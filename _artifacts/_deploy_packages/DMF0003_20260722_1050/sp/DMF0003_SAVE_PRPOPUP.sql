CREATE OR REPLACE PROCEDURE           "DMF0003_SAVE_PRPOPUP" (
	p_POPUP_TYPE			IN VARCHAR2
	, p_ITEM_SEQ			IN VARCHAR2
	, p_DIVISION_ID		    IN VARCHAR2
	, p_PROJECT_CODE		IN VARCHAR2
	, p_SCM_SITE_ID		    IN VARCHAR2
	, p_ITEM_ID			    IN VARCHAR2
	, p_DOM_EXP			    IN VARCHAR2
	, p_FCST_TYPE			IN VARCHAR2
	, p_INCOTERMS			IN VARCHAR2
	, p_PLANT_SITE_ID		IN VARCHAR2
	, p_YYYYMMDD			IN VARCHAR2
	, p_UOM				    IN VARCHAR2
	, p_PLAN_QTY			IN VARCHAR2
	, p_STORAGE_ID			IN VARCHAR2
	, p_STORAGE_PLANT_ID	IN VARCHAR2
	, p_PUCH_MGR			IN VARCHAR2
	, p_PUCH_GROUP			IN VARCHAR2
	, p_PR_HEADER			IN VARCHAR2
	, p_PR_ITEM_DETAIL		IN VARCHAR2
	, p_CREATED_BY			IN VARCHAR2
	, R_REQUEST_NO			OUT VARCHAR2
	, R_ERROR_MSG           OUT VARCHAR2
)
AS
/*
 * 2026.05.12 박재민 컴파일 오류 수정
 */
	/*========================================================================================================================
	-- LOG 용 변수 설정
	========================================================================================================================*/
	v_program_name    VARCHAR2(150 CHAR) := 'DMF0003_SAVE_PRPOPUP';
	v_log_type        VARCHAR2(30 CHAR);
	n_log_count       NUMBER(10) := 0;
	v_log_message     VARCHAR2(1000 CHAR);
	v_log_description VARCHAR2(500 CHAR);
	d_event_date      DATE;
	n_delete_count    NUMBER(10) := 0;
	n_insert_count    NUMBER(10)  := 0;
	n_input_count     NUMBER(10) := 0;
	n_logo_count      NUMBER(10) := 0;
	n_Invalid_item    VARCHAR2(50 CHAR);
	n_msg             VARCHAR2(1000 CHAR);
	V_BF_REQ_NO       VARCHAR2(30 CHAR);
	V_BF_QTY          NUMBER(10) := 0;
	V_THIS_QTY        NUMBER(10) := 0;
	/*========================================================================================================================
	-- MKT FCST 테이블 접근을 위한 변수
	========================================================================================================================*/
	V_DIVISION_ID			VARCHAR2(30 CHAR);
	V_PROJECT_CODE			VARCHAR2(50 CHAR);
	V_SCM_SITE_ID			VARCHAR2(30 CHAR);
	V_ITEM_ID				VARCHAR2(50 CHAR);
	V_DOM_EXP				VARCHAR2(3 CHAR);
	V_FCST_TYPE			    VARCHAR2(20 CHAR);
	V_INCOTERMS			    VARCHAR2(10 CHAR);
	V_MEASURE				VARCHAR2(50 CHAR);
	V_YYYYMMDD				VARCHAR2(8 CHAR);
	V_PLANT_SITE_ID		    VARCHAR2(30 CHAR);
	V_BEFORE_UPDATE_QTY	    NUMBER(30,10);	-- ADD HISTORY 일 경우 업데이트 하기 전 MKT FCST 테이블 수량


	-- 아래 BEGIN ~ END 구간에서 사용하는 변수 선언
	V_MSG                  VARCHAR2(1000 CHAR);

	V_REQUEST_NO           VARCHAR2(30 CHAR);
	V_MAX_NO	           VARCHAR2(30 CHAR);
	V_SUM_QTY              NUMBER(10);
	v_cnt_1                NUMBER(10);

    v_to_mail              VARCHAR2(150 CHAR);
	v_temp_addr            VARCHAR2(150 CHAR); -- 밑에서 v_to_mail에 여러 메일 주소를 넣기 위해 새로 생성한 메일 주소 임시 저장용 변수
    v_cnt                  NUMBER(10);
    v_i                    INTEGER;

    v_item_seq             NUMBER(10);
    v_item_name            VARCHAR2(50 CHAR);
    v_uom                  VARCHAR2(8 CHAR);
    v_plan_qty             NUMBER(30,10);
    v_created_by           VARCHAR2(150 CHAR);
    v_last_update_date     DATE;
    v_cursor_yyyymmdd      VARCHAR2(10 CHAR);

	-- 메일 발송용 변수
	v_mail_title           VARCHAR2(100 CHAR);
    v_body_contents        VARCHAR2(4000 CHAR);
    v_body_cont            VARCHAR2(4000 CHAR);
    v_head_cont            VARCHAR2(4000 CHAR);

	v_db_name              VARCHAR2(100 CHAR);

	BEGIN
		-- GT_DMF0_MAIN 테이블 초기화
		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_MAIN';

		-- GT_T_MAIL_ADDR 테이블 초기화
		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_T_MAIL_ADDR';

		-- 프로시저 호출이기 떄문에 아래 로그 쌓는 부분을 TO-BE(오라클) BEGIN 절 시작하는 시점으로 올김
		/*========================================================================================================================
		-- 시작 LOG  (START)
		========================================================================================================================*/
		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_log_description := NULL;
		d_event_date := SYSDATE;
		PR_DM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date, p_CREATED_BY);
		v_log_message := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/


		SELECT MAX(REQUEST_NO)
        INTO V_MAX_NO
		FROM DM_PLN_PR_DETAIL
		WHERE REQUEST_NO LIKE TO_CHAR(SYSDATE, 'YYYYMMDD')  ||  '%';

		IF V_MAX_NO IS NOT NULL THEN
			V_REQUEST_NO := (TO_CHAR(SYSDATE, 'YYYYMMDD') || LPAD(SUBSTR(V_MAX_NO, -6) || 1, 6, 0));
		ELSE
			V_REQUEST_NO := TO_CHAR(SYSDATE, 'YYYYMMDD')  ||  '000001';
		END IF;

		/* TODO:GTT:GT_DMF0_MAIN-->GT_DMF0_MAIN */
		INSERT INTO GT_DMF0_MAIN
		SELECT V_REQUEST_NO AS REQUEST_NO
			, B1.TOKEN AS ITEM_SEQ
			, B2.TOKEN AS DIVISION_ID
			, B3.TOKEN AS PROJECT_CODE
			, B4.TOKEN AS SCM_SITE_ID
			, B5.TOKEN AS ITEM_ID
			, B6.TOKEN AS DOM_EXP
			, B7.TOKEN AS FCST_TYPE
			, B8.TOKEN AS INCOTERMS
			, NVL(B9.TOKEN, NULL) AS PLANT_SITE_ID
			, B10.TOKEN AS YYYYMMDD
			, B11.TOKEN AS UOM
			, B12.TOKEN AS PLAN_QTY
			, B13.TOKEN AS STORAGE_ID
			, B14.TOKEN AS STORAGE_PLANT_ID
			, B15.TOKEN AS PUCH_MGR
			, B16.TOKEN AS PUCH_GROUP
			, B17.TOKEN AS PR_HEADER
			, B18.TOKEN AS PR_ITEM_DETAIL
			, p_CREATED_BY AS CREATED_BY
			, SYSDATE AS CREATION_DATE
			, p_CREATED_BY AS LAST_UPDATED_BY
			, SYSDATE AS LAST_UPDATE_DATE
			, 'N' AS SSP_TRANSFER_FLAG
			, CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE1
		FROM UF_FX_String_Split(p_ITEM_SEQ, '^') B1
		LEFT OUTER JOIN UF_FX_String_Split(p_DIVISION_ID		, '^') B2  ON B1.NR = B2.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PROJECT_CODE		, '^') B3  ON B1.NR = B3.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_SCM_SITE_ID		, '^') B4  ON B1.NR = B4.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_ITEM_ID			, '^') B5  ON B1.NR = B5.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_DOM_EXP			, '^') B6  ON B1.NR = B6.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_FCST_TYPE			, '^') B7  ON B1.NR = B7.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_INCOTERMS			, '^') B8  ON B1.NR = B8.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PLANT_SITE_ID		, '^') B9  ON B1.NR = B9.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_YYYYMMDD			, '^') B10 ON B1.NR = B10.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_UOM				, '^') B11 ON B1.NR = B11.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PLAN_QTY			, '^') B12 ON B1.NR = B12.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_STORAGE_ID		    , '^') B13 ON B1.NR = B13.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_STORAGE_PLANT_ID	, '^') B14 ON B1.NR = B14.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PUCH_MGR			, '^') B15 ON B1.NR = B15.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PUCH_GROUP		    , '^') B16 ON B1.NR = B16.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PR_HEADER			, '^') B17 ON B1.NR = B17.NR
		LEFT OUTER JOIN UF_FX_String_Split(p_PR_ITEM_DETAIL	    , '^') B18 ON B1.NR = B18.NR;

		SELECT COUNT(1)
		INTO v_cnt_1
		FROM GT_DMF0_MAIN A
		LEFT OUTER JOIN SCM_MST_SITE_ITEM B
		ON  A.DIVISION_ID	= B.DIVISION_ID
		AND A.SCM_SITE_ID	= B.SCM_SITE_ID
		AND A.PROJECT_CODE	= B.PROJECT_CODE
		AND A.ITEM_ID		= B.ITEM_ID
		AND B.VALID_YN		= 'Y'
		WHERE B.ITEM_ID IS NULL;

		IF v_cnt_1 > 0 THEN
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 START
			--원소스 주석 처리
			 /*
			SELECT TOP 1 @n_Invalid_item = A.ITEM_ID
			FROM #T_MAIN A
			LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)
						 ON A.DIVISION_ID	= B.DIVISION_ID
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
						AND A.ITEM_ID		= B.ITEM_ID
						AND B.VALID_YN		= 'Y'
			WHERE B.ITEM_ID IS NULL
			SET @n_msg = RTRIM(@n_Invalid_item) + N'은 사용할 수 없는 Model 입니다.'
			RAISERROR( @n_msg, 16, 1);
			*/
			SELECT A.ITEM_ID
			INTO n_Invalid_item
			FROM GT_DMF0_MAIN A
			LEFT OUTER JOIN SCM_MST_SITE_ITEM B
			ON A.DIVISION_ID	= B.DIVISION_ID
			AND A.SCM_SITE_ID	= B.SCM_SITE_ID
			AND A.PROJECT_CODE	= B.PROJECT_CODE
			AND A.ITEM_ID		= B.ITEM_ID
			AND B.VALID_YN		= 'Y'
			WHERE B.ITEM_ID IS NULL;

			BEGIN
				v_log_type := 'INVALID';
				v_log_message := RTRIM(n_Invalid_item)  ||  '은 사용할 수 없는 Model 입니다.';
				GOTO ERR_RTN;
			END;
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 END
		END IF;

		SELECT DIVISION_ID
		     , PROJECT_CODE
		     , SCM_SITE_ID
		     , ITEM_ID
		     , DOM_EXP
		     , FCST_TYPE
		     , INCOTERMS
		     , 'BNPIn'
		     , YYYYMMDD
		     , PLANT_SITE_ID
		INTO  V_DIVISION_ID
			, V_PROJECT_CODE
			, V_SCM_SITE_ID
			, V_ITEM_ID
			, V_DOM_EXP
			, V_FCST_TYPE
			, V_INCOTERMS
			, V_MEASURE
			, V_YYYYMMDD
			, V_PLANT_SITE_ID
		FROM GT_DMF0_MAIN
		WHERE ROWNUM = 1;

		/*========================================================================================================================
		-- ADD HISTORY 일 경우 MKT FCST 를 업데이트 해준다.
		========================================================================================================================*/
		IF ( p_POPUP_TYPE = 'ADD_HISTORY') THEN
			SELECT SUM(PLAN_QTY)
			INTO V_SUM_QTY
			FROM (	SELECT SUM(PLAN_QTY) AS PLAN_QTY
					FROM DM_PLN_PR_DETAIL
					WHERE DIVISION_ID	= V_DIVISION_ID
					AND PROJECT_CODE	= V_PROJECT_CODE
					AND SCM_SITE_ID		= V_SCM_SITE_ID
					AND ITEM_ID			= V_ITEM_ID
					AND DOM_EXP			= V_DOM_EXP
					AND FCST_TYPE		= V_FCST_TYPE
					AND INCOTERMS		= V_INCOTERMS
					AND YYYYMMDD		= V_YYYYMMDD
					AND PLANT_SITE_ID	= V_PLANT_SITE_ID
					UNION ALL
					SELECT TO_NUMBER(PLAN_QTY) AS PLAN_QTY
					FROM GT_DMF0_MAIN
			) A;

			-- [C20221117-000272]
			SELECT SUM(PLAN_QTY)
			INTO V_BF_QTY
			FROM DM_PLN_PR_DETAIL
			WHERE DIVISION_ID	= V_DIVISION_ID
			AND PROJECT_CODE	= V_PROJECT_CODE
			AND SCM_SITE_ID		= V_SCM_SITE_ID
			AND ITEM_ID			= V_ITEM_ID
			AND DOM_EXP			= V_DOM_EXP
			AND FCST_TYPE		= V_FCST_TYPE
			AND INCOTERMS		= V_INCOTERMS
			AND YYYYMMDD		= V_YYYYMMDD
			AND PLANT_SITE_ID	= V_PLANT_SITE_ID;

			SELECT PLAN_QTY
			INTO V_THIS_QTY
			FROM GT_DMF0_MAIN
			WHERE ROWNUM = 1;

			/*========================================================================================================================
			-- 수량이 마이너스일 경우 직전 REQ 의 수량보다 크면 안됨
			========================================================================================================================*/
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 START
			--원소스 주석 처리
			/*
			IF ( V_THIS_QTY < 0
				AND ABS(V_THIS_QTY) > V_BF_QTY )
			BEGIN
				RAISERROR(N'마이너스 REQUEST 는 이전 REQUEST 총합 수량 만큼만 가능합니다.', 16, 1);
			END
			*/
			IF ( V_THIS_QTY < 0 AND ABS(V_THIS_QTY) > V_BF_QTY ) THEN
				v_log_type := 'INVALID';
				V_log_message := '마이너스 REQUEST 는 이전 REQUEST 총합 수량 만큼만 가능합니다.';
				GOTO ERR_RTN;
			END IF;
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 END

			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 START
			--원소스 주석 처리
			/*
			IF ( @V_THIS_QTY = 0 )
			BEGIN
				RAISERROR(N'수량이 0인 경우는 생성할 수 없습니다.', 16, 1);
			END
			*/
			IF ( V_THIS_QTY = 0 ) THEN
				v_log_type := 'INVALID';
				V_log_message := '수량이 0인 경우는 생성할 수 없습니다.';
				GOTO ERR_RTN;
			END IF;
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 END

			SELECT QTY
			INTO V_BEFORE_UPDATE_QTY
			FROM DM_PLN_MKT_FCST
			WHERE DIVISION_ID	= V_DIVISION_ID
			AND PROJECT_CODE	= V_PROJECT_CODE
			AND SCM_SITE_ID		= V_SCM_SITE_ID
			AND ITEM_ID			= V_ITEM_ID
			AND DOM_EXP			= V_DOM_EXP
			AND FCST_TYPE		= V_FCST_TYPE
			AND INCOTERMS		= V_INCOTERMS
			AND YYYYMMDD		= V_YYYYMMDD
			AND PLANT_SITE_ID	= V_PLANT_SITE_ID
			AND MEASURE			= 'BNPIn'
			AND ROWNUM = 1;

			UPDATE DM_PLN_MKT_FCST
			SET QTY = V_SUM_QTY
			WHERE DIVISION_ID	= V_DIVISION_ID
			AND PROJECT_CODE	= V_PROJECT_CODE
			AND SCM_SITE_ID		= V_SCM_SITE_ID
			AND ITEM_ID			= V_ITEM_ID
			AND DOM_EXP			= V_DOM_EXP
			AND FCST_TYPE		= V_FCST_TYPE
			AND INCOTERMS		= V_INCOTERMS
			AND YYYYMMDD		= V_YYYYMMDD
			AND PLANT_SITE_ID	= V_PLANT_SITE_ID
			AND MEASURE			= 'BNPIn';
		END IF;

		/*========================================================================================================================
		-- 2021.6.21 LAST_UPDATED_BY 는 USER NAME 으로 처리한다.
		-- 2021.6.28	LAST_UPDATED_BY 는 아이디로, ATTRIBUTE1 에는 KR NAME 으로 한다.
		========================================================================================================================*/
