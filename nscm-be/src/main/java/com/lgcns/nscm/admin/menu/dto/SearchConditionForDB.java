package com.lgcns.nscm.admin.menu.dto;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

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
public class SearchConditionForDB {

	@JsonProperty("PRAM_NM")
    private String PRAM_NM;

	@JsonProperty("PRAM_CTN")
    private String PRAM_CTN;

    public static SearchConditionForDB of(SearchCondition data) {
    	return SearchConditionForDB.builder()
    		.PRAM_NM(data.getParamNm())
    		.PRAM_CTN(data.getParamCtn())
    		.build();
    }

    public static List<SearchConditionForDB> listOf(List<SearchCondition> datas) {
    	List<SearchConditionForDB> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(SearchConditionForDB.of(datas.get(i)));
		}
    	return result;
    }
}
