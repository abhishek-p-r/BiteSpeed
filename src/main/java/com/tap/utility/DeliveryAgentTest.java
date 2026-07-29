package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.DeliveryAgentDAOImpl;
import com.tap.model.DeliveryAgent;

public class DeliveryAgentTest {

    public static void main(String[] args) {

        DeliveryAgentDAOImpl dao = new DeliveryAgentDAOImpl();

        // ==========================================
        // ADD DELIVERY AGENT
        // ==========================================

        DeliveryAgent agent = new DeliveryAgent();

        agent.setFullName("Ramesh Kumar");
        agent.setPhone("9876543210");
        agent.setEmail("ramesh@gmail.com");
        agent.setVehicleNumber("KA01AB1234");
        agent.setVehicleType("Bike");
        agent.setStatus("Available");

        // dao.addAgent(agent);

        // ==========================================
        // GET DELIVERY AGENT
        // ==========================================

        System.out.println("========== GET AGENT ==========");

        DeliveryAgent a = dao.getAgent(1);

        if (a != null) {
            System.out.println(a);
        } else {
            System.out.println("Delivery Agent Not Found");
        }

        // ==========================================
        // GET ALL DELIVERY AGENTS
        // ==========================================

        System.out.println("\n========== ALL AGENTS ==========");

        List<DeliveryAgent> agents = dao.getAllAgents();

        for (DeliveryAgent ag : agents) {
            System.out.println(ag);
        }

        // ==========================================
        // UPDATE DELIVERY AGENT
        // ==========================================

        System.out.println("\n========== UPDATE AGENT ==========");

        DeliveryAgent update = dao.getAgent(1);

        if (update != null) {

            update.setFullName("Ramesh K");
            update.setPhone("9999999999");
            update.setEmail("ramesh123@gmail.com");
            update.setVehicleNumber("KA05CD5678");
            update.setVehicleType("Scooter");
            update.setStatus("Busy");

            // dao.updateAgent(update);

            System.out.println("Delivery Agent Ready For Update");
        }

        // ==========================================
        // DELETE DELIVERY AGENT
        // ==========================================

        // dao.deleteAgent(1);

        System.out.println("\nDelivery Agent Test Completed Successfully.");
    }
}