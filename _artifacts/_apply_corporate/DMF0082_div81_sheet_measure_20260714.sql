-- =====================================================================================================================
-- DMF0082 Division 81 — SCM_MST_SHEET_MEASURE 81 계열 노출 (2026-07-14, plan: zany-wondering-sundae)
-- 배경: FcstNPrice measure 메타가 DIVISION_ID='40' 14건뿐 (실측 D9) — 81 조회 시 measure 메타 공백.
-- 방식: SHEET_COLUMNS 동일 화면에서 검증된 composite DIVISION_ID 컨벤션 — 기존 40 행의 DIVISION_ID 에 81 토큰 확장.
--       ('40' 토큰 보존 → 40 무회귀. PK/UK 없음 실측이나 신규 행 중복 방지 위해 UPDATE 채택)
-- 대상 10건 = 40의 14건 중 81 적용분. 제외 4건 근거:
--   SCM_FCST / FCST_GAP(MKT vs SCM) : 81 measure 인벤토리에 SCM_FCST 부재 (실측 D3)
--   MKT_AMT_KRW / MKT_AMT_LOC      : 81 MKT_AMT 파생 미사용 (실측 D3, SAVE 81 브랜치 skip)
-- 멱등: WHERE DIVISION_ID='40' 조건 — 재실행 시 0건 갱신.
-- =====================================================================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_MEASURE
SET    DIVISION_ID      = '40,81,81_UC,81_HM,81_ST,81_HD,81_HG',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
WHERE  PROGRAM_ID  = 'DMF0082'
AND    SHEET_NAME  = 'FcstNPrice'
AND    DIVISION_ID = '40'
AND    COLUMN_NAME IN ('MKT_FCST_PP', 'MKT_FCST', 'RTF_SYS_RP', 'BALANCE',
                       'VMI_In_Plan', 'VMI_In_Req', 'VMI_Inv', 'KRW', 'USD', 'LOC');

COMMIT;

-- 검증: 81 토큰 포함 10건 / 40 단독 잔존 4건 (SCM_FCST, FCST_GAP, MKT_AMT_KRW, MKT_AMT_LOC)
SELECT DIVISION_ID, COUNT(*) AS CNT,
       LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO) AS COLS
FROM   SCM_MGR.SCM_MST_SHEET_MEASURE
WHERE  PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice'
GROUP BY DIVISION_ID;
