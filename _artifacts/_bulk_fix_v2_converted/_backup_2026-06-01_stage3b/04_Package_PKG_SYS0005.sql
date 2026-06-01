/*=============================================================================================
 * File         : 04_Package_PKG_SYS0005.sql
 * Description  : Package — PKG_SYS0005
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0005 AS

	-- 프로시저 목록조회
    PROCEDURE SYS0005_GET_MAIN_DATA (
    	P_SCHEMA			IN		VARCHAR2,
		P_PROC_NM			IN 		VARCHAR2,
		P_UPDATE_YN			IN 		VARCHAR2,
		
		O_CURSOR			OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
    );
   
    PROCEDURE SYS0005_SAVE_MAIN_DATA_BLK (
    	P_DATA				IN 		CLOB,
		P_USER_ID			IN 		VARCHAR2,
		
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
    );
   
    -- 프로시저 항목 조회
    PROCEDURE SYS0005_GET_PROC_DATA (
        P_OWNER				IN 		VARCHAR2,
		P_PROC_NM			IN 		VARCHAR2,
		P_IS_YN				IN 		VARCHAR2,
		
		O_CURSOR			OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
    );

	-- 프로시저 항목 저장
	PROCEDURE SYS0005_SAVE_PROC_DATA_BLK (
		P_DATA				IN 		CLOB,
		P_USER_ID			IN 		VARCHAR2,
		
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
	);

END PKG_SYS0005;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0005
AS

--====================================================================================================================

	PROCEDURE SYS0005_GET_MAIN_DATA (
		P_SCHEMA			IN		VARCHAR2,
		P_PROC_NM			IN 		VARCHAR2,
		P_UPDATE_YN			IN 		VARCHAR2,
		
		O_CURSOR			OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
	) IS
	
		V_ERR_MSG 	VARCHAR2(4000);
	BEGIN
		
		OPEN O_CURSOR FOR
			SELECT * FROM (
		 	SELECT  MAX(CASE 
		    		  WHEN NVL(PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(PROC.DATA_TP_CD),'X') <> NVL(DB.DB_DATA_TP_CD,'X') THEN 'Y'
		    		  WHEN NVL(PROC.SORT_ORD,0) <> NVL(DB.DB_SORT_ORD,0) THEN 'Y'
		    		  WHEN NVL(PROC.COL_TP_CD,'X') <> NVL(DB.DB_COL_TP_CD,'X') THEN 'Y'
		    		  ELSE ''
		    		END) AS UPDATE_YN
		    	  , DB.OWNER	
		    	  , DB.DB_PROC_NM AS PROC_NM
            , NVL2(PROC.PROC_NM, 'Y', '') AS IS_YN
            , MAX(CREATED_BY) AS CREATED_BY
            , MAX(PROC.CREATION_DATE) AS CREATION_DATE
            , MAX(PROC.LAST_UPDATED_BY) AS LAST_UPDATED_BY
            , MAX(PROC.LAST_UPDATE_DATE)  LAST_UPDATE_DATE
		      FROM  (SELECT  OWNER  
		      			   , NVL2(PACKAGE_NAME, PACKAGE_NAME||'.'||OBJECT_NAME, OBJECT_NAME) DB_PROC_NM
		                   , POSITION DB_SORT_ORD
		                   , DECODE(ARGUMENT_NAME, 'O_RESULT_CURSOR','PROC_RESULT', PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(DATA_TYPE)) DB_DATA_TP_CD
		                   , IN_OUT DB_COL_TP_CD
		               FROM  ALL_ARGUMENTS 
		              WHERE  1=1 --TRIM(NVL2(PACKAGE_NAME, PACKAGE_NAME||'.'||OBJECT_NAME, OBJECT_NAME)) IN (SELECT TRIM(PROC_NM) FROM SCM_ADM_PROC_M ) --park.choyi 2026.04.13 UI PKG는 Lookup으로 관리
                    AND EXISTS (
                        SELECT 1
                        FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE L.LOOKUP_TYPE = 'UI_PKG_NM'
                          AND L.VALID_YN = 'Y'
                          AND OWNER = TRIM(L.SEGMENT1)
                          AND PACKAGE_NAME LIKE TRIM(L.SEGMENT2) || '%' )
		                AND  TYPE_OBJECT_TYPE IS NULL) DB
		 LEFT JOIN  (SELECT PROC_NM, DATA_TP_CD, COL_TP_CD, ROW_NUMBER() OVER (PARTITION BY PROC_NM ORDER BY SORT_ORD ASC) SORT_ORD 
                       , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                   FROM  SCM_ADM_PROC_M) PROC
			    ON  DB.DB_PROC_NM = NVL(PROC.PROC_NM, DB.DB_PROC_NM)
			   AND  DB.DB_SORT_ORD = PROC.SORT_ORD
			 WHERE  1=1
--			   AND  DB.OWNER = NVL(P_SCHEMA, DB.OWNER)
			   AND  (NVL(P_SCHEMA, 'ALL') = 'ALL' OR DB.OWNER IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_SCHEMA, ','))))
			   AND  DB.DB_PROC_NM LIKE '%'||UPPER(P_PROC_NM)||'%'
		  GROUP BY  DB.OWNER, DB.DB_PROC_NM, NVL2(PROC.PROC_NM, 'Y', '')
			   )
		     WHERE  (NVL(P_UPDATE_YN, 'ALL')) = 'ALL' OR UPDATE_YN = NVL(P_UPDATE_YN, UPDATE_YN)
		  ORDER BY PROC_NM;
	 
	 	OPEN O_RESULT_CURSOR FOR
			SELECT '0' CODE, 'SUSSESS' MSG, 0 EVENT FROM DUAL;	  
	
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
			V_ERR_MSG := SQLERRM;
			RAISE_APPLICATION_ERROR(-20001, V_ERR_MSG);		
			RAISE;
	
	END;

--====================================================================================================================

	PROCEDURE SYS0005_SAVE_MAIN_DATA_BLK (
    	P_DATA				IN 		CLOB,
		P_USER_ID			IN 		VARCHAR2,
		
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
    ) IS
		EX_BIZ_EX	EXCEPTION;
		V_ROW_CNT	NUMBER := 0;
		V_ERR_MSG 	VARCHAR2(4000);
	BEGIN

		DELETE SCM_ADM_PROC_M
		WHERE PROC_NM IN (
		SELECT  DISTINCT V_PROC_NM
		  FROM JSON_TABLE(P_DATA, '$[*]'
		 	COLUMNS (
		 		V_CRUD_TYPE VARCHAR(10) PATH '$."CRUD_TYPE"',
		 		V_PROC_NM VARCHAR(300) PATH '$."PROC_NM"'
		 	))
		 WHERE  V_CRUD_TYPE = 'D' 
		);
		
		V_ROW_CNT := SQL%ROWCOUNT;
	
	
		OPEN O_RESULT_CURSOR FOR
			SELECT '0' CODE, 'SUSSESS' MSG, V_ROW_CNT EVENT FROM DUAL;
			COMMIT;
	
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
			V_ERR_MSG := SQLERRM;
			RAISE_APPLICATION_ERROR(-20001, V_ERR_MSG);
			RAISE;
			
	END;
--====================================================================================================================

	PROCEDURE SYS0005_GET_PROC_DATA (
		P_OWNER				IN 		VARCHAR2,
		P_PROC_NM			IN 		VARCHAR2,
		P_IS_YN				IN 		VARCHAR2,
		
		O_CURSOR			OUT		SYS_REFCURSOR,
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
	) IS
	
		V_ERR_MSG 	VARCHAR2(4000);
	BEGIN
		
		OPEN O_CURSOR FOR
    -- park.choyi 2026.04.14 ALL_ARGUMENTS, SCM_ADM_PROC_M 데이터가 모두 조회될 수 있도록 Full Outer Join 으로 변경        
    WITH DB_SRC AS (
        SELECT OWNER
             , NVL2(PACKAGE_NAME, PACKAGE_NAME || '.' || OBJECT_NAME, OBJECT_NAME) AS PROC_NM
             , ARGUMENT_NAME AS COL_NM
             , POSITION AS SORT_ORD
             , DECODE(ARGUMENT_NAME, 'O_RESULT_CURSOR', 'PROC_RESULT', PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(DATA_TYPE)) AS DATA_TP_CD
             , IN_OUT AS COL_TP_CD
          FROM ALL_ARGUMENTS A
         WHERE NVL2(PACKAGE_NAME, PACKAGE_NAME || '.' || OBJECT_NAME, OBJECT_NAME) = P_PROC_NM
           AND OWNER = NVL(P_OWNER, OWNER)
    )
    , PROC_SRC AS (
        SELECT PROC_NM
             , DATA_TP_CD
             , COL_TP_CD
             , COL_NM
             , ROW_NUMBER() OVER (PARTITION BY PROC_NM ORDER BY SORT_ORD) AS SORT_ORD
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
          FROM SCM_ADM_PROC_M
         WHERE PROC_NM = P_PROC_NM
    )
    , CMP AS (
        SELECT D.OWNER
             , D.PROC_NM
             , D.COL_NM AS DB_COL_NM
             , D.SORT_ORD AS DB_SORT_ORD
             , D.DATA_TP_CD AS DB_DATA_TP_CD
             , D.COL_TP_CD AS DB_COL_TP_CD
             , P.COL_NM
             , P.SORT_ORD
             , P.DATA_TP_CD
             , P.COL_TP_CD
             , P.CREATED_BY
             , P.CREATION_DATE
             , P.LAST_UPDATED_BY
             , P.LAST_UPDATE_DATE
          FROM DB_SRC D
          FULL OUTER JOIN PROC_SRC P
            ON D.PROC_NM = P.PROC_NM
           AND D.SORT_ORD = P.SORT_ORD
    )
    SELECT *
      FROM CMP
     ORDER BY CMP.PROC_NM
            , CMP.DB_SORT_ORD;
    /*
		SELECT  *
		  FROM  (
		     SELECT  NVL2(T2.PROC_NM, 'Y', '') IS_YN
		           , NVL(T1.OWNER, '') OWNER
		     	   , NVL(T2.PROC_NM, T1.OBJECT_NAME) PROC_NM_KEY
		     	   , NVL(T2.PROC_NM, NVL2(T1.PACKAGE_NAME, T1.PACKAGE_NAME||'.'||T1.OBJECT_NAME, T1.OBJECT_NAME)) PROC_NM
             
             --park.choyi 2026.04.13 DB Parameter 추가
             , T1.ARGUMENT_NAME AS DB_COL_NM
             , T1.PLS_TYPE AS DB_DATA_TP_CD
             , T1.IN_OUT AS DB_COL_TP_CD
             , T1.SEQUENCE AS DB_SORT_ORD
             
		     	   , NVL(T2.COL_NM, T1.ARGUMENT_NAME) COL_NM
		     	   , CASE 
			     	   WHEN NVL(T2.DATA_TP_CD, PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(T1.DATA_TYPE)) = 'CURSOR' AND T1.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT'
			     	   ELSE NVL(T2.DATA_TP_CD, PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(T1.DATA_TYPE))
			     	 END DATA_TP_CD
		     	   , NVL(T2.COL_TP_CD, T1.IN_OUT) COL_TP_CD
		     	   , NVL(T2.SORT_ORD, T1.POSITION) SORT_ORD
		     	   , T2.CREATED_BY
		     	   , T2.CREATION_DATE
		     	   , T2.LAST_UPDATED_BY
		     	   , T2.LAST_UPDATE_DATE
		       FROM  ALL_ARGUMENTS T1
		  LEFT JOIN  (SELECT  PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, ROW_NUMBER() OVER (PARTITION BY PROC_NM ORDER BY SORT_ORD ASC) SORT_ORD 
		                     ,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		                FROM  SCM_ADM_PROC_M) T2
		         ON  TRIM(NVL2(T1.PACKAGE_NAME, T1.PACKAGE_NAME||'.'||T1.OBJECT_NAME, T1.OBJECT_NAME)) = TRIM(T2.PROC_NM) 
		        AND  T1.POSITION = T2.SORT_ORD
		        AND  T1.TYPE_OBJECT_TYPE IS NULL ) TT
	      WHERE  1=1
	        AND  TT.OWNER = NVL(P_OWNER, TT.OWNER)
	        AND  (NVL(P_OWNER, 'ALL') = 'ALL' OR TT.OWNER IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_OWNER, ','))))
	        AND  1 = CASE WHEN NVL(P_IS_YN, '') = 'Y' AND TT.PROC_NM = P_PROC_NM THEN 1  
	        		 	  WHEN NVL(P_IS_YN, '') = '' AND TT.PROC_NM LIKE P_PROC_NM||'%' THEN 1
	        		 ELSE 0
	        		 END 		       		 
	        AND  TT.IS_YN = NVL(P_IS_YN, TT.IS_YN)	        
	   ORDER BY  TT.PROC_NM, TT.SORT_ORD;
	  */
		OPEN O_RESULT_CURSOR FOR
			SELECT '0' CODE, 'SUSSESS' MSG, 0 EVENT FROM DUAL;	  
	
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
			V_ERR_MSG := SQLERRM;
			RAISE_APPLICATION_ERROR(-20001, V_ERR_MSG);		
			RAISE;
			
	END;

	
