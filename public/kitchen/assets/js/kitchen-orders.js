const API = '/nusarasa/backend';

async function fetchOrders(status){
  const res = await fetch(
    API + '/orders/get_all_orders.php?status=' + encodeURIComponent(status)
  );
  return res.json();
}

async function postUpdateStatus(orderNumber, status){
  const res = await fetch(API + '/orders/update_status.php', {
    method:'POST',
    headers:{'Content-Type':'application/json'},
    body: JSON.stringify({order_number: orderNumber, status})
  });
  return res.json();
}

async function fetchAndRender(status){
  const cont = document.getElementById('ordersContainer');
  const j = await fetchOrders(status);
  cont.innerHTML = '';
  if (!j.ok || !j.data.length) {
    document.getElementById('noOrders').style.display = 'block';
    return;
  }
  document.getElementById('noOrders').style.display = 'none';
  j.data.forEach(o => {
    const card = document.createElement('div');
    card.className = 'col-md-6';
    // parse items
    const items = o.items || [];

    const btnHtml = (status === 'Pending') ? `<button class="btn btn-warning btn-sm" data-order="${o.order_number}">Proses</button>` :
                    (status === 'Diproses') ? `<button class="btn btn-success btn-sm" data-order="${o.order_number}">Selesai</button>` :
                    `<button class="btn btn-outline-danger btn-sm" data-order="${o.order_number}">Hapus</button>`;
    card.innerHTML = `<div class="card p-2">
      <div class="d-flex justify-content-between"><strong>${o.order_number}</strong><span>Meja ${o.table_number}</span></div>
      <div class="mt-2">
        ${items.map(i => `
          <div class="mb-1">
            ${i.name} × ${i.quantity}
            ${i.note ? `<div class="text-muted small">Catatan: ${i.note}</div>` : ""}
          </div>
        `).join('')}
      </div>
      <div class="mt-2 text-end">${btnHtml}</div>
    </div>`;
    cont.appendChild(card);
  });

  // delegate click
  cont.querySelectorAll('button').forEach(btn => {
    btn.addEventListener('click', async (e) => {
      const order = btn.dataset.order;
      if (status === 'Pending') {
        await postUpdateStatus(order, 'Diproses');
        fetchAllTabs();
      } else if (status === 'Diproses') {
        await postUpdateStatus(order, 'Selesai');
        fetchAllTabs();
      } else {
        Swal.fire({
          title: "Hapus Pesanan?",
          text: "Data pesanan akan dihapus permanen.",
          icon: "warning",
          showCancelButton: true,
          confirmButtonColor: "#d33",
          cancelButtonColor: "#3085d6",
          confirmButtonText: "Ya, hapus!",
          cancelButtonText: "Batal"
        }).then(async (result) => {
          if (result.isConfirmed) {

            const res = await fetch(API + '/orders/delete_order.php', {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ order_number: order })
            });

            const j = await res.json();

            if (j.ok) {
              Swal.fire({
                title: "Terhapus!",
                text: "Pesanan berhasil dihapus.",
                icon: "success",
                timer: 1500,
                showConfirmButton: false
              });

              fetchAllTabs();
            } else {
              Swal.fire("Gagal!", j.msg || "Tidak bisa menghapus pesanan.", "error");
            }
          }
        });
      }

    });
  });
}

async function fetchAllTabs(){
  const tabs = document.querySelectorAll('#ordersTab .nav-link');
  tabs.forEach(t => {
    const s = t.dataset.status;
    if (t.classList.contains('active')) fetchAndRender(s);
  });
}

document.addEventListener('DOMContentLoaded', () => {
  // initial render for active tab
  document.querySelectorAll('#ordersTab .nav-link').forEach(tab => {
    tab.addEventListener('click', (e) => {
      e.preventDefault();
      document.querySelectorAll('#ordersTab .nav-link').forEach(t=>t.classList.remove('active'));
      tab.classList.add('active');
      fetchAndRender(tab.dataset.status);
    });
  });
  // trigger initial
  const active = document.querySelector('#ordersTab .nav-link.active');
  if (active) fetchAndRender(active.dataset.status);
});
