package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.SupportTicketDAO;
import com.tap.model.SupportTicket;
import com.tap.utility.DBConnection;


public class SupportTicketDAOImpl implements SupportTicketDAO {


    private static final String INSERT_TICKET =
            "INSERT INTO support_tickets(user_id,subject,message,status,created_at) VALUES(?,?,?,?,?)";


    private static final String GET_TICKET =
            "SELECT * FROM support_tickets WHERE ticket_id=?";


    private static final String GET_ALL_TICKETS =
            "SELECT * FROM support_tickets ORDER BY ticket_id";


    private static final String GET_TICKETS_BY_USER =
            "SELECT * FROM support_tickets WHERE user_id=?";


    private static final String UPDATE_TICKET =
            "UPDATE support_tickets SET user_id=?,subject=?,message=?,status=? WHERE ticket_id=?";


    private static final String DELETE_TICKET =
            "DELETE FROM support_tickets WHERE ticket_id=?";


    private static final String TICKET_EXISTS =
            "SELECT COUNT(*) FROM support_tickets WHERE ticket_id=?";



    // ==========================
    // ADD TICKET
    // ==========================

    @Override
    public void addTicket(SupportTicket ticket) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT_TICKET)) {


            ps.setInt(1, ticket.getUserId());
            ps.setString(2, ticket.getSubject());
            ps.setString(3, ticket.getMessage());
            ps.setString(4, ticket.getStatus());
            ps.setTimestamp(5,
                    new Timestamp(System.currentTimeMillis()));


            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Support Ticket Added Successfully");
            else
                System.out.println("Failed To Add Support Ticket");


        }catch(Exception e){
            e.printStackTrace();
        }

    }





    // ==========================
    // GET TICKET
    // ==========================

    @Override
    public SupportTicket getTicket(int ticketId) {


        SupportTicket ticket = null;


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_TICKET)){


            ps.setInt(1, ticketId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                ticket = extractTicket(rs);

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return ticket;
    }






    // ==========================
    // GET ALL TICKETS
    // ==========================

    @Override
    public List<SupportTicket> getAllTickets() {


        List<SupportTicket> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(GET_ALL_TICKETS)){


            while(rs.next()){

                list.add(extractTicket(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }







    // ==========================
    // GET TICKETS BY USER
    // ==========================

    @Override
    public List<SupportTicket> getTicketsByUser(int userId) {


        List<SupportTicket> list = new ArrayList<>();


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_TICKETS_BY_USER)){


            ps.setInt(1,userId);


            ResultSet rs = ps.executeQuery();


            while(rs.next()){

                list.add(extractTicket(rs));

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return list;

    }






    // ==========================
    // UPDATE TICKET
    // ==========================

    @Override
    public void updateTicket(SupportTicket ticket) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_TICKET)){


            ps.setInt(1,ticket.getUserId());
            ps.setString(2,ticket.getSubject());
            ps.setString(3,ticket.getMessage());
            ps.setString(4,ticket.getStatus());
            ps.setInt(5,ticket.getTicketId());


            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Support Ticket Updated Successfully");
            else
                System.out.println("Failed To Update Ticket");


        }catch(Exception e){

            e.printStackTrace();

        }

    }







    // ==========================
    // DELETE TICKET
    // ==========================

    @Override
    public void deleteTicket(int ticketId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(DELETE_TICKET)){


            ps.setInt(1,ticketId);


            int rows = ps.executeUpdate();


            if(rows > 0)
                System.out.println("Support Ticket Deleted Successfully");
            else
                System.out.println("Failed To Delete Ticket");


        }catch(Exception e){

            e.printStackTrace();

        }

    }







    // ==========================
    // TICKET EXISTS
    // ==========================

    @Override
    public boolean ticketExists(int ticketId) {


        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(TICKET_EXISTS)){


            ps.setInt(1,ticketId);


            ResultSet rs = ps.executeQuery();


            if(rs.next()){

                return rs.getInt(1) > 0;

            }


        }catch(Exception e){

            e.printStackTrace();

        }


        return false;

    }







    // ==========================
    // EXTRACT TICKET
    // ==========================

    private SupportTicket extractTicket(ResultSet rs) throws Exception {


        SupportTicket ticket = new SupportTicket();


        ticket.setTicketId(rs.getInt("ticket_id"));
        ticket.setUserId(rs.getInt("user_id"));
        ticket.setSubject(rs.getString("subject"));
        ticket.setMessage(rs.getString("message"));
        ticket.setStatus(rs.getString("status"));
        ticket.setCreatedAt(rs.getTimestamp("created_at"));


        return ticket;

    }

}