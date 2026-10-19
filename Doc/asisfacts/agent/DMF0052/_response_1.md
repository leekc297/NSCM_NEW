아래 5개 문서를 생성합니다. 각 문서는 Fact Pack의 사실만 사용하며, 필수 조건(엔드포인트 7개, 이벤트 핸들러 8개, 시트 7개, SP 7개)을 모두 충족합니다.

---

=== FILE: analysis.md ===
# DMF0052 EDI Summary 화면 분석서

## 1. 화면 개요
- **화면 ID**: DMF0052
- **화면명**: EDI Summary
- **도메인**: DM (Demand Management)
- **주요 기능**: ERP EDI 데이터 수신 현황 요약 및 검증 (GSCM ↔ ERP 데이터 비교)

## 2. 파일 구성
| 구분 | 파일 경로 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | DMF0052_EDISummary.csproj | 796 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | DMF0052_EDISummary.csproj | 796 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | GSCM.DM.Plan.UIL.csproj | 265 |
| shared | 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.Designer.cs | GSCM.DM.Plan.UIL.csproj | 313 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0052_EDISummary.cs | GSCM.DM.Plan.UIL.csproj | 796 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0052_EDISummary.Designer.cs | GSCM.DM.Plan.UIL.csproj | 796 |

## 3. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | SP / SQL |
|---|---|---:|---|---|
| button:FindButton | FindButton > FindData | 211 | DM.DMF0052_GET_SITE_POPUP | SP DMF0052_GET_SITE_POPUP |
| button:FindButton | FindButton > FindData_Main | 312 | DM.DMF0052_GET_SUMMARY_DATA | SP DMF0052_GET_SUMMARY_DATA |
| button:FindButton | FindButton > FindData_Pjt | 355 | DM.DMF0052_GET_PJT_DATA | SP DMF0052_GET_PJT_DATA |
| button:FindButton | FindButton > FindData_Status | 418 | DM.DMF0052_GET_STATUS_DATA | SP DMF0052_GET_STATUS_DATA |
| button:FindButton | FindButton > FindData_Status > InitSpread > GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | SP DMF0052_GET_SPREAD_TITLE |
| event:btnRefresh.Click | BtnRefresh_Click > FindData_GSCMData | 460 | DM.DMF0052_GET_DETAIL_DATA | SP DMF0052_GET_DETAIL_DATA |
| event:btnRefresh.Click | BtnRefresh_Click > FindData_GSCMData > InitSpread > GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | SP DMF0052_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData | 211 | DM.DMF0052_GET_SITE_POPUP | SP DMF0052_GET_SITE_POPUP |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | SP DMF0052_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetEdiSender | 783 | DM.UP_FX_GetCommonDataList_DM | SP UP_FX_GETCOMMONDATALIST_DM |
| event:spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick > FindData_GSCMData | 460 | DM.DMF0052_GET_DETAIL_DATA | SP DMF0052_GET_DETAIL_DATA |
| event:spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick > FindData_ERPData | 529 | DM.DMF0052_GET_ERP_DATA | SP DMF0052_GET_ERP_DATA |
| event:spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick > FindData_ERPData > InitSpread > GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | SP DMF0052_GET_SPREAD_TITLE |

## 4. 엔드포인트 전체 표
| 엔드포인트 | 상태 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) |
|---|---|---|---|
| DM.DMF0052_GET_SUMMARY_DATA | MATCH | SP DMF0052_GET_SUMMARY_DATA | SELECT:XIF_ERP_EDI_CALLOFF_ITEM_R_SN |
| DM.DMF0052_GET_PJT_DATA | MATCH | SP DMF0052_GET_PJT_DATA | CREATE:#T_GSCM_DATA, INSERT:#T_GSCM_DATA, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCM_MST_SITE_ITEM, CREATE:#T_ERP_DATA, INSERT:#T_ERP_DATA, SELECT:SCM_MST_ITEM_SN, REF:FN_GET_ITEM_NICKNAME |
| DM.DMF0052_GET_STATUS_DATA | MATCH | SP DMF0052_GET_STATUS_DATA | SELECT:DM_DNM_EDI_CALLOFF_ITEM, REF:STRING_SPLIT |
| DM.DMF0052_GET_DETAIL_DATA | MATCH | SP DMF0052_GET_DETAIL_DATA | CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_ITEM_SN |
| DM.DMF0052_GET_ERP_DATA | MATCH | SP DMF0052_GET_ERP_DATA | CREATE:#T_EDI, INSERT:#T_EDI, SELECT:DM_DNM_EDI_CALLOFF_ITEM, REF:STRING_SPLIT, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_ITEM_SN |
| DM.DMF0052_GET_SPREAD_TITLE | MATCH | SP DMF0052_GET_SPREAD_TITLE | SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT |
| DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM | SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |

