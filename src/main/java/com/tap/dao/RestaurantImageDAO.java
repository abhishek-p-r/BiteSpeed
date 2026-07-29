package com.tap.dao;

import java.util.List;

import com.tap.model.RestaurantImage;


public interface RestaurantImageDAO {


    // Add Restaurant Image
    void addImage(RestaurantImage image);



    // Get Image By Id
    RestaurantImage getImage(int imageId);



    // Get All Images
    List<RestaurantImage> getAllImages();



    // Get Images By Restaurant
    List<RestaurantImage> getImagesByRestaurant(int restaurantId);



    // Update Image
    void updateImage(RestaurantImage image);



    // Delete Image
    void deleteImage(int imageId);


}