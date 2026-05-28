/*=============================================================================================
 * File         : 04_Package_PKG_NSCM_UI_COM_USER.sql
 * Description  : Package — PKG_NSCM_UI_COM_USER
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_NSCM_UI_COM_USER
AS
	-- DEPRECATED
	PROCEDURE PR_GET_USER ( 
		P_USER_ID	IN VARCHAR2,	
		DATA		OUT	SYS_REFCURSOR
	);

	PROCEDURE PR_GET_NSCM_USER ( 
		P_USER_ID	IN VARCHAR2,	
		DATA		OUT	SYS_REFCURSOR
	);

	PROCEDURE PR_UPDATE_LANG_CD ( 
		P_USER_ID	IN VARCHAR2,
		P_LANG_CD	IN VARCHAR2
	);

END PKG_NSCM_UI_COM_USER;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_NSCM_UI_COM_USER
AS

	-- DEPRECATED
	PROCEDURE PR_GET_USER ( 
		P_USER_ID	IN VARCHAR2, 
		DATA		OUT		SYS_REFCURSOR
	) IS
	
	BEGIN
		OPEN DATA FOR
			SELECT	U.USER_ID 				AS USER_ID
				  , ''		 				AS PASSWORD
				  , U.USER_NAME 			AS USER_NM
				  , U.USER_NAME_EN 			AS USER_ENG_NM
				  , NVL(UU.LANG_CD, 'KO') 	AS LANG_CD
			FROM 	SCM_MST_SSO_USER_INFO U
				LEFT JOIN SCM_ADM_USER_M UU
					ON	UU.USER_ID = U.USER_ID
			WHERE 	1=1
			AND 	U.USER_ID = P_USER_ID
			FETCH FIRST 1 ROWS ONLY
			;
	END;

	PROCEDURE PR_GET_NSCM_USER ( 
	    P_USER_ID   IN VARCHAR2, 
	    DATA        OUT     SYS_REFCURSOR  -- 매개변수 명칭 확인 (DATA)
	) IS
	    V_CNT NUMBER := 0;
	BEGIN
	    -- 1. NSCM USER 테이블 존재 여부 확인
	    SELECT COUNT(*)
	    INTO V_CNT
	    FROM SCM_ADM_USER_M
	    WHERE USER_ID = P_USER_ID;
	
	    IF V_CNT > 0 THEN
	        -- [Case 1] NSCM USER 있음: 즉시 조회
	        OPEN DATA FOR
	            SELECT USER_ID      AS USER_ID
	                 , ''           AS PASSWORD
	                 , USER_NM    	AS USER_NM
	                 , USER_ENG_NM	AS USER_ENG_NM
	                 , LANG_CD      AS LANG_CD
	            FROM SCM_ADM_USER_M
	            WHERE USER_ID = P_USER_ID
	            FETCH FIRST 1 ROWS ONLY;
	
	    ELSE
	        -- 2. NSCM USER 없음 -> SSO USER 테이블 확인
	        SELECT COUNT(*)
	        INTO V_CNT
	        FROM SCM_MST_SSO_USER_INFO
	        WHERE USER_ID = P_USER_ID;
	       
	        IF V_CNT > 0 THEN
	            -- [Case 2] SSO USER 있음: INSERT 후 조회
	            INSERT INTO SCM_ADM_USER_M (
	                USER_ID, USER_NM, USER_ENG_NM, USER_EML, DEPT_ID,
	                USER_PHN, USER_HPHN, LANG_CD, ACNT_LOK_YN, TMZ_CD,
	                LOGN_DTM, USE_YN, CREATED_BY, CREATION_DATE,
	                LAST_UPDATED_BY, LAST_UPDATE_DATE,
	                N01_ATR_CTN, N02_ATR_CTN, N03_ATR_CTN, N04_ATR_CTN,
	                N05_ATR_CTN, N06_ATR_CTN, N07_ATR_CTN, N08_ATR_CTN,
	                N09_ATR_CTN, N10_ATR_CTN, XLS_PWD, XLS_PWD_CHG_DATE, PERM_KEP_CNC_YN
	            )
	            SELECT 
	                USER_ID, USER_NAME, USER_NAME_EN, NULL, DEPT_ID,
	                NULL, NULL, 'KO', 'Y', 'AS054',
	                NULL, 'Y', 'SYSTEM', SYSDATE,
	                'SYSTEM', SYSDATE,
	                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	                NULL, NULL, ''
	            FROM SCM_MST_SSO_USER_INFO
	            WHERE USER_ID = P_USER_ID
	            AND ROWNUM = 1;
	           
	       		DELETE FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = P_USER_ID;
	           	DELETE FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_ID = P_USER_ID;
	          
		        INSERT INTO SCM_ADM_USER_GR_MPG_M (
		        	USER_GR_ID, USER_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE 
		        )
		        SELECT
		        	'GUEST', P_USER_ID, 'Y', 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
		        FROM DUAL;
	
	            -- INSERT 직후 조회
	            OPEN DATA FOR
	                SELECT USER_ID      AS USER_ID
	                     , ''           AS PASSWORD
	                     , USER_NM    	AS USER_NM
	                     , USER_ENG_NM	AS USER_ENG_NM
	                     , LANG_CD      AS LANG_CD
	                FROM SCM_ADM_USER_M
	                WHERE USER_ID = P_USER_ID
	                FETCH FIRST 1 ROWS ONLY;
	        ELSE
	            -- [Case 3] 둘 다 없음: 빈 커서 반환
	            OPEN DATA FOR
	                SELECT USER_ID		AS USER_ID
	                	 , '' 			AS PASSWORD
	                	 , USER_NM		AS USER_NM
	                	 , USER_ENG_NM	AS USER_ENG_NM
	                	 , LANG_CD		AS LANG_CD
	                FROM SCM_ADM_USER_M
	                WHERE 1=0; -- 테이블 구조만 빌려오는 방식이 안전합니다.
	        END IF;
	    END IF;
	END;

	PROCEDURE PR_UPDATE_LANG_CD ( 
		P_USER_ID	IN VARCHAR2, 
		P_LANG_CD	IN VARCHAR2
	) IS
	
	BEGIN
		UPDATE 	SCM_ADM_USER_M
		SET		LANG_CD = P_LANG_CD
		WHERE 	USER_ID = P_USER_ID
		;
	END;

END PKG_NSCM_UI_COM_USER;
/
