package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OTPDAO;
import com.tap.model.OTP;
import com.tap.utility.DBConnection;


public class OTPDAOImpl implements OTPDAO {


    // ==========================================
    // SQL QUERIES
    // ==========================================


    private static final String INSERT_OTP =
            "INSERT INTO otp(user_id,otp_code,expiry_time,is_verified,created_at) VALUES(?,?,?,?,?)";


    private static final String GET_OTP =
            "SELECT * FROM otp WHERE otp_id=?";


    private static final String GET_OTP_BY_USER =
            "SELECT * FROM otp WHERE user_id=? ORDER BY otp_id DESC LIMIT 1";


    private static final String GET_ALL_OTPS =
            "SELECT * FROM otp ORDER BY otp_id";


    private static final String UPDATE_OTP =
            "UPDATE otp SET otp_code=?,expiry_time=?,is_verified=? WHERE otp_id=?";


    private static final String DELETE_OTP =
            "DELETE FROM otp WHERE otp_id=?";


    private static final String OTP_EXISTS =
            "SELECT COUNT(*) FROM otp WHERE otp_id=?";





    // ==========================================
    // ADD OTP
    // ==========================================

    @Override
    public void addOTP(OTP otp) {


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(INSERT_OTP)) {



            ps.setInt(1, otp.getUserId());

            ps.setString(2, otp.getOtpCode());

            ps.setTimestamp(3, otp.getExpiryTime());

            ps.setBoolean(4, otp.isVerified());


            ps.setTimestamp(
                    5,
                    new Timestamp(System.currentTimeMillis())
            );



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println(
                        "OTP Added Successfully"
                );

            else

                System.out.println(
                        "Failed To Add OTP"
                );



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // GET OTP
    // ==========================================

    @Override
    public OTP getOTP(int otpId) {


        OTP otp = null;


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(GET_OTP)) {



            ps.setInt(1, otpId);



            ResultSet rs =
                    ps.executeQuery();



            if(rs.next()){

                otp = extractOTP(rs);

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return otp;

    }





    // ==========================================
    // GET OTP BY USER
    // ==========================================

    @Override
    public OTP getOTPByUser(int userId) {


        OTP otp = null;



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(GET_OTP_BY_USER)) {



            ps.setInt(1, userId);



            ResultSet rs =
                    ps.executeQuery();



            if(rs.next()){

                otp = extractOTP(rs);

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return otp;

    }





    // ==========================================
    // GET ALL OTP
    // ==========================================

    @Override
    public List<OTP> getAllOTPs() {


        List<OTP> list =
                new ArrayList<>();



        try(Connection con = DBConnection.getConnection();

            Statement stmt =
                    con.createStatement();

            ResultSet rs =
                    stmt.executeQuery(GET_ALL_OTPS)) {



            while(rs.next()){


                list.add(
                        extractOTP(rs)
                );


            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return list;

    }





    // ==========================================
    // OTP EXISTS
    // ==========================================

    @Override
    public boolean otpExists(int otpId) {


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(OTP_EXISTS)) {



            ps.setInt(1, otpId);



            ResultSet rs =
                    ps.executeQuery();



            if(rs.next()){

                return rs.getInt(1) > 0;

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return false;

    }





    // ==========================================
    // UPDATE OTP
    // ==========================================

    @Override
    public void updateOTP(OTP otp) {


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(UPDATE_OTP)) {



            ps.setString(
                    1,
                    otp.getOtpCode()
            );


            ps.setTimestamp(
                    2,
                    otp.getExpiryTime()
            );


            ps.setBoolean(
                    3,
                    otp.isVerified()
            );


            ps.setInt(
                    4,
                    otp.getOtpId()
            );



            int rows =
                    ps.executeUpdate();



            if(rows > 0)

                System.out.println(
                        "OTP Updated Successfully"
                );

            else

                System.out.println(
                        "Failed To Update OTP"
                );



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // DELETE OTP
    // ==========================================

    @Override
    public void deleteOTP(int otpId) {


        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(DELETE_OTP)) {



            ps.setInt(1, otpId);



            int rows =
                    ps.executeUpdate();



            if(rows > 0)

                System.out.println(
                        "OTP Deleted Successfully"
                );

            else

                System.out.println(
                        "Failed To Delete OTP"
                );



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // EXTRACT OTP
    // ==========================================

    private OTP extractOTP(ResultSet rs)
            throws Exception {



        OTP otp =
                new OTP();



        otp.setOtpId(
                rs.getInt("otp_id")
        );


        otp.setUserId(
                rs.getInt("user_id")
        );


        otp.setOtpCode(
                rs.getString("otp_code")
        );


        otp.setExpiryTime(
                rs.getTimestamp("expiry_time")
        );


        otp.setVerified(
                rs.getBoolean("is_verified")
        );


        otp.setCreatedAt(
                rs.getTimestamp("created_at")
        );



        return otp;

    }


}