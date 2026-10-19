# SCP0009 Shipment Plan FG — AS-IS ↔ TO-BE 매핑

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0009_Shipment_Plan_FG/SCP0009_Shipment_Plan_FG.cs`(4,748줄)
TO-BE: `nscm-fe/features/supply/src/pages/shipment-plan-fg/`
설계 근거: `.atlas/gscm-design/SCP0009/design/00~03_*.md`, 전환 계획: `.atlas/gscm-design/SCP0009/convert-flow/{goal,plan}.md`

## 1. 영역1 Layout (`ShipmentPlanFg.tsx`)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| `usrConditionPanel1`(HidePanel) | `MainTitle openSearchArea/toggleOpenSearchArea` | 구현 |
| `splitContainer1/2`(고정비율 425/581, 958) | `ShipmentPlanFgGrid` 단일 컬럼 레이아웃(spdPeggingInfo/spdPlanProblem 은 모달로 대체) | **부분구현** — AS-IS 는 3그리드 동시 노출(상하/좌우 split), TO-BE 는 더블클릭 시 모달로 열림. 화면 레이아웃 자체(고정 split)는 미구현 — 사용자 확인 필요 |
| `.cs:1211-1218` CboDivision_SelectedIndexChanged→btnNewControl | `canCreateNew` 파생상태(`ShipmentPlanFg.tsx`) | 구현 |
| `.cs:3977-4004` Set_FixButtonEnabled | `isLockedPlan` 파생상태 | 구현 |
| `.cs:1040-1068` BtnFix_Click 가드체인 | `handleFix` — hasButton/조회결과/잠금 가드 3종 구현. `SCP0013_GET_PLAN_TYPE_SAVE_YN` 판정 + 실제 저장 SP 호출 | **미구현**(SP 배선 미확정, §5#4/#6 — convert-sp 후속) |
| `.cs:1070-1102` BtnUnfix_Click(+MSG00016 confirm) | `handleUnfix` — confirm 배선 구현, 실제 저장 미구현 | **미구현**(상동) |
| `.cs:1105-1164` BtnNew_Click(+팝업) | `handleNew` — 가드 3종 구현, `SCM0002_ShipmentPlanInsertPopup` 대응 팝업 | **미구현**(팝업 UI 없음) |
| `.cs:1265-1312` EditButton(잠금토글) | 미구현 — 표준 DataGrid 상시편집 모델 채택(임시) | **사용자 결정 대기**(design 01 §5#5) |
| `.cs:1261-1263` FindButton | `handleSearch` — 필수값+기간 365일 검증 | 구현 |
| `.cs:1314-1316` SaveButton | `handleSave` — dirty 집계까지 구현, TVP 전송 미구현 | **부분구현**(§4.4/§6#6 SP 매핑 미확정) |
| `.cs:1318-1345` ExcelButton | `SubTitle excelFileName` 표준 | 구현(패턴) |

## 2. 영역2 조회조건 (`components/ShipmentPlanFgForm.tsx`)

| AS-IS 콤보 | TO-BE SQL_ID | cascade/필터 | 상태 |
|---|---|---|---|
| cboDivision | `Division_SCP` | 무필터 | 구현 |
| cboBizType | `OperationGroup_SCP`/`OperationGroupEE_SCP` | division EE 분기 | 구현 |
| clbFromSite | `AllPlantSiteDescription_SCP` | division/operationGroup 3갈래 클라필터 | 구현 |
| clbToSite | `ToSiteShipmentPlanFG1_SCP_ALL`/`SaleSiteByDivision1_SCP_ALL`/`AllPlantSiteDescription_SCP`(초기) + `SiteByEndCustomer`/`SiteByEndCustomer40`(Team 변경 2차, iter-3 수정) | division 3원천 분기 + Team 변경 시 81/82 vs 그외 2차 재조회(§2.6) | 구현 |
| clbTeam | `TeambyDivision` | division 파라미터 | 구현 |
| clbCustomer | `EndCustomerByDivisionDept`/`EndCustomerByDivision40` | division 81/82 분기 | 구현(§7#2 하드코딩 비대칭은 AS-IS/DB 자체 문제 — 재현) |
| clbElecType | `LookupCommon` | EE 여부로 Enabled 토글만 | 구현 |
| cboPlanDate/Type/Seq | `DATE_WEEKLY1_SCP_ALL`/`PlanType1_SCP_ALL`/`PlanSeq1_SCP_ALL` | 3단 cascade, PlanType 자동 최신행 | 구현 |
| dCalendar + W26/W52/WLast | `PeriodField` + 프리셋 버튼 | 프리셋 계산 SP(`SCM0001_GET_SCP_DAY_PERIOD`/`_DAILY_PLAN_PERIOD`) 미배포 | **미구현**(SP 미배포, convert-sp 후속 — goal.md ②) |
| btnItem_Id/txtItem_Id | `ItemByDivisionModal` | 구현 |
| btnProject/txtProject | `ProjectByDivisionModal` | 구현 |
| `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) | 미구현(조회조건 저장/복원 기능 자체가 이 화면에 없음) | **해당없음** |

