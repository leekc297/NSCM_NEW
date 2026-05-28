package com.lgcns.nscm.admin.message;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : ResponseEntity<BaseResponse<List<MessageDto>>>
	 */
	@Operation(summary = "다국어 메시지 조회", description = "언어코드에 따른 다국어 메시지를 조회합니다.")
	@AuthCheck(Type.NONE)
	@GetMapping(value="", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<MessageDto>>> retrieveMessage(@LoginUser UserSession userSession) throws Exception {
		log.info("userSession.LANG_CD : " + userSession.getLangCd());
        return successResponseEntity(messageService.retrieveMessages(userSession.getLangCd()));
    }

}
