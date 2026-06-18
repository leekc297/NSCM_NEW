# 00_INDEX.md — NSCM 룰셋 v2 트리거 매트릭스 + 카탈로그

> 진입점 3 (`CLAUDE.md` 의 분기 라우터의 매트릭스).

---

## §A 트리거 매트릭스 (작업 키워드 → 적용 룰 + Hook)

| T# | 작업 트리거 (사용자 키워드) | 필독 룰 | Hook |
|---:|---|---|---|
| T01 | "신규 화면 / 화면 추가 / DMFXXX 만들어 / 화면 생성" | `_tobe/01~10` 전부 (특히 `01 §1.5` components/ 의무) + `_asis/00_framework/01~07` 전부 + `_asis/02_screens/__TEMPLATE__.md` | screen-create-checklist + pre-write + asis-coverage-check + asis-button-mapping + runtime-error-prevention + grid-column-meta + ⭐ **ui-dynamic-property-management** (UI 생성의 동적 속성관리 — master, 2026-06-12) + **menu-button-dynamic-fetch** (Button Visible/Enable) + **ui-category-setup-column-meta** (Column + Measure + 신규 등록 의무) + **components-folder-pattern** (2026-06-09) + screen-entry-asis-baseline (진입 baseline) + **screen-completion-gate** (종료 게이트, 2026-06-11) |
| T02 | "AS-IS 화면 분석 / .cs 분석" | `_asis/02_screens/__TEMPLATE__.md` + `_asis/00_framework/01_BaseForm.md` | popup-asis-analysis (popup 호출 시) |
| T03 | "Popup 분석 / popup 매핑" | `_asis/01_popups/__POPUP_TEMPLATE__.md` + `_asis/01_popups/00_inventory.md` + `_tobe/10_popup_modal.md` | popup-asis-analysis |
| T04 | "Grid / DataGrid / 컬럼 메타 / row 선택 / 체크박스 / Add·Delete 배치 / dropdown / lookup / **column setting popup**" | `_tobe/07_datagrid.md` + `_tobe/08_column_meta.md` + `_tobe/09_subtitle_hotkey.md` §12 + `_tobe/01_file_structure.md §1.5` (Grid 분리 의무) + ⭐ **`Doc/wijmo-flexgrid-guide.md` + `Doc/wijmo-flexgrid-api-reference.md`** (사용자 추가 가이드 2 파일, 2026-06-17) | grid-column-meta + ⭐ **ui-dynamic-property-management** (master) + **ui-category-setup-column-meta** (Column + Measure 동적 fetch + 신규 등록 의무) + **menu-button-dynamic-fetch** (Button 동적 fetch) + ⭐ **column-lookup-meta-standard** (CELL_COMBO_DATA_TYPE 표준 위치 + INPUT_TP_CD 'IM' 표준 / 누락 방지, 2026-06-12) + runtime-error-prevention + **grid-interaction-patterns** + **components-folder-pattern** + ⭐ **wijmo-flexgrid-entry** (Wijmo FlexGrid 작업 진입점 — 사용자 가이드 2 파일 의무 Read + §10 안티패턴 10 row + 자기 점검 5 항목, 2026-06-17) + ⭐ **grid-column-setting-popup-pattern** (사용자 column 표시 설정 5 단계 — Store/Screen/Modal/Grid/Fallback + popup 재진입 복원 + visible flag + 동적 column 제외, DMF0043_01 master, 2026-06-17 사용자 명시 룰화) |
| T05 | "조회조건 / SearchArea / Form / **division/team/customer combo** / **cascade** / **dropdown reset**" | `_tobe/06_search_area.md` + searchFields 카탈로그 | search-button-when-no-searcharea (SearchArea 부재 시) + ⭐ **cascade-combo-filter** (Division 변경 시 하위 reset / Map dedup / useTabComboQueries 1RT / Grid modal callback 5 단계 의무 — PR 차단 강제, 2026-06-18 사용자 명시) |
| T06 | "Modal / Popup / 공용 modal" | `_tobe/10_popup_modal.md` + `_asis/01_popups/00_inventory.md` + `_tobe/01_file_structure.md §1.5` (modals/ 폴더 의무) | popup-asis-analysis + runtime-error-prevention + **components-folder-pattern** |
| T07 | "Button / CRUD / Search Aux / hotkeyConfig" | `_tobe/09_subtitle_hotkey.md` + `_asis/00_framework/01_BaseForm.md` | asis-button-mapping + search-button-when-no-searcharea (SearchArea 부재 시) |
| T08 | "BE / Controller / Service / SP / cursor / mutation / SAVE SP 다중 row" | `_tobe/11_be_controller_service.md` + `_tobe/12_metadata_sql.md` | ⭐ **oracle-db-workflow (진입, 2026-06-11)** → asis-coverage-check + sp-dual-cursor-pattern + mutation-onsuccess-defaults + proc-meta-signature-match + sp-body-minimal-change (SP body 변경 시) + sp-utl-call-stack-safety + sp-exception-handler-debug-friendly + **sp-no-fake-data-extraction** (가짜 구현 금지, 2026-06-11) + ⭐ **scmd-app-grant-mandatory** (신규 SP 컴파일 직후 SCMD_APP GRANT+SYNONYM 즉시 의무, 2026-06-12) + ⭐ **sp-json-table-array-pattern** (SAVE SP `'$[*]'` + cursor FOR LOOP / entry+HIST 동시 fix 의무, 2026-06-12 SYS0010 다중 row 사고 후) |
| T09 | "메뉴 안 나옴 / MNU_URL / SHT_NM / 권한 없음" | `_tobe/13_routing_menu.md` | menu-not-displayed-debug |
| T10 | "DB 오류 / ORA-XXXXX / PLS-XXXXX / 데이터 0건 / 이상치" | `_dev_rules/21_TROUBLESHOOTING.md` (유지) + `_tobe/12_metadata_sql.md` | ⭐ **oracle-db-workflow §3 증상→원인 매핑 (진입, 2026-06-11)** → sp-exception-handler-debug-friendly + sp-substr-zero-index-audit + oracle-cmbo-varname-quote + db-error-asis-cross-check + **sp-no-fake-data-extraction** (DUMMY cursor / NVL NULL / bare != 'Y' 등 18종 검출, 2026-06-11) |
| T11 | "Figma URL" | `_dev_rules/31_FIGMA_DESIGN_INTEGRATION.md` (유지) | (없음) |
| T12 | "Git push / 백업 / 원복" | `_dev_rules/28_GIT_MULTI_REMOTE.md` + `_dev_rules/30_LOCAL_BACKUP_RESTORE.md` (유지) | (없음) |
| T13 | "CSV 적재 / Oracle 적재" | `_dev_rules/29_LOCAL_DB_CSV_IMPORT.md` (유지) | (없음) |
| T14 | "서버 기동" | (메모리 `feedback_start_server.md`) | (없음) |
| T15 | "BaseForm / DataService / 공통 framework" | `_asis/00_framework/01~07.md` | (없음) |
| T16 | "deploy zip / 이관 패키지" | `_dev_rules/22_PACKAGE_ARTIFACTS.md` (유지) + 메모리 `feedback_deploy_package_completeness.md` | deploy-package-completeness + ⭐ **scmd-app-grant-mandatory** (`03_META/09_GRANT_SCMD_APP.sql` 필수, 2026-06-12) + ⭐ **fe-cloud-type-lint-readiness** (PRE-SUBMIT 5 패턴, 2026-06-12) + pre-submit |
| T17 | "G1~G10 격차 신규 구현" | `_mapping/asis_to_tobe.md` §2~§6 (해당 격차) | pre-submit |
| T18 | "사내 DB 적용 / 클라우드 적용 / Docker → 사내 동기화" | `reference_corporate_oracle_connection` + `feedback_corporate_db_apply_pattern` + `feedback_corporate_schema_8_diffs` | **oracle-db-workflow §0-F (진입)** → db-corporate-apply + db-schema-divergence-check + asis-msg-inventory (i18n 시) + ⭐ **scmd-app-grant-mandatory** (사내+클라우드 GRANT 동기화 의무, 2026-06-12) + ⭐ **fe-cloud-type-lint-readiness** (사내↔클라우드 type/lint 정합, 2026-06-12) + **i18n-ko-en-alignment** (다국어 영문화 정책, 2026-06-12) |
| T19 | ⭐ "MSSQL 변환 / SP 변환 / PKG 변환 / AS-IS SP → Oracle / SP 검증" | `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` (부록 C 함정 9종 + §7 성능 안티패턴 5룰 필독) + `Doc/_analysis/db_migration/02_SP_CONVERSION_PIPELINE.md` (6-Stage) | **oracle-db-workflow (진입)** + sp-substr-zero-index-audit + sp-dual-cursor-pattern + proc-meta-signature-match + **sp-no-fake-data-extraction** (변환기 1회 통과 채택 금지 + 18종 안티패턴 검출, 2026-06-11) + ⭐ **sp-json-table-array-pattern** (SAVE SP `'$[*]'` 의무 + entry+HIST 동시 fix, 2026-06-12 NextSCM Pilot 변환 결함 family) + ⭐ **oracle-sp-perf-anti-patterns** (5 룰: column 안 REGEXP_SUBSTR/CONNECT BY → FROM 분리 / 분리자 split → GT 적재 / MASTER lookup → LEFT JOIN / GT MAIN KEY INDEX / SARGable WHERE, 2026-06-16 DMF0003 22,095초 사고 후 신설) |
| T20 | ⭐ "화면 완료 / 작업 종료 / 다 됐어 / PR 제출" | (해당 작업의 룰) | **screen-completion-gate (8 게이트 의무)** → pre-submit |

