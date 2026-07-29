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
    RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
    
    if (assignedRestaurantId == null || assignedRestaurantId == 0) {
        Restaurant myRest = restaurantDAO.getRestaurantByOwnerId(loggedInUser.getUserId());
        if (myRest != null) {
            assignedRestaurantId = myRest.getRestaurantId();
            session.setAttribute("assignedRestaurantId", assignedRestaurantId);
        }
    }

    boolean isSuperAdmin = "SUPER_ADMIN".equalsIgnoreCase(adminRole) || 
        ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) && (assignedRestaurantId == null || assignedRestaurantId == 0));

    int restaurantId = 0;
    try {
        restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
    } catch (Exception e) {}
    
    if (restaurantId == 0 && assignedRestaurantId != null && assignedRestaurantId > 0) {
        restaurantId = assignedRestaurantId;
    }

    // Security Gate: Vendor Admins can only edit THEIR assigned restaurant
    if (!isSuperAdmin && (assignedRestaurantId == null || assignedRestaurantId != restaurantId)) {
        out.println("<div style='color:#ff4757; background:#0b0f17; padding:40px; font-family:sans-serif;'><h2>⚠️ Access Denied</h2><p>You are authorized to manage only your assigned restaurant profile.</p><a href='dashboard.jsp' style='color:#00f0ff;'>← Back to Dashboard</a></div>");
        return;
    }

    String message = "";

    // Process POST update
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int rId = Integer.parseInt(request.getParameter("restaurantId"));
            
            // Double check security on POST
            if (!isSuperAdmin && (assignedRestaurantId == null || assignedRestaurantId != rId)) {
                message = "❌ Security Violation: Unauthorized to update this restaurant.";
            } else {
                String name = request.getParameter("restaurantName");
                String desc = request.getParameter("description");
                String cuisine = request.getParameter("cuisineType");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String address = request.getParameter("address");
                String city = request.getParameter("city");
                String openTime = request.getParameter("openingTime");
                String closeTime = request.getParameter("closingTime");
                String image = request.getParameter("image");
                double rating = Double.parseDouble(request.getParameter("rating"));
                boolean active = "on".equals(request.getParameter("active")) || "true".equals(request.getParameter("active"));

                Restaurant r = restaurantDAO.getRestaurant(rId);
                if (r != null) {
                    r.setRestaurantName(name);
                    r.setDescription(desc);
                    r.setCuisineType(cuisine);
                    r.setPhone(phone);
                    r.setEmail(email);
                    r.setAddress(address);
                    r.setCity(city);
                    r.setOpeningTime(openTime);
                    r.setClosingTime(closeTime);
                    r.setImage(image);
                    r.setRating(rating);
                    r.setActive(active);
                    restaurantDAO.updateRestaurant(r);
                    message = "✅ Restaurant details & photos updated successfully!";
                }
            }
        } catch (Exception e) {
            message = "❌ Failed to update restaurant: " + e.getMessage();
        }
    }

    Restaurant r = restaurantDAO.getRestaurant(restaurantId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="<%=request.getContextPath()%>/js/theme.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Restaurant #<%= restaurantId %> — BiteSpeed Admin</title>
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
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px 14px; background: rgba(255,255,255,0.05); border: 1px solid rgba(0,240,255,0.2); border-radius: 6px; color: #fff; font-family: 'Outfit', sans-serif; box-sizing: border-box; }
        .btn-save { background: #00f0ff; color: #0b0f17; padding: 14px 28px; border: none; border-radius: 6px; font-weight: 700; cursor: pointer; font-size: 15px; width: 100%; margin-top: 15px; transition: background 0.3s; }
        .btn-save:hover { background: #00c8d6; }
        .btn-back { color: #94a3b8; text-decoration: none; display: inline-block; margin-bottom: 20px; font-size: 14px; }
        .msg { padding: 12px 18px; border-radius: 6px; margin-bottom: 20px; background: rgba(0,240,255,0.1); border: 1px solid #00f0ff; color: #00f0ff; font-weight: 500; }
        
        /* Image Preview Box & Presets Gallery */
        .image-preview-container { display: flex; gap: 15px; align-items: center; background: rgba(255,255,255,0.03); border: 1px dashed rgba(0,240,255,0.3); padding: 12px; border-radius: 8px; margin-top: 8px; }
        .preview-img { width: 90px; height: 90px; object-fit: cover; border-radius: 8px; border: 1px solid #00f0ff; background: #000; }
        .preset-gallery { display: flex; gap: 8px; overflow-x: auto; padding-top: 8px; }
        .preset-thumb { width: 48px; height: 48px; object-fit: cover; border-radius: 6px; border: 1px solid rgba(255,255,255,0.2); cursor: pointer; transition: transform 0.2s, border-color 0.2s; }
        .preset-thumb:hover { transform: scale(1.1); border-color: #00f0ff; }
    </style>
</head>
<body>
    <div class="admin-card">
        <a href="dashboard.jsp" class="btn-back">← Back to Dashboard</a>
        <h1>Edit Restaurant Deck</h1>
        <p style="color:#94a3b8; font-size:14px; margin-top:-10px; margin-bottom:25px;">Update details, description, operating hours, and cover photos for your restaurant venue.</p>
        
        <% if (!message.isEmpty()) { %>
            <div class="msg"><%= message %></div>
        <% } %>

        <% if (r != null) { 
            String currentImg = (r.getImage() != null && !r.getImage().trim().isEmpty()) ? r.getImage() : "../images/res.jpeg";
        %>
            <form action="editRestaurant.jsp?restaurantId=<%= r.getRestaurantId() %>" method="POST">
                <input type="hidden" name="restaurantId" value="<%= r.getRestaurantId() %>">
                
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Restaurant Name</label>
                        <input type="text" name="restaurantName" value="<%= r.getRestaurantName() %>" required>
                    </div>

                    <div class="form-group full-width">
                        <label>Restaurant Description / Bio</label>
                        <textarea name="description" rows="3" placeholder="Describe the ambient dining, specialty dishes, and experience..."><%= r.getDescription() != null ? r.getDescription() : "" %></textarea>
                    </div>

                    <div class="form-group">
                        <label>Cuisine Type</label>
                        <input type="text" name="cuisineType" value="<%= r.getCuisineType() != null ? r.getCuisineType() : "" %>" placeholder="e.g. Italian, North Indian, Asian" required>
                    </div>

                    <div class="form-group">
                        <label>City Location</label>
                        <input type="text" name="city" value="<%= r.getCity() != null ? r.getCity() : "" %>" required>
                    </div>

                    <div class="form-group full-width">
                        <label>Full Address</label>
                        <input type="text" name="address" value="<%= r.getAddress() != null ? r.getAddress() : "" %>" placeholder="Street address, building / floor number">
                    </div>

                    <div class="form-group">
                        <label>Opening Time</label>
                        <input type="text" name="openingTime" value="<%= r.getOpeningTime() != null ? r.getOpeningTime() : "09:00 AM" %>" placeholder="09:00 AM">
                    </div>

                    <div class="form-group">
                        <label>Closing Time</label>
                        <input type="text" name="closingTime" value="<%= r.getClosingTime() != null ? r.getClosingTime() : "11:00 PM" %>" placeholder="11:00 PM">
                    </div>

                    <div class="form-group">
                        <label>Contact Phone</label>
                        <input type="text" name="phone" value="<%= r.getPhone() != null ? r.getPhone() : "" %>">
                    </div>

                    <div class="form-group">
                        <label>Contact Email</label>
                        <input type="email" name="email" value="<%= r.getEmail() != null ? r.getEmail() : "" %>">
                    </div>

                    <div class="form-group">
                        <label>Star Rating</label>
                        <input type="number" step="0.1" min="1.0" max="5.0" name="rating" value="<%= r.getRating() %>" required>
                    </div>

                    <div class="form-group" style="display:flex; align-items:center;">
                        <label style="margin:0; cursor:pointer; font-size:14px; color:#fff; display:flex; align-items:center; gap:8px;">
                            <input type="checkbox" name="active" <%= r.isActive() ? "checked" : "" %> style="width:auto;"> Active / Open for Orders
                        </label>
                    </div>

                    <!-- IMAGE UPLOAD & POST SECTION -->
                    <div class="form-group full-width">
                        <label>Restaurant Cover Photo URL</label>
                        <input type="text" id="imageInput" name="image" value="<%= currentImg %>" oninput="updateImagePreview(this.value)">
                        
                        <div class="image-preview-container">
                            <img id="imagePreview" src="<%= currentImg %>" class="preview-img" alt="Preview" onerror="this.src='../images/res.jpeg'">
                            <div>
                                <span style="font-size:12px; color:#94a3b8; display:block; margin-bottom:4px;">Quick Select Preset Covers:</span>
                                <div class="preset-gallery">
                                    <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=600&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Fine Dining">
                                    <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=600&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Bistro Interior">
                                    <img src="https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=600&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Cozy Restaurant">
                                    <img src="https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=600&q=80" class="preset-thumb" onclick="setPresetImg(this.src)" title="Steakhouse Bar">
                                    <img src="../images/res.jpeg" class="preset-thumb" onclick="setPresetImg(this.src)" title="Default Cover">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-save">💾 Save Restaurant Updates & Photos →</button>
            </form>
        <% } else { %>
            <p>⚠️ Restaurant #<%= restaurantId %> not found in system records.</p>
        <% } %>
    </div>

    <script>
        function updateImagePreview(val) {
            var img = document.getElementById('imagePreview');
            if (val && val.trim() !== '') {
                img.src = val;
            } else {
                img.src = '../images/res.jpeg';
            }
        }
        function setPresetImg(url) {
            document.getElementById('imageInput').value = url;
            updateImagePreview(url);
        }
    </script>
</body>
</html>