--====================================================================================================================

	PROCEDURE SYS0005_SAVE_PROC_DATA_BLK (
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
		EX_BIZ_EX	EXCEPTION;
		V_ROW_CNT	NUMBER := 0;
		V_ERR_MSG 	VARCHAR2(4000);
	BEGIN
        
    -- park.choyi 2026.04.14 ALL_ARGUMENTS 에 없는 데이터 삭제
    DELETE FROM SCM_ADM_PROC_M T
    WHERE EXISTS (
        SELECT 1
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_PROC_NM   VARCHAR2(300) PATH '$.PROC_NM',
                N_SORT_ORD  NUMBER        PATH '$.DB_SORT_ORD'
            )
        ) J
        WHERE J.V_PROC_NM  = T.PROC_NM
          AND J.N_SORT_ORD = T.SORT_ORD
    )
    AND NOT EXISTS (
        SELECT 1
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_PROC_NM   VARCHAR2(300) PATH '$.PROC_NM',
                N_SORT_ORD  NUMBER        PATH '$.DB_SORT_ORD'
            )
        ) J
        JOIN ALL_ARGUMENTS A
          ON NVL2(A.PACKAGE_NAME, A.PACKAGE_NAME || '.' || A.OBJECT_NAME, A.OBJECT_NAME) = J.V_PROC_NM
         AND A.POSITION = J.N_SORT_ORD
         AND A.TYPE_OBJECT_TYPE IS NULL
        WHERE J.V_PROC_NM  = T.PROC_NM
          AND J.N_SORT_ORD = T.SORT_ORD
    );
    -- park.choyi 2026.04.14 SCM_ADM_PROC_M 매핑 데이터 삭제
    DELETE FROM SCM_ADM_PROC_M T
    WHERE EXISTS (
        SELECT 1
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_PROC_NM   VARCHAR2(300) PATH '$.PROC_NM',
                N_SORT_ORD  NUMBER        PATH '$.DB_SORT_ORD'
            )
        ) J
        WHERE J.V_PROC_NM  = T.PROC_NM
          AND J.N_SORT_ORD = T.SORT_ORD
    );
		/*DELETE SCM_ADM_PROC_M
		WHERE PROC_NM IN (
		SELECT  DISTINCT V_PROC_NM
			FROM JSON_TABLE(P_DATA, '$[*]'
		 	COLUMNS (
		 		V_PROC_NM VARCHAR(300) PATH '$."PROC_NM"'
		 	))
		);*/
		
		MERGE INTO  SCM_ADM_PROC_M TGT
			 USING  ( SELECT  V_PROC_NM PROC_NM
			                , V_COL_NM COL_NM
			                , V_DATA_TP_CD DATA_TP_CD
			                , V_COL_TP_CD COL_TP_CD
			                , N_SORT_ORD SORT_ORD
			                , P_USER_ID USER_ID
						FROM JSON_TABLE(P_DATA, '$[*]'
			    	 	COLUMNS (
			    	 		V_PROC_NM VARCHAR(300) PATH '$."PROC_NM"',
			    	 		V_COL_NM VARCHAR(100) PATH '$."COL_NM"',
			    	 		V_DATA_TP_CD VARCHAR(100) PATH '$."DATA_TP_CD"',
			    	 		V_COL_TP_CD VARCHAR(100) PATH '$."COL_TP_CD"',
			    	 		N_SORT_ORD NUMBER PATH '$."DB_SORT_ORD"'
			    	 	))
            WHERE TRIM(V_PROC_NM) IS NOT NULL -- park.choyi 2026.04.14 V_PROC_NM IS NULL 제외
             ) SRC
		        ON  (TGT.PROC_NM = SRC.PROC_NM 
		             AND TGT.SORT_ORD = SRC.SORT_ORD)				             
		WHEN MATCHED THEN
	  			UPDATE SET
	  				TGT.DATA_TP_CD = SRC.DATA_TP_CD
	  				, TGT.COL_NM = SRC.COL_NM
	  				, TGT.COL_TP_CD = SRC.COL_TP_CD
	  				, TGT.LAST_UPDATED_BY = SRC.USER_ID
	  				, TGT.LAST_UPDATE_DATE = SYSDATE	
  			  				
		WHEN NOT MATCHED THEN 
				INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) 
				VALUES (SRC.PROC_NM, SRC.COL_NM, SRC.DATA_TP_CD, SRC.COL_TP_CD, SRC.SORT_ORD, SRC.USER_ID, SYSDATE, SRC.USER_ID, SYSDATE);
			
		V_ROW_CNT := SQL%ROWCOUNT;
	
	
		OPEN O_RESULT_CURSOR FOR
			SELECT '0' CODE, 'SUSSESS' MSG, V_ROW_CNT EVENT FROM DUAL;
			COMMIT;
	
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
			V_ERR_MSG := SQLERRM;
			RAISE_APPLICATION_ERROR(-20001, V_ERR_MSG);
			RAISE;
			
	END;
	

--====================================================================================================================
	


END PKG_SYS0005;
/
