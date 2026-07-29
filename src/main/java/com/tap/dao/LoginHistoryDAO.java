package com.tap.dao;

import java.util.List;
import com.tap.model.LoginHistory;

public interface LoginHistoryDAO {

    void addLoginHistory(LoginHistory history);

    LoginHistory getLogin(int loginId);

    List<LoginHistory> getLoginsByUser(int userId);

    List<LoginHistory> getAllLogins();

    void updateLogoutTime(int loginId);
}