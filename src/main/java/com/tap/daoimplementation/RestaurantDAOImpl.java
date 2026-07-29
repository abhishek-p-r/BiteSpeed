package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.utility.DBConnection;


public class RestaurantDAOImpl implements RestaurantDAO {


    // =====================================================
    // SQL QUERIES
    // =====================================================

    private static final String INSERT_RESTAURANT =
            "INSERT INTO restaurants "
            + "(owner_id,restaurant_name,description,cuisine_type,phone,email,address,city,state,pincode,"
            + "opening_time,closing_time,image,rating,is_active,created_at,updated_at) "
            + "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";


    private static final String GET_RESTAURANT =
            "SELECT * FROM restaurants WHERE restaurant_id=?";


    private static final String GET_ALL_RESTAURANTS =
            "SELECT * FROM restaurants ORDER BY restaurant_id";


    private static final String GET_BY_CITY =
            "SELECT * FROM restaurants WHERE city=?";


    private static final String SEARCH_RESTAURANT =
            "SELECT * FROM restaurants "
            + "WHERE restaurant_name LIKE ? OR cuisine_type LIKE ?";


    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurants SET "
            + "owner_id=?,restaurant_name=?,description=?,cuisine_type=?,phone=?,email=?,"
            + "address=?,city=?,state=?,pincode=?,opening_time=?,closing_time=?,"
            + "image=?,rating=?,is_active=?,updated_at=? "
            + "WHERE restaurant_id=?";


    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurants WHERE restaurant_id=?";


    private static final String RESTAURANT_EXISTS =
            "SELECT COUNT(*) FROM restaurants WHERE restaurant_id=?";



    // =====================================================
    // ADD RESTAURANT
    // =====================================================

