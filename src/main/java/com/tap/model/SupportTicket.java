package com.tap.model;

import java.sql.Timestamp;

public class SupportTicket {

    private int ticketId;

    private int userId;

    private String subject;

    private String message;

    private String status;

    private Timestamp createdAt;



    // Default Constructor
    public SupportTicket() {

    }



    // Constructor for Add Ticket
    public SupportTicket(int userId,
                         String subject,
                         String message,
                         String status) {

        this.userId = userId;
        this.subject = subject;
        this.message = message;
        this.status = status;

    }



    // Full Constructor
    public SupportTicket(int ticketId,
                         int userId,
                         String subject,
                         String message,
                         String status,
                         Timestamp createdAt) {

        this.ticketId = ticketId;
        this.userId = userId;
        this.subject = subject;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;

    }



    public int getTicketId() {
        return ticketId;
    }


    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }



    public int getUserId() {
        return userId;
    }


    public void setUserId(int userId) {
        this.userId = userId;
    }



    public String getSubject() {
        return subject;
    }


    public void setSubject(String subject) {
        this.subject = subject;
    }



    public String getMessage() {
        return message;
    }


    public void setMessage(String message) {
        this.message = message;
    }



    public String getStatus() {
        return status;
    }


    public void setStatus(String status) {
        this.status = status;
    }



    public Timestamp getCreatedAt() {
        return createdAt;
    }


    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }



    @Override
    public String toString() {

        return "SupportTicket [ticketId=" + ticketId
                + ", userId=" + userId
                + ", subject=" + subject
                + ", message=" + message
                + ", status=" + status
                + ", createdAt=" + createdAt
                + "]";

    }

}