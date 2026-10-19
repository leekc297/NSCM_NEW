-- =============================================================================
-- V09_FCSTTYPE_COMBO_CHECK.sql — DMF0082 Insert 행 FCST Type 후보가 W/S 유형만 나오는 원인 판정 (READ-ONLY, 전체 F5 · 값 입력 없음)
--   계정: SCM_MGR · BE 가 붙은 클라우드 DB
--   신고(2026-10-12): Division 81 · minyonglee1(ADMIN) 로 Insert Row 시 FCST Type 에 ADMIN 용 유형이 안 보이고 W/S 유형만 선택 가능
--   화면의 FCST Type 편집 후보 = 콤보 'FcstTypeEditDMF0082'(@divisionId, @sesUserId) 결과. 등록 SQL 의 분기(사내 ZIOUI1 기준):
--     ㉮ division 이 81 계열 **이고** 사용자가 그룹 'DM Planner (W/S)' 를 보유(USE_YN='Y') → W/S 유형(SALES_TYPE_CODE2 ∪ SALES_TYPE_CODE2_ADD)**만**
--     ㉯ 그 외 → 일반 유형(SALES_TYPE_CODE 중 W/S 전용 표시 ATTRIBUTE2='Y' 제외)
--     ⇒ ADMIN 과 'DM Planner (W/S)' 를 **둘 다** 가진 사용자는 81 에서 ㉮ 로 빠져 W/S 유형만 나온다 (ADMIN 보유 여부는 보지 않는다)
--   [G1] 사용자의 보유 그룹   [G2] 등록 SQL 상태(수정자·시각·분기 문구 유무)   [G3] 81 에서 이 사용자가 받는 후보 재현
--   [G4] 판정   [G5] 원천 룩업 3종 내용
--   다른 사용자·division 을 볼 때는 DEFINE 2줄만 변경
-- =============================================================================
SET LINESIZE 200
SET PAGESIZE 500
SET TRIMSPOOL ON
SET VERIFY OFF
SET DEFINE ON
DEFINE P_USER = 'minyonglee1'
DEFINE P_DIV  = '81'
COLUMN CHK FORMAT A6
COLUMN USER_GR_ID FORMAT A30
COLUMN SQL_ID FORMAT A30
COLUMN WHO FORMAT A14
COLUMN BRANCH FORMAT A26
COLUMN CODE FORMAT A16
COLUMN NAME FORMAT A40
COLUMN LOOKUP_TYPE FORMAT A22
COLUMN JUDGE FORMAT A150
SPOOL V09_FCSTTYPE_COMBO_CHECK_OUT.txt

