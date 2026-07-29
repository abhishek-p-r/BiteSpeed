package com.tap.dao;

import java.util.List;
import com.tap.model.Menu;


public interface MenuDAO {


    // Add new menu item
    void addMenu(Menu menu);



    // Get single menu item by id
    Menu getMenu(int menuId);



    // Get all menu items
    List<Menu> getAllMenus();



    // Get menu items by restaurant id
    List<Menu> getMenuByRestaurantId(int restaurantId);



    // Get menu items by category
    List<Menu> getMenusByCategory(String category);



    // Get only available menu items
    List<Menu> getAvailableMenus();



    // Search menu by name
    List<Menu> searchMenuByName(String itemName);



    // Update menu item
    void updateMenu(Menu menu);



    // Soft delete menu item
    void deleteMenu(int menuId);



    // Check menu exists
    boolean menuExists(int menuId);

}