<?php
// autosync.php - improved
// function autosync_reduce_stock_by_order_number(PDO $pdo, string $order_number): bool

function autosync_reduce_stock_by_order_number($pdo, $order_number) {
    // 1. find order id
    $s = $pdo->prepare("SELECT order_id FROM orders WHERE order_number = :on LIMIT 1");
    $s->execute([':on' => $order_number]);
    $o = $s->fetch(PDO::FETCH_ASSOC);
    if (!$o) return false;
    $order_id = (int)$o['order_id'];

    // 1.5 idempotency: check stock_logs for this order already
    $check = $pdo->prepare("SELECT COUNT(*) AS cnt FROM stock_logs WHERE reason = :reason");
    $reasonText = "Auto-reduce for order {$order_number}";
    $check->execute([':reason' => $reasonText]);
    $cnt = (int)$check->fetchColumn();
    if ($cnt > 0) {
        // already reduced
        return true;
    }

    // 2. get items
    $si = $pdo->prepare("SELECT menu_id, quantity FROM order_items WHERE order_id = :oid");
    $si->execute([':oid' => $order_id]);
    $items = $si->fetchAll(PDO::FETCH_ASSOC);
    if (!$items) {
        // nothing to reduce
        return true;
    }

    // prepared statements we will reuse
    $sr = $pdo->prepare("SELECT inventory_id, amount, unit FROM menu_recipes WHERE menu_id = :mid");
    $getInv = $pdo->prepare("SELECT inventory_id, quantity, unit_purchase, ml_per_pcs, gram_per_pcs, pieces_per_pcs FROM inventory WHERE inventory_id = :iid LIMIT 1");
    $updateInv = $pdo->prepare("UPDATE inventory SET quantity = GREATEST(quantity - :c, 0) WHERE inventory_id = :iid");
    $insertLog = $pdo->prepare("INSERT INTO stock_logs (inventory_id, change_amount, reason) VALUES (:iid, :chg, :reason)");

    try {
        $pdo->beginTransaction();

        foreach ($items as $it) {
            $menu_id = (int)$it['menu_id'];
            $qty = (int)$it['quantity'];
            if ($menu_id <= 0 || $qty <= 0) continue;

            // recipes for this menu
            $sr->execute([':mid' => $menu_id]);
            $recipes = $sr->fetchAll(PDO::FETCH_ASSOC);

            foreach ($recipes as $r) {
                $inventory_id = (int)$r['inventory_id'];
                $amount_per_portion = floatval($r['amount']); // in recipe unit
                $recipe_unit = $r['unit']; // 'gram'|'ml'|'pcs'

                // load inventory details
                $getInv->execute([':iid' => $inventory_id]);
                $inv = $getInv->fetch(PDO::FETCH_ASSOC);
                if (!$inv) {
                    // inventory item not found -> log and skip
                    error_log("autosync: inventory_id {$inventory_id} not found for menu {$menu_id}");
                    continue;
                }

                $inv_unit = $inv['unit_purchase']; // 'kg' or 'pcs'
                $ml_per_pcs = $inv['ml_per_pcs'] ? floatval($inv['ml_per_pcs']) : null;
                $gram_per_pcs = $inv['gram_per_pcs'] ? floatval($inv['gram_per_pcs']) : null;
                $pieces_per_pcs = $inv['pieces_per_pcs'] ? floatval($inv['pieces_per_pcs']) : null;

                // total amount needed (in recipe unit)
                $total_needed = $amount_per_portion * $qty;

                // convert total_needed to inventory's unit (we need numeric 'consume')
                $consume = null; // number in inventory.quantity units
                $conversion_ok = true;

                if ($recipe_unit === 'gram') {
                    if ($inv_unit === 'kg') {
                        // convert grams -> kg
                        $consume = $total_needed / 1000.0; // inventory stored in kg
                    } elseif ($inv_unit === 'pcs') {
                        // convert grams -> pcs using gram_per_pcs if available
                        if ($gram_per_pcs && $gram_per_pcs > 0) {
                            $consume = ceil($total_needed / $gram_per_pcs); // pieces needed
                        } else {
                            $conversion_ok = false;
                        }
                    } else {
                        // assume same unit (unlikely)
                        $consume = $total_needed;
                    }
                } elseif ($recipe_unit === 'ml') {
                    if ($inv_unit === 'pcs') {
                        if ($ml_per_pcs && $ml_per_pcs > 0) {
                            $consume = ceil($total_needed / $ml_per_pcs);
                        } else {
                            $conversion_ok = false;
                        }
                    } elseif ($inv_unit === 'kg') {
                        // cannot reliably convert ml to kg without density info
                        $conversion_ok = false;
                    } else {
                        $consume = $total_needed;
                    }
                } elseif ($recipe_unit === 'pcs') {
                    if ($inv_unit === 'pcs') {
                        $consume = $total_needed;
                    } elseif ($inv_unit === 'kg') {
                        // If menu recipe says pcs but inventory is kg, try using pieces_per_pcs or gram_per_pcs
                        if ($pieces_per_pcs && $pieces_per_pcs > 0) {
                            $consume = $total_needed / $pieces_per_pcs; // convert pieces to groups (rare)
                        } elseif ($gram_per_pcs && $gram_per_pcs > 0) {
                            // interpret 1 piece weight in grams -> convert to kg
                            $consume = ($total_needed * $gram_per_pcs) / 1000.0;
                        } else {
                            $conversion_ok = false;
                        }
                    } else {
                        $consume = $total_needed;
                    }
                } else {
                    // unknown recipe unit -> skip
                    $conversion_ok = false;
                }

                if (!$conversion_ok || $consume === null) {
                    error_log("autosync: cannot convert recipe_unit={$recipe_unit} to inventory unit {$inv_unit} for inventory_id {$inventory_id} (menu {$menu_id}). Skipping this ingredient.");
                    continue; // skip this ingredient to avoid wrong update
                }

                // For safety, ensure consume is numeric and non-negative
                $consume = floatval($consume);
                if ($consume <= 0) continue;

                // execute inventory update
                $updateInv->execute([':c' => $consume, ':iid' => $inventory_id]);

                // insert stock log (store negative change)
                $insertLog->execute([
                    ':iid' => $inventory_id,
                    ':chg' => -1 * $consume,
                    ':reason' => $reasonText
                ]);
            }
        }

        $pdo->commit();
        return true;
    } catch (Exception $e) {
        $pdo->rollBack();
        error_log("Auto sync failed for order {$order_number}: " . $e->getMessage());
        return false;
    }
}
