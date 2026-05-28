/*=============================================================================================
 * File         : 04_Package_PKG_DMF0048.sql
 * Description  : Package — PKG_DMF0048
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0048 IS
    /*
    * Program ID   : PKG_DMF0048
    * Description  : PKG_DMF0048
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.04.07   김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0048_GET_DM_PLN_SALES_MONITORING
    (
        P_DIVISION_ID   VARCHAR2
       ,P_DEPT_ID       VARCHAR2
       ,P_END_CUSTOMER  VARCHAR2
       ,P_SCM_SITE_ID   VARCHAR2
       ,P_PROJECT_CODE  VARCHAR2
       ,P_ITEM_ID       VARCHAR2
       ,P_ITEM_TYPE     VARCHAR2
       ,P_FROM_YYYYMMDD VARCHAR2
       ,P_NOW_YYYYMMDD  VARCHAR2
       ,P_TO_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_PLANT_SITE_ID VARCHAR2
       ,P_BIZTYPE       VARCHAR2
       ,P_OWNER         VARCHAR2
       ,P_INTERNAL_YN   VARCHAR2
       ,P_USERINFO      VARCHAR2
       ,P_BUCKET        VARCHAR2 -- 20211026 SALES PLAN 속도 개선
       ,P_USER_DEPT_ID  VARCHAR2 -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

END PKG_DMF0048;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0048 IS

    PROCEDURE P_DMF0048_GET_DM_PLN_SALES_MONITORING
    (
        P_DIVISION_ID   VARCHAR2
       ,P_DEPT_ID       VARCHAR2
       ,P_END_CUSTOMER  VARCHAR2
       ,P_SCM_SITE_ID   VARCHAR2
       ,P_PROJECT_CODE  VARCHAR2
       ,P_ITEM_ID       VARCHAR2
       ,P_ITEM_TYPE     VARCHAR2
       ,P_FROM_YYYYMMDD VARCHAR2
       ,P_NOW_YYYYMMDD  VARCHAR2
       ,P_TO_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_PLANT_SITE_ID VARCHAR2
       ,P_BIZTYPE       VARCHAR2
       ,P_OWNER         VARCHAR2
       ,P_INTERNAL_YN   VARCHAR2
       ,P_USERINFO      VARCHAR2
       ,P_BUCKET        VARCHAR2 -- 20211026 SALES PLAN 속도 개선
       ,P_USER_DEPT_ID  VARCHAR2 -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*=====================================================================================================================================================
         * Program ID  : P_DMF0048_GET_DM_PLN_SALES_MONITORING
         * Description : Procedure 작성 가이드
         * Usage       : Procedure 작성 시 참조하세요!
         * Parameter   :
         *=====================================================================================================================================================
         * Date        In Charge    Description
         *=====================================================================================================================================================
         * 2019/12/18   hwi1993     신규작성 요청제목 : GSCM Sales Report 버전 관리 화면 통합 및 실적 모니터링 화면 개발 요청의 건 요청번호 : C20191108-000042
         * 2019/12/18   hwi1993     COMPANY_ID 제거
         * 2020/02/03   hwi1993     COMPANY_ID 추가
         * 2020/02/19   hwi1993     now_yyyymmdd > to_yyyymmdd 일 경우 처리 추가
         * 2020/03/10   hwi1993     now_yyyymmdd = to_yyyymmdd 일 경우 처리 추가
         * 2020/03/13   KHSONG      C20200103-000586 권한그룹을 LOOKUP관리
         * 2020/04/27   KHSONG      C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
         * 2020/08/10   P.C.I       [C20200608-000117] 실적구간 Unit Price Measure는 QTY/Sales Amt로 계산
         * 2020/07/31   HWI1993     과제 - ESS 내부거래등 제거로직 수정 ( attribute2 컬럼 사용 )
         * 2020/09/04   hwi1993     [C20200812-000104] ACTIVE N 처리
         * 2020/09/08   hwi1993     [C20200812-000104] ACTIVE N 처리 운영데이터 검증중 추가 수정 [C20200812-000104_2]
         * 2020/08/12   hwi1993     C20200812-000104 [시스템 변경요청]  Active = ‘N’ 인 Model 도 조회되도록 변경( 미래구간 에만 적용 )
         * 2020/09/28   hwi1993     [C20200928-000147][SCM PI팀] ESS 사내거래 – Sales Plan Waterfall 수정 및 사내거래 포함시 실적구간 PRICE 로직 수정 ( INTERNAL QTY 포함하도록 )
         * 2020/11/25   P.C.I       [C20201125-000012] COMPANY_ID 변경(Site -> Sales Site Project Model)
         * 2021/03/15   P.C.I       [C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)
         * 2021/06/03   SJHAN       [C20210525-000374] 셀 용량 및 팩 당 용량 추가
         * 2021/11/11   rosia27     PJ20209643 SALES MONITORING 속도개선
         * 2021/11/17   rosia27     [C20211103-000146] ESS영업관리팀 GSCM 용량 Measure 값 생성 요청의 건
         * 2021/11/19   kdw2819     과제  자동차 사업부 JV Planner 의 조회 권한 추가
         * 2021/12/03   HWI1993     NOW 가 TO 보다 큰 경우 예외처리
         * 2021/12/07   rosia27     [C20211130-000420]ESS영업관리팀 RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
         * 2021/12/09   HWI1993     실적/계획구간 분할 오류 수정 ( NOW_YYYYMMDD 사용 방법 변경 )
         * 2022/03/03   HWI1993     [C20220303-000249] GSCM Sales monitoring 로직 수정 요청의 건 ( NOW_YYYYMMDD 수정 )
         * 2022/03/22   kdw2819     [C20220318-000248] GSCM Sales Plan 및 Sales Monitoring의 Unit Price 컬럼값 표기 오류 수정 요청의 건
         * 2022/03/25   hwi1993     [GM-JV] division_id 수정
         * 2022/04/11   rosia27     과제PJ20216891RGM_JV
         * 2022/12/14   rosia27     [C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
         * 2023/07/11   HMIN        [E20230630-001379] 사업부(40) 계획구간은 SSPM.ROUTE , 실적구간은 ERP.ROUTE(LGS_ROUTE_NAME) 표출
         * 2024/03/13   kcw3408     DM 프로시저 속도개선(김춘동 책임)
         * 2024/04/17   KCW3408     이동계획 기타매출 추가 요건(TEXT추가)
         * 2024/05/17   kcw3408     이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
         * 2024/08/02   JSSBAE      [E20240731-000856]_[공급 SCM PI팀] Wh --> KWh 환산 로직개선
         * 2024/08/27   KJJ         [PJ2024-50461] Team Mapping
         * 2024/09/12   JSSBAE      [E20240920-000300]_SCM.DM 화면 조회 속도 개선
         * 2024.11.04   KJJ         [PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
         * 2024.12.19   KJJ         [PJ2024-50611] 기타매출, Catch Up 테이블 분리 - 작업중
         * 2025.04.03   dsiol       [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
         * 2025.07.07   KANG.H.J    [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
         *===================================================================================================================================================
         P_DMF0048_GET_DM_PLN_SALES_MONITORING(p_division_id='40');
        ,p_dept_id='ALL'
        ,p_end_customer='ALL'
        ,p_scm_site_id='ALL'
        ,p_project_code=NULL
        ,p_item_id=NULL
        ,p_item_type='ALL'
        ,p_from_yyyymmdd='20241101'
        ,p_now_yyyymmdd='20241120'
        ,p_to_yyyymmdd='20250430'
        ,p_created_by='kjj0070'
        ,p_plant_site_id='ALL'
        ,p_biztype='ALL'
        ,p_owner=NULL
        ,p_internal_yn=''
        ,p_userinfo='ADMIN'
        ,p_bucket='MONTHLY'
        ,p_user_dept_id='ICT'
         */
     AS
        V_PROGRAM_NAME             VARCHAR2(200) := $$PLSQL_UNIT;
        V_PROD                     VARCHAR2(4000 CHAR);
        V_COLLIST                  CLOB;
        V_ORDERLIST                CLOB;
        V_NSQL                     VARCHAR2(4000 CHAR);
        V_NSQL2                    VARCHAR2(4000 CHAR);
        P_PROGRAM_ID               VARCHAR2(50) := 'DMF0048';
        P_SHEET_NAME               VARCHAR2(50) := 'Sales Monitoring';--'salesMonitoring'; --'Sales Monitoring'; 값 변경됨
        V_DEPT_LIST                VARCHAR2(4000) := NULL;
        V_GROUP_ID                 VARCHAR2(50) := NULL;
        V_MEASURE                  INTEGER := 0;
        I_COUNT                    INTEGER := 0;
        V_USER_MEA_CNT             INTEGER := 0;
        V_START_YYYYMMDD           VARCHAR2(8 CHAR);
        V_SQL_TEXT                 CLOB;
        V_PV_LIST                  CLOB;
        V_PV_COL_LIST              CLOB;
        V_PIVOT_IN                 CLOB;
        V_COL_PIVOT                CLOB;
        V_PTT_SQL                  CLOB;
        V_MEASURE_COL              VARCHAR2(100);
        V_COLUMN_NAME              VARCHAR2(100 CHAR);
        V_COLUMN                   VARCHAR2(1000 CHAR);
        V_ORDERBY                  VARCHAR2(1000 CHAR);
        V_COLUMN_TEXT              VARCHAR2(1000 CHAR);
        V_PV_COLUMN_NAME           VARCHAR2(100 CHAR);
        V_PV_NAME                  VARCHAR2(50 CHAR);
        V_COLUMN_TYPE              VARCHAR2(50 CHAR);
        V_COLUMN_VALUE             VARCHAR2(50 CHAR);
        V_SORT_ORDER_NO            VARCHAR2(50 CHAR);
        V_SHIP_DIVISION_ID         VARCHAR2(30 CHAR);
        V_SHIP_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
        V_SHIP_PLAN_TYPE           VARCHAR2(50 CHAR);
        V_SHIP_PPLAN_SEQ           INTEGER;
        V_SHIP_PPLAN_ID            VARCHAR2(30 CHAR);
        V_SHIP_PMODELING_ID        VARCHAR2(30 CHAR);
        V_SQL_SELECT               VARCHAR2(4000 CHAR);
        V_SQL_GROUPBY              VARCHAR2(4000 CHAR);
        V_I                        INTEGER;
        V_CNT                      INTEGER;
        V_CNT_1                    INTEGER := 0;
        V_CNT_2                    INTEGER := 0;
        V_CNT_3                    INTEGER := 0;
        V_CNT_4                    INTEGER := 0;
        V_CNT_5                    INTEGER := 0;
        V_CNT_6                    INTEGER := 0;
        V_CNT_7                    INTEGER := 0;
        V_CNT_8                    INTEGER := 0;
        V_CNT_9                    INTEGER := 0;
        V_CNT_10                   INTEGER := 0;
        V_STEP                     VARCHAR2(4000 CHAR) := NULL;
        V_IN_PARA_DATA             VARCHAR2(4000);
        V_LOG_TYPE                 VARCHAR2(20) := NULL;
        N_LOG_COUNT                NUMBER := 0;
        V_LOG_MESSAGE              VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION              VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE               DATE := SYSDATE;
        V_PROC_INPUT               CLOB := NULL;
        V_SQL_CODE                 VARCHAR2(100) := NULL;
        V_SQL_ERRMSG               VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE                VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                     ,'p_dept_id' VALUE P_DEPT_ID
                                     ,'p_end_customer' VALUE P_END_CUSTOMER
                                     ,'p_scm_site_id' VALUE P_SCM_SITE_ID
                                     ,'p_project_code' VALUE P_PROJECT_CODE
                                     ,'p_item_id' VALUE P_ITEM_ID
                                     ,'p_item_type' VALUE P_ITEM_TYPE
                                     ,'p_from_yyyymmdd' VALUE P_FROM_YYYYMMDD
                                     ,'p_now_yyyymmdd' VALUE P_NOW_YYYYMMDD
                                     ,'p_to_yyyymmdd' VALUE P_TO_YYYYMMDD
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_plant_site_id' VALUE P_PLANT_SITE_ID
                                     ,'p_biztype' VALUE P_BIZTYPE
                                     ,'p_owner' VALUE P_OWNER
                                     ,'p_internal_yn' VALUE P_INTERNAL_YN
                                     ,'p_userinfo' VALUE P_USERINFO
                                     ,'p_bucket' VALUE P_BUCKET
                                     ,'p_user_dept_id' VALUE P_USER_DEPT_ID);
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        -- GTT 초기화
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_SELECT_MEASURE';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_RAW_DATA';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_SHIPMENT_SITE';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_SHIPMENT_SITE_ROW';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_DM_MST_ITEM_SINGLE_ORI_V';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_DM_MST_ITEM_SINGLE_A_V';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_DM_MST_ITEM_SINGLE_B_V';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_DM_MST_ITEM_SINGLE_V';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_SCM_MST_SITE';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_SCM_MST_SITE_ITEM';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_COLUMN_SETUP';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_T';
        -- PTT는 DROP (존재 시)
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ORA$PTT_GDPS_WF';
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    
        --print 'A--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
        V_COLLIST   := NULL;
        V_ORDERLIST := NULL;
        V_PROD      := NULL;
    
        -- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
        SELECT BASIS_START_DATE INTO V_START_YYYYMMDD FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
    
        --p_now_yyyymmdd := TO_CHAR(FN_NEXT_DAY( SYSDATE, 'MON') + (-7), 'YYYYMMDD')
        -- now 가 to 보다 크면 문제가 됨
        --IF ( p_now_yyyymmdd > p_to_yyyymmdd )
        --BEGIN
        --  p_now_yyyymmdd := p_to_yyyymmdd
        --END
        -- Waterfall은 Edit_Flag 사용하지 않으므로 주석처리
        -- ---------------------------------------------------------------------------------------
        --                                                       Temp Table 존재 여부 체크 (BEGIN)
        -- ---------------------------------------------------------------------------------------
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
        -- ------------------------------------------------------------------------------
        --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
        -- ------------------------------------------------------------------------------
        SELECT COUNT(1)
        INTO   V_CNT_1
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN = 'Y'
        AND    SEGMENT2 = 'ALL' -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
        AND    SEGMENT1 = P_USERINFO;
        IF V_CNT_1 > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
    
        -- ----------------------------------------------------------------------------------------------------------------------
        -- 사용자의 팀정보 & 권한 - [C20210504-000057] SalesPlan 권한은 있으나 편집안되는 현상 수정 2021/05/13 SJHan
        -- ----------------------------------------------------------------------------------------------------------------------
        SELECT LISTAGG(D.SEGMENT3, ',') WITHIN GROUP(ORDER BY D.SEGMENT3)
        INTO   V_DEPT_LIST
        FROM   (SELECT LOOK.SEGMENT1, LOOK.SEGMENT3
                FROM   SCM_ADM_USER_M USR
                INNER  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                ON     USR.DEPT_ID = LOOK.SEGMENT1
                AND    LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                AND    LOOK.VALID_YN = 'Y'
                WHERE  USR.USER_ID = P_CREATED_BY
                UNION
                SELECT DEPT_ID AS SEGMENT1, DEPT_ID AS SEGMENT3
                FROM   SCM_ADM_USER_M
                WHERE  USER_ID = P_CREATED_BY) D
        WHERE  D.SEGMENT1 = (SELECT DEPT_ID FROM SCM_ADM_USER_M WHERE USER_ID = P_CREATED_BY);
    
        -- DAILY 일 경우 EDIT 불가
        --IF P_BUCKET = 'DAILY' THEN
        --BEGIN
        --  SELECT v_group_id IS NULL, v_dept_list = NULL
        --END
        -- ---------------------------------------------------------------------------------------
        -- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
        -- ---------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('D--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        /* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
           과거 구간은 전체 Data가 포함되어야 함.
           단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
           단위 환산이 되어야 함.
        */
        -- ----------------------------------------------------------------------
        -- 20200316 KHSONG C20200224-000109 (BEGIN)
        -- ----------------------------------------------------------------------
        SELECT COUNT(*)
        INTO   V_USER_MEA_CNT
        FROM   SCM_MST_TITLESET_USER U
        WHERE  1 = 1
        AND    U.PROGRAM_ID = P_PROGRAM_ID
        AND    U.SHEET_NAME = P_SHEET_NAME
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
        AND    U.USER_ID = P_CREATED_BY;
    
        IF V_USER_MEA_CNT = 0 THEN
            INSERT INTO SCM_MST_TITLESET_USER
                (USER_ID
                ,PROGRAM_ID
                ,SHEET_NAME
                ,USER_INQUIRY_COLUMN_TYPE_CODE
                ,COLUMN_NAME
                ,SORT_ORDER_NO
                ,SUB_TOTAL_FLAG
                ,DATA_SORT_METHOD_CODE
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE)
                SELECT P_CREATED_BY
                      ,C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,'M'
                      ,C.COLUMN_NAME
                      ,C.SORT_ORDER_NO
                      ,''
                      ,''
                      ,P_CREATED_BY
                      ,SYSDATE
                      ,P_CREATED_BY
                      ,SYSDATE
                FROM   SCM_MST_SHEET_MEASURE C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = P_PROGRAM_ID
                AND    C.SHEET_NAME = P_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN = 'Y';
        END IF;
        -- ----------------------------------------------------------------------
        -- 20200316 KHSONG C20200224-000109 (END)
        -- ----------------------------------------------------------------------
        --테스트 때문--
        IF P_CREATED_BY = 'park.choyi' AND P_PROGRAM_ID = 'DMF0048' THEN
        INSERT INTO GT_GDPS_SELECT_MEASURE
            SELECT DISTINCT U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, '' AS SYSTEM_ADD
            -- 20191025 KHSONG 쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함
            FROM   SCM_MST_TITLESET_USER U
            
            LEFT   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
            ON     (U.USER_ID = T.SEGMENT4) -- 20200309 KHSONG TMM MEASURE 권한추가
            AND    P_CREATED_BY = T.SEGMENT4 -- USER_ID
            AND    T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
            AND    T.VALID_YN = 'Y' -- VALID_YN 여부
            
            WHERE  1 = 1
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
            AND    U.PROGRAM_ID = P_PROGRAM_ID
            AND    U.USER_ID = P_CREATED_BY
            AND    U.USER_ID = 'park.choyi' AND U.COLUMN_NAME IN ('MKT_FCST_RP','RTF_SYS_RP','SalesAmt_LOC')
            AND    U.USER_ID = CASE
                       WHEN U.COLUMN_NAME = 'TMM_FCST' THEN
                        T.SEGMENT4
                       ELSE
                        P_CREATED_BY
                   END; -- 20200309 KHSONG TMM MEASURE 권한추가
        ELSE
        INSERT INTO GT_GDPS_SELECT_MEASURE
            SELECT DISTINCT U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, '' AS SYSTEM_ADD
            -- 20191025 KHSONG 쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함
            FROM   SCM_MST_TITLESET_USER U
            
            LEFT   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
            ON     (U.USER_ID = T.SEGMENT4) -- 20200309 KHSONG TMM MEASURE 권한추가
            AND    P_CREATED_BY = T.SEGMENT4 -- USER_ID
            AND    T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
            AND    T.VALID_YN = 'Y' -- VALID_YN 여부
            
            WHERE  1 = 1
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
            AND    U.PROGRAM_ID = P_PROGRAM_ID
            AND    U.USER_ID = P_CREATED_BY
            AND    U.USER_ID = CASE
                       WHEN U.COLUMN_NAME = 'TMM_FCST' THEN
                        T.SEGMENT4
                       ELSE
                        P_CREATED_BY
                   END; -- 20200309 KHSONG TMM MEASURE 권한추가
        END IF;
        -- ---------------------------------------------------------------------------------------------------------------
        -- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.
        -- ---------------------------------------------------------------------------------------------------------------
        SELECT COUNT(1) INTO V_CNT_2 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE IN ('LOC', 'KRW');
        IF V_CNT_2 > 0 THEN
            INSERT INTO GT_GDPS_SELECT_MEASURE
                (MEASURE, SYSTEM_ADD)
                SELECT A.MEASURE, 'Y'
                FROM   (SELECT 'RTF_SYS_RP' AS MEASURE
                        FROM   DUAL
                        UNION ALL
                        SELECT 'SalesAmt_KRW' AS MEASURE --> 대문자 소문자로 변경. SALESAMT_KRW --> SalesAmt_KRW
                        FROM   DUAL
                        UNION ALL
                        SELECT 'SalesAmt_LOC' AS MEASURE --> 대문자 소문자로 변경. SALESAMT_LOC --> SalesAmt_LOC
                        FROM   DUAL) A
                LEFT   OUTER JOIN GT_GDPS_SELECT_MEASURE B
                ON     A.MEASURE = B.MEASURE
                WHERE  B.MEASURE IS NULL;
                   
        END IF;
    
        SELECT COUNT(1) INTO V_CNT_3 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE IN ('MKT_FCST_RP');
        IF V_CNT_3 > 0 THEN
            INSERT INTO GT_GDPS_SELECT_MEASURE
                (MEASURE, SYSTEM_ADD)
                SELECT A.MEASURE, 'Y'
                FROM   (SELECT 'MKT_FCST' AS MEASURE FROM DUAL UNION ALL SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL) A
                LEFT   OUTER JOIN GT_GDPS_SELECT_MEASURE B
                ON     A.MEASURE = B.MEASURE
                WHERE  B.MEASURE IS NULL;
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('E--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        -- -----------------------------------------------
        -- (1) DM_PLN_SALES_PLAN + (4) DM_PLN_SALES_PLAN (MEASURE = 'MKT_FCST')
        -- -----------------------------------------------
        INSERT INTO GT_GDPS_RAW_DATA
            (VERSION_NO
            ,CUTOFF_YYYYMMDD
            ,DIVISION_ID
            ,PROJECT_CODE
            ,SCM_SITE_ID
            ,PLANT_SITE_ID
            ,ITEM_ID
            ,TEXT
            ,INCOTERMS
            ,DOM_EXP
            ,FCST_TYPE
            ,CURRENCY
            ,COMPANY_ID
            ,MEASURE
            ,YYYYMMDD
            ,QTY
            ,PLAN_RESULT
            ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
             )
            SELECT 'CURRENT' AS VERSION_NO
                  ,NULL CUTOFF_YYYYMMDD
                  ,A.DIVISION_ID
                  ,A.PROJECT_CODE
                  ,A.SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,A.ITEM_ID
                  ,NVL(A.ATTRIBUTE9, NULL) TEXT
                  ,A.INCOTERMS
                  ,A.DOM_EXP
                  ,A.FCST_TYPE
                  ,A.CURRENCY
                  ,NULL COMPANY_ID
                  ,A.MEASURE
                  ,A.YYYYMMDD
                  ,A.QTY
                  ,'P'
                  ,A.CELL_PROD_SITE_ID --, CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
            FROM   DM_PLN_SALES_PLAN A /* 2024.03.08 kimcd index hint 추가 */
            JOIN   GT_GDPS_SELECT_MEASURE B
            ON     A.MEASURE = B.MEASURE
            JOIN   SCM_MST_SITE C
            ON     A.DIVISION_ID = C.DIVISION_ID
            AND    A.SCM_SITE_ID = C.SCM_SITE_ID
            AND    C.VALID_YN = 'Y'
            --LEFT OUTER JOIN GT_GDPS_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
            WHERE  A.YYYYMMDD >= P_NOW_YYYYMMDD
                  --AND A.YYYYMMDD >= p_FROM_yyyymmdd --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
            AND    A.YYYYMMDD <= P_TO_YYYYMMDD
            AND    A.DIVISION_ID = P_DIVISION_ID -- 2024.03.08 kimcd  SCM_MST_DIVISION 제거
                  --AND A.DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE DIVISION_ID = P_DIVISION_ID )
            AND    A.QTY <> 0
                  --마이그레이션 된 데이터 지우면 조건삭제
            AND    A.FCST_TYPE NOT IN (SELECT DISTINCT SEGMENT2
                                       FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                                       WHERE  LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                       AND    VALID_YN = 'Y'
                                       AND    SEGMENT1 = A.DIVISION_ID)
            AND    A.ITEM_ID NOT IN (SELECT DISTINCT SEGMENT3
                                     FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE  LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                     AND    VALID_YN = 'Y'
                                     AND    SEGMENT1 = A.DIVISION_ID)
            AND    A.MEASURE NOT IN (SELECT SEGMENT2
                                     FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE  LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
                                     AND    VALID_YN = 'Y')
            --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 start
            UNION ALL
            SELECT 'CURRENT' AS VERSION_NO
                  ,NULL CUTOFF_YYYYMMDD
                  ,A.DIVISION_ID
                  ,A.PROJECT_CODE
                  ,A.SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,A.ITEM_ID
                  ,A.REMARK_TEXT
                  ,A.INCOTERMS
                  ,A.DOM_EXP
                  ,A.FCST_TYPE
                  ,A.CURRENCY
                  ,NULL COMPANY_ID
                  ,A.MEASURE
                  ,A.YYYYMMDD
                  ,A.QTY
                  ,'P'
                  ,'-' AS CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
            FROM   DM_PLN_SALES_ETC_PLAN A
            JOIN   GT_GDPS_SELECT_MEASURE B
            ON     A.MEASURE = B.MEASURE
            JOIN   SCM_MST_SITE C
            ON     A.DIVISION_ID = C.DIVISION_ID
            AND    A.SCM_SITE_ID = C.SCM_SITE_ID
            AND    C.VALID_YN = 'Y'
            WHERE  A.YYYYMMDD >= P_NOW_YYYYMMDD
                  --AND A.YYYYMMDD >= p_FROM_yyyymmdd --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
            AND    A.YYYYMMDD <= P_TO_YYYYMMDD
            AND    A.DIVISION_ID = P_DIVISION_ID
            AND    A.QTY <> 0
            --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 end
            UNION ALL
            
            SELECT 'CURRENT' AS VERSION_NO
                  ,NULL CUTOFF_YYYYMMDD
                  ,A.DIVISION_ID
                  ,A.PROJECT_CODE
                  ,A.SCM_SITE_ID
                  ,PLANT_SITE_ID
                  ,A.ITEM_ID
                  ,NVL(A.ATTRIBUTE9, NULL) TEXT
                  ,A.INCOTERMS
                  ,A.DOM_EXP
                  ,A.FCST_TYPE
                  ,A.CURRENCY
                  ,A.COMPANY_ID
                  ,A.MEASURE
                  ,A.YYYYMMDD
                  ,A.QTY + CASE
                       WHEN P_INTERNAL_YN = 'Y' AND P_DIVISION_ID = '82' AND REGEXP_LIKE(A.ATTRIBUTE2, '^[0-9.]+$') THEN
                        TO_NUMBER(A.ATTRIBUTE2)
                       ELSE
                        0
                   END
                  ,'R'
                   --, '-' AS CELL_PROD_SITE_ID    --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                  ,A.CELL_PROD_SITE_ID --[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
            FROM   DM_PLN_SALES_PLAN_RESULT A /* 2024.03.08 kimcd index hint 추가 */
            JOIN   GT_GDPS_SELECT_MEASURE B
            ON     A.MEASURE = B.MEASURE
            WHERE  A.YYYYMMDD >= P_FROM_YYYYMMDD
            AND    A.YYYYMMDD < P_NOW_YYYYMMDD
                  --AND A.YYYYMMDD <= p_TO_yyyymmdd --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
            AND    A.DIVISION_ID = P_DIVISION_ID -- 2024.03.08 kimcd  SCM_MST_DIVISION 제거
                  --AND A.DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE DIVISION_ID = P_DIVISION_ID )
            AND    A.QTY <> 0;
    
        --SELECT P_FROM_YYYYMMDD, P_NOW_YYYYMMDD
        --SELECT * FROM GT_GDPS_SELECT_MEASURE
        --select version_no, measure, PLAN_RESULT, count(*) from GT_GDPS_RAW_DATA
        --group by version_no, measure, PLAN_RESULT
        --order by 1, 2
        --select version_no, measure, PLAN_RESULT, count(*) from GT_GDPS_RAW_DATA
        --group by version_no, measure, PLAN_RESULT
        --order by 1, 2
        DBMS_OUTPUT.PUT_LINE('E2--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        
        SELECT COUNT(1) INTO V_CNT_4 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP';
        IF V_CNT_4 > 0 THEN
            INSERT INTO GT_GDPS_RAW_DATA
                (VERSION_NO
                ,CUTOFF_YYYYMMDD
                ,DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,TEXT
                ,INCOTERMS
                ,DOM_EXP
                ,FCST_TYPE
                ,CURRENCY
                ,COMPANY_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY
                ,PLAN_RESULT
                ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                 )
                SELECT VERSION_NO
                      ,A.CUTOFF_YYYYMMDD
                      ,DIVISION_ID
                      ,PROJECT_CODE
                      ,SCM_SITE_ID
                      ,PLANT_SITE_ID
                      ,ITEM_ID
                      ,TEXT
                      ,INCOTERMS
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,CURRENCY
                      ,COMPANY_ID
                      ,'MKT_FCST_RP' AS MEASURE
                      ,YYYYMMDD
                      ,QTY
                      ,A.PLAN_RESULT
                      ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                FROM   GT_GDPS_RAW_DATA A
                WHERE  A.MEASURE = 'MKT_FCST'
                AND    A.YYYYMMDD >= CASE
                           WHEN VERSION_NO = 'CURRENT' THEN
                            P_NOW_YYYYMMDD
                           ELSE
                            TO_CHAR(FN_NEXT_DAY(CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
                       END -- [C20200521-000202] Version cutoff 기준으로 MKT_FCST 조회
                AND    A.YYYYMMDD <= P_TO_YYYYMMDD;
        
            INSERT INTO GT_GDPS_RAW_DATA
                (VERSION_NO
                ,CUTOFF_YYYYMMDD
                ,DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,TEXT
                ,INCOTERMS
                ,DOM_EXP
                ,FCST_TYPE
                ,CURRENCY
                ,COMPANY_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY
                ,PLAN_RESULT
                ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                 )
                SELECT VERSION_NO
                      ,A.CUTOFF_YYYYMMDD
                      ,DIVISION_ID
                      ,PROJECT_CODE
                      ,SCM_SITE_ID
                      ,PLANT_SITE_ID
                      ,ITEM_ID
                      ,TEXT
                      ,INCOTERMS
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,CURRENCY
                      ,COMPANY_ID
                      ,'MKT_FCST_RP' AS MEASURE
                      ,YYYYMMDD
                      ,QTY
                      ,PLAN_RESULT
                      ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                FROM   GT_GDPS_RAW_DATA A
                WHERE  MEASURE = 'RTF_SYS_RP'
                AND    A.YYYYMMDD >= P_FROM_YYYYMMDD
                AND    A.YYYYMMDD < CASE
                           WHEN VERSION_NO = 'CURRENT' THEN
                            P_NOW_YYYYMMDD
                           ELSE
                            TO_CHAR(FN_NEXT_DAY(CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
                       END; -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('E3--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        -- 아래서부터는 CURRENCY를 사용해야 하므로 여기서 UPDATE 한다.
        UPDATE GT_GDPS_RAW_DATA A
        SET    A.CURRENCY =
               (SELECT B.CURRENCY
                FROM   SCM_MST_SITE_ITEM B
                WHERE  B.DIVISION_ID = A.DIVISION_ID
                AND    B.PROJECT_CODE = A.PROJECT_CODE
                AND    B.SCM_SITE_ID = A.SCM_SITE_ID
                AND    B.ITEM_ID = A.ITEM_ID
                AND    ROWNUM = 1)
        WHERE  A.CURRENCY IS NULL
        AND    EXISTS (SELECT 1
                FROM   SCM_MST_SITE_ITEM B
                WHERE  B.DIVISION_ID = A.DIVISION_ID
                AND    B.PROJECT_CODE = A.PROJECT_CODE
                AND    B.SCM_SITE_ID = A.SCM_SITE_ID
                AND    B.ITEM_ID = A.ITEM_ID);
    
        IF (P_INTERNAL_YN <> 'Y') THEN
            DELETE FROM GT_GDPS_RAW_DATA WHERE SCM_SITE_ID IN (SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN);
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('B--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
        --원소스 주석처리
        -- --------------------------------------------------------------------------------------
        --                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (BEGIN)
        -- --------------------------------------------------------------------------------------
        /* 2024.03.13    kcw3408       DM 프로시저 속도개선: GT_GDPS_DM_MST_ITEM_SINGLE_V 테이블 변경 */
        /*
         INSERT INTO GT_GDPS_DM_MST_ITEM_SINGLE_V
         SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
           , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
           , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
           , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
           , ENERGE, CELL_QUANTITY
           , MDM_PROJECT_NAME, CELL_TYPE, SCP_EXTRA_SPEC
          --FROM DM_MST_ITEM_SINGLE_V A
          FROM
          (
                    SELECT  T1.DIVISION_ID,
                        T1.ITEM_ID,
                        MAX(T1.ITEM_NAME) ITEM_NAME,                --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                        MAX(T1.ITEM_CLASS) ITEM_CLASS,              --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                        MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME,        --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                        MAX(T1.NICK_NAME) NICK_NAME,            --닉네임이 NULL인 경우가 있으므로 하나로 통일
                        case  min( case when T1.item_type = 'P' then 1                  --타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
                                        when T1.item_type = 'H' then 2                  --또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
                                        when T1.item_type = 'Q' then 3
                                        else 4 end )
                                                        when 1 then 'P'
                                                        when 2 then 'H'
                                                        when 3 then 'Q'
                                                        else 'R' end    AS ITEM_TYPE,
                        MAX(T1.MATERIAL_CLASS_NAME              ) MATERIAL_CLASS_NAME,
                        MAX(T1.ITEM_UOM                         ) ITEM_UOM,
                        MAX(T1.SPEC                             ) SPEC,
                        MAX(T1.MDM_PROJECT_NAME                 ) MDM_PROJECT_NAME,
                        MAX(T1.MIN_CAPACITY                     ) MIN_CAPACITY,
                        MAX(T2.FORECAST_INFO_BIZ_TYPE           ) FORECAST_INFO_BIZ_TYPE,
                        MAX(T2.FORECAST_INFO_PRODUCT_GROUP      ) FORECAST_INFO_PRODUCT_GROUP,
                        MAX(T2.FORECAST_INFO_CELL_MODEL         ) FORECAST_INFO_CELL_MODEL,
                        MAX(T2.FORECAST_INFO_CELL_PACK_COUNT    ) FORECAST_INFO_CELL_PACK_COUNT,
                        MAX(T2.FORECAST_INFO_SPEC               ) FORECAST_INFO_SPEC,
                        MAX(T2.FORECAST_INFOR_VERSION           ) FORECAST_INFOR_VERSION,
                        MAX(T1.ACTIVE_FLAG                      ) ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
                        MAX(T2.CELL_TYPE                        ) CELL_TYPE,  -- 20180911 ADD cell_type
                        MAX(T1.ENERGE                           ) ENERGE,           -- 20200116 khsong ADD ENERGE
                        MAX(T1.CELL_QUANTITY                    ) CELL_QUANTITY,    -- 20200116 khsong ADD CELL_QUANTITY
                        MAX(T1.SCP_EXTRA_SPEC) SCP_EXTRA_SPEC    -- [20210428 SJHAN / CSR ID:C20210323-000420]
                    --FROM SCM_MST_ITEM_SN T1
                    FROM [10.34.221.78,7433].FP_MGR.SCM_ITEM_M T1
                    INNER JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) ITEM_ID
                                    , MAX(FORECAST_INFO_BIZ_TYPE) FORECAST_INFO_BIZ_TYPE
                                    , MAX(FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
                                    , MAX(FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
                                    , MAX(FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
                                    , MAX(FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
                                    , MAX(FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
                                    , MAX(CELL_TYPE) CELL_TYPE
                                FROM  SCM_MST_ITEM_SN T2
                               WHERE  DIVISION_ID =  p_division_id
                                GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
                            ) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
                        AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
                    where 1=1
                    AND     T1.DIVISION_ID = p_division_id
                    group by T1.DIVISION_ID, T1.ITEM_ID
          )  A
          join ( select distinct division_id, item_id from GT_GDPS_RAW_DATA) b
               on a.division_id = b.division_id and a.item_id = b.item_id
          WHERE A.DIVISION_ID = p_division_id;
        */
        DBMS_OUTPUT.PUT_LINE('B1--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        --> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
        INSERT INTO GT_GDPS_DM_MST_ITEM_SINGLE_ORI_V
            SELECT *
            FROM   SCM_MST_ITEM_SN
            --FROM [10.34.221.78,7433].FP_MGR.SCM_ITEM_M
            WHERE  DIVISION_ID = P_DIVISION_ID;
    
        DBMS_OUTPUT.PUT_LINE('B2--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
        INSERT INTO GT_GDPS_DM_MST_ITEM_SINGLE_A_V
            SELECT T1.DIVISION_ID
                  ,T1.ITEM_ID
                  ,MAX(T1.ITEM_NAME) ITEM_NAME
                  ,MAX(T1.ITEM_CLASS) ITEM_CLASS
                  ,MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME
                  ,MAX(T1.NICK_NAME) NICK_NAME
                  ,CASE MIN(CASE
                            WHEN T1.ITEM_TYPE = 'P' THEN
                             1
                            WHEN T1.ITEM_TYPE = 'H' THEN
                             2
                            WHEN T1.ITEM_TYPE = 'Q' THEN
                             3
                            ELSE
                             4
                        END)
                       WHEN 1 THEN
                        'P'
                       WHEN 2 THEN
                        'H'
                       WHEN 3 THEN
                        'Q'
                       ELSE
                        'R'
                   END AS ITEM_TYPE
                  ,MAX(T1.MATERIAL_CLASS_NAME) MATERIAL_CLASS_NAME
                  ,MAX(T1.ITEM_UOM) ITEM_UOM
                  ,MAX(T1.SPEC) SPEC
                  ,MAX(T1.MDM_PROJECT_NAME) MDM_PROJECT_NAME
                  ,MAX(T1.MIN_CAPACITY) MIN_CAPACITY
                  ,MAX(T1.ACTIVE_FLAG) ACTIVE_FLAG
                  ,MAX(T1.ENERGE) ENERGE
                  ,MAX(T1.CELL_QUANTITY) CELL_QUANTITY
                  ,MAX(T1.SCP_EXTRA_SPEC) SCP_EXTRA_SPEC
            FROM   GT_GDPS_DM_MST_ITEM_SINGLE_ORI_V T1
            WHERE  1 = 1
            GROUP  BY T1.DIVISION_ID, T1.ITEM_ID;
    
        DBMS_OUTPUT.PUT_LINE('B3--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
        INSERT INTO GT_GDPS_DM_MST_ITEM_SINGLE_B_V
            SELECT DIVISION_ID
                  ,SUBSTR(ITEM_ID, 1, 12) ITEM_ID
                  ,MAX(FORECAST_INFO_BIZ_TYPE) FORECAST_INFO_BIZ_TYPE
                  ,MAX(FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
                  ,MAX(FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
                  ,MAX(FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
                  ,MAX(FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
                  ,MAX(FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
                  ,MAX(CELL_TYPE) CELL_TYPE
            FROM   GT_GDPS_DM_MST_ITEM_SINGLE_ORI_V T2
            GROUP  BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);
    
        DBMS_OUTPUT.PUT_LINE('B4--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        --TEMP 테이블에 넣은 데이터를 JOIN 한다.
        INSERT INTO GT_GDPS_DM_MST_ITEM_SINGLE_V
            SELECT A.DIVISION_ID
                  ,A.ITEM_ID
                  ,A.ITEM_NAME
                  ,A.ITEM_CLASS
                  ,A.ITEM_CLASS_NAME
                  ,A.NICK_NAME
                  ,A.ITEM_TYPE
                  ,A.MATERIAL_CLASS_NAME
                  ,A.ITEM_UOM
                  ,A.SPEC
                  ,A.MDM_PROJECT_NAME
                  ,A.MIN_CAPACITY
                  ,A.FORECAST_INFO_BIZ_TYPE
                  ,A.FORECAST_INFO_PRODUCT_GROUP
                  ,A.FORECAST_INFO_CELL_MODEL
                  ,A.FORECAST_INFO_CELL_PACK_COUNT
                  ,A.FORECAST_INFO_SPEC
                  ,A.FORECAST_INFOR_VERSION
                  ,A.ACTIVE_FLAG
                  ,A.CELL_TYPE
                  ,A.ENERGE
                  ,A.CELL_QUANTITY
                  ,A.SCP_EXTRA_SPEC
            FROM   (SELECT T1.DIVISION_ID
                          ,T1.ITEM_ID
                          ,T1.ITEM_NAME                     ITEM_NAME
                          ,T1.ITEM_CLASS                    ITEM_CLASS
                          ,T1.ITEM_CLASS_NAME               ITEM_CLASS_NAME
                          ,T1.NICK_NAME                     NICK_NAME
                          ,T1.ITEM_TYPE                     ITEM_TYPE
                          ,T1.MATERIAL_CLASS_NAME           MATERIAL_CLASS_NAME
                          ,T1.ITEM_UOM                      ITEM_UOM
                          ,T1.SPEC                          SPEC
                          ,T1.MDM_PROJECT_NAME              MDM_PROJECT_NAME
                          ,T1.MIN_CAPACITY                  MIN_CAPACITY
                          ,T2.FORECAST_INFO_BIZ_TYPE        FORECAST_INFO_BIZ_TYPE
                          ,T2.FORECAST_INFO_PRODUCT_GROUP   FORECAST_INFO_PRODUCT_GROUP
                          ,T2.FORECAST_INFO_CELL_MODEL      FORECAST_INFO_CELL_MODEL
                          ,T2.FORECAST_INFO_CELL_PACK_COUNT FORECAST_INFO_CELL_PACK_COUNT
                          ,T2.FORECAST_INFO_SPEC            FORECAST_INFO_SPEC
                          ,T2.FORECAST_INFOR_VERSION        FORECAST_INFOR_VERSION
                          ,T1.ACTIVE_FLAG                   ACTIVE_FLAG
                          ,T2.CELL_TYPE                     CELL_TYPE
                          ,T1.ENERGE                        ENERGE
                          ,T1.CELL_QUANTITY                 CELL_QUANTITY
                          ,T1.SCP_EXTRA_SPEC                SCP_EXTRA_SPEC
                    FROM   GT_GDPS_DM_MST_ITEM_SINGLE_A_V T1
                    INNER  JOIN GT_GDPS_DM_MST_ITEM_SINGLE_B_V T2
                    ON     T1.DIVISION_ID = T2.DIVISION_ID
                    AND    SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
                    WHERE  1 = 1) A
            JOIN   (SELECT DISTINCT DIVISION_ID, ITEM_ID FROM GT_GDPS_RAW_DATA) B
            ON     A.DIVISION_ID = B.DIVISION_ID
            AND    A.ITEM_ID = B.ITEM_ID
            WHERE  A.DIVISION_ID = P_DIVISION_ID
            GROUP  BY A.DIVISION_ID
                     ,A.ITEM_ID
                     ,A.ITEM_NAME
                     ,A.ITEM_CLASS
                     ,A.ITEM_CLASS_NAME
                     ,A.NICK_NAME
                     ,A.ITEM_TYPE
                     ,A.MATERIAL_CLASS_NAME
                     ,A.ITEM_UOM
                     ,A.SPEC
                     ,A.MDM_PROJECT_NAME
                     ,A.MIN_CAPACITY
                     ,A.FORECAST_INFO_BIZ_TYPE
                     ,A.FORECAST_INFO_PRODUCT_GROUP
                     ,A.FORECAST_INFO_CELL_MODEL
                     ,A.FORECAST_INFO_CELL_PACK_COUNT
                     ,A.FORECAST_INFO_SPEC
                     ,A.FORECAST_INFOR_VERSION
                     ,A.ACTIVE_FLAG
                     ,A.CELL_TYPE
                     ,A.ENERGE
                     ,A.CELL_QUANTITY
                     ,A.SCP_EXTRA_SPEC;
    
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
        DBMS_OUTPUT.PUT_LINE('B5--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        --[E20240731-000856]_[공급 SCM PI팀] Wh --> KWh 환산 로직개선 END
        /*
                  INSERT INTO GT_GDPS_DM_MST_ITEM_SINGLE_V
                  SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
                          , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
                          , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
                          , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
                          , ENERGE, CELL_QUANTITY
                          , MDM_PROJECT_NAME, CELL_TYPE
                   FROM DM_MST_ITEM_SINGLE_V A
                   join ( select distinct division_id, item_id from GT_GDPS_RAW_DATA ) b on a.division_id = b.division_id and a.item_id = b.item_id
                  WHERE A.DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE DIVISION_ID = P_DIVISION_ID );
        */
        -- --------------------------------------------------------------------------------------
        --                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
        -- --------------------------------------------------------------------------------------
        -- ---------------------------------------------------------------------------------------
        --                                 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
        -- ---------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('C--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        -- ---------------------------------------------------------------------------------------
        -- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
        -- ---------------------------------------------------------------------------------------
        INSERT INTO GT_GDPS_SCM_MST_SITE_ITEM
            SELECT A.DIVISION_ID
                  ,A.PROJECT_CODE
                  ,A.SCM_SITE_ID
                  ,A.ITEM_ID
                  ,APPLICATION
                  ,CUST_GROUP
                  ,ROUTE
                  ,CUST_GROUP_DTL
                  ,CELL_PER_CAR
                  ,CELL_PER_MODULE
                  ,CURRENCY
                  ,SALES_COMPANY
                  ,SALES_PLANT
                  ,SALES_PLAN_ADJUST_YN
                  ,ATTRIBUTE1
                  ,ATTRIBUTE2
                  ,ATTRIBUTE5
                  ,ATTRIBUTE7
                  ,ATTRIBUTE8
                  ,ATTRIBUTE9
                  ,NULL REPORT_GROUP6
                  ,A.OWNER
                  ,FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'EN') OWNER_NAME
                  ,FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'KO') OWNER_NAME_KO
                  ,(SELECT SU.DEPT_ID
                    FROM   SCM_MST_SSO_USER_INFO SU
                    WHERE  SU.USER_ID = (SELECT VALUE FROM TABLE(FN_SPLITSTRING(A.OWNER, ',')) FETCH FIRST 1 ROWS ONLY)) DEPT_ID
                  ,VALID_YN
            FROM   SCM_MST_SITE_ITEM A
            JOIN   (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM GT_GDPS_RAW_DATA) B
            ON     A.DIVISION_ID = B.DIVISION_ID
            AND    A.SCM_SITE_ID = B.SCM_SITE_ID
            AND    A.PROJECT_CODE = B.PROJECT_CODE
            AND    A.ITEM_ID = B.ITEM_ID
            WHERE  A.DIVISION_ID = P_DIVISION_ID;
        --  WHERE a.Division_id IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE DIVISION_ID = P_DIVISION_ID )
        --DELETE FROM A
        --FROM GT_GDPS_RAW_DATA A
        --LEFT OUTER JOIN GT_GDPS_SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
        --WHERE A.PLAN_RESULT = 'P'
        --  AND A.ITEM_ID NOT IN ('ETC', 'ED_D','TOOLING','MDF')
        --  AND NVL(B.VALID_YN, NULL) <> 'Y'
        --AND A.VERSION_NO = 'CURRENT'  ( 수정 전 로직이 버전구분 없이 처리 )
        --[[orphan FETCH FIRST 제거]]
        --[PJ2024-50611] 화면에서 저장한 dept_id 업데이트 start
        MERGE INTO GT_GDPS_RAW_DATA A
        USING (SELECT DIVISION_ID
                     ,PROJECT_CODE
                     ,SCM_SITE_ID
                     ,ITEM_ID
                     ,DOM_EXP
                     ,FCST_TYPE
                     ,INCOTERMS
                     ,MAX(MEASURE) MEASURE
                     ,PLANT_SITE_ID
                     ,YYYYMMDD
                     ,MAX(ATTRIBUTE1) ATTRIBUTE1
                     ,REMARK_TEXT --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 필드추가
                     ,'-' AS CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
               FROM   DM_PLN_SALES_ETC_PLAN --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
               WHERE  DIVISION_ID = '40'
               AND    FCST_TYPE = 'ETC'
               AND    YYYYMMDD >= P_NOW_YYYYMMDD
               AND    YYYYMMDD <= P_TO_YYYYMMDD
               AND    QTY <> 0
               GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD, REMARK_TEXT) B
        ON (A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.DOM_EXP = B.DOM_EXP AND A.FCST_TYPE = B.FCST_TYPE AND A.INCOTERMS = B.INCOTERMS AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.YYYYMMDD = B.YYYYMMDD AND A.TEXT = B.REMARK_TEXT --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 조인추가
        AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID --[PJ2025-50017]
        )
        WHEN MATCHED THEN
            UPDATE SET A.ATTRIBUTE1 = B.ATTRIBUTE1;
        --[PJ2024-50611] 화면에서 저장한 dept_id 처리 end
        -- -----------------------------------------------------------------------------------------------------------------------------------------
        -- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )
        -- -----------------------------------------------------------------------------------------------------------------------------------------
        -- 필터링 시작
    
        IF (P_PROJECT_CODE IS NOT NULL) THEN
            -- 소형은 UI 에서 PROJECT DISABLE 됨
            DELETE FROM GT_GDPS_RAW_DATA A
            WHERE  NOT EXISTS (SELECT 1
                    FROM   SCM_MST_PROJECT B, TABLE(FN_SPLITSTRING(P_PROJECT_CODE, ',')) T
                    WHERE  B.DIVISION_ID = A.DIVISION_ID
                    AND    B.PROJECT_CODE = A.PROJECT_CODE
                    AND    (B.PROJECT_CODE LIKE '%' || T.VALUE || '%' OR B.PROJECT_NAME LIKE '%' || T.VALUE || '%'));
        END IF;
    
        IF (P_ITEM_ID IS NOT NULL) THEN
            DELETE FROM GT_GDPS_RAW_DATA A
            WHERE  NOT EXISTS (SELECT 1 FROM TABLE(FN_SPLITSTRING(P_ITEM_ID, ',')) T WHERE A.ITEM_ID LIKE '%' || T.VALUE || '%')
            AND    NOT EXISTS (SELECT 1
                    FROM   GT_GDPS_DM_MST_ITEM_SINGLE_V B, TABLE(FN_SPLITSTRING(P_ITEM_ID, ',')) T
                    WHERE  B.ITEM_ID = A.ITEM_ID
                    AND    B.NICK_NAME LIKE '%' || T.VALUE || '%');
        END IF;
    
        IF (P_OWNER IS NOT NULL) THEN
            DELETE FROM GT_GDPS_RAW_DATA A
            WHERE  NOT EXISTS
             (SELECT 1
                    FROM   GT_GDPS_SCM_MST_SITE_ITEM B, TABLE(FN_SPLITSTRING(P_OWNER, ',')) T
                    WHERE  B.ITEM_ID = A.ITEM_ID
                    AND    B.SCM_SITE_ID = A.SCM_SITE_ID
                    AND    B.PROJECT_CODE = A.PROJECT_CODE
                    AND    (B.OWNER LIKE '%' || T.VALUE || '%' OR B.OWNER_NAME LIKE '%' || T.VALUE || '%' OR B.OWNER_NAME_KO LIKE '%' || T.VALUE || '%'));
        END IF;
    
        IF (P_DEPT_ID <> 'ALL') THEN
        
            --[PJ2024-50461] Team Mapping------------------------------------
            --기타매출 이외
            DELETE FROM GT_GDPS_RAW_DATA A
            WHERE  A.FCST_TYPE <> 'ETC'
            AND    NOT EXISTS (SELECT 1
                    FROM   GT_GDPS_SCM_MST_SITE_ITEM B, TABLE(FN_SPLITSTRING(P_DEPT_ID, ',')) T
                    WHERE  B.ITEM_ID = A.ITEM_ID
                    AND    B.SCM_SITE_ID = A.SCM_SITE_ID
                    AND    B.PROJECT_CODE = A.PROJECT_CODE
                    AND    B.DEPT_ID = T.VALUE);
        
            --기타매출(40 이외 사업부)
            DELETE FROM GT_GDPS_RAW_DATA A
            WHERE  A.FCST_TYPE = 'ETC'
            AND    A.DIVISION_ID <> '40' --[PJ2024-50611] 40 이외 사업부는 기타일 경우 SCM_MST_SITE 에서 가져옴
            AND    NOT EXISTS (SELECT 1
                    FROM   SCM_MST_SITE B
                    JOIN   SCM_MST_SITE_ITEM MSI
                    ON     MSI.DIVISION_ID = B.DIVISION_ID
                    AND    MSI.SCM_SITE_ID = B.SCM_SITE_ID, TABLE(FN_SPLITSTRING(P_DEPT_ID, ',')) T
                    WHERE  B.SCM_SITE_ID = A.SCM_SITE_ID
                    AND    B.DIVISION_ID = P_DIVISION_ID
                    AND    MSI.DEPT_ID = T.VALUE);
        
            ----[PJ2024-50611]기타매출(40사업부) START
            DELETE FROM GT_GDPS_RAW_DATA A
            WHERE  A.FCST_TYPE = 'ETC'
            AND    A.DIVISION_ID = '40'
            AND    NOT EXISTS (SELECT 1
                    FROM   TABLE(FN_SPLITSTRING(P_DEPT_ID, ',')) T
                    WHERE  A.ATTRIBUTE1 = T.VALUE --[PJ2024-50611] 40사업부 기타매출은 ATTRIBUTE1 에 부서코드 있음
                    );
            ----[PJ2024-50611]기타매출(40사업부) END
        
            /*
                IF ( P_DIVISION_ID = '40') THEN
                    DELETE FROM GT_GDPS_RAW_DATA A
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM GT_GDPS_SCM_MST_SITE_ITEM B,
                             TABLE(fn_splitstring(p_dept_id, ',')) T
                        WHERE B.ITEM_ID = A.ITEM_ID
                          AND B.SCM_SITE_ID = A.SCM_SITE_ID
                          AND B.PROJECT_CODE = A.PROJECT_CODE
                          AND B.DEPT_ID = T.value
                    );
                ELSE
                    DELETE FROM GT_GDPS_RAW_DATA A
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM SCM_MST_SITE B,
                             TABLE(fn_splitstring(p_dept_id, ',')) T
                        WHERE B.SCM_SITE_ID = A.SCM_SITE_ID
                          AND B.DIVISION_ID = P_DIVISION_ID
                          AND B.DEPT_ID = T.value
                    );
                END IF;
            */
        END IF;
    
        IF (P_END_CUSTOMER <> 'ALL') THEN
            IF (P_DIVISION_ID = '40') THEN
                DELETE FROM GT_GDPS_RAW_DATA A WHERE NOT EXISTS (SELECT 1 FROM TABLE(FN_SPLITSTRING(P_END_CUSTOMER, ',')) T WHERE A.PROJECT_CODE = T.VALUE);
            ELSE
                DELETE FROM GT_GDPS_RAW_DATA A
                WHERE  NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE B, TABLE(FN_SPLITSTRING(P_END_CUSTOMER, ',')) T
                        WHERE  B.SCM_SITE_ID = A.SCM_SITE_ID
                        AND    B.DIVISION_ID = P_DIVISION_ID
                        AND    B.END_CUSTOMER = T.VALUE);
            END IF;
        END IF;
    
        IF (P_SCM_SITE_ID <> 'ALL') THEN
            DELETE FROM GT_GDPS_RAW_DATA A WHERE NOT EXISTS (SELECT 1 FROM TABLE(FN_SPLITSTRING(P_SCM_SITE_ID, ',')) T WHERE A.SCM_SITE_ID = T.VALUE);
        END IF;
    
        IF (P_PLANT_SITE_ID <> 'ALL') THEN
            DELETE FROM GT_GDPS_RAW_DATA A WHERE NOT EXISTS (SELECT 1 FROM TABLE(FN_SPLITSTRING(P_PLANT_SITE_ID, ',')) T WHERE A.PLANT_SITE_ID = T.VALUE);
        END IF;
    
        IF (P_ITEM_TYPE <> 'ALL') THEN
            DELETE FROM GT_GDPS_RAW_DATA A
            WHERE  NOT EXISTS (SELECT 1
                    FROM   GT_GDPS_DM_MST_ITEM_SINGLE_V B, TABLE(FN_SPLITSTRING(P_ITEM_TYPE, ',')) T
                    WHERE  B.ITEM_ID = A.ITEM_ID
                    AND    B.ITEM_TYPE = T.VALUE);
        END IF;
    
        IF (P_BIZTYPE <> 'ALL') THEN
            IF (P_DIVISION_ID = '40') THEN
                DELETE FROM GT_GDPS_RAW_DATA A
                WHERE  NOT EXISTS (SELECT 1
                        FROM   GT_GDPS_DM_MST_ITEM_SINGLE_V B, TABLE(FN_SPLITSTRING(P_BIZTYPE, ',')) T
                        WHERE  B.ITEM_ID = A.ITEM_ID
                        AND    B.FORECAST_INFO_BIZ_TYPE = T.VALUE);
            ELSE
                DELETE FROM GT_GDPS_RAW_DATA A
                WHERE  NOT EXISTS (SELECT 1
                        FROM   SCM_MST_PROJECT B, TABLE(FN_SPLITSTRING(P_BIZTYPE, ',')) T
                        WHERE  B.DIVISION_ID = A.DIVISION_ID
                        AND    B.PROJECT_CODE = A.PROJECT_CODE
                        AND    B.BIZ_TYPE LIKE '%' || T.VALUE || '%');
            END IF;
        END IF;
    
        -- 필터링 끝
    
        DBMS_OUTPUT.PUT_LINE('E4--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        --SELECT COUNT(*) FROM GT_GDPS_RAW_DATA
        -- 실적구간 PRICE 처리
        SELECT COUNT(1) INTO V_CNT_5 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE = 'LOC';
        IF V_CNT_5 > 0 THEN
            INSERT INTO GT_GDPS_RAW_DATA
                (VERSION_NO
                ,CUTOFF_YYYYMMDD
                ,DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,TEXT
                ,INCOTERMS
                ,DOM_EXP
                ,FCST_TYPE
                ,CURRENCY
                ,COMPANY_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY
                ,PLAN_RESULT
                ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                 )
                SELECT A.VERSION_NO
                      ,A.CUTOFF_YYYYMMDD
                      ,A.DIVISION_ID
                      ,A.PROJECT_CODE
                      ,A.SCM_SITE_ID
                      ,A.PLANT_SITE_ID
                      ,A.ITEM_ID
                      ,'' AS TEXT
                      ,A.INCOTERMS
                      ,A.DOM_EXP
                      ,A.FCST_TYPE
                      ,A.CURRENCY
                      ,A.COMPANY_ID
                      ,'LOC' AS MEASURE
                      ,A.YYYYMMDD
                      ,CASE
                           WHEN A.QTY <> 0 THEN
                            B.QTY / A.QTY
                           ELSE
                            0
                       END AS QTY
                      ,'R'
                      ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                FROM   (SELECT A.VERSION_NO
                              ,A.CUTOFF_YYYYMMDD
                              ,A.DIVISION_ID
                              ,A.PROJECT_CODE
                              ,A.SCM_SITE_ID
                              ,A.PLANT_SITE_ID
                              ,A.ITEM_ID
                              ,A.INCOTERMS
                              ,A.DOM_EXP
                              ,A.FCST_TYPE
                              ,A.CURRENCY
                              ,A.COMPANY_ID
                              ,A.YYYYMMDD
                              ,SUM(A.QTY) QTY
                              ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        FROM   GT_GDPS_RAW_DATA A
                        WHERE  YYYYMMDD >= V_START_YYYYMMDD
                        AND    YYYYMMDD < CASE
                                   WHEN VERSION_NO = 'CURRENT' THEN
                                    P_NOW_YYYYMMDD
                                   ELSE
                                    TO_CHAR(FN_NEXT_DAY(CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
                               END
                        AND    A.MEASURE = 'RTF_SYS_RP'
                        GROUP  BY A.VERSION_NO
                                 ,A.CUTOFF_YYYYMMDD
                                 ,A.DIVISION_ID
                                 ,A.PROJECT_CODE
                                 ,A.SCM_SITE_ID
                                 ,A.PLANT_SITE_ID
                                 ,A.ITEM_ID
                                 ,A.INCOTERMS
                                 ,A.DOM_EXP
                                 ,A.FCST_TYPE
                                 ,A.CURRENCY
                                 ,A.COMPANY_ID
                                 ,A.YYYYMMDD
                                 ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        ) A
                JOIN   (SELECT A.VERSION_NO
                              ,A.CUTOFF_YYYYMMDD
                              ,A.DIVISION_ID
                              ,A.PROJECT_CODE
                              ,A.SCM_SITE_ID
                              ,A.PLANT_SITE_ID
                              ,A.ITEM_ID
                              ,A.INCOTERMS
                              ,A.DOM_EXP
                              ,A.FCST_TYPE
                              ,A.CURRENCY
                              ,A.COMPANY_ID
                              ,A.YYYYMMDD
                              ,SUM(A.QTY) QTY
                              ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        FROM   GT_GDPS_RAW_DATA A
                        WHERE  YYYYMMDD >= V_START_YYYYMMDD
                        AND    YYYYMMDD < CASE
                                   WHEN VERSION_NO = 'CURRENT' THEN
                                    P_NOW_YYYYMMDD
                                   ELSE
                                    TO_CHAR(FN_NEXT_DAY(CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
                               END
                        AND    A.MEASURE = 'SalesAmt_LOC'
                        GROUP  BY A.VERSION_NO
                                 ,A.CUTOFF_YYYYMMDD
                                 ,A.DIVISION_ID
                                 ,A.PROJECT_CODE
                                 ,A.SCM_SITE_ID
                                 ,A.PLANT_SITE_ID
                                 ,A.ITEM_ID
                                 ,A.INCOTERMS
                                 ,A.DOM_EXP
                                 ,A.FCST_TYPE
                                 ,A.CURRENCY
                                 ,A.COMPANY_ID
                                 ,A.YYYYMMDD
                                 ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        ) B
                ON     A.VERSION_NO = B.VERSION_NO
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.PROJECT_CODE = B.PROJECT_CODE
                AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                AND    A.ITEM_ID = B.ITEM_ID
                AND    A.INCOTERMS = B.INCOTERMS
                AND    A.DOM_EXP = B.DOM_EXP
                AND    A.FCST_TYPE = B.FCST_TYPE
                AND    A.CURRENCY = B.CURRENCY
                AND    A.YYYYMMDD = B.YYYYMMDD
                AND    NVL(A.COMPANY_ID, '@#@#@#') = NVL(B.COMPANY_ID, '@#@#@#')
                AND    A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID; --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
        
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('E5--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        SELECT COUNT(1) INTO V_CNT_6 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE = 'KRW';
        IF V_CNT_6 > 0 THEN
            INSERT INTO GT_GDPS_RAW_DATA
                (VERSION_NO
                ,CUTOFF_YYYYMMDD
                ,DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,TEXT
                ,INCOTERMS
                ,DOM_EXP
                ,FCST_TYPE
                ,CURRENCY
                ,COMPANY_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY
                ,PLAN_RESULT
                ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                 )
                SELECT A.VERSION_NO
                      ,A.CUTOFF_YYYYMMDD
                      ,A.DIVISION_ID
                      ,A.PROJECT_CODE
                      ,A.SCM_SITE_ID
                      ,A.PLANT_SITE_ID
                      ,A.ITEM_ID
                      ,'' AS TEXT
                      ,A.INCOTERMS
                      ,A.DOM_EXP
                      ,A.FCST_TYPE
                      ,A.CURRENCY
                      ,A.COMPANY_ID
                      ,'KRW' AS MEASURE
                      ,A.YYYYMMDD
                      ,CASE
                           WHEN A.QTY <> 0 THEN
                            B.QTY / A.QTY
                           ELSE
                            0
                       END AS QTY
                      ,'R'
                      ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                FROM   (SELECT A.VERSION_NO
                              ,A.CUTOFF_YYYYMMDD
                              ,A.DIVISION_ID
                              ,A.PROJECT_CODE
                              ,A.SCM_SITE_ID
                              ,A.PLANT_SITE_ID
                              ,A.ITEM_ID
                              ,A.INCOTERMS
                              ,A.DOM_EXP
                              ,A.FCST_TYPE
                              ,A.CURRENCY
                              ,A.COMPANY_ID
                              ,A.YYYYMMDD
                              ,SUM(A.QTY) QTY
                              ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        FROM   GT_GDPS_RAW_DATA A
                        WHERE  YYYYMMDD >= V_START_YYYYMMDD
                        AND    YYYYMMDD < CASE
                                   WHEN VERSION_NO = 'CURRENT' THEN
                                    P_NOW_YYYYMMDD
                                   ELSE
                                    TO_CHAR(FN_NEXT_DAY(CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
                               END
                        AND    A.MEASURE = 'RTF_SYS_RP'
                        GROUP  BY A.VERSION_NO
                                 ,A.CUTOFF_YYYYMMDD
                                 ,A.DIVISION_ID
                                 ,A.PROJECT_CODE
                                 ,A.SCM_SITE_ID
                                 ,A.PLANT_SITE_ID
                                 ,A.ITEM_ID
                                 ,A.INCOTERMS
                                 ,A.DOM_EXP
                                 ,A.FCST_TYPE
                                 ,A.CURRENCY
                                 ,A.COMPANY_ID
                                 ,A.YYYYMMDD
                                 ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        ) A
                JOIN   (SELECT A.VERSION_NO
                              ,A.CUTOFF_YYYYMMDD
                              ,A.DIVISION_ID
                              ,A.PROJECT_CODE
                              ,A.SCM_SITE_ID
                              ,A.PLANT_SITE_ID
                              ,A.ITEM_ID
                              ,A.INCOTERMS
                              ,A.DOM_EXP
                              ,A.FCST_TYPE
                              ,A.CURRENCY
                              ,A.COMPANY_ID
                              ,A.YYYYMMDD
                              ,SUM(A.QTY) QTY
                              ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        FROM   GT_GDPS_RAW_DATA A
                        WHERE  YYYYMMDD >= V_START_YYYYMMDD
                        AND    YYYYMMDD < CASE
                                   WHEN VERSION_NO = 'CURRENT' THEN
                                    P_NOW_YYYYMMDD
                                   ELSE
                                    TO_CHAR(FN_NEXT_DAY(CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
                               END
                        AND    A.MEASURE = 'SalesAmt_KRW'
                        GROUP  BY A.VERSION_NO
                                 ,A.CUTOFF_YYYYMMDD
                                 ,A.DIVISION_ID
                                 ,A.PROJECT_CODE
                                 ,A.SCM_SITE_ID
                                 ,A.PLANT_SITE_ID
                                 ,A.ITEM_ID
                                 ,A.INCOTERMS
                                 ,A.DOM_EXP
                                 ,A.FCST_TYPE
                                 ,A.CURRENCY
                                 ,A.COMPANY_ID
                                 ,A.YYYYMMDD
                                 ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        ) B
                ON     A.VERSION_NO = B.VERSION_NO
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.PROJECT_CODE = B.PROJECT_CODE
                AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                AND    A.ITEM_ID = B.ITEM_ID
                AND    A.INCOTERMS = B.INCOTERMS
                AND    A.DOM_EXP = B.DOM_EXP
                AND    A.FCST_TYPE = B.FCST_TYPE
                AND    A.CURRENCY = B.CURRENCY
                AND    A.YYYYMMDD = B.YYYYMMDD
                AND    NVL(A.COMPANY_ID, '@#@#@#') = NVL(B.COMPANY_ID, '@#@#@#')
                AND    A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID; --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
        
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('E6--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        -- 계획구간 PRICE 처리
        SELECT COUNT(1) INTO V_CNT_7 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE IN ('KRW', 'LOC', 'USD');
        IF V_CNT_7 > 0 THEN
            INSERT INTO GT_GDPS_RAW_DATA
                (VERSION_NO
                ,CUTOFF_YYYYMMDD
                ,DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,TEXT
                ,INCOTERMS
                ,DOM_EXP
                ,FCST_TYPE
                ,CURRENCY
                ,COMPANY_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY
                ,PLAN_RESULT
                ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                 )
                SELECT A.VERSION_NO
                      ,A.CUTOFF_YYYYMMDD
                      ,A.DIVISION_ID
                      ,A.PROJECT_CODE
                      ,A.SCM_SITE_ID
                      ,A.PLANT_SITE_ID
                      ,A.ITEM_ID
                      ,A.TEXT
                      ,A.INCOTERMS
                      ,A.DOM_EXP
                      ,A.FCST_TYPE
                      ,A.CURRENCY
                      ,A.COMPANY_ID
                      ,C.MEASURE
                      ,A.YYYYMMDD
                      ,C.PRICE
                      ,'P'
                      ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                FROM   (SELECT DISTINCT A.VERSION_NO
                                       ,A.CUTOFF_YYYYMMDD
                                       ,A.DIVISION_ID
                                       ,A.PROJECT_CODE
                                       ,A.SCM_SITE_ID
                                       ,A.PLANT_SITE_ID
                                       ,A.ITEM_ID
                                       ,A.TEXT
                                       ,A.INCOTERMS
                                       ,A.DOM_EXP
                                       ,A.FCST_TYPE
                                       ,A.CURRENCY
                                       ,A.COMPANY_ID
                                       ,A.YYYYMMDD
                                       ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                        FROM   GT_GDPS_RAW_DATA A
                        WHERE  A.YYYYMMDD >= P_NOW_YYYYMMDD
                        AND    A.YYYYMMDD <= P_TO_YYYYMMDD
                        AND    A.MEASURE IN ('RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW')) A
                JOIN   SCM_SYS_CALENDAR_M B
                ON     A.YYYYMMDD = B.BASIS_YYYYMMDD
                --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                JOIN   (SELECT CC.DIVISION_ID
                              ,CC.PROJECT_CODE
                              ,CC.SCM_SITE_ID
                              ,CC.PLANT_SITE_ID
                              ,CC.ITEM_ID
                              ,CC.INCOTERMS
                              ,CC.DOM_EXP
                              ,CC.FCST_TYPE
                              ,CC.YYYYMMDD
                              ,CC.MEASURE
                              ,CC.PRICE
                              ,'-' AS CELL_PROD_SITE_ID
                        FROM   SCM_MST_FUTURE_PRICE CC
                        WHERE  (CASE
                                   WHEN P_DIVISION_ID = '40' THEN
                                    1
                                   ELSE
                                    2
                               END) = 2
                        UNION ALL
                        SELECT CC.DIVISION_ID
                              ,CC.PROJECT_CODE
                              ,CC.SCM_SITE_ID
                              ,CC.PLANT_SITE_ID
                              ,CC.ITEM_ID
                              ,CC.INCOTERMS
                              ,CC.DOM_EXP
                              ,CC.FCST_TYPE
                              ,CC.YYYYMMDD
                              ,CC.MEASURE
                              ,CC.PRICE
                              ,CC.CELL_PROD_SITE_ID
                        FROM   DM_PLN_CFM_SELLING_PRICE CC
                        WHERE  (CASE
                                   WHEN P_DIVISION_ID = '40' THEN
                                    1
                                   ELSE
                                    2
                               END) = 1) C
                ON     A.DIVISION_ID = C.DIVISION_ID
                AND    A.PROJECT_CODE = C.PROJECT_CODE
                AND    A.SCM_SITE_ID = C.SCM_SITE_ID
                AND    A.PLANT_SITE_ID = C.PLANT_SITE_ID
                AND    A.ITEM_ID = C.ITEM_ID
                AND    A.INCOTERMS = C.INCOTERMS
                AND    A.DOM_EXP = C.DOM_EXP
                AND    A.FCST_TYPE = C.FCST_TYPE
                AND    B.BASIS_START_DATE = C.YYYYMMDD
                AND    C.YYYYMMDD <= P_TO_YYYYMMDD
                AND    A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                --JOIN SCM_MST_FUTURE_PRICE C   ON A.DIVISION_ID        = C.DIVISION_ID
                --                                      AND A.PROJECT_CODE      = C.PROJECT_CODE
                --                                      AND A.SCM_SITE_ID       = C.SCM_SITE_ID
                --                                      AND A.PLANT_SITE_ID     = C.PLANT_SITE_ID
                --                                      AND A.ITEM_ID           = C.ITEM_ID
                --                                      AND A.INCOTERMS         = C.INCOTERMS
                --                                      AND A.DOM_EXP           = C.DOM_EXP
                --                                      AND A.FCST_TYPE         = C.FCST_TYPE
                --                                      AND B.basis_start_date  = C.YYYYMMDD
                --                                      AND C.YYYYMMDD          <= p_to_yyyymmdd
                JOIN   GT_GDPS_SELECT_MEASURE D
                ON     C.MEASURE = D.MEASURE;
        
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('E7--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        DBMS_OUTPUT.PUT_LINE('J--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        -- ---------------------------------------------------------------------------------------
        --  필요없는 메저 삭제
        -- ---------------------------------------------------------------------------------------
        DELETE FROM GT_GDPS_RAW_DATA A
        WHERE  EXISTS (SELECT 1
                FROM   GT_GDPS_SELECT_MEASURE B
                WHERE  B.MEASURE = A.MEASURE
                AND    B.SYSTEM_ADD = 'Y');
    
        SELECT COUNT(1) INTO V_CNT_8 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL');
        IF V_CNT_8 > 0 THEN
        
            INSERT INTO GT_GDPS_RAW_DATA
                (VERSION_NO
                ,CUTOFF_YYYYMMDD
                ,DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,TEXT
                ,INCOTERMS
                ,DOM_EXP
                ,FCST_TYPE
                ,CURRENCY
                ,COMPANY_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY
                ,PLAN_RESULT
                ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                 )
                SELECT A.VERSION_NO
                      ,A.CUTOFF_YYYYMMDD
                      ,A.DIVISION_ID
                      ,A.PROJECT_CODE
                      ,A.SCM_SITE_ID
                      ,A.PLANT_SITE_ID
                      ,A.ITEM_ID
                      ,A.TEXT
                      ,A.INCOTERMS
                      ,A.DOM_EXP
                      ,A.FCST_TYPE
                      ,A.CURRENCY
                      ,A.COMPANY_ID
                      ,B.MEASURE_CALC
                      ,A.YYYYMMDD
                      ,CASE
                           WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR', 'RTF_RP_CAR', 'RTF_SYS_RP_CAR') THEN
                            CASE
                                WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN
                                 QTY / D.CELL_PER_CAR
                                WHEN INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN
                                 QTY / (D.CELL_PER_CAR / D.CELL_PER_MODULE)
                                WHEN INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0 THEN
                                 A.QTY
                                ELSE
                                 0
                            END
                           WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL', 'RTF_RP_CELL', 'RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
                            CASE
                                WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN
                                 A.QTY
                                WHEN (INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0) AND D.CELL_PER_MODULE > 0 THEN
                                 A.QTY * D.CELL_PER_MODULE
                                ELSE
                                 0
                            END
                           WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL', 'RTF_RP_CELL', 'RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN
                            A.QTY * C.CELL_QUANTITY
                           ELSE
                            0
                       END
                      ,A.PLAN_RESULT
                      ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                FROM   GT_GDPS_RAW_DATA A
                JOIN   (SELECT CASE
                                   WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN
                                    'MKT_FCST_RP'
                                   ELSE
                                    'RTF_SYS_RP'
                               END AS MEASURE_ORI
                              ,A.MEASURE MEASURE_CALC
                        FROM   GT_GDPS_SELECT_MEASURE A
                        WHERE  MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL')) B
                ON     A.MEASURE = B.MEASURE_ORI
                JOIN   GT_GDPS_DM_MST_ITEM_SINGLE_V C
                ON     A.ITEM_ID = C.ITEM_ID
                AND    A.DIVISION_ID = C.DIVISION_ID
                LEFT   OUTER JOIN GT_GDPS_SCM_MST_SITE_ITEM D
                ON     A.DIVISION_ID = D.DIVISION_ID
                AND    A.SCM_SITE_ID = D.SCM_SITE_ID
                AND    A.PROJECT_CODE = D.PROJECT_CODE
                AND    A.ITEM_ID = D.ITEM_ID
                WHERE  A.MEASURE IN ('MKT_FCST_RP', 'RTF_SYS_RP');
        
        END IF;
    
        -- [C20211130-000420]ESS영업관리팀 RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
        SELECT COUNT(1) INTO V_CNT_9 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE IN ('RTF_ENERGY');
        IF V_CNT_9 > 0 THEN
        
            INSERT INTO GT_GDPS_RAW_DATA
                (VERSION_NO
                ,CUTOFF_YYYYMMDD
                ,DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,TEXT
                ,INCOTERMS
                ,DOM_EXP
                ,FCST_TYPE
                ,CURRENCY
                ,COMPANY_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY
                ,PLAN_RESULT
                ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                 )
                SELECT A.VERSION_NO
                      ,A.CUTOFF_YYYYMMDD
                      ,A.DIVISION_ID
                      ,A.PROJECT_CODE
                      ,A.SCM_SITE_ID
                      ,A.PLANT_SITE_ID
                      ,A.ITEM_ID
                      ,A.TEXT
                      ,A.INCOTERMS
                      ,A.DOM_EXP
                      ,A.FCST_TYPE
                      ,A.CURRENCY
                      ,A.COMPANY_ID
                      ,B.MEASURE_CALC
                      ,A.YYYYMMDD
                      ,CASE
                           WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
                            CASE
                                WHEN REGEXP_LIKE(C.ENERGE, '^[0-9.]+$') THEN
                                 (A.QTY * C.ENERGE) / 1000
                            END
                           ELSE
                            0
                       END
                      ,A.PLAN_RESULT
                      ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                FROM   GT_GDPS_RAW_DATA A
                JOIN   (SELECT 'RTF' AS MEASURE_ORI, A.MEASURE MEASURE_CALC FROM GT_GDPS_SELECT_MEASURE A WHERE MEASURE IN ('RTF_ENERGY')) B
                ON     A.MEASURE = B.MEASURE_ORI
                JOIN   GT_GDPS_DM_MST_ITEM_SINGLE_V C
                ON     A.ITEM_ID = C.ITEM_ID
                AND    A.DIVISION_ID = C.DIVISION_ID
                LEFT   OUTER JOIN GT_GDPS_SCM_MST_SITE_ITEM D
                ON     A.DIVISION_ID = D.DIVISION_ID
                AND    A.SCM_SITE_ID = D.SCM_SITE_ID
                AND    A.PROJECT_CODE = D.PROJECT_CODE
                AND    A.ITEM_ID = D.ITEM_ID
                WHERE  A.MEASURE IN ('RTF');
        
        END IF;
    
        --[C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
        SELECT COUNT(1) INTO V_CNT_10 FROM GT_GDPS_SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_ENERGY';
        IF V_CNT_10 > 0 THEN
            INSERT INTO GT_GDPS_RAW_DATA
                (VERSION_NO
                ,CUTOFF_YYYYMMDD
                ,DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,TEXT
                ,INCOTERMS
                ,DOM_EXP
                ,FCST_TYPE
                ,CURRENCY
                ,COMPANY_ID
                ,MEASURE
                ,YYYYMMDD
                ,QTY
                ,PLAN_RESULT
                ,CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                 )
                SELECT A.VERSION_NO
                      ,A.CUTOFF_YYYYMMDD
                      ,A.DIVISION_ID
                      ,A.PROJECT_CODE
                      ,A.SCM_SITE_ID
                      ,A.PLANT_SITE_ID
                      ,A.ITEM_ID
                      ,A.TEXT
                      ,A.INCOTERMS
                      ,A.DOM_EXP
                      ,A.FCST_TYPE
                      ,A.CURRENCY
                      ,A.COMPANY_ID
                      ,B.MEASURE_CALC
                      ,A.YYYYMMDD
                      ,CASE
                           WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'MKT_FCST_RP' THEN
                            CASE
                                WHEN REGEXP_LIKE(C.ENERGE, '^[0-9.]+$') THEN
                                 (A.QTY * C.ENERGE) / 1000
                            END
                           ELSE
                            0
                       END
                      ,A.PLAN_RESULT
                      ,A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
                FROM   GT_GDPS_RAW_DATA A
                JOIN   (SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE MEASURE_CALC FROM GT_GDPS_SELECT_MEASURE A WHERE MEASURE IN ('MKT_FCST_ENERGY')) B
                ON     A.MEASURE = B.MEASURE_ORI
                JOIN   GT_GDPS_DM_MST_ITEM_SINGLE_V C
                ON     A.ITEM_ID = C.ITEM_ID
                AND    A.DIVISION_ID = C.DIVISION_ID
                WHERE  A.MEASURE = 'MKT_FCST_RP';
        
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('K--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        -- ---------------------------------------------------------------------------------------
        --  컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
        -- ---------------------------------------------------------------------------------------
        -- 컬럼리스트 생성
        BEGIN
            V_PV_LIST     := NULL;
            V_PV_COL_LIST := NULL;
        
            SELECT RTRIM(XMLAGG(XMLELEMENT(E, COLUMN_NAME || ',') ORDER BY SORT_ORDER_NO).EXTRACT('//text()').GETCLOBVAL(), ',')
                  ,RTRIM(XMLAGG(XMLELEMENT(E, PV_NAME || ',') ORDER BY SORT_ORDER_NO).EXTRACT('//text()').GETCLOBVAL(), ',')
            INTO   V_PV_COL_LIST, V_PV_LIST
            FROM   (SELECT 'D_' || A.BASIS_YYYYMMDD || ' AS D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
                          ,'D_' || A.BASIS_YYYYMMDD AS PV_NAME
                          ,A.BASIS_YYYYMMDD || '_' || TO_CHAR(31) AS SORT_ORDER_NO
                    FROM   SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                    AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                    AND    P_BUCKET = 'DAILY'
                    UNION ALL
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
                          ,'W_' || A.BASIS_YYYYMM || A.ISO_WEEK
                          ,MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(21)
                    FROM   SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                    AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                    GROUP  BY A.BASIS_YYYYMM, A.ISO_WEEK
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM || ' AS M_' || A.BASIS_YYYYMM, 'M_' || A.BASIS_YYYYMM, MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(1)
                    FROM   SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                    AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                    GROUP  BY A.BASIS_YYYYMM);
        END;
    
        -- PIVOT IN용 변환: 'value' AS value 형식
        V_PIVOT_IN := NULL;
        FOR R IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(V_PV_LIST, ','))) LOOP
            IF V_PIVOT_IN IS NOT NULL THEN
                V_PIVOT_IN := V_PIVOT_IN || ',';
            END IF;
            V_PIVOT_IN := V_PIVOT_IN || '''' || R.VALUE || ''' AS ' || R.VALUE;
        END LOOP;
    
        /*--debuging
        DBMS_OUTPUT.PUT_LINE('L2;  ----------------------------------------------' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        DBMS_OUTPUT.PUT_LINE('V_PV_LIST:' || V_PV_LIST);
        DBMS_OUTPUT.PUT_LINE('L2;  ----------------------------------------------' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        */
        
        /* 20240518 KCW3408 속도개선_템프사용 시작 */
        INSERT INTO GT_GDPS_SCM_MST_SITE
            SELECT B.SCM_SITE_ID
                  ,B.DIVISION_ID
                   --, B.DEPT_ID
                  ,NULL DEPT_ID
                  ,K.SOLDTO_CODE
                  ,B.VMI_YN
                  ,B.END_CUSTOMER
                  ,H.CITY_NAME
                  ,J.COUNTRY_NAME
                  ,L.SHIPTO_DESCRIPTION
                  ,L.SOLDTO_DESCRIPTION
            FROM   SCM_MST_SITE B
            LEFT   OUTER JOIN SCM_MST_SITE_CUSTOMER K
            ON     B.DIVISION_ID = K.DIVISION_ID
            AND    B.SCM_SITE_ID = K.SCM_SITE_ID
            AND    K.REP_YN = 'Y'
            LEFT   OUTER JOIN SCM_MST_CITY H
            ON     B.CITY = H.CITY
            LEFT   OUTER JOIN SCM_MST_COUNTRY J
            ON     B.COUNTRY = J.COUNTRY
            LEFT   OUTER JOIN SCM_MST_CUSTOMER L
            ON     K.DIVISION_ID = L.DIVISION_ID
            AND    K.SHIPTO_CODE = L.SHIPTO_CODE
            AND    K.SOLDTO_CODE = L.SOLDTO_CODE;
    
        /* 20240518 KCW3408 속도개선_템프사용 종료 */
    
        -----   일반 컬럼 -----------------------------------------------------------------------------------------------------------
        V_COLUMN_NAME := NULL;
        V_COLUMN      := NULL;
        V_ORDERBY     := NULL;
    
        SELECT COUNT(*)
        INTO   I_COUNT
        FROM   SCM_MST_TITLESET_USER U
        WHERE  1 = 1
        AND    U.PROGRAM_ID = P_PROGRAM_ID
        AND    U.SHEET_NAME = P_SHEET_NAME
        AND    U.USER_ID = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';
    
        --  print i_Count
        IF I_COUNT = 0 THEN
            SELECT RTRIM(XMLAGG(XMLELEMENT(E, COLUMN_NAME || ',') ORDER BY SORT_ORDER_NO).EXTRACT('//text()').GETCLOBVAL(), ',')
                  ,RTRIM(XMLAGG(XMLELEMENT(E, COLUMN_NAME || ' ' || DATA_SORT_METHOD_CODE || ',') ORDER BY SORT_ORDER_NO).EXTRACT('//text()').GETCLOBVAL()
                        ,',')
            INTO   V_COLLIST, V_ORDERLIST
            FROM   (
                    -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
                    SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                    FROM   SCM_MST_SHEET_COLUMNS C
                    WHERE  1 = 1
                    AND    C.PROGRAM_ID = P_PROGRAM_ID
                    AND    C.SHEET_NAME = P_SHEET_NAME
                    AND    (C.DEFAULT_FLAG = 'Y' OR (C.VISIBLE_FLAG = '' AND C.DEFAULT_FLAG =' ' AND C.VALID_YN = 'Y') 
                                                 OR (C.VISIBLE_FLAG = '' AND C.DEFAULT_FLAG ='-' AND C.VALID_YN = 'Y')) )TBCOLLIST;
        ELSE
            SELECT RTRIM(XMLAGG(XMLELEMENT(E, COLUMN_NAME || ',') ORDER BY SORT_ORDER_NO).EXTRACT('//text()').GETCLOBVAL(), ',')
                  ,RTRIM(XMLAGG(XMLELEMENT(E, COLUMN_NAME || ' ' || DATA_SORT_METHOD_CODE || ',') ORDER BY SORT_ORDER_NO).EXTRACT('//text()').GETCLOBVAL()
                        ,',')
            INTO   V_COLLIST, V_ORDERLIST
            FROM   (
                    -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
                    SELECT U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
                    FROM   SCM_MST_TITLESET_USER U
                    INNER  JOIN SCM_MST_SHEET_COLUMNS C
                    ON     U.PROGRAM_ID = C.PROGRAM_ID
                    AND    U.SHEET_NAME = C.SHEET_NAME
                    AND    U.COLUMN_NAME = C.COLUMN_NAME
                    AND    U.PROGRAM_ID = P_PROGRAM_ID
                    AND    U.SHEET_NAME = P_SHEET_NAME
                    AND    U.USER_ID = P_CREATED_BY
                    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                    -- ------
                    UNION ALL
                    -- ------
                    /* 2024/05/17   kcw3408     이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
                    SELECT CASE
                                WHEN C.COLUMN_NAME = 'GROUP_ID' THEN
                                 NVL(U.SORT_ORDER_NO, 85) - 0.5
                                ELSE
                                 C.SORT_ORDER_NO
                            END AS SORT_ORDER_NO
                           ,C.COLUMN_NAME
                           ,C.DATA_SORT_METHOD_CODE
                    FROM   SCM_MST_SHEET_COLUMNS C
                    LEFT   OUTER JOIN SCM_MST_TITLESET_USER U
                    ON     U.PROGRAM_ID = C.PROGRAM_ID
                    AND    U.SHEET_NAME = C.SHEET_NAME
                    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                    AND    U.COLUMN_NAME IN ('ITEM_ID')
                    AND    U.USER_ID = P_CREATED_BY
                    WHERE  1 = 1
                    AND    C.PROGRAM_ID = P_PROGRAM_ID
                    AND    C.SHEET_NAME = P_SHEET_NAME
                    AND    C.VISIBLE_FLAG = ''
                    AND    (C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ' )
                    AND    C.VALID_YN = 'Y') TBCOLLIST
            WHERE  ROWNUM <= 100;
        END IF;
    
        V_COLLIST   := REPLACE(V_COLLIST, 'VERSION_NO', 'VERSION_SORT,VERSION_NO');
        V_ORDERLIST := REPLACE(V_ORDERLIST, 'VERSION_NO', 'VERSION_SORT DESC,VERSION_NO');
        V_ORDERLIST := REPLACE(V_ORDERLIST, 'MEASURE', 'SORT_ORDER_NO,MEASURE');
    
        --  컬럼생성 끝  ----------------------------------------------------------------
    
        /*---------------------------------------------------------------   SHIPMENT 컬럼 시작 ----------------------------------------------------------------------*/
        --PJ20200138 Shipment Site 임시테이블 추가
        IF V_COLLIST LIKE '%SHIPMENT_SITE%' AND P_DIVISION_ID = '82' THEN
            SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
            INTO   V_SHIP_DIVISION_ID, V_SHIP_PLAN_START_YYYYMMDD, V_SHIP_PLAN_TYPE, V_SHIP_PPLAN_SEQ, V_SHIP_PPLAN_ID, V_SHIP_PMODELING_ID
            FROM   (SELECT *
                    FROM   (SELECT DIVISION_ID
                                  ,PLAN_START_YYYYMMDD
                                  ,PLAN_TYPE
                                  ,PLAN_SEQ
                                  ,PLAN_ID
                                  ,MODELING_ID
                                  ,ROW_NUMBER() OVER(ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC) ROW_NUM
                            FROM   SCP_PLAN_VERSION_V
                            WHERE  1 = 1
                            AND    DIVISION_ID = '82'
                            AND    PLAN_CYCLE = 'WEEKLY'
                            AND    PLAN_TYPE = 'FN'
                            AND    PLAN_START_YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-60), 'YYYYMMDD')) A) PV
            WHERE  PV.ROW_NUM = 1;
        
            -- 2020.11.26 hwi1993   FROM_SITE 를 MAX 값으로 변경 ( 안그러면 모델의 생산지를 변경할 경우 중복오류남 )
            INSERT INTO GT_GDPS_SHIPMENT_SITE_ROW
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE SCM_SITE_ID, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE
                --[C20201202-000394]ESS Shipment Site(생산지) 중복 콤마(,) 처리
                FROM   SCP_ANL_SHIPMENT_PLAN_FG A
                INNER  JOIN SCM_SYS_CALENDAR_M O
                ON     A.YYYYMMDD = O.BASIS_YYYYMMDD
                LEFT   OUTER JOIN (SELECT DIVISION_ID
                                         ,PLAN_START_YYYYMMDD
                                         ,ITEM_ID
                                         ,FROM_SITE
                                         ,TO_SITE
                                         ,MAX(REPLACE(SUBSTR(ENG_DEMAND_ID, INSTR(ENG_DEMAND_ID, '::', 1, 4) + 2, 3), ':', '')) FCST_TYPE
                                   FROM   SCP_ANL_PROBLEM_REPORT_PEGGING
                                   WHERE  DIVISION_ID = V_SHIP_DIVISION_ID
                                   AND    PLAN_START_YYYYMMDD = V_SHIP_PLAN_START_YYYYMMDD
                                   AND    PLAN_TYPE = V_SHIP_PLAN_TYPE
                                   AND    SEQ = V_SHIP_PPLAN_SEQ
                                   AND    PEGGING_OPERATION_CODE IN ('CSHIP', 'PSHIP')
                                   GROUP  BY DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE) FC
                ON     A.ITEM_ID = FC.ITEM_ID
                AND    A.FROM_SITE = FC.FROM_SITE
                AND    A.TO_SITE = FC.TO_SITE
                WHERE  A.DIVISION_ID = V_SHIP_DIVISION_ID
                AND    A.PLAN_START_YYYYMMDD = V_SHIP_PLAN_START_YYYYMMDD
                AND    A.PLAN_TYPE = V_SHIP_PLAN_TYPE
                AND    A.SEQ = V_SHIP_PPLAN_SEQ
                AND    A.MEASURE = 'SHIP_PLAN'
                AND    A.QTY > 0
                GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE;
        
            --[C20201202-000394]ESS Shipment Site(생산지) 중복 중복 콤마(,) 처리
            INSERT INTO GT_GDPS_SHIPMENT_SITE
                (DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE, SHIPMENT_SITE)
                SELECT DIVISION_ID
                      ,PROJECT_CODE
                      ,ITEM_ID
                      ,SCM_SITE_ID
                      ,INCOTERMS
                      ,FCST_TYPE
                      ,NVL(1, NULL) || CASE
                           WHEN 2 IS NULL THEN
                            ''
                           ELSE
                            ',' || 2
                       END || CASE
                           WHEN 3 IS NULL THEN
                            ''
                           ELSE
                            ',' || 3
                       END || CASE
                           WHEN 4 IS NULL THEN
                            ''
                           ELSE
                            ',' || 4
                       END || CASE
                           WHEN 5 IS NULL THEN
                            ''
                           ELSE
                            ',' || 5
                       END AS SHIPMENT_SITE
                FROM   (SELECT A.DIVISION_ID
                              ,A.PROJECT_CODE
                              ,A.ITEM_ID
                              ,A.SCM_SITE_ID
                              ,A.INCOTERMS
                              ,A.FCST_TYPE
                              ,A.FROM_SITE
                              ,ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS, A.FCST_TYPE ORDER BY A.FROM_SITE) ROW_NUM
                        FROM   GT_GDPS_SHIPMENT_SITE_ROW A) A
                PIVOT(MAX(FROM_SITE)
                FOR    ROW_NUM IN(1, 2, 3, 4, 5)) PVT;
        END IF;
    
        /*---------------------------------------------------------------   SHIPMENT 컬럼 끝 ----------------------------------------------------------------------*/
        --select V_PV_COL_LIST,   V_PV_LIST,   v_orderby,   v_orderby
        /*
                    , FN_GET_DM_SALES_PLAN_WATERFALL_QTY2(A.MEASURE, NVL(D.ITEM_CLASS_NAME,''''), NVL(A.QTY,0), NVL(C.CELL_PER_CAR,0), NVL(C.CELL_PER_MODULE,0)
                                , ''' || p_cell_yn || '''', NVL(D.FORECAST_INFO_CELL_PACK_COUNT, 0), ''' || P_DIVISION_ID || '''', NVL(D.FORECAST_INFO_BIZ_TYPE, '''')) QTY
        */
        --SELECT * FROM GT_GDPS_RAW_DATA
        --select version_no, measure, count(*) from GT_GDPS_RAW_DATA
        --group by version_no, measure
        --order by 1, 2
    
        -- CTE 에서 사용할 SELECT COLUMN 정리
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'VERSION_NO', 'A.VERSION_NO', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'DIVISION_ID', 'A.DIVISION_ID', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'PROJECT_CODE', 'A.PROJECT_CODE', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'SCM_SITE_ID', 'A.SCM_SITE_ID', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'PLANT_SITE_ID', 'A.PLANT_SITE_ID', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'GROUP_ID', 'NVL(I.GROUP_ID,'''') GROUP_ID', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'ITEM_ID', 'A.ITEM_ID', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'TEXT', 'A.TEXT', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'INCOTERMS', 'A.INCOTERMS', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'DOM_EXP', 'A.DOM_EXP', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'FCST_TYPE', 'A.FCST_TYPE', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'MEASURE', 'A.MEASURE', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'END_CUSTOMER40', 'A.PROJECT_CODE AS END_CUSTOMER40', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP
        VALUES
            ('A', 'INTERNAL_YN', 'CASE WHEN LENGTH(A.SCM_SITE_ID) > 2 AND LENGTH(A.SCM_SITE_ID) < 6  THEN ''Y'' ELSE '''' END AS INTERNAL_YN', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'YYYYMMDD', 'A.YYYYMMDD', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('A', 'QTY', 'A.QTY', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP
        VALUES
            ('A', 'VERSION_SORT', 'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('B', 'VMI_YN', 'B.VMI_YN', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('B', 'END_CUSTOMER', 'B.END_CUSTOMER', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('AC', 'CURRENCY', 'CASE WHEN A.CURRENCY IS NOT NULL THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY', 1);
    
        --[PJ2024-50461] Team Mapping------------------------------------
        --INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID', 1)
        --INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'C.DEPT_ID', 1)
        --[PJ2024-50461] Team Mapping------------------------------------
        --[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1))
        INSERT INTO GT_GDPS_COLUMN_SETUP
        VALUES
            ('ABC'
            ,'DEPT_ID'
            ,'CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID'
            ,1);
        --[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1))
        --[PJ2024-50461] Team Mapping------------------------------------
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'APPLICATION', 'C.APPLICATION', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'CUST_GROUP', 'C.CUST_GROUP', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'OWNER', 'C.OWNER_NAME AS OWNER', 1);
        /* [E20230630-001379] 계획구간은 SSPM.ROUTE , 실적구간은 ERP.ROUTE(LGS_ROUTE_NAME) */
        --INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ( 'C', 'ROUTE', 'C.ROUTE', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP
        VALUES
            ('C'
            ,'ROUTE'
            ,'CASE WHEN A.DIVISION_ID = ''40'' THEN FN_GET_ROUTE_INFO (A.PLAN_RESULT, A.DIVISION_ID,  A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE , A.INCOTERMS, A.CURRENCY, ''' ||
             P_FROM_YYYYMMDD || ''' , ''' || P_NOW_YYYYMMDD || ''', ''' || P_TO_YYYYMMDD || ''') ELSE C.ROUTE END AS ROUTE'
            ,1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'CUST_GROUP_DTL', 'C.CUST_GROUP_DTL', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'CELL_PER_CAR', 'C.CELL_PER_CAR', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'CELL_PER_MODULE', 'C.CELL_PER_MODULE', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP
        VALUES
            ('AC', 'COMPANY_ID', 'CASE WHEN NVL(A.COMPANY_ID, '''') = '''' OR A.COMPANY_ID IS NULL THEN C.SALES_COMPANY ELSE A.COMPANY_ID END AS COMPANY_ID', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP
        VALUES
            ('C', 'MODULE_PER_CAR', 'CASE WHEN C.CELL_PER_MODULE  <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'DMS_SALES', 'NVL(C.ATTRIBUTE1,'''') DMS_SALES', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'DMS_CUSTOMER', 'NVL(C.ATTRIBUTE2,'''') DMS_CUSTOMER', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'FORECAST_INFO_CELL_MODEL', 'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'PRIORITY', 'C.ATTRIBUTE7 AS PRIORITY', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'KWH_CELL', 'C.ATTRIBUTE8 AS KWH_CELL', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'REPORT_GROUP6', 'NVL(C.REPORT_GROUP6,'''') REPORT_GROUP6', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP
        VALUES
            ('AC'
            ,'KWH_MODULE'
            ,'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' THEN TO_NUMBER((C.CELL_PER_MODULE * C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE'
            ,1);
        INSERT INTO GT_GDPS_COLUMN_SETUP
        VALUES
            ('AC'
            ,'KWH_PACK'
            ,'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' THEN TO_NUMBER((C.CELL_PER_CAR * C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK'
            ,1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'BIZ_TYPE_NAME40', 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'ENERGE', 'D.ENERGE', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'CELL_QUANTITY', 'D.CELL_QUANTITY', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'ITEM_CLASS_NAME', 'NVL(D.ITEM_CLASS_NAME, '''') ITEM_CLASS_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'ITEM_NAME', 'NVL(D.ITEM_NAME, '''') ITEM_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'ITEM_TYPE', 'NVL(D.ITEM_TYPE, '''') ITEM_TYPE', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'NICK_NAME', 'NVL(D.NICK_NAME, '''') NICK_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'MIN_CAPACITY', 'D.MIN_CAPACITY', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'FORECAST_INFO_ALL', 'D.FORECAST_INFO_SPEC + D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'FORECAST_INFO_SPEC', 'D.FORECAST_INFO_SPEC', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'FORECAST_INFOR_VERSION', 'D.FORECAST_INFOR_VERSION', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('D', 'MDM_PROJECT_NAME', 'D.MDM_PROJECT_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('E', 'CELL_TYPE', 'E.SEGMENT2 AS CELL_TYPE', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('F', 'CELL_MODEL_NICK_NAME', 'NVL(F.NICK_NAME,'''') CELL_MODEL_NICK_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('G', 'BIZ_TYPE_NAME', 'G.BIZ_TYPE AS BIZ_TYPE_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('G', 'PROJECT_NAME', 'G.PROJECT_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('G', 'PROJECT_OWNER', 'G.PROJECT_OWNER', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('G', 'PROJECT_STATUS', 'G.PROJECT_STATUS', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('G', 'PRODUCT_GROUP_NAME', 'G.PRODUCT_GROUP_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('B', 'CITY_NAME', 'B.CITY_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('B', 'COUNTRY_NAME', 'B.COUNTRY_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('B', 'SHIPTO_DESCRIPTION', 'B.SHIPTO_DESCRIPTION', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('M', 'SORT_ORDER_NO', 'M.SORT_ORDER_NO', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'CELL_NAME', 'C.ATTRIBUTE9 AS CELL_NAME', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'DISTRIBUTION_CHANNEL', 'B.ATTRIBUTE3 AS DISTRIBUTION_CHANNEL', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'SALES_COMPANY', 'C.SALES_COMPANY', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('C', 'SALES_PLANT', 'C.SALES_PLANT', 1);
        INSERT INTO GT_GDPS_COLUMN_SETUP VALUES ('', 'SHIPMENT_SITE', 'N.SHIPMENT_SITE', 1);
        -- GT_GDPS_T: 컬럼순서 임시 테이블 적재
        INSERT INTO GT_GDPS_T
            SELECT B.COLUMN_STRING, ROW_NUMBER() OVER(ORDER BY B.SORT_KEY) SEQ
            FROM   TABLE(FN_SPLITSTRING(V_COLLIST, ',')) A
            JOIN   GT_GDPS_COLUMN_SETUP B
            ON     REPLACE(REPLACE(A.VALUE, '[', ''), ']', '') = B.COLUMN_NAME;
    
        SELECT COUNT(*) INTO V_CNT FROM GT_GDPS_T;
    
        /*--debuging
        FOR C1 IN (SELECT * FROM GT_GDPS_T) LOOP
            DBMS_OUTPUT.PUT_LINE('column_string :' || C1.COLUMN_STRING || ',' || 'SEQ :' || C1.SEQ);
        END LOOP;*/
    
        IF V_CNT > 0 THEN
        
            -- V_SQL_SELECT, V_SQL_GROUPBY 생성 (FOR LOOP)
            FOR REC IN (SELECT COLUMN_STRING, SEQ FROM GT_GDPS_T ORDER BY SEQ) LOOP
                IF V_SQL_SELECT IS NOT NULL THEN
                    V_SQL_SELECT  := V_SQL_SELECT || ',';
                    V_SQL_GROUPBY := V_SQL_GROUPBY || ',';
                END IF;
            
                V_SQL_SELECT := V_SQL_SELECT || REC.COLUMN_STRING;
            
                V_SQL_GROUPBY := V_SQL_GROUPBY || CASE
                                     WHEN INSTR(REC.COLUMN_STRING, ' AS ') > 0 THEN
                                      SUBSTR(REC.COLUMN_STRING, 1, INSTR(REC.COLUMN_STRING, ' AS ') - 1)
                                     ELSE
                                      REC.COLUMN_STRING
                                 END;
            END LOOP;
        
            --SELECT V_SQL_GROUPBY
            --SELECT * FROM GT_GDPS_RAW_DATA
            --WHERE PROJECT_CODE = 'G-21-222' AND SCM_SITE_ID = 'Terra-Gen_US_EWA' AND ITEM_ID = 'EEA00334AB'
            --AND YYYYMMDD LIKE '202110%'
            -- [C20220318-000248] GSCM Sales Plan 및 Sales Monitoring의 Unit Price 컬럼값 표기 오류 수정 요청의 건(group by 제거)
        
            -- ====================================================================
            -- PTT CTAS: ORA$PTT_GDPS_WF (동적 피벗 컬럼 포함)
            -- ====================================================================
            -- PTT 생성 전 COMMIT (GTT 변경분 확정) --ORA-32462 방지
            COMMIT; --ORA-32462 : can not use an object modified in current transaction 
            --
            -- MEASURE가 V_SQL_SELECT에 없으면 고정 컬럼으로 추가
            IF INSTR(UPPER(V_SQL_SELECT), 'MEASURE') = 0 THEN
                V_MEASURE_COL := ', A.MEASURE';
            ELSE
                V_MEASURE_COL := '';
            END IF;
        
            V_PTT_SQL := 'CREATE PRIVATE TEMPORARY TABLE ORA$PTT_GDPS_WF ON COMMIT PRESERVE DEFINITION AS
        SELECT
            A.QTY AS QTY
            ' || V_MEASURE_COL || '
            , CASE WHEN ''' || P_BUCKET || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
            , M.SORT_ORDER_NO
            , CASE WHEN D.ITEM_ID IS NULL THEN ''N_''
                    WHEN NVL(C.SALES_PLAN_ADJUST_YN,'''')='''' THEN ''N_''
                    ELSE ''Y_''
                    END
            || CASE WHEN ''' || V_DEPT_LIST || ''' LIKE ''%''|| C.DEPT_ID ||''%'' THEN ''Y''
                    WHEN ''' || V_GROUP_ID || ''' =''ADMIN'' THEN ''Y''
                ELSE ''''
                END AS SALES_PLAN_ADJUST_YN
            , CAL.BASIS_YYYYMM, CAL.ISO_WEEK
            , CASE WHEN LENGTH(NVL(EE.ATTRIBUTE1,'''')) = 0 THEN ''Common'' ELSE EE.ATTRIBUTE1 END AS CELL_PROD_SITE_ID
            ';
            IF V_SQL_SELECT IS NOT NULL THEN
                V_PTT_SQL := V_PTT_SQL || '
            , ' || V_SQL_SELECT || '
            ';
            END IF;
            V_PTT_SQL := V_PTT_SQL || '
            , TEI.EDIT_YN
        FROM GT_GDPS_RAW_DATA A
        INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''' || P_USER_ID || ''', ''' || P_MENU_ID || ''')) TEI
        ON     TEI.UNIT_ID = A.DIVISION_ID
        LEFT OUTER JOIN GT_GDPS_SCM_MST_SITE B ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
        LEFT OUTER JOIN GT_GDPS_SCM_MST_SITE_ITEM C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
        LEFT OUTER JOIN GT_GDPS_DM_MST_ITEM_SINGLE_V D ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
        LEFT OUTER JOIN GT_GDPS_DM_MST_ITEM_SINGLE_V F ON D.DIVISION_ID = F.DIVISION_ID AND NVL(D.FORECAST_INFO_CELL_MODEL,'''') = F.ITEM_ID
        LEFT OUTER JOIN SCM_MST_PROJECT G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
        LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL I ON A.DIVISION_ID = I.DIVISION_ID AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
        JOIN GT_GDPS_SELECT_MEASURE M ON A.MEASURE = M.MEASURE
        LEFT OUTER JOIN GT_GDPS_SHIPMENT_SITE N ON A.DIVISION_ID = N.DIVISION_ID AND A.PROJECT_CODE = N.PROJECT_CODE AND A.SCM_SITE_ID = N.SCM_SITE_ID
                                                    AND A.ITEM_ID = N.ITEM_ID AND A.FCST_TYPE = N.FCST_TYPE AND A.INCOTERMS = N.INCOTERMS
        JOIN SCM_SYS_CALENDAR_M CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD
             AND CAL.BASIS_DATE BETWEEN TO_DATE(''' || P_FROM_YYYYMMDD || ''', ''YYYYMMDD'') AND TO_DATE(''' || P_TO_YYYYMMDD ||
                         ''', ''YYYYMMDD'') + 1
         -- [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL EE
        ON  EE.LOOKUP_TYPE = ''SP_CELL_PROD_SITE''
        AND EE.SEGMENT1 = CASE WHEN LENGTH(NVL(A.CELL_PROD_SITE_ID,'''')) = 0 THEN ''-'' ELSE A.CELL_PROD_SITE_ID END
        AND EE.SEGMENT2 = ''-''
        AND EE.SEGMENT3 = ''-''
        AND EE.SEGMENT4 = ''-''
        AND EE.SEGMENT5 = ''-''
        AND EE.VALID_YN = ''Y''';
        
            -- PTT DROP 후 생성
            BEGIN
                EXECUTE IMMEDIATE 'DROP TABLE ORA$PTT_GDPS_WF';
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;
            EXECUTE IMMEDIATE V_PTT_SQL;
        
            DBMS_OUTPUT.PUT_LINE('L;  --' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        
            --PKG_DMF0007.P_PR_PRINT_CLOB(P_TITLE => '1 V_COLLIST', P_TEXT => V_COLLIST);
        
            -- PIVOT 내부 쿼리용: YYYYMMDD, QTY 제거
            V_COL_PIVOT := V_COLLIST;
            V_COL_PIVOT := REPLACE(V_COL_PIVOT, ',YYYYMMDD', '');
            V_COL_PIVOT := REPLACE(V_COL_PIVOT, 'YYYYMMDD,', '');
            V_COL_PIVOT := REPLACE(V_COL_PIVOT, ',QTY', '');
            V_COL_PIVOT := REPLACE(V_COL_PIVOT, 'QTY,', '');
        
            --PKG_DMF0007.P_PR_PRINT_CLOB(P_TITLE => '2 V_COL_PIVOT', P_TEXT => V_COL_PIVOT);
        
            -- ====================================================================
            -- 메인 동적SQL: PTT에서 PIVOT 조회
            -- ====================================================================
            V_SQL_TEXT := 'SELECT V_COLUMN
                    , SORT_ORDER_NO
                    , V_PV_COL_LIST
                    , EDIT_YN
                FROM ( ';
        
            IF P_BUCKET = 'DAILY' THEN
                V_SQL_TEXT := V_SQL_TEXT || '
                SELECT V_COL_PIVOT, F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY, F.EDIT_YN
                FROM ORA$PTT_GDPS_WF F
                WHERE QTY <> 0
                UNION ALL ';
            END IF;
        
            V_SQL_TEXT := V_SQL_TEXT || '
                SELECT V_COL_PIVOT, F.SORT_ORDER_NO, ''W_'' || F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD
                    , CASE WHEN MEASURE IN (''KRW'',''USD'',''LOC'') THEN AVG(QTY) ELSE SUM(QTY) END AS QTY, MAX(F.EDIT_YN) EDIT_YN
                FROM ORA$PTT_GDPS_WF F
                WHERE QTY <> 0
                GROUP BY V_COL_PIVOT, MEASURE, F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK

                UNION ALL
                SELECT V_COL_PIVOT, F.SORT_ORDER_NO, ''M_'' || F.BASIS_YYYYMM AS YYYYMMDD
                    , CASE WHEN MEASURE IN (''KRW'',''USD'',''LOC'') THEN AVG(QTY) ELSE SUM(QTY) END AS QTY, MAX(F.EDIT_YN) EDIT_YN
                FROM ORA$PTT_GDPS_WF F
                WHERE QTY <> 0
                GROUP BY V_COL_PIVOT, MEASURE, F.SORT_ORDER_NO, F.BASIS_YYYYMM

                ) F
            PIVOT (
                SUM(QTY) FOR YYYYMMDD IN ( V_PV_LIST )
            ) PVT
            ORDER BY v_orderby';
        
            DBMS_OUTPUT.PUT_LINE('L--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        
            --PKG_DMF0007.P_PR_PRINT_CLOB(P_TITLE => 'before V_SQL_TEXT', P_TEXT => V_SQL_TEXT);
            -- v_sql_text를 DBMS_OUTPUT으로 출력해서 중복 컬럼 확인
        
            --SELECT v_sql_text;
            -- Placeholder REPLACE (순서 중요: 긴 것 먼저)
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_COL_PIVOT', V_COL_PIVOT); -- 1. 내부: YYYYMMDD,QTY 제외
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_COLUMN', V_COLLIST); -- 2. 외부: 전체 컬럼
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_PV_COL_LIST', V_PV_COL_LIST); -- 3. SELECT절용 (긴 것 먼저)
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_PV_LIST', V_PIVOT_IN); -- 4. PIVOT IN용
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'V_OrderList', V_ORDERLIST); -- 5. ORDER BY
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'SQL_SELECT', V_SQL_SELECT); -- 6. PTT 컬럼
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'SQL_GROUPBY', V_SQL_GROUPBY); -- 7. GROUP BY
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_orderby', V_ORDERLIST); -- 8. 기존 호환        
        
            --PKG_DMF0007.P_PR_PRINT_CLOB(P_TITLE => 'V_SQL_TEXT', P_TEXT => V_SQL_TEXT);
            
            --select V_ColList, V_SQL_SELECT
            --EXECUTE IMMEDIATE V_SQL_TEXT;
            OPEN O_RC1 FOR V_SQL_TEXT;ELSE
            -- 빈 결과셋 반환 (컬럼 없이)
            OPEN O_RC1 FOR
                SELECT NULL FROM DUAL WHERE 1 = 0;
        END IF; -- v_cnt > 0
    
        OPEN O_RC2 FOR
            SELECT 'M_' || A.BASIS_YYYYMM AS THIS_YYYYMM
                  ,'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS THIS_YYYYMMWW
                  ,A.BASIS_DATE
                  ,'M_' || B.BASIS_YYYYMM AS PRE_YYYYMM
                  ,'W_' || B.BASIS_YYYYMM || B.ISO_WEEK AS PRE_YYYYMMWW
                  ,A.BASIS_YYYYMM
                  ,A.ISO_WEEK
            FROM   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD')) A
            JOIN   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE + (-7), 'YYYYMMDD')) B
            ON     1 = 1;
    
        --select * from GT_GDPS_SELECT_MEASURE
        -- xml확인할경우
        --SELECT CAST(v_sql_text AS TEXT)
        --/* TODO: FOR XML PATH --> LISTAGG 수동변환 */--,ROOT('x')
        --SELECT COUNT(*) FROM GT_GDPS_RAW_DATA
        --execute SP_executesql V_NSQL2
        DBMS_OUTPUT.PUT_LINE('Q--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        
        -- ---------------------------------------------------------------------------------------
        --                                                       Temp Table 존재 여부 체크 (BEGIN)
        -- ---------------------------------------------------------------------------------------
        --EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GDPS_COLUMN_SETUP';
        -- ---------------------------------------------------------------------------------------
        --                                                       Temp Table 존재 여부 체크 (END)
        -- ---------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('R--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
        COMMIT;
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0048_GET_DM_PLN_SALES_MONITORING;

END PKG_DMF0048;
/
