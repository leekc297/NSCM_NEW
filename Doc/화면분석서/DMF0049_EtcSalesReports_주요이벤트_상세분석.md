# DMF0049 ETC Sales Reports — 주요 이벤트 상세분석

## 원천 (전수 Read 실측)

| 구분 | 경로 | 행수 |
|---|---|---:|
| 정본 (분석 기준) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.cs` | 1,727 |
| 정본 Designer (이벤트 배선 확인) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0049_Sales_ETC_Reports\DMF0049_Sales_ETC_Reports.Designer.cs` | — |
| 참고 변형 (구사본) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\DMF0049_Sales_ETC_Reports.cs` | 1,648 |
| 호출 팝업 1 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_United_VersionPopup.cs` | 727 |
| 호출 팝업 2 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DM0002_TitleSetForm_Popup.cs` | 665 |
| 호출 팝업 3 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.SCM.Popup.UIL\SCM0002_ProjectbyDivisionPopupEx.cs` | 602 |

- 클래스: `GSCM.DM.Plan.UIL.DMF0049_Sales_ETC_Reports : BaseForm` (L45)
- 시트: 단일 시트 `"MDF Reports"` (`SpdSheet.shtMain`, L70~73)
- WCF 바인딩: `sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc"` (L132)
- 조회조건 컨트롤: `clbDivision`(Division), `clbType`(MDF Type), `clbPlanResult`(Plan/Result), `usrYear`(연도), `txtSPVersion` + `btnSPVer`(버전 팝업), `btnMeasure`(Measure Setting), `lblSPVersion`
- 전역 상태: `gsDivision_id`(L63, FindData 성공 시에만 갱신), `gsResultMonth`(L64), `gsVersion_no`(L65), `sCUTOFF_YYYYMMDD`(L62 — public 필드이나 **활성 코드에서 대입 없음**, btnSPVer_Click 내 대입은 주석 L1249)

### 이벤트 배선 전수 (Designer.cs 실측)

| 컨트롤 | 이벤트 | 핸들러 | Designer 행 |
|---|---|---|---:|
| btnSPVer | Click | btnSPVer_Click | 190 |
| clbType | SelectedIndexChanged | clbType_SelectedIndexChanged | 225 |
| btnMeasure | Click | btnMeasure_Click | 296 |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | 331 |
| clbPlanResult | SelectedIndexChanged | clbPlanResult_SelectedIndexChanged | 369 |
| spdMain | CellClick | spdMain_CellClick | 536 |
| spdMain | CellDoubleClick | spdMain_CellDoubleClick | 537 |
| this(Form) | Load | Form_Load | 코드 L143 (생성자에서 배선) |
| spdMain Data Model | Changed | spdMain_Changed | 코드 L234 (DefineProperty에서 배선) |

> 참고: clbType 은 Designer 배선 외에 코드에서 InitControls 도중 임시 해제(L203)→재부착(L225) 한다 (콤보 적재 중 이벤트 발화 방지).

---

## 0. 정본 vs 변형(GSCM.DM.Plan.UIL 평면본) 차이 — git diff --no-index 실측

차이는 정확히 3덩어리 (95 삽입 / 16 삭제). **변형이 구버전**이며 로직 골격은 동일.

1. **헤더 주석**: 정본에만 2024-09-11 `[E20240906-001717]`(엑셀 다운로드 속도 개선), 2025-02-10 `[E20250121-000490]`(조회구간 변경) 이력 추가.
2. **`ExcelButton()` override (정본 L471~516)**: 변형에는 없음(BaseForm 기본 동작). 정본은 `SimpleExcelExportOption` 구성 후 `SimplexelService.ExportFpSpread(fps, exportOption)` 직접 호출 — Merge=None, Border=All, AheadZero=HideZero, AmendZero=ShowZero, Null→Zero 변환 안함, 파일명 = `Application.StartupPath\{FormName}_{yyyyMMddHHmmss}.xlsx`, `AmendDecimalFormat = "#,##0.000;[Red]-#,##0.000"`, finally 에서 `MessageService.CloseProgress()`.
3. **`YearSet()` (정본 L1152~1175) + `GetCalendarYYYY()` 신설 (정본 L1178~1194)**: 변형은 로컬 for 루프로 `현재-5년 ~ +10년` DataTable 생성. 정본은 그 블록을 주석 처리하고 SP `DM.UP_FX_GetCommonDataList_DM` (`CODE="CALENDAR_YYYY"`, `PARAM1`~`PARAM5`="") 호출 결과로 연도 콤보 구성. 기본 선택값은 양쪽 모두 `DateTime.Now.Year`.

---

## 1. 초기화 체인 (Form_Load, L146~154)

생성자(L138~144)에서 `InitializeComponent()` 후 `this.Load += Form_Load` 배선. Form_Load 실행 순서:

1. `clsCtrl = new CControl(this)` (L148)
2. `InitForm()` (L150) — BaseForm 공통 초기화
3. `InitControls()` (L151)
4. `CreateSpread()` (L152) — 내부에서 `InitSpread()` 호출
5. `DefineProperty()` (L153)

### 1.1 InitControls (L191~226) — 콤보 로딩 순서·기본값