> 이전 hook 카탈로그 갱신은 §B.3 카탈로그 (**51 항목**) 참조. **새 51**: ⭐ oracle-sp-perf-anti-patterns (MSSQL → Oracle 변환 5 성능 룰 — REGEXP_SUBSTR/CONNECT BY column subquery / 분리자 split JOIN / MASTER lookup / GT INDEX / SARGable WHERE 의무, 2026-06-16 DMF0003 GT_GGET_SITE_ITEM_ALL INSERT 22,095초 사고 후 사용자 명시 요구 신설). **새 49~50**: column-lookup-meta-standard / sp-json-table-array-pattern (2026-06-12 오후 SYS0014 dropdown + SYS0010 다중 row 사고 후 누락 방지 강조). **새 23~27**: db-corporate-apply / db-schema-divergence-check / asis-msg-inventory / react-query-foundation-reexport / relative-import-order (2026-06-10). **새 28**: sp-substr-zero-index-audit (2026-06-11). **새 29~33**: 기존 미등재 5종 소급 등재. **새 34~39**: 룰 v1 hooks/ 잔존 유니크 6종 이관. **새 40~41**: oracle-db-workflow + screen-completion-gate (2026-06-11 정리). **새 42**: ui-category-setup-column-meta (admin 메타 동적 fetch 의무, 2026-06-11). **새 43**: sp-no-fake-data-extraction (PKG/SP 가짜 구현 절대 금지, 2026-06-11 사용자 명시 요구). **새 44**: i18n-ko-en-alignment (다국어 KO=EN 통일, MNU_/TITLE_/LBL_/BTN_ 한정 → 전체 확장, 2026-06-12 사용자 명시 요구). **새 45**: ⭐ ui-dynamic-property-management (UI 생성의 동적 속성관리 — Menu Button + Column + Measure 통합 master, 2026-06-12 사용자 명명). **새 46**: menu-button-dynamic-fetch (Button Visible/Enable 동적 fetch, 2026-06-12 사용자 명시 요구). **새 47**: ⭐ fe-cloud-type-lint-readiness (FE 클라우드 type-check + lint 통과 의무 5 패턴, 2026-06-12 DMF0020 사내↔클라우드 정합 사고 후). **새 48**: ⭐ scmd-app-grant-mandatory (SCMD_APP BE 사용계정 GRANT + SYNONYM 의무, 신규 SP/테이블 즉시 적용, 이관 패키지 09_GRANT_SCMD_APP.sql 필수, 2026-06-12 SYS0010~15 25 SP GRANT 누락 → -9994 사고 후).

