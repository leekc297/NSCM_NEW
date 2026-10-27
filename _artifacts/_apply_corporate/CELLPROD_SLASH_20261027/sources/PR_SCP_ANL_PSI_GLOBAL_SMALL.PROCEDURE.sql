PROCEDURE PR_SCP_ANL_PSI_GLOBAL_SMALL
(
      P_PLAN_CYCLE            IN  VARCHAR2                       /* NVARCHAR(150) */
    , P_PLAN_START_YYYYMMDD   IN  VARCHAR2                       /* NVARCHAR(8)     -- plan_name */
    , P_PLAN_ID               IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_MODELING_ID           IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_SEQ                   IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_PLAN_TYPE             IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_MASTER_ID             IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_DIVISION_ID           IN  VARCHAR2                       /* NVARCHAR(30) */
    , P_ENGINE_PLAN_ID        IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_USER_ID               IN  VARCHAR2 DEFAULT 'scp_batch'   /* NVARCHAR(150)  = 'scp_batch' */
    /* ---- , @p_debug       INT OUTPUT */
    , O_RETURN                OUT NUMBER                         /* AS-IS RETURN 값 → OUT 인자(CNS 가이드) */
)
/*
 * Program ID   : PR_SCP_ANL_PSI_GLOBAL_SMALL
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :
                 DELETE FROM SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL_SMALL' AND CREATED_BY = 'KTH'

                 EXEC PR_SCP_ANL_PSI_GLOBAL_SMALL
                   @p_plan_cycle          = 'WEEKLY'
                 , @p_plan_start_yyyymmdd = '20181112'
                 , @p_plan_id             = '1052'
                 , @p_modeling_id         = '1'
                 , @p_seq                 = '1'
                 , @p_plan_type           = 'PR'
                 , @p_master_id           = '40::WEEKLY'
                 , @p_division_id         = '40'
                 , @p_engine_plan_id      = '1052::PR::1'
                 , @p_user_id             = 'KTH'

                 SELECT * FROM SCM_SYS_LOG_BATCH  WITH (NOLOCK)  WHERE PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL_SMALL' AND CREATED_BY = 'KTH'  order by CREATION_DATE desc

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.26   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.12.05   KTH         ATTRIBUTE9 조건 변경
 * 2018.12.14   KTH         MEASURE 삭제로직 반영
 * 2019.04.19   KTH         ATTRIBUTE2(ACTIVATE_PROGRESS, MODEL_INVENTORY) 추가
 * 2019.06.19   KTH         [CSR ID:4018125] Global PSI(Small) 내 Packer 셀 재고 행 추가 요청 - PACK SITE CELL 재고 'MODEL_INVENTORY' 추가
 * 2021.03.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 :: 0 값 삭제처리 추가
 * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.07.16   sclee.lee   PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) : scp_mst_bod_v에서 scp_mst_bod_n_v로 변경
 * 2021.11.11   sclee.lee   튜닝개선안에 따른 일부 쿼리 변경
 * 2022.03.23	KSW			GM JV 반영 :: 81_UC, EE_UC  추가
 * 2023.03.29	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.07.21	HRK			PJ20230691  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *                          ------------------------------------------------
 *							(사내TCO)  CP.TCO  > CA2.TCO > CA1
 *							(사외TCO)  CP.TCO  > CP      > CA1
 *							(일반)     CP      > CA1
 *                          ------------------------------------------------
 *							* 공통적용 i  :  FROM SITE의 Plant가 Cell Plant인 경우만 해당, Pack창고 Cell 재고는 대상 아님.
 *							* 공통적용 ii :  FROM SITE 외주(osp_yn = 'Y') 제외
 *                          ------------------------------------------------
 *							1. BOH/EOH(Model_Inventory) CA2 또는 CA1으로 통합 합산 적재
 *								  - 사내TCO 모델: CP.TCO -> CA2
 *								  - 사외TCO 모델: CP     -> CA1
 *								  - 일반    모델: CP     -> CA1
 *							2. 사외TCO 모델의 CP를 제외하고 CP(TCO포함) 모델 전구간 0인 데이터 삭제
 * 									------------------------------------------
 * 									 대상 measure
 * 									------------------------------------------
 * 									PRODUCTION				Production
 * 									ACTIVATE_COMPLETED		Char. Completed
 * 									CHAR_AVAILABLE			Char. Available
 * 									ACTIVATE_PROGRESS		Formation Progress
 * 									MODEL_INVENTORY			Model Inventory
 * 									DIO						DIO
 * 									------------------------------------------
 * 2023.08.03	HRK			PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 외주TCO 모델 출하정보로 생산정보 강제 생성한 Production 정보 제외
 *							(TCO : 사외 -> 사내 물류창고(P), CP : 사내 Plant -> 사외(P))
 *						     구분 방법 : PSI_VALUE값에 line이 아닌 사이트 정보가 있는 데이터
 * 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                          1. DIO 계산 오류 보완
 *                          2. 재고기준
 *                             1) 공장내 재고 기준으로 Inventroy 구성 - Packer 재고 제외 함
 *                             2) 공장내 재고 중 생산창고/ oWMS Measure구분 하여 표기
 *                          3. Prodtype –FN /PR  2 형태 유지
 *                          4. Sales RTF 기준으로 진행 함
 *
 *                          UI 수정 필요 항목
 *                          1. 조회 조건 버킷은 monthly  / Weekly / daily 유지
 *                          2. From site 선택 후에는  - Material [ 전체 / 선택 ] 가능 토록 변경
 *                          3. 조회 구간 52주 , 12개월 표시
 * 2025.09.03   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  :
 *                          활성화 후 공정 Cell이 존재하는 경우  Cell 정보를  활성화 후 공정 Cell로 설정
 *                          활성화 후 공정 Cell 수요 정보 추가
 * 2025.09.21   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  :
 *                          소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.27    ZIONEX      [PJ202650304] 티라엔진 제거 - SCP_PLN_SALES_ONHAND -> 통합 Dataset 기반 뷰(SCP_PLN_SALES_ONHAND_V) 교체
 */
IS
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; SET XACT_ABORT ON; */
    /* SET ANSI_WARNINGS OFF; → 임시 테이블 칸보다 긴 문자는 잘려 적재되던 것을 SUBSTR 로 재현 */

    /* AS-IS 인자 선언 길이 재현 : NVARCHAR(8) · NVARCHAR(30) · NVARCHAR(150) */
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)    := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_DIVISION_ID           VARCHAR2(30 CHAR)   := SUBSTR(P_DIVISION_ID, 1, 30);
    V_USER_ID               VARCHAR2(150 CHAR)  := SUBSTR(P_USER_ID, 1, 150);
    N_SEQ                   NUMBER(19);          /* @p_seq 를 BIGINT 칸과 비교·적재할 때의 암묵 변환 재현 */

    /* LOG 용 변수 설정 */
    V_BATCH_USER            VARCHAR2(150 CHAR)  := 'scp_batch';
    V_PROGRAM_NAME          VARCHAR2(150 CHAR)  := 'PR_SCP_ANL_PSI_GLOBAL_SMALL';
    V_LOG_TYPE              VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT             NUMBER(10)          := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    V_TABLE_ID              VARCHAR2(150 CHAR)  := 'PR_SCP_ANL_PSI_GLOBAL_SMALL';
    D_EVENT_DATE            DATE;

    /* 임시 실행시간 확인용 */
    V_START_TIME            DATE;
    V_EXEC_TIME             VARCHAR2(10 CHAR)   := NULL;  /* --'00:00'; */

    /* 364 일 */
    V_DD                    VARCHAR2(8 CHAR);

    /* * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start */
    V_PET_DATE              VARCHAR2(12 CHAR)   := NULL;

    /* 오류 로그용 */
    V_IN_PARA_DATA          VARCHAR2(4000 CHAR);
