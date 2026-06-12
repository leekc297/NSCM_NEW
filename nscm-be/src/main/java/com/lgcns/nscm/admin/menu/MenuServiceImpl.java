package com.lgcns.nscm.admin.menu;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.admin.lookup.LookupService;
import com.lgcns.nscm.admin.menu.dto.GridColumn;
import com.lgcns.nscm.admin.menu.dto.GridMeasure;
import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.admin.menu.dto.SearchCondition;
import com.lgcns.nscm.admin.menu.dto.SearchConditionForDB;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.security.CustomUserDetails;

import java.util.ArrayList;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MenuServiceImpl extends BaseService implements MenuService {

	private final String nameSpace = "admin.menu.";

	private final LookupService lookupService;

	@Override
	public List<MenuDto> retrieveMenus(String userId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);

		Map<String, Object> result = selectList(nameSpace + "retrieveMenus", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		return MenuDto.treeOf(MenuDto.listOf(data));
	}

	@Override
	public List<GridColumn> retrieveGridColumns(String userId, String mnuId, String sheetNm, String divisionId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);
		params.put("sheetNm", sheetNm);
		params.put("divisionId",divisionId);

		Map<String, Object> result = selectList(nameSpace + "retrieveGridColumns", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		List<GridColumn> columns = GridColumn.listOf(data);

		// UI Category Setup 의 ATTRIBUTE1 이 SCM_ADM_CMBO_SQL_M 의 SQL_ID 이고
		// CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox' 일 때 BE 가 자동 resolve.
		// FE 는 메타만 받아 wijmo dropdown 으로 자동 렌더 (틀 제공 / Column 속성 = admin 관리).
		resolveComboBoxDataMaps(columns, mnuId, divisionId);

		return columns;
	}

	/**
	 * cellCtrlObjTpCd='FPComboBox' AND attribute1=SQL_ID 컬럼들의 dataMap 을 자동 resolve.
	 * 회귀 안전성: column 마다 try-catch — SQL_ID 미등록·실행 실패 시 해당 column 만 skip.
	 * LookupService.retrieveCombo 재사용 (CMBO_SQL_M + execStmt).
	 * null param 주의: makeComboQuery 가 params.getOrDefault(key, "''") 사용하므로 null value 입력 시 NPE.
	 *                   값이 있을 때만 quote 로 wrap 해서 put.
	 */
	@SuppressWarnings("unchecked")
	private void resolveComboBoxDataMaps(List<GridColumn> columns, String mnuId, String divisionId) {
		for (GridColumn col : columns) {
			if (!"FPComboBox".equals(col.getCellCtrlObjTpCd())) continue;
			if (col.getAttribute1() == null || col.getAttribute1().isEmpty()) continue;
			try {
				Map<String, Object> p = new HashMap<>();
				p.put("comboId", col.getAttribute1());
				if (mnuId != null && !mnuId.isEmpty()) p.put("mnuId", "'" + mnuId + "'");
				if (divisionId != null && !divisionId.isEmpty()) p.put("divisionId", "'" + divisionId + "'");
				Map<String, Object> r = lookupService.retrieveCombo(p);
				Object v = r.get(col.getAttribute1());
				if (v instanceof List) col.setDataMap((List<Map<String, Object>>) v);
			} catch (Exception e) {
				// 해당 column 의 SQL_ID 미등록 또는 실행 실패 — skip (화면 진입 가능 보장).
				log.warn("FPComboBox resolve skip (mnuId={}, col={}, sqlId={}): {}",
						mnuId, col.getColNm(), col.getAttribute1(), e.getMessage());
			}
		}
	}

	@Override
	public List<GridMeasure> retrieveGridMeasures(String userId, String mnuId, String sheetNm, String divisionId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);
		params.put("sheetNm", sheetNm);
		params.put("divisionId", divisionId);

		Map<String, Object> result = selectList(nameSpace + "retrieveGridMeasures", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		return GridMeasure.listOf(data);
	}

	@Override
	public void addFavorite(String userId, String mnuId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);

		selectList(nameSpace + "addFavorite", params);

		return;
	}

	@Override
	public void removeFavorite(String userId, String mnuId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);

		selectList(nameSpace + "removeFavorite", params);

		return;
	}

	@Override
	public List<SearchCondition> retrieveSearchCondition(String userId, String mnuId) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);

		Map<String, Object> result = selectList(nameSpace + "retrieveSearchConditions", params);
		List<Map<String, Object>> data = ((List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT));

		return SearchCondition.listOf(data);

	}

	@Override
	public void saveSearchCondition(String userId, String mnuId, List<SearchCondition> searchConditions)
			throws Exception {

		ObjectMapper objectMapper = new ObjectMapper();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);
		params.put("searchConditions", objectMapper.writeValueAsString(SearchConditionForDB.listOf(searchConditions)));

		selectList(nameSpace + "saveSearchConditions", params);

		return;
	}

	@Override
	public void resetSearchCondition(String userId, String mnuId) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("mnuId", mnuId);

		selectList(nameSpace + "resetSearchConditions", params);

		return;
	}
}
