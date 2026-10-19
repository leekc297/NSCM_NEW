# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Division / LayoutControlItem | ProductionPlanWaterfallForm.tsx:188-194 (single Division*, setDivision) |  | 구현 |
| D00-1-002 | §1 btnColumn / UsrButton | ProductionPlanWaterfall.tsx:269-276 (customButtons Column Set → ColumnLayoutModal) |  | 구현 |
| D00-1-003 | §1 btnItemId / UsrButton | ProductionPlanWaterfallForm.tsx:249-253 (Model 팝업 FunctionSearchIcon onModelSearch) |  | 구현 |
| D00-1-004 | §1 btnMeasure / UsrButton | ProductionPlanWaterfall.tsx:277-283 (customButtons Measure → MeasureSelectModal) |  | 구현 |
| D00-1-005 | §1 cboBucketType / UsrCombo | ProductionPlanWaterfallForm.tsx:226-228 (single Bucket, COMBO.BUCKET) |  | 구현 |
| D00-1-006 | §1 cboDivision / UsrCombo | ProductionPlanWaterfallForm.tsx:188-194 (single Division*, COMBO.DIVISION) |  | 구현 |
| D00-1-007 | §1 cboElectrode / UsrCheckedList | ProductionPlanWaterfallForm.tsx:214-220 (multi Electrode, lookup, disabled=!isEe) |  | 구현 |
| D00-1-008 | §1 cboOperationGroup / UsrCombo | ProductionPlanWaterfallForm.tsx:195-201 (single Operation Group*) |  | 구현 |
| D00-1-009 | §1 chkALL / UsrCheckBox | ProductionPlanWaterfallForm.tsx:289-293 (Checkbox All → setChkAll) |  | 구현 |
| D00-1-010 | §1 chkGap / UsrCheckBox | ProductionPlanWaterfallForm.tsx:283-287 (Checkbox Gap) |  | 구현 |
| D00-1-011 | §1 chkSum / UsrCheckBox | ProductionPlanWaterfallForm.tsx:294-298 (Checkbox Sum) |  | 구현 |
| D00-1-012 | §1 clbLine / UsrCheckedList2 | ProductionPlanWaterfallForm.tsx:205-207 (multi Line, '-' sentinel 제외 81) |  | 구현 |
| D00-1-013 | §1 clbPlantSite / UsrCheckedList | ProductionPlanWaterfallForm.tsx:202-204 (multi Plant Site) |  | 구현 |
| D00-1-014 | §1 clbVersion / UsrCheckedList | ProductionPlanWaterfallForm.tsx:210-212 (multi Version, setVersions) |  | 구현 |
| D00-1-015 | §1 components / System.ComponentModel.Container |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-016 | §1 dCalendar / UsrDateRangePicker3 | ProductionPlanWaterfallForm.tsx:229-235 (PeriodField from/to) |  | 구현 |
| D00-1-017 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem2 / EmptySpaceItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-019 | §1 emptySpaceItem3 / EmptySpaceItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-020 | §1 layoutControlGroup2 / LayoutControlGroup |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-021 | §1 layoutControlItem1 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-022 | §1 layoutControlItem10 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-023 | §1 layoutControlItem11 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-024 | §1 layoutControlItem12 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-025 | §1 layoutControlItem13 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-026 | §1 layoutControlItem14 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-027 | §1 layoutControlItem2 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-028 | §1 layoutControlItem3 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-029 | §1 layoutControlItem4 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-030 | §1 layoutControlItem5 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-031 | §1 layoutControlItem6 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-032 | §1 layoutControlItem7 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-033 | §1 layoutControlItem9 / LayoutControlItem |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-034 | §1 lblBucket1 / LayoutControlItem |  | WinForms 레이아웃 프리미티브(라벨) — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-035 | §1 lblItemId / LayoutControlItem |  | WinForms 레이아웃 프리미티브(라벨) — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-036 | §1 spdMain / FpSpread | ProductionPlanWaterfallGrid.tsx:315-329 (DataGrid), ProductionPlanWaterfall.tsx:288-293 |  | 구현 |
| D00-1-037 | §1 spdMain_Sheet1 / SheetView |  | WinForms 레이아웃 프리미티브(SheetView) — React DataGrid 단일 시트로 대체 | 해당없음 |
| D00-1-038 | §1 txtItemId / UsrMultiLineEditor | ProductionPlanWaterfallForm.tsx:242-258 (InputField Model, sc.modelId) |  | 구현 |
| D00-1-039 | §1 txtNickName / TextBox | ProductionPlanWaterfallForm.tsx:268-274 (InputField Nick Name, sc.nickName) |  | 구현 |
| D00-1-040 | §1 usrButton1 / UsrButton |  | AS-IS dead control(Designer 33, 미노출) — 미이식(§1 usrButton1 dead control 소거) | 제외 |
| D00-1-041 | §1 usrConditionPanel1 / UsrConditionPanel |  | WinForms 레이아웃 프리미티브(조회영역 패널) — SearchArea 컴포넌트로 대체 | 해당없음 |
| D00-1-042 | §1 usrLayoutControl2 / UsrLayoutControl |  | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-2-001 | §2 btnColumn / Click | ProductionPlanWaterfall.tsx:273 (action setOpenColumnSetting), :185-210 handleSaveColumnLayout |  | 구현 |
| D00-2-002 | §2 btnItemId / Click | ProductionPlanWaterfallForm.tsx:252 (onClick onModelSearch), ProductionPlanWaterfall.tsx:297-305 ItemByDivisionModal |  | 구현 |
| D00-2-003 | §2 btnMeasure / Click | ProductionPlanWaterfall.tsx:280 (action setOpenMeasureSelect), :214-233 handleApplyMeasures |  | 구현 |
| D00-2-004 | §2 cboBucketType / SelectedIndexChanged | ProductionPlanWaterfallForm.tsx:226-228 (onPick set bucket) → baseVisibleOf 재적용(ProductionPlanWaterfallGrid.tsx:131-167) |  | 구현 |
| D00-2-005 | §2 cboDivision / SelectedIndexChanged | useProductionPlanWaterfallStore.ts:144-159 (setDivision — cascade 초기화 + filters clear) |  | 구현 |
| D00-2-006 | §2 cboOperationGroup / SelectedIndexChanged | ProductionPlanWaterfallForm.tsx:199 (set operationGroupId) → plantSite/line 콤보 파라미터 재조회(ProductionPlanWaterfallForm.tsx:64-70) |  | 구현 |
| D00-2-007 | §2 chkALL / CheckedChanged | useProductionPlanWaterfallStore.ts:174-178 (setChkAll — filters clear/ClearDataSource 재현). 헤더 재구성 bool 효과는 잔여 G1(§7) |  | 구현 |
| D00-2-008 | §2 chkSum / CheckedChanged | ProductionPlanWaterfallForm.tsx:294-298 (set chkSum) → baseVisibleOf W_/M_ 합계 토글(waterfall.periods.ts:69-78, ProductionPlanWaterfallGrid.tsx:146) |  | 구현 |
| D00-2-009 | §2 clbVersion / SelectedIndexChanged | useProductionPlanWaterfallStore.ts:162-171 (setVersions → periodFromVersion Period 재산정, :85-92) |  | 구현 |
| D00-2-010 | §2 spdMain / CellDoubleClick | ProductionPlanWaterfallGrid.tsx:226-250 (헤더 더블클릭 드릴다운 R14) |  | 구현 |
| D00-2-011 | §2 spdMain / TopChange | ProductionPlanWaterfallGrid.tsx:210-222 (scrollPositionChanged → invalidate 세로병합 재계산) |  | 구현 |
| D00-3-001 | §3 SmartColMerge / () | waterfall.merge.ts:56-76 (데이터셀 좌측 계층 세로병합) + ProductionPlanWaterfallGrid.tsx:202-207 (mergeManager 배선) |  | 구현 |
| D00-3-002 | §3 SmartColMerge / () | waterfall.merge.ts:78-107 (헤더 스팬 병합) + ProductionPlanWaterfallGrid.tsx:202-207 |  | 구현 |
| D00-3-003 | §3 Visible= / ORIGIN_DIVISION_ID = false | waterfall.columns.ts:116-118 (isEeOnly && !isEe → visible/display=false), constants EE_ONLY_COLUMNS:103 |  | 구현 |
| D00-3-004 | §3 Visible= / ELECTRODE_TYPE = false | waterfall.columns.ts:116-118 (isEeOnly && !isEe → false), constants EE_ONLY_COLUMNS:103 |  | 구현 |
| D00-3-005 | §3 Visible= / ORIGIN_DIVISION_ID = true | waterfall.columns.ts:116-118 (EE division 이면 메타 visible 유지) |  | 구현 |
| D00-3-006 | §3 Visible= / ELECTRODE_TYPE = true | waterfall.columns.ts:116-118 (EE division 이면 메타 visible 유지) |  | 구현 |
| D00-3-007 | §3 SetReNumerCellType / GetColumnIndex(cCOLUMN_NAME), -9999999999, 0 | waterfall.columns.ts:170,187-201 (dynamicColumns numeric format=`#,##0`, align right) |  | 구현 |
| D00-3-008 | §3 ColumnHeaderSpan / (0, iSmallStartCol+i, cMMDD_LABEL_NAME) | waterfall.columns.ts:189-190 (3단 leaf=일자 라벨) |  | 구현 |
| D00-3-009 | §3 ColumnHeaderSpan / (1, iSmallStartCol+i, cCOLUMN_LABEL_NAME) | waterfall.columns.ts:213-217 (2단 주차 그룹 header) |  | 구현 |
| D00-3-010 | §3 ColumnHeaderSpan / (2, iSmallStartCol+i, "SUM") | waterfall.columns.ts:181,190 (합계 컬럼 leaf/subKey='SUM') |  | 구현 |
| D00-3-011 | §3 ForeColor= / 헤더 토요일=Blue / 그외=Red | ProductionPlanWaterfallGrid.tsx:262-273 (formatItem DAY_CODE SAT/SUN), constants HEADER_COLORS:121-124 |  | 구현 |
| D00-3-012 | §3 ColumnHeaderSpan / (0, iLargeStartCol, sLargeSpanName) | waterfall.columns.ts:207-209 (1단 월 그룹 header) + waterfall.merge.ts:96-106 (월키 가로병합) |  | 구현 |
| D00-3-013 | §3 ColumnHeaderSpan / (1, iLargeStartCol, "SUM") | waterfall.columns.ts:181 (월 rank0 subKey='SUM') + waterfall.merge.ts:87-91 (월합계 세로병합) |  | 구현 |
| D00-3-014 | §3 ColumnHeaderSpan / (1, iSmallStartCol, sSmallSpanName) | waterfall.columns.ts:213-217 (2단 header) + waterfall.merge.ts:96-106 (주차키 가로병합) |  | 구현 |
| D00-3-015 | §3 ColumnHeaderSpan / (2, iSmallStartCol, "SUM") | waterfall.columns.ts:190 (합계 leaf='SUM') |  | 구현 |
| D00-3-016 | §3 ColumnHeaderSpan / (1, iSmallStartCol, sSmallSpanName) | waterfall.columns.ts:213-217 (2단 header) + waterfall.merge.ts:96-106 |  | 구현 |
| D00-3-017 | §3 ColumnHeaderSpan / (2, iSmallStartCol, "SUM") | waterfall.columns.ts:190 (합계 leaf='SUM') |  | 구현 |
| D00-3-018 | §3 ColumnHeaderSpan / (1, iSmallStartCol, sSmallSpanName) | waterfall.columns.ts:213-217 (2단 header) + waterfall.merge.ts:96-106 |  | 구현 |
| D00-3-019 | §3 ColumnHeaderSpan / (2, iSmallStartCol, "SUM") | waterfall.columns.ts:190 (합계 leaf='SUM') |  | 구현 |
| D00-3-020 | §3 ColumnHeaderSpan / (0, iLargeStartCol, sLargeSpanName) | waterfall.columns.ts:207-209 (1단 월 그룹) + waterfall.merge.ts:96-106 (월키 가로병합) |  | 구현 |
| D00-3-021 | §3 ColumnHeaderSpan / (1, iLargeStartCol, "SUM") | waterfall.columns.ts:181 (월 subKey='SUM') + waterfall.merge.ts:87-91 (세로병합) |  | 구현 |
| D00-3-022 | §3 SmartColMerge / () | waterfall.merge.ts:56-76 (세로병합) + ProductionPlanWaterfallGrid.tsx:202-207 |  | 구현 |
| D00-3-023 | §3 SmartColMerge / () | waterfall.merge.ts:56-76 (세로병합) + ProductionPlanWaterfallGrid.tsx:202-207 |  | 구현 |
| D00-3-024 | §3 ColumnHeaderHeight / (0, 20) | ProductionPlanWaterfallGrid.tsx:169-199 (HEADER_TOTAL_HEIGHT 48/tier 강제) |  | 구현 |
| D00-3-025 | §3 Visible= / Columns[iCol] = true | waterfall.periods.ts:61-78 (baseVisibleOf) + ProductionPlanWaterfallGrid.tsx:139-158 (applyDynVisibility) |  | 구현 |
| D00-3-026 | §3 Visible= / Columns[iCol] = chkSum.Checked | waterfall.periods.ts:73,77 (M_ 합계=chkSum) + ProductionPlanWaterfallGrid.tsx:146 |  | 구현 |
| D00-3-027 | §3 Visible= / Columns[iCol] = false | waterfall.periods.ts:67-72 (bucket 별 숨김 분기) + ProductionPlanWaterfallGrid.tsx:139-158 |  | 구현 |
| D00-3-028 | §3 Visible= / Columns[iCol] = true | waterfall.periods.ts:69-76 (D_/W_ 표시) + ProductionPlanWaterfallGrid.tsx:139-158 |  | 구현 |
| D00-3-029 | §3 Visible= / Columns[iCol] = chkSum.Checked | waterfall.periods.ts:73,77 (chkSum 토글) + ProductionPlanWaterfallGrid.tsx:146 |  | 구현 |
| D00-3-030 | §3 Visible= / Columns[iCol] = isWeeklyISO | waterfall.periods.ts:68 (WEEKLY_ISO: kind==='W' && isIso) + isIsoWeek:21 |  | 구현 |
| D00-3-031 | §3 Visible= / Columns[iCol] = false | waterfall.periods.ts:67-72 (bucket 미해당 숨김) + ProductionPlanWaterfallGrid.tsx:139-158 |  | 구현 |
| D00-3-032 | §3 Visible= / Columns[iCol] = true | waterfall.periods.ts:74-77 (DAILY 표시) + ProductionPlanWaterfallGrid.tsx:139-158 |  | 구현 |
| D00-3-033 | §3 LockRange / (0, iCol, RowCount-1, iCol, true) | ProductionPlanWaterfallGrid.tsx:319 (isReadOnly), 메타 INPUT_TP_CD=S 위임(hook #130 상수 이식 금지) |  | 구현 |
| D00-3-034 | §3 Query / (dsBinding) | ProductionPlanWaterfall.tsx:86-93 (useTabProcQuery MAIN → o_rc1 rows) |  | 구현 |
| D00-3-035 | §3 LockColumn / (0, GetMaxColumnIndex(), true) 전체 잠금(읽기전용) | ProductionPlanWaterfallGrid.tsx:319 (isReadOnly=true), INPUT_TP_CD=S 메타 위임 |  | 구현 |
| D00-3-036 | §3 SmartColMerge / () | waterfall.merge.ts:56-76 (조회후 세로병합) + ProductionPlanWaterfallGrid.tsx:202-207 |  | 구현 |
| D00-3-037 | §3 SetActiveCell / (nSelRowOfMain, nSelColOfMain) 선택복원 |  | 재조회 후 선택셀 복원(R10) 미배선 — UX 편의 후속 결정(G9, 04 §④ / §7 잔여). 데이터/회귀 무관 저위험 | 제외 |
| D00-3-038 | §3 ShowCell / 선택셀 스크롤 이동 |  | 선택셀 중앙 스크롤(R10) 미배선 — 선택복원(D00-3-037)과 동일 UX 후속 결정(G9) | 제외 |
| D00-3-039 | §3 SetBGColor2 / 회색(234,234,234) 배경 | ProductionPlanWaterfallGrid.tsx:277-287 (formatItem 과거실적 음영 R11), constants PAST_ACTUAL_BG:127 |  | 구현 |
| D00-3-040 | §3 Query / (dsBinding) Line 그리드 바인딩 |  | LINE 시트 = AS-IS 미구동(spdLine/FindData_Line 전량 주석) — 미구현 재현(파리티, design 03 §6-2). §4 명시 | 해당없음 |
| D00-3-041 | §3 LockColumn / (0, GetMaxColumnIndex(), true) 전체 잠금 |  | LINE 시트 미구동(AS-IS 파리티) — MODEL 시트만 구동 | 해당없음 |
| D00-3-042 | §3 SmartColMerge / () |  | LINE 시트 병합 = AS-IS 미구동(spdLine 주석) — 미구현 재현(파리티) | 해당없음 |
| D00-3-043 | §3 SetDecimal / (i, nIdxStart, i, nIdxEnd, 2, true) 소수2자리 |  | siLine 소수처리 — LINE 시트 미구동(AS-IS 파리티) | 해당없음 |
| D00-3-044 | §3 SetActiveCell / (nSelRowOfLine, nSelColOfLine) |  | siLine 선택복원 — LINE 시트 미구동(AS-IS 파리티) | 해당없음 |
| D00-3-045 | §3 GetViewRowFromModelRow / (i) 뷰행 매핑 | ProductionPlanWaterfallGrid.tsx:315-322 (DataGrid CollectionView 뷰행 위임) |  | 구현 |
| D00-3-046 | §3 SetDecimal / (viewRow, nIdxStart..nIdxEnd, 2, true) | ProductionPlanWaterfallGrid.tsx:288-298 (행별 NOTATION formatItem), constants formatByNotation:143-158 |  | 구현 |
| D00-3-047 | §3 SetValue / 주합계/주일수 = weekSum/nCntDayOfWeek |  | R15 주/월 합계는 SP 서버계산 반환 → FE 표시만(design 03 §3.1). FE 재계산 없음, EOH 보정은 PKG 배포 후(§7 R15) | 해당없음 |
| D00-3-048 | §3 SetValue / 월합계/월일수 = monthSum/nCntDayOfMonth |  | R15 월합계 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-049 | §3 SetValue / 월컬럼 = 전일값 파생 |  | R15 전일값 파생 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-050 | §3 SetValue / 주컬럼 = 전일값 파생 |  | R15 전일값 파생 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-051 | §3 SetValue / 주컬럼 = 전일값 파생 |  | R15 전일값 파생 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-052 | §3 SetValue / 월컬럼 = 전일값 파생 |  | R15 전일값 파생 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-053 | §3 SetValue / 주컬럼_D = weekSum_D |  | R15 주합계_D SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-054 | §3 SetValue / 월컬럼_D = monthSum_D |  | R15 월합계_D SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-055 | §3 SetDblClickColumnShowHide / (sender, e) 더블클릭 컬럼 show/hide | ProductionPlanWaterfallGrid.tsx:226-250 (헤더 더블클릭 드릴 하위 rank 토글 R14) |  | 구현 |
| D00-4b-001 | §4b Data_SCP.Common / MyDivisionInEE / dtMyDivision | ProductionPlanWaterfallForm.tsx:63 (COMBO.DIVISION+mnuId), constants COMBO.DIVISION='MyDivisionInEE_SCP':46 |  | 구현 |
| D00-4b-002 | §4b Data.Common / LookupCommon / dtElectrodeType | ProductionPlanWaterfallForm.tsx:75 (useTabLookupQueries ELECTRODE_LOOKUP), constants ELECTRODE_LOOKUP:57 |  | 구현 |
| D00-4b-003 | §4b Data_SCP.Common / BucketISO / dt | ProductionPlanWaterfallForm.tsx:72 (COMBO.BUCKET), constants COMBO.BUCKET='BucketISO_SCP':54 |  | 구현 |
| D00-4b-004 | §4b Data_SCP.Common / OperationGroupEE / dtOperationGroup | ProductionPlanWaterfallForm.tsx:64 (isEe ? OP_GROUP_EE), constants OP_GROUP_EE='OperationGroupEE_SCP':47 |  | 구현 |
| D00-4b-005 | §4b Data_SCP.Common / OperationGroup / dtOperationGroup | ProductionPlanWaterfallForm.tsx:64 (비EE OP_GROUP), constants OP_GROUP='OperationGroup_SCP':48 |  | 구현 |
| D00-4b-006 | §4b Data_SCP.Common / PlantSiteProdPlan / dtPlantSiteByDivision | ProductionPlanWaterfallForm.tsx:66 (isEe PLANT_SITE_EE, attribute2/segment2), constants:49 |  | 구현 |
| D00-4b-007 | §4b Data.Common / PlantByDivisionOperation / dtPlantSiteByDivision | ProductionPlanWaterfallForm.tsx:67 (비EE PLANT_SITE, divisionId/operationGroup), constants:50 |  | 구현 |
| D00-4b-008 | §4b Data_SCP.Common / WaterfallVer2 / dtVersion | ProductionPlanWaterfallForm.tsx:71 (COMBO.VERSION+divisionId), constants VERSION='WaterfallVer2_SCP':53 |  | 구현 |
| D00-4b-009 | §4b Data_SCP.Common / LineProdPlanLine / dtLine | ProductionPlanWaterfallForm.tsx:69 (isEe LINE_EE, attribute2/operationGroup), constants LINE_EE='LineProdPlanLine_SCP':51 |  | 구현 |
| D00-4b-010 | §4b Data_SCP.Common / LineByOperationAddOSP / dtLine | ProductionPlanWaterfallForm.tsx:70 (비EE LINE, divisionId), constants LINE='LineByOperationAddOSP_SCP':52 |  | 구현 |
| D00-4b-011 | §4b Data.Common / PlantByDivisionOperation / dtPlantSiteByDivision | ProductionPlanWaterfallForm.tsx:67 (OperationGroup 변경 재조회 — react-query 키에 operationGroupId 포함, 별도 호출 아님) |  | 구현 |
| D00-4b-012 | §4b Data_SCP.Common / PlantSiteProdPlan / dtPlantSiteByDivision | ProductionPlanWaterfallForm.tsx:66 (OperationGroup 변경 재조회 — 콤보 파라미터 키 재조회) |  | 구현 |
| D00-4b-013 | §4b Data_SCP.Common / LineProdPlanLine / dtLine | ProductionPlanWaterfallForm.tsx:69 (OperationGroup 변경 재조회 — Line 콤보 파라미터 키 재조회) |  | 구현 |
| D00-4b-014 | §4b Data_SCP.Common / LineByOperationAddOSP / dtLine | ProductionPlanWaterfallForm.tsx:70 (OperationGroup 변경 재조회 — Line 콤보 파라미터 키 재조회) |  | 구현 |
| D00-4b-015 | §4b Data.CallBizCommonData / (PERIOD_+value) / dt |  | AS-IS dead 콤보(PERIOD_ biz common, 화면 미배선 — 미이관) — comboCalls dead 2건(§6 comboCalls 대사) | 해당없음 |
| D00-4b-016 | §4b Data.CallBizCommonData / (PERIOD2_+value) / dt |  | AS-IS dead 콤보(PERIOD2_ biz common, 화면 미배선 — 미이관) — comboCalls dead 2건(§6) | 해당없음 |
| D00-4e-001 | §4e MSG00109 / GMessageBox |  | EditButton 편집불가 안내(Model 시트) — 읽기전용 화면·편집버튼 미노출(hotkey 'edit' 부재, ProductionPlanWaterfall.tsx:238-246)이라 발화 경로 없음. 편집 자체 부재(§5) | 해당없음 |
| D00-4e-002 | §4e MSG00109 / GMessageBox |  | EditButton 편집불가 안내(Line 시트) — 편집버튼 미노출로 발화 경로 없음, 편집 자체 부재(§5) | 해당없음 |
| D00-4e-003 | §4e MSG00007 / GMessageBox |  | btnMeasure 활성시트 미선택 가드 — 단일 그리드 상시활성 + Measure 모달이라 가드 불요(04 §④', ProductionPlanWaterfall.tsx:277-284) | 해당없음 |
| D00-4e-004 | §4e MSG00007 / GMessageBox |  | btnMeasure 활성시트 없음 가드 — 단일 그리드 상시활성이라 가드 불요(04 §④') | 해당없음 |
| D00-4e-005 | §4e MSG00376 / GMessageBox | ProductionPlanWaterfall.tsx:158-168 (chkGap & versionNos≠2 → MSG.GAP_NEED_TWO_VERSION), constants MSG.GAP_NEED_TWO_VERSION='MSG00376':74 |  | 구현 |
| D00-4e-006 | §4e (예외) / GMessageBoxForException | ProductionPlanWaterfall.tsx:86-92 (useTabProcQuery — 공용 훅 조회예외 setAlert 표준 처리) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 조회전용 화면 — Insert 없음(hotkeyConfig insert=false, ProductionPlanWaterfall.tsx:241), AS-IS NO-OP·DB 버튼메타 미등록 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) |  | 조회전용 화면 — 편집 없음(isReadOnly, ProductionPlanWaterfallGrid.tsx:319), 수정중 상태 부재 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | ProductionPlanWaterfall.tsx:185-210 (handleSaveColumnLayout: clearFilters+removeQueries+invalidateQueries+fetchStaticColumns) / :214-233 (handleApplyMeasures 동일) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) |  | 조회전용 화면 — CRUD 없음(Insert/Delete/Save NO-OP, ProductionPlanWaterfall.tsx:241-243). titleSet 저장 완료는 setToast 사용(:206,:229) | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) |  | 그리드 셀 콤보 0건 — 전 컬럼 FPTextBox(ora.py 실측, 04 §③-B). Code→Name 매핑 대상 콤보 컬럼 없음 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useProductionPlanWaterfallStore.ts:190 (itemId=modelId.trim() 콤마 passthrough), :195 (nickName.trim() passthrough) — 다중선택은 joinOrAll 콤마 조립(:189,193,197) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | ProductionPlanWaterfall.tsx:50,289 (gridFilterRef → Grid) + ProductionPlanWaterfallGrid.tsx:317 (DataGrid gridFilterRef 배선 — 공용 필터 유지) |  | 구현 |

