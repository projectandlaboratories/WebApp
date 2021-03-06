package it.project.dto;

import it.project.enums.SystemType;

import java.io.Serializable;

import it.project.enums.Mode;

public class Room implements Serializable{
	
	private String room;
	private String roomName;
	private int idAirCond;
	private boolean connState;
	private Program winterProfile;
	private Program summerProfile;
	private Mode mode;
	private double manualTemp;
	private SystemType manualSystem;
	
	
	public Room(String room, String roomName, int idAirCond, boolean connState, Program winterProfile,
			Program summerProfile, Mode mode, double manualTemp, SystemType manualSystem) {
		super();
		this.room = room;
		this.roomName = roomName;
		this.idAirCond = idAirCond;
		this.connState = connState;
		this.winterProfile = winterProfile;
		this.summerProfile = summerProfile;
		this.mode=mode;
		this.manualTemp = manualTemp;
		this.manualSystem = manualSystem;
	}


	public Mode getMode() {
		return mode;
	}


	public void setMode(Mode mode) {
		this.mode = mode;
	}


	public String getRoom() {
		return room;
	}


	public void setRoom(String room) {
		this.room = room;
	}


	public String getRoomName() {
		return roomName;
	}


	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}


	public int getIdAirCond() {
		return idAirCond;
	}


	public void setIdAirCond(int idAirCond) {
		this.idAirCond = idAirCond;
	}


	public boolean isConnState() {
		return connState;
	}


	public void setConnState(boolean connState) {
		this.connState = connState;
	}


	public Program getWinterProfile() {
		return winterProfile;
	}


	public void setWinterProfile(Program winterProfile) {
		this.winterProfile = winterProfile;
	}


	public Program getSummerProfile() {
		return summerProfile;
	}


	public void setSummerProfile(Program summerProfile) {
		this.summerProfile = summerProfile;
	}


	public double getManualTemp() {
		return manualTemp;
	}


	public void setManualTemp(double manualTemp) {
		this.manualTemp = manualTemp;
	}


	public SystemType getManualSystem() {
		return manualSystem;
	}


	public void setManualSystem(SystemType manualSystem) {
		this.manualSystem = manualSystem;
	}
	
	

}
