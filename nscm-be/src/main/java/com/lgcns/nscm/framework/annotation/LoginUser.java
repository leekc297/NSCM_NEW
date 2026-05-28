package com.lgcns.nscm.framework.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;



/**
 * 컨트롤러 파라미터를 전달시 세션정보를 제공하는 어노테이션.
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.annotation
 * @FileName : LoginUser.java
 * @author   : story55
 * @date     : 2026. 2. 12.
 * @description : LoginUser
 * <p><b>Usage Example:</b></p>
 * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
 * {@code
 * @GetMapping("/messages")
 * public ResponseEntity<BaseResponse<List<MessageDto>>> retrieveMessage(@LoginUser UserSession userSession) throws Exception {
 * 	log.info("userSession.LANG_CD : " + userSession.getLangCd());
 * 	return successResponseEntity(messageService.retrieveMessages(userSession.getLangCd()));
 * }
 *
 * }
 * </pre>
 *
 */
@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
public @interface LoginUser {
}
