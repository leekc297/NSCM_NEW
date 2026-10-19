-- =====================================================================
-- SYS0006 (Api Setting) 조회조건 API Type 콤보 원천 = SCM_ADM_LOOKUP_MASTER_DETAIL
--   LOOKUP_TYPE = 'API_TP_CD'  (MASTER 는 기존재: SEGMENT1='CODE', SEGMENT2='NAME')
-- 작성일 : 2026-09-14 (rev2 — 클라우드 '-' 표시 보정)
-- 대상   : SCM_MGR
-- 성격   : 목표 상태 멱등 MERGE — 사내·클라우드 동일 실행 / 삭제 없음
--   · 코드 행 없음 → INSERT
--   · 코드 행 있음 + NAME(SEGMENT2)·순번·설명이 목표와 다름 → 보정 (현재값이 무엇이든)
--   · 이미 목표 상태 → 0행 (재실행 안전)
-- 범위   : DETAIL 행만. CMBO_SQL_M / FE / BE 무변경
--
-- 코드값 근거 : SELECT API_TP_CD, COUNT(*) FROM SCM_ADM_API_M GROUP BY API_TP_CD (2026-09-14 사내)
--   PROC_SELECT 255 / PROC_SAVE 99 / PROC 79 / POST 24 / EXCELUPLOAD 1
-- SEGMENT2(NAME) : 사용자 확정 = 클라우드 원설계 LBL 코드
--   PROC_SELECT=LBL00321 'Procedure(Read)' / PROC_SAVE=LBL00322 'Procedure(Save)' / EXCELUPLOAD=LBL00346 'Excel Upload'
--   PROC / POST 는 대응 LBL 없음 → 영문 명칭
-- 조회조건 콤보 라벨 = SEGMENT2 → SEGMENT2 가 '-' 면 화면에 '-' 로 보인다 (2026-09-14 클라우드 증상)
--
-- 주의: SEGMENT2 는 PK 컬럼. 같은 코드에 목표 SEGMENT2 행이 이미 따로 있으면 그 '-' 행은
--   보정하지 않는다(PK 충돌 방지). 이 경우 확인 SELECT 에서 코드당 2행으로 보인다 → 담당자 판단.
-- =====================================================================

-- [사전 확인] 적용 전 현재 상태 (결과를 저장해 두면 원복 근거가 된다)
SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
     , DISPLAY_SEQ, VALID_YN, DESCRIPTION, CREATED_BY, LAST_UPDATED_BY, LAST_UPDATE_DATE
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'API_TP_CD'
 ORDER BY DISPLAY_SEQ, SEGMENT1;

MERGE INTO SCM_ADM_LOOKUP_MASTER_DETAIL T
USING (
    SELECT 'API_TP_CD' AS LOOKUP_TYPE, 'PROC_SELECT' AS SEGMENT1, 'LBL00321' AS SEGMENT2
         , 10 AS DISPLAY_SEQ, 'Procedure Select' AS DESCRIPTION
      FROM DUAL
    UNION ALL
    SELECT 'API_TP_CD', 'PROC_SAVE',   'LBL00322',  20, 'Procedure Save' FROM DUAL
    UNION ALL
    SELECT 'API_TP_CD', 'PROC',        'Procedure', 30, 'Procedure'      FROM DUAL
    UNION ALL
    SELECT 'API_TP_CD', 'POST',        'Post',      40, 'Post'           FROM DUAL
    UNION ALL
    SELECT 'API_TP_CD', 'EXCELUPLOAD', 'LBL00346',  50, 'Excel Upload'   FROM DUAL
) S
ON (    T.LOOKUP_TYPE = S.LOOKUP_TYPE
    AND T.SEGMENT1    = S.SEGMENT1
    AND T.SEGMENT3    = '-'
    AND T.SEGMENT4    = '-'
    AND T.SEGMENT5    = '-')
WHEN MATCHED THEN
    UPDATE SET T.SEGMENT2         = S.SEGMENT2
             , T.DISPLAY_SEQ      = S.DISPLAY_SEQ
             , T.VALID_YN         = 'Y'
             , T.DESCRIPTION      = S.DESCRIPTION
             , T.LAST_UPDATED_BY  = 'admin'
             , T.LAST_UPDATE_DATE = SYSDATE
     WHERE (   T.SEGMENT2 <> S.SEGMENT2
            OR NVL(T.DISPLAY_SEQ, -1) <> S.DISPLAY_SEQ
            OR NVL(T.VALID_YN, '-') <> 'Y'
            OR NVL(T.DESCRIPTION, '-') <> S.DESCRIPTION)
       AND (   T.SEGMENT2 = S.SEGMENT2
            OR NOT EXISTS (SELECT 1
                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL X
                            WHERE X.LOOKUP_TYPE = S.LOOKUP_TYPE
                              AND X.SEGMENT1    = S.SEGMENT1
                              AND X.SEGMENT2    = S.SEGMENT2
                              AND X.SEGMENT3    = '-'
                              AND X.SEGMENT4    = '-'
                              AND X.SEGMENT5    = '-'))
WHEN NOT MATCHED THEN
    INSERT (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
          , DISPLAY_SEQ, VALID_YN, DESCRIPTION
          , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.LOOKUP_TYPE, S.SEGMENT1, S.SEGMENT2, '-', '-', '-'
          , S.DISPLAY_SEQ, 'Y', S.DESCRIPTION
          , 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- [사후 확인] 코드 5종이 각 1행, SEGMENT2 = 목표값
SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, DISPLAY_SEQ, VALID_YN, DESCRIPTION, CREATED_BY, LAST_UPDATED_BY
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'API_TP_CD'
 ORDER BY DISPLAY_SEQ, SEGMENT1;
