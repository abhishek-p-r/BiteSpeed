package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.RestaurantDAOImpl;
import com.tap.model.Restaurant;


public class RestaurantTest {


    public static void main(String[] args) {


        RestaurantDAOImpl dao = new RestaurantDAOImpl();



        // =====================================================
        // ADD RESTAURANT
        // =====================================================

        Restaurant restaurant6 = new Restaurant();

        restaurant6.setOwnerId(6);
        restaurant6.setRestaurantName("Domino's Pizza");
        restaurant6.setDescription("Fast Food, Pizza and Desserts");
        restaurant6.setCuisineType("Fast Food");
        restaurant6.setPhone("9000001111");
        restaurant6.setEmail("dominos@gmail.com");
        restaurant6.setAddress("Electronic City");
        restaurant6.setCity("Bangalore");
        restaurant6.setState("Karnataka");
        restaurant6.setPincode("560100");
        restaurant6.setOpeningTime("10:30:00");
        restaurant6.setClosingTime("23:45:00");
        restaurant6.setImage("dominos.jpg");
        restaurant6.setRating(4.3);
        restaurant6.setActive(true);

        dao.addRestaurant(restaurant6);
//
//        // =====================================================
//        // GET RESTAURANT BY ID
//        // =====================================================
//
//
//        Restaurant result = dao.getRestaurant(1);
//
//
//        System.out.println(result);
//
//
//
//
//
//
//        // =====================================================
//        // GET ALL RESTAURANTS
//        // =====================================================
//
//
//        List<Restaurant> restaurants = dao.getAllRestaurants();
//
//
//
//        for(Restaurant r : restaurants){
//
//            System.out.println(r);
//
//        }
//
//
//
//
//
//
//        // =====================================================
//        // SEARCH RESTAURANT
//        // =====================================================
//
//
//        List<Restaurant> search =
//                dao.searchRestaurant("Biryani");
//
//
//
//        for(Restaurant r : search){
//
//            System.out.println("Search Result : " + r);
//
//        }
//
//
//
//
//
//
//        // =====================================================
//        // GET BY CITY
//        // =====================================================
//
//
//        List<Restaurant> cityList =
//                dao.getRestaurantsByCity("Bangalore");
//
//
//
//        for(Restaurant r : cityList){
//
//            System.out.println("City Result : " + r);
//
//        }
//
//
//
//
//
//
//
//        // =====================================================
//        // UPDATE RESTAURANT
//        // =====================================================
//
//
//        Restaurant update =
//                dao.getRestaurant(1);
//
//
//
//        if(update != null){
//
//
//            update.setRating(4.8);
//
//            update.setDescription(
//                    "Updated Premium Restaurant"
//            );
//
//
//            dao.updateRestaurant(update);
//
//
//        }
//
//
//
//
//
//
//
//
//        // =====================================================
//        // CHECK EXISTS
//        // =====================================================
//
//
//        boolean exists =
//                dao.restaurantExists(1);
//
//
//
//        System.out.println(
//                "Restaurant Exists : " + exists
//        );
//
//
//
//
//
//
//
//
//        // =====================================================
//        // DELETE RESTAURANT
//        // =====================================================
//
//
//        // dao.deleteRestaurant(1);



    }

}