# SCP0111 Integration PSI — TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순서(추정 아님: Designer 선언 순서 아님 — 배치 좌표 확인 필요) | 라벨 원문 | 컨트롤 | 필수 | 데이터 원천 |
|---|---|---|---|---|
| - | `Division*` | cboDivision | Y(*) | 확인 필요 (Division 콤보 원천이 Fact Pack에 없음) |
| - | `Plan-date*` | cboPlanDate | Y(*) | 확인 필요 (RefreshPlanDate — dtPlanTypeFN.PLANDATE) |
| - | `Plan-type` | cboPlanType | - | Visible=false. 원천 확인 필요(RefreshPlanType) |
| - | `Period` ~ ` ~` | cmbFromMonth ~ cmbToMonth | 확인 필요 | CommonDataList CalendarMonth (SetChangedPeriod:287/288, DataBind:290/291) |
| - | `Nick Name` | txtNickName + btnNickName | - | 팝업 원천 확인 필요 |
| - | `Model` | txtItemId + btnItemId | - | 팝업 원천 확인 필요 |
| - | `Cell Model` | txtCellItemId (btnCellItem_Id 숨김) | - | 직접 입력 |
| - | (체크) `Qty < 0` | chkQty | - | - |

- TB_FX_SearchCondition에 SCP0111 행이 19개 있습니다. 조회조건 저장 대상과 순서는 이 행으로 확인해야 합니다.

연동 동작:
- Division / Plan-date / Plan-type을 바꾸면 SetChangedPeriod가 실행되어 Period From/To 콤보를 다시 채웁니다.
- Plan-date를 바꾸면 InitSpread > SetCalendar로 그리드 월 컬럼을 다시 생성합니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 API 후보 |
|---|---|---|
| 화면 진입 | Form_Load | `SCP0111_GET_ESS_PACK_LINE`, `DM0003_GET_BUCKET_TYPE_CODE`, CommonDataList(CalendarMonth) |
| 조건 변경 | Cbo*_SelectedIndexChanged, _defaultDataModel_Changed | CommonDataList(CalendarMonth) |
| 조회(Find) | FindButton > FindData_Main | `SCP0111_GET_INTEGRATION_PSI` + 월 컬럼용 CommonDataList(CalendarMonth) |
| 편집(Edit) | EditButton | CommonDataList(CalendarMonth, LookupCommon). 편집 모드에서 SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE를 표시 |
| 저장(Save) | SaveButton > SaveData | `SCP0111_SAVE_INTEGRATION_PSI_ADMIN` 또는 `SCP0111_SAVE_INTEGRATION_PSI`(분기 조건 확인 필요) → 저장 후 `SCP0111_GET_INTEGRATION_PSI` 재조회 |
| 행 추가 | InsertRow (NowGroupID 사용) | 진입 버튼 확인 필요 |
| 셀 클릭 | spdMain_CellClick | Line CODE/NAME 참조(dtLine 원천 확인 필요) |

## 3. Division별 Grid 변형 요약
- 메타: 모든 division이 SHEET_COLUMNS 22/0, SHEET_MEASURE 7/0으로 같습니다. **변형이 없습니다**.
- 코드: division 분기가 없습니다.
- 공통 코드 변형:
  - 월 동적 컬럼(CalendarMonth, 폭 75)
  - Tag D_/W_ 숨김, M_ 표시
  - 편집 모드/조회 모드에 따른 SEQ_FLAG·MEASURE·PLANT_ID·TO_SITE 전환

## 4. 권한(C/R/U/D) 관련 사실
- 메타: TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행이 있습니다. 권한 플래그 값은 Fact Pack에 없어 확인 필요입니다.
- 코드: EditButton:559, InsertRow:960, SaveData:1159에서 `FoxUserInfoContext.Current.NowGroupID`를 읽습니다. 그룹별로 동작이 다를 수 있지만 조건은 확인 필요입니다.
- 저장 SP가 `_ADMIN` / 일반 2종으로 나뉘어 있는 사실이 있습니다.
- 버튼 오버라이드로는 Find / Edit / Save만 Fact Pack에 있습니다. Delete 관련 사실은 없습니다.

## 5. 미확정 사항
1. ADMIN 저장 / 일반 저장의 분기 조건과, NowGroupID와의 관계.
2. Plan-date / Plan-type / Plan-seq 콤보의 데이터 원천(RefreshPlanDate / RefreshPlanType / RefreshPlanSeq).
3. Division 콤보 원천.
4. Nick Name / Model 팝업 원천.
5. InsertRow 진입점, SpdMain_CellDoubleClick / SpdMain_TopChange 동작.
6. SaveButton:816 SaveData의 해석(PersonalSettingPopup으로 오인했는지).
7. SHEET_MEASURE 7행의 Measure 목록과 순서. MEASURE_COLOR를 쓰는 방식.
8. GET SP 동적 SQL의 컬럼 생성 규칙. D_/W_/M_ Tag 컬럼과 어떻게 대응하는지.
9. 조회조건 실제 배치 순서(좌표 미추출).
10. `<field:dtPeriod>`:66 LookupCommon 호출 시점.
