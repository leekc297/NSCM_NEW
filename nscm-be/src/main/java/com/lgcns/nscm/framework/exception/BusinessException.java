package com.lgcns.nscm.framework.exception;


import java.io.Serial;
import java.util.Map;

import org.springframework.context.MessageSource;

import com.lgcns.nscm.framework.base.BaseConstants;

public class BusinessException extends BaseException {

    /** Serializable */
    @Serial
    private static final long serialVersionUID = 1092054755518990825L;

    public BusinessException() {
        super("서비스 수행중 오류가 발생했습니다. 관리자에게 문의하세요");
    }

    public BusinessException(String message) {
        super(BaseConstants.BUSINESS_ERROR, message);
    }

    public BusinessException(String code, String message) {
        super(code, message);
    }

    public BusinessException(String code, String message, Exception rootCause) {
        super(code, message, rootCause);
    }

    public BusinessException(String code, String message, Exception rootCause, Map<String,Object> params) {
        super(code, message, rootCause, params);
    }

    public BusinessException(MessageSource messageSource, String code) {
        super(messageSource, code);
    }

    public BusinessException(MessageSource messageSource, String code, Exception rootCause) {
        super(messageSource, code, rootCause);
    }

    public BusinessException(MessageSource messageSource, String code, Object[] msgParams) {
        super(messageSource, code, msgParams);
    }

    public BusinessException(MessageSource messageSource, String code, Object[] msgParams, Exception rootCause) {
        super(messageSource, code, msgParams, rootCause);
    }

    @Override
    public String toString(){
        String s = getClass().getName();
        String message = super.getMessage();
        String code = super.getCode();
        return s + (message == null ? "" : ": " + message) + (code == null || code.isEmpty() ? " " : "(" + code + ")");
    }

    public String getStatusCode (){
        return  super.getCode();
    }

    public String getMessage (){
        return  super.getMessage();
    }

    public Map<String, Object> getParams (){
        return  super.getPrams();
    }
}
