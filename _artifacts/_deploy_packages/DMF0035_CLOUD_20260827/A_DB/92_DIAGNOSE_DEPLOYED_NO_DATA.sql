--------------------------------------------------------------------------------
-- 92_DIAGNOSE_DEPLOYED_NO_DATA.sql — DMF0035 "클라우드 배포 버전에서만 조회 0행" 점검 세트 (2026-08-28)
--
-- 배경: 2026-08-27 클라우드 *로컬 기동* 기준으로는 S4(MNU_M 행 부재)·S5(DMF0022/0051 시트 메타) 정정 후
--       MKT/SALES/BIZ 3 GUBUN 조회 확인. 2026-08-28 *배포 버전* 에서 다시 0행.
--       로컬 기동 ↔ 배포 버전의 차이 축 = ① 접속 DB(QA/DEV 2대) ② BE 접속 계정(SCMP_APP/SCMD_APP)
--       ③ 로그인 사용자·권한그룹 ④ 배포된 FE 번들(시트명·콜 경로) ⑤ 세션 NLS. DB 쪽 ①~③⑤ 를 여기서 가른다.
--
-- ⭐ 실행 규약
--   · 읽기 전용 (DML 없음). SCM_MGR 로 실행. Q8 만 DBMS_OUTPUT 필요(SET SERVEROUTPUT ON).
--   · ⭐ QA / DEV 두 DB 에서 각각 실행 → Q0 결과로 어느 DB 인지 라벨링해 둘 다 회신.
--     (배포 BE 가 보는 DB 와 어제 정정을 적용한 DB 가 다르면 그것이 원인 — 0순위)
--   · <TEST_USER> = 배포 버전에서 조회를 시도한 로그인 ID 로 치환 (2곳: Q3, Q8).
--   · 판정 요약표는 파일 끝 §판정 참조.
--------------------------------------------------------------------------------

--==============================================================================
-- Q0. 어느 DB 인가 (라벨용) — 회신 첫 줄에 붙일 것
--==============================================================================
SELECT 'Q0-ENV' G, USER AS RUN_USER,
       SYS_CONTEXT('USERENV','DB_NAME') DB_NAME,
       SYS_CONTEXT('USERENV','CON_NAME') CON_NAME,
       SYS_CONTEXT('USERENV','SERVER_HOST') SERVER_HOST,
       SYS_CONTEXT('USERENV','INSTANCE_NAME') INSTANCE_NAME,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW_DT
  FROM DUAL;
-- 앱 계정 존재 여부 (배포 BE 가 쓰는 계정이 어느 쪽인지 — application yml 의 datasource.username 과 대조)
SELECT 'Q0-APPACCT' G, USERNAME, TO_CHAR(CREATED,'YYYY-MM-DD') CREATED_DT
  FROM ALL_USERS WHERE USERNAME IN ('SCMP_APP','SCMD_APP','SCM_MGR') ORDER BY USERNAME;
--   (계정 잠금 여부까지 보려면 DBA 대행: SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS WHERE USERNAME IN ('SCMP_APP','SCMD_APP'))
-- 지금 이 DB 에 붙어 있는 BE 세션 (배포 WAS 가 이 DB 를 보는지 — 호스트/프로그램/계정)
--   (V$SESSION 권한 없으면 DBA 대행. 0행 = 배포 BE 는 이 DB 를 보지 않는다)
SELECT 'Q0-BESESS' G, USERNAME, MACHINE, PROGRAM, MODULE, COUNT(*) CNT,
       TO_CHAR(MAX(LOGON_TIME),'MM-DD HH24:MI') LAST_LOGON
  FROM V$SESSION WHERE USERNAME IN ('SCMP_APP','SCMD_APP') AND TYPE='USER'
 GROUP BY USERNAME, MACHINE, PROGRAM, MODULE ORDER BY 1,2;

