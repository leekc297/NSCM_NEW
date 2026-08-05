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
import com.lgcns.nscm.admin.menu.dto.TitleSetSaveRequest;
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

	/**
	 * 컬럼 개인화(titleSet) 저장 — 공용 Column 팝업 전용.
	 *
	 * <p>프로시저가 programId/sheetName 을 인자로 받아 메뉴 종속이 없으므로, 화면마다
	 * SCM_ADM_MNU_BTN_MPG_M 에 (MNU_ID, 'titleSet', 'SAVE') 를 등록하는 대신 고정 매핑을 쓴다.
	 * programId 는 path 의 mnuId, P_USER_ID 는 로그인 세션에서 채운다(클라이언트 신뢰 금지).
	 *
	 * <p>반환값 = 프로시저 첫 OUT 커서 행. 호출측(FE)이 기존과 동일하게 CODE 로 성공 여부를 판정한다.
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> saveTitleSet(String userId, String mnuId, TitleSetSaveRequest request) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("programId", mnuId);
		params.put("sheetName", request.getSheetName());
		params.put("columnType", request.getColumnType());
		params.put("activeFlag", request.getActiveFlag());
		params.put("columnName", request.getColumnName());
		params.put("sortOrderNo", request.getSortOrderNo());
		params.put("subTotalFlag", request.getSubTotalFlag());
		params.put("sortMethodCode", request.getSortMethodCode());
		params.put("sesUserId", userId);
		params.put("columnWidth", request.getColumnWidth());
		params.put("cellColor", request.getCellColor());
		params.put("textColor", request.getTextColor());

		Map<String, Object> result = selectList(nameSpace + "saveTitleSet", params);

		return (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);
	}
}
