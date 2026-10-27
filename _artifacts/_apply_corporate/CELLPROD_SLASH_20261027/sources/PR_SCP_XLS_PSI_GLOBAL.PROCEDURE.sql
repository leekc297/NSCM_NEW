PROCEDURE PR_SCP_XLS_PSI_GLOBAL
( P_PLAN_CYCLE            IN  VARCHAR2                       /* NVARCHAR(0150) */
, P_PLAN_START_YYYYMMDD   IN  VARCHAR2                       /* NVARCHAR(0008) */
, P_PLAN_ID               IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_MODELING_ID           IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_SEQ                   IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_PLAN_TYPE             IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_MASTER_ID             IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_DIVISION_ID           IN  VARCHAR2                       /* NVARCHAR(0030) */
, P_ENGINE_PLAN_ID        IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_USER_ID               IN  VARCHAR2 DEFAULT 'SCP_batch'   /* NVARCHAR(0150)  = 'SCP_batch' */
, P_IS_DEBUG              IN  VARCHAR2 DEFAULT '0'           /* bit = 0 : -- 0:	RELEASE    , 1 : DEBUG */
, P_CELL                  IN  VARCHAR2 DEFAULT NULL          /* NVARCHAR(50) = NULL : -- 디버그용 셀 */
, P_TO_SITE               IN  VARCHAR2 DEFAULT NULL          /* NVARCHAR(50) = NULL : -- 디버그용 도착지 */
, O_RETURN                OUT NUMBER                         /* AS-IS RETURN 값 */
)
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :

      EXEC PR_SCP_XLS_PSI_GLOBAL
               @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20190325'
             , @p_plan_id             = '1071'
             , @p_modeling_id         = '2'
             , @p_seq                 = '1'
             , @p_plan_type           = 'PR'
             , @p_master_id           = '81::WEEKLY'
             , @p_division_id         = '81'
             , @p_engine_plan_id      = '1071::PR::1'
             , @p_user_id             = 'KTH'

    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL' order by CREATION_DATE desc

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.01.08   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.01.23   KTH         TRANSPORT_MODE 반영
 * 2019.02.11   KTH         PROJECT_CODE 추가
 * 2019.02.20   KTH         INCOTERMS 추가
 * 2019.04.01   KTH         WEEK로직으로 변경
 * 2019.04.10   KTH         LINE LOAD율 로직 변경
 * 2019.04.17   KTH         SHIP_PLAN, CELL_FORM_PROGRESS,CELL_FOR_FORM_END  로직 변경
 * 2019.04.18   KTH         SHIP_PLAN 수정
 * 2019.04.22   KTH         SHIP_PLAN이 없을 경우 로직 반영
 * 2019.04.24   YYDOK       BOH 수량오류수정.=> XLS_BOH활용으로 통일
 * 2019.04.25   KTH         YIELD 추가
 * 2019.04.30   KTH         DIO 계산용 MEASURE 추가(MKT_FCST_TOTAL,ALLOCATION_TOTAL,EOH_TOTAL,MKT_FCST_DIO,ALLOCATION_DIO)
 * 2019.05.14   KTH         CELL_FORM_HOLD 추가
 * 2019.05.28   KTH         PACK공장 CELL 재고 로직 변경
 * 2019.05.29   KTH         LINE_ID 추가 로직 수정
 * 2019.06.03   KTH         BOD LT (SHIP_PLAN/SEMI_SHIP_PLAN) : BOD L/T 계산시 1~7일 구간은 반올림, 이후 구간은 올림 처리
 * 2019.06.05   KTH         TRANSPORT 모드 추가 로직 변경(SEMI_SHIP_PLAN)
 * 2019.06.10   KTH         YIELD 수정 (PLANT_SITE_ID 조건 추가)
 * 2019.06.12   KTH         Line Load율 로직 변경
 * 2019.06.26   KTH         MKT_FCST_PACK_TOTAL,MKT_FCST_CELL_TOTAL 추가
 * 2019.06.27   KTH         PACK_PROD MEASURE에 YIELD 추가
 * 2019.07.03   KTH         TRANSPORT_MODE 추가시 SUB.TRANSPORT_MODE  IS NOT NULL 조건 추가
 * 2019.07.09   KTH         YIELD(CELL_CHAR_AVAILABLE) 로직 변경 (CASE WHEN Y.SSP_MODIFY_YIELD > 0.0 THEN Y.SSP_MODIFY_YIELD ELSE Y.FORMATION_TOTAL_YIELD END)
 * 2019.07.10   KTH         INTRANSIT 계산시 INCOTERMS 도 구분하여 계산하는 로직 추가
 * 2019.08.23   KTH         FG FROM SITE와 WH_IN만 MEASURE 있는 경우 누락되는 로직 수정
 * 2019.09.05   KTH         SEMI SEMI_SHIP_PLAN없이 해상재고만 있는 경우 누락되는 로직 수정
 * 2019.09.17   KTH         SEMI_SHIP_PLAN BOD_ID 없이 생성되는 중복 오류 보정
 * 2019.11.12   KTH         PACK_BOH 로직 변경(MODEL_INVENTORY 생성부분 삭제)
 * 2020.01.07   KTH         #Rn 테이블 변경
 * 2020.02.06   KTH         ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
 * 2020.03.17   KTH         LT 로직 변경(SCM_MST_SITE_ITEM.SCP_VMI_LT)
 * 2020.03.23   KTH         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
 * 2020.03.31   KTH         CELL_PROD LT로직 변경
 * 2020.06.26   KTH         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
 * 2020.06.25   KTH         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련, 2020.07.02 KSW 보완
 * 2020.07.13   KSW         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련 - 기준/최소 쿼리에서 YYYYMM -> YYYYQ 으로 변경
 * 2020.07.14   KSW         생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완
 * 2020.09.03   KSW         SEMI 첫날 수량이 0값으로 되는 오류수정 - 해상재고 union 할 때 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완)
 * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (+26주 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
							- 실제로는 364 + 364 플랜 DATA 가 생성됨
 * 2021.05.27   KSW         NICK NAME 누락오류 수정
 * 2021.06.28   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가
 * 2021.08.10   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현
 * 2021.08.10   KSW         capa. 적용기준 변경
 * 2021.08.17   KSW         CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가 - PRIORITY 조건 추가
 * 2021.08.25   KSW         CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - SCM_MST_SITE_ITEM_PRIORITY From/To YYYYMMDD 조건변경
 * 2021.08.26   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021.09.08   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가
 * 2021.10.19   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외
 * 2021.10.26   KSW         튜닝개선안 반영
 * 2021.11.03   KSW         Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정
 * 2022.07.29   KSW         DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체
 * 2022.08.30   KSW			Cell 재고 개선건
 *							1) PACK_CELL_BOH	Cell BOH measure 에서 HOLD 수량제외
 *							2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
 *							3) CELL_FORM_HOLD_AFTER	After Form. Hold Release measure 에서 FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
 * 2022.10.14	KSW			불필요한 생산계획 생성을 차단
 * 2022.10.19   KSW			Memo measure 추가
 * 2022.12.05	KSW			Line assign 조건변경
 * 2023.07.01 KSK/DHJ		PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 분리
 * 2024.05.08 KSK				E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경)
 * 2024.07.04 KSK				라인정보 가져올때 ACTIVE_FLAG 유효성('Y') 체크
 * 2024.08.14 KSK				이동계획의 말일자 데이터 누락 수정
 * 2025.02.03 KSK				INTRANSIT_ETA와 SEMI_INTRANSIT_ETA 메저추가시  SITE_TYPE조건을 추가함
 * 2025.04.22 KIMCD			#LineLoad 형성용 조회문에 HASH JOIN 추가
 * 2025.04.23 KSK				디버그 파라미터 추가
 * 2025.04.30 KSK				멀티구간 BOD 로직수정
 * 2025.07.09 KSK				멀티구간 BOD 로직보완(BOD_VALID_YN, ROUTE VALID)
 * 2025.08.29 YMH           CSR E20250829-001508 실행계획개선 (속도개선)
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
/* --DROP PROC dbo.PR_SCP_XLS_PSI_GLOBAL */
AS
    /* AS-IS 인자 선언 길이 재현 */
    V_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR)    := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_DIVISION_ID          VARCHAR2(30 CHAR)   := SUBSTR(P_DIVISION_ID, 1, 30);
    V_USER_ID              VARCHAR2(150 CHAR)  := SUBSTR(P_USER_ID, 1, 150);
    /* AS-IS 숫자 칸(SEQ) = NVARCHAR 인자 비교 → 인자를 숫자로 바꿔 비교 */
    V_SEQ                  NUMBER              := TO_NUMBER(P_SEQ);

    /* -- LOG 용 변수 설정 */
    V_BATCH_USER           VARCHAR2(150 CHAR)  := 'SCP_batch';
    V_PROGRAM_NAME         VARCHAR2(150 CHAR)  := 'PR_SCP_XLS_PSI_GLOBAL';
    V_LOG_TYPE             VARCHAR2(30 CHAR);   /* -- START/END/ERROR/... */
    N_LOG_COUNT            INTEGER             := 0;
    V_LOG_MESSAGE          VARCHAR2(1000 CHAR);
    V_DESCRIPTION          VARCHAR2(500 CHAR);
    V_TABLE_ID             VARCHAR2(150 CHAR)  := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE           DATE;

    /* -- 실행시간 확인용 */
    V_START_TIME           DATE                := SYSDATE;
    V_EXEC_TIME            VARCHAR2(10 CHAR)   := '';   /* --'00:00'; */

    V_P_PROGRAM_ID         VARCHAR2(30 CHAR)   := 'XLSPSI01';
    V_P_TO_YYYYMMDD        VARCHAR2(8 CHAR)    := '';   /* --CONVERT(VARCHAR(8), DATEADD(day, 728, @p_plan_start_yyyymmdd), 112) */
    V_P_CUTOFF_DATE        VARCHAR2(8 CHAR)    := TO_CHAR(TO_DATE(SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8), 'YYYYMMDD') - 1, 'YYYYMMDD');

    /* --DECLARE @debug_mode            NVARCHAR(30) = 'T' */
    V_BP_FLAG              VARCHAR2(8 CHAR)    := '';

    V_ROWS                 NUMBER;
    V_CREATE_FROM_YYYYMMDD VARCHAR2(8 CHAR);
    V_CREATE_TO_YYYYMMDD   VARCHAR2(8 CHAR);

    /* --  Plan End Date */
    V_PET_DATE             VARCHAR2(12 CHAR)   := '';
    V_BP_DAYS              INTEGER             := 0;
    V_BP_PLAN_END_YYYYMMDD VARCHAR2(8 CHAR)    := '';
