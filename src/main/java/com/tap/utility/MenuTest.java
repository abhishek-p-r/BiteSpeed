package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.MenuDAOImpl;
import com.tap.model.Menu;



public class MenuTest {


    public static void main(String[] args) {


        MenuDAOImpl dao = new MenuDAOImpl();



        // ADD

        Menu menu = new Menu();


        menu.setRestaurantId(1);


        menu.setRestaurantId(1);
        menu.setItemName("Mutton Biryani");
        menu.setDescription("Authentic Dum Mutton Biryani");
        menu.setPrice(350);
        menu.setAvailable(true);
        menu.setCategory("Biryani");

        dao.addMenu(menu);


//
//
//        // GET
//
//        Menu result = dao.getMenu(1);
//
//        System.out.println(result);
//
//
//
//
//
//
//        // GET ALL
//
//        List<Menu> menus = dao.getAllMenus();
//
//
//        for(Menu m : menus){
//
//            System.out.println(m);
//
//        }
//
//
//
//
//
//
//        // UPDATE
//
//        Menu update = dao.getMenu(1);
//
//
//        if(update != null){
//
//
//            update.setPrice(280);
//
//
//            dao.updateMenu(update);
//
//        }
//
//
//
//


        // DELETE

        // dao.deleteMenu(1);

    }

}