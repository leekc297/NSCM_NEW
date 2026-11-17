package com.lgcns.nscm.admin.user;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.menu.MenuService;
import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.admin.user.dto.LangCdRequest;
import com.lgcns.nscm.admin.user.dto.LoginRequest;
import com.lgcns.nscm.admin.user.dto.TmzCdRequest;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.framework.security.CustomUserDetails;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Tag(name = "0. 로그인 관리")
@RestController
@RequiredArgsConstructor
public class UserController extends BaseController {

	private final UserService userService;
	private final MenuService menuService;

	@Operation(summary = "유저 세션 확인", description = "현재 로그인 된 유저 세션 정보를 확인합니다.")
    @GetMapping("/user/session")
	public ResponseEntity<BaseResponse<UserSession>> getUserSession(@LoginUser UserSession userSession) throws SQLException {
		// 세션 확인 시마다 메뉴를 DB 에서 재조회해 세션 캐시(CustomUserDetails.menus)를 갱신한다.
		// 메뉴 관리(Active 등)·권한 변경분이 재로그인 없이 새로고침으로 반영되도록 하기 위함이다.
		// 조회 실패 시에는 로그인 시점 캐시를 그대로 반환한다 — 세션 확인 자체가 DB 오류로
		// 로그아웃(FE fetchSession 실패 처리)을 유발하지 않게 한다.
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null && auth.getPrincipal() instanceof CustomUserDetails userDetails) {
			try {
				List<MenuDto> menus = menuService.retrieveMenus(
					userDetails.isGuest() ? BaseConstants.GUEST_USER_ID : userDetails.getUserId());
				userDetails.setMenus(menus);
				userSession.setMenus(menus);
			} catch (Exception e) {
				log.info("session menu refresh exception. userId={}", userSession.getUserId());
			}
		}
		return successResponseEntity(userSession);
	}

	@Operation(summary = "사용자 소속 그룹 조회", description = "특정 사용자가 속한 그룹(USER_GR_ID/USER_GR_NM) 목록을 조회합니다. USE_YN='Y' 만. 화면 Assign Group 조회용.")
    @GetMapping("/user/{userId}/groups")
	public ResponseEntity<BaseResponse<List<Map<String, Object>>>> getUserGroups(@PathVariable String userId) throws Exception {
		return successResponseEntity(userService.retrieveUserGroupList(userId));
	}

	@Operation(summary = "유저 세션 언어코드 변경", description = "현재 로그인 된 유저 세션의 언어코드를 변경합니다.")
    @PostMapping("/user/session/lang-cd")
	public ResponseEntity<BaseResponse<Void>> setLangCd(@LoginUser UserSession userSession, @RequestBody LangCdRequest dto) throws Exception {

		userService.updateLangCd(userSession.getUserId(), dto.getLangCd());

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();

		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		userDetails.setLangCd(dto.getLangCd()); // 필드값 변경

		Authentication newAuth = new UsernamePasswordAuthenticationToken(
		    userDetails,
		    auth.getCredentials(),
		    auth.getAuthorities()
		);

		SecurityContextHolder.getContext().setAuthentication(newAuth);

		return successResponseEntity();
	}

	@Operation(summary = "유저 세션 타임존 변경", description = "현재 로그인 된 유저 세션의 타임존(TMZ_CD)을 변경합니다.")
    @PostMapping("/user/session/tmz-cd")
	public ResponseEntity<BaseResponse<Void>> setTmzCd(@LoginUser UserSession userSession, @RequestBody TmzCdRequest dto) throws Exception {

		userService.updateTmzCd(userSession.getUserId(), dto.getTmzCd());

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();

		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		userDetails.setTmzCd(dto.getTmzCd()); // 필드값 변경

		Authentication newAuth = new UsernamePasswordAuthenticationToken(
		    userDetails,
		    auth.getCredentials(),
		    auth.getAuthorities()
		);

		SecurityContextHolder.getContext().setAuthentication(newAuth);

		return successResponseEntity();
	}

	// Spring Security의 JsonLoginFilter가 요청을 가로채기 때문에 이 메서드는 실제 실행되지 않습니다.
	@Operation(summary = "로그인", description = "ID를 이용해 로그인을 진행합니다.")
    @PostMapping("/user/login")
    public void login(@RequestBody LoginRequest loginRequest) {}

	// Spring Security의 JsonLoginFilter가 요청을 가로채기 때문에 이 메서드는 실제 실행되지 않습니다.
	@Operation(summary = "로그아웃", description = "로그아웃을 진행합니다.")
    @PostMapping("/user/logout")
    public void logout() {}
}