1. 속도개선 로그 `DataService.FP_Log2("SpeedUp","DMF0049","division_id_changed","start")` (L194)
2. **Division 콤보**: `SetChangeControl("MyDivision")` (L199) → FILTER_PART(L165~186)의 `DataService.GetDMInnerTable("MyDivision", Filter)` 호출. Filter 파라미터 = `GROUP_ID`(=`UserInfoContext.Current["NowGroupID"]`), `USER_ID`(=UserId). 결과 `dtDivision` 을 `clsCtrl.setListBox(dtDivision, clbDivision, false, "CODE", "NAME")` 로 적재 (L201). *(구 방식 `Data.Common(Data.Type.MyDivision, ...)` 은 주석 L197 — 비활성)*
3. **Type 콤보**: `clbType.SelectedIndexChanged` 임시 해제 (L203) → `GetLookupData("MDF_TYPE")` (L204, SP `SCM.SCM0001_GET_LOOKUP_VALUES`, `p_lookup_type="MDF_TYPE"`) → `setListBox(dtLook, clbType, false, "CODE","NAME")` (L205)
4. **Plan/Result 콤보 기본값**: `clbPlanResult.SelectedIndex = 0` (L207)
5. **End Customer 사전 적재**: `gsDivision_id != "40"` 이면 `SetChangeControl("EndCustomerByDivision", gsDivision_id, "")` (L209~215) → `GetDMInnerTable("EndCustomerByDivision", Filter)`, Filter 에 `DIVISION_ID`, `DEPT_ID` 추가 (L179~182). ※ 최초 로드 시점 `gsDivision_id` 는 `""` (FindData 성공 후에만 갱신되는 필드, L600) — 즉 최초에는 division `""` 로 호출됨 (실측 코드 그대로임).
6. 속도개선 로그 end (L217)
7. **연도 콤보**: `YearSet()` (L219) → `GetCalendarYYYY()` SP 결과 적재, 기본값 = 올해 (L1172~1174)
8. **Measure 목록 적재**: `dtMeasure = GetMeasure()` (L221) — SP `DM.DMF0049_GET_MEASURE`, 파라미터 `p_division_id = clbDivision.SelectedValue` (L1138~1150). InsertRow 시 MEASURE 셀 값 채움 용도.
9. **Company 룩업 적재**: `dtCompanyid = GetLookupData("DM_COMPANY")` (L223) — 적재만 하고 활성 코드에서 소비처 없음 (필드 보관).
10. `clbType.SelectedIndexChanged` 재부착 (L225)

### 1.2 CreateSpread (L240~247) / InitSpread (L249~268) — 시트 구성

1. `AddSheet(spdMain, "MDF Reports", "MDF Reports", 1, 1, 30)` → `siMain = GetSheetInfo(...)` → `siMain.ChangeSheet()` (L242~244)
2. `InitSpread()` (L246):
   - SP `DM.DMF0049_GET_SPREAD_TITLE` 호출 (L254). 파라미터 실명 순서: `p_division_id`(=clbDivision.SelectedValue), `p_created_by`(=UserId), `p_start_dt`(=`usrYear.SelectedValue+"0101"`), `p_end_dt`(=`usrYear.SelectedValue+"1231"`) (L256~259)
   - `siMain.InitSheet(siMain.SheetName)` (L263) 후 `siMain.CreateSheetHeaderColumnDtDiv(siMain, 1, dt, clbDivision.SelectedValue)` (L265) — 타이틀 DataTable + Division 기반 동적 헤더 생성. *(`SetSheetHeaderColumn` 은 주석 L264 — 비활성)*

### 1.3 DefineProperty (L227~238)

1. `cellTypeImage` = 팝업 아이콘 배경의 TextCellType 구성 (L229~231) — 활성 코드에서 셀 적용부는 주석(L1042)뿐, 즉 구성만 하고 미사용.
2. `dsdm.Changed += spdMain_Changed` — 시트 DataModel Changed 이벤트 배선 (L233~234)
3. `DEPARTMENT_ID`, `DEPT_ID` 컬럼 숨김 (L236~237)

---

## 2. FindData — 조회 (FindButton L274~277 → FindData L522~627)

1. `CheckForIllegalCrossThreadCalls = false` (L524)
2. **검증**: `txtSPVersion.Text == ""` → `MessageHelper.GMessageBox("MSG00283")` 후 return (L526~530)
3. `siMain.SpreadObject.SuspendLayout()` → `InitSpread()` (헤더 재생성, L532~533) → `ProgressForm` 표시 (L535~536)
4. `SearchStartTime()` (L540) — BaseForm 성능측정
5. **SP 호출** (FoxAsyncProxy 비동기, ShowProgress=false, L543~564): `DM.DMF0049_GET_SALES_ETC_REPORTS_DATA`, `CommandTimeout = 10*60`. 파라미터 실명 순서 전수:
   1. `division_id` = `clbDivision.SelectedValue` (L551 — 유일하게 `p_` 접두어 없음)
   2. `p_mdf_type` = `clbType.ControlValues` (L552)
   3. `p_yyyy` = `usrYear.ControlValues` (L553)
   4. `p_sp_version_no` = `txtSPVersion.Text` (L554)
   5. `p_user_group` = `UserInfoContext.Current["NowGroupID"]` (L555)
   6. `p_created_by` = `base.UserInfo.UserId` (L556)
6. `SearchEndTime()` (L567)
7. **결과 소비/Draw** (L569~599):
   - `siMain.Query(dsMain)` (L569) → 전 컬럼 잠금 `LockColumn(0, MaxCol, true)` (L570) → `DEPARTMENT_ID`/`DEPT_ID` 숨김 (L571~572)
   - 행이 있으면(`GetMaxRowIndex() > 0`) 회색 배경 처리 (L574~597): 기준월 `nowYYYYMM = 현재 yyyyMM`, 단 `clbType == "REPORT_BP_M"` 이면 `"20180101"` (L576~578).
     - `Plan`: MEASURE 다음 컬럼 ~ `M_{nowYYYYMM}` 직전 컬럼을 `Color.Gainsboro` (과거 구간 회색, L580~588)
     - `Result`(else): `M_{nowYYYYMM}` ~ 마지막 컬럼을 Gainsboro (당월 이후 회색, L589~596)
   - `siMain.SmartColMerge()` (L599)
