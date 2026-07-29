<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.tap.model.User" %>
        <%@ page import="java.text.SimpleDateFormat" %>
            <%@ page import="java.util.Date" %>
                <% String orderId=request.getParameter("orderId");
                    response.sendRedirect("confirmation.html?orderId=" + (orderId != null ? orderId : ""));
    return;
    
    SimpleDateFormat sdfTime = new SimpleDateFormat(" hh:mm a"); SimpleDateFormat sdfDate=new SimpleDateFormat("dd MMM
                    yyyy"); Date now=new Date(); String placedTimeStr=sdfTime.format(now) + ", " + sdfDate.format(now);
                    // Estimated arrival in 30 minutes Date eta=new Date(now.getTime() + 30 * 60 * 1000); String
                    etaStr=sdfTime.format(eta); // Order confirmed: Clear cart from session completely java.util.Map<?,
                    ?> successCart = (java.util.Map
                    <?, ?>) session.getAttribute("cart");
                    if (successCart != null) {
                    successCart.clear();
                    }
                    session.removeAttribute("cart");
                    session.removeAttribute("cartCount");
                    session.setAttribute("cartCount", 0);
                    int cartCount = 0;
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <script src="<%=request.getContextPath()%>/js/theme.js"></script>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Order Confirmed 🎉 — BiteSpeed</title>
                        <link
                            href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap"
                            rel="stylesheet">
                        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
                        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
                        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
                        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
                        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/order.css">
                        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
                        <style>
                            .order-success-main {
                                margin-top: 120px !important;
                                position: relative;
                                z-index: 10;
                            }

                            #confetti-canvas {
                                position: fixed;
                                inset: 0;
                                pointer-events: none;
                                z-index: 99;
                            }

                            .tracking-card {
                                max-width: 780px;
                                margin: 0 auto;
                                background: rgba(18, 26, 43, 0.85);
                                backdrop-filter: blur(20px);
                                border: 1.5px solid var(--gold);
                                border-radius: 28px;
                                padding: 45px;
                                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.8), 0 0 35px rgba(212, 168, 83, 0.3);
                                position: relative;
                                animation: popIn 0.5s ease;
                            }

                            @keyframes popIn {
                                from {
                                    opacity: 0;
                                    transform: scale(0.92);
                                }

                                to {
                                    opacity: 1;
                                    transform: scale(1);
                                }
                            }

                            .tracking-header {
                                text-align: center;
                                margin-bottom: 30px;
                            }

                            .tracking-header .icon {
                                font-size: 4rem;
                                animation: bounceParty 1.2s ease infinite alternate;
                            }

                            @keyframes bounceParty {
                                0% {
                                    transform: translateY(0) scale(1);
                                }

                                100% {
                                    transform: translateY(-12px) scale(1.1);
                                }
                            }

                            .party-banner {
                                display: inline-block;
                                background: linear-gradient(135deg, rgba(212, 168, 83, 0.2), rgba(0, 240, 255, 0.2));
                                border: 1px solid var(--gold);
                                border-radius: 50px;
                                padding: 6px 20px;
                                font-size: 0.85rem;
                                font-weight: 700;
                                color: var(--gold);
                                letter-spacing: 0.1em;
                                text-transform: uppercase;
                                margin-bottom: 12px;
                            }

                            .timer-badge-container {
                                display: flex;
                                justify-content: space-around;
                                align-items: center;
                                background: rgba(0, 240, 255, 0.05);
                                border: 1px solid rgba(0, 240, 255, 0.25);
                                border-radius: 18px;
                                padding: 22px;
                                margin: 25px 0;
                            }

                            .timer-box {
                                text-align: center;
                            }

                            .timer-box .val {
                                font-family: monospace;
                                font-size: 2.2rem;
                                font-weight: 700;
                                color: #00f0ff;
                                text-shadow: 0 0 16px rgba(0, 240, 255, 0.5);
                            }

                            .timer-box .lbl {
                                font-size: 0.78rem;
                                color: var(--muted);
                                text-transform: uppercase;
                                letter-spacing: 0.08em;
                                margin-top: 4px;
                            }

                            /* Step Tracker Bar */
                            .live-tracker-steps {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                position: relative;
                                margin: 35px 0 25px 0;
                                padding: 0 10px;
                            }

                            .live-tracker-steps::before {
                                content: '';
                                position: absolute;
                                top: 20px;
                                left: 40px;
                                right: 40px;
                                height: 3px;
                                background: rgba(255, 255, 255, 0.1);
                                z-index: 1;
                            }

                            .live-tracker-steps::after {
                                content: '';
                                position: absolute;
                                top: 20px;
                                left: 40px;
                                width: 35%;
                                height: 3px;
                                background: linear-gradient(90deg, #00f0ff, #2ecc71);
                                z-index: 2;
                                box-shadow: 0 0 10px #00f0ff;
                            }

                            .tracker-step {
                                position: relative;
                                z-index: 3;
                                display: flex;
                                flex-direction: column;
                                align-items: center;
                                gap: 8px;
                            }

                            .tracker-circle {
                                width: 44px;
                                height: 44px;
                                border-radius: 50%;
                                background: #111827;
                                border: 2px solid var(--border);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 1.1rem;
                                transition: all 0.3s;
                            }

                            .tracker-step.done .tracker-circle {
                                border-color: #2ecc71;
                                background: rgba(46, 204, 113, 0.2);
                                color: #2ecc71;
                            }

                            .tracker-step.active .tracker-circle {
                                border-color: #00f0ff;
                                background: rgba(0, 240, 255, 0.2);
                                box-shadow: 0 0 15px rgba(0, 240, 255, 0.6);
                                animation: pulseGlow 1.5s infinite;
                            }

                            @keyframes pulseGlow {

                                0%,
                                100% {
                                    box-shadow: 0 0 10px rgba(0, 240, 255, 0.4);
                                }

                                50% {
                                    box-shadow: 0 0 22px rgba(0, 240, 255, 0.8);
                                }
                            }

                            .tracker-label {
                                font-size: 0.8rem;
                                font-weight: 600;
                                color: var(--muted);
                                text-align: center;
                            }

                            .tracker-step.active .tracker-label,
                            .tracker-step.done .tracker-label {
                                color: #fff;
                            }

                            .tracker-time {
                                font-size: 0.72rem;
                                color: var(--muted);
                            }

                            .success-actions {
                                display: flex;
                                gap: 15px;
                                justify-content: center;
                                margin-top: 30px;
                            }

                            @media (max-width: 600px) {
                                .success-actions {
                                    flex-direction: column;
                                }
                            }
                        </style>
                    </head>

                    <body>
                        <canvas id="confetti-canvas"></canvas>
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
                                <button class="theme-btn" id="theme-toggle" onclick="toggleTheme()"
                                    aria-label="Toggle Light/Dark Theme">
                                    <svg class="theme-icon sun" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                                    <svg class="theme-icon moon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                                    </svg>
                                </button>
                                <div id="auth-header-container" class="auth-header-container">
                                    <% if (loggedInUser !=null) { %>
                                        <span class="user-greeting"
                                            style="color:var(--text-glow); font-weight:500; margin-right:15px;">Hi, <%=
                                                loggedInUser.getFullName() %></span>
                                        <a href="<%=request.getContextPath()%>/profile.jsp" class="auth-btn"
                                            style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Profile</a>
                                        <% if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
                                            <a href="<%=request.getContextPath()%>/admin/orders.jsp" class="auth-btn"
                                                style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Admin</a>
                                            <% } %>
                                                <a href="<%=request.getContextPath()%>/logout" class="auth-btn"
                                                    style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Logout</a>
                                                <% } else { %>
                                                    <a href="<%=request.getContextPath()%>/login.jsp" class="auth-btn"
                                                        style="text-decoration:none; margin-right:10px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign
                                                        In</a>
                                                    <a href="<%=request.getContextPath()%>/register.jsp"
                                                        class="auth-btn"
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

                        <main class="order-success-main">
                            <div class="tracking-card">
                                <div class="tracking-header">
                                    <div class="party-banner">🎉 CONGRATULATIONS! ORDER PLACED 🎉</div>
                                    <div class="icon">🥳 🎆 📦</div>
                                    <h1
                                        style="font-family: var(--font-serif); font-size: 2.3rem; color: #fff; margin: 10px 0;">
                                        Order Confirmed & Teleporting!</h1>
                                    <p class="success-sub" style="color: var(--muted);">Your gourmet order has been
                                        successfully registered & dispatched to the kitchen!</p>
                                </div>

                                <!-- LIVE TIMING DISPLAY -->
                                <div class="timer-badge-container">
                                    <div class="timer-box">
                                        <div class="val" id="countdown-timer">29m : 55s</div>
                                        <div class="lbl">Live Delivery Countdown</div>
                                    </div>
                                    <div style="width: 1px; height: 40px; background: rgba(255,255,255,0.15);"></div>
                                    <div class="timer-box">
                                        <div class="val" style="color: var(--gold); font-size: 1.6rem;">
                                            <%= etaStr %>
                                        </div>
                                        <div class="lbl">Estimated Delivery Target</div>
                                    </div>
                                </div>

                                <!-- LIVE STAGE TRACKER STEPPER -->
                                <div class="live-tracker-steps">
                                    <div class="tracker-step done">
                                        <div class="tracker-circle">✓</div>
                                        <div class="tracker-label">Order Placed</div>
                                        <div class="tracker-time">
                                            <%= sdfTime.format(now) %>
                                        </div>
                                    </div>
                                    <div class="tracker-step active">
                                        <div class="tracker-circle">🍳</div>
                                        <div class="tracker-label">Preparing Food</div>
                                        <div class="tracker-time">In Kitchen</div>
                                    </div>
                                    <div class="tracker-step">
                                        <div class="tracker-circle">🛵</div>
                                        <div class="tracker-label">Out for Delivery</div>
                                        <div class="tracker-time">On Way</div>
                                    </div>
                                    <div class="tracker-step">
                                        <div class="tracker-circle">📍</div>
                                        <div class="tracker-label">Delivered</div>
                                        <div class="tracker-time">Target</div>
                                    </div>
                                </div>

                                <div class="order-details-box"
                                    style="background: rgba(255,255,255,0.03); border: 1px solid var(--border); border-radius: 14px; padding: 20px; margin: 25px 0;">
                                    <p style="margin-bottom: 8px;"><strong>Order Tracking Code:</strong> <span
                                            class="highlight"
                                            style="color: var(--gold); font-size: 1.1rem; font-family: monospace;">#BS
                                            <%= orderId !=null ? orderId : "1002" %>
                                        </span></p>
                                    <p style="margin-bottom: 8px;"><strong>Order Placed Timestamp:</strong> <span>
                                            <%= placedTimeStr %>
                                        </span></p>
                                    <p style="margin-bottom: 0;"><strong>Live Kitchen Status:</strong> <span
                                            class="highlight" style="color:#00f0ff; font-weight: 600;">CHEF PREPARING
                                            YOUR MEAL ⚡</span></p>
                                </div>

                                <div class="success-actions">
                                    <% if (orderId !=null && !orderId.isEmpty()) { %>
                                        <a href="orderDetails.jsp?orderId=<%= orderId %>" class="btn-primary"
                                            style="font-size: 1rem; padding: 14px 28px;">
                                            📄 Inspect Placed Order Receipt (#BS<%= orderId %>) →
                                        </a>
                                        <% } %>
                                            <a href="menu.jsp" class="btn-ghost"
                                                style="font-size: 1rem; padding: 14px 24px;">
                                                🍔 Browse All Menus
                                            </a>
                                            <a href="orders.jsp" class="btn-ghost"
                                                style="font-size: 1rem; padding: 14px 24px;">
                                                📜 View Orders History
                                            </a>
                                </div>
                            </div>
                        </main>

                        <script>
                            // Real-time 30-minute countdown timer
                            let totalSeconds = 29 * 60 + 55;
                            function updateTimer() {
                                const minutes = Math.floor(totalSeconds / 60);
                                const seconds = totalSeconds % 60;
                                const timerEl = document.getElementById('countdown-timer');
                                if (timerEl) {
                                    timerEl.textContent = minutes + "m : " + (seconds < 10 ? "0" : "") + seconds + "s";
                                }
                                if (totalSeconds > 0) {
                                    totalSeconds--;
                                }
                            }
                            setInterval(updateTimer, 1000);
                            updateTimer();

                            // Party Confetti & Crackers Fireworks Canvas Effect
                            (function launchConfetti() {
                                const canvas = document.getElementById('confetti-canvas');
                                if (!canvas) return;
                                const ctx = canvas.getContext('2d');
                                canvas.width = window.innerWidth;
                                canvas.height = window.innerHeight;

                                const pieces = [];
                                const colors = ['#00f0ff', '#d4a853', '#ff0055', '#2ecc71', '#ffea00', '#9b59b6', '#ffffff'];

                                for (let i = 0; i < 180; i++) {
                                    pieces.push({
                                        x: Math.random() * canvas.width,
                                        y: Math.random() * canvas.height - canvas.height,
                                        size: Math.random() * 9 + 4,
                                        color: colors[Math.floor(Math.random() * colors.length)],
                                        speedY: Math.random() * 4 + 2,
                                        speedX: (Math.random() - 0.5) * 3,
                                        rotation: Math.random() * 360,
                                        rotSpeed: (Math.random() - 0.5) * 6
                                    });
                                }

                                function animate() {
                                    ctx.clearRect(0, 0, canvas.width, canvas.height);
                                    pieces.forEach(p => {
                                        ctx.save();
                                        ctx.translate(p.x, p.y);
                                        ctx.rotate((p.rotation * Math.PI) / 180);
                                        ctx.fillStyle = p.color;
                                        ctx.fillRect(-p.size / 2, -p.size / 2, p.size, p.size);
                                        ctx.restore();

                                        p.y += p.speedY;
                                        p.x += p.speedX;
                                        p.rotation += p.rotSpeed;

                                        if (p.y > canvas.height) {
                                            p.y = -20;
                                            p.x = Math.random() * canvas.width;
                                        }
                                    });
                                    requestAnimationFrame(animate);
                                }
                                animate();

                                window.addEventListener('resize', () => {
                                    canvas.width = window.innerWidth;
                                    canvas.height = window.innerHeight;
                                });
                            })();
                        </script>
                    </body>

                    </html>