--==============================================================================
-- Q1. 배포 BE 가 실제로 이 DB 에 DMF0035 호출을 남겼는가 — BE 프레임워크 SQL 로그 (SCM_COM_SQL_LOG)
--   · 0행            → 배포 BE 는 이 DB 를 안 보거나(다른 DB), 요청이 SP 호출 전에 끝남(FE/BE 배선) → 다른 DB 에서 재실행 + FE Network 탭
--   · 행 있음+EXCEPTION → 그 원문이 원인 (PLS-00201 = 권한/시노님, ORA-01861 = NLS, ORA-00942 = 객체)
--   · 행 있음+EXCEPTION NULL+RESULT_COUNT 0 → SP 는 돌았고 0행 = Q2/Q3 로 진행
--==============================================================================
SELECT 'Q1-SQLLOG' G, TO_CHAR(EXECUTE_TIME,'MM-DD HH24:MI:SS') EXEC_DT, CREATED_BY AS LOGIN_USER,
       SQL_ID, ELAPSED_MS, RESULT_COUNT,
       SUBSTR(EXCEPTION,1,300) EXCEPTION_HEAD,
       DBMS_LOB.SUBSTR(PARAMS, 1500, 1) PARAMS_HEAD
  FROM SCM_MGR.SCM_COM_SQL_LOG
 WHERE EXECUTE_TIME >= SYSDATE - 1
   AND (DBMS_LOB.INSTR(PARAMS,'DMF0035') > 0
        OR DBMS_LOB.INSTR(PARAMS,'PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL') > 0
        OR DBMS_LOB.INSTR(PARAMS,'PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL') > 0
        OR DBMS_LOB.INSTR(PARAMS,'Waterfall') > 0)
 ORDER BY EXECUTE_TIME DESC
 FETCH FIRST 30 ROWS ONLY;
-- Q1' BE 시스템 로그 (SCM_COM_SYS_LOG) — 메뉴 단위 예외 원문(EXCT_MSG_CTN). 래퍼(-9994/InvocationTargetException) 밑의 실제 ORA 체인이 여기에 있다
SELECT 'Q1-SYSLOG' G, TO_CHAR(LOG_ST_DTM,'MM-DD HH24:MI:SS') LOG_DT, CREATED_BY AS LOGIN_USER, LOG_TP_CD,
       MNU_ID, SHT_NM, MNU_BTN_CD, RQR_CLNT_IP, SUBSTR(CALL_PGM_URL,1,80) CALL_URL,
       SUBSTR(EXCT_MSG_CTN,1,600) EXCEPTION_HEAD
  FROM SCM_MGR.SCM_COM_SYS_LOG
 WHERE LOG_ST_DTM >= SYSDATE - 1
   AND (MNU_ID = 'DMF0035' OR SHT_NM IN ('mktFcstWaterfall','salesPlanWaterfall','bizPlanWaterfall',
                                          'mktFcstSpreadTitle','salesPlanSpreadTitle','bizPlanSpreadTitle','version','versionWf'))
 ORDER BY LOG_ST_DTM DESC
 FETCH FIRST 30 ROWS ONLY;

--==============================================================================
-- Q2. SP 내부 단계 로그 (SCM_SYS_LOG_BATCH) — 마지막 실행의 단계별 카운트 + 오류
--   PROGRAM_NAME = $$PLSQL_UNIT.SUBPROGRAM 이므로 3 GUBUN 모두 아래 LIKE 에 잡힌다.
--   사내 참조(div 40 / Current / 2026-08-27): MKT  G2 RAW_DATA 5,864 · H(최종) 36
--   · START 는 있는데 END 없음/ERROR 행     → SQL_ERR_CODE·SQL_ERR_MSG·BACKTRACE 가 원인 원문
--   · 단계 카운트 중 처음 0 이 되는 단계    → 그 단계 원천 축 (91_DIAGNOSE_MKT_NO_DATA.sql ②~⑥)
--   · 전 단계 정상(G2>0)인데 화면 0행       → 최종 SQL 의 권한 뷰 INNER JOIN 축 = Q3
--   · 로그 자체 0건 (Q1 은 있음)             → SP 진입 전 실패 = Q4 권한/시노님
--==============================================================================
SELECT 'Q2-LASTRUN' G, PROGRAM_NAME, TO_CHAR(MAX(EVENT_DATE),'MM-DD HH24:MI:SS') LAST_START, COUNT(*) RUNS_24H
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE LOG_TYPE='START' AND EVENT_DATE >= SYSDATE - 1
   AND (PROGRAM_NAME LIKE 'PKG_DMF0035.%' OR PROGRAM_NAME LIKE 'PKG_DMF0022.%WATERFALL%' OR PROGRAM_NAME LIKE 'PKG_DMF0051.%WATERFALL%'
        OR PROGRAM_NAME LIKE 'PKG_DMF0022.%SPREAD_TITLE%' OR PROGRAM_NAME LIKE 'PKG_DMF0051.%SPREAD_TITLE%')
 GROUP BY PROGRAM_NAME ORDER BY 2 DESC;

