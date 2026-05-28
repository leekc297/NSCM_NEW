/*=============================================================================================
 * File         : 04_Package_PKG_SYS0009.sql
 * Description  : Package — PKG_SYS0009
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0009 AS

	-- Menu Button search
    PROCEDURE SYS0009_GET_MAIN_DATA (
		P_MNU_ID		IN      VARCHAR2,	
		P_SHT_NM		IN      VARCHAR2,
		P_MNU_BTN_CD	IN      VARCHAR2,
		P_API_NM		IN      VARCHAR2,
		P_USE_YN		IN      VARCHAR2,
		P_LANG_CD		IN 		VARCHAR2,
		
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );
   
   
   	-- Menu Button save
	PROCEDURE SYS0009_SAVE_MAIN_DATA (
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	);

END PKG_SYS0009;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0009
AS

	PROCEDURE SYS0009_GET_MAIN_DATA (
		P_MNU_ID		IN      VARCHAR2,	
		P_SHT_NM		IN      VARCHAR2,
		P_MNU_BTN_CD	IN      VARCHAR2,
		P_API_NM		IN      VARCHAR2,
		P_USE_YN		IN      VARCHAR2,
		P_LANG_CD		IN 		VARCHAR2,
		
		O_CURSOR		OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    ) IS
	
    	V_ROW_CNT	NUMBER := 0;
    	V_ERR_MSG 	VARCHAR2(4000);

	BEGIN
		
		OPEN O_CURSOR FOR
			SELECT  *
			  FROM  (SELECT  NVL(MNU.MNU_ID, 'Delete '|| T.MNU_ID) MNU_ID, NVL(MSG.MSG_NM, MNU.MNU_DESC) MNU_NM
			  			   , T.SHT_NM, T.MNU_BTN_CD
			  			   , NVL(API.API_ID, 'Delete '|| T.API_ID) API_ID
			  			   , NVL(API_MSG.MSG_NM, API.API_MSG_DESC) API_NM
				    	   , T.USE_YN , T.CREATED_BY, T.CREATION_DATE, T.LAST_UPDATED_BY, T.LAST_UPDATE_DATE
				       FROM  SCM_ADM_MNU_BTN_MPG_M T
				  LEFT JOIN  SCM_ADM_MNU_M MNU
				         ON  T.MNU_ID = MNU.MNU_ID
				        --AND  MNU.MNU_TP_CD = 'SCREEN' --park.choyi 2026.04.15 SCREEN 조건 제외 (Popup 포함)
				  LEFT JOIN  SCM_ADM_MSG_M MSG
				         ON  MNU.MNU_MSG_ID = MSG.MSG_ID
				        AND  MSG.LANG_CD = P_LANG_CD
				  LEFT JOIN  SCM_ADM_API_M API 
				         ON  T.API_ID = API.API_ID
				  LEFT JOIN  SCM_ADM_MSG_M API_MSG
				         ON  API.API_MSG_ID = API_MSG.MSG_ID
				        AND  API_MSG.LANG_CD = P_LANG_CD
				      --WHERE  MSG.LANG_CD = P_LANG_CD
              ) TT
			  WHERE  1=1
			    AND  (NVL(P_MNU_ID, 'ALL') = 'ALL' OR TT.MNU_ID IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_MNU_ID, ','))))
			    AND  TT.SHT_NM LIKE '%'|| P_SHT_NM ||'%'
			    AND  (NVL(P_API_NM, 'ALL') = 'ALL' OR TT.API_NM LIKE '%'|| P_API_NM ||'%')
			    AND  (NVL(P_MNU_BTN_CD, 'ALL') = 'ALL' OR TT.MNU_BTN_CD IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_MNU_BTN_CD, ','))))
			    AND  (NVL(P_USE_YN, 'ALL') = 'ALL' OR TT.USE_YN = NVL(P_USE_YN, TT.USE_YN))
           ORDER BY  MNU_ID, 2,3,4;
				
	 	OPEN O_RESULT_CURSOR FOR      
			SELECT '0' CODE, 'SUSSESS' MSG, V_ROW_CNT EVENT FROM DUAL;
		
	EXCEPTION
	  WHEN OTHERS THEN
	    RAISE_APPLICATION_ERROR(-20001,
	      ' SQLCODE=' || SQLCODE ||
	      ' / SQLERRM=' || SQLERRM 
	    );
	    RAISE;
		
	END;



	PROCEDURE SYS0009_SAVE_MAIN_DATA (
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS 

		V_ROW_CNT	NUMBER := 0;
		V_ROW_CNT2	NUMBER := 0;
		V_ERR_MSG 	VARCHAR2(4000);
	
	BEGIN
		
		-- 삭제 
		DELETE SCM_ADM_MNU_BTN_MPG_M
		WHERE MNU_ID||SHT_NM||MNU_BTN_CD IN (SELECT  V_MNU_ID || V_SHT_NM || V_MNU_BTN_CD
						   FROM  JSON_TABLE(P_DATA, '$[*]'
						    	 	COLUMNS (
						    	 		V_CRUD_TYPE VARCHAR(10) PATH '$."CRUD_TYPE"',
						    	 		V_MNU_ID VARCHAR(100) PATH '$."MNU_ID"',
						    	 		V_SHT_NM VARCHAR(150) PATH '$."SHT_NM"',
						    	 		V_MNU_BTN_CD VARCHAR(150) PATH '$."MNU_BTN_CD"',
						    	 		V_USE_YN VARCHAR(10) PATH '$."USE_YN"'
						    	 	))
			    	 	   WHERE  V_CRUD_TYPE = 'D');
			    	 
		V_ROW_CNT := SQL%ROWCOUNT;
	
		
		MERGE INTO  SCM_ADM_MNU_BTN_MPG_M TGT
			 USING  ( SELECT  V_CRUD_TYPE CRUD_TYPE
			 				, V_MNU_ID MNU_ID
			                , V_SHT_NM SHT_NM
			                , V_MNU_BTN_CD MNU_BTN_CD
			                , V_API_ID API_ID
			                , V_USE_YN USE_YN
			                , P_USER_ID USER_ID
						FROM JSON_TABLE(P_DATA, '$[*]'
			    	 	COLUMNS (
			    	 		V_CRUD_TYPE VARCHAR(10) PATH '$."CRUD_TYPE"',
			    	 		V_MNU_ID VARCHAR(100) PATH '$."MNU_ID"',
						    V_SHT_NM VARCHAR(150) PATH '$."SHT_NM"',
						    V_MNU_BTN_CD VARCHAR(150) PATH '$."MNU_BTN_CD"',
						    V_API_ID VARCHAR(150) PATH '$."API_ID"',
			    	 		V_USE_YN VARCHAR(10) PATH '$."USE_YN"'
			    	 	))
			    	 	WHERE V_CRUD_TYPE IN ('M', 'I')
			    	 	) SRC
		        ON  (TGT.MNU_ID = SRC.MNU_ID
		        	AND TGT.SHT_NM = SRC.SHT_NM
		        	AND TGT.MNU_BTN_CD = SRC.MNU_BTN_CD)
		WHEN MATCHED THEN
	  			UPDATE SET
	  				TGT.API_ID = SRC.API_ID
	  				, TGT.USE_YN = SRC.USE_YN
	  				, TGT.LAST_UPDATED_BY = SRC.USER_ID
	  				, TGT.LAST_UPDATE_DATE = SYSDATE	
  			  				
		WHEN NOT MATCHED THEN 
				INSERT (MNU_ID, SHT_NM, MNU_BTN_CD,  API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) 
				VALUES (SRC.MNU_ID, SRC.SHT_NM, SRC.MNU_BTN_CD, SRC.API_ID, SRC.USE_YN, SRC.USER_ID, SYSDATE, SRC.USER_ID, SYSDATE);
			
		V_ROW_CNT2 := SQL%ROWCOUNT;
		
		--park.choyi 2026.04.16 Sheet, Button 권한 자동 부여 Start
    MERGE INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M TGT
    USING (
        /* 1) 일반 메뉴: 메뉴권한(Y) 있는 그룹만 */
        SELECT DISTINCT
               UG.USER_GR_ID  AS USER_GR_ID
             , S.V_MNU_ID     AS MNU_ID
             , S.V_SHT_NM     AS SHT_NM
             , S.V_MNU_BTN_CD AS MNU_BTN_CD
             , S.V_USE_YN     AS USE_YN
             , P_USER_ID      AS USER_ID
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_CRUD_TYPE   VARCHAR2(10)  PATH '$.CRUD_TYPE',
                V_MNU_ID      VARCHAR2(100) PATH '$.MNU_ID',
                V_SHT_NM      VARCHAR2(150) PATH '$.SHT_NM',
                V_MNU_BTN_CD  VARCHAR2(150) PATH '$.MNU_BTN_CD',
                V_USE_YN      VARCHAR2(10)  PATH '$.USE_YN'
            )
        ) S
        JOIN SCM_ADM_MNU_M MN
          ON MN.MNU_ID = S.V_MNU_ID
        JOIN SCM_ADM_USER_GR_MNU_MPG_M UG
          ON UG.MNU_ID = S.V_MNU_ID
         AND UG.USE_YN = 'Y'
        WHERE S.V_CRUD_TYPE IN ('I', 'M')
          AND NVL(UPPER(TRIM(MN.MNU_TP_CD)), 'NORMAL') <> 'POPUP'
          AND TRIM(S.V_MNU_ID) IS NOT NULL
          AND TRIM(S.V_SHT_NM) IS NOT NULL
          AND TRIM(S.V_MNU_BTN_CD) IS NOT NULL

        UNION ALL

        /* 2) POPUP 메뉴: 전체 그룹 */
        SELECT DISTINCT
               G.USER_GR_ID   AS USER_GR_ID
             , S.V_MNU_ID     AS MNU_ID
             , S.V_SHT_NM     AS SHT_NM
             , S.V_MNU_BTN_CD AS MNU_BTN_CD
             , S.V_USE_YN     AS USE_YN
             , P_USER_ID      AS USER_ID
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_CRUD_TYPE   VARCHAR2(10)  PATH '$.CRUD_TYPE',
                V_MNU_ID      VARCHAR2(100) PATH '$.MNU_ID',
                V_SHT_NM      VARCHAR2(150) PATH '$.SHT_NM',
                V_MNU_BTN_CD  VARCHAR2(150) PATH '$.MNU_BTN_CD',
                V_USE_YN      VARCHAR2(10)  PATH '$.USE_YN'
            )
        ) S
        JOIN SCM_ADM_MNU_M MN
          ON MN.MNU_ID = S.V_MNU_ID
        JOIN SCM_ADM_USER_GR_M G
          ON 1 = 1
        WHERE S.V_CRUD_TYPE IN ('I', 'M')
          AND NVL(UPPER(TRIM(MN.MNU_TP_CD)), 'SCREEN') = 'POPUP'
          AND TRIM(S.V_MNU_ID) IS NOT NULL
          AND TRIM(S.V_SHT_NM) IS NOT NULL
          AND TRIM(S.V_MNU_BTN_CD) IS NOT NULL
    ) SRC
    ON (    TGT.USER_GR_ID = SRC.USER_GR_ID
        AND TGT.MNU_ID     = SRC.MNU_ID
        AND TGT.SHT_NM     = SRC.SHT_NM
        AND TGT.MNU_BTN_CD = SRC.MNU_BTN_CD)
    WHEN MATCHED THEN
        UPDATE SET
              TGT.USE_YN           = SRC.USE_YN
            , TGT.LAST_UPDATED_BY  = SRC.USER_ID
            , TGT.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (
              USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        VALUES (
              SRC.USER_GR_ID, SRC.MNU_ID, SRC.SHT_NM, SRC.MNU_BTN_CD, SRC.USE_YN
            , SRC.USER_ID, SYSDATE, SRC.USER_ID, SYSDATE
        );
    
    
		--park.choyi 2026.04.16 Sheet, Button 권한 자동 부여 End
    
		COMMIT;	
    
		OPEN O_RESULT_CURSOR FOR
		 SELECT '0' CODE, 'SUSSESS' MSG, V_ROW_CNT+V_ROW_CNT2 EVENT FROM DUAL;
		   
	EXCEPTION
	  WHEN OTHERS THEN
	    RAISE_APPLICATION_ERROR(-20001,
	      ' SQLCODE=' || SQLCODE ||
	      ' / SQLERRM=' || SQLERRM 
	    );
	    RAISE;	     
	     
	END;

END PKG_SYS0009;
/
