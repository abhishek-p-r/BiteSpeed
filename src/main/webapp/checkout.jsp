<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.tap.model.User" %>
        <%@ page import="com.tap.model.CartItem" %>
            <%@ page import="java.util.Map" %>
                <% User loggedInUser=(User) session.getAttribute("user"); if (loggedInUser==null) {
                    response.sendRedirect("login?error=please_login"); return; } Map<Integer, CartItem> cart = (Map
                    <Integer, CartItem>) session.getAttribute("cart");
                        double subtotal = 0.0;
                        int cartCount = 0;
                        if (cart != null) {
                        for (CartItem item : cart.values()) {
                        subtotal += item.getSubTotal();
                        cartCount += item.getQuantity();
                        }
                        }
                        double deliveryFee = 0.0; // Free delivery
                        double grandTotal = subtotal + deliveryFee;
                        String userPhoneVal = "+91 98765 43210";
                        if (loggedInUser != null && loggedInUser.getPhone() != null &&
                        !loggedInUser.getPhone().trim().isEmpty()) {
                        userPhoneVal = loggedInUser.getPhone().trim();
                        }
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <script src="<%=request.getContextPath()%>/js/theme.js"></script>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Checkout Delivery — BiteSpeed</title>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
                                rel="stylesheet">
                            <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
                            <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
                            <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
                            <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
                            <link rel="stylesheet" href="<%=request.getContextPath()%>/css/checkout.css">
                            <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
                            <style>
                                .checkout-main {
                                    margin-top: 120px !important;
                                }

                                .address-tags {
                                    display: flex;
                                    gap: 10px;
                                    margin-top: 6px;
                                    margin-bottom: 12px;
                                }

                                .tag-btn {
                                    background: rgba(255, 255, 255, 0.05);
                                    border: 1px solid var(--border);
                                    color: var(--text-mute);
                                    padding: 6px 14px;
                                    border-radius: 20px;
                                    font-size: 0.8rem;
                                    cursor: pointer;
                                    transition: all 0.2s;
                                }

                                .tag-btn.active,
                                .tag-btn:hover {
                                    background: rgba(212, 168, 83, 0.15);
                                    border-color: var(--gold);
                                    color: var(--gold);
                                }

                                .delivery-speed-grid {
                                    display: grid;
                                    grid-template-columns: 1fr 1fr;
                                    gap: 12px;
                                    margin-top: 8px;
                                }

                                .speed-card {
                                    background: rgba(255, 255, 255, 0.02);
                                    border: 1px solid var(--border);
                                    border-radius: 10px;
                                    padding: 12px;
                                    cursor: pointer;
                                    transition: border-color 0.2s;
                                }

                                .speed-card.active,
                                .speed-card:hover {
                                    border-color: var(--gold);
                                    background: rgba(212, 168, 83, 0.05);
                                }

                                .speed-title {
                                    font-weight: 600;
                                    font-size: 0.9rem;
                                    color: #fff;
                                }

                                .speed-desc {
                                    font-size: 0.78rem;
                                    color: var(--muted);
                                    margin-top: 4px;
                                }

                                .checkout-items-preview {
                                    max-height: 240px;
                                    overflow-y: auto;
                                    margin-bottom: 20px;
                                    padding-right: 5px;
                                }

                                .preview-item-row {
                                    display: flex;
                                    align-items: center;
                                    justify-content: space-between;
                                    padding: 8px 0;
                                    border-bottom: 1px dashed rgba(255, 255, 255, 0.08);
                                    font-size: 0.88rem;
                                }

                                .preview-item-info {
                                    display: flex;
                                    align-items: center;
                                    gap: 10px;
                                }

                                .preview-item-img {
                                    width: 40px;
                                    height: 40px;
                                    border-radius: 8px;
                                    object-fit: cover;
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
                                    <a href="<%=request.getContextPath()%>/restaurants.jsp"
                                        class="nav-link">Restaurants</a>
                                    <a href="<%=request.getContextPath()%>/menu.jsp" class="nav-link">Menu</a>
                                    <a href="<%=request.getContextPath()%>/cart.jsp" class="nav-link">Cart</a>
                                    <a href="<%=request.getContextPath()%>/orders.jsp" class="nav-link">Orders</a>
                                </nav>
                                <div class="hactions">
                                    <button class="theme-btn" id="theme-toggle" onclick="toggleTheme()"
                                        aria-label="Toggle Light/Dark Theme">
                                        <svg class="theme-icon sun" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round">
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
                                        <svg class="theme-icon moon" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                                        </svg>
                                    </button>
                                    <div id="auth-header-container" class="auth-header-container">
                                        <% if (loggedInUser !=null) { %>
                                            <span class="user-greeting"
                                                style="color: var(--text-glow); font-weight: 500; margin-right: 15px;">Hi,
                                                <%= loggedInUser.getFullName() %>
                                            </span>
                                            <a href="<%=request.getContextPath()%>/profile.jsp" class="auth-btn"
                                                style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Profile</a>
                                            <% if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
                                                <a href="<%=request.getContextPath()%>/admin/orders.jsp"
                                                    class="auth-btn"
                                                    style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Admin</a>
                                                <% } %>
                                                    <a href="logout" class="auth-btn"
                                                        style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Logout</a>
                                                    <% } else { %>
                                                        <a href="login" class="auth-btn"
                                                            style="text-decoration:none; margin-right:10px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign
                                                            In</a>
                                                        <a href="register.jsp" class="auth-btn"
                                                            style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign
                                                            Up</a>
                                                        <% } %>
                                    </div>
                                    <a href="<%=request.getContextPath()%>/cart.jsp" class="cart-btn"
                                        style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                                        Cart <span class="cbadge" id="cbadge">
                                            <%= cartCount %>
                                        </span>
                                    </a>
                                    <button class="hamburger" id="hbg" onclick="toggleMnav()">
                                        <span></span><span></span><span></span>
                                    </button>
                                </div>
                            </header>

                            <main class="checkout-main">
                                <h1>Checkout & Delivery Details</h1>

                                <div class="checkout-container">
                                    <!-- LEFT FORM CARD -->
                                    <div class="checkout-card">
                                        <h2>1. Delivery Destination</h2>
                                        <p class="checkout-sub">Provide delivery coordinates and recipient contact info
                                        </p>

                                        <% String checkoutErr=(String) session.getAttribute("checkoutError"); if
                                            (checkoutErr !=null) { session.removeAttribute("checkoutError"); %>
                                            <div
                                                style="background: rgba(230,57,70,0.1); border: 1px solid rgba(230,57,70,0.3); color: #ff6b6b; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 0.88rem;">
                                                ⚠️ <%= checkoutErr %>
                                            </div>
                                            <% } %>

                                                <form action="checkout" method="POST" class="checkout-form">
                                                    <div class="form-group">
                                                        <label for="recipientName">Recipient Full Name</label>
                                                        <input type="text" id="recipientName" name="recipientName"
                                                            value="<%= loggedInUser != null ? loggedInUser.getFullName() : "" %>"
                                                            placeholder="e.g. John Doe" required>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="address">Full Delivery Address</label>
                                                        <textarea id="address" name="address" rows="3"
                                                            placeholder="Flat / House No., Apartment, Street Name, Landmark, City, Pincode"
                                                            required>MG Road, Indiranagar, Bengaluru - 560038</textarea>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>Address Type</label>
                                                        <div class="address-tags">
                                                            <button type="button" class="tag-btn active"
                                                                onclick="selectTag(this)">🏠 Home</button>
                                                            <button type="button" class="tag-btn"
                                                                onclick="selectTag(this)">💼 Work / Office</button>
                                                            <button type="button" class="tag-btn"
                                                                onclick="selectTag(this)">📍 Other</button>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="phone">Recipient Contact Phone</label>
                                                        <input type="tel" id="phone" name="phone"
                                                            value="<%= userPhoneVal %>" placeholder="+91 99999 99999"
                                                            required>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>Delivery Preference</label>
                                                        <div class="delivery-speed-grid">
                                                            <div class="speed-card active" onclick="selectSpeed(this)">
                                                                <div class="speed-title">⚡ Standard Delivery</div>
                                                                <div class="speed-desc">Estimated: 30 - 35 Mins (Free)
                                                                </div>
                                                            </div>
                                                            <div class="speed-card" onclick="selectSpeed(this)">
                                                                <div class="speed-title">🚀 Priority Drone</div>
                                                                <div class="speed-desc">Estimated: 15 - 20 Mins
                                                                    (Priority)</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="notes">Special Delivery Instructions
                                                            (Optional)</label>
                                                        <input type="text" id="notes" name="notes"
                                                            placeholder="e.g. Leave at door, call on arrival, don't ring bell">
                                                    </div>

                                                    <button type="submit" class="btn-checkout-submit">Proceed to Payment
                                                        Grid →</button>
                                                </form>

                                                <div class="checkout-links" style="margin-top: 20px;">
                                                    <a href="cart.jsp"
                                                        style="color: var(--gold); text-decoration: none; font-size: 0.9rem;">←
                                                        Return to Shopping Cart</a>
                                                </div>
                                    </div>

                                    <!-- RIGHT SUMMARY CARD -->
                                    <div class="bill-summary-card">
                                        <h2>2. Cart Order Summary</h2>

                                        <div class="checkout-items-preview">
                                            <% if (cart !=null && !cart.isEmpty()) { for (CartItem item : cart.values())
                                                { String cImg = item.getImagePath();
                                                  if (cImg == null || cImg.trim().isEmpty()) {
                                                      cImg = "1.jpg";
                                                  } else {
                                                      cImg = cImg.trim();
                                                      if (cImg.startsWith("images/") || cImg.startsWith("images\\")) {
                                                          cImg = cImg.substring(7);
                                                      }
                                                  }
                                                  String cImgUrl = (cImg.startsWith("http://") || cImg.startsWith("https://") || cImg.startsWith("/"))
                                                      ? cImg
                                                      : request.getContextPath() + "/images/" + cImg; %>
                                                <div class="preview-item-row">
                                                    <div class="preview-item-info">
                                                        <img src="<%= cImgUrl %>" alt="<%= item.getName() %>"
                                                            class="preview-item-img"
                                                            onerror="this.src='<%=request.getContextPath()%>/images/1.jpg';">
                                                        <div>
                                                            <strong style="color: #fff; display: block;">
                                                                <%= item.getName() %>
                                                            </strong>
                                                            <span style="color: var(--muted); font-size: 0.8rem;">₹<%=
                                                                    item.getPrice() %> × <%= item.getQuantity() %>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <span style="color: var(--gold); font-weight: 600;">₹<%=
                                                            item.getSubTotal() %></span>
                                                </div>
                                                <% } } else { %>
                                                    <p style="color: var(--muted); text-align: center;">No items in cart
                                                    </p>
                                                    <% } %>
                                        </div>

                                        <div class="detail-row">
                                            <span class="label">Items Subtotal</span>
                                            <span class="value">₹<%= subtotal %></span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="label">Delivery Charge</span>
                                            <span class="value" style="color: #2ecc71;">FREE</span>
                                        </div>
                                        <div class="detail-row">
                                            <span class="label">Packaging & Taxes</span>
                                            <span class="value">Included</span>
                                        </div>

                                        <hr>

                                        <div class="detail-row total-row">
                                            <span class="label">Total Payable</span>
                                            <span class="value">₹<%= grandTotal %></span>
                                        </div>
                                    </div>
                                </div>
                            </main>

                            <script>
                                function selectTag(btn) {
                                    document.querySelectorAll('.tag-btn').forEach(b => b.classList.remove('active'));
                                    btn.classList.add('active');
                                }
                                function selectSpeed(card) {
                                    document.querySelectorAll('.speed-card').forEach(c => c.classList.remove('active'));
                                    card.classList.add('active');
                                }
                            </script>
                        </body>

                        </html>