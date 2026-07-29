<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.daoimplementation.RestaurantDAOImpl"%>
<%@ page import="java.util.List"%>

<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="java.util.List"%>

<%-- 
List<Restaurant> restaurants = restaurantDAO.getAllRestaurants(); 
--%>
<%
RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
List<Restaurant> restaurants = restaurantDAO.getAllRestaurants(); 

java.util.Map<Integer, com.tap.model.CartItem> restCart = (java.util.Map<Integer, com.tap.model.CartItem>) session.getAttribute("cart");
int restCartCount = 0;
if (restCart != null) {
    for (com.tap.model.CartItem item : restCart.values()) {
        restCartCount += item.getQuantity();
    }
}
%>


<!DOCTYPE html>
<html lang="en">

<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSpeed Restaurants — Browse Top Hubs</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/auth.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/restaurant.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="noise"></div>

    <!-- HEADER -->
    <header id="hdr">
        <a href="<%=request.getContextPath()%>/index.jsp" class="logo">
            <div class="logo-dot"></div>
            BiteSpeed
        </a>
        <nav>
            <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link">Home</a>
            <a href="<%=request.getContextPath()%>/restaurants.jsp" class="nav-link active">Restaurants</a>
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
                <% 
                    com.tap.model.User loggedUser = (com.tap.model.User) session.getAttribute("user");
                    if (loggedUser != null) { 
                %>
                    <span class="user-greeting" style="color:var(--text-glow); font-weight:500; margin-right:15px;">Hi, <%= loggedUser.getFullName() %></span>
                    <a href="<%=request.getContextPath()%>/profile.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Profile</a>
                    <% if ("ADMIN".equalsIgnoreCase(loggedUser.getRole())) { %>
                    <a href="<%=request.getContextPath()%>/admin/orders.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Admin</a>
                    <% } %>
                    <a href="<%=request.getContextPath()%>/logout" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">Logout</a>
                <% } else { %>
                    <a href="<%=request.getContextPath()%>/login.jsp" class="auth-btn" style="text-decoration:none; margin-right:10px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign In</a>
                    <a href="<%=request.getContextPath()%>/register.jsp" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">Sign Up</a>
                <% } %>
            </div>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="cart-btn" style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                Cart <span class="cbadge" id="cbadge"><%= restCartCount %></span>
            </a>
            <button class="hamburger" id="hbg" onclick="toggleMnav()">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    
        <!-- Restaurants -->
    

	<section class="section-pad">


		<div class="container">


			<h1 class="section-title">Best Restaurants</h1>


			<p class="section-sub">Explore delicious food from top
				restaurants.</p>



			<div class="rcards">



				<%
				if (restaurants != null && !restaurants.isEmpty()) {

					for (Restaurant restaurant : restaurants) {
				%>



				<article class="rcard">


					<div class="rcard-img">
						<%
							String rImg = restaurant.getImage();
							if (rImg == null || rImg.trim().isEmpty()) {
								rImg = "empire.png";
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
						<img
							src="<%= rImgUrl %>"
							alt="<%=restaurant.getRestaurantName()%>"
							onerror="this.src='<%=request.getContextPath()%>/images/empire.png';" />



						<span class="rcard-badge" style="<%= restaurant.isActive() ? "background:rgba(34,197,94,0.2); color:#22c55e; border:1px solid #22c55e;" : "background:rgba(239,68,68,0.2); color:#ef4444; border:1px solid #ef4444;" %>">
							<%= restaurant.isActive() ? "🟢 OPEN FOR ORDERS" : "🔴 CLOSED / INACTIVE" %>
						</span>

					</div>

					<div class="rcard-body">

						<div class="rcard-top">

							<h3>
								<%=restaurant.getRestaurantName()%>
							</h3>

							<span class="rrating"> ⭐ <%=restaurant.getRating()%>
							</span>

						</div>

						<p>
							<%=restaurant.getDescription()%>
						</p>

						<div class="rmeta">
							<span> 📍 <%=restaurant.getCity()%> </span> 
							<span> <%= restaurant.getCuisineType() != null ? restaurant.getCuisineType() : "Gourmet" %> </span>
						</div>
						
						<% if (restaurant.isActive()) { %>
							<button onclick="location.href='<%=request.getContextPath()%>/menu?restaurantId=<%=restaurant.getRestaurantId()%>'">
								View Menu & Order →
							</button>
						<% } else { %>
							<button onclick="location.href='<%=request.getContextPath()%>/menu?restaurantId=<%=restaurant.getRestaurantId()%>'" style="background:rgba(255,255,255,0.08); color:#cbd5e1; border:1px solid rgba(255,255,255,0.2);">
								View Menu (Closed)
							</button>
						<% } %>
				</article>




				<%

    }

}
else{

%>


				<h3>No Restaurants Available</h3>


				<%

}

%>



			</div>


		</div>


	</section>


</body>

</html>