---

## §B 룰 카탈로그

### B.1 TO-BE 룰 (`_tobe/`) — 13 정밀

| # | 토픽 | 핵심 내용 |
|---:|---|---|
| 01 | file_structure | 폴더/명명 표준 + components 오타 금지 |
| 02 | imports | alias 인벤토리 + 정확 export + 사고 패턴 |
| 03 | main_component | 7 단계 구조 + 5 변형 + 7 금지 |
| 04 | store | createPersistedStoreWithTab + G1 GET 의무 |
| 05 | constants | MENU_ID/SHEETS/RESPONSE_SET + LBL 5자리 표준 |
| 06 | search_area | SearchArea/FormItem/CustomDropdown + 카탈로그 13종 + G2 통합 |
| 07 | datagrid | DataGrid wrapper + EditTracker + 8 금지 사고 사례 |
| 08 | column_meta | `_inputEditType`/`_ctrlType`/`_modalKey` + dynamic util |
| 09 | subtitle_hotkey | 10 키 매핑 + 정책 4종 + Search Aux 자동 활성 + ⭐ §2.2.1 공통 버튼 기본 표시 정책 (2026-06-06) + §2.5 SearchArea 부재 searchAction (2026-06-06) |
| 10 | popup_modal | 공용 11종 + CustomDialog + 신규 작성 표준 |
| 11 | be_controller_service | Spring Boot + 보안 의무 + 5 격차 endpoint |
| 12 | metadata_sql | 7-BLOCK + 멱등 INSERT + MSSQL→Oracle |
| 13 | routing_menu | MNU_URL slug + 7단계 디버깅 + UPPR_MNU_ID |

### B.2 AS-IS Framework (`_asis/00_framework/`) — 7 정밀

| # | 토픽 | 정밀도 |
|---:|---|---|
| 01 | BaseForm | 6,329 lines / 157 method (CRUD/Aux/F-key/권한/검색조건) |
| 02 | DataService | 5,261 lines / 87 method (4 시스템 SP + BigFilter + Dynamic) |
| 03 | MessageHelper | 405 lines (100%) + Type 4/Button 7 + 23 MSG ID |
| 04 | Logging | SCM_SYS_LOG + G3 통합 |
| 05 | Auth_FormAuth | UserInfoContext + GAppSettings + 보안 의무 |
| 06 | UsrControls | 36 컨트롤 + ControlValues 표준 |
| 07 | FoxDataClient | WCF→REST 매핑 |

### B.3 Hook 카탈로그 (`hooks/`) — 53

