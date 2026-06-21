# NSCM RULESET MASTER — 통합 마스터 룰 / Consolidated Master Ruleset

> 작성일 / Date: 2026-06-18 · 짝 문서 / Companion: `00_DIAGNOSIS_진단보고서.md`
> 목적 / Purpose: **TO-BE UI 개발·수정 시 RULE 누락 0** — 전체 룰(UI/DB/SP/BE)의 단일 참조점.
> 형태 / Form: Claude Code 가 그대로 읽을 수 있는 `CLAUDE.md` 호환 구조 (트리거 매트릭스 + hook 카탈로그 + 체크리스트).
>
> **채택 방법 / How to adopt (택1)**:
> 1. 루트 `CLAUDE.md` 에서 본 파일을 1차 로드 대상으로 추가: `Read: Doc/_rules_consolidation/RULESET_MASTER.md`, 또는
> 2. 본 파일 내용을 검토 후 루트 `CLAUDE.md` 로 병합(권장 — 진입점 단일화 R-1).
>
> ⚠️ 본 파일은 **기존 룰의 재정합·인덱스**이며 룰 내용을 새로 만들지 않는다. 각 항목은 기존 `_rules_v2/` 파일을 가리킨다(단일 진실 소스 유지).

---

## §0. 진입 정책 (Entry Policy) — 단일 진입 / Single Entry

작업 시작 시 **아래 4개만 1차 로드**. 나머지는 §2 트리거 매트릭스가 작업 키워드로 분기한다.

```
1. Read: Doc/_rules_v2/anti-simplification.md        ⚠️ 최우선·불변 (단순화 절대 금지)
2. Read: Doc/_rules_consolidation/RULESET_MASTER.md   ← 이 파일 (트리거 + 카탈로그 + UI 체크리스트)
3. Read: Doc/_rules_v2/00_INDEX.md                    ← 상세 카탈로그 (hook 본문 위치)
4. (UI 작업 시) §3 UI-MANDATORY 체크리스트를 PRE-WRITE 로 통과
```

