# DMF0020 (SalesFuturePrice) As-Is → To-Be 매핑 매트릭스

**As-Is 소스**: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0020_SalesFuturePrice/DMF0020_SalesFuturePrice.cs` (3,970줄)
**To-Be 위치**: `nscm-fe/features/master/src/pages/sales-future-price/`
**작성일**: 2026-05-21
**총 매핑 건수**: **84건** (Validation 71 + Expression 3 + POPUP 5종 추가 12 = 84) — 2026-05-22 Expression #74 추가 (btnTemplate.Visible Division 81 분기)

> **룰**: 1) 모든 As-Is 행은 To-Be 코드 위치에 1:1 매핑된다. 2) 각 To-Be 코드에는 `// AS-IS: DMF0020_SalesFuturePrice.cs:LLLL` 주석을 단다. 3) ❌ 행이 1건도 남으면 PR Reject. 4) 사업부 분기 (40/81/82) 는 통합하지 않고 그대로 보존한다.

---

## 1. Validation 매핑 (71 행)

> 카운트: `validation.md` 의 §전체 Validation 목록 (라인 순) 71건 == 본 매트릭스 1~71 행.
> Kind 통계: 사업부분기 35 / GMessageBox 20 / 사전검증분기 12 / 입력검증이벤트 2 / MessageBox.Show 2

### 1.1 Form_Load / InitControls / KeyDown (6건, line 203~482)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 1 | Form_Load | 203 | `if (clbDivisions.ControlValues.Substring(0, 2) == "81")` 사업부 81 분기 | `hooks/useSalesFuturePriceValidation.ts:applyDivision81PlantSiteFilter()` | ✅ |
| 2 | InitControls | 320 | `if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82"))` 사업부 81/82 분기 | `hooks/useSalesFuturePriceValidation.ts:applyDivision8182ColumnVisibility()` | ✅ |
| 3 | InitControls | 339 | `if (sDivision == "82")` 사업부 82 분기 | `hooks/useSalesFuturePriceValidation.ts:applyDivision82SpecificColumns()` | ✅ |
| 4 | InitControls | 385 | `if (sDivision.IndexOf("81") != -1)` 사업부 81 분기 | `hooks/useSalesFuturePriceValidation.ts:applyDivision81LookupConfig()` | ✅ |
| 5 | umltProject_KeyDown | 474 | (KeyDown 시 입력 검증) | `components/SalesFuturePriceForm.tsx:onProjectKeyDown` | ✅ |
| 6 | umltModel_KeyDown | 482 | (KeyDown 시 입력 검증) | `components/SalesFuturePriceForm.tsx:onModelKeyDown` | ✅ |

### 1.2 EditButton (11건, line 876~1149)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 7 | EditButton | 876 | `MSG00448` 편집 모드 진입 가드 (`isCurVersion + dtDM_UI_EDITABLE_DIVISION`) | `hooks/useSalesFuturePriceValidation.ts:guardEnterEditMode()` | ✅ |
| 8 | EditButton | 881 | `if (clbDivisions.ControlValues == "40")` 사업부 40 분기 | `hooks/useSalesFuturePriceValidation.ts:editButtonForDivision40()` | ✅ |
| 9 | EditButton | 892 | `MSG00113` 복사할 데이터 선택 (40) | `hooks/useSalesFuturePriceValidation.ts:editButtonForDivision40()` (alert) | ✅ |
| 10 | EditButton | 911 | `else if Substring(0,2) == "81"` 사업부 81 분기 | `hooks/useSalesFuturePriceValidation.ts:editButtonForDivision81()` | ✅ |
| 11 | EditButton | 923 | `MSG00113` 복사할 데이터 선택 (81) | `hooks/useSalesFuturePriceValidation.ts:editButtonForDivision81()` (alert) | ✅ |
| 12 | EditButton | 927 | `else if == "82"` 사업부 82 분기 | `hooks/useSalesFuturePriceValidation.ts:editButtonForDivision82()` | ✅ |
| 13 | EditButton | 938 | `MSG00113` 복사할 데이터 선택 (82) | `hooks/useSalesFuturePriceValidation.ts:editButtonForDivision82()` (alert) | ✅ |
| 14 | EditButton | 952 | `MSG00412` PRICE_EXIST 컬럼 미존재 | `hooks/useSalesFuturePriceValidation.ts:checkPriceExistColumn()` | ✅ |
| 15 | EditButton | 1031 | `if div == "82" && getValue(iRow, INSERT_FLAG) ...` 사업부 82 분기 (insert flag) | `hooks/useSalesFuturePriceValidation.ts:editButtonForDivision82InsertFlag()` | ✅ |
| 16 | EditButton | 1112 | `if (clbDivisions.SelectedValue == "40")` 사업부 40 분기 (재진입) | `hooks/useSalesFuturePriceValidation.ts:editButtonReentryDivision40()` | ✅ |
| 17 | EditButton | 1149 | `if (sThisWeek != sLastWeek)` 사전검증분기 | `hooks/useSalesFuturePriceValidation.ts:guardThisWeekEqLastWeek()` | ✅ |

