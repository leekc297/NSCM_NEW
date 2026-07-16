# DMF0044 Sales Reports (판매실적 리포트 · "MDF Reports") — 상세 동작 명세 (개발 이관용)

> **원천**: AS-IS `GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.cs` (**실측 1,483줄**) + `.Designer.cs` (**716줄**) 전수 Read.
> **화면 ID / 시트**: `DMF0044` / 그리드 시트명 = **"MDF Reports"** (`SpdSheet.shtMain`, Designer 폼 Text = `DMF0044_MDF_Reports`). 단계 = **DM(Demand) / Plan**. 도메인 정본 = `Plan.UIL`(호출 팝업) + `Forms.UIL`(메인 폼).
> **전용 팝업 3종 (실제 호출)**: `GSCM.DM.Plan.UIL\POPUP\DMF0044_United_VersionPopup.cs`(727줄, 버전 조회/복사/생성/전송 통합 — L1150 호출) · `DMF0044_SalesReportExchangePopup.cs`(721줄, 환율 등록/조회 — L1441 호출) · `DMF0044_SalesReport_TextboxPopup.cs`(453줄, 월별 코멘트 13칸 — L1476 호출, **Division 82 전용**). 공용 팝업: `DM0002_ItembyDivisionPopupEx`(그리드 Item 셀 더블클릭 — L1317) · `DM0002_TitleSetForm_Popup`(Measure Show — L1409).
> **데이터 접근**: 레거시 FoxData (`FoxDataClient` / `FoxAsyncProxy.ExecuteAsync` / `Data.Common` / `GetLookupData` / `DataService`). 핵심 엔드포인트 —
> `DM.DMF0044_GET_SALES_REPORTS_DATA`(조회, 7 param) / `DM.DMF0044_GET_SPREAD_TITLE`(동적 헤더, 4 param) / `DM.DMF0044_GET_MEASURE`(Measure 행 정의) / `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C`(ETC 저장 21 param) / `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF`(Cutoff 저장 25 param) / `SCM.SCM0001_GET_LOOKUP_VALUES`(MDF_TYPE/MDF_TYPE2/REPORT_GROUP3) / `DM.UP_FX_GetCommonDataList_DM`(CALENDAR_YYYY) — 팝업 SP: `DMF0044_GET_SALES_VERSION_POPUP` / `DMF0044_SAVE_SALES_PLAN_VERSION_COPY`(복사/생성/삭제) / `DMF0044_MOBILE_REPORT_CREATE`(GDW 전송/취소) / `DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE` / `DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP(_DATA)` / `DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT` / `DMF0044_GET_TEXTBOX` / `DMF0044_SAVE_TEXTBOX`. **TO-BE 대응 = `PKG_DMF0044` SP**.
> **범위**: 화면 이벤트/액션 **29 전수** 상세 (핸들러 wire + body + 호출메서드 1-depth) + 팝업 흐름 **5** (United Version / Exchange / Textbox / Item / Measure).
> **화면 특성 = 3축 분기 화면**: ① **Report Type**(`clbType`: `REPORT_SP_W` 주간 SP / `REPORT_BP_M` 월간 BP) → 라벨/버전유형/편집구간 분기, ② **Data Type**(`usrDataType`: `ALL` 전체보기(편집불가) / `1` Cutoff Data / `2` ETC Data) → 저장 SP·행 구조 분기, ③ **Division**(`clbDivision`: `40` 소형 / 그 외) → 과거구간 편집 허용 여부 + `82` 시 Text 입력 버튼 노출. 버킷 축은 **월(Monthly) 단일**(M_YYYYMM 동적 컬럼 + 년도 헤더 span), DMF0042 의 Q_/Y_ 롤업은 **없음**.
> **편집제어 방식 = 이중 게이트** (§1 [9] EditButton 상세): (1) **화면 게이트** — `Data Type == "ALL"` 이면 편집·저장 전면 차단(MSG00321), TO-BE 는 여기에 `USER_MNU_EDIT_AUTH_V.EDIT_YN` 권한 게이트가 겹침, (2) **행 게이트** — GET SP(`DMF0044_GET_SALES_REPORTS_DATA`)가 행별 `EDIT_FLAG` 를 계산해 반환 → EditButton 이 `EDIT_FLAG=='Y'` 행만 수량 편집 개방, 그 외 행은 Measure(LOC/RTF/Business_Plan/SalesAmt)·Division(40 여부)·시점(현재월 기준 계획/실적 구간)에 따라 차등 잠금.

> ⚠ 이 문서는 **개발자용 기술 상세본**입니다. User 관점 가독본은 **UI분석서 시트 5** 참조. (§4 User 관점 변환 요지 = 시트5 반영용 요약)

---

## 1. 이벤트 · 액션 상세 (29)

> Report Type 표기: **SP_W**(`REPORT_SP_W`, 주간 Sales Plan 리포트) / **BP_M**(`REPORT_BP_M`, 월간 Business Plan 리포트). Data Type 표기: **ALL**(전체·읽기전용) / **1**(Cutoff Data) / **2**(ETC Data·행추가 가능). Division 표기: **40**(소형 — 과거구간 편집 허용) / **그 외**(과거구간 편집 불가) / **82**(ESS — Text 입력 버튼 노출).

### ▣ 초기화

#### [1] ctor `DMF0044_Sales_Reports()`
- **트리거**: 인스턴스 생성  ·  **컨트롤/소스**: Form (`InitializeComponent`)
- **소스라인**: `122-130`  ·  **호출 메서드**: `InitializeComponent`
- **실제 동작 (실측)**: ① `this.Load += Form_Load`(127) 배선 → ② `UnFilterInsertRow=true`(129, 필터 상태에서도 Insert 허용)

#### [2] Form_Load
- **트리거**: Form load  ·  **컨트롤/소스**: `this.Load += Form_Load` (ctor L127)
- **소스라인**: `132-140`  ·  **호출 메서드**: `new CControl(this)`(134), `InitForm`(BaseForm, 136), `InitControls`(137), `CreateSpread`(138), `DefineProperty`(139)
- **데이터/SP**: 하위 메서드 참조  ·  **Division 분기**: InitControls 내부에서 처리
- **실제 동작 (실측)**: ① clsCtrl 생성 → `InitForm()`(BaseForm 표준 초기화) → `InitControls()` → `CreateSpread()` → `DefineProperty()` 순차. (DMF0042 와 달리 `InitSaveDataTable` 없음 — 저장버퍼는 SaveData 가 그리드 직접 스캔으로 조립)

