# DMF0052 EDI Summary 화면설계서

## 1. 화면 개요
- **화면 ID**: DMF0052
- **화면명**: EDI Summary
- **메뉴 위치**: 확인 필요 (TB_FX_MenuItemInfo 메타 1행 존재하나 상세 미제공)
- **주요 기능**: ERP EDI 데이터 수신 현황 요약 및 GSCM/ERP 데이터 검증

## 2. 화면 레이아웃
### 2.1 영역 구성
```
┌─────────────────────────────────────────────────────┐
│ [조회조건 영역] usrConditionPanel1                   │
│  - Period, chkToday, EDI Sender, Project, Model     │
│  - btnRefresh                                       │
├─────────────────────────────────────────────────────┤
│ [상단 좌측] spdSummary (SUMMARY 시트)                │
├─────────────────────────────────────────────────────┤
│ [상단 우측] spdSummaryPJT (Summary Pjt 시트)         │
├─────────────────────────────────────────────────────┤
│ [하단 좌측] spdSummaryStatus (Summary Status 시트)   │
├─────────────────────────────────────────────────────┤
│ [하단 우측] spdData (GSCM Data/ERP Data 2시트 전환)  │
└─────────────────────────────────────────────────────┘
```
- 레이아웃: SplitContainer 3단 (splitContainer1 > splitContainer2/splitContainer3)
- splitContainer1.Panel1: 조회조건 영역
- splitContainer1.Panel2 > splitContainer2.Panel1: spdSummary
- splitContainer1.Panel2 > splitContainer2.Panel2: spdSummaryPJT
- splitContainer1.Panel2 > splitContainer3.Panel1: spdSummaryStatus
- splitContainer1.Panel2 > splitContainer3.Panel2: spdData

### 2.2 팝업
- **DMF0052_GSCMDataPopup**: "EDI Summary GSCM DATA Popup" 시트 (하드코딩 9컬럼, PopupType 파라미터로 4개 컬럼 표시 분기)

## 3. 컨트롤 명세
| 컨트롤명 | 타입 | 라벨/설명 | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | 조회조건 영역 | - | - | - | SearchPanel |
| usrLayoutControl1 | UsrLayoutControl | 조회조건 레이아웃 | - | - | - | LayoutControl |
| drpPeriod | UsrDateRangePicker | Period | - | 선택 | - | DateRangePicker |
| chkToday | UsrCheckBox | 오늘 날짜 | unchecked | 선택 | chkToday_CheckedChanged | Checkbox |
| clbEDISender | UsrCheckedList | EDI Sender | - | 선택 | - | CheckedComboBox |
| txtProject | UsrMultiLineEditor | Project Code | - | 선택 | - | MultiLineInput |
| btnProject | UsrButton | Project 선택 팝업 | - | - | btnProject_Click | Button + Popup |
| txtItemId | UsrMultiLineEditor | Model | - | 선택 | - | MultiLineInput |
| btnItemId | UsrButton | Model 선택 팝업 | - | - | btnItemId_Click | Button + Popup |
| btnRefresh | SimpleButton | Refresh | - | - | BtnRefresh_Click | Button |
| spdSummary | FpSpread | SUMMARY 시트 그리드 | - | - | - | Wijmo FlexGrid |
| spdSummary_Sheet1 | SheetView | SUMMARY 시트뷰 | - | - | - | - |
| spdSummaryPJT | FpSpread | Summary Pjt 시트 그리드 | - | - | spdPjt_CellDoubleClick | Wijmo FlexGrid |
| spdSummaryPJT_Sheet1 | SheetView | Summary Pjt 시트뷰 | - | - | - | - |
| spdSummaryStatus | FpSpread | Summary Status 시트 그리드 | - | - | - | Wijmo FlexGrid |
| spdSummaryStatus_Sheet1 | SheetView | Summary Status 시트뷰 | - | - | - | - |
| spdData | FpSpread | GSCM Data/ERP Data 시트 그리드 | - | - | spdData_ActiveSheetChanging, spdData_CellDoubleClick | Wijmo FlexGrid (Tab) |
| spdData_Sheet1 | SheetView | spdData 시트뷰 | - | - | - | - |

