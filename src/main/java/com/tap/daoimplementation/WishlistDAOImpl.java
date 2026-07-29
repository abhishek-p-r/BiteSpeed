package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.WishlistDAO;
import com.tap.model.Wishlist;
import com.tap.utility.DBConnection;


public class WishlistDAOImpl implements WishlistDAO {


    // ==========================================
    // SQL QUERIES
    // ==========================================


    private static final String INSERT_WISHLIST =
            "INSERT INTO wishlist(user_id,menu_item_id,created_at) VALUES(?,?,?)";


    private static final String GET_WISHLIST =
            "SELECT * FROM wishlist WHERE wishlist_id=?";


    private static final String GET_WISHLIST_BY_USER =
            "SELECT * FROM wishlist WHERE user_id=? ORDER BY wishlist_id";


    private static final String DELETE_WISHLIST =
            "DELETE FROM wishlist WHERE wishlist_id=?";


    private static final String CHECK_EXISTS =
            "SELECT COUNT(*) FROM wishlist WHERE user_id=? AND menu_item_id=?";



    // ==========================================
    // ADD WISHLIST
    // ==========================================

    @Override
    public void addWishlist(Wishlist wishlist) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_WISHLIST)){



            ps.setInt(1,wishlist.getUserId());

            ps.setInt(2,wishlist.getMenuItemId());

            ps.setTimestamp(3,
                    new java.sql.Timestamp(System.currentTimeMillis()));



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Added To Wishlist Successfully");

            else

                System.out.println("Failed To Add Wishlist");



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // GET WISHLIST
    // ==========================================

    @Override
    public Wishlist getWishlist(int wishlistId) {


        Wishlist wishlist = null;



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_WISHLIST)){



            ps.setInt(1,wishlistId);



            ResultSet rs = ps.executeQuery();



            if(rs.next()){


                wishlist = extractWishlist(rs);


            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return wishlist;

    }







    // ==========================================
    // GET USER WISHLIST
    // ==========================================

    @Override
    public List<Wishlist> getWishlistByUser(int userId) {


        List<Wishlist> wishlistList = new ArrayList<>();



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_WISHLIST_BY_USER)){



            ps.setInt(1,userId);



            ResultSet rs = ps.executeQuery();



            while(rs.next()){


                wishlistList.add(extractWishlist(rs));


            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return wishlistList;

    }







    // ==========================================
    // DELETE WISHLIST
    // ==========================================

    @Override
    public void deleteWishlist(int wishlistId) {



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_WISHLIST)){



            ps.setInt(1,wishlistId);



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Removed From Wishlist Successfully");

            else

                System.out.println("Wishlist Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }







    // ==========================================
    // CHECK EXISTS
    // ==========================================

    @Override
    public boolean exists(int userId,int menuItemId) {



        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(CHECK_EXISTS)){



            ps.setInt(1,userId);

            ps.setInt(2,menuItemId);



            ResultSet rs = ps.executeQuery();



            if(rs.next()){

                return rs.getInt(1) > 0;

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return false;

    }








    // ==========================================
    // EXTRACT WISHLIST
    // ==========================================

    private Wishlist extractWishlist(ResultSet rs) throws Exception {


        Wishlist wishlist = new Wishlist();



        wishlist.setWishlistId(
                rs.getInt("wishlist_id")
        );


        wishlist.setUserId(
                rs.getInt("user_id")
        );


        wishlist.setMenuItemId(
                rs.getInt("menu_item_id")
        );


        wishlist.setCreatedAt(
                rs.getTimestamp("created_at")
        );



        return wishlist;

    }

}