PROCEDURE PR_SCP_XLS_DAILY_SMALL
(
      P_DIVISION_ID          IN  VARCHAR2         DEFAULT '40'
    , P_PLAN_START_YYYYMMDD  IN  VARCHAR2         DEFAULT '20250224'
    , P_CELL_LIST            IN  VARCHAR2         DEFAULT NULL
    , P_BP_FLAG              IN  CHAR             DEFAULT 'N'
    , P_MEASURE_LIST         IN  VARCHAR2         DEFAULT NULL
    , P_PLANT                IN  VARCHAR2         DEFAULT 'NJ01-A'
    , O_RESULT_CURSOR        OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_SCP_XLS_DAILY_SMALL
 * Description  : SCP SIMULATION EXCEL SHEET BODY QUERY(Daily)
 *
	exec PR_SCP_XLS_DAILY_SMALl '40', '20250407', 'MCCM134010A1', 'N'

	exec PR_SCP_XLS_DAILY_SMALl '40', '20250407', 'MCCM348014A3', 'N'

	exec PR_SCP_XLS_DAILY_SMALl '40', '20250407', 'MCCM350415A1', 'N', 'CELL_EOH'

	exec PR_SCP_XLS_DAILY_SMALl '40', '20250407', 'MCCM350415A1', 'N', 'CELL_EOH', 'NJ01-A'


 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.02.04  KSK         Initial Release
 * 2025.02.27  KSK         팀명 중복방지 및 정렬조건 보완(INCOTERMS,  PROJECT_CODE 추가등)
 * 2025.03.27  KSK         생산계획 및 재고 메저 추가
 * 2025.06.04  KSK         CELL_FORM_HOLD_AFTER 추가조회
 * 2025.06.24  KSK         CELL PROD 메저의 LT와 LINE 정보 제거
 * 2025.06.24  KSK         기말재고로직변경
 * 2025.06.24  KSK         재고메저추가관련 수율로직개선(널데이터를 1로 처리ㅣ
 * 2025.10.22  PWC         FROM BOH QTY수량을 CP,CA1,CA2의 합, CELL_FORM_HOLD_AFTER는 CP,CA1수량의 합
 * 2025.11.12  KSK         E20251112-000986 소형 셀 시뮬레이터 홀드재고 이슈 (보류재고 처리 보완)
 * 2025.12.05  KSK        E20251105-001003  소형셀 시뮬레이터 신규 measure 추가 요청건 ( SEMI_SHIP_PLAN_ORG , SEMI_SHIP_GAP_ACC)
 * 2026.02.25  PWC        E20260126-000229  소형셀 시뮬레이터 PLANT별 조회기능 추가
 * 2026.07.31  ZIONEX  [PJ202650304] NextSCM Migration
 */
/* DECLARE 디버깅 */
/*   @P_DIVISION_ID VARCHAR(10) = '40' */
/* , @P_PLAN_START_YYYYMMDD VARCHAR(10) = '20251027' */
/* , @P_CELL_LIST  NVARCHAR(MAX) =  'MCCM348018A3' */
/* , @P_BP_FLAG  CHAR(1) = 'N' */
/* , @P_MEASURE_LIST VARCHAR(4000) = 'CELL_EOH' */
/* , @P_PLANT VARCHAR(10) = 'NJ01-A'     [E20260126-000229]  2026.2.26 PWC PLANT별 조회기능추가 */
AS
    /* MSSQL 본문 중간 DECLARE 를 선언부로 이동(CV-011) */
    /*   @v_create_from_yyyymmdd2 varchar(10) : 원본에서도 선언/대입만 하고 본문 어디에서도 참조하지 않는다(1:1 보존) */
    /*   @V_CELLS varchar(MAX)                : PRINT(=DBMS_OUTPUT) 전용 디버그 변수 */
    V_CREATE_FROM_YYYYMMDD2  VARCHAR2(10 CHAR);
    V_CELLS                  VARCHAR2(32767 CHAR);
BEGIN

    /* CONVERT(VARCHAR(8), DATEADD(day, 364, @P_PLAN_START_YYYYMMDD), 112) -> TO_CHAR(TO_DATE(..)+364,'YYYYMMDD') (CV-066) */
    V_CREATE_FROM_YYYYMMDD2 := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD');

    /* MSSQL DECLARE @TV_CELL TABLE ( CELL_ITEM_ID NVARCHAR(150) PRIMARY KEY ) -> GTT GT_SXDS_TV_CELL (CV-035 / LS-042 1:1) */


    DELETE FROM GT_SXDS_TV_CELL;

    /* INSERT @TV_CELL (생산라인이 있는 아이템 여부) */
    /*      SELECT DISTINCT  CELL_ITEM_ID */
    /*      FROM SCP_XLS_PSI_GLOBAL_SMALL WITH (NOLOCK) */
    /*      WHERE PROD_LINE IN ( SELECT DISTINCT  S.PROD_LINE */
    /*                                  FROM SCP_XLS_PSI_GLOBAL_SMALL S  WITH (NOLOCK) */
    /*                                  WHERE PROD_LINE <> '-' */
    /*                                  AND S.CELL_ITEM_ID IN (SELECT TOKEN FROM STRING_SPLIT(@P_CELL_LIST, ',')) */
    /*                                  ) */
    /*      UNION */
    /*      SELECT DISTINCT CELL_ITEM_ID */
    /*      FROM SCP_XLS_PSI_GLOBAL_SMALL WITH (NOLOCK) */
    /*      WHERE CELL_ITEM_ID IN (SELECT TOKEN FROM STRING_SPLIT(@P_CELL_LIST, ',')) */

    INSERT INTO GT_SXDS_TV_CELL
    SELECT COLUMN_VALUE
      FROM TABLE(STRING_SPLIT(P_CELL_LIST, ','));

    /* STRING_AGG -> LISTAGG (CV-022). 원본 @V_CELLS 가 varchar(MAX) 라 4000 초과 가능 -> ORA-01489 회피용 */

    SELECT LISTAGG(CELL_ITEM_ID, ',' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY CELL_ITEM_ID)
      INTO V_CELLS
      FROM GT_SXDS_TV_CELL;


    DBMS_OUTPUT.PUT_LINE('조회할 셀목록=> ' || V_CELLS);

    OPEN O_RESULT_CURSOR FOR
    WITH YY AS
    ( SELECT Y.DIVISION_ID
           , Y.PLAN_START_YYYYMMDD
           , Y.CREATE_FROM_YYYYMMDD
           , Y.PLAN_TYPE
           , Y.SEQ
           , Y.OPERATION_GROUP
           , Y.OPERATION_GROUP_NAME
           , Y.FROM_SITE
           , FROM_SITE_DESCRIPTION
           , Y.CELL_ITEM_ID
           , Y.ITEM_ID
           , Y.NICK_NAME
           , CELL_QTY_PACK
           , Y.TO_SITE
           , TO_SITE_DESCRIPTION
           , Y.PROJECT_CODE
           , FROM_BOH_QTY
           , TO_BOH_QTY
           , Y.INCOTERMS
           , Y.TRANSPORT_MODE
           , YIELD
           , PROD_LINE
           , Y.BOD_ID
             /* , DI.DEPT_NAME_KO */
           , ( SELECT PRIORITY
                 FROM SCP_MST_BOD_V
                WHERE DIVISION_ID = P_DIVISION_ID
                  AND BOD_ID = Y.BOD_ID ) AS PRIORITY
             /* LT 정보 */

           , CASE WHEN NVL(Y.LT_DAY, 0) = 0 THEN 0
                  WHEN MEASURE = 'CELL_PROD' THEN
                       ( SELECT LT_FORMATION + TO_NUMBER(NVL(F.ATTRIBUTE1, 0))
                           FROM SCP_MST_FORMATION F
                          WHERE F.DIVISION_ID = Y.DIVISION_ID
                            AND F.PLANT_SITE_ID = Y.FROM_SITE
                            AND F.ITEM_ID = Y.ITEM_ID
                            AND Y.MEASURE = 'CELL_PROD'
                            AND ROWNUM = 1 )
                  WHEN EXISTS ( SELECT 1
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL MD
                                     , SCM_MST_SITE_ITEM S
                                 WHERE S.DIVISION_ID = MD.SEGMENT1
                                   AND S.SCM_SITE_ID = MD.SEGMENT2
                                   AND MD.LOOKUP_TYPE = 'VMI_LT_SITE'
                                   AND S.VALID_YN = 'Y'
                                   AND MD.VALID_YN = 'Y'
                                   AND S.DIVISION_ID = Y.DIVISION_ID
                                   AND S.SCM_SITE_ID = Y.FROM_SITE ) THEN
                       ( SELECT MAX(NVL(S.SCP_VMI_LT, 0))
                           FROM SCM_MST_SITE_ITEM S
                          WHERE S.DIVISION_ID = Y.DIVISION_ID
                            AND S.SCM_SITE_ID = Y.FROM_SITE )
                  WHEN EXISTS ( SELECT 1
                                  FROM SCP_MST_OPERATION_LT OP
                                 WHERE Y.MEASURE = 'PACK_BOH'
                                   AND OP.DIVISION_ID = Y.DIVISION_ID
                                   AND OP.ITEM_ID = Y.ITEM_ID
                                   AND OP.SCM_SITE_ID = Y.FROM_SITE
                                   AND OP.LT_OPERATION = 'PRE_INSP' ) THEN
                       ( SELECT LT_DAY
                           FROM SCP_MST_OPERATION_LT OP
                          WHERE OP.DIVISION_ID = Y.DIVISION_ID
                            AND OP.ITEM_ID = Y.ITEM_ID
                            AND OP.SCM_SITE_ID = Y.FROM_SITE
                            AND LT_OPERATION = 'PRE_INSP' )
                  ELSE NVL(B.LT_TOTAL, 0)
                  END AS LT_DAY
           , Y.ATTRIBUTE4 AS "GRO STD DIO"
           , Y.ATTRIBUTE5 AS "MIN STD DIO"
           , MEASURE
           , MEASURE_LABEL
           , CASE MEASURE
                  WHEN 'MKT_FCST' THEN 10
                  WHEN 'ALLOCATION' THEN 20
                  WHEN 'FCST_RTF_ACC' THEN 30
                  WHEN 'TO_SITE_BOH' THEN 40
                  WHEN 'TO_SITE_EOH' THEN 50
                  WHEN 'INTRANSIT' THEN 60
                  WHEN 'INTRANSIT_ETA' THEN 70
                  WHEN 'WHIN_TOTAL' THEN 80
                  WHEN 'WHIN' THEN 90
                  WHEN 'SHIP_REQ' THEN 95
                  WHEN 'SHIP_PLAN_ETA' THEN 100
                  WHEN 'SEMI_SHIP_PLAN_ORG' THEN 105
                  WHEN 'SEMI_SHIP_PLAN' THEN 110
                  WHEN 'SEMI_SHIP_GAP_ACC' THEN 115
                  WHEN 'SHIP_PLAN' THEN 120
                  WHEN 'SHIP_PLAN_PLANT' THEN 130
                  END AS MEASURE_ORDER
           , XLS_KEY1
             /* 일간데이터 */
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
           , Y.CREATED_BY
           , Y.CREATION_DATE
           , Y.LAST_UPDATED_BY
           , Y.LAST_UPDATE_DATE
           , Y.ATTRIBUTE1
           , Y.ATTRIBUTE3
           , Y.ATTRIBUTE9
           , Y.ATTRIBUTE10
           , CASE WHEN Y.CELL_ITEM_ID = Y.ITEM_ID THEN 'FG' ELSE 'SEMI' END AS ITEM_TYPE
           , CASE WHEN Y.MEASURE IN ('CELL_EOH', 'CELL_FOR_FORM_END', 'CELL_PROD_FORM_END', 'CELL_PROD'
           , 'CELL_FORM_PROGRESS', 'CELL_FORM_HOLD_UNDER_AVAILABLE'
           , 'CELL_FORM_HOLD_AFTER') THEN 'PROD'
                  ELSE 'SHIP'
                  END AS SHEET_TYPE   /* (KSK, 250605 위치조정 및 메저추가) */
        FROM SCP_XLS_PSI_GLOBAL_SMALL Y
           , GT_SXDS_TV_CELL C
           , SCP_MST_BOD_V B
       WHERE 0 = 0
         AND Y.CELL_ITEM_ID = C.CELL_ITEM_ID
         AND B.DIVISION_ID(+) = Y.DIVISION_ID
         AND B.BOD_ID(+) = Y.BOD_ID
         AND Y.OPERATION_GROUP = 'A'
         AND Y.DIVISION_ID = P_DIVISION_ID
         AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
         AND EXISTS ( SELECT 1
                        FROM TABLE(STRING_SPLIT(P_MEASURE_LIST, ','))
                       WHERE COLUMN_VALUE = Y.MEASURE
                      UNION ALL
                      SELECT 1
                        FROM DUAL
                       WHERE P_MEASURE_LIST IS NULL )
         AND EXISTS ( SELECT 1
                        FROM DUAL
                       WHERE P_BP_FLAG = 'N'
                         AND P_PLAN_START_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
                      UNION ALL
                      SELECT 1
                        FROM DUAL
                       WHERE P_BP_FLAG = 'Y'
                         AND P_PLAN_START_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
                      UNION ALL
                      SELECT 1
                        FROM DUAL
                       WHERE P_BP_FLAG = 'Y'
                         AND P_PLAN_START_YYYYMMDD < Y.CREATE_FROM_YYYYMMDD )
           /* 출하관련 */
           /* 생산 및 재고관련 : CELL_FORM_HOLD_AFTER (KSK, 250604, 재고관련 매저추가) */
           /* SEMI_SHIP_PLAN_ORG, SEMI_SHIP_GAP_ACC : E20251105-001003 */
         AND Y.MEASURE IN ('MKT_FCST', 'ALLOCATION', 'FCST_RTF_ACC', 'TO_SITE_BOH', 'TO_SITE_EOH', 'INTRANSIT'
                         , 'INTRANSIT_ETA', 'WHIN_TOTAL', 'WHIN', 'SHIP_PLAN', 'SEMI_SHIP_PLAN', 'SHIP_PLAN_PLANT', 'SHIP_PLAN_ETA', 'SHIP_REQ'
                         , 'SEMI_SHIP_PLAN_ORG', 'SEMI_SHIP_GAP_ACC'
                         , 'CELL_EOH', 'CELL_FOR_FORM_END', 'CELL_PROD_FORM_END', 'CELL_PROD', 'CELL_FORM_PROGRESS', 'CELL_FORM_HOLD_UNDER_AVAILABLE'
                         , 'CELL_FORM_HOLD_AFTER')
    )
    /* -ENTRY ------------------------------------------------------------------------------------------------------------------------------------------ */
    SELECT YY.DIVISION_ID AS DIVISION
         , PLAN_START_YYYYMMDD
         , CREATE_FROM_YYYYMMDD
         , PLAN_TYPE
         , SEQ
         , YY.OPERATION_GROUP AS OPERATION
         , FROM_SITE
         , FROM_SITE_DESCRIPTION AS "FROM SITE"
         , YY.CELL_ITEM_ID AS "CELL ITEM ID"
         , YY.ITEM_ID AS "ITEM ID"
         , YY.NICK_NAME AS NICK
         , FN_XLS_TEAM(YY.DIVISION_ID, YY.TO_SITE, YY.ITEM_ID, YY.PROJECT_CODE) AS TEAM
         , CELL_QTY_PACK AS "CELL QTY"
         , MEASURE
           /* 2025.10.22  WC PARK  FROM BOH QTY수량을 CP,CA1,CA2까지 모두 합산한 값이 되도록 수정 */
           /* ,  (CASE WHEN MEASURE = 'CELL_EOH' THEN FROM_BOH_QTY + ( SELECT SUM(FROM_BOH_QTY) */
           /*                     FROM SCP_XLS_PSI_GLOBAL_SMALL AS SUB WITH (NOLOCK) */
           /*                 WHERE SUB.CELL_ITEM_ID = YY.CELL_ITEM_ID */
           /*                 AND  SUB.FROM_SITE = YY.FROM_SITE */
           /*                 AND SUB.CELL_ITEM_ID <> SUB.ITEM_ID  SEMI */
           /*                 AND SUB.MEASURE = 'CELL_EOH' ) (KSK, 오형선책책임요청) */
           /*     ELSE  YY.FROM_BOH_QTY END ) AS  "FROM BOH QTY" */
         , (CASE WHEN MEASURE = 'CELL_EOH' THEN
                      (CASE WHEN YY.CELL_ITEM_ID <> YY.ITEM_ID THEN
                                 (FROM_BOH_QTY + ( SELECT SUM(FROM_BOH_QTY)
                                                     FROM SCP_XLS_PSI_GLOBAL_SMALL SUB
                                                    WHERE SUB.CELL_ITEM_ID = YY.CELL_ITEM_ID
                                                      AND SUB.FROM_SITE = YY.FROM_SITE
                                                      AND SUB.CELL_ITEM_ID <> SUB.ITEM_ID   /* SEMI */
                                                        /* E20251112-000986 (1차년도의 2차년도 수량표시 방지) */
                                                      AND YY.PLAN_START_YYYYMMDD = YY.CREATE_FROM_YYYYMMDD
                                                      AND SUB.MEASURE = 'CELL_EOH' ))
                            ELSE
                                 ( SELECT SUM(B.QTY)
                                     FROM SCP_MST_FINAL_ITEM A
                                        , ( SELECT ITEM_ID, QTY
                                              FROM SCP_XLS_BOH S
                                             WHERE SCM_SITE_ID = YY.FROM_SITE
                                               /* E20251112-000986 (BOH 수량에서 보류재고 제외함) */
                                               AND ATTRIBUTE10 <> 'WH_HOLD'
                                               AND YY.PLAN_START_YYYYMMDD = YY.CREATE_FROM_YYYYMMDD ) B
                                    WHERE A.ITEM_ID = B.ITEM_ID
                                      AND ATTRIBUTE1 = YY.CELL_ITEM_ID
                                      AND ATTRIBUTE8 LIKE 'C%'
                                    GROUP BY A.ATTRIBUTE1 )
                            END)
                 ELSE YY.FROM_BOH_QTY
                 END) AS "FROM BOH QTY"
         , MEASURE_LABEL AS "MEASURE LABEL"
         , PROJECT_CODE AS PROJECT
         , TO_SITE
         , TO_SITE_DESCRIPTION AS "TO SITE"
         , INCOTERMS
         , BOD_ID AS "BOD ID"
         , TRANSPORT_MODE AS "TRANS"
         , CASE WHEN MEASURE IN ('CELL_FORM_HOLD_AFTER', 'CELL_FORM_HOLD_UNDER_AVAILABLE') THEN NVL(YIELD, 1)
                ELSE YIELD
                END AS YIELD   /* (KSK오형선책임요청) */
         , PROD_LINE AS LINE
         , ITEM_TYPE
         , LT_DAY
         , PRIORITY
         , ATTRIBUTE4 AS "GRO STD DIO"
         , ATTRIBUTE5 AS "MIN STD DIO"
           /* , YEAR1_KEY */
           /* , YEAR2_KEY */
         , MEASURE_ORDER
         , XLS_KEY1
           /* 2025.10.22  WC PARK  QTY001수량을 CP,CA1을 합산한 값이 되도록 수정 */
         , (CASE WHEN MEASURE = 'CELL_FORM_HOLD_AFTER' THEN
                      (CASE WHEN YY.CELL_ITEM_ID <> YY.ITEM_ID THEN QTY001
                            ELSE
                                 ( SELECT SUM(B.QTY001)
                                     FROM SCP_MST_FINAL_ITEM A
                                        , ( SELECT CELL_ITEM_ID, ITEM_ID, FROM_SITE, QTY001
                                              FROM SCP_XLS_PSI_GLOBAL_SMALL S
                                             WHERE MEASURE = 'CELL_FORM_HOLD_AFTER'
                                               /* E20251112-000986 소형 셀 시뮬레이터 홀드재고 이슈 (HOLD 재고의 1,2차년도  중복반영 제거)) */
                                               AND S.CREATE_FROM_YYYYMMDD = YY.CREATE_FROM_YYYYMMDD ) B
                                    WHERE A.ITEM_ID = B.ITEM_ID
                                      AND A.ATTRIBUTE1 = YY.CELL_ITEM_ID
                                      AND A.ATTRIBUTE8 IN ('CP', 'CA1')
                                      AND B.FROM_SITE = YY.FROM_SITE
                                    GROUP BY A.ATTRIBUTE1 )
                            END)
                 ELSE QTY001
                 END) AS "QTY001"
             , QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010, QTY011
             , QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020, QTY021
             , QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030, QTY031
             , QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040, QTY041
             , QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050, QTY051
             , QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060, QTY061
             , QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070, QTY071
             , QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080, QTY081
             , QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090, QTY091
             , QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100, QTY101
             , QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110, QTY111
             , QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120, QTY121
             , QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130, QTY131
             , QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140, QTY141
             , QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150, QTY151
             , QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160, QTY161
             , QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170, QTY171
             , QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180, QTY181
             , QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190, QTY191
             , QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200, QTY201
             , QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210, QTY211
             , QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220, QTY221
             , QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230, QTY231
             , QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240, QTY241
             , QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250, QTY251
             , QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260, QTY261
             , QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270, QTY271
             , QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280, QTY281
             , QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290, QTY291
             , QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300, QTY301
             , QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310, QTY311
             , QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320, QTY321
             , QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330, QTY331
             , QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340, QTY341
             , QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350, QTY351
             , QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360, QTY361
             , QTY362, QTY363, QTY364
         , YY.CREATED_BY
         , YY.CREATION_DATE
         , YY.LAST_UPDATED_BY
         , YY.LAST_UPDATE_DATE
         , YY.ATTRIBUTE1
         , YY.ATTRIBUTE3   /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 */
         , YY.ATTRIBUTE9
         , YY.ATTRIBUTE10
         , YY.SHEET_TYPE   /* (KSK  코드위치이동) */
         , 0 AS RNO   /* 입력시트의 PSI참조행번호 (KSK, 250409) */
      FROM YY
         , SCP_MST_FINAL_ITEM B
     WHERE 1 = 1
       AND YY.DIVISION_ID = B.DIVISION_ID(+)
       AND YY.ITEM_ID = B.ITEM_ID(+)
       /* 완제품의 경우 FORM 메저 제외 */
       AND NOT (ITEM_TYPE = 'FG' AND YY.MEASURE IN ('CELL_FOR_FORM_END', 'CELL_PROD_FORM_END', 'CELL_FORM_PROGRESS', 'CELL_FORM_HOLD_UNDER_AVAILABLE'))
       AND NOT (ITEM_TYPE = 'SEMI' AND YY.MEASURE IN ('CELL_EOH', 'CELL_FORM_HOLD_AFTER'))   /* (KSK, 요형선책임 요청) */
       /* [E20260126-000229]  2026.2.26 PWC PLANT별 조회기능추가 : CHARINDEX(a,b) -> INSTR(b,a) (CV-020) */
       AND INSTR(P_PLANT, FROM_SITE) > 0
     ORDER BY CREATE_FROM_YYYYMMDD
            , SHEET_TYPE DESC   /* 시트분리기준 */
            , YY.FROM_SITE
            , YY.CELL_ITEM_ID
            , ITEM_TYPE   /* 제품먼저(KSK, 250407) */
            , YY.ITEM_ID
            , MEASURE_ORDER
            , TO_SITE
              /* , YY.DEPT_NAME_KO */
            , INCOTERMS
            , PROJECT_CODE
            , XLS_KEY1;   /* REQ TO PLAN 복사시 순서역전 방지를 위해 추가(KSK, 250319) */

END;