<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User"%>
<%@ page import="com.tap.model.CartItem"%>
<%@ page import="java.util.Map"%>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login?error=please_login");
        return;
    }
    String address = (String) session.getAttribute("checkoutAddress");
    String phone = (String) session.getAttribute("checkoutPhone");
    if (address == null || address.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
        session.setAttribute("checkoutError", "Please fill out the delivery destination form before proceeding with payment.");
        response.sendRedirect("checkout.jsp");
        return;
    }
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    double total = 0.0;
    int cartCount = 0;
    if (cart != null) {
        for (CartItem item : cart.values()) {
            total += item.getSubTotal();
            cartCount += item.getQuantity();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Grid — BiteSpeed</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/payment.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .payment-main { margin-top: 120px !important; }
        .pay-details-panel {
            display: none;
            margin-top: 12px;
            padding: 14px;
            background: rgba(0,0,0,0.25);
            border-radius: 8px;
            border: 1px dashed var(--border);
        }
        .pay-option input[type="radio"]:checked ~ .option-details .pay-details-panel {
            display: block;
        }
        .pay-input-row {
            display: flex;
            gap: 10px;
            margin-top: 8px;
        }
        .pay-input-row input {
            background: rgba(15, 23, 42, 0.8) !important;
            border: 1px solid rgba(212, 168, 83, 0.3) !important;
            border-radius: 8px !important;
            padding: 10px 14px !important;
            color: #fff !important;
            font-size: 0.88rem !important;
            width: 100% !important;
        }
        .pay-items-list {
            max-height: 180px;
            overflow-y: auto;
            margin-bottom: 15px;
        }
        .pay-item-line {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            color: var(--muted);
            padding: 6px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.06);
        }
        /* ORDER CONFIRMATION MODAL STYLES */
        .confirm-modal-overlay {
            position: fixed;
            inset: 0;
            z-index: 9999;
            background: rgba(5, 8, 15, 0.88);
            backdrop-filter: blur(12px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            animation: fadeIn 0.3s ease;
        }
        .confirm-modal-box {
            max-width: 480px;
            width: 100%;
            background: rgba(18, 26, 43, 0.95);
            border: 1px solid var(--gold);
            border-radius: 24px;
            padding: 35px 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.8), 0 0 30px rgba(212, 168, 83, 0.25);
            text-align: center;
            position: relative;
        }
        .confirm-summary-box {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
            margin: 20px 0;
            text-align: left;
        }
        .confirm-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.88rem;
            color: var(--muted);
            padding: 8px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.08);
        }
        .confirm-row:last-child {
            border-bottom: none;
        }
        .spinner-glow {
            width: 50px;
            height: 50px;
            border: 4px solid rgba(212, 168, 83, 0.2);
            border-top-color: var(--gold);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin: 0 auto;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="noise"></div>

    <!-- HEADER -->
    <header id="hdr">
        <a href="<%=request.getContextPath()%>/index.jsp" class="logo">
            <div class="logo-dot"></div> BiteSpeed
        </a>
        <nav>
            <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link">Home</a>
            <a href="<%=request.getContextPath()%>/restaurants.jsp" class="nav-link">Restaurants</a>
            <a href="<%=request.getContextPath()%>/menu.jsp" class="nav-link">Menu</a>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="nav-link">Cart</a>
            <a href="<%=request.getContextPath()%>/orders.jsp" class="nav-link">Orders</a>
        </nav>
        <div class="hactions">
            <button class="theme-btn" id="theme-toggle" onclick="toggleTheme()" aria-label="Toggle Light/Dark Theme">
                <svg class="theme-icon sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="5"></circle>
                    <line x1="12" y1="1" x2="12" y2="3"></line>
                    <line x1="12" y1="21" x2="12" y2="23"></line>
                    <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                    <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                    <line x1="1" y1="12" x2="3" y2="12"></line>
                    <line x1="21" y1="12" x2="23" y2="12"></line>
                    <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                    <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                </svg>
                <svg class="theme-icon moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                </svg>
            </button>
            <div id="auth-header-container" class="auth-header-container">
                <% if (loggedInUser != null) { %>
                    <span class="user-greeting" style="color:var(--text-glow); font-weight:500; margin-right:15px;">Hi, <%= loggedInUser.getFullName() %></span>
                    <a href="<%=request.getContextPath()%>/profile.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Profile</a>
                    <% if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
                    <a href="<%=request.getContextPath()%>/admin/orders.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Admin</a>
                    <% } %>
                    <a href="<%=request.getContextPath()%>/logout" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Logout</a>
                <% } else { %>
                    <a href="<%=request.getContextPath()%>/login.jsp" class="auth-btn" style="text-decoration:none; margin-right:10px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign In</a>
                    <a href="<%=request.getContextPath()%>/register.jsp" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign Up</a>
                <% } %>
            </div>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="cart-btn" style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                Cart <span class="cbadge" id="cbadge"><%= cartCount %></span>
            </a>
            <button class="hamburger" id="hbg" onclick="toggleMnav()">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <main class="payment-main">
        <h1>Payment Grid & Order Authorization</h1>

        <div class="payment-container">
            <!-- PAYMENT OPTION CARD -->
            <div class="payment-card">
                <h2>Select Payment Method</h2>
                <p class="payment-sub">Choose your preferred payment gateway to place order</p>

                <form action="payment" method="POST" class="payment-form" id="paymentForm" onsubmit="openOrderConfirmModal(event)">
                    <div class="payment-options">
                        <!-- COD -->
                        <label class="pay-option">
                            <input type="radio" name="paymentMode" value="COD" checked onclick="togglePayDetails('cod')">
                            <span class="option-details">
                                <span class="option-title">💵 Cash On Delivery (COD)</span>
                                <span class="option-desc">Pay cash or scan QR upon drone/courier arrival at your doorstep.</span>
                            </span>
                        </label>

                        <!-- UPI -->
                        <label class="pay-option">
                            <input type="radio" name="paymentMode" value="UPI" onclick="togglePayDetails('upi')">
                            <span class="option-details">
                                <span class="option-title">⚡ Instant UPI / QR (GPay, PhonePe, Paytm)</span>
                                <span class="option-desc">Zero transaction fee. Instant payment verification.</span>
                                <div class="pay-details-panel" id="panel-upi">
                                    <span style="font-size: 0.8rem; color: var(--gold);">Enter Virtual Payment Address (VPA):</span>
                                    <div class="pay-input-row">
                                        <input type="text" placeholder="username@upi or mobile@paytm">
                                    </div>
                                </div>
                            </span>
                        </label>

                        <!-- CREDIT CARD -->
                        <label class="pay-option">
                            <input type="radio" name="paymentMode" value="CREDIT_CARD" onclick="togglePayDetails('card')">
                            <span class="option-details">
                                <span class="option-title">💳 Credit / Debit Card</span>
                                <span class="option-desc">Supports Visa, MasterCard, RuPay & American Express.</span>
                                <div class="pay-details-panel" id="panel-card">
                                    <div class="pay-input-row">
                                        <input type="text" placeholder="Card Number (4532 •••• •••• 8890)">
                                    </div>
                                    <div class="pay-input-row" style="margin-top: 6px;">
                                        <input type="text" placeholder="MM/YY" style="width: 50%;">
                                        <input type="password" placeholder="CVV" style="width: 50%;">
                                    </div>
                                </div>
                            </span>
                        </label>

                        <!-- NET BANKING -->
                        <label class="pay-option">
                            <input type="radio" name="paymentMode" value="NET_BANKING" onclick="togglePayDetails('netbanking')">
                            <span class="option-details">
                                <span class="option-title">🏛️ Net Banking</span>
                                <span class="option-desc">All major Indian public & private banks supported.</span>
                            </span>
                        </label>
                    </div>

                    <button type="submit" class="btn-pay-submit" id="btn-pay-trigger">
                        Pay & Place Order ₹<%= total %> →
                    </button>
                </form>
            </div>

            <!-- BILL & ADDRESS SUMMARY -->
            <div class="bill-summary-card">
                <h2>Delivery Coordinates</h2>

                <div class="detail-row">
                    <span class="label">Destination</span>
                    <span class="value" style="font-size: 0.85rem;" id="dest-address-text">
                        <%= address != null && !address.trim().isEmpty() ? address : "Indiranagar, Bengaluru - 560038" %>
                    </span>
                </div>

                <div class="detail-row">
                    <span class="label">Contact Phone</span>
                    <span class="value">
                        <%= phone != null && !phone.trim().isEmpty() ? phone : (loggedInUser != null ? loggedInUser.getPhone() : "") %>
                    </span>
                </div>

                <hr>

                <h2>Order Manifest</h2>
                <div class="pay-items-list">
                    <% if (cart != null && !cart.isEmpty()) {
                        for (CartItem item : cart.values()) { %>
                            <div class="pay-item-line">
                                <span><%= item.getName() %> × <strong><%= item.getQuantity() %></strong></span>
                                <span style="color: #fff; font-weight: 500;">₹<%= item.getSubTotal() %></span>
                            </div>
                    <%  }
                    } %>
                </div>

                <div class="detail-row total-row">
                    <span class="label">Grand Total</span>
                    <span class="value">₹<%= total %></span>
                </div>
            </div>
        </div>
    </main>

    <!-- ORDER CONFIRMATION MODAL -->
    <div id="order-confirm-modal" class="confirm-modal-overlay" style="display: none;">
        <div class="confirm-modal-box">
            <!-- STEP 1: CONFIRMATION PROMPT -->
            <div id="modal-confirm-content">
                <div style="font-size: 3rem; margin-bottom: 10px;">🛍️</div>
                <h2 style="font-family: var(--font-serif); font-size: 1.8rem; color: #fff; margin-bottom: 8px;">Confirm Order Placement?</h2>
                <p style="color: var(--muted); font-size: 0.88rem;">Please double-check your order details before submitting</p>

                <div class="confirm-summary-box">
                    <div class="confirm-row">
                        <span>Payable Amount:</span>
                        <strong style="color: var(--gold); font-size: 1.1rem;">₹<%= total %></strong>
                    </div>
                    <div class="confirm-row">
                        <span>Payment Gateway:</span>
                        <strong id="modal-pay-mode-lbl" style="color: #fff;">Cash On Delivery (COD)</strong>
                    </div>
                    <div class="confirm-row">
                        <span>Delivery Address:</span>
                        <span id="modal-address-lbl" style="color: #fff; max-width: 220px; text-align: right;"><%= address != null && !address.trim().isEmpty() ? address : "Indiranagar, Bengaluru - 560038" %></span>
                    </div>
                </div>

                <div style="display: flex; flex-direction: column; gap: 10px;">
                    <button type="button" class="btn-primary full" onclick="executeFinalOrderSubmit()">
                        ✅ Yes, Confirm & Place Order →
                    </button>
                    <button type="button" class="btn-ghost full" onclick="closeOrderConfirmModal()">
                        ❌ Modify Order / Cancel
                    </button>
                </div>
            </div>

            <!-- STEP 2: PROCESSING SPINNER -->
            <div id="modal-processing-content" style="display: none; padding: 25px 0;">
                <div class="spinner-glow"></div>
                <h3 style="color: #fff; font-size: 1.3rem; margin-top: 20px; margin-bottom: 8px;">Placing Your Order...</h3>
                <p style="color: #00f0ff; font-size: 0.9rem; font-weight: 500;">Securing payment & notifying restaurant kitchen ⚡</p>
            </div>
        </div>
    </div>

    <script>
        let isConfirmed = false;

        function togglePayDetails(type) {
            document.querySelectorAll('.pay-details-panel').forEach(p => p.style.display = 'none');
            const target = document.getElementById('panel-' + type);
            if (target) target.style.display = 'block';
        }

        function openOrderConfirmModal(e) {
            if (!isConfirmed) {
                e.preventDefault();
                // Determine selected payment mode text
                const selectedRadio = document.querySelector('input[name="paymentMode"]:checked');
                let modeText = "Cash On Delivery (COD)";
                if (selectedRadio) {
                    if (selectedRadio.value === 'UPI') modeText = "Instant UPI / QR";
                    else if (selectedRadio.value === 'CREDIT_CARD') modeText = "Credit / Debit Card";
                    else if (selectedRadio.value === 'NET_BANKING') modeText = "Net Banking";
                }
                document.getElementById('modal-pay-mode-lbl').textContent = modeText;
                document.getElementById('order-confirm-modal').style.display = 'flex';
            }
        }

        function closeOrderConfirmModal() {
            document.getElementById('order-confirm-modal').style.display = 'none';
        }

        function executeFinalOrderSubmit() {
            isConfirmed = true;
            document.getElementById('modal-confirm-content').style.display = 'none';
            document.getElementById('modal-processing-content').style.display = 'block';

            setTimeout(function() {
                document.getElementById('paymentForm').submit();
            }, 750);
        }
    </script>
</body>
</html>
