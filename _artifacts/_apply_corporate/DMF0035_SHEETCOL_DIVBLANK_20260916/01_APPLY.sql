-- [E20260916-DIVBLANK] DMF0035 SHEET_COLUMNS — DIVISION_ID 공백 행 비표시 처리
--   요청: 사용자 지시 2026-09-16 "DMF0035 의 SHEET_COLUMNS 데이터 중 DIVISION 에 값이 비어있으면
--         VISIBLE='N', DEFAULT='N' 처리" (범위 = PROGRAM_ID='DMF0035' 한정, 사용자 재확인)
--   근거: DIVISION_ID 실측값 = CHR(32) 단일 공백(NULL 아님). FE 컬럼메타 SP
--         PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST 의 division 필터
--         `C.DIVISION_ID IS NULL OR INSTR(','||C.DIVISION_ID||',', ','||P_DIVISION_ID||',')>0` 는
--         NULL 만 통과시키므로 공백(' ')행은 **모든 division 에서 이미 제외**된다.
--         그런데 그중 4행이 DEFAULT_FLAG='Y' 라 워터폴 SP 컬럼목록(=SELECT/GROUP BY/PIVOT 축)에는
--         들어가, 화면에 없는 컬럼이 집계 grain 을 쪼개고 있었다([E20260910-GRAINFIX] 와 동일 계보).
--   ⚠ DEFAULT_FLAG 는 공백(' ')이 아니라 'N' 으로 둔다 — 공백이면 VISIBLE='N' 과 결합해
--     '숨은컬럼 arm'(VISIBLE='N' AND RTRIM(DEFAULT_FLAG,' -') IS NULL)에 걸려 되레 재주입된다.
--   멱등: 이미 N/N 인 행은 WHERE 로 제외되어 0건 갱신.
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET VISIBLE_FLAG     = 'N'
     , DEFAULT_FLAG     = 'N'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0035'
   AND TRIM(DIVISION_ID) IS NULL
   AND (VISIBLE_FLAG <> 'N' OR DEFAULT_FLAG <> 'N');
COMMIT;
