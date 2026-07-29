<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.daoimplementation.RestaurantDAOImpl" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=please_login");
        return;
    }
    
    Integer assignedRestaurantId = (Integer) session.getAttribute("assignedRestaurantId");
    String adminRole = (String) session.getAttribute("adminRole");
    boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(adminRole) || 
        ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId == 0));

    if (!isSuperAdmin) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String message = "";

    // Process POST creation
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            String name = request.getParameter("restaurantName");
            String desc = request.getParameter("description");
            String cuisine = request.getParameter("cuisineType");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String image = request.getParameter("image");
            double rating = Double.parseDouble(request.getParameter("rating"));
            boolean active = "on".equals(request.getParameter("active")) || "true".equals(request.getParameter("active"));

            Restaurant r = new Restaurant();
            r.setOwnerId(loggedInUser.getUserId());
            r.setRestaurantName(name);
            r.setDescription(desc);
            r.setCuisineType(cuisine);
            r.setPhone(phone);
            r.setEmail(email);
            r.setAddress(address);
            r.setCity(city);
            r.setImage(image != null && !image.trim().isEmpty() ? image : "../images/res.jpeg");
            r.setRating(rating);
            r.setActive(active);
            r.setOpeningTime("09:00 AM");
            r.setClosingTime("11:00 PM");

            new RestaurantDAOImpl().addRestaurant(r);
            message = "🎉 Restaurant '" + name + "' registered successfully!";
        } catch (Exception e) {
            message = "❌ Failed to add restaurant: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Restaurant Hub — BiteSpeed Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body { background-color: #0b0f17; color: #ecf0f1; font-family: 'Outfit', sans-serif; padding: 40px; }
        .admin-card { background: rgba(16, 24, 40, 0.75); border: 1px solid rgba(0, 240, 255, 0.2); padding: 35px; border-radius: 12px; max-width: 680px; margin: 0 auto; box-shadow: 0 8px 32px rgba(0,0,0,0.5); }
        h1 { color: #00f0ff; text-shadow: 0 0 10px rgba(0,240,255,0.3); margin-top: 0; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .full-width { grid-column: span 2; }
        .form-group { margin-bottom: 14px; text-align: left; }
        .form-group label { display: block; margin-bottom: 6px; font-size: 0.82rem; color: #94a3b8; text-transform: uppercase; font-weight: 600; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px 14px; background: rgba(255,255,255,0.05); border: 1px solid rgba(0,240,255,0.2); border-radius: 6px; color: #fff; font-family: 'Outfit', sans-serif; box-sizing: border-box; }
        .btn-save { background: #00f0ff; color: #0b0f17; padding: 14px 28px; border: none; border-radius: 6px; font-weight: 700; cursor: pointer; font-size: 15px; width: 100%; margin-top: 15px; }
        .btn-back { color: #94a3b8; text-decoration: none; display: inline-block; margin-bottom: 20px; font-size: 14px; }
        .msg { padding: 12px 18px; border-radius: 6px; margin-bottom: 20px; background: rgba(0,240,255,0.1); border: 1px solid #00f0ff; color: #00f0ff; }
        
        .image-preview-container { display: flex; gap: 15px; align-items: center; background: rgba(255,255,255,0.03); border: 1px dashed rgba(0,240,255,0.3); padding: 12px; border-radius: 8px; margin-top: 8px; }
        .preview-img { width: 90px; height: 90px; object-fit: cover; border-radius: 8px; border: 1px solid #00f0ff; background: #000; }
        .preset-gallery { display: flex; gap: 8px; overflow-x: auto; padding-top: 8px; }
        .preset-thumb { width: 48px; height: 48px; object-fit: cover; border-radius: 6px; border: 1px solid rgba(255,255,255,0.2); cursor: pointer; }
    </style>
</head>
<body>
    <div class="admin-card">
        <a href="restaurants.jsp" class="btn-back">← Back to Restaurants List</a>
        <h1>+ Add Restaurant Hub</h1>
        
        <% if (!message.isEmpty()) { %>
            <div class="msg"><%= message %></div>
        <% } %>

        <form action="addRestaurant.jsp" method="POST">
            <div class="form-grid">
                <div class="form-group full-width">
                    <label>Restaurant Name</label>
                    <input type="text" name="restaurantName" placeholder="e.g. Royal Punjab Express" required>
                </div>
                
                <div class="form-group full-width">
                    <label>Description</label>
                    <textarea name="description" rows="2" placeholder="Brief tagline or cuisine summary..."></textarea>
                </div>

                <div class="form-group">
                    <label>Cuisine Type</label>
                    <input type="text" name="cuisineType" placeholder="e.g. North Indian, Tandoori" required>
                </div>

                <div class="form-group">
                    <label>City Location</label>
                    <input type="text" name="city" placeholder="e.g. Bengaluru" required>
                </div>

                <div class="form-group full-width">
                    <label>Address</label>
                    <input type="text" name="address" placeholder="Building, Street, Landmark">
                </div>

                <div class="form-group">
                    <label>Contact Phone</label>
                    <input type="text" name="phone" placeholder="e.g. 9876543210">
                </div>

                <div class="form-group">
                    <label>Contact Email</label>
                    <input type="email" name="email" placeholder="e.g. info@restaurant.com">
                </div>

                <div class="form-group">
                    <label>Initial Rating</label>
                    <input type="number" step="0.1" min="1.0" max="5.0" name="rating" value="4.5" required>
                </div>

                <div class="form-group" style="display:flex; align-items:center;">
                    <label style="margin:0; cursor:pointer; font-size:14px; color:#fff; display:flex; align-items:center; gap:8px;">
                        <input type="checkbox" name="active" checked style="width:auto;"> Active / Open for Orders
                    </label>
                </div>

                <div class="form-group full-width">
                    <label>Restaurant Cover Photo URL</label>
                    <input type="text" id="imageInput" name="image" placeholder="https://..." oninput="updateImagePreview(this.value)">
                    
                    <div class="image-preview-container">
                        <img id="imagePreview" src="../images/res.jpeg" class="preview-img" alt="Preview">
                        <div>
                            <span style="font-size:12px; color:#94a3b8; display:block;">Select Preset Cover Photo:</span>
                            <div class="preset-gallery">
                                <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=600&q=80" class="preset-thumb" onclick="setPresetImg(this.src)">
                                <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=600&q=80" class="preset-thumb" onclick="setPresetImg(this.src)">
                                <img src="https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=600&q=80" class="preset-thumb" onclick="setPresetImg(this.src)">
                                <img src="../images/res.jpeg" class="preset-thumb" onclick="setPresetImg(this.src)">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-save">+ Register New Restaurant →</button>
        </form>
    </div>

    <script>
        function updateImagePreview(val) {
            var img = document.getElementById('imagePreview');
            img.src = (val && val.trim() !== '') ? val : '../images/res.jpeg';
        }
        function setPresetImg(url) {
            document.getElementById('imageInput').value = url;
            updateImagePreview(url);
        }
    </script>
</body>
</html>