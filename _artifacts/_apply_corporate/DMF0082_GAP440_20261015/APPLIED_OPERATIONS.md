# DMF0082_GAP440_20261015 — 사내 ZIOUI1 적용 기록

- 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` O_RC2(월 칸 잠금 경계) `M3_CUTOFF_DATE` 1식 (마커 `[GAP440 2026-10-15]`)
- 변경: `ADD_MONTHS(TRUNC(TO_DATE(MIN(BASIS_YYYYMMDD)),'MM'),3)`(조회 월별) → `ADD_MONTHS(TRUNC(SYSDATE,'MM'),3)`(오늘 월 기준, AS-IS 동일)
- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR · 착수 기준본 LAST_DDL 2026-10-15 11:34:15 · FRESH-GATE 통과 후 적용 · VALID / 오류 0

## 검증 (minyonglee1, Div 81, Current, ~20270331, O_RC2 첫 행 = FE 잠금 경계월)
| 조회 시작 | 수정 전 | 수정 후 |
|---|---|---|
| 2026-07-01 | 202610 | 202701 |
| 2026-09-01 | 202612 | 202701 |
| 2026-11-01 | 202702 | 202701 |
