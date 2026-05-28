package com.lgcns.nscm.admin.lookup.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class LookupRequest {
    private String lookupType;


    public static LookupRequest of(Map<String, Object> data) {
    	return LookupRequest.builder()
    		.lookupType((String) data.get("lookupType"))
    		.build();
    }

    public static List<LookupRequest> listOf(List<Map<String, Object>> datas) {
    	List<LookupRequest> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(LookupRequest.of(datas.get(i)));
		}
    	return result;
    }
}
