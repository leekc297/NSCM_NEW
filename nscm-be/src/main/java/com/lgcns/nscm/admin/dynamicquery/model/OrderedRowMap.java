package com.lgcns.nscm.admin.dynamicquery.model;

import java.util.LinkedHashMap;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class OrderedRowMap extends LinkedHashMap<String, Object> {

	private static final long serialVersionUID = 1L;

	@Override
	public Object put(String key, Object value) {

		// CLOB 변환 로직
		if (value instanceof java.sql.Clob) {
			try {
				java.sql.Clob clob = (java.sql.Clob) value;
				String text = clob.getSubString(1, (int) clob.length());
				value = text;
			} catch (Exception e) {
				value = "";
				log.error("OrderedRowMap[Clob] convert Error. " + e.getMessage());
			}
		}
		// 오라클 전용 TIMESTAMP / DATE 타입 대응 (드라이버에 따라 다를 수 있음)
		else if (value != null
				&& (value.getClass().getName().contains("oracle.sql.TIMESTAMP")
						|| value.getClass().getName().contains("oracle.sql.DATE"))) {
			try {
				value = String.valueOf(value);
			} catch (Exception e) {
				value = "";
				log.error("OrderedRowMap[Date] convert Error. " + e.getMessage());
			}
		}

		return super.put(key, value);
	}
}