## 5. 이벤트 배선 표
| 대상 | 이벤트 | 핸들러 | 위치 (줄) |
|---|---|---|---:|
| this.spdSummaryPJT | CellDoubleClick | spdPjt_CellDoubleClick | 171 |
| this.btnRefresh | Click | BtnRefresh_Click | 218 |
| this.chkToday | CheckedChanged | chkToday_CheckedChanged | 255 |
| this.btnProject | Click | btnProject_Click | 362 |
| this.btnItemId | Click | btnItemId_Click | 399 |
| this.spdData | ActiveSheetChanging | spdData_ActiveSheetChanging | 657 |
| this.spdData | CellDoubleClick | spdData_CellDoubleClick | 658 |
| this | Load | Form_Load | 123 |

## 6. Grid 구성 방식
**HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)**

화면은 메타(SCM_MST_SHEET_COLUMNS) 기반 컬럼 생성(`CreateSheetHeaderColumn` @InitSpread:192)과 코드 하드코딩을 병행합니다.

### 6.1 메타 기반 시트 (6개)
- **SUMMARY**: 날짜별 ERP/GSCM 수신 현황 (4컬럼)
- **Summary Pjt**: 프로젝트별 검증 현황 (8컬럼)
- **Summary Status**: 상태별 통계 (4컬럼)
- **GSCM Data**: Master Data 검증 상세 (10컬럼)
- **ERP Data**: ERP 데이터 상세 (10컬럼)
- **Site Popup**: Sales Site 매칭 현황 (9컬럼, 메타 정의만 존재하나 코드 미참조 → 미사용 가능)

### 6.2 코드 전용 시트 (1개, Popup)
- **EDI Summary GSCM DATA Popup** (06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs:144~155)
  - 9개 컬럼 하드코딩 (SENDER_NAME, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, SCM_SITE_ID, VALID_YN, GSCM_CODE, CODE_VALID_YN, Message)
  - PopupType != "CHECK_SALES_SITE" 조건으로 4개 컬럼 표시 분기 (실행 시점 확인 필요)

### 6.3 Division별 차이
메타는 division=81만 정의되어 있으며, 다른 division은 데이터 없음. 모든 시트가 81 고정으로 표시됨.

| 테이블 | 시트 | 81 |
|---|---|---:|
| SCM_MST_SHEET_COLUMNS | ERP Data | 10/0 (필수+기본/선택) |
| SCM_MST_SHEET_COLUMNS | GSCM Data | 10/0 |
| SCM_MST_SHEET_COLUMNS | Site Popup | 9/0 |
| SCM_MST_SHEET_COLUMNS | SUMMARY | 4/0 |
| SCM_MST_SHEET_COLUMNS | Summary Pjt | 8/0 |
| SCM_MST_SHEET_COLUMNS | Summary Status | 4/0 |

## 7. 프레임워크 메타 소비 메서드
| 호출 메서드 | 호출 위치 | 읽는 메타 컬럼 |
|---|---|---|
| GetCheckedListValue | InitControls:144, FindData_Main:278, FindData_Pjt:344, FindData_Status:407 | CODE |
| GetSpdTitle | InitSpread:191 | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:192 | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |

## 8. 확인 필요 항목
1. **Site Popup 시트**: 메타에 정의되어 있으나 코드에서 참조하지 않음 → 폐기 후보
2. **EDI Summary GSCM DATA Popup 조건 분기**: PopupType 파라미터에 따라 4개 컬럼 표시 여부 결정 → 런타임 호출 지점 확인 필요
3. **Division 단일 지원**: 현재 메타가 81만 정의. 다른 division 지원 필요 여부 확인
4. **주석 처리된 호출**: 0건 (commented_calls.csv 빈 파일)

---

=== FILE: source_links.md ===
# DMF0052 소스 링크 표