#### [3] InitControls
- **트리거**: Form_Load 내부  ·  **컨트롤/소스**: 조회조건 컨트롤 바인딩
- **소스라인**: `169-199`  ·  **호출 메서드**: `DataService.FP_Log2`(속도개선 로그), `SetChangeControl("MyDivision")`, `clsCtrl.setListBox`, `CString.GetCheckedListValue`, `GetLookupData`, `YearSet`, `GetMeasure`
- **데이터/SP**: `MyDivision`(SetChangeControl → `DataService.GetDMInnerTable`) / `GetLookupData("MDF_TYPE")`·`("MDF_TYPE2")`·`("DM_COMPANY")`(→ `SCM.SCM0001_GET_LOOKUP_VALUES`) / `GetMeasure`(→ `DM.DMF0044_GET_MEASURE`) / `YearSet`(→ `DM.UP_FX_GetCommonDataList_DM` CALENDAR_YYYY)
- **Division 분기**: `sDivision=="82"` 이면 `lci_btnTextBox.Visibility=Always`, 아니면 `Never`(181) — **Text 입력 버튼은 ESS(82) 전용**
- **실제 동작 (실측)**:

    ① FP_Log2 시작 로그(172) → `SetChangeControl("MyDivision")`(177)로 `dtDivision` 적재 → `setListBox(dtDivision, clbDivision)`(178)
    ② 현재 Division 값 추출(180) → **82 여부로 btnTextbox 표시/숨김**(181)
    ③ `clbType` 이벤트 detach(186) → `GetLookupData("MDF_TYPE")` 로 Report Type 콤보 바인딩(187-188) → `YearSet()`(189, 연도 콤보 + 당해년도 기본값)
    ④ `dtMeasure = GetMeasure()`(191, Measure 행 정의 테이블) → `usrDataType` = MDF_TYPE2 콤보(193-194) → `dtCompanyid` = DM_COMPANY(196)
    ⑤ `clbType` 이벤트 재attach(198)

#### [4] DefineProperty
- **트리거**: Form_Load 내부  ·  **컨트롤/소스**: 그리드 이미지 셀타입 + 이벤트 배선
- **소스라인**: `200-209`  ·  **호출 메서드**: `TextCellType`(팝업버튼 이미지), `dsdm.Changed += spdMain_Changed`, `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged`
- **실제 동작 (실측)**: ① `cellTypeImage`(ITEM_ID 셀용 팝업버튼 배경) 생성(202-204) → ② **`dsdm.Changed += spdMain_Changed`**(207, 그리드 값변경 배선) → ③ `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged`(208, **코드 배선 — Designer L460 과 이중 배선**)

#### [5] CreateSpread / InitSpread
- **트리거**: Form_Load 내부 (+ 각 조회/타입변경 시 InitSpread 재호출)  ·  **컨트롤/소스**: spdMain (FpSpread)
- **소스라인**: `CreateSpread 211-218 / InitSpread 220-240`  ·  **호출 메서드**: `AddSheet(spdMain,"MDF Reports","MDF Reports",1,1,30)`, `GetSheetInfo`, `siMain.ChangeSheet`, `siMain.SetSheetHeaderColumn`, `siMain.CreateSheetHeaderColumnDtDiv`
- **데이터/SP**: `DM.DMF0044_GET_SPREAD_TITLE` (4 param: `p_division_id`=clbDivision.ControlValues / `p_created_by` / `p_start_dt`=usrYear+"0101" / `p_end_dt`=usrYear+"1231")
- **실제 동작 (실측)**:

    ① `AddSheet(...,1,1,30)`(213, 헤더 **1단** + 데이터폭 30) → siMain 확보 → ChangeSheet
    ② InitSpread: `DMF0044_GET_SPREAD_TITLE` 로 동적 컬럼정의 dt 조회(225-232, **선택 연도 1~12월 구간**) → `InitSheet`(234) → `SetSheetHeaderColumn(siMain,1)`(235) → **`CreateSheetHeaderColumnDtDiv(siMain,1,dt,Division)`**(236, Division 조건부 컬럼 생성 — 월별 M_YYYYMM 컬럼 + 년도 헤더 span)

### ▣ 조회조건 (Report Type / Division cascade)

#### [6] clbType_SelectedIndexChanged  ⭐ Report Type 전환
- **트리거**: Report Type combo change  ·  **컨트롤/소스**: clbType (Designer L316 + 코드 detach/attach L186·198)
- **소스라인**: `1394-1403`  ·  **호출 메서드**: `InitSpread`
- **데이터/SP**: `DMF0044_GET_SPREAD_TITLE`(InitSpread)  ·  **분기**: `clbType.ControlValues == "REPORT_SP_W"` → 라벨 "SP Version" / else "BP Version"
- **실제 동작 (실측)**: ① `InitSpread()`(1396, 헤더 재생성) → ② `txtSPVersion.Text=null`(1397, 버전 초기화 — 타입 바뀌면 버전 무효) → ③ 라벨 텍스트 SP/BP 전환(1399-1402)

#### [7] clbDivision_SelectedIndexChanged
- **트리거**: Division combo change  ·  **컨트롤/소스**: clbDivision (Designer L460 + 코드 L208 이중 배선)
- **소스라인**: `1457-1466`  ·  **호출 메서드**: `InitSpread`, `CString.GetCheckedListValue`
- **데이터/SP**: `DMF0044_GET_SPREAD_TITLE`(InitSpread)  ·  **Division 분기**: `sDivision=="82"` → btnTextbox Always / else Never
- **실제 동작 (실측)**: ① `siMain != null` 가드 → `InitSpread()`(1461, Division 기준 컬럼 재생성) → ② `txtSPVersion.Text=""`(1462, 버전 초기화) → ③ **82 여부로 btnTextbox 표시/숨김**(1464)

#### [8] btnSPVer_Click — 버전 선택 팝업 열기
- **트리거**: 버전 '...' 버튼 click  ·  **컨트롤/소스**: btnSPVer (Designer L280)
- **소스라인**: `1148-1164`  ·  **호출 메서드**: `DMF0044_United_VersionPopup.Form_Load(division, type)`, `ShowDialog`
- **데이터/SP**: 전용 팝업 `DMF0044_United_VersionPopup` (→ §3 팝업 흐름 A)  ·  **분기**: 없음 (팝업 내부에서 SP_W/BP_M 분기)
- **실제 동작 (실측)**: ① `new DMF0044_United_VersionPopup()` → `Form_Load(clbDivision.ControlValues, clbType.ControlValues)`(1151, 오버로드 — Division/Type 를 팝업 필드에 저장) → `ShowDialog()`(1152) → ② `txtSPVersion.Text = pop.sVersions`(1154, 팝업에서 선택/더블클릭한 버전 반영). ※ L1156-1163 구 `DMF0044_Sales_VersionPopUp` 호출 코드는 **전량 주석**(United 팝업으로 통합됨)

### ▣ CRUD 버튼 (BaseForm override)

