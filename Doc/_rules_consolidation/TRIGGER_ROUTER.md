# NSCM TRIGGER ROUTER — 작업 → 룰/Hook 분기표 (경량 진입)

> ⚙️ **자동 추출본** — 정본 = `Doc/_rules_consolidation/RULESET_MASTER.md`. 직접 편집 금지. MASTER 수정 후 `python scripts/rules/build_router.py` 재실행. (추출일 2026-10-12)

## 사용법
1. 요청문에서 **T# 를 1개 이상 고른다** (복수 가능. 판단 불가 시 T00 + 가장 가까운 T#).
2. 해당 행의 **핵심 Hook 을 `Doc/_rules_v2/hooks/<name>.md` 에서 Read** 한다 — ⭐⭐⭐ 표기는 생략 불가.
3. T01/T01M 이면 `UI_MANDATORY_CHECKLIST.md` 를 PRE-WRITE 로 통과한다.
4. 첫 응답 머리에 `[T# 적용: T01, T04 / Read: hook-a, hook-b]` 1줄을 남긴다 (누락 추적용).
5. 카탈로그 전체(142+ hook 한 줄 요약)가 필요할 때만 `RULESET_MASTER.md §4` 를 연다.

## §2. 트리거 매트릭스 / Trigger Matrix (작업 키워드 → 룰 + Hook)

> ⭐⭐⭐ = PR 차단 강제 등급 / PR-blocking · ⭐⭐ = master 통합 진입 / integrated entry · ⭐ = 강조 / emphasized
> **UI 작업은 T01(신규)·T01M(수정)·T04·T05·T06·T07·T09 + §3 체크리스트가 핵심.**

