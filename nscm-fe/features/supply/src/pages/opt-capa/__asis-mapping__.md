# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Division / DevExpress.XtraLayout.LayoutControlItem | components/OptCapaForm.tsx `singleField` Division |  | 구현 |
| D00-1-002 | §1 btnBatchSave / GSCM.Windows.Forms.Controls.UsrButton | components/OptCapaForm.tsx 부모 `customButtons[1]`(C-26) |  | 구현 |
| D00-1-003 | §1 btnExcelForm / GSCM.Windows.Forms.Controls.UsrButton | components/OptCapaForm.tsx 부모 `customButtons[0]`(C-24) |  | 구현 |
| D00-1-004 | §1 btnExcelUpload / GSCM.Windows.Forms.Controls.UsrButton | hooks/useOptCapaActions.ts hotkeyConfig.upload(C-22) |  | 구현 |
| D00-1-005 | §1 cboDivision / GSCM.Windows.Forms.Controls.UsrCombo | components/OptCapaForm.tsx `singleField` Division(`CustomDropdown`) |  | 구현 |
| D00-1-006 | §1 cboPlanGroup / GSCM.Windows.Forms.Controls.UsrComboBox | components/OptCapaForm.tsx `singleField` Plan Group |  | 구현 |
| D00-1-007 | §1 clbLine / GSCM.Windows.Forms.Controls.UsrCheckedList2 | components/OptCapaForm.tsx `multiField` Line |  | 구현 |
| D00-1-008 | §1 clbPlant / GSCM.Windows.Forms.Controls.UsrCheckedList2 | components/OptCapaForm.tsx `multiField` Plant |  | 구현 |
| D00-1-009 | §1 components / System.ComponentModel.Container |  | WinForms 디자이너 비가시 컨테이너(`System.ComponentModel.Container`) — React 대응 불필요 | 해당없음 |
| D00-1-010 | §1 emptySpaceItem1 / DevExpress.XtraLayout.EmptySpaceItem |  | DevExpress LayoutControl 여백 아이템 — MUI `Grid` 반응형 레이아웃이 자동 처리, 개별 React 대응 불필요 | 해당없음 |
| D00-1-011 | §1 emptySpaceItem2 / DevExpress.XtraLayout.EmptySpaceItem |  | D00-1-010 과 동일 사유 | 해당없음 |
| D00-1-012 | §1 layoutControlGroup1 / DevExpress.XtraLayout.LayoutControlGroup | components/OptCapaForm.tsx `SearchArea`/`Grid container` |  | 구현 |
| D00-1-013 | §1 layoutControlGroup2 / DevExpress.XtraLayout.LayoutControlGroup | components/OptCapaForm.tsx `SearchArea`/`Grid container` |  | 구현 |
| D00-1-014 | §1 layoutControlItem1 / DevExpress.XtraLayout.LayoutControlItem |  | DevExpress 개별 필드 wrapper — MUI `Grid`/`FormItem` 으로 대체, 1:1 대응 불필요 | 해당없음 |
| D00-1-015 | §1 layoutControlItem2 / DevExpress.XtraLayout.LayoutControlItem |  | D00-1-014 과 동일 사유 | 해당없음 |
| D00-1-016 | §1 layoutControlItem3 / DevExpress.XtraLayout.LayoutControlItem |  | D00-1-014 과 동일 사유 | 해당없음 |
| D00-1-017 | §1 layoutControlItem9 / DevExpress.XtraLayout.LayoutControlItem |  | D00-1-014 과 동일 사유 | 해당없음 |
| D00-1-018 | §1 lciBatchSave / DevExpress.XtraLayout.LayoutControlItem | components/OptCapaForm.tsx 부모 `customButtons[1]`(C-25 동일 사유) | 버튼을 SubTitle 로 올려 '래퍼 표시 = 버튼 표시' 로 흡수(C-25 와 동일) | 제외 |
| D00-1-019 | §1 lciExcelForm / DevExpress.XtraLayout.LayoutControlItem | components/OptCapaForm.tsx 부모 `customButtons[0]`(C-23 동일 사유) | C-23 과 동일 사유 | 제외 |
| D00-1-020 | §1 lciExcelUpload / DevExpress.XtraLayout.LayoutControlItem | hooks/useOptCapaActions.ts hotkeyConfig.upload(C-21 동일 사유) | C-21 과 동일 사유 | 제외 |
| D00-1-021 | §1 lciModel / DevExpress.XtraLayout.LayoutControlItem | components/OptCapaForm.tsx `extraConditions` Model `textField` |  | 구현 |
| D00-1-022 | §1 lciNickName / DevExpress.XtraLayout.LayoutControlItem | components/OptCapaForm.tsx `textField` Nick Name |  | 구현 |
| D00-1-023 | §1 mrpPeriod / GSCM.Windows.Forms.Controls.UsrMonthRangePicker | components/OptCapaForm.tsx `PeriodField` |  | 구현 |
| D00-1-024 | §1 spdMain / FarPoint.Win.Spread.FpSpread | components/OptCapaGrid.tsx `FlexGrid`(공용 `DataGrid`) |  | 구현 |
| D00-1-025 | §1 spdMain_Sheet1 / FarPoint.Win.Spread.SheetView | components/OptCapaGrid.tsx 활성 시트(`sheet`/`staticColumns[sheet]`) |  | 구현 |
| D00-1-026 | §1 txtModel / GSCM.Windows.Forms.Controls.UsrTextBox | components/OptCapaForm.tsx `textField` Model |  | 구현 |
| D00-1-027 | §1 txtNickName / GSCM.Windows.Forms.Controls.UsrTextBox | components/OptCapaForm.tsx `textField` Nick Name |  | 구현 |
| D00-1-028 | §1 usrConditionPanel1 / GSCM.Windows.Forms.Controls.UsrConditionPanel | components/OptCapaForm.tsx `SearchArea` 전체 |  | 구현 |
| D00-1-029 | §1 usrLayoutControl1 / GSCM.Windows.Forms.Controls.UsrLayoutControl |  | C-01 과 동일 — `this.Controls.Add` 없음, dead 컨트롤 | 제외 |
| D00-1-030 | §1 usrLayoutControl2 / GSCM.Windows.Forms.Controls.UsrLayoutControl | components/OptCapaForm.tsx `sx` 잠금(C-02 구현 확인) |  | 구현 |
| D00-2-001 | §2 _defaultDataModel / Changed | components/OptCapaGrid.tsx `cellEditEndedHandler`/`pastedCellHandler`(파생 공유) |  | 구현 |
| D00-2-002 | §2 btnBatchSave / Click | OptCapa.tsx `customButtons[1]` → `NoWorkBatchModal` open |  | 구현 |
| D00-2-003 | §2 btnExcelForm / Click | hooks/useOptCapaActions.ts `handleExcelForm` |  | 구현 |
| D00-2-004 | §2 btnExcelUpload / Click | hooks/useOptCapaActions.ts hotkeyConfig.upload → `setOpenUpload(true)` |  | 구현 |
| D00-2-005 | §2 cboDivision / SelectedIndexChanged | components/OptCapaForm.tsx Division `onPick`(planGrId/plantIds/lineIds 리셋) |  | 구현 |
| D00-2-006 | §2 cboPlanGroup / SelectedIndexChanged | components/OptCapaForm.tsx Plan Group `onPick` |  | 구현 |
| D00-2-007 | §2 clbPlant / SelectedIndexChanged | components/OptCapaForm.tsx Plant `onPick`(lineIds 리셋) |  | 구현 |
| D00-2-008 | §2 spdMain / ActiveSheetChanged | useOptCapaStore.ts `activeSheet`/`setActiveSheet` |  | 구현 |
| D00-2-009 | §2 spdMain / ActiveSheetChanging | hooks/useOptCapaActions.ts `handleTabChange`(dirty 가드) |  | 구현 |
| D00-2-010 | §2 spdMain / CellClick | components/OptCapaGrid.tsx `beginningEditHandler`(`candidatesFor` dataMap 주입) |  | 구현 |
| D00-2-011 | §2 spdMain / CellDoubleClick | hooks/useOptCapaActions.ts `openItemPopup`(ITEM_ID 더블클릭) |  | 구현 |
| D00-2-012 | §2 spdMain / ClipboardPasted | components/OptCapaGrid.tsx `pastedCellHandler` |  | 구현 |
| D00-2-013 | §2 spdMain / ComboSelChange | components/OptCapaGrid.tsx `beginningEditHandler`/`cellEditEndedHandler`(Line→Operation→LineType cascade) |  | 구현 |
| D00-3-001 | §3 RemoveSheet / `(dtExptDiv.Rows[i]["SHEET_NAME"].ToString())` | utils/optCapa.sheetVisibility.ts `buildVisibleSheets` |  | 구현 |
| D00-3-002 | §3 VisibleTab / `(true)` | utils/optCapa.sheetVisibility.ts `buildVisibleSheets` |  | 구현 |
| D00-3-003 | §3 VisibleTab / `(true)` | utils/optCapa.sheetVisibility.ts `buildVisibleSheets` |  | 구현 |
| D00-3-004 | §3 Delete / `()` | hooks/useOptCapaActions.ts `handleDelete` |  | 구현 |
| D00-3-005 | §3 Delete / `()` | hooks/useOptCapaActions.ts `handleDelete` |  | 구현 |
| D00-3-006 | §3 SwitchLock / `()` | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-007 | §3 LockRange / `(i, DIVISION_ID, i, YYYYMM, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-008 | §3 LockRange / `(i, LAST_UPDATED_BY, i, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-009 | §3 LockRange / `(i, CAPA, i, CAPA, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-010 | §3 LockRange / `(i, M_MIN, i, M_MIN, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-011 | §3 LockRange / `(i, LANE, i, LANE, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-012 | §3 LockRange / `(i, WIDE_YN, i, WIDE_YN, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-013 | §3 LockColumn / `(DIVISION_ID, YYYYMM, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-014 | §3 LockColumn / `(LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-015 | §3 LockColumn / `(DIVISION_ID, OPMZ_PLAN_GR_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-016 | §3 LockColumn / `(LINE_NAME, LINE_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-017 | §3 LockColumn / `(DAY_OF_WEEK, DAY_OF_WEEK, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-018 | §3 LockColumn / `(LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-019 | §3 LockColumn / `(LINE_TYPE, LINE_TYPE, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-020 | §3 LockColumn / `(DIVISION_ID, OPMZ_PLAN_GR_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-021 | §3 LockColumn / `(LINE_NAME, LINE_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-022 | §3 LockColumn / `(NICK_NAME, NICK_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-023 | §3 LockColumn / `(LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-024 | §3 LockColumn / `(LINE_TYPE, LINE_TYPE, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-025 | §3 LockColumn / `(DIVISION_ID, OPMZ_PLAN_GR_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-026 | §3 LockColumn / `(LINE_NAME, LINE_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-027 | §3 LockColumn / `(LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-028 | §3 LockColumn / `(DIVISION_ID, OPMZ_PLAN_GR_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-029 | §3 LockColumn / `(NICK_NAME, NICK_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-030 | §3 LockColumn / `(LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-031 | §3 Insert / `()` | hooks/useOptCapaActions.ts `handleInsert` |  | 구현 |
| D00-3-032 | §3 SetValue / `(insCell, defaultData)` | hooks/useOptCapaActions.ts `handleInsert`(신규행 기본값 조립) |  | 구현 |
| D00-3-033 | §3 LockRange / `(insCell, DIVISION_ID, OPMZ_PLAN_GR_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-034 | §3 LockRange / `(insCell, LINE_NAME, LINE_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-035 | §3 LockRange / `(insCell, DAY_OF_WEEK, DAY_OF_WEEK, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-036 | §3 LockRange / `(insCell, LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-037 | §3 LockRange / `(insCell, LINE_TYPE, LINE_TYPE, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-038 | §3 SetValue / `(insCell, defaultData)` | hooks/useOptCapaActions.ts `handleInsert`(신규행 기본값 조립) |  | 구현 |
| D00-3-039 | §3 LockRange / `(insCell, DIVISION_ID, OPMZ_PLAN_GR_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-040 | §3 LockRange / `(insCell, LINE_NAME, LINE_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-041 | §3 LockRange / `(insCell, NICK_NAME, NICK_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-042 | §3 LockRange / `(insCell, LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-043 | §3 LockRange / `(insCell, LINE_TYPE, LINE_TYPE, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-044 | §3 SetValue / `(insCell, defaultData)` | hooks/useOptCapaActions.ts `handleInsert`(신규행 기본값 조립) |  | 구현 |
| D00-3-045 | §3 LockRange / `(insCell, DIVISION_ID, OPMZ_PLAN_GR_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-046 | §3 LockRange / `(insCell, LINE_NAME, LINE_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-047 | §3 LockRange / `(insCell, LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-048 | §3 SetValue / `(insCell, defaultData)` | hooks/useOptCapaActions.ts `handleInsert`(신규행 기본값 조립) |  | 구현 |
| D00-3-049 | §3 LockRange / `(insCell, DIVISION_ID, OPMZ_PLAN_GR_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-050 | §3 LockRange / `(insCell, NICK_NAME, NICK_NAME, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-051 | §3 LockRange / `(insCell, LAST_UPDATED_BY, PRE_KEY_VALUES, true)` | utils/optCapa.editLock.ts `editableAt`(admin 메타 INPUT_TP_CD 구동) — 05_runtime-parity.md A축 131/131 일치 확인 |  | 구현 |
| D00-3-052 | §3 Query / `(ds)` | hooks/useOptCapaActions.ts `runSearch`(GET 조회) |  | 구현 |
| D00-3-053 | §3 LockColumn / `(0, GetMaxColumnIndex(), true)` | utils/optCapa.editLock.ts `editableAt`(`canEdit=false` 시 전열 잠금) |  | 구현 |
| D00-3-054 | §3 RemoveSheet / `(dtExptDiv.Rows[i]["SHEET_NAME"].ToString())` | utils/optCapa.sheetVisibility.ts `buildVisibleSheets` |  | 구현 |
| D00-3-055 | §3 Find / `(_spdSheets[i])` | opt-capa.constants.ts `GRID_SHEETS` / hooks/useOptCapaSheets.ts `visibleSheets` |  | 구현 |
| D00-3-056 | §3 Find / `(_spdSheets[i])` | opt-capa.constants.ts `GRID_SHEETS` / hooks/useOptCapaSheets.ts `visibleSheets` |  | 구현 |
| D00-3-057 | §3 SetValue / `(e.Row, LINE_ID, "")` | components/OptCapaGrid.tsx `cellEditEndedHandler`/`applyLineNameDerivation`/`applyDayOfWeekDerivation` |  | 구현 |
| D00-3-058 | §3 SetValue / `(e.Row, LINE_NAME, "")` | components/OptCapaGrid.tsx `cellEditEndedHandler`/`applyLineNameDerivation`/`applyDayOfWeekDerivation` |  | 구현 |
| D00-3-059 | §3 SetValue / `(e.Row, LINE_NAME, codeVal)` | components/OptCapaGrid.tsx `cellEditEndedHandler`/`applyLineNameDerivation`/`applyDayOfWeekDerivation` |  | 구현 |
| D00-3-060 | §3 SetValue / `(e.Row, OPERATION_ID, operation)` | components/OptCapaGrid.tsx `cellEditEndedHandler`/`applyLineNameDerivation`/`applyDayOfWeekDerivation` |  | 구현 |
| D00-3-061 | §3 SetValue / `(e.Row, DAY_OF_WEEK, dayOfWeek)` | components/OptCapaGrid.tsx `cellEditEndedHandler`/`applyLineNameDerivation`/`applyDayOfWeekDerivation` |  | 구현 |
| D00-3-062 | §3 SetValue / `(iRow, LINE_NAME, codeVal)` | components/OptCapaGrid.tsx `cellEditEndedHandler`/`applyLineNameDerivation`/`applyDayOfWeekDerivation` |  | 구현 |
| D00-3-063 | §3 SetText / `(e.Row, ITEM_ID, sItemId)` | hooks/useOptCapaActions.ts `handleItemSelect` |  | 구현 |
| D00-3-064 | §3 SetText / `(e.Row, NICK_NAME, sNickName)` | hooks/useOptCapaActions.ts `handleItemSelect` |  | 구현 |
| D00-4b-001 | §4b BLUtils.GetDivision / false / dtMyDivision | hooks/useOptCapaSheets.ts `divisionOptions`(콤보 `Division_SCP`) |  | 구현 |
| D00-4c-001 | §4c DBUtils.Filter / dtPlanGroupAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-002 | §4c DBUtils.Filter / dtPlantIdAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-003 | §4c DBUtils.Filter / dtPlantIdAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-004 | §4c DBUtils.Filter / dtPlantIdAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-005 | §4c DBUtils.Filter / dtPlantIdAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-006 | §4c DBUtils.Filter / dtLineAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-007 | §4c DBUtils.Filter / dtLineAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-008 | §4c DBUtils.Filter / dtLineAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-009 | §4c DBUtils.Filter / dtLineAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-010 | §4c DBUtils.Filter / dtLineAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-011 | §4c DBUtils.Filter / dtLineAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-012 | §4c DBUtils.Filter / dtOperationAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-013 | §4c DBUtils.Filter / dtLineTypeAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-014 | §4c DBUtils.Filter / dtExptDivAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-015 | §4c DBUtils.Filter / dtNoWorkAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-016 | §4c DBUtils.Filter / dtSopEopAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-017 | §4c DBUtils.Filter / dtRampupAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-018 | §4c DBUtils.Filter / dtRampupAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-019 | §4c DBUtils.Filter / dtRampupItvlAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-020 | §4c DBUtils.Filter / dtPrepRtAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-021 | §4c DBUtils.Filter / dtPrepRtAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-022 | §4c DBUtils.Filter / dtUtilRtAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-023 | §4c DBUtils.Filter / dtUtilRtAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-024 | §4c DBUtils.Filter / dtYieldAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-025 | §4c DBUtils.Filter / dtExptDivAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-026 | §4c DBUtils.Filter / dtExptDiv | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-027 | §4c DBUtils.Filter / dtLineAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-028 | §4c DBUtils.Filter / dtLineTypeAll | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-029 | §4c DBUtils.Filter / dtPlantId | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4c-030 | §4c DBUtils.Filter / dtLine | utils/optCapa.candidates.ts `candidatesFor`/`buildLineOptions`/`resolveFilterCodes`(클라 cascade 필터) — 05_runtime-parity.md §2.2 OK 확인 |  | 구현 |
| D00-4d-001 | §4d DeleteButton / Delete | hooks/useOptCapaActions.ts `handleDelete` |  | 구현 |
| D00-4d-002 | §4d DeleteButton / Delete | hooks/useOptCapaActions.ts `handleDelete` |  | 구현 |
| D00-4d-003 | §4d DeleteButton / Delete | hooks/useOptCapaActions.ts `handleDelete` |  | 구현 |
| D00-4d-004 | §4d DeleteButton / Delete | hooks/useOptCapaActions.ts `handleDelete` |  | 구현 |
| D00-4d-005 | §4d SaveButton / Save | hooks/useOptCapaActions.ts `handleSave` |  | 구현 |
| D00-4d-006 | §4d SpdMain_ActiveSheetChanging / — | hooks/useOptCapaActions.ts `handleTabChange` |  | 구현 |
| D00-4d-007 | §4d SpdMain_ActiveSheetChanging / — | hooks/useOptCapaActions.ts `handleTabChange` |  | 구현 |
| D00-4d-008 | §4d SpdMain_ActiveSheetChanging / — | hooks/useOptCapaActions.ts `handleTabChange` |  | 구현 |
| D00-4d-009 | §4d SpdMain_CellDoubleClick / — | hooks/useOptCapaActions.ts `openItemPopup`(ITEM_ID 더블클릭) |  | 구현 |
| D00-4d-010 | §4d SpdMain_CellDoubleClick / — | hooks/useOptCapaActions.ts `openItemPopup`(ITEM_ID 더블클릭) |  | 구현 |
| D00-4d-011 | §4d SpdMain_CellDoubleClick / — | hooks/useOptCapaActions.ts `openItemPopup`(ITEM_ID 더블클릭) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:NoWorkBatchModal | FE 실존 모달 (components/modals/NoWorkBatchModal.tsx) — AS-IS `SCP0126_NoWork_BatchPopup.cs` 1:1 대응(R07) | components/modals/NoWorkBatchModal.tsx |  | 구현 |
| MODAL:NoWorkExcelUploadModal | FE 실존 모달 (components/modals/NoWorkExcelUploadModal.tsx) — AS-IS Excel Upload 팝업 대응 | components/modals/NoWorkExcelUploadModal.tsx |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.
> gap-resolve iter-1(2026-10-02) 전건 실측·판정. 근거 상세는 `gap-resolve/iter-1/evidence.md` §2.2.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | hooks/useOptCapaActions.ts:227 `GridAction.addRow`(공용 유틸, keepRowVisibleUnderFilter 내장) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | hooks/useOptCapaActions.ts `handleSearch`(`GRID_SHEETS.some(hasChanges)` 가드, gap-resolve iter-1 신설) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) |  | 이 화면은 `DataGrid`에 `layoutKey` 를 넘기지 않아 컬럼설정(ColumnLayoutModal) 기능 자체가 없다 — SCP 도메인 개인화 복원이 DB 게이트 2건(`SCM_MST_SHEET_COLUMNS.DIVISION_ID` 전건 NULL·`UNIT_TP_CD='S'` 권한행 0건)으로 막혀 있어(memory `scp-sheet-columns-division-id-null-breaks-titleset`) 도메인 공통 과제다. 화면 범위 밖 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | hooks/useOptCapaActions.ts:266,301 `setToast` (저장 성공) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | hooks/useOptCapaActions.ts hotkeyConfig(`excel` 키 미지정 시 공용 `SubTitle` 기본 액션 `GridAction.excelDownload` 사용, dataMap 치환 내장) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) |  | AS-IS SP 실측(`asis.py proc SCP0126_GET_DAILY_CAPA` 133-134행) `ITEM_ID`/`NICK_NAME` 모두 `LIKE '%'+@p+'%'` 단일 부분일치다 — AS-IS 자체가 콤마다중 코드매칭 필드가 아니다(TO-BE `PKG_SCP0126` 동일 LIKE 패턴, `ora.py` 재실측 확인). 대상 아님 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | OptCapa.tsx:81 `gridFilterRefs`(시트별 유지) + components/OptCapaGrid.tsx:408 `ResultArea`/`DataGrid` 표준 배선 |  | 구현 |

## 1. 영역1 — Layout (45행)

### 1.1 컨트롤 (C, 8행)

| 체크리스트 | AS-IS | TO-BE | 사유 (미구현/제외/해당없음 시 필수) | 판정 |
|---|---|---|---|---|
| C-01 | `usrLayoutControl1` (Designer:33·88~96) | — | `this.Controls.Add` 없음, `.cs` 참조 0건(dead 컨트롤) | 해당없음 |
| C-02 | `usrLayoutControl2` + `SetDivisionAuthCheck`(cs:213-214) | `OptCapa.tsx` `hasDivisionAuth` 게이트 → `OptCapaForm` 전 필드 `disabled` + SubTitle 전 버튼 `false` + `setAlert(MSG00667)` 1회(`authAlertedRef`) |  | 구현 |
| C-21 | `lciExcelUpload` 래퍼 (Designer:602~612) | — | 버튼을 SubTitle 로 올려 "래퍼 표시 = 버튼 표시" 로 흡수 | 제외 |
| C-22 | `btnExcelUpload` (Designer:208~245) | `hotkeyConfig.upload` (조건부, `LBL00346`) |  | 구현 |
| C-23 | `lciExcelForm` | — | C-21 과 동일 사유 | 제외 |
| C-24 | `btnExcelForm` (Designer:172~206) | `customButtons[0]` (`LBL00762`) |  | 구현 |
| C-25 | `lciBatchSave` | — | C-21 과 동일 사유(버튼 래퍼 흡수) | 제외 |
| C-26 | `btnBatchSave` (Designer:137~170) | `customButtons[1]` → `NoWorkBatchModal` (`LBL01056`) |  | 구현 |

> 전용 3버튼을 조회영역이 아니라 SubTitle 로 옮긴 근거: hook #63(SubTitle 11버튼 1객체) ·
> #97(공통버튼 활성그리드 라우팅). 조회영역에 액션 버튼을 심으면 `SearchArea` 의 dirty 가드와
> 권한 게이트를 우회한다. 배치 변경은 UI 개선이 아니라 표준 준수다.

### 1.2 이벤트 · 검증 (E 5 / V 1)

| 체크리스트 | AS-IS | TO-BE |
|---|---|---|
| E-04 ExcelUpload Click (cs:3833-3839) | `ExcelUploadForm("SCP0126", 시트)`, `SaveExceptError=false` | `NoWorkExcelUploadModal` → `POST /SCP0126/No Work/UPLOAD/excel-upload`. **전량 롤백 옵션은 공용 경로에 미노출 → 04 ⑦ V-5** |
| E-05 ExcelForm Click (cs:3841-3844) | HelpServer 고정 `.xls` HTTP GET | `utils/optCapa.excelForm.ts` + `GridAction.flatExcelDownload` — `HEADER_CONTENT` 11토큰 클라 생성 |
| E-06 BatchSave Click (cs:3847-3859) | 모달 → `DialogResult.OK` 면 `FindData_Main()` | `NoWorkBatchModal onSaved` → `gridQuery.refetch()` (저장 성공 시에만) |
| E-07 / EP-12 `ActiveSheetChanging` (cs:3664-3681) | 인덱스<0 / 조회중 / 편집중 3가드 | `handleTabChange` — 인덱스 가드는 **미해당**(controlled state 라 음수 불가), `isFetching` 조용히 return, 편집중 `MSG01149` |
| E-08 / EP-13 `ActiveSheetChanged` (cs:3684-3696) | 시트명 갱신 + 버튼·콤보 재구성 3회 호출 | `setActiveSheet` 만. 버튼 노출·콤보 후보는 `useMemo` 파생이 자동 반영 |
| V-58 `MSG00129` (cs:3679) | `{0}를 수정 중이어서…` | **`MSG01149`** — TO-BE MSG00129 는 `{0}` 없는 플레이스홀더라 재사용 금지(hook #114) |

### 1.3 gridSignals (G, 7행) · toolbarOverride (OV, 5행) · entryPoints (EP, 10행) · filterCalls (F, 3행) · buttonGuards (BG, 6행)

| 체크리스트 | AS-IS | TO-BE |
|---|---|---|
| G-01 / F-14 `RemoveSheet`(CreateSpread cs:562-618) | 5시트 고정 + `division=="40"` 이면 PrepRt 추가 → 제외목록 제거 | `buildVisibleSheets()` — 제외목록 **단일 원천**. `=="40"` 리터럴 미이식(04 ④ G-9) |
| G-02·G-03 `VisibleTab(true)` (cs:632·640) | `TabStripPolicy.Always` | `TabWrapper` 무조건 렌더(조건부 렌더 금지) |
| G-06 `SwitchLock()` (cs:842) | 시트 잠금 토글 | **미이식** — TO-BE 공통 결정으로 Edit 잠금 토글 자체를 안 쓴다(§6.3 주). 편집 가능 여부는 `canEdit = hasButton('EDIT')` 권한만 |
| G-54·G-55·G-56 / F-25·F-26 (cs:3391-3462) | Division 변경 시 add/remove | 같은 `buildVisibleSheets()` 파생식 하나 |
| OV-01 `FindButton`(923) | `FindData_Main()` | `hotkeyConfig.search` |
| OV-02 `SaveButton`(937) | null 가드 + 8분기 | `hotkeyConfig.save` → `handleSave` 가 `activeSheet` 분기 |
| OV-03 `DeleteButton`(763) | `fps` 2가드 + 시트별 | `hotkeyConfig.delete`. **`fps` 가드 2건 = 미해당**(그리드 1개 단일 ref) |
| OV-04 `EditButton`(833) | `SwitchLock` + 재잠금 | **미이식** — Edit 버튼·editMode 토글 제거. `hasButton('EDIT')` 은 버튼이 아니라 `canEdit` 권한축(convert-core §2.4) |
| OV-05 `InsertButton`(928) | Daily Capa 에선 무동작 | `hotkeyConfig.insert` = 핸들러 유지 + `handleInsert` 내부 `if (sheet === DAILY_CAPA) return`. **생략·`false` 둘 다 금지** |
| EP-01~EP-08 | 위 OV + 전용 3버튼 Click | 동상 |
| BG-01 `fps == null`(Delete) · BG-02 `fps.Name=="spdMain"` | — | **미해당**(구조적) |
| BG-05 `fps == null`(Save) | — | `if (!grid) return` |
| BG-06 `ActiveSheetIndex < 0` | — | **미해당**(controlled state) |
| BG-07 `_isFinding` | 조용히 전환 취소 | `if (gridQuery.isFetching) return` — 토스트 추가 금지 |
| BG-08 `!IsLock` + MSG00129 | 전환 차단 + 메시지 | `MSG01149` + 시트 라벨 — 판정축이 편집모드 → **미저장 변경(dirty)** 로 바뀐다(Edit 잠금 미채용, 사용자 결정 2026-09-29) |

### 1.4 R21 조회 중 상태

AS-IS `_isFinding` / `CanModelChange=false` / `ProgressForm`(cs:1078-1081·1235-1246) →
react-query `isFetching`. **별도 로딩 토스트 추가 금지**(nscm-patterns §6).

---

## 2. 영역2 — 조회조건 (35행 고유)

### 2.1 컨트롤 (C, 15행)

| 체크리스트 | AS-IS | TO-BE |
|---|---|---|
| C-03 `usrConditionPanel1` (`PanelType.HidePanel`) | 접힘/펼침 패널 | `MainTitle openSearchArea` + `{openSearchArea && <OptCapaForm/>}` |
| C-06·C-07 Division / `cboDivision` | `BLUtils.GetDivision(false,"")` → `Data_SCP.Common(Type.Division,…)` | `CustomDropdown` 단일 + 콤보 **`Division_SCP`**. ALL 옵션 없음. 기본값 = 목록 첫 행(세션 division 아님) |
| C-08·C-09 Plan Group / `cboPlanGroup` | `SCP0121_GET_SEARCH_INFO` Tables[3] | 콤보 `PlanGroup_SCP_ALL` + ALL 선행 + `DIVISION_ID` 클라 필터 + **NAME 오름차순 FE 정렬** |
| C-10·C-11 Period / `mrpPeriod` | 당월 ~ +12개월, `yyyy-MM` | 공용 `PeriodField mode='month'` + **`label={t('LBL00013')}` 명시**(기본 `LBL00505` 는 DB·번들 0건) |
| C-13·C-14 Plant / `clbPlant` | `init` Tables[0] + 클라 필터 3중 | `CustomDropdown multiple allOption` + `buildPlantOptions()` |
| C-15·C-16 Line / `clbLine` | `init` Tables[1] + 클라 필터 2중. **`SelectedIndexChanged` 미배선** | `buildLineOptions()`. **Line 변경은 그리드를 비우지 않는다**(AS-IS 비대칭 재현) |
| C-17·C-18 Nick Name / `txtNickName` | 텍스트. No Work 조회 시 값만 `''` | `InputField`. 숨기지 않는다(주석처리된 AS-IS 코드 이식 금지) |
| C-19·C-20 Model / `txtModel` | 동상(`= ITEM_ID`) | 동상 + `extraConditions` 분리(hook #52 — 7 > 6) |

### 2.2 이벤트 (E, 3행)

| 체크리스트 | AS-IS | TO-BE |
|---|---|---|
| E-01 `ClbDivision_SelectedIndexChanged`(cs:3391) | 4콤보 재구성 + `ClearDataSource` | Division 변경 → 하위 3조건 초기화 + `clearFilters()`(전 시트) + `fetchStaticColumns(division)` + `removeQueries([tabId])` |
| E-02 `CboPlanGroup_SelectedIndexChanged`(cs:3528) | 콤보 재구성 없음 + `ClearDataSource` | 같은 effect 의 조건 키에 포함 → `clearFilters()` 만 |
| E-03 `ClbPlant_SelectedIndexChanged`(cs:3533) | `RefreshLine()` + `ClearDataSource` | Plant 변경 → `lineIds: []` + `clearFilters()` |

### 2.3 검증 (V 1) · 콤보공급 (CB 9) · 필터 (F 7)

| 체크리스트 | AS-IS | TO-BE |
|---|---|---|
| V-01 `MSG00344` Period 역전 (cs:1071-1075) | 조회 차단 | `validateSearch()` → **`MSG01340`**(KO 문구 완전 일치) |
| CB-01 `BLUtils.GetDivision` | 5층 추적 → 권한필터 有 | SQL_ID **`Division_SCP`**. `MyDivision`/`Division_SCP_NoEE`/`AllDivision_SCP` 사용 0건 |
| CB-02~CB-06 `init` Tables[0..4] | `dtPlantIdAll`/`dtLineAll`/`dtOperationAll`/`dtExptDivAll`/`dtLineTypeAll` | `useOptCapaSheets` 의 `o_rc1`~`o_rc5`(**소문자**) |
| CB-07 `SCP0121` Tables[3] | `dtPlanGroupAll` | 콤보 `PlanGroup_SCP_ALL` |
| CB-08 `dtType` 리터럴(cs:233-245) | SOP/EOP 2행 | `SOP_EOP_TYPE_CANDIDATES` — 셀 콤보 FE 주입 |
| CB-09 `dtFixCombo` 리터럴(cs:253-265) | 공백/`Y` 2행 | `FIX_CANDIDATES` — 동상 |
| F-01 PlanGroup `DIVISION_ID` | cs:345 | `useOptCapaSheets.planGroupOptions` |
| F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ) | cs:355-379 | `buildPlantOptions()` — `ORG_DIVISION_FALLBACK_DIVISION` 축 전환 + `needsSeqNormalOnly()` |
| F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제한 | cs:443-458 | `buildLineOptions()` |
| F-12 Operation(영역2·3 공유) | cs:524-536 | `buildOperationCellCandidates()` |

### 2.4 초기화 순서 결함 2건

| # | AS-IS | TO-BE | 사유 (미구현/제외/해당없음 시 필수) | 판정 |
|---|---|---|---|---|
| I-1 | `SetChangedControl()`(cs:229)이 `_sActiveSheetName` 대입(cs:249)보다 앞 → **최초 로드 시 82 의 OSP 가 후보에 남는다**. 탭을 한 번 바꿔야 걸린다 | `activeSheet` 초기값이 `No Work` 라 **처음부터 제외된다** → AS-IS 와 다르다. 순서 결함을 controlled state 로 재현하려면 "초기 1회만 필터를 끄는" 인위적 분기가 필요해 채택하지 않았다 | AS-IS 자체의 초기화 순서 결함을 그대로 재현할지(인위적 분기 추가) 여부는 대안이 갈리고 AS-IS 재현이 바람직한지 불명確 — 절차 1 (b) 요건 충족, gap-resolve iter-1 에서 R3(사용자 확인 대기)로 이월 | 미구현 |
| I-2 | `ChangeSheet()`(615)가 `InitEvent()` 이전이라 I-1 이 자동 교정되지 않는다 | 동상(I-1 에 흡수) | I-1 에 흡수되는 동일 블로커 | 미구현 |

---

## 3. 영역3 — 그리드 (181행)

### 3.1 규칙 R-01~R-23 → 구현 위치

| # | AS-IS | TO-BE |
|---|---|---|
| R-01 Division 별 컬럼 표시 토글(cs:724-756) | `IndexOf("EE_UC")` / `IndexOf("EE")` / else 3분기로 CAPA·M_MIN·LANE·WIDE_YN 폭 토글 | **미구현** — hook #113 정본은 `SHEET_COLUMNS.DIVISION_ID` 서버 필터이고 현재 131행 전건 NULL 이다. `fetchStaticColumns` 가 `divisionId` 를 실어 보내는 배선은 완료했으나 메타가 비어 서버가 거르지 않는다. 컬럼명 화이트리스트·FALLBACK 대체는 hook #113 금지 → 04 ⑦ B-4 |
| R-02 조회 직후 전 컬럼 잠금(cs:1229-1230) | `LockColumn(0, max, true)` | **미이식** — 조회 직후 잠금 없음. `editableAt` 첫 가드는 `editMode`(=`canEdit` 권한)라 권한 있으면 바로 편집 |
| R-03 Edit 이 유일 해제 경로 | `SwitchLock` | **미이식** — Edit 버튼·토글 제거. `canEdit = hasButton('EDIT')` 권한으로만 갈린다 |
| R-04 시트별 고정 잠금 집합(cs:871-917) | `LockColumn` 45건 | `utils/optCapa.editLock.ts` `LOCKED_COLUMNS`. **파리티 정본은 `INPUT_TP_CD` 메타**(05_register 블록 3) — 이 배열은 메타 미적용 구간의 override 다(hook #130 사유 명시) |
| R-05 비EE_UC `LINE_TYPE` 잠금 + 기본값 `'-'`(cs:887·901·994·1017) | `!= "EE_UC"` 완전일치 | `isOptCapaCellEditable` LINE_TYPE 분기 + `handleInsert` 기본값 |
| R-06 Daily Capa × EE_UC 행 교차 잠금(cs:848-867) | 행 `OPERATION_ID=='E2000'` → CAPA 잠금 / else M_MIN·LANE·WIDE_YN | `isDailyCapaRowLocked()` |
| R-07 `LINE_TYPE` 콤보 EE_UC 한정(cs:3806-3818) | 주입 자체가 조건부 | `canInjectLineTypeCombo()` |
| R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573) | `dtLineAll` 전체 마스터 조회 | `deriveLineName()` (cellEditEnded) |
| R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-3580 → 3594-3616) | Plant 확인 후 Line 2단 조회. 못 찾으면 공백 | `deriveOperationByLine()` — 빈 문자열이 정답 |
| R-10 `PLANT_ID` 변경 → LINE 클리어(cs:3546-3567) | 새 후보에 없을 때만 | `shouldClearLineOnPlantChange()` — **포함되면 유지** |
| R-11 `ITEM_ID` 더블클릭 팝업(cs:3732-3765) | 3중 가드 + `ITEM_ID`+`NICK_NAME` 동시 채움 | `OptCapaGrid` dblClick(헤더 아님 / 편집모드 / Daily Capa 제외) → `ItemByDivisionModal` → `handleItemSelect` (EditTracker 경유로 `CRUD_TYPE` 세움) |
| R-12 붙여넣기 `LINE_NAME` 재파생(cs:3638-3661) | 범위 순회, 빈 셀 skip | `pastedCell` 핸들러 |
| R-13 `NO_WORK_DATE`→`DAY_OF_WEEK`(cs:3619-3636) | `ToString("ddd", InvariantCulture).ToUpper()` | `dayOfWeekOf()` — `DAY_OF_WEEK_LABELS` 고정 배열(locale 의존 0) |
| R-14 행 추가 = 편집모드 전제(cs:928·983) | Daily Capa 무동작 | `handleInsert` |
| R-15 신규행 기본값(cs:992-1049) | 시트별 상이. **상위행 복사 아님** | `handleInsert` 의 `row` 객체 |
| R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876-918) | — | 행 상태 분기 없음 → `IM`/`IO` 미사용 |
| R-17 삭제 시트별 가드(cs:770-789) | Daily Capa 는 행 선택 + 저장된 행만 | `handleDelete` + `isPersistedRow()`. `deleteOnlyNew` 미사용(`'D'` = 물리 DELETE 실측) |
| R-18 셀 클릭 행 인덱스(cs:3768-3770) | `_currRowIdx` | `grid.selectedRows[0]` — 선택 없으면 무동작 |
| R-19 Plant 셀콤보 2차 제한(cs:394-432) | `CODE IN (조회조건 선택 Plant)` | `buildPlantCellCandidates()` |
| R-20 Line 셀콤보 EE_UC/Plant 2중(cs:473-505) | 행 `PLANT_ID` | `buildLineCellCandidates()` |
| R-21 Operation 후보 시트 의존(cs:507-543) | 82 × {Daily Capa, No Work} → SEQ=1 | `buildOperationCellCandidates()` |
| R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트) | 신규 즉시 / 수정은 키 변경 시만 | `useOptCapaValidation.findDuplicateKey()` + `utils/optCapa.save.ts` 키 산출(날짜 `-` 제거 환원 포함) |
| R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·2950-2986) | `MSG00105` / `MSG00108` | `findPeriodProblem()` — 대상 3시트만(`PERIOD_RANGE_COLUMNS`) |

### 3.2 SP (SP-01~SP-18) · 콤보공급 (CB-10~CB-26)

- GET 8 + SAVE 8 + `init` + EXCEL_UPLOAD 전건 배포·배선 완료(`MNU_BTN_MPG_M` 20행 + API_M 20행).
  파라미터·응답키는 `procedures.d.ts SCP0126` 에 `SCM_ADM_PROC_M.COL_NM` 실측값으로 고정.
- 셀 콤보 6종(`CB-10`~`CB-26` = `SetComBoParam` 11 + `SetComboDataRow` 6)은 **FE 주입**으로
  재현했다 — `OptCapaGrid.beginningEdit` → `column.dataMap`. CMBO_SQL 등록 0건(04 ④ G-1).

### 3.3 그리드 동작(behavior) 파리티 게이트 — `guides/grid-behavior-parity.md`

`.cs` + `.Designer.cs` 전수 grep 결과:

| 동작 | AS-IS 호출 | TO-BE |
|---|---|---|
| 셀 병합 | `FPMerge` / `SetToggleMerge` / `SmartColMerge` / `AllowCellOverflow` / `SpanModel` **전건 0** | **병합 없음**이 파리티. 공용 `DataGrid` 의 `allowMerging` prop 을 전달하지 않아 기본값을 유지한다 |
| Lock 계열 | `SwitchLock` 1 / `LockColumn` 45 / `LockRange` 20 | R-02·R-03·R-04·R-05·R-06 (`optCapa.editLock.ts` + `beginningEdit`) |
| 셀 타입 콤보 | `SetComboDataRow` 6 | R-07·R-19·R-20·R-21 (FE 주입) |
| 셀 타입 기타 | `SetCellType*` 0 / `cellTypeImage` 0 | 메타 `CELL_CONTROL_OBJECT_TYPE_CODE` 구동(현재 공란 — 04 ⑦ Q2) |
| 붙여넣기 | `ClipboardPasted` 1 | R-12 (`pastedCell`) |
| 데이터모델 이벤트 | `_defaultDataModel.Changed` 1 | R-13 (`cellEditEnded`) |
| 행 높이·색 | `SetBGColor`/`SetForeColor` = **주석 처리 블록 안에만**(cs:808-824) | **미해당** — 주석 코드 이식 금지 |

미매핑 0건.

---

## 4. 미해당 판정 모음 (무언 누락 금지)

| 항목 | 판정 근거 |
|---|---|
| `SCP0126_SingleDatePopup` | `SCP0126_CAPA.cs`·`SCP0126_NoWork_BatchPopup.cs` 참조 0건 + `.csproj` Compile 항목 부재 → 호출처 없음 |
| R08 탭 인덱스 음수 가드 | controlled state 라 음수 불가 |
| R19 `fps` 가드 2건 | 그리드 1개 단일 ref |
| hook #138 (`ACTIVE_YN` 삭제) | 적용 조건 2개 중 1개만 충족 — 조회조건에 `_Active` 항목 없음. SAVE `'D'` = 물리 DELETE 실측 |
| hook #68 (신규행 콤보 PARAM9) | 신규/기존 후보 동일(R-16) → 등록하면 오히려 AS-IS 불일치 |
| hook #92 (`DIVISION_ID` 콤마토큰 구방식) | 메타 전건 NULL — 대조 대상 없음. #113 우선 |
| hook #81 (탭 구동 lazy fetch) | 8탭이 독립 마스터라 공유 컨텍스트 없음. 붙이면 AS-IS 에 없는 SP 호출 7건 발생 |
| 주석처리된 `lciNickName`/`lciModel` 숨김 코드(cs:3702·3723) | 현행 AS-IS 는 두 필드를 항상 보여주고 값만 공백 전송 → 이식 금지 |
| 주석처리된 `division=="40"` 구버전 탭 분기(cs:3465-3522) | 제외목록 도입 전 잔재 → 이식 금지 |
| `Preparation Rate` 탭 | 제외목록 실측상 등록 7 division 전건 제외. 미등록 7 division 에서만 나타난다 → 04 ⑦ V-1 |
| hook #92 → **#113 로 전환 완료**(iter-3) | 메타 전건 NULL 이 아니게 됐다 — `05_register.sql [블록 4]` 적용으로 Daily Capa 4컬럼에 콤마토큰이 실렸고, 서버 `PR_GET_SHEET_COLUMN_LIST` BODY:165·215 의 `INSTR` 술어가 거른다. 위 줄의 "대조 대상 없음" 은 iter-2 까지의 상태다 |

---

## 6. iter-3 추가 매핑 (2026-09-26 — iter-2 감사 G2-1·G2-2 / 사용자 판정 D-1~D-4)

### 6.1 `Save_DailyCapa` 저장 규칙 6건 — iter-2 까지 **전건 미이식**

이 6건은 설계 3문서(`01`~`03`)가 규정하지 않은 규칙이다(설계 자체의 누락 — 감사 G2-1 지적).
AS-IS `Save_DailyCapa`(cs:1488-1802) 전문 직접 read 로 도출했다.

| AS-IS | 내용 | TO-BE |
|---|---|---|
| cs:1558 | `valid_yn == "" ? "Y"` — I/M/D 분기 **바깥**(삭제행도 대상) | `utils/optCapa.save.ts` `applyDailyCapaSaveRules` 1번 |
| cs:1561 | 기본값·필수검증은 `FlagI‖FlagM` 행만 | 동 — `activeFlag === 'D'` 조기 반환 |
| cs:1564 | `pre_key_values.Split('|')[0] == ""` → `action = FlagI` | 동 2번. 근거: `GET_DAILY_CAPA` 가 원장을 OUTER JOIN(`PKG_SCP0126` BODY:694-699)해 **미저장 조합**까지 행으로 내려주므로, 그 행 편집 시 `'M'` 이 서고 그대로 보내면 UPDATE 0건으로 입력이 소실된다 |
| cs:1569 | `division_id == "EE" ‖ (== "EE_UC" && operation_id == "E2000")` | `isElectrodeCapaRow()` — **행의** `DIVISION_ID` 완전일치. 조회조건 division 아님 |
| cs:1599 | 전극 분기 → `capa = "0.0"` | 동 3번 — `DAILY_CAPA_SAVE_DEFAULT.CAPA` |
| cs:1662-1664 | 그 외 → `m_min="0"`, `lane="0"`, `wide_yn="Y"` | 동 3번 |

전수 확인: 위 패턴은 8 `Save_*` 중 `Save_DailyCapa` **1곳에만** 있다(grep 실측 — `valid_yn == "" ? "Y"` 1건,
`Split('|')[0] == ""` 1건). 나머지 7시트는 **미해당**이며 무언 누락이 아니다.

### 6.2 필수검증 4건 — AS-IS 상호배타(사용자 판정 D-3)

| AS-IS | 판정 함수 | TO-BE |
|---|---|---|
| cs:1573-1580 `M_MIN` | `string.IsNullOrEmpty` | `findMissingRequired` — 전극 분기 1번 (`isEmpty`) |
| cs:1582-1588 `LANE` | `string.IsNullOrWhiteSpace` | 동 2번 (`isBlank`) |
| cs:1590-1596 `WIDE_YN` | `string.IsNullOrWhiteSpace` | 동 3번 (`isBlank`) |
| cs:1654-1659 `CAPA` | `string.IsNullOrEmpty` | 동 비전극 분기 (`isEmpty`) |

**정정(iter-4, 감사 G3-1 / 사용자 판정 D-3′)**: 위 4건은 **Daily Capa 분기 전용**이고
"나머지 7시트는 클라 필수검증 0건" 은 **오측이었다**. AS-IS 는 `MSG00002` 를 화면 `.cs` 에서 직접
띄우지 않고 공용 헬퍼가 띄운다 — `DataUtil.checkRequiredOfSpread(siMain)` 호출이 **라이브 7건**
(cs:1311 NoWork · 1866 SopEop · 2089 Rampup · 2390 RampupItvl · 2648 PrepRt · 2907 UtilRt ·
3160 Yield)이고 **Daily Capa 만 주석처리**(cs:1572)다. 헬퍼 본문
(`01.Framework/GSCM.Windows.Forms/Class/DataUtil.cs:23-65`) = `action=='D'` skip → 헤더 라벨에 `*`
없으면 skip → `IsNullOrWhiteSpace` → `MSG00002` + 중단.

→ TO-BE 배선: `saveWithValidation(dirty, sheet === DAILY_CAPA ? [] : staticColumns[sheet], cb)`
(`hooks/useOptCapaActions.ts`). 공용 `isMandatoryColumn`(`inputTpCd` M/IM **또는** 라벨 `*`)이
AS-IS 술어와 동치이고, 숨긴 컬럼·`S` 컬럼은 공용 훅이 거른다.
i18n = `MSG00429`(`{0} value is required.`) — 공용 `CRUD_MSG.REQUIRED_FIELD.id` 와 같은 값이라
경로별 문구가 갈리지 않는다. AS-IS 번호 `MSG00002` 직접 사용 금지(TO-BE 는 정반대 의미).

### 6.3 의도적 차이 (사용자 확정 — 파리티 미일치를 알고 남긴다)

| 항목 | AS-IS | TO-BE | 근거 |
|---|---|---|---|
| `editMode`(Edit 잠금 토글) 전체 | `EditButton`→`SwitchLock`, `Save_*`/`Insert_Row` 의 `IsLock` 가드 | **미이식** — Edit 버튼·`editMode` store·토글 제거. 편집 가능 여부는 `canEdit = hasButton('EDIT')`(mount 1회 권한)만. Save/Delete/Insert 는 `!canEdit` 일 때만 무동작, grid 는 `editMode={canEdit}` 를 받는다 | **사용자 결정(2026-09-29)** = convert-core §2.4 공통 규범(선례 SCP0120·SSP0025). **이 결정이 D-4 를 뒤집는다** — D-4 의 "editMode 가드 유지" 는 무효. 탭 전환만 미저장 변경(dirty)으로 가드(위 BG-08) |
| `findDuplicateKey` 가 Daily Capa 에도 적용 | `Save_DailyCapa`(cs:1488-1800) 구간에 `MSG00260`/`MSG00443` **0 hit** | 시트 무관 적용 | **iter-4 확정(감사 G3-9)**: 키 6종이 전건 `INPUT_TP_CD='S'` 라 사용자가 바꿀 수 없어 오탐 확률이 0 에 가깝고, SAVE SP `'I'` 분기가 같은 6키 중복을 `C_MSG_DUP_I` 로 되돌린다(BODY:2972-2986) — FE 는 그 서버 방어의 문구를 앞당겨 보여주는 역할이다 |
| 기간 중첩·역전 대조 원천 | **조회 스냅샷**(`dtRampupAll` 등, cs:1206-1240 Copy) | **라이브 그리드**(`collectionView.sourceCollection`) | **iter-4 확정(감사 G3-11 ②)**: 같은 배치에서 두 행 기간을 함께 고치면 TO-BE 만 차단한다. TO-BE 가 더 엄격해 잘못된 마스터 적재를 막으므로 유지. 검사 **순서**(중첩 → 역전)는 AS-IS 로 맞췄다(G3-11 ①) |
| `ROUTE_PATH` `'supply/opt-plan/opt-capa'` → `'supply/opt-capa'` | 3단 | 2단 | **사용자 판정 D-1**(사후 승인). skill §2.7 규정 + `viewRegistry` 1순위 키 형식 |

### 6.4 `SetVisibleSheetColumns`(cs:724-756) R-01 — iter-3 해소

AS-IS 부분문자열 비교를 TO-BE 서버 술어(콤마 토큰 **완전일치**)로 옮기기 위해 division 14종
(`SCM_MST_DIVISION VALID_YN='Y'` 실측)을 전개했다. FE 컬럼명 화이트리스트·FALLBACK 0건 — 서버가 거른다.

| AS-IS 분기 | 해당 division | 메타 적재 |
|---|---|---|
| cs:731 `IndexOf("EE_UC")>=0` → 4컬럼 표시 | `EE_UC` | CAPA·M_MIN·LANE·WIDE_YN 토큰에 모두 포함 |
| cs:739 `IndexOf("EE")>=0` → CAPA 숨김 | `EE`,`EE_HD`,`EE_HG`,`EE_HM`,`EE_ST` | M_MIN·LANE·WIDE_YN 에만 포함 |
| cs:746 else → CAPA 만 표시 | `40`,`81`,`81_HD`,`81_HG`,`81_HM`,`81_ST`,`81_UC`,`82` | CAPA 에만 포함 |

---

## 5. 카운트 대사

| 영역 | 대상 | 소진 | 미해당(근거 기재) |
|---|--:|--:|--:|
| 1 Layout | 45 | 45 | 6 (C-01·C-21·C-23·C-25 / BG-01·02·06 중 3) |
| 2 조회조건 | 35 | 35 | 0 |
| 3 그리드 | 181 | 181 | 5 (hook #138·#68·#92 + 주석코드 2) |
| 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2) | 10 | 10 | 7 (`Save_DailyCapa` 외 7시트 = 대응 코드 0건) |
| **계** | **271** | **271** | **18** |

iter-2 까지의 "미구현 1건 = R-01" 은 **iter-3 에서 해소**됐다(§6.4 — `05_register.sql [블록 4]` 적용 +
재조회 확인). FE 우회는 여전히 0건이고 서버가 거른다.

의도적 차이 2건은 §6.3 에 근거와 함께 기재했다(무언 누락이 아니다).
