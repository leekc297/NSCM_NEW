# DMF0044 Sales Reports — 주요 이벤트 상세분석

- **분석일**: 2026-07-20
- **분석 원칙**: 전수·실측 (anti-simplification). 활성 코드 기준, 주석 처리된 코드는 "비활성" 으로 분리 표기. 라인번호는 각 파일 원본 기준.

## 원천 파일 (7개, 전체 Read 완료)

| # | 구분 | 경로 | 행수 |
|---|---|---|---:|
| 1 | 정본(본화면) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.cs` | 1,483 |
| 2 | 팝업(버전 선택-구형) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_Sales_VersionPopUp.cs` | 444 |
| 3 | 팝업(버전 복사-구형) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_Sales_VersionCopyPopUp.cs` | 451 |
| 4 | 팝업(통합 버전 — 현행 사용) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_United_VersionPopup.cs` | 727 |
| 5 | 팝업(환율) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_SalesReportExchangePopup.cs` | 721 |
| 6 | 팝업(텍스트박스) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_SalesReport_TextboxPopup.cs` | 453 |
| 7 | 팝업(MDF Cut-Off — 참고) | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_MDFVersionPopUp.cs` | 440 |

보조 실측: `DMF0044_Sales_Reports.Designer.cs` (이벤트 배선 grep), Plan.UIL 변형 `GSCM.DM.Plan.UIL\DMF0044_Sales_Reports.cs` (1,405행, diff 실측).

---

## 0. 정본(Forms.UIL) vs Plan.UIL 변형 차이 요약

diff 실측 결과 변경 라인 106줄, 실질 차이는 **2건 + 헤더 주석**뿐이다 (로직 본체는 동일).

1. **정본에만 `ExcelButton()` override 존재** (정본 L380~L424, `[E20240906-001717]` 엑셀 다운로드 속도 개선): `SimplexelService.ExportFpSpread` 직접 호출로 base 엑셀 내보내기를 대체. Plan.UIL 변형에는 이 override 가 없어 BaseForm 기본 동작 사용.
2. **정본에만 `YearSet()` 이 SP 기반으로 교체됨** (`[E20250107-000806]` 조회구간 변경, 정본 L1067~L1108): Plan.UIL 변형은 -5년~+10년 하드코딩 루프, 정본은 `DM.UP_FX_GetCommonDataList_DM`(CODE=`CALENDAR_YYYY`) 호출 + `GetCalendarYYYY()` 메서드 신설.
3. 헤더 이력 주석: 정본에 2024-09-11, 2025-01-15 이력 2건 추가.

이하 전체 분석은 **정본(Forms.UIL)** 기준.

---

## 1. 초기화 체인 — Form_Load (L132~L140) / InitControls (L169~L199) / CreateSpread·InitSpread (L211~L240)

### 1.1 생성자 (L122~L130)
1. `InitializeComponent()` 후 `this.Load += Form_Load` 배선 (L127).
2. `UnFilterInsertRow = true` 설정 (L129).

### 1.2 Form_Load (L132~L140) — 호출 순서
1. `clsCtrl = new CControl(this)` (L134)
2. `InitForm()` (L136) — BaseForm 공통 초기화
3. `InitControls()` (L137) — 조회조건 콤보 로딩
4. `CreateSpread()` (L138) — 시트 생성 + InitSpread
5. `DefineProperty()` (L139) — 셀타입/모델 이벤트 배선

### 1.3 InitControls (L169~L199) — 콤보 로딩 순서·기본값 (전수)
1. `DataService.FP_Log2("SpeedUp","DMF0044","division_id_changed","start")` 속도개선 로그 (L172).
2. **Division**: `SetChangeControl("MyDivision")` (L177) → FILTER_PART (L151~L164) 에서 `Filter["GROUP_ID"]=UserInfoContext.Current["NowGroupID"]`, `Filter["USER_ID"]=UserId` 세팅 후 `DataService.GetDMInnerTable("MyDivision", Filter)` 로 `dtDivision` 취득. `clsCtrl.setListBox(dtDivision, clbDivision, false, "CODE","NAME")` (L178). *(비활성: 구 `Data.Common(Data.Type.MyDivision,...)` 호출은 L175 주석 처리 — [PJ202350699] 속도개선 대체)*
3. **Textbox 버튼 가시성**: `CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)` 가 `"82"` 이면 `lci_btnTextBox` Always, 아니면 Never (L180~L181). 즉 Textbox 팝업 버튼은 Division 82 전용.
4. `FP_Log2(... "end")` (L184).
5. **Type 콤보(clbType)**: `clbType.SelectedIndexChanged` 핸들러를 임시 해제(L186) 후 `GetLookupData("MDF_TYPE")` (SP `SCM.SCM0001_GET_LOOKUP_VALUES`, L1040~L1051) 결과로 setListBox (L187~L188), 마지막에 핸들러 재부착 (L198). 로딩 중 InitSpread 재호출 방지 목적.
6. **Year 콤보**: `YearSet()` (L189 → L1067~L1089) — SP `DM.UP_FX_GetCommonDataList_DM` (파라미터 실명 순서: `CODE`="CALENDAR_YYYY", `PARAM1`~`PARAM5`="" 6개, L1098~L1104) 로 연도 목록 취득 후 `usrYear.SelectedValue = DateTime.Now.Year` 기본값 (L1088). *(비활성: -5~+10년 하드코딩 루프는 L1070~L1083 주석 블록)*
7. **Measure**: `dtMeasure = GetMeasure()` (L191 → L1054~L1065) — SP `DM.DMF0044_GET_MEASURE`, 파라미터 `p_Data_Type` = `sDataType`(이 시점 빈 문자열) 1개. 행추가 시 2행 세트(Measure 2종) 기본값으로 사용.
8. **DataType 콤보(usrDataType)**: `GetLookupData("MDF_TYPE2")` → setListBox (L193~L194). 값 의미: `ALL`/`1`(Cutoff Data)/`2`(ETC Data) (L50 주석).
9. **Company**: `dtCompanyid = GetLookupData("DM_COMPANY")` (L196) — 캐시만 하고 화면 콤보 바인딩 없음.

### 1.4 CreateSpread (L211~L218) / InitSpread (L220~L240) — 시트 구성
1. `AddSheet(spdMain, "MDF Reports", "MDF Reports", 1, 1, 30)` — 시트명 상수 `SpdSheet.shtMain = "MDF Reports"` (L65). `siMain` 취득 + `ChangeSheet()` (L214~L215).
2. `InitSpread()` (L220~L240): SP `DM.DMF0044_GET_SPREAD_TITLE` 호출 — 파라미터 실명 순서 4개: `p_division_id`=clbDivision.ControlValues, `p_created_by`=UserId, `p_start_dt`=usrYear.SelectedValue+"0101", `p_end_dt`=usrYear.SelectedValue+"1231" (L227~L230). 즉 **선택 연도 1년치(1/1~12/31) 월 컬럼**을 타이틀로 받는다.
3. `siMain.InitSheet` → `SetSheetHeaderColumn(siMain,1)` → `CreateSheetHeaderColumnDtDiv(siMain, 1, dt, clbDivision.SelectedValue)` (L234~L236) — Division 별 분기형 헤더 생성. *(비활성: 일반형 `CreateSheetHeaderColumn` 은 L239 주석)*

### 1.5 DefineProperty (L200~L209)
1. `cellTypeImage`: `TextCellType` + 배경 이미지 `siMain.ImagePopUp`(우측 정렬) — ITEM_ID 셀의 팝업 아이콘 표시용 (L202~L204).
2. 시트 데이터모델 `Changed += spdMain_Changed` 배선 (L206~L207).
3. `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged` 배선 (L208). ⚠️ **잠재결함(실측)**: Designer.cs L450 에서 동일 핸들러가 이미 배선되어 있어 **이중 구독 → Division 변경 시 핸들러 2회 실행** (InitSpread 2회 호출).

---

## 2. FindData — 조회 (`private async void FindData()`, L431~L500)

트리거: `FindButton()` override (L246~L249), SaveData 성공 후 재조회 (L686/L699/L938/L951).

1. `CheckForIllegalCrossThreadCalls = false` (L433).
2. **검증 1건**: `txtSPVersion.Text == ""` 이면 `MessageHelper.GMessageBox("MSG00283")` 후 return (L435~L439) — 버전 미선택 차단. 이 화면의 조회 전 검증은 이것이 전부.
3. `SuspendLayout()` → `InitSpread()` 재실행 (헤더 재구성, L441~L442) → `ProgressForm` 표시 (L444~L445).
4. `SearchStartTime()` (L449) 후 `FoxAsyncProxy.ExecuteAsync<DataSet>` 로 비동기 조회 (L452~L474).
5. **조회 SP**: `DM.DMF0044_GET_SALES_REPORTS_DATA`, `CommandTimeout = 10*60`(600초). **파라미터 실명 순서 전수 (7개, L460~L466)**:
   1. `division_id` = clbDivision.ControlValues *(유일하게 p_ 접두사 없음 — 원본 그대로)*
   2. `p_mdf_type` = clbType.ControlValues
   3. `p_yyyy` = usrYear.ControlValues
   4. `p_sp_version_no` = txtSPVersion.Text
   5. `p_data_type` = usrDataType.ControlValues
   6. `p_user_group` = UserInfoContext.Current["NowGroupID"]
   7. `p_created_by` = base.UserInfo.UserId
6. **결과 소비**: 단일 DataSet 을 `siMain.Query(dsMain)` 으로 통째 바인딩 (L479). 테이블별 개별 소비 없음.
7. **Draw**: `siMain.LockColumn(0, GetMaxColumnIndex(), true)` 전체 잠금(조회 직후는 항상 읽기전용, L480) → `siMain.SmartColMerge()` 동일값 세로 머지 (L482). 별도 색상 로직은 FindData 에는 없음(편집 시 빨간 글자는 프레임워크 EDIT 표준).
8. `sDataType = usrDataType.ControlValues` 저장 — 이후 Edit/Save 분기 기준 (L483).
9. `SearchEndTime()`/`UIEndTime()` 성능로그 (L477, L486~L488; SearchEndTime 이 2회 호출됨 — 원본 그대로).
10. finally: `prg.Close()`, `CanModelChange = true`, `ResumeLayout()` (L494~L499). 예외는 `GMessageBoxForException` (L492).

---

## 3. 편집 이벤트 — EditButton (L270~L372) 잠금 규칙 전수

이 화면은 **리포트형이지만 편집 가능** (단, Data Type 별 상이). Edit 진입 조건·잠금 규칙:

1. **검증**: `sDataType == "ALL"` 이면 `MSG00321` 후 return (L272~L276) — ALL 조회분은 편집·저장 불가.
2. `siMain.SwitchLock()` 으로 잠금 토글 (L280). 행이 없으면 return (L284).
3. **계획/실적 구간 경계 컬럼(iCurCol) 산출** (L287~L315): 현재월 `yyyyMM` 과 각 데이터 컬럼의 Tag(`M_yyyyMM`) 비교.
   - 시작컬럼(MEASURE 다음)이 현재월 이상이거나 `clbType == "REPORT_BP_M"`(BP) 이면 전체 계획구간 → iCurCol=iStartCol (L295~L299).
   - 마지막 컬럼이 현재월 미만이면 전체 실적구간 → iCurCol=MaxColumnIndex (L301~L304).
   - 그 외 루프로 현재월 컬럼 탐색 (L307~L314).
4. **행별 잠금 (L318~L370)**:
   - `EDIT_FLAG == "Y"` 행: 키영역(0~MEASURE)만 잠금 — 수치 전 구간 편집 허용 (L320~L328). *(비활성: 개별 컬럼 잠금 5줄은 L322~L326 주석)*
   - `EDIT_FLAG != "Y"` 행:
     - MEASURE 가 `"LOC"`: 키영역 잠금 + 과거구간(iStartCol~iCurCol-1) 잠금 → 계획구간만 편집 (L331~L339).
     - MEASURE 에 `"RTF"` 포함 또는 `"Business_Plan"`: Division 40(소형)만 키영역 잠금(수치 편집 가능), 그 외 Division 은 행 전체 잠금 (L340~L352).
     - 그 외 MEASURE: Division 40 은 키영역+미래구간(iCurCol~Max) 잠금(=과거구간만 편집), 그 외 Division 은 행 전체 잠금 (L353~L365).

### 3.1 InsertButton → InsertRow (L251~L254, L970~L1035)
1. `usrDataType.ControlValues != "2"` 이면 return — **행추가는 ETC Data 조회 상태에서만** (L973~L974). 잠금 해제 상태 + 시트명 일치 시에만 진행 (L976~L978).
2. `GetCellNumbersByRow(ActiveRowIndex)` (L1111~L1138) 로 2행 세트 페어 인덱스 계산 → 첫 행에 ActiveCell 이동 후 `siMain.Insert(2)` 로 **2행 동시 삽입** (L982~L984).
3. DEPT_ID 콤보: `Data.Common(Data.Type.DMF0044_DEPARTMENT_TEAM2, false, "","","","Y")` 바인딩 (L990~L991).
4. 신규 2행 각각에 대해 (L993~L1028): DEPARTMENT_NAME/DEPT_NAME/CUTOFF_YYYYMMDD/NICK_NAME/SCM_SITE_ID/PROJECT_CODE/APPLICATION/BIZ_TYPE_NAME/BIZ_TYPE_NAME40/DMS_SALES/DMS_CUSTOMER 컬럼 존재 시 개별 잠금, MEASURE 잠금 + `dtMeasure.Rows[i]["CODE"]` 값 자동 세팅 (L1021~L1025), ITEM_ID 셀에 `cellTypeImage`(팝업 아이콘) 적용 (L1027).
5. `SetRowSpanFucTwo(siMain, ActiveRow, ActiveRow+1, 1, MEASURE-1)` (L1031 → 구현 L1348~L1393) — 신규 2행의 키컬럼 세로 머지.

### 3.2 DeleteButton (L256~L268)
`GetCellNumbersByRow(ActiveRowIndex)` 로 2행 세트를 구해 역순으로 `siMain.Delete()` — 세트 단위 삭제. *(비활성: I-flag 검사 L258~L259 주석)*

---

## 4. SaveData — 저장 (`private async void SaveData()`, L502~L968)

트리거: `SaveButton()` override (L374~L377). **Data Type 별 2 분기 + 공통 검증**:

### 4.0 공통 검증 (L504~L514)
1. `txtSPVersion.Text == ""` → `MSG00281` return.
2. `sDataType == "ALL"` → `MSG00321` return (ALL 은 저장 불가).

### 4.1 분기 A — `sDataType == "2"` (ETC Data, L515~L715)
전제: 잠금 해제 상태(`IsLock == false`) + 시트명 "MDF Reports" (L517~L519). ProgressForm 표시.

1. **payload 조립 (2행 세트 단위, L552~L648)**: `i += 2` 루프. 세트의 두 행 Action 이 모두 빈 값이면 skip, 아니면 `iCount++`.
2. 데이터 컬럼 루프(MEASURE+1 ~ Max): **셀 ForeColor 가 Red(=편집됨)이고 값이 비어있지 않은 컬럼만** 수집 대상 (L566~L567, `GetCellColor` L1337~L1346 — ForeColor 반환).
3. **검증**: 세트 첫 행 DEPARTMENT_ID 빈 값이면 `MSG00002`("Department") 후 전체 중단 return (L570~L575).
4. `^` 구분자 문자열로 **행1·행2 를 연달아 2 세트 append** — 행2 는 MEASURE 만 `i+1` 행 값(L638), 나머지 키는 행1 값 재사용. 조립 항목(세트당 21종): active_flag(=action), division_id, version_no(=txtSPVersion), cutoff_type(=clbType.ControlValues), cutoff_yyyymmdd(=`sCUTOFF_YYYYMMDD` — 아래 §5.4 참조, 현행 흐름에선 항상 빈 값), department_id/name, dept_id/name, end_cust_report, cust_report, product_group, item_id, measure, currency, company_id, yyyymmdd(컬럼 Tag `M_` 제거), qty, created_by, cell_model_info, cell_model.
5. **저장 SP**: `iCount > 0` 일 때만 `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C` 호출, timeout 600초. **파라미터 실명 순서 전수 (21개, L657~L677)**: `p_active_flag`, `p_division_id`, `p_version_no`, `p_cutoff_type`, `p_cutoff_yyyymmdd`, `p_department_id`, `p_department_name`, `p_dept_id`, `p_dept_name`, `p_end_cust_report`, `p_cust_report`, `p_product_group`, `p_item_id`, `p_measure`, `p_yyyymmdd`, `p_currency`, `p_company_id`, `p_qty`, `p_created_by`, `p_cell_model_info`, `p_cell_model` — 모두 선두 `^` 제거(`Remove(0,1)`) 후 전달.
6. **결과 처리 (L683~L700)**: Tables[0][0][0] == `"success"` → `MSG00004`(iCount) + `FindData()` 재조회 / 테이블 존재 시 그 값을 메시지 ID 로 직접 표시 / 그 외 `MSG00004` + 뷰포트 TopRow 유지 후 FindData. 예외 `GMessageBoxForException`, finally `prg.Close()`.

### 4.2 분기 B — `sDataType == "1"` (Cutoff Data, L716~L967)
전제 동일. **1행 단위 루프(`i += 1`)** 이며 **Action == "M" 인 행만** 대상 (L756~L762).

1. 데이터 컬럼 루프에서 Red+비빈값 셀만 수집 (L771). DEPARTMENT_ID 빈 값 검증 동일(`MSG00002`, L776~L781).
2. 분기 A 와 달리 END_CUST_REPORT/CUST_REPORT/PRODUCT_GROUP/ITEM_ID/MEASURE/CURRENCY/SCM_SITE_ID/PROJECT_CODE/COMPANY_ID/FCST_TYPE/INCOTERMS/CELL_MODEL_INFO/CELL_MODEL 은 **컬럼 존재 여부(`GetColumnIndex > 0`) 확인 후 조립** (sTemp 패턴, L805~L858 — 2020-05-19 "savedata 에 컬럼별 존재여부 확인 추가" 이력분). *(비활성: 구 2행 세트 조립 블록 L861~L893 주석)*
3. **저장 SP**: `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF`, timeout 600초. **파라미터 실명 순서 전수 (25개, L905~L929)**: `p_active_flag`, `p_division_id`, `p_version_no`, `p_cutoff_type`, `p_cutoff_yyyymmdd`, `p_department_id`, `p_department_name`, `p_dept_id`, `p_dept_name`, `p_end_cust_report`, `p_cust_report`, `p_product_group`, `p_item_id`, `p_measure`, `p_yyyymmdd`, `p_currency`, `p_scm_site_id`, `p_project_code`, `p_company_id`, `p_fcst_type`, `p_incoterms`, `p_qty`, `p_created_by`, `p_cell_model_info`, `p_cell_model` (분기 A 21개 + scm_site_id/project_code/fcst_type/incoterms 4개 추가).
4. 결과 처리는 분기 A 와 동일 패턴 (L935~L952).

---

## 5. 버전 팝업 4종

### 5.1 DMF0044_United_VersionPopup (727행) — **본화면에서 실제 호출되는 유일한 버전 팝업**

- **진입**: 본화면 `btnSPVer_Click` (정본 L1148~L1164): `new DMF0044_United_VersionPopup()` → `pop.Form_Load(clbDivision.ControlValues, clbType.ControlValues)` (오버로드 L109~L113: `_sDiv`/`_sType` 저장) → `ShowDialog()` → **반환값**: `txtSPVersion.Text = pop.sVersions` (L1154). *(비활성: 구 Sales_VersionPopUp 호출 + `sCUTOFF_YYYYMMDD` 수신 블록은 L1156~L1163 주석 — 따라서 현행 흐름에서 본화면 `sCUTOFF_YYYYMMDD` 는 항상 "" 로 저장 SP 에 전달됨)*
- **초기화** (Form_Load L92~L107, InitControls L115~L141): MyDivision 콤보(선택값 `_sDiv`, Enabled=false), 기간 기본 -1개월~+5개월, `BasicDate.Enabled=false`, `chkUpdate.Checked=true`. Type 콤보는 `_sType=="REPORT_SP_W"` 이면 lookup `MDF_TYPE_SP_POPUP`, 아니면 `MDF_TYPE_BP_POPUP` (L130~L137). `ControlDisplay()` (L503~L579) 로 Type 값별 버튼/컨트롤 가시성 전환: `SP_W`/`BP_M`/`SP_M`(Plan 계열) = Version Create 만 노출, `REPORT_*`(Copy 계열) = Transfer/Cancel/VersionCopy/VersionDelete/OK/Result/BasicDate 노출. SP_W·SP_M·REPORT_SP_W 는 MV(월) 컨트롤 추가 노출. `IsPopup=true`, `IsPopupEditCheck=false` (L105~L106).
- **조회 SP** (FindData L220~L259): `DM.DMF0044_GET_SALES_VERSION_POPUP`, timeout 600초 — 파라미터 5개 순서: `p_division_id`, `p_sdt`, `p_edt`, `p_version_type`(clbType.ControlValues), `p_Description`(txtDesc.Text). 결과 `Query` 후 DIVISION_ID~끝 잠금 + SmartColMerge.
- **행 선택**: `spdMain_CellClick` (L693~L711) — 클릭 행을 녹색(RGB 215,227,188) 하이라이트하고 `giRowIndex` 저장, 나머지는 흰색 복원. `SingleCheck()` (L323~L347) 는 `giRowIndex` 반환 (구 다중선택 검사 코드는 전부 비활성 주석).
- **선택 반환**: `btnOK_Click` (L481~L489) — 선택 행 VERSION_NO → `sVersions` 후 Close. `spdMain_CellDoubleClick` (L349~L356) — Type 이 `REPORT_BP_M`/`REPORT_SP_W` 일 때만 더블클릭으로 동일 반환.
- **부가 기능 버튼 (전수)**:
  - `btnTransfer_Click` (L376~L394): SEND_YN=="N" 행만 → `DMF0044_MOBILE_REPORT_CREATE(row,"T")` (GDW 전송). 아니면 `MSG00318` 확인.
  - `btnTranCancel_Click` (L396~L418): SEND_YN=="Y" 행만 → `MSG00195` 확인 후 `DMF0044_MOBILE_REPORT_CREATE(row,"C")` (전송 취소). 아니면 `MSG00319`.
  - `btnVerDel_Click` (L420~L441): SEND_YN 이 "N" 또는 "C" 인 행만 → `MSG00016` 확인 후 `DMF0044_SAVE_SALES_PLAN_VERSION_COPY(row,"D")` (버전 삭제). 아니면 `MSG00320`.
  - `btnVerCopy_Click` (L443~L468): 실적포함(chkResult) 미체크 시 `MSG00314` 확인 후 진행 → `DMF0044_SAVE_SALES_PLAN_VERSION_COPY(row,"CP")` (버전 복사).
  - `btnVerCre_Click` (L470~L479): `DMF0044_SAVE_SALES_PLAN_VERSION_COPY(row,"CR")` (Sales Plan 버전으로부터 Report 버전 생성).
  - `btnFind_Click`/`usrButton1_Click` (L371~L374, L686~L689): FindData.
  - `chkResult_CheckedChanged` (L302~L321): 체크 시 BasicDate 활성+오늘값, chkUpdate 강제 체크+비활성. 해제 시 역방향.
  - `chkMV_CheckedChanged` (L713~L725): 체크 시 MvMonth 활성 + 전월(yyyyMM) 기본값.
- **실행 SP 2종**:
  - `DMF0044_MOBILE_REPORT_CREATE` 메서드 (L581~L627): SP `DM.DMF0044_MOBILE_REPORT_CREATE` — 파라미터 5개: `p_division_id`(SelectedValue), `p_version_no`(선택 행), `p_version_type`(clbType.SelectedValue), `p_action_type`("T"/"C"), `p_created_by`. success → `MSG00004`(1) + FindData, 실패 → 반환 문자열을 메시지 ID 로 표시.
  - `DMF0044_SAVE_SALES_PLAN_VERSION_COPY` 메서드 (L629~L682): SP `DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY` — 파라미터 8개 순서: `p_division_id`, `p_version_no`(선택 행), `p_version_description`(txtDesc), `p_created_by`, `p_result_date`(chkResult 체크 시 BasicDate yyyyMMdd, 아니면 ""), `p_action_type`("D"/"CP"/"CR"), `p_mv_plan_yyyymm`(chkMV 체크 시 MvMonth), `p_update_yn`(chkUpdate Y/N). 결과 처리 동일 패턴.
- BaseForm override: FindButton=FindData, Insert/Delete/Edit = 빈 구현(주석), SaveButton→`SaveData()` 이나 **SaveData 본체가 빈 메서드** (L261~L264) — 실질 저장 없음.

### 5.2 DMF0044_Sales_VersionPopUp (444행) — 구형. **현행 본화면에서는 호출 경로 없음** (btnSPVer 의 호출 코드가 주석 처리됨, 정본 L1156~L1163)

- **초기화** (Form_Load L88~L102): 기간 -1개월~+5개월, InitControls (L132~L143) 에서 Division(전체)·MyDivision 2종 로드 후 MyDivision 을 clbDivision 에 바인딩, `Enabled=false`. `LoadData(sVersion_Type, sFlag)` (L104~L126): 전송모드(sFlag=true)면 타이틀 "MDF Version[전송]" + Transfer 레이아웃 노출, 아니면 "MDF Version" + Copy 버튼 노출.
- **시트**: `MDFVerpopup2`, 헤더는 공통 SP `DM.DMF0000_GET_COMMON_SPREAD_TITLE` (파라미터 6개: `p_start_yyyymmdd`="" , `p_end_yyyymmdd`="", `p_created_by`, `p_program_id`="DMF0044", `p_sheet_name`="MDFVerpopup2", `p_division_id`) (L162~L179).
- **조회 SP** (FindData L195~L239): `DM.DMF0044_GET_SALES_VERSION_POPUP` — 파라미터 4개: `p_division_id`, `p_sdt`, `p_edt`, `p_version_type`(this.sVersion_Type). United 버전과 달리 `p_Description` 없음.
- **선택 반환** (SetItem L324~L359): 전송모드면 `MSG00280` 차단. 선택 범위 RowCount>1 이면 `MSG00279`. 단일 행이면 `sVersions`=VERSION_NO, **`sCUTOFF_YYYYMMDD`=YYYYMMDD 컬럼값** 반환 후 Close — 본화면 `sCUTOFF_YYYYMMDD`(저장 파라미터) 의 원 공급자였음. 트리거: OK 버튼(L302~L304) 또는 `spdMain_CellDoubleClick` (L318~L322).
- **버튼**: btnButtonList(Find/OK/Close, L295~L309), `btnCopy_Click` (L361~L371) → `DMF0044_Sales_VersionCopyPopUp` 호출 후 FindData, `btnTransfer_Click` (L373~L441) → 단일 행 검사 후 SP `DM.DMF0044_MOBILE_REPORT_CREATE` (파라미터 4개: `p_division_id`, `p_version_no`, `p_version_type`, `p_created_by` — action_type 없음). 결과 "MSG00156" 분기 처리.
- `spdMain_TopChange` (L311~L316): SmartColMerge 재적용.
- SaveData (L241~L291) 존재하나 **FoxDataRequest("") 빈 SP명** — 미완/사용 안 함(호출자 없음).

### 5.3 DMF0044_Sales_VersionCopyPopUp (451행) — Sales_VersionPopUp 의 Copy 버튼에서만 진입 (현행 본화면 경로에서는 도달 불가)

- **초기화**: 기간 오늘~+5개월. `LoadData` (L103~L121): sVersion_Type 을 `"REPORT_SP_W"→"SP_W"` / 그 외 `"BP_M"` 으로 변환. 타이틀 "Version Copy". 시트 `MDFVerpopup`, 헤더 공통 SP 동일 (L156~L173).
- **조회 SP** (FindData L188~L241): `DM.DMF0044_GET_COPY_VERSION_POPUP` — 파라미터 6개 순서: `p_start_yyyymmdd`, `p_end_yyyymmdd`, `p_created_by`, `p_division_id`, `p_version_type`(SP_W/BP_M), `p_version_no`(txtDes.Text — 설명 입력란을 검색어로 사용).
- **저장** (SaveData L243~L346, Save 버튼 트리거 L357~L364; 전송모드면 `MSG00280` 차단): 선택 단일 행 검사(`MSG00279`) 후 VERSION_NO 취득 → sVersion_Type 에 따라 SP 분기: `SP_W`→`DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY`, 그 외→`DM.DMF0044_SAVE_BIZ_PLAN_VERSION_COPY`. 파라미터 4개: `p_division_id`, `p_version_no`(선택 버전), `p_version_description`(txtDes), `p_created_by`. 결과: "MSG00156"/"success"(`MSG00004`+Close)/기타 메시지.
- **버튼**: Find/Save/Close (btnButtonList), `btnTransfer_Click` (L378~L446) — 5.2 와 동일한 `DM.DMF0044_MOBILE_REPORT_CREATE` 호출. `spdMain_TopChange` (L371~L376) SmartColMerge.

### 5.4 DMF0044_MDFVersionPopUp (440행, 참고) — **본화면(정본) 어디에서도 인스턴스화되지 않음** (grep 실측: 정본 내 참조 0건; L58 주석 "MDF Version 팝업에서 전달" 만 흔적)

- Cut-Off 실행형 팝업. 시트 "Cut-Off PopUp", 컬럼은 코드에서 직접 구성 (InitSpread L163~L184: Division 콤보 + Version NO/Type/Description/yyyyMMdd/Ver Seq/Update By/Update Date 텍스트 컬럼).
- `LoadData(sVersion_Type, sFoxData)` (L115~L128): 타이틀 "Ver. Cut-Off [type]", 실행 SP 명을 인자로 주입 (기본값 `DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF`, L47).
- **조회** (FindData L245~L298): SP `DM0021_GET_DM_MST_VERSION` (`CUIControl.GetAsyncDataUsingByDB`) — NameValueCollection 6개: `p_division_id`, `p_version_description`(txtDes), `p_version_type`(txtType), `p_from_yyyymmdd`, `p_to_yyyymmdd`, `p_created_by`. 전체 잠금 + SmartColMerge + SetPreferredWidth.
- **실행** (SaveData L300~L348, Confirm 버튼 L422~L424 트리거): Division 체크값을 `,` split 하여 **Division 별 반복 호출** — 주입된 sFoxData SP 에 `p_division_id`, `p_version_description` 2개 파라미터. 결과 문자열 누적 후 `MSG00143`(division, 결과) 표시 + FindData.
- 버튼: Find/Close/Confirm 만 활성 (L393~L426, Edit/Insert/Delete/Save/OK/Excel 케이스는 주석). InsertRow/EditButton 본체 전부 주석(비활성). `spdMain_TopChange` (L433~L438).

---

## 6. DMF0044_SalesReportExchangePopup — 환율 팝업 (721행)

- **진입** (본화면 `btnExchangeRate_Click`, 정본 L1421~L1455): 검증 2건 — ① 시트가 잠금 해제(편집 모드) 상태면 `MSG00142` 차단 (L1428~L1433), ② `txtSPVersion` 빈 값이면 `MSG00281` (L1435~L1439). 통과 시 `popup.LoadData(usrYear.ControlValues, txtSPVersion.Text)` 후 ShowDialog. **반환값 소비 없음** *(비활성: `popup.blnOK` 후속 재조회 블록 L1446~L1454 주석)*.
- **초기화**: LoadData (L91~L101) 에서 YearSet(-5~+10년 하드코딩, L104~L119) + 연도 세팅 + `_sVersionNo` 저장. InitControls (L125~L138): MyDivision(clbDivision), Division 전체(dtDivision2 — 그리드 Division 콤보용), `CURRENCY_LIST`(dtCurrency — Unit 콤보용).
- **권한** (DefineProperty L140~L163): `NowGroupID` 가 `ADMIN`/`DM ADMIN` 이 아니면 Edit/Insert/Save 버튼 숨김. EditButton (L327~L390)·SaveButton (L392~L407) 에서도 동일 그룹 재검사 (비권한: MessageBox / `MSG00096`).
- **시트 구성** (InitSpread L248~L301): Action + Division(콤보)/Currency/Unit(콤보)/CURRENCY_UNITCURRENCY(숨김) 고정 컬럼 후, SP `DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE`(파라미터 `p_year` 1개) 로 월 컬럼(CALENDAR_MONTH, Tag=`D`+BASIS_START_DATE) 동적 추가, 연도 헤더 span. Freeze(UNIT_CURRENCY+1). *(비활성: 구 주간 SQL 직조회 버전 `InitSpread_X` L176~L246 — 호출자 없음)*
- **조회** (FindData L413~L465) — **2 SP 2 단계**:
  1. `DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP` (`CUIControl.GetDataUsingByDBEx`) — 파라미터 4개: `p_division_id`(체크값), `p_year`, `p_created_by`, `p_version_no`. 행 골격(통화쌍 목록) 바인딩 후 전체 잠금.
  2. `DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA` — 동일 파라미터 4개. 반환 행(DIVISION_ID/CURRENCY/UNIT_CURRENCY/YYYYMMDD/EXCHANGE_PRICE)을 골격 테이블에서 `Select` 매칭하여 해당 (행, YYYYMMDD 컬럼) 셀에 SetText 로 피벗 채움 (L443~L458).
  3. Action 컬럼 추가 + AcceptChanges + SmartColMerge + SetPreferredWidth (L460~L463).
- **편집** (EditButton L327~L390): 권한 통과 시 SwitchLock 후 DIVISION_ID~CURRENCY_UNITCURRENCY 키 잠금. *(비활성: BP/연도별 과거월 잠금 로직 L347~L388 전체 주석)*
- **행추가** (InsertRow L614~L653): Insert 후 CURRENCY 기본값 "KRW" + 잠금, DIVISION_ID 에 MyDivision 콤보. 과거 연도 조회 중이면 현재월 이전 컬럼 LockRange (L631~L650). DeleteButton (L318~L325): Action 빈 행 제외 후 Delete.
- **저장** (SaveData L467~L612):
  1. I-flag 행 필수값 검증: Division/Currency/Unit 빈 값 시 `MSG00002`(누락 필드명) + 해당 행 포커스 (L479~L514).
  2. I/M/D 행 × Red(편집) 셀만 수집 (L518~L560). 셀 값 규칙: 빈 값→"0" 저장, "0"→action "D"(삭제), 그 외→action "" (L539~L544).
  3. `CString.AppendStringEx` 로 `^` 연결 — **파라미터 실명 순서 전수 (10개, L546~L554)**: `p_active_flag`, `p_division_id`, `p_version_no`(=_sVersionNo), `p_YYYYMMDD`(Tag 의 `D` 제거), `p_CURRENCY`, `p_UNIT_CURRENCY`, `p_EXCHANGE_PRICE`, `p_CREATED_BY`, `p_LAST_UPDATED_BY`.
  4. EXCHANGE_PRICE 실질값(0/^ 제거 후) 없으면 `MSG00002`("[EXCHANGE_PRICE]") 차단 (L563~L571).
  5. **저장 SP**: `DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT` — nvc 전체를 루프로 전달 (L575~L589). 결과 첫 셀 != "success" 면 행 전체를 이어붙여 MessageBox("Error!"), success 면 `MSG00004`(수정 행 수) + FindData (L592~L609).
- **그리드/버튼 이벤트**: btnButtonList (L677~L707) — Find/Edit/Insert/Delete/Save/OK(blnOK=true 후 Close)/Close/Excel. `spdMain_TopChange` (L714~L719) SmartColMerge. CellDoubleClick 등 기타 그리드 이벤트 없음.

---

## 7. DMF0044_SalesReport_TextboxPopup — 텍스트박스(월별 코멘트) 팝업 (453행)

- **용도**: 버전별 월 코멘트(DESCRIPTION1~13, 13개월) 조회·편집. **Division 82 전용** (본화면 InitControls L181 / clbDivision_SelectedIndexChanged L1464 에서 버튼 가시성 제어).
- **트리거** (본화면 `btnTextbox_Click`, 정본 L1468~L1480): `txtSPVersion` 빈 값이면 `MSG00281` 차단 → `popup.LoadData(txtSPVersion.Text)` 후 ShowDialog. **반환값 소비 없음** (blnOK 세팅만 존재, 본화면 미사용).
- **시트 구성** (InitSpread L140~L165): Action + 기준월(sMonday, 미조회시 이번주 월요일)부터 13개월 `yyyy-MM` 헤더의 DESCRIPTION1~13 텍스트 컬럼(폭 290).
- **조회** (FindData L233~L272): SP `DM.DMF0044_GET_TEXTBOX` — 파라미터 `P_VERSION_NO` 1개. Tables[1]("MONDAY") 있으면 기준월 갱신 후 InitSpread 재실행 (L259~L263). Query 후 1~Max 컬럼 잠금, `SetChangeRequestInfo()` (L427~L451) 로 전 셀 Multiline TextCellType(MaxLength 8000) + 행높이 300 적용.
- **권한**: Exchange 팝업과 동일 — ADMIN/DM ADMIN 외 Edit/Insert/Save 숨김 (L109~L129), EditButton(L185~L211)·SaveButton(L213~L227) 재검사(`MSG00096`). EditButton 은 행이 없으면 1행 자동 생성 (L204~L207).
- **저장** (SaveData L274~L375): 행 루프로 DESCRIPTION1~13 텍스트 수집(실질 마지막 행 값) 후 SP `DM.DMF0044_SAVE_TEXTBOX` — **파라미터 실명 순서 전수 (16개, L326~L341)**: `P_VERSION_NO`, `P_YYYYMM`(sMonday yyyyMM), `P_DESCRIPTION1`~`P_DESCRIPTION13`, `P_CREATED_BY`. 결과: success→`MSG00004`(1)+FindData / Tables.Count!=1→`MSG00006` / 첫 컬럼명 "ERR_MSG"→해당 값 메시지 / 그 외 `MSG00006`.
- **버튼**: btnButtonList (L392~L413) — Edit/Save/OK/Close/Excel (Find/Insert/Delete 는 override 가 빈 구현 L171~L183). `spdMain_TopChange` (L420~L425).

---

## 8. 본화면 그리드 이벤트 배선 전수 (실측: 코드 L206~L208 + Designer.cs grep)

| 이벤트 | 핸들러 | 배선 위치 | 내용 |
|---|---|---|---|
| Sheet DataModel `Changed` | `spdMain_Changed` (L1166~L1305) | 코드 DefineProperty L207 | 아래 상세 |
| `spdMain.CellDoubleClick` | `spdMain_CellDoubleClick` (L1307~L1334) | Designer L637 | 아래 상세 |
| `clbDivision.SelectedIndexChanged` | `clbDivision_SelectedIndexChanged` (L1457~L1466) | Designer L450 **+ 코드 L208 (이중)** | InitSpread + 버전 초기화 + Textbox 버튼 가시성(82) |
| `clbType.SelectedIndexChanged` | `clbType_SelectedIndexChanged` (L1394~L1403) | Designer L310 | InitSpread + txtSPVersion=null + 라벨 "SP Version"/"BP Version" 전환 |
| `btnSPVer.Click` | `btnSPVer_Click` (L1148) | Designer L275 | §5.1 |
| `btnMeasure.Click` | `btnMeasure_Click` (L1407~L1418) | Designer L415 | `DM0002_TitleSetForm_Popup("DMF0044", 시트명, false)` — OK 시 InitSpread (Measure 타이틀 설정) |
| `btnExchangeRate.Click` | `btnExchangeRate_Click` (L1421) | Designer L205 | §6 |
| `btnTextbox.Click` | `btnTextbox_Click` (L1468) | Designer L167 | §7 |

**본화면에 없는 그리드 이벤트 (정직 표기)**: `TopChange`(팝업들과 달리 본화면은 미배선 — SmartColMerge 는 FindData 시점에만), `CellClick`, `ButtonClicked`, `EditModeOn/Off` 등은 배선·핸들러 모두 없음.

### 8.1 spdMain_Changed (L1166~L1305) — CellsUpdated 시 Auto-Sync 전수
1. **DEPARTMENT_ID 변경 시** (L1174~L1217):
   - 값 != "기타": DEPT_ID 콤보를 `Data.Common(DMF0044_DEPARTMENT_TEAM, false, 부서명, "")` 로 교체 + 중앙정렬, ITEM_ID/NICK_NAME/END_CUST_REPORT/CUST_REPORT/PRODUCT_GROUP 5개 셀 클리어.
   - 값 == "기타": DEPT_ID 콤보를 `DMF0044_ETC_SALE_RESULT_TYPE_40` 로 교체, END_CUST_REPORT/CUST_REPORT/PRODUCT_GROUP 콤보를 빈 1행 dtNull 로 교체 후 동일 5개 셀 클리어.
2. **DEPT_ID 변경 시** (L1219~L1293):
   - 부서값 존재 시: END_CUST_REPORT 콤보=`DMF0044_MDF_ENDCUST_REPORT`, PRODUCT_GROUP 콤보=lookup `REPORT_GROUP3` + 중앙정렬.
     - 팀 != "MDF": CUST_REPORT 콤보=`DMF0005_REPORT_GROUP2`, ITEM_ID/NICK_NAME 에 "기타매출" 세팅 후 END_CUST/CUST/PRODUCT_GROUP 클리어 (L1242~L1256). ⚠️ CUST_REPORT 콤보 세팅만 `siMain.ActiveRowIndex` 기준(L1245) — 나머지는 e.Row 기준(원본 그대로).
     - 팀 == "MDF": CUST_REPORT 콤보=빈 dtNull, ITEM_ID/NICK_NAME 포함 5개 셀 클리어 (L1257~L1275).
   - 부서값 없음: END_CUST_REPORT=dtNull·PRODUCT_GROUP=REPORT_GROUP3 콤보 후 3개 셀 클리어 (L1278~L1292).
3. **수치 컬럼(MEASURE 이후) 변경 시** (L1295~L1302): Action 이 "M" 이고 값이 빈 셀이면 "0" 자동 세팅 — 빈값 저장 방지.

### 8.2 spdMain_CellDoubleClick (L1307~L1334)
ITEM_ID 컬럼 더블클릭 + 값 != "기타매출" 일 때만: `DM0002_ItembyDivisionPopupEx` 팝업 `Form_Load(false, 행의 DIVISION_ID, DEPT_ID 표시텍스트, "","","","")` → 반환 `popItem.ItemID` 를 해당 셀, `popItem.ItemName` 을 NICK_NAME 에 세팅. *(비활성: SCM_SITE_ID/PROJECT_CODE 세팅 L1325~L1326 주석)*

---

## 9. 버튼 전수 (BaseForm override + 커스텀)

### 9.1 BaseForm override (본화면)
| 버튼 | 위치 | 동작 |
|---|---|---|
| Find | L246~L249 | `FindData()` (§2) |
| Insert | L251~L254 | `InsertRow()` — ETC(2) 조회 상태 전용 2행 세트 삽입 (§3.1) |
| Delete | L256~L268 | 2행 세트 역순 삭제 (§3.2) |
| Edit | L270~L372 | ALL 차단(`MSG00321`) + SwitchLock + Measure/Division/구간별 잠금 규칙 (§3) |
| Save | L374~L377 | `SaveData()` (§4) |
| Excel | L380~L424 | 정본 전용 override — `SimplexelService.ExportFpSpread(fps, exportOption)`; 옵션: Merge=None, Border=All, AheadZero=HideZero, AmendZero=ShowZero, NullToZero=false×2, 파일명 `{화면명}_{yyyyMMddHHmmss}.xlsx`(StartupPath), AmendDecimalFormat=`#,##0.000;[Red]-#,##0.000`; finally `MessageService.CloseProgress()` |