BEGIN
    O_RETURN := 0;  /* 반환값 초기화 */

    /* AS-IS 무대응 구문(원문 보존)
       SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
       SET NOCOUNT ON;
       SET XACT_ABORT ON;
       --SET ANSI_WARNINGS OFF;
       SET ANSI_WARNINGS ON;
       SET ANSI_NULLS ON; */

    V_BATCH_USER := V_USER_ID;

    /* -- 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    IF P_IS_DEBUG = '0' THEN
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END IF;

    BEGIN  /* BEGIN TRY */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- PLAN 기간설정 - 2021.11.19 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* DECLARE @v_bp_flag NVARCHAR(8) = '' → 선언부 V_BP_FLAG
           AS-IS SELECT @변수 = ... : 행이 없으면 변수값 유지 → FOR 루프로 재현
           AS-IS plan_id(NVARCHAR) < 9999 : MSSQL 은 칸을 숫자로 바꿔 비교 → TO_NUMBER */
        FOR R IN (SELECT P.HORIZON_END_DATE
                       , (CASE WHEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') > 364 THEN 'Y' ELSE 'N' END) AS BP_FLAG
                    FROM SCM_MST_PLAN P
                   WHERE P.DIVISION_ID = V_DIVISION_ID
                     AND P.PLAN_ID     = (SELECT MAX(SA.PLAN_ID)
                                            FROM SCM_MST_PLAN SA
                                           WHERE SA.DIVISION_ID = V_DIVISION_ID
                                             AND TO_NUMBER(SA.PLAN_ID) < 9999)
                     AND P.PLAN_CYCLE  = 'WEEKLY'
                 )
        LOOP
            V_P_TO_YYYYMMDD := R.HORIZON_END_DATE;
            V_BP_FLAG       := R.BP_FLAG;
        END LOOP;

        IF V_BP_FLAG = 'Y' THEN
            /* -- 중장기일 경우 104주차로 변경 */
            V_P_TO_YYYYMMDD := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364 + 363, 'YYYYMMDD');
        END IF;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 정보 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#MEASURE') IS NOT NULL DROP TABLE #MEASURE → GTT 초기화 */
        DELETE
          FROM GT_XGLB_MEASURE;

        /* MEASURE 세팅값 추출 */
        INSERT
          INTO GT_XGLB_MEASURE
             ( COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             , DIV
             , GUBUN
             )
        SELECT M.COLUMN_NAME
             , M.COLUMN_LABEL_NAME
             , M.SORT_ORDER_NO
             , (CASE WHEN M.ATTRIBUTE1 = 'PACK' THEN 'P' WHEN M.ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END) AS DIV
             , M.ATTRIBUTE2                                                                                 AS GUBUN
          FROM SCM_MST_SHEET_MEASURE M
         WHERE M.PROGRAM_ID = V_P_PROGRAM_ID
           AND M.VALID_YN   = 'Y'
        ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  데이터 이관 ('MKT_FCST','SHIP_PLAN','PRODUCTION') */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#PSI_GLOBAL') IS NOT NULL DROP TABLE #PSI_GLOBAL; CREATE TABLE #PSI_GLOBAL (...) → GTT 초기화
           칸 설명 원문 : PROJECT_CODE -- FG 때문에 추가 / TO_BOH_QTY --BIGINT / FROM_BOH_QTY -- BIGINT / ATTRIBUTE9 -- OPERATION_ID */
        DELETE
          FROM GT_XGLB_PSI_GLOBAL;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- SHIP_PLAN (FG) (팩,셀 공통) - MKT_FCST, SHIP_PLAN */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* AS-IS '' AS CELL_ITEM_ID : Oracle 은 빈 문자가 NULL
           AS-IS ISNULL(NULLIF(A.TO_SITE, ''), '-') : 빈 문자(공백만 포함)는 '-' → CASE WHEN RTRIM(..) IS NULL */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.BIZ_TYPE
             , ''                                                                  AS CELL_ITEM_ID
             , A.ITEM_ID
             , (CASE WHEN RTRIM(A.TO_SITE) IS NULL THEN '-' ELSE A.TO_SITE END)    AS TO_SITE
             , A.PROJECT_CODE
             , 0                                                                   AS TO_BOH_QTY
             , 0                                                                   AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
               /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL((SELECT C.TRANSPORT_MODE
                      FROM SCP_MST_BOD_N_V C
                     WHERE 0 = 0
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND A.BOD_ID      = C.BOD_ID
                       AND A.FROM_SITE   = C.FROM_SITE
                       AND ROWNUM        = 1), '-')                                AS TRANSPORT_MODE
             , '-'                                                                 AS PROD_LINE
             , A.MEASURE                                                           /* -- SHIP_PLAN FG */
             , A.YYYYMMDD                                                          AS YYYYMMDD
             , NVL(A.QTY, 0)                                                       AS QTY   /* -- 기존 INTRANSIT 무시하고 모두 0 */
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'                                          AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
               /* --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) */
               /* --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD */
             , GT_XGLB_MEASURE          M
         WHERE A.MEASURE              = M.COLUMN_NAME
           AND M.COLUMN_NAME         IN ('SHIP_PLAN', 'MKT_FCST')
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = P_PLAN_TYPE
           AND A.SEQ                  = V_SEQ
           AND A.YYYYMMDD            >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD            <= V_P_TO_YYYYMMDD   /* --말일포함 (KSK, 20240814) */
           AND A.MEASURE             IN ('SHIP_PLAN', 'MKT_FCST')
           /* -- 중복값 수정이 안되는 현상 발생하여 제거함 : KSK, 2023-07-10 */
           /* --AND PROJECT_CODE != '-' */
        ;

        /* IF @p_is_debug = 1 BEGIN SELECT '279' AS "#PSI_GLOBAL", * FROM #PSI_GLOBAL WHERE ... END
           → 디버그 조회 : Oracle 프로시저는 결과셋을 돌려주지 않으므로 생략(이하 디버그 SELECT 동일) */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- SHIP_PLAN (FG) (팩,셀 공통) - WH_IN */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.BIZ_TYPE
             , ''                                                                  AS CELL_ITEM_ID
             , A.ITEM_ID
             , (CASE WHEN RTRIM(A.TO_SITE) IS NULL THEN '-' ELSE A.TO_SITE END)    AS TO_SITE
             , A.PROJECT_CODE
             , 0                                                                   AS TO_BOH_QTY
             , 0                                                                   AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
               /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL((SELECT C.TRANSPORT_MODE
                      FROM SCP_MST_BOD_N_V C
                     WHERE 0 = 0
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND A.BOD_ID      = C.BOD_ID
                       AND A.FROM_SITE   = C.FROM_SITE
                       AND ROWNUM        = 1), '-')                                AS TRANSPORT_MODE
             , '-'                                                                 AS PROD_LINE
             , M.COLUMN_NAME                                                       AS MEASURE   /* -- SHIP_PLAN FG */
             , A.YYYYMMDD                                                          AS YYYYMMDD
             , NVL(A.QTY, 0)                                                       AS QTY   /* -- 기존 INTRANSIT 무시하고 모두 0 */
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'                                          AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
               /* --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) */
               /* --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD */
             , GT_XGLB_MEASURE          M
         WHERE M.COLUMN_NAME         IN ('WHIN')
           AND A.MEASURE              = 'WH_IN'   /* --(CASE WHEN M.COLUMN_NAME ='WHIN' THEN 'WH_IN' ELSE M.COLUMN_NAME END ) */
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = P_PLAN_TYPE
           AND A.SEQ                  = V_SEQ
           AND A.YYYYMMDD            >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD            <= V_P_TO_YYYYMMDD   /* --말일포함 (KSK, 20240814) */
           AND A.MEASURE             IN ('WH_IN')
        ;



        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- PACK_PROD, CELL_PROD (SCP_ANL_PRODUCTION_PLAN) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , ''                          AS CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                         AS TO_SITE
             , '-'                         AS PROJECT_CODE
             , 0                           AS TO_BOH_QTY
             , 0                           AS FROM_BOH_QTY
             , '-'                         AS INCOTERMS
             , A.SCM_SITE_ID               AS FROM_SITE
             , '-'                         AS TRANSPORT_MODE
             , A.LINE_ID                   AS PROD_LINE
             , M.COLUMN_NAME               AS MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)                  AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                         AS BOD_ID
             , 'SCP_ANL_PRODUCTION_PLAN'   AS ATTRIBUTE1
             , A.OPERATION_ID              AS ATTRIBUTE9
          FROM SCP_ANL_PRODUCTION_PLAN A
               /* --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) */
               /* --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD */
             , GT_XGLB_MEASURE         M
         WHERE (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                     WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                     ELSE '-'
                 END)                  = M.COLUMN_NAME
           AND M.COLUMN_NAME          IN ('PACK_PROD', 'CELL_PROD')
           AND A.DIVISION_ID           = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD   = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE             = P_PLAN_TYPE
           AND A.SEQ                   = V_SEQ
           AND A.LINE_ID              <> '-'
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.ITEM_ID
                , A.SCM_SITE_ID
                , A.LINE_ID
                , M.COLUMN_NAME
                , A.YYYYMMDD
                , M.SORT_ORDER_NO
                , M.COLUMN_LABEL_NAME
                , A.OPERATION_ID
        ;



        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) */
        /* -- PACK_PROD, CELL_PROD - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가 */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LINE_ASSIGN') IS NOT NULL DROP TABLE #LINE_ASSIGN → GTT 초기화
           IF OBJECT_ID('tempdb..#LINE_ASSIGN_ORG') IS NOT NULL DROP TABLE #LINE_ASSIGN_ORG
           SELECT DISTINCT ... INTO #LINE_ASSIGN_ORG ... → 쓰는 곳이 #LINE_ASSIGN 한 곳뿐이라 아래 인라인 뷰 A(두 갈래 같은 정의)로 옮김
             --AND AN.UPDATE_TIME >= convert(char(8), dateadd(D, -2, getdate()), 112)	-- 2022.11.03 주석해제 :: 불필요 생산계획 생성방지에 따른 최신 PRIORITY 값이 반영되지 않는 현상 개선
             AN.MONTH >= LEFT(convert(char(8), getdate(), 112), 6)		-- 2021.08.10 capa. 적용기준 변경
             NOT AN.PRIORITY IN (9, 8)	-- 2022.10.25 미적용기준을 변경  (PRIORITY 는 문자 칸 : MSSQL 은 숫자로 바꿔 비교 → TO_NUMBER) */
		/* 활성화 상태 블록 - 배포보류
			SELECT DISTINCT
						TM.DIVISION_ID
					, TM.PLANT_ID AS FROM_SITE_ID
					, TM.LINE_ID
					, TM.ITEM_ID
					, TM.OPERATION_ID
					, TM.COMPANY_ID
					, TM.SITE_ID
					, TM.FACTORY_ID
					, TM.ELECTRODE_TYPE
				INTO #LINE_ASSIGN_ORG
				FROM  SCM_MST_ITEM_LINE_ASSIGN_SN AN WITH (NOLOCK)
				INNER JOIN SCM_MST_TACT_TIME_SN TM WITH (NOLOCK) 
					ON  TM.DIVISION_ID		= AN.DIVISION_ID
					AND TM.COMPANY_ID		= AN.COMPANY_ID
					AND TM.SITE_ID			= AN.SITE_ID
					AND TM.PLANT_ID			= AN.PLANT_ID
					AND TM.FACTORY_ID		= AN.FACTORY_ID
					AND TM.OPERATION_ID		= AN.OPERATION_ID
					AND TM.LINE_ID			= AN.LINE_ID
					AND TM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
					AND TM.ITEM_ID			= AN.ITEM_ID
			  INNER JOIN SCM_LINE_M_SN LM WITH (NOLOCK) 
					ON  LM.DIVISION_ID		= AN.DIVISION_ID
					AND LM.COMPANY_ID		= AN.COMPANY_ID
					AND LM.SITE_ID			= AN.SITE_ID
					AND LM.PLANT_ID			= AN.PLANT_ID
					AND LM.FACTORY_ID		= AN.FACTORY_ID
					AND LM.OPERATION_ID		= AN.OPERATION_ID
					AND LM.LINE_ID			= AN.LINE_ID
					AND LM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
				WHERE 1 = 1 
				--AND AN.UPDATE_TIME >= convert(char(8), dateadd(D, -2, getdate()), 112)	-- 2022.11.03 주석해제 :: 불필요 생산계획 생성방지에 따른 최신 PRIORITY 값이 반영되지 않는 현상 개선
				AND AN.DIVISION_ID       = @p_division_id				
				AND TM.DAILY_CAPA       > 0.0
				AND AN.MONTH            >= LEFT(convert(char(8), getdate(), 112), 6)		-- 2021.08.10 capa. 적용기준 변경
				AND NOT AN.PRIORITY     IN (9, 8)	-- 2022.10.25 미적용기준을 변경
				AND LM.ACTIVE_FLAG = 'Y'  --'2024.07.04 활성화 상태 체크 (KSK)
				; */

        /* ------------------------- */
        /* -- 출하/생산계획 추가대상 건 확인 */
        /* ------------------------- */
        DELETE
          FROM GT_XGLB_LINE_ASSIGN;

        INSERT
          INTO GT_XGLB_LINE_ASSIGN
             ( DIVISION_ID
             , PLANT_ID
             , ITEM_ID
             , LINE_ID
             , MODEL_ID
             , CHILD_ITEM_ID
             , OPERATION_ID
             , OPERATION_GROUP_ID
             , COMPANY_ID
             , SITE_ID
             , FACTORY_ID
             , ELECTRODE_TYPE
             , ITEM_TYPE
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.PLANT_ID
             , X.ITEM_ID
             , X.LINE_ID
             , X.MODEL_ID
             , X.CHILD_ITEM_ID
             , X.OPERATION_ID
             , X.OPERATION_GROUP_ID
             , X.COMPANY_ID
             , X.SITE_ID
             , X.FACTORY_ID
             , X.ELECTRODE_TYPE
             , (CASE WHEN X.ITEM_ID = X.CHILD_ITEM_ID THEN 'R' ELSE 'S' END) AS ITEM_TYPE
          FROM (SELECT V1.DIVISION_ID
                     , V1.PLANT_ID
                     , A.ITEM_ID
                     , A.LINE_ID
                     , V1.MODEL_ID
                     , V1.CHILD_ITEM_ID
                     , A.OPERATION_ID
                     , V1.OPERATION_GROUP_ID
                     , A.COMPANY_ID
                     , A.SITE_ID
                     , A.FACTORY_ID
                     , A.ELECTRODE_TYPE
                  FROM (SELECT DISTINCT
                              TM.DIVISION_ID
                            , TM.PLANT_ID       AS FROM_SITE_ID
                            , TM.LINE_ID
                            , TM.ITEM_ID
                            , TM.OPERATION_ID
                            , TM.COMPANY_ID
                            , TM.SITE_ID
                            , TM.FACTORY_ID
                            , TM.ELECTRODE_TYPE
                         FROM SCM_MST_ITEM_LINE_ASSIGN_SN AN
                            , SCM_MST_TACT_TIME_SN        TM
                        WHERE 1 = 1
                          AND TM.DIVISION_ID    = AN.DIVISION_ID
                          AND TM.COMPANY_ID     = AN.COMPANY_ID
                          AND TM.SITE_ID        = AN.SITE_ID
                          AND TM.PLANT_ID       = AN.PLANT_ID
                          AND TM.FACTORY_ID     = AN.FACTORY_ID
                          AND TM.OPERATION_ID   = AN.OPERATION_ID
                          AND TM.LINE_ID        = AN.LINE_ID
                          AND TM.ELECTRODE_TYPE = AN.ELECTRODE_TYPE
                          AND TM.ITEM_ID        = AN.ITEM_ID
                          AND TM.DAILY_CAPA     > 0.0
                          AND NOT TO_NUMBER(AN.PRIORITY) IN (9, 8)   /* -- 2022.10.25 미적용기준을 변경 */
                          AND AN.DIVISION_ID    = V_DIVISION_ID
                          AND AN.MONTH         >= TO_CHAR(SYSDATE, 'YYYYMM')   /* -- 2021.08.10 capa. 적용기준 변경 */
                       )   /* #LINE_ASSIGN_ORG */                A
                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V    V1   /* -- PACK 기준으로 종속된 CELL 까지 */
                 WHERE V1.DIVISION_ID         = A.DIVISION_ID
                   AND V1.PLANT_ID            = A.FROM_SITE_ID
                   AND V1.MODEL_ID            = A.ITEM_ID
                   AND V1.OPERATION_GROUP_ID <> 'E'
                 UNION ALL
                SELECT V2.DIVISION_ID
                     , V2.PLANT_ID
                     , A.ITEM_ID
                     , A.LINE_ID
                     , V2.MODEL_ID
                     , V2.CHILD_ITEM_ID
                     , A.OPERATION_ID
                     , V2.OPERATION_GROUP_ID
                     , A.COMPANY_ID
                     , A.SITE_ID
                     , A.FACTORY_ID
                     , A.ELECTRODE_TYPE
                  FROM (SELECT DISTINCT
                              TM.DIVISION_ID
                            , TM.PLANT_ID       AS FROM_SITE_ID
                            , TM.LINE_ID
                            , TM.ITEM_ID
                            , TM.OPERATION_ID
                            , TM.COMPANY_ID
                            , TM.SITE_ID
                            , TM.FACTORY_ID
                            , TM.ELECTRODE_TYPE
                         FROM SCM_MST_ITEM_LINE_ASSIGN_SN AN
                            , SCM_MST_TACT_TIME_SN        TM
                        WHERE 1 = 1
                          AND TM.DIVISION_ID    = AN.DIVISION_ID
                          AND TM.COMPANY_ID     = AN.COMPANY_ID
                          AND TM.SITE_ID        = AN.SITE_ID
                          AND TM.PLANT_ID       = AN.PLANT_ID
                          AND TM.FACTORY_ID     = AN.FACTORY_ID
                          AND TM.OPERATION_ID   = AN.OPERATION_ID
                          AND TM.LINE_ID        = AN.LINE_ID
                          AND TM.ELECTRODE_TYPE = AN.ELECTRODE_TYPE
                          AND TM.ITEM_ID        = AN.ITEM_ID
                          AND TM.DAILY_CAPA     > 0.0
                          AND NOT TO_NUMBER(AN.PRIORITY) IN (9, 8)   /* -- 2022.10.25 미적용기준을 변경 */
                          AND AN.DIVISION_ID    = V_DIVISION_ID
                          AND AN.MONTH         >= TO_CHAR(SYSDATE, 'YYYYMM')   /* -- 2021.08.10 capa. 적용기준 변경 */
                       )   /* #LINE_ASSIGN_ORG */                A
                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V    V2   /* -- CELL 단독 */
                 WHERE V2.DIVISION_ID        = A.DIVISION_ID
                   AND V2.PLANT_ID           = A.FROM_SITE_ID
                   AND V2.MODEL_ID           = A.ITEM_ID
                   AND V2.CHILD_ITEM_ID      = A.ITEM_ID
                   AND V2.OPERATION_GROUP_ID = 'A'
               )                  X
             , SCP_MST_FINAL_ITEM Z
         WHERE 1 = 1
           AND X.DIVISION_ID        = Z.DIVISION_ID
           AND X.ITEM_ID            = Z.ITEM_ID
           AND X.OPERATION_GROUP_ID = Z.OPERATION_GROUP
           AND X.OPERATION_ID       = Z.FLOW_ID
           AND Z.DIVISION_ID        = V_DIVISION_ID
           AND Z.FCST_YN            = 'Y'
        ;

        /* ----------- */
        /* -- 출하계획 */
        /* ----------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.BIZ_TYPE
             , ''                                                                  AS CELL_ITEM_ID
             , A.ITEM_ID
             , (CASE WHEN RTRIM(A.TO_SITE) IS NULL THEN '-' ELSE A.TO_SITE END)    AS TO_SITE
             , A.PROJECT_CODE
             , 0                                                                   AS TO_BOH_QTY
             , 0                                                                   AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
               /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL((SELECT C.TRANSPORT_MODE
                      FROM SCP_MST_BOD_N_V C
                     WHERE 0 = 0
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND A.BOD_ID      = C.BOD_ID
                       AND A.FROM_SITE   = C.FROM_SITE
                       AND ROWNUM        = 1), '-')                                AS TRANSPORT_MODE
             , '-'                                                                 AS PROD_LINE
             , A.MEASURE                                                           /* -- SHIP_PLAN FG */
             , A.YYYYMMDD                                                          AS YYYYMMDD
             , NVL(A.QTY, 0)                                                       AS QTY   /* -- 기존 INTRANSIT 무시하고 모두 0 */
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'                                          AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       P.DIVISION_ID
                     , LN.CHILD_ITEM_ID       AS ITEM_ID
                     , Y.SH_FG                AS BIZ_TYPE
                     , P.PROJECT_CODE
                     , P.SALES_SITE_ID        AS TO_SITE
                     , P.PLANT_SITE_ID        AS FROM_SITE
                     , V_PLAN_START_YYYYMMDD  AS YYYYMMDD
                     , B.INCOTERMS
                     , B.BOD_ID
                     , 'SHIP_PLAN'            AS MEASURE
                     , 0                      AS QTY
                     , NULL                   AS ATTRIBUTE9
                  FROM SCM_MST_SITE_ITEM_PRIORITY P
                     , GT_XGLB_LINE_ASSIGN        LN
                     , (SELECT DISTINCT
                               ITEM_ID
                             , MEASURE
                             , BIZ_TYPE AS SH_FG
                             , INCOTERMS
                             , TO_SITE
                          FROM SCP_ANL_SHIPMENT_PLAN_FG   /* -- MKT_FCST 존재할 경우만 */
                         WHERE DIVISION_ID         = V_DIVISION_ID
                           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                           AND PLAN_TYPE           = P_PLAN_TYPE
                           AND SEQ                 = V_SEQ
                           AND MEASURE             = 'MKT_FCST'
                       )                          Y
                     , SCP_MST_BOD_N_V            B   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                 WHERE P.DIVISION_ID                 = LN.DIVISION_ID
                   AND P.ITEM_ID                     = LN.CHILD_ITEM_ID
                   AND SUBSTR(P.PLANT_SITE_ID, 1, 4) = LN.PLANT_ID
                   AND Y.ITEM_ID                     = P.ITEM_ID
                   AND Y.SH_FG                       = LN.OPERATION_GROUP_ID   /* -- */
                   AND B.DIVISION_ID                 = LN.DIVISION_ID
                   AND B.FROM_SITE                   = P.PLANT_SITE_ID
                   AND B.TO_SITE                     = P.SALES_SITE_ID
                   AND B.INCOTERMS                   = Y.INCOTERMS
                   AND B.TO_SITE                     = Y.TO_SITE
                   AND NOT EXISTS (SELECT 1
                                     FROM SCP_ANL_SHIPMENT_PLAN_FG SA   /* -- 출하계획 존재시 제외 */
                                    WHERE SA.DIVISION_ID         = V_DIVISION_ID
                                      AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND SA.PLAN_TYPE           = P_PLAN_TYPE
                                      AND SA.SEQ                 = V_SEQ
                                      AND SA.FROM_SITE           = P.PLANT_SITE_ID
                                      AND SA.ITEM_ID             = LN.CHILD_ITEM_ID
                                      AND SA.BOD_ID              = B.BOD_ID
                                      AND SA.MEASURE             = 'SHIP_PLAN'
                                      /* -- 중복값 수정이 안되는 현상 발생하여 제거함 : KSK, 2023-07-10 */
                                      /* -- AND PROJECT_CODE != '-' */
                                  )
                   /* -- CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - SCM_MST_SITE_ITEM_PRIORITY From/To YYYYMMDD 조건변경 - start */
                   /* -- 변경전 */
                   /* --AND P.FROM_YYYYMMDD <= @p_plan_start_yyyymmdd */
                   /* --AND P.TO_YYYYMMDD   >= @p_plan_start_yyyymmdd */
                   /* -- */
                   /* -- 변경후 */
                   AND P.FROM_YYYYMMDD              <= V_P_TO_YYYYMMDD
                   /* -- CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - SCM_MST_SITE_ITEM_PRIORITY From/To YYYYMMDD 조건변경 - end */
                   /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - PRIORITY --> VALID_YN 으로 교체 */
                   /* --AND P.PRIORITY     = '1' */
                   AND P.VALID_YN                    = 'Y'
                   /* --AND Y.MEASURE = 'MKT_FCST'		--IN ('MKT_FCST', 'SHIP_REQ') */
                   AND B.BOD_TYPE                    = 'SALES'
                   AND B.BOD_VALID_YN                = 'Y'
               ) A
             , (SELECT M.COLUMN_NAME
                     , M.COLUMN_LABEL_NAME
                     , M.SORT_ORDER_NO
                     , (CASE WHEN M.ATTRIBUTE1 = 'PACK' THEN 'P' WHEN M.ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END) AS DIV
                     , M.ATTRIBUTE2 AS GUBUN
                       /* --INTO #MEASURE */
                  FROM SCM_MST_SHEET_MEASURE M
                 WHERE M.PROGRAM_ID = V_P_PROGRAM_ID
                   AND M.VALID_YN   = 'Y'
               ) M
         WHERE A.MEASURE      = M.COLUMN_NAME
           AND M.COLUMN_NAME IN ('SHIP_PLAN', 'MKT_FCST')
        ;

        /* IF @p_is_debug = 1 SELECT '560' AS "#PSI_GLOBAL", * FROM #PSI_GLOBAL WHERE ... → 디버그 조회 생략 */

        /* ----------- */
        /* -- 생산계획 */
        /* ----------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , SUBSTR(X.OPERATION_ID, 1, 1)  AS OPERATION_GROUP_ID
             , ''                            AS CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                           AS TO_SITE
             , '-'                           AS PROJECT_CODE
             , 0                             AS TO_BOH_QTY
             , 0                             AS FROM_BOH_QTY
             , '-'                           AS INCOTERMS
             , X.SCM_SITE_ID                 AS FROM_SITE
             , '-'                           AS TRANSPORT_MODE
             , X.LINE_ID                     AS PROD_LINE
             , M.COLUMN_NAME                 AS MEASURE
             , X.YYYYMMDD
             , 0                             AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                           AS BOD_ID
             , 'SCP_ANL_PRODUCTION_PLAN'     AS ATTRIBUTE1
             , X.OPERATION_ID                AS ATTRIBUTE9
          FROM (SELECT DISTINCT   /* -- LINE ASSIGN + DAILY CAPA + PACK 에 대한 CELL ITEM */
                       X.DIVISION_ID
                     , S.SCM_SITE_ID
                     , X.ITEM_ID
                     , X.LINE_ID
                       /* --, X.MODEL_ID */
                       /* --, X.CHILD_ITEM_ID */
                     , X.OPERATION_ID
                     , V_PLAN_START_YYYYMMDD AS YYYYMMDD
                  FROM (SELECT DISTINCT
                               TM.DIVISION_ID
                             , TM.PLANT_ID
                             , TM.LINE_ID
                             , TM.ITEM_ID
                             , TM.OPERATION_ID
                             , AN.OPERATION_GROUP_ID
                          FROM GT_XGLB_LINE_ASSIGN  AN
                             , SCM_MST_TACT_TIME_SN TM
                         WHERE TM.DIVISION_ID    = AN.DIVISION_ID
                           AND TM.COMPANY_ID     = AN.COMPANY_ID
                           AND TM.SITE_ID        = AN.SITE_ID
                           AND TM.PLANT_ID       = AN.PLANT_ID
                           AND TM.FACTORY_ID     = AN.FACTORY_ID
                           AND TM.OPERATION_ID   = AN.OPERATION_ID
                           AND TM.LINE_ID        = AN.LINE_ID
                           AND TM.ELECTRODE_TYPE = AN.ELECTRODE_TYPE
                           AND TM.ITEM_ID        = AN.ITEM_ID
                           AND AN.ITEM_TYPE      = 'R'
                         UNION ALL
                        SELECT DISTINCT
                               TM.DIVISION_ID
                             , TM.PLANT_ID
                             , TM.LINE_ID
                             , TM.ITEM_ID
                             , TM.OPERATION_ID
                             , AN.OPERATION_GROUP_ID
                          FROM GT_XGLB_LINE_ASSIGN  AN
                             , SCM_MST_TACT_TIME_SN TM
                         WHERE TM.DIVISION_ID    = AN.DIVISION_ID
                           AND TM.COMPANY_ID     = AN.COMPANY_ID
                           AND TM.SITE_ID        = AN.SITE_ID
                           AND TM.PLANT_ID       = AN.PLANT_ID
                           AND TM.FACTORY_ID     = AN.FACTORY_ID
                           AND TM.OPERATION_ID   = AN.OPERATION_ID
                           AND TM.LINE_ID        = AN.LINE_ID
                           AND TM.ELECTRODE_TYPE = AN.ELECTRODE_TYPE
                           AND TM.ITEM_ID        = AN.CHILD_ITEM_ID
                           AND AN.ITEM_TYPE      = 'S'
                           AND SUBSTR(TM.OPERATION_ID, 1, 1) = 'A'
                       ) X