## 1. 엔드포인트 호출 지점
| 파일 | 메서드 | 줄 | 엔드포인트 | SP |
|---|---|---:|---|---|
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_Main | 312 | DM.DMF0052_GET_SUMMARY_DATA | DMF0052_GET_SUMMARY_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_Pjt | 355 | DM.DMF0052_GET_PJT_DATA | DMF0052_GET_PJT_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_Status | 418 | DM.DMF0052_GET_STATUS_DATA | DMF0052_GET_STATUS_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_GSCMData | 460 | DM.DMF0052_GET_DETAIL_DATA | DMF0052_GET_DETAIL_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_ERPData | 529 | DM.DMF0052_GET_ERP_DATA | DMF0052_GET_ERP_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | DMF0052_GET_SPREAD_TITLE |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | GetEdiSender | 783 | DM.UP_FX_GetCommonDataList_DM | UP_FX_GETCOMMONDATALIST_DM |

## 2. 이벤트 핸들러 정의
| 파일 | 이벤트 | 핸들러 | 등록 줄 |
|---|---|---|---:|
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick | 171 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.btnRefresh.Click | BtnRefresh_Click | 218 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.chkToday.CheckedChanged | chkToday_CheckedChanged | 255 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.btnProject.Click | btnProject_Click | 362 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.btnItemId.Click | btnItemId_Click | 399 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.spdData.ActiveSheetChanging | spdData_ActiveSheetChanging | 657 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.spdData.CellDoubleClick | spdData_CellDoubleClick | 658 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | this.Load | Form_Load | 123 |

## 3. Grid 시트 생성
| 파일 | 메서드 | 줄 | 시트명 | API |
|---|---|---:|---|---|
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 158 | SUMMARY | AddSheet |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 162 | Summary Pjt | AddSheet |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 166 | Summary Status | AddSheet |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 170 | GSCM Data | AddSheet |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 171 | ERP Data | AddSheet |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | CreateSpread | 129 | EDI Summary GSCM DATA Popup | AddSheet |

## 4. Grid 컬럼 하드코딩 (Popup)
| 파일 | 메서드 | 줄 | 컬럼명 | 필드 |
|---|---|---:|---|---|
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 144 | (ERP) EDI Sender | SENDER_NAME |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 145 | (ERP) Company | COMPANY_ID |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 146 | (ERP) Sold to | SOLDTO_CODE |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 147 | (ERP) Ship to | SHIPTO_CODE |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 150 | (GSCM) Sales Site | SCM_SITE_ID |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 151 | Active | VALID_YN |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 152 | (GSCM) Sold to / Ship to | GSCM_CODE |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 153 | Active | CODE_VALID_YN |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 155 | Message | Message |

## 5. 컨트롤 정의
| 파일 | 컨트롤명 | 타입 | 줄 |
|---|---|---|---:|
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | spdSummary | FarPoint.Win.Spread.FpSpread | 37 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | spdSummaryPJT | FarPoint.Win.Spread.FpSpread | 39 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | spdSummaryStatus | FarPoint.Win.Spread.FpSpread | 62 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | spdData | FarPoint.Win.Spread.FpSpread | 64 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | btnRefresh | DevExpress.XtraEditors.SimpleButton | 43 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | chkToday | GSCM.Windows.Forms.Controls.UsrCheckBox | 44 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | txtItemId | GSCM.Windows.Forms.Controls.UsrMultiLineEditor | 45 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | txtProject | GSCM.Windows.Forms.Controls.UsrMultiLineEditor | 46 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | btnProject | GSCM.Windows.Forms.Controls.UsrButton | 47 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | btnItemId | GSCM.Windows.Forms.Controls.UsrButton | 48 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | drpPeriod | GSCM.Windows.Forms.Controls.UsrDateRangePicker | 49 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | clbEDISender | GSCM.Windows.Forms.Controls.UsrCheckedList | 50 |

---

