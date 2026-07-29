package com.tap.dao;

import com.tap.model.EmailVerification;

public interface EmailVerificationDAO {

    void verifyEmail(EmailVerification verification);

    EmailVerification getVerification(String email);

    void updateVerification(EmailVerification verification);

    void deleteVerification(String email);
}