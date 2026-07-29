package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.ReviewDAOImpl;
import com.tap.model.Review;


public class ReviewTest {


    public static void main(String[] args) {


        ReviewDAOImpl dao = new ReviewDAOImpl();



        // ADD REVIEW

        Review review = new Review();

        review.setUserId(1);
        review.setRestaurantId(1);
        review.setRating(5);
        review.setReviewText("Excellent Food");


        dao.addReview(review);



        // GET REVIEW

        System.out.println(
                dao.getReview(1)
        );



        // GET ALL REVIEWS

        List<Review> reviews =
                dao.getAllReviews();


        for(Review r:reviews){

            System.out.println(r);

        }



        // UPDATE REVIEW

        Review update =
                dao.getReview(1);


        if(update!=null){

            update.setReviewText(
                    "Awesome Food & Fast Delivery"
            );


            dao.updateReview(update);

        }



        // DELETE REVIEW

        // dao.deleteReview(1);

    }

}