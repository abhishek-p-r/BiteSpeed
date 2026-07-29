package com.tap.daoimplementation;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderItemDAO;
import com.tap.model.OrderItem;
import com.tap.utility.DBConnection;



public class OrderItemDAOImpl implements OrderItemDAO {



    private static final String INSERT =

            "INSERT INTO order_items "
            +
            "(order_id, menu_id, quantity, price) "
            +
            "VALUES(?,?,?,?)";




    private static final String GET =

            "SELECT * FROM order_items "
            +
            "WHERE order_item_id=?";




    private static final String GET_ALL =

            "SELECT * FROM order_items "
            +
            "ORDER BY order_item_id DESC";




    private static final String GET_BY_ORDER =

            "SELECT * FROM order_items "
            +
            "WHERE order_id=?";




    private static final String UPDATE =

            "UPDATE order_items SET "
            +
            "menu_id=?, quantity=?, price=? "
            +
            "WHERE order_item_id=?";




    private static final String DELETE =

            "DELETE FROM order_items "
            +
            "WHERE order_item_id=?";








    @Override
    public int addOrderItem(OrderItem item) {
        int result = 0;
        String sql = "INSERT INTO order_items (order_id, menu_id, quantity, price, subtotal) VALUES(?,?,?,?,?)";
        double subtotal = item.getTotalPrice() > 0 ? item.getTotalPrice() : (item.getQuantity() * item.getPrice());

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getMenuId());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getPrice());
            ps.setDouble(5, subtotal);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }









    @Override
    public OrderItem getOrderItem(int orderItemId) {



        OrderItem item = null;



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(GET)

        ){



            ps.setInt(
                    1,
                    orderItemId
            );



            ResultSet rs =
                    ps.executeQuery();




            if(rs.next()){


                item =
                        extract(rs);

            }



        }
        catch(Exception e){


            e.printStackTrace();

        }




        return item;

    }









    @Override
    public List<OrderItem> getAllOrderItems() {



        List<OrderItem> list =
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


                list.add(
                        extract(rs)
                );

            }


        }
        catch(Exception e){


            e.printStackTrace();

        }




        return list;

    }









    @Override
    public List<OrderItem> getItemsByOrder(int orderId) {



        List<OrderItem> list =
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


                list.add(
                        extract(rs)
                );

            }


        }
        catch(Exception e){


            e.printStackTrace();

        }




        return list;

    }









    @Override
    public void updateOrderItem(OrderItem item) {



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(UPDATE)

        ){



            ps.setInt(
                    1,
                    item.getMenuId()
            );



            ps.setInt(
                    2,
                    item.getQuantity()
            );



            ps.setDouble(
                    3,
                    item.getPrice()
            );



            ps.setInt(
                    4,
                    item.getOrderItemId()
            );



            ps.executeUpdate();



        }
        catch(Exception e){


            e.printStackTrace();

        }


    }









    @Override
    public void deleteOrderItem(int orderItemId) {



        try(
                Connection con =
                        DBConnection.getConnection();


                PreparedStatement ps =
                        con.prepareStatement(DELETE)

        ){



            ps.setInt(
                    1,
                    orderItemId
            );



            ps.executeUpdate();



        }
        catch(Exception e){


            e.printStackTrace();

        }


    }









    private OrderItem extract(ResultSet rs)
            throws Exception {



        OrderItem item =
                new OrderItem();



        item.setOrderItemId(
                rs.getInt("order_item_id")
        );



        item.setOrderId(
                rs.getInt("order_id")
        );



        item.setMenuId(
                rs.getInt("menu_id")
        );



        item.setQuantity(
                rs.getInt("quantity")
        );



        item.setPrice(
                rs.getDouble("price")
        );

        item.setTotalPrice(
                item.getPrice() * (item.getQuantity() > 0 ? item.getQuantity() : 1)
        );

        return item;

    }









	@Override
	public boolean orderItemExists(int orderItemId) {
		// TODO Auto-generated method stub
		return false;
	}


}