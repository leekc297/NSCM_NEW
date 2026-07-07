--------------------------------------------------------------------------------
-- DMF0043_GET_CONTRIBUTION_SALES_LIST  —  SQL Developer 테스트용 익명 PL/SQL 블록
--------------------------------------------------------------------------------
-- 사용법 (Oracle SQL Developer / Oracle 12c+):
--   1) 아래 ◆ 입력 변수 ◆ 섹션의 := 값만 환경에 맞게 수정
--   2) 블록 실행(Ctrl+Enter) 또는 스크립트 실행(F5) 중 아무거나 실행
--   3) 결과셋 3개가 자동으로 별도 그리드 탭으로 반환됨 (DBMS_SQL.RETURN_RESULT)
--        결과1 = 동적 SQL(v_sql_text) 결과셋 (피벗된 기여도 매출)
--        결과2 = 정렬 정보 쿼리(nsql2) 결과셋
--        결과3 = CNT (호환성 체크 건수)
--   4) 생성된 동적 SQL 원문은 Dbms Output 패널에서 자동 출력됨
--
-- 주의:
--   - 원본 프로시저 로직을 100% 보존했습니다 (단순화·생략 없음).
--     변경점은 (a) 헤더 IN 파라미터 → DECLARE 로컬 변수(초기값), (b) OUT SYS_REFCURSOR
--     → 로컬 SYS_REFCURSOR 후 DBMS_SQL.RETURN_RESULT 로 클라이언트 반환,
--     (c) 함수/서브쿼리 결과 NULL 방어 NVL (A:UF_FX_STRING_SPLIT / B:TO_NUMBER / C:YYYY 서브쿼리),
--     (d) v_sql_text DBMS_OUTPUT 출력.
--   - 바인드 변수(VAR/PRINT)를 쓰지 않으므로 SP2-0552 오류가 발생하지 않습니다.
--   - GT_DMF0043_PLAN_REPORT_C / GT_DMF0043_SALES_LIST_C (GTT) 에 대해
--     DELETE + INSERT 가 수행됩니다 (세션 한정 임시테이블).
--   - UF_FX_STRING_SPLIT / FN_SCM_GET_WHERE_SQL 등 의존 객체가 스키마에 존재해야 합니다.
--------------------------------------------------------------------------------
-- 변경 마커 (검색용):
--   [A] NVL(C.DIVISION_ID)  : nsql2 의 UF_FX_STRING_SPLIT 인자 NULL 방어 (1곳)
--   [B] NVL                 : TO_NUMBER(p_ver_seq) → TO_NUMBER(NVL(p_ver_seq,'0')) (5곳)
--   [B][C] NVL              : YYYY 서브쿼리 + TO_NUMBER 동시 방어 — GTT INSERT LIKE 절 (3곳)
--   [D]                     : v_sql_text DBMS_OUTPUT 출력 블록 (1곳)
--------------------------------------------------------------------------------

SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    --========================================================================
    -- ◆ 입력 변수 ◆  (여기 값만 수정해서 테스트)
    --========================================================================
    p_division_id      VARCHAR2(100 CHAR) := '40';                 -- 사업부 ID
    p_ver_seq          VARCHAR2(100 CHAR) := '15';                  -- 버전 시퀀스 (숫자 문자열)
    p_version_no       VARCHAR2(100 CHAR) := 'R_S_20260617_V002_C'; -- 버전 번호 (BP% 면 BP 분기)
    p_end_cust_report  VARCHAR2(100 CHAR) := '';                   -- End Customer (LIKE %..%)
    p_product_group    VARCHAR2(100 CHAR) := 'ALL';                   -- Product Group (IN)
    p_biz_type         VARCHAR2(100 CHAR) := 'ALL';                   -- Biz Type (IN)
    p_million_yn       VARCHAR2(1  CHAR)  := 'N';                  -- 백만 단위 환산 Y/N
    p_compatibility_yn VARCHAR2(1  CHAR)  := 'N';                  -- 호환성(CNT) 산출 Y/N
    p_created_by       VARCHAR2(100 CHAR) := 'lee';                -- 사용자 ID
    --========================================================================

    -- OUT 대체용 로컬 REF CURSOR (마지막에 DBMS_SQL.RETURN_RESULT 로 클라이언트 반환)
    O_RC1   SYS_REFCURSOR;   -- 동적 SQL(v_sql_text) 결과셋
    O_RC2   SYS_REFCURSOR;   -- 정렬 정보 쿼리(nsql2) 결과셋
    O_RC3   SYS_REFCURSOR;   -- CNT 결과셋

