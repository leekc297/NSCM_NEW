package com.lgcns.nscm.framework.aspect;

import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.f4b6a3.ulid.UlidCreator;
import com.lgcns.nscm.framework.annotation.SystemLog;
import com.lgcns.nscm.framework.interceptor.LogInterceptor;
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.framework.utils.NullUtils;
import com.lgcns.nscm.framework.utils.SecurityUtil;
import com.lgcns.nscm.framework.utils.StringUtils;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Aspect
@Component
public class SystemLogAspect {


	@Autowired
	protected LogInterceptor logInterceptor;

	private final ObjectMapper objectMapper = new ObjectMapper();

    @Around("execution(* com.lgcns..*NCommonDAO.*(..))")
    public Object sqlLog(ProceedingJoinPoint joinPoint) {

    	String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();
        long startTime = System.currentTimeMillis();
        String params = StringUtils.cutStringByBytes(toJson(joinPoint.getArgs()), 4000);
        boolean bLog = true;
/*
        if(joinPoint.getArgs().length > 0) {
        	String queryId = joinPoint.getArgs()[0].toString();
        	if(joinPoint.getArgs()[0].toString().contains("insertSysLog") || joinPoint.getArgs()[0].toString().contains("checkMenuBtnAuth")) {
        		bLog = false;
        		MDC.put("sqlStTm", null);
        	}
        }
*/
        // sql 시작시간
        if(!(MDC.get("typeCd") == null || MDC.get("typeCd").equals(""))) {
        	if(NullUtils.isNone(MDC.get("sqlStTm"))) MDC.put("sqlStTm", String.valueOf(startTime));
        	MDC.put("params", params);
        }

//        System.out.println("traceId: "+MDC.get("traceId")+"\n Type: "+MDC.get("typeCd")+"   "+MDC.get("sqlStTm"));
        if(bLog) log.info("START: {}.{}() | Params: {}", className, methodName, params);


        Object result = null;
        try {
            result = joinPoint.proceed();
            if(bLog) log.info("END: {}.{}() | Result: {} | Time: {}ms",
                     className, methodName, summarizeResult(result), (System.currentTimeMillis() - startTime));

            return result;
        } catch (Throwable throwable) {
            log.error("EXCEPTION: {}.{}() | Message: {}", className, methodName, throwable.getMessage());
            result = throwable;
            MDC.put("exception", className+"."+methodName+": "+throwable.getMessage());
        } finally {
        	// sql 종료시간
        	MDC.put("sqlEdTm", String.valueOf(System.currentTimeMillis()));
        	MDC.put("serverEdTm", String.valueOf(System.currentTimeMillis()));
		}
        return result;
    }

    @Around("!execution(* com.lgcns..*NCommonDAO.*(..)) && (@annotation(com.lgcns.nscm.framework.annotation.SystemLog) || @within(com.lgcns.nscm.framework.annotation.SystemLog))")
    public Object systemLog(ProceedingJoinPoint joinPoint) throws Throwable {
    	String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();
        long startTime = System.currentTimeMillis();
        Map<String, Object> logParam = new HashMap<String, Object>(); // login, logout 용 map


        String params = StringUtils.cutStringByBytes(toJson(joinPoint.getArgs()), 4000);
        String annoType = getAnnoType(joinPoint);

        MDC.put("typeCd", annoType);
        MDC.put("params", params);
    	if(annoType.equals("BUTTON")) {
    		if(className != null && className.equals("GeneralController")) {
    	        Object[] obj = joinPoint.getArgs();
    	        if(obj != null && obj[2] != null && obj[3] != null && obj[4] != null ) {
    	        	MDC.put("menuId", obj[2].toString());
    	        	MDC.put("shtNm", obj[3].toString());
	        		MDC.put("buttonCd", obj[4].toString());
    	        }
            }
    	}
    	if(annoType.equals("EXCELUPLOAD")) {
    		if(className != null && className.equals("FileController")) {
    	        Object[] obj = joinPoint.getArgs();
    	        if(obj != null && obj[0] != null && obj[1] != null && obj[2] != null ) {
    	        	MDC.put("menuId", obj[0].toString());
    	        	MDC.put("shtNm", obj[1].toString());
	        		MDC.put("buttonCd", obj[2].toString());
    	        }
            }
    	}
    	if(annoType.equals("LOGIN") || annoType.equals("LOGOUT")) {

            String traceId = UlidCreator.getUlid().toString();
            Object[] args = joinPoint.getArgs();
            Authentication authentication = null;
            HttpServletRequest httpReq = null;
            int argCnt = 0;
            for (Object arg : args) {
            	if (arg instanceof HttpServletRequest) {httpReq = (HttpServletRequest) arg; argCnt++;}
                if (arg instanceof Authentication) {authentication = (Authentication) arg; argCnt++;}
                if(argCnt==2) break;
            }

            logParam.put("traceId", traceId);
            logParam.put("userId", SecurityUtil.getUserSession(authentication).getUserId());
            logParam.put("typeCd", annoType);
            logParam.put("requestUrl", annoType);
            logParam.put("clientIp", logInterceptor.getClientIp(httpReq));
            logParam.put("menuId", annoType);
            logParam.put("buttonCd", annoType);
            logParam.put("clientStTm", cvtLongToDate(startTime));
            logParam.put("serverStTm", cvtLongToDate(startTime));
            logParam.put("sqlStTm", cvtLongToDate(startTime));
    	}

        log.info("START: {}.{}() | Params: {}", className, methodName, params);
        Object result;
        try {

            result = joinPoint.proceed();
            log.info("END: {}.{}() | Result: {} | Time: {}ms",
                     className, methodName, summarizeResult(result), (System.currentTimeMillis() - startTime));

            return result;
        } catch (Throwable throwable) {
            log.error("EXCEPTION: {}.{}() | Message: {}", className, methodName, throwable.getMessage());
            result = joinPoint.proceed();
            if(annoType.equals("LOGIN") || annoType.equals("LOGOUT")) {
            	logParam.put("exception", className+"."+methodName+": "+throwable.getMessage());
            } else {
            	if(NullUtils.isNone(MDC.get("exception"))) MDC.put("exception", className+"."+methodName+": "+throwable.getMessage());
            	else MDC.put("exception", MDC.get("exception") +"\n"+ className+"."+methodName+": "+throwable.getMessage());
            }
        } finally {

        	if(annoType.equals("LOGIN") || annoType.equals("LOGOUT")) {
        		logParam.put("sqlEdTm", cvtLongToDate(startTime));
        		logParam.put("serverEdTm", cvtLongToDate(System.currentTimeMillis()));
        		logParam.put("clientEdTm", cvtLongToDate(System.currentTimeMillis()));
                logInterceptor.insertSystemLog(logParam);
        	}
		}
		return result;
    }



