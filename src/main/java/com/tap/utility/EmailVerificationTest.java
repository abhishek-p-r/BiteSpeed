package com.tap.utility;

import java.sql.Timestamp;

import com.tap.daoimplementation.EmailVerificationDAOImpl;
import com.tap.model.EmailVerification;

public class EmailVerificationTest {

    public static void main(String[] args) {

        EmailVerificationDAOImpl dao = new EmailVerificationDAOImpl();

        // ==================================
        // VERIFY EMAIL
        // ==================================

        EmailVerification verification = new EmailVerification();

        verification.setEmail("abhi@gmail.com");
        verification.setVerified(true);
        verification.setVerifiedAt(new Timestamp(System.currentTimeMillis()));

        // dao.verifyEmail(verification);

        // ==================================
        // GET VERIFICATION
        // ==================================

        System.out.println("===== GET VERIFICATION =====");

        EmailVerification getVerification = dao.getVerification("abhi@gmail.com");

        if (getVerification != null) {
            System.out.println(getVerification);
        } else {
            System.out.println("Verification Not Found");
        }

        // ==================================
        // UPDATE VERIFICATION
        // ==================================

        System.out.println("\n===== UPDATE VERIFICATION =====");

        EmailVerification update = dao.getVerification("abhi@gmail.com");

        if (update != null) {

            update.setVerified(false);
            update.setVerifiedAt(new Timestamp(System.currentTimeMillis()));

            // dao.updateVerification(update);

            System.out.println("Verification Ready For Update");
        }

        // ==================================
        // DELETE VERIFICATION
        // ==================================

        // dao.deleteVerification("abhi@gmail.com");

        System.out.println("\nEmail Verification Test Completed Successfully.");
    }
}