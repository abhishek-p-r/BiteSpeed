package com.tap.daoimplementation;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDAO;
import com.tap.model.Menu;
import com.tap.utility.DBConnection;



public class MenuDAOImpl implements MenuDAO {



    private static final String INSERT_MENU =
            "INSERT INTO menu "
            + "(restaurant_id,item_name,description,price,is_available,"
            + "category,image_path,created_at,updated_at) "
            + "VALUES(?,?,?,?,?,?,?,?,?)";



    private static final String GET_MENU =
            "SELECT * FROM menu "
            + "WHERE menu_id=? "
            + "AND deleted_at IS NULL";



    private static final String GET_ALL_MENU =
            "SELECT * FROM menu "
            + "WHERE deleted_at IS NULL "
            + "ORDER BY menu_id DESC";



    private static final String GET_BY_RESTAURANT =
            "SELECT * FROM menu "
            + "WHERE restaurant_id=? "
            + "AND deleted_at IS NULL "
            + "ORDER BY menu_id";



    private static final String GET_BY_CATEGORY =
            "SELECT * FROM menu "
            + "WHERE category=? "
            + "AND deleted_at IS NULL";



    private static final String GET_AVAILABLE =
            "SELECT * FROM menu "
            + "WHERE is_available=true "
            + "AND deleted_at IS NULL";



    private static final String SEARCH =
            "SELECT * FROM menu "
            + "WHERE item_name LIKE ? "
            + "AND deleted_at IS NULL";



    private static final String UPDATE_MENU =
            "UPDATE menu SET "
            + "restaurant_id=?,"
            + "item_name=?,"
            + "description=?,"
            + "price=?,"
            + "is_available=?,"
            + "category=?,"
            + "image_path=?,"
            + "updated_at=? "
            + "WHERE menu_id=?";



    private static final String DELETE_MENU =
            "UPDATE menu SET deleted_at=? "
            + "WHERE menu_id=?";



    private static final String EXISTS =
            "SELECT COUNT(*) FROM menu WHERE menu_id=?";







