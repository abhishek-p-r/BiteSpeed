package com.tap.dao;

import java.util.List;

import com.tap.model.Address;

public interface AddressDAO {

    // Add Address
    void addAddress(Address address);

    // Get Address by ID
    Address getAddress(int addressId);

    // Get All Addresses
    List<Address> getAllAddresses();

    // Get Addresses by User ID
    List<Address> getAddressesByUser(int userId);

    // Update Address
    void updateAddress(Address address);

    // Delete Address
    void deleteAddress(int addressId);

    // Check Address Exists
    boolean addressExists(int addressId);
}