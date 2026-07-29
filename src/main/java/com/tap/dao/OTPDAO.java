package com.tap.dao;

import java.util.List;
import com.tap.model.OTP;

public interface OTPDAO {

    void addOTP(OTP otp);

    OTP getOTP(int otpId);

    OTP getOTPByUser(int userId);

    List<OTP> getAllOTPs();

    void updateOTP(OTP otp);

    void deleteOTP(int otpId);

    boolean otpExists(int otpId);

}