/* AS-IS 주석 원문 (L656~L673)
							 --  (SELECT DISTINCT
								--	   ITEM_ID, MEASURE, BIZ_TYPE AS SH_FG
								--  FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)	-- MKT_FCST 존재할 경우만
								-- WHERE DIVISION_ID         = @p_division_id
								--   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								--   AND PLAN_TYPE           = @p_plan_type
								--   AND SEQ                 = @p_seq
								--   AND MEASURE             = 'MKT_FCST'
								-- UNION ALL
								--SELECT DISTINCT
								--	   ITEM_ID, MEASURE, 'A' AS SH_FG
								--  FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
								-- WHERE DIVISION_ID         = @p_division_id
								--   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								--   AND PLAN_TYPE           = @p_plan_type
								--   AND SEQ                 = @p_seq
								--   AND MEASURE             IN ( 'MKT_FCST', 'SHIP_REQ' )
							 --  ) Y,
*/
                     , (SELECT DIVISION_ID
                             , SCM_SITE_ID
                             , SITE_DESCRIPTION
                             , OPERATION_GROUP
                          FROM SCM_MST_SITE
                         WHERE DIVISION_ID = V_DIVISION_ID
                       ) S
                 WHERE 1 = 1
                   /* --AND Y.ITEM_ID = X.ITEM_ID */
                   /* --AND Y.MEASURE = 'MKT_FCST'			--= (CASE WHEN LEFT(X.OPERATION_ID, 1) = 'P' THEN 'MKT_FCST' ELSE 'SHIP_REQ' END) */
                   /* --AND Y.SH_FG   = LEFT(X.OPERATION_ID, 1) */
                   AND S.OPERATION_GROUP             = X.OPERATION_GROUP_ID
                   AND SUBSTR(S.SCM_SITE_ID, 1, 4)   = X.PLANT_ID
                   AND NOT EXISTS (SELECT 1
                                     FROM SCP_ANL_PRODUCTION_PLAN SA   /* -- 생산계획 존재시 제외 */
                                    WHERE SA.DIVISION_ID         = V_DIVISION_ID
                                      AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND SA.PLAN_TYPE           = P_PLAN_TYPE
                                      AND SA.SEQ                 = V_SEQ
                                      AND SA.SCM_SITE_ID         = S.SCM_SITE_ID
                                      AND SA.ITEM_ID             = X.ITEM_ID
                                      AND SA.LINE_ID             = X.LINE_ID
                                      AND SA.MEASURE             = 'PROD_PLAN_AMEND')
               ) X
               /* --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) */
               /* --   ON X.YYYYMMDD           = C.BASIS_YYYYMMDD */
             , (SELECT M.COLUMN_NAME
                     , M.COLUMN_LABEL_NAME
                     , M.SORT_ORDER_NO
                     , (CASE WHEN M.ATTRIBUTE1 = 'PACK' THEN 'P' WHEN M.ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END) AS DIV
                     , M.ATTRIBUTE2 AS GUBUN
                       /* --INTO #MEASURE */
                  FROM SCM_MST_SHEET_MEASURE M
                 WHERE M.PROGRAM_ID = V_P_PROGRAM_ID
                   AND M.VALID_YN   = 'Y'
               ) M
         WHERE (CASE WHEN SUBSTR(X.OPERATION_ID, 1, 1) = 'P' THEN 'PACK_PROD'
                     WHEN SUBSTR(X.OPERATION_ID, 1, 1) = 'A' THEN 'CELL_PROD'
                     ELSE '-'
                 END)            = M.COLUMN_NAME
           AND M.COLUMN_NAME    IN ('PACK_PROD', 'CELL_PROD')
        ;

        /* ----------- */
        /* -- SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN */
        /* ----------- */
        /* AS-IS V.electrode_type = '' : Oracle 은 빈 문자가 NULL → IS NULL */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , ''                                                                  AS CELL_ITEM_ID
             , A.ITEM_ID
             , (CASE WHEN RTRIM(A.TO_SITE) IS NULL THEN '-' ELSE A.TO_SITE END)    AS TO_SITE
             , '-'                                                                 AS PROJECT_CODE
             , 0                                                                   AS TO_BOH_QTY
             , 0                                                                   AS FROM_BOH_QTY
             , '-'                                                                 AS INCOTERMS
             , A.FROM_SITE
               /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL((SELECT C.TRANSPORT_MODE
                      FROM SCP_MST_BOD_N_V C
                     WHERE 0 = 0
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND A.BOD_ID      = C.BOD_ID
                       AND A.FROM_SITE   = C.FROM_SITE
                       AND ROWNUM        = 1), '-')                                AS TRANSPORT_MODE
             , '-'                                                                 AS PROD_LINE
             , M.COLUMN_NAME                                                       AS MEASURE
             , A.YYYYMMDD                                                          AS YYYYMMDD
             , NVL(A.QTY, 0)                                                       AS QTY   /* -- 기존 INTRANSIT 무시하고 모두 0 */
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_SEMI'                                        AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM (SELECT LN.DIVISION_ID
                     , LN.CHILD_ITEM_ID       AS ITEM_ID
                     , B.FROM_SITE
                     , B.TO_SITE
                     , B.BOD_ID
                     , V_PLAN_START_YYYYMMDD  AS YYYYMMDD
                     , 'SEMI_SHIP_PLAN'       AS MEASURE
                     , LN.OPERATION_GROUP_ID  AS OPERATION_GROUP
                     , 0                      AS QTY
                     , NULL                   AS ATTRIBUTE9
                  FROM GT_XGLB_LINE_ASSIGN LN
                     , SCP_MST_BOD_N_V     B   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                 WHERE B.DIVISION_ID             = LN.DIVISION_ID
                   AND SUBSTR(B.FROM_SITE, 1, 4) = LN.PLANT_ID
                   AND B.TO_SITE                 = (SELECT DISTINCT LN.PLANT_ID || '-P'
                                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
                                                     WHERE V.MODEL_ID           = LN.CHILD_ITEM_ID
                                                       AND V.PLANT_ID           = LN.PLANT_ID
                                                       AND V.OPERATION_GROUP_ID = 'A'
                                                       AND V.ELECTRODE_TYPE    IS NULL)
                   AND NOT EXISTS (SELECT 1
                                     FROM SCP_ANL_SHIPMENT_PLAN_SEMI SA   /* -- SEMI 출하계획 존재시 제외 */
                                    WHERE SA.DIVISION_ID         = V_DIVISION_ID
                                      AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND SA.PLAN_TYPE           = P_PLAN_TYPE
                                      AND SA.SEQ                 = V_SEQ
                                      AND SA.FROM_SITE           = B.TO_SITE
                                      AND SA.ITEM_ID             = LN.CHILD_ITEM_ID
                                      AND SA.BOD_ID              = B.BOD_ID
                                      AND SA.MEASURE             = 'SHIP_PLAN')
                   AND LN.OPERATION_GROUP_ID     = 'A'
                   AND B.BOD_TYPE                = 'PLANT'
                   AND B.BOD_VALID_YN            = 'Y'
               ) A
             , (SELECT M.COLUMN_NAME
                     , M.COLUMN_LABEL_NAME
                     , M.SORT_ORDER_NO
                     , (CASE WHEN M.ATTRIBUTE1 = 'PACK' THEN 'P' WHEN M.ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END) AS DIV
                     , M.ATTRIBUTE2 AS GUBUN
                       /* --INTO #MEASURE */
                  FROM SCM_MST_SHEET_MEASURE M
                 WHERE M.PROGRAM_ID = V_P_PROGRAM_ID
                   AND M.VALID_YN   = 'Y'
               ) M
         WHERE (CASE A.MEASURE WHEN 'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE END) = M.COLUMN_NAME
           AND A.ITEM_ID IN (SELECT DISTINCT SB.ITEM_ID
                               FROM SCP_ANL_SHIPMENT_PLAN_FG SB   /* -- 출하계획 존재시 제외 */
                              WHERE SB.DIVISION_ID         = V_DIVISION_ID
                                AND SB.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                AND SB.PLAN_TYPE           = P_PLAN_TYPE
                                AND SB.SEQ                 = V_SEQ
                                AND SB.FROM_SITE           = A.FROM_SITE
                                AND SB.ITEM_ID             = A.ITEM_ID
                                AND SB.BOD_ID              = A.BOD_ID
                                AND SB.MEASURE             = 'MKT_FCST')
           AND M.COLUMN_NAME IN ('SEMI_SHIP_PLAN')
        ;
        /* -- CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - end */

        /* IF OBJECT_ID('TEMPDB..#ANL_SHIPMENT_PLAN_FG') IS NOT NULL DROP TABLE #ANL_SHIPMENT_PLAN_FG
           SELECT * INTO #ANL_SHIPMENT_PLAN_FG FROM #PSI_GLOBAL WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'
           IF OBJECT_ID('TEMPDB..#ANL_PRODUCTION_PLAN') IS NOT NULL DROP TABLE #ANL_PRODUCTION_PLAN
           SELECT * INTO #ANL_PRODUCTION_PLAN FROM #PSI_GLOBAL WHERE ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'
           → 이후 #PSI_GLOBAL 에는 ATTRIBUTE1 이 'SCP_ANL_SHIPMENT_PLAN_FG'·'SCP_ANL_PRODUCTION_PLAN' 인 행이 더 들어오지 않고
             수정·삭제도 없으므로, 쓰는 곳마다 GT_XGLB_PSI_GLOBAL 을 같은 조건으로 읽는다(복사본과 내용 동일) */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* AS-IS UNION 안의 '360' AS SORT_ORDER_NO(문자) 는 INT 칸으로 맞춰지므로 숫자 360 */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , X.MEASURE
             , X.YYYYMMDD
             , X.QTY
             , X.SORT_ORDER_NO
             , X.COLUMN_LABEL_NAME
             , MAX(X.BOD_ID)          AS BOD_ID   /* -- */
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM (SELECT A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , ''                                                                  AS CELL_ITEM_ID
                     , A.ITEM_ID
                     , (CASE WHEN RTRIM(A.TO_SITE) IS NULL THEN '-' ELSE A.TO_SITE END)    AS TO_SITE
                     , '-'                                                                 AS PROJECT_CODE
                     , 0                                                                   AS TO_BOH_QTY
                     , 0                                                                   AS FROM_BOH_QTY
                     , '-'                                                                 AS INCOTERMS
                     , A.FROM_SITE
                       /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                     , NVL((SELECT C.TRANSPORT_MODE
                              FROM SCP_MST_BOD_N_V C
                             WHERE 0 = 0
                               AND C.DIVISION_ID = A.DIVISION_ID
                               AND A.BOD_ID      = C.BOD_ID
                               AND A.FROM_SITE   = C.FROM_SITE
                               AND ROWNUM        = 1), '-')                                AS TRANSPORT_MODE
                     , '-'                                                                 AS PROD_LINE
                     , M.COLUMN_NAME                                                       AS MEASURE
                     , A.YYYYMMDD                                                          AS YYYYMMDD
                     , NVL(A.QTY, 0)                                                       AS QTY   /* -- 기존 INTRANSIT 무시하고 모두 0 */
                     , M.SORT_ORDER_NO
                     , M.COLUMN_LABEL_NAME
                     , A.BOD_ID
                     , 'SCP_ANL_SHIPMENT_PLAN_SEMI'                                        AS ATTRIBUTE1
                     , A.ATTRIBUTE9
                  FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                     , GT_XGLB_MEASURE            M
                 WHERE (CASE A.MEASURE WHEN 'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE END) = M.COLUMN_NAME
                   AND M.COLUMN_NAME         IN ('SEMI_SHIP_PLAN')
                   AND A.DIVISION_ID          = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE            = P_PLAN_TYPE
                   AND A.SEQ                  = V_SEQ
                   AND A.YYYYMMDD            >= V_PLAN_START_YYYYMMDD
                   AND A.YYYYMMDD            <= V_P_TO_YYYYMMDD   /* --말일포함 (KSK, 20240814) */
                   AND A.MEASURE             IN ('SHIP_PLAN')

                /* -- SEMI SEMI_SHIP_PLAN없이 해상재고만 있는 경우 누락되는 로직 수정 */
                 UNION
                SELECT DISTINCT
                       V_DIVISION_ID                                                                     AS DIVISION_ID
                     , C.OPERATION_GROUP
                     , ''                                                                                AS CELL_ITEM_ID
                     , A.ITEM_ID
                     , (SUBSTR(A.SITE_ID, 1, FN_CHARINDEX_REV(A.SITE_ID, '~', 0) - 1))                   AS TO_SITE
                     , '-'                                                                               AS PROJECT_CODE
                     , 0                                                                                 AS TO_BOH_QTY
                     , 0                                                                                 AS FROM_BOH_QTY
                     , '-'                                                                               AS INCOTERMS
                     , (SUBSTR(A.LOT_ID, FN_CHARINDEX_REV(A.LOT_ID, '::', 0) + 2, 100))                  AS FROM_SITE
                     , 'SEA'                                                                             AS TRANSPORT_MODE   /* -- 해상재고 강제로 'SEA' */
                     , '-'                                                                               AS PROD_LINE
                     , 'SEMI_SHIP_PLAN'                                                                  AS MEASURE
                     , V_PLAN_START_YYYYMMDD                                                             AS YYYYMMDD
                       /* --                                ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD */
                     , 0                                                                                 AS QTY
                     , 360                                                                               AS SORT_ORDER_NO
                     , 'Semi Ship Plan'                                                                  AS COLUMN_LABEL_NAME
                     , '-'                                                                               AS BOD_ID   /* -- */
                     , 'SCP_ANL_SHIPMENT_PLAN_SEMI'                                                      AS ATTRIBUTE1
                     , NULL                                                                              AS ATTRIBUTE9
                  FROM TH_ENG_STOCK_PLAN_SN A
                     , SCP_MST_FINAL_ITEM_V C
                 WHERE 0 = 0
                   AND A.ITEM_ID   = C.ITEM_ID
                   AND A.MASTER_ID = P_MASTER_ID
                   AND A.PLAN_ID   = P_ENGINE_PLAN_ID
                   AND A.DESCR     = 'INT'
                   /* --AND LEFT(A.SITE_ID, 6) = (SELECT TOP 1 S.SCM_SITE_ID FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.PLANT_ID = LEFT(A.SITE_ID, 6) AND S.PLANT_ID IS NOT NULL)		-- 2021.11.16 SEMI PACK 출하계획생성오류 수정 */
                   /* --AND A.ITEM_ID          = 'ACPN1034U-A1' */

                   /* -->>> KSW 2020.09.03 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완) start */
                   AND NOT A.ITEM_ID IN (SELECT SA.ITEM_ID
                                           FROM SCP_ANL_SHIPMENT_PLAN_SEMI SA
                                          WHERE SA.DIVISION_ID         = V_DIVISION_ID
                                            AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                            AND SA.PLAN_TYPE           = P_PLAN_TYPE
                                            AND SA.SEQ                 = V_SEQ
                                            AND SA.YYYYMMDD           >= V_PLAN_START_YYYYMMDD
                                            AND SA.YYYYMMDD           <= V_P_TO_YYYYMMDD   /* --말일포함 (KSK, 20240814) */
                                            AND SA.MEASURE            IN ('SHIP_PLAN'))
                   /* -->>> KSW 2020.09.03 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완) end */
               ) X
         GROUP BY X.DIVISION_ID
                , X.OPERATION_GROUP
                , X.CELL_ITEM_ID
                , X.ITEM_ID
                , X.TO_SITE
                , X.PROJECT_CODE
                , X.TO_BOH_QTY
                , X.FROM_BOH_QTY
                , X.INCOTERMS
                , X.FROM_SITE
                , X.TRANSPORT_MODE
                , X.PROD_LINE
                , X.MEASURE
                , X.YYYYMMDD
                , X.QTY
                , X.SORT_ORDER_NO
                , X.COLUMN_LABEL_NAME
                , X.ATTRIBUTE1
                , X.ATTRIBUTE9
        ;

        /* SELECT * INTO #ANL_SHIPMENT_PLAN_SEMI FROM #PSI_GLOBAL WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           → 이후 해당 ATTRIBUTE1 행 추가·수정 없음 : 쓰는 곳마다 GT_XGLB_PSI_GLOBAL 을 같은 조건으로 읽는다 */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN)   ACTIVATE_COMPLETED --> CELL_CHAR_PLAN */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* AS-IS '440' AS SORT_ORDER_NO(문자) 는 INT 칸으로 맞춰지므로 숫자 440 / '' AS ATTRIBUTE1·ATTRIBUTE9 는 Oracle NULL */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , MAX(X.PROD_LINE)       AS PROD_LINE
             , X.MEASURE
             , X.YYYYMMDD
             , MAX(X.QTY)             AS QTY
             , X.SORT_ORDER_NO
             , X.COLUMN_LABEL_NAME
             , X.BOD_ID
             , MAX(X.ATTRIBUTE1)      AS ATTRIBUTE1
             , MAX(X.ATTRIBUTE9)      AS ATTRIBUTE9
          FROM (SELECT A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , ''                                  AS CELL_ITEM_ID
                     , A.ITEM_ID
                     , '-'                                 AS TO_SITE
                     , '-'                                 AS PROJECT_CODE
                     , 0                                   AS TO_BOH_QTY
                     , 0                                   AS FROM_BOH_QTY
                     , '-'                                 AS INCOTERMS
                     , A.SITE_ID                           AS FROM_SITE
                     , '-'                                 AS TRANSPORT_MODE
                     , '-'                                 AS PROD_LINE
                     , 'CELL_CHAR_PLAN'                    AS MEASURE   /* -- ACTIVATE_COMPLETED */
                     , TO_CHAR(A.END_TIME, 'YYYYMMDD')     AS YYYYMMDD
                     , SUM(NVL(A.COMPLETE_QTY, 0))         AS QTY
                     , M.SORT_ORDER_NO
                     , M.COLUMN_LABEL_NAME
                     , '-'                                 AS BOD_ID
                     , 'SCP_PLN_PRODUCTION_PLAN'           AS ATTRIBUTE1
                     , A.OPERATION_ID                      AS ATTRIBUTE9
                  FROM SCP_PLN_PRODUCTION_PLAN A
                     , GT_XGLB_MEASURE         M
                 WHERE 1 = 1
                   AND M.COLUMN_NAME          IN ('CELL_CHAR_PLAN')
                   AND A.DIVISION_ID           = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD   = V_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE             = P_PLAN_TYPE
                   AND A.SEQ                   = V_SEQ
                   AND A.OPERATION_ID          = 'F6000'
                 GROUP BY A.DIVISION_ID
                        , A.OPERATION_GROUP
                        , A.ITEM_ID
                        , A.SITE_ID
                        , TO_CHAR(A.END_TIME, 'YYYYMMDD')
                        , M.SORT_ORDER_NO
                        , M.COLUMN_LABEL_NAME
                        , A.OPERATION_ID

                 UNION
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , ''                                  AS CELL_ITEM_ID
                     , A.ITEM_ID
                     , '-'                                 AS TO_SITE
                     , '-'                                 AS PROJECT_CODE
                     , 0                                   AS TO_BOH_QTY
                     , 0                                   AS FROM_BOH_QTY
                     , '-'                                 AS INCOTERMS
                     , A.FROM_SITE
                     , '-'                                 AS TRANSPORT_MODE
                     , '-'                                 AS PROD_LINE
                     , 'CELL_CHAR_PLAN'                    AS MEASURE   /* -- ACTIVATE_COMPLETED */
                     , A.YYYYMMDD
                     , 0                                   AS QTY
                     , 440                                 AS SORT_ORDER_NO
                     , 'Char. Plan'                        AS COLUMN_LABEL_NAME
                     , '-'                                 AS BOD_ID
                     , ''                                  AS ATTRIBUTE1
                     , ''                                  AS ATTRIBUTE9
                  FROM GT_XGLB_PSI_GLOBAL A   /* #ANL_PRODUCTION_PLAN */
                 WHERE 0 = 0
                   AND A.ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'

                /* -- KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - Start */
                 UNION
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , ''                                  AS CELL_ITEM_ID
                     , A.ITEM_ID
                     , '-'                                 AS TO_SITE
                     , '-'                                 AS PROJECT_CODE
                     , 0                                   AS TO_BOH_QTY
                     , 0                                   AS FROM_BOH_QTY
                     , '-'                                 AS INCOTERMS
                     , A.FROM_SITE
                     , '-'                                 AS TRANSPORT_MODE
                     , '-'                                 AS PROD_LINE
                     , 'CELL_CHAR_PLAN'                    AS MEASURE   /* -- ACTIVATE_COMPLETED */
                     , A.YYYYMMDD
                     , 0                                   AS QTY
                     , 440                                 AS SORT_ORDER_NO
                     , 'Char. Plan'                        AS COLUMN_LABEL_NAME
                     , '-'                                 AS BOD_ID
                     , ''                                  AS ATTRIBUTE1
                     , ''                                  AS ATTRIBUTE9
                  FROM GT_XGLB_PSI_GLOBAL A   /* #ANL_SHIPMENT_PLAN_SEMI */
                 WHERE 0 = 0
                   AND A.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                /* -- KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - End */
               ) X
         GROUP BY X.DIVISION_ID
                , X.OPERATION_GROUP
                , X.CELL_ITEM_ID
                , X.ITEM_ID
                , X.TO_SITE
                , X.PROJECT_CODE
                , X.TO_BOH_QTY
                , X.FROM_BOH_QTY
                , X.INCOTERMS
                , X.FROM_SITE
                , X.TRANSPORT_MODE
                /* --                        , X.PROD_LINE */
                , X.MEASURE
                , X.YYYYMMDD
                /* --, MAX(X.QTY) AS QTY */
                , X.SORT_ORDER_NO
                , X.COLUMN_LABEL_NAME
                , X.BOD_ID
                /* --, X.ATTRIBUTE1 */
                /* --, X.ATTRIBUTE9 */
        ;

        /* SELECT * INTO #SCP_PLN_PRODUCTION_PLAN FROM #PSI_GLOBAL WHERE ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
           → 이후 #PSI_GLOBAL 추가·수정 없음 : 쓰는 곳에서 GT_XGLB_PSI_GLOBAL 을 같은 조건으로 읽는다 */



        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- 대상 ITEM_ID 추출 */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_XGLB_ITEM_ID;

        INSERT
          INTO GT_XGLB_ITEM_ID
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , MAX(TO_BOH_QTY)          AS TO_BOH_QTY
             , MAX(FROM_BOH_QTY)        AS FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , V_PLAN_START_YYYYMMDD    AS YYYYMMDD
             , MAX(QTY)                 AS QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , MAX(ATTRIBUTE1)          AS ATTRIBUTE1
             , MAX(ATTRIBUTE9)          AS ATTRIBUTE9
          FROM GT_XGLB_PSI_GLOBAL
         WHERE 0 = 0
         GROUP BY DIVISION_ID
                , OPERATION_GROUP
                , CELL_ITEM_ID
                , ITEM_ID
                , TO_SITE
                , PROJECT_CODE
                , INCOTERMS
                , FROM_SITE
                , TRANSPORT_MODE
                , PROD_LINE
                , MEASURE
                , SORT_ORDER_NO
                , COLUMN_LABEL_NAME
                , BOD_ID
                /* --,ATTRIBUTE1 */
                /* --,ATTRIBUTE9 */
        ;

        /* IF @p_is_debug = 1 SELECT '1119' AS #ITEM_ID, * FROM #ITEM_ID WHERE ... → 디버그 조회 생략 */


        /* IF OBJECT_ID('tempdb..#PSI_GLOBAL_AUTO') IS NOT NULL DROP TABLE #PSI_GLOBAL_AUTO; CREATE TABLE #PSI_GLOBAL_AUTO (...) → GTT 초기화
           칸 설명 원문 : PROJECT_CODE -- FG 때문에 추가 / TO_BOH_QTY --BIGINT / FROM_BOH_QTY -- BIGINT / ATTRIBUTE9 -- OPERATION_ID */
        DELETE
          FROM GT_XGLB_PSI_GLOBAL_AUTO;


        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* CROSS APPLY #MEASURE M : 상관 조건이 없는 곱 조인 */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS PROJECT_CODE
             , 0                       AS TO_BOH_QTY     /* AS-IS '0' → 숫자 칸 */
             , 0                       AS FROM_BOH_QTY   /* AS-IS '0' → 숫자 칸 */
             , '-'                     AS INCOTERMS
             , '-'                     AS FROM_SITE
             , '-'                     AS TRANSPORT_MODE
             , '-'                     AS PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                     AS BOD_ID
             , 'MKT_FCST_PACK_TOTAL'   AS ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV             = 'C'
           AND M.GUBUN           = 'ITEM_ID'
           AND X.MEASURE         = 'MKT_FCST'
           AND X.OPERATION_GROUP = 'P'
        ;

        /* IF @p_is_debug = 1 SELECT '1180' AS #PSI_GLOBAL_AUTO_1180, * FROM #PSI_GLOBAL_AUTO WHERE ... → 디버그 조회 생략 */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , '-'                     AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , X.BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV     = 'C'
           AND M.GUBUN   = 'TO'   /* --ALLOCATION/FCST_RTF_ACC/FCST_RTF_GAP/MKT_FCST/TO_SITE_BOH/TO_SITE_EOH/WHIN_BALANCE/WHIN_TOTAL */
           AND X.MEASURE = 'MKT_FCST'
        ;
        /* IF @p_is_debug = 1 SELECT '1212' AS #PSI_GLOBAL_AUTO_1212, * FROM #PSI_GLOBAL_AUTO WHERE ... → 디버그 조회 생략 */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN X.PROJECT_CODE ELSE '-' END)     AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN X.TRANSPORT_MODE ELSE '-' END)   AS TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME                                                                AS MEASURE
             , X.YYYYMMDD
             , 0                                                                            AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN X.BOD_ID ELSE '-' END)           AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV          = 'C'
           AND M.GUBUN        = 'FROM'   /* --INTRANSIT/INTRANSIT_ETA/SHIP_PLAN/SHIP_PLAN_ETA/SHIP_PLAN_PLANT/WHIN */
           AND M.COLUMN_NAME <> 'WHIN'   /* --KSK(250430, 멀티구간 BOD) */
           AND X.MEASURE     IN ('SHIP_PLAN')
        ;

        /* IF @p_is_debug = 1 SELECT '1247' AS #PSI_GLOBAL_AUTO_1246, * FROM #PSI_GLOBAL_AUTO WHERE ... --AND MEASURE = 'SHIP_PLAN' → 디버그 조회 생략 */

        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , '-'                     AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , '-'                     AS TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                     AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV         = 'C'
           AND M.GUBUN       = 'FROM'   /* --INTRANSIT/INTRANSIT_ETA/SHIP_PLAN/SHIP_PLAN_ETA/SHIP_PLAN_PLANT/WHIN */
           AND M.COLUMN_NAME = 'WHIN'
           AND X.MEASURE    IN ('WHIN')
        ;

        /* IF @p_is_debug = 1 SELECT '1278' AS #PSI_GLOBAL_AUTO_1246, * FROM #PSI_GLOBAL_AUTO WHERE ... → 디버그 조회 생략 */

        /* -- 2022.10.19   KSW			Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 - START */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , X.BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV         = 'C'
           AND M.GUBUN       = 'FROM'
           AND X.MEASURE     = 'SHIP_PLAN'
           AND M.COLUMN_NAME = 'SHIP_PLAN_MEMO'
        ;
        /* -- 2022.10.19   KSW			Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 - END */
        /* IF @p_is_debug = 1 SELECT '1312' AS #PSI_GLOBAL_AUTO, * FROM #PSI_GLOBAL_AUTO WHERE ... → 디버그 조회 생략 */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH') THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE
             , (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH', 'PACK_BOH_HOLD', 'PACK_BOH_WAIT_FOR_INSP', 'PACK_BOH_EXP_INSP_DATE') THEN '-' ELSE X.PROD_LINE END) AS PROD_LINE   /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 */
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH') THEN X.BOD_ID ELSE '-' END) AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV             = 'P'
           AND M.GUBUN           = 'FROM'
           AND X.MEASURE         = 'PACK_PROD'
           AND X.OPERATION_GROUP = 'P'
           /* -- 전진검사 MEASURE 는 대상 모델만 추가 */
           AND (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH_WAIT_FOR_INSP', 'PACK_BOH_EXP_INSP_DATE') THEN
                          (CASE WHEN NVL((SELECT DISTINCT C.ITEM_ID
                                            FROM SCP_MST_OPERATION_LT C
                                           WHERE C.DIVISION_ID  = '81'
                                             AND C.SCM_SITE_ID  = X.FROM_SITE
                                             AND C.ITEM_ID      = X.ITEM_ID
                                             AND C.LT_OPERATION = 'PRE_INSP'
                                             AND C.ATTRIBUTE1   = 'Y'
                                         ), 'N') = 'N' THEN 'N' ELSE 'Y'
                            END)
                     ELSE 'Y'
                 END) = 'Y'
        ;


            /*
            -------------------------------------------------------------------------------------------------------------------------        
            -- MEASURE 추가 : CELL_ITEM_ID별 (MKT_FCST_CELL_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , 'A' OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , '-' AS ITEM_ID
			                        , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
			                        , '0' AS TO_BOH_QTY										
			                        , '0' AS FROM_BOH_QTY									
			                        , '-' AS INCOTERMS 										
			                        , '-' AS FROM_SITE 										
                              , '-' AS TRANSPORT_MODE
                              , '-' AS PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , '-' AS BOD_ID						
                              , 'MKT_FCST_CELL_TOTAL' AS ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='C' 
                AND M.GUBUN       = 'CELL_ITEM_ID'
                AND X.MEASURE     = 'MKT_FCST'
            --    AND X.OPERATION_GROUP ='A'
            */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL) */
        /* -- MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , (CASE WHEN M.COLUMN_NAME IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_PLAN_MEMO') THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE   /* -- 2022.10.19   KSW			Memo measure 추가 :: IN 으로 변경하고 SEMI_SHIP_PLAN_MEMO 추가 */
             , X.PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , (CASE WHEN M.COLUMN_NAME IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_PLAN_MEMO') THEN X.BOD_ID ELSE '-' END) AS BOD_ID   /* -- 2022.10.19   KSW			Memo measure 추가 :: IN 으로 변경하고 SEMI_SHIP_PLAN_MEMO 추가 */
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV             = 'A'
           AND M.GUBUN           = 'FROM'
           AND M.COLUMN_NAME  LIKE 'SEMI%'
           AND X.MEASURE         = 'SEMI_SHIP_PLAN'
           AND X.OPERATION_GROUP = 'A'
        /* -- SEMI_WHIN_TOTAL */
         UNION ALL
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , '-'                     AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , '-'                     AS INCOTERMS
             , '-'                     AS FROM_SITE
             , '-'                     AS TRANSPORT_MODE
             , '-'                     AS PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                     AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV             = 'A'
           AND M.GUBUN           = 'TO'
           AND M.COLUMN_NAME  LIKE 'SEMI%'
           AND X.MEASURE         = 'SEMI_SHIP_PLAN'
           AND X.OPERATION_GROUP = 'A'
        ;

        /* IF @p_is_debug = 1 SELECT '1457' AS #PSI_GLOBAL_AUTO, * FROM #PSI_GLOBAL_AUTO WHERE ... → 디버그 조회 생략 */


        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN */
        /* --                                 ,CELL_CHAR_AVAILABLE,CELL_FORM_PROGRESS,CELL_FORM_HOLD,CELL_FOR_FORM_END,CELL_PROD_FORM_END */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , '-'                     AS INCOTERMS
             , X.FROM_SITE
             , '-'                     AS TRANSPORT_MODE
             , '-'                     AS PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                     AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV              = 'A'
           AND M.GUBUN            = 'FROM'
           AND M.COLUMN_NAME   LIKE 'CELL%'
           AND X.MEASURE          = 'CELL_CHAR_PLAN'
           AND X.OPERATION_GROUP  = 'A'
           AND M.COLUMN_NAME NOT IN ('CELL_PROD', 'CELL_PROD_LOAD', 'CELL_PROD_MEMO')   /* -- 2022.10.19   KSW			Memo measure 추가 */
        ;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 추가 : CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , '-'                     AS INCOTERMS
             , X.FROM_SITE
             , '-'                     AS TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                     AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XGLB_ITEM_ID X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND M.DIV             = 'A'
           AND M.GUBUN           = 'FROM'
           AND X.OPERATION_GROUP = 'A'
           AND M.COLUMN_NAME    IN ('CELL_PROD', 'CELL_PROD_LOAD', 'CELL_PROD_MEMO')   /* -- 2022.10.19   KSW			Memo measure 추가 */
           AND X.PROD_LINE      <> '-'
        ;



        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* -- MEASURE 0 추가 : */
        /* ------------------------------------------------------------------------------------------------------------------------- */
/* AS-IS 주석 원문 (L1547~L1577)
        --        INSERT #PSI_GLOBAL_AUTO
        --        SELECT  DIVISION_ID
        --               ,OPERATION_GROUP
        --               ,CELL_ITEM_ID
        --               ,ITEM_ID
        --               ,TO_SITE
        --               ,PROJECT_CODE
        --               ,TO_BOH_QTY
        --               ,FROM_BOH_QTY
        --               ,INCOTERMS
        --               ,FROM_SITE
        --               ,TRANSPORT_MODE
        --               ,PROD_LINE
        --               ,MEASURE
        --               , Y.YYYYMMDD
        --               ,'0' AS QTY
        --               ,SORT_ORDER_NO
        --               ,COLUMN_LABEL_NAME
        --               ,BOD_ID
        --               ,ATTRIBUTE1
        --               ,ATTRIBUTE9
        --         FROM #PSI_GLOBAL_AUTO X WITH (NOLOCK)
        --         CROSS APPLY
        --         (  -- 364 DAYS
        --               SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
        --                FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)
        --               WHERE 1=1
        --               --AND C.BASIS_YYYYMMDD > @p_plan_start_yyyymmdd       -- 엔진시작일 제외
        --               --AND C.BASIS_YYYYMMDD <  @p_to_yyyymmdd
					   --AND C.BASIS_YYYYMMDD IN ( @p_plan_start_yyyymmdd, CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112))
        --          ) Y
*/

        /* -- 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장 */
        /* IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_AUTO') IS NOT NULL DROP TABLE #tmp_PSI_GLOBAL_AUTO → GTT 초기화 */
        DELETE
          FROM GT_XGLB_TMP_PSI_GLOBAL_AUTO;

        /* -- 0 값을 플랜시작일자만 추가한다. - 모든 item 의 모든 measure */
        /* AS-IS '0' AS QTY(문자) → #PSI_GLOBAL_AUTO 숫자 칸으로 다시 적재되므로 숫자 0 */
        INSERT
          INTO GT_XGLB_TMP_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , X.MEASURE
             , Y.YYYYMMDD
             , 0                     AS QTY
             , X.SORT_ORDER_NO
             , X.COLUMN_LABEL_NAME
             , X.BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       DIVISION_ID
                     , OPERATION_GROUP
                     , CELL_ITEM_ID
                     , ITEM_ID
                     , TO_SITE
                     , PROJECT_CODE
                     , TO_BOH_QTY
                     , FROM_BOH_QTY
                     , INCOTERMS
                     , FROM_SITE
                     , TRANSPORT_MODE
                     , PROD_LINE
                     , MEASURE
                     , SORT_ORDER_NO
                     , COLUMN_LABEL_NAME
                     , BOD_ID
                     , ATTRIBUTE1
                     , ATTRIBUTE9
                  FROM GT_XGLB_PSI_GLOBAL_AUTO
               ) X
             , (  /* -- 364 DAYS */
                SELECT DISTINCT XA.YYYYMMDD
                  FROM (  /* --SELECT YYYYMMDD */
                          /* --FROM #PSI_GLOBAL    C WITH(NOLOCK) */
                          /* --UNION ALL */
                        SELECT V_PLAN_START_YYYYMMDD AS YYYYMMDD
                          FROM DUAL
                         UNION ALL
                        SELECT TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD') AS YYYYMMDD
                          FROM DUAL
                       ) XA
               ) Y   /* CROSS APPLY : 상관 조건 없음 = 곱 조인 */
         WHERE 0 = 0
        ;

        /* BEGIN */
        /* -- 0 값(플랜시작일자만)이 추가된 작업용 테이블의 DATA 를 #PSI_GLOBAL_AUTO 으로 복제 */
        DELETE
          FROM GT_XGLB_PSI_GLOBAL_AUTO;

        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
          FROM GT_XGLB_TMP_PSI_GLOBAL_AUTO X
        ;
        /* END */

        /* IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_AUTO') IS NOT NULL DROP TABLE #tmp_PSI_GLOBAL_AUTO; → GTT 비우기 */
        DELETE
          FROM GT_XGLB_TMP_PSI_GLOBAL_AUTO;





