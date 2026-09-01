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

## 전수 분류표 (hook 126 — 커버리지 검증 원장)

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
| 70 | screen-runtime-pitfalls-mandatory | 02, 06, 05 (P9 CustomDialog customContentArea — 2026-08-06 SYS0017 감사) |
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
| 132 | ui-layout-shell-modal-feedback-standard | 01, 06 |
| 133 | ui-common-testitem-mapping-axis | 01, 06 |
| 135 | excel-form-upload-standard | 01, 05, 08 |
| 122 | cloud-ui-db-object-fetch | 12, 08 |
| 123 | screen-modal-cascade-filter-analysis | 11, 04, 05 |
| 124 | screen-asis-pre-analysis-mandatory | 11, 01, 05 |
| 125 | ui-selfcheck-runtime-mandatory | 12, 02, 05 |
| 126 | verification-completion-honesty | 12, 11, 10 |
| 127 | oracle-nvl-null-antipattern | 09, 10 |
| 128 | auth-by-userid-not-groupid | 02, 08 |
| 129 | oracle-perf-fix-priority-order | 09, 10, 12 |
| 130 | ui-meta-consumption-and-crud-path-coverage | 03, 08, 12 |
| 131 | ui-save-idempotent-readback | 09, 03, 12 |
| 134 | sdm-domain-development-standard | 12, 11, 06 |
| 136 | sp-deploy-verify-target-object | 12, 10 |
| 137 | oracle-load-dedup-and-exception-propagation | 09, 10 |
| 138 | comment-live-code-discrimination | 11, 10, 09 |
| 139 | request-ledger-and-subclause-mapping | 12, 11, 06 |
| 140 | msg-table-cloud-sync-and-insert-only | 08, 09, 12 |
| 141 | wijmo-merge-row-data-only | 01, 02, 12 |
| 142 | ui-meta-dictionary-mandatory | 03, 04, 11 |
| 143 | grid-insert-and-modal-derived-parity | 03, 01, 05 |
| 144 | grid-insert-position-and-filter-contract | 03, 01, 02 |
| 145 | verification-evidence-and-scale | 12, 10, 11 |
| 146 | asis-grid-cell-event-full-extraction | 11, 03, 12 |
| 147 | excel-upload-nls-safe-parsing | 12, 09 |
| 148 | cloud-deploy-silent-failure-gates | 12, 10, 09 |
| 149 | remediation-closure-symptom-reproduction | 12, 10 |

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
> 2026-08-22 **#144 grid-insert-position-and-filter-contract 신설** — 카테고리 03(주)·01·02 / Insert 위치=포커스 세트 **바로 위**(맨앞 삽입 ⛔·anchor 는 행 객체 참조·행 배열은 useMemo 계산) · `FlexGridFilter` 는 화면이 만들지 않고 `<DataGrid gridFilterRef>` 로 위임(wijmo 가 생성자에서 `itemsSourceChanged→clear` 를 걸어 capture→create→restore 순서가 계약) · 신규행은 `keepRowVisibleUnderFilter` 로 필터 예외 등록(복원 이후 effect 에서). §5 에 현행 미준수 11파일 명시.

> 2026-08-22 **#145 verification-evidence-and-scale 신설** — 카테고리 12(주)·10·11 / `구현` 주장 = 파일:라인·백틱 심볼·**백틱 리터럴** 중 최소 1(리터럴 축만이 거짓 `구현` 적발) · 게이트 `verify_mapping_evidence.py` FAIL 0·공란 0 · 인용 없는 서술 = `UNVERIFIABLE`(PASS ⛔) / **기대값에 실측값 대입 ⛔** · FAIL→오탐 재분류 3요건(ⓐ라인 ⓑ**적용범위** ⓒ실존확인) / 선행조건 미성립 = **판정불가**(삽입 실패인데 삭제 PASS ⛔) · 후보는 원장 실키에서 / CRUD 규모 = **SIZE 10,000자**(최대행수 ⛔) / 대조 단위 = 분기·하위문구 · 공란 0

> 2026-08-22 **#146 asis-grid-cell-event-full-extraction 신설** — 카테고리 11(주)·03·12 / AS-IS 그리드 셀 EVENT **전수 추출 → TO-BE 누락 0**(사용자 "절대 누락되지 안되는 영역") · `.Designer.cs` 배선 grep 실측(추정 핸들러명 ⛔) · **주석 제거본**에서만 판정(#138) · 핸들러 전 라인 판독 · 산출물 `events_grid_cell.md`(동작 유형 5종 구분 + 콤보 파라미터 계약) · `ATTRIBUTE2` 대체 ⛔ · 대사표 `EVENT:E-nn` 축 단위 + 근거 필수 · 게이트 G146-1~6
> 2026-08-22 **#143 grid-insert-and-modal-derived-parity 신설** — 카테고리 03(주)·01·05 / Insert 복사 목록=AS-IS InsertRow 1:1(팝업이 읽는 키는 화면 미표시라도 복사) · 셀 모달 파라미터 빈문자('') 금지=`'ALL'` 폴백(SP 0행 실측) · 파생 컬럼 가드는 `'KEY' in row` ⛔ **그리드 컬럼 존재**로 · 코드 컬럼(FPComboBox)에 명칭 주입 ⛔.
> 2026-08-21 **#141 wijmo-merge-row-data-only 신설** — 카테고리 01(주)·02·12 / 병합 판정=행 데이터 전용·상태 혼입 3형 금지·요구문구는 결함신고일 수 있음·수정은 제거(로직 diff 0).
> 2026-08-21 **#140 msg-table-cloud-sync-and-insert-only 신설** — 카테고리 08(주)·09·12 / MSG 클라우드 동기화 고정 절차(A~D·순환치환·언어퇴행) + 이관 시 MSG 축 INSERT(NOT EXISTS) 전용.
> 2026-08-20 **#139 request-ledger-and-subclause-mapping 신설** — 카테고리 12(주)·11·06 / 보완요청 원장·미적용 전제·게이트 REQ 축(러너 섹션 10·G10·#126 (F)).
> 2026-08-07 검증 실측: 123 파일 / MISSING 0. (2026-08-07 SYS0017 감사 보강 — 신설 hook 없음·카운트 불변, #70 에 카테고리 05 추가[P9])
> 2026-08-08 **#126 verification-completion-honesty 신설** — 126 파일 / 카테고리 12(주)·11·10 / MISSING 0.
> 2026-08-07(저녁) **#125 ui-selfcheck-runtime-mandatory 신설** — 125 파일 / 카테고리 12(주)·02·05 / MISSING 0.
> 2026-08-07(오후) **#124 screen-asis-pre-analysis-mandatory 신설** — 124 파일 / 카테고리 11(주)·01·05 동시 등재 / MISSING 0.

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
> 2026-08-23 **#147 excel-upload-nls-safe-parsing 신설** — 카테고리 12(주·프로세스/운영) + 09(Oracle SP). 엑셀 업로드 값 파싱의 NLS·셀서식 의존 제거(사내 정상·클라우드 전건 반려 실사고 계보).
> 2026-08-28 **#148 cloud-deploy-silent-failure-gates 신설** — 카테고리 12(주·이관 패키지 게이트) + 10(클라우드만 실패 진단 순서) + 09(동적 SQL NLS). 룰 본문에만 있고 생성기에 없던 V11 이 재발한 계보.
