package com.tap.utility;

import java.sql.Timestamp;

import com.tap.daoimplementation.AuthTokenDAOImpl;
import com.tap.model.AuthToken;

public class AuthTokenTest {

    public static void main(String[] args) {

        AuthTokenDAOImpl dao = new AuthTokenDAOImpl();

        // SAVE TOKEN
        AuthToken token = new AuthToken();

        token.setUserId(1);
        token.setToken("ABC123XYZTOKEN");
        token.setExpiryTime(new Timestamp(System.currentTimeMillis() + 3600000));
        token.setActive(true);

        dao.saveToken(token);

        // GET TOKEN
        System.out.println(dao.getToken("ABC123XYZTOKEN"));

        // DELETE TOKEN
        // dao.deleteToken("ABC123XYZTOKEN");
    }
}