package it.project.mqtt;

import java.sql.Connection;
import java.util.AbstractMap.SimpleEntry;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.MqttPersistenceException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;

import it.project.db.DBClass;
import it.project.db.MQTTDbSync;
import it.project.dto.Program;
import it.project.enums.ActuatorState;
import it.project.enums.Mode;
import it.project.enums.Season;
import it.project.enums.SystemType;
import it.project.enums.Topics;
import it.project.utils.DbIdentifiers;

public class MQTTAppSensori {

	private static final int qos = 2;
    private static String send_topic,subscribe_topic;
    private static MqttClient client;
    private static MqttConnectOptions conOpt;
    private static String endpoint = "192.168.1.44:1883"; //TODO da settare
    private static String username = "";//TODO da settare
    private static String password = "";//TODO da settare
    private static DbIdentifiers user;
    
    public static void setConnection(DbIdentifiers usr) {
    	user = usr;
    	if(user.equals(DbIdentifiers.LOCAL) && (client == null || !client.isConnected())) {
    		try {
        		String host = String.format("tcp://%s", endpoint);
        		String clientId = user.name();
        		
        		conOpt = new MqttConnectOptions();
        		conOpt.setCleanSession(false);
        		//conOpt.setUserName(username);
        		//conOpt.setPassword(password.toCharArray());

        		client = new MqttClient(host, clientId, new MemoryPersistence());
        		client.connect(conOpt);
        		client.setCallback(new MqttCallback() {
					
					@Override
					public void messageArrived(String topic, MqttMessage message) throws Exception {
						topicReceived(topic,message);
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
    
    public static void topicReceived(String topic,MqttMessage message) throws Exception {
    	Topics receivedTopic = Topics.valueOf(topic);
    	String roomId = "";
		switch(receivedTopic) {
			case TEMPERATURE:
				JSONObject tempJson = new JSONObject(new String(message.getPayload()));
				roomId = tempJson.getString("roomId");
				int currentTemp = Integer.parseInt(tempJson.getString("currentTemp"));
				DBClass.saveCurrentTemperature(roomId,currentTemp);
				break;
			case ACTUATOR_STATUS:
				JSONObject actJson = new JSONObject(new String(message.getPayload()));
				roomId = actJson.getString("roomId");
				ActuatorState actStatus = ActuatorState.valueOf(actJson.getString("status"));
				DBClass.saveActuatorStatus(roomId,actStatus);
				break;
		}
    }
    
    
    public static void notifyModeChanged(Mode mode, String roomId, double targetTemp, SystemType act) {

    	JSONObject json = new JSONObject();
    	try {
    		json.put("mode", mode.name());
    		if(mode.equals(Mode.MANUAL)) {
    			json.put("roomId", roomId);
    			json.put("targetTemp", targetTemp);
    			json.put("act", act.name());
    		} 
    		if(user.equals(DbIdentifiers.LOCAL)) {
    			publish(json.toString(),qos,Topics.MODE.getName());
    		}
    		else {
    			//pubblica su dbSync
    			MQTTDbSync.sendMQTTMessage(json.toString());
    		} 	

    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}



    }
    
    public static void notifyModeChanged(JSONObject json) throws Exception {
    	publish(json.toString(),qos,Topics.MODE.getName());
    }
    
    public static void notifyProfileChanged(String roomId, Season season, Program profile) {

    	Gson json = new Gson();
    	try {    		
    		Map<String,Object> map = new HashMap<>();
    		map.put("roomId", roomId);
    		map.put("season", season.name());
    		map.put("profile", profile);
    		String finalJson = new Gson().toJson(map);
    		if(user.equals(DbIdentifiers.LOCAL)) {
    			publish(finalJson,qos,Topics.PROFILE_CHANGE.getName());
    		}
    		else {
    			//pubblica su dbSync
    			MQTTDbSync.sendMQTTMessage(finalJson);
    		}      		
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}



    }
    
    public static void notifyProfileChanged(JSONObject json) throws Exception {
    	publish(json.toString(),qos,Topics.PROFILE_CHANGE.getName());
    }
    
    public static void publish(String stringMessage, int qos, String topic) throws Exception {
    	MqttMessage message = new MqttMessage(stringMessage.getBytes());
        message.setQos(qos);
        client.publish(topic, message);
    }
    	
}
