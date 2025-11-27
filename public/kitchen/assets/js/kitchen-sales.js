// =======================
// CONFIG
// =======================
const API = '/nusarasa/backend/reports';

// =======================
// PREFILL TODAY RANGE
// =======================
function setDefaultDates() {
  const today = new Date().toISOString().split('T')[0];
  const from = document.getElementById('fromDate');
  const to = document.getElementById('toDate');

  from.value = today;
  to.value = today;
}

// =======================
// FETCH SALES DATA
// =======================
async function fetchSales(from, to) {
  try {
    const params = new URLSearchParams();
    if (from) params.set('from', from);
    if (to) params.set('to', to);

    const res = await fetch(`${API}/get_sales.php?` + params.toString());
    return await res.json();

  } catch (err) {
    console.error('Gagal memuat data penjualan:', err);
    return { ok: false, data: [] };
  }
}

// =======================
// RENDER SALES LIST
// =======================
function renderSales(data) {
  const list = document.getElementById('salesList');
  const no = document.getElementById('noSales');

  list.innerHTML = '';

  if (!data.ok || !data.data.length) {
    no.style.display = 'block';
    return;
  }
  no.style.display = 'none';

  data.data.forEach(s => {
    const el = document.createElement('div');
    el.className = 'card p-3 mb-2';
    el.innerHTML = `
      <div class="d-flex justify-content-between">
        <div>
          <strong>${s.order_number}</strong>
          <br><small>${s.payment_date || '-'}</small>
        </div>
        <div class="fw-bold">Rp ${Number(s.amount).toLocaleString()}</div>
      </div>
    `;
    list.appendChild(el);
  });
}

// =======================
// FILTER BUTTON CLICK
// =======================
async function handleFilter() {
  const from = document.getElementById('fromDate').value;
  const to = document.getElementById('toDate').value;

  // Validasi range tanggal
  if (from && to && from > to) {
    alert('Tanggal awal tidak boleh lebih besar dari tanggal akhir.');
    return;
  }

  const result = await fetchSales(from, to);
  renderSales(result);
}

// =======================
// LOGOUT
// =======================
function setupLogout() {
  const lb = document.getElementById('logoutBtn');
  if (!lb) return;
  lb.addEventListener('click', () => {
    localStorage.removeItem('kitchen_token');
    location.href = 'kitchen-login.html';
  });
}

// =======================
// INIT
// =======================
document.addEventListener('DOMContentLoaded', async () => {
  setupLogout();
  setDefaultDates();

  // Auto-load sales hari ini
  const today = document.getElementById('fromDate').value;
  const data = await fetchSales(today, today);
  renderSales(data);

  // Event filter
  document.getElementById('filterSales').addEventListener('click', handleFilter);
});
