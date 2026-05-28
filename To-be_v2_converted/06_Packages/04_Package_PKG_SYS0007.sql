/*=============================================================================================
 * File         : 04_Package_PKG_SYS0007.sql
 * Description  : Package — PKG_SYS0007
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0007
AS

    PROCEDURE SYS0007_GET_MAIN_DATA (
		P_GR_CTN		IN 		VARCHAR2,
		P_USE_YN		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );

	PROCEDURE SYS0007_SAVE_MAIN_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	);

END PKG_SYS0007;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0007
AS

	PROCEDURE SYS0007_GET_MAIN_DATA (
	    P_GR_CTN       	IN      VARCHAR2,
	    P_USE_YN		IN		VARCHAR2,
	    O_CURSOR        OUT     SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	BEGIN

		OPEN O_CURSOR FOR
			SELECT	G.USER_GR_ID
				  , G.USER_GR_NM 
				  , G.USE_YN
				  , G.CREATED_BY
				  , G.CREATION_DATE
				  , G.LAST_UPDATED_BY
				  , G.LAST_UPDATE_DATE
			FROM	SCM_ADM_USER_GR_M G
			WHERE	(P_GR_CTN IS NULL OR (UPPER(G.USER_GR_ID) LIKE UPPER('%' || P_GR_CTN || '%')) OR
					 (UPPER(G.USER_GR_NM) LIKE UPPER('%' || P_GR_CTN || '%')))
			AND		(P_USE_YN = 'ALL' OR G.USE_YN = P_USE_YN)
			ORDER BY G.USER_GR_ID
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
	
	END SYS0007_GET_MAIN_DATA;

	PROCEDURE SYS0007_SAVE_MAIN_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
	) IS
		V_ERR_MSG 	VARCHAR2(4000);
		V_ROW_CNT	NUMBER := 0;
	BEGIN
		
		DELETE
		FROM	SCM_ADM_USER_GR_M
        WHERE	USER_GR_ID IN (
			SELECT V_USER_GR_ID
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID'
                ))
			WHERE V_CRUD_TYPE = 'D'
        );
			    
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

		MERGE INTO SCM_ADM_USER_GR_M T
        USING (
			SELECT 
                V_CRUD_TYPE 	AS CRUD_TYPE,
                V_USER_GR_ID    AS USER_GR_ID,
                V_USER_GR_NM    AS USER_GR_NM,
                V_USE_YN    	AS USE_YN
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_USER_GR_NM    VARCHAR2(200) PATH '$.USER_GR_NM',
                    V_USE_YN    	VARCHAR2(1)   PATH '$.USE_YN'
                ))
			WHERE V_CRUD_TYPE IN ('I', 'M')
        ) M
        ON (T.USER_GR_ID = M.USER_GR_ID AND M.CRUD_TYPE = 'M')
        WHEN MATCHED THEN
            UPDATE SET	T.USER_GR_NM 		= M.USER_GR_NM
            		  , T.USE_YN			= M.USE_YN
            		  , T.LAST_UPDATED_BY 	= P_USER_ID
            		  , T.LAST_UPDATE_DATE 	= SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (USER_GR_ID
            	  , USER_GR_NM
            	  , USE_YN
            	  , CREATED_BY
            	  , CREATION_DATE
            	  , LAST_UPDATED_BY
            	  , LAST_UPDATE_DATE)
            VALUES (M.USER_GR_ID
           	 	  , M.USER_GR_NM
           	 	  , M.USE_YN
           	 	  , P_USER_ID
           	 	  , SYSDATE
           	 	  , P_USER_ID
           	 	  , SYSDATE)
	    ;
	   
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
		
	END SYS0007_SAVE_MAIN_DATA;

END PKG_SYS0007;
/
