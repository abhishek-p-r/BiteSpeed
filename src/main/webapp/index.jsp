<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ page import="com.tap.model.User" %>
    <%@ page import="com.tap.model.Restaurant" %>
      <%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
        <%@ page import="com.tap.model.Menu" %>
          <%@ page import="com.tap.daoimplementation.MenuDAOImpl" %>
            <%@ page import="java.util.List" %>
              <% User indexUser=(User) session.getAttribute("user"); boolean isUserLoggedIn=(indexUser !=null);
                java.util.Map<Integer, com.tap.model.CartItem> indexCart = (java.util.Map<Integer,
                  com.tap.model.CartItem>) session.getAttribute("cart");
                  int indexCartCount = 0;
                  if (indexCart != null) {
                  for (com.tap.model.CartItem item : indexCart.values()) {
                  indexCartCount += item.getQuantity();
                  }
                  }
                  %>
                  <!doctype html>
                  <html lang="en">

                  <head>
                    <script src="<%=request.getContextPath()%>/js/theme.js" charset="UTF-8"></script>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
                    <title>BiteSpeed — Luxury Food Delivery</title>
                    <link
                      href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap"
                      rel="stylesheet" />
                    <meta name="description"
                      content="BiteSpeed — Luxury food delivery from handpicked restaurants. 30-minute delivery guarantee across India." />
                    <meta property="og:title" content="BiteSpeed — Luxury Food Delivery" />
                    <meta property="og:description" content="Fresh, hot restaurant meals delivered in 30 minutes." />
                    <!-- CSS -->
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/auth.css">
                    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">

                    <!-- Three.js 3D Library -->
                    <script src="<%=request.getContextPath()%>/js/three.min.js" charset="UTF-8"></script>
                    <script>
                      window.contextPath = "<%= request.getContextPath() %>";
                      window.isUserLoggedIn = "<%= isUserLoggedIn %>" === "true";
                    </script>

                    <!-- Smart Loader Control: Show ONLY on manual browser refresh or initial visit -->
                    <script>
                      (function () {
                        try {
                          var navEntries = (performance && performance.getEntriesByType) ? performance.getEntriesByType('navigation') : [];
                          var isReload = navEntries.length > 0 && navEntries[0].type === 'reload';
                          var isFirstVisit = !sessionStorage.getItem('bitespeed_visited');

                          if (!isReload && !isFirstVisit) {
                            // Synchronously hide loader CSS before body renders to eliminate flash
                            document.write('<style>#loader { display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; } body.loading { overflow: auto !important; background: transparent !important; }</style>');
                            document.addEventListener('DOMContentLoaded', function () {
                              document.body.classList.remove('loading');
                              document.body.style.overflow = '';
                              var ldr = document.getElementById('loader');
                              if (ldr) ldr.remove();
                            });
                          } else {
                            sessionStorage.setItem('bitespeed_visited', 'true');
                          }
                        } catch (e) { }
                      })();
                    </script>

                    <!-- Prevent Flash of Unstyled Content while loading -->
                    <style>
                      body.loading {
                        overflow: hidden;
                        background: #050505 !important;
                      }

                      body.loading>*:not(#loader):not(.cursor):not(.cursor-ring):not(.noise) {
                        display: none !important;
                      }

                      /* Hero 3D Canvas */
                      #hero-canvas {
                        width: 100%;
                        max-width: 480px;
                        height: 300px;
                        display: block;
                        border-radius: 12px;
                        cursor: grab;
                        margin: 0 auto;
                      }

                      #hero-canvas:active {
                        cursor: grabbing;
                      }

                      /* Showcase 3D Canvas */
                      #showcase-canvas {
                        width: 100%;
                        max-width: 480px;
                        height: 300px;
                        display: block;
                        border-radius: 12px;
                        cursor: grab;
                        margin: 0 auto;
                      }

                      #showcase-canvas:active {
                        cursor: grabbing;
                      }

                      /* Hide Custom Cursor & Restore Normal Browser Cursor */
                      body {
                        cursor: auto !important;
                      }

                      .cursor,
                      .cursor-ring {
                        display: none !important;
                        pointer-events: none !important;
                      }

                      /* Maze Game Canvas - must have explicit height for WebGL init */
                      #maze-canvas {
                        width: 100%;
                        height: 480px;
                        display: block;
                        border-radius: 10px;
                      }

                      /* Restaurant grid - proper 3-column layout */
                      .rcards {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                        gap: 28px;
                        margin-top: 2rem;
                      }

                      .rcard {
                        border-radius: 16px;
                        overflow: hidden;
                        background: var(--card-bg, #0d1320);
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35);
                        transition: transform 0.3s ease, box-shadow 0.3s ease;
                      }

                      .rcard:hover {
                        transform: translateY(-6px);
                        box-shadow: 0 16px 48px rgba(212, 168, 83, 0.18);
                      }

                      .rcard-img {
                        position: relative;
                        height: 200px;
                        overflow: hidden;
                      }

                      .rcard-img img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                        transition: transform 0.5s ease;
                      }

                      .rcard:hover .rcard-img img {
                        transform: scale(1.08);
                      }

                      .rcard-body {
                        padding: 1.2rem 1.4rem 1.4rem;
                      }

                      .rcard-top {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 0.5rem;
                      }

                      .rcard-top h3 {
                        font-size: 1.1rem;
                        font-weight: 600;
                        color: var(--text-primary, #f0e6d0);
                      }

                      .rrating {
                        color: var(--accent-gold, #d4a853);
                        font-size: 0.9rem;
                        font-weight: 600;
                      }

                      .rcard-badge {
                        position: absolute;
                        top: 12px;
                        left: 12px;
                        background: rgba(10, 15, 30, 0.85);
                        color: #d4a853;
                        font-size: 0.78rem;
                        font-weight: 600;
                        padding: 4px 10px;
                        border-radius: 20px;
                        backdrop-filter: blur(6px);
                        border: 1px solid rgba(212, 168, 83, 0.3);
                      }

                      .rcard-overlay {
                        position: absolute;
                        inset: 0;
                        background: rgba(5, 10, 20, 0.7);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        opacity: 0;
                        transition: opacity 0.3s ease;
                      }

                      .rcard:hover .rcard-overlay {
                        opacity: 1;
                      }

                      .rcard-overlay button {
                        background: var(--accent-gold, #d4a853);
                        color: #000;
                        border: none;
                        padding: 10px 22px;
                        border-radius: 6px;
                        font-weight: 700;
                        cursor: pointer;
                        font-size: 0.9rem;
                      }

                      /* Loader Background Grid Styles */
                      .loader-bg-grid {
                        position: absolute;
                        inset: 0;
                        display: grid;
                        grid-template-columns: repeat(4, 1fr);
                        grid-template-rows: repeat(3, 1fr);
                        gap: 20px;
                        padding: 40px;
                        opacity: 0.12;
                        z-index: 1;
                        pointer-events: none;
                      }

                      .loader-bg-cell {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 16px;
                        background: rgba(255, 255, 255, 0.02);
                        border: 1px solid rgba(212, 168, 83, 0.05);
                        animation: pulseCell 5s ease-in-out infinite;
                        animation-delay: var(--delay);
                      }

                      .loader-bg-cell img {
                        width: 65%;
                        height: 65%;
                        object-fit: contain;
                        filter: grayscale(100%) sepia(30%) brightness(0.6);
                      }

                      @keyframes pulseCell {

                        0%,
                        100% {
                          opacity: 0.25;
                          transform: scale(0.96);
                        }

                        50% {
                          opacity: 0.85;
                          transform: scale(1.02);
                          border-color: rgba(212, 168, 83, 0.18);
                          box-shadow: 0 0 20px rgba(212, 168, 83, 0.08);
                        }
                      }

                      /* Restaurant Card View Menu Styles */
                      .rcard-action {
                        margin-top: 1.2rem;
                      }

                      .btn-view-menu {
                        width: 100%;
                        background: transparent;
                        color: var(--accent-gold, #d4a853);
                        border: 1px solid rgba(212, 168, 83, 0.4);
                        padding: 10px 0;
                        border-radius: 8px;
                        font-family: 'Outfit', sans-serif;
                        font-size: 0.9rem;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        text-align: center;
                        display: block;
                      }

                      .btn-view-menu:hover {
                        background: var(--accent-gold, #d4a853);
                        color: #000;
                        box-shadow: 0 0 15px rgba(212, 168, 83, 0.3);
                      }
                    </style>
                  </head>

                  <body class="loading">
                    <!-- PROMO BANNER REMOVED -->
                    <!-- CURSOR -->
                    <div class="cursor" id="cursor"></div>
                    <div class="cursor-ring" id="cursor-ring"></div>
                    <div class="noise"></div>

                    <!-- LOADER -->
                    <div id="loader">
                      <div class="loader-bg-grid">
                        <div class="loader-bg-cell" style="--delay:0s;"><img
                            src="<%=request.getContextPath()%>/images/dum_biryani.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:1.5s;"><img
                            src="<%=request.getContextPath()%>/images/margherita_pizza.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:3s;"><img
                            src="<%=request.getContextPath()%>/images/paneer_tikka.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:0.5s;"><img
                            src="<%=request.getContextPath()%>/images/sushi_platter.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:2s;"><img
                            src="<%=request.getContextPath()%>/images/butter_chicken.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:3.5s;"><img
                            src="<%=request.getContextPath()%>/images/bacon_cheeseburger.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:1s;"><img
                            src="<%=request.getContextPath()%>/images/masala_dosa.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:2.5s;"><img
                            src="<%=request.getContextPath()%>/images/avocado_salad.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:4s;"><img
                            src="<%=request.getContextPath()%>/images/ramen_bowl.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:0.8s;"><img
                            src="<%=request.getContextPath()%>/images/waffle_fries.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:2.2s;"><img
                            src="<%=request.getContextPath()%>/images/gulab_jamun.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:3.8s;"><img
                            src="<%=request.getContextPath()%>/images/indian_thali.png" alt=""></div>
                        <!-- Repeated to ensure full grid coverage -->
                        <div class="loader-bg-cell" style="--delay:0.3s;"><img
                            src="<%=request.getContextPath()%>/images/dum_biryani.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:1.8s;"><img
                            src="<%=request.getContextPath()%>/images/margherita_pizza.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:3.3s;"><img
                            src="<%=request.getContextPath()%>/images/paneer_tikka.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:0.8s;"><img
                            src="<%=request.getContextPath()%>/images/sushi_platter.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:2.3s;"><img
                            src="<%=request.getContextPath()%>/images/butter_chicken.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:3.8s;"><img
                            src="<%=request.getContextPath()%>/images/bacon_cheeseburger.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:1.3s;"><img
                            src="<%=request.getContextPath()%>/images/masala_dosa.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:2.8s;"><img
                            src="<%=request.getContextPath()%>/images/avocado_salad.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:4.3s;"><img
                            src="<%=request.getContextPath()%>/images/ramen_bowl.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:1.1s;"><img
                            src="<%=request.getContextPath()%>/images/waffle_fries.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:2.5s;"><img
                            src="<%=request.getContextPath()%>/images/gulab_jamun.png" alt=""></div>
                        <div class="loader-bg-cell" style="--delay:4.1s;"><img
                            src="<%=request.getContextPath()%>/images/indian_thali.png" alt=""></div>
                      </div>
                      <div class="loader-cyber-grid"></div>
                      <canvas id="loader-starfield"></canvas>
                      <div class="loader-scanline"></div>

                      <!-- Holographic Portal Rings -->
                      <div class="loader-hologram-ring ring-outer"></div>
                      <div class="loader-hologram-ring ring-mid"></div>
                      <div class="loader-hologram-ring ring-inner"></div>

                      <!-- Telemetry HUD Sidebars -->
                      <div class="loader-hud-panel left-panel">
                        <div class="hud-panel-title">SYSTEM STATUS</div>
                        <div class="hud-panel-row"><span>COURIER:</span> <span class="hud-glow">BITESPEED-ONE</span>
                        </div>
                        <div class="hud-panel-row"><span>VECTOR:</span> <span class="hud-glow">SUB-ORBITAL X4</span>
                        </div>
                        <div class="hud-panel-row"><span>WARP CORE:</span> <span id="hud-val-warp">99.8%</span></div>
                        <div class="hud-panel-row"><span>STABILITY:</span> <span id="hud-val-stab">100.0%</span></div>
                        <div class="hud-panel-row"><span>COORDINATES:</span> <span id="hud-val-coords">45.922 /
                            -89.123</span></div>
                      </div>

                      <div class="loader-hud-panel right-panel">
                        <div class="hud-panel-title">TELEMETRY STREAM</div>
                        <div class="hud-panel-row"><span>FREQUENCY:</span> <span id="hud-val-freq">4.88 GHz</span></div>
                        <div class="hud-panel-row"><span>ALTITUDE:</span> <span id="hud-val-alt">12,440 M</span></div>
                        <div class="hud-panel-row"><span>DENSITY:</span> <span id="hud-val-dens">0.12 kg/m³</span></div>
                        <div class="hud-panel-row"><span>TARGET RANGE:</span> <span id="hud-val-range">14.2 km</span>
                        </div>
                        <div class="hud-panel-row"><span>SIGNAL:</span> <span id="hud-val-sig">100%</span></div>
                      </div>

                      <!-- Sound Control Button -->
                      <button class="loader-sound-toggle" id="loader-sound-toggle" onclick="toggleLoaderSound()">
                        <span class="sound-icon">🔊</span> AUDIO SYNTH ACTIVE
                      </button>

                      <!-- Floating food image cards - Indian & International Cuisine -->
                      <div class="loader-food-cards" id="loader-food-cards">
                        <div class="floating-food-card" style="--delay:0s; --x:-250px; --y:-220px;"><img
                            src="<%=request.getContextPath()%>/images/indian_thali.png" alt="Thali"><span>🍽️ Grand
                            Thali</span></div>
                        <div class="floating-food-card" style="--delay:1.5s; --x:280px; --y:-180px;"><img
                            src="<%=request.getContextPath()%>/images/dum_biryani.png" alt="Biryani"><span>🍲 Dum
                            Biryani</span></div>
                        <div class="floating-food-card" style="--delay:3s; --x:-320px; --y:180px;"><img
                            src="<%=request.getContextPath()%>/images/paneer_tikka.png" alt="Paneer Tikka"><span>🍢
                            Paneer
                            Tikka</span></div>
                        <div class="floating-food-card" style="--delay:4.5s; --x:260px; --y:220px;"><img
                            src="<%=request.getContextPath()%>/images/butter_chicken.png" alt="Butter Chicken"><span>🍛
                            Butter Chicken</span></div>
                        <div class="floating-food-card" style="--delay:6s; --x:60px; --y:-300px;"><img
                            src="<%=request.getContextPath()%>/images/masala_dosa.png" alt="Masala Dosa"><span>🥞 Masala
                            Dosa</span></div>
                        <div class="floating-food-card" style="--delay:7.5s; --x:-180px; --y:80px;"><img
                            src="<%=request.getContextPath()%>/images/gulab_jamun.png" alt="Gulab Jamun"><span>🍨 Gulab
                            Jamun</span></div>
                        <div class="floating-food-card" style="--delay:9s; --x:180px; --y:-80px;"><img
                            src="<%=request.getContextPath()%>/images/indian_thali.png" alt="Indian Curry"><span>🇮🇳
                            Premium Indian</span></div>
                        <div class="floating-food-card" style="--delay:1s; --x:-420px; --y:-80px;"><img
                            src="<%=request.getContextPath()%>/images/margherita_pizza.png" alt="Pizza"><span>🍕
                            Margherita
                            Pizza</span></div>
                        <div class="floating-food-card" style="--delay:2.5s; --x:380px; --y:40px;"><img
                            src="<%=request.getContextPath()%>/images/sushi_platter.png" alt="Sushi"><span>🍣 Sushi
                            Platter</span></div>
                        <div class="floating-food-card" style="--delay:4s; --x:-120px; --y:280px;"><img
                            src="<%=request.getContextPath()%>/images/bacon_cheeseburger.png" alt="Burger"><span>🍔
                            Bacon
                            Burger</span></div>
                        <div class="floating-food-card" style="--delay:5.5s; --x:120px; --y:320px;"><img
                            src="<%=request.getContextPath()%>/images/avocado_salad.png" alt="Salad"><span>🥗 Avocado
                            Salad</span></div>
                        <div class="floating-food-card" style="--delay:7s; --x:-380px; --y:-280px;"><img
                            src="<%=request.getContextPath()%>/images/waffle_fries.png" alt="Fries"><span>🍟 Waffle
                            Fries</span></div>
                        <div class="floating-food-card" style="--delay:8.5s; --x:400px; --y:-300px;"><img
                            src="<%=request.getContextPath()%>/images/ramen_bowl.png" alt="Ramen"><span>🍜 Ramen
                            Bowl</span>
                        </div>
                      </div>
                      <div class="loader-content">
                        <div class="loader-badge">SYSTEM INITIALIZATION</div>
                        <h1 class="loader-logo">BiteSpeed</h1>
                        <div class="loader-sub">QUANTUM GASTROMONY TELEPORTATION COURIER</div>

                        <!-- Cinematic Animation Stage -->
                        <div class="loader-animation-stage" id="loader-animation-stage">
                          <!-- Spaceship -->
                          <div class="cinematic-ship" id="cinematic-ship">
                            <svg viewBox="0 0 100 50" width="100" height="50">
                              <path d="M 15 25 L 45 10 L 75 10 L 95 25 L 75 40 L 45 40 Z" fill="#151e2e"
                                stroke="#d4a853" stroke-width="2" />
                              <path d="M 45 10 L 55 25 L 45 40" fill="none" stroke="#00f0ff" stroke-width="1.5" />
                              <polygon points="5,25 20,18 20,32" fill="#ff6b35" />
                              <rect x="75" y="22" width="10" height="6" rx="2" fill="#00f0ff" class="cockpit-glow" />
                            </svg>
                          </div>
                          <!-- Cargo Pod Box -->
                          <div class="cinematic-box" id="cinematic-box">
                            <div class="box-half box-top">
                              <svg viewBox="0 0 60 30" width="60" height="30">
                                <path d="M 10 30 L 30 10 L 50 30 Z" fill="#1d2e47" stroke="#00f0ff" stroke-width="2" />
                              </svg>
                            </div>
                            <div class="box-half box-bottom">
                              <svg viewBox="0 0 60 30" width="60" height="30">
                                <path d="M 10 0 L 30 20 L 50 0 Z" fill="#1d2e47" stroke="#00f0ff" stroke-width="2" />
                              </svg>
                            </div>
                            <!-- Target dot box glow indicator -->
                            <div class="box-target-dot" id="box-target-dot"></div>
                          </div>
                          <!-- Missile -->
                          <div class="cinematic-missile" id="cinematic-missile"></div>
                          <!-- Laser Blast / Explosion -->
                          <div class="cinematic-explosion" id="cinematic-explosion"></div>
                          <!-- Floating Foods Burst -->
                          <div class="cinematic-burst-foods" id="cinematic-burst-foods">
                            <img src="<%=request.getContextPath()%>/images/margherita_pizza.png"
                              class="burst-food-img pizza" alt="Pizza">
                            <img src="<%=request.getContextPath()%>/images/bacon_cheeseburger.png"
                              class="burst-food-img burger" alt="Burger">
                            <img src="<%=request.getContextPath()%>/images/sushi_platter.png"
                              class="burst-food-img sushi" alt="Sushi">
                          </div>
                          <!-- Revealed 3D model / Holographic drone -->
                          <div class="cinematic-drone-reveal" id="cinematic-drone-reveal">
                            <img src="<%=request.getContextPath()%>/images/delivery_drone.png" alt="Drone">
                          </div>
                        </div>

                        <!-- Welcome text overlay -->
                        <div class="cinematic-welcome-msg" id="cinematic-welcome-msg">
                          WELCOME TO BITESPEED
                        </div>

                        <div class="loader-progress-wrapper">
                          <div class="loader-progress-track">
                            <div class="loader-progress-bar" id="loader-progress-bar"></div>
                          </div>
                          <div class="loader-percentage" id="loader-percentage">00%</div>
                        </div>

                        <div class="loader-terminal" id="loader-terminal">
                          &gt; Accessing sub-orbital space delivery vector...<br>
                          &gt; Warning: Atmospheric turbulence detected...
                        </div>
                      </div>
                    </div>

                    <!-- CART OVERLAY + DRAWER -->
                    <div class="cart-overlay" id="cart-overlay" onclick="toggleCart()"></div>
                    <aside class="cart-drawer" id="cart-drawer">
                      <div class="cart-head">
                        <h3>🛒 Your Order</h3>
                        <button class="ccls" onclick="toggleCart()">✕</button>
                      </div>
                      <div class="cart-items" id="cart-items">
                        <div class="empty-cart">
                          <span>🛒</span>
                          <p>Your cart is empty</p>
                        </div>
                      </div>
                      <div class="cart-foot" id="cart-foot" style="display: none">
                        <div class="ctotal"><span>Total</span><span id="ctotal">₹0</span></div>
                        <button class="btn-checkout" onclick="checkout()">Place Order →</button>
                      </div>
                    </aside>

                    <!-- HEADER -->
                    <header id="hdr">
                      <a href="<%=request.getContextPath()%>/index.jsp" class="logo">
                        <div class="logo-dot"></div>
                        BiteSpeed
                      </a>
                      <nav>
                        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link active">Home</a>
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
                          <% User u=(User) session.getAttribute("user"); if (u !=null) { %>
                            <span class="user-greeting"
                              style="color:var(--text-glow); font-weight:500; margin-right:15px;">Hi, <%=
                                u.getFullName() %>
                            </span>
                            <a href="<%=request.getContextPath()%>/profile.jsp" class="auth-btn"
                              style="text-decoration:none; margin-right: 8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Profile</a>
                            <a href="<%=request.getContextPath()%>/orders.jsp" class="auth-btn"
                              style="text-decoration:none; margin-right: 8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Orders</a>
                            <% if (u.getRole() != null && (u.getRole().equalsIgnoreCase("ADMIN") || u.getRole().equalsIgnoreCase("SUPER_ADMIN") || u.getRole().equalsIgnoreCase("RESTAURANT_ADMIN"))) { %>
                              <a href="<%=request.getContextPath()%>/admin/orders.jsp" class="auth-btn"
                                style="text-decoration:none; margin-right: 8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Admin</a>
                              <% } %>
                                <a href="<%=request.getContextPath()%>/logout" class="auth-btn"
                                  style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Logout</a>
                                <% } else { %>
                                  <a href="<%=request.getContextPath()%>/login.jsp" class="auth-btn"
                                    style="text-decoration:none; margin-right: 10px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign
                                    In</a>
                                  <a href="<%=request.getContextPath()%>/register.jsp" class="auth-btn"
                                    style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign
                                    Up</a>
                                  <% } %>
                        </div>
                        <button class="cart-btn" onclick="toggleCart()">
                          Cart <span class="cbadge" id="cbadge">
                            <%= indexCartCount %>
                          </span>
                        </button>
                        <button class="hamburger" id="hbg" onclick="toggleMnav()">
                          <span></span><span></span><span></span>
                        </button>
                      </div>
                    </header>
                    <div class="mnav" id="mnav">
                      <a href="<%=request.getContextPath()%>/index.jsp" onclick="closeMnav()">Home</a>
                      <a href="<%=request.getContextPath()%>/restaurants.jsp" onclick="closeMnav()">Restaurants</a>
                      <a href="<%=request.getContextPath()%>/menu.jsp" onclick="closeMnav()">Menu</a>
                      <a href="<%=request.getContextPath()%>/cart.jsp" onclick="closeMnav()">Cart</a>
                      <a href="<%=request.getContextPath()%>/orders.jsp" onclick="closeMnav()">Orders</a>
                      <a href="<%=request.getContextPath()%>/profile.jsp" onclick="closeMnav()">Profile</a>
                    </div>

                    <!-- HERO -->
                    <section id="home" class="hero">
                      <div class="hero-bg"></div>
                      <canvas class="hero-particles" id="particles"></canvas>
                      <div class="hero-content">
                        <div class="hbadge">
                          <div class="hbadge-dot"></div>
                          ⚡ 30-Minute Delivery Guarantee
                        </div>
                        <h1 class="hero-title">
                          <em>Extraordinary</em><br />
                          <strong>Food Delivered</strong><br />
                          to Your Door
                        </h1>
                        <p class="hero-sub">
                          From handpicked local restaurants to your doorstep — fresh, hot, and
                          delivered in minutes. Experience dining reimagined.
                        </p>
                        <div class="hero-cta">
                          <a href="#menu" class="btn-primary">Explore Menu ↓</a>
                          <a href="#restaurants" class="btn-ghost">Top Restaurants</a>
                        </div>
                        <div class="hero-stats">
                          <div class="hstat">
                            <div class="hstat-n">500+</div>
                            <div class="hstat-l">Restaurants</div>
                          </div>
                          <div class="hstat-div"></div>
                          <div class="hstat">
                            <div class="hstat-n">50K+</div>
                            <div class="hstat-l">Happy Customers</div>
                          </div>
                          <div class="hstat-div"></div>
                          <div class="hstat">
                            <div class="hstat-n">4.9★</div>
                            <div class="hstat-l">Avg Rating</div>
                          </div>
                        </div>
                      </div>
                      <div class="hero-visual">
                        <div class="hero-visual-container">
                          <img id="hero-img" src="<%= request.getContextPath() %>/images/indian_thali.png"
                            alt="Grand Thali" class="hero-food-img">
                        </div>
                      </div>
                    </section>

                    <!-- MARQUEE -->
                    <div class="marquee-strip">
                      <div class="marquee-track" id="mtrack"></div>
                    </div>

                    <!-- ABOUT -->
                    <section id="about" class="section-pad">
                      <div class="container">
                        <div class="about-grid reveal">
                          <div class="about-imgs">
                            <img
                              src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=700&auto=format&fit=crop&q=85"
                              alt="Restaurant kitchen" class="aimg-main" />
                            <img
                              src="https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&auto=format&fit=crop&q=80"
                              alt="Chef at work" class="aimg-sm" />
                            <div class="about-tag">Est. 2026</div>
                          </div>
                          <div class="about-text">
                            <div class="gold-line"></div>
                            <p class="eyebrow">Our Story</p>
                            <h2 class="section-title">
                              Redefining Food Delivery, <em>One Bite at a Time</em>
                            </h2>
                            <p>
                              Founded in 2026, BiteSpeed bridges passionate culinary creators
                              and hungry food lovers. We partner exclusively with top-rated
                              eateries, maintaining strict hygiene protocols and deploying a
                              state-of-the-art delivery fleet.
                            </p>
                            <p>
                              Every delivery is a promise — fresh, hot, full of flavor. Our
                              riders are trained to be swift and careful, so restaurant-quality
                              meals arrive perfectly at your door.
                            </p>
                            <div class="chips">
                              <span class="chip">🌿 Organic First</span>
                              <span class="chip">🚴 30-min Delivery</span>
                              <span class="chip">🔥 Always Hot</span>
                              <span class="chip">⭐ Top Rated</span>
                              <span class="chip">🛡️ Safe & Hygienic</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </section>

                    <!-- 3D FOOD SHOWCASE -->
                    <section class="showcase">
                      <div class="container">
                        <div class="showcase-header reveal">
                          <p class="eyebrow">Interactive 3D Showcase</p>
                          <h2 class="section-title">See Your Food <em>Before You Order</em></h2>
                          <p class="section-sub" style="margin: 0 auto">
                            Drag to spin &amp; explore premium Indian dishes in stunning 3D — experience food like never
                            before!
                          </p>
                        </div>
                        <div class="showcase-img-container">
                          <img id="showcase-img" src="<%= request.getContextPath() %>/images/paneer_tikka.png"
                            alt="Paneer Tikka" class="showcase-food-img">
                        </div>
                        <div class="showcase-controls">
                          <button class="sctrl active" onclick="setDish(0, this)">🍢 Paneer Tikka</button>
                          <button class="sctrl" onclick="setDish(1, this)">🍲 Dum Biryani</button>
                          <button class="sctrl" onclick="setDish(2, this)">🥞 Masala Dosa</button>
                          <button class="sctrl" onclick="setDish(3, this)">🍨 Gulab Jamun</button>
                          <button class="sctrl" onclick="setDish(4, this)">🍛 Butter Chicken</button>
                        </div>
                        <p class="sc-hint">
                          Drag to rotate · Scroll to zoom · Double-click to reset
                        </p>
                      </div>
                    </section>

                    <!-- 3D DELIVERY MAZE GAME -->
                    <section id="maze-section" class="maze-section section-pad">
                      <div class="container">
                        <div class="maze-header reveal">
                          <p class="eyebrow">Interactive Space Delivery</p>
                          <h2 class="section-title">Cyber Gastronomy <em>Delivery Maze</em></h2>
                          <p class="section-sub" style="margin: 0 auto 2rem">
                            Guide the BiteSpeed quantum delivery drone through the neon cyber-maze to beam coffee and
                            meals
                            directly to
                            the customer waiting at the lounge!
                          </p>
                        </div>

                        <div class="maze-wrapper">
                          <div class="maze-canvas-wrapper">
                            <canvas id="maze-canvas"></canvas>

                            <!-- Floating game controls overlay -->
                            <div class="maze-ui-controls">
                              <button onclick="zoomGame(0.85)" title="Zoom In">🔍﹢</button>
                              <button onclick="zoomGame(1.15)" title="Zoom Out">🔍﹣</button>
                              <button onclick="toggleGameFullscreen()" title="Toggle Fullscreen">⛶</button>
                            </div>

                            <!-- Floating game notifications -->
                            <div class="game-toast" id="game-toast"></div>

                            <!-- Game overlay screen -->
                            <div class="maze-overlay" id="maze-overlay">
                              <div class="maze-start-screen" id="maze-start-screen">
                                <div class="maze-drone-icon">🛸</div>
                                <h3>Warp Drive Delivery</h3>
                                <p>Navigate the spaceship using ARROWS / WASD or the buttons below. Deliver hot coffee
                                  and
                                  food to the
                                  lounge at the center of the grid.</p>
                                <button class="btn-primary" onclick="startMazeGame()">Launch Mission</button>
                              </div>

                              <div class="maze-win-screen" id="maze-win-screen" style="display: none;">
                                <div class="maze-win-icon">🎉</div>
                                <h3>Delivery Complete!</h3>
                                <p>The food was delivered fresh, hot, and with perfect quantum stability. The client is
                                  fully satisfied!
                                </p>
                                <div class="maze-reward">
                                  <small>UNLOCKED PROMO CODE</small>
                                  <div class="maze-code" id="maze-code" onclick="copyMazeCode()">MAZE50</div>
                                  <small class="click-copy-hint">Click code to copy (₹150 OFF + Free Delivery)</small>
                                </div>
                                <button class="btn-primary" onclick="restartMazeGame()">Play Again</button>
                              </div>
                            </div>
                          </div>

                          <!-- HUD & Controls -->
                          <div class="maze-hud">
                            <div class="hud-item">
                              <span class="hud-label">Battery Charge</span>
                              <div class="hud-bar-container">
                                <div class="hud-bar" id="hud-battery" style="width: 100%"></div>
                              </div>
                            </div>
                            <div class="hud-item">
                              <span class="hud-label">Signal Stability</span>
                              <div class="hud-bar-container">
                                <div class="hud-bar" id="hud-signal" style="width: 100%"></div>
                              </div>
                            </div>
                            <div class="hud-item speed">
                              <span class="hud-label">Warp Velocity</span>
                              <div class="hud-val" id="hud-velocity">0.0 km/s</div>
                            </div>
                          </div>

                          <!-- On-Screen Controls for mobile/mouse users -->
                          <div class="maze-controls">
                            <div class="mctrl-row">
                              <button class="mctrl-btn up" id="mctrl-up">▲</button>
                            </div>
                            <div class="mctrl-row">
                              <button class="mctrl-btn left" id="mctrl-left">◀</button>
                              <button class="mctrl-btn down" id="mctrl-down">▼</button>
                              <button class="mctrl-btn right" id="mctrl-right">▶</button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </section>

                    <!-- RESTAURANTS -->
                    <section id="restaurants" class="section-pad">
                      <div class="container">
                        <p class="eyebrow">Handpicked For You</p>
                        <h2 class="section-title">
                          Best &amp; Top Featured <em>Restaurants</em>
                        </h2>
                        <p class="section-sub">
                          Our community's highest-rated dining spots — chosen for outstanding
                          quality, speed, and exceptional taste.
                        </p>
                        <div class="rcards">
                          <% List<Restaurant> dbRestaurants = new RestaurantDAOImpl().getAllRestaurants();
                            if (dbRestaurants != null && !dbRestaurants.isEmpty()) {
                            for (Restaurant restaurant : dbRestaurants) {
                            String emoji = "🍽️";
                            String ctype = restaurant.getCuisineType().toLowerCase();
                            if (ctype.contains("italian")) emoji = "🇮🇹";
                            else if (ctype.contains("american")) emoji = "🍔";
                            else if (ctype.contains("healthy") || ctype.contains("salad")) emoji = "🥗";
                            else if (ctype.contains("japanese") || ctype.contains("sushi")) emoji = "🍣";
                            else if (ctype.contains("chinese")) emoji = "🇨🇳";
                            else if (ctype.contains("indian")) emoji = "🇮🇳";
                            %>
                            <article class="rcard reveal">
                              <%
                                String rImg = restaurant.getImage();
                                if (rImg == null || rImg.trim().isEmpty()) {
                                    rImg = "restaurant1.jpg";
                                } else {
                                    rImg = rImg.trim();
                                    if (rImg.startsWith("images/") || rImg.startsWith("images\\")) {
                                        rImg = rImg.substring(7);
                                    }
                                }
                                String rImgUrl = (rImg.startsWith("http://") || rImg.startsWith("https://") || rImg.startsWith("/"))
                                    ? rImg
                                    : request.getContextPath() + "/images/" + rImg;
                              %>
                              <div class="rcard-img">
                                <img src="<%= rImgUrl %>"
                                  alt="<%= restaurant.getRestaurantName() %>"
                                  onerror="this.src='<%= request.getContextPath() %>/images/restaurant1.jpg';">
                                <span class="rcard-badge">
                                  <%= emoji %>
                                    <%= restaurant.getCuisineType() %>
                                </span>
                              </div>

                              <div class="rcard-body">
                                <div class="rcard-top">
                                  <h3>
                                    <%= restaurant.getRestaurantName() %>
                                  </h3>
                                  <span class="rrating">
                                    ⭐ <%= restaurant.getRating() %>
                                  </span>
                                </div>

                                <p>
                                  Enjoy premium <%= restaurant.getCuisineType() %> delicacies crafted by world-class
                                    culinary experts at <%= restaurant.getRestaurantName() %>.
                                </p>

                                <div class="rcard-action">
                                  <button class="btn-view-menu"
                                    onclick="location.href='<%= request.getContextPath() %>/menu?restaurantId=<%= restaurant.getRestaurantId() %>'">
                                    View Menu
                                  </button>
                                </div>
                              </div>
                            </article>
                            <% } } else { %>
                              <h3>No active restaurant hubs detected in database coordinates.</h3>
                              <% } %>
                        </div>
                      </div>
                    </section>

                    <!-- FOOD MENU -->
                    <section id="menu" class="section-pad" style="background: var(--deep)">
                      <div class="container">
                        <p class="eyebrow">Fan Favourites</p>
                        <h2 class="section-title">Popular Food <em>Items</em></h2>
                        <p class="section-sub">
                          Freshly prepared to order — our customers' absolute favorites.
                        </p>
                        <div class="filter-tabs">
                          <button class="ftab active" onclick="filterFood(this, 'all')">
                            🍽️ All Items
                          </button>
                          <button class="ftab" onclick="filterFood(this, 'indian')">
                            🇮🇳 Indian
                          </button>
                          <button class="ftab" onclick="filterFood(this, 'southindian')">
                            🥞 South Indian
                          </button>
                          <button class="ftab" onclick="filterFood(this, 'snacks')">
                            🥙 Snacks
                          </button>
                          <button class="ftab" onclick="filterFood(this, 'healthy')">
                            🥗 Healthy
                          </button>
                        </div>
                        <div class="food-grid" id="food-grid">
                          <% List<Menu> dbMenus = new MenuDAOImpl().getAllMenus();
                            if (dbMenus != null && !dbMenus.isEmpty()) {
                            for (Menu m : dbMenus) {
                            String cuisineCat = "indian"; // default: Indian
                            String itemNameLower = m.getItemName().toLowerCase();
                            // South Indian
                            if (itemNameLower.contains("dosa") || itemNameLower.contains("idli")
                            || itemNameLower.contains("vada") || itemNameLower.contains("uttapam")
                            || itemNameLower.contains("upma") || itemNameLower.contains("sambhar")) {
                            cuisineCat = "southindian";
                            // Snacks
                            } else if (itemNameLower.contains("samosa") || itemNameLower.contains("pakora")
                            || itemNameLower.contains("chaat") || itemNameLower.contains("tikki")
                            || itemNameLower.contains("bhel") || itemNameLower.contains("kachori")
                            || itemNameLower.contains("roll") || itemNameLower.contains("sandwich")
                            || itemNameLower.contains("puri") || itemNameLower.contains("veg roll")) {
                            cuisineCat = "snacks";
                            // Healthy
                            } else if (itemNameLower.contains("salad") || itemNameLower.contains("raita")
                            || itemNameLower.contains("fruit") || itemNameLower.contains("smoothie")
                            || itemNameLower.contains("juice") || itemNameLower.contains("bowl")) {
                            cuisineCat = "healthy";
                            // Indian main course (biryani, curries, etc.)
                            } else if (itemNameLower.contains("biryani") || itemNameLower.contains("curry")
                            || itemNameLower.contains("paneer") || itemNameLower.contains("tikka")
                            || itemNameLower.contains("naan") || itemNameLower.contains("roti")
                            || itemNameLower.contains("dal") || itemNameLower.contains("masala")
                            || itemNameLower.contains("tandoori") || itemNameLower.contains("korma")
                            || itemNameLower.contains("butter") || itemNameLower.contains("kebab")
                            || itemNameLower.contains("pulao") || itemNameLower.contains("khichdi")) {
                            cuisineCat = "indian";
                            }
                            %>
                            <article class="fcard reveal" data-cat="<%= cuisineCat %>" style="cursor: pointer;"
                              onclick="location.href='<%= request.getContextPath() %>/menu?restaurantId=<%= m.getRestaurantId() %>'">
                              <%
                                String mImg = m.getImage();
                                if (mImg == null || mImg.trim().isEmpty()) {
                                    mImg = "1.jpg";
                                } else {
                                    mImg = mImg.trim();
                                    if (mImg.startsWith("images/") || mImg.startsWith("images\\")) {
                                        mImg = mImg.substring(7);
                                    }
                                }
                                String mImgUrl = (mImg.startsWith("http://") || mImg.startsWith("https://") || mImg.startsWith("/"))
                                    ? mImg
                                    : request.getContextPath() + "/images/" + mImg;
                              %>
                              <div class="fcard-img">
                                <img src="<%= mImgUrl %>"
                                  alt="<%= m.getItemName() %>"
                                  onerror="this.src='<%= request.getContextPath() %>/images/1.jpg';">
                                <div class="flike" onclick="event.stopPropagation(); toggleLike(this)">♡</div>
                              </div>
                              <div class="fcard-body">
                                <div class="fcard-top">
                                  <h3>
                                    <%= m.getItemName() %>
                                  </h3>
                                  <span class="fprice">₹<%= (int)m.getPrice() %></span>
                                </div>
                                <p>
                                  <%= m.getDescription() !=null && !m.getDescription().trim().isEmpty() ?
                                    m.getDescription() : "Delicious gourmet dish prepared with fresh ingredients." %>
                                </p>
                                <div class="factions" style="margin-top: 15px;">
                                  <button class="btn-primary full"
                                    style="border-radius: 8px; width: 100%; padding: 10px 16px; font-size: 0.88rem;"
                                    onclick="location.href='<%= request.getContextPath() %>/menu?restaurantId=<%= m.getRestaurantId() %>'">
                                    Explore Restaurant Menu →
                                  </button>
                                </div>
                              </div>
                            </article>
                            <% } } else { %>
                              <p>No food items found in database coordinates.</p>
                              <% } %>
                        </div>
                      </div>
                    </section>

                    <!-- TESTIMONIALS -->
                    <section class="section-pad">
                      <div class="container">
                        <p class="eyebrow">What People Say</p>
                        <h2 class="section-title">Loved by <em>Thousands</em></h2>
                        <div class="tgrid">
                          <div class="tcard reveal">
                            <div class="tstars">★★★★★</div>
                            <p>
                              "Absolutely the fastest delivery I've ever experienced. The pizza
                              arrived piping hot and tasted incredible — better than dining in!"
                            </p>
                            <div class="tauthor">
                              <img
                                src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80&auto=format&fit=crop"
                                alt="Rohan M" />
                              <div><strong>Rohan M.</strong><small>Mumbai</small></div>
                            </div>
                          </div>
                          <div class="tcard hl reveal">
                            <div class="tstars">★★★★★</div>
                            <p>
                              "Green Garden is my go-to every morning. Fresh, healthy, delivered
                              before I even finish getting ready. Genuinely life-changing."
                            </p>
                            <div class="tauthor">
                              <img
                                src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=80&auto=format&fit=crop"
                                alt="Priya K" />
                              <div><strong>Priya K.</strong><small>Pune</small></div>
                            </div>
                          </div>
                          <div class="tcard reveal">
                            <div class="tstars">★★★★★</div>
                            <p>
                              "The sushi platter from Golden Dragon is next level. I've ordered
                              it five times this month. Fresh, beautiful, and incredibly fast."
                            </p>
                            <div class="tauthor">
                              <img
                                src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&auto=format&fit=crop"
                                alt="Arjun S" />
                              <div><strong>Arjun S.</strong><small>Bangalore</small></div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </section>

                    <!-- CONTACT -->
                    <section id="contact" class="section-pad" style="background: var(--deep)">
                      <div class="container">
                        <div class="cgrid reveal">
                          <div class="cinfo">
                            <div class="gold-line"></div>
                            <p class="eyebrow">Get In Touch</p>
                            <h2 class="section-title">We'd Love to <em>Hear From You</em></h2>
                            <p>
                              Questions about your order, partnership opportunities, or feedback
                              — we're here 24/7 for you.
                            </p>
                            <div class="clist">
                              <div class="citem">
                                <div class="cicon">📞</div>
                                <div>
                                  <strong>Call Us</strong>
                                  <p>+91 98765 43210</p>
                                </div>
                              </div>
                              <div class="citem">
                                <div class="cicon">📧</div>
                                <div>
                                  <strong>Email Us</strong>
                                  <p>hello@bitespeed.in</p>
                                </div>
                              </div>
                              <div class="citem">
                                <div class="cicon">📍</div>
                                <div>
                                  <strong>Head Office</strong>
                                  <p>Bandra West, Mumbai 400050</p>
                                </div>
                              </div>
                            </div>
                          </div>
                          <div class="cform-wrap">
                            <form class="cform" onsubmit="submitForm(event)">
                              <div class="fg">
                                <label>Full Name</label><input type="text" id="name" placeholder="e.g. Ravi Sharma"
                                  required />
                              </div>
                              <div class="fg">
                                <label>Email Address</label><input type="email" id="email" placeholder="you@example.com"
                                  required />
                              </div>
                              <div class="fg">
                                <label>Mobile Number</label><input type="tel" id="phone" placeholder="+91 XXXXX XXXXX"
                                  required />
                              </div>
                              <div class="fg">
                                <label>Message</label><textarea id="msg" rows="4"
                                  placeholder="Tell us how we can help..."></textarea>
                              </div>
                              <button type="submit" class="btn-primary full">
                                Send Message →
                              </button>
                            </form>
                          </div>
                        </div>
                      </div>
                    </section>

                    <!-- FOOTER -->
                    <footer>
                      <div class="container">
                        <div class="fgrid">
                          <div class="fbrand">
                            <a href="#home" class="logo">
                              <div class="logo-dot"></div>
                              BiteSpeed
                            </a>
                            <p>
                              Bringing joy, one meal at a time. Fresh food delivered fast —
                              every single day across India.
                            </p>
                            <div class="socials">
                              <a href="https://linkedin.com" target="_blank" class="sbtn" aria-label="LinkedIn"><svg
                                  viewBox="0 0 24 24" fill="currentColor">
                                  <path
                                    d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.32 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.79M6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37h2.77z" />
                                </svg></a>
                              <a href="https://twitter.com" target="_blank" class="sbtn" aria-label="X"><svg
                                  viewBox="0 0 24 24" fill="currentColor">
                                  <path
                                    d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                                </svg></a>
                              <a href="https://youtube.com" target="_blank" class="sbtn" aria-label="YouTube"><svg
                                  viewBox="0 0 24 24" fill="currentColor">
                                  <path
                                    d="M23.495 6.205a3.007 3.007 0 0 0-2.088-2.088c-1.87-.501-9.396-.501-9.396-.501s-7.507-.01-9.396.501A3.007 3.007 0 0 0 .527 6.205a31.247 31.247 0 0 0-.522 5.805 31.247 31.247 0 0 0 .522 5.783 3.007 3.007 0 0 0 2.088 2.088c1.868.502 9.396.502 9.396.502s7.506 0 9.396-.502a3.007 3.007 0 0 0 2.088-2.088 31.247 31.247 0 0 0 .5-5.783 31.247 31.247 0 0 0-.5-5.805zM9.609 15.601V8.408l6.264 3.602z" />
                                </svg></a>
                              <a href="https://instagram.com" target="_blank" class="sbtn" aria-label="Instagram"><svg
                                  viewBox="0 0 24 24" fill="currentColor">
                                  <path
                                    d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 1 0 0 12.324 6.162 6.162 0 0 0 0-12.324zM12 16a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm6.406-11.845a1.44 1.44 0 1 0 0 2.881 1.44 1.44 0 0 0 0-2.881z" />
                                </svg></a>
                            </div>
                          </div>
                          <div class="flinks">
                            <h4>Quick Links</h4>
                            <ul>
                              <li><a href="#home">Home</a></li>
                              <li><a href="#about">About Us</a></li>
                              <li><a href="#restaurants">Restaurants</a></li>
                              <li><a href="#menu">Food Menu</a></li>
                              <li><a href="#contact">Contact</a></li>
                            </ul>
                          </div>
                          <div class="flinks">
                            <h4>Support</h4>
                            <ul>
                              <li><a href="#">Track Order</a></li>
                              <li><a href="#">FAQs</a></li>
                              <li><a href="#">Refund Policy</a></li>
                              <li><a href="#">Privacy Policy</a></li>
                              <li><a href="#">Partner With Us</a></li>
                            </ul>
                          </div>
                          <div class="fapp">
                            <h4>Get the App</h4>
                            <p>
                              Order faster on our mobile app — available on iOS and Android.
                            </p>
                            <div class="appbtns">
                              <a href="#" class="abtn">🍎 App Store</a><a href="#" class="abtn">🤖 Play Store</a>
                            </div>
                          </div>
                        </div>
                        <div class="fbottom">
                          <p>© 2026 BiteSpeed Food Delivery Services. All rights reserved.</p>
                          <p>Made with ❤️ in India</p>
                        </div>
                      </div>
                    </footer>

                    <!-- RESTAURANT MENU MODAL -->
                    <div class="modal-bg" id="menu-modal" onclick="bgClose(event, 'menu-modal')">
                      <div class="modal-box">
                        <button class="mclose" onclick="closeModal('menu-modal')">✕</button>
                        <div class="modal-inner" id="modal-content"></div>
                      </div>
                    </div>

                    <!-- ORDER SUCCESS MODAL -->
                    <div class="modal-bg" id="order-modal" onclick="bgClose(event, 'order-modal')">
                      <div class="modal-box order-box">
                        <div class="order-success">
                          <div class="osicon">🎉</div>
                          <h2>Order Placed!</h2>
                          <p>
                            Your food is being prepared.<br />Estimated delivery:
                            <strong>25–30 minutes</strong>
                          </p>
                          <div class="order-id">Order #BS<span id="onum"></span></div>
                          <button class="btn-primary" onclick="closeModal('order-modal')">
                            Track My Order →
                          </button>
                        </div>
                      </div>
                    </div>

                    <!-- LIVE DELIVERY TRACKER WIDGET -->
                    <div class="delivery-tracker" id="delivery-tracker">
                      <div class="dt-header">
                        <span class="dt-icon">🛵</span>
                        <div class="dt-info">
                          <strong>Live Deliveries Near You</strong>
                          <small id="dt-count">Loading...</small>
                        </div>
                        <button class="dt-close"
                          onclick="document.getElementById('delivery-tracker').classList.add('dt-hidden')"
                          aria-label="Close">✕</button>
                      </div>
                      <div class="dt-bar">
                        <div class="dt-fill" id="dt-fill"></div>
                      </div>
                      <p class="dt-label" id="dt-label">Finding restaurants...</p>
                    </div>



                    <!-- USER PROFILE MODAL -->
                    <div class="modal-bg" id="profile-modal" onclick="bgClose(event, 'profile-modal')">
                      <div class="modal-box dashboard-box glass-panel">
                        <button class="mclose" onclick="closeModal('profile-modal')">✕</button>

                        <div class="dashboard-wrapper">
                          <!-- Sidebar Navigation -->
                          <aside class="dashboard-sidebar">
                            <div class="db-user-avatar-wrap">
                              <img src="" alt="Avatar" id="db-user-avatar" class="db-user-avatar" />
                              <div class="db-username-wrap">
                                <span id="db-user-name" class="db-user-name">Loading...</span>
                                <span id="db-user-role" class="db-user-role-badge">USER</span>
                              </div>
                            </div>

                            <nav class="dashboard-nav">
                              <button class="db-nav-btn active" id="db-tab-btn-settings"
                                onclick="switchDbTab('settings')">⚙️ Profile
                                Settings</button>
                              <button class="db-nav-btn" id="db-tab-btn-sessions" onclick="switchDbTab('sessions')">🛡️
                                Active
                                Sessions</button>
                              <button class="db-nav-btn" id="db-tab-btn-history" onclick="switchDbTab('history')">🕒
                                Login
                                History</button>
                              <button class="db-nav-btn signout-btn" onclick="terminateSession()">🚪 Logout
                                System</button>
                            </nav>
                          </aside>

                          <!-- Main Dashboard View Panel -->
                          <main class="dashboard-main-content">
                            <!-- Tab 1: Profile Settings -->
                            <section id="db-tab-settings" class="db-tab-panel active">
                              <h2 class="db-panel-heading">Profile Settings Node</h2>

                              <div class="db-meta-grid">
                                <div class="db-meta-item">
                                  <span class="db-meta-lbl">Email Endpoint</span>
                                  <span class="db-meta-val" id="profile-email-node">Loading...</span>
                                  <span class="verification-badge" id="profile-verified-badge">Verification
                                    Pending</span>
                                </div>
                                <div class="db-meta-item">
                                  <span class="db-meta-lbl">Mobile Vector</span>
                                  <span class="db-meta-val" id="profile-phone-node">Loading...</span>
                                </div>
                                <div class="db-meta-item">
                                  <span class="db-meta-lbl">Auth Service Provider</span>
                                  <span class="db-meta-val text-capitalize" id="profile-provider-node">Loading...</span>
                                </div>
                                <div class="db-meta-item">
                                  <span class="db-meta-lbl">Google Link Node</span>
                                  <div id="profile-google-link-container">
                                    <!-- JS inserts status or link button -->
                                  </div>
                                </div>
                              </div>

                              <div class="db-settings-section">
                                <h3 class="db-section-heading">Update Security Key Credentials</h3>
                                <form id="db-change-password-form" onsubmit="submitChangePassword(event)">
                                  <div class="fg">
                                    <label for="change-curr-pass">Current Password</label>
                                    <input type="password" id="change-curr-pass" placeholder="••••••••" required />
                                  </div>
                                  <div class="fg">
                                    <label for="change-new-pass">New Password</label>
                                    <input type="password" id="change-new-pass" placeholder="Min 8 characters"
                                      required />
                                  </div>
                                  <button type="submit" class="btn-primary sm">Secure Credentials</button>
                                </form>
                              </div>
                            </section>

                            <!-- Tab 2: Active Sessions -->
                            <section id="db-tab-sessions" class="db-tab-panel">
                              <h2 class="db-panel-heading">Active Logged Sessions</h2>
                              <p class="db-panel-sub">Inspect and revoke authorizations targeting other devices /
                                browsers.
                              </p>

                              <div class="db-list-wrapper">
                                <table class="db-table">
                                  <thead>
                                    <tr>
                                      <th>Device Details</th>
                                      <th>IP Vector</th>
                                      <th>Initialized At</th>
                                      <th>Actions</th>
                                    </tr>
                                  </thead>
                                  <tbody id="db-active-sessions-list">
                                    <!-- Loaded dynamically by JS -->
                                  </tbody>
                                </table>
                              </div>
                            </section>

                            <!-- Tab 3: Login History -->
                            <section id="db-tab-history" class="db-tab-panel">
                              <h2 class="db-panel-heading">System Connection Activity</h2>
                              <p class="db-panel-sub">History log of login requests targeting this profile node (Last 10
                                attempts).</p>

                              <div class="db-list-wrapper">
                                <table class="db-table">
                                  <thead>
                                    <tr>
                                      <th>Login Time</th>
                                      <th>IP Coordinates</th>
                                      <th>Client Identifier</th>
                                      <th>Status</th>
                                    </tr>
                                  </thead>
                                  <tbody id="db-login-history-list">
                                    <!-- Loaded dynamically by JS -->
                                  </tbody>
                                </table>
                              </div>
                            </section>
                          </main>
                        </div>
                      </div>
                    </div>

                    <!-- ADMIN DASHBOARD MODAL -->
                    <div class="modal-bg" id="admin-modal" onclick="bgClose(event, 'admin-modal')">
                      <div class="modal-box admin-box glass-panel">
                        <button class="mclose" onclick="closeModal('admin-modal')">✕</button>

                        <div class="admin-wrapper">
                          <h1 class="admin-heading">👑 ADMINISTRATIVE CORE CONTROL</h1>

                          <div class="admin-tabs">
                            <button class="atab active" id="adm-tab-users" onclick="switchAdminTab('users')">👥 Accounts
                              Registry</button>
                            <button class="atab" id="adm-tab-logins" onclick="switchAdminTab('logins')">🔑 Connection
                              Logs</button>
                            <button class="atab" id="adm-tab-otps" onclick="switchAdminTab('otps')">📡 OTP Log
                              History</button>
                            <button class="atab" id="adm-tab-emails" onclick="switchAdminTab('emails')">✉️ Email
                              Logs</button>
                          </div>

                          <div class="admin-content-area">
                            <!-- Users Management Section -->
                            <section id="adm-section-users" class="adm-panel active">
                              <div class="adm-table-wrap">
                                <table class="adm-table">
                                  <thead>
                                    <tr>
                                      <th>ID</th>
                                      <th>Operator Info</th>
                                      <th>Auth Node</th>
                                      <th>Verification</th>
                                      <th>Created At</th>
                                      <th>Last Active</th>
                                      <th>Control Operations</th>
                                    </tr>
                                  </thead>
                                  <tbody id="adm-users-list">
                                    <!-- Loaded dynamically by JS -->
                                  </tbody>
                                </table>
                              </div>

                              <!-- Admin Reset Modal Overlay inside Dashboard -->
                              <div class="admin-reset-panel" id="admin-reset-overlay" style="display:none;">
                                <h3>Modify Operator Node #<span id="reset-user-id-lbl"></span></h3>
                                <form id="admin-reset-form" onsubmit="submitAdminReset(event)">
                                  <div class="fg">
                                    <label for="adm-reset-pass">Force Reset Password</label>
                                    <input type="password" id="adm-reset-pass"
                                      placeholder="Set new password (leave blank to skip)" />
                                  </div>
                                  <div class="fg">
                                    <label>Email Verified Status</label>
                                    <select id="adm-reset-verify">
                                      <option value="1">Verified (Active)</option>
                                      <option value="0">Unverified (Pending)</option>
                                    </select>
                                  </div>
                                  <div class="admin-reset-actions">
                                    <button type="submit" class="btn-primary sm">Update Settings</button>
                                    <button type="button" class="btn-ghost sm"
                                      onclick="closeAdminResetPanel()">Cancel</button>
                                  </div>
                                </form>
                              </div>
                            </section>

                            <!-- Login Activity Logs -->
                            <section id="adm-section-logins" class="adm-panel">
                              <div class="adm-table-wrap">
                                <table class="adm-table">
                                  <thead>
                                    <tr>
                                      <th>Time</th>
                                      <th>Operator Email</th>
                                      <th>IP Coordinates</th>
                                      <th>Session Status</th>
                                      <th>Error Detail</th>
                                      <th>Client Terminal Info</th>
                                    </tr>
                                  </thead>
                                  <tbody id="adm-logins-list">
                                    <!-- Loaded dynamically by JS -->
                                  </tbody>
                                </table>
                              </div>
                            </section>

                            <!-- OTP Dispatch Logs -->
                            <section id="adm-section-otps" class="adm-panel">
                              <div class="adm-table-wrap">
                                <table class="adm-table">
                                  <thead>
                                    <tr>
                                      <th>Created At</th>
                                      <th>Target Email</th>
                                      <th>Verification Type</th>
                                      <th>Attempts</th>
                                      <th>Expires At</th>
                                      <th>Verified Time</th>
                                      <th>Status</th>
                                    </tr>
                                  </thead>
                                  <tbody id="adm-otps-list">
                                    <!-- Loaded dynamically by JS -->
                                  </tbody>
                                </table>
                              </div>
                            </section>

                            <!-- Email Dispatch Logs -->
                            <section id="adm-section-emails" class="adm-panel">
                              <div class="adm-table-wrap">
                                <table class="adm-table">
                                  <thead>
                                    <tr>
                                      <th>Sent At</th>
                                      <th>Recipient Node</th>
                                      <th>Email Subject</th>
                                      <th>Template Type</th>
                                      <th>Delivery Status</th>
                                      <th>Dispatch Error Log</th>
                                    </tr>
                                  </thead>
                                  <tbody id="adm-emails-list">
                                    <!-- Loaded dynamically by JS -->
                                  </tbody>
                                </table>
                              </div>
                            </section>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="toast" id="toast"></div>
                    <button class="scrtop" id="scrtop" onclick="window.scrollTo({ top: 0, behavior: 'smooth' })">
                      ↑
                    </button>
                    <script src="<%=request.getContextPath()%>/js/main.js" charset="UTF-8"></script>
                  </body>

                  </html>