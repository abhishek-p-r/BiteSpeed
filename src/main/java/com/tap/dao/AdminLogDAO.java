package com.tap.dao;

import java.util.List;
import com.tap.model.AdminLog;

public interface AdminLogDAO {

    void addLog(AdminLog log);

    AdminLog getLog(int logId);

    List<AdminLog> getLogsByAdmin(int adminId);

    List<AdminLog> getAllLogs();

    void deleteLog(int logId);
}