# SCP0123 Plan Control — AS-IS ↔ TO-BE 매핑 (convert-core §2.1 #11)

AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0123_PlanControl/SCP0123_PlanControl.cs`(1,327줄) + `.Designer.cs`
설계 근거: `.atlas/gscm-design/SCP0123/design/00_checklist.md` ~ `03_grid-columns.md`
전환 회차: convert-react iter-1~3 (2026-09-26 신규 생성) → **convert-gap-resolve iter-1 (2026-09-26) 게이트 양식 정규화**

상태 어휘: `asis_mapping_gate.py` 계약 4값 — **구현**(구현 위치 필수) / **제외**(사유 필수) / **해당없음**(사유 필수) / **미구현**(잔여).
표는 5열 `| # | AS-IS | TO-BE(구현 위치) | 사유 | 상태 |` 다. convert-react 가 쓰던 4열 자유 양식(상태에 `구조적 대체`·`미이식`·
`구현(…)` 등을 섞어 쓰던 형태)은 `--check` 가 상태 칸을 읽지 못해 **게이트가 한 번도 실행되지 못한 원인**이었다
(gap-resolve iter-1 실측: 121/139 행이 열 개수 때문에 잔여로 잡혔다) → 뉘앙스는 **사유 칸으로 옮기고** 상태는 4값으로 정규화했다.
셀 본문에 `|` 를 쓰지 않는다 — 파서가 백슬래시 이스케이프를 해석하지 않아 `\|\|` 도 셀 경계로 갈라진다(R30·B04 실사고).

---

## 1. 레이아웃 · 툴바 (01_layout R01~R31)

