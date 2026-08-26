--------------------------------------------------------------------------------
-- 10_EXPORT_MSG_SNAPSHOT.sql
--   목적 : MSG 원장 스냅샷을 "1행 1레코드 · 이스케이프된 TSV" 로 덤프한다.
--          클라우드 / 사내 양쪽에서 **동일하게** 실행하여 두 파일을 만들고,
--          msg_sync.py diff 로 차이를 분류한다.
--   실행 : 클라우드 = 이 SQL 을 직접 실행 (DBeaver 등) -> 결과 전량 복사 -> msg_cloud.txt
--          사내     = `python msg_sync.py export-corp` 로 자동 추출 (동일 쿼리 내장)
--   성격 : SELECT 전용 (원본 무변경)
--
--   포맷 : MSG_ID <TAB> LANG_CD <TAB> MSG_NM <TAB> MSG_DESC <TAB> MSG_TP_CD <TAB> USE_YN
--   이스케이프 (순서 고정 — 역치환 가능하도록 백슬래시를 **먼저** 처리)
--     \       -> \\
--     CHR(13) -> \r
--     CHR(10) -> \n
--     CHR(9)  -> \t
--     NULL    -> \N   (이스케이프 후이므로 데이터의 '\N' 은 '\\N' 이 되어 구분됨)
--
--   ! 감사컬럼(CREATED_BY / *_DATE)은 의도적으로 제외한다.
--     양측 적재 시각은 항상 다르므로 포함하면 전 행이 차이로 잡혀 의미가 사라진다.
--     감사컬럼까지 봐야 하면 90_VERIFY_CORP.sql 을 쓸 것.
--------------------------------------------------------------------------------
SELECT LINE FROM (
  SELECT 0 AS O1, ' ' AS O2, ' ' AS O3,
         '#FORMAT' || CHR(9) || 'MSG_ID' || CHR(9) || 'LANG_CD' || CHR(9) || 'MSG_NM'
                   || CHR(9) || 'MSG_DESC' || CHR(9) || 'MSG_TP_CD' || CHR(9) || 'USE_YN' AS LINE
    FROM DUAL
  UNION ALL
  SELECT 0, ' ', '  ',
         '#META' || CHR(9) || 'EXPORTED=' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
                 || CHR(9) || 'DB=' || SYS_CONTEXT('USERENV', 'DB_NAME')
                 || CHR(9) || 'SCHEMA=' || SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA')
                 || CHR(9) || 'ROWS=' || (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M)
    FROM DUAL
  UNION ALL
  SELECT 1, M.MSG_ID, M.LANG_CD,
         M.MSG_ID || CHR(9) || M.LANG_CD || CHR(9) ||
         CASE WHEN M.MSG_NM IS NULL THEN '\N'
              ELSE REPLACE(REPLACE(REPLACE(REPLACE(M.MSG_NM,
                     '\', '\\'), CHR(13), '\r'), CHR(10), '\n'), CHR(9), '\t') END || CHR(9) ||
         CASE WHEN M.MSG_DESC IS NULL THEN '\N'
              ELSE REPLACE(REPLACE(REPLACE(REPLACE(M.MSG_DESC,
                     '\', '\\'), CHR(13), '\r'), CHR(10), '\n'), CHR(9), '\t') END || CHR(9) ||
         CASE WHEN M.MSG_TP_CD IS NULL THEN '\N'
              ELSE REPLACE(M.MSG_TP_CD, '\', '\\') END || CHR(9) ||
         CASE WHEN M.USE_YN IS NULL THEN '\N'
              ELSE REPLACE(M.USE_YN, '\', '\\') END
    FROM SCM_MGR.SCM_ADM_MSG_M M
)
ORDER BY O1, O2, O3
