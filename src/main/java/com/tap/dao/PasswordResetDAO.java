package com.tap.dao;

import com.tap.model.PasswordReset;

public interface PasswordResetDAO {

    void saveResetToken(PasswordReset reset);

    PasswordReset getResetToken(String email);

    void updateResetToken(PasswordReset reset);

    void deleteResetToken(String email);
}