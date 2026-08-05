package com.lgcns.nscm.admin.dynamicquery;

import java.util.Map;


public interface DynamicQueryService {

	Map<String, Object> executeQuery(String sqlText) throws Exception;

	Map<String, Object> validateQuery(String sqlText) throws Exception;
}