#### [9] FindButton (override) → FindData()
- **트리거**: Find toolbar 버튼 / F5  ·  **컨트롤/소스**: Common toolbar (BaseForm hotkey)
- **소스라인**: `246-249(override) / FindData 431-500 (async)`  ·  **호출 메서드**: `FindData()`, `InitSpread`, `FoxAsyncProxy.ExecuteAsync('DM.DMF0044_GET_SALES_REPORTS_DATA')`, `siMain.Query`/`LockColumn`/`SmartColMerge`
- **데이터/SP**: SP `DM.DMF0044_GET_SALES_REPORTS_DATA` (**Table[0]=본문 그리드**; 행별 `EDIT_FLAG` 포함 = 편집 게이트)  ·  **MSG**: MSG00283  ·  **CommandTimeout**: 10분
- **분기**: 파라미터 `division_id`/`p_mdf_type`(Report Type)/`p_yyyy`(연도)/`p_data_type`(ALL/1/2)/`p_user_group`(권한 그룹) 조합. 조회 후 `sDataType = usrDataType.ControlValues`(483) 로 편집 게이트 상태 확정
- **실제 동작 (실측)**:

    ① `CheckForIllegalCrossThreadCalls=false`(433) → **버전 검증**: `txtSPVersion.Text==""` → **MSG00283**(Version 선택 후 조회)(437) return
    ② `SuspendLayout` + `InitSpread()`(441-442, 헤더 재생성) → ProgressForm 표시(444-445)
    ③ `SearchStartTime()` → `FoxAsyncProxy.ExecuteAsync DM.DMF0044_GET_SALES_REPORTS_DATA`(454-474) — **파라미터 7종**: `division_id`(clbDivision.ControlValues) / `p_mdf_type`(clbType.ControlValues) / `p_yyyy`(usrYear.ControlValues) / `p_sp_version_no`(txtSPVersion.Text) / `p_data_type`(usrDataType.ControlValues) / `p_user_group`(NowGroupID) / `p_created_by`(UserId)
    ④ `SearchEndTime()` → `siMain.Query(dsMain)`(479) → **`LockColumn(0, max, true)`**(480, 조회 직후 전체 잠금 = 읽기전용 기본) → `SmartColMerge()`(482) → **`sDataType = usrDataType.ControlValues`**(483, 편집 게이트 갱신) → UIEndTime
    ⑤ catch: `GMessageBoxForException`(492); finally: ProgressForm.Close + `CanModelChange=true` + ResumeLayout(496-498)

#### [10] EditButton (override)  ⭐ 이중 게이트 편집제어
- **트리거**: Edit toolbar 버튼 / F2  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `270-372`  ·  **호출 메서드**: `MessageHelper.GMessageBox`, `siMain.SwitchLock`, `siMain.GetColumnTag`(M_YYYYMM), `siMain.GetValue`(EDIT_FLAG/MEASURE/DIVISION_ID), `siMain.LockRange`
- **데이터/SP**: 없음 (로컬 잠금)  ·  **MSG**: MSG00321  ·  **분기**: Data Type(ALL 차단) + 행별 EDIT_FLAG + Measure(LOC/RTF/Business_Plan/SalesAmt) + Division(40 여부) + 시점(현재월 계획/실적 구간)
- **실제 동작 (실측)**:

    ① **화면 게이트**: `sDataType=="ALL"` → **MSG00321**(전체보기 모드는 편집 불가)(274) return
    ② `siMain.SwitchLock()`(280, Lock↔Edit 토글) → `GetMaxRowIndex()<0` 이면 return(284)
    ③ **현재월 구간 컬럼(iCurCol) 산정**(287-315): 시작컬럼(MEASURE 우측 첫 M_)이 현재월 이상이거나 Report Type=`REPORT_BP_M` 이면 전체 계획구간(iCurCol=iStartCol) / 마지막 컬럼이 현재월 미만이면 전체 실적구간(iCurCol=max) / else 현재월 태그 컬럼 탐색
    ④ **행별 잠금 루프**(318-370):
      · **`EDIT_FLAG=='Y'`**(320) → `LockRange(iRow, 0, iRow, MEASURE, true)`(327, **좌측 키만 잠금 → 수량 컬럼은 편집 개방** = 이 행은 편집 대상)
      · **EDIT_FLAG≠'Y' & Measure=="LOC"**(331) → 키 잠금(333) + 계획구간 이전(iStartCol~iCurCol-1) 잠금(337) — LOC 는 계획구간만 편집
      · **EDIT_FLAG≠'Y' & Measure∋"RTF" 또는 =="Business_Plan"**(340-341) → Division `40` 은 키만 잠금(수량 편집 허용, 346) / **그 외 Division 은 전 컬럼 잠금**(350, 수량 편집 불가)
      · **EDIT_FLAG≠'Y' & 그 외 Measure(SalesAmt 등)**(353) → Division `40` 은 키 잠금 + **현재월 이후(iCurCol~max) 잠금**(과거 실적구간만 편집, 358-359) / 그 외 Division 은 전 컬럼 잠금(363)
    · ⚠ **TO-BE 편집 판정 로직 요약**: FE 는 (a) `dataType!=='ALL'` **및** `USER_MNU_EDIT_AUTH_V.EDIT_YN==='Y'`(화면 게이트) 를 먼저 통과시키고, (b) 행별 `EDIT_FLAG==='Y'` 이면 수량셀 개방, 아니면 `MEASURE`+`DIVISION_ID`+현재월 기준으로 셀 `isReadOnly` 를 계산해야 함. 개발 시 이 4-변수(게이트/EDIT_FLAG/Measure/Division·시점)를 모두 재현하지 않으면 편집 허용 범위가 어긋남.

#### [11] InsertButton (override) → InsertRow()
- **트리거**: Insert toolbar 버튼 / F8  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `251-254(override) / InsertRow 970-1035`  ·  **호출 메서드**: `GetCellNumbersByRow`, `siMain.Insert(2)`, `Data.Common(DMF0044_DEPARTMENT_TEAM2)`, `siMain.SetCellTypeCombo`, `siMain.LockRange`(메타 컬럼), `siMain.SetValue`(Measure), `SetRowSpanFucTwo`
- **데이터/SP**: 콤보 `DMF0044_DEPARTMENT_TEAM2`(Data.Common)  ·  **분기**: **Data Type=="2"(ETC) 전용**(973 — 아니면 즉시 return)
- **실제 동작 (실측)**:

    ① `usrDataType.ControlValues != "2"` → return(973-974, **ETC Data 일 때만 행추가 가능**)
    ② `!IsLock && SheetName=="MDF Reports"` 확인(976-978) → 활성행 기준 `Insert(2)`(984, **Measure 2행 블록 삽입** — dtMeasure 2행: 예 Business_Plan/LOC 계열)
    ③ DEPT_ID 팀 콤보 = `DMF0044_DEPARTMENT_TEAM2`(990-991)
    ④ **2행 반복**(993-1028): DEPARTMENT_NAME/DEPT_NAME/CUTOFF_YYYYMMDD/NICK_NAME/SCM_SITE_ID/PROJECT_CODE/APPLICATION/BIZ_TYPE_NAME(40)/DMS_SALES/DMS_CUSTOMER 각 컬럼 존재 시 Lock(996-1019) → MEASURE 컬럼 Lock + `SetValue(dtMeasure.Rows[i]["CODE"])`(1021-1025) → ITEM_ID 셀에 `cellTypeImage`(팝업버튼) 부착(1027)
    ⑤ `SetRowSpanFucTwo(siMain, activeRow, activeRow+1, 1, MEASURE-1)`(1031, 2행 블록 좌측 키 세로병합)

#### [12] DeleteButton (override)
- **트리거**: Delete toolbar 버튼 / F9  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `256-268`  ·  **호출 메서드**: `GetCellNumbersByRow`, `siMain.Delete`
- **데이터/SP**: 없음 (로컬 그리드)  ·  ⚠ **Action=='I' 가드 주석 처리**(258-259) — DMF0042 와 달리 신규행 제한 없이 활성 블록 삭제
- **실제 동작 (실측)**: ① `GetCellNumbersByRow(활성행)`(261, 2행 Measure 블록 인덱스 산정) → ② 역순으로 각 행 SetActiveCell 후 `Delete()`(263-267)

