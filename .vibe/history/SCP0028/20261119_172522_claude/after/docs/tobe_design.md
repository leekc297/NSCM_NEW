# SCP0028 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨 (AS-IS 원문) | AS-IS 컨트롤 | 형태 | 필수 | 데이터 소스 | 연동 |
|---|---|---|---|---|---|
| Division* | cboDivision | 단일 콤보 | `*` 표기 | **확인 필요** | 변경 시 From/To Site 재조회 (`ClbDivision_SelectedIndexChanged` → `SetChangedControl`) |
| Operation Group | cboOperationGroup | 단일 콤보 | – | **확인 필요** | – |
| From Site | clbFromSite | 멀티 체크 | – | CommonDataList FromSiteByDivision (NowGroupID) | Division 종속 |
| To Site | clbToSite | 멀티 체크 | – | CommonDataList ToSiteByDivision (NowGroupID) | Division 종속 |
| Trans Mode | clbTransMode | 멀티 체크 | – | CommonDataList LookupCommon (추정, **확인 필요**) | – |
| Model | txtItemId + btnItemId | 멀티라인 입력 + 검색 버튼 | – | `btnItemId_Click`이 `txtItemId.Text` 설정 | 팝업 여부 **확인 필요** |
| Valid | cboValid | 단일 콤보 | – | `biz:CommonData.YesOrNo` | – |

- `FindData`는 332~336줄에서 `GetCheckedListValue`를 5회 호출합니다. 어느 5개 컨트롤에서 값을 꺼내는지는 **확인 필요**입니다.
- `TB_FX_SearchCondition`에 54행이 있습니다(조회조건 저장/복원 메타). 내용은 **확인 필요**입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 SP | 후속 |
|---|---|---|---|
| 화면 진입 | `Form_Load` > `InitControls` | YesOrNo, LookupCommon, From/ToSiteByDivision | – |
| Division 변경 | `ClbDivision_SelectedIndexChanged` > `SetChangedControl` | From/ToSiteByDivision | – |
| 조회 (Search) | `FindButton` > `FindData` | `SCP0028_GET_SHIPMENT_LOT_SIZE` | – |
| 저장 (Save) | `SaveButton` > `SaveData` | `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | `FindData` 재조회 |
| Input | `btnInput_Click` > `FindInput` | `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | Grid 반영 방식(행 추가 또는 대체) **확인 필요** |
| Delete | `btnDelete_Click` > `FindDelete` | `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | `FindData` 재조회 |
| Model 검색 | `btnItemId_Click` | 없음 | `txtItemId.Text` 설정 |
| Grid 편집 | `spdMain_Change` (dsdm.Changed) | 없음 | 본문 **확인 필요** |
| Grid 스크롤 | `SpdMain_TopChange` | 없음 | 본문 **확인 필요** |

- BE 후보: Controller → Service → `SCP0028` 패키지의 조회 / Input 조회 / 저장(삭제 겸용) 3개 프로시저.
- Delete가 저장 SP를 공유하므로 TO-BE에서도 같은 SP를 호출하는 방식(구분 인자)을 유지할지 **확인 필요**합니다.

## 3. Division별 Grid 변형 요약

- 시트 `Shipment Lot Size` 1개. 14개 division(40, 81, 81_HD/HG/HM/ST/UC, 82, EE, EE_HD/HG/HM/ST/UC) 모두 표시 15개로 같아 division별 변형은 없습니다.
- 숨김 컬럼은 FROM_SITE, TO_SITE, TRANS_MODE_CODE입니다(전 division 공통).
- 코드에 의한 컬럼 추가나 숨김은 없고, 헤더 스타일만 override합니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| `TB_FX_GroupMenuAuth` 13행 존재 | DB 메타 §8 |
| `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 10행 존재 | DB 메타 §8 |
| Site 목록이 `TB_FX_USERGROUPAUTHEXTENTION`과 `NowGroupID`로 사용자 그룹별 제한됨 | §2 공통코드 분기 |
| 프레임워크 버튼 FindButton, SaveButton 사용 / `EditButton` 메서드 존재(231) | flow.csv, grid_code.csv |

- 그룹별 C/R/U/D 플래그 값, Input/Delete 버튼의 권한 연동 여부는 Fact Pack에 없어 **확인 필요**입니다.

## 5. 미확정 사항

1. cboDivision과 cboOperationGroup의 데이터 소스
2. LookupCommon(137)과 clbTransMode의 연결, 그리고 LOOKUP 유형 값
3. `FindDelete`가 저장 SP에 넘기는 삭제 구분값과, SP 안에서 MERGE/DELETE가 분기되는 조건
4. Input 결과를 Grid에 반영하는 방식
5. `spdMain_Change`, `SpdMain_TopChange`, `EditButton`의 동작
6. 메타 컬럼 표시 순서, 편집 유형, 필수(`*`) 검증 로직
7. `SaveButton:207`이 `PersonalSettingPopup.SaveData`로 해석된 정적 분석 결과의 정확성
8. 조회조건 항목의 배치 순서(Location)와 `usrLayoutControl1`의 용도
9. `UP_FX_GetCommonDataList`와 `_SCP` 중 실행되는 분기 조건
