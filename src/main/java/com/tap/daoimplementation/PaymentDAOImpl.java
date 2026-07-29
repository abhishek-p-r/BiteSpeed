package com.tap.daoimplementation;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;


import com.tap.dao.PaymentDAO;
import com.tap.model.Payment;
import com.tap.utility.DBConnection;



public class PaymentDAOImpl implements PaymentDAO {



    private static final String INSERT_PAYMENT =

            "INSERT INTO payments "
            +
            "(order_id, amount, payment_method, "
            +
            "payment_status, transaction_id, payment_date) "
            +
            "VALUES(?,?,?,?,?,?)";




    private static final String GET_PAYMENT =

            "SELECT * FROM payments WHERE payment_id=?";




    private static final String GET_ALL =

            "SELECT * FROM payments ORDER BY payment_id DESC";




    private static final String GET_BY_ORDER =

            "SELECT * FROM payments WHERE order_id=?";




    private static final String UPDATE =

            "UPDATE payments SET "
            +
            "amount=?, "
            +
            "payment_method=?, "
            +
            "payment_status=?, "
            +
            "transaction_id=? "
            +
            "WHERE payment_id=?";




    private static final String DELETE =

            "DELETE FROM payments WHERE payment_id=?";




    private static final String EXISTS =

            "SELECT COUNT(*) FROM payments WHERE payment_id=?";









    @Override
    public int addPayment(Payment payment) {


        int result = 0;



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(INSERT_PAYMENT)

        ){



            ps.setInt(
                    1,
                    payment.getOrderId()
            );



            ps.setDouble(
                    2,
                    payment.getAmount()
            );



            ps.setString(
                    3,
                    payment.getPaymentMethod()
            );



            ps.setString(
                    4,
                    payment.getPaymentStatus()
            );



            ps.setString(
                    5,
                    payment.getTransactionId()
            );



            ps.setTimestamp(
                    6,
                    new Timestamp(
                            System.currentTimeMillis()
                    )
            );




            result =
                    ps.executeUpdate();




            if(result > 0){

                System.out.println(
                        "Payment Added Successfully"
                );

            }



        }
        catch(Exception e){


            e.printStackTrace();


        }



        return result;

    }









    @Override
    public Payment getPayment(int paymentId) {


        Payment payment = null;



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(GET_PAYMENT)

        ){



            ps.setInt(
                    1,
                    paymentId
            );



            ResultSet rs =
                    ps.executeQuery();




            if(rs.next()){


                payment =
                        extractPayment(rs);


            }



        }
        catch(Exception e){


            e.printStackTrace();

        }



        return payment;

    }









    @Override
    public List<Payment> getAllPayments() {



        List<Payment> payments =
                new ArrayList<>();




        try(
                Connection con =
                        DBConnection.getConnection();


                Statement st =
                        con.createStatement();


                ResultSet rs =
                        st.executeQuery(GET_ALL)

        ){



            while(rs.next()){


                payments.add(
                        extractPayment(rs)
                );


            }



        }
        catch(Exception e){


            e.printStackTrace();

        }




        return payments;

    }









    @Override
    public List<Payment> getPaymentsByOrder(int orderId) {



        List<Payment> payments =
                new ArrayList<>();




        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(GET_BY_ORDER)

        ){



            ps.setInt(
                    1,
                    orderId
            );



            ResultSet rs =
                    ps.executeQuery();




            while(rs.next()){


                payments.add(
                        extractPayment(rs)
                );


            }



        }
        catch(Exception e){


            e.printStackTrace();

        }




        return payments;

    }









    @Override
    public void updatePayment(Payment payment) {



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(UPDATE)

        ){



            ps.setDouble(
                    1,
                    payment.getAmount()
            );



            ps.setString(
                    2,
                    payment.getPaymentMethod()
            );



            ps.setString(
                    3,
                    payment.getPaymentStatus()
            );



            ps.setString(
                    4,
                    payment.getTransactionId()
            );



            ps.setInt(
                    5,
                    payment.getPaymentId()
            );



            Timestamp payTime = payment.getPaymentDate();
            if (payTime == null) {
                payTime = new Timestamp(System.currentTimeMillis());
            }
            ps.setTimestamp(6, payTime);
            int result = ps.executeUpdate();



        }
        catch(Exception e){


            e.printStackTrace();

        }


    }









    @Override
    public void deletePayment(int paymentId) {



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(DELETE)

        ){



            ps.setInt(
                    1,
                    paymentId
            );



            ps.executeUpdate();



        }
        catch(Exception e){


            e.printStackTrace();

        }


    }









    @Override
    public boolean paymentExists(int paymentId) {



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(EXISTS)

        ){



            ps.setInt(
                    1,
                    paymentId
            );



            ResultSet rs =
                    ps.executeQuery();




            if(rs.next()){


                return rs.getInt(1) > 0;


            }



        }
        catch(Exception e){


            e.printStackTrace();

        }




        return false;

    }









    private Payment extractPayment(ResultSet rs)
            throws Exception {



        Payment payment =
                new Payment();



        payment.setPaymentId(
                rs.getInt("payment_id")
        );



        payment.setOrderId(
                rs.getInt("order_id")
        );



        payment.setAmount(
                rs.getDouble("amount")
        );



        payment.setPaymentMethod(
                rs.getString("payment_method")
        );



        payment.setPaymentStatus(
                rs.getString("payment_status")
        );



        payment.setTransactionId(
                rs.getString("transaction_id")
        );



        payment.setPaymentDate(
                rs.getTimestamp("payment_date")
        );



        return payment;

    }



}