-- SOURCE-FRESH: SCM_MGR.PKG_NSCM_UI_EXCEL PACKAGE BODY LAST_DDL=2026-09-14 10:00:06 FETCHED=2026-09-15 16:33 DB=ZIOUI1
-- PKG_NSCM_UI_EXCEL PACKAGE BODY — ② 임시적재 / ④ 결과조회 (공용 — 전 화면 Excel Upload)
-- 원천: 사내 ZIOUI1 SCM_MGR 현재 원문 (LAST_DDL 2026-09-14 10:00:06, VALID) · 수정 마커 1종
SET DEFINE OFF
SET SQLBLANKLINES ON
CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_NSCM_UI_EXCEL

AS
	
	PROCEDURE PR_SAVE_EXCEL_UPLOAD
	(
	    P_EXCEL_DATA		IN		CLOB,
	    P_COL_CNT			IN		NUMBER,
	    P_MNU_ID			IN 		VARCHAR2,
	    P_SHT_NM			IN 		VARCHAR2,
	    P_USER_ID      		IN		VARCHAR2,
	    
	    O_RESULT_CURSOR		OUT		SYS_REFCURSOR
	) IS
		V_ROW_CNT		NUMBER := 0;
		V_ERR_MSG 		VARCHAR2(4000);
	
		V_INS_SQL		CLOB;
    	V_SEL_SQL		CLOB;
		V_SQL			CLOB;
    	V_COL_DEFS		CLOB := ''; 
    	V_ATTR_LIST		CLOB := '';
    	V_VAL_LIST		CLOB := '';
    	V_SYSDATE		VARCHAR2(20);
	BEGIN
		
		V_SYSDATE := TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');
		
		FOR i IN 1..NVL(P_COL_CNT, 0) LOOP
	        -- JSON_TABLE용 정의
	        V_COL_DEFS := V_COL_DEFS || ' ATTRIBUTE' || i || ' VARCHAR2(4000) PATH ''$._COL' || i || ''',';
	        -- INSERT용 컬럼명 리스트 (예: ATTRIBUTE1, ATTRIBUTE2...)
	        V_ATTR_LIST := V_ATTR_LIST || 'ATTRIBUTE' || i || ', ';
	        -- INSERT용 값 리스트 (예: TMP.ATTRIBUTE1, TMP.ATTRIBUTE2...)
	        V_VAL_LIST  := V_VAL_LIST || 'TMP.ATTRIBUTE' || i || ', ';
	    END LOOP;
	
	    V_COL_DEFS  := RTRIM(V_COL_DEFS, ',');
	    V_ATTR_LIST := RTRIM(V_ATTR_LIST, ', ');
	    V_VAL_LIST  := RTRIM(V_VAL_LIST, ', ');
	
	   
	  	V_INS_SQL := 'INSERT INTO SCM_ADM_EXCEL_UPLOAD ( ' ||
                  'UPLOAD_ID, PROGRAM_ID, SHEET_NAME, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, UPLOAD_STATUS_CODE, ' || V_ATTR_LIST || ' ) ';
	   
	    -- 2. 전체 쿼리 조립
	    V_SEL_SQL := 'SELECT SCM_MGR.SEQ1_SCM_ADM_EXCEL_UPLOAD.NEXTVAL, ' || 
	             '  ''' || P_MNU_ID || ''' AS PROGRAM_ID, ' ||
	             '  ''' || P_SHT_NM || ''' AS SHEET_NAME, ' ||
	             '  ''' || P_USER_ID || ''' AS CREATED_BY, ' ||
	             '  TO_DATE(''' || V_SYSDATE || ''', ''YYYY-MM-DD HH24:MI:SS'') AS CREATION_DATE, ' ||
	             '  ''' || P_USER_ID || ''' AS LAST_UPDATED_BY, ' ||
	             '  TO_DATE(''' || V_SYSDATE || ''', ''YYYY-MM-DD HH24:MI:SS'') AS LAST_UPDATE_DATE, ' ||
	             '  TMP.UPLOAD_STAT, ' ||
	             '  ' || V_VAL_LIST || ' ' ||
	             'FROM JSON_TABLE(:json, ''$[*]'' ' ||
                  '  COLUMNS ( ' ||
                  '    ROW_IDX FOR ORDINALITY, ' ||
                  '    UPLOAD_STAT VARCHAR2(20) PATH ''$.UPLOAD_STAT'', ' || V_COL_DEFS || '  )) TMP ';
	
	    V_SQL := V_INS_SQL || V_SEL_SQL;
		DBMS_OUTPUT.PUT_LINE(V_SQL);	
		
		EXECUTE IMMEDIATE V_SQL USING P_EXCEL_DATA;
		V_ROW_CNT := SQL%ROWCOUNT;
				
	    -- 검증용 select
--	    OPEN O_RESULT_CURSOR FOR V_SEL_SQL USING P_EXCEL_DATA;
	   
		OPEN O_RESULT_CURSOR FOR
			SELECT '0' CODE, 'SUSSESS' MSG, V_ROW_CNT EVENT FROM DUAL;
		
	
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
			V_ERR_MSG := SQLERRM;
			RAISE_APPLICATION_ERROR(-20001, V_ERR_MSG);
			RAISE;
			
	END;



	PROCEDURE PR_GET_EXCEL_UPLOAD_RESULT
	(
		P_COL_CNT			IN		NUMBER,
	    P_MNU_ID			IN 		VARCHAR2,
	    P_SHT_NM			IN 		VARCHAR2,
	    P_USER_ID      		IN		VARCHAR2,
	     
	    O_RESULT_COUNT		OUT		SYS_REFCURSOR,
	    O_RESULT_LIST		OUT		SYS_REFCURSOR,
	    O_RESULT_CURSOR		OUT		SYS_REFCURSOR
	) IS
		V_ROW_CNT		NUMBER := 0;
		V_ERR_MSG 		VARCHAR2(4000);
	
    	V_SQL			CLOB; 
    	V_ATTR_LIST		CLOB := '';
    	V_SYSDATE		VARCHAR2(20);
	BEGIN
		
		--1. 결과 count 
		OPEN O_RESULT_COUNT FOR 
		SELECT  'Success'                                                               AS SUCCESS_TITLE
			  , COUNT(CASE WHEN T.UPLOAD_STATUS_CODE = 'SUCCESS' THEN T.PROGRAM_ID END) AS SUCCESS_COUNT
	          , 'Error'                                                                 AS ERROR_TITLE
			  , COUNT(CASE WHEN T.UPLOAD_STATUS_CODE = 'ERROR' THEN T.PROGRAM_ID END)   AS ERROR_COUNT
	          , 'Total'                                                                 AS TOTAL_TITLE
	          , COUNT(T.PROGRAM_ID)                                                     AS TOTAL_COUNT
	      FROM   SCM_ADM_EXCEL_UPLOAD T
	     WHERE  T.PROGRAM_ID    = P_MNU_ID
		   AND  T.SHEET_NAME    = P_SHT_NM
		   AND  T.CREATED_BY    = P_USER_ID
	       AND  T.CREATION_DATE = ( SELECT  MAX(X.CREATION_DATE)
	                                    FROM  SCM_ADM_EXCEL_UPLOAD X
	                                   WHERE  X.PROGRAM_ID = P_MNU_ID
									     AND  X.SHEET_NAME = P_SHT_NM
									     AND  X.CREATED_BY = P_USER_ID  )
	       AND  T.UPLOAD_STATUS_CODE IN ('SUCCESS','ERROR'); 
		
	    --2. 결과 정보
		FOR i IN 1..NVL(P_COL_CNT, 0) LOOP
	        -- INSERT용 컬럼명 리스트 (예: ATTRIBUTE1, ATTRIBUTE2...)
	        V_ATTR_LIST := V_ATTR_LIST || 'ATTRIBUTE' || i || ', ';
	    END LOOP;
	    V_ATTR_LIST :=  V_ATTR_LIST || ' MESSAGE_TEXT';
	
	   
	  	/* [E20260914-EXCELROW] EXCEL_ROW = 엑셀 실제 행 번호. 구 로직은 ERROR 행만 거른 뒤 번호를 매겨
	  	   (오류 순번 1,2,3…) 화면 'Row' 가 엑셀 행과 어긋났다(정상 행이 끼면 뒤 행 전부 밀림).
	  	   배치 전 행(@TITLE=1행 포함, UPLOAD_ID=업로드 JSON 순서)에 번호를 매긴 뒤 바깥에서 ERROR 만 남긴다.
	  	   BE 는 헤더 1행=@TITLE, 이후 엑셀 행 순서대로 적재한다(2단 헤더 양식은 2행을 공란 행으로 적재). */
	  	V_SQL := 'SELECT * FROM (' ||
	  			 'SELECT ROW_NUMBER() OVER (ORDER BY T.UPLOAD_ID ASC) AS EXCEL_ROW, UPLOAD_STATUS_CODE, ' || V_ATTR_LIST || 
           		 '  FROM SCM_ADM_EXCEL_UPLOAD T ' ||
           		 ' WHERE T.PROGRAM_ID       = ''' || P_MNU_ID || '''' ||
           		 '   AND T.SHEET_NAME       = ''' || P_SHT_NM || '''' ||
           		 '   AND T.CREATED_BY       = ''' || P_USER_ID || '''' ||
           		 '   AND T.CREATION_DATE    = ( ' ||
           		 '       SELECT MAX(X.CREATION_DATE) ' ||
           		 '         FROM SCM_ADM_EXCEL_UPLOAD X ' ||
           		 '        WHERE X.PROGRAM_ID = ''' || P_MNU_ID || '''' ||
           		 '          AND X.SHEET_NAME = ''' || P_SHT_NM || '''' ||
           		 '          AND X.CREATED_BY = ''' || P_USER_ID || '''' ||
           		 '   AND UPLOAD_STATUS_CODE <> ''@TITLE''' ||
           		 '   )) WHERE UPLOAD_STATUS_CODE = ''ERROR'' ORDER BY EXCEL_ROW';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		OPEN O_RESULT_LIST FOR V_SQL;
				
	   
		OPEN O_RESULT_CURSOR FOR
			SELECT '0' CODE, 'SUSSESS' MSG, V_ROW_CNT EVENT FROM DUAL;
		
	
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
			V_ERR_MSG := SQLERRM;
			RAISE_APPLICATION_ERROR(-20001, V_ERR_MSG);
			RAISE;
			
	END;





END PKG_NSCM_UI_EXCEL;
/
SHOW ERRORS PACKAGE BODY SCM_MGR.PKG_NSCM_UI_EXCEL