## 4. 그리드 명세
### 4.1 SUMMARY 시트 (division=81, 메타 기반 4컬럼)
| 컬럼명 | 헤더 | 타입 | 필드 | 출처 | division별 표시 | 편집 가능 |
|---|---|---|---|---|---|---|
| YYYYMMDD | 날짜 | Text | YYYYMMDD | META | 81:기본 | N |
| STATUS | Status | Text | STATUS | META | 81:기본 | N |
| SEND_CNT | ERP전송 데이터 수 | Text | SEND_CNT | META | 81:기본 | N |
| RCV_CNT | GSCM 수신한 데이터 수 | Text | RCV_CNT | META | 81:기본 | N |

### 4.2 Summary Pjt 시트 (division=81, 메타 기반 8컬럼)
| 컬럼명 | 헤더 | 타입 | 필드 | 출처 | division별 표시 | 편집 가능 |
|---|---|---|---|---|---|---|
| SENDER_NAME | EDI Sender | Text | SENDER_NAME | META | 81:기본 | N |
| SENDER_CODE | EDI Sender Code | Text | SENDER_CODE | META | 81:기본 | N |
| PROJECT_CODE | Project Code | Text | PROJECT_CODE | META | 81:기본 | N |
| PROJECT_CNT | 수신한 데이터 수 | Text | PROJECT_CNT | META | 81:기본 | N |
| COMPLETED_CNT | 정상 | Text | COMPLETED_CNT | META | 81:기본 | N |
| CHECK_GSCM_CNT | Master Data 정비 필요 건 수 (GSCM) | Text | CHECK_GSCM_CNT | META | 81:기본 | N |
| CHECK_ERP_CNT | ERP Data 확인 필요 | Text | CHECK_ERP_CNT | META | 81:기본 | N |
| CREATION_DATE | 최종 수신일 | Text | CREATION_DATE | META | 81:기본 | N |

### 4.3 Summary Status 시트 (division=81, 메타 기반 4컬럼)
| 컬럼명 | 헤더 | 타입 | 필드 | 출처 | division별 표시 | 편집 가능 |
|---|---|---|---|---|---|---|
| STATUS_GSCM | Status GSCM | Text | STATUS_GSCM | META | 81:기본 | N |
| STATUS_ERP | Status ERP | Text | STATUS_ERP | META | 81:기본 | N |
| QTY | Qty | Text | QTY | META | 81:기본 | N |
| AVG_PERCENT | % | Text | AVG_PERCENT | META | 81:기본 | N |

### 4.4 GSCM Data 시트 (division=81, 메타 기반 10컬럼)
| 컬럼명 | 헤더 | 타입 | 필드 | 출처 | division별 표시 | 편집 가능 |
|---|---|---|---|---|---|---|
| SENDER_NAME | EDI Sender | Text | SENDER_NAME | META | 81:기본 | N |
| SENDER_CODE | EDI Sender Code | Text | SENDER_CODE | META | 81:기본 | N |
| PROJECT_CODE | Project Code | Text | PROJECT_CODE | META | 81:기본 | N |
| ITEM_ID | Model | Text | ITEM_ID | META | 81:기본 | N |
| NICK_NAME | Nickname | Text | NICK_NAME | META | 81:기본 | N |
| CHECK_SALES_SITE | Sales Site 누락 | Text | CHECK_SALES_SITE | META | 81:기본 | N |
| CHECK_SALES_ACTIVE | Sales Site Active | Text | CHECK_SALES_ACTIVE | META | 81:기본 | N |
| CHECK_SSPM | SSPM 누락 | Text | CHECK_SSPM | META | 81:기본 | N |
| CHECK_SSPM_ACTIVE | SSPM Active | Text | CHECK_SSPM_ACTIVE | META | 81:기본 | N |
| CHECK_INCOTERMS | EDI Incoterms(SSPM) | Text | CHECK_INCOTERMS | META | 81:기본 | N |