    @Override
    public void addRestaurant(Restaurant restaurant) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_RESTAURANT)) {


            Timestamp now = new Timestamp(System.currentTimeMillis());


            ps.setInt(1, restaurant.getOwnerId());
            ps.setString(2, restaurant.getRestaurantName());
            ps.setString(3, restaurant.getDescription());
            ps.setString(4, restaurant.getCuisineType());
            ps.setString(5, restaurant.getPhone());
            ps.setString(6, restaurant.getEmail());
            ps.setString(7, restaurant.getAddress());
            ps.setString(8, restaurant.getCity());
            ps.setString(9, restaurant.getState());
            ps.setString(10, restaurant.getPincode());
            ps.setString(11, restaurant.getOpeningTime());
            ps.setString(12, restaurant.getClosingTime());
            ps.setString(13, restaurant.getImage());
            ps.setDouble(14, restaurant.getRating());
            ps.setBoolean(15, restaurant.isActive());
            ps.setTimestamp(16, now);
            ps.setTimestamp(17, now);



            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Restaurant Added Successfully");
            else
                System.out.println("Restaurant Add Failed");


        }catch(Exception e){
            e.printStackTrace();
        }

    }



    // =====================================================
    // GET RESTAURANT
    // =====================================================

    @Override
    public Restaurant getRestaurant(int restaurantId) {


        Restaurant restaurant = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_RESTAURANT)) {


            ps.setInt(1, restaurantId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()) {

                restaurant = extractRestaurant(rs);

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return restaurant;

    }





    // =====================================================
    // GET ALL RESTAURANTS
    // =====================================================


    @Override
    public List<Restaurant> getAllRestaurants() {


        List<Restaurant> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(GET_ALL_RESTAURANTS)) {


            while(rs.next()) {

                list.add(extractRestaurant(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }





    // =====================================================
    // GET RESTAURANTS BY CITY
    // =====================================================


    @Override
    public List<Restaurant> getRestaurantsByCity(String city) {


        List<Restaurant> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_BY_CITY)) {


            ps.setString(1, city);


            ResultSet rs = ps.executeQuery();



            while(rs.next()) {

                list.add(extractRestaurant(rs));

            }



        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }





    // =====================================================
    // SEARCH RESTAURANT
    // =====================================================


    @Override
    public List<Restaurant> searchRestaurant(String keyword) {


        List<Restaurant> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(SEARCH_RESTAURANT)) {


            ps.setString(1,"%"+keyword+"%");
            ps.setString(2,"%"+keyword+"%");


            ResultSet rs = ps.executeQuery();



            while(rs.next()) {

                list.add(extractRestaurant(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }





    // =====================================================
    // UPDATE RESTAURANT
    // =====================================================


    @Override
    public void updateRestaurant(Restaurant restaurant) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_RESTAURANT)) {



            ps.setInt(1, restaurant.getOwnerId());
            ps.setString(2, restaurant.getRestaurantName());
            ps.setString(3, restaurant.getDescription());
            ps.setString(4, restaurant.getCuisineType());
            ps.setString(5, restaurant.getPhone());
            ps.setString(6, restaurant.getEmail());
            ps.setString(7, restaurant.getAddress());
            ps.setString(8, restaurant.getCity());
            ps.setString(9, restaurant.getState());
            ps.setString(10, restaurant.getPincode());
            ps.setString(11, restaurant.getOpeningTime());
            ps.setString(12, restaurant.getClosingTime());
            ps.setString(13, restaurant.getImage());
            ps.setDouble(14, restaurant.getRating());
            ps.setBoolean(15, restaurant.isActive());
            ps.setTimestamp(16,new Timestamp(System.currentTimeMillis()));
            ps.setInt(17, restaurant.getRestaurantId());



            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Restaurant Updated Successfully");
            else
                System.out.println("Restaurant Update Failed");



        }catch(Exception e){

            e.printStackTrace();

        }


    }





    // =====================================================
    // DELETE RESTAURANT
    // =====================================================


    @Override
    public void deleteRestaurant(int restaurantId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_RESTAURANT)) {


            ps.setInt(1, restaurantId);


            int rows = ps.executeUpdate();



            if(rows > 0)
                System.out.println("Restaurant Deleted Successfully");
            else
                System.out.println("Restaurant Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // =====================================================
    // RESTAURANT EXISTS
    // =====================================================


    @Override
    public boolean restaurantExists(int restaurantId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(RESTAURANT_EXISTS)) {



            ps.setInt(1, restaurantId);



            ResultSet rs = ps.executeQuery();



            if(rs.next()) {

                return rs.getInt(1) > 0;

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return false;

    }





    // =====================================================
    // EXTRACT RESTAURANT
    // =====================================================


    private Restaurant extractRestaurant(ResultSet rs) throws Exception {


        Restaurant restaurant = new Restaurant();


        restaurant.setRestaurantId(rs.getInt("restaurant_id"));
        restaurant.setOwnerId(rs.getInt("owner_id"));

        restaurant.setRestaurantName(
                rs.getString("restaurant_name")
        );

        restaurant.setDescription(
                rs.getString("description")
        );

        restaurant.setCuisineType(
                rs.getString("cuisine_type")
        );

        restaurant.setPhone(
                rs.getString("phone")
        );

        restaurant.setEmail(
                rs.getString("email")
        );

        restaurant.setAddress(
                rs.getString("address")
        );

        restaurant.setCity(
                rs.getString("city")
        );

        restaurant.setState(
                rs.getString("state")
        );

        restaurant.setPincode(
                rs.getString("pincode")
        );

        restaurant.setOpeningTime(
                rs.getString("opening_time")
        );

        restaurant.setClosingTime(
                rs.getString("closing_time")
        );

        restaurant.setImage(
                rs.getString("image")
        );

        restaurant.setRating(
                rs.getDouble("rating")
        );

        restaurant.setActive(
                rs.getBoolean("is_active")
        );

        restaurant.setCreatedAt(
                rs.getTimestamp("created_at")
        );

        restaurant.setUpdatedAt(
                rs.getTimestamp("updated_at")
        );


        return restaurant;

    }

    @Override
    public Restaurant getRestaurantByOwnerId(int ownerId) {
        Restaurant restaurant = null;
        String sql = "SELECT * FROM restaurants WHERE owner_id=? LIMIT 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                restaurant = extractRestaurant(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return restaurant;
    }

}