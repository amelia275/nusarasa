const API_INV = '/nusarasa/backend/stock/get_inventory.php';
const API_UPDATE = '/nusarasa/backend/stock/update_stock.php';

async function loadStock(){
  const res = await fetch(API_INV);
  const j = await res.json();
  const cont = document.getElementById('stockList');
  cont.innerHTML = '';
  if (!j.ok || j.data.length === 0) { document.getElementById('noStock').style.display='block'; return; }
  document.getElementById('noStock').style.display='none';
  j.data.forEach(it => {
    const col = document.createElement('div');
    col.className = 'col-md-4';
    col.innerHTML = `<div class="card p-2">
      <div><strong>${it.item_name}</strong></div>
      <div>Qty: <span class="stock-qty">${it.quantity}</span> ${it.unit_purchase}</div>
      <div class="mt-2">
        <input type="number" class="form-control form-control-sm change-amt" placeholder="Jumlah (+/-)">
        <input type="text" class="form-control form-control-sm mt-1 reason" placeholder="Alasan (optional)">
        <div class="mt-2 text-end"><button class="btn btn-pepper btn-sm apply" data-id="${it.inventory_id}">Update</button></div>
      </div>
    </div>`;
    cont.appendChild(col);
  });
  // attach
  document.querySelectorAll('.apply').forEach(b=>{
    b.addEventListener('click', async () => {
      const id = b.dataset.id;
      const parent = b.closest('.card');
      const amt = Number(parent.querySelector('.change-amt').value || 0);
      const reason = parent.querySelector('.reason').value || 'manual';
      if (amt === 0) { alert('Isi jumlah (+/-)'); return; }
      const res = await fetch(API_UPDATE, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({inventory_id:id, change:amt, reason})});
      const j = await res.json();
      if (j.ok) {
        parent.querySelector('.stock-qty').innerText = Number(parent.querySelector('.stock-qty').innerText) + amt;
        parent.querySelector('.change-amt').value = '';
        parent.querySelector('.reason').value = '';
      } else alert('Gagal');
    });
  });
}

document.addEventListener('DOMContentLoaded', loadStock);
