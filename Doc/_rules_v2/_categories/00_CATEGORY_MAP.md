# 00_CATEGORY_MAP — 룰 카테고리 총괄 맵 / Rule Category Map

> **신설**: 2026-07-30 (사용자 요구 — "관련되는 RULE 을 모아서 관리함으로써 적용할 때 오류를 줄이고자")
> **목적**: 기존 트리거 매트릭스(작업 유형 T01~T20)와 **직교하는 주제 축** — "UI 디자인 관련 룰 전부"처럼 주제로 모아 열 수 있게 한다.
> **원칙**: ①카테고리 파일 = **포인터 인덱스** (hook 본문 이동/복제 없음 — 단일 진실 소스 유지) ②카운트 단일 소스 = RULESET_MASTER §4 (본 폴더는 카운트 비보유) ③다중 소속 허용.

## 카테고리 12종

| 코드 | 파일 | 주제 | 연다: 언제? |
|---|---|---|---|
| 01 | [01_ui_design_layout.md](01_ui_design_layout.md) | UI 디자인·레이아웃 | 배치/높이 36px/헤더 48px/3색/No.코너/아이콘 버튼 |
| 02 | [02_auth_edit_control.md](02_auth_edit_control.md) | 권한·Edit 제어 | hasButton/EDIT_YN/editLock/권한 게이트 3형 |
| 03 | [03_grid_column_meta.md](03_grid_column_meta.md) | Grid·컬럼 메타·Wijmo | DataGrid/SHEET_COLUMNS/PIVOT/머지/titleset |
| 04 | [04_search_condition_combo.md](04_search_condition_combo.md) | 조회조건·콤보·cascade | 카탈로그 #112·#117/cascade/SearchArea/lookup·CMBO |
| 05 | [05_popup_modal.md](05_popup_modal.md) | 팝업·모달·라우팅 | 공용 popup 5파일/CustomDialog/Router 등록 |
| 06 | [06_screen_architecture.md](06_screen_architecture.md) | 화면 골격·타입·명명·런타임 | 4-Layer/MDI/d.ts SSOT/naming/런타임 사고 |
| 07 | [07_i18n_msg.md](07_i18n_msg.md) | i18n·MSG/LBL | 채번 3점 동시/재사용 실값 검증/#114 |
| 08 | [08_admin_meta_wiring.md](08_admin_meta_wiring.md) | admin 메타·배선 | API_M/BTN_MPG/PROC_M/GRANT/임의생성 금지 |
| 09 | [09_sp_db_conversion.md](09_sp_db_conversion.md) | SP·DB 변환·성능 | MSSQL→Oracle 함정/성능/SAVE 무결성 |
| 10 | [10_diagnosis_troubleshoot.md](10_diagnosis_troubleshoot.md) | 진단·트러블슈팅 | 증상→룰 역인덱스 (0행/hang/클라우드만 실패…) |
| 11 | [11_asis_parity.md](11_asis_parity.md) | AS-IS 분석·정합 | 4축 매핑/원소스 전량 Read/분석서 표준 |
| 12 | [12_process_ops.md](12_process_ops.md) | 프로세스·운영·배포 | 게이트 3종/사내 적용/이관 패키지/git/로컬 |

## 전수 분류표 (hook 122 — 커버리지 검증 원장)

> 형식: `#번호 hook파일명 → 소속 카테고리(첫 번째 = 주 소속)`. RULESET_MASTER §4 번호 체계.

