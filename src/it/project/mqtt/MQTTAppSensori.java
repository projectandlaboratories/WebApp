package it.project.mqtt;

import java.sql.Connection;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.AbstractMap.SimpleEntry;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

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
import it.project.dto.Room;
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
    private static String endpoint = "localhost:1883"; //TODO da settare
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
        		conOpt.setCleanSession(true);
        		//conOpt.setUserName(username);
        		//conOpt.setPassword(password.toCharArray());

        		client = new MqttClient(host, clientId, new MemoryPersistence());
        		client.connect(conOpt);
        		System.out.println(new Date().toString() + "connected to MQTTAppSensori");
        		client.setCallback(new MqttCallback() {
					
					@Override
					public void messageArrived(String topic, MqttMessage message) throws Exception {
						topicReceived(topic,message);
					}
					
					@Override
					public void deliveryComplete(IMqttDeliveryToken arg0) {
						
						
					}
					
					@Override
					public void connectionLost(Throwable arg0) {
						System.out.println(new Date().toString() + "AppSensoriMQTT connection Lost");
					}
				});
        		
        		
        		client.subscribe(Topics.ACTUATOR_STATUS.getName(), qos);
        		client.subscribe(Topics.TEMPERATURE.getName(), qos);
        		client.subscribe(Topics.ANTIFREEZE.getName(),qos);
        		
        		Map<String,Room> rooms = DBClass.getRooms();
		 		for(String roomId:rooms.keySet()) {
		 			subscribeLastWill(roomId);
		 		}
        		
        	} catch(Exception e) {
            	e.printStackTrace();
            }
    	}
    	
    }
    
    public static void subscribeLastWill(String roomId) {
    	try {
 			client.subscribe(Topics.LAST_WILL.getName()+"/"+roomId,qos);
 			System.out.println(new Date().toString() + "- subscribed to topic : " + Topics.LAST_WILL.getName()+"/"+roomId);
		} catch (MqttException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public static void unsubscribeLastWill(String roomId) {
    	try {
			client.unsubscribe(Topics.LAST_WILL.getName()+"/"+roomId);
			System.out.println(new Date().toString() + "- unsubscribed to topic : " + Topics.LAST_WILL.getName()+"/"+roomId);
		} catch (MqttException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public static void topicReceived(String topic,MqttMessage message) throws Exception {
    	
//    	Topics receivedTopic = null;
//    	for(Topics currTopic : Topics.values()) {
//    		if(currTopic.getName().equals(topic)) {
//    			receivedTopic = currTopic;
//    			break;
//    		}
//    	}
    	
    	
    	
    	if(topic.startsWith("Last")) {
    		topic = topic.split("/")[0];
    	}
    	String roomId = "";
    		switch(topic) {
    		case "Temperature":
    			JSONObject tempJson = new JSONObject(new String(message.getPayload()));
    			roomId = tempJson.getString("roomId");
    			float currentTemp = Float.parseFloat(tempJson.getString("currentTemp"));
    			long tempTimestamp = tempJson.getLong("timestamp");
    			DBClass.saveCurrentTemperature(roomId,currentTemp,tempTimestamp);
    			MQTTDbProf.sendAppSensoriLog(topic, roomId, Float.toString(currentTemp), tempTimestamp);
    			break;
    		case "ActuatorStatus":
    			JSONObject actJson = new JSONObject(new String(message.getPayload()));
    			System.out.println(new Date().toString() + " - Actuator status received: " + actJson.toString());
    			roomId = actJson.getString("roomId");
    			ActuatorState actStatus = ActuatorState.valueOf(actJson.getString("status"));
    			long actTimestamp = actJson.getLong("timestamp");
    			DBClass.saveActuatorStatus(roomId,actStatus,actTimestamp);
    			MQTTDbProf.sendAppSensoriLog(topic, roomId, actStatus.toString(), actTimestamp);
    			break;
    		case "LastWill":
    			JSONObject lastWillJson = new JSONObject(new String(message.getPayload()));
    			System.out.println(new Date().toString() + " - Last will received: " + lastWillJson.toString());
    			roomId = lastWillJson.getString("roomId");
    			int roomStatus = lastWillJson.getInt("status");
    			//send info to AP when room is reconnected
    			if(roomStatus == 1) {
    				Map<String,Room> roomsMap = DBClass.getRooms();
    				Room room = roomsMap.get(roomId);
    				Program summerProfile =room.getSummerProfile();
    				Program winterProfile = room.getWinterProfile();
    				notifyProfileChanged(roomId,Season.SUMMER,summerProfile);
    				notifyProfileChanged(roomId,Season.WINTER,winterProfile);
    				String weekendEndDate = DBClass.isWeekendMode();
    				if(weekendEndDate == null) {
    					notifyModeChanged(room.getMode(), roomId, room.getManualTemp(), room.getManualSystem(), 0);
    				}	
    				else {
    					DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    					format.setTimeZone(TimeZone.getTimeZone("Europe/Rome"));
    		 			Date endTimestamp = format.parse(weekendEndDate);
    					notifyModeChanged(Mode.WEEKEND, roomId, 0, null, endTimestamp.getTime()/1000);
    				}
    					
    			}
    			DBClass.updateRoomStatus(roomId, roomStatus);
    			MQTTDbProf.sendAppSensoriLog(topic, roomId, Integer.toString(roomStatus), System.currentTimeMillis());
    			break;
    		case "Antifreeze":
    			JSONObject antifreezeJson = new JSONObject(new String(message.getPayload()));
    			System.out.println(new Date().toString() + " - Antifreeze received: " + antifreezeJson.toString());
    			int status = antifreezeJson.getInt("status");
    			long timestampMillisecond = antifreezeJson.getLong("timestamp");
    			
    			if(status == 1)
    				DBClass.enableAntifreeze(timestampMillisecond);
    			else
    				DBClass.disableAntiFreeze(timestampMillisecond);
    			
    			MQTTDbProf.sendAppSensoriLog(topic, "-", Integer.toString(status), timestampMillisecond);
    		}
    	
		
    }
    
    
    public static void notifyModeChanged(Mode mode, String roomId, double targetTemp, SystemType act, long endTimestampMs) {

    	JSONObject json = new JSONObject();
    	try {
    		json.put("mode", mode.name());
    		
    		if(mode.equals(Mode.MANUAL)) {
    			json.put("roomId", roomId);
    			json.put("targetTemp", targetTemp);
    			json.put("act", act.name());
    		}
    		if(mode.equals(Mode.PROGRAMMABLE)) {
    			json.put("roomId", roomId);
    		}
    		if(mode.equals(Mode.WEEKEND)) {
    			json.put("endTimestamp", endTimestampMs);
    		}
    		if(mode.equals(Mode.OFF)) {
    			json.put("roomId", roomId);
    		}
    		    		
    		if(user.equals(DbIdentifiers.LOCAL)) {
    			publish(json.toString(),qos,Topics.MODE.getName()+"/"+roomId);
    		}
    		else {
    			//pubblica su dbSync
    			MQTTDbSync.sendMQTTMessage(json.toString(),"modechange");
    		}
    		System.out.println(new Date().toString() + " - Mode changed : " + json.toString());

    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}



    }
    
    
    public static void notifyModeChanged(JSONObject json, String roomId) throws Exception {
    	System.out.println(new Date().toString() + "Mode changed : " + json.toString());
    	publish(json.toString(),qos,Topics.MODE.getName()+"/"+roomId);  	
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
    			publish(finalJson,qos,Topics.PROFILE_CHANGE.getName()+"/"+roomId);
    		}
    		else {
    			//pubblica su dbSync
    			MQTTDbSync.sendMQTTMessage(finalJson,"profilechange");
    		} 
    		System.out.println(new Date().toString() + "Profile changed: profileName = " + profile.getName() + " for room: " + roomId);
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}



    }
    
    public static void notifyProfileChanged(JSONObject json,String roomId) throws Exception {
    	System.out.println(new Date().toString() + "Profile changed : " + json.toString());
    	publish(json.toString(),qos,Topics.PROFILE_CHANGE.getName()+"/"+roomId);
    }
    
    public static void publish(String stringMessage, int qos, String topic) throws Exception {
    	//TODO decommentare quando si testa con appSensori
    	MqttMessage message = new MqttMessage(stringMessage.getBytes());
        message.setQos(qos);
        client.publish(topic, message);
    }
    	
}
