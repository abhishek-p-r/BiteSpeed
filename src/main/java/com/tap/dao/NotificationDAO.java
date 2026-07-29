package com.tap.dao;

import java.util.List;
import com.tap.model.Notification;

public interface NotificationDAO {

    void addNotification(Notification notification);

    Notification getNotification(int notificationId);

    List<Notification> getNotificationsByUser(int userId);

    void markAsRead(int notificationId);

    void deleteNotification(int notificationId);
}