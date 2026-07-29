package com.tap.dao;

import java.util.List;
import com.tap.model.Review;

public interface ReviewDAO {

    void addReview(Review review);

    Review getReview(int reviewId);

    List<Review> getAllReviews();

    List<Review> getReviewsByRestaurant(int restaurantId);

    List<Review> getReviewsByUser(int userId);

    void updateReview(Review review);

    void deleteReview(int reviewId);

    boolean reviewExists(int reviewId);
}