package com.lgcns.nscm.framework.interceptor;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.AsyncHandlerInterceptor;

import com.github.f4b6a3.ulid.Ulid;
import com.github.f4b6a3.ulid.UlidCreator;
import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.dao.NCommonDAO;
import com.lgcns.nscm.framework.exception.SqlException;
import com.lgcns.nscm.framework.utils.NullUtils;
import com.lgcns.nscm.framework.utils.SecurityUtil;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

/**
 * 시스템 로그용 Interceptor
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.interceptor
 * @FileName : LogInterceptor.java
 * @author   : story55
 * @date     : 2026. 2. 12.
 * @description : LogInterceptor
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 12.        story55       최초 생성
 */
@Slf4j
@Component
public class LogInterceptor implements AsyncHandlerInterceptor {

	@Autowired
    protected NCommonDAO ncommondao;

	/**
	 * [E20261015-STREAMPROC] 비동기 응답(StreamingResponseBody — call-proc-stream) 대응.
	 * 비동기 요청은 1차 디스패치 끝에 afterCompletion 대신 afterConcurrentHandlingStarted 가 불리고, 전송이 끝난 뒤
	 * ASYNC 2차 디스패치에서 preHandle → afterCompletion 이 다시 돈다. 그대로 두면 2차 preHandle 이 MDC 를 초기화해
	 * typeCd(=BUTTON) 를 잃고 시스템 로그가 남지 않는다 → 1차 MDC 를 요청 속성에 보관했다가 2차에서 복원한다.
	 * 동기 요청(기존 전부)은 dispatcherType=REQUEST 라 동작 무변경.
	 */
	private static final String MDC_SNAPSHOT_ATTR = LogInterceptor.class.getName() + ".MDC_SNAPSHOT";

	@Override
	public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler) {
		Map<String, String> snapshot = MDC.getCopyOfContextMap();
		if(snapshot != null) request.setAttribute(MDC_SNAPSHOT_ATTR, snapshot);
		MDC.clear();
	}

	/**
	 * @MethodName : preHandle
	 * @Description: 로그 핸들링용 Interceptor(로그용 init 데이터 추가)
	 * @author     : story55
	 * @date       : 2026. 2. 12.
	 * @param      : @param request
	 * @param      : @param response
	 * @param      : @param handler
	 * @param      : @return
	 */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        // 비동기 2차 디스패치 — 1차에서 보관한 MDC 복원(afterConcurrentHandlingStarted 참조)
        if (request.getDispatcherType() == DispatcherType.ASYNC
                && request.getAttribute(MDC_SNAPSHOT_ATTR) instanceof Map<?, ?> snapshot) {
            Map<String, String> restored = new HashMap<>();
            snapshot.forEach((k, v) -> restored.put(String.valueOf(k), v == null ? null : String.valueOf(v)));
            MDC.setContextMap(restored);
            return true;
        }
        // ULID 기반 Trace ID 생성 (없을 경우에만 생성)
        String traceId = request.getHeader("x-request-id");
