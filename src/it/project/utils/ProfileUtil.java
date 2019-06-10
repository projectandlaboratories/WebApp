package it.project.utils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import it.project.dto.Interval;
import it.project.dto.Profile;
import it.project.dto.Program;
import it.project.enums.DayMoment;
import it.project.enums.DayName;
import it.project.enums.DayType;

public class ProfileUtil {

	public static Program getProgramFromProfile(List<Profile> profiles) {
		
		Map<DayName,DayType> days = new HashMap<>();
		Map<DayType, List<Interval>> intervals  = new HashMap<>();
		
		for(Profile profile : profiles) {
			if(!days.containsKey(profile.getDayOfWeek()))
				days.put(profile.getDayOfWeek(), profile.getDayType());
			
			if(intervals.containsKey(profile.getDayType())) {
				intervals.get(profile.getDayType()).add(profile.getInterval());
			}
			else {
				List<Interval> programIntervalList = new ArrayList<>();
				programIntervalList.add(profile.getInterval());
				intervals.put(profile.getDayType(), programIntervalList);
			}
		}
		
		Program program = new Program(days,intervals);
		program.setName(profiles.get(0).getIdProfile());
		
		return program;
	}
	
	public static Map<String,List<Profile>> groupProfilesById(List<Profile> profiles) {
		Map<String,List<Profile>> profileMap = new HashMap<>();
		for(Profile profile : profiles) {
			if(profileMap.containsKey(profile.getIdProfile())) {
				profileMap.get(profile.getIdProfile()).add(profile);
			}
			else {
				List<Profile> programProfiles = new ArrayList<>();
				programProfiles.add(profile);
				profileMap.put(profile.getIdProfile(), programProfiles);
			}
		}
		
		return profileMap;
		
	}
	
	public static Profile getProfile(ResultSet result) throws SQLException {
		String idProfile = result.getString("ID_PROFILE");
		DayName dayOfWeek = DayName.valueOf(result.getString("DAY_OF_WEEK"));
		DayType dayType = DayType.valueOf(result.getString("DAY_TYPE"));
		DayMoment dayMoment = DayMoment.valueOf(result.getString("DAY_MOMENT"));
		int startHour = result.getInt("START_HOUR");
		int startMin = result.getInt("START_MIN");
		int endHour = result.getInt("END_HOUR");
		int endMin = result.getInt("END_MIN");
		double temperature = result.getDouble("TEMPERATURE");
		
		Interval interval = new Interval(startHour,startMin,endHour,endMin,temperature,dayMoment);
		Profile profile = new Profile(idProfile,dayOfWeek,dayType,interval);
		
		return profile;
		
	}
	

}
