package com.lgcns.nscm.admin.auth.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class UnitDto {
    private String unitTpCd;
    private String unitId;
    private String editYn;
    private boolean editable;

    public static UnitDto of(Map<String, Object> data) {
    	return UnitDto.builder()
    		.unitTpCd((String) data.get("UNIT_TP_CD"))
    		.unitId((String) data.get("UNIT_ID"))
    		.editYn((String) data.get("EDIT_YN"))
    		.editable(data.get("EDIT_YN").equals("Y") ? true : false)
    		.build();
    }

    public static List<UnitDto> listOf(List<Map<String, Object>> datas) {
    	List<UnitDto> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(UnitDto.of(datas.get(i)));
		}
    	return result;
    }
}
