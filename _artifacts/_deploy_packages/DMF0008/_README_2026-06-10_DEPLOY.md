# DMF0008 보완 클라우드 적용 패키지 — 2026-06-10

> 본 패키지는 오늘 (2026-06-10) 작업분만 모음. 기존 패키지 (`README.md` 2026-06-05 + `_README_2026-06-10_PATCH.md` 오전) 의 추가 보완.

## 사고 + Fix 요약

| # | 사고 | Root cause | Fix |
|---|---|---|---|
| 1 | 컴포넌트 props mismatch (`rows`/`onDoubleClick` ≠ `data`/`onDblClick`, `gridFilterRef` 누락) | 메인 ErpEdiMaster.tsx 가 옛 명칭으로 sub-grid 호출 | FE — 메인 props 정정 |
| 2 | Form 의 store API mismatch (`searchParams`/`setSummaryFilters`/`fetchStaticColumns`/`updateHistory` 부재) | store 가 옛 명칭 (`searchCondition`/`setFilter`) | FE — store 를 DMF0004 표준으로 보강 (`fetchStaticColumns` 신규 + `updateHistory` state 신규) |
| 3 | `SHEETS.MAIN` (= `'main'`) BE 메타 불일치 | BE 메타 SHT_NM = `'summary'`. `'main'` 부재 | FE — `SHEETS.SUMMARY` 통일 |
| 4 | sessionStorage stale state → DataGrid `.filter` null read | 어제 store schema 가 sessionStorage 에 잔존, 새 selector mismatch | FE — store storageName `erp-edi-master` → `erp-edi-master-v2` |
| 5 | 3단 layout 분리 X (Repair grid wrapper 누락) | flex section wrapper + flex-grow 비율 미적용 | FE — SCSS `.summarySection/.repairSection/.subSection` 신설 + 메인 wrapper |
| 6 | grid column 헤더 미표시 + BE `-9999` error | SHEET_COLUMNS 의 `FIXED_FLAG`/`UPPERCASE_APPLY_FLAG`/`USER_SELECTABLE_FLAG` NULL → BE `GridColumn.of` `.equals("Y")` NullPointerException | **DB — `03_META/110_*.sql` SHEET_COLUMNS NULL flag NVL fix** |

## 적용 순서

### Phase B (META — DB 측 fix)
```
03_META/110_DMF0008_SHEET_COLUMNS_null_flags_fix.sql    (sqlplus 호환)
또는
03_META/110_DMF0008_SHEET_COLUMNS_null_flags_fix_DBeaver.sql  (DBeaver 호환)
검증:
03_META/110_DMF0008_SHEET_COLUMNS_null_flags_fix_Verify.sql   (5 flag NULL count = 0 확인)
```

### Phase E (FE — 소스 배포)
`01_FE/erp-edi-master/` 전체를 cloud FE `nscm-fe/features/master/src/pages/erp-edi-master/` 로 덮어쓰기.

| 파일 | 의도 |
|---|---|
| `ErpEdiMaster.tsx` (306 lines) | composition only, 3단 layout (4:3:3) + Summary/Repair/Sub wrapper |
| `ErpEdiMaster.module.scss` | `.summarySection`/`.repairSection`/`.subSection` (height:0 + flex-grow N) |
| `useErpEdiMasterStore.ts` | DMF0004 표준 — `searchParams` / `setSummaryFilters` / `fetchStaticColumns` (BE 메타 GET) / `updateHistory`. storage v2 |
| `erp-edi-master.constants.ts` | `SHEETS.MAIN` 제거 → `SHEETS.SUMMARY` (BE 메타 일치) |
| `erp-edi-master.types.ts` / `types.ts` | `SearchCondition` 등 |
| `erp-edi-master.empty-rows.ts` / `.utils.ts` | helper |
| `components/ErpEdiMasterForm.{tsx,module.scss}` | SearchArea + FormItem + CustomDropdown (DMF0004 표준) |
| `components/ErpEdiMasterSummaryGrid.tsx` (69 lines) | DataGrid 래퍼 + `staticColumns` store 구독 + dblClick |
| `components/ErpEdiMasterRepairGrid.tsx` (76 lines) | + formatItem 화이트리스트 |
| `components/ErpEdiMasterSalesSiteGrid.tsx` (168 lines) | + Customer/Region/Team 3 modal |
| `components/ErpEdiMasterSspmGrid.tsx` (133 lines) | + Project/Item/Owner 3 modal |
| `components/ErpEdiMasterUpdateHistoryBar.tsx` (29 lines) | UpdateHistory bar |
| `components/modals/` (`.gitkeep`) | 룰 v2 `_tobe/01_file_structure.md §1.5` 의무 폴더 |

### Phase F (검증)
1. Hard refresh (F5) — sessionStorage v2 reset
2. DMF0008 진입
3. Network: `POST /admin/menu/DMF0008/column` 4건 (sheetNm=summary/repair/salesSite/sspm) 모두 status=200 + result 행 수 (5/22/25/69)
4. 시각: 3단 분리 + 각 grid column 헤더 표시
5. Network: `POST /DMF0008/summary/SEARCH/call-proc` 자동 호출 + 데이터 표시
6. 동작: Summary dblClick → Repair refetch / Repair dblClick → SalesSite + SSPM refetch

## 합격 기준

| Phase | 기준 |
|---|---|
| B | 110 SQL POST-CHECK 의 5 flag NULL count = 0 |
| E | 17 file 모두 sync (FE) |
| F | 4 grid 모두 column + 데이터 표시 + 콘솔 0 error |

## 룰 보강 (별도 git commit — cloud 무관)

- `Doc/_rules_v2/hooks/components-folder-pattern.md §7` — Sub-component Props 표준 (Grid/Form/Modal + store 명칭) 신설

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-05 | 초기 패키지 (40 file) — `README.md` |
| 2026-06-10 오전 | `03_META/100_*` PROC_M O_RESULT_CURSOR boost (3 file) + FE 4 grid sub-component 분리 — `_README_2026-06-10_PATCH.md` |
| 2026-06-10 오후 | **6 사고 종합 fix** — store DMF0004 표준 / 3단 layout / SHEETS.SUMMARY / sessionStorage v2 / SHEET_COLUMNS NULL flag NVL — 본 README |
