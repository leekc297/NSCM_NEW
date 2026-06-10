# 00_INDEX.md — NSCM 룰셋 v2 트리거 매트릭스 + 카탈로그

> 진입점 3 (`CLAUDE.md` 의 분기 라우터의 매트릭스).

---

## §A 트리거 매트릭스 (작업 키워드 → 적용 룰 + Hook)

| T# | 작업 트리거 (사용자 키워드) | 필독 룰 | Hook |
|---:|---|---|---|
| T01 | "신규 화면 / 화면 추가 / DMFXXX 만들어 / 화면 생성" | `_tobe/01~10` 전부 (특히 `01 §1.5` components/ 의무) + `_asis/00_framework/01~07` 전부 + `_asis/02_screens/__TEMPLATE__.md` | screen-create-checklist + pre-write + asis-coverage-check + asis-button-mapping + runtime-error-prevention + grid-column-meta + **components-folder-pattern** (2026-06-09) |
| T02 | "AS-IS 화면 분석 / .cs 분석" | `_asis/02_screens/__TEMPLATE__.md` + `_asis/00_framework/01_BaseForm.md` | popup-asis-analysis (popup 호출 시) |
| T03 | "Popup 분석 / popup 매핑" | `_asis/01_popups/__POPUP_TEMPLATE__.md` + `_asis/01_popups/00_inventory.md` + `_tobe/10_popup_modal.md` | popup-asis-analysis |
| T04 | "Grid / DataGrid / 컬럼 메타 / row 선택 / 체크박스 / Add·Delete 배치" | `_tobe/07_datagrid.md` + `_tobe/08_column_meta.md` + `_tobe/09_subtitle_hotkey.md` §12 + `_tobe/01_file_structure.md §1.5` (Grid 분리 의무) | grid-column-meta + runtime-error-prevention + **grid-interaction-patterns** + **components-folder-pattern** |
| T05 | "조회조건 / SearchArea / Form" | `_tobe/06_search_area.md` + searchFields 카탈로그 | search-button-when-no-searcharea (SearchArea 부재 시) |
| T06 | "Modal / Popup / 공용 modal" | `_tobe/10_popup_modal.md` + `_asis/01_popups/00_inventory.md` + `_tobe/01_file_structure.md §1.5` (modals/ 폴더 의무) | popup-asis-analysis + runtime-error-prevention + **components-folder-pattern** |
| T07 | "Button / CRUD / Search Aux / hotkeyConfig" | `_tobe/09_subtitle_hotkey.md` + `_asis/00_framework/01_BaseForm.md` | asis-button-mapping + search-button-when-no-searcharea (SearchArea 부재 시) |
| T08 | "BE / Controller / Service / SP / cursor / mutation" | `_tobe/11_be_controller_service.md` + `_tobe/12_metadata_sql.md` | asis-coverage-check + **sp-dual-cursor-pattern** + **mutation-onsuccess-defaults** + **proc-meta-signature-match** + **sp-body-minimal-change** (SP body 변경 시) + **sp-utl-call-stack-safety** + **sp-exception-handler-debug-friendly** (2026-06-10) |
| T09 | "메뉴 안 나옴 / MNU_URL / SHT_NM / 권한 없음" | `_tobe/13_routing_menu.md` | menu-not-displayed-debug |
| T10 | "DB 오류 / ORA-XXXXX" | `_dev_rules/21_TROUBLESHOOTING.md` (유지) + `_tobe/12_metadata_sql.md` | **sp-exception-handler-debug-friendly** (사고 진단 시 EXCEPTION OTHERS 우회 절차, 2026-06-10) |
| T11 | "Figma URL" | `_dev_rules/31_FIGMA_DESIGN_INTEGRATION.md` (유지) | (없음) |
| T12 | "Git push / 백업 / 원복" | `_dev_rules/28_GIT_MULTI_REMOTE.md` + `_dev_rules/30_LOCAL_BACKUP_RESTORE.md` (유지) | (없음) |
| T13 | "CSV 적재 / Oracle 적재" | `_dev_rules/29_LOCAL_DB_CSV_IMPORT.md` (유지) | (없음) |
| T14 | "서버 기동" | (메모리 `feedback_start_server.md`) | (없음) |
| T15 | "BaseForm / DataService / 공통 framework" | `_asis/00_framework/01~07.md` | (없음) |
| T16 | "deploy zip / 이관 패키지" | `_dev_rules/22_PACKAGE_ARTIFACTS.md` (유지) + 메모리 `feedback_deploy_package_completeness.md` | pre-submit |
| T17 | "G1~G10 격차 신규 구현" | `_mapping/asis_to_tobe.md` §2~§6 (해당 격차) | pre-submit |
| T18 | "사내 DB 적용 / 클라우드 적용 / Docker → 사내 동기화" | `reference_corporate_oracle_connection` + `feedback_corporate_db_apply_pattern` + `feedback_corporate_schema_8_diffs` | db-corporate-apply + db-schema-divergence-check + asis-msg-inventory (i18n 시) |

> 이전 hook 카탈로그 갱신은 §B.3 카탈로그 (27 항목) 참조. **새 23~27**: db-corporate-apply / db-schema-divergence-check / asis-msg-inventory / react-query-foundation-reexport / relative-import-order (2026-06-10 신규).

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

### B.3 Hook 카탈로그 (`hooks/`) — 27

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
| 23 | db-corporate-apply.md | ⭐ T17 (사내 DB 적용 — `docker exec nscm-oracle sqlplus` + `tr -d '\r'` CRLF 우회 + apply.sh wrapper + 04_GRANT_SYNONYM 별도 승인 의무 + Known error 6 카테고리 분류 + 화면별/카테고리별 순차 적용 + 보고서 의무. 2026-06-10 11 화면 사내 일괄 적용 작업 후) |
| 24 | db-schema-divergence-check.md | ⭐ T17 (Docker vs 사내 Oracle 8가지 schema 차이 — SCM_ADM_MSG_M NOT NULL 4컬럼 / SCM_COM_MSG_M 미존재 / BMK_YN 미존재 / USERS tablespace / DBMS_METADATA bug. PRE-CHECK NOT NULL 비교 + 신규 SQL 호환성 의무 + 자기 점검 grep. 2026-06-10) |
| 25 | asis-msg-inventory.md | ⭐ T17 (AS-IS MSG[숫자] 인벤토리 → To-Be 등록 SQL 절차 — 다중 grep 패턴 합집합 + Docker cross-check + 본문 한계 명시 + NOT NULL 보강 + 4-파일 세트 의무 + 의미 충돌 검증 + Docker DB 우선 검증. MSG00096 권한 없음 + 33 MSG ID 인벤토리 작업 후, 2026-06-10) |
| 26 | react-query-foundation-reexport.md | ⭐ T01 / T04 (`@tanstack/react-query` 직접 import 금지 — `@foundation/query-client` re-export 사용 의무. PRE-WRITE grep `from '@tanstack/react-query` → 0 매치 확인. import 위치 `@foundation/*` 그룹. ESLint no-restricted-imports 차단. SCM0008/0009 사고 후, 2026-06-10) |
| 27 | relative-import-order.md | ⭐ T01 / T04 (Relative imports 알파벳/계층 정렬 — 현 폴더 `.constants/.types` → 하위 폴더 `./components/*` → `./use{Name}Store`. ESLint `import/order` 차단. AuthApproval.tsx 사고 후, 2026-06-10) |

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