8. **전역 상태 갱신** (L600~609): `gsDivision_id = clbDivision.SelectedValue`, `gsVersion_no = txtSPVersion.Text`, `gsResultMonth` = Result 선택 시 전월 `yyyyMM`, Plan 이면 `""`
9. `UIEndTime()` → `SearchEndTime()` (L613~615)
10. 예외: `GMessageBoxForException(ex)` (L619). finally: `prg.Close()`, `CanModelChange = true`, `ResumeLayout()` (L621~626)

---

## 3. 편집/저장

### 3.1 EditButton (L338~463) — 편집 게이트·잠금 규칙

1. **권한 게이트**: `NowGroupID == "DM Planner"` 이고 `gsDivision_id != "82"` 이면 `GMessageBox("MSG00096")` 후 return (L341~346) — [C20210406-000259] ESS(82)만 Planner 편집 허용.
2. `fps != null` 전제 (L348). **편집 허용 메저 조회**: `Data.Common(Data.Type.DM_LOOKUP_DIV, false, gsDivision_id, "DM_SR_ETC_CURRENCY")` → 첫 행 첫 컬럼 = `sEditMeasure` (L350~355)
3. `siMain.SwitchLock()` — 편집모드 토글 (L357~358). 행 없으면 return (L360).
4. 기준월: `nowYYYYMM = 현재 yyyyMM`, `nowYYYY = 현재 연도`; `clbType == "REPORT_BP_M"` 이면 `nowYYYYMM = "201801"` (L366~371)
5. 컬럼 가시성 스왑: `DEPARTMENT_ID`/`DEPT_ID` 표시, `T_DEPARTMENT_ID`/`T_DEPT_ID` 숨김 (L391~394)
6. **행별 잠금 루프** (L396~461), 전 행 대상:
   - 키영역 잠금: `gsDivision_id == "40"` 이면 0~`EDIT_FLAG` 잠금 + `T_DEPARTMENT_NAME`, `T_DEPT_NAME` 잠금 + `END_CUST_REPORT`~`COUNTRY_CODE` 잠금 + `MEASURE` 잠금 (L399~406). 그 외 사업부는 0~`MEASURE` 잠금 + `T_DEPARTMENT_NAME`, `T_DEPT_NAME` 잠금 (L407~412).
   - **Plan 모드** (L415~439):
     - `M_{nowYYYYMM}` 컬럼이 존재하고 그 인덱스가 `MEASURE+1` 보다 크면 → `MEASURE+1` ~ `M_{nowYYYYMM}-1` (과거 구간) 잠금 (L417~420)
     - 아니면서 조회연도 < 현재연도면 → `MEASURE+1` ~ 끝까지 전부 잠금 (L421~424) — [C20201223-000448] 과거년도 잠금
     - `gsDivision_id != "40"` 이면: 미래 구간에서 해당 행 MEASURE ≠ `sEditMeasure` 인 행은 `M_{nowYYYYMM}` ~ 끝 잠금 (L427~438)
   - **Result 모드** (L440~460):
     - `M_{nowYYYYMM}` 존재 시 `M_{nowYYYYMM}` ~ 끝 (미래 구간) 잠금 (L442~445)
     - `gsDivision_id != "40"` 이면: 실적 구간에서 MEASURE ≠ `sEditMeasure` 인 행은 `MEASURE+1` ~ `M_{nowYYYYMM}-1` 잠금 (L448~459)
   - *(비활성: 구 전체-컬럼 LockColumn 방식 L362, L375~389 주석)*

### 3.2 SaveButton (L465~468) → SaveData (L629~923)

1. **검증 1**: `txtSPVersion.Text == ""` → `GMessageBox("MSG00281")` return (L631~635)
2. **게이트**: `siMain != null && siMain.IsLock(SheetName) == false` (편집모드일 때만) && `SheetName == "MDF Reports"` (L638~640). ProgressForm 표시 (L642~643).
3. **메저 세트 단위 판단**: `iMeasureCnt` 기본 1; `gsDivision_id != "40"` 이면 1 유지([C20210406-000259]로 1로 변경, L686~690); 40 이면 루프 내 매 세트마다 `GetMeasureCntBy40(i)` 로 재산정 (L694~697). 행 루프는 `i += iMeasureCnt` 로 세트 단위 진행 (L692).
4. **Action 판정** (L700~716): 세트 내 1~3행 중 하나라도 Action 컬럼(`CAppSetting.StringAction`)에 값이 있으면 그 값을 세트 전체 action 으로 사용. action == "" 이면 세트 skip.
5. **컬럼 루프** (L718): `MEASURE+1` ~ 마지막 컬럼. `sQty`(i행), `sQty2`(i+1행, cnt≥2), `sQty3`(i+2행, cnt≥3) 추출 (L720~737).
6. **payload 채택 조건** (L739~744) — 하나라도 참이면 해당 (세트, 월) 조합 수집:
   - i행 셀 ForeColor == Red 이고 sQty ≠ "" (`GetCellColor` L1481~1490 은 ForeColor 반환)
   - i+1행 Red && sQty2 ≠ ""
   - cnt==3 && i+2행 Red && sQty3 ≠ ""
   - `gsDivision_id=="40" && action=="M" && cnt>=2`
   - `gsDivision_id=="82" && action=="M"`
