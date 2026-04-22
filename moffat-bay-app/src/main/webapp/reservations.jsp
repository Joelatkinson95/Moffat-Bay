<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="moffatbay.Reservation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="moffatbay.DatabaseConnection" %>
<%
    // Which section to show: "booking" (default), "summary", or "lookup".
    // Set by CreateReservationServlet / LookupReservationServlet.
    String view = (String) request.getAttribute("view");
    if (view == null) view = request.getParameter("view");
    if (view == null) view = "booking";

    // Prefill values from availability.jsp query string
    String qpRoom = request.getParameter("roomType");
    String qpCheckIn = request.getParameter("checkIn");
    String qpCheckOut = request.getParameter("checkOut");
    String qpGuests = request.getParameter("guests");

    Reservation res = (Reservation) request.getAttribute("reservation");
    @SuppressWarnings("unchecked")
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    @SuppressWarnings("unchecked")
    List<String> recentSearches = (List<String>) session.getAttribute("recentSearches");
    String bookingError = (String) request.getAttribute("bookingError");
    String lookupError = (String) request.getAttribute("lookupError");
    String lookupQuery = (String) request.getAttribute("lookupQuery");
    SimpleDateFormat dateFmt = new SimpleDateFormat("MMM d, yyyy");

    // Overlap-confirm state + preserved form values (set by CreateReservationServlet when same-user overlap detected)
    String overlapConfirm = (String) request.getAttribute("overlapConfirm");
    String formCheckIn   = (String) request.getAttribute("formCheckIn");
    String formCheckOut  = (String) request.getAttribute("formCheckOut");
    String formRoomType  = (String) request.getAttribute("formRoomType");
    String formAdults    = (String) request.getAttribute("formAdults");
    String formChildren  = (String) request.getAttribute("formChildren");
    String formCustName  = (String) request.getAttribute("formCustName");
    String formCustEmail = (String) request.getAttribute("formCustEmail");
    String formCustPhone = (String) request.getAttribute("formCustPhone");
    Boolean formIsLocal  = (Boolean) request.getAttribute("formIsLocal");

    // Auto-populate guest info for logged-in users (falls back to preserved form values on re-render)
    String prefillName = formCustName != null ? formCustName : "";
    String prefillEmail = formCustEmail != null ? formCustEmail : "";
    String prefillPhone = formCustPhone != null ? formCustPhone : "";
    Integer sessionUserId = (Integer) session.getAttribute("user_id");
    if (sessionUserId != null && formCustName == null) {
        String fn = (String) session.getAttribute("firstName");
        String ln = (String) session.getAttribute("lastName");
        if (fn != null || ln != null) {
            prefillName = ((fn == null ? "" : fn) + " " + (ln == null ? "" : ln)).trim();
        }
        Object semail = session.getAttribute("email");
        if (semail != null) prefillEmail = semail.toString();
        try (Connection c = DatabaseConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT user_phoneNumber FROM users WHERE user_id = ?")) {
            ps.setInt(1, sessionUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String p = rs.getString(1);
                    if (p != null) prefillPhone = p;
                }
            }
        } catch (Exception ignored) {}
    }

    // Effective values for each date/room/guest field (form re-render beats query string)
    String valCheckIn  = formCheckIn  != null ? formCheckIn  : (qpCheckIn  != null ? qpCheckIn  : "");
    String valCheckOut = formCheckOut != null ? formCheckOut : (qpCheckOut != null ? qpCheckOut : "");
    String valRoom     = formRoomType != null ? formRoomType : qpRoom;
    String valAdults   = formAdults   != null ? formAdults   : (qpGuests != null ? qpGuests : "2");
    String valChildren = formChildren != null ? formChildren : "0";
    boolean valIsLocal = formIsLocal != null && formIsLocal.booleanValue();

    // Pull the distinct room types + their price from the DB so the booking form's
    // dropdown always matches what CreateReservationServlet will actually find.
    java.util.List<String[]> roomOptions = new java.util.ArrayList<>();
    try (Connection c = DatabaseConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(
             "SELECT room_type, MIN(room_price) AS price FROM rooms GROUP BY room_type ORDER BY price")) {
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roomOptions.add(new String[] { rs.getString("room_type"), rs.getBigDecimal("price").toPlainString() });
            }
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay Resort - Reservations</title>

    <!-- Tailwind + icons to match the mockup -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Header / nav — mockup styling, auth-aware buttons from the existing app -->
