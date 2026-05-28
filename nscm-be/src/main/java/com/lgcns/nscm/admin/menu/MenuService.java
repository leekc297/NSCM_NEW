package com.lgcns.nscm.admin.menu;

import java.util.List;

import com.lgcns.nscm.admin.menu.dto.GridColumn;
import com.lgcns.nscm.admin.menu.dto.GridMeasure;
import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.admin.menu.dto.SearchCondition;

public interface MenuService {

	List<MenuDto> retrieveMenus(String userId) throws Exception;
	List<GridColumn> retrieveGridColumns(String userId, String mnuId, String sheetNm, String divisionId) throws Exception;
	List<GridMeasure> retrieveGridMeasures(String userId, String mnuId, String sheetNm, String divisionId) throws Exception;
	void addFavorite(String userId, String mnuId) throws Exception;
	void removeFavorite(String userId, String mnuId) throws Exception;
	List<SearchCondition> retrieveSearchCondition(String userId, String mnuId) throws Exception;
	void saveSearchCondition(String userId, String mnuId, List<SearchCondition> searchConditions) throws Exception;
	void resetSearchCondition(String userId, String mnuId) throws Exception;

}
