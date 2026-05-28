package com.lgcns.nscm.framework.exception;


import java.io.PrintWriter;
import java.io.Serial;
import java.io.StringWriter;
import java.util.Locale;
import java.util.Map;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;

import lombok.Getter;

/**
 * BaseException을 만들어서 tracing 관련 로직을
 */
public class BaseException  extends RuntimeException {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 예외메시지
     */
    private final String message;

    /**
     * 예외메시지코드
     * -- GETTER --
     *  예외메시지코드 getter함수
     *

     */
    @Getter
    private final String code;

    /**
     *
     * -- GETTER --
     *

     */
    @Getter
    private final Exception rootCause;

    private Map<String,Object> params;


    /**
     * 기본 생성자
     */
    public BaseException() {
        this("");
    }

    /**
     * 생성자
     *
     * @param message String 예외메시지
     */
    public BaseException(String message) {
        this("", message);
    }

    /**
     *
     * @param message String
     * @param rootCause Exception
     */
    public BaseException(String message, Exception rootCause) {
        this("", message, rootCause, null);
    }

    /**
     * 생성자
     *
     * @param code    String 예외코드
     * @param message String 예외메시지
     */
    public BaseException(String code, String message) {
        this(code, message, null, null);
    }

    /**
     * 생성자
     *  @param code    String 예외코드
     * @param message String 예외메시지
     * @param rootCause   Exception 원인 Throwable
     */
    public BaseException(String code, String message, Exception rootCause) {
        this(code, message, rootCause, null);

    }

    /**
     * 생성자
     *  @param code    String 예외코드
     * @param message String 예외메시지
     * @param rootCause   Exception 원인 Throwable
     */
    public BaseException(String code, String message, Exception rootCause, Map<String,Object> params) {
        super(message, rootCause);
        this.message = message;
        this.code = code;
        this.rootCause = rootCause;
        this.params = params;
    }

    /**
     * 생성자, Exception 발생 시 메시지 내용도 함께 보관한다.
     *
     * @param messageSource MessageSource 예외메시지를 가져오는 MessageSource
     * @param code          String 예외메시지코드
     */
    public BaseException(MessageSource messageSource, String code) {
        this(messageSource, code, new Object[0]);
    }

    /**
     * 생성자, Exception 발생 시 메시지 내용은 구하지 않고 코드만 보관한다. 메세지 코드로 메세지를 찾는 것은 추후 필요한 시점에서
     * 처리해야 한다.
     *
     * @param messageSource MessageSource 예외메시지를 가져오는 MessageSource
     * @param code          String 예외메시지코드
     * @param rootCause Exception
     */
    public BaseException(MessageSource messageSource, String code, Exception rootCause) {
        this(messageSource, code, new Object[0], rootCause);
    }

    /**
     * 생성자, Exception 발생 시 메시지 내용은 구하지 않고 코드만 보관한다. 메세지 코드로 메세지를 찾는 것은 추후 필요한 시점에서
     * 처리해야 한다.
     *
     * @param messageSource MessageSource 예외메시지를 가져오는 MessageSource
     * @param code          String 예외메시지코드
     * @param messageParameters  Object[]   메시지를 구성하는 arguments
     */
    public BaseException(MessageSource messageSource, String code, Object[] messageParameters) {
        this(messageSource, code, messageParameters, LocaleContextHolder.getLocale());
    }

    /**
     *
     * @param messageSource:
     * @param code :
     * @param messageParameters :
     * @param locale :
     */
    public BaseException(MessageSource messageSource, String code, Object[] messageParameters, Locale locale) {
        this(messageSource, code, messageParameters, null, locale);
    }

    /**
     * 생성자, Exception 발생 시 메시지 내용은 구하지 않고 코드만 보관한다. 메세지 코드로 메세지를 찾는 것은 추후 필요한 시점에서
     * 처리해야 한다.
     *
     * @param messageSource MessageSource 예외메시지를 가져오는 MessageSource
     * @param code          String 예외메시지코드
     * @param messageParameters  Object[]   메시지를 구성하는 arguments
     * @param rootCause Exception
     */
    public BaseException(MessageSource messageSource, String code, Object[] messageParameters, Exception rootCause) {
        this(messageSource, code, messageParameters, rootCause, LocaleContextHolder.getLocale());
    }

    /**
     * 생성자, Exception 발생 시 메시지 내용은 구하지 않고 코드만 보관한다. 메세지 코드로 메세지를 찾는 것은 추후 필요한 시점에서
     * 처리해야 한다.
     *
     * @param messageSource MessageSource 예외메시지를 가져오는 MessageSource
     * @param code          String 예외메시지코드
     * @param messageParameters  Object[]   메시지를 구성하는 arguments
     * @param rootCause Exception
     * @param locale Locale
     */
    public BaseException(MessageSource messageSource, String code, Object[] messageParameters, Exception rootCause,
                         Locale locale) {
        super(messageSource != null ? messageSource.getMessage(code, messageParameters, locale) : "", rootCause);
        this.code = code;
        this.message = messageSource !=null ? messageSource.getMessage(code, messageParameters, locale) : code;
        this.rootCause = rootCause;
    }

    /**
     * 예외메시지 getter 함수
     *
     * @return 예외메시지
     * @see Throwable#getMessage()
     */
    @Override
    public String getMessage() {
        return this.message;
    }

    public Map<String, Object> getPrams(){return this.params;}

    /**
     *
     * @return String
     */
    public String getRootCauseMessage() {
        return rootCause != null ? rootCause.getMessage() : "";
    }


    /**
     * StackTraceString의 getter함수
     *
     * @return String
     */
    public String getStackTraceString() {
        StringWriter writer = new StringWriter();
        super.printStackTrace(new PrintWriter(writer));
        return writer.toString();
    }
}