=== FILE: web_components.md ===
# DMF0052 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑
| AS-IS 컨트롤 | 타입 | → TO-BE 컴포넌트 | 비고 |
|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | SearchPanel (공통) | 조회조건 영역 |
| btnRefresh | SimpleButton | Button | Refresh 버튼 |
| chkToday | UsrCheckBox | Checkbox | 오늘 날짜 필터 |
| txtProject | UsrMultiLineEditor | MultiLineInput | 프로젝트 코드 멀티 입력 |
| txtItemId | UsrMultiLineEditor | MultiLineInput | Model 멀티 입력 |
| btnProject | UsrButton | Button + Popup | 프로젝트 선택 팝업 |
| btnItemId | UsrButton | Button + Popup | Model 선택 팝업 |
| drpPeriod | UsrDateRangePicker | DateRangePicker | 기간 조회 |
| clbEDISender | UsrCheckedList | CheckedComboBox | EDI Sender 멀티 선택 |
| spdSummary | FpSpread | Wijmo FlexGrid | SUMMARY 시트 |
| spdSummaryPJT | FpSpread | Wijmo FlexGrid | Summary Pjt 시트 |
| spdSummaryStatus | FpSpread | Wijmo FlexGrid | Summary Status 시트 |
| spdData | FpSpread (2시트) | Wijmo FlexGrid (Tab) | GSCM Data / ERP Data 시트 전환 |
| splitContainer1/2/3 | SplitContainer | SplitPanel (공통) | 화면 분할 레이아웃 |

## 2. 시트별 Grid 컬럼 (division=81 기준)
### 2.1 SUMMARY (메타 기반, 4컬럼)
| 컬럼명 | 필드 | 소스 | 표시 |
|---|---|---|---|
| 날짜 | YYYYMMDD | META | 기본 |
| Status | STATUS | META | 기본 |
| ERP전송 데이터 수 | SEND_CNT | META | 기본 |
| GSCM 수신한 데이터 수 | RCV_CNT | META | 기본 |

### 2.2 Summary Pjt (메타 기반, 8컬럼)
| 컬럼명 | 필드 | 소스 | 표시 |
|---|---|---|---|
| EDI Sender | SENDER_NAME | META | 기본 |
| EDI Sender Code | SENDER_CODE | META | 기본 |
| Project Code | PROJECT_CODE | META | 기본 |
| 수신한 데이터 수 | PROJECT_CNT | META | 기본 |
| 정상 | COMPLETED_CNT | META | 기본 |
| Master Data 정비 필요 건 수 (GSCM) | CHECK_GSCM_CNT | META | 기본 |
| ERP Data 확인 필요 | CHECK_ERP_CNT | META | 기본 |
| 최종 수신일 | CREATION_DATE | META | 기본 |

### 2.3 Summary Status (메타 기반, 4컬럼)
| 컬럼명 | 필드 | 소스 | 표시 |
|---|---|---|---|
| Status GSCM | STATUS_GSCM | META | 기본 |
| Status ERP | STATUS_ERP | META | 기본 |
| Qty | QTY | META | 기본 |
| % | AVG_PERCENT | META | 기본 |

### 2.4 GSCM Data (메타 기반, 10컬럼)
| 컬럼명 | 필드 | 소스 | 표시 |
|---|---|---|---|
| EDI Sender | SENDER_NAME | META | 기본 |
| EDI Sender Code | SENDER_CODE | META | 기본 |
| Project Code | PROJECT_CODE | META | 기본 |
| Model | ITEM_ID | META | 기본 |
| Nickname | NICK_NAME | META | 기본 |
| Sales Site 누락 | CHECK_SALES_SITE | META | 기본 |
| Sales Site Active | CHECK_SALES_ACTIVE | META | 기본 |
| SSPM 누락 | CHECK_SSPM | META | 기본 |
| SSPM Active | CHECK_SSPM_ACTIVE | META | 기본 |
| EDI Incoterms(SSPM) | CHECK_INCOTERMS | META | 기본 |

### 2.5 ERP Data (메타 기반, 10컬럼)
| 컬럼명 | 필드 | 소스 | 표시 |
|---|---|---|---|
| EDI Sender | SENDER_NAME | META | 기본 |
| Company | COMPANY_ID | META | 기본 |
| Sold to | SOLDTO_CODE | META | 기본 |
| Ship to | SHIPTO_CODE | META | 기본 |
| EDI_IF_SEQ | EDI_IF_SEQ | META | 기본 |
| Model | ITEM_ID | META | 기본 |
| Nickname | NICK_NAME | META | 기본 |
| Status | GSCM_STATUS | META | 기본 |
| (ERP) Status | ERP_STATUS | META | 기본 |
| Status Detail | STATUS_DETAIL | META | 기본 |

### 2.6 Site Popup (메타 기반, 9컬럼, **미사용 추정**)
| 컬럼명 | 필드 | 소스 | 표시 |
|---|---|---|---|
| EDI Sender | SENDER_NAME | META | 기본 |
| Company | COMPANY_ID | META | 기본 |
| Sold to | SOLDTO_CODE | META | 기본 |
| Ship to | SHIPTO_CODE | META | 기본 |
| (GSCM) Sales Site | SCM_SITE_ID | META | 기본 |
| Active | VALID_YN | META | 기본 |
| (GSCM) Sold to / Ship to | GSCM_CODE | META | 기본 |
| Active | CODE_VALID_YN | META | 기본 |
| MESSAGE | MESSAGE | META | 기본 |