    @Override
    public void addMenu(Menu menu) {


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(INSERT_MENU)) {



            Timestamp time =
                    new Timestamp(
                            System.currentTimeMillis()
                    );



            ps.setInt(
                    1,
                    menu.getRestaurantId()
            );


            ps.setString(
                    2,
                    menu.getItemName()
            );


            ps.setString(
                    3,
                    menu.getDescription()
            );


            ps.setDouble(
                    4,
                    menu.getPrice()
            );


            ps.setBoolean(
                    5,
                    menu.isAvailable()
            );


            ps.setString(
                    6,
                    menu.getCategory()
            );


            // Image coming from database/file name
            ps.setString(
                    7,
                    menu.getImage()
            );


            ps.setTimestamp(
                    8,
                    time
            );


            ps.setTimestamp(
                    9,
                    time
            );



            ps.executeUpdate();

            // Sync menu_items table if it exists
            try (Statement st = con.createStatement()) {
                String safeName = menu.getItemName() != null ? menu.getItemName().replace("'", "''") : "";
                String safeDesc = menu.getDescription() != null ? menu.getDescription().replace("'", "''") : "";
                String safeCat = menu.getCategory() != null ? menu.getCategory().replace("'", "''") : "Main Course";
                String safeImg = menu.getImage() != null ? menu.getImage().replace("'", "''") : "";
                st.executeUpdate("INSERT INTO menu_items (restaurant_id, item_name, description, price, is_available, category, image, image_path, created_at, updated_at) VALUES ("
                    + menu.getRestaurantId() + ", '" + safeName + "', '" + safeDesc + "', " + menu.getPrice() + ", " + menu.isAvailable() + ", '" + safeCat + "', '" + safeImg + "', '" + safeImg + "', NOW(), NOW())");
            } catch (Exception ignored) {}

            System.out.println(
                    "Menu Added Successfully"
            );



        }
        catch(Exception e){

            e.printStackTrace();

        }

    }









    @Override
    public Menu getMenu(int menuId) {


        Menu menu = null;



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(GET_MENU)){



            ps.setInt(
                    1,
                    menuId
            );



            ResultSet rs =
                    ps.executeQuery();



            if(rs.next()){

                menu = extractMenu(rs);

            }



        }
        catch(Exception e){

            e.printStackTrace();

        }



        return menu;

    }









    @Override
    public List<Menu> getAllMenus(){
        List<Menu> list = new ArrayList<>();
        String[] queries = {
            "SELECT * FROM menu WHERE deleted_at IS NULL ORDER BY menu_id DESC",
            "SELECT * FROM menu_items WHERE deleted_at IS NULL ORDER BY menu_id DESC",
            "SELECT * FROM menu",
            "SELECT * FROM menu_items",
            "SELECT * FROM menu_item WHERE deleted_at IS NULL",
            "SELECT * FROM menu_item"
        };

        for (String sql : queries) {
            try (Connection con = DBConnection.getConnection();
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    list.add(extractMenu(rs));
                }
                if (!list.isEmpty()) return list;
            } catch (Exception ignored) {}
        }
        return list;
    }

    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantId){
        List<Menu> list = new ArrayList<>();
        String[] queries = {
            "SELECT * FROM menu WHERE restaurant_id=? AND deleted_at IS NULL ORDER BY menu_id DESC",
            "SELECT * FROM menu_items WHERE restaurant_id=? AND deleted_at IS NULL ORDER BY menu_id DESC",
            "SELECT * FROM menu WHERE restaurant_id=?",
            "SELECT * FROM menu_items WHERE restaurant_id=?",
            "SELECT * FROM menu_item WHERE restaurant_id=?"
        };

        for (String sql : queries) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, restaurantId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    list.add(extractMenu(rs));
                }
                if (!list.isEmpty()) return list;
            } catch (Exception ignored) {}
        }

        return list;
    }









    @Override
    public List<Menu> getMenusByCategory(String category){


        List<Menu> list =
                new ArrayList<>();


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(GET_BY_CATEGORY)){



            ps.setString(
                    1,
                    category
            );



            ResultSet rs =
                    ps.executeQuery();



            while(rs.next()){

                list.add(
                        extractMenu(rs)
                );

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }









    @Override
    public List<Menu> getAvailableMenus(){


        List<Menu> list =
                new ArrayList<>();


        try(Connection con = DBConnection.getConnection();

            Statement st =
                    con.createStatement();

            ResultSet rs =
                    st.executeQuery(GET_AVAILABLE)){



            while(rs.next()){


                list.add(
                        extractMenu(rs)
                );


            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }









    @Override
    public List<Menu> searchMenuByName(String name){


        List<Menu> list =
                new ArrayList<>();



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(SEARCH)){



            ps.setString(
                    1,
                    "%" + name + "%"
            );



            ResultSet rs =
                    ps.executeQuery();



            while(rs.next()){


                list.add(
                        extractMenu(rs)
                );

            }



        }
        catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }









    @Override
    public void updateMenu(Menu menu){



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(UPDATE_MENU)){



            ps.setInt(
                    1,
                    menu.getRestaurantId()
            );


            ps.setString(
                    2,
                    menu.getItemName()
            );


            ps.setString(
                    3,
                    menu.getDescription()
            );


            ps.setDouble(
                    4,
                    menu.getPrice()
            );


            ps.setBoolean(
                    5,
                    menu.isAvailable()
            );


            ps.setString(
                    6,
                    menu.getCategory()
            );


            ps.setString(
                    7,
                    menu.getImage()
            );


            ps.setTimestamp(
                    8,
                    new Timestamp(
                            System.currentTimeMillis()
                    )
            );


            ps.setInt(
                    9,
                    menu.getMenuId()
            );



            ps.executeUpdate();

            // Sync menu_items table if it exists
            try (Statement st = con.createStatement()) {
                String safeName = menu.getItemName() != null ? menu.getItemName().replace("'", "''") : "";
                String safeDesc = menu.getDescription() != null ? menu.getDescription().replace("'", "''") : "";
                String safeCat = menu.getCategory() != null ? menu.getCategory().replace("'", "''") : "Main Course";
                String safeImg = menu.getImage() != null ? menu.getImage().replace("'", "''") : "";
                st.executeUpdate("UPDATE menu_items SET restaurant_id=" + menu.getRestaurantId() + ", item_name='" + safeName + "', description='" + safeDesc + "', price=" + menu.getPrice() + ", is_available=" + menu.isAvailable() + ", category='" + safeCat + "', image='" + safeImg + "', image_path='" + safeImg + "', updated_at=NOW() WHERE menu_id=" + menu.getMenuId());
            } catch (Exception ignored) {}



        }
        catch(Exception e){

            e.printStackTrace();

        }

    }









    @Override
    public void deleteMenu(int menuId){


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(DELETE_MENU)){



            ps.setTimestamp(
                    1,
                    new Timestamp(
                            System.currentTimeMillis()
                    )
            );


            ps.setInt(
                    2,
                    menuId
            );


            ps.executeUpdate();



        }
        catch(Exception e){

            e.printStackTrace();

        }

    }









    @Override
    public boolean menuExists(int menuId){



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(EXISTS)){



            ps.setInt(
                    1,
                    menuId
            );



            ResultSet rs =
                    ps.executeQuery();



            if(rs.next()){

                return rs.getInt(1) > 0;

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return false;

    }









    private Menu extractMenu(ResultSet rs) throws Exception {
        Menu menu = new Menu();

        try { menu.setMenuId(rs.getInt("menu_id")); } catch(Exception e) {
            try { menu.setMenuId(rs.getInt("menu_item_id")); } catch(Exception ex) {
                try { menu.setMenuId(rs.getInt("item_id")); } catch(Exception ex2) {
                    try { menu.setMenuId(rs.getInt("id")); } catch(Exception ex3) {}
                }
            }
        }

        try { menu.setRestaurantId(rs.getInt("restaurant_id")); } catch(Exception e) {
            try { menu.setRestaurantId(rs.getInt("rest_id")); } catch(Exception ex) {}
        }

        try { menu.setItemName(rs.getString("item_name")); } catch(Exception e) {
            try { menu.setItemName(rs.getString("name")); } catch(Exception ex) {
                try { menu.setItemName(rs.getString("menu_name")); } catch(Exception ex2) {}
            }
        }

        try { menu.setDescription(rs.getString("description")); } catch(Exception e) {
            try { menu.setDescription(rs.getString("desc")); } catch(Exception ex) {}
        }

        try { menu.setPrice(rs.getDouble("price")); } catch(Exception e) {}

        try { menu.setAvailable(rs.getBoolean("is_available")); } catch(Exception e) {
            try { menu.setAvailable(rs.getBoolean("available")); } catch(Exception ex) {
                menu.setAvailable(true);
            }
        }

        try { menu.setCategory(rs.getString("category")); } catch(Exception e) {
            try { menu.setCategory(rs.getString("category_name")); } catch(Exception ex) {
                menu.setCategory("Gourmet");
            }
        }

        String imgStr = null;
        try { imgStr = rs.getString("image_path"); } catch(Exception e) {}
        if (imgStr == null || imgStr.trim().isEmpty()) {
            try { imgStr = rs.getString("image"); } catch(Exception e) {}
        }
        if (imgStr == null || imgStr.trim().isEmpty()) {
            try { imgStr = rs.getString("image_url"); } catch(Exception e) {}
        }
        if (imgStr == null || imgStr.trim().isEmpty()) {
            try { imgStr = rs.getString("img"); } catch(Exception e) {}
        }
        menu.setImage(imgStr);

        try { menu.setCreatedAt(rs.getTimestamp("created_at")); } catch(Exception e) {}
        try { menu.setUpdatedAt(rs.getTimestamp("updated_at")); } catch(Exception e) {}
        try { menu.setDeletedAt(rs.getTimestamp("deleted_at")); } catch(Exception e) {}

        return menu;
    }



}