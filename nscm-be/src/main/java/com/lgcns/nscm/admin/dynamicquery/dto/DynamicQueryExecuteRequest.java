package com.lgcns.nscm.admin.dynamicquery.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class DynamicQueryExecuteRequest {

	/** 실행/검증할 SQL 문장. */
	private String sqlText;
}
