package com.tap.model;


public class UserAddress {


    private int addressId;

    private int userId;

    private String addressLine;

    private String city;

    private String state;

    private String pincode;

    private String addressType;

    private boolean isDefault;



    public UserAddress(){}



    public int getAddressId() {
        return addressId;
    }


    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }



    public int getUserId() {
        return userId;
    }


    public void setUserId(int userId) {
        this.userId = userId;
    }



    public String getAddressLine() {
        return addressLine;
    }


    public void setAddressLine(String addressLine) {
        this.addressLine = addressLine;
    }



    public String getCity() {
        return city;
    }


    public void setCity(String city) {
        this.city = city;
    }



    public String getState() {
        return state;
    }


    public void setState(String state) {
        this.state = state;
    }



    public String getPincode() {
        return pincode;
    }


    public void setPincode(String pincode) {
        this.pincode = pincode;
    }



    public String getAddressType() {
        return addressType;
    }


    public void setAddressType(String addressType) {
        this.addressType = addressType;
    }



    public boolean isDefault() {
        return isDefault;
    }


    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }



    @Override
    public String toString() {

        return "UserAddress [addressId="
                + addressId
                + ", userId="
                + userId
                + ", addressLine="
                + addressLine
                + ", city="
                + city
                + ", state="
                + state
                + ", pincode="
                + pincode
                + ", addressType="
                + addressType
                + ", default="
                + isDefault
                + "]";

    }

}