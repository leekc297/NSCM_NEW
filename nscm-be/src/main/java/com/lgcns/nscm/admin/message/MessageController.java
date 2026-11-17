package com.lgcns.nscm.admin.message;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.message.dto.MessageDto;
import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.AuthCheck;
import com.lgcns.nscm.framework.annotation.AuthCheck.Type;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 다국어 메시지 관련 Controller
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.admin.message
 * @FileName : MessageController.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : MessageController
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
@Tag(name = "3. 다국어 기능")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/message")
public class MessageController extends BaseController {

	private final MessageService messageService;

	/**
	 * @MethodName : retrieveMessage
	 * @Description: 다국어 메시지를 반환한다.
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : ResponseEntity<BaseResponse<List<MessageDto>>>
	 */
	public ResponseEntity<BaseResponse<List<MessageDto>>> retrieveMessage() throws Exception {
        return successResponseEntity(messageService.retrieveMessages());
    }

	/**
	 * @MethodName : retrieveMessage
	 * @Description: 언어별 다국어 메시지를 반환한다.
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param userSession
	 * @param      : @param langCd 요청 언어코드(FE i18next 가 로드할 언어 버킷). 비어 있으면 세션 langCd 로 폴백.
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : ResponseEntity<BaseResponse<List<MessageDto>>>
	 */
	@Operation(summary = "다국어 메시지 조회", description = "요청 langCd(없으면 세션 langCd)에 따른 다국어 메시지를 조회합니다.")
	@AuthCheck(Type.NONE)
	@GetMapping(value="", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<MessageDto>>> retrieveMessage(
            @LoginUser UserSession userSession,
            @RequestParam(value = "langCd", required = false) String langCd) throws Exception {
        // 요청 언어 우선 — i18next 가 채우는 언어 버킷과 응답 언어를 일치시킨다. 세션 langCd 로만 응답하면
        //   i18next 언어 버킷 캐시와 어긋나 "KOR 표시 + 다른 언어 메시지" desync 가 발생한다(공통 i18n 결함).
        //   파라미터가 없을 때만(로그인 전 등) 세션 langCd 로 폴백한다.
        String effectiveLangCd = StringUtils.hasText(langCd) ? langCd : userSession.getLangCd();
        log.info("retrieveMessage langCd(param)={}, session={}, effective={}", langCd, userSession.getLangCd(), effectiveLangCd);
        return successResponseEntity(messageService.retrieveMessages(effectiveLangCd));
    }

}
