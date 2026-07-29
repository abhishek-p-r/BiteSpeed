<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="java.util.Map" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser != null) {
        String role = loggedInUser.getRole();
        if (role != null && (role.equalsIgnoreCase("ADMIN") || role.equalsIgnoreCase("SUPER_ADMIN") || role.equalsIgnoreCase("RESTAURANT_ADMIN") || role.equalsIgnoreCase("VENDOR") || role.equalsIgnoreCase("OWNER"))) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
        return;
    }
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (cart != null) {
        for (CartItem item : cart.values()) {
            cartCount += item.getQuantity();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Operator Registration — BiteSpeed</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/auth.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">

    <style>
        .auth-page-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-top: 100px;
            padding-bottom: 40px;
            position: relative;
            z-index: 10;
        }
        .auth-food-bg {
            position: fixed;
            inset: 0;
            z-index: 1;
            overflow: hidden;
            pointer-events: none;
        }
        .auth-food-bg .food-bg-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: blur(10px) brightness(0.35) contrast(1.1);
            transform: scale(1.06);
        }
        .auth-food-bg .food-overlay {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at center, rgba(15, 23, 42, 0.65) 0%, rgba(5, 8, 15, 0.95) 100%);
            z-index: 2;
        }
        .floating-food-badge {
            position: absolute;
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid rgba(212, 168, 83, 0.3);
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            opacity: 0.25;
            animation: floatSlow 12s ease-in-out infinite alternate;
        }
        @keyframes floatSlow {
            0% { transform: translateY(0) rotate(0deg); }
            100% { transform: translateY(-30px) rotate(8deg); }
        }
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.88rem;
            margin-bottom: 20px;
            border: 1px solid transparent;
            font-family: 'Outfit', sans-serif;
        }
        .alert-error {
            background: rgba(230, 57, 70, 0.1);
            color: #ff6b6b;
            border-color: rgba(230, 57, 70, 0.2);
        }
        .alert-warning {
            background: rgba(255, 107, 53, 0.1);
            color: #ff9f43;
            border-color: rgba(255, 107, 53, 0.2);
        }
        .alert-success {
            background: rgba(34, 197, 94, 0.1);
            color: #22c55e;
            border-color: rgba(34, 197, 94, 0.2);
        }
        .alert-info {
            background: rgba(0, 240, 255, 0.1);
            color: #00f0ff;
            border-color: rgba(0, 240, 255, 0.2);
        }
    </style>