### 9.2 커스텀 버튼 (본화면)
| 버튼 | 핸들러 | 동작 |
|---|---|---|
| SP/BP Version (btnSPVer) | L1148~L1164 | United_VersionPopup → txtSPVersion 반영 (§5.1) |
| Measure (btnMeasure) | L1407~L1418 | DM0002_TitleSetForm_Popup(타이틀셋) → OK 시 InitSpread |
| Exchange Rate (btnExchangeRate) | L1421~L1455 | 편집모드 차단(`MSG00142`)·버전 필수(`MSG00281`) 후 환율 팝업 (§6) |
| Textbox (btnTextbox) | L1468~L1480 | 버전 필수(`MSG00281`) 후 Textbox 팝업 (§7) — Division 82 에서만 노출 |

---

## 10. 사용 SP 인벤토리 (본화면 + 팝업, 전수)

| SP (FoxData) | 호출 위치 | 용도 |
|---|---|---|
| `DM.DMF0044_GET_SPREAD_TITLE` | 정본 InitSpread L225 | 본화면 헤더(1년 월 구간) |
| `DM.DMF0044_GET_SALES_REPORTS_DATA` | 정본 FindData L458 | 본조회 (7 파라미터) |
| `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C` | 정본 SaveData L656 | ETC(2) 저장 (21 파라미터) |
| `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF` | 정본 SaveData L904 | Cutoff(1) 저장 (25 파라미터) |
| `SCM.SCM0001_GET_LOOKUP_VALUES` | 정본 L1046 / United L364·L294 | lookup (MDF_TYPE, MDF_TYPE2, DM_COMPANY, REPORT_GROUP3, MDF_TYPE_SP_POPUP, MDF_TYPE_BP_POPUP) |
| `DM.DMF0044_GET_MEASURE` | 정본 L1060 | 행추가용 Measure 2종 |
| `DM.UP_FX_GetCommonDataList_DM` | 정본 L1098 | 연도 콤보 (CALENDAR_YYYY) — 정본 전용 |
| `DM.DMF0044_GET_SALES_VERSION_POPUP` | United L233 / Sales_Ver L208 | 버전 목록 조회 |
| `DM.DMF0044_GET_COPY_VERSION_POPUP` | Copy L210 | 복사 대상 버전 조회 |
| `DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY` | United L642 / Copy L302 | 버전 복사/생성/삭제 (action D/CP/CR) |
| `DM.DMF0044_SAVE_BIZ_PLAN_VERSION_COPY` | Copy L304 | BP 버전 복사 |
| `DM.DMF0044_MOBILE_REPORT_CREATE` | United L593 / Sales_Ver L406 / Copy L411 | GDW 전송/취소 (action T/C) |
| `DM.DMF0000_GET_COMMON_SPREAD_TITLE` | Sales_Ver L167 / Copy L161 / United L274 | 팝업 공통 헤더 |
| `DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE` | Exchange L263 | 환율 팝업 월 헤더 |
| `DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP` | Exchange L426 | 환율 행 골격 |
| `DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA` | Exchange L441 | 환율 값 피벗 |
| `DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT` | Exchange L579 | 환율 저장 (10 파라미터) |
| `DM.DMF0044_GET_TEXTBOX` / `DM.DMF0044_SAVE_TEXTBOX` | Textbox L247 / L282 | 코멘트 조회/저장 (16 파라미터) |
| `DM0021_GET_DM_MST_VERSION` / `DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF`(주입) | MDFVer L269 / L327 | (미호출 팝업) 버전 조회 / Cut-Off 실행 |

## 11. Validation 메시지 인벤토리 (전수)

MSG00002(필수값), MSG00004(저장건수), MSG00006(저장실패), MSG00016(삭제확인), MSG00096(권한없음), MSG00142(편집모드차단), MSG00143(Cut-Off 결과), MSG00151(버전생성 결과), MSG00156(버전결과), MSG00195(전송취소확인), MSG00279(버전 1개 선택), MSG00280(전송모드 저장불가), MSG00281(버전 필수-저장/팝업진입), MSG00283(버전 필수-조회), MSG00314(계획만 복사확인), MSG00318/MSG00319/MSG00320(SEND_YN 상태 불일치), MSG00321(ALL 편집·저장 불가).
