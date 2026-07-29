package com.tap.dao;

import java.util.List;
import com.tap.model.CartItem;

public interface CartItemDAO {


    // Add new cart item
    void addCartItem(CartItem cartItem);


    // Get cart item by id
    CartItem getCartItem(int cartItemId);


    // Get all cart items
    List<CartItem> getAllCartItems();


    // Get cart items by cart id
    List<CartItem> getCartItemsByCart(int cartId);


    // Update cart item
    void updateCartItem(CartItem cartItem);


    // Delete cart item
    void deleteCartItem(int cartItemId);


    // Check cart item exists
    boolean cartItemExists(int cartItemId);

}