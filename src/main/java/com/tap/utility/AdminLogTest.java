package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.AdminLogDAOImpl;
import com.tap.model.AdminLog;

public class AdminLogTest {

    public static void main(String[] args) {

        AdminLogDAOImpl dao = new AdminLogDAOImpl();

        // ADD
        AdminLog log = new AdminLog();

        log.setAdminId(1);
        log.setAction("LOGIN");
        log.setDescription("Admin logged into the system.");

        dao.addLog(log);

        // GET
        System.out.println(dao.getLog(1));

        // GET BY ADMIN
        List<AdminLog> adminLogs = dao.getLogsByAdmin(1);

        for (AdminLog l : adminLogs) {
            System.out.println(l);
        }

        // GET ALL
        List<AdminLog> logs = dao.getAllLogs();

        for (AdminLog l : logs) {
            System.out.println(l);
        }

        // DELETE
        // dao.deleteLog(1);
    }
}