-- 마지막 실행 1회분 전체 단계 (3 GUBUN 중 마지막으로 START 된 것 기준 — 특정 GUBUN 만 보려면 LIKE 를 좁힐 것)
SELECT 'Q2-STEPS' G, TO_CHAR(EVENT_DATE,'HH24:MI:SS') DT, PROGRAM_NAME, LOG_TYPE,
       SUBSTR(LOG_MESSAGE,1,60) MSG, LOG_COUNT, SQL_ERR_CODE,
       SUBSTR(SQL_ERR_MSG,1,200) ERR, SUBSTR(SQL_BACKTRACE,1,200) BACKTRACE,
       SUBSTR(IN_PARA_DATA,1,300) IN_PARA
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE (PROGRAM_NAME LIKE 'PKG_DMF0035.%' OR PROGRAM_NAME LIKE 'PKG_DMF0022.%' OR PROGRAM_NAME LIKE 'PKG_DMF0051.%')
   AND EVENT_DATE >= (SELECT MAX(EVENT_DATE) - 1/1440 FROM SCM_MGR.SCM_SYS_LOG_BATCH
                       WHERE LOG_TYPE='START'
                         AND (PROGRAM_NAME LIKE 'PKG_DMF0035.%WATERFALL%' OR PROGRAM_NAME LIKE 'PKG_DMF0022.%WATERFALL%' OR PROGRAM_NAME LIKE 'PKG_DMF0051.%WATERFALL%'))
 ORDER BY EVENT_DATE, PROGRAM_NAME, LOG_MESSAGE;

-- 최근 24h ERROR 만 (어느 GUBUN 이든)
SELECT 'Q2-ERRORS' G, TO_CHAR(EVENT_DATE,'MM-DD HH24:MI:SS') DT, PROGRAM_NAME, SQL_ERR_CODE,
       SUBSTR(SQL_ERR_MSG,1,300) ERR, SUBSTR(SQL_BACKTRACE,1,300) BACKTRACE
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE EVENT_DATE >= SYSDATE - 1 AND SQL_ERR_CODE IS NOT NULL
   AND (PROGRAM_NAME LIKE 'PKG_DMF0035.%' OR PROGRAM_NAME LIKE 'PKG_DMF0022.%' OR PROGRAM_NAME LIKE 'PKG_DMF0051.%' OR PROGRAM_NAME LIKE '%SCM0002%')
 ORDER BY EVENT_DATE DESC FETCH FIRST 20 ROWS ONLY;

--==============================================================================
-- Q3. V11 — 메뉴 행 + 로그인 사용자의 권한 뷰 (어제 S4 원인 축. 이 DB 에도 적용됐는지)
--   기대: MNU 1행(UNIT_TP_CD='D', USE_YN='Y') / AUTH ≥1행(조회한 Division 포함) / 그룹 매핑 5행
--   AUTH 0행 = 오류 없이 0행 확정 (PKG 3본 모두 SCM_ADM_USER_MNU_EDIT_AUTH_V INNER JOIN)
--==============================================================================
SELECT 'Q3-MNU' G, MNU_ID, UPPR_MNU_ID, UNIT_TP_CD, USE_YN, ROUTE_PATH, TO_CHAR(LAST_UPDATE_DATE,'MM-DD HH24:MI') UPD_DT
  FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0035';
SELECT 'Q3-GRMPG' G, USER_GR_ID, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0035' ORDER BY 2;
SELECT 'Q3-AUTH' G, USER_ID, MNU_ID, UNIT_ID, EDIT_YN
  FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
 WHERE USER_ID='<TEST_USER>' AND MNU_ID='DMF0035' ORDER BY UNIT_ID;