### 2.7 EDI Summary GSCM DATA Popup (코드 전용, 9컬럼)
| 컬럼명 | 필드 | 소스 | 표시 | 조건 |
|---|---|---|---|---|
| (ERP) EDI Sender | SENDER_NAME | CODE | 항상 | - |
| (ERP) Company | COMPANY_ID | CODE | 항상 | - |
| (ERP) Sold to | SOLDTO_CODE | CODE | 항상 | - |
| (ERP) Ship to | SHIPTO_CODE | CODE | 항상 | - |
| (GSCM) Sales Site | SCM_SITE_ID | CODE | 조건부 | PopupType != "CHECK_SALES_SITE" |
| Active | VALID_YN | CODE | 조건부 | PopupType != "CHECK_SALES_SITE" |
| (GSCM) Sold to / Ship to | GSCM_CODE | CODE | 조건부 | PopupType != "CHECK_SALES_SITE" |
| Active | CODE_VALID_YN | CODE | 조건부 | PopupType != "CHECK_SALES_SITE" |
| Message | Message | CODE | 항상 | - |

## 3. 시트 연결 규칙
| 시트 | 연결 규칙 | 비고 |
|---|---|---|
| SUMMARY | META+코드연결 | CreateSpread:158 AddSheet, InitSpread:192 메타 컬럼 생성 |
| Summary Pjt | META+코드연결 | CreateSpread:162 AddSheet, InitSpread:192 메타 컬럼 생성 |
| Summary Status | META+코드연결 | CreateSpread:166 AddSheet, InitSpread:192 메타 컬럼 생성 |
| GSCM Data | META+코드연결 | CreateSpread:170 AddSheet, InitSpread:192 메타 컬럼 생성 |
| ERP Data | META+코드연결 | CreateSpread:171 AddSheet, InitSpread:192 메타 컬럼 생성 |
| Site Popup | 메타 정의만, 코드 미참조 | 메타에만 존재, 코드 어디서도 참조 안 함 (폐기 후보) |
| EDI Summary GSCM DATA Popup | 코드 하드코딩 전용 | 메타 없이 코드로만 구성 (06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs:144~155) |

## 4. Grid 이벤트 연결
| 이벤트 | AS-IS | TO-BE | 비고 |
|---|---|---|---|
| spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick | onCellDoubleClick | CHECK_GSCM_CNT / CHECK_ERP_CNT 클릭 시 spdData 시트 전환 |
| spdData.CellDoubleClick | spdData_CellDoubleClick | onCellDoubleClick | 팝업 호출 (조건 확인 필요) |
| spdData.ActiveSheetChanging | spdData_ActiveSheetChanging | onTabChange | GSCM Data ↔ ERP Data 시트 전환 |

## 5. Division별 표시 차이
현재 메타는 **division=81만** 정의되어 있음. 다른 division(40, 82, EE 등)에 대한 데이터 없음.

---

=== FILE: oracle_migration.md ===
# DMF0052 Oracle 전환 가이드

## 1. 호출 SP 인벤토리
| SP명 | 참조 테이블 (SP 내부) | EXEC 체인 | 비고 |
|---|---|---|---|
| DMF0052_GET_SUMMARY_DATA | XIF_ERP_EDI_CALLOFF_ITEM_R_SN | - | ERP 인터페이스 뷰 |
| DMF0052_GET_PJT_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SCM_MST_ITEM_SN | #T_GSCM_DATA, #T_ERP_DATA (임시 테이블) | FN_GET_ITEM_NICKNAME, STRING_SPLIT 함수 사용 |
| DMF0052_GET_STATUS_DATA | DM_DNM_EDI_CALLOFF_ITEM | - | STRING_SPLIT 함수 사용 |
| DMF0052_GET_DETAIL_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SCM_MST_ITEM_SN | #T_EDI (임시 테이블) | FN_GET_ITEM_NICKNAME, STRING_SPLIT 함수 사용 |
| DMF0052_GET_ERP_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_MST_ITEM_SN | #T_EDI (임시 테이블) | FN_GET_ITEM_NICKNAME, STRING_SPLIT 함수 사용 |
| DMF0052_GET_SPREAD_TITLE | SCM_MST_TITLESET_USER, SCM_MST_SHEET_COLUMNS | - | STRING_SPLIT 함수 사용 (메타 조회) |
| UP_FX_GETCOMMONDATALIST_DM | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE_ITEM, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_ITEM_M_SN, SCM_MST_SITE_ITEM_PRIORITY, SCM_MST_ITEM_SN, SCM_LINE_HIERARCHY_V_SN, DM_MST_BUCKET_CONVERSION, SCM_MST_PLANT_SN | DYNAMIC@UP_FX_GETCOMMONDATALIST_DM | 동적 SQL 포함, STRING_SPLIT 함수 사용 |