7. **검증 2**: 채택 시 `DEPARTMENT_ID` 값이 "" 이면 `GMessageBox("MSG00002", {"Department"})` → prg.Close() → return (전체 저장 중단, L746~751)
8. **'^' 구분 payload 조립** (L753~839): 메저 k(0~cnt-1) 루프로 다음 순서로 누적(코드 기재 순서 그대로):
   `p_active_flag`(action) → `p_result_month`(gsResultMonth) → `p_division_id`(gsDivision_id) → `p_version_no`(gsVersion_no) → `p_data_seq`(i행 DATA_SEQ) → `p_department_id` → `p_dept_id` → `p_measure`(i+k행 MEASURE) → `p_yyyymmdd`(컬럼 Tag 의 `"M_"` 제거값) → `p_created_by`(UserId) → `p_department_edit_flag`(DEPARTMENT_ID 셀 ForeColor==Red ? "true":"false") → `p_department_name`(T_DEPARTMENT_NAME) → 이하 "컬럼 존재 시 값, 없으면 빈문자" 가드( `GetColumnIndex(...) > -1` 또는 `> 0` )로: `p_cust_report`, `p_end_cust_report`, `p_soldto_code`(GetText), `p_soldto_cust_report`, `p_product_group`, `p_item_id`, `p_product_details`, `p_currency`, `p_company_id`, `p_biz_type`, `p_application_gr`, `p_application`, `p_country_code`, `p_project_code`, `p_scm_site_id`(GetText), `p_fcst_type`, `p_item_use`, `p_soldto_country`, `p_shipto_country`, `p_end_customer`, `p_etc_descr`, `p_cell_model_info`, `p_cell_model`. k 루프 종료 후 `p_qty` 에 sQty(+cnt≥2 이면 sQty2, cnt==3 이면 sQty3) 누적 (L826~834). `iCount++` (L839).
   - ※ 존재가드 부등호가 컬럼별로 `> -1`(CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT) 과 `> 0`(그 외) 로 혼재 — 원본 그대로임.
9. **SP 호출** (L845~890): `iCount > 0` 일 때만. `DM.DMF0049_SAVE_SALES_ETC_REPORT_C`, `CommandTimeout = 10*60` (L888). **파라미터 실명 등록 순서 전수 (36개, 각각 선두 '^' 1글자 `Remove(0,1)` 후 전달, L850~886):**
   1. `p_active_flag` 2. `p_result_month` 3. `p_division_id` 4. `p_version_no` 5. `p_data_seq` 6. `p_department_id` 7. `p_department_edit_flag` 8. `p_department_name` 9. `p_dept_id` 10. `p_cust_report` 11. `p_end_cust_report` 12. `p_soldto_code` 13. `p_soldto_cust_report` 14. `p_product_group` 15. `p_item_id` 16. `p_product_details` 17. `p_currency` 18. `p_company_id` 19. `p_biz_type` 20. `p_application_gr` 21. `p_application` 22. `p_country_code` 23. `p_project_code` 24. `p_scm_site_id` 25. `p_fcst_type` 26. `p_item_use` 27. `p_soldto_country` 28. `p_shipto_country` 29. `p_end_customer` 30. `p_etc_descr` 31. `p_cell_model_info` 32. `p_measure` 33. `p_yyyymmdd` 34. `p_qty` 35. `p_created_by` 36. `p_cell_model`
10. **응답 분기** (L892~909):
    - `Tables[0].Rows[0][0] == "success"` → `GMessageBox("MSG00004", {iCount})` + `FindData()` 재조회
    - else if `Tables.Count != 0` → 반환 문자열 자체를 MSG ID 로 `GMessageBox(반환값)` (SP가 MSG ID 반환하는 구조)
    - else → `GMessageBox("MSG00004", {iCount})` + 뷰포트 TopRow 보존 후 `FindData()` (L903~908; Tables.Count==0 이면 도달 불가한 방어 분기 — 원본 그대로)
11. 예외 `GMessageBoxForException`, finally `prg.Close()` (L913~920)

### 3.3 InsertButton (L279~282) → InsertRow (L925~1119)

1. **게이트**: 편집모드(`IsLock == false`) && 시트 = "MDF Reports" (L928~930). `SuspendLayout()` (L932).
2. **메저 수 결정** (L934~939): 기본 3(=40 소형: SalesAmt_LOC/SalesAmt_KRW/RTF_SYS_RP); `gsDivision_id` 앞 2자리 == "81" → 2; == "82" → 1.
3. `GetCellNumbersByRow(ActiveRow, cnt)` (L941, 구현 L1197~1224: 활성행이 속한 세트의 행 인덱스 배열 산출) → 세트 첫 행에 ActiveCell 설정 → `siMain.Insert(iMeasureCnt)` 로 cnt 행 삽입 (L942~943).
4. 컬럼 가시성 스왑: `DEPARTMENT_ID`/`DEPT_ID` 표시, `T_DEPARTMENT_ID`/`T_DEPT_ID` 숨김 (L946~949)
5. 편집 허용 메저 `sEditMeasure` 조회 (`DM_LOOKUP_DIV` + `"DM_SR_ETC_CURRENCY"`, L951~956)
6. **팀 콤보**: `Data.Common(Data.Type.DMF0044_DEPARTMENT_TEAM2, false, gsDivision_id, "", "", "Y")` → 신규 행 `DEPT_ID` 셀에 SetCellTypeCombo (L958~960). *(UserSiteByEndCustomer 사전조회는 주석 L959 — 비활성)*
7. **신규 행별(i = 0~cnt-1) 잠금/콤보** (L962~1043):
   - 존재 시 잠금: `T_DEPARTMENT_NAME`, `T_DEPT_NAME`, `CUTOFF_YYYYMMDD`, `NICK_NAME`, `SCM_SITE_ID`, `BIZ_TYPE_NAME`, `DMS_CUSTOMER` (L965~978)
   - **81\* 분기** (L983~1003): `PROJECT_CODE` 잠금해제, `FCST_TYPE`~`MEASURE` 잠금, `END_CUSTOMER` 셀에 `Data.UserEndCustomerByDivisionDeptAuth(NowGroupID, UserId, gsDivision_id, "")` 콤보, `SCM_SITE_ID` 잠금해제, `CURRENCY` 잠금해제, `ETC_DESCR` 잠금해제(단, 존재판정은 CURRENCY 인덱스로 검사 — 원본 그대로 L996~997), `CELL_MODEL_INFO` 잠금
   - **82 분기** (L1004~1024): `PROJECT_CODE`/`END_CUSTOMER`/`SCM_SITE_ID`/`CURRENCY` 잠금해제, `ITEM_ID` 잠금, `CELL_MODEL_INFO` 잠금
   - `MEASURE` 잠금 + `dtMeasure.Rows[i]["CODE"]` 값 SetValue (L1027~1031)