#### [13] SaveButton (override) → SaveData()  ⭐ Data Type 3분기
- **트리거**: Save toolbar 버튼 / F7  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `374-377(override) / SaveData 502-968 (async)`  ·  **호출 메서드**: `SaveData()`, `GetCellColor`(빨강=수정셀), `siMain.GetValue`/`GetText`/`GetColumnTag`, `FoxDataClient.ExecuteDataSet`, `FindData`(재조회)
- **데이터/SP**: **Data Type 분기** — `"2"`(ETC) → `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C`(21 param) / `"1"`(Cutoff) → `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF`(25 param)  ·  **MSG**: MSG00281, MSG00321, MSG00002, MSG00004  ·  **CommandTimeout**: 10분
- **실제 동작 (실측)**:

    ① **버전 검증**: `txtSPVersion.Text==""` → **MSG00281**(506) return
    ② **화면 게이트**: `sDataType=="ALL"` → **MSG00321**(512) return
    ③ **분기 A — `sDataType=="2"`(ETC Data, 515-715)**: `!IsLock && SheetName=="MDF Reports"` 확인 → **`i += 2` (2행 블록 순회, 552)**: 블록의 두 행 Action(i, i+1) 모두 공란이면 continue(556) → MEASURE 우측 컬럼별 순회(561): 두 행 중 하나라도 **빨강(수정) & 값 존재**이면(566-567) → DEPARTMENT_ID 공란 시 **MSG00002 {"Department"}**(572) return → **i 행 + i+1 행 각각 파라미터 '^' 누적**(577-645, 두 Measure 행 모두 전송) → `DMF0044_SAVE_SALES_PLAN_REPORT_C` 호출(656-701, **21 param**: active_flag/division_id/version_no/cutoff_type/cutoff_yyyymmdd/department_id/department_name/dept_id/dept_name/end_cust_report/cust_report/product_group/item_id/measure/yyyymmdd/currency/company_id/qty/created_by/cell_model_info/cell_model)
    ④ **분기 B — `sDataType=="1"`(Cutoff Data, 716-967)**: **`i += 1` (단일행 순회, 756)**: `Action!="M"` 이면 continue(759, **수정행만**) → MEASURE 우측 컬럼별 순회(766): **빨강 & 값 존재**만(771) → DEPARTMENT_ID 공란 시 **MSG00002**(778) return → 각 컬럼 존재 여부(`GetColumnIndex>0`) 확인 후 파라미터 '^' 누적(783-858) → `DMF0044_SAVE_SALES_PLAN_REPORT_C_CF` 호출(904-953, **25 param**: 분기 A 21종 + `scm_site_id`/`project_code`/`fcst_type`/`incoterms` 추가, company_id 위치 상이)
    ⑤ **공통 결과 처리**: Table[0][0]=="success" → **MSG00004 {iCount}**(N건 저장) + `FindData()` 재조회 / Tables.Count≠0 → SP 반환 메시지 passthrough(GMessageBox) / else → MSG00004 + 뷰포트 top 유지 후 재조회

#### [14] ExcelButton (override)
- **트리거**: Excel toolbar 버튼  ·  **컨트롤/소스**: Common toolbar (BaseForm)
- **소스라인**: `380-424`  ·  **호출 메서드**: `SimpleExcelExportOption`, `SimplexelService.ExportFpSpread`, `MessageService.CloseProgress`
- **데이터/SP**: 없음 (로컬 Export)  ·  ⚠ `[E20240906-001717]` 엑셀 다운로드 속도개선 — BaseForm 기본 대신 `SimplexelService` 직접 사용
- **실제 동작 (실측)**: ① Export 옵션 구성(Merge=None, Border=All, HideZero/ShowZero, 소수 3자리 서식)(382-401) → ② `SimplexelService.ExportFpSpread(fps, exportOption)`(405, `{FormName}_{yyyyMMddHHmmss}.xlsx`) → finally `CloseProgress`(414)

### ▣ 그리드 편집 · 배분

#### [15] spdMain_Changed  ⭐ 부서/팀 cascade + 신규셀 정규화
- **트리거**: Grid cell value changed (edit/combo)  ·  **컨트롤/소스**: `dsdm.Changed += spdMain_Changed` (코드 배선 L207)
- **소스라인**: `1166-1305`  ·  **호출 메서드**: `Data.Common`(DMF0044_DEPARTMENT_TEAM/ETC_SALE_RESULT_TYPE_40/MDF_ENDCUST_REPORT/DMF0005_REPORT_GROUP2), `GetLookupData("REPORT_GROUP3")`, `siMain.SetCellTypeCombo`/`SetText`
- **데이터/SP**: 콤보 룩업 (부서→팀, 팀→고객/제품군)  ·  **분기**: DEPARTMENT_ID 값 "기타" 여부 / DEPT_ID(팀) "MDF" 여부
- **실제 동작 (실측)**:

    ① **DEPARTMENT_ID 셀 변경**(1174-1217): 값≠"기타" → 팀 콤보=`DMF0044_DEPARTMENT_TEAM`(1180-1181) + ITEM/NICK/END_CUST/CUST/PRODUCT 셀 clear(1187-1191) / 값=="기타" → 팀 콤보=`DMF0044_ETC_SALE_RESULT_TYPE_40`(1195-1196) + 고객/제품 콤보를 빈 콤보로 세팅 + 셀 clear(1202-1215)
    ② **DEPT_ID(팀) 셀 변경**(1219-1293): 부서명 존재 시 → EndCust=`DMF0044_MDF_ENDCUST_REPORT` + Product=`REPORT_GROUP3` 콤보(1231-1232) → 팀명≠"MDF" 이면 Customer=`DMF0005_REPORT_GROUP2` 콤보 + ITEM/NICK="기타매출"(1244-1255) / 팀명=="MDF" 이면 Customer 빈 콤보 + 셀 clear(1259-1274) → 부서명 공란이면 EndCust 빈 콤보 + Product 콤보만(1280-1291)
    ③ **수량셀 정규화**(1295-1302): MEASURE 우측 컬럼 & Action=="M" & 값 공란이면 → `SetText(e.Row, e.Column, "0")`(1299, 빈 수정셀 → "0")

#### [16] spdMain_CellDoubleClick — Item 팝업
- **트리거**: Grid cell double click  ·  **컨트롤/소스**: spdMain.CellDoubleClick (Designer L648)
- **소스라인**: `1307-1334`  ·  **호출 메서드**: `DM0002_ItembyDivisionPopupEx.Form_Load`, `ShowDialog`, `siMain.SetText`
- **데이터/SP**: 공용 팝업 `DM0002_ItembyDivisionPopupEx` (→ §3 팝업 흐름 D)  ·  **분기**: ITEM_ID 값 =="기타매출" 이면 팝업 미호출
- **실제 동작 (실측)**: ① `e.Column == ITEM_ID` & 값≠"기타매출"(1309-1314) → Division/팀(DEPT_ID) 수집 → `DM0002_ItembyDivisionPopupEx.Form_Load(false, div, team, ...)`(1319) 모달 → ② `siMain.SetText(ITEM_ID, popItem.ItemID)` + `SetText(NICK_NAME, popItem.ItemName)`(1323-1324)

