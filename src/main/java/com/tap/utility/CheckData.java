package com.tap.utility;

import java.util.List;
import com.tap.daoimplementation.RestaurantDAOImpl;
import com.tap.daoimplementation.MenuDAOImpl;
import com.tap.model.Restaurant;
import com.tap.model.Menu;

public class CheckData {
    public static void main(String[] args) {
        try {
            RestaurantDAOImpl dao = new RestaurantDAOImpl();
            List<Restaurant> list = dao.getAllRestaurants();
            if (list == null) {
                System.out.println("Result list is null!");
            } else {
                System.out.println("Found " + list.size() + " restaurants in database.");
                for (Restaurant r : list) {
                    System.out.println("ID: " + r.getRestaurantId() + ", Name: " + r.getRestaurantName() + ", Image: " + r.getImage() + ", Active: " + r.isActive());
                }
            }

            MenuDAOImpl menuDao = new MenuDAOImpl();
            List<Menu> menus = menuDao.getAllMenus();
            if (menus == null) {
                System.out.println("Menus is null!");
            } else {
                System.out.println("Found " + menus.size() + " menus in database.");
                for (Menu m : menus) {
                    System.out.println("ID: " + m.getMenuId() + ", Name: " + m.getItemName() + ", Image: " + m.getImage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
