package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.CartDAO;
import com.tap.model.Cart;
import com.tap.utility.DBConnection;


public class CartDAOImpl implements CartDAO {


    private static final String INSERT_CART =
            "INSERT INTO cart(user_id,created_at,updated_at) VALUES(?,?,?)";


    private static final String GET_CART =
            "SELECT * FROM cart WHERE cart_id=?";


    private static final String GET_CART_BY_USER =
            "SELECT * FROM cart WHERE user_id=?";


    private static final String GET_ALL_CARTS =
            "SELECT * FROM cart ORDER BY cart_id";


    private static final String UPDATE_CART =
            "UPDATE cart SET user_id=?, updated_at=? WHERE cart_id=?";


    private static final String DELETE_CART =
            "DELETE FROM cart WHERE cart_id=?";


    private static final String CHECK_CART =
            "SELECT COUNT(*) FROM cart WHERE cart_id=?";



    @Override
    public void addCart(Cart cart) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_CART)){


            Timestamp time =
                    new Timestamp(System.currentTimeMillis());


            ps.setInt(1, cart.getUserId());
            ps.setTimestamp(2,time);
            ps.setTimestamp(3,time);


            ps.executeUpdate();


            System.out.println("Cart Added Successfully");


        }catch(Exception e){

            e.printStackTrace();

        }

    }



    @Override
    public Cart getCart(int cartId){


        Cart cart=null;


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(GET_CART)){


            ps.setInt(1,cartId);


            ResultSet rs=ps.executeQuery();


            if(rs.next()){

                cart=new Cart();

                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setCreatedAt(rs.getTimestamp("created_at"));
                cart.setUpdatedAt(rs.getTimestamp("updated_at"));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return cart;

    }





    @Override
    public Cart getCartByUser(int userId){


        Cart cart=null;


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(GET_CART_BY_USER)){


            ps.setInt(1,userId);


            ResultSet rs=ps.executeQuery();


            if(rs.next()){

                cart=new Cart();

                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setCreatedAt(rs.getTimestamp("created_at"));
                cart.setUpdatedAt(rs.getTimestamp("updated_at"));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return cart;

    }





    @Override
    public List<Cart> getAllCarts(){


        List<Cart> list=new ArrayList<>();


        try(Connection con=DBConnection.getConnection();
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery(GET_ALL_CARTS)){


            while(rs.next()){


                Cart cart=new Cart();


                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setCreatedAt(rs.getTimestamp("created_at"));
                cart.setUpdatedAt(rs.getTimestamp("updated_at"));


                list.add(cart);

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }





    @Override
    public void updateCart(Cart cart){


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(UPDATE_CART)){


            ps.setInt(1,cart.getUserId());

            ps.setTimestamp(2,
                    new Timestamp(System.currentTimeMillis()));

            ps.setInt(3,cart.getCartId());


            ps.executeUpdate();


            System.out.println("Cart Updated Successfully");


        }catch(Exception e){

            e.printStackTrace();

        }

    }





    @Override
    public void deleteCart(int cartId){


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(DELETE_CART)){


            ps.setInt(1,cartId);


            ps.executeUpdate();


            System.out.println("Cart Deleted Successfully");


        }catch(Exception e){

            e.printStackTrace();

        }

    }





    @Override
    public boolean cartExists(int cartId){


        try(Connection con=DBConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(CHECK_CART)){


            ps.setInt(1,cartId);


            ResultSet rs=ps.executeQuery();


            if(rs.next()){

                return rs.getInt(1)>0;

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return false;

    }

}