| # | Hook | 카테고리 |
|---:|---|---|
| 1 | asis-button-mapping | 11 |
| 2 | asis-coverage-check | 02, 11 |
| 3 | asis-msg-inventory | 07 |
| 4 | be-infrastructure-reuse | 09 |
| 5 | cascade-combo-filter | 04 |
| 6 | cascade-pattern-check | 04 |
| 7 | column-lookup-meta-standard | 03 |
| 8 | column-meta-rework-checklist | 03 |
| 9 | components-folder-pattern | 06 |
| 10 | datagrid-shared-component-mandatory | 03 |
| 11 | db-corporate-apply | 12 |
| 12 | db-error-asis-cross-check | 10 |
| 13 | db-schema-divergence-check | 12 |
| 14 | deploy-package-completeness | 12 |
| 15 | destructive-git-ops | 12 |
| 16 | fe-cloud-type-lint-readiness | 06 |
| 17 | file-write-fallback | 12 |
| 18 | grid-cell-interaction-patterns-mandatory | 03 |
| 19 | grid-column-meta | 03 |
| 20 | grid-column-setting-popup-pattern | 03, 05 |
| 21 | grid-interaction-patterns | 03 |
| 22 | i18n-ko-en-alignment | 07 |
| 23 | localstorage-persist-pattern | 06 |
| 24 | menu-button-dynamic-fetch | 02 |
| 25 | menu-not-displayed-debug | 10 |
| 26 | messaging-api-and-search-fields-mandatory | 04, 05 |
| 27 | modal-callback-cascade-check | 05 |
| 28 | mutation-onsuccess-defaults | 06 |
| 29 | oracle-cmbo-varname-quote | 04, 09 |
| 30 | oracle-db-workflow | 09, 10 |
| 31 | oracle-sp-perf-anti-patterns | 09 |
| 32 | pivot-dynamic-column-nvl | 09 |
| 33 | popup-asis-analysis | 05, 11 |
| 34 | popup-dialog-layout | 01, 05 |
| 35 | popup-modal-and-routing-mandatory | 05 |
| 36 | post-write | 12 |
| 37 | pre-submit | 12 |
| 38 | pre-write | 12 |
| 39 | proc-meta-signature-match | 08 |
| 40 | react-query-foundation-reexport | 06 |
| 41 | regression-zero-mandatory | 06 |
| 42 | relative-import-order | 06 |
| 43 | runtime-error-prevention | 06, 10 |
| 44 | scmd-app-grant-mandatory | 08, 12 |
| 45 | screen-additional-skills-mandatory | 06 |
| 46 | screen-completion-gate | 12 |
| 47 | screen-conventions-mandatory | 06 |
| 48 | screen-create-checklist | 06 |
| 49 | screen-entry-asis-baseline | 06, 11 |
| 50 | screen-meta-and-permissions-mandatory | 02 |
| 51 | screen-shell-composition-mandatory | 06 |
| 52 | search-area-extra-conditions | 04 |
| 53 | search-button-when-no-searcharea | 04 |
| 54 | sheet-columns-binding-match | 03 |
| 55 | sp-body-minimal-change | 09 |
| 56 | sp-dual-cursor-pattern | 09 |
| 57 | sp-exception-handler-debug-friendly | 09 |
| 58 | sp-json-table-array-pattern | 09 |
| 59 | sp-no-fake-data-extraction | 09 |
| 60 | sp-patch-file-deploy | 09, 12 |
| 61 | sp-substr-zero-index-audit | 09 |
| 62 | sp-utl-call-stack-safety | 09 |
| 63 | subtitle-button-actions-mandatory | 02 |
| 64 | type-check-error-patterns | 06 |
| 65 | ui-category-setup-column-meta | 03 |
| 66 | ui-dynamic-property-management | 02, 08 |
| 67 | wijmo-flexgrid-entry | 03 |
| 68 | wijmo-insert-cell-dropdown | 03 |
| 69 | wijmo-merge-sticky-content | 03 |
| 70 | screen-runtime-pitfalls-mandatory | 02, 06 |
| 71 | framework-foundation-entry | 06 |
| 72 | mdi-tab-isolation-mandatory | 06 |
| 73 | procedure-dts-ssot-mandatory | 06 |
| 74 | atomic-design-components | 06 |
| 75 | be-api-contract-ui | 08 |
| 76 | code-naming-convention-mandatory | 06 |
| 77 | claude-md-changelog-policy | 12 |
| 78 | ui-category-setup-no-arbitrary-data | 08, 12 |
| 79 | local-server-startup-standard | 12 |
| 80 | sp-cursor-name-response-key | 06, 09 |
| 81 | tab-driven-lazy-fetch | 06 |
| 82 | feature-button-meta-completeness | 02, 08 |
| 83 | search-area-button-position-and-toggle | 01, 04 |
| 84 | sheet-columns-meta-completeness | 03, 08 |
| 85 | sp-inline-function-gtt-mandatory | 09 |
| 86 | issue-feed-rules | 12 |
| 87 | screen-combo-validation-message-mandatory | 01, 04, 07 |
| 88 | issue-log-daily-workflow | 12 |
| 89 | screen-grid-edit-merge-and-meta-mandatory | 02, 03, 07 |
| 90 | figma-layout-parity-mandatory | 01 |
| 91 | sheet-name-asis-preserve-mandatory | 08, 11 |
| 92 | column-division-id-visibility | 03 |
| 93 | grid-multi-tier-header-height | 01 |
| 94 | search-condition-height-uniformity | 01, 04 |
| 95 | grid-cell-backcolor-standard | 01 |
| 96 | column-align-code-standard | 01 |
| 97 | common-button-grid-routing | 02, 03 |
| 98 | corp-meta-integrity-and-wiring | 07, 08 |
| 99 | oracle-save-payload-integrity | 09 |
| 100 | get-zero-dup-invisible-diagnosis | 08, 10 |
| 101 | ui-work-entry-playbook | 01, 11, 12 |
| 102 | custom-context-menu-standard | 03 |
| 103 | pivot-header-drilldown | 03 |
| 104 | sp-side-effect-test-gate | 09 |
| 105 | screen-analysis-workbook-standard | 11 |
| 106 | oracle-bulk-clob-buffer | 09 |
| 107 | sp-hang-runaway-loop-diagnosis | 09, 10 |
| 108 | ui-grid-corner-no-header | 01 |
| 109 | oracle-nls-implicit-conversion | 10 |
| 110 | sp-multiselect-filter-and-conversion-pitfalls | 09 |
| 111 | oracle-sp-perf-correlated-setbased-and-live-redeploy | 09 |
| 112 | search-condition-asis-tobe-catalog | 04, 11 |
| 113 | ui-category-division-direct-compare | 03 |
| 114 | msg-id-asis-tobe-conversion | 07, 11 |
| 115 | titleset-cache-immunization | 03 |
| 116 | sp-parallel-dml-txn-guard | 09 |
| 117 | search-condition-datasource-asis-parity | 04, 11 |
| 118 | mssql-ci-collation-parity | 09 |
| 119 | oracle-null-sentinel-and-notnull-default | 09 |
| 120 | ui-title-icon-buttons-standard | 01 |
| 121 | form-common-styles-mandatory | 01, 04 |
| 122 | cloud-ui-db-object-fetch | 12, 08 |