## 2. 공통코드 분기
| 코드 종류 | 테이블 | 메서드 | 비고 |
|---|---|---|---|
| EDI Sender | SCM_ADM_LOOKUP_MASTER_DETAIL | GetEdiSender:783 | UP_FX_GETCOMMONDATALIST_DM 호출 |
| - | - | GetCheckedListValue | InitControls:144, FindData_Main:278, FindData_Pjt:344, FindData_Status:407 (CODE 컬럼 읽음) |

## 3. FoxQuery 미등록/직접호출 SP
**없음** — 모든 엔드포인트가 FoxQuery 등록(DM.* 형식) 상태

## 4. Oracle 전환 시 확인 포인트
### 4.1 MSSQL → Oracle 전환 항목
| 항목 | MSSQL 구문 | Oracle 대응 | 비고 |
|---|---|---|---|
| 임시 테이블 | #T_GSCM_DATA, #T_ERP_DATA, #T_EDI | GTT (Global Temporary Table) | DMF0052_GET_PJT_DATA, DMF0052_GET_DETAIL_DATA, DMF0052_GET_ERP_DATA 에서 사용 |
| STRING_SPLIT | STRING_SPLIT(@param, ',') | REGEXP_SUBSTR + CONNECT BY 또는 TABLE() | 6개 SP에서 사용 (멀티 값 파싱) |
| 함수 | FN_GET_ITEM_NICKNAME | 동일 함수 Oracle 버전 확인 | 4개 SP에서 사용 |
| 동적 SQL | DYNAMIC@UP_FX_GETCOMMONDATALIST_DM | EXECUTE IMMEDIATE | UP_FX_GETCOMMONDATALIST_DM 내부 |

### 4.2 난이도 평가 (사실 기반)
- **임시 테이블 3개**: #T_GSCM_DATA, #T_ERP_DATA, #T_EDI → GTT 전환 필요
- **STRING_SPLIT 6회 사용**: 공통 함수로 패턴화 필요
- **FN_GET_ITEM_NICKNAME 함수**: Oracle 버전 존재 여부 확인 필요
- **동적 SQL**: UP_FX_GETCOMMONDATALIST_DM 내부 동적 쿼리 → Oracle EXECUTE IMMEDIATE 전환

### 4.3 인터페이스 뷰
- **XIF_ERP_EDI_CALLOFF_ITEM_R_SN**: ERP → GSCM 인터페이스 뷰 (DMF0052_GET_SUMMARY_DATA에서 사용)
- 뷰 정의 Oracle 버전 확인 필요

### 4.4 SP별 변환 우선순위 (참조 복잡도 기준)
1. DMF0052_GET_SPREAD_TITLE (메타 조회만, 의존 최소)
2. DMF0052_GET_SUMMARY_DATA (뷰 조회만)
3. DMF0052_GET_STATUS_DATA (단일 테이블 + STRING_SPLIT)
4. DMF0052_GET_ERP_DATA (임시 테이블 1개)
5. DMF0052_GET_DETAIL_DATA (임시 테이블 1개 + 다중 테이블 조인)
6. DMF0052_GET_PJT_DATA (임시 테이블 2개 + 다중 테이블 조인)
7. UP_FX_GETCOMMONDATALIST_DM (동적 SQL + 다중 테이블 조인)

---

=== FILE: tobe_design.md ===
# DMF0052 TO-BE 설계 가이드

