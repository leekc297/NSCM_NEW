Fact Pack을 분석하여 3개 산출물을 작성합니다.

=== FILE: business_analysis.md ===
# DMF0052 EDI Summary 업무분석서

## 1. 업무 목적 및 범위
### 1.1 목적
ERP에서 전송한 EDI(Electronic Data Interchange) Call-off 데이터의 수신 현황을 요약하고, GSCM과 ERP 데이터 간 불일치를 검증하여 Master Data 정비가 필요한 항목을 식별합니다.

### 1.2 범위
- ERP → GSCM EDI 데이터 수신 현황 조회 (날짜별/프로젝트별/상태별)
- GSCM Master Data 검증 (Sales Site, SSPM, Incoterms 누락/비활성 체크)
- ERP 데이터 상세 조회 및 상태 확인
- 조회 전용 화면 (저장/수정/삭제 기능 없음)

## 2. 사용자 시나리오
### 시나리오 1: 전체 EDI 수신 현황 조회
**행위**: 사용자가 기간/EDI Sender/프로젝트/Model 조건을 선택하고 조회 버튼 클릭  
**시스템 처리**:  
- `DM.DMF0052_GET_SUMMARY_DATA` → `DMF0052_GET_SUMMARY_DATA` SP 호출하여 날짜별 ERP 전송 건수/GSCM 수신 건수 조회 (원천: `XIF_ERP_EDI_CALLOFF_ITEM_R_SN`)
- `DM.DMF0052_GET_PJT_DATA` → `DMF0052_GET_PJT_DATA` SP 호출하여 프로젝트별 정상/검증 필요 건수 집계 (원천: `DM_DNM_EDI_CALLOFF_ITEM`, 임시테이블 `#T_GSCM_DATA`, `#T_ERP_DATA`)
- `DM.DMF0052_GET_STATUS_DATA` → `DMF0052_GET_STATUS_DATA` SP 호출하여 상태별 통계 조회 (원천: `DM_DNM_EDI_CALLOFF_ITEM`)  
**결과**: SUMMARY 시트(날짜별 4컬럼), Summary Pjt 시트(프로젝트별 8컬럼), Summary Status 시트(상태별 4컬럼)에 데이터 표시

### 시나리오 2: GSCM Master Data 검증 상세 조회
**행위**: Summary Pjt 시트에서 "Master Data 정비 필요 건 수 (GSCM)" 컬럼 더블클릭  
**시스템 처리**:  
- `DM.DMF0052_GET_DETAIL_DATA` → `DMF0052_GET_DETAIL_DATA` SP 호출 (원천: `DM_DNM_EDI_CALLOFF_ITEM`, `SCM_MST_SITE_ITEM`, `SCM_MST_ITEM_SN`, 임시테이블 `#T_EDI`)
- spdData 시트를 "GSCM Data"로 전환  
**결과**: GSCM Data 시트(10컬럼)에 Sales Site 누락/Active, SSPM 누락/Active, EDI Incoterms 검증 결과 표시

### 시나리오 3: ERP Data 상세 조회
**행위**: Summary Pjt 시트에서 "ERP Data 확인 필요" 컬럼 더블클릭  
**시스템 처리**:  
- `DM.DMF0052_GET_ERP_DATA` → `DMF0052_GET_ERP_DATA` SP 호출 (원천: `DM_DNM_EDI_CALLOFF_ITEM`, `SCM_MST_ITEM_SN`, 임시테이블 `#T_EDI`)
- spdData 시트를 "ERP Data"로 전환  
**결과**: ERP Data 시트(10컬럼)에 Company/Sold to/Ship to/EDI_IF_SEQ/Status Detail 표시

### 시나리오 4: Refresh (GSCM Data 갱신)
**행위**: GSCM Data 시트 표시 중 btnRefresh 버튼 클릭  
**시스템 처리**: 시나리오 2와 동일 (`DM.DMF0052_GET_DETAIL_DATA` 재호출)  
**결과**: GSCM Data 최신 상태로 갱신

### 시나리오 5: 화면 초기 로드
**행위**: 화면 진입 (Form_Load 이벤트)  
**시스템 처리**:  
- `DM.DMF0052_GET_SPREAD_TITLE` → `DMF0052_GET_SPREAD_TITLE` SP 호출하여 시트별 컬럼 메타 조회 (원천: `SCM_MST_TITLESET_USER`, `SCM_MST_SHEET_COLUMNS`)
- `DM.UP_FX_GetCommonDataList_DM` → `UP_FX_GETCOMMONDATALIST_DM` SP 호출하여 EDI Sender 콤보 데이터 조회 (원천: `SCM_ADM_LOOKUP_MASTER_DETAIL` 등 복수 테이블)  
**결과**: 조회조건 컨트롤 초기화, 빈 그리드 표시

