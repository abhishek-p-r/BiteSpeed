package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.CouponDAO;
import com.tap.model.Coupon;
import com.tap.utility.DBConnection;

public class CouponDAOImpl implements CouponDAO {

    // =====================================================
    // SQL QUERIES
    // =====================================================

    private static final String INSERT_COUPON =
            "INSERT INTO coupons(coupon_code,discount_percentage,expiry_date,minimum_order_amount,is_active) VALUES(?,?,?,?,?)";

    private static final String GET_COUPON =
            "SELECT * FROM coupons WHERE coupon_id=?";

    private static final String GET_COUPON_BY_CODE =
            "SELECT * FROM coupons WHERE coupon_code=?";

    private static final String GET_ALL_COUPONS =
            "SELECT * FROM coupons ORDER BY coupon_id";

    private static final String UPDATE_COUPON =
            "UPDATE coupons SET coupon_code=?,discount_percentage=?,expiry_date=?,minimum_order_amount=?,is_active=? WHERE coupon_id=?";

    private static final String DELETE_COUPON =
            "DELETE FROM coupons WHERE coupon_id=?";

    private static final String COUPON_EXISTS =
            "SELECT COUNT(*) FROM coupons WHERE coupon_code=?";

    // =====================================================
    // ADD COUPON
    // =====================================================

    @Override
    public void addCoupon(Coupon coupon) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_COUPON)) {

            ps.setString(1, coupon.getCouponCode());
            ps.setDouble(2, coupon.getDiscountPercentage());
            ps.setDate(3, coupon.getExpiryDate());
            ps.setDouble(4, coupon.getMinimumOrderAmount());
            ps.setBoolean(5, coupon.isActive());

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Coupon Added Successfully");
            else
                System.out.println("Failed To Add Coupon");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================================
    // GET COUPON BY ID
    // =====================================================

    @Override
    public Coupon getCoupon(int couponId) {

        Coupon coupon = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_COUPON)) {

            ps.setInt(1, couponId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                coupon = extractCoupon(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return coupon;
    }

    // =====================================================
    // GET COUPON BY CODE
    // =====================================================

    @Override
    public Coupon getCouponByCode(String couponCode) {

        Coupon coupon = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_COUPON_BY_CODE)) {

            ps.setString(1, couponCode);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                coupon = extractCoupon(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return coupon;
    }
    // =====================================================
    // GET ALL COUPONS
    // =====================================================

    @Override
    public List<Coupon> getAllCoupons() {

        List<Coupon> coupons = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_COUPONS)) {

            while (rs.next()) {
                coupons.add(extractCoupon(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return coupons;
    }

    // =====================================================
    // UPDATE COUPON
    // =====================================================

    @Override
    public void updateCoupon(Coupon coupon) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_COUPON)) {

            ps.setString(1, coupon.getCouponCode());
            ps.setDouble(2, coupon.getDiscountPercentage());
            ps.setDate(3, coupon.getExpiryDate());
            ps.setDouble(4, coupon.getMinimumOrderAmount());
            ps.setBoolean(5, coupon.isActive());
            ps.setInt(6, coupon.getCouponId());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                System.out.println("Coupon Updated Successfully");
            } else {
                System.out.println("Failed To Update Coupon");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================================
    // DELETE COUPON
    // =====================================================

    @Override
    public void deleteCoupon(int couponId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_COUPON)) {

            ps.setInt(1, couponId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                System.out.println("Coupon Deleted Successfully");
            } else {
                System.out.println("Failed To Delete Coupon");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // =====================================================
    // COUPON EXISTS
    // =====================================================

    @Override
    public boolean couponExists(String couponCode) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(COUPON_EXISTS)) {

            ps.setString(1, couponCode);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // EXTRACT COUPON
    // =====================================================

    private Coupon extractCoupon(ResultSet rs) throws Exception {

        Coupon coupon = new Coupon();

        coupon.setCouponId(rs.getInt("coupon_id"));
        coupon.setCouponCode(rs.getString("coupon_code"));
        coupon.setDiscountPercentage(rs.getDouble("discount_percentage"));
        coupon.setExpiryDate(rs.getDate("expiry_date"));
        coupon.setMinimumOrderAmount(rs.getDouble("minimum_order_amount"));
        coupon.setActive(rs.getBoolean("is_active"));

        return coupon;
    }

}