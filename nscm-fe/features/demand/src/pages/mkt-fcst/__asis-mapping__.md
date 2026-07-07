# DMF0003 MktFcst — AS-IS ↔ To-Be 4축 매핑 매트릭스

> hook `asis-coverage-check.md` 4축 100% 매핑 검증 (anti-simplification — 표본·은폐 금지).
> 작성: 2026-06-28 (Phase 2f — validation 전수 + division 분기 + expressions cross-check).
>
> **AS-IS 정본**: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Plan.UIL/DMF0003_MktFcst.cs` (5,920줄)
> **분석서**: `Doc/_analysis/domain_DM/screens/DMF0003_MktFcst/` — validation.md(152) / expressions.md(130) / asis_behavior_supplement.md
>
> ⚠️ 라인 표기 2종:
> - `(.cs Lxxxx)` = 정본 `GSCM.DM.Plan.UIL/DMF0003_MktFcst.cs` (To-Be 구현 근거).
> - `(va#NN)` = validation.md 의 행 번호(원소스 6,945줄 기준 — 정본과 라인 오프셋 상이, 의미 동일).

---

## §0. 커버리지 요약 (4축)

| 축 | AS-IS 건수 | 적용(직접) | inline/대체 | 미구현(사유 명시) | 커버 |
|---|---:|---:|---:|---:|---:|
| Validation | **152** | 22 | 121 (division 분기 → division.ts + editLock matrix) | 9 (Excel/legacy/Find 내부) | **152/152** |
| Expressions | **130** | 125 | 0 | 5 (AS_FROM_SITE 조건부 잠금 = 콤보/BE 의존) | **130/130 분류** |
| Events | **26** | 24 | 2 (EditChange/ClipboardPasted = Wijmo cellEditEnding/pastedCell) | 0 | **26/26** |
| Popup | **8** | 8 | 0 | 0 | **8/8** |

> "적용(직접)" = To-Be 코드에 1:1 함수/가드 존재. "inline/대체" = 사업부분기(division.ts) 또는 편집 matrix(editLock.ts) 로 흡수된 항목. "미구현" = 사유 명시(아래 각 축).

---

## §1. Validation 축 — 152건 전수

### 1.1 카테고리 분포 (validation.md)

| 카테고리 | 건수 | To-Be 처리 위치 |
|---|---:|---|
| 사업부분기(40/81/82) | 113 | `utils/mkt-fcst.division.ts` (키/필수/중복키/SspSync/PlantSite 분기) |
| 기타(사전검증분기) | 25 | `validate.ts` 가드 + `editLock.ts` cutoff + Excel(미구현) |
| 필수값 | 4 | `validate.ts` validateSaveRows (REQUIRED division 분기) |
| 중복체크 | 3 | `validate.ts` (buildDuplicateKey) + `prContext.ts` (Model dup) |
| 날짜기간 | 2 | `validate.ts` validateFind (역전/3년) |
| 확인메시지 | 2 | `MktFcst.tsx` handleSave setAlert confirm |
| 모드분기 | 1 | `validate.ts` validateEditMode |
| 숫자값검증 | 1 | `recalc.ts` recalcMonthlyToDaily belowActual(MSG00225) |
| Grid입력 | 1 | `MktFcstGrid.tsx` cellEditEnding(EditChange) |

### 1.2 GMessageBox / 직접 메시지 — MSG/LBL ID 정밀 매핑 (2026-06-28 사내 SCM_ADM_MSG_M 정합 재채번)

> ⚠️ **GSCM-era MSG ID 재채번**: AS-IS 의 `GMessageBox("MSG####")` ID 는 NSCM 사내 메시지 마스터와
> **의미가 일치하지 않는다**(사내 실측: MSG00002='성공적으로 저장되었습니다.', MSG00004='저장하시겠습니까?' 만 일치).
> 따라서 AS-IS 한글 원문을 사내 텍스트 매칭(READ)한 결과 **MSG00004 1건만 재사용**, 나머지는 전부 사내 미존재 →
> 정식 채번(MSG00631+ / LBL00679+, gap 포함). 등록 handoff = `_artifacts/_apply_corporate/40_dmf0003_i18n_register.py`.

| va# | .cs Line | AS-IS 한글 원문 | 사내 정합 ID | FE 키 | 조치 | To-Be 위치 | 상태 |
|---:|---:|---|---|---|---|---|:--:|
| 10/12/14 | L802/814/826 | 복사할 데이터를 선택하세요. | **MSG00637** | SELECT_COPY_ROW | 신규 | `validate.ts` validateCopyTarget | ✅ |
| 15 | L847 | 조회 후 수정모드로 가능합니다. | **MSG00641** | EDIT_AFTER_SEARCH | 신규 | `validate.ts` validateEditMode | ✅ |
| 30 | L1213 | Division 을 선택하세요. | **MSG00635** | REQUIRE_DIVISION | 신규 | `validate.ts` validateFind | ✅ |
| 31 | L1224 | (기간 역전) | **MSG00636** | PERIOD_INVERTED | 신규 | `validate.ts` validateFind | ✅ |
| 32 | L1230 | (기간 3년 초과) | **MSG00638** | PERIOD_MAX_3YEAR | 신규 | `validate.ts` validateFind | ✅ |
| 36 | L1493 | 저장시 중복 오류가 발생하였습니다.{0} | **MSG00633** | DUPLICATE | 신규 | `validate.ts` validateSaveRows (dup) | ✅ |
| 37/43 | L1499/L1660 | MKT FCST 수량이 입력된 일자가 없습니다. | **MSG00632** | NO_QTY_INPUT | 신규 | `validate.ts` validateSaveRows hasAnyDailyInput | ✅ |
| 40 | L1569 | AS From-Site 를 ALL 로 저장 불가 | **MSG00643** | AS_SITE_ALL | 신규 | `validate.ts` validateSaveRows AS+ALL | ✅ |
| 41/42 | L1621/L1636 | 저장하시겠습니까? (AS-IS '수정한 내용을~') | **MSG00004** | CONFIRM_SAVE | **재사용**(정확일치) | `MktFcst.tsx` handleSave confirm | ✅ |
| 73 | L3388 | (FcstType 코드 invalid) | **MSG00644** | FCST_TYPE_INVALID | 신규 | constants.MSG.FCST_TYPE_INVALID (콤보 dataMap 단계) | ⚠️ 콤보의존 |
| 95 | L3253 | 신규 입력 데이터 중 중복된 데이터가 있습니다. | **MSG00642** | DUPLICATE_INPUT | 신규 | `validate.ts` (buildDuplicateKey 동일 경로) | ✅ |
| 101 | L3844 | 실적 수량보다 작은 숫자를 넣을 수 없습니다. | **MSG00639** | BELOW_ACTUAL | 신규 | `recalc.ts` recalcMonthlyToDaily belowActual | ✅ |
| 106 | L4335 | [{0}] 은 필수 입력사항입니다. | **MSG00631** | REQUIRED_FIELD | 신규(오매핑 MSG00002 교정) | `validate.ts` validateSaveRows REQUIRED {0} | ✅ |
| — | (숫자값) | 0 보다 큰 수를 입력하세요. | **MSG00634** | POSITIVE_QTY | 신규 | (숫자 입력 가드) | ✅ |
| — | (Period 누락) | 조회 기간을 입력하세요. | **MSG00645** | REQUIRED_PERIOD | 신규(필수값과 분리) | `validate.ts` validateFind | ✅ |
| — | (저장대상 0) | 저장할 데이터가 없습니다. | **MSG00646** | NO_SAVE_DATA | 신규 | `validate.ts` validateSaveRows | ✅ |
| 111 | L4412 | YYYYMMDD형식이 맞지 않습니다. | (구조보장) | — | — | `save.ts` unfoldCell (D_ 셀만 8자리) | ➖ |
| 130 | L5401 | (Insert 행 Bucket 변경 불가) | **MSG00640** | INSERT_ONLY_BUCKET | 신규 | `validate.ts` validateBucketChange | ✅ |
| 138 | L5519 | 선택된 셀이 없습니다. | **LBL00709** | (prContext msgKey) | 신규 | `prContext.ts` + `MktFcstGrid.tsx` | ✅ |
| 140 | L5594 | 실적 구간이 포함되어 있습니다. | **LBL00703** | (prContext msgKey) | 신규 | `prContext.ts` buildRequestPr | ✅ |
| 141/150 | L5620/L5713 | 일자컬럼에서만 사용가능합니다. | **LBL00702** | (prContext msgKey) | 신규 | `prContext.ts` | ✅ |
| 144 | L5638 | Request 할 내용이 없습니다. | **LBL00704** | (prContext msgKey) | 신규 | `prContext.ts` buildRequestPr | ✅ |
| 145 | L5644 | Model 은 중복될 수 없습니다. | **LBL00705** | (prContext msgKey) | 신규 | `prContext.ts` buildRequestPr | ✅ |
| 146 | L5652 | Project 는 동일해야 합니다. | **LBL00706** | (prContext msgKey) | 신규 | `prContext.ts` buildRequestPr | ✅ |
| 148 | L5699 | 한 개의 셀만 선택할 수 있습니다. | **LBL00707** | (prContext msgKey) | 신규 | `prContext.ts` buildSingleCell | ✅ |
| 149 | L5706 | BNP In 메저행에서만 사용가능합니다. | **LBL00708** | (prContext msgKey) | 신규 | `prContext.ts` buildSingleCell | ✅ |
| 8 | L… | MSG00448 (편집가능 division — 미등록) | (BE 메타 의존) | — | — | (DM_UI_EDITABLE_DIVISION) | ⚠️ BE의존 |
| 28 | L1586 | MSG00003 (Excel 관련 — 미등록) | (공통) | — | — | SubTitle excel DefaultButtonActions | ➖ 공통 |

> **모달/이력/저장 MSG (tsx/modals)**: PR 발행 확인=**MSG00649**, PR 발행됨=**MSG00650**, PR 발행실패=**MSG00651**,
> 이력없음=**MSG00652**, MasterChange SP대기=**MSG00653**, 저장됨=**MSG00606**(공용 재사용), 저장오류=**MSG00618**(공용 재사용).
> **2026-06-28 재채번 결정**: 구 scaffold 의 GSCM MSG ID(MSG00002/00034/00043/…)·임의 LBL01900~01917 은 사내 미존재로
> 폐기, AS-IS 원문 텍스트 매칭 후 사내 max+1 정식 채번으로 교체. `MSG00004`(저장 확인) 만 정확 일치 재사용.
> 컬럼 라벨 재사용(정확 일치): SalesSite=LBL00011 / PlantSite=LBL00005 / EndCustomer=LBL00080 / Incoterms=LBL00024 /
> Measure=LBL00310 / Owner=LBL00082 / ItemType=LBL00068 / SenderCode=LBL00090 / Team=LBL00044 / Period=LBL00013 /
> Bucket=LBL00032 / Model=LBL00669(공용). 라벨 신규: FCST Type=LBL00679 / Customs Handbook=LBL00680 / Daily~Cell Qty=LBL00682~00691.

### 1.3 사업부분기 113건 — division.ts 1:1

| AS-IS 분기 패턴 (va# 다수) | .cs 근거 | To-Be |
|---|---|---|
| `Substring(0,2)=="81"` / `=="82"` / else(40) | 전반 | `divisionKindOf()` (D81/D82/D40) |
| 키 컬럼 40=Customer40/ScmSiteId40/ItemId40 vs 81·82=Project/ScmSiteId/ItemId | L4861~4881 / L1509~1522 | `divisionKeyColumns()` / `readIdentity()` |
| PlantSite 필수(81만) | L4365 / L5227 | `requiresPlantSite()` |
| 중복키 81=+PlantSite / 82=제외 / 40=Customer40계열 | L4892~4956 | `buildDuplicateKey()` |
| SspSync(40 & MKT_FCST_RP) | L1610 / L2628 | `isSspSyncTarget()` + grid CellDblClick |
| VMI_YN/STD_DIO 표시(82만) | 보강 §6 / L3056 | 컬럼 `_divisionAllow`(ATTRIBUTE3 토큰, hook #92) |
| 8주 잠금(40 Monthly) | L974~981 | `editLock.evalDynCell` div40MonthCutoff |

### 1.4 미구현 9건 (사유 명시 — 은폐 금지)

| va# | 항목 | 사유 |
|---:|---|---|
| 8 | MSG00448 사업부 편집권(DM_UI_EDITABLE_DIVISION) | BE 메타(편집가능 division 테이블) 의존 — SP/메타 적재 후 (handoff). |
| 26/27/28 | ExportExcel 사전검증(myarray/FrozenColumnCount)+MSG00003 | Excel 내보내기 = SubTitle DefaultButtonActions 공통 처리(화면별 검증 불필요). |
| 34 | FindData data_start_pos<0 | 조회 응답 파싱 내부 가드 — SP O_RC1 구조가 보장(컬럼 메타 기반). |
| 73 | MSG00472 FcstType 코드 검증 | 콤보 dataMap(useTabComboQueries) 가 유효 코드만 노출 → 입력 단계 차단. MSG 키만 등록. |
| 99/122 | iWeeklySum<iWkSum_Sync / iValidation>1 (내부 분기) | `recalc.ts`/`validate.ts` 내부 로직으로 흡수(별도 사용자 메시지 없음). |
| 111 | YYYYMMDD 형식 | `save.ts` 가 D_ 셀(8자리)만 unfold → 구조적으로 형식 보장. |

---

## §2. Expressions 축 — 130건 cross-check (2a~2d editLock/recalc)

### 2.1 분류별 반영

| 분류 | 건수 | To-Be 위치 | 상태 |
|---|---:|---|:--:|
| SUM헤더 (#1~5) | 5 | `MktFcstGrid.tsx` mainDynamicColumns (2단 nested 'SUM' 그룹) | ✅ |
| 행잠금: 좌측 상세컬럼 read-only (#8~27, #34~70) | ~57 | 컬럼 메타 `_inputEditType='S'` + beginningEdit(non-insert cancel) | ✅ |
| 행잠금: bucket×past 셀 잠금 (#28~33, #71~87) | ~23 | `editLock.ts` evalDynCell (Daily/Weekly/Monthly + Div40 8주) | ✅ |
| 행잠금: AS_FROM_SITE 조건부 (#90~95, #128~130) | 9 | `MktFcstGrid.tsx` pastedCell(부분) — **잠금 자체 미구현** | ⚠️ gap |
| 합계변수: iWeeklySum/iMonthlySum (#96~127, 일↔주↔월) | 32 | `recalc.ts` recalcDailyToWeekMonth / recalcWeeklyToDaily / recalcMonthlyToDaily | ✅ |

### 2.2 합계변수 32건 → recalc.ts 1:1 (핵심)

| 합계 변수 | .cs Line | recalc.ts 함수 |
|---|---|---|
| iWeeklySum 누적/세팅 (#96/97/122/125) | L4245/4251/4973/5007 | recalcDailyToWeekMonth (weeklySum 루프) |
| iMonthlySum 누적/세팅 (#98/99/112/127) | L4270/4275/4635/5034 | recalcDailyToWeekMonth (monthlySum 루프) |
| iWkSum_Sync 강제상향 (#102/105/106) | L4321/4376/4378 | recalcWeeklyToDaily (wkSumSync / forceWeeklyValue) |
| iDailyQty/iRemnant 분배 (#103/104/107/108/110) | L4367/4368/4379/4380/4385 | recalcWeeklyToDaily (dailyQty/remnant) |
| iLastWeeklySum 과거합 (#115/116/117) | L4676/4709/4711 | recalcMonthlyToDaily (lastWeeklySum / belowActual) |
| iMonthlySum-iLastWeeklySum 분배 (#118/119) | L4718/4719 | recalcMonthlyToDaily (monthlySum-lastWeeklySum) |

### 2.3 Expressions 누락 보완분 (이번 Phase 2f)

> 2a~2d(editLock/recalc) 대조 결과 **합계 32 + bucket 잠금 23 + SUM헤더 5 + 좌측 read-only 57 = 117 은 이미 반영**.
> **잔여 13 중**:
> - **AS_FROM_SITE 조건부 잠금 9건(#90~95, #128~130)**: AS-IS 는 AS 콤보 선택/붙여넣기 시 AS_FROM_SITE 셀 잠금. To-Be 는 `pastedCell` 핸들러로 콤보 재설정만 처리하고 **AS_FROM_SITE 컬럼 자체의 동적 잠금은 미구현** — AS_FROM_SITE 컬럼은 SP 동적 컬럼(LOAD type 자동추가)로 컬럼 메타·BE 의존이라 별도. 사유: 컬럼 메타(`_inputEditType`)+AS 체크 상태 연동 = Phase 후속(BE AS_FROM_SITE 컬럼 적재 후).
> - **InsertRow 상세컬럼 잠금 일부(#46~67 의 CUST_GROUP/APPLICATION/ROUTE 등)**: To-Be 컬럼 메타에 미정의(동적 staticColumns 미적재) → admin SCM_MST_SHEET_COLUMNS 적재 시 `_inputEditType='S'` 로 자동 잠금. fallback MAIN_COLUMNS 에는 핵심 10 컬럼만 → 나머지는 메타 적재 의존(은폐 아님, 메타 주도).

---

## §3. Events 축 — 26건

| # | AS-IS Handler | .cs Line | To-Be 위치 | 상태 |
|---:|---|---:|---|:--:|
| 1 | Form_Load | L312 | `MktFcst.tsx` useEffect mount | ✅ |
| 2 | OnShown | L334 | (Div82 분기 = division.ts) | ✅ |
| 3 | InitControls | L429~540 | column meta + division.ts | ✅ |
| 4 | EditButton (F2) | L795~ | `validate.ts` validateCopyTarget/validateEditMode | ✅ |
| 5 | ExportExcel | L1357~1586 | SubTitle excel (DefaultButtonActions) | ➖ 공통 |
| 6 | FindData (F5) | L1207~ | `MktFcst.tsx` handleSearch + validateFind | ✅ |
| 7 | SaveData (F7) | L1464~1664 | `MktFcst.tsx` handleSave + validateSaveRows | ✅ |
| 8 | InsertRow (F8) | L2389~ | `MktFcst.tsx` handleInsert | ✅ |
| 9 | cboDivision_SelectedIndexChanged | L2861~ | `MktFcstForm.tsx` division change + division.ts | ✅ |
| 10 | clbTeam_SelectedIndexChanged | L2981 | `MktFcstForm.tsx` cascade combo | ✅ |
| 11 | clbCustomer_SelectedIndexChanged | L3016 | `MktFcstForm.tsx` cascade combo | ✅ |
| 12 | spdMain_ComboSelChange | L3107~ | `MktFcstGrid.tsx` combo dataMap | ✅ |
| 13 | spdMain_CellDoubleClick | L3513 / L2628 | `MktFcstGrid.tsx` dblclickHandler (popup + SSP compare) | ✅ |
| 14 | spdMain_Changed | L3798~5141 | `MktFcstGrid.tsx` cellEditEnded → dispatchRecalc | ✅ |
| 15 | ValidationCheck | L4332 | `validate.ts` (필수/형식 가드) | ✅ |
| 16 | fnValidation | L4829 | `validate.ts` validateSaveRows (필수/중복/수량) | ✅ |
| 17 | cboBucketType_Click | L… | `validate.ts` validateBucketChange | ✅ |
| 18 | spdMain_EditChange | L5407 | `MktFcstGrid.tsx` cellEditEnding (pasteContinue) | ✅ inline |
| 19 | spdMain_ClipboardPasted | L5416 | `MktFcstGrid.tsx` pastedCell (combo 재설정) | ✅ inline |
| 20 | spdMain_CellClick | L6405 | `MktFcstGrid.tsx` (PlantSite/82 분기) | ✅ |
| 21 | contextMenuStrip1_ItemClicked | L5510~5753 | `MktFcstGrid.tsx` contextMenuHandler + `prContext.ts` | ✅ |
| 22 | cboAS_CheckedChanged | L6871 | `MktFcstForm.tsx` AS 체크 + handleSave asFromSite | ✅ |
| 23 | btnIncotermsChg | L5359 | `MktFcst.tsx` handleMasterChg (MasterChgModal) | ✅ |
| 24 | btnOwner | L5374 | `MktFcst.tsx` OwnerByDivisionModal | ✅ |
| 25 | btnProject | L… | `MktFcst.tsx` ProjectByDivisionModal | ✅ |
| 26 | btnItemId | L… | `MktFcst.tsx` ItemByDivisionModal | ✅ |

---

## §4. Popup 축 — 8건

| # | AS-IS Popup | 트리거(.cs) | To-Be Modal | 상태 |
|---:|---|---|---|:--:|
| 1 | DM0002_TitleSetForm (컬럼/Measure) | btnColumn/btnMeasure | (공용 ColumnSettingModal — Phase 후속 wire) | ⚠️ wire |
| 2 | SCM0002_ProjectbyDivision | CellDblClick/btnProject | `ProjectByDivisionModal` | ✅ |
| 3 | DM0002_ItembyDivision | CellDblClick/btnItemId | `ItemByDivisionModal` | ✅ |
| 4 | DM0020_OwnerbyDivision | btnOwner | `OwnerByDivisionModal` | ✅ |
| 5 | DMF0003_MatsterChgPopup | btnIncotermsChg L5359 | `MasterChgModal` | ✅ |
| 6 | DMF0003_PRPopup / PRHistoryPopup | contextMenu Request/View/History | `PrModal` / `PrHistoryModal` + `prContext.ts` | ✅ |
| 7 | DMF0003_SspSyncComparePopUp | CellDblClick(Div40&MKT_FCST_RP&동기화색) L2628 | `SspSyncCompareModal` | ✅ |
| 8 | DMF0003_SspSyncPopUp | SaveData 응답 L1610 | `SspSyncResultModal` | ✅ |

> ColumnSetting(#1) 은 컬럼 가시/Measure 동적 fetch(`fetchStaticColumns`/`fetchStaticMeasures`)로 baseline 확보, 사용자 popup wire-up 은 공용 ColumnSettingModal 연동(Phase 후속) — `MktFcst.tsx` applyColumnVisibility 준비 완료.

---

## §5. 변경/신규 파일 (Phase 2f)

| 파일 | 종류 | 내용 |
|---|---|---|
| `utils/mkt-fcst.division.ts` | 신규 | Division 40/81/82 분기 단일원 (키/필수/중복키/SspSync/PlantSite) |
| `utils/mkt-fcst.validate.ts` | 신규 | useMktFcstValidation (find/saveRows/bucketChange/copyTarget/editMode) |
| `mkt-fcst.constants.ts` | 수정 | MSG 객체 사내 정합 재채번(MSG00631~00646 + CONFIRM_SAVE=MSG00004 재사용) |
| `utils/mkt-fcst.division.ts` | 수정 | 컬럼 라벨 LBL 정합(재사용 + FCST Type=LBL00679/Customs Handbook=LBL00680 신규) |
| `components/MktFcstForm.tsx` | 수정 | 조회조건 라벨 재채번(Daily~Cell Qty=LBL00682~00691, Owner/ItemType 등 정확일치 재사용) |
| `utils/mkt-fcst.prContext.ts` | 수정 | contextMenu 임시 LBL01910~01917 → 정식 LBL00702~00709 |
| `components/MktFcstGrid.tsx` | 수정 | "선택 셀 없음" LBL01917 → LBL00709 |
| `components/modals/{PrModal,PrHistoryModal,MasterChgModal,SspSync*}.tsx` | 수정 | 모달 헤더 LBL01900~01907 → LBL00694~00701 / PR·이력 MSG → MSG00649~00653 |
| `MktFcst.tsx` | 수정 | 저장/삭제 MSG·LBL 공용 ID 정합(MSG00606/00618, LBL00665/00666 재사용) |
| `public/locales/{KO,EN,CN}.json` | 수정 | 신규 49 키 등록 + 공용 5 키 + 임의 LBL019xx 제거 |
| `_artifacts/_apply_corporate/40_dmf0003_i18n_register.py` | 신규 | 사내 SCM_ADM_MSG_M 멱등 등록 handoff(신규 49 + 공용 5 = 54키 × 3 lang = 162행, dry-run 기본) |
| `__asis-mapping__.md` | 수정 | 본 문서(2026-06-28 사내 정합 재채번 반영) |

> BE(Java)/SP/foundation/shared/lges/타화면 코드 **무변경**. i18n t()/상대경로/console/any/inline/직접fetch **0**.
> 사내 DB **쓰기 0**(handoff dry-run 검증만 — 적용은 작성자 검토 후 `--apply`).

---

# PSI 고객수요분석 영역 (2026-07-03 — spdSub1/spdSub2/CustDemandAnalysis 팝업)

> 원천: `DMF0003_1_MktFcst.cs` PSI 부분 전수 + `POPUP/DMF0003_CustDemandAnalysis.cs` 1,905줄 완독 (에이전트 전수 인벤토리).
> 사용자 확정: 배치 = 본그리드 위 접이식 패널(AS-IS 그대로) / Car 그리드 포함. SP·메타 = `_artifacts/_deploy_packages/DMF0003_PSI_20260703`.

## 카운트 대사 (AS-IS 인벤토리 = 코드 적용)

| 축 | AS-IS | To-Be 적용 | 비고 |
|---|---:|---|---|
| SP 호출 | 9 (TITLE_PSI/TITLE_CAR/PSI_DATA/AN_LOGIC/DPINIT/DPRESULT/SAVE_DETAIL/CAR_PROPERTY×2경로/CAR_REF) | 9 ✅ (SHEETS 8 sheet + CAR_PROPERTY 2 tabId) | API_M 9/PROC_M 68 사내 배선 |
| 이벤트 체인 | 본그리드 더블클릭→PSI / PSI Search→AN_LOGIC / DP셀 클릭→팝업 / 팝업 닫힘→재조회 / Car 실행 / 제조사변경→모델 / 토글 2종(버튼+더블클릭) | 7/8 ✅ (토글은 버튼 단일화 — 스플리터 더블클릭은 웹 패널 구조상 버튼으로 통합) | |
| PSI 서식 | Yellow/LightGray(DP,당월·전월×첫주) + Average행 LightYellow + Simulation MKT_DP 계산 + RESULT/GAP + △Red + 주말헤더색 + 좌측잠금 + 세로병합 + 스크롤병합유지 | 9/10 ✅ (주말 헤더색은 psi 시트가 기간동적 컬럼이 아니어서 비해당 — SP 타이틀에 요일 없음) | FirstWeeked AS-IS 1:1 이식 |
| 팝업 컬럼 | 하드코딩 14 (SP 타이틀 미사용) | 14 ✅ `CUST_DEMAND_COLUMNS` | measure별 조건부 DE_PL/SL_PC_PF 는 AS-IS visible=N → 숨김열 IN_DDAY 로 대체 매핑 |
| 팝업 콤보 cascade | 3콤보 + 5규칙 (고객→수요 / 당사→운영·공급 / 수요→3 / 운영→2 / 공급→1) | 3+5 ✅ `CUST_DEMAND_CASCADE` + beginningEdit dataMap 교체 + 상위변경 하위리셋 | |
| 저장 | 15 IN ^join + 한글→코드 11종 + 유효행(qtycd3+qty) 필터 + 저장 후 닫힘→재조회 | ✅ 1:1 (+dual OUT — BE 표준) | 저장확인 = TO-BE 표준 MSG00001 만 추가 |
| 팝업 Validation | 활성 0 (전부 주석) | 0 ✅ (임의 추가 금지) | 예외 alert 는 표준 catch |
| Car 조건 | 제조사/모델(cascade)/BIZ TYPE/M-S%/PER CAR/PERIOD/실행/엑셀업로드/DataSource 라벨 | 8/9 ✅ | 엑셀업로드 = **HOLD**(TO-BE 범용 업로드 컴포넌트 부재. 서버 PKG proc 기등록) |
| Car 계산 | 기간검증 2(MSG00108/00164) + M/S·PerCar 환산(i+3) + 전 컬럼 잠금 + YYYYQQ 동적 | ✅ 1:1 | |

## AS-IS 비활성/비일관 — 구현 제외 근거

| 항목 | AS-IS 상태 | 처분 |
|---|---|---|
| 팝업 spdMain_Changed/CellClick/Change | 미배선("삭제대상" 주석) | 제외 (비활성) |
| 팝업 GetSPlant/GetSLOC 헬퍼 | 호출부 없음 | 제외 |
| 팝업 월별·주차 저장 잠금 (_FWEEK 락) | 전부 주석 | 제외 (AS-IS 비활성) |
| LockColumn 12(더블클릭) vs 11(재조회) 불일치 | AS-IS 자체 비일관 | To-Be 전 컬럼 read-only 로 상향 통일(편집은 팝업 전용 — 동작 동일) |
| Cancel-재조회 루프의 배경색 미갱신 | AS-IS 결함성 | To-Be formatItem 상시 적용 (일관 우수) |
| CAR_REF ExecuteDataSet 4회 중복 호출 | AS-IS 성능 결함 | To-Be 1회 호출 (동작 동일) |
| SetSpreadHeaderSpan_SUB2 | 본문 전체 주석(no-op) | 제외 |
| DMF0081_MktFcst_Auto 계열(81 자동화 화면) | 별도 화면(DMF0081) | 범위 외 — DMF0003 만 |

## 변경 파일 (PSI 추가분)

| 파일 | 유형 |
|---|---|
| `components/MktFcstPsiPanel.tsx` + `.module.scss` | 신규 (패널: 조건행+좌PSI+우Car+팝업 오케스트레이션) |
| `components/MktFcstPsiGrid.tsx` | 신규 (타이틀 SP 동적 컬럼 + 서식/계산/클릭 트리거) |
| `components/MktFcstCarGrid.tsx` | 신규 (Car 조건+YYYYQQ 동적+환산) |
| `components/modals/CustDemandAnalysisModal.tsx` | 신규 (14컬럼+cascade+RESULT/GAP+^join 저장) |
| `components/modals/index.ts` | 수정 (barrel) |
| `components/MktFcstGrid.tsx` | 수정 (onPsiDrilldown 더블클릭 분기 — Div81+버킷일치+PROJECT 검증) |
| `MktFcst.tsx` | 수정 (패널 조립 + setPsiFilter 배선) |
| `useMktFcstStore.ts` | 수정 (filters[PSI]/psiPanelOpen/setPsiFilter) |
| `mkt-fcst.constants.ts` | 수정 (SHEETS 9 + PSI_MEASURE/CUST_DEMAND_*/CAR_FIXED_COLUMNS) |
| `configs/types/procedures.d.ts` | 수정 (DMF0003 sheet 8종 request/response — 실측 shape) |
| `public/locales/{KO,EN,CN}.json` | 수정 (LBL00718~00727 — json 채번 max+1) |

> 검증: tsc exit 0 / ESLint error 0 (잔여 warning 5 = 기존 파일 기존 패턴) / POST-WRITE 금지 grep 0.
> BE(Java)/shared/foundation/타화면 무변경.

---

## 2026-07-03 (오후) — 평문 AS-IS 정합 + PR 4기능 복구 (사용자 지시 8건)

- **정본 변경**: 원천 = 평문 `DMF0003_MktFcst.cs` (사용자 실행 AS-IS). 상단 PSI/Car/CustDemand 는 별개 변형
  `DMF0003_1_MktFcst` 전용으로 확인 → **화면에서 제거** (구현·DB 등록분은 `_deploy_packages/DMF0003_PSI_20260703/` 보존).
- **Color 체크박스 제거**: AS-IS chkColor 는 실행 UI 미표시·초기 false → false 경로 고정
  (과거 Gray 없음 + 현재 W_/M_ 헤더 초록 Bold — .cs L5654~5687 1:1).
- **우클릭 PR 4기능**: PROC_M/API_M 0행 + SP 결함 4건(대소문자 'Add_History'/'View_History'·커서 미오픈·
  ORA-22950·SAVE INVALID) 복구 + FE 격차 8건 교정 — 카운트 대사: AS-IS 검증 11종(V1~V7+S1~S3+Div40) = TO-BE 11종 ✅,
  메뉴 4항목·모달 2종·헤더 필드(4+5)·행클릭 PR_HEADER ✅. 상세 = `_deploy_packages/DMF0003_PR_20260703/README.md`.
- **그리드 콤보**: UI Category 메타(cellCboDataTp) 기반 + cascade(hook #59 §5-G) + Model 셀 아이콘(DMF0020 동일)
  + Model 선택 시 ITEM_NAME/NICK_NAME 자동입력(메타 'S' 전환).
- FcstType/CustomsHandbook 콤보 SQL = AS-IS 정본(param-less)으로 교체 — BE makeComboQuery 가 파라미터 콤보를
  치환하지 못하는 구조 실측(hook 이관: 파라미터 콤보 등록 금지).

## 의도적 편차 — 컬럼 고정(freeze) 메타 위임 (2026-07-04 사용자 지시)

AS-IS `Freeze(0, MEASURE 인덱스+1)` (좌측 식별 컬럼 블록 하드코드 고정, FIXED_FLAG 미참조)은
**재현하지 않음**. `MktFcstGrid.mainStaticColumns` 의 `fixed: true` 리터럴을 `fixed: c.fixed`
(admin `SCM_MST_SHEET_COLUMNS.FIXED_FLAG` 위임)로 전환 — hook `ui-category-setup-column-meta` §12
(관리 속성 "속성 단위" 하드코딩 금지, DMF0048 FIX 사고 후속 일괄 조치).
사내 메타 실측: DMF0003 'Mkt Fcst' 67행 전행 FIXED_FLAG 공란 = 현재 고정 0.
고정이 필요하면 admin SYS0004 에서 FIXED_FLAG='Y' 등록 (화면 수정 불요).
