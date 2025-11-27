// sesuaikan API_BASE jika project tidak di root /nusarasa
const API_BASE = '/nusarasa/backend'; // <--- ganti kalau path berbeda (contoh: '/ProjectWeb/backend')

async function apiGet(path){
  const res = await fetch(API_BASE + path, { credentials: 'same-origin' });
  return res.json();
}
async function apiPost(path, data){
  const res = await fetch(API_BASE + path, {
    method: 'POST',
    headers: {'Content-Type':'application/json'},
    credentials: 'same-origin',
    body: JSON.stringify(data)
  });
  return res.json();
}