| # | AS-IS | TO-BE (구현 위치) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| R01~R03 | `RefreshPlanDate` 의 `DBUtils.Filter(dtDivision_GM,...)` 판정으로 `lciPlanDate`/`lciPlanDate_Days` Visibility 배타 토글 (cs:223-239) | `PlanControl.tsx` `isDailyPlanDateMode` 단일 파생값 → `PlanControlForm.tsx` Plan Date FormItem 삼항 조건부 렌더 | 구현 |
| R04 | `dpPlanDate_Days.Text = DateTime.Now.ToShortDateString()` (cs:230) | `PlanControlForm.tsx` useEffect — 일단위 모드 전이마다 `planDate = dayjs().format('YYYYMMDD')` |  | 구현 |
| R05 | Visible 토글 후 `cboPlanDate` 후보 재적재 (cs:237-238) | 주단위 모드에서만 `planDateOptions` 계산(조건부 렌더) — 순서 계약 동일 |  | 구현 |
| R06 | `p_plan_start_yyyymmdd` 소스 모드 분기 6곳 중복 (cs:385·526·703·902) | `utils/planControl.activity.ts` `resolvePlanStartYyyymmdd` 1함수 | 구조적 대체 — 결과 동등, 기제 다름(의미 동일) | 구현 |
| R07 | `SetDivisionAuthCheck(usrLayoutControl1)` → `usrLayoutControl.Enabled=false` + 경고 1회 (cs:174-175) | `noAuthDivision` → Form 전 컨트롤 `disabled` + `setAlert(MSG00667)` 1회 |  | 구현 |
| R08 | `DataUtil.checkRequiredOfSearch` → Division 0건이면 조회 early-return (cs:371) | `PlanControl.tsx` `handleSearch` 선두 가드 |  | 구현 |
| R09 | `MSG00097`("권한을 가진 Division이 없습니다") | `MSG00667` 로 재매핑(TO-BE MSG00097 = "Please select Division." 로 의미 불일치) |  | 구현 |
| R10 | `FindButton()` override → `FindData_Main()` (cs:356-359) | `hotkeyConfig.search = hasButton('SEARCH') ? handleSearch : false` |  | 구현 |
| R11 | Insert(F8)/Delete(F9) override 없음 = BaseForm 빈 구현 + admin 메타 미등록 | `hotkeyConfig.insert=false, delete=false` (키 생략 금지 — 공용 기본 addRow/removeRow 부활 방지) |  | 구현 |
| R11' | (NO-OP 규칙 예외 근거) AS-IS 는 Insert/Delete/Save 버튼이 **보이되 클릭 무동작**(`BaseForm.cs:3357-3371` 빈 구현)이라 skill self-check 의 NO-OP 규칙상 정답은 `() => undefined` 다. 이 화면은 `false`(비노출)를 쓴다 — 근거: ① 설계 `01_layout.md §2.3 R11` 이 "AS-IS NO-OP + admin 메타 미등록 두 축 일치"를 이유로 `false` 를 지시 ② `SCM_ADM_MNU_BTN_MPG_M` 에 INSERT/DELETE 0행이라 admin 메타를 원천으로 삼는 어떤 구현이든 비노출이 된다(CLAUDE.md §2 체크 3·4) ③ 행 추가/삭제 호출부가 화면에 0건이라 데이터 위험 0. **사용자 최종 확정 대기**(04_react-gap.md §5 잔여 3) | 의도적 차이(확정 대기) |
| R12 | Save(F7) override 없음. `SaveData` 유일 호출부 = CONFIRM 버튼 셀 | `hotkeyConfig.save=false` + `hasSavePermission`(`hasButton('SAVE')`)을 CONFIRM 셀 실행 게이트로 사용 |  | 구현 |
| R13 | `ExcelButton` 프레임워크 기본(포커스 Spread 대상) | `excel` 키 생략 + `excelFileName='PlanControl'` + 활성 그리드 라우팅(R18) |  | 구현 |
| R14 | Manual/Upload 기능 없음 | `manual=false, upload=false` |  | 구현 |
| R15 | Sort/Filter/Condition/Reset — BaseForm 공통 | 키 생략(공용 SubTitle 기본) + `searchParam={searchParams}` |  | 구현 |
| R16 | `SpreadInfo.ClearDataSource(spdMain)`/`(spdSub)` ×8 (cs:857-883) | store `setSearchParams` 가 `filters={}` + `engineRunContext=null` — 양 그리드 동시 공백 |  | 구현 |
| R17 | `siSub.VisibleTab(true)` / 상단은 cs:306 주석 | 하단만 `TabWrapper > TabItem label={t('LBL00014')}`, 상단은 `DataGrid` 직접 |  | 구현 |
| R18 | `BaseForm.ExcelButton` 이 `si.SpreadObject.Focused` 로 대상 시트 선택 | `focusSub` state + 각 DataGrid `gotFocus` → `SubTitle grid/gridFilter` 전환, `countGrid=mainGridRef` 고정 |  | 구현 |
| R19 | `timerStatus.Tick`(2000ms) → `CheckEngineStatus` (cs:156·837-847) | `hooks/usePlanControlPolling.ts` — `useTabProcQuery` 2건의 `refetchInterval` | 구조적 대체 — 결과 동등, 기제 다름 | 구현 |
| R20 | 상태 `C`/`E`/공백이면 `timerStatus.Stop()` (cs:639-647) | `statusInterval`/`canPoll` 이 같은 3조건에서 `false` 반환 |  | 구현 |
| R21 | 조회·Sub 재조회 진입 시 선행 `Stop()` (cs:376·546) | store `setFilters`/`clearFilters` 가 `engineRunContext=null` → query disabled |  | 구현 |
| R22 | 상태가 진행중이고 사용자 경로면 `Start()` (cs:645-646) | `refetchInterval` 이 진행중 상태에서 주기를 반환 — "타이머가 스스로 재기동하지 않는다"는 의미는 동일 | 구조적 대체 — 결과 동등, 기제 다름 | 구현 |
| R23 | (AS-IS 무대응 — 폼 1개) | `refetchInterval` 이 `hostElement.offsetParent === null`(숨김 탭)이면 정지 (MDI keep-alive, hook #72) | TO-BE 신설 | 구현 |
| R24 | (AS-IS 무대응) | `createPersistedStoreWithTab` + `useTabProcQuery`(queryKey 에 tabId) — 선택행·폴링 전부 탭 스코프 | TO-BE 신설 | 구현 |
| R25 | (AS-IS 버튼권한 테이블 `TB_FX_GroupMenuAuthExtension` SCP0123 0행) | `hasSavePermission` 게이트. **AS-IS 에 없던 TO-BE 신설 제약** — SCP Planner 만 SAVE 미등록(C-1, 현업 확인 대상). gap-resolve iter-1: 차단 시 **무피드백을 제거**했다(`MSG01125` "You do not have permission." alert) — CONFIRM 셀 캡션은 권한과 무관하게 그려지므로 조용한 return 은 "눌러도 아무 일이 없는 버튼"이 된다. 권한행 등록 여부는 여전히 현업 결정 | 제약 보고 + 안내 | 구현 |
| R26 | `TB_FX_GroupMenuAuth` 4그룹 | TO-BE `USER_GR_MNU_BTN_MPG_M` 동일 4그룹 — 변경 불요 | AS-IS 4그룹 = TO-BE `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 4그룹으로 동일 — 변경 대상 자체가 없다(DB 실측 19행/4그룹) | 해당없음 |
| R27 | — | `ROUTE_PATH` 3세그먼트 결함 → `05_register.sql` B2 로 정정. **적용 완료** — `SCM_ADM_MNU_M.ROUTE_PATH='supply/plan-control'`(2세그먼트) 재조회 확인(gap-resolve iter-1 ora.py 실측) |  | 구현 |
| R28 | `GMessageBox(saveMsg)` Confirmed./Executed./Released. (cs:756-781) | `resolveSaveMessage`(MSG 코드 반환) + `setToast({type:'success'})` (Alert 금지). 문구 = **MSG01465/01466/01467** iter-2 신규 등록(DB KO/EN + locales) |  | 구현 |
| R29 | 저장 성공 후 `FindData_Main()` + `InitSpread(siSub)` (cs:782·468) | `queryClient.invalidateQueries({queryKey:[tabId]})` — 두 시트 동시 갱신 |  | 구현 |
| R30 | 실패 시 `"Error!\nMsg : " + 마지막 테이블 첫 셀` (cs:786-789) | `res.status>=400` 또는 `Number(body.code)` false-success 분기 + `O_RESULT_MSG` error Toast |  | 구현 |
| R31 | `p_user_id = UserInfoContext.Current.UserId` (cs:716) | `sesUserId: useSessionStore(state => state.session.userId)` 를 SAVE payload 에 직접 싣는다(PROC_M IN SORT_ORD 7 = `sesUserId`, ora.py 실측). 설계 `01_layout.md` R31 의 "BE 세션 자동 주입" 서술은 **오류** — `/call-proc`(GeneralController.java:51-62)는 세션을 넣지 않고 `/call-proc2`(같은 파일 83행)만 넣는다. 자매 SCP0122 와 규약이 같다 | iter-3 정정, GAP-22 | 구현 |

### 정적 트리 (Designer 19노드)

| AS-IS | TO-BE |
|---|---|
| `splitContainer1` Orientation=**Horizontal**(=상/하) SplitterDistance 380 FixedPanel=Panel2 | `PanelGroup orientation='vertical'` + `Panel 56`/`PanelSeparator`/`Panel 44`. FixedPanel 은 비율 기반이라 등가 옵션 없음(C-L2 저위험 잔여) |
| `usrConditionPanel1`(HidePanel) + `usrLayoutControl1` + `layoutControlGroup1` | `MainTitle openSearchArea` + `{openSearchArea && <PlanControlForm/>}` + `SearchArea` 1행 |
| `layoutControlItem1/5` · `lciPlanDate` · `lciPlanDate_Days` | `FormItem` 3개(`commonStyles.formItem`) — Plan Date 2개는 배타 렌더 |
| `emptySpaceItem1`(344px 여백) | 해당 없음 — `SearchArea` grid 가 잔여 칸 처리 |
| `spdMain` / `spdSub` (FpSpread) | `PlanControlGrid` / `EngineRunGrid`(공용 `DataGrid`) |
| `imageList1` / `timerStatus` / `components` | `imageList1` 미이식(X11) · `timerStatus` → refetchInterval · `components` 이식 대상 아님 |

---

## 2. 조회조건 · cascade (02_search-combo)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| K01 `BLUtils.GetDivision(false,"")` → `UP_FX_GetCommonDataList_SCP @Code='Division'` | 콤보 `Division_SCP` (`COMBO.DIVISION`). `MyDivision`/`FilterMyDivision`/`Division_SCP_NoEE` 사용 금지 — `ATTRIBUTE3<>'EE'` 로 EE_UC 소실 | 구현 |
| F01 `DBUtils.Filter(dtMyDivision,"CODE IN (planGroup DIVISION_ID distinct)")` (cs:196) | `buildDivisionOptions` — 두 원천 도착 전에는 빈 배열 | 구현 |
| X14 `dsSearchInfo.Tables[3]` = Plan Group 공급 | `useTabProcQuery(SHEETS.SEARCH_INFO)` → `planGroupList` 커서 | 구현 |
| X21 `NowGroupID in (ADMIN, SCM PI Admin)` ? `p_user_id=''` : userId (cs:329-332) | `OWNER_BYPASS_GROUP_IDS.includes(session.groupId)` ? `''` : `session.userId` | 구현 |
| F02 `DBUtils.Filter(dtPlanGroupAll,"DIVISION_ID='..'",true)` (cs:212) | `PlanControlForm` planGroupOptions — division 필터 + CODE distinct, 정렬은 SP 순서 유지 | 구현 |
| K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY)` | 콤보 `OPMZ_DATE_WEEKLY_SCP_ALL` (`sortBy` 미지정 = SP `PLAN_NAME DESC` 유지) | 구현 |
| F04 `DBUtils.Filter(dtPlanDateAll,"DIVISION_ID='..'")` (cs:237) | `planDateOptions` division 필터 | 구현 |
| K04 `Data.Common(LookupCommon,"OPMZ_DIVISION_GM")` | **콤보** `useTabComboQueries({comboId:'LookupCommon', lookupType:'OPMZ_DIVISION_GM'})` — 코드 집합만 사용(SEGMENT2='-' 라 표시 금지). **`useTabLookupQueries` 금지**: admin/lookup 은 응답 컬럼명을 `LOOKUP_MASTER.SEGMENT1` 헤더값(이 룩업은 `DIVISION_ID`)으로 동적 생성해 `CODE` 가 없다(iter-2 GAP-1) | 구현 |
| K03·K05 `Data_SCP.CommonAll(PlanID)` + `SetComBoParam("PlanID", dtPlanID)`(X01) | admin 컬럼 메타 단일 원천(`CELL_COMBO_DATA_TYPE='PlanID_SCP_ALL'` + `ATTRIBUTE2` 필터 방식). 화면이 `col.dataMap` 을 직접 만들지 않는다 | 구현(iter-2 메타 적용 완료) |
| F06 3키 좁힘 (cs:262) | `ATTRIBUTE2` PARAM2 등록·적용 완료(05_register.sql B1-c) | 구현 |
| X08 `DataView.Sort="CODE DESC"` (cs:265-267) | 등록 SQL 에 `order by CODE desc` 추가했으나 공용 DataGrid 가 dataMap 표시 순서를 오름차순으로 덮어쓴다 | **의도적 차이(승인 D3)** — AS-IS 정렬 포기 |
| F03·F05·F07~F10 판정식 6회 중복 | `resolvePlanStartYyyymmdd` + `isDailyPlanDateMode` 단일 파생 | 구조적 대체 |
| C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0) | 콤보 파라미터에 divisionId 미탑재(쿼리 키 고정) + FE 필터 | 구현 |
| X06 `ConditionNotUseList.Add(cboPlanDate)` | TO-BE 에 조회조건 저장/복원 기능 자체가 없다(`packages/` grep 0건) | 해당 없음 |
| X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검사 | 4개 라벨 어디에도 `*` 없음(Designer 실측) → 필수 입력 검증 0건 | 해당 없음 |
| `setListBox` 바인딩 직후 첫 행 자동 선택(Division / Plan Group / Plan Date 주단위) | `PlanControlForm` useEffect 3개 — 값이 비어 있을 때만 첫 후보를 채운다(`CustomDropdown` 은 자동 선택을 하지 않으므로 화면이 보완) | 구현 |

