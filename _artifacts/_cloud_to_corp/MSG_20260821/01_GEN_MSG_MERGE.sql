--------------------------------------------------------------------------------
-- 01_GEN_MSG_MERGE.sql
--   목적 : [클라우드] SCM_MGR.SCM_ADM_MSG_M 을 읽어서
--          [사내]     SCM_MGR.SCM_ADM_MSG_M 에 적용할 MERGE INTO 스크립트를 "생성" 한다.
--   실행 : ★ 클라우드 DB 에서 실행 (SELECT 전용 — 원본 무변경)
--   출력 : LINE 컬럼 1개. 전체 행을 그대로 복사 -> .sql 파일로 저장 -> 사내 DB 에서 실행.
--
--   대상 테이블 실측 (2026-08-21, 사내 100.65.143.121:1521/OCGSCMD_P01)
--     컬럼 10 : MSG_ID(VC50,NN) LANG_CD(VC10,NN) MSG_NM(VC400) MSG_DESC(VC1000)
--                MSG_TP_CD(VC20,NN) USE_YN(VC1,NN)
--                CREATED_BY(VC120,NN) CREATION_DATE(DATE,NN)
--                LAST_UPDATED_BY(VC120,NN) LAST_UPDATE_DATE(DATE,NN)
--     PK       : PK_TB_FX_MESSAGE_M (MSG_ID, LANG_CD)  <- MERGE ON 키 (실측 근거)
--
--   이스케이프 처리 (사내 데이터 실측 기준 — 전부 실재함)
--     '  (작은따옴표)  -> '' 로 치환                        [실측 6건]
--     CHR(10)/CHR(13)  -> ' || CHR(10) || ' 형태로 분해     [실측 LF 3건]
--     &  (치환변수)     -> 생성 스크립트 머리에 SET DEFINE OFF [실측 18건]
--     NULL             -> CAST(NULL AS VARCHAR2(n)) 명시    [MSG_NM 1건 / MSG_DESC 2012건]
--     DATE             -> TO_DATE(..,'YYYY-MM-DD HH24:MI:SS') 명시 마스크 (NLS 비의존)
--
--   ! 의미 : UPSERT 전용. 사내에만 존재하는 행은 삭제하지 않는다(추가/갱신만).
--            사내 단독 보유 행까지 보려면 90_VERIFY_CORP.sql 의 차집합 절차를 따를 것.
--------------------------------------------------------------------------------
WITH PRM AS (          /* vvv 필요 시 이 4개 값만 수정 (NULL = 전체 / 제외 없음) vvv */
  SELECT CAST(NULL AS VARCHAR2(50)) AS P_MSG_ID_LIKE     /* 예) 'MSG01%' , 'LBL%'      */
       , CAST(NULL AS VARCHAR2(10)) AS P_LANG_CD         /* 예) 'KO'                   */
       , CAST(NULL AS DATE)         AS P_CHANGED_SINCE   /* 예) DATE '2026-08-01'      */
       /* ⭐ P_EXCLUDE_MSG_IDS — "사내 명칭을 정본으로 유지" 로 판정한 코드를 MERGE 에서 제외.
             값은 msg_sync.py report 가 만드는 exclude_candidates.txt 를 검토·선별해 붙여넣는다.
             형식 = 콤마 구분, 앞뒤 공백 없이. 예) 'LBL00005,LBL00067,MSG00097'            */
       , CAST(NULL AS VARCHAR2(4000)) AS P_EXCLUDE_MSG_IDS
    FROM DUAL
), SRC AS (
  SELECT M.MSG_ID, M.LANG_CD, M.MSG_NM, M.MSG_DESC, M.MSG_TP_CD, M.USE_YN
       , M.CREATED_BY, M.CREATION_DATE, M.LAST_UPDATED_BY, M.LAST_UPDATE_DATE
    FROM SCM_MGR.SCM_ADM_MSG_M M
   CROSS JOIN PRM P
   WHERE M.MSG_ID  LIKE NVL(P.P_MSG_ID_LIKE, '%')
     AND M.LANG_CD LIKE NVL(P.P_LANG_CD    , '%')
     AND M.LAST_UPDATE_DATE >= NVL(P.P_CHANGED_SINCE, DATE '1900-01-01')
     /* 제외 목록 — 양변을 콤마로 감싸 부분일치 오탐(LBL0000 이 LBL00005 를 먹는 일) 차단 */
     AND ',' || NVL(P.P_EXCLUDE_MSG_IDS, '~') || ',' NOT LIKE '%,' || M.MSG_ID || ',%'
), Q AS (
  SELECT S.MSG_ID, S.LANG_CD
       , '''' || REPLACE(S.MSG_ID , '''', '''''') || ''''  AS QID
       , '''' || REPLACE(S.LANG_CD, '''', '''''') || ''''  AS QLANG
       , CASE WHEN S.MSG_NM IS NULL THEN 'CAST(NULL AS VARCHAR2(400))'
              ELSE '''' || REPLACE(REPLACE(REPLACE(S.MSG_NM, '''', ''''''),
                                   CHR(13), q'[' || CHR(13) || ']'),
                                   CHR(10), q'[' || CHR(10) || ']') || '''' END AS QNM
       , CASE WHEN S.MSG_DESC IS NULL THEN 'CAST(NULL AS VARCHAR2(1000))'
              ELSE '''' || REPLACE(REPLACE(REPLACE(S.MSG_DESC, '''', ''''''),
                                   CHR(13), q'[' || CHR(13) || ']'),
                                   CHR(10), q'[' || CHR(10) || ']') || '''' END AS QDESC
       , '''' || REPLACE(S.MSG_TP_CD      , '''', '''''') || '''' AS QTP
       , '''' || REPLACE(S.USE_YN         , '''', '''''') || '''' AS QUSE
       , '''' || REPLACE(S.CREATED_BY     , '''', '''''') || '''' AS QCBY
       , '''' || REPLACE(S.LAST_UPDATED_BY, '''', '''''') || '''' AS QUBY
       , 'TO_DATE(''' || TO_CHAR(S.CREATION_DATE   , 'YYYY-MM-DD HH24:MI:SS')
                      || ''',''YYYY-MM-DD HH24:MI:SS'')' AS QCDT
       , 'TO_DATE(''' || TO_CHAR(S.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS')
                      || ''',''YYYY-MM-DD HH24:MI:SS'')' AS QUDT
    FROM SRC S
), AGG AS (
  SELECT COUNT(*) AS CNT
       , NVL(SUM(ORA_HASH(S.MSG_ID || '|' || S.LANG_CD || '|' ||
                          NVL(S.MSG_NM, '~') || '|' || NVL(S.MSG_DESC, '~') || '|' ||
                          S.MSG_TP_CD || '|' || S.USE_YN)), 0) AS HASHSUM
    FROM SRC S
), L AS (
  SELECT LEVEL AS SEQ FROM DUAL CONNECT BY LEVEL <= 9
)
SELECT LINE FROM (
  /* -- 1) 헤더 ------------------------------------------------------------ */
  SELECT 0 AS O1, ' ' AS O2, ' ' AS O3, H.SEQ AS O4,
         CASE H.SEQ
           WHEN  1 THEN '-- ==========================================================================='
           WHEN  2 THEN '-- SCM_ADM_MSG_M : CLOUD -> 사내(SCM_MGR) MERGE 적용 스크립트 [자동생성]'
           WHEN  3 THEN '--   생성일시 : ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
           WHEN  4 THEN '--   원본     : CLOUD SCM_MGR.SCM_ADM_MSG_M'
           WHEN  5 THEN '--   필터     : MSG_ID LIKE ' || NVL(P.P_MSG_ID_LIKE, '(전체)')
                                     || ' / LANG_CD ' || NVL(P.P_LANG_CD, '(전체)')
                                     || ' / CHANGED_SINCE '
                                     || NVL(TO_CHAR(P.P_CHANGED_SINCE, 'YYYY-MM-DD'), '(전체)')
                                     || ' / EXCLUDE ' || NVL(P.P_EXCLUDE_MSG_IDS, '(없음)')
           WHEN  6 THEN '--   대상건수 : ' || A.CNT || ' 행'
           WHEN  7 THEN '--   원본검증 : SRC_CNT=' || A.CNT || ' / SRC_HASHSUM=' || A.HASHSUM
                                     || '   (적용 후 90_VERIFY_CORP.sql 결과와 대조)'
           WHEN  8 THEN '--   ON 키    : (MSG_ID, LANG_CD) = PK_TB_FX_MESSAGE_M'
           WHEN  9 THEN '--   주의     : UPSERT 전용 — 사내 단독 보유 행은 삭제하지 않음'
           WHEN 10 THEN '-- ==========================================================================='
           WHEN 11 THEN 'SET DEFINE OFF'
           WHEN 12 THEN ''
         END AS LINE
    FROM (SELECT LEVEL AS SEQ FROM DUAL CONNECT BY LEVEL <= 12) H
   CROSS JOIN PRM P
   CROSS JOIN AGG A
  UNION ALL
  /* -- 2) 본문 : 1행 = MERGE 1문 (행 단위 독립 실행 -> 부분 실패 격리) ------ */
  SELECT 1, Q.MSG_ID, Q.LANG_CD, L.SEQ,
         CASE L.SEQ
           WHEN 1 THEN 'MERGE INTO SCM_MGR.SCM_ADM_MSG_M T'
           WHEN 2 THEN 'USING (SELECT ' || Q.QID || ' AS MSG_ID, ' || Q.QLANG || ' AS LANG_CD, '
                                        || Q.QNM || ' AS MSG_NM,'
           WHEN 3 THEN '              ' || Q.QDESC || ' AS MSG_DESC, ' || Q.QTP || ' AS MSG_TP_CD, '
                                        || Q.QUSE || ' AS USE_YN,'
           WHEN 4 THEN '              ' || Q.QCBY || ' AS CREATED_BY, ' || Q.QCDT
                                        || ' AS CREATION_DATE, ' || Q.QUBY || ' AS LAST_UPDATED_BY, '
                                        || Q.QUDT || ' AS LAST_UPDATE_DATE FROM DUAL) S'
           WHEN 5 THEN '   ON (T.MSG_ID = S.MSG_ID AND T.LANG_CD = S.LANG_CD)'
           WHEN 6 THEN ' WHEN MATCHED THEN UPDATE SET T.MSG_NM = S.MSG_NM, T.MSG_DESC = S.MSG_DESC'
                                        || ', T.MSG_TP_CD = S.MSG_TP_CD, T.USE_YN = S.USE_YN'
                                        || ', T.LAST_UPDATED_BY = S.LAST_UPDATED_BY'
                                        || ', T.LAST_UPDATE_DATE = S.LAST_UPDATE_DATE'
           WHEN 7 THEN ' WHEN NOT MATCHED THEN INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD'
                                        || ', USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY'
                                        || ', LAST_UPDATE_DATE)'
           WHEN 8 THEN '      VALUES (S.MSG_ID, S.LANG_CD, S.MSG_NM, S.MSG_DESC, S.MSG_TP_CD'
                                        || ', S.USE_YN, S.CREATED_BY, S.CREATION_DATE, S.LAST_UPDATED_BY'
                                        || ', S.LAST_UPDATE_DATE);'
           WHEN 9 THEN ''
         END
    FROM Q CROSS JOIN L
  UNION ALL
  /* -- 3) 푸터 ------------------------------------------------------------ */
  SELECT 2, ' ', ' ', F.SEQ,
         CASE F.SEQ
           WHEN 1 THEN 'COMMIT;'
           WHEN 2 THEN '-- END OF SCRIPT : ' || A.CNT || ' 행 MERGE (SRC_HASHSUM=' || A.HASHSUM || ')'
         END
    FROM (SELECT LEVEL AS SEQ FROM DUAL CONNECT BY LEVEL <= 2) F
   CROSS JOIN AGG A
)
ORDER BY O1, O2, O3, O4
