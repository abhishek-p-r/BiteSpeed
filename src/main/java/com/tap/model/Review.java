package com.tap.model;

import java.sql.Timestamp;

public class Review {

    private int reviewId;

    private int userId;

    private int restaurantId;

    private int rating;

    private String reviewText;

    private Timestamp reviewDate;


    // Default Constructor
    public Review() {

    }


    // Constructor for Add Review
    public Review(int userId,
                  int restaurantId,
                  int rating,
                  String reviewText) {

        this.userId = userId;
        this.restaurantId = restaurantId;
        this.rating = rating;
        this.reviewText = reviewText;
    }


    // Full Constructor
    public Review(int reviewId,
                  int userId,
                  int restaurantId,
                  int rating,
                  String reviewText,
                  Timestamp reviewDate) {

        this.reviewId = reviewId;
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.rating = rating;
        this.reviewText = reviewText;
        this.reviewDate = reviewDate;
    }



    public int getReviewId() {
        return reviewId;
    }


    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }



    public int getUserId() {
        return userId;
    }


    public void setUserId(int userId) {
        this.userId = userId;
    }



    public int getRestaurantId() {
        return restaurantId;
    }


    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }



    public int getRating() {
        return rating;
    }


    public void setRating(int rating) {
        this.rating = rating;
    }



    public String getReviewText() {
        return reviewText;
    }


    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }



    public Timestamp getReviewDate() {
        return reviewDate;
    }


    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }



    @Override
    public String toString() {

        return "Review [reviewId=" + reviewId
                + ", userId=" + userId
                + ", restaurantId=" + restaurantId
                + ", rating=" + rating
                + ", reviewText=" + reviewText
                + ", reviewDate=" + reviewDate
                + "]";
    }

}