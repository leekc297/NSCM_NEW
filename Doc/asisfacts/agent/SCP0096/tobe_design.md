# SCP0096 — TO-BE 설계 요약

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | AS-IS 컨트롤 | 필수 | TO-BE | 비고 |
|---|---|---|---|---|
| Division* | cboDivision (UsrCombo) | 필수(`*`) | ComboBox | 변경 이벤트 있음(본문 확인 필요) |
| Plant Site | clbPlantSite (UsrCheckedList) | – | MultiSelect | FindData_Main 442/443에서 GetCheckedListValue(CODE) 사용 |
| Period* | dCalendar (UsrDateRangePicker3) | 필수(`*`) | Date Range | |
| Day of the week | cboDayWeek (UsrCombo) | – | ComboBox (다중 여부 확인 필요) | 데이터 원천 후보 biz:CommonData.CommonDataList [code=LookupCommon] (dtDayWeek) — 확인 필요 |
| Input Value | cboInputValue (UsrCombo) | – | ComboBox | Day of the week 선택에 따라 Enabled 토글 |
| (버튼) Input | btnInput | – | Button | 일괄 입력 동작 |
| Sum | chkSum (UsrCheckBox) | – | CheckBox | AS-IS **Visible=false** — TO-BE 노출 여부 확인 필요 |

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 API 후보 |
|---|---|---|
| 화면 진입 | Form_Load > InitControls > GetBucketType | DM0003_GET_BUCKET_TYPE_CODE (바인딩 대상 컨트롤 확인 필요) |
| 화면 진입 | Form_Load > CreateSpread > InitSpread > GetSpdTitle | SCP0009_GET_SHEET_CALENDAR_3SPAN (Grid 날짜 헤더) |
| 조회 | FindButton > FindData_Main | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP + SCP0009_GET_SHEET_CALENDAR_3SPAN(헤더 재생성) |
| 저장 | SaveButton > SaveData_Main → FindData_Main | **저장 SP 확인 필요** → 이후 조회 API 재호출. 파라미터: p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default. 변경 행은 GetChanges(ROW_ID) |
| Day of the week 변경 | CboDayWeek_SelectedIndexChanged | API 없음. cboInputValue Enabled 토글(675/679) |
| Input 클릭 | BtnInput_Click | API 없음(추출 기준). GetCheckedListValue 695/696 이후 동작 확인 필요 |
| Sum 토글 | chkSum_CheckedChanged | API 없음. SetSpreadColumn으로 M_/W_ 컬럼 표시 토글 |
| Division 변경 | CboDivision_SelectedIndexChanged | 확인 필요 (Plant Site 재조회 여부 등) |
| Plant Site 변경 | ClbPlantSite_SelectedIndexChanged | 확인 필요 |
| Grid 더블클릭 | SpdMain_CellDoubleClick | 확인 필요 |
| Grid 스크롤 | SpdMain_TopChange | 확인 필요 |
| (주석 처리됨) | SCP.SCP0019_GET_WORKING_TIME (456) | 주석 처리됨 — 현행 아님, 구현 대상 아님 |

## 3. Division별 Grid 변형 요약

- 시트는 `Shipment Working Day OSP` 1개입니다.
- 메타 고정 6개 컬럼(DIVISION_ID, LAST_INPUT_DATE, MEASURE, PLANT_SITE_ID, PLANT_SITE_NAME, WORKING_TIME_DEFAULT)은 14개 division 모두 "기본"입니다. **division별 변형은 없습니다.**
- 날짜 컬럼은 SCP0009 결과를 DB 루프로 돌려 동적으로 생성합니다(Combo Y/N, 폭 50, SAT 파랑 / SUN 빨강, `B_` 포함 컬럼은 숨김 Text).
- 헤더 3단(Large / Small / 컬럼)에 그룹별 `"SUM"` 헤더가 있습니다.
- Tag 접두어로 표시를 토글합니다: `D_` 표시, `M_`/`W_`는 chkSum.Checked를 따릅니다(`W_` 최종값은 확인 필요).

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | dbo.TB_FX_GroupMenuAuth 4행 (값 미포함 → C/R/U/D 확인 필요) |
| 메뉴/프로그램 | TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행 |
| 사용 버튼 (코드 기준) | FindButton(조회), SaveButton(저장), EditButton(288, 진입점 표 미포함 — 확인 필요) |
| 저장 사용자 | SaveData_Main이 p_user_id를 전달 |

## 5. 미확정 사항

1. 저장 SP와 엔드포인트 (최우선)
2. DM0003_GET_BUCKET_TYPE_CODE 결과의 사용처 (cboBucketType 컨트롤 없음, `cboBucketType_SelectedIndexChanged` 미배선)
3. `biz:CommonData.CommonDataList` [code=LookupCommon]의 Lookup 그룹 키와 cboDayWeek 바인딩 여부
4. `biz:CommonData.YesOrNo`가 진입점 미연결로 분류됐지만 grid_code 203에서 사용되는 상충
5. chkSum 숨김(Visible=false) 상태에서 M_/W_ 컬럼을 노출할지에 대한 TO-BE 정책
6. cboInputValue Enabled 토글 조건(675/679)과 BtnInput_Click의 일괄 입력 대상(행/열 범위)
7. SaveData_Main 570~573 / 578~581 두 블록의 분기 조건
8. CellDoubleClick / TopChange / CboDivision / ClbPlantSite 핸들러 본문
9. usrButton1의 용도
10. 메타 6개 컬럼의 정렬 순서, 폭, 편집 여부(SCM_MST_SHEET_COLUMNS 행 값 미포함)
11. TB_FX_GroupMenuAuth 4행의 권한 값
