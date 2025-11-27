const API_BASE = '/nusarasa/backend/reports';
async function apiGet(path) {
  const res = await fetch(API_BASE + '/' + path);
  return res.json();
}
async function apiPost(path, body) {
  const res = await fetch(API_BASE + '/' + path, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(body) });
  return res.json();
}

document.addEventListener('DOMContentLoaded', async () => {
  // logout link
  const lb = document.getElementById('logoutBtn');
  if (lb) lb.addEventListener('click', () => { localStorage.removeItem('kitchen_token'); location.href='kitchen-login.html'; });

  // if on dashboard page -> load stats
  if (document.getElementById('todaySales')) {
    const j = await apiGet('get_stats.php');
    if (j.ok) {
      document.getElementById('todaySales').innerText = 'Rp ' + (Number(j.today_sales || 0)).toLocaleString();
      const top = document.getElementById('topMenu');
      top.innerHTML = j.top_menu.map(t => `<li>${t.name} — ${t.sold}</li>`).join('');
      const low = document.getElementById('lowStock');
      low.innerHTML = j.low_stock.map(l => `<li>${l.item_name} — ${l.quantity}</li>`).join('');
      const ro = document.getElementById('recentOrders');
      ro.innerHTML = j.recent_orders.map(r => `<div class="card p-2 mb-2">${r.order_number} — ${r.status}<br><small>${r.created_at}</small></div>`).join('');
    }
  }
});
