-- =====================================================================
-- [DMF0003] 조회 ORA-00918/ORA-00904 통합 근본진단·정정 — titleset 컬럼 캐시 오염
--   증상 계보: 클라우드 조회 시 PKG line ~9248 (OPEN O_RC1 FOR V_SQL_TEXT, 동적 PIVOT) 에서
--     1) ORA-00918 MEASURE ambiguously specified   (중복)
--     2) 해소 후 ORA-00904 "DEPT_ID" invalid identifier  (미생성 컬럼)
--     → 한 컬럼씩 튀어나옴(whack-a-mole). 공통 뿌리는 하나.
--
--   근본원인: 동적 PIVOT 컬럼목록 V_COLUMN = branch①(titleset 사용자컬럼 TYPE='C') + branch②(SHEET_COLUMNS 고정컬럼).
--     V_COLUMN 의 모든 컬럼은 내부 쿼리(MF_BASE)가 실제 산출하는 컬럼이어야 함.
--     클라우드 SCM_MST_TITLESET_USER(사용자 컬럼설정 캐시) 에 '표시컬럼(DEFAULT_FLAG=Y)이 아닌' 컬럼이 섞임:
--       · MEASURE  : SHEET_COLUMNS DEFAULT_FLAG=' '/'-' (고정컬럼=branch②) → titleset 에도 있으면 2회 → ORA-00918
--       · DEPT_ID  : SHEET_COLUMNS DEFAULT_FLAG='N' (비표시, MF_BASE 미산출) → V_COLUMN 유입 시 ORA-00904
--     ⇒ ColumnSetting 저장/마이그레이션으로 비표시 컬럼이 titleset(C) 에 유입된 데이터 오염.
--
--   ★ 사내(정상): titleset(C)=16컬럼 전부 DEFAULT_FLAG='Y'. 오염 0. V_COLUMN 유효집합=26.
--     (16 titleset + 10 고정: DIVISION_ID,DIVISION_ID40,END_CUSTOMER,END_CUSTOMER40,SCM_SITE_ID,SCM_SITE_ID40,
--      PROJECT_CODE,PROJECT_NAME,PROJECT_OWNER,ITEM_ID,ITEM_ID40,NICK_NAME,INCOTERMS,FCST_TYPE,DOM_EXP,PLANT_SITE_ID
--      + GROUP_ID,EDIT_FLAG,NEW_FLAG,BUCKET,MEASURE_GROUP,ATTR1,VMI_STD_DIO,AS_YN,SORT_KEY,MEASURE)
--   ★ 사내 SHEET_COLUMNS(Mkt Fcst): DEFAULT_FLAG 분포 Y=17 / ' '=10 / N=40. (총 67)
-- =====================================================================
DEFINE USERID = 'minyonglee1'

-- ── D1. [핵심·전수] titleset(C) 오염 컬럼 = '표시컬럼(Y)' 아닌 것 (사내=0행) ────────
--     MEASURE / DEPT_ID / 기타 오염이 한 번에 전부 나옴.
SELECT U.COLUMN_NAME, NVL(C.DEFAULT_FLAG,'(orphan)') AS DEFAULT_FLAG, NVL(C.VALID_YN,'-') AS VALID_YN, U.SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_TITLESET_USER U
  LEFT JOIN SCM_MGR.SCM_MST_SHEET_COLUMNS C
    ON C.PROGRAM_ID=U.PROGRAM_ID AND C.SHEET_NAME=U.SHEET_NAME AND C.COLUMN_NAME=U.COLUMN_NAME
 WHERE U.PROGRAM_ID='DMF0003' AND U.SHEET_NAME='Mkt Fcst'
   AND U.USER_ID='&USERID' AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
   AND ( C.COLUMN_NAME IS NULL OR NVL(C.DEFAULT_FLAG,'X') <> 'Y' OR NVL(C.VALID_YN,'N') <> 'Y' )
 ORDER BY U.COLUMN_NAME;

-- ── D2. SHEET_COLUMNS 고정컬럼(branch②) 이 사내(10개)와 다른가 = SHEET_COLUMNS 오염 확인 ──
--     결과가 아래 10개와 다르면(특히 DEPT_ID 등이 blank 로 뜨면) SHEET_COLUMNS DEFAULT_FLAG 도 오염.
--     사내 10개: GROUP_ID,EDIT_FLAG,NEW_FLAG,BUCKET,MEASURE_GROUP,ATTR1,VMI_STD_DIO,AS_YN,SORT_KEY,MEASURE
SELECT COLUMN_NAME, DEFAULT_FLAG, VALID_YN FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
   AND (DEFAULT_FLAG='-' OR DEFAULT_FLAG=' ' OR DEFAULT_FLAG='') AND VALID_YN='Y'
 ORDER BY COLUMN_NAME;

-- ── D3. DEPT_ID 메타 상태 (사내: Mkt Fcst / 'N' / 'Y') ───────────────────────────
SELECT SHEET_NAME, COLUMN_NAME, DEFAULT_FLAG, VALID_YN FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND COLUMN_NAME='DEPT_ID';

-- =====================================================================
-- 정정 (D1 결과 = 오염 컬럼 전부 제거). 사내에서 무영향 검증됨(16컬럼 전부 Y).
--   원리: titleset(C) 에는 '선택형 표시컬럼(DEFAULT_FLAG=Y & VALID_YN=Y)' 만 남긴다.
--   삭제 후 재조회 시, titleset 가 남아있으면 그대로, 전부 지워졌으면 DEFAULT_FLAG='Y' 기준 자동 재생성.
-- =====================================================================
-- [해당 사용자만]
-- DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER U
--  WHERE U.PROGRAM_ID='DMF0003' AND U.SHEET_NAME='Mkt Fcst'
--    AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
--    AND U.USER_ID='&USERID'
--    AND U.COLUMN_NAME NOT IN (
--        SELECT C.COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
--         WHERE C.PROGRAM_ID='DMF0003' AND C.SHEET_NAME='Mkt Fcst'
--           AND C.DEFAULT_FLAG='Y' AND C.VALID_YN='Y');
-- COMMIT;
--
-- [전 사용자 대상 — 같은 오염이 여러 계정에 있을 때: 위에서 USER_ID 줄만 제거]
--
-- 검증: 위 삭제 후 D1 을 재실행 → 0행이면 해소. 화면 재조회로 최종 확인.
--
-- ⚠ 만약 D2 에서 branch② 고정컬럼이 사내 10개와 다르면(SHEET_COLUMNS 오염) → titleset 정정만으로 부족.
--    그 경우 클라우드 SHEET_COLUMNS(DMF0003/Mkt Fcst) DEFAULT_FLAG 를 사내값(Y=17/' '=10/N=40)으로 동기화 필요.
--    (예: DEPT_ID 가 blank 로 떠 있으면  UPDATE ... SET DEFAULT_FLAG='N' WHERE COLUMN_NAME='DEPT_ID' ...)
-- =====================================================================