## 3. 영역3 그리드 (`components/ShipmentPlanFgGrid.tsx`, `utils/shipment-plan-fg.editLock.ts`)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| 정보컬럼 44/24/12(§0 전건 INPUT_TP_CD='S') | `shipment-plan-fg.columns.ts` MAIN/PEGGING/PROBLEM_COLUMNS + admin fetch | 구현 |
| division 조건부 hidden(R-A/R-B, 19+12건) | `ShipmentPlanFgGrid` infoColumns 런타임 오버레이 + `buildColumns()` division overlay(iter-3 수정, 아래 §6a NEW1) | 구현 |
| `P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더) | `SHEETS.CALENDAR` 조회 | **확인 필요** — 실측 배포 SP 명은 `PKG_SCP0009.P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL`(all_procedures), design 03 §2.1 은 `PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN` 표기 — 배선 확정 필요(procedures.d.ts 등록 시, convert-sp) |
| `P_MAKE_PIVOT_COLUMNS`(값) | 동일 GET SP(O_RC1) 응답에 포함되는 것으로 가정 | 구현(가정) |
| Bucket×chkSum→visible(§2.4) | `isDynVisible` | 구현 |
| chkAll off 시 그리드 비움+재조회 필요(§2.4 예외) | **미구현** — 현재는 chkAll 값이 filter 파라미터로만 전달, Bucket 변경 시 자동 clear 로직 없음 | **미구현**(확인 필요) |
| Fix 하이라이트(O_RC3, §2.5) | `fixedDayBindings` — D_ 매칭만 | **부분구현** — Weekly 시 W_ 헤더 확산 미구현 |
| Fix-잠금 불일치(AS-IS 기지결함) | 재현 여부 미결정 | **사용자 결정 대기**(§6#3) |
| `BlockCellsChecking`(R-K, 편집가능판정) | `computeEditableRange`+`isMainCellEditable` | 구현(전문 이식, W_ 대표일 산정 방식만 확인 필요 — `dynColRepDate` 주석) |
| SmartColMerge(R-I) | `allowMerging` 컬럼별 토글(Freeze 경계=measure_label) | 구현 |
| 더블클릭 5-가드(R-Q+발견분) | `dblclickHandler` — kind/Bucket/MEASURE==='MKT_FCST' 3종 구현, chkAll 일치 조건은 미반영 | **부분구현** |
| 저장 검증(MSG00084/MSG00317) | `cellEditEndedHandler` | 구현(문구/로직 불일치는 AS-IS 그대로 재현, §4#10) |
| 저장 26필드 TVP 전송 | **미구현** — dirty 집계까지만, SP 매핑 미확정(§6#6) | **미구현** |
| Pegging/PlanProblem 서브그리드 | `PeggingInfoModal`/`PlanProblemModal`(읽기전용) | 구현(SP 미반환 8+6개 컬럼은 빈값 — §6#1/#2 확인 필요) |
| Column/Measure 커스텀(btnColumn/btnMeasure) | `ColumnLayoutModal`(Column 만), Measure 미구현 | **부분구현** |

## 4. 그리드 동작 파리티 게이트(`grid-behavior-parity.md`) 대조

| 판별축 | grep/전수 확인 결과 | TO-BE 매핑 |
|---|---|---|
| 셀 병합(SmartColMerge) | `.cs` 682/1181/1611/3853/3921 — 5건 | `allowMerging` 컬럼 토글 + DataGrid 공용 `CustomMergeManager` |
| Lock 계열(LockColumn/LockRange/SwitchLock) | `.cs` L1284-1302,1588,2353-2564 등 20건 — 전건 `BlockCellsChecking`(R-K) 단일 로직으로 수렴 | `isMainCellEditable`(beginningEdit) |
| 셀 타입 콤보(SetCellTypeCombo) | 0건(design 03 §0 DB 실측 — CELL_COMBO_DATA_TYPE 80행 전건 공백) | 해당없음 |
| FrozenColumnCount | `.cs` L845 `Freeze(0, MEASURE_LABEL+1)` | `FREEZE_ANCHOR_COLUMN='measure_label'`(병합 경계로만 사용, 실제 컬럼 freeze 적용은 미구현 — 확인 필요) |

## 5. 자기점검(self-check) 결과 (convert-core §4.2)

- grep 게이트 10종: 0-hit (상대경로 import / console / inline style / any / direct cast / wijmo 직접 사용 / 자체 행상태필드 / 없는 @shared export / deep import / 감사키 빈문자열) — 자기 화면 폴더(`features/supply/src/pages/shipment-plan-fg/`) 대상 확인.
- `hotkeyConfig` NO-OP 배선: 해당 없음(design 01 §2 — 이 화면은 NO-OP 판정 버튼이 0건, 4개 toolbarOverride 전수 실동작).
- type-check: `pnpm --dir nscm-fe/features/supply type-check` — **PASS**(내 화면 폴더 0 error. 기존 잔존 에러 1건은 `integration-psi`, 이 회차 이전부터 있던 무관 항목).
- lint:fix: `pnpm --dir nscm-fe/features/supply lint:fix` — **PASS**(내 화면 폴더 0 error/0 warning. 기존 잔존 에러 3건 `bod`/`integration-psi` 는 무관).
  - **주의(프로세스 관찰)**: 패키지 전체 대상 `lint --fix` 실행이 `integration-psi` 3개 파일의 import 순서/미사용 import 를 부수적으로 고쳤다(Hard Boundary 위반) — 수동으로 원복 완료, 최종 diff 에는 반영되지 않았다. 후속 activity 는 이 side-effect 가능성을 인지할 것.
- 경계 점검: `git status --porcelain nscm-fe/` — `shipment-plan-fg/` 외 diff 0건(위 side-effect 원복 확인).
- procedures.d.ts: SCP0009 항목 미등록(PROC_M/convert-sp 소관) — `RawProcedureMap` index signature fallback 으로 타입체크는 통과하나 자동완성은 느슨함. 화면 코드는 그대로 두고 convert-sp 완료를 기다린다(Hard Boundary — procedures.d.ts 자기 화면 SHEETS 항목은 허용 범위이나, 80+ 컬럼 SP 시그니처 전체를 이 activity 에서 추정 등록하는 것은 convert-sp 영역 침범으로 판단해 보류).

## 6. 확인 필요 / 미구현 종합 (정직 보고 — 완료 아님, iter-2 재검증 반영)

iter-1 종료 후 `react-gap-audit`(v1, `04_impl-gap-audit.md`)가 H1~H6/M1~M9/L1~L7 22건을 지적했다.
iter-2 는 이 22건을 코드 대비 재검증하고, 가능한 항목은 해소했다. 아래는 재검증 결과다(원 issue id 병기).

### 해소됨(iter-2)

| id | 항목 | 근거 |
|---|---|---|
| H3 | PlanProblem 더블클릭이 열리지 않던 문제 | `ShipmentPlanFg.tsx` `onCellDoubleClick` — `setOpenPegging(true)`+`setOpenProblem(true)` 동시 호출 확인(grep 재확인, 호출부 존재) |
| H4 | spdPeggingInfo/spdPlanProblem 서브그리드 병합 미구현 | `PeggingInfoModal.tsx`/`PlanProblemModal.tsx` `<DataGrid allowMerging={AllowMerging.All} .../>` — `DataGrid.tsx:927`(`allowMerging: allowMerging !== AllowMerging.None`)가 전 컬럼 `allowMerging=true`로 세팅, 두 그리드 전 컬럼이 정보컬럼(AS-IS 전부 `FPMerge.Restricted`)이라 의미상 1:1 대응 |
| H6 | chkAll off 시 그리드 clear+재조회 미구현 | `ShipmentPlanFg.tsx` `handleChangeBucketType` — `if (!sc.chkAll) clearFilters();` |
| M1 | Column/Measure 버튼 hasButton 게이트 없음 | `ShipmentPlanFg.tsx` `showColumnButton={hasButton('COLUMN_SETUP')}`/`showMeasureButton={hasButton('MEASURE_SELECT')}` → `ShipmentPlanFgGrid.tsx` 조건부 렌더 |
| M2 | 더블클릭 5-가드 chkAll 조건 미반영 | `ShipmentPlanFgGrid.tsx` `dblclickHandler` 첫 줄 `if (!chkAll) return;` |
| M3 | Fix 하이라이트 Weekly W_ 헤더 확산 미구현 | `fixedWeekStarts`(weekOrMonthStart 역추적) + `formatItemHandler` W_ 분기 추가 |
| M6 | i18n 키 LBL00000 3곳 재사용 | Pegging=`LBL09996`, PlanProblem=`LBL09997`, Sum 체크박스=`LBL00687` — 3키 분리 확인 |
| M8 | calendar 헤더 SP 명칭 불일치(design 표기 vs 실측) | DB 재조회: `SCM_ADM_API_M.API_ID='P_SCP0009_TITLE_GET'` → `PKG_SCP0009.P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL`(실측 배포본과 동일 이름으로 등록) — 코드/DB 정합 확인 |
| L1 | mount effect clearFilters 미호출 | `ShipmentPlanFg.tsx` mount `useEffect` — `clearFilters();` 첫 줄 확인 |
| L7 | CommonCheckList [화면별] 상세 대조 미수행 | 아래 §7 "CommonCheckList 2.95" 표로 이번 회차 수행 |

### 이번 회차(iter-2) 신규 발견·조치 — react-gap-audit 밖의 독립 발견

| # | 발견 | 조치 |
|---|---|---|
| A | Fix/Unfix 저장 호출이 `mnuBtnCd` 세그먼트를 둘 다 `'FIX'`로 고정 — BE `CustomAuthorizationManager.checkMenuBtnAuth`가 URL 3번째 세그먼트로 권한판정(`SCM_ADM_USER_GR_MNU_BTN_MPG_M`)하므로, 그룹별 FIX/UNFIX 권한이 다르면 Unfix 가 FIX 권한을 요구하는 오류가 됐다 | `saveFixDataset(action, fixReason)`로 시그니처 변경, `handleFix`→`'FIX'`/`handleUnfix`→`'UNFIX'` 세그먼트 분리(수정 완료) |
| B | 조회조건 14필드(Grid size 합계 42, 2단=24 초과)가 전부 `conditions`에 나열 — `Doc/rules/hooks/04_search_condition_combo/search-area-extra-conditions.md`(#52, nscm-patterns.md §6 "2줄+ 접기/펼치기") 위반 | 필수(*) 6필드+Period(합계 21)만 `conditions`에 남기고, cascade 종속/보조 필터 7필드(FromSite/ToSite/Team/EndCustomer/Electrode/Project/Model, 합계 21)는 `extraConditions`로 분리(수정 완료 — hook 우선순위표 2번 "cascade 종속" 기준) |
| C | `SHEETS.CALENDAR`/`PEGGING`/`PROBLEM` GET 호출이 `useTabProcQuery`(기본 `BUTTON_TYPE.SEARCH`)로 `mnuBtnCd='SEARCH'`+해당 `SHT_NM`을 쓰는데, `SCM_ADM_MNU_BTN_MPG_M`엔 `SHT_NM='main'` 행만 있고 `calendar`/`pegging`/`problem` 행이 없었다(DMF0082 대조 — `spreadTitle`/`futurePriceInfo` 등 서브시트마다 별도 SEARCH 행 등록이 표준). API_M/PROC_M 이 전부 정상이어도 이 매핑 누락으로 세 GET 은 런타임에서 실패한다 | `05_register.sql`에 3개 서브시트 SEARCH 버튼 + 그룹×시트 권한 INSERT 추가 — **DB 적용은 `ora.py exec`가 이 세션(비대화형)에서 승인 차단돼 미적용**(skill.md 2.6 — 재시도 금지, "적용 대기(권한 차단)"로 기록) |

### 미해소(변경 없음 — 여전히 open)

| # | 항목 | 원천 | 축 |
|---|---|---|---|
| H1 | Fix/Unfix/Save 실제 저장 SP 배선 | design 01 §5#4/#6, 03 §4.4 | **배선(FE)은 완료**했으나 런타임 미검증(ERROR) — 이유 2가지: (1) `P_SCP0009_SAVE`/`P_SCP0009_FIX_SAVE` 모두 `SCM_ADM_PROC_M` 파라미터 메타 0행(DB 재확인, GET 4종은 있음: `P_SCP0009_GET_SHIPMENT_PLAN_FG`=23행/`_TITLE_PARAL`=22행/`_PEGGING`=13행/`_PROBLEM`=9행, 하지만 SAVE 2종은 0행) → PROC_M 없으면 BE 가 더미 1행으로 인자개수 불일치 즉시 실패(convert-sp 소관). (2) 이 SP 들의 IN 파라미터가 진짜 Oracle TABLE(TVP, `T_SCP0009_TAB`)인데 `nscm-be` `BaseService`엔 TVP 바인딩 코드가 없다(`callProc`/`callProc2` 둘 다 단순 바인딩/JVARCHAR 문자열 접기뿐) — Hard Boundary(`nscm-be` 수정 금지)로 이 activity 범위에서 해결 불가, 별도 BE 개선 필요 |
| H2 | New Plan 팝업(`SCM0002_ShipmentPlanInsertPopup` 대응) | design 01 §2#5 | 미구현 — 이 팝업은 design/00~03 분석 범위 밖 별도 AS-IS 화면(자체 필드·Insert SP 미분석)이라 추측 UI 금지(anti-simplification §1), 별도 design 서브태스크 선행 필요(변경 없음) |
| M4 | FrozenColumnCount 실제 적용 여부 | grid-behavior-parity §4 | 확인 필요 — admin `_fixed` 메타(`FIXED_FLAG='Y'` 1건=measure_label) 경유 자동 적용 가능성(코드 확인됨), 컬럼 순서 확정 후 실측 필요 |
| M5 | Pegging Info 8개/PlanProblem 6개 컬럼 원천 | design 03 §6#1/#2 | 확인 필요(변경 없음) |
| M7 | Daily Bucket 저장 SP 매핑 | design 03 §6#6 | 확인 필요(convert-sp) — DB 재조회로도 Daily 전용 SP 별도 확인 안 됨, `P_SCP0009_SAVE`(Weekly 명) 단일 SP가 Bucket 무관 처리할 가능성 미확정 |
| M9 | `SCP0013_GET_PLAN_TYPE_SAVE_YN` 판정 SP 실제 호출 배선 | design 01 §5#4 | 미구현 — `procedures.d.ts`에 SCP0013 SHEETS 미등록이라 표준 `useTabProcQuery`로 호출 불가(변경 없음) |
| L2 | Edit(잠금토글) UX 유지 여부 | design 01 §5#5 | 사용자 결정 대기(변경 없음) |
| L3 | Fix 하이라이트-잠금 불일치 재현 여부 | design 03 §6#3 | 사용자 결정 대기(변경 없음) |
| L4 | W_ 컬럼 대표일 산정 방식 | editLock.ts 주석 | 확인 필요(변경 없음) |
| L5 | cboPlanDate/PlanType 신규 LBL 채번 여부 | design 02 §7#6 | 사용자 결정 대기(변경 없음) |
| L6 | 3그리드 동시노출 vs 모달 방식 | design 01 §1 | 사용자 결정(현재 모달 구현 유지, 변경 없음) |
| 6 | 보조 기간계산 SP 2종(W26/W52/WLast) 배포 방안 | goal.md ② | convert-sp 후속(변경 없음) |

## 7. CommonCheckList [화면별] 대조 (2.95, iter-2 수행)

`nscm-patterns.md §6` [화면별] 표 기준(패턴 항목 제외, [화면별]만 대조):

| 섹션 | 항목 | 판정 | 근거 |
|---|---|:---:|---|
| 조회조건 | 검색조건 AS-IS 대비 동일 | 통과 | design 02 §2 16건 SQL_ID 전건 코드 대조 완료(§2 표) |
| 조회조건 | Cascade 콤보 filter 정확 | 통과 | ToSite 3원천/EndCustomer 81·82 분기/PlanType 최신행 자동선택 코드 확인 |
| 조회조건 | 조회조건 변경 시 그리드 깜빡임 | 미확인(사용자 축) | 브라우저 육안 확인 필요 |
| 조회조건 | 필수조건 alert | 통과 | `handleSearch` 5필드+기간 검증 |
| 조회조건 | 2줄+ 접기/펼치기 | **통과(iter-2 수정)** | 위 §6 "신규 발견 B" — `extraConditions` 분리 완료 |
| 조회조건 | Condition 저장/Reset(Period 제외) | 해당없음 | 이 화면은 조회조건 저장/복원 기능 자체가 없음(design 02 §4 `ConditionNotUseList`는 "저장 대상 제외" 의미일 뿐, 저장 기능 자체 부재) |
| 그리드 | 셀 병합 AS-IS 동일 | 통과 | spdMain `allowMerging` 컬럼토글 + 서브그리드 2종 H4 해소 |
| 그리드 | 그리드 필수 항목 alert | 해당없음 | 전 정보컬럼 `INPUT_TP_CD='S'` 읽기전용(§0) |
| 그리드 | CODE 아닌 NAME 표시 | 통과 | 콤보 SQL `CODE`/`NAME` 별칭 규약(design 02), 그리드 콤보 셀 자체가 0건(§0) |
| Division/개인화 | Insert 시 확정 searchParams 기준 division | 해당없음 | 이 화면 Insert 경로 없음(New 는 별도 팝업, H2 미구현) |
| Division/개인화 | 숨김 컬럼 비노출 | 통과 | division 조건부 hidden(EE 3건/40 10건) `infoColumns` useMemo |
| 팝업 | 재오픈 시 검색조건 유지 | 통과 | Pegging/PlanProblem 필터는 store(`setPeggingFilter`/`setProblemFilter`)가 매 더블클릭 시 갱신 — 팝업 자체 로컬 상태 없음(재오픈 시 항상 최신 행 기준으로 재설정, 유지할 "이전 조건"이 없는 구조) |
| 팝업 | 콤마 다중검색 | 해당없음 | 두 팝업 모두 검색 UI 없는 읽기전용 상세 조회 |
| 저장 | C/U/D/R 독립 확인 | **미확인(런타임 축, ERROR)** | Fix/Unfix/Save 3경로 코드는 분리(§6 신규발견 A 로 URL 세그먼트도 분리) 되어 있으나 H1(PROC_M 0행+TVP 미지원)로 실제 실행 자체가 안 됨 — 코드 정적검증으로 대체 불가 |
| 저장 | 필요 영역만 재조회 | 통과 | `setFilter()`(main 재조회)만 호출, pegging/problem 은 `clearDetailFilters` 액션이 있으나 모달 close 시 미호출(경미 — 다음 더블클릭이 filter 를 덮어쓰므로 stale 노출 위험 낮음) |
| 공통 | SubTitle 공용 아이콘 순서 | 통과 | `customButtons` 배열이 New→Fix→Unfix 순, 표준 아이콘(GridColumnSet/Measure)은 그리드 툴바 쪽(Column→Measure 순, 환율 버튼 해당없음) |

## 8. self-check 결과 (iter-2 재실행)

- grep 게이트 10종(상대경로 import 2단↑ / console / inline style(JSX) / any 타입 / deep import 3단↑ / 감사키 빈문자열 등): 0-hit, 자기 화면 폴더 대상 재확인.
- type-check: `pnpm --dir nscm-fe/features/supply type-check` — **PASS**(내 폴더 0 error). 패키지 잔존 에러 1건(`integration-psi/IntegrationPsi.tsx:291` `hotkeyConfig.edit`)은 무관 파일(git status 로 diff 0 확인, 이 activity 발생 아님).
- lint:fix: `pnpm --dir nscm-fe/features/supply lint:fix` — **PASS**(내 폴더 0 error/0 warning). 패키지 전체 실행이 이번에도 `integration-psi` 3개 파일(import 순서 재정렬 2건 + 미사용 상수 제거 1건)을 부수 수정 — 두 차례 모두 수동 원복 완료, `git status --porcelain`으로 diff 0 재확인(Hard Boundary 유지). 후속 activity 도 이 side-effect 재발 가능성을 인지할 것(패키지 단위 lint:fix 스크립트 자체의 구조적 한계 — 화면 폴더 스코프 lint 스크립트 부재).
- 경계 점검: `git status --porcelain -- nscm-fe/features/supply/src/pages/` — `shipment-plan-fg/` 외 diff 0건(위 side-effect 원복 후 재확인). `formation/__asis-mapping__.md`(untracked)는 이 activity 가 생성하지 않은 무관 파일 — 손대지 않음.
- procedures.d.ts: SCP0009 미등록 상태 유지(변경 없음) — `RawProcedureMap` index signature fallback 으로 타입체크 통과. **iter-2 확인**: GET 4종(main/calendar/pegging/problem)은 PROC_M 이 채워졌으므로(23/22/13/9행) procedures.d.ts 등록이 가능한 상태이나, 80+ 컬럼 응답 스키마 전체를 이 activity 에서 추정 등록하는 것은 convert-sp 영역 침범으로 판단해 이번 회차도 보류(§2.3 원칙 유지) — 다만 SAVE 2종은 PROC_M 0행이라 어차피 등록해도 무의미하다는 사실은 새로 확인됨.

## 9. DB 게이트 재확인 (iter-2, `ora.py` 재조회)

| 게이트 | 상태 | 근거 |
|---|:---:|---|
| 메뉴 등록(2.7) | PASS | `SCM_ADM_MNU_M WHERE MNU_ID='SCP0009'` — 1건, `USE_YN='Y'`, `ROUTE_PATH='supply/shipment-plan-fg'` |
| 버튼 등록(2.8, main 시트) | PASS | `SCM_ADM_MNU_BTN_MPG_M` 9건(SEARCH/SAVE/EDIT/EXCEL/FIX/UNFIX/NEW/COLUMN_SETUP/MEASURE_SELECT), `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 18건(2그룹×9버튼) |
| **버튼 등록(서브시트 SEARCH)** | **적용 대기(권한 차단)** | §6 "신규 발견 C" — `05_register.sql` 작성 완료, `ora.py exec` 승인 차단으로 미적용(재시도 안 함, skill.md 2.6) |
| 컬럼/Measure 메타(2.75) | PASS(기존확인) | `SCM_MST_SHEET_COLUMNS` 80건 / `SCM_MST_SHEET_MEASURE` 10건, design 03 §0 실측치와 일치 |
| 콤보/Lookup 메타(2.76) | PASS(기존확인) | SQL_ID 15종 전건 등록 확인(변경 없음) |
| API_M | PASS(적용 완료, 3건 iter-2 문서 보정) | `P_SCP0009_GET`/`P_SCP0009_SAVE`/`P_SCP0009_FIX_SAVE`(기존) + `P_SCP0009_TITLE_GET`/`P_SCP0009_PEGGING_GET`/`P_SCP0009_PROBLEM_GET`(DB 엔 이미 있었으나 `05_register.sql`에 누락돼 있던 것을 이번 회차에 문서로 보정) — 총 7건 |
| PROC_M(파라미터 메타) | **부분 — GET 4종 PASS / SAVE 2종 ERROR** | GET: `P_SCP0009_GET_SHIPMENT_PLAN_FG`=23행,`_TITLE_PARAL`=22행,`_PEGGING`=13행,`_PROBLEM`=9행. SAVE: `_SAVE_ANL_SHIP_PLAN_FG_WEEKLY`/`_SAVE_ANL_SHIP_FG_FIX_DATASET` 둘 다 0행(convert-sp 소관) |

