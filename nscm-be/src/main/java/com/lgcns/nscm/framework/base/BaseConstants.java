package com.lgcns.nscm.framework.base;

import java.util.Arrays;
import java.util.List;

/**
 * 시스템 상수 Class
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.base
 * @FileName : BaseConstants.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : BaseConstants
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
public class BaseConstants {
    public static final String DEFAULT_SESSION_KEY = "actor";
    public static final String MYBATIS_NAME_SPACE = "com.lgcns.nscm.";
    public static final String DEFAULT_DB_NAME = "defaltDB";
    public static final String DB_SESIONFACTORY_KEY = "dbId";
    public static final String DEFAULT_DATA_RESULT = "DATARESULT";

    public static final String DISPOSITION_FORMAT = "attachment;filename=%s;filename*=%s''%s";
    public static final String CONTENT_TYPE_FORMAT = "%s; charset=%s";

    public static final String XLS_MEDIA_TYPE = "application/vnd.ms-excel";
    public static final String XLSX_MEDIA_TYPE = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    public static final String STREAM_MEDIA_TYPE = "application/octet-stream";

    public static final String HTML_TAG_PATTERN = ".*<[^>@]{1,6}>.*";
    public static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("gif","jpeg","bmp","jpg","png","doc","hwp","xls","xlsx","xlsb","ppt","pptx","csv","txt","doc","pdf","docx");


    public static final short EXCEL_COLUMN_WIDTH_FACTOR = 170;
    public static final short EXCEL_ROW_HEIGHT_FACTOR = 20;
    public static final int UNIT_OFFSET_LENGTH = 7;
    public static final int[] UNIT_OFFSET_MAP = new int[] { 0, 36, 73, 109, 146, 182, 219 };

    public static final String SUCCESS = "0";
    public static final String SUCCESS_MSG = "success";

    public static final String SERVER_ERROR = "-9999";
    public static final String SERVER_ERROR_MSG = "Server Error";

    public static final String AUTHENTICATION_ERROR = "-9998";
    public static final String AUTHENTICATION_ERROR_MSG = "Authentication Error";

    public static final String AUTHORIZATION_ERROR = "-9997";
    public static final String AUTHORIZATION_ERROR_MSG = "No Permission";

    public static final String SYSTEM_ERROR = "-9996";
    public static final String SYSTEM_ERROR_MSG = "System Error";

    public static final String BUSINESS_ERROR = "-9995";
    public static final String BUSINESS_ERROR_MSG = "Business Error";

    /** 공유 게스트 계정 ID (미등록 사용자의 메뉴·권한 판정 기준). Oracle 대소문자 구분. */
    public static final String GUEST_USER_ID = "Guest";
    public static final String GUEST_GROUP_NM = "GUEST";

    public static final String SQL_ERROR = "-9994";
    public static final String SQL_ERROR_MSG = "Sql Error";

}
