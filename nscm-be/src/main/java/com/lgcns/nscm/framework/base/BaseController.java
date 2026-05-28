package com.lgcns.nscm.framework.base;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;

import com.lgcns.nscm.framework.model.BaseResponse;

import lombok.extern.slf4j.Slf4j;

/**
 * 시스템 기본 Entity Controller
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.base
 * @FileName : BaseController.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : BaseController
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
@Slf4j
@SuppressWarnings({"rawtypes" })
@ControllerAdvice
public class BaseController {

	protected ResponseEntity successResponseEntity(){
    	return ResponseEntity.ok().body(makeBaseResponse());
    }

    protected ResponseEntity successResponseEntity(String code){
    	return ResponseEntity.ok().body(makeBaseResponse(code));
    }

    protected ResponseEntity successResponseEntity(String code, String message){
    	return ResponseEntity.ok().body(makeBaseResponse(code, message));
    }

    protected <T> ResponseEntity<BaseResponse<T>> successResponseEntity(T result){
    	return ResponseEntity.ok().body(makeBaseResponse(result));
    }

    protected <T> ResponseEntity<BaseResponse<T>> successResponseEntity(T result, String code){
    	return ResponseEntity.ok().body(makeBaseResponse(result, code));
    }

    protected <T> ResponseEntity<BaseResponse<T>> successResponseEntity(T result, String code, String message){
        return ResponseEntity.ok().body(makeBaseResponse(result, code, message));
    }

    private BaseResponse makeBaseResponse(){
        return BaseResponse.builder()
                .code(BaseConstants.SUCCESS)
                .message(BaseConstants.SUCCESS_MSG)
                .result(null)
                .build();
    }

    private BaseResponse makeBaseResponse(String code){
        return BaseResponse.builder()
                .code(code)
                .message(BaseConstants.SUCCESS_MSG)
                .result(null)
                .build();
    }

    private BaseResponse makeBaseResponse(String code, String message){
        return BaseResponse.builder()
                .code(code)
                .message(message)
                .result(null)
                .build();
    }

    private <T> BaseResponse<T> makeBaseResponse(T result){
        return BaseResponse.<T>builder()
                .code(BaseConstants.SUCCESS)
                .message(BaseConstants.SUCCESS_MSG)
                .result(result)
                .build();
    }

    private <T> BaseResponse<T> makeBaseResponse(T result, String code){
        return BaseResponse.<T>builder()
                .code(code)
                .message(BaseConstants.SUCCESS_MSG)
                .result(result)
                .build();
    }

    private <T> BaseResponse<T> makeBaseResponse(T result, String code, String message){
        return BaseResponse.<T>builder()
                .code(code)
                .message(message)
                .result(result)
                .build();
    }

}
