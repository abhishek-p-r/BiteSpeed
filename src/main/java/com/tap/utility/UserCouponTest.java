package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.UserCouponDAOImpl;
import com.tap.model.UserCoupon;



public class UserCouponTest {


    public static void main(String[] args) {


        UserCouponDAOImpl dao =
                new UserCouponDAOImpl();




        // ASSIGN COUPON


        UserCoupon coupon =
                new UserCoupon();


        coupon.setUserId(1);

        coupon.setCouponId(1);

        coupon.setUsed(false);



        dao.assignCoupon(coupon);





        // GET


        System.out.println(
                dao.getUserCoupon(1)
        );





        // GET USER COUPONS


        List<UserCoupon> list =
                dao.getCouponsByUser(1);



        for(UserCoupon c : list){

            System.out.println(c);

        }





        // UPDATE


        UserCoupon update =
                dao.getUserCoupon(1);



        if(update != null){


            update.setUsed(true);


            dao.updateUserCoupon(update);

        }





        // DELETE

        // dao.deleteUserCoupon(1);


    }

}