8. **전 행 구간 잠금 재적용 루프** (L1054~1111): `EDIT_FLAG == "Y"` 행은 0~`MEASURE` 잠금(L1056~1059); 그 외 행은 EditButton §3.1 6번과 동일한 Plan/Result·과거년도·비허용 메저 잠금 규칙 (nowYYYYMM 기준, `REPORT_BP_M` 이면 `"201801"`, L1050~1051).
9. **세트 행 병합**: `SetRowSpanFucTwo(siMain, ActiveRow, ActiveRow+(cnt-1), 1, MEASURE-1)` (L1115, 구현 L1492~1529: 컬럼별 동일값 세로 스팬) → `ResumeLayout()` (L1116)

### 3.4 DeleteButton (L284~336)

1. `iMeasureCnt` 기본 2; `gsDivision_id == "40"` 이면 `GetMeasureCntBy40(ActiveRow)` 로 재산정 (L290~296).
2. **40 분기** (L298~322): `GetCellIndexBySpanRowCells40(ActiveRow, cnt)` (구현 L1612~1635: MEASURE 값이 RTF_SYS_RP→-2, SalesAmt_KRW→-1, SalesAmt_LOC→0 오프셋으로 세트 첫 행 산출) 로 첫 행을 얻고, cnt==2 이면 {첫행, 첫행+1}, cnt==3 이면 {첫행, 첫행+1, 첫행+2} 를 **역순으로** ActiveCell 이동 후 `siMain.Delete()` 반복.
3. **그 외 사업부** (L324~333): `GetCellNumbersByRow(ActiveRow, cnt)` 결과 배열을 역순으로 `siMain.Delete()`.
4. *(비활성: Action=='I' 행만 삭제 허용 가드 주석 L286~287)*
5. `GetMeasureCntBy40` (L1643~1723): DATA_SEQ 가 있으면 사업부 무관 동일 SEQ 연속 구간 길이로 cnt 산출([C20210506-000051]); 없고 40이면 MEASURE 값(SalesAmt_LOC/SalesAmt_KRW/RTF_SYS_RP) 순서 규칙으로 2 또는 3 판정.

---

## 4. 그리드 이벤트

### 4.1 spdMain_Changed (Data Model Changed, L1252~1426) — `CellsUpdated` 타입만 처리

1. **DEPARTMENT_ID 컬럼 변경 && gsDivision_id=="40"** (L1260~1326):
   - 부서명 ≠ "기타": `Data.Common(Data.Type.DMF0044_DEPARTMENT_TEAM, false, sDEPARTMENT_ID, "")` 로 `DEPT_ID` 콤보 재설정 + 가운데 정렬 (L1268~1273). Action=="M" 이면 `CUST_REPORT` 만 clear; 아니면 `ITEM_ID`/`NICK_NAME`/`END_CUST_REPORT`/`CUST_REPORT`/`PRODUCT_GROUP` 전부 clear (L1276~1287).
   - 부서명 == "기타": `DMF0044_DEPARTMENT_TEAM2(gsDivision_id)` 로 DEPT_ID 콤보 + 빈 1행 dtNull 콤보를 M 이면 `CUST_REPORT` 에, 아니면 `END_CUST_REPORT`/`CUST_REPORT`/`PRODUCT_GROUP` 에 설정하고 텍스트 clear (L1291~1324).
2. **DEPT_ID 컬럼 변경** (L1331~1406):
   - `dtEndCustomer = Data.Common(Data.Type.END_CUST_REPORT, ...)`, `dtProduct = GetLookupData("REPORT_GROUP3")` (L1337~1338). *(DMF0044_MDF_ENDCUST_REPORT 는 주석 L1336 — 비활성)*
   - 부서값 존재 시: Action=="M" 이면 `CUST_REPORT` 에만 `Data.Common(Data.Type.DMF0005_REPORT_GROUP2)` 콤보(가운데 정렬); 아니면 `END_CUST_REPORT`(dtEndCustomer)·`PRODUCT_GROUP`(dtProduct)·`CUST_REPORT`(REPORT_GROUP2) 콤보 설정 + `ITEM_ID`/`NICK_NAME`/`END_CUST_REPORT`/`CUST_REPORT`/`PRODUCT_GROUP` clear (L1340~1381)
   - 부서값 없음: M 이면 CUST_REPORT clear; 아니면 dtNull/dtProduct 콤보 + 3필드 clear (L1382~1405)
3. **END_CUSTOMER 컬럼 변경** (L1407~1412): `Data.UserSiteByEndCustomer(NowGroupID, UserId, gsDivision_id, 선택값)` 결과로 `SCM_SITE_ID` 셀 콤보 설정 — End Customer→Site cascade.
4. **수량 영역 자동 0 채움** (L1416~1423): MEASURE 이후 컬럼이고 Action=="M"(`CAppSetting.FlagM`) 이며 셀값 "" 이면 `SetText("0")`.

