package com.tap.model;

import java.sql.Timestamp;

public class DeliveryTracking {

    private int trackingId;
    private int orderId;
    private String currentLocation;
    private String deliveryStatus;
    private Timestamp updatedAt;


    // ==========================
    // Default Constructor
    // ==========================

    public DeliveryTracking() {
    }


    // ==========================
    // Parameterized Constructor
    // ==========================

    public DeliveryTracking(int orderId,
                            String currentLocation,
                            String deliveryStatus,
                            Timestamp updatedAt) {

        this.orderId = orderId;
        this.currentLocation = currentLocation;
        this.deliveryStatus = deliveryStatus;
        this.updatedAt = updatedAt;
    }



    // ==========================
    // Full Constructor
    // ==========================

    public DeliveryTracking(int trackingId,
                            int orderId,
                            String currentLocation,
                            String deliveryStatus,
                            Timestamp updatedAt) {

        this.trackingId = trackingId;
        this.orderId = orderId;
        this.currentLocation = currentLocation;
        this.deliveryStatus = deliveryStatus;
        this.updatedAt = updatedAt;
    }



    public int getTrackingId() {
        return trackingId;
    }


    public void setTrackingId(int trackingId) {
        this.trackingId = trackingId;
    }



    public int getOrderId() {
        return orderId;
    }


    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }



    public String getCurrentLocation() {
        return currentLocation;
    }


    public void setCurrentLocation(String currentLocation) {
        this.currentLocation = currentLocation;
    }



    public String getDeliveryStatus() {
        return deliveryStatus;
    }


    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }



    public Timestamp getUpdatedAt() {
        return updatedAt;
    }


    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }



    @Override
    public String toString() {

        return "DeliveryTracking{" +
                "trackingId=" + trackingId +
                ", orderId=" + orderId +
                ", currentLocation='" + currentLocation + '\'' +
                ", deliveryStatus='" + deliveryStatus + '\'' +
                ", updatedAt=" + updatedAt +
                '}';

    }

}