## 3. 업무 흐름도
```
1. [화면 진입] Form_Load
   → DMF0052_GET_SPREAD_TITLE (시트 컬럼 메타)
   → UP_FX_GETCOMMONDATALIST_DM (EDI Sender 콤보)
   → 조회조건 초기화

2. [조회 버튼 클릭] FindButton
   → DMF0052_GET_SUMMARY_DATA (SUMMARY 시트)
   → DMF0052_GET_PJT_DATA (Summary Pjt 시트)
   → DMF0052_GET_STATUS_DATA (Summary Status 시트)
   → 3개 시트 데이터 표시

3. [Summary Pjt 더블클릭] spdPjt_CellDoubleClick
   → 클릭 컬럼 = "CHECK_GSCM_CNT" && 값 != "0"
     → DMF0052_GET_DETAIL_DATA (GSCM Data)
     → spdData 시트 "GSCM Data"로 전환
   → 클릭 컬럼 = "CHECK_ERP_CNT" && 값 != "0"
     → DMF0052_GET_ERP_DATA (ERP Data)
     → spdData 시트 "ERP Data"로 전환

4. [Refresh 버튼 클릭] BtnRefresh_Click
   → 현재 spdData 활성 시트 = "GSCM Data"
     → DMF0052_GET_DETAIL_DATA 재호출

5. [spdData 시트 전환] spdData_ActiveSheetChanging
   → GSCM Data ↔ ERP Data 수동 전환 (각 시트 초기화 로직 실행 가능)

6. [spdData 더블클릭] spdData_CellDoubleClick
   → 팝업 호출 (조건 확인 필요 - Fact Pack에 본문 없음)
```

## 4. 업무 규칙
### 4.1 SP 분기 조건
| SP | 분기 조건 | 처리 |
|---|---|---|
| DMF0052_GET_PJT_DATA | Fact Pack에 코드 본문 없음 | 임시테이블 #T_GSCM_DATA, #T_ERP_DATA 생성/조인하여 프로젝트별 집계 (확인 필요) |
| DMF0052_GET_DETAIL_DATA | Fact Pack에 코드 본문 없음 | 임시테이블 #T_EDI 생성, DM_DNM_EDI_CALLOFF_ITEM 조인하여 Sales Site/SSPM 검증 (확인 필요) |
| DMF0052_GET_ERP_DATA | Fact Pack에 코드 본문 없음 | 임시테이블 #T_EDI 생성, DM_DNM_EDI_CALLOFF_ITEM 조인하여 ERP 상태 조회 (확인 필요) |
| DMF0052_GET_STATUS_DATA | Fact Pack에 코드 본문 없음 | DM_DNM_EDI_CALLOFF_ITEM에서 상태별 집계 (확인 필요) |

### 4.2 필수값
- 조회 조건: 모두 선택 사항 (기간/EDI Sender/프로젝트/Model 빈값 가능, 빈값 시 전체 조회 추정)
- chkToday 체크박스: 체크 시 오늘 날짜로 기간 필터 (chkToday_CheckedChanged 핸들러 본문 확인 필요)

### 4.3 검증 규칙
Fact Pack에 SP 본문/검증 로직 없음. 아래는 컬럼명 기반 추정:
- GSCM Data 시트: CHECK_SALES_SITE (Sales Site 누락 여부), CHECK_SALES_ACTIVE (Sales Site Active 여부), CHECK_SSPM (SSPM 누락 여부), CHECK_SSPM_ACTIVE (SSPM Active 여부), CHECK_INCOTERMS (EDI Incoterms 검증)
- 검증 로직 상세는 SP 원문 확인 필요

### 4.4 날짜/버킷 규칙
- drpPeriod (UsrDateRangePicker): 조회 기간 범위 선택
- chkToday: 체크 시 drpPeriod를 오늘 날짜로 설정 (추정)
- 버킷 규칙: 본 화면에 버킷 관련 컬럼 없음