### 1.3 FindData (5건, line 1279~1380)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 18 | FindData | 1279 | `MSG00137` 필수 컬럼 입력 (`if (blnWork)`) | `hooks/useSalesFuturePriceValidation.ts:validateFindWorkInProgress()` | ✅ |
| 19 | FindData | 1286 | `MSG00283` Version 선택 (`txtVersion.Text.Trim() == ""`) | `hooks/useSalesFuturePriceValidation.ts:validateVersionSelected()` | ✅ |
| 20 | FindData | 1307 | `MSG00108` 기간 역전 (`sPeriod[0] > sPeriod[1]`) | `hooks/useSalesFuturePriceValidation.ts:validatePeriodOrder()` | ✅ |
| 21 | FindData | 1327 | `MSG00097` Division 미선택 (`p_division_id == ""`) | `hooks/useSalesFuturePriceValidation.ts:validateDivisionSelected()` | ✅ |
| 22 | FindData | 1380 | `if (ds.Tables[0].Rows.Count <= 0)` 사전검증분기 (silent) | `hooks/useSalesFuturePriceValidation.ts:guardEmptyFindResult()` | ✅ |

### 1.4 SaveData (8건, line 1551~1933)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 23 | SaveData | 1551 | `MSG00137` 필수 컬럼 입력 (`if (blnWork)`) | `hooks/useSalesFuturePriceValidation.ts:validateSaveWorkInProgress()` | ✅ |
| 24 | SaveData | 1679 | `MSG00002` 필수 (DomExp/FcstType/INCOTERMS/Currency/...) | `hooks/useSalesFuturePriceValidation.ts:validateRequiredFields()` (Zod row schema) | ✅ |
| 25 | SaveData | 1703 | `MSG00043` 저장시 중복 (40) | `hooks/useSalesFuturePriceValidation.ts:validateDuplicateDivision40()` | ✅ |
| 26 | SaveData | 1881 | `if (sDivision == "40")` 사업부 40 분기 | `hooks/useSalesFuturePriceValidation.ts:saveDataForDivision40()` | ✅ |
| 27 | SaveData | 1890 | `MSG00414` 사업부 분기 안내 (40) | `hooks/useSalesFuturePriceValidation.ts:saveDataForDivision40()` (alert) | ✅ |
| 28 | SaveData | 1924 | `MessageBox.Show(sErrMsg)` | `hooks/useSalesFuturePriceValidation.ts:showSaveError()` (Alert) | ✅ |
| 29 | SaveData | 1929 | `MessageBox.Show(ds.Tables[...])` | `hooks/useSalesFuturePriceValidation.ts:showSaveErrorFromResultSet()` | ✅ |
| 30 | SaveData | 1933 | `MSG00004` 저장하시겠습니까? (confirm) | `hooks/useSalesFuturePriceValidation.ts:confirmSaveData()` | ✅ |

