package com.lgcns.nscm.admin.dynamicquery;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.dynamicquery.model.OrderedCursorResult;
import com.lgcns.nscm.framework.base.BaseService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DynamicQueryServiceImpl extends BaseService implements DynamicQueryService {

	private final String nameSpace = "admin.dynamicquery.";

	@Override
	public Map<String, Object> executeQuery(String sqlText) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sqlText", sqlText);
		params.put("@o_rc1", null);
		params.put("@O_RESULT_CURSOR", null);

		Map<String, Object> result = selectList(nameSpace + "executeDynamicQuery", params);

		Object rc1 = result.get("o_rc1");
		if (rc1 instanceof OrderedCursorResult) {
			OrderedCursorResult cursor = (OrderedCursorResult) rc1;


			result.put("o_rc1", cursor.getRows());

			List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();
			for (OrderedCursorResult.ColumnMeta col : cursor.getColumns()) {
				Map<String, Object> c = new LinkedHashMap<String, Object>();
				c.put("name", col.getName());
				c.put("type", col.getType());
				columns.add(c);
			}
			result.put("o_rc1_columns", columns);
		}

		return result;
	}

	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> validateQuery(String sqlText) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sqlText", sqlText);
		params.put("@o_rc1", null);
		params.put("@O_RESULT_CURSOR", null);
		System.out.println("111");
		Map<String, Object> result = selectList(nameSpace + "validateDynamicQuery", params);

		Object rc1 = result.get("o_rc1");
		List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();
		if (rc1 instanceof List) {
			for (Map<String, Object> row : (List<Map<String, Object>>) rc1) {
				Map<String, Object> c = new LinkedHashMap<String, Object>();
				c.put("name", row.get("COLUMN_NAME"));
				c.put("type", row.get("VALUE_TYPE"));
				columns.add(c);
			}
		}
		result.put("o_rc1_columns", columns);

		result.remove("o_rc1");

		return result;
	}
}
