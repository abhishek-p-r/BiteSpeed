package com.tap.utility;


import java.sql.Timestamp;
import java.util.List;

import com.tap.daoimplementation.DeliveryTrackingDAOImpl;
import com.tap.model.DeliveryTracking;



public class DeliveryTrackingTest {


    public static void main(String[] args) {


        DeliveryTrackingDAOImpl dao =
                new DeliveryTrackingDAOImpl();



        // ==================================
        // ADD TRACKING
        // ==================================

        DeliveryTracking tracking =
                new DeliveryTracking();


        tracking.setOrderId(1);

        tracking.setCurrentLocation(
                "Bangalore Hub"
        );


        tracking.setDeliveryStatus(
                "Out For Delivery"
        );


        tracking.setUpdatedAt(
                new Timestamp(System.currentTimeMillis())
        );



        // Uncomment to insert
        // dao.addTracking(tracking);




        // ==================================
        // GET TRACKING
        // ==================================

        System.out.println(
                "========== GET TRACKING =========="
        );


        DeliveryTracking result =
                dao.getTracking(1);



        if(result != null){

            System.out.println(result);

        }
        else{

            System.out.println(
                    "Tracking Not Found"
            );

        }





        // ==================================
        // GET BY ORDER
        // ==================================

        System.out.println(
                "\n========== ORDER TRACKING =========="
        );


        List<DeliveryTracking> list =
                dao.getTrackingByOrder(1);



        for(DeliveryTracking t : list){

            System.out.println(t);

        }





        // ==================================
        // UPDATE
        // ==================================

        System.out.println(
                "\n========== UPDATE TRACKING =========="
        );



        DeliveryTracking update =
                dao.getTracking(1);



        if(update != null){


            update.setCurrentLocation(
                    "Mysore Delivery Center"
            );


            update.setDeliveryStatus(
                    "Delivered"
            );


            update.setUpdatedAt(
                    new Timestamp(System.currentTimeMillis())
            );



            // Uncomment to update
            // dao.updateTracking(update);


            System.out.println(
                    "Tracking Ready For Update"
            );

        }





        // ==================================
        // DELETE
        // ==================================

        // dao.deleteTracking(1);



        System.out.println(
                "\nDelivery Tracking Test Completed Successfully"
        );


    }

}