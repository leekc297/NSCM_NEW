-- =============================================================================
-- DMF0021_ORA30926_DIAG_CLOUD.sql
--   DMF0021 조회 `ORA-30926` (PKG_DMF0021 line 840) 원인 확인 — **클라우드에서 실행**
--
--   ⚠ READ-ONLY. 데이터·구조·SP 를 전혀 변경하지 않습니다.
--   계정: SCM_MGR
--
--   ▶ 사내 분석 결론(대조용)
--     `DM_PLN_SALES_ETC_PLAN` 의 PK 는 **11 컬럼**인데
--     L840 MERGE 의 조인키는 **10 개**만 사용하고 **`MEASURE` 가 빠져 있습니다.**
--     같은 키에 통화별 measure(SalesAmt_KRW / _LOC / _USD)가 여러 건이면
--     USING 이 대상 1행에 여러 행을 매칭 → ORA-30926.
--     사내 실측: 중복 그룹 1 / 행 3 / ATTRIBUTE1 은 그룹 내 **동일(1종)**.
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 200
SET TRIMSPOOL ON
SET FEEDBACK ON
SET VERIFY OFF
COLUMN MEASURES        FORMAT A46
COLUMN ATTR1_VALUES    FORMAT A40
COLUMN COLUMN_NAME     FORMAT A22
COLUMN T               FORMAT A118

-- ── 조회 기간: **오류가 난 화면 조회의 기간**으로 바꿔 주세요 ────────────────
--    p_now_yyyymmdd  = 조회 시작(보통 오늘 또는 조회조건 From)
--    p_to_yyyymmdd   = 조회 종료(조회조건 To)
DEFINE P_NOW = '20260731'
DEFINE P_TO  = '20270101'

SPOOL DMF0021_ORA30926_DIAG.txt

PROMPT ############################################################
PROMPT [0] 환경 · 진단 기간
PROMPT ############################################################
SELECT SYS_CONTEXT('USERENV','DB_NAME') DB_NAME,
       SYS_CONTEXT('USERENV','SERVER_HOST') HOST,
       '&P_NOW' AS P_NOW_YYYYMMDD, '&P_TO' AS P_TO_YYYYMMDD,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') NOW
  FROM DUAL;

PROMPT ############################################################
PROMPT [1] 클라우드 PKG_DMF0021 L840 이 사내와 동일한 MERGE 인지 확인
PROMPT     (라인 번호가 밀려 있으면 아래 [1-B] 로 위치를 다시 찾으세요)
PROMPT ############################################################
SELECT LINE, TEXT AS T
  FROM USER_SOURCE
 WHERE NAME='PKG_DMF0021' AND TYPE='PACKAGE BODY'
   AND LINE BETWEEN 838 AND 862
 ORDER BY LINE;
-- 기대: L840 `MERGE INTO GT_DMF0021_RAW_DATA A`
--       L841 `USING ( SELECT DIVISION_ID, ... , YYYYMMDD`
--       L848 `AND QTY <> 0 ) B`      ← GROUP BY / DISTINCT 없음이 원인
--       L860 `WHEN MATCHED THEN UPDATE SET A.ATTRIBUTE1 = B.ATTRIBUTE1;`

PROMPT --- [1-B] 라인이 다르면 MERGE 위치 재탐색
SELECT LINE, TEXT AS T
  FROM USER_SOURCE
 WHERE NAME='PKG_DMF0021' AND TYPE='PACKAGE BODY'
   AND TRIM(TEXT) NOT LIKE '--%'
   AND REGEXP_LIKE(TEXT,'MERGE\s+INTO\s+(SCM_MGR\.)?GT_DMF0021_RAW_DATA','i')
 ORDER BY LINE;

PROMPT ############################################################
PROMPT [2] DM_PLN_SALES_ETC_PLAN PK 구성 (MEASURE 포함 여부 확인)
PROMPT ############################################################
SELECT cc.POSITION, cc.COLUMN_NAME,
       CASE WHEN cc.COLUMN_NAME = 'MEASURE' THEN '<<< MERGE 조인키에서 누락' END AS NOTE
  FROM USER_CONSTRAINTS c
  JOIN USER_CONS_COLUMNS cc ON c.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
 WHERE c.TABLE_NAME='DM_PLN_SALES_ETC_PLAN' AND c.CONSTRAINT_TYPE='P'
 ORDER BY cc.POSITION;
-- 사내 기준 11 컬럼:
--   DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT, DOM_EXP,
--   FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD

PROMPT ############################################################
PROMPT [3] ⭐⭐ 핵심 — MERGE 조인키 기준 중복 그룹 (이것이 ORA-30926 의 원인)
PROMPT ############################################################
SELECT COUNT(*)                                        AS DUP_GROUPS,
       NVL(SUM(CNT),0)                                 AS DUP_ROWS,
       NVL(MAX(CNT),0)                                 AS MAX_ROWS_PER_KEY,
       NVL(SUM(CASE WHEN ATTR_DISTINCT > 1 THEN 1 ELSE 0 END),0) AS ATTR1_DIFFERS_GROUPS
  FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                INCOTERMS, PLANT_SITE_ID, YYYYMMDD, NVL(REMARK_TEXT,'#') RT,
                COUNT(*) CNT,
                COUNT(DISTINCT NVL(ATTRIBUTE1,'~')) ATTR_DISTINCT
           FROM DM_PLN_SALES_ETC_PLAN
          WHERE DIVISION_ID = '40'
            AND FCST_TYPE   = 'ETC'
            AND YYYYMMDD >= '&P_NOW' AND YYYYMMDD <= '&P_TO'
            AND QTY <> 0
          GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                   INCOTERMS, PLANT_SITE_ID, YYYYMMDD, NVL(REMARK_TEXT,'#')
         HAVING COUNT(*) > 1 );