PROMPT ################ [G1] ⭐ &P_USER 의 보유 그룹 ################
SELECT 'G1' CHK, G.USER_GR_ID, G.USE_YN, SUBSTR(G.LAST_UPDATED_BY,1,14) WHO, TO_CHAR(G.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD,
       CASE WHEN G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y' THEN '<< 81 에서 W/S 유형만 나오게 하는 그룹' END NOTE
  FROM SCM_ADM_USER_GR_MPG_M G
 WHERE G.USER_ID = '&P_USER'
 ORDER BY G.USER_GR_ID;

PROMPT ################ [G2] 콤보 등록 SQL 상태 ################
SELECT 'G2' CHK, M.SQL_ID, M.USE_YN, SUBSTR(M.LAST_UPDATED_BY,1,14) WHO, TO_CHAR(M.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD,
       LENGTH(M.SQL_DTL_CTN) LEN,
       CASE WHEN M.SQL_DTL_CTN LIKE '%DM Planner (W/S)%' THEN 'Y' ELSE 'N' END HAS_WS_BRANCH,
       CASE WHEN M.SQL_DTL_CTN LIKE '%ADMIN%' THEN 'Y' ELSE 'N' END HAS_ADMIN_BRANCH
  FROM SCM_ADM_CMBO_SQL_M M
 WHERE M.SQL_ID IN ('FcstTypeEditDMF0082','FcstTypeByUserGroupDMF0082')
 ORDER BY M.SQL_ID;
PROMPT --  사내 기준: 두 SQL 모두 HAS_WS_BRANCH = Y · HAS_ADMIN_BRANCH = N (ADMIN 보유 여부를 보는 분기가 없다)

PROMPT ################ [G3] ⭐ 재현 — &P_USER 가 division &P_DIV 에서 받는 FCST Type 편집 후보 (사내 등록 SQL 과 같은 분기) ################
SELECT 'G3' CHK, X.BRANCH, X.CODE, X.NAME, X.DISPLAY_SEQ
  FROM (SELECT '㉮ W/S 유형' BRANCH, L.SEGMENT1 CODE, L.SEGMENT2 NAME,
               CASE L.LOOKUP_TYPE WHEN 'SALES_TYPE_CODE2' THEN L.DISPLAY_SEQ ELSE 100 + L.DISPLAY_SEQ END DISPLAY_SEQ
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.LOOKUP_TYPE IN ('SALES_TYPE_CODE2','SALES_TYPE_CODE2_ADD') AND L.VALID_YN = 'Y'
           AND '&P_DIV' LIKE '81%'
           AND EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M G WHERE G.USER_ID = '&P_USER' AND G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y')
        UNION ALL
        SELECT '㉯ 일반 유형', L.SEGMENT1, L.SEGMENT2, L.DISPLAY_SEQ
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND L.VALID_YN = 'Y' AND NVL(L.ATTRIBUTE2,' ') <> 'Y'
           AND NOT ('&P_DIV' LIKE '81%'
                    AND EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M G WHERE G.USER_ID = '&P_USER' AND G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y'))) X
 ORDER BY X.DISPLAY_SEQ, X.CODE;

PROMPT ################ [G4] ⭐⭐ 판정 ################
SELECT 'G4' CHK,
       CASE WHEN ADM = 1 AND WS = 1 AND '&P_DIV' LIKE '81%'
              THEN '원인 확인 — &P_USER 는 ADMIN 과 DM Planner (W/S) 를 둘 다 보유. 등록 SQL 은 81 에서 W/S 보유만 보고 W/S 유형만 준다 (ADMIN 은 판정에 없음)'
            WHEN ADM = 1 AND WS = 0
              THEN '그룹 원인 아님 — &P_USER 는 DM Planner (W/S) 미보유(또는 USE_YN<>Y). 일반 유형이 나와야 한다 → [G2] 등록 SQL 이 사내와 다른지 확인'
            WHEN ADM = 0 AND WS = 1
              THEN '&P_USER 는 ADMIN 미보유 · W/S 만 보유 → 81 에서 W/S 유형만 나오는 것이 설계 동작'
            ELSE '&P_USER 는 ADMIN·W/S 모두 미보유 → 일반 유형이 나와야 한다' END JUDGE
  FROM (SELECT NVL(MAX(CASE WHEN USER_GR_ID = 'ADMIN' AND USE_YN = 'Y' THEN 1 END),0) ADM,
               NVL(MAX(CASE WHEN USER_GR_ID = 'DM Planner (W/S)' AND USE_YN = 'Y' THEN 1 END),0) WS
          FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = '&P_USER');

PROMPT ################ [G5] 원천 룩업 — 유형 목록 3종 ################
SELECT 'G5' CHK, L.LOOKUP_TYPE, L.SEGMENT1 CODE, L.SEGMENT2 NAME, L.DISPLAY_SEQ, L.ATTRIBUTE2 WS_ONLY, L.VALID_YN
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
 WHERE L.LOOKUP_TYPE IN ('SALES_TYPE_CODE','SALES_TYPE_CODE2','SALES_TYPE_CODE2_ADD')
 ORDER BY L.LOOKUP_TYPE, L.DISPLAY_SEQ, L.SEGMENT1;

PROMPT ################ [G6] ADMIN 과 DM Planner (W/S) 를 함께 보유한 사용자 (같은 증상 대상) ################
SELECT 'G6' CHK, G.USER_ID
  FROM SCM_ADM_USER_GR_MPG_M G
 WHERE G.USE_YN = 'Y' AND G.USER_GR_ID IN ('ADMIN','DM Planner (W/S)')
 GROUP BY G.USER_ID HAVING COUNT(DISTINCT G.USER_GR_ID) = 2
 ORDER BY G.USER_ID;

SPOOL OFF
PROMPT =============================================================================
PROMPT  V09 완료 → V09_FCSTTYPE_COMBO_CHECK_OUT.txt 회신 ([G1] 보유 그룹 · [G3] 재현 목록 · [G4] 판정이 핵심)
PROMPT =============================================================================
