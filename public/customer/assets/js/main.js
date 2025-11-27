// main.js - uses server-side cart
// NOTE: ensure api-client.js is loaded BEFORE this file
async function fetchCart(){
  const res = await fetch('/nusarasa/backend/cart/get.php', { credentials: 'same-origin' });
  const j = await res.json();
  return (j && j.ok) ? j.data : [];
}

async function addToCart(menu_id, qty = 1, note = ''){
  const form = new FormData();
  form.append('menu_id', menu_id);
  form.append('quantity', qty);
  form.append('note', note);
  const res = await fetch('/nusarasa/backend/cart/add.php', { method:'POST', body: form, credentials:'same-origin' });
  const j = await res.json();
  if (j.ok) showToast('Ditambahkan ke cart');
  await updateCartBadges();
  await renderOrderSummary();
}

async function removeFromCart(cart_id){
  const form = new FormData();
  form.append('cart_id', cart_id);
  const res = await fetch('/nusarasa/backend/cart/remove.php', { method:'POST', body: form, credentials:'same-origin' });
  const j = await res.json();
  if (j.ok) showToast('Item dihapus');
  await updateCartBadges();
  await renderOrderSummary();
}

async function setQty(cart_id, qty){
  const form = new FormData();
  form.append('cart_id', cart_id);
  form.append('quantity', qty);
  const res = await fetch('/nusarasa/backend/cart/update.php', { method:'POST', body: form, credentials:'same-origin' });
  const j = await res.json();
  if (j.ok) await renderOrderSummary();
}

async function setNote(cart_id, note){
  const form = new FormData();
  form.append('cart_id', cart_id);
  form.append('note', note);
  await fetch('/nusarasa/backend/cart/update.php', { method:'POST', body: form, credentials:'same-origin' });
}

async function clearCart(){
  // no direct endpoint; can delete all cart rows for session by removing one-by-one or create an endpoint.
  // for now just call create_order which clears on success; otherwise user can remove items manually.
  showToast('Gunakan tombol checkout untuk menyelesaikan pesanan.');
}

async function updateCartBadges(){
  const cart = await fetchCart();
  const total = cart.reduce((s,i)=>s + Number(i.quantity), 0);
  const badges = ['cartCountBadge','cartCountBadge2','cartCountBadge3','cartCountBadge4','cartCountBadge5'];
  badges.forEach(id => { const el = document.getElementById(id); if (el) el.textContent = total; });
}

function showToast(msg){
  const t = document.createElement('div');
  t.className = 'toast align-items-center show position-fixed bottom-0 end-0 m-3';
  t.innerHTML = `<div class="d-flex"><div class="toast-body">${msg}</div><button class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>`;
  document.body.appendChild(t);
  setTimeout(()=>t.remove(),2200);
}

// render home preview by fetching menu from server
async function renderHomeMenu(){
  const grid = document.getElementById('homeMenuGrid');
  if (!grid) return;
  grid.innerHTML = '';
  const res = await fetch('/nusarasa/backend/menu/get_menu.php');
  const j = await res.json();
  if (!j.ok) return;
  (j.data.slice(0,4)).forEach(item => {
    const col = document.createElement('div');
    col.className = 'col-md-3';
    col.innerHTML = `
      <div class="card menu-card p-2">
        <img src="http://localhost/nusarasa/backend/uploads/menu/${item.image}" class="menu-item-img w-100" alt="${item.name}"/>
        <div class="p-2">
          <h6 class="mb-1">${item.name}</h6>
          <div class="d-flex justify-content-between align-items-center">
            <div class="price-tag">Rp ${Number(item.price).toLocaleString()}</div>
            <button class="btn btn-outline-danger btn-sm me-2" onclick="addToCart(${item.menu_id})">Add</button>
          </div>
        </div>
      </div>`;
    grid.appendChild(col);
  });
}

