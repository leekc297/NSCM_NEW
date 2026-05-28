package com.lgcns.nscm.framework.exception;


import java.io.Serial;
import java.util.Map;

import org.springframework.context.MessageSource;

public class SystemException extends BaseException {

    /** Serializable */
    @Serial
    private static final long serialVersionUID = 1092054755518990825L;

    public SystemException() {
        super("시스템 내부에서 오류가 발생했습니다. 관리자에게 문의하세요");
    }

    public SystemException(String message) {
        super(message);
    }

    public SystemException(String message, Exception rootCause) {
        super(message, rootCause);
    }

    public SystemException(String code, String message) {
        super(code, message);
    }

    public SystemException(String code, String message, Exception rootCause) {
        super(code, message, rootCause);
    }

    public SystemException(String code, String message, Exception rootCause, Map<String,Object> params) {
        super(code, message, rootCause, params);
    }


    public SystemException(MessageSource messageSource, String code) {
        super(messageSource, code);
    }

    public SystemException(MessageSource messageSource, String code, Exception rootCause) {
        super(messageSource, code, rootCause);
    }

    public SystemException(MessageSource messageSource, String code, Object[] msgParams) {
        super(messageSource, code, msgParams);
    }

    public SystemException(MessageSource messageSource, String code, Object[] msgParams, Exception rootCause) {
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
