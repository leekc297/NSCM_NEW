--------------------------------------------------------------------------------
-- 90_VERIFY_CORP.sql
--   목적 : 01_GEN_MSG_MERGE.sql 로 생성한 MERGE 스크립트를 사내에 적용한 뒤,
--          클라우드 원본과 실제로 일치하는지 "실측 대조" 한다.
--   실행 : §1~§2 = 사내 / 클라우드 양쪽에서 동일하게 실행 후 수치 비교
--          §3      = 양쪽에서 실행 후 결과를 파일로 저장 -> 텍스트 diff (정확한 차집합)
--   전제 : 아래 PRM 값은 01_GEN_MSG_MERGE.sql 에서 사용한 값과 반드시 동일해야 한다.
--
--   ! MERGE 는 UPSERT 전용이므로, 사내에만 있는 행이 있으면 §1 의 CNT/HASHSUM 은
--     정상 적용 후에도 불일치한다. 이때는 §3 diff 로 차이의 실체를 확정할 것.
--     (수치 불일치 = 실패 라고 단정 금지 — 원인을 §3 로 가른다)
--------------------------------------------------------------------------------

-- ============================================================================
-- §1. 총계 + 행 해시 합계  (사내 / 클라우드 동일 실행 -> 수치 대조)
--     01 생성물 헤더의 "SRC_CNT / SRC_HASHSUM" 과 직접 비교한다.
-- ============================================================================
WITH PRM AS (
  SELECT CAST(NULL AS VARCHAR2(50)) AS P_MSG_ID_LIKE
       , CAST(NULL AS VARCHAR2(10)) AS P_LANG_CD
       , CAST(NULL AS DATE)         AS P_CHANGED_SINCE
    FROM DUAL
)
SELECT COUNT(*) AS CNT
     , NVL(SUM(ORA_HASH(M.MSG_ID || '|' || M.LANG_CD || '|' ||
                        NVL(M.MSG_NM, '~') || '|' || NVL(M.MSG_DESC, '~') || '|' ||
                        M.MSG_TP_CD || '|' || M.USE_YN)), 0) AS HASHSUM
  FROM SCM_MGR.SCM_ADM_MSG_M M
 CROSS JOIN PRM P
 WHERE M.MSG_ID  LIKE NVL(P.P_MSG_ID_LIKE, '%')
   AND M.LANG_CD LIKE NVL(P.P_LANG_CD    , '%')
   AND M.LAST_UPDATE_DATE >= NVL(P.P_CHANGED_SINCE, DATE '1900-01-01');

-- ============================================================================
-- §2. 언어별 / 유형별 분포  (누락이 특정 언어·유형에 쏠렸는지 확인)
-- ============================================================================
SELECT LANG_CD
     , MSG_TP_CD
     , COUNT(*)                                        AS CNT
     , SUM(CASE WHEN USE_YN = 'Y' THEN 1 ELSE 0 END)   AS USE_Y
     , SUM(CASE WHEN MSG_NM IS NULL THEN 1 ELSE 0 END) AS NM_NULL
  FROM SCM_MGR.SCM_ADM_MSG_M
 GROUP BY LANG_CD, MSG_TP_CD
 ORDER BY LANG_CD, MSG_TP_CD;

-- ============================================================================
-- §3. 키 + 행해시 전량 목록  (사내/클라우드 각각 실행 -> 파일 저장 -> diff)
--     diff 결과 해석
--       클라우드에만 있음 = MERGE 미적용/누락       -> 01 재생성 후 재적용
--       사내에만 있음     = 사내 단독 보유 행       -> 삭제 여부는 사용자 판단
--       양쪽 존재+해시상이 = 값 불일치(적용 실패)   -> 해당 키만 재적용
-- ============================================================================
SELECT M.MSG_ID || '|' || M.LANG_CD || '|' ||
       ORA_HASH(NVL(M.MSG_NM, '~') || '|' || NVL(M.MSG_DESC, '~') || '|' ||
                M.MSG_TP_CD || '|' || M.USE_YN) AS KEY_HASH
  FROM SCM_MGR.SCM_ADM_MSG_M M
 ORDER BY M.MSG_ID, M.LANG_CD;

-- ============================================================================
-- §4. 특수문자 보유 행 스팟체크 (이스케이프 손상 여부 — 양쪽 값 직접 눈으로 대조)
--     생성기 이스케이프 4종(따옴표/개행/&/NULL)이 실제로 살아있는지 본다.
-- ============================================================================
SELECT MSG_ID
     , LANG_CD
     , CASE WHEN INSTR(NVL(MSG_NM, '-') || NVL(MSG_DESC, '-'), CHR(10)) > 0 THEN 'LF '    END ||
       CASE WHEN INSTR(NVL(MSG_NM, '-') || NVL(MSG_DESC, '-'), CHR(13)) > 0 THEN 'CR '    END ||
       CASE WHEN INSTR(NVL(MSG_NM, '-') || NVL(MSG_DESC, '-'), '''')   > 0 THEN 'QUOTE ' END ||
       CASE WHEN INSTR(NVL(MSG_NM, '-') || NVL(MSG_DESC, '-'), '&')    > 0 THEN 'AMP '   END ||
       CASE WHEN MSG_NM IS NULL                                             THEN 'NMNULL' END AS FLAGS
     , MSG_NM
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE INSTR(NVL(MSG_NM, '-') || NVL(MSG_DESC, '-'), CHR(10)) > 0
    OR INSTR(NVL(MSG_NM, '-') || NVL(MSG_DESC, '-'), CHR(13)) > 0
    OR INSTR(NVL(MSG_NM, '-') || NVL(MSG_DESC, '-'), '''')   > 0
    OR INSTR(NVL(MSG_NM, '-') || NVL(MSG_DESC, '-'), '&')    > 0
    OR MSG_NM IS NULL
 ORDER BY MSG_ID, LANG_CD;