### 4.2 spdMain_CellDoubleClick (L1428~1478)

- **PROJECT_CODE 컬럼** 더블클릭 시에만 동작: `SCM0002_ProjectbyDivisionPopupEx` 생성 → `Form_Load(false, gsDivision_id, "ALL", "ALL", "ALL", 현재셀 PROJECT_CODE, true)` (multiSelect=false, Team/EndCustomer/Site="ALL", ETC=true) → CenterParent ShowDialog (L1440~1444). 반환 `ProjectCode` ≠ "" 이면 해당 셀에 SetText, `PROJECT_NAME` 컬럼 존재 시 `ProjectName` 도 SetText (L1446~1457).
- *(비활성: ITEM_ID 더블클릭 → DM0002_ItembyDivisionPopupEx 호출 블록 전체 주석 L1461~1477 — "콤보로 변경함")*

### 4.3 spdMain_CellClick (L1578~1605)

- 편집모드(`!IsLock`)이고 `gsDivision_id == "40"` 일 때만:
  - `DEPARTMENT_ID` 또는 `DEPT_ID` 컬럼 클릭 → 해당 세트 범위에 `SetRowSpanFucTwo` 재적용(스팬 복구) (L1587~1594)
  - `CUST_REPORT` 컬럼 클릭 → `DMF0005_REPORT_GROUP2` 콤보 재설정 + 스팬 재적용 (L1595~1601)

---

## 5. 버튼 전수

### 5.1 BaseForm override (공통 버튼)

| 버튼 | 핸들러 (라인) | 동작 |
|---|---|---|
| Find | `FindButton()` L274~277 | `FindData()` — §2 |
| Insert | `InsertButton()` L279~282 | `InsertRow()` — §3.3 |
| Delete | `DeleteButton()` L284~336 | 세트 단위 행 삭제 — §3.4 |
| Edit | `EditButton()` L338~463 | 잠금 토글 + 규칙 — §3.1 |
| Save | `SaveButton()` L465~468 | `SaveData()` — §3.2 |
| Excel | `ExcelButton()` L471~516 | Simplexel 직접 export — §0-2 (정본 전용) |

### 5.2 커스텀 버튼·콤보 이벤트

1. **btnSPVer_Click (L1234~1250)** — SP/BP Version 팝업: `DMF0044_United_VersionPopup` 생성 → `pop.Form_Load(clbDivision.ControlValues, clbType.ControlValues)` → ShowDialog → `txtSPVersion.Text = pop.sVersions`. *(비활성: 구 `DMF0044_Sales_VersionPopUp` 호출 + `sCUTOFF_YYYYMMDD` 수신 블록 주석 L1242~1249)*
2. **btnMeasure_Click (L1543~1554)** — Measure Setting 팝업: `new DM0002_TitleSetForm_Popup("DMF0049", siMain.SheetName, false, clbDivision.SelectedValue)` (isColumn=false → Measure 모드, [C20210125-000207] Division 파라미터 추가) → CenterParent ShowDialog → `DialogResult.OK` 이면 `InitSpread()` 재구성.
3. **clbType_SelectedIndexChanged (L1530~1539)**: `InitSpread()` + `txtSPVersion.Text = null` + 라벨 토글(`REPORT_SP_W` → "SP Version", 그 외 → "BP Version").
4. **clbDivision_SelectedIndexChanged (L1556~1564)**: `siMain != null` 이면 `dtMeasure = GetMeasure()` → `InitSpread()` → `DefineProperty()`.
5. **clbPlanResult_SelectedIndexChanged (L1566~1573)**: `siMain != null` 이면 `InitSpread()` → `DefineProperty()`.

### 5.3 화면 내 검증 메시지 전수 (활성 기준)

| MSG ID | 위치 (라인) | 조건 |
|---|---|---|
| MSG00283 | FindData L528 | 조회 시 Version 미입력 |
| MSG00281 | SaveData L633 | 저장 시 Version 미입력 |
| MSG00096 | EditButton L344 | DM Planner 그룹이 82 외 사업부 편집 시도 |
| MSG00002 {"Department"} | SaveData L748 | 저장 대상 행 DEPARTMENT_ID 공백 |
| MSG00004 {iCount} | SaveData L894, L903 | 저장 성공 건수 안내 |
| (SP 반환 문자열) | SaveData L899 | SP 가 "success" 외 MSG ID 반환 시 그대로 표시 |
| GMessageBoxForException | FindData L619, SaveData L915 | 예외 |

---

## 6. 호출 팝업 상세

### 6.1 DMF0044_United_VersionPopup (버전 선택 — btnSPVer)

