PROCEDURE PR_SCP_XLS_PSI_GLOBAL_S
( P_PLAN_CYCLE            IN  VARCHAR2                       /* NVARCHAR(0150) */
, P_PLAN_START_YYYYMMDD   IN  VARCHAR2                       /* NVARCHAR(0008) */
, P_PLAN_ID               IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_MODELING_ID           IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_SEQ                   IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_PLAN_TYPE             IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_MASTER_ID             IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_DIVISION_ID           IN  VARCHAR2                       /* NVARCHAR(0030) */
, P_ENGINE_PLAN_ID        IN  VARCHAR2                       /* NVARCHAR(4000) */
, P_CREATE_FROM_YYYYMMDD  IN  VARCHAR2                       /* NVARCHAR(0008) */
, P_CREATE_TO_YYYYMMDD    IN  VARCHAR2                       /* NVARCHAR(0008) */
, P_USER_ID               IN  VARCHAR2 DEFAULT 'SCP_batch'   /* NVARCHAR(0150)  = 'SCP_batch' */
  /* ---- , @p_debug       INT OUTPUT */
, O_RETURN                OUT NUMBER                         /* AS-IS RETURN 값 */
)
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_S
 * Description  : PR_SCP_XLS_PSI_GLOBAL 에서 호출함.
 * OutTable     :
 * Execute      :
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
      EXEC PR_SCP_XLS_PSI_GLOBAL_S
               @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20210429'
             , @p_plan_id             = '1071'
             , @p_modeling_id         = '2'
             , @p_seq                 = '1'
             , @p_plan_type           = 'PR'
             , @p_master_id           = '81::WEEKLY'
             , @p_division_id         = '81'
             , @p_engine_plan_id      = '1071::PR::1'
		     , @p_create_from_yyyymmdd  = '20210429'
	         , @p_create_to_yyyymmdd    = '20220428'
             , @p_user_id             = 'KSW'

    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_S' order by CREATION_DATE desc

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
 * 2021.05.27   KSW         NICK NAME 누락오류 수정
 * 2021.08.10   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현
 * 2021.08.17   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021.09.08   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 적용
 * 2021.10.19   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외
 * 2021.10.28   KSW         튜닝 개선안 적용
 * 2022.03.02   KSW         BOD 정보가 없는 SEMI_SHIP_PLAN UPDATE (BOD_ID, ATTRIBUTE3, LT_DAY)
 * 2022.03.23	KSW	        GM JV 반영
 * 2022.07.29   KSW         DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체
 * 2022.08.30   KSW			Cell 재고 개선건
 *							1) PACK_CELL_BOH	Cell BOH measure 에서 HOLD 수량제외
 *							2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
 *							3) CELL_FORM_HOLD_AFTER	After Form. Hold Release measure 에서 FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
 * 2022.10.14	KSW			불필요한 생산계획 생성을 차단
 * 2022.10.11	KSW			W01 ~ W08 주차 합산 생산계획이 0 일 경우 1 추가 건에 대한 처리
 * 2023.07.01  DHJ/KSK	    PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 분리
 * 2025.04.22 KIMCD			#LineLoad 형성용 조회문에 HASH JOIN 추가
 * 2025.08.18	KSK          E20250722-000632 자동차 시뮬레이터 주간LT 오류 보완
 * 2025.12.02   HRK			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : SEMI_SHIP_PLAN 중복 데이터 삭제 로직 보완
 *							 - SEMI_SHIP_PLAN measure 추가 및 중복데이터 삭제시  BOD_ID, TRANSPORT_MODE 컬럼 ISNULL 처리 ('-')
 *							 - 2025.12.23 #TRANSPORT_MODE 추가 쿼리 SEMI_SHIP_PLAN measure  BOD_ID isnull 처리 보완
 *							   (ESS semi 출학계획 동기화로 생성된 데이터 division의 from/to site와 bod_id 불일치
 *								: 왜 left outer join을 하고.. join 조건에 bod_id가 있는지..bod_id를 알면 전송mode가 다를 수 없을 것으로 보임)
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
/* --DROP PROC dbo.PR_SCP_XLS_PSI_GLOBAL_S */
AS
    /* AS-IS 인자 선언 길이 재현 */
    V_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR)    := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_DIVISION_ID          VARCHAR2(30 CHAR)   := SUBSTR(P_DIVISION_ID, 1, 30);
    V_CREATE_FROM_YYYYMMDD VARCHAR2(8 CHAR)    := SUBSTR(P_CREATE_FROM_YYYYMMDD, 1, 8);
    V_CREATE_TO_YYYYMMDD   VARCHAR2(8 CHAR)    := SUBSTR(P_CREATE_TO_YYYYMMDD, 1, 8);
    V_USER_ID              VARCHAR2(150 CHAR)  := SUBSTR(P_USER_ID, 1, 150);
    /* AS-IS 숫자 칸(SEQ) = NVARCHAR 인자 비교 → 인자를 숫자로 바꿔 비교 */
    V_SEQ                  NUMBER              := TO_NUMBER(P_SEQ);

    /* -- LOG 용 변수 설정 */
    V_BATCH_USER           VARCHAR2(150 CHAR)  := 'SCP_batch';
    V_PROGRAM_NAME         VARCHAR2(150 CHAR)  := 'PR_SCP_XLS_PSI_GLOBAL_S';
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
    /* ----DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) */
    /* ----DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112) */

    /* --DECLARE @debug_mode            NVARCHAR(30) = 'T' */

    /* AS-IS 81 사업부 DIO 조회용 변수 : declare @p_get_* nvarchar(20) */
    V_GET_PLAN_START_YYYYMMDD VARCHAR2(20 CHAR) := '';
    V_GET_SEQ                 VARCHAR2(20 CHAR) := '';
    V_GET_VER                 VARCHAR2(20 CHAR) := '';
    V_GET_PLAN_TYPE           VARCHAR2(20 CHAR) := 'FN';
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
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    BEGIN  /* BEGIN TRY */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- Line Load 율 - #LineLoad 를 1 YEAR 단위로 처리하기 위해서 다시 생성함 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad; → GTT 초기화 */
        DELETE
          FROM GT_XGLS_LINELOAD;

        INSERT
          INTO GT_XGLS_LINELOAD
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_GROUP
             , OPERATION_ID
             , LINE_ID
             , MEASURE
             , QTY
             , CAPA_TACT
             , WORKING_TIME
             , YYYYMMDD
             , ISO_YYYYWW
             , TIME_TERM
             , WEEK_COLUMN
             )
        SELECT /* DISTINCT */
               A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.OPERATION_GROUP
             , A.OPERATION_ID
             , A.LINE_ID
             , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                     WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                 END)                                                                                         AS MEASURE
             , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                    ELSE NVL(((ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME)), 0) * 100
                END                                                                                           AS QTY
             , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0)                                              AS CAPA_TACT
             , NVL(D.WORKING_TIME, 0)                                                                         AS WORKING_TIME
             , A.YYYYMMDD                                                                                     AS YYYYMMDD
             , C.ISO_YYYYWW                                                                                   AS ISO_YYYYWW
             , M.TIME_TERM                                                                  /* -- 형교환(Model Change) */
               /* AS-IS 'WQTY' + REPLICATE('0', 2 - LEN(n)) + n : n 은 1년 안 주차 순번(최대 53)이라 2자리 왼쪽 0 채움 */
             , 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0') AS WEEK_COLUMN
          FROM SCP_ANL_PRODUCTION_PLAN A
             , SCM_SYS_CALENDAR_M      C
             , GT_XGLB_LINE_WORKTIME   D
             , SCP_ANL_TACT_TIME       E
             , SCM_WORK_CALENDAR_M_SN  M
         WHERE A.YYYYMMDD                     = C.BASIS_YYYYMMDD
           AND A.DIVISION_ID                  = D.DIVISION_ID(+)
           AND A.OPERATION_ID                 = D.OPERATION_ID(+)
           AND A.SCM_SITE_ID                  = D.SCM_SITE_ID(+)
           AND A.LINE_ID                      = D.LINE_ID(+)
           AND A.YYYYMMDD                     = D.YYYYMMDD(+)
           AND A.DIVISION_ID                  = E.DIVISION_ID(+)
           AND A.OPERATION_ID                 = E.OPERATION_ID(+)
           AND A.SCM_SITE_ID                  = E.SCM_SITE_ID(+)
           AND A.LINE_ID                      = E.LINE_ID(+)
           AND A.ITEM_ID                      = E.ITEM_ID(+)
           AND A.YYYYMMDD                     = E.YYYYMMDD(+)
           /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 */
           /* -- 형교환(Model Change) 적용 - start */
           AND A.DIVISION_ID                  = M.DIVISION_ID(+)
           AND SUBSTR(A.SCM_SITE_ID, 1, 4)    = M.PLANT_ID(+)
           AND A.OPERATION_ID                 = M.OPERATION_ID(+)
           AND TO_DATE(A.YYYYMMDD, 'YYYYMMDD') = M.WORK_DATE(+)
           AND A.LINE_ID                      = M.LINE_ID(+)
           AND M.LOSS_CODE(+)                 = 'XC031'
           /* -- 형교환(Model Change) 적용 - end */
           AND A.DIVISION_ID                  = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD          = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE                    = P_PLAN_TYPE
           AND A.SEQ                          = V_SEQ
           AND A.YYYYMMDD                    >= V_CREATE_FROM_YYYYMMDD
           AND A.YYYYMMDD                    <= V_CREATE_TO_YYYYMMDD
           /* --	                AND A.MEASURE             IN ('CELL_PROD','PACK_PROD') */
           AND A.MEASURE                     IN ('PROD_PLAN_AMEND')
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
        ;   /* -- 2025.04.22 KIMCD HASH JOIN 3곳 추가 (Oracle 은 조인 힌트 문법 없음) */


        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_AUTO) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_AUTO') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_AUTO */
        /* --DROP TABLE #SCP_XLS_PSI_GLOBAL_AUTO */
        /* CREATE TABLE #SCP_XLS_PSI_GLOBAL_AUTO → GTT GT_XGLS_PSI_GLOBAL_AUTO(별도 DDL) 초기화
           칸 설명 원문 : OPERATION_GROUP_NAME -- 신규 / CELL_QTY_PACK -- 신규 / TO_SITE_DESCRIPTION -- SCM_SITE_DESCRIPTION
                          PROJECT_CODE -- FG 때문에 추가 / FROM_SITE_DESCRIPTION -- SCM_SITE_DESCRIPTION
                          MEASURE_LABEL -- COLUMN_LABEL_NAME / QTY001 -- 신규 / ATTRIBUTE9 -- OPERATION_ID
                          --                CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE */
        DELETE
          FROM GT_XGLS_PSI_GLOBAL_AUTO;


        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  364일 데이터 생성(PIVOIT 대상 날짜문자열 생성) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- 전체 DATA 생성 (#PSI_GLOBAL_AUTO --> #SCP_XLS_PSI_GLOBAL_AUTO) PIVOT */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS 는 @mQry_sum 에 달력 날짜(생성 From~To, 날짜 오름차순)마다
           SUM(CASE WHEN YYYYMMDD = '날짜' THEN QTY ELSE 0 END) AS QTYnnn 을 이어 붙여 sp_executesql 로 실행했다.
           → 정적 SQL : 같은 달력 범위에 날짜 오름차순 순번(XA.RN)을 매기고 SUM(CASE WHEN XA.RN = n ...) AS QTYnnn 으로 고정.
             QTYnnn 의 nnn = 달력 날짜 순번(ROW_NUMBER() OVER(ORDER BY YYYYMMDD)) 이라 의미가 같다.
           AS-IS LEFT JOIN 조건 안의 A.YYYYMMDD 범위 조건은 아래 WHERE 의 같은 범위 조건과 겹쳐 결과에 영향이 없어 WHERE 로 둔다. */
        INSERT
          INTO GT_XGLS_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT A.DIVISION_ID
             , V_PLAN_START_YYYYMMDD                                         AS PLAN_START_YYYYMMDD
             , P_PLAN_TYPE                                                   AS PLAN_TYPE
             , V_SEQ                                                         AS SEQ
             , A.OPERATION_GROUP
             , (SELECT SA.SEGMENT2
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                 WHERE SA.LOOKUP_TYPE = 'OPERATION_GROUP'
                   AND SA.SEGMENT1    = A.OPERATION_GROUP
                   AND ROWNUM         = 1)                                   AS OPERATION_GROUP_NAME
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , (SELECT (CASE WHEN RTRIM(SB.NICK_NAME) IS NULL THEN '-' ELSE SB.NICK_NAME END)  /* AS-IS WHEN X.NICK_NAME = '' THEN '-' : Oracle 은 '' = NULL */
                  FROM SCM_MST_ITEM_SN SB
                 WHERE SB.ITEM_ID   = A.ITEM_ID
                   AND SB.NICK_NAME IS NOT NULL
                   AND ROWNUM       = 1)                                     AS NICK_NAME
             , 0                                                             AS CELL_QTY_PACK
             , A.TO_SITE
             , NVL((SELECT CASE WHEN RTRIM(SC.SITE_DESCRIPTION) IS NULL THEN '-' ELSE SC.SITE_DESCRIPTION END
                      FROM SCM_MST_SITE SC
                     WHERE SC.SCM_SITE_ID = A.TO_SITE
                       AND ROWNUM         = 1), '-')                         AS TO_SITE_DESCRIPTION
             , A.PROJECT_CODE
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , CASE WHEN RTRIM(A.INCOTERMS) IS NULL THEN '-' ELSE A.INCOTERMS END AS INCOTERMS  /* AS-IS ISNULL(NULLIF(A.INCOTERMS, ''), '-') */
             , A.FROM_SITE
             , NVL((SELECT CASE WHEN RTRIM(SD.SITE_DESCRIPTION) IS NULL THEN '-' ELSE SD.SITE_DESCRIPTION END
                      FROM SCM_MST_SITE SD
                     WHERE SD.SCM_SITE_ID = A.FROM_SITE
                       AND ROWNUM         = 1), '-')                         AS FROM_SITE_DESCRIPTION
             , NVL(A.TRANSPORT_MODE, '-')                                    AS TRANSPORT_MODE
             , NVL(A.PROD_LINE, '-')                                         AS PROD_LINE
               /* AS-IS (CASE WHEN A.BOD_ID='-' THEN '-' ELSE CONVERT(NVARCHAR(50), B.LT_TOTAL_BY_WEEK) END) → INT 칸 적재 시 '-' 는 0 */
             , (CASE WHEN A.BOD_ID = '-' THEN 0 ELSE B.LT_TOTAL_BY_WEEK END) AS LT_DAY
             , A.BOD_ID
             , A.MEASURE
             , A.COLUMN_LABEL_NAME                                           AS MEASURE_LABEL
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY1
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY2
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY3
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY4
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY5
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE1
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE2
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE3
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE4
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE5
             , A.SORT_ORDER_NO
             , SUM(CASE WHEN XA.RN = 1 THEN A.QTY ELSE 0 END) AS QTY001
             , SUM(CASE WHEN XA.RN = 2 THEN A.QTY ELSE 0 END) AS QTY002
             , SUM(CASE WHEN XA.RN = 3 THEN A.QTY ELSE 0 END) AS QTY003
             , SUM(CASE WHEN XA.RN = 4 THEN A.QTY ELSE 0 END) AS QTY004
             , SUM(CASE WHEN XA.RN = 5 THEN A.QTY ELSE 0 END) AS QTY005
             , SUM(CASE WHEN XA.RN = 6 THEN A.QTY ELSE 0 END) AS QTY006
             , SUM(CASE WHEN XA.RN = 7 THEN A.QTY ELSE 0 END) AS QTY007
             , SUM(CASE WHEN XA.RN = 8 THEN A.QTY ELSE 0 END) AS QTY008
             , SUM(CASE WHEN XA.RN = 9 THEN A.QTY ELSE 0 END) AS QTY009
             , SUM(CASE WHEN XA.RN = 10 THEN A.QTY ELSE 0 END) AS QTY010
             , SUM(CASE WHEN XA.RN = 11 THEN A.QTY ELSE 0 END) AS QTY011
             , SUM(CASE WHEN XA.RN = 12 THEN A.QTY ELSE 0 END) AS QTY012
             , SUM(CASE WHEN XA.RN = 13 THEN A.QTY ELSE 0 END) AS QTY013
             , SUM(CASE WHEN XA.RN = 14 THEN A.QTY ELSE 0 END) AS QTY014
             , SUM(CASE WHEN XA.RN = 15 THEN A.QTY ELSE 0 END) AS QTY015
             , SUM(CASE WHEN XA.RN = 16 THEN A.QTY ELSE 0 END) AS QTY016
             , SUM(CASE WHEN XA.RN = 17 THEN A.QTY ELSE 0 END) AS QTY017
             , SUM(CASE WHEN XA.RN = 18 THEN A.QTY ELSE 0 END) AS QTY018
             , SUM(CASE WHEN XA.RN = 19 THEN A.QTY ELSE 0 END) AS QTY019
             , SUM(CASE WHEN XA.RN = 20 THEN A.QTY ELSE 0 END) AS QTY020
             , SUM(CASE WHEN XA.RN = 21 THEN A.QTY ELSE 0 END) AS QTY021
             , SUM(CASE WHEN XA.RN = 22 THEN A.QTY ELSE 0 END) AS QTY022
             , SUM(CASE WHEN XA.RN = 23 THEN A.QTY ELSE 0 END) AS QTY023
             , SUM(CASE WHEN XA.RN = 24 THEN A.QTY ELSE 0 END) AS QTY024
             , SUM(CASE WHEN XA.RN = 25 THEN A.QTY ELSE 0 END) AS QTY025
             , SUM(CASE WHEN XA.RN = 26 THEN A.QTY ELSE 0 END) AS QTY026
             , SUM(CASE WHEN XA.RN = 27 THEN A.QTY ELSE 0 END) AS QTY027
             , SUM(CASE WHEN XA.RN = 28 THEN A.QTY ELSE 0 END) AS QTY028
             , SUM(CASE WHEN XA.RN = 29 THEN A.QTY ELSE 0 END) AS QTY029
             , SUM(CASE WHEN XA.RN = 30 THEN A.QTY ELSE 0 END) AS QTY030
             , SUM(CASE WHEN XA.RN = 31 THEN A.QTY ELSE 0 END) AS QTY031
             , SUM(CASE WHEN XA.RN = 32 THEN A.QTY ELSE 0 END) AS QTY032
             , SUM(CASE WHEN XA.RN = 33 THEN A.QTY ELSE 0 END) AS QTY033
             , SUM(CASE WHEN XA.RN = 34 THEN A.QTY ELSE 0 END) AS QTY034
             , SUM(CASE WHEN XA.RN = 35 THEN A.QTY ELSE 0 END) AS QTY035
             , SUM(CASE WHEN XA.RN = 36 THEN A.QTY ELSE 0 END) AS QTY036
             , SUM(CASE WHEN XA.RN = 37 THEN A.QTY ELSE 0 END) AS QTY037
             , SUM(CASE WHEN XA.RN = 38 THEN A.QTY ELSE 0 END) AS QTY038
             , SUM(CASE WHEN XA.RN = 39 THEN A.QTY ELSE 0 END) AS QTY039
             , SUM(CASE WHEN XA.RN = 40 THEN A.QTY ELSE 0 END) AS QTY040
             , SUM(CASE WHEN XA.RN = 41 THEN A.QTY ELSE 0 END) AS QTY041
             , SUM(CASE WHEN XA.RN = 42 THEN A.QTY ELSE 0 END) AS QTY042
             , SUM(CASE WHEN XA.RN = 43 THEN A.QTY ELSE 0 END) AS QTY043
             , SUM(CASE WHEN XA.RN = 44 THEN A.QTY ELSE 0 END) AS QTY044
             , SUM(CASE WHEN XA.RN = 45 THEN A.QTY ELSE 0 END) AS QTY045
             , SUM(CASE WHEN XA.RN = 46 THEN A.QTY ELSE 0 END) AS QTY046
             , SUM(CASE WHEN XA.RN = 47 THEN A.QTY ELSE 0 END) AS QTY047
             , SUM(CASE WHEN XA.RN = 48 THEN A.QTY ELSE 0 END) AS QTY048
             , SUM(CASE WHEN XA.RN = 49 THEN A.QTY ELSE 0 END) AS QTY049
             , SUM(CASE WHEN XA.RN = 50 THEN A.QTY ELSE 0 END) AS QTY050
             , SUM(CASE WHEN XA.RN = 51 THEN A.QTY ELSE 0 END) AS QTY051
             , SUM(CASE WHEN XA.RN = 52 THEN A.QTY ELSE 0 END) AS QTY052
             , SUM(CASE WHEN XA.RN = 53 THEN A.QTY ELSE 0 END) AS QTY053
             , SUM(CASE WHEN XA.RN = 54 THEN A.QTY ELSE 0 END) AS QTY054
             , SUM(CASE WHEN XA.RN = 55 THEN A.QTY ELSE 0 END) AS QTY055
             , SUM(CASE WHEN XA.RN = 56 THEN A.QTY ELSE 0 END) AS QTY056
             , SUM(CASE WHEN XA.RN = 57 THEN A.QTY ELSE 0 END) AS QTY057
             , SUM(CASE WHEN XA.RN = 58 THEN A.QTY ELSE 0 END) AS QTY058
             , SUM(CASE WHEN XA.RN = 59 THEN A.QTY ELSE 0 END) AS QTY059
             , SUM(CASE WHEN XA.RN = 60 THEN A.QTY ELSE 0 END) AS QTY060
             , SUM(CASE WHEN XA.RN = 61 THEN A.QTY ELSE 0 END) AS QTY061
             , SUM(CASE WHEN XA.RN = 62 THEN A.QTY ELSE 0 END) AS QTY062
             , SUM(CASE WHEN XA.RN = 63 THEN A.QTY ELSE 0 END) AS QTY063
             , SUM(CASE WHEN XA.RN = 64 THEN A.QTY ELSE 0 END) AS QTY064
             , SUM(CASE WHEN XA.RN = 65 THEN A.QTY ELSE 0 END) AS QTY065
             , SUM(CASE WHEN XA.RN = 66 THEN A.QTY ELSE 0 END) AS QTY066
             , SUM(CASE WHEN XA.RN = 67 THEN A.QTY ELSE 0 END) AS QTY067
             , SUM(CASE WHEN XA.RN = 68 THEN A.QTY ELSE 0 END) AS QTY068
             , SUM(CASE WHEN XA.RN = 69 THEN A.QTY ELSE 0 END) AS QTY069
             , SUM(CASE WHEN XA.RN = 70 THEN A.QTY ELSE 0 END) AS QTY070
             , SUM(CASE WHEN XA.RN = 71 THEN A.QTY ELSE 0 END) AS QTY071
             , SUM(CASE WHEN XA.RN = 72 THEN A.QTY ELSE 0 END) AS QTY072
             , SUM(CASE WHEN XA.RN = 73 THEN A.QTY ELSE 0 END) AS QTY073
             , SUM(CASE WHEN XA.RN = 74 THEN A.QTY ELSE 0 END) AS QTY074
             , SUM(CASE WHEN XA.RN = 75 THEN A.QTY ELSE 0 END) AS QTY075
             , SUM(CASE WHEN XA.RN = 76 THEN A.QTY ELSE 0 END) AS QTY076
             , SUM(CASE WHEN XA.RN = 77 THEN A.QTY ELSE 0 END) AS QTY077
             , SUM(CASE WHEN XA.RN = 78 THEN A.QTY ELSE 0 END) AS QTY078
             , SUM(CASE WHEN XA.RN = 79 THEN A.QTY ELSE 0 END) AS QTY079
             , SUM(CASE WHEN XA.RN = 80 THEN A.QTY ELSE 0 END) AS QTY080
             , SUM(CASE WHEN XA.RN = 81 THEN A.QTY ELSE 0 END) AS QTY081
             , SUM(CASE WHEN XA.RN = 82 THEN A.QTY ELSE 0 END) AS QTY082
             , SUM(CASE WHEN XA.RN = 83 THEN A.QTY ELSE 0 END) AS QTY083
             , SUM(CASE WHEN XA.RN = 84 THEN A.QTY ELSE 0 END) AS QTY084
             , SUM(CASE WHEN XA.RN = 85 THEN A.QTY ELSE 0 END) AS QTY085
             , SUM(CASE WHEN XA.RN = 86 THEN A.QTY ELSE 0 END) AS QTY086
             , SUM(CASE WHEN XA.RN = 87 THEN A.QTY ELSE 0 END) AS QTY087
             , SUM(CASE WHEN XA.RN = 88 THEN A.QTY ELSE 0 END) AS QTY088
             , SUM(CASE WHEN XA.RN = 89 THEN A.QTY ELSE 0 END) AS QTY089
             , SUM(CASE WHEN XA.RN = 90 THEN A.QTY ELSE 0 END) AS QTY090
             , SUM(CASE WHEN XA.RN = 91 THEN A.QTY ELSE 0 END) AS QTY091
             , SUM(CASE WHEN XA.RN = 92 THEN A.QTY ELSE 0 END) AS QTY092
             , SUM(CASE WHEN XA.RN = 93 THEN A.QTY ELSE 0 END) AS QTY093
             , SUM(CASE WHEN XA.RN = 94 THEN A.QTY ELSE 0 END) AS QTY094
             , SUM(CASE WHEN XA.RN = 95 THEN A.QTY ELSE 0 END) AS QTY095
             , SUM(CASE WHEN XA.RN = 96 THEN A.QTY ELSE 0 END) AS QTY096
             , SUM(CASE WHEN XA.RN = 97 THEN A.QTY ELSE 0 END) AS QTY097
             , SUM(CASE WHEN XA.RN = 98 THEN A.QTY ELSE 0 END) AS QTY098
             , SUM(CASE WHEN XA.RN = 99 THEN A.QTY ELSE 0 END) AS QTY099
             , SUM(CASE WHEN XA.RN = 100 THEN A.QTY ELSE 0 END) AS QTY100
             , SUM(CASE WHEN XA.RN = 101 THEN A.QTY ELSE 0 END) AS QTY101
             , SUM(CASE WHEN XA.RN = 102 THEN A.QTY ELSE 0 END) AS QTY102
             , SUM(CASE WHEN XA.RN = 103 THEN A.QTY ELSE 0 END) AS QTY103
             , SUM(CASE WHEN XA.RN = 104 THEN A.QTY ELSE 0 END) AS QTY104
             , SUM(CASE WHEN XA.RN = 105 THEN A.QTY ELSE 0 END) AS QTY105
             , SUM(CASE WHEN XA.RN = 106 THEN A.QTY ELSE 0 END) AS QTY106
             , SUM(CASE WHEN XA.RN = 107 THEN A.QTY ELSE 0 END) AS QTY107
             , SUM(CASE WHEN XA.RN = 108 THEN A.QTY ELSE 0 END) AS QTY108
             , SUM(CASE WHEN XA.RN = 109 THEN A.QTY ELSE 0 END) AS QTY109
             , SUM(CASE WHEN XA.RN = 110 THEN A.QTY ELSE 0 END) AS QTY110
             , SUM(CASE WHEN XA.RN = 111 THEN A.QTY ELSE 0 END) AS QTY111
             , SUM(CASE WHEN XA.RN = 112 THEN A.QTY ELSE 0 END) AS QTY112
             , SUM(CASE WHEN XA.RN = 113 THEN A.QTY ELSE 0 END) AS QTY113
             , SUM(CASE WHEN XA.RN = 114 THEN A.QTY ELSE 0 END) AS QTY114
             , SUM(CASE WHEN XA.RN = 115 THEN A.QTY ELSE 0 END) AS QTY115
             , SUM(CASE WHEN XA.RN = 116 THEN A.QTY ELSE 0 END) AS QTY116
             , SUM(CASE WHEN XA.RN = 117 THEN A.QTY ELSE 0 END) AS QTY117
             , SUM(CASE WHEN XA.RN = 118 THEN A.QTY ELSE 0 END) AS QTY118
             , SUM(CASE WHEN XA.RN = 119 THEN A.QTY ELSE 0 END) AS QTY119
             , SUM(CASE WHEN XA.RN = 120 THEN A.QTY ELSE 0 END) AS QTY120
             , SUM(CASE WHEN XA.RN = 121 THEN A.QTY ELSE 0 END) AS QTY121
             , SUM(CASE WHEN XA.RN = 122 THEN A.QTY ELSE 0 END) AS QTY122
             , SUM(CASE WHEN XA.RN = 123 THEN A.QTY ELSE 0 END) AS QTY123
             , SUM(CASE WHEN XA.RN = 124 THEN A.QTY ELSE 0 END) AS QTY124
             , SUM(CASE WHEN XA.RN = 125 THEN A.QTY ELSE 0 END) AS QTY125
             , SUM(CASE WHEN XA.RN = 126 THEN A.QTY ELSE 0 END) AS QTY126
             , SUM(CASE WHEN XA.RN = 127 THEN A.QTY ELSE 0 END) AS QTY127
             , SUM(CASE WHEN XA.RN = 128 THEN A.QTY ELSE 0 END) AS QTY128
             , SUM(CASE WHEN XA.RN = 129 THEN A.QTY ELSE 0 END) AS QTY129
             , SUM(CASE WHEN XA.RN = 130 THEN A.QTY ELSE 0 END) AS QTY130
             , SUM(CASE WHEN XA.RN = 131 THEN A.QTY ELSE 0 END) AS QTY131
             , SUM(CASE WHEN XA.RN = 132 THEN A.QTY ELSE 0 END) AS QTY132
             , SUM(CASE WHEN XA.RN = 133 THEN A.QTY ELSE 0 END) AS QTY133
             , SUM(CASE WHEN XA.RN = 134 THEN A.QTY ELSE 0 END) AS QTY134
             , SUM(CASE WHEN XA.RN = 135 THEN A.QTY ELSE 0 END) AS QTY135
             , SUM(CASE WHEN XA.RN = 136 THEN A.QTY ELSE 0 END) AS QTY136
             , SUM(CASE WHEN XA.RN = 137 THEN A.QTY ELSE 0 END) AS QTY137
             , SUM(CASE WHEN XA.RN = 138 THEN A.QTY ELSE 0 END) AS QTY138
             , SUM(CASE WHEN XA.RN = 139 THEN A.QTY ELSE 0 END) AS QTY139
             , SUM(CASE WHEN XA.RN = 140 THEN A.QTY ELSE 0 END) AS QTY140
             , SUM(CASE WHEN XA.RN = 141 THEN A.QTY ELSE 0 END) AS QTY141
             , SUM(CASE WHEN XA.RN = 142 THEN A.QTY ELSE 0 END) AS QTY142
             , SUM(CASE WHEN XA.RN = 143 THEN A.QTY ELSE 0 END) AS QTY143
             , SUM(CASE WHEN XA.RN = 144 THEN A.QTY ELSE 0 END) AS QTY144
             , SUM(CASE WHEN XA.RN = 145 THEN A.QTY ELSE 0 END) AS QTY145
             , SUM(CASE WHEN XA.RN = 146 THEN A.QTY ELSE 0 END) AS QTY146
             , SUM(CASE WHEN XA.RN = 147 THEN A.QTY ELSE 0 END) AS QTY147
             , SUM(CASE WHEN XA.RN = 148 THEN A.QTY ELSE 0 END) AS QTY148
             , SUM(CASE WHEN XA.RN = 149 THEN A.QTY ELSE 0 END) AS QTY149
             , SUM(CASE WHEN XA.RN = 150 THEN A.QTY ELSE 0 END) AS QTY150
             , SUM(CASE WHEN XA.RN = 151 THEN A.QTY ELSE 0 END) AS QTY151
             , SUM(CASE WHEN XA.RN = 152 THEN A.QTY ELSE 0 END) AS QTY152
             , SUM(CASE WHEN XA.RN = 153 THEN A.QTY ELSE 0 END) AS QTY153
             , SUM(CASE WHEN XA.RN = 154 THEN A.QTY ELSE 0 END) AS QTY154
             , SUM(CASE WHEN XA.RN = 155 THEN A.QTY ELSE 0 END) AS QTY155
             , SUM(CASE WHEN XA.RN = 156 THEN A.QTY ELSE 0 END) AS QTY156
             , SUM(CASE WHEN XA.RN = 157 THEN A.QTY ELSE 0 END) AS QTY157
             , SUM(CASE WHEN XA.RN = 158 THEN A.QTY ELSE 0 END) AS QTY158
             , SUM(CASE WHEN XA.RN = 159 THEN A.QTY ELSE 0 END) AS QTY159
             , SUM(CASE WHEN XA.RN = 160 THEN A.QTY ELSE 0 END) AS QTY160
             , SUM(CASE WHEN XA.RN = 161 THEN A.QTY ELSE 0 END) AS QTY161
             , SUM(CASE WHEN XA.RN = 162 THEN A.QTY ELSE 0 END) AS QTY162
             , SUM(CASE WHEN XA.RN = 163 THEN A.QTY ELSE 0 END) AS QTY163
             , SUM(CASE WHEN XA.RN = 164 THEN A.QTY ELSE 0 END) AS QTY164
             , SUM(CASE WHEN XA.RN = 165 THEN A.QTY ELSE 0 END) AS QTY165
             , SUM(CASE WHEN XA.RN = 166 THEN A.QTY ELSE 0 END) AS QTY166
             , SUM(CASE WHEN XA.RN = 167 THEN A.QTY ELSE 0 END) AS QTY167
             , SUM(CASE WHEN XA.RN = 168 THEN A.QTY ELSE 0 END) AS QTY168
             , SUM(CASE WHEN XA.RN = 169 THEN A.QTY ELSE 0 END) AS QTY169
             , SUM(CASE WHEN XA.RN = 170 THEN A.QTY ELSE 0 END) AS QTY170
             , SUM(CASE WHEN XA.RN = 171 THEN A.QTY ELSE 0 END) AS QTY171
             , SUM(CASE WHEN XA.RN = 172 THEN A.QTY ELSE 0 END) AS QTY172
             , SUM(CASE WHEN XA.RN = 173 THEN A.QTY ELSE 0 END) AS QTY173
             , SUM(CASE WHEN XA.RN = 174 THEN A.QTY ELSE 0 END) AS QTY174
             , SUM(CASE WHEN XA.RN = 175 THEN A.QTY ELSE 0 END) AS QTY175
             , SUM(CASE WHEN XA.RN = 176 THEN A.QTY ELSE 0 END) AS QTY176
             , SUM(CASE WHEN XA.RN = 177 THEN A.QTY ELSE 0 END) AS QTY177
             , SUM(CASE WHEN XA.RN = 178 THEN A.QTY ELSE 0 END) AS QTY178
             , SUM(CASE WHEN XA.RN = 179 THEN A.QTY ELSE 0 END) AS QTY179
             , SUM(CASE WHEN XA.RN = 180 THEN A.QTY ELSE 0 END) AS QTY180
             , SUM(CASE WHEN XA.RN = 181 THEN A.QTY ELSE 0 END) AS QTY181
             , SUM(CASE WHEN XA.RN = 182 THEN A.QTY ELSE 0 END) AS QTY182
             , SUM(CASE WHEN XA.RN = 183 THEN A.QTY ELSE 0 END) AS QTY183
             , SUM(CASE WHEN XA.RN = 184 THEN A.QTY ELSE 0 END) AS QTY184
             , SUM(CASE WHEN XA.RN = 185 THEN A.QTY ELSE 0 END) AS QTY185
             , SUM(CASE WHEN XA.RN = 186 THEN A.QTY ELSE 0 END) AS QTY186
             , SUM(CASE WHEN XA.RN = 187 THEN A.QTY ELSE 0 END) AS QTY187
             , SUM(CASE WHEN XA.RN = 188 THEN A.QTY ELSE 0 END) AS QTY188
             , SUM(CASE WHEN XA.RN = 189 THEN A.QTY ELSE 0 END) AS QTY189
             , SUM(CASE WHEN XA.RN = 190 THEN A.QTY ELSE 0 END) AS QTY190
             , SUM(CASE WHEN XA.RN = 191 THEN A.QTY ELSE 0 END) AS QTY191
             , SUM(CASE WHEN XA.RN = 192 THEN A.QTY ELSE 0 END) AS QTY192
             , SUM(CASE WHEN XA.RN = 193 THEN A.QTY ELSE 0 END) AS QTY193
             , SUM(CASE WHEN XA.RN = 194 THEN A.QTY ELSE 0 END) AS QTY194
             , SUM(CASE WHEN XA.RN = 195 THEN A.QTY ELSE 0 END) AS QTY195
             , SUM(CASE WHEN XA.RN = 196 THEN A.QTY ELSE 0 END) AS QTY196
             , SUM(CASE WHEN XA.RN = 197 THEN A.QTY ELSE 0 END) AS QTY197
             , SUM(CASE WHEN XA.RN = 198 THEN A.QTY ELSE 0 END) AS QTY198
             , SUM(CASE WHEN XA.RN = 199 THEN A.QTY ELSE 0 END) AS QTY199
             , SUM(CASE WHEN XA.RN = 200 THEN A.QTY ELSE 0 END) AS QTY200
             , SUM(CASE WHEN XA.RN = 201 THEN A.QTY ELSE 0 END) AS QTY201
             , SUM(CASE WHEN XA.RN = 202 THEN A.QTY ELSE 0 END) AS QTY202
             , SUM(CASE WHEN XA.RN = 203 THEN A.QTY ELSE 0 END) AS QTY203
             , SUM(CASE WHEN XA.RN = 204 THEN A.QTY ELSE 0 END) AS QTY204
             , SUM(CASE WHEN XA.RN = 205 THEN A.QTY ELSE 0 END) AS QTY205
             , SUM(CASE WHEN XA.RN = 206 THEN A.QTY ELSE 0 END) AS QTY206
             , SUM(CASE WHEN XA.RN = 207 THEN A.QTY ELSE 0 END) AS QTY207
             , SUM(CASE WHEN XA.RN = 208 THEN A.QTY ELSE 0 END) AS QTY208
             , SUM(CASE WHEN XA.RN = 209 THEN A.QTY ELSE 0 END) AS QTY209
             , SUM(CASE WHEN XA.RN = 210 THEN A.QTY ELSE 0 END) AS QTY210
             , SUM(CASE WHEN XA.RN = 211 THEN A.QTY ELSE 0 END) AS QTY211
             , SUM(CASE WHEN XA.RN = 212 THEN A.QTY ELSE 0 END) AS QTY212
             , SUM(CASE WHEN XA.RN = 213 THEN A.QTY ELSE 0 END) AS QTY213
             , SUM(CASE WHEN XA.RN = 214 THEN A.QTY ELSE 0 END) AS QTY214
             , SUM(CASE WHEN XA.RN = 215 THEN A.QTY ELSE 0 END) AS QTY215
             , SUM(CASE WHEN XA.RN = 216 THEN A.QTY ELSE 0 END) AS QTY216
             , SUM(CASE WHEN XA.RN = 217 THEN A.QTY ELSE 0 END) AS QTY217
             , SUM(CASE WHEN XA.RN = 218 THEN A.QTY ELSE 0 END) AS QTY218
             , SUM(CASE WHEN XA.RN = 219 THEN A.QTY ELSE 0 END) AS QTY219
             , SUM(CASE WHEN XA.RN = 220 THEN A.QTY ELSE 0 END) AS QTY220
             , SUM(CASE WHEN XA.RN = 221 THEN A.QTY ELSE 0 END) AS QTY221
             , SUM(CASE WHEN XA.RN = 222 THEN A.QTY ELSE 0 END) AS QTY222
             , SUM(CASE WHEN XA.RN = 223 THEN A.QTY ELSE 0 END) AS QTY223
             , SUM(CASE WHEN XA.RN = 224 THEN A.QTY ELSE 0 END) AS QTY224
             , SUM(CASE WHEN XA.RN = 225 THEN A.QTY ELSE 0 END) AS QTY225
             , SUM(CASE WHEN XA.RN = 226 THEN A.QTY ELSE 0 END) AS QTY226
             , SUM(CASE WHEN XA.RN = 227 THEN A.QTY ELSE 0 END) AS QTY227
             , SUM(CASE WHEN XA.RN = 228 THEN A.QTY ELSE 0 END) AS QTY228
             , SUM(CASE WHEN XA.RN = 229 THEN A.QTY ELSE 0 END) AS QTY229
             , SUM(CASE WHEN XA.RN = 230 THEN A.QTY ELSE 0 END) AS QTY230
             , SUM(CASE WHEN XA.RN = 231 THEN A.QTY ELSE 0 END) AS QTY231
             , SUM(CASE WHEN XA.RN = 232 THEN A.QTY ELSE 0 END) AS QTY232
             , SUM(CASE WHEN XA.RN = 233 THEN A.QTY ELSE 0 END) AS QTY233
             , SUM(CASE WHEN XA.RN = 234 THEN A.QTY ELSE 0 END) AS QTY234
             , SUM(CASE WHEN XA.RN = 235 THEN A.QTY ELSE 0 END) AS QTY235
             , SUM(CASE WHEN XA.RN = 236 THEN A.QTY ELSE 0 END) AS QTY236
             , SUM(CASE WHEN XA.RN = 237 THEN A.QTY ELSE 0 END) AS QTY237
             , SUM(CASE WHEN XA.RN = 238 THEN A.QTY ELSE 0 END) AS QTY238
             , SUM(CASE WHEN XA.RN = 239 THEN A.QTY ELSE 0 END) AS QTY239
             , SUM(CASE WHEN XA.RN = 240 THEN A.QTY ELSE 0 END) AS QTY240
             , SUM(CASE WHEN XA.RN = 241 THEN A.QTY ELSE 0 END) AS QTY241
             , SUM(CASE WHEN XA.RN = 242 THEN A.QTY ELSE 0 END) AS QTY242
             , SUM(CASE WHEN XA.RN = 243 THEN A.QTY ELSE 0 END) AS QTY243
             , SUM(CASE WHEN XA.RN = 244 THEN A.QTY ELSE 0 END) AS QTY244
             , SUM(CASE WHEN XA.RN = 245 THEN A.QTY ELSE 0 END) AS QTY245
             , SUM(CASE WHEN XA.RN = 246 THEN A.QTY ELSE 0 END) AS QTY246
             , SUM(CASE WHEN XA.RN = 247 THEN A.QTY ELSE 0 END) AS QTY247
             , SUM(CASE WHEN XA.RN = 248 THEN A.QTY ELSE 0 END) AS QTY248
             , SUM(CASE WHEN XA.RN = 249 THEN A.QTY ELSE 0 END) AS QTY249
             , SUM(CASE WHEN XA.RN = 250 THEN A.QTY ELSE 0 END) AS QTY250
             , SUM(CASE WHEN XA.RN = 251 THEN A.QTY ELSE 0 END) AS QTY251
             , SUM(CASE WHEN XA.RN = 252 THEN A.QTY ELSE 0 END) AS QTY252
             , SUM(CASE WHEN XA.RN = 253 THEN A.QTY ELSE 0 END) AS QTY253
             , SUM(CASE WHEN XA.RN = 254 THEN A.QTY ELSE 0 END) AS QTY254
             , SUM(CASE WHEN XA.RN = 255 THEN A.QTY ELSE 0 END) AS QTY255
             , SUM(CASE WHEN XA.RN = 256 THEN A.QTY ELSE 0 END) AS QTY256
             , SUM(CASE WHEN XA.RN = 257 THEN A.QTY ELSE 0 END) AS QTY257
             , SUM(CASE WHEN XA.RN = 258 THEN A.QTY ELSE 0 END) AS QTY258
             , SUM(CASE WHEN XA.RN = 259 THEN A.QTY ELSE 0 END) AS QTY259
             , SUM(CASE WHEN XA.RN = 260 THEN A.QTY ELSE 0 END) AS QTY260
             , SUM(CASE WHEN XA.RN = 261 THEN A.QTY ELSE 0 END) AS QTY261
             , SUM(CASE WHEN XA.RN = 262 THEN A.QTY ELSE 0 END) AS QTY262
             , SUM(CASE WHEN XA.RN = 263 THEN A.QTY ELSE 0 END) AS QTY263
             , SUM(CASE WHEN XA.RN = 264 THEN A.QTY ELSE 0 END) AS QTY264
             , SUM(CASE WHEN XA.RN = 265 THEN A.QTY ELSE 0 END) AS QTY265
             , SUM(CASE WHEN XA.RN = 266 THEN A.QTY ELSE 0 END) AS QTY266
             , SUM(CASE WHEN XA.RN = 267 THEN A.QTY ELSE 0 END) AS QTY267
             , SUM(CASE WHEN XA.RN = 268 THEN A.QTY ELSE 0 END) AS QTY268
             , SUM(CASE WHEN XA.RN = 269 THEN A.QTY ELSE 0 END) AS QTY269
             , SUM(CASE WHEN XA.RN = 270 THEN A.QTY ELSE 0 END) AS QTY270
             , SUM(CASE WHEN XA.RN = 271 THEN A.QTY ELSE 0 END) AS QTY271
             , SUM(CASE WHEN XA.RN = 272 THEN A.QTY ELSE 0 END) AS QTY272
             , SUM(CASE WHEN XA.RN = 273 THEN A.QTY ELSE 0 END) AS QTY273
             , SUM(CASE WHEN XA.RN = 274 THEN A.QTY ELSE 0 END) AS QTY274
             , SUM(CASE WHEN XA.RN = 275 THEN A.QTY ELSE 0 END) AS QTY275
             , SUM(CASE WHEN XA.RN = 276 THEN A.QTY ELSE 0 END) AS QTY276
             , SUM(CASE WHEN XA.RN = 277 THEN A.QTY ELSE 0 END) AS QTY277
             , SUM(CASE WHEN XA.RN = 278 THEN A.QTY ELSE 0 END) AS QTY278
             , SUM(CASE WHEN XA.RN = 279 THEN A.QTY ELSE 0 END) AS QTY279
             , SUM(CASE WHEN XA.RN = 280 THEN A.QTY ELSE 0 END) AS QTY280
             , SUM(CASE WHEN XA.RN = 281 THEN A.QTY ELSE 0 END) AS QTY281
             , SUM(CASE WHEN XA.RN = 282 THEN A.QTY ELSE 0 END) AS QTY282
             , SUM(CASE WHEN XA.RN = 283 THEN A.QTY ELSE 0 END) AS QTY283
             , SUM(CASE WHEN XA.RN = 284 THEN A.QTY ELSE 0 END) AS QTY284
             , SUM(CASE WHEN XA.RN = 285 THEN A.QTY ELSE 0 END) AS QTY285
             , SUM(CASE WHEN XA.RN = 286 THEN A.QTY ELSE 0 END) AS QTY286
             , SUM(CASE WHEN XA.RN = 287 THEN A.QTY ELSE 0 END) AS QTY287
             , SUM(CASE WHEN XA.RN = 288 THEN A.QTY ELSE 0 END) AS QTY288
             , SUM(CASE WHEN XA.RN = 289 THEN A.QTY ELSE 0 END) AS QTY289
             , SUM(CASE WHEN XA.RN = 290 THEN A.QTY ELSE 0 END) AS QTY290
             , SUM(CASE WHEN XA.RN = 291 THEN A.QTY ELSE 0 END) AS QTY291
             , SUM(CASE WHEN XA.RN = 292 THEN A.QTY ELSE 0 END) AS QTY292
             , SUM(CASE WHEN XA.RN = 293 THEN A.QTY ELSE 0 END) AS QTY293
             , SUM(CASE WHEN XA.RN = 294 THEN A.QTY ELSE 0 END) AS QTY294
             , SUM(CASE WHEN XA.RN = 295 THEN A.QTY ELSE 0 END) AS QTY295
             , SUM(CASE WHEN XA.RN = 296 THEN A.QTY ELSE 0 END) AS QTY296
             , SUM(CASE WHEN XA.RN = 297 THEN A.QTY ELSE 0 END) AS QTY297
             , SUM(CASE WHEN XA.RN = 298 THEN A.QTY ELSE 0 END) AS QTY298
             , SUM(CASE WHEN XA.RN = 299 THEN A.QTY ELSE 0 END) AS QTY299
             , SUM(CASE WHEN XA.RN = 300 THEN A.QTY ELSE 0 END) AS QTY300
             , SUM(CASE WHEN XA.RN = 301 THEN A.QTY ELSE 0 END) AS QTY301
             , SUM(CASE WHEN XA.RN = 302 THEN A.QTY ELSE 0 END) AS QTY302
             , SUM(CASE WHEN XA.RN = 303 THEN A.QTY ELSE 0 END) AS QTY303
             , SUM(CASE WHEN XA.RN = 304 THEN A.QTY ELSE 0 END) AS QTY304
             , SUM(CASE WHEN XA.RN = 305 THEN A.QTY ELSE 0 END) AS QTY305
             , SUM(CASE WHEN XA.RN = 306 THEN A.QTY ELSE 0 END) AS QTY306
             , SUM(CASE WHEN XA.RN = 307 THEN A.QTY ELSE 0 END) AS QTY307
             , SUM(CASE WHEN XA.RN = 308 THEN A.QTY ELSE 0 END) AS QTY308
             , SUM(CASE WHEN XA.RN = 309 THEN A.QTY ELSE 0 END) AS QTY309
             , SUM(CASE WHEN XA.RN = 310 THEN A.QTY ELSE 0 END) AS QTY310
             , SUM(CASE WHEN XA.RN = 311 THEN A.QTY ELSE 0 END) AS QTY311
             , SUM(CASE WHEN XA.RN = 312 THEN A.QTY ELSE 0 END) AS QTY312
             , SUM(CASE WHEN XA.RN = 313 THEN A.QTY ELSE 0 END) AS QTY313
             , SUM(CASE WHEN XA.RN = 314 THEN A.QTY ELSE 0 END) AS QTY314
             , SUM(CASE WHEN XA.RN = 315 THEN A.QTY ELSE 0 END) AS QTY315
             , SUM(CASE WHEN XA.RN = 316 THEN A.QTY ELSE 0 END) AS QTY316
             , SUM(CASE WHEN XA.RN = 317 THEN A.QTY ELSE 0 END) AS QTY317
             , SUM(CASE WHEN XA.RN = 318 THEN A.QTY ELSE 0 END) AS QTY318
             , SUM(CASE WHEN XA.RN = 319 THEN A.QTY ELSE 0 END) AS QTY319
             , SUM(CASE WHEN XA.RN = 320 THEN A.QTY ELSE 0 END) AS QTY320
             , SUM(CASE WHEN XA.RN = 321 THEN A.QTY ELSE 0 END) AS QTY321
             , SUM(CASE WHEN XA.RN = 322 THEN A.QTY ELSE 0 END) AS QTY322
             , SUM(CASE WHEN XA.RN = 323 THEN A.QTY ELSE 0 END) AS QTY323
             , SUM(CASE WHEN XA.RN = 324 THEN A.QTY ELSE 0 END) AS QTY324
             , SUM(CASE WHEN XA.RN = 325 THEN A.QTY ELSE 0 END) AS QTY325
             , SUM(CASE WHEN XA.RN = 326 THEN A.QTY ELSE 0 END) AS QTY326
             , SUM(CASE WHEN XA.RN = 327 THEN A.QTY ELSE 0 END) AS QTY327
             , SUM(CASE WHEN XA.RN = 328 THEN A.QTY ELSE 0 END) AS QTY328
             , SUM(CASE WHEN XA.RN = 329 THEN A.QTY ELSE 0 END) AS QTY329
             , SUM(CASE WHEN XA.RN = 330 THEN A.QTY ELSE 0 END) AS QTY330
             , SUM(CASE WHEN XA.RN = 331 THEN A.QTY ELSE 0 END) AS QTY331
             , SUM(CASE WHEN XA.RN = 332 THEN A.QTY ELSE 0 END) AS QTY332
             , SUM(CASE WHEN XA.RN = 333 THEN A.QTY ELSE 0 END) AS QTY333
             , SUM(CASE WHEN XA.RN = 334 THEN A.QTY ELSE 0 END) AS QTY334
             , SUM(CASE WHEN XA.RN = 335 THEN A.QTY ELSE 0 END) AS QTY335
             , SUM(CASE WHEN XA.RN = 336 THEN A.QTY ELSE 0 END) AS QTY336
             , SUM(CASE WHEN XA.RN = 337 THEN A.QTY ELSE 0 END) AS QTY337
             , SUM(CASE WHEN XA.RN = 338 THEN A.QTY ELSE 0 END) AS QTY338
             , SUM(CASE WHEN XA.RN = 339 THEN A.QTY ELSE 0 END) AS QTY339
             , SUM(CASE WHEN XA.RN = 340 THEN A.QTY ELSE 0 END) AS QTY340
             , SUM(CASE WHEN XA.RN = 341 THEN A.QTY ELSE 0 END) AS QTY341
             , SUM(CASE WHEN XA.RN = 342 THEN A.QTY ELSE 0 END) AS QTY342
             , SUM(CASE WHEN XA.RN = 343 THEN A.QTY ELSE 0 END) AS QTY343
             , SUM(CASE WHEN XA.RN = 344 THEN A.QTY ELSE 0 END) AS QTY344
             , SUM(CASE WHEN XA.RN = 345 THEN A.QTY ELSE 0 END) AS QTY345
             , SUM(CASE WHEN XA.RN = 346 THEN A.QTY ELSE 0 END) AS QTY346
             , SUM(CASE WHEN XA.RN = 347 THEN A.QTY ELSE 0 END) AS QTY347
             , SUM(CASE WHEN XA.RN = 348 THEN A.QTY ELSE 0 END) AS QTY348
             , SUM(CASE WHEN XA.RN = 349 THEN A.QTY ELSE 0 END) AS QTY349
             , SUM(CASE WHEN XA.RN = 350 THEN A.QTY ELSE 0 END) AS QTY350
             , SUM(CASE WHEN XA.RN = 351 THEN A.QTY ELSE 0 END) AS QTY351
             , SUM(CASE WHEN XA.RN = 352 THEN A.QTY ELSE 0 END) AS QTY352
             , SUM(CASE WHEN XA.RN = 353 THEN A.QTY ELSE 0 END) AS QTY353
             , SUM(CASE WHEN XA.RN = 354 THEN A.QTY ELSE 0 END) AS QTY354
             , SUM(CASE WHEN XA.RN = 355 THEN A.QTY ELSE 0 END) AS QTY355
             , SUM(CASE WHEN XA.RN = 356 THEN A.QTY ELSE 0 END) AS QTY356
             , SUM(CASE WHEN XA.RN = 357 THEN A.QTY ELSE 0 END) AS QTY357
             , SUM(CASE WHEN XA.RN = 358 THEN A.QTY ELSE 0 END) AS QTY358
             , SUM(CASE WHEN XA.RN = 359 THEN A.QTY ELSE 0 END) AS QTY359
             , SUM(CASE WHEN XA.RN = 360 THEN A.QTY ELSE 0 END) AS QTY360
             , SUM(CASE WHEN XA.RN = 361 THEN A.QTY ELSE 0 END) AS QTY361
             , SUM(CASE WHEN XA.RN = 362 THEN A.QTY ELSE 0 END) AS QTY362
             , SUM(CASE WHEN XA.RN = 363 THEN A.QTY ELSE 0 END) AS QTY363
             , SUM(CASE WHEN XA.RN = 364 THEN A.QTY ELSE 0 END) AS QTY364
             , A.ATTRIBUTE1
             , NULL                                                          AS ATTRIBUTE2
             , NULL                                                          AS ATTRIBUTE3
             , NULL                                                          AS ATTRIBUTE4
             , NULL                                                          AS ATTRIBUTE5
             , NULL                                                          AS ATTRIBUTE6
             , NULL                                                          AS ATTRIBUTE7
             , NULL                                                          AS ATTRIBUTE8
             , A.ATTRIBUTE9
             , NULL                                                          AS ATTRIBUTE10
          FROM GT_XGLB_PSI_GLOBAL_AUTO A
             , GT_XGLB_BOD_V           B
             , (SELECT IA.YYYYMMDD
                     , ROW_NUMBER() OVER(ORDER BY IA.YYYYMMDD) AS RN
                  FROM (SELECT BASIS_YYYYMMDD AS YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M
                         WHERE BASIS_YYYYMMDD >= V_CREATE_FROM_YYYYMMDD
                           AND BASIS_YYYYMMDD <= V_CREATE_TO_YYYYMMDD
                         GROUP BY BASIS_YYYYMMDD
                       ) IA
               )                       XA
         WHERE 0 = 0
           AND A.DIVISION_ID = B.DIVISION_ID(+)
           AND A.BOD_ID      = B.BOD_ID(+)
           AND A.FROM_SITE   = B.FROM_SITE(+)
           AND A.TO_SITE     = B.TO_SITE(+)
           AND A.INCOTERMS   = B.INCOTERMS(+)
           AND A.YYYYMMDD    = XA.YYYYMMDD(+)
           /* -- 튜닝 - start */
           /* --SET @mEXEC = @mEXEC + '	   WHERE A.YYYYMMDD    = ''' + @p_create_from_yyyymmdd  + ''''+CHAR(10);		-- 52 구간별 처리 */
           AND A.YYYYMMDD BETWEEN V_CREATE_FROM_YYYYMMDD AND V_CREATE_TO_YYYYMMDD   /* -- 52 구간별 처리 */
           /* --SET @mEXEC = @mEXEC + '	      OR A.QTY         <> 0 '+CHAR(10); */
           /* -- 튜닝 - end */
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.CELL_ITEM_ID
                , A.ITEM_ID
                , A.TO_SITE
                , A.PROJECT_CODE
                , A.TO_BOH_QTY
                , A.FROM_BOH_QTY
                , A.INCOTERMS
                , A.FROM_SITE
                , NVL(A.TRANSPORT_MODE, '-')
                , NVL(A.PROD_LINE, '-')
                , A.BOD_ID
                , A.MEASURE
                , A.SORT_ORDER_NO
                , A.COLUMN_LABEL_NAME
                , (CASE WHEN A.BOD_ID = '-' THEN 0 ELSE B.LT_TOTAL_BY_WEEK END)
                , A.ATTRIBUTE1
                /* --, A.ATTRIBUTE2 */
                /* --, A.ATTRIBUTE3 */
                /* --, A.ATTRIBUTE4 */
                /* --, A.ATTRIBUTE5 */
                /* --, A.ATTRIBUTE6 */
                /* --, A.ATTRIBUTE7 */
                /* --, A.ATTRIBUTE8 */
                , A.ATTRIBUTE9
                /* --, A.ATTRIBUTE10 */
        ;

        /*
            DECLARE @POS int
            DECLARE @LEN NVARCHAR(max)
				    SET @POS =1;
				    SET @LEN =LEN(@mEXEC);
				    WHILE @POS <= @LEN
					    BEGIN
						    PRINT SUBSTRING(@mEXEC,@POS,4000);
						    SET @POS = @POS+4000;
					    END;
          */



        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- TRANSPORT_MODE 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- 'SHIP_PLAN'의 TRANSPORT_MODE 종류 별 추가 */

        /* IF OBJECT_ID('tempdb..#TRANSPORT_MODE') IS NOT NULL DROP TABLE #TRANSPORT_MODE; → GTT 초기화 */
        DELETE
          FROM GT_XGLS_TRANSPORT_MODE;

        INSERT
          INTO GT_XGLS_TRANSPORT_MODE
             ( DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , BOD_ID
             , PROJECT_CODE
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
             , Y.PROJECT_CODE
             , X.LT_TOTAL_BY_WEEK
          FROM GT_XGLB_BOD_V           X
             , GT_XGLS_PSI_GLOBAL_AUTO Y
         WHERE X.DIVISION_ID      = Y.DIVISION_ID(+)
           AND X.FROM_SITE        = Y.FROM_SITE(+)
           AND X.TO_SITE          = Y.TO_SITE(+)
           AND X.INCOTERMS        = Y.INCOTERMS(+)
           AND X.BOD_ID           = Y.BOD_ID(+)   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
           AND Y.PROJECT_CODE(+) <> '-'
           /* --                WHERE ISNULL(Y.PROJECT_CODE ,'') <> '' */
        ;


        /* AS-IS : SUB = #SCP_XLS_PSI_GLOBAL_AUTO X LEFT OUTER JOIN #TRANSPORT_MODE Y ON ... AND X.MEASURE = 'SHIP_PLAN'
                   바깥 WHERE 가 SUB.MEASURE = 'SHIP_PLAN' AND SUB.TRANSPORT_MODE IS NOT NULL 이라
                   짝이 없는 행·SHIP_PLAN 이 아닌 행은 모두 빠진다 → 내부 조인 + X.MEASURE = 'SHIP_PLAN' 과 결과가 같다.
           AS-IS NOT EXISTS 의 CELL_ITEM_ID 비교는 MSSQL 빈 문자('')끼리 같다고 본다.
           Oracle 은 빈 문자가 NULL 이므로 NULL 끼리도 같다고 보도록 비교한다. */
        INSERT
          INTO GT_XGLS_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.OPERATION_GROUP_NAME
             , SUB.CELL_ITEM_ID
             , SUB.ITEM_ID
             , SUB.NICK_NAME
             , SUB.CELL_QTY_PACK
             , SUB.TO_SITE
             , SUB.TO_SITE_DESCRIPTION
             , SUB.PROJECT_CODE
             , SUB.FROM_BOH_QTY
             , SUB.TO_BOH_QTY
             , SUB.INCOTERMS
             , SUB.FROM_SITE
             , SUB.FROM_SITE_DESCRIPTION
             , SUB.TRANSPORT_MODE
             , SUB.PROD_LINE
             , SUB.LT_DAY
             , SUB.BOD_ID
             , SUB.MEASURE
             , SUB.MEASURE_LABEL
             , SUB.XLS_KEY1
             , SUB.XLS_KEY2
             , SUB.XLS_KEY3
             , SUB.XLS_KEY4
             , SUB.XLS_KEY5
             , SUB.XLS_ATTRIBUTE1
             , SUB.XLS_ATTRIBUTE2
             , SUB.XLS_ATTRIBUTE3
             , SUB.XLS_ATTRIBUTE4
             , SUB.XLS_ATTRIBUTE5
             , SUB.SORT_ORDER_NO
             , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
             , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
             , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
             , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
             , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
             , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
             , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
             , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
             , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
             , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
             , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
             , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
             , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
             , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
             , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
             , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
             , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
             , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
             , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
             , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
             , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
             , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
             , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
             , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
             , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
             , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
             , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
             , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
             , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
             , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
             , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
             , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
             , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
             , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
             , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
             , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
             , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
             /* --,X.CREATED_BY */
             /* --,X.CREATION_DATE */
             /* --,X.LAST_UPDATED_BY */
             /* --,X.LAST_UPDATE_DATE */
             , SUB.ATTRIBUTE1
             , SUB.ATTRIBUTE2
             , SUB.ATTRIBUTE3
             , SUB.ATTRIBUTE4
             , SUB.ATTRIBUTE5
             , SUB.ATTRIBUTE6
             , SUB.ATTRIBUTE7
             , SUB.ATTRIBUTE8
             , SUB.ATTRIBUTE9
             , SUB.ATTRIBUTE10
          FROM (SELECT DISTINCT
                       X.DIVISION_ID
                     , X.PLAN_START_YYYYMMDD
                     , X.PLAN_TYPE
                     , X.SEQ
                     , X.OPERATION_GROUP
                     , X.OPERATION_GROUP_NAME
                     , X.CELL_ITEM_ID
                     , X.ITEM_ID
                     , X.NICK_NAME
                     , X.CELL_QTY_PACK
                     , X.TO_SITE
                     , X.TO_SITE_DESCRIPTION
                     , X.PROJECT_CODE
                     , X.FROM_BOH_QTY
                     , X.TO_BOH_QTY
                     , X.INCOTERMS
                     , X.FROM_SITE
                     , X.FROM_SITE_DESCRIPTION
                     , Y.TRANSPORT_MODE
                     , X.PROD_LINE
                     , Y.LT_TOTAL_BY_WEEK AS LT_DAY
                     , Y.BOD_ID
                     , X.MEASURE
                     , X.MEASURE_LABEL
                     , X.XLS_KEY1
                     , X.XLS_KEY2
                     , X.XLS_KEY3
                     , X.XLS_KEY4
                     , X.XLS_KEY5
                     , X.XLS_ATTRIBUTE1
                     , X.XLS_ATTRIBUTE2
                     , X.XLS_ATTRIBUTE3
                     , X.XLS_ATTRIBUTE4
                     , X.XLS_ATTRIBUTE5
                     , X.SORT_ORDER_NO
                     /* --,X.CREATED_BY */
                     /* --,X.CREATION_DATE */
                     /* --,X.LAST_UPDATED_BY */
                     /* --,X.LAST_UPDATE_DATE */
                     , X.ATTRIBUTE1
                     , X.ATTRIBUTE2
                     , X.ATTRIBUTE3
                     , X.ATTRIBUTE4
                     , X.ATTRIBUTE5
                     , X.ATTRIBUTE6
                     , X.ATTRIBUTE7
                     , X.ATTRIBUTE8
                     , X.ATTRIBUTE9
                     , X.ATTRIBUTE10
                  FROM GT_XGLS_PSI_GLOBAL_AUTO X
                     , GT_XGLS_TRANSPORT_MODE  Y
                 WHERE 0 = 0
                   AND X.DIVISION_ID     = Y.DIVISION_ID
                   AND X.FROM_SITE       = Y.FROM_SITE
                   AND X.TO_SITE         = Y.TO_SITE
                   AND X.INCOTERMS       = Y.INCOTERMS
                   AND X.PROJECT_CODE    = Y.PROJECT_CODE
                   AND X.BOD_ID          = Y.BOD_ID   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
                   AND X.MEASURE         = 'SHIP_PLAN'
                   /* --                                AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE */
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM GT_XGLS_PSI_GLOBAL_AUTO Z
                            WHERE 1 = 1
                              AND Z.DIVISION_ID     = SUB.DIVISION_ID
                              AND Z.OPERATION_GROUP = SUB.OPERATION_GROUP
                              AND (Z.CELL_ITEM_ID   = SUB.CELL_ITEM_ID OR (Z.CELL_ITEM_ID IS NULL AND SUB.CELL_ITEM_ID IS NULL))
                              AND Z.ITEM_ID         = SUB.ITEM_ID
                              AND Z.PROJECT_CODE    = SUB.PROJECT_CODE
                              AND Z.TO_SITE         = SUB.TO_SITE
                              AND Z.INCOTERMS       = SUB.INCOTERMS
                              AND Z.FROM_SITE       = SUB.FROM_SITE
                              AND Z.TRANSPORT_MODE  = SUB.TRANSPORT_MODE
                              AND Z.MEASURE         = SUB.MEASURE
                              AND Z.MEASURE         = 'SHIP_PLAN'
                              AND Z.BOD_ID          = SUB.BOD_ID
                              AND Z.ATTRIBUTE1      = SUB.ATTRIBUTE1
                              /* --			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9 */
                          )
           AND SUB.MEASURE = 'SHIP_PLAN'
           AND SUB.TRANSPORT_MODE IS NOT NULL
        ;


        INSERT
          INTO GT_XGLS_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.OPERATION_GROUP_NAME
             , SUB.CELL_ITEM_ID
             , SUB.ITEM_ID
             , SUB.NICK_NAME
             , SUB.CELL_QTY_PACK
             , SUB.TO_SITE
             , SUB.TO_SITE_DESCRIPTION
             , SUB.PROJECT_CODE
             , SUB.FROM_BOH_QTY
             , SUB.TO_BOH_QTY
             , SUB.INCOTERMS
             , SUB.FROM_SITE
             , SUB.FROM_SITE_DESCRIPTION
             , SUB.TRANSPORT_MODE
             , SUB.PROD_LINE
             , SUB.LT_DAY
             , SUB.BOD_ID
             , SUB.MEASURE
             , SUB.MEASURE_LABEL
             , SUB.XLS_KEY1
             , SUB.XLS_KEY2
             , SUB.XLS_KEY3
             , SUB.XLS_KEY4
             , SUB.XLS_KEY5
             , SUB.XLS_ATTRIBUTE1
             , SUB.XLS_ATTRIBUTE2
             , SUB.XLS_ATTRIBUTE3
             , SUB.XLS_ATTRIBUTE4
             , SUB.XLS_ATTRIBUTE5
             , SUB.SORT_ORDER_NO
             , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
             , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
             , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
             , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
             , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
             , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
             , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
             , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
             , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
             , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
             , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
             , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
             , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
             , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
             , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
             , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
             , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
             , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
             , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
             , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
             , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
             , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
             , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
             , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
             , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
             , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
             , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
             , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
             , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
             , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
             , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
             , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
             , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
             , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
             , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
             , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
             , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
             /* --,X.CREATED_BY */
             /* --,X.CREATION_DATE */
             /* --,X.LAST_UPDATED_BY */
             /* --,X.LAST_UPDATE_DATE */
             , SUB.ATTRIBUTE1
             , SUB.ATTRIBUTE2
             , SUB.ATTRIBUTE3
             , SUB.ATTRIBUTE4
             , SUB.ATTRIBUTE5
             , SUB.ATTRIBUTE6
             , SUB.ATTRIBUTE7
             , SUB.ATTRIBUTE8
             , SUB.ATTRIBUTE9
             , SUB.ATTRIBUTE10
          FROM (SELECT DISTINCT
                       X.DIVISION_ID
                     , X.PLAN_START_YYYYMMDD
                     , X.PLAN_TYPE
                     , X.SEQ
                     , X.OPERATION_GROUP
                     , X.OPERATION_GROUP_NAME
                     , X.CELL_ITEM_ID
                     , X.ITEM_ID
                     , X.NICK_NAME
                     , X.CELL_QTY_PACK
                     , X.TO_SITE
                     , X.TO_SITE_DESCRIPTION
                     , X.PROJECT_CODE
                     , X.FROM_BOH_QTY
                     , X.TO_BOH_QTY
                     , X.INCOTERMS
                     , X.FROM_SITE
                     , X.FROM_SITE_DESCRIPTION
                     , NVL(Y.TRANSPORT_MODE, '-')      AS TRANSPORT_MODE   /* -- PJ2025F254 : ISNULL 처리 */
                     , X.PROD_LINE
                     , NVL(Y.LT_TOTAL_BY_WEEK, 0)      AS LT_DAY           /* -- PJ2025F254 : ISNULL 처리 */
                     , NVL(Y.BOD_ID, X.BOD_ID)         AS BOD_ID           /* -- PJ2025F254 : ISNULL 처리  --- 2025.12.23 */
                     , X.MEASURE
                     , X.MEASURE_LABEL
                     , X.XLS_KEY1
                     , X.XLS_KEY2
                     , X.XLS_KEY3
                     , X.XLS_KEY4
                     , X.XLS_KEY5
                     , X.XLS_ATTRIBUTE1
                     , X.XLS_ATTRIBUTE2
                     , X.XLS_ATTRIBUTE3
                     , X.XLS_ATTRIBUTE4
                     , X.XLS_ATTRIBUTE5
                     , X.SORT_ORDER_NO
                     /* --,X.CREATED_BY */
                     /* --,X.CREATION_DATE */
                     /* --,X.LAST_UPDATED_BY */
                     /* --,X.LAST_UPDATE_DATE */
                     , X.ATTRIBUTE1
                     , X.ATTRIBUTE2
                     , X.ATTRIBUTE3
                     , X.ATTRIBUTE4
                     , X.ATTRIBUTE5
                     , X.ATTRIBUTE6
                     , X.ATTRIBUTE7
                     , X.ATTRIBUTE8
                     , X.ATTRIBUTE9
                     , X.ATTRIBUTE10
                  FROM GT_XGLS_PSI_GLOBAL_AUTO X
                     , GT_XGLS_TRANSPORT_MODE  Y
                 WHERE 0 = 0
                   AND X.DIVISION_ID             = Y.DIVISION_ID(+)
                   AND X.FROM_SITE               = Y.FROM_SITE(+)
                   AND X.TO_SITE                 = Y.TO_SITE(+)
                   /* --                                    AND X.INCOTERMS       = Y.INCOTERMS */
                   AND X.PROJECT_CODE            = NVL(Y.PROJECT_CODE(+), '-')
                   AND X.BOD_ID                  = Y.BOD_ID(+)   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
                   /* AS-IS 조인 조건 X.MEASURE = 'SEMI_SHIP_PLAN' : 바깥 WHERE 가 SEMI_SHIP_PLAN 만 남기므로 여기 WHERE 로 둔다 */
                   AND X.MEASURE                 = 'SEMI_SHIP_PLAN'
                   /* --                                AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE */
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM GT_XGLS_PSI_GLOBAL_AUTO Z
                            WHERE 1 = 1
                              AND Z.DIVISION_ID              = SUB.DIVISION_ID
                              AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP
                              AND (Z.CELL_ITEM_ID            = SUB.CELL_ITEM_ID OR (Z.CELL_ITEM_ID IS NULL AND SUB.CELL_ITEM_ID IS NULL))
                              AND Z.ITEM_ID                  = SUB.ITEM_ID
                              AND Z.PROJECT_CODE             = SUB.PROJECT_CODE
                              AND Z.TO_SITE                  = SUB.TO_SITE
                              AND Z.INCOTERMS                = SUB.INCOTERMS
                              AND Z.FROM_SITE                = SUB.FROM_SITE
                              AND NVL(Z.TRANSPORT_MODE, '-') = NVL(SUB.TRANSPORT_MODE, '-')   /* -- PJ2025F254 : ISNULL 처리 (BOD가 없는 경우 중복 데이터 발생 현상 보완) */
                              AND Z.MEASURE                  = SUB.MEASURE
                              AND Z.MEASURE                  = 'SEMI_SHIP_PLAN'
                              AND NVL(Z.BOD_ID, '-')         = NVL(SUB.BOD_ID, '-')           /* -- PJ2025F254 : ISNULL 처리 (BOD가 없는 경우 중복 데이터 발생 현상 보완) */
                              AND Z.ATTRIBUTE1               = SUB.ATTRIBUTE1
                              /* --			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9 */
                          )
           AND SUB.MEASURE = 'SEMI_SHIP_PLAN'
        ;


        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL DROP TABLE #tmp_SCP_MST_TACT_TIME
           SELECT * INTO #tmp_SCP_MST_TACT_TIME FROM (SCP_MST_TACT_TIME UNION ALL SCP_MST_TACT_TIME_OSP) X
           → 쓰는 곳이 아래 「PACK PROD : YIELD」 한 곳뿐이라 그 문장의 인라인 뷰로 옮김(원천·조건 동일) */

/* AS-IS 주석 원문 (L854~L1079)
-- 주석처리 : 2022.10.14 - 불필요한 생산계획 생성을 차단
            ---------------------------------------------------------------------------------------------------------------
            ---- LINE_ID 추가
            ---------------------------------------------------------------------------------------------------------------
            ---- 'SHIP_PLAN'의 LINE_ID 종류 별 추가
            --   INSERT INTO #SCP_XLS_PSI_GLOBAL_AUTO
            --          SELECT DISTINCT X.DIVISION_ID
            --          ,X.PLAN_START_YYYYMMDD
            --          ,X.PLAN_TYPE
            --          ,X.SEQ
            --          ,X.OPERATION_GROUP
            --          ,X.OPERATION_GROUP_NAME
            --          ,X.CELL_ITEM_ID
            --          ,X.ITEM_ID
            --          ,X.NICK_NAME
            --          ,X.CELL_QTY_PACK
            --          ,TO_SITE
            --          ,TO_SITE_DESCRIPTION
            --          ,PROJECT_CODE
            --          ,FROM_BOH_QTY
            --          ,TO_BOH_QTY
            --          ,INCOTERMS
            --          ,FROM_SITE
            --          ,FROM_SITE_DESCRIPTION
            --          ,TRANSPORT_MODE
            --          ,Y.LINE_ID AS PROD_LINE
            --          ,LT_DAY
            --          ,BOD_ID
            --          ,X.MEASURE
            --          ,X.MEASURE_LABEL
            --          ,X.XLS_KEY1
            --          ,X.XLS_KEY2
            --          ,X.XLS_KEY3
            --          ,X.XLS_KEY4
            --          ,X.XLS_KEY5
            --          ,X.XLS_ATTRIBUTE1
            --          ,X.XLS_ATTRIBUTE2
            --          ,X.XLS_ATTRIBUTE3
            --          ,X.XLS_ATTRIBUTE4
            --          ,X.XLS_ATTRIBUTE5
            --          ,X.SORT_ORDER_NO
            --          ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
            --          ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
            --          ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
            --          ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
            --          ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
            --          ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
            --          ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
            --          ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
            --          ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
            --          ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

            --          ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
            --          ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
            --          ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
            --          ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
            --          ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
            --          ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
            --          ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
            --          ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
            --          ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
            --          ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

            --          ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
            --          ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
            --          ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
            --          ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
            --          ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
            --          ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
            --          ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
            --          ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
            --          ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
            --          ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

            --          ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
            --          ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
            --          ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
            --          ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
            --          ,0 AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
            --          ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
            --          ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364
            --          --,X.CREATED_BY
            --          --,X.CREATION_DATE
            --          --,X.LAST_UPDATED_BY
            --          --,X.LAST_UPDATE_DATE
            --          ,X.ATTRIBUTE1
            --          ,X.ATTRIBUTE2
            --          ,X.ATTRIBUTE3
            --          ,X.ATTRIBUTE4
            --          ,X.ATTRIBUTE5
            --          ,X.ATTRIBUTE6
            --          ,X.ATTRIBUTE7
            --          ,X.ATTRIBUTE8
            --          ,X.ATTRIBUTE9
            --          ,X.ATTRIBUTE10
            --          FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH (NOLOCK)
            --          CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
            --          WHERE 0 = 0
            --          AND X.DIVISION_ID   = Y.DIVISION_ID
            --          AND X.ITEM_ID       = Y.ITEM_ID
            --          AND X.FROM_SITE     = Y.PLANT_SITE_ID
            --          AND X.MEASURE       IN  ('CELL_PROD','PACK_PROD')
            --          AND NOT EXISTS (
            --                                SELECT 'X'
            --                                  FROM #SCP_XLS_PSI_GLOBAL_AUTO Z WITH(NOLOCK)
            --                                 WHERE 1=1
            --                                   AND Z.DIVISION_ID          = X.DIVISION_ID
            --                                   AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID
            --                                   AND Z.ITEM_ID              = X.ITEM_ID
            --                                   AND Z.MEASURE              = X.MEASURE
            --                                   AND Z.FROM_SITE            = Y.PLANT_SITE_ID
            --                                   AND Z.PROD_LINE            = Y.LINE_ID
            --                                   AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
            --                                   )

            --  UNION
            --        SELECT DISTINCT X.DIVISION_ID
            --          ,X.PLAN_START_YYYYMMDD
            --          ,X.PLAN_TYPE
            --          ,X.SEQ
            --          ,X.OPERATION_GROUP
            --          ,X.OPERATION_GROUP_NAME
            --          ,X.CELL_ITEM_ID
            --          ,X.ITEM_ID
            --          ,X.NICK_NAME
            --          ,X.CELL_QTY_PACK
            --          ,X.TO_SITE
            --          ,X.TO_SITE_DESCRIPTION
            --          ,X.PROJECT_CODE
            --          ,X.FROM_BOH_QTY
            --          ,X.TO_BOH_QTY
            --          ,X.INCOTERMS
            --          ,X.FROM_SITE
            --          ,X.FROM_SITE_DESCRIPTION
            --          ,X.TRANSPORT_MODE
            --          ,Y.LINE_ID AS PROD_LINE
            --          ,X.LT_DAY
            --          ,X.BOD_ID
            --          ,(CASE  WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_PROD_LOAD'
            --                  WHEN X.MEASURE = 'CELL_PROD' THEN 'CELL_PROD_LOAD' END ) AS MEASURE
            --          ,(CASE  WHEN X.MEASURE = 'PACK_PROD' THEN 'Load Ratio(%)'
            --                  WHEN X.MEASURE = 'CELL_PROD' THEN 'Load Ratio(%)' END ) AS MEASURE_LABEL
            --          ,X.XLS_KEY1
            --          ,X.XLS_KEY2
            --          ,X.XLS_KEY3
            --          ,X.XLS_KEY4
            --          ,X.XLS_KEY5
            --          ,X.XLS_ATTRIBUTE1
            --          ,X.XLS_ATTRIBUTE2
            --          ,X.XLS_ATTRIBUTE3
            --          ,X.XLS_ATTRIBUTE4
            --          ,X.XLS_ATTRIBUTE5
            --          ,X.SORT_ORDER_NO
            --          ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
            --          ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
            --          ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
            --          ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
            --          ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
            --          ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
            --          ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
            --          ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
            --          ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
            --          ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

            --          ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
            --          ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
            --          ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
            --          ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
            --          ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
            --          ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
            --          ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
            --          ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
            --          ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
            --          ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

            --          ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
            --          ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
            --          ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
            --          ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
            --          ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
            --          ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
            --          ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
            --          ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
            --          ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
            --          ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

            --          ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
            --          ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
            --          ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
            --          ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
            --          ,0  AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
            --          ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
            --          ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364
            --          --,X.CREATED_BY
            --          --,X.CREATION_DATE
            --          --,X.LAST_UPDATED_BY
            --          --,X.LAST_UPDATE_DATE
            --          ,X.ATTRIBUTE1
            --          ,X.ATTRIBUTE2
            --          ,X.ATTRIBUTE3
            --          ,X.ATTRIBUTE4
            --          ,X.ATTRIBUTE5
            --          ,X.ATTRIBUTE6
            --          ,X.ATTRIBUTE7
            --          ,X.ATTRIBUTE8
            --          ,X.ATTRIBUTE9
            --          ,X.ATTRIBUTE10
            --          FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH (NOLOCK)
            --          CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
            --          WHERE 0 = 0
            --          AND X.DIVISION_ID   = Y.DIVISION_ID
            --          AND X.ITEM_ID       = Y.ITEM_ID
            --          AND X.FROM_SITE     = Y.PLANT_SITE_ID
            --          AND X.MEASURE       IN  ('CELL_PROD','PACK_PROD')
            --          AND NOT EXISTS (
            --                                SELECT 'X'
            --                                  FROM #SCP_XLS_PSI_GLOBAL_AUTO Z WITH(NOLOCK)
            --                                 WHERE 1=1
            --                                   AND Z.DIVISION_ID          = X.DIVISION_ID
            --                                   AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID
            --                                   AND Z.ITEM_ID              = X.ITEM_ID
            --                                   AND Z.MEASURE              = X.MEASURE
            --                                   AND Z.FROM_SITE            = Y.PLANT_SITE_ID
            --                                   AND Z.PROD_LINE            = Y.LINE_ID
            --                                   AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
            --                                   )
*/

        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  MEASURE 추가 : ITEM_ID별 (MKT_FCST_CELL_TOTAL) */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLS_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , X.OPERATION_GROUP
             , 'CELL'                AS OPERATION_GROUP_NAME
             , X.CELL_ITEM_ID
             , '-'                   AS ITEM_ID
             , '-'                   AS NICK_NAME
             , 0                     AS CELL_QTY_PACK          /* AS-IS '0' → 숫자 칸 */
             , '-'                   AS TO_SITE
             , '-'                   AS TO_SITE_DESCRIPTION
             , '-'                   AS PROJECT_CODE
             , 0                     AS FROM_BOH_QTY           /* AS-IS '0' → 숫자 칸 */
             , 0                     AS TO_BOH_QTY             /* AS-IS '0' → 숫자 칸 */
             , '-'                   AS INCOTERMS
             , '-'                   AS FROM_SITE
             , '-'                   AS FROM_SITE_DESCRIPTION
             , '-'                   AS TRANSPORT_MODE
             , '-'                   AS PROD_LINE
             , 0                     AS LT_DAY                 /* AS-IS '-' → INT 칸 적재 시 0 */
             , '-'                   AS BOD_ID
             , M.COLUMN_NAME         AS MEASURE
             , M.COLUMN_LABEL_NAME   AS MEASURE_LABEL
             , X.XLS_KEY1
             , X.XLS_KEY2
             , X.XLS_KEY3
             , X.XLS_KEY4
             , X.XLS_KEY5
             , X.XLS_ATTRIBUTE1
             , X.XLS_ATTRIBUTE2
             , X.XLS_ATTRIBUTE3
             , X.XLS_ATTRIBUTE4
             , X.XLS_ATTRIBUTE5
             , M.SORT_ORDER_NO
             , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
             , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
             , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
             , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
             , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
             , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
             , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
             , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
             , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
             , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
             , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
             , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
             , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
             , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
             , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
             , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
             , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
             , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
             , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
             , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
             , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
             , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
             , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
             , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
             , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
             , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
             , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
             , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
             , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
             , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
             , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
             , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
             , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
             , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
             , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
             , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
             , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
             /* --,X.CREATED_BY */
             /* --,X.CREATION_DATE */
             /* --,X.LAST_UPDATED_BY */
             /* --,X.LAST_UPDATE_DATE */
             , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL' ELSE 'DIO' END) AS ATTRIBUTE1
             , X.ATTRIBUTE2
             , X.ATTRIBUTE3
             , X.ATTRIBUTE4
             , X.ATTRIBUTE5
             , X.ATTRIBUTE6
             , X.ATTRIBUTE7
             , X.ATTRIBUTE8
             , NULL                  AS ATTRIBUTE9
             , X.ATTRIBUTE10
          FROM GT_XGLS_PSI_GLOBAL_AUTO X
             , GT_XGLB_MEASURE         M      /* CROSS APPLY #MEASURE M (상관 조건 없음 = 곱 조인) */
         WHERE 1 = 1
           AND M.GUBUN           = 'CELL_ITEM_ID'
           AND M.COLUMN_NAME     = 'MKT_FCST_CELL_TOTAL'
           AND X.OPERATION_GROUP = 'A'
        ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  DIO 계산용 MEASURE 추가(MKT_FCST_TOTAL,ALLOCATION_TOTAL,EOH_TOTAL,MKT_FCST_DIO,ALLOCATION_DIO) */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XGLS_PSI_GLOBAL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , 'A'                   AS OPERATION_GROUP
             , 'CELL'                AS OPERATION_GROUP_NAME
             , X.CELL_ITEM_ID
             , '-'                   AS ITEM_ID
             , '-'                   AS NICK_NAME
             , 0                     AS CELL_QTY_PACK          /* AS-IS '0' → 숫자 칸 */
             , '-'                   AS TO_SITE
             , '-'                   AS TO_SITE_DESCRIPTION
             , '-'                   AS PROJECT_CODE
             , 0                     AS FROM_BOH_QTY           /* AS-IS '0' → 숫자 칸 */
             , 0                     AS TO_BOH_QTY             /* AS-IS '0' → 숫자 칸 */
             , '-'                   AS INCOTERMS
             , '-'                   AS FROM_SITE
             , '-'                   AS FROM_SITE_DESCRIPTION
             , '-'                   AS TRANSPORT_MODE
             , '-'                   AS PROD_LINE
             , 0                     AS LT_DAY                 /* AS-IS '-' → INT 칸 적재 시 0 */
             , '-'                   AS BOD_ID
             , M.COLUMN_NAME         AS MEASURE
             , M.COLUMN_LABEL_NAME   AS MEASURE_LABEL
             , X.XLS_KEY1
             , X.XLS_KEY2
             , X.XLS_KEY3
             , X.XLS_KEY4
             , X.XLS_KEY5
             , X.XLS_ATTRIBUTE1
             , X.XLS_ATTRIBUTE2
             , X.XLS_ATTRIBUTE3
             , X.XLS_ATTRIBUTE4
             , X.XLS_ATTRIBUTE5
             , M.SORT_ORDER_NO
             , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
             , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
             , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
             , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
             , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
             , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
             , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
             , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
             , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
             , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
             , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
             , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
             , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
             , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
             , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
             , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
             , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
             , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
             , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
             , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
             , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
             , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
             , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
             , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
             , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
             , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
             , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
             , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
             , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
             , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
             , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
             , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
             , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
             , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
             , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
             , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
             , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
             /* --,X.CREATED_BY */
             /* --,X.CREATION_DATE */
             /* --,X.LAST_UPDATED_BY */
             /* --,X.LAST_UPDATE_DATE */
             , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL' ELSE 'DIO' END) AS ATTRIBUTE1
             , X.ATTRIBUTE2
             , X.ATTRIBUTE3
             , X.ATTRIBUTE4
             , X.ATTRIBUTE5
             , X.ATTRIBUTE6
             , X.ATTRIBUTE7
             , X.ATTRIBUTE8
             , NULL                  AS ATTRIBUTE9
             , X.ATTRIBUTE10
          FROM GT_XGLS_PSI_GLOBAL_AUTO X
             , GT_XGLB_MEASURE         M      /* CROSS APPLY #MEASURE M (상관 조건 없음 = 곱 조인) */
         WHERE 1 = 1
           AND M.GUBUN        = 'CELL_ITEM_ID'
           AND M.COLUMN_NAME <> 'MKT_FCST_CELL_TOTAL'
        ;



        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  보정 */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE GT_XGLS_PSI_GLOBAL_AUTO
           SET LT_DAY         = 0
         WHERE TRANSPORT_MODE = '-'
        ;


        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  삭제 후 입력 */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* --DELETE FROM SCP_XLS_PSI_GLOBAL */
        /* --      WHERE DIVISION_ID = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */

        /* AS-IS : SELECT ... INTO #GLOBAL_XLS_KEY FROM #SCP_XLS_PSI_GLOBAL_AUTO 후 INSERT INTO SCP_XLS_PSI_GLOBAL SELECT * FROM #GLOBAL_XLS_KEY
           → 한 번만 쓰는 임시 테이블이라 INSERT ... SELECT 한 문장으로 옮김(칸·값 동일)
           XLS_KEY1 정렬 : AS-IS 정렬 규칙(Latin1_General_CI_AS : 대소문자 무시 · 하이픈 무시 · 밑줄은 글자·숫자 앞 · 빈 값/NULL 맨 앞)을
                           문자 키마다 UPPER(TRANSLATE(x, '_-', '/')) + 원값 2차 키 + NULLS FIRST(내림차순은 NULLS LAST)로 재현
           PROJECT_CODE : AS-IS LEN(PROJECT_CODE) = 0 은 빈 문자('') → Oracle 은 '' 가 NULL 이라 RTRIM 결과 NULL 로 판정 */
        INSERT
          INTO SCP_XLS_PSI_GLOBAL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , CREATE_FROM_YYYYMMDD
             , CREATE_TO_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             /* --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25 */
             /* --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50 */
             /* --,WQTY51,WQTY52 */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , V_CREATE_FROM_YYYYMMDD                                                   AS CREATE_FROM_YYYYMMDD
             , V_CREATE_TO_YYYYMMDD                                                     AS CREATE_TO_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , X.OPERATION_GROUP
             , X.OPERATION_GROUP_NAME
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.NICK_NAME
             , X.CELL_QTY_PACK
             , X.TO_SITE
             , X.TO_SITE_DESCRIPTION
             , (CASE WHEN X.PROJECT_CODE IS NULL OR RTRIM(X.PROJECT_CODE) IS NULL THEN '-' ELSE X.PROJECT_CODE END) AS PROJECT_CODE
             , X.FROM_BOH_QTY
             , X.TO_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.FROM_SITE_DESCRIPTION
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , X.LT_DAY
             , X.BOD_ID
             , X.MEASURE
             , X.MEASURE_LABEL
             , ROW_NUMBER() OVER(ORDER BY UPPER(TRANSLATE(X.DIVISION_ID, '_-', '/')) NULLS FIRST, X.DIVISION_ID NULLS FIRST
                                        , UPPER(TRANSLATE(X.OPERATION_GROUP, '_-', '/')) DESC NULLS LAST, X.OPERATION_GROUP DESC NULLS LAST
                                        , UPPER(TRANSLATE(X.CELL_ITEM_ID, '_-', '/')) NULLS FIRST, X.CELL_ITEM_ID NULLS FIRST
                                        /* -- 동일한 CELL ITEM ID 인경우 CELL 공정에서는 CP 해당 품목을 위에 표시 */
                                        , UPPER(TRANSLATE(CASE WHEN X.OPERATION_GROUP = 'P' THEN '0'
                                                               WHEN X.OPERATION_GROUP = 'A' THEN FN_GET_FINAL_ITEM(X.DIVISION_ID, X.ITEM_ID, 'CELL_SORT')
                                                               ELSE '9'
                                                           END, '_-', '/')) NULLS FIRST
                                        , (CASE WHEN X.OPERATION_GROUP = 'P' THEN '0'
                                                WHEN X.OPERATION_GROUP = 'A' THEN FN_GET_FINAL_ITEM(X.DIVISION_ID, X.ITEM_ID, 'CELL_SORT')
                                                ELSE '9'
                                            END) NULLS FIRST
                                        , UPPER(TRANSLATE(CASE WHEN X.ATTRIBUTE1 = 'DIO' THEN '-' ELSE X.OPERATION_GROUP END, '_-', '/')) DESC NULLS LAST
                                        , (CASE WHEN X.ATTRIBUTE1 = 'DIO' THEN '-' ELSE X.OPERATION_GROUP END) DESC NULLS LAST
                                        , UPPER(TRANSLATE(X.ITEM_ID, '_-', '/')) NULLS FIRST, X.ITEM_ID NULLS FIRST
                                        /* --                                                 ,TO_SITE desc */
                                        , UPPER(TRANSLATE(CASE WHEN (X.TO_SITE = '-' AND X.MEASURE = 'MKT_FCST_PACK_TOTAL') THEN 'ZZZ'
                                                               WHEN (X.TO_SITE = '-' AND X.MEASURE = 'MKT_FCST_CELL_TOTAL') THEN 'AAA'
                                                               ELSE X.TO_SITE
                                                           END, '_-', '/')) DESC NULLS LAST
                                        , (CASE WHEN (X.TO_SITE = '-' AND X.MEASURE = 'MKT_FCST_PACK_TOTAL') THEN 'ZZZ'
                                                WHEN (X.TO_SITE = '-' AND X.MEASURE = 'MKT_FCST_CELL_TOTAL') THEN 'AAA'
                                                ELSE X.TO_SITE
                                            END) DESC NULLS LAST
                                        , UPPER(TRANSLATE(X.ITEM_ID, '_-', '/')) NULLS FIRST, X.ITEM_ID NULLS FIRST
                                        , UPPER(TRANSLATE(X.INCOTERMS, '_-', '/')) NULLS FIRST, X.INCOTERMS NULLS FIRST
                                        , UPPER(TRANSLATE(CASE WHEN (X.FROM_SITE = '-' AND X.MEASURE LIKE 'CELL%') THEN 'AAA'
                                                               ELSE X.FROM_SITE
                                                           END, '_-', '/')) NULLS FIRST
                                        , (CASE WHEN (X.FROM_SITE = '-' AND X.MEASURE LIKE 'CELL%') THEN 'AAA'
                                                ELSE X.FROM_SITE
                                            END) NULLS FIRST
                                        , UPPER(TRANSLATE(X.PROJECT_CODE, '_-', '/')) NULLS FIRST, X.PROJECT_CODE NULLS FIRST
                                        , UPPER(TRANSLATE(X.ATTRIBUTE10, '_-', '/')) NULLS FIRST, X.ATTRIBUTE10 NULLS FIRST
                                        , UPPER(TRANSLATE(CASE WHEN X.MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH') THEN 'ZZZ' ELSE X.PROD_LINE END, '_-', '/')) NULLS FIRST
                                        , (CASE WHEN X.MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH') THEN 'ZZZ' ELSE X.PROD_LINE END) NULLS FIRST
                                        , X.SORT_ORDER_NO NULLS FIRST
                                        , UPPER(TRANSLATE(X.TRANSPORT_MODE, '_-', '/')) NULLS FIRST, X.TRANSPORT_MODE NULLS FIRST
                                        , UPPER(TRANSLATE(X.MEASURE_LABEL, '_-', '/')) DESC NULLS LAST, X.MEASURE_LABEL DESC NULLS LAST
                                )                                                        AS XLS_KEY1
             , X.XLS_KEY2
             , X.XLS_KEY3
             , X.XLS_KEY4
             , X.XLS_KEY5
             , X.XLS_ATTRIBUTE1
             , X.XLS_ATTRIBUTE2
             , X.XLS_ATTRIBUTE3
             , X.XLS_ATTRIBUTE4
             , X.XLS_ATTRIBUTE5
             , X.SORT_ORDER_NO
             , X.QTY001, X.QTY002, X.QTY003, X.QTY004, X.QTY005, X.QTY006, X.QTY007, X.QTY008, X.QTY009, X.QTY010
             , X.QTY011, X.QTY012, X.QTY013, X.QTY014, X.QTY015, X.QTY016, X.QTY017, X.QTY018, X.QTY019, X.QTY020
             , X.QTY021, X.QTY022, X.QTY023, X.QTY024, X.QTY025, X.QTY026, X.QTY027, X.QTY028, X.QTY029, X.QTY030
             , X.QTY031, X.QTY032, X.QTY033, X.QTY034, X.QTY035, X.QTY036, X.QTY037, X.QTY038, X.QTY039, X.QTY040
             , X.QTY041, X.QTY042, X.QTY043, X.QTY044, X.QTY045, X.QTY046, X.QTY047, X.QTY048, X.QTY049, X.QTY050
             , X.QTY051, X.QTY052, X.QTY053, X.QTY054, X.QTY055, X.QTY056, X.QTY057, X.QTY058, X.QTY059, X.QTY060
             , X.QTY061, X.QTY062, X.QTY063, X.QTY064, X.QTY065, X.QTY066, X.QTY067, X.QTY068, X.QTY069, X.QTY070
             , X.QTY071, X.QTY072, X.QTY073, X.QTY074, X.QTY075, X.QTY076, X.QTY077, X.QTY078, X.QTY079, X.QTY080
             , X.QTY081, X.QTY082, X.QTY083, X.QTY084, X.QTY085, X.QTY086, X.QTY087, X.QTY088, X.QTY089, X.QTY090
             , X.QTY091, X.QTY092, X.QTY093, X.QTY094, X.QTY095, X.QTY096, X.QTY097, X.QTY098, X.QTY099, X.QTY100
             , X.QTY101, X.QTY102, X.QTY103, X.QTY104, X.QTY105, X.QTY106, X.QTY107, X.QTY108, X.QTY109, X.QTY110
             , X.QTY111, X.QTY112, X.QTY113, X.QTY114, X.QTY115, X.QTY116, X.QTY117, X.QTY118, X.QTY119, X.QTY120
             , X.QTY121, X.QTY122, X.QTY123, X.QTY124, X.QTY125, X.QTY126, X.QTY127, X.QTY128, X.QTY129, X.QTY130
             , X.QTY131, X.QTY132, X.QTY133, X.QTY134, X.QTY135, X.QTY136, X.QTY137, X.QTY138, X.QTY139, X.QTY140
             , X.QTY141, X.QTY142, X.QTY143, X.QTY144, X.QTY145, X.QTY146, X.QTY147, X.QTY148, X.QTY149, X.QTY150
             , X.QTY151, X.QTY152, X.QTY153, X.QTY154, X.QTY155, X.QTY156, X.QTY157, X.QTY158, X.QTY159, X.QTY160
             , X.QTY161, X.QTY162, X.QTY163, X.QTY164, X.QTY165, X.QTY166, X.QTY167, X.QTY168, X.QTY169, X.QTY170
             , X.QTY171, X.QTY172, X.QTY173, X.QTY174, X.QTY175, X.QTY176, X.QTY177, X.QTY178, X.QTY179, X.QTY180
             , X.QTY181, X.QTY182, X.QTY183, X.QTY184, X.QTY185, X.QTY186, X.QTY187, X.QTY188, X.QTY189, X.QTY190
             , X.QTY191, X.QTY192, X.QTY193, X.QTY194, X.QTY195, X.QTY196, X.QTY197, X.QTY198, X.QTY199, X.QTY200
             , X.QTY201, X.QTY202, X.QTY203, X.QTY204, X.QTY205, X.QTY206, X.QTY207, X.QTY208, X.QTY209, X.QTY210
             , X.QTY211, X.QTY212, X.QTY213, X.QTY214, X.QTY215, X.QTY216, X.QTY217, X.QTY218, X.QTY219, X.QTY220
             , X.QTY221, X.QTY222, X.QTY223, X.QTY224, X.QTY225, X.QTY226, X.QTY227, X.QTY228, X.QTY229, X.QTY230
             , X.QTY231, X.QTY232, X.QTY233, X.QTY234, X.QTY235, X.QTY236, X.QTY237, X.QTY238, X.QTY239, X.QTY240
             , X.QTY241, X.QTY242, X.QTY243, X.QTY244, X.QTY245, X.QTY246, X.QTY247, X.QTY248, X.QTY249, X.QTY250
             , X.QTY251, X.QTY252, X.QTY253, X.QTY254, X.QTY255, X.QTY256, X.QTY257, X.QTY258, X.QTY259, X.QTY260
             , X.QTY261, X.QTY262, X.QTY263, X.QTY264, X.QTY265, X.QTY266, X.QTY267, X.QTY268, X.QTY269, X.QTY270
             , X.QTY271, X.QTY272, X.QTY273, X.QTY274, X.QTY275, X.QTY276, X.QTY277, X.QTY278, X.QTY279, X.QTY280
             , X.QTY281, X.QTY282, X.QTY283, X.QTY284, X.QTY285, X.QTY286, X.QTY287, X.QTY288, X.QTY289, X.QTY290
             , X.QTY291, X.QTY292, X.QTY293, X.QTY294, X.QTY295, X.QTY296, X.QTY297, X.QTY298, X.QTY299, X.QTY300
             , X.QTY301, X.QTY302, X.QTY303, X.QTY304, X.QTY305, X.QTY306, X.QTY307, X.QTY308, X.QTY309, X.QTY310
             , X.QTY311, X.QTY312, X.QTY313, X.QTY314, X.QTY315, X.QTY316, X.QTY317, X.QTY318, X.QTY319, X.QTY320
             , X.QTY321, X.QTY322, X.QTY323, X.QTY324, X.QTY325, X.QTY326, X.QTY327, X.QTY328, X.QTY329, X.QTY330
             , X.QTY331, X.QTY332, X.QTY333, X.QTY334, X.QTY335, X.QTY336, X.QTY337, X.QTY338, X.QTY339, X.QTY340
             , X.QTY341, X.QTY342, X.QTY343, X.QTY344, X.QTY345, X.QTY346, X.QTY347, X.QTY348, X.QTY349, X.QTY350
             , X.QTY351, X.QTY352, X.QTY353, X.QTY354, X.QTY355, X.QTY356, X.QTY357, X.QTY358, X.QTY359, X.QTY360
             , X.QTY361, X.QTY362, X.QTY363, X.QTY364
             /* --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25 */
             /* --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50 */
             /* --,WQTY51,WQTY52 */
             , V_USER_ID                                                                AS CREATED_BY
             , SYSDATE                                                                  AS CREATION_DATE
             , V_USER_ID                                                                AS LAST_UPDATED_BY
             , SYSDATE                                                                  AS LAST_UPDATE_DATE
             , X.ATTRIBUTE1
             , X.ATTRIBUTE2
             , X.ATTRIBUTE3
             , X.ATTRIBUTE4
             , X.ATTRIBUTE5
             , X.ATTRIBUTE6
             , X.ATTRIBUTE7
             , X.ATTRIBUTE8
             , X.ATTRIBUTE9
             , X.ATTRIBUTE10
          FROM GT_XGLS_PSI_GLOBAL_AUTO X
        ;


        /* -- 불필요한 TEMP 테이블 삭제 */
        /* IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_AUTO') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_AUTO → GTT 비우기 */
        DELETE
          FROM GT_XGLS_PSI_GLOBAL_AUTO;


        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  YIELD(CELL_CHAR_AVAILABLE), LT UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* UPDATE ... FROM ... INNER JOIN → MERGE(행 식별자 ROWID 로 대상 고정, 같은 행에 짝이 여럿이면 AS-IS 처럼 하나만 반영) */
        MERGE
         INTO SCP_XLS_PSI_GLOBAL X
        USING (SELECT IB.RID
                    , IB.YIELD
                 FROM (SELECT X.ROWID                                                     AS RID
                            , (CASE WHEN NVL(Y.SSP_MODIFY_YIELD, 0) > 0.0 THEN NVL(Y.SSP_MODIFY_YIELD, 0)
                                    ELSE NVL(Y.FORMATION_TOTAL_YIELD, 0)
                                END)                                                    AS YIELD
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)       AS RN
                         FROM SCP_XLS_PSI_GLOBAL X
                            , (SELECT ITEM_ID
                                    , PLANT_SITE_ID
                                    , MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                                    , SSP_MODIFY_YIELD
                                 FROM SCP_MST_FORMATION_V
                                WHERE DIVISION_ID = V_DIVISION_ID
                                GROUP BY ITEM_ID
                                       , PLANT_SITE_ID
                                       , SSP_MODIFY_YIELD
                              ) Y
                        WHERE X.CELL_ITEM_ID         = Y.ITEM_ID
                          AND X.FROM_SITE            = Y.PLANT_SITE_ID
                          AND X.MEASURE              = 'CELL_CHAR_AVAILABLE'
                          AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                          AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (X.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET X.YIELD = S.YIELD
        ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  PACK PROD : YIELD */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  SELECT X.CELL_ITEM_ID, X.ITEM_ID, X.FROM_SITE, X.TO_SITE, X.YIELD,X.MEASURE,X.PROD_LINE,Y.LINE_ID, (CASE WHEN X.PROD_LINE = Y.LINE_ID THEN 'O' ELSE 'X' END )  AS chk,Y.ITEM_ID, Y.PLANT_SITE_ID,Y.YIELD */
        MERGE
         INTO SCP_XLS_PSI_GLOBAL X
        USING (SELECT IB.RID
                    , IB.YIELD
                 FROM (SELECT X.ROWID                                                     AS RID
                            , NVL(Y.YIELD, 0)                                             AS YIELD
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)       AS RN
                         FROM SCP_XLS_PSI_GLOBAL X
                            , (SELECT PLANT_SITE_ID
                                    , ITEM_ID
                                    , OPERATION_ID
                                    , LINE_ID
                                    , MAX(YIELD) AS YIELD
                                 FROM (SELECT DIVISION_ID
                                            , PLANT_SITE_ID
                                            , ITEM_ID
                                            , OPERATION_ID
                                            , LINE_ID
                                            , YIELD
                                         FROM SCP_MST_TACT_TIME
                                        WHERE DIVISION_ID = V_DIVISION_ID
                                        UNION ALL
                                       SELECT DIVISION_ID
                                            , PLANT_SITE_ID
                                            , ITEM_ID
                                            , OPERATION_ID
                                            , LINE_ID
                                            , YIELD
                                         FROM SCP_MST_TACT_TIME_OSP
                                        WHERE DIVISION_ID = V_DIVISION_ID
                                      ) XA   /* #tmp_SCP_MST_TACT_TIME */
                                WHERE DIVISION_ID = V_DIVISION_ID
                                  AND OPERATION_ID IN ('P9500', 'P5500', 'P5200')   /* -- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - P5200 추가 */
                                GROUP BY PLANT_SITE_ID
                                       , ITEM_ID
                                       , OPERATION_ID
                                       , LINE_ID
                              ) Y
                        WHERE X.ITEM_ID              = Y.ITEM_ID
                          AND X.FROM_SITE            = Y.PLANT_SITE_ID
                          AND X.ATTRIBUTE9           = Y.OPERATION_ID
                          AND X.PROD_LINE            = Y.LINE_ID
                          AND X.MEASURE              = 'PACK_PROD'
                          AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                          AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (X.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET X.YIELD = S.YIELD
        ;



        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 적용 - START */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- 중장기 :: 첫 1 YEAR 만 적용 */
        /* -- */
        IF (V_PLAN_START_YYYYMMDD = V_CREATE_FROM_YYYYMMDD) THEN
            /* -- 0값으로 초기화 (하이픈을 0 으로 통일) */
            UPDATE SCP_XLS_PSI_GLOBAL
               SET LT_DAY               = 0
             WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
               AND DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
               AND MEASURE              = 'PACK_BOH'
            ;

            /* -- 실제값으로 Update */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.LT_DAY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , CEIL(Y.LT_DAY / 7.0)                                    AS LT_DAY   /* -- Y.LT_DAY :: 2022.05.31 일수에서 주수로 변경 */
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , (SELECT LT_DAY
                                        , SCM_SITE_ID
                                        , ITEM_ID
                                     FROM SCP_MST_OPERATION_LT
                                    WHERE DIVISION_ID  = V_DIVISION_ID
                                      AND LT_OPERATION = 'PRE_INSP'
                                  ) Y
                            WHERE X.ITEM_ID              = Y.ITEM_ID
                              AND X.FROM_SITE            = Y.SCM_SITE_ID
                              AND X.MEASURE              = 'PACK_BOH'
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.LT_DAY = S.LT_DAY
            ;
        END IF;
        /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 적용 - START */


             /*
            -------------------------------------------------------------------------------------------------------------    
            -- SCP_ANL_PSI_GLOBAL.MODEL_INVENTORY --> SCP_XLS_PSI_GLOBAL.PACK_BOH
            -------------------------------------------------------------------------------------------------------------    
               SELECT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,CELL_ITEM_ID,ITEM_ID,FROM_SITE,QTY
                INTO #SCP_XLS_PSI_GLOBAL_AUTO_MODEL_INVENTORY
                FROM SCP_ANL_PSI_GLOBAL X  WITH (NOLOCK)
                 WHERE X.DIVISION_ID			    =  @p_division_id
		                AND X.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                AND X.PLAN_TYPE				    =  @p_plan_type
		                AND X.SEQ					        =  @p_seq
                    AND X.MEASURE             = 'MODEL_INVENTORY'
                    AND X.YYYYMMDD            = @p_plan_start_yyyymmdd

              UPDATE X
                SET X.QTY001            = Y.QTY
                FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
                INNER JOIN #SCP_XLS_PSI_GLOBAL_AUTO_MODEL_INVENTORY Y WITH (NOLOCK)
                ON X.DIVISION_ID   = Y.DIVISION_ID
                AND X.FROM_SITE    = Y.FROM_SITE
                AND X.ITEM_ID      = Y.ITEM_ID
                AND X.MEASURE      ='PACK_BOH'
            */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */

        UPDATE SCP_XLS_PSI_GLOBAL X
           SET ITEM_ID             = (SELECT Y.CHILD_ITEM_ID
                                        FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
                                       WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                         AND Y.MODEL_ID           = X.ITEM_ID
                                         AND Y.OPERATION_GROUP_ID = 'A'
                                         /* 2023.07.01 추가 */
                                         AND Y.CELL_TYPE          = 'CP'
                                         AND ROWNUM               = 1
                                     )
             , TO_SITE             = '-'
             , TO_SITE_DESCRIPTION = '-'
             , PROJECT_CODE        = '-'
             , INCOTERMS           = '-'
             , PROD_LINE           = '-'
         WHERE OPERATION_GROUP      = 'P'
           AND MEASURE             IN ('PACK_CELL_BOH', 'PACK_CELL_EOH')
           AND DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        ;

        UPDATE SCP_XLS_PSI_GLOBAL X
           SET NICK_NAME = (SELECT (CASE WHEN RTRIM(Y.NICK_NAME) IS NULL THEN '-' ELSE Y.NICK_NAME END)  /* AS-IS WHEN Y.NICK_NAME = '' THEN '-' */
                              FROM SCM_MST_ITEM_SN Y
                             WHERE Y.ITEM_ID   = X.ITEM_ID
                               AND Y.NICK_NAME IS NOT NULL
                               AND ROWNUM      = 1
                           )   /* -- 2021.05.27   KSW         NICK NAME 누락오류 수정 :: AND Y.NICK_NAME IS NOT NULL 추가 */
         WHERE OPERATION_GROUP      = 'P'
           AND MEASURE             IN ('PACK_CELL_BOH', 'PACK_CELL_EOH')
           AND DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        ;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* --- 활성화코드 PACK의 CELL ASSAY는 CP로 표기::2023.06.20, KSK */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE SCP_XLS_PSI_GLOBAL
           SET ITEM_ID         = CELL_ITEM_ID
         WHERE OPERATION_GROUP = 'P'
           AND DIVISION_ID     = V_DIVISION_ID   /* -- 2022.03.23	KSW	        GM JV 반영 */
           AND FN_GET_FINAL_ITEM(DIVISION_ID, ITEM_ID, 'IS_CA') = 'Y'
        ;

        UPDATE SCP_XLS_PSI_GLOBAL X
           SET X.CELL_QTY_PACK = (SELECT CEIL(V.ACCUMULATED_CHILD_QTY)   /* AS-IS CONVERT(NVARCHAR(50), CEILING(...)) → 숫자 칸 */
                                    FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
                                   WHERE V.DIVISION_ID        = X.DIVISION_ID
                                     AND V.OPERATION_GROUP_ID = 'A'
                                     AND V.MODEL_ID           = X.ITEM_ID
                                     AND V.CHILD_ITEM_ID      = X.CELL_ITEM_ID
                                     AND ROWNUM               = 1
                                 )
         WHERE 0 = 0
           AND X.OPERATION_GROUP      = 'P'
           AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
           AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        ;


        /* DELETE TBL FROM (SELECT ROW_NUMBER() ... AS ROWNUM ...) AS TBL WHERE TBL.ROWNUM > 1 → ROWID 로 같은 행 삭제 */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL
         WHERE ROWID IN (SELECT TBL.RID
                           FROM (SELECT ROWID                                                                              AS RID
                                      , ROW_NUMBER() OVER(PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RN
                                   FROM SCP_XLS_PSI_GLOBAL
                                  WHERE MEASURE             IN ('PACK_CELL_BOH')
                                    AND DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                                    AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                ) TBL
                          WHERE TBL.RN > 1)
        ;


        DELETE
          FROM SCP_XLS_PSI_GLOBAL
         WHERE ROWID IN (SELECT TBL.RID
                           FROM (SELECT ROWID                                                                              AS RID
                                      , ROW_NUMBER() OVER(PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RN
                                   FROM SCP_XLS_PSI_GLOBAL
                                  WHERE MEASURE             IN ('PACK_CELL_EOH')
                                    AND DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                                    AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                ) TBL
                          WHERE TBL.RN > 1)
        ;

        /* --SEMI_SHIP_PLAN 해상재고 추가로 인한 중복 발생을 제거 하기 위해서 */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL
         WHERE ROWID IN (SELECT TBL.RID
                           FROM (SELECT ROWID                                                   AS RID
                                        /* -- PJ2025F254 2025.12.02 변경전 ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,TO_SITE,FROM_SITE,TRANSPORT_MODE, BOD_ID   ORDER BY BOD_ID desc ) AS ROWNUM		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
                                      , ROW_NUMBER() OVER(PARTITION BY CELL_ITEM_ID
                                                                     , ITEM_ID, TO_SITE
                                                                     , FROM_SITE
                                                                     , NVL(TRANSPORT_MODE, '-')   /* -- PJ2025F254 : ISNULL 처리 (BOD가 없는 경우 중복 데이터 발생 현상 보완) */
                                                                     , NVL(BOD_ID, '-')           /* -- PJ2025F254 : ISNULL 처리 (BOD가 없는 경우 중복 데이터 발생 현상 보완) */
                                                              ORDER BY BOD_ID DESC NULLS LAST) AS RN   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
                                   FROM SCP_XLS_PSI_GLOBAL
                                  WHERE MEASURE             IN ('SEMI_SHIP_PLAN')
                                    AND DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                                    AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                ) TBL
                          WHERE TBL.RN > 1)
        ;

        /* --UPDATE X */
        /* --   SET X.LT_DAY = Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) -- AS LT_FORMATION */
        /* --   --SELECT Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) AS LT_FORMATION,* */
        /* --    FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK) */
        /* --   INNER JOIN SCP_MST_FORMATION Y WITH (NOLOCK) */
        /* --   ON X.DIVISION_ID   = Y.DIVISION_ID */
        /* --   AND X.FROM_SITE    = Y.PLANT_SITE_ID */
        /* --   AND X.ITEM_ID      = Y.ITEM_ID */
        /* --   AND X.MEASURE      ='CELL_PROD' */


        DELETE
          FROM SCP_XLS_PSI_GLOBAL
         WHERE MEASURE              = 'SHIP_PLAN'
           AND TRANSPORT_MODE       = '-'
           AND DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        ;



        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- BOH 반영(SCP_XLS_BOH) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- 중장기 :: 첫 1 YEAR 만 적용 */
        /* -- */
        IF (V_PLAN_START_YYYYMMDD = V_CREATE_FROM_YYYYMMDD) THEN

            /* IF OBJECT_ID('tempdb..#BOH') IS NOT NULL DROP TABLE #BOH
               SELECT ... INTO #BOH FROM SCP_XLS_BOH ... GROUP BY ...
               --  ,ORIGIN_ITEM_ID / --  ,SUM(ORIGIN_QTY) AS ORIGIN_QTY / --  ,ORIGIN_ITEM_ID
               → 원천(SCP_XLS_BOH)이 이 구간에서 바뀌지 않으므로 쓰는 문장마다 같은 집계를 인라인 뷰로 둔다.
               AS-IS ISNULL(ORIGIN_ITEM_ID,'') = '' → Oracle 은 '' 가 NULL : ORIGIN_ITEM_ID IS NULL(공백만 있는 값 포함 RTRIM) */

            /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외 - start */
            /* -- HOLD 가 포함되지 않음 - PACK HOLD 만 해당 */
            /* IF OBJECT_ID('tempdb..#BOH_NHOLD') IS NOT NULL DROP TABLE #BOH_NHOLD → 인라인 뷰 */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , NVL(Y.QTY, 0)                                           AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , (SELECT DIVISION_ID
                                        , PLAN_START_YYYYMMDD
                                        , PLAN_TYPE
                                        , SEQ
                                        , SCM_SITE_ID
                                        , INCOTERMS
                                        , ITEM_ID
                                        , SUM(QTY) AS QTY
                                        /* --  ,ORIGIN_ITEM_ID */
                                        /* --  ,SUM(ORIGIN_QTY) AS ORIGIN_QTY */
                                     FROM SCP_XLS_BOH
                                    WHERE DIVISION_ID         = V_DIVISION_ID
                                      AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND PLAN_TYPE           = P_PLAN_TYPE
                                      AND SEQ                 = V_SEQ
                                      AND RTRIM(ORIGIN_ITEM_ID) IS NULL
                                      AND NOT ATTRIBUTE10  LIKE '%HOLD'   /* -- Pack BOH 수량에서 Hold 수량제외 */
                                    GROUP BY DIVISION_ID
                                           , PLAN_START_YYYYMMDD
                                           , PLAN_TYPE
                                           , SEQ
                                           , SCM_SITE_ID
                                           , INCOTERMS
                                           , ITEM_ID
                                  ) Y   /* #BOH_NHOLD */
                            WHERE 0 = 0
                              AND X.FROM_SITE            = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'PACK_BOH'
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.QTY001 = S.QTY
            ;
            /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외 - end */


            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , NVL(Y.QTY, 0)                                           AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , (SELECT DIVISION_ID
                                        , PLAN_START_YYYYMMDD
                                        , PLAN_TYPE
                                        , SEQ
                                        , SCM_SITE_ID
                                        , INCOTERMS
                                        , ITEM_ID
                                        , SUM(QTY) AS QTY
                                     FROM SCP_XLS_BOH
                                    WHERE DIVISION_ID         = V_DIVISION_ID
                                      AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND PLAN_TYPE           = P_PLAN_TYPE
                                      AND SEQ                 = V_SEQ
                                      AND RTRIM(ORIGIN_ITEM_ID) IS NULL
                                    GROUP BY DIVISION_ID
                                           , PLAN_START_YYYYMMDD
                                           , PLAN_TYPE
                                           , SEQ
                                           , SCM_SITE_ID
                                           , INCOTERMS
                                           , ITEM_ID
                                  ) Y   /* #BOH */
                            WHERE 0 = 0
                              AND X.FROM_SITE            = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외 */
                              /* --AND X.MEASURE              IN ('PACK_BOH','CELL_BOH','PACK_CELL_BOH') */
                              AND X.MEASURE             IN ('CELL_BOH', 'PACK_CELL_BOH')
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.QTY001 = S.QTY
            ;



            /* -- -- 보류중 해제일자가 없는수량 */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , NVL(Y.QTY, 0)                                           AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , (SELECT YA.ITEM_ID
                                        , YA.FROM_SITE
                                        , SUM(YA.QTY) AS QTY
                                     FROM GT_XGLB_ENG_STOCK_PLAN YA
                                    WHERE YA.DESCR = 'WH_HOLD'
                                    GROUP BY YA.ITEM_ID
                                           , YA.FROM_SITE
                                  ) Y
                            WHERE 0 = 0
                              AND X.FROM_SITE            = Y.FROM_SITE
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE             IN ('CELL_BOH', 'PACK_CELL_BOH')   /* -- 2022.08.30   KSW	Cell 재고 개선건 - PACK_CELL_BOH	Cell BOH measure 에서 HOLD 수량제외 */
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.QTY001 = NVL(X.QTY001, 0) - S.QTY
            ;



            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , NVL(Y.QTY, 0)                                           AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , (SELECT DIVISION_ID
                                        , PLAN_START_YYYYMMDD
                                        , PLAN_TYPE
                                        , SEQ
                                        , SCM_SITE_ID
                                        , INCOTERMS
                                        , ITEM_ID
                                        , SUM(QTY) AS QTY
                                     FROM SCP_XLS_BOH
                                    WHERE DIVISION_ID         = V_DIVISION_ID
                                      AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND PLAN_TYPE           = P_PLAN_TYPE
                                      AND SEQ                 = V_SEQ
                                      AND RTRIM(ORIGIN_ITEM_ID) IS NULL
                                    GROUP BY DIVISION_ID
                                           , PLAN_START_YYYYMMDD
                                           , PLAN_TYPE
                                           , SEQ
                                           , SCM_SITE_ID
                                           , INCOTERMS
                                           , ITEM_ID
                                  ) Y   /* #BOH */
                            WHERE 0 = 0
                              AND X.TO_SITE              = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'TO_SITE_BOH'
                              AND X.INCOTERMS            = Y.INCOTERMS
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.QTY001 = S.QTY
            ;

            /* ------------------------------------------------------------------------------------------------------------- */
            /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - Pack BOH(Wait for Inspection) 추가 - start */
            /* ------------------------------------------------------------------------------------------------------------- */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , NVL(Z.QTY, 0)                                           AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , (SELECT Y.ITEM_ID
                                        , Y.FROM_SITE
                                        , SUM(Y.QTY) AS QTY
                                     FROM GT_XGLB_ENG_STOCK_PLAN_INSP Y
                                    WHERE Y.INSP_TYPE = 'INSP_PRE'
                                      /* --AND Y.YYYYMMDD < DATEADD(day, 7, CONVERT(DATE, @p_plan_start_yyyymmdd)) */
                                    GROUP BY Y.ITEM_ID
                                           , Y.FROM_SITE
                                  ) Z
                            WHERE X.ITEM_ID              = Z.ITEM_ID
                              AND X.FROM_SITE            = Z.FROM_SITE
                              AND X.MEASURE              = 'PACK_BOH_WAIT_FOR_INSP'
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.QTY001 = S.QTY
            ;

            /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - Pack BOH(Wait for Inspection) 추가 - end */



            /* --/ * (AS-IS 줄 주석 안의 블록 주석 시작 기호) */
            /* -- 2022.07.29   KSW         DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체 - start */
            /* ------------------------------------------------------------------------------------------------------------- */
            /* --  DIO 관련 시뮬레이션 추가 */
            /* --  2020.06.25   KTH         DIO 수정 관련 */
            /* ------------------------------------------------------------------------------------------------------------- */
            /* IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO_OLD') IS NOT NULL DROP TABLE #tmp_SCP_MST_DIO_OLD → 인라인 뷰 */

            /* -- 변경전 주석처리 */
            /* -- 81 (자동차) 사업부만 해당 */
            IF V_DIVISION_ID <> '81' THEN

                MERGE
                 INTO SCP_XLS_PSI_GLOBAL X
                USING (SELECT IB.RID
                            , IB.GRO_STD_DIO
                            , IB.MIN_STD_DIO
                         FROM (SELECT X.ROWID                                                 AS RID
                                    , Z.GRO_STD_DIO
                                    , Z.MIN_STD_DIO
                                    , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                                 FROM SCP_XLS_PSI_GLOBAL X
                                    , (SELECT A.DIVISION_ID
                                            , A.PLANT_ID
                                            , A.ITEM_ID
                                            , A.GRO_STD_DIO
                                            , A.MIN_STD_DIO
                                         FROM SCP_MST_DIO A
                                            , (SELECT DIVISION_ID
                                                    , PLANT_ID
                                                    , MAX(YYYYQ) AS YYYYQ
                                                 FROM SCP_MST_DIO
                                                WHERE DIVISION_ID IS NOT NULL
                                                GROUP BY DIVISION_ID
                                                       , PLANT_ID
                                              ) B
                                        WHERE A.DIVISION_ID = B.DIVISION_ID
                                          AND A.PLANT_ID    = B.PLANT_ID
                                          AND A.YYYYQ       = B.YYYYQ
                                          AND A.DIVISION_ID = V_DIVISION_ID
                                          /* --and a.YYYYMM      like '201912' -- @p_plan_start_yyyymmdd -- */
                                      ) Z   /* #tmp_SCP_MST_DIO_OLD */
                                WHERE X.CELL_ITEM_ID         = Z.ITEM_ID
                                  /* -- AND X.FROM_SITE   = Z.PLANT_ID */
                                  AND X.MEASURE              = 'ALLOCATION_DIO'
                                  AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                                  AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                              ) IB
                        WHERE IB.RN = 1
                      ) S
                   ON (X.ROWID = S.RID)
                 WHEN MATCHED THEN
                      UPDATE
                         SET X.ATTRIBUTE4 = TO_CHAR(S.GRO_STD_DIO, 'FM99999999999990.000')   /* AS-IS numeric(17,3) → 문자 칸 : 소수 3자리 문자 */
                           , X.ATTRIBUTE5 = TO_CHAR(S.MIN_STD_DIO, 'FM99999999999990.000')
                ;
            END IF;


            IF V_DIVISION_ID = '81' THEN

                /* IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO') IS NOT NULL DROP TABLE #tmp_SCP_MST_DIO → 인라인 뷰 */

                /* -- 변경후 */
                /* declare @p_get_plan_start_yyyymmdd / @p_get_seq / @p_get_ver = '' , @p_get_plan_type = 'FN' → 선언부 V_GET_* */

                /* -- FN 플랜중에서 최신건 */
                /* AS-IS SELECT @변수 = ... : 행이 없으면 변수값 유지 → FOR 루프로 재현 */
                FOR R IN (SELECT A.PLAN_START_YYYYMMDD
                               , TO_CHAR(MAX(A.SEQ)) AS SEQ
                               , TO_CHAR(MAX(A.VER)) AS VER
                            FROM SCP_ANL_DIO_REPORT A
                           WHERE A.DIVISION_ID         = V_DIVISION_ID
                             AND A.PLAN_START_YYYYMMDD = (SELECT MAX(B.PLAN_START_YYYYMMDD)
                                                            FROM SCP_ANL_DIO_REPORT B
                                                           WHERE B.DIVISION_ID = V_DIVISION_ID
                                                             AND B.PLAN_TYPE   = 'FN')
                             AND A.PLAN_TYPE           = 'FN'
                           GROUP BY A.PLAN_START_YYYYMMDD
                         )
                LOOP
                    V_GET_PLAN_START_YYYYMMDD := R.PLAN_START_YYYYMMDD;
                    V_GET_SEQ                 := R.SEQ;
                    V_GET_VER                 := R.VER;
                END LOOP;

                /* -- PLAN_START_YYYYMMDD 기준으로 전주차 FN 이 없을 경우 --> 최신건 */
                /* AS-IS 빈 문자('') <> 날짜 는 참 → Oracle 은 '' 가 NULL 이라 IS NULL 을 함께 본다 */
                IF V_GET_PLAN_START_YYYYMMDD IS NULL
                   OR V_GET_PLAN_START_YYYYMMDD <> TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD') THEN
                    V_GET_PLAN_START_YYYYMMDD := '';
                    V_GET_SEQ                 := '';
                    V_GET_VER                 := '';
                    V_GET_PLAN_TYPE           := '';

                    FOR R IN (SELECT A.PLAN_START_YYYYMMDD
                                   , TO_CHAR(MAX(A.SEQ)) AS SEQ
                                   , TO_CHAR(MAX(A.VER)) AS VER
                                   , A.PLAN_TYPE
                                FROM SCP_ANL_DIO_REPORT A
                               WHERE A.DIVISION_ID         = V_DIVISION_ID
                                 AND A.PLAN_START_YYYYMMDD = (SELECT MAX(B.PLAN_START_YYYYMMDD)
                                                                FROM SCP_ANL_DIO_REPORT B
                                                               WHERE B.DIVISION_ID = '81')
                               GROUP BY A.PLAN_START_YYYYMMDD
                                      , A.PLAN_TYPE
                             )
                    LOOP
                        V_GET_PLAN_START_YYYYMMDD := R.PLAN_START_YYYYMMDD;
                        V_GET_SEQ                 := R.SEQ;
                        V_GET_VER                 := R.VER;
                        V_GET_PLAN_TYPE           := R.PLAN_TYPE;
                    END LOOP;
                END IF;

                /* -- 시뮬레이터에 적용할 경우, cell_item_id 기준으로 CELL 만 존재하는 건과 PACK/CELL 이 모두 있는 건으로 나누어서 업데이트 필요 !!! */
                /* SELECT ... INTO #tmp_SCP_MST_DIO FROM (SCP_ANL_DIO_REPORT) AA → 아래 MERGE 의 인라인 뷰 Z
                   칸 설명 원문 : ISNULL(STANDARD_DIO, 0) AS STANDARD_DIO_AUTO		-- 현업 사용자가 수정한 값 */

                /* -- NICK NAME */
                /* IF OBJECT_ID('tempdb..#tmp_NICK_NAME') IS NOT NULL DROP TABLE #tmp_NICK_NAME
                   SELECT DISTINCT ITEM_ID, NICK_NAME INTO #tmp_NICK_NAME FROM (SCP_MST_FINAL_ITEM ...) AA
                   --ISNULL(ISNULL(LEVEL4, CELL_GROUP), ISNULL(BASIC_NICKNAME_CELL, ISNULL(NICK_NAME, ITEM_ID) )) AS NICK_NAME2
                   → 이 임시 테이블을 쓰는 문장은 아래 주석 블록(PSI UPDATE) 하나뿐이라 결과에 쓰이지 않음 : 생성 생략 */

                /* -- PSI UPDATE */
				/*
				  UPDATE X
					 SET X.ATTRIBUTE4   = Z.GRO_STD_DIO
						,X.ATTRIBUTE5   = Z.MIN_STD_DIO
				   FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
				   INNER JOIN #tmp_NICK_NAME N
					ON X.CELL_ITEM_ID         = N.ITEM_ID
				   INNER JOIN #tmp_SCP_MST_DIO Z  WITH (NOLOCK)
					ON N.NICK_NAME            = Z.NICK_NAME		
				 WHERE X.DIVISION_ID          = @p_division_id
				   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
				   AND X.MEASURE              = 'ALLOCATION_DIO'
				   ;
				   */

                /* -- PSI UPDATE :: SCP_MST_FINAL_ITEM.GROUP_CODE1 적용버전 */
                MERGE
                 INTO SCP_XLS_PSI_GLOBAL X
                USING (SELECT IB.RID
                            , IB.GRO_STD_DIO
                            , IB.MIN_STD_DIO
                         FROM (SELECT X.ROWID                                                 AS RID
                                    , Z.GRO_STD_DIO
                                    , Z.MIN_STD_DIO
                                    , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                                 FROM SCP_XLS_PSI_GLOBAL X
                                    , SCP_MST_FINAL_ITEM N
                                    , (SELECT AA.DIVISION_ID
                                            , ROUND(AA.CELL_SUM + AA.PACK_SUM + AA.DEPARTURE_DAYS_INTRANSIT_VMI2 + AA.SAFETY_STOCK_SUM + AA.PRODUCTION_CYCLE_SUM, 2) AS GRO_STD_DIO
                                            , ROUND(AA.CELL_SUM + AA.PACK_SUM + AA.DEPARTURE_DAYS_INTRANSIT_VMI2, 2)                                               AS MIN_STD_DIO
                                            , AA.FROM_SITE
                                            , AA.NICK_NAME
                                            , AA.CELL_ITEM_ID
                                            , AA.ITEM_ID
                                            , AA.TO_SITE
                                         FROM (SELECT RTRIM(A.DIVISION_ID)                                           AS DIVISION_ID
                                                    , RTRIM(A.FROM_SITE)                                             AS FROM_SITE
                                                    , A.FROM_SITE_DESCRIPTION
                                                    , RTRIM(A.ITEM_ID)                                               AS ITEM_ID
                                                    , A.CELL_ITEM_ID
                                                    , A.TO_SITE
                                                    , A.NICK_NAME
                                                    , NVL(A.CELL_AGING_LT, 0)                                        AS CELL_AGING_LT
                                                    , NVL(A.CELL_EOL_SHIPPING_LOT, 0)                                AS CELL_EOL_SHIPPING_LOT
                                                    , NVL(A.CELL_AGING_LT, 0) + NVL(A.CELL_EOL_SHIPPING_LOT, 0)      AS CELL_SUM
                                                    , NVL(A.PACK_INCOMMING, 0)                                       AS PACK_INCOMMING
                                                    , NVL(A.PACK_OPERATION_LT, 0)                                    AS PACK_OPERATION_LT
                                                    , NVL(A.PACK_INCOMMING, 0) + NVL(A.PACK_OPERATION_LT, 0)         AS PACK_SUM
                                                    , NVL(A.SHIPMENT_CELL_INSPECTION_LOAD, 0)
                                                    + NVL(A.SHIPMENT_CELL_INSPECTION_WAITING, 0)
                                                    + NVL(A.SHIPMENT_PACK_INSPECTION_LOAD, 0)
                                                    + NVL(A.SHIPMENT_PACK_INSPECTION_WAITING, 0)
                                                    + NVL(A.DNI_CELL_DEPARTURE_DAYS, 0)
                                                    + NVL(A.DNI_CELL_DEPARTURE_INLAND, 0)
                                                    + NVL(A.DNI_CELL_WAITING_FOR_SHIPPING, 0)
                                                    + NVL(A.DNI_CELL_VOYAGE, 0)
                                                    + NVL(A.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE, 0)
                                                    + NVL(A.DNI_CELL_ARRIVAL_INLAND, 0)
                                                    + NVL(A.DNI_PACK_DEPARTURE_DAYS, 0)
                                                    + NVL(A.DNI_PACK_DEPARTURE_INLAND, 0)
                                                    + NVL(A.DNI_PACK_WAITING_FOR_SHIPPING, 0)
                                                    + NVL(A.DNI_PACK_VOYAGE, 0)
                                                    + NVL(A.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE, 0)
                                                    + NVL(A.DNI_PACK_ARRIVAL_INLAND, 0)
                                                    + NVL(A.PRE_INSPECTION_CELL, 0)
                                                    + NVL(A.PRE_INSPECTION_PACK, 0)
                                                    + NVL(A.VMI_CELL, 0)
                                                    + NVL(A.VMI_PACK, 0)
                                                    + NVL(A.FOREIGN_CORP, 0)
                                                    + NVL(A.RACK_BIZ, 0)
                                                    + NVL(A.DEPARTURE_INTRANSIT_VMI, 0)                              AS DEPARTURE_DAYS_INTRANSIT_VMI
                                                    , NVL(A.SAFETY_STOCK_CELL, 0)                                    AS SAFETY_STOCK_CELL
                                                    , NVL(A.SAFETY_STOCK_PACK, 0)                                    AS SAFETY_STOCK_PACK
                                                    , NVL(A.SAFETY_STOCK_CELL, 0) + NVL(A.SAFETY_STOCK_PACK, 0)      AS SAFETY_STOCK_SUM
                                                    , NVL(A.PRODUCTION_CYCLE_CELL, 0)                                AS PRODUCTION_CYCLE_CELL
                                                    , NVL(A.PRODUCTION_CYCLE_PACK, 0)                                AS PRODUCTION_CYCLE_PACK
                                                    , NVL(A.PRODUCTION_CYCLE_CELL, 0) + NVL(A.PRODUCTION_CYCLE_PACK, 0) AS PRODUCTION_CYCLE_SUM
                                                    , NVL(A.STANDARD_DIO, 0)                                         AS STANDARD_DIO_AUTO   /* -- 현업 사용자가 수정한 값 */
                                                    , NVL(A.DEPARTURE_INTRANSIT_VMI, 0)                              AS DEPARTURE_DAYS_INTRANSIT_VMI2
                                                 FROM SCP_ANL_DIO_REPORT A
                                                WHERE A.DIVISION_ID         = V_DIVISION_ID
                                                  AND A.PLAN_START_YYYYMMDD = V_GET_PLAN_START_YYYYMMDD
                                                  AND A.PLAN_TYPE           = V_GET_PLAN_TYPE
                                                  AND A.SEQ                 = TO_NUMBER(V_GET_SEQ)
                                                  AND A.VER                 = TO_NUMBER(V_GET_VER)
                                              ) AA
                                      ) Z   /* #tmp_SCP_MST_DIO */
                                WHERE X.DIVISION_ID          = N.DIVISION_ID
                                  AND X.CELL_ITEM_ID         = N.ITEM_ID
                                  AND N.GROUP_CODE1          = Z.NICK_NAME
                                  AND X.DIVISION_ID          = V_DIVISION_ID
                                  AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
                                  AND X.MEASURE              = 'ALLOCATION_DIO'
                              ) IB
                        WHERE IB.RN = 1
                      ) S
                   ON (X.ROWID = S.RID)
                 WHEN MATCHED THEN
                      UPDATE
                         SET X.ATTRIBUTE4 = TO_CHAR(S.GRO_STD_DIO, 'FM9999999999999999999999999990.0000000000')   /* AS-IS numeric(…,10) 합계 → 문자 칸 : 소수 10자리 문자 */
                           , X.ATTRIBUTE5 = TO_CHAR(S.MIN_STD_DIO, 'FM9999999999999999999999999990.0000000000')
                ;
            END IF;
            /* -- 2022.07.29   KSW         DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체 - end */

        END IF;   /* -- IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd)		중장기 :: 첫 1 YEAR 만 적용 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- start */
        /* -- BOD_ID에 대한 from_yyyymmdd, to_yyyymmdd 추가 --> ATTRIBUTE3 */
        /* ------------------------------------------------------------------------------------------------------------- */
        MERGE
         INTO SCP_XLS_PSI_GLOBAL X
        USING (SELECT IB.RID
                    , IB.ATTRIBUTE3
                 FROM (SELECT X.ROWID                                                     AS RID
                              /* AS-IS Z.FROM_YYYYMMDD + ',' + Z.TO_YYYYMMDD : 한쪽이 NULL 이면 전체 NULL → CASE 로 재현 */
                            , CASE WHEN Z.FROM_YYYYMMDD IS NULL OR Z.TO_YYYYMMDD IS NULL THEN NULL
                                   ELSE Z.FROM_YYYYMMDD || ',' || Z.TO_YYYYMMDD
                               END                                                        AS ATTRIBUTE3
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)       AS RN
                         FROM SCP_XLS_PSI_GLOBAL X
                            , SCP_MST_BOD_N_V    Z
                        WHERE X.BOD_ID      = Z.BOD_ID
                          AND X.MEASURE    IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
                          AND X.DIVISION_ID = V_DIVISION_ID   /* -- 2022.03.23	KSW	        GM JV 반영 */
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (X.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET X.ATTRIBUTE3 = S.ATTRIBUTE3
        ;
        /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- end */


        /* ------------------------------------------------------------------------------------------------------------- */
        /* --  52주 데이터 SCRIPT 생성후 UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS : #Rn(WQTY01 ← 1~7일, WQTY02 ← 8~14일 … WQTY52 ← 358~364일 고정 매핑) 과
                   #CALENDAR(생성 From~To 날짜 오름차순 순번 Rn, YYYYMMDD_COLUMN = 'QTY' + 3자리 순번) 을 Rn 으로 붙인 #HEADER 로
                   'UPDATE X SET WQTYnn = (QTYa+QTYb+...)' 문장을 만들어 sp_executesql 로 실행했다.
                   QTY 칸 번호 = 날짜 순번이므로 WQTYnn = QTY(7n-6) + … + QTY(7n) 로 고정된다 → 정적 UPDATE.
           IF OBJECT_ID('tempdb..#Rn') ... CREATE TABLE #Rn ( WEEK_COLUMN NVARCHAR(6), Rn INT ) ... INSERT INTO #Rn SELECT 'WQTY01', 1 UNION ALL ... SELECT 'WQTY52', 364
           --  SELECT 'WQTY' + A.ISO_WEEK     AS WEEK_COLUMN
           --  , ROW_NUMBER() OVER (ORDER BY ISO_WEEK) AS Rn
           --  INTO #Rn
           -- FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)
           --WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd
           --    AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
           IF OBJECT_ID('tempdb..#CALENDAR') ... GROUP BY A.BASIS_YYYYMMDD--,ISO_WEEK--,A.BASIS_YYYYMM,ISO_WEEK
           IF OBJECT_ID('tempdb..#HEADER') ... order by x.rn
           --              PRINT @mQry_sumWeek */
        UPDATE SCP_XLS_PSI_GLOBAL X
           SET X.WQTY01 = (X.QTY001 + X.QTY002 + X.QTY003 + X.QTY004 + X.QTY005 + X.QTY006 + X.QTY007)
             , X.WQTY02 = (X.QTY008 + X.QTY009 + X.QTY010 + X.QTY011 + X.QTY012 + X.QTY013 + X.QTY014)
             , X.WQTY03 = (X.QTY015 + X.QTY016 + X.QTY017 + X.QTY018 + X.QTY019 + X.QTY020 + X.QTY021)
             , X.WQTY04 = (X.QTY022 + X.QTY023 + X.QTY024 + X.QTY025 + X.QTY026 + X.QTY027 + X.QTY028)
             , X.WQTY05 = (X.QTY029 + X.QTY030 + X.QTY031 + X.QTY032 + X.QTY033 + X.QTY034 + X.QTY035)
             , X.WQTY06 = (X.QTY036 + X.QTY037 + X.QTY038 + X.QTY039 + X.QTY040 + X.QTY041 + X.QTY042)
             , X.WQTY07 = (X.QTY043 + X.QTY044 + X.QTY045 + X.QTY046 + X.QTY047 + X.QTY048 + X.QTY049)
             , X.WQTY08 = (X.QTY050 + X.QTY051 + X.QTY052 + X.QTY053 + X.QTY054 + X.QTY055 + X.QTY056)
             , X.WQTY09 = (X.QTY057 + X.QTY058 + X.QTY059 + X.QTY060 + X.QTY061 + X.QTY062 + X.QTY063)
             , X.WQTY10 = (X.QTY064 + X.QTY065 + X.QTY066 + X.QTY067 + X.QTY068 + X.QTY069 + X.QTY070)
             , X.WQTY11 = (X.QTY071 + X.QTY072 + X.QTY073 + X.QTY074 + X.QTY075 + X.QTY076 + X.QTY077)
             , X.WQTY12 = (X.QTY078 + X.QTY079 + X.QTY080 + X.QTY081 + X.QTY082 + X.QTY083 + X.QTY084)
             , X.WQTY13 = (X.QTY085 + X.QTY086 + X.QTY087 + X.QTY088 + X.QTY089 + X.QTY090 + X.QTY091)
             , X.WQTY14 = (X.QTY092 + X.QTY093 + X.QTY094 + X.QTY095 + X.QTY096 + X.QTY097 + X.QTY098)
             , X.WQTY15 = (X.QTY099 + X.QTY100 + X.QTY101 + X.QTY102 + X.QTY103 + X.QTY104 + X.QTY105)
             , X.WQTY16 = (X.QTY106 + X.QTY107 + X.QTY108 + X.QTY109 + X.QTY110 + X.QTY111 + X.QTY112)
             , X.WQTY17 = (X.QTY113 + X.QTY114 + X.QTY115 + X.QTY116 + X.QTY117 + X.QTY118 + X.QTY119)
             , X.WQTY18 = (X.QTY120 + X.QTY121 + X.QTY122 + X.QTY123 + X.QTY124 + X.QTY125 + X.QTY126)
             , X.WQTY19 = (X.QTY127 + X.QTY128 + X.QTY129 + X.QTY130 + X.QTY131 + X.QTY132 + X.QTY133)
             , X.WQTY20 = (X.QTY134 + X.QTY135 + X.QTY136 + X.QTY137 + X.QTY138 + X.QTY139 + X.QTY140)
             , X.WQTY21 = (X.QTY141 + X.QTY142 + X.QTY143 + X.QTY144 + X.QTY145 + X.QTY146 + X.QTY147)
             , X.WQTY22 = (X.QTY148 + X.QTY149 + X.QTY150 + X.QTY151 + X.QTY152 + X.QTY153 + X.QTY154)
             , X.WQTY23 = (X.QTY155 + X.QTY156 + X.QTY157 + X.QTY158 + X.QTY159 + X.QTY160 + X.QTY161)
             , X.WQTY24 = (X.QTY162 + X.QTY163 + X.QTY164 + X.QTY165 + X.QTY166 + X.QTY167 + X.QTY168)
             , X.WQTY25 = (X.QTY169 + X.QTY170 + X.QTY171 + X.QTY172 + X.QTY173 + X.QTY174 + X.QTY175)
             , X.WQTY26 = (X.QTY176 + X.QTY177 + X.QTY178 + X.QTY179 + X.QTY180 + X.QTY181 + X.QTY182)
             , X.WQTY27 = (X.QTY183 + X.QTY184 + X.QTY185 + X.QTY186 + X.QTY187 + X.QTY188 + X.QTY189)
             , X.WQTY28 = (X.QTY190 + X.QTY191 + X.QTY192 + X.QTY193 + X.QTY194 + X.QTY195 + X.QTY196)
             , X.WQTY29 = (X.QTY197 + X.QTY198 + X.QTY199 + X.QTY200 + X.QTY201 + X.QTY202 + X.QTY203)
             , X.WQTY30 = (X.QTY204 + X.QTY205 + X.QTY206 + X.QTY207 + X.QTY208 + X.QTY209 + X.QTY210)
             , X.WQTY31 = (X.QTY211 + X.QTY212 + X.QTY213 + X.QTY214 + X.QTY215 + X.QTY216 + X.QTY217)
             , X.WQTY32 = (X.QTY218 + X.QTY219 + X.QTY220 + X.QTY221 + X.QTY222 + X.QTY223 + X.QTY224)
             , X.WQTY33 = (X.QTY225 + X.QTY226 + X.QTY227 + X.QTY228 + X.QTY229 + X.QTY230 + X.QTY231)
             , X.WQTY34 = (X.QTY232 + X.QTY233 + X.QTY234 + X.QTY235 + X.QTY236 + X.QTY237 + X.QTY238)
             , X.WQTY35 = (X.QTY239 + X.QTY240 + X.QTY241 + X.QTY242 + X.QTY243 + X.QTY244 + X.QTY245)
             , X.WQTY36 = (X.QTY246 + X.QTY247 + X.QTY248 + X.QTY249 + X.QTY250 + X.QTY251 + X.QTY252)
             , X.WQTY37 = (X.QTY253 + X.QTY254 + X.QTY255 + X.QTY256 + X.QTY257 + X.QTY258 + X.QTY259)
             , X.WQTY38 = (X.QTY260 + X.QTY261 + X.QTY262 + X.QTY263 + X.QTY264 + X.QTY265 + X.QTY266)
             , X.WQTY39 = (X.QTY267 + X.QTY268 + X.QTY269 + X.QTY270 + X.QTY271 + X.QTY272 + X.QTY273)
             , X.WQTY40 = (X.QTY274 + X.QTY275 + X.QTY276 + X.QTY277 + X.QTY278 + X.QTY279 + X.QTY280)
             , X.WQTY41 = (X.QTY281 + X.QTY282 + X.QTY283 + X.QTY284 + X.QTY285 + X.QTY286 + X.QTY287)
             , X.WQTY42 = (X.QTY288 + X.QTY289 + X.QTY290 + X.QTY291 + X.QTY292 + X.QTY293 + X.QTY294)
             , X.WQTY43 = (X.QTY295 + X.QTY296 + X.QTY297 + X.QTY298 + X.QTY299 + X.QTY300 + X.QTY301)
             , X.WQTY44 = (X.QTY302 + X.QTY303 + X.QTY304 + X.QTY305 + X.QTY306 + X.QTY307 + X.QTY308)
             , X.WQTY45 = (X.QTY309 + X.QTY310 + X.QTY311 + X.QTY312 + X.QTY313 + X.QTY314 + X.QTY315)
             , X.WQTY46 = (X.QTY316 + X.QTY317 + X.QTY318 + X.QTY319 + X.QTY320 + X.QTY321 + X.QTY322)
             , X.WQTY47 = (X.QTY323 + X.QTY324 + X.QTY325 + X.QTY326 + X.QTY327 + X.QTY328 + X.QTY329)
             , X.WQTY48 = (X.QTY330 + X.QTY331 + X.QTY332 + X.QTY333 + X.QTY334 + X.QTY335 + X.QTY336)
             , X.WQTY49 = (X.QTY337 + X.QTY338 + X.QTY339 + X.QTY340 + X.QTY341 + X.QTY342 + X.QTY343)
             , X.WQTY50 = (X.QTY344 + X.QTY345 + X.QTY346 + X.QTY347 + X.QTY348 + X.QTY349 + X.QTY350)
             , X.WQTY51 = (X.QTY351 + X.QTY352 + X.QTY353 + X.QTY354 + X.QTY355 + X.QTY356 + X.QTY357)
             , X.WQTY52 = (X.QTY358 + X.QTY359 + X.QTY360 + X.QTY361 + X.QTY362 + X.QTY363 + X.QTY364)
         WHERE X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
           AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
        ;



        /* --          ------------------------------------------------------------------------------------------------------------- */
        /* --  WEEK SUM PIVOT 생성 후 UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL DROP TABLE #LineLoad_WEEK; → 아래 인라인 뷰 IA
           IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL DROP TABLE #LineLoad_WEEK_PIVOT; → GTT
           PIVOT ( MIN(WQTY) FOR WEEK_COLUMN IN ([WQTY01] .. [WQTY52]) ) → MIN(CASE WHEN WEEK_COLUMN = 'WQTYnn' THEN WQTY END) */
        DELETE
          FROM GT_XGLS_LINELOAD_WEEK_PVT;

        INSERT
          INTO GT_XGLS_LINELOAD_WEEK_PVT
             ( DIVISION_ID
             , SITE_ID
             , OPERATION_ID
             , PROD_LINE
             , MEASURE
             , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
             , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
             , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
             , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
             , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
             , WQTY51, WQTY52
             )
        SELECT IA.DIVISION_ID
             , IA.SITE_ID
             , IA.OPERATION_ID
             , IA.PROD_LINE
             , IA.MEASURE
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY01' THEN IA.WQTY END) AS WQTY01
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY02' THEN IA.WQTY END) AS WQTY02
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY03' THEN IA.WQTY END) AS WQTY03
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY04' THEN IA.WQTY END) AS WQTY04
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY05' THEN IA.WQTY END) AS WQTY05
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY06' THEN IA.WQTY END) AS WQTY06
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY07' THEN IA.WQTY END) AS WQTY07
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY08' THEN IA.WQTY END) AS WQTY08
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY09' THEN IA.WQTY END) AS WQTY09
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY10' THEN IA.WQTY END) AS WQTY10
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY11' THEN IA.WQTY END) AS WQTY11
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY12' THEN IA.WQTY END) AS WQTY12
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY13' THEN IA.WQTY END) AS WQTY13
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY14' THEN IA.WQTY END) AS WQTY14
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY15' THEN IA.WQTY END) AS WQTY15
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY16' THEN IA.WQTY END) AS WQTY16
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY17' THEN IA.WQTY END) AS WQTY17
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY18' THEN IA.WQTY END) AS WQTY18
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY19' THEN IA.WQTY END) AS WQTY19
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY20' THEN IA.WQTY END) AS WQTY20
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY21' THEN IA.WQTY END) AS WQTY21
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY22' THEN IA.WQTY END) AS WQTY22
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY23' THEN IA.WQTY END) AS WQTY23
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY24' THEN IA.WQTY END) AS WQTY24
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY25' THEN IA.WQTY END) AS WQTY25
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY26' THEN IA.WQTY END) AS WQTY26
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY27' THEN IA.WQTY END) AS WQTY27
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY28' THEN IA.WQTY END) AS WQTY28
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY29' THEN IA.WQTY END) AS WQTY29
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY30' THEN IA.WQTY END) AS WQTY30
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY31' THEN IA.WQTY END) AS WQTY31
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY32' THEN IA.WQTY END) AS WQTY32
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY33' THEN IA.WQTY END) AS WQTY33
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY34' THEN IA.WQTY END) AS WQTY34
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY35' THEN IA.WQTY END) AS WQTY35
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY36' THEN IA.WQTY END) AS WQTY36
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY37' THEN IA.WQTY END) AS WQTY37
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY38' THEN IA.WQTY END) AS WQTY38
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY39' THEN IA.WQTY END) AS WQTY39
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY40' THEN IA.WQTY END) AS WQTY40
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY41' THEN IA.WQTY END) AS WQTY41
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY42' THEN IA.WQTY END) AS WQTY42
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY43' THEN IA.WQTY END) AS WQTY43
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY44' THEN IA.WQTY END) AS WQTY44
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY45' THEN IA.WQTY END) AS WQTY45
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY46' THEN IA.WQTY END) AS WQTY46
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY47' THEN IA.WQTY END) AS WQTY47
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY48' THEN IA.WQTY END) AS WQTY48
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY49' THEN IA.WQTY END) AS WQTY49
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY50' THEN IA.WQTY END) AS WQTY50
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY51' THEN IA.WQTY END) AS WQTY51
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY52' THEN IA.WQTY END) AS WQTY52
          FROM (SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID   AS SITE_ID
                     , A.OPERATION_ID
                     , A.LINE_ID       AS PROD_LINE
                     , A.MEASURE
                     , CASE WHEN SUM(A.WORKING_TIME) <= 0.0 THEN 0
                            /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 - start */
                            /* -- 변경전 */
                            /* -- */
                            /* --ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100 */
                            /* -- */
                            ELSE NVL((ROUND(SUM(A.CAPA_TACT), 0) / (SUM(A.WORKING_TIME) - NVL(SUM(A.TIME_TERM), 0))), 0) * 100
                            /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 - end */
                        END            AS WQTY
                     , A.ISO_YYYYWW
                     , A.WEEK_COLUMN
                  FROM GT_XGLS_LINELOAD A
                 GROUP BY A.DIVISION_ID
                        , A.SCM_SITE_ID
                        , A.OPERATION_ID
                        , A.LINE_ID
                        , A.MEASURE
                        , A.ISO_YYYYWW
                        , A.WEEK_COLUMN
               ) IA   /* #LineLoad_WEEK */
         GROUP BY IA.DIVISION_ID
                , IA.SITE_ID
                , IA.OPERATION_ID
                , IA.PROD_LINE
                , IA.MEASURE
        ;


        MERGE
         INTO SCP_XLS_PSI_GLOBAL X
        USING (SELECT IB.*
                 FROM (SELECT X.ROWID                                                     AS RID
                            , Y.WQTY01
                            , Y.WQTY02
                            , Y.WQTY03
                            , Y.WQTY04
                            , Y.WQTY05
                            , Y.WQTY06
                            , Y.WQTY07
                            , Y.WQTY08
                            , Y.WQTY09
                            , Y.WQTY10
                            , Y.WQTY11
                            , Y.WQTY12
                            , Y.WQTY13
                            , Y.WQTY14
                            , Y.WQTY15
                            , Y.WQTY16
                            , Y.WQTY17
                            , Y.WQTY18
                            , Y.WQTY19
                            , Y.WQTY20
                            , Y.WQTY21
                            , Y.WQTY22
                            , Y.WQTY23
                            , Y.WQTY24
                            , Y.WQTY25
                            , Y.WQTY26
                            , Y.WQTY27
                            , Y.WQTY28
                            , Y.WQTY29
                            , Y.WQTY30
                            , Y.WQTY31
                            , Y.WQTY32
                            , Y.WQTY33
                            , Y.WQTY34
                            , Y.WQTY35
                            , Y.WQTY36
                            , Y.WQTY37
                            , Y.WQTY38
                            , Y.WQTY39
                            , Y.WQTY40
                            , Y.WQTY41
                            , Y.WQTY42
                            , Y.WQTY43
                            , Y.WQTY44
                            , Y.WQTY45
                            , Y.WQTY46
                            , Y.WQTY47
                            , Y.WQTY48
                            , Y.WQTY49
                            , Y.WQTY50
                            , Y.WQTY51
                            , Y.WQTY52
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)       AS RN
                         FROM SCP_XLS_PSI_GLOBAL         X
                            , GT_XGLS_LINELOAD_WEEK_PVT  Y
                        WHERE Y.PROD_LINE            = X.PROD_LINE
                          AND X.DIVISION_ID          = Y.DIVISION_ID
                          AND X.FROM_SITE            = Y.SITE_ID
                          AND X.ATTRIBUTE9           = Y.OPERATION_ID
                          AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          AND X.MEASURE             IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD')
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (X.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET X.WQTY01 = S.WQTY01
                   , X.WQTY02 = S.WQTY02
                   , X.WQTY03 = S.WQTY03
                   , X.WQTY04 = S.WQTY04
                   , X.WQTY05 = S.WQTY05
                   , X.WQTY06 = S.WQTY06
                   , X.WQTY07 = S.WQTY07
                   , X.WQTY08 = S.WQTY08
                   , X.WQTY09 = S.WQTY09
                   , X.WQTY10 = S.WQTY10
                   , X.WQTY11 = S.WQTY11
                   , X.WQTY12 = S.WQTY12
                   , X.WQTY13 = S.WQTY13
                   , X.WQTY14 = S.WQTY14
                   , X.WQTY15 = S.WQTY15
                   , X.WQTY16 = S.WQTY16
                   , X.WQTY17 = S.WQTY17
                   , X.WQTY18 = S.WQTY18
                   , X.WQTY19 = S.WQTY19
                   , X.WQTY20 = S.WQTY20
                   , X.WQTY21 = S.WQTY21
                   , X.WQTY22 = S.WQTY22
                   , X.WQTY23 = S.WQTY23
                   , X.WQTY24 = S.WQTY24
                   , X.WQTY25 = S.WQTY25
                   , X.WQTY26 = S.WQTY26
                   , X.WQTY27 = S.WQTY27
                   , X.WQTY28 = S.WQTY28
                   , X.WQTY29 = S.WQTY29
                   , X.WQTY30 = S.WQTY30
                   , X.WQTY31 = S.WQTY31
                   , X.WQTY32 = S.WQTY32
                   , X.WQTY33 = S.WQTY33
                   , X.WQTY34 = S.WQTY34
                   , X.WQTY35 = S.WQTY35
                   , X.WQTY36 = S.WQTY36
                   , X.WQTY37 = S.WQTY37
                   , X.WQTY38 = S.WQTY38
                   , X.WQTY39 = S.WQTY39
                   , X.WQTY40 = S.WQTY40
                   , X.WQTY41 = S.WQTY41
                   , X.WQTY42 = S.WQTY42
                   , X.WQTY43 = S.WQTY43
                   , X.WQTY44 = S.WQTY44
                   , X.WQTY45 = S.WQTY45
                   , X.WQTY46 = S.WQTY46
                   , X.WQTY47 = S.WQTY47
                   , X.WQTY48 = S.WQTY48
                   , X.WQTY49 = S.WQTY49
                   , X.WQTY50 = S.WQTY50
                   , X.WQTY51 = S.WQTY51
                   , X.WQTY52 = S.WQTY52
        ;

        /* -- LT_TOTAL_BY_WEEK */
        /* -- BOD LT (SHIP_PLAN/SEMI_SHIP_PLAN) : BOD L/T 계산시 1~7일 구간은 반올림, 이후 구간은 올림 처리 */
           /*
              UPDATE X
                 SET X.LT_DAY = (CASE WHEN (Y.LT_TOTAL/7.0) < 1   THEN ROUND ((Y.LT_TOTAL/7.0),0,0) ELSE CEILING((Y.LT_TOTAL/7.0))  END) 
                FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
                INNER JOIN SCP_MST_BOD_V  Y WITH (NOLOCK)
                ON X.DIVISION_ID    = Y.DIVISION_ID
                AND X.FROM_SITE     = Y.FROM_SITE
                AND X.TO_SITE       = Y.TO_SITE
                AND X.TRANSPORT_MODE= Y.TRANSPORT_MODE
                AND X.BOD_ID        = Y.BOD_ID
              */




        /* -- LT_DAY 업데이트 - 2021.08.10 KSW - start */
        /* -- 중장기 :: 첫 1 YEAR 만 적용 */
        /* -- */
        IF (V_PLAN_START_YYYYMMDD = V_CREATE_FROM_YYYYMMDD) THEN

            /* AS-IS INT 칸(LT_DAY) 적재 : 소수는 버림(MSSQL 숫자→INT 변환) → TRUNC */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.LT_DAY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , TRUNC(Y.LT_TOTAL)                                       AS LT_DAY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , SCP_MST_BOD_N_V    Y   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                            WHERE X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.FROM_SITE            = Y.FROM_SITE
                              AND X.TO_SITE              = Y.TO_SITE
                              AND X.TRANSPORT_MODE       = Y.TRANSPORT_MODE
                              AND X.BOD_ID               = Y.BOD_ID
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.LT_DAY      = S.LT_DAY
                       , X.ATTRIBUTE10 = 'NO_LT_DIVIDE'   /* -- 2022.05.24 LT오류반영 */
            ;

            /* -- LT_DAY 업데이트 - 2022.03.02 - BOD 정보가 없는 SEMI_SHIP_PLAN UPDATE - START */
            /* AS-IS Y.FROM_YYYYMMDD + ',' + Y.TO_YYYYMMDD : 한쪽이 NULL 이면 전체 NULL → CASE 로 재현 */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.LT_DAY
                        , IB.BOD_ID
                        , IB.ATTRIBUTE3
                     FROM (SELECT X.ROWID                                                 AS RID
                                , TRUNC(Y.LT_TOTAL)                                       AS LT_DAY
                                , Y.BOD_ID
                                , CASE WHEN Y.FROM_YYYYMMDD IS NULL OR Y.TO_YYYYMMDD IS NULL THEN NULL
                                       ELSE Y.FROM_YYYYMMDD || ',' || Y.TO_YYYYMMDD
                                   END                                                    AS ATTRIBUTE3
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , SCP_MST_BOD_N_V    Y   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                            WHERE X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.FROM_SITE            = Y.FROM_SITE
                              AND X.TO_SITE              = Y.TO_SITE
                              AND X.TRANSPORT_MODE       = Y.TRANSPORT_MODE
                              AND X.BOD_ID               = '-'
                              AND X.MEASURE              = 'SEMI_SHIP_PLAN'
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.LT_DAY      = S.LT_DAY
                       , X.BOD_ID      = S.BOD_ID
                       , X.ATTRIBUTE3  = S.ATTRIBUTE3
                       , X.ATTRIBUTE10 = 'NO_LT_DIVIDE'   /* -- 2022.05.24 LT오류반영 */
            ;

            /* -- SEMI_SHIP_PLAN 에서 TRANSPORT_MODE, BOD_ID 가 NULL 인건 삭제 */
            DELETE
              FROM SCP_XLS_PSI_GLOBAL
             WHERE MEASURE        = 'SEMI_SHIP_PLAN'
               AND BOD_ID         IS NULL
               AND TRANSPORT_MODE IS NULL
               AND DIVISION_ID    = V_DIVISION_ID   /* -- 2022.03.23	KSW	        GM JV 반영 */
            ;
            /* -- LT_DAY 업데이트 - 2022.03.02 - BOD 정보가 없는 SEMI_SHIP_PLAN UPDATE - END */


            /* -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 */
            /* -- VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 더해 줌 */
            /* -- 2022.05.24 LT오류반영 */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.LT_DAY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , (CASE WHEN ((NVL(X.LT_DAY, 0) + NVL(Y.LT_DAY, 0)) / 7.0) < 1 THEN ROUND(((NVL(X.LT_DAY, 0) + NVL(Y.LT_DAY, 0)) / 7.0), 0)
                                        ELSE CEIL(((NVL(X.LT_DAY, 0) + NVL(Y.LT_DAY, 0)) / 7.0))
                                    END)                                                  AS LT_DAY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , (SELECT S.DIVISION_ID
                                        , S.SCM_SITE_ID
                                        , S.ITEM_ID
                                        , MAX(NVL(S.SCP_VMI_LT, 0)) AS LT_DAY
                                     FROM SCM_MST_SITE_ITEM            S
                                        , SCM_ADM_LOOKUP_MASTER_DETAIL MD
                                    WHERE S.DIVISION_ID  = MD.SEGMENT1
                                      AND S.SCM_SITE_ID  = MD.SEGMENT2
                                      AND MD.LOOKUP_TYPE = 'VMI_LT_SITE'
                                      AND S.VALID_YN     = 'Y'
                                      AND MD.VALID_YN    = 'Y'
                                    GROUP BY S.DIVISION_ID
                                           , S.SCM_SITE_ID
                                           , S.ITEM_ID
                                  ) Y
                            WHERE X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.TO_SITE              = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.LT_DAY      = S.LT_DAY
                       , X.ATTRIBUTE10 = NULL
            ;


            /* -- 2022.05.24 LT오류반영 - start */
            /* -- VMI LT 업데이트에서 누락된 모든 LT를 7로 나눈값을 적용한다 */
            UPDATE SCP_XLS_PSI_GLOBAL X
               /* -- E20250722-000632 (LT 일수와  주간수에서  7진법 적용, KSK) */
               SET X.LT_DAY               = ROUND(X.LT_DAY / 7.0, 0)
                 , X.ATTRIBUTE10          = NULL
             WHERE X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
               AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
               AND X.ATTRIBUTE10          = 'NO_LT_DIVIDE'
            ;
            /* -- 2022.05.24 LT오류반영 - end */

            /* --SELECT * INTO ##SCP_XLS_PSI_GLOBAL2  FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK) */
            /* --RETURN; */

            /* -- * 2020.03.31   KTH         CELL_PROD LT로직 변경 */
            /* AS-IS CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) : 빈 문자·'-'·'+' 는 0 으로 바뀐다(MSSQL 변환 규칙) → CASE 로 재현 */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.LT_DAY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , (CEIL(NVL(Y.LT_FORMATION + (CASE WHEN TRIM(Y.ATTRIBUTE1) IS NULL OR TRIM(Y.ATTRIBUTE1) IN ('-', '+') THEN 0
                                                                   ELSE TO_NUMBER(TRIM(Y.ATTRIBUTE1))
                                                               END), 0) / 7.0)) AS LT_DAY
                                  /* --,Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) AS LT_FORMATION */
                                  /* --,Y.LT_FORMATION,ISNULL(Y.ATTRIBUTE1, '0'), * */
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , SCP_MST_FORMATION  Y
                            WHERE X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.FROM_SITE            = Y.PLANT_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'CELL_PROD'
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.LT_DAY = S.LT_DAY
            ;

            /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - FROM_BOH_QTY 컬럼에 Pack BOH (Hold) 통합수량 update - start */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL X
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                                                 AS RID
                                , NVL(Y.QTY, 0)                                           AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL)   AS RN
                             FROM SCP_XLS_PSI_GLOBAL X
                                , (SELECT ITEM_ID
                                        , FROM_SITE
                                        , SUM(QTY) AS QTY
                                     FROM GT_XGLB_ENG_STOCK_PLAN_INSP
                                    WHERE (INSP_TYPE = 'INSP_HOLD' OR DESCR LIKE '%HOLD')
                                      AND NOT INSP_TYPE = 'INSP_PRE'
                                    GROUP BY ITEM_ID
                                           , FROM_SITE
                                  ) Y
                            WHERE 0 = 0
                              AND X.FROM_SITE            = Y.FROM_SITE
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'PACK_BOH_HOLD'
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
                              AND X.DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (X.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET X.FROM_BOH_QTY = S.QTY
            ;
            /* -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - FROM_BOH_QTY 컬럼에 Pack BOH (Hold) 통합수량 update - end */
        END IF;
        /* -- 중장기 :: 첫 1 YEAR 만 적용 */
        /* -- LT_DAY 업데이트 - 2021.08.10 KSW - end */


        /* -- 중복 오류 보정 */
        /* --  SELECT * */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL
         WHERE ROWID IN (SELECT TBL.RID
                           FROM (SELECT ROWID                                                   AS RID
                                      , ROW_NUMBER() OVER(PARTITION BY CELL_ITEM_ID, ITEM_ID, NICK_NAME, TO_SITE, PROJECT_CODE, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE, BOD_ID
                                                              ORDER BY BOD_ID DESC NULLS LAST) AS RN   /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 중복제거시 BOD_ID 추가 */
                                      /* --                                 ,* */
                                   FROM SCP_XLS_PSI_GLOBAL
                                  WHERE MEASURE             IN ('SEMI_SHIP_PLAN', 'SHIP_PLAN')   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 SHIP_PLAN 추가 */
                                    AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD   /* -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                    AND DIVISION_ID          = V_DIVISION_ID            /* -- 2022.03.23	KSW	        GM JV 반영 */
                                ) TBL
                          WHERE TBL.RN > 1)
        ;


/* AS-IS 주석 원문 (L2412~L2467)
-- 2022.08.30   KSW			Cell 재고 개선건 :: PR_SCP_XLS_PSI_GLOBAL 에서 수량을 보정하지 않아도 처리할 수 있도록 수정
				---- CELL_FORM_HOLD_AFTER(After Form. Hold Release) Measure 값 보완 - start
				---- 52주 첫회전 일 경우 (CREATE_FROM_YYYYMMDD = PLAN_START_YYYYMMDD)
				--IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd)
				--BEGIN
    --              UPDATE X
    --              SET X.FROM_BOH_QTY = ISNULL(X.FROM_BOH_QTY,0) -
    --                                  (ISNULL(WQTY01,0)+ISNULL(WQTY02,0)+ISNULL(WQTY03,0)+ISNULL(WQTY04,0)+ISNULL(WQTY05,0)+ISNULL(WQTY06,0)+ISNULL(WQTY07,0)+ISNULL(WQTY08,0)+ISNULL(WQTY09,0)+ISNULL(WQTY10,0)
    --                                                        +ISNULL(WQTY11,0)+ISNULL(WQTY12,0)+ISNULL(WQTY13,0)+ISNULL(WQTY14,0)+ISNULL(WQTY15,0)+ISNULL(WQTY16,0)+ISNULL(WQTY17,0)+ISNULL(WQTY18,0)+ISNULL(WQTY19,0)+ISNULL(WQTY20,0)
    --                                                        +ISNULL(WQTY21,0)+ISNULL(WQTY22,0)+ISNULL(WQTY23,0)+ISNULL(WQTY24,0)+ISNULL(WQTY25,0)+ISNULL(WQTY26,0)+ISNULL(WQTY27,0)+ISNULL(WQTY28,0)+ISNULL(WQTY29,0)+ISNULL(WQTY30,0)
    --                                                        +ISNULL(WQTY31,0)+ISNULL(WQTY32,0)+ISNULL(WQTY33,0)+ISNULL(WQTY34,0)+ISNULL(WQTY35,0)+ISNULL(WQTY36,0)+ISNULL(WQTY37,0)+ISNULL(WQTY38,0)+ISNULL(WQTY39,0)+ISNULL(WQTY40,0)
    --                                                        +ISNULL(WQTY41,0)+ISNULL(WQTY42,0)+ISNULL(WQTY43,0)+ISNULL(WQTY44,0)+ISNULL(WQTY45,0)+ISNULL(WQTY46,0)+ISNULL(WQTY47,0)+ISNULL(WQTY48,0)+ISNULL(WQTY49,0)+ISNULL(WQTY50,0)
    --                                                        +ISNULL(WQTY51,0)+ISNULL(WQTY52,0)
    --                                   )
    --              FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
    --              WHERE MEASURE ='CELL_FORM_HOLD_AFTER'
				--  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
				--  AND DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영

				--END

-- 2022.08.30   KSW			Cell 재고 개선건 :: PR_SCP_XLS_PSI_GLOBAL 에서 수량을 보정하지 않아도 처리할 수 있도록 수정
				---- 중장기 52주 이후 구간은 30주 구간의 합산 - 추후 플랜기간이 늘어날 경우 대비  --> 52주로 변경 2022.08.29
				--IF (@p_plan_start_yyyymmdd <> @p_create_from_yyyymmdd)
				--BEGIN
				--	DECLARE @p_real_to_yyyymmdd		nvarchar(12) = CONVERT(VARCHAR(8), DATEADD(day, 52*7, @p_create_from_yyyymmdd), 112);		-- 30주 --> 52주로 변경 2022.08.29

				--	  SET     @mQry_sum = 'ISNULL(WQTY01,0)';
				--	  SELECT  @mQry_sum = @mQry_sum+
				--		  CASE
				--		  WHEN 1 = 1 THEN  '+ISNULL('+A.WEEK_NO+',0)'
				--		  END +''+CHAR(10)
				--	  FROM (
				--			SELECT 'WQTY'+RIGHT('0'+CONVERT(VARCHAR(2), ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)),2) AS WEEK_NO
  	 -- 				  FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)
	 		--			   WHERE A.BASIS_YYYYMMDD     >= @p_create_from_yyyymmdd
				--	   AND A.BASIS_YYYYMMDD     <=  @p_real_to_yyyymmdd
				--	   and A.DAYOFWEEK = 'SUN'
				--	  ) AS A
				--	  WHERE A.WEEK_NO <> 'WQTY01'
				--	;

				--	--select @mQry_sum;

				--	SET @mEXEC = '';
				--	SET @mEXEC = 'UPDATE X '+CHAR(10)
				--	SET @mEXEC = @mEXEC + 'SET X.FROM_BOH_QTY = (' + @mQry_sum + ') ' + CHAR(10)
				--	SET @mEXEC = @mEXEC + 'FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK) ' + CHAR(10)
				--	SET @mEXEC = @mEXEC + 'WHERE X.MEASURE = ''CELL_FORM_HOLD_AFTER'''  + CHAR(10)
				--	SET @mEXEC = @mEXEC + '  AND X.CREATE_FROM_YYYYMMDD = ''' + @p_create_from_yyyymmdd + '''' + CHAR(10)
				--	SET @mEXEC = @mEXEC + '  AND X.DIVISION_ID          = ''' + @p_division_id + '''' + CHAR(10)					-- 2022.03.23	KSW	        GM JV 반영

				--	--select @mEXEC;
				--	EXEC sp_executesql @mEXEC;
				--END
				---- CELL_FORM_HOLD_AFTER(After Form. Hold Release) Measure 값 보완 - end
*/

        /* -- ITEM_ID 없는 PACK_CELL_BOH, PACK_CELL_EOH 삭제 - 2021.11.17 KSW */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL
         WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
           AND DIVISION_ID          = V_DIVISION_ID   /* -- 2022.03.23	KSW	        GM JV 반영 */
           AND MEASURE             IN ('PACK_CELL_BOH', 'PACK_CELL_EOH')
           AND ITEM_ID             IS NULL
        ;

        /* -- PACK 영역에 추가된 SEMI 삭제 - 2021.11.17 KSW */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL
         WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
           AND DIVISION_ID          = V_DIVISION_ID   /* -- 2022.03.23	KSW	        GM JV 반영 */
           AND MEASURE             IN ('SEMI_WHIN', 'SEMI_INTRANSIT', 'SEMI_INTRANSIT_ETA', 'SEMI_SHIP_PLAN_ETA', 'SEMI_SHIP_PLAN')
           AND OPERATION_GROUP      = 'P'
        ;

        /* -- PACK_CELL_BOH_HOLD 단독으로 존재하는 모델 PACK_CELL_BOH_HOLD 삭제 - 2022.08.30   KSW			Cell 재고 개선건 */
        /* DELETE Y FROM (...) X INNER JOIN SCP_XLS_PSI_GLOBAL Y ON ... → EXISTS */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL Y
         WHERE EXISTS (SELECT 1
                         FROM (SELECT S.CELL_ITEM_ID
                                    , S.ITEM_ID
                                    , S.FROM_SITE
                                    , SUM(S.CNT) AS CNT
                                 FROM (SELECT A.CELL_ITEM_ID
                                            , A.ITEM_ID
                                            , A.FROM_SITE
                                            , (CASE WHEN A.MEASURE = 'PACK_CELL_BOH' THEN 1 ELSE 2 END) AS CNT
                                         FROM SCP_XLS_PSI_GLOBAL A
                                        WHERE A.DIVISION_ID = V_DIVISION_ID
                                          AND A.MEASURE    IN ('PACK_CELL_BOH_HOLD', 'PACK_CELL_BOH')
                                      ) S
                                GROUP BY S.CELL_ITEM_ID
                                       , S.ITEM_ID
                                       , S.FROM_SITE
                              ) X
                        WHERE X.CELL_ITEM_ID = Y.CELL_ITEM_ID
                          AND X.ITEM_ID      = Y.ITEM_ID
                          AND X.FROM_SITE    = Y.FROM_SITE
                          AND X.CNT          = 2)
           AND Y.DIVISION_ID = V_DIVISION_ID
           AND Y.MEASURE     = 'PACK_CELL_BOH_HOLD'
        ;

        /* IF OBJECT_ID('TEMPDB..#PSI_GLOBAL_FINAL') IS NOT NULL DROP TABLE #PSI_GLOBAL_FINAL
           SELECT ... INTO #PSI_GLOBAL_FINAL ... / INSERT SCP_XLS_PSI_GLOBAL (...) SELECT * FROM #PSI_GLOBAL_FINAL
           → 한 번만 쓰는 임시 테이블이라 INSERT ... SELECT 한 문장으로 옮김(칸·값 동일) */
        /* -- 2022.08.30   KSW			Cell 재고 개선건 */
        /* -- PACK_CELL_BOH_HOLD measure가 없는 PACK_CELL_BOH 그룹에 PACK_CELL_BOH_HOLD 추가 */
        INSERT
          INTO SCP_XLS_PSI_GLOBAL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , CREATE_FROM_YYYYMMDD
             , CREATE_TO_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
             , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
             , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
             , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
             , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
             , WQTY51, WQTY52
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT Y.DIVISION_ID
             , Y.PLAN_START_YYYYMMDD
             , Y.CREATE_FROM_YYYYMMDD
             , Y.CREATE_TO_YYYYMMDD
             , Y.PLAN_TYPE
             , Y.SEQ
             , Y.OPERATION_GROUP
             , Y.OPERATION_GROUP_NAME
             , Y.CELL_ITEM_ID
             , Y.ITEM_ID
             , Y.NICK_NAME
             , Y.CELL_QTY_PACK
             , Y.TO_SITE
             , Y.TO_SITE_DESCRIPTION
             , Y.PROJECT_CODE
             , Y.FROM_BOH_QTY
             , Y.TO_BOH_QTY
             , Y.INCOTERMS
             , Y.FROM_SITE
             , Y.FROM_SITE_DESCRIPTION
             , Y.TRANSPORT_MODE
             , Y.PROD_LINE
             , Y.LT_DAY
             , Y.BOD_ID
             , 'PACK_CELL_BOH_HOLD'      AS MEASURE
             , 'Cell BOH(Hold)'          AS MEASURE_LABEL
               /* --	,Y.XLS_KEY1  100*10000         AS XLS_KEY1  -- 레코드 추가시의 충돌오류 회피를 위해  키값에  백만을 곱하기 */
             , Y.XLS_KEY1 + 1000000      AS XLS_KEY1   /* -- 레코드 추가시의 충돌오류 회피를 위해  키값에  백만을 곱하기 */
             , Y.XLS_KEY2
             , Y.XLS_KEY3
             , Y.XLS_KEY4
             , Y.XLS_KEY5
             , Y.XLS_ATTRIBUTE1
             , Y.XLS_ATTRIBUTE2
             , Y.XLS_ATTRIBUTE3
             , Y.XLS_ATTRIBUTE4
             , Y.XLS_ATTRIBUTE5
             , B.SORT_ORDER_NO + 5       AS SORT_ORDER_NO
             , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
             , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
             , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
             , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
             , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
             , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
             , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
             , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
             , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
             , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
             , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
             , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
             , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
             , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
             , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
             , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
             , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
             , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
             , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
             , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
             , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
             , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
             , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
             , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
             , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
             , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
             , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
             , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
             , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
             , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
             , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
             , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
             , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
             , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
             , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
             , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
             , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
             , 0 AS WQTY01, 0 AS WQTY02, 0 AS WQTY03, 0 AS WQTY04, 0 AS WQTY05, 0 AS WQTY06, 0 AS WQTY07, 0 AS WQTY08, 0 AS WQTY09, 0 AS WQTY10
             , 0 AS WQTY11, 0 AS WQTY12, 0 AS WQTY13, 0 AS WQTY14, 0 AS WQTY15, 0 AS WQTY16, 0 AS WQTY17, 0 AS WQTY18, 0 AS WQTY19, 0 AS WQTY20
             , 0 AS WQTY21, 0 AS WQTY22, 0 AS WQTY23, 0 AS WQTY24, 0 AS WQTY25, 0 AS WQTY26, 0 AS WQTY27, 0 AS WQTY28, 0 AS WQTY29, 0 AS WQTY30
             , 0 AS WQTY31, 0 AS WQTY32, 0 AS WQTY33, 0 AS WQTY34, 0 AS WQTY35, 0 AS WQTY36, 0 AS WQTY37, 0 AS WQTY38, 0 AS WQTY39, 0 AS WQTY40
             , 0 AS WQTY41, 0 AS WQTY42, 0 AS WQTY43, 0 AS WQTY44, 0 AS WQTY45, 0 AS WQTY46, 0 AS WQTY47, 0 AS WQTY48, 0 AS WQTY49, 0 AS WQTY50
             , 0 AS WQTY51, 0 AS WQTY52
             , Y.CREATED_BY
             , Y.CREATION_DATE
             , Y.LAST_UPDATED_BY
             , Y.LAST_UPDATE_DATE
             , Y.ATTRIBUTE1
             , Y.ATTRIBUTE2
             , Y.ATTRIBUTE3
             , Y.ATTRIBUTE4
             , Y.ATTRIBUTE5
             , Y.ATTRIBUTE6
             , Y.ATTRIBUTE7
             , Y.ATTRIBUTE8
             , Y.ATTRIBUTE9
             , Y.ATTRIBUTE10
          FROM (SELECT S.CELL_ITEM_ID
                     , S.ITEM_ID
                     , S.FROM_SITE
                     , SUM(S.CNT) AS CNT
                  FROM (SELECT A.CELL_ITEM_ID
                             , A.ITEM_ID
                             , A.FROM_SITE
                             , (CASE WHEN A.MEASURE = 'PACK_CELL_BOH' THEN 1 ELSE 2 END) AS CNT
                          FROM SCP_XLS_PSI_GLOBAL A
                         WHERE A.DIVISION_ID          = V_DIVISION_ID
                           AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
                           AND A.MEASURE             IN ('PACK_CELL_BOH_HOLD', 'PACK_CELL_BOH')
                           AND A.CELL_ITEM_ID        IS NOT NULL
                       ) S
                 GROUP BY S.CELL_ITEM_ID
                        , S.ITEM_ID
                        , S.FROM_SITE
               )                     X
             , SCP_XLS_PSI_GLOBAL    Y
             , (SELECT *
                  FROM SCM_MST_SHEET_MEASURE
                 WHERE COLUMN_NAME = 'PACK_CELL_BOH'
                   AND PROGRAM_ID  = 'XLSPSI01'
               )                     B
         WHERE X.CELL_ITEM_ID         = Y.CELL_ITEM_ID
           AND X.ITEM_ID              = Y.ITEM_ID
           AND X.FROM_SITE            = Y.FROM_SITE
           AND Y.MEASURE              = B.COLUMN_NAME
           AND X.CNT                  = 1
           AND Y.DIVISION_ID          = V_DIVISION_ID
           AND Y.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
           AND Y.MEASURE              = 'PACK_CELL_BOH'
           AND Y.CELL_ITEM_ID        IS NOT NULL
        ;


        /* -- 2022.10.11	KSW			W01 ~ W08 주차 합산 생산계획이 0 일 경우 1 추가 건에 대한 처리 - START */
        /* -- W01 ~ W08 주차 0 엔진계획이 0 값 모델 리스트 */
        IF P_PLAN_TYPE = 'PR' AND V_CREATE_FROM_YYYYMMDD = V_PLAN_START_YYYYMMDD THEN
            /* IF OBJECT_ID('tempdb..#tmp_W1W8_ZERO_MODEL') IS NOT NULL DROP TABLE #tmp_W1W8_ZERO_MODEL
               SELECT ITEM_ID, SCM_SITE_ID, LINE_ID INTO #tmp_W1W8_ZERO_MODEL FROM (...) S WHERE S.S_QTY = 0
               → 한 번만 쓰는 임시 테이블이라 EXISTS 의 인라인 뷰로 옮김(값을 가져오지 않고 짝 존재만 본다) */
            UPDATE SCP_XLS_PSI_GLOBAL X
               SET X.XLS_ATTRIBUTE1 = 'A_SET'
                   /* --,X.QTY001			= 1		-- 저장할 때 1값 저장하는 것으로 변경 */
                   /* --,X.WQTY01			= 1 */
             WHERE EXISTS (SELECT 1
                             FROM (SELECT ITEM_ID
                                        , SCM_SITE_ID
                                        , LINE_ID
                                        , SUM(QTY) AS S_QTY
                                     FROM SCP_ANL_PRODUCTION_PLAN
                                    WHERE DIVISION_ID         = V_DIVISION_ID
                                      AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND PLAN_TYPE           = P_PLAN_TYPE
                                      AND SEQ                 = V_SEQ
                                      AND MEASURE             = 'PROD_PLAN_AMEND'
                                      /* --AND YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day,  7 * 8, @p_plan_start_yyyymmdd), 112) */
                                      AND YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_CREATE_TO_YYYYMMDD   /* -- 8주에서 전체 플랜구간 */
                                    GROUP BY ITEM_ID
                                           , SCM_SITE_ID
                                           , LINE_ID
                                  ) Z   /* #tmp_W1W8_ZERO_MODEL */
                            WHERE X.ITEM_ID   = Z.ITEM_ID
                              AND X.FROM_SITE = Z.SCM_SITE_ID
                              AND X.PROD_LINE = Z.LINE_ID
                              AND Z.S_QTY     = 0)
               AND X.DIVISION_ID          = V_DIVISION_ID
               AND X.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
               AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
               AND X.PLAN_TYPE            = P_PLAN_TYPE
               AND X.SEQ                  = V_SEQ
               AND X.MEASURE             IN ('PACK_PROD', 'CELL_PROD')
            ;

            /* IF OBJECT_ID('tempdb..#tmp_W1W8_ZERO_MODEL') IS NOT NULL DROP TABLE #tmp_W1W8_ZERO_MODEL */
        END IF;
        /* -- 2022.10.11	KSW			W01 ~ W08 주차 합산 생산계획이 0 일 경우 1 추가 건에 대한 처리 - END */


        /* -- TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := SQL%ROWCOUNT;
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
            /* --    ROLLBACK TRAN T1 */
            /* --  END; */

            /* -- ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );
            /* --      PRINT @@ERROR */
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
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );
    O_RETURN := 1;  /* return 1 */
    RETURN;
END;