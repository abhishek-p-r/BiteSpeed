package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.AddressDAO;
import com.tap.model.Address;
import com.tap.utility.DBConnection;

public class AddressDAOImpl implements AddressDAO {

    // ================= SQL QUERIES =================

    private static final String INSERT_ADDRESS =
            "INSERT INTO address (user_id, address_line1, address_line2, city, state, pincode, landmark, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_ADDRESS =
            "SELECT * FROM address WHERE address_id=?";

    private static final String GET_ALL_ADDRESSES =
            "SELECT * FROM address ORDER BY address_id";

    private static final String GET_ADDRESSES_BY_USER =
            "SELECT * FROM address WHERE user_id=?";

    private static final String UPDATE_ADDRESS =
            "UPDATE address SET user_id=?, address_line1=?, address_line2=?, city=?, state=?, pincode=?, landmark=?, is_default=? WHERE address_id=?";

    private static final String DELETE_ADDRESS =
            "DELETE FROM address WHERE address_id=?";

    private static final String ADDRESS_EXISTS =
            "SELECT COUNT(*) FROM address WHERE address_id=?";

    // ================= ADD ADDRESS =================

    @Override
    public void addAddress(Address address) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_ADDRESS)) {

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getAddressLine1());
            ps.setString(3, address.getAddressLine2());
            ps.setString(4, address.getCity());
            ps.setString(5, address.getState());
            ps.setString(6, address.getPincode());
            ps.setString(7, address.getLandmark());
            ps.setBoolean(8, address.isDefault());

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Address Added Successfully");
            else
                System.out.println("Failed To Add Address");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= GET ADDRESS =================

    @Override
    public Address getAddress(int addressId) {

        Address address = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_ADDRESS)) {

            ps.setInt(1, addressId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                address = extractAddress(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return address;
    }

    // ================= GET ALL ADDRESSES =================

    @Override
    public List<Address> getAllAddresses() {

        List<Address> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_ADDRESSES)) {

            while (rs.next()) {
                list.add(extractAddress(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= GET ADDRESSES BY USER =================

    @Override
    public List<Address> getAddressesByUser(int userId) {

        List<Address> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_ADDRESSES_BY_USER)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractAddress(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= UPDATE ADDRESS =================

    @Override
    public void updateAddress(Address address) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_ADDRESS)) {

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getAddressLine1());
            ps.setString(3, address.getAddressLine2());
            ps.setString(4, address.getCity());
            ps.setString(5, address.getState());
            ps.setString(6, address.getPincode());
            ps.setString(7, address.getLandmark());
            ps.setBoolean(8, address.isDefault());
            ps.setInt(9, address.getAddressId());

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Address Updated Successfully");
            else
                System.out.println("Failed To Update Address");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= DELETE ADDRESS =================

    @Override
    public void deleteAddress(int addressId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_ADDRESS)) {

            ps.setInt(1, addressId);

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Address Deleted Successfully");
            else
                System.out.println("Failed To Delete Address");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= ADDRESS EXISTS =================

    @Override
    public boolean addressExists(int addressId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(ADDRESS_EXISTS)) {

            ps.setInt(1, addressId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= EXTRACT ADDRESS =================

    private Address extractAddress(ResultSet rs) throws Exception {

        Address address = new Address();

        address.setAddressId(rs.getInt("address_id"));
        address.setUserId(rs.getInt("user_id"));
        address.setAddressLine1(rs.getString("address_line1"));
        address.setAddressLine2(rs.getString("address_line2"));
        address.setCity(rs.getString("city"));
        address.setState(rs.getString("state"));
        address.setPincode(rs.getString("pincode"));
        address.setLandmark(rs.getString("landmark"));
        address.setDefault(rs.getBoolean("is_default"));

        return address;
    }
}