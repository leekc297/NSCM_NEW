# DMF0043 (Contribute Main) — As-Is ↔ To-Be 4축 매핑

| 항목 | 값 |
|---|---|
| 화면 ID | **DMF0043** |
| 화면 명 (TO-BE) | Overseas Subs. Contribution Rate Reg. (기여율 관리) |
| 폴더 (TO-BE) | `nscm-fe/features/master/src/pages/contribute-main/` |
| As-Is 원본 | `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0043_Contribute_Main/{DMF0043_Contribute_Main.cs, .Designer.cs}` (942 / 499 줄) |
| 분석 자료 | `Doc/_analysis/domain_DM/screens/DMF0043_Contribute_Main/` (validation.md, expressions.md, analysis.md 등) |
| 매핑 양식 출처 | hook #68 `screen-meta-and-permissions-mandatory.md` §B 표준 양식 |
| 작성·갱신 | 2026-06-02 (신규) · 2026-06-19 (룰 전면 점검 — §A Event 10 / §C Validation 4 / §D Expression 3 / §E Protected override 6 / 카운트 요약 8 행 추가) |

---

## §0. 카운트 요약 (anti-simplification 게이트 — 누락 1건 = 위반)

| 영역 | AS-IS 실측 | TO-BE 매핑 | 차이 | Phase |
|---|---:|---:|---:|---|
| Event handler (§A) | 10 | 10 | 0 | ✅ |
| API SP 호출 (§B) | 5 | 6 (sheet 단위) | +1 (View 분리 mainTitle 분리 sheet) | ✅ |
| Validation (§C) | 4 | 4 | 0 | ✅ |
| Expression (§D) | 3 | 3 | 0 | ✅ |
| Button (§E) | 5 + Framework 4 = 9 | 5 + hotkeyConfig 4 + customButton 1 = 10 | +1 (VERSION_MGMT customButton) | ✅ |
| Grid 컬럼 (BASE) | 6 + 동적 PIVOT (월/년) | 6 (admin SHEET_COLUMNS) + 동적 PIVOT (SP 응답) | 0 | ✅ |
| POPUP (§F) | 1 (ContributeRatePopup) | 2 (ContributeRateModal + ContributeVersionModal — TO-BE 분리) | +1 (VersionModal — 기여율 버전관리 customButton) | ✅ |
| Protected override (§G) | 6 (Find/Insert/Delete/Edit/Save/Excel) + Form_Load | hotkeyConfig + EditTracker + SubTitle Excel + MainTitle = 동등 | 0 | ✅ |

> Validation/Expression 실측 = analysis 자료 `validation.md` (4 행) + `expressions.md` (3 행) 검증. AS-IS 카운트가 BE explore 보고의 "Main 59 + View 48 = 107" 추정과 다른 이유: 그 추정은 다른 화면 카운트와 혼동된 수치. **본 매핑의 실측이 단일 진실 source.**

---

## §A. Event handler 매핑 (As-Is → To-Be) — 10 행