## 5. 데이터 흐름 표
| 엔드포인트 | SP | 읽기 테이블 | 쓰기 테이블 | 비고 |
|---|---|---|---|---|
| DM.DMF0052_GET_SUMMARY_DATA | DMF0052_GET_SUMMARY_DATA | XIF_ERP_EDI_CALLOFF_ITEM_R_SN | - | 날짜별 ERP 전송/GSCM 수신 건수 |
| DM.DMF0052_GET_PJT_DATA | DMF0052_GET_PJT_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SCM_MST_ITEM_SN | #T_GSCM_DATA, #T_ERP_DATA (임시) | 프로젝트별 검증 현황 |
| DM.DMF0052_GET_STATUS_DATA | DMF0052_GET_STATUS_DATA | DM_DNM_EDI_CALLOFF_ITEM | - | 상태별 통계 |
| DM.DMF0052_GET_DETAIL_DATA | DMF0052_GET_DETAIL_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SCM_MST_ITEM_SN | #T_EDI (임시) | GSCM Master Data 검증 상세 |
| DM.DMF0052_GET_ERP_DATA | DMF0052_GET_ERP_DATA | DM_DNM_EDI_CALLOFF_ITEM, SCM_MST_ITEM_SN | #T_EDI (임시) | ERP 데이터 상세 |
| DM.DMF0052_GET_SPREAD_TITLE | DMF0052_GET_SPREAD_TITLE | SCM_MST_TITLESET_USER, SCM_MST_SHEET_COLUMNS | - | 시트 컬럼 메타 |
| DM.UP_FX_GetCommonDataList_DM | UP_FX_GETCOMMONDATALIST_DM | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE_ITEM, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_ITEM_M_SN, SCM_MST_SITE_ITEM_PRIORITY, SCM_MST_ITEM_SN, SCM_LINE_HIERARCHY_V_SN, DM_MST_BUCKET_CONVERSION, SCM_MST_PLANT_SN | - | 공통 콤보 데이터 (EDI Sender 등) |

## 6. Division별 변형
현재 메타는 **division=81만** 정의되어 있습니다.
- 모든 시트(SUMMARY, Summary Pjt, Summary Status, GSCM Data, ERP Data, Site Popup)가 division=81 고정
- 다른 division(40, 82, EE 등)에 대한 메타 데이터 없음
- Division별 컬럼 표시 차이: 현재 확인 불가 (81만 존재)
- TO-BE에서 다른 division 지원 필요 시 메타 추가 작업 필요

## 7. 외부 인터페이스
- **ERP EDI 데이터 수신**: `XIF_ERP_EDI_CALLOFF_ITEM_R_SN` (뷰 또는 인터페이스 테이블, _R_SN 접미사로 추정)에서 ERP 전송 데이터 조회
- **GSCM 내부 테이블**: `DM_DNM_EDI_CALLOFF_ITEM`에 수신된 EDI 데이터 저장 (추정)
- 인터페이스 주기/방식: Fact Pack에 정보 없음 (확인 필요)

## 8. 미확정 및 확인 필요
1. **SP 본문**: Fact Pack에 SP 내부 로직 없음. 아래 사항 확인 필요:
   - DMF0052_GET_PJT_DATA: #T_GSCM_DATA, #T_ERP_DATA 임시테이블 생성/조인 로직
   - DMF0052_GET_DETAIL_DATA: Sales Site/SSPM/Incoterms 검증 조건
   - DMF0052_GET_ERP_DATA: ERP Status, Status Detail 계산 로직
   - DMF0052_GET_STATUS_DATA: 상태별 집계 기준
2. **chkToday_CheckedChanged 핸들러**: 이벤트는 등록되어 있으나 메서드 본문 없음
3. **spdData_CellDoubleClick 핸들러**: 팝업 호출 조건 확인 필요 (DMF0052_GSCMDataPopup 호출 추정)
4. **Site Popup 시트**: 메타에 정의되어 있으나 코드에서 참조 없음 (폐기 후보). DMF0052_GET_SITE_POPUP SP는 Form_Load:211에서 호출되나 화면 표시 여부 불명
5. **조회 조건 빈값 처리**: 기간/EDI Sender/프로젝트/Model 미선택 시 SP 내부 처리 방식 확인 필요 (STRING_SPLIT 함수 사용 → 빈값 시 전체 조회 추정)
6. **Division 확장**: 현재 메타가 81만 정의. 다른 division 지원 필요 여부 및 메타 추가 작업 범위 확인 필요
7. **권한**: TB_FX_GroupMenuAuth에 4행 메타 존재하나 C/R/U/D 권한 상세 미확인

---

=== FILE: screen_design.md ===
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

=== FILE: unit_test.md ===
# DMF0052 EDI Summary 단위테스트