| T# | 트리거 키워드 | 필독 룰 (`_tobe`,`_asis`) | 핵심 Hook |
|---:|---|---|---|
| **T01** | 신규 화면 / DMFxxxx 생성 / 화면 추가 / **"신규 생성"·"신규 UI"** | ⭐ **ui-work-entry-playbook §2 (트리거 시 플레이북 전문 = 요청문과 동등 적용)** + `_tobe/01~10` 전부 + `_asis/00_framework/01~07` + `_asis/02_screens/__TEMPLATE__` + **`Doc/03.Framework` 공식 FE 설계서/인수인계서** | ⭐⭐⭐ **framework-foundation-entry(아키텍처 진입)** · **mdi-tab-isolation-mandatory** · **procedure-dts-ssot-mandatory** · atomic-design-components + screen-conventions-mandatory · screen-shell-composition-mandatory · regression-zero-mandatory · datagrid-shared-component-mandatory · screen-meta-and-permissions-mandatory · screen-additional-skills-mandatory + ui-dynamic-property-management(master) + menu-button-dynamic-fetch + ui-category-setup-column-meta + screen-create-checklist + screen-entry-asis-baseline + components-folder-pattern + pre-write/post-write + **screen-completion-gate(종료)** + ⭐⭐⭐ **screen-asis-pre-analysis-mandatory(#124 — 4영역 AS-IS 선행 분석 md + 모달=MAIN 동등 점검, 2026-08-07)** + ⭐⭐⭐ **ui-selfcheck-runtime-mandatory(#125 — 완료 선언 전 셀프 런타임 검증: CRUD 왕복+HTTP E2E 8축+권한별 15계정+모달 5칸, 2026-08-07)** |
| **T01M** | **기존 화면 수정 / column 재작업 / 속성 변경 / "보완"·"보완요청"** | ⭐ **ui-work-entry-playbook §1 (트리거 시 전면 점검·교정 플레이북 전문 = 요청문과 동등 적용 — 준수 점검표 의무)** + 해당 화면 룰 + `_tobe/08_column_meta` | ⭐⭐⭐ **regression-zero-mandatory**(Hard Boundary) + **column-meta-rework-checklist**(8 점검) + datagrid-shared-component-mandatory + pivot-dynamic-column-nvl + screen-completion-gate + ⭐⭐⭐ **screen-asis-pre-analysis-mandatory(#124 — 부재 md 선분석 후 보완, 분석 없는 국소 수정 금지)** + ⭐⭐⭐ **pinpoint-request-scope-first(#153 — 대상 특정 보완 = 지정 지점 직행 · 계층 미지정 1줄 확인 · 재현값=FE 실전송값)** |
| **T02** | AS-IS 화면 분석 / .cs 분석 / **UI분석서·화면분석서 생성 / 화면설계서 생성** | `_asis/02_screens/__TEMPLATE__` + `_asis/00_framework/01_BaseForm` | popup-asis-analysis + ⭐⭐ **screen-analysis-workbook-standard(#105 — UI분석서=§1-C 10시트[전체흐름+제약매트릭스 내부구조, 단위테스트 제외] / 화면설계서=§1-A 8시트 + **§1-D EVENT 목차+선행MD 전문 승계 / §1-E 가로 머지**. 정본 DMF0003_UI분석서_v2.1, 설계서 견본 DMF0042·0044·0049 v1.1)** |
| **T03** | Popup 분석 / popup 매핑 | `_asis/01_popups/__POPUP_TEMPLATE__` + `00_inventory` + `_tobe/10_popup_modal` | popup-asis-analysis |
| **T04** | Grid / DataGrid / 컬럼 메타 / dropdown / lookup / column setting popup / drill-down / **머지·편집 제어** | `_tobe/07_datagrid` + `08_column_meta` + `09 §12` + `Doc/wijmo-flexgrid-guide` + `-api-reference` | ⭐⭐⭐ datagrid-shared-component-mandatory · grid-cell-interaction-patterns-mandatory + grid-column-meta + ui-category-setup-column-meta + column-lookup-meta-standard + grid-column-setting-popup-pattern + grid-interaction-patterns + sheet-columns-binding-match + wijmo-flexgrid-entry(진입) + wijmo-insert-cell-dropdown + wijmo-merge-sticky-content + runtime-error-prevention + ⭐⭐⭐ **screen-grid-edit-merge-and-meta-mandatory** (#89 — G mergeManager=props 직접 세팅 + sameRow `CRUD_TYPE`/`INSERT_GROUP_ID` · E `INPUT_TP_CD`+조건부 `beginningEdit` 행잠금 · A `API_ID` JOIN 정합, 이슈목록 2026-06-23 PM R-6~R-10 승격) + ⭐⭐⭐ **column-division-id-visibility** (#92 — DIVISION_ID 콤마 토큰 기반 컬럼 표시, SP/BE 무변경=ATTRIBUTE3 복사+FE 토큰 필터, 2026-06-27) + ⭐⭐⭐ **grid-multi-tier-header-height** (#93 — 다단 헤더 높이 48px 고정, 1단×N 비대화 금지, foundation HEIGHT_BY_COLUMN_DEPTH+DMF0007 P-A/P-B, 2026-06-27) + ⭐⭐⭐ **grid-cell-backcolor-standard** (#95 — cell 배경 3색 표준: 기본 White+zebra / 편집 Yellow(wj-cell-editable) / 잠금 Gray(wj-cell-non-editable, 특수만). 전체 회색·inline 배경 금지, 2026-06-28) + ⭐⭐ **column-align-code-standard** (#96 — HORIZONTAL_ALIGN_CODE 단일문자 C/L/R, 전체단어 금지, 2026-06-28) + ⭐⭐ **common-button-grid-routing** (#97 — 공통버튼 hotkeyConfig 표시 + 자체 toolbar 금지 + 활성그리드 라우팅 + No 컬럼 2방식 + CRUD pending 부모키 reset, 2026-06-28) + ⭐⭐⭐ **wijmo-merge-row-data-only** (#141 — 병합 판정 입력은 행 데이터뿐. 선택/포커스/편집 상태 혼입 ⛔, 2026-08-21) |
| **T05** | 조회조건 / SearchArea / Form / combo / cascade / dropdown reset / **모달 콤보 옵션** / **객체 높이·배치** | `_tobe/06_search_area` + searchFields 카탈로그 | ⭐⭐⭐ messaging-api-and-search-fields-mandatory · cascade-combo-filter · screen-shell-composition-mandatory + search-area-extra-conditions + search-button-when-no-searcharea + cascade-pattern-check + ⭐⭐⭐ **screen-combo-validation-message-mandatory** (§1 L — 콤보/모달 옵션 룩업 조회, 하드코딩 금지) + search-area-button-position-and-toggle + ⭐⭐⭐ **search-condition-height-uniformity** (#94 — 디자인 필수: 모든 조회조건 객체 높이 36px 동일 Main UI+Popup + DatePicker wrapper 36 강제 + Figma 1단 4개 gridSize, 2026-06-27) |
| **T06** | Modal / Popup / 공용 modal | `_tobe/10_popup_modal` + `01 §1.5(modals/)` | ⭐⭐⭐ popup-modal-and-routing-mandatory + popup-asis-analysis + popup-dialog-layout + modal-callback-cascade-check + components-folder-pattern + grid-column-setting-popup-pattern |
| **T07** | Button / CRUD / SubTitle hotkey / 추가·삭제·저장·sort·filter·condition·reset | `_tobe/09_subtitle_hotkey` + `_asis/00_framework/01_BaseForm` | ⭐⭐⭐ subtitle-button-actions-mandatory · screen-meta-and-permissions-mandatory(권한) + screen-shell-composition-mandatory + asis-button-mapping + search-button-when-no-searcharea |
| **T08** | BE / Controller / Service / SP / cursor / mutation / SAVE SP | `_tobe/11_be_controller_service` + `12_metadata_sql` + **`Doc/03.Framework` BE API javadoc** | ⭐⭐ **oracle-db-workflow(진입)** + ⭐⭐ **be-api-contract-ui(UI 호출 계약)** + be-infrastructure-reuse + asis-coverage-check + procedure-dts-ssot-mandatory + sp-dual-cursor-pattern + mutation-onsuccess-defaults + proc-meta-signature-match + sp-body-minimal-change + sp-utl-call-stack-safety + sp-exception-handler-debug-friendly + sp-no-fake-data-extraction + sp-json-table-array-pattern + sp-patch-file-deploy + scmd-app-grant-mandatory + ⭐⭐ **oracle-null-sentinel-and-notnull-default(#119 — MSSQL `ISNULL(x,'')` → 센티널 **`'/'`**(⭐ 10-15 개정 §0.5 · 원래 `'-'` 데이터 유지 · 과도기 `IN ('-','/')`) / NOT NULL 초기값)** + ⭐⭐⭐ **pinpoint-request-scope-first(#153 — 대상 특정 보완 = 지정 지점 직행 · 계층 미지정 1줄 확인 · 재현값=FE 실전송값)** |
| **T09** | 메뉴 안 나옴 / MNU_URL / SHT_NM / 권한 없음 | `_tobe/13_routing_menu` | menu-not-displayed-debug + menu-button-dynamic-fetch |
| **T10** | DB 오류 / ORA-xxxxx / PLS-xxxxx / 데이터 0건 / **날짜·메시지 검증 오탐** / **대량 조회·저장 실패(ORA-06502/40478)** / **업로드·저장 무반응(hang)** | `_dev_rules/21_TROUBLESHOOTING` + `_tobe/12_metadata_sql` | ⭐⭐ oracle-db-workflow §3 + sp-exception-handler-debug-friendly + sp-substr-zero-index-audit + oracle-cmbo-varname-quote + ⭐⭐ **oracle-bulk-clob-buffer(#106 — 대량 CLOB 버퍼)** + ⭐⭐ **sp-hang-runaway-loop-diagnosis(#107 — 무반응 hang·GTT TRUNCATE mutex·FETCH_STATUS 무한루프·재배포 pin 차단)** + ⭐⭐ **oracle-nls-implicit-conversion(#109 — "클라우드만 실패"=세션 NLS 암묵변환 / -9994·InvocationTargetException 래퍼 진단)** + db-error-asis-cross-check + sp-no-fake-data-extraction + pivot-dynamic-column-nvl + ⭐⭐⭐ **screen-combo-validation-message-mandatory** (§2 V 날짜 표시↔검증 형식 / §3 M 메시지 코드 충돌) + ⭐⭐ **oracle-null-sentinel-and-notnull-default(#119 — MSSQL `ISNULL(x,'')` → 센티널 **`'/'`**(⭐ 10-15 개정 §0.5 · 원래 `'-'` 데이터 유지 · 과도기 `IN ('-','/')`) / NOT NULL 초기값)** + ⭐⭐⭐ **pinpoint-request-scope-first(#153 — 대상 특정 보완 = 지정 지점 직행 · 계층 미지정 1줄 확인 · 재현값=FE 실전송값)** |
| **T11** | Figma URL | `_dev_rules/31_FIGMA_DESIGN_INTEGRATION` | (figma-mapping-check — v1) |
| **T12** | Git push / 백업 / 원복 | `_dev_rules/28_GIT_MULTI_REMOTE` + `30_LOCAL_BACKUP_RESTORE` | destructive-git-ops |
| **T13** | CSV 적재 / Oracle 적재 | `_dev_rules/29_LOCAL_DB_CSV_IMPORT` | (없음) |
| **T14** | 서버 기동 | (메모리 `feedback_start_server`) | (없음) |
| **T15** | BaseForm / DataService / 공통 framework | `_asis/00_framework/01~07` | (없음) |
| **T16** | deploy zip / 이관 패키지 | `_dev_rules/22_PACKAGE_ARTIFACTS` | deploy-package-completeness + scmd-app-grant-mandatory + fe-cloud-type-lint-readiness + ⭐⭐⭐ **msg-table-cloud-sync-and-insert-only §B** (#140 — `SCM_ADM_MSG_M` 축은 `INSERT ... NOT EXISTS` 전용, MERGE·기존코드 UPDATE·DELETE ⛔) + pre-submit |
| **T17** | G1~G10 격차 신규 구현 | `_mapping/asis_to_tobe.md §2~§6` | pre-submit |
| **T18** | 사내 DB 적용 / 클라우드 동기화 / 메타 INSERT / LBL 등록 / SP 호출 배선 | (메모리 corporate) | oracle-db-workflow §0-F + db-corporate-apply + db-schema-divergence-check + asis-msg-inventory + scmd-app-grant-mandatory + fe-cloud-type-lint-readiness + i18n-ko-en-alignment + ⭐⭐ **corp-meta-integrity-and-wiring** (#98 — 메타 INSERT NOT NULL 전수[MSG_TP_CD/USE_YN] + LBL 동일명칭/권위 max+1 + BE 무변경 generic call-proc 배선 + SHEET_NAME case-sensitive 잔존정리) + column-align-code-standard(#96) + ⭐⭐⭐ **msg-table-cloud-sync-and-insert-only §A** (#140 — "MSG TABLE 클라우드 기준(첨부) 으로 업데이트 해줘" 고정 절차) |
| **T19** | MSSQL 변환 / SP 변환 / PKG 변환 | `Doc/_analysis/db_migration/01_*` + `02_SP_CONVERSION_PIPELINE` | oracle-db-workflow + sp-substr-zero-index-audit + sp-dual-cursor-pattern + proc-meta-signature-match + sp-no-fake-data-extraction + sp-json-table-array-pattern + oracle-sp-perf-anti-patterns + sp-patch-file-deploy |
| **T20** | 화면 완료 / 작업 종료 / 다 됐어 / PR 제출 | (해당 작업 룰) | ⭐⭐ **screen-completion-gate(8 게이트)** → pre-submit |
| **T21** | ⭐ **"MSG TABLE 클라우드 기준(첨부) 으로 업데이트 해줘"** / MSG·LBL 원장 클라우드 동기화 | (첨부 = 클라우드 `SCM_ADM_MSG_M` 추출본 CSV/TSV/JSON) | ⭐⭐⭐ **msg-table-cloud-sync-and-insert-only** (#140 §A 전문 = 요청문과 동등 적용 — `_artifacts/_cloud_to_corp/MSG_SYNC/msg_update.py` 1-명령 절차 · 절대준수 5항 · 완료 조건 재판정 0 수렴) |
| **T00** | (모든 작업 공통) | — | pre-write · post-write · pre-submit · file-write-fallback · destructive-git-ops · type-check-error-patterns · react-query-foundation-reexport · relative-import-order |

> **진단 반영(C-3)**: 유지 룰 v1 표는 §5 1곳에서만 보유. T10~T19 의 `_dev_rules/NN` 참조는 §5 표를 단일 출처로 본다.

---

## §2.5 ⭐ 카테고리 축 (주제별 룰 묶음) / Thematic Category Axis — 2026-07-30 신설 (사용자 요구)

> 트리거 매트릭스(§2 — 작업 유형 축)와 **직교하는 주제 축**. "UI 디자인 관련 룰 전부 / EDIT 권한 관련 전부"처럼 **주제로 모아서 적용**할 때 사용 — 적용 누락·오류 저감 목적.
> **진입점**: `Doc/_rules_v2/_categories/00_CATEGORY_MAP.md` (hook 123 전수 분류표 + 커버리지 검증식 보유).
> 원칙: 카테고리 파일 = 포인터 인덱스(본문 복제 없음) / 카운트는 본 파일 §4 만 보유 / 다중 소속 허용 / **신규 hook 신설 시 §4·00_INDEX 와 함께 카테고리 맵·해당 카테고리 파일 동시 등재 의무**.

| 코드 | 카테고리 (`_rules_v2/_categories/`) | 주제 |
|---|---|---|
| 01 | `01_ui_design_layout.md` | UI 디자인·레이아웃 (36px/48px/3색/No.코너/아이콘 버튼/Figma 정합) |
| 02 | `02_auth_edit_control.md` | 권한·Edit 제어 (hasButton/EDIT_YN/editLock/권한 게이트 3형) |
| 03 | `03_grid_column_meta.md` | Grid·컬럼 메타·Wijmo |
| 04 | `04_search_condition_combo.md` | 조회조건·콤보·cascade |
| 05 | `05_popup_modal.md` | 팝업·모달·라우팅 |
| 06 | `06_screen_architecture.md` | 화면 골격·타입·명명·런타임 |
| 07 | `07_i18n_msg.md` | i18n·MSG/LBL |
| 08 | `08_admin_meta_wiring.md` | admin 메타·배선 |
| 09 | `09_sp_db_conversion.md` | SP·DB 변환·성능 |
| 10 | `10_diagnosis_troubleshoot.md` | 진단·트러블슈팅 (증상→룰 역인덱스) |
| 11 | `11_asis_parity.md` | AS-IS 분석·정합 |
| 12 | `12_process_ops.md` | 프로세스·운영·배포 |

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
