document.addEventListener("DOMContentLoaded", () => {
  const params = new URLSearchParams(window.location.search);
  const method = params.get("method");
  const total = params.get("total") || 0;
  const orderId = params.get("order_id");

  // Tampilkan section sesuai metode
  if (method === "qris") {
    document.getElementById("qrisSection").style.display = "block";
    document.getElementById("paymentTitle").innerText = "Pembayaran via QRIS";
    document.getElementById("paymentTotalQris").innerText =
      "Rp " + Number(total).toLocaleString();
  } else {
    document.getElementById("cashSection").style.display = "block";
    document.getElementById("paymentTitle").innerText = "Pembayaran Tunai";
    document.getElementById("paymentTotalcash").innerText =
      "Rp " + Number(total).toLocaleString();
  }

  // Validasi wajib
  if (!orderId) {
    Swal.fire({
      icon: "error",
      title: "Order ID tidak ditemukan",
      text: "Pembayaran tidak dapat diproses."
    }).then(() => window.location.href = "index.html");
    return;
  }

  // ---------------------------
  // 🔴 KIRIM DATA PEMBAYARAN KE BACKEND
  // ---------------------------
  document.getElementById("doneBtn").addEventListener("click", async () => {
    const res = await fetch(
      "/nusarasa/backend/payments/create_payment.php",
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          order_id: orderId,
          amount: total,
          payment_method: method,
        }),
      }
    );

    const data = await res.json();

    if (data.ok) {
    Swal.fire({
      title: "Pembayaran Berhasil!",
      text: "Terima kasih, pesanan Anda sedang diproses.",
      icon: "success",
      showCancelButton: true,
      confirmButtonText: "Lihat Struk",
      cancelButtonText: "Kembali ke Home",
      confirmButtonColor: "#b83b24",
    }).then((result) => {
      if (result.isConfirmed) {
        window.location.href = "payment_receipt.php?id=" + data.payment_id;
      } else {
        window.location.href = "/nusarasa/public/customer/pages/index.html";
      }
    });
  } else {
      Swal.fire({
        title: "Gagal!",
        text: data.msg || "Terjadi kesalahan saat memproses pembayaran.",
        icon: "error",
      });
    }
  });
});