-- Q3-MENUS ⭐ (2026-08-28 QA 회신 후 추가) 'waterfall' 계열 메뉴 전부 — 클라우드 QA retrieveMenus 에 SCM0020 이 MNU_URL='demand-plan-waterfall'·ROUTE 'demand/demand-waterfall/scm0020' 로
--   보였다(사내 SCM0020 은 MNU_URL='scm0020'). 배포 화면에서 클릭한 메뉴가 SCM0020 이면 페이지는 DMF0035 컴포넌트인데 MNU_ID=SCM0020 으로 call-proc/버튼권한이 흘러 배선 0 = 조용한 0행.
SELECT 'Q3-MENUS' G, MNU_ID, UPPR_MNU_ID, MNU_URL, ROUTE_PATH, MNU_MSG_ID, USE_YN, TO_CHAR(LAST_UPDATE_DATE,'MM-DD HH24:MI') UPD_DT
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('SCM0020','DMF0035','DMF0022','DMF0053','Demand_Waterfall','Waterfall') OR LOWER(MNU_URL) LIKE '%waterfall%' ORDER BY 1;
SELECT 'Q3-SCM0020WIRE' G, 'BTN' T, COUNT(*) CNT FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SCM0020'
UNION ALL SELECT 'Q3-SCM0020WIRE', 'GRMPG', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='SCM0020'
UNION ALL SELECT 'Q3-SCM0020WIRE', 'SYSLOG_24H', COUNT(*) FROM SCM_MGR.SCM_COM_SYS_LOG WHERE MNU_ID='SCM0020' AND LOG_ST_DTM >= SYSDATE-1
UNION ALL SELECT 'Q3-SCM0020WIRE', 'SYSLOG_DMF0035_24H', COUNT(*) FROM SCM_MGR.SCM_COM_SYS_LOG WHERE MNU_ID='DMF0035' AND LOG_ST_DTM >= SYSDATE-1;
-- Q3' 같은 사용자가 다른 메뉴(예: DMF0022/DMF0082)는 권한 뷰가 나오는지 — 0행이면 사용자·그룹 자체 문제, DMF0035 만 0 이면 메뉴 배선 문제
SELECT 'Q3-AUTHOTHER' G, MNU_ID, COUNT(*) CNT
  FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
 WHERE USER_ID='<TEST_USER>' AND MNU_ID IN ('DMF0035','DMF0022','DMF0051','DMF0082','DMF0044') GROUP BY MNU_ID ORDER BY 1;

--==============================================================================
-- Q4. V12 — 앱 계정별 EXECUTE + 시노님 (배포 BE 계정이 로컬 기동 계정과 다르면 여기서 갈린다)
--   기대: 13 객체 × (SCMP_APP, SCMD_APP) 각 EXECUTE 1 + 시노님 1. 부재 = PLS-00201 → 화면 "SQL ERROR"
--   (데이터 0행 증상과는 다르지만, FE 가 오류를 삼키고 빈 그리드로 보이는 경우가 있어 함께 확인)
--==============================================================================
WITH OBJ AS (
  SELECT COLUMN_VALUE AS OBJ FROM TABLE(SYS.ODCIVARCHAR2LIST(
    'PKG_DMF0035','PKG_DMF0022','PKG_DMF0051','PKG_SCM0002','FN_GET_DM_MKT_OWNER_NAME','FN_NEXT_DAY',
    'UF_FX_STRING_SPLIT','PR_SCM_SYS_LOG_BATCH','FN_SPLITSTRING','FN_SCM_SYS_NVL','SCM_ARR_SPL_CNT','SCM_ARR_SPL_VAL',
    'DMF0073_GET_VERSION_SALESPRICE','PKG_SCM_USER_MNU','PKG_NSCM_UI_COMM'))),
ACCT AS (SELECT 'SCMP_APP' A FROM DUAL UNION ALL SELECT 'SCMD_APP' FROM DUAL)
SELECT 'Q4-GRANT' G, ACCT.A ACCOUNT, OBJ.OBJ,
       (SELECT COUNT(*) FROM ALL_TAB_PRIVS P WHERE P.TABLE_SCHEMA='SCM_MGR' AND P.TABLE_NAME=OBJ.OBJ AND P.GRANTEE=ACCT.A AND P.PRIVILEGE='EXECUTE') EXEC_GRANT,
       (SELECT COUNT(*) FROM ALL_SYNONYMS S WHERE S.OWNER=ACCT.A AND S.SYNONYM_NAME=OBJ.OBJ AND S.TABLE_OWNER='SCM_MGR') PRIV_SYNONYM,
       (SELECT COUNT(*) FROM ALL_SYNONYMS S WHERE S.OWNER='PUBLIC' AND S.SYNONYM_NAME=OBJ.OBJ AND S.TABLE_OWNER='SCM_MGR') PUB_SYNONYM
  FROM OBJ CROSS JOIN ACCT
 ORDER BY 2, 3;
-- 권한 뷰·메뉴 테이블 SELECT 권한 (PKG 는 정의자 권한이라 보통 불요 — 확인용)
SELECT 'Q4-VIEWSEL' G, GRANTEE, TABLE_NAME, PRIVILEGE FROM ALL_TAB_PRIVS
 WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME IN ('SCM_ADM_USER_MNU_EDIT_AUTH_V','SCM_ADM_MNU_M','SCM_COM_SQL_LOG')
   AND GRANTEE IN ('SCMP_APP','SCMD_APP') ORDER BY 1,2,3;

