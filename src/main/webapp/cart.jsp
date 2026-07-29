<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.CartItem"%>
<%@ page import="com.tap.model.User"%>
<%@ page import="java.util.Map"%>
<%
User loggedInUser = (User) session.getAttribute("user");
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
    <title>Shopping Cart — BiteSpeed</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/variables.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/components.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/cart.css">
    
    <style>
        .cart-main {
            margin-top: 140px !important;
        }
        
        /* Quantity Selector Styles */
        .qty-selector {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border);
            border-radius: 6px;
            padding: 5px 10px;
            width: fit-content;
            margin-right: 15px;
        }
        .qty-btn {
            background: transparent;
            border: none;
            color: var(--gold);
            font-size: 1.2rem;
            cursor: pointer;
            width: 25px;
            height: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: opacity 0.2s;
        }
        .qty-btn:hover {
            opacity: 0.8;
        }
        .qty-val {
            color: var(--text);
            font-weight: 600;
            font-size: 1rem;
            width: 25px;
            text-align: center;
        }

        /* Other Carts Styles */
        .other-carts-section {
            margin-top: 40px;
            border-top: 1px solid var(--border);
            padding-top: 30px;
        }
        .other-carts-title {
            color: var(--gold);
            font-family: 'Outfit', sans-serif;
            font-size: 1.5rem;
            margin-bottom: 20px;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }
        .other-carts-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        .other-cart-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 20px;
            backdrop-filter: blur(10px);
            transition: transform 0.3s, border-color 0.3s;
        }
        .other-cart-card:hover {
            transform: translateY(-2px);
            border-color: var(--gold-mute);
        }
        .other-cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px dashed rgba(255,255,255,0.1);
            padding-bottom: 10px;
        }
        .other-cart-rest-name {
            font-weight: 700;
            color: var(--text);
            font-size: 1.1rem;
        }
        .other-cart-items-count {
            color: var(--gold);
            font-size: 0.9rem;
            font-weight: 600;
        }
        .other-cart-item-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            color: var(--text-mute);
            margin-bottom: 8px;
        }
        .btn-switch-cart {
            width: 100%;
            margin-top: 15px;
            padding: 10px;
            background: transparent;
            border: 1px solid var(--gold);
            color: var(--gold);
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s, color 0.3s;
            text-align: center;
            text-decoration: none;
            display: block;
        }
        .btn-switch-cart:hover {
            background: var(--gold);
            color: var(--black);
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
			<a href="<%=request.getContextPath()%>/index.jsp" class="nav-link"> Home </a>
			<a href="<%=request.getContextPath()%>/restaurants.jsp" class="nav-link"> Restaurants </a>
			<a href="<%=request.getContextPath()%>/menu.jsp" class="nav-link"> Menu </a>
			<a href="<%=request.getContextPath()%>/cart.jsp" class="nav-link active"> Cart </a>
			<a href="<%=request.getContextPath()%>/orders.jsp" class="nav-link"> Orders </a>
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
				if (loggedInUser != null) {
				%>
					<span class="user-greeting" style="color: var(--text-glow); font-weight: 500; margin-right: 15px;"> Hi, <%=loggedInUser.getFullName()%> </span>
					<a href="<%=request.getContextPath()%>/profile.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;"> Profile </a>
					<% if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
					<a href="<%=request.getContextPath()%>/admin/orders.jsp" class="auth-btn" style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;"> Admin </a>
					<% } %>
					<a href="<%=request.getContextPath()%>/logout" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;"> Logout </a>
				<%
				} else {
				%>
					<a href="<%=request.getContextPath()%>/login.jsp" class="auth-btn" style="text-decoration:none; margin-right:10px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;"> Sign In </a>
					<a href="<%=request.getContextPath()%>/register.jsp" class="auth-btn" style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;"> Sign Up </a>
				<%
				}
				%>
			</div>
			<a href="<%=request.getContextPath()%>/cart.jsp" class="cart-btn" style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
				Cart <span class="cbadge" id="cbadge"><%= cartCount %></span>
			</a>
			<button class="hamburger" id="hbg" onclick="toggleMnav()">
				<span></span><span></span><span></span>
			</button>
		</div>
	</header>






	<main class="cart-main">


		<h1>Gourmet Cart Manifest</h1>





		<%
		if (cart != null && !cart.isEmpty()) {
		%>




		<div class="cart-container">





			<div class="cart-items-panel">





				<%
				for (CartItem item : cart.values()) {
				%>





				<div class="cart-item">





					<%
						String cImg = item.getImagePath();
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
							: request.getContextPath() + "/images/" + cImg;
					%>
					<img src="<%=cImgUrl%>" alt="<%=item.getName()%>"
						onerror="this.src='<%=request.getContextPath()%>/images/1.jpg';">





					<div class="item-info">


						<h3>

							<%=item.getName()%>

						</h3>



						<p class="item-price">

							₹<%=item.getPrice()%>
							each

						</p>


					</div>







					<div class="item-actions">





						<!-- UPDATE QUANTITY -->

						<form action="<%=request.getContextPath()%>/cart" method="POST"
							style="display: inline-block; margin-right: 10px;" id="update-form-<%= item.getMenuId() %>">

							<input type="hidden" name="action" value="update"> <input
								type="hidden" name="itemId" value="<%=item.getMenuId()%>">
							<input type="hidden" name="quantity" id="qty-input-<%= item.getMenuId() %>" value="<%=item.getQuantity()%>">

							<div class="qty-selector">
								<button type="button" class="qty-btn minus" onclick="adjustCartQty('<%= item.getMenuId() %>', -1)">−</button>
								<span class="qty-val"><%= item.getQuantity() %></span>
								<button type="button" class="qty-btn plus" onclick="adjustCartQty('<%= item.getMenuId() %>', 1)">+</button>
							</div>

						</form>








						<!-- REMOVE ITEM -->


						<form action="<%=request.getContextPath()%>/cart" method="POST" style="display: inline-block;">



							<input type="hidden" name="action" value="remove"> <input
								type="hidden" name="itemId" value="<%=item.getMenuId()%>">





							<button type="submit" class="remove-btn">Remove</button>


						</form>





					</div>







					<div class="item-total">


						<span> ₹<%=item.getSubTotal()%>

						</span>


					</div>





				</div>







				<%
				}
				%>







				<!-- CART ACTIONS: ADD MORE ITEMS & CLEAR CART -->
				<div style="display: flex; gap: 15px; align-items: center; margin-top: 20px; flex-wrap: wrap;">
					<a href="<%=request.getContextPath()%>/menu" class="btn-primary" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px; padding: 10px 22px; font-weight: 600;">
						➕ Add More Items
					</a>
					<form action="<%=request.getContextPath()%>/cart" method="POST" style="margin: 0;">
						<input type="hidden" name="action" value="clear">
						<button type="submit" class="btn-clear-cart">Clear Entire Cart</button>
					</form>
				</div>
			</div>










			<!-- ORDER SUMMARY -->


			<div class="cart-summary-panel">


				<h2>Order Summary</h2>





				<div class="summary-row">


					<span> Cart Subtotal </span> <span> ₹<%=total%>
					</span>


				</div>





				<div class="summary-row">


					<span> Delivery Fee </span> <span> FREE </span>


				</div>





				<hr>





				<div class="summary-row total-row">


					<span> Grand Total </span> <span> ₹<%=total%>
					</span>


				</div>







				<%
				if (loggedInUser != null) {
				%>



				<a href="<%=request.getContextPath()%>/checkout" class="btn-checkout-link"> Proceed to
					Checkout → </a>



				<%

}
else{

%>



				<a href="<%=request.getContextPath()%>/login.jsp?error=please_login" class="btn-checkout-link">

					Sign In to Checkout → </a>



				<%

}

%>






			</div>






		</div>







		<%

}
else{

%>







		<div class="empty-cart-view">


			<span> 🛒 </span>



			<p>Your shopping cart is currently empty.</p>




			<a href="menu.jsp" class="btn-primary"> Browse Menu </a>




		</div>







		<%
}
%>



	</main>

	<script>
		function adjustCartQty(itemId, amount) {
			const input = document.getElementById('qty-input-' + itemId);
			const form = document.getElementById('update-form-' + itemId);
			if (input && form) {
				let val = parseInt(input.value) + amount;
				if (val < 1) val = 1;
				input.value = val;
				form.submit();
			}
		}
	</script>

</body>
</html>