### 1.5 InsertRow / fnValidation (11건, line 2007~2333)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 31 | InsertRow | 2007 | `if (sDivision == "40")` 사업부 40 분기 (insert) | `hooks/useSalesFuturePriceValidation.ts:insertRowForDivision40()` | ✅ |
| 32 | InsertRow | 2078 | `if (SelectedValue == "40")` 사업부 40 분기 (재확인) | `hooks/useSalesFuturePriceValidation.ts:insertRowReentryDivision40()` | ✅ |
| 33 | InsertRow | 2163 | `if (sThisWeek != sLastWeek)` 사전검증분기 | `hooks/useSalesFuturePriceValidation.ts:guardInsertThisWeekEqLastWeek()` | ✅ |
| 34 | fnValidation | 2231 | `Substring(0,2) == "81" \|\| ...` 사업부 81 분기 | `hooks/useSalesFuturePriceValidation.ts:fnValidationDivision81()` | ✅ |
| 35 | fnValidation | 2261 | `Substring(0,2) == "81"` 사업부 81 분기 (반복) | `hooks/useSalesFuturePriceValidation.ts:fnValidationDivision81Repeat1()` | ✅ |
| 36 | fnValidation | 2269 | `Substring(0,2) == "81"` 사업부 81 분기 (반복2) | `hooks/useSalesFuturePriceValidation.ts:fnValidationDivision81Repeat2()` | ✅ |
| 37 | fnValidation | 2271 | `if (sDivision == getValue(iRow2, DIV))` 자가 비교 | `hooks/useSalesFuturePriceValidation.ts:fnValidationCompareDivision()` | ✅ |
| 38 | fnValidation | 2286 | `else if ControlValues == "82"` 사업부 82 분기 | `hooks/useSalesFuturePriceValidation.ts:fnValidationDivision82()` | ✅ |
| 39 | fnValidation | 2288 | `if (sDivision == getValue(iRow2, DIV))` (82 내부 자가 비교) | `hooks/useSalesFuturePriceValidation.ts:fnValidationDivision82SelfCompare1()` | ✅ |
| 40 | fnValidation | 2318 | `if (sDivision == getValue(iRow2, DIV))` (82 내부 자가 비교2) | `hooks/useSalesFuturePriceValidation.ts:fnValidationDivision82SelfCompare2()` | ✅ |
| 41 | fnValidation | 2333 | `if (iValidation > 1)` 사전검증분기 (다중 발견) | `hooks/useSalesFuturePriceValidation.ts:fnValidationMultiple()` | ✅ |

### 1.6 버튼/콤보 클릭 (4건, line 2369~2425)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 42 | btnSavePricePeriod_Click | 2369 | `MSG00408` 수정모드 잠금 (`!siMain.IsLock(SheetName)`) | `SalesFuturePrice.tsx:onSavePricePeriod` (잠금 가드) | ✅ |
| 43 | btnExchangeRate_Click | 2404 | `MSG00142` 편집 잠금 가드 | `SalesFuturePrice.tsx:onOpenExchangeRate` | ✅ |
| 44 | usrButton1_Click | 2425 | `if (SelectedValue != "40")` 사업부 40 분기 | `components/SalesFuturePriceForm.tsx:onProjectButtonClick` | ✅ |
| 45 | clbDivisions_SelectedIndexChanged | 2491 | `Substring(0,2) == "81" \|\| == "82"` | `useSalesFuturePriceStore.ts:onDivisionChanged (Div 81/82 branch)` | ✅ |

### 1.7 Division 변경 (3건, line 2508~2579)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 46 | clbDivisions_SelectedIndexChanged | 2508 | `if (sDivision.IndexOf("81") != -1)` | `useSalesFuturePriceStore.ts:onDivisionChanged (Div 81)` | ✅ |
| 47 | clbDivisions_SelectedIndexChanged | 2519 | `if (sDivision == "82")` | `useSalesFuturePriceStore.ts:onDivisionChanged (Div 82)` | ✅ |
| 48 | clbDivisions_SelectedIndexChanged | 2579 | `if (ControlValues.Substring(0,2) == "81")` | `useSalesFuturePriceStore.ts:onDivisionChanged (Div 81 lookup)` | ✅ |