--==============================================================================
-- Q5. 객체 상태·배포 시각 — 어제 적용본이 이 DB 에 있는가 (QA/DEV 대조 핵심)
--   기대: 4 PKG SPEC/BODY 모두 VALID, BODY LAST_DDL ≥ 2026-08-27 · GTT 49 · INVALID 0
--==============================================================================
SELECT 'Q5-OBJ' G, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051','PKG_SCM0002','PKG_SCM_USER_MNU','SCM_ADM_USER_MNU_EDIT_AUTH_V',
                       'FN_GET_DM_MKT_OWNER_NAME','FN_NEXT_DAY','UF_FX_STRING_SPLIT','PR_SCM_SYS_LOG_BATCH','FN_SPLITSTRING',
                       'FN_SCM_SYS_NVL','SCM_ARR_SPL_CNT','SCM_ARR_SPL_VAL','DMF0073_GET_VERSION_SALESPRICE')
 ORDER BY 2, 3;
SELECT 'Q5-INVALID' G, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND STATUS='INVALID'
   AND (OBJECT_NAME LIKE 'PKG_DMF00%' OR OBJECT_NAME LIKE 'PKG_SCM%' OR OBJECT_NAME LIKE 'GT_DM%' OR OBJECT_NAME LIKE '%USER_MNU%')
 ORDER BY 1;
SELECT 'Q5-GTT' G, COUNT(*) GTT_CNT FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y'
-- 기대 49
   AND (TABLE_NAME LIKE 'GT_DM35%' OR TABLE_NAME LIKE 'GT_DM22%' OR TABLE_NAME LIKE 'GT_DM51%' OR TABLE_NAME LIKE 'GT_SPNC_SHPCHK%');
-- 어제 정정 계보 마커가 이 DB 의 BODY 에 있는가 (0 = 구본)
SELECT 'Q5-MARKER' G, NAME, COUNT(*) CNT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')
   AND (TEXT LIKE '%E2026%' OR TEXT LIKE '%[E2026%')
 GROUP BY NAME ORDER BY 1;

--==============================================================================
-- Q6. 배선·메타 (API_M / BTN / PROC_M / 시트 메타 V13) — 기대값은 90_VERIFY 와 동일
--==============================================================================
-- 기대 8
SELECT 'Q6-API' G, API_ID, API_URL, USE_YN FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'DMF0035%' ORDER BY 1;
-- 기대 8
SELECT 'Q6-BTN' G, SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035' ORDER BY 1,2;
-- 기대 5그룹 합 40
SELECT 'Q6-BTNAUTH' G, USER_GR_ID, COUNT(*) CNT FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035' GROUP BY USER_GR_ID ORDER BY 1;
SELECT 'Q6-PROCM' G, PROC_NM, COUNT(*) PARAM_CNT FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM IN ('PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL','PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE',
                   'PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL','PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE',
                   'PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL','PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE',
                   'PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP','DMF0073_GET_VERSION_SALESPRICE')
-- 기대 25/7/25/9/22/9/8/9
 GROUP BY PROC_NM ORDER BY 1;
SELECT 'Q6-META' G, PROGRAM_ID, SHEET_NAME, 'COLUMNS' T, COUNT(*) CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID IN ('DMF0022','DMF0035','DMF0051') GROUP BY PROGRAM_ID, SHEET_NAME
UNION ALL SELECT 'Q6-META', PROGRAM_ID, SHEET_NAME, 'MEASURE', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID IN ('DMF0022','DMF0035','DMF0051') GROUP BY PROGRAM_ID, SHEET_NAME
-- 기대 DMF0035 'Mkt Fcst Waterfall' 71/49 · DMF0022 salesPlanWaterfall 65 / 'Sales Plan Waterfall' 31 · DMF0051 'Biz Plan Waterfall' 61/9
 ORDER BY 2,3,4;
-- 사용자 메저/컬럼 선택 저장분(TITLESET_USER) — 선택이 있는데 원천 MEASURE 와 안 맞으면 0행 (있으면 SHEET_NAME·건수 회신)
SELECT 'Q6-TITLESET' G, USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE TP, COUNT(*) CNT FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID IN ('DMF0022','DMF0035','DMF0051') GROUP BY USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE ORDER BY 1,2,3,4;

