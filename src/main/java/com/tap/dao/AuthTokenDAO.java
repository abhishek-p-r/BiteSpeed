package com.tap.dao;

import com.tap.model.AuthToken;

public interface AuthTokenDAO {

    void saveToken(AuthToken token);

    AuthToken getToken(String token);

    void deleteToken(String token);
}