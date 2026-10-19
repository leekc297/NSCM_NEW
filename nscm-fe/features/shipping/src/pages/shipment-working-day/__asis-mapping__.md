# SSP0005 Shipment Working Day — AS-IS ↔ TO-BE 매핑 매트릭스

- AS-IS 정본: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0005_ShipmentWorkingDay.{cs,Designer.cs}`
  (이하 `cs:n` = code-behind, `dsn:n` = Designer)
- 설계 근거: `.atlas/gscm-design/SSP0005/design/00_checklist.md` ~ `03_grid-columns.md`
- TO-BE 경로: `features/shipping/src/pages/shipment-working-day/`
- 작성: convert-react iter-1 · 2026-09-29

> 미이식 항목도 전건 "미이식 + 근거" 로 기재한다(조용한 제외는 커버리지 불인정 — convert-core §1).

---

## 1. controls (21건 — C01~C21)

| # | AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|:--:|
| C01 | `usrConditionPanel1`(HidePanel) | dsn:104-112 | `MainTitle openSearchArea` + `SearchArea isHidden` | 이식 |
| C02 | `usrLayoutControl2` | dsn:114-130 | `SearchArea conditions` 컨테이너. 권한 0건 시 전 필드 `disabled`(Form `disabled` prop) | 이식 |
| C03 | `layoutControlGroup2`(Root) | dsn:330-346 | `<Grid size={3}>` 격자(12-column) | 이식 |
| C04 | `layoutControlItem4` "Company" | dsn:428-440 | `FormItem label={t('LBL00047')}` | 이식 |
| C05 | `lcDivision` "Division" | dsn:396-406 | `FormItem label={t('LBL00001')}` — `LBL00641` 아님(커밋 a5b92cf0 표준화) | 이식 |
| C06 | `layoutControlItem6` "Period*" | dsn:382-394 | `PeriodField`(required 내장). `*` 는 라벨 문자열이 아니라 required prop | 이식 |
| C07 | `layoutControlItem1` "Day of the week" | dsn:356-368 | `FormItem label={t('LBL01067')}` | 이식 |
| C08 | `lcInputValue` "Input Value" | dsn:408-418 | `FormItem label={t('LBL01084')}` — 라벨이 D03 메시지 인자이기도 하다 | 이식 |
| C09 | `layoutControlItem10`(TextVisible=false) | dsn:370-380 | 조회조건 격자 6번째 칸(`Grid size={3}` + `commonStyles.customGrid`) — 라벨 없는 단독 버튼 칸 | 이식 |
| C10 | `emptySpaceItem1` | dsn:420-426 | 여백 전용 — React 대응물 없음(Grid 잔여 칸이 등가) | 미이식(해당 없음) |
| C11 | `emptySpaceItem2` | dsn:348-354 | 동일 — 여백 전용 | 미이식(해당 없음) |
| C12 | `btnInput` | dsn:132-166 / cs:316 | `ShipmentWorkingDayForm` 조회조건 6번째 칸 `<Button>`(Input Value 바로 옆 = AS-IS `Location(504,25)`) + `handleInputValue`. 최초 구현의 `extraButtons`(조회 버튼 옆) 배치는 05_runtime-parity L3 드리프트였고 2026-09-30 사용자 지시로 AS-IS 로 되돌렸다 | 이식 |
| C13 | `cboCompany`(UsrCombo) | dsn:294-328 | `CustomDropdown` 단일, `allOption` 없음. `ControlName="cboDivision"` 오설정은 이름만 잘못이라 무시 | 이식 |
| C14 | `clbDivision`(UsrCheckedList) | dsn:245-282 | `CustomDropdown multiple allOption` **다중 체크**(AS-IS `setListBox(dtMyDivision, clbDivision, true)`+`ClearUsrCheckedList(UsrCheckedList)` cs:148/164 = 다중. `ItemSelectionMode=One` 은 하이라이트 방식일 뿐 체크 제한 아님 — 종전 "단일" 오독 정정 2026-09-30) | 이식 |
| C15 | `drpPeriod`(UsrDateRangePicker) | dsn:204-243 | `PeriodField`(공용) — 표시 달력 2개, 값 `YYYYMMDD` | 이식 |
| C16 | `cboDayWeek`(UsrCombo) | dsn:168-202 | `CustomDropdown` + 콤보 `{comboId:'LookupCommon', lookupType:'WEEK_WORK_TIME'}`(ORDER BY DISPLAY_SEQ) | 이식 |
| C17 | `cboInputValue`(UsrComboBox) | dsn:284-292 | `CustomDropdown` + `YesOrNo` 콤보. 상시 enabled | 이식 |
| C18 | `spdMain`(FpSpread) | dsn:442-451 | 공용 `DataGrid`(`ShipmentWorkingDayGrid`) | 이식 |
| C19 | `spdMain_Sheet1`(SheetView) | dsn:453-491 | Designer 시트는 이름뿐 — 실 시트는 `AddSheet("Shipment Working Day", …)`(cs:179) → `SHEETS.MAIN` | 이식 |
| C20 | `components`(Container) | dsn:31 | WinForms 인프라 — 대응물 없음 | 미이식(해당 없음) |
| C21 | `usrButton1` | dsn:33·69-102·524 | **미이식(dead)** — 어떤 `Controls.Add` 에도 없고 Click 배선 0건. 부모 부착 자체가 없어 런타임 미렌더 | 미이식(근거 기재) |

## 2. events (5건 — E01~E05)

| # | AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|:--:|
| E01 | `CboDayWeek_SelectedIndexChanged` | cs:658-670 | Form `Day of the week onChange` → `setSearchCondition({ dayWeekCode, inputValue: '' })`. **분기와 무관하게 항상 리셋**(cs:669 1:1). enable 토글은 도달 불가 분기라 미이식(02 §3.2) | 부분이식(근거 기재) |
| E02 | `BtnInput_Click` | cs:671-822 | `handleInputValue` + `utils/shipmentWorkingDayBulkInput.ts` | 이식 |
| E03 | `SpdMain_CellDoubleClick`(헤더 드릴다운) | cs:834-861 | **미이식 — 사문 확정.** `M_`/`W_` 컬럼이 생성되지 않아(cs:253 이 `D_` 아닌 행 전건 skip + GET SP 의 `W_`/`M_` PIVOT UNION 이 AS-IS 원문에서 주석) 분기가 항상 false | 미이식(근거 기재) |
| E04 | `SpdMain_Changed` | cs:872-907 | **미이식** — `case CellsUpdated:` 본문이 비어 있어 실효 로직 0. 남은 것은 FarPoint 전용 재귀 방지/`AcceptChanges()` 관용구뿐이다. TO-BE 변경 추적은 공용 `EditTracker`(`CRUD_TYPE`) | 미이식(근거 기재) |
| E05 | `SpdMain_TopChange` | cs:319-323 | 공용 `CustomMergeManager` 가 viewport 재병합을 담당한다(`allowMerging` prop) — 화면 코드 불요 | 이식(공용 위임) |

## 3. validations (7건 — V01~V07)

| # | AS-IS MSG | 근거 | TO-BE | 상태 |
|---|---|---|---|:--:|
| V01 | `MSG00004` 저장 성공 | cs:555 | **`MSG00672`** Toast. 건수는 FE 카운트가 아니라 SP `RESULT_CNT`. TO-BE `MSG00004` 는 "No changes to save." 로 정반대라 재사용 금지 | 이식(번호 재매핑) |
| V02 | `GMessageBoxForException`(`iCount>0` 내부) | cs:563 | `postSave` catch + false-success 분기 → `MSG00618` | 이식 |
| V03 | `GMessageBoxForException`(outer catch) | cs:635 | 동일 catch 로 흡수 | 이식 |
| V04 | `MSG00135` 편집모드 아님 | cs:676 | 편집모드 축 폐기 → 판정축을 "조회 전"으로 치환, 문구 **`MSG00719`**("No data have been retrieved.", 사용자 확정 Q1). AS-IS 번호는 TO-BE 에서 의미가 반전된다 | 이식(축·번호 치환) |
| V05 | `MSG00093` `{0}` 선택 | cs:688 | **`MSG01122`** + 인자 `t('LBL01084')`(화면 라벨과 같은 키 — 하드코딩 금지) | 이식(번호 재매핑) |
| V06 | `MSG00134` 날짜 선택 후 입력 | cs:699 | **`MSG01153`**. 판정은 `hasCellRangeSelection(grid)`(`rowSpan>1 \|\| columnSpan>1`, `utils/shipmentWorkingDayBulkInput.ts:24-25`) — `selectedRanges.length===0` 은 Wijmo 에서 영구 false 라 폐기했다(Δ8) | 이식(번호 재매핑 + 판정축 근사) |
| V07 | `MSG00050` 숫자 형식 | cs:714 | **미이식 — 도달 불가.** `try` 블록(cs:708-717)에 숫자 파싱이 없어 `FormatException` 이 발생할 수 없다 | 미이식(근거 기재) |

## 4. spCalls (4건 — S01~S04)

| # | AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|:--:|
| S01 | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` | cs:403 | `useTabProcQuery(SHEETS.MAIN)` → `P_SSP0005_GET` (5 IN) | 이식 |
| S02 | SAVE(동적 QueryId) | cs:523·535-537 | `apiClient.post('/SSP0005/Shipment Working Day/SAVE/call-proc')` → `P_SSP0005_SAVE` (5 CLOB `^` + 3 스칼라) | 이식 |
| S03 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | cs:925 | `useTabProcQuery(SHEETS.CALENDAR)` → `SCP0009_SHEET_CALENDAR_3SPAN_GET`(공용 API 재사용) | 이식 |
| S04 | `SCP.SCM0001_GET_SCP_PERIOD` | cs:941 | `store.fetchDayRange()` → `/SSP0005/Shipment Working Day/GET_SCP_PERIOD/call-proc`. **dayjs 근사 금지** | 이식 |

