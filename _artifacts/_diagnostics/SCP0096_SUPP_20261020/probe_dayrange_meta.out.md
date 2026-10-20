## 조회 DB: To-Be Oracle (ZIOUI1 / SCM_MGR) [oracle] SCM_MGR@59.19.252.148:2521/ZIOUI1
## 조회시각: 2026-10-20 07:49:39

## 4) PKG_SCP0096 / PKG_COM0000 LAST_DDL
   ('PKG_COM0000', 'PACKAGE', 'VALID', '2026-10-09 13:38:30')
   ('PKG_COM0000', 'PACKAGE BODY', 'VALID', '2026-10-13 17:04:52')
   ('PKG_SCP0096', 'PACKAGE', 'VALID', '2026-10-19 22:53:27')
   ('PKG_SCP0096', 'PACKAGE BODY', 'VALID', '2026-10-19 22:53:27')

## 1) P_SCM0001_GET_SCP_MONTH_PERIOD 원문 (PKG_COM0000 BODY 발췌)
 2705: PROCEDURE P_SCM0001_GET_SCP_MONTH_PERIOD(
 2706:     P_DIVISION_ID   IN  VARCHAR2,
 2707:     P_PLAN_CYCLE    IN  VARCHAR2,
 2708:     P_FROM_DATE     IN  VARCHAR2,
 2709:     P_OFFSET_MONTH  IN  VARCHAR2,
 2710:     P_TIMEZONE      IN  VARCHAR2,
 2711:     O_RC1           OUT SYS_REFCURSOR,
 2712:     O_RESULT_CURSOR OUT SYS_REFCURSOR
 2713: )
 2714: /*
 2715:  * Program ID   : PKG_COM0000
 2716:  * Description  : P_SCM0001_GET_SCP_MONTH_PERIOD - PERIOD 기간조회 SCM_MST_PLAN 테이블에서 가져옴 (공용)
 2717:  *                주간 계획이 있으면 계획명 ~ 계획명+363일, 없으면 시작일 ~ 개월 수 뒤 일자의 직전 일요일
 2718:  *                결과 PERIOD = 'YYYYMMDD:YYYYMMDD' (조회 구간이 없으면 NULL)
 2719:  * Program History
 2720:  *===========================================================================================================
 2721:  *   Date       In Charge      Description
 2722:  *===========================================================================================================
 2723:  * 2026.09.17   AJS            AS-IS SCM0001_GET_SCP_MONTH_PERIOD 전환
 2724:  */
 2725: AS
 2726:     V_STEP          VARCHAR2(100 CHAR);
 2727:     V_DIVISION_ID   VARCHAR2(100 CHAR);
 2728:     V_PLAN_NAME     VARCHAR2(30 CHAR);
 2729:     V_CHK           NUMBER := 0;
 2730:     V_FROM_DATE     VARCHAR2(30 CHAR);
 2731:     V_FROM_LOW      VARCHAR2(31 CHAR);
 2732:     V_OFFSET_MONTH  VARCHAR2(2 CHAR);
 2733:     V_TO_DATE       VARCHAR2(8 CHAR);
 2734: BEGIN
 2735:     /* AS-IS 문자열 비교는 대소문자·뒤 공백 무시 */
 2736:     V_STEP := 'INPUT';
 2737:     V_DIVISION_ID := UPPER(RTRIM(P_DIVISION_ID));
 2738:     V_PLAN_NAME   := RTRIM(P_FROM_DATE);
 2739: 
 2740:     V_STEP := 'PLAN CHECK';
 2741:     SELECT COUNT(*)
 2742:       INTO V_CHK
 2743:       FROM SCM_MST_PLAN
 2744:      WHERE PLAN_CYCLE = 'WEEKLY'
 2745:        AND DIVISION_ID = V_DIVISION_ID
 2746:        AND PLAN_NAME = V_PLAN_NAME
 2747:        AND ROWNUM = 1;
 2748: 
 2749:     V_STEP := 'O_RC1';
 2750:     IF V_CHK > 0 THEN
 2751:         /* 2021-05-27 : 중장기 - 계획명 + 363일 */
 2752:         OPEN O_RC1 FOR
 2753:             SELECT PLAN_NAME || ':' || TO_CHAR(TO_DATE(PLAN_NAME, 'YYYYMMDD') + 363, 'YYYYMMDD') AS PERIOD
 2754:               FROM SCM_MST_PLAN
 2755:              WHERE PLAN_CYCLE = 'WEEKLY'
 2756:                AND DIVISION_ID = V_DIVISION_ID
 2757:                AND PLAN_NAME = V_PLAN_NAME;
 2758:     ELSE
 2759:         V_FROM_DATE := TRIM(P_FROM_DATE);
 2760: 
 2761:         /* 시작일이 비면 시간대 기준 오늘 */
 2762:         IF V_FROM_DATE IS NULL THEN
 2763:             V_FROM_DATE := TO_CHAR(FN_MULTY_TIME(P_TIMEZONE), 'YYYYMMDD');
 2764:         END IF;
 2765: 
 2766:         /* AS-IS NVARCHAR(2) 인자 : 3자리 이상은 앞 2자리, 비면 12 */
 2767:         V_OFFSET_MONTH := TRIM(SUBSTR(P_OFFSET_MONTH, 1, 2));
 2768:         IF V_OFFSET_MONTH IS NULL THEN
 2769:             V_OFFSET_MONTH := '12';
 2770:         END IF;
 2771: 
 2772:         V_FROM_LOW := F_SCM0001_LOW_BOUND(V_FROM_DATE);
 2773:         V_TO_DATE  := F_SCM0001_ADD_MONTHS(V_FROM_DATE, TO_NUMBER(V_OFFSET_MONTH));
 2774: 
 2775:         /* 종료일은 마지막 일자의 직전 일요일(일요일이면 당일) */
 2776:         OPEN O_RC1 FOR
 2777:             SELECT CASE WHEN IA.MIN_BASIS_YYYYMMDD IS NOT NULL
 2778:                         THEN IA.MIN_BASIS_YYYYMMDD || ':'
 2779:                           || TO_CHAR(TRUNC(TO_DATE(IA.MAX_BASIS_YYYYMMDD, 'YYYYMMDD') + 1, 'IW') - 1, 'YYYYMMDD')
 2780:                    END AS PERIOD
 2781:               FROM (SELECT MIN(BASIS_YYYYMMDD) AS MIN_BASIS_YYYYMMDD
 2782:                          , MAX(BASIS_YYYYMMDD) AS MAX_BASIS_YYYYMMDD
 2783:                       FROM SCM_SYS_CALENDAR_M
 2784:                      WHERE BASIS_YYYYMMDD >= V_FROM_LOW
 2785:                        AND BASIS_YYYYMMDD <= V_TO_DATE
 2786:                    ) IA;
 2787:     END IF;
 2788: 
 2789:     OPEN O_RESULT_CURSOR FOR
 2790:         SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
 2791: 
 2792: EXCEPTION
 2793:     WHEN OTHERS THEN
 2794:         RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD] STEP=' || V_STEP
 2795:                                       || ' INPUT=' || P_DIVISION_ID || '|' || P_PLAN_CYCLE || '|' || P_FROM_DATE
 2796:                                       || '|' || P_OFFSET_MONTH || '|' || P_TIMEZONE
 2797:                                       || ' / ' || SQLERRM);
 2798: END P_SCM0001_GET_SCP_MONTH_PERIOD;