--==============================================================================
-- Q7. 원천 데이터 (division 별) — 이 DB 에 조회 대상 데이터 자체가 있는가 (QA/DEV 적재 차이)
--   원천 실측: MKT=DM_PLN_CFM_MKT_DEMAND_PLAN(div40)/DM_PLN_MKT_FCST · SALES=DM_PLN_SALES_PLAN(+_C/RESULT) · BIZ=DM_PLN_BP_FCST(YYYYMM 축)
--==============================================================================
SELECT 'Q7-SRC' G, 'CFM_MKT_DEMAND_PLAN' T, DIVISION_ID, COUNT(*) CNT, MIN(YYYYMMDD) MINY, MAX(YYYYMMDD) MAXY FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN WHERE QTY <> 0 GROUP BY DIVISION_ID
UNION ALL SELECT 'Q7-SRC', 'MKT_FCST', DIVISION_ID, COUNT(*), MIN(YYYYMMDD), MAX(YYYYMMDD) FROM SCM_MGR.DM_PLN_MKT_FCST WHERE QTY <> 0 GROUP BY DIVISION_ID
UNION ALL SELECT 'Q7-SRC', 'SALES_PLAN', DIVISION_ID, COUNT(*), MIN(YYYYMMDD), MAX(YYYYMMDD) FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE QTY <> 0 GROUP BY DIVISION_ID
UNION ALL SELECT 'Q7-SRC', 'BP_FCST(BIZ)', DIVISION_ID, COUNT(*), MIN(YYYYMM), MAX(YYYYMM) FROM SCM_MGR.DM_PLN_BP_FCST WHERE QTY <> 0 GROUP BY DIVISION_ID
ORDER BY 2, 3;
SELECT 'Q7-VER' G, DIVISION_ID, COUNT(*) CNT, MAX(VERSION_NO) MAX_VER FROM SCM_MGR.DM_MST_VERSION GROUP BY DIVISION_ID ORDER BY 2;
SELECT 'Q7-CAL' G, COUNT(*) CNT FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD BETWEEN '20250101' AND '20271231';

--==============================================================================
-- Q8. SP 직접 호출 재현 (DB 축 격리) — Q1 의 PARAMS_HEAD 에 찍힌 값으로 아래 리터럴을 맞춘 뒤 실행
--   결과 해석: SCM_MGR 에서 O_RC1 행 > 0 인데 화면 0행 → DB 는 정상, 원인은 계정(Q4)·DB 불일치(Q0)·FE 번들 축
--              여기서도 0행 → Q2 단계 카운트 / Q3 권한 뷰 / Q7 원천 순으로 DB 축 원인
--   SET SERVEROUTPUT ON 필요. (GTT 는 세션 종료 시 비워지므로 부작용 없음)
--==============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  V_USER   VARCHAR2(50)  := '<TEST_USER>';
-- 화면에서 선택한 Division
  V_DIV    VARCHAR2(10)  := '40';
-- 화면 From
  V_FROM   VARCHAR2(8)   := '20260801';
-- 화면 To
  V_TO     VARCHAR2(8)   := '20270228';
  -- FE 값 그대로: DAILY / WEEKLY / MONTHLY / ONLY_WEEKLY (FE 기본 MONTHLY)
  V_BUCKET VARCHAR2(20)  := 'MONTHLY';
  -- ⚠ 대문자 'CURRENT' (3 PKG 모두 LIKE '%CURRENT%' 분기 — 'Current'/공란은 적재 분기 없음 = 0행). 특정 버전이면 그 VERSION_NO
  V_VER    VARCHAR2(50)  := 'CURRENT';
  -- FE calcNowYyyymmdd: 이번주 월요일, From 이 그 이후면 From, To 가 그 이전이면 To+1
  V_NOW    VARCHAR2(8);
  RC1 SYS_REFCURSOR; RC2 SYS_REFCURSOR; RC3 SYS_REFCURSOR; RCR SYS_REFCURSOR;
  V_CNT PLS_INTEGER;
  V_CODE VARCHAR2(4000); V_MSG VARCHAR2(4000);
  PROCEDURE CNT_CUR(P_RC IN OUT SYS_REFCURSOR, P_LABEL VARCHAR2) IS
    C INTEGER; N PLS_INTEGER := 0; D DBMS_SQL.DESC_TAB; COLCNT PLS_INTEGER; V VARCHAR2(4000);
  BEGIN
    C := DBMS_SQL.TO_CURSOR_NUMBER(P_RC);
    DBMS_SQL.DESCRIBE_COLUMNS(C, COLCNT, D);
    FOR I IN 1..COLCNT LOOP DBMS_SQL.DEFINE_COLUMN(C, I, V, 4000); END LOOP;
    WHILE DBMS_SQL.FETCH_ROWS(C) > 0 LOOP N := N + 1; END LOOP;
    DBMS_SQL.CLOSE_CURSOR(C);
    DBMS_OUTPUT.PUT_LINE(P_LABEL || ' rows=' || N || ' cols=' || COLCNT);
  END;
