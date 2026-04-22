// Moffat Bay reservation page JS.
// Phone auto-format, price preview, client-side validation.
// Form posts to CreateReservationServlet — server handles persistence and confirmation.

document.addEventListener('DOMContentLoaded', function () {
    var phone = document.getElementById('custPhone');
    if (phone) {
        phone.addEventListener('input', function (e) {
            var x = e.target.value.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
            e.target.value = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
        });
    }

    var form = document.getElementById('bookingForm');
    if (form) {
        form.addEventListener('submit', function (e) {
            if (!validateBooking()) {
                e.preventDefault();
            }
            // If valid: let the browser submit to CreateReservationServlet naturally.
        });
    }

    var today = new Date().toISOString().split('T')[0];
    var ci = document.getElementById('checkIn');
    var co = document.getElementById('checkOut');
    if (ci && !ci.value) {
        ci.value = today;
        ci.setAttribute('min', today);
    }
    if (co && !co.value) {
        var t = new Date();
        t.setDate(t.getDate() + 2);
        co.value = t.toISOString().split('T')[0];
        co.setAttribute('min', today);
    }

    updatePriceDisplay();
});

function updatePriceDisplay() {
    var select = document.getElementById('roomType');
    if (!select) return;
    var pricePerNight = parseFloat(select.options[select.selectedIndex].dataset.price);
    var isLocal = document.getElementById('isLocal') && document.getElementById('isLocal').checked;

    // Match the server calc: nightly rate × nights, then × 0.85 if local discount.
    var checkIn = document.getElementById('checkIn').value;
    var checkOut = document.getElementById('checkOut').value;
    var nights = 1;
    if (checkIn && checkOut) {
        var ms = new Date(checkOut) - new Date(checkIn);
        var diff = Math.round(ms / (1000 * 60 * 60 * 24));
        if (diff > 0) nights = diff;
    }

    var total = pricePerNight * nights;
    if (isLocal) total = total * 0.85;

    var el = document.getElementById('priceDisplay');
    if (el) {
        el.innerText = '$' + total.toFixed(2) + ' total (' + nights + ' night' + (nights === 1 ? '' : 's') + ')';
    }
}

function validateBooking() {
    var isValid = true;
    var checkIn = document.getElementById('checkIn').value;
    var checkOut = document.getElementById('checkOut').value;
    var adults = parseInt(document.getElementById('adults').value || '0', 10);
    var name = document.getElementById('custName').value.trim();
    var email = document.getElementById('custEmail').value.trim();
    var phone = document.getElementById('custPhone').value.trim();

    document.querySelectorAll('.error-text').forEach(function (e) { e.style.display = 'none'; });

    if (!checkIn) { show('err-checkIn'); isValid = false; }
    if (!checkOut || new Date(checkOut) <= new Date(checkIn)) { show('err-checkOut'); isValid = false; }
    if (adults < 1) { show('err-guests'); isValid = false; }
    if (!name) { show('err-custName'); isValid = false; }
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email || !emailRegex.test(email)) { show('err-custEmail'); isValid = false; }
    var phoneRegex = /^\(\d{3}\) \d{3}-\d{4}$/;
    if (!phone || !phoneRegex.test(phone)) { show('err-custPhone'); isValid = false; }
    return isValid;
}

function show(id) {
    var el = document.getElementById(id);
    if (el) el.style.display = 'block';
}
