-- =============================================================================
-- V08_SORTKEY_904_CHECK.sql — DMF0082 조회 ORA-00904 "SORT_KEY" 원인 판정 (READ-ONLY, 전체 F5 · 값 입력 없음)
--   계정: SCM_MGR · BE 가 붙은 클라우드 DB
--   오류 위치(V07): 조회 SP 최종 결과 커서 OPEN — 정렬절이 `ORDER BY SORT_KEY, …` 로 시작하는데 출력 컬럼 목록에 SORT_KEY 가 없다.
--   SORT_KEY 는 사용자 컬럼 저장 내역이 아니라 **컬럼 메타(SCM_MST_SHEET_COLUMNS)의 시스템 컬럼**에서 온다.
--     출력 컬럼 목록 = ㉮ 사용자 컬럼 저장 내역(C) ∪ ㉯ 메타에서 DEFAULT_FLAG 가 '빈 값' 인 컬럼 (SORT_KEY · EDIT_FLAG · GROUP_ID 등)
--     ㉯ 의 '빈 값' 판정식이 SP 원문에 `NVL(TRIM(C.DEFAULT_FLAG), '<센티널>') = '<센티널>'` 로 들어 있다.
--     메타의 DEFAULT_FLAG 실제 값과 이 센티널이 어긋나면 ㉯ 가 0건 → SORT_KEY 누락 → ORA-00904.
--   [K1] 이 DB 의 SP 원문에 들어 있는 판정식 (센티널이 '-' 인지 '/' 인지)
--   [K2] 메타의 시스템 컬럼 DEFAULT_FLAG 실제 값 · 마지막 수정자/시각
--   [K3] 판정 — 현재 SP 판정식 기준으로 ㉯ 에 SORT_KEY 가 잡히는가
--   [K4] 오늘 바뀐 메타 행 (DMF0082 · FcstNPrice)
--   [K5] DEFAULT_FLAG 값 분포 (DMF0082 · FcstNPrice)
-- =============================================================================
SET LINESIZE 220
SET PAGESIZE 500
SET TRIMSPOOL ON
SET VERIFY OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A170
COLUMN COLUMN_NAME FORMAT A22
COLUMN FLAG FORMAT A8
COLUMN FLAG_DUMP FORMAT A26
COLUMN WHO FORMAT A14
COLUMN AT FORMAT A17
COLUMN JUDGE FORMAT A110
SPOOL V08_SORTKEY_904_CHECK_OUT.txt

PROMPT ################ [K1] ⭐ SP 원문의 '빈 값' 판정식 (주석 줄 포함 — 앞에 '--' 가 없는 줄이 실제 동작) ################
SELECT 'K1' CHK, S.LINE, SUBSTR(RTRIM(S.TEXT, CHR(10)||CHR(13)),1,170) TXT
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.TEXT LIKE '%C.DEFAULT_FLAG%'
 ORDER BY S.LINE;