/* AS-IS 주석 원문 (L1656~L1674)
                 -- MKT_FCST
--                UPDATE X
--                SET X.QTY = Y.QTY
--                FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
--                INNER JOIN
--                (SELECT ITEM_ID, TO_SITE, MEASURE, INCOTERMS, YYYYMMDD, SUM(QTY) AS QTY
--                  FROM #ANL_SHIPMENT_PLAN_FG   WITH (NOLOCK)
--                  GROUP BY ITEM_ID,TO_SITE, MEASURE, INCOTERMS,YYYYMMDD
--                 ) Y
--                ON 0 = 0
--                AND X.TO_SITE         = Y.TO_SITE
----                AND X.FROM_SITE       = Y.FROM_SITE
--                AND X.MEASURE         = Y.MEASURE
--                AND X.ITEM_ID         = Y.ITEM_ID
--                AND X.YYYYMMDD        = Y.YYYYMMDD
--                AND X.INCOTERMS       = Y.INCOTERMS
----                AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
----                AND X.PROJECT_CODE    = Y.PROJECT_CODE
--                AND X.MEASURE         = 'MKT_FCST'
*/

        /* MERGE 원문 구조 유지 */
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT DIVISION_ID
                    , OPERATION_GROUP
                    , CELL_ITEM_ID
                    , ITEM_ID
                    , TO_SITE
                    , '-'                AS PROJECT_CODE   /* -- 중복방지 */
                    , TO_BOH_QTY
                    , FROM_BOH_QTY
                    , INCOTERMS
                    , FROM_SITE
                    , TRANSPORT_MODE
                    , PROD_LINE
                    , MEASURE
                    , YYYYMMDD
                    , SUM(QTY)           AS QTY
                    , SORT_ORDER_NO
                    , COLUMN_LABEL_NAME
                    , BOD_ID
                    , ATTRIBUTE1
                    , ATTRIBUTE9
                 FROM GT_XGLB_PSI_GLOBAL   /* #ANL_SHIPMENT_PLAN_FG */
                WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'
                  AND MEASURE    = 'MKT_FCST'
                GROUP BY DIVISION_ID
                       , OPERATION_GROUP
                       , CELL_ITEM_ID
                       , ITEM_ID
                       , TO_SITE
                       , TO_BOH_QTY
                       , FROM_BOH_QTY
                       , INCOTERMS
                       , FROM_SITE
                       , TRANSPORT_MODE
                       , PROD_LINE
                       , MEASURE
                       , YYYYMMDD
                       , SORT_ORDER_NO
                       , COLUMN_LABEL_NAME
                       , BOD_ID
                       , ATTRIBUTE1
                       , ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.OPERATION_GROUP = Z.OPERATION_GROUP
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.TO_SITE         = Z.TO_SITE
               AND X.PROJECT_CODE    = Z.PROJECT_CODE
               AND X.INCOTERMS       = Z.INCOTERMS
               AND X.MEASURE         = Z.MEASURE
               AND X.YYYYMMDD        = Z.YYYYMMDD
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;


/* AS-IS 주석 원문 (L1776~L1790)
    --            UPDATE X
    --            SET X.QTY = Y.QTY
    --            FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
    --            INNER JOIN #ANL_SHIPMENT_PLAN_FG Y  WITH (NOLOCK)
    --            ON 0 = 0
    --            AND X.TO_SITE         = Y.TO_SITE
    --            AND X.FROM_SITE       = Y.FROM_SITE
    --            AND X.MEASURE         = Y.MEASURE
    --            AND X.ITEM_ID         = Y.ITEM_ID
    --            AND X.YYYYMMDD        = Y.YYYYMMDD
    --            AND X.INCOTERMS       = Y.INCOTERMS
    --            AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
    --            AND X.PROJECT_CODE    = Y.PROJECT_CODE
				--AND X.BOD_ID          = Y.BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
    --            AND X.MEASURE         = 'SHIP_PLAN'
*/

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT DIVISION_ID
                    , OPERATION_GROUP
                    , CELL_ITEM_ID
                    , ITEM_ID
                    , TO_SITE
                    , PROJECT_CODE       /* -- 중복방지 */
                    , TO_BOH_QTY
                    , FROM_BOH_QTY
                    , INCOTERMS
                    , FROM_SITE
                    , TRANSPORT_MODE
                    , PROD_LINE
                    , MEASURE
                    , YYYYMMDD
                    , SUM(QTY)           AS QTY
                    , SORT_ORDER_NO
                    , COLUMN_LABEL_NAME
                    , BOD_ID
                    , ATTRIBUTE1
                    , ATTRIBUTE9
                 FROM GT_XGLB_PSI_GLOBAL   /* #ANL_SHIPMENT_PLAN_FG */
                WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'
                  AND MEASURE    = 'SHIP_PLAN'
                GROUP BY DIVISION_ID
                       , OPERATION_GROUP
                       , CELL_ITEM_ID
                       , ITEM_ID
                       , TO_SITE
                       , PROJECT_CODE
                       , TO_BOH_QTY
                       , FROM_BOH_QTY
                       , INCOTERMS
                       , FROM_SITE
                       , TRANSPORT_MODE
                       , PROD_LINE
                       , MEASURE
                       , YYYYMMDD
                       , SORT_ORDER_NO
                       , COLUMN_LABEL_NAME
                       , BOD_ID
                       , ATTRIBUTE1
                       , ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.TO_SITE         = Z.TO_SITE
               AND X.FROM_SITE       = Z.FROM_SITE
               AND X.MEASURE         = Z.MEASURE
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.YYYYMMDD        = Z.YYYYMMDD
               AND X.INCOTERMS       = Z.INCOTERMS
               AND X.TRANSPORT_MODE  = Z.TRANSPORT_MODE
               AND X.PROJECT_CODE    = Z.PROJECT_CODE
               AND X.BOD_ID          = Z.BOD_ID   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
               AND X.MEASURE         = 'SHIP_PLAN'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;

        /* IF @p_is_debug = 1 SELECT '1883' AS #PSI_GLOBAL_AUTO, * FROM #PSI_GLOBAL_AUTO WHERE ... → 디버그 조회 생략 */



        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT DIVISION_ID
                    , OPERATION_GROUP
                    , CELL_ITEM_ID
                    , ITEM_ID
                    , TO_SITE
                    , PROJECT_CODE
                    , TO_BOH_QTY
                    , FROM_BOH_QTY
                    , INCOTERMS
                    , FROM_SITE
                    , TRANSPORT_MODE
                    , PROD_LINE
                    , MEASURE
                    , YYYYMMDD
                    , SUM(QTY)           AS QTY
                    , SORT_ORDER_NO
                    , COLUMN_LABEL_NAME
                    , BOD_ID
                    , ATTRIBUTE1
                    , ATTRIBUTE9
                 FROM GT_XGLB_PSI_GLOBAL   /* #ANL_PRODUCTION_PLAN */
                WHERE ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'
                GROUP BY DIVISION_ID
                       , OPERATION_GROUP
                       , CELL_ITEM_ID
                       , ITEM_ID
                       , TO_SITE
                       , PROJECT_CODE
                       , TO_BOH_QTY
                       , FROM_BOH_QTY
                       , INCOTERMS
                       , FROM_SITE
                       , TRANSPORT_MODE
                       , PROD_LINE
                       , MEASURE
                       , YYYYMMDD
                       , SORT_ORDER_NO
                       , COLUMN_LABEL_NAME
                       , BOD_ID
                       , ATTRIBUTE1
                       , ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.OPERATION_GROUP = Z.OPERATION_GROUP
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.TO_SITE         = Z.TO_SITE
               AND X.FROM_SITE       = Z.FROM_SITE
               AND X.MEASURE         = Z.MEASURE
               AND X.YYYYMMDD        = Z.YYYYMMDD
               AND X.PROD_LINE       = Z.PROD_LINE
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;



        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT DIVISION_ID
                    , OPERATION_GROUP
                    , CELL_ITEM_ID
                    , ITEM_ID
                    , TO_SITE
                    , PROJECT_CODE
                    , TO_BOH_QTY
                    , FROM_BOH_QTY
                    , INCOTERMS
                    , FROM_SITE
                    , TRANSPORT_MODE
                    , PROD_LINE
                    , MEASURE
                    , YYYYMMDD
                    , SUM(QTY)           AS QTY
                    , SORT_ORDER_NO
                    , COLUMN_LABEL_NAME
                    , BOD_ID
                    , ATTRIBUTE1
                    , ATTRIBUTE9
                 FROM GT_XGLB_PSI_GLOBAL   /* #ANL_SHIPMENT_PLAN_SEMI */
                WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                GROUP BY DIVISION_ID
                       , OPERATION_GROUP
                       , CELL_ITEM_ID
                       , ITEM_ID
                       , TO_SITE
                       , PROJECT_CODE
                       , TO_BOH_QTY
                       , FROM_BOH_QTY
                       , INCOTERMS
                       , FROM_SITE
                       , TRANSPORT_MODE
                       , PROD_LINE
                       , MEASURE
                       , YYYYMMDD
                       , SORT_ORDER_NO
                       , COLUMN_LABEL_NAME
                       , BOD_ID
                       , ATTRIBUTE1
                       , ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.OPERATION_GROUP = Z.OPERATION_GROUP
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.TO_SITE         = Z.TO_SITE
               AND X.FROM_SITE       = Z.FROM_SITE
               AND X.MEASURE         = Z.MEASURE
               AND X.YYYYMMDD        = Z.YYYYMMDD
               AND X.TRANSPORT_MODE  = Z.TRANSPORT_MODE
               AND X.BOD_ID          = Z.BOD_ID
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;


