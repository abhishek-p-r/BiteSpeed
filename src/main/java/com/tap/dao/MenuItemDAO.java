package com.tap.dao;

import java.util.List;
import com.tap.model.MenuItem;

public interface MenuItemDAO {

    void addMenuItem(MenuItem menuItem);

    MenuItem getMenuItem(int menuItemId);

    List<MenuItem> getAllMenuItems();

    List<MenuItem> getMenuItemsByRestaurant(int restaurantId);

    List<MenuItem> getMenuItemsByCategory(int categoryId);

    List<MenuItem> searchMenuItem(String keyword);

    List<MenuItem> getAvailableMenuItems();

    void updateMenuItem(MenuItem menuItem);

    void deleteMenuItem(int menuItemId);

    boolean menuItemExists(int menuItemId);
}