-- AS-IS 쿼리는 오라클에 사용 불가하여 아래 MERGE문으로 변경함.
--		UPDATE A
--		SET ATTRIBUTE1 = B.USER_NAME
--		FROM GT_DMF0_MAIN A
--		JOIN SCM_MST_SSO_USER_INFO B
--		ON A.LAST_UPDATED_BY = B.USER_ID;

		MERGE INTO GT_DMF0_MAIN A
		USING SCM_MST_SSO_USER_INFO B
		ON (A.LAST_UPDATED_BY = B.USER_ID)
		WHEN MATCHED THEN
		UPDATE SET A.ATTRIBUTE1 = B.USER_NAME;

		INSERT INTO DM_PLN_PR_DETAIL (
			   REQUEST_NO, ITEM_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			 , ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
			 , YYYYMMDD, UOM, PLAN_QTY, STORAGE_ID, STORAGE_PLANT_ID
			 , PUCH_MGR, PUCH_GROUP, PR_HEADER, PR_ITEM_DETAIL, CREATED_BY
			 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, SSP_TRANSFER_FLAG
			 , ATTRIBUTE1
		)
		SELECT REQUEST_NO, ITEM_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			 , ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
			 , YYYYMMDD, UOM, PLAN_QTY, STORAGE_ID, STORAGE_PLANT_ID
			 , PUCH_MGR, PUCH_GROUP, PR_HEADER, PR_ITEM_DETAIL, CREATED_BY
			 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, SSP_TRANSFER_FLAG
			 , ATTRIBUTE1
		FROM GT_DMF0_MAIN;
		--RAISERROR('ASAAAA', 16, 1)

		/*========================================================================================================================
		-- ESS 프로시저 호출	------------------------------------------------------------------------------------
		-- 트랜잭션 문제가 해결이 안된 관계로 여기서 처리하고, 문제 발생시 DM_PLN_PR_DETAIL 삭제 및 DM_PLN_MKT_FCST UPDATE 한다.
		========================================================================================================================*/

		--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 START
		--원소스 주석 처리
		/*
		EXEC PR_SSP_ANL_ESS_REQ @V_REQUEST_NO, @V_DIVISION_ID, @V_MSG OUTPUT
		IF ISNULL(@V_MSG,'') <> N'OK'
		BEGIN
			RAISERROR(@V_MSG, 16, 1);
		END
		*/
		PR_SSP_ANL_ESS_REQ(V_REQUEST_NO, V_DIVISION_ID, V_MSG);
		IF NVL(V_MSG, '') <> 'OK' THEN
			v_log_type := 'INVALID';
			v_log_message := V_MSG;
			GOTO ERR_RTN;
		END IF;
		--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 END


		INSERT INTO GT_T_MAIL_ADDR ( ADDR )
		SELECT A.SEGMENT1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
		WHERE A.LOOKUP_TYPE = 'DM_PR_MAIL_ADDR'
		AND A.VALID_YN = 'Y';

		SELECT COUNT(*), 0, ''
		INTO v_cnt, v_i, v_to_mail
		FROM GT_T_MAIL_ADDR;

		WHILE v_i < v_cnt LOOP
			-- 오라클은 SELECT 결과를 바로 변수에 더할 수 없으므로, 값을 가져온 뒤 할당합니다.
			SELECT ADDR
			INTO v_temp_addr -- 임시 변수 필요
			FROM GT_T_MAIL_ADDR
			WHERE SEQ = v_i;

			-- 문자열 합치기 (|| 사용)
			v_to_mail := v_to_mail || v_temp_addr || ';';

			-- 카운트 증가
			v_i := v_i + 1;
		END LOOP;

		v_mail_title    := '[SCM] PR Requested';
		v_body_contents := '하기와 같이 PR Request 가 접수 되었습니다. 기 확보된 재고 Allo 후 PR 생성 바랍니다.';
		v_body_cont     := '';
		v_head_cont := '<TR>'
                || '    <TH>Request No</TH>'
                || '    <TH>Div</TH>'
                || '    <TH>Project Code</TH>'
                || '    <TH>Seq.</TH>'
                || '    <TH>Model</TH>'
                || '    <TH>Model Name</TH>'
                || '    <TH>UOM</TH>'
                || '    <TH>To Site</TH>'
                || '    <TH>Request Date</TH>'
                || '    <TH>Request Qty</TH>'
                || '    <TH>Requestor</TH>'
                || '    <TH>Update date</TH>'
                || '</TR>';

		FOR rec IN (
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_SEQ, A.ITEM_ID, B.ITEM_NAME
				 , A.UOM, A.SCM_SITE_ID, A.YYYYMMDD, A.PLAN_QTY, A.CREATED_BY
				 , A.LAST_UPDATE_DATE, A.REQUEST_NO -- 필요한 컬럼 추가
			FROM DM_PLN_PR_DETAIL A
			LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
			ON A.DIVISION_ID = B.DIVISION_ID
			AND A.ITEM_ID = B.ITEM_ID
			WHERE REQUEST_NO = V_REQUEST_NO
			ORDER BY ITEM_SEQ
		) LOOP
			v_body_cont := v_body_cont || '<TR>' ||
				'<TD>' || NVL(rec.REQUEST_NO, '') || '</TD>' ||
				'<TD>' || NVL(rec.DIVISION_ID, '') || '</TD>' ||
				'<TD>' || NVL(rec.PROJECT_CODE, '') || '</TD>' ||
				'<TD>' || NVL(TO_CHAR(rec.ITEM_SEQ), '') || '</TD>' ||
				'<TD>' || NVL(rec.ITEM_ID, '') || '</TD>' ||
				'<TD>' || NVL(rec.ITEM_NAME, '') || '</TD>' ||
				'<TD>' || NVL(rec.UOM, '') || '</TD>' ||
				'<TD>' || NVL(rec.SCM_SITE_ID, '') || '</TD>' ||
				'<TD>' || NVL(TO_CHAR(TO_DATE(rec.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD'), '') || '</TD>' ||
				'<TD ALIGN="RIGHT">' || FN_GET_NUMER_TO_STRING(rec.PLAN_QTY, 0) || '</TD>' ||
				'<TD>' || NVL(rec.CREATED_BY, '') || '</TD>' ||
				'<TD>' || NVL(TO_CHAR(rec.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS'), '') || '</TD>' ||
				'</TR>';
		END LOOP;

		-- 현재 DB 이름 가져오기
		SELECT GLOBAL_NAME INTO v_db_name FROM GLOBAL_NAME;

		-- AS-IS는 LGCE_SCMDEV이였으나 TO-BE는 현재 ESSCMD임
		-- 개발 서버('ESSCMD')가 아닐 경우에만 발송
		IF v_db_name <> 'ESSCMD' THEN
			SCM_ADM_MAIL_SEND (v_to_mail, v_mail_title, v_body_cont, 'Y');
		END IF;

		/*=============================================================================
		-- MAIL 발송 LOG 저장
		=============================================================================*/
		SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG (
			'MAIL',
			'-',
			v_program_name,
			V_DIVISION_ID,
			V_REQUEST_NO,
			'',
			'',
			'',
			'',
			'',
			'',
			v_to_mail
		);

		R_REQUEST_NO := V_REQUEST_NO;

		/*=============================================================================
		--  종료 LOG
		=============================================================================*/
		v_log_type    := 'END';
		v_log_message := '########## END of procedure ##########';
		v_log_description := 'input_count: ' || TO_CHAR(n_input_count);
		d_event_date  := SYSDATE;

		PR_DM_SYS_LOG_BATCH (v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date, p_CREATED_BY);

		COMMIT;
	--[E20250401-000548]_VALIDATION 체크시 로그 찍는 부분 추가 START
	/*========================================================================================================================
	-- 트랜잭션 (INVALID)
	========================================================================================================================*/

	<<ERR_RTN>>
	IF v_log_type = 'INVALID' THEN
		-- 1. 트랜잭션 롤백 (오라클은 조건 없이 ROLLBACK 가능)
		ROLLBACK;

		-- 2. INVALID 로그 기록
		d_event_date := SYSDATE;

		PR_DM_SYS_LOG_BATCH (
			v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date, p_CREATED_BY
		);

		-- 3. 에러 메시지 반환 (OUT 파라미터에 할당)
		-- AS-IS => SELECT @v_log_message AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/
		R_ERROR_MSG := v_log_message; /*-- 에러메시지 RETURN --*/

		-- 4. 종료 절차 진행
		v_log_type    := 'END';
		v_log_message := '########## END of procedure ##########';
		v_log_description := 'input_count: ' || TO_CHAR(n_input_count);
		d_event_date  := SYSDATE;

		-- 5. 종료 로그 기록
		PR_DM_SYS_LOG_BATCH (
			v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date, p_CREATED_BY
		);
		--[E20250401-000548]_VALIDATION 체크시 로그 찍는 부분 추가 END
	END IF;

	EXCEPTION
		WHEN OTHERS THEN
			-- 1. 트랜잭션 롤백 (오라클은 조건 체크 없이 롤백해도 안전합니다)
			ROLLBACK;

			-- 2. 로그 변수 설정
			v_log_type        := 'ERROR';
			v_log_message     := SUBSTR(SQLERRM, 1, 1000); -- ERROR_MESSAGE() 대응

			-- ERROR_LINE() 대응 (정규식으로 라인 번호만 추출)
			v_log_description := 'ERROR_LINE : ' || TO_CHAR(REGEXP_SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'line ([0-9]+)', 1, 1, NULL, 1));
			d_event_date      := SYSDATE;

			-- MSSQL의 SELECT [error_no] + error_msg 대응
			-- AS-IS => SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/
			R_ERROR_MSG       := '[' || TO_CHAR(SQLCODE) || '] ' || SQLERRM; /*-- 에러메시지 RETURN --*/

			-- 4. 로그 저장 프로시저 호출
			PR_DM_SYS_LOG_BATCH (v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date, p_CREATED_BY);

END;
/
