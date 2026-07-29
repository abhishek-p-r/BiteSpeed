package com.tap.dao;

import java.util.List;
import com.tap.model.DeliveryAgent;

public interface DeliveryAgentDAO {

    void addAgent(DeliveryAgent agent);

    DeliveryAgent getAgent(int agentId);

    List<DeliveryAgent> getAllAgents();

    void updateAgent(DeliveryAgent agent);

    void deleteAgent(int agentId);
}