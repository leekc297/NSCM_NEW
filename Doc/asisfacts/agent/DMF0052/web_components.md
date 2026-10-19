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
