// ====== INSTANCE MODAL BOOTSTRAP ======
let modalAdd, modalEdit;

document.addEventListener("DOMContentLoaded", () => {
  modalAdd = new bootstrap.Modal(document.getElementById("modalAddMenu"));
  modalEdit = new bootstrap.Modal(document.getElementById("modalEditMenu"));

  loadCategories();
  loadMenu();
});

// ====== LOAD CATEGORIES ======
async function loadCategories() {
  try {
    const res = await fetch("/nusarasa/backend/menu/categories.php");
    const data = await res.json();

    const addSelect = document.getElementById("addCategory");
    const editSelect = document.getElementById("editCategory");

    addSelect.innerHTML = "";
    editSelect.innerHTML = "";

    data.forEach(cat => {
      addSelect.innerHTML += `<option value="${cat.category_id}">${cat.category_name}</option>`;
      editSelect.innerHTML += `<option value="${cat.category_id}">${cat.category_name}</option>`;
    });

  } catch (err) {
    console.error("Gagal load kategori:", err);
  }
}

// ====== LOAD MENU LIST ======
async function loadMenu() {
  try {
    const res = await fetch("/nusarasa/backend/menu/get_menu.php");
    const json = await res.json();

    const data = json.data || [];
    const body = document.getElementById("menuBody");
    body.innerHTML = "";

    if (!data.length) {
      body.innerHTML = `
        <tr>
          <td colspan="6" style="text-align:center; padding:20px;">
            Belum ada menu terdaftar.
          </td>
        </tr>`;
      return;
    }

    data.forEach(item => {
      body.innerHTML += `
        <tr>
          <td><img src="/nusarasa/backend/uploads/menu/${item.image}" style="height:55px; border-radius:6px;"></td>
          <td>${item.name}</td>
          <td>${item.category_name}</td>
          <td>Rp ${Number(item.price).toLocaleString()}</td>
          <td>
            <span class="status ${item.status}">
              ${item.status === "available" ? "Tersedia" : "Tidak Tersedia"}
            </span>
          </td>
          <td>
            <button class="btn-table edit" onclick="openEditMenu(${item.menu_id})">Edit</button>
            <button class="btn-table delete" onclick="deleteMenu(${item.menu_id})">Hapus</button>
          </td>
        </tr>
      `;
    });

  } catch (err) {
    console.error("Gagal load menu:", err);
  }
}

// ====== OPEN ADD MENU ======
document.getElementById("btnAddMenu").onclick = () => {
  modalAdd.show();
};

// ====== CLOSE ADD MENU ======
function closeAddMenu() {
  modalAdd.hide();
  document.getElementById("formAddMenu").reset();
}

// ====== SUBMIT FORM TAMBAH MENU ======
document.getElementById("formAddMenu").addEventListener("submit", async (e) => {
  e.preventDefault();

  const formData = new FormData(e.target);

  const res = await fetch("/nusarasa/backend/menu/add_menu.php", {
    method: "POST",
    body: formData
  });

  const result = await res.json();

  if (result.success) {
    alert("Menu berhasil ditambahkan!");
    closeAddMenu();
    loadMenu();
  } else {
    alert("Gagal menambahkan menu: " + result.message);
  }
});

// ====== OPEN EDIT MENU ======
async function openEditMenu(id) {
  try {
    const res = await fetch("/nusarasa/backend/menu/get_menu.php?id=" + id);
    const json = await res.json();
    const data = json.data;

    document.getElementById("editMenuId").value = data.menu_id;
    document.getElementById("editName").value = data.name;
    document.getElementById("editPrice").value = data.price;
    document.getElementById("editDesc").value = data.description;
    document.getElementById("editStatus").value = data.status;

    await loadCategories();

    setTimeout(() => {
      document.getElementById("editCategory").value = data.category_id;
    }, 150);

    modalEdit.show();

  } catch (err) {
    console.error("Gagal load detail menu:", err);
  }
}

// ====== CLOSE EDIT MENU ======
function closeEditMenu() {
  modalEdit.hide();
}

// ====== SUBMIT EDIT MENU ======
document.getElementById("formEditMenu").addEventListener("submit", async (e) => {
  e.preventDefault();

  const formData = new FormData(e.target);

  const res = await fetch("/nusarasa/backend/menu/update_menu.php", {
    method: "POST",
    body: formData
  });

  const result = await res.json();

  if (result.success) {
    alert("Perubahan menu berhasil disimpan!");
    closeEditMenu();
    loadMenu();
  } else {
    alert("Gagal update menu: " + result.message);
  }
});

// ====== DELETE MENU ======
async function deleteMenu(id) {
  if (!confirm("Hapus menu ini?")) return;

  const form = new FormData();
  form.append("menu_id", id);

  const res = await fetch("/nusarasa/backend/menu/delete_menu.php", {
    method: "POST",
    body: form
  });

  const result = await res.json();

  if (result.success) {
    alert("Menu dihapus.");
    loadMenu();
  } else {
    alert("Gagal menghapus menu.");
  }
}
