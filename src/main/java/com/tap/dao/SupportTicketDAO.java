package com.tap.dao;

import java.util.List;
import com.tap.model.SupportTicket;

public interface SupportTicketDAO {

    void addTicket(SupportTicket ticket);

    SupportTicket getTicket(int ticketId);

    List<SupportTicket> getAllTickets();

    List<SupportTicket> getTicketsByUser(int userId);

    void updateTicket(SupportTicket ticket);

    void deleteTicket(int ticketId);

    boolean ticketExists(int ticketId);
}