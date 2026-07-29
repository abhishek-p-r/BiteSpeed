package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantImageDAO;
import com.tap.model.RestaurantImage;
import com.tap.utility.DBConnection;


public class RestaurantImageDAOImpl implements RestaurantImageDAO {


    // =====================================================
    // SQL QUERIES
    // =====================================================


    private static final String INSERT_IMAGE =
            "INSERT INTO restaurant_images "
            + "(restaurant_id,image_url,image_type,display_order,created_at) "
            + "VALUES(?,?,?,?,?)";



    private static final String GET_IMAGE =
            "SELECT * FROM restaurant_images WHERE image_id=?";



    private static final String GET_ALL_IMAGES =
            "SELECT * FROM restaurant_images ORDER BY image_id";



    private static final String GET_IMAGES_BY_RESTAURANT =
            "SELECT * FROM restaurant_images "
            + "WHERE restaurant_id=? ORDER BY display_order";



    private static final String UPDATE_IMAGE =
            "UPDATE restaurant_images SET "
            + "restaurant_id=?,image_url=?,image_type=?,display_order=? "
            + "WHERE image_id=?";



    private static final String DELETE_IMAGE =
            "DELETE FROM restaurant_images WHERE image_id=?";





    // =====================================================
    // ADD IMAGE
    // =====================================================


    @Override
    public void addImage(RestaurantImage image) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_IMAGE)) {



            ps.setInt(1, image.getRestaurantId());

            ps.setString(2, image.getImageUrl());

            ps.setString(3, image.getImageType());

            ps.setInt(4, image.getDisplayOrder());

            ps.setTimestamp(
                    5,
                    new java.sql.Timestamp(
                            System.currentTimeMillis()
                    )
            );



            int rows = ps.executeUpdate();



            if(rows > 0)
                System.out.println("Restaurant Image Added Successfully");
            else
                System.out.println("Restaurant Image Add Failed");



        }catch(Exception e){

            e.printStackTrace();

        }


    }







    // =====================================================
    // GET IMAGE
    // =====================================================


    @Override
    public RestaurantImage getImage(int imageId) {


        RestaurantImage image = null;



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_IMAGE)) {



            ps.setInt(1,imageId);



            ResultSet rs = ps.executeQuery();



            if(rs.next()) {

                image = extractImage(rs);

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return image;

    }








    // =====================================================
    // GET ALL IMAGES
    // =====================================================


    @Override
    public List<RestaurantImage> getAllImages() {


        List<RestaurantImage> images = new ArrayList<>();



        try(Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(GET_ALL_IMAGES)) {



            while(rs.next()) {

                images.add(extractImage(rs));

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return images;

    }








    // =====================================================
    // GET IMAGES BY RESTAURANT
    // =====================================================


    @Override
    public List<RestaurantImage> getImagesByRestaurant(int restaurantId) {


        List<RestaurantImage> images = new ArrayList<>();



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_IMAGES_BY_RESTAURANT)) {



            ps.setInt(1, restaurantId);



            ResultSet rs = ps.executeQuery();



            while(rs.next()) {


                images.add(extractImage(rs));


            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return images;

    }








    // =====================================================
    // UPDATE IMAGE
    // =====================================================


    @Override
    public void updateImage(RestaurantImage image) {



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_IMAGE)) {



            ps.setInt(
                    1,
                    image.getRestaurantId()
            );



            ps.setString(
                    2,
                    image.getImageUrl()
            );



            ps.setString(
                    3,
                    image.getImageType()
            );



            ps.setInt(
                    4,
                    image.getDisplayOrder()
            );



            ps.setInt(
                    5,
                    image.getImageId()
            );



            int rows = ps.executeUpdate();



            if(rows > 0)
                System.out.println("Restaurant Image Updated Successfully");
            else
                System.out.println("Restaurant Image Update Failed");



        }catch(Exception e){

            e.printStackTrace();

        }


    }








    // =====================================================
    // DELETE IMAGE
    // =====================================================


    @Override
    public void deleteImage(int imageId) {



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_IMAGE)) {



            ps.setInt(1,imageId);



            int rows = ps.executeUpdate();



            if(rows > 0)
                System.out.println("Restaurant Image Deleted Successfully");
            else
                System.out.println("Restaurant Image Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }


    }








    // =====================================================
    // EXTRACT IMAGE
    // =====================================================


    private RestaurantImage extractImage(ResultSet rs) throws Exception {



        RestaurantImage image = new RestaurantImage();



        image.setImageId(
                rs.getInt("image_id")
        );



        image.setRestaurantId(
                rs.getInt("restaurant_id")
        );



        image.setImageUrl(
                rs.getString("image_url")
        );



        image.setImageType(
                rs.getString("image_type")
        );



        image.setDisplayOrder(
                rs.getInt("display_order")
        );



        image.setCreatedAt(
                rs.getTimestamp("created_at")
        );



        return image;

    }


}