package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.tap.dao.AuthTokenDAO;
import com.tap.model.AuthToken;
import com.tap.utility.DBConnection;

public class AuthTokenDAOImpl implements AuthTokenDAO {

    // ================= SQL QUERIES =================

    private static final String INSERT_TOKEN =
            "INSERT INTO auth_token(user_id, token, expiry_time, active) VALUES (?, ?, ?, ?)";

    private static final String GET_TOKEN =
            "SELECT * FROM auth_token WHERE token=?";

    private static final String DELETE_TOKEN =
            "DELETE FROM auth_token WHERE token=?";

    // ================= SAVE TOKEN =================

    @Override
    public void saveToken(AuthToken token) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_TOKEN)) {

            ps.setInt(1, token.getUserId());
            ps.setString(2, token.getToken());
            ps.setTimestamp(3, token.getExpiryTime());
            ps.setBoolean(4, token.isActive());

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Token Saved Successfully");
            else
                System.out.println("Failed To Save Token");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= GET TOKEN =================

    @Override
    public AuthToken getToken(String token) {

        AuthToken authToken = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_TOKEN)) {

            ps.setString(1, token);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                authToken = extractToken(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return authToken;
    }

    // ================= DELETE TOKEN =================

    @Override
    public void deleteToken(String token) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_TOKEN)) {

            ps.setString(1, token);

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Token Deleted Successfully");
            else
                System.out.println("Failed To Delete Token");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= EXTRACT TOKEN =================

    private AuthToken extractToken(ResultSet rs) throws Exception {

        AuthToken token = new AuthToken();

        token.setTokenId(rs.getInt("token_id"));
        token.setUserId(rs.getInt("user_id"));
        token.setToken(rs.getString("token"));
        token.setExpiryTime(rs.getTimestamp("expiry_time"));
        token.setActive(rs.getBoolean("active"));

        return token;
    }
}