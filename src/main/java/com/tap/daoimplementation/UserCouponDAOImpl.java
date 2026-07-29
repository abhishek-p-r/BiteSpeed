package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.UserCouponDAO;
import com.tap.model.UserCoupon;
import com.tap.utility.DBConnection;


public class UserCouponDAOImpl implements UserCouponDAO {


    // ==========================================
    // SQL QUERIES
    // ==========================================


    private static final String INSERT_USER_COUPON =
            "INSERT INTO user_coupons(user_id,coupon_id,is_used,assigned_at) VALUES(?,?,?,?)";


    private static final String GET_USER_COUPON =
            "SELECT * FROM user_coupons WHERE id=?";


    private static final String GET_COUPONS_BY_USER =
            "SELECT * FROM user_coupons WHERE user_id=?";


    private static final String UPDATE_USER_COUPON =
            "UPDATE user_coupons SET user_id=?,coupon_id=?,is_used=? WHERE id=?";


    private static final String DELETE_USER_COUPON =
            "DELETE FROM user_coupons WHERE id=?";



    // ==========================================
    // ASSIGN COUPON
    // ==========================================

    @Override
    public void assignCoupon(UserCoupon userCoupon) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_USER_COUPON)){


            ps.setInt(1,userCoupon.getUserId());

            ps.setInt(2,userCoupon.getCouponId());

            ps.setBoolean(3,userCoupon.isUsed());

            ps.setTimestamp(4,
                    new java.sql.Timestamp(System.currentTimeMillis()));



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Coupon Assigned Successfully");

            else

                System.out.println("Coupon Assignment Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // GET USER COUPON
    // ==========================================

    @Override
    public UserCoupon getUserCoupon(int id) {


        UserCoupon userCoupon = null;



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_USER_COUPON)){



            ps.setInt(1,id);



            ResultSet rs = ps.executeQuery();



            if(rs.next()){

                userCoupon = extractUserCoupon(rs);

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return userCoupon;

    }







    // ==========================================
    // GET COUPONS BY USER
    // ==========================================

    @Override
    public List<UserCoupon> getCouponsByUser(int userId) {


        List<UserCoupon> coupons = new ArrayList<>();



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_COUPONS_BY_USER)){



            ps.setInt(1,userId);



            ResultSet rs = ps.executeQuery();



            while(rs.next()){


                coupons.add(extractUserCoupon(rs));


            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return coupons;

    }






    // ==========================================
    // UPDATE USER COUPON
    // ==========================================

    @Override
    public void updateUserCoupon(UserCoupon userCoupon) {



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_USER_COUPON)){



            ps.setInt(1,userCoupon.getUserId());

            ps.setInt(2,userCoupon.getCouponId());

            ps.setBoolean(3,userCoupon.isUsed());

            ps.setInt(4,userCoupon.getId());



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("User Coupon Updated Successfully");

            else

                System.out.println("User Coupon Update Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }







    // ==========================================
    // DELETE USER COUPON
    // ==========================================

    @Override
    public void deleteUserCoupon(int id) {



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_USER_COUPON)){



            ps.setInt(1,id);



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("User Coupon Deleted Successfully");

            else

                System.out.println("User Coupon Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }








    // ==========================================
    // EXTRACT USER COUPON
    // ==========================================

    private UserCoupon extractUserCoupon(ResultSet rs) throws Exception {


        UserCoupon userCoupon = new UserCoupon();



        userCoupon.setId(
                rs.getInt("id")
        );

        userCoupon.setUserId(
                rs.getInt("user_id")
        );


        userCoupon.setCouponId(
                rs.getInt("coupon_id")
        );


        userCoupon.setUsed(
                rs.getBoolean("is_used")
        );


        userCoupon.setAssignedAt(
                rs.getTimestamp("assigned_at")
        );



        return userCoupon;

    }

}