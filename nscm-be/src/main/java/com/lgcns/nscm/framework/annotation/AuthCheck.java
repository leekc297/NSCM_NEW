package com.lgcns.nscm.framework.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 권한체크용 어노테이션
 *
 * @Project     : nscm
 * @Package     : com.lgcns.nscm.framework.annotation
 * @FileName    : AuthCheck.java
 * @author      : story55
 * @date        : 2026. 2. 12.
 * @description : 권한 체크 범위를 지정하기 위한 어노테이션
 *
 * <p><b>Usage Example:</b></p>
 * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
 * &#64;AuthCheck(Type.LOGIN)
 * // NONE  : 세션체크 및 권한 미확인
 * // LOGIN : 세션체크만 확인 (Default)
 * // ALL   : 세션체크와 권한까지 확인
 * </pre>
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface AuthCheck {
	Type value() default Type.LOGIN;

    enum Type {
    	NONE,   // 세션체크 및 권한 미확인
 	    LOGIN,  // 세션체크만 확인 (어노테이션 default)
 	    ALL     // 세션체크와 권한까지 확인
    }
}