> **카운트 단일 소스**: hook 총수 = **77** (`Doc/_rules_v2/hooks/*.md` 실측, 2026-06-20). 어떤 문서든 카운트를 별도 보유하지 말 것 — 본 파일 §4 와 00_INDEX 만 카운트를 가진다. (진단 R-2)
> ⚠️ **CLAUDE.md §15 직접 entry 추가 금지** (hook #77 `claude-md-changelog-policy`): 변경 이력은 monthly archive 에 1-line / 상세는 `Doc/_archive/work_reports/{YYYY-MM-DD}_{topic}.md`.

---

## §1. 핵심 원칙 3 / Three Core Principles

| # | 원칙 | 의미 |
|---|---|---|
| 1 | **한 사람이 개발한 것처럼** / "As if one developer" | 신규 코드 = reference 화면(DMF0004~0007) 의 폴더/import/명명/주석 스타일과 100% 동일 |
| 2 | **AS-IS 한 줄도 누락 없음** / "Zero AS-IS omission" | AS-IS `.cs/.Designer.cs` 정밀 read → Event/API/Validation/Expression/Button 1:1 매핑. 누락 1건 = anti-simplification 위반 |
| 3 | **공용으로 끌어올리기** / "Lift to shared" | 공용 후보는 `@shared/components` · `@foundation/*` 로 승격. 단, **shared default 변경은 절대 금지**(분리 PR) |

> 최상위 룰: `anti-simplification.md` 는 다른 모든 룰을 압도한다. "모두/전체/정밀/상세" 요청 = 다중 패턴 + Cross-check 의무.

---

## §2. 트리거 매트릭스 / Trigger Matrix (작업 키워드 → 룰 + Hook)

> ⭐⭐⭐ = PR 차단 강제 등급 / PR-blocking · ⭐⭐ = master 통합 진입 / integrated entry · ⭐ = 강조 / emphasized
> **UI 작업은 T01(신규)·T01M(수정)·T04·T05·T06·T07·T09 + §3 체크리스트가 핵심.**

| T# | 트리거 키워드 | 필독 룰 (`_tobe`,`_asis`) | 핵심 Hook |
|---:|---|---|---|
| **T01** | 신규 화면 / DMFxxxx 생성 / 화면 추가 | `_tobe/01~10` 전부 + `_asis/00_framework/01~07` + `_asis/02_screens/__TEMPLATE__` + **`Doc/03.Framework` 공식 FE 설계서/인수인계서** | ⭐⭐⭐ **framework-foundation-entry(아키텍처 진입)** · **mdi-tab-isolation-mandatory** · **procedure-dts-ssot-mandatory** · atomic-design-components + screen-conventions-mandatory · screen-shell-composition-mandatory · regression-zero-mandatory · datagrid-shared-component-mandatory · screen-meta-and-permissions-mandatory · screen-additional-skills-mandatory + ui-dynamic-property-management(master) + menu-button-dynamic-fetch + ui-category-setup-column-meta + screen-create-checklist + screen-entry-asis-baseline + components-folder-pattern + pre-write/post-write + **screen-completion-gate(종료)** |
| **T01M** | **기존 화면 수정 / column 재작업 / 속성 변경** | 해당 화면 룰 + `_tobe/08_column_meta` | ⭐⭐⭐ **regression-zero-mandatory**(Hard Boundary) + **column-meta-rework-checklist**(8 점검) + datagrid-shared-component-mandatory + pivot-dynamic-column-nvl + screen-completion-gate |
| **T02** | AS-IS 화면 분석 / .cs 분석 | `_asis/02_screens/__TEMPLATE__` + `_asis/00_framework/01_BaseForm` | popup-asis-analysis |
| **T03** | Popup 분석 / popup 매핑 | `_asis/01_popups/__POPUP_TEMPLATE__` + `00_inventory` + `_tobe/10_popup_modal` | popup-asis-analysis |
| **T04** | Grid / DataGrid / 컬럼 메타 / dropdown / lookup / column setting popup / drill-down | `_tobe/07_datagrid` + `08_column_meta` + `09 §12` + `Doc/wijmo-flexgrid-guide` + `-api-reference` | ⭐⭐⭐ datagrid-shared-component-mandatory · grid-cell-interaction-patterns-mandatory + grid-column-meta + ui-category-setup-column-meta + column-lookup-meta-standard + grid-column-setting-popup-pattern + grid-interaction-patterns + sheet-columns-binding-match + wijmo-flexgrid-entry(진입) + wijmo-insert-cell-dropdown + wijmo-merge-sticky-content + runtime-error-prevention |
| **T05** | 조회조건 / SearchArea / Form / combo / cascade / dropdown reset | `_tobe/06_search_area` + searchFields 카탈로그 | ⭐⭐⭐ messaging-api-and-search-fields-mandatory · cascade-combo-filter · screen-shell-composition-mandatory + search-area-extra-conditions + search-button-when-no-searcharea + cascade-pattern-check |
| **T06** | Modal / Popup / 공용 modal | `_tobe/10_popup_modal` + `01 §1.5(modals/)` | ⭐⭐⭐ popup-modal-and-routing-mandatory + popup-asis-analysis + popup-dialog-layout + modal-callback-cascade-check + components-folder-pattern + grid-column-setting-popup-pattern |
| **T07** | Button / CRUD / SubTitle hotkey / 추가·삭제·저장·sort·filter·condition·reset | `_tobe/09_subtitle_hotkey` + `_asis/00_framework/01_BaseForm` | ⭐⭐⭐ subtitle-button-actions-mandatory · screen-meta-and-permissions-mandatory(권한) + screen-shell-composition-mandatory + asis-button-mapping + search-button-when-no-searcharea |
| **T08** | BE / Controller / Service / SP / cursor / mutation / SAVE SP | `_tobe/11_be_controller_service` + `12_metadata_sql` + **`Doc/03.Framework` BE API javadoc** | ⭐⭐ **oracle-db-workflow(진입)** + ⭐⭐ **be-api-contract-ui(UI 호출 계약)** + be-infrastructure-reuse + asis-coverage-check + procedure-dts-ssot-mandatory + sp-dual-cursor-pattern + mutation-onsuccess-defaults + proc-meta-signature-match + sp-body-minimal-change + sp-utl-call-stack-safety + sp-exception-handler-debug-friendly + sp-no-fake-data-extraction + sp-json-table-array-pattern + sp-patch-file-deploy + scmd-app-grant-mandatory |
| **T09** | 메뉴 안 나옴 / MNU_URL / SHT_NM / 권한 없음 | `_tobe/13_routing_menu` | menu-not-displayed-debug + menu-button-dynamic-fetch |
| **T10** | DB 오류 / ORA-xxxxx / PLS-xxxxx / 데이터 0건 | `_dev_rules/21_TROUBLESHOOTING` + `_tobe/12_metadata_sql` | ⭐⭐ oracle-db-workflow §3 + sp-exception-handler-debug-friendly + sp-substr-zero-index-audit + oracle-cmbo-varname-quote + db-error-asis-cross-check + sp-no-fake-data-extraction + pivot-dynamic-column-nvl |
| **T11** | Figma URL | `_dev_rules/31_FIGMA_DESIGN_INTEGRATION` | (figma-mapping-check — v1) |
| **T12** | Git push / 백업 / 원복 | `_dev_rules/28_GIT_MULTI_REMOTE` + `30_LOCAL_BACKUP_RESTORE` | destructive-git-ops |
| **T13** | CSV 적재 / Oracle 적재 | `_dev_rules/29_LOCAL_DB_CSV_IMPORT` | (없음) |
| **T14** | 서버 기동 | (메모리 `feedback_start_server`) | (없음) |
| **T15** | BaseForm / DataService / 공통 framework | `_asis/00_framework/01~07` | (없음) |
| **T16** | deploy zip / 이관 패키지 | `_dev_rules/22_PACKAGE_ARTIFACTS` | deploy-package-completeness + scmd-app-grant-mandatory + fe-cloud-type-lint-readiness + pre-submit |
| **T17** | G1~G10 격차 신규 구현 | `_mapping/asis_to_tobe.md §2~§6` | pre-submit |
| **T18** | 사내 DB 적용 / 클라우드 동기화 | (메모리 corporate) | oracle-db-workflow §0-F + db-corporate-apply + db-schema-divergence-check + asis-msg-inventory + scmd-app-grant-mandatory + fe-cloud-type-lint-readiness + i18n-ko-en-alignment |
| **T19** | MSSQL 변환 / SP 변환 / PKG 변환 | `Doc/_analysis/db_migration/01_*` + `02_SP_CONVERSION_PIPELINE` | oracle-db-workflow + sp-substr-zero-index-audit + sp-dual-cursor-pattern + proc-meta-signature-match + sp-no-fake-data-extraction + sp-json-table-array-pattern + oracle-sp-perf-anti-patterns + sp-patch-file-deploy |
| **T20** | 화면 완료 / 작업 종료 / 다 됐어 / PR 제출 | (해당 작업 룰) | ⭐⭐ **screen-completion-gate(8 게이트)** → pre-submit |
| **T00** | (모든 작업 공통) | — | pre-write · post-write · pre-submit · file-write-fallback · destructive-git-ops · type-check-error-patterns · react-query-foundation-reexport · relative-import-order |

> **진단 반영(C-3)**: 유지 룰 v1 표는 §5 1곳에서만 보유. T10~T19 의 `_dev_rules/NN` 참조는 §5 표를 단일 출처로 본다.

---

## §3. ⭐ UI-MANDATORY 통합 체크리스트 (TO-BE UI 누락 0 핵심) / UI Mandatory Checklist

> **사용자 핵심 요구 직결**: 신규 화면(T01) · 화면 수정(T01M) 시 **이 한 장만 통과하면 UI 룰 누락이 구조적으로 차단**된다.
> 각 항목 위반 = PR 차단(anti-simplification 동등). 출처 hook 을 괄호에 명시.

### 3.1 PRE-WRITE (작성 직전 — 반드시 먼저)
- [ ] ⭐ **아키텍처 적합성 (framework-foundation-entry)**: 4-Layer 의존방향(foundation←shared←features←web) 위반 0 + feature 간 직접 import 0 + Layer 1/2 는 2-depth alias(deep/relative import 0) + 고정 기술스택 외 라이브러리 임의 도입 0
- [ ] ⭐ **MDI 격리 (mdi-tab-isolation-mandatory)**: 페이지 store = `createPersistedStoreWithTab`(멀티톤, storageName=폴더명) + 데이터 fetch = `useTabProcQuery`(Query Key tabId 포함) + **store 에 조회 결과 data 저장 금지(SSOT — searchParams/filters/UI 상태만)**
- [ ] ⭐ **타입 SSOT (procedure-dts-ssot-mandatory)**: 화면 작성 전 `procedure.d.ts` IN/OUT 정확 작성 → constants 정합 → 제네릭 추론. SP 응답 로컬 재정의 / `any` / `as unknown as` 금지
- [ ] **컴포넌트 재사용 (atomic-design-components)**: `@lges/design-system` + `@shared/components` 카탈로그 우선 검색(중복 작성 금지) + `useDataGridStore`(DEPRECATED) 0
- [ ] **코드 Naming Rule (code-naming-convention-mandatory)**: 함수=동사 camelCase + boolean=`is/has/can` 접두 + 상수=SNAKE_CASE + 미사용 파라미터=`_` 접두 + 축약어 금지 + 파일/폴더 명명 표 준수 + 품질 게이트(Husky pre-push lint+type) 통과
- [ ] **reference baseline 선정**: Tab형=DMF0004 / Panel형=DMF0005 / 단일 grid=DMF0006 중 시나리오 매칭 (screen-conventions-mandatory)
- [ ] **폴더/명명 4 cross-check**: MENU_ID = 폴더명 = `route-paths.ts` = DB `MNU_URL` 동일 (screen-conventions-mandatory §1.2 / popup-modal-and-routing-mandatory)
- [ ] **동적 속성 3종 admin 데이터 확인** — 부재 시 신규 등록 의무 (ui-dynamic-property-management = master):
  - [ ] Menu Button Visible/Enable → SYS0009 매핑 (menu-button-dynamic-fetch)
  - [ ] Column Visible/Width/Lookup/CellType/Label/Scale → admin (ui-category-setup-column-meta)
  - [ ] Measure Code/Label/Sort/Valid → SYS0004
- [ ] **Grid = 공용 DataGrid 만** 사용, FlexGrid JSX 직접 금지 (datagrid-shared-component-mandatory)
- [ ] **Form = SearchArea/FormItem/CustomDropdown**, 2단(6필드) 초과 시 `extraConditions` 분리 (screen-shell-composition-mandatory / search-area-extra-conditions)
- [ ] **SubTitle hotkeyConfig 1 객체**로 11 버튼 자동 매핑 (subtitle-button-actions-mandatory)
- [ ] **권한 분기**: `useTabBtnPermissions` + `hasButton(BTN_CD)` 각 액션 (screen-meta-and-permissions-mandatory)
- [ ] **공용 popup = camelCase 폴더 + 5 파일 + MODAL_XXX(실제 MENU_ID)** (popup-modal-and-routing-mandatory)
- [ ] **cascade**: Division 변경 시 하위 'ALL' reset + Map dedup + useTabComboQueries 1RT (cascade-combo-filter)
- [ ] **messaging**: `useMessageStore`(alert/confirm/yesNoCancel/toast) — `window.alert` 직접 금지 (messaging-api-and-search-fields-mandatory)
- [ ] **i18n 3언어 동시**(KO=EN 값 동일, CN fallback) + `LBL`+5자리 (screen-meta-and-permissions-mandatory / i18n-ko-en-alignment)
- [ ] **import 규약**: `@tanstack/react-query`→`@foundation/query-client` re-export, 상대경로 정렬, `@foundation/lodash` (react-query-foundation-reexport / relative-import-order)
- [ ] **타입 self-check 17 패턴** (type-check-error-patterns)
- [ ] ⭐ **런타임 사고 7종 사전 차단** (screen-runtime-pitfalls-mandatory):
  - [ ] zustand selector 의 `?? []` / `?? {}` fallback 사용 금지 — store 초기값에 stable 참조 명시
  - [ ] `<DataGrid initialized={...}>` 사용 금지 (wrapper 가 호출 안 함, deprecated). ⭐ **모든 wijmo 이벤트 핸들러** (`formatItem` / `cellEditEnded` / `beginningEdit` / `loadedRows` / `cellEditEnding` / `selectionChanged` / `gotFocus`) 등록은 `useEffect` + `gridRef.current` (`internalRef` 단독 금지) + dependency `[staticColumns, dynamicColumns]` (`[]` 1회 금지 — mount 시점 ref undefined → 미등록 사고) + cleanup 의무
  - [ ] Grid row interface 는 `extends WijmoRowItem` + 모든 fields non-optional + 인덱스 시그니처 `string | number` 만
  - [ ] dynamicColumns 의 group + 모든 leaf 객체에 `allowSorting:false`, `allowMerging:false` 명시 + DataGrid `allowMerging` prop 결정 매트릭스 따라 명시
  - [ ] admin 메타 INSERT 작성 전 `desc TABLE_NAME` 으로 NULLABLE='N' 컬럼 인벤토리 확인 + INSERT column list 매핑 (`VALID_YN` 등 누락 방지)
  - [ ] dynamicColumns 의 group + 모든 leaf 객체에 **`height`** 명시 — `HEIGHT_BY_COLUMN_DEPTH` 캐노니컬 정합 (1단=48 / **2단=24** / 3단=16). DataGrid wrapper 가 staticColumns 만 자동 처리 → dynamicColumns 누락 시 wijmo default 48 × N (cell 96 rowspan 사고). DMF0007 wrapper 동작 정합. (`packages/foundation/src/utils/columnMapping.ts:27-29`)
  - [ ] **동적 컬럼 편집 의도** + BE 응답 row 의 `EDIT_FLAG='N'` 환경 → 화면 측 `beginningEdit` 핸들러 등록 의무 (`useEffect` mount + dependency `[staticColumns, dynamicColumns]` + cleanup) + 의도 binding 만 `e.cancel = false` 강제 override. wrapper 의 `setEditableColumns` 가 `isEditableCell` (OPTIONAL/MANDATORY 분기 = `editFlag !== 'N'`) 결과로 cancel 처리 → 동적 컬럼 readonly 사고 (DMF0043 master)

### 3.2 화면 수정(T01M) 추가 점검
- [ ] **Hard Boundary 6종 변경 금지**: `packages/shared` · `foundation` · `lges` · 타도메인 · 타화면 · `nscm-be` (regression-zero-mandatory)
- [ ] **column 재작업 8 점검**: SP NVL / minimal change / patch 종결자 / admin 동기 / binding 매칭 / shared prop / anti-simplification / 사후검증 (column-meta-rework-checklist)
- [ ] **dynamic 컬럼 NVL wrap**: PIVOT NULL → 키 누락 사고 방지 (pivot-dynamic-column-nvl)
- [ ] **공용 prop 추가는 분리 PR** + 4 도메인 regression 0 (regression-zero-mandatory)
- [ ] ⭐ 런타임 사고 7종 (screen-runtime-pitfalls-mandatory) — 신규 화면 동일 적용

### 3.3 POST-WRITE grep (작성 직후 자동 검증)
- [ ] `<FlexGrid` / `<FlexGridColumn` 직접 JSX = 0 (datagrid-shared-component-mandatory)
- [ ] `from 'clsx'` / `from 'lodash'` / `from 'react-i18next'` / `from '@tanstack/react-query'` 직접 = 0
- [ ] `window.alert` / `window.confirm` / raw `alert(` = 0
- [ ] `set({` 즉시 객체 교체(immer draft 아님) = 0 (screen-additional-skills-mandatory)
- [ ] 인라인 `<dialog>` / MUI `<Dialog>` 직접 = 0 (popup-modal-and-routing-mandatory)
- [ ] 진입 Page ≤ 400 라인 (components-folder-pattern)
- [ ] ⭐ 런타임 사고 grep (screen-runtime-pitfalls-mandatory):
  - [ ] `useStore\(s => s\.\w+ \?\? ` = 0 (selector fallback 안티패턴)
  - [ ] `<DataGrid[^/]*initialized=` = 0 (deprecated prop 사용 금지)
  - [ ] Grid row interface 가 `extends WijmoRowItem` 누락된 곳 = 0

### 3.4 종료 게이트 (T20 — 종료 선언 전 8 게이트)
> `screen-completion-gate.md` 의 8 게이트 의무 + 보고 양식:
> ① AS-IS 4축 매핑 ② 버튼 매핑 ③ Grid/Column 메타 ④ 메타·라우팅 ⑤ 정적(type/lint) ⑥ 런타임 smoke ⑦ 표준 정합 ⑧ 이관 패키지
>
> ⭐ **G5 정적 검증 강화 (2026-06-19 DMF0043 회고 후)**: type/lint/build 3종 외 `_artifacts/_local_setup/regression-impact.ps1` 실행 → Hard Boundary 위반 0 / 영향 도메인 / `procedures.d.ts` 변경 여부 보고 의무. 사내 nexus 로컬 차단 환경에서 cross-screen 회귀를 commit 후 발견하는 사고 차단. (regression-zero-mandatory §9)

---

## §4. Hook 카탈로그 (전체 77 / Full Catalog) — 단일 카운트 소스

> 본문 위치: `Doc/_rules_v2/hooks/<name>.md`. 카운트 = **77** (2026-06-20 실측 — #77 claude-md-changelog-policy 신설). 정렬: 파일명 알파벳순(진단 R-4).
> 분류: 🅒 공통 · 🆄 UI/화면 · 🅖 Grid/Wijmo · 🅕 Search/Form · 🅟 Popup/Modal · 🅑 BE/SP/Oracle · 🅓 DB적용/Deploy · 🅖it Git/Infra

| # | Hook | 분류 | 트리거 | 한 줄 요약 |
|---:|---|:--:|---|---|
| 1 | asis-button-mapping | 🆄 | T07 | CRUD 6 + Aux 4 버튼 AS-IS 매핑 |
| 2 | asis-coverage-check | 🆄 | T01/T08 | AS-IS 4축(Event/API/Validation/Expression) 매핑 검증 |
| 3 | asis-msg-inventory | 🅓 | T18 | AS-IS MSG[n] 인벤토리 → To-Be 등록 SQL 절차 |
| 4 | be-infrastructure-reuse | 🅑 | T08/T01 | ⭐⭐ 신규 BE 작성 전 동적 SP 인프라 재사용 검색 의무 |
| 5 | cascade-combo-filter | 🅕 | T05/T04 | ⭐⭐⭐ Division→하위 reset / Map dedup / 1RT / modal callback 5단계 |
| 6 | cascade-pattern-check | 🅕 | T01/T04 | 조회조건·grid cascade 패턴 (룰 07 §2.10) |
| 7 | column-lookup-meta-standard | 🅖 | T04/T07 | ⭐⭐ dropdown=`CELL_COMBO_DATA_TYPE` 위치 / `INPUT_TP_CD` 5종(`MI` 금지) |
| 8 | column-meta-rework-checklist | 🅖 | T01M/T04 | ⭐⭐ 기존 column 재작업 8 점검 |
| 9 | components-folder-pattern | 🆄 | T01/T04/T06 | 진입 Page ≤400라인 + inline grid/dialog JSX 금지 + components/modals 폴더 |
| 10 | datagrid-shared-component-mandatory | 🅖 | T01/T04 | ⭐⭐⭐ 공용 DataGrid + foundation utils 4종 의무, FlexGrid 직접 금지 |
| 11 | db-corporate-apply | 🅓 | T18 | 사내 DB 적용 (docker sqlplus + CRLF 우회 + 카테고리 분류) |
| 12 | db-error-asis-cross-check | 🅑 | T10 | DB 오류 시 AS-IS MSSQL 직접 cross-check |
| 13 | db-schema-divergence-check | 🅓 | T18 | Docker vs 사내 Oracle 8 schema 차이 PRE-CHECK |
| 14 | deploy-package-completeness | 🅓 | T16 | PRE/POST deploy 인벤토리 + 사후 보강 |
| 15 | destructive-git-ops | 🅖it | 전체 | filter-branch/force-push/reset --hard 전 승인 의무 |
| 16 | fe-cloud-type-lint-readiness | 🅓 | T01/T18 | FE 클라우드 type/lint 통과 5 패턴 |
| 17 | file-write-fallback | 🅒 | 전체 | 파일 작성 실패 시 fallback 절차 |
| 18 | grid-cell-interaction-patterns-mandatory | 🅖 | T01/T04 | ⭐⭐⭐ Grid 3 시나리오(A/B/C) + drill-down + 다중 popup + CSV |
| 19 | grid-column-meta | 🅖 | T04 | Grid/Column 메타 14 ctrl + 5 edit type |
| 20 | grid-column-setting-popup-pattern | 🅟 | T01/T04/T06 | ⭐⭐ 사용자 column 표시설정 popup 5단계 + 재진입 복원 |
| 21 | grid-interaction-patterns | 🅖 | T04 | selectionMode + 자동체크 금지 + loadedRows 4 패턴 |
| 22 | i18n-ko-en-alignment | 🆄 | T01/T18 | ⭐ i18n KO=EN 전체 통일 (전 prefix) |
| 23 | localstorage-persist-pattern | 🆄 | T01/T04 | mount 1회 복원 + handleApply 직접 setItem |
| 24 | menu-button-dynamic-fetch | 🆄 | T01/T04/T07 | ⭐⭐ Menu Button Visible/Enable 동적 fetch (ui-dynamic child) |
| 25 | menu-not-displayed-debug | 🆄 | T09 | 메뉴 미표시 7단계 디버깅 |
| 26 | messaging-api-and-search-fields-mandatory | 🅕 | T01/T05/T07 | ⭐⭐⭐ useMessageStore 5 + apiClient 10 + searchFields 14 + CustomDialog 7 size |
| 27 | modal-callback-cascade-check | 🅟 | T06 | modal callback → cascade 전파 |
| 28 | mutation-onsuccess-defaults | 🅑 | T01/T08 | mutate onSuccess override 시 default invalidate+toast 명시 |
| 29 | oracle-cmbo-varname-quote | 🅑 | T08/T10 | CMBO_SQL_M `@varName` → `TO_CHAR()` wrap (ORA-01722 방지) |
| 30 | oracle-db-workflow | 🅑 | T08/T10/T18/T19 | ⭐⭐ Oracle SP/DB 단일 진입점 (8 타입 + 증상→원인) |
| 31 | oracle-sp-perf-anti-patterns | 🅑 | T08/T10/T19 | ⭐⭐ MSSQL→Oracle 6 성능 룰 (REGEXP/split/lookup/index/SARGable) |
| 32 | pivot-dynamic-column-nvl | 🅑 | T08/T10/T19 | ⭐⭐ PIVOT 동적컬럼 NVL wrap (NULL 키 누락 방지) |
| 33 | popup-asis-analysis | 🅟 | T03/T06 | Popup 9 category .cs deep read |
| 34 | popup-dialog-layout | 🅟 | T06 | CustomDialog 잘림·중앙 미표시 방지 |
| 35 | popup-modal-and-routing-mandatory | 🅟 | T01/T13 | ⭐⭐⭐ 공용 popup 5파일 + camelCase + Router 4 cross-check |
| 36 | post-write | 🅒 | 전체 | 작성 직후 grep 검증 |
| 37 | pre-submit | 🅒 | 전체 | PR 제출 직전 통합 검증 (PR 게이트 §6) |
| 38 | pre-write | 🅒 | 전체 | 작성 직전 체크리스트 |
| 39 | proc-meta-signature-match | 🅑 | T08 | PROC_M 행/SORT_ORD = SP ALL_ARGUMENTS positional 일치 |
| 40 | react-query-foundation-reexport | 🅒 | T01/T04 | `@tanstack/react-query` 직접 import 금지 → `@foundation/query-client` |
| 41 | regression-zero-mandatory | 🆄 | T01/T01M | ⭐⭐⭐ Hard Boundary 6종 + 사고 카탈로그 18 + type/lint 0 |
| 42 | relative-import-order | 🅒 | T01/T04 | 상대 import 알파벳/계층 정렬 (ESLint) |
| 43 | runtime-error-prevention | 🆄 | T01/T04/T06 | 사고 사례 사전 차단 |
| 44 | scmd-app-grant-mandatory | 🅑 | T08/T16/T18 | ⭐⭐ SCMD_APP GRANT+SYNONYM 즉시 의무 (-9994 방지) |
| 45 | screen-additional-skills-mandatory | 🆄 | T01 | ⭐⭐⭐ useTranslation/clsx/immer/atomic selector/preSearchParams 9 skill |
| 46 | screen-completion-gate | 🆄 | T01/T20 | ⭐⭐ 화면 종료 8 게이트 + 보고 양식 |
| 47 | screen-conventions-mandatory | 🆄 | T01 | ⭐⭐⭐ 폴더/명명/constants 5/utils/SCSS/ID 정합 (DMF0004~6 master) |
| 48 | screen-create-checklist | 🆄 | T01 | 신규 화면 작성 체크리스트 |
| 49 | screen-entry-asis-baseline | 🆄 | T01 | 신규 화면 진입 AS-IS baseline 4단계 |
| 50 | screen-meta-and-permissions-mandatory | 🆄 | T01/T20 | ⭐⭐⭐ 권한 hook + `__asis-mapping__` + i18n 3언어 + Modal mount |
| 51 | screen-shell-composition-mandatory | 🆄 | T01/T05/T07 | ⭐⭐⭐ Page/Form/Hook/Store 인프라 의무 (DMF0004~6) |
| 52 | search-area-extra-conditions | 🅕 | T01/T04/T05 | ⭐ SearchArea 2단 초과 시 `extraConditions` 분리 |
| 53 | search-button-when-no-searcharea | 🅕 | T05/T07 | SearchArea 부재 시 SubTitle `searchAction` prop |
| 54 | sheet-columns-binding-match | 🅖 | T04/T08 | SHEET_COLUMNS ↔ SP alias 일치, 하드코딩 staticColumns 금지 |
| 55 | sp-body-minimal-change | 🅑 | T08 | SP body 변경 시 원본 1바이트 변경 금지 + 3축 검증 |
| 56 | sp-dual-cursor-pattern | 🅑 | T08 | GET SP `O_RC` + `O_RESULT_CURSOR` dual OUT |
| 57 | sp-exception-handler-debug-friendly | 🅑 | T08/T10 | EXCEPTION OTHERS — 개발=SQLERRM 명시 / 운영=표준+로그 |
| 58 | sp-json-table-array-pattern | 🅑 | T08/T19 | ⭐⭐ SAVE SP `'$[*]'` + cursor + entry/HIST 동시 fix |
| 59 | sp-no-fake-data-extraction | 🅑 | T08/T19/T10 | ⭐⭐ 가짜 구현 18종 금지 + 실추출 교체 |
| 60 | sp-patch-file-deploy | 🅑 | T08/T19/T16 | ⭐⭐ patch 종결자 `END;`+별행 `/` + 의존순서 + fallback |
| 61 | sp-substr-zero-index-audit | 🅑 | T08/T10/T19 | `SUBSTR(s,0,n)` 정규화 결함 audit |
| 62 | sp-utl-call-stack-safety | 🅑 | T08 | `UTL_CALL_STACK.SUBPROGRAM(1)(N)` `.COUNT>=N` 안전체크 |
| 63 | subtitle-button-actions-mandatory | 🆄 | T01/T07 | ⭐⭐⭐ SubTitle 11 버튼 hotkeyConfig 1 객체 자동 매핑 |
| 64 | type-check-error-patterns | 🅒 | T01/T04/T06/T08 | ⭐ FE 17 패턴 self-check (pnpm 호출 없이 grep) |
| 65 | ui-category-setup-column-meta | 🆄 | T01/T04/T07 | ⭐⭐ admin column 메타 동적 fetch + 신규 등록 |
| 66 | ui-dynamic-property-management | 🆄 | T01/T04/T07 | ⭐⭐ **master** — Menu Button + Column + Measure 동적 속성관리 |
| 67 | wijmo-flexgrid-entry | 🅖 | T01/T04/T07 | ⭐⭐ Wijmo 작업 진입점 (가이드 2파일 + 안티패턴 10) |
| 68 | wijmo-insert-cell-dropdown | 🅖 | T04 | Insert cell ComboBox 12단계 1-pass |
| 69 | wijmo-merge-sticky-content | 🅖 | T01/T04 | ⭐⭐ 세로 merge + viewport sticky (CustomMergeManager) |
| 70 | screen-runtime-pitfalls-mandatory | 🆄 | T01/T01M/T04/T05 | ⭐⭐⭐ 런타임 사고 7종 통합 차단 (zustand selector fallback / DataGrid initialized deprecated / WijmoRowItem extends / AllowMerging.All + dynamicColumns 옵션 / admin 메타 NOT NULL / 다단 헤더 row 높이 정합 / **동적 컬럼 EDIT_FLAG='N' 환경에서 `beginningEdit` cancel 우회 (FIFO 마지막 override)** — DMF0043 master, 2026-06-19) |
| 71 | framework-foundation-entry | 🆄 | T01/전체 UI | ⭐⭐⭐ 공식 FE 설계서/인수인계서 준수 진입점 — 4-Layer 의존방향 + import 규율(deep/relative 금지, 2-depth alias) + YAGNI/SoC/SSOT + 고정 기술스택 (2026-06-19 03.Framework 룰화) |
| 72 | mdi-tab-isolation-mandatory | 🆄 | T01/T04/T05 | ⭐⭐⭐ MDI 탭 격리 3축 — UUID tabId 라우팅/unmount + Zustand 멀티톤(createPersistedStoreWithTab) + Query Key [tabId,menuId,params] + IndexedDB persister + store=searchParams only(SSOT) (2026-06-19) |
| 73 | procedure-dts-ssot-mandatory | 🆄 | T01/T07/T08 | ⭐⭐⭐ procedure.d.ts IN/OUT 단일 타입 SSOT — 타입 먼저 작성 후 화면 + constants 정합 + 제네릭 추론 + 로컬 재정의/any 금지 (2026-06-19) |
| 74 | atomic-design-components | 🆄 | T01/T04/T06 | ⭐⭐ 아토믹 디자인 계층(atoms/molecules/organisms) + @lges/design-system 우선 + 공통 컴포넌트·Store·Hooks·Utils 카탈로그 재사용(중복 작성 금지, useDataGridStore DEPRECATED) (2026-06-19) |
| 75 | be-api-contract-ui | 🅑 | T07/T08/T01 | ⭐⭐ BE API javadoc UI 호출 계약 — callProc/combo-muti/lookup-muti/menu auth·동적컬럼 endpoint ↔ apiClient 매핑 + 표준 응답 {code,message,result}/successResponseEntity + @AuthCheck/@SystemLog (2026-06-19) |
| 76 | code-naming-convention-mandatory | 🆄 | T01/전체 FE | ⭐⭐ 코드 Naming Convention + 품질 게이트 (인수인계서 §4 / 설계서 §3 누락 보강) — 변수/함수/상수 Naming Rule(함수=동사 camelCase / boolean=is·has·can / 상수=SNAKE_CASE / 미사용 파라미터=`_` 접두 / 축약어 금지) + 파일·폴더 명명 표 + 품질 자동화 게이트(Husky pre-push lint+type / Vitest / SonarLint / Branch Naming / GitLab CI Fail) (2026-06-19) |
| 77 | claude-md-changelog-policy | 📘 | 전체 (CLAUDE.md 갱신 시) | ⭐⭐ CLAUDE.md 사이즈 다이어트 정책 — §15 entry 직접 추가 금지 + monthly archive (`Doc/_archive/CLAUDE_changelog_YYYY-MM.md`) 1-line 작성 + 상세 = `Doc/_archive/work_reports/{YYYY-MM-DD}_{topic}.md` 별도 보고서 분리. §15 본문 ≤ 5 줄 pointer 만 강제 (2026-06-20) |

> ⚠️ 표 정렬은 파일명 알파벳순이지만 #70~#77 은 등재 시점 보존 위해 표 끝에 배치. 다음 정합 PR 시 알파벳순(atomic-design-components / be-api-contract-ui / claude-md-changelog-policy / code-naming-convention-mandatory / framework-foundation-entry / mdi-tab-isolation-mandatory / procedure-dts-ssot-mandatory / screen-runtime-pitfalls-mandatory)으로 재배치.

> **Retracted (참고)**: `screen-hooks-patterns-mandatory` (구 별도 번호) — 2026-06-18 철회. DMF0004~6 master 에 `hooks/` 폴더 부재. 신규 화면 hooks/ 폴더는 **권장**(필수 아님).

---

## §5. 정적 룰 인벤토리 / Static Rule Inventory

### 5.1 TO-BE 정밀 룰 13 (`Doc/_rules_v2/_tobe/`)
| # | 파일 | 핵심 |
|---:|---|---|
| 01 | file_structure | 폴더/명명 표준 + components 분리 의무 |
| 02 | imports | alias 인벤토리 + 정확 export |
| 03 | main_component | 7 단계 구조 + 5 변형 + 7 금지 |
| 04 | store | createPersistedStoreWithTab + G1 GET |
| 05 | constants | MENU_ID/SHEETS/RESPONSE_SET + LBL 5자리 |
| 06 | search_area | SearchArea/FormItem/CustomDropdown + 카탈로그 13 |
| 07 | datagrid | DataGrid wrapper + EditTracker + 8 금지 |
| 08 | column_meta | `_inputEditType`/`_ctrlType`/`_modalKey` + dynamic util |
| 09 | subtitle_hotkey | 10 키 매핑 + 공통 버튼 표시 정책 |
| 10 | popup_modal | 공용 11종 + CustomDialog + 신규 표준 |
| 11 | be_controller_service | Spring Boot + 보안 + 5 격차 endpoint |
| 12 | metadata_sql | 7-BLOCK + 멱등 INSERT + MSSQL→Oracle |
| 13 | routing_menu | MNU_URL slug + 7단계 디버깅 + UPPR_MNU_ID |

### 5.2 AS-IS Framework 7 (`Doc/_rules_v2/_asis/00_framework/`)
01 BaseForm(6,329L/157method) · 02 DataService(5,261L/87method) · 03 MessageHelper(405L/23 MSG) · 04 Logging(SCM_SYS_LOG) · 05 Auth_FormAuth(보안 의무) · 06 UsrControls(36 컨트롤) · 07 FoxDataClient(WCF→REST)

### 5.3 격차 G1~G10 (`Doc/_rules_v2/_mapping/asis_to_tobe.md`)
신규 구현 8: G1 검색조건 저장/복원 · G2 BigFilter 캐싱 · G3 PerfLog · G4 Batch · G5 File transfer · G6 YesNoCancel · G9 DateRangePicker · G10 MonthPicker. 격차 유지 2: G7 Impersonation · G8 UsrColumnCombo.

### 5.4 유지 룰 v1 (`Doc/_dev_rules/`) — **단일 출처 (진단 C-3 반영)**
| 룰 | 토픽 | UI 관련? |
|---|---|---|
| 02_DEVELOPMENT_RULES | 브랜치/커밋/PR/리뷰 | 절차 |
| 21_TROUBLESHOOTING | Oracle/DBeaver/Wijmo/PowerShell | DB/infra |
| 22_PACKAGE_ARTIFACTS | 이관 패키지 | 절차 |
| 28_GIT_MULTI_REMOTE | 모노레포 + GitHub + GitLab | infra |
| 29_LOCAL_DB_CSV_IMPORT | Docker Oracle CSV 적재 | DB |
| 30_LOCAL_BACKUP_RESTORE | 백업/원복 | infra |
| 31_FIGMA_DESIGN_INTEGRATION | Figma → React | **UI** |
| **32_CLAUDE_ORACLE_DIRECT** | Claude Code Oracle 직결 (SQLcl/oracledb) | DB · ⚠️ 기존 인덱스 미등재 → **여기서 정식 등재**(진단 C-3) |

> 나머지 24 룰(00/01/03~20/23~27) → `_dev_rules/_archive/` (흡수 검증 완료).

---

## §6. 실행 강제 hook vs 문서 hook / Enforced vs Guide Hooks (진단 G-1·C-4 반영)

> **중요**: §4 의 76 hook 중 **프로그램이 자동 차단하는 것은 5종뿐**. 나머지 71종은 "AI 가 읽고 지키는 가이드"다. 수동 편집은 강제되지 않는다 — 용어를 구분한다.

### 6.1 실행 hook (`.claude/settings.json` wiring — 실제 차단)
| 스크립트 | 이벤트 | 강제 | Exit |
|---|---|---|---|
| `attach-context.ps1` | UserPromptSubmit | 키워드→룰 자동 첨부 (비차단) | 0 |
| `block-dev-commands.ps1` | PreToolUse(Bash) | 로컬 pnpm/turbo/eslint 차단 (`ALLOW_PNPM=1` 우회) | deny |
| `check-dbeaver-sql.ps1` | PostToolUse(Write/Edit) | `*_DBeaver*.sql` SQL*Plus 토큰 차단 | 2 |
| `check-notnull-insert.ps1` | PostToolUse(Write/Edit) | 6 테이블 NOT NULL 누락 차단 | 2 |
| `check-fe-import.ps1` | PostToolUse(Write/Edit) | `@shared/*` 금지 import 차단 + `as unknown as` 경고 | 2/1 |

### 6.2 강제 승격 후보 (권고 R-3 — 문서 hook → 실행 hook)
UI mandatory 의 POST-WRITE grep 중 기계 검증 가능한 패턴을 `check-fe-import.ps1` 류로 확장 권장:
`<FlexGrid` 직접 JSX · `from 'clsx'`/`'lodash'`/`'react-i18next'` 직접 · `window.alert(` · `from '@tanstack/react-query'` · 인라인 `<dialog>`. → 수동 작업에도 자동 차단 적용.

### 6.3 OS 커버리지 (권고 R-7)
현재 wiring 은 ps1 전용(Windows). `block-dev-commands.sh` 부재 + sh 미연결 → Linux/클라우드 강제 0. 5종 모두 `.sh` 완비 + settings.json OS 분기 필요.

---

## §7. PR 머지 게이트 / PR Merge Gate (`pre-submit` §0)

```
1. anti-simplification 확인 (단순화 0)
2. UI-MANDATORY §3 체크리스트 통과 (신규 T01 / 수정 T01M)
3. AS-IS 4축 매핑 (__asis-mapping__.md 모든 행 ✅)
4. 메타 SQL 7-BLOCK 등록 + SCMD_APP GRANT
5. 4 파일 SQL 세트 (DBeaver 호환)
6. 격차 G1~G10 적용 (화면별)
7. 빌드/Lint/Type-check 0 + 기존 화면 regression 0 (Hard Boundary)
8. screen-completion-gate 8 게이트 보고
```

---

## §8. 채택·유지 가이드 / Adoption & Maintenance (진단 권고 반영)

1. **R-1 진입점 단일화**: 루트 `CLAUDE.md` 1차 로드에 본 파일 추가, `_rules_v2/CLAUDE.md` 는 포인터로 축소.
2. **R-2 카운트 SSoT**: 카운트는 본 §4 + 00_INDEX 만 보유. 사전 검증 스니펫:
   ```bash
   N=$(ls Doc/_rules_v2/hooks/*.md | wc -l)
   grep -q "= \*\*$N\*\*" Doc/_rules_consolidation/RULESET_MASTER.md || echo "⚠ hook count drift: disk=$N"
   ```
3. **R-4 재번호**: §4 는 파일명 알파벳순(고정) — 신규 hook 은 알파벳 위치 삽입(번호는 표시 순서일 뿐, 파일명이 키).
4. **R-5 v1 정리**: §5.4 가 유지 룰 단일 출처. v1 `hooks/` DEPRECATED 10종은 archive 권장.
5. **R-8 용어**: "문서 hook(guide)" 과 "실행 hook(enforced)" 을 §6 처럼 항상 분리 표기.

---

> 단일 진실 소스 / Single Source of Truth:
> - 진입 / Entry: 루트 `CLAUDE.md` → 본 파일 → `00_INDEX.md`
> - 카운트 / Count: 본 §4 (= 69) + `00_INDEX.md` (동기화 의무)
> - UI 누락 방지 / UI no-omission: 본 §3 체크리스트 (PR 게이트 §7 통합)