//        String traceId = request.getHeader("X-Request-ID");
        if (traceId == null) {
            traceId = UlidCreator.getUlid().toString();
        }
        UserSession userSession = SecurityUtil.getUserSession();
        String userId =  (userSession != null && userSession.getUserId() != null) ? userSession.getUserId() : "GUEST";

        // 헤더 및 요청 정보 저장
        MDC.put("traceId", traceId);
        MDC.put("userId", userId);
        MDC.put("typeCd", "");
        MDC.put("requestUrl", request.getRequestURI());
        MDC.put("clientIp", getClientIp(request));
        MDC.put("menuId", "");
        MDC.put("shtNm", "");
        MDC.put("buttonCd", "");
        MDC.put("exception", "");
        MDC.put("clientStTm", String.valueOf(Ulid.from(traceId).getTime()));
        MDC.put("serverStTm", String.valueOf(System.currentTimeMillis()));
        log.debug("traceId: "+traceId);

        return true;
    }

    /**
     * @MethodName : afterCompletion
     * @Description: 로그 핸들링용 Interceptor (로그 데이터 추가)
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param request
     * @param      : @param response
     * @param      : @param handler
     * @param      : @param ex
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {

        // system 로그를 DB에 저장로직 비동기이면서 에러 발생시에도 이셉션이 나오면 안됨
    	Map<String, Object> logParam = new HashMap<String, Object>();
    	logParam.put("traceId", MDC.get("traceId"));
    	logParam.put("userId", MDC.get("userId"));
    	logParam.put("typeCd", MDC.get("typeCd"));
    	logParam.put("params", MDC.get("params"));
    	logParam.put("requestUrl", MDC.get("requestUrl"));
    	logParam.put("clientIp", MDC.get("clientIp"));
    	logParam.put("menuId", MDC.get("menuId"));
    	logParam.put("shtNm", MDC.get("shtNm"));
    	logParam.put("buttonCd", MDC.get("buttonCd"));
    	if(NullUtils.isNone(ex)) logParam.put("exception", MDC.get("exception"));
    	else logParam.put("exception", MDC.get("exception")+"\n"+ex.getMessage());
    	logParam.put("clientStTm", cvtLongStrToDate(MDC.get("clientStTm")));
    	logParam.put("serverStTm", cvtLongStrToDate(MDC.get("serverStTm")));
    	logParam.put("sqlStTm", cvtLongStrToDate(MDC.get("sqlStTm")));
    	logParam.put("sqlEdTm", cvtLongStrToDate(MDC.get("sqlEdTm")));
    	logParam.put("serverEdTm", cvtLongToDate(System.currentTimeMillis()));
    	logParam.put("clientEdTm", cvtLongToDate(System.currentTimeMillis()));	// default 서버 종료시간입력 후 client에서 업데이트
    	// 요청 종료 시 반듯이 MDC 클리어 (스레드 풀 환경 필수)
    	MDC.clear();
    	log.debug("logParamMap: \n"+logParam);
    	if(!(NullUtils.isNone(logParam.get("traceId")) || logParam.get("typeCd").equals(""))) {
    		// 로그를 남기는 서비스에서 쿼리를 실행하지 않는 경우 쿼리 시간은 서버 시간과 동일하게 넣는다.
    		if(NullUtils.isNone(logParam.get("sqlStTm"))) logParam.put("sqlStTm", logParam.get("serverStTm"));
    		if(NullUtils.isNone(logParam.get("sqlEdTm"))) logParam.put("sqlEdTm", logParam.get("serverEdTm"));
    		insertSystemLog(logParam);
    	}


    }


    public String getClientIp(HttpServletRequest request) {
    	if(NullUtils.isNone(request)) return "unknown";
        String ip = request.getHeader("X-Forwarded-For");

        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP"); // 웹로직 등
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }

        // IPv6 루프백 주소인 경우 로컬 IPv4로 변환 (선택 사항)
        if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
            ip = "127.0.0.1";
        }

        // X-Forwarded-For의 경우 여러 IP가 콤마로 연결될 수 있음 (첫 번째가 실제 클라이언트)
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }

        return ip;
    }

    private Timestamp cvtLongStrToDate(String sMillis) {
    	if(sMillis == null) return null;
    	long millis = Long.parseLong(sMillis);
    	Timestamp date = new Timestamp(millis);
    	return date;
    }

    private Timestamp cvtLongToDate(long millis) {
    	Timestamp date = new Timestamp(millis);
    	return date;
    }

    @Async
    public void insertSystemLog(Map<String, Object> logParam) {
    	try {
    		ncommondao.insert(BaseConstants.MYBATIS_NAME_SPACE+"admin.log.insertSysLog", logParam);
    	} catch (Exception e) {
    		log.error("insertSystemLog Error: "+e.getMessage());
		}
    }

}
