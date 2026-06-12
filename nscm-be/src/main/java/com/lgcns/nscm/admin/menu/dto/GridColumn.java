package com.lgcns.nscm.admin.menu.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Builder
@AllArgsConstructor
public class GridColumn {
    private String colNm;
    private String colLblNm;
    @JsonProperty("sClsLblNm")
    private String sClsLblNm;
    @JsonProperty("lClsLblNm")
    private String lClsLblNm;
    private String cellCtrlObjTpCd;
    private String cellCboDataTp;
    private String inputTpCd;
    private String horzAlgnCd;

    private BigDecimal scale;
    private BigDecimal colWth;

    private boolean fixed;
    private boolean uppercase;
    private boolean visible;
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

    // UI Category Setup 의 ATTRIBUTE1 이 SCM_ADM_CMBO_SQL_M 의 SQL_ID 이고
    // CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox' 일 때 BE 가 자동 resolve 하여 채움.
    // FE columnMapping.ts:161 `getDataMap(column.dataMap, column.attribute2)` 사용.
    @Setter
    private List<Map<String, Object>> dataMap;

    public static GridColumn of(Map<String, Object> data) {
    	return GridColumn.builder()
    		.colNm((String) data.get("COLUMN_NAME"))
    		.colLblNm((String) data.get("COLUMN_LABEL_NAME"))
    		.sClsLblNm((String) data.get("SMALL_CLASS_LABEL_NAME"))
    		.lClsLblNm((String) data.get("LARGE_CLASS_LABEL_NAME"))
    		.cellCtrlObjTpCd((String) data.get("CELL_CONTROL_OBJECT_TYPE_CODE"))
    		.cellCboDataTp((String) data.get("CELL_COMBO_DATA_TYPE"))
    		.inputTpCd((String) data.get("INPUT_TP_CD"))
    		.horzAlgnCd((String) data.get("HORIZONTAL_ALIGN_CODE"))
		.scale((BigDecimal) data.get("DATA_SCALE_NUMBER"))
    		.colWth((BigDecimal) data.get("COLUMN_WIDTH"))
    		.fixed(data.get("FIXED_FLAG").equals("Y") ? true : false)
    		.uppercase(data.get("UPPERCASE_APPLY_FLAG").equals("Y") ? true : false)
    		.visible(data.get("VISIBLE_FLAG").equals("Y") ? true : false)
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

    public static List<GridColumn> listOf(List<Map<String, Object>> datas) {
    	List<GridColumn> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(GridColumn.of(datas.get(i)));
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