<header class="bg-white header-border sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 md:px-10">
        <div class="flex justify-between h-20 md:h-24 items-center">
            <a href="index.jsp" class="flex items-center space-x-2 cursor-pointer">
                <div class="border-[1.5px] border-emerald-900 p-1 flex items-center bg-white">
                    <div class="flex flex-col items-center px-1 border-r border-emerald-900 pr-1.5 md:pr-2">
                        <span style="color:#1d5b3d" class="font-bold text-base md:text-xl leading-none">Moffat</span>
                        <span style="color:#1d5b3d" class="font-bold text-base md:text-xl leading-none">Bay</span>
                    </div>
                    <div class="pl-1.5 md:pl-2 flex flex-col items-center">
                        <i class="fas fa-monument text-slate-600 text-sm md:text-lg"></i>
                        <span class="text-[7px] md:text-[8px] font-bold text-slate-500 mt-1">LODGE</span>
                    </div>
                </div>
            </a>

            <nav class="hidden lg:flex space-x-6 xl:space-x-10 text-[11px] xl:text-sm font-bold uppercase">
                <a href="index.jsp" class="nav-link">HOME</a>
                <a href="reservations.jsp" class="nav-link">BOOK</a>
                <a href="LookupReservationServlet" class="nav-link" style="color:var(--moffat-navy)">LOOKUP</a>
            </nav>

            <div class="flex items-center space-x-3 md:space-x-6">
                <% if (session.getAttribute("firstName") != null) { %>
                    <span class="text-xs md:text-sm text-slate-600">
                        Welcome, <%= session.getAttribute("firstName") %>
                    </span>
                    <a href="LogoutServlet" class="login-link text-xs md:text-sm">Log Out</a>
                <% } else { %>
                    <a href="login.jsp" class="login-link text-xs md:text-sm">Log In</a>
                    <a href="signup.jsp" class="btn-signup">SIGN UP <i class="fas fa-arrow-right"></i></a>
                <% } %>
            </div>
        </div>
    </div>
</header>

