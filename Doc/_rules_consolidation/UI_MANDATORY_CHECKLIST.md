# NSCM UI-MANDATORY CHECKLIST (T01 신규 / T01M 수정 — PRE-WRITE 통과 의무)

> ⚙️ **자동 추출본** — 정본 = `Doc/_rules_consolidation/RULESET_MASTER.md`. 직접 편집 금지. MASTER 수정 후 `python scripts/rules/build_router.py` 재실행. (추출일 2026-10-12)

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
- [ ] ⭐⭐⭐ **Figma 디자인 레이아웃 정합** (figma-layout-parity-mandatory): Figma MD(`Doc/_figma/screens/{ID}.md`) 존재 시 §5 레이아웃 구조 → 영역 매핑표 작성 후 **그 배치대로 구현(디자인-우선)**. MD 부재 시 Figma 추출 선행. geometry-only MD 금지(영역 의미 명시). ⚠️ **경계: Figma=디자인 참조 only — 정책(권한/편집/필수값/기능동작/Validation/콤보 값) 판단 금지, 정책 소스=AS-IS 원소스·DB 메타·분석서·사용자 확정** (#90 §1.5, 2026-07-14 사용자 명시)
- [ ] **폴더/명명 4 cross-check**: MENU_ID = 폴더명 = `route-paths.ts` = DB `MNU_URL` 동일 (screen-conventions-mandatory §1.2 / popup-modal-and-routing-mandatory)
- [ ] **동적 속성 3종 admin 데이터 확인** — 부재 시 신규 등록 의무 (ui-dynamic-property-management = master):
  - [ ] Menu Button Visible/Enable → SYS0009 매핑 (menu-button-dynamic-fetch)
  - [ ] Column Visible/Width/Lookup/CellType/Label/Scale → admin (ui-category-setup-column-meta)
  - [ ] Measure Code/Label/Sort/Valid → SYS0004
- [ ] **Grid = 공용 DataGrid 만** 사용, FlexGrid JSX 직접 금지 (datagrid-shared-component-mandatory)
- [ ] **Form = SearchArea/FormItem/CustomDropdown**, 2단(6필드) 초과 시 `extraConditions` 분리 (screen-shell-composition-mandatory / search-area-extra-conditions)
- [ ] ⭐⭐ **폼 스타일 = 공용 common-styles 클래스만** (form-common-styles-mandatory #121): 모든 `<FormItem>` 에 `className={commonStyles.formItem}`(`@foundation/styles/common-styles.module.scss` — HD 50/FHD 140 라벨 칼럼+min-width:0) + 체크박스 셀=`customGrid`/`customCheckbox` + 팝업 검색 InputField=`popupSearchField`. **페이지 로컬 scss 에 폼/인풋 레이아웃 신설 금지**(대체 후 dead 파일 삭제 — 그리드/모달/셀 컬러링 등 화면 고유 스타일만 로컬 유지). 정본 SalesSiteForm.tsx. ⚠️ SearchFields 카탈로그 필드는 미부착 — 인라인 FormItem 혼용 행 라벨 폭 확인
- [ ] ⭐⭐ **SCP·DM 조회조건 = AS-IS↔TO-BE 카탈로그 전 행 대조** (search-condition-asis-tobe-catalog #112): `_rules_v2/_mapping/search_conditions_scp_dm.md`(953행/99화면) 에서 해당 화면 표 확인 — To-Be 명칭·유형·기능·팝업 그대로(명칭 표준: Div→**Div.**/Valid→**Active**/Project→**PJT** 등 13쌍) + 다중선택=**검색+ALL버튼** + 공통기능화 검토 행 SearchArea 승계 금지 + Sun-Set 8화면 사전 보고 + 카운트 일치 보고
- [ ] **SubTitle hotkeyConfig 1 객체**로 11 버튼 자동 매핑 (subtitle-button-actions-mandatory)
- [ ] **권한 분기**: `useTabBtnPermissions` + `hasButton(BTN_CD)` 각 액션 (screen-meta-and-permissions-mandatory)
- [ ] **공용 popup = camelCase 폴더 + 5 파일 + MODAL_XXX(실제 MENU_ID)** (popup-modal-and-routing-mandatory)
- [ ] **cascade**: Division 변경 시 하위 'ALL' reset + Map dedup + useTabComboQueries 1RT (cascade-combo-filter) + ⭐ **Division 변경 시 Grid 데이터 초기화(비움)+CRUD pending reset 의무** (§1.4, 2026-07-14 사용자 명시 — 재조회는 Search 버튼)
  - [ ] ⭐ **Grid 셀 종속 combo/modal** (cascade-combo-filter §5-G): beginningEdit 행값 dataMap 스왑 + **cellEditEnded 전체 dataMap 원복 필수**(누락=타 행 명칭표시 사고) + 계단식 clear(oldVal 비교) + 관대 sentinel + modal preSearchParams=클릭 행값. 콤보 변경 시 사용처 역매핑 — **공유 콤보 SQL 컬럼 추가 금지**(중복표시), 필터 키 반환 콤보 재사용. cascade 정의=화면 constants (AS-IS 실측: 메타 PARAM 없음 — 화면 코드 결정 구조)
- [ ] ⭐⭐⭐ **Modal AS-IS 기능분석 선행 + Cascade/Filter 상세분석 md** (screen-modal-cascade-filter-analysis #123, 2026-08-06 사용자 명시): ①신규 화면에 Modal 있으면 **AS-IS 팝업 .cs 기능분석 후 구현**(오픈 게이트/SP 바인딩/저장 후처리/MSG — DMF0042 Cutoff·Replace SP 뒤바뀜 사고 계보) ②신규 화면 = 조회조건+Grid **Cascade/Filter 전수 상세분석 → `Doc/화면분석서/{UI}_..._Cascade_Filter_전수.md` 생성 후 적용**(정본 양식=DMF0042 판, AS-IS 라인 인용+카운트 일치) ③**UI 보완 시 해당 md 부재면 먼저 분석·md 생성 후 보완**(분석 없는 국소 수정 금지)
- [ ] ⭐⭐⭐ **완료 선언 전 셀프 런타임 검증** (ui-selfcheck-runtime-mandatory #125, 2026-08-07 사용자 명시): ①SP 직접 CRUD 왕복(원복·잔존 0) ②**HTTP E2E 러너** `python _artifacts/_diagnostics/ui_http_e2e.py --menu {MNU}` 8축 PASS(로그인 **guest 단언**·권한 2축·메타·콤보·조회·SAVE 왕복·**모달 시트 전수**·**Division×역할 15계정 로스터**) ③데이터 전제조건 실측 선정("데이터 대기" 명시) ④**모달=MAIN 동등 5칸**(AS-IS 기능 대사·디자인·R·CUD·권한) ⑤완료 선언=게이트/E2E/CRUD **3리포트 경로 첨부**
- [ ] ⭐⭐⭐ **검증 완료 선언 = 3-상태 정직 보고** (verification-completion-honesty #126, 2026-08-08 사용자 명시): 보고는 PASS/**ERROR**/FAIL — ①`ui_gate_runner` **9섹션 전부 실행** 후 종합 ∈ {PASS, WARN(사유가 `__asis-mapping__.md` 에 기재된 것만)} ②리포트 3종 경로 첨부 + **신선도 확인**(`find {페이지} -name "*.ts*" -newer {리포트}` = 0건) ③적용 축 **사내/클라우드 QA/클라우드 DEV 각각** 명시(사내만 적용 = ERROR) ④브라우저 시각·조작감 = **사용자 축, 미완 명시** ⛔ **미실행·미확인·환경파손을 "문제 없음"으로 회신 금지** — 환경 복구까지가 작업 범위. ERROR 행 1개라도 있으면 **종합 판정은 ERROR**
- [ ] ⭐⭐⭐ **4영역 AS-IS 선행 분석 md 세트 + 모달=MAIN 동등 점검** (screen-asis-pre-analysis-mandatory #124, 2026-08-07 사용자 명시): 구현 착수 전 ①디자인(#90 Figma MD+영역 매핑표) ②VALIDATION 전체(제약매트릭스 md) ③EVENT 전체(주요이벤트 md E번호 전수) ④CRUD 전체+종속 모달(Cascade/Filter md + CRUD·모달 매트릭스 `asis_mapping_gate --init`) — **md 완비 전 구현 착수 금지**(보완 T01M 도 부재분 선분석). ⭐ **각 모달별로 MAIN UI 와 동일한 4영역 분석·점검**(CRUD 행 체크만으로 완료 금지 — `MODAL:` 행에 모달별 근거 링크 기입). 완료 = `--check` PASS + ui_gate_runner 리포트 첨부(§3.4)
- [ ] ⭐⭐⭐ **레이아웃 셸 소유·공용 모달·저장 피드백** (ui-layout-shell-modal-feedback-standard #132, 2026-08-12 사용자 명시): ①페이지 최상위 래퍼 div ⛔(`<>` — 셸이 배치 소유) ②DataGrid 감싸는 div ⛔ ③FormItem=`commonStyles.formItem`(#121) ④Measure/Column 모달=공용 컴포넌트(사본 ⛔) ⑤설정 저장=그리드 비움(Division 변경 규약, 자동 재조회 ⛔) ⑥저장 성공=Toast(Alert ⛔)
- [ ] ⭐⭐⭐ **통합테스트 UI 공통 6항목 대사표 축** (ui-common-testitem-mapping-axis #133, 2026-08-12 사용자 명시): 대사표에 `COMMON:UC-01~06` 상시 존재+전 행 판정 — `asis_mapping_gate --check` 가 부재 시 FAIL. Insert 필터 clear/조회 confirm MSG00703/설정 저장 그리드 비움/저장 Toast/Excel Name/콤마 다중 조회
- [ ] **messaging**: `useMessageStore`(alert/confirm/yesNoCancel/toast) — `window.alert` 직접 금지 (messaging-api-and-search-fields-mandatory)
- [ ] **i18n 3언어 동시**(KO=EN 값 동일, CN fallback) + `LBL`+5자리 (screen-meta-and-permissions-mandatory / i18n-ko-en-alignment)
- [ ] **import 규약**: `@tanstack/react-query`→`@foundation/query-client` re-export, 상대경로 정렬, `@foundation/lodash` (react-query-foundation-reexport / relative-import-order)
- [ ] **타입 self-check 17 패턴** (type-check-error-patterns)
- [ ] ⭐⭐ **저장 대상 행 판정 = `CRUD_TYPE` 전용** (hook #99 §0, 2026-08-06 SYS0017 감사): 자체 상태필드(rowStatus/ROW_STATUS/actionFlag/isNew 류) 신설 금지 — 값이 I/M/D 로 같아도 공통버튼·EditTracker 마킹과 단절 → 저장 payload 0건
- [ ] ⭐⭐ **`apiClient.post`(call-proc) 직접 호출 = 결과 판정 의무** (screen-completion-gate §1-3, 2026-08-06 SYS0017 감사): `if (res.status >= 400 || Number(res.data.code))` 실패 분기 — axios responseErrorInterceptor 는 500/403 도 resolve (false success). 정본 `business-plan/utils/business-plan.api.ts:71`
- [ ] ⭐ **런타임 사고 9종 사전 차단** (screen-runtime-pitfalls-mandatory):
  - [ ] ⭐⭐ **`useTabProcQuery({ filters })` 에 인라인 객체 리터럴 전달 금지** (2026-07-29 SYS0017 사고) — `useCustomQueryClient.ts` 는 filters 를 **참조 비교**(`prevKeyRef.current !== filters`)하므로 매 렌더 새 객체가 생기면 removeQueries+재요청이 무한 반복(스피너 안 멈춤). **store 보관 값** 또는 `useMemo` 안정 참조만 전달. 그리드 `selectionChanged` 처럼 고빈도 이벤트가 store 를 갱신할 때는 **동일 값이면 set 을 건너뛰는 가드**를 store 액션에 둔다. 진단: BE 로그에 동일 `mnuId`/`mnuBtnCd` SEARCH 가 초 단위 반복이면 1순위.
  - [ ] zustand selector 의 `?? []` / `?? {}` fallback 사용 금지 — store 초기값에 stable 참조 명시
  - [ ] `<DataGrid initialized={...}>` 사용 금지 (wrapper 가 호출 안 함, deprecated). ⭐ **모든 wijmo 이벤트 핸들러** (`formatItem` / `cellEditEnded` / `beginningEdit` / `loadedRows` / `cellEditEnding` / `selectionChanged` / `gotFocus`) 등록은 `useEffect` + `gridRef.current` (`internalRef` 단독 금지) + dependency `[staticColumns, dynamicColumns]` (`[]` 1회 금지 — mount 시점 ref undefined → 미등록 사고) + cleanup 의무
  - [ ] Grid row interface 는 `extends WijmoRowItem` + 모든 fields non-optional + 인덱스 시그니처 `string | number` 만
  - [ ] dynamicColumns 의 group + 모든 leaf 객체에 `allowSorting:false`, `allowMerging:false` 명시 + DataGrid `allowMerging` prop 결정 매트릭스 따라 명시
  - [ ] ⭐⭐ **No. 코너 헤더 공통 표준** (ui-grid-corner-no-header #108): rowHeader(순번) 쓰는 모든 그리드 — TopLeft 패널 전체 **가로/세로 단일 머지 + 'No.' 라벨**(setCellData 재귀 가드+중앙 정렬). 커스텀 MergeManager 사용 시 **동적 1단(년/년월) 수평 머지 수동 구현**(nested 그룹 네이티브 span 가정 금지 — 설치 시 무효화됨)
  - [ ] admin 메타 INSERT 작성 전 `desc TABLE_NAME` 으로 NULLABLE='N' 컬럼 인벤토리 확인 + INSERT column list 매핑 (`VALID_YN` 등 누락 방지)
  - [ ] dynamicColumns 의 group + 모든 leaf 객체에 **`height`** 명시 — `HEIGHT_BY_COLUMN_DEPTH` 캐노니컬 정합 (1단=48 / **2단=24** / 3단=16). DataGrid wrapper 가 staticColumns 만 자동 처리 → dynamicColumns 누락 시 wijmo default 48 × N (cell 96 rowspan 사고). DMF0007 wrapper 동작 정합. (`packages/foundation/src/utils/columnMapping.ts:27-29`)
  - [ ] ⭐⭐⭐ **디자인 필수 — 조회조건 객체 높이 36px 동일화** (search-condition-height-uniformity #94): Dropdown/Popup InputField/Text/DatePicker/Date input **모든** 조회조건 객체 높이 = **36px** (Main UI + Popup 동일). Main UI=표준 searchFields/CustomDropdown(자동) / Popup raw `<select>`·`<input type=date>`=`height:36px; box-sizing:border-box` / **DatePicker=`.datePickerFix` wrapper 로 전 레벨(MuiBox/FormControl/OutlinedInput) 36 강제** (design-system small 28px overflow 보정 — `sx` forward 안 됨). 조회조건은 **Figma 기준 1단 4개** = 카탈로그 필드 `gridSize` additive prop(default 보존)로 `gridSize={3}`.
  - [ ] **동적 컬럼 편집 의도** + BE 응답 row 의 `EDIT_FLAG='N'` 환경 → 화면 측 `beginningEdit` 핸들러 등록 의무 (`useEffect` mount + dependency `[staticColumns, dynamicColumns]` + cleanup) + 의도 binding 만 `e.cancel = false` 강제 override. wrapper 의 `setEditableColumns` 가 `isEditableCell` (OPTIONAL/MANDATORY 분기 = `editFlag !== 'N'`) 결과로 cancel 처리 → 동적 컬럼 readonly 사고 (DMF0043 master)
  - [ ] ⭐⭐ **P9 상호배타 prop 함정** (2026-08-06 SYS0017 감사): `CustomDialog customContentArea` 지정 = 공통 OK/Cancel footer **미렌더**(CustomDialogContent 삼항) → **자체 footer 구현 의무** (정본 forecast-price ExchangeRateModal). 공용 컴포넌트 낯선 prop 지정 전 소스 조건 분기 확인 + §8C.4 함정 표 전수 확인

### 3.2 화면 수정(T01M) 추가 점검
- [ ] ⭐⭐⭐ **Figma 디자인 레이아웃 교체 필수** (figma-layout-parity-mandatory): 화면 Figma MD(`Doc/_figma/screens/{ID}.md`) 의 영역 배치(상단조건/좌·우/상·하/영역별 컨텐츠)와 현재 구현이 **불일치하면 레이아웃을 디자인에 맞게 교체**한다. 기능(타입/권한/버튼)만 고치고 레이아웃 방치 금지. (사용자 명시 2026-06-26 SYS0014 사고)
- [ ] ⭐⭐⭐ **SHEET_NAME = AS-IS 원본 정정** (sheet-name-asis-preserve-mandatory): 수정 화면의 `SHEETS` value 가 AS-IS SHEET_NAME(AS-IS DB SHEET_COLUMNS 또는 `.cs` `SpdSheet`)과 다르게 개명돼 있으면 **AS-IS 값으로 정정** (FE SHEETS·SP·SHEET_COLUMNS·MNU_BTN.SHT_NM 5구간 동시). 수정 시 적용(일괄 audit 안 함). (사용자 명시 2026-06-26)
- [ ] **Hard Boundary 6종 변경 금지**: `packages/shared` · `foundation` · `lges` · 타도메인 · 타화면 · `nscm-be` (regression-zero-mandatory)
- [ ] **column 재작업 8 점검**: SP NVL / minimal change / patch 종결자 / admin 동기 / binding 매칭 / shared prop / anti-simplification / 사후검증 (column-meta-rework-checklist)
- [ ] **dynamic 컬럼 NVL wrap**: PIVOT NULL → 키 누락 사고 방지 (pivot-dynamic-column-nvl)
- [ ] **공용 prop 추가는 분리 PR** + 4 도메인 regression 0 (regression-zero-mandatory)
- [ ] ⭐ 런타임 사고 9종 (screen-runtime-pitfalls-mandatory) — 신규 화면 동일 적용

### 3.3 POST-WRITE grep (작성 직후 자동 검증)
- [ ] `<FlexGrid` / `<FlexGridColumn` 직접 JSX = 0 (datagrid-shared-component-mandatory)
- [ ] `from 'clsx'` / `from 'lodash'` / `from 'react-i18next'` / `from '@tanstack/react-query'` 직접 = 0
- [ ] `window.alert` / `window.confirm` / raw `alert(` = 0
- [ ] `set({` 즉시 객체 교체(immer draft 아님) = 0 (screen-additional-skills-mandatory)
- [ ] 인라인 `<dialog>` / MUI `<Dialog>` 직접 = 0 (popup-modal-and-routing-mandatory)
- [ ] 진입 Page ≤ 400 라인 (components-folder-pattern)
- [ ] ⭐ 런타임 사고 grep (screen-runtime-pitfalls-mandatory):
  - [ ] `useStore\(s => s\.\w+ \?\? ` = 0 (selector fallback 안티패턴)
  - [ ] `useTabProcQuery` 호출부에 `filters:\s*\{` / `filters=\{\{` 인라인 리터럴(useMemo 밖) = 0
  - [ ] `<DataGrid[^/]*initialized=` = 0 (deprecated prop 사용 금지)
  - [ ] Grid row interface 가 `extends WijmoRowItem` 누락된 곳 = 0
- [ ] ⭐ SYS0017 감사 grep 4종 (2026-08-06 — post-write §0.1 #18~#20 + §0.1-B):
  - [ ] `rowStatus|ROW_STATUS|actionFlag|isNewRow` = 0 (자체 행상태 필드 — hook #99 §0)
  - [ ] 판정 없는 `apiClient.post(.*call-proc` = 0 (후속 5줄 안 `res.status >= 400|.code)` 분기 — gate §1-3)
  - [ ] `map(() => '')|createdBy: ''` = 0 (감사키 빈문자열 — hook #99 §0.1)
  - [ ] util export 함수별 동일 폴더 import 참조 grep — **0건 export = "미배선 의심" 보고 의무** (post-write §0.1-B, SYS0017 실측 5/10)

### 3.4 종료 게이트 (T20 — 종료 선언 전 8 게이트)
> ⛔ ⭐ **완료 선언 = ui_gate_runner 리포트 경로 첨부 의무 (2026-08-07 신설 — 사용자 확인 규약)**:
> `python _artifacts/_diagnostics/ui_gate_runner.py --menu {MNU_ID} --page <페이지폴더>` 실행 →
> `_artifacts/_gate_reports/{MNU_ID}_{ts}.md` (①check-ui-gates G-A~G-G 전 파일 ②asis_mapping_gate --check EID 1:1
> ③wiring_chain_check FE→BE→SP 체인+v2 액션·권한 축 L2A/L2P ④SHEET_COLUMNS 값 단언 ⑤**CRUD·모달 매트릭스**
> --matrix-only) — **리포트 경로 없는 완료 보고 = 미완료 간주**. 런타임 짝 = G6-6 모달별 CRUD 왕복(열기→편집→OK→DB 반영).
>
> `screen-completion-gate.md` 의 8 게이트 의무 + 보고 양식:
> ① AS-IS 4축 매핑 (⭐ **EID 1:1 대사표 — 빈 칸 0**, asis-coverage-check §0.1) ② 버튼 매핑 ③ Grid/Column 메타 ④ 메타·라우팅 ⑤ 정적(type/lint) ⑥ 런타임 smoke (⭐ **§0.5 명시 체크리스트 5항**: 모달 전수 OK/Cancel · 편집→저장→toast+`SCM_COM_SQL_LOG` SAVE 실증 · 저장 후 DB SELECT 왕복 · 콤보 NAME 표시 · cascade 1회 — 2026-08-06 SYS0017 감사 정량화) ⑦ 표준 정합 ⑧ 이관 패키지
>
> ⭐ **G5 정적 검증 강화 (2026-06-19 DMF0043 회고 후)**: type/lint/build 3종 외 `_artifacts/_local_setup/regression-impact.ps1` 실행 → Hard Boundary 위반 0 / 영향 도메인 / `procedures.d.ts` 변경 여부 보고 의무. 사내 nexus 로컬 차단 환경에서 cross-screen 회귀를 commit 후 발견하는 사고 차단. (regression-zero-mandatory §9)

---
