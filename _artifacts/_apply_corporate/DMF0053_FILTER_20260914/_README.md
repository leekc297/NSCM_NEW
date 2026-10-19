# DMF0053 Customer FCST Waterfall — Project / Model / Owner 조회조건 미동작 보완 (2026-09-14)

사내 적용: ZIOUI1 · `PKG_DMF0053` BODY (마커 `E20260914-DMF0053FLT` 3곳) · VALID / 오류 0 · 클라우드 ⛔ 미적용

## 원인
`IF P_PROJECT_CODE / P_ITEM_ID / P_OWNER IS NOT NULL AND <변수> <> '' THEN` — Oracle 은 `''`=NULL 이라 `<> ''` 가 항상 UNKNOWN →
필터 블록이 한 번도 실행되지 않아 값을 넣어도 전체가 조회됐다. AS-IS `IF (@p_... <> '')` 직역 결함.
블록 내부 삭제 조건은 AS-IS(DB 직접 대조, LESDFPSTO1C01/LGCE_SCMDEV)와 동일 — `IF` 조건만 `IS NOT NULL` 로 정정.
본문 전수 스윕: 같은 사문화는 이 3곳뿐.

## 실측 (Div 81, Input Date 09-01~09-14 · 전체 144행)
| 조건 | 수정 전 (A / B / A,B) | 수정 후 |
|---|---|---|
| Project A18BW2003 / A15BW7002 | 144 / 144 / 144 | 32 / 27 / 59 |
| Model APBMW48CL-B1-1Y0 / -A2-7X0 | 144 / 144 / 144 | 8 / 6 / 14 |
| Owner hkslee / JAEHYEOK | 144 / 144 / 144 | 59 / 44 / 103 |

BE API 경로(`/DMF0053/custFcstWaterfall/SEARCH/call-proc`) 결과 값 분포 = 선택 값만 남음 확인.

## 부수 발견 (사내 환경)
사내 `SCMP_APP` 에 `PKG_DMF0053` 시노님 누락(EXECUTE 권한은 존재) → 로컬 BE 에서 DMF0053 조회 자체가 PLS-00201 로 실패하던 상태.
`02_SYNONYM_SCMP_APP_PKG_DMF0053.sql` 로 추가(원복 = DROP SYNONYM). 이번 BODY 수정과 무관한 기존 결함.

## 파일
- `01_PKG_DMF0053_BODY.sql` — 적용본 / `00_BACKUP_PKG_DMF0053_BODY_pre_20260914.sql` — 원복용
- `02_SYNONYM_SCMP_APP_PKG_DMF0053.sql` — 사내 전용(클라우드는 시노님 존재 여부 확인 후 필요 시)
- 러너: `_artifacts/_diagnostics/dmf0053_filter_sweep.py` (before/after json) · `dmf0053_filter_http_after.py`
