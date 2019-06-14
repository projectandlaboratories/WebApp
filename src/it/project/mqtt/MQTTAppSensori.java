package it.project.mqtt;

import java.sql.Connection;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
//import org.json.JSONObject;

import it.project.db.DBClass;
import it.project.enums.Mode;
import it.project.enums.Topics;
import it.project.utils.DbIdentifiers;

public class MQTTAppSensori {

	private static final int qos = 2;
    private static String send_topic,subscribe_topic;
    private static MqttClient client;
    private static MqttConnectOptions conOpt;
    private static String endpoint = ""; //TODO da settare
    private static String username = "";//TODO da settare
    private static String password = "";//TODO da settare
    
    public static void setConnection(DbIdentifiers user) {
    	if(client == null || !client.isConnected()) {
    		try {
        		String host = String.format("tcp://%s", endpoint);
        		String clientId = user.name();
        		
        		conOpt = new MqttConnectOptions();
        		conOpt.setCleanSession(false);
        		conOpt.setUserName(username);
        		conOpt.setPassword(password.toCharArray());

        		client = new MqttClient(host, clientId, new MemoryPersistence());
        		client.connect(conOpt);
        		client.setCallback(new MqttCallback() {
					
					@Override
					public void messageArrived(String topic, MqttMessage message) throws Exception {
						Topics receivedTopic = Topics.valueOf(topic);
						switch(receivedTopic) {
							case TEMPERATURE:
//								JSONObject json = new JSONObject(new String(message.getPayload()));
//								String roomId = json.getString("roomId");
//								int currentTemp = Integer.parseInt(json.getString("currentTemp"));
								break;
							case ACTUATOR_STATUS:
								break;
						}
						
					}
					
					@Override
					public void deliveryComplete(IMqttDeliveryToken arg0) {
						// TODO Auto-generated method stub
						
					}
					
					@Override
					public void connectionLost(Throwable arg0) {
						// TODO Auto-generated method stub
						
					}
				});
        		
        		
        		client.subscribe(Topics.ACTUATOR_STATUS.getName(), qos);
        		client.subscribe(Topics.TEMPERATURE.getName(), qos);
        		
        	} catch(Exception e) {
            	e.printStackTrace();
            }
    	}
    	
    }
    
    
    public static void notifyModeChanged(Mode mode) throws MqttException {
        MqttMessage message = new MqttMessage(mode.name().getBytes());
        message.setQos(qos);
        client.publish(Topics.MODE.getName(), message);
    }

}
