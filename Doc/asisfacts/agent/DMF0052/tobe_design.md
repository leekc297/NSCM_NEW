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