---

## 3. gridSignals 21건 (G01~G21)

| # | AS-IS | TO-BE (구현 위치) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| G01 | `SetSheetHeaderColumnSCP(si,1,false,"")` — SCP 컬럼메타 공급, 헤더 1단 | store `fetchStaticColumns`(2시트) → `staticColumns` prop. `headerRowHeight` 미지정 |  | 구현 |
| G02 | `VisibleTab(true)` — Status 시트탭 | 하단 `TabWrapper > TabItem 'Status'` |  | 구현 |
| G03 | `siMain.Query(ds)` | `PlanControlGrid itemsSource={rows}` |  | 구현 |
| G04 | `LockColumn(0, OPMZ_PLAN_ID_INDP_YN, true)` idx 0~14 | 컬럼 메타 `INPUT_TP_CD='S'`(현 메타 그대로) — 컬럼명 배열 이식 금지 |  | 구현 |
| G05 | `LockColumn(OPMZ_ACTV_RUN_STAT_CD, LAST_UPDATED_BY, true)` idx 16~21 | 동상 |  | 구현 |
| G06 | A001 행 + `isValidSearch` → `"Critical : n, Warning : m"` (cs:433-441) | `PlanControlGrid` formatItem `DETAIL` 분기 + `formatValidationDetail` | 값 원천 미구현 — §6 | 구현 |
| G07 | `plan_id_indp_yn != 'Y'` 행 Plan ID 셀 Yellow (cs:444-448) | formatItem `toggleClass('wj-cell-editable', indpYn!=='Y')` — 임의 hex 금지 |  | 구현 |
| G08 | `plan_id_indp_yn == 'Y'` 행 Plan ID 셀 `Locked=true` (cs:449-453) | `handleBeginningEdit` 에서 `e.cancel = true`(메타 뒤 마지막 override, hook #70) |  | 구현 |
| G09 | `SetValue(i, LINK, link_Text)` (cs:459) | SP 값이 이미 바인딩됨 — AS-IS 의 셀타입 재설정 부작용 회피용 중복 대입이라 불필요 | SP 가 `LINK` 값을 이미 내려준다(`procedures.d.ts` planControl.LINK) — AS-IS 의 `SetValue` 재대입이 불필요 | 해당없음 |
| G10 | `SetForeColor(LINK, Color.Blue)` (cs:460) | formatItem `styles.linkCell`(color+underline) |  | 구현 |
| G11 | `SetCellTypeButtonByText(i, CONFIRM, ACTION_NAME)` (cs:462) | formatItem `CONFIRM` 분기 — `span` 캡션 = 행의 `ACTION_NAME`, `styles.actionButtonCell` |  | 구현 |
| G12 | `siSub.Query(ds)` | `EngineRunGrid itemsSource={engineRunRows}` |  | 구현 |
| G13 | `siSub.LockColumn(0, max, true)` | Status 컬럼 메타 전건 `INPUT_TP_CD='S'` + `isReadOnly` |  | 구현 |
| (병합) | 화면 `.cs` 에 merge 토큰 0건이지만 컬럼을 만드는 프레임워크 메타 빌더가 `merge = FPMerge.Restricted` 를 **무조건** 대입한다(`SpreadInfo.cs:1797` → `Add*Column` → `col.MergePolicy`, L2605-2617). 호출부 = cs:313 `SetSheetHeaderColumn`(Status, 확정) / cs:305 `SetSheetHeaderColumnSCP`(Plan Control, 본문 부재) | 두 그리드 `allowMerging={AllowMerging.Cells}` → 공용 DataGrid 가 `CustomMergeManager`(좌측 누적 키 = Restricted 등가) 자동 설치. **grep 0건을 병합 없음으로 읽지 않았다**(`guides/grid-behavior-parity.md` §1.1) | 구현(Status 확정 / Plan Control 은 CN-2 시각 확인 대기) |
| (고정열) | `AddSheet(spd, name, name, 1, 1, 30)` frozen row 1 / col 1 (cs:282·286) + `SetSheetHeaderColumnSCP(si, 1, false, "")` 의 4번째 인자 = **fixedColumnName** 이 빈 문자열(같은 메서드의 SCP0108 호출부 변수명으로 확정 — `_fixed_column_name`/`refreshAllColumn`) | `FIXED_FLAG` 전건 `'-'` → `frozenColumns=0`. AS-IS 도 고정열 지정이 없으므로 **메타 무변경이 파리티**. 근거 없는 `FIXED_FLAG='Y'` UPDATE 금지(메모리 `datagrid-display-is-default-flag`) | 구현(iter-2 확정) |
| G14 | 폴링 후 `OPMZ_ACTV_RUN_STAT_CD` SetText (cs:600) | `usePlanControlPolling` useEffect — 행 객체 값만 갱신 + `collectionView.refresh()` |  | 구현 |
| G15 | 폴링 후 `LAST_UPDATE_DATE` (cs:601) | 동상 |  | 구현 |
| G16 | 폴링 후 `LAST_UPDATED_BY` (cs:602) | 동상 |  | 구현 |
| G17 | SCP0039 팝업 OK 시 `DETAIL` 기입 + `isValidSearch=true` (cs:930-936) | store `setMasterValidation` 배선은 있으나 **팝업 반환 계약이 없어 호출부 미구현**(§6 ERROR) | goal.md §0-D **D2** 승인된 의도적 차이 — TO-BE SCP0039 는 모달이 아니라 독립 화면(supply/master-validation)이라 criticalCnt/warningCnt 반환 계약이 없다. 화면 오픈까지는 구현했고 반환값 축은 별건 work item | 제외 |
| G18 | 콤보 변경 후 `OPMZ_ACTV_RUN_STAT_CD` (cs:1305) | `handleCellEditEnded` 단건 재조회 4컬럼 갱신 |  | 구현 |
| G19 | 〃 `OPMZ_ACTV_RUN_STAT_NAME` (cs:1306) | 동상 |  | 구현 |
| G20 | 〃 `LAST_UPDATED_BY` (cs:1307) | 동상 |  | 구현 |
| G21 | 〃 `LAST_UPDATE_DATE` (cs:1308) | 동상 |  | 구현 |

---

## 4. buttonGuards B01~B41 + X19·X20 (43행 전건)

구현 위치는 별도 표기가 없으면 `hooks/usePlanControlCellActions.ts`.

| # | AS-IS 조건 | TO-BE (구현 위치) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| B01 | `Rows.Count <= 0` | `handleGridClick` `rows.length <= 0` return |  | 구현 |
| B02 | `col == LINK` | `binding === ACTION_COLUMN.LINK` 분기 |  | 구현 |
| X19 | `actv_cd == 'A001'` → SCP0039 팝업 | `handleLinkCell` A001 → `openScreen('SCP0039')`. 모달 반환값(criticalCnt/warningCnt) 계약은 TO-BE 부재 | goal.md §0-D **D2** 승인된 의도적 차이 — TO-BE SCP0039 는 모달이 아니라 독립 화면(supply/master-validation)이라 criticalCnt/warningCnt 반환 계약이 없다. 화면 오픈까지는 구현했고 반환값 축은 별건 work item | 제외 |
| B03 | `actv_cd == 'A002'` | `handleLinkCell` A002 분기 |  | 구현 |
| B04 | `!planId` 또는 `stat != 'C'` → **조용히 무동작** | A002 는 전체가 무동작이라 메시지 없음(alert 추가 금지 준수) |  | 구현 |
| B05 | `actv_cd == 'A003'` | A003 → `setEngineRunContext` 만(**저장 없음**). AS-IS cs:949-962 의 "선택된 셀위치 저장" 은 `nSelRowSpdMain = e.Row`(행 인덱스 보관)이고 `SaveData` 호출부 7곳은 전부 CONFIRM 경로다 — 설계 03 §3.4 B05 의 "선택행 저장" 서술은 오독(iter-2 GAP-2) |  | 구현 |
| B06 | `!planId` → MSG00093 | `alertSelectPlanId()` = `t('MSG01122').replace('{0}', t('LBL01149'))`(i18next 기본 보간은 `{{ }}` 라 options 로는 치환되지 않는다 — iter-2 GAP-10) |  | 구현 |
| B07 | (else) `link_adress != ''` → `GoPage` | `openScreen(row.LINK_ADDRESS)` — default 경로 유지(W-GEN) |  | 구현 |
| B08 | `col == CONFIRM` | `binding === ACTION_COLUMN.CONFIRM` 분기 |  | 구현 |
| B09 | `seq != '1'` | `str(row.OPMZ_ACTV_SEQ) !== '1'` |  | 구현 |
| B10 | `actv_cd != 'A004' && != 'A005'` | 동일 조건으로 선행검사 면제 |  | 구현 |
| B11 | `!CheckPreStepCompleted` → 리터럴 | `isPreStepCompleted(rows, actvCd)` + `MSG.PRE_ACTIVITY_NOT_DONE`(**MSG01462** — iter-2 신규 등록: DB KO/EN + locales 양쪽) |  | 구현 |
| B12 | `plan_id_indp_yn == 'Y'` | `runIndependent` / `runDependent` 분기 |  | 구현 |
| B13 | `stat == 'C' && actv_cd != 'A009'` → 조용히 차단 | `runIndependent` 선두 return(메시지 없음) |  | 구현 |
| B14 | `confirm_yn == 'Y'` | `runIndependent` Confirm 계열 분기 |  | 구현 |
| B15 | `actv_cd == 'A001'` | Master Validation 전용 가드 진입 |  | 구현 |
| B16 | `!isValidSearch` → MSG00469 | `MSG01441` alert | 값 원천 미구현 | 구현 |
| B17 | `criticalCnt > 0` → MSG00470 | `MSG01442` alert | 값 원천 미구현 | 구현 |
| B18 | Confirm 확인 = No → MSG00184 | `confirmMsg(MSG01457)` false 면 return |  | 구현 |
| B19 | `actv_cd == 'A006'` | Release 분기 |  | 구현 |
| B20 | Release 확인 = No → MSG00465 | `confirmMsg(MSG01438)` |  | 구현 |
| B21 | `actv_cd == 'A009'` | Semi Cut-off 분기 |  | 구현 |
| B22 | 실행 확인 = No → MSG00183 | `confirmMsg(MSG01456)` |  | 구현 |
| (else) | A006·A009 외에는 확인창 없이 바로 저장 (cs:1051-1054) | `runIndependent` 말미 `saveActivity(row)` 직행 — 확인창 추가 금지 준수 | 구현 |
| X20 | `actv_cd == 'A002'` → Plan ID 생성 팝업(plan_id='') | `runDependent` A002 → 오픈 지점까지만(팝업 본체 미구현, B3 결정) | goal.md §0-D **B3** 승인된 범위 밖 — `SCP0123_PlanIDCreatePopup` 은 메인 폼 전환 범위에서 제외(별도 work item). 오픈 지점까지만 배선하는 것이 승인된 구현이다 | 제외 |
| B23 | `actv_cd == 'A003'` | Engine Run Request 분기 |  | 구현 |
| B24 | `stat in (C,W,R,E)` → 리터럴 | 4상태 검사 + `MSG.PLAN_ID_ALREADY_PROCESSED`(**MSG01463** — iter-2 신규 등록) |  | 구현 |
| B25 | `!planId` → MSG00093 | `alertSelectPlanId()` |  | 구현 |
| B26 | 실행 확인 = No → MSG00183 | `confirmMsg(MSG01456)` |  | 구현 |
| B27 | `actv_cd == 'A004'` | A004/A005 공통 블록 진입 |  | 구현 |
| B28 | `!planId` → MSG00093 | `alertSelectPlanId()` |  | 구현 |
| B29 | A003 재조회 `Rows.Count > 0` | `fetchSingleStatus('A003', planId)` 결과 존재 검사 |  | 구현 |
| B30 | 재조회 `stat != 'C'` → 리터럴 | `MSG.ENGINE_RUN_NOT_EXECUTED`(**MSG01464** — iter-2 신규 등록) |  | 구현 |
| B31 | 현재 행 `stat == 'C'` | A004 이고 행 상태가 완료면 재실행 확인 분기 |  | 구현 |
| B32 | 재실행 확인 = No → MSG00466 | `confirmMsg(MSG01439)` |  | 구현 |
| B33 | 최초 실행 확인 = No → MSG00183 | `confirmMsg(MSG01456)` |  | 구현 |
| B34 | `actv_cd == 'A005'` | A004/A005 공통 블록(분기 조건은 분리) |  | 구현 |
| B35 | `!planId` → MSG00093 | `alertSelectPlanId()` |  | 구현 |
| B36 | A003 재조회 | 동상 `fetchSingleStatus` |  | 구현 |
| B37 | `stat != 'C'` → 리터럴 | 동상 | MSG 미등록 | 구현 |
| B38 | 실행 확인 = No → MSG00183 | A005 는 `confirmMsg(MSG01456)` 만 — 재실행 확인(MSG01439) 없음(임의 통일 금지 준수) |  | 구현 |
| B39 | 더블클릭 `Rows.Count <= 0` | `handleGridDoubleClick` 선두 return |  | 구현 |
| B40 | 더블클릭 `actv_cd == 'A003'` | A003 만 Status 조회, 그 외 `setEngineRunContext(null)`(= AS-IS -1) |  | 구현 |
| B41 | 더블클릭 `!planId` → MSG00093 | `alertSelectPlanId()` |  | 구현 |

**W-GEN**: A007·A008 은 전용 분기가 없지만 `INDP_YN='Y'`+`CONFIRM_YN='Y'` 라 LINK default(B07) / CONFIRM 독립·Confirm 경로(B18)를 그대로 탄다. `ACTIVITY` 상수는 화이트리스트가 아니며 default 경로가 살아 있다.
**validations 21건**: 전건이 위 B 행(또는 S04 저장 결과 메시지 3행)에 1:1 대응한다 — `00_checklist.md §6.1` 매핑표와 동일. 미매핑 0건.

---

## 5. 백본 밖 발견분 X01~X21 (21건 전건)

| # | AS-IS | TO-BE (구현 위치) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| X01 | `SetComBoParam("PlanID", dtPlanID)` (cs:304) | admin 메타 단일 원천(PARAM2 필터 방식). 화면이 `col.dataMap` 직접 조작 금지. **메타 정정 적용 완료** — `CELL_COMBO_DATA_TYPE='PlanID_SCP_ALL'` · `ATTRIBUTE2` 3키 · `INPUT_TP_CD='O'` 재조회 확인(gap-resolve iter-1 ora.py 실측) |  | 구현 |
| X02 | `ClearDataSource` ×8 | store 가 4조건 변경 시 양 시트 filters 무효화 |  | 구현 |
| X03 | LINK 셀 밑줄 폰트 (cs:457-458) | `styles.linkCell` `text-decoration: underline` |  | 구현 |
| X04 | `checkRequiredOfSearch` | 실효 = Division 권한 0건 조회차단(R08). `*` 필수 라벨 0건 |  | 구현 |
| X05 | `SetDivisionAuthCheck` 컨트롤 잠금형 게이트 | R07 |  | 구현 |
| X06 | `ConditionNotUseList.Add(cboPlanDate)` | TO-BE 조회조건 저장 기능 부재 | TO-BE 에 조회조건 저장(Condition) 기능 자체가 없다 — 이식 대상 0건(grep 0) | 해당없음 |
| X07 | Plan Date 배타 Visibility | R01~R03 |  | 구현 |
| X08 | `ToTable(true, DIVISION_ID)` distinct / `DataView.Sort="CODE DESC"` | distinct → `buildDivisionOptions` Set / CODE DESC → 콤보 SQL `ORDER BY` 제안(B1-b) + 공용 DataGrid 정렬 제약(G-3) | distinct 축은 `buildDivisionOptions` 로 구현. 후보 정렬 `CODE DESC` 만 goal.md §0-D **D3** 승인된 의도적 차이(공용 `sortComboDisplayNames` 오름차순 고정 — Hard Boundary §2.2) | 구현 |
| X09 | 폴링 타이머 + 정지조건 | R19~R23 |  | 구현 |
| X10 | `AddSheet(spd,name,name,1,1,30)` frozen 1행/1열 | `FIXED_FLAG` 전건 `-` → frozenColumns 0. AS-IS frozen col 1 은 폭 0 컬럼이라 시각 효과 없음 | AS-IS frozen col 1 의 대상이 폭 0 숨김 컬럼이고 `FIXED_FLAG` 전건 `'-'` 라 시각 효과가 0 이다(저위험 잔여) | 해당없음 |
| X11 | `cellTypeImage` / `siMain.ImagePopUp` (cs:162-167) | 참조처 0건 + 이 화면 메타에 `FPModal` 셀 0건 → **dead code 미이식** | AS-IS cs:162-167 초기화 후 참조처 0건 + 이 화면 메타에 `FPModal` 셀 0건 — dead code 라 미이식이 파리티 | 제외 |
| X12 | `CheckPreStepCompleted` (cs:1186-1258) | `utils/planControl.activity.ts` `isPreStepCompleted` 순수함수(OPTION_YN='Y' 제외, 첫 행 false) |  | 구현 |
| X13 | `SetEngineStatus` 4컬럼 갱신 + 행수 불일치 return (cs:660-693) | 커서 결과 전체 재바인딩이라 행 어긋남이 구조적으로 불가 | 구조적 대체 — 결과 동등, 기제 다름 | 구현 |
| X14 | `cboPlanGroup` 공급 = `Tables[3]` | `searchInfo.planGroupList` |  | 구현 |
| X15 | `CanModelChange = false/true` (cs:373·466·509·655) | `isBusy`(`isFetching`) 로 클릭·더블클릭 차단 + `savingRef` 중복 저장 차단 |  | 구현 |
| X16 | (00_checklist 상 영역1·2 공유 항목) | 해당 규칙은 R07/R08·F01 로 소진 |  | 구현 |
| X17 | `GoPage(link_adress)` → `openSubMenu` (cs:804-834·970) | `openScreen` = `findMenuPath` 확인 후 `navigate('/view/<PROGRAM_ID>')`. 선행 더미 조회 미이식 |  | 구현 |
| X18 | (00_checklist 상 영역1 레이아웃 항목) | §1 정적 트리 표로 소진 |  | 구현 |
| X19 | A001 LINK → SCP0039 팝업 | §4 X19 행 | goal.md §0-D **D2** 승인된 의도적 차이 — TO-BE SCP0039 는 모달이 아니라 독립 화면(supply/master-validation)이라 criticalCnt/warningCnt 반환 계약이 없다. 화면 오픈까지는 구현했고 반환값 축은 별건 work item | 제외 |
| X20 | A002 CONFIRM → Plan ID 생성 팝업 | §4 X20 행 | goal.md §0-D **B3** 승인된 범위 밖 — `SCP0123_PlanIDCreatePopup` 은 메인 폼 전환 범위에서 제외(별도 work item). 오픈 지점까지만 배선하는 것이 승인된 구현이다 | 제외 |
| X21 | `NowGroupID` ADMIN/SCM PI Admin owner 우회 | §2 X21 행 |  | 구현 |

> X16·X18 은 `00_checklist.md §5.3` 에서 영역1·2 규칙으로 분류돼 §1·§2 표에 흡수됐다(별도 코드 대응 없음).

---

## 6. 팝업 (popups U01~U05)

| # | AS-IS | TO-BE (구현 위치) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| U01·U02 | `ProgressForm` ×2 (조회/저장 진행표시) | 공용 로딩(useTabProcQuery/`setProgress`) — 화면 전용 구현 없음 | 구조적 대체 |
| U03 | `SCP0039_ValidationMaster`(division_id, plan_group_id) → `criticalCnt`/`warningCnt` 반환 | TO-BE SCP0039 는 **모달이 아니라 독립 화면**(`supply/master-validation`)이라 반환 계약이 없다. MDI 탭 오픈까지만 재현하고 `isValidSearch`/`criticalCnt`/`warningCnt` 는 채워지지 않는다 → B16·B17 가 항상 차단 | goal.md §0-D **D2** 승인된 의도적 차이 — TO-BE SCP0039 는 모달이 아니라 독립 화면(supply/master-validation)이라 criticalCnt/warningCnt 반환 계약이 없다. 화면 오픈까지는 구현했고 반환값 축은 별건 work item | 제외 |
| U04 | `SCP0123_PlanIDCreatePopup` 조회 모드(LINK A002) | B3 결정 = 메인 폼만 전환. 오픈 지점까지만 배선 | goal.md §0-D **B3** 승인된 범위 밖 — `SCP0123_PlanIDCreatePopup` 은 메인 폼 전환 범위에서 제외(별도 work item). 오픈 지점까지만 배선하는 것이 승인된 구현이다 | 제외 |
| U05 | 〃 생성 모드(CONFIRM A002, plan_id='') | 동상 | goal.md §0-D **B3** 승인된 범위 밖 — `SCP0123_PlanIDCreatePopup` 은 메인 폼 전환 범위에서 제외(별도 work item). 오픈 지점까지만 배선하는 것이 승인된 구현이다 | 제외 |

---

## 7. SP 호출 (spCalls S01~S05)

| # | AS-IS | TO-BE (구현 위치) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| S01 | `SCP0121_GET_SEARCH_INFO` | `PKG_COM0000.P_SCP0121_GET_SEARCH_INFO` — `SHEETS.SEARCH_INFO`, 응답키 `planGroupList` |  | 구현 |
| S02 | `SCP0123_GET_PLAN_CONTROL` | `PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL` — `SHEETS.PLAN_CONTROL`, 응답키 `planControl`(o_rc1 아님) |  | 구현 |
| S03 | `SCP0123_GET_PLAN_ENGINE_RUN` | `PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RUN` — `SHEETS.ENGINE_RUN`, 응답키 `engineRun` |  | 구현 |
| S04 | `SCP0123_SAVE_PLAN_CTRL_ACTV_RUN` (IN 7) | `PKG_SCP0123.P_SCP0123_SAVE_PLAN_ACTV_RUN` — 파라미터 7개 순서·의미 완전 일치(동일 SP 확정). 7번째 `sesUserId` 는 **FE 가 직접 전송**(R31 참조 — `/call-proc` 세션 자동주입 없음) |  | 구현 |
| S05 | `UP_FX_GetGSCMAuthenticationMenuList` |  | AS-IS 주석이 "메뉴 숨김오픈 회피용 의미없는 조회" 라고 명시한 더미 호출 — 실 이동은 `openScreen` 이 담당하므로 미이식이 파리티 | 제외 |

---

## 8. 권한 메타 (01_layout §2.5 실측 전재)

`SCM_ADM_MNU_BTN_MPG_M` (MNU_ID='SCP0123', 4행 · 전건 USE_YN='Y')

| SHT_NM | MNU_BTN_CD | API_ID | API_URL |
|---|---|---|---|
| planControl | SEARCH | `P_SCP0123_PLAN_CONTROL_GET` | `PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL` |
| planControl | SAVE | `P_SCP0123_ACTV_RUN_SAVE` | `PKG_SCP0123.P_SCP0123_SAVE_PLAN_ACTV_RUN` |
| engineRun | SEARCH | `P_SCP0123_ENGINE_RUN_GET` | `PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RUN` |
| searchInfo | SEARCH | `SCP0121_SEARCH_INFO_GET` | `PKG_COM0000.P_SCP0121_GET_SEARCH_INFO` |

`SCM_ADM_USER_GR_MNU_BTN_MPG_M` (15행 / 4그룹 — 2026-09-26 재실측)

| USER_GR_ID | planControl/SEARCH | planControl/SAVE | engineRun/SEARCH | searchInfo/SEARCH |
|---|:--:|:--:|:--:|:--:|
| ADMIN | Y | Y | Y | Y |
| FP Planner | Y | Y | Y | Y |
| SCM PI Admin | Y | Y | Y | Y |
| **SCP Planner** | Y | **(없음)** | Y | Y |

AS-IS 버튼권한 테이블 `TB_FX_GroupMenuAuthExtension` 은 SCP0123 **0행**(design 01 §6.2 asis.py 실측) → SCP Planner 의 SAVE 부재는 AS-IS 근거가 없는 TO-BE 신설 제약이다. 임의 INSERT 하지 않고 현업 확인 대상으로 남긴다(C-1).

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 11개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:CboPlanDate_SelectedIndexChanged | AS-IS `SCP0123_PlanControl.cs:869` (라이브 5행) — Plan Date(주) 변경 → `RefreshPlanID` + 양 그리드 `ClearDataSource` | `PlanControlForm.tsx` Plan Date 콤보 `onChange` → `setSearchParams({ planDateCode })` → `usePlanControlStore.ts` `setSearchParams` 가 filters·engineRunContext·masterValidation 초기화 (§2 C3-7) |  | 구현 |
| HANDLER:CboPlanGroup_SelectedIndexChanged | AS-IS `SCP0123_PlanControl.cs:861` (라이브 5행) — Plan Group 변경 → 동상 | `PlanControlForm.tsx` Plan Group 콤보 `onChange` → `setSearchParams({ planGroupId })` → 동일 초기화 경로 (§2 C3-6) |  | 구현 |
| HANDLER:DpPlanDate_Days_ValueChanged | AS-IS `SCP0123_PlanControl.cs:878` (라이브 5행) — 일단위 Plan Date 변경 → 동상 | `PlanControlForm.tsx` DatePicker `onChange` → `setSearchParams({ planDate })` → 동일 초기화 경로 (§2 C3-8) |  | 구현 |
| HANDLER:FindButton | AS-IS `SCP0123_PlanControl.cs:356` (라이브 3행) · ~~**사문(빈 몸통)**~~ — **오탐**: 몸통이 `FindData_Main();` 1줄이라 라이브 3행으로 세어졌을 뿐 실동작 override 다(cs:356-359 직접 read) | `PlanControl.tsx` `hotkeyConfig.search = hasButton('SEARCH') ? handleSearch : false` (§1 R10) |  | 구현 |
| HANDLER:Form_Load | AS-IS `SCP0123_PlanControl.cs:137` (라이브 7행) — `InitForm`/`InitControls`/`CreateSpread`/`DefineProperty`/`InitEvent` 5단 초기화 | `PlanControl.tsx` mount effect(`clearFilters()` — 진입 자동조회 금지 V05) + 콤보 `useTabComboQueries` + `fetchStaticColumns` 2시트. Spread 생성·이벤트 바인딩은 React/공용 DataGrid 가 대체 | 5단 중 `CreateSpread`·`InitEvent` 는 프레임워크 생명주기라 1:1 이식 대상이 아니다(구조적 대체) | 구현 |
| HANDLER:SaveData | AS-IS `SCP0123_PlanControl.cs:695` (라이브 88행) — Activity 실행/Confirm/Release 저장(IN 7, `indp_yn='Y'` 면 `p_plan_id='-'`) | `hooks/usePlanControlCellActions.ts` `saveActivity`(§1 R28~R31, §4 S04) |  | 구현 |
| HANDLER:SpdMain_CellClick | AS-IS `SCP0123_PlanControl.cs:887` (라이브 202행) — LINK/CONFIRM 분기, 가드 38건 | `usePlanControlCellActions.ts` `handleGridClick` → §4 B01~B38 전건 |  | 구현 |
| HANDLER:SpdMain_CellDoubleClick | AS-IS `SCP0123_PlanControl.cs:1260` (라이브 20행) — A003 행이면 Status 조회, 그 외 선택행 -1 초기화 | `usePlanControlCellActions.ts` `handleGridDoubleClick` → §4 B39~B41 |  | 구현 |
| HANDLER:SpdMain_ComboSelChange | AS-IS `SCP0123_PlanControl.cs:1290` (라이브 18행) — Plan ID 변경 → 같은 GET SP 단건 재조회로 4컬럼 갱신(0행이면 유지) | `usePlanControlCellActions.ts` `handleCellEditEnded` → §3 G18~G21 |  | 구현 |
| HANDLER:SpdMain_KeyPress | AS-IS `SCP0123_PlanControl.cs:1313` (라이브 9행) — 활성 셀이 **잠기지 않았고** 그 컬럼 `CellType == ComboBoxCellType` 이면 `e.Handled = true`(문자 키 차단 = Plan ID 는 드롭다운 선택 전용). **convert-react 3회차·감사·런타임게이트가 전부 놓쳤던 행** — 이 도구의 `HANDLER_RE` 에 `KeyPress` 가 없어 추출조차 되지 않았다(gap-resolve iter-1 에 정규식 보강) | `components/PlanControlGrid.tsx` `blockComboCellKey` — `hostElement` keydown **capture** 에서 `selection.col === OPMZ_PLAN_ID` + 메타 편집허용 + `INDP_YN !== 'Y'` + 문자 키(`key.length === 1`, Ctrl/Alt/Meta 제외)면 `preventDefault()`. 방향키·Tab·Enter·Esc·Backspace·F 키는 통과 |  | 구현 |
| HANDLER:cboDivision_SelectedIndexChanged | AS-IS `SCP0123_PlanControl.cs:853` (라이브 5행) — Division 변경 → `SetChangedControl` 연쇄 + 양 그리드 `ClearDataSource` | `PlanControlForm.tsx` Division 콤보 `onChange` → `setSearchParams({ divisionId })`. `usePlanControlStore.ts` `setSearchParams` 가 Division 변경을 감지해 planGroupId·planDateCode 를 비우고 filters·engineRunContext·masterValidation 까지 초기화한다 (§2 C3-1·C3-5) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common'.
> 화면 분석 md 에 없는 전 UI 공통 요구 — `asis_mapping_gate.py --check` 가 부재 행을 FAIL 처리한다.
> gap-resolve iter-1 신설: convert-react 3회차가 이 축을 한 번도 생성하지 않아 Gate 1 이 이 지점에서 막혀 있었다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) |  | 이 화면은 **행 추가 기능 자체가 없다** — AS-IS Insert(F8) override 가 `BaseForm` 빈 구현(NO-OP)이고 `hotkeyConfig.insert=false`, `addRow` 호출부 0건, `SCM_ADM_MNU_BTN_MPG_M` 에 INSERT 0행(DB 실측). 신규행이 생기지 않으므로 이 요구가 발동할 상태가 없다 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = confirm (MSG00703/00704) | 공용 위임 — `SubTitle.tsx:198` `confirmIfDirtyKey(dirtyKey, 'search')` → `useDirtyRegistry.ts:110` MSG00704. 이 화면은 Search 를 공용 `hotkeyConfig.search` 로만 발사하고(`PlanControl.tsx` `handleSearch`) `excludeFromDirtyCheck` 를 주지 않아 기본 dirty 경로에 그대로 붙는다 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 |  | 이 화면은 SubTitle 의 컬럼설정·Measure 아이콘을 쓰지 않는다(`SCM_MST_SHEET_MEASURE` 0행 = PIVOT 아님, 컬럼설정 opt-in `layoutKey` 미지정). 컬럼 추가/제외 진입점이 없어 발동 상태가 없다 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 | `hooks/usePlanControlCellActions.ts` `saveActivity` — 성공 `setToast({type:'success'})` / 실패 `setToast({type:'error'})`. `setAlert` 는 가드 안내·confirm 에만 쓰고 저장 결과에는 쓰지 않는다(§1 R28·R30) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 | 공용 위임 — `SubTitle` excel + `gridAction` 의 dataMap 승계 경로 | 이 화면의 유일한 콤보 컬럼 `OPMZ_PLAN_ID` 는 등록 SQL 이 `OPMZ_PLAN_ID AS CODE, OPMZ_PLAN_ID AS NAME`(DB 실측)이라 **Code 와 Name 이 같은 값**이다 — 어느 쪽으로 출력돼도 결과가 동일해 이 요구의 위반 상태가 발생하지 않는다 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 |  | 이 화면 조회조건 3필드는 전부 단일 select(`CustomDropdown` 2) + DatePicker 1 이고 Key-in 텍스트 조건이 0건이다(설계 02 §1 컨트롤 4종). 콤마 다중 입력 경로가 없다 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** | 공용 위임 — `DataGrid.tsx:1483` `rebindFilterColumns(grid, getGridFilter())`. 이 화면은 `gridFilterRef` 를 두 그리드 모두 SubTitle 에 넘겨 공용 필터 경로를 그대로 쓴다(`PlanControl.tsx` `gridFilter` prop) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

