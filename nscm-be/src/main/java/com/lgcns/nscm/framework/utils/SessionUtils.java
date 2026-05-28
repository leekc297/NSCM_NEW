package com.lgcns.nscm.framework.utils;


import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.exception.SystemException;

import jakarta.servlet.http.HttpSession;

public class SessionUtils {

    /*
     * Instance 생성 방지
     */
    private SessionUtils() {
        /* Do nothing **/
    }
    /**
     * 세션 정보에 user information 설정
     *
     * @param object Object 세팅하려는 user information 내용
     */
    public static void setSession(Object object) {
        setSession(BaseConstants.DEFAULT_SESSION_KEY, object);
    }

    /**
     * 세션 정보에 user information 설정
     *
     * @param key String attribute 이름
     * @param object Object attribute 내용
     */
    public static void setSession(String key, Object object) {

        if (RequestContextHolder.getRequestAttributes() != null && key != null && !key.isEmpty() && object != null) {
            RequestContextHolder.getRequestAttributes().setAttribute(key, object, RequestAttributes.SCOPE_SESSION);
        }
        else {
            throw new SystemException("RequestContextHolder is null or no session key and value, please check your configuration");
        }
    }

    /**
     * 현재 사용중인 Session ID를 반환하는 메소드
     *
     * @return String sessionId
     *
     */
    public static String getCurrentSessionId() {
        ServletRequestAttributes attributes = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
        return attributes.getRequest().getSession().getId();
    }

    /**
     * 현재 Session에 저장되어 있는 정보를 반환하는 메소드
     *
     * @return {@code T} user session
     */
    public static <T> T getCurrentSession(){
        return getCurrentSession(BaseConstants.DEFAULT_SESSION_KEY);
    }

    /**
     * 현재 Session 에 저장되어 있는 정보를 입력한 Key로 찾아 반환하는 메소드
     *
     * @param key String 반환하고자 하는 session data 의 이름
     * @param <T> 결과 클래스
     * @return T session data
     */
    @SuppressWarnings("unchecked")
    public static <T> T getCurrentSession(String key) {

        if (RequestContextHolder.getRequestAttributes() != null && key != null && !key.isEmpty()) {
            return (T) RequestContextHolder.getRequestAttributes().getAttribute(key, RequestAttributes.SCOPE_SESSION);
        }
        else {
            throw new SystemException("RequestContextHolder is null or no session key, please check your configuration");
        }
    }

    /**
     * 현재의 사용자의 Session정보를 삭제
     *
     */
    public static void removeSession()  {
        removeSession(BaseConstants.DEFAULT_SESSION_KEY);
    }

    /**
     *  현재의 사용자의 Session 정보를 삭제
     *
     * @param name String 삭제하려는 attribute 이름
     */
    public static void removeSession(String name) {

        if (RequestContextHolder.getRequestAttributes() != null&& name != null && !name.isEmpty()) {
            RequestContextHolder.getRequestAttributes().removeAttribute(name, RequestAttributes.SCOPE_SESSION);
        }
        else {
            throw new SystemException("RequestContextHolder is null or no session name");
        }
    }

    /**
     * 현재의 사용자의 Session 정보를 삭제함
     *
     */
    public static void invalidSession() {
        ServletRequestAttributes attributes = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
        HttpSession session =  attributes.getRequest().getSession();
        session.invalidate();
    }

    public static HttpSession getCustomCurrentSession() {
        ServletRequestAttributes attributes = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
        return attributes.getRequest().getSession();
    }
    public static HttpSession getCustomSession() {
        return (HttpSession) RequestContextHolder.getRequestAttributes();
    }

}