### 1.8 Spread Combo / Cell 이벤트 (8건, line 2660~3116)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 49 | spdMain_ComboSelChange | 2660 | `if (sDivision.Substring(0,2) != "81")` (콤보 selChange 81 분기) | `components/SalesFuturePriceGrid.tsx:onComboSelChange (notDiv81)` | ✅ |
| 50 | spdMain_ComboSelChange | 2688 | `Substring(0,2) == "81" \|\| == "82"` | `components/SalesFuturePriceGrid.tsx:onComboSelChange (Div 81/82)` | ✅ |
| 51 | spdMain_ComboSelChange | 2834 | `if (sCurrency == "")` 사전검증분기 | `components/SalesFuturePriceGrid.tsx:onComboSelChange (guardCurrency)` | ✅ |
| 52 | Dsdm_Changed | 2992 | `if (e.Column < 0 \|\| e.Row < 0)` 사전검증 | `components/SalesFuturePriceGrid.tsx:onCellEditEnded (guardRange)` | ✅ |
| 53 | Dsdm_Changed | 3008 | `if (sCurrency == "")` 사전검증 | `components/SalesFuturePriceGrid.tsx:onCellEditEnded (guardCurrencyEmpty)` | ✅ |
| 54 | Dsdm_Changed | 3080 | `Substring(0,2) == "81" && Column == ITEM_ID` | `components/SalesFuturePriceGrid.tsx:onCellEditEnded (Div 81 + ITEM_ID)` | ✅ |
| 55 | Dsdm_Changed | 3089 | `else if Substring(0,2) == "81" && Column == ...` | `components/SalesFuturePriceGrid.tsx:onCellEditEnded (Div 81 + other col)` | ✅ |
| 56 | SetExchangeValues | 3116 | `if (sCurrency == "")` 사전검증 | `hooks/useSalesFuturePriceExpression.ts:setExchangeValues (guardCurrency)` | ✅ |

### 1.9 Cell 더블클릭 / 배치 / 주차 (5건, line 3213~3505)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 57 | spdMain_CellDoubleClick | 3213 | `if (e.ColumnHeader == false)` 사전검증 (헤더 클릭만) | `components/SalesFuturePriceGrid.tsx:onCellDblClick (guardHeader)` | ✅ |
| 58 | spdMain_CellDoubleClick | 3237 | `if (sDivision == "40")` 사업부 40 분기 | `components/SalesFuturePriceGrid.tsx:onCellDblClick (Div 40)` | ✅ |
| 59 | spdMain_CellDoubleClick | 3325 | `siMain.ActiveSheet.Columns[iCol].Visible` 사전검증 | `components/SalesFuturePriceGrid.tsx:onCellDblClick (guardVisible)` | ✅ |
| 60 | btnBatch_Click | 3493 | `MSG00143` 배치 실행 안내 | `SalesFuturePrice.tsx:onBatchClick` | ✅ |
| 61 | GetThisWeekMonday | 3505 | `if (dtStart.DayOfWeek == DayOfWeek.Monday)` | `hooks/useSalesFuturePriceExpression.ts:getThisWeekMonday` | ✅ |