## 2) 실행 — FE 실전송값 (divisionId=40, planCycle=DAILY, fromDate="", offsetMonth=12, timeZone="")
  timeZone='': o_rc1 cols=['PERIOD'] rows=[('20261020:20271017',)] (n=1)
    o_result_cursor: ['CODE', 'MSG', 'EVENT'] [('0', 'SUCCESS', '0')]
  timeZone='Asia/Seoul': o_rc1 cols=['PERIOD'] rows=[(None,)] (n=1)
    o_result_cursor: ['CODE', 'MSG', 'EVENT'] [('0', 'SUCCESS', '0')]
  division=81:  [('20261020:20271017',)]
  division=82:  [('20261020:20271017',)]

## 3) SCP0096 사내 메타 현재값
### MNU_BTN_MPG_M
   ('Shipment Working Day OSP', 'EDIT', None, 'Y')
   ('Shipment Working Day OSP', 'SAVE', 'P_SCP0096_SAVE', 'Y')
   ('Shipment Working Day OSP', 'SEARCH', 'P_SCP0096_GET', 'Y')
   ('calendar', 'SEARCH', 'SCP0009_SHEET_CALENDAR_3SPAN_GET', 'Y')
   ('dayRange', 'SEARCH', 'SCM0001_SCP_MONTH_PERIOD_GET', 'Y')
### API_M (SCP0096 버튼이 참조하는 API_ID)
   ('P_SCP0096_GET', 'PROC_SELECT', 'PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP', 'Y')
   ('P_SCP0096_SAVE', 'PROC_SAVE', 'PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP', 'Y')
   ('SCM0001_SCP_MONTH_PERIOD_GET', 'PROC_SELECT', 'PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD', 'Y')
   ('SCP0009_SHEET_CALENDAR_3SPAN_GET', 'PROC_SELECT', 'PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN', 'Y')
