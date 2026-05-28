package com.lgcns.nscm.admin.log.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class LogDto {
    private String mnuId;
    private String mnuNm;
    private String logTpCd;
    private String logTpNm;
    private String mnuBtnCd;
    private String mnuBtnNm;
    private BigDecimal diffTotal;
    private BigDecimal diffNetwork;
    private BigDecimal diffServer;
    private BigDecimal diffSql;
    private String clntIp;
    private String exctMsgCtn;
    private String userId;


    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    @Builder.Default
    private List<LogDto> children = new ArrayList<>();

    public static LogDto of(Map<String, Object> data) {
    	return LogDto.builder()
    		.mnuId((String) data.get("MNU_ID"))
    		.mnuNm((String) data.get("MNU_NM"))
    		.logTpCd((String) data.get("LOG_TP_CD"))
    		.logTpNm((String) data.get("LOG_TP_NM"))
    		.mnuBtnCd((String) data.get("MNU_BTN_CD"))
    		.mnuBtnNm((String) data.get("MNU_BTN_NM"))
    		.diffTotal((BigDecimal) data.get("DIFF_TOTAL"))
    		.diffNetwork((BigDecimal) data.get("DIFF_NET"))
    		.diffServer((BigDecimal) data.get("DIFF_SVR"))
    		.diffSql((BigDecimal) data.get("DIFF_DB"))
    		.clntIp((String) data.get("RQR_CLNT_IP"))
    		.exctMsgCtn((String) data.get("EXCT_MSG_CTN"))
    		.userId((String) data.get("USER_ID"))
    		.build();
    }

    public static List<LogDto> listOf(List<Map<String, Object>> datas) {
    	List<LogDto> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(LogDto.of(datas.get(i)));
		}
    	return result;
    }


}
