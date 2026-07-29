package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp;

import com.tap.dao.SystemSettingDAO;
import com.tap.model.SystemSetting;
import com.tap.utility.DBConnection;

public class SystemSettingDAOImpl implements SystemSettingDAO {


    // ==========================================
    // SQL QUERIES
    // ==========================================

    private static final String INSERT_SETTING =
            "INSERT INTO system_settings(setting_key,setting_value,description,created_at,updated_at) VALUES(?,?,?,?,?)";


    private static final String GET_SETTING =
            "SELECT * FROM system_settings WHERE setting_key=?";


    private static final String GET_ALL_SETTINGS =
            "SELECT * FROM system_settings ORDER BY setting_key";


    private static final String UPDATE_SETTING =
            "UPDATE system_settings SET setting_value=?,description=?,updated_at=? WHERE setting_key=?";


    private static final String DELETE_SETTING =
            "DELETE FROM system_settings WHERE setting_key=?";



    // ==========================================
    // ADD SETTING
    // ==========================================

    @Override
    public void addSetting(SystemSetting setting) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_SETTING)){


            Timestamp now = new Timestamp(System.currentTimeMillis());


            ps.setString(1, setting.getSettingKey());
            ps.setString(2, setting.getSettingValue());
            ps.setString(3, setting.getDescription());
            ps.setTimestamp(4, now);
            ps.setTimestamp(5, now);


            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Setting Added Successfully");
            else
                System.out.println("Failed To Add Setting");


        }catch(Exception e){

            e.printStackTrace();

        }

    }



    // ==========================================
    // GET SETTING
    // ==========================================

    @Override
    public SystemSetting getSetting(String settingKey) {


        SystemSetting setting = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_SETTING)){


            ps.setString(1, settingKey);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                setting = extractSetting(rs);

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return setting;

    }




    // ==========================================
    // GET ALL SETTINGS
    // ==========================================

    @Override
    public List<SystemSetting> getAllSettings() {


        List<SystemSetting> settings = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(GET_ALL_SETTINGS)){



            while(rs.next()){

                settings.add(extractSetting(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return settings;

    }





    // ==========================================
    // UPDATE SETTING
    // ==========================================

    @Override
    public void updateSetting(SystemSetting setting) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_SETTING)){



            ps.setString(1, setting.getSettingValue());
            ps.setString(2, setting.getDescription());
            ps.setTimestamp(3,new Timestamp(System.currentTimeMillis()));
            ps.setString(4,setting.getSettingKey());



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Setting Updated Successfully");

            else

                System.out.println("Setting Update Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // DELETE SETTING
    // ==========================================

    @Override
    public void deleteSetting(String settingKey) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_SETTING)){



            ps.setString(1, settingKey);



            int rows = ps.executeUpdate();



            if(rows > 0)

                System.out.println("Setting Deleted Successfully");

            else

                System.out.println("Setting Delete Failed");



        }catch(Exception e){

            e.printStackTrace();

        }

    }





    // ==========================================
    // EXTRACT SETTING
    // ==========================================

    private SystemSetting extractSetting(ResultSet rs) throws Exception {


        SystemSetting setting = new SystemSetting();


        setting.setSettingKey(
                rs.getString("setting_key")
        );


        setting.setSettingValue(
                rs.getString("setting_value")
        );


        setting.setDescription(
                rs.getString("description")
        );


        setting.setCreatedAt(
                rs.getTimestamp("created_at")
        );


        setting.setUpdatedAt(
                rs.getTimestamp("updated_at")
        );


        return setting;

    }

}