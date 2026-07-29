package com.tap.daoimplementation;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.NotificationDAO;
import com.tap.model.Notification;
import com.tap.utility.DBConnection;



public class NotificationDAOImpl implements NotificationDAO {



    private static final String INSERT_NOTIFICATION =
            "INSERT INTO notification(user_id,title,message,is_read,created_at) VALUES(?,?,?,?,?)";



    private static final String GET_NOTIFICATION =
            "SELECT * FROM notification WHERE notification_id=?";



    private static final String GET_BY_USER =
            "SELECT * FROM notification WHERE user_id=? ORDER BY created_at DESC";



    private static final String MARK_READ =
            "UPDATE notification SET is_read=true WHERE notification_id=?";



    private static final String DELETE_NOTIFICATION =
            "DELETE FROM notification WHERE notification_id=?";







    // ==========================
    // ADD NOTIFICATION
    // ==========================

    @Override
    public void addNotification(Notification notification) {



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(INSERT_NOTIFICATION)){



            ps.setInt(1, notification.getUserId());

            ps.setString(2, notification.getTitle());

            ps.setString(3, notification.getMessage());

            ps.setBoolean(4, notification.isRead());

            ps.setTimestamp(5,
                    new java.sql.Timestamp(
                            System.currentTimeMillis()
                    )
            );



            int rows = ps.executeUpdate();



            if(rows > 0)
                System.out.println("Notification Added Successfully");

            else
                System.out.println("Notification Add Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }









    // ==========================
    // GET NOTIFICATION
    // ==========================

    @Override
    public Notification getNotification(int notificationId) {



        Notification notification = null;



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(GET_NOTIFICATION)){



            ps.setInt(1, notificationId);



            ResultSet rs = ps.executeQuery();



            if(rs.next()){

                notification = extractNotification(rs);

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return notification;

    }









    // ==========================
    // GET USER NOTIFICATIONS
    // ==========================

    @Override
    public List<Notification> getNotificationsByUser(int userId) {



        List<Notification> list = new ArrayList<>();



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(GET_BY_USER)){



            ps.setInt(1,userId);



            ResultSet rs = ps.executeQuery();



            while(rs.next()){


                list.add(extractNotification(rs));


            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return list;

    }









    // ==========================
    // MARK AS READ
    // ==========================

    @Override
    public void markAsRead(int notificationId) {



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(MARK_READ)){



            ps.setInt(1, notificationId);



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Notification Marked As Read");

            else

                System.out.println("Notification Not Found");



        }catch(Exception e){

            e.printStackTrace();

        }

    }









    // ==========================
    // DELETE NOTIFICATION
    // ==========================

    @Override
    public void deleteNotification(int notificationId) {



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(DELETE_NOTIFICATION)){



            ps.setInt(1, notificationId);



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Notification Deleted Successfully");

            else

                System.out.println("Notification Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }









    // ==========================
    // EXTRACT OBJECT
    // ==========================

    private Notification extractNotification(ResultSet rs) throws Exception {



        Notification notification = new Notification();



        notification.setNotificationId(
                rs.getInt("notification_id")
        );



        notification.setUserId(
                rs.getInt("user_id")
        );



        notification.setTitle(
                rs.getString("title")
        );



        notification.setMessage(
                rs.getString("message")
        );



        notification.setRead(
                rs.getBoolean("is_read")
        );



        notification.setCreatedAt(
                rs.getTimestamp("created_at")
        );



        return notification;

    }

}