## 10. 종합 판정(convert-core §4.3, iter-2)

**ERROR** — self-check(코드 품질)와 메뉴/컬럼/콤보 DB 게이트는 PASS 이나:
1. 서브시트(calendar/pegging/problem) SEARCH 버튼 등록이 "적용 대기(권한 차단)" 로 남아 있어 그 3개 GET 이 런타임에서 동작하지 않는다(§6 발견 C, §9).
2. Fix/Unfix/Save 저장(H1)은 PROC_M 미등록(SAVE 2종) + BE TVP 미지원으로 런타임 미검증(ERROR) — convert-sp + 별도 BE 개선 선행 필요.
3. H2(New 팝업)·M4/M5/M7/M9·L2~L6 은 미해소(대부분 사용자 결정·별도 SP/BE 작업 대기, 코드 결함 아님).

화면 "완료"는 위 3항목 해소 후 재판정한다. iter-2 는 react-gap-audit v1 지적 22건 중 10건(H3/H4/H6/M1/M2/M3/M6/M8/L1/L7)을 해소하고, 3건의 신규 결함(A/B/C)을 독립 발견·A/B는 즉시 수정, C는 SQL 작성까지 완료(DB 적용은 권한 차단으로 대기)했다.

## 11. iter-3 재검증·수정 내역 (react-gap-audit v2 verdict fail 대응)