### 4.5 ERP Data 시트 (division=81, 메타 기반 10컬럼)
| 컬럼명 | 헤더 | 타입 | 필드 | 출처 | division별 표시 | 편집 가능 |
|---|---|---|---|---|---|---|
| SENDER_NAME | EDI Sender | Text | SENDER_NAME | META | 81:기본 | N |
| COMPANY_ID | Company | Text | COMPANY_ID | META | 81:기본 | N |
| SOLDTO_CODE | Sold to | Text | SOLDTO_CODE | META | 81:기본 | N |
| SHIPTO_CODE | Ship to | Text | SHIPTO_CODE | META | 81:기본 | N |
| EDI_IF_SEQ | EDI_IF_SEQ | Text | EDI_IF_SEQ | META | 81:기본 | N |
| ITEM_ID | Model | Text | ITEM_ID | META | 81:기본 | N |
| NICK_NAME | Nickname | Text | NICK_NAME | META | 81:기본 | N |
| GSCM_STATUS | Status | Text | GSCM_STATUS | META | 81:기본 | N |
| ERP_STATUS | (ERP) Status | Text | ERP_STATUS | META | 81:기본 | N |
| STATUS_DETAIL | Status Detail | Text | STATUS_DETAIL | META | 81:기본 | N |

### 4.6 Site Popup 시트 (division=81, 메타 기반 9컬럼, **미사용 추정**)
| 컬럼명 | 헤더 | 타입 | 필드 | 출처 | division별 표시 | 편집 가능 |
|---|---|---|---|---|---|---|
| SENDER_NAME | EDI Sender | Text | SENDER_NAME | META | 81:기본 | N |
| COMPANY_ID | Company | Text | COMPANY_ID | META | 81:기본 | N |
| SOLDTO_CODE | Sold to | Text | SOLDTO_CODE | META | 81:기본 | N |
| SHIPTO_CODE | Ship to | Text | SHIPTO_CODE | META | 81:기본 | N |
| SCM_SITE_ID | (GSCM) Sales Site | Text | SCM_SITE_ID | META | 81:기본 | N |
| VALID_YN | Active | Text | VALID_YN | META | 81:기본 | N |
| GSCM_CODE | (GSCM) Sold to / Ship to | Text | GSCM_CODE | META | 81:기본 | N |
| CODE_VALID_YN | Active | Text | CODE_VALID_YN | META | 81:기본 | N |
| MESSAGE | MESSAGE | Text | MESSAGE | META | 81:기본 | N |

### 4.7 EDI Summary GSCM DATA Popup 시트 (코드 하드코딩, 9컬럼)
| 컬럼명 | 헤더 | 타입 | 필드 | 출처 | 표시 조건 | 편집 가능 |
|---|---|---|---|---|---|---|
| SENDER_NAME | (ERP) EDI Sender | Text | SENDER_NAME | CODE | 항상 | N |
| COMPANY_ID | (ERP) Company | Text | COMPANY_ID | CODE | 항상 | N |
| SOLDTO_CODE | (ERP) Sold to | Text | SOLDTO_CODE | CODE | 항상 | N |
| SHIPTO_CODE | (ERP) Ship to | Text | SHIPTO_CODE | CODE | 항상 | N |
| SCM_SITE_ID | (GSCM) Sales Site | Text | SCM_SITE_ID | CODE | PopupType != "CHECK_SALES_SITE" | N |
| VALID_YN | Active | Text | VALID_YN | CODE | PopupType != "CHECK_SALES_SITE" | N |
| GSCM_CODE | (GSCM) Sold to / Ship to | Text | GSCM_CODE | CODE | PopupType != "CHECK_SALES_SITE" | N |
| CODE_VALID_YN | Active | Text | CODE_VALID_YN | CODE | PopupType != "CHECK_SALES_SITE" | N |
| Message | Message | Text | Message | CODE | 항상 | N |