## 테스트 케이스
| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-DMF0052-001 | 초기화 | 화면 미진입 | 화면 진입 | - | EDI Sender 콤보 데이터 로드, 조회조건 초기화, 빈 그리드 표시 | Form_Load, DM.UP_FX_GetCommonDataList_DM, UP_FX_GETCOMMONDATALIST_DM |
| TC-DMF0052-002 | 초기화 | 화면 진입 | - | - | 6개 시트(SUMMARY, Summary Pjt, Summary Status, GSCM Data, ERP Data, Site Popup) 컬럼 메타 로드 | Form_Load, DM.DMF0052_GET_SPREAD_TITLE, DMF0052_GET_SPREAD_TITLE |
| TC-DMF0052-003 | 조회 | 화면 진입 완료 | 조회 버튼 클릭 | 기간: 2026-01-01~2026-01-31, EDI Sender: 전체, 프로젝트: 빈값, Model: 빈값 | SUMMARY 시트에 날짜별 ERP 전송/GSCM 수신 건수 표시 | FindButton, DM.DMF0052_GET_SUMMARY_DATA, DMF0052_GET_SUMMARY_DATA, SUMMARY 시트 |
| TC-DMF0052-004 | 조회 | 화면 진입 완료 | 조회 버튼 클릭 | 기간: 2026-01-01~2026-01-31, EDI Sender: 전체, 프로젝트: 빈값, Model: 빈값 | Summary Pjt 시트에 프로젝트별 정상/검증 필요 건수 표시 | FindButton, DM.DMF0052_GET_PJT_DATA, DMF0052_GET_PJT_DATA, Summary Pjt 시트 |
| TC-DMF0052-005 | 조회 | 화면 진입 완료 | 조회 버튼 클릭 | 기간: 2026-01-01~2026-01-31, EDI Sender: 전체, 프로젝트: 빈값, Model: 빈값 | Summary Status 시트에 상태별 통계 표시 | FindButton, DM.DMF0052_GET_STATUS_DATA, DMF0052_GET_STATUS_DATA, Summary Status 시트 |
| TC-DMF0052-006 | 조회 | 조회 완료 | Summary Pjt 시트에서 CHECK_GSCM_CNT 컬럼(값 != "0") 더블클릭 | - | spdData 시트가 "GSCM Data"로 전환되고 Master Data 검증 상세 표시 (10컬럼) | spdPjt_CellDoubleClick, DM.DMF0052_GET_DETAIL_DATA, DMF0052_GET_DETAIL_DATA, GSCM Data 시트 |
| TC-DMF0052-007 | 조회 | 조회 완료 | Summary Pjt 시트에서 CHECK_ERP_CNT 컬럼(값 != "0") 더블클릭 | - | spdData 시트가 "ERP Data"로 전환되고 ERP 데이터 상세 표시 (10컬럼) | spdPjt_CellDoubleClick, DM.DMF0052_GET_ERP_DATA, DMF0052_GET_ERP_DATA, ERP Data 시트 |
| TC-DMF0052-008 | 이벤트 | spdData "GSCM Data" 시트 표시 중 | btnRefresh 버튼 클릭 | - | GSCM Data 시트 데이터 재조회 및 갱신 | BtnRefresh_Click, DM.DMF0052_GET_DETAIL_DATA, DMF0052_GET_DETAIL_DATA, GSCM Data 시트 |
| TC-DMF0052-009 | 이벤트 | 조회조건 입력 중 | chkToday 체크박스 체크 | chkToday: checked | drpPeriod가 오늘 날짜로 설정됨 (추정) | chkToday_CheckedChanged |
| TC-DMF0052-010 | 이벤트 | 조회조건 입력 중 | btnProject 버튼 클릭 | - | 프로젝트 선택 팝업 표시, 선택값 txtProject에 반영 (추정) | btnProject_Click |
| TC-DMF0052-011 | 이벤트 | 조회조건 입력 중 | btnItemId 버튼 클릭 | - | Model 선택 팝업 표시, 선택값 txtItemId에 반영 (추정) | btnItemId_Click |
| TC-DMF0052-012 | 그리드 | spdData 표시 중 | GSCM Data ↔ ERP Data 시트 수동 전환 | - | 시트 전환 성공, 각 시트 초기화 로직 실행 (추정) | spdData_ActiveSheetChanging |
| TC-DMF0052-013 | 그리드 | spdData 표시 중 | spdData 셀 더블클릭 | - | 팝업 호출 (조건 확인 필요) | spdData_CellDoubleClick |
| TC-DMF0052-014 | 그리드 | Summary Pjt 시트 표시 중 | CHECK_GSCM_CNT 컬럼(값 = "0") 더블클릭 | - | 동작 없음 (더블클릭 조건: 값 != "0") | spdPjt_CellDoubleClick, Summary Pjt 시트 |
| TC-DMF0052-015 | division | 화면 진입 | 조회 버튼 클릭 (division=81) | - | SUMMARY 시트 4컬럼 표시 (날짜, Status, ERP전송 데이터 수, GSCM 수신한 데이터 수) | SUMMARY 시트, division=81 메타 |
| TC-DMF0052-016 | division | 화면 진입 | 조회 버튼 클릭 (division=81) | - | Summary Pjt 시트 8컬럼 표시 (EDI Sender, EDI Sender Code, Project Code, 수신한 데이터 수, 정상, Master Data 정비 필요 건 수 (GSCM), ERP Data 확인 필요, 최종 수신일) | Summary Pjt 시트, division=81 메타 |
| TC-DMF0052-017 | division | 화면 진입 | 조회 버튼 클릭 (division=81) | - | Summary Status 시트 4컬럼 표시 (Status GSCM, Status ERP, Qty, %) | Summary Status 시트, division=81 메타 |
| TC-DMF0052-018 | division | GSCM Data 시트 표시 | - | - | 10컬럼 표시 (EDI Sender, EDI Sender Code, Project Code, Model, Nickname, Sales Site 누락, Sales Site Active, SSPM 누락, SSPM Active, EDI Incoterms(SSPM)) | GSCM Data 시트, division=81 메타 |
| TC-DMF0052-019 | division | ERP Data 시트 표시 | - | - | 10컬럼 표시 (EDI Sender, Company, Sold to, Ship to, EDI_IF_SEQ, Model, Nickname, Status, (ERP) Status, Status Detail) | ERP Data 시트, division=81 메타 |
| TC-DMF0052-020 | 조회 | 화면 진입 완료 | 조회 버튼 클릭 | 기간: 빈값, EDI Sender: 빈값, 프로젝트: 빈값, Model: 빈값 | 전체 데이터 조회 (빈값 시 전체 조회 추정) | FindButton, DM.DMF0052_GET_SUMMARY_DATA, DM.DMF0052_GET_PJT_DATA, DM.DMF0052_GET_STATUS_DATA |
| TC-DMF0052-021 | 조회 | 조회 완료 | - | - | SUMMARY 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_SUMMARY_DATA, DMF0052_GET_SUMMARY_DATA, SUMMARY 시트 |
| TC-DMF0052-022 | 조회 | 조회 완료 | - | - | Summary Pjt 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_PJT_DATA, DMF0052_GET_PJT_DATA, Summary Pjt 시트 |
| TC-DMF0052-023 | 조회 | 조회 완료 | - | - | Summary Status 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_STATUS_DATA, DMF0052_GET_STATUS_DATA, Summary Status 시트 |
| TC-DMF0052-024 | 조회 | GSCM Data 시트 표시 요청 | - | - | GSCM Data 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_DETAIL_DATA, DMF0052_GET_DETAIL_DATA, GSCM Data 시트 |
| TC-DMF0052-025 | 조회 | ERP Data 시트 표시 요청 | - | - | ERP Data 시트에 데이터 0건 표시 (조회 결과 없을 경우) | DM.DMF0052_GET_ERP_DATA, DMF0052_GET_ERP_DATA, ERP Data 시트 |
| TC-DMF0052-026 | 그리드 | 화면 진입 | - | - | Site Popup 시트 메타 존재하나 화면 표시 안 됨 (미사용 추정, 확인 필요) | Site Popup 시트, DM.DMF0052_GET_SITE_POPUP |
| TC-DMF0052-027 | 팝업 | spdData 셀 더블클릭 (PopupType = "CHECK_SALES_SITE" 추정) | - | - | EDI Summary GSCM DATA Popup 표시, 5개 컬럼 표시 (SENDER_NAME, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, Message) | spdData_CellDoubleClick, EDI Summary GSCM DATA Popup 시트 |
| TC-DMF0052-028 | 팝업 | spdData 셀 더블클릭 (PopupType != "CHECK_SALES_SITE" 추정) | - | - | EDI Summary GSCM DATA Popup 표시, 9개 컬럼 표시 (SENDER_NAME, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, SCM_SITE_ID, VALID_YN, GSCM_CODE, CODE_VALID_YN, Message) | spdData_CellDoubleClick, EDI Summary GSCM DATA Popup 시트 |

---
