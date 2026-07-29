package com.tap.dao;

import java.util.List;
import com.tap.model.SystemSetting;

public interface SystemSettingDAO {

    void addSetting(SystemSetting setting);

    SystemSetting getSetting(String settingKey);

    List<SystemSetting> getAllSettings();

    void updateSetting(SystemSetting setting);

    void deleteSetting(String settingKey);
}