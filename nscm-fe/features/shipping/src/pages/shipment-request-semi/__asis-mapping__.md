# SSP0045 Shipment Request SEMI — AS-IS ↔ TO-BE 매핑 매트릭스

> convert-core §2.1 Top11-11(AS-IS 검증·표현식 항목 매핑 누락 금지)의 산출물.
> 백본 = `.atlas/gscm-design/SSP0045/design/00_checklist.md`(Roslyn `1.2-syntax`) **154행** +
> 백본 밖 **G01~G21** + `extractionLimits` **L01·L02**. **공란 0** — 제외 항목도 사유를 명시한다.
>
> AS-IS 정본: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0045_ShipmentRequest.cs`(1,468행) + `.Designer.cs`(683행).
> TO-BE 정본: `nscm-fe/features/shipping/src/pages/shipment-request-semi/`.
> 약칭 — Page=`ShipmentRequestSemi.tsx` · Form=`components/ShipmentRequestSemiForm.tsx` ·
> Grid=`components/ShipmentRequestSemiGrid.tsx` · Bod=`components/modals/BodItemRouteModal.tsx` ·
> Store=`useShipmentRequestSemiStore.ts` · Lock=`utils/shipmentRequestSemi.editLock.ts` ·
> Cols=`utils/shipmentRequestSemi.columns.ts` · Save=`utils/shipmentRequestSemi.save.ts` ·
> SaveHook=`hooks/useShipmentRequestSemiSave.ts` · Valid=`hooks/useShipmentRequestSemiValidation.ts` ·
> Const=`shipment-request-semi.constants.ts` · Meta=`.atlas/gscm-design/SSP0045/design/05_register.sql`.
>
> 상태 어휘: **구현** / **제외(사유)** / **미완(사유)**.
>
> 개정 이력: iter-2(2026-09-25) — react-gap-audit iter-1 G-12 지적 반영.
> legend 에 `SaveHook`/`Meta` 추가(저장 가드 7행이 `Page` 로 오지정돼 있었다) · G05 상태 정정 ·
> iter-2 에서 바뀐 행에 `file:line` 부여.
>
> 개정 이력: iter-3(2026-09-25, convert-react) — H-02 로 V09 중복검사 대상이 dirty → **그리드 전 행**
> 으로 바뀌었다. 이 문서는 그 회차에 갱신되지 않아 **고친 결함을 그대로 기술**하고 있었다(N-08).
>
> 개정 이력: convert-gap-resolve iter-1(2026-09-25) — 아래 행을 실측으로 갱신했다.
> · V09 — 대상·`file:line` 을 iter-3 교정 후 상태로 정정(N-08).
> · G05 — 저장 가드 **순서**를 AS-IS(cs:867-873 → cs:1011-1014)대로 정정: 행0 → 필수 → 9키중복 →
>   수집 → 변경0. iter-3 까지는 변경0 가드가 앞에 있어 조회 결과의 기존 중복이 경고 없이
>   "변경 없음" 으로 빠졌다(N-06).
> · S56 / R12 — BOD 확정 시 기간셀 클리어 대상을 가시 컬럼 → **기간칼럼 전체**로 정정(N-03).
> · 신규 R03-b — 기간셀 음수 글자색(`NegativeRed`)·입력 클램프(±9,999,999,999) 이식(N-04·N-05).
> · 신규 G22 — `EXCEL` 버튼 admin 권한 게이트(N-07).

---

## 1. controls (26) — §1

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| C01 | `cboDivision` (UsrCombo) | Form F1 `CustomDropdown` + `MyDivision`(mnuId 전달) | 구현 |
| C02 | `cboBizType` (UsrCombo) | Form F2 `CustomDropdown` + `OperationGroup_SCP` | 구현 |
| C03 | `txtItem_Id` (UsrMultiLineEditor) | Form F3 `InputField`(콤마 다중) | 구현 |
| C04 | `btnItem_Id` (UsrButton) | Form F4 `Button`+`FunctionSearchIcon` → Page `ModelByDivisionPopup` | 구현 |
| C05 | `clbFromSite` (UsrCheckedList) | Form F5 `CustomDropdown multiple allOption` | 구현 |
| C06 | `cboBucketType` (UsrCombo) | Form F6(extraConditions) `CustomDropdown` + `BucketType` | 구현 |
| C07 | `drpPeriod` (UsrDateRangePicker, Enabled=false) | Form F7 로컬 read-only `InputField`(disabled) | 구현 |
| C08 | `chkSum` (UsrCheckBox) | Form F8(extraConditions) `Checkbox` | 구현 |
| C09 | `usrConditionPanel1` (HidePanel) | `MainTitle.openSearchArea` + `SearchArea isHidden` | 구현 |
| C10 | `usrLayoutControl2` | `SearchArea` 내부 12-column grid(별도 DOM 없음). 권한 0건 시 전 필드 disabled | 구현 |
| C11 | `layoutControlGroup2` | FormItem 배열 루트 | 구현 |
| C12 | `lblCombo1` "Division*" | `FormItem label={t('LBL00641')} required` | 구현 |
| C13 | `lblCombo` "Operation Group*" | `FormItem label={t('LBL00027')} required` | 구현 |
| C14 | `lblItemId` "Model" | `FormItem label={t('LBL00669')}` | 구현 |
| C15 | `layoutControlItem4`(팝업버튼 슬롯) | Model FormItem 안 `popupSearchField` 버튼 슬롯 | 구현 |
| C16 | `layoutControlItem3` "From Site" | `FormItem label={t('LBL00022')}` | 구현 |
| C17 | `emptySpaceItem1` | 여백 슬롯 — **제외**(빈 div 신설 금지, grid column span 으로 표현) | 제외(DOM 노드 불필요) |
| C18 | `lblBucket` "Bucket" | `FormItem label={t('LBL00710')}` | 구현 |
| C19 | `layoutControlItem6` "Period*" | `FormItem label={t('LBL00013')} required` | 구현 |
| C20 | `layoutControlItem9`(체크박스 슬롯) | `commonStyles.customCheckbox` 래퍼 | 구현 |
| C21 | `emptySpaceItem3` | 여백 슬롯 — **제외**(C17 동일) | 제외(DOM 노드 불필요) |
| C22 | `spdMain` (FpSpread) | Grid `DataGrid` | 구현 |
| C23 | `spdMain_Sheet1` (Designer 시트) | `Reset()` 후 미사용 — 런타임 시트는 `AddSheet` 산출물 | 제외(미사용) |
| C24 | `imageList1` (edit.png) | TR_MODE 셀 어포던스 — Grid formatItem `styles.trModeEditable`(연필 글리프, iter-2). 이미지 자산은 미이식하고 동일 의미 글리프로 대체 | 구현(자산 대체) |
| C25 | `components` (Container) | WinForms 전용 컨테이너 | 제외(대응 없음) |
| C26 | `usrButton1` | **dead control** — `Controls.Add` 미포함 + 참조 0건(G14) | 제외(dead) |

## 2. events (9) — §2

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| E01 | `CboDivision_SelectedIndexChanged` | Store `setDivision`(하위 From Site reset=CS1) + Page division 감시 effect(그리드 초기화) | 구현 |
| E02 | `BtnItem_Id_Click` | Form `onModelSearch` → Page `ModelByDivisionPopup` | 구현 |
| E03 | `cboBucketType_SelectedIndexChanged` | Grid `isPivotVisible` 매트릭스 재평가(상태 변경 = 렌더) | 구현 |
| E04 | `CboBizType_SelectedIndexChanged` | Store `setOperationGroup` → 콤보 파라미터 변화로 From Site 재조회 | 구현 |
| E05 | `SpdMain_TopChange` (스크롤 병합 재적용) | 공용 `CustomMergeManager` 가 상시 유지 — 스크롤 훅 불필요 | 제외(공용 대체) |
| E06 | `SpdMain_CellDoubleClick` | Grid `dblclick` → `buildDrilldownPatch` | 구현 |
| E07 | `SpdMain_CellClick` | Grid `click` → TR_MODE 가드 → `onBodCellClick` | 구현 |
| E08 | `SpdMain_ComboSelChange` | Grid `cellEditEnded`(ITEM_ID) → Page `handleModelChanged` | 구현 |
| E09 | `chkSum_CheckedChanged` | E03 과 **같은 매트릭스 1벌**(`isPivotVisible`) | 구현 |

## 3. validations (9) — §2b · Top11-11 대상

| # | AS-IS msgId | 의미 | TO-BE | 상태 |
|---|---|---|---|---|
| V01 | — (`GMessageBoxForException`) | 조회 예외 표면화 | react-query 전역 에러 처리 + 공용 인터셉터 | 제외(공용 대체) |
| V02 | `MSG00084` | 수량 음수 차단 + 셀 배경 | Save `findNegativeCells`(save.ts:105) → SaveHook alert `MSG00699` + 전체 중단 + Page `negativeCells` → Grid `styles.negativeCell` | 구현 |
| V03 | `MSG00004` | 저장 성공 `{0}건` + 재조회 | SaveHook `setToast(MSG00672)` + `onSaved()` → Page `refetch()` | 구현 |
| V04 | (동적 문자열) | SP 반환 `'N'` — 서버 메시지 | SaveHook `RESULT_CODE==='N'` → 서버 `MSG` 그대로 alert | 구현 |
| V05 | `MSG00042` | 시스템 오류(else 분기) | SaveHook else → `MSG01075` | 구현 |
| V06 | `MSG00005` | 변경/추가 없음 | SaveHook dirty 0 / cells 0 → toast `MSG00676` | 구현 |
| V07 | — (`GMessageBoxForException`) | 저장 예외 표면화 | SaveHook `catch` → alert | 구현 |
| V08 | `MSG00098` | TR_MODE 클릭 시 Model 미선택 | Grid `onModelRequired` → Page alert `MSG01126`(`{0}`=Model) | 구현 |
| V09 | `MSG00260` | 9키 중복 차단 | Save `findDuplicateKey`(save.ts:159, 대상=**그리드 전 행** × `MEASURE='SHIP_REQ'`) ← SaveHook:158 alert **`MSG00428`** | 구현 |

> i18n: AS-IS 번호는 TO-BE 에서 뜻이 다르거나 미등록이라 **문구 역조회로 확정한 코드**만 쓴다(hook #114,
> design 02 §4.5.1 / 03 §5.3). `MSG00108` 만 유일하게 번호가 그대로 유효하다.
>
> iter-2 정정 1건 — V09: AS-IS `MSG00260` 의 의도는 소스 주석 실측(cs:1449 "입력 데이터 중 중복된 데이터가
> 있습니다.")이고, TO-BE `MSG00260` 은 "Duplicate combination (Division/Project/Item/Date/Measure)." 로
> **축이 다른 별개 문구**다. 번호를 답습하면 9축 중복을 5축으로 잘못 안내한다 → 문구 역조회로 정확히 일치하는
> `MSG00428`("There are duplicate entries among the newly entered data.")로 교체했다(react-gap-audit G-19).
>
> **`*` 라벨 필수검증(AS-IS `checkRequiredOfSpread`, cs:870 → `DataUtil.cs:29-58`)은 백본 `validations` 9행에
> 없다** — Roslyn 이 `MessageHelper` 직접 호출만 뽑았고 이 경로는 프레임워크 유틸 안에서 메시지를 띄우기
> 때문이다(한계 L01 계열). 매핑 대상에서 빠져 iter-1 이 통째로 미구현했다(G-01). iter-2 에서
> `Save.findMissingRequired`(save.ts:126) + SaveHook `MSG00429` 로 구현했고, 원장 위치는 아래 G05 다.

## 4. gridSignals (63) — §3

### 4.1 영역3 48건

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| S01 | `SmartColMerge` (InitSpread_2) | Grid `col.allowMerging` + 공용 `CustomMergeManager` | 구현 |
| S02 | `SetReNumerCellType` (`B_` 컬럼) | `B_` 분기 **도달 불가**(판정식 `IndexOf("B_")>0`) | 제외(도달 불가) |
| S03 | `SetReNumerCellType` (기간 컬럼) | Cols `buildPivotColumns` `format:'n0'`(= `DecimalPlaces=0` + `ShowSeparator`) · **`NegativeRed` → Grid `formatItem` `styles.negativeValue`(N-04)** · **`Min/MaximumValue ±9,999,999,999` → Grid `cellEditEnding` `clampQtyOnCommit`(N-05)**. 프레임워크 4-인자 오버로드 본문 = `SpreadInfo.cs:11005-11018`. 음수 입력 자체는 AS-IS 도 허용(하한 -9,999,999,999)이며 저장 시 R13/V02 가 차단 | 구현 |
| S04 | `ForeColor=` 토/일 헤더 | Grid `formatItem` + `styles.satHeader`/`sunHeader` | 구현 |
| S05 | `ColumnHeaderSpan` 0단 월 | Cols 1단 그룹(`largeLabel`) | 구현 |
| S06 | `ColumnHeaderSpan` 1단 월 SUM | Cols 월 SUM 전용 2단 그룹 + leaf `'SUM'` | 구현 |
| S07 | `ColumnHeaderSpan` 1단 주(월 전환) | Cols 2단 그룹(`smallLabel`) | 구현 |
| S08 | `ColumnHeaderSpan` 2단 주 SUM(높이 30) | Cols leaf `'SUM'`. 높이는 hook #93 규약(16px 고정)으로 대체 | 구현(수치 미이식) |
| S09 | `ColumnHeaderSpan` 1단 주(주 전환) | S07 과 동일 경로 | 구현 |
| S10 | `ColumnHeaderSpan` 2단 주 SUM(주 전환) | S08 과 동일 경로 | 구현 |
| S11 | 1단 주 스팬 — 마감분 | 그룹 누적 방식이라 마지막 그룹도 자동 종료(누락 버그 구조적 부재) | 구현 |
| S12 | 2단 주 SUM — 마감분 | 동상 | 구현 |
| S13 | 0단 월 스팬 — 마감분 | 동상 | 구현 |
| S14 | 1단 월 SUM — 마감분 | 동상 | 구현 |
| S15 | `SetDblClickColumnShowHide` | Cols `buildDrilldownPatch` + Grid `dblclick` | 구현 |
| S16 | `SmartColMerge` (TopChange) | E05 와 동일 — 공용 머지 매니저가 상시 유지 | 제외(공용 대체) |
| S22 | `Delete` (신규행만) | Page `handleDelete` → `GridAction.removeRow(grid, true)` | 구현 |
| S23 | `Query(dsBinding)` | Page `useTabProcQuery` → `DataGrid itemsSource` | 구현 |
| S25 | `SmartColMerge` (조회 후) | S01 과 동일 | 구현 |
| S27 | `Insert` (InsertRow, dead) | 호출 0건 — 미이식 | 제외(dead, G14) |
| S28 | `SetValue` 기본값 3종 (dead) | S33 으로 대표 구현 | 제외(dead, G14) |
| S31 | `SetCellTypeCombo` ITEM_ID (dead) | S36 으로 대표 구현 | 제외(dead, G14) |
| S32 | `Insert` (InsertRow2, 실사용) | Page `handleBodSelected` 2건째부터 `GridAction.addRow` | 구현 |
| S33 | `SetValue` 기본값 3종 | Page `handleBodSelected` — DIVISION_ID(확정 searchParams)/MEASURE/MEASURE_LABEL | 구현 |
| S36 | `SetCellTypeCombo` ITEM_ID | Grid `BODItemProjectRoute_SCP` DataMap 주입(Grid.tsx:199-209) | 구현 |
| S37 | `SetBGColor` 음수 셀 | Page `negativeCells` state → Grid formatItem `styles.negativeCell`(iter-2) | 구현 |
| S38 | Daily `D_`/`W_` = true | Cols `isPivotVisible(DAILY)` | 구현 |
| S39 | Daily `M_`/`W_` = chkSum | 동상(최종값이 chkSum 임을 매트릭스에 반영) | 구현 |
| S40 | Weekly `D_` = false | `isPivotVisible(WEEKLY)` | 구현 |
| S41 | Weekly `W_` = true | 동상 | 구현 |
| S42 | Weekly `M_` = chkSum | 동상 | 구현 |
| S43 | Monthly `D_`/`W_` = false | `isPivotVisible(MONTHLY)` | 구현 |
| S44 | Monthly else = true | `M_` 만 true. **hidden 메타컬럼 노출은 미재현**(U3 결함 미이식) | 구현(의도적 이탈, U3) |
| S45 | `SetActiveCell` → ITEM_ID | Grid click 핸들러가 `g.select(new CellRange(ht.row, itemIdIndex))` 후 팝업 오픈(iter-2). AS-IS cs:1215 와 동일하게 Model 미선택 안내 분기보다 **먼저** 수행 | 구현 |
| S47 | `SetValue` ITEM_ID | Page `BOD_FILL_MAP` | 구현 |
| S48 | `SetValue` FROM_SITE | 동상 | 구현 |
| S49 | `SetValue` TO_SITE | 동상 | 구현 |
| S50 | `SetValue` TR_MODE | 동상 | 구현 |
| S51 | `SetValue` INCOTERMS | 동상 | 구현 |
| S52 | `SetValue` LT_DAY | 동상 | 구현 |
| S53 | `SetValue` FROZEN_YYYYMMDD | 동상 | 구현 |
| S54 | `SetValue` BOD_ID | 동상 | 구현 |
| S56 | `SetValue` 기간셀 `null` 클리어 | Page `handleBodSelected` ③ — 대상 = **기간칼럼 전체**(`pivotCols` ∪ 행 객체의 `M_/W_/D_` 키). 가시 컬럼(`grid.columns`)으로 뽑으면 Weekly/Monthly 에서 `D_` 가 생성되지 않아 한 칸도 못 지우고 이전 BOD 수량이 저장된다(N-03). hidden `BOD_FROM/TO` 는 기간칼럼이 아니라 제외(U3) | 구현 |
| S58 | `SetValue` FROM_SITE ← `""` | Page `handleModelChanged` | 구현 |
| S59 | `SetValue` TO_SITE ← `""` | 동상 | 구현 |
| S60 | `SetValue` TR_MODE ← `""` | 동상 | 구현 |
| S61 | `SetValue` INCOTERMS ← `""` | 동상 | 구현 |
| S62 | `SetValue` LT_DAY ← `""` | 동상 | 구현 |
| GC01 | `AddTextColumn` (`B_`, hidden) | S02 와 동일 — 도달 불가 | 제외(도달 불가) |
| GC02 | `AddNumColumn` (기간, width 70) | Cols `PIVOT_COLUMN_WIDTH=70` | 구현 |

### 4.2 영역1 lock 15건 (L01~L15 ↔ L-A~L-J)

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| S17 | `SwitchLock()` (EditButton) | Edit 모드토글 미이식 — `asis_to_tobe.md §11`(전 화면 공통 결정) | 제외(§11) |
| S18 | `LockColumn(0,true)` | Action 컬럼 없음(`CRUD_TYPE`/EditTracker 대체) | 제외(§11) |
| S19 | `LockColumn(0,max,true)` | "기본 거부 화이트리스트" 철학만 승계 → Lock `isEditableDayCell` 기본 false | 구현(의미 승계) |
| S20 | `LockRange(MEASURE+1..end)` (BG04) | 모드 OFF 복귀 경로 — 모드 자체가 없다 | 제외(§11) |
| S21 | `LockRange` SHIP_REQ 행 3케이스 | **Lock `editableDayRange` 3케이스**(K1) | 구현 |
| S24 | `LockColumn` 조회 직후 전잠금 | `INPUT_TP_CD='S'` + 기본 거부로 자동 성립 | 구현(구조적) |
| S26 | `SetLockSumColumn` (Tag `M_`/`W_`) | Lock `isSumBinding` — 개방 규칙보다 **먼저** 평가(K3) | 구현 |
| S29 | `LockRange` DIVISION_ID (dead) | S34 로 대표 구현 | 제외(dead) |
| S30 | `LockRange` NICK_NAME..end (dead) | S35 로 대표 구현 | 제외(dead) |
| S34 | `LockRange` DIVISION_ID (실사용) | 신규행 DIVISION_ID 는 확정 division 으로 채우고 메타(`INPUT_TP_CD='S'`)로 잠김 | 구현 |
| S35 | `LockRange` NICK_NAME..end | Lock ④ `CRUD_TYPE='I' && !BOD_ID` → `D_` 전건 거부 + 고정 컬럼 메타 잠금(K4) | 구현 |
| S46 | `LockRange` ITEM_ID 해제(2번째 행~) | Grid `beginningEdit` 예외 — 신규행 ITEM_ID 만 개방. **AS-IS 행범위 이상(Q5)은 미재현** | 구현(의도적 이탈, Q5) |
| S55 | `LockRange` MEASURE+1..end (BOD 매핑 전) | S56 클리어의 전제 — TO-BE 는 값 클리어 후 Lock 이 즉시 재판정 | 구현(구조적) |
| S57 | `LockRange` BOD×Frozen 개방 | S21 과 **같은 함수**(K2) — Lock 1벌 공유 | 구현 |
| S63 | `LockRange` MEASURE..end 재잠금 | `BOD_ID` 를 비워 Lock ④ 로 자동 재잠금. **시작열 1칸 차이(Q5)는 기록** | 구현(의도적 이탈, Q5) |

## 5. spCalls (5) — §4-A

| # | AS-IS SP | TO-BE | 상태 |
|---|---|---|---|
| SP01 | `DM0003_GET_BUCKET_TYPE_CODE` | 콤보 `BucketType`(TO-BE 등록 실측, 동일 LOOKUP) | 구현 |
| SP02 | `SCM0001_GET_SCP_DAY_PERIOD` | Store `makeInitPeriod`(오늘~+55일). **달력 clamp 는 SP 몫 — 미완** | 미완(SP 미배포) |
| SP03 | `SSP0045_GET_SHIPMENT_REQUEST` | Page `useTabProcQuery(SHEETS.MAIN)` — 10 파라미터 배선 완비 | 미완(SP 미배포) |
| SP04 | `SSP0045_SAVE_SHIPMENT_REQUEST` | Page `handleSave` → Save `buildSavePayload`(13×'^' + created_by + debug_mode) | 미완(SP 미배포) |
| SP05 | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | Page `useTabProcQuery(SHEETS.CALENDAR)` — 자매 SCP0100 배선 미러 | 미완(SP 미배포) |

## 6. comboCalls (5) — §4b

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| CB01 | `OperationGroup` (`_SCP`) | Form `OperationGroup_SCP`(5층 대조 완전 일치) | 구현 |
| CB02 | `PlantByDivisionOperation` (InitControls) | Form F5 — 토큰 4개 전달 | 구현 |
| CB03 | `PlantSiteByDivision('40,81,82')` | Grid FROM_SITE/TO_SITE DataMap + `'-'` 더미 선두 | 구현 |
| CB04 | `PlantByDivisionOperation` (CboBizType) | CB02 와 동일 콤보 — 파라미터 변화로 재조회 | 구현 |
| CB05 | `BODItemProjectRoute` (`_SCP`) | Grid ITEM_ID DataMap — 지연로딩은 react-query 키로 등가 재현(G18) | 구현 |

## 7. entryPoints (14) — §4-B

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| EP01 | `FindButton` | `hotkeyConfig.search = hasButton('SEARCH') ? handleSearch : false` | 구현 |
| EP02 | `SaveButton` | `hotkeyConfig.save = hasButton('SAVE') ? handleSave : false` | 구현 |
| EP03 | `EditButton` | **키 자체 없음** — `asis_to_tobe.md §11` 미이식(`HotkeyConfig` 에 `edit` 키 부재) | 제외(§11) |
| EP04 | `InsertButton` | `hotkeyConfig.insert = () => undefined` — 명시적 NO-OP(K6) | 구현 |
| EP05 | `DeleteButton` | `hotkeyConfig.delete = hasButton('DELETE') ? handleDelete : false` | 구현 |
| EP06 | `BtnItem_Id_Click` | Form `onModelSearch` | 구현 |
| EP07 | `CboDivision_SelectedIndexChanged` | Store `setDivision` | 구현 |
| EP08 | `CboBizType_SelectedIndexChanged` | Store `setOperationGroup` | 구현 |
| EP09 | `cboBucketType_SelectedIndexChanged` | 상태 변경 → 매트릭스 재평가 | 구현 |
| EP10 | `chkSum_CheckedChanged` | 동상 | 구현 |
| EP11 | `SpdMain_CellClick` | Grid `click` 핸들러 | 구현 |
| EP12 | `SpdMain_CellDoubleClick` | Grid `dblclick` 핸들러 | 구현 |
| EP13 | `SpdMain_ComboSelChange` | Grid `cellEditEnded` | 구현 |
| EP14 | `SpdMain_TopChange` | E05/S16 과 동일 — 공용 머지 매니저 | 제외(공용 대체) |

## 8. buttonGuards (17) — §4d

| # | AS-IS 가드 | TO-BE | 상태 |
|---|---|---|---|
| BG01 | `fps == null` (Edit) | Edit 미이식 | 제외(§11) |
| BG02 | `fps.Name=="spdMain"` (Edit) | 동상 | 제외(§11) |
| BG03 | `RowCount == 0` (Edit) | 행 0건이면 편집 시도 자체가 불가 — 구조적 성립 | 구현(구조적) |
| BG04 | Action 컬럼 hidden 분기 | 모드 OFF 복귀 경로 | 제외(§11) |
| BG05 | `fps != null` (Delete) | `if (!grid) return` | 구현 |
| BG06 | `fps.Name=="spdMain"` (Delete) | 화면에 그리드가 1개뿐 — 구조적 성립 | 구현(구조적) |
| BG07 | `ActiveRow == null` (Delete) | `if (!row) return` | 구현 |
| BG08 | `e.ColumnHeader` → return | Grid `ht.cellType !== CellType.Cell` | 구현 |
| BG09 | `RowCount == 0` → return | Grid `g.rows.length === 0` | 구현 |
| BG10 | `IsLock == true` → return | 모드 없음 — 신규행 조건(BG11)만 남는다 | 제외(§11) |
| BG11 | `GetText(insRow,0) != "I"` → return | Grid `isInsertRow(row)` | 구현 |
| BG12 | `e.Column == TR_MODE` 분기 | Grid `binding !== COLUMN.TR_MODE` | 구현 |
| BG13 | `DialogResult == OK` | Bod `handleSubmit`(OK 버튼)에서만 `setSelectedValue` | 구현 |
| BG14 | `retList.Count <= 0` → return | Bod `selections.length === 0` / Page `picked.length === 0` | 구현 |
| BG15 | `RowCount == 0` (ComboSelChange) | Grid `cellEditEnded` 는 행이 있어야 발화 — 구조적 성립 | 구현(구조적) |
| BG16 | `IsLock == true` (ComboSelChange) | 모드 없음 | 제외(§11) |
| BG17 | `GetText(e.Row,0) != "I"` | Grid `isInsertRow(row)` | 구현 |

## 9. popups (4) — §4e

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| PU01 | `ProgressForm` (조회) | react-query `isFetching` — 로딩 중 그리드 언마운트 금지 | 구현(공용) |
| PU02 | `ProgressForm` (저장) | `savingRef` 가드 + 공용 진행 표시 | 구현(공용) |
| PU03 | `SCM0002_ItembyDivisionPopup` | `ModelByDivisionPopup`(features/master, AS-IS 1:1 대응 명시) | 구현 |
| PU04 | `SCM0002_GetBODItemPrjRoutePopup` | Bod `BodItemRouteModal`(화면 로컬) | 미완(SP 미배포) |

> PU03 다중선택(R2): AS-IS `bMultiSelect=true` 인데 `ModelByDivisionPopup` 은 단일 선택 전용이다.
> `features/master` 수정은 Hard Boundary 밖이라 **이번 회차 미해결** — 업무 확인/분리 PR 대상(04 리포트).

## 10. 백본 밖 (G01~G21)

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| G01 | `GetSSPInnerTable("MyDivisionCMM")` | 콤보 `MyDivision` + `mnuId`. 클라 후처리 2건 중 **정렬(P2)은 FE 재현**, DISTINCT(P1)는 SQL `GROUP BY` 가 보장 | 구현 |
| G02 | `SetComBoParam` 셀 콤보 주입 | **메타 구동으로 전환**(iter-2) — Meta 6-3/6-4 가 FROM_SITE/TO_SITE=`PlantSiteByDivision`·FCST_TYPE=`FcstType` 를 등록하고 `@divisionId` 는 Grid `comboParams` 로 해소. 화면 DataMap 직접 주입은 제거(공용 `applyComboDataMaps` 가 덮어쓰므로 — G-02) | 구현 |
| G03 | 더미행 `CODE='-'` | **제외** — AS-IS 는 편집 가능한 셀 콤보에서 값을 비우기 위한 빈 행이다. TO-BE 는 컬럼메타 `INPUT_TP_CD='S'` 라 FROM_SITE/TO_SITE 가 애초에 편집 불가(표시 전용 코드→명 매핑)여서 더미 항목이 선택될 경로가 없다. 메타 단일 원천으로 옮기면서 함께 제거(iter-2) | 제외(구조적 무효) |
| G04 | 조회 사전 가드 2건 | Valid `validateSearch` **단일 지점** | 구현 |
| G05 | 저장 사전 가드 5건 | SaveHook `handleSave`(useShipmentRequestSemiSave.ts:130-): 행0 → **`*` 라벨 필수(`findMissingRequired`)** → **9키중복(`findDuplicateKey`)** → **변경0 toast** → `useSaveWithValidation`(메타 축, 이 화면에선 `INPUT_TP_CD` 전건 `'S'` 라 무발동 — 그래서 앞의 로컬 필수검증이 실질 게이트다). 순서가 AS-IS 계약이다: cs:867 행0 → cs:870 필수 → cs:873 중복 → (수집) → cs:1011-1014 변경0. iter-3 까지 변경0 이 중복보다 앞이어서 조회 결과의 기존 중복이 경고 없이 "변경 없음" 으로 빠졌다(N-06). `IsLock` 가드만 제외(§11) | 구현 |
| G06 | Division 권한 0건 화면 차단 | Form `noDivisionAuth` → 전 필드 disabled + `MSG00667` 1회 | 구현 |
| G07 | `AddSheet(...,3,1,35)` | 3단 헤더 = Cols 그룹 구성 / `headerRowHeight=16`(hook #93). 행높이 35 는 **미이식**(공용 규약) | 구현(수치 미이식) |
| G08 | `SetSearchCount` + 시간계측 | 건수 = `SubTitle dataCount`. 시간계측·`SetSaveLog` 는 **격차 G3 위임** | 제외(격차 G3) |
| G09 | `Set_SumValues` (BOH) | Cols `applyBohSumValues` — 바인딩 전 후처리(K14) | 구현 |
| G10 | `Set_MeasureColor` 3분기 | Grid `formatItem`: MEASURE_COLOR 배경 / `groupBoundary` / `FROZEN_PAST_BG` | 구현 |
| G11 | `SetLockSumColumn` Tag prefix | Lock `isSumBinding`(개방보다 먼저 평가) | 구현 |
| G12 | Bucket×Sum 매트릭스 | Cols `isPivotVisible` **1벌** | 구현 |
| G13 | `cellTypeImage` (TR_MODE edit.png) | Grid formatItem 이 신규행 TR_MODE 셀에 `styles.trModeEditable`(`::after` 연필 글리프 + pointer 커서)을 붙인다(iter-2). inline style 금지 규약대로 SCSS Module | 구현(자산 대체) |
| G14 | dead code 3건 | `usrButton1`/`InsertRow()`/`RetValue()` 전건 미이식 | 제외(dead) |
| G15 | `drpPeriod.Enabled=false` | Form F7 로컬 read-only(disabled) | 구현 |
| G16 | `usrConditionPanel1.Height=75` | px 미이식 — "2단 전제" 의미만 승계(필드 6개 초과분 `extraConditions`) | 제외(px 이식 금지) |
| G17 | Bucket 기본값 `DAILY` | Const `DEFAULT_BUCKET_TYPE` | 구현 |
| G18 | `bChgDiv` 지연로딩 플래그 | react-query 키 `(division, operationGroup)` 로 등가 재현 — 수동 플래그 불필요 | 구현(등가) |
| G19 | `ComboSelChange -= / +=` 재진입 차단 | 프로그램적 대입은 `cellEditEnded` 를 발화시키지 않아 재진입 구조가 없다 | 제외(구조적 부재) |
| G20 | Roslyn chain 오표기(EP06) | 분석 도구 산출물 오류 — 이식 대상 아님 | 제외(분석 오표기) |
| G21 | `FP_Log2` SpeedUp 계측 | **격차 G3 위임** — 화면이 개별 구현하지 않는다(Hard Boundary) | 제외(격차 G3) |
| G22 | `toolbarOverride` 에 Excel 항목 없음(cs:334-339) | Page `hotkeyConfig.excel = hasButton('EXCEL') ? undefined : false`. `SCM_ADM_MNU_BTN_MPG_M` 실측 5행(SEARCH×3시트/SAVE/DELETE)에 `EXCEL` 미등록 → 현재는 숨김. 키를 생략하면 공용 SubTitle 기본 액션이 살아 무조건 노출된다(admin 에서 끈 버튼이 남는 SCM0008 유형, CLAUDE.md §2 체크3) — convert-gap-resolve iter-1 N-07 | 구현 |

## 11. extractionLimits (L01 · L02)

| # | 한계 | 처리 | 상태 |
|---|---|---|---|
| L01 | intra-class 호출그래프(외부 참조 미해석) | 설계 3문서가 프레임워크/BIZ/WSL 본문 직접 read 로 G01·G02·G04·G05·G11 을 확정 → 그 결과를 이식 | 해소(설계 단계) |
| L02 | 서드파티 컨트롤 → React 매핑 범위 밖 | `nscm-patterns.md §4` 대응표대로 §1 controls 전건 매핑 | 해소 |

---

## 12. 대사

| 축 | 기준 | 본 문서 | 일치 |
|---|---:|---:|:--:|
| controls | 26 | 26 | O |
| events | 9 | 9 | O |
| validations | 9 | 9 | O |
| gridSignals | 63 | 48 + 15 = 63 | O |
| gridColumns | 2 | 2 | O |
| spCalls | 5 | 5 | O |
| comboCalls | 5 | 5 | O |
| entryPoints | 14 | 14 | O |
| buttonGuards | 17 | 17 | O |
| popups | 4 | 4 | O |
| **백본 합계** | **154** | **154** | O |
| 백본 밖 G | 21 | 21 | O |
| extractionLimits | 2 | 2 | O |

**공란 0.** iter-2 에서 C24 / S37 / S45 / G13 4건이 **미완 → 구현**으로 바뀌었다(react-gap-audit iter-1
G-05 / G-23 / G-24 해소). 남은 미완은 **SP 미배포 축 전건**(PU04 조회 · SP03/04/05 실행체인)뿐이며,
이는 `convert-sp` 소관이라 이 화면이 닫을 수 없다. 제외 전건의 사유는 본문에 명시했다.
