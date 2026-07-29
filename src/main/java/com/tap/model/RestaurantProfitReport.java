package com.tap.model;

public class RestaurantProfitReport {

    private int restaurantId;
    private String restaurantName;
    private int totalOrders;
    private double totalRevenue;
    private double estimatedProfit;

    public RestaurantProfitReport() {
    }

    public RestaurantProfitReport(int restaurantId, String restaurantName, int totalOrders, double totalRevenue, double estimatedProfit) {
        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
        this.estimatedProfit = estimatedProfit;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public double getEstimatedProfit() {
        return estimatedProfit;
    }

    public void setEstimatedProfit(double estimatedProfit) {
        this.estimatedProfit = estimatedProfit;
    }
}
