package com.lgcns.nscm.admin.user;

import java.sql.SQLException;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.user.dto.LangCdRequest;
import com.lgcns.nscm.admin.user.dto.LoginRequest;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.framework.security.CustomUserDetails;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@Tag(name = "0. 로그인 관리")
@RestController
@RequiredArgsConstructor
public class UserController extends BaseController {

	private final UserService userService;

	@Operation(summary = "유저 세션 확인", description = "현재 로그인 된 유저 세션 정보를 확인합니다.")
    @GetMapping("/user/session")
	public ResponseEntity<BaseResponse<UserSession>> getUserSession(@LoginUser UserSession userSession) throws SQLException {
		return successResponseEntity(userSession);
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

	// Spring Security의 JsonLoginFilter가 요청을 가로채기 때문에 이 메서드는 실제 실행되지 않습니다.
	@Operation(summary = "로그인", description = "ID를 이용해 로그인을 진행합니다.")
    @PostMapping("/user/login")
    public void login(@RequestBody LoginRequest loginRequest) {}

	// Spring Security의 JsonLoginFilter가 요청을 가로채기 때문에 이 메서드는 실제 실행되지 않습니다.
	@Operation(summary = "로그아웃", description = "로그아웃을 진행합니다.")
    @PostMapping("/user/logout")
    public void logout() {}
}
