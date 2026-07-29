package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.ReviewDAO;
import com.tap.model.Review;
import com.tap.utility.DBConnection;


public class ReviewDAOImpl implements ReviewDAO {


    private static final String INSERT_REVIEW =
            "INSERT INTO reviews(user_id,restaurant_id,rating,review_text,review_date) VALUES(?,?,?,?,?)";


    private static final String GET_REVIEW =
            "SELECT * FROM reviews WHERE review_id=?";


    private static final String GET_ALL_REVIEWS =
            "SELECT * FROM reviews ORDER BY review_id";


    private static final String GET_BY_RESTAURANT =
            "SELECT * FROM reviews WHERE restaurant_id=?";


    private static final String GET_BY_USER =
            "SELECT * FROM reviews WHERE user_id=?";


    private static final String UPDATE_REVIEW =
            "UPDATE reviews SET user_id=?,restaurant_id=?,rating=?,review_text=? WHERE review_id=?";


    private static final String DELETE_REVIEW =
            "DELETE FROM reviews WHERE review_id=?";


    private static final String REVIEW_EXISTS =
            "SELECT COUNT(*) FROM reviews WHERE review_id=?";



    @Override
    public void addReview(Review review) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_REVIEW)) {


            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getRestaurantId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getReviewText());
            ps.setTimestamp(5,
                    new Timestamp(System.currentTimeMillis()));


            if(ps.executeUpdate()>0)
                System.out.println("Review Added Successfully");


        }catch(Exception e){
            e.printStackTrace();
        }
    }




    @Override
    public Review getReview(int reviewId) {


        Review review=null;


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(GET_REVIEW)){


            ps.setInt(1, reviewId);


            ResultSet rs=ps.executeQuery();


            if(rs.next())
                review=extractReview(rs);


        }catch(Exception e){
            e.printStackTrace();
        }


        return review;
    }





    @Override
    public List<Review> getAllReviews() {


        List<Review> list=new ArrayList<>();


        try(Connection con=DBConnection.getConnection();
            Statement stmt=con.createStatement();
            ResultSet rs=stmt.executeQuery(GET_ALL_REVIEWS)){


            while(rs.next())
                list.add(extractReview(rs));


        }catch(Exception e){
            e.printStackTrace();
        }


        return list;
    }





    @Override
    public List<Review> getReviewsByRestaurant(int restaurantId) {


        List<Review> list=new ArrayList<>();


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(GET_BY_RESTAURANT)){


            ps.setInt(1, restaurantId);


            ResultSet rs=ps.executeQuery();


            while(rs.next())
                list.add(extractReview(rs));


        }catch(Exception e){
            e.printStackTrace();
        }


        return list;
    }





    @Override
    public List<Review> getReviewsByUser(int userId) {


        List<Review> list=new ArrayList<>();


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(GET_BY_USER)){


            ps.setInt(1,userId);


            ResultSet rs=ps.executeQuery();


            while(rs.next())
                list.add(extractReview(rs));


        }catch(Exception e){
            e.printStackTrace();
        }


        return list;
    }





    @Override
    public void updateReview(Review review) {


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(UPDATE_REVIEW)){


            ps.setInt(1,review.getUserId());
            ps.setInt(2,review.getRestaurantId());
            ps.setInt(3,review.getRating());
            ps.setString(4,review.getReviewText());
            ps.setInt(5,review.getReviewId());


            if(ps.executeUpdate()>0)
                System.out.println("Review Updated Successfully");


        }catch(Exception e){
            e.printStackTrace();
        }

    }





    @Override
    public void deleteReview(int reviewId) {


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(DELETE_REVIEW)){


            ps.setInt(1,reviewId);


            if(ps.executeUpdate()>0)
                System.out.println("Review Deleted Successfully");


        }catch(Exception e){
            e.printStackTrace();
        }
    }





    @Override
    public boolean reviewExists(int reviewId) {


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(REVIEW_EXISTS)){


            ps.setInt(1,reviewId);


            ResultSet rs=ps.executeQuery();


            if(rs.next())
                return rs.getInt(1)>0;


        }catch(Exception e){
            e.printStackTrace();
        }


        return false;
    }





    private Review extractReview(ResultSet rs)throws Exception{


        Review review=new Review();


        review.setReviewId(rs.getInt("review_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setRestaurantId(rs.getInt("restaurant_id"));
        review.setRating(rs.getInt("rating"));
        review.setReviewText(rs.getString("review_text"));
        review.setReviewDate(rs.getTimestamp("review_date"));


        return review;
    }

}