입력: `.atlas/gscm-design/SCP0009/design/04_impl-gap-audit.md`(iteration:2, verdict:fail) issues — NEW1(고)/NEW2(중)/NEW3(중) 신규 3건 + H1/H2/M4/M5/M7/M9/L2~L6 기존 12건 미해소.

### 11.1 NEW1 해소 — Division 조건부 컬럼 visible 무력화(고위험)

- **원인**: `utils/shipment-plan-fg.buildColumns.ts` `buildColumns()`가 `if (adminCols && adminCols.length > 0) return adminCols;`로 admin 메타(80행, `VISIBLE_FLAG='Y'` division 무관 고정)를 그대로 반환해, `ShipmentPlanFgGrid.tsx`의 `infoColumns`(division 기준 R-A/R-B 런타임 계산)를 완전히 버렸다.
- **수정**: `buildColumns.ts`에 `DIVISION_CONDITIONAL_KEYS`(`DIVISION_40_ONLY_COLUMNS ∪ DIVISION_EE_ONLY_COLUMNS`, `shipment-plan-fg.columns.ts` 기존 export 재사용) 기반 `withDivisionOverlay()`를 추가 — admin 메타를 authoritative 로 유지하되(다른 78개 컬럼은 무변경), 이 13개 division 조건부 컬럼만 `infoColumns`의 런타임 `visible`로 덮어쓴다(`adminCols.map(withDivisionOverlay)`). fallback 경로(admin 메타 없음)에도 동일 오버레이 적용.
- **검증**: `division='40'`이면 `DIVISION_40_ONLY_COLUMNS`(EXTRA_SPEC 등 10건) visible=true·`DIVISION_EE_ONLY_COLUMNS`(ELECTRODE_TYPE 등 3건) visible=false로, `division` EE* 이면 반대로 계산되는 것을 코드 read로 확인(런타임 브라우저 실측은 미확인 축).

