/*=============================================================================================
 * File         : 04_Package_PKG_SYS0003.sql
 * Description  : Package — PKG_SYS0003
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0003
AS

    PROCEDURE SYS0003_GET_LEVEL_ONE_DATA (
    	P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );

    PROCEDURE SYS0003_GET_LEVEL_TWO_DATA (
    	P_MNU_ID		IN		VARCHAR2,
    	P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );
   
    PROCEDURE SYS0003_GET_LEVEL_THREE_DATA (
    	P_MNU_ID		IN		VARCHAR2,
    	P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );
   
	PROCEDURE SYS0003_SAVE_LEVEL_ONE_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	);
   
	PROCEDURE SYS0003_SAVE_LEVEL_TWO_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	);

	PROCEDURE SYS0003_SAVE_LEVEL_THREE_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	);

END PKG_SYS0003;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0003
AS

	PROCEDURE SYS0003_GET_LEVEL_ONE_DATA (
		P_LANG_CD		IN		VARCHAR2,
	    O_CURSOR        OUT     SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	BEGIN

		OPEN O_CURSOR FOR
			SELECT	M.MNU_ID
				  , M.UPPR_MNU_ID
				  , M.MNU_URL
				  , M.SYS_MNUL_URL
				  , M.MNU_MSG_ID
				  , MSG.MSG_NM		AS MNU_MSG_NM
				  , M.MNU_DESC
				  , M.SORT_ORD
				  , M.MNU_LV_NO
				  , M.MNU_TP_CD
				  , M.UNIT_TP_CD
				  , M.USE_YN
				  , M.N01_ATR_CTN
				  , M.N02_ATR_CTN
				  , M.N03_ATR_CTN
				  , M.N04_ATR_CTN
				  , M.N05_ATR_CTN
				  , M.N06_ATR_CTN
				  , M.N07_ATR_CTN
				  , M.N08_ATR_CTN
				  , M.N09_ATR_CTN
				  , M.N10_ATR_CTN
				  , M.CREATED_BY
				  , M.CREATION_DATE
				  , M.LAST_UPDATED_BY
				  , M.LAST_UPDATE_DATE
			FROM	SCM_ADM_MNU_M M
				LEFT JOIN SCM_ADM_MSG_M MSG
					ON	1=1
					AND MSG.MSG_TP_CD = 'MNU'
					AND MSG.USE_YN = 'Y'
					AND MSG.LANG_CD = P_LANG_CD
					AND MSG.MSG_ID = M.MNU_MSG_ID
			WHERE 	MNU_LV_NO = 1
			ORDER BY M.SORT_ORD
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
	
	END SYS0003_GET_LEVEL_ONE_DATA;

	PROCEDURE SYS0003_GET_LEVEL_TWO_DATA (
		P_MNU_ID		IN		VARCHAR2,
		P_LANG_CD		IN		VARCHAR2,
	    O_CURSOR        OUT     SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	BEGIN

		OPEN O_CURSOR FOR
			SELECT	P_MNU_ID		AS LEVEL_ONE_MNU_ID
				  , M.MNU_ID
				  , M.UPPR_MNU_ID
				  , M.MNU_URL
				  , M.SYS_MNUL_URL
				  , M.MNU_MSG_ID
				  , MSG.MSG_NM		AS MNU_MSG_NM
				  , M.MNU_DESC
				  , M.SORT_ORD
				  , M.MNU_LV_NO
				  , M.MNU_TP_CD
				  , M.UNIT_TP_CD
				  , M.USE_YN
				  , M.N01_ATR_CTN
				  , M.N02_ATR_CTN
				  , M.N03_ATR_CTN
				  , M.N04_ATR_CTN
				  , M.N05_ATR_CTN
				  , M.N06_ATR_CTN
				  , M.N07_ATR_CTN
				  , M.N08_ATR_CTN
				  , M.N09_ATR_CTN
				  , M.N10_ATR_CTN
				  , M.CREATED_BY
				  , M.CREATION_DATE
				  , M.LAST_UPDATED_BY
				  , M.LAST_UPDATE_DATE
			FROM	SCM_ADM_MNU_M M
				LEFT JOIN SCM_ADM_MSG_M MSG
					ON	1=1
					AND MSG.MSG_TP_CD = 'MNU'
					AND MSG.USE_YN = 'Y'
					AND MSG.LANG_CD = P_LANG_CD
					AND MSG.MSG_ID = M.MNU_MSG_ID
			WHERE 	MNU_LV_NO = 2
			AND		M.UPPR_MNU_ID = P_MNU_ID
			ORDER BY SORT_ORD
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
	
	END SYS0003_GET_LEVEL_TWO_DATA;

	PROCEDURE SYS0003_GET_LEVEL_THREE_DATA (
		P_MNU_ID		IN		VARCHAR2,
		P_LANG_CD		IN		VARCHAR2,
	    O_CURSOR        OUT     SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
		V_LEVEL_ONE_MNU_ID VARCHAR2(100);
	BEGIN
		
		SELECT 	UPPR_MNU_ID
        INTO   	V_LEVEL_ONE_MNU_ID
        FROM   	SCM_ADM_MNU_M
        WHERE  	MNU_LV_NO = 2
        AND		MNU_ID = P_MNU_ID
        ;

		OPEN O_CURSOR FOR
			SELECT	V_LEVEL_ONE_MNU_ID	AS LEVEL_ONE_MNU_ID
				  , P_MNU_ID			AS LEVEL_TWO_MNU_ID
				  , M.MNU_ID
				  , M.UPPR_MNU_ID
				  , M.MNU_URL
				  , M.SYS_MNUL_URL
				  , M.MNU_MSG_ID
				  , MSG.MSG_NM			AS MNU_MSG_NM
				  , M.MNU_DESC
				  , M.SORT_ORD
				  , M.MNU_LV_NO
				  , M.MNU_TP_CD
				  , M.UNIT_TP_CD
				  , M.USE_YN
				  , M.N01_ATR_CTN
				  , M.N02_ATR_CTN
				  , M.N03_ATR_CTN
				  , M.N04_ATR_CTN
				  , M.N05_ATR_CTN
				  , M.N06_ATR_CTN
				  , M.N07_ATR_CTN
				  , M.N08_ATR_CTN
				  , M.N09_ATR_CTN
				  , M.N10_ATR_CTN
				  , M.CREATED_BY
				  , M.CREATION_DATE
				  , M.LAST_UPDATED_BY
				  , M.LAST_UPDATE_DATE
			FROM	SCM_ADM_MNU_M M
				LEFT JOIN SCM_ADM_MSG_M MSG
					ON	1=1
					AND MSG.MSG_TP_CD = 'MNU'
					AND MSG.USE_YN = 'Y'
					AND MSG.LANG_CD = P_LANG_CD
					AND MSG.MSG_ID = M.MNU_MSG_ID
			WHERE 	MNU_LV_NO = 3
			AND		M.UPPR_MNU_ID = P_MNU_ID
			ORDER BY SORT_ORD
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
	
	END SYS0003_GET_LEVEL_THREE_DATA;
   
	PROCEDURE SYS0003_SAVE_LEVEL_ONE_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	    EX_BIZ_EX       EXCEPTION;
		V_CHILD_CNT		NUMBER := 0;
		V_ERR_MSG 		VARCHAR2(4000);
		V_ROW_CNT 		NUMBER := 0;
	BEGIN
        
        -- DELETE할 메뉴 중 CHILD가 있는 경우 에러 보내주기
        SELECT	COUNT(*)
        INTO	V_CHILD_CNT
        FROM	JSON_TABLE(P_DATA, '$[*]'
            	COLUMNS (
                	V_CRUD_TYPE    		VARCHAR2(200) PATH '$.CRUD_TYPE',
                	V_MNU_ID    		VARCHAR2(200) PATH '$.MNU_ID'
            	)) A
	        INNER JOIN	SCM_ADM_MNU_M B
        		ON	TRIM(A.V_MNU_ID) = B.UPPR_MNU_ID -- park.choyi 2026.04.15 공백제거
		WHERE A.V_CRUD_TYPE = 'D'
		;
	
		IF (V_CHILD_CNT > 0) THEN
	        V_ERR_MSG     := '하위 메뉴가 존재하여 삭제가 불가합니다.';
	        RAISE EX_BIZ_EX;
	    END IF;
                  
		-- DELETE
		DELETE
		FROM	SCM_ADM_MNU_M
        WHERE	MNU_ID IN (
			SELECT TRIM(V_MNU_ID) -- park.choyi 2026.04.15 공백제거
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
	                V_CRUD_TYPE    		VARCHAR2(200) PATH '$.CRUD_TYPE',
                    V_MNU_ID    		VARCHAR2(200) PATH '$.MNU_ID'
                ))
			WHERE V_CRUD_TYPE = 'D'
        );
       
		-- 삭제 건수 확인
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
	   
		-- MERGE
		MERGE INTO SCM_ADM_MNU_M T
        USING (
			SELECT -- park.choyi 2026.04.15 공백제거
                TRIM(V_CRUD_TYPE) 		AS CRUD_TYPE,
                TRIM(V_MNU_ID)    		AS MNU_ID,
                TRIM(V_MNU_MSG_ID)    	AS MNU_MSG_ID,
                TRIM(V_MNU_DESC)    		AS MNU_DESC,
                TRIM(V_MNU_URL)    		AS MNU_URL,
                TRIM(V_SORT_ORD)    		AS SORT_ORD,
                TRIM(V_USE_YN)    		AS USE_YN
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 		VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_MNU_ID    		VARCHAR2(200) PATH '$.MNU_ID',
                    V_MNU_MSG_ID    	VARCHAR2(200) PATH '$.MNU_MSG_ID',
                    V_MNU_DESC    		VARCHAR2(200) PATH '$.MNU_DESC',
                    V_MNU_URL    		VARCHAR2(200) PATH '$.MNU_URL',
                    V_SORT_ORD    		VARCHAR2(200) PATH '$.SORT_ORD',
                    V_USE_YN    		VARCHAR2(1)   PATH '$.USE_YN'
                ))
			WHERE V_CRUD_TYPE IN ('I', 'M')
        ) M
        ON (T.MNU_ID = M.MNU_ID AND M.CRUD_TYPE = 'M')
        WHEN MATCHED THEN
            UPDATE SET	T.MNU_MSG_ID 		= M.MNU_MSG_ID
            		  , T.MNU_DESC			= M.MNU_DESC
            		  , T.MNU_URL			= M.MNU_URL
            		  , T.SORT_ORD			= M.SORT_ORD
            		  , T.USE_YN			= M.USE_YN
            		  , T.LAST_UPDATED_BY 	= P_USER_ID
            		  , T.LAST_UPDATE_DATE 	= SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (MNU_ID
            	  , MNU_URL
            	  , MNU_MSG_ID
            	  , MNU_DESC
            	  , SORT_ORD
            	  , MNU_LV_NO
            	  , MNU_TP_CD
            	  , UNIT_TP_CD
            	  , USE_YN
            	  , CREATED_BY
            	  , CREATION_DATE
            	  , LAST_UPDATED_BY
            	  , LAST_UPDATE_DATE)
            VALUES (M.MNU_ID
           	 	  , M.MNU_URL
           	 	  , M.MNU_MSG_ID
           	 	  , M.MNU_DESC
           	 	  , M.SORT_ORD
           	 	  , 1
           	 	  , 'MENU'
           	 	  , '-'
           	 	  , M.USE_YN
           	 	  , P_USER_ID
           	 	  , SYSDATE
           	 	  , P_USER_ID
           	 	  , SYSDATE)
	    ;
	   
		-- 생성, 수정 건수 확인
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
		
    
    --park.choyi 2026.04.21 ADMIN 권한 자동 부여 Start
    MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
    USING (
        SELECT DISTINCT
               'ADMIN'      AS USER_GR_ID
             , J.V_MNU_ID   AS MNU_ID
        FROM JSON_TABLE(
                P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE   VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_MNU_ID      VARCHAR2(200) PATH '$.MNU_ID'
                )
             ) J
        WHERE TRIM(J.V_CRUD_TYPE) IN ('I', 'M')
          AND TRIM(J.V_MNU_ID) IS NOT NULL
    ) S
    ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID)
    WHEN MATCHED THEN
        UPDATE SET
              T.USE_YN           = 'Y'
            , T.LAST_UPDATED_BY  = P_USER_ID
            , T.LAST_UPDATE_DATE = SYSDATE
        WHERE NVL(T.USE_YN, '') <> 'Y'
    WHEN NOT MATCHED THEN
        INSERT (
              USER_GR_ID, MNU_ID, USE_YN
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        VALUES (
              S.USER_GR_ID, S.MNU_ID, 'Y'
            , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
        );
        
    --park.choyi 2026.04.21 ADMIN 권한 자동 부여 End
        
		COMMIT;	
	
	    OPEN O_RESULT_CURSOR FOR
	         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
	
		EXCEPTION
			WHEN EX_BIZ_EX THEN
				ROLLBACK;
			
		        OPEN O_RESULT_CURSOR FOR
		            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
		
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

	END SYS0003_SAVE_LEVEL_ONE_DATA;

	PROCEDURE SYS0003_SAVE_LEVEL_TWO_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	    EX_BIZ_EX       EXCEPTION;
		V_CHILD_CNT		NUMBER := 0;
		V_ERR_MSG 		VARCHAR2(4000);
		V_ROW_CNT 		NUMBER := 0;
	BEGIN
        
        -- DELETE할 메뉴 중 CHILD가 있는 경우 에러 보내주기
        SELECT	COUNT(*)
        INTO	V_CHILD_CNT
        FROM	JSON_TABLE(P_DATA, '$[*]'
            	COLUMNS (
                	V_CRUD_TYPE    		VARCHAR2(200) PATH '$.CRUD_TYPE',
                	V_MNU_ID    		VARCHAR2(200) PATH '$.MNU_ID'
            	)) A
	        INNER JOIN	SCM_ADM_MNU_M B
        		ON	TRIM(A.V_MNU_ID) = B.UPPR_MNU_ID -- park.choyi 2026.04.15 공백제거
		WHERE A.V_CRUD_TYPE = 'D'
		;
	
		IF (V_CHILD_CNT > 0) THEN
	        V_ERR_MSG     := '하위 메뉴가 존재하여 삭제가 불가합니다.';
	        RAISE EX_BIZ_EX;
	    END IF;
                  
		-- DELETE
		DELETE
		FROM	SCM_ADM_MNU_M
        WHERE	MNU_ID IN (
			SELECT TRIM(V_MNU_ID) -- park.choyi 2026.04.15 공백제거
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
	                V_CRUD_TYPE    		VARCHAR2(200) PATH '$.CRUD_TYPE',
                    V_MNU_ID    		VARCHAR2(200) PATH '$.MNU_ID'
                ))
			WHERE V_CRUD_TYPE = 'D'
        );
	   
		-- 삭제 건수 확인
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
	   
		-- MERGE
		MERGE INTO SCM_ADM_MNU_M T
        USING (
			SELECT -- park.choyi 2026.04.15 공백제거
                TRIM(V_CRUD_TYPE)    AS CRUD_TYPE,
                TRIM(V_LEVEL_ONE_MNU_ID) AS UPPR_MNU_ID,
                TRIM(V_MNU_ID)       AS MNU_ID,
                TRIM(V_MNU_MSG_ID)     AS MNU_MSG_ID,
                TRIM(V_MNU_DESC)       AS MNU_DESC,
                TRIM(V_MNU_URL)        AS MNU_URL,
                TRIM(V_SORT_ORD)       AS SORT_ORD,
                TRIM(V_USE_YN)       AS USE_YN
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 		VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_LEVEL_ONE_MNU_ID  VARCHAR2(200) PATH '$.LEVEL_ONE_MNU_ID',
                    V_MNU_ID    		VARCHAR2(200) PATH '$.MNU_ID',
                    V_MNU_MSG_ID    	VARCHAR2(200) PATH '$.MNU_MSG_ID',
                    V_MNU_DESC    		VARCHAR2(200) PATH '$.MNU_DESC',
                    V_MNU_URL    		VARCHAR2(200) PATH '$.MNU_URL',
                    V_SORT_ORD    		VARCHAR2(200) PATH '$.SORT_ORD',
                    V_USE_YN    		VARCHAR2(1)   PATH '$.USE_YN'
                ))
			WHERE V_CRUD_TYPE IN ('I', 'M')
        ) M
        ON (T.MNU_ID = M.MNU_ID AND M.CRUD_TYPE = 'M')
        WHEN MATCHED THEN
            UPDATE SET	T.MNU_MSG_ID 		= M.MNU_MSG_ID
            		  , T.MNU_DESC			= M.MNU_DESC
            		  , T.MNU_URL			= M.MNU_URL
            		  , T.SORT_ORD			= M.SORT_ORD
            		  , T.USE_YN			= M.USE_YN
            		  , T.LAST_UPDATED_BY 	= P_USER_ID
            		  , T.LAST_UPDATE_DATE 	= SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (MNU_ID
            	  , UPPR_MNU_ID
            	  , MNU_URL
            	  , MNU_MSG_ID
            	  , MNU_DESC
            	  , SORT_ORD
            	  , MNU_LV_NO
            	  , MNU_TP_CD
            	  , UNIT_TP_CD
            	  , USE_YN
            	  , CREATED_BY
            	  , CREATION_DATE
            	  , LAST_UPDATED_BY
            	  , LAST_UPDATE_DATE)
            VALUES (M.MNU_ID
            	  , M.UPPR_MNU_ID
           	 	  , M.MNU_URL
           	 	  , M.MNU_MSG_ID
           	 	  , M.MNU_DESC
           	 	  , M.SORT_ORD
           	 	  , 2
           	 	  , 'MENU'
           	 	  , '-'
           	 	  , M.USE_YN
           	 	  , P_USER_ID
           	 	  , SYSDATE
           	 	  , P_USER_ID
           	 	  , SYSDATE)
	    ;
	   
		-- 생성, 수정 건수 확인
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
		
    
    --park.choyi 2026.04.21 ADMIN 권한 자동 부여 Start
    MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
    USING (
        SELECT DISTINCT
               'ADMIN'      AS USER_GR_ID
             , J.V_MNU_ID   AS MNU_ID
        FROM JSON_TABLE(
                P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE   VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_MNU_ID      VARCHAR2(200) PATH '$.MNU_ID'
                )
             ) J
        WHERE TRIM(J.V_CRUD_TYPE) IN ('I', 'M')
          AND TRIM(J.V_MNU_ID) IS NOT NULL
    ) S
    ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID)
    WHEN MATCHED THEN
        UPDATE SET
              T.USE_YN           = 'Y'
            , T.LAST_UPDATED_BY  = P_USER_ID
            , T.LAST_UPDATE_DATE = SYSDATE
        WHERE NVL(T.USE_YN, '') <> 'Y'
    WHEN NOT MATCHED THEN
        INSERT (
              USER_GR_ID, MNU_ID, USE_YN
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        VALUES (
              S.USER_GR_ID, S.MNU_ID, 'Y'
            , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
        );
        
        
		COMMIT;	
	
	    OPEN O_RESULT_CURSOR FOR
	         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
	
		EXCEPTION
			WHEN EX_BIZ_EX THEN
				ROLLBACK;
			
		        OPEN O_RESULT_CURSOR FOR
		            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
		
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

	END SYS0003_SAVE_LEVEL_TWO_DATA;

	PROCEDURE SYS0003_SAVE_LEVEL_THREE_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
	) IS
		V_ROW_CNT 		NUMBER := 0;
		V_ERR_MSG 		VARCHAR2(4000);
	BEGIN
		
        -- DELETE
		DELETE
		FROM	SCM_ADM_MNU_M
        WHERE	MNU_ID IN (
            SELECT TRIM(V_MNU_ID) -- park.choyi 2026.04.15 공백제거
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
	                V_CRUD_TYPE    		VARCHAR2(200) PATH '$.CRUD_TYPE',
                    V_MNU_ID    		VARCHAR2(200) PATH '$.MNU_ID'
                ))
			WHERE V_CRUD_TYPE = 'D'
        );
       
		-- 삭제 건수 확인
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

		-- MERGE
		MERGE INTO SCM_ADM_MNU_M T
        USING (
			SELECT -- park.choyi 2026.04.15 공백제거
              TRIM(V_CRUD_TYPE)    AS CRUD_TYPE,
              TRIM(V_MNU_ID)       AS MNU_ID,
              TRIM(V_LEVEL_TWO_MNU_ID) AS UPPR_MNU_ID,
              TRIM(V_MNU_MSG_ID)     AS MNU_MSG_ID,
              TRIM(V_MNU_DESC)       AS MNU_DESC,
              TRIM(V_MNU_URL)        AS MNU_URL,
              TRIM(V_MNU_TP_CD)        AS MNU_TP_CD,
              TRIM(V_UNIT_TP_CD)     AS UNIT_TP_CD,
              TRIM(V_SORT_ORD)       AS SORT_ORD,
              TRIM(V_USE_YN)       AS USE_YN
	        FROM JSON_TABLE(P_DATA, '$[*]'
	            COLUMNS (
	                V_CRUD_TYPE 		VARCHAR2(20)  PATH '$.CRUD_TYPE',
	                V_LEVEL_TWO_MNU_ID  VARCHAR2(200) PATH '$.LEVEL_TWO_MNU_ID',
	                V_MNU_ID    		VARCHAR2(200) PATH '$.MNU_ID',
	                V_MNU_MSG_ID    	VARCHAR2(200) PATH '$.MNU_MSG_ID',
	                V_MNU_DESC    		VARCHAR2(200) PATH '$.MNU_DESC',
	                V_MNU_URL    		VARCHAR2(200) PATH '$.MNU_URL',
	                V_MNU_TP_CD    		VARCHAR2(200) PATH '$.MNU_TP_CD',
	                V_UNIT_TP_CD    	VARCHAR2(200) PATH '$.UNIT_TP_CD',
	                V_SORT_ORD    		VARCHAR2(200) PATH '$.SORT_ORD',
	                V_USE_YN    		VARCHAR2(1)   PATH '$.USE_YN'
	            ))
			WHERE V_CRUD_TYPE IN ('I', 'M')
        ) M
        ON (T.MNU_ID = M.MNU_ID AND M.CRUD_TYPE = 'M')
        WHEN MATCHED THEN
            UPDATE SET	T.MNU_MSG_ID 		= M.MNU_MSG_ID
            		  , T.MNU_DESC			= M.MNU_DESC
            		  , T.MNU_URL			= M.MNU_URL
            		  , T.SORT_ORD			= M.SORT_ORD
            		  , T.USE_YN			= M.USE_YN
                  , T.MNU_TP_CD   = M.MNU_TP_CD --park.choyi 2026.04.15 MNU_TP_CD 추가
                  , T.UNIT_TP_CD  = M.UNIT_TP_CD --park.choyi 2026.04.15 UNIT_TP_CD 추가
            		  , T.LAST_UPDATED_BY 	= P_USER_ID
            		  , T.LAST_UPDATE_DATE 	= SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (MNU_ID
            	  , UPPR_MNU_ID
            	  , MNU_URL
            	  , MNU_MSG_ID
            	  , MNU_DESC
            	  , SORT_ORD
            	  , MNU_LV_NO
            	  , MNU_TP_CD
            	  , UNIT_TP_CD
            	  , USE_YN
            	  , CREATED_BY
            	  , CREATION_DATE
            	  , LAST_UPDATED_BY
            	  , LAST_UPDATE_DATE)
            VALUES (M.MNU_ID
            	  , M.UPPR_MNU_ID
           	 	  , M.MNU_URL
           	 	  , M.MNU_MSG_ID
           	 	  , M.MNU_DESC
           	 	  , M.SORT_ORD
           	 	  , 3
           	 	  , M.MNU_TP_CD
           	 	  , M.UNIT_TP_CD
           	 	  , M.USE_YN
           	 	  , P_USER_ID
           	 	  , SYSDATE
           	 	  , P_USER_ID
           	 	  , SYSDATE)
	    ;
	   
		-- 생성, 수정 건수 확인
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
        
    --park.choyi 2026.04.15 메뉴 권한 자동 부여 Start
    MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
    USING (
        /* 1) POPUP 메뉴: 전체 그룹 권한 */
        SELECT DISTINCT
               G.USER_GR_ID
             , J.V_MNU_ID AS MNU_ID
        FROM SCM_ADM_USER_GR_M G
           , JSON_TABLE(
                P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE   VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_MNU_ID      VARCHAR2(200) PATH '$.MNU_ID',
                    V_MNU_TP_CD   VARCHAR2(200) PATH '$.MNU_TP_CD'
                )
             ) J
        WHERE TRIM(J.V_CRUD_TYPE) IN ( 'I' , 'M')
          AND TRIM(J.V_MNU_TP_CD) = 'POPUP'
          AND TRIM(J.V_MNU_ID) IS NOT NULL
          
        UNION ALL

        /* 2) 메뉴 타입 무관: ADMIN 항상 권한 */
        SELECT DISTINCT
               'ADMIN'      AS USER_GR_ID
             , J.V_MNU_ID   AS MNU_ID
        FROM JSON_TABLE(
                P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE   VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_MNU_ID      VARCHAR2(200) PATH '$.MNU_ID'
                )
             ) J
        WHERE TRIM(J.V_CRUD_TYPE) IN ('I', 'M')
          AND TRIM(J.V_MNU_ID) IS NOT NULL
    ) S
    ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID)
    WHEN MATCHED THEN
        UPDATE SET
              T.USE_YN           = 'Y'
            , T.LAST_UPDATED_BY  = P_USER_ID
            , T.LAST_UPDATE_DATE = SYSDATE
        WHERE NVL(T.USE_YN, '') <> 'Y'
    WHEN NOT MATCHED THEN
        INSERT (
              USER_GR_ID, MNU_ID, USE_YN
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        VALUES (
              S.USER_GR_ID, S.MNU_ID, 'Y'
            , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
        );
        
        
    /* 메뉴 삭제(D) 대상의 모든 그룹 권한 삭제 */
    DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M T
    WHERE T.MNU_ID IN (
        SELECT DISTINCT J.V_MNU_ID
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_CRUD_TYPE VARCHAR2(20)  PATH '$.CRUD_TYPE',
                V_MNU_ID    VARCHAR2(200) PATH '$.MNU_ID'
            )
        ) J
        WHERE TRIM(J.V_CRUD_TYPE) = 'D'
          AND TRIM(J.V_MNU_ID) IS NOT NULL
    );
        
    --park.choyi 2026.04.15 메뉴 권한 자동 부여 End
    
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

	END SYS0003_SAVE_LEVEL_THREE_DATA;

END PKG_SYS0003;
/
