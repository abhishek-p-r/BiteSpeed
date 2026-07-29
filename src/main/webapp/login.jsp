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
    <title>Authorize Operator — BiteSpeed</title>
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
        <img src="<%=request.getContextPath()%>/images/pizza.jpg" class="floating-food-badge" style="top: 15%; left: 8%;" alt="Pizza">
        <img src="<%=request.getContextPath()%>/images/burger.jpg" class="floating-food-badge" style="bottom: 15%; right: 8%; animation-delay: -5s;" alt="Burger">
        <img src="<%=request.getContextPath()%>/images/biryani.jpg" class="floating-food-badge" style="top: 60%; left: 6%; animation-delay: -3s;" alt="Biryani">
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

    <!-- PERFECTLY CENTERED FORM CONTAINER -->
    <div class="auth-page-container">
        <div class="auth-wrapper" style="margin-top: 0;">
            <div class="auth-box glass-panel" style="box-shadow: 0 20px 50px rgba(0,0,0,0.7); border: 1px solid rgba(212, 168, 83, 0.25);">
                
                <div class="auth-tabs">
                    <button class="atab active" id="login-tab-pw" onclick="switchLoginTab('pw')">Password Login</button>
                    <button class="atab" id="login-tab-otp" onclick="switchLoginTab('otp')">OTP Login</button>
                </div>

                <!-- Error and Success Messages -->
                <% 
                    String error = request.getParameter("error");
                    if ("invalid_credentials".equals(error)) {
                %>
                    <div class="alert alert-error">❌ Invalid email or password node.</div>
                <% } else if ("please_login".equals(error)) { %>
                    <div class="alert alert-warning">⚠️ Authentication token required for page.</div>
                <% } else if ("inactive_account".equals(error)) { %>
                    <div class="alert alert-error">❌ Account node is currently deactivated.</div>
                <% } else if ("invalid_role".equals(error) || "unauthorized".equals(error)) { %>
                    <div class="alert alert-error">❌ Unauthorized access: Only Super Admin and authorized operators can access Admin area.</div>
                <% } else if ("empty_fields".equals(error)) { %>
                    <div class="alert alert-warning">⚠️ Form fields cannot be empty.</div>
                <% } else if ("registration_failed".equals(error)) { %>
                    <div class="alert alert-error">❌ Registration failed. Please try again.</div>
                <% } %>
                
                <% 
                    String success = request.getParameter("success");
                    if ("registered".equals(success)) {
                %>
                    <div class="alert alert-success">✅ User registration node committed successfully!</div>
                <% } else if ("logged_out".equals(success)) { %>
                    <div class="alert alert-info">ℹ️ Session invalidated successfully.</div>
                <% } %>

                <!-- Password Login Form -->
                <form id="login-form-pw" action="login" method="POST" class="auth-form active">
                    <div class="auth-title">AUTHORIZE OPERATOR</div>

                    <div class="fg">
                        <label for="login-email">Email Address</label>
                        <input type="email" id="login-email" name="email" placeholder="operator@bitespeed.in" required autocomplete="email" />
                    </div>

                    <div class="fg pw-group">
                        <label for="login-password">Security Password</label>
                        <div class="pw-input-wrapper">
                            <input type="password" id="login-password" name="password" placeholder="••••••••" required autocomplete="current-password" />
                            <button type="button" class="pw-toggle-btn" onclick="togglePasswordVisibility('login-password', this)">👁️</button>
                        </div>
                    </div>

                    <div class="auth-row">
                        <label class="remember-label">
                            <input type="checkbox" id="login-remember" name="remember" /> Remember Session
                        </label>
                        <a href="forgotPassword.jsp" class="forgot-link">Decrypt Password?</a>
                    </div>

                    <button type="submit" class="btn-primary auth-submit full">
                        <span class="btn-text">INITIALIZE LOGIN →</span>
                    </button>
                </form>

                <!-- OTP Login Form -->
                <div id="login-form-otp" class="auth-form">
                    <div class="auth-title">REQUEST TEMPORARY PASSKEY</div>
                    <div class="fg">
                        <label for="login-otp-email">Registered Email</label>
                        <input type="email" id="login-otp-email" placeholder="operator@bitespeed.in" />
                    </div>
                    <button type="button" class="btn-primary auth-submit full" onclick="alert('⚠️ Quantum OTP dispatcher offline on this node. Please authorize session using Security Key password, or initiate OTP via the main space deck portal.')">
                        <span class="btn-text">DISPATCH OTP KEY →</span>
                    </button>
                </div>

                <div class="auth-divider"><span>OR CONTINUE WITH</span></div>

                <!-- Google Sign-In button container -->
                <div class="google-auth-btn-wrapper">
                    <button type="button" class="google-btn" onclick="initiateGoogleLogin()">
                        <svg class="google-icon" viewBox="0 0 24 24" width="18" height="18" style="margin-right: 8px; vertical-align: middle;">
                            <path fill="#EA4335" d="M12 5.04c1.66 0 3.2.57 4.38 1.69l3.27-3.27C17.68 1.54 14.98 1 12 1 7.35 1 3.37 3.67 1.39 7.56l3.85 2.99C6.16 7.42 8.87 5.04 12 5.04z" />
                            <path fill="#4285F4" d="M23.49 12.27c0-.81-.07-1.59-.2-2.36H12v4.51h6.46c-.29 1.48-1.14 2.73-2.4 3.58l3.73 2.89c2.18-2.01 3.7-4.98 3.7-8.62z" />
                            <path fill="#FBBC05" d="M5.24 14.75c-.24-.72-.38-1.49-.38-2.29s.14-1.57.38-2.29L1.39 7.18C.5 8.93 0 10.9 0 13s.5 4.07 1.39 5.82l3.85-3.07z" />
                            <path fill="#34A853" d="M12 23c3.24 0 5.97-1.07 7.96-2.91l-3.73-2.89c-1.1.74-2.5 1.18-4.23 1.18-3.13 0-5.84-2.38-6.76-5.51L1.39 15.94C3.37 20.33 7.35 23 12 23z" />
                        </svg>
                        Google Terminal Auth
                    </button>
                </div>

                <div class="auth-footer-prompt" style="font-size: 0.84rem;">
                    New Courier Operator? <a href="register.jsp">Initialize Account Registration</a>
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

        function switchLoginTab(tab) {
            const pwForm = document.getElementById('login-form-pw');
            const otpForm = document.getElementById('login-form-otp');
            const pwTab = document.getElementById('login-tab-pw');
            const otpTab = document.getElementById('login-tab-otp');
            
            if (tab === 'pw') {
                pwForm.classList.add('active');
                otpForm.classList.remove('active');
                pwTab.classList.add('active');
                otpTab.classList.remove('active');
            } else {
                pwForm.classList.remove('active');
                otpForm.classList.add('active');
                pwTab.classList.remove('active');
                otpTab.classList.add('active');
            }
        }

        function initiateGoogleLogin() {
            const mockEmail = prompt("Enter Mock Google Email (for testing sandbox):", "operator@bitespeed.in");
            if (mockEmail) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'login';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'googleEmail';
                input.value = mockEmail;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