### ▣ 액션 버튼 (Measure · 환율 · Text)

#### [17] btnMeasure_Click — Measure Show 팝업
- **트리거**: Measure Show 버튼 click  ·  **컨트롤/소스**: btnMeasure (Designer L424, Tag "Measure Show")
- **소스라인**: `1407-1418`  ·  **호출 메서드**: `DM0002_TitleSetForm_Popup(mode=false)`, `InitSpread`
- **데이터/SP**: 공용 팝업 `DM0002_TitleSetForm_Popup` (Measure 메타 Show/Hide) → OK 시 `InitSpread` 재구성
- **실제 동작 (실측)**: ① `new DM0002_TitleSetForm_Popup("DMF0044", siMain.SheetName, **false**)`(1409, false=Measure 모드) 모달 → ② `DialogResult==OK` 이면 `InitSpread()`(1416) 로 헤더 재적용

#### [18] btnExchangeRate_Click — 환율 등록/조회 팝업
- **트리거**: Exchange Rate 버튼 click  ·  **컨트롤/소스**: btnExchangeRate (Designer L208)
- **소스라인**: `1421-1455`  ·  **호출 메서드**: `siMain.IsLock`, `DMF0044_SalesReportExchangePopup.LoadData`, `ShowDialog`
- **데이터/SP**: 전용 팝업 `DMF0044_SalesReportExchangePopup` (→ §3 팝업 흐름 B)  ·  **MSG**: MSG00142, MSG00281
- **실제 동작 (실측)**: ① 편집모드(`!IsLock`)면 **MSG00142**(Edit 모드 환율 금지)(1431) return → ② `txtSPVersion.Text==""` → **MSG00281**(1437) return → ③ `new DMF0044_SalesReportExchangePopup()` → `LoadData(usrYear.ControlValues, txtSPVersion.Text)`(1442) 모달. ⚠ 닫힌 후 `blnOK` 재조회 블록은 **주석 처리**(1446-1454) — 메인 그리드 자동 갱신 없음(사용자가 재조회 필요)

#### [19] btnTextbox_Click — 월별 코멘트 팝업 (ESS 82 전용)
- **트리거**: Text 입력 버튼 click  ·  **컨트롤/소스**: btnTextbox (Designer L169; **Division 82 일 때만 노출**, InitControls/clbDivision_SIC)
- **소스라인**: `1468-1480`  ·  **호출 메서드**: `DMF0044_SalesReport_TextboxPopup.LoadData`, `ShowDialog`
- **데이터/SP**: 전용 팝업 `DMF0044_SalesReport_TextboxPopup` (→ §3 팝업 흐름 C)  ·  **MSG**: MSG00281
- **실제 동작 (실측)**: ① `txtSPVersion.Text==""` → **MSG00281**(1472) return → ② `new DMF0044_SalesReport_TextboxPopup()` → `LoadData(txtSPVersion.Text)`(1477) 모달

### ▣ 내부 헬퍼 (호출메서드 1-depth)

#### [20] SetChangeControl (FILTER_PART)
- **소스라인**: `151-164` (`[PJ202350699]` 속도개선)  ·  **호출 메서드**: `DataService.GetDMInnerTable`
- **실제 동작**: `triggerControl=="MyDivision"` → `dtDivision = DataService.GetDMInnerTable("MyDivision", Filter)`(160). Filter 에 GROUP_ID/USER_ID 세팅(153-154)

#### [21] GetLookupData
- **소스라인**: `1040-1051`  ·  **SP**: `SCM.SCM0001_GET_LOOKUP_VALUES`(p_lookup_type)  ·  호출처: MDF_TYPE/MDF_TYPE2/DM_COMPANY/REPORT_GROUP3

#### [22] GetMeasure
- **소스라인**: `1054-1065`  ·  **SP**: `DM.DMF0044_GET_MEASURE`(p_Data_Type=sDataType) — 그리드 Measure 행 정의(dtMeasure)

#### [23] YearSet / GetCalendarYYYY
- **소스라인**: `YearSet 1067-1089 / GetCalendarYYYY 1092-1108`  ·  **SP**: `DM.UP_FX_GetCommonDataList_DM`(CODE="CALENDAR_YYYY")  ·  `[E20250107-000806]` 조회구간 변경 — 구 -5~+10년 하드코딩 주석, 캘린더 마스터 기반으로 교체. 기본값 = 당해년도(1088)

#### [24] GetCellNumbersByRow / GetCellIndexBySpanRowCells
- **소스라인**: `1111-1146`  ·  2행 Measure 블록 인덱스 계산(multiful=2). Delete/Insert 의 블록 단위 처리 근거

#### [25] GetCellColor
- **소스라인**: `1337-1346`  ·  셀 ForeColor 반환 (빨강=수정 표시 → SaveData 의 변경셀 판별에 사용)

#### [26] SetRowSpanFucTwo (static)
- **소스라인**: `1348-1393`  ·  2행 블록의 좌측 키 컬럼 값-동일 세로병합(년도 변경 시 span) + 중앙정렬. InsertRow 에서 호출

> ※ **비활성/미사용 멤버**: `InitEvent`(빈 메서드) · `GetLookupValues`(팝업 전용 미사용) · 구 `DMF0044_Sales_VersionPopUp` 호출부(1156-1163 주석). TO-BE 이관 대상 아님.
> ※ 우클릭 컨텍스트 메뉴 없음. spdMain 배선 이벤트는 CellDoubleClick(Designer) + Changed(코드) 2종 (DMF0042 대비 ComboSelChange/EditChange/TopChange/KeyUp 없음).

---

## 2. 버튼 · 컨트롤 인벤토리 — AS-IS 실측

### 2.1 버튼 (10)

| # | 버튼 | 위치 | 동작 | 연결 SP/팝업 | MSG | 활성/권한 | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | Find (toolbar) | toolbar | FindData(): 버전검증 + async 조회 + Query | DM.DMF0044_GET_SALES_REPORTS_DATA | MSG00283 | Always | 246-249 / 431-500 |
| 2 | Insert (toolbar) | toolbar | InsertRow(): 2행 블록 삽입 + 콤보·Lock | Data.Common(DEPARTMENT_TEAM2) | — | **Data Type="2"(ETC) 만** | 251-254 / 970-1035 |
| 3 | Delete (toolbar) | toolbar | 2행 블록 삭제 (Action 가드 주석) | — | — | Edit 모드 | 256-268 |
| 4 | Edit (toolbar) | toolbar | SwitchLock + EDIT_FLAG/Measure/Division/시점 별 잠금 | — | MSG00321 | **Data Type≠"ALL"** | 270-372 |
| 5 | Save (toolbar) | toolbar | SaveData(): Data Type 분기 '^' bulk 저장 | DMF0044_SAVE_SALES_PLAN_REPORT_C(21) / _C_CF(25) | MSG00281/00321/00002/00004 | Edit 모드; async void | 374-377 / 502-968 |
| 6 | Excel (toolbar) | toolbar | SimplexelService Export | (로컬) | — | Always | 380-424 |
| 7 | btnSPVer '...' | Version 필드 | United Version 팝업 → txtSPVersion | DMF0044_United_VersionPopup | — | Always | 280 / 1148-1164 |
| 8 | btnMeasure 'Measure Show' | 조회조건 | Measure Show/Hide 팝업(false) → InitSpread | DM0002_TitleSetForm_Popup(false) | — | Always | 424 / 1407-1418 |
| 9 | btnExchangeRate 'Exchange Rate' | 조회조건 | 환율 등록/조회 팝업 | DMF0044_SalesReportExchangePopup | MSG00142/00281 | 비편집(Lock) 만 | 208 / 1421-1455 |
| 10 | btnTextbox 'Text 입력' | 조회조건 | 월별 코멘트 13칸 팝업 | DMF0044_SalesReport_TextboxPopup | MSG00281 | **Division 82 전용** | 169 / 1468-1480 |

