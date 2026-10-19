CREATE OR REPLACE PROCEDURE           "DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP" 
(
    p_division_id            IN  VARCHAR2,
    p_dept_id                IN  VARCHAR2,    --Department
    p_end_customer           IN  VARCHAR2,    --Endcustomer
    p_scm_site_id            IN  VARCHAR2,
    p_plant_site_id          IN  VARCHAR2,
    p_project_code           IN  VARCHAR2,
    p_item_id                IN  VARCHAR2,
    p_customer_project_code  IN  VARCHAR2,
    p_customer_model         IN  VARCHAR2,
    p_from_yyyymmdd          IN  VARCHAR2,
    p_to_yyyymmdd            IN  VARCHAR2,
    p_biztype                IN  VARCHAR2,
    p_created_by             IN  VARCHAR2,
    p_userinfo               IN  VARCHAR2,
    p_owner                  IN  VARCHAR2,
    p_over_range             IN  VARCHAR2,   -- [PJ20200138]범위 초과 Flag
    p_invalid_exec           IN  VARCHAR2,   -- [C20200612-000174] ESS사업부 New Model Flag
    p_cur                    OUT SYS_REFCURSOR
)
IS
/* 2026.05.20  ZIONEX        [PJ202650304]  NextSCM Migration */

    -- SET NOCOUNT ON;
    -- SET ANSI_WARNINGS OFF;

    --SELECT 'TEST01' AS DIVISION_ID , '1' AS SCM_SITE_ID , 'M1' AS MEASURE
    --UNION ALL
    --SELECT 'TEST02' AS DIVISION_ID , '2' AS SCM_SITE_ID , 'M2' AS MEASURE

    --DECLARE @v_dept_id nvarchar(max)='';
    v_group_id          VARCHAR2(50 CHAR) := '';
    v_program_id        VARCHAR2(4000 CHAR) := 'DMF0020';       -- 20180605 수정
    v_to_yyyymmdd2      VARCHAR2(8 CHAR);                       -- [PJ20200138] 비교 날짜
    v_valid_yn          VARCHAR2(10 CHAR) := 'Y';  --[C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공

    --IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
    --    SET @v_group_id = 'ADMIN'

    v_prod              CLOB;
    v_prod_pivot        CLOB;  /* 2026.08.14 AJS PIVOT IN 절 전용(상수+별칭). v_prod 는 SELECT 목록용 식별자 목록이라 형식이 다름 */
    v_nsql              CLOB;
    v_admin_cnt         NUMBER;
BEGIN

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    SELECT NVL(COUNT(1), 0)
      INTO v_admin_cnt
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN = 'Y'
       AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
       AND (SEGMENT1 = p_userinfo
            OR SEGMENT1 IN (SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M /* [AUTHUNION 2026-08-05] */
                            WHERE USER_ID IN (p_userinfo, p_created_by) AND USE_YN = 'Y'));

    IF v_admin_cnt > 0 THEN
        v_group_id := 'ADMIN';
    END IF;
    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    v_prod := ''; v_prod_pivot := '';

    --[C20200506-000201] 속도개선 임시테이블 #tmpItem, #tmpPlanData 추가
    -- GTT 사용: TRUNCATE 로 세션 데이터 초기화
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0020_ITEM';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0020_PLAN_DATA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0020_DATA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0020_OUTPUT';
    -- [PJ20200138] 범위를 초과하는 대상 테이블
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0020_OVER_RANGE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0020_OVER_RANGE_LIST';
    --[C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0020_SALES_SITE_MODEL_ALL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0020_SALES_SITE_MODEL';


    -- [PJ20200138] 범위 초과 대상
    IF (p_over_range = 'Y') THEN
        v_to_yyyymmdd2 := TO_CHAR(TO_DATE(p_to_yyyymmdd, 'YYYYMMDD') + 7, 'YYYYMMDD');

        INSERT INTO GT_DMF0020_OVER_RANGE (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD)
        SELECT DISTINCT AA.DIVISION_ID, AA.PROJECT_CODE, AA.SCM_SITE_ID, AA.PLANT_SITE_ID, AA.ITEM_ID, AA.CURRENCY, AA.MEASURE, AA.DOM_EXP, AA.FCST_TYPE, AA.INCOTERMS, AA.YYYYMMDD
          FROM
            -- 기준데이터
            (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, YYYYMMDD
                , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS ROW_NO
            FROM SCM_MST_FUTURE_PRICE  A
            WHERE DIVISION_ID = p_division_id
            AND   MEASURE = 'LOC'
            AND   YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
            ) AA,
            -- 비교용 데이터 ( 다음주 )
            (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, YYYYMMDD
                , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS ROW_NO
            FROM SCM_MST_FUTURE_PRICE   A
            WHERE DIVISION_ID = p_division_id
            AND   MEASURE = 'LOC'
            AND   YYYYMMDD BETWEEN p_from_yyyymmdd AND v_to_yyyymmdd2
            ) BB,
            -- 비교용 데이터 ( 직전주차-없으면 마지막 주차 )
            (
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
                , A.YYYYMMDD
            FROM SCM_MST_FUTURE_PRICE  A,
                (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
                    , MAX(YYYYMMDD) AS YMD
                FROM SCM_MST_FUTURE_PRICE  A
                WHERE DIVISION_ID = p_division_id
                AND   MEASURE = 'LOC'
                AND   YYYYMMDD < p_from_yyyymmdd
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
                ) B
                WHERE A.DIVISION_ID = B.DIVISION_ID
                    AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND A.ITEM_ID = B.ITEM_ID
                    AND A.CURRENCY = B.CURRENCY
                    AND A.MEASURE = B.MEASURE
                    AND A.DOM_EXP = B.DOM_EXP
                    AND A.FCST_TYPE = B.FCST_TYPE
                    AND A.INCOTERMS = B.INCOTERMS
                    AND A.YYYYMMDD = B.YMD
            ) CC,
            (SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS LIMIT_RATE
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE  VALID_YN = 'Y'
                AND    LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE' ) L
         WHERE AA.DIVISION_ID = BB.DIVISION_ID(+)
           AND AA.PROJECT_CODE = BB.PROJECT_CODE(+)
           AND AA.SCM_SITE_ID = BB.SCM_SITE_ID(+)
           AND AA.PLANT_SITE_ID = BB.PLANT_SITE_ID(+)
           AND AA.ITEM_ID = BB.ITEM_ID(+)
           AND AA.CURRENCY = BB.CURRENCY(+)
           AND AA.MEASURE = BB.MEASURE(+)
           AND AA.DOM_EXP = BB.DOM_EXP(+)
           AND AA.FCST_TYPE = BB.FCST_TYPE(+)
           AND AA.INCOTERMS = BB.INCOTERMS(+)
           AND AA.ROW_NO = BB.ROW_NO(+) + 1
           AND AA.DIVISION_ID = CC.DIVISION_ID(+)
           AND AA.PROJECT_CODE = CC.PROJECT_CODE(+)
           AND AA.SCM_SITE_ID = CC.SCM_SITE_ID(+)
           AND AA.PLANT_SITE_ID = CC.PLANT_SITE_ID(+)
           AND AA.ITEM_ID = CC.ITEM_ID(+)
           AND AA.CURRENCY = CC.CURRENCY(+)
           AND AA.MEASURE = CC.MEASURE(+)
           AND AA.DOM_EXP = CC.DOM_EXP(+)
           AND AA.FCST_TYPE = CC.FCST_TYPE(+)
           AND AA.INCOTERMS = CC.INCOTERMS(+)
           AND AA.ROW_NO = 1
           AND AA.DIVISION_ID = L.DIVISION_ID
           AND CASE WHEN AA.ROW_NO = '1'  AND (AA.PRICE * L.LIMIT_RATE) < ABS(CC.PRICE - AA.PRICE) THEN 'Y'
                    WHEN AA.ROW_NO <> '1' AND (BB.PRICE * L.LIMIT_RATE) < ABS(BB.PRICE - AA.PRICE) THEN 'Y'
                    ELSE 'N'
               END = 'Y';


        INSERT INTO GT_DMF0020_OVER_RANGE_LIST (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS, COL_LIST)
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS
            ,REPLACE(NVL("1",''),',','') ||NVL("2",'') ||NVL("3",'') ||NVL("4",'')||NVL("5",'')||NVL("6",'')||NVL("7",'')||NVL("8",'')||NVL("9",'')||NVL("10",'')
            ||NVL("11",'')||NVL("12",'')||NVL("13",'')||NVL("14",'')||NVL("15",'')||NVL("16",'')||NVL("17",'')||NVL("18",'')||NVL("19",'')||NVL("20",'')
            ||NVL("21",'')||NVL("22",'')||NVL("23",'')||NVL("24",'')||NVL("25",'')||NVL("26",'')||NVL("27",'')||NVL("28",'')||NVL("29",'')||NVL("30",'')
            ||NVL("31",'')||NVL("32",'')||NVL("33",'')||NVL("34",'')||NVL("35",'')||NVL("36",'')||NVL("37",'')||NVL("38",'')||NVL("39",'')||NVL("40",'')
            ||NVL("41",'')||NVL("42",'')||NVL("43",'')||NVL("44",'')||NVL("45",'')||NVL("46",'')||NVL("47",'')||NVL("48",'')||NVL("49",'')||NVL("50",'')
            ||NVL("51",'')||NVL("52",'') AS COL_LIST
        FROM (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, ',W_' || YYYYMMDD AS YYYYMMDD
                , ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD ) AS ROW_NUM
            FROM GT_DMF0020_OVER_RANGE
            ) A
        PIVOT (
            MAX(YYYYMMDD) FOR ROW_NUM IN ( 1 AS "1",2 AS "2",3 AS "3",4 AS "4",5 AS "5",6 AS "6",7 AS "7",8 AS "8",9 AS "9",10 AS "10"
                                            ,11 AS "11",12 AS "12",13 AS "13",14 AS "14",15 AS "15",16 AS "16",17 AS "17",18 AS "18",19 AS "19",20 AS "20"
                                            ,21 AS "21",22 AS "22",23 AS "23",24 AS "24",25 AS "25",26 AS "26",27 AS "27",28 AS "28",29 AS "29",30 AS "30"
                                            ,31 AS "31",32 AS "32",33 AS "33",34 AS "34",35 AS "35",36 AS "36",37 AS "37",38 AS "38",39 AS "39",40 AS "40"
                                            ,41 AS "41",42 AS "42",43 AS "43",44 AS "44",45 AS "45",46 AS "46",47 AS "47",48 AS "48",49 AS "49",50 AS "50"
                                            ,51 AS "51",52 AS "52" )
            ) UNPVT;




    END IF;


    --[C20200506-000201] 속도개선 임시테이블 #tmpItem, #tmpPlanData 추가

    INSERT INTO GT_DMF0020_ITEM (DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, FORECAST_INFO_BIZ_TYPE, ITEM_TYPE)
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, FORECAST_INFO_BIZ_TYPE, ITEM_TYPE
    FROM DM_MST_ITEM_SINGLE_V
    WHERE DIVISION_ID = p_division_id;

    INSERT INTO GT_DMF0020_PLAN_DATA (DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP)
    SELECT
       A.DIVISION_ID,
       A.SCM_SITE_ID,
       A.PLANT_SITE_ID,
       A.PROJECT_CODE,
       A.ITEM_ID,
       A.INCOTERMS,
       A.CURRENCY,
       A.FCST_TYPE,
       A.DOM_EXP
    FROM SCM_MST_FUTURE_PRICE A
    WHERE   (A.YYYYMMDD >= p_from_yyyymmdd and A.YYYYMMDD <= p_to_yyyymmdd)
            AND CASE WHEN p_division_id = 'ALL' THEN 'ALL'
                     ELSE A.DIVISION_ID
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_division_id, '[^,]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_division_id, '[^,]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.column_value
                       )
            AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
                     ELSE A.SCM_SITE_ID
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.column_value
                       )
            AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL'
                     ELSE A.PLANT_SITE_ID
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_plant_site_id, '[^,]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_plant_site_id, '[^,]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.column_value
                       )
            -- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (START)
            AND EXISTS (  SELECT B.DIVISION_ID
                                FROM SCM_MST_SITE B
                                WHERE A.DIVISION_ID   = B.DIVISION_ID
                                AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                AND B.VALID_YN    = 'Y' )
            AND EXISTS (  SELECT B.DIVISION_ID
                               FROM SCM_MST_SITE_ITEM B
                              WHERE A.DIVISION_ID    = B.DIVISION_ID
                                AND A.PROJECT_CODE  = B.PROJECT_CODE
                                AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                                AND A.ITEM_ID        = B.ITEM_ID
                                AND B.VALID_YN    = 'Y'   )
            -- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (END)
    GROUP BY
       A.DIVISION_ID,
       A.SCM_SITE_ID,
       A.PLANT_SITE_ID,
       A.PROJECT_CODE,
       A.ITEM_ID,
       A.INCOTERMS,
       A.CURRENCY,
       A.FCST_TYPE,
       A.DOM_EXP;



    /* 2026.08.14 AJS PJT 원본을 물리 GTT 에 1회 실현 후 hash join */
    DELETE FROM SCM_MGR.GT_DMF0020_PJT;
    INSERT INTO SCM_MGR.GT_DMF0020_PJT (DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PROJECT_OWNER,
        PROJECT_STATUS, BIZ_TYPE, SCM_SITE_ID, ITEM_ID, DEPT_ID, DEPT_NAME_KO, USER_ID, USER_NAME, USER_NAME_EN)
            SELECT B.DIVISION_ID
                , B.PROJECT_CODE
                , B.PROJECT_NAME
                , B.PROJECT_OWNER
                , B.PROJECT_STATUS
                , B.BIZ_TYPE
                , '' SCM_SITE_ID
                , '' ITEM_ID
                , '' DEPT_ID
                , '' DEPT_NAME_KO
                ,SU.USER_ID
                ,SU.USER_NAME
                ,SU.USER_NAME_EN
            FROM SCM_MST_PROJECT B
                ,SCM_MST_SSO_USER_INFO SU
            WHERE B.DIVISION_ID <> '40'
                AND B.DIVISION_ID = p_division_id /* 2026.08.14 AJS 전 사업부 실현 방지(성능) */
                AND UPPER(TRIM(B.PROJECT_OWNER)) = UPPER(TRIM(SU.USER_ID)) /* 2026.08.14 AJS MSSQL CI collation 대응 */
            UNION
            SELECT SI.DIVISION_ID
                ,SI.PROJECT_CODE PROJECT_CODE
                ,'' PROJECT_NAME
                ,SI.OWNER PROJECT_OWNER
                ,'' PROJECT_STATUS
                ,'' BIZ_TYPE
                ,SI.SCM_SITE_ID
                ,SI.ITEM_ID
                ,SI.DEPT_ID  -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기) (AS-IS: SU.DEPT_ID)
                ,TM.DEPT_NAME_KO
                ,SU.USER_ID
                ,SU.USER_NAME
                ,SU.USER_NAME_EN
        -- 20180810 ------------------------------------------
                FROM SCM_MST_SITE_ITEM SI

                    LEFT JOIN SCM_MST_SSO_USER_INFO SU
                        ON UPPER(TRIM(SU.USER_ID)) = UPPER(TRIM((SELECT token FROM TABLE(FN_String_Split(SI.OWNER, ',')) WHERE ROWNUM = 1))) /* 2026.08.14 AJS 동일 사유 */

                    LEFT JOIN SCM_MST_SSO_DEPT_INFO TM
                        ON SI.DEPT_ID = TM.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: SU.DEPT_ID)

            WHERE SI.DIVISION_ID = '40'
                  AND p_division_id = '40' /* 2026.08.14 AJS 40 전용 분기 - 타 사업부 조회 시 SITE_ITEM 전건 상관서브쿼리 실행 방지 */
            -- 20180810 ------------------------------------------
    ;

    INSERT INTO GT_DMF0020_DATA (DIVISION_ID, DIVISION_NAME, UPPER_DEPT_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, SITE_DESCRIPTION, END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, BIZ_TYPE_NAME, PROJECT_STATUS, PROJECT_OWNER, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP, AUTHORITY_YN, NICK_NAME)
    SELECT
       A.DIVISION_ID,
       B.DIVISION_NAME,
       DEPRTMENT.DEPT_ID AS UPPER_DEPT_ID,
       --TEAM.DEPT_ID,         --20180625
       CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END DEPT_ID,
       --CASE WHEN isnull(TEAM.DEPT_NAME_KO,'') = '' THEN '' ELSE RIGHT(isnull(TEAM.DEPT_NAME_KO,''), CHARINDEX('.',REVERSE(isnull(TEAM.DEPT_NAME_KO,''))) -1) END AS TEAM_INCHARGE,
       A.SCM_SITE_ID,
       A.PLANT_SITE_ID,
       C.SITE_DESCRIPTION,
       NVL(C.END_CUSTOMER,'') AS END_CUSTOMER,
       A.PROJECT_CODE,
       PJT.PROJECT_NAME,
       PJT.BIZ_TYPE as BIZ_TYPE_NAME,
       --PJT.BIZ_TYPE_NAME,
       PJT.PROJECT_STATUS,
       PJT.PROJECT_OWNER,
       A.ITEM_ID,
       ITEM.ITEM_CLASS_NAME,
       NVL(ITEM.ITEM_NAME,'') AS ITEM_NAME,
       A.INCOTERMS,
       --SITE_ITEM.CURRENCY,
       A.CURRENCY,
       A.FCST_TYPE,
       A.DOM_EXP,
       --MEASURE.LOOKUP_CODE AS MEASURE,
       --MEASURE.DISPLAY_SEQ,
       --CASE WHEN (RTRIM(TEAM.DEPT_ID) = RTRIM(@v_dept_id) OR @v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
       CASE WHEN ((FN_GET_DEPT_LIST(p_created_by,
            --TEAM.DEPT_ID
            CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
            ) = 'Y') OR v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
       --,A.YYYYMMDD
       ,ITEM.NICK_NAME --20180711
       --,A.PRICE
    FROM GT_DMF0020_PLAN_DATA A
        INNER JOIN SCM_MST_DIVISION B
            ON A.DIVISION_ID = B.DIVISION_ID
            AND B.VALID_YN = 'Y'

        INNER JOIN SCM_MST_SITE C
            ON  A.DIVISION_ID = C.DIVISION_ID
            AND A.SCM_SITE_ID = C.SCM_SITE_ID
            AND C.SITE_TYPE = 'SALES'
            AND C.VALID_YN = 'Y'

        LEFT JOIN SCM_MST_SITE D
            ON  A.DIVISION_ID = D.DIVISION_ID
            AND A.SCM_SITE_ID = D.SCM_SITE_ID
            AND C.SITE_TYPE = 'PLANT'
            AND D.VALID_YN = 'Y'

        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
            -- [hook#150 2026-09-06 AJS] AS-IS: ON C.DEPT_ID = TEAM.DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: AND TEAM.VALID_YN = 'Y'

        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN SCM_MST_SSO_DEPT_INFO DEPRTMENT
            -- [hook#150 2026-09-06 AJS] AS-IS: ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: AND DEPRTMENT.VALID_YN = 'Y'

        INNER JOIN GT_DMF0020_ITEM ITEM
            ON  A.DIVISION_ID = ITEM.DIVISION_ID
            AND A.ITEM_ID  = ITEM.ITEM_ID
        LEFT JOIN GT_DMF0020_PJT PJT /* 2026.08.14 AJS 물리 GTT 사전 실현 (인라인 서브쿼리를 옵티마이저가 decorrelate -> 카테시안 폭발) */
            ON  A.DIVISION_ID = PJT.DIVISION_ID
            AND A.PROJECT_CODE = PJT.PROJECT_CODE
            AND CASE WHEN p_division_id = '40' THEN PJT.SCM_SITE_ID ELSE A.SCM_SITE_ID END =  A.SCM_SITE_ID    -- modified by ytchoi 180802
            AND CASE WHEN p_division_id = '40' THEN PJT.ITEM_ID ELSE A.ITEM_ID END = A.ITEM_ID

        LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM WHERE VALID_YN = 'Y') SITE_ITEM
            ON SITE_ITEM.DIVISION_ID = A.DIVISION_ID
            AND SITE_ITEM.PROJECT_CODE = A.PROJECT_CODE
            AND SITE_ITEM.SCM_SITE_ID = A.SCM_SITE_ID
            AND SITE_ITEM.ITEM_ID = A.ITEM_ID
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기) / TEAM,DEPRTMENT 조인을 SITE_ITEM 뒤로 이동
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
            ON SITE_ITEM.DEPT_ID = TEAM.DEPT_ID
            AND TEAM.VALID_YN = 'Y'
        LEFT JOIN SCM_MST_SSO_DEPT_INFO DEPRTMENT
            ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
            AND DEPRTMENT.VALID_YN = 'Y'

        LEFT JOIN SCM_MST_SSO_USER_INFO USER_INFO    --20180724
            ON SITE_ITEM.OWNER = USER_INFO.USER_ID
            -------------------------- Project --------------2018/07/30  Son Young Suk---------------------
                INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_project_code, ',')) WHERE p_project_code IS NOT NULL AND p_project_code NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_project_code IS NULL OR p_project_code IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b1
                ON (b1.tst IS NULL OR PJT.PROJECT_CODE like b1.tst OR PJT.PROJECT_NAME like b1.tst)
            -----------------------------------------------------------------------------------------------
        ------------  20180806  -------------------------------------------------------------------
        INNER JOIN (
                        SELECT DISTINCT X.OWNER
                            FROM SCM_MST_SITE_ITEM X
                            LEFT JOIN SCM_MST_SSO_USER_INFO UI
                            ON X.PROJECT_CODE = UI.USER_ID
                            INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_owner, ',')) WHERE p_owner IS NOT NULL AND p_owner NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_owner IS NULL OR p_owner IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) c
                  ON (c.tst IS NULL OR FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') like c.tst
                      OR X.OWNER like c.tst
                      OR FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') like c.tst)
                        where X.DIVISION_ID = p_division_id
                            AND p_owner IS NOT NULL AND p_owner NOT IN ('ALL','-')
                            UNION all
                            select '11' FROM DUAL
                            where p_owner IN ('','ALL','-')
            ) X
        ON  NVL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN (p_owner IS NULL OR p_owner IN ('ALL','-')) THEN  NVL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END
        -----------------------------------------------------------------------------------------------
        /*CROSS JOIN
        (
        SELECT  COLUMN_NAME AS LOOKUP_CODE,
                COLUMN_LABEL_NAME AS "DESCRIPTION",
                SORT_ORDER_NO AS DISPLAY_SEQ
        FROM     SCM_MST_SHEET_MEASURE
            WHERE  (PROGRAM_ID = @p_program_id AND SHEET_NAME = 'Sales Price')
                    AND COLUMN_NAME <> 'LOC'

        UNION

        SELECT  COLUMN_NAME AS LOOKUP_CODE,
                COLUMN_LABEL_NAME AS [DESCRIPTION],
                SORT_ORDER_NO AS DISPLAY_SEQ
        FROM     SCM_MST_SHEET_MEASURE WITH(NOLOCK)
            WHERE  (PROGRAM_ID = @p_program_id AND SHEET_NAME = 'Sales Price')
                    AND COLUMN_NAME = 'LOC'
        ) AS MEASURE*/

    WHERE   1=1
            AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
                     --ELSE TEAM.DEPT_ID
                     ELSE CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_dept_id, '[^,]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_dept_id, '[^,]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
                            --TEAM.DEPT_ID
                            CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
                        END) = P.column_value
                       )
            AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
                     ELSE NVL(
                        CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END
                     ,'')
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_end_customer, '[^,]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_end_customer, '[^,]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
                            CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END
                        ,'') END) = P.column_value
                       )
            AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'  --20180822
                     ELSE --PJT.BIZ_TYPE
                        CASE WHEN p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_biztype, '[^,]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_biztype, '[^,]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_biztype = 'ALL' THEN 'ALL' ELSE
                        --PJT.BIZ_TYPE
                        CASE WHEN p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
                        END) = P.column_value
                       )
    GROUP BY
            A.DIVISION_ID,
            B.DIVISION_NAME,
            DEPRTMENT.DEPT_ID,
            TEAM.DEPT_ID,
            PJT.DEPT_ID,
            A.SCM_SITE_ID,
            A.PLANT_SITE_ID,
            C.SITE_DESCRIPTION,
            NVL(C.END_CUSTOMER,''),
            A.PROJECT_CODE,
            PJT.PROJECT_NAME,
            PJT.BIZ_TYPE,
            PJT.PROJECT_STATUS,
            PJT.PROJECT_OWNER,
            A.ITEM_ID,
            ITEM.ITEM_CLASS_NAME,
            NVL(ITEM.ITEM_NAME,''),
            A.INCOTERMS,
            A.FCST_TYPE,
            A.DOM_EXP,
            A.CURRENCY,
            --MEASURE.LOOKUP_CODE,
            --MEASURE.DISPLAY_SEQ,
            --CASE WHEN RTRIM(TEAM.DEPT_ID) = RTRIM(@v_dept_id) THEN 'Y' ELSE 'N' END  --20200312 KHSONG @v_dept_id 값이 셋팅되는 곳이 없어서 필요없는 조건으로 주석처리
            --A.YYYYMMDD,
            ITEM.NICK_NAME;


    -- CREATE INDEX IDX_PRICE_KEYS ON #tmpData(DIVISION_ID ASC, PROJECT_CODE ASC, SCM_SITE_ID ASC, PLANT_SITE_ID ASC, ITEM_ID ASC, CURRENCY ASC, DOM_EXP ASC, FCST_TYPE ASC, INCOTERMS ASC );
    -- Oracle GTT 인덱스는 GTT DDL 파일에 사전 정의


    -- CREATE TABLE #tmpOutput (DIVISION_ID NVARCHAR(30) ... );
    -- Oracle GTT 사전 정의

    -- 1. 실데이타와 조인

    -- [PJ20200138] 범위 초과 대상
    IF (p_over_range = 'Y') THEN
        INSERT INTO GT_DMF0020_OUTPUT (DIVISION_ID, DIVISION_NAME, UPPER_DEPT_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, SITE_DESCRIPTION, END_CUSTOMER, END_CUSTOMER40, PROJECT_CODE, PROJECT_NAME, BIZ_TYPE_NAME, PROJECT_STATUS, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP, MEASURE, DISPLAY_SEQ, AUTHORITY_YN, YYYYMMDD, PRICE, NICK_NAME, COL_LIST)
        SELECT
                A.DIVISION_ID,
                A.DIVISION_NAME,
                A.UPPER_DEPT_ID,
                A.DEPT_ID    ,
                A.SCM_SITE_ID,
                A.PLANT_SITE_ID,
                A.SITE_DESCRIPTION,
                A.END_CUSTOMER,
                A.PROJECT_CODE AS END_CUSTOMER40,
                A.PROJECT_CODE,
                A.PROJECT_NAME,
                A.BIZ_TYPE_NAME,
                A.PROJECT_STATUS,
                A.ITEM_ID,
                A.ITEM_CLASS_NAME,
                A.ITEM_NAME,
                A.INCOTERMS,
                A.CURRENCY,
                A.FCST_TYPE,
                A.DOM_EXP,
                B.MEASURE,
                MEASURE.DISPLAY_SEQ,
                A.AUTHORITY_YN,
                'W_' || B.YYYYMMDD AS YYYYMMDD,
                NVL(B.PRICE,0) AS PRICE
                , A.NICK_NAME
                , C.COL_LIST
        FROM GT_DMF0020_DATA A
            JOIN SCM_MST_FUTURE_PRICE B
                ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.CURRENCY = B.CURRENCY
                   --AND A.MEASURE = B.MEASURE
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   --AND A.YYYYMMDD = B.YYYYMMDD
            JOIN   GT_DMF0020_OVER_RANGE_LIST C
                ON A.DIVISION_ID = C.DIVISION_ID
                   AND A.PROJECT_CODE = C.PROJECT_CODE
                   AND A.SCM_SITE_ID = C.SCM_SITE_ID
                   AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
                   AND A.ITEM_ID = C.ITEM_ID
                   AND A.CURRENCY = C.CURRENCY
                   --AND A.MEASURE = C.MEASURE
                   AND A.DOM_EXP = C.DOM_EXP
                   AND A.FCST_TYPE = C.FCST_TYPE
                   AND A.INCOTERMS = C.INCOTERMS
                   --AND A.YYYYMMDD = C.YYYYMMDD
            -------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
            INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_item_id, ',')) WHERE p_item_id IS NOT NULL AND p_item_id NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_item_id IS NULL OR p_item_id IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b2
                ON (b2.tst IS NULL OR A.ITEM_ID like b2.tst OR A.NICK_NAME like b2.tst)
            -----------------------------------------------------------------------------------------------
            JOIN (  SELECT  COLUMN_NAME AS LOOKUP_CODE,
                            COLUMN_LABEL_NAME AS "DESCRIPTION",
                            SORT_ORDER_NO AS DISPLAY_SEQ
                    FROM    SCM_MST_SHEET_MEASURE
                    WHERE  (PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price') ) MEASURE
                ON B.MEASURE = MEASURE.LOOKUP_CODE
        WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd; --[PJ20200138] 속도개선
    ELSE
        INSERT INTO GT_DMF0020_OUTPUT (DIVISION_ID, DIVISION_NAME, UPPER_DEPT_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, SITE_DESCRIPTION, END_CUSTOMER, END_CUSTOMER40, PROJECT_CODE, PROJECT_NAME, BIZ_TYPE_NAME, PROJECT_STATUS, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP, MEASURE, DISPLAY_SEQ, AUTHORITY_YN, YYYYMMDD, PRICE, NICK_NAME, COL_LIST)
        SELECT
                A.DIVISION_ID,
                A.DIVISION_NAME,
                A.UPPER_DEPT_ID,
                A.DEPT_ID    ,
                A.SCM_SITE_ID,
                A.PLANT_SITE_ID,
                A.SITE_DESCRIPTION,
                A.END_CUSTOMER,
                A.PROJECT_CODE AS END_CUSTOMER40,
                A.PROJECT_CODE,
                A.PROJECT_NAME,
                A.BIZ_TYPE_NAME,
                A.PROJECT_STATUS,
                A.ITEM_ID,
                A.ITEM_CLASS_NAME,
                A.ITEM_NAME,
                A.INCOTERMS,
                A.CURRENCY,
                A.FCST_TYPE,
                A.DOM_EXP,
                B.MEASURE,
                MEASURE.DISPLAY_SEQ,
                A.AUTHORITY_YN,
                'W_' || B.YYYYMMDD AS YYYYMMDD,
                NVL(B.PRICE,0) AS PRICE
                , A.NICK_NAME
                , '' AS COL_LIST
        FROM GT_DMF0020_DATA A
            JOIN SCM_MST_FUTURE_PRICE B
                ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.CURRENCY = B.CURRENCY
                   --AND A.MEASURE = B.MEASURE
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   --AND A.YYYYMMDD = B.YYYYMMDD
            -------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
            INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_item_id, ',')) WHERE p_item_id IS NOT NULL AND p_item_id NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_item_id IS NULL OR p_item_id IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b2
                ON (b2.tst IS NULL OR A.ITEM_ID like b2.tst OR A.NICK_NAME like b2.tst)
            -----------------------------------------------------------------------------------------------
            JOIN (  SELECT  COLUMN_NAME AS LOOKUP_CODE,
                            COLUMN_LABEL_NAME AS "DESCRIPTION",
                            SORT_ORDER_NO AS DISPLAY_SEQ
                    FROM    SCM_MST_SHEET_MEASURE
                    WHERE  (PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price') ) MEASURE
                ON B.MEASURE = MEASURE.LOOKUP_CODE
        WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd; --[PJ20200138] 속도개선
    END IF;

    -----------------------------------------------------------------------------------------------

    ------ 월 데이터 평균 값 산정
    ----INSERT #tmpOutput
    ----SELECT
    ----        A.DIVISION_ID,
    ----        A.DIVISION_NAME,
    ----        A.UPPER_DEPT_ID,
    ----        A.DEPT_ID    ,
    ----        A.SCM_SITE_ID,
    ----        A.PLANT_SITE_ID,
    ----        A.SITE_DESCRIPTION,
    ----        A.END_CUSTOMER,
    ----        A.PROJECT_CODE AS END_CUSTOMER40,
    ----        A.PROJECT_CODE,
    ----        A.PROJECT_NAME,
    ----        A.BIZ_TYPE_NAME,
    ----        A.PROJECT_STATUS,
    ----        A.ITEM_ID,
    ----        A.ITEM_CLASS_NAME,
    ----        A.ITEM_NAME,
    ----        A.INCOTERMS,
    ----        A.CURRENCY,
    ----        A.FCST_TYPE,
    ----        A.DOM_EXP,
    ----        A.MEASURE,
    ----        A.DISPLAY_SEQ,
    ----        A.AUTHORITY_YN,
    ----        'M_' + SUBSTRING(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6) + '01' AS YYYYMMDD,
    ----        --MIN(ISNULL(PRICE, 0)) AS PRICE
    ----        SUM(ISNULL(PRICE, 0)) / COUNT(YYYYMMDD) AS PRICE
    ----        , A.NICK_NAME
    ----        , A.COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
    ----FROM #tmpOutput  AS A
    ----group by A.DIVISION_ID,
    ----        A.DIVISION_ID,
    ----        A.DIVISION_NAME,
    ----        A.UPPER_DEPT_ID,
    ----        A.DEPT_ID    ,
    ----        A.SCM_SITE_ID,
    ----        A.PLANT_SITE_ID,
    ----        A.SITE_DESCRIPTION,
    ----        A.END_CUSTOMER,
    ----        A.END_CUSTOMER40,
    ----        A.PROJECT_CODE,
    ----        A.PROJECT_NAME,
    ----        A.BIZ_TYPE_NAME,
    ----        A.PROJECT_STATUS,
    ----        A.ITEM_ID,
    ----        A.ITEM_CLASS_NAME,
    ----        A.ITEM_NAME,
    ----        A.INCOTERMS,
    ----        A.CURRENCY,
    ----        A.FCST_TYPE,
    ----        A.DOM_EXP,
    ----        A.MEASURE,
    ----        A.DISPLAY_SEQ,
    ----        A.AUTHORITY_YN,
    ----        A.NICK_NAME,
    ----        A.COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
    ----        SUBSTRING(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6)

    /* tmpPlanData 에 대한 처리들  */
    FOR rec IN (SELECT DISTINCT YYYYMMDD FROM GT_DMF0020_OUTPUT) LOOP
        v_prod       := v_prod       || '"' || rec.YYYYMMDD || '",';
        v_prod_pivot := v_prod_pivot || '''' || rec.YYYYMMDD || ''' AS "' || rec.YYYYMMDD || '",';  /* 2026.08.14 AJS PIVOT IN 절은 상수값 필요(식별자만 넣으면 ORA-56901) */
    END LOOP;

    IF v_prod IS NULL OR v_prod = '' THEN
        v_prod := '"D_99999999"'; v_prod_pivot := '''D_99999999'' AS "D_99999999"';
    ELSE
        v_prod := SUBSTR(v_prod, 1, LENGTH(v_prod) - 1);
        v_prod_pivot := SUBSTR(v_prod_pivot, 1, LENGTH(v_prod_pivot) - 1);
    END IF;


    --Start [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
    IF p_division_id = '82' and p_invalid_exec = 'N' THEN

            INSERT INTO GT_DMF0020_SALES_SITE_MODEL_ALL (DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40, PROJECT_CODE, PROJECT_NAME, PROJECT_STATUS, SALES_PLAN_ADJUST_YN, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY)
            SELECT   SITE_PROJECT.DIVISION_ID,
                            TEAM.DEPT_ID,
                            SITE.END_CUSTOMER,
                            SITE.END_CUSTOMER AS END_CUSTOMER40,
                            SITE_PROJECT.SCM_SITE_ID,
                            SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40,
                            SITE_PROJECT.PROJECT_CODE,
                            PJT.PROJECT_NAME,
                            PJT.PROJECT_STATUS,
                            SITE_ITEM.SALES_PLAN_ADJUST_YN,
                            SITE_ITEM.ITEM_CLASS_NAME,
                            SITE_ITEM.ITEM_ID,
                            SITE_ITEM.ITEM_NAME,
                            SITE_ITEM.NICK_NAME,
                            SITE_ITEM.CURRENCY

            FROM           (SELECT  DISTINCT
                                    A.DIVISION_ID,
                                    SCM_SITE_ID,
                                    PROJECT_CODE,
                                    NVL(MAX(VALID_YN),'Y') AS VALID_YN
                            FROM    SCM_MST_SITE_ITEM A
                                    ,SCM_MST_ITEM_SN B
                            WHERE   A.ITEM_ID = B.ITEM_ID
                            GROUP BY A.DIVISION_ID,
                                        SCM_SITE_ID,
                                        PROJECT_CODE
                                                            )                   SITE_PROJECT
            LEFT JOIN       SCM_MST_PROJECT                                  PJT
            ON              SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
            AND             SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID
            LEFT JOIN       SCM_MST_SITE                                     SITE
            ON              SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID
            AND             SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN       SCM_MST_SSO_DEPT_INFO                            TEAM
            -- [hook#150 2026-09-06 AJS] AS-IS: ON              SITE.DEPT_ID = TEAM.DEPT_ID

            LEFT JOIN       (SELECT T1.DIVISION_ID,
                                    T1.SCM_SITE_ID,
                                    T1.PROJECT_CODE,
                                    T1.ITEM_ID,
                                    T2.ITEM_NAME,
                                    T2.ITEM_TYPE,
                                    T2.ITEM_CLASS_NAME,
                                    T1.SALES_PLAN_ADJUST_YN,
                                    T2.NICK_NAME,
                                    T1.CURRENCY,
                                    T1.VALID_YN,
                                    T1.OWNER,
                                    T1.PARTIAL_PLAN_YN, T1.DEPT_ID /* 2026-09-06 hook#150 AJS */ --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
                                    -----------------------
                                FROM    SCM_MST_SITE_ITEM       T1
                                JOIN    DM_MST_ITEM_SINGLE_V    T2
                                ON  T1.DIVISION_ID = T2.DIVISION_ID
                                AND T1.ITEM_ID   = T2.ITEM_ID

                                WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'H' END
                                OR   T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'P' END)
                                                            )                   SITE_ITEM

            ON              SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
            AND             SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
            AND             SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
            -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
            LEFT JOIN       SCM_MST_SSO_DEPT_INFO                            TEAM
            ON              SITE_ITEM.DEPT_ID = TEAM.DEPT_ID

            LEFT JOIN       SCM_MST_SITE_CUSTOMER                            SITE_CUST
            ON              SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
            AND             SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
            AND             SITE_CUST.REP_YN      = 'Y'

            LEFT JOIN       SCM_MST_CUSTOMER                                 CUST
            ON              SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
            AND             SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
            AND             SITE_CUST.DIVISION_ID = CUST.DIVISION_ID

            LEFT JOIN       (SELECT DIVISION_ID,
                                        MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL,
                                        SCM_SITE_ID,
                                        PROJECT_CODE,
                                        ITEM_ID
                                FROM   DM_MST_CUSTOMER_MODEL
                                WHERE  VALID_YN = 'Y'
                                GROUP BY DIVISION_ID,
                                        SCM_SITE_ID,
                                        PROJECT_CODE,
                                        ITEM_ID         )                   CUST_ITEM
            ON              SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
            AND             SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
            AND             SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
            AND             SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID

            LEFT JOIN SCM_MST_SSO_USER_INFO SU
            ON SITE_ITEM.owner = SU.USER_ID

                INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_item_id, ',')) WHERE p_item_id IS NOT NULL AND p_item_id NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_item_id IS NULL OR p_item_id IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b
                ON (b.tst IS NULL OR SITE_ITEM.ITEM_ID like b.tst OR SITE_ITEM.NICK_NAME like b.tst)
                INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_project_code, ',')) WHERE p_project_code IS NOT NULL AND p_project_code NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_project_code IS NULL OR p_project_code IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b1
                ON (b1.tst IS NULL OR PJT.PROJECT_CODE like b1.tst OR PJT.PROJECT_NAME like b1.tst)
            INNER JOIN (
                            SELECT DISTINCT X.OWNER
                                FROM SCM_MST_SITE_ITEM X
                                LEFT JOIN SCM_MST_SSO_USER_INFO UI
                                ON X.PROJECT_CODE = UI.USER_ID
                                INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_owner, ',')) WHERE p_owner IS NOT NULL AND p_owner NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_owner IS NULL OR p_owner IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) c
                  ON (c.tst IS NULL OR FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') like c.tst
                      OR X.OWNER like c.tst
                      OR FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') like c.tst)
                                where X.DIVISION_ID = p_division_id
                                    AND p_owner IS NOT NULL AND p_owner NOT IN ('ALL','-')
                                    UNION all
                                    select '11' FROM DUAL
                                    where p_owner IN ('','ALL','-')
                    ) X
            ON  NVL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN (p_owner IS NULL OR p_owner IN ('ALL','-')) THEN  NVL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END
            WHERE  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
            AND    CASE WHEN p_division_id = 'ALL' THEN p_division_id
                        ELSE SITE_PROJECT.DIVISION_ID
                    END  IN ( SELECT token FROM TABLE(FN_String_Split(p_division_id,',')) )
            AND    CASE WHEN p_dept_id = 'ALL' THEN p_dept_id
                        ELSE TEAM.DEPT_ID
                    END  IN ( SELECT token FROM TABLE(FN_String_Split(p_dept_id,',')) )
            AND    CASE WHEN p_end_customer = 'ALL' THEN p_end_customer
                        ELSE SITE.END_CUSTOMER
                    END  IN ( SELECT token FROM TABLE(FN_String_Split(p_end_customer,',')) )
            AND    CASE WHEN p_scm_site_id = 'ALL' THEN p_scm_site_id
                        ELSE SITE_PROJECT.SCM_SITE_ID  -- 20181220 KHSONG modify SITE_ITEM.SCM_SITE_ID -> SITE_PROJECT.SCM_SITE_ID
                    END  IN ( SELECT token FROM TABLE(FN_String_Split(p_scm_site_id,',')) )
            AND   SITE.SITE_TYPE <> 'PLANT';


            INSERT INTO GT_DMF0020_SALES_SITE_MODEL (DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40, PROJECT_CODE, PROJECT_NAME, PROJECT_STATUS, SALES_PLAN_ADJUST_YN, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY, MEASURE, DISPLAY_SEQ)
            select DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40, PROJECT_CODE, PROJECT_NAME
            , PROJECT_STATUS,SALES_PLAN_ADJUST_YN, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY, B.MEASURE, B.DISPLAY_SEQ
            from   GT_DMF0020_SALES_SITE_MODEL_ALL a
            cross join (SELECT  COLUMN_NAME AS MEASURE,
                                COLUMN_LABEL_NAME AS DESCRIPTION,
                                SORT_ORDER_NO AS DISPLAY_SEQ
                        FROM    SCM_MST_SHEET_MEASURE
                        WHERE   PROGRAM_ID = 'DMF0020'
                        AND     SHEET_NAME = 'Sales Price' )  b;



        v_nsql := '
            SELECT
                    DIVISION_ID,
                    DIVISION_NAME,
                    UPPER_DEPT_ID,
                    DEPT_ID    ,
                    SCM_SITE_ID,
                    PLANT_SITE_ID,
                    SITE_DESCRIPTION,
                    END_CUSTOMER,
                    END_CUSTOMER40,
                    PROJECT_CODE,
                    PROJECT_NAME,
                    BIZ_TYPE_NAME,
                    PROJECT_STATUS,
                    ITEM_ID,
                    ITEM_CLASS_NAME,
                    ITEM_NAME,
                    INCOTERMS,
                    CURRENCY,
                    FCST_TYPE,
                    DOM_EXP,
                    AUTHORITY_YN,
                    DISPLAY_SEQ,
                    NICK_NAME,
                    COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
                    NEW_FLAG,
                    MEASURE,
                    ' || v_prod || '
            From(
                SELECT a.DIVISION_ID,
                    b.DIVISION_NAME,
                    b.UPPER_DEPT_ID,
                    a.DEPT_ID    ,
                    a.SCM_SITE_ID,
                    b.PLANT_SITE_ID,
                    b.SITE_DESCRIPTION,
                    a.END_CUSTOMER,
                    b.END_CUSTOMER40,
                    a.PROJECT_CODE,
                    a.PROJECT_NAME,
                    b.BIZ_TYPE_NAME,
                    a.PROJECT_STATUS,
                    a.ITEM_ID,
                    a.ITEM_CLASS_NAME,
                    a.ITEM_NAME,
                    b.INCOTERMS,
                    (CASE WHEN division_name is null THEN a.CURRENCY
                          ELSE b.CURRENCY
                     END) AS CURRENCY, --[C20200702-000136] ESS사업부 조회 구간 Currency 변경
                    b.FCST_TYPE,
                    b.DOM_EXP,
                    (CASE WHEN division_name is null
                               THEN (CASE WHEN ((FN_GET_DEPT_LIST( ''' || p_created_by || ''', a.DEPT_ID ) = ''Y'')  OR ''' || v_group_id || ''' =''ADMIN'') THEN ''Y''
                                          ELSE ''N''
                                     END )
                          ELSE b.AUTHORITY_YN
                     END) AS AUTHORITY_YN,
                    a.DISPLAY_SEQ,
                    a.NICK_NAME,
                    b.COL_LIST,
                    (CASE WHEN division_name is null THEN ''Y'' ELSE ''N'' END) AS NEW_FLAG,
                    a.MEASURE,
                    b.PRICE,
                    b.YYYYMMDD
                FROM GT_DMF0020_SALES_SITE_MODEL A
                    LEFT JOIN GT_DMF0020_OUTPUT B ON(   a.division_id =  b.division_id
                                                and a.dept_id = b.dept_id
                                                and a.scm_site_id = b.scm_site_id
                                                and a.item_id = b.item_id
                                                and a.project_code = b.project_code
                                                and a.measure = b.measure
                                            )
                WHERE A.MEASURE = ''LOC''
                ) T
            PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || v_prod_pivot || ')
            ) PVT
            ORDER BY

                    DIVISION_ID,
                    division_name,
                    DEPT_ID,
                    END_CUSTOMER,
                    SCM_SITE_ID,
                    PROJECT_CODE,
                    PROJECT_STATUS,
                    BIZ_TYPE_NAME,
                    ITEM_ID,
                    ITEM_CLASS_NAME,
                    ITEM_NAME,
                    INCOTERMS,
                    FCST_TYPE,
                    DOM_EXP,
                    CURRENCY,
                    PLANT_SITE_ID,
                    DISPLAY_SEQ,
                    MEASURE,
                    COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
            ';
        --End [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
    ELSE

        v_nsql := '
            SELECT
                    DIVISION_ID,
                    DIVISION_NAME,
                    UPPER_DEPT_ID,
                    DEPT_ID    ,
                    SCM_SITE_ID,
                    PLANT_SITE_ID,
                    SITE_DESCRIPTION,
                    END_CUSTOMER,
                    END_CUSTOMER40,
                    PROJECT_CODE,
                    PROJECT_NAME,
                    BIZ_TYPE_NAME,
                    PROJECT_STATUS,
                    ITEM_ID,
                    ITEM_CLASS_NAME,
                    ITEM_NAME,
                    INCOTERMS,
                    CURRENCY,
                    FCST_TYPE,
                    DOM_EXP,
                    AUTHORITY_YN,
                    DISPLAY_SEQ,
                    NICK_NAME,
                    COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
                    ''N'' AS NEW_FLAG,
                    MEASURE,
                    ' || v_prod || '
            From(
                SELECT
                    *
                FROM GT_DMF0020_OUTPUT
                WHERE MEASURE = ''LOC''
                ) T
            PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || v_prod_pivot || ')
            ) PVT
            ORDER BY

                    DIVISION_ID,
                    DEPT_ID,
                    END_CUSTOMER,
                    SCM_SITE_ID,
                    PROJECT_CODE,
                    PROJECT_STATUS,
                    BIZ_TYPE_NAME,
                    ITEM_ID,
                    ITEM_CLASS_NAME,
                    ITEM_NAME,
                    INCOTERMS,
                    FCST_TYPE,
                    DOM_EXP,
                    CURRENCY,
                    PLANT_SITE_ID,
                    DISPLAY_SEQ,
                    MEASURE,
                    COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
            ';

    END IF;

    --PRINT @NSQL
    OPEN p_cur FOR v_nsql;


    --SELECT CONVERT(TEXT, @NSQL)
    --FOR XML PATH('')--,ROOT('x')


EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP ERROR: ' || SQLERRM);
END;
/