PROMPT ################ [K2] ⭐ 메타 — 시스템 컬럼의 DEFAULT_FLAG 실제 값 ################
PROMPT --  FLAG 는 대괄호 안이 실제 값. FLAG_DUMP 로 공백(32)·'-'(45)·'/'(47) 를 구분한다
SELECT 'K2' CHK, C.COLUMN_NAME, '[' || C.DEFAULT_FLAG || ']' FLAG, SUBSTR(DUMP(C.DEFAULT_FLAG),1,26) FLAG_DUMP,
       C.VALID_YN VAL, C.VISIBLE_FLAG VIS, C.USER_SELECTABLE_FLAG SEL,
       SUBSTR(C.LAST_UPDATED_BY,1,14) WHO, TO_CHAR(C.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') AT
  FROM SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice'
   AND C.COLUMN_NAME IN ('SORT_KEY','EDIT_FLAG','GROUP_ID','MEASURE_GROUP','BUCKET','NEW_FLAG','ATTR1','VMI_STD_DIO','AS_YN','NOTATION','VERSION_NO')
 ORDER BY C.COLUMN_NAME;
PROMPT --  SORT_KEY 행이 없다 = 메타에서 행 자체가 사라짐

PROMPT ################ [K3] ⭐⭐ 판정 — 센티널별로 ㉯ 에 잡히는 시스템 컬럼 수 · SORT_KEY 포함 여부 ################
SELECT 'K3' CHK, X.SENTINEL,
       (SELECT COUNT(*) FROM USER_SOURCE S WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
           AND REPLACE(S.TEXT,' ','') LIKE '%ANDNVL(TRIM(C.DEFAULT_FLAG),''' || X.SENTINEL || ''')=''' || X.SENTINEL || '''%'
           AND LTRIM(S.TEXT) NOT LIKE '--%') SP_USES,
       (SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS C WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice'
           AND NVL(TRIM(C.DEFAULT_FLAG), X.SENTINEL) = X.SENTINEL) COLS,
       (SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS C WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice'
           AND NVL(TRIM(C.DEFAULT_FLAG), X.SENTINEL) = X.SENTINEL AND C.COLUMN_NAME = 'SORT_KEY') SORT_KEY_IN,
       CASE WHEN (SELECT COUNT(*) FROM USER_SOURCE S WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
                     AND REPLACE(S.TEXT,' ','') LIKE '%ANDNVL(TRIM(C.DEFAULT_FLAG),''' || X.SENTINEL || ''')=''' || X.SENTINEL || '''%'
                     AND LTRIM(S.TEXT) NOT LIKE '--%') = 0 THEN '(이 DB 의 SP 는 이 센티널을 쓰지 않음)'
            WHEN (SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS C WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice'
                     AND NVL(TRIM(C.DEFAULT_FLAG), X.SENTINEL) = X.SENTINEL AND C.COLUMN_NAME = 'SORT_KEY') = 0
                 THEN 'FAIL — SP 가 쓰는 센티널로는 SORT_KEY 가 안 잡힌다 = ORA-00904 원인 (메타 값과 SP 센티널 불일치)'
            ELSE 'PASS — SP 가 쓰는 센티널로 SORT_KEY 가 잡힌다 (원인은 다른 곳)' END JUDGE
  FROM (SELECT '-' SENTINEL FROM DUAL UNION ALL SELECT '/' FROM DUAL) X
 ORDER BY X.SENTINEL;
PROMPT --  SP_USES = 그 센티널을 쓰는 실제 동작 줄 수(조회 SP 2종에 각 1줄씩이라 보통 2) · SORT_KEY_IN = 1 이어야 정상

PROMPT ################ [K4] 오늘 바뀐 메타 행 (DMF0082 · FcstNPrice) ################
SELECT 'K4' CHK, C.COLUMN_NAME, '[' || C.DEFAULT_FLAG || ']' FLAG, C.VALID_YN VAL,
       SUBSTR(C.LAST_UPDATED_BY,1,14) WHO, TO_CHAR(C.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') AT
  FROM SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice' AND C.LAST_UPDATE_DATE >= TRUNC(SYSDATE)
 ORDER BY C.LAST_UPDATE_DATE DESC, C.COLUMN_NAME;

PROMPT ################ [K5] DEFAULT_FLAG 값 분포 (DMF0082 · FcstNPrice) ################
SELECT 'K5' CHK, '[' || C.DEFAULT_FLAG || ']' FLAG, SUBSTR(DUMP(C.DEFAULT_FLAG),1,26) FLAG_DUMP, COUNT(*) CNT,
       TO_CHAR(MAX(C.LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI') AT
  FROM SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice'
 GROUP BY C.DEFAULT_FLAG, SUBSTR(DUMP(C.DEFAULT_FLAG),1,26)
 ORDER BY 2;

SPOOL OFF
PROMPT =============================================================================
PROMPT  V08 완료 → V08_SORTKEY_904_CHECK_OUT.txt 회신 ([K1] 판정식 · [K2] 실제 값 · [K3] 판정이 핵심)
PROMPT =============================================================================