### 2.2 조회조건 컨트롤 (8)

| # | 컨트롤 | 라벨 | 유형 | 기본값/소스 | 분기 역할 | Cascade | 라인(Designer) |
|---|---|---|---|---|---|---|---|
| 1 | clbDivision | Division | combo (single) | MyDivision(DataService) | **82→btnTextbox / 40→과거편집** | SIC(L460+코드L208) → InitSpread + 버전 초기화 | 426-460 |
| 2 | clbType | Report Type | combo | MDF_TYPE lookup | **SP_W / BP_M** → 라벨·편집구간 | SIC(L316) → InitSpread + 버전 초기화 + 라벨 | 282-316 |
| 3 | usrYear | Year | combo | CALENDAR_YYYY; 당해년도 | 조회 기간(연도) | FindData 파라미터 p_yyyy | 318-351 |
| 4 | usrDataType | Data Type | combo | MDF_TYPE2 (ALL/1/2) | **ALL 편집차단 / 1 Cutoff / 2 ETC** | Edit·Save·Insert 게이트 | 353-386 |
| 5 | txtSPVersion | Version | multiline text (readonly) | 팝업에서 주입 | 조회/저장 필수키 | btnSPVer 팝업 | 210-243 |
| 6 | btnSPVer | (Version '...') | button | — | — | United Version 팝업 | 245-280 |
| 7 | btnMeasure | (Measure Show) | button | Tag "Measure Show" | — | Measure 팝업 | 388-424 |
| 8 | lblSPVersion | SP/BP Version | label | "SP Version" 기본 | Report Type 따라 텍스트 전환 | clbType_SIC | 490-501 |

> 그리드 `spdMain`(FpSpread, 시트 "MDF Reports", 헤더 1단 + 월(M_YYYYMM) 동적컬럼 + 년도 span). 2행 Measure 블록 구조(GetCellNumbersByRow multiful=2). 배선 이벤트 = CellDoubleClick(Designer L648) + Changed(코드 L207).

---

## 3. 팝업 흐름 ①→②③ (5)

### A. DMF0044_United_VersionPopup — 버전 통합 관리 (btnSPVer, L1150)
- **원천**: `DMF0044_United_VersionPopup.cs` (727줄)  ·  **진입**: `Form_Load(division, type)` 오버로드로 Division/Type 저장 → ShowDialog → 파라미터리스 `Form_Load` 이벤트가 InitForm/InitControls/CreateSpread/FindData 실행
- **SP**: `DM.DMF0044_GET_SALES_VERSION_POPUP`(조회 5 param) / `DM.DMF0000_GET_COMMON_SPREAD_TITLE`(헤더) / `SCM.SCM0001_GET_LOOKUP_VALUES`(MDF_TYPE_SP_POPUP / MDF_TYPE_BP_POPUP) / `DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY`(복사/생성/삭제) / `DM.DMF0044_MOBILE_REPORT_CREATE`(GDW 전송/취소)
- **흐름**:
  ① 로드 시 `clbDivision`(고정, Enabled=false, 부모 Division) + 기간(당월-1 ~ +5개월) + Report Type 콤보(SP/BP 별 lookup) + `ControlDisplay()` 로 버튼 가시성 세팅 → `FindData()`(`DMF0044_GET_SALES_VERSION_POPUP`) 로 버전 목록 조회
  ② 행 선택 = `spdMain_CellClick`(695-711, 선택행 배경 연녹색 + `giRowIndex` 저장). **버전 채택** = `spdMain_CellDoubleClick`(349-356, Report Type=REPORT_BP_M/SP_W 일 때 VERSION_NO → `sVersions` + Close) 또는 `btnOK_Click`(481-489)
  ③ 액션 버튼(각각 `SingleCheck()` 선택행 확인 후):
    · **Transfer**(`btnTransfer_Click` 376) — SEND_YN=='N' 행만 `DMF0044_MOBILE_REPORT_CREATE(row,"T")`; else **MSG00318**
    · **Cancel**(`btnTranCancel_Click` 396) — SEND_YN=='Y' 만, **MSG00195** 확인 후 `..._CREATE(row,"C")`; else **MSG00319**
    · **Version Delete**(`btnVerDel_Click` 420) — SEND_YN∈{N,C} 만, **MSG00016** 확인 후 `SAVE_SALES_PLAN_VERSION_COPY(row,"D")`; else **MSG00320**
    · **Version Copy**(`btnVerCopy_Click` 443) — 실적포함 미체크 시 **MSG00314** 확인 → `..._COPY(row,"CP")` (chkResult/BasicDate/chkMV·MvMonth/chkUpdate 파라미터 동반)
    · **Version Create**(`btnVerCre_Click` 470) — `..._COPY(row,"CR")` (Sales Plan → Sales Report 버전 생성)
  · 성공 시 **MSG00004 {1}** + FindData 재조회. `ControlDisplay()`(503-579) 가 Report Type(SP_W/BP_M/SP_M vs Copy 계열)에 따라 Transfer/Cancel/Copy/Delete/OK/Result/MV 버튼 가시성 토글

### B. DMF0044_SalesReportExchangePopup — 환율 등록/조회 (btnExchangeRate, L1441)
- **원천**: `DMF0044_SalesReportExchangePopup.cs` (721줄, `[PJ20200138]`)  ·  **진입**: `LoadData(year, versionNo)` → ShowDialog → Form_Load
- **SP**: `DM.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE`(월 헤더) / `DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP`(그리드 프레임) / `DM.DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA`(환율값 매핑) / `DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT`(저장)
- **권한**: ADMIN / DM ADMIN 만 Edit/Insert/Save (그 외 버튼 숨김 + Save 시 **MSG00096**)
- **흐름**:
  ① 로드 → InitControls(Division/Division2/Currency 콤보) → InitSpread(Division/Currency/Unit/월별 D+YYYYMMDD 컬럼 + 년도 span) → `FindData()`: 프레임 조회 후 `..._DATA` 로 CURRENCY×UNIT×DIVISION 매칭해 셀에 환율 주입(444-458)
  ② **Edit**(327) → 권한 확인 후 SwitchLock + Division~Currency_Unit 키 컬럼 잠금 / **Insert**(614) → KRW 기본행 추가 + 과거월 잠금 / 셀 편집 = 빨강 표시
  ③ **Save**(392→467): 신규행 Division/Currency/Unit 공란 검증(**MSG00002**) → 빨강 셀만 '^' 누적(price=""→"0", "0"→action 'D') → EXCHANGE_PRICE 전무 시 **MSG00002 [EXCHANGE_PRICE]** → `DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT` → 성공 **MSG00004 {건수}** + FindData. OK(`mOK`) 시 `blnOK=true`
  · ⚠ 메인 폼은 팝업 종료 후 자동 재조회 안 함(§1 [18] 주석) — 환율 반영은 사용자 재조회로 확인

