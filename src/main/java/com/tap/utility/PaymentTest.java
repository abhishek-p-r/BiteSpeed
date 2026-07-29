package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.PaymentDAOImpl;
import com.tap.model.Payment;



public class PaymentTest {


    public static void main(String[] args) {


        PaymentDAOImpl dao =
                new PaymentDAOImpl();



        Payment payment = new Payment();



        payment.setOrderId(1);

        payment.setAmount(499.99);

        payment.setPaymentMethod("UPI");

        payment.setPaymentStatus("SUCCESS");

        payment.setTransactionId("TXN10001");



        dao.addPayment(payment);







        System.out.println(
                dao.getPayment(1)
        );







        List<Payment> payments =
                dao.getAllPayments();



        for(Payment p : payments){

            System.out.println(p);

        }







        Payment update =
                dao.getPayment(1);



        if(update != null){


            update.setPaymentStatus("REFUNDED");


            dao.updatePayment(update);


        }







        // dao.deletePayment(1);



    }

}