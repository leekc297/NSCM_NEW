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
import com.lgcns.nscm.admin.menu.dto.GridColumn;
import com.lgcns.nscm.admin.menu.dto.GridMeasure;
import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.admin.menu.dto.SearchCondition;
import com.lgcns.nscm.admin.menu.dto.SearchConditionForDB;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.security.CustomUserDetails;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MenuServiceImpl extends BaseService implements MenuService {

	private final String nameSpace = "admin.menu.";

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

		return GridColumn.listOf(data);
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