</head>
<body class="auth-body">
    <div class="noise"></div>

    <!-- BACKGROUND FOOD IMAGE OVERLAY -->
    <div class="auth-food-bg">
        <div class="food-overlay"></div>
        <img src="<%=request.getContextPath()%>/images/banner.jpg" class="food-bg-img" alt="Food Backdrop" onerror="this.src='<%=request.getContextPath()%>/images/pizza.jpg';">
        <img src="<%=request.getContextPath()%>/images/biryani.jpg" class="floating-food-badge" style="top: 15%; right: 8%;" alt="Biryani">
        <img src="<%=request.getContextPath()%>/images/pizza.jpg" class="floating-food-badge" style="bottom: 12%; left: 8%; animation-delay: -4s;" alt="Pizza">
    </div>

    <!-- HEADER -->
    <header id="hdr" style="z-index: 100;">
        <a href="<%=request.getContextPath()%>/index.jsp" class="logo">
            <div class="logo-dot"></div>
            BiteSpeed
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

    <!-- PERFECTLY CENTERED REGISTER FORM CONTAINER -->
    <div class="auth-page-container">
        <div class="auth-wrapper" style="margin-top: 0;">
            <div class="auth-box glass-panel" style="box-shadow: 0 20px 50px rgba(0,0,0,0.7); border: 1px solid rgba(212, 168, 83, 0.25);">
                
                <div class="auth-title">OPERATOR REGISTRATION</div>

                <!-- Error Messages -->
                <% 
                    String error = request.getParameter("error");
                    if ("email_exists".equals(error)) {
                %>
                    <div class="alert alert-error">❌ Email coordinate is already registered on grid.</div>
                <% } else if ("phone_exists".equals(error)) { %>
                    <div class="alert alert-error">❌ Mobile vector is already registered on grid.</div>
                <% } else if ("registration_failed".equals(error)) { %>
                    <div class="alert alert-error">❌ Registration node commit failed. Please retry.</div>
                <% } else if ("empty_fields".equals(error)) { %>
                    <div class="alert alert-warning">⚠️ Registration fields cannot be empty.</div>
                <% } %>

                <!-- Registration Form -->
                <form action="register" method="POST" class="auth-form active">
                    
                    <div class="fg">
                        <label for="reg-name">Full Name</label>
                        <input type="text" id="reg-name" name="name" placeholder="e.g. Ravi Sharma" required autocomplete="name" />
                    </div>

                    <div class="fg availability-group">
                        <label for="reg-email">Email Address</label>
                        <div class="input-avail-wrapper">
                            <input type="email" id="reg-email" name="email" placeholder="you@example.com" required autocomplete="email" />
                            <span class="avail-indicator" id="email-avail-indicator"></span>
                        </div>
                    </div>

                    <div class="fg availability-group">
                        <label for="reg-phone">Mobile Number</label>
                        <div class="input-avail-wrapper">
                            <input type="tel" id="reg-phone" name="phone" placeholder="+91 XXXXX XXXXX" required autocomplete="tel" />
                            <span class="avail-indicator" id="phone-avail-indicator"></span>
                        </div>
                    </div>

                    <div class="fg">
                        <label for="role">Register As</label>
                        <select id="role" name="role" required style="background: rgba(255,255,255,0.05); color:#fff; border: 1px solid var(--border); border-radius: 8px; padding: 10px;">
                            <option value="" style="background: #111827;">-- Select Role --</option>
                            <option value="CUSTOMER" selected style="background: #111827;">Customer</option>
                            <option value="DELIVERY" style="background: #111827;">Delivery Partner</option>
                            <option value="ADMIN" style="background: #111827;">Admin</option>
                        </select>
                    </div>

                    <div class="fg pw-group">
                        <label for="reg-password">Security Password</label>
                        <div class="pw-input-wrapper">
                            <input type="password" id="reg-password" name="password" placeholder="Min 8 characters" required autocomplete="new-password" oninput="checkPasswordStrength()" />
                            <button type="button" class="pw-toggle-btn" onclick="togglePasswordVisibility('reg-password', this)">👁️</button>
                        </div>
                        <!-- Password Strength Indicator -->
                        <div class="strength-meter-container">
                            <div class="strength-bar" id="strength-bar"></div>
                            <span class="strength-text" id="strength-text">Strength: Empty</span>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary auth-submit full" id="reg-submit-btn" style="margin-top: 15px;">
                        <span class="btn-text">PROCEED TO REGISTRATION →</span>
                    </button>
                </form>

                <div class="auth-footer-prompt" style="font-size: 0.84rem; margin-top: 20px;">
                    Already registered? <a href="login.jsp">Sign In Operator</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function togglePasswordVisibility(id, btn) {
            const input = document.getElementById(id);
            if (input) {
                const isPw = input.type === 'password';
                input.type = isPw ? 'text' : 'password';
                btn.textContent = isPw ? '🙈' : '👁️';
            }
        }

        function checkPasswordStrength() {
            const password = document.getElementById('reg-password').value;
            const bar = document.getElementById('strength-bar');
            const text = document.getElementById('strength-text');
            
            // Clear previous classes
            bar.className = 'strength-bar';
            text.className = 'strength-text';
            
            let strength = 0;
            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            if (password.length === 0) {
                text.textContent = 'Strength: Empty';
            } else if (strength <= 1) {
                bar.classList.add('weak');
                text.classList.add('weak');
                text.textContent = 'Strength: Weak';
            } else if (strength === 2 || strength === 3) {
                bar.classList.add('medium');
                text.classList.add('medium');
                text.textContent = 'Strength: Medium';
            } else {
                bar.classList.add('strong');
                text.classList.add('strong');
                text.textContent = 'Strength: Strong';
            }
        }
    </script>
</body>
</html>
