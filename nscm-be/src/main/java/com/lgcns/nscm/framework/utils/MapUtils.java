package com.lgcns.nscm.framework.utils;


import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.json.JSONObject;
import org.json.XML;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.framework.exception.BusinessException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class MapUtils {


	private MapUtils() {
		super();
	}

	//
	private static final ObjectMapper objectMapper = new ObjectMapper();

	public static List<String> findKeysContaining(Map<String, ?> map, String target) {
	    if (map == null) return Collections.emptyList();

	    return map.keySet().stream()
	              .filter(key -> key != null && key.contains(target))
	              .collect(Collectors.toList());
	}

    /**
     * 메서드 설명: List 값을 JSON 방식의 String 으로 변환한다.
     * * <pre>
     * {@code
     * 샘플 코드 예시
     *
     * }
     * </pre>
     * * @param list
     * * @return
     * @author story55
     * @since 2026. 2. 4.
     */
    public static String cvtListToJson(List<Map<String, Object>> list) {

    	if (list == null || list.isEmpty()) return "[]";

        try {
            return objectMapper.writeValueAsString(list);
        } catch (JsonProcessingException e) {
            log.error(e.getMessage());
            return "[]";
        }
    }

    /**
     * xml을 map으로 전환하는 함수
     *
     * @MethodName : cvtXmlToMap
     * @Description:
     <p><b>Usage Example:</b></p>
     * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
     * {@code
     *
     *
     * }
     * </pre>
     * @author     : story55
     * @date       : 2026. 3. 4.
     * @param      : @param xml
     * @param      : @return
     * @return     : Map<String,Object>
     */
    public static Map<String, Object> cvtXmlToMap(String xml) {
        JSONObject json = XML.toJSONObject(xml);
        return json.toMap();
    }


    public static boolean isFindKey(Map<String, ?> map, String key) {
    	if (map == null) return false;
    	else return map.containsKey(key);
    }

    public static void cvtJsonToJVarchar(Map<String, Object> oriMap, Set<String> cols) throws Exception {
    	if(MapUtils.isFindKey(oriMap, "data")) {
    		try {

    			List<Map<String, Object>> list = (List<Map<String, Object>>) oriMap.get("data");
//    			String jsonStr = (String) oriMap.get("data");
//    			List<Map<String, Object>> list = objectMapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>() {});
    			for(String key:cols) {
    				String value = "";
    				if(key.equals("sesUserId^")) {
    					String sUserId = SecurityUtil.getUserSession().getUserId();
    					for(int row=0; row<list.size(); row++) value += "^"+sUserId;
    				}
    				else if(key.equals("sesLangCd^")) {
    					String sLangCd = SecurityUtil.getUserSession().getLangCd();
    					for(int row=0; row<list.size(); row++) value += "^"+sLangCd;
    				}
    				else for(int row=0; row<list.size(); row++) value += "^"+list.get(row).get(key);
    				value = value.replaceAll("null", "");
	    			oriMap.put(key, value.substring(1));
    			}
    		} catch (Exception e) {
    			throw new BusinessException(e.getMessage());
			}
    	}
    }

    public static void decodeMap(Map<String, Object> encodedMap) {
    	if (encodedMap == null || encodedMap.isEmpty()) return;
        encodedMap.replaceAll((key, value) -> decodeValue(value));
    }

    public static Map<String, Object> decodeMapRtn(Map<String, Object> encodedMap) {
        if (encodedMap == null) return null;

        return encodedMap.entrySet().stream()
            .collect(Collectors.toMap(
                entry -> decodeString(entry.getKey()),       // Key 디코딩
                entry -> decodeValue(entry.getValue())       // Value 디코딩 (String일 경우만)
            ));
    }

    private static String decodeString(String str) {
        if (str == null) return null;
        try {
            return URLDecoder.decode(str, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return str;
        }
    }

    // Value가 String인 경우에만 디코딩 수행
    private static Object decodeValue(Object value) {
        if (value instanceof String) {
            return decodeString((String) value);
        }
        return value;
    }

    /*========================================================================================================================== */

/*
    public static void main(String[] args) {


    	String testData = "[\r\n"
    			+ "    	  {\"emp_id\": 101, \"name\": \"김철수\", \"dept_code\": \"HR\", \"rank\": \"과장\", \"loc\": \"서울\", \"base_sal\": 5500, \"bonus\": 500, \"tel\": \"010-1111-2222\", \"email\": \"kim@lgs.com\", \"join_date\": \"2015-03-01\", \"work_status\": \"재직\", \"proj_code\": \"P001\"},\r\n"
    			+ "    	  {\"emp_id\": 102, \"name\": \"이영희\", \"dept_code\": \"DEV\", \"rank\": \"대리\", \"loc\": \"판교\", \"base_sal\": 4800, \"bonus\": 800, \"tel\": \"010-2222-3333\", \"email\": \"lee@lgs.com\", \"join_date\": \"2018-07-15\", \"work_status\": \"재직\", \"proj_code\": \"P002\"},\r\n"
    			+ "    	  {\"emp_id\": 103, \"name\": \"박지성\", \"dept_code\": \"SAL\", \"rank\": \"부장\", \"loc\": \"부산\", \"base_sal\": 7200, \"bonus\": 1200, \"tel\": \"010-3333-4444\", \"email\": \"park@lgs.com\", \"join_date\": \"2010-11-20\", \"work_status\": \"재직\", \"proj_code\": \"P003\"},\r\n"
    			+ "    	  {\"emp_id\": 104, \"name\": \"최민수\", \"dept_code\": \"DEV\", \"rank\": \"사원\", \"loc\": \"판교\", \"base_sal\": 3500, \"bonus\": 300, \"tel\": \"010-4444-5555\", \"email\": \"choi@lgs.com\", \"join_date\": \"2023-01-02\", \"work_status\": \"수습\", \"proj_code\": \"P004\"},\r\n"
    			+ "    	  {\"emp_id\": 105, \"name\": \"정소희\", \"dept_code\": \"PLN\", \"rank\": \"차장\", \"loc\": \"서울\", \"base_sal\": 6300, \"bonus\": 900, \"tel\": \"010-5555-6666\", \"email\": \"jung@lgs.com\", \"join_date\": \"2014-05-12\", \"work_status\": \"재직\", \"proj_code\": \"P005\"},\r\n"
    			+ "    	  {\"emp_id\": 106, \"name\": \"강호동\", \"dept_code\": \"SUP\", \"rank\": \"과장\", \"loc\": \"대구\", \"base_sal\": 5200, \"bonus\": 400, \"tel\": \"010-6666-7777\", \"email\": \"kang@lgs.com\", \"join_date\": \"2016-09-30\", \"work_status\": \"재직\", \"proj_code\": \"P006\"},\r\n"
    			+ "    	  {\"emp_id\": 107, \"name\": \"유재석\", \"dept_code\": \"DEV\", \"rank\": \"팀장\", \"loc\": \"판교\", \"base_sal\": 8500, \"bonus\": 2000, \"tel\": \"010-7777-8888\", \"email\": \"yu@lgs.com\", \"join_date\": \"2011-02-14\", \"work_status\": \"재직\", \"proj_code\": \"P007\"},\r\n"
    			+ "    	  {\"emp_id\": 108, \"name\": \"홍길동\", \"dept_code\": \"MKT\", \"rank\": \"사원\", \"loc\": \"서울\", \"base_sal\": 3600, \"bonus\": 200, \"tel\": \"010-8888-9999\", \"email\": \"hong@lgs.com\", \"join_date\": \"2022-12-01\", \"work_status\": \"재직\", \"proj_code\": \"P008\"},\r\n"
    			+ "    	  {\"emp_id\": 109, \"name\": \"신사임\", \"dept_code\": \"FIN\", \"rank\": \"대리\", \"loc\": \"서울\", \"base_sal\": 4700, \"bonus\": 600, \"tel\": \"010-9999-0000\", \"email\": \"shin@lgs.com\", \"join_date\": \"2019-04-25\", \"work_status\": \"휴직\", \"proj_code\": \"P009\"},\r\n"
    			+ "    	  {\"emp_id\": 110, \"name\": \"장보고\", \"dept_code\": \"LOG\", \"rank\": \"과장\", \"loc\": \"인천\", \"base_sal\": 5400, \"bonus\": 700, \"tel\": \"010-0000-1111\", \"email\": \"jang@lgs.com\", \"join_date\": \"2017-08-08\", \"work_status\": \"재직\", \"proj_code\": \"P010\"}\r\n"
    			+ "    	]";

    	Map<String, Object> testMap = new HashMap<>();
    	testMap.put("data", testData);
    	Set<String> keys =  new HashSet<>();
    	keys.add("dept_code");
    	keys.add("base_sal");


    	MapUtils.cvtJsonToJVarchar(testMap, keys);
	}

*/
}
