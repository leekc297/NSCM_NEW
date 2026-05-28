/*=============================================================================================
 * File         : 04_Package_PKG_SYS0002.sql
 * Description  : Package — PKG_SYS0002
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0002
AS

    PROCEDURE SYS0002_GET_MAIN_DATA (
		P_USER_CTN		IN 		VARCHAR2,
		P_DEPT_CTN		IN 		VARCHAR2,
		P_USER_GR		IN 		VARCHAR2,
		P_USE_YN		IN		VARCHAR2,
		P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );

	PROCEDURE SYS0002_SAVE_MAIN_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	);


END PKG_SYS0002;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0002
AS

	PROCEDURE SYS0002_GET_MAIN_DATA (
		P_USER_CTN		IN 		VARCHAR2,
		P_DEPT_CTN		IN 		VARCHAR2,
		P_USER_GR		IN 		VARCHAR2,
		P_USE_YN		IN		VARCHAR2,
		P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	BEGIN
		
		OPEN O_CURSOR FOR
			SELECT DISTINCT
				    U.USER_ID
				  , U.USER_NM
				  , U.USER_ENG_NM
				  , U.USER_EML
				  , U.DEPT_ID
				  , CASE
						WHEN P_LANG_CD = 'KO' THEN D.DEPT_NAME_KO
						WHEN P_LANG_CD = 'EN' THEN D.DEPT_NAME_EN
						WHEN P_LANG_CD = 'CN' THEN D.DEPT_NAME_CN
						ELSE '-'
					END AS DEPT_NM
				  , U.USER_HPHN
				  , U.LANG_CD
				  , U.TMZ_CD
				  , U.LOGN_DTM
				  , U.ACNT_LOK_YN
				  , U.PERM_KEP_CNC_YN
				  , U.USE_YN
				  , U.CREATED_BY
				  , U.CREATION_DATE
				  , U.LAST_UPDATED_BY
				  , U.LAST_UPDATE_DATE
			FROM 	SCM_ADM_USER_M U
				LEFT JOIN SCM_MST_SSO_DEPT_INFO D
					ON	U.DEPT_ID = D.DEPT_ID
				LEFT JOIN SCM_ADM_USER_GR_MPG_M G
					ON	U.USER_ID = G.USER_ID
			WHERE	1=1
			AND		(P_USER_CTN IS NULL OR
					 UPPER(U.USER_ID) LIKE '%' || UPPER(P_USER_CTN) || '%' OR
					 UPPER(U.USER_NM) LIKE '%' || UPPER(P_USER_CTN) || '%' OR
					 UPPER(U.USER_ENG_NM) LIKE '%' || UPPER(P_USER_CTN) || '%')
			AND		(P_DEPT_CTN IS NULL OR
					 UPPER(D.DEPT_NAME_KO) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
					 UPPER(D.DEPT_NAME_EN) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
					 UPPER(D.DEPT_NAME_CN) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
					 UPPER(U.DEPT_ID) LIKE '%' || UPPER(P_DEPT_CTN) || '%')
			AND		(P_USER_GR = 'ALL' OR P_USER_GR = G.USER_GR_ID)
			AND		(P_USE_YN = 'ALL' OR U.USE_YN = P_USE_YN)
			ORDER BY U.USER_ID
			;
	     
		OPEN O_RESULT_CURSOR FOR
			SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
	          
		EXCEPTION
		    WHEN OTHERS THEN
		        RAISE_APPLICATION_ERROR(-20001,
		        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
		        ' / SQLERRM=' || SQLERRM ||
		        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
		        ' / PARAMS=' || '-' );

		
	END SYS0002_GET_MAIN_DATA;

	
	PROCEDURE SYS0002_SAVE_MAIN_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
		V_ROW_CNT	NUMBER := 0;
		V_ERR_MSG 	VARCHAR2(4000);
	BEGIN
		
		DELETE FROM SCM_ADM_USER_M
		WHERE USER_ID IN (
		    SELECT V_USER_ID
		    FROM JSON_TABLE(P_DATA, '$[*]'
		        COLUMNS (
		            V_CRUD_TYPE VARCHAR2(20)  PATH '$.CRUD_TYPE',
		            V_USER_ID    VARCHAR2(200) PATH '$.USER_ID'
		        ))
		    WHERE V_CRUD_TYPE = 'D'
		);
		
		-- 삭제 건수 확인
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
	   
		-- MERGE
		MERGE INTO SCM_ADM_USER_M T
        USING (
			SELECT 
                V_CRUD_TYPE 		AS CRUD_TYPE,
                V_USER_ID    		AS USER_ID,
                V_USER_NM    		AS USER_NM,
                V_USER_ENG_NM    	AS USER_ENG_NM,
                --V_USER_EML    		AS USER_EML,
                V_DEPT_ID    		AS DEPT_ID,
                --V_USER_HPHN    		AS USER_HPHN,
                V_LANG_CD    		AS LANG_CD,
                V_TMZ_CD    		AS TMZ_CD,
                V_PERM_KEP_CNC_YN   AS PERM_KEP_CNC_YN,
                V_USE_YN    		AS USE_YN
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 		VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_ID    		VARCHAR2(200) PATH '$.USER_ID',
                    V_USER_NM    		VARCHAR2(200) PATH '$.USER_NM',
                    V_USER_ENG_NM 		VARCHAR2(200) PATH '$.USER_ENG_NM',
                    --V_USER_EML    		VARCHAR2(200) PATH '$.USER_EML',
                    V_DEPT_ID    		VARCHAR2(200) PATH '$.DEPT_ID',
                    --V_USER_HPHN   		VARCHAR2(200) PATH '$.USER_HPHN',
                    V_LANG_CD    		VARCHAR2(200) PATH '$.LANG_CD',
                    V_TMZ_CD    		VARCHAR2(200) PATH '$.TMZ_CD',
                    V_PERM_KEP_CNC_YN   VARCHAR2(1)   PATH '$.PERM_KEP_CNC_YN',
                    V_USE_YN    		VARCHAR2(1)   PATH '$.USE_YN'
                ))
			WHERE V_CRUD_TYPE IN ('I', 'M')
        ) M
        ON (T.USER_ID = M.USER_ID AND M.CRUD_TYPE = 'M')
        WHEN MATCHED THEN
            UPDATE SET	T.USER_NM 			= M.USER_NM
            		  , T.USER_ENG_NM		= M.USER_ENG_NM
            		  --, T.USER_EML			= M.USER_EML
            		  , T.DEPT_ID			= M.DEPT_ID
            		  --, T.USER_HPHN			= M.USER_HPHN
            		  , T.LANG_CD 			= LANG_CD
            		  , T.TMZ_CD 			= TMZ_CD
            		  , T.PERM_KEP_CNC_YN 	= PERM_KEP_CNC_YN
            		  , T.USE_YN 			= USE_YN
            		  , T.LAST_UPDATED_BY 	= P_USER_ID
            		  , T.LAST_UPDATE_DATE 	= SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (USER_ID
            	  , USER_NM
            	  , USER_ENG_NM
            	  --, USER_EML
            	  , DEPT_ID
            	  --, USER_HPHN
            	  , LANG_CD
            	  , TMZ_CD
            	  , PERM_KEP_CNC_YN
            	  , USE_YN
            	  , CREATED_BY
            	  , CREATION_DATE
            	  , LAST_UPDATED_BY
            	  , LAST_UPDATE_DATE)
            VALUES (M.USER_ID
            	  , M.USER_NM
            	  , M.USER_ENG_NM
            	  --, M.USER_EML
            	  , M.DEPT_ID
            	  --, M.USER_HPHN
            	  , M.LANG_CD
            	  , M.TMZ_CD
            	  , M.PERM_KEP_CNC_YN
           	 	  , M.USE_YN
           	 	  , P_USER_ID
           	 	  , SYSDATE
           	 	  , P_USER_ID
           	 	  , SYSDATE)
	    ;
	   
		-- 생성, 수정 건수 확인
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
		
		COMMIT;	
	
	    OPEN O_RESULT_CURSOR FOR
	         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
	
		EXCEPTION
		    WHEN OTHERS THEN
		        ROLLBACK;

				IF SQLCODE = -1 THEN
		            V_ERR_MSG := 'Duplicate key error.';         
	           	    OPEN O_RESULT_CURSOR FOR
			            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
        		ELSIF SQLCODE = -1400 THEN
   		            V_ERR_MSG := 'Required value is missing.';
	           	    OPEN O_RESULT_CURSOR FOR
			            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
        		ELSIF SQLCODE = -12899 THEN
		            V_ERR_MSG := 'Maximum data size exceeded.';
	           	    OPEN O_RESULT_CURSOR FOR
			            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
        		ELSE
			        RAISE_APPLICATION_ERROR(-20001,
			        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
			        ' / SQLERRM=' || SQLERRM ||
			        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
			        ' / PARAMS=' || '-' );
        		END IF;
		
	END SYS0002_SAVE_MAIN_DATA;

END PKG_SYS0002;
/
