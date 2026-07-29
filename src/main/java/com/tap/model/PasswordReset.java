package com.tap.model;

import java.sql.Timestamp;


public class PasswordReset {


    private int resetId;

    private String email;

    private String resetToken;

    private Timestamp createdAt;

    private Timestamp expiresAt;





    // Default Constructor

    public PasswordReset() {

    }





    // Constructor for saving token

    public PasswordReset(String email,
                         String resetToken,
                         Timestamp expiresAt) {

        this.email = email;

        this.resetToken = resetToken;

        this.expiresAt = expiresAt;

    }





    // Full Constructor

    public PasswordReset(int resetId,
                         String email,
                         String resetToken,
                         Timestamp createdAt,
                         Timestamp expiresAt) {


        this.resetId = resetId;

        this.email = email;

        this.resetToken = resetToken;

        this.createdAt = createdAt;

        this.expiresAt = expiresAt;

    }







    public int getResetId() {

        return resetId;

    }


    public void setResetId(int resetId) {

        this.resetId = resetId;

    }







    public String getEmail() {

        return email;

    }


    public void setEmail(String email) {

        this.email = email;

    }







    public String getResetToken() {

        return resetToken;

    }


    public void setResetToken(String resetToken) {

        this.resetToken = resetToken;

    }







    public Timestamp getCreatedAt() {

        return createdAt;

    }


    public void setCreatedAt(Timestamp createdAt) {

        this.createdAt = createdAt;

    }







    public Timestamp getExpiresAt() {

        return expiresAt;

    }


    public void setExpiresAt(Timestamp expiresAt) {

        this.expiresAt = expiresAt;

    }







    @Override
    public String toString() {


        return "PasswordReset [resetId=" + resetId
                + ", email=" + email
                + ", resetToken=" + resetToken
                + ", createdAt=" + createdAt
                + ", expiresAt=" + expiresAt
                + "]";

    }

}