### PROC_M PKG_SCP0096.* (행수)
   ('PKG_SCP0096.P_DM0003_GET_BUCKET_TYPE_CODE', 2, 'o_rc1,o_result_cursor')
   ('PKG_SCP0096.P_SCP0009_GET_SHEET_CALENDAR_3SPAN', 4, 'startYyyymmdd,endYyyymmdd,o_rc1,o_result_cursor')
   ('PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP', 6, 'divisionId,plantSiteId,fromYyyymmdd,toYyyymmdd,o_rc1,o_result_cursor')
   ('PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP', 9, 'divisionId,plantSiteId,yyyymmdd,measure,shipmentYn,workingTimeDefault,isSaveDefault,userId,o_result_cursor')
### SHEET_COLUMNS SCP0096
   ('Shipment Working Day OSP', 'DIVISION_ID', 'Div', 1, '-', 50, None, None, None, 'C', 'Y', 'Y', '-', 'Y', None, 'S', 'ZIONEX', '2026-10-13 12:13')
   ('Shipment Working Day OSP', 'PLANT_SITE_ID', 'Plant Site ID', 2, '-', 100, None, None, None, 'L', 'Y', 'Y', '-', 'Y', None, 'S', 'wonyeoulb', '2023-02-06 09:46')
   ('Shipment Working Day OSP', 'PLANT_SITE_NAME', 'Plant Site', 3, '-', 130, None, None, None, 'L', 'Y', 'Y', '-', 'Y', None, 'S', 'wonyeoulb', '2023-02-06 09:46')
   ('Shipment Working Day OSP', 'WORKING_TIME_DEFAULT', 'Working Time Default', 4, '-', 85, 'FPNumber', None, 2, 'R', 'Y', 'Y', '-', 'Y', None, 'O', 'ZIONEX', '2026-09-25 10:44')
   ('Shipment Working Day OSP', 'LAST_INPUT_DATE', 'Last Input Date', 5, '-', 100, None, None, None, 'C', 'Y', 'Y', '-', 'Y', None, 'S', 'wonyeoulb', '2023-02-06 09:46')
   ('Shipment Working Day OSP', 'MEASURE', 'Measure', 6, 'Y', 140, None, None, None, 'L', 'Y', 'Y', '-', 'Y', None, 'S', 'wonyeoulb', '2023-02-06 09:46')
### USER_GR_MNU_MPG_M / USER_GR_MNU_BTN_MPG_M
   ('ADMIN', 'Y')
   ('SCM PI Admin', 'Y')
   ('SCM Viewer', 'Y')
   ('SCP Planner', 'Y')
   ('ADMIN', 'Shipment Working Day OSP', 'EDIT', 'Y')
   ('ADMIN', 'Shipment Working Day OSP', 'SAVE', 'Y')
   ('ADMIN', 'Shipment Working Day OSP', 'SEARCH', 'Y')
   ('ADMIN', 'calendar', 'SEARCH', 'Y')
   ('ADMIN', 'dayRange', 'SEARCH', 'Y')
   ('SCM PI Admin', 'Shipment Working Day OSP', 'EDIT', 'Y')
   ('SCM PI Admin', 'Shipment Working Day OSP', 'SAVE', 'Y')
   ('SCM PI Admin', 'Shipment Working Day OSP', 'SEARCH', 'Y')
   ('SCM PI Admin', 'calendar', 'SEARCH', 'Y')
   ('SCM PI Admin', 'dayRange', 'SEARCH', 'Y')
   ('SCM Viewer', 'Shipment Working Day OSP', 'EDIT', 'Y')
   ('SCM Viewer', 'Shipment Working Day OSP', 'SAVE', 'Y')
   ('SCM Viewer', 'Shipment Working Day OSP', 'SEARCH', 'Y')
   ('SCM Viewer', 'calendar', 'SEARCH', 'Y')
   ('SCM Viewer', 'dayRange', 'SEARCH', 'Y')
   ('SCP Planner', 'Shipment Working Day OSP', 'EDIT', 'Y')
   ('SCP Planner', 'Shipment Working Day OSP', 'SAVE', 'Y')
   ('SCP Planner', 'Shipment Working Day OSP', 'SEARCH', 'Y')
   ('SCP Planner', 'calendar', 'SEARCH', 'Y')
   ('SCP Planner', 'dayRange', 'SEARCH', 'Y')
### MNU_M
   ('SCP0096', 'Supply_Master', 'shipment-working-day-osp', 'MNU_SCP0096', 96, 3, 'Y', 'supply/supply-master/shipment-working-day-osp')
