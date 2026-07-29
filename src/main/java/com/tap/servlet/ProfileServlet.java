package com.tap.servlet;

import com.tap.dao.UserDAO;
import com.tap.daoimplementation.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        String fullName = request.getParameter("name");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String address = request.getParameter("address");

        if (fullName == null || fullName.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/editProfile.jsp?error=invalid_data");
            return;
        }

        user.setFullName(fullName.trim());
        user.setPhone(phone.trim());
        if (gender != null && !gender.trim().isEmpty()) {
            user.setGender(gender.trim());
        }
        if (dob != null && !dob.trim().isEmpty()) {
            try {
                user.setDob(java.sql.Date.valueOf(dob.trim()));
            } catch (Exception e) {}
        }

        if (address != null && !address.trim().isEmpty()) {
            try {
                com.tap.model.UserAddress ua = new com.tap.model.UserAddress();
                ua.setUserId(user.getUserId());
                ua.setAddressLine(address.trim());
                ua.setCity("Bengaluru");
                ua.setState("Karnataka");
                ua.setPincode("560038");
                ua.setAddressType("HOME");
                ua.setDefault(true);
                new com.tap.daoimplementation.UserAddressDAOImpl().addAddress(ua);
            } catch (Exception e) {}
        }

        boolean updated = userDAO.updateUser(user);

        if (updated) {
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/profile.jsp?success=profile_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/editProfile.jsp?error=update_failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
