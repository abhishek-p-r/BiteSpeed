package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.UserAddressDAOImpl;
import com.tap.model.UserAddress;



public class UserAddressTest {


    public static void main(String[] args) {


        UserAddressDAOImpl dao =
                new UserAddressDAOImpl();



        // ADD

        UserAddress address =
                new UserAddress();


        address.setUserId(1);

        address.setAddressLine("MG Road");

        address.setCity("Bangalore");

        address.setState("Karnataka");

        address.setPincode("560001");

        address.setAddressType("HOME");

        address.setDefault(true);



        dao.addAddress(address);




        // GET

        System.out.println(
                dao.getAddress(1)
        );





        // GET USER ADDRESSES


        List<UserAddress> list =
                dao.getAddressesByUser(1);



        for(UserAddress a : list){

            System.out.println(a);

        }





        // UPDATE


        UserAddress update =
                dao.getAddress(1);



        if(update != null){


            update.setCity("Mysore");


            dao.updateAddress(update);

        }




        // SET DEFAULT

        // dao.setDefaultAddress(1,1);




        // DELETE

        // dao.deleteAddress(1);

    }

}