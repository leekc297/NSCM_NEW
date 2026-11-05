# DMF0049 FHD 월 칸 미표시 보완 — 고정 칸 해제(AS-IS 일치) · 2026-11-04

- 작업 모드: DB MODE(DB_ONLY) — META 1행 수정
- 사용자 결정 (2026-11-04 23:3x): "AS-IS대로 고정 해제"

## 근거 (실측)

- **TO-BE (사내 ZIOUI1):** `SCM_MST_SHEET_COLUMNS` DMF0049 'MDF Reports'의 MEASURE 칸이 FIXED_FLAG='Y'입니다(수정 기록 hmyong 2024-02-02 14:27:18).
  - 공용 DataGrid는 고정 칸 수를 "FIXED_FLAG='Y'인 마지막 칸의 순번 + 1"로 정합니다. 그래서 왼쪽 20칸(1,930px)이 고정되는데, 그리드 표시 폭은 1,543px(창 1920)입니다.
  - 그 결과 스크롤 영역이 그려지지 않아 월 칸이 보이지 않고 편집할 수도 없었습니다(검증 T54 · 11-04 21:1x).
- **AS-IS (MSSQL 운영 DB 직접 조회):** DMF0049 칸 42개의 FIXED_FLAG가 모두 빈 값입니다. MEASURE 행도 '', 수정 기록 hmyong 2024-02-02 14:27:18로 TO-BE와 같습니다.
  - AS-IS 프레임워크 규칙도 TO-BE와 같습니다(`SpreadInfo.cs:1658` — FIXED_FLAG='Y'인 마지막 칸까지 고정). 따라서 AS-IS 화면에는 고정 칸이 없었습니다.

## 적용 (사내 ZIOUI1 · SCM_MGR)

| 순서 | 작업 | 결과 |
|---|---|---|
| 1 | 대상 행 새로 조회·백업 → `00_BACKUP_ROW.json` (FIXED_FLAG 'Y' · hmyong · 2024-02-02 14:27:18 · 조회 23:39:02) | — |
| 2 | 적용 직전 재조회 일치 확인(FRESH-GATE) → `UPDATE … SET FIXED_FLAG='N', LAST_UPDATED_BY='SYSTEM', LAST_UPDATE_DATE=SYSDATE WHERE PROGRAM_ID='DMF0049' AND SHEET_NAME='MDF Reports' AND COLUMN_NAME='MEASURE'` | 1행 · COMMIT 23:39:02 |
| 3 | 확인: DMF0049 FIXED_FLAG='Y' 0행 | PASS |
| 4 | 화면 확인 (창 1920 · hongjae.kim Div 40 · 저장 없음) | 월 칸이 그려지고 편집 판정 측정 가능. 2026-09·10 잠김, 2026-11·12 편집 가능 = 화면 판정 함수(evalEtcReportCell)와 일치 |

**원복 방법:** `UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET FIXED_FLAG='Y' WHERE PROGRAM_ID='DMF0049' AND SHEET_NAME='MDF Reports' AND COLUMN_NAME='MEASURE'; COMMIT;`

## 클라우드 이관 패키지

- 위치: `_artifacts/_deploy_packages/DMF0049_CLOUD_DB_MOD_20261104_2341/` (cloud_pkg 1.1.0 · 사내 리허설 OK · 경고 0)
- 이번 보완이 담긴 파일: `A_DB/30_META_DMF0049.sql` — `SCM_MST_SHEET_COLUMNS` MERGE, MEASURE FIXED_FLAG 'N'
- 클라우드 적용 상태: **미적용**

## 참고

- 자매 화면 DMF0044도 TO-BE에는 FIXED_FLAG='Y'가 4칸(CURRENCY·CURRENCY_UNITCURRENCY·DIVISION_ID·UNIT_CURRENCY) 있고, AS-IS에는 0칸입니다.
- 이번 범위에는 넣지 않았습니다. 보고만 합니다.
