PROCEDURE           "PR_DM_DNM_EDI_CALLOFF_STATUS"

/*
 * Program ID   : PR_DM_DNM_EDI_CALLOFF_STATUS
 * Description  : EDI_CALLOFF DATA의 STATUS 체크
 *                PR_DM_DNM_EDI_CALLOFF 프로시저에서 호출
 *                스케줄러에서 호출
 *                XIF_ERP_EDI_CALLOFF_HEAD_R    -> DM_DNM_EDI_CALLOFF_HEAD
 *                XIF_ERP_EDI_CALLOFF_PARTNER_R -> DM_DNM_EDI_CALLOFF_PARTNER
 *                XIF_ERP_EDI_CALLOFF_ITEM_R    -> DM_DNM_EDI_CALLOFF_ITEM
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 배포시 주의사항 : 개발기 -> LGCE_INFDEV , 운영기 -> LGCE_INF
 *===================================================================================================
   2023.01.30				     PR_DM_DNM_EDI_CALLOFF_STATUS 프로시저 생성
   2023.11.29	kjj0070		 예외처리 적용
   2024.04.22   HMIN		 예외처리 로직에 SPACE처리 후 비교 하도록 수정
   2024.06.27	JSSBAE		 [E20240610-000320]_SCM DM EDI(Cust FCST) 관련 문의사항 (예외로직적용: 앞뒤 공백값, NULL값 공백으로 치환해서 비교 처리)
   2024.07.03	JSSBAE		 [E20240701-000472]_[공급 SCM PI팀] ERP EDI Master화면 업데이트 범위 개선
   2024.12.16	KANG.H.J	 [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
   2026.03.23	김준규      [PJ20264226] NextSCM Pilot 설계 및 개발
   2026.04.23 강민재      NextSCM Pilot 수정
 */
IS
  /* v_batch_user      VARCHAR2(150 CHAR) := 'scm_batch'; */
  V_PROGRAM_NAME    VARCHAR2(150 CHAR) := $$PLSQL_UNIT;  /* PR_DM_DNM_EDI_CALLOFF_STATUS(AS); */
  V_BATCH_CHK_MSG   VARCHAR2(150 CHAR) := ' ';

  V_LOG_TYPE        VARCHAR2(30 CHAR);
  N_LOG_COUNT       INTEGER := 0;
  V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
  V_DESCRIPTION     VARCHAR2(500 CHAR);
  D_EVENT_DATE      DATE;
  /* N_HISTORY_SEQ     NUMBER; */
  V_DIVISION_ID     VARCHAR2(30 CHAR);

  V_FROM_YYYYMMDD   VARCHAR2(4000 CHAR);
  V_IN_PARA_DATA    VARCHAR2(4000 CHAR) := '';