--
-- ⭐ 판정
--   DUP_GROUPS = 0            → 이 기간엔 중복 없음. 오류가 난 **실제 기간**으로 &P_NOW/&P_TO 를
--                                바꿔 다시 실행하세요(기간이 다르면 재현 안 됩니다)
--   DUP_GROUPS > 0            → **원인 확정**. ORA-30926 의 직접 원인입니다
--   ATTR1_DIFFERS_GROUPS = 0  → ✅ 패치(GROUP BY + MAX(ATTRIBUTE1)) 가 **의미 변화 없이 안전**
--   ATTR1_DIFFERS_GROUPS > 0  → ⛔ 같은 키인데 dept_id 가 서로 다름 →
--                                어느 값을 남길지 **업무 판단 필요**. 패치 보류하고 [5] 를 확인

PROMPT ############################################################
PROMPT [4] 중복 그룹 상세 (상위 20건) — 어떤 measure 들이 겹치는가
PROMPT ############################################################
SELECT * FROM (
  SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, PLANT_SITE_ID, YYYYMMDD,
         NVL(REMARK_TEXT,'#') AS RT,
         COUNT(*) AS CNT,
         LISTAGG(MEASURE, ',') WITHIN GROUP (ORDER BY MEASURE) AS MEASURES,
         COUNT(DISTINCT NVL(ATTRIBUTE1,'~')) AS ATTR1_KINDS
    FROM DM_PLN_SALES_ETC_PLAN
   WHERE DIVISION_ID = '40'
     AND FCST_TYPE   = 'ETC'
     AND YYYYMMDD >= '&P_NOW' AND YYYYMMDD <= '&P_TO'
     AND QTY <> 0
   GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
            PLANT_SITE_ID, YYYYMMDD, NVL(REMARK_TEXT,'#')
  HAVING COUNT(*) > 1
   ORDER BY COUNT(*) DESC, PROJECT_CODE
) WHERE ROWNUM <= 20;
-- 사내 사례: NT / ETC_P / 20260630 / 3건 / SalesAmt_KRW,SalesAmt_LOC,SalesAmt_USD / ATTR1_KINDS=1

PROMPT ############################################################
PROMPT [5] ⚠ ATTRIBUTE1(dept_id) 이 서로 다른 그룹만 (있으면 패치 보류)
PROMPT ############################################################
SELECT * FROM (
  SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, PLANT_SITE_ID, YYYYMMDD,
         NVL(REMARK_TEXT,'#') AS RT, COUNT(*) AS CNT,
         LISTAGG(MEASURE,',') WITHIN GROUP (ORDER BY MEASURE) AS MEASURES,
         LISTAGG(DISTINCT NVL(ATTRIBUTE1,'~'), ' | ') WITHIN GROUP (ORDER BY 1) AS ATTR1_VALUES
    FROM DM_PLN_SALES_ETC_PLAN
   WHERE DIVISION_ID = '40'
     AND FCST_TYPE   = 'ETC'
     AND YYYYMMDD >= '&P_NOW' AND YYYYMMDD <= '&P_TO'
     AND QTY <> 0
   GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
            PLANT_SITE_ID, YYYYMMDD, NVL(REMARK_TEXT,'#')
  HAVING COUNT(*) > 1 AND COUNT(DISTINCT NVL(ATTRIBUTE1,'~')) > 1
   ORDER BY COUNT(*) DESC
) WHERE ROWNUM <= 20;
-- 기대: **0행** (0행이면 §4 패치 안전)

PROMPT ############################################################
PROMPT [6] 참고 — 기간 무관 전체 중복 현황 (얼마나 흔한 데이터인지)
PROMPT ############################################################
SELECT COUNT(*) AS DUP_GROUPS_ALL_PERIOD,
       NVL(SUM(CNT),0) AS DUP_ROWS_ALL_PERIOD,
       NVL(MIN(MIN_D),'-') AS FROM_YYYYMMDD,
       NVL(MAX(MAX_D),'-') AS TO_YYYYMMDD
  FROM ( SELECT COUNT(*) CNT, MIN(YYYYMMDD) MIN_D, MAX(YYYYMMDD) MAX_D
           FROM DM_PLN_SALES_ETC_PLAN
          WHERE DIVISION_ID='40' AND FCST_TYPE='ETC' AND QTY<>0
          GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                   INCOTERMS, PLANT_SITE_ID, YYYYMMDD, NVL(REMARK_TEXT,'#')
         HAVING COUNT(*) > 1 );

PROMPT ############################################################
PROMPT [7] 참고 — 이 MERGE 는 division 40 고정입니다
PROMPT ############################################################
SELECT DIVISION_ID, COUNT(*) CNT
  FROM DM_PLN_SALES_ETC_PLAN
 WHERE FCST_TYPE='ETC' AND QTY<>0
 GROUP BY DIVISION_ID ORDER BY 2 DESC;
-- L845 `WHERE DIVISION_ID = '40'` 이므로 40 외 division 은 이 MERGE 대상이 아닙니다.

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 회신 요망: DMF0021_ORA30926_DIAG.txt
PROMPT   ⭐ 특히 [3] 의 DUP_GROUPS 와 ATTR1_DIFFERS_GROUPS
PROMPT      · DUP_GROUPS > 0  · ATTR1_DIFFERS_GROUPS = 0  → 패치 진행 가능
PROMPT      · ATTR1_DIFFERS_GROUPS > 0                    → 업무 판단 필요(보류)
PROMPT   ⚠ [3] 이 0행이면 &P_NOW/&P_TO 를 **오류가 난 실제 조회기간**으로 바꿔 재실행
PROMPT =============================================================
