package com.lgcns.nscm.framework.model;

import java.util.HashMap;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomMap extends HashMap<String, Object> {

	private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss.SSS";

	/**
	 * 공통 Data DTO
	 * Clob 및 Date/Timestamp 를 변환하여주는 map
	 * @MethodName : put
	 * @Description:
	 * @author     : story55
	 * @date       : 2026. 3. 5.
	 * @param      : @param key
	 * @param      : @param value
	 * @param      : @return
	 */
    public Object put(String key, Object value) {

    	// CLOB 변환 로직
        if (value instanceof java.sql.Clob) {
        	try {
                java.sql.Clob clob = (java.sql.Clob) value;
                String text = clob.getSubString(1, (int) clob.length());
                value = text;
            } catch (Exception e) {
            	value = "";
            	log.error("CustomMap[Clob] convert Error. "+e.getMessage());
            }
        }
        // 2. 오라클 전용 TIMESTAMP 타입 대응 (드라이버에 따라 다를 수 있음)
        else if (value.getClass().getName().contains("oracle.sql.TIMESTAMP") ||
                 value.getClass().getName().contains("oracle.sql.DATE")) {
            try {
                // 오라클 객체는 문자열로 변환 후 처리하거나 format 사용
                value = String.valueOf(value);
            } catch (Exception e) {
                value = "";
                log.error("CustomMap[Date] convert Error. "+e.getMessage());
            }
        }

        return super.put(key, value);
    }
}
