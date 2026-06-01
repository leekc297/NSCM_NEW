/*=============================================================================================
 * File         : 04_Package_PKG_NSCM_UI_COM_MENU.sql
 * Description  : Package — PKG_NSCM_UI_COM_MENU
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_NSCM_UI_COM_MENU
AS

	PROCEDURE PR_GET_MENU_LIST ( 
		P_USER_ID	IN	VARCHAR2, 
		DATA		OUT	SYS_REFCURSOR
	);

	PROCEDURE PR_GET_SHEET_COLUMN_LIST (
		P_USER_ID		IN	VARCHAR2,	
		P_MNU_ID		IN	VARCHAR2,
		P_SHEET_NAME 	IN	VARCHAR2,
		P_DIVISION_ID	IN	VARCHAR2,
		DATA			OUT SYS_REFCURSOR
	);

	PROCEDURE PR_GET_SHEET_MEASURE_LIST (
		P_USER_ID		IN	VARCHAR2,	
		P_MNU_ID		IN	VARCHAR2,
		P_SHEET_NAME 	IN	VARCHAR2,
		P_DIVISION_ID	IN	VARCHAR2,
		DATA			OUT SYS_REFCURSOR
	);

	PROCEDURE PR_ADD_USER_BMK (
		P_USER_ID		IN	VARCHAR2,	
		P_MNU_ID		IN	VARCHAR2
	);

	PROCEDURE PR_REMOVE_USER_BMK (
		P_USER_ID		IN	VARCHAR2,	
		P_MNU_ID		IN	VARCHAR2
	);

END PKG_NSCM_UI_COM_MENU;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_NSCM_UI_COM_MENU
AS

	PROCEDURE PR_GET_MENU_LIST ( 
		P_USER_ID	IN VARCHAR2, 
		DATA		OUT		SYS_REFCURSOR
	) IS
	
	BEGIN
		OPEN DATA FOR
			SELECT 	DISTINCT
					M.MNU_ID		AS MNU_ID
				  , M.UPPR_MNU_ID	AS UPPR_MNU_ID
				  , M.MNU_URL		AS MNU_URL
				  , M.MNU_MSG_ID 	AS MNU_MSG_ID
				  , M.MNU_DESC 		AS MNU_DESC
				  , M.SORT_ORD		AS SORT_ORD
				  , NVL2(B.MNU_ID, 'Y', 'N') AS BMK_YN /* 2026-05-26 fix: '' → 'N'. Oracle empty-string = NULL → BE MenuDto.of NPE */
			FROM   	SCM_ADM_MNU_M M
				INNER JOIN SCM_ADM_USER_GR_MNU_MPG_M GM
			   		ON	M.MNU_ID = GM.MNU_ID
			   	INNER JOIN SCM_ADM_USER_GR_MPG_M UG
			   		ON	GM.USER_GR_ID = UG.USER_GR_ID
			   	LEFT JOIN SCM_ADM_USER_BMK_M B
			   		ON	UG.USER_ID = B.USER_ID
			   		AND	M.MNU_ID = B.MNU_ID 
			WHERE	1=1	
			AND 	M.USE_YN  = 'Y'
			AND  	UG.USE_YN = 'Y'
			AND		M.MNU_ID <> 'Popup' 		-- POPUP LEVEL 1
			AND		M.MNU_ID NOT LIKE '%Popup' 	-- POPUP LEVEL 2
			AND		M.MNU_TP_CD <> 'POPUP'		-- POPUP LEVEL 3
			AND 	UG.USER_ID = P_USER_ID --'minyonglee1' --park.choyi 2026.04.15 P_USER_ID 로 변경
			ORDER BY M.SORT_ORD ASC
			;
	END;

	PROCEDURE PR_GET_SHEET_COLUMN_LIST (
	    P_USER_ID       IN  VARCHAR2,   
	    P_MNU_ID        IN  VARCHAR2,
	    P_SHEET_NAME    IN  VARCHAR2,
	    P_DIVISION_ID   IN  VARCHAR2,
	    DATA            OUT SYS_REFCURSOR
	) IS
	    V_PRSL_YN       VARCHAR2(1);
	    V_CNT           NUMBER;
	    V_PRSL_CNT      NUMBER;
	    V_SHEET_NAME    VARCHAR2(100);
	BEGIN
	    -- 1. 그리드의 개인화 여부 체크 (MAX를 써서 데이터 없을 때 NO_DATA_FOUND 방지)
	    SELECT MAX(SEGMENT3)
	      INTO V_PRSL_YN
	      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	     WHERE LOOKUP_TYPE = 'SHEET_PRSL_YN'
	       AND SEGMENT1 = P_MNU_ID
	       AND SEGMENT2 = P_SHEET_NAME;
	
	    -- 2. Sheet 명 결정 (Division ID 우선)
	    SELECT COUNT(*)
	      INTO V_CNT
	      FROM SCM_MST_SHEET_COLUMNS
	     WHERE SHEET_NAME = P_SHEET_NAME || '_' || P_DIVISION_ID
	       AND ROWNUM = 1;
	
	    IF V_CNT > 0 THEN
	        V_SHEET_NAME := P_SHEET_NAME || '_' || P_DIVISION_ID;
	    ELSE
	        V_SHEET_NAME := P_SHEET_NAME;
	    END IF;
	
	    -- 3. 개인화 적용 그리드의 경우 처리
	    IF V_PRSL_YN = 'Y' THEN
	        
	    	SELECT	COUNT(*)
	    	INTO	V_PRSL_CNT
	    	FROM	SCM_MST_TITLESET_USER U
	    	WHERE 	U.USER_ID = P_USER_ID
	    	AND 	U.PROGRAM_ID = P_MNU_ID
	    	AND 	U.SHEET_NAME = V_SHEET_NAME
	    	AND		U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

	    	-- 개인화 적용 그리드인데, 개인화 데이터 하나도 없는 경우 DEFAULT_FLAG='Y'인 데이터 초기 세팅
	    	IF V_PRSL_CNT = 0 THEN
	    		INSERT	INTO SCM_MST_TITLESET_USER (
		    		USER_ID
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
		    	SELECT	P_USER_ID		AS USER_ID
		    		  , C.PROGRAM_ID
		    		  , C.SHEET_NAME
		    		  , 'C'
		    		  , C.COLUMN_NAME 
		    		  , C.SORT_ORDER_NO
		    		  , '' AS SUB_TOTAL_FLAG
		    		  , C.DATA_SORT_METHOD_CODE
		    		  , P_USER_ID 		AS CREATED_BY
		    		  , SYSDATE			AS CREATION_DATE
		    		  , P_USER_ID 		AS LAST_UPDATED_BY
		    		  , SYSDATE			AS LAST_UPDATE_DATE 
		    	FROM 	SCM_MST_SHEET_COLUMNS C
		    	WHERE 	C.PROGRAM_ID = P_MNU_ID
		    	AND		C.SHEET_NAME = V_SHEET_NAME
		    	AND		C.DEFAULT_FLAG = 'Y';
	    	END IF;
	    
	        -- 4. 개인화 쿼리 반환 (정렬 로직 수정)
	        OPEN DATA FOR
	            WITH BEFORE_SORT AS (
	                SELECT	C.PROGRAM_ID
	                	  , C.SHEET_NAME
	                	  , C.COLUMN_NAME
	                	  , C.COLUMN_LABEL_NAME
	                	  , C.SORT_ORDER_NO
	                	  , C.DATA_SORT_METHOD_CODE
						  , C.SMALL_CLASS_LABEL_NAME 
	  				 	  , C.LARGE_CLASS_LABEL_NAME 
	                	  , C.FIXED_FLAG
	                	  , C.COLUMN_WIDTH
	                	  , C.CELL_CONTROL_OBJECT_TYPE_CODE
	               	      , C.CELL_COMBO_DATA_TYPE 
						  , C.INPUT_TP_CD
						  , C.DATA_SCALE_NUMBER 
						  , C.DATA_MAX_LENGTH 
						  , C.HORIZONTAL_ALIGN_CODE 
						  , C.UPPERCASE_APPLY_FLAG 
						  , C.VISIBLE_FLAG 
						  , C.USER_SELECTABLE_FLAG 
	                	  , CASE WHEN
	                	  		U.COLUMN_NAME IS NULL THEN ''
	                	  		ELSE 'Y'
	                	  	END AS DISPLAY_FLAG
	                	  , NVL(U.SORT_ORDER_NO, 999) AS USER_SORT_ORDER_NO
	                	  , C.ATTRIBUTE1
	                	  , C.ATTRIBUTE2
	                	  , C.ATTRIBUTE3
	                	  , C.ATTRIBUTE4
	                	  , C.ATTRIBUTE5
	                	  , C.ATTRIBUTE6
	                	  , C.ATTRIBUTE7
	                	  , C.ATTRIBUTE8
	                	  , C.ATTRIBUTE9
	                	  , C.ATTRIBUTE10
	                FROM	SCM_MST_SHEET_COLUMNS C
		                LEFT JOIN SCM_MST_TITLESET_USER U
	                		ON	C.PROGRAM_ID = U.PROGRAM_ID
			                AND C.SHEET_NAME = U.SHEET_NAME
			                AND C.COLUMN_NAME = U.COLUMN_NAME
			                AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
			                AND U.USER_ID = P_USER_ID
	                WHERE C.VALID_YN = 'Y'
	                  AND C.PROGRAM_ID = P_MNU_ID
	                  AND C.SHEET_NAME = V_SHEET_NAME
	            )
	            SELECT	*
	            FROM	(
	                	-- 표시되지 않는 컬럼 (기본 순서)
		                SELECT B.*, 1 AS GRP FROM BEFORE_SORT B WHERE B.DISPLAY_FLAG = ''
		                UNION ALL
		                -- 표시되는 컬럼 (사용자 지정 순서)
		                SELECT B.*, 2 AS GRP FROM BEFORE_SORT B WHERE B.DISPLAY_FLAG = 'Y'
	            		)
	            ORDER BY GRP, CASE WHEN GRP = 1 THEN SORT_ORDER_NO ELSE USER_SORT_ORDER_NO END;
	            
	    ELSE 
	        -- 5. 개인화 미적용 그리드의 경우 처리
	        OPEN DATA FOR
	            SELECT	C.PROGRAM_ID
	            	  , C.SHEET_NAME
	            	  , C.COLUMN_NAME
	            	  , C.COLUMN_LABEL_NAME
	            	  , C.SORT_ORDER_NO
	            	  , C.DATA_SORT_METHOD_CODE
					  , C.SMALL_CLASS_LABEL_NAME 
				 	  , C.LARGE_CLASS_LABEL_NAME 
	            	  , C.FIXED_FLAG
	            	  , C.COLUMN_WIDTH
	            	  , C.CELL_CONTROL_OBJECT_TYPE_CODE
	           	      , C.CELL_COMBO_DATA_TYPE 
					  , C.INPUT_TP_CD
					  , C.DATA_SCALE_NUMBER 
					  , C.DATA_MAX_LENGTH 
					  , C.HORIZONTAL_ALIGN_CODE 
					  , C.UPPERCASE_APPLY_FLAG 
					  , C.VISIBLE_FLAG 
					  , C.USER_SELECTABLE_FLAG
	            	  , C.DEFAULT_FLAG AS DISPLAY_FLAG
	            	  , 0 AS USER_SORT_ORDER_NO
                	  , C.ATTRIBUTE1
                	  , C.ATTRIBUTE2
                	  , C.ATTRIBUTE3
                	  , C.ATTRIBUTE4
                	  , C.ATTRIBUTE5
                	  , C.ATTRIBUTE6
                	  , C.ATTRIBUTE7
                	  , C.ATTRIBUTE8
                	  , C.ATTRIBUTE9
                	  , C.ATTRIBUTE10
	            FROM	SCM_MST_SHEET_COLUMNS C
	            WHERE	C.VALID_YN = 'Y'
	            AND		C.PROGRAM_ID = P_MNU_ID
	            AND		C.SHEET_NAME = V_SHEET_NAME
	            ORDER BY C.SORT_ORDER_NO;
		END IF;
	    
	END PR_GET_SHEET_COLUMN_LIST;

	PROCEDURE PR_GET_SHEET_MEASURE_LIST (
		P_USER_ID		IN	VARCHAR2,	
		P_MNU_ID		IN	VARCHAR2,
		P_SHEET_NAME 	IN	VARCHAR2,
		P_DIVISION_ID	IN	VARCHAR2,
		DATA			OUT SYS_REFCURSOR
	) IS
	    V_PRSL_YN       VARCHAR2(1);
	    V_CNT           NUMBER;
	    V_PRSL_CNT      NUMBER;
	    V_SHEET_NAME    VARCHAR2(100);
	BEGIN
		
		-- 1. 그리드의 개인화 여부 체크 (MAX를 써서 데이터 없을 때 NO_DATA_FOUND 방지)
	    SELECT MAX(SEGMENT3)
	      INTO V_PRSL_YN
	      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	     WHERE LOOKUP_TYPE = 'SHEET_PRSL_YN'
	       AND SEGMENT1 = P_MNU_ID
	       AND SEGMENT2 = P_SHEET_NAME;
	
	    -- 2. Sheet 명 결정 (Division ID 우선)
	    SELECT COUNT(*)
	      INTO V_CNT
	      FROM SCM_MST_SHEET_MEASURE
	     WHERE SHEET_NAME = P_SHEET_NAME || '_' || P_DIVISION_ID
	       AND ROWNUM = 1;
	
	    IF V_CNT > 0 THEN
	        V_SHEET_NAME := P_SHEET_NAME || '_' || P_DIVISION_ID;
	    ELSE
	        V_SHEET_NAME := P_SHEET_NAME;
	    END IF;
	
	    -- 3. 개인화 적용 그리드의 경우 처리
	    IF V_PRSL_YN = 'Y' THEN
	        
	    	SELECT	COUNT(*)
	    	INTO	V_PRSL_CNT
	    	FROM	SCM_MST_TITLESET_USER U
	    	WHERE 	U.USER_ID = P_USER_ID
	    	AND 	U.PROGRAM_ID = P_MNU_ID
	    	AND 	U.SHEET_NAME = V_SHEET_NAME
	    	AND		U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M';

	    	-- 개인화 적용 그리드인데, 개인화 데이터 하나도 없는 경우 DEFAULT_FLAG='Y'인 데이터 초기 세팅
	    	IF V_PRSL_CNT = 0 THEN
	    		INSERT	INTO SCM_MST_TITLESET_USER (
		    		USER_ID
		    	  , PROGRAM_ID
		    	  , SHEET_NAME
		    	  , USER_INQUIRY_COLUMN_TYPE_CODE
		    	  , COLUMN_NAME
		    	  , SORT_ORDER_NO
		    	  , SUB_TOTAL_FLAG
		    	  , CREATED_BY
		    	  , CREATION_DATE
		    	  , LAST_UPDATED_BY
		    	  , LAST_UPDATE_DATE
		    	)
		    	SELECT	P_USER_ID		AS USER_ID
		    		  , M.PROGRAM_ID
		    		  , M.SHEET_NAME
		    		  , 'M'
		    		  , M.COLUMN_NAME 
		    		  , M.SORT_ORDER_NO
		    		  , '' AS SUB_TOTAL_FLAG
		    		  , P_USER_ID 		AS CREATED_BY
		    		  , SYSDATE			AS CREATION_DATE
		    		  , P_USER_ID 		AS LAST_UPDATED_BY
		    		  , SYSDATE			AS LAST_UPDATE_DATE 
		    	FROM 	SCM_MST_SHEET_MEASURE M
		    	WHERE 	M.PROGRAM_ID = P_MNU_ID
		    	AND		M.SHEET_NAME = V_SHEET_NAME
		    	AND		M.DEFAULT_FLAG = 'Y';
	    	END IF;
	    
	        -- 4. 개인화 쿼리 반환 (정렬 로직 수정)
	        OPEN DATA FOR
	            WITH BEFORE_SORT AS (
	                SELECT	M.PROGRAM_ID
						  , M.SHEET_NAME
						  , M.COLUMN_NAME 
						  , M.COLUMN_LABEL_NAME 
						  , M.SORT_ORDER_NO 
						  , M.SMALL_CLASS_LABEL_NAME 
						  , M.LARGE_CLASS_LABEL_NAME 
						  , M.INPUT_TP_CD
						  , M.DEFAULT_FLAG
						  , M.USER_SELECTABLE_FLAG 
	                	  , CASE WHEN
	                	  		U.COLUMN_NAME IS NULL THEN ''
	                	  		ELSE 'Y'
	                	  	END AS DISPLAY_FLAG
	                	  ,	NVL(U.SORT_ORDER_NO, 999) AS USER_SORT_ORDER_NO
	                	  , M.ATTRIBUTE1
	                	  , M.ATTRIBUTE2
	                	  , M.ATTRIBUTE3
	                	  , M.ATTRIBUTE4
	                	  , M.ATTRIBUTE5
	                	  , M.ATTRIBUTE6
	                	  , M.ATTRIBUTE7
	                	  , M.ATTRIBUTE8
	                	  , M.ATTRIBUTE9
	                	  , M.ATTRIBUTE10
	                FROM	SCM_MST_SHEET_MEASURE M
		                LEFT JOIN SCM_MST_TITLESET_USER U
	                		ON	M.PROGRAM_ID = U.PROGRAM_ID
			                AND M.SHEET_NAME = U.SHEET_NAME
			                AND M.COLUMN_NAME = U.COLUMN_NAME
			                AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
			                AND U.USER_ID = P_USER_ID
	                WHERE M.VALID_YN = 'Y'
	                  AND M.PROGRAM_ID = P_MNU_ID
	                  AND M.SHEET_NAME = V_SHEET_NAME
	            )
	            SELECT	*
	            FROM	(
	                	-- 표시되지 않는 컬럼 (기본 순서)
		                SELECT B.*, 1 AS GRP FROM BEFORE_SORT B WHERE B.DISPLAY_FLAG = ''
		                UNION ALL
		                -- 표시되는 컬럼 (사용자 지정 순서)
		                SELECT B.*, 2 AS GRP FROM BEFORE_SORT B WHERE B.DISPLAY_FLAG = 'Y'
	            		)
	            ORDER BY GRP, CASE WHEN GRP = 1 THEN SORT_ORDER_NO ELSE USER_SORT_ORDER_NO END;
	            
	    ELSE 
	        -- 5. 개인화 미적용 그리드의 경우 처리
	        OPEN DATA FOR
	            SELECT	M.PROGRAM_ID
					  , M.SHEET_NAME
					  , M.COLUMN_NAME 
					  , M.COLUMN_LABEL_NAME 
					  , M.SORT_ORDER_NO 
					  , M.SMALL_CLASS_LABEL_NAME 
					  , M.LARGE_CLASS_LABEL_NAME 
					  , M.INPUT_TP_CD
					  , M.DEFAULT_FLAG
					  , M.USER_SELECTABLE_FLAG 
	            	  , M.DEFAULT_FLAG AS DISPLAY_FLAG
	            	  , 0 AS USER_SORT_ORDER_NO
                	  , M.ATTRIBUTE1
                	  , M.ATTRIBUTE2
                	  , M.ATTRIBUTE3
                	  , M.ATTRIBUTE4
                	  , M.ATTRIBUTE5
                	  , M.ATTRIBUTE6
                	  , M.ATTRIBUTE7
                	  , M.ATTRIBUTE8
                	  , M.ATTRIBUTE9
                	  , M.ATTRIBUTE10
	            FROM	SCM_MST_SHEET_MEASURE M
	            WHERE	M.VALID_YN = 'Y'
	            AND		M.PROGRAM_ID = P_MNU_ID
	            AND		M.SHEET_NAME = V_SHEET_NAME
	            ORDER BY M.SORT_ORDER_NO;
		END IF;
		
	END;

	PROCEDURE PR_ADD_USER_BMK (
		P_USER_ID		IN	VARCHAR2,	
		P_MNU_ID		IN	VARCHAR2
	) IS
	BEGIN
		
		MERGE INTO SCM_ADM_USER_BMK_M B
		USING DUAL
		   ON (B.USER_ID = P_USER_ID AND B.MNU_ID = P_MNU_ID)
		WHEN NOT MATCHED THEN
		    INSERT (USER_ID, MNU_ID, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
		    VALUES (P_USER_ID, P_MNU_ID, P_USER_ID, SYSDATE, P_USER_ID, SYSDATE);
	
	END;

	PROCEDURE PR_REMOVE_USER_BMK (
		P_USER_ID		IN	VARCHAR2,	
		P_MNU_ID		IN	VARCHAR2
	) IS
	BEGIN
		
		DELETE
		FROM SCM_ADM_USER_BMK_M
		WHERE USER_ID = P_USER_ID AND MNU_ID = P_MNU_ID
		;
	
	END;

END PKG_NSCM_UI_COM_MENU;
/
