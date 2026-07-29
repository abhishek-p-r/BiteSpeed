package com.tap.dao;


import java.util.List;
import com.tap.model.Payment;



public interface PaymentDAO {


    int addPayment(Payment payment);



    Payment getPayment(int paymentId);



    List<Payment> getAllPayments();



    List<Payment> getPaymentsByOrder(int orderId);



    void updatePayment(Payment payment);



    void deletePayment(int paymentId);



    boolean paymentExists(int paymentId);


}