## 5. comboCalls (5건 — B01~B05) · filterCalls 0건

| # | AS-IS | TO-BE SQL_ID | 상태 |
|---|---|---|:--:|
| B01 | `Data.Common(MyDivision, false, GroupID, UserId)` cs:45 | `MyDivision` — `ATTRIBUTE3<>'EE'`·`VALID_YN='Y'`·`NAME=ID||' '||MIN(NAME)`·`ORDER BY ATTRIBUTE1` 1:1 일치 확인. **`mnuId` 는 공용 `withMenuId` 가 자동 주입한다**(화면에서 끌 수 없다 — 02 §2.1 ④-b 의 "미전송"은 실현 불가). **실측 영향 2명**(gap-resolve iter-1 재실측 2026-09-29 — iter-2 의 "영향 0건" 은 반증됐다): SSP0005 오픈 가능 19명 중 `loveidea`·`test001` 은 메뉴를 `ADMIN` 그룹으로 열지만 Division unit auth 는 `SPMS ADMIN` 에만 있어 mnuId 게이트 교집합이 공집합 → 콤보 0행 → `noAuth` 발동으로 화면 전체 잠김. `dong.lee2` 는 게이트와 무관하게 unit auth 자체가 0(AS-IS 도 동일). 조치는 admin 권한 등록 축이다 → Δ7 | 이식(서술 정정) |
| B02 | `Data.Common(Company, false)` cs:46 | **`Company_SSP0005` 신설**(05_register.sql §5). 공유 `Company` 는 `NAME=COMPANY_ID` 라 AS-IS(`COMPANY_NAME`)와 표시가 다르고 소비자 2건이라 본문 수정 금지(hook #117) | 이식(화면 전용 분리) |
| B03 | `Data.Common(Data.Type.LookupCommon, false, "WEEK_WORK_TIME")` cs:47 | 콤보 `{comboId:'LookupCommon', lookupType:'WEEK_WORK_TIME'}` — AS-IS `LookupCommon` 데이터소스 = TO-BE `SCM_ADM_CMBO_SQL_M` SQL_ID='LookupCommon'(@lookupType, `ORDER BY B.DISPLAY_SEQ`)에 1:1. 종전 generic `useTabLookupQueries`(PR_GET_LOOKUP_INFO_LIST, 비정렬) 오이관 정정(2026-09-30 담당 확인) | 이식 |
| B04 | `Data.Common(YesOrNo)` cs:48 | `YesOrNo`(조회조건) + 그리드 동적 셀은 **리터럴 `dataMap:['Y','N']`**(동적 alias 라 메타 미등재) | 이식 |
| B05 | `Data.CallBizCommonData("PERIOD_"+value)` cs:910 | **미이식(dead)** — `SetChangedPeriod`(cs:909-919) 호출처가 `cs` 전문에 0건. 원의도는 `PERIOD_<value>` 기간 프리셋 | 미이식(근거 기재) |
| — | `filterCalls` | **0건**(`DBUtils.Filter`/`RowFilter` 미사용) — 클라 후처리 필터 재현 불요 | 해당 없음 |

cascade 체인도 0건이다(02 §3.1 7축 실측) — `useCascadeFields` 를 신설하지 않는다.

## 6. buttonGuards (10건 — D01~D10)

| # | AS-IS 조건 | 근거 | TO-BE | 상태 |
|---|---|---|---|:--:|
| D01 | `Columns.Get(0).Visible == false` | cs:673 | 판정축을 `rows.length === 0`(조회 전)으로 치환 + 버튼 `disabled={!canEdit}`. 문구 `MSG00719` | 이식(축 치환) |
| D02 | `!CanModelChange`(1회차) | cs:681 | `inputRunningRef` 재진입 가드 + `grid.deferUpdate()` 배치 | 이식 |
| D03 | `cboInputValue.SelectedValue == null` | cs:684 | `if (!sc.inputValue)` → `MSG01122` + `LBL01084` 인자 | 이식 |
| D04 | `pDayWeekCode == "SelectDay"` | cs:696 | `sc.dayWeekCode === DAY_WEEK.SELECT_DAY` 분기 | 이식 |
| D05 | `selCells.Length < 1` | cs:697 | `!hasCellRangeSelection(grid)` → `MSG01153`(Δ8 — `selectedRanges.length===0` 은 영구 false 라 쓰지 않는다) | 이식(근사 등가) |
| D06 | `IsNullOrEmpty(pDayWeekCode)` | cs:703 | 조용한 return 유지. 요일이 빈값이 될 수 없어 **도달 불가**이나, 제거하면 요일을 비울 수 있게 바뀔 때 구멍이 되므로 남긴다(코드에 주석 명기) | 이식(도달불가 명기) |
| D07 | `!CanModelChange`(2회차) | cs:720 | **D02 와 1회로 합침** — 두 지점 사이(cs:684-717)에 플래그를 바꾸는 코드가 없어 두 번째 검사는 항상 같은 결과다(정밀 read 확인) | 이식(중복 통합) |
| D08 | `ds == null` | cs:730 | **구조 복제 금지 — AS-IS 잠재 결함.** 직전 cs:725 가 `dsdm.Changed -=` 를 실행한 뒤라 여기서 return 하면 핸들러가 영구 미복구다. TO-BE 는 D01("조회 전이면 안내 후 무동작")로 단순화 | 미이식(결함 재현 금지) |
| D09 | `!CanModelChange`(Changed) | cs:873 | E04 미이식에 포함 | 미이식(근거 기재) |
| D10 | `ds == null`(Changed) | cs:885 | 동일. `finally { dt.AcceptChanges() }` 가 `dt` null 이면 NRE — 복제 금지 | 미이식(결함 재현 금지) |

## 7. gridSignals (24건 — G01~G24)

| # | AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|:--:|
| G01 | `SmartColMerge`(InitSpread) | cs:201 | 공용 `allowMerging={AllowMerging.All}` → `CustomMergeManager` | 이식(공용 위임) |
| G02 | 3단 헤더 `ForeColor` SAT/SUN | cs:265-268 | `formatItem` ColumnHeader 분기 + `binding -> DAY_CODE` 맵. SAT `#1e56c8` / SUN `#c0392b` | 이식 |
| G03 | `ColumnHeaderSpan`(월 span 마감) | cs:274 | `buildDayColumnTree` 월 그룹(연속 run) | 이식 |
| G04 | `ColumnHeaderSpan`(월 변경 시 주 span 동시 마감) | cs:280 | 월 그룹 안에서만 주차를 매칭 — 월 경계 강제 마감이 구조적으로 보장된다 | 이식 |
| G05 | `ColumnHeaderSpan`(주 변경) | cs:290 | 주차 그룹(연속 run) | 이식 |
| G06 | `ColumnHeaderSpan`(마지막 주 마감) | cs:301 | 루프 종료 = 마지막 그룹 close(트리 구조상 자동) | 이식 |
| G07 | `ColumnHeaderSpan`(마지막 월 마감) | cs:303 | 동일 | 이식 |
| G08 | `SmartColMerge`(TopChange) | cs:322 | 공용 처리(E05) | 이식(공용 위임) |
| G09 | `SwitchLock`(EditButton) | cs:353 | **미이식** — 편집모드 토글 폐기(convert-core §2.4). `canEdit = hasButton('EDIT')` 단일 축 | 미이식(근거 기재) |
| G10 | `LockColumn(COMPANY, DIVISION, true)` | cs:355 | **메타 등가** — `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD='S'` 실측 2행. FE 컬럼명 배열 하드코딩 금지(hook #130) | 이식(메타 위임) |
| G11 | `siMain.Query(dsBinding)` | cs:418 | `itemsSource={rows}`(`data.o_rc1`). 서버 데이터 store 금지 | 이식 |
| G12 | `LockColumn(0, max, true)`(조회 직후 전열 잠금) | cs:420 | **미이식** — G09 와 같은 축. 그대로 옮기면 편집이 영구 차단된다 | 미이식(근거 기재) |
| G13 | `SmartColMerge`(조회 후) | cs:424 | 공용 처리 | 이식(공용 위임) |
| G14 | `Columns.Get(0).Visible` | cs:673 | D01 축 치환 | 이식(축 치환) |
| G15 | `GetModelColumnFromViewColumn`(cRow) | cs:742 | **미이식(사문)** — 산출값 `cRow`/`cCol` 이 이후 한 번도 쓰이지 않는다(cs:744 이후 전부 원값 사용). Wijmo `selectedRanges` 는 이미 데이터 인덱스 | 미이식(근거 기재) |
| G16 | `GetModelColumnFromViewColumn`(cCol) | cs:743 | 동일 | 미이식(근거 기재) |
| G17 | `SetText` SelectDay + 행 선택 | cs:752 | `applyBulkInput` — 범위가 전 컬럼을 덮으면 행 선택으로 환산해 그 행의 모든 `D_` 에 write | 이식 |
| G18 | `SetText` SelectDay + 열 선택 | cs:766 | 범위가 전 행을 덮으면 열 선택으로 환산 → 전 행 × 선택 열 | 이식 |
| G19 | `SetText` SelectDay + 블록 | cs:780 | 범위 내 `D_` 셀 | 이식 |
| G20 | `SetText` EveryDay | cs:802 | 전 행 × 전 `D_` | 이식 |
| G21 | `SetText` 요일별 | cs:810 | `DAY_CODE` 대소문자 무시 일치 컬럼 × 전 행 | 이식 |
| G22 | `Visible=`(`M_` → `W_` 토글) | cs:840 | **미이식(사문)** — E03 동일 근거 | 미이식(근거 기재) |
| G23 | `Visible=`(`M_` → `D_` 숨김) | cs:843 | 동일 | 미이식(근거 기재) |
| G24 | `Visible=`(`W_` → `D_` 토글) | cs:854 | 동일 | 미이식(근거 기재) |

## 8. gridColumns (1건 — GC01)

| # | AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|:--:|
| GC01 | `AddComboColumn(label, name, FPMerge.None, 70, true, dtYesOrNo, Center, Center)` | cs:263 | 동적 leaf 컬럼: `width 70` / `align 'center'` / `_ctrlType: COMBO` / 리터럴 `dataMap:['Y','N']`. **`_ctrlData`(cellCboDataTp) 미세팅** — 값이 남으면 자동 콤보가 dataMap 을 덮어쓴다 | 이식 |

## 9. entryPoints (10건 — P01~P10)

| # | AS-IS | TO-BE | 상태 |
|---|---|---|:--:|
| P01 | `FindButton` cs:330 | `hotkeyConfig.search = hasButton('SEARCH') ? handleSearch : false` | 이식 |
| P02 | `InsertButton` cs:335 | `insert: () => undefined` — 버튼 노출 + 무동작. `false`(숨김)도 키 생략(공용 `addRow` 부활)도 오답 | 이식(NO-OP 재현) |
| P03 | `DeleteButton` cs:340 | `delete: () => undefined` — 동일 | 이식(NO-OP 재현) |
| P04 | `EditButton` cs:346 | `hotkeyConfig` 에 `edit` 키를 두지 않는다(`Hotkeys` enum 미등재 = 죽은 키). `customButtons` 로도 만들지 않는다 — 편집모드 토글 미이식. `EDIT` 는 권한축으로만 생존 | 부분이식(권한축만) |
| P05 | `SaveButton` cs:360 | `save: hasButton('SAVE') && canEdit ? handleSave : false` → `useSaveWithValidation` 경유 | 이식 |
| P06 | `BtnInput_Click` cs:671 | `handleInputValue` | 이식 |
| P07 | `CboDayWeek_SelectedIndexChanged` cs:658 | Form onChange | 이식 |
| P08 | `SpdMain_CellDoubleClick` cs:834 | 미이식(E03 사문) | 미이식(근거 기재) |
| P09 | `SpdMain_Changed` cs:872 | 미이식(E04 본문 공란) | 미이식(근거 기재) |
| P10 | `SpdMain_TopChange` cs:319 | 공용 병합 위임(E05) | 이식(공용 위임) |

## 10. popups (2건 — U01·U02)

| # | AS-IS | TO-BE | 상태 |
|---|---|---|:--:|
| U01 | `ProgressForm`(FindData_Main) cs:372 | 업무 팝업이 아니라 로딩 인디케이터 — react-query `isFetching` 이 등가 | 이식(공용 위임) |
| U02 | `ProgressForm`(SaveData_Main) cs:438 | `savingRef` in-flight + 공용 로딩 | 이식(공용 위임) |

업무 팝업은 **0건**이다 — 화면 전용 모달을 만들지 않는다.

## 11. toolbarOverride 판정 (OV1~OV5)

§9 P01~P05 와 동일 행이다. NO-OP 2건(OV2/OV3) · 실동작 3건(OV1/OV4/OV5) — OV4 만 미이식(편집모드 축).

## 12. 백본 밖 편입 (A01~A17)

| # | 항목 | TO-BE | 상태 |
|---|---|---|:--:|
| A01 | 실 SAVE SP ID(동적 QueryId) cs:535-537 | `SHEETS.MAIN` + `SAVE` 버튼코드 → `P_SSP0005_SAVE` 메타 배선 | 이식 |
| A02 | 필수값 검증 2건 cs:377·456 | 조회측 = Division 권한 게이트 + Period 빈값 가드(의도적 강화) / 저장측 = `useSaveWithValidation` | 이식 |
| A03 | `cboInputValue.DataBind(YesOrNo)` cs:168 | `YesOrNo` 콤보 | 이식 |
| A04 | Division 권한 게이트 cs:161-162 | **2중**: mount 안내 1회(`MSG00667`, `useRef` 가드) + `handleSearch` 차단 + `enabled` 게이트 | 이식 |
| A05 | `UnFilterInsertRow = true` cs:124 | Insert 가 NO-OP 라 신규행이 생기지 않아 실효 없음. 컬럼셋은 조회 발사 시점 스냅샷으로만 재구성 | 미이식(실효 없음) |
| A06 | 저장 대상 = action AND 글자색 Red cs:491-492 | **색상 축 폐기** — `CRUD_TYPE`(EditTracker) 단일 축. btnInput 도 `storeChange` 를 반드시 태워 AS-IS 가 빠졌던 함정을 구조적으로 차단 | 미이식(축 치환) |
| A07 | `iCount==0` 시 첫/끝 행 플래그 cs:514-515 | **미이식 — AS-IS 결함 재현 금지.** `if (iCount>0)` 밖에서 `Rows[0]`/`Rows[iCount-1]` 접근 → 0건이면 예외. TO-BE 는 0건이면 조기 반환 + `MSG00152`. TO-BE SAVE SP 에 `P_FIRST_ROW`/`P_LAST_ROW` 인자 자체가 없다 | 미이식(근거 기재) |
| A08 | dead 메서드 3건(`ClearUsrCheckedList`·`InsertRow`·`SetChangedPeriod`) | 전건 미이식 — 호출처 0건 / 본문 전체 주석 | 미이식(근거 기재) |
| A09 | `DefineProperty()` 빈 본문 cs:142-144 | 대응물 없음 | 미이식(해당 없음) |
| A10 | `AddSheet(…, 3, 1, 35)` cs:179 | 헤더 3단 → 총 48px(hook #93 P-B). depth 는 라벨 메타/3SPAN 응답에서 파생 — `3` 리터럴 미이식. **공용 `headerRowHeight` prop 은 쓰지 않는다** — `rows.defaultSize` 만 세팅해서 정적 2열(메타가 `colLblNm=sCls=lCls` 로 같아 `getColumnDepth`→1단)에 박히는 명시 `height:48` 잔여를 못 덮고 48+16+16=**80px** 이 됐다(2026-09-30 사용자 보고). `ShipmentWorkingDayGrid` 의 단일 `updatedLayout` effect 가 `rows[i].height = 48/실제 행수` 까지 강제한다. frozen 은 AS-IS 도 `Freeze()` 가 주석이라 메타 `FIXED_FLAG` 위임(= 2) | 이식(메타 위임) |
| A11 | 고정컬럼 DB 메타 구동 cs:196 | admin `/column` 응답 그대로 소비. 리터럴 `AddComboColumn("Company",…)` 는 AS-IS 도 주석 | 이식 |
| A12 | `B_` 컬럼 분기 cs:257-261 | **미이식(도달 불가)** — 조건이 `IndexOf("B_") > 0` 인데 이미 `D_` 로 시작하는 이름만 남아 성립 불가, 본문도 주석 1줄 | 미이식(근거 기재) |
| A13 | `D_` 이외 컬럼 전건 skip cs:253 | `toDayColumns` 가 `/^D_\d{8}$/` 만 통과시킨다 | 이식 |
| A14 | 컬럼 Tag 접두가 로직 키 | `DAY_BINDING_RE` 단일 상수로 전 경로(저장·대량입력) 공유 | 이식 |
| A15 | `GetDayOfWeek` = dsSpdTitle 역조회 cs:824-830 | `Map<binding, DAY_CODE>`. AS-IS 는 null 체크 없이 `dr["DAY_CODE"]` 접근해 미매칭 시 NRE — TO-BE 는 `?? ''` 방어 | 이식(결함 보완) |
| A16 | `drpPeriod.InitValue` 포맷 cs:170 | `'YYYYMMDD:YYYYMMDD'` split → store `fromYyyymmdd`/`toYyyymmdd`. 표시는 `PeriodField` 달력, payload 는 `YYYYMMDD` | 이식 |
| A17 | `spdInfo` vs `siMain` 는 같은 시트 | 그리드는 1개다 — 오독 방지 기록 | 해당 없음(기록) |

---

## 13. 의도적 델타 (AS-IS 와 다름 — 근거 명시)

| # | 델타 | 근거 |
|---|---|---|
| Δ1 | `Period*` 빈값 조회 **차단** | AS-IS 는 `UsrDateRangePicker` 브랜치 부재로 미차단(사문)이었으나 `InitValue` 가 항상 채워 빈값이 구조적으로 없었다. TO-BE 는 비울 수 있어 전기간 스캔 위험 → 사용자 확정(2026-09-29, Q4)으로 가드 추가 |
| Δ2 | 편집 기본 ON(모드 토글 미이식) | convert-core §2.4 사용자 지시(2026-09-25) |
| Δ3 | 저장 건수 = SP `RESULT_CNT` | AS-IS 는 FE 카운트(`iCount`)를 썼다. SP 값이 실제 갱신 행수라 더 정확 |
| Δ4 | btnInput 입력분이 반드시 저장 대상에 포함 | AS-IS 는 `SetText` 가 `Modify()` 를 거치지 않아 저장에서 빠졌을 가능성이 있다(런타임 미확정, 03 §6-E01). TO-BE 는 `EditTracker.storeChange` 필수라 구조적으로 재발하지 않는다 |
| Δ5 | Company 표시값 = `COMPANY_NAME` | TO-BE 공유 `Company` 콤보는 `NAME=COMPANY_ID` 라 AS-IS 와 다르다. 화면 전용 `Company_SSP0005` 신설로 AS-IS 패리티 + 정렬 결정성 확보(사용자 확정 Q3) |
| Δ6 | 빈 `D_` 셀 변경건 전송 제외 | SP 가 NULL 로 UPDATE → `WORKDAY_YN` NOT NULL → ORA-01400 전건 롤백. FE 가 사전 차단. 안내는 원인 축(`MSG00614` + `LBL00069` 'Date')로 표기한다 — iter-1 은 조회조건 `Input Value` 를 가리켜 사용자를 엉뚱한 곳으로 보냈다(iter-2 G7) |
| Δ7 | `MyDivision` 콤보에 `mnuId` 전송 | 공용 `useCustomQueryClient.withMenuId` 가 탭 menuId 를 자동 주입하므로 화면이 끌 수 없다. 설계 02 §2.1 ④-b / V-21 의 "미전송" 은 **달성 불가 요구**였다. **영향은 0건이 아니다**(gap-resolve iter-1 재실측): 오픈 가능 19명 중 2명(`loveidea`·`test001`)이 mnuId 게이트로 Division 콤보 0행 → 화면 전체 잠김. 원인은 "메뉴 권한은 `ADMIN`, Division unit auth 는 `SPMS ADMIN`" 의 그룹 불일치이며, 해소는 `SCM_ADM_USER_GR_MNU_MPG_M` 에 `('SPMS ADMIN','SSP0005')` 를 추가하거나 두 계정의 unit auth 를 `ADMIN` 으로 옮기는 admin 결정이다(자매 SSP0014/SCP0096/SSP0015 전부 `ADMIN`+`SSP Planner` 2행만 등록돼 미러링 선례가 없다). 화면 코드로는 고칠 수 없다 |
| Δ11 | 붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설) | AS-IS 는 `LockColumn(0, max, true)`(`cs:420`)로 조회 직후 전열을 잠가 키 입력·붙여넣기가 함께 막혔다. TO-BE 는 잠금 토글을 미이식(Δ2)하고 `beginningEdit` 으로만 게이트했는데, Wijmo 붙여넣기 경로는 `beginningEdit` 을 발화하지 않고 공용 `pastingCell` 의 `isEditableCell`(= `_inputEditType` 단독 판정)만 본다. 동적 `D_` 컬럼은 `_inputEditType:'O'` 를 무조건 선언하므로 `canEdit=false` 인 사용자도 Ctrl+V 로 셀을 채울 수 있었다 — 같은 조건을 `pastingCell` 에 걸어 AS-IS 잠금 등가를 복원했다(memory `datagrid-paste-editability-pastingcell-gap`) |
| Δ9 | `Company` 빈값 조회 **차단**(gap-resolve iter-1 신설) | AS-IS 는 `DataSource` 바인딩이 동기라 `cboCompany` 가 빈값인 순간이 없었다(`cs:166`). TO-BE 는 콤보 응답 뒤 effect 가 기본값을 넣으므로 pending·isError 창에서 빈값이 나갈 수 있고, SP 는 `:B_COMPANY_YN IS NULL` 로 회사 필터를 통째로 건너뛴다(`PKG_SSP0005` BODY L206-209 실측) — Company 는 ALL 옵션이 없는 단일 선택이라 "전 회사"는 화면 사양에 없다. Δ1 과 같은 성격의 의도적 강화다 |
| Δ10 | 툴바 `Insert`/`Delete` NO-OP 노출을 **버튼 권한 축으로 게이트**(gap-resolve iter-1 신설) | AS-IS `BaseForm.InitForm`(`GSCM/01.Framework/GSCM.Windows.Forms/UI/BaseForm.cs:438-450`)은 10개 툴바 버튼을 **권한과 무관하게 무조건 생성**하고, `TB_FX_GroupMenuAuth.BasicACL*` 은 `Authentication.cs:222-225` 에서 ACL 로 조립만 될 뿐 UI 소비처가 0건이다. 즉 AS-IS 는 권한으로 버튼을 숨기지 않았다. TO-BE 는 admin 이 버튼을 끌 수 있어야 한다는 프로젝트 규칙(CLAUDE.md §2 체크3 · hook #66/#24)이 우선하므로 `hasButton()` 조건부로 바꿨다. 현재 두 버튼 모두 2그룹 권한이 등록돼 있어 실동작 차이는 0이다 |
| Δ8 | `SelectDay` 선택영역 판정 = "2셀 이상 범위" | AS-IS FarPoint `GetSelections()` 는 단일 셀 클릭에 빈 배열을 돌려줘 `MSG00134` 로 차단했다(cs:694-701). Wijmo `selectedRanges` 는 현재 셀 하나도 1x1 범위로 돌려주므로 `length===0` 판정은 영구 false 였다(iter-1 결함). `rowSpan>1 \|\| columnSpan>1` 로 AS-IS 등가를 만든다 — 완전 동일은 아니다(Wijmo 는 "드래그로 만든 선택" 자체를 구분하지 않는다) |
