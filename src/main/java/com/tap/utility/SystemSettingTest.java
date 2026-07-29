package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.SystemSettingDAOImpl;
import com.tap.model.SystemSetting;


public class SystemSettingTest {


    public static void main(String[] args) {


        SystemSettingDAOImpl dao = new SystemSettingDAOImpl();



        // ADD

        SystemSetting setting = new SystemSetting();


        setting.setSettingKey("DELIVERY_CHARGE");

        setting.setSettingValue("40");

        setting.setDescription("Default delivery charge");


        dao.addSetting(setting);




        // GET

        System.out.println(
                dao.getSetting("DELIVERY_CHARGE")
        );




        // GET ALL


        List<SystemSetting> list =
                dao.getAllSettings();



        for(SystemSetting s : list){

            System.out.println(s);

        }





        // UPDATE


        SystemSetting update =
                dao.getSetting("DELIVERY_CHARGE");



        if(update != null){


            update.setSettingValue("50");


            dao.updateSetting(update);

        }





        // DELETE

        // dao.deleteSetting("DELIVERY_CHARGE");

    }

}