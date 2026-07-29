package com.tap.dao;

import java.util.List;

import com.tap.model.Coupon;

public interface CouponDAO {

    // CREATE
    void addCoupon(Coupon coupon);

    // READ
    Coupon getCoupon(int couponId);

    Coupon getCouponByCode(String couponCode);

    List<Coupon> getAllCoupons();

    // UPDATE
    void updateCoupon(Coupon coupon);

    // DELETE
    void deleteCoupon(int couponId);

    // VALIDATION
    boolean couponExists(String couponCode);
}