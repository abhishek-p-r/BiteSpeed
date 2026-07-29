package com.tap.utility;

import java.sql.Date;
import java.util.List;

import com.tap.daoimplementation.CouponDAOImpl;
import com.tap.model.Coupon;

public class CouponTest {

    public static void main(String[] args) {

        CouponDAOImpl dao = new CouponDAOImpl();

        // ==========================================
        // ADD COUPON
        // ==========================================

        Coupon coupon = new Coupon();

        coupon.setCouponCode("SAVE20");
        coupon.setDiscountPercentage(20);
        coupon.setExpiryDate(Date.valueOf("2027-12-31"));
        coupon.setMinimumOrderAmount(500);
        coupon.setActive(true);

        // dao.addCoupon(coupon);

        // ==========================================
        // GET COUPON BY ID
        // ==========================================

        System.out.println("===== GET COUPON =====");

        Coupon c = dao.getCoupon(1);

        if (c != null)
            System.out.println(c);
        else
            System.out.println("Coupon Not Found");

        // ==========================================
        // GET COUPON BY CODE
        // ==========================================

        System.out.println("\n===== GET COUPON BY CODE =====");

        Coupon codeCoupon = dao.getCouponByCode("SAVE20");

        if (codeCoupon != null)
            System.out.println(codeCoupon);
        else
            System.out.println("Coupon Code Not Found");

        // ==========================================
        // GET ALL COUPONS
        // ==========================================

        System.out.println("\n===== ALL COUPONS =====");

        List<Coupon> coupons = dao.getAllCoupons();

        for (Coupon cp : coupons) {
            System.out.println(cp);
        }

        // ==========================================
        // UPDATE COUPON
        // ==========================================

        System.out.println("\n===== UPDATE COUPON =====");

        Coupon update = dao.getCoupon(1);

        if (update != null) {

            update.setCouponCode("SAVE25");
            update.setDiscountPercentage(25);
            update.setExpiryDate(Date.valueOf("2028-01-31"));
            update.setMinimumOrderAmount(700);
            update.setActive(true);

            // dao.updateCoupon(update);

            System.out.println("Coupon Ready For Update");
        }

        // ==========================================
        // CHECK COUPON EXISTS
        // ==========================================

        System.out.println("\n===== COUPON EXISTS =====");

        boolean exists = dao.couponExists("SAVE20");

        System.out.println(exists);

        // ==========================================
        // DELETE COUPON
        // ==========================================

        // dao.deleteCoupon(1);

        System.out.println("\nCoupon Test Completed Successfully.");
    }
}