- **진입**: §5.2-1. `Form_Load(strDiv, strType)` 오버로드(L109~113)로 `_sDiv`/`_sType` 만 선주입 후 ShowDialog → 실제 Load(L92~107)에서 InitForm/InitControls/DefineProperty/CreateSpread/FindData, `IsPopup=true`, `IsPopupEditCheck=false`.
- **초기화** (InitControls L115~141): Division = `Data.Common(MyDivision)` 적재 후 `_sDiv` 선택·**Enabled=false**; 조회기간 `drpPeriod` = 전월 오늘 ~ +5개월; `BasicDate.Enabled=false`; `chkUpdate.Checked=true`; Type 콤보 = `_sType=="REPORT_SP_W"` 이면 룩업 `MDF_TYPE_SP_POPUP`, 아니면 `MDF_TYPE_BP_POPUP`; `ControlDisplay()`(L503~579) 로 Type 값별 버튼 레이아웃 토글(SP_W/BP_M/SP_M = 생성계, REPORT_* = 복사계; REPORT_SP_W/SP_W/SP_M 은 MV 영역 표시).
- **시트**: 타이틀 SP `DM.DMF0000_GET_COMMON_SPREAD_TITLE` (`p_start_yyyymmdd`="", `p_end_yyyymmdd`="", `p_created_by`, `p_program_id="DMF0044"`, `p_sheet_name="MDFVerpopup"`, `p_division_id`) (L270~286).
- **조회** (FindData L220~259): SP `DM.DMF0044_GET_SALES_VERSION_POPUP`, timeout 10분. 파라미터 순서: `p_division_id`, `p_sdt`(기간 시작 yyyyMMdd), `p_edt`(기간 끝), `p_version_type`(=clbType), `p_Description`(=txtDesc). 조회 후 DIVISION_ID~끝 잠금 + SmartColMerge.
- **행 선택**: `spdMain_CellClick`(L693~711) — 클릭 행을 연두색(215,227,188) 하이라이트하고 `giRowIndex` 보관. `SingleCheck()`(L323~347) 는 `giRowIndex` 반환(-1 = 미선택).
- **반환**: `btnOK_Click`(L481~489) 또는 `spdMain_CellDoubleClick`(L349~356, Type 이 `REPORT_BP_M`/`REPORT_SP_W` 일 때만) → `sVersions = 선택행 VERSION_NO` 후 Close. **호출측(DMF0049)은 `sVersions` 만 소비** (`sCUTOFF_YYYYMMDD` 전달은 구 팝업용 주석 — 비활성).
- **부가 버튼** (DMF0049 사용 흐름과 무관하게 팝업 내 존재):
  - `btnFind_Click`/`usrButton1_Click` → FindData (L371~374, L686~689)
  - `btnTransfer_Click`(L376~394): SEND_YN=="N" 행만 `DMF0044_MOBILE_REPORT_CREATE(row,"T")`, 아니면 MSG00318 확인
  - `btnTranCancel_Click`(L396~418): SEND_YN=="Y" 행만 MSG00195 확인 후 `..._CREATE(row,"C")`, 아니면 MSG00319
  - `btnVerDel_Click`(L420~441): SEND_YN ∈ {N,C} 행만 MSG00016 확인 후 `DMF0044_SAVE_SALES_PLAN_VERSION_COPY(row,"D")`, 아니면 MSG00320
  - `btnVerCopy_Click`(L443~468): 실적 미포함 시 MSG00314 확인 후 `..._COPY(row,"CP")`
  - `btnVerCre_Click`(L470~479): `..._COPY(row,"CR")`
  - `chkResult_CheckedChanged`(L302~321) / `chkMV_CheckedChanged`(L713~725): BasicDate/MvMonth 활성 토글
- **팝업 내 SP 2종 파라미터**:
  - `DM.DMF0044_MOBILE_REPORT_CREATE` (L581~627): `p_division_id`, `p_version_no`(선택행), `p_version_type`, `p_action_type`(T/C), `p_created_by`. success → MSG00004{1} + 재조회, 아니면 반환 MSG 표시.
  - `DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY` (L629~682): `p_division_id`, `p_version_no`, `p_version_description`(txtDesc), `p_created_by`, `p_result_date`(chkResult 시 BasicDate), `p_action_type`(D/CP/CR), `p_mv_plan_yyyymm`(chkMV 시 MvMonth), `p_update_yn`(chkUpdate Y/N). 응답 처리 동일.

### 6.2 DM0002_TitleSetForm_Popup (Measure Setting — btnMeasure)

- **진입**: §5.2-2. 생성자 `(sProgramID="DMF0049", sSheetName="MDF Reports", isColumn=false → _sTitleSetType="M", sDivisionId=clbDivision)` (L75~85) — 생성자에서 즉시 `GetTitleSet()` 실행.
- **조회 SP**: `DM.DMF0002_GET_TITLESET_POPUP` (L236~255): `p_program_id`, `p_sheet_name`, `p_column_type`("M"), `p_user_id`, `p_division_id`. *(구 `SCM.SCM0002_GET_TITLESET_POPUP` 은 주석 — 비활성)*
- **UI**: Base(미사용 항목)/User(사용 항목) 2-스프레드 (InitSheet L152~211). `SetTitleSet(false)`(L257~263) 로 `USER_FLAG` = 'N'→Base, 'Y'→User 분배. 이동은 `btnRight_Click`/`btnLeft_Click`/양쪽 CellDoubleClick(L571~587) → `SetTitleSet(SheetView)`(L298~423, USER_SELECTABLE_FLAG=='Y' 만 이동, SORT_ORDER_NO 동값 그룹 동반 이동). `spdUser_RowDragMove`(L628~635) 는 USER_SELECTABLE_FLAG≠'Y' 행 드래그 취소. `spdUser_ButtonClicked`(L589~599) 는 SUB_TOTAL_FLAG 단일선택 강제.
- **버튼 리스트** (`usrButtonList1_UsrButtonList_Click_Detected` L606~621): Default → `SetTitleSet(true)`(DEFAULT_FLAG 기준 리셋), OK → `SaveTitleSet()` + `DialogResult = OK`, Cancel → Close.
- **저장 SP**: `SCM.SCM0002_SET_TITLESET_POPUP` (SaveTitleSet L425~569). '^' 구분 payload: `p_program_id`, `p_sheet_name`, `p_column_type`, `p_active_flag`(행마다 "I"), `p_column_name`, `p_sort_order_no`(iCount 증가값; _isBaseSort 면 빈값), `p_sub_total_flag`(Y/N), `p_sort_method_code`(USER_SORT_METHOD_CODE), `p_user_id`. finally 에서 `MSG00020`{Column|Measure} + `FindButton()`. iCount==0 이면 `MSG00093`{Column|Measure}. 예외 시 `MSG00006`.
- **호출측 반환 소비**: `DialogResult.OK` 인 경우에만 DMF0049 가 `InitSpread()` 재실행 (L1550~1553) — 반환 데이터 없음(서버 저장 기반).

