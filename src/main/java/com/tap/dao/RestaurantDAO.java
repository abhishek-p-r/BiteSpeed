package com.tap.dao;

import java.util.List;

import com.tap.model.Restaurant;

public interface RestaurantDAO {


    // Add Restaurant
    void addRestaurant(Restaurant restaurant);


    // Get Restaurant By Id
    Restaurant getRestaurant(int restaurantId);


    // Get All Restaurants
    List<Restaurant> getAllRestaurants();


    // Get Restaurants By City
    List<Restaurant> getRestaurantsByCity(String city);


    // Search Restaurant By Name / Cuisine
    List<Restaurant> searchRestaurant(String keyword);


    // Update Restaurant
    void updateRestaurant(Restaurant restaurant);


    // Delete Restaurant
    void deleteRestaurant(int restaurantId);


    // Check Restaurant Exists
    boolean restaurantExists(int restaurantId);

    // Get Restaurant By Owner Id
    Restaurant getRestaurantByOwnerId(int ownerId);

}