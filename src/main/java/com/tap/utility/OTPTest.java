package com.tap.utility;

import java.sql.Timestamp;
import java.util.List;

import com.tap.daoimplementation.OTPDAOImpl;
import com.tap.model.OTP;


public class OTPTest {


    public static void main(String[] args) {


        OTPDAOImpl dao =
                new OTPDAOImpl();



        // ==========================
        // ADD OTP
        // ==========================


        OTP otp =
                new OTP();


        otp.setUserId(1);

        otp.setOtpCode("123456");


        otp.setExpiryTime(
                new Timestamp(
                        System.currentTimeMillis()+300000
                )
        );


        otp.setVerified(false);



        // dao.addOTP(otp);





        // ==========================
        // GET OTP
        // ==========================


        System.out.println(
                dao.getOTP(1)
        );





        // ==========================
        // GET ALL OTP
        // ==========================


        List<OTP> list =
                dao.getAllOTPs();



        for(OTP o : list){

            System.out.println(o);

        }





        // ==========================
        // UPDATE OTP
        // ==========================


        OTP update =
                dao.getOTP(1);



        if(update != null){


            update.setVerified(true);


            // dao.updateOTP(update);


            System.out.println(
                    "OTP Ready For Update"
            );

        }





        // ==========================
        // DELETE
        // ==========================


        // dao.deleteOTP(1);



        System.out.println(
                "OTP Test Completed Successfully"
        );


    }

}