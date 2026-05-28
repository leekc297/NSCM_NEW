/*=============================================================================================
 * File         : 04_Package_PKG_SYS0008.sql
 * Description  : Package — PKG_SYS0008
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
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0008
AS

    PROCEDURE SYS0008_GET_USER_GR_DATA (
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );

    PROCEDURE SYS0008_GET_MNU_AUTH_DATA (
    	P_USER_GR_ID	IN		VARCHAR2,
    	P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );
   
    PROCEDURE SYS0008_GET_BTN_AUTH_DATA (
    	P_USER_GR_ID	IN		VARCHAR2,
    	P_MNU_ID		IN		VARCHAR2,
    	P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );
   
    PROCEDURE SYS0008_SAVE_MNU_AUTH_DATA (
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );
   
    PROCEDURE SYS0008_SAVE_BTN_AUTH_DATA (
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );

END PKG_SYS0008;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0008
AS

	PROCEDURE SYS0008_GET_USER_GR_DATA (
	    O_CURSOR        OUT     SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	BEGIN

		OPEN O_CURSOR FOR
			SELECT	G.USER_GR_ID
				  , G.USER_GR_NM
			FROM	SCM_ADM_USER_GR_M G
			WHERE 	G.USE_YN = 'Y'
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
	
	END SYS0008_GET_USER_GR_DATA;

	PROCEDURE SYS0008_GET_MNU_AUTH_DATA (
    	P_USER_GR_ID	IN		VARCHAR2,
    	P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	BEGIN

		OPEN O_CURSOR FOR
			SELECT	P_USER_GR_ID AS USER_GR_ID
				  , LV1.MNU_ID 	AS LEVEL_ONE_MNU_ID
				  , LV2.MNU_ID 	AS LEVEL_TWO_MNU_ID
				  , LV3.MNU_ID 	AS MNU_ID
				  , M3.MSG_NM 	AS MNU_MSG_NM
				  , NVL(GM.USE_YN, '') AS MNU_AUTH_YN  --, NVL2(GM.USER_GR_ID, 'Y', '') AS MNU_AUTH_YN --park.choyi 2026.04.15 USE_YN으로 관리
				  , GM.CREATED_BY
				  , GM.CREATION_DATE
				  , GM.LAST_UPDATED_BY
				  , GM.LAST_UPDATE_DATE
			FROM	SCM_ADM_MNU_M LV3
				INNER JOIN SCM_ADM_MNU_M LV2
					ON	LV3.UPPR_MNU_ID = LV2.MNU_ID
				INNER JOIN SCM_ADM_MNU_M LV1
					ON	LV2.UPPR_MNU_ID = LV1.MNU_ID
				LEFT JOIN SCM_ADM_MSG_M M3
					ON	LV3.MNU_MSG_ID = M3.MSG_ID 
					AND M3.USE_YN = 'Y'
					AND M3.LANG_CD = P_LANG_CD
				LEFT JOIN SCM_ADM_USER_GR_MNU_MPG_M GM
					ON  LV3.MNU_ID = GM.MNU_ID
					AND GM.USER_GR_ID = P_USER_GR_ID
			WHERE	1=1
			AND		LV3.MNU_LV_NO = '3'
			AND		LV3.USE_YN = 'Y'
			AND		LV2.USE_YN = 'Y'
			AND		LV1.USE_YN = 'Y'
      
			ORDER BY LV1.SORT_ORD , LV2.SORT_ORD, LV3.SORT_ORD
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
	
	END SYS0008_GET_MNU_AUTH_DATA;

	PROCEDURE SYS0008_GET_BTN_AUTH_DATA (
		P_USER_GR_ID	IN		VARCHAR2,
    	P_MNU_ID		IN		VARCHAR2,
    	P_LANG_CD		IN		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	BEGIN

		OPEN O_CURSOR FOR
			SELECT	P_USER_GR_ID 					AS USER_GR_ID
				  , MB.MNU_ID
				  , M.MSG_NM						AS MNU_MSG_NM
				  , MB.SHT_NM
				  , MB.MNU_BTN_CD
				  , NVL(GMB.USE_YN, '') AS BTN_AUTH_YN --, NVL2(GMB.USER_GR_ID, 'Y', '')	AS BTN_AUTH_YN --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
				  , GMB.CREATED_BY
				  , GMB.CREATION_DATE
				  , GMB.LAST_UPDATED_BY
				  , GMB.LAST_UPDATE_DATE
			FROM	SCM_ADM_MNU_BTN_MPG_M MB
				INNER JOIN SCM_ADM_MNU_M MN
					ON	MB.MNU_ID = MN.MNU_ID 
				LEFT JOIN SCM_ADM_MSG_M M
					ON	MN.MNU_MSG_ID = M.MSG_ID 
         AND	M.USE_YN = 'Y'           --park.choyi 2026.04.03 Join 문으로 이동
         AND	M.LANG_CD = P_LANG_CD    --park.choyi 2026.04.03 Join 문으로 이동
				LEFT JOIN SCM_ADM_USER_GR_MNU_BTN_MPG_M GMB
					ON	MB.MNU_ID = GMB.MNU_ID
					AND MB.SHT_NM = GMB.SHT_NM
					AND MB.MNU_BTN_CD = GMB.MNU_BTN_CD 
					AND	GMB.USER_GR_ID = P_USER_GR_ID
			WHERE	1=1
			AND		MN.USE_YN = 'Y'
			--AND		M.USE_YN = 'Y'                    --park.choyi 2026.04.03 Join 문으로 이동
			--AND		M.LANG_CD = P_LANG_CD             --park.choyi 2026.04.03 Join 문으로 이동
			AND 	MB.MNU_ID = P_MNU_ID
			ORDER BY MB.MNU_ID, M.MSG_NM, MB.SHT_NM, MB.MNU_BTN_CD
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
	
	END SYS0008_GET_BTN_AUTH_DATA;

	PROCEDURE SYS0008_SAVE_MNU_AUTH_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	    EX_BIZ_EX       EXCEPTION;
		V_BTN_AUTH_CNT	NUMBER := 0;
		V_ERR_MSG 		VARCHAR2(4000);
		V_ROW_CNT		NUMBER := 0;
	BEGIN
		
		-- 메뉴 권한을 회수하려는데, 버튼 권한이 있는 경우 체크
        SELECT	COUNT(*)
        INTO	V_BTN_AUTH_CNT
        FROM	JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_MNU_ID    	VARCHAR2(200) PATH '$.MNU_ID',
                    V_MNU_AUTH_YN   VARCHAR2(1)   PATH '$.MNU_AUTH_YN'
                )) A
	        INNER JOIN	SCM_ADM_USER_GR_MNU_BTN_MPG_M B
        		ON	A.V_USER_GR_ID = B.USER_GR_ID
        		AND A.V_MNU_ID = B.MNU_ID
            AND B.USE_YN = 'Y' --park.choyi 2026.04.15 USE_YN이 'Y'인 대상만 권한 확인
		WHERE A.V_CRUD_TYPE = 'M'
		AND	  A.V_MNU_AUTH_YN = ''
		;
	
		IF (V_BTN_AUTH_CNT > 0) THEN
		    V_ERR_MSG := '버튼 권한을 먼저 회수하고 상위 메뉴 권한을 회수하세요.';
	        RAISE EX_BIZ_EX;
	    END IF;
		
    --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
    /*
		DELETE
		FROM	SCM_ADM_USER_GR_MNU_MPG_M
        WHERE	(USER_GR_ID, MNU_ID) IN (
			SELECT V_USER_GR_ID, V_MNU_ID
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_MNU_ID    	VARCHAR2(200) PATH '$.MNU_ID',
                    V_MNU_AUTH_YN   VARCHAR2(1)   PATH '$.MNU_AUTH_YN'
                ))
			WHERE V_CRUD_TYPE = 'M'
			AND	  V_MNU_AUTH_YN = '' -- 권한 삭제
        );
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
		*/

		MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
        USING (
			SELECT V_USER_GR_ID	AS USER_GR_ID
				 , V_MNU_ID		AS MNU_ID
         , V_MNU_AUTH_YN	AS MNU_AUTH_YN --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_MNU_ID    	VARCHAR2(200) PATH '$.MNU_ID',
                    V_MNU_AUTH_YN   VARCHAR2(1)   PATH '$.MNU_AUTH_YN'
                ))
			WHERE V_CRUD_TYPE = 'M'
			--AND	  V_MNU_AUTH_YN = 'Y' -- 권한 추가 --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
        ) M
        ON (T.USER_GR_ID = M.USER_GR_ID AND T.MNU_ID = M.MNU_ID)
        WHEN MATCHED THEN --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
            UPDATE
               SET T.USE_YN           = M.MNU_AUTH_YN
                 , T.LAST_UPDATED_BY  = P_USER_ID
                 , T.LAST_UPDATE_DATE = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (USER_GR_ID
            	  , MNU_ID
            	  , USE_YN
            	  , CREATED_BY
            	  , CREATION_DATE
            	  , LAST_UPDATED_BY
            	  , LAST_UPDATE_DATE)
            VALUES (M.USER_GR_ID
           	 	  , M.MNU_ID
           	 	  , 'Y'
           	 	  , P_USER_ID
           	 	  , SYSDATE
           	 	  , P_USER_ID
           	 	  , SYSDATE)
	    ;
	   
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    --park.choyi 2026.04.15 상위(1/2레벨) 권한 관리 Start
    /* 3레벨 권한 부여 시 상위(1/2레벨) 자동 부여 */
    MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
    USING (
        SELECT DISTINCT V_USER_GR_ID AS USER_GR_ID
             , LEVEL_ONE_MNU_ID      AS MNU_ID
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_CRUD_TYPE           VARCHAR2(20)  PATH '$.CRUD_TYPE',
                V_USER_GR_ID          VARCHAR2(200) PATH '$.USER_GR_ID',
                V_MNU_AUTH_YN         VARCHAR2(1)   PATH '$.MNU_AUTH_YN',
                LEVEL_ONE_MNU_ID      VARCHAR2(200) PATH '$.LEVEL_ONE_MNU_ID'
            )
        )
        WHERE V_CRUD_TYPE = 'M'
          AND V_MNU_AUTH_YN = 'Y'
          AND TRIM(LEVEL_ONE_MNU_ID) IS NOT NULL

        UNION

        SELECT DISTINCT V_USER_GR_ID AS USER_GR_ID
             , LEVEL_TWO_MNU_ID      AS MNU_ID
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_CRUD_TYPE           VARCHAR2(20)  PATH '$.CRUD_TYPE',
                V_USER_GR_ID          VARCHAR2(200) PATH '$.USER_GR_ID',
                V_MNU_AUTH_YN         VARCHAR2(1)   PATH '$.MNU_AUTH_YN',
                LEVEL_TWO_MNU_ID      VARCHAR2(200) PATH '$.LEVEL_TWO_MNU_ID'
            )
        )
        WHERE V_CRUD_TYPE = 'M'
          AND V_MNU_AUTH_YN = 'Y'
          AND TRIM(LEVEL_TWO_MNU_ID) IS NOT NULL
    ) P
    ON (T.USER_GR_ID = P.USER_GR_ID AND T.MNU_ID = P.MNU_ID)
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
              P.USER_GR_ID, P.MNU_ID, 'Y'
            , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
        );


		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
    
    /* 2레벨 회수: 해당 2레벨 하위 3레벨 권한(Y)이 더 이상 없으면 N */
    UPDATE SCM_ADM_USER_GR_MNU_MPG_M P2
       SET P2.USE_YN           = ''
         , P2.LAST_UPDATED_BY  = P_USER_ID
         , P2.LAST_UPDATE_DATE = SYSDATE
     WHERE EXISTS (
            SELECT 1
            FROM JSON_TABLE(
                P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE         VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID        VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_MNU_AUTH_YN       VARCHAR2(1)   PATH '$.MNU_AUTH_YN',
                    LEVEL_TWO_MNU_ID    VARCHAR2(200) PATH '$.LEVEL_TWO_MNU_ID'
                )
            ) J
            WHERE J.V_CRUD_TYPE = 'M'
              AND J.V_MNU_AUTH_YN = ''
              AND J.V_USER_GR_ID = P2.USER_GR_ID
              AND J.LEVEL_TWO_MNU_ID = P2.MNU_ID
        )
       AND NOT EXISTS (
            SELECT 1
            FROM SCM_ADM_MNU_M C3
            JOIN SCM_ADM_USER_GR_MNU_MPG_M M3
              ON M3.MNU_ID = C3.MNU_ID
             AND M3.USER_GR_ID = P2.USER_GR_ID
             AND M3.USE_YN = 'Y'
            WHERE C3.UPPR_MNU_ID = P2.MNU_ID
        );
        
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    /* 1레벨 회수: 해당 1레벨 하위 2레벨 권한(Y)이 더 이상 없으면 N */
    UPDATE SCM_ADM_USER_GR_MNU_MPG_M P1
       SET P1.USE_YN           = ''
         , P1.LAST_UPDATED_BY  = P_USER_ID
         , P1.LAST_UPDATE_DATE = SYSDATE
     WHERE EXISTS (
            SELECT 1
            FROM JSON_TABLE(
                P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE         VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID        VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_MNU_AUTH_YN       VARCHAR2(1)   PATH '$.MNU_AUTH_YN',
                    LEVEL_ONE_MNU_ID    VARCHAR2(200) PATH '$.LEVEL_ONE_MNU_ID'
                )
            ) J
            WHERE J.V_CRUD_TYPE = 'M'
              AND J.V_MNU_AUTH_YN = ''
              AND J.V_USER_GR_ID = P1.USER_GR_ID
              AND J.LEVEL_ONE_MNU_ID = P1.MNU_ID
        )
       AND NOT EXISTS (
            SELECT 1
            FROM SCM_ADM_MNU_M C2
            JOIN SCM_ADM_USER_GR_MNU_MPG_M M2
              ON M2.MNU_ID = C2.MNU_ID
             AND M2.USER_GR_ID = P1.USER_GR_ID
             AND M2.USE_YN = 'Y'
            WHERE C2.UPPR_MNU_ID = P1.MNU_ID
        );
        
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
    
    --park.choyi 2026.04.15 상위(1/2레벨) 권한 관리 End
    
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
		
	END SYS0008_SAVE_MNU_AUTH_DATA;

	PROCEDURE SYS0008_SAVE_BTN_AUTH_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	    EX_BIZ_EX       	EXCEPTION;
		V_MNU_AUTH_NULL_CNT	NUMBER := 0;
		V_ERR_MSG 			VARCHAR2(4000);
		V_ROW_CNT			NUMBER := 0;
	BEGIN
		
		-- 버튼 권한을 부여하려는데, 메뉴 권한이 없는 경우 체크
		SELECT  COUNT(*)
		INTO    V_MNU_AUTH_NULL_CNT
		FROM    JSON_TABLE(P_DATA, '$[*]'
		            COLUMNS (
		                V_CRUD_TYPE     VARCHAR2(20)  PATH '$.CRUD_TYPE',
		                V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
		                V_MNU_ID        VARCHAR2(200) PATH '$.MNU_ID',
		                V_BTN_AUTH_YN   VARCHAR2(1)   PATH '$.BTN_AUTH_YN'
		            )) A
		LEFT OUTER JOIN SCM_ADM_USER_GR_MNU_MPG_M B
		    ON  A.V_USER_GR_ID = B.USER_GR_ID
		    AND A.V_MNU_ID = B.MNU_ID
		WHERE A.V_CRUD_TYPE = 'M'
		AND   A.V_BTN_AUTH_YN = 'Y'
		AND   B.USER_GR_ID IS NULL
		;
		
		IF (V_MNU_AUTH_NULL_CNT > 0) THEN
		    V_ERR_MSG := '메뉴 권한을 먼저 부여하고 하위 버튼 권한을 부여하세요.';
		    RAISE EX_BIZ_EX;
		END IF;
		
    --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
    /*
		DELETE
		FROM	SCM_ADM_USER_GR_MNU_BTN_MPG_M
        WHERE	(USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD) IN (
			SELECT V_USER_GR_ID, V_MNU_ID, V_SHT_NM, V_MNU_BTN_CD
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_MNU_ID    	VARCHAR2(200) PATH '$.MNU_ID',
                    V_SHT_NM    	VARCHAR2(200) PATH '$.SHT_NM',
                    V_MNU_BTN_CD    VARCHAR2(200) PATH '$.MNU_BTN_CD',
                    V_BTN_AUTH_YN   VARCHAR2(1)   PATH '$.BTN_AUTH_YN'
                ))
			WHERE V_CRUD_TYPE = 'M'
			AND	  V_BTN_AUTH_YN = '' -- 권한 삭제
        );
			    
		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
    */
		MERGE INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M T
        USING (
			SELECT V_USER_GR_ID	AS USER_GR_ID
				 , V_MNU_ID		AS MNU_ID
				 , V_SHT_NM		AS SHT_NM
				 , V_MNU_BTN_CD	AS MNU_BTN_CD
				 , V_BTN_AUTH_YN	AS BTN_AUTH_YN --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_MNU_ID    	VARCHAR2(200) PATH '$.MNU_ID',
                    V_SHT_NM    	VARCHAR2(200) PATH '$.SHT_NM',
                    V_MNU_BTN_CD    VARCHAR2(200) PATH '$.MNU_BTN_CD',
                    V_BTN_AUTH_YN   VARCHAR2(1)   PATH '$.BTN_AUTH_YN'
                ))
			WHERE V_CRUD_TYPE = 'M'
			--AND	  V_BTN_AUTH_YN = 'Y' -- 권한 추가 --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
        ) M
        ON (T.USER_GR_ID = M.USER_GR_ID AND T.MNU_ID = M.MNU_ID AND T.SHT_NM = M.SHT_NM AND T.MNU_BTN_CD = M.MNU_BTN_CD)
        WHEN MATCHED THEN --park.choyi 2026.04.13 권한 DELETE 대신 USE_YN으로 관리
            UPDATE
               SET T.USE_YN           = M.BTN_AUTH_YN
                 , T.LAST_UPDATED_BY  = P_USER_ID
                 , T.LAST_UPDATE_DATE = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (USER_GR_ID
            	  , MNU_ID
            	  , SHT_NM
            	  , MNU_BTN_CD
            	  , USE_YN
            	  , CREATED_BY
            	  , CREATION_DATE
            	  , LAST_UPDATED_BY
            	  , LAST_UPDATE_DATE)
            VALUES (M.USER_GR_ID
           	 	  , M.MNU_ID
           	 	  , M.SHT_NM
           	 	  , M.MNU_BTN_CD
           	 	  , 'Y'
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
		
	END SYS0008_SAVE_BTN_AUTH_DATA;

END PKG_SYS0008;
/