### 11.2 NEW2 해소 — ToSite 2차 재조회(Team 변경 시) 미배선(중위험)

- **원인**: `COMBO.SITE_BY_END_CUSTOMER`/`SITE_BY_END_CUSTOMER_40` 상수만 정의되고 화면 어디서도 참조되지 않았다(design 02 §2.6 clbTeam_SelectedIndexChanged 의 ToSite 2차 갱신 미이식).
- **수정**: `ShipmentPlanFgForm.tsx`에 `siteByEndCustomerComboId = is81Series ? COMBO.SITE_BY_END_CUSTOMER : COMBO.SITE_BY_END_CUSTOMER_40` 분기와 `toSitesByTeam` 콤보쿼리(`divisionId`/`endCustomer`/`deptId`/`projectCode` — DB 실측 SQL_DTL_CTN 토큰과 1:1 일치 확인, 아래 참조)를 추가하고, `sc.teamIds.length > 0`일 때 §2.4 초기 `toSiteOptions`(division 3분기) 대신 이 2차 결과로 대체한다.
- **DB 토큰 재확인**(`ora.py query SELECT SQL_ID, SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('SiteByEndCustomer','SiteByEndCustomer40')`, iter-3 재실측): `SiteByEndCustomer`=`@divisionId,@endCustomer`(+`@sesUserId`), `SiteByEndCustomer40`=`@divisionId,@deptId,@projectCode` — design 02 §2.6 기재와 일치. 빈 값은 CLAUDE.local.md §5 관례대로 `'ALL'` 센티널로 전달(SQL 이 `@x='ALL'` 분기를 명시적으로 처리).
- **미해소 잔여**: design 02 §2.6 라인 135의 "sEndCustomer 타이밍(AS-IS가 EndCustomer 재적재 직후 값을 곧바로 읽어 실질적으로 '이전 선택값'을 씀)"은 AS-IS 소스만으로 의도된 동작인지 우발적 버그인지 판정 불가한 사용자 확인 필요 항목(design 자체가 확인필요로 남김) — TO-BE 는 React 상태 기반으로 "현재" `sc.endCustomerIds`를 파라미터로 쓴다(팀 변경 시 `endCustomerIds`가 함께 `[]`로 리셋되므로 초기 재조회 시점엔 `'ALL'` 센티널로 넘어가 사실상 AS-IS 의 "리셋 직후" 상태와 유사하게 동작). 브라우저 실측(화면 확인 축)은 미완.