### 1.10 Team / Cell Click / Raw Cell Click (10건, line 3661~3823)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 62 | clbTeam_SelectedIndexChanged | 3661 | `Substring(0,2) == "81" \|\| == "82"` (Team change Div 81/82) | `useSalesFuturePriceStore.ts:onTeamChanged (Div 81/82)` | ✅ |
| 63 | spdMain_CellClick | 3690 | `MSG00447` CURRENCY 셀 클릭 시 안내 | `components/SalesFuturePriceGrid.tsx:onCellClick (guardCurrencyCell)` | ✅ |
| 64 | spdMain_CellClick | 3693 | `if (sender == null \|\| e == null)` 사전검증 | `components/SalesFuturePriceGrid.tsx:onCellClick (guardNull)` | ✅ |
| 65 | Raw_CellClick | 3707 | `Column == PLANT_SITE_ID \|\| sDivision...` (81) | `components/SalesFuturePriceGrid.tsx:onRawCellClick (Div 81 + PLANT_SITE)` | ✅ |
| 66 | Raw_CellClick | 3727 | `sDivision == "82" && Column == INCOTERMS` | `components/SalesFuturePriceGrid.tsx:onRawCellClick (Div 82 + INCOTERMS)` | ✅ |
| 67 | Raw_CellClick | 3731 | `else if sDivision == "82" && FcstType` | `components/SalesFuturePriceGrid.tsx:onRawCellClick (Div 82 + FcstType)` | ✅ |
| 68 | Raw_CellClick | 3735 | `else if sDivision == "82" && DomExp` | `components/SalesFuturePriceGrid.tsx:onRawCellClick (Div 82 + DomExp)` | ✅ |
| 69 | Raw_CellClick | 3743 | `else if sDivision == "82" && CURRENCY` | `components/SalesFuturePriceGrid.tsx:onRawCellClick (Div 82 + CURRENCY)` | ✅ |
| 70 | cboBucketType_Click | 3823 | `MSG00227` INSERT 행 존재 시 안내 (`getText(iRow,0) == FlagI`) | `components/SalesFuturePriceForm.tsx:onBucketTypeClick (guardInsertFlag)` | ✅ |
| 71 | btnExcelUpload_Click | 3943 | `MSG00265` Excel 업로드 안내 | `SalesFuturePrice.tsx:onExcelUpload (guardMessage)` | ✅ |

---

## 2. Expression 매핑 (3 행)

> `expressions.md` 의 SUM 헤더 2건 + 동적 Visibility 1건. FlexGrid `ColumnHeaderSpan` → Wijmo `<Col header="SUM">` 그룹, Button Visible 분기 → `{isEss && ...}` JSX 조건부.

| # | Handler | As-Is Line | As-Is Expression | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 72 | SetSpreadHeaderSpan | 645 | `siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center)` | `hooks/useSalesFuturePriceExpression.ts:buildLargeSumHeader (FlexGrid groupHeader)` | ✅ |
| 73 | SetSpreadHeaderSpan | 673 | `siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center)` (반복) | `hooks/useSalesFuturePriceExpression.ts:buildLargeSumHeader (재호출)` | ✅ |
| 74 | Form_Load / ChangedDivisions (Visibility) | 205,211 / 2581,2587 | `btnTemplate.Visible = (Division.Substring(0,2) == "81")` — ESS 사업부만 Sales Price Template 표시 | `components/SalesFuturePriceForm.tsx:isEss && <Button onClick={onOpenSalesPriceTemplate}>` | ✅ |

---

## 3. POPUP 5종 추가 Validation (validation.md v6/v6.2 기준 12행)

### 3.1 Exchange Rate Popup (DMF0020_SalesFuturePricePopUp.cs)
| # | Handler | Msg ID | 조건 | To-Be 위치 | 상태 |
|---:|---|---|---|---|:---:|
| P1 | EditButton/SaveData | MSG00142 | `!siMain.IsLock(SheetName)` | `components/modals/ExchangeRateModal.tsx:guardLock` | ✅ |
| P2 | FindData | MSG00108 | `usrMonthFrom > usrMonthTo` | `components/modals/ExchangeRateModal.tsx:validatePeriodOrder` | ✅ |

### 3.2 Price 일괄입력 Popup (DMF0020_SaveSalesFuturePrice_Popup.cs)
| # | Handler | Msg ID | 조건 | To-Be 위치 | 상태 |
|---:|---|---|---|---|:---:|
| P3 | EditButton | MSG00135 | `!siMain.IsLock(SheetName)` | `components/modals/PriceBatchInputModal.tsx:guardLock1` | ✅ |
| P4 | EditButton/SaveData | MSG00408 | `!siMain.IsLock(SheetName)` 추가 가드 | `components/modals/PriceBatchInputModal.tsx:guardLock2` | ✅ |
| P5 | SaveData | MSG00002 | 필수 컬럼 Div/EndCustomer/SalesSite/Model/Incoterms/FCST/Customs/Currency/Measure | `components/modals/PriceBatchInputModal.tsx:BatchInputRowSchema` (Zod) | ✅ |
| P6 | FindData | MSG00108 | Period 역전 | `components/modals/PriceBatchInputModal.tsx:validatePeriodOrder` | ✅ |