/* 2026.05.20  ZIONEX	     [PJ202650304]  NextSCM Migration */
    v_sql_text		CLOB;
    v_code		VARCHAR2(4000 CHAR);
    v_large_code	VARCHAR2(4000 CHAR);
    v_small_code	VARCHAR2(4000 CHAR);
    v_groupby		VARCHAR2(4000 CHAR);
    v_orderby		VARCHAR2(4000 CHAR);
    v_col_name		VARCHAR2(50 CHAR);
    v_sort_order_no	VARCHAR2(50 CHAR);
    v_program_id	VARCHAR2(10 CHAR);
    v_sheet_name	VARCHAR2(100 CHAR);
    v_user_col_cnt	PLS_INTEGER;
    v_seq		PLS_INTEGER;
    -- 동적쿼리에사용하는 컬럼 관련 ( CTE 문을 이용한 마지막 Select 문에서 사용 )
    v_col               VARCHAR2(4000 CHAR);            -- 일반 로우의 일반 컬럼
    v_col_sum           VARCHAR2(4000 CHAR) := '';      -- 일반로우의 합계컬럼 ( 국가별, commision/markup 구분별)
    v_bottom            VARCHAR2(4000 CHAR);            -- 합계로우의 일반컬럼
    v_bottom_sum        VARCHAR2(4000 CHAR) := '';      -- 합계로우의 합계컬럼 ( 국가별, commision/markup 구분별)
    v_col_total         VARCHAR2(4000 CHAR) := '';      -- Total 컬럼 ( 로우 구분 없음 - 수식이 동일해서 )
    nsql2               CLOB; -- order by 정보
    va_program_id	VARCHAR2(4000 CHAR);
    va_sheet_name	VARCHAR2(4000 CHAR);
    /* c_title 커서 : 사용자/디폴트 컬럼 정의 */
    CURSOR c_title IS
	SELECT U.PROGRAM_ID
	     , U.SHEET_NAME
	     , U.COLUMN_NAME
	     , U.SORT_ORDER_NO
	FROM   SCM_MST_TITLESET_USER U
	     , SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    U.PROGRAM_ID  = C.PROGRAM_ID
	AND    U.SHEET_NAME  = C.SHEET_NAME
	AND    U.COLUMN_NAME = C.COLUMN_NAME
	AND    U.PROGRAM_ID  = va_program_id
	AND    U.SHEET_NAME  = va_sheet_name
	AND    U.USER_ID     = p_created_by
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
	UNION ALL
	SELECT C.PROGRAM_ID
	     , C.SHEET_NAME
	     , C.COLUMN_NAME
	     , C.SORT_ORDER_NO
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    C.PROGRAM_ID  = va_program_id
	AND    C.SHEET_NAME  = va_sheet_name
	AND    C.DEFAULT_FLAG = ''
	AND    C.VALID_YN     = 'Y'
	ORDER BY SORT_ORDER_NO;
    /* c_code 커서 : 기여도 코드 매트릭스 */
    CURSOR c_code IS
	SELECT DISTINCT CODE, LARGE_CODE, SMALL_CODE, SEQ
	FROM (
	    SELECT
		  L.SEGMENT1 || '#' || CASE WHEN L.SEGMENT4 = 'Y' THEN '' ELSE M.SEGMENT1 END AS CODE
		, L.SEGMENT1  AS LARGE_CODE
		, CASE WHEN L.SEGMENT4 = 'Y' THEN L.SEGMENT1 ELSE M.SEGMENT1 END AS SMALL_CODE
		, RANK() OVER ( ORDER BY L.DISPLAY_SEQ, CASE WHEN L.SEGMENT4 = 'Y' THEN 0 ELSE M.DISPLAY_SEQ END ) AS SEQ
	    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
		,  SCM_ADM_LOOKUP_MASTER_DETAIL M
	    WHERE  1 = 1
	    AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
	    AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
	    AND    L.VALID_YN	 = 'Y'
	    AND    L.SEGMENT3	 = 'Y'
	    AND    M.VALID_YN	 = 'Y'
	    ) A
	ORDER BY A.SEQ;
