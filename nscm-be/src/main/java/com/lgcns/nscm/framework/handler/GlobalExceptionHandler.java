package com.lgcns.nscm.framework.handler;


import org.springframework.dao.QueryTimeoutException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;

import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.exception.BusinessException;
import com.lgcns.nscm.framework.exception.SqlException;
import com.lgcns.nscm.framework.exception.SystemException;
import com.lgcns.nscm.framework.model.ErrorResponse;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@SuppressWarnings({"rawtypes" })
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity badRequestException(Exception e) {
    	log.error("Error: {}", e.getMessage());
    	ErrorResponse error = ErrorResponse.builder()
    			.code(BaseConstants.SERVER_ERROR)
    			.message(BaseConstants.SERVER_ERROR_MSG)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity authenticationException(Exception e) {
    	log.error("Error: {}", e.getMessage());
    	ErrorResponse error = ErrorResponse.builder()
    			.code(BaseConstants.AUTHENTICATION_ERROR)
    			.message(BaseConstants.AUTHENTICATION_ERROR_MSG)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity forbiddenException(Exception e) {
    	log.error("Error: {}", e.getMessage());
    	ErrorResponse error = ErrorResponse.builder()
    			.code(BaseConstants.AUTHORIZATION_ERROR)
    			.message(BaseConstants.AUTHORIZATION_ERROR_MSG)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error);
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity notFoundException(Exception e) {
    	log.error("Error: {}", e.getMessage());
    	ErrorResponse error = ErrorResponse.builder()
    			.code(BaseConstants.SERVER_ERROR)
    			.message(BaseConstants.SERVER_ERROR_MSG)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler({NullPointerException.class, QueryTimeoutException.class, RuntimeException.class})
    public ResponseEntity internalServerErrorException(Exception e) {
    	log.error("Error: {}", e.getMessage());
    	ErrorResponse error = ErrorResponse.builder()
    			.code(BaseConstants.SERVER_ERROR)
    			.message(BaseConstants.SERVER_ERROR_MSG)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }


    @ExceptionHandler(SystemException.class)
    public ResponseEntity systemException(SystemException e) {
    	log.error("Error: {}", e.getMessage());
    	String code = BaseConstants.SYSTEM_ERROR;
    	String message = BaseConstants.SYSTEM_ERROR_MSG;
    	if(e.getCode() != null) code = e.getCode();
    	if(e.getMessage() != null) message = e.getMessage();
    	ErrorResponse error = ErrorResponse.builder()
    			.code(code)
    			.message(message)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity businessException(BusinessException e) {
    	log.error("Error: {}", e.getMessage());
    	String code = BaseConstants.BUSINESS_ERROR;
    	String message = BaseConstants.BUSINESS_ERROR_MSG;
    	if(e.getCode() != null) code = e.getCode();
    	if(e.getMessage() != null) message = e.getMessage();
    	ErrorResponse error = ErrorResponse.builder()
    			.code(code)
    			.message(message)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }

    @ExceptionHandler(SqlException.class)
    public ResponseEntity sqlException(SqlException e) {
    	log.error("Error: {}", e.getMessage());
    	String code = BaseConstants.SQL_ERROR;
    	String message = BaseConstants.SQL_ERROR_MSG;
//    	if(e.getSqlCode() != null) code = e.getSqlCode();
//    	if(e.getSqlMsg() != null) message = e.getSqlMsg();
    	ErrorResponse error = ErrorResponse.builder()
    			.code(code)
    			.message(message)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity defaultException(Exception e) {
    	log.error("Error: {}", e.getMessage());
    	ErrorResponse error = ErrorResponse.builder()
    			.code(BaseConstants.SERVER_ERROR)
    			.message(BaseConstants.SERVER_ERROR_MSG)
    			.result(null)
    			.build();

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
