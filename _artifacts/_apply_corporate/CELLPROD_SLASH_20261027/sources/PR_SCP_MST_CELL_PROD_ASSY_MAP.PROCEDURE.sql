PROCEDURE PR_SCP_MST_CELL_PROD_ASSY_MAP
/*
 * Program ID  : [PR_SCP_MST_CELL_PROD_ASSY_MAP]
 * Description : Cell Product/Cell Assy 매핑 정보 생성

	* 매핑 케이스
		1. Cell Product - Cell Assy1
		   - Cell Product - Cell Assy1
		2. TCO Cell Product - Cell Product - Cell Assy1
		   - TCO Cell Product - Cell Assy1
		   - Cell Product - Cell Assy1
		3. TCO Cell Product - Cell Assy2 - Cell Assy1
		   - TCO Cell Product - Cell Assy2
		   - TCO Cell Product - Cell Assy12023

	* source table : SCM_MST_BOM_SN
	* target table : SCP_MST_CELL_PROD_ASSY_MAP
 *
 * Program History
 *============================================================================================================================
 *   Date		In Charge	Description
 *============================================================================================================================
 * 2023/06/12	hrkim		Initial Release  [PJ20230691] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *   현재 한국만 생성 : 8월에 전체 생성으로 수정 필요함
 * 2023/07/12	hrkim		[PJ20230691] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 - 전체 생성으로 수정
 * 2023/12/18	hrkim		성능 이슈 대응 구조 변경
 * 2026.07.06   ZIONEX      [PJ202650304] NextSCM Migration
 *
*/
IS
    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_MST_CELL_PROD_ASSY_MAP';  /* Proc별 이름 설정 */
    V_LOG_TYPE      VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT     PLS_INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_BATCH_USER    VARCHAR2(150 CHAR) := 'scm_batch';

    /* 임시 실행시간 확인용 */
    V_START_TIME    DATE := SYSDATE;
    V_EXEC_TIME     VARCHAR2(10 CHAR) := '';  /* '[00:00]'; */
    V_ELAPSED_SEC   PLS_INTEGER;
BEGIN


    /* 시작 LOG  (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '##### Start of procedure #####';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;  /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
    /* 시작 LOG  (END) */