    private String toJson(Object obj) {
        if (obj == null) return "";
        try {
            return objectMapper.writeValueAsString(obj);
        } catch (JsonProcessingException e) {
//            log.warn("SystemLogAspect.toJson JSON 변환 실패: {}", e.getMessage());
            return "";
        }
    }

    /**
     * [E20261015-LOGRESULT] 결과 로그 요약.
     * 기존에는 응답 전체를 JSON 으로 한 번 더 직렬화해 INFO 한 줄로 기록했다 — 대량 조회(SCP0030 289,551행 x 37컬럼)는
     * 응답과 같은 234MB 를 다시 만들고 로그에 써서 BE 시간·메모리를 크게 잡아먹었다.
     * 이제 구조만 남긴다: 목록은 건수, Map 은 키별 요약, 나머지(작은 값)는 JSON 앞부분 RESULT_LOG_MAX_LEN 자.
     */
    private static final int RESULT_LOG_MAX_LEN = 1000;

    private String summarizeResult(Object obj) {
        if (obj == null) return "";
        Object target = obj;
        if (target instanceof ResponseEntity<?> re) target = re.getBody();
        if (target instanceof BaseResponse<?> br) {
            return "{code=" + br.getCode() + ", message=" + br.getMessage() + ", result=" + summarizeValue(br.getResult(), 0) + "}";
        }
        return summarizeValue(target, 0);
    }

    private String summarizeValue(Object v, int depth) {
        if (v == null) return "null";
        if (v instanceof Collection<?> c) return "[" + c.size() + " rows]";
        if (v instanceof Map<?, ?> m) {
            if (depth >= 1) return "{" + m.size() + " keys}";
            StringBuilder sb = new StringBuilder("{");
            int i = 0;
            for (Map.Entry<?, ?> e : m.entrySet()) {
                if (i++ > 0) sb.append(", ");
                if (i > 20) { sb.append("..."); break; }
                sb.append(e.getKey()).append('=').append(summarizeValue(e.getValue(), depth + 1));
            }
            return sb.append('}').toString();
        }
        String json = toJson(v);
        return json.length() > RESULT_LOG_MAX_LEN ? json.substring(0, RESULT_LOG_MAX_LEN) + "...(" + json.length() + " chars)" : json;
    }

    private String getAnnoType(ProceedingJoinPoint joinPoint) {

	    MethodSignature signature = (MethodSignature) joinPoint.getSignature();
	    Method method = signature.getMethod();

	    //AnnotationUtils를 사용해 메서드 -> 클래스 순으로 어노테이션 탐색
	    SystemLog systemLog = AnnotationUtils.findAnnotation(method, SystemLog.class);

	    if (systemLog == null) {
	        systemLog = AnnotationUtils.findAnnotation(joinPoint.getTarget().getClass(), SystemLog.class);
	    }

	    return systemLog.value().toString();
    }

    private Timestamp cvtLongToDate(long millis) {
    	Timestamp date = new Timestamp(millis);
    	return date;
    }

}
