package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.NotificationDAOImpl;
import com.tap.model.Notification;



public class NotificationTest {


	public static void main(String[] args) {



		NotificationDAOImpl dao = new NotificationDAOImpl();





		// ==========================
		// ADD NOTIFICATION
		// ==========================


		Notification notification = new Notification();



		notification.setUserId(1);

		notification.setTitle("Order Confirmed");

		notification.setMessage(
				"Your food order has been confirmed successfully"
				);

		notification.setRead(false);



		dao.addNotification(notification);








		// ==========================
		// GET NOTIFICATION BY ID
		// ==========================


		Notification result =
				dao.getNotification(1);



		System.out.println(result);








		// ==========================
		// GET USER NOTIFICATIONS
		// ==========================


		List<Notification> notifications =
				dao.getNotificationsByUser(1);



		for(Notification n : notifications){


			System.out.println(n);


		}








		// ==========================
		// MARK AS READ
		// ==========================


		dao.markAsRead(1);








		// ==========================
		// DELETE NOTIFICATION
		// ==========================


		// dao.deleteNotification(1);



	}

}