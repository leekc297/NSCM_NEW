package com.lgcns.nscm.framework.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 시스템 로그용 어노테이션
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.annotation
 * @FileName : SystemLog.java
 * @author   : story55
 * @date     : 2026. 2. 12.
 * @description : SystemLog
 * <p><b>Usage Example:</b></p>
 * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
 * {@code
 * @SystemLog(Type.BUTTON)  >> 버튼클릭에 대한 로그를 남긴다.
 * </pre>
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 12.        story55       최초 생성
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Inherited
public @interface SystemLog {

	LogType value() default LogType.SYSTEM;

	enum LogType {
        LOGIN,
        LOGOUT,
        MENU,
        BUTTON,
        SYSTEM,
        LOOKUP,
        COMBO,
        EXCELUPLOAD
    }
}
