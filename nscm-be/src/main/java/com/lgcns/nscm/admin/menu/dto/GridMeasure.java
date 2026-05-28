package com.lgcns.nscm.admin.menu.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class GridMeasure {
    private String colNm;
    private String colLblNm;
    @JsonProperty("sClsLblNm")
    private String sClsLblNm;
    @JsonProperty("lClsLblNm")
    private String lClsLblNm;

    private boolean personalizable;

    private boolean display;

    private String attribute1;
    private String attribute2;
    private String attribute3;
    private String attribute4;
    private String attribute5;
    private String attribute6;
    private String attribute7;
    private String attribute8;
    private String attribute9;
    private String attribute10;

    public static GridMeasure of(Map<String, Object> data) {
    	return GridMeasure.builder()
    		.colNm((String) data.get("COLUMN_NAME"))
    		.colLblNm((String) data.get("COLUMN_LABEL_NAME"))
    		.sClsLblNm((String) data.get("SMALL_CLASS_LABEL_NAME"))
    		.lClsLblNm((String) data.get("LARGE_CLASS_LABEL_NAME"))
    		.personalizable(data.get("USER_SELECTABLE_FLAG").equals("Y") ? true : false)
    		.display(data.get("DISPLAY_FLAG").equals("Y") ? true : false)
    		.attribute1((String) data.get("ATTRIBUTE1"))
    		.attribute2((String) data.get("ATTRIBUTE2"))
    		.attribute3((String) data.get("ATTRIBUTE3"))
    		.attribute4((String) data.get("ATTRIBUTE4"))
    		.attribute5((String) data.get("ATTRIBUTE5"))
    		.attribute6((String) data.get("ATTRIBUTE6"))
    		.attribute7((String) data.get("ATTRIBUTE7"))
    		.attribute8((String) data.get("ATTRIBUTE8"))
    		.attribute9((String) data.get("ATTRIBUTE9"))
    		.attribute10((String) data.get("ATTRIBUTE10"))
    		.build();
    }

    public static List<GridMeasure> listOf(List<Map<String, Object>> datas) {
    	List<GridMeasure> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(GridMeasure.of(datas.get(i)));
		}
    	return result;
    }

    @JsonGetter("sClsLblNm")
    public String getSClsLblNm() {
        return sClsLblNm;
    }

    @JsonGetter("lClsLblNm")
    public String getLClsLblNm() {
        return lClsLblNm;
    }
}
