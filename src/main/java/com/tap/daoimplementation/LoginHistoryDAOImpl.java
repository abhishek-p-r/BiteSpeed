package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.LoginHistoryDAO;
import com.tap.model.LoginHistory;
import com.tap.utility.DBConnection;


public class LoginHistoryDAOImpl implements LoginHistoryDAO {


    private static final String INSERT_LOGIN =
            "INSERT INTO login_history(user_id, login_time, logout_time, ip_address, device_info, login_status) VALUES(?,?,?,?,?,?)";


    private static final String GET_LOGIN =
            "SELECT * FROM login_history WHERE login_history_id=?";


    private static final String GET_ALL_LOGINS =
            "SELECT * FROM login_history ORDER BY login_history_id";


    private static final String GET_BY_USER =
            "SELECT * FROM login_history WHERE user_id=?";


    private static final String UPDATE_LOGOUT =
            "UPDATE login_history SET logout_time=?, login_status=? WHERE login_history_id=?";



    @Override
    public void addLoginHistory(LoginHistory history) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_LOGIN)) {


            ps.setInt(1, history.getUserId());

            ps.setTimestamp(2, 
                history.getLoginTime() != null ?
                history.getLoginTime() :
                new Timestamp(System.currentTimeMillis())
            );

            ps.setTimestamp(3, history.getLogoutTime());

            ps.setString(4, history.getIpAddress());

            ps.setString(5, history.getDeviceInfo());

            ps.setString(6, history.getLoginStatus());


            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Login History Added Successfully");
            else
                System.out.println("Login History Add Failed");


        } catch(Exception e) {
            e.printStackTrace();
        }
    }





    @Override
    public LoginHistory getLogin(int loginId) {


        LoginHistory history = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_LOGIN)) {


            ps.setInt(1, loginId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()) {

                history = extractLogin(rs);

            }


        } catch(Exception e) {

            e.printStackTrace();

        }


        return history;
    }





    @Override
    public List<LoginHistory> getAllLogins() {


        List<LoginHistory> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(GET_ALL_LOGINS)) {


            while(rs.next()) {

                list.add(extractLogin(rs));

            }


        } catch(Exception e) {

            e.printStackTrace();

        }


        return list;
    }






    @Override
    public List<LoginHistory> getLoginsByUser(int userId) {


        List<LoginHistory> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_BY_USER)) {


            ps.setInt(1, userId);


            ResultSet rs = ps.executeQuery();



            while(rs.next()) {

                list.add(extractLogin(rs));

            }



        } catch(Exception e) {

            e.printStackTrace();

        }


        return list;
    }







    @Override
    public void updateLogoutTime(int loginId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_LOGOUT)) {


            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));

            ps.setString(2, "LOGOUT");

            ps.setInt(3, loginId);



            int rows = ps.executeUpdate();



            if(rows > 0)
                System.out.println("Logout Time Updated Successfully");
            else
                System.out.println("Logout Update Failed");



        } catch(Exception e) {

            e.printStackTrace();

        }
    }







    private LoginHistory extractLogin(ResultSet rs) throws Exception {


        LoginHistory history = new LoginHistory();


        history.setLoginHistoryId(
                rs.getInt("login_history_id")
        );


        history.setUserId(
                rs.getInt("user_id")
        );


        history.setLoginTime(
                rs.getTimestamp("login_time")
        );


        history.setLogoutTime(
                rs.getTimestamp("logout_time")
        );


        history.setIpAddress(
                rs.getString("ip_address")
        );


        history.setDeviceInfo(
                rs.getString("device_info")
        );


        history.setLoginStatus(
                rs.getString("login_status")
        );


        return history;
    }

}