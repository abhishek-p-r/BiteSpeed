package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import com.tap.dao.EmailVerificationDAO;
import com.tap.model.EmailVerification;
import com.tap.utility.DBConnection;

public class EmailVerificationDAOImpl implements EmailVerificationDAO {

    // =====================================
    // SQL QUERIES
    // =====================================

    private static final String INSERT_VERIFICATION =
            "INSERT INTO email_verification(email,is_verified,verified_at) VALUES(?,?,?)";

    private static final String GET_VERIFICATION =
            "SELECT * FROM email_verification WHERE email=?";

    private static final String UPDATE_VERIFICATION =
            "UPDATE email_verification SET is_verified=?,verified_at=? WHERE email=?";

    private static final String DELETE_VERIFICATION =
            "DELETE FROM email_verification WHERE email=?";

    // =====================================
    // VERIFY EMAIL
    // =====================================

    @Override
    public void verifyEmail(EmailVerification verification) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_VERIFICATION)) {

            ps.setString(1, verification.getEmail());
            ps.setBoolean(2, verification.isVerified());

            Timestamp timestamp = verification.getVerifiedAt();

            if (timestamp == null) {
                timestamp = new Timestamp(System.currentTimeMillis());
            }

            ps.setTimestamp(3, timestamp);

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Email Verified Successfully");
            else
                System.out.println("Failed To Verify Email");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================
    // GET VERIFICATION
    // =====================================

    @Override
    public EmailVerification getVerification(String email) {

        EmailVerification verification = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_VERIFICATION)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                verification = extractVerification(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return verification;
    }

// =====================================
// UPDATE VERIFICATION
// =====================================

@Override
public void updateVerification(EmailVerification verification) {

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(UPDATE_VERIFICATION)) {

        ps.setBoolean(1, verification.isVerified());

        Timestamp timestamp = verification.getVerifiedAt();

        if (timestamp == null) {
            timestamp = new Timestamp(System.currentTimeMillis());
        }

        ps.setTimestamp(2, timestamp);
        ps.setString(3, verification.getEmail());

        int rows = ps.executeUpdate();

        if (rows > 0)
            System.out.println("Email Verification Updated Successfully");
        else
            System.out.println("Failed To Update Email Verification");

    } catch (Exception e) {
        e.printStackTrace();
    }
}

// =====================================
// DELETE VERIFICATION
// =====================================

@Override
public void deleteVerification(String email) {

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(DELETE_VERIFICATION)) {

        ps.setString(1, email);

        int rows = ps.executeUpdate();

        if (rows > 0)
            System.out.println("Email Verification Deleted Successfully");
        else
            System.out.println("Failed To Delete Email Verification");

    } catch (Exception e) {
        e.printStackTrace();
    }
}

// =====================================
// EXTRACT VERIFICATION
// =====================================

private EmailVerification extractVerification(ResultSet rs) throws Exception {

    EmailVerification verification = new EmailVerification();

    verification.setVerificationId(rs.getInt("verification_id"));
    verification.setEmail(rs.getString("email"));
    verification.setVerified(rs.getBoolean("is_verified"));
    verification.setVerifiedAt(rs.getTimestamp("verified_at"));

    return verification;
}

}