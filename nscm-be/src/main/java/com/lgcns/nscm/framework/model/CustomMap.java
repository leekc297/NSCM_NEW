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

        // callSettersOnNulls=true(mybatis-config.xml) 이면 커서의 NULL 컬럼도 여기로 들어온다.
        // 아래 value.getClass() 가 NPE 를 내므로 null 은 변환 없이 그대로 담는다.
        // 필수: 이 가드와 callSettersOnNulls 설정은 한 쌍이다 — 가드 없이 설정만 켜면 모든 조회가 NPE 로 실패한다.
        if (value == null) {
            return super.put(key, null);
        }

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
