-- =====================================================================================================
-- 94_DIAGNOSE_FAST.sql — 93 대체본 (**SELECT 전용 · 초 단위 완료**)
--
--   ⚠ 93 이 느렸던 것은 진단 SQL 설계 잘못입니다(대용량 표에 범위 COUNT/GROUP BY).
--     판정에 필요한 것은 **행수가 아니라 "있는가/없는가"** 이므로 `ROWNUM=1` 존재 검사로 바꿉니다.
--     사내 실측(2026-08-20): F1 0.02s / F3 0.01s / F4 0.51s / F5 0.01s / F2 4.1s.
--
--   ⭐ 그런데 사내에서는 **구(93) 쿼리조차 0.07초**였습니다(SALES div40 기간 COUNT = 15,278행).
--     같은 쿼리가 클라우드에서만 느리면 원인은 데이터가 아니라 **인덱스·통계 차이**입니다.
--     → G1/G2 로 그 축을 함께 봅니다. 이관 패키지의 DDL 은 **GTT 만** 담고 있어(01/02) 원장 표의
--       인덱스는 "이미 있다"고 가정했습니다 — 그 가정이 깨졌는지 확인하는 것입니다.
-- =====================================================================================================
SET LINESIZE 220
SET PAGESIZE 200
SET TIMING ON

PROMPT ===== F1. ⭐⭐ BIZ — 화면이 보낸 그 버전에 데이터가 있는가 (PK 선두 = 즉시) =====
--  0 이면 **원인 확정**: 선택한 버전에 데이터가 없음.
SELECT COUNT(*) AS SELECTED_VERSION_HAS_DATA
  FROM (SELECT 1 FROM SCM_MGR.DM_PLN_BP_FCST_C
         WHERE DIVISION_ID = '40'
           AND VERSION_NO  = 'BP_M_20260807_V002'   -- S1 파라미터에서 '(W32)' 제거한 값
           AND ROWNUM = 1);

PROMPT ===== F2. BIZ — 이 division 에 실제 존재하는 버전 목록 (F1=0 일 때 여기서 고를 것) =====
SELECT VERSION_NO FROM (
  SELECT DISTINCT VERSION_NO FROM SCM_MGR.DM_PLN_BP_FCST_C WHERE DIVISION_ID = '40'
) ORDER BY VERSION_NO DESC FETCH FIRST 15 ROWS ONLY;

PROMPT ===== F3. BIZ — measure 교집합 (사내 기준선: 9종 중 7 HIT) =====
--  EXISTS + PK 선두라 measure 당 수 ms. 전부 MISS 면 measure 이름 불일치가 원인.
SELECT U.COLUMN_NAME,
       NVL((SELECT 'HIT' FROM SCM_MGR.DM_PLN_BP_FCST_C L
             WHERE L.DIVISION_ID = '40'
               AND L.VERSION_NO  = 'BP_M_20260807_V002'
               AND L.MEASURE     = U.COLUMN_NAME
               AND ROWNUM = 1), 'MISS') AS MATCH_
  FROM SCM_MGR.SCM_MST_TITLESET_USER U
 WHERE U.PROGRAM_ID = 'DMF0051' AND U.SHEET_NAME = 'Biz Plan Waterfall'
   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND U.USER_ID = 'minyonglee1'
 ORDER BY 1;

PROMPT ===== F4. MKT / F5. SALES — 조회 조건에 데이터가 있는가 (존재 검사) =====
SELECT 'MKT'   AS TYPE_,
       (SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST
                               WHERE DIVISION_ID='40'
                                 AND YYYYMMDD BETWEEN '20260801' AND '20270228'
                                 AND ROWNUM=1)) AS HAS_DATA FROM DUAL
UNION ALL
SELECT 'SALES',
       (SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN
                               WHERE DIVISION_ID='40'
                                 AND YYYYMMDD BETWEEN '20260801' AND '20270228'
                                 AND ROWNUM=1)) FROM DUAL;

PROMPT ===== G1. ⭐ 인덱스 대조 — 사내 기준선과 같은가 (없으면 조회가 통째로 느려진다) =====
--  사내(정본) 실측 2026-08-20:
--    DM_PLN_BP_FCST_C  : PK_DM_PLN_BP_FCST_C (DIVISION_ID,VERSION_NO,SEQ_NO)
--    DM_PLN_MKT_FCST   : PK(10컬럼) + IDX_..._N1(DIVISION_ID,MEASURE,YYYYMMDD)
--                        + N2(DIVISION_ID,SCM_SITE_ID,MEASURE) + N3(6컬럼)   ← 총 4
--    DM_PLN_SALES_PLAN : PK(11컬럼) + IDX_..._N1(DIVISION_ID,YYYYMMDD)        ← 총 2
SELECT I.TABLE_NAME, I.INDEX_NAME, I.STATUS,
       LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) COLS
  FROM ALL_INDEXES I
  JOIN ALL_IND_COLUMNS C ON C.INDEX_OWNER = I.OWNER AND C.INDEX_NAME = I.INDEX_NAME
 WHERE I.OWNER = 'SCM_MGR'
   AND I.TABLE_NAME IN ('DM_PLN_SALES_PLAN','DM_PLN_BP_FCST_C','DM_PLN_MKT_FCST')
 GROUP BY I.TABLE_NAME, I.INDEX_NAME, I.STATUS ORDER BY 1, 2;

PROMPT ===== G2. 통계 신선도 — 통계가 없거나 낡으면 플랜이 무너진다 =====
SELECT TABLE_NAME, NUM_ROWS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD') LAST_ANALYZED, STALE_STATS
  FROM ALL_TAB_STATISTICS
 WHERE OWNER='SCM_MGR' AND PARTITION_NAME IS NULL
   AND TABLE_NAME IN ('DM_PLN_SALES_PLAN','DM_PLN_BP_FCST_C','DM_PLN_MKT_FCST',
                      'DM_PLN_MKT_FCST_C','DM_PLN_CFM_MKT_DEMAND_PLAN')
 ORDER BY 1;

PROMPT ===== 판독 =====
PROMPT   F1 = 0                  → **선택 버전에 데이터 없음 = 0행의 원인**. F2 목록의 버전으로 재조회
PROMPT   F3 전부 MISS            → measure 이름 불일치가 원인
PROMPT   F4/F5 = 0               → 해당 TYPE 은 그 조건에 원장 데이터가 없음
PROMPT   G1 에 사내 대비 인덱스 부재 → **조회 지연의 원인** (이관 패키지 미포함 축 — DBA 생성 필요)
PROMPT   G2 LAST_ANALYZED 공란   → 통계 미수집 → 플랜 붕괴. DBMS_STATS 수집 필요