BEGIN

  IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
      V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
  END IF;
	/* CHECKPOINT */
	/* -- 버퍼 풀 초기화 */
	/* DBCC DROPCLEANBUFFERS */
	/* -- 프로시저 캐시 초기화 */
	/* DBCC FREEPROCCACHE */
  /* LOG 용 변수 설정 */

	/* 시작 LOG */
  V_LOG_TYPE := 'START';
  V_LOG_MESSAGE := '########## Start of procedure ##########';
  V_DESCRIPTION := NULL;
  D_EVENT_DATE := SYSTIMESTAMP;
  PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

  /* ----------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇ */
	/* BEGIN TRY (Oracle: EXCEPTION 블록으로 대체) */
  /* ----------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇ */

  /* 기존 MSSQL에서는 DROP 후 CREATE로 테이블 매번 생성 */

  V_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') + (-52)*7, 'YYYYMMDD');

  /* ITEM_RECORD 입력용 TEMP TABLE 생성 */
  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DDEC_EDI_INVALID_DATA';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DDEC_SCM_MST_ITEM_SN';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DDEC_SCM_MST_SITE_ITEM';

  /* ----------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇ */
	BEGIN


    /*
      0. 점검대상 테이블 추출
    */
		BEGIN
			/* GT_DDEC_EDI_INVALID_DATA */
			INSERT /*+ NO_PARALLEL */ INTO GT_DDEC_EDI_INVALID_DATA
			(
        EDI_IF_SEQ
      , SUB_NO
      , YYYYMMDD
      , IFSEQNO
	  , DIVISION_ID
      , COMPANY_ID
	  , SENDER_CODE
      , SENDER_NAME
      , SOLDTO_CODE
      , SHIPTO_CODE
			, UNLOADING_POINT
      , CUSTOMER_PLANT
      , PROJECT_CODE
      , CUST_MATERIAL_CODE
      , ITEM_ID
			, SCM_SITE_ID
      , SALES_PLANT_SITE_ID
      , EDI_INCOTERMS
			, STATUS_CODE
      , BOM_STATUS
      , SALES_SITE_STATUS
      , PROJECT_STATUS
      , ITEM_STATUS
      , SSPM_STATUS
      , PLANT_SITE_STATUS
      , INCOTERMS_STATUS
      , SALES_PLANT_SITE_STATUS
      , ERP_STATUS
			)
			SELECT
          EDI_IF_SEQ
        , SUB_NO
        , YYYYMMDD
        , IFSEQNO
				, DIVISION_ID
        , COMPANY_ID
				, SENDER_CODE
        , SENDER_NAME
        , SOLDTO_CODE
        , SHIPTO_CODE
				, UNLOADING_POINT
        , CUSTOMER_PLANT
        , PROJECT_CODE
        , CUST_MATERIAL_CODE
        , ITEM_ID
				, SCM_SITE_ID
        , SALES_PLANT_SITE_ID
        , EDI_INCOTERMS
				, STATUS_CODE
        , BOM_STATUS
        , SALES_SITE_STATUS
        , PROJECT_STATUS
        , ITEM_STATUS
        , SSPM_STATUS
        , PLANT_SITE_STATUS
        , INCOTERMS_STATUS
        , SALES_PLANT_SITE_STATUS
        , ERP_STATUS
			FROM DM_DNM_EDI_CALLOFF_ITEM A
      WHERE 1=1
        /* U : CALL_OFF_DATA 기반 신규 생성 / E : 기 점검되었으나 기준정보 부족으로 인해 보류된 건. */
        AND STATUS_CODE IN ('U', 'E')
        /* 오늘 기준 전전월(M-2 월의 1일)부터 현재까지 데이터만 변경 */
        AND A.CREATE_DATE >= V_FROM_YYYYMMDD;

			/* GT_DDEC_SCM_MST_ITEM_SN */
			INSERT /*+ NO_PARALLEL */ INTO GT_DDEC_SCM_MST_ITEM_SN
      (
        DIVISION_ID
      , COMPANY_ID
      , ITEM_ID
      , SITE_ID
      , ITEM_TYPE
      )
			SELECT DISTINCT
        DIVISION_ID
      , COMPANY_ID
      , ITEM_ID
      , SITE_ID
      , ITEM_TYPE
			FROM SCM_MST_ITEM_SN
			WHERE 1=1
        AND DIVISION_ID IN (SELECT DISTINCT DIVISION_ID FROM GT_DDEC_EDI_INVALID_DATA);

			/* GT_DDEC_SCM_MST_SITE_ITEM */
			INSERT /*+ NO_PARALLEL */ INTO GT_DDEC_SCM_MST_SITE_ITEM
      (
        DIVISION_ID
      , SCM_SITE_ID
      , ITEM_ID
      , PROJECT_CODE
      , SALES_PLANT
      , EDI_INCOTERMS
      , VALID_YN
      )
			SELECT
        A.DIVISION_ID
      , A.SCM_SITE_ID
      , A.ITEM_ID
      , A.PROJECT_CODE
      , A.SALES_PLANT
      , A.ATTRIBUTE6 EDI_INCOTERMS
      , A.VALID_YN
			FROM
			(
				SELECT
          A.DIVISION_ID
        , A.SCM_SITE_ID
        , A.ITEM_ID
        , A.PROJECT_CODE
        , A.SALES_PLANT
        , A.ATTRIBUTE6
        , A.VALID_YN
				, ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID ORDER BY A.CREATION_DATE DESC, A.PROJECT_CODE DESC) RN  /* PROJECT 코드가 중복이므로 가장 최근의 프로젝트로 선정함 */
				FROM SCM_MST_SITE_ITEM	A
				WHERE 1=1
          AND DIVISION_ID IN (SELECT DISTINCT DIVISION_ID FROM GT_DDEC_EDI_INVALID_DATA)
          AND	VALID_YN = 'Y'
			) A
			WHERE RN = 1;
		END;

		/*
      1. SALES_SITE_STATUS
      SoldTo, Shipto 정보를 기반으로 SCM_SITE_ID 찾아서 업데이트.
      . 정보 있을 시,SALES_SITE_STATUS = 'S'로 반영.
      . 정보 없을 시 SALES_SITE_STATUS = 'E'로 반영, STATUS_CODE = 'E'로 반영
		*/
		BEGIN
			/* SCM_SITE_ID, SALES_SITE_STATUS 업데이트 */
			MERGE INTO GT_DDEC_EDI_INVALID_DATA A
			USING
			(
				SELECT
            A1.DIVISION_ID
          , A1.SCM_SITE_ID
          , A1.SOLDTO_CODE
          , A1.SHIPTO_CODE
          , A2.PLANT_ID
          , A2.OPERATION_GROUP
          , A2.SITE_TYPE
				FROM SCM_MST_SITE_CUSTOMER A1
				   , SCM_MST_SITE          A2
				WHERE 1=1
				AND A1.DIVISION_ID	= A2.DIVISION_ID
				AND	A1.SCM_SITE_ID	= A2.SCM_SITE_ID
				AND A2.SITE_TYPE    = 'SALES'
				AND A2.VALID_YN		  = 'Y'
				AND A1.DIVISION_ID IN (SELECT DISTINCT DIVISION_ID FROM GT_DDEC_EDI_INVALID_DATA)
				AND A1.VALID_YN	  = 'Y'
			) B
			ON (
            1=1
        AND A.DIVISION_ID	= B.DIVISION_ID
        AND A.SOLDTO_CODE	= B.SOLDTO_CODE
        AND A.SHIPTO_CODE	= B.SHIPTO_CODE
      )
			WHEN MATCHED THEN UPDATE SET
          A.SCM_SITE_ID	      = B.SCM_SITE_ID
				,	A.SALES_SITE_STATUS = 'S'
			WHEN NOT MATCHED THEN INSERT (EDI_IF_SEQ) VALUES (NULL);

			UPDATE GT_DDEC_EDI_INVALID_DATA A
      SET	A.SALES_SITE_STATUS = 'E'
				,	A.STATUS_CODE		    = 'E'
			WHERE NOT EXISTS (
				SELECT 1
				  FROM SCM_MST_SITE_CUSTOMER A1
				     , SCM_MST_SITE          A2
				WHERE 1=1
				AND A1.DIVISION_ID	  = A2.DIVISION_ID
				AND	A1.SCM_SITE_ID	  = A2.SCM_SITE_ID
				AND A2.SITE_TYPE      = 'SALES'
				AND A2.VALID_YN		    = 'Y'
        AND   A1.VALID_YN	    = 'Y'
				AND   A1.DIVISION_ID  = A.DIVISION_ID
				AND   A1.SOLDTO_CODE  = A.SOLDTO_CODE
				AND   A1.SHIPTO_CODE  = A.SHIPTO_CODE
			);
		END;

		/*
      2. SSPM_STATUS / ITEM_STATUS
      . DIVISION_ID, SCM_SITE_ID, ITEM_ID 기반으로 SSPM 정보 존재 여부를 확인한다.
      . 정보가 있다면 MAX 기준으로 프로젝트 코드 데이터 정비
      . 정보 있을 시, SSPM_STATUS, ITEM_STATUS S로 반영
      . 정보 없을 시, SSPM_STATUS, ITEM_STATUS E로 반영, STATUS_CODE = 'E'로 반영
		*/
    BEGIN
			/* SSPM_STATUS / ITEM_ID 업데이트 */
			MERGE INTO GT_DDEC_EDI_INVALID_DATA A
			USING (
        SELECT
            DIVISION_ID
          , SCM_SITE_ID
          , ITEM_ID
          , PROJECT_CODE
        FROM GT_DDEC_SCM_MST_SITE_ITEM
        WHERE VALID_YN = 'Y'
      ) B
			ON (
            1=1
        AND A.DIVISION_ID	= B.DIVISION_ID
        AND A.SCM_SITE_ID	= B.SCM_SITE_ID
        AND A.ITEM_ID		  = B.ITEM_ID
      )
			WHEN MATCHED THEN UPDATE SET
          A.SSPM_STATUS	  = 'S'
				,	A.ITEM_STATUS	  = 'S'
				,	A.PROJECT_CODE	= CASE WHEN LENGTH(B.PROJECT_CODE) > 0	THEN B.PROJECT_CODE		ELSE NULL		END  /* Project_Code는 Division_id, Scm_Site_ID, Item까지만 비교하여 가장 최근 Project_Code로 생성함. */
			;
			UPDATE GT_DDEC_EDI_INVALID_DATA A
			SET	A.SSPM_STATUS	  = 'E'
				,	A.ITEM_STATUS	  = 'E'
				,	A.STATUS_CODE	  = 'E'
			WHERE NOT EXISTS (
				SELECT 1 FROM GT_DDEC_SCM_MST_SITE_ITEM B
				WHERE 1=1
        AND B.VALID_YN    = 'Y'
				AND A.DIVISION_ID = B.DIVISION_ID
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.ITEM_ID     = B.ITEM_ID
			);

		END;

		/*
      3. PROJECT_CODE
			. DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE 기반으로 PROJECT_CODE 정보 존재 여부를 확인한다.
			. 정보 있을 시, PROJECT_STATUS = S로 반영
			. 정보 없을 시, PROJECT_STATUS = E로 반영, STATUS_CODE = 'E'로 반영
		*/
    BEGIN
			/* PROJECT_CODE / PROJECT_STATUS 업데이트 */
			MERGE INTO GT_DDEC_EDI_INVALID_DATA A
			USING (
        SELECT
            DIVISION_ID
          , SCM_SITE_ID
          , ITEM_ID
          , PROJECT_CODE
        FROM GT_DDEC_SCM_MST_SITE_ITEM
        WHERE VALID_YN      = 'Y'
      ) B
			ON (
          1=1
      AND A.DIVISION_ID	    = B.DIVISION_ID
			AND A.SCM_SITE_ID	    = B.SCM_SITE_ID
			AND A.ITEM_ID		      = B.ITEM_ID
			AND A.PROJECT_CODE	  = B.PROJECT_CODE
      )
			WHEN MATCHED THEN UPDATE SET
          A.PROJECT_STATUS  = CASE WHEN LENGTH(B.PROJECT_CODE) > 0 THEN 'S' ELSE 'E'	END
        ,	A.STATUS_CODE		  = CASE WHEN LENGTH(B.PROJECT_CODE) = 0 OR B.PROJECT_CODE IS NULL THEN 'E'	END
			;

			UPDATE GT_DDEC_EDI_INVALID_DATA A
			SET		A.PROJECT_STATUS	= 'E'
          ,	A.STATUS_CODE		  = 'E'
			WHERE NOT EXISTS (
				SELECT 1
        FROM GT_DDEC_SCM_MST_SITE_ITEM B
				WHERE 1=1
          AND B.VALID_YN      = 'Y'
          AND A.DIVISION_ID   = B.DIVISION_ID
          AND A.SCM_SITE_ID   = B.SCM_SITE_ID
          AND A.ITEM_ID       = B.ITEM_ID
          AND A.PROJECT_CODE  = B.PROJECT_CODE
			);

		END;

		/*
      4. INCOTERMS_STATUS / SALES_PLAN_SITE_STATUS
			. DIVISION_ID, SCM_SITE_ID, ITEM_ID 기반으로 PROJECT_CODE, EDI_INCOTERMS, SALES_PLAN_SITE_ID 를 찾는다.
			. 각각의 정보 있을 시, PROJECT_CODE, EDI_INCOTERMS, SALES_PLANT_SITE_ID 업데이트, PROJECT_STATUS, INCOTERMS_STATUS, SALES_PLAN_SITE_STATUS S로 반영
			. 각각의 정보 없을 시, PROJECT_STATUS, INCOTERMS_STATUS, SALES_PLAN_SITE_STATUS E로 반영, STATUS_CODE = 'E'로 반영
			. incoterms 및 Sales_Plant_Site_ID는 빈칸일 수도 있기 때문에 길이로 판단함.
    */
		BEGIN
			/* INCOTERMS / SALES_PLANT_SITE_ID 업데이트 */
			MERGE INTO GT_DDEC_EDI_INVALID_DATA A
			USING (
        SELECT
            DIVISION_ID
          , SCM_SITE_ID
          , ITEM_ID
          , PROJECT_CODE
          , EDI_INCOTERMS
          , SALES_PLANT
        FROM GT_DDEC_SCM_MST_SITE_ITEM
        WHERE VALID_YN = 'Y'
      ) B
			ON (
          1=1
      AND A.DIVISION_ID	  = B.DIVISION_ID
			AND A.SCM_SITE_ID	  = B.SCM_SITE_ID
			AND A.PROJECT_CODE	= B.PROJECT_CODE
      AND A.ITEM_ID		= B.ITEM_ID
      )
			WHEN MATCHED THEN UPDATE SET
          A.EDI_INCOTERMS				    = CASE WHEN LENGTH(B.EDI_INCOTERMS) > 0   THEN B.EDI_INCOTERMS	ELSE 'E'	END
				,	A.INCOTERMS_STATUS			  = CASE WHEN LENGTH(B.EDI_INCOTERMS) > 0   THEN 'S'				      ELSE 'E'	END
				,	A.SALES_PLANT_SITE_STATUS	= CASE WHEN LENGTH(B.SALES_PLANT) > 0	    THEN 'S'				      ELSE 'E'	END
				, A.SALES_PLANT_SITE_ID		  = CASE WHEN LENGTH(B.SALES_PLANT) > 0		  THEN
        (B.SALES_PLANT || CASE WHEN SUBSTR(B.ITEM_ID, 2, 1) IN ('M', 'P') THEN '-P' ELSE '-A' END)  ELSE NULL END
        ,	A.STATUS_CODE				      = CASE WHEN (LENGTH(B.EDI_INCOTERMS) IS NULL OR LENGTH(B.SALES_PLANT) IS NULL) THEN 'E' END
			;

			UPDATE GT_DDEC_EDI_INVALID_DATA A
			SET		A.EDI_INCOTERMS				    = 'E'
          ,	A.INCOTERMS_STATUS			  = 'E'
          ,	A.SALES_PLANT_SITE_STATUS	= 'E'
          , A.SALES_PLANT_SITE_ID		  = NULL
          ,	A.STATUS_CODE				      = 'E'
			WHERE NOT EXISTS (
				SELECT 1
        FROM GT_DDEC_SCM_MST_SITE_ITEM B
				WHERE 1=1
          AND B.VALID_YN      = 'Y'
          AND A.DIVISION_ID   = B.DIVISION_ID
          AND A.SCM_SITE_ID   = B.SCM_SITE_ID
          AND A.PROJECT_CODE  = B.PROJECT_CODE
          AND A.ITEM_ID       = B.ITEM_ID
			);
		END;

		/*
      5.  SALES_SITE_STATUS / SSPM_STATUS / PROJECT_STATUS / ITEM_STATUS / INCOTERMS_STATUS / SALES_PLANT_SITE_STATUS 모두 S ==> STATUS_CODE ='S'
		  * 참고로 BOM_STATUS는 체크로직 제외됨.
    */
		BEGIN
			UPDATE GT_DDEC_EDI_INVALID_DATA
			SET STATUS_CODE = 'S'
			WHERE 1=1
			AND (
            SALES_SITE_STATUS       = 'S'
        AND SSPM_STATUS             = 'S'
        AND PROJECT_STATUS          = 'S'
        AND ITEM_STATUS             = 'S'
        AND INCOTERMS_STATUS        = 'S'
        AND SALES_PLANT_SITE_STATUS = 'S'
      );
		END;

		/*
      6.  최종 점검 데이터 원테이블에 UPDATE
    */
		BEGIN
			/* TODO: UPDATE...FROM MERGE 변환 실패 */
			MERGE INTO DM_DNM_EDI_CALLOFF_ITEM T
			USING (SELECT * FROM GT_DDEC_EDI_INVALID_DATA) A
			ON (T.EDI_IF_SEQ	= A.EDI_IF_SEQ
			AND T.SUB_NO		  = A.SUB_NO
			AND T.YYYYMMDD		= A.YYYYMMDD
			AND T.CREATE_DATE	>= V_FROM_YYYYMMDD)
			WHEN MATCHED THEN UPDATE SET
          T.PROJECT_CODE			      = A.PROJECT_CODE
				, T.SCM_SITE_ID				      = A.SCM_SITE_ID
				, T.SALES_PLANT_SITE_ID		  = A.SALES_PLANT_SITE_ID
				, T.STATUS_CODE				      = NVL(A.STATUS_CODE, 'E')
				, T.SALES_SITE_STATUS		    = NVL(A.SALES_SITE_STATUS, 'E')
        , T.BOM_STATUS				      = NVL(A.BOM_STATUS, 'E')
				, T.SSPM_STATUS				      = NVL(A.ITEM_STATUS, 'E')
				, T.PROJECT_STATUS			    = NVL(A.PROJECT_STATUS, 'E')
				, T.ITEM_STATUS				      = NVL(A.ITEM_STATUS, 'E')
				, T.INCOTERMS_STATUS		    = NVL(A.INCOTERMS_STATUS, 'E')
				, T.EDI_INCOTERMS			      = A.EDI_INCOTERMS
				, T.SALES_PLANT_SITE_STATUS	= A.SALES_PLANT_SITE_STATUS
				, T.LAST_UPDATE_DATE		    = SYSDATE
				, T.LAST_UPDATED_BY			    = 'scm_batch';
		END;


		/*
      7.  예외로직 적용
      *   예외라 함은 NERP로부터 EDI 접수받더라도 집계에서는 제외한다는 의미로.
      *   EXCEPTION_FLAG = 'Y' 라 함은 CALL_OFF_STATUS에서 점검 제외 ==> MKT_FCST(CUST_FCST_EDI) 집계도 제외 함.
      *   EXCEPTION_FLAG 는 'Y'와 NULL 2중 1개로만 존재함.
    */
		BEGIN
			UPDATE DM_DNM_EDI_CALLOFF_ITEM A
			SET   EXCEPTION_FLAG    = 'Y'
          , EXCEPTION_DATE    = SYSDATE
          , LAST_UPDATE_DATE  = SYSDATE
          , LAST_UPDATED_BY   = 'scm_batch_exception_1'
			WHERE 1=1
			AND A.CREATE_DATE >= V_FROM_YYYYMMDD
			/* AND NVL(A.EXCEPTION_FLAG , NULL) <> 'Y' */
			AND EXISTS
			(
				SELECT 1
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL Z
				WHERE Z.LOOKUP_TYPE = 'DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE'
				AND Z.SEGMENT1  = A.DIVISION_ID
				AND (LTRIM(RTRIM(Z.SEGMENT2)) = LTRIM(RTRIM(A.SENDER_CODE)) OR (LTRIM(RTRIM(Z.SEGMENT2)) IS NULL AND LTRIM(RTRIM(A.SENDER_CODE)) IS NULL))
				AND (LTRIM(RTRIM(Z.SEGMENT3)) = LTRIM(RTRIM(A.UNLOADING_POINT)) OR (LTRIM(RTRIM(Z.SEGMENT3)) IS NULL AND LTRIM(RTRIM(A.UNLOADING_POINT)) IS NULL))
				AND (LTRIM(RTRIM(Z.SEGMENT4)) = LTRIM(RTRIM(A.CUST_MATERIAL_CODE)) OR (LTRIM(RTRIM(Z.SEGMENT4)) IS NULL AND LTRIM(RTRIM(A.CUST_MATERIAL_CODE)) IS NULL))
				AND Z.VALID_YN = 'Y'
				AND (A.YYYYMMDD BETWEEN Z.ATTRIBUTE2 AND Z.ATTRIBUTE3)
			);

			UPDATE DM_DNM_EDI_CALLOFF_ITEM A
			SET   EXCEPTION_FLAG = NULL
				, EXCEPTION_DATE = NULL
				, LAST_UPDATE_DATE = SYSDATE
				, LAST_UPDATED_BY = 'scm_batch_exception_2'
			WHERE 1=1
			AND A.CREATE_DATE >= V_FROM_YYYYMMDD
			/* AND A.EXCEPTION_FLAG = 'Y' */
			AND EXISTS
			(
				SELECT 1
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL Z
				WHERE Z.LOOKUP_TYPE = 'DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE'
				AND Z.SEGMENT1  = A.DIVISION_ID
				AND (LTRIM(RTRIM(Z.SEGMENT2)) = LTRIM(RTRIM(A.SENDER_CODE)) OR (LTRIM(RTRIM(Z.SEGMENT2)) IS NULL AND LTRIM(RTRIM(A.SENDER_CODE)) IS NULL))
				AND (LTRIM(RTRIM(Z.SEGMENT3)) = LTRIM(RTRIM(A.UNLOADING_POINT)) OR (LTRIM(RTRIM(Z.SEGMENT3)) IS NULL AND LTRIM(RTRIM(A.UNLOADING_POINT)) IS NULL))
				AND (LTRIM(RTRIM(Z.SEGMENT4)) = LTRIM(RTRIM(A.CUST_MATERIAL_CODE)) OR (LTRIM(RTRIM(Z.SEGMENT4)) IS NULL AND LTRIM(RTRIM(A.CUST_MATERIAL_CODE)) IS NULL))
				AND Z.VALID_YN = 'N'
				AND (A.YYYYMMDD BETWEEN Z.ATTRIBUTE2 AND Z.ATTRIBUTE3)
			);

		END;

		COMMIT;

	END;

    /* ----------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇ */
    /* END TRY */
    /* ----------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇ */

        /* 종료 LOG (정상 경로) - 2026-06-17 fix */
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    EXCEPTION
        WHEN OTHERS THEN
      ROLLBACK;
      V_LOG_TYPE := 'ERROR';
      V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
      V_DESCRIPTION := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
      D_EVENT_DATE := SYSTIMESTAMP;

      PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    /* END CATCH */

    /* 종료 LOG */
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    /* V_DESCRIPTION := 'INVALID Count : ' || CAST((v_result_invalid_count) AS VARCHAR2(10)) ||' / '|| 'CUST_FCST INSERT INTO Count : ' || CAST((v_result_insert_count) AS VARCHAR2(10))  ; */
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

/* ERR_RTN: */

DBMS_OUTPUT.PUT_LINE('end '  ||  TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
  END;