### 11.3 NEW3 — O_RC2(Plan 상태 표시) 미착수(중위험, design 갭 동반)

design/01_layout.md·00_checklist.md 어디에도 O_RC2(IS_EDITABLE/PLAN_STATUS/CONFIRM_FLAG 등)의 UI 요구사항이 없다(grep 재확인, 변경 없음) — gap-audit v2 expect 그대로 "design 서브태스크 선행"이 먼저다. anti-simplification §1(추측 UI 금지)에 따라 이번 회차도 미착수 유지, 04_react-gap.md/결과 보고에 "설계 갭 — FE 단독 해소 불가"로 명시한다.

### 11.4 기존 미해소 12건(H1/H2/M4/M5/M7/M9/L2~L6) — 변경 없음

전건 재확인 결과 iter-2 대비 상태 변화 없음(코드/DB 재점검, 아래 §9 DB 게이트 표 그대로 최신). 사유는 §6 "미해소" 표와 동일 — convert-sp(SP 배포·PROC_M)·BE(TVP 바인딩)·design 서브태스크(New 팝업, O_RC2)·사용자 결정(Edit 토글/Fix-잠금 파리티/LBL 채번/레이아웃 구조) 선행이 필요하며 FE 단독으로 해소할 수 없는 항목들이다.

### 11.5 iter-3 self-check

- grep 게이트(상대경로 import/console/inline style/any/direct cast): 수정 2개 파일(`buildColumns.ts`, `ShipmentPlanFgForm.tsx`) 대상 0-hit.
- type-check: `pnpm --dir nscm-fe/features/supply type-check` — PASS(내 폴더 0 error, 패키지 잔존 에러 1건 `integration-psi` 는 무관, 변경 없음).
- lint:fix: `pnpm --dir nscm-fe/features/supply lint:fix` — PASS(내 폴더 0 error/0 warning). 이번에도 `integration-psi` 3개 파일(import 순서 재정렬 2건 + 미사용 상수 제거 1건)을 부수 수정 — 수동 원복 완료, `git status --porcelain`으로 diff 0 확인(Hard Boundary 유지, iter-2 관찰과 동일 재발).
- 경계 점검: `git status --porcelain -- nscm-fe/` — `shipment-plan-fg/` 외 diff 0.
- DB 게이트(2.7/2.75/2.76/2.8): 이번 회차 신규 DB 쓰기 없음(코드 수정만) — §9 표 상태 유지, 서브시트 SEARCH 버튼은 재조회로 이미 PASS 확인(v2 gap-audit 정정 사항 재확인).

### 11.6 종합 판정(convert-core §4.3, iter-3)

**ERROR (변경 없음, 부분 개선)** — NEW1(고위험 불일치) 해소 + NEW2(중위험 미구현) 해소로 react-gap-audit v2 지적 3건 중 2건을 해소했으나, H1(저장 SP 실행체인)·H2(New 팝업)·NEW3(O_RC2 설계갭)·M4/M5/M7/M9·L2~L6 는 전부 FE 단독 해소 불가 항목(convert-sp/BE/design 서브태스크/사용자 결정 선행)으로 여전히 미해소다. 화면 "완료" 판정은 이들 해소 후 재검토한다.

## 12. iter-4 — 확인필요 3건(M4/M5/NEW3) 정밀 재조사 (코드 변경 0건, 순수 분석)

입력: `.atlas/gscm-design/SCP0009/design/04_impl-gap-audit.md`(iteration:3, verdict:fail, confirm_needed:6) — plan.md 남은 todo 없음(1~8 전항목 iter-1~3에 걸쳐 처리 완료) + `convert-flow/iter-3/gap-audit.md` issues. 이번 회차는 FE 단독 해소 불가로 3회 연속 보류돼 온 확인필요 항목 중 코드/DB 정밀 재조사로 해소 가능한 3건(M4/M5/NEW3)을 대상으로 삼았다(skill.md 절차 0 — 피드백 issues 를 이번 회차 작업범위로 확정). **이번 회차는 코드 수정 0건**(투자 대비 리스크 판단 — 아래 §12.3 참조) — gap-audit 의 사실관계 자체를 새 실측으로 교정하는 순수 재조사 회차다.