/* AS-IS 주석 원문 (L2102~L2113)
                -- PRODUCTION
                --UPDATE X
                --SET X.QTY = Y.QTY
                --FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                --INNER JOIN #SCP_PLN_PRODUCTION_PLAN Y  WITH (NOLOCK)
                --ON 0 = 0
                --AND X.TO_SITE   = Y.TO_SITE
                --AND X.FROM_SITE = Y.FROM_SITE
                --AND X.MEASURE   = Y.MEASURE
                --AND X.YYYYMMDD  = Y.YYYYMMDD
                --AND X.ITEM_ID   = Y.ITEM_ID
                --AND X.PROD_LINE = Y.PROD_LINE
*/

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT DIVISION_ID
                    , OPERATION_GROUP
                    , CELL_ITEM_ID
                    , ITEM_ID
                    , TO_SITE
                    , PROJECT_CODE
                    , TO_BOH_QTY
                    , FROM_BOH_QTY
                    , INCOTERMS
                    , FROM_SITE
                    , TRANSPORT_MODE
                    , PROD_LINE
                    , MEASURE
                    , YYYYMMDD
                    , SUM(QTY)           AS QTY
                    , SORT_ORDER_NO
                    , COLUMN_LABEL_NAME
                    , BOD_ID
                    , ATTRIBUTE1
                    , ATTRIBUTE9
                 FROM GT_XGLB_PSI_GLOBAL   /* #SCP_PLN_PRODUCTION_PLAN */
                WHERE ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
                GROUP BY DIVISION_ID
                       , OPERATION_GROUP
                       , CELL_ITEM_ID
                       , ITEM_ID
                       , TO_SITE
                       , PROJECT_CODE
                       , TO_BOH_QTY
                       , FROM_BOH_QTY
                       , INCOTERMS
                       , FROM_SITE
                       , TRANSPORT_MODE
                       , PROD_LINE
                       , MEASURE
                       , YYYYMMDD
                       , SORT_ORDER_NO
                       , COLUMN_LABEL_NAME
                       , BOD_ID
                       , ATTRIBUTE1
                       , ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.OPERATION_GROUP = Z.OPERATION_GROUP
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.TO_SITE         = Z.TO_SITE
               AND X.FROM_SITE       = Z.FROM_SITE
               AND X.MEASURE         = Z.MEASURE
               AND X.YYYYMMDD        = Z.YYYYMMDD
               AND X.PROD_LINE       = Z.PROD_LINE
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;



        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- INTRANSIT 반영 */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_XGLB_INTRANSIT;

        INSERT
          INTO GT_XGLB_INTRANSIT
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , INCOTERMS
             , TO_SITE
             , FROM_SITE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , SITE_TYPE
             )
        SELECT X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , X.OPERATION_GROUP
             , X.ITEM_ID
             , X.INCOTERMS
             , X.TO_SITE
             , X.FROM_SITE
               /* --,MEASURE */
             , X.YYYYMMDD
             , SUM(X.QTY)   AS QTY
             , X.ATTRIBUTE1
               /* -- TODO : SALES와 PLANT로 분리하여 처리토록 */
             , S.SITE_TYPE
          FROM (SELECT V_DIVISION_ID                                                         AS DIVISION_ID
                     , V_PLAN_START_YYYYMMDD                                                 AS PLAN_START_YYYYMMDD
                     , P_PLAN_TYPE                                                           AS PLAN_TYPE
                     , V_SEQ                                                                 AS SEQ
                     , C.OPERATION_GROUP
                     , A.ITEM_ID
                     , FN_SCM_SPLIT(A.SITE_ID, 2, '~')                                       AS INCOTERMS
                     , (SUBSTR(A.SITE_ID, 1, FN_CHARINDEX_REV(A.SITE_ID, '~', 0) - 1))       AS TO_SITE
                     , (SUBSTR(A.LOT_ID, FN_CHARINDEX_REV(A.LOT_ID, '::', 0) + 2, 100))      AS FROM_SITE
                     , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')                                 AS YYYYMMDD
                     , (A.QTY)                                                               AS QTY
                     , 'TH_ENG_STOCK_PLAN_SN'                                                AS ATTRIBUTE1
                  FROM TH_ENG_STOCK_PLAN_SN A
                     , SCP_MST_FINAL_ITEM_V C
                 WHERE 1 = 1
                   AND A.ITEM_ID   = C.ITEM_ID
                   AND A.MASTER_ID = P_MASTER_ID
                   AND A.PLAN_ID   = P_ENGINE_PLAN_ID
                   AND A.DESCR     = 'INT'
                   /* --AND LEFT(A.SITE_ID, 6) = (SELECT TOP 1 S.SCM_SITE_ID FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.PLANT_ID = LEFT(A.SITE_ID, 6) AND S.PLANT_ID IS NOT NULL)		-- 2021.11.16 SEMI PACK 출하계획생성오류 수정 */
               )            X
             , SCM_MST_SITE S   /* -- 250105(KSK) PLAN_TYPE 추가 */
         WHERE X.DIVISION_ID = S.DIVISION_ID(+)
           AND X.TO_SITE     = S.SCM_SITE_ID(+)
         GROUP BY X.DIVISION_ID
                , X.PLAN_START_YYYYMMDD
                , X.PLAN_TYPE
                , X.SEQ
                , X.OPERATION_GROUP
                , X.ITEM_ID
                , X.INCOTERMS
                , X.TO_SITE
                , S.SITE_TYPE
                , X.FROM_SITE
                  /* --,MEASURE */
                , X.YYYYMMDD
                , X.ATTRIBUTE1
        ;

        /* -- SEMI_INTRANSIT_ETA  --> SEMI_INTRANSIT, */
        /* -- INTRANSIT_ETA       --> INTRANSIT */

/* AS-IS 주석 원문 (L2281~L2290)
                 --UPDATE X
                 --   SET X.QTY = ISNULL(Y.QTY,0)
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN #INTRANSIT Y  WITH (NOLOCK)
                 --     ON X.ITEM_ID    = Y.ITEM_ID
                 --    AND X.INCOTERMS  = Y.INCOTERMS
                 --    AND X.TO_SITE    = Y.TO_SITE
                 --    AND X.FROM_SITE  = Y.FROM_SITE
                 --    AND X.YYYYMMDD   = Y.YYYYMMDD
                 --    AND X.MEASURE    = 'INTRANSIT_ETA'
*/

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , ''                           AS CELL_ITEM_ID
                    , A.ITEM_ID
                    , A.TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'INTRANSIT_ETA'              AS MEASURE
                    , A.YYYYMMDD
                    , SUM(A.QTY)                   AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_ANL_SHIPMENT_PLAN_FG'   AS ATTRIBUTE1
                 FROM GT_XGLB_INTRANSIT A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'INTRANSIT_ETA'
                      )                 B
                WHERE 1 = 1
                  AND A.SITE_TYPE = 'SALES'
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , A.YYYYMMDD
                       , B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.INCOTERMS = Y.INCOTERMS
               AND X.TO_SITE   = Y.TO_SITE
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'INTRANSIT_ETA'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.CELL_ITEM_ID, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1
                   )
        ;

        /* IF @P_IS_DEBUG = 1  SELECT  2383  RNO,   GETDATE() - @d_event_date  ELAPSED → 디버그 조회 생략 */

/* AS-IS 주석 원문 (L2381~L2390)
                 --UPDATE X
                 --   SET X.QTY = ISNULL(Y.QTY,0)
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN #INTRANSIT Y  WITH (NOLOCK)
                 --     ON X.ITEM_ID    = Y.ITEM_ID
                 --    AND X.TO_SITE    = Y.TO_SITE
                 --    AND X.FROM_SITE  = Y.FROM_SITE
                 --    AND X.YYYYMMDD   = Y.YYYYMMDD
                 --    AND X.MEASURE    = 'SEMI_INTRANSIT_ETA'
				-- 2022.05.17 중복오류 수정
*/
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT XX.DIVISION_ID
                    , XX.OPERATION_GROUP
                    , XX.CELL_ITEM_ID
                    , XX.ITEM_ID
                    , XX.TO_SITE
                    , XX.PROJECT_CODE
                    , XX.TO_BOH_QTY
                    , XX.FROM_BOH_QTY
                    , XX.INCOTERMS
                    , XX.FROM_SITE
                    , XX.TRANSPORT_MODE
                    , XX.PROD_LINE
                    , XX.MEASURE
                    , XX.YYYYMMDD
                    , SUM(XX.QTY)        AS QTY
                    , XX.SORT_ORDER_NO
                    , XX.COLUMN_LABEL_NAME
                    , XX.BOD_ID
                    , XX.ATTRIBUTE1
                 FROM (SELECT A.DIVISION_ID
                            , A.OPERATION_GROUP
                            , ''                             AS CELL_ITEM_ID
                            , A.ITEM_ID
                            , A.TO_SITE
                            , '-'                            AS PROJECT_CODE
                            , 0                              AS TO_BOH_QTY
                            , 0                              AS FROM_BOH_QTY
                            , '-'                            AS INCOTERMS
                            , A.FROM_SITE
                            , '-'                            AS TRANSPORT_MODE
                            , '-'                            AS PROD_LINE
                            , 'SEMI_INTRANSIT_ETA'           AS MEASURE
                            , A.YYYYMMDD
                            , SUM(A.QTY)                     AS QTY
                            , B.SORT_ORDER_NO
                            , B.COLUMN_LABEL_NAME
                            , '-'                            AS BOD_ID
                            , 'SCP_ANL_SHIPMENT_PLAN_SEMI'   AS ATTRIBUTE1
                         FROM GT_XGLB_INTRANSIT A
                            , (SELECT *
                                 FROM GT_XGLB_MEASURE
                                WHERE COLUMN_NAME = 'SEMI_INTRANSIT_ETA'
                              )                 B
                        WHERE 1 = 1
                          AND A.SITE_TYPE = 'PLANT'
                        GROUP BY A.DIVISION_ID
                               , A.OPERATION_GROUP
                               , A.ITEM_ID
                               , A.TO_SITE
                               , A.INCOTERMS
                               , A.FROM_SITE
                               , A.YYYYMMDD
                               , B.SORT_ORDER_NO
                               , B.COLUMN_LABEL_NAME
                      ) XX
                GROUP BY XX.DIVISION_ID
                       , XX.OPERATION_GROUP
                       , XX.CELL_ITEM_ID
                       , XX.ITEM_ID
                       , XX.TO_SITE
                       , XX.PROJECT_CODE
                       , XX.TO_BOH_QTY
                       , XX.FROM_BOH_QTY
                       , XX.INCOTERMS
                       , XX.FROM_SITE
                       , XX.TRANSPORT_MODE
                       , XX.PROD_LINE
                       , XX.MEASURE
                       , XX.YYYYMMDD
                       , XX.SORT_ORDER_NO
                       , XX.COLUMN_LABEL_NAME
                       , XX.BOD_ID
                       , XX.ATTRIBUTE1
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.TO_SITE   = Y.TO_SITE
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'SEMI_INTRANSIT_ETA'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.CELL_ITEM_ID, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1
                   )
        ;


/* AS-IS 주석 원문 (L2517~L2528)
                 --UPDATE X
                 --   SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,TO_SITE,INCOTERMS, SUM(Y.QTY) AS FROM_BOH_QTY
                 --                FROM #INTRANSIT Y
                 --               GROUP BY ITEM_ID, FROM_SITE,TO_SITE,INCOTERMS
                 --            )  Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.INCOTERMS  = Z.INCOTERMS
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.TO_SITE    = Z.TO_SITE
                 --    AND X.MEASURE    = 'INTRANSIT'
*/

        /* IF @P_IS_DEBUG = 1  SELECT  2534  RNO,   GETDATE() - @d_event_date  ELAPSED → 디버그 조회 생략 */


        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , ''                           AS CELL_ITEM_ID
                    , A.ITEM_ID
                    , A.TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , SUM(A.QTY)                   AS FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'INTRANSIT'                  AS MEASURE
                    , 0                            AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_ANL_SHIPMENT_PLAN_FG'   AS ATTRIBUTE1
                 FROM GT_XGLB_INTRANSIT A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'INTRANSIT'
                      )                 B
                WHERE 1 = 1
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.INCOTERMS = Y.INCOTERMS
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.TO_SITE   = Y.TO_SITE
               AND X.MEASURE   = 'INTRANSIT'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.CELL_ITEM_ID, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, V_PLAN_START_YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1
                   )
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  2620  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

/* AS-IS 주석 원문 (L2620~L2631)
                 --UPDATE X
                 --   SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,TO_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                 --                FROM #INTRANSIT Y
                 --               GROUP BY ITEM_ID, FROM_SITE,TO_SITE
                 --            )  Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.TO_SITE    = Z.TO_SITE
                 --    AND X.MEASURE    = 'SEMI_INTRANSIT'
				-- 중복오류 수정 :: 2022.05.17
*/
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT XX.DIVISION_ID
                    , XX.OPERATION_GROUP
                    , XX.CELL_ITEM_ID
                    , XX.ITEM_ID
                    , XX.TO_SITE
                    , XX.PROJECT_CODE
                    , XX.TO_BOH_QTY
                    , SUM(XX.FROM_BOH_QTY)   AS FROM_BOH_QTY
                    , XX.INCOTERMS
                    , XX.FROM_SITE
                    , XX.TRANSPORT_MODE
                    , XX.PROD_LINE
                    , XX.MEASURE
                    , XX.QTY
                    , XX.SORT_ORDER_NO
                    , XX.COLUMN_LABEL_NAME
                    , XX.BOD_ID
                    , XX.ATTRIBUTE1
                 FROM (SELECT A.DIVISION_ID
                            , A.OPERATION_GROUP
                            , ''                             AS CELL_ITEM_ID
                            , A.ITEM_ID
                            , A.TO_SITE
                            , '-'                            AS PROJECT_CODE
                            , 0                              AS TO_BOH_QTY
                            , SUM(A.QTY)                     AS FROM_BOH_QTY
                            , '-'                            AS INCOTERMS
                            , A.FROM_SITE
                            , '-'                            AS TRANSPORT_MODE
                            , '-'                            AS PROD_LINE
                            , 'SEMI_INTRANSIT'               AS MEASURE
                            , 0                              AS QTY
                            , B.SORT_ORDER_NO
                            , B.COLUMN_LABEL_NAME
                            , '-'                            AS BOD_ID
                            , 'SCP_ANL_SHIPMENT_PLAN_SEMI'   AS ATTRIBUTE1
                         FROM GT_XGLB_INTRANSIT A
                            , (SELECT *
                                 FROM GT_XGLB_MEASURE
                                WHERE COLUMN_NAME = 'SEMI_INTRANSIT'
                              )                 B
                        WHERE 1 = 1
                        GROUP BY A.DIVISION_ID
                               , A.OPERATION_GROUP
                               , A.ITEM_ID
                               , A.TO_SITE
                               , A.INCOTERMS
                               , A.FROM_SITE
                               , B.SORT_ORDER_NO
                               , B.COLUMN_LABEL_NAME
                      ) XX
                GROUP BY XX.DIVISION_ID
                       , XX.OPERATION_GROUP
                       , XX.CELL_ITEM_ID
                       , XX.ITEM_ID
                       , XX.TO_SITE
                       , XX.PROJECT_CODE
                       , XX.TO_BOH_QTY
                       , XX.INCOTERMS
                       , XX.FROM_SITE
                       , XX.TRANSPORT_MODE
                       , XX.PROD_LINE
                       , XX.MEASURE
                       , XX.QTY
                       , XX.SORT_ORDER_NO
                       , XX.COLUMN_LABEL_NAME
                       , XX.BOD_ID
                       , XX.ATTRIBUTE1
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.INCOTERMS = Y.INCOTERMS
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.TO_SITE   = Y.TO_SITE
               AND X.MEASURE   = 'SEMI_INTRANSIT'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.CELL_ITEM_ID, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, V_PLAN_START_YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1
                   )
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  2759  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */


        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- CELL_FOR_FORM_END */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN') IS NOT NULL DROP TABLE #PLN_TH_ENG_STOCK_PLAN → GTT 초기화 */
        DELETE
          FROM GT_XGLB_ENG_STOCK_PLAN;

        INSERT
          INTO GT_XGLB_ENG_STOCK_PLAN
             ( DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             , DESCR
             )
        SELECT SUBSTR(A.MASTER_ID, 1, 2)                           AS DIVISION_ID
             , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)     AS FROM_SITE
             , A.ITEM_ID
             , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')               AS YYYYMMDD
             , SUM(NVL(A.QTY, 0))                                  AS QTY
             , A.DESCR
          FROM SCP_PLN_TH_ENG_STOCK_PLAN A
         WHERE 1 = 1
           AND A.MASTER_ID = P_MASTER_ID
           AND A.PLAN_ID   = P_ENGINE_PLAN_ID
           /* --                  AND A.LOT_ID LIKE 'FOR%' */
         GROUP BY SUBSTR(A.MASTER_ID, 1, 2)
                , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
                , A.ITEM_ID
                , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')
                , A.DESCR
        ;