## 5. 액션 명세
| 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|
| FindButton | FindButton | 조회 | DM.DMF0052_GET_SUMMARY_DATA, DM.DMF0052_GET_PJT_DATA, DM.DMF0052_GET_STATUS_DATA | spdSummary/spdSummaryPJT/spdSummaryStatus 시트 데이터 바인딩 |
| btnRefresh | BtnRefresh_Click | GSCM Data 갱신 | DM.DMF0052_GET_DETAIL_DATA | spdData "GSCM Data" 시트 갱신 |
| spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick | CHECK_GSCM_CNT/CHECK_ERP_CNT 컬럼 더블클릭 | DM.DMF0052_GET_DETAIL_DATA (GSCM), DM.DMF0052_GET_ERP_DATA (ERP) | spdData 시트 전환 + 데이터 표시 |
| spdData.ActiveSheetChanging | spdData_ActiveSheetChanging | GSCM Data ↔ ERP Data 시트 전환 | - | 시트 전환 로직 (초기화 추정) |
| spdData.CellDoubleClick | spdData_CellDoubleClick | 셀 더블클릭 | 확인 필요 | 팝업 호출 추정 (Fact Pack에 본문 없음) |
| this.Load | Form_Load | 화면 초기화 | DM.DMF0052_GET_SPREAD_TITLE, DM.UP_FX_GetCommonDataList_DM | 시트 컬럼 메타 로드, EDI Sender 콤보 바인딩 |
| chkToday.CheckedChanged | chkToday_CheckedChanged | 오늘 날짜 체크박스 | - | drpPeriod 오늘 날짜로 설정 추정 (본문 확인 필요) |
| btnProject.Click | btnProject_Click | 프로젝트 선택 팝업 | 확인 필요 | txtProject에 선택값 반영 추정 |
| btnItemId.Click | btnItemId_Click | Model 선택 팝업 | 확인 필요 | txtItemId에 선택값 반영 추정 |

## 6. 검증 및 메시지
Fact Pack에 검증 로직 없음. 아래는 추정:
- 조회 조건 필수 검증: 없음 (모두 선택 사항)
- GSCM Data 시트: CHECK_SALES_SITE/CHECK_SALES_ACTIVE/CHECK_SSPM/CHECK_SSPM_ACTIVE/CHECK_INCOTERMS 컬럼에 검증 결과 표시 (Y/N 추정)
- 메시지: SP 내부 처리 추정 (확인 필요)

## 7. 권한 (C/R/U/D)
- **R (조회)**: 모든 사용자 (FindButton, btnRefresh)
- **C/U/D**: 본 화면에 저장/수정/삭제 기능 없음 (조회 전용)
- 권한 메타: TB_FX_GroupMenuAuth 4행 존재하나 상세 미제공 (확인 필요)

## 8. To-Be 전환 메모
### 8.1 Grid 구성 방식
- **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)**
- SUMMARY/Summary Pjt/Summary Status/GSCM Data/ERP Data: 메타(SCM_MST_SHEET_COLUMNS) 기반, 코드에서 CreateSheetHeaderColumn 호출
- EDI Summary GSCM DATA Popup: 코드 하드코딩 전용 (메타 없음)
- Site Popup: 메타 정의만 존재, 코드 미참조 (폐기 후보)

### 8.2 spdData 시트 전환
- AS-IS: spdData 하나에 GSCM Data/ERP Data 2개 시트 담음 (ActiveSheetChanging 이벤트로 전환)
- TO-BE: Wijmo FlexGrid Tab 또는 조건부 표시로 구현

### 8.3 Division 지원
- 현재 메타는 division=81만 정의
- TO-BE에서 다른 division(40, 82, EE 등) 지원 필요 시 메타 추가 작업 필요

### 8.4 Oracle 전환
- UsrDateRangePicker, UsrCheckedList, UsrMultiLineEditor 등 커스텀 컨트롤 → 공통 컴포넌트 매핑
- FpSpread → Wijmo FlexGrid
- SP 파라미터 STRING_SPLIT 함수 사용 → Oracle REGEXP_SUBSTR 또는 임시테이블 전환

## 9. 미확정
1. **chkToday_CheckedChanged 핸들러 본문**: 이벤트는 등록되어 있으나 Fact Pack에 본문 없음
2. **spdData_CellDoubleClick 핸들러 본문**: 팝업 호출 추정 (DMF0052_GSCMDataPopup)하나 본문 없음
3. **btnProject_Click, btnItemId_Click 핸들러 본문**: 팝업 호출 추정하나 본문 없음
4. **Site Popup 시트 사용 여부**: 메타에 정의되어 있으나 코드에서 참조 없음. DMF0052_GET_SITE_POPUP SP는 Form_Load:211에서 호출되나 화면 표시 확인 필요
5. **PopupType 파라미터**: DMF0052_GSCMDataPopup의 PopupType 값에 따라 4개 컬럼 표시 분기. 호출 지점 및 값 확인 필요

---
