package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.AddressDAOImpl;
import com.tap.model.Address;

public class AddressTest {

    public static void main(String[] args) {

        AddressDAOImpl dao = new AddressDAOImpl();

        Address address = new Address();

        address.setUserId(1);
        address.setAddressLine1("MG Road");
        address.setAddressLine2("Near Metro");
        address.setCity("Bangalore");
        address.setState("Karnataka");
        address.setPincode("560001");
        address.setLandmark("Brigade Road");
        address.setDefault(true);

        dao.addAddress(address);

        System.out.println(dao.getAddress(1));

        List<Address> addresses = dao.getAllAddresses();

        for(Address a : addresses) {
            System.out.println(a);
        }

        Address update = dao.getAddress(1);

        if(update != null) {

            update.setCity("Mysore");

            dao.updateAddress(update);
        }

        // dao.deleteAddress(1);

    }
}