package com.tap.utility;


import java.sql.Timestamp;

import com.tap.daoimplementation.PasswordResetDAOImpl;
import com.tap.model.PasswordReset;



public class PasswordResetTest {


    public static void main(String[] args) {



        PasswordResetDAOImpl dao =
                new PasswordResetDAOImpl();





        // =========================
        // SAVE TOKEN
        // =========================


        PasswordReset reset =
                new PasswordReset();



        reset.setEmail("abhi@gmail.com");

        reset.setResetToken("RESET12345");

        reset.setExpiresAt(
                new Timestamp(
                        System.currentTimeMillis()
                        + 15 * 60 * 1000
                )
        );



        dao.saveResetToken(reset);








        // =========================
        // GET TOKEN
        // =========================


        PasswordReset result =
                dao.getResetToken("abhi@gmail.com");



        System.out.println(result);








        // =========================
        // UPDATE TOKEN
        // =========================


        if(result != null){


            result.setResetToken("NEWRESET6789");


            dao.updateResetToken(result);


        }








        // =========================
        // DELETE TOKEN
        // =========================


        // dao.deleteResetToken("abhi@gmail.com");



    }

}