### C. DMF0044_SalesReport_TextboxPopup — 월별 코멘트 13칸 (btnTextbox, L1476, Division 82)
- **원천**: `DMF0044_SalesReport_TextboxPopup.cs` (453줄, `2021 rosia27`)  ·  **진입**: `LoadData(versionNo)` → ShowDialog → Form_Load
- **SP**: `DM.DMF0044_GET_TEXTBOX`(P_VERSION_NO — Table[1].MONDAY 로 시작월 결정) / `DM.DMF0044_SAVE_TEXTBOX`(P_VERSION_NO/P_YYYYMM + P_DESCRIPTION1~13 + P_CREATED_BY)
- **권한**: ADMIN / DM ADMIN 만 Edit/Insert/Save (그 외 Save 시 **MSG00096**)
- **흐름**:
  ① 로드 → InitSpread: 시작 월요일(sMonday) 기준 13개월 컬럼(DESCRIPTION1~13, 헤더=yyyy-MM) 생성 → `FindData()`(`DMF0044_GET_TEXTBOX`): Table[1].MONDAY 로 시작월 재설정 후 InitSpread 재생성 + Query + 멀티라인 셀(높이 300, MaxLength 8000) 세팅(SetChangeRequestInfo)
  ② **Edit**(185) → 권한 확인 + SwitchLock + 행 없으면 1행 삽입
  ③ **Save**(213→274): 각 행 DESCRIPTION1~13 수집 → `DMF0044_SAVE_TEXTBOX` → 성공 **MSG00004 {1}** + FindData / 실패 **MSG00006** 또는 ERR_MSG passthrough

### D. DM0002_ItembyDivisionPopupEx — Item 선택 (그리드 ITEM_ID 더블클릭, L1317)
- **진입**: `Form_Load(false, division, team, "", "", "", "")` → ShowDialog  ·  **반환**: `ItemID` / `ItemName`
- **흐름**: ① Division·팀(DEPT_ID) 기준 Item 목록 조회(팝업 내부 SP) → ② 선택 시 그리드 ITEM_ID/NICK_NAME 셀에 반영 (§1 [16])

### E. DM0002_TitleSetForm_Popup — Measure Show/Hide (btnMeasure, L1409)
- **진입**: `new DM0002_TitleSetForm_Popup("DMF0044", sheetName, false)` → ShowDialog  ·  **반환**: DialogResult.OK
- **흐름**: ① Measure 표시/숨김 메타 편집(공용 컬럼셋 저장) → ② OK 시 `InitSpread()` 로 그리드 재구성 (§1 [17])

---

## 4. Validation 14건 + Expression 20건 매핑

### 4.1 Validation (14) — `validation.md` / `__asis-mapping__.md` 대조 (100%)

| # | Handler | MSG | 조건 | 라인 | TO-BE 매핑 |
|---:|---|---|---|---:|---|
| 1 | EditButton | MSG00321 | `sDataType=="ALL"` (전체보기 편집불가) | 274 | 화면 게이트 — `if(dataType==='ALL') showAlert(MSG00321)` |
| 2 | FindData | MSG00283 | `txtSPVersion.Text==""` (조회 전 버전) | 437 | Form validator (조회 버튼) |
| 3 | SaveData | MSG00281 | `txtSPVersion.Text==""` (저장 전 버전) | 506 | Form validator (저장) |
| 4 | SaveData | MSG00321 | `sDataType=="ALL"` (저장 차단) | 512 | 화면 게이트 |
| 5 | SaveData(ETC) | MSG00002 | Department 공란 (빨강셀 존재 시) | 572 | Zod `.min(1,'MSG00002')` — Department |
| 6 | SaveData(ETC) | MSG00004 | 저장 성공 {iCount} | 685 | `showToast(MSG00004)` |
| 7 | SaveData(ETC) | MSG00004 | 저장 성공 (Tables=0 fallback) | 694 | 동일 |
| 8 | SaveData(CF) | MSG00002 | Department 공란 | 778 | Zod `.min(1,'MSG00002')` |
| 9 | SaveData(CF) | MSG00004 | 저장 성공 {iCount} | 937 | `showToast(MSG00004)` |
| 10 | SaveData(CF) | MSG00004 | 저장 성공 (fallback) | 946 | 동일 |
| 11 | InsertRow | (분기) | `usrDataType.ControlValues!="2"` → return | 973 | `if(dataType!=='2') return` (Insert 가드) |
| 12 | btnExchangeRate_Click | MSG00142 | `!IsLock` (편집모드 환율 금지) | 1431 | `if(isEditMode) showAlert(MSG00142)` |
| 13 | btnExchangeRate_Click | MSG00281 | `txtSPVersion.Text==""` | 1437 | Form validator |
| 14 | btnTextbox_Click | MSG00281 | `txtSPVersion.Text==""` | 1472 | Form validator |

> **MSG ID 대사 주의** (메모리 `feedback_msg_id_text_reconciliation`): MSG00004 는 validation.md 에 "저장하시겠습니까?"로 기재되어 있으나 **실사용은 "{N}건 저장되었습니다"**(성공 토스트) — 실코드 `GMessageBox("MSG00004", new object[]{iCount})` 문맥이 정답. MSG00281/00321/00142 는 사내 MSG_M 실문구 대사 필요(미등록 표시). MSG00002 = "[{}] 은 필수 입력사항입니다."

### 4.2 Expression (20) — `expressions.md` 대조 (조건부 잠금 20 = LockRange)

| # | Handler | 라인 | 잠금 대상 | 조건 |
|---:|---|---:|---|---|
| 1 | EditButton | 327 | `0~MEASURE`(좌측키) | `EDIT_FLAG=='Y'` (행 편집 개방) |
| 2 | EditButton | 333 | `0~MEASURE` | `EDIT_FLAG≠'Y' & Measure=="LOC"` |
| 3 | EditButton | 337 | `iStartCol~iCurCol-1` | LOC 계획구간 이전 (`iCurCol-1>iStartCol`) |
| 4 | EditButton | 346 | `0~MEASURE` | RTF/Business_Plan & **Division 40** (수량 편집 허용) |
| 5 | EditButton | 350 | `0~max`(전체) | RTF/Business_Plan & Division≠40 (편집 불가) |
| 6 | EditButton | 358 | `0~MEASURE` | 기타 Measure & Division 40 (키 잠금) |
| 7 | EditButton | 359 | `iCurCol~max` | 기타 Measure & Division 40 (미래구간 잠금=과거만 편집) |
| 8 | EditButton | 363 | `0~max` | 기타 Measure & Division≠40 (전체 잠금) |
| 9–20 | InsertRow | 997·999·1001·1003·1007·1009·1011·1013·1015·1017·1019·1023 | DEPARTMENT_NAME / DEPT_NAME / CUTOFF_YYYYMMDD / NICK_NAME / SCM_SITE_ID / PROJECT_CODE / APPLICATION / BIZ_TYPE_NAME / BIZ_TYPE_NAME40 / DMS_SALES / DMS_CUSTOMER / MEASURE | 신규 2행 블록 메타 컬럼 잠금 (컬럼 존재 시 `GetColumnIndex≠-1`) |

