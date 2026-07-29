package com.tap.dao;

import java.util.List;
import com.tap.model.MenuCategory;

public interface MenuCategoryDAO {

    void addCategory(MenuCategory category);

    MenuCategory getCategory(int categoryId);

    List<MenuCategory> getAllCategories();

    List<MenuCategory> getCategoriesByRestaurant(int restaurantId);

    void updateCategory(MenuCategory category);

    void deleteCategory(int categoryId);

    boolean categoryExists(int categoryId);
}