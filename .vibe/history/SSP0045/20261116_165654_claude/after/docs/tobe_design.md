# SSP0045 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | AS-IS 컨트롤 | 필수 표시 | 데이터 원천(사실) | 비고 |
|---|---|---|---|---|
| Operation Group* | cboBizType | `*` | 원천 **확인 필요** | 변경 시 `CommonData.CommonDataList` [PlantByDivisionOperation] 호출(413줄) |
| Division* | cboDivision | `*` | 원천 **확인 필요** | 변경 시 SetChangedControl → [PlantByDivisionOperation](268줄) |
| Bucket | cboBucketType | - | `DM0003_GET_BUCKET_TYPE_CODE` (GetBucketType:279) | 코드 비교값 DAILY/WEEKLY/MONTHLY · 변경 시 Grid 컬럼 표시 재계산 |
| Model | txtItem_Id (+btnItem_Id) | - | 버튼 팝업 → `txtItem_Id.Text = sItemId`(1198줄) | 팝업 종류 **확인 필요** |
| Period* | drpPeriod | `*` | `SCM0001_GET_SCP_DAY_PERIOD` (GetDayRange:647) | `Enabled=false` (편집 불가) |
| From Site | clbFromSite | - | [PlantByDivisionOperation] 결과로 채워지는 것으로 보임 — **확인 필요** | 다중 선택(`GetCheckedListValue`) |
| Sum | chkSum | - | - | 변경 시 `M_`(및 DAILY 시 `W_`) 컬럼 표시 토글 |

조건 저장(TB_FX_SearchCondition 55행) 존재 — 저장 항목 상세는 **확인 필요**.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입 | 호출 순서 | API 후보 |
|---|---|---|---|
| 화면 로드 | `Form_Load` | 공통코드[PlantByDivisionOperation] → Bucket 코드 → 공통코드[PlantSiteByDivision] → 기간 범위 → 달력 헤더 | 공통코드 API, `DM0003_GET_BUCKET_TYPE_CODE`, `SCM0001_GET_SCP_DAY_PERIOD`, `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| Division 변경 | `CboDivision_SelectedIndexChanged` | 공통코드[PlantByDivisionOperation] | 공통코드 API |
| Operation Group 변경 | `CboBizType_SelectedIndexChanged` | 공통코드[PlantByDivisionOperation] | 공통코드 API |
| Bucket 변경 / Sum 체크 | `cboBucketType_SelectedIndexChanged` / `chkSum_CheckedChanged` | SetSpreadColumn (서버 호출 없음) | FE 처리 |
| Model 검색 | `BtnItem_Id_Click` | 팝업 | 팝업 API **확인 필요** |
| 조회 | FindButton → `FindData_Main` | 공통코드[PlantSiteByDivision] → 달력 3SPAN → `SSP0045_GET_SHIPMENT_REQUEST` | 조회 API (SSP0045_GET_SHIPMENT_REQUEST) |
| 저장 | SaveButton → `SaveData` | `checkValidN0` 검증(추정 위치) → `SSP0045_SAVE_SHIPMENT_REQUEST` → 재조회 | 저장 API (SSP0045_SAVE_SHIPMENT_REQUEST) |
| 행 추가 | InsertRow / InsertRow2 | ITEM_ID 콤보 = `Data_SCP.Common(BODItemProjectRoute, division, bizType)` | API **확인 필요** / 진입 버튼 **확인 필요** |
| 편집 | EditButton(449) | GetSheetInfo | 동작 **확인 필요** |
| 셀 클릭 | `SpdMain_CellClick` | GetCheckedListValue(1227·1228), ComboSelChange 해제(1252)→재등록(1334) | FE 처리 · 서버 호출 여부 **확인 필요** |
| 기타 Grid 이벤트 | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_ComboSelChange` | 미추출 | **확인 필요** |

저장 시 행 키 후보(checkValidN0 읽는 컬럼): p_division_id, p_scm_site_id, p_item_id, p_incoterms, p_transport_mode, p_plant_site_id, p_bod_id, p_project_code, p_fcst_type (+ dr 에만 p_user_id).

## 3. division별 Grid 변형 요약
- 시트 `Shipment Request` 단일. 메타 표시 12 / 숨김 6, **14개 division 모두 동일**.
- 코드의 컬럼 변경은 division 이 아니라 **Bucket(DAILY/WEEKLY/MONTHLY)·Sum 체크** 기준.
- 날짜 컬럼은 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과로 동적 생성(3단 헤더, SAT 파랑/SUN 빨강, `B_` 컬럼 숨김).
- SP 내부 division 40 전용 처리 흔적(`SSP_ANL_SHIP_PLAN_40`, `#TBLDYNAMIC_SCP0045_40_STD`) — 결과 컬럼 차이 여부 **확인 필요**.

## 4. 권한(C/R/U/D) 관련 사실
- `TB_FX_GroupMenuAuth` 11행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행 존재 — 권한 값(C/R/U/D 플래그) 내용은 미첨부, **확인 필요**.
- 화면 코드: `SetChangeControl` 에서 `Filter[GROUP_ID]`, `NowGroupID`, `Filter[USER_ID]` 사용 후 `GetSSPInnerTable` 호출 — 그룹/사용자 기준 필터 적용 사실만 확인.
- 행 추가 시 `siMain.IsLock(siMain.SheetName) == false` 조건 — 시트 잠금 시 ITEM_ID 콤보 미설정.
- `TB_FX_Favorite` 14행(즐겨찾기) 존재.

## 5. 미확정 사항
| # | 항목 |
|---|---|
| 1 | `usrButton1` 용도, `InsertRow`/`InsertRow2`/`EditButton` 진입 버튼 |
| 2 | `BODItemProjectRoute` 데이터 원천 SP |
| 3 | Operation Group·Division 콤보 데이터 원천, From Site 목록 원천 |
| 4 | Period 값 설정 방식(SCM0001 결과 → drpPeriod 대입 코드) |
| 5 | DAILY 버킷에서 `W_` 컬럼 최종 표시 여부 |
| 6 | 측정값(SCM_MST_SHEET_MEASURE 9행) 목록·순서, 메타 컬럼 표시 순서 |
| 7 | SaveButton:527 `SaveData` 의 프레임워크 매핑(PersonalSettingPopup.SaveData) 오매핑 여부 |
| 8 | 권한 C/R/U/D 실제 값 |
| 9 | SP 내부 division 40 분기, `RESULT_ERP_C_EXIST/NON` 객체 성격 |
