package it.project.db;

import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

import it.project.utils.DbIdentifiers;

import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

public class MQTTClientPublishOnly{
	
	private static final int qos = 2;
    private static String send_topic;
    private static MqttClient client;
    private static MqttConnectOptions conOpt;
    private static Connection conn;
    private static String endpoint = "postman.cloudmqtt.com:17836";
    private static String username = "gadysjkt";
    private static String password = "OA4repM2hwOL";
    
    public static void setConnection(DbIdentifiers user) {
    	if(conn == null || client == null || !client.isConnected()) {
    		try {
        		String host = String.format("tcp://%s", endpoint);
        		String clientId = user.name();
        		if(user.equals(DbIdentifiers.LOCAL)) {
        			send_topic = "new_query_for_aws";
        		}
        		if(user.equals(DbIdentifiers.AWS)) {
        			send_topic = "new_query_for_local";
        		}
        		
        		conn = DBClass.getConnection(user);

        		conOpt = new MqttConnectOptions();
        		conOpt.setCleanSession(false);
        		conOpt.setUserName(username);
        		conOpt.setPassword(password.toCharArray());

        		client = new MqttClient(host, clientId, new MemoryPersistence());
        		client.connect(conOpt);	
        		
        	} catch(Exception e) {
            	e.printStackTrace();
            }
    	}
    	
    }

  
    public static void sendMessage(String payload) throws MqttException {
        MqttMessage message = new MqttMessage(payload.getBytes());
        message.setQos(qos);
        client.publish(send_topic, message);
    }

}
