package com.tap.dao;

import java.util.List;
import com.tap.model.UserCoupon;

public interface UserCouponDAO {

    void assignCoupon(UserCoupon userCoupon);

    UserCoupon getUserCoupon(int id);

    List<UserCoupon> getCouponsByUser(int userId);

    void updateUserCoupon(UserCoupon userCoupon);

    void deleteUserCoupon(int id);
}