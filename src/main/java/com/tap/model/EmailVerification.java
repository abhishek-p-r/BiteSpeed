package com.tap.model;

import java.sql.Timestamp;

public class EmailVerification {

    private int verificationId;
    private String email;
    private boolean verified;
    private Timestamp verifiedAt;

    // Default Constructor
    public EmailVerification() {

    }

    // Constructor
    public EmailVerification(String email, boolean verified, Timestamp verifiedAt) {
        this.email = email;
        this.verified = verified;
        this.verifiedAt = verifiedAt;
    }

    // Full Constructor
    public EmailVerification(int verificationId, String email, boolean verified, Timestamp verifiedAt) {
        this.verificationId = verificationId;
        this.email = email;
        this.verified = verified;
        this.verifiedAt = verifiedAt;
    }

    public int getVerificationId() {
        return verificationId;
    }

    public void setVerificationId(int verificationId) {
        this.verificationId = verificationId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isVerified() {
        return verified;
    }

    public void setVerified(boolean verified) {
        this.verified = verified;
    }

    public Timestamp getVerifiedAt() {
        return verifiedAt;
    }

    public void setVerifiedAt(Timestamp verifiedAt) {
        this.verifiedAt = verifiedAt;
    }

    @Override
    public String toString() {
        return "EmailVerification [verificationId=" + verificationId
                + ", email=" + email
                + ", verified=" + verified
                + ", verifiedAt=" + verifiedAt + "]";
    }
}