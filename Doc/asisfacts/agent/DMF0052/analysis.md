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