<main class="max-w-6xl mx-auto py-6 md:py-12 px-4">

    <!-- SECTION: BOOKING FORM -->
    <section id="page-booking" class="page-content fade-in <%= "booking".equals(view) ? "" : "hidden" %>">
        <div class="flex items-center space-x-2 md:space-x-4 mb-8 md:mb-12">
            <div class="h-px bg-slate-200 flex-1"></div>
            <h2 class="text-[10px] md:text-sm font-bold text-slate-500 text-center uppercase tracking-widest px-2">
                Moffat Bay Resort Lodge, Joviedsa Island
            </h2>
            <div class="h-px bg-slate-200 flex-1"></div>
        </div>

        <% if (overlapConfirm != null) { %>
            <div class="max-w-3xl mx-auto mb-6 p-4 bg-amber-50 text-amber-900 text-sm rounded border border-amber-200 font-bold">
                <i class="fas fa-circle-question mr-2"></i><%= overlapConfirm %>
                <div class="mt-2 font-normal text-amber-800">
                    Your details below are pre-filled from your previous entry — click
                    <span class="font-bold">Confirm &amp; Book Anyway</span> to proceed, or
                    <a href="reservations.jsp?view=lookup" class="underline">go to Lookup</a> to view your existing reservation.
                </div>
            </div>
        <% } %>

        <% if (bookingError != null) { %>
            <div class="max-w-3xl mx-auto mb-6 p-4 bg-red-50 text-red-700 text-sm rounded border border-red-100 font-bold">
                <i class="fas fa-exclamation-triangle mr-2"></i><%= bookingError %>
            </div>
        <% } %>

        <% if (session.getAttribute("user_id") == null) { %>
            <div class="max-w-3xl mx-auto mb-6 p-4 bg-amber-50 text-amber-800 text-sm rounded border border-amber-200 font-bold">
                <i class="fas fa-info-circle mr-2"></i>
                Please <a href="login.jsp" class="underline">log in</a> or
                <a href="signup.jsp" class="underline">sign up</a> to complete a reservation.
            </div>
        <% } %>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 md:gap-10">
            <div class="lg:col-span-2">
                <div class="booking-card p-6 md:p-8 border-t-4 border-emerald-800">
                    <div class="mb-6 md:mb-8">
                        <h3 class="text-lg md:text-2xl font-black text-slate-800 italic uppercase tracking-tight md:whitespace-nowrap">
                            Escape to the last untouched corner of the PNW...
                        </h3>
                    </div>

                    <form id="bookingForm" action="CreateReservationServlet" method="POST" novalidate class="space-y-6 md:space-y-8">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6">
                            <div>
                                <label class="block text-[10px] font-black text-emerald-900 uppercase tracking-widest mb-2">Check In Date *</label>
                                <input type="date" id="checkIn" name="checkIn" required
                                       value="<%= valCheckIn %>" onchange="updatePriceDisplay()"
                                       class="w-full p-4 md:p-3 bg-slate-50 rounded border border-slate-200 focus:bg-white focus:border-emerald-700 transition outline-none text-sm">
                                <p id="err-checkIn" class="error-text">Check-in date is required.</p>
                            </div>
                            <div>
                                <label class="block text-[10px] font-black text-emerald-900 uppercase tracking-widest mb-2">Check Out Date *</label>
                                <input type="date" id="checkOut" name="checkOut" required
                                       value="<%= valCheckOut %>" onchange="updatePriceDisplay()"
                                       class="w-full p-4 md:p-3 bg-slate-50 rounded border border-slate-200 focus:bg-white focus:border-emerald-700 transition outline-none text-sm">
                                <p id="err-checkOut" class="error-text">Check-out must be after check-in.</p>
                            </div>
                            <div>
                                <label class="block text-[10px] font-black text-emerald-900 uppercase tracking-widest mb-2">Room Preference *</label>
                                <select id="roomType" name="roomType" onchange="updatePriceDisplay()"
                                        class="w-full p-4 md:p-3 bg-slate-50 rounded border border-slate-200 outline-none text-sm appearance-none">
                                    <% for (int i = 0; i < roomOptions.size(); i++) {
                                           String rt = roomOptions.get(i)[0];
                                           String rp = roomOptions.get(i)[1];
                                           boolean selected = (valRoom == null && i == 0) || rt.equals(valRoom); %>
                                        <option value="<%= rt %>" data-price="<%= rp %>" <%= selected ? "selected" : "" %>><%= rt %> ($<%= rp %>)</option>
                                    <% } %>
                                </select>
                            </div>
                            <div>
                                <label class="block text-[10px] font-black text-emerald-900 uppercase tracking-widest mb-2">Adults / Children *</label>
                                <div class="flex space-x-2">
                                    <div class="relative w-1/2">
                                        <input type="number" id="adults" name="adults" min="1" max="4"
                                               value="<%= valAdults %>"
                                               class="w-full p-4 md:p-3 bg-slate-50 rounded border border-slate-200 outline-none text-sm">
                                        <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[8px] font-bold text-slate-400 uppercase pointer-events-none">Adult</span>
                                    </div>
                                    <div class="relative w-1/2">
                                        <input type="number" id="children" name="children" min="0" max="4" value="<%= valChildren %>"
                                               class="w-full p-4 md:p-3 bg-slate-50 rounded border border-slate-200 outline-none text-sm">
                                        <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[8px] font-bold text-slate-400 uppercase pointer-events-none">Child</span>
                                    </div>
                                </div>
                                <p id="err-guests" class="error-text">At least 1 adult required.</p>
                            </div>
                        </div>

                        <div class="pt-6 border-t border-slate-100">
                            <h4 class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-4">Guest Contact Information</h4>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div class="md:col-span-1">
                                    <input type="text" id="custName" name="custName" placeholder="Full Name *" required
                                           value="<%= prefillName %>"
                                           class="w-full p-4 md:p-3 bg-slate-50 rounded border border-slate-200 outline-none text-sm">
                                    <p id="err-custName" class="error-text">Full name is required.</p>
                                </div>
                                <div class="md:col-span-1">
                                    <input type="email" id="custEmail" name="custEmail" placeholder="Email Address *" required
                                           value="<%= prefillEmail %>"
                                           class="w-full p-4 md:p-3 bg-slate-50 rounded border border-slate-200 outline-none text-sm">
                                    <p id="err-custEmail" class="error-text">Please enter a valid email.</p>
                                </div>
                                <div class="md:col-span-2">
                                    <input type="tel" id="custPhone" name="custPhone" placeholder="Phone: (555) 555-5555 *"
                                           required pattern="\(\d{3}\) \d{3}-\d{4}"
                                           value="<%= prefillPhone %>"
                                           class="w-full p-4 md:p-3 bg-slate-50 rounded border border-slate-200 outline-none text-sm">
                                    <p id="err-custPhone" class="error-text">Format: (555) 555-5555</p>
                                </div>
                            </div>
                        </div>

                        <div class="p-4 bg-emerald-50 rounded-lg flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                            <label class="flex items-center space-x-3 cursor-pointer">
                                <input type="checkbox" id="isLocal" name="isLocal" <%= valIsLocal ? "checked" : "" %> class="w-5 h-5 sm:w-4 sm:h-4 rounded text-emerald-700" onchange="updatePriceDisplay()">
                                <span class="text-[11px] font-bold text-emerald-900 leading-tight">Local Resident / First Responder Discount (15%)</span>
                            </label>
                            <span id="priceDisplay" class="text-2xl sm:text-xl font-black text-emerald-900">$375.00 / night</span>
                        </div>

                        <% if (overlapConfirm != null) { %>
                            <input type="hidden" name="confirmOverlap" value="yes">
                        <% } %>
                        <button type="submit"
                                class="w-full btn-check py-5 md:py-4 rounded font-black text-xs md:text-sm uppercase tracking-widest shadow-lg active:scale-[0.98] transition">
                            <%= overlapConfirm != null ? "Confirm &amp; Book Anyway" : "Complete Reservation" %>
                        </button>
                    </form>
                </div>
            </div>

            <div class="space-y-6">
                <div class="bg-[#003057] p-6 md:p-8 rounded-lg text-white">
                    <h4 class="font-bold text-xs uppercase tracking-widest mb-4">TRAVEL ADVISORY</h4>
                    <p class="text-xs text-slate-300 leading-relaxed mb-6">
                        Accessible via the Moffat Express Ferry departing daily from Friday Harbor. Advanced
                        booking is recommended for peak season travel.
                    </p>
                    <a href="#" class="text-[10px] font-bold text-emerald-400 hover:text-emerald-300 transition">
                        VIEW FERRY SCHEDULE <i class="fas fa-external-link-alt ml-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- SECTION: RESERVATION SUMMARY -->
    <section id="page-summary" class="page-content fade-in <%= "summary".equals(view) && res != null ? "" : "hidden" %>">
        <% if (res != null) { %>
        <div class="max-w-2xl mx-auto">
            <div class="text-center mb-8">
                <div class="w-16 h-16 bg-emerald-100 text-emerald-600 rounded-full flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-check text-2xl"></i>
                </div>
                <h1 class="text-2xl md:text-3xl font-black text-slate-900 uppercase">Confirmed</h1>
                <p class="text-emerald-700 text-sm font-bold mt-1">Your PNW escape is ready for you.</p>
            </div>

            <div class="booking-card overflow-hidden border-t-8 border-emerald-700">
                <div class="bg-slate-50 p-5 border-b border-slate-100 flex justify-between items-center">
                    <span class="text-[9px] font-black text-slate-400 uppercase tracking-widest">Confirmation</span>
                    <span class="text-base md:text-lg font-black text-emerald-800 font-mono">#<%= res.getConfirmationId() %></span>
                </div>
                <div class="p-6 md:p-8 space-y-6">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-6 gap-x-8">
                        <div class="border-b sm:border-0 pb-4 sm:pb-0">
                            <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest block mb-1">Primary Guest</label>
                            <p class="text-sm font-bold text-slate-800"><%= res.getGuestName() %></p>
                            <p class="text-[10px] text-slate-500 truncate"><%= res.getGuestEmail() %></p>
                        </div>
                        <div class="border-b sm:border-0 pb-4 sm:pb-0">
                            <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest block mb-1">Room Preference</label>
                            <p class="text-sm font-bold text-slate-800"><%= res.getRoomType() %></p>
                            <p class="text-[10px] text-slate-500"><%= res.getGuestAmount() %> Guests</p>
                        </div>
                        <div class="bg-slate-50 p-3 rounded">
                            <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest block mb-1">Check-In</label>
                            <p class="text-sm font-bold text-slate-700"><%= res.getCheckIn() %></p>
                        </div>
                        <div class="bg-slate-50 p-3 rounded">
                            <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest block mb-1">Check-Out</label>
                            <p class="text-sm font-bold text-slate-700"><%= res.getCheckOut() %></p>
                        </div>
                    </div>

                    <div class="pt-6 border-t border-slate-100 flex flex-col sm:flex-row justify-between items-center gap-6">
                        <div class="text-center sm:text-left">
                            <p class="text-[9px] font-black text-slate-400 uppercase mb-1">Final Total<% if (res.isLocalDiscountApplied()) { %> (incl. 15% discount)<% } %></p>
                            <p class="text-3xl font-black text-slate-900">$<%= res.getFinalPrice() %></p>
                        </div>
                        <div class="flex flex-wrap gap-2 w-full sm:w-auto">
                            <button onclick="window.print()" class="flex-1 sm:flex-none p-4 bg-slate-100 rounded text-slate-500 hover:text-slate-900">
                                <i class="fas fa-print"></i>
                            </button>
                            <% if ("confirmed".equalsIgnoreCase(res.getStatus())) { %>
                            <form action="CancelReservationServlet" method="POST" class="flex-[3] sm:flex-none"
                                  onsubmit="return confirm('Cancel reservation <%= res.getConfirmationId() %>? This cannot be undone.');">
                                <input type="hidden" name="reservationId" value="<%= res.getReservationId() %>">
                                <button type="submit" class="w-full px-6 py-4 bg-red-50 text-red-700 rounded text-[10px] font-black uppercase tracking-widest text-center hover:bg-red-100 transition">
                                    <i class="fas fa-xmark mr-1"></i> Cancel Reservation
                                </button>
                            </form>
                            <% } %>
                            <a href="index.jsp" class="flex-[3] sm:flex-none px-8 py-4 bg-[#003057] text-white rounded text-[10px] font-black uppercase tracking-widest text-center">
                                Back to Home
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </section>

    <!-- SECTION: RESERVATION LOOKUP -->
    <section id="page-lookup" class="page-content fade-in <%= "lookup".equals(view) ? "" : "hidden" %>">
        <div class="max-w-xl mx-auto">
            <div class="text-center mb-8">
                <h1 class="text-2xl md:text-3xl font-black text-slate-900 uppercase">Find a Stay</h1>
                <p class="text-slate-500 text-sm mt-1 font-medium px-4">Search by email or confirmation ID</p>
            </div>

            <% if (session.getAttribute("user_id") == null) { %>
                <div class="booking-card p-6 md:p-8 text-center">
                    <i class="fas fa-lock text-slate-300 text-3xl mb-4"></i>
                    <p class="text-sm font-bold text-slate-700 mb-2">Log in to view your reservations</p>
                    <p class="text-xs text-slate-500 font-medium mb-6">Reservation lookup is available to registered guests only.</p>
                    <div class="grid grid-cols-2 gap-3">
                        <a href="login.jsp"
                           class="py-4 bg-[#003057] text-white rounded font-black text-[10px] uppercase tracking-widest active:scale-[0.98] transition text-center">
                            Log In
                        </a>
                        <a href="signup.jsp"
                           class="py-4 bg-slate-100 text-slate-700 rounded font-black text-[10px] uppercase tracking-widest active:scale-[0.98] transition text-center">
                            Sign Up
                        </a>
                    </div>
                </div>
            <% } else { %>
            <div class="booking-card p-6 md:p-8">
                <form action="LookupReservationServlet" method="GET" class="space-y-4">
                    <div class="relative">
                        <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-slate-300"></i>
                        <input type="text" id="lookupSearch" name="query"
                               value="<%= lookupQuery != null ? lookupQuery : "" %>"
                               placeholder="MB-00042 or your email..."
                               class="w-full pl-12 p-4 bg-slate-50 rounded border border-slate-200 text-base font-medium outline-none focus:border-emerald-700 transition">
                    </div>
                    <div class="grid grid-cols-2 gap-3">
                        <button type="submit"
                                class="py-4 bg-[#003057] text-white rounded font-black text-[10px] uppercase tracking-widest active:scale-[0.98] transition">
                            Search
                        </button>
                        <a href="LookupReservationServlet"
                           class="py-4 bg-slate-100 text-slate-500 rounded font-black text-[10px] uppercase tracking-widest active:scale-[0.98] transition text-center">
                            Reset
                        </a>
                    </div>
                    <% if (lookupError != null) { %>
                        <div class="p-4 bg-red-50 text-red-600 text-[10px] rounded border border-red-100 text-center font-black uppercase tracking-wider">
                            <i class="fas fa-info-circle mr-1"></i> <%= lookupError %>
                        </div>
                    <% } %>
                </form>
            </div>

            <% if (recentSearches != null && !recentSearches.isEmpty()) { %>
                <div class="mt-6">
                    <p class="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2">Recent searches</p>
                    <div class="flex flex-wrap gap-2">
                        <% for (String rs : recentSearches) { %>
                            <a href="LookupReservationServlet?query=<%= java.net.URLEncoder.encode(rs, "UTF-8") %>"
                               class="px-3 py-2 bg-slate-100 text-slate-700 rounded text-[11px] font-bold hover:bg-slate-200 transition">
                                <i class="fas fa-clock-rotate-left text-slate-400 mr-1"></i><%= rs %>
                            </a>
                        <% } %>
                    </div>
                </div>
            <% } %>
            <% } %>

            <% if (reservations != null && !reservations.isEmpty()) { %>
                <div class="mt-8 space-y-3">
                    <p class="text-[10px] font-black uppercase tracking-widest text-slate-500 text-center">
                        <%= reservations.size() %> reservations found
                    </p>
                    <% for (Reservation r : reservations) { %>
                        <a href="LookupReservationServlet?query=MB-<%= String.format("%05d", r.getReservationId()) %>"
                           class="block booking-card p-5 hover:border-emerald-700 transition">
                            <div class="flex items-start justify-between gap-4">
                                <div>
                                    <p class="text-[10px] font-black uppercase tracking-widest text-emerald-700 mb-1">
                                        MB-<%= String.format("%05d", r.getReservationId()) %>
                                    </p>
                                    <p class="text-base font-black text-slate-900"><%= r.getRoomType() %></p>
                                    <p class="text-xs text-slate-500 font-medium mt-1">
                                        <%= dateFmt.format(r.getCheckIn()) %> &rarr; <%= dateFmt.format(r.getCheckOut()) %>
                                    </p>
                                </div>
                                <div class="text-right">
                                    <p class="text-[9px] font-black uppercase tracking-widest text-slate-400">Status</p>
                                    <p class="text-xs font-black text-slate-900 mt-1"><%= r.getStatus() %></p>
                                </div>
                            </div>
                        </a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </section>

</main>

<footer class="bg-white py-10 md:py-16 border-t border-slate-100 mt-12">
    <div class="max-w-7xl mx-auto px-6 md:px-10 text-center">
        <p class="text-[9px] text-slate-400 font-bold uppercase tracking-[0.2em] leading-relaxed">
            &copy; 2026 Moffat Bay Resort &amp; Marina. All rights reserved. <br class="sm:hidden"> Joviedsa Island, PNW.
        </p>
    </div>
</footer>

<script src="js/booking.js"></script>
</body>
</html>
