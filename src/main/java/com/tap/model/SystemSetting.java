package com.tap.model;

import java.sql.Timestamp;

public class SystemSetting {


    private String settingKey;

    private String settingValue;

    private String description;

    private Timestamp createdAt;

    private Timestamp updatedAt;



    public SystemSetting(){}



    public String getSettingKey() {
        return settingKey;
    }


    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }



    public String getSettingValue() {
        return settingValue;
    }


    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }



    public String getDescription() {
        return description;
    }


    public void setDescription(String description) {
        this.description = description;
    }



    public Timestamp getCreatedAt() {
        return createdAt;
    }


    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }



    public Timestamp getUpdatedAt() {
        return updatedAt;
    }


    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }



    @Override
    public String toString() {

        return "SystemSetting [settingKey="
                + settingKey
                + ", settingValue="
                + settingValue
                + ", description="
                + description
                + "]";

    }

}