> TO-BE 매핑: [1]~[8] = `isReadOnly={(item,col)=>...}` 또는 `cellEditEnding e.cancel` 로 EDIT_FLAG+Measure+Division+현재월 4변수 재현. [9]~[20] = 신규행 초기 컬럼 readonly 지정.

---

## 5. ② User 관점 변환 요지 (시트 5 반영용)

> 개발 세부(메서드명·라인·SP·detach/attach)를 제거하고 **업무 규칙 + MSG 의미**만 남긴 요지.

### 5.1 화면 성격
- **판매실적 리포트(Sales Reports, 화면상 "MDF Reports")** 는 확정된 판매 버전을 리포트 형태로 조회·보정하는 화면. 세 가지 선택으로 화면이 갈린다: **리포트 종류**(주간 SP / 월간 BP — 버전 라벨과 편집 가능 구간이 달라짐), **데이터 종류**(전체보기=읽기전용 / Cutoff 데이터 / 기타(ETC) 데이터 — 저장 방식과 행 추가 가능 여부가 달라짐), **사업부**(소형(40)은 과거 실적도 고칠 수 있고, ESS(82)는 월별 코멘트 입력 버튼이 뜬다).
- 숫자는 **월 단위**로 보며, 연도를 고르면 그 해 1~12월이 컬럼으로 펼쳐진다.

### 5.2 조회
- 먼저 **버전(Version)** 을 골라야 조회된다(안 고르면 "버전 선택" MSG00283). 버전은 '...' 버튼 → 버전 창에서 선택(더블클릭)한다.
- 사업부·리포트종류·연도·데이터종류를 정하고 조회한다.

### 5.3 편집
- 수정하려면 Edit 로 전환. **전체보기(ALL) 상태에서는 편집이 막힌다**(MSG00321) — Cutoff 또는 기타(ETC) 데이터를 골라야 한다. (실제 편집 버튼 자체는 사용자 편집권한이 있어야 활성 — TO-BE 권한 게이트).
- 어떤 칸을 고칠 수 있는지는 **행마다 다르다**: 조회 시 서버가 행별로 "편집 가능" 표시를 계산해 내려주고, 그 표시가 있는 행만 수량을 고칠 수 있다. 그 외 행은 측정치 종류(단가 LOC/실적 RTF/사업계획/판매금액)와 사업부(소형 40 여부), 그리고 이번 달 기준 계획구간/실적구간에 따라 고칠 수 있는 칸이 제한된다.
- **행 추가는 기타(ETC) 데이터일 때만** 가능하며, 추가 시 부서→팀→고객/제품군이 위에서 아래로 연동된다.

### 5.4 저장
- 저장 시 데이터 종류에 따라 규칙이 다르게 모아 한 번에 저장한다(기타=측정치 2줄 세트, Cutoff=수정한 줄만). 부서가 비면 "[Department] 필수"(MSG00002), 성공하면 "N건 저장"(MSG00004) 후 다시 조회한다. 서버 오류는 서버 메시지를 그대로 보여준다.

### 5.5 보조 기능
- **버전 창**: 버전 조회 외에 복사(Copy)/생성(Create)/삭제(Delete)/모바일 전송(Transfer)·전송취소도 여기서 한다(관리자 권한·SEND 상태별 제약, 확인 메시지 동반).
- **Exchange Rate**: 환율 등록/조회 창(편집모드에서는 못 열고 MSG00142, 버전 필수). 관리자만 저장 가능. 닫아도 화면은 자동 갱신되지 않아 다시 조회해야 반영을 본다.
- **Text 입력**: ESS(82)에서만 뜨는 버튼으로, 버전별 월별 코멘트(13칸)를 관리자만 입력·저장한다.
- **Measure Show**: 화면에 보일 측정치를 사용자가 고른다. 그리드의 모델(ITEM) 칸을 더블클릭하면 모델 선택 창이 뜬다.

---

## 6. 격차 (TO-BE 이관 관점)

| 구분 | 내용 |
|---|---|
| **FE 미개발** | `features/demand/src/pages/dmf0044-sales-reports/` **미존재**(`__asis-mapping__.md` 추정 경로, Validation 0/14·Expression 0/20 = 0% 적용). 신규 화면 작성 필요. |
| **API·PROC·BTN 미등록** | `SCM_ADM_API_M`(GET/SAVE/버전/환율/텍스트 SP 12+종), `SCM_ADM_PROC_M`(SP positional 시그니처), `MNU_BTN_MPG_M`(Find/Insert/Delete/Edit/Save/Excel + Measure/Exchange/Text/버전 버튼) 미배선 추정. FE hook 전 BE endpoint 인벤토리 필요(메모리 `feedback_be_endpoint_inventory_before_hook`). |
| **비호출 팝업 3종** | `DMF0044_MDFVersionPopUp` · `DMF0044_Sales_VersionCopyPopUp` · `DMF0044_Sales_VersionPopUp` = **레거시 버전/복사 팝업 — 현행 폼은 호출 안 함**(`DMF0044_United_VersionPopup` 로 통합, L1156-1163 구 호출부 주석). TO-BE 이관 대상 아님(참고용). |
| **자동 재조회 미배선** | Exchange Rate 팝업 종료 후 메인 그리드 자동 갱신 로직 주석 처리(§1 [18]) — TO-BE 에서는 `onSuccess → invalidate` 로 개선 검토 여지. |
| **편집 게이트 재현** | 서버 `EDIT_FLAG` + Measure + Division + 현재월 구간 4변수 + 화면 `USER_MNU_EDIT_AUTH_V.EDIT_YN` 게이트를 FE `isReadOnly` 에 정확히 재현하지 않으면 편집 허용 범위가 어긋남(anti-simplification 대상). |

---

> **실측 근거**: 본 문서의 라인 번호·파라미터·MSG·분기는 `DMF0044_Sales_Reports.cs`(**1,483줄**) + `.Designer.cs`(**716줄**) 전수 Read, 전용 팝업 3종(`United_VersionPopup` 727 / `SalesReportExchangePopup` 721 / `SalesReport_TextboxPopup` 453) Read, 공용 팝업(`DM0002_ItembyDivisionPopupEx`·`DM0002_TitleSetForm_Popup`) 호출부 실측, 기존 분석자료(`validation.md` 14 / `expressions.md` 20 / `__asis-mapping__.md`) 대조 결과이며, 주석(비활성) 코드(`InitEvent`/구 `Sales_VersionPopUp` 호출부/Exchange 재조회 블록)는 별도 명시하고 활성 코드만 기술함. 편집제어 이중 게이트(EDIT_FLAG 행계산 + USER_MNU_EDIT_AUTH_V 화면권한)는 hook #105 §2.5-3 표준에 따라 개발자 재현 관점으로 기술함.