/* 2023.12.18 변경전
			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 1 #tmp_CELL_PROD_ASSY_MAP 추출 - 대상 데이터 추출'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#tmp_CELL_PROD_ASSY_MAP')  IS NOT NULL
				DROP TABLE #tmp_CELL_PROD_ASSY_MAP ;

			SELECT *
			  INTO #tmp_CELL_PROD_ASSY_MAP
			 FROM (
					-- Parent - Child 구조
					SELECT DISTINCT B.DIVISION_ID
								  , B.PLANT_ID
								  , B.PARENT_ITEM_ID	AS CELL_PROD
								  , B.CHILD_ITEM_ID		AS CELL_ASSY
								  , FA.ATTRIBUTE8		AS CELL_TYPE
					FROM SCM_MST_BOM_SN B WITH(NOLOCK)
						INNER JOIN  SCM_MST_ITEM_SN P WITH(NOLOCK)	-- parent
								ON P.DIVISION_ID		 = B.DIVISION_ID
							   AND P.COMPANY_ID			 = B.COMPANY_ID
							   AND P.SITE_ID			 = B.SITE_ID
							   AND P.ITEM_ID			 = B.PARENT_ITEM_ID
							   AND P.ACTIVE_FLAG		 = 'Y'
							   AND P.SCP_OPERATION_GROUP = 'A'
						INNER JOIN SCP_MST_FINAL_ITEM FP WITH(NOLOCK)
								ON FP.DIVISION_ID		 = B.DIVISION_ID
							   AND FP.ITEM_ID			 = B.PARENT_ITEM_ID
							   AND FP.ATTRIBUTE8		 = 'CP'
						INNER JOIN SCM_MST_ITEM_SN C WITH(NOLOCK)       -- child
								ON C.DIVISION_ID		 = B.DIVISION_ID
							   AND C.COMPANY_ID			 = B.COMPANY_ID
							   AND C.SITE_ID			 = B.SITE_ID
							   AND C.ITEM_ID			 = B.CHILD_ITEM_ID
							   AND C.ACTIVE_FLAG		 = 'Y'
							   AND C.SCP_OPERATION_GROUP = 'A'
						INNER JOIN SCP_MST_FINAL_ITEM FA WITH(NOLOCK)
								ON FA.DIVISION_ID		= B.DIVISION_ID
							   AND FA.ITEM_ID			= B.CHILD_ITEM_ID
							   AND FA.ATTRIBUTE8		IN ('CA1', 'CA2')
					WHERE 1=1
			-- 현재 한국만 생성 : 8월에 전체 생성으로 수정 필요함
			--AND B.company_id = 'C100'
					UNION ALL
					-- Model ID 하위 Cell Assy 전체 (Model과 Parent가 같은 건 제외 : Parent-Child 구조 결과에 포함됨)
					SELECT DISTINCT B.DIVISION_ID
								  , B.PLANT_ID
								  , B.MODEL_ID			AS CELL_PROD
								  , B.CHILD_ITEM_ID		AS CELL_ASSY
								  , FA.ATTRIBUTE8		AS CELL_TYPE
					FROM SCM_MST_BOM_SN B WITH(NOLOCK)
						INNER JOIN  SCM_MST_ITEM_SN P WITH(NOLOCK)	-- model
								ON P.DIVISION_ID		 = B.DIVISION_ID
							   AND P.COMPANY_ID			 = B.COMPANY_ID
							   AND P.SITE_ID			 = B.SITE_ID
							   AND P.ITEM_ID			 = B.MODEL_ID
							   AND P.ACTIVE_FLAG		 = 'Y'
							   AND P.SCP_OPERATION_GROUP = 'A'
						INNER JOIN SCP_MST_FINAL_ITEM FP WITH(NOLOCK)
								ON FP.DIVISION_ID		 = B.DIVISION_ID
							   AND FP.ITEM_ID			 = B.MODEL_ID
							   AND FP.ATTRIBUTE8		 = 'CP'
						INNER JOIN SCM_MST_ITEM_SN C WITH(NOLOCK)       -- child
								ON C.DIVISION_ID		 = B.DIVISION_ID
							   AND C.COMPANY_ID			 = B.COMPANY_ID
							   AND C.SITE_ID			 = B.SITE_ID
							   AND C.ITEM_ID			 = B.CHILD_ITEM_ID
							   AND C.ACTIVE_FLAG		 = 'Y'
							   AND C.SCP_OPERATION_GROUP = 'A'
						INNER JOIN SCP_MST_FINAL_ITEM FA WITH(NOLOCK)
								ON FA.DIVISION_ID		= B.DIVISION_ID
							   AND FA.ITEM_ID			= B.CHILD_ITEM_ID
							   AND FA.ATTRIBUTE8		IN ('CA1', 'CA2')
					WHERE 1=1
			-- 현재 한국만 생성 : 8월에 전체 생성으로 수정 필요함
			--AND B.company_id = 'C100'
					  AND B.PARENT_ITEM_ID	 != B.MODEL_ID -- Parent - Child 구조 제외
				) AS TG
*/
    /* --------------------------------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 0.1 #tmp_CELL_PROD 추출 - Cell Product');
    /* --------------------------------------------------------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_SMCPA_CELL_PROD;

    INSERT
      INTO GT_SMCPA_CELL_PROD
         ( DIVISION_ID_CP
         , ITEM_ID_CP
         , COMPANY_ID_CP
         , SITE_ID_CP )
    SELECT FC.DIVISION_ID AS DIVISION_ID_CP
         , FC.ITEM_ID AS ITEM_ID_CP
         , P.COMPANY_ID AS COMPANY_ID_CP
         , P.SITE_ID AS SITE_ID_CP
      FROM SCP_MST_FINAL_ITEM FC
         , SCM_MST_ITEM_SN    P
     WHERE 1 = 1
       AND P.DIVISION_ID = FC.DIVISION_ID
       AND P.ITEM_ID = FC.ITEM_ID
       AND P.ACTIVE_FLAG = 'Y'
       AND P.SCP_OPERATION_GROUP = 'A'
       AND FC.ATTRIBUTE8 = 'CP';

    /* --------------------------------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 0.1 #tmp_CELL_ASSY 추출 - Cell Assy');
    /* --------------------------------------------------------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_SMCPA_CELL_ASSY;

    INSERT
      INTO GT_SMCPA_CELL_ASSY
         ( DIVISION_ID_CA
         , ITEM_ID_CA
         , CELL_TYPE
         , COMPANY_ID_CA
         , SITE_ID_CA )
    SELECT FA.DIVISION_ID AS DIVISION_ID_CA
         , FA.ITEM_ID AS ITEM_ID_CA
         , FA.ATTRIBUTE8 AS CELL_TYPE
         , C.COMPANY_ID AS COMPANY_ID_CA
         , C.SITE_ID AS SITE_ID_CA
      FROM SCP_MST_FINAL_ITEM FA
         , SCM_MST_ITEM_SN    C
     WHERE 1 = 1
       AND C.DIVISION_ID = FA.DIVISION_ID
       AND C.ITEM_ID = FA.ITEM_ID
       AND C.ACTIVE_FLAG = 'Y'
       AND C.SCP_OPERATION_GROUP = 'A'
       AND FA.ATTRIBUTE8 IN ('CA1', 'CA2');

    /* --------------------------------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 1 #tmp_CELL_PROD_ASSY_MAP 추출 - 대상 데이터 추출');
    /* --------------------------------------------------------------------------------------------------------------------------------------- */
    DELETE
      FROM GT_SMCPA_CELL_PROD_ASSY_MAP;

    INSERT
      INTO GT_SMCPA_CELL_PROD_ASSY_MAP
         ( DIVISION_ID
         , PLANT_ID
         , CELL_PROD
         , CELL_ASSY
         , CELL_TYPE )
    SELECT SRC.DIVISION_ID
         , SRC.PLANT_ID
         , SRC.CELL_PROD
         , SRC.CELL_ASSY
         , SRC.CELL_TYPE
      FROM (
            /* Parent - Child 구조 */
            SELECT DISTINCT B.DIVISION_ID
                          , B.PLANT_ID
                          , B.PARENT_ITEM_ID AS CELL_PROD
                          , B.CHILD_ITEM_ID AS CELL_ASSY
                          , CA.CELL_TYPE
              FROM GT_SMCPA_CELL_ASSY CA
                 , SCM_MST_BOM_SN     B
                 , GT_SMCPA_CELL_PROD CP
             WHERE 1 = 1
               AND B.CHILD_ITEM_ID = CA.ITEM_ID_CA
               AND B.DIVISION_ID = CA.DIVISION_ID_CA
               AND CP.ITEM_ID_CP = B.PARENT_ITEM_ID
               AND CP.DIVISION_ID_CP = B.DIVISION_ID

            UNION ALL

            SELECT DISTINCT B.DIVISION_ID
                          , B.PLANT_ID
                          , B.MODEL_ID AS CELL_PROD
                          , B.CHILD_ITEM_ID AS CELL_ASSY
                          , CA.CELL_TYPE
              FROM GT_SMCPA_CELL_ASSY CA
                 , SCM_MST_BOM_SN     B
                 , GT_SMCPA_CELL_PROD CP
             WHERE 1 = 1
               AND B.CHILD_ITEM_ID = CA.ITEM_ID_CA
               AND B.DIVISION_ID = CA.DIVISION_ID_CA
               AND B.COMPANY_ID = CA.COMPANY_ID_CA
               AND B.SITE_ID = CA.SITE_ID_CA
               AND B.MODEL_ID = CP.ITEM_ID_CP
               AND B.DIVISION_ID = CP.DIVISION_ID_CP
               AND B.COMPANY_ID = CP.COMPANY_ID_CP
               AND B.SITE_ID = CP.SITE_ID_CP
               AND B.PARENT_ITEM_ID != B.MODEL_ID /* Parent - Child 구조 제외 */
    ) SRC;

    /* --------------------------------------------------------------- 최종 테이블에 반영 -------------------------------------------------------------- */


    /* --------------------------------------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 2.1 대상에 없는 기 생성 데이터 VALID_YN 업데이트 ');
    /* --------------------------------------------------------------------------------------------------------------------------------------------- */
    UPDATE SCP_MST_CELL_PROD_ASSY_MAP TGT
       SET TGT.VALID_YN = 'N'
         , TGT.LAST_UPDATE_DATE = SYSDATE
         , TGT.LAST_UPDATED_BY = V_PROGRAM_NAME
     WHERE 1 = 1
       AND TGT.VALID_YN = 'Y'
       AND NOT EXISTS (
            SELECT 1
              FROM GT_SMCPA_CELL_PROD_ASSY_MAP F
             WHERE F.DIVISION_ID = TGT.DIVISION_ID
               AND F.PLANT_ID = TGT.PLANT_ID
               AND F.CELL_PROD = TGT.ITEM_ID_PROD
               AND F.CELL_ASSY = TGT.ITEM_ID_ASSY );

    /* ----------------------------------------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 2.2 MERGE INTO (UPDATE / INSERT) ');
    /* ----------------------------------------------------------------------------------------------------------------------------------------------- */
    MERGE INTO SCP_MST_CELL_PROD_ASSY_MAP TGT
    USING (
            SELECT F.DIVISION_ID
                 , F.PLANT_ID
                 , F.CELL_PROD AS ITEM_ID_PROD
                 , F.CELL_ASSY AS ITEM_ID_ASSY
                 , F.CELL_TYPE
              FROM GT_SMCPA_CELL_PROD_ASSY_MAP F
             WHERE 1 = 1
               AND NOT EXISTS (
                    /* TGT와 동일한 값으로 존재하는 건 제외 (VALID_YN = 'Y') */
                    SELECT 1
                      FROM SCP_MST_CELL_PROD_ASSY_MAP T
                     WHERE 1 = 1
                       AND T.DIVISION_ID = F.DIVISION_ID
                       AND T.PLANT_ID = F.PLANT_ID
                       AND T.ITEM_ID_PROD = F.CELL_PROD
                       AND T.ITEM_ID_ASSY = F.CELL_ASSY
                       AND T.CELL_TYPE = F.CELL_TYPE
                       AND T.VALID_YN = 'Y' )
    ) SRC
    ON  ( TGT.DIVISION_ID = SRC.DIVISION_ID
      AND TGT.PLANT_ID = SRC.PLANT_ID
      AND TGT.ITEM_ID_PROD = SRC.ITEM_ID_PROD
      AND TGT.ITEM_ID_ASSY = SRC.ITEM_ID_ASSY )
    WHEN MATCHED THEN
         UPDATE SET LAST_UPDATE_DATE = SYSDATE
                  , LAST_UPDATED_BY = V_PROGRAM_NAME
                  , VALID_YN = 'Y'
                  , CELL_TYPE = SRC.CELL_TYPE
    WHEN NOT MATCHED THEN
         INSERT (
                  DIVISION_ID
                , PLANT_ID
                , ITEM_ID_PROD
                , ITEM_ID_ASSY
                , CELL_TYPE
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
         VALUES (
                  SRC.DIVISION_ID
                , SRC.PLANT_ID
                , SRC.ITEM_ID_PROD
                , SRC.ITEM_ID_ASSY
                , SRC.CELL_TYPE
                , 'Y'             /* VALID_YN */
                , V_PROGRAM_NAME  /* created_by */
                , SYSDATE         /* creation_date */
                , V_PROGRAM_NAME  /* last_updated_by */
                , SYSDATE         /* last_update_date */
                );


    COMMIT;

    V_ELAPSED_SEC := ROUND((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME   := LPAD(TO_CHAR(TRUNC(V_ELAPSED_SEC / 60)), 2, '0') || ':' ||
                     LPAD(TO_CHAR(MOD(V_ELAPSED_SEC, 60)), 2, '0');
    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '##### END of procedure #####';
    V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( V_PROGRAM_NAME
                         ,V_LOG_TYPE
                         ,N_LOG_COUNT
                         ,V_LOG_MESSAGE
                         ,V_DESCRIPTION
                         ,D_EVENT_DATE
                         ,V_BATCH_USER
                         );
    RETURN;

EXCEPTION
    WHEN OTHERS THEN

        IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
            ROLLBACK;
        END IF;

        /* ERROR LOG */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( V_PROGRAM_NAME
                             ,V_LOG_TYPE
                             ,N_LOG_COUNT
                             ,V_LOG_MESSAGE
                             ,V_DESCRIPTION
                             ,D_EVENT_DATE
                             ,V_BATCH_USER
                             );
        DBMS_OUTPUT.PUT_LINE(V_LOG_MESSAGE || ' : ' || V_DESCRIPTION);
        RETURN;
END PR_SCP_MST_CELL_PROD_ASSY_MAP;