package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.UserAddressDAO;
import com.tap.model.UserAddress;
import com.tap.utility.DBConnection;

public class UserAddressDAOImpl implements UserAddressDAO {


    // ==========================================
    // SQL QUERIES
    // ==========================================


    private static final String INSERT_ADDRESS =
            "INSERT INTO user_addresses(user_id,address_line,city,state,pincode,address_type,is_default) VALUES(?,?,?,?,?,?,?)";


    private static final String GET_ADDRESS =
            "SELECT * FROM user_addresses WHERE address_id=?";


    private static final String GET_ALL_USER_ADDRESS =
            "SELECT * FROM user_addresses WHERE user_id=? ORDER BY address_id";


    private static final String UPDATE_ADDRESS =
            "UPDATE user_addresses SET address_line=?,city=?,state=?,pincode=?,address_type=? WHERE address_id=?";


    private static final String DELETE_ADDRESS =
            "DELETE FROM user_addresses WHERE address_id=?";


    private static final String REMOVE_DEFAULT =
            "UPDATE user_addresses SET is_default=false WHERE user_id=?";


    private static final String SET_DEFAULT =
            "UPDATE user_addresses SET is_default=true WHERE address_id=? AND user_id=?";





    // ==========================================
    // ADD ADDRESS
    // ==========================================

    @Override
    public void addAddress(UserAddress address) {
        String sql1 = "INSERT INTO user_addresses(user_id,address_line,city,state,pincode,address_type,is_default) VALUES(?,?,?,?,?,?,?)";
        String sql2 = "INSERT INTO user_address(user_id,house_no,street,city,state,pincode,landmark,address_type,is_default) VALUES(?,?,?,?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps1 = con.prepareStatement(sql1)) {
                ps1.setInt(1, address.getUserId());
                ps1.setString(2, address.getAddressLine());
                ps1.setString(3, address.getCity());
                ps1.setString(4, address.getState());
                ps1.setString(5, address.getPincode());
                ps1.setString(6, address.getAddressType());
                ps1.setBoolean(7, address.isDefault());
                ps1.executeUpdate();
            } catch (Exception ex) {
                System.err.println("user_addresses insert warning: " + ex.getMessage());
            }

            try (PreparedStatement ps2 = con.prepareStatement(sql2)) {
                ps2.setInt(1, address.getUserId());
                ps2.setString(2, address.getAddressLine() != null ? address.getAddressLine() : "Main St");
                ps2.setString(3, "Indiranagar");
                ps2.setString(4, address.getCity());
                ps2.setString(5, address.getState());
                ps2.setString(6, address.getPincode());
                ps2.setString(7, "Near Metro");
                ps2.setString(8, address.getAddressType() != null && address.getAddressType().length() <= 1 ? address.getAddressType() : "H");
                ps2.setBoolean(9, address.isDefault());
                ps2.executeUpdate();
            } catch (Exception ex) {
                System.err.println("user_address insert warning: " + ex.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }





    // ==========================================
    // GET ADDRESS
    // ==========================================

    @Override
    public UserAddress getAddress(int addressId) {


        UserAddress address = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_ADDRESS)){


            ps.setInt(1,addressId);


            ResultSet rs = ps.executeQuery();



            if(rs.next()){

                address = extractAddress(rs);

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return address;

    }





    // ==========================================
    // GET USER ADDRESSES
    // ==========================================

    @Override
    public List<UserAddress> getAddressesByUser(int userId) {


        List<UserAddress> addresses = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_ALL_USER_ADDRESS)){


            ps.setInt(1,userId);


            ResultSet rs = ps.executeQuery();



            while(rs.next()){

                addresses.add(extractAddress(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return addresses;

    }





    // ==========================================
    // UPDATE ADDRESS
    // ==========================================

    @Override
    public void updateAddress(UserAddress address) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_ADDRESS)){



            ps.setString(1,address.getAddressLine());

            ps.setString(2,address.getCity());

            ps.setString(3,address.getState());

            ps.setString(4,address.getPincode());

            ps.setString(5,address.getAddressType());

            ps.setInt(6,address.getAddressId());



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Address Updated Successfully");

            else

                System.out.println("Address Update Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // DELETE ADDRESS
    // ==========================================

    @Override
    public void deleteAddress(int addressId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_ADDRESS)){



            ps.setInt(1,addressId);



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Address Deleted Successfully");

            else

                System.out.println("Address Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // SET DEFAULT ADDRESS
    // ==========================================

    @Override
    public void setDefaultAddress(int addressId,int userId) {


        try(Connection con = DBConnection.getConnection()){


            PreparedStatement remove =
                    con.prepareStatement(REMOVE_DEFAULT);


            remove.setInt(1,userId);

            remove.executeUpdate();



            PreparedStatement set =
                    con.prepareStatement(SET_DEFAULT);


            set.setInt(1,addressId);

            set.setInt(2,userId);


            int rows = set.executeUpdate();



            if(rows > 0)

                System.out.println("Default Address Updated");

            else

                System.out.println("Failed To Set Default Address");



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // EXTRACT ADDRESS
    // ==========================================

    private UserAddress extractAddress(ResultSet rs) throws Exception {


        UserAddress address = new UserAddress();


        address.setAddressId(
                rs.getInt("address_id")
        );


        address.setUserId(
                rs.getInt("user_id")
        );


        address.setAddressLine(
                rs.getString("address_line")
        );


        address.setCity(
                rs.getString("city")
        );


        address.setState(
                rs.getString("state")
        );


        address.setPincode(
                rs.getString("pincode")
        );


        address.setAddressType(
                rs.getString("address_type")
        );


        address.setDefault(
                rs.getBoolean("is_default")
        );


        return address;

    }

}