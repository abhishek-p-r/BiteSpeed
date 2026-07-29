package com.tap.daoimplementation;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.tap.dao.PasswordResetDAO;
import com.tap.model.PasswordReset;
import com.tap.utility.DBConnection;



public class PasswordResetDAOImpl implements PasswordResetDAO {



    private static final String INSERT_RESET_TOKEN =
            "INSERT INTO password_reset(email,reset_token,created_at,expires_at) VALUES(?,?,?,?)";



    private static final String GET_RESET_TOKEN =
            "SELECT * FROM password_reset WHERE email=?";



    private static final String UPDATE_RESET_TOKEN =
            "UPDATE password_reset SET reset_token=?,created_at=?,expires_at=? WHERE email=?";



    private static final String DELETE_RESET_TOKEN =
            "DELETE FROM password_reset WHERE email=?";







    // =====================================
    // SAVE RESET TOKEN
    // =====================================

    @Override
    public void saveResetToken(PasswordReset reset) {



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(INSERT_RESET_TOKEN)){



            ps.setString(1, reset.getEmail());

            ps.setString(2, reset.getResetToken());

            ps.setTimestamp(3,
                    new java.sql.Timestamp(
                            System.currentTimeMillis()
                    )
            );

            ps.setTimestamp(4, reset.getExpiresAt());



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Reset Token Saved Successfully");

            else

                System.out.println("Failed To Save Reset Token");



        }catch(Exception e){

            e.printStackTrace();

        }

    }









    // =====================================
    // GET RESET TOKEN
    // =====================================

    @Override
    public PasswordReset getResetToken(String email) {



        PasswordReset reset = null;



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(GET_RESET_TOKEN)){



            ps.setString(1,email);



            ResultSet rs = ps.executeQuery();



            if(rs.next()){

                reset = extractReset(rs);

            }



        }catch(Exception e){

            e.printStackTrace();

        }



        return reset;

    }









    // =====================================
    // UPDATE RESET TOKEN
    // =====================================

    @Override
    public void updateResetToken(PasswordReset reset) {



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(UPDATE_RESET_TOKEN)){



            ps.setString(1, reset.getResetToken());

            ps.setTimestamp(2,
                    new java.sql.Timestamp(
                            System.currentTimeMillis()
                    )
            );

            ps.setTimestamp(3, reset.getExpiresAt());

            ps.setString(4, reset.getEmail());



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Reset Token Updated Successfully");

            else

                System.out.println("Reset Token Update Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }









    // =====================================
    // DELETE RESET TOKEN
    // =====================================

    @Override
    public void deleteResetToken(String email) {



        try(Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(DELETE_RESET_TOKEN)){



            ps.setString(1,email);



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Reset Token Deleted Successfully");

            else

                System.out.println("Reset Token Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }









    // =====================================
    // EXTRACT OBJECT
    // =====================================

    private PasswordReset extractReset(ResultSet rs)
            throws Exception {



        PasswordReset reset =
                new PasswordReset();



        reset.setResetId(
                rs.getInt("reset_id")
        );



        reset.setEmail(
                rs.getString("email")
        );



        reset.setResetToken(
                rs.getString("reset_token")
        );



        reset.setCreatedAt(
                rs.getTimestamp("created_at")
        );



        reset.setExpiresAt(
                rs.getTimestamp("expires_at")
        );



        return reset;

    }


}