package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuCategoryDAO;
import com.tap.model.MenuCategory;
import com.tap.utility.DBConnection;


public class MenuCategoryDAOImpl implements MenuCategoryDAO {


    private static final String INSERT_CATEGORY =
            "INSERT INTO menu_category(restaurant_id,category_name,description,created_at,updated_at) VALUES(?,?,?,?,?)";


    private static final String GET_CATEGORY =
            "SELECT * FROM menu_category WHERE category_id=? AND deleted_at IS NULL";


    private static final String GET_ALL =
            "SELECT * FROM menu_category WHERE deleted_at IS NULL ORDER BY category_id";


    private static final String GET_BY_RESTAURANT =
            "SELECT * FROM menu_category WHERE restaurant_id=? AND deleted_at IS NULL";


    private static final String UPDATE_CATEGORY =
            "UPDATE menu_category SET restaurant_id=?,category_name=?,description=?,updated_at=? WHERE category_id=?";


    private static final String DELETE_CATEGORY =
            "UPDATE menu_category SET deleted_at=? WHERE category_id=?";


    private static final String EXISTS =
            "SELECT COUNT(*) FROM menu_category WHERE category_id=?";





    @Override
    public void addCategory(MenuCategory category) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_CATEGORY)){


            Timestamp now = new Timestamp(System.currentTimeMillis());


            ps.setInt(1, category.getRestaurantId());

            ps.setString(2, category.getCategoryName());

            ps.setString(3, category.getDescription());

            ps.setTimestamp(4, now);

            ps.setTimestamp(5, now);



            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Category Added Successfully");
            else
                System.out.println("Category Add Failed");



        }catch(Exception e){
            e.printStackTrace();
        }

    }







    @Override
    public MenuCategory getCategory(int categoryId) {


        MenuCategory category = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_CATEGORY)){


            ps.setInt(1, categoryId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                category = extractCategory(rs);

            }



        }catch(Exception e){

            e.printStackTrace();

        }


        return category;

    }







    @Override
    public List<MenuCategory> getAllCategories() {


        List<MenuCategory> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(GET_ALL)){


            while(rs.next()){

                list.add(extractCategory(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }








    @Override
    public List<MenuCategory> getCategoriesByRestaurant(int restaurantId) {


        List<MenuCategory> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_BY_RESTAURANT)){


            ps.setInt(1, restaurantId);


            ResultSet rs = ps.executeQuery();


            while(rs.next()){

                list.add(extractCategory(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }







    @Override
    public void updateCategory(MenuCategory category) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_CATEGORY)){


            ps.setInt(1, category.getRestaurantId());

            ps.setString(2, category.getCategoryName());

            ps.setString(3, category.getDescription());

            ps.setTimestamp(4,new Timestamp(System.currentTimeMillis()));

            ps.setInt(5, category.getCategoryId());



            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Category Updated Successfully");
            else
                System.out.println("Category Update Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }








    @Override
    public void deleteCategory(int categoryId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_CATEGORY)){


            ps.setTimestamp(1,new Timestamp(System.currentTimeMillis()));

            ps.setInt(2,categoryId);



            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Category Deleted Successfully");
            else
                System.out.println("Category Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }








    @Override
    public boolean categoryExists(int categoryId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(EXISTS)){


            ps.setInt(1,categoryId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                return rs.getInt(1) > 0;

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return false;

    }








    private MenuCategory extractCategory(ResultSet rs)throws Exception {


        MenuCategory category = new MenuCategory();


        category.setCategoryId(
                rs.getInt("category_id")
        );


        category.setRestaurantId(
                rs.getInt("restaurant_id")
        );


        category.setCategoryName(
                rs.getString("category_name")
        );


        category.setDescription(
                rs.getString("description")
        );


        category.setCreatedAt(
                rs.getTimestamp("created_at")
        );


        category.setUpdatedAt(
                rs.getTimestamp("updated_at")
        );


        category.setDeletedAt(
                rs.getTimestamp("deleted_at")
        );


        return category;
    }

}