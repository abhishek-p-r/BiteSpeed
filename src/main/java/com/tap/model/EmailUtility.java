package com.tap.model;


import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;



public class EmailUtility {


    private static final String FROM_EMAIL = "your_email@gmail.com";

    private static final String PASSWORD = "your_app_password";




    public static void sendEmail(
            String toEmail,
            String subject,
            String emailBody
    ) throws Exception {



        Properties properties = new Properties();



        properties.put(
                "mail.smtp.host",
                "smtp.gmail.com"
        );


        properties.put(
                "mail.smtp.port",
                "587"
        );


        properties.put(
                "mail.smtp.auth",
                "true"
        );


        properties.put(
                "mail.smtp.starttls.enable",
                "true"
        );





        Session session =
                Session.getInstance(
                        properties,
                        new Authenticator() {


                            @Override
                            protected PasswordAuthentication
                            getPasswordAuthentication() {


                                return new PasswordAuthentication(
                                        FROM_EMAIL,
                                        PASSWORD
                                );


                            }

                        }
                );







        Message message =
                new MimeMessage(session);



        message.setFrom(
                new InternetAddress(FROM_EMAIL)
        );



        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail)
        );



        message.setSubject(subject);



        message.setContent(
                emailBody,
                "text/html"
        );



        Transport.send(message);



        System.out.println(
                "Email Sent Successfully"
        );



    }



}