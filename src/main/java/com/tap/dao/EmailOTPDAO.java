package com.tap.dao;

import com.tap.model.EmailOTP;

public interface EmailOTPDAO {

    void saveOTP(EmailOTP otp);

    EmailOTP getOTP(String email);

    void updateOTP(EmailOTP otp);

    void deleteOTP(String email);
}