# SCP0096 — TO-BE 설계 기초

## 1. 조회조건

| 컨트롤 | 라벨 | 필수 | 형태 | 비고 |
|---|---|---|---|---|
| cboDivision | Division* | Y (라벨 *) | 단일 콤보 | 데이터 원천 확인 필요. `CboDivision_SelectedIndexChanged` 연쇄 동작 확인 필요 |
| clbPlantSite | Plant Site | 확인 필요 | 멀티 체크리스트 | 값은 GetCheckedListValue 로 추출(FindData_Main:442/443) |
| dCalendar | Period* | Y (라벨 *) | 기간 From~To | SCP0009 달력 헤더와 연동 |
| chkSum | Sum | — | 체크박스 | Designer Visible=false, 기본 false. M_/W_ 컬럼 표시 토글 |

그리드 입력 보조(조회조건 영역에 있음): cboDayWeek(Day of the week), cboInputValue(Input Value), btnInput(Input).

## 2. 액션별 호출 API 후보

| 액션 | As-is 처리 | 호출 SP/엔드포인트 | TO-BE 후보 |
|---|---|---|---|
| 화면 로드 (`Form_Load`) | InitControls > GetBucketType, CreateSpread > InitSpread > GetSpdTitle | DM0003_GET_BUCKET_TYPE_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN | 콤보 조회 API + 달력 헤더 조회 API |
| 조회 (FindButton) | FindData_Main | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP + SCP0009_GET_SHEET_CALENDAR_3SPAN | 데이터 조회 API(동적 컬럼) + 헤더 API |
| 저장 (SaveButton) | SaveData_Main(GetChanges) → FindData_Main | 저장 SP 확인 필요 → 재조회 | 저장 API(변경행) + 재조회 |
| Edit (EditButton:288) | GetSheetInfo | — | 확인 필요 |
| Input (`BtnInput_Click`) | GetCheckedListValue(:695/:696) | 없음(클라이언트 처리) | 클라이언트 그리드 일괄 입력 |
| Day of week 변경 (`CboDayWeek_SelectedIndexChanged`) | cboInputValue Enabled 전환 | 없음 | 클라이언트 상태 |
| Sum 토글 (`chkSum_CheckedChanged`) | SetSpreadColumn | 없음 | 컬럼 visible 토글 |
| `SpdMain_CellDoubleClick` / `SpdMain_TopChange` | — | 확인 필요 | 확인 필요 |
| `ClbPlantSite_SelectedIndexChanged` / `CboDivision_SelectedIndexChanged` | — | 확인 필요 | 확인 필요 |

## 3. Division별 Grid 변형 요약

- 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 메타 6컬럼으로 같고, **변형이 없습니다**.
- 날짜 동적 컬럼은 Period 기준 SCP0009 결과로 생성됩니다(division 무관).

## 4. 권한(C/R/U/D) 관련 사실

- 메타 행: TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행.
- 그룹별 C/R/U/D 값은 Fact Pack 본문에 없습니다 → `dbmeta_dbo_TB_FX_GroupMenuAuth.csv` 확인 필요.
- 코드상 확인된 버튼 경로: FindButton(조회), SaveButton(저장), EditButton(:288).

## 5. 미확정 사항

1. 저장 SP 및 파라미터 계약(`p_is_save_defalut` 포함), 컬럼 "A" 의미
2. Bucket Type(DM0003) 결과의 사용처 — `cboBucketType` 컨트롤 부재
3. cboDivision / clbPlantSite / cboInputValue 데이터 원천
4. dtDayWeek LookupCommon 코드값과 cboDayWeek 바인딩 여부
5. chkSum 런타임 표시 여부, W_ 컬럼 최종 표시 규칙
6. SpdMain_CellDoubleClick / TopChange / CboDivision / ClbPlantSite 핸들러 로직
7. usrButton1 용도, 조회조건 행·열 배치
8. 메타 컬럼 순서·편집 속성(SCM_MST_SHEET_COLUMNS 원본)
9. 주석 처리됨: SCP0019_GET_WORKING_TIME — 현행 기능에서 제외
