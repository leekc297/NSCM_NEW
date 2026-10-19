# 10_RULES_KEEP — Vibe_Manager 이관 룰셋 (지켜야 하는 룰, 2026-10-19)

> 원천: `CLAUDE.md`(2026-10-12) · `.claude/rules/00~03` · `Doc/_rules_consolidation/{RULESET_MASTER §4, UI_MANDATORY_CHECKLIST, TRIGGER_ROUTER}` · `Doc/_rules_v2/hooks/*.md`(153) · `Doc/_dev_rules/*`.
> 형식: **요지 — (출처 #hook) — Vibe 적용**. 적용 열의 코드: `G:` = check.js/check-pkg.js 게이트 코드(F/S/M/G/D/V/T/L = 기존, **R01~R16 / P30~P38 = 이 이관에서 신설**), `DoD:` = Doc/gen/<ID>/DOD.md 항목, `T:` = templates.js 가 골격에 박음, `P:` = 하네스 프롬프트(new_screen.md/port_pkg.md)가 Claude 에 지시, `E:` = E2E 스펙, `M:` = 사람 확인(Vibe_Manager "사람 확인 큐").
> 전문이 필요하면 `Doc/_rules_v2/hooks/<name>.md` 를 연다(포인터 인덱스 방식 — 본문 복제 없음). 제외한 룰과 이유는 `20_RULES_SKIP.md`, 전수 처분표는 `30_HOOK_DISPOSITION.csv`.

## A. 최상위 원칙 (모든 단계)
1. **anti-simplification** — 속도·편의를 위한 단순화 금지. "전체/정밀" = 다중 패턴 + cross-check, 자동화 1회 통과 채택 금지, 추출 한계 명시. — (`Doc/_rules_v2/anti-simplification.md`) — AsisFacts 교차검증 `crosscheck_report.csv` 0건, Recon 대사표 confidence, `G:G01~G04/M04`.
2. **AS-IS 한 줄도 누락 없음** — Event/API/Validation/Expression 4축 + 셀 EVENT 전수 + 버튼 + 시트 + SP 가 `__asis-mapping__.md` 에 행 단위로 있고 상태가 구현/제외(사유) 중 하나. — (#2 asis-coverage-check, #146 asis-grid-cell-event-full-extraction, #1 asis-button-mapping, 절대금지 ⑪) — `T:` 매핑표 자동 생성 `G:M01~M05` `DoD:B01~B21`.
3. **디자인 그대로 → 한 사람이 개발한 것처럼(DMF0004~0007 패턴 100%) → 공용으로 끌어올리기(shared default 변경 금지)**. — (CLAUDE.md §1-2, #47 screen-conventions, #41 regression-zero) — `T:` 골격 = 실측 패턴, `G:D01` 카탈로그 밖 컴포넌트 BLOCK, `P:` 예제 7종.
4. **Layer 의존 방향** foundation ← shared ← features ← web / BE Controller → Service(interface) → Impl → BaseService → MyBatis. feature 간 직접 import 금지, 2-depth alias, 상대/deep import 금지. — (#71 framework-foundation-entry, #42 relative-import-order) — `G:R01/R02` + `check-fe-import.ps1`(유지).
5. **Syntax Error 0** — Oracle 컴파일 VALID(ALL_ERRORS 0) / FE tsc 0 / lint 0(로컬 참고, 최종 클라우드). — (CLAUDE.md §1-4) — `G:T01/L01`, `check-pkg` USER_ERRORS.
6. **정직 보고** — 검증 미실행·미확인·환경 파손은 PASS 가 아니라 ERROR. 완료는 게이트 증빙(PIPELINE/DOD/CHECK/E2E 요약)으로만 선언. — (#126 verification-completion-honesty, #145 verification-evidence-and-scale) — Vibe_Manager 판정은 산출물 파일로만(`steps.json gate`), 수선 루프 NEEDS_HUMAN 큐.
7. **DB 작업 = 새로고침한 최신 원문 기준** — 기존 Oracle 객체 수정 시 `ALL_SOURCE`+`LAST_DDL_TIME` 재조회 후 그 위에 병합. 신규 PKG 생성에는 미적용. — (#152 db-source-refresh-before-work, #55 sp-body-minimal-change) — `M:` 기존 PKG 수정 작업 시 `run_sql.py`/DbConn 으로 재조회(자동화 후보).
8. **파괴적 Git 작업 승인** — force-push/filter-branch/reset --hard 전 사용자 승인. — (#15 destructive-git-ops) — Vibe_Manager 는 Git 을 호출하지 않음.
9. **주석은 분석 근거가 아니다** — 소스 grep/카운트 근거는 살아있는 코드만(주석 처리 코드 제외). — (#138 comment-live-code-discrimination) — AsisFacts `commented_calls.csv` 분리, `G:D01` stripComments.
10. **살아있는 DB 가 정본** — As-is 사실(SP 파라미터·시트 메타)은 DB 직접 조회가 정본, 파일 fallback 은 표기. — (#151 asis-db-live-connection-mandatory) — AsisFacts db/grid 단계, DbConn probe.

## B. FE 화면 골격·아키텍처
| # | 룰 요지 | 출처 | Vibe 적용 |
|---|---|---|---|
| B1 | 폴더/파일 = `features/<layer>/src/pages/<kebab>/{Page.tsx, components/{Form,Grid*,modals/}, use<Page>Store.ts, <page>.constants.ts, hooks/, __tests__/, __asis-mapping__.md, index.ts}`; 컴포넌트 PascalCase, 훅/스토어 camelCase, 타입/상수 kebab. 진입 Page ≤400 라인, inline grid/dialog JSX 금지 | #47, #9 components-folder, #76 code-naming, `nscm-fe/docs` | `T:` 골격, `G:S00~S03/R16` |
| B2 | features 폴더 결정 5단계: `SCM_ADM_MNU_M` walk-up → 최상위 매핑(Master/Demand/Report 동명, Admin→admin, Authority→authority) → Router import 검색(기존이면 cross-check만) → 자매 화면 패턴 → 보고 | `.claude/rules/00-fe-screen.md §C` | `gen.js menuMeta`(menu.csv route_path 첫 세그먼트) `DoD:B01` |
| B3 | MENU_ID = 폴더명 = `route-paths.ts` = DB `MNU_URL` 4 cross-check | #47 §1.2, #35 | `gen-register-sql selfMenu`, `G:S02` |
| B4 | MDI 격리: 페이지 store = `createPersistedStoreWithTab`(멀티톤, storageName=폴더명), fetch = `useTabProcQuery`(Query Key 에 tabId), **store 에 조회 결과 data 저장 금지**(searchParams/filters/UI 상태만) | #72 mdi-tab-isolation | `T:` store 템플릿, `DoD:B04` |
| B5 | 타입 SSOT: `procedure.d.ts` IN/OUT 먼저 → constants 정합 → 제네릭 추론. 로컬 재정의/`any`/`as unknown as` 금지 | #73 procedure-dts-ssot | `T:` `${Page}Filter`·HARD_COLUMNS 타입, `G:R05`, `check-fe-import.ps1` |
| B6 | 공용 우선: `@lges/design-system` → `@shared/components` → 신규. `useDataGridStore` DEPRECATED 0. 카탈로그 밖 컴포넌트는 먼저 사전 제안 | #74 atomic-design, #45 screen-additional-skills | `Doc/tobefacts/framework/*.md` 카탈로그, `G:D01` |
| B7 | import: `@tanstack/react-query`→`@foundation/query-client`, `clsx`/`lodash`/`react-i18next` 직접 import 0, 상대 import 정렬(external·features → @foundation/@shared → ../ → ./) | #40, #42, UI체크 3.3 | `T:tidy()`, `G:R01/R02` + eslint import/order(`G:L01`) |
| B8 | 레이아웃 셸: 페이지 최상위 래퍼 div ⛔(`<>`), DataGrid 감싸는 div ⛔, `<MainTitle>`+`<SubTitle>` 필수, FormItem=`commonStyles.formItem` | #132 ui-layout-shell, #121 form-common-styles, #51 screen-shell | `T:` page 템플릿, `G:S03/R12` |
| B9 | 팝업/모달: 화면 종속 모달은 `components/modals/<Name>Modal.tsx`+`.module.scss`, 공용 popup 은 camelCase 폴더 5파일 + `MODAL_XXX`(실제 MENU_ID) + Router 4 cross-check; CustomDialog `customContentArea` 지정 시 자체 footer 의무(공통 OK/Cancel 미렌더) | #35 popup-modal-and-routing, #34 popup-dialog-layout, UI체크 P9 | `T:modalTpl()`(type modaless, 자체 actions), `DoD:B10/B11`, `G:R14`, 매핑 `D00-P-nnn` |
| B10 | SHEET_NAME = AS-IS 원본 그대로(개명 금지): FE `SHEETS` value = `SCM_MST_SHEET_COLUMNS.SHEET_NAME`(또는 .cs SpdSheet) = SP = MNU_BTN.SHT_NM | #91 sheet-name-asis-preserve | `T:` SHEETS enum = As-is 시트명, `gen-register-sql` 동일 값 |
| B11 | 수정 작업 Hard Boundary 6종 변경 금지: `packages/shared` · foundation · lges · 타 도메인 · 타 화면 · `nscm-be`. 공용 prop 추가는 분리 PR + 4 도메인 regression 0 | #41 regression-zero | `applied.json` 범위 = 페이지 폴더만, `repair-loop` allowedTools 범위, `M:` |

## C. 동적 속성·메타 (admin 운영 결정이 화면에서 무효화되면 안 된다 — 절대 누락 금지 3종)
| # | 룰 요지 | 출처 | Vibe 적용 |
|---|---|---|---|
| C1 | **Menu Button Visible/Enable 동적 fetch**: 공통 버튼은 `useTabBtnPermissions`+`hasButton(BTN_CD)`, SYS0009 매핑. 하드코딩 버튼 노출 금지 | #66 ui-dynamic-property-management(master), #24 menu-button-dynamic-fetch | `T:` hotkeyConfig+권한 훅, `DoD:B06~B09`, 등록 SQL BLOCK 6/7 |
| C2 | **컬럼 메타 동적 fetch**: Visible/Width/Lookup/CellType/Label/Scale = `SCM_MST_SHEET_COLUMNS` → `/admin/menu/{MNU}/column` → `staticColumns`. 하드코딩 staticColumns 금지(메타 없을 때만 `RawFlexGridColumnConfig` 폴백 + 등록 SQL 로 메타 이관) | #65 ui-category-setup-column-meta, #54 sheet-columns-binding-match, #84 | `T:` store 시트별 로드(팝업 시트 포함), `gen-register-sql` BLOCK 3(메타 이관+하드코딩 9000+), `G:G01`, Recon 시트 대사 |
| C3 | Measure Code/Label/Sort/Valid = SYS0004(동적 PIVOT 화면) | #66 | `M:` PIVOT 화면 시 확인(자동화 후보) |
| C4 | admin 메타 8 테이블에 **임의 데이터 금지**: 값은 As-is 메타/소스에서만. CTRL 코드 `FP*` 화이트리스트, `INPUT_TP_CD` 5종(`MI` 금지), `HORIZONTAL_ALIGN_CODE` 단일문자 C/L/R, NOT NULL 전수(`desc` 선행) | #78 ui-category-setup-no-arbitrary-data, #7 column-lookup-meta, #96 column-align-code, #98 | `gen-register-sql` JSON_TABLE 값 매핑, `check-meta-sql.ps1`·`check-notnull-insert.ps1`(유지) |
| C5 | `DIVISION_ID`(콤마 토큰) 기반 컬럼 표시: 값 있으면 선택 division 포함 시만, 공란=전체. 서버 직접 비교(divisionId 전송) | #92 column-division-id-visibility, #113 ui-category-division-direct-compare | `T:` division 필수 필터, AsisFacts grid_effective DIV 열, `DoD:B12` |
| C6 | PROC_M 행/SORT_ORD = SP `ALL_ARGUMENTS` positional 일치; SP body 변경 후 PROC_M 동기(O_RESULT_CURSOR 누락 → PLS-00306) | #39 proc-meta-signature-match, 21_TROUBLESHOOTING §0 | `gen-register-sql` BLOCK 2 (ALL_ARGUMENTS 동적), `check-pkg` |
| C7 | 등록 7영역(i18n·PROC_M·SHEET_COLUMNS·MNU_M·API_M·MNU_BTN_MPG·USER_GR 권한) + SCMD_APP GRANT/SYNONYM 즉시 | TRIGGER §7-4, #44 scmd-app-grant | `gen-register-sql` 7 BLOCK + 검증 SELECT, `M:` GRANT 는 클라우드 이관 시 |
| C8 | 권한 판정 = USER_ID 기준 보유 권한 **합집합**(현재 그룹 1개 전송 금지) | #128 auth-by-userid-not-groupid | `E:` auth 스펙 12계정×DIV, `T:` 권한 훅 |
| C9 | 기능 버튼 메타 완전성: As-is 기능 + FE handler 가 있는데 `hasButton()` false 로 미표시되는 버튼 0 | #82 feature-button-meta-completeness | `DoD:B07/B08`, 등록 SQL BLOCK 6, `E:` buttons 어노테이션 |
| C10 | UI 메타 지식사전 대조: 조회조건·컬럼·MEASURE 작성 시 사전(`_rules_v2/_dictionary`) 과 대조 | #142 ui-meta-dictionary | `P:` 사전 경로 안내(참고) |

## D. Grid (Wijmo FlexGrid — SpreadJS 가 아니다)
| # | 룰 요지 | 출처 | Vibe 적용 |
|---|---|---|---|
| D1 | Grid = 공용 `DataGrid` 만, `<FlexGrid>`/`<FlexGridColumn>` 직접 JSX 0, foundation utils(`GridAction.addRow/removeRow`, `GridUtils.getSelectedRows` 등) 사용 | #10 datagrid-shared-component | `T:` Grid 템플릿, `G:R04/S01`, `DoD:B18` |
| D2 | wijmo 이벤트 핸들러(formatItem/cellEditEnded/beginningEdit/loadedRows/selectionChanged…)는 `useEffect`+`gridRef.current` 로 등록·cleanup, `initialized` prop 금지. row interface `extends WijmoRowItem`, 필드 non-optional | #70 screen-runtime-pitfalls | `T:` Grid 템플릿 주석+스텁, `G:R06` |
| D3 | dynamicColumns group/leaf 에 `allowSorting:false`·`allowMerging:false`·`height` 명시(`HEIGHT_BY_COLUMN_DEPTH` 1단48/2단24/3단16), 다단 헤더 높이 48 고정 | #93 grid-multi-tier-header-height, #70 | `P:` PIVOT/다단 화면 지시, `M:` |
| D4 | 셀 배경 3색 표준(White+zebra `.wj-alt`), No. 코너 헤더(TopLeft 단일 머지+'No.'), 커스텀 MergeManager 는 DataGrid props 직접(useEffect 주입 금지), sameRow 머지 기준 `CRUD_TYPE`+`INSERT_GROUP_ID`, 세로 merge + sticky(CustomMergeManager), merge 는 row data only | #95, #108, #89, #69, wijmo-merge-row-data-only | `P:` 해당 패턴 보유 화면 지시, 예제 `prompts/examples` |
| D5 | 공통버튼 = hotkeyConfig 만(그리드 자체 toolbar 금지) → **활성 그리드 라우팅**(focusedSheet); 신규행 Insert 위치·컬럼 필터 규약; Insert 복사·셀 모달 파생 컬럼 = AS-IS 1:1 | #97 common-button-grid-routing, #144, #143 | `T:` `handleAddRow/RemoveRow` 활성 그리드 분기, `DoD:B07` |
| D6 | selectionMode 명시, 자동 체크 금지, loadedRows 4 패턴, 셀 종속 combo: beginningEdit dataMap 스왑 + cellEditEnded 전체 원복, 계단식 clear, modal preSearchParams = 클릭 행값 | #21 grid-interaction, #5 §5-G, #18 grid-cell-interaction | `T:` CellDoubleClick→모달 preSearchParams+selectedRow, `P:` |
| D7 | 사용자 컬럼 표시설정 popup 5단계 + 재진입 복원(localStorage mount 1회 복원, handleApply 직접 setItem) | #20, #23 | `P:` 참고 |
| D8 | PIVOT 헤더 드릴다운(M→W→D 토글, AS-IS 1:1), 동적 컬럼 NVL wrap(NULL 키 누락 방지), titleset 'C' 캐시 면역, 다단 grid + 하단 tab = lazy fetch | #103, #32, #115, #81 | `P:` PIVOT 화면 지시, `M:` |
| D9 | 우클릭 커스텀 메뉴: dismiss 는 `mousedown {once:true}` 가 아닌 click 단계 | #102 | `P:` 참고 |
| D10 | 편집 가능 그리드 + BE `EDIT_FLAG='N'` 환경 → 화면 측 `beginningEdit` 등록(의도 binding 만 `e.cancel=false`) | UI체크 3.1 | `T:` 주석, `P:` |

## E. 조회조건·폼·콤보·메시지·i18n
| # | 룰 요지 | 출처 | Vibe 적용 |
|---|---|---|---|
| E1 | Form = `SearchArea`/`FormItem`/`CustomDropdown`/`ItemField`/`ProjectField`/`OwnerField`; 2단(6필드) 초과 → `extraConditions`; 3단↑ 펼침/닫기 토글; SearchArea 부재 시 SubTitle `searchAction`; 모든 조회조건 객체 높이 36px | #51, #52, #83, #53, #94 | `T:` Form 템플릿(공용 필드 우선), `DoD:B14~B17` |
| E2 | **Division 변경 시 하위 'ALL' reset + Grid 비움 + CRUD pending reset**(재조회는 Search), Map dedup, `useTabComboQueries` 1RT, `filters` 인라인 객체 리터럴 금지(참조 비교 → 무한 재요청) | #5 cascade-combo-filter §1.4, #70 | `T:` MyDivision effect·`toFilter`, `G:R08` |
| E3 | 콤보/모달 옵션 = 룩업 조회(하드코딩 금지, 빈 결과 fallback), 날짜 셀 표시↔검증 형식 일치; CMBO_SQL `@var` → `TO_CHAR()` wrap | #87, #29 | `T:` CustomDropdown multiple 패턴, `G:B16`(라벨 하드코딩) |
| E4 | 조회조건 AS-IS↔TO-BE 카탈로그(`_rules_v2/_mapping/search_conditions_scp_dm.md` 953행) 와 데이터 소스 1:1 정합 — 명칭·유형·팝업 그대로, 공유 CMBO 보호 | #112, #117 | `rules/map_field.csv`·`map_control.csv`(mined), `P:` 카탈로그 경로, `G:G02` |
| E5 | 메시지 = `useMessageStore`(alert/confirm/yesNoCancel/toast) 만, `window.alert/confirm` 0; **AS-IS MSG_ID 그대로 사용 금지**(54/61 의미 재배정) → To-Be 등록 코드로 재매핑, 미확정은 `LBL?????`/`MSG?????` 표시 | #26, #114 msg-id-asis-tobe-conversion | `T:` `t('LBL?????','_x')`, `G:F12`(WARN) + `G:R03`, `rules/lbl_codes.csv` |
| E6 | i18n KO=EN 동일 + CN fallback, `LBL`+5자리, LBL/MSG 신규 채번은 1000 대역(LBL01001·MSG01001~), `SCM_ADM_MSG_M` 이관은 `INSERT … NOT EXISTS` 전용 | #22, #98 §7.1, #140 | `gen-register-sql` BLOCK 1(기존 MSG 있으면 보존), `M:` |
| E7 | 저장 대상 행 판정 = `CRUD_TYPE` 전용(rowStatus/isNew 류 신설 금지), 감사키 빈문자열 금지, `apiClient.post(call-proc)` 직접 호출 시 `res.status>=400 || Number(res.data.code)` 판정 | #99 §0, gate §1-3 | `T:` handleSave 스텁, `G:R09/R10/R15`, `check-ui-gates.ps1`(유지) |
| E8 | Excel Form/Upload 보유 화면 = DMF0082 정본(2단), 업로드 SP 값 파싱은 NLS·셀서식 무관 | #135, #147 | `P:` 해당 화면만 |

## F. 버튼·권한·저장·응답
| # | 룰 요지 | 출처 | Vibe 적용 |
|---|---|---|---|
| F1 | SubTitle 11 버튼 = `hotkeyConfig` 1 객체 자동 매핑(search/save/addRow/removeRow/refresh/excel…), AS-IS CRUD 6 + Aux 4 버튼 매핑표, 공통 버튼 override 3줄 이하(빈 본문) = 기능 비활성 | #63, #1, `rules/map_button.csv` | `T:` handlers→hotkeyConfig, `DoD:B06~B09`, 매핑 `D00-1-nnn` |
| F2 | `useProcMutation` onSuccess override 시 default invalidate+toast 명시; 저장 후 toast + 재조회(readback) | #28, #131 ui-save-idempotent-readback | `T:` handleSave 스텁 주석, `P:` |
| F3 | 저장 멱등성: 조회가 PIVOT/GROUP BY 축이면 저장도 그 축 보존(유령 행 금지); SAVE payload 편집=`'M'` 신규=`'I'`, FE dedup 키 = SP GROUP BY 키 | #131, #99 | `P:` SAVE 보유 화면, golden 테스트(`golden.py` --write ROLLBACK) |
| F4 | SP OUT cursor 이름 ↔ FE response key 정합(`o_rc` / `O_RESULT_CURSOR` fallback chain) | #80 | `T:` `data?.o_rc ?? []`, `DoD:B05` |
| F5 | call-proc 500 진단 5종: PROC_M 미등록 / SP INVALID / 파라미터 mismatch / 커서 누락 / 권한 | 21_TROUBLESHOOTING §7, #100 | `E:` calls 어노테이션 HTTP<400, `M:` |

## G. BE (하네스는 BE 무변경이 기본)
| # | 룰 요지 | 출처 | Vibe 적용 |
|---|---|---|---|
| G1 | 신규 BE 작성 전 **동적 SP 인프라 재사용**: generic call-proc(`/api/{MENU}/{sheet}/{action}/call-proc`) 메타 배선으로 Java 무변경 가능한지 먼저 확인 | #4 be-infrastructure-reuse, #75 be-api-contract-ui | 하네스 기본 = 메타 배선(API_M/BTN_MPG) + PKG, BE 코드 생성 없음 |
| G2 | 부득이 BE 작성 시: 패키지 `com.lgcns.nscm.{domain}.{feature}`, `{Feature}Controller/Service/ServiceImpl`, DTO `dto/`, MyBatis `sql/{domain}/{Feature}.xml`, `successResponseEntity`(ResponseEntity 직접 금지), `@RequiredArgsConstructor`+final, Slf4j, `nameSpace + "method"`, 주석 헤더 | `.claude/rules/01-be.md` | `M:` 가이드 제공 |

## H. DB / Oracle PL/SQL (PKG 이식 — port_pkg.md 가 Claude 에 주입)
| # | 룰 요지 | 출처 | Vibe 적용 |
|---|---|---|---|
| H1 | MSSQL 키워드 잔존 0: DATEADD/CHARINDEX/STRING_SPLIT/GETDATE/ISNULL/IIF/N'…'/NOLOCK/TOP/`+`문자열/CONVERT/#temp/@@ | 절대금지 ⑩, 01_MSSQL_to_Oracle_Conversion_Rules | `G:P01~P19`(check-pkg) |
| H2 | 널 센티널 `'-'` 통일: 비교·JOIN 양변 `NVL(x,'-')`, NOT NULL INSERT `NVL(x,'-')/NVL(x,0)/SYSDATE`; `NVL(x,NULL)` 금지 | #119, #127 | `G:P30`(NVL(x,NULL)) · 센티널은 `P:` |
| H3 | DATE 파라미터 원시값·단일인자 `TO_DATE` 금지, `TO_CHAR(date)` 무마스크 금지(NLS 암묵변환) | #109 | `G:P32/P33` |
| H4 | GET SP = `O_RC` + `O_RESULT_CURSOR` dual OUT(O_RC 가 PROC_RESULT); SAVE SP = `JSON_TABLE '$[*]'` + entry/HIST 동시 | #56, #58 | `gen-pkg` 골격, `G:P91` |
| H5 | EXCEPTION OTHERS 는 디버그 친화(개발=SQLERRM 명시, 운영=표준+로그), `UTL_CALL_STACK.SUBPROGRAM(1)(N)` 는 `.COUNT>=N` 체크 | #57, #62 | `gen-pkg` 골격, `G:P92/P36` |
| H6 | GTT `TRUNCATE` 금지 → `DELETE`; `@@FETCH_STATUS` 변환 시 FETCH 직후 `%NOTFOUND` 재할당; 도입부 `ALTER SESSION … PARALLEL DML` 은 트랜잭션 가드; 멀티선택 필터 = GTT 사전적재 후 JOIN / 빈값·'ALL' = 조건 skip | #107, #116, #110 | `G:P31`, `P:` |
| H7 | 성능 순서 고정: ①SELECT 목록 함수 제거(JOIN) → ②인덱스 타는 구문 → ③힌트. 상관 UPDATE→MERGE, per-row 스칼라 함수→GTT 사전 적재, REGEXP/split/lookup 안티패턴, SARGable, `SUBSTR(s,0,n)` 정규화, CI collation 등가 상실(UPPER 비교) | #129, #111, #85, #31, #61, #118 | `G:P34/P35/P37`(WARN), `P:` |
| H8 | PIVOT 동적 컬럼 NVL wrap, 대량 조회/저장 CLOB 버퍼(V_SQL_TEXT 누적, '^' bulk 홀더) | #32, #106 | `P:` PIVOT 화면 |
| H9 | 적재 유일성은 PK 기준 명시 + 예외 전파(삼킴 금지); DEPT_ID 원천 = `SCM_MST_SITE_ITEM.DEPT_ID` 단일 | #137, #150 | `P:` SAVE/적재 SP |
| H10 | 가짜 구현 18종 금지(상수 반환·빈 커서·하드코딩 샘플…) → 실추출; SP body 수정은 원본 최소 변경 + 3축 검증 | #59 sp-no-fake-data-extraction, #55 | `G:P00/P20/P21` TODO/ASIS 잔존 BLOCK, `G:P38`, golden 테스트 |
| H11 | 배포 검증 = **대상 객체 실측**(다른 객체 상태로 PASS 금지), 저장 SP 테스트 전 내부 COMMIT·DML·메일 연쇄 실측 → ROLLBACK 가능 여부 판정 | #136, #104 | `run_sql.py` USER_ERRORS 대상 객체, `golden.py --write` 는 ROLLBACK 전용 |
| H12 | patch 종결자 `END;` + 별행 `/`, 의존 순서, `ALL_SOURCE` 덤프엔 `CREATE OR REPLACE` 없음(조립 3계약) | #60 | `gen-pkg`·`run_sql.py` 블록 분리 |
| H13 | 사내/클라우드 메타 INSERT = NOT NULL 전수 + LBL/MSG 1000 대역 + MSG 는 INSERT NOT EXISTS; 조회 0행 silent = PROC_M 순서 뒤틀림부터 의심 | #98, #140, #100 | `gen-register-sql`, `check-notnull-insert.ps1`(유지) |

## I. 런타임·정적 함정 (사고 카탈로그 — 반복 누락 방지)
- zustand selector `?? []`/`?? {}` fallback 금지(초기값 stable 참조) · `useTabProcQuery({filters})` 인라인 리터럴 금지 · `<DataGrid initialized>` 금지 · `extends WijmoRowItem` · dynamicColumns height/allowSorting/allowMerging · P9 `customContentArea` 자체 footer · `set({…})` 즉시 교체 금지(immer draft) · `@foundation/lodash` · 17 타입 패턴 self-check(pnpm 없이 grep). — (#70, #43, #45, #64) — `G:R05~R13`, `T:` 템플릿이 금지 패턴을 애초에 안 만듦.
- Vite + `@lges/design-system` dayjs/locale dynamic import(§6), Wijmo `finishEditing null`(§3.1), `mergeManager===null`(§9.1), PivotGrid 필드 미표시(§9.2), 신규 sheet ORA-01403(§9.5), SQL*Plus `SQL%ROWCOUNT` ORA-00911(§9.6). — (`Doc/_dev_rules/21_TROUBLESHOOTING.md`) — `M:` 증상→절 역인덱스로 참조.

## J. 완료 정의 (screen-completion-gate 8 게이트 → Vibe DoD)
| 게이트 | 내용 | Vibe 대응 |
|---|---|---|
| ① AS-IS 4축 매핑 | EID 1:1 대사표 빈 칸 0 | `__asis-mapping__.md` `G:M01~M05/G02`, `DoD:B01~B03/B19` |
| ② 버튼 매핑 | CRUD 6 + Aux 4 | `DoD:B06~B09` |
| ③ Grid/Column 메타 | 시트×DIV 컬럼 = 메타 | `DoD:B03/B12/B18`, `G:G01`, Recon 시트 대사, `E:` columns 어노테이션 |
| ④ 메타·라우팅 | 7영역 등록 + MNU_URL=폴더 | `<ID>_registration.sql` BLOCK 8 검증 |
| ⑤ 정적 | type/lint 0, Hard Boundary 0 | `check.js --final`, `applied.json` |
| ⑥ 런타임 smoke | 화면 열림·조회·모달 OK/Cancel·편집→저장→toast | `E:` smoke/crud/auth 스펙 |
| ⑦ 권한·Division | 계정×DIV 매트릭스 | `E:` auth(12계정×40/81/82) |
| ⑧ 보고 | 증빙 경로 첨부 | `PIPELINE.md`(단계·소요·다음 할 일) + `DOD.md` |
- 추가: UI 메타 실소비 + CRUD 경로 전수 커버리지(#130), 통합테스트 UI 공통 6항목(Insert 필터 clear/조회 confirm MSG00703/설정 복원…)(#133), 보완요청 종결 = 증상 재현·해소 실측(#149). — `E:` crud 스펙 + `M:`.

## K. 분석 산출물 (AsisFacts 가 대체한 영역 — 유지되는 원칙만)
- 화면별 `.cs`+`.Designer.cs` 전체 Read, `MessageHelper.GMessageBox` 전수(Validation), `LockColumn/LockRange/SetValue`(Expression), `new XxxPopup()` 전수, 호출 SP·테이블 인벤토리, 동적 생성 UI 는 소스로만 확인. — (v7.4 룰, `.claude/rules/03-analysis-docs.md §B`, #124) — AsisFacts Pack(controls/events/endpoints/validations/expressions/popups/grid_effective) + 교차검증이 자동 수행; xlsx 13시트 산출물 자체는 더 이상 만들지 않음(`20_RULES_SKIP.md`).
- As-is 탐색은 인덱스(Fact Pack) 행 기준, 트리 전체 Glob/Grep 금지; 인덱스에 없는 파일이 필요하면 탐색 대신 보고. — (`CLAUDE-rules-snippet.md`) — `P:` new_screen.md 입력 1~7.
