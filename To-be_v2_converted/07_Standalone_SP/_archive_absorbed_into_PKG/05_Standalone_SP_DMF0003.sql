-- ============================================================================
-- ABSORBED: 다음 SP들은 PKG_DMF0003에 P_* prefix로 흡수됨 (2026-05-13)
-- 원본 파일은 컴파일 대상에서 제외. 이력 관리용 보관.
-- ============================================================================

/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0003.sql
 * Description  : Standalone Procedures — DMF0003 화면 (23개)
 *              : 향후 PKG_DMF0003로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC
(
		p_division_id			VARCHAR2,
		p_project_code			VARCHAR2,
		p_project_name		    VARCHAR2,
		p_yyyymm_from			VARCHAR2,
		p_yyyymm_to			VARCHAR2,
		p_yyyymm_from_simul	VARCHAR2,
		p_yyyymm_to_simul		VARCHAR2,
		p_created_by			VARCHAR2,
    	p_end_customer VARCHAR2
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:36:58
 * 파일: dbo.DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC.sql
 * ----------------------------------------
 * ⚠ IF: IF:8  END IF:7  차이:+1
 * ⚠ LOOP: LOOP:1  END LOOP:0  차이:+1
 * ⚠ BEGIN: BEGIN:25  END:21  차이:+4
 * ----------------------------------------
 * BEGIN 위치: L57, L104, L114, L123, L145, L158, L172, L217, L229, L232 ...
 * END;  위치: L111, L140, L152, L169, L209, L211, L227, L383, L388, L393 ...
 * ----------------------------------------
 * 힌트: BEGIN이 4개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */




    V_CNT INTEGER := 0, v_i INTEGER =  1;
    v_yyyymm VARCHAR2(20 CHAR);
    p_yyyymm VARCHAR2(20 CHAR);
    v_CUST_FCST_M VARCHAR2(4000 CHAR);
    v_MKT_FCST_S VARCHAR2(4000 CHAR);
    v_MKT_FCST_R VARCHAR2(4000 CHAR);
    v_0month_tuesday VARCHAR2(08 CHAR);
    v_0month VARCHAR2(6 CHAR);
    v_1month VARCHAR2(6 CHAR);
    v_s INTEGER := 0;
    V_PSI_CNT INTEGER := 1;
    V_YYYYMM_CNT INTEGER := 1;
    V_YYYYMM VARCHAR2(30 CHAR);
    V_YYYYMM_FROM VARCHAR2(30 CHAR);
    V_YYYYMM_TO VARCHAR2(30 CHAR);
    V_MEASURE VARCHAR2(30 CHAR);
    V_P INTEGER := 0;
    V_S INTEGER := 0;
    V_I INTEGER := 0;
    V_V INTEGER := 0;
    V_M INTEGER := 0;
    V_CP INTEGER := 0;
BEGIN








	    v_DP_RESULT_SUM NUMERIC(20,10);
	    v_DP_RESULT_P NUMERIC(20,10);
	    v_DP_RESULT_S NUMERIC(20,10);
	    v_DP_RESULT_I NUMERIC(20,10);
	    v_DP_RESULT_V NUMERIC(20,10);
	    v_DP_RESULT_M NUMERIC(20,10);
	    v_DP_RESULT_CP NUMERIC(20,10);
	    v_EDI_SUM NUMERIC(20,10);

	    v_DP_ANL_SUM NUMERIC(20,10);
	    v_DP_ANL_P NUMERIC(20,10);
	    v_DP_ANL_S NUMERIC(20,10);
	    v_DP_ANL_I NUMERIC(20,10);
	    v_DP_ANL_V NUMERIC(20,10);
	    v_DP_ANL_M NUMERIC(20,10);
	    v_DP_ANL_CP NUMERIC(20,10);
	    v_LAST_MONTH_EDI NUMERIC(20,10);







	v_0month := TO_CHAR(SYSDATE, 'YYYYMMDD'); --M0 당월
	v_1month := TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMMDD')	--M-1 전월



	SELECT MONTHS_BETWEEN(1, 4, SUBSTR(p_yyyymm_to)  ||  '-'  ||  SUBSTR(p_yyyymm_to, 5, 2)   ||  '-01', SUBSTR(p_yyyymm_from, 1, 4)  ||  '-'  ||  SUBSTR(p_yyyymm_from, 5, 2)   ||  '-01' )
  INTO v_i
		)
	FROM DUAL;

	-- 테이블중복제거
	-- 임시확인용테이블 중복제거
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION';

	BEGIN

		-- 테이블중복제거
		-- 임시확인용테이블 중복제거
		SELECT * INTO GT_DMF0_PROJECT_CODE
		FROM (SELECT PROJECT_CODE FROM SCM_MST_PROJECT WHERE DIVISION_ID = p_division_id AND PROJECT_NAME = p_project_name) A;

	END;


	BEGIN

		--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
		IF DATEPART(WEEKDAY, SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)  ||  '01') = '4' THEN
				v_0month_tuesday := TO_CHAR(/* TODO:(FN_NEXT_DAY(TO_CHAR(SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6) + (-1) * 7 + '01', 'YYYYMMDD'), 'TUE')) */, 'YYYYMMDD');
		ELSE
				v_0month_tuesday := TO_CHAR(1 || (/* TODO:DATEDIFF(WK,0,(SYSDATE) + (5-DATEPART(DAY, SYSDATE) */)))*7SYSDATE || (5-DATEPART(DAY, SYSDATE))), 1), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
			END IF;

		BEGIN
			INSERT INTO GT_DMF0_DM_MST_VERSION ( NUM, VERSION_NO, VERSION_TYPE )
			SELECT ROW_NUMBER() OVER (ORDER BY X.VERSION_NO) AS NUM
						, X.VERSION_NO
						, X.VERSION_TYPE
			FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
									, A.VERSION_NO, A.VERSION_TYPE
						FROM  DM_MST_VERSION A
						JOIN SCM_SYS_CALENDAR_M B
						ON A.YYYYMMDD = B.BASIS_YYYYMMDD
						WHERE 1=1
						AND A.DIVISION_ID = p_division_id
						AND A.VERSION_TYPE = 'MF_W'			--MKT_FCST Weekly Cutoff
						AND A.YYYYMMDD = v_0month_tuesday
					) X;
			WHERE RNK = 1;
		END;

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------


		BEGIN
	    	-- 테이블중복제거
	       	-- 임시확인용테이블 중복제거
		    SELECT * INTO GT_DMF0_DM_MST_ITEM_SINGLE_V FROM DM_MST_ITEM_SINGLE_V  WHERE DIVISION_ID = p_division_id
			AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_PROJECT_ITEM WHERE PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
			AND VALID_YN = 'Y') AND ITEM_TYPE = 'P' AND ACTIVE_FLAG = 'Y';
			--AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_PROJECT_ITEM WHERE PROJECT_CODE = p_project_code AND VALID_YN = 'Y') AND ITEM_TYPE = 'P' AND ACTIVE_FLAG = 'Y'
		END;
		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------



		--SCM_MST_SITE 대상건만 추출
		BEGIN
        	-- 테이블중복제거
        	-- 임시확인용테이블 중복제거
        	/* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
        	INSERT INTO GT_DMF0_SCM_MST_SITE
        	SELECT DIVISION_ID
			     , SCM_SITE_ID
				 , END_CUSTOMER
			FROM SCM_MST_SITE
			WHERE DIVISION_ID  = p_division_id
	          AND END_CUSTOMER = p_end_customer;
		END;


		BEGIN
        	-- 테이블중복제거
        	-- 임시확인용테이블 중복제거
        	/* TODO:GTT:GT_DMF0_DM_PLN_MKT_FCST_C-->GT_DMF0_DM_PLN_MKT_FCST_C */
        	INSERT INTO GT_DMF0_DM_PLN_MKT_FCST_C
        	SELECT X.*
			FROM DM_PLN_MKT_FCST_C X
			JOIN GT_DMF0_DM_MST_VERSION Y
			ON X.VERSION_NO = Y.VERSION_NO
		    JOIN GT_DMF0_SCM_MST_SITE Z
			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
			WHERE 1=1
			AND X.DIVISION_ID = p_division_id
			AND X.MEASURE IN ('MKT_FCST','CUST_FCST_EDI', 'CUST_FCST')
			AND X.PROJECT_CODE = p_project_code
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V);
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------

        	-- 테이블중복제거
        	-- 임시확인용테이블 중복제거
        	/* TODO:GTT:GT_DMF0_DM_PLN_MKT_FCST_RESULT-->GT_DMF0_DM_PLN_MKT_FCST_RESULT */
        	INSERT INTO GT_DMF0_DM_PLN_MKT_FCST_RESULT
        	SELECT X.*
			FROM DM_PLN_MKT_FCST_RESULT_C X
			JOIN GT_DMF0_DM_MST_VERSION Y
			ON X.VERSION_NO = Y.VERSION_NO
		    JOIN GT_DMF0_SCM_MST_SITE Z
			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
			WHERE 1=1
			AND X.DIVISION_ID = p_division_id
			AND X.MEASURE IN ('MKT_FCST','CUST_FCST_EDI', 'CUST_FCST')
			AND X.PROJECT_CODE = p_project_code
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V);
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------

		END;

	END;

	--SELECT * FROM GT_DMF0_DM_MST_ITEM_SINGLE_V

	WHILE v_i <= 0 LOOP

		BEGIN
			SELECT COUNT(*)
  INTO V_CNT
			FROM DM_ANL_MKT_PSI
			WHERE 1=1
			AND DIVISION_ID = p_division_id
			AND END_CUSTOMER = p_end_customer
			--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
			AND PROJECT_CODE = p_project_code
			AND YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD');
		END;

		BEGIN
			IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') THEN
					--고객수요계획
					BEGIN
						IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
								SELECT (A_QTY  ||  B_QTY)
  INTO v_CUST_FCST_M
								FROM (
											SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
											FROM GT_DMF0_DM_PLN_MKT_FCST_C X
											JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1
											AND X.DIVISION_ID = p_division_id
											AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
											AND X.PROJECT_CODE = p_project_code
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
											AND X.QTY <> 0
											) A,
											(
											SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
											FROM GT_DMF0_DM_PLN_MKT_FCST_RESULT X
											JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1
											AND X.DIVISION_ID = p_division_id
											AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
											AND X.PROJECT_CODE = p_project_code
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
											) B;
						ELSE
							SELECT v_CUST_FCST_M = 0
					END IF;
					--마케팅수요계획
					BEGIN
						IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
								SELECT (A_QTY  ||  B_QTY)
  INTO v_MKT_FCST_S
								FROM (
											SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
											FROM GT_DMF0_DM_PLN_MKT_FCST_C X
											JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1
											AND X.DIVISION_ID = p_division_id
											AND X.MEASURE = 'RTF_SYS_RP'
											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
											AND X.PROJECT_CODE = p_project_code
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
											AND X.QTY <> 0
											) A,
											(
											SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
											FROM GT_DMF0_DM_PLN_MKT_FCST_RESULT X
											JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1
											AND X.DIVISION_ID = p_division_id
											AND X.MEASURE = 'RTF_SYS_RP'
											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
											AND X.PROJECT_CODE = p_project_code
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
											) B;
						ELSE
							SELECT v_MKT_FCST_S = 0

						IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_1month THEN
					            /* 2023.11.02	   kcw3408		  전월 실적 구하기 ,기존로직 삭제
								SELECT v_MKT_FCST_R = (A_QTY || B_QTY)
								FROM (
											SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
											FROM GT_DMF0_DM_PLN_MKT_FCST_C X
											JOIN GT_DMF0_DM_MST_VERSION Y
											ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1
											AND DIVISION_ID = p_division_id
											AND MEASURE = 'RTF_SYS_RP'
											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
											AND PROJECT_CODE = p_project_code
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTR(YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', -1), 'YYYYMMDD')
											AND QTY <> 0
											) A,
											(
											SELECT NVL(CEILING(SUM(QTY)), 0) AS B_QTY
											FROM GT_DMF0_DM_PLN_MKT_FCST_RESULT X
											JOIN GT_DMF0_DM_MST_VERSION Y
											ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1
											AND DIVISION_ID = p_division_id
											AND MEASURE = 'RTF_SYS_RP'
											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
											AND PROJECT_CODE = p_project_code
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTR(YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', -1), 'YYYYMMDD')
											) B;
					    */
				    		SELECT v_MKT_FCST_R = A.A_QTY
					          FROM (
								SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
								FROM DM_PLN_MKT_FCST_RESULT X
		                        JOIN SCM_MST_SITE_ITEM F
				                     ON	F.DIVISION_ID    = X.DIVISION_ID
				                    AND	F.PROJECT_CODE   = X.PROJECT_CODE
			                        AND	F.scm_site_id    = X.scm_site_id
                                    AND	F.ITEM_ID        = X.ITEM_ID
			                   JOIN GT_DMF0_SCM_MST_SITE H
				                    ON	F.DIVISION_ID    = H.DIVISION_ID
				                   AND	F.SCM_SITE_ID    = H.SCM_SITE_ID
			                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
			                        ON	G.SEGMENT1    = X.FCST_TYPE
				                   AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE'
								WHERE 1 = 1
									AND X.DIVISION_ID = p_division_id
									AND X.MEASURE = 'RTF_SYS_RP'
									AND X.PROJECT_CODE = p_project_code
									AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', - 1), 'YYYYMMDD')
							       ) A;
						ELSE
							SELECT v_MKT_FCST_R = 0
					END IF;
			ELSE
				SELECT 0,
    0,
    0
  INTO v_CUST_FCST_M, v_MKT_FCST_S, v_MKT_FCST_R
		END IF;


		IF (V_CNT = 0) THEN
			IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
					BEGIN
						INSERT INTO GT_DMF0_DATA
						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), v_CUST_FCST_M, 'Average impact(%)', '0%', '0%', '0%', '0%', '0%', '0%', '0%',NULL, '1'
					END;

					BEGIN
						INSERT INTO GT_DMF0_DATA
						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), v_CUST_FCST_M, 'Simulation (Impact)', 0, 0, 0, 0, 0, 0, 0, 0, '2'
					END;

					BEGIN
						INSERT INTO GT_DMF0_DATA
						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), v_CUST_FCST_M, 'Demand Plan (1st)', 0, 0, 0, 0, 0, 0, 0, CEILING(v_MKT_FCST_S), '3'
					END;

					BEGIN
						INSERT INTO GT_DMF0_DATA
						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), v_CUST_FCST_M, 'Demand Plan (final)', 0, 0, 0, 0, 0, 0, 0, CEILING(v_MKT_FCST_R), '4'
					END;
			ELSE
					BEGIN
						INSERT INTO GT_DMF0_DATA
						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), 0, 'Average impact(%)', '0%', '0%', '0%', '0%', '0%', '0%', '0%', NULL, '1'
					END;

					BEGIN
						INSERT INTO GT_DMF0_DATA
						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), 0, 'Simulation (Impact)', 0, 0, 0, 0, 0, 0, 0, 0, '2'
					END;

					BEGIN
						INSERT INTO GT_DMF0_DATA
						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), 0, 'Demand Plan (1st)', 0, 0, 0, 0, 0, 0, 0, CEILING(v_MKT_FCST_S), '3'
					END;

					BEGIN
						INSERT INTO GT_DMF0_DATA
						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), 0, 'Demand Plan (final)', 0, 0, 0, 0, 0, 0, 0, CEILING(v_MKT_FCST_R), '4'
					END;
		ELSE
				-- 고객수요증감분석 전체조회
				INSERT INTO GT_DMF0_DATA
				SELECT  T1.DIVISION_ID AS DIVISION_ID
				          , p_end_customer
						  , p_project_name
						  , p_project_code
						  , T1.YYYYMM AS YYYYMM
						  , (CASE WHEN NVL(T1.CUST_FCST_M, 0) = 0 THEN
											   v_CUST_FCST_M
									 WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
											   v_CUST_FCST_M
									 ELSE CEILING(T1.CUST_FCST_M) END) AS EDI_QTY
						  , (CASE T1.MEASURE WHEN 'AN_LOGIC' THEN 'Average impact(%)'
													   WHEN 'AN_RESULT' THEN 'Simulation (Impact)'
													   WHEN 'DP_INIT' THEN 'Demand Plan (1st)'
													   WHEN 'DP_RESULT' THEN 'Demand Plan (final)' END) AS MEASURE
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T2.VSUM), 2))) || '%')
								 	 ELSE TO_CHAR(CEILING(T2.VSUM), '#,#') END) AS SUM
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR(ROUND(TO_NUMBER(T1.P_VALUE), 2)) || '%')
									 ELSE TO_CHAR(CEILING(T1.P_VALUE), '#,#') END) AS PRODUCT
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.S_VALUE), 2))) || '%')
									 ELSE TO_CHAR(CEILING(T1.S_VALUE), '#,#') END) AS SALE
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.I_VALUE), 2))) || '%')
									 ELSE TO_CHAR(CEILING(T1.I_VALUE), '#,#') END) AS INVENTORY
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.V_VALUE), 2))) || '%')
									 ELSE TO_CHAR(CEILING(T1.V_VALUE), '#,#') END) AS TIME_ADJUST
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.M_VALUE), 2))) || '%')
									 ELSE TO_CHAR(CEILING(T1.M_VALUE), '#,#') END) AS MODEL_MIX
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.CP_VALUE), 2))) || '%')
									 ELSE TO_CHAR(CEILING(T1.CP_VALUE), '#,#') END) AS SUPPLY_ISSUE
						  , (CASE WHEN T1.MEASURE = 'AN_RESULT' THEN
											  (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN 0 ELSE CEILING(T1.MKT_FCST_M) END)
									 WHEN T1.MEASURE = 'DP_INIT' THEN
											  (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN
																 CEILING(v_MKT_FCST_S)
													   WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
																 CEILING(v_MKT_FCST_S)
														ELSE CEILING(T1.MKT_FCST_M) END)
									 WHEN T1.MEASURE = 'DP_RESULT' THEN
											  (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN
																 CEILING(v_MKT_FCST_R)
													   WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
																 CEILING(v_MKT_FCST_R)
													   ELSE CEILING(T1.MKT_FCST_M) END)
									 ELSE NULL END)
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN '1'
									 WHEN T1.MEASURE = 'AN_RESULT' THEN '2'
									 WHEN T1.MEASURE = 'DP_INIT' THEN '3'
									 ELSE '4' END) RNK
				FROM DM_ANL_MKT_PSI T1
				LEFT OUTER JOIN (SELECT PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE, SUM(VVALUE) AS VSUM
										  FROM DM_ANL_MKT_PSI;
				UNPIVOT (VVALUE FOR VLIST IN (P_VALUE, S_VALUE, I_VALUE, V_VALUE, M_VALUE, CP_VALUE)) AS UPV_RST
				GROUP BY PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE) T2
				ON T1.PROJECT_CODE = T2.PROJECT_CODE AND T1.END_CUSTOMER = T2.END_CUSTOMER AND T1.YYYYMM = T2.YYYYMM AND T1.MEASURE = T2.MEASURE
				WHERE 1=1
				AND T1.DIVISION_ID = p_division_id
				AND T1.END_CUSTOMER = p_end_customer
				AND T1.PROJECT_CODE = p_project_code
				AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'); --20240112 p_yyyymm_to_simul --> p_yyyymm 로 변경



				IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') >= TO_CHAR(p_yyyymm_from_simul  ||  '01', 'YYYYMMDD')
				AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') <= TO_CHAR(p_yyyymm_to_simul  ||  '01', 'YYYYMMDD') THEN
				--SELECT TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
					--SELECT v_EDI_SUM
					--SELECT TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
					--SELECT TO_CHAR(p_yyyymm_to_simul + '01', 'YYYYMMDD')
					--SELECT v_EDI_SUM
					SELECT
					 v_EDI_SUM = T1.CUST_FCST_M		 ||  NVL(v_EDI_SUM, 0)
					 ,T2.VSUM		 ||  NVL(v_DP_RESULT_SUM AS v_DP_RESULT_SUM, 0)
					,T1.P_VALUE	 ||  NVL(v_DP_RESULT_P AS v_DP_RESULT_P, 0)
					,T1.S_VALUE	 ||  NVL(v_DP_RESULT_S AS v_DP_RESULT_S, 0)
					,T1.I_VALUE	 ||  NVL(v_DP_RESULT_I AS v_DP_RESULT_I, 0)
					,T1.V_VALUE	 ||  NVL(v_DP_RESULT_V AS v_DP_RESULT_V, 0)
					,T1.M_VALUE	 ||  NVL(v_DP_RESULT_M AS v_DP_RESULT_M, 0)
					,NVL(T1.CP_VALUE AS v_DP_RESULT_CP, 0)	 ||  NVL(v_DP_RESULT_CP, 0)
					FROM DM_ANL_MKT_PSI T1
					LEFT OUTER JOIN (SELECT PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE, SUM(VVALUE) AS VSUM
											  FROM DM_ANL_MKT_PSI;
					UNPIVOT (VVALUE FOR VLIST IN (P_VALUE, S_VALUE, I_VALUE, V_VALUE, M_VALUE, CP_VALUE)) AS UPV_RST
					GROUP BY PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE) T2
					ON T1.PROJECT_CODE = T2.PROJECT_CODE AND T1.END_CUSTOMER = T2.END_CUSTOMER AND T1.YYYYMM = T2.YYYYMM AND T1.MEASURE = T2.MEASURE
					WHERE 1=1
					AND T1.DIVISION_ID = p_division_id
		     		AND T1.END_CUSTOMER = p_end_customer
					AND T1.PROJECT_CODE = p_project_code-- IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
					AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
					AND T1.MEASURE = 'DP_RESULT';
				END IF;

		v_i := v_i || 1;

 	END IF;

	-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	BEGIN














	SELECT MONTHS_BETWEEN(1, 4, SUBSTR(p_yyyymm_from_simul)  ||  '-'  ||  SUBSTR(p_yyyymm_from_simul, 5, 2)   ||  '-01', SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, 0), 'YYYYMMDD') , 1, 4)  ||  '-'  ||  SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, 0), 'YYYYMMDD') , 5, 2)   ||  '-01' ),
    TO_CHAR(SYSDATE, 'YYYYMMDD')
  INTO V_YYYYMM_CNT, V_YYYYMM_TO
	END;


	BEGIN
			-- 테이블중복제거
		-- 임시확인용테이블 중복제거
		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_AN_LOGIC';

	END;

	--PRINT V_YYYYMM_CNT


	--SELECT * FROM GT_DMF0_DM_MST_VERSION

		BEGIN

			SELECT NVL(CEILING(SUM(QTY)), 0)
  INTO v_LAST_MONTH_EDI
			FROM DM_PLN_MKT_FCST_C X
			JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
		    JOIN GT_DMF0_SCM_MST_SITE Z
			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
			WHERE 1=1
			AND X.DIVISION_ID = p_division_id
			AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
			--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
			AND X.PROJECT_CODE = p_project_code
			AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
			AND X.FCST_TYPE = 'MPS'
			AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul  ||  '01', 1), 'YYYYMMDD'); --'202308'

			--SELECT TO_CHAR(ADD_MONTHS('202310' + '01', 1), 'YYYYMMDD')

			--SELECT TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul + '01', 1), 'YYYYMMDD')

			--PRINT v_LAST_MONTH_EDI

			--SELECT v_LAST_MONTH_EDI = CUST_FCST_M FROM DM_ANL_MKT_PSI  WHERE 1=1
			--AND PROJECT_CODE = p_project_code
			--AND YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul + '01', 1), 'YYYYMMDD') AND MEASURE = 'DP_RESULT'
		END;


		BEGIN
			--SELECT * FROM GT_DMF0_DATA WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i-1), 'YYYYMMDD')


			v_DP_ANL_SUM := TO_NUMBER(v_DP_RESULT_SUM/v_EDI_SUM);
			v_DP_ANL_P := TO_NUMBER(v_DP_RESULT_P/v_EDI_SUM);
			v_DP_ANL_S := TO_NUMBER(v_DP_RESULT_S/v_EDI_SUM);
			v_DP_ANL_I := TO_NUMBER(v_DP_RESULT_I/v_EDI_SUM);
			v_DP_ANL_V := TO_NUMBER(v_DP_RESULT_V/v_EDI_SUM);
			v_DP_ANL_M := TO_NUMBER(v_DP_RESULT_M/v_EDI_SUM);
			v_DP_ANL_CP := TO_NUMBER(v_DP_RESULT_CP/v_EDI_SUM);

			--SELECT v_DP_ANL_SUM, v_DP_ANL_P
		END;

		--PRINT TO_NUMBER(NVL(v_DP_ANL_SUM, 0))

		DBMS_OUTPUT.PUT_LINE(v_EDI_SUM);

		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_SUM, 0)) * 100) || '%');
		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_P, 0))* 100) || '%');
		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_S, 0))* 100) || '%');
		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_I, 0))* 100) || '%');
		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_V, 0))* 100) || '%');
		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_M, 0))* 100) || '%');
		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_CP, 0))* 100) || '%');

		BEGIN
		    UPDATE GT_DMF0_DATA SET;
			SUM        = ((TO_NUMBER(NVL(v_DP_ANL_SUM, 0)) * 100) || '%')  --(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_SUM, 0), 3)) * 100) || '%')
			,((TO_NUMBER(NVL(v_DP_ANL_P AS PRODUCT, 0)) * 100) || '%')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_P, 0), 3)) * 100) || '%')
			,((TO_NUMBER(NVL(v_DP_ANL_S AS SALE, 0)) * 100) || '%')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_S, 0), 3)) * 100) || '%')
			,((TO_NUMBER(NVL(v_DP_ANL_I AS INVENTORY, 0)) * 100) || '%')  --(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_I, 0), 3)) * 100) || '%')
			,((TO_NUMBER(NVL(v_DP_ANL_V AS TIME_ADJUST, 0)) * 100) || '%')  --(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_V, 0), 3)) * 100) || '%')
			,((TO_NUMBER(NVL(v_DP_ANL_M AS MODEL_MIX, 0)) * 100) || '%')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_M, 0), 3)) * 100) || '%')
			,((TO_NUMBER(NVL(v_DP_ANL_CP AS SUPPLY_ISSUE, 0)) * 100) || '%')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_CP, 0), 3)) * 100) || '%')
			--, PRODUCT = v_DP_ANL_P, SALE = v_DP_ANL_S, INVENTORY = v_DP_ANL_I, TIME_ADJUST = v_DP_ANL_V, MODEL_MIX = v_DP_ANL_M
			WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul  ||  '01', 1), 'YYYYMMDD')    AND MEASURE = 'Average impact(%)';
		END;


		DBMS_OUTPUT.PUT_LINE(v_LAST_MONTH_EDI);

		BEGIN
		    UPDATE GT_DMF0_DATA SET;
			SUM        = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_SUM, 0), 3)) * v_LAST_MONTH_EDI), '#,#')
			,PRODUCT     = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_P, 0), 3)) * v_LAST_MONTH_EDI), '#,#') --(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_P, 0), 2)) * 100) || '%')
			,SALE        = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_S, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_S, 0), 2)) * 100) || '%')
			,INVENTORY   = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_I, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_I, 0), 2)) * 100) || '%')
			,TIME_ADJUST = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_V, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_V, 0), 2)) * 100) || '%')
			,MODEL_MIX   = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_M, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_M, 0), 2)) * 100) || '%')
			,SUPPLY_ISSUE   = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_CP, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_CP, 0), 2)) * 100) || '%')
			--, PRODUCT = v_DP_ANL_P, SALE = v_DP_ANL_S, INVENTORY = v_DP_ANL_I, TIME_ADJUST = v_DP_ANL_V, MODEL_MIX = v_DP_ANL_M
			WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul  ||  '01', 1), 'YYYYMMDD')    AND MEASURE = 'Simulation (Impact)';
		END;



	SELECT T.DIVISION_ID
		,T.END_CUSTOMER
		,T.PROJECT_NAME
		,T.PROJECT_CODE
		,(SUBSTR(YYYYMM, 1, 4) || '.' || SUBSTR(YYYYMM, 5, 2)) AS YYYYMM
		,CEILING(EDI_QTY) AS EDI_QTY
		,MEASURE
		,SUM
		,PRODUCT
		,SALE
		,INVENTORY
		,TIME_ADJUST
		,MODEL_MIX
		,MKT_DP
		,SUPPLY_ISSUE   --2023.11.03 kcw3408 	개발요청 수요분석시스템_35번	Simulation 기능 로직 수정(신규 추가된 '공급차질' 카테고리를 연계하도록)
	FROM GT_DMF0_DATA T
	ORDER BY YYYYMM ASC
		,RNK;
END IF;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_DM_ANL_MKT_PSI_DATA
(
	 p_division_id VARCHAR2
	,p_project_code VARCHAR2
	,p_project_name VARCHAR2
	,p_yyyymm VARCHAR2
	,p_created_by VARCHAR2
	,p_end_customer VARCHAR2
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:36:59
 * 파일: dbo.DMF0003_GET_DM_ANL_MKT_PSI_DATA.sql
 * ----------------------------------------
 * ⚠ IF: IF:8  END IF:9  차이:-1
 * ⚠ BEGIN: BEGIN:21  END:15  차이:+6
 * ----------------------------------------
 * BEGIN 위치: L38, L77, L91, L99, L127, L152, L171, L216, L230, L233 ...
 * END;  위치: L89, L124, L144, L163, L165, L210, L226, L453, L475, L496 ...
 * ----------------------------------------
 * 힌트: END가 8개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    V_CNT INTEGER := 0;
    v_yyyymm VARCHAR2(20 CHAR);
    v_CUST_FCST_M VARCHAR2(4000 CHAR);
    v_MKT_FCST_S VARCHAR2(4000 CHAR);
    v_MKT_FCST_R VARCHAR2(4000 CHAR);
    v_0month_tuesday VARCHAR2(08 CHAR);
    v_0month VARCHAR2(6 CHAR);
    v_1month VARCHAR2(6 CHAR);
BEGIN

		,v_i INTEGER = 1




	    v_DP_RESULT_SUM NUMERIC(20, 10);
	    v_DP_RESULT_P NUMERIC(20, 10);
	    v_DP_RESULT_S NUMERIC(20, 10);
	    v_DP_RESULT_I NUMERIC(20, 10);
	    v_DP_RESULT_V NUMERIC(20, 10);
	    v_DP_RESULT_M NUMERIC(20, 10);
	    v_DP_RESULT_CP NUMERIC(20, 10);
	    v_EDI_SUM NUMERIC(20, 10);
	    v_DP_ANL_SUM NUMERIC(20, 10);
	    v_DP_ANL_P NUMERIC(20, 10);
	    v_DP_ANL_S NUMERIC(20, 10);
	    v_DP_ANL_I NUMERIC(20, 10);
	    v_DP_ANL_V NUMERIC(20, 10);
	    v_DP_ANL_M NUMERIC(20, 10);
	    v_DP_ANL_CP NUMERIC(20, 10);
	    v_DP_ANL_CPI NUMERIC(20, 10);




	v_0month := TO_CHAR(SYSDATE, 'YYYYMMDD'); --M0 당월
	v_1month := TO_CHAR(ADD_MONTHS(SYSDATE, - 1), 'YYYYMMDD'); --M-1 전월
	v_i := - 12;

	-- 테이블중복제거
	-- 임시확인용테이블 중복제거
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DATA';

	-- 테이블중복제거
	-- 임시확인용테이블 중복제거
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION';

	BEGIN
		-- 테이블중복제거
		-- 임시확인용테이블 중복제거
		/* TODO:GTT:GT_DMF0_PROJECT_CODE-->GT_DMF0_PROJECT_CODE */
		INSERT INTO GT_DMF0_PROJECT_CODE
		SELECT *
		FROM (
			SELECT PROJECT_CODE
			FROM SCM_MST_PROJECT
			WHERE DIVISION_ID = p_division_id
				AND PROJECT_NAME = p_project_name
			) A;
	END;

	BEGIN
		--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
		IF DATEPART(WEEKDAY, SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)  ||  '01') = '4' THEN
			v_0month_tuesday := TO_CHAR(/* TODO:(FN_NEXT_DAY(TO_CHAR(SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6) + (- 1) * 7 + '01', 'YYYYMMDD'), 'TUE')) */, 'YYYYMMDD');
		ELSE
			v_0month_tuesday := TO_CHAR(1 || (/* TODO:DATEDIFF(WK,0,(SYSDATE) + (5 - DATEPART(DAY, SYSDATE) */)))*7SYSDATE || (5 - DATEPART(DAY, SYSDATE))), 1), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
		END IF;

		BEGIN
			INSERT INTO GT_DMF0_DM_MST_VERSION (;
				NUM
				,VERSION_NO
				,VERSION_TYPE
				)
			SELECT ROW_NUMBER() OVER (
					ORDER BY X.VERSION_NO
					) AS NUM
				,X.VERSION_NO
				,X.VERSION_TYPE
			FROM (
				SELECT ROW_NUMBER() OVER (
						PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC
						) AS RNK
					,A.VERSION_NO
					,A.VERSION_TYPE
				FROM DM_MST_VERSION A
				JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD
				WHERE 1 = 1
					AND A.DIVISION_ID = p_division_id
					AND A.VERSION_TYPE = 'MF_W' --MKT_FCST Weekly Cutoff
					AND A.YYYYMMDD = v_0month_tuesday
				) X;
			WHERE RNK = 1;
		END;

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------
		BEGIN
	    	-- 테이블중복제거
	       	-- 임시확인용테이블 중복제거
		    /* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
		    INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
		    SELECT *
			FROM DM_MST_ITEM_SINGLE_V
			WHERE DIVISION_ID = p_division_id
				AND ITEM_ID IN (
					SELECT ITEM_ID
					FROM SCM_MST_PROJECT_ITEM
					WHERE PROJECT_CODE = p_project_code --PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
						AND VALID_YN = 'Y'
					)
				AND ITEM_TYPE = 'P'
				AND ACTIVE_FLAG = 'Y';
				--AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_PROJECT_ITEM WHERE PROJECT_CODE = p_project_code AND VALID_YN = 'Y') AND ITEM_TYPE = 'P' AND ACTIVE_FLAG = 'Y'
		END;
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------





		--SCM_MST_SITE 대상건만 추출
		BEGIN
        	-- 테이블중복제거
        	-- 임시확인용테이블 중복제거
        	/* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
        	INSERT INTO GT_DMF0_SCM_MST_SITE
        	SELECT DIVISION_ID
			     , SCM_SITE_ID
				 , END_CUSTOMER
			FROM SCM_MST_SITE
			WHERE DIVISION_ID  = p_division_id
	          AND END_CUSTOMER = p_end_customer;
		END;

	END;

DBMS_OUTPUT.PUT_LINE('A1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	/*
	   2023.11.02	   kcw3408		  DP_RESULT(Demand Plan (final)) ⓓMKT.FCST (DP) 에 MKTFCST 화면에 월 MKT FCST[R || P] Measure실적과 동일하게 관리
    */
	BEGIN

		UPDATE T1
		SET MKT_FCST_M = T2.A_QTY
		FROM DM_ANL_MKT_PSI T1
		JOIN
		    (SELECT X.DIVISION_ID
			      , H.END_CUSTOMER
			      , X.PROJECT_CODE
				  , SUBSTR(X.YYYYMMDD, 1, 6) AS YYYYMM
			      , NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
			   FROM DM_PLN_MKT_FCST_RESULT X
			   JOIN SCM_MST_SITE_ITEM F
				    ON	F.DIVISION_ID    = X.DIVISION_ID
				   AND	F.PROJECT_CODE   = X.PROJECT_CODE
				   AND	F.SCM_SITE_ID    = X.SCM_SITE_ID
				   AND	F.ITEM_ID        = X.ITEM_ID
			   JOIN GT_DMF0_SCM_MST_SITE H
				    ON	F.DIVISION_ID    = H.DIVISION_ID
				   AND	F.SCM_SITE_ID    = H.SCM_SITE_ID
			  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
			       ON	G.SEGMENT1    = X.FCST_TYPE
				  AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE'
		      WHERE 1 = 1
		        AND X.DIVISION_ID = p_division_id
			    AND X.PROJECT_CODE = p_project_code
	            AND X.MEASURE = 'RTF_SYS_RP'
				AND SUBSTR(X.YYYYMMDD, 1, 6) >= TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', -12), 'YYYYMMDD')
				AND SUBSTR(X.YYYYMMDD, 1, 6) <= TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', -1), 'YYYYMMDD')
			GROUP BY X.DIVISION_ID
			      , H.END_CUSTOMER
			      , X.PROJECT_CODE
				  , SUBSTR(X.YYYYMMDD, 1, 6)
		  ) T2;
		 ON T2.DIVISION_ID = T1.DIVISION_ID
		AND T2.PROJECT_CODE = T1.PROJECT_CODE
		AND T2.END_CUSTOMER = T1.END_CUSTOMER
		AND T2.YYYYMM = T1.YYYYMM
		AND T1.MEASURE = 'DP_RESULT';
	END;


DBMS_OUTPUT.PUT_LINE('B1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--SELECT * FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
	WHILE v_i <= 0 LOOP
		BEGIN
			SELECT COUNT(*)
  INTO V_CNT
			FROM DM_ANL_MKT_PSI
			WHERE 1 = 1
				AND DIVISION_ID = p_division_id
				--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
				AND PROJECT_CODE = p_project_code
				AND END_CUSTOMER = p_end_customer
				AND YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD');
		END;

DBMS_OUTPUT.PUT_LINE('C1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		BEGIN
			IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') THEN
				--고객수요계획
				BEGIN
					IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
						SELECT (A_QTY  ||  B_QTY)
  INTO v_CUST_FCST_M
						FROM (
							SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
							FROM DM_PLN_MKT_FCST_C X
							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
							JOIN GT_DMF0_SCM_MST_SITE Z
							ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE 1 = 1
								AND X.DIVISION_ID = p_division_id
								AND X.MEASURE IN (;
									'CUST_FCST_EDI'
									,'CUST_FCST'
									)
								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
								AND X.PROJECT_CODE = p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND X.ITEM_ID IN (
									SELECT ITEM_ID
									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
								AND X.QTY <> 0
							) A;
							,(
								SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
								FROM DM_PLN_MKT_FCST_RESULT_C X
								JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
							    JOIN GT_DMF0_SCM_MST_SITE Z
						     	ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
								WHERE 1 = 1
									AND X.DIVISION_ID = p_division_id
									AND X.MEASURE IN (;
										'CUST_FCST_EDI'
										,'CUST_FCST'
										)
									--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
									AND X.PROJECT_CODE = p_project_code
									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
									AND X.ITEM_ID IN (
										SELECT ITEM_ID
										FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
										)
									AND X.FCST_TYPE = 'MPS'
									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
									AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
								) B;
DBMS_OUTPUT.PUT_LINE('i : '  ||  TO_CHAR(v_i));
DBMS_OUTPUT.PUT_LINE('0month_tuesday : '  ||  v_0month_tuesday);
DBMS_OUTPUT.PUT_LINE('CUST_FCST_M : '  ||  v_CUST_FCST_M);
					ELSE
						SELECT 0
  INTO v_CUST_FCST_M
				END IF;

DBMS_OUTPUT.PUT_LINE('D1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				--마케팅수요계획
				BEGIN
					IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
						SELECT (A_QTY  ||  B_QTY)
  INTO v_MKT_FCST_S
						FROM (
							SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
							FROM DM_PLN_MKT_FCST_C X
							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
							JOIN GT_DMF0_SCM_MST_SITE Z
							ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE 1 = 1
								AND X.DIVISION_ID = p_division_id
								AND X.MEASURE = 'RTF_SYS_RP'
								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
								AND X.PROJECT_CODE = p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND X.ITEM_ID IN (
									SELECT ITEM_ID
									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
								AND X.QTY <> 0
							) A;
							,(
								SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
								FROM DM_PLN_MKT_FCST_RESULT_C X
								JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
						    	JOIN GT_DMF0_SCM_MST_SITE Z
							    ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
								WHERE 1 = 1
									AND X.DIVISION_ID = p_division_id
									AND X.MEASURE = 'RTF_SYS_RP'
									--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
									AND X.PROJECT_CODE = p_project_code
									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
									AND X.ITEM_ID IN (
										SELECT ITEM_ID
										FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
										)
									AND X.FCST_TYPE = 'MPS'
									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
									AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
								) B;
					ELSE
						SELECT v_MKT_FCST_S = 0

DBMS_OUTPUT.PUT_LINE('E1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

					IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_1month
		             OR (V_CNT = 0) THEN
					    /* 2023.11.02	   kcw3408		  전월 실적 구하기 ,기존로직 삭제
						SELECT v_MKT_FCST_R = (A_QTY || B_QTY)
						FROM (
							SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
							FROM DM_PLN_MKT_FCST_C X
							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
							WHERE 1 = 1
								AND DIVISION_ID = p_division_id
								AND MEASURE = 'RTF_SYS_RP'
								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
								AND PROJECT_CODE = p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND ITEM_ID IN (
									SELECT ITEM_ID
									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTR(YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', - 1), 'YYYYMMDD')
								AND QTY <> 0
							) A;
							,(
								SELECT NVL(CEILING(SUM(QTY)), 0) AS B_QTY
								FROM DM_PLN_MKT_FCST_RESULT_C X
								JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
								WHERE 1 = 1
									AND DIVISION_ID = p_division_id
									AND MEASURE = 'RTF_SYS_RP'
									--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
									AND PROJECT_CODE = p_project_code
									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
									AND ITEM_ID IN (
										SELECT ITEM_ID
										FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
										)
									AND X.FCST_TYPE = 'MPS'
									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
									AND SUBSTR(YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', - 1), 'YYYYMMDD')
								) B;
					    */
						SELECT v_MKT_FCST_R = A.A_QTY
						FROM (
								SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
								FROM DM_PLN_MKT_FCST_RESULT X
		                        JOIN SCM_MST_SITE_ITEM F
				                     ON	F.DIVISION_ID    = X.DIVISION_ID
				                    AND	F.PROJECT_CODE   = X.PROJECT_CODE
			                        AND	F.scm_site_id    = X.scm_site_id
                                    AND	F.ITEM_ID        = X.ITEM_ID
			                   JOIN GT_DMF0_SCM_MST_SITE H
				                    ON	F.DIVISION_ID    = H.DIVISION_ID
				                   AND	F.SCM_SITE_ID    = H.SCM_SITE_ID
			                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
			                        ON	G.SEGMENT1    = X.FCST_TYPE
				                   AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE'
								WHERE 1 = 1
									AND X.DIVISION_ID = p_division_id
									AND X.MEASURE = 'RTF_SYS_RP'
									AND X.PROJECT_CODE = p_project_code
									AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
							) A;
					ELSE
						SELECT v_MKT_FCST_R = 0
				END IF;

DBMS_OUTPUT.PUT_LINE('F1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			ELSE
				SELECT 0,
    0,
    0
  INTO v_CUST_FCST_M, v_MKT_FCST_S, v_MKT_FCST_R
		END IF;

		DBMS_OUTPUT.PUT_LINE('=================================');
		DBMS_OUTPUT.PUT_LINE(p_yyyymm);
		DBMS_OUTPUT.PUT_LINE(v_0month_tuesday);
		DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYYMMDD'));
		DBMS_OUTPUT.PUT_LINE(TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'));
		DBMS_OUTPUT.PUT_LINE(v_0month);
		DBMS_OUTPUT.PUT_LINE(V_CNT);
		DBMS_OUTPUT.PUT_LINE(v_CUST_FCST_M);
		DBMS_OUTPUT.PUT_LINE('=================================');

DBMS_OUTPUT.PUT_LINE('G1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		IF (V_CNT = 0) THEN
			IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
				AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
				BEGIN
					INSERT INTO GT_DMF0_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
						,v_CUST_FCST_M
						,'Average impact(%)'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,NULL
						,'1' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				END;

DBMS_OUTPUT.PUT_LINE('H1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				BEGIN
					INSERT INTO GT_DMF0_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
						,v_CUST_FCST_M
						,'Simulation (Impact)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,'2' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				END;

DBMS_OUTPUT.PUT_LINE('I1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				BEGIN
					INSERT INTO GT_DMF0_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
						,v_CUST_FCST_M
						,'Demand Plan (1st)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,CEILING(v_MKT_FCST_S)
						,'3' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				END;

DBMS_OUTPUT.PUT_LINE('J1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				BEGIN
					INSERT INTO GT_DMF0_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
						,v_CUST_FCST_M
						,'Demand Plan (final)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,CEILING(v_MKT_FCST_R)
						,'4' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				END;

DBMS_OUTPUT.PUT_LINE('K1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			ELSE
				BEGIN
					INSERT INTO GT_DMF0_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
						,0
						,'Average impact(%)'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,NULL
						,'1' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				END;

DBMS_OUTPUT.PUT_LINE('L1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				BEGIN
					INSERT INTO GT_DMF0_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
						,0
						,'Simulation (Impact)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,'2' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				END;
DBMS_OUTPUT.PUT_LINE('M1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				BEGIN
					INSERT INTO GT_DMF0_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
						,0
						,'Demand Plan (1st)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,CEILING(v_MKT_FCST_S)
						,'3' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				END;

DBMS_OUTPUT.PUT_LINE('N1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				BEGIN
					INSERT INTO GT_DMF0_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
						,0
						,'Demand Plan (final)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,CEILING(v_MKT_FCST_R)
						,'4' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				END;
DBMS_OUTPUT.PUT_LINE('O1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		ELSE
			-- 고객수요증감분석 전체조회
			---SELECT v_0month_tuesday, TO_CHAR(SYSDATE, 'YYYYMMDD') , TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD'), v_0month
			INSERT INTO GT_DMF0_DATA
			SELECT T1.DIVISION_ID AS DIVISION_ID
				,p_end_customer
				,p_project_name
				,p_project_code
				,T1.YYYYMM AS YYYYMM
				,(
					CASE
						WHEN NVL(T1.CUST_FCST_M, 0) = 0
							THEN v_CUST_FCST_M
						WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
							AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month;
							THEN v_CUST_FCST_M
						ELSE CEILING(T1.CUST_FCST_M)
						END IF;
					) AS EDI_QTY
				,(
					CASE T1.MEASURE
						WHEN 'AN_LOGIC'
							THEN 'Average impact(%)'
						WHEN 'AN_RESULT'
							THEN 'Simulation (Impact)'
						WHEN 'DP_INIT'
							THEN 'Demand Plan (1st)'
						WHEN 'DP_RESULT'
							THEN 'Demand Plan (final)'
						END IF;
					) AS MEASURE
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN (TO_CHAR((ROUND(TO_NUMBER(T2.VSUM), 2))) || '%')
						ELSE TO_CHAR(CEILING(T2.VSUM), '#,#')
						END IF;
					) AS SUM
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN (TO_CHAR(ROUND(TO_NUMBER(T1.P_VALUE), 2)) || '%')
						ELSE TO_CHAR(CEILING(T1.P_VALUE), '#,#')
						END;
					) AS PRODUCT
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN (TO_CHAR((ROUND(TO_NUMBER(T1.S_VALUE), 2))) || '%')
						ELSE TO_CHAR(CEILING(T1.S_VALUE), '#,#')
						END;
					) AS SALE
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN (TO_CHAR((ROUND(TO_NUMBER(T1.I_VALUE), 2))) || '%')
						ELSE TO_CHAR(CEILING(T1.I_VALUE), '#,#')
						END IF;
					) AS INVENTORY
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN (TO_CHAR((ROUND(TO_NUMBER(T1.V_VALUE), 2))) || '%')
						ELSE TO_CHAR(CEILING(T1.V_VALUE), '#,#')
						END;
					) AS TIME_ADJUST
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN (TO_CHAR((ROUND(TO_NUMBER(T1.M_VALUE), 2))) || '%')
						ELSE TO_CHAR(CEILING(T1.M_VALUE), '#,#')
						END LOOP;
					) AS MODEL_MIX
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN (TO_CHAR((ROUND(TO_NUMBER(NVL(T1.CP_VALUE, 0)), 2))) || '%')
						ELSE TO_CHAR(CEILING(NVL(T1.CP_VALUE, 0)), '#,#')
						END;
					) AS SUPPLY_ISSUE --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				,(
					CASE
						WHEN T1.MEASURE = 'AN_RESULT'
							THEN (
									CASE
										WHEN NVL(T1.MKT_FCST_M, 0) = 0
											THEN 0
										ELSE CEILING(T1.MKT_FCST_M)
										END;
									)
						WHEN T1.MEASURE = 'DP_INIT'
							THEN (
									CASE
										WHEN NVL(T1.MKT_FCST_M, 0) = 0
											THEN CEILING(v_MKT_FCST_S)
										WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
											AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month;
											THEN CEILING(v_MKT_FCST_S)
										ELSE CEILING(T1.MKT_FCST_M)
										END;
									)
						WHEN T1.MEASURE = 'DP_RESULT'
							THEN (
									CASE
										WHEN NVL(T1.MKT_FCST_M, 0) = 0
										THEN CEILING(v_MKT_FCST_R)
												--WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD') = v_1month THEN
												-- CEILING(v_MKT_FCST_R)
										WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
											AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month;
											THEN CEILING(v_MKT_FCST_R)
										ELSE CEILING(T1.MKT_FCST_M)
										END;
									)
						ELSE NULL
						END;
					) MKT_DP;
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN '1'
						WHEN T1.MEASURE = 'AN_RESULT'
							THEN '2'
						WHEN T1.MEASURE = 'DP_INIT'
							THEN '3'
						ELSE '4'
						END;
					) RNK;
			FROM DM_ANL_MKT_PSI T1
			LEFT OUTER JOIN (
				SELECT PROJECT_CODE
			      	,END_CUSTOMER
					,YYYYMM
					,MEASURE
					,SUM(VVALUE) AS VSUM
				FROM DM_ANL_MKT_PSI;
				UNPIVOT(VVALUE FOR VLIST IN (
							P_VALUE
							,S_VALUE
							,I_VALUE
							,V_VALUE
							,M_VALUE
							,CP_VALUE
							)) AS UPV_RST --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
				GROUP BY PROJECT_CODE,END_CUSTOMER
					,YYYYMM
					,MEASURE
				) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
				AND T1.END_CUSTOMER = T2.END_CUSTOMER
				AND T1.YYYYMM = T2.YYYYMM
				AND T1.MEASURE = T2.MEASURE
			WHERE 1 = 1
				AND T1.DIVISION_ID = p_division_id
				AND T1.END_CUSTOMER = p_end_customer
				AND T1.PROJECT_CODE = p_project_code -- IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
				--AND T1.PROJECT_CODE = p_project_code
				AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD');

DBMS_OUTPUT.PUT_LINE('P1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));


			IF v_i <= - 1 THEN
				--SELECT TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
				SELECT T1.CUST_FCST_M  ||  NVL(v_EDI_SUM, 0),
    T2.VSUM  ||  NVL(v_DP_RESULT_SUM, 0),
    T1.P_VALUE  ||  NVL(v_DP_RESULT_P, 0),
    T1.S_VALUE  ||  NVL(v_DP_RESULT_S, 0),
    T1.I_VALUE  ||  NVL(v_DP_RESULT_I, 0),
    T1.V_VALUE  ||  NVL(v_DP_RESULT_V, 0),
    T1.M_VALUE  ||  NVL(v_DP_RESULT_M, 0),
    NVL(T1.CP_VALUE, 0)  ||  NVL(v_DP_RESULT_CP, 0)
  INTO v_EDI_SUM, v_DP_RESULT_SUM, v_DP_RESULT_P, v_DP_RESULT_S, v_DP_RESULT_I, v_DP_RESULT_V, v_DP_RESULT_M, v_DP_RESULT_CP
				FROM DM_ANL_MKT_PSI T1
				LEFT OUTER JOIN (
					SELECT PROJECT_CODE
						,END_CUSTOMER
						,YYYYMM
						,MEASURE
						,SUM(VVALUE) AS VSUM
					FROM DM_ANL_MKT_PSI;
					UNPIVOT(VVALUE FOR VLIST IN (
								 P_VALUE
								,S_VALUE
								,I_VALUE
								,V_VALUE
								,M_VALUE
								,CP_VALUE
								)) AS UPV_RST --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
					GROUP BY PROJECT_CODE,END_CUSTOMER
						,YYYYMM
						,MEASURE
					) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
					AND T1.YYYYMM = T2.YYYYMM
					AND T1.END_CUSTOMER = T2.END_CUSTOMER
					AND T1.MEASURE = T2.MEASURE
				WHERE 1 = 1
					AND T1.DIVISION_ID = p_division_id
		     		AND T1.END_CUSTOMER = p_end_customer
					AND T1.PROJECT_CODE = p_project_code -- IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
					AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
					AND T1.MEASURE = 'DP_RESULT';
			END IF;
		END;


		v_i := v_i || 1;
			--		v_EDI_SUM
	END;

DBMS_OUTPUT.PUT_LINE('Q1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- -----------------------------------------------------------------------------------------------------------------------------------------------
	BEGIN

		--SELECT * FROM GT_DMF0_DATA WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i-1), 'YYYYMMDD')
		v_DP_ANL_SUM := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_SUM / v_EDI_SUM) END;
		v_DP_ANL_P := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_P / v_EDI_SUM) END;
		v_DP_ANL_S := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_S / v_EDI_SUM) END;
		v_DP_ANL_I := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_I / v_EDI_SUM) END;
		v_DP_ANL_V := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_V / v_EDI_SUM) END;
		v_DP_ANL_M := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_M / v_EDI_SUM) END;
		v_DP_ANL_CP := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_CP / v_EDI_SUM) END; --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
			--SELECT v_DP_ANL_SUM
	END;

DBMS_OUTPUT.PUT_LINE('R1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--20240617 화면 조회불가로 임시조치 NUMBERIC(3, 2) -> NUMBERIC(5, 2)로 변경
	BEGIN
		UPDATE GT_DMF0_DATA
		SET SUM = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_SUM, 0), 2)) * 100) || '%')
			,PRODUCT = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_P, 0), 2)) * 100) || '%')
			,SALE = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_S, 0), 2)) * 100) || '%')
			,INVENTORY = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_I, 0), 2)) * 100) || '%')
			,TIME_ADJUST = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_V, 0), 2)) * 100) || '%')
			,MODEL_MIX = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_M, 0), 2)) * 100) || '%')
			,SUPPLY_ISSUE = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_CP, 0), 2)) * 100) || '%') --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
			--, PRODUCT = v_DP_ANL_P, SALE = v_DP_ANL_S, INVENTORY = v_DP_ANL_I, TIME_ADJUST = v_DP_ANL_V, MODEL_MIX = v_DP_ANL_M
		WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i - 1), 'YYYYMMDD')
			AND MEASURE = 'Average impact(%)';
	END;
		-- -----------------------------------------------------------------------------------------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('S1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	SELECT T.DIVISION_ID
		,T.END_CUSTOMER
		,T.PROJECT_NAME
		,T.PROJECT_CODE
		,(SUBSTR(YYYYMM, 1, 4) || '.' || SUBSTR(YYYYMM, 5, 2)) AS YYYYMM
		,CEILING(EDI_QTY) AS EDI_QTY
		,MEASURE
		,SUM
		,PRODUCT
		,SALE
		,INVENTORY
		,TIME_ADJUST
		,MODEL_MIX
		,MKT_DP
		,SUPPLY_ISSUE --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
	FROM GT_DMF0_DATA T
	ORDER BY YYYYMM ASC
		,RNK;
END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_MKT_FCST_DATA
    ( P_DIVISION_ID      IN  VARCHAR2
    , P_SCM_SITE_ID      IN  VARCHAR2
    , P_PLANT_SITE_ID    IN  VARCHAR2
    , P_TEAM_ID          IN  VARCHAR2
    , P_CUSTOMER         IN  VARCHAR2
    , P_BIZ_TYPE         IN  VARCHAR2
    , P_PROJECT_CODE     IN  VARCHAR2
    , P_ITEM_ID          IN  VARCHAR2
    , P_FROM_YYYYMMDD    IN  VARCHAR2
    , P_TO_YYYYMMDD      IN  VARCHAR2
    , P_CREATED_BY       IN  VARCHAR2
    , P_USER_GROUP       IN  VARCHAR2
    , P_ITEM_TYPE        IN  VARCHAR2
    , P_OWNER            IN  VARCHAR2
    , P_QTY_YN           IN  VARCHAR2
    , P_CELL_YN          IN  VARCHAR2
    , P_INVALID_EXEC     IN  VARCHAR2   -- [C20200612-000174] ESS사업부 New Model Flag
    , P_AS_YN            IN  VARCHAR2
    , P_USER_DEPT_ID     IN  VARCHAR2   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
    , P_SENDER_CODE      IN  VARCHAR2   -- SENDER_CODE 추가
    , P_USER_ID          IN VARCHAR2
    , P_MENU_ID          IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RC2              OUT SYS_REFCURSOR   -- 8주 이내 bucket 정보
    , O_RC3              OUT SYS_REFCURSOR   -- 현재 주차 정보
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR

    )
/*=====================================================================================================================================================
 * Program ID  : DMF0003_GET_MKT_FCST_DATA
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date				In Charge    Description
 *=====================================================================================================================================================
 * 2017.11.24		SongDH		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.14		KHSONG		BALANCE MEASURE 신규추가로 MINUS값까지 보여주기위하여 QTY <> 0 로 수정
 * 2018.05.30		JYE			복수 팀 권한 관련  수정
 * 2018.07.12		KHSONG		속도개선 수정버젼임
 * 2018.07.27		SonYoungSuk 컬럼 정렬 정보
 * 2018.07.30		SonYoungSuk 검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정
 * 2018.08.08		KHSONG		실적구간 중복되어 between 에서 수식으로 수정/p_from 변수사용
 * 2018.08.09		ytchoi		조건수정으로 속도개선
 * 2018.08.10		ytchoi		조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
 * 2018.08.09		JYE			멀티 오너 추가
 * 2018.08.13		JYE			Qty '0' 포함 추가
 * 2018.08.16		KHSONG		VALID_YN 조건추가
 * 2018.08.23		JYE			멀티 오너에 대한 수정 권한 수정. 신규 함수 적용.
 * 2018.09.04		JYE			멀티 오너에 대한 수정 권한 변경 수정 -- 주석처리.20180912
 * 2018.09.11		SonYoungSuk 조회 컬럼 CELL_TYPE 추가 #TEMP_DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회
 * 2018.09.28		JYE			RTF 수정 불가 처리
 * 2018.10.04		SonYoungSuk MEASURE VMI_IN_Req, VMI_IN_Plan Edit 가능
 * 2018.11.01		khsong		특정기간(20181101-20190531) 조회시 에러발생으로 BUCKET_PER null조건추가
 * 2018.11.02					속도개선을 의해서 추가
 * 2018.11.14		JYE			Cell Qty 환산 추가
 * 2018.11.15		JYE			소형 사업부 8주 이내는 일별로만 입력되도록
 * 2018.12.21		KHSONG		PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS 참조하여 주석처리함
 * 2019.01.18		KHSONG		중복제거위한 DISTINCT추가
 * 2019.01.21		KHSONG		MERGE 추가
 * 2019.01.23		KHSONG		전지재료DIV설정 (''42'',''44'') -> 20190624 모두 제거함
 * 2019.02.13		KHSONG		[CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건
 * 2019.02.14		JYE			정렬 쿼리에 디비전 조건 추가
 * ----------------------------------------------------------------------------------------
 * 20190219 KHSONG JOIN 조건 위로 올려서 속도개선한 버전
 * ----------------------------------------------------------------------------------------
 * 2019.02.19		KHSONG		숫자가 아닌 MEASURE는 FORECAST_INFO_CELL_PACK_COUNT로 곱하지 않도록 수정
 * 2019.03.08		KHSONG		[CSR ID:3940493] MKT FcstUI상 Shipping Plan Measure 추가 (SHIPMENT_PLAN)
 * 2019.03.22		KHSONG		고객군, 판매처 컬럼 NULL처리조건 추가
 * 2019.04.01		KHSONG		81,82인경우 PROJECT_CODE 를 출력하면 GROUP이 묶이지 않으므로 END_CUSTOMER 출력으로 변경함
 * 2019.04.19		KHSONG		[CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
 * 2019.06.24		KHSONG		[CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용
 * 2019.07.04		KHSONG		ITEM_ID = ('MCCM346010A1,MCCM346010A1-D06') 이렇게 조회시 두배로 보이는 현상으로 재 GROUP
 * 2019.07.05		KHSONG		[CSR ID:4023158] Column / Measure 추가 Setting 요청건 (Column 3개 : Cell/Module , Cell/Car , Module/Car) (Measure 4개:MKT_FCST_RP_CAR,MKT_FCST_RP_CELL,RTF_RP_CAR,RTF_RP_CELL)
 * 2019.02.14		JYE			Warranty 용도 권한 추가
 * 2019.08.09		KHSONG		[CSR ID:4059971] VMI-In Request 로직 변경 -> ESS 사업부 별도추가 필요없음
 * 2019.10.02		KHSONG		조회시 DB Lock 현상으로 로직수정
 * 2019.10.29		KYH			Shipment_Plan 관련 MKT_FCST 의 기간조건 제거
 * 2019.11.18		KHSONG		[CSR ID:C20191031-000137] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건
 * 2019.11.19		KHSONG		Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
 * 2020.01.30		KHSONG		[C20200114-000201] ESS사업부 ENERGE, CELL_QUANTITY 컬럼/Measure추가
 * 2020.02.17		KHSONG		C20200103-000586 'SCM PI Admin' ADD
 * 2020.02.18		KHSONG		C20200212-000304 : GSCM 차량대수 환산 오류 개선 요청 건
 * 2020.02.25		KHSONG		C20200221-000056 Sales plan waterfall 차량대수 환산 logic 변경 요청 RTF MEASURE 삭제
 * 2020.03.09		KHSONG		C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
 * 2020.03.11		KHSONG		C20200103-000586 권한그룹을 LOOKUP관리
 * 2020.06.05		P.C.I		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
 * 2020.06.18		P.C.I		[C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터
 * 2020.07.02		P.C.I		[C20200702-000136] Sales Price check시 currency 제외, new_flag 추가
 * 2020.07.16		HWI1993		[C20200713-000189] [VMI-in Req] VMI Biz의 경우 VMI-in Req 입력을 통한 MKT FCST 자동산출 로직 추가
 * 2020.07.23		P.C.I		[prepare] MKT_FCST_RP 실적 구간 변경(현재 기준 전주 일요일까지)
 * 2020.08.31		hwi1993		[C20200812-000104] [시스템 변경요청]  Active = ‘N’ 인 Model 도 조회되도록 변경
 * 2020.10.15		hwi1993		[C20201015-000200] VMi 원복 (원본은 C20200713-000189 ). 원복하기로 해서 프로시저는 삭제하지 않고, Agent 에서만 제거함.
 * 2020.11.13		hwi1993		개발에서 ssp sync 작업한 버전을 [DMF0003_GET_MKT_FCST_DATA_SSP_SYNC_작업분] 으로 백업하고, 운영에서 새로 내려받음
 * 2020.11.13		hwi1993		[C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건
 * 2020.11.27		hwi1993		[C20201103-000114]. Sales Price 기반으로 데이터 가져오는 부분에서는 VMI 메저 강제추가 제거함.
 * 2020.12.15		hwi1993		[C20201105-000099] 오류 데이터 삭제요청 -- ESS 의 경우 Future Price 를 참조할 때 FCST_TYPE = '' 인 것들 제외
 * 2020.12.28		HWI1993		[C20200804-000123] MKT FCST - SSP 동기화
 * 2021.01.14		HWI1993		[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( ATP 메저 보완 )
 * 2021.02.26		P.C.I		[C20210225-000385] 동기화 기준은 ATTRIBUTE4, ATTRIBUTE5으로 구분
 * 2021.05.12		hwi1993		[PJ20209642R] Digital SCM Level.3 달성을 위한 개선 - ESS 상품 PR
 * 2021.05.17		HWI1993		[PJ20209642R] Digital SCM Level.3 달성을 위한 개선 - 중장기계획
 * 2021.06.18		HWI1993		[PJ20209642R] PR REQUEST 에 원재료 추가
 * 2021.08.10		hwi1993		[C20210810-000268] 메저 순서 변경 시 오류 발생
 * 2021.08.24		HWI1993		[과제]_BOD 유효기간 추가
 * 2021.09.01		SJHAN		[C20210827-000130] GSCM내 VMI inventory값 표시 변경 요청
 * 2021.09.15		SJHAN		[PJ20209643]-속도개선
 * 2021.09.17		hwi1993		[PJ20209643] AS 프로세스
 * 2021.11.02		hwi1993		[PJ20209643] AS 프로세스 - balance 메저 표시방법 변경, 룩업 컬럼 변경
 * 2021.11.17		hwi1993		[PJ20209643] 성능개선 - hash 옵션 추가 등
 * 2021.11.18		kdw2819		[과제]_자동차 사업부 JV Planner 의 조회 권한 추가
 * 2021.11.19		ROSIA27		[C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
 * 2021.11.30		rosia27		[C20211122-000414]속도개선을 위한 색구현 및 조회조건 변경안
 * 2021.12.07		rosia27		[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
 * 2021.12.15		kdw2819		[C20211215-000076] 1년 이상 조회기간을 설정하여도 가능하도록 변경 건
 * 2022.01.06		hwi1993		[] sales_type_code 룩업의 as 전용 fcst type 을 사용할수 없게 되어서, as 구분방법 변경
								( 고객향은 attribute10, 플랜트향은 scm_site_id 이용 )
 * 2022.02.07		kdw2819		[C20220125-000192] MKT FSCT 상 From stie 표기 요청의 건
 * 2022.02.24		HWI1993		[C20220218-000409] GSCM-DM AS Inventory 메저 계산 로직 수정 -- INV 메저 표시방법 변경, INTRANSIT 메저의 ATTR10 오류 수정
 * 2022.04.05		rosia27		[과제PJ20216891R]GM_JV
 * 2022.12.14		rosia27		[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
 * 2023.03.13		rosia27		[E20230308-000315] [시스템 오류] Owner 조회조건 수정 요청 건
 * 2023.05.03		kdmcc14		[EDI과제]
 * 2023.08.25		JSSBAE		[E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청(LOOKUP이용)
 * 2023.10.19		JSSBAE		[E20231018-000776]_[영업/마케팅 PI팀] MKT FCST 화면 SHIPMENT_PLAN 메저 로직 수정 프로그램 화면 내 메져의 VALID가 Y인 대상만 나오도록 수정
 * 2023.11.21		chano0612	[고객수요분석시스템 정비] EDI데이터 중복건 제거
 * 2023.12.07		kcw3408		[개발요청] 수요분석시스템_4_고객수요 Measure 통합
 * 2024.01.15		JSSBAE		[E20240102-000545] [마케팅PI] 82번 사업부 - VMI표기 로직 개선
 * 2024.03.07       kcw3408     DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
 * 2024.05.17       kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024.07.18		JSSBAE		[E20240712-001683]_'MKT FCST 미등록제외' 관련 소스 수정
 * 2024.08.02		JSSBAE		[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024.09.05		JSSBAE		[E20240812-000094]_82사업부 MKT FCST 화면 Energy Measure 소수점 자리수 수정 요청
 * 2024.08.27		KJJ			[PJ2024-50461] Team Mapping
 * 2024.09.12		JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.11.04		JSSBAE		[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건
 *                              SSPM에 신규 추가 요청드린 'Project(S&OP Report)' 컬럼 MKT FCST Waterfall 사용자 화면에 추가 요청
 * 2024.11.12		JSSBAE		[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건
 * 2024.12.04		JSSBAE		[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
 * 2025.07.07		KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.01.23		JSSBAE		[E20260123-001715]_E20241015-000415 CSR 원복 요청
 * 2026.02.20		JSSBAE		[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
 * 2026.04.13       kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                                  SCM_MST_SITE_ITEM Table PROJECT_S_OP_REPORT Column 삭제에 따라 컬럼 사용 문장 삭제
 *                                  ORA-01799: a column may not be outer-joined to a subquery 방지용으로 불필요한 outer join 제거
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='40', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='', @p_cell_yn='', @p_invalid_exec='', @p_as_yn='', @p_user_dept_id='58235660',@p_sender_code='ALL'
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='81', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='', @p_cell_yn='', @p_invalid_exec='', @p_as_yn='', @p_user_dept_id='58235660',@p_sender_code='ALL'
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='82', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='', @p_cell_yn='', @p_invalid_exec='', @p_as_yn='', @p_user_dept_id='58235660',@p_sender_code='ALL'
 *===================================================================================================================================================*/
AS
    -- 프로그램명 (로그용)
    $$PLSQL_UNIT      VARCHAR2(150);

    -- 동적 SQL / PIVOT 관련
    V_SQL_TEXT          CLOB;
    V_PV_LIST           CLOB    := '';
    V_PV_COL_LIST       CLOB    := '';
    V_PV_COLUMN_NAME    VARCHAR2(1000);
    V_PV_NAME           VARCHAR2(200);
    V_SORT_ORDER_NO     VARCHAR2(50);
    V_COLUMN_NAME       VARCHAR2(100);
    V_COLUMN            CLOB    := '';
    V_GROUPBY           CLOB    := '';
    V_ORDERBY           CLOB    := '';

    -- 프로그램 / 시트 고정값
    VA_PROGRAM_ID       VARCHAR2(50)  := 'DMF0003';
    VA_SHEET_NAME       VARCHAR2(50)  := 'Mkt Fcst';

    -- 권한 / 부서
    V_GROUP_ID          VARCHAR2(50)  := '';
    V_DEPT_ID           VARCHAR2(50)  := '';

    -- 조회 구간 날짜 변수
    V_EXP_YYYYMMDD      VARCHAR2(8);
    V_FROM_YYYYMMDD     VARCHAR2(8)   := '';   -- 계획 구간 FROM (당주 월요일 기준)
    V_TO_YYYYMMDD       VARCHAR2(8)   := '';   -- 계획 구간 TO
    V_FROM_RESULT       VARCHAR2(8)   := '';   -- 실적 구간 FROM
    V_TO_RESULT         VARCHAR2(8)   := '';   -- 실적 구간 TO
    V_USER_TIME_ZONE    VARCHAR2(50)  := '';

    -- 사용자 컬럼/메저 카운트
    V_USER_COL_CNT      PLS_INTEGER   := 0;
    V_USER_MEA_CNT      PLS_INTEGER   := 0;

    -- IN 파라미터를 로컬 복사본으로 사용 (IN 파라미터 직접 수정 불가)
    LP_AS_YN            VARCHAR2(1);
    LP_SCM_SITE_ID      VARCHAR2(4000);
    LP_PROJECT_CODE     VARCHAR2(4000);

    -- 팀 WHERE 조건 (동적 SQL에 삽입)
    V_TEAM_WHERE        VARCHAR2(4000);

    -- 예외처리 / 로그 변수
    V_LOG_TYPE          VARCHAR2(30);
    V_LOG_MESSAGE       VARCHAR2(1000);
    V_DESCRIPTION       VARCHAR2(500);
    D_EVENT_DATE        DATE;
    V_SQL_CODE          VARCHAR2(20);
    V_SQL_ERRMSG        VARCHAR2(4000);
    V_BACKTRACE         VARCHAR2(4000);
    V_PROC_INPUT        CLOB;

    -- T_SSP_SYNC 컬렉션용
    T_SCM_SITE_IDS      SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();

BEGIN
    -----------------------------------------------------------------------
    -- 프로그램명 설정
    -----------------------------------------------------------------------
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    -- IN 파라미터 로컬 복사
    LP_AS_YN        := P_AS_YN;
    LP_SCM_SITE_ID  := P_SCM_SITE_ID;
    LP_PROJECT_CODE := P_PROJECT_CODE;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    -----------------------------------------------------------------------
    -- GTT 초기화 (세션 재사용 시 이전 데이터 제거)
    -----------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_GGET_T_SSP_SYNC;
    DELETE FROM SCM_MGR.GT_GGET_T_BNP;
    DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_ORI;
    DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_A;
    DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_B;
    DELETE FROM SCM_MGR.GT_GGET_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GT_GGET_SELECT_MEASURE;
    DELETE FROM SCM_MGR.GT_GGET_VMI_DIO;
    DELETE FROM SCM_MGR.GT_GGET_SITE_ITEM_ALL;
    DELETE FROM SCM_MGR.GT_GGET_SITE_ITEM;
    DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_DATA;
    DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_DST;
    DELETE FROM SCM_MGR.GT_GGET_SALES_PRICE;
    DELETE FROM SCM_MGR.GT_GGET_EDI_SENDER;
    DELETE FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP;
    DELETE FROM SCM_MGR.GT_GGET_EDI_END_CUST;
    DELETE FROM SCM_MGR.GT_GGET_RPA_END_CUST;
    DELETE FROM SCM_MGR.GT_GGET_MKT_FCST_RESULT;
    DELETE FROM SCM_MGR.GT_GGET_MF;
    DELETE FROM SCM_MGR.GT_GGET_CAL_MONTH_END;
    DELETE FROM SCM_MGR.GT_GGET_CAL_WEEK_END;
    DELETE FROM SCM_MGR.GT_GGET_SHIPMENT_PLAN;
    DELETE FROM SCM_MGR.GT_GGET_INTRANSIT_DATA;
    DELETE FROM SCM_MGR.GT_GGET_VMI_INV;
    DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT;

    -----------------------------------------------------------------------
    -- 권한그룹 LOOKUP 관리 [20200311 KHSONG C20200103-000586]
    -----------------------------------------------------------------------
    DECLARE
        V_ADMIN_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(1),0) INTO V_ADMIN_CNT
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
          AND  VALID_YN    = 'Y'
          AND  SEGMENT2   IN ('ALL','DMF0003')
          AND  SEGMENT1    = P_USER_GROUP;
        IF V_ADMIN_CNT > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
    END;

    -----------------------------------------------------------------------
    -- 조회 만료 기준 계산 (from + 40주)
    -- SM임시작업 20240621 화면 장애 오류로 인하여 임시조치
    -----------------------------------------------------------------------
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD') + 40*7, 'YYYYMMDD');

    -----------------------------------------------------------------------
    -- 버킷 컬럼 목록 동적 생성 (일별 D_, 주별 W_, 월별 M_)
    -- CURSOR FAST_FORWARD → FOR LOOP
    -----------------------------------------------------------------------
    FOR R IN (
        SELECT 'D_' || A.BASIS_YYYYMMDD || ' AS D_' || A.BASIS_YYYYMMDD     AS COLUMN_NAME
             , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD AS PV_NAME
             , A.BASIS_YYYYMMDD || '_31'                                    AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
             , '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
             , A.BASIS_START_DATE || '_21'
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM || ' AS M_' || A.BASIS_YYYYMM
             , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM
             , MIN(A.BASIS_START_DATE) || '_01'
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        GROUP BY A.BASIS_YYYYMM
        ORDER BY 3 -- SORT_ORDER_NO -- 컴파일 오류로 번호로 변경
    )
    LOOP
        IF V_PV_COL_LIST IS NULL OR V_PV_COL_LIST = '' THEN
            V_PV_COL_LIST := R.COLUMN_NAME;
            V_PV_LIST     := R.PV_NAME;
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || R.COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || R.PV_NAME;
        END IF;
    END LOOP;

    -----------------------------------------------------------------------
    -- 사용자 컬럼 초기화 처리
    -----------------------------------------------------------------------
    V_COLUMN_NAME  := '';
    V_COLUMN       := '';
    V_GROUPBY      := '';
    V_USER_COL_CNT := 0;
    V_USER_MEA_CNT := 0;

    -- 사용자 컬럼 존재 여부 확인
    SELECT COUNT(1) INTO V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
      AND  U.SHEET_NAME                    = VA_SHEET_NAME
      AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
      AND  U.USER_ID                       = P_CREATED_BY;

    IF V_USER_COL_CNT = 0 THEN
        -- 사용자 컬럼이 없으면 기본값으로 복사
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'C'
             , C.COLUMN_NAME, C.SORT_ORDER_NO, '', ''
             , P_CREATED_BY, SYSDATE
             , P_CREATED_BY, SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
          AND  C.SHEET_NAME   = VA_SHEET_NAME
          AND  C.DEFAULT_FLAG = 'Y'
          AND  C.VALID_YN     = 'Y';

          COMMIT WORK;
    END IF;

    -- 사용자 메저 존재 여부 확인
    SELECT COUNT(1) INTO V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
      AND  U.SHEET_NAME                    = VA_SHEET_NAME
      AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
      AND  U.USER_ID                       = P_CREATED_BY;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'M'
             , C.COLUMN_NAME, C.SORT_ORDER_NO, '', ''
             , P_CREATED_BY, SYSDATE
             , P_CREATED_BY, SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
          AND  C.SHEET_NAME   = VA_SHEET_NAME
          AND  C.DEFAULT_FLAG = 'Y'
          AND  C.VALID_YN     = 'Y';

          COMMIT WORK;
    END IF;

    -----------------------------------------------------------------------
    -- 컬럼/정렬 문자열 동적 조립
    -- CURSOR FAST_FORWARD c_title → FOR LOOP
    -----------------------------------------------------------------------
    FOR R IN (
        SELECT U.COLUMN_NAME
             , U.SORT_ORDER_NO
        FROM  ( SELECT U.COLUMN_NAME
                     , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                            WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                            ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
                FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                     , SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  U.PROGRAM_ID  = C.PROGRAM_ID
                  AND  U.SHEET_NAME  = C.SHEET_NAME
                  AND  U.COLUMN_NAME = C.COLUMN_NAME
                  AND  U.PROGRAM_ID  = VA_PROGRAM_ID
                  AND  U.SHEET_NAME  = VA_SHEET_NAME
                  AND  U.USER_ID     = P_CREATED_BY
                  AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                UNION ALL
                -- 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID 추가
                SELECT C.COLUMN_NAME
                     , CASE WHEN C.COLUMN_NAME = 'GROUP_ID'
                            THEN TO_CHAR(NVL(U.SORT_ORDER_NO,85) - 0.5)
                            ELSE TO_CHAR(C.SORT_ORDER_NO) END AS SORT_ORDER_NO
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                LEFT   OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
                  ON   U.PROGRAM_ID  = C.PROGRAM_ID
                 AND   U.SHEET_NAME  = C.SHEET_NAME
                 AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                 AND   U.COLUMN_NAME IN ('ITEM_ID')
                 AND   U.USER_ID     = P_CREATED_BY
                WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
                  AND  C.SHEET_NAME   = VA_SHEET_NAME
                  AND  ( C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' '  OR C.DEFAULT_FLAG = '' )
                  AND  C.VALID_YN     = 'Y' ) U
        ORDER BY TO_NUMBER(U.SORT_ORDER_NO)
    )
    LOOP
        IF V_COLUMN IS NULL OR V_COLUMN = '' THEN
            V_COLUMN  := R.COLUMN_NAME;
            V_GROUPBY := ' GROUP BY ' || R.COLUMN_NAME;
            V_ORDERBY := ' ORDER BY SORT_KEY, '
                      || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
                               THEN R.COLUMN_NAME ELSE '' END;
        ELSE
            V_COLUMN  := V_COLUMN  || ', ' || R.COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', ' || R.COLUMN_NAME;
            V_ORDERBY := V_ORDERBY
                      || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
                               THEN ', ' || R.COLUMN_NAME ELSE '' END;
        END IF;
    END LOOP;

    -- [E20240812-000094] NOTATION 컬럼 추가
    V_COLUMN  := V_COLUMN  || ',NOTATION';
    V_GROUPBY := V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO';
    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');

    -----------------------------------------------------------------------
    -- 사용자 시차(TIMEZONE) 조회
    -----------------------------------------------------------------------
    BEGIN
        SELECT U.TMZ_CD INTO V_USER_TIME_ZONE
        FROM   SCM_MGR.SCM_ADM_USER_M U
        WHERE  U.USER_ID = P_CREATED_BY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_USER_TIME_ZONE := '';
    END;

    -----------------------------------------------------------------------
    -- 계획/실적 기준 날짜 계산
    -----------------------------------------------------------------------
    -- @v_from_yyyymmdd : (User 시차 고려) 당주 월요일
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD) INTO V_FROM_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
             , ( SELECT DISTINCT ISO_YYYYWW
                 FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                 WHERE  BASIS_YYYYMMDD =
                        TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE),'YYYYMMDD')
               ) T
        WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := TO_CHAR(SYSDATE,'YYYYMMDD');
    END;

    -- From 실적 : From 조회 구간 월요일
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_FROM_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_RESULT := '';
    END;

    -- To 실적 : To 조회 구간 월요일 전까지
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_TO_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT := '';
    END;

    IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
        -- 실적 보여줌
        V_TO_YYYYMMDD := P_TO_YYYYMMDD;
        V_TO_RESULT   := V_FROM_YYYYMMDD;  -- To 실적 : 당주 월요일 전까지
    ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := P_TO_YYYYMMDD;
        V_FROM_RESULT := '19000101';
        V_TO_RESULT   := '19000101';
    ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
        -- 실적만 보여줌
        V_FROM_YYYYMMDD := '19000101';
        V_TO_YYYYMMDD   := '19000101';
        V_FROM_RESULT   := P_FROM_YYYYMMDD;
        V_TO_RESULT     := P_TO_YYYYMMDD;
    ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
        V_FROM_RESULT := P_FROM_YYYYMMDD;
        V_TO_RESULT   := P_TO_YYYYMMDD;
    END IF;

    -----------------------------------------------------------------------
    -- [E20260211-001189] 조회 SALES SITE 중 AS용 데이터가 있으면 AS_YN = 'Y'로 처리
    -- TABLE()은 컬렉션 변수만 허용 → 먼저 변수에 COLLECT 후 참조
    -----------------------------------------------------------------------
    DECLARE
        V_AS_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT CAST(
                   COLLECT(DISTINCT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)))
               AS SCM_MGR.T_STR_TAB)
        INTO   T_SCM_SITE_IDS
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;

        SELECT COUNT(DISTINCT A.COLUMN_VALUE) INTO V_AS_CNT
        FROM   TABLE(T_SCM_SITE_IDS) A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.COLUMN_VALUE = B.SEGMENT1
         AND   B.LOOKUP_TYPE  = 'AS_SITE_PLANT';

        IF V_AS_CNT > 0 THEN
            LP_AS_YN := 'Y';
        END IF;
    END;
    -- [E20260211-001189] END

    -----------------------------------------------------------------------
    -- [C20200804-000123] SSP 동기화 / BNP 데이터 수집
    -----------------------------------------------------------------------
    -- Division 40: DM_PLN_MKT_FCST 기반 PIVOT → GT_GGET_T_SSP_SYNC
    IF P_DIVISION_ID = '40' THEN
        INSERT INTO SCM_MGR.GT_GGET_T_SSP_SYNC
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
            || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
            || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
            || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
            || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
            || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
            || '^' || NVL(A31,'') AS ATTR1
        FROM (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
                 , YYYYMMDD || '/'
                   || CASE
                          WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                           AND A.QTY >
                               CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                                    THEN TO_NUMBER(ATTRIBUTE3) ELSE 0 END
                             + CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE2,'0'),'^[0-9.]+$')
                                    THEN TO_NUMBER(ATTRIBUTE2) ELSE 0 END
                          THEN 'P'
                          ELSE 'A'
                      END AS SYNC_YN
                 , 'A' || TO_CHAR(
                       ROW_NUMBER() OVER (
                           PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                        DOM_EXP, A.FCST_TYPE, INCOTERMS
                           ORDER BY YYYYMMDD
                       )) AS ROW_NUM
            FROM   SCM_MGR.DM_PLN_MKT_FCST A
            -- [E20260211-001189] #T_WS_FCST JOIN 주석처리된 원본 그대로 반영
            WHERE  A.DIVISION_ID = P_DIVISION_ID
              AND  A.MEASURE     = 'MKT_FCST'
              AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
              AND  ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL OR NVL(A.ATTRIBUTE4,'') <> '' OR NVL(A.ATTRIBUTE5,'') <> '')  -- [C20210225-000385]
              AND  A.QTY <> 0
              AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
                          ELSE A.SCM_SITE_ID END
                     IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
              AND  ( LP_PROJECT_CODE IS NULL
                     OR CASE WHEN LP_PROJECT_CODE = '' THEN LP_PROJECT_CODE
                          ELSE A.PROJECT_CODE END
                     IN (SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL) )
              AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID
                          ELSE A.PLANT_SITE_ID END
                     IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
        ) A
        PIVOT (
            MAX(SYNC_YN) FOR ROW_NUM IN (
                'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                'A31' A31
            )
        );

    -- Division 82: DM_PLN_PR_DETAIL 기반 PIVOT → GT_GGET_T_BNP [PJ20209642R]
    ELSIF P_DIVISION_ID = '82' THEN
        INSERT INTO SCM_MGR.GT_GGET_T_BNP
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
            || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
            || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
            || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
            || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
            || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
            || '^' || NVL(A31,'') AS ATTR1
        FROM (
            SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                            DOM_EXP, FCST_TYPE, INCOTERMS
                 , YYYYMMDD || '/A' AS SYNC_YN
                 , 'A' || TO_CHAR(
                       ROW_NUMBER() OVER (
                           PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                        DOM_EXP, FCST_TYPE, INCOTERMS
                           ORDER BY YYYYMMDD
                       )) AS ROW_NUM
            FROM   SCM_MGR.DM_PLN_PR_DETAIL A
            WHERE  A.DIVISION_ID = P_DIVISION_ID
              AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        ) A
        PIVOT (
            MAX(SYNC_YN) FOR ROW_NUM IN (
                'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                'A31' A31
            )
        );
    END IF;
    -- [C20200804-000123] 끝

    -----------------------------------------------------------------------
    -- [E20240920-000300] ITEM_SINGLE_V 속도 개선 - 3단계로 나눠서 INSERT
    -----------------------------------------------------------------------
    -- Step 1: SCM_MST_ITEM_SN 전체를 GT_GGET_ITEM_SINGLE_ORI에 적재
    INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_ORI
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
    , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
         , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
         , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    FROM   SCM_MGR.SCM_MST_ITEM_SN
    WHERE  DIVISION_ID = P_DIVISION_ID
      AND  ACTIVE_FLAG = 'Y';

    -- Step 2A: 기본 컬럼 GROUP BY → GT_GGET_ITEM_SINGLE_A
    INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_A
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
    , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)
         , MAX(T1.ITEM_CLASS)
         , MAX(T1.ITEM_CLASS_NAME)
         , MAX(T1.NICK_NAME)
         , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                         WHEN T1.ITEM_TYPE = 'H' THEN 2
                         WHEN T1.ITEM_TYPE = 'Q' THEN 3
                         ELSE 4 END)
               WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END
         , MAX(T1.MATERIAL_CLASS_NAME)
         , MAX(T1.ITEM_UOM)
         , MAX(T1.SPEC)
         , MAX(T1.MDM_PROJECT_NAME)
         , MAX(T1.MIN_CAPACITY)
         , MAX(T1.ACTIVE_FLAG)
         , MAX(T1.ENERGE)
         , MAX(T1.CELL_QUANTITY)
         , MAX(T1.SCP_EXTRA_SPEC)
    FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_ORI T1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

    -- Step 2B: FORECAST_INFO 계열 LEFT(12) 기준 집계 → GT_GGET_ITEM_SINGLE_B
    INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_B
    ( DIVISION_ID, ITEM_ID
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)
         , MAX(FORECAST_INFO_PRODUCT_GROUP)
         , MAX(FORECAST_INFO_CELL_MODEL)
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(FORECAST_INFO_SPEC)
         , MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_TYPE)
    FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_ORI
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

    -- Step 3: A+B JOIN 후 ITEM_ID/NICK_NAME LIKE 필터 적용 → GT_GGET_ITEM_SINGLE_V
    INSERT INTO SCM_MGR.GT_GGET_ITEM_SINGLE_V
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
    , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID, T1.ITEM_ID
         , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
         , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
         , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
         , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
         , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
    FROM   SCM_MGR.GT_GGET_ITEM_SINGLE_A T1
    JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_B T2
      ON   T1.DIVISION_ID          = T2.DIVISION_ID
     AND   SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
    WHERE  T1.DIVISION_ID = P_DIVISION_ID
      AND  EXISTS (
               SELECT 1
               FROM (
                   SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' AS TST
                   FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
               ) B
               WHERE T1.ITEM_ID   LIKE B.TST
                  OR T1.NICK_NAME LIKE B.TST
           )
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID
           , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
           , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
           , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
           , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
           , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC;

    -- [E20240731-000856] Wh → KWh 환산
    UPDATE SCM_MGR.GT_GGET_ITEM_SINGLE_V
    SET    ENERGE = CASE WHEN REGEXP_LIKE(NVL(ENERGE,'X'),'^[0-9.]+$')
                         THEN TO_CHAR(ROUND(TO_NUMBER(ENERGE)/1000, 4))
                         ELSE NULL END;

    -----------------------------------------------------------------------
    -- GT_GGET_SELECT_MEASURE 수집
    -- [C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터 제공
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_SELECT_MEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
    SELECT DISTINCT U.PROGRAM_ID
                  , U.SHEET_NAME
                  , U.USER_ID
                  , CASE WHEN U.COLUMN_NAME IN ('CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO')
                         THEN 'CUST. PSI'
                         WHEN U.COLUMN_NAME IN ('MKT_INV_I','MKT_PRODUCT_S','MKT_WHIN_P','MKT_DIO')
                         THEN 'MKT PSI'
                         ELSE U.COLUMN_NAME END AS MEASURE_GROUP
                  , U.COLUMN_NAME AS MEASURE
                  , CASE WHEN U.COLUMN_NAME IN ('CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG')
                         THEN SMSM.SORT_ORDER_NO   -- 20231212 kcw3408 4_고객수요 Measure 통합
                         ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
      ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID
     AND   U.SHEET_NAME  = SMSM.SHEET_NAME
     AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
     AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
     AND   SMSM.VALID_YN = 'Y'
    LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
      ON   U.USER_ID    = T.SEGMENT4     -- 20200309 KHSONG TMM MEASURE 권한추가
     AND   P_CREATED_BY = T.SEGMENT4
     AND   T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
     AND   T.VALID_YN    = 'Y'
    WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
      AND  U.PROGRAM_ID = 'DMF0003'
      AND  U.SHEET_NAME = 'Mkt Fcst'
      AND  U.USER_ID    = P_CREATED_BY
      AND  U.USER_ID    = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4
                               ELSE P_CREATED_BY END
    -----------------------------------------------------------------------
    -- [20191118 KHSONG CSR ID:C20191031-000137] CUST_FCST_EDI 계열 sub-measure 추가
    -----------------------------------------------------------------------
    UNION ALL
    SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
         , A.SORT_ORDER_NO + B.SORT_ORDER_NO
    FROM (
        SELECT U.PROGRAM_ID, U.SHEET_NAME, U.USER_ID
             -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
             , 'CUST_FCST' AS MEASURE_GROUP
             , SMSM.SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
          ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
         AND   SMSM.VALID_YN = 'Y'
        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
          AND  U.PROGRAM_ID  = 'DMF0003'
          AND  U.SHEET_NAME  = 'Mkt Fcst'
          AND  U.USER_ID     = P_CREATED_BY
          -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
          AND  U.COLUMN_NAME = 'CUST_FCST'
    ) A,
    (
        -- [E20241126-000426] CUST_FCST_EDI 추가 및 순서 변경
        SELECT 'Immidiate'                   AS MEASURE, 0.15 AS SORT_ORDER_NO FROM DUAL UNION ALL
        SELECT 'Planning_Forecast'                      , 0.18 FROM DUAL UNION ALL
        SELECT 'Commercial_Agreement'                   , 0.13 FROM DUAL UNION ALL
        SELECT 'Firm_Temp'                              , 0.14 FROM DUAL UNION ALL
        SELECT 'Manumacturing_Material_Temp'            , 0.16 FROM DUAL UNION ALL
        SELECT 'Material_Temp'                          , 0.17 FROM DUAL UNION ALL
        SELECT 'Backorder'                              , 0.12 FROM DUAL UNION ALL
        SELECT 'CUST_FCST_EDI'                          , 0.11 FROM DUAL
    ) B
    GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
           , A.SORT_ORDER_NO + B.SORT_ORDER_NO
    -----------------------------------------------------------------------
    -- CUST_FCST_2 : DM_MST_CUSTOMER_FCST 기반 동적 Measure
    -----------------------------------------------------------------------
    UNION ALL
    SELECT DISTINCT 'DMF0003'   AS PROGRAM_ID
                  , 'Mkt Fcst'  AS SHEET_NAME
                  , P_CREATED_BY AS USER_ID
                  , 'CUST_FCST_2' AS MEASURE_GROUP
                  , C.MEASURE
                  ,
                      ( SELECT SMSM.SORT_ORDER_NO
                        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
                          ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
                         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
                         AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
                        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                          AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'Mkt Fcst'
                          AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST' )
                      + 0.1
                     AS SORT_ORDER_NO
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
    WHERE  C.MEASURE_GROUP = 'CUST_FCST'
      AND  NVL(C.MEASURE,'-') <> '-'
      AND  C.VALID_YN = 'Y'
      AND  EXISTS (
               SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
               WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'Mkt Fcst'
                 AND  X.USER_ID    = P_CREATED_BY
                 AND  X.COLUMN_NAME = 'CUST_FCST' AND X.COLUMN_NAME = C.MEASURE_GROUP
           )
    -----------------------------------------------------------------------
    -- CUST_FCST_3 : Customer Fcst[Org.] 고정 Measure
    -----------------------------------------------------------------------
    UNION ALL
    SELECT DISTINCT 'DMF0003', 'Mkt Fcst', P_CREATED_BY
                  , 'CUST_FCST_3', 'Customer Fcst[Org.]'
                  ,
                      ( SELECT SMSM.SORT_ORDER_NO
                        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
                          ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
                         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
                         AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
                        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                          AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'Mkt Fcst'
                          AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST_ORG' )
                      + 0.1
                     AS SORT_ORDER_NO
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
    WHERE  C.MEASURE_GROUP = 'CUST_FCST'
      AND  NVL(C.MEASURE,'-') <> '-'
      AND  C.VALID_YN = 'Y'
      AND  EXISTS (
               SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
               WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'Mkt Fcst'
                 AND  X.USER_ID    = P_CREATED_BY AND X.COLUMN_NAME = 'CUST_FCST_ORG'
           );

    -----------------------------------------------------------------------
    -- [C20201103-000114] Division 82: MKT_FCST_RP 선택 시 VMI 관련 메저 강제 추가
    -----------------------------------------------------------------------
    DECLARE
        V_MKT_RP_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_MKT_RP_CNT
        FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
        WHERE  MEASURE = 'MKT_FCST_RP';

        IF V_MKT_RP_CNT > 0 AND P_DIVISION_ID = '82' THEN
            -- 순서 조정을 위해 기존 항목 제거 후 재삽입
            DELETE FROM SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_SYS_RP','VMI_IN_PLAN','VMI_IN_REQ','VMI_INV');

            INSERT INTO SCM_MGR.GT_GGET_SELECT_MEASURE
            ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
            SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID
                 , B.MEASURE_GROUP, B.MEASURE
                 , REPLACE(A.SORT_ORDER_NO, '.0', B.SORTKEY)
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE A
            JOIN   (
                       SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' AS SORTKEY FROM DUAL UNION ALL
                       SELECT 'VMI_In_Plan'               , 'VMI_In_Plan'               , '.2' FROM DUAL UNION ALL
                       SELECT 'VMI_In_Req'                , 'VMI_In_Req'                , '.3' FROM DUAL UNION ALL
                       SELECT 'VMI_Inv'                   , 'VMI_Inv'                   , '.4' FROM DUAL
                   ) B ON 1=1
            WHERE  A.MEASURE = 'MKT_FCST_RP';
        END IF;
    END;

    -- MKT FCST 메저 순서 변경
    UPDATE SCM_MGR.GT_GGET_SELECT_MEASURE
    SET    SORT_ORDER_NO = REPLACE(SORT_ORDER_NO, '.0', '.9')
    WHERE  MEASURE = 'MKT_FCST_RP';

    -----------------------------------------------------------------------
    -- GT_GGET_VMI_DIO 수집
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '40' THEN
        INSERT INTO SCM_MGR.GT_GGET_VMI_DIO ( KEY_JOIN, VMI_STD_DIO )
        SELECT A.ITEM_ID, A.VMI_STD_DIO
        FROM   SCM_MGR.SCP_MST_DIO A
        JOIN (
            SELECT DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN, MAX(YYYYMM) AS YYYYMM
            FROM   SCM_MGR.SCP_MST_DIO
            WHERE  DIVISION_ID = '40' AND TOTAL_YN = 'Y' AND PLANT_ID = '*'
            GROUP  BY DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
        ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
           AND A.ITEM_ID     = B.ITEM_ID     AND A.TOTAL_YN = B.TOTAL_YN
           AND A.YYYYMM      = B.YYYYMM
        WHERE  A.DIVISION_ID = '40' AND A.TOTAL_YN = 'Y' AND A.PLANT_ID = '*';

    ELSIF P_DIVISION_ID = '82' THEN   -- [C20201103-000114]
        INSERT INTO SCM_MGR.GT_GGET_VMI_DIO ( KEY_JOIN, VMI_VAL )
        SELECT A.SCM_SITE_ID
             , A.VMI_YN || '^' || NVL(TO_CHAR(A.ATTRIBUTE5),'')
        FROM   SCM_MGR.SCM_MST_SITE A
        WHERE  DIVISION_ID = P_DIVISION_ID;
    END IF;

    -----------------------------------------------------------------------
    -- GT_GGET_SITE_ITEM_ALL 수집 (81/82 vs 40 분기)
    -----------------------------------------------------------------------
    IF P_DIVISION_ID LIKE '81%' OR P_DIVISION_ID = '82' THEN
        INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, T3.PROJECT_NAME
             , ''   AS CELL_MODEL      -- 20180809 ytchoi modify
             , T3.BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             , ( SELECT DISTINCT
                     LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
                 FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
                 WHERE  ZA.USER_ID IN (
                     SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL
                 )
               ) AS OWNER
             , CASE WHEN F.DIVISION_ID NOT IN ('40') THEN T3.PROJECT_OWNER
                    ELSE J.USER_NAME_EN END AS PROJECT_OWNER   -- 20180705
             , J.USER_ID
             , T2.ITEM_NAME, T2.ITEM_TYPE
             , T3.PROJECT_STATUS
             , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
             , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
             , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
             , LOOK.NAME  AS CELL_TYPE   -- 20180911 LookUp TABLE JOIN
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME  -- 20190419 KHSONG
             , S.VMI_YN
             , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES    -- 20190213 KHSONG
             , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER -- 20190213 KHSONG
             -- [PJ2024-50461] Team Mapping
             , TEAM.DEPT_ID
             , TEAM_DEPT.DEPT_NAME_KO
             , F.CELL_PER_CAR
             , F.CELL_PER_MODULE  -- [E20260123-001715] 원소스 복원
             , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
                                      ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
             , T2.ITEM_CLASS_NAME
             , T2.ENERGE
             , TO_CHAR(T2.CELL_QUANTITY)
             , F.VALID_YN  AS ITEM_VALID_YN
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
          ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
        JOIN   SCM_MGR.SCM_MST_PROJECT T3
          ON   F.DIVISION_ID = T3.DIVISION_ID AND F.PROJECT_CODE = T3.PROJECT_CODE
        JOIN (
             SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' TST
             FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
        ) B ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)   -- 20190118 DISTINCT 추가
        JOIN (
             SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) || '%' TST
             FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL
        ) C ON (F.PROJECT_CODE LIKE C.TST OR T3.PROJECT_NAME LIKE C.TST)
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES' AND S.VALID_YN = 'Y'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        -- [PJ2024-50461] Team Mapping
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO TEAM
          ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM_DEPT
          ON   TEAM.DEPT_ID = TEAM_DEPT.DEPT_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
          ON   SUBSTR(F.OWNER, 1,
                      CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
                           ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K ON J.DEPT_ID = K.DEPT_ID
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   NVL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID  -- 20190419 KHSONG
        WHERE  F.DIVISION_ID <> '40'   -- hard coding (20190123 KHSONG)
          AND  F.DIVISION_ID = P_DIVISION_ID
          -- [E20260211-001189] SCM_SITE_ID 조건 주석처리
          AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
                      ELSE S.END_CUSTOMER END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
                      ELSE T2.ITEM_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
                      ELSE T3.BIZ_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( ( P_OWNER IS NULL OR P_OWNER = '' )
                   OR F.OWNER IN (SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
                                  FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL) );

    ELSE
        -- Division 40 (소형) 케이스
        INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, F.PROJECT_CODE  AS PROJECT_NAME
             , F.ATTRIBUTE5  AS CELL_MODEL   -- 20180810 ytchoi 조회속도개선
             , ''  AS BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             , ( SELECT DISTINCT
                     LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
                 FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
                 WHERE  ZA.USER_ID IN (
                     SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL
                 )
               ) AS OWNER
             , J.USER_NAME_EN  AS PROJECT_OWNER   -- 20180705
             , J.USER_ID
             , T2.ITEM_NAME, T2.ITEM_TYPE
             , ''  AS PROJECT_STATUS
             , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
             , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
             -- [E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                    ELSE T2.FORECAST_INFO_BIZ_TYPE END  AS FORECAST_INFO_BIZ_TYPE
             , T2.FORECAST_INFO_PRODUCT_GROUP
             , LOOK.NAME  AS CELL_TYPE
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT)
                    ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END  AS FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME
             , S.VMI_YN
             , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES
             , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER
             -- [PJ2024-50461] Team Mapping
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO
             , F.CELL_PER_CAR
             , F.CELL_PER_MODULE
             , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
                                      ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
             , T2.ITEM_CLASS_NAME
             , T2.ENERGE
             , TO_CHAR(T2.CELL_QUANTITY)
             , F.VALID_YN  AS ITEM_VALID_YN
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
          ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
        JOIN (
             SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' TST
             FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
        ) B ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
        JOIN (
             SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) || '%' TST
             FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL
        ) C ON F.PROJECT_CODE LIKE C.TST
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        LEFT   JOIN (
                        SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                        FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B
                        JOIN   SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
                    ) TEAM
          ON   TEAM.USER_ID IN (
                   SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1)) FROM DUAL
               )
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
          ON   SUBSTR(F.OWNER, 1,
                      CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
                           ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
          ON   CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
                    ELSE F.DEPT_ID END = K.DEPT_ID   -- 20190123 KHSONG
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   NVL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID
        -- [E20230720-001573] 40번사업부 AMDMO0001A모델 BIZ_TYPE/CELL_PACK_COUNT LOOKUP 적용
        LEFT   JOIN (
                        SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT
                        FROM (
                            SELECT SEGMENT2 AS MODEL
                                 , SEGMENT3 AS BIZ_TYPE
                                 , SEGMENT4 AS CELL_PACK_COUNT
                                 , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40'
                        ) A WHERE MODEL_RANK = 1
                    ) LOOKA ON LOOKA.MODEL = F.ITEM_ID
        WHERE  F.DIVISION_ID = '40'
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
                      ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
                      ELSE F.PROJECT_CODE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
                      ELSE T2.ITEM_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- [E20230720-001573] BIZ_TYPE LOOKUP 우선 적용
          AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
                      WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                      ELSE T2.FORECAST_INFO_BIZ_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( ( P_OWNER IS NULL OR P_OWNER = '' )
                   OR F.OWNER IN (SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
                                  FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL) );

    END IF;

    -----------------------------------------------------------------------
    -- [20190704 KHSONG] ITEM_ID 중복 현상 방지를 위해 재 GROUP
    -- GT_GGET_SITE_ITEM_ALL → GT_GGET_SITE_ITEM
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)
         , MAX(BIZ_TYPE)
         , MAX(END_CUSTOMER)
         , MAX(SOLDTO_CUSTOMER)
         , MAX(COUNTRY)
         , MAX(COUNTRY_NAME)
         , MAX(CITY)
         , MAX(CITY_NAME)
         , MAX(OWNER)
         , MAX(PROJECT_OWNER)
         , MAX(USER_ID)
         , MAX(ITEM_NAME)
         , MAX(ITEM_TYPE)
         , MAX(PROJECT_STATUS)
         , MAX(CUST_GROUP)
         , MAX(CUST_GROUP_DTL)
         , MAX(APPLICATION)
         , MAX(ROUTE)
         , MAX(MDM_PROJECT_NAME)
         , MAX(MIN_CAPACITY)
         , MAX(FORECAST_INFO_BIZ_TYPE)
         , MAX(FORECAST_INFO_PRODUCT_GROUP)
         , MAX(CELL_TYPE)
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(FORECAST_INFO_ALL)
         , MAX(FORECAST_INFO_SPEC)
         , MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_MODEL_NICK_NAME)
         , MAX(VMI_YN)
         , MAX(DMS_SALES)
         , MAX(DMS_CUSTOMER)
         , MAX(DEPT_ID)
         , MAX(DEPT_NAME_KO)
         , MAX(CELL_PER_CAR)
         , MAX(CELL_PER_MODULE)
         , MAX(MODULE_PER_CAR)
         , MAX(ITEM_CLASS_NAME)
         , MAX(ENERGE)
         , MAX(CELL_QUANTITY)
         , MAX(ITEM_VALID_YN)
    FROM   SCM_MGR.GT_GGET_SITE_ITEM_ALL
    GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;

    -----------------------------------------------------------------------
    -- GT_GGET_EDI_SENDER 수집
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_EDI_SENDER ( SCM_SITE_ID, SENDER_CODE, SENDER_NAME )
    SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
    FROM   SCM_MGR.SCM_MST_SITE A
    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   A.END_CUSTOMER = B.SEGMENT2
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
    GROUP  BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6;

    -----------------------------------------------------------------------
    -- GT_GGET_LAST_DATA_SETUP 수집 (최종 입력일시 및 입력자)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_LAST_DATA_SETUP
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    , CREATE_DATE, LAST_UPDATED_BY )
    SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
         , X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
         , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
    FROM (
        -- DM_PLN_MKT_FCST (계획 테이블)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , CASE WHEN A.MEASURE IN (
                        'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
                        'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
                        'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
                        'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
                        'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
                        'Material_Temp[Org.]','Backorder[Org.]')
                    THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
                                THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
                                ELSE MAX(A.ATTRIBUTE9) END )
                    ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
               END AS LAST_UPDATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE B
          ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
                                WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
                                WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
                                WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
                                                   'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                                               THEN 'RTF'
                                ELSE B.MEASURE END
        WHERE  A.DIVISION_ID = P_DIVISION_ID
          AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
          AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
        GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        UNION ALL
        -- DM_PLN_MKT_FCST_RESULT (실적 테이블)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , CASE WHEN A.MEASURE IN (
                        'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
                        'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
                        'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
                        'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
                        'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
                        'Material_Temp[Org.]','Backorder[Org.]')
                    THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
                                THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
                                ELSE MAX(A.ATTRIBUTE9) END )
                    ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
               END AS LAST_UPDATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE B
          ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
                                WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
                                WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
                                WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
                                                   'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                                               THEN 'RTF'
                                ELSE B.MEASURE END
        WHERE  A.DIVISION_ID = P_DIVISION_ID
          AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
          AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
        GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
    ) X
    WHERE  ( X.PROJECT_CODE IS NOT NULL OR NVL(X.PROJECT_CODE,'') <> '' )
      AND  ( X.SCM_SITE_ID IS NOT NULL OR NVL(X.SCM_SITE_ID,'')  <> '' )
      AND  ( X.ITEM_ID IS NOT NULL OR NVL(X.ITEM_ID,'')      <> '' )
    GROUP  BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
           ,  X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;

    -----------------------------------------------------------------------
    -- GT_GGET_EDI_END_CUST 수집 (EDI END_CUSTOMER별 기간 설정)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_EDI_END_CUST
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , NVL(B.SEGMENT4, '-')
         , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
                ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
         , NVL(B.ATTRIBUTE2, 'TUE')
         , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
         , NVL(B.ATTRIBUTE4, 'MON')
         , NVL(B.SEGMENT5, 'Off')
    FROM   SCM_MGR.SCM_MST_SITE A
    LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   A.END_CUSTOMER = B.SEGMENT2
     AND   B.VALID_YN     = 'Y'
    WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
    GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
           ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

    -----------------------------------------------------------------------
    -- GT_GGET_RPA_END_CUST 수집 (RPA END_CUSTOMER별 기간 설정)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_RPA_END_CUST
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , NVL(B.SEGMENT4, '-')
         , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
                ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
         , NVL(B.ATTRIBUTE2, 'TUE')
         , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
         , NVL(B.ATTRIBUTE4, 'MON')
         , NVL(B.SEGMENT5, 'Off')
    FROM   SCM_MGR.SCM_MST_SITE A
    LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   B.LOOKUP_TYPE  = 'RPA_END_CUSTOMER'
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   A.END_CUSTOMER = B.SEGMENT2
     AND   B.VALID_YN     = 'Y'
    WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
    GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
           ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

    -----------------------------------------------------------------------
    -- CAL_MONTH_END / CAL_WEEK_END 수집 (월말일 / 주말일 목록)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_CAL_MONTH_END ( MONTH_END_DATE )
    SELECT TO_CHAR(LAST_DAY(TO_DATE(BASIS_YYYYMM,'YYYYMM')),'YYYYMMDD') AS MONTH_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    GROUP  BY BASIS_YYYYMM;

    INSERT INTO SCM_MGR.GT_GGET_CAL_WEEK_END ( WEEK_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    GROUP  BY BASIS_YYYYMM, ISO_WEEK;


    -----------------------------------------------------------------------
    -- 계획 구간 INSERT 조건:
    --   V_TO_YYYYMMDD >= 당주 월요일  →  계획구간 데이터 존재
    -- CONVERT(CHAR(8), (FN_NEXT_DAY(GETDATE(),'MON') + (-7)),112)
    --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
    -----------------------------------------------------------------------
    IF V_TO_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN

        -----------------------------------------------------------------------
        -- Block 1-A : MKT_FCST 계열 (CUST_FCST_EDI/Immidiate 등 제외)
        --             AS콤보박스 제거로 T4(AS_SITE_PLANT) LEFT JOIN 추가 [E20260211-001189]
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
        , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
        , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
        , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
        , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE
                   AND  QTY         <> 0 )
             , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE )
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        -- [E20260211-001189] AS콤보박스 제거 → AS_SITE_PLANT LEFT JOIN으로 AS데이터 포함
        LEFT   OUTER JOIN (
                               SELECT SEGMENT1, SEGMENT2
                               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                                 AND  SEGMENT3    = P_DIVISION_ID
                           ) T4 ON NVL(F.ATTRIBUTE10,'') = T4.SEGMENT2
        WHERE  F.QTY <> 0
          AND  F.MEASURE NOT IN (
                   'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
                   'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
                   'CUST_FCST','Customer FCST' )
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL)
                 OR
                 CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE T4.SEGMENT1 END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- Block 1-B : CUST_FCST_EDI 계열 (EDI/RPA Sender 기반)
        --             YYYYMMDD 범위: v_to_result ~ p_to_yyyymmdd  [고객수요분석시스템 정비]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                    'Commercial_Agreement','Firm_Temp',
                                    'Manumacturing_Material_Temp','Material_Temp','Backorder') )
             , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
                   ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
             , CASE WHEN ( F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' ) THEN
                   ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
             , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                         ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                         ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> -9999999999
          AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                             'Commercial_Agreement','Firm_Temp',
                             'Manumacturing_Material_Temp','Material_Temp','Backorder')
          -- [고객수요분석시스템 정비] EDI데이터 중복건 제거: v_to_result 이후부터만 조회
          AND  F.YYYYMMDD    BETWEEN V_TO_RESULT AND P_TO_YYYYMMDD
          AND  F.DIVISION_ID = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
                      THEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END )
                      ELSE F.ATTRIBUTE4 END
                 IN ( SELECT TRIM(REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
                      FROM DUAL
                      CONNECT BY REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )

        -----------------------------------------------------------------------
        -- Block 1-C : Customer FCST (RPA/EXCEL 경로, Cust.FCST_RPA[P+P] / Cust.FCST_EXCEL[P+P] 으로 표시)
        --             [E20241126-000426] Customer FCST 전용 로직
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , CASE WHEN F.MEASURE = 'Customer FCST' THEN
                        CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                             THEN 'Cust.FCST_RPA[P+P]'
                             ELSE 'Cust.FCST_EXCEL[P+P]' END
                    ELSE F.MEASURE END  AS MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             -- [E20241126-000426] Customer FCST 전용 LAST_DATA_SETUP
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
             , CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                    THEN F.LAST_UPDATED_BY || '_RPA'
                    ELSE F.LAST_UPDATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND   ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                   ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          -- [E20241126-000426] Customer FCST 전용
          AND  F.MEASURE      = 'Customer FCST'
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- Block 1-D : CUST_FCST 전용  [E20241126-000426]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
             , F.LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND  ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                        ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                          ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          AND  F.MEASURE      = 'CUST_FCST'
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );

        -----------------------------------------------------------------------
        -- Block 2 : MKT_FCST_RP / MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
        --           (Cell/Car/Module 환산 포함)
        -----------------------------------------------------------------------
        DECLARE
            V_RP_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RP_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');

            IF V_RP_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                            THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE = 'MKT_FCST_RP' THEN F.QTY
                           WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell') > 0   AND NVL(T2.CELL_PER_CAR,0) > 0
                                        THEN F.QTY / T2.CELL_PER_CAR
                                   -- [C20200212-000304] Module: QTY / MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0
                                        THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack') > 0   THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID LIKE '81%' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   -- [C20200511-000360] Pack → CELL_PER_CAR 곱
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20200114-000201] ESS(82): CELL_QUANTITY 곱
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID = '82' THEN
                               F.QTY * T2.CELL_QUANTITY
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE = 'MKT_FCST'
                 AND   M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                                        THEN 'MKT_FCST' ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 2 END
        END;

        -----------------------------------------------------------------------
        -- Block 3 : RTF_RP_CAR / RTF_SYS_RP_CAR / RTF_RP_CELL / RTF_SYS_RP_CELL / RTF_ENERGY
        --           [CSR ID:4023158] 20190705 KHSONG
        --           [C20211103-000146] 20211119 RTF_ENERGY 추가
        -----------------------------------------------------------------------
        DECLARE
            V_RTF_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RTF_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY');

            IF V_RTF_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     -- Measure명 결정
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
                                    ELSE '' END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
                                    ELSE '' END
                           WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
                       END  AS MEASURE
                     , F.YYYYMMDD
                     -- QTY 환산
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
                                        THEN F.QTY / T2.CELL_PER_CAR
                                   -- [C20200212-000304] Module → MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0
                                    AND NVL(T2.CELL_PER_CAR,0) > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0
                                        THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') AND F.DIVISION_ID LIKE '81%' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20200114-000201] ESS(82) RTF_RP_CELL: CELL_QUANTITY 곱
                           WHEN M.MEASURE = 'RTF_RP_CELL' AND F.DIVISION_ID = '82' THEN
                               F.QTY * T2.CELL_QUANTITY
                           -- [C20211103-000146] RTF_ENERGY: ENERGE * QTY / 1000
                           WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP')
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
                 AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.MEASURE = CASE
                                       WHEN M.MEASURE IN ('RTF_RP_CAR', 'RTF_RP_CELL')                    THEN 'RTF'
                                       WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF_SYS_RP'
                                       ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 3 END
        END;


        -----------------------------------------------------------------------
        -- Block 4 : MKT_FCST_ENERGY  [C20221207-000080] 20221214 rosia27
        --           소스: GT_GGET_MKT_FCST_DATA 에 이미 들어간 MKT_FCST_RP 행에서 파생
        --           (원본: #TempMktFcstData JOIN #TempSiteItem)
        -----------------------------------------------------------------------
        DECLARE
            V_ENERGY_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_ENERGY_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE = 'MKT_FCST_ENERGY';

            IF V_ENERGY_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'MKT_FCST_RP'
                            THEN 'MKT_FCST_ENERGY' END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                            ELSE 0 END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     -- MKT_FCST_ENERGY는 GT_GGET_MKT_FCST_DATA의 MKT_FCST_RP 행에서 파생
                     -- CREATE_DATE / LAST_UPDATED_BY / SENDER_* 는 원본 F 행 값 그대로 사용
                     , F.AS_FROM_SITE
                     , F.CREATE_DATE
                     , F.LAST_UPDATED_BY
                     , F.SENDER_CODE
                     , F.SENDER_NAME
                FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA F   -- 이미 삽입된 MKT_FCST_RP 행을 소스로 사용
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE = 'MKT_FCST_RP'
                 AND   M.MEASURE = 'MKT_FCST_ENERGY'
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 4 END
        END;

    END IF;  -- 계획 구간 조건 END (V_TO_YYYYMMDD >= 당주 월요일)


    -----------------------------------------------------------------------
    -- 실적 구간 INSERT 조건:
    --   V_FROM_YYYYMMDD <= 당주 월요일
    -- CONVERT(CHAR(8), (FN_NEXT_DAY(GETDATE(),'MON') + (-7)),112)
    --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
    -----------------------------------------------------------------------
    IF V_FROM_YYYYMMDD <= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN

        -----------------------------------------------------------------------
        -- [PJ2025-50188] GT_GGET_MKT_FCST_RESULT 생성
        --   DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 컬럼이 추가되어
        --   DUP 방지를 위해 CELL_PROD_SITE_ID 제거 후 GROUP BY로 집계
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, YYYYMMDD
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        , QTY )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, YYYYMMDD
             , MAX(CREATED_BY)        AS CREATED_BY
             , MAX(CREATION_DATE)     AS CREATION_DATE
             , MAX(LAST_UPDATED_BY)   AS LAST_UPDATED_BY
             , MAX(LAST_UPDATE_DATE)  AS LAST_UPDATE_DATE
             , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
             , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
             , SUM(QTY)               AS QTY
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
        WHERE  DIVISION_ID  = P_DIVISION_ID
          AND  YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  YYYYMMDD     < V_TO_RESULT
        GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
               ,  MEASURE, PLANT_SITE_ID, YYYYMMDD
               ,  ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
               ,  ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10;

        -----------------------------------------------------------------------
        -- Block R-1 ~ R-4: 단일 INSERT … UNION ALL
        --   소스: GT_GGET_MKT_FCST_RESULT (= 집계된 실적 테이블)
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
        , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
        , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
        , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
        , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )

        -----------------------------------------------------------------------
        -- R-1: MKT_FCST 계열 (CUST_FCST_EDI 계열 및 CUST_FCST/Customer FCST 제외)
        -----------------------------------------------------------------------
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
             , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
                   AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                        WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                          AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                          AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                          AND  INCOTERMS   = F.INCOTERMS
                                          AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        WHERE  F.QTY <> 0
          AND  F.MEASURE NOT IN (
                   'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
                   'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
                   'CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]',
                   'Commercial_Agreement[Org.]','Firm_Temp[Org.]',
                   'Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]',
                   'CUST_FCST','Customer FCST' )
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- R-2: CUST_FCST_EDI 계열 (EDI Sender 포함)
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE    IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                       'Commercial_Agreement','Firm_Temp',
                                       'Manumacturing_Material_Temp','Material_Temp','Backorder') )
             , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
                   ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
             , CASE WHEN F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' THEN
                   ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
             , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
        FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> -9999999999
          AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                             'Commercial_Agreement','Firm_Temp',
                             'Manumacturing_Material_Temp','Material_Temp','Backorder')
          -- [E20241126-000426] EDI 기간 필터 주석처리(배치에서 정리) → 단순 날짜 범위만 적용
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
                      THEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END )
                      ELSE F.ATTRIBUTE4 END
                 IN ( SELECT TRIM(REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
                      FROM DUAL
                      CONNECT BY REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )

        -----------------------------------------------------------------------
        -- R-3: Customer FCST (RPA/EXCEL → Cust.FCST_RPA/EXCEL[P+P])
        --      [E20241126-000426] Customer FCST 전용; LAST_UPDATED_BY는 CREATED_BY 기반
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , CASE WHEN F.MEASURE = 'Customer FCST' THEN
                        CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                             THEN 'Cust.FCST_RPA[P+P]'
                             ELSE 'Cust.FCST_EXCEL[P+P]' END
                    ELSE F.MEASURE END  AS MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             -- [E20241126-000426] Customer FCST 전용 CREATE_DATE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
             -- [PJ2025-50188] 실적은 CREATED_BY 기반으로 _RPA/_EXCEL 결정
             , CASE WHEN F.CREATED_BY LIKE '%robot'
                    THEN F.CREATED_BY || '_RPA'
                    ELSE F.CREATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          -- [E20241126-000426] Customer FCST 전용
          AND  F.MEASURE      = 'Customer FCST'
          -- [E20241126-000426] 날짜 필터 단순화(배치에서 RPA 기간 정리)
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- R-4: CUST_FCST 전용  [E20241126-000426]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
             , F.LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          AND  F.MEASURE      = 'CUST_FCST'
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );

        -----------------------------------------------------------------------
        -- Block R-5 : MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
        --   소스: GT_GGET_MKT_FCST_RESULT (RTF → 실적 기준)
        --   20190722 KHSONG: MKT_FCST_RESULT에서 RTF 컬럼이 실적값
        -----------------------------------------------------------------------
        DECLARE
            V_RP_RESULT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RP_RESULT_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');

            IF V_RP_RESULT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                            THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
                -- 실적에서 RTF는 MKT_FCST_RP_CAR/CELL 환산 소스 (20190722 KHSONG)
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE = 'RTF'
                 AND   M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                                        THEN 'RTF' ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-5 END
        END;

        -----------------------------------------------------------------------
        -- Block R-6: RTF_RP_CAR/CELL/ENERGY + MKT_FCST_ENERGY
        --   소스: GT_GGET_MKT_FCST_RESULT (RTF/RTF_SYS_RP)
        --   [CSR ID:4023158] + [C20211103-000146] + [C20221207-000080]
        -----------------------------------------------------------------------
        DECLARE
            V_RTF_RESULT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RTF_RESULT_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
                               'RTF_ENERGY','MKT_FCST_ENERGY');

            IF V_RTF_RESULT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
                                    ELSE '' END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
                                    ELSE '' END
                           WHEN M.MEASURE = 'RTF_ENERGY'      AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
                           WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'MKT_FCST_ENERGY'
                       END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20211103-000146] RTF_ENERGY
                           WHEN M.MEASURE = 'RTF_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                           -- [C20221207-000080] MKT_FCST_ENERGY
                           WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE     IN ('RTF','RTF_SYS_RP')
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
                 AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
                                     'RTF_ENERGY','MKT_FCST_ENERGY')
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.MEASURE = CASE
                                       WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_RP_CELL')                        THEN 'RTF'
                                       WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL',
                                                          'RTF_ENERGY','MKT_FCST_ENERGY')                   THEN 'RTF_SYS_RP'
                                       ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-6 END
        END;

        -----------------------------------------------------------------------
        -- Block R-7: MKT_FCST_RP
        --   소스: GT_GGET_MKT_FCST_RESULT (RTF → MKT_FCST_RP 표시)
        -----------------------------------------------------------------------
        DECLARE
            V_MFTRP_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_MFTRP_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE = 'MKT_FCST_RP';

            IF V_MFTRP_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , 'MKT_FCST_RP'  AS MEASURE   -- RTF 실적 → MKT_FCST_RP 로 표시
                     , F.YYYYMMDD, F.QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND QTY         <> 0
                           AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_GGET_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_GGET_MKT_FCST_RESULT F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE  = 'RTF'         -- 실적은 RTF
                 AND   M.MEASURE  = 'MKT_FCST_RP' -- → MKT_FCST_RP 로 표시
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-7 END
        END;

        -----------------------------------------------------------------------
        -- Block R-8: IN_TRANSIT
        --   소스: GT_GGET_INTRANSIT_DATA
        --   [E20241126-000426] SHIPMENT_PLAN 주석처리됨; IN_TRANSIT만 사용
        --   주의: YYYYMMDD 범위가 p_from_yyyymmdd ~ v_to_yyyymmdd (계획+실적 모두)
        -----------------------------------------------------------------------
        DECLARE
            V_IT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_IT_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE = 'IN_TRANSIT';

            IF V_IT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , F.MEASURE
                     , F.YYYYMMDD, F.QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , ''  AS AS_FROM_SITE
                     , ''  AS CREATE_DATE
                     , ''  AS LAST_UPDATED_BY
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_GGET_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_GGET_INTRANSIT_DATA F
                JOIN   SCM_MGR.GT_GGET_SELECT_MEASURE M
                  ON   F.MEASURE = 'IN_TRANSIT'
                 AND   F.MEASURE = M.MEASURE
                JOIN   SCM_MGR.GT_GGET_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-8 END
        END;

    END IF;  -- 실적 구간 조건 END (V_FROM_YYYYMMDD <= 당주 월요일)

    -----------------------------------------------------------------------
    -- Step 1: GT_GGET_MKT_FCST_DATA → GT_GGET_MKT_FCST_DST  집계
    --   [E20240712-001683] YYYYMMDD 포함 GROUP BY
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD
    , MEASURE_GROUP, FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
    , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
    , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
    , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
    , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
    , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
    , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
         , F.YYYYMMDD
         , MAX(F.MEASURE_GROUP)             AS MEASURE_GROUP
         , MAX(F.CELL_MODEL)               AS FORECAST_INFO_CELL_MODEL
         , MAX(F.END_CUSTOMER)             AS END_CUSTOMER
         , MAX(F.NICK_NAME)               AS NICK_NAME
         , MAX(F.DMS_SALES)               AS DMS_SALES
         , MAX(F.DMS_CUSTOMER)            AS DMS_CUSTOMER
         , MAX(F.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(F.DEPT_ID)                 AS DEPT_ID
         , MAX(F.DEPT_NAME_KO)            AS DEPT_NAME_KO
         , MAX(F.ITEM_TYPE)               AS ITEM_TYPE
         , MAX(F.PROJECT_NAME)            AS PROJECT_NAME
         , MAX(F.PROJECT_OWNER)           AS PROJECT_OWNER
         , MAX(F.OWNER)                   AS OWNER
         , MAX(F.BIZ_TYPE)               AS BIZ_TYPE
         , MAX(F.SOLDTO_CUSTOMER)         AS SOLDTO_CUSTOMER
         , MAX(F.COUNTRY_NAME)            AS COUNTRY_NAME
         , MAX(F.CITY_NAME)              AS CITY_NAME
         , MAX(F.PROJECT_STATUS)          AS PROJECT_STATUS
         , MAX(F.ITEM_NAME)              AS ITEM_NAME
         , MAX(F.VMI_YN)                 AS VMI_YN
         , MAX(F.CUST_GROUP)             AS CUST_GROUP
         , MAX(F.CUST_GROUP_DTL)         AS CUST_GROUP_DTL
         , MAX(F.APPLICATION)            AS APPLICATION
         , MAX(F.ROUTE)                  AS ROUTE
         , MAX(F.MDM_PROJECT_NAME)       AS MDM_PROJECT_NAME
         , MAX(F.MIN_CAPACITY)           AS MIN_CAPACITY
         , MAX(F.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
         , MAX(F.CELL_TYPE)              AS CELL_TYPE
         , MAX(F.FORECAST_INFO_ALL)      AS FORECAST_INFO_ALL
         , MAX(F.FORECAST_INFO_SPEC)     AS FORECAST_INFO_SPEC
         , MAX(F.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
         , MAX(F.CELL_MODEL_NICK_NAME)   AS CELL_MODEL_NICK_NAME
         , MAX(F.CELL_PER_CAR)           AS CELL_PER_CAR
         , MAX(F.CELL_PER_MODULE)        AS CELL_PER_MODULE
         , MAX(F.MODULE_PER_CAR)         AS MODULE_PER_CAR
         , MAX(F.SORT_ORDER_NO)          AS SORT_ORDER_NO
         , MAX(F.ENERGE)                 AS ENERGE
         , MAX(F.CELL_QUANTITY)          AS CELL_QUANTITY
         , MAX(F.AS_FROM_SITE)           AS AS_FROM_SITE
         , MAX(F.CREATE_DATE)            AS CREATE_DATE
         , MAX(F.LAST_UPDATED_BY)        AS LAST_UPDATED_BY
         , MAX(F.SENDER_CODE)            AS SENDER_CODE
         , MAX(F.SENDER_NAME)            AS SENDER_NAME
    FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA F
    GROUP  BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
           ,  F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD;

    -----------------------------------------------------------------------
    -- Step 2: Division 82, MKT_FCST_RP 선택 + VMI 사이트 존재 시
    --         빠진 메저(RTF_SYS_RP, VMI_In_Plan/Req, VMI_Inv, MKT_FCST_RP) 행 보완
    --   [C20201103-000114]
    -----------------------------------------------------------------------
    DECLARE
        V_MKT_FCST_RP_VMI_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_MKT_FCST_RP_VMI_CNT
        FROM   SCM_MGR.GT_GGET_SELECT_MEASURE A
        WHERE  A.MEASURE = 'MKT_FCST_RP'
          AND  P_DIVISION_ID = '82'
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_GGET_MKT_FCST_DST D
                   JOIN   SCM_MGR.SCM_MST_SITE B
                     ON   D.DIVISION_ID = B.DIVISION_ID
                    AND   D.SCM_SITE_ID = B.SCM_SITE_ID
                    AND   B.VMI_YN      = 'Y'
                   WHERE  D.MEASURE     = 'MKT_FCST_RP'
               );

        IF V_MKT_FCST_RP_VMI_CNT > 0 THEN
            -- VMI 사이트 × 빠진 메저 조합 보완
            INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
            , DOM_EXP, FCST_TYPE, INCOTERMS
            , MEASURE, MEASURE_GROUP
            , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
            , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
            , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
            , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
            , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
            , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
            , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
            , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
            , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
            , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                 , A.MEASURE, A.MEASURE_GROUP
                 , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                 , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
                 , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
                 , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                 , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                 , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                 , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                 , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                 , REPLACE(D.SORT_ORDER_NO, '.0', A.SORTKEY)  AS SORT_ORDER_NO
                 , A.ENERGE, A.CELL_QUANTITY
                 , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
            FROM (
                -- VMI 사이트 기반 DISTINCT 헤더
                SELECT B2.MEASURE    AS MEASURE
                     , B2.MEASURE_GROUP
                     , B2.SORTKEY
                     , A2.*
                FROM (
                    SELECT DISTINCT
                           A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                         , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                         , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                         , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                         , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                         , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                         , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                         , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                         , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                         , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                         , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                         , A2.ENERGE, A2.CELL_QUANTITY
                         , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    FROM   SCM_MGR.GT_GGET_MKT_FCST_DST A2
                    JOIN   SCM_MGR.SCM_MST_SITE S
                      ON   A2.DIVISION_ID = S.DIVISION_ID
                     AND   A2.SCM_SITE_ID = S.SCM_SITE_ID
                     AND   S.VMI_YN       = 'Y'
                ) A2,
                (
                    SELECT 'MKT_FCST_RP' AS MEASURE_GROUP, 'MKT_FCST_RP' AS MEASURE, '.9' AS SORTKEY FROM DUAL UNION ALL
                    SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' FROM DUAL UNION ALL
                    SELECT 'VMI_In_Plan' AS MEASURE_GROUP, 'VMI_In_Plan' AS MEASURE, '.2' FROM DUAL UNION ALL
                    SELECT 'VMI_In_Req'  AS MEASURE_GROUP, 'VMI_In_Req'  AS MEASURE, '.3' FROM DUAL UNION ALL
                    SELECT 'VMI_Inv'     AS MEASURE_GROUP, 'VMI_Inv'     AS MEASURE, '.4' FROM DUAL
                ) B2
            ) A
            -- 이미 GT_GGET_MKT_FCST_DST에 존재하는 조합은 제외
            LEFT OUTER JOIN SCM_MGR.GT_GGET_MKT_FCST_DST C
              ON  A.DIVISION_ID    = C.DIVISION_ID
             AND  A.PROJECT_CODE   = C.PROJECT_CODE
             AND  A.SCM_SITE_ID    = C.SCM_SITE_ID
             AND  A.PLANT_SITE_ID  = C.PLANT_SITE_ID
             AND  A.ITEM_ID        = C.ITEM_ID
             AND  A.DOM_EXP        = C.DOM_EXP
             AND  A.FCST_TYPE      = C.FCST_TYPE
             AND  A.INCOTERMS      = C.INCOTERMS
             AND  A.MEASURE        = C.MEASURE
             AND  A.MEASURE_GROUP  = C.MEASURE_GROUP
            LEFT OUTER JOIN SCM_MGR.GT_GGET_SELECT_MEASURE D
              ON  A.MEASURE = D.MEASURE AND A.MEASURE_GROUP = D.MEASURE_GROUP
            WHERE C.MEASURE IS NULL
            ORDER BY A.INCOTERMS, A.MEASURE;
        END IF;
    END;

    -----------------------------------------------------------------------
    -- Step 3: Division 82 + P_INVALID_EXEC=''
    --         → GT_GGET_SALES_PRICE 수집 (mapping 미등록 Sales Price 제공)
    --   [C20200612-000174]
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = '' THEN

        -- LOC measure → MKT_FCST_RP, BNPIn(상품/전극) 행 수집
        INSERT INTO SCM_MGR.GT_GGET_SALES_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS
        , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
        , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
        , PROJECT_STATUS, NICK_NAME, DEPT_ID, DEPT_NAME_KO, VMI_YN
        , PROJECT_NAME, END_CUSTOMER, ENERGE, CELL_QUANTITY
        , MEASURE, MEASURE_GROUP, SORT_ORDER_NO )
        SELECT DISTINCT
               A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
             , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
             , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
             , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
             , 'MKT_FCST_RP'  AS MEASURE
             , 'MKT_FCST_RP'  AS MEASURE_GROUP
             , CASE WHEN NVL(B.VMI_YN,'') <> 'Y' THEN '00.0' ELSE '.9' END  AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM B
          ON   A.DIVISION_ID  = B.DIVISION_ID
         AND   A.PROJECT_CODE = B.PROJECT_CODE
         AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   A.ITEM_ID      = B.ITEM_ID
         AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
        WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.MEASURE     = 'LOC'
          AND  A.FCST_TYPE  <> 'ETC'    -- [C20200702-000136] ETC 제외

        UNION ALL

        SELECT DISTINCT
               A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
             , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
             , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
             , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
             , 'BNPIn'  AS MEASURE
             , 'BNPIn'  AS MEASURE_GROUP
             , '00.0'   AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        JOIN   SCM_MGR.GT_GGET_SITE_ITEM B
          ON   A.DIVISION_ID  = B.DIVISION_ID
         AND   A.PROJECT_CODE = B.PROJECT_CODE
         AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   A.ITEM_ID      = B.ITEM_ID
         AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
         AND   B.ITEM_TYPE   IN ('Q','R')  -- 상품/전극만
        WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.MEASURE     = 'LOC'
          AND  A.FCST_TYPE  <> 'ETC';

        -- SORT_ORDER_NO: GT_GGET_SELECT_MEASURE 기준으로 업데이트
        UPDATE SCM_MGR.GT_GGET_SALES_PRICE A
        SET    A.SORT_ORDER_NO = (
                   SELECT B.SORT_ORDER_NO
                   FROM   SCM_MGR.GT_GGET_SELECT_MEASURE B
                   WHERE  A.MEASURE       = B.MEASURE
                     AND  A.MEASURE_GROUP = B.MEASURE_GROUP
                     AND  ROWNUM          = 1 );

        -- VMI/RTF/MKT_FCST_RP 계열 SORT_ORDER_NO 소수점 자리 조정
        UPDATE SCM_MGR.GT_GGET_SALES_PRICE
        SET    SORT_ORDER_NO =
               CASE WHEN MEASURE = 'RTF_SYS_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.1')
                    WHEN MEASURE = 'VMI_In_Plan'  THEN REPLACE(SORT_ORDER_NO, '.0', '.2')
                    WHEN MEASURE = 'VMI_In_Req'   THEN REPLACE(SORT_ORDER_NO, '.0', '.3')
                    WHEN MEASURE = 'VMI_Inv'      THEN REPLACE(SORT_ORDER_NO, '.0', '.4')
                    WHEN MEASURE = 'MKT_FCST_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.9')
               END
        WHERE  MEASURE IN ('MKT_FCST_RP','RTF_SYS_RP','VMI_In_Plan','VMI_In_Req','VMI_Inv');

    END IF;

    -----------------------------------------------------------------------
    -- Step 4: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 GT_GGET_MKT_FCST_DST에 추가
    --   조건: AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID인 데이터 중
    --         아직 GT_GGET_MKT_FCST_DATA에 AS 메저가 없는 조합 삽입
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = '' AND LP_AS_YN = 'Y' THEN
        DECLARE
            V_AS_MEA_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_AS_MEA_CNT
            FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
            WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');

            IF V_AS_MEA_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DST
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, MEASURE_GROUP
                , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
                , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
                , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
                , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
                , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
                , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
                , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                     , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                     , C.MEASURE, C.MEASURE_GROUP
                     , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                     , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
                     , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
                     , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                     , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                     , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                     , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                     , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                     , C.SORT_ORDER_NO
                     , A.ENERGE, A.CELL_QUANTITY
                     , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
                FROM (
                    -- AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID 기반 DST 헤더 (중복 제거)
                    SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                         , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
                         , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                         , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                         , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                         , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                         , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                         , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                         , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                         , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                         , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                         , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                         , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    FROM   SCM_MGR.GT_GGET_MKT_FCST_DST A2
                    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
                      ON   A2.SCM_SITE_ID = B2.SEGMENT1
                     AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND   B2.SEGMENT3    = P_DIVISION_ID
                    GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                           ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
                           ,  A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                           ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                           ,  A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                           ,  A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                           ,  A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                           ,  A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                           ,  A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                           ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                           ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                           ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                           ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                ) A
                -- AS_IN_REQ/PLAN/INV 메저 목록 (CROSS JOIN)
                JOIN (
                    SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
                    FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
                    WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
                ) C ON 1=1
                -- 이미 GT_GGET_MKT_FCST_DATA에 AS 메저가 있는 조합은 제외
                LEFT OUTER JOIN (
                    SELECT DISTINCT
                           D2.DIVISION_ID, D2.PROJECT_CODE, D2.SCM_SITE_ID, D2.ITEM_ID
                         , D2.DOM_EXP, D2.FCST_TYPE, D2.INCOTERMS, D2.MEASURE, D2.PLANT_SITE_ID
                    FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA D2
                    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
                      ON   D2.SCM_SITE_ID = B3.SEGMENT1
                     AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND   B3.SEGMENT3    = P_DIVISION_ID
                ) D ON  A.DIVISION_ID   = D.DIVISION_ID
                    AND A.PROJECT_CODE  = D.PROJECT_CODE
                    AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                    AND A.ITEM_ID       = D.ITEM_ID
                    AND A.DOM_EXP       = D.DOM_EXP
                    AND A.FCST_TYPE     = D.FCST_TYPE
                    AND A.INCOTERMS     = D.INCOTERMS
                    AND C.MEASURE       = D.MEASURE
                    AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
                WHERE D.DIVISION_ID IS NULL;
            END IF;
        END;
   END IF;

    -----------------------------------------------------------------------
    -- Step 5: Division 82 VMI 재고계산  [E20240102-000545]
    --   5-1) GT_GGET_VMI_INV: RANK=1(최신 일자) 행 추출
    --   5-2) DELETE: VMI_INV 일자 이후에 MKT_FCST/VMI_In_Plan/VMI_In_Req 있는 경우 제거
    --   5-3) DELETE: MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 (VMI_INV만 남김)
    --   5-4) GT_GGET_VMI_INV_RESULT: GT_GGET_MKT_FCST_DATA와 JOIN → 헤더 정보 붙임
    --   5-5) PERIOD 기간만큼 GT_GGET_VMI_INV_RESULT 확장
    --   5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
    --   5-7) GT_GGET_MKT_FCST_DATA에 최종 INSERT
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' THEN

        -- 5-1) 최신 날짜 VMI 관련 데이터 추출 (RANK=1)
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV;
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT;

        INSERT INTO SCM_MGR.GT_GGET_VMI_INV
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        FROM (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                 , RANK() OVER (
                       PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                    DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
                       ORDER BY YYYYMMDD DESC
                   ) AS SEQ
            FROM (
                -- 계획 테이블
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                FROM   SCM_MGR.DM_PLN_MKT_FCST
                WHERE  DIVISION_ID = P_DIVISION_ID
                  AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
                  AND  QTY        <> 0
                  AND  YYYYMMDD  BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                UNION ALL
                -- 실적 테이블 (RESULT): 당주 월요일 이전까지
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
                     , SUM(QTY) AS QTY   -- [PJ2025-50188] CELL_PROD_SITE_ID 제거 후 집계
                FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
                WHERE  DIVISION_ID = P_DIVISION_ID
                  AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
                  AND  QTY        <> 0
                  AND  YYYYMMDD  >= P_FROM_YYYYMMDD
                  AND  YYYYMMDD   < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
                GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                       ,  DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
            ) A
        ) B
        WHERE SEQ = 1;

        -- 5-2) VMI_INV 일자 이후에 MKT_FCST 계열이 있는 경우 → VMI_INV 행 제거
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV C
        WHERE EXISTS (
            SELECT 1
            FROM (
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                     , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                FROM   SCM_MGR.GT_GGET_VMI_INV A    -- VMI_INV
                JOIN   SCM_MGR.GT_GGET_VMI_INV B    -- MKT_FCST 계열
                  ON   A.DIVISION_ID   = B.DIVISION_ID
                 AND   A.PROJECT_CODE  = B.PROJECT_CODE
                 AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                 AND   A.ITEM_ID       = B.ITEM_ID
                 AND   A.DOM_EXP       = B.DOM_EXP
                 AND   A.FCST_TYPE     = B.FCST_TYPE
                 AND   A.INCOTERMS     = B.INCOTERMS
                 AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                 AND   A.MEASURE       = 'VMI_INV'
                 AND   B.MEASURE      IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req')
                 AND   B.YYYYMMDD     >= A.YYYYMMDD + 1
            ) T
            WHERE C.DIVISION_ID   = T.DIVISION_ID
              AND C.PROJECT_CODE  = T.PROJECT_CODE
              AND C.SCM_SITE_ID   = T.SCM_SITE_ID
              AND C.ITEM_ID       = T.ITEM_ID
              AND C.DOM_EXP       = T.DOM_EXP
              AND C.FCST_TYPE     = T.FCST_TYPE
              AND C.INCOTERMS     = T.INCOTERMS
              AND C.PLANT_SITE_ID = T.PLANT_SITE_ID
        );

        -- 5-3) MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 → VMI_INV만 남김
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV
        WHERE  MEASURE IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req');

        -- 5-4) GT_GGET_MKT_FCST_DATA와 JOIN하여 헤더 정보 포함 → GT_GGET_VMI_INV_RESULT
        INSERT INTO SCM_MGR.GT_GGET_VMI_INV_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY
             , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
             , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
             , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
             , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
             , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
             , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
             , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
             , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
             , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
        FROM   SCM_MGR.GT_GGET_VMI_INV A
        JOIN   SCM_MGR.GT_GGET_MKT_FCST_DATA B
          ON   A.DIVISION_ID   = B.DIVISION_ID
         AND   A.PROJECT_CODE  = B.PROJECT_CODE
         AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
         AND   A.ITEM_ID       = B.ITEM_ID
         AND   A.DOM_EXP       = B.DOM_EXP
         AND   A.FCST_TYPE     = B.FCST_TYPE
         AND   A.INCOTERMS     = B.INCOTERMS
         AND   A.MEASURE       = B.MEASURE
         AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
         AND   A.YYYYMMDD      = B.YYYYMMDD;

        -- 5-5) PERIOD 기간만큼 GT_GGET_VMI_INV_RESULT 행 확장
        --       (원본 날짜 이후의 모든 날짜에 동일 QTY 행 생성)
        INSERT INTO SCM_MGR.GT_GGET_VMI_INV_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT DISTINCT
               B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID
             , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE
             , A.BASIS_YYYYMMDD  AS YYYYMMDD   -- 캘린더 날짜로 확장
             , B.PLANT_SITE_ID, B.QTY
             , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
             , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
             , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
             , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
             , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
             , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
             , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
             , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
             , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        LEFT   OUTER JOIN SCM_MGR.GT_GGET_VMI_INV_RESULT B
          ON   A.BASIS_YYYYMMDD > B.YYYYMMDD   -- 원본 날짜 이후 모든 날짜
        WHERE  A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.BASIS_YYYYMMDD > B.YYYYMMDD;

        -- 5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
        DELETE FROM SCM_MGR.GT_GGET_VMI_INV_RESULT A
        WHERE  DIVISION_ID = '82'
          AND  MEASURE     = 'VMI_INV'
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_GGET_VMI_INV Z
                   WHERE  A.DIVISION_ID   = Z.DIVISION_ID
                     AND  A.PROJECT_CODE  = Z.PROJECT_CODE
                     AND  A.SCM_SITE_ID   = Z.SCM_SITE_ID
                     AND  A.ITEM_ID       = Z.ITEM_ID
                     AND  A.DOM_EXP       = Z.DOM_EXP
                     AND  A.FCST_TYPE     = Z.FCST_TYPE
                     AND  A.INCOTERMS     = Z.INCOTERMS
                     AND  A.PLANT_SITE_ID = Z.PLANT_SITE_ID
                     AND  A.YYYYMMDD      = Z.YYYYMMDD
               );

        -- 5-7) GT_GGET_MKT_FCST_DATA에 VMI_INV 보완 행 INSERT
        INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
        , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
        , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
        , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
             , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
             , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
             , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
             , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
             , CUST_GROUP, CUST_GROUP_DTL
             , NULL  AS APPLICATION   -- GT_GGET_VMI_INV_RESULT에 APPLICATION/ROUTE 없음
             , NULL  AS ROUTE
             , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
             , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
             , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
             , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
             , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
        FROM   SCM_MGR.GT_GGET_VMI_INV_RESULT;

    END IF;  -- Division 82 VMI 재고계산 END

    -----------------------------------------------------------------------
    -- Step 6: NOTATION 컬럼 업데이트  [E20240812-000094]
    --   DM_MEASURE_POSITIONAL_NOTATION LOOKUP → MEASURE별 소수점 표기형태 설정
    -----------------------------------------------------------------------
    UPDATE SCM_MGR.GT_GGET_MKT_FCST_DATA A
    SET    A.NOTATION = NVL(
               ( SELECT C.SEGMENT3
                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
                 WHERE  C.LOOKUP_TYPE = 'DM_MEASURE_POSITIONAL_NOTATION'
                   AND  A.MEASURE     = C.SEGMENT2
                   AND  A.DIVISION_ID = C.SEGMENT1
                   AND  ROWNUM        = 1 ),
               'DEFAULT' );

    -----------------------------------------------------------------------
    -- 팀 WHERE 조건 생성 (FN_SCM_GET_WHERE_SQL → 인라인 변환)
    -----------------------------------------------------------------------
    IF P_TEAM_ID = 'ALL' THEN
        V_TEAM_WHERE := '1=1';
    ELSE
        -- P_TEAM_ID 가 콤마 구분 목록일 경우 IN 절 생성
        V_TEAM_WHERE := 'A.DEPT_ID IN ('''
                     || REPLACE(P_TEAM_ID, ',', ''',''')
                     || ''')';
    END IF;

    -----------------------------------------------------------------------
    -- 분기: Division 82 + P_INVALID_EXEC=''  → PIVOT SQL #1 (AS용)
    --        그 외                             → AS_IN_REQ 보완 + PIVOT SQL #2
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = '' THEN

        -- -----------------------------------------------------------------------
        -- PIVOT SQL #1 (AS용)
        --   소스: GT_GGET_SALES_PRICE  FULL OUTER JOIN  GT_GGET_MKT_FCST_DST
        --         → GT_GGET_MF (임시 조인 결과)
        --         → PIVOT + EXECUTE IMMEDIATE → O_RC
        -- -----------------------------------------------------------------------
        V_SQL_TEXT :=
        'WITH MF_BASE AS (' || CHR(10) ||
        'SELECT' || CHR(10) ||
        '      A.DIVISION_ID' || CHR(10) ||
        '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
        '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
        '    , A.SCM_SITE_ID' || CHR(10) ||
        '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
        '    , A.PLANT_SITE_ID' || CHR(10) ||
        '    , A.PROJECT_CODE' || CHR(10) ||
        '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
        '    , A.ITEM_ID' || CHR(10) ||
        '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
        '    , A.INCOTERMS' || CHR(10) ||
        '    , A.FCST_TYPE' || CHR(10) ||
        '    , A.DOM_EXP' || CHR(10) ||
        '    , A.MEASURE' || CHR(10) ||
        '    , A.END_CUSTOMER' || CHR(10) ||
        '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
        '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
        '    , A.NICK_NAME' || CHR(10) ||
        '    , A.DMS_SALES' || CHR(10) ||
        '    , A.DMS_CUSTOMER' || CHR(10) ||
        '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
        '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
        '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
        '    , C.DAYOFWEEK' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
        '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
        '    , A.ITEM_TYPE' || CHR(10) ||
        '    , A.PROJECT_NAME' || CHR(10) ||
        '    , A.PROJECT_OWNER' || CHR(10) ||
        '    , A.OWNER' || CHR(10) ||
        '    , A.BIZ_TYPE' || CHR(10) ||
        '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
        '    , A.COUNTRY_NAME' || CHR(10) ||
        '    , A.CITY_NAME' || CHR(10) ||
        '    , A.PROJECT_STATUS' || CHR(10) ||
        '    , A.ITEM_NAME' || CHR(10) ||
        '    , A.VMI_YN' || CHR(10) ||
        '    , A.CUST_GROUP' || CHR(10) ||
        '    , A.CUST_GROUP_DTL' || CHR(10) ||
        '    , A.APPLICATION' || CHR(10) ||
        '    , A.ROUTE' || CHR(10) ||
        '    , A.MDM_PROJECT_NAME' || CHR(10) ||
        '    , A.MIN_CAPACITY' || CHR(10) ||
        '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '    , A.CELL_TYPE' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '    , A.FORECAST_INFO_ALL' || CHR(10) ||
        '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
        '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
        '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
        '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
        '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
        '                THEN D.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '                ELSE D.QTY END AS NUMBER(10)) AS QTY' || CHR(10) ||
        '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE '''' END AS MONTH_END_YN' || CHR(10) ||
        '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE '''' END AS WEEK_END_YN' || CHR(10) ||
        '    , CASE' || CHR(10) ||
        '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
        '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
        '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
        '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          ELSE ''''' || CHR(10) ||
        '      END AS EDIT_FLAG' || CHR(10) ||
        '    , A.CELL_PER_CAR' || CHR(10) ||
        '    , A.CELL_PER_MODULE' || CHR(10) ||
        '    , A.MODULE_PER_CAR' || CHR(10) ||
        '    , A.SORT_ORDER_NO' || CHR(10) ||
        '    , A.MEASURE_GROUP' || CHR(10) ||
        '    , A.ENERGE' || CHR(10) ||
        '    , A.CELL_QUANTITY' || CHR(10) ||
        '    , A.NEW_FLAG' || CHR(10) ||
        '    , NVL(VM.VMI_VAL,'''')                                  AS VMI_STD_DIO' || CHR(10) ||
        '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
        '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
        '    , A.AS_YN' || CHR(10) ||
        '    , A.AS_FROM_SITE' || CHR(10) ||
        '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
        '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
        '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
        '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
        '    , CASE WHEN 1 = 2 THEN '' '' END AS NOTATION' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT' || CHR(10) ||
        '          NVL(M.DIVISION_ID,  P.DIVISION_ID)                AS DIVISION_ID' || CHR(10) ||
        '        , NVL(M.PROJECT_CODE, P.PROJECT_CODE)               AS PROJECT_CODE' || CHR(10) ||
        '        , NVL(M.SCM_SITE_ID,  P.SCM_SITE_ID)                AS SCM_SITE_ID' || CHR(10) ||
        '        , NVL(M.PLANT_SITE_ID,P.PLANT_SITE_ID)              AS PLANT_SITE_ID' || CHR(10) ||
        '        , NVL(M.ITEM_ID,      P.ITEM_ID)                    AS ITEM_ID' || CHR(10) ||
        '        , NVL(M.DOM_EXP,      P.DOM_EXP)                    AS DOM_EXP' || CHR(10) ||
        '        , NVL(M.FCST_TYPE,    P.FCST_TYPE)                  AS FCST_TYPE' || CHR(10) ||
        '        , NVL(M.INCOTERMS,    P.INCOTERMS)                  AS INCOTERMS' || CHR(10) ||
        '        , CASE WHEN P.MEASURE IS NOT NULL OR NVL(P.MEASURE,'''') <> '''' THEN P.MEASURE' || CHR(10) ||
        '               WHEN M.MEASURE IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
        '               ELSE M.MEASURE END                           AS MEASURE' || CHR(10) ||
        '        , CASE WHEN P.MEASURE_GROUP IS NOT NULL OR NVL(P.MEASURE_GROUP,'''') <> '''' THEN P.MEASURE_GROUP' || CHR(10) ||
        '               WHEN M.MEASURE_GROUP IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
        '               ELSE M.MEASURE_GROUP END                     AS MEASURE_GROUP' || CHR(10) ||
        '        , M.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '        , NVL(M.END_CUSTOMER,   P.END_CUSTOMER)             AS END_CUSTOMER' || CHR(10) ||
        '        , NVL(M.NICK_NAME,      P.NICK_NAME)                AS NICK_NAME' || CHR(10) ||
        '        , M.DMS_SALES' || CHR(10) ||
        '        , M.DMS_CUSTOMER' || CHR(10) ||
        '        , M.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '        , NVL(M.DEPT_ID,        P.DEPT_ID)                  AS DEPT_ID' || CHR(10) ||
        '        , NVL(M.DEPT_NAME_KO,   P.DEPT_NAME_KO)             AS DEPT_NAME_KO' || CHR(10) ||
        '        , NVL(M.ITEM_TYPE,      P.ITEM_TYPE)                AS ITEM_TYPE' || CHR(10) ||
        '        , NVL(M.PROJECT_NAME,   P.PROJECT_NAME)             AS PROJECT_NAME' || CHR(10) ||
        '        , NVL(M.PROJECT_OWNER,  P.PROJECT_OWNER)            AS PROJECT_OWNER' || CHR(10) ||
        '        , NVL(M.OWNER,          P.OWNER)                    AS OWNER' || CHR(10) ||
        '        , NVL(M.BIZ_TYPE,       P.BIZ_TYPE)                 AS BIZ_TYPE' || CHR(10) ||
        '        , NVL(M.SOLDTO_CUSTOMER,P.SOLDTO_CUSTOMER)          AS SOLDTO_CUSTOMER' || CHR(10) ||
        '        , NVL(M.COUNTRY_NAME,   P.COUNTRY_NAME)             AS COUNTRY_NAME' || CHR(10) ||
        '        , NVL(M.CITY_NAME,      P.CITY_NAME)                AS CITY_NAME' || CHR(10) ||
        '        , NVL(M.PROJECT_STATUS, P.PROJECT_STATUS)           AS PROJECT_STATUS' || CHR(10) ||
        '        , NVL(M.ITEM_NAME,      P.ITEM_NAME)                AS ITEM_NAME' || CHR(10) ||
        '        , NVL(M.VMI_YN,         P.VMI_YN)                   AS VMI_YN' || CHR(10) ||
        '        , M.CUST_GROUP' || CHR(10) ||
        '        , M.CUST_GROUP_DTL' || CHR(10) ||
        '        , M.APPLICATION' || CHR(10) ||
        '        , M.ROUTE' || CHR(10) ||
        '        , M.MDM_PROJECT_NAME' || CHR(10) ||
        '        , M.MIN_CAPACITY' || CHR(10) ||
        '        , M.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '        , M.CELL_TYPE' || CHR(10) ||
        '        , M.FORECAST_INFO_ALL' || CHR(10) ||
        '        , M.FORECAST_INFO_SPEC' || CHR(10) ||
        '        , M.FORECAST_INFOR_VERSION' || CHR(10) ||
        '        , M.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '        , M.CELL_PER_CAR' || CHR(10) ||
        '        , M.CELL_PER_MODULE' || CHR(10) ||
        '        , M.MODULE_PER_CAR' || CHR(10) ||
        '        , NVL(P.SORT_ORDER_NO, M.SORT_ORDER_NO)             AS SORT_ORDER_NO' || CHR(10) ||
        '        , NVL(M.ENERGE,         P.ENERGE)                   AS ENERGE' || CHR(10) ||
        '        , NVL(M.CELL_QUANTITY,  P.CELL_QUANTITY)            AS CELL_QUANTITY' || CHR(10) ||
        '        , CASE WHEN M.DIVISION_ID IS NULL THEN ''Y'' ELSE '''' END AS NEW_FLAG' || CHR(10) ||
        '        , ''' || LP_AS_YN || '''                             AS AS_YN' || CHR(10) ||
        '        , M.AS_FROM_SITE' || CHR(10) ||
        '        , M.CREATE_DATE' || CHR(10) ||
        '        , M.LAST_UPDATED_BY' || CHR(10) ||
        '        , M.SENDER_CODE' || CHR(10) ||
        '        , M.SENDER_NAME' || CHR(10) ||
        '        , M.YYYYMMDD' || CHR(10) ||
        '    FROM SCM_MGR.GT_GGET_SALES_PRICE P' || CHR(10) ||
        '    FULL OUTER JOIN SCM_MGR.GT_GGET_MKT_FCST_DST M' || CHR(10) ||
        '      ON  P.DIVISION_ID   = M.DIVISION_ID' || CHR(10) ||
        '      AND P.PROJECT_CODE  = M.PROJECT_CODE' || CHR(10) ||
        '      AND P.SCM_SITE_ID   = M.SCM_SITE_ID' || CHR(10) ||
        '      AND P.PLANT_SITE_ID = M.PLANT_SITE_ID' || CHR(10) ||
        '      AND P.ITEM_ID       = M.ITEM_ID' || CHR(10) ||
        '      AND P.FCST_TYPE     = M.FCST_TYPE' || CHR(10) ||
        '      AND P.INCOTERMS     = M.INCOTERMS' || CHR(10) ||
        '      AND P.DOM_EXP       = M.DOM_EXP' || CHR(10) ||
        '      AND P.MEASURE       = M.MEASURE' || CHR(10) ||
        ') A' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_GGET_MKT_FCST_DATA D' || CHR(10) ||
        '  ON  A.DIVISION_ID   = D.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE  = D.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID   = D.SCM_SITE_ID' || CHR(10) ||
        '  AND A.PLANT_SITE_ID = D.PLANT_SITE_ID' || CHR(10) ||
        '  AND A.ITEM_ID       = D.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP       = D.DOM_EXP' || CHR(10) ||
        '  AND A.FCST_TYPE     = D.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS     = D.INCOTERMS' || CHR(10) ||
        '  AND A.MEASURE       = D.MEASURE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
        '  ON  C.BASIS_YYYYMMDD = D.YYYYMMDD' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
        '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
        '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_MONTH_END C2' || CHR(10) ||
        '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_WEEK_END C3' || CHR(10) ||
        '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
        '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
        '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
        '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
        '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
        '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
        '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
        '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
        '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_GGET_VMI_DIO VM' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = VM.KEY_JOIN' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_SSP_SYNC B1' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_BNP B2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
        '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
        '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
        '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
        '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
        '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
        '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
        '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
        '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
        '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
        ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
        '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
        '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
        '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
        '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
        '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
        '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
        '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
        '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
        '    UNION' || CHR(10) ||
        '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
        ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
        'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
        ')' || CHR(10) ||
        -- ── PIVOT WRAPPER (일별/주별/월별 UNION ALL + PIVOT) ──────────────────────
        'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
        ') F' || CHR(10) ||
        'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
        '[@V_ORDERBY]';


    ELSE

        -- -----------------------------------------------------------------------
        -- 비AS 경로 보완 처리: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 추가
        -- -----------------------------------------------------------------------
		-- IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = '' AND AND LP_AS_YN = 'Y' THEN
        IF LP_AS_YN = 'Y' THEN
            DECLARE
                V_AS_CNT2 PLS_INTEGER := 0;
            BEGIN
                SELECT COUNT(1) INTO V_AS_CNT2
                FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
                WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');

                IF V_AS_CNT2 > 0 THEN
                    -- AS 사이트에 해당하는 조합 중 AS 메저가 없는 날짜에 QTY=0 행 삽입
                    INSERT INTO SCM_MGR.GT_GGET_MKT_FCST_DATA
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
                    , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                    , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
                    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER
                    , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
                    , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
                    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
                    , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
                    , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                    , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                         , C.MEASURE
                         , A.YYYYMMDD   -- MAX(YYYYMMDD) 기준 날짜 사용
                         , 0  AS QTY
                         , C.MEASURE_GROUP
                         , A.CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                         , A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO
                         , A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER
                         , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                         , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                         , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                         , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                         , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                         , C.SORT_ORDER_NO
                         , A.ENERGE, A.CELL_QUANTITY
                         , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
                    FROM (
                        -- AS 사이트 기반 헤더 (최신 YYYYMMDD)
                        SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                             , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                             , MAX(A2.YYYYMMDD) AS YYYYMMDD
                             , 0 AS QTY
                             , A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                             , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
                             , A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
                             , A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
                             , A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
                             , A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
                             , A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                             , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                             , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                             , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                             , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                        FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA A2
                        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
                          ON   A2.SCM_SITE_ID = B2.SEGMENT1
                         AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
                         AND   B2.SEGMENT3    = P_DIVISION_ID
                        GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                               ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                               ,  A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                               ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
                               ,  A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
                               ,  A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
                               ,  A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
                               ,  A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
                               ,  A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                               ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                               ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                               ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                               ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    ) A
                    -- AS_IN_REQ/PLAN/INV 메저 CROSS JOIN
                    JOIN (
                        SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
                        FROM   SCM_MGR.GT_GGET_SELECT_MEASURE
                        WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
                    ) C ON 1=1
                    -- 이미 존재하는 조합 제외
                    LEFT OUTER JOIN (
                        SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                                      , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                        FROM   SCM_MGR.GT_GGET_MKT_FCST_DATA D2
                        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
                          ON   D2.SCM_SITE_ID = B3.SEGMENT1
                         AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
                         AND   B3.SEGMENT3    = P_DIVISION_ID
                    ) D ON  A.DIVISION_ID   = D.DIVISION_ID
                        AND A.PROJECT_CODE  = D.PROJECT_CODE
                        AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                        AND A.ITEM_ID       = D.ITEM_ID
                        AND A.DOM_EXP       = D.DOM_EXP
                        AND A.FCST_TYPE     = D.FCST_TYPE
                        AND A.INCOTERMS     = D.INCOTERMS
                        AND C.MEASURE       = D.MEASURE
                        AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
                    WHERE D.DIVISION_ID IS NULL;
                END IF;
            END;
        END IF;

        -- -----------------------------------------------------------------------
        -- PIVOT SQL #2 (비AS용, 일반 경로)
        --   소스: GT_GGET_MKT_FCST_DATA  → #MF (임시)
        --         → PIVOT + EXECUTE IMMEDIATE
        -- -----------------------------------------------------------------------
        V_SQL_TEXT :=
        'WITH MF_BASE AS (' || CHR(10) ||
        'SELECT' || CHR(10) ||
        '      A.DIVISION_ID' || CHR(10) ||
        '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
        '    , A.SCM_SITE_ID' || CHR(10) ||
        '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
        '    , A.PLANT_SITE_ID' || CHR(10) ||
        '    , A.PROJECT_CODE' || CHR(10) ||
        '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
        '    , A.ITEM_ID' || CHR(10) ||
        '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
        '    , A.INCOTERMS' || CHR(10) ||
        '    , A.FCST_TYPE' || CHR(10) ||
        '    , A.DOM_EXP' || CHR(10) ||
        '    , A.MEASURE' || CHR(10) ||
        '    , A.END_CUSTOMER' || CHR(10) ||
        '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
        '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
        '    , A.NICK_NAME' || CHR(10) ||
        '    , A.DMS_SALES' || CHR(10) ||
        '    , A.DMS_CUSTOMER' || CHR(10) ||
        '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
        '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
        '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
        '    , C.DAYOFWEEK' || CHR(10) ||
        '    , A.CELL_MODEL                                          AS FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
        '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
        '    , A.ITEM_TYPE' || CHR(10) ||
        '    , A.PROJECT_NAME' || CHR(10) ||
        '    , A.PROJECT_OWNER' || CHR(10) ||
        '    , A.OWNER' || CHR(10) ||
        '    , A.BIZ_TYPE' || CHR(10) ||
        '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
        '    , A.COUNTRY_NAME' || CHR(10) ||
        '    , A.CITY_NAME' || CHR(10) ||
        '    , A.PROJECT_STATUS' || CHR(10) ||
        '    , A.ITEM_NAME' || CHR(10) ||
        '    , A.VMI_YN' || CHR(10) ||
        '    , A.CUST_GROUP' || CHR(10) ||
        '    , A.CUST_GROUP_DTL' || CHR(10) ||
        '    , A.APPLICATION' || CHR(10) ||
        '    , A.ROUTE' || CHR(10) ||
        '    , A.MDM_PROJECT_NAME' || CHR(10) ||
        '    , A.MIN_CAPACITY' || CHR(10) ||
        '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '    , A.CELL_TYPE' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '    , A.FORECAST_INFO_ALL' || CHR(10) ||
        '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
        '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
        '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
        '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
        '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
        '                THEN A.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '                ELSE A.QTY END AS NUMBER(36,10)) AS QTY' || CHR(10) ||
        '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE '''' END AS MONTH_END_YN' || CHR(10) ||
        '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE '''' END AS WEEK_END_YN' || CHR(10) ||
        '    , CASE' || CHR(10) ||
        '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
        '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
        '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
        '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          ELSE ''''' || CHR(10) ||
        '      END AS EDIT_FLAG' || CHR(10) ||
        '    , A.CELL_PER_CAR' || CHR(10) ||
        '    , A.CELL_PER_MODULE' || CHR(10) ||
        '    , A.MODULE_PER_CAR' || CHR(10) ||
        '    , A.SORT_ORDER_NO' || CHR(10) ||
        '    , A.MEASURE_GROUP' || CHR(10) ||
        '    , A.ENERGE' || CHR(10) ||
        '    , A.CELL_QUANTITY' || CHR(10) ||
        '    , ''''                                                 AS NEW_FLAG' || CHR(10) ||
        '    , CASE WHEN A.DIVISION_ID = ''40''' || CHR(10) ||
        '           THEN TO_CHAR(CAST(VM.VMI_STD_DIO AS NUMBER))' || CHR(10) ||
        '           ELSE VM.VMI_VAL END                              AS VMI_STD_DIO' || CHR(10) ||
        '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
        '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
        '    , ''' || LP_AS_YN || '''                                AS AS_YN' || CHR(10) ||
        '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
        '    , NVL(A.AS_FROM_SITE,'''')                             AS AS_FROM_SITE' || CHR(10) ||
        '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
        '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
        '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
        '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
        '    , A.NOTATION' || CHR(10) ||
        'FROM SCM_MGR.GT_GGET_MKT_FCST_DATA A' || CHR(10) ||
        'INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
        '  ON  C.BASIS_YYYYMMDD = A.YYYYMMDD' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
        '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
        '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_MONTH_END C2' || CHR(10) ||
        '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_CAL_WEEK_END C3' || CHR(10) ||
        '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
        '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
        '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
        '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
        '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
        '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
        '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
        '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
        '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_GGET_VMI_DIO VM' || CHR(10) ||
        '  ON  A.ITEM_ID     = CASE WHEN ''' || P_DIVISION_ID || ''' = ''40'' THEN VM.KEY_JOIN ELSE A.ITEM_ID END' || CHR(10) ||
        '  AND ( ''' || P_DIVISION_ID || ''' = ''40''  ' || CHR(10) ||
        '        OR A.SCM_SITE_ID = VM.KEY_JOIN )' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_SSP_SYNC B1' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_GGET_T_BNP B2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
        '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
        '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
        '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
        '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
        '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
        '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
        '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
        '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
        '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
        ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
        '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
        '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
        '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
        '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
        '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
        '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
        '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
        '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
        '    UNION' || CHR(10) ||
        '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
        ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
        'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
        ')' || CHR(10) ||
        -- ── PIVOT WRAPPER (동일) ──────────────────────────────────────────────────
        'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
        ') F' || CHR(10) ||
        'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
        '[@V_ORDERBY]';

    END IF;



    -----------------------------------------------------------------------
    -- 플레이스홀더 치환
    -----------------------------------------------------------------------
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_COL_LIST]',  V_PV_COL_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_LIST]',      V_PV_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_COLUMN]',       V_COLUMN);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_groupby]',      V_GROUPBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_team_id]',      V_TEAM_WHERE);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_created_by]',   P_CREATED_BY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_group_id]',     V_GROUP_ID);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_orderby]',      V_ORDERBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',      V_ORDERBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_from_yyyymmdd]',P_FROM_YYYYMMDD);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_to_yyyymmdd]',  P_TO_YYYYMMDD);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@CellQtyYN]',      P_CELL_YN);
    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -----------------------------------------------------------------------
    -- EXECUTE IMMEDIATE → O_RC 반환
    -----------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(V_SQL_TEXT);
    OPEN O_RC1 FOR V_SQL_TEXT;

    -----------------------------------------------------------------------
    -- O_RC2: 8주 이내 버킷 정보 (20181115 소형 사업부 일별 입력 전용)
    -- 원본: SELECT TOP 1 * FROM SCM_SYS_CALENDAR_M
    --       WHERE ISO_WEEK = DATEPART(ISO_WEEK, (GETDATE()) + (7) * 7)
    --         AND CALENDAR_YYYY = DATEPART(YEAR, (GETDATE()) + (7) * 7)
    --       ORDER BY BASIS_YYYYMMDD
    -----------------------------------------------------------------------
    OPEN O_RC2 FOR
        SELECT *
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE  ISO_YYYYWW  = TO_CHAR(SYSDATE + (7*7), 'IYYY') ||
                             TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE + (7*7), 'IW')), 'FM00')
        ORDER  BY BASIS_YYYYMMDD
        FETCH  FIRST 1 ROW ONLY;

    -----------------------------------------------------------------------
    -- O_RC3: 현재 주차 정보 (20211130)
    -- 원본: SELECT 'M_'+THIS_YYYYMM, 'W_'+THIS_YYYYMMWW, ...
    --                현재주 + 전주 정보
    -----------------------------------------------------------------------
    OPEN O_RC3 FOR
        SELECT 'M_' || A.BASIS_YYYYMM                         AS THIS_YYYYMM
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK           AS THIS_YYYYMMWW
             , A.BASIS_DATE
             , 'M_' || B.BASIS_YYYYMM                         AS PRE_YYYYMM
             , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK           AS PRE_YYYYMMWW
             , A.BASIS_YYYYMM, A.ISO_WEEK
        FROM   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) A
        JOIN   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')) B ON 1=1;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;

        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
            'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
            'P_CREATED_BY'    VALUE P_CREATED_BY,
            'P_USER_GROUP'    VALUE P_USER_GROUP,
            'P_ITEM_ID'       VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, 0, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE
         || ' / SQLERRM='   || V_SQL_ERRMSG
         || ' / BACKTRACE=' || V_BACKTRACE
         || ' / PARAMS='    || V_PROC_INPUT
        );

END DMF0003_GET_MKT_FCST_DATA;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_PRPOPUP
(
	p_POPUP_TYPE		VARCHAR2,
    p_division_id		VARCHAR2,
	p_REQUEST_NO		VARCHAR2,
    p_PROJECT_CODE		VARCHAR2,
    p_SCM_SITE_ID		VARCHAR2,
    p_ITEM_ID	        VARCHAR2,
	p_DOM_EXP			VARCHAR2,
	p_FCST_TYPE		VARCHAR2,
	p_INCOTERMS		VARCHAR2,
	p_PLANT_SITE_ID	VARCHAR2,
	p_YYYYMMDD			VARCHAR2, --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
	P_PLAN_QTY			VARCHAR2,
	p_CREATED_BY		VARCHAR2
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:03
 * 파일: dbo.DMF0003_GET_PRPOPUP.sql
 * ----------------------------------------
 * ⚠ IF: IF:9  END IF:6  차이:+3
 * ----------------------------------------
 * BEGIN 위치: L55
 * END;  위치: L300
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    V_PUCH_MGR VARCHAR2(150 CHAR);
    V_DEPT_ID VARCHAR2(50 CHAR);
    v_cnt_1  INTEGER := 0;
BEGIN

			, V_PUCH_GROUP			VARCHAR2(150 CHAR)
			, V_STORAGE_PLANT_ID	VARCHAR2(60 CHAR)
			, V_ERR_MSG			VARCHAR2(1000 CHAR)
			, v_ERR_CNT			VARCHAR2(10 CHAR)
			, v_USER_NAME			VARCHAR2(150 CHAR)

	-- 신규 REQUEST 일 경우 기존재하는 REQUEST 가 하나라도 있으면 에러처리한다.
	IF ( p_POPUP_TYPE = 'Request_PR') THEN
		/* TODO:GTT:GT_DMF0_-->GT_DMF0_ */
		INSERT INTO GT_DMF0_
		SELECT
			P_DIVISION_ID AS DIVISION_ID
			, B8.TOKEN AS YYYYMMDD
			, P_PROJECT_CODE AS PROJECT_CODE
			, B1.TOKEN AS ITEM_ID, B2.TOKEN AS PLAN_QTY
			, B3.TOKEN AS DOM_EXP, B4.TOKEN AS FCST_TYPE
			, B5.TOKEN AS INCOTERMS, B6.TOKEN AS PLANT_SITE_ID
			, B7.TOKEN AS SCM_SITE_ID
		FROM UF_FX_String_Split(p_ITEM_ID, '^') B1
		LEFT OUTER JOIN UF_FX_String_Split(P_PLAN_QTY			, '^') B2  ON B1.NR = B2.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_DOM_EXP			, '^') B3  ON B1.NR = B3.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_FCST_TYPE			, '^') B4  ON B1.NR = B4.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_INCOTERMS				, '^') B5  ON B1.NR = B5.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PLANT_SITE_ID			, '^') B6  ON B1.NR = B6.NR
		LEFT OUTER JOIN UF_FX_String_Split(P_SCM_SITE_ID			, '^') B7  ON B1.NR = B7.NR
		-- [C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
		LEFT OUTER JOIN UF_FX_String_Split(p_YYYYMMDD				, '^') B8  ON B1.NR = B8.NR
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B1.TOKEN = C.ITEM_ID
		WHERE NVL(B1.TOKEN, NULL) IS NOT NULL;


		/* TODO:GTT:GT_DMF0_ERR-->GT_DMF0_ERR */
		INSERT INTO GT_DMF0_ERR
		SELECT DISTINCT A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.YYYYMMDD
		FROM GT_DMF0_ A
		JOIN DM_PLN_PR_DETAIL B ON
				A.DIVISION_ID	= B.DIVISION_ID
			AND A.PROJECT_CODE	= B.PROJECT_CODE
			AND A.SCM_SITE_ID	= B.SCM_SITE_ID
			AND A.ITEM_ID		= B.ITEM_ID
			AND A.DOM_EXP		= B.DOM_EXP
			AND A.FCST_TYPE		= B.FCST_TYPE
			AND A.INCOTERMS		= B.INCOTERMS
			AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
			AND A.YYYYMMDD		= B.YYYYMMDD

		SELECT COUNT(1)
		INTO v_cnt_1
		FROM GT_DMF0_ERR;
		IF v_cnt_1 > 0 THEN
			SELECT COUNT(*)
  INTO V_ERR_CNT
			FROM GT_DMF0_ERR

			SELECT /*__INTO_V_ERR_MSG__*/ '[Sales Site:'  ||  RTRIM(SCM_SITE_ID)  ||  ']'
				 ||  '[Model :'  ||  RTRIM(ITEM_ID)  ||  ']'
				 ||  '[FCST Type :'  ||  RTRIM(FCST_TYPE)  ||  ']'
				 ||  '[YYYYMMDd :'  ||  RTRIM(YYYYMMDD)  ||  ']'
				 ||  '외 '  ||  V_ERR_CNT  ||  '건은 기 Request 가 생성된 건입니다. '
			FROM GT_DMF0_ERR

			SELECT V_ERR_MSG AS ERR_MSG
			RETURN;

		END IF;

		IF NOT EXISTS (
			SELECT DISTINCT A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.YYYYMMDD
			FROM GT_DMF0_ A
			JOIN DM_PLN_MKT_FCST B ON
					A.DIVISION_ID	= B.DIVISION_ID
				AND A.PROJECT_CODE	= B.PROJECT_CODE
				AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				AND A.ITEM_ID		= B.ITEM_ID
				AND A.DOM_EXP		= B.DOM_EXP
				AND A.FCST_TYPE		= B.FCST_TYPE
				AND A.INCOTERMS		= B.INCOTERMS
				AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
				AND A.YYYYMMDD		= B.YYYYMMDD
				AND A.PLAN_QTY		= B.QTY				-- 수량까지 일치해야 한다.
			WHERE B.DIVISION_ID = P_DIVISION_ID
				AND B.MEASURE = 'BNPIn'
				) THEN
			SELECT 'BNP In 메저의 수량이 아직 등록되지 않았습니다.'  AS ERR_MSG
			RETURN;
		END IF;


	-- POPUP_TYPE = View_PR 일 경우 MKT FCST 의 값을 이용해서 REQUEST_NO 를 찾아준다.
	IF ( p_POPUP_TYPE = 'View_PR' AND p_REQUEST_NO IS NULL) THEN


		SELECT p_REQUEST_NO = MAX(REQUEST_NO)
		FROM DM_PLN_PR_DETAIL A
		WHERE DIVISION_ID = P_DIVISION_ID
			AND PROJECT_CODE	= P_PROJECT_CODE
			AND SCM_SITE_ID		= P_SCM_SITE_ID
			AND ITEM_ID			= P_ITEM_ID
			AND DOM_EXP			= P_DOM_EXP
			AND FCST_TYPE		= P_FCST_TYPE
			AND INCOTERMS		= P_INCOTERMS
			AND NVL(PLANT_SITE_ID, NULL)	= NVL(P_PLANT_SITE_ID, NULL)
			AND YYYYMMDD		= P_YYYYMMDD;

		IF NVL(p_REQUEST_NO, NULL) IS NULL THEN
			SELECT 'PR 이 존재하지 않습니다.' AS ERR_MSG
			RETURN;
		END IF;

	IF NVL(P_REQUEST_NO, NULL) IS NOT NULL THEN

		-- DETAIL
		SELECT A.ITEM_SEQ
			, A.STORAGE_PLANT_ID
			, FN_CHAR_TO_DATE(A.YYYYMMDD) AS YYYYMMDD
			, A.PROJECT_CODE
			, A.ITEM_ID
			, B.ITEM_NAME AS ITEM_NAME
			, B.ITEM_UOM AS ITEM_UOM
			, A.PLAN_QTY AS QTY
			, A.DOM_EXP
			, A.FCST_TYPE
			, A.INCOTERMS
			, A.PLANT_SITE_ID
			, A.SCM_SITE_ID
			, A.STORAGE_ID AS SLOC
			, A.PR_ITEM_DETAIL AS ITEM_DETAIL
		FROM DM_PLN_PR_DETAIL A
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID AND A.DIVISION_ID = B.DIVISION_ID
		WHERE A.DIVISION_ID = P_DIVISION_ID
			AND A.REQUEST_NO = P_REQUEST_NO

		-- HEADER
		SELECT A.REQUEST_NO
			, FN_GET_DIVISION_NAME(A.DIVISION_ID) AS DIVISION_NAME
			, A.PUCH_MGR
			, A.PUCH_GROUP
			, SCM_ARR_SPL_VAL(A.LAST_UPDATED_BY, '^', 1) AS REQUESTED_BY
			, A.LAST_UPDATE_DATE AS REQUEST_DATE
			, A.PR_HEADER
		FROM DM_PLN_PR_DETAIL A
		WHERE DIVISION_ID = P_DIVISION_ID
			AND REQUEST_NO = P_REQUEST_NO;

	ELSE  -- 신규 또는 ADD

		-- ADD HISTORY 일 경우 기존 데이터가 없으면 에러처리한다.
		IF ( p_POPUP_TYPE = 'ADD_HISTORY' ) THEN
			IF NOT EXISTS (
				SELECT *
				FROM DM_PLN_PR_DETAIL A
				WHERE DIVISION_ID = P_DIVISION_ID
					AND PROJECT_CODE	= P_PROJECT_CODE
					AND SCM_SITE_ID		= P_SCM_SITE_ID
					AND ITEM_ID			= P_ITEM_ID
					AND DOM_EXP			= P_DOM_EXP
					AND FCST_TYPE		= P_FCST_TYPE
					AND INCOTERMS		= P_INCOTERMS
					AND NVL(PLANT_SITE_ID, NULL)	= NVL(P_PLANT_SITE_ID, NULL)
					AND YYYYMMDD		= P_YYYYMMDD
					) THEN
				SELECT '기존 PR 이 존재하지 않습니다.\r\n Request PR 을 이용해주세요.' AS ERR_MSG
				RETURN;
			END IF;

		SELECT /*__INTO_V_PUCH_MGR__*/ SEGMENT1
				, V_PUCH_GROUP = SEGMENT2
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		WHERE LOOKUP_TYPE = 'DM_PR_PUCH'

		-- [C20210813-000004] 기본 plant 와 sloc 처리

			, V_DEFAULT_PLANT VARCHAR2(50 CHAR)
			, V_DEFAULT_SLOC	VARCHAR2(50 CHAR)

		SELECT DEPT_ID,
    UserName
  INTO V_DEPT_ID, v_USER_NAME
		FROM TB_FX_USER
		WHERE USERID = p_CREATED_BY



		-- DEPT 가 걸리면 W/S PLANT, 없으면 일반
		SELECT /*__INTO_V_DEFAULT_PLANT__*/ SEGMENT1
			, V_DEFAULT_SLOC = SEGMENT2
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		WHERE LOOKUP_TYPE = 'DM_PR_SLOC'
			AND ATTRIBUTE2 LIKE '%'  ||  V_DEPT_ID  ||  '%';

		IF V_DEFAULT_PLANT IS NULL THEN
			SELECT /*__INTO_V_DEFAULT_PLANT__*/ SEGMENT1
				, V_DEFAULT_SLOC = SEGMENT2
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE LOOKUP_TYPE = 'DM_PR_SLOC'
				AND ATTRIBUTE2 IS NULL
			ORDER BY DISPLAY_SEQ;

		END IF;


		-- DETAIL
		SELECT
			ROW_NUMBER() OVER ( ORDER BY B1.TOKEN ) AS ITEM_SEQ
			, V_DEFAULT_PLANT AS STORAGE_PLANT_ID
			-- [C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
			, FN_CHAR_TO_DATE(B8.TOKEN) AS YYYYMMDD
			, P_PROJECT_CODE AS PROJECT_CODE
			, B1.TOKEN AS ITEM_ID
			, C.ITEM_NAME, C.ITEM_UOM
			, CASE WHEN p_POPUP_TYPE = 'ADD_HISTORY' THEN '' ELSE B2.TOKEN END AS QTY
			, B3.TOKEN AS DOM_EXP, B4.TOKEN AS FCST_TYPE
			, B5.TOKEN AS INCOTERMS, B6.TOKEN AS PLANT_SITE_ID
			, B7.TOKEN AS SCM_SITE_ID
			, V_DEFAULT_SLOC AS SLOC
			, '' AS ITEM_DETAIL
			, SYSDATE AS CREATION_DATE
		FROM UF_FX_String_Split(p_ITEM_ID, '^') B1
		LEFT OUTER JOIN UF_FX_String_Split(P_PLAN_QTY			, '^') B2  ON B1.NR = B2.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_DOM_EXP			, '^') B3  ON B1.NR = B3.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_FCST_TYPE			, '^') B4  ON B1.NR = B4.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_INCOTERMS				, '^') B5  ON B1.NR = B5.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PLANT_SITE_ID			, '^') B6  ON B1.NR = B6.NR
		LEFT OUTER JOIN UF_FX_String_Split(P_SCM_SITE_ID			, '^') B7  ON B1.NR = B7.NR
		-- [C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
		LEFT OUTER JOIN UF_FX_String_Split(p_YYYYMMDD				, '^') B8  ON B1.NR = B8.NR
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B1.TOKEN = C.ITEM_ID AND C.DIVISION_ID = P_DIVISION_ID
		WHERE NVL(B1.TOKEN, NULL) IS NOT NULL



		-- HEADER
		SELECT NULL AS REQUEST_NO
			, FN_GET_DIVISION_NAME(P_DIVISION_ID) AS DIVISION_NAME
			, V_PUCH_MGR AS PUCH_MGR
			, V_PUCH_GROUP AS PUCH_GROUP
			--, p_CREATED_BY AS REQUESTED_BY
			, v_USER_NAME AS REQUESTED_BY
			, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS REQUEST_DATE
			, '' AS PR_HEADER

	END IF;

END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_PR_HISTORY_POPUP
(
	p_POPUP_TYPE		VARCHAR2,
    p_division_id		VARCHAR2,
	p_REQUEST_NO		VARCHAR2,
    p_PROJECT_CODE		VARCHAR2,
    p_SCM_SITE_ID		VARCHAR2,
    p_ITEM_ID	        VARCHAR2,
	p_DOM_EXP			VARCHAR2,
	p_FCST_TYPE		VARCHAR2,
	p_INCOTERMS		VARCHAR2,
	p_PLANT_SITE_ID	VARCHAR2,
	p_YYYYMMDD			VARCHAR2,
	P_PLAN_QTY			VARCHAR2,
	p_CREATED_BY		VARCHAR2
/*


*/
)
AS


    V_PUCH_MGR VARCHAR2(150 CHAR);
BEGIN

			, V_PUCH_GROUP			VARCHAR2(150 CHAR)
			, V_STORAGE_PLANT_ID	VARCHAR2(60 CHAR)
			, V_ERR_MSG			VARCHAR2(1000 CHAR)
			, v_ERR_CNT			VARCHAR2(10 CHAR)


	-- POPUP_TYPE = View_PR 일 경우 MKT FCST 의 값을 이용해서 REQUEST_NO 를 찾아준다.
	IF ( p_POPUP_TYPE = 'View_HISTORY') THEN

		-- MKT FCST UI 에서 받은 값을 이용해서 REQUEST NO 들을 찾는다.
		/* TODO:GTT:GT_DMF0_-->GT_DMF0_ */
		INSERT INTO GT_DMF0_
		SELECT DIVISION_ID, REQUEST_NO, ITEM_SEQ
		FROM DM_PLN_PR_DETAIL A
		WHERE DIVISION_ID = P_DIVISION_ID
			AND PROJECT_CODE	= P_PROJECT_CODE
			AND SCM_SITE_ID		= P_SCM_SITE_ID
			AND ITEM_ID			= P_ITEM_ID
			AND DOM_EXP			= P_DOM_EXP
			AND FCST_TYPE		= P_FCST_TYPE
			AND INCOTERMS		= P_INCOTERMS
			AND NVL(PLANT_SITE_ID, NULL)	= NVL(P_PLANT_SITE_ID, NULL)
			AND YYYYMMDD		= P_YYYYMMDD;

		IF NOT EXISTS ( SELECT * FROM GT_DMF0_ ) THEN
			SELECT 'HISTORY가 존재하지 않습니다.' AS ERR_MSG
		END IF;

		-- DETAIL
		SELECT B.REQUEST_NO, B.CREATION_DATE as REQUEST_DATE
			, SCM_ARR_SPL_VAL(B.CREATED_BY, '^', 1) AS REQUESTED_BY
			, B.PLAN_QTY as ITEM_QTY, B.PR_ITEM_DETAIL as ITEM_DETAIL
			, B.PR_HEADER, B.PROJECT_CODE, B.ITEM_ID, C.ITEM_NAME, B.YYYYMMDD
		FROM GT_DMF0_ A
		JOIN DM_PLN_PR_DETAIL B ON A.REQUEST_NO = B.REQUEST_NO AND A.ITEM_SEQ = B.ITEM_SEQ AND A.DIVISION_ID = B.DIVISION_ID
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B.ITEM_ID = C.ITEM_ID AND B.DIVISION_ID = C.DIVISION_ID
		ORDER BY A.REQUEST_NO DESC;


		-- HEADER
		SELECTB.PR_HEADER, B.PROJECT_CODE, B.ITEM_ID, C.ITEM_NAME, B.YYYYMMDD
		FROM GT_DMF0_ A
		JOIN DM_PLN_PR_DETAIL B ON A.REQUEST_NO = B.REQUEST_NO AND A.ITEM_SEQ = B.ITEM_SEQ AND A.DIVISION_ID = B.DIVISION_ID
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B.ITEM_ID = C.ITEM_ID AND B.DIVISION_ID = C.DIVISION_ID
		ORDER BY A.REQUEST_NO DESC

FETCH FIRST 1 ROWS ONLY
	END IF;


END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL
(
     p_division_id VARCHAR2
	,p_project_code VARCHAR2
	,p_yyyymm VARCHAR2
	,p_cust_fcst_m VARCHAR2
	,p_measure VARCHAR2
	,p_qtycd1 VARCHAR2
	,p_qtycd2 VARCHAR2
	,p_qtycd3 VARCHAR2
	,p_seq VARCHAR2
	,p_qty VARCHAR2
	,p_mkt_fcst_m VARCHAR2
	,p_desc VARCHAR2
	,p_input_limit VARCHAR2
	,p_created_by VARCHAR2
	,p_end_customer VARCHAR2
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:04
 * 파일: dbo.DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL.sql
 * ----------------------------------------
 * ⚠ IF: IF:26  END IF:13  차이:+13
 * ⚠ BEGIN: BEGIN:31  END:30  차이:+1
 * ----------------------------------------
 * BEGIN 위치: L86, L201, L213, L225, L237, L249, L263, L274, L297, L442 ...
 * END;  위치: L209, L221, L233, L245, L257, L271, L283, L310, L464, L527 ...
 * ----------------------------------------
 * 힌트: BEGIN이 3개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_END_CUSTOMER VARCHAR2(4000 CHAR);
    v_PROJECT_CODE VARCHAR2(4000 CHAR);
    v_YYYYMM VARCHAR2(4000 CHAR);
    v_CUST_FCST_M VARCHAR2(4000 CHAR);
    v_CUST_FCST_M_PRE VARCHAR2(4000 CHAR);
    v_MEASURE VARCHAR2(4000 CHAR);
    v_QTYCD1 VARCHAR2(4000 CHAR);
    v_QTYCD2 VARCHAR2(4000 CHAR);
    v_QTYCD3 VARCHAR2(4000 CHAR);
    v_SEQ VARCHAR2(4000 CHAR);
    v_QTY VARCHAR2(4000 CHAR);
    v_MKT_FCST_M VARCHAR2(4000 CHAR);
    v_DESC VARCHAR2(4000 CHAR);
    v_INPUT_LIMIT VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_CREATION_DATE VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATE_DATE VARCHAR2(4000 CHAR);
    v_ITEM_CLASS VARCHAR2(30 CHAR);
    v_PACK_CNT INTEGER := 0;
    v_MODULE_CNT INTEGER := 0;
    v_CELL_CNT INTEGER := 0;
    v_0month_tuesday VARCHAR2(08 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_CNT INTEGER := 0;
    v_CNT_PRE INTEGER := 0;
    -- $$PLSQL_UNIT 제거: $$PLSQL_UNIT 사용 (사내 표준 §11)
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_i INTEGER := 1;
    V_ITEM_CNT INTEGER := 0;
    V_ITEM_ID VARCHAR2(50 CHAR);
BEGIN























	DECLARE v_CELL_PER_PACK NUMERIC(30, 10)
	DECLARE v_CELL_PER_MODULE NUMERIC(30, 10)
	DECLARE v_CELL_PER_CELL NUMERIC(30, 10)
	DECLARE v_TRANSLATOR NUMERIC(30, 10) --환산자
	DECLARE v_REP_ITEM_ID VARCHAR2(30 CHAR) --대표환산자 ITEM_ID
	DECLARE v_REP_TRANSLATOR VARCHAR2(30 CHAR) --대표환산자
	DECLARE v_CUST_FCST_M_CELL NUMERIC(30, 10)
	DECLARE v_P_VALUE_CELL NUMERIC(30, 10)
	DECLARE v_S_VALUE_CELL NUMERIC(30, 10)
	DECLARE v_I_VALUE_CELL NUMERIC(30, 10)
	DECLARE v_V_VALUE_CELL NUMERIC(30, 10)
	DECLARE v_M_VALUE_CELL NUMERIC(30, 10)
	DECLARE v_CP_VALUE_CELL NUMERIC(30, 10)
	DECLARE v_MKT_FCST_M_CELL NUMERIC(30, 10)

	------------------------------------------------------------------------------------------------------환산자 추가
	v_DIVISION_ID := NULL;
	v_END_CUSTOMER := NULL;
	v_PROJECT_CODE := NULL;
	v_YYYYMM := NULL;
	v_CUST_FCST_M := NULL;
	v_CUST_FCST_M_PRE := NULL;
	v_MEASURE := NULL;
	v_QTYCD1 := NULL;
	v_QTYCD2 := NULL;
	v_QTYCD3 := NULL;
	v_SEQ := NULL;
	v_QTY := NULL;
	v_MKT_FCST_M := NULL;
	v_DESC := NULL;
	v_INPUT_LIMIT := NULL;
	v_CREATED_BY := NULL;
	v_CREATION_DATE := NULL;
	v_LAST_UPDATED_BY := NULL;
	v_LAST_UPDATE_DATE := NULL;
	v_ITEM_CLASS := NULL;
	v_PACK_CNT := NULL;
	v_MODULE_CNT := NULL;
	v_CELL_CNT := NULL;
	v_CELL_PER_PACK := NULL;
	v_CELL_PER_MODULE := NULL;
	v_CELL_PER_CELL := NULL;
	v_TRANSLATOR := NULL;
	v_CUST_FCST_M_CELL := NULL;
	v_P_VALUE_CELL := NULL;
	v_S_VALUE_CELL := NULL;
	v_I_VALUE_CELL := NULL;
	v_V_VALUE_CELL := NULL;
	v_M_VALUE_CELL := NULL;
	v_CP_VALUE_CELL := NULL;
	v_MKT_FCST_M_CELL := NULL;



	v_delimiter := '^';











	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;

	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
		,v_log_type
		,n_log_count
		,v_log_message
		,v_description
		,d_event_date;

	-- 테이블중복제거
	-- 임시확인용테이블 중복제거
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_ANL_MKT_PSI';

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_PROJECT_DEPT';

	-- 시작 LOG  (END)
	v_log_message := NULL /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/


	BEGIN TRY
		IF p_division_id IS NULL
			OR p_division_id IS NULL;
		BEGIN
			v_log_type := 'INVALID';

			SELECT 'DIVISION_ID 입력값을 확인하세요.'

			v_description := '필수 입력값을 확인하세요.';

			GOTO err_rtn
		END

		IF p_end_customer IS NULL
			OR p_end_customer IS NULL;
		BEGIN
			v_log_type := 'INVALID';

			SELECT 'END_CUSTOMER 입력값을 확인하세요.'

			v_description := 'End_Customer 입력값을 확인하세요.';

			GOTO err_rtn
		END

		IF p_project_code IS NULL
			OR p_project_code IS NULL;
		BEGIN
			v_log_type := 'INVALID';

			SELECT 'PROJECT_CODE 입력값을 확인하세요.'

			v_description := 'Project 입력값을 확인하세요.';

			GOTO err_rtn
		END

		IF p_yyyymm IS NULL
			OR p_yyyymm IS NULL;
		BEGIN
			v_log_type := 'INVALID';

			SELECT 'YYYYMM 입력값을 확인하세요.'

			v_description := 'YYYYMM 입력값을 확인하세요.';

			GOTO err_rtn
		END

		IF p_measure IS NULL
			OR p_measure IS NULL;
		BEGIN
			v_log_type := 'INVALID';

			SELECT 'MEASURE 입력값을 확인하세요.'

			v_description := 'MEASURE 입력값을 확인하세요.';

			GOTO err_rtn
		END


		IF p_qtycd3 IS NULL
			OR p_qtycd3 IS NULL
			OR LENGTH(p_qtycd3) = 0;
		BEGIN
			v_log_type := 'INVALID';

			SELECT '입력값을 확인하세요.'

			v_description := '입력값을 확인하세요.';

			GOTO err_rtn
		END


		BEGIN
			DELETE
			FROM DM_ANL_MKT_PSI_DETAIL
			WHERE 1 = 1
				AND DIVISION_ID = p_division_id
				AND END_CUSTOMER = p_end_customer
				AND PROJECT_CODE = p_project_code
				AND YYYYMM = p_yyyymm
				AND MEASURE = p_measure;
		END

		--BEGIN
		--	-- 테이블중복제거
		--	--	-- 임시확인용테이블 중복제거
		--	--	SELECT * INTO GT_DMF0_PROJECT_CODE
		--	FROM (SELECT PROJECT_CODE FROM SCM_MST_PROJECT WHERE DIVISION_ID = p_division_id AND PROJECT_NAME = V_project_name) A
		--END
		-- 프로시저 LOOP 길이를 판단
		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_qtycd3, v_delimiter);

		DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_max_loop_cnt)  ||  ' '  ||  '----------------------------------------------------------------------------------------------------------------------------------------------');

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------START
		BEGIN
			/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
			INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
			SELECT *
			FROM DM_MST_ITEM_SINGLE_V
			WHERE DIVISION_ID = p_division_id
				AND ITEM_ID IN (
					SELECT ITEM_ID
					FROM SCM_MST_PROJECT_ITEM
					WHERE PROJECT_CODE = p_project_code
						AND VALID_YN = 'Y'
					)
				AND ITEM_TYPE = 'P';
		END

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')------------------------------END

		-- 환산자 추출 로직 ======================================================================START
		-- 테이블중복제거
		-- 임시확인용테이블 중복제거
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
		DBMS_OUTPUT.PUT_LINE('환산자 추출 START--------------------------------------------------------------------------------------------------------------------------------------');

		-- 신규 로직으로 변경
		--BEGIN
		--	-- 1.프로젝트에 있는 ITEM을 CLASS별로 추출하여 임시테이블(GT_DMF0_ITEM_CLASS_IN_PROJECT)에 저장한다.
		--	SELECT ITEM_ID
		--		,CASE
		--			WHEN INSTR(ITEM_CLASS_NAME, 'Pack') > 0
		--				THEN 'PACK'
		--			WHEN INSTR(ITEM_CLASS_NAME, 'Module') > 0
		--				THEN 'MODULE'
		--			WHEN INSTR(ITEM_CLASS_NAME, 'Cell') > 0
		--				THEN 'CELL'
		--			ELSE ''
		--			END ITEM_CLASS
		--	INTO GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	FROM DM_MST_ITEM_SINGLE_V
		--	WHERE DIVISION_ID = '81'
		--		AND ITEM_ID IN (
		--			SELECT ITEM_ID
		--			FROM SCM_MST_PROJECT_ITEM
		--			WHERE PROJECT_CODE = p_PROJECT_CODE
		--				AND VALID_YN = 'Y'
		--			)
		--		AND ITEM_TYPE = 'P'
		--		AND ACTIVE_FLAG = 'Y'

		--	--SELECT * FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	-- 2. 임시테이블(GT_DMF0_ITEM_CLASS_IN_PROJECT)에서 PACK, MODULE, CELL 별로 수량을 파악한다.
		--	SELECT v_PACK_CNT = COUNT(1)
		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'PACK'
		--	GROUP BY ITEM_CLASS

		--	SELECT v_MODULE_CNT = COUNT(1)
		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'MODULE'
		--	GROUP BY ITEM_CLASS

		--	SELECT v_CELL_CNT = COUNT(1)
		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'CELL'
		--	GROUP BY ITEM_CLASS

		--	PRINT TO_CHAR(v_PACK_CNT) + ' PACK'
		--	PRINT TO_CHAR(v_MODULE_CNT) + ' MODULE'
		--	PRINT TO_CHAR(v_CELL_CNT) + ' CELL'

		--	-- 3. 해당 프로젝트에서(GT_DMF0_ITEM_CLASS_IN_PROJECT)
		--	IF v_PACK_CNT > 0 -- PACK에 수량이 있으면 PACK 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_PACK'

		--		SELECT v_CELL_PER_PACK = CELL_PER_CAR
		--		FROM SCM_MST_SITE_ITEM
		--		WHERE PROJECT_CODE = p_PROJECT_CODE
		--			AND ITEM_ID IN (
		--				SELECT ITEM_ID
		--				FROM DM_MST_ITEM_SINGLE_V
		--				WHERE DIVISION_ID = '81'
		--					AND ITEM_ID IN (
		--						SELECT ITEM_ID
		--						FROM SCM_MST_PROJECT_ITEM
		--						WHERE PROJECT_CODE = p_PROJECT_CODE
		--							AND VALID_YN = 'Y'
		--						)
		--					AND ITEM_TYPE = 'P'
		--					AND ACTIVE_FLAG = 'Y'
		--				)
		--			AND VALID_YN = 'Y'
		--			AND CELL_PER_CAR IS NOT NULL
		--		GROUP BY CELL_PER_CAR

		--		v_TRANSLATOR := v_CELL_PER_PACK;
		--		v_REP_TRANSLATOR := 'PACK'
		--	END
		--	ELSE IF v_PACK_CNT = 0
		--		AND v_MODULE_CNT > 0 -- PACK에 수량이 없고 MODULE에 수량이 있으면 MODULE 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_MODULE'

		--		SELECT v_CELL_PER_MODULE = CELL_PER_MODULE
		--		FROM SCM_MST_SITE_ITEM
		--		WHERE PROJECT_CODE = p_PROJECT_CODE
		--			AND ITEM_ID IN (
		--				SELECT ITEM_ID
		--				FROM DM_MST_ITEM_SINGLE_V
		--				WHERE DIVISION_ID = '81'
		--					AND ITEM_ID IN (
		--						SELECT ITEM_ID
		--						FROM SCM_MST_PROJECT_ITEM
		--						WHERE PROJECT_CODE = p_PROJECT_CODE
		--							AND VALID_YN = 'Y'
		--						)
		--					AND ITEM_TYPE = 'P'
		--					AND ACTIVE_FLAG = 'Y'
		--				)
		--			AND VALID_YN = 'Y'
		--			AND CELL_PER_CAR IS NOT NULL
		--		GROUP BY CELL_PER_MODULE

		--		v_TRANSLATOR := v_CELL_PER_MODULE;
		--		v_REP_TRANSLATOR := 'MODULE'
		--	END
		--	ELSE IF v_PACK_CNT = 0
		--		AND v_MODULE_CNT = 0
		--		AND v_CELL_CNT > 0 -- PACK, MODULE에 수량이 없고 CELL에 수량이 있으면 CELL 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_CELL'

		--		SELECT v_CELL_PER_CELL = 1

		--		v_TRANSLATOR := v_CELL_PER_CELL;
		--		v_REP_TRANSLATOR := 'CELL'
		--	END
		--END
		-- 신규 로직으로 변경

		v_DIVISION_ID := p_division_id;
		v_PROJECT_CODE := p_project_code;

		DBMS_OUTPUT.PUT_LINE(v_DIVISION_ID);
		DBMS_OUTPUT.PUT_LINE(v_PROJECT_CODE);

		BEGIN

			--SELECT AAAA.PROJECT_CODE, AAAA.ITEM_ID, AAAA.BIZ_TYPE FROM(
			SELECT AAAA.ITEM_ID,
    AAAA.BIZ_TYPE
  INTO v_REP_ITEM_ID, v_REP_TRANSLATOR
			FROM(
			SELECT AAA.PROJECT_CODE, AAA.ITEM_ID
			, CASE WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AP' THEN 'PACK' WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AM' THEN 'MODULE' WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AC' THEN 'CELL' END BIZ_TYPE
			,  ROW_NUMBER() OVER (PARTITION BY AAA.PROJECT_CODE ORDER BY AAA.PROJECT_CODE, SUBSTR(AAA.ITEM_ID, 2,1) DESC) AS RNK FROM(
			SELECT AA.PROJECT_CODE, BB.ITEM_ID
			, CASE WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AP' THEN 3 WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AM' THEN 2 WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AC' THEN 1 END RNK FROM
			(SELECT DISTINCT PROJECT_CODE FROM DM_ANL_MKT_PSI_DETAIL WHERE DIVISION_ID = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE) AA INNER JOIN
			(SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID
			FROM SCM_MST_SITE_ITEM A INNER JOIN DM_MST_ITEM_SINGLE_V B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
			WHERE A.DIVISION_ID = v_DIVISION_ID AND A.VALID_YN = 'Y' AND B.ITEM_TYPE = 'P') BB
			ON AA.PROJECT_CODE = BB.PROJECT_CODE
			GROUP BY AA.PROJECT_CODE, BB.ITEM_ID
			) AAA;
			) AAAA WHERE AAAA.RNK = 1
			ORDER BY AAAA.PROJECT_CODE, AAAA.ITEM_ID;

		END

		SELECT v_TRANSLATOR = CELL_CF FROM SCP_MST_FINAL_ITEM WHERE ITEM_ID = v_REP_ITEM_ID

		DBMS_OUTPUT.PUT_LINE(v_TRANSLATOR);

		DBMS_OUTPUT.PUT_LINE('환산자 추출 END--------------------------------------------------------------------------------------------------------------------------------------');

		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		-- 환산자 추출 로직 ========================================================================END


		DBMS_OUTPUT.PUT_LINE('환산자');
		DBMS_OUTPUT.PUT_LINE('환산자 '  ||  v_REP_TRANSLATOR  ||  ' '  ||  TO_CHAR(v_TRANSLATOR));


		WHILE LENGTH(p_qtycd3) > 0
			AND v_mst_loop_cnt < v_max_loop_cnt;
		BEGIN
			-- v_mst_loop_cnt 1증가
			v_mst_loop_cnt := v_mst_loop_cnt || 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				v_DIVISION_ID := p_division_id;
				--SELECT v_DIVISION_ID
				v_END_CUSTOMER := p_end_customer;
				--SELECT v_END_CUSTOMER
				v_PROJECT_CODE := p_project_code;
				--SELECT v_PROJECT_CODE
				v_YYYYMM := p_yyyymm;
				--SELECT v_YYYYMM
				--v_CUST_FCST_M := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter , 1);
				--v_CUST_FCST_M_PRE := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter , 2);
				v_CUST_FCST_M := p_cust_fcst_m;
				--SELECT v_CUST_FCST_M
				v_MEASURE := p_measure;
				--SELECT v_MEASURE
				v_QTYCD1 := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter, v_mst_loop_cnt);
				--SELECT v_QTYCD1
				v_QTYCD2 := SCM_ARR_SPL_VAL(p_qtycd2, v_delimiter, v_mst_loop_cnt);
				--SELECT v_QTYCD2
				v_QTYCD3 := SCM_ARR_SPL_VAL(p_qtycd3, v_delimiter, v_mst_loop_cnt);
				--SELECT v_QTYCD3
				v_SEQ := SCM_ARR_SPL_VAL(p_seq, v_delimiter, v_mst_loop_cnt);
				--SELECT v_SEQ
				v_QTY := SCM_ARR_SPL_VAL(p_qty, v_delimiter, v_mst_loop_cnt);
				--SELECT v_QTY
				v_MKT_FCST_M := p_mkt_fcst_m;
				--SELECT v_MKT_FCST_M
				v_DESC := SCM_ARR_SPL_VAL(p_desc, v_delimiter, v_mst_loop_cnt);
				--SELECT v_DESC
				v_INPUT_LIMIT := p_input_limit;
				--SELECT v_INPUT_LIMIT
				v_CREATED_BY := p_created_by;
				--SELECT v_CREATED_BY
				v_CREATION_DATE := SYSTIMESTAMP;
				--SELECT v_CREATION_DATE
				v_LAST_UPDATED_BY := p_created_by;
				--SELECT v_LAST_UPDATED_BY
				v_LAST_UPDATE_DATE := SYSTIMESTAMP;
					--SELECT v_LAST_UPDATE_DATE
			END

			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
			IF v_DIVISION_ID = ''
				OR v_DIVISION_ID IS NULL;
			BEGIN
				v_log_type := 'INVALID';

				SELECT 'DIVISION_ID 입력값을 확인하세요.'

				v_description := '필수 입력값을 확인하세요.';

				GOTO err_rtn
			END

		IF v_END_CUSTOMER = ''
			OR v_END_CUSTOMER IS NULL;
		BEGIN
			v_log_type := 'INVALID';

			SELECT 'END_CUSTOMER 입력값을 확인하세요.'

			v_description := 'End_Customer 입력값을 확인하세요.';

			GOTO err_rtn
		END

			IF v_PROJECT_CODE = ''
				OR v_PROJECT_CODE IS NULL;
			BEGIN
				v_log_type := 'INVALID';

				SELECT 'PROJECT_CODE 입력값을 확인하세요.'

				v_description := 'Div 입력값을 확인하세요.';

				GOTO err_rtn
			END

			IF v_YYYYMM = ''
				OR v_YYYYMM IS NULL;
			BEGIN
				v_log_type := 'INVALID';

				SELECT 'YYYYMM 입력값을 확인하세요.'

				v_description := 'YYYYMM 입력값을 확인하세요.';

				GOTO err_rtn
			END



			/* =================================================
		   주석유지
		    =================================================*/
			/*
			IF v_CUST_FCST_M = '' OR v_CUST_FCST_M IS NULL
				BEGIN
					v_log_type := 'INVALID';
					SELECT 'Sold-To 입력값을 확인하세요.'
					v_description := 'Sold-To 입력값을 확인하세요.';
					goto err_rtn
				*/
			/* =================================================*/
			--IF SCM_ARR_SPL_CNT(p_cust_fcst_m, v_delimiter) = 2
			--	BEGIN
			--		v_CUST_FCST_M_PRE := SCM_ARR_SPL_VAL(p_cust_fcst_m, v_delimiter , 1);
			--		v_CUST_FCST_M := SCM_ARR_SPL_VAL(p_cust_fcst_m, v_delimiter , 2);
			--	END
			-- 테이블중복제거
			-- 임시확인용테이블 중복제거
			EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION'
					FROM DUAL;

			--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
			IF v_MEASURE = 'DP_INIT' THEN
				IF DATEPART(WEEKDAY, SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01') = '4' THEN
					v_0month_tuesday := TO_CHAR(/* TODO:(FN_NEXT_DAY(TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6) + (- 1) * 7 + '01', 'YYYYMMDD'), 'TUE')) */, 'YYYYMMDD');
				ELSE
					v_0month_tuesday := TO_CHAR(1 || (/* TODO:DATEDIFF(WK,0,(v_yyyymm  ||  '01') + (5 - DATEPART(DAY, v_yyyymm + '01') */)))*7v_yyyymm  ||  '01' + (5 - DATEPART(DAY, v_yyyymm  ||  '01'))), 1), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
			ELSIF DATEPART(WEEKDAY, SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01') = '4' THEN
				v_0month_tuesday := TO_CHAR(/* TODO:(FN_NEXT_DAY(DATEADD(MM, 1, TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6) + (- 1) * 7 + '01', 'YYYYMMDD')), 'TUE')) */ADD_MONTHS(TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01', 'YYYYMMDD'), 1), 'TUE')), 'YYYYMMDD');
			ELSE
				v_0month_tuesday := TO_CHAR(1 || (/* TODO:DATEDIFF(WK,0,DATEADD(DD, 5 - DATEPART(DAY, ADD_MONTHS(v_yyyymm + '01', 1) */), ADD_MONTHS(v_yyyymm  ||  '01', 1))))*7DATEADD(MM, 1, v_yyyymm  ||  '01') || (5 - DATEPART(DAY, ADD_MONTHS(v_yyyymm  ||  '01', 1)))ADD_MONTHS(v_yyyymm  ||  '01', 1)), ADD_MONTHS(v_yyyymm  ||  '01', 1))), 1), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
			END IF;

			BEGIN
				INSERT INTO GT_DMF0_DM_MST_VERSION (;
					NUM
					,VERSION_NO
					,VERSION_TYPE
					)
				SELECT ROW_NUMBER() OVER (
						ORDER BY X.VERSION_NO
						) AS NUM
					,X.VERSION_NO
					,X.VERSION_TYPE
				FROM (
					SELECT ROW_NUMBER() OVER (
							PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC
							) AS RNK
						,A.VERSION_NO
						,A.VERSION_TYPE
					FROM DM_MST_VERSION A
					JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE 1 = 1
						AND A.DIVISION_ID = p_division_id
						AND A.VERSION_TYPE = 'MF_W' --MKT_FCST Weekly Cutoff
						AND A.YYYYMMDD = v_0month_tuesday
					) X;
				WHERE RNK = 1;
			END;

			--SCM_MST_SITE 대상건만 추출(end_customer)
		    BEGIN
			    /* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
			    INSERT INTO GT_DMF0_SCM_MST_SITE
			    SELECT DIVISION_ID
			         , SCM_SITE_ID
			    	 , END_CUSTOMER
		    	FROM SCM_MST_SITE
		    	WHERE DIVISION_ID  = p_division_id
	              AND END_CUSTOMER = p_end_customer;
	    	END;


			--IF v_CUST_FCST_M_PRE = '' OR v_CUST_FCST_M_PRE IS NULL OR v_CUST_FCST_M_PRE = '0'
			--	BEGIN
			--		SELECT v_CUST_FCST_M_PRE = (A_QTY + B_QTY)
			--		FROM (
			--					SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
			--					FROM DM_PLN_MKT_FCST_C X
			--					JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
			--					WHERE 1=1
			--					AND X.DIVISION_ID = p_division_id
			--					AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
			--					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
			--					AND PROJECT_CODE = p_project_code
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
			--					AND X.FCST_TYPE = 'MPS'
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND SUBSTR(YYYYMMDD, 1, 6) = v_yyyymm
			--					AND QTY <> 0
			--					) A,
			--					(
			--					SELECT NVL(CEILING(SUM(QTY)), 0) AS B_QTY
			--					FROM DM_PLN_MKT_FCST_RESULT_C X
			--					JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
			--					WHERE 1=1
			--					AND X.DIVISION_ID = p_division_id
			--					AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
			--					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
			--					AND PROJECT_CODE = p_project_code
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
			--					AND X.FCST_TYPE = 'MPS'
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND SUBSTR(YYYYMMDD, 1, 6) = v_yyyymm
			--					) B
			--	END
			IF v_CUST_FCST_M = ''
				OR v_CUST_FCST_M IS NULL
				OR v_CUST_FCST_M = '0' THEN
				IF v_MEASURE = 'DP_INIT' THEN
					SELECT (A_QTY  ||  B_QTY)
  INTO v_CUST_FCST_M
					FROM (
						SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
						FROM DM_PLN_MKT_FCST_C X
						JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
						JOIN GT_DMF0_SCM_MST_SITE Z
						  	ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
						WHERE 1 = 1
							AND X.DIVISION_ID = p_division_id
							AND X.MEASURE IN (;
								'CUST_FCST_EDI'
								,'CUST_FCST'
								)
							--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
							AND X.PROJECT_CODE = p_project_code
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND X.ITEM_ID IN (
								SELECT ITEM_ID
								FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
								)
							AND X.FCST_TYPE = 'MPS'
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND SUBSTR(X.YYYYMMDD, 1, 6) = v_yyyymm
							AND X.QTY <> 0
						) A;
						,(
							SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
							FROM DM_PLN_MKT_FCST_RESULT_C X
							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
						    JOIN GT_DMF0_SCM_MST_SITE Z
							     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE 1 = 1
								AND X.DIVISION_ID = p_division_id
								AND X.MEASURE IN (;
									'CUST_FCST_EDI'
									,'CUST_FCST'
									)
								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
								AND X.PROJECT_CODE = p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND X.ITEM_ID IN (
									SELECT ITEM_ID
									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTR(X.YYYYMMDD, 1, 6) = v_yyyymm
							) B;
				ELSE
					SELECT v_CUST_FCST_M = (A_QTY  ||  B_QTY)
					FROM (
						SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
						FROM DM_PLN_MKT_FCST_C X
						JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
					    JOIN GT_DMF0_SCM_MST_SITE Z
						     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
						WHERE 1 = 1
							AND X.DIVISION_ID = p_division_id
							AND X.MEASURE IN (;
								'CUST_FCST_EDI'
								,'CUST_FCST'
								)
							--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
							AND X.PROJECT_CODE = p_project_code
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND X.ITEM_ID IN (
								SELECT ITEM_ID
								FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
								)
							AND X.FCST_TYPE = 'MPS'
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
							AND X.QTY <> 0
						) A;
						,(
							SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
							FROM DM_PLN_MKT_FCST_RESULT_C X
							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
						    JOIN GT_DMF0_SCM_MST_SITE Z
							     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE 1 = 1
								AND X.DIVISION_ID = p_division_id
								AND X.MEASURE IN (;
									'CUST_FCST_EDI'
									,'CUST_FCST'
									)
								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
								AND X.PROJECT_CODE = p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND X.ITEM_ID IN (
									SELECT ITEM_ID
									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
							) B;
				END IF;

			IF v_MEASURE = ''
				OR v_MEASURE IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'MEASURE 입력값을 확인하세요.'

				v_description := 'MEASURE 입력값을 확인하세요.';

				GOTO err_rtn
			END IF;

			IF v_QTYCD1 = ''
				OR v_QTYCD1 IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'QTYCD1 입력값을 확인하세요.'

				v_description := 'QTYCD1 입력값을 확인하세요.';

				GOTO err_rtn
			END IF;

			IF v_QTYCD2 = ''
				OR v_QTYCD2 IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'QTYCD2 입력값을 확인하세요.'

				v_description := 'QTYCD2 입력값을 확인하세요.';

				GOTO err_rtn
			END IF;

			IF v_QTYCD3 = ''
				OR v_QTYCD3 IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'QTYCD3 입력값을 확인하세요.'

				v_description := 'QTYCD3 입력값을 확인하세요.';

				GOTO err_rtn
			END IF;

			IF v_SEQ = ''
				OR v_SEQ IS NULL THEN
				SELECT MAX(SEQ) || 1
  INTO v_SEQ
				FROM DM_ANL_MKT_PSI_DETAIL
				WHERE DIVISION_ID = v_DIVISION_ID
					AND END_CUSTOMER = p_end_customer
					AND PROJECT_CODE = v_PROJECT_CODE
					AND YYYYMM = v_YYYYMM
					--AND CUST_FCST_M = v_CUST_FCST_M
					AND MEASURE = v_MEASURE
					AND QTYCD1 = v_QTYCD1
					AND QTYCD2 = v_QTYCD2
					AND QTYCD3 = v_QTYCD3;
			END IF;

			DBMS_OUTPUT.PUT_LINE('INSERT INTO 1------------------------------------------------------------------------------------------------------------------------------------------------------------');

			IF v_mst_loop_cnt > 0 THEN
				INSERT INTO DM_ANL_MKT_PSI_DETAIL (;
					DIVISION_ID
					,END_CUSTOMER
					,PROJECT_CODE
					,YYYYMM
					,CUST_FCST_M
					,MEASURE
					,QTYCD1
					,QTYCD2
					,QTYCD3
					,SEQ
					,QTY
					,MKT_FCST_M
					,DESC
					,INPUT_LIMIT
					,CUST_FCST_M_CELL
					,QTY_CELL
					,MKT_FCST_M_CELL
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					)
				SELECT v_DIVISION_ID
					,v_END_CUSTOMER
					,v_PROJECT_CODE
					,v_YYYYMM
					,v_CUST_FCST_M AS CUST_FCST_M
					--, CASE WHEN v_MEASURE = 'DP_INIT' THEN v_CUST_FCST_M
					--       WHEN v_MEASURE = 'DP_RESULT' THEN v_CUST_FCST_M_PRE END AS CUST_FCST_M
					,v_MEASURE
					,v_QTYCD1
					,v_QTYCD2
					,v_QTYCD3
					,v_SEQ
					,NVL(v_QTY, 0)
					,NVL(v_MKT_FCST_M, 0)
					,v_DESC
					,v_INPUT_LIMIT
					,TO_NUMBER(NVL(v_CUST_FCST_M, 0)) * v_TRANSLATOR AS CUST_FCST_M_CELL
					--, CASE WHEN v_MEASURE = 'DP_INIT' THEN TO_NUMBER(NVL(v_CUST_FCST_M, 0)) * v_TRANSLATOR
					--       WHEN v_MEASURE = 'DP_RESULT' THEN TO_NUMBER(NVL(v_CUST_FCST_M_PRE, 0)) * v_TRANSLATOR END AS CUST_FCST_M_CELL
					,TO_NUMBER(NVL(v_QTY, 0)) * v_TRANSLATOR AS QTY_CELL
					,NVL(v_MKT_FCST_M, 0) * v_TRANSLATOR AS MKT_FCST_M_CELL
					,v_CREATED_BY
					,SYSTIMESTAMP
					,v_LAST_UPDATED_BY
					,SYSTIMESTAMP
			END IF;
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		--RESULT등록시 신규월 EDI 수량
		BEGIN
			SELECT (A_QTY  ||  B_QTY)
  INTO v_CUST_FCST_M_PRE
			FROM (
				SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
				FROM DM_PLN_MKT_FCST_C X
				JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
			    JOIN GT_DMF0_SCM_MST_SITE Z
				     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
				WHERE 1 = 1
					AND X.DIVISION_ID = p_division_id
					AND X.MEASURE IN (;
						'CUST_FCST_EDI'
						,'CUST_FCST'
						)
					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
					AND X.PROJECT_CODE = p_project_code
					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
					AND X.ITEM_ID IN (
						SELECT ITEM_ID
						FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
						)
					AND X.FCST_TYPE = 'MPS'
					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
					AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
					AND QTY <> 0
				) A;
				,(
					SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
					FROM DM_PLN_MKT_FCST_RESULT_C X
					JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
				    JOIN GT_DMF0_SCM_MST_SITE Z
					     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
					WHERE 1 = 1
						AND X.DIVISION_ID = p_division_id
						AND X.MEASURE IN (;
							'CUST_FCST_EDI'
							,'CUST_FCST'
							)
						--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
						AND X.PROJECT_CODE = p_project_code
						--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
						AND X.ITEM_ID IN (
							SELECT ITEM_ID
							FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
							)
						AND X.FCST_TYPE = 'MPS'
						--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
						AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
					) B;
		END;
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		-- MASTER 테이블(DM_ANL_MKT_PSI) 데이터 입력
		BEGIN
			IF v_MEASURE = 'DP_INIT' THEN
				DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-0------------------------------------------------------------------------------------------------------------------------------------------------------------');
				DBMS_OUTPUT.PUT_LINE(v_DIVISION_ID  ||  ' /// '  ||  v_PROJECT_CODE  ||  ' /// '  ||  v_YYYYMM  ||  ' /// '  ||  v_MEASURE);

				SELECT COUNT(*)
  INTO v_CNT
				FROM DM_ANL_MKT_PSI
				WHERE 1 = 1
					AND DIVISION_ID = v_DIVISION_ID
					AND END_CUSTOMER = v_END_CUSTOMER
					AND PROJECT_CODE = v_PROJECT_CODE
					AND YYYYMM = v_YYYYMM
					AND MEASURE = v_MEASURE;

				DBMS_OUTPUT.PUT_LINE(v_CNT);

				IF v_CNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-1[수요계획(1ST) 존재]------------------------------------------------------------------------------------------------------------------------------------------');

					BEGIN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM
							AND MEASURE IN (v_MEASURE);
					END;

					BEGIN
						INSERT INTO GT_DMF0_DM_ANL_MKT_PSI (;
							DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,P_VALUE
							,S_VALUE
							,I_VALUE
							,V_VALUE
							,M_VALUE
							,MKT_FCST_M
							,CUST_FCST_M_CELL
							,P_VALUE_CELL
							,S_VALUE_CELL
							,I_VALUE_CELL
							,V_VALUE_CELL
							,M_VALUE_CELL
							,MKT_FCST_M_CELL
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,CP_VALUE
							,CP_VALUE_CELL
							)
						SELECT T1.DIVISION_ID
							,T1.END_CUSTOMER
							,T1.PROJECT_CODE
							,T1.YYYYMM
							,T1.CUST_FCST_M
							,T1.MEASURE
							,NVL(CEILING(T1.P_VALUE), 0)
							,NVL(CEILING(T1.S_VALUE), 0)
							,NVL(CEILING(T1.I_VALUE), 0)
							,NVL(CEILING(T1.V_VALUE), 0)
							,NVL(CEILING(T1.M_VALUE), 0)
							,NVL(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE)  ||  CEILING(T1.S_VALUE)  ||  CEILING(T1.I_VALUE)  ||  CEILING(T1.V_VALUE)  ||  CEILING(T1.M_VALUE)  ||  CEILING(T1.CP_VALUE))), 0) AS MKT_FCST_M
							,NVL(CEILING(T1.CUST_FCST_M * v_TRANSLATOR), 0) AS CUST_FCST_M_CELL
							,NVL(CEILING(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALUE_CELL
							,NVL(CEILING(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALUE_CELL
							,NVL(CEILING(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALUE_CELL
							,NVL(CEILING(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALUE_CELL
							,NVL(CEILING(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALUE_CELL
							,NVL(CEILING(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE)  ||  CEILING(T1.S_VALUE)  ||  CEILING(T1.I_VALUE)  ||  CEILING(T1.V_VALUE)  ||  CEILING(T1.M_VALUE)  ||  CEILING(T1.CP_VALUE))) * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,NVL(CEILING(T1.CP_VALUE), 0)
							,NVL(CEILING(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALUE_CELL
						FROM (
							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
								,SUM(PRODUCT) AS P_VALUE
								,SUM(SALES) AS S_VALUE
								,SUM(INVENTORY) AS I_VALUE
								,SUM(VPA) AS V_VALUE
								,SUM(MODELMIX) AS M_VALUE
								,SUM(SUPPLYISSUE) AS CP_VALUE
							FROM DM_ANL_MKT_PSI_DETAIL;
							PIVOT(SUM(QTY) FOR QTYCD3 IN (
										PRODUCT
										,SALES
										,INVENTORY
										,VPA
										,MODELMIX
										,SUPPLYISSUE
										)) AS PVT
							WHERE 1 = 1
								AND DIVISION_ID = v_DIVISION_ID
								AND END_CUSTOMER = v_END_CUSTOMER
								AND PROJECT_CODE = v_PROJECT_CODE
								AND YYYYMM = v_YYYYMM
								AND MEASURE = v_MEASURE
							GROUP BY DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
							) T1;

						SELECT '1'
							,*
						FROM GT_DMF0_DM_ANL_MKT_PSI;
					END;
				ELSE  -- 수요계획(1st)가 존재하지 않을 시 INSERT ALL(해당월 첫 등록 시 나머지 MEASURE DEFAULT 값 처리)
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-1[수요계획(1ST) 미존재]----------------------------------------------------------------------------------------------------------------------------------------');

					BEGIN -- 수요계획(1ST)가 없으면 나머지 MEASURE 데이터도 의미가 없으므로 삭제
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM;
					END;

					BEGIN
						INSERT INTO GT_DMF0_DM_ANL_MKT_PSI (;
							DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,P_VALUE
							,S_VALUE
							,I_VALUE
							,V_VALUE
							,M_VALUE
							,MKT_FCST_M
							,CUST_FCST_M_CELL
							,P_VALUE_CELL
							,S_VALUE_CELL
							,I_VALUE_CELL
							,V_VALUE_CELL
							,M_VALUE_CELL
							,MKT_FCST_M_CELL
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,CP_VALUE
							,CP_VALUE_CELL
							)
						--AN_LOGIC
						SELECT v_DIVISION_ID
							,v_END_CUSTOMER
							,v_PROJECT_CODE
							,v_YYYYMM
							,CEILING(v_CUST_FCST_M) --CUST_FCST_M
							,'AN_LOGIC'
							,0 --P_VALUE
							,0 --S_VALUE
							,0 --I_VALUE
							,0 --V_VALUE
							,0 --M_VALUE
							,0 --MKT_FCST_M
							,0 --CUST_FCST_M_CELL
							,0 --P_VALUE_CELL
							,0 --S_VALUE_CELL
							,0 --I_VALUE_CELL
							,0 --V_VALUE_CELL
							,0 --M_VALUE_CELL
							,0 --MKT_FCST_M_CELL
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,0 --CP_VALUE
							,0 --CP_VALUE_CELL
							--AN_RESULT[분석로직(%)*고객수요계획]

						UNION ALL

						SELECT v_DIVISION_ID
							,v_END_CUSTOMER
							,v_PROJECT_CODE
							,v_YYYYMM
							,CEILING(v_CUST_FCST_M)
							,'AN_RESULT'
							,0 --P_VALUE
							,0 --S_VALUE
							,0 --I_VALUE
							,0 --V_VALUE
							,0 --M_VALUE
							,0 --MKT_FCST_M
							,0 --CUST_FCST_M_CELL
							,0 --P_VALUE_CELL
							,0 --S_VALUE_CELL
							,0 --I_VALUE_CELL
							,0 --V_VALUE_CELL
							,0 --M_VALUE_CELL
							,0 --MKT_FCST_M_CELL
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,0 --CP_VALUE
							,0 --CP_VALUE_CELL

						UNION ALL

						--DP_INIT
						SELECT T1.DIVISION_ID
							,T1.END_CUSTOMER
							,T1.PROJECT_CODE
							,T1.YYYYMM
							,T1.CUST_FCST_M
							,T1.MEASURE
							,NVL(CEILING(T1.P_VALUE), 0)
							,NVL(CEILING(T1.S_VALUE), 0)
							,NVL(CEILING(T1.I_VALUE), 0)
							,NVL(CEILING(T1.V_VALUE), 0)
							,NVL(CEILING(T1.M_VALUE), 0)
							,NVL(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE)  ||  CEILING(T1.S_VALUE)  ||  CEILING(T1.I_VALUE)  ||  CEILING(T1.V_VALUE)  ||  CEILING(T1.M_VALUE)  ||  CEILING(T1.CP_VALUE))), 0) AS MKT_FCST_M
							,NVL(CEILING(T1.CUST_FCST_M * v_TRANSLATOR), 0) AS CUST_FCST_M_CELL
							,NVL(CEILING(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALUE_CELL
							,NVL(CEILING(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALUE_CELL
							,NVL(CEILING(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALUE_CELL
							,NVL(CEILING(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALUE_CELL
							,NVL(CEILING(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALUE_CELL
							,NVL(CEILING(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE)  ||  CEILING(T1.S_VALUE)  ||  CEILING(T1.I_VALUE)  ||  CEILING(T1.V_VALUE)  ||  CEILING(T1.M_VALUE)  ||  CEILING(T1.CP_VALUE))) * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,NVL(CEILING(T1.CP_VALUE), 0)
							,NVL(CEILING(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALUE_CELL
						FROM (
							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,SUM(PRODUCT) AS P_VALUE
								,SUM(SALES) AS S_VALUE
								,SUM(INVENTORY) AS I_VALUE
								,SUM(VPA) AS V_VALUE
								,SUM(MODELMIX) AS M_VALUE
								,SUM(SUPPLYISSUE) AS CP_VALUE
							FROM DM_ANL_MKT_PSI_DETAIL;
							PIVOT(SUM(QTY) FOR QTYCD3 IN (
										PRODUCT
										,SALES
										,INVENTORY
										,VPA
										,MODELMIX
										,SUPPLYISSUE
										)) AS PVT
							WHERE 1 = 1
								AND DIVISION_ID = v_DIVISION_ID
								AND END_CUSTOMER = v_END_CUSTOMER
								AND PROJECT_CODE = v_PROJECT_CODE
								AND YYYYMM = v_YYYYMM
								AND MEASURE = v_MEASURE
							GROUP BY DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
							) T1;

						UNION ALL

						-- DP_RESULT
						SELECT v_DIVISION_ID
							,v_END_CUSTOMER
							,v_PROJECT_CODE
							,v_YYYYMM
							,CEILING(v_CUST_FCST_M)
							,'DP_RESULT'
							,0 --P_VALUE
							,0 --S_VALUE
							,0 --I_VALUE
							,0 --V_VALUE
							,0 --M_VALUE
							,0 --MKT_FCST_M
							,0 --CUST_FCST_M_CELL
							,0 --P_VALUE_CELL
							,0 --S_VALUE_CELL
							,0 --I_VALUE_CELL
							,0 --V_VALUE_CELL
							,0 --M_VALUE_CELL
							,0 --MKT_FCST_M_CELL
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,0 --CP_VALUE
							,0 --CP_VALUE_CELL
					END;
				END IF;
						--SELECT '2', * FROM GT_DMF0_DM_ANL_MKT_PSI
			ELSE  -- 수요계획(Result) 저장
				-- 수요계획(Result) 다음달 데이터 등록여부확인(다음달 데이터 첫등록여부 확인을 위함)
				SELECT COUNT(*)
  INTO v_CNT
				FROM DM_ANL_MKT_PSI
				WHERE 1 = 1
					AND DIVISION_ID = v_DIVISION_ID
					AND END_CUSTOMER = v_END_CUSTOMER
					AND PROJECT_CODE = v_PROJECT_CODE
					--AND YYYYMM = v_YYYYMM
					AND YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
					AND MEASURE = v_MEASURE

				-- 수요계획(Result) 당월 분석로직/분석결과/DPINIT이 존재하지않을 시
				SELECT v_CNT_PRE = COUNT(*)
				FROM DM_ANL_MKT_PSI
				WHERE 1 = 1
					AND DIVISION_ID = v_DIVISION_ID
					AND END_CUSTOMER = v_END_CUSTOMER
					AND PROJECT_CODE = v_PROJECT_CODE
					AND YYYYMM = v_YYYYMM;

				IF v_CNT_PRE = 0 THEN
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3[수요계획(Result) 저장, 당월 분석로직/분석결과/DPINIT 미존재]----------------------------------------------------------------------------------------------------');

					--AN_LOGIC
					INSERT INTO DM_ANL_MKT_PSI (;
						DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						,YYYYMM
						,CUST_FCST_M
						,MEASURE
						,P_VALUE
						,S_VALUE
						,I_VALUE
						,V_VALUE
						,M_VALUE
						,MKT_FCST_M
						,CUST_FCST_M_CELL
						,P_VALUE_CELL
						,S_VALUE_CELL
						,I_VALUE_CELL
						,V_VALUE_CELL
						,M_VALUE_CELL
						,MKT_FCST_M_CELL
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,CP_VALUE
						,CP_VALUE_CELL
						)
					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,v_YYYYMM
						,CEILING(v_CUST_FCST_M)
						,'AN_LOGIC'
						,0 --P_VALUE
						,0 --S_VALUE
						,0 --I_VALUE
						,0 --V_VALUE
						,0 --M_VALUE
						,0 --MKT_FCST_M
						,0 --CUST_FCST_M_CELL
						,0 --P_VALUE_CELL
						,0 --S_VALUE_CELL
						,0 --I_VALUE_CELL
						,0 --V_VALUE_CELL
						,0 --M_VALUE_CELL
						,0 --MKT_FCST_M_CELL
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL
					--AN_RESULT[분석로직(%)*고객수요계획]

					UNION ALL

					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,v_YYYYMM
						,CEILING(v_CUST_FCST_M)
						,'AN_RESULT'
						,0 --P_VALUE
						,0 --S_VALUE
						,0 --I_VALUE
						,0 --V_VALUE
						,0 --M_VALUE
						,0 --MKT_FCST_M
						,0 --CUST_FCST_M_CELL
						,0 --P_VALUE_CELL
						,0 --S_VALUE_CELL
						,0 --I_VALUE_CELL
						,0 --V_VALUE_CELL
						,0 --M_VALUE_CELL
						,0 --MKT_FCST_M_CELL
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL
					-- DP_INIT

					UNION ALL

					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,v_YYYYMM
						,CEILING(v_CUST_FCST_M)
						,'DP_INIT'
						,0 --P_VALUE
						,0 --S_VALUE
						,0 --I_VALUE
						,0 --V_VALUE
						,0 --M_VALUE
						,CEILING(v_MKT_FCST_M) --MKT_FCST_M
						,0 --CUST_FCST_M_CELL
						,0 --P_VALUE_CELL
						,0 --S_VALUE_CELL
						,0 --I_VALUE_CELL
						,0 --V_VALUE_CELL
						,0 --M_VALUE_CELL
						,0 --MKT_FCST_M_CELL
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL
					FROM DUAL;
				END IF;

				BEGIN -- 분석로직 임시테이블 저장(BEGIN~END)
					-- 테이블중복제거
					-- 임시확인용테이블 중복제거
					EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_AN_LOGIC';

					-- 해당월의 다음달 데이터 분석로직 데이터 저장
					INSERT INTO GT_DMF0_AN_LOGIC (;
						DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						,YYYYMM
						,CUST_FCST_M
						,MEASURE
						,P_VALUE
						,S_VALUE
						,I_VALUE
						,V_VALUE
						,M_VALUE
						,MKT_FCST_M
						,CUST_FCST_M_CELL
						,P_VALUE_CELL
						,S_VALUE_CELL
						,I_VALUE_CELL
						,V_VALUE_CELL
						,M_VALUE_CELL
						,MKT_FCST_M_CELL
						,CP_VALUE
						,CP_VALUE_CELL
						)
					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
						,CEILING(v_CUST_FCST_M)
						,'AN_LOGIC'
						,NVL(CEILING(B.P_QTY / A.EDI_QTY), 0) AS P_QTY
						,NVL(CEILING(B.S_QTY / A.EDI_QTY), 0) AS S_QTY
						,NVL(CEILING(B.I_QTY / A.EDI_QTY), 0) AS I_QTY
						,NVL(CEILING(B.V_QTY / A.EDI_QTY), 0) AS V_QTY
						,NVL(CEILING(B.M_QTY / A.EDI_QTY), 0) AS M_QTY
						,0
						,CEILING(v_CUST_FCST_M * v_TRANSLATOR) AS CUST_FCST_M_CELL
						,NVL(CEILING(B.P_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS P_VALUE_CELL
						,NVL(CEILING(B.S_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS S_VALUE_CELL
						,NVL(CEILING(B.I_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS I_VALUE_CELL
						,NVL(CEILING(B.V_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS V_VALUE_CELL
						,NVL(CEILING(B.M_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS M_VALUE_CELL
						,0 AS MKT_FCST_M_CELL
						,NVL(CEILING(B.CP_QTY / A.EDI_QTY), 0) AS CP_QTY
						,NVL(CEILING(B.CP_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS CP_VALUE_CELL
					FROM (
						SELECT SUM(QTY) AS EDI_QTY
						FROM DM_PLN_MKT_FCST
						WHERE DIVISION_ID = v_DIVISION_ID
							AND PROJECT_CODE = v_PROJECT_CODE
							AND MEASURE IN (;
								'CUST_FCST'
								,'CUST_FCST_EDI'
								)
							AND YYYYMMDD >= (TO_CHAR(ADD_MONTHS(SYSDATE, (- 1)*12), 'YYYYMMDD') || '01')
							AND YYYYMMDD <= TO_CHAR(EOMONTH(SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)  ||  '01'), 'YYYYMMDD')
						) A;
						,(
							SELECT SUM(P_VALUE) AS P_QTY
								,SUM(S_VALUE) AS S_QTY
								,SUM(I_VALUE) AS I_QTY
								,SUM(V_VALUE) AS V_QTY
								,SUM(M_VALUE) AS M_QTY
								,SUM(CP_VALUE) AS CP_QTY
							FROM DM_ANL_MKT_PSI
							WHERE DIVISION_ID = v_DIVISION_ID
								AND END_CUSTOMER = v_END_CUSTOMER
								AND PROJECT_CODE = v_PROJECT_CODE
								AND MEASURE = 'DP_RESULT'
								AND YYYYMM >= SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, (- 1)*12), 'YYYYMMDD'), 1, 6)
								AND YYYYMM <= SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
							) B;
				END;

				IF v_CNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3-1[수요계획(Result) 저장, 수요계획(Result)가 존재시 DPINIT 만 나머지 삭제]----------------------------------------------------------------------------------------');

					-- 분석로직, 분석결과는 해당월의 다음달 데이터 삭제, 수요계획(Result)는 해당월 데이터 삭제
					BEGIN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
							AND MEASURE IN (;
								'AN_LOGIC'
								,'AN_RESULT'
								)

						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM
							AND MEASURE = 'DP_RESULT';
					END;

					-- DM_ANL_MKT_PSI 데이터 저장
					BEGIN
						INSERT INTO GT_DMF0_DM_ANL_MKT_PSI (;
							DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,P_VALUE
							,S_VALUE
							,I_VALUE
							,V_VALUE
							,M_VALUE
							,MKT_FCST_M
							,CUST_FCST_M_CELL
							,P_VALUE_CELL
							,S_VALUE_CELL
							,I_VALUE_CELL
							,V_VALUE_CELL
							,M_VALUE_CELL
							,MKT_FCST_M_CELL
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,CP_VALUE
							,CP_VALUE_CELL
							)
						--AN_LOGIC
						SELECT DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,v_CUST_FCST_M_PRE
							,MEASURE
							,NVL(P_VALUE, 0)
							,NVL(S_VALUE, 0)
							,NVL(I_VALUE, 0)
							,NVL(V_VALUE, 0)
							,NVL(M_VALUE, 0)
							,NVL(MKT_FCST_M, 0)
							,NVL(CUST_FCST_M_CELL, 0)
							,NVL(P_VALUE_CELL, 0)
							,NVL(S_VALUE_CELL, 0)
							,NVL(I_VALUE_CELL, 0)
							,NVL(V_VALUE_CELL, 0)
							,NVL(M_VALUE_CELL, 0)
							,NVL(MKT_FCST_M_CELL, 0)
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,NVL(CP_VALUE, 0)
							,NVL(CP_VALUE_CELL, 0)
						FROM GT_DMF0_AN_LOGIC
						--AN_RESULT[분석로직(%)*고객수요계획]

						UNION ALL

						SELECT DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,v_CUST_FCST_M_PRE
							,'AN_RESULT'
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) - (CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100))), 0)
							,CUST_FCST_M_CELL
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) - (CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100))), 0)
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100), 0)
							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100), 0)
						FROM GT_DMF0_AN_LOGIC
						-- DP_RESULT

						UNION ALL

						SELECT T1.DIVISION_ID
							,T1.END_CUSTOMER
							,T1.PROJECT_CODE
							,T1.YYYYMM
							,T1.CUST_FCST_M
							,T1.MEASURE
							,NVL(CEILING(T1.P_VALUE), 0)
							,NVL(CEILING(T1.S_VALUE), 0)
							,NVL(CEILING(T1.I_VALUE), 0)
							,NVL(CEILING(T1.V_VALUE), 0)
							,NVL(CEILING(T1.M_VALUE), 0)
							,NVL(CEILING(T1.MKT_FCST_M), 0) AS MKT_FCST_M
							,T1.CUST_FCST_M * v_TRANSLATOR AS CUST_FCST_M_CELL
							,NVL(CEILING(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALU_CELL
							,NVL(CEILING(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALU_CELL
							,NVL(CEILING(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALU_CELL
							,NVL(CEILING(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALU_CELL
							,NVL(CEILING(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALU_CELL
							,NVL(CEILING(T1.MKT_FCST_M * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,NVL(CEILING(T1.CP_VALUE), 0)
							,NVL(CEILING(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALU_CELL
						FROM (
							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
								,SUM(PRODUCT) AS P_VALUE
								,SUM(SALES) AS S_VALUE
								,SUM(INVENTORY) AS I_VALUE
								,SUM(VPA) AS V_VALUE
								,SUM(MODELMIX) AS M_VALUE
								,SUM(SUPPLYISSUE) AS CP_VALUE
							FROM DM_ANL_MKT_PSI_DETAIL;
							PIVOT(SUM(QTY) FOR QTYCD3 IN (
										PRODUCT
										,SALES
										,INVENTORY
										,VPA
										,MODELMIX
										,SUPPLYISSUE
										)) AS PVT
							WHERE 1 = 1
								AND DIVISION_ID = v_DIVISION_ID
								AND END_CUSTOMER = v_END_CUSTOMER
								AND PROJECT_CODE = v_PROJECT_CODE
								AND YYYYMM = v_YYYYMM
								AND MEASURE = v_MEASURE
							GROUP BY DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
							) T1;
					END;

					SELECT '3'
						,*
					FROM GT_DMF0_DM_ANL_MKT_PSI;
				ELSE  -- 수요계획(Result)가 존재하지 않을 시 INSERT ALL(해당월의 다음달 첫 등록 시 나머지 MEASURE DEFAULT 값 처리)
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3-1[수요계획(Result) 미존재]----------------------------------------------------------------------------------------');

					IF v_CNT_PRE > 0 THEN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM
							AND MEASURE = 'DP_RESULT';
					END IF;

					INSERT INTO GT_DMF0_DM_ANL_MKT_PSI (;
						DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						,YYYYMM
						,CUST_FCST_M
						,MEASURE
						,P_VALUE
						,S_VALUE
						,I_VALUE
						,V_VALUE
						,M_VALUE
						,MKT_FCST_M
						,CUST_FCST_M_CELL
						,P_VALUE_CELL
						,S_VALUE_CELL
						,I_VALUE_CELL
						,V_VALUE_CELL
						,M_VALUE_CELL
						,MKT_FCST_M_CELL
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,CP_VALUE
						,CP_VALUE_CELL
						)
					--AN_LOGIC
					SELECT DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						--, YYYYMM
						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
						,CEILING(v_CUST_FCST_M_PRE)
						,MEASURE
						,NVL(P_VALUE, 0)
						,NVL(S_VALUE, 0)
						,NVL(I_VALUE, 0)
						,NVL(V_VALUE, 0)
						,NVL(M_VALUE, 0)
						,NVL(MKT_FCST_M, 0)
						,CUST_FCST_M_CELL
						,NVL(P_VALUE_CELL, 0)
						,NVL(S_VALUE_CELL, 0)
						,NVL(I_VALUE_CELL, 0)
						,NVL(V_VALUE_CELL, 0)
						,NVL(M_VALUE_CELL, 0)
						,NVL(MKT_FCST_M_CELL, 0)
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,NVL(CP_VALUE, 0)
						,NVL(CP_VALUE_CELL, 0)
					FROM GT_DMF0_AN_LOGIC
					--AN_RESULT[분석로직(%)*고객수요계획]

					UNION ALL

					SELECT DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						--, YYYYMM
						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
						,CEILING(v_CUST_FCST_M_PRE)
						,'AN_RESULT'
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) - (CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100))), 0)
						,CUST_FCST_M_CELL
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) - (CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100))), 0)
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100), 0)
						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100), 0)
					FROM GT_DMF0_AN_LOGIC

					UNION ALL

					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
						,CEILING(v_CUST_FCST_M_PRE)
						,'DP_INIT'
						,0
						,0
						,0
						,0
						,0
						,CEILING(v_MKT_FCST_M)
						,CEILING(v_CUST_FCST_M_CELL)
						,0
						,0
						,0
						,0
						,0
						,CEILING(v_MKT_FCST_M_CELL)
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,0
						,0

					UNION ALL

					SELECT T1.DIVISION_ID
						,T1.END_CUSTOMER
						,T1.PROJECT_CODE
						,T1.YYYYMM
						,T1.CUST_FCST_M
						,T1.MEASURE
						,NVL(CEILING(T1.P_VALUE), 0)
						,NVL(CEILING(T1.S_VALUE), 0)
						,NVL(CEILING(T1.I_VALUE), 0)
						,NVL(CEILING(T1.V_VALUE), 0)
						,NVL(CEILING(T1.M_VALUE), 0)
						,NVL(CEILING(T1.MKT_FCST_M), 0) AS MKT_FCST_M
						,T1.CUST_FCST_M * v_TRANSLATOR AS CUST_FCST_M_CELL
						,NVL(CEILING(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALU_CELL
						,NVL(CEILING(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALU_CELL
						,NVL(CEILING(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALU_CELL
						,NVL(CEILING(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALU_CELL
						,NVL(CEILING(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALU_CELL
						,NVL(CEILING(T1.MKT_FCST_M * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,NVL(CEILING(T1.CP_VALUE), 0)
						,NVL(CEILING(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALU_CELL
					FROM (
						SELECT DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,MKT_FCST_M
							,SUM(PRODUCT) AS P_VALUE
							,SUM(SALES) AS S_VALUE
							,SUM(INVENTORY) AS I_VALUE
							,SUM(VPA) AS V_VALUE
							,SUM(MODELMIX) AS M_VALUE
							,SUM(SUPPLYISSUE) AS CP_VALUE
						FROM DM_ANL_MKT_PSI_DETAIL;
						PIVOT(SUM(QTY) FOR QTYCD3 IN (
									PRODUCT
									,SALES
									,INVENTORY
									,VPA
									,MODELMIX
									,SUPPLYISSUE
									)) AS PVT
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM
							AND MEASURE = v_MEASURE
						GROUP BY DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,MKT_FCST_M
						) T1;

					UNION ALL

					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
						,CEILING(v_CUST_FCST_M_PRE)
						,'DP_RESULT'
						,0
						,0
						,0
						,0
						,0
						,0
						,CEILING(v_CUST_FCST_M_CELL) AS CUST_FCST_M_CELL
						,0 AS P_VALU_CELL
						,0 AS S_VALU_CELL
						,0 AS I_VALU_CELL
						,0 AS V_VALU_CELL
						,0 AS M_VALU_CELL
						,0 AS MKT_FCST_M_CELL
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,0
						,0 AS CP_VALU_CELL

					SELECT '4'
						,*
					FROM GT_DMF0_DM_ANL_MKT_PSI;
				END IF;
		END;
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		BEGIN -- 본 테이블 INSERT INTO SELECT '5'
				,*
			FROM GT_DMF0_DM_ANL_MKT_PSI;

			INSERT INTO DM_ANL_MKT_PSI (;
				DIVISION_ID
				,END_CUSTOMER
				,PROJECT_CODE
				,YYYYMM
				,CUST_FCST_M
				,MEASURE
				,P_VALUE
				,S_VALUE
				,I_VALUE
				,V_VALUE
				,M_VALUE
				,MKT_FCST_M
				,DESC
				,INPUT_LIMIT
				,CUST_FCST_M_CELL
				,P_VALUE_CELL
				,S_VALUE_CELL
				,I_VALUE_CELL
				,V_VALUE_CELL
				,M_VALUE_CELL
				,MKT_FCST_M_CELL
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,CP_VALUE
				,CP_VALUE_CELL
				)
			SELECT DIVISION_ID
				,END_CUSTOMER
				,PROJECT_CODE
				,YYYYMM
				,CUST_FCST_M
				,MEASURE
				,TO_NUMBER(P_VALUE)
				,TO_NUMBER(S_VALUE)
				,TO_NUMBER(I_VALUE)
				,TO_NUMBER(V_VALUE)
				,TO_NUMBER(M_VALUE)
				,TO_NUMBER(MKT_FCST_M)
				,DESC
				,INPUT_LIMIT
				,TO_NUMBER(CUST_FCST_M_CELL)
				,TO_NUMBER(P_VALUE_CELL)
				,TO_NUMBER(S_VALUE_CELL)
				,TO_NUMBER(I_VALUE_CELL)
				,TO_NUMBER(V_VALUE_CELL)
				,TO_NUMBER(M_VALUE_CELL)
				,TO_NUMBER(MKT_FCST_M_CELL)
				,CREATED_BY
				,SYSDATE
				,LAST_UPDATED_BY
				,SYSDATE
				,TO_NUMBER(CP_VALUE)
				,TO_NUMBER(CP_VALUE_CELL)
			FROM GT_DMF0_DM_ANL_MKT_PSI;
		END;
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);


		/*
		2024.01.10    kcw3408        PR_DM_ANL_MKT_PSI_DATA:고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송 배치 작업 신규로  I/F 테이블 INSERT INTO 삭제함
		*/
		/*
		BEGIN -- I/F 테이블 INSERT
			--SELECT '6', * FROM GT_DMF0_DM_ANL_MKT_PSI
			--**중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)
			BEGIN -- I/F 테이블 해당 PROJECT 삭제
				DELETE
				FROM LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DW_S
				WHERE DIVISION_ID = v_Division_id
					AND END_CUSTOMER = p_end_customer
					AND PROJECT_CODE = p_project_code;
			END

			INSERT INTO LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DW_S (;
				DIVISION_ID
				,END_CUSTOMER
				,PROJECT_CODE
				,YYYYMM
				,CUST_FCST_M
				,MEASURE
				,P_VALUE
				,S_VALUE
				,I_VALUE
				,V_VALUE
				,M_VALUE
				,MKT_FCST_M
				,DESC
				,INPUT_LIMIT
				,CUST_FCST_M_CELL
				,P_VALUE_CELL
				,S_VALUE_CELL
				,I_VALUE_CELL
				,V_VALUE_CELL
				,M_VALUE_CELL
				,MKT_FCST_M_CELL
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,CP_VALUE
				,CP_VALUE_CELL
				)
			SELECT DIVISION_ID
				,END_CUSTOMER
				,PROJECT_CODE
				,YYYYMM
				,CUST_FCST_M
				,MEASURE
				,TO_NUMBER(P_VALUE)
				,TO_NUMBER(S_VALUE)
				,TO_NUMBER(I_VALUE)
				,TO_NUMBER(V_VALUE)
				,TO_NUMBER(M_VALUE)
				,TO_NUMBER(MKT_FCST_M)
				,DESC
				,INPUT_LIMIT
				,TO_NUMBER(CUST_FCST_M_CELL)
				,TO_NUMBER(P_VALUE_CELL)
				,TO_NUMBER(S_VALUE_CELL)
				,TO_NUMBER(I_VALUE_CELL)
				,TO_NUMBER(V_VALUE_CELL)
				,TO_NUMBER(M_VALUE_CELL)
				,TO_NUMBER(MKT_FCST_M_CELL)
				,CREATED_BY
				,SYSDATE
				,LAST_UPDATED_BY
				,SYSDATE
				,TO_NUMBER(CP_VALUE)
				,TO_NUMBER(CP_VALUE_CELL)
			FROM DM_ANL_MKT_PSI
			WHERE DIVISION_ID = v_Division_id
				AND PROJECT_CODE = p_project_code
				AND END_CUSTOMER = p_end_customer;
		END

		-- 프로젝트 OWNERSHIP으로 DEPT_ID 정보 추출 START
			BEGIN
				INSERT INTO GT_DMF0_PROJECT_DEPT
				SELECT PRJ.DIVISION_ID,PRJ.PROJECT_CODE, PRJ.PROJECT_NAME, DEPT.DEPT_ID, DEPT.DEPT_NAME_KO FROM SCM_MST_PROJECT PRJ INNER JOIN
				(
				SELECT A.USER_ID, A.USER_NAME, A.USER_NAME_EN, A.DEPT_ID, B.DEPT_NAME_KO
					FROM SCM_MST_SSO_USER_INFO A
						INNER JOIN SCM_MST_SSO_DEPT_INFO B
							ON A.DEPT_ID = B.DEPT_ID
				) DEPT ON DEPT.USER_ID = PRJ.PROJECT_OWNER
			END


		-- 프로젝트 OWNERSHIP으로 DEPT_ID 정보 추출 END

		/* TODO:GTT:GT_DMF0_ITEM_ID-->GT_DMF0_ITEM_ID */
		INSERT INTO GT_DMF0_ITEM_ID
		SELECT ROW_NUMBER() OVER(ORDER BY A.ITEM_ID) SEQ, A.ITEM_ID
		FROM
		(SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V GROUP BY ITEM_ID) A




		SELECT COUNT(*)
  INTO V_ITEM_CNT
		FROM GT_DMF0_ITEM_ID;

		--SELECT * FROM GT_DMF0_ITEM_ID

		BEGIN -- I/F 테이블 INSERT
			--SELECT '6', * FROM GT_DMF0_DM_ANL_MKT_PSI
			--**중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)
			BEGIN -- I/F 테이블 해당 PROJECT 삭제
				DELETE
				FROM LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DETAIL_DW_S
				WHERE DIVISION_ID = v_Division_id
					AND PROJECT_CODE = p_project_code
					AND END_CUSTOMER = p_end_customer;
			END

			WHILE v_i <= V_ITEM_CNT
			BEGIN
				SELECT V_ITEM_ID = ITEM_ID FROM GT_DMF0_ITEM_ID WHERE SEQ = v_i
				INSERT INTO LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DETAIL_DW_S (;
							DIVISION_ID
							,DEPT_ID
							,DEPT_NAME_KO
							,PROJECT_NAME
							,PROJECT_CODE
							,ITEM_ID --,SCM_SITE_ID
							,END_CUSTOMER
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,QTYCD1
							,QTYCD2
							,QTYCD3
							,SEQ
							,QTY
							,MKT_FCST_M
							,DESC
							,INPUT_LIMIT
							,CUST_FCST_M_CELL
							,QTY_CELL
							,MKT_FCST_M_CELL
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE

					)
				SELECT
					 A.DIVISION_ID
					,B.DEPT_ID
					,B.DEPT_NAME_KO
					,B.PROJECT_NAME
					,A.PROJECT_CODE
					,V_ITEM_ID AS ITEM_ID
					,A.END_CUSTOMER
					,A.YYYYMM
					,A.CUST_FCST_M
					,A.MEASURE
					,A.QTYCD1
					,A.QTYCD2
					,A.QTYCD3
					,A.SEQ
					,A.QTY
					,A.MKT_FCST_M
					,A.DESC
					,A.INPUT_LIMIT
					,A.CUST_FCST_M * v_TRANSLATOR -- A.CUST_FCST_M_CELL
					,A.QTY * v_TRANSLATOR --A.QTY_CELL
					,A.MKT_FCST_M * v_TRANSLATOR --A.MKT_FCST_M_CELL
					,A.CREATED_BY
					,SYSDATE
					, p_created_by --,A.LAST_UPDATED_BY
					,SYSDATE

				FROM DM_ANL_MKT_PSI_DETAIL A
				INNER JOIN GT_DMF0_PROJECT_DEPT B	ON A.DIVISION_ID = B.DIVISION_ID  AND A.PROJECT_CODE = B.PROJECT_CODE
				WHERE A.DIVISION_ID = v_Division_id
					AND A.PROJECT_CODE = p_project_code
					AND A.END_CUSTOMER = p_end_customer;

				v_i := v_i || 1;
			END
		*/

		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		--DMF0003_GET_DM_ANL_MKT_PSI_DATA v_DIVISION_ID, v_PROJECT_CODE, v_YYYYMM, v_CREATED_BY;
		COMMIT;
	-- END TRY

	EXCEPTION
	    WHEN OTHERS THEN

		-- ERROR LOG
		v_log_type := 'ERROR';
		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
		v_description := 'ERROR_LINE : '  ||  STR(NULL);
		d_event_date := SYSTIMESTAMP;

		PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
			,v_log_type
			,n_log_count
			,v_log_message
			,v_description
			,d_event_date;

		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;
	-- END CATCH

	-- 종료 LOG
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;

	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
		,v_log_type
		,n_log_count
		,v_log_message
		,v_description
		,d_event_date;
        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
END;

-- 트랜잭션 (END)
err_rtn:

IF v_log_type = 'INVALID' THEN
	SELECT v_description


	v_log_message := '########## END of procedure ##########';
	d_event_date := SYSTIMESTAMP;

	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
		,v_log_type
		,n_log_count
		,v_log_message
		,v_description
		,d_event_date;


	-- 종료 LOG
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;

	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
		,v_log_type
		,n_log_count
		,v_log_message
		,v_description
		,d_event_date;
END IF;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_SAVE_MKT_FCST
    -- Add the parameters for the stored procedure here
      ( P_ACTIVE_FLAG      IN  VARCHAR2
      , P_DIVISION_ID      IN  VARCHAR2
      , P_PROJECT_CODE     IN  VARCHAR2
      , P_SCM_SITE_ID      IN  VARCHAR2
      , P_ITEM_ID          IN  VARCHAR2
      , P_DOM_EXP          IN  VARCHAR2
      , P_FCST_TYPE        IN  VARCHAR2
      , P_INCOTERMS        IN  VARCHAR2
      , P_MEASURE          IN  VARCHAR2
      , P_PLANT_SITE_ID    IN  VARCHAR2
      , P_YYYYMMDD         IN  VARCHAR2
      , P_QTY              IN  VARCHAR2
      , P_CREATED_BY       IN  VARCHAR2
      , P_AS_FROM_SITE     IN  VARCHAR2
      , P_BUCKET           IN  VARCHAR2  --[E20250313-001251]_화면의 bucket 정보 받음
      , O_RC1              OUT SYS_REFCURSOR
      , O_RESULT_CURSOR    OUT SYS_REFCURSOR
      )
/*============================================================================================================================
 * Program ID  : [DMF0003_SAVE_MKT_FCST]
 * Description : MKT FCST 저장, 수정, 삭제
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=============================================================================================================================
 * Date        In Charge    Description
 *=============================================================================================================================
 * 2018.03.27	KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31				insert시 테이블 컬럼지정
 * 2018.06.11				MKT_FCST_QTY_BALANCE_CREATE 로직 추가
 * 2018.06.14	KHSONG		상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (임시로직으로 차후삭제필요)
 * 2018.06.18	KHSONG		40 DIVISION 조건 추가
 * 2018.06.27	KHSONG		MKT_FCST 소형 SAVE시 VMI재고 확인후 RTF 생성 로직 개발
 * 2018.07.03	KHSONG		SCM_MST_SITE테이블의 VMI대상조건 추가
 * 2018.07.03	KHSONG		1. 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함.
 *							BOM 이 없다고 Alert을 띄우고 ROLLBACK시킴.
 *							2. 저장하려는 SITE의 4주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함.
 *							SITE SHIP-TO가 없다고 Alert을 띄우고 ROLLBACK시킴.
 * ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
 * 2018.07.10	SKH			속도개선 수정 버전
 * ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
 * 2018.07.13   KHSONG		VMI_In_Plan 조건 추가, 당주월요일 초재고 VMI_Inv 값은 SCM_DNM_STOCK_V 에서 산출
 * 2018.07.17   KHSONG		속도개선 커서제거 로직으로 수정 (VMI재고 확인후 RTF 생성 로직)
 * 2018.07.20   KHSONG		ACTIVE_FLAG 조건추가
 * 2018.07.25   ytchoi		vmi stock qty 를 초재고로 적용
 * 2018.07.30   KHSONG		대상 Row 수가 20건 이하일 때만 수행하도록 처리
 * 2018.07.31   KHSONG		balance등 저장속도개선
 * 2018.08.06   KHSONG		2018년 10월 scp오픈전까지 vmi값이 존재하지않아 주석처리함 (ui에서 vmi RTF를 수동으로 입력가능하도록함)
 * 2018.08.10-1 KHSONG		소형은 BOM Validation 에서 제외
 * 2018.08.10-3 KHSONG		소형은 SHIP-TO Validation 에서 제외
 * 2018.08.10-2 KHSONG		소형은 BALANCE_CREATE 에서 제외 (임시)
 * 2018.08.13   KHSONG		당주 월요일이후 데이터만 대상으로 하도록 로직보완
 * 2018.08.13   ytchoi		상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직은 Div:40 소형은 제외로직 추가
 * 2018.08.16   KHSONG		DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출
 * 2018.08.16   KHSONG		Unit Price가 없는 MKT_FCST validation
 * 2018.09.14-1 KHSONG		(20180810-1 KHSONG 소형은 BOM Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
 * 2018.09.14-2 KHSONG		(20180810-3 KHSONG 소형은 SHIP-TO Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
 * 2018.09.14				소형도 FROM_SITE 조건에 추가
 * 2018.09.17	KHSONG		fcst_type LOOKUP참조하여 출력으로 변경
 * 2018.10.02	KHSONG		BALANCE CREATE 프로시져 호출로직으로 변경
 * 2018.10.05	khsong		공백제거로직추가
 * 2018.10.11	khsong		Price가 없는 case Validation 에서 제외
 * 2018.10.12				BLOCK Model
 * 2018.10.16	KHSONG		SALES_PLAN_ADJUST_YN = ''인대상에 대해서는 Price Validation 에서 제외
 * 2018.11.07	KHSONG		소형 반품예정수량(RMA) fcst_type 조건추가
 * 2018.11.08				RMA FCST_TYPE 이외의 MEASURE 정수값 validation
 * 2018.11.21	KHSONG		MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
 * 2019.01.15	KHSONG		SALES_TYPE_CODE 'ASF' 신규 추가 (ESS측 요청사항)
 * 2019.01.18	KHSONG		ESS인경우 ITEM INSERT 후 Unit Price validation을 위해 위치변경
 * 2019.06.14	KHSONG		김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
 * 2019.07.08	KHSONG		김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
 * 2019.07.09	KHSONG		[CSR ID:4034895]  GSCM RTF[system] Measure 관련 요청건
 * 2020.03.04	KHSONG		날짜선택 오류수정
 * 2020.05.07	KHSONG		C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.05.22	P.C.I		[C20200525-000296] (81 사업부) MKT Fcst 입력 시 Unit Price 체크 기준에 Plant Site 조건 추가
 * 2020.05.29	KHSONG		[C20200424-000010] (Sales Price 필수 입력 구간 관련의 건)
 * 2020.06.08	P.C.I		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
 * 2020.06.15	P.C.I		[C20200615-000238] [ESS사업부] Sales Company/Plant 저장시 기준정보 재생성 로직 삭제
 * 2020.07.07	hwi1993		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화 -- 제품일경우에만 적용
 * 2020.07.09	P.C.I		[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가
 * 2020.07.16	hwi1993		[C20200713-000189] [VMI-in Req] 에 의해 자동계산된 mkt fcst 는 무시하고, 다시 자동계산해서 insert 함.
 * 2020.07.20	P.C.I		[C20200717-000157] ESS 사업부 Sales Site Project Model validation 추가
 * 2020.07.29	P.C.I		[C20200707-000149] 자동차- 환산정보 Validation에 제품(P), 반제품(H), 원재료(R), 상품(Q) 모두 포함
 * 2020.08.31	hwi1993		[C20200812-000104] [시스템 변경요청]  Active = '' 인 Model 도 조회되도록 변경( 미래구간 에만 적용 )
 *                           --> 그에따라 MKT FCST 에서 저장시 ACTIVE = '' 이면 저장 안되도록 변경
 * 2020.09.02	P.C.I		[C20200819-000105] VMI-In Request 입력시 Sales Price 필수 입력 Validation 추가
 * 2020.09.02	P.C.I		[C20200814-000183] RMA 수요의 MKT FCST 입력 제약 조건 제외
 * 2020.10.15	hwi1993		[C20201015-000200] VMi 원복 (원본은 C20200713-000189 ). 원복하기로 해서 프로시저는 삭제하지 않고, Agent 에서만 제거함.
 * 2020.11.03	P.C.I		[C20201103-000114] [ESS사업부] VMI In Req 자동화
 * 2020.11.27	hwi1993		[C20201103-000114] [ESS사업부] VMI In Req 자동화 - 수정버전
 * 2020.12.18	hwi1993		[C20201217-000126] ESS 판매법인 VMI inventory 수신 프로세스 수정 - MKT FCST ->VMI Req 변환기간을 52주에서 62주로 변경
 * 2020.12.22	kuni		[C20201211-000353] SALES PRICE 팝업 창 문구 변경 : Start  ~ End date
 * 2021.01.01	HWI1993		[C20200804-000123] SSP 동기화 수량보다 작은 수량으로 수정 불가 ( 소형 & MKT FCST 메저 )
 * 2021.01.14	HWI1993		[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( 초록색도 수정가능하도록 변경 )
 * 2021.02.03	KUNI		[C20210203-000427] Sales Price가 없는 MKT FCST DATA
 * 2021.02.26	P.C.I 		[C20210225-000385] 동기화, Carry Over 된 CONFIRM_ID 추가, 동기화 수량보다 작은 수량은 입력 불가(원복)
 * 2021.02.26	P.C.I 		[C20210420-000162] #RESULTS Table v_attribute4, v_attribute4 사이즈 변경
 * 2021.04.20	hwi1993		[PJ20209642R] PR Request 가 완료된 건은 수정되지 않도록 함. - 수정전 버전은 김영휘에게 문의
 * 2021.08.06	hwi1993		중장기과제 -- 특정 기간동안은 2022년 데이터 수정할 수 없도록
 * 2021.08.11	hwi1993		[C20210811-000230] NET DEMAND 생성 구간 확장
 * 2021.08.18	HWI1993		[C20210817-000420] Net Demand 구간 확장 로직 수정
 * 2021.09.29	hwi1993		[PJ20209643] AS 프로세스
 * 2021.09.29	hwi1993		[PJ20209643] AS 프로세스, SALES SITE 가 AS PLANT 일 경우 INCOTERMS 를 제한함.
 * 2021.12.15	HWI1993		[PJ20209643] AS 프로세스 - AS PLANT 향은 FROM SITE 를 넣지 않도록 변경
 * 2021.12.20	hwi1993		속도개선 버전
 * 2022.01.13	hwi1993		2차 속도개선 버전
 * 2022.01.20	HWI1993		3차 속도개선 및 로그프로시저 변경
 * 2022.01.22	HWI1993		[22년 하반기 과제] PRICE 자동화 진행 중 PRICE 유효성체크 로직이 필요한 기간보다 하루 더 들어가있어서 수정함
 * 2022.03.04	rosia27		[C20220224-000160]DM_LONG_PLAN 기능 고도화 요청의 건
 * 2022.03.30	kdw2819     [C20220328-000205] MKT FCST 입력, 저장 간 오류 확인 요청
 * 2022.04.07	rosia27		[과제PJ20216891R]GM_JV
 * 2022.04.27	hwi1993		C20220428-000211 자동차 VMI Biz 로직 수정 요청의 건 - 자동차 사업부 vmi 는 mkt fcst 메저를 사용하는 관계로 관련 로직 수정
 * 2022.07.15	rosia27		[C20220713-000194][영업마케팅PI P]GSCM DM 시스템의 각 모델별 Cell,Module,Pack 환산자 누락오류 방안 검토
 * 2022.07.27	rosia27		[C20220722-000367][영업마케팅PI]등급품(-K)자재 MKT FCST 입력 요청의 건
 * 2023.06.08	chano0612   [E20230608-000891]MKT FCST, Sales Plan 동일 Measure 실시간 연동건
 * 2023.07.18	CHANO0612   [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선
 * 2023.11.25	HMIN        [E20231020-001565] GSCM 현장설치품 DP입력 시스템/프로세스 개선 요청의 건
 * 2024.02.05	KJJ			MKT FCST 수정시 PR_DETAIL_AUTO 수량도 업데이트 (가장 마지막 줄에 DMF0070_SAVE_QTY_PR_DETAIL_AUTO 호출)
 * 2024.12.11	JSSBAE		[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
 * 2025.03.26	JSSBAE		[E20250313-001251]_MKT FCST화면 Period 관련 조회입력 기능 개선
 * 2025.05.21   KANG.H.J	[PJ2025-50188] CELL_PROD_SITE_ID 추가 - RTF_BALANCE 계산시 40 사업부와 통일 필요
 * 2025.07.07	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.21	JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2025.08.26	JSSBAE		[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 * 2025.10.02	JSSBAE		[E20250919-001699]_Incoterms 데이터 처리 VALID 처리
 * 2026.02.20	JSSBAE		[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
 * 2026.04.06   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                              SCM_MST_SITE_ITEM Table Column 삭제에 따른 반영
 *                              #mshychu1 → T_STR_TAB TYPE 사용 (SEGMENT2 단일 컬럼, 1000건 이내, DML 없음)
 *                              #mshychu2 → T_STR_TAB TYPE 사용
 *                              #ess_price_except_model → T_STR_TAB TYPE 사용
 *============================================================================================================================*/
AS
    -- 내부 변수
    V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
    V_DIVISION_ID           VARCHAR2(4000 CHAR);
    V_PROJECT_CODE          VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
    V_ITEM_ID               VARCHAR2(4000 CHAR);
    V_DOM_EXP               VARCHAR2(4000 CHAR);
    V_FCST_TYPE             VARCHAR2(4000 CHAR);
    V_INCOTERMS             VARCHAR2(4000 CHAR);
    V_MEASURE               VARCHAR2(4000 CHAR);
    V_PLANT_SITE_ID         VARCHAR2(4000 CHAR);
    V_YYYYMMDD              VARCHAR2(4000 CHAR);
    V_QTY                   VARCHAR2(4000 CHAR);
    V_CREATED_BY            VARCHAR2(4000 CHAR);
    V_AS_FROM_SITE          VARCHAR2(4000 CHAR);
    V_AS_FROM_PLANT         VARCHAR2(4000 CHAR);
    V_MAX_INV_DAYS          PLS_INTEGER;         -- [C20210817-000420]
    PLAN_START_YYYYMMDD     VARCHAR2(4000 CHAR); -- 20180611 KHSONG ADDED
    V_BUCKET                VARCHAR2(4000 CHAR); -- [E20250313-001251]_화면의 bucket 정보 받음

    -- 작업용 복사본 파라미터 (IN 파라미터 직접 조작 불가이므로 로컬 복사)
    LP_ACTIVE_FLAG          VARCHAR2(32767 CHAR);
    LP_DIVISION_ID          VARCHAR2(32767 CHAR);
    LP_PROJECT_CODE         VARCHAR2(32767 CHAR);
    LP_SCM_SITE_ID          VARCHAR2(32767 CHAR);
    LP_ITEM_ID              VARCHAR2(32767 CHAR);
    LP_DOM_EXP              VARCHAR2(32767 CHAR);
    LP_FCST_TYPE            VARCHAR2(32767 CHAR);
    LP_INCOTERMS            VARCHAR2(32767 CHAR);
    LP_MEASURE              VARCHAR2(32767 CHAR);
    LP_PLANT_SITE_ID        VARCHAR2(32767 CHAR);
    LP_YYYYMMDD             VARCHAR2(32767 CHAR);
    LP_QTY                  VARCHAR2(32767 CHAR);
    LP_CREATED_BY           VARCHAR2(32767 CHAR);
    LP_AS_FROM_SITE         VARCHAR2(32767 CHAR);

    -- 인덱스 변수
    N_INDEX_ACTIVE_FLAG     PLS_INTEGER;
    N_INDEX_DIVISION_ID     PLS_INTEGER;
    N_INDEX_PROJECT_CODE    PLS_INTEGER;
    N_INDEX_SCM_SITE_ID     PLS_INTEGER;
    N_INDEX_ITEM_ID         PLS_INTEGER;
    N_INDEX_DOM_EXP         PLS_INTEGER;
    N_INDEX_FCST_TYPE       PLS_INTEGER;
    N_INDEX_INCOTERMS       PLS_INTEGER;
    N_INDEX_MEASURE         PLS_INTEGER;
    N_INDEX_PLANT_SITE_ID   PLS_INTEGER;
    N_INDEX_YYYYMMDD        PLS_INTEGER;
    N_INDEX_QTY             PLS_INTEGER;
    N_INDEX_CREATED_BY      PLS_INTEGER;
    N_INDEX_AS_FROM_SITE    PLS_INTEGER; -- [E20260211-001189]

    READ_CNT                PLS_INTEGER := 0;
    READ_1000_CNT           PLS_INTEGER := 0;

    -- LOG 용 변수
    $$PLSQL_UNIT          VARCHAR2(150 CHAR);
    V_LOG_TYPE              VARCHAR2(30 CHAR);
    N_LOG_COUNT             NUMBER(10) := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;
    V_PROC_INPUT            CLOB;
    V_SQL_CODE              VARCHAR2(20 CHAR);
    V_SQL_ERRMSG            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);

    -- 검증용 변수
    V_CHECK_CNT             NUMBER(10);
    V_VALID_PROJECT_CODE    VARCHAR2(4000 CHAR);
    V_VALID_ITEM_ID         VARCHAR2(4000 CHAR);
    V_VALID_ITEM_ID_2       VARCHAR2(4000 CHAR);
    V_VALID_TYPE            VARCHAR2(100 CHAR);
    V_VALID_BOM             VARCHAR2(4000 CHAR);
    V_VALID_SHIPTO          VARCHAR2(4000 CHAR);
    V_S_BLOCK_MODEL         VARCHAR2(4000 CHAR);
    V_S_UNIT_PRICE_VALID    VARCHAR2(4000 CHAR);
    V_ERR_CNT               PLS_INTEGER;

    -- INVENTORY/DATE 변수
    V_MIN_DATE              CHAR(8 CHAR);
    V_MAX_DATE              CHAR(8 CHAR);
    V_FROM_DATE             CHAR(8 CHAR);
    V_TO_DATE               CHAR(8 CHAR);

    -- 중장기 계획 DIVISION 변수
    V_C_DIVISION_ID         VARCHAR2(4000 CHAR);

    -- TYPE 변수 (#mshychu1, #mshychu2, #ess_price_except_model 대체)
    T_MSHYCHU1              SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();
    T_MSHYCHU2              SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();
    T_ESS_PRICE_EXCEPT      SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();

    -- ESS VMI 커서용 변수
    EV_DIVISION_ID          VARCHAR2(30 CHAR);
    EV_SCM_SITE_ID          VARCHAR2(50 CHAR);
    EV_PROJECT_CODE         VARCHAR2(50 CHAR);
    EV_ITEM_ID              VARCHAR2(50 CHAR);
    EV_DOM_EXP              VARCHAR2(3 CHAR);
    EV_FCST_TYPE            VARCHAR2(20 CHAR);
    EV_INCOTERMS            VARCHAR2(10 CHAR);
    EV_PLANT_SITE_ID        VARCHAR2(30 CHAR);
    EV_DIO                  PLS_INTEGER;
    EV_BINV                 PLS_INTEGER;

    -- ESS VMI 커서
    CURSOR CURSOR_ESSVMI1 IS
        --[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건으로 기존 SCM_MST_SITE ATTRIBUTE5에서 SSPM INVENTORY DAYS 컬럼으로 변경 [START]
        -- 2026.04.06 SCM_MST_SITE_ITEM 칼럼 삭제에 따른 조회 컬럼 제거
        SELECT DISTINCT A.V_DIVISION_ID, A.V_SCM_SITE_ID, A.V_PROJECT_CODE, A.V_ITEM_ID, A.V_DOM_EXP
                      , A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
        FROM  SCM_MGR.GT_DMF3_RESULTS A
        JOIN  SCM_MGR.SCM_MST_SITE_ITEM B
          ON  A.V_DIVISION_ID   = B.DIVISION_ID
         AND  A.V_SCM_SITE_ID   = B.SCM_SITE_ID
         AND  A.V_ITEM_ID       = B.ITEM_ID
         AND  A.V_PROJECT_CODE  = B.PROJECT_CODE
        WHERE A.V_MEASURE       = 'MKT_FCST'
          AND A.V_VMI_YN        = 'Y'
          AND A.V_DIVISION_ID   = '82';
        --[E20230619-000273] [END]

    -- INVALID 플래그
    V_INVALID               BOOLEAN := FALSE;
    V_R_CURSOR              SYS_REFCURSOR;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    -- GTT 초기화 (프로시저 시작 시 이전에 일반 테이블 DML 없으므로 DELETE 사용)
    -- ※ TRUNCATE는 DDL로 자동 COMMIT 발생 위험이 있으므로 DELETE 사용
    DELETE FROM SCM_MGR.GT_DMF3_RESULTS;
    DELETE FROM SCM_MGR.GT_DMF3_T_PRICE;
    DELETE FROM SCM_MGR.GT_DMF3_TMP_MKT_FCST;
    DELETE FROM SCM_MGR.GT_DMF3_SEND_TARGET_DATA;
    --DELETE FROM SCM_MGR.GT_DMF3_INVENTORY_SITE; 2026.04.06 SCM_MST_SITE_ITEM 미사용으로 제거
    DELETE FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GT_DMF3_T_ERR;
    DELETE FROM SCM_MGR.GT_DMF3_T_ERR2;
    DELETE FROM SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP;

    -- 로컬 복사
    LP_ACTIVE_FLAG   := RTRIM(P_ACTIVE_FLAG)  || '^';
    LP_DIVISION_ID   := RTRIM(P_DIVISION_ID)  || '^';
    LP_PROJECT_CODE  := RTRIM(P_PROJECT_CODE) || '^';
    LP_SCM_SITE_ID   := RTRIM(P_SCM_SITE_ID)  || '^';
    LP_ITEM_ID       := RTRIM(P_ITEM_ID)       || '^';
    LP_DOM_EXP       := RTRIM(P_DOM_EXP)       || '^';
    LP_FCST_TYPE     := RTRIM(P_FCST_TYPE)     || '^';
    LP_INCOTERMS     := RTRIM(P_INCOTERMS)     || '^';
    LP_MEASURE       := RTRIM(P_MEASURE)       || '^';
    LP_PLANT_SITE_ID := RTRIM(P_PLANT_SITE_ID) || '^';
    LP_YYYYMMDD      := RTRIM(P_YYYYMMDD)      || '^';
    LP_QTY           := RTRIM(P_QTY)           || '^';
    LP_CREATED_BY    := RTRIM(P_CREATED_BY)    || '^';
    LP_AS_FROM_SITE  := P_AS_FROM_SITE;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    V_CREATED_BY  := SUBSTR(LP_CREATED_BY, 1,
                        CASE WHEN INSTR(LP_CREATED_BY, '^') > 1 THEN INSTR(LP_CREATED_BY, '^') - 1
                             ELSE 100 END);
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    V_CREATED_BY  := NULL;
    -- 시작 LOG (END)

    ------------------------------------------------------------------------------------------------------
    -- [E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
    /*
    -- AS_FROM_SITE 를 뽑는다.
    IF P_AS_FROM_SITE <> 'ALL'
    THEN
        -- as from site 세팅
        SELECT A.TOKEN INTO V_AS_FROM_SITE
        FROM (
            SELECT TRIM(REGEXP_SUBSTR(P_AS_FROM_SITE, '[^' || CHR(94) || ']+', 1, LEVEL)) AS TOKEN
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_AS_FROM_SITE, '[^' || CHR(94) || ']+', 1, LEVEL) IS NOT NULL
        ) A
        JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON A.TOKEN    = B.SEGMENT2
         AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
         AND B.SEGMENT2 <> '-'
         AND B.SEGMENT3 = SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1)
        WHERE ROWNUM = 1;
    END IF;
    */
    --[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선

    --[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건의 속도저하문제로 SSPM 테이블을 임시테이블로 생성 [START]
    -- 2026.04.06 SCM_MST_SITE_ITEM 미사용으로 제거
    /*IF SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1) = '82' THEN
        INSERT INTO SCM_MGR.GT_DMF3_INVENTORY_SITE
        ( DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID )
        SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
        FROM   SCM_MGR.SCM_MST_SITE_ITEM
        WHERE  DIVISION_ID = SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1)
          AND  SCM_SITE_ID IN (SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'INVENTORY_DAYS_SETUP_SITE');
    END IF;*/
    --[E20230619-000273] [END]

    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    -- 1. 화면에서 전달받은 데이터 -> GTT로 insert
    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

    WHILE LENGTH(LP_DIVISION_ID) > 0
    LOOP
        N_INDEX_ACTIVE_FLAG   := INSTR(LP_ACTIVE_FLAG,   '^');
        N_INDEX_DIVISION_ID   := INSTR(LP_DIVISION_ID,   '^');
        N_INDEX_PROJECT_CODE  := INSTR(LP_PROJECT_CODE,  '^');
        N_INDEX_SCM_SITE_ID   := INSTR(LP_SCM_SITE_ID,   '^');
        N_INDEX_ITEM_ID       := INSTR(LP_ITEM_ID,        '^');
        N_INDEX_DOM_EXP       := INSTR(LP_DOM_EXP,        '^');
        N_INDEX_FCST_TYPE     := INSTR(LP_FCST_TYPE,      '^');
        N_INDEX_INCOTERMS     := INSTR(LP_INCOTERMS,      '^');
        N_INDEX_MEASURE       := INSTR(LP_MEASURE,        '^');
        N_INDEX_PLANT_SITE_ID := INSTR(LP_PLANT_SITE_ID,  '^');
        N_INDEX_YYYYMMDD      := INSTR(LP_YYYYMMDD,       '^');
        N_INDEX_QTY           := INSTR(LP_QTY,            '^');
        N_INDEX_CREATED_BY    := INSTR(LP_CREATED_BY,     '^');
        --[E20260211-001189]_index_as_from_site추가
        N_INDEX_AS_FROM_SITE  := INSTR(LP_AS_FROM_SITE || '^', '^');

        IF N_INDEX_DIVISION_ID > 0 THEN
            V_ACTIVE_FLAG   := SUBSTR(LP_ACTIVE_FLAG,   1, N_INDEX_ACTIVE_FLAG   - 1);
            V_DIVISION_ID   := SUBSTR(LP_DIVISION_ID,   1, N_INDEX_DIVISION_ID   - 1);
            V_PROJECT_CODE  := SUBSTR(LP_PROJECT_CODE,  1, N_INDEX_PROJECT_CODE  - 1);
            V_SCM_SITE_ID   := SUBSTR(LP_SCM_SITE_ID,   1, N_INDEX_SCM_SITE_ID   - 1);
            V_ITEM_ID       := SUBSTR(LP_ITEM_ID,        1, N_INDEX_ITEM_ID       - 1);
            V_DOM_EXP       := SUBSTR(LP_DOM_EXP,        1, N_INDEX_DOM_EXP       - 1);
            V_FCST_TYPE     := SUBSTR(LP_FCST_TYPE,      1, N_INDEX_FCST_TYPE     - 1);
            V_INCOTERMS     := SUBSTR(LP_INCOTERMS,      1, N_INDEX_INCOTERMS     - 1);
            V_MEASURE       := SUBSTR(LP_MEASURE,        1, N_INDEX_MEASURE       - 1);
            V_PLANT_SITE_ID := SUBSTR(LP_PLANT_SITE_ID,  1, N_INDEX_PLANT_SITE_ID - 1);
            V_YYYYMMDD      := SUBSTR(LP_YYYYMMDD,       1, N_INDEX_YYYYMMDD      - 1);
            V_QTY           := SUBSTR(LP_QTY,            1, N_INDEX_QTY           - 1);
            V_CREATED_BY    := SUBSTR(LP_CREATED_BY,     1, N_INDEX_CREATED_BY    - 1);
            --[E20260211-001189]_index_as_from_site추가
            V_AS_FROM_SITE  := SUBSTR(LP_AS_FROM_SITE || '^', 1, N_INDEX_AS_FROM_SITE - 1);

            LP_ACTIVE_FLAG   := SUBSTR(LP_ACTIVE_FLAG,   LENGTH(V_ACTIVE_FLAG   || '^') + 1);
            LP_DIVISION_ID   := SUBSTR(LP_DIVISION_ID,   LENGTH(V_DIVISION_ID   || '^') + 1);
            LP_PROJECT_CODE  := SUBSTR(LP_PROJECT_CODE,  LENGTH(V_PROJECT_CODE  || '^') + 1);
            LP_SCM_SITE_ID   := SUBSTR(LP_SCM_SITE_ID,   LENGTH(V_SCM_SITE_ID   || '^') + 1);
            LP_ITEM_ID       := SUBSTR(LP_ITEM_ID,        LENGTH(V_ITEM_ID       || '^') + 1);
            LP_DOM_EXP       := SUBSTR(LP_DOM_EXP,        LENGTH(V_DOM_EXP       || '^') + 1);
            LP_FCST_TYPE     := SUBSTR(LP_FCST_TYPE,      LENGTH(V_FCST_TYPE     || '^') + 1);
            LP_INCOTERMS     := SUBSTR(LP_INCOTERMS,      LENGTH(V_INCOTERMS     || '^') + 1);
            LP_MEASURE       := SUBSTR(LP_MEASURE,        LENGTH(V_MEASURE       || '^') + 1);

            IF V_MEASURE = 'MKT_FCST_RP' THEN
                V_MEASURE := 'MKT_FCST';
            END IF;

            LP_PLANT_SITE_ID := SUBSTR(LP_PLANT_SITE_ID, LENGTH(V_PLANT_SITE_ID || '^') + 1);
            LP_YYYYMMDD      := SUBSTR(LP_YYYYMMDD,      LENGTH(V_YYYYMMDD      || '^') + 1);
            LP_QTY           := SUBSTR(LP_QTY,           LENGTH(V_QTY           || '^') + 1);
            LP_CREATED_BY    := SUBSTR(LP_CREATED_BY,    LENGTH(V_CREATED_BY    || '^') + 1);
            --[E20260211-001189]_index_as_from_site추가
            IF N_INDEX_AS_FROM_SITE > 0 AND LENGTH(LP_AS_FROM_SITE) >= N_INDEX_AS_FROM_SITE THEN
                LP_AS_FROM_SITE := SUBSTR(LP_AS_FROM_SITE, LENGTH(V_AS_FROM_SITE || '^') + 1);
            ELSE
                LP_AS_FROM_SITE := NULL;
            END IF;

            --20181005 khsong 공백제거로직추가 (START)
            V_ACTIVE_FLAG   := TRIM(V_ACTIVE_FLAG);
            V_DIVISION_ID   := TRIM(V_DIVISION_ID);
            V_PROJECT_CODE  := TRIM(V_PROJECT_CODE);
            V_SCM_SITE_ID   := TRIM(V_SCM_SITE_ID);
            --[E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)
            --1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
            V_ITEM_ID       := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID), CHR(13),''), CHR(10),''), CHR(9),''), ' ','');
            --[E20250522-001188] (END)
            V_DOM_EXP       := TRIM(V_DOM_EXP);
            V_FCST_TYPE     := TRIM(V_FCST_TYPE);
            V_INCOTERMS     := TRIM(V_INCOTERMS);
            V_MEASURE       := TRIM(V_MEASURE);
            V_PLANT_SITE_ID := TRIM(V_PLANT_SITE_ID);
            V_YYYYMMDD      := TRIM(V_YYYYMMDD);
            V_QTY           := TRIM(V_QTY);
            V_CREATED_BY    := TRIM(V_CREATED_BY);
            --[E20260211-001189]_index_as_from_site추가
            V_AS_FROM_SITE  := TRIM(V_AS_FROM_SITE);
            --20181005 khsong 공백제거로직추가 (END)

            -- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
            IF V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND REGEXP_LIKE(V_YYYYMMDD, '^[0-9]+$')  -- 2021.09.27
            THEN
                -- 2021.12.15
                DECLARE
                    V_EXISTS_W PLS_INTEGER := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS_W FROM DUAL
                    WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.SCM_MST_SITE
                        WHERE DIVISION_ID    = V_DIVISION_ID
                          AND SCM_SITE_ID    = V_SCM_SITE_ID
                          AND SITE_TYPE      = 'SALES'
                          AND OPERATION_GROUP = 'W'
                    );
                    -- SITE_TYPE=SALES, OPERATION_GROUP=W 인 AS PLANT 이면 ATTRIBUTE10 비움
                    V_AS_FROM_PLANT := '-';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- AS PLANT 가 아닌 일반 Sales Site
                        BEGIN
                            SELECT SEGMENT2 INTO V_AS_FROM_PLANT
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                              AND  SEGMENT2    = V_AS_FROM_SITE
                              AND  SEGMENT3    = V_DIVISION_ID
                              AND  SEGMENT1   <> V_SCM_SITE_ID
                              AND  ROWNUM      = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_AS_FROM_PLANT := '-';
                        END;
                END;

                INSERT INTO SCM_MGR.GT_DMF3_RESULTS
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
                VALUES
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, TO_NUMBER(V_QTY), V_CREATED_BY
                --[E20260211-001189]_index_as_from_site 원소스 주석처리 (START)
                --, NVL(V_AS_FROM_PLANT,'-')
                , NVL(V_AS_FROM_SITE, '-')  --[E20260211-001189]_변경
                --[E20260211-001189]_index_as_from_site 원소스 주석처리 (END)
                );
            ELSE
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := ' Check date values (only future dates can be entered after this week) !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;

        ELSE
            -- 마지막 토큰 처리
            V_DIVISION_ID   := LP_DIVISION_ID;
            LP_DIVISION_ID  := NULL;

            --20181005 khsong 공백제거로직추가 (START)
            V_ACTIVE_FLAG   := TRIM(V_ACTIVE_FLAG);
            V_DIVISION_ID   := TRIM(V_DIVISION_ID);
            V_PROJECT_CODE  := TRIM(V_PROJECT_CODE);
            V_SCM_SITE_ID   := TRIM(V_SCM_SITE_ID);
            V_ITEM_ID       := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID), CHR(13),''), CHR(10),''), CHR(9),''), ' ','');
            V_DOM_EXP       := TRIM(V_DOM_EXP);
            V_FCST_TYPE     := TRIM(V_FCST_TYPE);
            V_INCOTERMS     := TRIM(V_INCOTERMS);
            V_MEASURE       := TRIM(V_MEASURE);
            V_PLANT_SITE_ID := TRIM(V_PLANT_SITE_ID);
            V_YYYYMMDD      := TRIM(V_YYYYMMDD);
            V_QTY           := TRIM(V_QTY);
            V_CREATED_BY    := TRIM(V_CREATED_BY);
            --[E20260211-001189]_v_as_from_site 추가
            V_AS_FROM_SITE  := TRIM(V_AS_FROM_SITE);
            --20181005 khsong 공백제거로직추가 (END)

            -- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
            IF V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND REGEXP_LIKE(V_YYYYMMDD, '^[0-9]+$')
            THEN
                DECLARE
                    V_EXISTS_W2 PLS_INTEGER := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS_W2 FROM DUAL
                    WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.SCM_MST_SITE
                        WHERE DIVISION_ID     = V_DIVISION_ID
                          AND SCM_SITE_ID     = V_SCM_SITE_ID
                          AND SITE_TYPE       = 'SALES'
                          AND OPERATION_GROUP = 'W'
                    );
                    V_AS_FROM_PLANT := '-';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        BEGIN
                            SELECT SEGMENT2 INTO V_AS_FROM_PLANT
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                              AND  SEGMENT2    = V_AS_FROM_SITE
                              AND  SEGMENT3    = V_DIVISION_ID
                              AND  SEGMENT1   <> V_SCM_SITE_ID
                              AND  ROWNUM      = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_AS_FROM_PLANT := '-';
                        END;
                END;

                INSERT INTO SCM_MGR.GT_DMF3_RESULTS
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
                VALUES
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, TO_NUMBER(V_QTY), V_CREATED_BY
                --[E20260211-001189]_v_as_from_site 원소스 주석처리 (START)
                --, NVL(V_AS_FROM_PLANT,'-')
                , NVL(V_AS_FROM_SITE, '-')  --변경
                --[E20260211-001189]_v_as_from_site 원소스 주석처리 (END)
                );
            ELSE
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := ' Check date values (only future dates can be entered after this week) !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;

            EXIT; -- WHILE 종료
        END IF;

        --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        -- 2. 데이터 정합성 Validation
        --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        ----------- 20180810 KHSONG NULL VALIDATION ADDED
        IF    NVL(V_DIVISION_ID,  '-') = '-'  OR V_DIVISION_ID  = ''
           OR NVL(V_PROJECT_CODE, '-') = '-'  OR V_PROJECT_CODE = ''
           OR NVL(V_SCM_SITE_ID,  '-') = '-'  OR V_SCM_SITE_ID  = ''
           OR NVL(V_ITEM_ID,      '-') = '-'  OR V_ITEM_ID      = ''
           OR NVL(V_DOM_EXP,      '-') = '-'  OR V_DOM_EXP      = ''
           OR NVL(V_FCST_TYPE,    '-') = '-'  OR V_FCST_TYPE    = ''
           OR NVL(V_INCOTERMS,    '-') = '-'  OR V_INCOTERMS    = ''
           OR NVL(V_MEASURE,      '-') = '-'  OR V_MEASURE      = ''
        THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := ' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook ) !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
        -----------
    END LOOP;

    -- [C20220328-000205] MKT FCST 입력, 저장 간 오류 확인 요청
    DECLARE
        V_DUP_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_DUP_CNT
        FROM (
            SELECT COUNT(V_DIVISION_ID) AS CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS
            GROUP BY V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                   , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
            HAVING COUNT(V_DIVISION_ID) > 1
        );
        IF V_DUP_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일한 일자에 AS From Site 만 다른 DP 를 입력할 수 없습니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;

    -- ----------------------- SALES PRICE 미리 수집 --------------------------------
    SELECT MIN(BASIS_START_DATE), MAX(BASIS_END_DATE)
    INTO   V_MIN_DATE, V_MAX_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M M
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
    /*
    WHERE M.BASIS_YYYYMMDD BETWEEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD')  --당주 월요일부터
                                AND TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7 + 52*7,'YYYYMMDD')  -- 52주후 월요일까지
    */
    -----------------------------------------------------------------------------------------------------------------------------------
    WHERE  M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD')   --당주 월요일부터
      AND  M.BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7 + 52*7,'YYYYMMDD');  -- 52주후 월요일까지
    -- [E20250825-000297] (END)
    -----------------------------------------------------------------------------------------------------------------------------------

    INSERT INTO SCM_MGR.GT_DMF3_T_PRICE
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
    SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID
                  , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE
    FROM   SCM_MGR.GT_DMF3_RESULTS A
    JOIN   SCM_MGR.SCM_MST_FUTURE_PRICE B
      ON   A.V_DIVISION_ID    = B.DIVISION_ID
     AND   A.V_PROJECT_CODE   = B.PROJECT_CODE
     AND   A.V_SCM_SITE_ID    = B.SCM_SITE_ID
     AND   A.V_PLANT_SITE_ID  = CASE WHEN A.V_DIVISION_ID LIKE '81%' THEN B.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
     AND   A.V_ITEM_ID        = B.ITEM_ID
     AND   A.V_DOM_EXP        = B.DOM_EXP
     AND   A.V_FCST_TYPE      = B.FCST_TYPE
     AND   A.V_INCOTERMS      = B.INCOTERMS
    WHERE  B.DIVISION_ID      = V_DIVISION_ID
      AND  B.YYYYMMDD        BETWEEN V_MIN_DATE AND V_MAX_DATE
      AND  B.PRICE           <> 0;

    ---------------------------------------------------------------------------------------------------------

    -- GT_DMF3_RESULTS 테이블의 VMI_YN UPDATE
    UPDATE SCM_MGR.GT_DMF3_RESULTS A
    SET    V_VMI_YN = (
               SELECT CASE WHEN NVL(B.VMI_YN, '-') = 'Y' THEN 'Y' ELSE '' END
               FROM   SCM_MGR.SCM_MST_SITE B
               WHERE  B.DIVISION_ID = A.V_DIVISION_ID
                 AND  B.SCM_SITE_ID = A.V_SCM_SITE_ID
           );

    -- AS 이더라도 AS Plant 에는 Attribute10 을 지워준다.
    UPDATE SCM_MGR.GT_DMF3_RESULTS A
    SET    V_ATTRIBUTE10 = '-'
    WHERE  V_SCM_SITE_ID = V_ATTRIBUTE10;

    /*
    [E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선 사용하지 않아도 됨 (START)
    -- AS 인데, FROM Site 가 없는 건들은 오류처리한다. ( WS, 20211103 )
	-- FCST Type 에 WS, WSF가 포함되어있는데, From Site 가 없는 경우 에러처리
	IF EXISTS ( SELECT *
				FROM #results A
				JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON A.v_division_id = B.DIVISION_ID
					AND A.v_scm_site_id = B.SCM_SITE_ID
					AND ISNULL(B.OPERATION_GROUP,'') <> 'W'
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
					ON A.v_fcst_type = C.SEGMENT1
					AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					AND C.ATTRIBUTE2 = 'Y'
				)
		AND NOT EXISTS ( SELECT *
							FROM SCM_MST_SITE WITH(NOLOCK)
							WHERE DIVISION_ID = @v_division_id
							AND SCM_SITE_ID = @v_as_from_site
						)
		BEGIN
			SET @v_log_type = 'INVALID';
			--[E20260211-001189]_내용변경 (START)
			--SELECT 'AS 관련 FCST TYPE 을 사용할 경우 상단 Sales Site 에 AS Plant 가 선택되어있어야 합니다.'
			SELECT 'AS 관련 FCST TYPE 을 사용할 경우 AS FROM SITE를 선택해야 합니다.'
			--SET @v_description =  'AS 관련 FCST TYPE 을 사용할 경우 상단 Sales Site 에 AS Plant 가 선택되어있어야 합니다.'
			SET @v_description =  'AS 관련 FCST TYPE 을 사용할 경우 AS FROM SITE를 선택해야 합니다.'
			--[E20260211-001189]_내용변경 (END)
			GOTO ERR_RTN
		END

	-- AS 유효성 체크
	-- AS FROM SITE 가 여러개 있거나 없는 경우
	IF NOT EXISTS (	SELECT COUNT(*)
					FROM DBO.UF_FX_String_Split(@p_as_from_site, '^') A
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
						ON A.TOKEN = B.SEGMENT1
						AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
						AND B.SEGMENT2 <> '-' AND B.SEGMENT3 = @v_division_id
						HAVING COUNT(*) = 1
					)
		-- 고객향이 포함된 경우 ( AS PLANT 로 가는 데이터만 있을 경우 FROM SITE 필요 없음 )
		AND EXISTS ( SELECT *
						FROM #results A
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									ON A.v_scm_site_id = B.SEGMENT1
									AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
									AND B.SEGMENT2 <> '-' AND B.SEGMENT3 = @v_division_id
						WHERE B.SEGMENT1 IS NULL
					) -- AS FCST TYPE 이 있을 경우
		AND EXISTS ( SELECT *
						FROM #results A
						JOIN SCM_MST_SITE B WITH(NOLOCK)
						ON A.v_division_id = B.DIVISION_ID
						AND A.v_scm_site_id = B.SCM_SITE_ID
						AND ISNULL(B.OPERATION_GROUP,'') <> 'W'
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
						ON A.v_fcst_type = C.SEGMENT1
						AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND C.ATTRIBUTE2 = 'Y'
					)
		BEGIN
			SET @v_log_type = 'INVALID';
			--[E20260211-001189]_내용변경 (START)
			--SELECT 'AS 가 체크되었을 때에는 한 개의 AS PLANT 가 Sales Site 에 선택이 되어야 합니다.'
			SELECT 'AS 관련 FCST TYPE을 선택했을 때에는 한 개의 AS FROM SITE가 선택이 되어야 합니다.'
			--SET @v_description =  'AS 가 체크되었을 때에는 한 개의 AS PLANT 가 Sales Site 에 선택이 되어야 합니다.!'
			SET @v_description =  'AS 관련 FCST TYPE을 선택했을 때에는 한 개의 AS FROM SITE가 선택이 되어야 합니다.!'
			--[E20260211-001189]_내용변경 (END)
			goto err_rtn
		END
    [E20260211-001189] (END)
    */

    -- AS PLANT 로 가는 DP의 INCOTERMS 를 제한한다.
    DECLARE
        V_INCO_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_INCO_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.V_DIVISION_ID = B.SEGMENT3
         AND   A.V_SCM_SITE_ID = B.SEGMENT1
         AND   B.LOOKUP_TYPE   = 'AS_SITE_PLANT'
         AND   B.VALID_YN      = 'Y'
        LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.V_DIVISION_ID = C.SEGMENT1
         AND   A.V_INCOTERMS   = C.SEGMENT2
         AND   C.VALID_YN      = 'Y'
        WHERE  C.SEGMENT1 IS NULL;

        IF V_INCO_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS In Request 메저는 지정된 Incoterms 만 사용가능합니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;

    --==========================================================================================================================
    -- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
    --==========================================================================================================================
    DECLARE
        V_OLD_INCO_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_OLD_INCO_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  A.V_INCOTERMS IN (
                   SELECT OLD_VALUE1
                   FROM   SCM_MGR.NERP_CONV_MASTER
                   WHERE  CODETYPE = 'INCOTERMS_ID'
                   GROUP BY OLD_VALUE1
               );
        IF V_OLD_INCO_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '구코드 INCOTERMS는 저장할 수 없습니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    --==========================================================================================================================
    -- [E20250919-001699] (END)
    --==========================================================================================================================

    -- 중장기계획 기간 조회
    SELECT MIN(C.BASIS_YYYYMMDD), MAX(C.BASIS_YYYYMMDD)
    INTO   V_FROM_DATE, V_TO_DATE
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
    JOIN   SCM_MGR.SCM_SYS_CALENDAR_M C
      ON   C.BASIS_YYYYMM = L.ATTRIBUTE1 OR C.BASIS_YYYYMM = L.ATTRIBUTE2
    WHERE  L.LOOKUP_TYPE = 'DM_LONG_PLAN'
      AND  L.SEGMENT1    = '40'
      AND  L.SEGMENT2    = 'MKT FCST'
      AND  L.VALID_YN    = 'Y';

    -- 소형일 경우 중장기계획 관련 기간 확인
    IF V_DIVISION_ID = '40' THEN
        DECLARE
            V_OOB_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_OOB_CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS R
            WHERE  R.V_YYYYMMDD < V_FROM_DATE OR R.V_YYYYMMDD > V_TO_DATE;
            IF V_OOB_CNT > 0 THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := V_FROM_DATE || ' ~ ' || V_TO_DATE || ' 구간 내의 데이터만 수정할 수 있습니다.';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181012 BLOCK Model (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    V_S_BLOCK_MODEL := '-';
    BEGIN
        SELECT V_ITEM_ID INTO V_S_BLOCK_MODEL
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE  LOOKUP_TYPE = 'FCST_EXCEPT_MODEL'
                     AND  SEGMENT1   = '40'
                     AND  VALID_YN   = 'Y'
                     AND  SEGMENT2   = A.V_ITEM_ID
               )
          AND  A.V_QTY <> 0
          AND  ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_S_BLOCK_MODEL := '-';
    END;

    IF V_S_BLOCK_MODEL <> '-' THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := 'Model : ' || V_S_BLOCK_MODEL || CHR(10) || 'FCST INPUT BLOCK Model. contact 영업관리팀';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181012 BLOCK Model (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 저장전 변수 초기화
    V_CHECK_CNT          := 0;
    V_VALID_PROJECT_CODE := NULL;
    V_VALID_ITEM_ID      := NULL;
    V_VALID_ITEM_ID_2    := NULL;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID <> '40';

    IF V_CHECK_CNT > 0 THEN
        BEGIN
            SELECT A.V_PROJECT_CODE INTO V_VALID_PROJECT_CODE
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            WHERE  NOT EXISTS (
                       SELECT C.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_PROJECT C
                       WHERE  A.V_DIVISION_ID  = C.DIVISION_ID
                         AND  A.V_PROJECT_CODE = C.PROJECT_CODE
                         AND  C.DIVISION_ID   <> '40'
                   )
              AND  A.V_DIVISION_ID <> '40'
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_PROJECT_CODE := NULL;
        END;
        IF V_VALID_PROJECT_CODE IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_PROJECT_CODE || '] Invalid Project Code !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;

    BEGIN
        SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  NOT EXISTS (
                   SELECT ITEM.DIVISION_ID
                   FROM   SCM_MGR.SCM_MST_SITE_ITEM ITEM
                   JOIN   SCM_MGR.SCM_MST_ITEM_SN   SN
                     ON   ITEM.DIVISION_ID = SN.DIVISION_ID
                    AND   ITEM.ITEM_ID     = SN.ITEM_ID
                   WHERE  ITEM.DIVISION_ID  = A.V_DIVISION_ID
                     AND  ITEM.PROJECT_CODE = A.V_PROJECT_CODE
                     AND  ITEM.SCM_SITE_ID  = A.V_SCM_SITE_ID
                     AND  ITEM.ITEM_ID      = A.V_ITEM_ID
                     AND  SN.ACTIVE_FLAG    = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                     AND  ITEM.VALID_YN     = 'Y'  -- [C20200812-000104]
               )
          AND  ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
    END;
    IF V_VALID_ITEM_ID IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] Invalid Site Item ID !';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;

    -- [C20200717-000157] ESS사업부 Sales Site Project Model Sales Company, Sales Plant Validation 추가
    V_CHECK_CNT          := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82';

    IF V_CHECK_CNT > 0 THEN
        BEGIN
            SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            WHERE  EXISTS (
                       SELECT ITEM.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_SITE_ITEM ITEM
                       JOIN   SCM_MGR.SCM_MST_ITEM_SN   SN
                         ON   ITEM.DIVISION_ID = SN.DIVISION_ID
                        AND   ITEM.ITEM_ID     = SN.ITEM_ID
                       WHERE  ITEM.DIVISION_ID  = A.V_DIVISION_ID
                         AND  ITEM.PROJECT_CODE = A.V_PROJECT_CODE
                         AND  ITEM.SCM_SITE_ID  = A.V_SCM_SITE_ID
                         AND  ITEM.ITEM_ID      = A.V_ITEM_ID
                         AND  SN.ACTIVE_FLAG    = 'Y'
                         AND  ( (ITEM.SALES_COMPANY IS NULL OR ITEM.SALES_COMPANY = '-')
                              OR (ITEM.SALES_PLANT   IS NULL OR ITEM.SALES_PLANT   = '-') )
                   )
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
        END;
        IF V_VALID_ITEM_ID IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] Sales Company/Plant does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    --  20200529 KHSONG C20200424-000010 (Sales Price 필수 입력 구간 관련의 건) Unit Price 유무 Validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎

    -- #mshychu1 → T_MSHYCHU1 (단일 컬럼 Type)
    SELECT SEGMENT2
    BULK COLLECT INTO T_MSHYCHU1
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
      AND  MST.SEGMENT1    = 'MEASURE'
      AND  MST.VALID_YN    = 'Y';

    -- #mshychu2 → T_MSHYCHU2
    SELECT SEGMENT2
    BULK COLLECT INTO T_MSHYCHU2
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
      AND  MST.SEGMENT1    = 'FCST_TYPE'
      AND  MST.VALID_YN    = 'Y';

    -- [E20231020-001565] 현장설치품 예외 모델 로드
    SELECT SEGMENT2
    BULK COLLECT INTO T_ESS_PRICE_EXCEPT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'ESS_PRICE_EXCEPT_MODEL'
      AND  MST.SEGMENT1    = V_DIVISION_ID   -- 82번사업부만해당
      AND  MST.VALID_YN    = 'Y';

    V_S_UNIT_PRICE_VALID := NULL;
    BEGIN
        SELECT
            CASE WHEN A.V_DIVISION_ID = '40'
                 THEN 'End Customer________ : ' || NVL(V_PROJECT_CODE, '-')
                 ELSE 'Project_________ : '     || NVL(V_PROJECT_CODE, '-') END
            || CHR(10) || 'Sales site_____________ : '   || NVL(V_SCM_SITE_ID,   '-')
            || CHR(10) || 'Model________________ : '     || NVL(V_ITEM_ID,        '-')
            || CHR(10) || 'Customs Handbook__ : '        || NVL(V_DOM_EXP,        '-')
            || CHR(10) || 'Fcst Type_____________ : '    ||
                NVL(( SELECT SEGMENT2
                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                      WHERE  MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND  MST.SEGMENT1    = A.V_FCST_TYPE
                        AND  ROWNUM = 1 ), '-')  -- 20180917 KHSONG fcst_type LOOKUP참조하여 출력으로 변경
            || CHR(10) || 'Incoterms____________ : '     || NVL(V_INCOTERMS,      '-')
            || CHR(10) || 'Plant Site___________ : '     || NVL(V_PLANT_SITE_ID,  '-')  -- [C20200525-000296]
            || CHR(10) || 'YYYYMMDD_________ : '         || NVL(MIN(M.BASIS_START_DATE),'-') || ' ~ ' || NVL(MAX(M.BASIS_START_DATE),'-')  -- [C20210203-000427]
            || CHR(10) || CHR(10)
        INTO V_S_UNIT_PRICE_VALID
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        --  20181016 KHSONG SALES_PLAN_ADJUST_YN = ''인대상에 대해서는 Price Validation 에서 제외
        JOIN   SCM_MGR.SCM_MST_SITE_ITEM Z
          ON   A.V_DIVISION_ID   = Z.DIVISION_ID
         AND   A.V_PROJECT_CODE  = Z.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = Z.SCM_SITE_ID
         AND   A.V_ITEM_ID       = Z.ITEM_ID
         AND   Z.VALID_YN        = 'Y'
         AND   ( Z.SALES_PLAN_ADJUST_YN = 'Y' OR NVL(Z.SALES_PLAN_ADJUST_YN,'-') = '-' )  -- 20181023 보완
        --  20181016 KHSONG SALES_PLAN_ADJUST_YN = ''인대상에 대해서는 Price Validation 에서 제외
        LEFT   JOIN (  -- [C20210203-000427]
                       SELECT BASIS_START_DATE
                       FROM   SCM_MGR.SCM_SYS_CALENDAR_M M
                       -----------------------------------------------------------------------------------------------------------------------------------
                       -- [E20250825-000297] (START)
                       /*
                       WHERE M.BASIS_YYYYMMDD BETWEEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
                                               AND TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')
                       */
                       WHERE  M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')   --당주 월요일부터
                         AND  M.BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')  -- 52주후 월요일까지
                       -- [E20250825-000297] (END)
                       -----------------------------------------------------------------------------------------------------------------------------------
                       GROUP BY BASIS_START_DATE
                   ) M
          ON   1=1
        LEFT   JOIN SCM_MGR.GT_DMF3_T_PRICE P
          ON   A.V_DIVISION_ID   = P.DIVISION_ID
         AND   A.V_PROJECT_CODE  = P.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = P.SCM_SITE_ID
         AND   A.V_ITEM_ID       = P.ITEM_ID
         AND   A.V_DOM_EXP       = P.DOM_EXP
         AND   A.V_FCST_TYPE     = P.FCST_TYPE
         AND   A.V_INCOTERMS     = P.INCOTERMS
         AND   A.V_PLANT_SITE_ID = CASE WHEN A.V_DIVISION_ID LIKE '81%' THEN P.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END  -- [C20200525-000296]
         AND   P.YYYYMMDD        = M.BASIS_START_DATE
         AND   P.PRICE > 0
        WHERE  P.YYYYMMDD IS NULL  -- PRICE값이 없는경우
          AND  A.V_MEASURE IN (SELECT COLUMN_VALUE FROM TABLE(T_MSHYCHU1))
          AND  A.V_QTY     <> 0
          AND  A.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_MSHYCHU2))
          AND  A.V_ITEM_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_ESS_PRICE_EXCEPT))  -- [E20231020-001565]
        GROUP  BY A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID
                , A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_MEASURE, A.V_PLANT_SITE_ID, P.YYYYMMDD
        ORDER  BY A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID
                , A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_MEASURE, A.V_PLANT_SITE_ID, P.YYYYMMDD
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_S_UNIT_PRICE_VALID := NULL;
    END;

    IF V_S_UNIT_PRICE_VALID IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := V_S_UNIT_PRICE_VALID || 'Unit Price Not Found !' || CHR(10)
                      || '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || CHR(10)
                      || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    --  20200529 KHSONG C20200424-000010 Unit Price 유무 Validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 RMA FCST_TYPE 음수값 validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DECLARE
        V_RMA_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(*),0) INTO V_RMA_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS
        WHERE  V_FCST_TYPE = 'RMA'
          AND  V_QTY > 0;
        IF V_RMA_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '반품수량(RMA)은 음수값만 입력가능합니다 !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 RMA FCST_TYPE 음수값 validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DECLARE
        V_NEG_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(*),0) INTO V_NEG_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS
        WHERE  V_FCST_TYPE <> 'RMA'
          AND  V_QTY < 0;
        IF V_NEG_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '정수값만 입력가능합니다 !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -- Start [C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
    V_VALID_TYPE := NULL;
    V_CHECK_CNT          := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID LIKE '81%';


    IF V_CHECK_CNT > 0 THEN

        INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_V
        ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
        , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
        , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
        , CELL_QUANTITY )
        SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
             , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
             , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
             , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
             , CELL_QUANTITY
        FROM (
            SELECT T2.DIVISION_ID, T2.ITEM_ID, T2.ITEM_NAME, T2.ITEM_CLASS, T2.ITEM_CLASS_NAME
                 , T2.NICK_NAME, T2.ITEM_TYPE, T2.MATERIAL_CLASS_NAME, T2.ITEM_UOM, T2.SPEC
                 , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
                 , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T2.ACTIVE_FLAG, T2.CELL_TYPE, T2.ENERGE
                 , T2.CELL_QUANTITY
            FROM  SCM_MGR.DM_MST_ITEM_SINGLE_V T2
            JOIN  SCM_MGR.GT_DMF3_RESULTS A
              ON  A.V_DIVISION_ID = T2.DIVISION_ID
             AND  A.V_ITEM_ID     = T2.ITEM_ID
        ) G
        GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
               , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
               , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
               , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
               , CELL_QUANTITY;

        BEGIN
            SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_ITEM F
              ON   A.V_DIVISION_ID   = F.DIVISION_ID
             AND   A.V_ITEM_ID       = F.ITEM_ID
             AND   A.V_PROJECT_CODE  = F.PROJECT_CODE
             AND   A.V_SCM_SITE_ID   = F.SCM_SITE_ID
            JOIN   SCM_MGR.GT_DMF3_ITEM_SINGLE_V X
              ON   A.V_DIVISION_ID = X.DIVISION_ID
             AND   A.V_ITEM_ID     = X.ITEM_ID
            WHERE  CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Cell') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Pack') > 0  AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        ELSE 0
                   END = 1
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
        END;

        IF V_VALID_ITEM_ID IS NOT NULL THEN
            BEGIN
                SELECT CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 THEN 'Cell/Car or Cell/Module'
                            ELSE 'Cell/Car' END
                INTO   V_VALID_TYPE
                FROM   SCM_MGR.GT_DMF3_ITEM_SINGLE_V X
                WHERE  X.ITEM_ID = V_VALID_ITEM_ID
                  AND  ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN V_VALID_TYPE := '-';
            END;
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] ' || V_VALID_TYPE || ' does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;
    -- END [C20200511-000360]

    -- START [C20220713-000194]
    V_CHECK_CNT  := 0;
    SELECT CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF3_RESULTS A WHERE A.V_DIVISION_ID LIKE '81%')
           THEN 1 ELSE 0 END
    INTO V_CHECK_CNT
    FROM DUAL;

    IF V_CHECK_CNT > 0 THEN -- Case 28 변환
        DECLARE
            V_DESC_81 VARCHAR2(4000 CHAR);
        BEGIN
            SELECT V_DESCRIPTION INTO V_DESC_81
            FROM (
                SELECT '[' || RTRIM(A.V_ITEM_ID) || '] '
                    || CASE WHEN (NOT REGEXP_LIKE(B.ATTRIBUTE8, '^[0-9.]+$') OR NVL(TO_NUMBER(B.ATTRIBUTE8),0) <= 0)
                            THEN 'Kwh/Cell does not exist !'
                            WHEN B.ATTRIBUTE10 NOT IN (
                                     SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y'
                                 )
                            THEN 'CELL_TYPE does not exist !'
                            WHEN NVL(B.CELL_PER_CAR,0) <= 0
                            THEN 'Cell/Car does not exist !'
                       END
                    || CHR(10) || 'Sales Site Project Model 에서 해당 항목을 채워주세요.' AS V_DESCRIPTION
                FROM SCM_MGR.GT_DMF3_RESULTS A
                JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                  ON A.V_DIVISION_ID  = B.DIVISION_ID
                 AND A.V_PROJECT_CODE = B.PROJECT_CODE
                 AND A.V_SCM_SITE_ID  = B.SCM_SITE_ID
                 AND A.V_ITEM_ID      = B.ITEM_ID
                JOIN SCM_MGR.GT_DMF3_ITEM_SINGLE_V C
                  ON A.V_DIVISION_ID  = C.DIVISION_ID
                 AND A.V_ITEM_ID      = C.ITEM_ID
                 AND C.ITEM_TYPE      = 'P'
                WHERE A.V_DIVISION_ID LIKE '81%'
                  AND (
                        ( NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                          OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0 )
                        OR B.ATTRIBUTE10 NOT IN (
                               SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y'
                           )
                        OR NVL(B.CELL_PER_CAR,0) <= 0
                      )
                ORDER BY A.V_ITEM_ID
                FETCH FIRST 1 ROW ONLY
            );
            IF V_DESC_81 IS NOT NULL THEN
                V_DESCRIPTION := V_DESC_81;
                V_LOG_TYPE    := 'INVALID';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
    END IF;
    -- END [C20220713-000194]

    -- [C20200804-000123] SSP 동기화 수량보다 작은 수량으로 수정 불가 ( 소형 & MKT FCST 메저 ) ------------ START
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40' AND V_MEASURE = 'MKT_FCST';

    IF V_CHECK_CNT > 0 THEN

        -- 아래에서 I/O 처리시 DELETE 후 INSERT 이므로 ATTRIBUTE를 보존하기 위해 업데이트
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    ( V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5 ) =
               ( SELECT B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.ATTRIBUTE5
                 FROM   SCM_MGR.DM_PLN_MKT_FCST B
                 WHERE  B.DIVISION_ID  = A.V_DIVISION_ID
                   AND  B.PROJECT_CODE = A.V_PROJECT_CODE
                   AND  B.SCM_SITE_ID  = A.V_SCM_SITE_ID
                   AND  B.ITEM_ID      = A.V_ITEM_ID
                   AND  B.DOM_EXP      = A.V_DOM_EXP
                   AND  B.FCST_TYPE    = A.V_FCST_TYPE
                   AND  B.INCOTERMS    = A.V_INCOTERMS
                   AND  B.MEASURE      = A.V_MEASURE
                   AND  B.YYYYMMDD     = A.V_YYYYMMDD
                   AND  B.MEASURE      = 'MKT_FCST'
                   AND  REGEXP_LIKE(NVL(B.ATTRIBUTE1,'-'), '^[0-9.]+$')
                   AND  B.DIVISION_ID  = V_DIVISION_ID
                   AND  EXISTS ( SELECT 1 FROM SCM_MGR.SCM_MST_SITE C
                                 WHERE B.DIVISION_ID = C.DIVISION_ID
                                   AND B.SCM_SITE_ID = C.SCM_SITE_ID
                                   AND C.VMI_YN <> 'Y' )
               );

        -- [C20210225-000385] 동기화 수량보다 작은 수량은 입력 불가(원복)
        INSERT INTO SCM_MGR.GT_DMF3_T_ERR
        ( PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, SYNC_QTY, QTY )
        SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS
             , A.V_MEASURE, A.V_YYYYMMDD
             , CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE2,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE2) ELSE 0 END
             + CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE3,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE3) ELSE 0 END
               AS SYNC_QTY
             , A.V_QTY
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE C
          ON   A.V_DIVISION_ID = C.DIVISION_ID
         AND   A.V_SCM_SITE_ID = C.SCM_SITE_ID
         AND   C.VMI_YN <> 'Y'
        WHERE  A.V_DIVISION_ID = V_DIVISION_ID
          AND  REGEXP_LIKE(NVL(A.V_ATTRIBUTE1,'-'), '^[0-9.]+$')
          AND  A.V_MEASURE     = 'MKT_FCST'
          AND  CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE2,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE2) ELSE 0 END
             + CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE3,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE3) ELSE 0 END
               > A.V_QTY
          AND  A.V_YYYYMMDD <> TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');

        DECLARE
            V_T_ERR_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_T_ERR_CNT FROM SCM_MGR.GT_DMF3_T_ERR;
            IF V_T_ERR_CNT > 0 THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := 'SSP 동기화 수량보다 작은 수량으로 수정된 건이 있습니다.';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;
    -- [C20200804-000123] END ------------

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG BOM 검증 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    --IF (SELECT count(1) FROM GT_DMF3_RESULTS where V_DIVISION_ID = '40') = 0  -- 20180914-1 주석처리
    BEGIN
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    V_BOM_YN = ''
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
                   WHERE  B.LOOKUP_TYPE    = 'AS_SITE_PLANT'
                     AND  B.SEGMENT3       = V_DIVISION_ID
                     AND  B.VALID_YN       = 'Y'
                     AND  A.V_ATTRIBUTE10  = B.SEGMENT2
               )
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_MST_ITEM_SN C
                   WHERE  C.DIVISION_ID = A.V_DIVISION_ID
                     AND  C.ITEM_ID     = A.V_ITEM_ID
               )
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
                   JOIN   SCM_MGR.SCM_MST_ITEM_SN CC
                     ON   CC.DIVISION_ID = A.V_DIVISION_ID
                    AND   CC.ITEM_ID     = A.V_ITEM_ID
                    AND   CC.EVAL_CLASS  = D.SEGMENT1
                   WHERE  D.LOOKUP_TYPE = 'DM_BOM_EXCEPT_CLASS'
                     AND  D.VALID_YN    = 'Y'
               )
          AND  A.V_DIVISION_ID = V_DIVISION_ID
          AND  A.V_MEASURE     = 'MKT_FCST';

        V_CHECK_CNT  := 0;
        SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_BOM_YN IS NULL;

        IF V_CHECK_CNT > 0 THEN
            V_VALID_BOM   := NULL;
            V_VALID_SHIPTO := NULL;

            BEGIN
                SELECT A.V_ITEM_ID INTO V_VALID_BOM
                FROM   SCM_MGR.GT_DMF3_RESULTS A
                JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V C
                  ON   A.V_ITEM_ID     = C.ITEM_ID
                 AND   A.V_DIVISION_ID = C.DIVISION_ID
                 AND   C.ITEM_TYPE     IN ('P','H')
                 AND   C.ACTIVE_FLAG   = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                LEFT   JOIN SCM_MGR.SCM_MST_BOM_ENG_SN X
                  ON   A.V_DIVISION_ID    = X.DIVISION_ID
                 AND   A.V_ITEM_ID        = X.PARENT_ITEM_ID
                LEFT   JOIN (
                                SELECT DIVISION_ID
                                     , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END AS FROM_SITE  -- 20180914 소형도 FROM_SITE 조건에 추가
                                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                                FROM  SCM_MGR.SCP_MST_BOD_V
                                WHERE PRIORITY = 1
                                GROUP BY DIVISION_ID
                                       , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END
                                       , TO_SITE, INCOTERMS  -- 20180914 소형도 FROM_SITE 조건에 추가
                            ) BOD
                  ON   A.V_DIVISION_ID   = BOD.DIVISION_ID
                 AND   A.V_PLANT_SITE_ID = BOD.FROM_SITE
                 AND   A.V_SCM_SITE_ID   = BOD.TO_SITE
                 AND   A.V_INCOTERMS     = BOD.INCOTERMS
                WHERE  A.V_MEASURE  IN ('MKT_FCST','Vmi_In_Req')
                  AND  A.V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
                  AND  A.V_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') + NVL(BOD.LT_TOTAL,0) + 70, 'YYYYMMDD')  -- 당주 월요일 + 11주 까지
                  AND  A.V_QTY      > 0
                  AND  X.PARENT_ITEM_ID IS NULL  -- 존재하지 않는대상
                  AND  A.V_ITEM_ID NOT IN ('ECE0074N5-01')  -- 20190614 김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
                  AND  A.V_ITEM_ID NOT IN ('MCCH120022B2-K','MCCH120022B2-GD')  -- 20190708 김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
                  AND  A.V_BOM_YN IS NULL
                  AND  ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN V_VALID_BOM := NULL;
            END;

            IF V_VALID_BOM IS NOT NULL THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[' || V_VALID_BOM || '] BOM does not exist !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG BOM 검증 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG SHIPTO 검증 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- IF (SELECT count(1) FROM GT_DMF3_RESULTS where V_DIVISION_ID = '40') = 0  -- 20180914-2 주석처리
    BEGIN
        BEGIN
            SELECT A.V_SCM_SITE_ID INTO V_VALID_SHIPTO
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER X
              ON   A.V_DIVISION_ID = X.DIVISION_ID
             AND   A.V_SCM_SITE_ID = X.SCM_SITE_ID
             AND   X.VALID_YN      = 'Y'
             AND   X.REP_YN        = 'Y'
            LEFT   JOIN (
                            SELECT DIVISION_ID
                                 , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END AS FROM_SITE  -- 20180914 소형도 FROM_SITE 조건에 추가
                                 , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                            FROM  SCM_MGR.SCP_MST_BOD_V
                            WHERE PRIORITY = 1
                            GROUP BY DIVISION_ID
                                   , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END
                                   , TO_SITE, INCOTERMS  -- 20180914 소형도 FROM_SITE 조건에 추가
                        ) BOD
              ON   A.V_DIVISION_ID   = BOD.DIVISION_ID
             AND   A.V_PLANT_SITE_ID = BOD.FROM_SITE
             AND   A.V_SCM_SITE_ID   = BOD.TO_SITE
             AND   A.V_INCOTERMS     = BOD.INCOTERMS
            WHERE  A.V_MEASURE  IN ('MKT_FCST','Vmi_In_Req')
              AND  A.V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
              AND  A.V_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') + NVL(BOD.LT_TOTAL,0) + 21, 'YYYYMMDD')   -- BOD LT + 4W
              AND  A.V_QTY      > 0
              AND  X.SHIPTO_CODE IS NULL
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_SHIPTO := NULL;
        END;

        IF V_VALID_SHIPTO IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_SHIPTO || '] SITE SHIP-TO does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG SHIPTO 검증 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 2021.4.20 hwi1993 [PJ20209642R]과제 - PR Request 가 존재하는 건들은 수정 못하도록 함. (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82' AND V_MEASURE = 'BNPIn';

    IF V_CHECK_CNT > 0 THEN

        INSERT INTO SCM_MGR.GT_DMF3_T_ERR2
        ( SCM_SITE_ID, ITEM_ID, FCST_TYPE, YYYYMMDD )
        SELECT DISTINCT B.SCM_SITE_ID, B.ITEM_ID, B.FCST_TYPE, B.YYYYMMDD
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.DM_PLN_PR_DETAIL B
          ON   A.V_DIVISION_ID   = B.DIVISION_ID
         AND   A.V_PROJECT_CODE  = B.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = B.SCM_SITE_ID
         AND   A.V_ITEM_ID       = B.ITEM_ID
         AND   A.V_DOM_EXP       = B.DOM_EXP
         AND   A.V_FCST_TYPE     = B.FCST_TYPE
         AND   A.V_INCOTERMS     = B.INCOTERMS
         AND   A.V_PLANT_SITE_ID = B.PLANT_SITE_ID
         AND   A.V_YYYYMMDD      = B.YYYYMMDD;

        DECLARE
            V_T_ERR2_CNT PLS_INTEGER := 0;
            V_ERR2_SCM   VARCHAR2(30 CHAR);
            V_ERR2_ITEM  VARCHAR2(50 CHAR);
            V_ERR2_FCST  VARCHAR2(20 CHAR);
            V_ERR2_YYYY  VARCHAR2(8 CHAR);
        BEGIN
            SELECT COUNT(1) INTO V_T_ERR2_CNT FROM SCM_MGR.GT_DMF3_T_ERR2;
            IF V_T_ERR2_CNT > 0 THEN
                SELECT SCM_SITE_ID, ITEM_ID, FCST_TYPE, YYYYMMDD
                INTO   V_ERR2_SCM, V_ERR2_ITEM, V_ERR2_FCST, V_ERR2_YYYY
                FROM   SCM_MGR.GT_DMF3_T_ERR2
                WHERE  ROWNUM = 1;
                V_ERR_CNT := V_T_ERR2_CNT;
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[Sales Site:' || RTRIM(V_ERR2_SCM)  || ']'
                              || '[Model :' || RTRIM(V_ERR2_ITEM) || ']'
                              || '[FCST Type :' || RTRIM(V_ERR2_FCST) || ']'
                              || '[YYYYMMDd :' || RTRIM(V_ERR2_YYYY) || ']'
                              || CASE WHEN V_ERR_CNT > 1 THEN '외 ' || TO_CHAR(V_ERR_CNT-1) || '건' ELSE ' ' END
                              || '은 기 Request 가 생성된 건입니다. \r\n ADD History 팝업을 이용해서 수정해주세요';
                V_INVALID := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;

    -- ATTRIBUTE9 가 '' 이 아닌 경우 수정불가 ( ESS )
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82' AND V_MEASURE = 'BNPIn';

    IF V_CHECK_CNT > 0 THEN
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    V_ATTRIBUTE9 = (
                   SELECT B.ATTRIBUTE9
                   FROM   SCM_MGR.DM_PLN_MKT_FCST B
                   WHERE  B.DIVISION_ID  = A.V_DIVISION_ID
                     AND  B.PROJECT_CODE = A.V_PROJECT_CODE
                     AND  B.SCM_SITE_ID  = A.V_SCM_SITE_ID
                     AND  B.ITEM_ID      = A.V_ITEM_ID
                     AND  B.DOM_EXP      = A.V_DOM_EXP
                     AND  B.FCST_TYPE    = A.V_FCST_TYPE
                     AND  B.INCOTERMS    = A.V_INCOTERMS
                     AND  B.MEASURE      = A.V_MEASURE
                     AND  B.YYYYMMDD     = A.V_YYYYMMDD
                     AND  B.MEASURE      = 'BNPIn'
                     AND  B.DIVISION_ID  = V_DIVISION_ID
               );

        DECLARE
            V_ATTR9_CNT PLS_INTEGER := 0;
            V_ATTR9_SCM VARCHAR2(30 CHAR);
            V_ATTR9_ITM VARCHAR2(50 CHAR);
            V_ATTR9_FCT VARCHAR2(20 CHAR);
            V_ATTR9_YYY VARCHAR2(8 CHAR);
        BEGIN
            SELECT COUNT(1) INTO V_ATTR9_CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS
            WHERE  NVL(V_ATTRIBUTE9,'-') <> '-';

            IF V_ATTR9_CNT > 0 THEN
                SELECT V_SCM_SITE_ID, V_ITEM_ID, V_FCST_TYPE, V_YYYYMMDD
                INTO   V_ATTR9_SCM, V_ATTR9_ITM, V_ATTR9_FCT, V_ATTR9_YYY
                FROM   SCM_MGR.GT_DMF3_RESULTS
                WHERE  NVL(V_ATTRIBUTE9,'-') <> '-'
                  AND  ROWNUM = 1;
                V_ERR_CNT     := V_ATTR9_CNT;
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[Sales Site:' || RTRIM(V_ATTR9_SCM) || ']'
                              || '[Model :' || RTRIM(V_ATTR9_ITM) || ']'
                              || '[FCST Type :' || RTRIM(V_ATTR9_FCT) || ']'
                              || '[YYYYMMDd :' || RTRIM(V_ATTR9_YYY) || ']'
                              || CASE WHEN V_ERR_CNT > 1 THEN '외 ' || TO_CHAR(V_ERR_CNT-1) || '건' ELSE ' ' END
                              || '은 기 Confirm ID 가 생성된 건입니다. \r\n ADD History 팝업을 이용해서 수정해주세요';
                V_INVALID := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 2021.4.20 hwi1993 [PJ20209642R] (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    --  INPUT MEASURE 중복값 delete후 INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎

    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    -- 3. MKT FCST 테이블 INSERT
    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

    --[E20250313-001251]_bucket = 'Monthly' or 'Weekly'인 경우 우선 데이터를 0으로 UPDATE를 한뒤 데이터 작업을 시작한다. START
    IF P_BUCKET = 'MONTHLY' THEN
        UPDATE SCM_MGR.DM_PLN_MKT_FCST A
        SET    A.QTY = 0
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF3_RESULTS R
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BR
                     ON   R.V_YYYYMMDD = BR.BASIS_YYYYMMDD
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BA
                     ON   A.YYYYMMDD = BA.BASIS_YYYYMMDD
                   WHERE  A.DIVISION_ID    = R.V_DIVISION_ID
                     AND  A.PROJECT_CODE   = R.V_PROJECT_CODE
                     AND  A.SCM_SITE_ID    = R.V_SCM_SITE_ID
                     AND  A.ITEM_ID        = R.V_ITEM_ID
                     AND  A.DOM_EXP        = R.V_DOM_EXP
                     AND  A.FCST_TYPE      = R.V_FCST_TYPE
                     AND  A.INCOTERMS      = R.V_INCOTERMS
                     AND  A.MEASURE        = R.V_MEASURE
                     AND  A.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                     AND  BA.BASIS_YYYYMM  = BR.BASIS_YYYYMM
               );
    ELSIF P_BUCKET = 'WEEKLY' THEN
        UPDATE SCM_MGR.DM_PLN_MKT_FCST A
        SET    A.QTY = 0
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF3_RESULTS R
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BR
                     ON   R.V_YYYYMMDD = BR.BASIS_YYYYMMDD
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BA
                     ON   A.YYYYMMDD = BA.BASIS_YYYYMMDD
                   WHERE  A.DIVISION_ID    = R.V_DIVISION_ID
                     AND  A.PROJECT_CODE   = R.V_PROJECT_CODE
                     AND  A.SCM_SITE_ID    = R.V_SCM_SITE_ID
                     AND  A.ITEM_ID        = R.V_ITEM_ID
                     AND  A.DOM_EXP        = R.V_DOM_EXP
                     AND  A.FCST_TYPE      = R.V_FCST_TYPE
                     AND  A.INCOTERMS      = R.V_INCOTERMS
                     AND  A.MEASURE        = R.V_MEASURE
                     AND  A.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                     AND  BA.BASIS_YYYYMM  = BR.BASIS_YYYYMM
                     AND  BA.ISO_YYYYWW    = BR.ISO_YYYYWW
               );
    END IF;
    --[E20250313-001251] END

    -- [] 81 -VMI 에 MKT FCST 가 있으면 VMI IN REQ 메저도 동일하게 생성/삭제한다.
    V_CHECK_CNT  := 0;
    SELECT COUNT(1)
    INTO   V_CHECK_CNT
    FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE B
          ON   A.V_SCM_SITE_ID = B.SCM_SITE_ID AND A.V_DIVISION_ID = B.DIVISION_ID AND B.VMI_YN = 'Y'
        WHERE  A.V_DIVISION_ID LIKE '81%'
          AND  A.V_MEASURE = 'MKT_FCST';

    IF V_CHECK_CNT > 0
    THEN
        INSERT INTO SCM_MGR.GT_DMF3_RESULTS
        ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
        , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
        , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
        SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
             , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'VMI_In_Req' AS V_MEASURE, V_PLANT_SITE_ID
             , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE B
          ON   A.V_SCM_SITE_ID = B.SCM_SITE_ID
         AND   A.V_DIVISION_ID = B.DIVISION_ID
         AND   B.VMI_YN        = 'Y'
        WHERE  A.V_DIVISION_ID LIKE '81%'
          AND  A.V_MEASURE     = 'MKT_FCST';
    END IF;

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS R
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = R.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = R.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = R.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = R.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = R.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = R.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = R.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.MEASURE        = R.V_MEASURE
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       = R.V_YYYYMMDD
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
         , V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
         , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5  -- [C20210225-000385]
         , NULL, NULL, NULL, NULL, V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_RESULTS;

    -----------------------------------------------------------------------
    -- [C20201103-000114] ESS 법인 MKT_FCST 메저에 따라 VMI_IN_REQ 자동 계산
    -----------------------------------------------------------------------
    FOR R_VMI IN CURSOR_ESSVMI1
    LOOP
        EV_DIVISION_ID   := R_VMI.V_DIVISION_ID;
        EV_SCM_SITE_ID   := R_VMI.V_SCM_SITE_ID;
        EV_PROJECT_CODE  := R_VMI.V_PROJECT_CODE;
        EV_ITEM_ID       := R_VMI.V_ITEM_ID;
        EV_DOM_EXP       := R_VMI.V_DOM_EXP;
        EV_FCST_TYPE     := R_VMI.V_FCST_TYPE;
        EV_INCOTERMS     := R_VMI.V_INCOTERMS;
        EV_PLANT_SITE_ID := R_VMI.V_PLANT_SITE_ID;

        -- 기초재고를 가져온다.
        EV_BINV := 0;
        BEGIN
            SELECT NVL(QTY,0) INTO EV_BINV
            FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
            WHERE  A.DIVISION_ID       = '82'
              AND  A.MEASURE           = 'VMI_Inv'
              AND  A.YYYYMMDD          = TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 8, 'YYYYMMDD')   -- 실적구간 마지막일자
              AND  A.SCM_SITE_ID       = EV_SCM_SITE_ID
              AND  A.PROJECT_CODE      = EV_PROJECT_CODE
              AND  A.ITEM_ID           = EV_ITEM_ID
              AND  A.DOM_EXP           = EV_DOM_EXP
              AND  A.FCST_TYPE         = EV_FCST_TYPE
              AND  A.INCOTERMS         = EV_INCOTERMS
              AND  A.PLANT_SITE_ID     = EV_PLANT_SITE_ID
              AND  A.CELL_PROD_SITE_ID = '-';  -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
        EXCEPTION
            WHEN NO_DATA_FOUND THEN EV_BINV := 0;
        END;

        -- 해당 SITE 의 미래구간의 VMI_IN_REQ 를 모두 지운다.
        DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A
        WHERE  A.DIVISION_ID  = '82'
          AND  A.MEASURE       = 'VMI_In_Req'
          AND  A.YYYYMMDD     >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 계획구간만
          AND  A.SCM_SITE_ID   = EV_SCM_SITE_ID
          AND  A.PROJECT_CODE  = EV_PROJECT_CODE
          AND  A.ITEM_ID       = EV_ITEM_ID
          AND  A.DOM_EXP       = EV_DOM_EXP
          AND  A.FCST_TYPE     = EV_FCST_TYPE
          AND  A.INCOTERMS     = EV_INCOTERMS
          AND  A.PLANT_SITE_ID = EV_PLANT_SITE_ID;

        -- 계산 및 INSERT
        INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
        , INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE
             , X.INCOTERMS, 'VMI_In_Req' AS MEASURE
             , TO_CHAR(TO_DATE(X.YYYYMMDD,'YYYYMMDD') - 0, 'YYYYMMDD')  -- MKT FCST 의 일자를 기준으로 집계했으므로 재고일수만큼 앞으로 밀어준다.
             , X.PLANT_SITE_ID
             , CASE WHEN ROW_NUM <= 0 THEN 0
                    WHEN ROW_NUM = 0 + 1 THEN CASE WHEN SUM_QTY > EV_BINV THEN SUM_QTY - EV_BINV ELSE 0 END
                    WHEN SUM_QTY > EV_BINV AND BF_SUM <= EV_BINV THEN SUM_QTY - EV_BINV
                    WHEN BF_SUM  > EV_BINV THEN QTY
                    ELSE 0
               END AS QTY
             , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
        FROM (
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
                 , A.INCOTERMS, A.YYYYMMDD, A.PLANT_SITE_ID
                 , SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD )                                              AS SUM_QTY
                 , SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS BF_SUM
                 , QTY
                 , ROW_NUMBER() OVER ( ORDER BY A.YYYYMMDD )                                            AS ROW_NUM
            FROM (
                SELECT A.BASIS_YYYYMMDD AS YYYYMMDD, 'MKT_FCST' AS MEASURE
                     , NVL(B.QTY, 0) AS QTY
                     , EV_DIVISION_ID  AS DIVISION_ID
                     , EV_SCM_SITE_ID  AS SCM_SITE_ID
                     , EV_PROJECT_CODE AS PROJECT_CODE
                     , EV_ITEM_ID      AS ITEM_ID
                     , EV_DOM_EXP      AS DOM_EXP
                     , EV_FCST_TYPE    AS FCST_TYPE
                     , EV_INCOTERMS    AS INCOTERMS
                     , EV_PLANT_SITE_ID AS PLANT_SITE_ID
                FROM  SCM_MGR.SCM_SYS_CALENDAR_M A
                LEFT  JOIN SCM_MGR.DM_PLN_MKT_FCST B
                  ON  A.BASIS_YYYYMMDD  = B.YYYYMMDD
                 AND  B.MEASURE         = 'MKT_FCST'
                 AND  B.DIVISION_ID     = '82'
                 AND  B.SCM_SITE_ID     = EV_SCM_SITE_ID
                 AND  B.PROJECT_CODE    = EV_PROJECT_CODE
                 AND  B.ITEM_ID         = EV_ITEM_ID
                 AND  B.DOM_EXP         = EV_DOM_EXP
                 AND  B.FCST_TYPE       = EV_FCST_TYPE
                 AND  B.INCOTERMS       = EV_INCOTERMS
                 AND  B.PLANT_SITE_ID   = EV_PLANT_SITE_ID
                WHERE A.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 계획구간만
                  AND A.BASIS_YYYYMMDD <= TO_CHAR(
                          TO_DATE(TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD'),'YYYYMMDD')
                          + CASE WHEN 0 > 0 THEN 0 + 1 ELSE 0 + 10 END + 7*84
                        , 'YYYYMMDD')
                -- [C20201217-000126], [C20210811-000230] 62주에서 92주로 확장(MKT FCST 메저 기준), [C20210817-000420]
            ) A
        ) X
        WHERE CASE WHEN ROW_NUM <= 0 THEN 0
                   WHEN ROW_NUM = 0 + 1 THEN CASE WHEN SUM_QTY > EV_BINV THEN SUM_QTY - EV_BINV ELSE 0 END
                   WHEN SUM_QTY > EV_BINV AND BF_SUM <= EV_BINV THEN SUM_QTY - EV_BINV
                   WHEN BF_SUM  > EV_BINV  THEN QTY
                   ELSE 0
              END > 0;

    END LOOP;

    -------------------------------------------------------------------------------------◎◎◎◎
    -- HISTORY INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
    , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT V_DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
         , V_YYYYMMDD, V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY
         , SYSDATE, NULL, NULL, NULL, NULL, NULL
         , NULL, NULL, NULL, NULL, V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_RESULTS;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- HISTORY INSERT (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_MST_CUSTOMER_FCST map create (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP
    ( DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY )
    SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.MEASURE
         , A.SUMMARY_BUCKET_VALUE AS START_DAY
         , CASE WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY'
                THEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE,'YYYYMMDD'),'SUN'),'YYYYMMDD')
                ELSE A.SUMMARY_BUCKET_VALUE
           END AS END_DAY
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID
           FROM   SCM_MGR.GT_DMF3_RESULTS
           WHERE  V_MEASURE NOT IN ('MKT_FCST','RTF')  -- 20181121 KHSONG MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
         ) RSLT
      ON  A.DIVISION_ID = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID = RSLT.V_SCM_SITE_ID
    WHERE A.VALID_YN           = 'Y'
      AND A.MEASURE_GROUP      = 'CUST_FCST'
      AND A.PLAN_WEEK          = (SELECT MAX(PLAN_WEEK) FROM SCM_MGR.DM_MST_CUSTOMER_FCST)
      AND A.SUMMARY_BUCKET_VALUE >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 당주 월요일 이후데이터만
      AND A.SUMMARY_BUCKET_TYPE IN ('DAILY','WEEKLY')
    UNION ALL
    SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.MEASURE
         , CASE WHEN A.SUMMARY_BUCKET_VALUE = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE,-1))+1,'YYYYMMDD')
                THEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
                ELSE A.SUMMARY_BUCKET_VALUE
           END AS START_DAY
         , TO_CHAR(LAST_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE,'YYYYMMDD')),'YYYYMMDD') AS END_DAY
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID
           FROM   SCM_MGR.GT_DMF3_RESULTS
           WHERE  V_MEASURE NOT IN ('MKT_FCST','RTF')
         ) RSLT
      ON  A.DIVISION_ID = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID = RSLT.V_SCM_SITE_ID
    WHERE A.VALID_YN           = 'Y'
      AND A.MEASURE_GROUP      = 'CUST_FCST'
      AND A.PLAN_WEEK          = (SELECT MAX(PLAN_WEEK) FROM SCM_MGR.DM_MST_CUSTOMER_FCST)
      AND A.SUMMARY_BUCKET_VALUE >= TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD')
      AND A.SUMMARY_BUCKET_TYPE IN ('MONTHLY');
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_MST_CUSTOMER_FCST map create (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_TMP_MKT_FCST
    ( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
    , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
    , V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY )
    SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                  , A.FCST_TYPE, A.INCOTERMS, 'CUST_FCST', A.PLANT_SITE_ID, A.YYYYMMDD
                  , A.QTY, A.CREATED_BY, A.LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID, V_ITEM_ID, V_INCOTERMS
                         , V_PLANT_SITE_ID, V_PROJECT_CODE, V_DOM_EXP, V_FCST_TYPE, V_ATTRIBUTE10
           FROM  SCM_MGR.GT_DMF3_RESULTS
         ) RSLT
      ON  A.DIVISION_ID   = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
     AND  A.ITEM_ID        = RSLT.V_ITEM_ID
     AND  A.INCOTERMS      = RSLT.V_INCOTERMS
     AND  A.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
     AND  A.PROJECT_CODE   = RSLT.V_PROJECT_CODE
     AND  A.DOM_EXP        = RSLT.V_DOM_EXP
     AND  A.FCST_TYPE      = RSLT.V_FCST_TYPE
    JOIN (
        SELECT DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
        FROM   SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP
        GROUP  BY DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
    ) MAP
      ON  A.DIVISION_ID = MAP.DIVISION_ID
     AND  A.SCM_SITE_ID = MAP.SCM_SITE_ID
     AND  A.MEASURE     = MAP.MEASURE
    WHERE A.YYYYMMDD BETWEEN MAP.START_DAY AND MAP.END_DAY
      AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_TMP_MKT_FCST T
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = T.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = T.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = T.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = T.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = T.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = T.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = T.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.MEASURE        = T.V_MEASURE
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = T.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE10 )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
         , V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
         , V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_TMP_MKT_FCST;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    PLAN_START_YYYYMMDD := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  MEASURE  = 'RTF_SYS_RP'  -- 20200427 변경
      AND  YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      -- modified by ytchoi 20180813
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = RSLT.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = RSLT.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = RSLT.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = RSLT.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= PLAN_START_YYYYMMDD
                 AND  ITEM.ACTIVE_FLAG = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 AND  ( ITEM.ITEM_TYPE IN ('Q','R')
                     OR RSLT.V_ITEM_ID IN (
                            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                            WHERE K.DIVISION_ID = RSLT.V_DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                        )
                      )  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
                 --AND DM_PLN_MKT_FCST.DIVISION_ID IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895]
                 AND  DM_PLN_MKT_FCST.DIVISION_ID IN ('82')  -- 20190709 KHSONG [CSR ID:4034895]
                 --[E20241211-000856] END
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
    , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
         , A.INCOTERMS
         --, 'RTF'
         , 'RTF_SYS_RP'  -- 20200427 변경
         , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
         , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
         , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  A.MEASURE   = 'MKT_FCST'
      AND  A.YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      -- modified by ytchoi 20180813
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  A.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  A.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  A.ITEM_ID       = RSLT.V_ITEM_ID
                 AND  A.DOM_EXP       = RSLT.V_DOM_EXP
                 AND  A.FCST_TYPE     = RSLT.V_FCST_TYPE
                 AND  A.INCOTERMS     = RSLT.V_INCOTERMS
                 AND  A.PLANT_SITE_ID = RSLT.V_PLANT_SITE_ID
                 AND  ITEM.ACTIVE_FLAG = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 AND  ( ITEM.ITEM_TYPE IN ('Q','R')
                     OR RSLT.V_ITEM_ID IN (
                            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                            WHERE K.DIVISION_ID = RSLT.V_DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                        )
                      )  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
                 --AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895]
                 AND  A.DIVISION_ID IN ('82')  -- 20190709 KHSONG [CSR ID:4034895]
                 --[E20241211-000856] END
           );
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우에 RTF를 MKT_FCST와 동일하게 생성 조건추가 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    PLAN_START_YYYYMMDD := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  MEASURE  = 'RTF_SYS_RP'  -- 20200507 변경
      AND  YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = RSLT.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = RSLT.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = RSLT.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = RSLT.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= PLAN_START_YYYYMMDD
                 AND  ITEM.ACTIVE_FLAG  = 'Y'
                 AND  RSLT.V_FCST_TYPE  = 'RMA'
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
    , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
         , A.INCOTERMS
         --, 'RTF'
         , 'RTF_SYS_RP'  -- 20200507 변경
         , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
         , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
         , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  A.MEASURE   = 'MKT_FCST'
      AND  A.YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  A.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  A.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  A.ITEM_ID       = RSLT.V_ITEM_ID
                 AND  A.DOM_EXP       = RSLT.V_DOM_EXP
                 AND  A.FCST_TYPE     = RSLT.V_FCST_TYPE
                 AND  A.INCOTERMS     = RSLT.V_INCOTERMS
                 AND  A.PLANT_SITE_ID = RSLT.V_PLANT_SITE_ID
                 AND  ITEM.ACTIVE_FLAG = 'Y'
                 AND  RSLT.V_FCST_TYPE = 'RMA'
           );
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 KHSONG 소형 반품예정수량(RMA) (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- BALANCE_CREATE 호출 로직 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_SEND_TARGET_DATA
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, PLANT_SITE_ID
    , CELL_PROD_SITE_ID  -- [PJ2025-00188]
    , VMI_YN )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
         , '-' AS CELL_PROD_SITE_ID  -- [PJ2025-00188] 그외는 - 로 처리
         , '' AS VMI_YN             -- vmi_yn 초기값
    FROM   SCM_MGR.GT_DMF3_RESULTS
    GROUP  BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
            , V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID;

    SELECT DIVISION_ID INTO V_C_DIVISION_ID
    FROM   SCM_MGR.GT_DMF3_SEND_TARGET_DATA
    WHERE  ROWNUM = 1;

    -- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (START)
    -- 2026.04.06   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
    -- 2026.04.06 POC 테스트를 위해 임시 막음. PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE이 참조 작업이 너무 많아 일단 막음
    -- SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(V_C_DIVISION_ID, P_PLAN_ID => 'CALL');
    -- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (END)

    -------------------------------------------------------------------------------------◎◎◎◎
    -- BALANCE_CREATE 호출 로직 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    --[E20230608-000891]MKT FCST, Sales Plan 동일 Measure 실시간 연동건 [START]
    IF V_DIVISION_ID = '82' THEN
        PKG_DMF0003.P_DMF0003_MKT_FCST_SALES_PLAN_SYNC(V_DIVISION_ID, V_CREATED_BY, V_R_CURSOR);
        IF V_R_CURSOR%ISOPEN THEN
            CLOSE V_R_CURSOR;
        END IF;
    END IF;
    --[E20230608-000891] [END]

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180816 KHSONG DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- SCP가 Open 했기 때문에 RTF 값을 MKT FCST에서 수정하지 않음.
    V_CHECK_CNT := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40';

    IF V_CHECK_CNT > 0 THEN
        SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180816 KHSONG DIVISION_ID = '40' (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -----------------------------------------------------------------------
    -- DMF0070_SAVE_QTY_PR_DETAIL_AUTO 호출
    -----------------------------------------------------------------------
    -- MKT FCST 수정시 PR_DETAIL_AUTO 수량도 업데이트--KJJ 2024.02.05
    /*
    EXEC dbo.DMF0070_SAVE_QTY_PR_DETAIL_AUTO
        @p_division_id  ,
        @p_project_code,
        @p_scm_site_id,
        @p_item_id,
        @p_dom_exp,
        @p_fcst_type,
        @p_incoterms,
        @p_plant_site_id,
        @p_yyyymmdd ,
        @p_qty
        */
    /* 2026.04.06   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
       DMF0070 기능 미사용 DMF0070_SAVE_QTY_PR_DETAIL_AUTO 작업 호출 안 함
    SCM_MGR.DMF0070_SAVE_QTY_PR_DETAIL_AUTO(
        V_DIVISION_ID,
        V_PROJECT_CODE,
        V_SCM_SITE_ID,
        V_ITEM_ID,
        V_DOM_EXP,
        V_FCST_TYPE,
        V_INCOTERMS,
        V_PLANT_SITE_ID,
        V_YYYYMMDD,
        V_QTY
    ); */

    -- COMMIT은 프로시저 종료 직전 1회만 수행
    COMMIT;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    RETURN;

    -- 트랜잭션 (END)
    <<ERR_RTN>>
    IF V_LOG_TYPE = 'INVALID' THEN

        V_LOG_MESSAGE := '########## END of procedure ##########';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'END', N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[C20200804-000123]
        V_CHECK_CNT := 0;
        SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40';

        IF V_CHECK_CNT > 0 THEN
            OPEN O_RC1 FOR
            SELECT A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD
                , A.SYNC_QTY, A.QTY
            FROM SCM_MGR.GT_DMF3_T_ERR A
            ORDER BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD;

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_DESCRIPTION AS MSG , '0' AS EVENT FROM DUAL;
        ELSE
            OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_DESCRIPTION AS MSG , '0' AS EVENT FROM DUAL;
        END IF;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF V_R_CURSOR%ISOPEN THEN
            CLOSE V_R_CURSOR;
        END IF;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'   VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_PROJECT_CODE'  VALUE P_PROJECT_CODE,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_ITEM_ID'       VALUE P_ITEM_ID,
            'P_DOM_EXP'       VALUE P_DOM_EXP,
            'P_FCST_TYPE'     VALUE P_FCST_TYPE,
            'P_INCOTERMS'     VALUE P_INCOTERMS,
            'P_MEASURE'       VALUE P_MEASURE,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_YYYYMMDD'      VALUE P_YYYYMMDD,
            'P_QTY'           VALUE P_QTY,
            'P_CREATED_BY'    VALUE P_CREATED_BY,
            'P_AS_FROM_SITE'  VALUE P_AS_FROM_SITE,
            'P_BUCKET'        VALUE P_BUCKET
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END DMF0003_SAVE_MKT_FCST;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_SAVE_PRPOPUP (
	  p_POPUP_TYPE			VARCHAR2
	, p_ITEM_SEQ			VARCHAR2
	, p_DIVISION_ID		    VARCHAR2
	, p_PROJECT_CODE		VARCHAR2
	, p_SCM_SITE_ID		    VARCHAR2
	, p_ITEM_ID			    VARCHAR2
	, p_DOM_EXP			    VARCHAR2
	, p_FCST_TYPE			VARCHAR2
	, p_INCOTERMS			VARCHAR2
	, p_PLANT_SITE_ID		VARCHAR2
	, p_YYYYMMDD			VARCHAR2
	, p_UOM				    VARCHAR2
	, p_PLAN_QTY			VARCHAR2
	, p_STORAGE_ID			VARCHAR2
	, p_STORAGE_PLANT_ID	VARCHAR2
	, p_PUCH_MGR			VARCHAR2
	, p_PUCH_GROUP			VARCHAR2
	, p_PR_HEADER			VARCHAR2
	, p_PR_ITEM_DETAIL		VARCHAR2
	, p_CREATED_BY			VARCHAR2

)
AS;
/
