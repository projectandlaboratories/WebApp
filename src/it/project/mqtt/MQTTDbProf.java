package it.project.mqtt;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONException;
//import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
//import org.eclipse.paho.client.mqttv3.MqttCallback;
//import org.eclipse.paho.client.mqttv3.MqttClient;
//import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
//import org.eclipse.paho.client.mqttv3.MqttMessage;
//import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.json.JSONObject;

import com.amazonaws.services.iot.client.AWSIotMessage;
import com.amazonaws.services.iot.client.AWSIotMqttClient;
import com.amazonaws.services.iot.client.AWSIotQos;
import com.amazonaws.services.iot.client.AWSIotTopic;
import com.amazonaws.services.iot.client.sample.sampleUtil.SampleUtil;
import com.amazonaws.services.iot.client.sample.sampleUtil.SampleUtil.KeyStorePasswordPair;
import org.eclipse.paho.client.mqttv3.internal.wire.MqttReceivedMessage;
import it.project.db.DBClass;
import it.project.dto.Program;
import it.project.dto.Room;
import it.project.utils.DbIdentifiers;


public class MQTTDbProf {
	//private static final int qos = 2;
	static AWSIotQos qos = AWSIotQos.QOS1;//non esiste 2
	private static final String topicNotification = "pl19/notification";//subscribe
	private static final String topicEvent =  "pl19/event";//only send
	//private static MqttClient client;
    //private static MqttConnectOptions conOpt;
	private static AWSIotMqttClient client;
    private static String endpoint = "a3cezb6rg1vyed-ats.iot.us-west-2.amazonaws.com"; //TODO  :8883
    private static String clientId = "pl19-20";
    private static DbIdentifiers user;
    private static long timeout = 3000;
    private static String mac;
    
    private static String getMac() {
    	if(mac==null) {
    		mac=DBClass.getConfigValue("mac");
    	}
    	return mac;
    }
   
    
    public static void setConnection(DbIdentifiers usr, String rootCApath,String certificatePath, String privateKeyPath) {
    	user = usr;
    	if(user.equals(DbIdentifiers.LOCAL) && (client == null || client.getConnection()==null)) {
	    	try {
	    		KeyStorePasswordPair pair = SampleUtil.getKeyStorePasswordPair(certificatePath, privateKeyPath);
	    		client = new AWSIotMqttClient(endpoint, clientId, pair.keyStore, pair.keyPassword);

	    		System.out.println("starting connect the server...");
	    		client.connect();	    		
	    		System.out.println("connected!");
	    		
	    		NotificationTopic topic = new NotificationTopic(topicNotification, qos);
	    		client.subscribe(topic);
	    		
	    	} catch(Exception e) {
	        	e.printStackTrace();
	        }
    	}
    }
    
    
    public static class NotificationTopic extends AWSIotTopic {
        public NotificationTopic(String topic, AWSIotQos qos) {
            super(topic, qos);
        }

        @Override
        public void onMessage(AWSIotMessage message) {
        	/*{"device_mac":"00:00:00:00:00:00","event_id":0,"event":{"sequence":10296,"message":"Please reply."},"timestamp":"2019-07-08 12:51:14.992790"}
			event_id: 0*/
        	System.out.println("topicReceived notification");
			JSONObject tempJson;
			try {
				tempJson = new JSONObject(new String(message.getPayload()));
				System.out.println(tempJson);
				int event_id = tempJson.getInt("event_id");
				//System.out.println("event_id: "+event_id);//check if 0
				int sequence = tempJson.getJSONObject("event").getInt("sequence"); 
				replyToPing(sequence);
			} catch (Exception e) {
				e.printStackTrace();
			}
        }
    }
    
    public static class MyMessage extends AWSIotMessage {
        public MyMessage(String topic, AWSIotQos qos, String payload) {
            super(topic, qos, payload);
        }

        @Override
        public void onSuccess() {
            // called when message publishing succeeded
        	System.out.println("Success!");
        }

        @Override
        public void onFailure() {
            // called when message publishing failed
        	System.out.println("Failure!");
        }

        @Override
        public void onTimeout() {
            // called when message publishing timed out
        	System.out.println("Timeout!");
        }
    }
    
    public static void replyToPing(int sequence) {
    	JSONObject json = new JSONObject();
    	try {
    		json.put("event_id", 1);
    		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
			String timestamp = dateFormat.format(new Date());
    		
			json.put("timestamp", timestamp);
    		json.put("device_mac", getMac());
    		
    		JSONObject event = new JSONObject();
    		event.put("sequence", sequence);
    		json.put("event", event);
    		
    		System.out.println(json.toString());
    		MyMessage message = new MyMessage(topicEvent, qos, json.toString());
    		client.publish(message, timeout);
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    public static void sendLog(JSONObject event) {
    	JSONObject json = new JSONObject();
    	try {
    		json.put("event_id", 2);//non è specificato il valore
    		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
			String timestamp = dateFormat.format(new Date());
    		
			json.put("timestamp", timestamp);
    		json.put("device_mac", getMac());
    		
    		json.put("event", event);
    		
    		System.out.println("Sending: " + json.toString());
    		MyMessage message = new MyMessage(topicEvent, qos, json.toString());
    		client.publish(message, timeout);
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    public static void sendAppSensoriLog(String type, String roomId, String status, long timestamp) {
    	JSONObject log = new JSONObject();
    	try {
			log.put("type", type);
			log.put("roomId", roomId);
			log.put("status", status);
			log.put("timestamp", timestamp);
			sendLog(log);
		} catch (JSONException e) {
			e.printStackTrace();
		}
    }
    
    public static void sendEditRoomLog(String type, String roomId, Room room, long timestamp) {
    	//type = ADDROOM, EDITROOM, DELETEROOM
    	JSONObject log = new JSONObject();
    	try {
			log.put("type", type);
			log.put("roomId", roomId);
			if(room!=null) {
				JSONObject jroom = new JSONObject();
				jroom.put("roomId", room.getRoom());
				jroom.put("roomName", room.getRoomName());
				jroom.put("idAirCond", room.getIdAirCond());
				jroom.put("winterProfileId", room.getWinterProfile().getName());
				jroom.put("summerProfileId", room.getSummerProfile().getName());
				log.put("room", jroom);
			}else {
				log.put("roomId", roomId);
			}
			log.put("timestamp", timestamp);
			sendLog(log);
		} catch (JSONException e) {
			e.printStackTrace();
		}
    }
    
    public static void sendEditProfileLog(String type, String profileId, Program program, long timestamp) {
    	//type = ADDROOM, EDITROOM, DELETEROOM
    	JSONObject log = new JSONObject();
    	try {
			log.put("type", type);
			log.put("profileId", profileId);
			if(program!=null) {
				JSONObject jprogram = new JSONObject(program);
				log.put("profile", jprogram);
			}else {
				log.put("profileId",profileId);				
			}
			
			log.put("timestamp", timestamp);
			sendLog(log);
		} catch (JSONException e) {
			e.printStackTrace();
		}
    }
    
}
