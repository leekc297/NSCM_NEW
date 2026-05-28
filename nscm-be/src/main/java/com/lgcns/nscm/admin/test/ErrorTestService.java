package com.lgcns.nscm.admin.test;

import java.util.List;
import java.util.Map;

import org.springframework.core.MethodParameter;
import org.springframework.http.HttpHeaders;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.servlet.NoHandlerFoundException;

import com.lgcns.nscm.admin.menu.dto.MenuSaveRequest;
import com.lgcns.nscm.framework.base.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ErrorTestService extends BaseService{

	public List<Map<String, Object>> badRequest() throws Exception {
		MenuSaveRequest target = new MenuSaveRequest();
	    BeanPropertyBindingResult bindingResult = new BeanPropertyBindingResult(target, "menuCreateRequest");

	    bindingResult.addError(new FieldError(
	            "MenuSaveRequest",
	            "mnuId",
	            "invalid mnuId",
	            false,
	            null,
	            null,
	            "유효하지 않은 메뉴ID입니다.")
	    );

	    MethodParameter parameter = new MethodParameter(
	            this.getClass().getDeclaredMethods()[0], -1);

	    throw new MethodArgumentNotValidException(parameter, bindingResult);
	}

	public List<Map<String, Object>> forbidden() throws Exception {
		throw new AccessDeniedException("인가 실패 - 요청한 리소스에 접근할 권한이 없음");
	}

	public List<Map<String, Object>> notFound() throws Exception {
		throw new NoHandlerFoundException(
			    "GET",
			    "/test",
			    new HttpHeaders()
			);
	}

	public List<Map<String, Object>> internalServerError() throws Exception {
		throw new NullPointerException("API 서버 내부 오류");
//		throw new QueryTimeoutException("API 서버 내부 오류");
//		throw new RuntimeException("API 서버 내부 오류");
	}

}