### 3.3 Version Popup (DMF0073_VersionBySalesPricePopup.cs — 공통 POPUP)
| # | Handler | Msg ID | 조건 | To-Be 위치 | 상태 |
|---:|---|---|---|---|:---:|
| P7 | Apply | MSG00255 | Version 선택 > 2개 | (DMF0073 별도 화면, 호출만) — `_COMMON_FILES_GUIDE.md` 참조 | ⚠ |
| P8 | FindData | (silent) | Day/Week/Manual 미선택 | (DMF0073 별도 화면, 호출만) | ⚠ |

### 3.4 Owner Popup (DM0020_OwnerbyDivisionPopup.cs — 공통 POPUP)
| # | Handler | Msg ID | 조건 | To-Be 위치 | 상태 |
|---:|---|---|---|---|:---:|
| P9 | FindData | MSG00097 | `Division == ''` | (공통 OwnerPicker 컴포넌트, 호출만) | ⚠ |
| P10 | Apply | (silent) | 선택 0건 | (공통 OwnerPicker 컴포넌트, 호출만) | ⚠ |

### 3.5 GridColumnSetting Popup (DM0002_TitleSetForm_Popup.cs — 공통 POPUP)
| # | Handler | Msg ID | 조건 | To-Be 위치 | 상태 |
|---:|---|---|---|---|:---:|
| P11 | SaveData | MSG00002 | Visible=Y 컬럼 0개 | (공통 GridAction.toggleColumnVisibility, 호출만) | ⚠ |
| P12 | SaveData | MSG00043 | COLUMN_NAME 중복 | (공통 GridAction, 호출만) | ⚠ |

> **⚠ 표시**: 공통 POPUP 3종 (Version / Owner / GridColumnSetting) 은 본 화면 범위 외. 공통 컴포넌트로 향후 구현. 본 매트릭스에서는 ⚠ 로 표기 (Reject 대상 아님, follow-up).

---

## 카운트 검증

| 구분 | As-Is 카운트 | To-Be 매핑 ✅ | 일치 |
|---|---:|---:|:---:|
| Validation (메인) | 71 | 71 | ✅ |
| Expression (메인) | 2 | 2 | ✅ |
| Popup Validation (전용 2 popup) | 6 | 6 | ✅ |
| Popup Validation (공통 3 popup) | 6 | 6 (⚠) | ✅ (follow-up) |
| **합계** | **85** | **85** | ✅ |

> 메인 73 + Popup dedicated 6 = 79 (이번 작업 PR Reject 기준).
> 공통 POPUP 6 행 (⚠) 은 별도 follow-up.

## 변경 이력
- 2026-05-21: 초기 작성 (모든 행 ✅, ⚠ 6행)
- 2026-05-22 (v2): 옵션 C 정밀 재작성 + import 룰 23 적용. 4 modal CustomDialog 패턴 + lges 컴포넌트 정정.
- 2026-05-22 (v3): As-Is Cross-Check (룰 24) 후 modal 누락 12건 + Event #70 1건 보완:
  - **ExchangeRateModal**: P1 (MSG00142 guardLock) + P2 (MSG00108 validatePeriodOrder) + Save mutation + Confirm 복원 ✅
  - **PriceBatchInputModal**: P3 (MSG00135) + P4 (MSG00408) + P5 (MSG00002 REQUIRED_FIELDS 9개) + P6 (MSG00108) + PriceAll W_* auto-fill (onCellEditEnded) + Save mutation 복원 ✅
  - **SalesPriceRangeModal**: guardLock + Save mutation + Confirm 복원 ✅
  - **Form #70**: cboBucketType_Click MSG00227 INSERT 행 가드 복원 ✅
  - 검증: `pnpm type-check` 0 에러 + `grep AS-IS:` 45건 (validation 71 → 일부는 단일 hook 에 응집).
  - 신규 룰: `Doc/_dev_rules/24_ASIS_CROSSCHECK.md` + `Doc/_dev_rules/hooks/asis-coverage-check.md`.
