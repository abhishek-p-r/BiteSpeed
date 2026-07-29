package com.tap.dao;

import java.util.List;

import com.tap.model.DeliveryTracking;


public interface DeliveryTrackingDAO {


    void addTracking(DeliveryTracking tracking);



    DeliveryTracking getTracking(int trackingId);



    List<DeliveryTracking> getTrackingByOrder(int orderId);



    void updateTracking(DeliveryTracking tracking);



    void deleteTracking(int trackingId);


}