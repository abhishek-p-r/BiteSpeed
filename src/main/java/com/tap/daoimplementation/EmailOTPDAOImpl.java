package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import com.tap.dao.EmailOTPDAO;
import com.tap.model.EmailOTP;
import com.tap.utility.DBConnection;

public class EmailOTPDAOImpl implements EmailOTPDAO {

    // ============================
    // SQL QUERIES
    // ============================

    private static final String INSERT_OTP =
            "INSERT INTO email_otp(email,otp,expiry_time) VALUES(?,?,?)";

    private static final String GET_OTP =
            "SELECT * FROM email_otp WHERE email=?";

    private static final String UPDATE_OTP =
            "UPDATE email_otp SET otp=?,expiry_time=? WHERE email=?";

    private static final String DELETE_OTP =
            "DELETE FROM email_otp WHERE email=?";

    // ============================
    // SAVE OTP
    // ============================

    @Override
    public void saveOTP(EmailOTP otp) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_OTP)) {

            ps.setString(1, otp.getEmail());
            ps.setString(2, otp.getOtp());
            ps.setTimestamp(3, otp.getExpiryTime());

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("OTP Saved Successfully");
            else
                System.out.println("Failed To Save OTP");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ============================
    // GET OTP
    // ============================

    @Override
    public EmailOTP getOTP(String email) {

        EmailOTP otp = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_OTP)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                otp = extractOTP(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return otp;
    }


// ============================
// UPDATE OTP
// ============================

@Override
public void updateOTP(EmailOTP otp) {

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(UPDATE_OTP)) {

        ps.setString(1, otp.getOtp());
        ps.setTimestamp(2, otp.getExpiryTime());
        ps.setString(3, otp.getEmail());

        int rows = ps.executeUpdate();

        if (rows > 0)
            System.out.println("OTP Updated Successfully");
        else
            System.out.println("Failed To Update OTP");

    } catch (Exception e) {
        e.printStackTrace();
    }
}

// ============================
// DELETE OTP
// ============================

@Override
public void deleteOTP(String email) {

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(DELETE_OTP)) {

        ps.setString(1, email);

        int rows = ps.executeUpdate();

        if (rows > 0)
            System.out.println("OTP Deleted Successfully");
        else
            System.out.println("Failed To Delete OTP");

    } catch (Exception e) {
        e.printStackTrace();
    }
}

// ============================
// EXTRACT OTP
// ============================

private EmailOTP extractOTP(ResultSet rs) throws Exception {

    EmailOTP otp = new EmailOTP();

    otp.setOtpId(rs.getInt("otp_id"));
    otp.setEmail(rs.getString("email"));
    otp.setOtp(rs.getString("otp"));
    otp.setExpiryTime(rs.getTimestamp("expiry_time"));

    return otp;
}

}