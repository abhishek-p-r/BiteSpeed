package com.tap.servlet;

import com.tap.dao.AdminDAO;
import com.tap.dao.UserDAO;
import com.tap.daoimplementation.AdminDAOImpl;
import com.tap.daoimplementation.UserDAOImpl;
import com.tap.model.Admin;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;


@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private AdminDAO adminDAO;


    @Override
    public void init() throws ServletException {

        userDAO = new UserDAOImpl();
        adminDAO = new AdminDAOImpl();

    }



    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {


        RequestDispatcher rd =
                request.getRequestDispatcher("register.jsp");

        rd.forward(request, response);

    }




    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {


        try {


            String fullName = request.getParameter("name");

            String email = request.getParameter("email");

            String phone = request.getParameter("phone");

            String password = request.getParameter("password");
            
            String role = request.getParameter("role");

            String hashpw = BCrypt.hashpw(password, BCrypt.gensalt(12));

            if(fullName == null || email == null ||
               phone == null || password == null ||
               role == null ||
               fullName.trim().isEmpty() ||
               email.trim().isEmpty() ||
               phone.trim().isEmpty() ||
               password.trim().isEmpty() ||
               role.trim().isEmpty()) {


                response.sendRedirect(
                    "register.jsp?error=empty_fields"
                );

                return;

            }

            if (userDAO.emailExists(email.trim())) {
                response.sendRedirect("register.jsp?error=email_exists");
                return;
            }

            if (userDAO.phoneExists(phone.trim())) {
                response.sendRedirect("register.jsp?error=phone_exists");
                return;
            }



            User user = new User();


            user.setFullName(fullName.trim());

            user.setEmail(email.trim());

            user.setPhone(phone.trim());
            
            user.setPassword(hashpw);   
            
            user.setRole(role.trim());    


            user.setStatus("active");



            boolean result =
                    userDAO.addUser(user);



            if(result) {

                if ("ADMIN".equalsIgnoreCase(role.trim())) {
                    try {
                        Admin admin = new Admin();
                        admin.setName(fullName.trim());
                        admin.setUsername(email.trim());
                        admin.setEmail(email.trim());
                        admin.setPassword(hashpw);
                        admin.setPhoneNumber(phone.trim());
                        admin.setRole("ADMIN");
                        admin.setActive(true);
                        adminDAO.addAdmin(admin);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }


                System.out.println(
                    "User Registered Successfully"
                );


                response.sendRedirect(
                    "login.jsp?success=registered"
                );


            }
            else {


                response.sendRedirect(
                    "register.jsp?error=failed"
                );

            }


        }
        catch(Exception e) {


            e.printStackTrace();


            response.sendRedirect(
                "error.jsp"
            );

        }

    }

}