| # | Hook | 적용 trigger |
|---:|---|---|
| 1 | pre-write.md | 모든 파일 작성 직전 |
| 2 | post-write.md | 모든 파일 작성 직후 (grep 검증) |
| 3 | pre-submit.md | PR 제출 직전 (통합 검증) |
| 4 | screen-create-checklist.md | T01 (신규 화면) |
| 5 | asis-coverage-check.md | T01 / T08 (4축 매핑) |
| 6 | grid-column-meta.md | T04 (Grid / Column 메타) |
| 7 | popup-asis-analysis.md | T03 / T06 (Popup 9 category) |
| 8 | asis-button-mapping.md | T07 (CRUD 6 + Aux 4 매핑) |
| 9 | runtime-error-prevention.md | T01 / T04 / T06 (사고 사례 사전 차단) |
| 10 | menu-not-displayed-debug.md | T09 (메뉴 미표시 7단계) |
| 11 | search-button-when-no-searcharea.md | T05 / T07 (SearchArea 부재 → SubTitle `searchAction` prop 의무, 2026-06-06) |
| 12 | mutation-onsuccess-defaults.md | T01 / T08 (mutate({onSuccess}) override 시 default invalidate+toast 명시 호출 의무, 2026-06-09) |
| 13 | sp-dual-cursor-pattern.md | T08 (GET SP 의 `O_RC` + `O_RESULT_CURSOR` dual OUT 의무 + PROC_M COL_NM 패턴, 2026-06-09) |
| 14 | grid-interaction-patterns.md | T04 (DataGrid selectionMode + 그리드 특화 액션 배치 + 자동 체크 금지 + recently-added loadedRows 4 패턴, 2026-06-09) |
| 15 | sheet-columns-binding-match.md | T04 / T08 (SHEET_COLUMNS.COLUMN_NAME ↔ SP 반환 alias 일치 의무 + 하드코딩 staticColumns 금지, 2026-06-09) |
| 16 | proc-meta-signature-match.md | T08 (PROC_M 행 수 + SORT_ORD = SP ALL_ARGUMENTS positional 일치 + FE filter key 매핑, 2026-06-09) |
| 17 | sp-body-minimal-change.md | T08 (Oracle SP body 변경 시 DBMS_METADATA.GET_DDL 원본 1바이트 변경 금지 + 3축 검증 의무, 2026-06-07) |
| 18 | destructive-git-ops.md | (모든 트리거) git filter-branch / force-push / reset --hard 등 destructive ops 전 사용자 명시 승인 + 영향 보고 의무, 2026-06-07 |
| 19 | type-check-error-patterns.md | ⭐ T01 / T04 / T06 / T08 (모든 FE 파일 작성 시 17 패턴 self-check — cloud `fix/lint-cleanup-20260608` 8 회 push 차단 사고 후, `pnpm type-check` 호출 없이 PRE-WRITE/POST-WRITE grep 으로 사전 차단, 2026-06-09) |
| 20 | components-folder-pattern.md | ⭐ T01 / T04 / T06 (진입 페이지 ≤ 400 라인 + `<FlexGrid>`/`<DataGrid>`/`<CustomDialog>` inline JSX 금지 + components/modals/ 폴더 의무. DMF0008 inline 4 grid 440 라인 사고 후 사용자 명시 요구, 2026-06-09) |
| 21 | sp-utl-call-stack-safety.md | ⭐ T08 (`UTL_CALL_STACK.SUBPROGRAM(1)(N)` (N≥2) 접근 시 `.COUNT >= N` 안전 체크 의무 + 안티 패턴 `(1)(1) IS NOT NULL` 검출 grep. DMF0008_GET_SALES_SITE Repair dblClick ORA-06533 사고 후, 2026-06-10) |
| 22 | sp-exception-handler-debug-friendly.md | ⭐ T08 / T10 (EXCEPTION OTHERS 의 generic `RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.')` 가 실제 SQLERRM 손실 + SCM_SYS_LOG 미존재 시 cascade fail. 개발=SQLCODE/SQLERRM 명시 raise / 운영=표준 + SCM_SYS_LOG 정상. 진단 임시 patch 절차. DMF0008 30분 진단 사고 후, 2026-06-10) |
| 23 | db-corporate-apply.md | ⭐ T18 (사내 DB 적용 — `docker exec nscm-oracle sqlplus` + `tr -d '\r'` CRLF 우회 + apply.sh wrapper + 04_GRANT_SYNONYM 별도 승인 의무 + Known error 6 카테고리 분류 + 화면별/카테고리별 순차 적용 + 보고서 의무. 2026-06-10 11 화면 사내 일괄 적용 작업 후) |
| 24 | db-schema-divergence-check.md | ⭐ T18 (Docker vs 사내 Oracle 8가지 schema 차이 — SCM_ADM_MSG_M NOT NULL 4컬럼 / SCM_COM_MSG_M 미존재 / BMK_YN 미존재 / USERS tablespace / DBMS_METADATA bug. PRE-CHECK NOT NULL 비교 + 신규 SQL 호환성 의무 + 자기 점검 grep. 2026-06-10) |
| 25 | asis-msg-inventory.md | ⭐ T18 (AS-IS MSG[숫자] 인벤토리 → To-Be 등록 SQL 절차 — 다중 grep 패턴 합집합 + Docker cross-check + 본문 한계 명시 + NOT NULL 보강 + 4-파일 세트 의무 + 의미 충돌 검증 + Docker DB 우선 검증. MSG00096 권한 없음 + 33 MSG ID 인벤토리 작업 후, 2026-06-10) |
| 26 | react-query-foundation-reexport.md | ⭐ T01 / T04 (`@tanstack/react-query` 직접 import 금지 — `@foundation/query-client` re-export 사용 의무. PRE-WRITE grep `from '@tanstack/react-query` → 0 매치 확인. import 위치 `@foundation/*` 그룹. ESLint no-restricted-imports 차단. SCM0008/0009 사고 후, 2026-06-10) |
| 27 | relative-import-order.md | ⭐ T01 / T04 (Relative imports 알파벳/계층 정렬 — 현 폴더 `.constants/.types` → 하위 폴더 `./components/*` → `./use{Name}Store`. ESLint `import/order` 차단. AuthApproval.tsx 사고 후, 2026-06-10) |
| 28 | sp-substr-zero-index-audit.md | ⭐ T08 / T10 / T19 (Oracle `SUBSTR(s, 0, n)` ≡ `SUBSTR(s, 1, n)` (position=0→1 정규화) — ^ 구분 bulk SAVE SP 의 token 추출 시 `^` 포함 → MERGE 매치 fail → silent EXCEPTION → DB 미반영. NextSCM Pilot 변환기 광범위 결함. audit SQL + fix script 일반화. DMF0043 VersionPopup `o_rc1:null success` 사고 후, 2026-06-11) |
| 29 | file-write-fallback.md | (모든 트리거) 파일 작성 실패 시 fallback 절차 — 2026-06-11 소급 등재 |
| 30 | cascade-pattern-check.md | T01 / T04 (조회조건/grid cascade 패턴 — 룰 07 §2.10 cross-ref) — 소급 등재 |
| 31 | modal-callback-cascade-check.md | T06 (modal callback → cascade 전파 — DMF0004 §2.10.6) — 소급 등재 |
| 32 | wijmo-insert-cell-dropdown.md | T04 (Insert cell ComboBox 12 단계 1-pass 의무 — DMF0003 사고, 2026-06-07) — 소급 등재 |
| 33 | localstorage-persist-pattern.md | T01 / T04 (mount 1회 복원 + handleApply 직접 setItem — DMF0003 사고, 2026-06-07) — 소급 등재 |
| 34 | oracle-cmbo-varname-quote.md | ⭐ T08 / T10 (CMBO_SQL_M `@varName` raw 치환 → ORA-01722. `TO_CHAR()` wrap 의무 + Oracle `''`=NULL. 룰 v1 hooks/ 에서 이관, 2026-06-11) |
| 35 | db-error-asis-cross-check.md | T10 (DB 오류 시 AS-IS MSSQL 직접 cross-check 절차 — `_diagnostics` 3 스크립트 연동. 룰 v1 에서 이관) |
| 36 | deploy-package-completeness.md | T16 (PRE-DEPLOY 5 인벤토리 + POST-DEPLOY 4 grep + 사후 보강 6 단계. 룰 v1 에서 이관) |
| 37 | screen-entry-asis-baseline.md | T01 (신규 화면 진입 시 AS-IS baseline 4단계 자동 점검. 룰 v1 에서 이관) |
| 38 | wijmo-merge-sticky-content.md | ⭐⭐ T01 / T04 **세로 cell merge + viewport 안 sticky content** — `panel.viewRange.row/row2` 로 머지 범위 viewport 안 제한 + `scrollPositionChanged → g.invalidate()` 머지 재계산. DMF0004 `CustomMergeManager` 표준 + DMF0043/DMF0043_01/DMF0072/DMF0020 적용 검증 완료. translateY 보정 패턴 (v3 deprecated) 제거. 사용자 명시 (2026-06-18 DMF0043 사고 후 표준화 요청) |
| 39 | popup-dialog-layout.md | T06 (CustomDialog DEFAULT_HEIGHT/position 잘림·중앙 미표시 방지. 룰 v1 에서 이관) |
| 40 | oracle-db-workflow.md | ⭐⭐ T08 / T10 / T18 / T19 **Oracle SP/DB 작업 단일 진입점** — 작업 타입 8종(A~H) 분기 + 증상→원인 매핑 11행 + POST-WRITE 5단계 검증 의무 (2026-06-11 신설) |
| 41 | screen-completion-gate.md | ⭐⭐ T01 / T20 **UI 화면 완성도 통합 게이트** — 종료 선언 전 8 게이트 (AS-IS 매핑/버튼/Grid 메타/메타·라우팅/정적/런타임 smoke/표준 정합/이관) 의무 + 보고 양식 (2026-06-11 신설) |
| 42 | ui-category-setup-column-meta.md | ⭐⭐ T01 / T04 / T07 **UI Category Setup column 메타 동적 fetch 의무** — admin VISIBLE 변경이 화면 즉시 반영되도록 store `staticColumns` + `fetchStaticColumns` + mount/search 호출 + DataGrid prop 5 단계 의무 (DMF0004/0005 표준, 2026-06-11 신설) |
| 43 | sp-no-fake-data-extraction.md | ⭐⭐ T08 / T19 / T10 **PKG/SP 데이터 추출 가짜 구현 절대 금지** — DUMMY cursor / NVL NULL / EXCEPTION OTHERS THEN NULL / hardcoded sentinel / NextSCM Pilot 안티패턴 (TRUNCATE GTT, UF_FX_STRING_SPLIT, SUBSTR pos=0, ORDER BY A.) 18종 금지. 발견 즉시 6단계 실추출 교체 의무. POST-WRITE grep 6 카테고리 (2026-06-11 사용자 명시 요구, 누적 사고 6건) |
| 44 | i18n-ko-en-alignment.md | ⭐ T01 / T18 (i18n KO=EN 전체 통일 — KO 의 모든 i18n 키 = EN 정확 동일. MNU_/TITLE_/LBL_/BTN_/MSG_/TOOLTIP_/PLH_ 전부. KO 전용 키 유지. CN 미적용. POST-WRITE Python/SQL 검증 의무. 2026-06-12 사용자 명시 — 다국어 전체 영문화 정책) |
| 45 | ui-dynamic-property-management.md | ⭐⭐ T01 / T04 / T07 **UI 생성의 동적 속성관리 (master)** — Menu Button(Visible/Enable) + Column(Visible/Width/Lookup/CellType/Label/Scale 등 전부) + Measure(Code/Label/Sort/Valid) 3 구성요소 모두 admin UI (SYS0009 + SYS0004) 관리 데이터 기준 동적 fetch + 즉시 반영 의무. 신규 UI 작성 시 admin 데이터 부재 → 신규 등록 의무. child hook 2종 분기 (`menu-button-dynamic-fetch` + `ui-category-setup-column-meta`). 2026-06-12 사용자 명명 |
| 46 | menu-button-dynamic-fetch.md | ⭐⭐ T01 / T04 / T07 (Menu Button Visible/Enable 동적 fetch — SYS0009 `SCM_ADM_MNU_BTN_MPG_M` + `USER_GR_MNU_BTN_MPG_M`. FE `useTabBtnPermissions` + `hasButton(BTN_CD)` 조건부 callback. hotkeyConfig 하드코딩 `search: handleSearch` 금지. 신규 화면 BLOCK 3/7 멱등 INSERT 의무. ui-dynamic-property-management child. 2026-06-12 사용자 명시) |
| 47 | fe-cloud-type-lint-readiness.md | ⭐ T01 / T18 (FE 클라우드 type-check + lint 통과 의무 5 패턴 — SHEETS=procedures.d.ts 유니온 일치 + DB SHT_NM 정렬 / Ref<T>.current type guard+cast / Wijmo imports 순서 / inline type import / 불필요 as 제거. 이관 패키지 PRE-SUBMIT 의무. 2026-06-12 DMF0020 클라우드 9 errors 사고 후) |
| 48 | scmd-app-grant-mandatory.md | ⭐⭐ T08 / T16 / T18 (SCMD_APP 권한 GRANT + SYNONYM 의무 — SCM_MGR(DDL owner) → SCMD_APP(BE 연결) EXECUTE/SELECT/INSERT/UPDATE/DELETE GRANT + SYNONYM. 신규 SP/테이블 작성 시 즉시 의무. 이관 패키지 `03_META/09_GRANT_SCMD_APP.sql` 필수. BE 응답 -9994 "Sql Error" 90% root cause. 2026-06-12 SYS0010~15 6 화면 25 SP GRANT 누락 사고 후) |
| 49 | column-lookup-meta-standard.md | ⭐⭐ T01 / T04 / T07 **컬럼 lookup 메타 표준 + INPUT_TP_CD 표준 (누락 방지)** — dropdown 컬럼 메타는 `CELL_COMBO_DATA_TYPE` (FE `cellCboDataTp`) 위치 등록 의무 (**ATTRIBUTE1 위치 절대 금지** — DataGrid wrapper 인식 안 함). INPUT_TP_CD 표준 5종 (`S/O/M/IO/IM`) — **`'MI'` 절대 금지** (FE enum `MANDATORY_INSERT_ONLY='IM'` mismatch → isEditableCell 항상 false → cell editor 영원히 미동작). 사용자 명시 요구 (2026-06-12 SYS0014 dropdown 사고 후 누락 방지 강조) |
| 50 | sp-json-table-array-pattern.md | ⭐⭐ T08 / T19 **SAVE SP JSON_TABLE array 처리 표준** — `'$[*]'` + cursor FOR LOOP (또는 bulk INSERT-SELECT / MERGE) 3 패턴. `'$'` + SELECT INTO 절대 금지 (단일 row 만 처리). entry + HIST sub SP 동시 fix 의무 (HIST 가 array 받으면 NULL INSERT → ORA-01400 → 전체 rollback). NextSCM Pilot 변환 결함 family. 2026-06-12 SYS0010 4 SP 다중 row 사고 후 |
| 53 | search-area-extra-conditions.md | ⭐ T01 / T04 / T05 **SearchArea 2단 초과 시 extraConditions 분리 의무** — 12 column Grid 기준 2단 (6 필드) 초과 시 표준 공용 SearchArea 의 `extraConditions` prop 으로 3단 이후 분리 의무. SearchArea 가 자동으로 Search 버튼 우측 ▼ 확장 화살표 + 토글 처리. 자체 expand state / 자체 토글 버튼 작성 금지. 분리 기준 4 우선순위 (필수 → 종속 → 옵션 → 고급). Sample DMF0006 (CustomerModelMappingForm.tsx). DMF0003/DMF0020 적용 사례 동반. 2026-06-16 사용자 명시 |
| 52 | be-infrastructure-reuse.md | ⭐⭐ T08 / T10 / T01 / T04 **BE 인프라 재사용 의무 (신규 BE 작성 전 검색)** — NSCM BE 는 동적 SP 호출 표준 인프라 (callMutationProc + useTabProcQuery + SCM_ADM_API_M/PROC_M 메타 기반) 이미 작성. 신규 Controller/Service/DTO/SP 작성 전 §2 인벤토리 검색 의무 (`@PostMapping` grep + `ALL_PROCEDURES` SP 검색 + `SCM_ADM_API_M` endpoint 인벤토리). 표준 path = SP 작성 (또는 기존 재사용) + 메타 INSERT (API_M+PROC_M) 만으로 완성 — BE Java 0 line. 안티패턴: 화면별 신규 endpoint / 화면 전용 MyBatis xml / FE `apiClient.post('/api/custom-endpoint')` 직접. 2026-06-16 DMF0003 사용자 measure 권한 UPSERT 사고에서 발견 — 사용자 명시 "BE 는 틀 제공 + 신규 생성 회피" 룰화 |
| 54 | pivot-dynamic-column-nvl.md | ⭐⭐ T08 / T10 / T19 **PIVOT dynamic 컬럼 NVL wrap 의무** — 동적 SELECT list + PIVOT 결과 NULL → MyBatis `callSettersOnNulls=false` 환경에서 setter skip → JSON 응답 키 누락 사고. 의무 패턴: 동적 SELECT `NVL(CAST(..., NUMBER), 0)` + PIVOT 입력 `MAX(NVL(value, 0))` 또는 `SUM(NVL(value, 0))`. DMF0020 (NVL 적용) 클라우드 정상 ↔ DMF0043 (NVL 미적용) 사고. Python 첫 row NULL 카운트 검증 의무 (0 NULL 기대). 2026-06-17 DMF0043 dynamic 컬럼 사고 후 신설 |
| 55 | column-meta-rework-checklist.md | ⭐⭐ T01 / T04 / T07 **Column 속성 재작업 8 점검 의무** — 기존 화면의 column 메타 + dynamic 컬럼 + admin 메타 동기화 + BE 응답/FE 매칭 + SP NVL 통합 점검. DMF0008/0020/0043/0043_01 4 화면 비교표 동반. 인벤토리 4 (SP/SHEET_COLUMNS/BASE_COLUMNS/매칭) + 단계 8 (PIVOT NVL/minimal change/patch 종결자/admin 동기/binding 매칭/shared prop/anti-simplification/사후 검증). 2026-06-17 4 화면 column 재작업 진입 룰 |
| 57 | wijmo-flexgrid-entry.md | ⭐⭐ T01 / T04 / T07 **Wijmo FlexGrid 작업 진입점** — 사용자 추가 가이드 (`Doc/wijmo-flexgrid-guide.md` 17.7KB + `Doc/wijmo-flexgrid-api-reference.md` 22.8KB) 참조 의무. §0 "Claude Code 자주 틀리는 3가지" + §10 안티패턴 → 올바른 패턴 10 row (gridApi/columnDefs/renderCell/SpreadJS 문법 / `@grapecity` 패키지 / 렌더마다 new CollectionView / 원본 push / cell.innerHTML / view.refresh 누락 / yyyy-mm-dd / autoGenerateColumns / DataMap). 자기 점검 5 항목 (@mescius/* 패키지 / CollectionView useMemo 1회 / autoGenerateColumns / 셀 커스터마이징 4 방식 / 날짜 yyyy-MM-dd). 기존 wijmo hooks 5 종 (insert-cell-dropdown, merge-sticky-content, grid-column-meta, column-meta-rework-checklist, runtime-error-prevention) cross-ref 단일 진입점. 2026-06-17 사용자 명시 (Wijmo 가이드 2 파일 추가 + 클로드코드 통합 요구) |
| 56 | sp-patch-file-deploy.md | ⭐⭐ T08 / T19 / T16 **SP patch 파일 종결자 + 의존 순서 + fallback 의무** — `END;` 다음 `/` **별개 라인** 의무 (`END;/` 한 줄 → SP body 안 `/` 포함 → PLS-00103 INVALID). 객체 의존 순서 (호출되는 SP 먼저 → wrapper SP 나중) + 통합 SQL 끝 fallback `ALTER PROCEDURE COMPILE` 블록 의무. SQL client 별 적용 방법 (SQL*Plus/SQLcl `@file`, SQL Developer "Run Script F5", DBeaver "Execute SQL Script CTRL+Alt+X"). 적용 후 5 query 검증 (INVALID/USER_ERRORS/재컴파일/상태/권한). PR 직전 `grep "END\s*;\s*/"` 0 row 의무. 2026-06-17 DMF0043 patch 2 사고 후 신설 |
| 51 | oracle-sp-perf-anti-patterns.md | ⭐⭐ T08 / T10 / T19 **MSSQL → Oracle 변환 6 성능 룰** (반드시 지켜야 할 룰): (1) **column 안 REGEXP_SUBSTR/CONNECT BY** correlated subquery → FROM 절 inline view 분리 + GROUP BY 사전 집계 (2) **분리자 split JOIN** → 사전 GT (`GT_GGET_SPLIT_{X}`) 적재 + EXISTS/JOIN (3) **MASTER 명칭 lookup** → FROM 절 LEFT JOIN 분리 (4) **TEMP TABLE MAIN KEY INDEX 의무** (CREATE INDEX + 통계) (5) **WHERE 함수/문자 조합** → SARGable 변환 또는 function-based index (6) **'ALL'/''/NULL 매개변수 시 GT INSERT skip + SELECT OR short-circuit** (사용자 명시 추가, 2026-06-16). MSSQL OK 패턴이 Oracle row-by-row 처리되어 급격한 속도저하 유발. 2026-06-16 DMF0003 GT_GGET_SITE_ITEM_ALL INSERT 22,095초 (99% bottleneck) 사고 후 사용자 명시 요구로 신설 |
| 58 | grid-column-setting-popup-pattern.md | ⭐⭐ T01 / T04 / T06 **Grid Column Setting Popup 통합 패턴 (5 단계)** — Store (`visibleBaseColumns` state + `setVisibleBaseColumns` action) + Screen (`fallbackColumns` useMemo + `.slice(0, BASE_COLUMN_COUNT)` 동적 column 제외 + `visible` flag 매칭) + Modal (공용 ColumnSettingModal + 의무 prop: menuId/sheetName/columnType/divisionId/fallbackColumns/onSave) + Grid (`baseColumns` filter + `baseCountRef` + HeaderMergeManager `dynStart` 동적 갱신) + Fallback (`ColumnSettingFallback.visible?: boolean` 으로 popup 재진입 시 이전 이동 내역 복원). DMF0043_01 master reference 5 사고 사례 동반. 사용자 명시 룰화 요청 (2026-06-17) |
| 59 | cascade-combo-filter.md | ⭐⭐⭐ T01 / T04 / T05 **Cascade Combo Filter 5 단계 표준 (PR 차단 강제)** — Form Cascade reset (Division 변경 시 하위 'ALL' / 단일 setSearchParams) + Multi-level filter ('ALL' sentinel + `&&` 조합) + Map dedup (복합 unique key `${col1}\|${col2}`) + useTabComboQueries 1 round-trip + Grid Modal callback (cell dblClick → modal → row refresh). DMF0004/0005/0006/0007 4 reference 화면 추출 + DMF0020/0003 적용 의무. PRE-WRITE 5 체크 + POST-WRITE grep 6. 위반 시 PR 머지 차단 (anti-simplification 동등 강도). 사용자 명시 룰화 요청 (2026-06-18) |

### B.4 매핑 (`_mapping/`) — 1

| 파일 | 내용 |
|---|---|
| `asis_to_tobe.md` | AS-IS↔TO-BE 매핑 표 + 10 격차 사양 (G1~G10 — 신규 구현 8 + 격차 유지 2) + §10 cascade 격차 25건 (Phase 7 후속) |

### B.5 메타 룰 / 화면별 cross-check (Phase 7 후속, 2026-06-04)

| 파일 | 내용 |
|---|---|
| `meta-rule-evolution.md` | ⭐ PoC → 룰 보강 사이클 (4 분류: §1/§2/Hook/메타) + 사용자 작업물 우선 (anti-simplification 의 반대편) |
| `_asis/02_screens/DMF0004/cascade-mapping.md` | 4 grid + 3 modal callback + 신규 §2.10.6 modal callback 패턴 발견 |
| `_asis/02_screens/DMF0005/cascade-mapping.md` | 4 branch + 신규 §2.10.7 다중 row propagate 패턴 발견 |
| `_asis/02_screens/DMF0006/cascade-mapping.md` | 1 branch (가장 단순) + AS-IS unsubscribe/subscribe 패턴 |
| `_asis/02_screens/DMF0007/cascade-mapping.md` | 3 handler / 7 branch + TO-BE handleActiveChange (§2.10.3 reference) |
| `_asis/02_screens/DMF0008/cascade-mapping.md` | 3 handler / 5 cascade + read-only 의도 |
| `_asis/02_screens/DMF0008/g3-g4-validation.md` | G3 PerfLog + G4 Batch 적용 가이드 |
| `_asis/02_screens/DMF0008/PoC_REPORT.md` | Phase 7 2 차 PoC 결과 (보완 10/10 완료) |
| `_asis/02_screens/DMF0015/PoC_REPORT.md` + `PoC_FIX_REPORT.md` | Phase 6 1 차 PoC (보완 10/10 PASS) |

---

## §C 유지되는 룰 v1 (`Doc/_dev_rules/`)

> Phase 4 종료 후에도 유지 — `_archive/` 미이동.

| 룰 # | 토픽 | 사유 |
|---:|---|---|
| 02_DEVELOPMENT_RULES.md | 브랜치/커밋/PR/리뷰 | 절차 표준 — 룰 v2 와 별개 |
| 21_TROUBLESHOOTING.md | Oracle/DBeaver/Wijmo/PowerShell 종합 | 트러블슈팅 — 룰 v2 와 cross-ref |
| 22_PACKAGE_ARTIFACTS.md | 이관 패키지 (`_artifacts`) | 절차 표준 |
| 28_GIT_MULTI_REMOTE.md | NSCM 모노레포 + GitHub + GitLab | 절차 표준 |
| 29_LOCAL_DB_CSV_IMPORT.md | Docker Oracle CSV 적재 | 환경 표준 |
| 30_LOCAL_BACKUP_RESTORE.md | 백업/원복 표준 | 환경 표준 |
| 31_FIGMA_DESIGN_INTEGRATION.md | Figma → React 매핑 | 절차 표준 |

→ 나머지 24 룰 (00 / 01 / 03~20 / 23~27) → `_archive/` 이동 (Phase 4 종료).

---

## §D 메모리 정책 (`memory/MEMORY.md`)

> Phase 4 종료 후 메모리 정리:

- **흡수 (룰 v2 안 통합)**: 룰 위반 / 표준 패턴 / 보안 의무 등 → `_tobe/*.md` / `_asis/*.md` 안 흡수
- **유지 (사용자 트리거)**: 서버 기동 / 백업 / Figma URL / 백업 / GitHub push 등
- **archive (`memory/_archive/`)**: 한 번 사용 + 룰 v2 흡수 완료 사고 패턴

→ Phase 4 종료 후 메모리 전수 분류.

---

## §E PR 머지 게이트 (pre-submit hook §0)

```
1. anti-simplification 확인 (단순화 0)
2. 13 룰 자동 검증 grep (post-write hook 의 §0)
3. AS-IS 4축 매핑 (__asis-mapping__.md)
4. 메타 SQL 7-BLOCK 등록
5. 4 파일 SQL 세트 (DBeaver 호환)
6. 격차 G1~G10 적용 (Phase 5 후 화면별)
7. 빌드/Lint/Type-check 통과
```

---

> Plan 파일: `C:\Users\ejene\.claude\plans\effervescent-beaming-donut.md`
> 진입점 1: `Doc/_rules_v2/anti-simplification.md` ⚠️
> 진입점 2: `Doc/_rules_v2/CLAUDE.md`
> 진입점 3: 이 파일 (`Doc/_rules_v2/00_INDEX.md`)