## 1. 영역1 Layout / toolbarOverride (design 01)

| AS-IS (.cs 라인) | 동작 | To-Be |
|---|---|---|
| `override FindButton()`→`FindData_Model()` (596) | Model 조회 실행 | `hotkeyConfig.search = handleSearch` (ProductionPlanWaterfall.tsx) |
| `override InsertButton()` 주석 `//InsertRow()` (601) | NO-OP | `hotkeyConfig.insert = false` (읽기전용, 미노출 — 아래 §5) |
| `override DeleteButton()` 주석 (606) | NO-OP | `hotkeyConfig.delete = false` |
| `override SaveButton()` 주석 (711) | NO-OP | `hotkeyConfig.save = false` |
| `override EditButton()` MSG00109 후 return (612) | 편집 전환 없음 | 편집 모드 없음 — 그리드 `isReadOnly`, hotkey 'edit' 키 부재(미노출) |
| `SetDivisionAuthCheck` L1 (211, BaseForm 5269) | 권한 division 0건 → 조회영역 disabled + MSG00097 | Form: `noDivisionAuth`(divisions 로드 후 옵션 0건) → 콤보/입력 disabled + MSG00667 1회(AS-IS MSG00097 의도 매칭 TO-BE 코드, Hook #114). page: `hotkeyConfig.search=false` + handleSearch early-return(조회 미발사). G6 해소 |
| `CboDivision_SelectedIndexChanged` Electrode enable (1006-1014) | 비EE → Electrode disable+clear | Form: `!isEe` → Electrode disabled + `set({electrodeTypes:[]})` effect |
| `btnMeasure_Click` 활성그리드 가드 (666, MSG00007) | 미선택 시 팝업 차단 | 단일 그리드 상시 활성 — Column Set/Measure customButton(이식 후속) |
| `usrButton1` dead control (Designer 33) | 미노출 | 미이식(dead control 소거) |

## 2. 영역2 조회조건 콤보 (design 02) — validations 1 · events 4

| AS-IS | To-Be |
|---|---|
| Division `MyDivisionInEE_SCP` (52,217) | `COMBO.DIVISION` + `{mnuId}` (Form) |
| OperationGroup `OperationGroupEE_SCP`/`OperationGroup_SCP` (949) | `isEe ? OP_GROUP_EE : OP_GROUP` 스왑 |
| PlantSite `PlantSiteProdPlan_SCP`/`PlantByDivisionOperation` (958) | isEe 스왑 + `{attribute2/segment2}` or `{divisionId/operationGroup}` |
| Line `LineProdPlanLine_SCP`/`LineByOperationAddOSP_SCP` (994) | isEe 스왑, `'-'` sentinel 필터 + 조회 파라미터 '' 치환(store) |
| Version `WaterfallVer2_SCP` (971) | `COMBO.VERSION` + `{divisionId}`, 다중(Gap 2건) |
| Electrode lookup `ELECTRODE_TYPE` (61,222) | `useTabLookupQueries('ELECTRODE_TYPE')`, enable=isEe |
| Bucket `BucketISO_SCP` (226,925) | `COMBO.BUCKET`, 기본 DAILY |
| cascade: Division→OpGroup/PlantSite/Line/Version (§3) | 콤보 파라미터 재조회(react-query 키 부모값). PlantSite 수동변경→Line 재조회 안 함(§3 파리티 — Line 파라미터에 plantSite 미포함) |
| `MSG00376` Gap+version≠27 (1068) | `validateSearch()` chkGap & versionNos.length≠2 → MSG00376 |
| Model 팝업 `SCM0002_ItembyDivisionPopup` (652, sScmSite=plant site 전달) | `ItemByDivisionModal` preSearchParams={divisionId, itemId}. **plant site 사전필터는 공용 모달 미지원 → 잔여(G8, Hard Boundary — shared 수정 금지)** |
| `checkRequiredOfSearch`/`Check_PeriodDate` (1029,1034) | `validateSearch()` 필수(Division/OpGroup/Version/Period) + from>to(MSG00108) + **최대기간 to≥from+1년+7일 차단(MSG00172 상당, G7 해소)** |
| Version→Period 재산정 `GetDayRange`(2176-2202)=서버 SP `SCM0001_GET_SCP_MONTH_PERIOD`(offset 12, DateUtil.cs:156) | store `periodFromVersion`/`rangeFrom`: versionStart anchor(코드 뒤 8자) + **offset 12개월**(iter-2 의 +3개월 추측 제거, G2 해소). 정본 SP 배선은 convert-sp 후속 |
| `ChkAll_CheckedChanged`(795-799)=`InitSpread_2`(SetSheetHeaderColumn chkAll bool)+`ClearDataSource` | store `setChkAll`: chkAll 저장 + filters clear(ClearDataSource 재현, 재조회 요구). **헤더 재구성 bool 효과는 프레임워크 overload 본문이 레포에 부재(grep — int/int+DataTable 만 존재)라 재현 불가 → 잔여(G1, 후속)** |

## 3. 영역3 그리드 white-list (design 03 gridSignals 55 → R1~R15)

| R# | AS-IS | To-Be |
|---|---|---|
| R1 읽기전용 | `LockColumn` (1137) | `isReadOnly`, 메타 INPUT_TP_CD=S 그대로(상수 이식 없음) |
| R2 EE 컬럼 show/hide | siMain 317/322 | `buildStaticColumns({isEe})` — 비EE 면 ORIGIN_DIVISION_ID·ELECTRODE_TYPE visible=false |
| R3 세로 병합 SmartColMerge | 258/585/1147 | `WaterfallMergeManager`(좌측 누적 계층) + scrollPositionChanged 재-merge |
| R4 숫자 셀타입 | spdInfo 433 | dynamicColumns numeric format |
| R5 3단 헤더 스팬 | 437-547 | `buildDynamicColumns` 3단 그룹(월>주>일 + SUM) + `WaterfallMergeManager` 헤더 병합 |
| R6 요일 헤더색 | ForeColor 509-511 (SAT=Blue/SUN=Red **only** — green 당기강조 없음) | formatItem: DAY_CODE SAT=Blue/SUN=Red (inline, HEADER_COLORS). **iter-2 green 당기강조는 AS-IS 미존재 drift → 제거(G10). waterfall.headerColors 파일 삭제** |
| R7 Bucket show/hide + chkSum | 864-906 | `baseVisibleOf(bucket, chkSum, kind)` (waterfall.periods §2.5 표) |
| R8 합계칼럼 잠금 | 938 | R1 포함(전 칼럼 잠금) |
| R9 헤더행 높이 20 | 747 | headerRowHeight = 48/tier |
| R10 선택복원 | 1168 | 공용 DataGrid selection(별도 미배선 — 저위험 잔여) |
| R11 과거실적 음영 | SetBGColor2 1201 | formatItem: D_ 일자 < 계획시작일 → 배경 회색(PAST_ACTUAL_BG) |
| R12 뷰행 매핑 | 1458 | 공용 DataGrid CollectionView |
| R13 비율 소수2자리 | 1459 | 서버계산 반환 표시(§3.1 SP 계산) — FE 재계산 없음, 스케일=DATA_SCALE_NUMBER |
| R14 더블클릭 접기/펼치기 | 1984 | 헤더 더블클릭 드릴(그리드 onDblClick, 하위 rank 컬럼 토글) |
| R15 주/월 합계·EOH 파생 | 1683-1790 | **SP 서버계산 반환 → FE 표시만**(design 03 §3.1 주석 — 현행 SP 계산). EOH 보정은 PKG 배포 후 재검증(§6-3) |

## 4. 저장 / 데이터 계약

- 저장 없음(읽기전용) — SaveButton NO-OP. `useProcMutation` 미배선.
- 메인 SP `SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL`(15 IN) → `PKG_SCP0017.P_...`(미배포, convert-sp 후속). store setFilters 15-param 매핑.
- 기간칼럼 헤더 = title 시트(`SCP0009_GET_SHEET_CALENDAR_3SPAN`(+_ISO) 상당) → `P_SCP0017_GET_SHEET_CALENDAR_3SPAN`(미배포). splitTitleRows/buildDynColMetas 소비.
- LINE 시트/Model→Line 드릴 = AS-IS 미구동(spdLine/FindData_Line 전량 주석) → **미구현 재현**(design 03 §6-2). MODEL 시트만 구동.

## 5. 편집 버튼 미노출 결정 (self-check §3 예외 근거)

AS-IS 는 Insert/Delete/Save/Edit 버튼이 보였으나 본문이 전량 NO-OP(주석)였다. To-Be 는 `hotkeyConfig` 에서
`insert/delete/save = false`(hotkey 'edit' 키 자체 부재)로 **미노출**한다. 근거:
- 자매 읽기전용 화면 **SCP0101(Inventory Trend)** 이 `SCM_ADM_MNU_BTN_MPG_M` 에 SEARCH 만 등록(편집버튼 미노출) — 사내 read-only 선례(design 01 §5 Q1).
- SCP0017 DB 등록도 SEARCH 만(`05_register.sql` main/SEARCH·title/SEARCH) — 버튼 권한 자체가 없어 노출돼도 -9997.
- self-check §3: "화면별로 숨기기로 확정된 경우 false 를 쓰되 근거를 __asis-mapping__ 에 남긴다" — 본 절이 그 근거다.
- 공용 addRow/removeRow 회귀 위험 없음(false = 키 자체 비활성이라 공용 기본 핸들러도 불발).

## 6. 커버리지 대사

- validations 6(design 00): MSG00097→MSG00667(L1 권한, **해소 G6**) · MSG00109(Edit) · MSG00007(btnMeasure 가드) · MSG00376(Gap) · checkRequiredOfSearch · Check_PeriodDate(**최대기간 해소 G7**) → validateSearch + Form disable + 편집 미노출로 소진.
- buttonGuards 4: EditButton(3) + btnMeasure(1) → 읽기전용 미노출 / customButton.
- gridSignals 55 → R1~R15 (design 03 §3 회수표, 위 §3).
- comboCalls 16 → 콤보 9(자매 EE/비EE 4쌍) + PERIOD dead 2(미이관) + 중복 → 위 §2.

## 7. 잔여(확인 필요 — 04 리포트)

- 런타임 조회: `PKG_SCP0017` 미배포(convert-sp 후속) — FE 정적 배선 완료, 실 데이터 미검증.
- 기간칼럼 공급 SP 명/패키지: convert-sp 결정(title API 는 화면 PKG 래퍼명으로 선배선, design 03 §6-6).
- G2 정본: `SCM0001_GET_SCP_MONTH_PERIOD`(division/bucket/경계 반영) 배포 후 배선 — 현행은 클라 offset 12개월 근사(iter-3 교정, AS-IS 기본값 재현).
- G12(iter-4 해소): 그리드 하단 footer 'Sum' 합계행 제거. AS-IS SCP0017 에 ColumnFooter/합계행 신호 0건(cs 전수 grep)이고, 이질 measure(수량·비율·EOH)를 세로 합산하면 무의미 값이라 AS-IS 파리티로 제거. `columnFooters`/`GroupRow` useEffect + dynamic column `aggregate: Aggregate.Sum` 전부 삭제(소비처 없음).
- I2(iter-4 해소) 최대기간 메시지 코드: AS-IS MSG00172 는 TO-BE 미등록(ora.py 0행). 문구 역조회로 등록된 TO-BE 코드 `MSG01187`(EN 'Maximum Period is From Date + {0}.', USE_YN='Y' 실측)에 매핑, {0}='371 days'(Hook #114 준수, '_' fallback 해소).
- I1 Gap 2건 검증 메시지(MSG00376): TO-BE 미등록(ora.py 0행) + 문구 역조회 1:1 일치 코드 없음(MSG00255 'up to 2 versions' 는 상한 제약이라 의미 불일치). EN defaultValue fallback 유지, 신규 등록은 i18n 팀 소관(SCM_ADM_MSG_M INSERT 금지). 저위험 잔여.
- I3(iter-4 해소): 미사용 MSG 상수 `EDIT_LOCKED`/`SELECT_GRID` 제거(폴더 내 참조 0건 — 편집버튼 미노출·btnMeasure 단일그리드 상시활성이라 가드 불요).
- G1 chkAll 헤더 재구성 bool 효과: 프레임워크 `SetSheetHeaderColumn` bool overload 본문이 레포에 부재 → 재현 불가. 확정 효과(ClearDataSource=grid clear)만 재현. 후속(프레임워크 본문 실측 또는 SP 배포 후).
- G8 Model 팝업 plant site 사전필터: 공용 `ItemByDivisionModal` 미지원(Hard Boundary — shared 수정 금지). 공용 모달 prop 확장은 분리 PR.
- G9 재조회 후 선택셀 복원/중앙 스크롤(R10): 공용 DataGrid selection 별도 미배선(UX 편의, 저위험).
- R15 주/월 합계·EOH FE 재계산 여부: SP 서버계산 전제, PKG 배포 후 확정(design 03 §6-3).
- Column Set/Measure(SCM0002_TitleSetForm): ColumnLayoutModal/MeasureSelectModal 이식(런타임 titleSet 저장은 PKG 후속).
