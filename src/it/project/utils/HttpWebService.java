package it.project.utils;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import it.project.db.DBClass;
import it.project.enums.HttpAction;

public class HttpWebService {
	private static final String baseUrl =  "http://ec2-34-220-162-82.us-west-2.compute.amazonaws.com:5002";
	private static String username = "PL19-20";
	private static String password = "projectpwd"; 
	private static String token = null;//TODO
	
	
	
	public static JSONObject getGroupInfo() {
		//{”group info”: group info, ”group id”: group id}
		return sendGet(HttpAction.GROUP);
	}
	public static JSONObject getDeviceInfo() {
		//{”status”: status, ”data”: {”configuration”: configuration, ”nickname”:
		//nickname, ”device status”: device status, ”device mac”: device mac}}
		return sendGet(HttpAction.DEVICE);
	}
	public static JSONObject getLogs() {
		/*{”status”: status, 
		 * ”data”: 
		 * 		[{”event id”: event id, ”timestamp dev”: timestamp dev, ”timestamp srv”: timestamp srv, 
		 * 			”event”: ”{”message”: message, ”sequence”: sequenceg”, ”device id”: device id},
		 * 		 ...]}”
		 */
		return sendGet(HttpAction.LOG);
	}
	private static JSONObject sendGet(HttpAction action) {
		try {
			System.out.println("entering GET "+action.toString());
			
			String url = baseUrl + action.getName();
			HttpClient client = HttpClientBuilder.create().build();
			HttpGet request = new HttpGet(url);
			


			token = getAuthenticationToken();
			
			System.out.println("GET "+action.toString());
			
			request.setHeader(HttpHeaders.AUTHORIZATION,"JWT "+token);
			
			HttpResponse response = client.execute(request);		
			System.out.println("Response Code : " + response.getStatusLine().getStatusCode());
			
			HttpEntity responseEnitity = response.getEntity();
			String retSrc = EntityUtils.toString(responseEnitity);
			System.out.println("BASE --> " + retSrc);
			
			switch(action) {
				case GROUP:
					retSrc=retSrc.substring(1,retSrc.length()-2).replace("\\", "");
					break;
				case DEVICE:
					retSrc=retSrc.substring(1,retSrc.length()-2).replace("\"{", "{").replace("}\\\"", "}").replace("\\", "");
					break;
				case LOG:
					retSrc=retSrc.substring(1,retSrc.length()-2).replace("\\", "");
					break;
			
			}
			
			System.out.println(retSrc);
	        JSONObject result = new JSONObject(retSrc); //Convert String to JSON Object
			
	        return result; //CAPIRE DOVE USARLO!!
			/*switch(action) {
				case GROUP:
					break;
				case DEVICE:
					break;
				case LOG:
					break;
				default:
					break;	
			}*/

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	
	public static String getAuthenticationToken() {
		String tokenDate = DBClass.getConfigValue("mqtt.tokenDate");
		if(tokenDate!=null) {
			//controllo se il token è più vecchio di 20 ore
			Date currentDate = new Date();
			Calendar cal = Calendar.getInstance();
			cal.setTime(currentDate);
			cal.add(Calendar.HOUR, -20);
			DateFormat mydateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String pastDate = mydateFormat.format(cal.getTime());
			System.out.println(pastDate);
			if(tokenDate.compareTo(pastDate)>=0) {//il token è ancora valido
				token = DBClass.getConfigValue("mqtt.token");
				System.out.println(tokenDate);
				System.out.println(token);
				return token;
			}
		}else {
			DBClass.insertConfigValue("mqtt.tokenDate", "2019-07-06 11:08:15");//inserisco una data vecchia
			DBClass.insertConfigValue("mqtt.token", "0");//inizializzo per poi fare update
		}
		
		JSONObject json = new JSONObject();
		try {
			json.put("username", username);
			json.put("password", password);
			sendPost(HttpAction.AUTH, json);
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return token;
	}
	
	public static void updateGroupInfo(String groupInfo) {
		JSONObject json = new JSONObject();
		try {
			json.put("group_id", username);
			json.put("group info", groupInfo);
			sendPost(HttpAction.GROUP, json);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void updateDeviceInfo(String deviceMac, String nickname, String configuration) {
		JSONObject json = new JSONObject();
		try {
			json.put("device mac", deviceMac);
			json.put("nickname", nickname);
			json.put("configuration", configuration);
			sendPost(HttpAction.DEVICE, json);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private static void sendPost(HttpAction action, JSONObject json) {
		String url = baseUrl + action.getName();
		HttpClient client = HttpClientBuilder.create().build();
		
		HttpPost request = new HttpPost(url);
		
		request.setHeader(HttpHeaders.CONTENT_TYPE,"application/json");

		if(action.equals(HttpAction.GROUP) || action.equals(HttpAction.DEVICE)) {
			
			token = getAuthenticationToken();
			request.setHeader(HttpHeaders.AUTHORIZATION,"JWT "+token);
		}
		
		try {			
			StringEntity requestEntity = new StringEntity(json.toString());
			request.setEntity(requestEntity);
			HttpResponse response = client.execute(request);
			
	        System.out.println("POST "+action.toString());
			System.out.println(json.toString());
			System.out.println("Response Code : " + response.getStatusLine().getStatusCode());
			
			if(action.equals(HttpAction.AUTH)){
				HttpEntity responseEnitity = response.getEntity();
				String retSrc = EntityUtils.toString(responseEnitity); 
		        JSONObject result = new JSONObject(retSrc); //Convert String to JSON Object
				token = result.getString("access_token");
		        System.out.println(token);
		        //TODO salva token su db
		        
		        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String tokenDate = dateFormat.format(new Date());
				DBClass.updateConfigValue("mqtt.tokenDate", tokenDate);
				DBClass.updateConfigValue("mqtt.token", token);		        		        
			}	
	        
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}
