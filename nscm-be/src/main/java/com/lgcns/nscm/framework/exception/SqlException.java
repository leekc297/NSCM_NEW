package com.lgcns.nscm.framework.exception;


import java.io.Serial;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;

import com.lgcns.nscm.framework.base.BaseConstants;

import lombok.Getter;

public class SqlException extends Exception {

    /** Serializable */
    @Serial
    private static final long serialVersionUID = 1092054755518990825L;

    @Getter
    private static String sqlCode;
    @Getter
    private static String sqlMsg;
    private Throwable cause;

    public SqlException() {
        super("DB수행중에 오류가 발생했습니다. 관리자에게 문의하세요");
    }

    public SqlException(String message) {
        super(message);
    }

    public SqlException(Exception rootCause) {
    	super(sqlMsg, rootCause);

        if(rootCause instanceof PersistenceException) {
			Throwable cause = rootCause.getCause();
			while (cause != null && !(cause instanceof java.sql.SQLException)) {
		        cause = cause.getCause();
		    }

			if(cause instanceof java.sql.SQLException sqlEx) {
				int errorCode = sqlEx.getErrorCode();
		        String errorMessage = sqlEx.getMessage();
		        this.sqlCode = String.valueOf(errorCode);
				this.sqlMsg = errorMessage;
				this.cause = cause;
			}
		}
    }

    public SqlException(String code, String message, Exception rootCause) {
    	super(message, rootCause);

        if(rootCause instanceof PersistenceException) {
			Throwable cause = rootCause.getCause();
			while (cause != null && !(cause instanceof java.sql.SQLException)) {
		        cause = cause.getCause();
		    }

			if(cause instanceof java.sql.SQLException sqlEx) {
				int errorCode = sqlEx.getErrorCode();
		        String errorMessage = sqlEx.getMessage();
		        this.sqlCode = String.valueOf(errorCode);
				this.sqlMsg = errorMessage;
				this.cause = cause;
			}
		}
    }

}
