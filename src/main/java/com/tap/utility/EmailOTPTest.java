package com.tap.utility;

import java.sql.Timestamp;

import com.tap.daoimplementation.EmailOTPDAOImpl;
import com.tap.model.EmailOTP;

public class EmailOTPTest {

    public static void main(String[] args) {

        EmailOTPDAOImpl dao = new EmailOTPDAOImpl();

        // ==================================
        // SAVE OTP
        // ==================================

        EmailOTP otp = new EmailOTP();

        otp.setEmail("abhi@gmail.com");
        otp.setOtp("458963");
        otp.setExpiryTime(new Timestamp(System.currentTimeMillis() + 300000));

        // dao.saveOTP(otp);

        // ==================================
        // GET OTP
        // ==================================

        System.out.println("===== GET OTP =====");

        EmailOTP getOtp = dao.getOTP("abhi@gmail.com");

        if (getOtp != null) {
            System.out.println(getOtp);
        } else {
            System.out.println("OTP Not Found");
        }

        // ==================================
        // UPDATE OTP
        // ==================================

        System.out.println("\n===== UPDATE OTP =====");

        EmailOTP update = dao.getOTP("abhi@gmail.com");

        if (update != null) {

            update.setOtp("987654");
            update.setExpiryTime(new Timestamp(System.currentTimeMillis() + 300000));

            // dao.updateOTP(update);

            System.out.println("OTP Ready For Update");
        }

        // ==================================
        // DELETE OTP
        // ==================================

        // dao.deleteOTP("abhi@gmail.com");

        System.out.println("\nEmail OTP Test Completed Successfully.");
    }
}