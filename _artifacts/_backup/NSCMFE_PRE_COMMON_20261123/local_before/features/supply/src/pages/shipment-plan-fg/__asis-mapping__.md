# SCP0009 Shipment Plan FG — AS-IS ↔ TO-BE 매핑

AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0009_Shipment_Plan_FG/SCP0009_Shipment_Plan_FG.cs`(4,748줄)
TO-BE: `nscm-fe/features/supply/src/pages/shipment-plan-fg/`
설계 근거: `.atlas/gscm-design/SCP0009/design/00~03_*.md`, 전환 계획: `.atlas/gscm-design/SCP0009/convert-flow/{goal,plan}.md`

## 1. 영역1 Layout (`ShipmentPlanFg.tsx`)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| `usrConditionPanel1`(HidePanel) | `MainTitle openSearchArea/toggleOpenSearchArea` | 구현 |
| `splitContainer1/2`(고정비율 425/581, 958), 하단 서브그리드 `spdPeggingInfo`/`spdPlanProblem` | `ShipmentPlanFgGrid` 단일 그리드 레이아웃. 더블클릭 상세 모달도 두지 않는다 | **의도적 제외**(사용자 결정 2026-10-06) — TO-BE 는 spdMain 하나만 쓴다. 이전에 임시로 있던 `PeggingInfoModal`/`PlanProblemModal` 과 관련 스토어·상수·컬럼 정의, DB 등록분(§16)을 모두 제거했다 |
| `.cs:1211-1218` CboDivision_SelectedIndexChanged→btnNewControl, `.cs:3985/4000` Set_FixButtonEnabled 의 btnNew 비활성 | `canCreateNew = !isLockedPlan && !(EE && A)`(`ShipmentPlanFg.tsx`) — FN/TE/비최신 Seq/EE+A 모두 New 비활성(2026-10-06 정정, 이전엔 TE·비최신 Seq 누락) | 구현 |
| `.cs:3990` `dtPlanSeq.Max(CODE)` | `latestPlanSeq` = Seq 옵션 숫자 최댓값(`ShipmentPlanFgForm.tsx`) | 구현 — 이전엔 마지막 옵션(콤보 SQL `plan_seq DESC` 이므로 최솟값)을 써서 Seq 가 2개 이상이면 기본 상태에서 Fix/Unfix 가 비활성이었다(2026-10-06 정정) |
| `.cs:3977-4004` Set_FixButtonEnabled | `isLockedPlan` 파생상태 | 구현 |
| `.cs:1040-1068` BtnFix_Click 가드체인 | `handleFix` — hasButton/조회결과/잠금/서버 저장가능 판정(`checkServerSaveYn`, 아래 SaveYn 행) 가드 4종 구현. 실제 저장 SP 호출 | 가드 구현. 저장 실행은 **브라우저 미검증**(G2 — JSON 래퍼 경로로 전환됨, §18) |
| `.cs:3661-3705` Get_IsSaveYn — Fix(1056)/Unfix(1086)/New(1119)/Save(2744) 4곳(2026-10-06) | `checkServerSaveYn`(`ShipmentPlanFg.tsx`) — `POST /SCP0009/saveYn/SEARCH/call-proc`(`divisionId`/`planStartYyyymmdd`/`planType`), `o_rc1[0].EDIT_YN==='Y'`만 통과, division 공백이면 호출·메시지 없이 false, 실패는 MSG00182 | 구현 — DB 등록 선행: `SCM_ADM_MNU_BTN_MPG_M`/`SCM_ADM_USER_GR_MNU_BTN_MPG_M` 의 `SCP0009/saveYn/SEARCH → P_SCP0013_SAVE_YN_GET`(ADMIN·SCP Planner, `05_register.sql` 끝, 2026-10-06 적용). 미등록이면 4곳이 항상 막힌다. SP 판정 규칙: `PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN`(동일 Program ID). SP 의 실제 Y/N 반환과 브라우저 동작은 미확인 |
| `.cs:1070-1102` BtnUnfix_Click(+MSG00016 confirm) | `handleUnfix` — hasButton/조회결과/잠금/서버 저장가능 판정 가드 → 선택 확인(MSG00134) → confirm(MSG01438) → 대상 수집(0건이면 MSG01078) → 저장 호출. Unfix 사유는 빈 값 | 가드·수집 구현. 저장 실행은 **브라우저 미검증**(G2, §18) |
| `.cs:4271-4293` SaveData_FixInfo 사유 팝업(`SCM0002_RejectReasonPopup`) + `p_active_flag` I/D(2026-10-06) | `components/modals/FixReasonModal.tsx`(OK 확정 시에만 저장, 빈 값 OK 비활성, 100자 제한·`^` 입력 제거) + `saveFixDataset` 가 Fix='I'/Unfix='D' 전송, Unfix 사유는 빈 값 | 구현(팝업·flag). SP 실측: `P_ACTIVE_FLAG='D'` 일 때만 삭제(PKG_SCP0009.P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET 의 `/* 4. 삭제 */` 블록). 이전엔 `'M'` 고정이라 Unfix 가 삭제가 아니라 UPSERT 로 동작했다 |
| `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06) | `utils/shipment-plan-fg.fix.ts` `collectFixCells`(선택 범위 순회, `SHIP_PLAN_AMEND` 행·보이는 행/컬럼의 D_/W_ 셀, W_ 는 같은 주 D_ 로 펼침, Unfix 는 Fix 셀만) + `hasUnsavedCell`(Fix 시 미저장 편집 셀 있으면 MSG01059 중단) + `buildFixRows`(조회조건 Plan/Bucket 값, 수량 콤마 제거·빈 값 '0'). 선택 없음 MSG00134, Unfix 대상 0건 MSG01078 | 구현 — 이전엔 편집한(dirty) 셀만 대상이라 편집 없이 선택만 해서는 Fix/Unfix 할 수 없었다. 선택 확인은 사유 팝업보다 먼저 한다(AS-IS 는 팝업 뒤). Fix 대상 0건이면 AS-IS 처럼 조용히 끝난다. 확인 필요: Weekly 응답에 D_ 값이 없으면 W_ 펼침 수량이 '0'(AS-IS 도 빈 값 → "0") |
| 가드 메시지 ID(2026-10-06 정정) | `MSG.NO_PERMISSION`=MSG00096(hasButton 가드 alert 추가), `LOCKED_MODE` MSG00010→MSG01046, `CONFIRM_UNFIX` MSG00016→MSG01438 | 구현 — DB `SCM_ADM_MSG_M` 실측: 구 MSG00010="조회조건 저장됨", 구 MSG00016="page not found" 오표시였다. Unfix confirm 문구는 AS-IS "삭제하시겠습니까?"에서 "Release 하시겠습니까?"로 바뀐다(자매 production-plan-line 과 동일, 사용자 승인) |
| 저장 성공 토스트 메시지 ID(2026-10-06 정정) | `SAVE_SUCCESS` MSG00004→MSG00002 | 구현 — DB 실측: MSG00004="No changes to save."(`NO_CHANGE` 가 쓰는 ID)라 Fix/Unfix·Save·Column 저장 성공 토스트가 "변경 없음"으로 표시되던 오표시였다. MSG00002="Saved successfully." |
| `.cs:1105-1164` BtnNew_Click(+팝업) | `handleNew` — 가드 4종 구현(권한 MSG00096 alert / PlanDate 미선택 / 서버 저장가능 판정 / EE+A 차단) 뒤 `NewPlanModal`(`features/supply/src/components/newPlanModal/NewPlanModal.tsx`)을 연다. 저장 성공 뒤 `handleNewPlanSaved`가 비EE일 때 Item 조회조건을 채우고 재조회 여부(MSG01273)를 묻는다 | 구현(2026-10-07). 브라우저 실동작은 BOD 메타 SQL 적용 후 확인 필요 |
| `.cs:1261-1263` FindButton | `handleSearch` — 필수값+기간 365일 검증 | 구현 |
| `.cs:1314-1316` SaveButton → `SaveData_Main`(.cs:2735~) | `handleSave` — 변경 없음 확인 → 서버 저장가능 판정(.cs:2744) → dirty 셀 26필드 payload 조립·전송(`buildSaveRows`/`buildSavePayload`, `POST .../main/SAVE/call-proc`) → 성공 시 재조회 | 가드·전송 배선 구현. 저장 실행은 **브라우저 미검증**(G2, §18). Daily 저장 SP 매핑은 미확정(M7). AS-IS 의 `CheckMandatorySheetColumns`(.cs:2762)는 호출만 확인했고 본문은 읽지 않았다 — §7 "그리드 필수 항목 alert 해당없음"(전 정보컬럼 읽기전용) 판정에 따라 대응을 두지 않았다(확인 필요) |
| `.cs:1318-1345` ExcelButton | `SubTitle excelFileName` 표준 | 구현(패턴) |
| DB 권한 행 `SCP0009 / main / EDIT`(`API_ID` 없음, ADMIN·SCP Planner) | 화면 코드는 `hasButton('EDIT')` 를 쓰지 않는다 | **유지** — 다른 화면(`ShipmentChangeRequestPlan`, `ExchangeRateModal`)이 `hasButton('EDIT')` 를 편집 권한 표식으로 쓰는 것과 같은 형태의 행이다. AS-IS 잠금 토글 버튼과는 별개라 삭제하지 않는다(2026-10-06 확인) |

## 2. 영역2 조회조건 (`components/ShipmentPlanFgForm.tsx`)

