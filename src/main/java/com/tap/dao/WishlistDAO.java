package com.tap.dao;

import java.util.List;
import com.tap.model.Wishlist;

public interface WishlistDAO {

    void addWishlist(Wishlist wishlist);

    Wishlist getWishlist(int wishlistId);

    List<Wishlist> getWishlistByUser(int userId);

    void deleteWishlist(int wishlistId);

    boolean exists(int userId, int menuItemId);
}