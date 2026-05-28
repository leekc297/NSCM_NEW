package com.lgcns.nscm.framework.base;

import lombok.Getter;

/**
 * 시스템 열거형 상수 Class
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.base
 * @FileName : BaseEnum.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : BaseEnum
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
public class BaseEnum {
    public enum MessageStatus {
        ERROR,
        WARN,
        INFO,
        SUCCESS,
        POST
    }

    public enum ApplyPattern{
        SKIP,
        CHECK
    }

    public enum BrowserType {
        Gecko,
        MSIE,
        Firefox,
        Opera,
        Chrome
    }

    public enum MessageSourceType {
        FILE,
        DB,
        BOTH
    }

    public enum Method {
        GET,POST,PUT,DELETE,PATCH
    }

    @Getter
    public enum EncryptionAlgorithm {

        MD5("MD5"),
        SHA3256("SHA3-256"),
        SHA256("SHA-256");

        /**
         * 알고리즘 이름
         * -- GETTER --
         *  알고리즘 이름을 반환한다.

         */
        private final String algorithm;

        EncryptionAlgorithm(String algorithm) {
            this.algorithm = algorithm;
        }
    }
}