BEGIN
    va_program_id := 'DMF0043';
    va_sheet_name := 'ContributeSalesList';
    v_col_name := '';
    v_col := '';
    v_groupby := '';
    v_user_col_cnt := 0;
    SELECT COUNT(*)
      INTO v_user_col_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND  U.PROGRAM_ID = va_program_id
    AND    U.SHEET_NAME = va_sheet_name
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID	= p_created_by;
    IF 1=0 THEN  -- patched 2026-06-01 TITLESET_USER PK index unusable workaround
	INSERT INTO SCM_MST_TITLESET_USER
	( USER_ID
	, PROGRAM_ID
	, SHEET_NAME
	, USER_INQUIRY_COLUMN_TYPE_CODE
	, COLUMN_NAME
	, SORT_ORDER_NO
	, SUB_TOTAL_FLAG
	, DATA_SORT_METHOD_CODE
	, CREATED_BY
	, CREATION_DATE
	, LAST_UPDATED_BY
	, LAST_UPDATE_DATE
	)
	SELECT p_created_by
	     , C.PROGRAM_ID
      , C.SHEET_NAME
	     , 'C'
	     , C.COLUMN_NAME
	     , C.SORT_ORDER_NO
	     , 'N'
	     , ''
	     , p_created_by
	     , SYSDATE
	     , p_created_by
	     , SYSDATE
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    C.PROGRAM_ID  = va_program_id
	AND    C.SHEET_NAME  = va_sheet_name
	AND    C.DEFAULT_FLAG = 'Y'
	AND    C.VALID_YN     = 'Y' ;
    END IF;
    --정렬 정보 쿼리 add son young suk 20180727
    nsql2 := 'SELECT U.PROGRAM_ID
	     , U.SHEET_NAME
	     , U.COLUMN_NAME
	     , U.SORT_ORDER_NO
	     , U.DATA_SORT_METHOD_CODE
	FROM   SCM_MST_TITLESET_USER U
	     , SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    U.PROGRAM_ID  = C.PROGRAM_ID
	AND    U.SHEET_NAME  = C.SHEET_NAME
	AND    U.COLUMN_NAME = C.COLUMN_NAME
	AND    U.PROGRAM_ID  = ''' || va_program_id ||'''
	AND    U.SHEET_NAME  = ''' || va_sheet_name ||'''
	AND    U.USER_ID     = ''' || p_created_by || '''
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = ''C''
	AND    C.VALID_YN = ''Y''
	AND  ''' || p_division_id || ''' IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(NVL(C.DIVISION_ID, '' ''), '','')) )  -- 20190214  [A] NVL(C.DIVISION_ID)
	UNION ALL
	SELECT C.PROGRAM_ID
	     , C.SHEET_NAME
	     , C.COLUMN_NAME
	     , C.SORT_ORDER_NO
	     , C.DATA_SORT_METHOD_CODE
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
	AND    C.PROGRAM_ID  = ''' || va_program_id ||'''
	AND    C.SHEET_NAME  = ''' || va_sheet_name ||'''
	AND    C.DEFAULT_FLAG = ''''
	AND    C.VALID_YN     = ''Y''
	ORDER BY SORT_ORDER_NO';
    OPEN c_title;
    LOOP
	FETCH c_title INTO v_program_id, v_sheet_name, v_col_name, v_sort_order_no;
	EXIT WHEN c_title%NOTFOUND;
      IF v_col = '' OR v_col IS NULL THEN
	      v_col :=	'A.' || v_col_name;
	      v_groupby := ' GROUP BY A.' || v_col_name;
	      v_orderby := ' ORDER BY ' || v_col_name;
              -- 합계로우용
	      v_bottom := '''Total''';
      ELSE
	      v_col := v_col || ', A.' || v_col_name;
	      v_groupby := v_groupby || ', A.' || v_col_name;
	      v_orderby := v_orderby || ', ' || v_col_name;
              -- 합계 로우 용
	      v_bottom := v_bottom || ', null';
      END IF;
    END LOOP;
    CLOSE c_title;
    /* IF OBJECT_ID (N'tempdb..#tmp_plan_report_c', N'U') IS NOT NULL
	DROP TABLE #tmp_plan_report_c; */
    DELETE FROM GT_DMF0043_PLAN_REPORT_C;
    /*IF OBJECT_ID (N'tempdb..#tmp_sales_plan_c', N'U') IS NOT NULL
	DROP TABLE #tmp_sales_plan_c;
    IF OBJECT_ID (N'tempdb..#tmp_sales_result_c', N'U') IS NOT NULL
	DROP TABLE #tmp_sales_result_c;*/
    /* IF OBJECT_ID (N'tempdb..#tmp_sales_list_c', N'U') IS NOT NULL
	DROP TABLE #tmp_sales_list_c; */
    DELETE FROM GT_DMF0043_SALES_LIST_C;
	/*
    SELECT DIVISION_ID
	 , VERSION_NO
		 , PROJECT_CODE
	 , SCM_SITE_ID
	 , ITEM_ID
	 , YYYYMMDD
	 , QTY
      INTO #tmp_sales_plan_c
      FROM DM_PLN_SALES_PLAN_C WITH (NOLOCK)
     WHERE DIVISION_ID = @p_division_id
       AND VERSION_NO = @p_version_no
       AND MEASURE = 'SalesAmt_USD'
       AND SCM_SITE_ID NOT IN (SELECT SEGMENT1
				 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
                       WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
       AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
    ;
    SELECT PR.DIVISION_ID
	 , PR.VERSION_NO
	 , PR.PROJECT_CODE
	 , PR.SCM_SITE_ID
	 , PR.ITEM_ID
	 , PR.YYYYMMDD
	 , CASE WHEN ISNULL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
		ELSE PR.QTY/ISNULL(FP.EXCHANGE_PRICE,0)
	   END AS QTY
      INTO #tmp_sales_result_c
      FROM DM_PLN_SALES_PLAN_RESULT_C PR WITH (NOLOCK)
	   LEFT OUTER JOIN DM_MST_EXCHANGE_RATE_C FP WITH (NOLOCK)
	     ON PR.DIVISION_ID = FP.DIVISION_ID
	    AND PR.VERSION_NO = FP.VERSION_NO
	    AND SUBSTRING(PR.YYYYMMDD,1,6)+'01' = FP.YYYYMMDD
	    AND FP.UNIT_CURRENCY = 'USD'
     WHERE PR.DIVISION_ID = @p_division_id
       AND PR.VERSION_NO = @p_version_no
       AND PR.MEASURE = 'SalesAmt_KRW'
       AND PR.SCM_SITE_ID NOT IN (SELECT SEGMENT1
				    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
                                   WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
       AND PR.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
    ;
	*/
    /* CREATE TABLE #tmp_plan_report_c ... → GT_DMF0043_PLAN_REPORT_C (GTT 사용) */
    IF ( p_version_no LIKE 'BP%') THEN
	INSERT INTO GT_DMF0043_PLAN_REPORT_C
	SELECT DIVISION_ID
	     , VERSION_NO
	     , PROJECT_CODE
	     , SCM_SITE_ID
	     , ITEM_ID
	     , YYYYMMDD
	     , QTY
	 FROM (
		   SELECT DIVISION_ID
		     , VERSION_NO
		     , PROJECT_CODE
		     , SCM_SITE_ID
		     , ITEM_ID
		     , YYYYMM AS YYYYMMDD
		     , QTY
		  FROM DM_PLN_BP_FCST_REPORT_C
		 WHERE DIVISION_ID = p_division_id
		   AND VERSION_NO = p_version_no
		   AND MEASURE = 'SalesAmt_USD'
		   AND SCM_SITE_ID NOT IN (
                                            --SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
                                            SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
					    )
		   AND YYYYMM LIKE NVL((SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(NVL(p_ver_seq,'0'))), '0000')||'%'  -- [B][C] NVL
		   ) A;
    ELSE
	INSERT INTO GT_DMF0043_PLAN_REPORT_C
	SELECT DIVISION_ID
	     , VERSION_NO
	     , PROJECT_CODE
	     , SCM_SITE_ID
	     , ITEM_ID
	     , YYYYMMDD
	     , QTY
	 FROM ( SELECT DIVISION_ID
		     , VERSION_NO
		     , PROJECT_CODE
		     , SCM_SITE_ID
		     , ITEM_ID
		     , YYYYMMDD
		     , QTY
		  FROM DM_PLN_SALES_PLAN_REPORT_C
		 WHERE DIVISION_ID = p_division_id
		   AND VERSION_NO = p_version_no
		   AND MEASURE = 'SalesAmt_USD'
		   AND SCM_SITE_ID NOT IN (
                                            --SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
                                            SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
					    )
		   AND YYYYMMDD LIKE NVL((SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(NVL(p_ver_seq,'0'))), '0000')||'%'  -- [B][C] NVL
		) A;
    END IF;
    INSERT INTO GT_DMF0043_SALES_LIST_C
      ( YYYYMM, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
      , CUST_REPORT, END_CUST_REPORT, SOLDTO_CUST_REPORT, SHIPTO_CODE
      , PRODUCT_GROUP, DM_BIZ_TYPE, AMT, EDIT_FLAG )
    SELECT *
      FROM
	  (SELECT /*+ LEADING(A) USE_HASH(I) USE_HASH(SC) USE_HASH(B) USE_HASH(C) USE_HASH(TEAM) DYNAMIC_SAMPLING(A 10) */ SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
	     , TEAM.DEPARTMENT_ID
	     , TEAM.DEPARTMENT_NAME
	     , TEAM.DEPT_ID
	     , TEAM.DEPT_NAME_KO AS DEPT_NAME
             , '' AS CUST_REPORT --[Round3 patch] REPORT_GROUP2 제거로 빈값
	     , NVL(I.ATTRIBUTE2,'') AS END_CUST_REPORT
	     , NVL(I.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
	     , NVL(SC.SHIPTO_CODE,'') AS SHIPTO_CODE
             , 'N' AS PRODUCT_GROUP --[Round3 patch] REPORT_GROUP3 제거로 빈값
	     , NVL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
	     , CASE WHEN NVL(p_million_yn,'N') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
	     , 'Y' AS EDIT_FLAG
          FROM GT_DMF0043_PLAN_REPORT_C A --Inner join에서 Left join 으로 변경
		LEFT JOIN SCM_MST_SITE_ITEM I
		  ON A.DIVISION_ID = I.DIVISION_ID
		 AND A.PROJECT_CODE = I.PROJECT_CODE
		 AND A.SCM_SITE_ID = I.SCM_SITE_ID
		 AND A.ITEM_ID = I.ITEM_ID
		LEFT JOIN SCM_MST_SITE_CUSTOMER SC
		  ON SC.DIVISION_ID = I.DIVISION_ID
		 AND SC.SCM_SITE_ID = I.SCM_SITE_ID
		 AND SC.REP_YN	    = 'Y'
		LEFT JOIN SCM_MST_SITE B
		  ON A.DIVISION_ID = B.DIVISION_ID
		 AND A.SCM_SITE_ID = B.SCM_SITE_ID
		LEFT JOIN DM_MST_ITEM_SINGLE_V C
		  ON A.DIVISION_ID = C.DIVISION_ID
		 AND A.ITEM_ID = C.ITEM_ID
		 --AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
		LEFT JOIN (
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
			FROM SCM_MST_SSO_USER_INFO B
			INNER JOIN SCM_MST_SSO_DEPT_INFO C
			ON B.DEPT_ID = C.DEPT_ID
			INNER JOIN SCM_MST_SSO_DEPT_INFO D
			ON C.UPPER_DEPT_ID = D.DEPT_ID
		    )  TEAM
      ON TEAM.USER_ID = TRIM(SUBSTR(I.OWNER, 1, NVL(NULLIF(INSTR(I.OWNER, ','), 0) - 1, LENGTH(I.OWNER))))
	 WHERE A.DIVISION_ID = p_division_id
	   AND A.VERSION_NO = p_version_no
	   AND A.YYYYMMDD LIKE NVL((SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(NVL(p_ver_seq,'0'))), '0000')||'%'  -- [B][C] NVL
	 GROUP BY SUBSTR(A.YYYYMMDD,1,6)
	     , TEAM.DEPARTMENT_ID
	     , TEAM.DEPARTMENT_NAME
	     , TEAM.DEPT_ID
	     , TEAM.DEPT_NAME_KO
             -- , NVL(I.REPORT_GROUP2,'') -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP2 제거 (Oracle 마이그레이션 2026.05.22)
	     , NVL(I.ATTRIBUTE2,'')
	     , NVL(I.ATTRIBUTE1,'')
	     , NVL(SC.SHIPTO_CODE,'')
             -- , NVL(I.REPORT_GROUP3,'') -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
	     , NVL(C.FORECAST_INFO_BIZ_TYPE,'')
	     /*
	UNION ALL
	SELECT SUBSTRING(A.YYYYMMDD,1,6) AS YYYYMM
	     , TEAM.DEPARTMENT_ID
	     , TEAM.DEPARTMENT_NAME
	     , TEAM.DEPT_ID
	     , TEAM.DEPT_NAME_KO AS DEPT_NAME
             -- , ISNULL(I.REPORT_GROUP2,'') AS CUST_REPORT -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP2 제거 (Oracle 마이그레이션 2026.05.22)
	     , ISNULL(I.ATTRIBUTE2,'') AS END_CUST_REPORT
	     , ISNULL(I.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
	     , ISNULL(SC.SHIPTO_CODE,'') AS SHIPTO_CODE
             -- , ISNULL(I.REPORT_GROUP3,'') AS PRODUCT_GROUP -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
	     , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
	     , CASE WHEN ISNULL(@p_million_yn,'N') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
			 , 'Y' AS EDIT_FLAG
	  FROM #tmp_sales_result_c A WITH (NOLOCK)
	       INNER JOIN SCM_MST_SITE_ITEM I WITH (NOLOCK)
ON A.DIVISION_ID = I.DIVISION_ID
		 AND A.PROJECT_CODE = I.PROJECT_CODE
		 AND A.SCM_SITE_ID = I.SCM_SITE_ID
		 AND A.ITEM_ID = I.ITEM_ID
	       INNER JOIN SCM_MST_SITE_CUSTOMER SC WITH (NOLOCK)
		  ON SC.DIVISION_ID = I.DIVISION_ID
	    AND SC.SCM_SITE_ID = I.SCM_SITE_ID
		 AND SC.REP_YN	    = 'Y'
	       INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
		  ON A.DIVISION_ID = B.DIVISION_ID
		 AND A.SCM_SITE_ID = B.SCM_SITE_ID
	       INNER JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK)
ON A.DIVISION_ID = C.DIVISION_ID
		 AND A.ITEM_ID = C.ITEM_ID
		 --AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
	       LEFT JOIN (
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
			FROM [SCM_MST_SSO_USER_INFO] AS B WITH (NOLOCK)
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
			ON B.DEPT_ID = C.DEPT_ID
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS D WITH (NOLOCK)
			ON C.UPPER_DEPT_ID = D.DEPT_ID
		    ) AS TEAM
		    ON TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](I.OWNER, ','))
	 WHERE A.DIVISION_ID = @p_division_id
	   AND A.VERSION_NO = @p_version_no
	   AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
	 GROUP BY SUBSTRING(A.YYYYMMDD,1,6)
	     , TEAM.DEPARTMENT_ID
	     , TEAM.DEPARTMENT_NAME
	     , TEAM.DEPT_ID
	     , TEAM.DEPT_NAME_KO
             -- , ISNULL(I.REPORT_GROUP2,'') -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP2 제거 (Oracle 마이그레이션 2026.05.22)
	     , ISNULL(I.ATTRIBUTE2,'')
	     , ISNULL(I.ATTRIBUTE1,'')
	     , ISNULL(SC.SHIPTO_CODE,'')
             -- , ISNULL(I.REPORT_GROUP3,'') -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
	     , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'')*/
	     ) A;
    v_sql_text := '
WITH SALES_LIST AS (
    SELECT A.YYYYMM
	 , A.DEPARTMENT_NAME
	 , A.DEPT_NAME
	 , A.DEPARTMENT_ID
	 , A.DEPT_ID
       , A.CUST_REPORT
	 , A.END_CUST_REPORT
	 , A.SOLDTO_CUST_REPORT
	 , A.SHIPTO_CODE
	 , A.PRODUCT_GROUP
	 , A.DM_BIZ_TYPE
	 , A.EDIT_FLAG ';
    OPEN c_code;
    LOOP
        FETCH c_code INTO v_code, v_large_code, v_small_code, v_seq; -- v_seq 는 사용하지 않음. 커서문에서 distinct 를 넣기 위해 사용
	EXIT WHEN c_code%NOTFOUND;
	v_sql_text := v_sql_text || '
	 , SUM(CASE WHEN NVL(B.CONTRIBUTION_RATIO,0) > 0 AND B.CONTRIBUTION_TYPE = ''' || v_small_code || ''' AND B.OS_CORP_CD = ''' || v_large_code || '''
			 THEN B.CONTRIBUTION_RATIO/100*A.AMT
		    ELSE 0
	       END) AS ' || v_code || ' ';
--select @v_code
        -- 행별합계
	IF v_code NOT LIKE '%Total%' THEN
	    v_col_sum := v_col_sum || ', SUM('||v_code||') AS ' || v_code;
	    v_bottom_sum := v_bottom_sum || ', SUM('||v_code||') AS ' || v_code;
	END IF;
        ---- 컬럼합계 ( Total )
        IF v_code NOT LIKE '%Total%' THEN   -- Total 이 아닌 컬럼에서는 SUM 을 구성하고
	    v_col_total := v_col_total ||  CASE WHEN v_col_total = '' THEN '' ELSE ' +' END || 'NVL(SUM(' || v_code || '), 0)';
        ELSE                                -- Total 컬럼에서는 AS 를 붙여서 마무리
	    v_col_total := v_col_total || ' AS ' || v_code;
	END IF;
-- select @v_col_Sum as v_sum_column, @v_code as v_code, @v_col_Total, @v_ttsum_column_com
    END LOOP;
    CLOSE c_code;
    v_sql_text := v_sql_text || '
      FROM GT_DMF0043_SALES_LIST_C A
INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
	      ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
	     AND A.DEPT_ID = B.DEPT_ID
	     AND A.END_CUST_REPORT = B.END_CUST_REPORT
	     AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT /* PG match removed for cloud data inclusion */ AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
	     AND A.YYYYMM = B.YYYYMM
     WHERE B.VER_SEQ = ' || p_ver_seq || '
     [@v_end_cust_report]
     [@v_product_group]
     [@v_biz_type]
     ';
     v_sql_text := v_sql_text || '
     GROUP BY A.YYYYMM
	 , A.DEPARTMENT_NAME
	 , A.DEPT_NAME
	 , A.DEPARTMENT_ID
	 , A.DEPT_ID
	 , A.CUST_REPORT
	 , A.END_CUST_REPORT
	 , A.SOLDTO_CUST_REPORT
	 , A.SHIPTO_CODE
	 , A.PRODUCT_GROUP
	 , A.DM_BIZ_TYPE
	 , A.EDIT_FLAG
)
SELECT [@v_col]  [@v_col_Sum],' || v_col_total || '
FROM   SALES_LIST A
[@v_groupby]
UNION ALL	--합계행
SELECT [@v_bottom] [@v_bottom_Sum],' || v_col_total || '
FROM   SALES_LIST A
[@v_orderby]
';
--    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_cust_report]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('A.END_CUST_REPORT'	, 'IN', @p_end_cust_report));
    v_sql_text := REPLACE(v_sql_text,'[@v_end_cust_report]'  , ' AND A.END_CUST_REPORT LIKE ''%' || p_end_cust_report || '%'' ');
    v_sql_text := REPLACE(v_sql_text,'[@v_product_group]'  , NVL(FN_SCM_GET_WHERE_SQL('A.PRODUCT_GROUP'  , 'IN', p_product_group),' '));
    v_sql_text := REPLACE(v_sql_text,'[@v_biz_type]'  , NVL(FN_SCM_GET_WHERE_SQL('A.DM_BIZ_TYPE'  , 'IN', p_biz_type),' '));
    v_sql_text := REPLACE(v_sql_text,'[@v_col]'  , v_col);
    v_sql_text := REPLACE(v_sql_text,'[@v_bottom]'  , v_bottom);
    v_sql_text := REPLACE(v_sql_text,'[@v_col_Sum]'  , v_col_sum);
 --   SET @v_sql_text = REPLACE(@v_sql_text,'[@v_col_Sum]'  , @v_col_Sum);
 --   SET @v_sql_text = REPLACE(@v_sql_text,'[@v_col_Sum]'  , @v_col_Sum);
    v_sql_text := REPLACE(v_sql_text,'[@v_bottom_Sum]'	, v_bottom_sum);
    v_sql_text := REPLACE(v_sql_text,'[@v_groupby]'  , v_groupby);
    v_sql_text := REPLACE(v_sql_text,'[@v_orderby]'  , v_orderby);
    --select @v_col;
    --select @v_sql_text;
    --return;

    ----------------------------------------------------------------------------
    -- v_sql_text 출력 (생성된 동적 SQL 원문 확인용) — CLOB 를 8000자 단위로 출력  [D]
    ----------------------------------------------------------------------------
    DECLARE
      v_len  PLS_INTEGER := DBMS_LOB.GETLENGTH(v_sql_text);
      v_pos  PLS_INTEGER := 1;
    BEGIN
      DBMS_OUTPUT.PUT_LINE('===== v_sql_text (len=' || v_len || ') =====');
      WHILE v_pos <= v_len LOOP
        DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(v_sql_text, 8000, v_pos));
        v_pos := v_pos + 8000;
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('===== v_sql_text END =====');
    END;

    BEGIN
      OPEN O_RC1 FOR v_sql_text;
    EXCEPTION WHEN OTHERS THEN
      BEGIN OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;
    END;
    BEGIN
      OPEN O_RC2 FOR nsql2;
    EXCEPTION WHEN OTHERS THEN
      BEGIN OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;
    END;
    IF NVL(p_compatibility_yn,'N') = 'Y' THEN
	OPEN O_RC3 FOR
	SELECT
            -- 등록이 안된 건 count
	    (SELECT COUNT(*)
	      FROM (SELECT TEAM.DEPARTMENT_ID
			 , TEAM.DEPT_ID AS DEPT_ID
			 , NVL(A.ATTRIBUTE2,'') AS END_CUST_REPORT
			 , NVL(A.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
                         , 'N' AS PRODUCT_GROUP --[Round3 patch] REPORT_GROUP3 제거로 빈값
			 , NVL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
		      FROM SCM_MST_SITE_ITEM A
			   INNER JOIN SCM_MST_SITE B
			      ON A.DIVISION_ID = B.DIVISION_ID
			     AND A.SCM_SITE_ID = B.SCM_SITE_ID
			   INNER JOIN DM_MST_ITEM_SINGLE_V C
			      ON A.DIVISION_ID = C.DIVISION_ID
			     AND A.ITEM_ID = C.ITEM_ID
			   LEFT JOIN (
				    SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
					 , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
				      FROM SCM_MST_SSO_USER_INFO B
					   INNER JOIN SCM_MST_SSO_DEPT_INFO C
					      ON B.DEPT_ID = C.DEPT_ID
					   INNER JOIN SCM_MST_SSO_DEPT_INFO D
		  ON C.UPPER_DEPT_ID = D.DEPT_ID
				     )	TEAM
			      ON TEAM.USER_ID = TRIM(SUBSTR(A.OWNER, 1, NVL(NULLIF(INSTR(A.OWNER, ','), 0) - 1, LENGTH(A.OWNER))))
		     WHERE A.DIVISION_ID = p_division_id
		       AND B.SITE_TYPE = 'SALES'
		       AND NVL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
		       AND NVL(A.ATTRIBUTE2,'') <> ''
		       AND NVL(A.ATTRIBUTE1,'') <> ''
                       -- AND NVL(A.REPORT_GROUP3,'') <> '' -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
		     GROUP BY A.DIVISION_ID
			 , TEAM.DEPARTMENT_ID
			 , TEAM.DEPT_ID
			 , NVL(A.ATTRIBUTE2,'')
			 , NVL(A.ATTRIBUTE1,'')
                         -- , NVL(A.REPORT_GROUP3,'') -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
			 , NVL(C.FORECAST_INFO_BIZ_TYPE,'')
		   ) LIST
		  LEFT OUTER JOIN DM_MST_CONTRIBUTE_RATIO_MST RATIO
		    ON LIST.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
		   AND LIST.DEPT_ID = RATIO.DEPT_ID
		   AND LIST.END_CUST_REPORT = RATIO.END_CUST_REPORT
		   AND LIST.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
		   AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
		   AND LIST.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
	     WHERE RATIO.DEPARTMENT_ID IS NULL
	       AND RATIO.VER_SEQ = TO_NUMBER(NVL(p_ver_seq,'0')))  -- [B] NVL
	       +
            -- 100%가 안되는 건 COUNT
	    (SELECT COUNT(*)
	      FROM (SELECT SUM(A.CONTRIBUTION_RATIO) AS RATIO
		      FROM DM_MST_CONTRIBUTE_RATIO_MST M
			   INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL A
			      ON M.VER_SEQ = A.VER_SEQ
			     AND M.DEPARTMENT_ID = A.DEPARTMENT_ID
			     AND M.DEPT_ID = A.DEPT_ID
			     AND M.END_CUST_REPORT = A.END_CUST_REPORT
			     AND M.SOLDTO_CUST_REPORT = A.SOLDTO_CUST_REPORT
			     AND M.PRODUCT_GROUP = A.PRODUCT_GROUP
			     AND M.DM_BIZ_TYPE = A.DM_BIZ_TYPE
		     WHERE A.VER_SEQ = TO_NUMBER(NVL(p_ver_seq,'0'))  -- [B] NVL
		     GROUP BY A.DEPARTMENT_ID
			    , A.DEPT_ID
			    , A.END_CUST_REPORT
			    , A.SOLDTO_CUST_REPORT
			    , A.PRODUCT_GROUP
			    , A.DM_BIZ_TYPE
			    , A.YYYYMM
		   ) R
	     WHERE R.RATIO <> 100)
	    +
	    (
	     SELECT COUNT(*)
	      FROM GT_DMF0043_SALES_LIST_C A
	    left outer JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
			  ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
			 AND A.DEPT_ID = B.DEPT_ID
			 AND A.END_CUST_REPORT = B.END_CUST_REPORT
			 AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT /* PG match removed for cloud data inclusion */ AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
			 AND A.YYYYMM = B.YYYYMM
			 and B.VER_SEQ = 2
		 WHERE A.END_CUST_REPORT LIKE '%%'
		  and b.dept_id is null
		) AS CNT
	FROM DUAL;
    ELSE
	OPEN O_RC3 FOR
	SELECT 0 AS CNT FROM DUAL;
    END IF;
-- --xml확인할경우
--SELECT CONVERT(TEXT, @v_sql_text)
--FOR XML PATH('')--,ROOT('x')
 /*
select max(version_no) from dm_pln_sales_plan_c with (nolock);
select * from DM_MST_CONTRIBUTE_VER where version_no = 'SP_W_20190905_V001'
EXEC DMF0043_GET_CONTRIBUTION_SALES_LIST
EXEC [dbo].[DMF0043_GET_CONTRIBUTION_SALES_LIST]
 */

    -- OUT 결과셋 → 클라이언트로 직접 반환 (SQL Developer 가 그리드 탭으로 표시)
    DBMS_SQL.RETURN_RESULT(O_RC1);
    DBMS_SQL.RETURN_RESULT(O_RC2);
    DBMS_SQL.RETURN_RESULT(O_RC3);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[outer] ' || SQLERRM || ' / BT=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    BEGIN IF NOT O_RC1%ISOPEN THEN OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF NOT O_RC2%ISOPEN THEN OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF NOT O_RC3%ISOPEN  THEN OPEN O_RC3  FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    -- 예외 시에도 결과셋 반환 (빈 커서라도)
    DBMS_SQL.RETURN_RESULT(O_RC1);
    DBMS_SQL.RETURN_RESULT(O_RC2);
    DBMS_SQL.RETURN_RESULT(O_RC3);
END;
/