> gap-resolve iter-1 신설(수기). `--init` 이 이 축을 생성하지만 이 화면의 `00_checklist.md` 는
> `| C01 |`/`| E01 |` 형 ID 표라 도구의 D1 추출기(`| 42 |` 숫자 행 전제)가 0건을 뽑아 실행되지 않는다
> (`--init` 실측: "번호/제약 ID 추출 0건 — design 양식 아님"). 아래 행은 `00_checklist.md §4-B 진입점`
> 과 `§4e 팝업 표` 를 직접 읽어 같은 규칙으로 채운 것이다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:P01:SEARCH | `00_checklist §4-B` P01 `FindButton` toolbarOverride → `SCP0123_GET_PLAN_CONTROL`(+ `GET_PLAN_ENGINE_RUN`) | `PlanControl.tsx` `hotkeyConfig.search = hasButton('SEARCH') ? handleSearch : false` → `setFilters` + `fetchStaticColumns` 2시트 |  | 구현 |
| CRUD:P03:SAVE | `00_checklist §4-B` P03 `SpdMain_CellClick` → `SCP0123_SAVE_PLAN_CTRL_ACTV_RUN`. 이 화면의 저장은 툴바가 아니라 **CONFIRM 버튼 셀**이 유일 트리거 | `hooks/usePlanControlCellActions.ts` `saveActivity` (권한 게이트 `hasSavePermission` + `savingRef` 중복차단 + 공용 `saveWithValidation`) |  | 구현 |
| CRUD:INSERT | (AS-IS Insert(F8) override 부재 = `BaseForm` 빈 구현 NO-OP) |  | 행 추가 기능이 AS-IS·TO-BE 모두 없다 — `SCM_ADM_MNU_BTN_MPG_M` INSERT 0행(DB 실측), `hotkeyConfig.insert=false`, `addRow` 호출부 0건 | 해당없음 |
| CRUD:DELETE | (AS-IS Delete(F9) override 부재 = NO-OP) |  | 삭제 기능이 AS-IS·TO-BE 모두 없다 — `MNU_BTN_CD` DELETE 0행(DB 실측), `removeRow` 호출부 0건 | 해당없음 |
| MODAL:SCP0039_ValidationMaster | `00_checklist §4e` U01/U03 — A001 LINK 가 여는 Master Validation. AS-IS 는 모달 반환으로 criticalCnt/warningCnt 수령 | `usePlanControlCellActions.ts` `handleLinkCell` A001 → `openScreen('SCP0039')` (MDI 탭 오픈) | 반환 계약 축은 goal.md §0-D **D2** 승인된 의도적 차이 — TO-BE SCP0039 는 모달이 아니라 독립 화면이라 반환값이 없다. 오픈까지가 승인된 구현 범위 | 구현 |
| MODAL:SCP0123_PlanIDCreatePopup | `00_checklist §4e` U02/U04/U05 — A002 의 조회·생성 두 모드 팝업(AS-IS 별도 Form + SP 2건) |  | goal.md §0-D **B3** 승인된 범위 밖 — 메인 폼만 전환하고 팝업 본체는 별도 work item. FE 호출부 0건(조기 return 2곳)이 승인된 상태다 | 제외 |