// render menu grid (menu.html)
async function renderMenuGrid(){
  const grid = document.getElementById('menuGrid');
  if (!grid) return;
  grid.innerHTML = '';
  const filter = document.getElementById('categoryFilter');
  const cat = filter ? filter.value : 'all';
  const res = await fetch('/nusarasa/backend/menu/get_menu.php');
  const j = await res.json();
  if (!j.ok) return;
  const items = j.data.filter(i => cat === 'all' ? true : (i.category_name === cat));
  items.forEach(item => {
    const col = document.createElement('div');
    col.className = 'col-md-4';
    col.innerHTML = `
      <div class="card menu-card h-100 p-3">
        <img src="http://localhost/nusarasa/backend/uploads/menu/${item.image}" class="menu-item-img mb-3" alt="${item.name}"/>
        <div>
          <h5>${item.name}</h5>
          <p class="text-muted small">${item.description || ''}</p>
        </div>
        <div class="mt-auto d-flex justify-content-between align-items-center">
          <div class="price-tag">Rp ${Number(item.price).toLocaleString()}</div>
          <button class="btn btn-outline-danger btn-sm me-2" onclick="addToCart(${item.menu_id})">Add</button>
        </div>
      </div>`;
    grid.appendChild(col);
  });
}

// populate category filter from server categories endpoint
async function setupCategories(){
  const sel = document.getElementById('categoryFilter');
  if (!sel) return;
  const res = await fetch('/nusarasa/backend/menu/categories.php');
  const cats = await res.json();
  if (!Array.isArray(cats)) return;
  // cats expected as [{category_id, category_name}, ...]
  cats.forEach(c => {
    const opt = document.createElement('option');
    opt.value = c.category_name;
    opt.textContent = c.category_name;
    sel.appendChild(opt);
  });
  sel.addEventListener('change', renderMenuGrid);
}

// render order summary uses server cart
async function renderOrderSummary(){
  const wrap = document.getElementById('orderSummary');
  const totalEl = document.getElementById('orderTotal');
  if (!wrap) return;
  const cart = await fetchCart();
  if (!cart.length) {
    wrap.innerHTML = '<p class="text-muted">Cart is empty.</p>';
    if (totalEl) totalEl.textContent = 'Rp0';
    return;
  }
  wrap.innerHTML = '';
  let total = 0;
  cart.forEach(c => {
    const line = document.createElement('div');
    line.className = 'border-bottom pb-2 mb-3';
    line.innerHTML = `
      <div class="d-flex justify-content-between align-items-center">
        <div class="flex-grow-1">
          <strong>${c.name}</strong>
          <div class="small text-muted">Rp ${Number(c.price).toLocaleString()} × ${c.quantity}</div>
        </div>
        <div class="mx-3">
          <input type="number" min="1" value="${c.quantity}" style="width:68px" onchange="setQty(${c.cart_id}, this.value)">
        </div>
        <button class="btn btn-sm btn-outline-danger" onclick="removeFromCart(${c.cart_id})">Remove</button>
      </div>
      <div class="mt-2">
        <label class="form-label small">Catatan tambahan:</label>
        <textarea class="form-control form-control-sm" rows="1" placeholder="Contoh: tanpa sambal"
          oninput="setNote(${c.cart_id}, this.value)">${c.note || ''}</textarea>
      </div>`;
    wrap.appendChild(line);
    total += Number(c.price) * Number(c.quantity);
  });
  if (totalEl) totalEl.textContent = 'Rp ' + total.toLocaleString();
}

// init
document.addEventListener('DOMContentLoaded', () => {
  updateCartBadges();
  renderHomeMenu();
  renderMenuGrid();
  setupCategories();
  renderOrderSummary();

  // init splide if present
  if (typeof Splide !== 'undefined') {
    try {
      new Splide('#chefCarousel', {
        type: 'loop', perPage: 3, focus: 'center', autoplay: true,
        interval: 2500, pauseOnHover: false, pagination: false,
        arrows: true, speed: 800, gap: '2rem',
        breakpoints: {992:{perPage:1,gap:'1rem'},1200:{perPage:2}}
      }).mount();
    } catch(e){}
  }
});
