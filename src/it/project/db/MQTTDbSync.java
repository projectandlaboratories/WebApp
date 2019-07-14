package it.project.db;

import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.json.JSONException;
import org.json.JSONObject;

import it.project.enums.Topics;
import it.project.mqtt.MQTTAppSensori;
import it.project.utils.DbIdentifiers;
import it.project.utils.ProfileUtil;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;

public class MQTTDbSync{
	
	private static final int qos = 2;
    private static String send_topic,subscribe_topic;
    private static MqttClient client;
    private static MqttConnectOptions conOpt;
    private static Connection conn;
    private static String endpoint = "postman.cloudmqtt.com:17836";
    private static String username = "gadysjkt";
    private static String password = "OA4repM2hwOL";
    private static ServletContext servletContext;
    
    public static void setConnection(DbIdentifiers user, ServletContext context) {
    	if(conn == null || client == null || !client.isConnected()) {
    		try {
        		String host = String.format("tcp://%s", endpoint);
        		servletContext = context;
        		String clientId = user.name();
        		if(user.equals(DbIdentifiers.LOCAL)) {
        			send_topic = Topics.LOCAL_NEWQUERY_SEND.getName();
        			subscribe_topic = Topics.LOCAL_NEWQUERY_SUBSCRIBE.getName();
        		}
        		if(user.equals(DbIdentifiers.AWS)) {
        			send_topic = Topics.AWS_NEWQUERY_SEND.getName();
        			subscribe_topic = Topics.AWS_NEWQUERY_SUBSCRIBE.getName();
        		}
        		
        		conn = DBClass.getConnection(user);

        		conOpt = new MqttConnectOptions();
        		conOpt.setCleanSession(false);
        		conOpt.setUserName(username);
        		conOpt.setPassword(password.toCharArray());

        		client = new MqttClient(host, clientId, new MemoryPersistence());
        		client.connect(conOpt);
        		System.out.println(new Date().toString() + "Connected to Remote Cloud MQTT");
        		client.setCallback(new MqttCallback() {
					
					@Override
					public void messageArrived(String topic, MqttMessage message) throws Exception {
						if(topic.equals(Topics.MQTT_APP_SENSORI.getName())) {
							JSONObject inputJson = new JSONObject(message.getPayload());
							System.out.println(new Date().toString() + "Topic MQTT_APP_SENSORI arrived: " + inputJson.toString());
							String operation = inputJson.getString("operation");
							JSONObject inputMessage = inputJson.getJSONObject("message");
							switch(operation) {
							case "modechange":
								MQTTAppSensori.notifyModeChanged(inputMessage);
								break;
							case "profilechange":
								MQTTAppSensori.notifyProfileChanged(inputMessage);
								break;
							case "connectroom":
								String roomId = inputMessage.getString("roomId");
								int airCondModelId = DBClass.getRoomByName(roomId).getIdAirCond();
								String ssid = "ESP-" + roomId;
								String espPassword =  DBClass.getConfigValue("espPassword");
								ProfileUtil.connectToRoom(context, roomId, airCondModelId, ssid, espPassword);
								break;
							}
						}
						else if(topic.equals(Topics.LAST_WILL.getName())) {
							//usato per segnalare che la schedina è ora attiva
							JSONObject lastWillJson = new JSONObject(new String(message.getPayload()));
							System.out.println(new Date().toString() + "Topic DbSync LAST_WILL arrived: " + lastWillJson.toString());
							String roomId = lastWillJson.getString("roomId");
			    			int roomStatus = lastWillJson.getInt("status");
			    			DBClass.updateRoomStatus(roomId, roomStatus);
						}
						else if(topic.equals(Topics.DEPLOY_NEW_VERSION.getName())) {
							String url = new String(message.getPayload());
							System.out.println(new Date().toString() + "Deploy new version TOPIC arrived");
							
							Process deployNewVersion = new ProcessBuilder("/bin/bash", servletContext.getRealPath("/bash/deploy_app.sh"), url)
									.redirectErrorStream(true).start();
							
							String line;
							BufferedReader input = new BufferedReader(new InputStreamReader(deployNewVersion.getInputStream()));
							while ((line = input.readLine()) != null) {
								String output = line;
							}
						}
						else {
							DBClass.executeQuery(new String(message.getPayload()));
						}
						
						
					}
					
					@Override
					public void deliveryComplete(IMqttDeliveryToken arg0) {
						
						
					}
					
					@Override
					public void connectionLost(Throwable arg0) {
						System.out.println(new Date().toString() + "DbSyncMQTT connection Lost");
						
					}
				});
        		
        		
        		client.subscribe(subscribe_topic, qos);
        		client.subscribe(Topics.LAST_WILL.name(),qos);
        		client.subscribe(Topics.DEPLOY_NEW_VERSION.getName());
        		
        		if(user.equals(DbIdentifiers.LOCAL))
        			client.subscribe(Topics.MQTT_APP_SENSORI.getName());
        		
        	} catch(Exception e) {
            	e.printStackTrace();
            }
    	}
    	
    }
    
    
    public static void sendQueryMessage(String payload) throws MqttException {
        MqttMessage message = new MqttMessage(payload.getBytes());
        message.setQos(qos);
        client.publish(send_topic, message);
    }
    
    public static void sendMQTTMessage(String payload,String operation) throws Exception {
    	JSONObject json = new JSONObject();
    	json.put("operation", operation);
    	JSONObject jsonMessage = new JSONObject(payload);
    	json.put("message", jsonMessage);
    	MqttMessage message = new MqttMessage(payload.getBytes());
        message.setQos(qos);
        client.publish(Topics.MQTT_APP_SENSORI.getName(), message);
    }
    
    public static void sendNewRoomInfo(String roomId, int airCondModel, String brokerIp) {
    	JSONObject json = new JSONObject();
    	try {
    		json.put("airCondModel", airCondModel);
        	json.put("brokerIp", brokerIp);
        	MqttMessage message = new MqttMessage(json.toString().getBytes());
            message.setQos(qos);
            message.setRetained(true);
            client.publish(Topics.ADD_ROOM.getName(), message);
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	
    	
    }
    
    public static void deployNewVersion() {
    	String url = "https://github.com/projectandlaboratories/WebApp/raw/master/WARFiles/WebApp.war";
    	MqttMessage message = new MqttMessage(url.getBytes());
    	try {
			client.publish(Topics.DEPLOY_NEW_VERSION.getName(), message);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
    }
    
    public static void connectToRoom(String roomId) {
    	JSONObject json = new JSONObject();
    	JSONObject roomIdObject = new JSONObject();
    	try {
    		roomIdObject.put("roomId", roomId);
			json.put("operation", "connectroom");
			json.put("message", roomIdObject);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

}