### 6.3 SCM0002_ProjectbyDivisionPopupEx (Project 선택 — 그리드 PROJECT_CODE 더블클릭)

- **진입 조건**: 편집 중 신규/기존 행의 `PROJECT_CODE` 셀 더블클릭 (§4.2). 호출 인자: `Form_Load(false, gsDivision_id, "ALL", "ALL", "ALL", 현재 PROJECT_CODE, true)` — ETC 포함 오버로드(팝업 L188~199, [PJ20200138]).
- **초기화** (InitControls L202~261): 콤보 4종 적재 — Division=`Data.Common(MyDivision)`, Team=`Data.UserTeamByDivision`, EndCustomer=`Data.UserEndCustomerByDivisionDept(division, sTeam)`, SalesSite=`Data.UserSiteByEndCustomer`. 이후 전달값으로 선택 고정하고 **4종 모두 Enabled=false** (L257~260). ETC=true 이므로 `chkETC.Checked=true` (L254). `IsPopup=true` (L268).
- **시트**: 타이틀 SP `DM.DM0000_GET_COMMON_SPREAD_TITLE` (`p_program_id="SCM0002"`, `p_sheet_name="ProjectPopup"`) (L451~466).
- **조회** (FindData L350~413): SP `DM.SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX`. 파라미터 순서: `p_division_id`(=`CString.GetCheckedListValue(dtDivision, ...)`), `p_dept_id`(=`clbTeam.ControlValues` 원시값 — [E20260211-001049] ALL 은 ALL 그대로 DB 처리), `p_end_customer`, `p_scm_site_id`, `p_project_code`(=txtProject.Text), `p_etc`(chkETC ? "Y":"N"). 조회 후 전 컬럼 잠금 + 폭 자동조절.
- **반환**: 버튼리스트(L426~441) Find→FindData / OK→`SetProject()`+Close / Close→Close; `spdMain_CellDoubleClick`(L443~447)→`SetProject()`+Close. `SetProject()`(L468~528): bMulltiSelect=false 경로로 활성행의 `ProjectCode`/`ProjectName`/`ProjectStatus`/`BizType`/`Currency`/`ProjectVerSeq`/`ProjectOwner` 프로퍼티 세팅. `txtProject_KeyDown` Enter → FindButton (L589~595).
- **호출측(DMF0049) 소비**: `ProjectCode`, `ProjectName` 2개만 (L1446~1456). Currency/BizType 등 나머지 프로퍼티는 소비하지 않음.

---

## 부록. 헬퍼/유틸 (활성)

| 메서드 (라인) | 역할 |
|---|---|
| `SetChangeControl` (L165~186) | FILTER_PART — `GetDMInnerTable("MyDivision"/"EndCustomerByDivision")` 분기 호출 ([PJ202350699] 속도개선) |
| `GetLookupData` (L1124~1135) | SP `SCM.SCM0001_GET_LOOKUP_VALUES`(`p_lookup_type`) — "MDF_TYPE"/"DM_COMPANY"/"REPORT_GROUP3" 에 사용 |
| `GetMeasure` (L1138~1150) | SP `DM.DMF0049_GET_MEASURE`(`p_division_id`) |
| `YearSet` (L1152~1175) / `GetCalendarYYYY` (L1178~1194) | 연도 콤보 — SP `DM.UP_FX_GetCommonDataList_DM`(CODE="CALENDAR_YYYY") |
| `GetCellNumbersByRow` (L1197~1224) / `GetCellIndexBySpanRowCells` (L1226~1232) | 나머지 연산 기반 세트 행 인덱스 산출 (비-40 사업부) |
| `GetCellColor` (L1481~1490) | 셀 **ForeColor** 반환 (SaveData 편집셀 Red 판정) |
| `SetRowSpanFucTwo` (L1492~1529) | 동일값 세로 스팬 병합 (static) |
| `GetCellIndexBySpanRowCells40` (L1612~1635) / `GetMeasureCntBy40` (L1643~1723) | 40 사업부 세트 첫 행/메저 수 산출 (DATA_SEQ 우선, [C20210506-000051]) |

## 부록. 비활성(주석) 확인 목록 — 지어내기 방지용 실측

- `sCUTOFF_YYYYMMDD` 수신 (btnSPVer_Click 내 구 `DMF0044_Sales_VersionPopUp` 호출, L1242~1249)
- ITEM_ID 더블클릭 → `DM0002_ItembyDivisionPopupEx` 팝업 (L1461~1477)
- DeleteButton 의 Action=='I' 가드 (L286~287)
- EditButton 의 전체-컬럼 LockColumn 구방식 (L362, L375~389)
- InsertRow 의 CELL_MODEL_INFO 공통 잠금(L980~981), Cell_Name 잠금(L1001~1002, L1019~1020), BIZ_TYPE_NAME40/DMS_SALES/COMPANY_ID/APPLICATION 잠금(L1033~1040), `cellTypeImage` 적용(L1042)
- InitControls 구 데이터 소스 `Data.Common(MyDivision)`(L197), `Data.UserEndCustomerByDivisionDept`(L212)
- YearSet 로컬 연도 생성 루프 (L1155~1170, [E20250121-000490] 로 주석화)
- DefColumns 의 ATTRIBUTE2/REPORT_GROUP2/REPORT_GROUP3 (L88~90)
- 팝업(United_Version)의 SingleCheck 내 GetSelections 방식 + MSG00279 (L325~345)