/* AS-IS 주석 원문 (L2782~L2793)
                 --UPDATE X
                 --   SET X.QTY = ISNULL(Z.QTY,0)
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID,FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
                 --               FROM #PLN_TH_ENG_STOCK_PLAN Y WITH (NOLOCK)
                 --              WHERE DESCR LIKE 'FOR%'
                 --              GROUP BY ITEM_ID,FROM_SITE,YYYYMMDD
                 --             ) Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FOR_FORM_END'
*/

        /* AS-IS '' AS ATTRIBUTE1·ATTRIBUTE9 -- 중복방지 : Oracle 은 빈 문자가 NULL */
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID          AS DIVISION_ID
                    , 'A'                    AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                    AS TO_SITE
                    , '-'                    AS PROJECT_CODE
                    , 0                      AS TO_BOH_QTY
                    , 0                      AS FROM_BOH_QTY
                    , '-'                    AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                    AS TRANSPORT_MODE
                    , '-'                    AS PROD_LINE
                    , 'CELL_FOR_FORM_END'    AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)          AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                    AS BOD_ID
                    , ''                     AS ATTRIBUTE1   /* -- 중복방지 */
                    , ''                     AS ATTRIBUTE9   /* -- 중복방지 */
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , Y.YYYYMMDD
                            , SUM(Y.QTY) AS QTY
                         FROM GT_XGLB_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR LIKE 'FOR%'
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'CELL_FOR_FORM_END'
                      ) B
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'CELL_FOR_FORM_END'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1, Y.ATTRIBUTE9
                   )
        ;

        UPDATE GT_XGLB_PSI_GLOBAL_AUTO
           SET ATTRIBUTE1 = ''
             , ATTRIBUTE9 = ''
         WHERE MEASURE    = 'CELL_FOR_FORM_END'
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  2886  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- CELL_FORM_PROGRESS */
        /* ------------------------------------------------------------------------------------------------------------- */

/* AS-IS 주석 원문 (L2887~L2898)
--                 UPDATE X
--                    SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
--                   FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
--                   INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
--                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
--                                WHERE DESCR ='FOR'
----                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
--                                GROUP BY ITEM_ID, FROM_SITE
--                             )  Z
--                      ON X.ITEM_ID    = Z.ITEM_ID
--                     AND X.FROM_SITE  = Z.FROM_SITE
--                     AND X.MEASURE    = 'CELL_FORM_PROGRESS'
*/


        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID          AS DIVISION_ID
                    , 'A'                    AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                    AS TO_SITE
                    , '-'                    AS PROJECT_CODE
                    , 0                      AS TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , '-'                    AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                    AS TRANSPORT_MODE
                    , '-'                    AS PROD_LINE
                    , 'CELL_FORM_PROGRESS'   AS MEASURE
                    , 0                      AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                    AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY) AS FROM_BOH_QTY
                         FROM GT_XGLB_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'FOR'
                          /* --                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'CELL_FORM_PROGRESS'
                      ) B
              ) Y
           ON (    X.DIVISION_ID = Y.DIVISION_ID
               AND X.ITEM_ID     = Y.ITEM_ID
               AND X.FROM_SITE   = Y.FROM_SITE
               AND X.MEASURE     = 'CELL_FORM_PROGRESS'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, V_PLAN_START_YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID
                   )
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  2980  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가 - start */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_INSP') IS NOT NULL DROP TABLE #PLN_TH_ENG_STOCK_PLAN_INSP → GTT 초기화 */
        DELETE
          FROM GT_XGLB_ENG_STOCK_PLAN_INSP;

        INSERT
          INTO GT_XGLB_ENG_STOCK_PLAN_INSP
             ( DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             , DESCR
             , INSP_TYPE
             )
        SELECT SUBSTR(A.MASTER_ID, 1, 2)                           AS DIVISION_ID
             , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)     AS FROM_SITE
             , A.ITEM_ID
             , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')               AS YYYYMMDD
             , SUM(NVL(A.QTY, 0))                                  AS QTY
             , A.DESCR
             , A.INSP_TYPE
          FROM SCP_PLN_TH_ENG_STOCK_PLAN A
         WHERE 1 = 1
           AND A.MASTER_ID = P_MASTER_ID
           AND A.PLAN_ID   = P_ENGINE_PLAN_ID
         GROUP BY SUBSTR(A.MASTER_ID, 1, 2)
                , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
                , A.ITEM_ID
                , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')
                , A.DESCR
                , A.INSP_TYPE
        ;

        /* -- PACK BOH (Hold), 전진검사 HOLD + 전진검사 이외 HOLD */
/* AS-IS 주석 원문 (L3003~L3015)
            --     UPDATE X
            --        SET X.QTY = ISNULL(Z.QTY,0)
            --       FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
            --       INNER JOIN (SELECT ITEM_ID, FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
            --                    FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
            --                   WHERE (INSP_TYPE = 'INSP_HOLD' OR DESCR LIKE '%HOLD')
							     --AND NOT INSP_TYPE = 'INSP_PRE'
            --                   GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
            --                  ) Z
            --          ON X.ITEM_ID    = Z.ITEM_ID
            --         AND X.FROM_SITE  = Z.FROM_SITE
            --         AND X.YYYYMMDD   = Z.YYYYMMDD
            --         AND X.MEASURE    = 'PACK_BOH_HOLD'
*/

        /* AS-IS ISNULL((SELECT TOP 1 ATTRIBUTE9 ...), '') : Oracle 은 빈 문자가 NULL 이므로 하위 조회 결과 그대로 */
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID               AS DIVISION_ID
                    , 'P'                         AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                         AS TO_SITE
                    , '-'                         AS PROJECT_CODE
                    , 0                           AS TO_BOH_QTY
                    , 0                           AS FROM_BOH_QTY
                    , '-'                         AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                         AS TRANSPORT_MODE
                    , '-'                         AS PROD_LINE
                    , 'PACK_BOH_HOLD'             AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)               AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                         AS BOD_ID
                    , 'SCP_ANL_PRODUCTION_PLAN'   AS ATTRIBUTE1   /* --  중복방지 */
                    , (SELECT SA.ATTRIBUTE9
                         FROM GT_XGLB_PSI_GLOBAL_AUTO SA
                        WHERE SA.ITEM_ID     = A.ITEM_ID
                          AND SA.MEASURE    IN ('PACK_PROD', 'CELL_PROD')
                          AND SA.ATTRIBUTE9 IS NOT NULL
                          AND ROWNUM         = 1)   AS ATTRIBUTE9
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , Y.YYYYMMDD
                            , SUM(Y.QTY) AS QTY
                         FROM GT_XGLB_ENG_STOCK_PLAN_INSP Y
                        WHERE (Y.INSP_TYPE = 'INSP_HOLD' OR Y.DESCR LIKE '%HOLD')
                          AND NOT Y.INSP_TYPE = 'INSP_PRE'
                          AND (SELECT SB.OPERATION_GROUP
                                 FROM GT_XGLB_PSI_GLOBAL_AUTO SB
                                WHERE SB.ITEM_ID = Y.ITEM_ID
                                  AND SB.MEASURE = 'PACK_PROD'
                                  AND ROWNUM     = 1) = 'P'   /* -- CELL 이 함께 존재하므로 CELL을 제외한다. */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'PACK_BOH_HOLD'
                      ) B
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'PACK_BOH_HOLD'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1, Y.ATTRIBUTE9
                   )
        ;
        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  3103  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        /* -- Pack BOH(Expected Inspection date) */
/* AS-IS 주석 원문 (L3101~L3112)
                 --UPDATE X
                 --   SET X.QTY = ISNULL(Z.QTY,0)
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
                 --               FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                 --              WHERE INSP_TYPE = 'INSP_PRE'
                 --              GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
                 --             ) Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'PACK_BOH_EXP_INSP_DATE'
*/

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'P'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'PACK_BOH_EXP_INSP_DATE'     AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , Y.YYYYMMDD
                            , SUM(Y.QTY) AS QTY
                         FROM GT_XGLB_ENG_STOCK_PLAN_INSP Y
                        WHERE Y.INSP_TYPE = 'INSP_PRE'
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'PACK_BOH_EXP_INSP_DATE'
                      ) B
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'PACK_BOH_EXP_INSP_DATE'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID
                   )
        ;

        /* IF @p_is_debug = 1  BEGIN SELECT '3193' AS #PSI_GLOBAL_AUTO, * ... / SELECT  3196  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        /* -- Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정 - start */
        UPDATE GT_XGLB_PSI_GLOBAL_AUTO
           SET ATTRIBUTE1 = ''
             , ATTRIBUTE9 = ''
         WHERE MEASURE    = 'PACK_BOH_EXP_INSP_DATE'
        ;
        /* -- Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정 - end */

        /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가 - end */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- CELL_FORM_HOLD_UNDER 추가 */
        /* -- [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS) */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V') IS NOT NULL DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V → GTT 초기화
           CUTOFF_DATE·UNHOLD_EXP_DATE 는 날짜 칸 : AS-IS 'YYYYMMDD' 문자 비교(암묵 변환) → TO_DATE 로 같은 날짜 비교 */
        DELETE
          FROM GT_XGLB_STOCK_AGING_V;

        INSERT
          INTO GT_XGLB_STOCK_AGING_V
             ( FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             )
        SELECT SCM_SITE_ID   AS FROM_SITE
             , ITEM_ID
             , (CASE WHEN UNHOLD_EXP_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                     ELSE TO_CHAR(UNHOLD_EXP_DATE, 'YYYYMMDD')
                 END)        AS YYYYMMDD
             , SUM(QTY)      AS QTY
          FROM SCM_DNM_STOCK_AGING_V
         WHERE CUTOFF_DATE      = TO_DATE(V_P_CUTOFF_DATE, 'YYYYMMDD')
           AND WIPHOLD_YN       = 'Y'
           AND UNHOLD_EXP_DATE IS NOT NULL
         GROUP BY SCM_SITE_ID
                , ITEM_ID
                , (CASE WHEN UNHOLD_EXP_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                        ELSE TO_CHAR(UNHOLD_EXP_DATE, 'YYYYMMDD')
                    END)
        ;


        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  3228  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */
/* AS-IS 주석 원문 (L3225~L3232)
                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN #tmp_SCM_DNM_STOCK_AGING_V  Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
*/

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER'       AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_PLN_PRODUCTION_PLAN'    AS ATTRIBUTE1   /* -- 중복방지 */
                    , 'F6000'                      AS ATTRIBUTE9   /* -- 중복방지 */
                 FROM GT_XGLB_STOCK_AGING_V A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER'
                      )                     B
                WHERE A.FROM_SITE IS NOT NULL
                  AND A.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_P_TO_YYYYMMDD   /* -- 플랜구간만 유효 :: 2022.08.30   KSW			Cell 재고 개선건 */
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'CELL_FORM_HOLD_UNDER'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1, Y.ATTRIBUTE9
                   )
        ;
        /* IF @p_is_debug = 1 BEGIN SELECT '3277' AS #PSI_GLOBAL_AUTO, * ... / SELECT  3318  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */


        /* AS-IS ISNULL(ATTRIBUTE1, '') = '' : Oracle 은 빈 문자가 NULL → IS NULL */
        UPDATE GT_XGLB_PSI_GLOBAL_AUTO
           SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
             , ATTRIBUTE9 = 'F6000'
         WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER'
           /* -- 아래조건 전체를 'CELL_FORM_HOLD_UNDER'메저의   AND 조건으로 설정 */
           AND (ATTRIBUTE1 IS NULL OR ATTRIBUTE9 IS NULL)
        ;

        /* -- BOH */


        /* -- 보류중 해제일자가 없는수량 */
/* AS-IS 주석 원문 (L3328~L3338)
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
                  --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                  --              WHERE DESCR ='FOR_HOLD'
                  --              GROUP BY FROM_SITE, ITEM_ID
                  --           )  Z
                  --    ON X.ITEM_ID    = Z.ITEM_ID
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
*/

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER'       AS MEASURE
                    , 0                            AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
/* AS-IS 주석 원문 (L3357~L3361)
						--FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS FROM_BOH_QTY
      --                           FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
      --                          WHERE DESCR ='FOR_HOLD'
      --                          GROUP BY FROM_SITE, ITEM_ID
						--	 ) A,
*/
                 FROM (SELECT Y.FROM_SITE
                            , Y.ITEM_ID
                            , SUM(Y.QTY) AS FROM_BOH_QTY
                         FROM GT_XGLB_STOCK_AGING_V Y
                        WHERE (   Y.YYYYMMDD < V_PLAN_START_YYYYMMDD
                               OR Y.YYYYMMDD > V_P_TO_YYYYMMDD)   /* -- (플랜범위이전 + 플랜범위초과) 영역 :: 2022.08.30   KSW			Cell 재고 개선건 */
                        GROUP BY Y.FROM_SITE
                               , Y.ITEM_ID
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER'
                      ) B
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.MEASURE   = 'CELL_FORM_HOLD_UNDER'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, V_PLAN_START_YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID
                   )
        ;
        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  3422  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

/* AS-IS 주석 원문 (L3419~L3501)
-- 2022.08.30   KSW			Cell 재고 개선건 - 주석처리
    --              -- 보류중 해제일자가 없는수량
    --              -- BOH
    --              --UPDATE X
    --              --  SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Z.QTY
    --              -- FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
    --              -- INNER JOIN (
    --              --           SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
    --              --               FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
    --              --              GROUP BY FROM_SITE, ITEM_ID
    --              --              ) Z
    --              --    ON X.ITEM_ID    = Z.ITEM_ID
    --              --   AND X.FROM_SITE  = Z.FROM_SITE
    --              --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'

				--MERGE INTO #PSI_GLOBAL_AUTO AS X
				--USING (SELECT @p_division_id AS DIVISION_ID
				--			,'A'             AS OPERATION_GROUP
				--			,A.ITEM_ID
				--			,'-'             AS TO_SITE
				--			,'-'             AS PROJECT_CODE
				--			,0               AS TO_BOH_QTY
				--			,ISNULL(A.QTY,0) AS FROM_BOH_QTY
				--			,'-'             AS INCOTERMS
				--			,A.FROM_SITE
				--			,'-'             AS TRANSPORT_MODE
				--			,'-'             AS PROD_LINE
				--			,'CELL_FORM_HOLD_UNDER' AS MEASURE
				--			,0               AS QTY
				--			,B.SORT_ORDER_NO
				--			,B.COLUMN_LABEL_NAME
				--			,'-'            AS BOD_ID
				--		FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
    --                             FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
    --                            GROUP BY FROM_SITE, ITEM_ID) A,
				--		     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
				--	   WHERE A.FROM_SITE IS NOT NULL
				--      ) AS Y
				--ON  X.ITEM_ID    = Y.ITEM_ID
    --            AND X.FROM_SITE  = Y.FROM_SITE
    --            AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
				--WHEN MATCHED  THEN
				--UPDATE
				--   SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Y.FROM_BOH_QTY
				--WHEN NOT MATCHED  THEN
				--INSERT (
				--		 DIVISION_ID
				--		,OPERATION_GROUP
				--		,ITEM_ID
				--		,TO_SITE
				--		,PROJECT_CODE
				--		,TO_BOH_QTY
				--		,FROM_BOH_QTY
				--		,INCOTERMS
				--		,FROM_SITE
				--		,TRANSPORT_MODE
				--		,PROD_LINE
				--		,MEASURE
				--		,YYYYMMDD
				--		,QTY
				--		,SORT_ORDER_NO
				--		,COLUMN_LABEL_NAME
				--		,BOD_ID
				--       )
				--VALUES (
				--		 Y.DIVISION_ID
				--		,Y.OPERATION_GROUP
				--		,Y.ITEM_ID
				--		,Y.TO_SITE
				--		,Y.PROJECT_CODE
				--		,Y.TO_BOH_QTY
				--		,Y.FROM_BOH_QTY
				--		,Y.INCOTERMS
				--		,Y.FROM_SITE
				--		,Y.TRANSPORT_MODE
				--		,Y.PROD_LINE
				--		,Y.MEASURE
				--		,@p_plan_start_yyyymmdd
				--		,Y.QTY
				--		,Y.SORT_ORDER_NO
				--		,Y.COLUMN_LABEL_NAME
				--		,Y.BOD_ID
				--       );
*/


        /* IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V2') IS NOT NULL DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V2
           SELECT ... INTO #tmp_SCM_DNM_STOCK_AGING_V2 → 쓰는 곳이 아래 MERGE 한 곳뿐이라 인라인 뷰로 옮김
           --AND  UNHOLD_EXP_DATE                 IS NOT NULL */

        /* --aging에서 hold 수량중 available_date or 예상해제일 늦은날짜 기준 */
/* AS-IS 주석 원문 (L3519~L3531)
                  --UPDATE X
                  --  SET X.QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                  --               FROM #tmp_SCM_DNM_STOCK_AGING_V2 Y  WITH (NOLOCK)
                  --              WHERE 0 = 0
                  --              --AND DESCR ='WH_HOLD'
                  --              GROUP BY ITEM_ID,FROM_SITE,Y.YYYYMMDD
                  --           )  Z
                  --    ON X.ITEM_ID    = Z.ITEM_ID
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.YYYYMMDD   = Z.YYYYMMDD
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
*/

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID                      AS DIVISION_ID
                    , 'A'                                AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                                AS TO_SITE
                    , '-'                                AS PROJECT_CODE
                    , 0                                  AS TO_BOH_QTY
                    , 0                                  AS FROM_BOH_QTY
                    , '-'                                AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                                AS TRANSPORT_MODE
                    , '-'                                AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER_AVAILABLE'   AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                      AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                                AS BOD_ID
                    , 'SCP_PLN_PRODUCTION_PLAN'          AS ATTRIBUTE1   /* -- 중복방지 */
                    , 'F6000'                            AS ATTRIBUTE9   /* -- 중복방지 */
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY) AS QTY
                            , Y.YYYYMMDD
                         FROM (SELECT SCM_SITE_ID   AS FROM_SITE
                                    , ITEM_ID
                                    , (CASE WHEN AVAILABLE_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                                            ELSE TO_CHAR(AVAILABLE_DATE, 'YYYYMMDD')
                                        END)        AS YYYYMMDD
                                    , SUM(QTY)      AS QTY
                                 FROM SCM_DNM_STOCK_AGING_V
                                WHERE CUTOFF_DATE = TO_DATE(V_P_CUTOFF_DATE, 'YYYYMMDD')
                                  AND WIPHOLD_YN  = 'Y'
                                GROUP BY SCM_SITE_ID
                                       , ITEM_ID
                                       , (CASE WHEN AVAILABLE_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                                               ELSE TO_CHAR(AVAILABLE_DATE, 'YYYYMMDD')
                                           END)
                              ) Y   /* #tmp_SCM_DNM_STOCK_AGING_V2 */
                        WHERE 0 = 0
                          /* --AND DESCR ='WH_HOLD' */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1, Y.ATTRIBUTE9
                   )
        ;

        UPDATE GT_XGLB_PSI_GLOBAL_AUTO
           SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
             , ATTRIBUTE9 = 'F6000'
         WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
           /* -- 특정메저에서만 작동하도록 괄호조건 추가(KSK, 2024-05-21) */
           AND (ATTRIBUTE1 IS NULL OR ATTRIBUTE9 IS NULL)
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  3627  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- CELL_FORM_HOLD_AFTER 추가 */
        /* -- [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS) */
        /* ------------------------------------------------------------------------------------------------------------- */



/* AS-IS 주석 원문 (L3631~L3642)
                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                 --                FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                 --                WHERE DESCR ='WH_HOLD'
                 --               GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                 --            )  Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
*/

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID            AS DIVISION_ID
                    , 'A'                      AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                      AS TO_SITE
                    , '-'                      AS PROJECT_CODE
                    , 0                        AS TO_BOH_QTY
                    , 0                        AS FROM_BOH_QTY
                    , '-'                      AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                      AS TRANSPORT_MODE
                    , '-'                      AS PROD_LINE
                    , 'CELL_FORM_HOLD_AFTER'   AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)            AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                      AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY) AS QTY
                            , Y.YYYYMMDD
                         FROM GT_XGLB_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'WH_HOLD'
                          AND (SELECT SA.OPERATION_GROUP
                                 FROM SCM_MST_SITE SA
                                WHERE SA.SCM_SITE_ID = Y.FROM_SITE) = 'A'   /* -- CELL 생산 사이트 한정 */
                          AND Y.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_P_TO_YYYYMMDD   /* -- 플랜구간만 유효 :: 2022.08.30   KSW			Cell 재고 개선건 */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'CELL_FORM_HOLD_AFTER'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'CELL_FORM_HOLD_AFTER'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID
                   )
        ;