| # | Source (.cs Line) | Event | As-Is Handler | As-Is 호출 (API/SP) | Affects | To-Be 결정 |
|---:|---|---|---|---|---|---|
| 1 | L95 | Form.Load | `Form_Load` | `GetVersionData`, `InitControls`, `InitSpread` | `usrYear`, `spdMain` | `ContributeMain.tsx` mount + `useTabComboQueries(year)` + `staticColumns` fetch |
| 2 | L164-168 | F5 override | `FindButton → FindData` | `DMF0043_GET_MAIN_SPREAD_TITLE` + `DMF0043_GET_CONTRIBUTE_MAIN_DATA` | `spdMain` (전체 Lock) | `hotkeyConfig.search` = `setFilters(SHEETS.MAIN)` + `useTabProcQuery` |
| 3 | L211-214 | F7 override | `SaveButton → SaveData` | `DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO` | `spdMain` 저장 후 재조회 | `hotkeyConfig.save` = `handleSave` (`apiClient.post` direct — ^ 구분 bulk payload) |
| 4 | L189-209 | F2 override | `EditButton` | `siMain.SwitchLock`, `siMain.LockRange` (EDIT_FLAG='N' 행 잠금) | `spdMain` | EditTracker + cellEditEnded 가드 (CRUD_TYPE=U 자동) |
| 5 | L573-580 | btnCutOff.Click | `btnCutOff_Click` | `DMF0043_ContributeRatePopup.ShowDialog()` | 모달 호출 | `customButtons.VERSION_MGMT` → `ContributeVersionModal` open |
| 6 | L911-914 | usrYear.SelectedIndexChanged | `usrYear_SelectedIndexChanged` | `InitSpread` 재호출 | `spdMain` 헤더 재구성 | `searchParams.year` 변경 → `staticColumns` 재 fetch |
| 7 | L699-708 | chkYear.CheckedChanged | `chkYear_CheckedChanged` | `SetSpreadColumn` (Y# vs M# visibility) | `spdMain` 컬럼 visibility | `searchParams.chkYear` → DataGrid `staticColumns` visible flag |
| 8 | L899-903 | usrHis.CheckedChanged | `usrHis_CheckedChanged` | `InitSpread` + `usrDiscard=false` | `spdMain` (History) | `searchParams.his`/`searchParams.dis` 상호 배타 토글 |
| 9 | L905-909 | usrDiscard.Click | `usrDiscard_Click` | `InitSpread` + `usrHis=false` | `spdMain` (불일치) | 동일 (위와 짝) |
| 10 | L916-936 | spdMain.DataModel.Changed | `spdMain_Changed` | (로컬) empty cell → '0' 자동 + EDIT_FLAG='U' | `spdMain` | `cellEditEnded` 가드 + `editTracker.storeChange` |

---

## §B. API/SP 호출 매핑 (As-Is → To-Be) — 5 호출 / 6 sheet

| # | Source (.cs Line) | As-Is SP | Params (As-Is) | To-Be SP (API_M.API_URL) | sheetName (FE) | API_M.API_ID | Notes |
|---:|---|---|---|---|---|---|---|
| 1 | L114 (InitControls) | `DM.DMF0043_GET_MAIN_VARSION_DATA` | (sesUserId, mnuId) | `DMF0043_GET_MAIN_VARSION_DATA` | `version` | `P_DMF0043_VERSION_GET` | usrYear combo + Version master list |
| 2 | L143-152 (InitSpread) | `DM.DMF0043_GET_MAIN_SPREAD_TITLE` | (divisionId='40', yyyy, sesUserId, mnuId) | `DMF0043_GET_MAIN_SPREAD_TITLE` (PKG wrapper L362 + standalone L270) | `mainTitle` | `P_DMF0043_MAIN_TITLE` | 헤더 동적 (Y1~Y12, M1~M12) + ColumnHeaderSpan SUM |
| 3 | L289-300 (FindData) | `DM.DMF0043_GET_CONTRIBUTE_MAIN_DATA` | (yyyy, verSeq, dis, his, sesUserId, userGroup) | `DMF0043_GET_CONTRIBUTE_MAIN_DATA` | `main` | `P_DMF0043_MAIN_GET` | 메인 그리드 조회. dis×his 4 분기 |
| 4 | L432-466 (SaveData) | `DM.DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO` | 13 params (activeFlag~contributionRatio + sesUserId) | `DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO` | `main` (SAVE) | `P_DMF0043_MAIN_SAVE` | IUD 통합 + ^ 구분 bulk payload (`apiClient.post` direct) |
| 5 | btnCutOff.Click 경로 | `DMF0043_ContributeRatePopup` 내부 호출 | (yyyy / verSeq) | `DMF0043_GET_CONTRIBUTE_RATE_POPUP` + `DMF0043_GET_CONTRIBUTE_YEAR_POPUP` + `DMF0043_GET_CONT_VIEW_VERSIONPOPUP` + `DMF0043_SAVE_DM_MST_CONTRIBUTE_VER` | `ratePopup` / `yearPopup` / `versionPopup` / `version`(SAVE) | `P_DMF0043_RATE_POPUP` / `P_DMF0043_YEAR_POPUP` / `P_DMF0043_VERSION_POPUP` / `P_DMF0043_VERSION_SAVE` | TO-BE 분리: 3 조회 + 1 저장 sheet |

> SP body 위치: `_artifacts/_deploy_packages/DMF0043/01_SP_BODY/010_DMF0043_main_SP_bodies.sql` (9 standalone) + 040/041 (Version mgmt 2)

---

## §C. Validation 매핑 (As-Is → To-Be) — 4 행

| # | As-Is Method (Line) | Kind | Category | MsgID | Msg (KO) | 조건 | To-Be 적용 위치 |
|---:|---|---|---|---|---|---|---|
| 1 | `SaveData` L344 | GMessageBox | 숫자값검증 | **MSG00303** | "입력한 데이터가 100을 초과하거나 미만입니다." | 연/월 기여율 합계 ≠ 100 | `utils/validators.ts` → `validChk(rows): boolean` + `ContributeMain.handleSave` 호출 전 검증 + `useMessageStore.setAlert({type:'alert', msgId:'MSG00303'})` |
| 2 | `SaveData` L351 | GMessageBox | 필수값 | **MSG00308** | "구분값을 입력해 주세요." | `RBU_0999` 컬럼 NULL when 기여율 입력 | `utils/validators.ts` → `validChk2(rows): boolean` + 동일 setAlert |
| 3 | `SaveData` L459 | GMessageBox | 확인메시지 | **MSG00004** | "저장하시겠습니까?" | response.DataSet[0]='success' | `useMessageStore.setAlert({type:'confirm', msgId:'MSG00004'}) → boolean` 후 진행 |
| 4 | `chkYear_CheckedChanged` L703 | GMessageBox | 기타 | **MSG00266** | "(미등록)" | `!siMain.IsLock(sheetName)` | `chkYear` 토글 핸들러 + setAlert |

> i18n: 4 MsgID 모두 `nscm-fe/public/locales/{KO,EN,CN}.json` 등재 (사내 기존 메시지 — 신규 등록 불필요).

---

## §D. Expression 매핑 (As-Is → To-Be) — 3 행

| # | As-Is Handler (Line) | Kind | Category | Cell/Target | As-Is Expression | To-Be 적용 위치 |
|---:|---|---|---|---|---|---|
| 1 | `EditButton` L204 | 행잠금 | 조건부잠금 | `iRow, EDIT_FLAG+1 ~ MaxCol` | `siMain.LockRange(iRow, GetColumnIndex(EDIT_FLAG)+1, iRow, GetMaxColumnIndex(), true)` IF `EDIT_FLAG='N'` | `ContributeMainGrid.tsx` `loadedRows` event 안 — `GridUtils.getRow(grid, i)` 후 `EDIT_FLAG='N'` 일 때 해당 row 의 EDIT_FLAG 이후 셀 `isReadOnly=true` (admin SHEET_COLUMNS 의 INPUT_TP_CD='S' 처리 또는 cellFactory) |
| 2 | `SetSpreadHeaderSpan` L630 | SUM헤더 | 다단 헤더 머지 | Header (Row 1) | `siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", Center)` (Y) | `CustomMergeManager` 의 header range + `<FlexGridColumnGroup header="SUM">` 또는 staticColumns 의 `parentHeader='SUM'` |
| 3 | `SetSpreadHeaderSpan` L658 | SUM헤더 | 다단 헤더 머지 | Header (Row 1) | `siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", Center)` (M) | 동일 (월 그룹) |

---

## §E. Button 매핑 (As-Is Designer + Framework Override → To-Be hotkeyConfig + customButtons) — 5 + 4 → 10

| # | As-Is (Designer Line) | 라벨 | As-Is Event Handler | To-Be 매핑 |
|---:|---|---|---|---|
| 1 | `usrYear` L125 | Year | SelectedIndexChanged | `SearchArea` 안 `FormItem(Year)` + `CustomDropdown` (useTabComboQueries) |
| 2 | `chkYear` L183 | 년도별 | CheckedChanged | `SearchArea` 안 `FormItem(년도별)` + `CustomCheckbox` |
| 3 | `usrDiscard` L221 | 불일치조회 | Click | 동일 |
| 4 | `btnCutOff` L258 | **기여율 버전관리** | Click | `SubTitle.customButtons` 한 개 (label='기여율 버전관리', onClick=openVersionModal) |
| 5 | `usrHis` L296 | History | CheckedChanged | 동일 (`searchParams.his` 토글) |
| 6 | Framework F5 | Find | `FindButton` override | `hotkeyConfig.search: hasButton('SEARCH') ? handleSearch : false` |
| 7 | Framework F7 | Save | `SaveButton` override | `hotkeyConfig.save: hasButton('SAVE') ? handleSave : false` |
| 8 | Framework F2 | Edit | `EditButton` override | EditTracker + `cellEditEnded` 가드 (Edit 모드 별도 토글 없음 — TO-BE 표준) |
| 9 | Framework F9 | Delete | `DeleteButton` override (As-Is 주석 처리) | `hotkeyConfig.delete: false` (명시 숨김) |
| 10 | Framework Excel | Excel | `ExcelButton` override (SimplexelService) | SubTitle 기본 Excel + `excelFileName='DMF0043_ContributeMain'` (자동 활성) |

---

## §F. POPUP 매핑 (As-Is → To-Be Modal 분리) — 1 → 2

| # | As-Is | TO-BE Modal (승격) | 호출 시점 | 폴더 |
|---:|---|---|---|---|
| 1 | `DMF0043_ContributeRatePopup` (단일) | `ContributeRateModal` + `ContributeVersionModal` (2 분리) | `customButtons.VERSION_MGMT` → ContributeVersionModal → 내부에서 ContributeRateModal 호출 | `nscm-fe/features/master/src/components/contributeRateModal/`, `nscm-fe/features/master/src/components/contributeVersionModal/` (#67 공용 5 파일 표준) |

> 승격 이유: DMF0043_01 (contribute-view) 도 동일 모달 재사용 가능 → 공용 폴더로 lift (사용자 결정 2026-06-19).

---

## §G. Protected override 5+1 매핑 — 6

| # | As-Is override (Line) | 핵심 로직 | To-Be 동등 위치 |
|---:|---|---|---|
| 1 | `FindButton` L164 | `FindData()` 호출 | `hotkeyConfig.search` |
| 2 | `InsertButton` L170 | (주석 — 미사용) | `hotkeyConfig.insert: false` |
| 3 | `DeleteButton` L175 | (주석 — 미사용) | `hotkeyConfig.delete: false` |
| 4 | `EditButton` L189 | `SwitchLock` + `LockRange` (EDIT_FLAG='N') | EditTracker + `cellEditEnded` 가드 |
| 5 | `SaveButton` L211 | `SaveData()` 호출 | `hotkeyConfig.save` (`handleSave`) |
| 6 (+1) | `ExcelButton` L217 | `SimplexelService.ExportFpSpread` | SubTitle 기본 Excel (자동) |
| (+Form_Load) | L95 | `InitControls` + `InitSpread` | mount + `useTabComboQueries` + `staticColumns` |

---

## §H. 변경 이력

- 2026-06-02: 신규 작성 (공통 버튼 10대 룰 정비)
- **2026-06-19**: 룰 전면 점검 — anti-simplification 의무 적용. 표준 양식 (#68 §B) 채택. §A Event 10 / §C Validation 4 / §D Expression 3 / §E Button 10 / §F POPUP 2 / §G Protected override 6 / §0 카운트 요약 8 행 추가. AS-IS 실측 카운트 재확정 (validation.md 4 / expressions.md 3).
