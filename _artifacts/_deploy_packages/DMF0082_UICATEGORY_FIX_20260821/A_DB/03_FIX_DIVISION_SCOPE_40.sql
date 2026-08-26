-- ============================================================================
-- [F3] div 40 범위 누락 3컬럼 : DIVISION_ID 에 '40' 추가
--
-- 기준 (사용자 지정 2026-08-21, AS-IS 기준)
--   · division 40      → AS-IS **DMF0003 / Mkt Fcst**
--   · division 81·82   → AS-IS **DMF0082 / FcstNPrice**
--
-- 실측
--   · 기준(AS-IS DMF0003) DEPT_ID / DEPT_NAME_KO / GROUP_ID
--       DIVISION_ID = '40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG'  (40 포함) · VISIBLE_FLAG='N'
--   · TO-BE DMF0082 = '81,81_UC,81_HM,81_ST,81_HD,81_HG'        → **40 누락**
--   · AS-IS DMF0082 FcstNPrice 에는 이 3컬럼이 없다(0건) → 81/82 존재분은 TO-BE 확장.
--     따라서 81/82 는 손대지 않고 **40 만** 보충한다.
--
-- DIVISION_ID 는 실제로 소비된다 — SCM_MGR.PKG_NSCM_UI_COM_MENU (BODY L164 / L214):
--   AND (P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL
--        OR INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0)
--   ⇒ 40 으로 진입하면 이 3컬럼이 컬럼 메타에 실리지 않는다.
--
-- 영향: 3컬럼 모두 VISIBLE_FLAG='N'(숨김 캐리어) → 화면 표시 변화 없음. 40 에서만 추가.
-- ============================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DIVISION_ID      = '40,' || DIVISION_ID,
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0082'
   AND SHEET_NAME  = 'FcstNPrice'
   AND COLUMN_NAME IN ('DEPT_ID', 'DEPT_NAME_KO', 'GROUP_ID')
   AND INSTR(',' || DIVISION_ID || ',', ',40,') = 0;   -- 이미 있으면 건너뜀 (멱등)
-- 기대 3행
