package com.lgcns.nscm.framework.interceptor;

import java.time.LocalDateTime;

/**
 * 비동기 SQL 로그 큐에 담기는 불변 레코드.
 * 요청 스레드에서 값이 이미 확정(직렬화)된 상태로 생성되어, 워커 스레드가 그대로 INSERT 한다.
 * resultCount 가 음수면 로그 테이블에 NULL 로 저장한다.
 */
public record SqlLogRecord(
        String sqlId,
        String sqlType,
        String sqlText,
        int elapsedMs,
        LocalDateTime executeTime,
        String userId,
        String paramsJson,
        int resultCount,
        String exceptionMsg) {
}
