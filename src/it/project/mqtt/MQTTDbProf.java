package it.project.mqtt;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

//import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
//import org.eclipse.paho.client.mqttv3.MqttCallback;
//import org.eclipse.paho.client.mqttv3.MqttClient;
//import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
//import org.eclipse.paho.client.mqttv3.MqttMessage;
//import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.json.JSONObject;

import com.amazonaws.services.iot.client.AWSIotMqttClient;
import com.amazonaws.services.iot.client.AWSIotQos;
import com.amazonaws.services.iot.client.sample.sampleUtil.SampleUtil;
import com.amazonaws.services.iot.client.sample.sampleUtil.SampleUtil.KeyStorePasswordPair;

import it.project.db.DBClass;
import it.project.utils.DbIdentifiers;


public class MQTTDbProf {
	//private static final int qos = 2;
	AWSIotQos qos = AWSIotQos.QOS1;//non esiste 2
	private static final String topicNotification = "pl19/notification";//subscribe
	private static final String topicEvent =  "pl19/event";//only send
	//private static MqttClient client;
    //private static MqttConnectOptions conOpt;
	private static AWSIotMqttClient client;
    private static String endpoint = "a3cezb6rg1vyed-ats.iot.us-west-2.amazonaws.com"; //TODO  :8883
    private static String clientId = "PL19-20";
    private static DbIdentifiers user;
   
    
    public static void setConnection(DbIdentifiers usr, String rootCApath,String certificatePath, String privateKeyPath) {
    	user = usr;
    	if(user.equals(DbIdentifiers.LOCAL) && (client == null || client.getConnection()==null)) {
	    	try {
	    		//String host = String.format("ssl://%s", endpoint);
	    		KeyStorePasswordPair pair = SampleUtil.getKeyStorePasswordPair(certificatePath, privateKeyPath);
	    		client = new AWSIotMqttClient(endpoint, clientId, pair.keyStore, pair.keyPassword);
	    		
	    		
	    		System.out.println("starting connect the server...");
	    		client.connect();	    		
	    		System.out.println("connected!");
	    		
	    		
/*	    		conOpt = new MqttConnectOptions();
	    		conOpt.setCleanSession(false);
	    		conOpt.setUserName(username);
	    		conOpt.setPassword(password.toCharArray());


<<<<<<< HEAD


				System.out.println("starting connect the server...");
	    		client = new MqttClient(host, clientId, new MemoryPersistence());
	    		client.connect(conOpt);
	    		System.out.println("connected!");
	    		client.setCallback(new MqttCallback() {
=======
    		client = new MqttClient(host, clientId, new MemoryPersistence());
    		client.connect(conOpt);
    		client.setCallback(new MqttCallback() {
				
				@Override
				public void messageArrived(String topic, MqttMessage message) throws Exception {
					topicReceived(topic,message);
				}
				
				@Override
				public void deliveryComplete(IMqttDeliveryToken arg0) {
					
>>>>>>> branch 'master' of https://github.com/projectandlaboratories/WebApp.git
					
<<<<<<< HEAD
					@Override
					public void messageArrived(String topic, MqttMessage message) throws Exception {
						System.out.println("topicReceived");
						topicReceived(topic,message);
					}
=======
				}
				
				@Override
				public void connectionLost(Throwable arg0) {
					
>>>>>>> branch 'master' of https://github.com/projectandlaboratories/WebApp.git
					
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
	    		*/
	    		
	    	} catch(Exception e) {
	        	e.printStackTrace();
	        }
    	}
    }
    
    /*public static void topicReceived(String topic,MqttMessage message) throws Exception {
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
    		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
			String tokenDate = dateFormat.format(new Date());
    		
			json.put("timestamp", tokenDate);
    		json.put("device_mac", DBClass.getConfigValue("mac"));
    		
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
    }*/
    
}