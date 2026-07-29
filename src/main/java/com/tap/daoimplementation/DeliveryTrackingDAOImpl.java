package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.DeliveryTrackingDAO;
import com.tap.model.DeliveryTracking;
import com.tap.utility.DBConnection;


public class DeliveryTrackingDAOImpl implements DeliveryTrackingDAO {



    // ==========================================
    // SQL QUERIES
    // ==========================================


    private static final String INSERT_TRACKING =
            "INSERT INTO delivery_tracking(order_id,current_location,delivery_status,updated_at) VALUES(?,?,?,?)";


    private static final String GET_TRACKING =
            "SELECT * FROM delivery_tracking WHERE tracking_id=?";


    private static final String GET_TRACKING_BY_ORDER =
            "SELECT * FROM delivery_tracking WHERE order_id=? ORDER BY updated_at DESC";


    private static final String UPDATE_TRACKING =
            "UPDATE delivery_tracking SET order_id=?,current_location=?,delivery_status=?,updated_at=? WHERE tracking_id=?";


    private static final String DELETE_TRACKING =
            "DELETE FROM delivery_tracking WHERE tracking_id=?";





    // ==========================================
    // ADD TRACKING
    // ==========================================


    @Override
    public void addTracking(DeliveryTracking tracking) {


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(INSERT_TRACKING)) {



            ps.setInt(1, tracking.getOrderId());

            ps.setString(2, tracking.getCurrentLocation());

            ps.setString(3, tracking.getDeliveryStatus());



            Timestamp time = tracking.getUpdatedAt();


            if(time == null){

                time = new Timestamp(
                        System.currentTimeMillis()
                );

            }


            ps.setTimestamp(4, time);



            int rows = ps.executeUpdate();



            if(rows > 0){

                System.out.println(
                        "Tracking Added Successfully"
                );

            }
            else{

                System.out.println(
                        "Failed To Add Tracking"
                );

            }



        }
        catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // GET TRACKING BY ID
    // ==========================================


    @Override
    public DeliveryTracking getTracking(int trackingId) {


        DeliveryTracking tracking = null;



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(GET_TRACKING)) {



            ps.setInt(1, trackingId);



            ResultSet rs =
                    ps.executeQuery();



            if(rs.next()){

                tracking = extractTracking(rs);

            }



        }
        catch(Exception e){

            e.printStackTrace();

        }



        return tracking;

    }





    // ==========================================
    // GET TRACKING BY ORDER
    // ==========================================


    @Override
    public List<DeliveryTracking> getTrackingByOrder(int orderId) {



        List<DeliveryTracking> list =
                new ArrayList<>();



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(GET_TRACKING_BY_ORDER)) {



            ps.setInt(1, orderId);



            ResultSet rs =
                    ps.executeQuery();



            while(rs.next()){


                list.add(
                        extractTracking(rs)
                );


            }



        }
        catch(Exception e){

            e.printStackTrace();

        }



        return list;

    }





    // ==========================================
    // UPDATE TRACKING
    // ==========================================


    @Override
    public void updateTracking(DeliveryTracking tracking) {



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(UPDATE_TRACKING)) {



            ps.setInt(1, tracking.getOrderId());

            ps.setString(2, tracking.getCurrentLocation());

            ps.setString(3, tracking.getDeliveryStatus());



            Timestamp time =
                    tracking.getUpdatedAt();



            if(time == null){

                time =
                new Timestamp(System.currentTimeMillis());

            }



            ps.setTimestamp(4, time);


            ps.setInt(5, tracking.getTrackingId());



            int rows =
                    ps.executeUpdate();




            if(rows > 0){

                System.out.println(
                        "Tracking Updated Successfully"
                );

            }
            else{

                System.out.println(
                        "Failed To Update Tracking"
                );

            }



        }
        catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // DELETE TRACKING
    // ==========================================


    @Override
    public void deleteTracking(int trackingId) {



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(DELETE_TRACKING)) {



            ps.setInt(1, trackingId);



            int rows =
                    ps.executeUpdate();




            if(rows > 0){

                System.out.println(
                        "Tracking Deleted Successfully"
                );

            }
            else{

                System.out.println(
                        "Failed To Delete Tracking"
                );

            }



        }
        catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // EXTRACT TRACKING OBJECT
    // ==========================================


    private DeliveryTracking extractTracking(ResultSet rs)
            throws Exception {



        DeliveryTracking tracking =
                new DeliveryTracking();



        tracking.setTrackingId(
                rs.getInt("tracking_id")
        );


        tracking.setOrderId(
                rs.getInt("order_id")
        );


        tracking.setCurrentLocation(
                rs.getString("current_location")
        );


        tracking.setDeliveryStatus(
                rs.getString("delivery_status")
        );


        tracking.setUpdatedAt(
                rs.getTimestamp("updated_at")
        );



        return tracking;

    }


}