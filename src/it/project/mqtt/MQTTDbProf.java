package it.project.mqtt;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.json.JSONObject;

import it.project.utils.DbIdentifiers;

public class MQTTDbProf {
	private static final int qos = 2;
	private static final String topicNotification = "pl19/notification";//subscribe
	private static final String topicEvent =  "pl19/event";//only send
	private static MqttClient client;
    private static MqttConnectOptions conOpt;
    private static String endpoint = "a3cezb6rg1vyed-ats.iot.us-west-2.amazonaws.com"; //TODO ??
    private static String username = "PL19-20";
    private static String password = "projectdb";//TODO controlla
    private static DbIdentifiers user;

    public static void setConnection(DbIdentifiers usr) {
    	try {
    		String host = "";//???String.format("tcp://%s", endpoint);
    		String clientId = "";//??user.name();
    		
    		conOpt = new MqttConnectOptions();
    		conOpt.setCleanSession(false);
    		conOpt.setUserName(username);
    		conOpt.setPassword(password.toCharArray());

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
    		
    		
    		client.subscribe(topicNotification, qos);
    		
    		
    	} catch(Exception e) {
        	e.printStackTrace();
        }
    }
    
    public static void topicReceived(String topic,MqttMessage message) throws Exception {
		switch(topic) {
			case topicNotification:
				System.out.println("topicReceived notification");
				JSONObject tempJson = new JSONObject(new String(message.getPayload()));
				System.out.println(tempJson);
				int event_id = tempJson.getInt("event_id");
				System.out.println("event_id: "+event_id);//check if 0
				String sequence = tempJson.getJSONObject("event_data").getString("sequence"); 
				replyToPing(sequence);
				break;
			default:
				System.out.println("topicReceived default");
		}
    }
    
    public static void replyToPing(String sequence) {
    	JSONObject json = new JSONObject();
    	try {
    		json.put("event_id", 1);
    		JSONObject event = new JSONObject();
    		event.put("sequence", sequence);
    		json.put("event", event);
    		
    		publish(json.toString(),qos,topicEvent);
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    public static void publishEvent(String stringMessage) {
    	JSONObject json = new JSONObject();
    	//event_id ??
    	//timestamp %Y-%m-%d %H:%M:%S.%f.
    	//device_mac
    	//event : a string field containing arbitrary information about the event.
    	//publish(json.toString(),qos,topicEvent);
    }
    
    public static void publish(String stringMessage, int qos, String topic) throws Exception {
    	MqttMessage message = new MqttMessage(stringMessage.getBytes());
        message.setQos(qos);
        client.publish(topic, message);
    }
    
}
