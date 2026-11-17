# SSP0022 TO-BE 설계 기초 자료

> 아래는 As-is 사실에서 도출한 **후보**다. API 경로명은 확정값이 아니다.

## 1. 조회조건 (컨트롤 기준)

### 1-1. 상단 메인 조회 (FindButton → `SSP0022_GET_SHIPMENT_PSI`)
| 라벨(원문) | As-is 컨트롤 | 필수 | 비고 |
|---|---|---|---|
| Company* | clbCompany_ID | Y | 바꾸면 PlantEE 재조회 + 그리드 재구성(GetSpdTitle) |
| Division* | clbDivision_ID | Y | 바꾸면 clbDivision_ID_SelectedIndexChanged 실행 (DIVISION_ID 읽음) |
| Plan-date* | cboPlanDate | Y | 바꾸면 FROM_DATE/TO_DATE 반영 + GetSpdTitle |
| Period* | drpPeriod | Y | Enabled=false (Plan-date가 정한 값을 표시) |
| Bucket | cboBucketType | — | DM0003_GET_BUCKET_TYPE_CODE (DAILY/WEEKLY/MONTHLY 분기 존재) |
| Plant | clbPlantSite | — | 다중 선택 |
| Material | txtItemId (+btnItemId) | — | 멀티라인 |
| UOM Type | rdButton1 "UOM"(기본) / rdButton2 "Cell" / rdButton3 "Pancake m" | — | 표시만 바꿈 (재조회 없음) |
| Sum | chkSum | — | 표시만 바꿈 |
| Including Past Period | chkPastPeriod | — | Visible=false |
| Delegate Model / Team Leader / Part Leader | chkDelegateModel / chkTeamLeader / chkPartLeader | — | SP 인자와 어떻게 연결되는지 확인 필요 |
| My Model | chkMyModel | — | Visible=false |
| (라벨 확인 필요) | txtModelId, textNickName, clbCellType | — | |

### 1-2. 하단 상세 조회 (btnSearch → `SSP0022_GET_REQUEST_DETAIL` + `SSP0022_GET_STOCK_DETAIL`)
drpPeriod2, txtModelId2, txtRequestor(+btnRequestor), textNickName2, txtItemld2(+btnItemID2), txtLotID. 라벨은 모두 확인 필요다.

## 2. 액션별 호출 API 후보
| 액션 | As-is 경로 | 호출 SP | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | Form_Load | DM0003_GET_BUCKET_TYPE_CODE, SSP0022_GET_SHEET_CALENDAR_3SPAN | GET bucket-type, GET sheet-calendar |
| 회사 변경 | clbCompanyID_SelectedIndexChanged | CommonData PlantEE, SSP0022_GET_SHEET_CALENDAR_3SPAN | GET common-code(PlantEE), GET sheet-calendar |
| Plan-date 변경 | cboPlanDate_SelectedIndexChanged | SSP0022_GET_SHEET_CALENDAR_3SPAN | GET sheet-calendar |
| 조회 | FindButton > FindData_Main | SSP0022_GET_SHIPMENT_PSI (+3SPAN) | POST shipment-psi/search |
| Measure | BtnMeasure_Click | SSP0022_GET_SHEET_CALENDAR_3SPAN | (그리드 재구성) |
| 메인 더블클릭 | SpdMain_CellDoubleClick | SSP0022_GET_SHIPMENT_PSI (+3SPAN) | POST shipment-psi/search |
| 상세 조회 | BtnSearch_Click | SSP0022_GET_REQUEST_DETAIL, SSP0022_GET_STOCK_DETAIL (+3SPAN) | POST request-detail/search, POST stock-detail/search |
| 행추가 | InsertButton > InsertRow | CommonData PlantByElectordeShipFromSite/ToSite | GET common-code (셀 콤보) |
| 수정 | EditButton > GetSSPUserCheck | SSP0002_GET_USER_INFO_LIST | GET ssp-user-check |
| 저장 | SaveButton > SaveData / SaveData_Detail | SSP0022_SAVE_SHIPMENT_REQUEST → 재조회(PSI 또는 REQUEST_DETAIL) | POST shipment-request/save |
| 상세 셀 변경·더블클릭·붙여넣기 | SpdDetail_ComboSelChange / CellDoubleClick / ClipboardPasted > FindData_BOD | SSP0022_GET_ITEM_POPUP | GET bod-item |
| Excel Form | btnExcelFormDownload_Click | SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN | GET request-detail/excel-form |
| Upload | btnExcelUpload_Click | SSP0022_GET_SHIPMENT_PSI, SSP0022_GET_REQUEST_DETAIL (+3SPAN) | 업로드 후 재조회 (업로드 자체를 저장하는 호출은 Fact Pack에 없음 → 확인 필요) |
| BOD 팝업 | SSP0022_BodItemPopup Form_Load / 조회 | SCM0001_GET_DIVISION, SCM0001_GET_SITE_BY_DIVISION, SSP0022_GET_ITEM_POPUP, CommonData From/To Site | 팝업 API |
| 출하요청 팝업 | SSP0022_ShipmentRequestPopup Form_Load / Division 변경 / 저장 | SCP.GET_DATE_RANGE_1MONTH, CommonData 4종, SSP0022_GET_ITEM_POPUP, SSP0022_SAVE_SHIPMENT_REQUEST | 팝업 API |
| 유효성 검사(미연결) | BodItemValidChk 등 | SSP0022_GET_BOD_ITEM_VALID_CHECK, SSP0002_GET_BOD_VALID_CHECK | 실행 여부 확인 후 결정 |

