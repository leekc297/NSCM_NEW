# SCP0005 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순 | 라벨(원문) | AS-IS 컨트롤 | TO-BE 형태 후보 | 데이터 출처 후보 | 비고 |
|---:|---|---|---|---|---|
| 1 | Valid | cboValidYN (UsrCombo) | 단일 Combo | biz:CommonData.YesOrNo (dtValidYN:51) | 기본값은 **확인 필요** |
| 2 | Trans Mode | clbTransMode (UsrCheckedList) | 다중 선택 | biz:CommonData.CommonDataList [code=LookupCommon] (dtTransMode:49) | 조회 시 GetCheckedListValue(CODE) 후보 |
| 3 | From Country | txtFromCountry (TextBox) | Input + 검색 팝업 | btnFromSrch → popCity.Country | |
| 4 | From City | txtFromCity (TextBox) | Input + 검색 팝업 | btnFromSrch → popCity.City | |
| 5 | To Country | txtToCountry (TextBox) | Input + 검색 팝업 | btnToSrch → popCity.Country | |
| 6 | To City | txtToCity (TextBox) | Input + 검색 팝업 | btnToSrch → popCity.City | |

- 조회조건 저장/복원은 `InitControls` 가 ManualSearchCondition 의 ControlName/ControlValue 로 수행합니다(메타 TB_FX_SearchCondition 32행).
- 조회조건 패널 유형은 HidePanel(접힘 가능)입니다.
- 위 '순'은 라벨을 나열한 순서일 뿐 실제 화면 배치 순서가 아닙니다. 배치 좌표는 **확인 필요**입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | AS-IS 엔드포인트 | TO-BE API 후보 | 비고 |
|---|---|---|---|---|
| 화면 로드 | `Form_Load`(.ctor:144) | 필드 초기화 biz 5건(진입점 미연결) | 공통코드 조회(COUNTRY_MST, LookupCommon, YesOrNo) | 로드 시 호출 여부 확인 필요 |
| 조회 | FindButton > FindDataMain | SCP.SCP0005_GET_DISTRIBUTION_ROUTE | 조회 API(목록) | |
| 조회(수신) | FindButton > FindDataReceive | SCP.SCP0005_GET_DISTRIBUTION_ROUTEID | Route ID 단건/수신 조회 API | 분기 조건 확인 필요 |
| 조회(국가·도시) | FindButton > GetData_Country | SCP.SCP0005_GET_COUNTRY_CITY | 국가/도시 조회 API | SetCityCode 와의 관계 확인 필요 |
| 저장 | SaveButton > SaveData | SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE | 저장 API(추가/수정/삭제 통합) | 저장 후 FindDataMain 재조회 |
| 편집 | EditButton(318) | — | — | 동작 확인 필요 |
| Excel 업로드 | `btnEaxel_Upload_Click` | 이후 SCP.SCP0005_GET_DISTRIBUTION_ROUTE | 업로드 처리 + 조회 API | 업로드 데이터를 저장하는 경로 확인 필요 |
| Excel 양식 | `btnExcel_Form_Click` | — | Excel 양식 다운로드(공통) | SCM_ADM_EXCEL_COLUMNS 1행 |
| From 도시 검색 | `btnFromSrch_Click` | popCity(확인 필요) | 도시 선택 팝업 | |
| To 도시 검색 | `btnToSrch_Click` | popCity(확인 필요) | 도시 선택 팝업 | |
| 셀 더블클릭 | `spdMain_CellDoubleClick` | — (1135~1164 Changed 핸들러 해제/재등록) | 셀 팝업/값 설정 | 이력 팝업 호출 여부 확인 필요 |
| 셀 값 변경 | `spdMainDataModel_Changed` | — | 셀 편집 후 처리(cellEditEnded 계열) | 변경 셀·계산 로직 확인 필요 |
| 이력 팝업 조회 | 팝업 `Form_Load` / FindButton > FindData | SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 이력 조회 API | 팝업 Text "DistributionRoute History" |

> 'TO-BE API 후보' 열은 역할만 적었습니다. 실제 URL과 메서드명은 TO-BE BE 명명 규약에 따르며 Fact Pack 범위 밖입니다.

## 3. division별 Grid 변형 요약

| 시트 | 표시 컬럼 수 | division 차이 | 필수 컬럼 |
|---|---:|---|---|
| Distribution Route | 39 | 없음(14개 division 동일) | ROUTE_ID |
| POPUP | 16 | 없음(14개 division 동일) | ROUTE_ID |

- 코드 분기로 컬럼을 표시하거나 숨기는 곳은 없습니다(판단불가 0건).
- 그리드 헤더는 2단입니다(SetSheetHeaderColumn iColumnHeaderRowCount=2).

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 |
| 사용자 그룹 참조 | `<field:UserGroup>` 가 UserInfoContext.Current["NowGroupID"] 를 읽음(60행) |
| 사이트 권한 | FromSiteByDivision/ToSiteByDivision 공통코드가 TB_FX_USERGROUPAUTHEXTENTION 을 참조. 단, 호출자는 진입점 미연결 |
| C/U/D | 저장 SP 하나가 SCP_MST_DISTRIBUTION_ROUTE 에 INSERT/UPDATE/DELETE 를 모두 수행 |
| R | 조회 SP 4종(ROUTE, ROUTEID, COUNTRY_CITY, HISTORY_ROUTEID) |
| 그룹별 C/R/U/D 플래그 값 | TB_FX_GroupMenuAuth 행의 내용이 Fact Pack 본문에 없음 — **확인 필요** |

## 5. 미확정 사항

1. FindButton 하나에서 FindDataMain / FindDataReceive / GetData_Country 로 갈라지는 조건
2. 필드 초기화 biz 호출 5건과 미연결 메서드 4건(GetFromSitebyDivision, GetToSitebyDivision, GetBodType, GetTransMode)의 실제 사용 여부
3. `popCity` 팝업의 정체와 사용하는 엔드포인트
4. `spdMain_CellDoubleClick` 과 `spdMainDataModel_Changed` 의 내부 로직(이력 팝업 호출, 셀 계산)
5. Excel 업로드의 저장 경로, Excel 양식 생성 방식
6. SaveButton:333 의 SaveData 매핑 충돌(PersonalSettingPopup.SaveData vs 화면 SaveData:752)
7. 그리드 컬럼 순서와 2단 헤더 그룹명
8. 각 SP 의 파라미터 목록과 출력 컬럼(메타 39/16컬럼과의 일치)
9. `biz:CommonData.YesOrNo` 의 데이터 출처
10. usrLayoutControl1(657×184, parent 미지정)과 imageList1 의 용도
11. TB_FX_GroupMenuAuth 그룹별 권한 값
