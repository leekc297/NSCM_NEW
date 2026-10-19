-- ============================================================================
-- div81 병합 원인 최종 확정 — SP 가 실제로 쓰는 컬럼목록 확인 (클라우드, SCM_MGR)
--
-- [Q1] 로 밝혀진 것: 클라우드 div81 CELL_PROD_SITE_ID 에는 실제 값이 있다
--        [-] 568,452 / WA00-P 44,495 / WA00-A 8,820 / NB01-A 6,903 / HQ07-A 5,376 / MI00-P 4,995 / NA00-A 4,308 ...
--        (사내는 전부 [-] 뿐 → 사내에서 재현 불가했던 이유)
--
-- CELL_PROD_SITE_ID 는 SHEET_COLUMNS 상 DIVISION_ID='40' 이라 [E20260910-PERSDIV] 가 81 조회에서 제외한다.
-- 다만 FROM_SITE_ID(81 전용, 유지)가 CASE 로 같은 값을 실어 나르므로,
--   · 컬럼목록에 FROM_SITE_ID 가 **있으면** → CPS 를 빼도 구분이 유지되어 병합 안 됨
--   · 컬럼목록에 FROM_SITE_ID 가 **없으면** → CPS 구분이 통째로 사라져 병합 발생
-- 즉 판정은 "이 사용자의 컬럼목록에 FROM_SITE_ID 가 들어 있는가" 하나로 갈린다.
--
-- ⚠ 이전 스크립트의 [P0]/[P1]/[P3] 결과는 무효였다 — SET DEFINE OFF 상태에서 &V_USER 를 써
--    치환이 안 된 리터럴로 조회돼 전부 0행이 나왔다. 여기서는 ID 를 직접 박아 넣는다.
--    ▼▼ minyonglee1 이 아니면 아래 3곳을 실제 신고자 ID 로 바꿔 실행 ▼▼
-- 전부 읽기 전용 ([R3] 은 GET 1회 호출).
-- ============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 32767
SET PAGESIZE 0
SET TRIMSPOOL ON

PROMPT ############ [R1] 개인화 C 행수 (i_count) — 분기 결정 / 사내 = 19
SELECT COUNT(*) AS I_COUNT
FROM   SCM_MST_TITLESET_USER
WHERE  PROGRAM_ID = 'DMF0035' AND SHEET_NAME = 'Sales Plan Waterfall'
AND    USER_ID = 'minyonglee1' AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

PROMPT ############ [R2] 개인화 C 컬럼 목록 — FROM_SITE_ID / CELL_PROD_SITE_ID 포함 여부가 핵심
SELECT COLUMN_NAME, SORT_ORDER_NO
FROM   SCM_MST_TITLESET_USER
WHERE  PROGRAM_ID = 'DMF0035' AND SHEET_NAME = 'Sales Plan Waterfall'
AND    USER_ID = 'minyonglee1' AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
ORDER  BY SORT_ORDER_NO;

PROMPT ############ [R3] div81 GET 1회 호출 — SP 가 v_ColList / V_SQL_GROUPBY 를 직접 출력한다
PROMPT 출력 중 "v_ColList :" 줄에 CELL_PROD_SITE_ID / FROM_SITE_ID 가 있는지 보면 된다
DECLARE
  C1 SYS_REFCURSOR; C2 SYS_REFCURSOR; C3 SYS_REFCURSOR;
BEGIN
  PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL(
     P_DIVISION_ID=>'81', P_DEPT_ID=>'ALL', P_END_CUSTOMER=>'ALL', P_SCM_SITE_ID=>'ALL',
     P_PROJECT_CODE=>'', P_ITEM_ID=>'', P_ITEM_TYPE=>'ALL',
     P_FROM_YYYYMMDD=>'20260801', P_NOW_YYYYMMDD=>TO_CHAR(SYSDATE,'YYYYMMDD'),
     P_TO_YYYYMMDD=>'20270228',
     P_CREATED_BY=>'minyonglee1', P_PLANT_SITE_ID=>'ALL', P_BIZTYPE=>'ALL', P_OWNER=>'',
     P_INTERNAL_YN=>'N', P_CELL_YN=>'N', P_VERSION_TYPE=>'SP_W_20260828_V001', P_BUCKET=>'MONTHLY',
     P_USER_DEPT_ID=>'ICT', P_GROUP_ID=>'ADMIN', P_USER_ID=>'minyonglee1', P_MENU_ID=>'DMF0035',
     O_RC1=>C1, O_RC2=>C2, O_RESULT_CURSOR=>C3);
  DBMS_OUTPUT.PUT_LINE('[R3] 정상 종료');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[R3] 오류: ' || SQLCODE || ' ' || SUBSTR(SQLERRM,1,500));
END;
/

PROMPT ############ [R4] 방금 SQL 의 GROUP BY 확인용 — V$SQL 전문
SELECT SQL_FULLTEXT
FROM   V$SQL
WHERE  SQL_TEXT LIKE '%T_DM22_WF%'
AND    LAST_ACTIVE_TIME > SYSDATE - 5/1440
ORDER  BY LAST_ACTIVE_TIME DESC
FETCH FIRST 1 ROWS ONLY;