## 1. 조회조건 (SearchPanel)
| 항목 | AS-IS 컨트롤 | 타입 | TO-BE 컴포넌트 | 기본값 | 필수 |
|---|---|---|---|---|---|
| 기간 | drpPeriod | UsrDateRangePicker | DateRangePicker | - | 선택 |
| 오늘 날짜 | chkToday | UsrCheckBox | Checkbox | unchecked | 선택 |
| EDI Sender | clbEDISender | UsrCheckedList | CheckedComboBox | - | 선택 |
| 프로젝트 코드 | txtProject + btnProject | UsrMultiLineEditor + UsrButton | MultiLineInput + Popup | - | 선택 |
| Model | txtItemId + btnItemId | UsrMultiLineEditor + UsrButton | MultiLineInput + Popup | - | 선택 |

## 2. 액션별 호출 API 후보
| 액션 | AS-IS 버튼/이벤트 | 호출 SP | TO-BE API 후보 | Method |
|---|---|---|---|---|
| 조회 | FindButton | DMF0052_GET_SUMMARY_DATA, DMF0052_GET_PJT_DATA, DMF0052_GET_STATUS_DATA | /api/dm/dmf0052/summary | GET |
| Refresh (GSCM Data) | btnRefresh | DMF0052_GET_DETAIL_DATA | /api/dm/dmf0052/gscm-data | GET |
| Summary Pjt 더블클릭 (GSCM) | spdPjt_CellDoubleClick | DMF0052_GET_DETAIL_DATA | /api/dm/dmf0052/gscm-data | GET |
| Summary Pjt 더블클릭 (ERP) | spdPjt_CellDoubleClick | DMF0052_GET_ERP_DATA | /api/dm/dmf0052/erp-data | GET |
| Grid 타이틀 조회 | GetSpdTitle | DMF0052_GET_SPREAD_TITLE | /api/common/titleset | GET |
| EDI Sender 콤보 | GetEdiSender | UP_FX_GETCOMMONDATALIST_DM | /api/common/combo/edi-sender | GET |
| 화면 로드 | Form_Load | DMF0052_GET_SITE_POPUP (내부 호출) | /api/dm/dmf0052/site-popup | GET |

## 3. Division별 Grid 변형 요약
현재 메타는 **division=81만** 정의. TO-BE에서 다른 division 지원 필요 시 메타 추가 필요.

| 시트 | 81 컬럼 수 | 40, 82, EE 등 | 비고 |
|---|---:|---|---|
| SUMMARY | 4 | 미정의 | 메타 추가 필요 |
| Summary Pjt | 8 | 미정의 | 메타 추가 필요 |
| Summary Status | 4 | 미정의 | 메타 추가 필요 |
| GSCM Data | 10 | 미정의 | 메타 추가 필요 |
| ERP Data | 10 | 미정의 | 메타 추가 필요 |

## 4. 권한 (C/R/U/D) 관련 사실
**현재 Fact Pack에 권한 관련 직접 증거 없음**. 아래는 일반 패턴 추정:
- **R (조회)**: FindButton, btnRefresh → 모든 사용자 (기본 권한)
- **C/U/D**: 현재 코드에 저장/수정/삭제 로직 없음 (조회 전용 화면으로 추정)

확인 필요:
- TB_FX_GroupMenuAuth 메타 데이터(4행) 확인 → 실제 권한 설정 확인 필요

## 5. 미확정 사항
### 5.1 Popup 호출 조건
- **DMF0052_GSCMDataPopup**: PopupType 파라미터에 따라 컬럼 표시 변경
  - PopupType != "CHECK_SALES_SITE" → 4개 컬럼 추가 표시
  - 호출 지점: spdData_CellDoubleClick (조건 확인 필요)

### 5.2 Site Popup 시트 사용 여부
- 메타에 정의되어 있으나 코드에서 참조 없음
- DMF0052_GET_SITE_POPUP SP는 Form_Load:211 에서 호출됨
- 실제 화면 표시 여부 런타임 확인 필요

### 5.3 spdData 시트 전환 로직
- GSCM Data / ERP Data 2개 시트를 spdData 하나에 담음
- Summary Pjt 더블클릭 시 CHECK_GSCM_CNT / CHECK_ERP_CNT 값에 따라 시트 전환 (spdPjt_CellDoubleClick:596~612)
- TO-BE에서 Tab 또는 조건부 표시로 구현

### 5.4 chkToday 이벤트 핸들러
- chkToday_CheckedChanged 등록되어 있으나 메서드 본문 확인 필요 (Fact Pack에 본문 내용 없음)

### 5.5 Division 확장
- 현재 메타가 81만 정의
- 다른 division 지원 필요 시 메타 추가 작업 필요
