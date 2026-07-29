<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.daoimplementation.MenuDAOImpl" %>
<%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=please_login");
        return;
    }
    
    Integer assignedRestaurantId = (Integer) session.getAttribute("assignedRestaurantId");
    String adminRole = (String) session.getAttribute("adminRole");
    
    RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
    if (assignedRestaurantId == null || assignedRestaurantId <= 0) {
        Restaurant userRest = restaurantDAO.getRestaurantByOwnerId(loggedInUser.getUserId());
        if (userRest != null) {
            assignedRestaurantId = userRest.getRestaurantId();
            session.setAttribute("assignedRestaurantId", assignedRestaurantId);
        }
    }

    List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();
    if ((assignedRestaurantId == null || assignedRestaurantId <= 0) && restaurants != null && !restaurants.isEmpty()) {
        assignedRestaurantId = restaurants.get(0).getRestaurantId();
    }

    boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(adminRole) || 
        ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId <= 0));

    String message = "";
    boolean success = false;

    // Process POST creation
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            String rIdParam = request.getParameter("restaurantId");
            int restId = (rIdParam != null && !rIdParam.trim().isEmpty()) 
                ? Integer.parseInt(rIdParam.trim()) 
                : (assignedRestaurantId != null ? assignedRestaurantId : 1);
            
            String name = request.getParameter("itemName");
            double price = Double.parseDouble(request.getParameter("price"));
            String desc = request.getParameter("description");
            String cat = request.getParameter("category");
            String imgPath = request.getParameter("imagePath");
            boolean isAvail = "on".equals(request.getParameter("isAvailable")) || "true".equals(request.getParameter("isAvailable"));

            Menu m = new Menu();
            m.setRestaurantId(restId);
            m.setItemName(name);
            m.setPrice(price);
            m.setDescription(desc);
            m.setCategory(cat != null ? cat : "Main Course");
            m.setImage(imgPath != null && !imgPath.trim().isEmpty() ? imgPath : "../images/food1.jpg");
            m.setAvailable(isAvail);

            new MenuDAOImpl().addMenu(m);
            message = "Dish Item '" + name + "' registered successfully in database!";
            success = true;
        } catch (Exception e) {
            message = "❌ Failed to add dish item: " + e.getMessage();
            success = false;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Resto-Dish Item — BiteSpeed Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body { background-color: #0b0f17; color: #ecf0f1; font-family: 'Outfit', sans-serif; padding: 40px 20px; }
        .admin-card { background: rgba(16, 24, 40, 0.85); border: 1px solid rgba(0, 240, 255, 0.25); padding: 35px; border-radius: 14px; max-width: 650px; margin: 0 auto; box-shadow: 0 10px 35px rgba(0,0,0,0.6); }
        h1 { color: #00f0ff; text-shadow: 0 0 10px rgba(0,240,255,0.3); margin-top: 0; font-size: 1.8rem; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .full-width { grid-column: span 2; }
        .form-group { margin-bottom: 14px; text-align: left; }
        .form-group label { display: block; margin-bottom: 6px; font-size: 0.82rem; color: #94a3b8; text-transform: uppercase; font-weight: 600; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px 14px; background: rgba(255,255,255,0.06); border: 1px solid rgba(0,240,255,0.3); border-radius: 6px; color: #fff; font-family: 'Outfit', sans-serif; box-sizing: border-box; font-size: 0.95rem; }
        
        /* FIX FOR MENU CATEGORY DROPDOWN VISIBILITY */
        .form-group select option { background-color: #101828 !important; color: #ecf0f1 !important; padding: 10px; font-size: 0.95rem; }
        
        .btn-save { background: linear-gradient(135deg, #00f0ff, #0088ff); color: #0b0f17; padding: 14px 28px; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; font-size: 16px; width: 100%; margin-top: 15px; transition: transform 0.2s, box-shadow 0.2s; }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 4px 20px rgba(0, 240, 255, 0.4); }
        .btn-back { color: #94a3b8; text-decoration: none; display: inline-block; margin-bottom: 20px; font-size: 14px; }
        .btn-back:hover { color: #00f0ff; }
        
        .msg-error { padding: 12px 18px; border-radius: 8px; margin-bottom: 20px; background: rgba(239,68,68,0.15); border: 1px solid #ef4444; color: #ef4444; font-weight: 500; }
        
        /* SUCCESS BANNER CARD & 2 OPTIONS */
        .success-card { text-align: center; padding: 30px 20px; background: rgba(0, 240, 255, 0.05); border: 1px solid #00f0ff; border-radius: 12px; margin-bottom: 20px; }
        .success-badge { display: inline-block; background: #22c55e; color: #0b0f17; font-weight: 800; padding: 6px 16px; border-radius: 20px; font-size: 0.85rem; letter-spacing: 0.5px; margin-bottom: 12px; }
        .success-card h2 { color: #fff; margin: 10px 0; font-size: 1.5rem; }
        .btn-options-container { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; margin-top: 25px; }
        .btn-option { padding: 12px 24px; border-radius: 8px; font-weight: 700; text-decoration: none; font-size: 0.95rem; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 8px; cursor: pointer; }
        .btn-option.primary { background: #00f0ff; color: #0b0f17; box-shadow: 0 4px 15px rgba(0,240,255,0.3); }
        .btn-option.primary:hover { opacity: 0.9; transform: translateY(-2px); }
        .btn-option.secondary { background: rgba(255,255,255,0.1); color: #fff; border: 1px solid rgba(255,255,255,0.2); }
        .btn-option.secondary:hover { background: rgba(255,255,255,0.2); color: #00f0ff; border-color: #00f0ff; }
        
        /* IMAGE TABS & PREVIEW */
        .tab-btn { background: rgba(255,255,255,0.05); border: 1px solid rgba(0,240,255,0.2); color: #94a3b8; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; }
        .tab-btn.active { background: rgba(0,240,255,0.2); color: #00f0ff; border-color: #00f0ff; }
        .image-preview-container { display: flex; gap: 15px; align-items: center; background: rgba(255,255,255,0.03); border: 1px dashed rgba(0,240,255,0.3); padding: 12px; border-radius: 8px; margin-top: 12px; }
        .preview-img { width: 85px; height: 85px; object-fit: cover; border-radius: 8px; border: 1px solid #00f0ff; background: #000; }
        .preset-gallery { display: flex; gap: 8px; overflow-x: auto; padding-top: 8px; }
        .preset-thumb { width: 44px; height: 44px; object-fit: cover; border-radius: 6px; border: 1px solid rgba(255,255,255,0.2); cursor: pointer; transition: transform 0.2s; }
        .preset-thumb:hover { transform: scale(1.1); border-color: #00f0ff; }
    </style>
</head>
<body>
    <div class="admin-card">
        <a href="menus.jsp" class="btn-back">← Back to Menu Cards</a>
        
        <% if (success) { %>
            <div class="success-card">
                <div class="success-badge">✅ ADD SUCCESSFUL</div>
                <h2>Dish Item Registered!</h2>
                <p style="color:#cbd5e1; font-size:1rem; margin:0;"><%= message %></p>
                
                <div class="btn-options-container">
                    <a href="addMenu.jsp" class="btn-option primary">➕ Add More Dishes</a>
                    <a href="menus.jsp" class="btn-option secondary">📊 View Menu / Dashboard</a>
                </div>
            </div>
        <% } else { %>
            <h1>+ Add Resto-Dish Item</h1>
            
            <% if (!message.isEmpty()) { %>
                <div class="msg-error"><%= message %></div>
            <% } %>

            <form action="addMenu.jsp" method="POST">
                <div class="form-grid">
                    <% if (isSuperAdmin || assignedRestaurantId == null || assignedRestaurantId <= 0) { %>
                        <div class="form-group full-width">
                            <label>Target Restaurant</label>
                            <select name="restaurantId" required>
                                <% if (restaurants != null) {
                                    for (Restaurant r : restaurants) { %>
                                        <option value="<%= r.getRestaurantId() %>" <%= (assignedRestaurantId != null && assignedRestaurantId == r.getRestaurantId()) ? "selected" : "" %>>
                                            <%= r.getRestaurantName() %> (#<%= r.getRestaurantId() %>)
                                        </option>
                                <%   }
                                   } %>
                            </select>
                        </div>
                    <% } else { %>
                        <input type="hidden" name="restaurantId" value="<%= assignedRestaurantId %>">
                    <% } %>

                    <div class="form-group full-width">
                        <label>Dish Item Name</label>
                        <input type="text" name="itemName" placeholder="e.g. Special Paneer Tikka" required>
                    </div>

                    <div class="form-group">
                        <label>Unit Price (₹)</label>
                        <input type="number" step="0.01" name="price" placeholder="e.g. 240.00" required>
                    </div>

                    <div class="form-group">
                        <label>Menu Category</label>
                        <select name="category" required>
                            <option value="Starters">Starters & Appetizers</option>
                            <option value="Main Course" selected>Main Course</option>
                            <option value="Desserts">Desserts & Sweets</option>
                            <option value="Beverages">Beverages & Drinks</option>
                            <option value="Chef Specials">Chef Specials</option>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label>Dish Description & Ingredients</label>
                        <textarea name="description" rows="3" placeholder="e.g. Fresh cottage cheese marinated in spiced yogurt and grilled to perfection."></textarea>
                    </div>

                    <div class="form-group full-width" style="display:flex; align-items:center;">
                        <label style="margin:0; cursor:pointer; font-size:14px; color:#fff; display:flex; align-items:center; gap:8px;">
                            <input type="checkbox" name="isAvailable" checked style="width:auto;"> Is Available for Ordering
                        </label>
                    </div>

                    <!-- DISH PHOTO OPTIONS: URL OR IMPORT FROM DEVICE -->
                    <div class="form-group full-width">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                            <label style="margin:0;">Dish Photo Source</label>
                            <div style="display:flex; gap:6px;">
                                <button type="button" class="tab-btn active" id="btnUrlTab" onclick="switchImageTab('url')">🔗 Image URL</button>
                                <button type="button" class="tab-btn" id="btnFileTab" onclick="switchImageTab('file')">📁 Import Device</button>
                            </div>
                        </div>

                        <div id="urlSection">
                            <input type="text" id="imageInput" name="imagePath" placeholder="https://... or images/food1.jpg" oninput="updateImagePreview(this.value)">
                        </div>

                        <div id="fileSection" style="display:none;">
                            <input type="file" id="deviceFile" accept="image/*" onchange="handleDeviceFile(this)">
                            <span style="font-size:11px; color:#94a3b8; display:block; margin-top:4px;">Select photo from computer or mobile storage</span>
                        </div>
                        
                        <div class="image-preview-container">
                            <img id="imagePreview" src="<%= request.getContextPath() %>/images/food1.jpg" class="preview-img" alt="Dish Preview" onerror="this.src='<%= request.getContextPath() %>/images/food1.jpg';">
                            <div>
                                <span style="font-size:12px; color:#94a3b8; display:block; margin-bottom:4px;">Quick Select Preset Food Photo:</span>
                                <div class="preset-gallery">
                                    <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Burger">
                                    <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Pizza">
                                    <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=500&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Biryani">
                                    <img src="https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=500&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Dessert">
                                    <img src="https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=500&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Beverage">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-save">+ Register New Dish Item →</button>
            </form>
        <% } %>
    </div>

    <script>
        function updateImagePreview(val) {
            var img = document.getElementById('imagePreview');
            if (val && val.trim() !== '') {
                img.src = val;
            } else {
                img.src = '<%= request.getContextPath() %>/images/food1.jpg';
            }
        }

        function setPresetImg(url) {
            document.getElementById('imageInput').value = url;
            switchImageTab('url');
            updateImagePreview(url);
        }

        function handleDeviceFile(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var dataUrl = e.target.result;
                    document.getElementById('imageInput').value = dataUrl;
                    updateImagePreview(dataUrl);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function switchImageTab(tab) {
            if (tab === 'url') {
                document.getElementById('urlSection').style.display = 'block';
                document.getElementById('fileSection').style.display = 'none';
                document.getElementById('btnUrlTab').classList.add('active');
                document.getElementById('btnFileTab').classList.remove('active');
            } else {
                document.getElementById('urlSection').style.display = 'none';
                document.getElementById('fileSection').style.display = 'block';
                document.getElementById('btnFileTab').classList.add('active');
                document.getElementById('btnUrlTab').classList.remove('active');
            }
        }
    </script>
</body>
</html>