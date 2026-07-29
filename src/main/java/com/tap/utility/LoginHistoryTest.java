package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.LoginHistoryDAOImpl;
import com.tap.model.LoginHistory;



public class LoginHistoryTest {


    public static void main(String[] args) {


        LoginHistoryDAOImpl dao = new LoginHistoryDAOImpl();



        // ADD LOGIN HISTORY

        LoginHistory history = new LoginHistory();


        history.setUserId(1);

        history.setIpAddress("192.168.1.100");

        history.setDeviceInfo("Chrome Windows");

        history.setLoginStatus("SUCCESS");


        dao.addLoginHistory(history);





        // GET LOGIN BY ID

        LoginHistory login = dao.getLogin(1);


        System.out.println(login);





        // GET ALL LOGIN HISTORY

        List<LoginHistory> histories = dao.getAllLogins();


        for(LoginHistory h : histories) {

            System.out.println(h);

        }





        // GET LOGIN BY USER

        List<LoginHistory> userLogins =
                dao.getLoginsByUser(1);



        for(LoginHistory h : userLogins) {

            System.out.println(h);

        }





        // UPDATE LOGOUT TIME

        dao.updateLogoutTime(1);



    }

}