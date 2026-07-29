package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.SupportTicketDAOImpl;
import com.tap.model.SupportTicket;


public class SupportTicketTest {


    public static void main(String[] args) {


        SupportTicketDAOImpl dao =
                new SupportTicketDAOImpl();



        // ==========================
        // ADD TICKET
        // ==========================

        SupportTicket ticket = new SupportTicket();


        ticket.setUserId(1);
        ticket.setSubject("Order Issue");
        ticket.setMessage("My order is delayed");
        ticket.setStatus("OPEN");


        dao.addTicket(ticket);





        // ==========================
        // GET TICKET
        // ==========================

        System.out.println(
                dao.getTicket(1)
        );





        // ==========================
        // GET ALL TICKETS
        // ==========================

        List<SupportTicket> tickets =
                dao.getAllTickets();



        for(SupportTicket t : tickets){

            System.out.println(t);

        }





        // ==========================
        // UPDATE TICKET
        // ==========================

        SupportTicket update =
                dao.getTicket(1);



        if(update != null){


            update.setStatus("RESOLVED");


            dao.updateTicket(update);

        }





        // ==========================
        // DELETE TICKET
        // ==========================

        // dao.deleteTicket(1);


    }

}