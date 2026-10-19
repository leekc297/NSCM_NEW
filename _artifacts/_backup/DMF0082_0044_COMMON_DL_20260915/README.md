# DMF0082(forecast-price) · DMF0044(sales-reports) 공통소스 최신화 — 2026-09-15

공통 HEAD = `common/main eb32123a` (2026-09-15 16:34). 대상 = 두 화면 폴더 전 파일 73개. 푸시 없음(remote common push = no_push).

| 분류 | 건수 | 처리 |
|---|---:|---|
| SAME | 58 | 로컬 = 공통 HEAD |
| ADOPT | 2 | 로컬 = 공통 이력본 → 공통 HEAD (`forecast-price.combo.ts`, `sales-reports.merge.ts`) |
| ADOPT_RESOLVED | 11 | 3-way 충돌·잔여 확인 결과 **공통이 같은 기능을 이미 반영**(환율 모달 수정자/수정일시, LOC 부분주 폴백, MEASURE 정렬, MSG00680 단일화, BP_M 편집게이트, CELL_PROD_SITE 저장키, Cutoff Delete 숨김 #78) — 로컬 잔여 = 구판·주석·따옴표 포맷 → 공통 HEAD |
| MERGE | 2 | `ForecastPriceGrid.tsx` = 공통 HEAD + `[E20260901-CPSDISP]` 1블록(공통 미반영, 로컬 DataGrid `comboParamExcludes` 전제) / `__asis-mapping__.md` = 로컬 대사표 행 유지 3-way · BOM 제거 |

- 원복: `BACKUP_LOCAL/` (변경 전 로컬 원본, 동일 상대경로) · 충돌 자료: `CONFLICT/` (.common/.base/.merge_conflict/.resolved)
- 분류기: `common_dl.py plan|apply` · 결과: `result.json`
- import 심볼 대조: 두 폴더 전 named import 해석 OK (type-check 미수행 — 요청 시 수행)
- ⚠ 환율 모달 감사 컬럼 헤더가 공통 명칭으로 바뀜: `Updated By`(90) · `Update Date`(130), 순서 By → Date (종전 로컬 `Last Update Date`·`Last Update By`)
