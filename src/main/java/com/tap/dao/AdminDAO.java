package com.tap.dao;

import java.util.List;

import com.tap.model.Admin;

public interface AdminDAO {

    void addAdmin(Admin admin);

    Admin getAdmin(int adminId);

    Admin getAdminByEmail(String email);

    Admin getAdminByIdOrEmail(String identifier);

    List<Admin> getAllAdmins();

    void updateAdmin(Admin admin);

    void deleteAdmin(int adminId);
}