BEGIN
    O_RETURN := 1;  /* 반환값 초기화 (AS-IS 정상 종료값 return 1) */

    V_BATCH_USER := V_USER_ID;  /* SET     @v_batch_user = @p_user_id */

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' PR_SCP_ANL_PSI_GLOBAL_SMALL INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );
    /* 임시 실행시간 확인용 */
    V_START_TIME := SYSDATE;

    /* 364 일 */
    V_DD := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD');

    /*  Plan End Date */
    BEGIN
        SELECT A.HORIZON_END_DATE
          INTO V_PET_DATE
          FROM SCM_MST_PLAN A
         WHERE A.DIVISION_ID = V_DIVISION_ID
           AND A.PLAN_ID     = P_PLAN_ID
           AND ROWNUM        = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;  /* 대상 행이 없으면 변수 초깃값('') 유지 */
    END;

    V_DD := TO_CHAR(TO_DATE(V_PET_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD');
    /* * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end */

    BEGIN  /* BEGIN TRY */
        /* --BEGIN TRAN TX_PG */

        N_SEQ := TO_NUMBER(P_SEQ);

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL') IS NOT NULL DROP TABLE .. / #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 */
        /* CREATE TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL → GTT GT_APGS_PSI_GLOBAL_SMALL */
        /*   --	PROJECT_CODE            NVARCHAR(50)    NOT NULL, */
        /*   --            CELL_QTY_PER_PACK       NUMERIC(20, 10) NULL,     -- cell qty/pack 컬럼 신청해야 함. ( 기존에 유사한 CELL_REQ_QTY_PER_PACK 있음) */
        /*   ATTRIBUTE1  : 입력 테이블 flag 임시 SCP_ANL_SHIPMENT_PLAN_SEMI / SCP_ANL_PSI_PRODUCTION / SCP_ANL_SHIPMENT_PLAN_FG */
        /*   ATTRIBUTE2  : BOH ATTRIBUTE2(ACTIVATE_PROGRESS, MODEL_INVENTORY) 추가 */
        /*   ATTRIBUTE3  : 활성화코드 분리 대응 (CP/CA 통합 합산 적용 구분-검증을 위해) */
        /*   ATTRIBUTE4  : 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 / cell item class name 추가 */
        /*   ATTRIBUTE9  : operaton_id 추가 */
        /*   ATTRIBUTE10 : 정렬 추가 */
        /* --2021.11.11 튜닝개선안에 따른 쿼리구문 추가 (#tmp_SCP_ANL_PSI_GLOBAL_SMALL2 → GT_APGS_PSI_GLOBAL_SMALL2) */
        DELETE FROM GT_APGS_PSI_GLOBAL_SMALL;
        DELETE FROM GT_APGS_PSI_GLOBAL_SMALL2;

        /*   MEASURE 정리

              MKT_FCST              SCP_ANL_SHIPMENT_PLAN_FG
              ALLOCATION            SCP_ANL_SHIPMENT_PLAN_FG
              BALANCE               SCP_ANL_SHIPMENT_PLAN_FG
              WH_IN                 SCP_ANL_SHIPMENT_PLAN_FG
              SHIP_REQ              SCP_ANL_SHIPMENT_PLAN_FG
              SHIP_PLAN             SCP_ANL_SHIPMENT_PLAN_FG
              WH_IN_BALANCE         SCP_ANL_SHIPMENT_PLAN_FG

              SHIP_PLAN             SCP_ANL_SHIPMENT_PLAN_SEMI
              SHIP_REQ	            SCP_ANL_SHIPMENT_PLAN_SEMI


              ALLOCATION            '0' 채움
              BALANCE               '0' 채움
              MKT_FCST              '0' 채움
              WH_IN                 로직 추가

                        MODEL_INVENTORY       SCP_ANL_PSI_PRODUCTION	 -- ( 'CHAR', 'A_MOVE_WH','A_OUT_WH')
                            --  1.5.CHAR     : 특성완료 A~002    'CHAR'     /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'   AND A.SITE_ID like '%002'
					       	    --  1.6.A_OUT_WH : 출하창고 A~003    'A_OUT_WH' /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'   AND A.SITE_ID like '%003'
    Formation Progress  ACTIVATE_PROGRESS     SCP_ANL_PSI_PRODUCTION	 -- ( 'ASSM','FORMED')
			                --  1.4.ASSM     : ASSM            'ASSM'      /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'  AND A.SITE_ID like '%-A~***'
					       	    --  1.8. FORMED              'FORMED'/CATEGORY/SUM(ISNULL(A.QTY,0)) : AND B.OPERATION_GROUP ='A' AND A.SITE_ID like '%A~001'
                        DIO                   계산(ACTIVATE_PROGRESS+MODEL_INVENTORY - WH_IN)
    Char. Available     CHAR_AVAILABLE        SCP_ANL_PSI_PRODUCTION	 -- 'FORMED' 특성 가능 수량. EOH
    Char. Completed     ACTIVATE_COMPLETED    SCP_ANL_PSI_PRODUCTION	 -- F6000 공정으로 구분. 셀 특성완료 생산계획=F6000 생산계획


              PRODUCTION            로직
        */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 0.1 CALENDAR 생성 (속도 계선) */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_APGS_YYYYMMDD;

        INSERT
          INTO GT_APGS_YYYYMMDD
             ( YYYYMMDD
             )
        SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
          FROM SCM_SYS_CALENDAR_M C
         WHERE C.BASIS_YYYYMMDD >= V_PLAN_START_YYYYMMDD
           AND C.BASIS_YYYYMMDD <  V_DD;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 1. SEMI 입력   TO SITE TRANSPORT_MODE */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.ITEM_ID
             , NULL                         AS CELL_ITEM_ID
             , A.TO_SITE
             , NULL                         AS TO_BOH_QTY
             , NULL                         AS INCOTERMS
             , A.FROM_SITE
             , NULL                         AS FROM_BOH_QTY
             , A.BOD_ID
             , NULL                         AS TRANSPORT_MODE_LINE
             , A.MEASURE
             , A.YYYYMMDD
             , A.QTY
             , 'SCP_ANL_SHIPMENT_PLAN_SEMI'
          FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
         WHERE A.MEASURE            IN ('SHIP_PLAN', 'SHIP_REQ')
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2. PSI 입력 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /*
          I	MODEL_INVENTORY
          I	ACTIVATE_PROGRESS
          I	CHAR_AVAILABLE
          I	ACTIVATE_COMPLETED
        */
        /* PSI_TYPE 'P' 의 TO_SITE 빈 문자('') → Oracle NULL (최종 적재에서 '-' 로 채움) */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.ITEM_ID
             , NULL                                                                      AS CELL_ITEM_ID
               /* --                      ,A.TO_SITE */
             , (CASE WHEN A.PSI_TYPE = 'P' THEN NULL ELSE A.TO_SITE END)                AS TO_SITE
             , NULL                                                                      AS TO_BOH_QTY
             , NULL                                                                      AS INCOTERMS
             , A.FROM_SITE
             , NULL                                                                      AS FROM_BOH_QTY
             , NULL                                                                      AS BOD_ID
             , (CASE WHEN A.PSI_TYPE = 'P' THEN A.PSI_VALUE ELSE NULL END)              AS TRANSPORT_MODE_LINE
             , (CASE WHEN A.PSI_TYPE = 'P' THEN 'PRODUCTION'
                     WHEN A.PSI_TYPE = 'I' AND A.PSI_VALUE IN ('ACTIVATE_PROGRESS', 'CHAR_AVAILABLE', 'MODEL_INVENTORY', 'ACTIVATE_COMPLETED') THEN A.PSI_VALUE
                     ELSE '-' END)                                                       AS MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)                                                                AS QTY
             , 'SCP_ANL_PSI_PRODUCTION'
          FROM SCP_ANL_PSI_PRODUCTION A
         WHERE A.PSI_VALUE          <> 'DIO'
           AND A.PSI_VALUE          <> 'ISSUM'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
         GROUP BY A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.OPERATION_GROUP
                , A.ITEM_ID
                  /* --                      ,A.TO_SITE */
                , (CASE WHEN A.PSI_TYPE = 'P' THEN NULL ELSE A.TO_SITE END)
                , A.FROM_SITE
                , (CASE WHEN A.PSI_TYPE = 'P' THEN A.PSI_VALUE ELSE NULL END)
                , (CASE WHEN A.PSI_TYPE = 'P' THEN 'PRODUCTION'
                        WHEN A.PSI_TYPE = 'I' AND A.PSI_VALUE IN ('ACTIVATE_PROGRESS', 'CHAR_AVAILABLE', 'MODEL_INVENTORY', 'ACTIVATE_COMPLETED') THEN A.PSI_VALUE
                        ELSE '-' END)
                , A.YYYYMMDD;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 3. FG 입력   FROM SITE TRANSPORT_MODE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* BIZ_TYPE(30자) → OPERATION_GROUP(10자) : ANSI_WARNINGS OFF 잘림 재현 */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT /* --DISTINCT   -- PROJECT CODE 중복이 있으므로 */
               A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , SUBSTR(A.BIZ_TYPE, 1, 10)    AS OPERATION_GROUP
             , A.ITEM_ID
             , NULL                         AS CELL_ITEM_ID
             , A.TO_SITE
             , NULL                         AS TO_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , NULL                         AS FROM_BOH_QTY
             , A.BOD_ID
             , NULL                         AS TRANSPORT_MODE_LINE
             , A.MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)                   AS QTY
             , 'SCP_ANL_SHIPMENT_PLAN_FG'
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
         WHERE A.MEASURE        NOT IN ('SHIP_PLAN_AMEND')
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
         GROUP BY A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.BIZ_TYPE
                , A.ITEM_ID
                , A.TO_SITE
                , A.INCOTERMS
                , A.FROM_SITE
                , A.BOD_ID
                , A.MEASURE
                , A.YYYYMMDD;
                  /* --,A.QTY */
                  /* --                    ,NULL AS TRANSPORT_MODE_LINE */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PACK SITE CELL 재고 'MODEL_INVENTORY' 추가 */
        /* 정렬을 위한 ATTRIBUTE10 ='2' 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , ATTRIBUTE10
             )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , 'A'                          AS OPERATION_GROUP
             , ITEM_ID
             , ITEM_ID                      AS CELL_ITEM_ID
             , '-'                          AS TO_SITE
             , NULL                         AS TO_BOH_QTY
             , '-'                          AS INCOTERMS
             , SITE_ID                      AS FROM_SITE
             , NULL                         AS FROM_BOH_QTY
             , '-'                          AS BOD_ID
             , NULL                         AS TRANSPORT_MODE_LINE
             , 'MODEL_INVENTORY'            AS MEASURE  /* --- PACK SITE CELL 재고 */
             , YYYYMMDD
             , (NVL(PSI_EOH_QTY, 0))        AS PSI_BOH_QTY
             , 'CELL'                       AS ATTRIBUTE1
             , '2'                          AS ATTRIBUTE10
          FROM SCP_PLN_PLANT_ONHAND
         WHERE OPERATION_GROUP     = 'A'
           /* --             AND ITEM_ID                   = @p_item_id */
           AND SITE_ID          LIKE '%-P'
           AND STOCK_TYPE          = 'A_PACK'
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND PLAN_TYPE           = P_PLAN_TYPE
           AND SEQ                 = N_SEQ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* owms 재고 구분하여 정보 입력 MEASURE 'OWMS_MODEL_INVENTORY' 추가 */
        /* 정렬을 위한 ATTRIBUTE10 ='3' 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , ATTRIBUTE10
             )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.ITEM_ID
             , NULL                         AS CELL_ITEM_ID
             , NULL                         AS TO_SITE  /* '' */
             , NULL                         AS TO_BOH_QTY
             , NULL                         AS INCOTERMS
             , A.SITE_ID                    AS FROM_SITE
             , NULL                         AS FROM_BOH_QTY
             , '-'                          AS BOD_ID
             , NULL                         AS TRANSPORT_MODE_LINE
             , 'OWMS_MODEL_INVENTORY'       AS MEASURE  /* --- OWMS 창고 재고 */
             , A.YYYYMMDD
             , SUM(NVL(A.PSI_EOH_QTY, 0))   AS PSI_BOH_QTY
             , 'CELL_WH'                    AS ATTRIBUTE1
             , '3'                          AS ATTRIBUTE10
          FROM SCP_PLN_PLANT_ONHAND A
         WHERE A.OPERATION_GROUP     = 'A'
           AND A.STOCK_TYPE         IN ('A_MOVE_WH', 'A_OUT_WH')
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
         GROUP BY A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.OPERATION_GROUP
                , A.ITEM_ID
                , A.SITE_ID
                , A.YYYYMMDD;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* 사내 Cell 수량 계산 MEASURE 'INCP_MODEL_INVENTORY' 추가 */
        /* 정렬을 위한 ATTRIBUTE10 ='3' 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , ATTRIBUTE10
             )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.ITEM_ID
             , NULL                                   AS CELL_ITEM_ID
             , NULL                                   AS TO_SITE  /* '' */
             , NULL                                   AS TO_BOH_QTY
             , NULL                                   AS INCOTERMS
             , A.FROM_SITE
             , NULL                                   AS FROM_BOH_QTY
             , '-'                                    AS BOD_ID
             , NULL                                   AS TRANSPORT_MODE_LINE
             , 'INCP_MODEL_INVENTORY'                 AS MEASURE  /* --- 사내 창고 재고 */
             , A.YYYYMMDD
             , NVL(A.QTY, 0) - NVL(B.QTY, 0)          AS QTY
             , 'CELL_WH'                              AS ATTRIBUTE1
             , '3'                                    AS ATTRIBUTE10
          FROM GT_APGS_PSI_GLOBAL_SMALL A
             , GT_APGS_PSI_GLOBAL_SMALL B
         WHERE A.DIVISION_ID         = B.DIVISION_ID(+)
           AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD(+)
           AND A.PLAN_TYPE           = B.PLAN_TYPE(+)
           AND A.SEQ                 = B.SEQ(+)
           AND A.OPERATION_GROUP     = B.OPERATION_GROUP(+)
           AND A.ITEM_ID             = B.ITEM_ID(+)
           AND A.FROM_SITE           = B.FROM_SITE(+)
           AND A.YYYYMMDD            = B.YYYYMMDD(+)
           AND B.MEASURE(+)          = 'OWMS_MODEL_INVENTORY'
           AND B.ATTRIBUTE1(+)       = 'CELL_WH'
           AND A.OPERATION_GROUP     = 'A'
           AND A.MEASURE             = 'MODEL_INVENTORY'
           AND A.ATTRIBUTE1          = 'SCP_ANL_PSI_PRODUCTION'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ;

        /* --------------------------------------------------------------------------------------------------------------------- */
        /* BEGIN 2023.07.28 활성화코드 분리 대응 -- Cell Product EOH(Model Inventory)를 Cell Assy로 합산 적용 */
        /* --------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '### stp1. 활성화코드 분리에 따른 대상 Cell 모델 Parent/Child 추출');
        /* --------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_APGS_CELL_BOM_40;        /* IF OBJECT_ID('TEMPDB..#TMP_CELL_BOM_40') IS NOT NULL DROP TABLE #TMP_CELL_BOM_40; */
        DELETE FROM GT_APGS_TARGET_TO_CONVERT;  /* IF OBJECT_ID('TEMPDB..#TMP_TARGET_TO_CONVERT') IS NOT NULL DROP TABLE #TMP_TARGET_TO_CONVERT; */

        INSERT
          INTO GT_APGS_CELL_BOM_40
             ( COMPANY_ID
             , PLANT_ID
             , MODEL_ID
             , PARENT_ITEM_ID
             , CHILD_ITEM_ID
             , CONCATENATE_ITEM
             , TCO_CELL_YN_P
             , TCO_CELL_YN_C
             , CELL_TYPE_P
             , CELL_TYPE_C
             , FLOW_ID_P
             , FLOW_ID_C
             )
        SELECT A.COMPANY_ID
             , A.PLANT_ID
             , A.MODEL_ID
             , A.PARENT_ITEM_ID
             , A.CHILD_ITEM_ID
             , A.CONCATENATE_ITEM
             , C.TCO_CELL_YN                AS TCO_CELL_YN_P
             , B.TCO_CELL_YN                AS TCO_CELL_YN_C
             , C.ATTRIBUTE8                 AS CELL_TYPE_P
             , B.ATTRIBUTE8                 AS CELL_TYPE_C
             , C.FLOW_ID                    AS FLOW_ID_P
             , B.FLOW_ID                    AS FLOW_ID_C
          FROM SCM_MST_BOM_SN     A
             , SCP_MST_FINAL_ITEM B  /* -- Child */
             , SCP_MST_FINAL_ITEM C  /* -- Parent */
         WHERE B.DIVISION_ID     = A.DIVISION_ID
           AND B.ITEM_ID         = A.CHILD_ITEM_ID
           AND C.DIVISION_ID     = A.DIVISION_ID
           AND C.ITEM_ID         = A.PARENT_ITEM_ID
           AND B.OPERATION_GROUP = 'A'  /* -- Cell */
           AND C.OPERATION_GROUP = 'A'  /* -- Cell */
           AND A.DIVISION_ID     = '40';  /* -- 소형 */

        /* 2025.09.21   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : */
        /*                          소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완 */
        INSERT
          INTO GT_APGS_CELL_BOM_40
             ( COMPANY_ID
             , PLANT_ID
             , MODEL_ID
             , PARENT_ITEM_ID
             , CHILD_ITEM_ID
             , CONCATENATE_ITEM
             , TCO_CELL_YN_P
             , TCO_CELL_YN_C
             , CELL_TYPE_P
             , CELL_TYPE_C
             , FLOW_ID_P
             , FLOW_ID_C
             )
        SELECT A.COMPANY_ID
             , A.PLANT_ID
             , A.MODEL_ID
             , A.MODEL_ID                   AS PARENT_ITEM_ID
             , A.CHILD_ITEM_ID
             , A.CONCATENATE_ITEM
             , E.TCO_CELL_YN                AS TCO_CELL_YN_P
             , B.TCO_CELL_YN                AS TCO_CELL_YN_C
             , E.ATTRIBUTE8                 AS CELL_TYPE_P
             , B.ATTRIBUTE8                 AS CELL_TYPE_C
             , E.FLOW_ID                    AS FLOW_ID_P
             , B.FLOW_ID                    AS FLOW_ID_C
          FROM SCM_MST_BOM_SN        A
             , SCP_MST_FINAL_ITEM    B  /* -- Child */
             , SCM_MST_ITEM_SN       C  /* -- Parent */
             , SCM_MST_ITEM_CLASS_M  D  /* -- Parent Item Class */
             , SCP_MST_FINAL_ITEM    E  /* -- Model */
         WHERE B.DIVISION_ID     = A.DIVISION_ID
           AND B.ITEM_ID         = A.CHILD_ITEM_ID
           AND C.COMPANY_ID      = A.COMPANY_ID
           AND C.DIVISION_ID     = A.DIVISION_ID
           AND C.SITE_ID         = A.SITE_ID
           AND C.ITEM_ID         = A.PARENT_ITEM_ID
           AND C.ITEM_CLASS      = D.CLASS_ID
           AND E.DIVISION_ID     = A.DIVISION_ID
           AND E.ITEM_ID         = A.MODEL_ID
           AND NOT EXISTS (SELECT 1
                             FROM GT_APGS_CELL_BOM_40 CB
                            WHERE CB.COMPANY_ID     = A.COMPANY_ID
                              AND CB.PLANT_ID       = A.PLANT_ID
                              AND CB.MODEL_ID       = A.MODEL_ID
                              AND CB.PARENT_ITEM_ID = A.MODEL_ID
                              AND CB.CHILD_ITEM_ID  = A.CHILD_ITEM_ID)
           AND B.OPERATION_GROUP = 'A'  /* -- Cell */
           AND D.SCP_EXC_YN      = 'Y'
           AND E.OPERATION_GROUP = 'A'  /* -- Cell */
           AND A.DIVISION_ID     = '40'  /* -- 소형 */
           AND A.PARENT_ITEM_ID != '*';

        INSERT
          INTO GT_APGS_TARGET_TO_CONVERT
             ( PLANT_ID
             , PARENT_ITEM_ID
             , CHILD_ITEM_ID
             , TCO_CELL_YN_P
             , TCO_CELL_YN_C
             , CELL_TYPE_P
             , CELL_TYPE_C
             )
        SELECT TG.PLANT_ID
             , TG.PARENT_ITEM_ID
             , MIN(TG.CHILD_ITEM_ID)        AS CHILD_ITEM_ID
             , MIN(TG.TCO_CELL_YN_P)        AS TCO_CELL_YN_P
             , MIN(TG.TCO_CELL_YN_C)        AS TCO_CELL_YN_C
             , MIN(TG.CELL_TYPE_P  )        AS CELL_TYPE_P
             , MIN(TG.CELL_TYPE_C  )        AS CELL_TYPE_C
          FROM (
                /* -- TCO/CP > TCO/CA2 */
                SELECT DISTINCT
                       B.PLANT_ID
                     , B.PARENT_ITEM_ID
                     , B.CHILD_ITEM_ID
                     , B.TCO_CELL_YN_P
                     , B.TCO_CELL_YN_C
                     , B.CELL_TYPE_P
                     , B.CELL_TYPE_C
                  FROM GT_APGS_CELL_BOM_40 B
                 WHERE B.TCO_CELL_YN_P = 'Y'
                   AND B.CELL_TYPE_P   = 'CP'
                   AND B.TCO_CELL_YN_C = 'Y'
                   AND B.CELL_TYPE_C   = 'CA2'
                 UNION ALL
                /* -- CP > CA1 */
                SELECT DISTINCT
                       C.PLANT_ID
                     , C.PARENT_ITEM_ID
                     , C.CHILD_ITEM_ID
                     , C.TCO_CELL_YN_P
                     , C.TCO_CELL_YN_C
                     , C.CELL_TYPE_P
                     , C.CELL_TYPE_C
                  FROM GT_APGS_CELL_BOM_40 C
                 WHERE C.TCO_CELL_YN_P = 'N'
                   AND C.CELL_TYPE_P   = 'CP'
                   AND C.TCO_CELL_YN_C = 'N'
                   AND C.CELL_TYPE_C   = 'CA1'
               ) TG
         GROUP BY TG.PLANT_ID
                , TG.PARENT_ITEM_ID;

        /* --------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '### stp2. 대상 Cell Product Model Inventory 데이터 추출');
        /* --------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_APGS_TGT_CP_MODEL_INV;  /* IF OBJECT_ID('tempdb..#tgt_CELL_PRODUCT_MODEL_INVENTORY') IS NOT NULL DROP TABLE .. */

        INSERT
          INTO GT_APGS_TGT_CP_MODEL_INV
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE9
             , ATTRIBUTE10
             , PLANT_ID
             , CELL_ASSY
             )
        SELECT PG.DIVISION_ID
             , PG.PLAN_START_YYYYMMDD
             , PG.PLAN_TYPE
             , PG.SEQ
             , PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.CELL_ITEM_ID
             , PG.TO_SITE
             , PG.TO_BOH_QTY
             , PG.INCOTERMS
             , PG.FROM_SITE
             , PG.FROM_BOH_QTY
             , PG.BOD_ID
             , PG.TRANSPORT_MODE_LINE
             , PG.MEASURE
             , PG.YYYYMMDD
             , PG.QTY
             , PG.ATTRIBUTE1
             , PG.ATTRIBUTE2
             , PG.ATTRIBUTE3
             , PG.ATTRIBUTE4
             , PG.ATTRIBUTE9
             , PG.ATTRIBUTE10
             , FS.PLANT_ID
             , TG.CHILD_ITEM_ID             AS CELL_ASSY
          FROM GT_APGS_PSI_GLOBAL_SMALL  PG
             , SCM_MST_SITE              FS  /* -- 7월은 국내만 적용 */
             , GT_APGS_TARGET_TO_CONVERT TG
         WHERE FS.DIVISION_ID      = PG.DIVISION_ID
           AND FS.SCM_SITE_ID      = PG.FROM_SITE
           AND TG.PLANT_ID         = FS.PLANT_ID
           AND TG.PARENT_ITEM_ID   = PG.ITEM_ID
           AND FS.SITE_TYPE        = 'PLANT'
           AND FS.OPERATION_GROUP  = 'A'  /* -- Cell 창고 (Pack창고 Cell은 대상 아님) */
           AND FS.OSP_YN           = 'N'  /* -- OSP제외 */
           AND PG.MEASURE         IN ('INCP_MODEL_INVENTORY', 'MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY');
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* 'MODEL_INVENTORY'에 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY' 유형 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* --------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '### stp3. Cell Product Model Inventory 데이터 삭제');
        /* --------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_APGS_PSI_GLOBAL_SMALL X
         WHERE EXISTS (SELECT 1
                         FROM GT_APGS_TGT_CP_MODEL_INV TGT
                        WHERE TGT.CELL_ASSY IS NOT NULL
                          AND TGT.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
                          AND TGT.PLAN_TYPE           = X.PLAN_TYPE
                          AND TGT.SEQ                 = X.SEQ
                          AND TGT.DIVISION_ID         = X.DIVISION_ID
                          AND TGT.OPERATION_GROUP     = X.OPERATION_GROUP
                          AND TGT.ITEM_ID             = X.ITEM_ID  /* -- Cell Product */
                          AND TGT.FROM_SITE           = X.FROM_SITE
                          AND TGT.MEASURE             = X.MEASURE
                          AND TGT.YYYYMMDD            = X.YYYYMMDD);
                          /* -- NULL 또는 빈문자열 AND TGT.CELL_ITEM_ID			= X.CELL_ITEM_ID */
                          /* -- NULL 또는 빈문자열 AND TGT.TO_SITE				= X.TO_SITE */
                          /* -- NULL 또는 빈문자열 AND TGT.INCOTERMS				= X.INCOTERMS */
                          /* -- NULL 또는 빈문자열 AND TGT.BOD_ID				= X.BOD_ID */
                          /* -- NULL 또는 빈문자열 AND TGT.TRANSPORT_MODE_LINE	= X.TRANSPORT_MODE_LINE */

        /* --------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '### stp4. Cell Product Model Inventory 대상 데이터 Cell Assy에 합산 적용 (UPDATE / INSERT)');
        /* --------------------------------------------------------------------------------------------------------------------- */
        /* 원문 MERGE 구조 그대로 (배치) */
        /* ATTRIBUTE3 : 'UPDATE :: ' + CONVERT(NVARCHAR(40), 수량) .. → 소수 10자리 고정 문자, 수량 하나라도 NULL 이면 전체 NULL('+' 결합) */
        MERGE
         INTO GT_APGS_PSI_GLOBAL_SMALL TGT
        USING (SELECT IA.PLAN_START_YYYYMMDD
                    , IA.PLAN_TYPE
                    , IA.SEQ
                    , IA.DIVISION_ID
                    , IA.OPERATION_GROUP
                    , IA.CELL_ASSY                  AS ITEM_ID
                    , NULL                          AS CELL_ITEM_ID  /* -- 아래 로직에서 Cell Product로 일괄 Update됨. (SCP_ANL_PSI_PRODUCTION 'MODEL_INVENTORY'참조시  cell _item_id를 null로 넣고 있음) */
                    , IA.TO_SITE
                    , IA.INCOTERMS
                    , IA.FROM_SITE
                    , IA.BOD_ID
                    , IA.TRANSPORT_MODE_LINE
                    , IA.MEASURE
                    , IA.YYYYMMDD
                    , SUM(IA.QTY)                   AS QTY
                    , SUM(IA.FROM_BOH_QTY)          AS FROM_BOH_QTY
                    , SUM(IA.TO_BOH_QTY)            AS TO_BOH_QTY
                    , MAX(IA.ATTRIBUTE1)            AS ATTRIBUTE1
                    , MAX(IA.ATTRIBUTE2)            AS ATTRIBUTE2
                    , MAX(IA.ATTRIBUTE9)            AS ATTRIBUTE9
                    , MAX(IA.ATTRIBUTE10)           AS ATTRIBUTE10
                 FROM GT_APGS_TGT_CP_MODEL_INV IA
                WHERE IA.CELL_ASSY IS NOT NULL
                GROUP BY IA.PLAN_START_YYYYMMDD
                       , IA.PLAN_TYPE
                       , IA.SEQ
                       , IA.DIVISION_ID
                       , IA.OPERATION_GROUP
                       , IA.CELL_ASSY
                       , IA.TO_SITE
                       , IA.INCOTERMS
                       , IA.FROM_SITE
                       , IA.BOD_ID
                       , IA.TRANSPORT_MODE_LINE
                       , IA.MEASURE
                       , IA.YYYYMMDD
              ) SRC
           ON (    TGT.PLAN_START_YYYYMMDD = SRC.PLAN_START_YYYYMMDD
               AND TGT.PLAN_TYPE           = SRC.PLAN_TYPE
               AND TGT.SEQ                 = SRC.SEQ
               AND TGT.DIVISION_ID         = SRC.DIVISION_ID
               AND TGT.OPERATION_GROUP     = SRC.OPERATION_GROUP
               AND TGT.ITEM_ID             = SRC.ITEM_ID
               AND TGT.FROM_SITE           = SRC.FROM_SITE
               AND TGT.MEASURE             = SRC.MEASURE
               AND TGT.YYYYMMDD            = SRC.YYYYMMDD
               /* -- NULL 또는 빈문자열 AND TGT.CELL_ITEM_ID			= SRC.CELL_ITEM_ID -- NULL (대상이 아닌 Pack Site 셀을 제외하고 모두 NULL임) */
               /* -- NULL 또는 빈문자열 AND TGT.TO_SITE				= SRC.TO_SITE */
               /* -- NULL 또는 빈문자열 AND TGT.INCOTERMS			= SRC.INCOTERMS */
               /* -- NULL 또는 빈문자열 AND TGT.BOD_ID				= SRC.BOD_ID */
               /* -- NULL 또는 빈문자열 AND TGT.TRANSPORT_MODE_LINE	= SRC.TRANSPORT_MODE_LINE */
              )
         WHEN MATCHED THEN
       UPDATE
          SET TGT.QTY          = TGT.QTY          + SRC.QTY
            , TGT.FROM_BOH_QTY = TGT.FROM_BOH_QTY + SRC.FROM_BOH_QTY
            , TGT.TO_BOH_QTY   = TGT.TO_BOH_QTY   + SRC.TO_BOH_QTY
            , TGT.ATTRIBUTE3   = (CASE WHEN TGT.QTY IS NULL OR SRC.QTY IS NULL THEN NULL
                                       ELSE 'UPDATE :: ' || TO_CHAR(TGT.QTY, 'FM9999999999999999999999999990.0000000000')
                                         || ' :: '       || TO_CHAR(SRC.QTY, 'FM9999999999999999999999999990.0000000000')
                                  END)
         WHEN NOT MATCHED THEN
       INSERT
             ( PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , DIVISION_ID
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
       VALUES
             ( SRC.PLAN_START_YYYYMMDD
             , SRC.PLAN_TYPE
             , SRC.SEQ
             , SRC.DIVISION_ID
             , SRC.OPERATION_GROUP
             , SRC.ITEM_ID
             , SRC.CELL_ITEM_ID
             , SRC.TO_SITE
             , SRC.INCOTERMS
             , SRC.FROM_SITE
             , SRC.BOD_ID
             , SRC.TRANSPORT_MODE_LINE
             , SRC.MEASURE
             , SRC.YYYYMMDD
             , SRC.QTY
             , SRC.FROM_BOH_QTY
             , SRC.TO_BOH_QTY
             , SRC.ATTRIBUTE1
             , SRC.ATTRIBUTE2
             , 'INSERT'  /* --- SRC.ATTRIBUTE3 */
             , SRC.ATTRIBUTE9
             , SRC.ATTRIBUTE10
             );

        /* --------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || 'END Cell Product EOH(Model Inventory)를 Cell Assy로 합산 적용');
        /* --------------------------------------------------------------------------------------------------------------------- */
        /* END 2023.07.28 활성화코드 분리 대응 -- Cell Product EOH(Model Inventory)를 Cell Assy로 합산 적용 */
        /* --------------------------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 4. SEMI 추가 로직 : WH_IN */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 원문 LEFT OUTER JOIN + WHERE B.DIVISION_ID is not null 그대로 (+) 로 옮김 */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , MAX(X.OPERATION_GROUP)
             , X.ITEM_ID
             , NULL                         AS CELL_ITEM_ID
             , X.TO_SITE
             , NULL                         AS TO_BOH_QTY
             , '-'                          AS INCOTERMS
             , X.FROM_SITE
             , NULL                         AS FROM_BOH_QTY
             , '-'                          AS BOD_ID
             , X.TRANSPORT_MODE_LINE  /* -- NULL 후 UPDATE ? */
             , X.MEASURE
             , X.YYYYMMDD
             , SUM(X.QTY)
             , 'WH_IN'
          FROM (
                SELECT B.DIVISION_ID
                     , B.PLAN_START_YYYYMMDD  /* -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0) */
                     , B.PLAN_TYPE
                     , B.SEQ
                     , B.OPERATION_GROUP
                     , B.ITEM_ID
                     , NULL                             AS CELL_ITEM_ID
                     , B.TO_SITE
                     , B.INCOTERMS
                     , B.FROM_SITE
                     , B.BOD_ID
                     , NULL                             AS TRANSPORT_MODE_LINE  /* -- NULL 후 UPDATE ? */
                     , 'WH_IN'                          AS MEASURE
                     , TO_CHAR(B.END_TIME, 'YYYYMMDD')  AS YYYYMMDD
                     , A.ALLOCATION_QTY                 AS QTY
                  FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A
                     , SCP_PLN_SHIPMENT_PLAN         B
                 WHERE A.DIVISION_ID         = B.DIVISION_ID(+)
                   AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD(+)
                   AND A.PLAN_TYPE           = B.PLAN_TYPE(+)
                   AND A.SEQ                 = B.SEQ(+)
                   AND A.ORDER_ID            = B.ORDER_ID(+)
                   /* --   AND A.ENG_DEMAND_ID         = B.ENG_DEMAND_ID */
                   AND B.MEASURE(+)          = 'SHIP_PLAN'
                   AND B.SEMI_YN(+)          = 'Y'
                   AND B.INCOTERMS(+)       <> '-'  /* -- 임시처리 */
                   AND B.DIVISION_ID IS NOT NULL
                   AND B.INCOTERMS          <> '-'  /* -- 임시처리 */
                   AND A.INCOTERMS          <> '-'  /* -- 임시처리 */
                   AND A.DIVISION_ID         = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = P_PLAN_TYPE
                   AND A.SEQ                 = N_SEQ
               ) X
         GROUP BY X.DIVISION_ID
                , X.PLAN_START_YYYYMMDD
                , X.PLAN_TYPE
                , X.SEQ
                , X.ITEM_ID
                , X.TO_SITE
                , X.INCOTERMS
                , X.FROM_SITE
                , X.TRANSPORT_MODE_LINE
                , X.MEASURE
                , X.YYYYMMDD;
                  /* --                      ,NULL --TRANSPORT_MODE_LINE            -- NULL 후 UPDATE ? */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* WH_IN Cell 품목의 DIO 계산 개선을 위해서 Cell 하위 반제품 갱신 수행 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* UPDATE PG SET PG.ITEM_ID = TG.CHILD_ITEM_ID FROM .. INNER JOIN SCM_MST_SITE FS INNER JOIN #TMP_TARGET_TO_CONVERT TG */
        /* 조인 열쇠(ITEM_ID)를 바꾸는 갱신이라 MERGE 대신 상관 UPDATE (TG 는 PLANT_ID·PARENT_ITEM_ID 로 묶여 대응 행 하나) */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL PG
           SET PG.ITEM_ID = (SELECT TG.CHILD_ITEM_ID
                               FROM SCM_MST_SITE              FS  /* -- 7월은 국내만 적용 */
                                  , GT_APGS_TARGET_TO_CONVERT TG
                              WHERE FS.DIVISION_ID      = PG.DIVISION_ID
                                AND FS.SCM_SITE_ID      = PG.FROM_SITE
                                AND TG.PLANT_ID         = FS.PLANT_ID
                                AND TG.PARENT_ITEM_ID   = PG.ITEM_ID
                                AND FS.SITE_TYPE        = 'PLANT'
                                AND FS.OPERATION_GROUP  = 'A'  /* -- Cell 창고 (Pack창고 Cell은 대상 아님) */
                                AND FS.OSP_YN           = 'N'  /* -- OSP제외 */
                                AND ROWNUM              = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_SITE              FT
                            , GT_APGS_TARGET_TO_CONVERT TH
                        WHERE FT.DIVISION_ID      = PG.DIVISION_ID
                          AND FT.SCM_SITE_ID      = PG.FROM_SITE
                          AND TH.PLANT_ID         = FT.PLANT_ID
                          AND TH.PARENT_ITEM_ID   = PG.ITEM_ID
                          AND FT.SITE_TYPE        = 'PLANT'
                          AND FT.OPERATION_GROUP  = 'A'
                          AND FT.OSP_YN           = 'N')
           AND PG.ATTRIBUTE1     <> 'CELL'
           AND PG.ATTRIBUTE1     <> 'CELL_WH'
           AND PG.FROM_SITE      <> '-'
           AND PG.MEASURE         = 'WH_IN'
           AND PG.OPERATION_GROUP = 'A'
           AND PG.ATTRIBUTE1     IN ('SCP_ANL_SHIPMENT_PLAN_FG', 'WH_IN');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.09.03   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 */
        /*                          활성화 후 공정 Cell 수요 정보 추가 시작 */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , IA.CHILD_ITEM_ID             AS ITEM_ID
             , NULL                         AS CELL_ITEM_ID
             , A.FROM_SITE                  AS TO_SITE
             , NULL                         AS TO_BOH_QTY
             , '-'                          AS INCOTERMS
             , A.FROM_SITE
             , NULL                         AS FROM_BOH_QTY
             , '-'                          AS BOD_ID
             , '-'                          AS TRANSPORT_MODE_LINE
             , 'WH_IN'                      AS MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)                   AS QTY
             , 'WH_IN'                      AS ATTRIBUTE1
          FROM SCP_ANL_PSI_PRODUCTION A
             , (SELECT SA.PARENT_ITEM_ID
                     , MAX(SA.CHILD_ITEM_ID) AS CHILD_ITEM_ID
                  FROM GT_APGS_CELL_BOM_40 SA
                 WHERE SA.CELL_TYPE_P = 'CA2'
                   AND SA.CELL_TYPE_C = 'CA1'
                 GROUP BY SA.PARENT_ITEM_ID) IA
             , SCM_MST_SITE FS
         WHERE A.ITEM_ID             = IA.PARENT_ITEM_ID
           AND FS.DIVISION_ID        = A.DIVISION_ID
           AND FS.SCM_SITE_ID        = A.FROM_SITE
           AND FS.SITE_TYPE          = 'PLANT'
           AND FS.OPERATION_GROUP    = 'A'  /* -- Cell 창고 (Pack창고 Cell은 대상 아님) */
           AND FS.OSP_YN             = 'N'  /* -- OSP제외 */
           AND A.PSI_TYPE            = 'P'
           AND A.PSI_VALUE          <> 'DIO'
           AND A.PSI_VALUE          <> 'ISSUM'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
         GROUP BY A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.OPERATION_GROUP
                , IA.CHILD_ITEM_ID
                , A.FROM_SITE
                , A.YYYYMMDD;
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.09.03   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 */
        /*                          활성화 후 공정 Cell 수요 정보 추가 끝 */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 5. MKT_FCST 0 채워 넣기 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* CREATE CLUSTERED INDEX IX01_#tmp_SCP_ANL_PSI_GLOBAL_SMALL ON #tmp_SCP_ANL_PSI_GLOBAL_SMALL ( ATTRIBUTE1 ) */
        /*   --  DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, TO_SITE, ----INCOTERMS, FROM_SITE, BOD_ID, */
        /*   ----MEASURE, YYYYMMDD, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, TRANSPORT_MODE_LINE, */

        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL  /* CHECK1 */
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
               /* --,TO_BOH_QTY */
             , INCOTERMS
             , FROM_SITE
               /* --,FROM_BOH_QTY */
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
               /* --,CELL_ITEM_ID */
             , ATTRIBUTE1
             )
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.ITEM_ID
             , SUB.CELL_ITEM_ID
             , SUB.TO_SITE
               /* --                        ,TO_BOH_QTY */
             , '-'                          AS INCOTERMS
             , SUB.FROM_SITE
               /* --                        ,FROM_BOH_QTY */
             , '-'                          AS BOD_ID
             , SUB.TRANSPORT_MODE_LINE
             , 'MKT_FCST'                   AS MEASURE
             , SUB.YYYYMMDD
             , 0                            AS QTY
             , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
          FROM (
                SELECT B.DIVISION_ID
                     , B.PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.SEQ
                     , B.OPERATION_GROUP
                     , B.ITEM_ID
                     , B.CELL_ITEM_ID
                     , B.FROM_SITE
                     , B.TO_SITE
                       /* --                                  ,BOD_ID */
                       /* --                          ,MEASURE */
                     , A.YYYYMMDD
                     , NULL                 AS TRANSPORT_MODE_LINE
                  FROM GT_APGS_YYYYMMDD A
                     , (
                        SELECT DISTINCT
                               X.DIVISION_ID
                             , X.PLAN_START_YYYYMMDD
                             , X.PLAN_TYPE
                             , X.SEQ
                             , X.OPERATION_GROUP
                             , X.ITEM_ID
                             , X.CELL_ITEM_ID
                             , X.FROM_SITE
                             , X.TO_SITE
                               /* --                                           ,BOD_ID */
                               /* --                                   ,MEASURE */
                             , NULL         AS TRANSPORT_MODE_LINE
                          FROM GT_APGS_PSI_GLOBAL_SMALL X
                         WHERE X.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                       ) B
               ) SUB
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_APGS_PSI_GLOBAL_SMALL Z
                            WHERE Z.DIVISION_ID         = SUB.DIVISION_ID
                              AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                              AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                              AND Z.SEQ                 = SUB.SEQ
                              AND Z.OPERATION_GROUP     = SUB.OPERATION_GROUP
                              AND Z.ITEM_ID             = SUB.ITEM_ID
                              AND Z.CELL_ITEM_ID        = SUB.CELL_ITEM_ID
                              AND Z.TO_SITE             = SUB.TO_SITE
                              AND Z.FROM_SITE           = SUB.FROM_SITE
                              /* --                                              AND Z.BOD_ID                   = SUB.BOD_ID */
                              /* --                                      AND Z.MEASURE                  = SUB.MEASURE */
                              AND Z.YYYYMMDD            = SUB.YYYYMMDD);
                              /* --AND Z.TRANSPORT_MODE_LINE           = SUB.TRANSPORT_MODE_LINE */

        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL  /* CHECK2 */
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
               /* --,TO_BOH_QTY */
             , INCOTERMS
             , FROM_SITE
               /* --,FROM_BOH_QTY */
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.ITEM_ID
             , SUB.CELL_ITEM_ID
             , SUB.TO_SITE
               /* --                        ,TO_BOH_QTY */
             , '-'                          AS INCOTERMS
             , SUB.FROM_SITE
               /* --                        ,FROM_BOH_QTY */
             , '-'                          AS BOD_ID
             , SUB.TRANSPORT_MODE_LINE
             , 'WH_IN'                      AS MEASURE
             , SUB.YYYYMMDD
             , 0                            AS QTY
             , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
          FROM (
                SELECT B.DIVISION_ID
                     , B.PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.SEQ
                     , B.OPERATION_GROUP
                     , B.ITEM_ID
                     , B.CELL_ITEM_ID
                     , B.FROM_SITE
                     , B.TO_SITE
                       /* --                                  ,BOD_ID */
                     , 'WH_IN'              AS MEASURE
                     , A.YYYYMMDD
                     , NULL                 AS TRANSPORT_MODE_LINE
                  FROM GT_APGS_YYYYMMDD A
                     , (
                        SELECT DISTINCT
                               X.DIVISION_ID
                             , X.PLAN_START_YYYYMMDD
                             , X.PLAN_TYPE
                             , X.SEQ
                             , X.OPERATION_GROUP
                             , X.ITEM_ID
                             , X.CELL_ITEM_ID
                             , X.FROM_SITE
                             , X.TO_SITE
                               /* --                                           ,BOD_ID */
                             , X.MEASURE
                             , NULL         AS TRANSPORT_MODE_LINE
                          FROM GT_APGS_PSI_GLOBAL_SMALL X
                         WHERE X.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                           AND X.MEASURE    = 'WH_IN'
                       ) B
               ) SUB
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_APGS_PSI_GLOBAL_SMALL Z
                            WHERE Z.DIVISION_ID         = SUB.DIVISION_ID
                              AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                              AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                              AND Z.SEQ                 = SUB.SEQ
                              AND Z.OPERATION_GROUP     = SUB.OPERATION_GROUP
                              AND Z.ITEM_ID             = SUB.ITEM_ID
                              AND Z.CELL_ITEM_ID        = SUB.CELL_ITEM_ID
                              AND Z.TO_SITE             = SUB.TO_SITE
                              AND Z.FROM_SITE           = SUB.FROM_SITE
                              /* --                                              AND Z.BOD_ID                   = SUB.BOD_ID */
                              AND Z.MEASURE             = SUB.MEASURE
                              AND Z.YYYYMMDD            = SUB.YYYYMMDD);
                              /* --AND Z.TRANSPORT_MODE_LINE   = SUB.TRANSPORT_MODE_LINE */

        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL  /* CHECK2 */
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
               /* --,TO_BOH_QTY */
             , INCOTERMS
             , FROM_SITE
               /* --,FROM_BOH_QTY */
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.ITEM_ID
             , SUB.CELL_ITEM_ID
             , SUB.TO_SITE
               /* --                        ,TO_BOH_QTY */
             , '-'                          AS INCOTERMS
             , SUB.FROM_SITE
               /* --                        ,FROM_BOH_QTY */
             , '-'                          AS BOD_ID
             , SUB.TRANSPORT_MODE_LINE
             , 'WH_IN'                      AS MEASURE
             , SUB.YYYYMMDD
             , 0                            AS QTY
             , 'WH_IN'                      AS ATTRIBUTE1
          FROM (
                SELECT B.DIVISION_ID
                     , B.PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.SEQ
                     , B.OPERATION_GROUP
                     , B.ITEM_ID
                     , B.CELL_ITEM_ID
                     , B.FROM_SITE
                     , B.TO_SITE
                       /* --                                  ,BOD_ID */
                     , 'WH_IN'              AS MEASURE
                     , A.YYYYMMDD
                     , NULL                 AS TRANSPORT_MODE_LINE
                  FROM GT_APGS_YYYYMMDD A
                     , (
                        SELECT DISTINCT
                               X.DIVISION_ID
                             , X.PLAN_START_YYYYMMDD
                             , X.PLAN_TYPE
                             , X.SEQ
                             , X.OPERATION_GROUP
                             , X.ITEM_ID
                             , X.CELL_ITEM_ID
                             , X.FROM_SITE
                             , X.TO_SITE
                               /* --                                           ,BOD_ID */
                             , X.MEASURE
                             , NULL         AS TRANSPORT_MODE_LINE
                          FROM GT_APGS_PSI_GLOBAL_SMALL X
                         WHERE X.ATTRIBUTE1 = 'WH_IN'
                           AND X.MEASURE    = 'WH_IN'
                       ) B
               ) SUB
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_APGS_PSI_GLOBAL_SMALL Z
                            WHERE Z.DIVISION_ID         = SUB.DIVISION_ID
                              AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                              AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                              AND Z.SEQ                 = SUB.SEQ
                              AND Z.OPERATION_GROUP     = SUB.OPERATION_GROUP
                              AND Z.ITEM_ID             = SUB.ITEM_ID
                              AND Z.CELL_ITEM_ID        = SUB.CELL_ITEM_ID
                              AND Z.TO_SITE             = SUB.TO_SITE
                              AND Z.FROM_SITE           = SUB.FROM_SITE
                              /* --                                              AND Z.BOD_ID                   = SUB.BOD_ID */
                              AND Z.MEASURE             = SUB.MEASURE
                              AND Z.YYYYMMDD            = SUB.YYYYMMDD);
                              /* --AND Z.TRANSPORT_MODE_LINE           = SUB.TRANSPORT_MODE_LINE */

        /* --2021.11.11 튜닝개선안에 따른 인덱스 삭제 */
        /* drop INDEX IX01_#tmp_SCP_ANL_PSI_GLOBAL_SMALL ON #tmp_SCP_ANL_PSI_GLOBAL_SMALL */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 6. UPDATE   ( BOH, TRANSPORT MODE)  SEMI (TO_SITE TRANS_MODE / FROM_SITE BOH), FG (FROM_SITE TRANS_MODE /  TO_SITE BOH) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 6.1 -- SCP_PLN_SALES_ONHAND BOH 임시테이블 추출 */
        /* ------------------------------------------------------------------------------------------------------------- */

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '#BOH - Start ');

        DELETE FROM GT_APGS_BOH;

        INSERT
          INTO GT_APGS_BOH
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , SITE_ID
             , ITEM_ID
             , PSI_BOH_QTY
             )
        SELECT X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , X.SITE_ID
             , X.ITEM_ID
             , X.PSI_BOH_QTY
          FROM (
                SELECT A.DIVISION_ID
                     , A.PLAN_START_YYYYMMDD
                     , A.PLAN_TYPE
                     , A.SEQ
                     , A.SITE_ID
                     , A.ITEM_ID
                     , A.PSI_BOH_QTY
                  FROM SCP_PLN_SALES_ONHAND_V A
                 WHERE A.DIVISION_ID         = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = P_PLAN_TYPE
                   AND A.SEQ                 = N_SEQ
                   AND A.YYYYMMDD            = V_PLAN_START_YYYYMMDD
                /* ------------------------------------------------------------------------------------------------------------- */
                /* 6.2 -- SCP_PLN_PLANT_ONHAND BOH 임시테이블 추출 */
                /* ------------------------------------------------------------------------------------------------------------- */
                 UNION
                /* ------------------------------------------------------------------------------------------------------------- */
                /* 2023.07.28 활성화 코드 대응 : Cell창고 Cell Product 재고를 Cell Assy 재고로 치환 */
                /* ------------------------------------------------------------------------------------------------------------- */
                SELECT PO.DIVISION_ID
                     , PO.PLAN_START_YYYYMMDD
                     , PO.PLAN_TYPE
                     , PO.SEQ
                     , PO.SITE_ID
                     , CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT'  /* -- CELL 창고 */
                                 AND FS.OSP_YN = 'N'                                  /* -- 외주 제외 */
                                 AND CA.CHILD_ITEM_ID IS NOT NULL                     /* -- 대상 정보 존재 */
                            THEN CA.CHILD_ITEM_ID                                     /* -- 대상인 경우 Cell Product를 Cell Assy 정보로 치환 */
                            ELSE PO.ITEM_ID
                       END                          AS ITEM_ID
                     , NVL(SUM(PO.PSI_BOH_QTY), 0)  AS PSI_BOH_QTY
                  FROM SCP_PLN_PLANT_ONHAND      PO
                     , SCM_MST_SITE              FS
                     , GT_APGS_TARGET_TO_CONVERT CA
                 WHERE FS.DIVISION_ID          = PO.DIVISION_ID
                   AND FS.SCM_SITE_ID          = PO.SITE_ID
                   AND FS.PLANT_ID             = CA.PLANT_ID(+)
                   AND PO.ITEM_ID              = CA.PARENT_ITEM_ID(+)
                   AND PO.YYYYMMDD             = PO.PLAN_START_YYYYMMDD
                   AND PO.STOCK_TYPE      NOT IN ('ASSM', 'FOR_STOCKPLAN', 'FORMING', 'FORMED', 'CHARING')  /* --셀 특성완료이전 제외 */
                   AND PO.DIVISION_ID          = V_DIVISION_ID
                   AND PO.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                   AND PO.PLAN_TYPE            = P_PLAN_TYPE
                   AND PO.SEQ                  = N_SEQ
                 GROUP BY PO.DIVISION_ID
                        , PO.PLAN_START_YYYYMMDD
                        , PO.PLAN_TYPE
                        , PO.SEQ
                        , PO.SITE_ID
                        , CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT'  /* -- CELL 창고 */
                                    AND FS.OSP_YN = 'N'                                  /* -- 외주 제외 */
                                    AND CA.CHILD_ITEM_ID IS NOT NULL                     /* -- 대상 정보 존재 */
                               THEN CA.CHILD_ITEM_ID                                     /* -- 대상인 경우 Cell Product를 Cell Assy 정보로 치환 */
                               ELSE PO.ITEM_ID
                          END
                /* 2023.07.28 변경전 소스
                    select DIVISION_ID
                         ,PLAN_START_YYYYMMDD
                         ,PLAN_TYPE
                         ,SEQ
                         ,SITE_ID
                         ,ITEM_ID
                         ,SUM(ISNULL(PSI_BOH_QTY,0)) as     PSI_BOH_QTY
                     FROM SCP_PLN_PLANT_ONHAND WITH(NOLOCK)
                    WHERE DIVISION_ID               = @P_DIVISION_ID
                      AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD
                      AND PLAN_TYPE                 = @P_PLAN_TYPE
                      AND SEQ                       = @P_SEQ
                      AND YYYYMMDD                  = @P_PLAN_START_YYYYMMDD
                      AND STOCK_TYPE                NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING')   --셀 특성완료이전 제외
                    GROUP by DIVISION_ID
                            ,PLAN_START_YYYYMMDD
                            ,PLAN_TYPE
                            ,SEQ
                            ,SITE_ID
                            ,ITEM_ID
                    2023.07.28 변경전 소스 */
               ) X;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '#BOH - End ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 6.3  FROM_BOH_QTY,TO_BOH_QTY 계산 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* UPDATE X SET X.FROM_BOH_QTY = ISNULL(BOH.PSI_BOH_QTY,0) FROM .. LEFT OUTER JOIN #BOH : 전 행 갱신, 대응 행 여럿이면 MSSQL 임의 한 행 → ROWNUM = 1 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL X
           SET X.FROM_BOH_QTY = NVL((SELECT BOH.PSI_BOH_QTY
                                       FROM GT_APGS_BOH BOH
                                      WHERE X.DIVISION_ID         = BOH.DIVISION_ID
                                        AND X.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD
                                        AND X.PLAN_TYPE           = BOH.PLAN_TYPE
                                        AND X.SEQ                 = BOH.SEQ
                                        AND X.FROM_SITE           = BOH.SITE_ID
                                        AND X.ITEM_ID             = BOH.ITEM_ID
                                        AND ROWNUM                = 1), 0);

        /*
            UPDATE X
               SET X.ATTRIBUTE2 = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
               LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK)
                ON 0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE
                AND X.SEQ                  = BOH.SEQ
                AND X.TO_SITE              = BOH.SITE_ID
                AND X.ITEM_ID              = BOH.ITEM_ID
                AND X.MEASURE              = 'MODEL_INVENTORY'
                AND X.OPERATION_GROUP      = 'A'
        */

        /*
            ACTIVATE_PROGRESS	  Formation Progress
            MODEL_INVENTORY	    Model Inventory
        */

        /* ATTRIBUTE2 : NUMERIC → NVARCHAR 변환은 소수 10자리 고정 문자('56746.0000000000') → TO_CHAR 형식 지정 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL X
           SET X.ATTRIBUTE2 = (SELECT TO_CHAR(NVL(BOH.PSI_BOH_QTY, 0), 'FM9999999999999999999999999990.0000000000')
                                 FROM GT_APGS_BOH BOH
                                WHERE X.DIVISION_ID         = BOH.DIVISION_ID
                                  AND X.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD
                                  AND X.PLAN_TYPE           = BOH.PLAN_TYPE
                                  AND X.SEQ                 = BOH.SEQ
                                  AND X.FROM_SITE           = BOH.SITE_ID
                                  AND X.ITEM_ID             = BOH.ITEM_ID
                                  AND ROWNUM                = 1)
         WHERE EXISTS (SELECT 1
                         FROM GT_APGS_BOH B2
                        WHERE X.DIVISION_ID         = B2.DIVISION_ID
                          AND X.PLAN_START_YYYYMMDD = B2.PLAN_START_YYYYMMDD
                          AND X.PLAN_TYPE           = B2.PLAN_TYPE
                          AND X.SEQ                 = B2.SEQ
                          AND X.FROM_SITE           = B2.SITE_ID
                          AND X.ITEM_ID             = B2.ITEM_ID)
           AND X.MEASURE = 'MODEL_INVENTORY';

        /*

          UPDATE X
               SET X.ATTRIBUTE2 = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
               LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK)
                ON 0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE
                AND X.SEQ                  = BOH.SEQ
                AND X.FROM_SITE            = BOH.SITE_ID
                AND X.ITEM_ID              = BOH.ITEM_ID
                AND X.MEASURE              = 'MODEL_INVENTORY'
--                AND X.OPERATION_GROUP      = 'P'
        */
        /* BOH 인라인 뷰는 DIVISION_ID·PLAN_START_YYYYMMDD·PLAN_TYPE·SEQ·SITE_ID·ITEM_ID 로 묶여 대응 행 하나 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL X
           SET X.ATTRIBUTE2 = (SELECT TO_CHAR(NVL(SUM(NVL(BOH.PSI_BOH_QTY, 0)), 0), 'FM9999999999999999999999999990.0000000000')
                                 FROM SCP_PLN_PLANT_ONHAND BOH
                                WHERE BOH.DIVISION_ID         = X.DIVISION_ID
                                  AND BOH.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
                                  AND BOH.PLAN_TYPE           = X.PLAN_TYPE
                                  AND BOH.SEQ                 = X.SEQ
                                  AND BOH.SITE_ID             = X.FROM_SITE
                                  AND BOH.ITEM_ID             = X.ITEM_ID
                                  AND BOH.STOCK_TYPE          = 'FOR_STOCKPLAN'
                                  AND BOH.DIVISION_ID         = V_DIVISION_ID
                                  AND BOH.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                  AND BOH.PLAN_TYPE           = P_PLAN_TYPE
                                  AND BOH.SEQ                 = N_SEQ
                                  AND BOH.YYYYMMDD            = V_PLAN_START_YYYYMMDD)
         WHERE EXISTS (SELECT 1
                         FROM SCP_PLN_PLANT_ONHAND B2
                        WHERE B2.DIVISION_ID         = X.DIVISION_ID
                          AND B2.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
                          AND B2.PLAN_TYPE           = X.PLAN_TYPE
                          AND B2.SEQ                 = X.SEQ
                          AND B2.SITE_ID             = X.FROM_SITE
                          AND B2.ITEM_ID             = X.ITEM_ID
                          AND B2.STOCK_TYPE          = 'FOR_STOCKPLAN'
                          AND B2.DIVISION_ID         = V_DIVISION_ID
                          AND B2.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                          AND B2.PLAN_TYPE           = P_PLAN_TYPE
                          AND B2.SEQ                 = N_SEQ
                          AND B2.YYYYMMDD            = V_PLAN_START_YYYYMMDD)
           AND X.MEASURE         = 'ACTIVATE_PROGRESS'
           AND X.OPERATION_GROUP = 'A';

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 6.4  CELL_ITEM_ID UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* PACK 일경우 */
        /*
                UPDATE X
                   SET X.CELL_ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                                AND Y.MODEL_ID           = X.ITEM_ID
                                                AND Y.OPERATION_GROUP_ID = 'A')
                 FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
                 WHERE OPERATION_GROUP   = 'P'
                 ;

                -- CELL 일경우
              UPDATE X
                SET X.CELL_ITEM_ID      = X.ITEM_ID
                FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
                WHERE 0 = 0
                  AND X.OPERATION_GROUP   = 'A'
                ;
        */

        /* UPDATE X SET X.CELL_ITEM_ID = Y.CELL_LIST FROM .. JOIN SCP_MST_FINAL_ITEM_V Y : 대응 행 여럿이면 MSSQL 임의 한 행 → ROWNUM = 1 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL X
           SET X.CELL_ITEM_ID = (SELECT Y.CELL_LIST
                                   FROM SCP_MST_FINAL_ITEM_V Y
                                  WHERE X.ITEM_ID         = Y.ITEM_ID
                                    AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                                    AND Y.CELL_LIST IS NOT NULL
                                    AND ROWNUM            = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCP_MST_FINAL_ITEM_V Y2
                        WHERE X.ITEM_ID         = Y2.ITEM_ID
                          AND X.OPERATION_GROUP = Y2.OPERATION_GROUP
                          AND Y2.CELL_LIST IS NOT NULL);

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* CA1 품목은 바로 상위 품목으로 변경 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.09.03   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : */
        /*                          활성화 후 공정 Cell이 존재하는 경우  Cell 정보를  활성화 후 공정 Cell로 설정 */
        /*                          Cell 제품으로 추가 갱신 막음
                UPDATE X
                   SET X.CELL_ITEM_ID   = Y.PARENT_ITEM_ID
                 FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
                      INNER JOIN #TMP_CELL_BOM_40 Y WITH (NOLOCK)
                      ON  0 = 0
                      AND X.ITEM_ID     = Y.CHILD_ITEM_ID
					  AND TCO_CELL_YN_P = 'N'
					  AND CELL_TYPE_P   = 'CP'
					  AND TCO_CELL_YN_C = 'N'
					  AND CELL_TYPE_C   = 'CA1';

                -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 7. 'MKT_FCST'로 / RTF(ALLOCATION) / Balance 0 채워 넣기 */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL  /* CHECK3 */
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , MEASURE
             , YYYYMMDD
             , QTY
             , TRANSPORT_MODE_LINE
             , ATTRIBUTE1
             )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.ITEM_ID
             , A.CELL_ITEM_ID
             , A.TO_SITE
             , A.TO_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.FROM_BOH_QTY
             , A.BOD_ID
             , 'ALLOCATION'                 AS MEASURE
             , A.YYYYMMDD
             , 0                            AS QTY
             , A.TRANSPORT_MODE_LINE
             , '0'                          AS ATTRIBUTE1
          FROM GT_APGS_PSI_GLOBAL_SMALL A
         WHERE A.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND A.MEASURE    = 'MKT_FCST'
           AND A.TO_SITE   <> '-'  /* -- 생산제외 */
         UNION ALL
        SELECT B.DIVISION_ID
             , B.PLAN_START_YYYYMMDD
             , B.PLAN_TYPE
             , B.SEQ
             , B.OPERATION_GROUP
             , B.ITEM_ID
             , B.CELL_ITEM_ID
             , B.TO_SITE
             , B.TO_BOH_QTY
             , B.INCOTERMS
             , B.FROM_SITE
             , B.FROM_BOH_QTY
             , B.BOD_ID
             , 'BALANCE'                    AS MEASURE
             , B.YYYYMMDD
             , 0                            AS QTY
             , B.TRANSPORT_MODE_LINE
             , '0'                          AS ATTRIBUTE1
          FROM GT_APGS_PSI_GLOBAL_SMALL B
         WHERE B.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND B.MEASURE    = 'MKT_FCST'
           AND B.TO_SITE   <> '-'  /* -- 생산제외 */
         UNION ALL
        SELECT C.DIVISION_ID
             , C.PLAN_START_YYYYMMDD
             , C.PLAN_TYPE
             , C.SEQ
             , C.OPERATION_GROUP
             , C.ITEM_ID
             , C.CELL_ITEM_ID
             , C.TO_SITE
             , C.TO_BOH_QTY
             , C.INCOTERMS
             , C.FROM_SITE
             , C.FROM_BOH_QTY
             , C.BOD_ID
             , 'WH_IN_BALANCE'              AS MEASURE
             , C.YYYYMMDD
             , 0                            AS QTY
             , C.TRANSPORT_MODE_LINE
             , '0'                          AS ATTRIBUTE1
          FROM GT_APGS_PSI_GLOBAL_SMALL C
         WHERE C.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND C.MEASURE    = 'MKT_FCST'
           AND C.TO_SITE   <> '-';  /* -- 생산제외 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 8. TRANSPORT_MODE_LINE UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* TRANSPORT_MODE */
        /* PJ20209643 (20210716) : scp_mst_bod_v에서 scp_mst_bod_n_v로 변경 */
        /* UPDATE X .. INNER JOIN scp_mst_bod_n_v Y : 경로(ROUTE)별 행 여럿이면 MSSQL 임의 한 행 → ROWNUM = 1 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL X
           SET X.TRANSPORT_MODE_LINE = (SELECT Y.TRANSPORT_MODE
                                          FROM SCP_MST_BOD_N_V Y
                                         WHERE X.DIVISION_ID = Y.DIVISION_ID
                                           AND X.BOD_ID      = Y.BOD_ID
                                           AND X.FROM_SITE   = Y.FROM_SITE
                                           AND ROWNUM        = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCP_MST_BOD_N_V Y2
                        WHERE X.DIVISION_ID = Y2.DIVISION_ID
                          AND X.BOD_ID      = Y2.BOD_ID
                          AND X.FROM_SITE   = Y2.FROM_SITE)
           AND X.MEASURE <> 'PRODUCTION'
           AND X.BOD_ID  <> '-';

        DELETE
          FROM GT_APGS_PSI_GLOBAL_SMALL
         WHERE MEASURE IN ('MKT_FCST', 'ALLOCATION', 'BALANCE')
           AND TO_SITE  = '-';  /* -- 생산제외 */

        /* --             SELECT * FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WITH (NOLOCK) WHERE ITEM_ID ='MCP275292A10' AND MEASURE ='WH_IN' */
        /* --                return */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* 'WH_IN','ACTIVATE_PROGRESS','MODEL_INVENTORY','INCP_MODEL_INVENTORY','OWMS_MODEL_INVENTORY', PRODUCTION, CHAR_AVAILABLE 합산 시작. 일단 제외 ACTIVATE_COMPLETED */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* ITEM_ID(50자) ← CLASS_NAME(150자) : ANSI_WARNINGS OFF 잘림 재현 SUBSTR */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , SUBSTR(IC.CLASS_NAME, 1, 50) AS ITEM_ID
             , IC.CLASS_NAME                AS CELL_ITEM_ID
             , NULL                         AS TO_SITE  /* '' */
             , SUM(A.TO_BOH_QTY)            AS TO_BOH_QTY
             , NULL                         AS INCOTERMS
             , A.FROM_SITE
             , SUM(A.FROM_BOH_QTY)          AS FROM_BOH_QTY
             , '-'                          AS BOD_ID
             , NULL                         AS TRANSPORT_MODE_LINE
             , A.MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)                   AS QTY
             , MAX(A.ATTRIBUTE1)            AS ATTRIBUTE1
             , MAX(A.ATTRIBUTE3)            AS ATTRIBUTE3
             , IC.CLASS_NAME                AS ATTRIBUTE4
             , MAX(A.ATTRIBUTE9)            AS ATTRIBUTE9
             , '4'                          AS ATTRIBUTE10
          FROM GT_APGS_PSI_GLOBAL_SMALL A
             , SCM_MST_SITE             FS  /* -- 7월은 국내만 적용 */
             , SCP_MST_FINAL_ITEM       FI
             , SCM_MST_ITEM_CLASS_SN    IC
         WHERE FS.DIVISION_ID         = A.DIVISION_ID
           AND FS.SCM_SITE_ID         = A.FROM_SITE
           AND FI.DIVISION_ID         = A.DIVISION_ID
           AND FI.ITEM_ID             = A.CELL_ITEM_ID
           AND FI.ITEM_CLASS          = IC.CLASS_ID
           AND FS.SITE_TYPE           = 'PLANT'
           AND FS.OPERATION_GROUP     = 'A'  /* -- Cell 창고 (Pack창고 Cell은 대상 아님) */
           AND FS.OSP_YN              = 'N'  /* -- OSP제외 */
           AND A.OPERATION_GROUP      = 'A'
           AND A.MEASURE             IN ('ACTIVATE_PROGRESS', 'CHAR_AVAILABLE', 'INCP_MODEL_INVENTORY', 'MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY', 'PRODUCTION', 'WH_IN')
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = P_PLAN_TYPE
           AND A.SEQ                  = N_SEQ
         GROUP BY A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.OPERATION_GROUP
                , IC.CLASS_NAME
                , A.FROM_SITE
                , A.MEASURE
                , A.YYYYMMDD;

        /* 초기 재고 갱신 */
        /* UPDATE A .. LEFT OUTER JOIN (#BOH·#TMP_CELL_BOM_40·SCP_MST_FINAL_ITEM·SCM_MST_ITEM_CLASS_SN 묶음) BOH : 대응 없으면 0 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL A
           SET A.FROM_BOH_QTY = NVL((SELECT SUM(BOH.PSI_BOH_QTY)
                                       FROM GT_APGS_BOH           BOH
                                          , GT_APGS_CELL_BOM_40   Y
                                          , SCP_MST_FINAL_ITEM    FI
                                          , SCM_MST_ITEM_CLASS_SN IC
                                      WHERE BOH.ITEM_ID            = Y.CHILD_ITEM_ID
                                        AND FI.DIVISION_ID         = BOH.DIVISION_ID
                                        AND FI.ITEM_ID             = Y.PARENT_ITEM_ID
                                        AND FI.ITEM_CLASS          = IC.CLASS_ID
                                        AND Y.CELL_TYPE_P          = 'CP'
                                        AND BOH.DIVISION_ID        = A.DIVISION_ID
                                        AND BOH.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                        AND BOH.PLAN_TYPE          = A.PLAN_TYPE
                                        AND BOH.SEQ                = A.SEQ
                                        AND BOH.SITE_ID            = A.FROM_SITE
                                        AND IC.CLASS_NAME          = A.ITEM_ID), 0)
         WHERE A.ITEM_ID             = A.CELL_ITEM_ID
           AND A.CELL_ITEM_ID        = A.ATTRIBUTE4
           AND A.OPERATION_GROUP     = 'A'
           AND A.MEASURE            IN ('ACTIVATE_PROGRESS', 'CHAR_AVAILABLE', 'INCP_MODEL_INVENTORY', 'MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY', 'PRODUCTION', 'WH_IN')
           AND A.ATTRIBUTE10         = '4'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* 'WH_IN','ACTIVATE_PROGRESS','MODEL_INVENTORY','INCP_MODEL_INVENTORY','OWMS_MODEL_INVENTORY', PRODUCTION 합산 종료. 일단 제외 ACTIVATE_COMPLETED */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 9. DIO 생성 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 9.1. DIO 임시 테이블 생성          GROUPING 확인, CELL_ITEM_ID */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_APGS_DIO;  /* IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO') IS NOT NULL DROP TABLE .. / CREATE TABLE .. */

        /* DIVISION_ID(10자) · CELL_ITEM_ID(50자) : ANSI_WARNINGS OFF 잘림 재현 SUBSTR */
        INSERT
          INTO GT_APGS_DIO
             ( DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , CELL_ITEM_ID
             , YYYYMMDD
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , OUT_QTY
             , FORMATION_QTY
             , EOH_QTY
             , INV_DAY
             )
        SELECT SUBSTR(P.DIVISION_ID, 1, 10)
             , P.FROM_SITE
             , P.ITEM_ID
             , SUBSTR(P.CELL_ITEM_ID, 1, 50)
             , P.YYYYMMDD
             , MAX(P.FROM_BOH_QTY)                                                                 AS FROM_BOH_QTY
             , MAX(P.TO_BOH_QTY)                                                                   AS TO_BOH_QTY
             , SUM((CASE P.MEASURE WHEN 'WH_IN'             THEN ROUND(P.QTY, 1) ELSE 0 END))      AS OUT_QTY
             , SUM((CASE P.MEASURE WHEN 'ACTIVATE_PROGRESS' THEN ROUND(P.QTY, 1) ELSE 0 END))      AS FORMATION_QTY
             , SUM((CASE P.MEASURE WHEN 'MODEL_INVENTORY'   THEN ROUND(P.QTY, 1) ELSE 0 END))      AS EOH_QTY
             , 0
          FROM GT_APGS_PSI_GLOBAL_SMALL P
         WHERE P.ATTRIBUTE1 <> 'CELL'
           AND P.ATTRIBUTE1 <> 'CELL_WH'  /* -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 / -- 'CELL_WH' 조건 추가 */
           AND P.FROM_SITE  <> '-'
         GROUP BY P.DIVISION_ID
                , P.FROM_SITE
                , P.ITEM_ID
                , P.CELL_ITEM_ID
                , P.YYYYMMDD;  /* --,FROM_BOH_QTY,TO_BOH_QTY */
        /* ORDER BY  DIVISION_ID, FROM_SITE,ITEM_ID,CELL_ITEM_ID,YYYYMMDD--,FROM_BOH_QTY,TO_BOH_QTY             ; (적재 순서와 무관하여 생략) */

        /* -- DIO 보정로직 추가 */
        /*
          DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO
--        SELECT X.FROM_SITE , X.ITEM_ID , X.CELL_ITEM_ID
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO X
                 JOIN (
                        SELECT FROM_SITE
                              ,ITEM_ID
                              ,CELL_ITEM_ID
                          FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO  WITH(NOLOCK)
                          WHERE 1=1
                          GROUP BY FROM_SITE,ITEM_ID,CELL_ITEM_ID--,YYYYMMDD
                          HAVING 0 = 0
                          AND FROM_SITE <> '-'
                          AND SUM(EOH_QTY)  = 0
                          AND SUM(FORMATION_QTY) = 0
                    ) Y
              ON 0 = 0
              AND X.FROM_SITE     = Y.FROM_SITE
              AND X.ITEM_ID       = Y.ITEM_ID
              AND X.CELL_ITEM_ID  = Y.CELL_ITEM_ID
        */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 9.2. DIO 누적합계와 전일누적합계를  생성         #Tbl_DIO */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 창 함수 정렬 : MSSQL 은 NULL 을 가장 작은 값으로 정렬 → CELL_ITEM_ID NULLS FIRST */
        DELETE FROM GT_APGS_TBL_DIO;

        INSERT
          INTO GT_APGS_TBL_DIO
             ( YYYYMMDD
             , FROM_SITE
             , ITEM_ID
             , CELL_ITEM_ID
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , OUT_QTY
             , FORMATION_QTY
             , EOH_QTY
             , OUT_QTY_SUM
             , LAG_OUT_QTY_SUM
             )
        SELECT AA.YYYYMMDD
             , AA.FROM_SITE
             , AA.ITEM_ID
             , AA.CELL_ITEM_ID
             , AA.FROM_BOH_QTY
             , AA.TO_BOH_QTY
             , AA.OUT_QTY
             , AA.FORMATION_QTY
             , AA.EOH_QTY
             , AA.OUT_QTY_SUM
             , LAG((CASE WHEN AA.OUT_QTY_SUM < 0 THEN 0 ELSE AA.OUT_QTY_SUM END), 1, 0) OVER (PARTITION BY AA.FROM_SITE, AA.ITEM_ID, AA.CELL_ITEM_ID ORDER BY AA.YYYYMMDD) AS LAG_OUT_QTY_SUM  /* -- 전일 누적합계 */
          FROM (
                SELECT SUB.FROM_SITE
                     , SUB.ITEM_ID
                     , SUB.CELL_ITEM_ID
                     , SUB.YYYYMMDD
                     , MAX(SUB.FROM_BOH_QTY)                                                   AS FROM_BOH_QTY
                     , MAX(SUB.TO_BOH_QTY)                                                     AS TO_BOH_QTY
                     , SUM((CASE WHEN SUB.OUT_QTY < 0       THEN 0 ELSE SUB.OUT_QTY       END)) AS OUT_QTY
                     , SUM((CASE WHEN SUB.FORMATION_QTY < 0 THEN 0 ELSE SUB.FORMATION_QTY END)) AS FORMATION_QTY
                     , SUM((CASE WHEN SUB.EOH_QTY < 0       THEN 0 ELSE SUB.EOH_QTY       END)) AS EOH_QTY
                     , ROUND(SUM((CASE WHEN SUB.OUT_QTY < 0 THEN 0 ELSE SUB.OUT_QTY END)) OVER (PARTITION BY SUB.FROM_SITE, SUB.ITEM_ID ORDER BY SUB.FROM_SITE, SUB.ITEM_ID, SUB.CELL_ITEM_ID NULLS FIRST, SUB.YYYYMMDD), 2) AS OUT_QTY_SUM  /* -- 누적합계 */
                  FROM (
                        /* -- FROM_SITE,ITEM_ID,YYYYMMDD 기준으로 중복이 존재 ? */
                        SELECT P.FROM_SITE
                             , P.ITEM_ID
                             , P.CELL_ITEM_ID
                             , P.YYYYMMDD
                             , MAX(P.FROM_BOH_QTY)  AS FROM_BOH_QTY
                             , MAX(P.TO_BOH_QTY)    AS TO_BOH_QTY
                             , SUM(P.OUT_QTY)       AS OUT_QTY
                             , SUM(P.FORMATION_QTY) AS FORMATION_QTY
                             , SUM(P.EOH_QTY)       AS EOH_QTY
                          FROM GT_APGS_DIO P
                         GROUP BY P.FROM_SITE
                                , P.ITEM_ID
                                , P.CELL_ITEM_ID
                                , P.YYYYMMDD
                       ) SUB
                 GROUP BY SUB.FROM_SITE
                        , SUB.ITEM_ID
                        , SUB.CELL_ITEM_ID
                        , SUB.YYYYMMDD
                        , SUB.OUT_QTY
                        , SUB.FORMATION_QTY
                        , SUB.EOH_QTY
               ) AA;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 9.3.구하고자 하는 재고일수의 일자를 기준으로 이후 일자의 OUT값의 누적값중 현재 재고값보다 최초로 큰값을 구함. */
        /*                                   A. (OUT_QTY_SUM + EOH_QTY) 값과 X.OUT_QTY_SUM 비교 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* SELECT TOP 1 YYYYMMDD (ORDER BY 없음) : 누적값이 일자순으로 줄지 않으므로 조건을 만족하는 첫 일자 = MIN(YYYYMMDD) */
        /* DATEDIFF(DD, a, b) → TO_DATE(b) - TO_DATE(a) */
        DELETE FROM GT_APGS_TBL_SMALL_DIO;

        INSERT
          INTO GT_APGS_TBL_SMALL_DIO
             ( DIVISION_ID
             , YYYYMMDD
             , FROM_SITE
             , ITEM_ID
             , CELL_ITEM_ID
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , OUT_QTY
             , EOH_QTY
             , OUT_QTY_SUM
             , INV_YYYYMMDD
             , DD
             )
        SELECT V_DIVISION_ID                AS DIVISION_ID
             , A.YYYYMMDD
             , A.FROM_SITE
             , A.ITEM_ID
             , A.CELL_ITEM_ID
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.OUT_QTY
             , A.EOH_QTY
             , A.OUT_QTY_SUM
               /* --                        ,(A.OUT_QTY_SUM  + A.EOH_QTY ) */
             , (SELECT MIN(X.YYYYMMDD)
                  FROM GT_APGS_TBL_DIO X
                 WHERE X.FROM_SITE    = A.FROM_SITE
                   AND X.ITEM_ID      = A.ITEM_ID
                   AND X.CELL_ITEM_ID = A.CELL_ITEM_ID
                   AND X.YYYYMMDD     > A.YYYYMMDD
                   AND (A.OUT_QTY_SUM + A.EOH_QTY + A.FORMATION_QTY) <= X.OUT_QTY_SUM) AS INV_YYYYMMDD
             , (CASE WHEN A.EOH_QTY = 0.0 AND A.FORMATION_QTY = 0.0 THEN 0.0
                     ELSE NVL((TO_DATE((SELECT MIN(Y.YYYYMMDD)
                                          FROM GT_APGS_TBL_DIO Y
                                         WHERE Y.FROM_SITE    = A.FROM_SITE
                                           AND Y.ITEM_ID      = A.ITEM_ID
                                           AND Y.CELL_ITEM_ID = A.CELL_ITEM_ID
                                           AND Y.YYYYMMDD     > A.YYYYMMDD
                                           AND (A.OUT_QTY_SUM + A.EOH_QTY + A.FORMATION_QTY) <= Y.OUT_QTY_SUM), 'YYYYMMDD')
                               - TO_DATE(A.YYYYMMDD, 'YYYYMMDD')), 999)
                END)                        AS DD
          FROM GT_APGS_TBL_DIO A;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 9.4. #tmp_SCP_ANL_PSI_PRODUCTION 입력 */
        /* 'I'   AS PSI_TYPE */
        /* 'DIO' AS PSI_VALUE */
        /* ROUND(DD-1) + (OUT_QTY/TOT_QTY),2) */
        /* SET @V_INV_DAY = ROUND( (@V_DAY-1) + (@C_EOH_QTY / @V_QTY) , 2)  -- QTY */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL  /* DIO */
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID  /* -- */
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , MEASURE
             , YYYYMMDD
             , QTY
             , TRANSPORT_MODE_LINE
             , ATTRIBUTE1
             )
        SELECT V_DIVISION_ID
             , V_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , N_SEQ
             , Y.OPERATION_GROUP
             , X.ITEM_ID
             , X.CELL_ITEM_ID               AS CELL_ITEM_ID  /* -- update */
             , '-'                          AS TO_SITE
             , 0                            AS TO_BOH_QTY    /* -- update */
             , '-'                          AS INCOTERMS
             , X.FROM_SITE
             , X.FROM_BOH_QTY
             , NULL                         AS BOD_ID
               /* --                       ,'I'   AS PSI_TYPE */
             , 'DIO'                        AS MEASURE
             , X.YYYYMMDD
             , (CASE WHEN X.DD = 0 THEN 0 ELSE X.DD END) AS QTY
             , '-'                          AS TRANSPORT_MODE_LINE
             , 'DIO'                        AS ATTRIBUTE1
          FROM GT_APGS_TBL_SMALL_DIO X
             , SCP_MST_FINAL_ITEM_V  Y
         WHERE X.ITEM_ID    = Y.ITEM_ID
           /* --                     AND X.CELL_ITEM_ID      = Y.CELL_ITEM_ID */
           AND X.FROM_SITE <> '-'
         UNION
        SELECT V_DIVISION_ID
             , V_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , N_SEQ
             , 'A'                          AS OPERATION_GROUP
             , Z.ITEM_ID
             , Z.CELL_ITEM_ID               AS CELL_ITEM_ID  /* -- update */
             , '-'                          AS TO_SITE
             , 0                            AS TO_BOH_QTY    /* -- update */
             , '-'                          AS INCOTERMS
             , Z.FROM_SITE
             , Z.FROM_BOH_QTY
             , NULL                         AS BOD_ID
             , 'DIO'                        AS MEASURE
             , Z.YYYYMMDD
             , (CASE WHEN Z.DD = 0 THEN 0 ELSE Z.DD END) AS QTY
             , '-'                          AS TRANSPORT_MODE_LINE
             , 'DIO'                        AS ATTRIBUTE1
          FROM GT_APGS_TBL_SMALL_DIO Z
             , SCM_MST_ITEM_CLASS_SN IC
         WHERE Z.ITEM_ID    = IC.CLASS_NAME
           AND Z.FROM_SITE <> '-';

        /* UPDATE X SET X.ATTRIBUTE9 = SUBSTRING(Y.FLOW_ID,1,5) .. INNER JOIN SCM_MST_DIVISION DM INNER JOIN SCP_MST_FINAL_ITEM Y */
        /* EE 계열은 사업부 조건 없이 품목만으로 대응 → 행 여럿이면 MSSQL 임의 한 행 → ROWNUM = 1 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL X
           SET X.ATTRIBUTE9 = (SELECT SUBSTR(Y.FLOW_ID, 1, 5)
                                 FROM SCM_MST_DIVISION   DM  /* -- 2023.03.29 HM JV 가상 사업부 추가 대응 */
                                    , SCP_MST_FINAL_ITEM Y
                                WHERE DM.DIVISION_ID = X.DIVISION_ID
                                  AND X.ITEM_ID      = Y.ITEM_ID
                                  AND Y.DIVISION_ID  = CASE WHEN DM.ATTRIBUTE3 = 'EE'  /* -- 2023.03.29 HM JV 가상 사업부 추가 대응 */
                                                            THEN Y.DIVISION_ID
                                                            ELSE X.DIVISION_ID
                                                       END
                                  AND DM.VALID_YN    = 'Y'
                                  AND ROWNUM         = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_DIVISION   DN
                            , SCP_MST_FINAL_ITEM Y2
                        WHERE DN.DIVISION_ID = X.DIVISION_ID
                          AND X.ITEM_ID      = Y2.ITEM_ID
                          AND Y2.DIVISION_ID = CASE WHEN DN.ATTRIBUTE3 = 'EE'
                                                    THEN Y2.DIVISION_ID
                                                    ELSE X.DIVISION_ID
                                               END
                          AND DN.VALID_YN    = 'Y');
        /* -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )    -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가, 0 --> '0' */

        UPDATE GT_APGS_PSI_GLOBAL_SMALL X
           SET X.ATTRIBUTE9 = (SELECT Y.PLANT_ID
                                 FROM SCM_MST_SITE Y
                                WHERE Y.DIVISION_ID = X.DIVISION_ID
                                  AND Y.SCM_SITE_ID = X.FROM_SITE
                                  AND Y.OSP_YN      = 'Y'
                                  AND ROWNUM        = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_SITE Y2
                        WHERE Y2.DIVISION_ID = X.DIVISION_ID
                          AND Y2.SCM_SITE_ID = X.FROM_SITE
                          AND Y2.OSP_YN      = 'Y');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 10. 정렬순서 입력 PACK/TCO/CELL(1/2/3) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* PACK */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL
           SET ATTRIBUTE10 = '1'
         WHERE OPERATION_GROUP = 'P';
        /* CELL */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL
           SET ATTRIBUTE10 = '3'
         WHERE OPERATION_GROUP = 'A';

        /* ---- TCO_CELL 일경우 */
        /* --    UPDATE X */
        /* --    SET X.ATTRIBUTE10      = '2' */
        /* --    FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK) */
        /* --    INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) */
        /* --      ON 0 = 0 */
        /* --      AND '40'                = Y.DIVISION_ID */
        /* --      AND X.ITEM_ID           = Y.ITEM_ID */
        /* --      AND X.OPERATION_GROUP   = 'A' */
        /* --      AND Y.TCO_CELL_YN       = 'Y' */

        /* PACK SITE CELL 재고인 경우 일경우 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL
           SET ATTRIBUTE10 = '2'
         WHERE OPERATION_GROUP = 'A'
           AND ATTRIBUTE1      = 'CELL';

        INSERT
          INTO GT_APGS_PSI_GLOBAL_SMALL2
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3  /* -- 2023.07.28 활성화코드 분리 대응 */
             , ATTRIBUTE4  /* -- 2025.06.26 KIMCD PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축. cell item class name 추가 */
             , ATTRIBUTE9
             , (CASE WHEN OPERATION_GROUP = 'P'                            THEN '1'
                     WHEN OPERATION_GROUP = 'A' AND ATTRIBUTE1  = 'CELL'   THEN '2'
                     WHEN OPERATION_GROUP = 'A' AND ATTRIBUTE1 <> 'CELL'   THEN '3'
                     ELSE ATTRIBUTE10
                END)                        AS ATTRIBUTE10
          FROM GT_APGS_PSI_GLOBAL_SMALL;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* SCP_ANL_PSI_GLOBAL_SMALL 삭제 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /*
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WHERE 0 = 0 AND ATTRIBUTE1  = '0'    -- ALLOCATION / BALANCE
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WHERE 0 = 0 AND ATTRIBUTE1  = 'SCP_ANL_SHIPMENT_PLAN_SEMI'  AND MEASURE ='MKT_FCST'     -- MKT_FCST
--           DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WHERE 0 = 0 AND ATTRIBUTE10 = '3'                           AND MEASURE ='WH_IN_BALANCE'-- WH_IN_BALANCE
            DELETE A FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL A  WITH (NOLOCK)
               INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
                       ON B.SCM_SITE_ID = A.TO_SITE
                      AND A.DIVISION_ID = B.DIVISION_ID
                      AND B.OSP_YN = 'Y'
                    WHERE 0 = 0
                     AND A.ATTRIBUTE10  = '3'
                     AND MEASURE ='WH_IN_BALANCE';
        */

        DELETE
          FROM GT_APGS_PSI_GLOBAL_SMALL2
         WHERE ATTRIBUTE1 = '0';  /* -- ALLOCATION / BALANCE */

        DELETE
          FROM GT_APGS_PSI_GLOBAL_SMALL2
         WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           AND MEASURE    = 'MKT_FCST';  /* -- MKT_FCST */
        /* --           DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WHERE 0 = 0 AND ATTRIBUTE10 = '3'                           AND MEASURE ='WH_IN_BALANCE'-- WH_IN_BALANCE */

        DELETE
          FROM GT_APGS_PSI_GLOBAL_SMALL2 A
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_SITE B
                        WHERE B.SCM_SITE_ID = A.TO_SITE
                          AND A.DIVISION_ID = B.DIVISION_ID
                          AND B.OSP_YN      = 'Y')
           AND A.ATTRIBUTE10 = '3'
           AND A.MEASURE     = 'WH_IN_BALANCE';

        /*
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL
            WHERE 0 = 0
            AND ATTRIBUTE10 = '2'
            AND MEASURE  IN ( 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE','ACTIVATE_PROGRESS')   -- TCO 셀
        */

        /*
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL
            FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
              INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
                ON 0 = 0
                AND '40'                = Y.DIVISION_ID
                AND X.ITEM_ID           = Y.ITEM_ID
                AND X.OPERATION_GROUP   = 'A'
                AND Y.TCO_CELL_YN       = 'Y'
                AND MEASURE  IN ( 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE','ACTIVATE_PROGRESS')   -- TCO 셀
        */

        DELETE
          FROM GT_APGS_PSI_GLOBAL_SMALL2 X
         WHERE EXISTS (SELECT 1
                         FROM SCP_MST_FINAL_ITEM Y
                        WHERE '40'          = Y.DIVISION_ID
                          AND X.ITEM_ID     = Y.ITEM_ID
                          AND Y.TCO_CELL_YN = 'Y')
           AND X.OPERATION_GROUP = 'A'
           AND X.MEASURE        IN ('ACTIVATE_COMPLETED', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS');  /* -- TCO 셀 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 */
        /* 2023.07.28 Cell Product 생산관련 measure 전구간 0인 데이터 삭제 */
        /* ------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '#tmp_TARGET_TO_DELETE - Start ');
        DELETE FROM GT_APGS_TARGET_TO_DELETE;  /* IF OBJECT_ID('tempdb..#tmp_TARGET_TO_DELETE') IS NOT NULL DROP TABLE #tmp_TARGET_TO_DELETE  ; */

        /* (ISNULL(TO_SITE,'-') = '-' OR RTRIM(TO_SITE) = '') → Oracle 빈 문자 = NULL 이라 RTRIM(..) IS NULL */
        INSERT
          INTO GT_APGS_TARGET_TO_DELETE
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , TOTAL_QTY
             , QTY_CNT
             )
        SELECT PG.DIVISION_ID
             , PG.PLAN_START_YYYYMMDD
             , PG.PLAN_TYPE
             , PG.SEQ
             , PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.CELL_ITEM_ID
             , PG.TO_SITE
             , PG.INCOTERMS
             , PG.FROM_SITE
             , PG.BOD_ID
             , PG.TRANSPORT_MODE_LINE
             , PG.MEASURE
             , NVL(SUM(PG.QTY), 0)                AS TOTAL_QTY
             , COUNT(DISTINCT NVL(PG.QTY, 0))     AS QTY_CNT
          FROM GT_APGS_PSI_GLOBAL_SMALL2 PG
             , SCM_MST_SITE              FS
             , GT_APGS_TARGET_TO_CONVERT TG
         WHERE FS.DIVISION_ID         = PG.DIVISION_ID
           AND FS.SCM_SITE_ID         = PG.FROM_SITE
           AND TG.PLANT_ID            = FS.PLANT_ID
           AND TG.PARENT_ITEM_ID      = PG.ITEM_ID
           AND FS.OPERATION_GROUP     = 'A'  /* -- Cell 창고 */
           AND FS.OSP_YN              = 'N'  /* -- 외주 제외 */
           AND PG.OPERATION_GROUP     = 'A'  /* -- Cell  품목 */
           AND (NVL(PG.TO_SITE, '-') = '-' OR RTRIM(PG.TO_SITE) IS NULL)
           AND PG.MEASURE            IN ('PRODUCTION', 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'MODEL_INVENTORY', 'DIO', 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY')  /* -- 생산관련 measure */
           AND PG.DIVISION_ID         = V_DIVISION_ID
           AND PG.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND PG.PLAN_TYPE           = P_PLAN_TYPE
           AND PG.SEQ                 = N_SEQ
          /* ------------------------------------------------------------------------------------------------------------- */
          /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
          /* 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY' 유형 추가 */
          /* ------------------------------------------------------------------------------------------------------------- */
         GROUP BY PG.DIVISION_ID
                , PG.PLAN_START_YYYYMMDD
                , PG.PLAN_TYPE
                , PG.SEQ
                , PG.OPERATION_GROUP
                , PG.ITEM_ID
                , PG.CELL_ITEM_ID
                , PG.TO_SITE
                , PG.INCOTERMS
                , PG.FROM_SITE
                , PG.BOD_ID
                , PG.TRANSPORT_MODE_LINE
                , PG.MEASURE
        HAVING NVL(SUM(PG.QTY), 0)            = 0
           AND COUNT(DISTINCT NVL(PG.QTY, 0)) = 1;

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || 'Delete #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 - 전구간0인 cp 생산 measure');
        DELETE
          FROM GT_APGS_PSI_GLOBAL_SMALL2 TGT
         WHERE EXISTS (SELECT 1
                         FROM GT_APGS_TARGET_TO_DELETE D
                        WHERE D.DIVISION_ID                    = TGT.DIVISION_ID
                          AND D.PLAN_START_YYYYMMDD            = TGT.PLAN_START_YYYYMMDD
                          AND D.PLAN_TYPE                      = TGT.PLAN_TYPE
                          AND D.SEQ                            = TGT.SEQ
                          AND D.OPERATION_GROUP                = TGT.OPERATION_GROUP
                          AND D.ITEM_ID                        = TGT.ITEM_ID
                          AND D.FROM_SITE                      = TGT.FROM_SITE
                          AND D.MEASURE                        = TGT.MEASURE
                          AND NVL(D.CELL_ITEM_ID       , '-')  = NVL(TGT.CELL_ITEM_ID       , '-')
                          AND NVL(D.TRANSPORT_MODE_LINE, '-')  = NVL(TGT.TRANSPORT_MODE_LINE, '-')
                          AND NVL(D.INCOTERMS          , '-')  = NVL(TGT.INCOTERMS          , '-')
                          AND NVL(D.BOD_ID             , '-')  = NVL(TGT.BOD_ID             , '-'))
           AND (NVL(TGT.TO_SITE, '-') = '-' OR RTRIM(TGT.TO_SITE) IS NULL);

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || 'Delete #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 - 전구간0인 cp 생산 measure-End');

        /* Begin 2023.08.03 외주 TCO 모델 출하정보로 도착지 생산 정보 생성한 데이터 삭제 (Production  및 해당 production 으로 인해 생성된 생산 관련 measure들) */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '#tmp_OSP_CELL_TARGET_TO_DELETE - Start ');
        DELETE FROM GT_APGS_OSP_CELL_TGT_DEL;  /* IF OBJECT_ID('tempdb..#tmp_OSP_CELL_TARGET_TO_DELETE') IS NOT NULL DROP TABLE ..  ; */

        INSERT
          INTO GT_APGS_OSP_CELL_TGT_DEL
             ( FROM_SITE
             , ITEM_ID
             , OSP_YN
             )
        SELECT DISTINCT
               A.FROM_SITE
             , A.ITEM_ID
             , S.OSP_YN
          FROM SCP_ANL_PSI_PRODUCTION A
             , SCM_MST_SITE           S
         WHERE S.DIVISION_ID         = A.DIVISION_ID
           AND S.SCM_SITE_ID         = A.PSI_VALUE  /* -- 라인이 아닌 사이트 정보가 있는 건 (PSI PRODUCTION에서 추가한 데이터) */
           AND A.PSI_TYPE            = 'P'          /* -- 생산 */
           AND A.PSI_VALUE          <> 'DIO'
           AND A.PSI_VALUE          <> 'ISSUM'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ;

        DELETE
          FROM GT_APGS_PSI_GLOBAL_SMALL2 TGT
         WHERE EXISTS (SELECT 1
                         FROM GT_APGS_OSP_CELL_TGT_DEL TD
                        WHERE TD.FROM_SITE = TGT.FROM_SITE
                          AND TD.ITEM_ID   = TGT.ITEM_ID)
           AND EXISTS (SELECT 1
                         FROM SCP_MST_FINAL_ITEM FI
                        WHERE FI.DIVISION_ID     = TGT.DIVISION_ID
                          AND FI.ITEM_ID         = TGT.ITEM_ID
                          AND FI.OPERATION_GROUP = 'A'
                          AND FI.ATTRIBUTE8      = 'CP')  /* -- 외주TCO.CP 또는 사내CP */
           AND TGT.MEASURE IN ('PRODUCTION', 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'MODEL_INVENTORY', 'DIO', 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY');  /* -- 생산관련 measure */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY' 유형 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* End 2023.08.03 외주 TCO 모델 출하정보로 도착지 생산 정보 생성한 데이터 삭제 (Production  및 해당 production 으로 인해 생성된 생산 관련 measure들) */

        UPDATE GT_APGS_PSI_GLOBAL_SMALL2 TGT
           SET TGT.ATTRIBUTE4 = (SELECT IC.CLASS_NAME
                                   FROM SCP_MST_FINAL_ITEM    FI
                                      , SCM_MST_ITEM_CLASS_SN IC
                                  WHERE FI.DIVISION_ID = TGT.DIVISION_ID
                                    AND FI.ITEM_ID     = TGT.CELL_ITEM_ID
                                    AND FI.ITEM_CLASS  = IC.CLASS_ID
                                    AND ROWNUM         = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCP_MST_FINAL_ITEM    FJ
                            , SCM_MST_ITEM_CLASS_SN ID
                        WHERE FJ.DIVISION_ID = TGT.DIVISION_ID
                          AND FJ.ITEM_ID     = TGT.CELL_ITEM_ID
                          AND FJ.ITEM_CLASS  = ID.CLASS_ID);

        /* 합산 정보에 ATTRIBUTE4로 갱신. 정렬 순서도 변경 */
        UPDATE GT_APGS_PSI_GLOBAL_SMALL2 TGT
           SET TGT.ATTRIBUTE4  = TGT.CELL_ITEM_ID
             , TGT.ATTRIBUTE10 = '4'
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_ITEM_CLASS_SN IC
                        WHERE IC.CLASS_NAME = TGT.CELL_ITEM_ID);
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 */
        /* CELL ITEM CLASS NAME 갱신 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 10. SCP_ANL_PSI_GLOBAL_SMALL 삭제 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 속도 계선 */

        /* --PRINT '[' + CONVERT(VARCHAR(100), GETDATE(),120) + ']' */
        /* --SELECT 1 */
        /* --WHILE @@ROWCOUNT > 0  -- UPDATE  @@ROWCOUNT */
        /* --BEGIN */
        /* --  DELETE TOP (1000) */
        /* --  FROM SCP_ANL_PSI_GLOBAL_SMALL */
        /* --  WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */
        /* --END */

        /* -- 2021.11.11 튜닝개선안에 따른 삭제구분 변경 */
        LOOP  /* WHILE(1 = 1) */
            DELETE
              FROM SCP_ANL_PSI_GLOBAL_SMALL
             WHERE DIVISION_ID         = V_DIVISION_ID
               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND PLAN_TYPE           = P_PLAN_TYPE
               AND SEQ                 = N_SEQ
               AND ROWNUM             <= 10000;  /* DELETE TOP (10000) */

            EXIT WHEN SQL%ROWCOUNT = 0;  /* IF(@@ROWCOUNT = 0) BREAK; */
        END LOOP;
        /* --PRINT '[' + CONVERT(VARCHAR(100), GETDATE(),120) + ']' */
        /* -- [40][1054::PR::1][35:45] 10000 */
        /* -- [40][1054::PR::1][33:28] 1000    [40][1054::PR::1][60:08] */
        /* -- [40][1054::PR::1][25:54] 500 */

        /* -- TRUNCATE TABLE SCP_ANL_PSI_GLOBAL_SMALL    -- [40][1052::PR::1][06:57] */
        /* -- sp_spaceused SCP_ANL_PSI_GLOBAL_SMALL      -- 2519503 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 11. SCP_ANL_PSI_GLOBAL_SMALL 입력 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* KSW 2021-03-24 PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 :: 0 값 삭제처리 추가 - start */
        /* OLD : (원문 주석 블록 — 0 값 삭제처리 이전 SELECT .. FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL .. GROUP BY ..) */
        /*                    --SELECT */
        /*                    --       DIVISION_ID */
        /*                    --      ,PLAN_START_YYYYMMDD */
        /*                    --      ,PLAN_TYPE */
        /*                    --      ,SEQ */
        /*                    --      ,OPERATION_GROUP */
        /*                    --      ,ITEM_ID */
        /*                    --      ,CELL_ITEM_ID */
        /*                    --      ,ISNULL(TO_SITE,'') */
        /*                    --      ,TO_BOH_QTY */
        /*                    --      ,ISNULL(INCOTERMS, '-') */
        /*                    --      ,FROM_SITE */
        /*                    --      ,FROM_BOH_QTY */
        /*                    --      ,ISNULL(BOD_ID,'-') */
        /*                    --      ,ISNULL(TRANSPORT_MODE_LINE,'-') */
        /*                    --      ,MEASURE */
        /*                    --      ,YYYYMMDD */
        /*                    --      ,SUM(ISNULL(QTY,0)) AS QTY */
        /*                    --      ,@v_batch_user AS CREATED_BY */
        /*                    --      ,GETDATE()     AS CREATION_DATE */
        /*                    --      ,@v_batch_user AS LAST_UPDATED_BY */
        /*                    --      ,GETDATE()     AS LAST_UPDATED_BY */
        /*                    --      ,ATTRIBUTE1 */
        /*                    --      ,ATTRIBUTE2 */
        /*                    --      ,ATTRIBUTE9 */
        /*                    --      ,ATTRIBUTE10 */
        /*                    --  FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL WITH (NOLOCK) */
        /*                    -- WHERE 1=1 */
        /*                    -- AND YYYYMMDD < @v_DD */
        /*                    -- AND CELL_ITEM_ID IS NOT NULL */
        /*                    -- AND MEASURE <> '-' */
        /*                    -- GROUP BY */
        /*                    --       DIVISION_ID */
        /*                    --      ,PLAN_START_YYYYMMDD */
        /*                    --      ,PLAN_TYPE */
        /*                    --      ,SEQ */
        /*                    --      ,OPERATION_GROUP */
        /*                    --      ,ITEM_ID */
        /*                    --      ,CELL_ITEM_ID */
        /*                    --      ,TO_SITE */
        /*                    --      ,TO_BOH_QTY */
        /*                    --      ,ISNULL(INCOTERMS, '-') */
        /*                    --      ,FROM_SITE */
        /*                    --      ,FROM_BOH_QTY */
        /*                    --      ,ISNULL(BOD_ID,'-') */
        /*                    --      ,ISNULL(TRANSPORT_MODE_LINE,'-') */
        /*                    --      ,MEASURE */
        /*                    --      ,YYYYMMDD */
        /*                    --      ,ATTRIBUTE1 */
        /*                    --      ,ATTRIBUTE2 */
        /*                    --      ,ATTRIBUTE9 */
        /*                    --      ,ATTRIBUTE10 */
        /*                    --      ; */
        /* TO_SITE : 원문 ISNULL(TO_SITE,'') 의 빈 문자 → TO-BE 원장 NOT NULL 칸 채움값 '-' (이관 데이터와 같은 값) */
        INSERT
          INTO SCP_ANL_PSI_GLOBAL_SMALL  /* SCP_ANL_PSI_GLOBAL_SMALL */
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , CELL_ITEM_ID
             , TO_SITE
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_BOH_QTY
             , BOD_ID
             , TRANSPORT_MODE_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3  /* -- 2023.07.28 활성화코드 분리 대응 */
             , ATTRIBUTE4  /* -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 CELL ITEM CLASS NAME 추가 */
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT DT.DIVISION_ID
             , DT.PLAN_START_YYYYMMDD
             , DT.PLAN_TYPE
             , DT.SEQ
             , DT.OPERATION_GROUP
             , DT.ITEM_ID
             , DT.CELL_ITEM_ID
             , DT.TO_SITE
             , DT.TO_BOH_QTY
             , DT.INCOTERMS
             , DT.FROM_SITE
             , DT.FROM_BOH_QTY
             , DT.BOD_ID
             , DT.TRANSPORT_MODE_LINE
             , DT.MEASURE
             , DT.YYYYMMDD
             , SUM(DT.QTY)                  AS QTY
             , V_BATCH_USER                 AS CREATED_BY
             , SYSDATE                      AS CREATION_DATE
             , V_BATCH_USER                 AS LAST_UPDATED_BY
             , SYSDATE                      AS LAST_UPDATE_DATE
             , DT.ATTRIBUTE1
             , DT.ATTRIBUTE2
             , MAX(DT.ATTRIBUTE3)           AS ATTRIBUTE3  /* -- 2023.07.28 활성화코드 분리 대응 */
             , MAX(DT.ATTRIBUTE4)           AS ATTRIBUTE4  /* -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 CELL ITEM CLASS NAME 추가 */
             , DT.ATTRIBUTE9
             , DT.ATTRIBUTE10
          FROM (
                SELECT ZZ.DIVISION_ID
                     , ZZ.PLAN_START_YYYYMMDD
                     , ZZ.PLAN_TYPE
                     , ZZ.SEQ
                     , ZZ.OPERATION_GROUP
                     , ZZ.ITEM_ID
                     , ZZ.CELL_ITEM_ID
                     , ZZ.TO_SITE
                     , ZZ.TO_BOH_QTY
                     , ZZ.INCOTERMS
                     , ZZ.FROM_SITE
                     , ZZ.FROM_BOH_QTY
                     , ZZ.BOD_ID
                     , ZZ.TRANSPORT_MODE_LINE
                     , ZZ.MEASURE
                     , (CASE WHEN ZZ.QTY = 0.0 THEN ZZ.PLAN_START_YYYYMMDD ELSE ZZ.YYYYMMDD END) AS YYYYMMDD
                     , ZZ.QTY
                     , ZZ.ATTRIBUTE1
                     , ZZ.ATTRIBUTE2
                     , ZZ.ATTRIBUTE3  /* -- 2023.07.28 활성화코드 분리 대응 */
                     , ZZ.ATTRIBUTE4  /* -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 CELL ITEM CLASS NAME 추가 */
                     , ZZ.ATTRIBUTE9
                     , ZZ.ATTRIBUTE10
                  FROM (
                        SELECT A.DIVISION_ID
                             , A.PLAN_START_YYYYMMDD
                             , A.PLAN_TYPE
                             , A.SEQ
                             , A.OPERATION_GROUP
                             , A.ITEM_ID
                             , A.CELL_ITEM_ID
                             , NVL(A.TO_SITE, '-')              AS TO_SITE
                             , A.TO_BOH_QTY
                             , NVL(A.INCOTERMS, '-')            AS INCOTERMS
                             , A.FROM_SITE
                             , A.FROM_BOH_QTY
                             , NVL(A.BOD_ID, '-')               AS BOD_ID
                             , NVL(A.TRANSPORT_MODE_LINE, '-')  AS TRANSPORT_MODE_LINE
                             , A.MEASURE
                             , A.YYYYMMDD
                             , SUM(NVL(A.QTY, 0))               AS QTY
                             , A.ATTRIBUTE1
                             , A.ATTRIBUTE2
                             , MAX(A.ATTRIBUTE3)                AS ATTRIBUTE3  /* -- 2023.07.28 활성화코드 분리 대응 */
                             , MAX(A.ATTRIBUTE4)                AS ATTRIBUTE4  /* -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 CELL ITEM CLASS NAME 추가 */
                             , A.ATTRIBUTE9
                             , A.ATTRIBUTE10
                          /* --FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL WITH (NOLOCK) */
                          FROM GT_APGS_PSI_GLOBAL_SMALL2 A
                         WHERE A.YYYYMMDD      < V_DD
                           AND A.CELL_ITEM_ID IS NOT NULL
                           AND A.MEASURE      <> '-'
                         GROUP BY A.DIVISION_ID
                                , A.PLAN_START_YYYYMMDD
                                , A.PLAN_TYPE
                                , A.SEQ
                                , A.OPERATION_GROUP
                                , A.ITEM_ID
                                , A.CELL_ITEM_ID
                                , A.TO_SITE
                                , A.TO_BOH_QTY
                                , NVL(A.INCOTERMS, '-')
                                , A.FROM_SITE
                                , A.FROM_BOH_QTY
                                , NVL(A.BOD_ID, '-')
                                , NVL(A.TRANSPORT_MODE_LINE, '-')
                                , A.MEASURE
                                , A.YYYYMMDD
                                , A.ATTRIBUTE1
                                , A.ATTRIBUTE2
                                , A.ATTRIBUTE9
                                , A.ATTRIBUTE10
                       ) ZZ
               ) DT
         GROUP BY DT.DIVISION_ID
                , DT.PLAN_START_YYYYMMDD
                , DT.PLAN_TYPE
                , DT.SEQ
                , DT.OPERATION_GROUP
                , DT.ITEM_ID
                , DT.CELL_ITEM_ID
                , DT.TO_SITE
                , DT.TO_BOH_QTY
                , DT.INCOTERMS
                , DT.FROM_SITE
                , DT.FROM_BOH_QTY
                , DT.BOD_ID
                , DT.TRANSPORT_MODE_LINE
                , DT.MEASURE
                , DT.YYYYMMDD
                , DT.ATTRIBUTE1
                , DT.ATTRIBUTE2
                , DT.ATTRIBUTE9
                , DT.ATTRIBUTE10;

        /* KSW 2021-03-24 PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 :: 0 값 삭제처리 추가 - end */

        /* ----------------------------------------------------------- */
        /* 실행 Logic END -- */
        /* ----------------------------------------------------------- */
        /* --IF @@TRANCOUNT > 0 */
        /* --  BEGIN */
        /* --    COMMIT TRAN TX_PG; */
        /* --  END; */

        /* ----------------------------------------------------------- */
        /* 임시테이블 삭제 */
        /* ----------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL') .. #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 .. #YYYYMMDD .. #BOH */
        /* .. #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO .. #Tbl_DIO .. #Tbl_SCP_ANL_PSI_GLOBAL_SMALL_DIO  DROP TABLE */
        /* -- begin 2023.07.28 활성화코드 분리 대응 */
        /* IF OBJECT_ID('TEMPDB..#TMP_CELL_BOM_40') .. #TMP_TARGET_TO_CONVERT .. #tgt_CELL_PRODUCT_MODEL_INVENTORY .. #tmp_TARGET_TO_DELETE  DROP TABLE */
        /* -- end 2023.07.28 활성화코드 분리 대응 */
        /* → GTT 는 다음 실행 시작에서 DELETE 로 비움 */

        /* -- TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := 1;  /* @@ROWCOUNT : 바로 앞 SET @v_log_type 단순 대입문이 1 로 바꿔 둔 값 */
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            /* --IF @@TRANCOUNT > 0 */
            /* --  BEGIN */
            /* --    ROLLBACK TRAN TX_PG */
            /* --  END; */

            /* ERROR LOG */
            V_LOG_TYPE     := 'ERROR';
            V_LOG_MESSAGE  := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION  := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE   := SYSDATE;
            V_IN_PARA_DATA := SUBSTR( 'P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                                   || ',P_PLAN_ID='             || P_PLAN_ID
                                   || ',P_SEQ='                 || P_SEQ
                                   || ',P_PLAN_TYPE='           || P_PLAN_TYPE
                                   || ',P_MASTER_ID='           || P_MASTER_ID
                                   || ',P_DIVISION_ID='         || P_DIVISION_ID
                                   || ',P_ENGINE_PLAN_ID='      || P_ENGINE_PLAN_ID
                                   || ',P_USER_ID='             || P_USER_ID, 1, 4000);
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                                , P_LOG_TYPE      => V_LOG_TYPE
                                , P_LOG_COUNT     => N_LOG_COUNT
                                , P_LOG_MESSAGE   => V_LOG_MESSAGE
                                , P_DESCRIPTION   => V_DESCRIPTION
                                , P_EVENT_DATE    => D_EVENT_DATE
                                , P_USER_ID       => V_BATCH_USER
                                , P_IN_PARA_DATA  => V_IN_PARA_DATA
                                , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                                , P_SQL_ERR_MSG   => SQLERRM
                                , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                );
            /* --      PRINT @@ERROR */
            O_RETURN := -1;
            RETURN;  /* return -1 */
    END;  /* END CATCH; */

    /* 임시 운영반영시에 주석처리 할것. */
    /* REPLICATE('0', 2 - LEN(x)) + x : x 가 세 자리 이상이면 REPLICATE 가 NULL 을 돌려 전체가 NULL → CASE 로 재현 */
    V_EXEC_TIME := CASE
                     WHEN LENGTH(TO_CHAR(TRUNC(TRUNC((SYSDATE - V_START_TIME) * 86400) / 60))) > 2
                       OR LENGTH(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60))) > 2
                     THEN NULL
                     ELSE LPAD(TO_CHAR(TRUNC(TRUNC((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                          || ':' ||
                          LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := CASE WHEN P_MASTER_ID IS NULL OR P_ENGINE_PLAN_ID IS NULL OR V_EXEC_TIME IS NULL THEN NULL  /* '+' 결합은 NULL 하나면 전체 NULL */
                          ELSE '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']'
                     END;
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    O_RETURN := 1;
    RETURN;  /* return 1 */
END;