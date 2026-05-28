/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0005.sql
 * Description  : Standalone Procedures — DMF0005 화면 (5개)
 *              : 향후 PKG_DMF0005로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0005_GET_OWNERINFO
(

	V_Search		    VARCHAR2
   ,V_Language		VARCHAR2  DEFAULT 'KO'
   --,V_SSOUserYN      VARCHAR2  DEFAULT ''
   ,p_created_by   VARCHAR2

/* 20180704 creation
** 20180723 MODIFY
** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
**
**
**
*/
)
AS

    v_group_id VARCHAR2(50 CHAR);
    v_cnt_1  INTEGER := 0;
BEGIN

	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	-- ------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND VALID_YN = 'Y'
	AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
	AND SEGMENT1 = p_created_by;
	IF v_cnt_1 > 0 THEN
			v_group_id := 'ADMIN';
		END IF;
	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	-- ------------------------------------------------------------------------------
	SELECT DISTINCT  A.user_id UserID
		,A.user_name UserName
		,A.user_name_en	UserName_E
		,A.dept_id
		,CASE V_Language WHEN 'KO' THEN B.dept_name_ko
						WHEN 'EN' THEN B.dept_name_en
						WHEN 'CN' THEN B.dept_name_cn
			END dept_name
	FROM SCM_MST_SSO_USER_INFO A
	INNER JOIN SCM_MST_SSO_DEPT_INFO B
	ON A.DEPT_ID = B.DEPT_ID
	AND B.DEPT_ID in (
	                    select dept_id
						  from TB_FX_User zz
						  where zz.dept_id = B.dept_id
	                  )
	INNER JOIN (SELECT USER_ID, DEPT_ID FROM SCM_MST_SSO_USER_INFO  ) C ON A.DEPT_ID = C.DEPT_ID
	WHERE A.ACTIVE_FLAG != 'D'

	--AND C.USER_ID = CASE WHEN ( SELECTw.DefaultGroupID FROM TB_FX_User w   where w.USERID = p_created_by  ) like '%ADMIN'THEN C.USER_ID ELSE p_created_by END

	AND C.USER_ID = CASE WHEN v_group_id = 'ADMIN' THEN C.USER_ID ELSE p_created_by END  --20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리

	-- AND C.USER_ID = p_created_by   --추가, 20180704
		AND (
			   (V_Search IS NULL OR A.user_id LIKE '%'  ||  V_Search  ||  '%')
			OR (V_Search IS NULL OR A.user_name LIKE '%'  ||  V_Search  ||  '%')
			OR (V_Search IS NULL OR A.user_name_en LIKE '%'  ||  V_Search  ||  '%')
			)

