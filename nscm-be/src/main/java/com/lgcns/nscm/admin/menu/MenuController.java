package com.lgcns.nscm.admin.menu;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.auth.AuthService;
import com.lgcns.nscm.admin.auth.dto.UnitDto;
import com.lgcns.nscm.admin.menu.dto.ColumnRetrieveRequest;
import com.lgcns.nscm.admin.menu.dto.FavoriteRequest;
import com.lgcns.nscm.admin.menu.dto.GridColumn;
import com.lgcns.nscm.admin.menu.dto.GridMeasure;
import com.lgcns.nscm.admin.menu.dto.MenuAuthDto;
import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.admin.menu.dto.SearchCondition;
import com.lgcns.nscm.admin.menu.dto.TitleSetSaveRequest;
import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.framework.security.CustomUserDetails;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Tag(name = "2. 메뉴 기능")
@RestController
@RequiredArgsConstructor
public class MenuController extends BaseController {

	private final MenuService menuService;
	private final AuthService authService;

	@Operation(summary = "메뉴 목록 조회", description = "사용자가 권한이 있는 메뉴 목록을 조회합니다.")
	@GetMapping(value="/admin/menu", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<MenuDto>>> retrieveMenus(@LoginUser UserSession userSession) throws Exception {
        return successResponseEntity(menuService.retrieveMenus(userSession.getUserId()));
    }

	@Operation(summary = "메뉴 접근 권한 확인", description = "사용자의 메뉴 접근 권한을 확인합니다.")
	@GetMapping(value="/admin/menu/{mnuId}/access", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<Void>> checkMenuAuth(@LoginUser UserSession userSession, @PathVariable String mnuId) throws Exception {
		boolean hasMenuAuth = authService.checkMenuAuth(userSession.getUserId(), mnuId);

		if (!hasMenuAuth) throw new AccessDeniedException("메뉴 접근 권한 없음");

		return successResponseEntity();
    }

	@Operation(summary = "메뉴 권한 조회", description = "해당 메뉴에 대한 사용자의 버튼 및 단위 권한을 조회합니다.")
	@GetMapping(value="/admin/menu/{mnuId}/auth", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<MenuAuthDto>> retrieveMenuAuth(@LoginUser UserSession userSession, @PathVariable String mnuId) throws Exception {

		List<String> mnuBtnAuth = authService.retrieveMenuBtnAuth(userSession.getUserId(), mnuId);
		List<UnitDto> unitAuth = authService.retrieveUnitAuth(userSession.getUserId(), mnuId);
		MenuAuthDto mnuAuthDto = MenuAuthDto.builder()
			.mnuBtnAuth(mnuBtnAuth)
			.unitAuth(unitAuth)
			.build();

		return successResponseEntity(mnuAuthDto);
    }

	@Operation(summary = "Grid Column 조회", description = "Grid Column을 조회합니다.")
	@PostMapping(value="/admin/menu/{mnuId}/column", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<List<GridColumn>>> retrieveGridColumns(@LoginUser UserSession userSession, @PathVariable String mnuId, @RequestBody ColumnRetrieveRequest dto) throws Exception {
		return successResponseEntity(menuService.retrieveGridColumns(userSession.getUserId(), mnuId, dto.getSheetNm(), dto.getDivisionId()));
	}

	@Operation(summary = "Grid Measure 조회", description = "Grid Measure을 조회합니다.")
	@PostMapping(value="/admin/menu/{mnuId}/measure", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<List<GridMeasure>>> retrieveGridMeasures(@LoginUser UserSession userSession, @PathVariable String mnuId, @RequestBody ColumnRetrieveRequest dto) throws Exception {
		return successResponseEntity(menuService.retrieveGridMeasures(userSession.getUserId(), mnuId, dto.getSheetNm(), dto.getDivisionId()));
	}

	@Operation(summary = "즐겨찾기 등록/삭제", description = "즐겨찾기를 등록 혹은 삭제합니다.")
	@PostMapping(value="/admin/menu/favorite", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<Void>> updateFavorite(@LoginUser UserSession userSession, @RequestBody FavoriteRequest dto) throws Exception {

		if (dto.isFavorite() == true) {
			menuService.addFavorite(userSession.getUserId(), dto.getMnuId());
		}
		if (dto.isFavorite() == false){
			menuService.removeFavorite(userSession.getUserId(), dto.getMnuId());
		}
		_updateMenuSession(dto.getMnuId(), dto.isFavorite());

		return successResponseEntity();
	}

	@Operation(summary = "검색조건 조회", description = "검색조건을 조회합니다.")
	@GetMapping(value="/admin/menu/{mnuId}/search-conditions", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<List<SearchCondition>>> retrieveSearchConditions(@LoginUser UserSession userSession, @PathVariable String mnuId) throws Exception {
		return successResponseEntity(menuService.retrieveSearchCondition(userSession.getUserId(), mnuId));
	}

	@Operation(summary = "검색조건 저장", description = "검색조건을 저장합니다.")
	@PostMapping(value="/admin/menu/{mnuId}/search-conditions", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<Void>> saveSearchConditions(@LoginUser UserSession userSession, @PathVariable String mnuId, @RequestBody List<SearchCondition> searchConditions) throws Exception {
		menuService.saveSearchCondition(userSession.getUserId(), mnuId, searchConditions);
		return successResponseEntity();
	}

	@Operation(summary = "컬럼 개인화 저장", description = "공용 Column 팝업의 컬럼 표시/순서/폭/색을 저장합니다.")
	@PostMapping(value="/admin/menu/{mnuId}/titleset", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<List<Map<String, Object>>>> saveTitleSet(@LoginUser UserSession userSession, @PathVariable String mnuId, @RequestBody TitleSetSaveRequest dto) throws Exception {
		return successResponseEntity(menuService.saveTitleSet(userSession.getUserId(), mnuId, dto));
	}

	@Operation(summary = "검색조건 초기화", description = "검색조건을 초기화합니다.")
	@PostMapping(value="/admin/menu/{mnuId}/search-conditions/reset", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<Void>> resetSearchConditions(@LoginUser UserSession userSession, @PathVariable String mnuId) throws Exception {
		menuService.resetSearchCondition(userSession.getUserId(), mnuId);
		return successResponseEntity();
	}

	private void _updateMenuSession(String mnuId, boolean isFavorite) {
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    if (auth == null || !(auth.getPrincipal() instanceof CustomUserDetails)) {
	        return;
	    }

	    CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();

	    List<MenuDto> menus = userDetails.getMenus();
	    if (menus != null) {
	    	_updateFavorite(menus, mnuId, isFavorite);
	    }

	    Authentication newAuth = new UsernamePasswordAuthenticationToken(
	        userDetails,
	        auth.getCredentials(),
	        auth.getAuthorities()
	    );

	    SecurityContextHolder.getContext().setAuthentication(newAuth);
	}

	private boolean _updateFavorite(List<MenuDto> menus, String mnuId, boolean isFavorite) {
	    for (MenuDto menu : menus) {
	        if (mnuId.equals(menu.getMnuId())) {
	            menu.setFavorite(isFavorite);
	            return true;
	        }

	        // 자식 메뉴 재귀 탐색
	        if (menu.getChildren() != null && !menu.getChildren().isEmpty()) {
	            if (_updateFavorite(menu.getChildren(), mnuId, isFavorite)) {
	                return true;
	            }
	        }
	    }
	    return false;
	}
}
