package com.tap.daoimplementation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.DeliveryAgentDAO;
import com.tap.model.DeliveryAgent;
import com.tap.utility.DBConnection;

public class DeliveryAgentDAOImpl implements DeliveryAgentDAO {

    // =====================================================
    // SQL QUERIES
    // =====================================================

    private static final String INSERT_AGENT =
            "INSERT INTO delivery_agents(full_name,phone,email,vehicle_number,vehicle_type,status) VALUES(?,?,?,?,?,?)";

    private static final String GET_AGENT =
            "SELECT * FROM delivery_agents WHERE agent_id=?";

    private static final String GET_ALL_AGENTS =
            "SELECT * FROM delivery_agents ORDER BY agent_id";

    private static final String UPDATE_AGENT =
            "UPDATE delivery_agents SET full_name=?,phone=?,email=?,vehicle_number=?,vehicle_type=?,status=? WHERE agent_id=?";

    private static final String DELETE_AGENT =
            "DELETE FROM delivery_agents WHERE agent_id=?";

    // =====================================================
    // ADD AGENT
    // =====================================================

    @Override
    public void addAgent(DeliveryAgent agent) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_AGENT)) {

            ps.setString(1, agent.getFullName());
            ps.setString(2, agent.getPhone());
            ps.setString(3, agent.getEmail());
            ps.setString(4, agent.getVehicleNumber());
            ps.setString(5, agent.getVehicleType());
            ps.setString(6, agent.getStatus());

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Delivery Agent Added Successfully");
            else
                System.out.println("Failed To Add Delivery Agent");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================================
    // GET AGENT
    // =====================================================

    @Override
    public DeliveryAgent getAgent(int agentId) {

        DeliveryAgent agent = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_AGENT)) {

            ps.setInt(1, agentId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                agent = extractAgent(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return agent;
    }
    // =====================================================
    // GET ALL AGENTS
    // =====================================================

    @Override
    public List<DeliveryAgent> getAllAgents() {

        List<DeliveryAgent> agents = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_AGENTS)) {

            while (rs.next()) {
                agents.add(extractAgent(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return agents;
    }

    // =====================================================
    // UPDATE AGENT
    // =====================================================

    @Override
    public void updateAgent(DeliveryAgent agent) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_AGENT)) {

            ps.setString(1, agent.getFullName());
            ps.setString(2, agent.getPhone());
            ps.setString(3, agent.getEmail());
            ps.setString(4, agent.getVehicleNumber());
            ps.setString(5, agent.getVehicleType());
            ps.setString(6, agent.getStatus());
            ps.setInt(7, agent.getAgentId());

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Delivery Agent Updated Successfully");
            else
                System.out.println("Failed To Update Delivery Agent");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================================
    // DELETE AGENT
    // =====================================================

    @Override
    public void deleteAgent(int agentId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_AGENT)) {

            ps.setInt(1, agentId);

            int rows = ps.executeUpdate();

            if (rows > 0)
                System.out.println("Delivery Agent Deleted Successfully");
            else
                System.out.println("Failed To Delete Delivery Agent");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================================
    // EXTRACT AGENT
    // =====================================================

    private DeliveryAgent extractAgent(ResultSet rs) throws Exception {

        DeliveryAgent agent = new DeliveryAgent();

        agent.setAgentId(rs.getInt("agent_id"));
        agent.setFullName(rs.getString("full_name"));
        agent.setPhone(rs.getString("phone"));
        agent.setEmail(rs.getString("email"));
        agent.setVehicleNumber(rs.getString("vehicle_number"));
        agent.setVehicleType(rs.getString("vehicle_type"));
        agent.setStatus(rs.getString("status"));

        return agent;
    }

}