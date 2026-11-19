# SCP0096 TO-BE 설계 입력

## 1. 조회조건
| 순서(배치 원문 미확인) | 라벨 | AS-IS 컨트롤 | 필수 | 비고 |
|---|---|---|---|---|
| — | Division* | cboDivision (UsrCombo) | 예(라벨 `*`) | 변경 이벤트 `CboDivision_SelectedIndexChanged`(동작 확인 필요) |
| — | Plant Site | clbPlantSite (UsrCheckedList) | 확인 필요 | 다중 선택. `GetCheckedListValue`(CODE)로 값 추출(FindData_Main 442/443) |
| — | Period* | dCalendar (UsrDateRangePicker3) | 예(라벨 `*`) | 기간 |
| — | Day of the week | cboDayWeek (UsrCombo) | 확인 필요 | 변경 시 `cboInputValue.Enabled` 토글 |
| — | Input Value | cboInputValue (UsrCombo) | 확인 필요 | Input 버튼으로 일괄 입력할 값(추정 금지, 동작 확인 필요) |
| — | (버튼) Input | btnInput | — | `BtnInput_Click` |
| — | (체크) Sum | chkSum | — | Designer Visible=false, Checked=false. 합계(M_/W_) 컬럼 표시 토글 |

## 2. 액션별 API 후보
| 액션 | AS-IS 경로 | 호출 SP | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | Form_Load > InitControls > GetBucketType | DM0003_GET_BUCKET_TYPE_CODE | 공통 코드 조회 API(소비처 확인 필요) |
| 화면 진입 / 조회 헤더 | CreateSpread·FindData_Main > InitSpread > GetSpdTitle | SCP0009_GET_SHEET_CALENDAR_3SPAN | 기간별 3단 헤더 조회 API |
| 조회(FindButton) | FindData_Main | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | 조회 API(Division, Plant Site 다중, Period) |
| 저장(SaveButton) | SaveData_Main → FindData_Main 재조회 | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | 저장 API(변경 행 일괄) → 저장 후 재조회 |
| Input 버튼 | BtnInput_Click | 없음(클라이언트) | 그리드 일괄 값 입력(서버 호출 없음) |
| Sum 체크 | chkSum_CheckedChanged > SetSpreadColumn | 없음 | 컬럼 표시 토글 |
| Day of the week 변경 | CboDayWeek_SelectedIndexChanged | 없음 | Input Value 활성/비활성 |
| 셀 더블클릭 / 스크롤 | SpdMain_CellDoubleClick / SpdMain_TopChange | 묶음상 호출 없음 | 동작 확인 필요 |
| 공통코드 | dtDayWeek / dtValidYN | CommonDataList(LookupCommon) / YesOrNo | 공통 코드 API. YesOrNo는 날짜 셀 콤보 데이터 |

> 주석 처리됨: `SCP.SCP0019_GET_WORKING_TIME`(456). API 후보에서 뺐습니다.

## 3. Division별 Grid 변형 요약
- 시트 `Shipment Working Day OSP` 1개입니다. 14개 division 모두 메타 6컬럼(Division, Plant Site ID, Plant Site, Measure, Working Time Default, Last Input Date)이 같습니다.
- 날짜 컬럼은 division이 아니라 **Period와 SCP0009 결과**에 따라 바뀝니다.
  - Y/N 콤보(폭 50, 가운데 정렬)
  - 토요일 파랑, 일요일 빨강
  - `B_` 컬럼은 숨김
  - 3단 헤더와 SUM 헤더
  - `M_` 합계 컬럼은 Sum 체크에 연동

## 4. 권한(C/R/U/D) 관련 사실
- `TB_FX_GroupMenuAuth`에 이 화면 행이 **4건** 있고, `TB_FX_MenuItemInfo`와 `TB_FX_ProgramInfo`에 각 1건, `TB_FX_Favorite`에 1건이 있습니다. 권한 컬럼 값(그룹별 C/R/U/D)은 묶음에 없어 **확인 필요**입니다.
- 코드상 액션: 조회(FindButton), 저장(SaveButton), `EditButton`(288, GetSheetInfo 호출)이 확인됩니다. 삭제나 신규 행 버튼 코드는 묶음에 없습니다.
- 저장 시 `p_user_id`가 전달되고, SAVE SP에서 `PR_SCM_SYS_LOG_BATCH`로 로그를 남깁니다.

## 5. 미확정 사항
1. 조회조건 배치 순서와 행·열 좌표(Designer Location 미추출)
2. `cboDayWeek`, `cboInputValue`의 데이터원과 `BtnInput_Click` 일괄 입력 규칙
3. `GetBucketType`(DM0003) 결과의 사용처. BucketType 컨트롤 부재, `cboBucketType_SelectedIndexChanged` 미배선
4. `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged` 내부 동작
5. `W_` 컬럼 최종 Visible(350과 355가 겹침)과 `chkSum`이 Designer에서 숨김인 상태의 실사용 여부
6. 저장 파라미터 두 블록(570~573 / 578~581)의 분기와 `p_is_save_defalut`(DEFAULT 테이블 MERGE 여부) 조건
7. 메타 6컬럼의 정렬 순서, 폭, 편집 가능 여부(SCM_MST_SHEET_COLUMNS 원문)
8. 그룹별 메뉴 권한 4행의 C/R/U/D 값
