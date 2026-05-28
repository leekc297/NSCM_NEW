package com.lgcns.nscm.admin.menu.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchCondition {

    private String paramNm;
    private String paramCtn;

    public static SearchCondition of(Map<String, Object> data) {
    	return SearchCondition.builder()
    		.paramNm((String) data.get("PRAM_NM"))
    		.paramCtn((String) data.get("PRAM_CTN"))
    		.build();
    }

    public static List<SearchCondition> listOf(List<Map<String, Object>> datas) {
    	List<SearchCondition> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(SearchCondition.of(datas.get(i)));
		}
    	return result;
    }
}
