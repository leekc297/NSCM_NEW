--------------------------------------------------------------------------------
-- DMF0082 : SCM_FCST 메저를 81 계열 DIVISION 에서 사용 가능하도록 개방
--            [0/2] SCM_MST_SHEET_MEASURE DIVISION_ID 확장 (메저 노출 게이트)
-- 마커     : E20260902-81SCMFCST
-- 대상     : SCM_MGR.SCM_MST_SHEET_MEASURE
--------------------------------------------------------------------------------
-- ⚠ 사내(OCGSCMD_P01) 적용 상태 : **이미 적용됨** (2026-09-02 17:46 / LAST_UPDATED_BY='minyonglee1')
--    본 파일은 **클라우드 이관용**이다. 사내에서 재실행해도 같은 값이라 무해(멱등).
--
-- 이 축이 하는 일
--   메저 목록/모달에 SCM_FCST 가 나타나는지를 결정한다. DIVISION_ID 가 '40' 뿐이면
--   81 계열에서는 메저 자체가 뜨지 않아, 편집권한 룩업(01_·02_)을 아무리 넣어도 소용이 없다.
--   DIVISION_ID 는 콤마 구분 CSV 이며 SP 는 ','||DIVISION_ID||',' LIKE '%,'||div||',%' 형태로 소비한다.
--
-- 적용 전/후 (실측)
--   before : DIVISION_ID = '40'
--   after  : DIVISION_ID = '40,81,81_UC,81_HM,81_ST,81_HD,81_HG'
--
-- 대조 (같은 시트의 타 메저 — 81 계열 토큰 구성이 동일한지 확인)
--   MKT_FCST   = '40,81,81_UC,81_HM,81_ST,81_HD,81_HG,82'
--   LOC        = '40,81,81_UC,81_HM,81_ST,81_HD,81_HG,82'
--   VMI_In_Req = '40,81,81_UC,81_HM,81_ST,81_HD,81_HG,82'
--   AS_In_Req  = '81,81_UC,81_HM,81_ST,81_HD,81_HG'
--   ⇒ 81 계열 6종 토큰은 동일. SCM_FCST 는 요구가 "81" 이므로 **82 를 포함하지 않는다**.
--      (82 도 필요해지면 토큰 추가 + 01_/02_ 의 division 목록에도 '82' 를 함께 넣어야 한다)
--
-- 멱등성 : 값을 확정 대입하므로 재실행 안전. 이미 같은 값이면 0행 갱신.
--------------------------------------------------------------------------------

UPDATE SCM_MGR.SCM_MST_SHEET_MEASURE
   SET DIVISION_ID      = '40,81,81_UC,81_HM,81_ST,81_HD,81_HG'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0082'
   AND SHEET_NAME  = 'FcstNPrice'
   AND COLUMN_NAME = 'SCM_FCST'
   AND DIVISION_ID <> '40,81,81_UC,81_HM,81_ST,81_HD,81_HG';

COMMIT;

--------------------------------------------------------------------------------
-- 검증 ①  SCM_FCST 의 DIVISION_ID 에 81 계열 6종이 모두 들어갔는가 (토큰 단위 판정)
--          기대: 6행 전부 '있음'
--------------------------------------------------------------------------------
WITH DIVS AS (SELECT COLUMN_VALUE DIV
                FROM TABLE(SYS.ODCIVARCHAR2LIST('81','81_UC','81_ST','81_HD','81_HM','81_HG')))
SELECT D.DIV
     , CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_MEASURE M
                          WHERE M.PROGRAM_ID='DMF0082' AND M.SHEET_NAME='FcstNPrice'
                            AND M.COLUMN_NAME='SCM_FCST' AND M.VALID_YN='Y'
                            AND ','||M.DIVISION_ID||',' LIKE '%,'||D.DIV||',%')
            THEN '있음' ELSE 'N(누락)' END AS 토큰
  FROM DIVS D ORDER BY D.DIV;

--------------------------------------------------------------------------------
-- 검증 ②  시트 전체 메저의 DIVISION_ID 구성 대조
--------------------------------------------------------------------------------
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, DEFAULT_FLAG
     , USER_SELECTABLE_FLAG, VALID_YN, SORT_ORDER_NO
     , LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') AS UPD
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice'
 ORDER BY SORT_ORDER_NO;

--------------------------------------------------------------------------------
-- 원복 (필요 시)
--------------------------------------------------------------------------------
-- UPDATE SCM_MGR.SCM_MST_SHEET_MEASURE
--    SET DIVISION_ID = '40', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
--  WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND COLUMN_NAME='SCM_FCST';
-- COMMIT;
