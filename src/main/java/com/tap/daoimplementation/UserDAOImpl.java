package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.UserDAO;
import com.tap.model.User;
import com.tap.utility.DBConnection;


public class UserDAOImpl implements UserDAO {


	private static final String INSERT_USER =
			"INSERT INTO users(full_name,email,phone,password,role,status,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?)";
	
    private static final String GET_USER =
            "SELECT * FROM users WHERE user_id=?";


    private static final String GET_USER_BY_EMAIL =
            "SELECT * FROM users WHERE email=?";


    private static final String GET_USER_BY_PHONE =
            "SELECT * FROM users WHERE phone=?";


    private static final String GET_ALL_USERS =
            "SELECT * FROM users ORDER BY user_id";


    private static final String UPDATE_USER =
    		"UPDATE users SET full_name=?,email=?,phone=?,password=?,gender=?,dob=?,profile_image=?,role=?,status=?,updated_at=? WHERE user_id=?";

    private static final String DELETE_USER =
            "DELETE FROM users WHERE user_id=?";


    private static final String UPDATE_LAST_LOGIN =
            "UPDATE users SET updated_at=? WHERE user_id=?";



    // ============================
    // ADD USER
    // ============================
    @Override
    public boolean addUser(User user) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_USER)) {


            Timestamp time = 
                    new Timestamp(System.currentTimeMillis());


            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());
            ps.setTimestamp(7, time);
            ps.setTimestamp(8, time);



            int rows = ps.executeUpdate();


            System.out.println("Inserted rows : " + rows);


            return rows > 0;


        } catch(Exception e) {

            e.printStackTrace();

        }


        return false;
    }

    // ============================
    // GET USER BY ID
    // ============================

    @Override
    public User getUser(int userId) {


        User user = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_USER)){


            ps.setInt(1,userId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                user = extractUser(rs);

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return user;

    }




    // ============================
    // GET USER BY EMAIL
    // ============================

    @Override
    public User getUserByEmail(String email) {


        User user = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps =
            con.prepareStatement(GET_USER_BY_EMAIL)){


            ps.setString(1,email);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                user = extractUser(rs);

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return user;

    }




    // ============================
    // GET USER BY PHONE
    // ============================

    @Override
    public User getUserByPhone(String phone) {


        User user=null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps =
            con.prepareStatement(GET_USER_BY_PHONE)){


            ps.setString(1,phone);


            ResultSet rs=ps.executeQuery();


            if(rs.next()){

                user=extractUser(rs);

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return user;

    }




    // ============================
    // GET ALL USERS
    // ============================

    @Override
    public List<User> getAllUsers() {


        List<User> users = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs =
            st.executeQuery(GET_ALL_USERS)){


            while(rs.next()){

                users.add(extractUser(rs));

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return users;

    }




    // ============================
    // UPDATE USER
    // ============================

 
    @Override
    public boolean updateUser(User user) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_USER)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getGender());
            ps.setDate(6, user.getDob());
            ps.setString(7, user.getProfileImage());
            ps.setString(8, user.getRole());
            ps.setString(9, user.getStatus());
            ps.setTimestamp(10, new Timestamp(System.currentTimeMillis()));
            ps.setInt(11, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }



    // ============================
    // UPDATE LAST LOGIN
    // ============================

    @Override
    public void updateLastLogin(int userId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps =
            con.prepareStatement(UPDATE_LAST_LOGIN)){


            ps.setTimestamp(1,
                    new Timestamp(System.currentTimeMillis())
            );


            ps.setInt(2,userId);


            ps.executeUpdate();


        }
        catch(Exception e){

            e.printStackTrace();

        }

    }





    // ============================
    // DELETE USER
    // ============================

    @Override
    public void deleteUser(int userId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps =
            con.prepareStatement(DELETE_USER)){


            ps.setInt(1,userId);

            ps.executeUpdate();


        }
        catch(Exception e){

            e.printStackTrace();

        }

    }





    // ============================
    // EMAIL EXISTS
    // ============================

    @Override
    public boolean emailExists(String email) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps =
            con.prepareStatement(
            "SELECT COUNT(*) FROM users WHERE email=?")){


            ps.setString(1,email);


            ResultSet rs=ps.executeQuery();


            if(rs.next()){

                return rs.getInt(1)>0;

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return false;

    }





    // ============================
    // PHONE EXISTS
    // ============================

    @Override
    public boolean phoneExists(String phone) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps =
            con.prepareStatement(
            "SELECT COUNT(*) FROM users WHERE phone=?")){


            ps.setString(1,phone);


            ResultSet rs=ps.executeQuery();


            if(rs.next()){

                return rs.getInt(1)>0;

            }


        }
        catch(Exception e){

            e.printStackTrace();

        }


        return false;

    }





    // ============================
    // EXTRACT USER
    // ============================
    private User extractUser(ResultSet rs) throws Exception {

        User user = new User();

        try { user.setUserId(rs.getInt("user_id")); } catch (Exception e) { try { user.setUserId(rs.getInt("id")); } catch (Exception ex) {} }
        
        try {
            user.setFullName(rs.getString("full_name"));
        } catch (Exception e) {
            try { user.setFullName(rs.getString("name")); } catch (Exception ex) {}
        }
        
        try { user.setEmail(rs.getString("email")); } catch (Exception e) {}
        
        try {
            user.setPhone(rs.getString("phone"));
        } catch (Exception e) {
            try { user.setPhone(rs.getString("phone_number")); } catch (Exception ex) {}
        }
        
        try { user.setPassword(rs.getString("password")); } catch (Exception e) {}
        try { user.setRole(rs.getString("role")); } catch (Exception e) {}
        try { user.setGender(rs.getString("gender")); } catch (Exception e) {}
        try { user.setDob(rs.getDate("dob")); } catch (Exception e) {}
        try { user.setProfileImage(rs.getString("profile_image")); } catch (Exception e) {}
        
        try {
            user.setStatus(rs.getString("status"));
        } catch (Exception e) {
            try { user.setStatus(rs.getBoolean("active") ? "ACTIVE" : "INACTIVE"); } catch (Exception ex) {}
        }
        
        try { user.setCreatedAt(rs.getTimestamp("created_at")); } catch (Exception e) {}
        try { user.setUpdatedAt(rs.getTimestamp("updated_at")); } catch (Exception e) {}

        return user;
    }

    
}