BEGIN
  V_NOW := GREATEST(TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYYMMDD'), V_FROM);
  IF V_TO < V_NOW THEN V_NOW := TO_CHAR(TO_DATE(V_TO,'YYYYMMDD')+1,'YYYYMMDD'); END IF;
  -- ① MKT (PKG_DMF0035)
  SCM_MGR.PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE(V_FROM, V_TO, V_USER, V_DIV, V_BUCKET, RC1, RCR);
  CNT_CUR(RC1, 'MKT  spreadTitle'); CNT_CUR(RCR, 'MKT  spreadTitle result');
  --   ⚠ PROJECT_CODE / ITEM_ID / OWNER 는 '' (FE 는 join(',') 결과 공란). 'ALL' 을 넣으면 SP 가 LIKE '%ALL%' 필터로 전량 삭제(E52) → 0행
  SCM_MGR.PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL(
      V_DIV,'ALL','ALL','ALL','','','ALL', V_FROM, V_TO, V_USER,
      'ALL','ALL','', V_VER, V_BUCKET, '', '', 'N', 'ALL', V_USER, 'DMF0035',
      RC1, RC2, RC3, RCR);
  CNT_CUR(RC1, 'MKT  main o_rc1'); CNT_CUR(RC2, 'MKT  o_rc2'); CNT_CUR(RC3, 'MKT  o_rc3'); CNT_CUR(RCR, 'MKT  result');
  -- ② SALES (PKG_DMF0022) — ⚠ FE 는 버전 미선택 시 versionType='' 를 보낸다(store L211). SP 는 '%CURRENT%'/'%SP_%' 분기에서만 적재
  SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL(
      V_DIV,'ALL','ALL','ALL','','','ALL', V_FROM, V_NOW, V_TO, V_USER,
      'ALL','ALL','','N','N', V_VER, V_BUCKET, '', '', V_USER, 'DMF0035',
      RC1, RC2, RCR);
  CNT_CUR(RC1, 'SALES main o_rc1'); CNT_CUR(RC2, 'SALES o_rc2'); CNT_CUR(RCR, 'SALES result');
  -- ③ BIZ (PKG_DMF0051)
  -- ③ BIZ (PKG_DMF0051) — 동일: '%CURRENT%'/'%BP_%' 분기에서만 적재 (FE 공란이면 0행)
  SCM_MGR.PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL(
      V_DIV,'ALL','ALL','ALL','','','ALL', V_FROM, V_NOW, V_TO, V_USER,
      'ALL','ALL','', V_VER, 'N', 'N', V_USER, 'DMF0035',
      RC1, RC2, RCR);
  CNT_CUR(RC1, 'BIZ  main o_rc1'); CNT_CUR(RC2, 'BIZ  o_rc2'); CNT_CUR(RCR, 'BIZ  result');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR ' || SQLERRM);
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
-- Q8' 배포 BE 계정으로 같은 호출이 되는지 (시노님·권한 실측) — 해당 계정으로 접속해 접두 없이 실행
--   PLS-00201 → Q4 축 확정.  (계정 비밀번호가 없으면 DBA 대행)
--   BEGIN PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE('20260801','20270228','<TEST_USER>','40','W', :rc1, :rcr); END;

--==============================================================================
-- Q9. NLS / 옵티마이저 (배포 WAS = Linux JVM 세션. 동적 SQL 암묵 변환 재발 여부 — S2 계보)
--   세션 NLS 는 타 세션 것을 직접 볼 수 없다 → DB/인스턴스 기본값 + BE 세션의 optimizer_dynamic_sampling(V$ 권한 필요)만 본다.
--   JDBC 세션 NLS_DATE_FORMAT 은 JVM locale 로 정해진다(Linux en_US → 'DD-MON-RR'). 마스크 없는 TO_DATE/CAST 는 여기서만 ORA-01861.
--==============================================================================
SELECT 'Q9-NLSDB' G, 'DATABASE' SCOPE, PARAMETER, VALUE FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER IN ('NLS_DATE_FORMAT','NLS_LANGUAGE','NLS_TERRITORY','NLS_CHARACTERSET')
UNION ALL SELECT 'Q9-NLSDB', 'INSTANCE', PARAMETER, VALUE FROM NLS_INSTANCE_PARAMETERS WHERE PARAMETER IN ('NLS_DATE_FORMAT','NLS_LANGUAGE','NLS_TERRITORY')
UNION ALL SELECT 'Q9-NLSDB', 'THIS_SESSION', PARAMETER, VALUE FROM NLS_SESSION_PARAMETERS WHERE PARAMETER IN ('NLS_DATE_FORMAT','NLS_LANGUAGE')
ORDER BY 2,3;
-- BE 세션의 optimizer_dynamic_sampling (0 = GTT 무통계로 클라우드만 10배 느림 계보. V$ 권한 없으면 DBA 대행)
SELECT 'Q9-ODS' G, S.USERNAME, S.MACHINE, P.NAME, P.VALUE, COUNT(*) SESS
  FROM V$SESSION S JOIN V$SES_OPTIMIZER_ENV P ON P.SID = S.SID
 WHERE S.USERNAME IN ('SCMP_APP','SCMD_APP') AND P.NAME = 'optimizer_dynamic_sampling'
 GROUP BY S.USERNAME, S.MACHINE, P.NAME, P.VALUE ORDER BY 1,2,3;
-- 동적 SQL 안 암묵 DATE 변환 잔존 스캔 (0건 기대)
SELECT 'Q9-CAST' G, NAME, LINE, SUBSTR(TEXT,1,160) TXT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')
   AND (UPPER(TEXT) LIKE '%CAST(%AS DATE)%' OR REGEXP_LIKE(UPPER(TEXT), 'TO_DATE\s*\(\s*[A-Z_.]+\s*\)'))
 ORDER BY 1,2,3;

--------------------------------------------------------------------------------
-- §판정 (두 DB 결과를 나란히 두고)
-- A. Q0 DB_NAME/HOST 가 어제 정정 적용한 DB 와 다르고 Q5 BODY LAST_DDL < 08-27 / Q3-MNU 0행 / Q6-META DMF0051 0행
--      → 배포 BE 가 보는 DB 에 어제 패키지(20_MENU_WIRING_AUTH·22A·40) 미적용. 조치 = 그 DB 에 동일 적용 (QA·DEV 양쪽 원칙)
-- B. Q1 에 배포 호출 흔적이 한쪽 DB 에만 있음 → 그 DB 가 배포 대상. A 판정을 그 DB 로.
-- C. Q1 EXCEPTION 에 PLS-00201/ORA-00942 → Q4 계정 축 (배포 계정에 EXECUTE/시노님 부재). 조치 = 40_GRANT_SYNONYM.sql (그 계정)
-- D. Q1 EXCEPTION NULL·RESULT_COUNT 0·Q2 G2>0·Q3-AUTH 0행 → 권한 뷰 축 (MNU_M 행 또는 사용자 그룹 매핑). 조치 = 20_MENU_WIRING_AUTH.sql + 사용자 그룹 확인
-- E. Q8 이 SCM_MGR 에서 행 > 0 인데 Q1 이 아예 0행 → DB 는 정상, 요청이 SP 까지 안 옴 = FE 번들 축
--      (브라우저 Network: /call-proc 요청 sheetName 이 mktFcstWaterfall 인지 · 응답 code · index.ts viewRegistry 등록 · procedures.d.ts 블록). DB 쿼리로는 못 가름.
-- F. Q1 에 -1861 / Q9-CAST > 0 → NLS 축. 조치 = TO_DATE 명시 마스크 정정본 재배포
-- G. ⭐ Q1 PARAMS_HEAD 의 versionNo / versionType 값과 Q7-VER 를 대조 — 사내 실측(2026-08-28):
--      SALES/BIZ 는 P_VERSION_TYPE LIKE '%CURRENT%'(또는 SP_*/BP_* 버전)에서만 GTT 적재. ''(공란) = 오류 없이 0행 (SALES 0/BIZ 0 vs 'CURRENT' 2,619/15,897).
--      FE 는 SALES/BIZ 버전을 필수(required)로 막으므로 공란은 못 보내지만, **선택한 버전이 그 DB 의 DM_MST_VERSION 에 없으면 0행**(환경별 버전 목록 상이).
--      MKT 는 `p.version || 'CURRENT'` 보정. 또 PROJECT_CODE/ITEM_ID/OWNER 는 공란이어야 한다 — 'ALL' 이 들어오면 LIKE 필터로 전량 삭제(E52 단계 카운트 = E5 와 동일).
--      Q2-STEPS 서명: E5 > 0 인데 E51/E52/E53 이 E5 만큼 지우고 G2 = 0 → 이 축 확정 (FE 페이로드 결함).
--------------------------------------------------------------------------------