FETCH FIRST 1 ROWS ONLY
END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0005_SAVE_MODEL_CHANGE_POPUP
(
	p_item_id_before		VARCHAR2,
	p_item_id_after		VARCHAR2,
	p_last_updated_by		VARCHAR2
/*
 *===================================================================================================
 * Program ID   : DMF0005_SAVE_MODEL_CHANGE_POPUP
 * Description  : ITEM_ID 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *	2022.01.05	rosia27			[C20220103-000584]소형 패커 관련하여 코드 변경 관리
 *	2022.02.03	rosia27			[C20220121-000372]소형사업부 Model Code Change 적용
 *===================================================================================================
 */
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:08
 * 파일: dbo.DMF0005_SAVE_MODEL_CHANGE_POPUP.sql
 * ----------------------------------------
 * ⚠ IF: IF:49  END IF:46  차이:+3
 * ⚠ BEGIN: BEGIN:6  END:5  차이:+1
 * ----------------------------------------
 * BEGIN 위치: L82, L129, L134, L146, L174, L214
 * END;  위치: L172, L191, L194, L223, L1553
 * ----------------------------------------
 * 힌트: BEGIN이 1개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    s_item_id_before VARCHAR2(4000 CHAR);
    s_item_id_after VARCHAR2(4000 CHAR);
    s_last_updated_by VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := 'DMF0005_SAVE_MODEL_CHANGE_POPUP';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_insert_count INTEGER := 0;
    n_logo_count INTEGER := 0;
    v_index_item_id_before INTEGER;
    v_index_item_id_after INTEGER;
    v_index_last_updated_by INTEGER;
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
    v_cnt_3  INTEGER := 0;
    v_cnt_4  INTEGER := 0;
    v_cnt_5  INTEGER := 0;
    v_cnt_6  INTEGER := 0;
    v_cnt_7  INTEGER := 0;
    v_cnt_8  INTEGER := 0;
    v_cnt_9  INTEGER := 0;
    v_cnt_10  INTEGER := 0;
    v_cnt_11  INTEGER := 0;
    v_cnt_12  INTEGER := 0;
    v_cnt_13  INTEGER := 0;
    v_cnt_14  INTEGER := 0;
    v_cnt_15  INTEGER := 0;
    v_cnt_16  INTEGER := 0;
    v_cnt_17  INTEGER := 0;
    v_cnt_18  INTEGER := 0;
    v_cnt_19  INTEGER := 0;
    v_cnt_20  INTEGER := 0;
    v_cnt_21  INTEGER := 0;
    v_cnt_22  INTEGER := 0;
    v_cnt_23  INTEGER := 0;
    v_cnt_24  INTEGER := 0;
    v_cnt_25  INTEGER := 0;
    v_cnt_26  INTEGER := 0;
    v_cnt_27  INTEGER := 0;
    v_cnt_28  INTEGER := 0;
    v_cnt_29  INTEGER := 0;
    v_cnt_30  INTEGER := 0;
    v_cnt_31  INTEGER := 0;
    v_cnt_32  INTEGER := 0;
    v_cnt_33  INTEGER := 0;
    v_cnt_34  INTEGER := 0;
    v_cnt_35  INTEGER := 0;
    v_cnt_36  INTEGER := 0;
    v_cnt_37  INTEGER := 0;
    v_cnt_38  INTEGER := 0;
    v_cnt_39  INTEGER := 0;
    v_cnt_40  INTEGER := 0;
    v_cnt_41  INTEGER := 0;
    v_cnt_42  INTEGER := 0;
    v_cnt_43  INTEGER := 0;
    v_cnt_44  INTEGER := 0;
    v_cnt_45  INTEGER := 0;
BEGIN
DBMS_OUTPUT.PUT_LINE('1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	        	-- 스플릿관련 변수



	s_item_id_before := NULL;
	s_item_id_after := NULL;
	s_last_updated_by := NULL;

	-- 마지막 데이터 처리를 위한 구분자 추가
	p_item_id_before := RTRIM(p_item_id_before					)  ||  '^';
	p_item_id_after := RTRIM(p_item_id_after					)  ||  '^';
	p_last_updated_by := RTRIM(p_last_updated_by					)  ||  '^';

	-- GT_DMF0_results_MST TEMP TABLE
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_results_MST';

	-- GT_DMF0_results_insert TEMP TABLE
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_results_insert';

	-- LOG 용 변수 설정









	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 시작 LOG  (END)
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/


	BEGIN TRY

	--------------------------------------------------------------------------------------------◇◇◇◇
	--          GT_DMF0_results_MST 테이블에 split후 insert (BEGIN)
	--------------------------------------------------------------------------------------------◇◇◇◇
DBMS_OUTPUT.PUT_LINE('2--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	BEGIN  --split

		WHILE LENGTH(p_item_id_before) > 0

		---------------------------(2)
		BEGIN  -- WHILE
		---------------------------(2)



			v_index_item_id_before := PATINDEX('%'  ||  '^'  ||  '%', p_item_id_before			);
			v_index_item_id_after := PATINDEX('%'  ||  '^'  ||  '%', p_item_id_after			);
			v_index_last_updated_by := PATINDEX('%'  ||  '^'  ||  '%', p_last_updated_by		);

			---------------------------(1)
			IF LENGTH(v_index_item_id_before) > 0
			---------------------------(1)
				BEGIN
					--문자열 자르기(0 ~ INDEX)
					s_item_id_before := SUBSTR(p_item_id_before			, 0, v_index_item_id_before		);
					s_item_id_after := SUBSTR(p_item_id_after			, 0, v_index_item_id_after		);
					s_last_updated_by := SUBSTR(p_last_updated_by			, 0, v_index_last_updated_by		);

					--문자열 자르기(^ ~ END)
					p_item_id_before := SUBSTR(p_item_id_before			, LENGTH(s_item_id_before			  ||  '^') || 1, LENGTH(p_item_id_before			));
					p_item_id_after := SUBSTR(p_item_id_after			, LENGTH(s_item_id_after			  ||  '^') || 1, LENGTH(p_item_id_after			));
					p_last_updated_by := SUBSTR(p_last_updated_by			, LENGTH(s_last_updated_by			  ||  '^') || 1, LENGTH(p_last_updated_by			));

					-- 공백제거(START)
					s_item_id_before := RTRIM(LTRIM(s_item_id_before			));
					s_item_id_after := RTRIM(LTRIM(s_item_id_after			));
					s_last_updated_by := RTRIM(LTRIM(s_last_updated_by		));
					-- 공백제거(END)

					INSERT INTO GT_DMF0_results_MST (;
											  item_id_before
											 ,item_id_after
											 ,last_updated_by
					) VALUES (
											  s_item_id_before
											 ,s_item_id_after
											 ,s_last_updated_by
					)
				END
			ELSE
				BEGIN
					-- 공백제거(START)
					s_item_id_before := RTRIM(LTRIM(s_item_id_before			));
					s_item_id_after := RTRIM(LTRIM(s_item_id_after			));
					s_last_updated_by := RTRIM(LTRIM(s_last_updated_by		));
					-- 공백제거(END)

					INSERT INTO GT_DMF0_results_MST (;
											  item_id_before
											 ,item_id_after
											 ,last_updated_by
					) VALUES (
											  s_item_id_before
											 ,s_item_id_after
											 ,s_last_updated_by
					)
			---------------------------(1)
				END
			---------------------------(1)
		---------------------------(2)
		END  -- WHILE
		---------------------------(2)

		UPDATE A
		SET DATA_SEQ = NVL(B.DATA_SEQ, 0) || 1
		FROM GT_DMF0_results_MST A
		LEFT OUTER JOIN (
						SELECT A.BEFORE_CODE, A.AFTER_CODE, MAX(A.DATA_SEQ) AS DATA_SEQ
						FROM DM_DNM_ITEM_CODE_CHANGE_HISTORY A
						GROUP BY A.BEFORE_CODE, A.AFTER_CODE
						) B  ON A.ITEM_ID_BEFORE = B.BEFORE_CODE AND A.ITEM_ID_AFTER= B.AFTER_CODE

DBMS_OUTPUT.PUT_LINE('3--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		---------VALIDATION CHECK START----------------------------------------
		--VALIDATION CHECK : 문자 길이가 12자리인지
		SELECT COUNT(1)
		INTO v_cnt_1
		FROM GT_DMF0_results_MST WHERE LENGTH(ITEM_ID_BEFORE) <> 12;
		IF v_cnt_1 > 0
		BEGIN
			SELECT /*__INTO_v_description__*/ 'Model 코드의 자리수가 12자리가 아니므로 변경할 수 없습니다.'  ||  char(10)  ||  'MODEL : '  ||  ITEM_ID_BEFORE
			FROM GT_DMF0_results_MST
			WHERE LENGTH(ITEM_ID_BEFORE) <> 12

			SELECT v_description
			v_log_type := 'INVALID';
			GOTO ERR_RTN
			FROM DUAL;
		END;

		SELECT COUNT(1)
		INTO v_cnt_2
		FROM GT_DMF0_results_MST WHERE LENGTH(ITEM_ID_AFTER) <> 12;
		IF v_cnt_2 > 0 THEN
			SELECT /*__INTO_v_description__*/ 'Model 코드의 자리수가 12자리가 아니므로 변경할 수 없습니다.'  ||  char(10)  ||  'MODEL : '  ||  ITEM_ID_AFTER
			FROM GT_DMF0_results_MST
			WHERE LENGTH(ITEM_ID_AFTER) <> 12

			SELECT v_description
			v_log_type := 'INVALID';
			GOTO ERR_RTN
			FROM DUAL;
		END IF;

		-- VALIDATION CHECK : 앞의 11자리가 같은지
		SELECT COUNT(1)
		INTO v_cnt_3
		FROM GT_DMF0_results_MST WHERE SUBSTR(item_id_before, 1, 11) <> SUBSTR(item_id_after, 1, 11);
		IF v_cnt_3 > 0 THEN
			SELECT /*__INTO_v_description__*/ 'Model 코드의 앞 11자리가 서로 다르므로 변경할 수 없습니다.'  ||   'MODEL : '  ||  ITEM_ID_BEFORE  ||  ', '  ||  ITEM_ID_AFTER
			FROM GT_DMF0_results_MST
			WHERE SUBSTR(item_id_before, 1, 11) <> SUBSTR(item_id_after, 1, 11)

			SELECT v_description
			v_log_type := 'INVALID';
			GOTO ERR_RTN
			FROM DUAL;
		END IF;

		-- VALIDATION CHECK : 맨앞의 두글자가 MP인지
		SELECT COUNT(1)
		INTO v_cnt_4
		FROM GT_DMF0_results_MST WHERE SUBSTR(item_id_before, 1, 2) <> 'MP';
		IF v_cnt_4 > 0 THEN
			SELECT /*__INTO_v_description__*/ 'Model 코드가 ''MP''로 시작하지 않는 코드는 변경할 수 없습니다.'  ||   'MODEL : '  ||  ITEM_ID_BEFORE
			FROM GT_DMF0_results_MST
			WHERE SUBSTR(item_id_before, 1, 2) <> 'MP'

			SELECT v_description
			v_log_type := 'INVALID';
			GOTO ERR_RTN
			FROM DUAL;
		END IF;

		SELECT COUNT(1)
		INTO v_cnt_5
		FROM GT_DMF0_results_MST WHERE SUBSTR(item_id_after, 1, 2) <> 'MP';
		IF v_cnt_5 > 0 THEN
			SELECT /*__INTO_v_description__*/ 'Model 코드가 ''MP''로 시작하지 않는 코드는 변경할 수 없습니다.'  ||   'MODEL : '  ||  ITEM_ID_AFTER
			FROM GT_DMF0_results_MST
			WHERE SUBSTR(item_id_after, 1, 2) <> 'MP'

			SELECT v_description
			v_log_type := 'INVALID';
			GOTO ERR_RTN
			FROM DUAL;
		END IF;

		-- VALIDATION CHECK : 12번째 글자가 다른지
		SELECT COUNT(1)
		INTO v_cnt_6
		FROM GT_DMF0_results_MST WHERE item_id_before = item_id_after;
		IF v_cnt_6 > 0 THEN
			SELECT /*__INTO_v_description__*/ '변경전 후의 모델코드가 동일합니다.'  ||   'MODEL : '  ||  item_id_before
			FROM GT_DMF0_results_MST
			WHERE item_id_before = item_id_after

			SELECT v_description
			v_log_type := 'INVALID';
			GOTO ERR_RTN
			FROM DUAL;
		END IF;

		-- VALIDTION CHECK : 12번째가 N, C인 값이 동시 존재하고 있는지
		SELECT COUNT(1)
		INTO v_cnt_7
		FROM GT_DMF0_results_MST A
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID_BEFORE = B.ITEM_ID AND B.DIVISION_ID = '40'
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID_AFTER = C.ITEM_ID AND C.DIVISION_ID = '40'
		WHERE B.ITEM_ID IS NULL
		OR C.ITEM_ID IS NULL;
		IF v_cnt_7 > 0 THEN
			SELECT /*__INTO_v_description__*/ CASE WHEN B.ITEM_ID IS NULL THEN A.ITEM_ID_BEFORE ELSE A.ITEM_ID_AFTER END   ||  '은 존재하지 않는 코드입니다.'
			FROM GT_DMF0_results_MST A
			LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID_BEFORE = B.ITEM_ID AND B.DIVISION_ID = '40'
			LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID_AFTER = C.ITEM_ID AND C.DIVISION_ID = '40'
			WHERE B.ITEM_ID IS NULL
				OR C.ITEM_ID IS NULL

			SELECT v_description
			v_log_type := 'INVALID';
			GOTO ERR_RTN
			FROM DUAL;
		END IF;

		---------VALIDATION CHECK END----------------------------------------

DBMS_OUTPUT.PUT_LINE('4--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		---------TABLE UPDATE START------------------------------------------

		-- DM_ANL_KPI_RTF_DEMAND UPDATE
		SELECT COUNT(1)
		INTO v_cnt_8
		FROM DM_ANL_KPI_RTF_DEMAND A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_8 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_ANL_KPI_RTF_DEMAND' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_ANL_KPI_RTF_DEMAND A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_ANL_KPI_RTF_DEMAND A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
			END IF;

		-- DM_ANL_KPI_RTF_SALES UPDATE
		SELECT COUNT(1)
		INTO v_cnt_9
		FROM DM_ANL_KPI_RTF_SALES A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_9 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_ANL_KPI_RTF_SALES' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_ANL_KPI_RTF_SALES A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_ANL_KPI_RTF_SALES A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_ANL_KPI_SALES_ACCURACY UPDATE
		SELECT COUNT(1)
		INTO v_cnt_10
		FROM DM_ANL_KPI_SALES_ACCURACY A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_10 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_ANL_KPI_SALES_ACCURACY' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_ANL_KPI_SALES_ACCURACY A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_ANL_KPI_SALES_ACCURACY A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_ANL_KPI_SUMMARY UPDATE
		SELECT COUNT(1)
		INTO v_cnt_11
		FROM DM_ANL_KPI_SUMMARY A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_11 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_ANL_KPI_SUMMARY' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_ANL_KPI_SUMMARY A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_ANL_KPI_SUMMARY A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_DNM_EDI_CALLOFF_ITEM UPDATE
		SELECT COUNT(1)
		INTO v_cnt_12
		FROM DM_DNM_EDI_CALLOFF_ITEM A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_12 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_DNM_EDI_CALLOFF_ITEM' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_DNM_EDI_CALLOFF_ITEM A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_DNM_EDI_CALLOFF_ITEM A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_DNM_SALES_RESULT_IF UPDATE
		SELECT COUNT(1)
		INTO v_cnt_13
		FROM DM_DNM_SALES_RESULT_IF A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_13 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_DNM_SALES_RESULT_IF' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_DNM_SALES_RESULT_IF A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_DNM_SALES_RESULT_IF A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_HI_CUST_FCST_INPUT UPDATE
		SELECT COUNT(1)
		INTO v_cnt_14
		FROM DM_HI_CUST_FCST_INPUT A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_14 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_HI_CUST_FCST_INPUT' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_HI_CUST_FCST_INPUT A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_HI_CUST_FCST_INPUT A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_HI_MKT_FCST_CHANGE UPDATE
		SELECT COUNT(1)
		INTO v_cnt_15
		FROM DM_HI_MKT_FCST_CHANGE A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_15 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_HI_MKT_FCST_CHANGE' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_HI_MKT_FCST_CHANGE A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_HI_MKT_FCST_CHANGE A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_HI_SALES_INPUT UPDATE
		SELECT COUNT(1)
		INTO v_cnt_16
		FROM DM_HI_SALES_INPUT A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_16 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_HI_SALES_INPUT' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_HI_SALES_INPUT A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_HI_SALES_INPUT A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_HI_SITE_ITEM_MAPPING UPDATE
		SELECT COUNT(1)
		INTO v_cnt_17
		FROM DM_HI_SITE_ITEM_MAPPING A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_17 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_HI_SITE_ITEM_MAPPING' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_HI_SITE_ITEM_MAPPING A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_HI_SITE_ITEM_MAPPING A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_HI_SITE_ITEM_MAPPING_ROWDATA UPDATE
		SELECT COUNT(1)
		INTO v_cnt_18
		FROM DM_HI_SITE_ITEM_MAPPING_ROWDATA A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_18 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_HI_SITE_ITEM_MAPPING_ROWDATA' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_HI_SITE_ITEM_MAPPING_ROWDATA A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_HI_SITE_ITEM_MAPPING_ROWDATA A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_MST_BUCKET_CONVERSION UPDATE
		SELECT COUNT(1)
		INTO v_cnt_19
		FROM DM_MST_BUCKET_CONVERSION A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_19 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_MST_BUCKET_CONVERSION' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_MST_BUCKET_CONVERSION A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_MST_BUCKET_CONVERSION A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_MST_BUCKET_CONVERSION_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_20
		FROM DM_MST_BUCKET_CONVERSION_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_20 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_MST_BUCKET_CONVERSION_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_MST_BUCKET_CONVERSION_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_MST_BUCKET_CONVERSION_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_MST_CAPACITY_ALLOCATION UPDATE
		SELECT COUNT(1)
		INTO v_cnt_21
		FROM DM_MST_CAPACITY_ALLOCATION A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_21 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_MST_CAPACITY_ALLOCATION' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_MST_CAPACITY_ALLOCATION A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_MST_CAPACITY_ALLOCATION A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_MST_CAPACITY_ALLOCATION_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_22
		FROM DM_MST_CAPACITY_ALLOCATION_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_22 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_MST_CAPACITY_ALLOCATION_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_MST_CAPACITY_ALLOCATION_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_MST_CAPACITY_ALLOCATION_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_MST_CUSTOMER_MODEL UPDATE
		SELECT COUNT(1)
		INTO v_cnt_23
		FROM DM_MST_CUSTOMER_MODEL A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_23 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_MST_CUSTOMER_MODEL' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_MST_CUSTOMER_MODEL A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_MST_CUSTOMER_MODEL A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_MST_CUSTOMER_MODEL_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_24
		FROM DM_MST_CUSTOMER_MODEL_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_24 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_MST_CUSTOMER_MODEL_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_MST_CUSTOMER_MODEL_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_MST_CUSTOMER_MODEL_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_MST_EDI_CUST_MATERIAL_INFO UPDATE
		SELECT COUNT(1)
		INTO v_cnt_25
		FROM DM_MST_EDI_CUST_MATERIAL_INFO A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_25 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_MST_EDI_CUST_MATERIAL_INFO' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_MST_EDI_CUST_MATERIAL_INFO A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_MST_EDI_CUST_MATERIAL_INFO A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		END IF;

		-- DM_PLN_BP_FCST UPDATE
		SELECT COUNT(1)
		INTO v_cnt_26
		FROM DM_PLN_BP_FCST A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_26 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_BP_FCST' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_BP_FCST A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_BP_FCST A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_BP_FCST_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_27
		FROM DM_PLN_BP_FCST_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_27 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_BP_FCST_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_BP_FCST_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_BP_FCST_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_CUSTOMER_PSI UPDATE
		SELECT COUNT(1)
		INTO v_cnt_28
		FROM DM_PLN_CUSTOMER_PSI A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_28 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_CUSTOMER_PSI' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_CUSTOMER_PSI A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_CUSTOMER_PSI A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_CUSTOMER_PSI_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_29
		FROM DM_PLN_CUSTOMER_PSI_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_29 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_CUSTOMER_PSI_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_CUSTOMER_PSI_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_CUSTOMER_PSI_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_MKT_FCST UPDATE
		SELECT COUNT(1)
		INTO v_cnt_30
		FROM DM_PLN_MKT_FCST A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_30 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_MKT_FCST' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_MKT_FCST A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_MKT_FCST A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_MKT_FCST_CONFIRM UPDATE
		SELECT COUNT(1)
		INTO v_cnt_31
		FROM DM_PLN_MKT_FCST_CONFIRM A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_31 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_MKT_FCST_CONFIRM' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_MKT_FCST_CONFIRM A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_MKT_FCST_CONFIRM A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_MKT_FCST_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_32
		FROM DM_PLN_MKT_FCST_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_32 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_MKT_FCST_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_MKT_FCST_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_MKT_FCST_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_MKT_FCST_PK_DATA_UPDATE_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_33
		FROM DM_PLN_MKT_FCST_PK_DATA_UPDATE_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_33 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_MKT_FCST_PK_DATA_UPDATE_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_MKT_FCST_PK_DATA_UPDATE_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_MKT_FCST_PK_DATA_UPDATE_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_MKT_FCST_RESULT UPDATE
		SELECT COUNT(1)
		INTO v_cnt_34
		FROM DM_PLN_MKT_FCST_RESULT A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_34 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_MKT_FCST_RESULT' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_MKT_FCST_RESULT A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_MKT_FCST_RESULT A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_PR_DETAIL UPDATE
		SELECT COUNT(1)
		INTO v_cnt_35
		FROM DM_PLN_PR_DETAIL A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_35 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_PR_DETAIL' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_PR_DETAIL A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_PR_DETAIL A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_SALES_PLAN UPDATE
		SELECT COUNT(1)
		INTO v_cnt_36
		FROM DM_PLN_SALES_PLAN A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_36 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_SALES_PLAN' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_SALES_PLAN A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_SALES_PLAN A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_SALES_PLAN_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_37
		FROM DM_PLN_SALES_PLAN_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_37 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_SALES_PLAN_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_SALES_PLAN_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_SALES_PLAN_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_SALES_PLAN_REPORT_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_38
		FROM DM_PLN_SALES_PLAN_REPORT_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_38 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_SALES_PLAN_REPORT_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_SALES_PLAN_REPORT_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_SALES_PLAN_REPORT_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- DM_PLN_SALES_PLAN_RESULT UPDATE
		SELECT COUNT(1)
		INTO v_cnt_39
		FROM DM_PLN_SALES_PLAN_RESULT A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_39 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'DM_PLN_SALES_PLAN_RESULT' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM DM_PLN_SALES_PLAN_RESULT A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM DM_PLN_SALES_PLAN_RESULT A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- SCM_MST_FUTURE_PRICE UPDATE
		SELECT COUNT(1)
		INTO v_cnt_40
		FROM SCM_MST_FUTURE_PRICE A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_40 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'SCM_MST_FUTURE_PRICE' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM SCM_MST_FUTURE_PRICE A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM SCM_MST_FUTURE_PRICE A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- SCM_MST_FUTURE_PRICE_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_41
		FROM SCM_MST_FUTURE_PRICE_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_41 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'SCM_MST_FUTURE_PRICE_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM SCM_MST_FUTURE_PRICE_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM SCM_MST_FUTURE_PRICE_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- SCM_MST_SITE_ITEM UPDATE
		SELECT COUNT(1)
		INTO v_cnt_42
		FROM SCM_MST_SITE_ITEM A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_42 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'SCM_MST_SITE_ITEM' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM SCM_MST_SITE_ITEM A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM SCM_MST_SITE_ITEM A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- SCM_MST_SITE_ITEM_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_43
		FROM SCM_MST_SITE_ITEM_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_43 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'SCM_MST_SITE_ITEM_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM SCM_MST_SITE_ITEM_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM SCM_MST_SITE_ITEM_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- SCM_MST_SITE_ITEM_PRIORITY UPDATE
		SELECT COUNT(1)
		INTO v_cnt_44
		FROM SCM_MST_SITE_ITEM_PRIORITY A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_44 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'SCM_MST_SITE_ITEM_PRIORITY' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM SCM_MST_SITE_ITEM_PRIORITY A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM SCM_MST_SITE_ITEM_PRIORITY A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		-- SCM_MST_SITE_ITEM_PRIORITY_H UPDATE
		SELECT COUNT(1)
		INTO v_cnt_45
		FROM SCM_MST_SITE_ITEM_PRIORITY_H A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
		IF v_cnt_45 > 0 THEN
				INSERT INTO GT_DMF0_results_insert (;
							  ITEM_ID_BEFORE
							, ITEM_ID_AFTER
							, TABLE_NAME
							, ITEM_COUNT
							, CREATED_BY
							)
				SELECT B.ITEM_ID_BEFORE
					 , B.ITEM_ID_AFTER
					 , 'SCM_MST_SITE_ITEM_PRIORITY_H' AS TABLE_NAME
					 , COUNT(*)
					 , B.LAST_UPDATED_BY
				FROM SCM_MST_SITE_ITEM_PRIORITY_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40'
				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;

				UPDATE A
				SET ITEM_ID = B.ITEM_ID_AFTER
					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
					,LAST_UPDATE_DATE = SYSDATE
				FROM SCM_MST_SITE_ITEM_PRIORITY_H A
				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
				WHERE A.DIVISION_ID = '40';
		END IF;

		INSERT INTO DM_DNM_ITEM_CODE_CHANGE_HISTORY
			 ( BEFORE_CODE, AFTER_CODE, DATA_SEQ, TABLE_NAME, ROW_COUNT
			 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
			 , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
			 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT DISTINCT A.ITEM_ID_BEFORE, A.ITEM_ID_AFTER
			 , B.DATA_SEQ
			 , A.TABLE_NAME, A.ITEM_COUNT
			 , A.CREATED_BY, SYSDATE, A.CREATED_BY, SYSDATE, NULL
			 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
		FROM GT_DMF0_results_insert A
		JOIN GT_DMF0_results_MST B ON A.ITEM_ID_BEFORE = B.ITEM_ID_BEFORE AND A.ITEM_ID_AFTER = B.ITEM_ID_AFTER

	END;


	-- END TRY

	EXCEPTION
	    WHEN OTHERS THEN


		-- ERROR LOG
		v_log_type := 'ERROR';
		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
		v_description := 'ERROR_LINE : '  ||  STR(NULL);
		d_event_date := SYSTIMESTAMP;

		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM
		FROM DUAL;

    -- END CATCH

	-- 수행결과 성공여부 DISPLAY
     IF v_log_message IS NULL THEN
	  SELECT 'success'

	IF  v_log_type not in ('INVALID','ERROR') THEN
			-- 종료 LOG
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		END IF;

	-- INVALID 인경우 ROLLBACK 처리
	ERR_RTN:
		IF  v_log_type = 'INVALID' THEN
				SELECT 'INVALID'
								-- 종료 LOG
				v_log_message := '########## END of procedure ##########';
				d_event_date := SYSTIMESTAMP;
				PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
				-- [C20210323-000363]
				PR_SCM_SYS_LOG_BATCH(v_program_name, 'END', n_log_count, v_log_message, v_description, d_event_date);
				FROM DUAL;
			END IF;
/