## 커버리지 검증 (신규 hook 등재 시 재실행 의무)

신규 hook 신설 시 3곳 동시: ①RULESET_MASTER §4 ②00_INDEX §B.3 ③**본 맵 + 해당 카테고리 파일**.

```bash
# 맵에 없는 hook 파일 검출 (기대: 출력 없음 — 캐노니컬 검증)
for f in $(ls Doc/_rules_v2/hooks/ | sed 's/\.md$//'); do
  grep -q "| $f |" Doc/_rules_v2/_categories/00_CATEGORY_MAP.md || echo "MISSING: $f"
done
# hook 파일 수 (RULESET_MASTER §4 카운트와 동일해야 함)
ls Doc/_rules_v2/hooks/*.md | wc -l
```
> 2026-07-30 검증 실측: 120 파일 / MISSING 0.

## 비-hook 룰 자산의 카테고리 귀속 (참고)

| 자산 | 주 카테고리 |
|---|---|
| `anti-simplification.md` | (전 카테고리 상위 — 불변 최우선) |
| TO-BE 정밀 01~05(구조·상수) | 06 |
| TO-BE 06(search)/07(grid)/08(column) | 04 / 03 / 03 |
| TO-BE 09(subtitle)/10(popup)/13(routing) | 02 / 05 / 05 |
| TO-BE 11(BE)/12(metadata) | 09 / 08 |
| AS-IS Framework 7종 | 11 |
| `_mapping/asis_to_tobe.md`(격차 10)/`search_conditions_scp_dm.md` | 11 / 04 |
| 룰 v1: 02/28(git)·21(진단)·22/29/30(배포·환경)·31(Figma)·32(Oracle 도구) | 12 / 10 / 12 / 01 / 09·10 |