## 3. division별 Grid 변형 요약
- 메타 컬럼 수는 division 14종 모두 같다: Detail 16, Detail Excel 9, Shipment Request(Electrode) 28(+MEASURE 10), Stock Detail 28.
- 코드에는 division 분기가 없다.
- 실제 변형 축은 UOM Type 라디오(BOH 3계열 × 9컬럼, 날짜 Tag X_/Y_/Z_), Bucket(D_/W_/M_), Sum, Including Past Period다. TO-BE에서는 이것을 **클라이언트 컬럼 Visible 토글**로 구현하는 방안이 후보다. As-is에서도 재조회 없이 표시만 바꾼다(rdButton_Changed, chkSum_CheckedChanged → SetSpreadColumn).

## 4. 권한(C/R/U/D) 관련 사실
| 사실 | 출처 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth 13행 (C/R/U/D 값은 Fact Pack에 없음 → 확인 필요) | DB 메타 §8 |
| 프레임워크 버튼: FindButton, InsertButton, EditButton, SaveButton 오버라이드 | flow.csv |
| 수정(EditButton) 시 `SSP0002_GET_USER_INFO_LIST`로 SSP 사용자 검사 (TB_FX_USERGROUPAUTHEXTENTION 등 참조) | M GetSSPUserCheck:4448 |
| SetChangeControl에서 GROUP_ID, USER_ID를 `UserInfoContext.Current.NowGroupID` 기준으로 필터 | M 379~380 |
| 상세 행추가는 `siDetail.IsLock(...) == false`이고 활성 시트가 "Shipment Request Detail"일 때만 콤보 설정 | M InsertRow:1481 조건 |

## 5. 미확정 사항
1. 팝업 2종을 여는 핸들러.
2. 하드코딩 시트 Project / Shipment Reqeust(Electrode)가 어느 파일에 있는지.
3. 진입점 미연결 유효성 검사 SP의 실제 사용 여부.
4. 동적 SQL SP 3종의 내부 구조와 참조 테이블.
5. splitContainer1의 분할 방향과 비율.
6. 상단·하단 조회조건 중 라벨이 Fact Pack에서 잘린 컨트롤들의 라벨 원문.
7. Excel Upload의 저장 경로 (Fact Pack에는 업로드 후 재조회 호출만 있음).
8. TB_FX_SearchCondition 141행, SCM_MST_TITLESET_USER 4행, SCM_ADM_EXCEL_COLUMNS 1행, SCM_ADM_LOOKUP_MASTER_DETAIL 3행의 내용.
9. Delegate Model / Team Leader / Part Leader 체크가 SP 인자로 어떻게 넘어가는지.
