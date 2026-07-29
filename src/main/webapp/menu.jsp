<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<%@ page import="com.tap.model.Restaurant" %>
		<%@ page import="com.tap.model.Menu" %>
			<%@ page import="com.tap.model.User" %>
				<%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
					<%@ page import="com.tap.daoimplementation.MenuDAOImpl" %>
						<%@ page import="java.util.List" %>




							<% User loggedInUser=(User) session.getAttribute("user"); Restaurant restaurant=(Restaurant)
								request.getAttribute("restaurant"); List<Menu> menuList =
								(List<Menu>) request.getAttribute("menuList");
								if (menuList == null || menuList.isEmpty()) {
									try {
										menuList = new MenuDAOImpl().getAllMenus();
									} catch (Exception e) {}
								}

									java.util.Map<Integer, com.tap.model.CartItem> cart =
										(java.util.Map<Integer, com.tap.model.CartItem>) session.getAttribute("cart");
									int cartCount = 0;
									if (cart != null) {
										for (com.tap.model.CartItem ci : cart.values()) {
											cartCount += ci.getQuantity();
										}
									}

									java.util.Set<Integer> topSellingMenuIds = new java.util.HashSet<>();
									try (java.sql.Connection con = com.tap.utility.DBConnection.getConnection()) {
										if (con != null) {
											String tSql = "SELECT menu_id FROM order_items GROUP BY menu_id ORDER BY SUM(quantity) DESC LIMIT 5";
											try (java.sql.Statement st = con.createStatement(); java.sql.ResultSet rs = st.executeQuery(tSql)) {
												while (rs.next()) {
													topSellingMenuIds.add(rs.getInt("menu_id"));
												}
											} catch (Exception ignored) {}
										}
									} catch (Exception ignored) {}
											%>


											<!DOCTYPE html>
											<html lang="en">

											<head>
												<script src="<%=request.getContextPath()%>/js/theme.js"></script>

												<meta charset="UTF-8">

												<meta name="viewport" content="width=device-width, initial-scale=1.0">

												<title>
													<%=restaurant !=null ? restaurant.getRestaurantName() : "Menu" %>
														- BiteSpeed
												</title>

												<link
													href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
													rel="stylesheet">
												<link rel="stylesheet"
													href="<%=request.getContextPath()%>/css/variables.css">
												<link rel="stylesheet"
													href="<%=request.getContextPath()%>/css/base.css">
												<link rel="stylesheet"
													href="<%=request.getContextPath()%>/css/components.css">
												<link rel="stylesheet"
													href="<%=request.getContextPath()%>/css/layout.css">
												<link rel="stylesheet"
													href="<%=request.getContextPath()%>/css/menu.css">
												<link rel="stylesheet"
													href="<%=request.getContextPath()%>/css/style.css">

												<style>
													.menu-main {
														margin-top: 120px !important;
													}

													.qty-selector {
														display: flex;
														align-items: center;
														gap: 10px;
														margin-bottom: 15px;
														background: rgba(255, 255, 255, 0.05);
														border: 1px solid var(--border);
														border-radius: 6px;
														padding: 5px 10px;
														width: fit-content;
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
														background: transparent;
														border: none;
														color: var(--text);
														width: 30px;
														text-align: center;
														font-size: 1rem;
														font-weight: 600;
													}

													.qty-val::-webkit-outer-spin-button,
													.qty-val::-webkit-inner-spin-button {
														-webkit-appearance: none;
														margin: 0;
													}

													.qty-val {
														-moz-appearance: textfield;
													}
												</style>

											</head>

											<body>


												<div class="noise"></div>
												<header id="hdr">

													<a href="<%=request.getContextPath()%>/index.jsp" class="logo">

														<div class="logo-dot"></div> BiteSpeed

													</a>

													<nav>

														<a href="<%=request.getContextPath()%>/index.jsp"
															class="nav-link"> Home </a>
														<a href="<%=request.getContextPath()%>/restaurants.jsp"
															class="nav-link"> Restaurants </a>
														<a href="<%=request.getContextPath()%>/menu.jsp"
															class="nav-link active"> Menu </a>
														<a href="<%=request.getContextPath()%>/cart.jsp"
															class="nav-link"> Cart </a>
														<a href="<%=request.getContextPath()%>/orders.jsp"
															class="nav-link"> Orders </a>

													</nav>

													<div class="hactions">
														<button class="theme-btn" id="theme-toggle"
															onclick="toggleTheme()"
															aria-label="Toggle Light/Dark Theme">
															<svg class="theme-icon sun" viewBox="0 0 24 24" fill="none"
																stroke="currentColor" stroke-width="2"
																stroke-linecap="round" stroke-linejoin="round">
																<circle cx="12" cy="12" r="5"></circle>
																<line x1="12" y1="1" x2="12" y2="3"></line>
																<line x1="12" y1="21" x2="12" y2="23"></line>
																<line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
																<line x1="18.36" y1="18.36" x2="19.78" y2="19.78">
																</line>
																<line x1="1" y1="12" x2="3" y2="12"></line>
																<line x1="21" y1="12" x2="23" y2="12"></line>
																<line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
																<line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
															</svg>
															<svg class="theme-icon moon" viewBox="0 0 24 24" fill="none"
																stroke="currentColor" stroke-width="2"
																stroke-linecap="round" stroke-linejoin="round">
																<path
																	d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z">
																</path>
															</svg>
														</button>

														<div id="auth-header-container" class="auth-header-container">
															<% if(loggedInUser !=null){ %>
																<span class="user-greeting"
																	style="color:var(--text-glow); font-weight:500; margin-right:15px;">
																	Hi, <%=loggedInUser.getFullName()%> </span>
																<a href="<%=request.getContextPath()%>/profile.jsp"
																	class="auth-btn"
																	style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">
																	Profile </a>
																<a href="<%=request.getContextPath()%>/orders.jsp"
																	class="auth-btn"
																	style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">
																	Orders </a>
																<% if (loggedInUser.getRole() != null && (loggedInUser.getRole().equalsIgnoreCase("ADMIN") || loggedInUser.getRole().equalsIgnoreCase("SUPER_ADMIN") || loggedInUser.getRole().equalsIgnoreCase("RESTAURANT_ADMIN")))
																	{ %>
																	<a href="<%=request.getContextPath()%>/admin/orders.jsp"
																		class="auth-btn"
																		style="text-decoration:none; margin-right:8px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">
																		Admin </a>
																	<% } %>
																		<a href="<%=request.getContextPath()%>/logout"
																			class="auth-btn"
																			style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px;">
																			Logout </a>
																		<% } else { %>
																			<a href="<%=request.getContextPath()%>/login.jsp"
																				class="auth-btn"
																				style="text-decoration:none; margin-right:10px; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">
																				Sign In </a>
																			<a href="<%=request.getContextPath()%>/register.jsp"
																				class="auth-btn"
																				style="text-decoration:none; display:inline-block; line-height:36px; height:36px; padding:0 15px; border:1px solid var(--border-neon); border-radius:4px; font-family:'Outfit',sans-serif; font-size:14px; text-align:center;">
																				Sign Up </a>
																			<% } %>
														</div>

														<a href="<%=request.getContextPath()%>/cart.jsp"
															class="cart-btn"
															style="text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
															Cart <span class="cbadge" id="cbadge"><%= cartCount %></span>
														</a>
														<button class="hamburger" id="hbg" onclick="toggleMnav()">
															<span></span><span></span><span></span>
														</button>
													</div>

												</header>

												<main class="menu-main">

													<% if(restaurant !=null){ %>
														.
														<section class="menu-header">

															<div class="menu-header-content">

																<h1>
																	<%=restaurant.getRestaurantName()%>
																	<span style="font-size:0.85rem; padding:4px 12px; border-radius:20px; vertical-align:middle; margin-left:10px; font-weight:700; <%= restaurant.isActive() ? "background:rgba(34,197,94,0.2); color:#22c55e; border:1px solid #22c55e;" : "background:rgba(239,68,68,0.2); color:#ef4444; border:1px solid #ef4444;" %>">
																		<%= restaurant.isActive() ? "🟢 OPEN FOR ORDERS" : "🔴 INACTIVE / CLOSED" %>
																	</span>
																</h1>
																<p class="cuisine-type">
																	<%=restaurant.getCuisineType()%>
																</p>

																<p class="meta">
																	⭐ <%=restaurant.getRating()%> | <%=restaurant.getAddress()%>
																</p>

															</div>

														</section>

														<% if (!restaurant.isActive()) { %>
															<div style="background: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #ef4444; padding: 16px 22px; border-radius: 12px; margin: 20px auto; max-width:1200px; display: flex; align-items: center; gap: 14px; font-weight: 600; box-shadow: 0 4px 20px rgba(239, 68, 68, 0.2);">
																<span style="font-size:1.6rem;">🔴</span>
																<div>
																	<strong style="display:block; color:#fff; font-size:1.05rem; margin-bottom:2px;">RESTAURANT INACTIVE — ORDERS DISABLED</strong>
																	This restaurant is currently set to Inactive. Menu dishes are displayed for browsing only. Placing orders and selecting items is disabled.
																</div>
															</div>
														<% } %>

														<section class="menu-grid">

															<% if(menuList != null && !menuList.isEmpty()){
																for(Menu menu : menuList){ 
																	String rawImg = menu.getImage();
																	String cImgUrl = request.getContextPath() + "/images/food1.jpg";
																	if (rawImg != null && !rawImg.trim().isEmpty()) {
																		rawImg = rawImg.trim();
																		if (rawImg.startsWith("http://") || rawImg.startsWith("https://") || rawImg.startsWith("data:")) {
																			cImgUrl = rawImg;
																		} else if (rawImg.startsWith("/")) {
																			cImgUrl = request.getContextPath() + rawImg;
																		} else if (rawImg.startsWith("../images/")) {
																			cImgUrl = request.getContextPath() + "/images/" + rawImg.substring(10);
																		} else if (rawImg.startsWith("images/") || rawImg.startsWith("images\\")) {
																			cImgUrl = request.getContextPath() + "/" + rawImg;
																		} else {
																			cImgUrl = request.getContextPath() + "/images/" + rawImg;
																		}
																	}
															%>

																<% boolean isBestSeller = topSellingMenuIds != null && topSellingMenuIds.contains(menu.getMenuId()); %>
																<div class="menu-card" style="position:relative;">
																	<% if (isBestSeller) { %>
																		<span style="position:absolute; top:12px; right:12px; background:linear-gradient(135deg,#ff4e50,#f9d423); color:#000; font-weight:800; font-size:0.7rem; padding:4px 10px; border-radius:20px; box-shadow:0 4px 12px rgba(255,78,80,0.5); z-index:5; letter-spacing:0.5px;">🔥 MOST ORDERED</span>
																	<% } %>

																	<div class="menu-img-wrap">

																		<img src="<%= cImgUrl %>"
																			alt="<%=menu.getItemName()%>"
																			onerror="this.src='<%=request.getContextPath()%>/images/1.jpg';">

																	</div>

																	<div class="menu-info">

																		<div class="menu-title-row">

																			<h3>

																				<%=menu.getItemName()%>

																			</h3>

																			<span class="price"> ₹<%=menu.getPrice()%>

																			</span>

																		</div>

																		<p class="description">


																			<%=menu.getDescription()%>


																		</p>

																		<% com.tap.model.CartItem existingItem=(cart
																			!=null) ? cart.get(menu.getMenuId()) : null;
																			int cartQty=(existingItem !=null) ?
																			existingItem.getQuantity() : 0; %>
																			
																			<% if (restaurant.isActive()) { %>
																				<form
																					action="<%=request.getContextPath()%>/cart"
																					method="post"
																					id="qty-form-<%= menu.getMenuId() %>">
																					<input type="hidden" name="itemId"
																						value="<%=menu.getMenuId()%>">
																					<input type="hidden" name="restaurantId"
																						value="<%=restaurant.getRestaurantId()%>">

																					<% if (cartQty==0) { %>
																						<input type="hidden" name="action"
																							value="add">
																						<input type="hidden" name="quantity"
																							value="1">
																						<button type="submit"
																							class="add-to-cart-btn">Add To
																							Cart +</button>
																						<% } else { %>
																							<input type="hidden"
																								name="action" value="update"
																								id="action-<%= menu.getMenuId() %>">
																							<input type="hidden"
																								name="quantity"
																								value="<%= cartQty %>"
																								id="qty-<%= menu.getMenuId() %>">
																							<div class="qty-selector"
																								style="display: flex;">
																								<button type="button"
																									class="qty-btn minus"
																									onclick="submitMenuQtyChange('<%= menu.getMenuId() %>', -1)">−</button>
																								<span class="qty-val">
																									<%= cartQty %>
																								</span>
																								<button type="button"
																									class="qty-btn plus"
																									onclick="submitMenuQtyChange('<%= menu.getMenuId() %>', 1)">+</button>
																							</div>
																							<% } %>
																				</form>
																			<% } else { %>
																				<button type="button" class="add-to-cart-btn" disabled style="background: rgba(255,255,255,0.06); color: #94a3b8; border: 1px solid rgba(255,255,255,0.15); cursor: not-allowed; opacity: 0.7;">
																					🔒 Ordering Closed (Inactive)
																				</button>
																			<% } %>
																	</div>

																</div>


																<% } } else{ %>

																	<div class="empty-menu">



																		<h3>No Menu Items Available</h3>



																	</div>

																	<% } %>


														</section>



														<% } else{ %>


															<div class="error-hub">



																<h3>Restaurant Not Found</h3>



															</div>

															<% } %>

												</main>

												<script>
													function submitMenuQtyChange(itemId, delta) {
														const qtyInput = document.getElementById('qty-' + itemId);
														const actionInput = document.getElementById('action-' + itemId);
														const form = document.getElementById('qty-form-' + itemId);
														if (qtyInput && form) {
															let currentQty = parseInt(qtyInput.value);
															let newQty = currentQty + delta;
															if (newQty <= 0) {
																actionInput.value = 'remove';
															} else {
																qtyInput.value = newQty;
															}
															form.submit();
														}
													}
												</script>

											</body>

											</html>