/* AS-IS 주석 원문 (L3719~L3730)
                  -- -- 보류중 해제일자가 없는수량
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                  --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                  --              WHERE DESCR ='WH_HOLD'
                  --              GROUP BY ITEM_ID,FROM_SITE
                  --           )  Z
                  --    ON X.ITEM_ID    = Z.ITEM_ID
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
*/

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  3739  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID            AS DIVISION_ID
                    , 'A'                      AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                      AS TO_SITE
                    , '-'                      AS PROJECT_CODE
                    , 0                        AS TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , '-'                      AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                      AS TRANSPORT_MODE
                    , '-'                      AS PROD_LINE
                    , 'CELL_FORM_HOLD_AFTER'   AS MEASURE
                    , 0                        AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                      AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY) AS FROM_BOH_QTY
                         FROM GT_XGLB_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'WH_HOLD'
                          AND (SELECT SA.OPERATION_GROUP
                                 FROM SCM_MST_SITE SA
                                WHERE SA.SCM_SITE_ID = Y.FROM_SITE) = 'A'   /* -- CELL 생산 사이트 한정 */
                          AND (   Y.YYYYMMDD < V_PLAN_START_YYYYMMDD
                               OR Y.YYYYMMDD > V_P_TO_YYYYMMDD)   /* -- (플랜범위이전 + 플랜범위초과) 영역 :: 2022.08.30   KSW			Cell 재고 개선건 */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'CELL_FORM_HOLD_AFTER'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.MEASURE   = 'CELL_FORM_HOLD_AFTER'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, V_PLAN_START_YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID
                   )
        ;

        UPDATE GT_XGLB_PSI_GLOBAL_AUTO
           SET ATTRIBUTE1 = ''
             , ATTRIBUTE9 = ''
         WHERE MEASURE    = 'CELL_FORM_HOLD_AFTER'
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  3822  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- * 2022.08.30   KSW			Cell 재고 개선건 */
        /* -- *							2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 -- start */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- PACK_CELL_BOH 가 존재하는 모델을 참고로 해서 PACK_CELL_BOH_HOLD MEASURE 생성 */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             )
        SELECT DISTINCT
               Y.DIVISION_ID
             , Y.OPERATION_GROUP
             , Y.ITEM_ID
             , Y.TO_SITE
             , Y.PROJECT_CODE
             , Y.TO_BOH_QTY
             , Y.FROM_BOH_QTY
             , Y.INCOTERMS
             , Y.FROM_SITE
             , Y.TRANSPORT_MODE
             , '-'                     AS PROD_LINE
             , 'PACK_CELL_BOH_HOLD'    AS MEASURE
             , Y.YYYYMMDD
             , 0                       AS QTY
             , B.SORT_ORDER_NO + 5     AS SORT_ORDER_NO
             , 'Cell BOH(Hold)'        AS COLUMN_LABEL_NAME
             , Y.BOD_ID
          FROM GT_XGLB_PSI_GLOBAL_AUTO Y
             , (SELECT *
                  FROM GT_XGLB_MEASURE
                 WHERE COLUMN_NAME = 'PACK_CELL_BOH'
               )                       B   /* INNER JOIN ... ON 1 = 1 */
         WHERE Y.MEASURE = 'PACK_CELL_BOH'
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  3873  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */
        /* -- Cell BOH(Hold) new measure 에 주차별 표시 */
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID            AS DIVISION_ID
                    , 'P'                      AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                      AS TO_SITE
                    , '-'                      AS PROJECT_CODE
                    , 0                        AS TO_BOH_QTY
                    , 0                        AS FROM_BOH_QTY
                    , '-'                      AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                      AS TRANSPORT_MODE
                    , '-'                      AS PROD_LINE
                    , 'PACK_CELL_BOH_HOLD'     AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)            AS QTY
                    , B.SORT_ORDER_NO + 5      AS SORT_ORDER_NO
                    , 'Cell BOH(Hold)'         AS COLUMN_LABEL_NAME
                    , '-'                      AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY) AS QTY
                            , Y.YYYYMMDD
                         FROM GT_XGLB_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'WH_HOLD'
                          AND (SELECT SA.OPERATION_GROUP
                                 FROM SCM_MST_SITE SA
                                WHERE SA.SCM_SITE_ID = Y.FROM_SITE) = 'P'   /* -- PACK 생산 사이트 한정 */
                          AND Y.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_P_TO_YYYYMMDD   /* -- 플랜구간만 유효 */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'PACK_CELL_BOH'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'PACK_CELL_BOH_HOLD'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID
                   )
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  3952  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        /* -- FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 */
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT V_DIVISION_ID            AS DIVISION_ID
                    , 'P'                      AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                      AS TO_SITE
                    , '-'                      AS PROJECT_CODE
                    , 0                        AS TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , '-'                      AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                      AS TRANSPORT_MODE
                    , '-'                      AS PROD_LINE
                    , 'PACK_CELL_BOH_HOLD'     AS MEASURE
                    , 0                        AS QTY
                    , B.SORT_ORDER_NO + 5      AS SORT_ORDER_NO
                    , 'Cell BOH(Hold)'         AS COLUMN_LABEL_NAME
                    , '-'                      AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY) AS FROM_BOH_QTY
                         FROM GT_XGLB_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'WH_HOLD'
                          AND (SELECT SA.OPERATION_GROUP
                                 FROM SCM_MST_SITE SA
                                WHERE SA.SCM_SITE_ID = Y.FROM_SITE) = 'P'   /* -- PACK 생산 사이트 한정 */
                          AND (   Y.YYYYMMDD < V_PLAN_START_YYYYMMDD
                               OR Y.YYYYMMDD > V_P_TO_YYYYMMDD)   /* -- (플랜범위이전 + 플랜범위초과) 영역 */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                      ) A
                    , (SELECT *
                         FROM GT_XGLB_MEASURE
                        WHERE COLUMN_NAME = 'PACK_CELL_BOH'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.MEASURE   = 'PACK_CELL_BOH_HOLD'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID, OPERATION_GROUP, ITEM_ID, TO_SITE, PROJECT_CODE, TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE
                   , TRANSPORT_MODE, PROD_LINE, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID, Y.OPERATION_GROUP, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE, Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE
                   , Y.TRANSPORT_MODE, Y.PROD_LINE, Y.MEASURE, V_PLAN_START_YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID
                   )
        ;

        UPDATE GT_XGLB_PSI_GLOBAL_AUTO
           SET ATTRIBUTE1 = ''
             , ATTRIBUTE9 = ''
         WHERE MEASURE    = 'PACK_CELL_BOH_HOLD'
        ;
        /* -- *							2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 -- end */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF @p_is_debug = 1 BEGIN SELECT '3978' AS #PSI_GLOBAL_AUTO, * ... / SELECT  4040  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- LT 계산용 테이블 생성 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL DROP TABLE #SCP_MST_BOD_V; → GTT 초기화 */
        DELETE
          FROM GT_XGLB_BOD_V;

        INSERT
          INTO GT_XGLB_BOD_V
             ( DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , BOD_ID
             , LT_TOTAL_BY_WEEK
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.FROM_SITE
             , X.TO_SITE
             , X.INCOTERMS
             , X.TRANSPORT_MODE
             , X.LT_TOTAL
             , X.BOD_ID
             , CEIL(X.LT_TOTAL / 7.0)   AS LT_TOTAL_BY_WEEK
          FROM SCP_MST_BOD_N_V X   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
         WHERE X.DIVISION_ID = V_DIVISION_ID
        ;


        /* ----------------------------------------------------------------------------------------------------------------- */
        /* ---- PACK공장 CELL 재고 UPDATE */
        /* --------------------------------------------------------------------------------------------------------------- */
        /* -- PACK 일경우 */

        UPDATE GT_XGLB_PSI_GLOBAL_AUTO X
           SET CELL_ITEM_ID = (SELECT Y.CHILD_ITEM_ID
                                 FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
                                WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                  AND Y.MODEL_ID           = X.ITEM_ID
                                  AND Y.CELL_TYPE          = 'CP'   /* -- 활성화코드 분리 대응(Cell Product 조건 추가) :: 2023.06.15 , KSK */
                                  AND Y.OPERATION_GROUP_ID = 'A'
                                  AND ROWNUM               = 1)
         WHERE OPERATION_GROUP = 'P'
        ;


        /* --  CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가) :: 2023.06.15 , KSK - START */
        /* UPDATE X ... FROM #PSI_GLOBAL_AUTO X INNER JOIN SCP_MST_FINAL_ITEM_V F LEFT JOIN SCM_MST_SITE FS LEFT JOIN CP_INFO C1/C2/C3
           → MERGE(행 식별자 ROWID 로 대상 고정, 같은 행에 짝이 여럿이면 AS-IS 처럼 하나만 반영) · 원문 CTE(CP_INFO)는 WITH 로 둔다 */
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT IB.RID
                    , IB.CELL_ITEM_ID
                 FROM (WITH CP_INFO AS (SELECT M.DIVISION_ID
                                             , M.PLANT_ID
                                             , M.ITEM_ID_ASSY
                                             , M.ITEM_ID_PROD
                                             , ROW_NUMBER() OVER(PARTITION BY M.DIVISION_ID
                                                                            , M.ITEM_ID_ASSY
                                                                            , M.PLANT_ID
                                                                     ORDER BY M.VALID_YN DESC
                                                                            , M.ITEM_ID_PROD)   AS PRIORITY_1ST
                                             , ROW_NUMBER() OVER(PARTITION BY M.DIVISION_ID
                                                                            , M.ITEM_ID_ASSY
                                                                     ORDER BY M.VALID_YN DESC
                                                                            , M.ITEM_ID_PROD)   AS PRIORITY_2ND
                                             , ROW_NUMBER() OVER(PARTITION BY M.ITEM_ID_ASSY
                                                                     ORDER BY M.VALID_YN DESC
                                                                            , M.ITEM_ID_PROD)   AS PRIORITY_3RD
                                          FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                         WHERE 1 = 1
                                       )
                       SELECT X.ROWID                                                          AS RID
                            , CASE WHEN F.CELL_TYPE LIKE 'CA%'
                                   THEN NVL(NVL(NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD), C3.ITEM_ID_PROD), X.ITEM_ID)
                                   ELSE X.ITEM_ID
                               END                                                             AS CELL_ITEM_ID
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)            AS RN
                         FROM GT_XGLB_PSI_GLOBAL_AUTO X
                            , SCP_MST_FINAL_ITEM_V    F
                            , SCM_MST_SITE            FS
                            , CP_INFO                 C1
                            , CP_INFO                 C2
                            , CP_INFO                 C3
                        WHERE 1 = 1
                          AND F.ITEM_ID              = X.ITEM_ID
                          AND FS.DIVISION_ID(+)      = X.DIVISION_ID
                          AND FS.SCM_SITE_ID(+)      = X.FROM_SITE
                          AND FS.SITE_TYPE(+)        = 'PLANT'
                          AND C1.DIVISION_ID(+)      = X.DIVISION_ID
                          AND C1.PLANT_ID(+)         = FS.PLANT_ID
                          AND C1.ITEM_ID_ASSY(+)     = X.ITEM_ID
                          AND C1.PRIORITY_1ST(+)     = 1
                          AND C2.DIVISION_ID(+)      = X.DIVISION_ID
                          AND C2.ITEM_ID_ASSY(+)     = X.ITEM_ID
                          AND C2.PRIORITY_2ND(+)     = 1
                          AND C3.ITEM_ID_ASSY(+)     = X.ITEM_ID
                          AND C3.PRIORITY_3RD(+)     = 1
                          AND X.OPERATION_GROUP      = 'A'
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (X.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET X.CELL_ITEM_ID = S.CELL_ITEM_ID
        ;

        /* ------------------------------------------------------------------------------------------------------------------------------ */
        /* --  PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update, 2023.06.15, KSK - start */
        /* ------------------------------------------------------------------------------------------------------------------------------ */
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT IB.RID
                    , IB.CELL_ITEM_ID
                 FROM (SELECT X.ROWID                                                   AS RID
                            , Z.CELL_ITEM_ID
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)     AS RN
                         FROM GT_XGLB_PSI_GLOBAL_AUTO X
                            , (SELECT DISTINCT
                                      Z.MODEL_ID                AS ITEM_ID
                                    , Z.CHILD_ITEM_ID           AS CELL_ITEM_ID
                                    , Z.ACCUMULATED_CHILD_QTY   AS CELL_QTY_PACK
                                    , Y.MODULE_ID
                                    , Y.MODULE_QTY_PACK
                                 FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                                    , (SELECT XA.DIVISION_ID
                                            , XA.MODEL_ID
                                            , XA.CHILD_ITEM_ID AS MODULE_ID
                                            , XA.CHILD_QTY     AS MODULE_QTY_PACK
                                         FROM SCM_MST_BOM_SN_V XA   /* --2021-03-09	SCP 대치 BOM 적용 */
                                            , SCM_MST_ITEM_SN  I
                                        WHERE XA.CHILD_DIVISION_ID = I.DIVISION_ID
                                          AND XA.CHILD_ITEM_ID     = I.ITEM_ID
                                          AND XA.CHILD_COMPANY_ID  = I.COMPANY_ID   /* -- A002 빈강 추가 따른 조건 추가 */
                                          AND XA.CHILD_SITE_ID     = I.SITE_ID
                                          AND I.FLOW_ID            = 'P5200'
                                          AND I.ACTIVE_FLAG        = 'Y'
                                          AND XA.DIVISION_ID       = V_DIVISION_ID   /* -- CSR E20250829-001508 로직 속도개선 */
                                      ) Y
                                WHERE Z.DIVISION_ID        = Y.DIVISION_ID
                                  AND Z.MODEL_ID           = Y.MODEL_ID
                                  AND Z.CELL_TYPE          = 'CP'   /* -- 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가) */
                                  AND Z.OPERATION_GROUP_ID = 'A'
                                  AND Z.DIVISION_ID        = V_DIVISION_ID   /* -- CSR E20250829-001508 로직 속도개선 */
                              ) Z
                        WHERE X.ITEM_ID    = Z.MODULE_ID
                          AND X.ATTRIBUTE9 = 'P5200'
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (X.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET X.CELL_ITEM_ID = S.CELL_ITEM_ID
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  4148  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

/* AS-IS 주석 원문 (L4148~L4203)
-- 주석처리 : 2022.10.14 - 불필요한 생산계획 생성을 차단
			------------------------------------------------------
			---- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화
   --         -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - start
   --          INSERT INTO #PSI_GLOBAL_AUTO
	  --          SELECT DISTINCT A.DIVISION_ID
			--              , A.OPERATION_GROUP
			--              , A.CELL_ITEM_ID
			--              , A.ITEM_ID
			--              , '-' AS TO_SITE
   --                 , A.PROJECT_CODE
			--              , A.TO_BOH_QTY
			--              , A.FROM_BOH_QTY
			--              , '-' AS INCOTERMS
			--              , A.FROM_SITE
   --                 , '-' AS TRANSPORT_MODE
   --                 , Y.LINE_ID AS PROD_LINE
			--              , A.MEASURE
			--              , A.YYYYMMDD
   --                 , 0 AS QTY
			--              , A.SORT_ORDER_NO
			--              , A.COLUMN_LABEL_NAME
			--              , A.BOD_ID
   --                 , A.ATTRIBUTE1
			--              , A.ATTRIBUTE9
	  --          FROM #PSI_GLOBAL_AUTO A WITH(NOLOCK)
	  --          CROSS APPLY (
			--				SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD
			--				FROM SCP_MST_TACT_TIME WITH(NOLOCK)
			--				WHERE DIVISION_ID =@p_division_id
			--				UNION ALL
			--				SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD
			--				FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
			--				WHERE DIVISION_ID =@p_division_id
			--			  ) Y
		 --           WHERE 0 = 0
   --                   AND A.DIVISION_ID   = Y.DIVISION_ID
   --                   AND A.ITEM_ID       = Y.ITEM_ID
   --                   AND A.FROM_SITE     = Y.PLANT_SITE_ID
   --                   AND A.MEASURE       IN  ('CELL_PROD','PACK_PROD')
			--		  AND A.PROD_LINE     <> '-'
			--		  AND Y.LINE_ID       <> '-'
			--		  AND NOT EXISTS (
			--							SELECT 'X'
			--							FROM #PSI_GLOBAL_AUTO Z WITH(NOLOCK)
			--							WHERE 1=1
			--							AND Z.DIVISION_ID          = A.DIVISION_ID
			--							AND Z.CELL_ITEM_ID         = A.CELL_ITEM_ID
			--							AND Z.ITEM_ID              = A.ITEM_ID
			--							AND Z.MEASURE              = A.MEASURE
			--							AND Z.FROM_SITE            = Y.PLANT_SITE_ID
			--							AND Z.PROD_LINE            = Y.LINE_ID
			--							AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
			--						)
   --         -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - start
			------------------------------------------------------
*/



        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- LINE_TOTAL_LOAD_ENGINE (TACT_TIME,WORKING_TIME) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- Line Load 율 로직 작업중 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL DROP TABLE #LINE_WORKINGTIME_BY_LOSS; → GTT 초기화 */
        DELETE
          FROM GT_XGLB_LINE_WORKTIME;

        /* --Working Time 추출 */
        /* AS-IS 함수 4번째 인자 '' (전체 라인) : Oracle 은 빈 문자가 NULL → 함수가 NULL 을 전체 라인으로 처리 */
        INSERT
          INTO GT_XGLB_LINE_WORKTIME
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
             )
        SELECT DIVISION_ID
             , PLANT_SITE_ID AS SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
          FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(V_DIVISION_ID, V_PLAN_START_YYYYMMDD, V_P_TO_YYYYMMDD, ''))
        ;

        /* IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad; SELECT ... INTO #LineLoad
           → 쓰는 곳이 아래 INSERT 한 곳뿐이라 인라인 뷰 B 로 옮김(원천·조건 동일) */

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  4289  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                     AS TO_SITE
             , A.PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , '-'                     AS INCOTERMS
             , A.FROM_SITE
             , '-'                     AS TRANSPORT_MODE
             , A.PROD_LINE
             , B.MEASURE
             , A.YYYYMMDD
             , B.QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XGLB_PSI_GLOBAL_AUTO A
             , (SELECT /* DISTINCT */
                       A.DIVISION_ID
                     , A.SCM_SITE_ID
                     , A.OPERATION_GROUP
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                             WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                         END)                                                                                  AS MEASURE
                     , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                            ELSE NVL(((ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME)), 0) * 100
                        END                                                                                    AS QTY
                     , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0)                                       AS CAPA_TACT
                     , NVL(D.WORKING_TIME, 0)                                                                  AS WORKING_TIME
                     , A.YYYYMMDD                                                                              AS YYYYMMDD
                     , C.ISO_YYYYWW                                                                            AS ISO_YYYYWW
                     , M.TIME_TERM                                                           /* -- 형교환(Model Change) */
                     , 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0') AS WEEK_COLUMN
                  FROM SCP_ANL_PRODUCTION_PLAN A
                     , SCM_SYS_CALENDAR_M      C
                     , GT_XGLB_LINE_WORKTIME   D
                     , SCP_ANL_TACT_TIME       E
                     , SCM_WORK_CALENDAR_M_SN  M
                 WHERE A.YYYYMMDD                      = C.BASIS_YYYYMMDD
                   AND A.DIVISION_ID                   = D.DIVISION_ID(+)
                   AND A.OPERATION_ID                  = D.OPERATION_ID(+)
                   AND A.SCM_SITE_ID                   = D.SCM_SITE_ID(+)
                   AND A.LINE_ID                       = D.LINE_ID(+)
                   AND A.YYYYMMDD                      = D.YYYYMMDD(+)
                   AND A.DIVISION_ID                   = E.DIVISION_ID(+)
                   AND A.OPERATION_ID                  = E.OPERATION_ID(+)
                   AND A.SCM_SITE_ID                   = E.SCM_SITE_ID(+)
                   AND A.LINE_ID                       = E.LINE_ID(+)
                   AND A.ITEM_ID                       = E.ITEM_ID(+)
                   AND A.YYYYMMDD                      = E.YYYYMMDD(+)
                   /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 */
                   /* -- 형교환(Model Change) 적용 - start */
                   AND A.DIVISION_ID                   = M.DIVISION_ID(+)
                   AND SUBSTR(A.SCM_SITE_ID, 1, 4)     = M.PLANT_ID(+)
                   AND A.OPERATION_ID                  = M.OPERATION_ID(+)
                   AND TO_DATE(A.YYYYMMDD, 'YYYYMMDD') = M.WORK_DATE(+)
                   AND A.LINE_ID                       = M.LINE_ID(+)
                   AND M.LOSS_CODE(+)                  = 'XC031'
                   /* -- 형교환(Model Change) 적용 - end */
                   AND A.DIVISION_ID                   = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD           = V_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE                     = P_PLAN_TYPE
                   AND A.SEQ                           = V_SEQ
                   AND A.YYYYMMDD                     >= V_PLAN_START_YYYYMMDD
                   AND A.YYYYMMDD                     <= V_P_TO_YYYYMMDD   /* --말일포함(KSK, 20240814) */
                   /* --	                AND A.MEASURE             IN ('CELL_PROD','PACK_PROD') */
                   AND A.MEASURE                      IN ('PROD_PLAN_AMEND')
                 GROUP BY A.DIVISION_ID
                        , A.SCM_SITE_ID
                        , A.OPERATION_ID
                        , A.LINE_ID
                        , A.YYYYMMDD
                        , D.WORKING_TIME
                        , C.ISO_YYYYWW
                        , A.OPERATION_GROUP
                        , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                                WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                            END)
                        , M.TIME_TERM   /* -- 형교환(Model Change) */
                   /* -- 2025.04.22 KIMCD HASH JOIN 3곳 추가 (Oracle 은 조인 힌트 문법 없음) */
               )                       B   /* #LineLoad */
             , GT_XGLB_MEASURE         M
         WHERE A.DIVISION_ID     = B.DIVISION_ID
           AND A.OPERATION_GROUP = B.OPERATION_GROUP
           AND A.FROM_SITE       = B.SCM_SITE_ID
           AND A.ATTRIBUTE9      = B.OPERATION_ID
           AND A.PROD_LINE       = B.LINE_ID
           AND A.YYYYMMDD        = B.YYYYMMDD
           AND B.MEASURE         = M.COLUMN_NAME
        ;
        /* IF @p_is_debug = 1 BEGIN SELECT '4257' AS #PSI_GLOBAL_AUTO, * ... / SELECT  4328  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */


        /* ---------------- E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경)  ---------START */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT B.DIVISION_ID
             , F.OPERATION_GROUP
             , NVL(F.CELL_ITEM_ID, M.ITEM_ID)   AS CELL_ITEM_ID
             , M.ITEM_ID
             , B.TO_SITE

             , '-'                              AS PROJECT_CODE
             , 0                                AS TO_BOH_QTY
             , 0                                AS FROM_BOH_QTY
             , B.INCOTERMS
             , B.FROM_SITE
             , B.TRANSPORT_MODE

             , '-'                              AS PROD_LINE
             , 'SHIP_PLAN'                      AS MEASURE
             , V_PLAN_START_YYYYMMDD            AS YYYYMMDD
             , 0                                AS QTY
             , MS.SORT_ORDER_NO
             , MS.COLUMN_LABEL_NAME
             , B.BOD_ID

             , 'SCP_ANL_SHIPMENT_PLAN_FG'       AS ATTRIBUTE1
             , NULL                             AS ATTRIBUTE9
          FROM SCP_MST_BOD_N_V         B
             , SCP_MST_BOD_ITEM        M
             , SCP_MST_FINAL_ITEM      F
             , GT_XGLB_MEASURE         MS
             , GT_XGLB_PSI_GLOBAL_AUTO S
         WHERE B.DIVISION_ID    = M.DIVISION_ID
           AND B.BOD_ID         = M.BOD_ID
           AND M.DIVISION_ID    = F.DIVISION_ID
           AND M.ITEM_ID        = F.ITEM_ID
           AND S.DIVISION_ID    = M.DIVISION_ID
           AND S.ITEM_ID        = M.ITEM_ID
           AND S.FROM_SITE      = B.FROM_SITE
           AND S.TO_SITE        = B.TO_SITE
           AND (S.INCOTERMS     = B.INCOTERMS OR S.INCOTERMS = '-')
           AND S.INCOTERMS      = B.INCOTERMS
           AND B.BOD_ID NOT IN (SELECT DISTINCT SA.BOD_ID FROM GT_XGLB_PSI_GLOBAL_AUTO SA)   /* -- KSK (250430, 멀티구간 BOD) */
           AND M.VALID_YN       = 'Y'
           AND B.BOD_VALID_YN   = 'Y'
           AND B.ROUTE_VALID_YN = 'Y'   /* -- KSK,250709 */
           AND F.OPERATION_GROUP = 'A'
           AND F.ATTRIBUTE8     = 'CP'
           AND MS.COLUMN_NAME   = 'SHIP_PLAN'
           AND S.MEASURE        = 'SHIP_PLAN'
           AND S.BOD_ID        <> '-'
           AND B.BOD_TYPE       = 'SALES'
           AND B.TRANSPORT_MODE <> 'AIR'
           AND S.YYYYMMDD       = V_PLAN_START_YYYYMMDD
           AND B.DIVISION_ID    = V_DIVISION_ID
           AND B.FROM_YYYYMMDD <= V_P_TO_YYYYMMDD
           AND B.TO_YYYYMMDD   >= V_PLAN_START_YYYYMMDD
        ;

        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  4387  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */
        /* -- 반제품 */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT B.DIVISION_ID
             , F.OPERATION_GROUP
             , NVL(F.CELL_ITEM_ID, M.ITEM_ID)   AS CELL_ITEM_ID
             , M.ITEM_ID
             , B.TO_SITE

             , '-'                              AS PROJECT_CODE
             , 0                                AS TO_BOH_QTY
             , 0                                AS FROM_BOH_QTY
             , B.INCOTERMS
             , B.FROM_SITE
             , B.TRANSPORT_MODE

             , '-'                              AS PROD_LINE
             , 'SEMI_SHIP_PLAN'                 AS MEASURE
             , V_PLAN_START_YYYYMMDD            AS YYYYMMDD
             , 0                                AS QTY
             , MS.SORT_ORDER_NO
             , MS.COLUMN_LABEL_NAME
             , B.BOD_ID

             , 'SCP_ANL_SHIPMENT_PLAN_SEMI'     AS ATTRIBUTE1
             , NULL                             AS ATTRIBUTE9
          FROM SCP_MST_BOD_N_V         B
             , SCP_MST_BOD_ITEM        M
             , SCP_MST_FINAL_ITEM      F
             , GT_XGLB_MEASURE         MS
             , GT_XGLB_PSI_GLOBAL_AUTO S
         WHERE B.DIVISION_ID    = M.DIVISION_ID
           AND B.BOD_ID         = M.BOD_ID
           AND M.DIVISION_ID    = F.DIVISION_ID
           AND M.ITEM_ID        = F.ITEM_ID
           AND S.DIVISION_ID    = M.DIVISION_ID
           AND S.ITEM_ID        = M.ITEM_ID
           AND S.FROM_SITE      = B.FROM_SITE
           AND S.TO_SITE        = B.TO_SITE
           AND (S.INCOTERMS     = B.INCOTERMS OR S.INCOTERMS = '-')
           AND S.INCOTERMS      = B.INCOTERMS
           AND B.BOD_ID NOT IN (SELECT DISTINCT SA.BOD_ID FROM GT_XGLB_PSI_GLOBAL_AUTO SA)
           AND M.VALID_YN       = 'Y'
           AND B.BOD_VALID_YN   = 'Y'
           AND B.ROUTE_VALID_YN = 'Y'   /* -- KSK,250709 */
           AND F.OPERATION_GROUP = 'A'
           AND F.ATTRIBUTE8     = 'CP'
           AND MS.COLUMN_NAME   = 'SEMI_SHIP_PLAN'
           AND S.MEASURE        = 'SEMI_SHIP_PLAN'
           AND S.BOD_ID        <> '-'
           AND B.BOD_TYPE       = 'PLANT'
           AND B.TRANSPORT_MODE <> 'AIR'
           AND S.YYYYMMDD       = V_PLAN_START_YYYYMMDD
           AND B.DIVISION_ID    = V_DIVISION_ID
           AND B.FROM_YYYYMMDD <= V_P_TO_YYYYMMDD
           AND B.TO_YYYYMMDD   >= V_PLAN_START_YYYYMMDD
        ;
        /* ----------- E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경)  -------- END */


        /* IF @P_IS_DEBUG = 1  BEGIN SELECT  4448  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */
        /* ---------------------------------------------------- */
        /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 */
        /* -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - start */
        /* CROSS APPLY #MEASURE M : 상관 조건이 없는 곱 조인 */
        INSERT
          INTO GT_XGLB_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS PROJECT_CODE
             , 0                       AS TO_BOH_QTY
             , 0                       AS FROM_BOH_QTY
             , '-'                     AS INCOTERMS
             , X.FROM_SITE
             , '-'                     AS TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME           AS MEASURE
             , X.YYYYMMDD
             , 0                       AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                     AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       DIVISION_ID
                     , OPERATION_GROUP
                     , CELL_ITEM_ID
                     , ITEM_ID
                     , FROM_SITE
                     , PROD_LINE
                     , MEASURE
                     , YYYYMMDD
                     , ATTRIBUTE1
                     , ATTRIBUTE9
                  FROM GT_XGLB_PSI_GLOBAL_AUTO
                 WHERE MEASURE   IN ('PACK_PROD', 'CELL_PROD')
                   AND PROD_LINE <> '-'
               )               X
             , GT_XGLB_MEASURE M
         WHERE 1 = 1
           AND X.MEASURE    IN ('PACK_PROD', 'CELL_PROD')
           AND M.GUBUN       = 'FROM'
           AND M.COLUMN_NAME = (CASE WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_MODEL_CHANGE' ELSE 'CELL_MODEL_CHANGE' END)
           AND X.PROD_LINE  <> '-'
        ;

        /* IF @p_is_debug = 1 BEGIN SELECT '4418' AS #PSI_GLOBAL_AUTO, * ... / SELECT  4501  RNO,   GETDATE() - @d_event_date  ELAPSED END → 디버그 조회 생략 */

        DELETE
          FROM GT_XGLB_PSI_GLOBAL_AUTO
         WHERE MEASURE  IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE')
           AND PROD_LINE = '-'
        ;
        /* -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - end */

        /* -- KSW 2021.07.29 형교환 - start */
        /* UPDATE X ... FROM #PSI_GLOBAL_AUTO X INNER JOIN SCM_WORK_CALENDAR_M_SN B → MERGE(ROWID)
           AS-IS X.YYYYMMDD(문자) = B.WORK_DATE(날짜) 암묵 변환 → TO_DATE */
        MERGE
         INTO GT_XGLB_PSI_GLOBAL_AUTO X
        USING (SELECT IB.RID
                    , IB.QTY
                 FROM (SELECT X.ROWID                                                 AS RID
                            , NVL(B.TIME_TERM, 0)                                     AS QTY
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                         FROM GT_XGLB_PSI_GLOBAL_AUTO X
                            , SCM_WORK_CALENDAR_M_SN  B
                        WHERE 0 = 0
                          AND X.DIVISION_ID                   = B.DIVISION_ID
                          AND SUBSTR(X.FROM_SITE, 1, 4)       = B.PLANT_ID
                          AND X.ATTRIBUTE9                    = B.OPERATION_ID
                          AND TO_DATE(X.YYYYMMDD, 'YYYYMMDD') = B.WORK_DATE
                          AND X.PROD_LINE                     = B.LINE_ID
                          AND B.LOSS_CODE                     = 'XC031'
                          AND X.MEASURE                      IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE')
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (X.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = S.QTY
        ;
        /* -- KSW 2021.07.29 형교환 - end */
        /* ---------------------------------------------------- */

        /* AS-IS IF @p_is_debug = 1 BEGIN SELECT '4442' ... / SELECT 4529 RNO ... RETURN ; END
           → 디버그 조회는 생략하고 반환(RETURN ; = 0)만 재현 */
        IF P_IS_DEBUG = '1' THEN
            O_RETURN := 0;
            RETURN;
        END IF;



        /* -- 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성 */
        /* --  구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결) */

        /* -- 동일 플랜의 구 data 삭제 */
        IF P_IS_DEBUG = '0' THEN
            DELETE
              FROM SCP_XLS_PSI_GLOBAL
             WHERE DIVISION_ID = V_DIVISION_ID;   /* -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */
        END IF;


        /* DECLARE @rows INT; / @p_create_from_yyyymmdd NVARCHAR(0008); / @p_create_to_yyyymmdd NVARCHAR(0008); → 선언부 */

        /* --  Plan End Date */
        /* DECLARE @v_pet_date NVARCHAR(12) = '' / @v_bp_days INT = 0 / @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '' → 선언부 */
        V_BP_FLAG := '';

        /* AS-IS SELECT @변수 = ... : 행이 없으면 변수값 유지 → FOR 루프로 재현 */
        FOR R IN (SELECT P.HORIZON_END_DATE
                       , (CASE WHEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') > 364 THEN 'Y' ELSE 'N' END) AS BP_FLAG
                       , (CASE WHEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') > 364
                               THEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') - 363
                               ELSE 0
                           END)                                                                                                         AS BP_DAYS
                    FROM SCM_MST_PLAN P
                   WHERE P.DIVISION_ID = V_DIVISION_ID
                     AND P.PLAN_ID     = (SELECT MAX(SA.PLAN_ID)
                                            FROM SCM_MST_PLAN SA
                                           WHERE SA.DIVISION_ID = V_DIVISION_ID
                                             AND TO_NUMBER(SA.PLAN_ID) < 9999)
                 )
        LOOP
            V_PET_DATE := R.HORIZON_END_DATE;
            V_BP_FLAG  := R.BP_FLAG;
            V_BP_DAYS  := R.BP_DAYS;
        END LOOP;

        V_CREATE_FROM_YYYYMMDD := V_PLAN_START_YYYYMMDD;
        V_CREATE_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD');
        IF P_IS_DEBUG = '0' THEN
            PR_SCP_XLS_PSI_GLOBAL_S( P_PLAN_CYCLE           => P_PLAN_CYCLE
                                   , P_PLAN_START_YYYYMMDD  => V_PLAN_START_YYYYMMDD
                                   , P_PLAN_ID              => P_PLAN_ID
                                   , P_MODELING_ID          => P_MODELING_ID
                                   , P_SEQ                  => P_SEQ
                                   , P_PLAN_TYPE            => P_PLAN_TYPE
                                   , P_MASTER_ID            => P_MASTER_ID
                                   , P_DIVISION_ID          => V_DIVISION_ID
                                   , P_ENGINE_PLAN_ID       => P_ENGINE_PLAN_ID
                                   , P_CREATE_FROM_YYYYMMDD => V_CREATE_FROM_YYYYMMDD
                                   , P_CREATE_TO_YYYYMMDD   => V_CREATE_TO_YYYYMMDD
                                   , P_USER_ID              => V_BATCH_USER
                                     /* --, @p_is_debug			= @p_is_debug */
                                   , O_RETURN               => V_ROWS
                                   );
        END IF;
        IF (V_ROWS < 0) THEN
            /* GOTO _RETURN_ERR_CODE : RETURN -1 */
            O_RETURN := -1;
            RETURN;
        END IF;

        /* --PRINT 'PR_SCP_XLS_PSI_GLOBAL_S START' */

        IF V_BP_FLAG = 'Y' THEN
            /* -- 2 YEAR PIVOT data 생성 */
            V_CREATE_FROM_YYYYMMDD := TO_CHAR(TO_DATE(V_CREATE_TO_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');
            V_CREATE_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD');
            IF P_IS_DEBUG = '0' THEN
                PR_SCP_XLS_PSI_GLOBAL_S( P_PLAN_CYCLE           => P_PLAN_CYCLE
                                       , P_PLAN_START_YYYYMMDD  => V_PLAN_START_YYYYMMDD
                                       , P_PLAN_ID              => P_PLAN_ID
                                       , P_MODELING_ID          => P_MODELING_ID
                                       , P_SEQ                  => P_SEQ
                                       , P_PLAN_TYPE            => P_PLAN_TYPE
                                       , P_MASTER_ID            => P_MASTER_ID
                                       , P_DIVISION_ID          => V_DIVISION_ID
                                       , P_ENGINE_PLAN_ID       => P_ENGINE_PLAN_ID
                                       , P_CREATE_FROM_YYYYMMDD => V_CREATE_FROM_YYYYMMDD
                                       , P_CREATE_TO_YYYYMMDD   => V_CREATE_TO_YYYYMMDD
                                       , P_USER_ID              => V_BATCH_USER
                                         /* --, @p_is_debug			= @p_is_debug */
                                       , O_RETURN               => V_ROWS
                                       );
            END IF;
            IF (V_ROWS < 0) THEN
                /* GOTO _RETURN_ERR_CODE : RETURN -1 */
                O_RETURN := -1;
                RETURN;
            END IF;

        END IF;

        /* --PRINT '임시 TEMP  테이블 DROP' */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- 임시 TEMP  테이블 DROP */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS 는 여기서 #임시 테이블을 모두 DROP 한다.
           Oracle GTT(ON COMMIT PRESERVE ROWS)는 다음 실행 시작 때 DELETE 로 비우므로 별도 처리 없음.
           대상 원문 : #MEASURE #PSI_GLOBAL #ANL_SHIPMENT_PLAN_FG #ANL_PRODUCTION_PLAN #ANL_SHIPMENT_PLAN_SEMI #SCP_PLN_PRODUCTION_PLAN
                       #ITEM_ID #PSI_GLOBAL_AUTO #INTRANSIT #PLN_TH_ENG_STOCK_PLAN #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD #PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD
                       #SCP_MST_BOD_V #LineLoad #LineLoad_WEEK_PIVOT #TRANSPORT_MODE #SCP_XLS_PSI_GLOBAL_AUTO_MODEL_INVENTORY #Rn #CALENDAR #HEADER
                       #PLN_PLANT_ONHAND #BOH #BOH_NHOLD #SCP_XLS_PSI_GLOBAL_AUTO #tmp_SCP_MST_TACT_TIME #LINE_ASSIGN #LINE_ASSIGN_ORG
                       #temp_MODEL_INFO #PLN_TH_ENG_STOCK_PLAN_INSP #tmp_PSI_GLOBAL_AUTO #tmp_SCP_MST_DIO_OLD #tmp_SCP_MST_DIO #tmp_NICK_NAME
           원문 주석 : -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - HOLD 가 포함되지 않음 - PACK HOLD 만 해당
                       -------------------------------------------------------------------------------------------------------------------------
                       -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
                       -- PACK_PROD, CELL_PROD - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가 - 임시테이블 삭제
                       -------------------------------------------------------------------------------------------------------------------------
                       -- MODULE 의 상위 모델을 찾기위한 temp 테이블
                       -------------------------------------------------------------------------------------------------------------
                       -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가
                       -------------------------------------------------------------------------------------------------------------
                       -- 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장 */


        /* ----------------------------------------------------------- */
        /* -- 실행 Logic END -- */
        /* ----------------------------------------------------------- */
        /* --IF @@TRANCOUNT > 0 */
        /* --  BEGIN */
        /* --    COMMIT TRAN ; */
        /* --  END; */

        /* --PRINT '완료 로깅 시작' */

        /* -- TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        IF P_IS_DEBUG = '0' THEN
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );
        END IF;
        /* --PRINT '완료' */

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            /* --IF @@TRANCOUNT > 0 */
            /* --  BEGIN */
            /* --    ROLLBACK TRAN T1 */
            /* --  END; */

            /* -- ERROR LOG */
            /* --PRINT @@ERROR */
            /* --PRINT ERROR_MESSAGE(); */
            /* --PRINT  ERROR_LINE(); */

            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            IF P_IS_DEBUG = '0' THEN
                PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                    , P_LOG_TYPE     => V_LOG_TYPE
                                    , P_LOG_COUNT    => N_LOG_COUNT
                                    , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                    , P_DESCRIPTION  => V_DESCRIPTION
                                    , P_EVENT_DATE   => D_EVENT_DATE
                                    , P_USER_ID      => V_BATCH_USER
                                    );
            END IF;
            O_RETURN := -1;  /* return -1 */
            RETURN;
    END;  /* END CATCH; */


    /* -- 임시 운영반영시에 주석처리 할것. */
    /* AS-IS REPLICATE('0', 2 - LEN(x)) + x : x 가 3자리 이상이면 REPLICATE 가 NULL → 전체 NULL (형제 변환본과 같은 재현) */
    V_EXEC_TIME := CASE
                     WHEN LENGTH(TO_CHAR(TRUNC(TRUNC((SYSDATE - V_START_TIME) * 86400) / 60))) > 2
                       OR LENGTH(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60))) > 2
                     THEN NULL
                     ELSE LPAD(TO_CHAR(TRUNC(TRUNC((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                          || ':'
                          || LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0')
                   END;

    /* -- 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    /* AS-IS '+' 결합 : 하나라도 NULL 이면 전체 NULL */
    V_DESCRIPTION := CASE WHEN P_MASTER_ID IS NULL OR P_ENGINE_PLAN_ID IS NULL OR V_EXEC_TIME IS NULL THEN NULL
                          ELSE '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']'
                      END;
    D_EVENT_DATE  := SYSDATE;
    IF P_IS_DEBUG = '0' THEN
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END IF;
    O_RETURN := 1;  /* return 1 */
    RETURN;

    /* _RETURN_ERR_CODE: BEGIN RETURN -1 END; → 위 두 호출 직후 IF (V_ROWS < 0) 에서 O_RETURN := -1; RETURN; */
END;