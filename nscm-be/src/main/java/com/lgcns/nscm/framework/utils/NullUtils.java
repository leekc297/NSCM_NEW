package com.lgcns.nscm.framework.utils;


import java.lang.reflect.Array;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import com.google.gson.JsonObject;

public class NullUtils {

	private NullUtils() {
		super();
	}

	public static boolean isNull(Object value) {
		return value ==  null;
	}

	@SuppressWarnings("rawtypes")
	public static boolean isNone(Object obj) {

		if(obj == null || obj.equals(null)) return true;

		if(obj instanceof CharSequence) return ((CharSequence) obj).length() == 0;
		if(obj.getClass().isArray()) 	return Array.getLength(obj) == 0;
		if(obj instanceof Collection)	return ((Collection) obj).isEmpty();
		if(obj instanceof Map)			return ((Map) obj).isEmpty();
		if(obj instanceof String) 		return isNone(obj.toString());
		if(obj instanceof JsonObject) 	return isNone(((JsonObject) obj).entrySet());

		return false;
	}

	public static boolean isNone(String val) {
		return val == null || val.length() == 0
				|| val.equals("null") || val.equals("undefined");
	}

	public static boolean isNone(List val) {
		return val == null || val.isEmpty();
	}

	public static boolean isNone(int val) {
		try {Integer.toString(val);}
		catch (Exception e) {return true;}
		return false;
	}
}
