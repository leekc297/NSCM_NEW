/*=============================================================================================
 * File         : 04_Package_PKG_SYS0001.sql
 * Description  : Package — PKG_SYS0001
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0001
AS

    PROCEDURE SYS0001_GET_MAIN_DATA (
		P_MSG_TP_CD		IN 		VARCHAR2,
		P_MSG_CTN		IN 		VARCHAR2,
		P_USE_YN		IN		VARCHAR2,
    	O_CURSOR        OUT 	SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
    );

	PROCEDURE SYS0001_SAVE_MAIN_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	);

END PKG_SYS0001;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0001
AS

--====================================================================================================================

	PROCEDURE SYS0001_GET_MAIN_DATA (
	    P_MSG_TP_CD     IN      VARCHAR2,
	    P_MSG_CTN       IN      VARCHAR2,
	    P_USE_YN		IN		VARCHAR2,
    	O_CURSOR        OUT 	SYS_REFCURSOR,
	    O_RESULT_CURSOR OUT     SYS_REFCURSOR
	) IS
		V_ERR_MSG 	VARCHAR2(4000);
	BEGIN
		-- 언어코드 KO, EN, CN 고정
		OPEN O_CURSOR FOR
	        SELECT 
	            A.MSG_ID,
	            MAX(CASE WHEN A.LANG_CD = 'KO' THEN A.MSG_NM END) AS MSG_NM_KO,
	            MAX(CASE WHEN A.LANG_CD = 'EN' THEN A.MSG_NM END) AS MSG_NM_EN,
	            MAX(CASE WHEN A.LANG_CD = 'CN' THEN A.MSG_NM END) AS MSG_NM_CN,
	            A.MSG_TP_CD,
	            A.USE_YN,
	            MAX(A.CREATED_BY) 			AS CREATED_BY,
	            MAX(A.CREATION_DATE) 		AS CREATION_DATE,
	            MAX(A.LAST_UPDATED_BY) 		AS LAST_UPDATED_BY,
	            MAX(A.LAST_UPDATE_DATE) 	AS LAST_UPDATE_DATE
	        FROM SCM_ADM_MSG_M A
	        WHERE (P_MSG_TP_CD IS NULL OR P_MSG_TP_CD = 'ALL' OR A.MSG_TP_CD IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_MSG_TP_CD, ','))))
	          AND (P_USE_YN IS NULL OR P_USE_YN = 'ALL' OR A.USE_YN = P_USE_YN)
	        GROUP BY A.MSG_ID, A.MSG_TP_CD, A.USE_YN
          --, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE --park.choyi 2026.04.15 Group by 대상이 아니므로 삭
	        HAVING
	            (P_MSG_CTN IS NULL OR 
	             UPPER(A.MSG_ID) LIKE UPPER('%' || P_MSG_CTN || '%') OR
	             UPPER(MAX(CASE WHEN A.LANG_CD = 'KO' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%') OR 
	             UPPER(MAX(CASE WHEN A.LANG_CD = 'EN' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%') OR 
	             UPPER(MAX(CASE WHEN A.LANG_CD = 'CN' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%')
	            )
	        ORDER BY A.MSG_ID;
	     
		OPEN O_RESULT_CURSOR FOR
			SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
	          
		EXCEPTION
		    WHEN OTHERS THEN
		        ROLLBACK;
		        RAISE_APPLICATION_ERROR(-20001,
		        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
		        ' / SQLERRM=' || SQLERRM ||
		        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
		        ' / PARAMS=' || '-' );
	
	END SYS0001_GET_MAIN_DATA;

	
	PROCEDURE SYS0001_SAVE_MAIN_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
        O_RESULT_CURSOR    OUT SYS_REFCURSOR
	) IS
		V_ROW_CNT	NUMBER := 0;
		V_ERR_MSG 	VARCHAR2(4000);
	BEGIN
		
		-- 화면에서 보낸 행 기준으로 count 되어야 해서 쿼리 수행 전 별도 체크
		SELECT COUNT(*)
        INTO   V_ROW_CNT
        FROM   JSON_TABLE(P_DATA, '$[*]'
                   COLUMNS (
                       V_EXISTS NUMBER PATH '$'
                   ));
		
		DELETE FROM SCM_ADM_MSG_M
		WHERE (MSG_ID, LANG_CD) IN (
		    SELECT MSG_ID, LANG_CD
		    FROM (
		        SELECT 
		            V_MSG_ID AS MSG_ID,
		            V_MSG_NM_KO AS KO,
		            V_MSG_NM_EN AS EN,
		            V_MSG_NM_CN AS CN
		        FROM JSON_TABLE(P_DATA, '$[*]'
		            COLUMNS (
		                V_CRUD_TYPE VARCHAR2(20)  PATH '$.CRUD_TYPE',
		                V_MSG_ID    VARCHAR2(200) PATH '$.MSG_ID',
		                V_MSG_NM_KO VARCHAR2(200) PATH '$.MSG_NM_KO',
		                V_MSG_NM_EN VARCHAR2(200) PATH '$.MSG_NM_EN',
		                V_MSG_NM_CN VARCHAR2(200) PATH '$.MSG_NM_CN'
		            ))
		        WHERE V_CRUD_TYPE = 'D'
		    )
		    UNPIVOT (
		        MSG_NM FOR LANG_CD IN (KO AS 'KO', EN AS 'EN', CN AS 'CN')
		    )
		);
        
		MERGE INTO SCM_ADM_MSG_M T
		USING (
			WITH BASE AS (
	            SELECT 
	                V_CRUD_TYPE AS CRUD_TYPE,
					CASE 
	                    WHEN V_CRUD_TYPE = 'I' AND V_MSG_ID IS NULL THEN SCM_MGR.PKG_NSCM_UI_COMM.FN_GET_TEMP_MSG_SEQ
	                    ELSE V_MSG_ID 
	                END AS MSG_ID,
	                V_MSG_NM_KO AS MSG_NM_KO,
	                V_MSG_NM_EN AS MSG_NM_EN,
	                V_MSG_NM_CN AS MSG_NM_CN,
	                V_MSG_TP_CD AS MSG_TP_CD,
	                V_USE_YN    AS USE_YN
	            FROM JSON_TABLE(P_DATA, '$[*]'
	                COLUMNS (
	                    V_CRUD_TYPE VARCHAR2(20)  PATH '$.CRUD_TYPE',
	                    V_MSG_ID    VARCHAR2(200) PATH '$.MSG_ID',
	                    V_MSG_NM_KO VARCHAR2(200) PATH '$.MSG_NM_KO',
	                    V_MSG_NM_EN VARCHAR2(200) PATH '$.MSG_NM_EN',
	                    V_MSG_NM_CN VARCHAR2(200) PATH '$.MSG_NM_CN',
	                    V_MSG_TP_CD VARCHAR2(20)  PATH '$.MSG_TP_CD',
	                    V_USE_YN    VARCHAR2(1)   PATH '$.USE_YN'
	                ))
				WHERE V_CRUD_TYPE IN ('I', 'M')
	        )
	        SELECT 
	            CRUD_TYPE,
	            MSG_ID,
	            LANG_CD,
	            MSG_NM,
	            MSG_TP_CD,
	            USE_YN
	        FROM BASE
	        UNPIVOT INCLUDE NULLS (
	            MSG_NM FOR LANG_CD IN (
	                MSG_NM_KO AS 'KO', 
	                MSG_NM_EN AS 'EN', 
	                MSG_NM_CN AS 'CN'
	            )
	        )
		) S
		ON (T.MSG_ID = S.MSG_ID AND T.LANG_CD = S.LANG_CD AND S.CRUD_TYPE = 'M')
		WHEN MATCHED THEN
		    UPDATE SET 
		        T.MSG_NM           = S.MSG_NM,
		        T.MSG_TP_CD        = S.MSG_TP_CD,
		        T.USE_YN           = S.USE_YN,
		        T.LAST_UPDATED_BY  = P_USER_ID,
		        T.LAST_UPDATE_DATE = SYSDATE
		WHEN NOT MATCHED THEN
		    INSERT (
		        MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
		        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		    )
		    VALUES (
		        S.MSG_ID, S.LANG_CD, S.MSG_NM, S.MSG_TP_CD, S.USE_YN,
		        P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
		    );
	   	
		-- 임시 시퀀스로 등록된 데이터 실제 MSG_ID로 업데이트
		FOR U IN (
			SELECT MSG_ID, MSG_TP_CD, SCM_MGR.PKG_NSCM_UI_COMM.FN_GET_MSG_SEQ(MSG_TP_CD) AS NEW_ID
		 	FROM SCM_ADM_MSG_M
			WHERE MSG_ID LIKE 'MSG_TEMP_SEQ%'
			GROUP BY MSG_ID, MSG_TP_CD
		) LOOP 
		   	UPDATE SCM_ADM_MSG_M M
		   	SET M.MSG_ID = U.NEW_ID
		   	WHERE M.MSG_ID = U.MSG_ID
		   	;
		END LOOP
		;  

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

	END SYS0001_SAVE_MAIN_DATA;

END PKG_SYS0001;
/
