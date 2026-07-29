package com.tap.daoimplementation;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;


import com.tap.dao.CartItemDAO;
import com.tap.model.CartItem;
import com.tap.utility.DBConnection;



public class CartItemDAOImpl implements CartItemDAO {



    private static final String INSERT_CART_ITEM =
            "INSERT INTO cart_items(cart_id,menu_id,quantity,price) VALUES(?,?,?,?)";


    private static final String GET_CART_ITEM =
            "SELECT * FROM cart_items WHERE cart_item_id=?";


    private static final String GET_ALL_CART_ITEMS =
            "SELECT * FROM cart_items ORDER BY cart_item_id";


    private static final String GET_CART_ITEMS_BY_CART =
            "SELECT * FROM cart_items WHERE cart_id=?";


    private static final String UPDATE_CART_ITEM =
            "UPDATE cart_items SET cart_id=?,menu_id=?,quantity=?,price=? WHERE cart_item_id=?";


    private static final String DELETE_CART_ITEM =
            "DELETE FROM cart_items WHERE cart_item_id=?";


    private static final String CART_ITEM_EXISTS =
            "SELECT COUNT(*) FROM cart_items WHERE cart_item_id=?";





    @Override
    public void addCartItem(CartItem cartItem) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_CART_ITEM)){


            ps.setInt(1, cartItem.getCartId());
            ps.setInt(2, cartItem.getMenuId());
            ps.setInt(3, cartItem.getQuantity());
            ps.setDouble(4, cartItem.getPrice());


            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Cart Item Added Successfully");


        }
        catch(Exception e){

            e.printStackTrace();

        }

    }





    @Override
    public CartItem getCartItem(int cartItemId) {


        CartItem item = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_CART_ITEM)){


            ps.setInt(1, cartItemId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                item = extractCartItem(rs);

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return item;

    }





    @Override
    public List<CartItem> getAllCartItems(){


        List<CartItem> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(GET_ALL_CART_ITEMS)){


            while(rs.next()){

                list.add(extractCartItem(rs));

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }





    @Override
    public List<CartItem> getCartItemsByCart(int cartId){


        List<CartItem> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_CART_ITEMS_BY_CART)){


            ps.setInt(1, cartId);


            ResultSet rs = ps.executeQuery();


            while(rs.next()){

                list.add(extractCartItem(rs));

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }





    @Override
    public void updateCartItem(CartItem cartItem){


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_CART_ITEM)){


            ps.setInt(1, cartItem.getCartId());
            ps.setInt(2, cartItem.getMenuId());
            ps.setInt(3, cartItem.getQuantity());
            ps.setDouble(4, cartItem.getPrice());
            ps.setInt(5, cartItem.getCartItemId());


            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Cart Item Updated Successfully");


        }
        catch(Exception e){

            e.printStackTrace();

        }

    }





    @Override
    public void deleteCartItem(int cartItemId){


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_CART_ITEM)){


            ps.setInt(1, cartItemId);


            ps.executeUpdate();


            System.out.println("Cart Item Deleted Successfully");


        }
        catch(Exception e){

            e.printStackTrace();

        }

    }





    @Override
    public boolean cartItemExists(int cartItemId){


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(CART_ITEM_EXISTS)){


            ps.setInt(1, cartItemId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                return rs.getInt(1) > 0;

            }

        }
        catch(Exception e){

            e.printStackTrace();

        }


        return false;

    }





    private CartItem extractCartItem(ResultSet rs)throws Exception{


        CartItem item = new CartItem();


        item.setCartItemId(rs.getInt("cart_item_id"));
        item.setCartId(rs.getInt("cart_id"));
        item.setMenuId(rs.getInt("menu_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPrice(rs.getDouble("price"));


        return item;

    }

}