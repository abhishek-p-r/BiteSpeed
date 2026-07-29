package com.tap.servlet;


import com.tap.dao.MenuDAO;
import com.tap.daoimplementation.MenuDAOImpl;
import com.tap.model.CartItem;
import com.tap.model.Menu;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


import java.io.IOException;
import java.util.HashMap;
import java.util.Map;



@WebServlet("/cart")
public class CartServlet extends HttpServlet {


    private static final long serialVersionUID = 1L;


    private MenuDAO menuDAO;



    @Override
    public void init() throws ServletException {

        menuDAO = new MenuDAOImpl();

    }





    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {



        HttpSession session = request.getSession();



        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>) session.getAttribute("cart");



        if(cart == null) {

            cart = new HashMap<>();

            session.setAttribute("cart", cart);

        }




        String action =
                request.getParameter("action");


        String itemIdParam =
                request.getParameter("itemId");





        try {



            if(action != null) {



                switch(action.toLowerCase()) {



                    // ==========================
                    // ADD TO CART
                    // ==========================

                    case "add":

                        if(itemIdParam != null) {

                            int itemId =
                                    Integer.parseInt(itemIdParam);

                            Menu menu =
                                    menuDAO.getMenu(itemId);

                            if(menu != null) {
                                int itemRestId = menu.getRestaurantId();
                                com.tap.model.Restaurant targetRest = new com.tap.daoimplementation.RestaurantDAOImpl().getRestaurant(itemRestId);
                                if (targetRest != null && !targetRest.isActive()) {
                                    response.sendRedirect(request.getContextPath() + "/menu?restaurantId=" + itemRestId + "&error=restaurant_inactive");
                                    return;
                                }

                                int quantityToAdd = 1;
                                String qtyParam = request.getParameter("quantity");
                                if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                                    try {
                                        quantityToAdd = Integer.parseInt(qtyParam);
                                    } catch (NumberFormatException e) {}
                                }

                                // Keep items in cart persistently until user explicitly removes or clears them


                                CartItem cartItem = cart.get(itemId);

                                if(cartItem == null) {

                                    cartItem = new CartItem(
                                                    menu.getMenuId(),
                                                    menu.getRestaurantId(),
                                                    menu.getItemName(),
                                                    menu.getPrice(),
                                                    quantityToAdd,
                                                    menu.getImage()
                                            );

                                    cart.put(itemId, cartItem);

                                }
                                else {

                                    cartItem.setQuantity(
                                            cartItem.getQuantity() + quantityToAdd
                                    );
                                }
                            }
                        }

                        break;

                    // ==========================
                    // UPDATE QUANTITY
                    // ==========================

                    case "update":



                        if(itemIdParam != null) {



                            int itemId =
                                    Integer.parseInt(itemIdParam);



                            int quantity =
                                    Integer.parseInt(
                                            request.getParameter("quantity")
                                    );




                            CartItem item =
                                    cart.get(itemId);




                            if(item != null) {



                                if(quantity <= 0) {


                                    cart.remove(itemId);


                                }
                                else {


                                    item.setQuantity(quantity);


                                }
                            }
                        }

                        break;


                    // ==========================
                    // REMOVE ITEM
                    // ==========================

                    case "remove":



                        if(itemIdParam != null) {



                            int itemId =
                                    Integer.parseInt(itemIdParam);



                            cart.remove(itemId);


                        }



                        break;







                    // ==========================
                    // CLEAR CART
                    // ==========================

                    case "clear":


                        cart.clear();


                        break;





                    default:


                        System.out.println(
                                "Invalid cart action : " + action
                        );


                }



            }





        }
        catch(Exception e) {


            e.printStackTrace();


        }






        if (cart != null && !cart.isEmpty()) {
            session.setAttribute("cart", cart);
            int totalQty = 0;
            for (CartItem ci : cart.values()) {
                totalQty += ci.getQuantity();
            }
            session.setAttribute("cartCount", totalQty);
        } else {
            if (cart != null) cart.clear();
            session.removeAttribute("cart");
            session.setAttribute("cartCount", 0);
        }






        String referer =
                request.getHeader("referer");




        if(referer != null && !referer.isEmpty()) {



            response.sendRedirect(referer);



        }
        else {



            response.sendRedirect(
                    request.getContextPath()
                    + "/cart.jsp"
            );


        }



    }







    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {



        request.getRequestDispatcher(
                "/cart.jsp"
        ).forward(request, response);



    }


}

