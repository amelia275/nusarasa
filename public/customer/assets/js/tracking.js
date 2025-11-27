// ambil semua order
async function getAllOrders() {
  const res = await fetch("/nusarasa/backend/orders/get_all_orders.php");
  const j = await res.json();
  if (!j.ok) return [];
  return j.data;
}

// mapping status agar lebih enak dibaca user
const statusMap = {
  in_kitchen: "Sedang Diproses",
  out_for_delivery: "Dalam Perjalanan",
  delivered: "Selesai",
};

// buat badge warna
function statusBadge(status) {
  if (status === "delivered") return `<span class="badge bg-success">${statusMap[status]}</span>`;
  if (status === "out_for_delivery") return `<span class="badge bg-primary">${statusMap[status]}</span>`;
  return `<span class="badge bg-warning text-dark">${statusMap[status] || status}</span>`;
}

// render card order
function renderOrderCard(o) {
  const tr = o.tracking;
  const payment = o.payment;

  return `
    <div class="col-md-6 mx-auto">
      <div class="card border-0 shadow-sm mb-3">

        <div class="card-header bg-danger text-white d-flex justify-content-between align-items-center">
          <strong>${o.order_number}</strong>
          <span class="small">Meja: ${o.table_number}</span>
        </div>

        <div class="card-body">

          <p><strong>Status:</strong>  
            ${tr ? statusBadge(tr.status) : `<span class="badge bg-secondary">Belum Ada</span>`}
          </p>

          ${
            tr && tr.note
              ? `<p class="text-muted mb-1"><em>Catatan: ${tr.note}</em></p>`
              : ""
          }

          <p class="small text-muted mb-2">
            Update terakhir: ${tr ? tr.updated_at : "-"}
          </p>

          <p class="mb-1"><strong>Total:</strong> Rp ${parseInt(payment?.amount || 0).toLocaleString()}</p>
          <p class="small">Pembayaran: 
            ${
              payment?.status === "paid"
                ? `<span class="badge bg-success">Lunas</span>`
                : `<span class="badge bg-secondary">Pending</span>`
            }
          </p>

        </div>
      </div>
    </div>
  `;
}

// init saat halaman dibuka
document.addEventListener("DOMContentLoaded", async () => {
  const container = document.getElementById("trackingContainer");
  const noText = document.getElementById("noOrdersText");

  const orders = await getAllOrders();

  if (!orders || orders.length === 0) {
    noText.style.display = "block";
    return;
  }

  noText.style.display = "none";

  container.innerHTML = orders.map(renderOrderCard).join("");
});
