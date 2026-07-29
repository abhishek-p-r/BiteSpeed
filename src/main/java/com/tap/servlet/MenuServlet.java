package com.tap.servlet;


import com.tap.dao.MenuDAO;
import com.tap.dao.RestaurantDAO;

import com.tap.daoimplementation.MenuDAOImpl;
import com.tap.daoimplementation.RestaurantDAOImpl;

import com.tap.model.Menu;
import com.tap.model.Restaurant;
import com.tap.model.User;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


import java.io.IOException;
import java.util.List;



@WebServlet("/menu")
public class MenuServlet extends HttpServlet {



    private static final long serialVersionUID = 1L;


    private MenuDAO menuDAO;

    private RestaurantDAO restaurantDAO;





    @Override
    public void init() throws ServletException {


        menuDAO = new MenuDAOImpl();

        restaurantDAO = new RestaurantDAOImpl();


    }








    @Override
    protected void doGet(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {



        HttpSession session = request.getSession();
        String restaurantIdParam = request.getParameter("restaurantId");
        int restaurantId = 0;

        if (restaurantIdParam != null && !restaurantIdParam.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restaurantIdParam.trim());
            } catch (NumberFormatException e) {
                restaurantId = 0;
            }
        }

        // If no restaurantId provided, check active session cart for restaurantId
        if (restaurantId <= 0) {
            @SuppressWarnings("unchecked")
            java.util.Map<Integer, com.tap.model.CartItem> activeCart = 
                (java.util.Map<Integer, com.tap.model.CartItem>) session.getAttribute("cart");
            if (activeCart != null && !activeCart.isEmpty()) {
                restaurantId = activeCart.values().iterator().next().getRestaurantId();
            }
        }

        try {
            Restaurant restaurant = null;
            if (restaurantId > 0) {
                restaurant = restaurantDAO.getRestaurant(restaurantId);
            }

            List<Menu> menuList = null;
            if (restaurantId > 0) {
                menuList = menuDAO.getMenuByRestaurantId(restaurantId);
            } else {
                menuList = menuDAO.getAllMenus();
            }

            if (restaurant == null) {
                if (menuList != null && !menuList.isEmpty()) {
                    restaurantId = menuList.get(0).getRestaurantId();
                    restaurant = restaurantDAO.getRestaurant(restaurantId);
                }
                if (restaurant == null) {
                    restaurant = new Restaurant();
                    restaurant.setRestaurantId(1);
                    restaurant.setRestaurantName("BiteSpeed Gourmet Kitchen");
                    restaurant.setCuisineType("Multi-Cuisine");
                    restaurant.setAddress("Indiranagar, Bengaluru");
                    restaurant.setRating(4.8);
                }
            }








            System.out.println(
                    "Restaurant : "
                    + restaurant.getRestaurantName()
            );


            System.out.println(
                    "Menu Items : "
                    + menuList.size()
            );



            for(Menu menu : menuList){


                System.out.println(
                        menu.getItemName()
                        +" - "
                        +menu.getImage()
                );


            }








            // Logged user

            User loggedInUser =
                    (User)request.getSession()
                    .getAttribute("user");







            request.setAttribute(
                    "restaurant",
                    restaurant
            );



            request.setAttribute(
                    "menuList",
                    menuList
            );



            request.setAttribute(
                    "loggedInUser",
                    loggedInUser
            );







            request.getRequestDispatcher(
                    "/menu.jsp"
            )
            .forward(
                    request,
                    response
            );





        }
        catch(NumberFormatException e){



            e.printStackTrace();


            response.sendRedirect(
                    request.getContextPath()
                    + "/restaurants.jsp"
            );


        }
        catch(Exception e){



            e.printStackTrace();


            response.sendRedirect(
                    request.getContextPath()
                    + "/error.jsp"
            );


        }



    }



}