| AS-IS 콤보 | TO-BE SQL_ID | cascade/필터 | 상태 |
|---|---|---|---|
| cboDivision | `Division_SCP` | 무필터 | 구현 |
| cboBizType | `OperationGroup_SCP`/`OperationGroupEE_SCP` | division EE 분기 | 구현 |
| clbFromSite | `AllPlantSiteDescription_SCP` | division/operationGroup 3갈래 클라필터 | 구현 |
| clbToSite | `ToSiteShipmentPlanFG1_SCP_ALL`/`SaleSiteByDivision1_SCP_ALL`/`AllPlantSiteDescription_SCP`(초기) + `SiteByEndCustomer`/`SiteByEndCustomer40`(Team 변경 2차, iter-3 수정) | division 3원천 분기 + Team 변경 시 81/82 vs 그외 2차 재조회(§2.6) | 구현(2026-10-07 이후 endCustomer 입력은 §17) |
| clbTeam | `TeambyDivision` | division 파라미터 | 구현 |
| clbCustomer | (TO-BE 조회조건 없음) | AS-IS 는 `Visibility=Never` 숨김 컨트롤(`SCP0009_Shipment_Plan_FG.Designer.cs:1577`). 81/82 만 Team 의 `EndCustomerByDivisionDept` 후보 전체를 To Site 2차 재조회 입력으로 쓴다(§17) | 제거(2026-10-07), G23 종결 |
| clbElecType | `LookupCommon` | EE 여부로 Enabled 토글만 | 구현 |
| cboPlanDate/Type/Seq | `DATE_WEEKLY1_SCP_ALL`/`PlanType1_SCP_ALL`/`PlanSeq1_SCP_ALL` | 3단 cascade, PlanType 자동 최신행 | 구현 |
| dCalendar + W26/W52/WLast | 공용 `PeriodRangePicker`(`quickWeeks={[26, 52, 82]}`) + Plan Date 변경 시 기본 W52 클라이언트 계산(`ShipmentPlanFg.tsx` 기본 조회기간 `useEffect`) | 서버 SP(`SCM0001_GET_SCP_DAY_PERIOD`/`_DAILY_PLAN_PERIOD`) 호출은 하지 않기로 결정(2026-10-06) | 구현(클라이언트 계산) — AS-IS 의 서버 보정(타임존 등) 반영 여부는 확인 필요 |
| cboBucketType | `ShipmentPlanFgForm` Bucket 드롭다운(콤보 `BucketType`, `onChangeBucketType` → `handleChangeBucketType`) | 구현(2026-10-02 정정 — 기존엔 그리드 위 Daily/Weekly/Monthly 버튼. 콤보 `BucketType` 3건 여부는 DB 확인 필요) |
| chkAll | `ShipmentPlanFgForm` ALL 체크박스(`sc.chkAll`, 화면에는 노출하지 않고 기본값 true 로 고정 — 2026-10-07, `useShipmentPlanFgStore.ts` `initSearch`, AS-IS `InitValue="N"` 과 다른 TO-BE 결정. 체크 시 `P_CHK_ALL='Y'` 로 서버 SP 가 Daily 데이터를 로드하며 Bucket 드롭다운은 선택 가능) | 구현(2026-10-02 신규 — 기존 UI 자체가 없어 chkAll 이 항상 false 였다. 2026-10-07 기본값 체크로 변경) |
| chkSum | `ShipmentPlanFgForm` Sum 체크박스(`sc.chkSum`) | 구현(2026-10-02 정정 — 기존엔 그리드 툴바) |
| btnItem_Id/txtItem_Id | `MaterialByDivisionModal`(`ShipmentPlanFg.tsx` import `features/master/src/components`) | 구현 — 이전 문서는 `ItemByDivisionModal` 로 적혀 있었으나 현재 코드는 `MaterialByDivisionModal` 을 쓴다(이 작업 밖에서 바뀐 것을 코드 기준으로 반영). `ShipmentPlanFgForm.tsx` 주석에는 옛 이름이 남아 있다 |
| btnProject/txtProject | `ProjectByDivisionModal` | 구현 |
| `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) | 미구현(조회조건 저장/복원 기능 자체가 이 화면에 없음) | **해당없음** |

## 3. 영역3 그리드 (`components/ShipmentPlanFgGrid.tsx`, `utils/shipment-plan-fg.editLock.ts`)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| 정보컬럼 44(§0 전건 INPUT_TP_CD='S') | `shipment-plan-fg.columns.ts` MAIN_COLUMNS + admin fetch | 구현 |
| division 조건부 hidden(R-A/R-B, 19+12건) | `ShipmentPlanFgGrid` infoColumns 런타임 오버레이 + `buildColumns()` division overlay(iter-3 수정, 아래 §6a NEW1) | 구현 |
| `P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더) | `SHEETS.CALENDAR` 조회 — `SCM_ADM_MNU_BTN_MPG_M` 의 `SCP0009/calendar/SEARCH` 가 API `SCP0009_SHEET_CALENDAR_3SPAN_GET`(= `PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN`)로 연결(2026-10-02 정정, 2026-10-06 DB 재조회로 확인) | 구현. `P_SCP0009_TITLE_GET`(`TITLE_PARAL`)은 어떤 시트 버튼에도 연결돼 있지 않다 — AS-IS 가 Daily 에서 호출하는 SP 이지만 TO-BE 는 쓰지 않는다(§3 Fix 하이라이트 행 참조) |
| `P_MAKE_PIVOT_COLUMNS`(값) | 동일 GET SP(O_RC1) 응답에 포함되는 것으로 가정 | 구현(가정) |
| Bucket×chkSum→visible(§2.4) | `isDynVisible` | 구현 |
| chkAll off 시 그리드 비움+재조회 필요(§2.4 예외) | `handleChangeBucketType` — `if (!sc.chkAll) clearFilters();`(`ShipmentPlanFg.tsx`) | 구현(§6 H6 해소분을 이 표에 반영) |
| Fix 하이라이트(O_RC3, §2.5) | `buildFixedCellSet`/`isCellFixed`(`utils/shipment-plan-fg.fix.ts`) + `formatItemHandler` — 행(KEY_IDX+FROM_SITE+INCOTERMS+BOD_ID)×일자 셀 단위, `SHIP_PLAN_AMEND` 행만, W_ 셀은 Weekly 일 때만(.cs:1655-1731) | 구현(2026-10-06 정정 — 이전엔 날짜만 매칭해 해당 날짜 열 전체가 칠해졌다). Daily 는 SP 의 O_RC3 Bucket 조건(`P_BUCKET IN ('WEEKLY','MONTHLY')`)이 주석 처리된 이후 동작(PKG_SCP0009 BODY last_ddl 2026-10-06 15:13). AS-IS 도 Daily 에서 `TITLE_PARAL` 의 무조건 O_RC3 으로 칠한다(.cs:1401, 1486, 1600) |
| Fix-잠금 불일치(AS-IS 기지결함) | 재현 여부 미결정 | **사용자 결정 대기**(§6#3) |
| `BlockCellsChecking`(R-K, 편집가능판정) | `computeEditableRange`+`isMainCellEditable` | 구현(전문 이식, W_ 대표일 산정 방식만 확인 필요 — `dynColRepDate` 주석) |
| SmartColMerge(R-I) | `allowMerging` 컬럼별 토글(Freeze 경계=MEASURE_LABEL) | 구현 |
| 저장 검증(MSG00084/MSG00317) | `cellEditEndedHandler` | 구현(문구/로직 불일치는 AS-IS 그대로 재현, §4#10) |
| 저장 26필드 JSON 전송 | `buildSaveRows`(일반 저장, dirty 셀) / `buildFixRows`(Fix·Unfix, 선택 셀) → `buildSavePayload`(`{ data: 행 배열 }`) → `apiClient.post .../call-proc`(`utils/shipment-plan-fg.save.ts`) | 배선 구현. **런타임 미검증**(G2 — API_M 은 `_JSON` 래퍼 SP 를 가리키고 BE 는 `data` 배열을 CLOB 으로 바인딩한다. 실제 저장 왕복만 남음, §18) |
| Column/Measure 커스텀(btnColumn/btnMeasure) | `ShipmentPlanFg.tsx` SubTitle `customButtons` 아이콘 버튼(`IcGridColumnSetup`/`IcMeasureSelect`) → `ColumnLayoutModal`(`handleSaveColumnLayout` 이 `saveTitleSet` 'C' 저장 후 `invalidateQueries`+`fetchStaticColumns`) / `MeasureSelectModal`(`saveTitleSet` 'M' 저장) | 구현(2026-10-02 정정 — 기존엔 그리드 툴바 버튼이었고 Column 저장은 `saveTitleSet` 없이 메타 재조회만 했다) |

## 4. 그리드 동작 파리티 게이트(`grid-behavior-parity.md`) 대조

| 판별축 | grep/전수 확인 결과 | TO-BE 매핑 |
|---|---|---|
| 셀 병합(SmartColMerge) | `.cs` 682/1181/1611/3853/3921 — 5건 | `allowMerging` 컬럼 토글 + DataGrid 공용 `CustomMergeManager` |
| Lock 계열(LockColumn/LockRange/SwitchLock) | `.cs` L1284-1302,1588,2353-2564 등 20건 — 전건 `BlockCellsChecking`(R-K) 단일 로직으로 수렴 | `isMainCellEditable`(beginningEdit) |
| 셀 타입 콤보(SetCellTypeCombo) | 0건(design 03 §0 DB 실측 — CELL_COMBO_DATA_TYPE 80행 전건 공백) | 해당없음 |
| FrozenColumnCount | `.cs` L845 `Freeze(0, MEASURE_LABEL+1)` | `FREEZE_ANCHOR_COLUMN='MEASURE_LABEL'`(병합 경계로만 사용, 실제 컬럼 freeze 적용은 미구현 — 확인 필요) |

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
| H6 | chkAll off 시 그리드 clear+재조회 미구현 | `ShipmentPlanFg.tsx` `handleChangeBucketType` — `if (!sc.chkAll) clearFilters();` |
| M1 | Column/Measure 버튼 hasButton 게이트 없음 | `ShipmentPlanFg.tsx` SubTitle `customButtons` 의 `hasButton('COLUMN_SETUP') && {...}`/`hasButton('MEASURE_SELECT') && {...}`(2026-10-02 에 그리드 툴바 조건부 렌더에서 이관) |
| M2 | 더블클릭 5-가드 chkAll 조건 미반영 | **대상 소멸(2026-10-06)** — 하단 서브그리드 제외로 더블클릭 핸들러 자체를 삭제했다(당시엔 `dblclickHandler` 첫 줄 `if (!chkAll) return;` 로 해소) |
| M3 | Fix 하이라이트 Weekly W_ 헤더 확산 미구현 | `fixedWeekStarts`(weekOrMonthStart 역추적) + `formatItemHandler` W_ 분기 추가 — 단 당시 판정은 날짜 열 전체였다. 2026-10-06 에 행 단위 셀 판정(`shipment-plan-fg.fix.ts`)으로 교체(§3 Fix 하이라이트 행 참조) |
| M6 | i18n 키 LBL00000 재사용 | Sum 체크박스=`LBL00687` — 키 분리 확인 |
| M8 | calendar 헤더 SP 명칭 불일치(design 표기 vs 실측) | DB 재조회: `SCM_ADM_API_M.API_ID='P_SCP0009_TITLE_GET'` → `PKG_SCP0009.P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL`(실측 배포본과 동일 이름으로 등록) — 코드/DB 정합 확인 |
| L1 | mount effect clearFilters 미호출 | `ShipmentPlanFg.tsx` mount `useEffect` — `clearFilters();` 첫 줄 확인 |
| L7 | CommonCheckList [화면별] 상세 대조 미수행 | 아래 §7 "CommonCheckList 2.95" 표로 이번 회차 수행 |

### 이번 회차(iter-2) 신규 발견·조치 — react-gap-audit 밖의 독립 발견

| # | 발견 | 조치 |
|---|---|---|
| A | Fix/Unfix 저장 호출이 `mnuBtnCd` 세그먼트를 둘 다 `'FIX'`로 고정 — BE `CustomAuthorizationManager.checkMenuBtnAuth`가 URL 3번째 세그먼트로 권한판정(`SCM_ADM_USER_GR_MNU_BTN_MPG_M`)하므로, 그룹별 FIX/UNFIX 권한이 다르면 Unfix 가 FIX 권한을 요구하는 오류가 됐다 | `saveFixDataset(action, fixReason, cells)`로 시그니처 변경(2026-10-06 에 대상 셀 인자 추가), `handleFix`→`'FIX'`/`handleUnfix`→`'UNFIX'` 세그먼트 분리(수정 완료) |
| B | 조회조건 14필드(Grid size 합계 42, 2단=24 초과)가 전부 `conditions`에 나열 — `Doc/Doc_lgc_bak/rules/04_search_condition_combo/search-area/search-area-extra-conditions.md`(#52, nscm-patterns.md §6 "2줄+ 접기/펼치기") 위반 | 필수(*) 6필드+Period(합계 21)만 `conditions`에 남기고, cascade 종속/보조 필터 7필드(FromSite/ToSite/Team/EndCustomer/Electrode/Project/Model, 합계 21)는 `extraConditions`로 분리(수정 완료 — hook 우선순위표 2번 "cascade 종속" 기준) |
| C | `SHEETS.CALENDAR`/`PEGGING`/`PROBLEM` GET 호출이 `useTabProcQuery`(기본 `BUTTON_TYPE.SEARCH`)로 `mnuBtnCd='SEARCH'`+해당 `SHT_NM`을 쓰는데, `SCM_ADM_MNU_BTN_MPG_M`엔 `SHT_NM='main'` 행만 있고 `calendar`/`pegging`/`problem` 행이 없었다(DMF0082 대조 — `spreadTitle`/`futurePriceInfo` 등 서브시트마다 별도 SEARCH 행 등록이 표준). API_M/PROC_M 이 전부 정상이어도 이 매핑 누락으로 세 GET 은 런타임에서 실패한다 | `05_register.sql`에 3개 서브시트 SEARCH 버튼 + 그룹×시트 권한 INSERT 추가 — **DB 적용은 `ora.py exec`가 이 세션(비대화형)에서 승인 차단돼 미적용**(skill.md 2.6 — 재시도 금지, "적용 대기(권한 차단)"로 기록). 이후 §13.1(iter-5)과 2026-10-06 재조회에서 3건 모두 등록 확인 |

### 미해소(변경 없음 — 여전히 open)

| # | 항목 | 원천 | 축 |
|---|---|---|---|
| H1 | Fix/Unfix/Save 실제 저장 SP 배선 | design 01 §5#4/#6, 03 §4.4 | **배선(FE)은 완료**했으나 런타임 미검증(ERROR). 2026-10-06 에 Fix/Unfix 대상을 선택 범위로 바꾸고(`buildFixRows`) Fix='I'/Unfix='D' 로 보내도록 고쳤지만 서버 실행 여부는 여전히 확인하지 못했다 — 이유 2가지: (1) `P_SCP0009_SAVE`/`P_SCP0009_FIX_SAVE` 모두 `SCM_ADM_PROC_M` 파라미터 메타 0행(DB 재확인, GET 4종은 있음: `P_SCP0009_GET_SHIPMENT_PLAN_FG`=23행/`_TITLE_PARAL`=22행(`_PEGGING`/`_PROBLEM` 은 2026-10-06 서브그리드 제외로 삭제), 하지만 SAVE 2종은 0행) → PROC_M 없으면 BE 가 더미 1행으로 인자개수 불일치 즉시 실패(convert-sp 소관). (2) 이 SP 들의 IN 파라미터가 진짜 Oracle TABLE(TVP, `T_SCP0009_TAB`)인데 `nscm-be` `BaseService`엔 TVP 바인딩 코드가 없다(`callProc`/`callProc2` 둘 다 단순 바인딩/JVARCHAR 문자열 접기뿐) — Hard Boundary(`nscm-be` 수정 금지)로 이 activity 범위에서 해결 불가, 별도 BE 개선 필요 |
| H2 | New Plan 팝업(`SCM0002_ShipmentPlanInsertPopup` 대응) | design 01 §2#5 | **구현(2026-10-07), 브라우저 실동작 미확인** — 분석은 `.atlas/gscm-design/SCM0002/design/00~03`, 구현은 `features/supply/src/components/newPlanModal/NewPlanModal.tsx`·`NewPlanBodModal.tsx`·`newPlan.ts`(vitest 30건) — 2026-10-12 공용 위치로 이동(SCP0010 SEMI 와 공용, programId 분기). BOD 선택 SP 메타(`12_register_bod_popup.sql`)는 DB 담당자가 적용했고 2026-10-08 재조회로 확인했다. 2026-10-08 컬럼 갭 분석으로 Operation Group 이름 표시, Mon~Sun `Voyage` 그룹 헤더, EE의 Electrode Type·Project 이름 편집 조건을 AS-IS(`SCM0002_ShipmentPlanInsertPopup.cs` 396-406, 812-817)에 맞췄다. 컬럼 너비와 날짜 표시 형식은 맞추지 않았다 |
| M4 | FrozenColumnCount 실제 적용 여부 | grid-behavior-parity §4 | 확인 필요 — admin `_fixed` 메타(`FIXED_FLAG='Y'` 1건=measure_label) 경유 자동 적용 가능성(코드 확인됨), 컬럼 순서 확정 후 실측 필요 |
| M7 | Daily Bucket 저장 SP 매핑 | design 03 §6#6 | 확인 필요(convert-sp) — DB 재조회로도 Daily 전용 SP 별도 확인 안 됨, `P_SCP0009_SAVE`(Weekly 명) 단일 SP가 Bucket 무관 처리할 가능성 미확정 |
| M9 | `SCP0013_GET_PLAN_TYPE_SAVE_YN` 판정 SP 실제 호출 배선 | design 01 §5#4 | **해소(2026-10-06)** — `checkServerSaveYn`(untyped `apiClient.post`)으로 호출. `procedures.d.ts` 타입 등록 없이 SCP0009/saveYn/SEARCH 라우팅·권한 DB 등록으로 해결(§1 SaveYn 행). 서버 응답·브라우저 실동작은 미확인 |
| L3 | Fix 하이라이트-잠금 불일치 재현 여부 | design 03 §6#3 | 사용자 결정 대기(변경 없음) |
| L4 | W_ 컬럼 대표일 산정 방식 | editLock.ts 주석 | 확인 필요(변경 없음) |
| L5 | cboPlanDate/PlanType 신규 LBL 채번 여부 | design 02 §7#6 | 사용자 결정 대기(변경 없음) |
| 6 | 보조 기간계산 SP 2종(W26/W52/WLast) 배포 방안 | goal.md ② | **종결(2026-10-06 결정)** — 서버 SP 를 호출하지 않고 공용 `PeriodRangePicker` 빠른선택(`quickWeeks`)과 기본 W52 클라이언트 계산을 쓴다(§2 dCalendar 행). 서버 보정(타임존 등) 차이는 확인 필요 |

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
| 그리드 | 셀 병합 AS-IS 동일 | 통과 | spdMain `allowMerging` 컬럼토글 |
| 그리드 | 그리드 필수 항목 alert | 해당없음 | 전 정보컬럼 `INPUT_TP_CD='S'` 읽기전용(§0) |
| 그리드 | CODE 아닌 NAME 표시 | 통과 | 콤보 SQL `CODE`/`NAME` 별칭 규약(design 02), 그리드 콤보 셀 자체가 0건(§0) |
| Division/개인화 | Insert 시 확정 searchParams 기준 division | 해당없음 | 이 화면 Insert 경로 없음(New 는 별도 팝업, H2 미구현) |
| Division/개인화 | 숨김 컬럼 비노출 | 통과 | division 조건부 hidden(EE 3건/40 10건) `infoColumns` useMemo |
| 저장 | C/U/D/R 독립 확인 | **미확인(런타임 축, ERROR)** | Fix/Unfix/Save 3경로 코드는 분리(§6 신규발견 A 로 URL 세그먼트도 분리) 되어 있으나 H1(PROC_M 0행+TVP 미지원)로 실제 실행 자체가 안 됨 — 코드 정적검증으로 대체 불가 |
| 저장 | 필요 영역만 재조회 | 통과 | `setFilter()`(main 재조회)만 호출 |
| 공통 | SubTitle 공용 아이콘 순서 | 통과 | `customButtons` 배열이 New→Fix→Unfix→Column(`IcGridColumnSetup`)→Measure(`IcMeasureSelect`) 순(텍스트 버튼이 아이콘 앞, 환율 버튼 해당없음). 2026-10-02 에 그리드 툴바 쪽에서 SubTitle 로 이관 — 이전 "통과" 판정은 그리드 툴바 위치를 근거로 한 것이라 `ui-layout.md` 버튼 배치 규칙 위반이었다 |

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
| **버튼 등록(서브시트 SEARCH)** | **적용 대기(권한 차단)** | §6 "신규 발견 C" — `05_register.sql` 작성 완료, `ora.py exec` 승인 차단으로 미적용(재시도 안 함, skill.md 2.6). 2026-10-06 갱신: pegging/problem 라우팅·권한은 서브그리드 제외로 삭제(calendar 만 유지) |
| 컬럼/Measure 메타(2.75) | PASS(기존확인) | `SCM_MST_SHEET_COLUMNS` 80건 / `SCM_MST_SHEET_MEASURE` 10건, design 03 §0 실측치와 일치 |
| 콤보/Lookup 메타(2.76) | PASS(기존확인) | SQL_ID 15종 전건 등록 확인(변경 없음) |
| API_M | PASS(적용 완료, 3건 iter-2 문서 보정) | `P_SCP0009_GET`/`P_SCP0009_SAVE`/`P_SCP0009_FIX_SAVE`(기존) + `P_SCP0009_TITLE_GET`/`P_SCP0009_PEGGING_GET`/`P_SCP0009_PROBLEM_GET`(DB 엔 이미 있었으나 `05_register.sql`에 누락돼 있던 것을 이번 회차에 문서로 보정) — 총 7건. 2026-10-06 갱신: `P_SCP0009_PEGGING_GET`/`P_SCP0009_PROBLEM_GET` 은 서브그리드 제외로 삭제 — 현재 5건 |
| PROC_M(파라미터 메타) | **부분 — GET 4종 PASS / SAVE 2종 ERROR** | GET: `P_SCP0009_GET_SHIPMENT_PLAN_FG`=23행,`_TITLE_PARAL`=22행,`_PEGGING`=13행,`_PROBLEM`=9행. SAVE: `_SAVE_ANL_SHIP_PLAN_FG_WEEKLY`/`_SAVE_ANL_SHIP_FG_FIX_DATASET` 둘 다 0행(convert-sp 소관). 2026-10-06 갱신: `_PEGGING`(13행)/`_PROBLEM`(9행) 은 서브그리드 제외로 삭제 |

## 10. 종합 판정(convert-core §4.3, iter-2)

**ERROR** — self-check(코드 품질)와 메뉴/컬럼/콤보 DB 게이트는 PASS 이나:
1. 서브시트(calendar/pegging/problem) SEARCH 버튼 등록이 "적용 대기(권한 차단)" 로 남아 있어 그 3개 GET 이 런타임에서 동작하지 않는다(§6 발견 C, §9).
2. Fix/Unfix/Save 저장(H1)은 PROC_M 미등록(SAVE 2종) + BE TVP 미지원으로 런타임 미검증(ERROR) — convert-sp + 별도 BE 개선 선행 필요.
3. H2(New 팝업)·M4/M7/M9·L2~L5 은 미해소(대부분 사용자 결정·별도 SP/BE 작업 대기, 코드 결함 아님).

화면 "완료"는 위 3항목 해소 후 재판정한다. iter-2 는 react-gap-audit v1 지적 22건 중 10건(H3/H4/H6/M1/M2/M3/M6/M8/L1/L7)을 해소하고, 3건의 신규 결함(A/B/C)을 독립 발견·A/B는 즉시 수정, C는 SQL 작성까지 완료(DB 적용은 권한 차단으로 대기)했다.

## 11. iter-3 재검증·수정 내역 (react-gap-audit v2 verdict fail 대응)

입력: `.atlas/gscm-design/SCP0009/design/04_impl-gap-audit.md`(iteration:2, verdict:fail) issues — NEW1(고)/NEW2(중)/NEW3(중) 신규 3건 + H1/H2/M4/M5/M7/M9/L2~L6 기존 12건 미해소.

### 11.1 NEW1 해소 — Division 조건부 컬럼 visible 무력화(고위험)

- **원인**: `utils/shipment-plan-fg.buildColumns.ts` `buildColumns()`가 `if (adminCols && adminCols.length > 0) return adminCols;`로 admin 메타(80행, `VISIBLE_FLAG='Y'` division 무관 고정)를 그대로 반환해, `ShipmentPlanFgGrid.tsx`의 `infoColumns`(division 기준 R-A/R-B 런타임 계산)를 완전히 버렸다.
- **수정**: `buildColumns.ts`에 `DIVISION_CONDITIONAL_KEYS`(`DIVISION_40_ONLY_COLUMNS ∪ DIVISION_EE_ONLY_COLUMNS`, `shipment-plan-fg.columns.ts` 기존 export 재사용) 기반 `withDivisionOverlay()`를 추가 — admin 메타를 authoritative 로 유지하되(다른 78개 컬럼은 무변경), 이 13개 division 조건부 컬럼만 `infoColumns`의 런타임 `visible`로 덮어쓴다(`adminCols.map(withDivisionOverlay)`). fallback 경로(admin 메타 없음)에도 동일 오버레이 적용.
- **검증**: `division='40'`이면 `DIVISION_40_ONLY_COLUMNS`(EXTRA_SPEC 등 10건) visible=true·`DIVISION_EE_ONLY_COLUMNS`(ELECTRODE_TYPE 등 3건) visible=false로, `division` EE* 이면 반대로 계산되는 것을 코드 read로 확인(런타임 브라우저 실측은 미확인 축).

### 11.2 NEW2 해소 — ToSite 2차 재조회(Team 변경 시) 미배선(중위험)

- **원인**: `COMBO.SITE_BY_END_CUSTOMER`/`SITE_BY_END_CUSTOMER_40` 상수만 정의되고 화면 어디서도 참조되지 않았다(design 02 §2.6 clbTeam_SelectedIndexChanged 의 ToSite 2차 갱신 미이식).
- **수정**: `ShipmentPlanFgForm.tsx`에 `siteByEndCustomerComboId = is81Series ? COMBO.SITE_BY_END_CUSTOMER : COMBO.SITE_BY_END_CUSTOMER_40` 분기와 `toSitesByTeam` 콤보쿼리(`divisionId`/`endCustomer`/`deptId`/`projectCode` — DB 실측 SQL_DTL_CTN 토큰과 1:1 일치 확인, 아래 참조)를 추가하고, `sc.teamIds.length > 0`일 때 §2.4 초기 `toSiteOptions`(division 3분기) 대신 이 2차 결과로 대체한다. (2026-10-07 이후 `is81Series` 와 `endCustomer: 'ALL'` 은 §17 로 대체됨)
- **DB 토큰 재확인**(`ora.py query SELECT SQL_ID, SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('SiteByEndCustomer','SiteByEndCustomer40')`, iter-3 재실측): `SiteByEndCustomer`=`@divisionId,@endCustomer`(+`@sesUserId`), `SiteByEndCustomer40`=`@divisionId,@deptId,@projectCode` — design 02 §2.6 기재와 일치. 빈 값은 CLAUDE.local.md §5 관례대로 `'ALL'` 센티널로 전달(SQL 이 `@x='ALL'` 분기를 명시적으로 처리).
- **미해소 잔여**: design 02 §2.6 라인 135의 "sEndCustomer 타이밍(AS-IS가 EndCustomer 재적재 직후 값을 곧바로 읽어 실질적으로 '이전 선택값'을 씀)"은 AS-IS 소스만으로 의도된 동작인지 우발적 버그인지 판정 불가한 사용자 확인 필요 항목(design 자체가 확인필요로 남김) — TO-BE 는 React 상태 기반으로 "현재" `sc.endCustomerIds`를 파라미터로 쓴다(팀 변경 시 `endCustomerIds`가 함께 `[]`로 리셋되므로 초기 재조회 시점엔 `'ALL'` 센티널로 넘어가 사실상 AS-IS 의 "리셋 직후" 상태와 유사하게 동작). 브라우저 실측(화면 확인 축)은 미완. (2026-10-07 갱신: `sc.endCustomerIds` 는 제거됐고 타이밍 문제는 §17 에서 해소로 정리)

### 11.3 NEW3 — O_RC2(Plan 상태 표시) 미착수(중위험, design 갭 동반)

design/01_layout.md·00_checklist.md 어디에도 O_RC2(IS_EDITABLE/PLAN_STATUS/CONFIRM_FLAG 등)의 UI 요구사항이 없다(grep 재확인, 변경 없음) — gap-audit v2 expect 그대로 "design 서브태스크 선행"이 먼저다. anti-simplification §1(추측 UI 금지)에 따라 이번 회차도 미착수 유지, 04_react-gap.md/결과 보고에 "설계 갭 — FE 단독 해소 불가"로 명시한다.

### 11.4 기존 미해소 12건(H1/H2/M4/M7/M9/L2~L5) — 변경 없음

전건 재확인 결과 iter-2 대비 상태 변화 없음(코드/DB 재점검, 아래 §9 DB 게이트 표 그대로 최신). 사유는 §6 "미해소" 표와 동일 — convert-sp(SP 배포·PROC_M)·BE(TVP 바인딩)·design 서브태스크(New 팝업, O_RC2)·사용자 결정(Edit 토글/Fix-잠금 파리티/LBL 채번/레이아웃 구조) 선행이 필요하며 FE 단독으로 해소할 수 없는 항목들이다.

### 11.5 iter-3 self-check

- grep 게이트(상대경로 import/console/inline style/any/direct cast): 수정 2개 파일(`buildColumns.ts`, `ShipmentPlanFgForm.tsx`) 대상 0-hit.
- type-check: `pnpm --dir nscm-fe/features/supply type-check` — PASS(내 폴더 0 error, 패키지 잔존 에러 1건 `integration-psi` 는 무관, 변경 없음).
- lint:fix: `pnpm --dir nscm-fe/features/supply lint:fix` — PASS(내 폴더 0 error/0 warning). 이번에도 `integration-psi` 3개 파일(import 순서 재정렬 2건 + 미사용 상수 제거 1건)을 부수 수정 — 수동 원복 완료, `git status --porcelain`으로 diff 0 확인(Hard Boundary 유지, iter-2 관찰과 동일 재발).
- 경계 점검: `git status --porcelain -- nscm-fe/` — `shipment-plan-fg/` 외 diff 0.
- DB 게이트(2.7/2.75/2.76/2.8): 이번 회차 신규 DB 쓰기 없음(코드 수정만) — §9 표 상태 유지, 서브시트 SEARCH 버튼은 재조회로 이미 PASS 확인(v2 gap-audit 정정 사항 재확인).

### 11.6 종합 판정(convert-core §4.3, iter-3)

**ERROR (변경 없음, 부분 개선)** — NEW1(고위험 불일치) 해소 + NEW2(중위험 미구현) 해소로 react-gap-audit v2 지적 3건 중 2건을 해소했으나, H1(저장 SP 실행체인)·H2(New 팝업)·NEW3(O_RC2 설계갭)·M4/M5/M7/M9·L2~L6 는 전부 FE 단독 해소 불가 항목(convert-sp/BE/design 서브태스크/사용자 결정 선행)으로 여전히 미해소다. 화면 "완료" 판정은 이들 해소 후 재검토한다.

## 12. iter-4 — 확인필요 3건(M4/NEW3) 정밀 재조사 (코드 변경 0건, 순수 분석)

입력: `.atlas/gscm-design/SCP0009/design/04_impl-gap-audit.md`(iteration:3, verdict:fail, confirm_needed:6) — plan.md 남은 todo 없음(1~8 전항목 iter-1~3에 걸쳐 처리 완료) + `convert-flow/iter-3/gap-audit.md` issues. 이번 회차는 FE 단독 해소 불가로 3회 연속 보류돼 온 확인필요 항목 중 코드/DB 정밀 재조사로 해소 가능한 3건(M4/M5/NEW3)을 대상으로 삼았다(skill.md 절차 0 — 피드백 issues 를 이번 회차 작업범위로 확정). **이번 회차는 코드 수정 0건**(투자 대비 리스크 판단 — 아래 §12.3 참조) — gap-audit 의 사실관계 자체를 새 실측으로 교정하는 순수 재조사 회차다.

### 12.1 M4 해소 — FrozenColumnCount 확인필요 → PASS(경계 무모호 확정)

**근거**: `design/03_grid-columns.md §1.A` 44행 전체를 재대조한 결과, SORT_ORDER_NO=80 동률 13행(#32~44: measure_order_no/biz_type/to_site/from_site/SHIP_FROZEN/bod_id/KEY_IDX/BOD_FROM_YYYYMMDD/BOD_TO_YYYYMMDD/plan_start_yyyymmdd/plan_type/seq/to_yyyymmdd)은 **전건 `VISIBLE_FLAG=N`(hidden)** 이다(표에 이미 기재돼 있었으나 iter-1~3 은 "동률 13건의 순서를 확정 못함"에만 집중해 이 사실의 함의를 놓쳤다). Freeze 경계(`.cs` L845 `Freeze(0, MEASURE_LABEL_idx+1)`)는 `measure_label`(#31, `SORT=999`, `FIXED_FLAG='Y'` 유일 1건) 바로 다음이며, 그 뒤에 오는 80-동률 13건은 전부 비가시 컬럼이라 **화면에 렌더되지 않는다 — 이들 상호간 순서는 freeze 경계(가시 영역)에 어떤 영향도 주지 않는다.** 가시 컬럼(#1~30) 구간에는 SORT 동률이 없다(1~29 + 85 + 90, 전건 유일값). 현재 구현(`ShipmentPlanFgGrid.tsx` — DataGrid 가 admin `FIXED_FLAG` 메타를 그대로 경유, 화면 코드가 `frozenColumns`를 직접 넘기지 않음, iter-3 grep 재확인 유지)은 이미 정확하다 — **코드 변경 불요**.

**재분류**: `confirm_needed` → **PASS**(freeze 경계 확정, 브라우저 육안 확인만 남음 — 결과 자체는 모호함 없이 확정됐으므로 "사용자 확인 축"이지 "확인 필요(ERROR)" 축이 아니다).


### 12.3 NEW3 종결 — O_RC2 는 TO-BE 에서 불필요

NEW3(O_RC2 Plan 상태 표시 설계갭)은 독립 이슈가 아니었다. AS-IS 에서 O_RC2(`dsBinding.Tables[1]`)를 읽는 곳은 `GetIsEditable()`(L3527-3658) 뿐이고, 그 결과는 AS-IS 에만 있는 잠금 해제 토글 버튼의 선행조건으로만 쓰인다. O_RC2 필드를 화면에 표시하는 코드는 없다(`IS_EDITABLE`/`CONFIRM_FLAG`/`CONFIRM_YN`/`PLAN_TYPE_SEQ` grep 0-hit). TO-BE 에는 그 버튼을 두지 않으므로 O_RC2 cascade 는 구현 대상이 아니다 — **폐기**.

## 13. iter-5 — convert-flow 재개 루프 재검증 (코드 변경 0건)

입력: `.atlas/gscm-design/SCP0009/convert-flow/{goal,plan}.md`(이 세션에 신규 작성 — 과거 convert-flow 증거 소실로 이 문서가 유일한 이전 회차 기록이었다, goal.md ①). plan.md todo 0~12번 중 DB/코드 재검증 가능 항목(0/2/3/5/6/8/9/10/11/12)을 수행하고, 사용자 응답이 필요한 1)/4)/7)은 재게시만 했다(비대화형 세션, 응답 미수신).

### 13.1 DB 게이트 재실측(변화 없음, 일부 수치 갱신)

- 메뉴(2.7): `SCM_ADM_MNU_M` 1건 PASS(변화 없음).
- 버튼(2.8): `SCM_ADM_MNU_BTN_MPG_M` **12건**(main 9 + calendar/pegging/problem SEARCH 3) — iter-2 당시 "적용 대기(권한 차단)"였던 서브시트 3건이 이번 재조회에서 **등록 확인(PASS)**. 그룹×버튼 권한(`SCM_ADM_USER_GR_MNU_BTN_MPG_M`) **24건**(2그룹×12, iter-2 당시 18건에서 증가) — 중간에 다른 회차/운영자가 적용한 것으로 추정(이 세션은 DB 쓰기를 하지 않았다). `05_register.sql` 원본은 `design/` 폴더에서 소실 상태(확인 필요로 `04_react-gap.md`에 기록).
- 컬럼/Measure(2.75): `SCM_MST_SHEET_COLUMNS` 80건, `SCM_MST_SHEET_MEASURE` 10건 — 변화 없음, PASS.
- PKG_SCP0009: PACKAGE=VALID/PACKAGE BODY=**INVALID** — 변화 없음.
- PROC_M: GET 4종 PASS(변화 없음). SAVE 2종 — **PROC_M 행수가 0→2행으로 바뀌었으나(COL_NM='scp0009' VARCHAR IN, 'O_RESULT_CURSOR' PROC_RESULT OUT), 실 배포 시그니처(`ALL_ARGUMENTS`: P_SCP0009 TABLE IN/O_RC1 REF CURSOR OUT)와 여전히 불일치** — "0행이라 즉시 실패"에서 "행은 있으나 타입이 달라 바인딩 실패" 로 증상만 바뀌었을 뿐 근본 문제(convert-sp 재등록 필요)는 동일하다.

### 13.2 코드 재검증(레이아웃/조회조건/그리드) — 전부 변화 없음

`01_layout.md`/`02_search-combo.md`/`03_grid-columns.md` 구현검증 기준 대비 §1~§3 표, §11(NEW1/NEW2 해소), §12(M4 PASS, NEW3 재분류) 전부 코드 재확인 — 이번 회차 코드 수정 0건(이미 iter-4 까지 FE 가용 범위 내 항목은 전부 반영됨, 남은 항목은 전부 convert-sp/BE/design서브태스크/사용자결정 의존).

### 13.3 self-check(iter-5)

- grep 게이트: 0-hit(변화 없음).
- type-check: `pnpm --dir nscm-fe/features/supply type-check` — PASS(0 error).
- lint: `npx eslint src/pages/shipment-plan-fg`(폴더 스코프, --fix 미실행) — PASS(0 error/0 warning). 패키지 전체 `lint:fix` 는 실행하지 않았다 — 이번 세션 시작 시점에 `features/supply/` 하위 다른 화면(capa-line-master/constraint-mgmt/opt-capa/plan-control/warehouse-capacity 등)에 **이 activity 와 무관한 선행 미커밋 변경**이 이미 존재해(세션 시작 전부터 `git status`에 잡힘), 패키지 전체 `lint:fix` 를 돌리면 그 무관 변경들까지 추가로 건드릴 위험이 있었다(Hard Boundary 보호 — 과거 iter-2/3 의 `integration-psi` 부수수정 관찰과 같은 리스크의 재발 방지).
- 경계 점검: `git status --porcelain -- nscm-fe/features/supply/src/pages/shipment-plan-fg/` — 이번 회차 코드 diff 0건.

### 13.4 종합 판정(convert-core §4.3, iter-5)

**ERROR(변화 없음)** — self-check·메뉴/컬럼/콤보/권한 DB 게이트는 전부 PASS 유지. H1(SP 재컴파일+PROC_M 재등록+BE TVP 바인딩)·H2(New 팝업 design 서브태스크)·M7/M9(convert-sp)·L3/L5/L6(사용자 결정, 비대화형 세션이라 이번 회차도 미수신) 는 전부 FE 단독 해소 불가로 그대로 남았다. 다음 회차 우선순위는 변화 없음: (1) convert-sp 담당자가 PKG_SCP0009 재컴파일 + SAVE 2종 PROC_M 재등록, (2) BE 담당자가 TVP 바인딩 추가, (3) H2 전용 design 서브태스크.

### 12.4 iter-4 self-check

코드 변경 0건 — grep/type-check/lint 재실행 불요(변경 파일 없음, `git status --porcelain -- nscm-fe/features/supply/src/pages/shipment-plan-fg/` 로 diff 0 확인). DB 게이트(2.7/2.75/2.76/2.8): 신규 쓰기 없음, `SCM_ADM_MNU_M WHERE MNU_ID='SCP0009'` 재조회로 메뉴 등록 유지만 재확인(PASS, 변경 없음) — 나머지는 iter-3 §9 표 그대로 유지.

### 12.5 종합 판정(convert-core §4.3, iter-4)

**ERROR(부분 개선, 코드 무변경)** — confirm_needed 6건 중 3건(M4/NEW3) 을 정밀 재조사로 PASS/폐기-흡수 처리해 남은 confirm_needed 는 3건(L4/L5 및 §6#2 타이밍 이슈급 저위험)으로 줄었으나, verdict 를 바꾸는 것은 H1(저장 SP 실행체인, convert-sp+BE 선행)·H2(New 팝업, design 서브태스크 선행)·M7/M9(convert-sp)·L3/L6(사용자 결정) 미해소로 여전히 fail 범주다. 다음 회차 최우선순위는 변경 없음: (1) convert-sp(H1/M7/M9/L7-period), (2) H2 전용 design 서브태스크.

## 14. gap-resolve iter-2 — G11 분리(W26/W52 해소)·G22 신규해소·작업트리 손상 복구

입력: convert-gap-resolve activity(loop 밖 수동 실행). 착수 시점 발견한 작업트리 손상(이전 인터럽트된
실행이 `.atlas/gscm-design/SCP0009/design/00~04`·`gap-resolve/iter-1/*`·`05_register*.sql`을 git HEAD
`3c1cb6b18`보다 오래된 초안으로 되돌려 쓰고 iter-1 산출물 2파일을 삭제한 상태)를 `git checkout HEAD --
<경로>`로 복구했다 — 상세·판단근거는 `.atlas/gscm-design/SCP0009/gap-resolve/iter-2/evidence.md §0`.

### 14.1 G11 해소(부분) — W26/W52 기간 프리셋 SP 배선

> 2026-10-06 갱신: 이 절의 `applyDayRange` 서버 SP 호출은 제거됐다. 현재는 공용 `PeriodRangePicker` 빠른선택과
> Plan Date 변경 시 기본 W52 클라이언트 계산을 쓴다(§2 dCalendar 행). 아래는 당시(gap-resolve iter-2) 기록이다.
> `SCP0009/main/W26·W52` 버튼 라우팅 DB 행(`SCM0001_SCP_DAY_PERIOD_GET`)은 남아 있으나 호출처가 없다.

AS-IS `GetDayRange(periodType)`(`.cs:4050-4066`, `p_offset_day=periodType*7-1`)와 동일 공식으로
`ShipmentPlanFgForm.tsx`에 `applyDayRange('W26'|'W52', 181|363)` 구현 — 호출 대상은 공용 SP
`PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD`(다른 화면 SCP0025/SSP0200이 `GET_SCP_DAY_PERIOD` 버튼으로
이미 사용 중, API_M/PROC_M 등록 완료 상태, 2026-09-17 'AJS' 등록 — 이 화면이 신규 등록한 것 아님).
이 화면에 누락됐던 것은 버튼 라우팅(`SCM_ADM_MNU_BTN_MPG_M`/`SCM_ADM_USER_GR_MNU_BTN_MPG_M`) 1건뿐이라
`05_register.sql`에 등록 SQL을 추가해 적용·재조회로 확인했다(main 시트 버튼 11→13건, W26/W52 포함).
WLast(`SCM0001_GET_SCP_DAILY_PLAN_PERIOD`류)는 `PKG_COM0000` 재조회로도 미배포 확정 — G11b로 분리해
R3(convert-sp 후속) 유지, 코드는 기존 alert-only placeholder 그대로 둔다.

**이전 회차(iter-1 gap-resolve) 오판 정정**: 이전 회차가 `ALL_OBJECTS WHERE OBJECT_NAME='SCM0001_GET_SCP_DAY_PERIOD'`(0행)만 조회해 "미배포"로 결론 내렸으나, 이 프로시저는 `PKG_COM0000` 패키지 **내부**
프로시저(`P_SCM0001_GET_SCP_DAY_PERIOD`)라 top-level 객체 조회로는 찾을 수 없었다(함정 — 패키지
프로시저는 `ALL_PROCEDURES WHERE OBJECT_NAME='<패키지명>'`으로 조회해야 함).

### 14.2 G22 신규 해소 — Division 콤보 정렬(81→1, 40→2, 그 외→3)

AS-IS `.cs:473-488`("2021.10.22 : DIV 순서 변경")를 그동안 iter-1~5 어느 회차도 재현하지 않고
있었다(`toOptions(divisions)` 그대로 사용, admin 메타 등록 순서에 의존). 이번 회차에 `divisionSortRank`
함수로 재현 — 동순위(3순위) 내부 상대순서만 AS-IS(`InsertAt(0)` 역순)와 TO-BE(안정정렬) 사이에 미세한
차이가 있으나 핵심 요구사항(81/40 선두 승격)은 동일하게 재현된다(저위험, 코드 주석에 명시).

### 14.3 독립 검증(react-gap-audit, 이번 회차 수정 비공개) 결과

G11/G22 대상 "구현" 확정(blind 재검증 PASS). 추가로 신규 확인필요 2건을 발견: `EndCustomerByDivision40`
division 하드코딩 비대칭(G23, `02_search-combo.md §7#2`가 이미 "확인필요"로 남긴 항목 재확인), 그리드
월/주 드릴다운 expand/collapse(`SetDblClickColumnShowHide`) 재현 여부(G24, 신규) — 둘 다 이번 회차는
인벤토리 등재만 하고 해소는 다음 회차로 이월한다. 독립 검증이 Pegging/PlanProblem SP 미반환 컬럼을
다시 확인필요로 플래그했으나(§12.2 iter-4가 이미 PASS 확정한 항목), `all_source` 재조회로 교차검증한
결과 상태 변화 없음(PASS 유지) — 도구가 `§12.2`의 후속 해소 기록을 보지 못해 생긴 재플래그로 판정.

### 14.3a G24 해소 — 월/주 SUM 헤더 더블클릭 드릴다운(2026-10-07)

AS-IS 본문은 `GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs:10838-10885`(`SetDblClickColumnShowHide`)다.
`SUM` 헤더 셀 더블클릭만 동작한다. M_ SUM 은 그 달 구간의 W_ 표시를 뒤집고 보이는 D_ 를 숨기며, W_ SUM 은 그 주 구간의 D_ 표시를 뒤집는다.
화면 쪽 `chkAll` 가드(`SCP0009_Shipment_Plan_FG.cs:3771`)는 TO-BE 가 `chkAll` 을 항상 true 로 고정(§0 chkAll 행)해 구현하지 않았다.

| 항목 | 위치 |
| --- | --- |
| 토글 계산(순수 함수) | `utils/shipment-plan-fg.drilldown.ts` `computeDrillToggles` |
| 이벤트·오버라이드 | `components/ShipmentPlanFgGrid.tsx` `drillVisRef`, `hostElement` `dblclick`, `updatedLayout` 재적용 |
| 테스트 | `utils/shipment-plan-fg.drilldown.test.ts` |

오버라이드는 Bucket 변경과 새 조회 시 비운다. 확인 필요: Wijmo 중첩 헤더에서 `getCellData` 가 클릭한 행의 `SUM` 을 돌려주는지는 브라우저에서 확인하지 못했다.

### 14.4 self-check(iter-6/gap-resolve iter-2)

- grep 게이트: 변경 파일(`ShipmentPlanFgForm.tsx`) 대상 0-hit.
- type-check: `pnpm --dir nscm-fe/features/supply type-check` — PASS(0 error).
- lint: `npx eslint src/pages/shipment-plan-fg`(폴더 스코프) — PASS(0 error/0 warning).
- 경계 점검: `git status --porcelain -- nscm-fe/features/supply/src/pages/shipment-plan-fg/` — 위 변경 파일 + 이 문서 외 diff 없음.
- GATE-03(`process_bypass_gate.py --code SCP0009`): PASS(이탈 처리 의심 0건).
- R1 게이트(`r1_carryover_gate.py --code SCP0009 --iter 2`): PASS(G11/G22 전건 반영 확인).
- 메타-memory 상충 게이트(`meta_assumption_gate.py`): PASS(3개 파일, 상충 후보 없음).

### 14.5 종합 판정(convert-core §4.3, gap-resolve iter-2)

**미완(ERROR, 부분 해소)** — G11(W26/W52)·G22 해소로 react-gap-audit 누적 발견 중 2건을 추가 해소했으나,
H1(저장 SP 실행체인)·H2(New 팝업)·M7/M9(convert-sp)·L3/L5(사용자 결정)·WLast(G11b)·G23/G24(신규
확인필요)가 남아 여전히 ERROR 범주다. 다음 회차 우선순위는 변화 없음(convert-sp →
H2 design 서브태스크) + 신규로 G23(SQL_DTL_CTN 재조회)·G24(드릴다운 코드 대조) 추가.

## 15. 2026-10-06 구현 내역 — 가드·메시지 정정, Fix/Unfix 선택 수집, 서버 저장가능 판정

결론: Fix/Unfix/New/Save 의 클릭 가드와 Fix/Unfix 대상 수집을 AS-IS 에 맞췄다. 저장 SP 실행은 H1 때문에 여전히 확인할 수 없다.
각 항목의 AS-IS/TO-BE 대응은 §1·§2·§3 표 행에 있고, 여기에는 변경 목록과 점검 결과만 모은다.

### 15.1 변경 목록

| 구분 | 내용 | 위치 |
|---|---|---|
| 메시지 ID 정정 | `LOCKED_MODE`(MSG00010→MSG01046), `CONFIRM_UNFIX`(MSG00016→MSG01438), `SAVE_SUCCESS`(MSG00004→MSG00002), 신규 `NO_PERMISSION`/`SELECT_CELL`/`UNSAVED_DATA`/`NO_DELETE_DATA`/`SAVE_NOT_ALLOWED` | `shipment-plan-fg.constants.ts` `MSG` |
| New 활성화·Seq 기준 | `canCreateNew = !isLockedPlan && !(EE && A)`, `latestPlanSeq` 를 Seq 옵션 숫자 최댓값으로 | `ShipmentPlanFg.tsx`, `components/ShipmentPlanFgForm.tsx` |
| 조회기간 | 서버 SP 호출 제거, 기본 W52 클라이언트 계산 | `ShipmentPlanFg.tsx` 기본 조회기간 `useEffect` |
| Fix 사유 팝업 | OK 확정 시에만 저장, 100자·`^` 제한 | `components/modals/FixReasonModal.tsx` |
| Fix/Unfix 전송 | Fix='I' / Unfix='D', Unfix 사유 빈 값 | `ShipmentPlanFg.tsx` `saveFixDataset`, `utils/shipment-plan-fg.save.ts` `buildFixRows` |
| Fix 셀 판정·수집 | 행×일자 단위 판정, 선택 범위 수집, 미저장 셀 검사 | `utils/shipment-plan-fg.fix.ts`(+`.test.ts`), `components/ShipmentPlanFgGrid.tsx` `formatItemHandler` |
| 서버 저장가능 판정 | `checkServerSaveYn` 을 Fix/Unfix/New/Save 4곳에 삽입 | `ShipmentPlanFg.tsx`, `shipment-plan-fg.constants.ts` `SAVE_YN_SHEET` |

### 15.2 DB 변경 (2026-10-06, `ora.py exec`)

- `SCM_ADM_MNU_BTN_MPG_M` 1행: `SCP0009 / saveYn / SEARCH → P_SCP0013_SAVE_YN_GET`.
- `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 2행: 같은 키의 `ADMIN`, `SCP Planner`.
- 재조회로 반영 확인(SCP0009 버튼 15건, 그룹 권한 30건). SQL 은 `.atlas/gscm-design/SCP0009/design/05_register.sql` 끝, 롤백은 `05_register_rollback.sql` 끝.
- SP 쪽: `PKG_SCP0009` 메인 GET 의 O_RC3 에서 `AND P_BUCKET IN ('WEEKLY','MONTHLY')` 가 주석 처리됨(사용자 수정, BODY last_ddl 2026-10-06 15:13) — Daily 에서도 Fix 정보가 내려온다.

### 15.3 점검 결과

- type-check: `pnpm --dir nscm-fe/features/supply type-check` — PASS(0 error).
- 단위 테스트: `vitest run src/pages/shipment-plan-fg` — 10건 PASS(`shipment-plan-fg.fix.test.ts`).
- lint: 변경·신설한 파일(`ShipmentPlanFg.tsx`, `ShipmentPlanFgGrid.tsx`, `shipment-plan-fg.fix.ts`, `shipment-plan-fg.fix.test.ts`, `shipment-plan-fg.save.ts`, `shipment-plan-fg.constants.ts`) 0 error/0 warning. 폴더 전체(`npx eslint src/pages/shipment-plan-fg`)는 1 error — `utils/shipment-plan-fg.headerMerge.ts:25` `no-unsafe-argument`(git untracked 파일, 이 작업 밖).
- 패키지 전체 `lint:fix` 는 실행하지 않았다(§13.3 과 같은 사유).
- 브라우저 확인: **미확인** — 셀 단위 색칠, 선택/미저장/대상 없음 alert 흐름, 저장가능 판정 호출 통과 여부.

### 15.4 남은 항목

| 항목 | 상태 | 선행 조건 |
|---|---|---|
| G2(구 H1) 저장 SP 실행 | 코드·DB 배선 완료, 브라우저 미검증 | 브라우저에서 Save/Fix/Unfix 왕복 확인(§18) |
| H2 New 팝업 | 구현(실동작 미확인) | `.atlas/gscm-design/SCM0002/design/00~03`, `features/supply/src/components/newPlanModal/NewPlanModal.tsx` |
| L3 Fix 하이라이트-잠금 불일치 재현 여부 | 사용자 결정 대기 | 결정 후 구현 |
| Weekly 응답의 `D_` 값 유무 | 확인 필요 | 없으면 Fix 시 `W_` 펼침 수량이 '0' |
| `SCP0013_GET_PLAN_SAVE_YN` 실제 Y/N 반환, `KEY_IDX` 응답 포함 여부 | 확인 필요 | 브라우저 실행 |
| `shipment-plan-semi` 의 같은 Fix/Unfix 결함(`activeFlag: 'M'` 고정 등) | 이 화면 소관 아님 | 해당 화면 담당 |

## 16. 2026-10-06 하단 서브그리드(Pegging Info, Plan Problem) 제외

결론: TO-BE 는 spdMain 하나만 쓴다(사용자 결정). 임시로 구현돼 있던 더블클릭 상세 모달과 관련 코드, DB 등록분을 모두 제거했다.
모달은 설계 문서가 요구한 것이 아니었다(`00_checklist.md` #10 은 미결이었고 `01_layout.md` 는 분할 배치를 요구했다). 2026-09-28 커밋에서 임시로 들어온 구현이었다.

### 16.1 코드 제거 (`shipment-plan-fg/`)

| 구분 | 제거 내용 |
|---|---|
| 파일 삭제 | `components/PeggingInfoModal.tsx`, `components/PlanProblemModal.tsx` |
| `ShipmentPlanFg.tsx` | 모달 import·열림 상태·`onCellDoubleClick` 블록·모달 JSX, 그리드로 넘기던 `chkAll` prop |
| `components/ShipmentPlanFgGrid.tsx` | `dblclickHandler`(5-가드)와 리스너, `chkAll`/`onCellDoubleClick` prop, `CellType`/`DRILLDOWN_MEASURE` import |
| `useShipmentPlanFgStore.ts` | `PEGGING`/`PROBLEM` 필터·정적 컬럼 타입과 초기값, `setPeggingFilter`/`setProblemFilter`/`clearDetailFilters`, 미사용 `str` 헬퍼, `fetchStaticColumns` 시트 목록(`[MAIN]` 만) |
| `shipment-plan-fg.constants.ts` | `SHEETS.PEGGING/PROBLEM`, `RESPONSE_SET` 두 키, `ADMIN_SHEET_NAME` 두 항목, `DRILLDOWN_MEASURE` |
| `shipment-plan-fg.columns.ts`, `.types.ts` | `PEGGING_COLUMNS`, `PROBLEM_COLUMNS`, `PeggingRow`, `ProblemRow` |

유지: 조회조건의 ALL 체크(`chkAll`, `P_CHK_ALL` 파라미터와 Bucket 로직), 메인 그리드의 Fix 셀 판정·수집.

### 16.2 DB 삭제 (2026-10-06, `ora.py exec`)

| 테이블 | 조건 | 건수 |
|---|---|---|
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | `SCP0009`, `SHT_NM IN ('pegging','problem')` | 4 |
| `SCM_ADM_MNU_BTN_MPG_M` | 같은 조건 | 2 |
| `SCM_ADM_API_M` | `P_SCP0009_PEGGING_GET`, `P_SCP0009_PROBLEM_GET` | 2 |
| `SCM_ADM_PROC_M` | `PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING`/`_PROBLEM` | 22 |
| `SCM_MST_SHEET_COLUMNS` | `SCP0009`, 시트 `Pegging Info`/`Plan Problem` | 36 |

- 삭제 전후 건수는 4/2/2/22/36 에서 0/0/0/0/0 으로 재조회로 확인했다. 남은 것: 메인·calendar·saveYn 버튼 라우팅 13건, `Shipment Request` 컬럼 44건.
- 유지: `PKG_SCP0009` 의 `P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING/_PROBLEM` 프로시저 본문(오늘 다른 분이 수정한 패키지라 건드리지 않음), `SCM_MST_SHEET_MEASURE`, `SCM_MST_TITLESET_USER`.
- SQL: `.atlas/gscm-design/SCP0009/design/05_register.sql` 끝(삭제 5문장), 복원은 `05_register_rollback.sql` 끝(INSERT 66건).
- 복원 검증: 같은 트랜잭션에서 삭제한 뒤 생성한 INSERT 로 복원해 전 컬럼이 원본과 일치함을 확인하고 롤백했다.
- 컬럼 대소문자 정정 SQL(`COLUMN_NAME` 대문자화)은 `Shipment Request` 시트 30건만 대상이며 단독 파일로 분리했다: `.atlas/gscm-design/SCP0009/design/06_column_name_upper.sql`(적용), `06_column_name_upper_rollback.sql`(롤백). 트랜잭션 안에서 적용-롤백 시험으로 동작을 확인했고(30건 변경, 재실행 0건, 롤백 후 원본 일치) 2026-10-06 DB 에 적용했고, 화면 코드의 소문자 키 읽기는 2026-10-07 대문자로 고쳤다(§18).

### 16.3 확인하지 못한 것
- `SCM_MST_SHEET_COLUMNS` 의 두 시트 36행은 2018~2023 AS-IS 이관분이다. AS-IS 앱이 같은 DB 의 이 메타를 읽는다면 AS-IS 하단 그리드에 영향이 있다. AS-IS 가 이 DB 를 쓰는지는 확인하지 못했다. 필요하면 롤백 SQL 의 INSERT 로 복원한다.
- 브라우저 확인: 더블클릭 시 팝업이 뜨지 않고 메인 그리드(조회, 편집, Fix)가 정상인지는 미확인.
- 점검: type-check 0 error, 변경 파일 eslint 0 error/0 warning, 단위 테스트 10건 통과.


## 17. 2026-10-07 End Customer 조회조건 제거 (G23 종결)

### 17.1 결정 근거
- AS-IS `clbCustomer` 는 `layoutControlItem13.Visibility = Never` 로 화면에 보이지 않는다(`SCP0009_Shipment_Plan_FG.Designer.cs:1569-1577`). TO-BE 가 이를 조회조건으로 노출하던 것을 제거한다.
- 숨김 컨트롤은 `ALL_VIEW = true`(`Designer.cs:443`)이고 사용자가 선택할 수 없어 `ControlValues` 가 항상 `"ALL"` 이다(`GSCM/01.Framework/GSCM.Windows.Forms/Controls/UsrCheckedList2.cs` `ValueList` getter). `CString.GetCheckedListValue`(`Utility/CString.cs:526`)는 `"ALL"` 을 후보 `CODE` 전체의 쉼표 목록으로 펼친다.
- 따라서 `clbTeam_SelectedIndexChanged`(`SCP0009_Shipment_Plan_FG.cs:4734-4743`)의 To Site 재조회 입력은 81/82 에서 Team 후보 전체 목록이고, 그 외 division 에서는 문자열 `"ALL"` 이다.

### 17.2 TO-BE 구현 (`components/ShipmentPlanFgForm.tsx`)
| 구분 | 내용 |
| --- | --- |
| 분기 조건 | `isDeptCustomerDivision = divisionId === '81' || '82'` (AS-IS 와 동일). 이전 `includes('81')` 은 82 를 놓치고 81_UC/81_HD 등을 잘못 포함했다 |
| 81/82 | 화면에 없는 `EndCustomerByDivisionDept` 후보 쿼리(Team 선택 시에만)를 조회해 `CODE` 쉼표 목록을 `SiteByEndCustomer` 의 `endCustomer` 로 넘긴다. 후보 로드 후에만 To Site 를 조회한다 |
| 그 외 | `SiteByEndCustomer40` 에 `endCustomer: 'ALL'` (AS-IS 와 동일) |
| 제거 | End Customer 필드, `endCustomerIds` 상태, `LBL.END_CUSTOMER`, `COMBO.END_CUSTOMER_40`. `EndCustomerByDivision40` 은 TO-BE 에서 호출하지 않는다 |

### 17.3 DB 대조 (2026-10-07, 개발 DB 읽기 전용 조회)
| division | `endCustomer='ALL'` | 후보 목록 전달(AS-IS 호출을 재구성) | 판정 |
| --- | --- | --- | --- |
| 81 | Team 6개 모두 531건 | 16~54건 | 'ALL' 은 Team 이 반영되지 않아 후보 목록 전달이 필요 |
| 82 | Team 4개 모두 969건 | 1~205건 | 위와 같음 |
| 40 | 1~460건 | 후보 목록과 동일 | 'ALL' 로 충분(`SiteByEndCustomer40` 이 `@deptId` 로 좁힘) |

### 17.4 확인하지 못한 것
- 비교의 AS-IS 쪽은 AS-IS 호출을 코드로 재구성한 값이며, 실행 중인 AS-IS 에서 캡처한 값이 아니다. 샘플 사용자와 Team 몇 개 기준이다.
- 브라우저 확인(81, 82, 40, 81_UC 에서 End Customer 필드가 없고 Team 선택 시 To Site 가 좁혀지는지)은 미실행이다.
- 점검: type-check 0 error, 변경 폴더 eslint 0 error/0 warning.

## 18. 2026-10-07 G2 저장 경로(JSON 래퍼) 정리와 행 키 대문자화

§1·§3 의 현행 행은 이 절을 기준으로 한다. §6~§14 의 H1(TVP 미지원) 서술은 당시 기록이며 현재 동작이 아니다.

### 18.1 현재 저장 경로

| 구분 | 내용 | 근거 |
|---|---|---|
| FE 요청 | `POST /SCP0009/main/{SAVE\|FIX\|UNFIX}/call-proc`, 본문 `{ data: 26필드 행 배열 }` | `utils/shipment-plan-fg.save.ts` `buildSavePayload` |
| API 연결 | `P_SCP0009_SAVE` → `..._WEEKLY_JSON`, `P_SCP0009_FIX_SAVE`(FIX·UNFIX 공용) → `..._FIX_DATASET_JSON` | `SCM_ADM_API_M`, `SCM_ADM_MNU_BTN_MPG_M` 2026-10-07 `ora.py` 재조회 |
| BE 바인딩 | `data` 배열을 JSON 문자열로 바꿔 CLOB 으로 바인딩 | `nscm-be` `BaseService.makeProcedure`·`getRetrieveParam`, `MapUtils.cvtListToJson` |
| 래퍼 | JSON 26키를 TVP 로 변환해 기존 SP 호출, 결과는 `o_rc1`(`RESULT_CODE`/`ERR_MESSAGE`) | `design/07_sp_json_wrapper.sql`, `PKG_SCP0009` 본문 |

### 18.2 행 키 대문자화

조회 SP 응답 키가 전부 대문자(`06_column_name_upper.sql` 적용)인데 코드가 `measure`, `biz_type` 등 소문자 키로 행을 읽고 있었다. 저장 payload 의 정보 필드가 빈 문자열이 되고 편집 가능 판정(`row.MEASURE`)이 항상 실패할 수 있는 상태였다. 아래를 대문자 키로 맞췄다.

- `utils/shipment-plan-fg.save.ts`, `utils/shipment-plan-fg.fix.ts`, `utils/shipment-plan-fg.editLock.ts`, `components/ShipmentPlanFgGrid.tsx`
- `shipment-plan-fg.columns.ts` 의 컬럼 키, 사업부 조건부 컬럼 목록, `FREEZE_ANCHOR_COLUMN`
- 테스트 목업 행 키와 `buildSaveRows` 대문자 키 테스트 추가

### 18.3 확인하지 못한 것

- 브라우저에서 Save/Fix/Unfix 가 실제 저장되고 재조회에 반영되는지(G2 해소 조건).
- 셀을 비워 저장하면 `QTY` 가 NULL 로 저장된다(원 SP 는 `TO_NUMBER(... DEFAULT NULL ON CONVERSION ERROR)`). AS-IS 빈 셀 의미가 0 인지는 확인 필요.
- `W_`/`M_` 컬럼 저장 시 `yyyymmdd` 는 binding 앞 8자리로 잘린다. SP 가 요구하는 값인지는 확인 필요.
- Fix 사유 모달의 `^` 제거는 JSON 전환으로 필요 없어졌지만 AS-IS 와 같게 유지했다. 허용 여부는 사용자 확인 필요.