### 12.1 M4 해소 — FrozenColumnCount 확인필요 → PASS(경계 무모호 확정)

**근거**: `design/03_grid-columns.md §1.A` 44행 전체를 재대조한 결과, SORT_ORDER_NO=80 동률 13행(#32~44: measure_order_no/biz_type/to_site/from_site/SHIP_FROZEN/bod_id/KEY_IDX/BOD_FROM_YYYYMMDD/BOD_TO_YYYYMMDD/plan_start_yyyymmdd/plan_type/seq/to_yyyymmdd)은 **전건 `VISIBLE_FLAG=N`(hidden)** 이다(표에 이미 기재돼 있었으나 iter-1~3 은 "동률 13건의 순서를 확정 못함"에만 집중해 이 사실의 함의를 놓쳤다). Freeze 경계(`.cs` L845 `Freeze(0, MEASURE_LABEL_idx+1)`)는 `measure_label`(#31, `SORT=999`, `FIXED_FLAG='Y'` 유일 1건) 바로 다음이며, 그 뒤에 오는 80-동률 13건은 전부 비가시 컬럼이라 **화면에 렌더되지 않는다 — 이들 상호간 순서는 freeze 경계(가시 영역)에 어떤 영향도 주지 않는다.** 가시 컬럼(#1~30) 구간에는 SORT 동률이 없다(1~29 + 85 + 90, 전건 유일값). 현재 구현(`ShipmentPlanFgGrid.tsx` — DataGrid 가 admin `FIXED_FLAG` 메타를 그대로 경유, 화면 코드가 `frozenColumns`를 직접 넘기지 않음, iter-3 grep 재확인 유지)은 이미 정확하다 — **코드 변경 불요**.

**재분류**: `confirm_needed` → **PASS**(freeze 경계 확정, 브라우저 육안 확인만 남음 — 결과 자체는 모호함 없이 확정됐으므로 "사용자 확인 축"이지 "확인 필요(ERROR)" 축이 아니다).

### 12.2 M5 해소 — Pegging 8개/Problem 6개 컬럼 원천 → PASS(AS-IS도 공백, TO-BE 이미 파리티)

**근거**: 두 갈래로 확정했다.

1. **SP 본문 직접 실측**(`ora.py query "SELECT line, text FROM all_source WHERE name='PKG_SCP0009' AND type='PACKAGE BODY' AND line BETWEEN 3845 AND 3968"` — `P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING`/`_PROBLEM` 전문 재확인, design 03 §1.B/§1.C 가 이미 지목한 SELECT 컬럼 목록과 100% 일치): Pegging SP 는 16개 컬럼만 반환(PEGGING_OPERATION_CODE/SEGMENT2 AS PEGGING_OPERATION/ITEM_ID/ORIGIN_FROM_DIVISION_ID/FROM_SITE/ORIGIN_TO_DIVISION_ID/TO_SITE/DUE_DATE/PLAN_START_DATE/PLAN_END_DATE/OPERATION_GROUP/ELECTRODE_TYPE/REQUIRED_QTY/PLANNED_QTY/PROBLEM_TYPE/LPST/STOCK_PLAN_LOT_ID) — `problem_seq`/`REQUEST_TIME`/`RESPONSE_TIME`/중복 `OPERATION_GROUP`·`to_site`/`ENG_PROBLEM_TYPE`/`ENG_PROBLEM_DESC`/`problem_qty` 8개는 SELECT 절에 없다(재확인, 변경 없음). Problem SP 는 6개(PROBLEM_SEQ/ENG_PROBLEM_TYPE/ENG_PROBLEM_DESC/REQUEST_TIME/RESPONSE_TIME/PROBLEM_QTY)만 반환 — `nick_name`/`EXTRA_SPEC`/`ELECTRODE_TYPE`/`ORIGIN_TO_DIVISION_ID`/`boh`/`to_site_name` 6개는 SELECT 절에 없다(재확인, 변경 없음).
2. **AS-IS `.cs` 전수 grep**(`grep -n "siPeggingInfo\.|siPlanProblem\."` 전체 4,748행 대상 — iter-1~3 은 `FindData_PeggingInfo`/`FindData_PlanProblem` 메서드 본문만 읽고 "바인딩 처리부를 특정 못함"으로 남겼으나, 이번 회차는 **두 식별자의 전체 참조를 파일 전체에서 전수 확인**했다): `siPeggingInfo.`/`siPlanProblem.` 참조는 `InitSpread_2`의 헤더 컬럼 셋업(`SetSheetHeaderColumn`, division 조건부 visible 3건)과 `FindData_PeggingInfo`/`FindData_PlanProblem`의 `Query()`+`LockColumn()`+`SmartColMerge()` **외에 단 한 건도 없다.** 즉 AS-IS 자체에 이 8+6개 컬럼을 채우는 "부모 행 컨텍스트 복사" 코드가 **존재하지 않는다** — 추정이 아니라 전수 검색으로 부재를 확정했다. (참고로 `NICK_NAME`/`TO_SITE_NAME`/`BOH`/`ELECTRODE_TYPE`/`ORIGIN_TO_DIVISION_ID`/`ORIGIN_FROM_DIVISION_ID` 필드명 자체는 코드에 있으나, 이는 `InsertRow()`의 New-Plan 행 삽입 로직(L2092-2200, `dtCaller`=Main 그리드 자신의 캐시 데이터에서 복사)에서 쓰이는 **Main 그리드(spdMain) 컬럼**이며 Pegging/Problem 서브그리드와는 무관하다 — 동명이인 함정, H2 New 팝업 구현 시 참고할 사실이지 M5 와는 별개.)

**결론**: AS-IS 는 이 8+6개 컬럼을 **화면에서 실제로 항상 공백으로 렌더한다**(SP 미반환 + 바인딩 코드 부재 확정) — "확인 필요"가 아니라 "AS-IS 자체 결함/설계상 빈 컬럼"으로 확정됐다. TO-BE(`PeggingInfoModal.tsx`/`PlanProblemModal.tsx`)는 `buildColumns(META, staticColumns)`(admin 24/12행 전체를 컬럼으로 렌더) + `rows`(SP `o_rc1`반환분만)를 그대로 쓰고 있어 **이미 AS-IS와 동일하게 동작한다**(admin 메타 컬럼은 존재하되 값이 없는 행은 빈 셀) — **코드 변경 불요**.

**재분류**: `confirm_needed` → **PASS**(AS-IS parity 확정, 코드 변경 없이 이미 일치).

### 12.3 NEW3 재분류 — "O_RC2 Plan 상태 표시 설계갭" → 독립 이슈 아님, L2(Edit 잠금토글)에 완전히 종속

iter-1~3 은 NEW3 를 "O_RC2(IS_EDITABLE/PLAN_STATUS/CONFIRM_FLAG 등)를 보여줄 UI 위치가 design 00/01 에 없는 설계 커버리지 갭"으로 분류했다. **이 분류 자체가 틀렸다** — 근거:

1. **O_RC2 필드 계약은 이미 `design/03_grid-columns.md §2.2(L223)·§4(L300)`에 정확히 문서화돼 있다**(`IS_EDITABLE, PLAN_NAME, PLAN_SEQ, PLAN_TYPE, CONFIRM_FLAG, PLAN_START_YYYYMMDD, PLAN_STATUS, CONFIRM_YN, PLAN_TYPE_SEQ, BASIS_START_DATE, PLAN_START_DATE`, `P_BUCKET IN ('WEEKLY','MONTHLY')`일 때만 non-empty) — iter-1~3 의 grep 이 `00_checklist.md`/`01_layout.md` 두 파일에만 한정돼 `03_grid-columns.md`를 빠뜨렸다(재발 방지: 이번 회차 SP 본문(`PKG_SCP0009` L2473-2515, `P_SCP0009_GET_SHIPMENT_PLAN_FG` 자신의 O_RC2 — 오라클 소스 직접 재실측)으로 이 문서 기재가 **정확함**을 재확인했다).
2. **AS-IS `.cs`에서 O_RC2(`dsBinding.Tables[1]`)의 유일한 소비처를 전수 추적**(`grep -n "GetIsEditable|_IsEditable|_plan_Start_Date"` 전체 4,748행): `FindData_Main`(L1568-1575)이 `this._IsEditable = GetIsEditable(dsBinding.Tables[1], ...)`(L3527-3658, PR/MA/SE 3분기 cascade — "다음 Plan Type 이 생성돼 있고 PLAN_STATUS≠-1 이면 편집불가" 규칙, FN/TE 는 무조건 불가)와 `this._plan_Start_Date = ...`를 계산해 인스턴스 필드에 저장한다. 이 두 필드의 **유일한** 소비처는:
   - `_IsEditable` → `EditBlockChecking(2)`(L2019-2023) → **`EditButton()` override(L1265-1299) 내부에서만 호출**(`if (this.IsEditMode && bucket != Monthly) { if (EditBlockChecking(2) != 1) {...unlock...} else {...lock...} }`) — 이것은 AS-IS 의 명시적 "Edit(잠금해제)" 토글 버튼 핸들러 그 자체다.
   - `_plan_Start_Date` → `EditBlockChecking(1)`(BOD 편집범위 계산, 이미 R-K/editLock.ts 로 이식 완료) + `InsertRow()`(New Plan 팝업, H2 소관).
   - **UI 라벨/텍스트박스로 O_RC2 필드를 표시하는 코드는 파일 전체에 0건**(`IS_EDITABLE`/`CONFIRM_FLAG`/`CONFIRM_YN`/`PLAN_TYPE_SEQ` grep 전수 0-hit — `PLAN_STATUS` 만 `GetIsEditable()` 내부 조건식에서 사용, 표시용 아님). **"Plan 상태 표시 영역"은 실재하지 않는다** — constants.ts L6/L22 주석의 "o_rc2=Plan상태"라는 표현이 TO-BE 개발 과정에서 필드명(`PLAN_STATUS`)만 보고 추정한 오독이었다.

**결론**: O_RC2 는 독립적인 "표시 UI"가 아니라 **AS-IS Edit 토글 버튼의 선행조건 게이트**(다음 단계 Plan 이 이미 생성·진행 중이면 현재 단계 편집 재개를 막는 cascade 규칙)다. TO-BE 는 Edit 토글 버튼 자체가 없고(L2, "상시편집" 모델로 임시 구현) 대신 R-K(BOD 기간)만으로 편집가능 범위를 계산한다 — **O_RC2/`GetIsEditable()` cascade 는 L2 가 "AS-IS 토글 모델 재현"으로 결정될 때만 필요한 종속 요구사항이지, 독립된 미해결 항목이 아니다.** L2 가 "TO-BE 상시편집 모델 유지"로 결정되면 O_RC2 cascade 는 아예 불필요(dead requirement)하다. 별도 design 서브태스크는 필요 없다 — L2 사용자 결정 시 이 §12.3 을 구현 근거로 바로 쓸 수 있다(필드 계약·소비 로직·호출 조건 전부 실측 완료).

**재분류**: `NEW3`(독립 medium 이슈) → **폐기, L2 에 흡수**("L2 사용자 결정 시 O_RC2 cascade 구현 필요 여부도 함께 결정" 각주로 L2 항목에 병합). 코드 변경은 L2 결정 이후로 보류(변경 없음 — 리스크: 계획/저장 로직에 영향을 주는 편집가능 여부 게이트를 사용자 결정 없이 임의로 얹으면 오히려 회귀 위험).

### 12.4 iter-4 self-check

코드 변경 0건 — grep/type-check/lint 재실행 불요(변경 파일 없음, `git status --porcelain -- nscm-fe/features/supply/src/pages/shipment-plan-fg/` 로 diff 0 확인). DB 게이트(2.7/2.75/2.76/2.8): 신규 쓰기 없음, `SCM_ADM_MNU_M WHERE MNU_ID='SCP0009'` 재조회로 메뉴 등록 유지만 재확인(PASS, 변경 없음) — 나머지는 iter-3 §9 표 그대로 유지.

### 12.5 종합 판정(convert-core §4.3, iter-4)

**ERROR(부분 개선, 코드 무변경)** — confirm_needed 6건 중 3건(M4/M5/NEW3) 을 정밀 재조사로 PASS/폐기-흡수 처리해 남은 confirm_needed 는 3건(L4/L5 및 §6#2 타이밍 이슈급 저위험)으로 줄었으나, verdict 를 바꾸는 것은 H1(저장 SP 실행체인, convert-sp+BE 선행)·H2(New 팝업, design 서브태스크 선행)·M7/M9(convert-sp)·L2/L3/L6(사용자 결정) 미해소로 여전히 fail 범주다. 다음 회차 최우선순위는 변경 없음: (1) L2 사용자 결정(§12.3 이 그 구현 근거를 이미 완비), (2) convert-sp(H1/M7/M9/L7-period), (3) H2 전용 design 서브태스크.
