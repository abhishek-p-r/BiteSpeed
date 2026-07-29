package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.MenuItemDAOImpl;
import com.tap.model.MenuItem;



public class MenuItemTest {


    public static void main(String[] args) {


        MenuItemDAOImpl dao = new MenuItemDAOImpl();



        // =========================
        // ADD MENU ITEM
        // =========================


        MenuItem item = new MenuItem();


        item.setRestaurantId(1);

        item.setCategoryId(1);

        item.setItemName("Chicken Biryani");

        item.setDescription("Hyderabadi Style Chicken Biryani");

        item.setPrice(250);

        item.setImageUrl("biryani.jpg");

        item.setAvailable(true);



        dao.addMenuItem(item);





        // =========================
        // GET MENU ITEM BY ID
        // =========================


        MenuItem menuItem = dao.getMenuItem(1);


        System.out.println(menuItem);







        // =========================
        // GET ALL MENU ITEMS
        // =========================


        List<MenuItem> items = dao.getAllMenuItems();



        for(MenuItem m : items){

            System.out.println(m);

        }








        // =========================
        // GET ITEMS BY RESTAURANT
        // =========================


        List<MenuItem> restaurantItems =
                dao.getMenuItemsByRestaurant(1);



        for(MenuItem m : restaurantItems){

            System.out.println("Restaurant Item : " + m);

        }








        // =========================
        // GET ITEMS BY CATEGORY
        // =========================


        List<MenuItem> categoryItems =
                dao.getMenuItemsByCategory(1);



        for(MenuItem m : categoryItems){

            System.out.println("Category Item : " + m);

        }








        // =========================
        // SEARCH MENU ITEM
        // =========================


        List<MenuItem> search =
                dao.searchMenuItem("Chicken");



        for(MenuItem m : search){

            System.out.println("Search Result : " + m);

        }








        // =========================
        // AVAILABLE MENU ITEMS
        // =========================


        List<MenuItem> available =
                dao.getAvailableMenuItems();



        for(MenuItem m : available){

            System.out.println("Available : " + m);

        }








        // =========================
        // UPDATE MENU ITEM
        // =========================


        MenuItem update = dao.getMenuItem(1);



        if(update != null){


            update.setPrice(280);

            update.setDescription(
                    "Updated Chicken Biryani"
            );


            dao.updateMenuItem(update);

        }








        // =========================
        // DELETE MENU ITEM
        // =========================


        // dao.deleteMenuItem(1);








        // =========================
        // CHECK EXISTS
        // =========================


        boolean exists =
                dao.menuItemExists(1);



        System.out.println(
                "Menu Item Exists : " + exists
        );


    }

}