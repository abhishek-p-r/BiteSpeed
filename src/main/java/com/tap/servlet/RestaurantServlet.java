package com.tap.servlet;

import com.tap.daoimplementation.RestaurantDAOImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;


@WebServlet("/restaurants")
public class RestaurantServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, 
                         HttpServletResponse response)
                         throws ServletException, IOException {


        try {

            RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl();


            // Fetch restaurants from database
            List<Restaurant> restaurants = 
                    restaurantDAOImpl.getAllRestaurants();



            // Debug output
            for(Restaurant restaurant : restaurants) {

                System.out.println(restaurant);

            }



            // Send data to JSP
            request.setAttribute(
                    "restaurantsList",
                    restaurants
            );



            // Forward to JSP
            RequestDispatcher rd =
                    request.getRequestDispatcher("restaurants.jsp");


            rd.forward(request, response);



        } catch(Exception e) {


            e.printStackTrace();


            response.sendRedirect(
                    "error.jsp"
            );

        }

    }


    @Override
    protected void doPost(HttpServletRequest request,   HttpServletResponse response) throws ServletException, IOException {

        doGet(request,response);

    }

}










//package com.tap.servlet;
//
//import com.tap.dao.RestaurantDAO;
//import com.tap.daoimplementation.RestaurantDAOImpl;
//import com.tap.model.Restaurant;
//
//import jakarta.servlet.RequestDispatcher;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import java.io.IOException;
//import java.util.List;
//
//
//@WebServlet("/restaurants")
//public class RestaurantServlet extends HttpServlet {
//	//
//	//    private static final long serialVersionUID = 1L;
//	//
//	//    private RestaurantDAO restaurantDAO;
//	//
//	//
//	//    @Override
//	//    public void init() throws ServletException {
//	//
//	//        restaurantDAO = new RestaurantDAOImpl();
//	//
//	//    }
//
//
//	@Override
//	protected void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException {
//
//		RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl();
//		
//		List<Restaurant> allRestaurants =restaurantDAOImpl.getAllRestaurants();
//		
//		for(Restaurant restaurant : allRestaurants)
//		{
//			System.out.println(restaurant);
//		}
////		try {
////
////			// Fetch all restaurants
////			List<Restaurant> restaurants =
////					restaurantDAO.getAllRestaurants();
////
////
////			// Send data to JSP
////			request.setAttribute(
////					"restaurantsList",
////					restaurants
////					);
////
////
////			// Forward to restaurants page
////			request.getRequestDispatcher(
////					"/restaurants.jsp"
////					).forward(
////							request,
////							response
////							);
////
////
////		} catch (Exception e) {
////
////			e.printStackTrace();
////
////			response.sendRedirect(
////					request.getContextPath()
////					+ "/error.jsp"
////					);
////
////		}
//
////	}
//
//
////	@Override
////	protected void doPost(HttpServletRequest request,
////			HttpServletResponse response)
////					throws ServletException, IOException {
////
////		doGet(request, response);
//		request.setAttribute("allRestaurants", allRestaurants);
//		RequestDispatcher rd = request.getRequestDispatcher("restaurants.jsp");
//		rd.forward(request, response);
//
//	}
//


