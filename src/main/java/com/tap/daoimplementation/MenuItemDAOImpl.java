package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuItemDAO;
import com.tap.model.MenuItem;
import com.tap.utility.DBConnection;


public class MenuItemDAOImpl implements MenuItemDAO {


    private static final String INSERT_MENU_ITEM =
            "INSERT INTO menu_item(restaurant_id,category_id,item_name,description,price,image_url,is_available,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?)";


    private static final String GET_MENU_ITEM =
            "SELECT * FROM menu_item WHERE menu_item_id=?";


    private static final String GET_ALL_MENU_ITEMS =
            "SELECT * FROM menu_item WHERE deleted_at IS NULL ORDER BY menu_item_id";


    private static final String GET_BY_RESTAURANT =
            "SELECT * FROM menu_item WHERE restaurant_id=? AND deleted_at IS NULL";


    private static final String GET_BY_CATEGORY =
            "SELECT * FROM menu_item WHERE category_id=? AND deleted_at IS NULL";


    private static final String SEARCH_MENU_ITEM =
            "SELECT * FROM menu_item WHERE item_name LIKE ? AND deleted_at IS NULL";


    private static final String GET_AVAILABLE =
            "SELECT * FROM menu_item WHERE is_available=true AND deleted_at IS NULL";


    private static final String UPDATE_MENU_ITEM =
            "UPDATE menu_item SET restaurant_id=?,category_id=?,item_name=?,description=?,price=?,image_url=?,is_available=?,updated_at=? WHERE menu_item_id=?";


    private static final String DELETE_MENU_ITEM =
            "UPDATE menu_item SET deleted_at=? WHERE menu_item_id=?";


    private static final String EXISTS =
            "SELECT COUNT(*) FROM menu_item WHERE menu_item_id=?";





    // ADD MENU ITEM

    @Override
    public void addMenuItem(MenuItem menuItem) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_MENU_ITEM)){


            Timestamp now = new Timestamp(System.currentTimeMillis());


            ps.setInt(1, menuItem.getRestaurantId());

            ps.setInt(2, menuItem.getCategoryId());

            ps.setString(3, menuItem.getItemName());

            ps.setString(4, menuItem.getDescription());

            ps.setDouble(5, menuItem.getPrice());

            ps.setString(6, menuItem.getImageUrl());

            ps.setBoolean(7, menuItem.isAvailable());

            ps.setTimestamp(8, now);

            ps.setTimestamp(9, now);



            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Menu Item Added Successfully");


        }catch(Exception e){

            e.printStackTrace();

        }

    }







    // GET MENU ITEM

    @Override
    public MenuItem getMenuItem(int menuItemId) {


        MenuItem item = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_MENU_ITEM)){


            ps.setInt(1, menuItemId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                item = extractMenuItem(rs);

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return item;

    }








    // GET ALL ITEMS

    @Override
    public List<MenuItem> getAllMenuItems() {


        List<MenuItem> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(GET_ALL_MENU_ITEMS)){


            while(rs.next()){

                list.add(extractMenuItem(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }








    // GET BY RESTAURANT

    @Override
    public List<MenuItem> getMenuItemsByRestaurant(int restaurantId) {


        List<MenuItem> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_BY_RESTAURANT)){


            ps.setInt(1, restaurantId);


            ResultSet rs = ps.executeQuery();


            while(rs.next()){

                list.add(extractMenuItem(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }








    // GET BY CATEGORY

    @Override
    public List<MenuItem> getMenuItemsByCategory(int categoryId) {


        List<MenuItem> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_BY_CATEGORY)){


            ps.setInt(1, categoryId);


            ResultSet rs = ps.executeQuery();


            while(rs.next()){

                list.add(extractMenuItem(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }








    // SEARCH ITEM

    @Override
    public List<MenuItem> searchMenuItem(String keyword) {


        List<MenuItem> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(SEARCH_MENU_ITEM)){


            ps.setString(1, "%" + keyword + "%");


            ResultSet rs = ps.executeQuery();


            while(rs.next()){

                list.add(extractMenuItem(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }








    // AVAILABLE ITEMS

    @Override
    public List<MenuItem> getAvailableMenuItems() {


        List<MenuItem> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(GET_AVAILABLE)){


            while(rs.next()){

                list.add(extractMenuItem(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }








    // UPDATE ITEM

    @Override
    public void updateMenuItem(MenuItem menuItem) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_MENU_ITEM)){


            ps.setInt(1, menuItem.getRestaurantId());

            ps.setInt(2, menuItem.getCategoryId());

            ps.setString(3, menuItem.getItemName());

            ps.setString(4, menuItem.getDescription());

            ps.setDouble(5, menuItem.getPrice());

            ps.setString(6, menuItem.getImageUrl());

            ps.setBoolean(7, menuItem.isAvailable());

            ps.setTimestamp(8,
                    new Timestamp(System.currentTimeMillis())
            );

            ps.setInt(9, menuItem.getMenuItemId());



            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Menu Item Updated Successfully");


        }catch(Exception e){

            e.printStackTrace();

        }

    }








    // DELETE ITEM (SOFT DELETE)

    @Override
    public void deleteMenuItem(int menuItemId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_MENU_ITEM)){


            ps.setTimestamp(1,
                    new Timestamp(System.currentTimeMillis())
            );


            ps.setInt(2, menuItemId);



            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Menu Item Deleted Successfully");


        }catch(Exception e){

            e.printStackTrace();

        }

    }








    // EXISTS

    @Override
    public boolean menuItemExists(int menuItemId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(EXISTS)){


            ps.setInt(1, menuItemId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                return rs.getInt(1) > 0;

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return false;

    }








    // EXTRACT OBJECT

    private MenuItem extractMenuItem(ResultSet rs)throws Exception {


        MenuItem item = new MenuItem();


        item.setMenuItemId(
                rs.getInt("menu_item_id")
        );


        item.setRestaurantId(
                rs.getInt("restaurant_id")
        );


        item.setCategoryId(
                rs.getInt("category_id")
        );


        item.setItemName(
                rs.getString("item_name")
        );


        item.setDescription(
                rs.getString("description")
        );


        item.setPrice(
                rs.getDouble("price")
        );


        item.setImageUrl(
                rs.getString("image_url")
        );


        item.setAvailable(
                rs.getBoolean("is_available")
        );


        item.setCreatedAt(
                rs.getTimestamp("created_at")
        );


        item.setUpdatedAt(
                rs.getTimestamp("updated_at")
        );


        item.setDeletedAt(
                rs.getTimestamp("deleted_at")
        );


        return item;

    }

}