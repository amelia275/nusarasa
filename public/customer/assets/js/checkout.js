document.addEventListener("DOMContentLoaded", () => {
  const checkoutForm = document.getElementById("checkoutForm");
  const orderNumberField = document.getElementById("orderNumber");

  if (orderNumberField) {
  fetch("/nusarasa/backend/orders/get_next_order_number.php")
    .then(res => res.json())
    .then(j => {
      if (j.ok) {
        orderNumberField.value = j.order_number;
        window.generatedOrderNumber = j.order_number; // simpan
      }
    });
}

  if (!checkoutForm) return;

  checkoutForm.addEventListener("submit", async function (e) {
    e.preventDefault();

    const tableNumber = Number(document.getElementById("tableNumber").value || 0);
    const paymentMethod = document.getElementById("paymentMethod").value || "cash";

    const body = {
      table_number: tableNumber,
      payment_method: paymentMethod,
      order_number: window.generatedOrderNumber
    };

    const res = await fetch("/nusarasa/backend/orders/create_order.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      credentials: "same-origin",
      body: JSON.stringify(body)
    });

    const j = await res.json();

    if (j.ok) {
      const orderNo = j.data.order_number;
      const total = j.data.total;
      const oid = j.data.order_id;

      // tampilkan orderNumber
      if (orderNumberField) orderNumberField.value = orderNo;

      if (paymentMethod === "qris") {
        // redirect ke halaman QRIS
        window.location.href = `payment.html?method=${paymentMethod}&order=${orderNo}&total=${total}`;
      } else {
        // pembayaran tunai
        Swal.fire({
          icon: "success",
          title: "Pesanan Diterima!",
          text: "Silakan bayar tunai di kasir."
        }).then(() => window.location.href = "index.html");
      }

    } else {
      Swal.fire({
        icon: "error",
        title: "Error",
        text: j.msg || "Gagal membuat pesanan"
      });
    }
  });
});
