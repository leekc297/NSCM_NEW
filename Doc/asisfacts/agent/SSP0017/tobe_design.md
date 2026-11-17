# SSP0017 TO-BE 설계 입력 (Inventory Raw(Small))

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | AS-IS 컨트롤 | 유형 | 필수 | 초기 상태 / 데이터 | 비고 |
|---|---|---|---|---|---|
| `Plan-date*` | `cboPlanDate` | 단일 콤보 | 라벨에 `*` 표시 | [code=PlanDateShip] (`SetChangedControl`:365, Form_Load 시와 Division 변경 시 갱신) | |
| `Division` | `clbDivision` | 다중 체크 | 확인 필요 | `Enabled=false` (`InitControls`:176) | 사용자 Division 기본 설정 로직(`dtMyDivision` ← `NowGroupID`)과의 관계는 확인 필요 |
| `Plant Site` | `clbPlantSite` | 다중 체크 | 확인 필요 | 데이터 출처 확인 필요 | |
| `Inventory Type` | `cboInventoryType` | 단일 콤보 | 확인 필요 | 데이터 출처 확인 필요 (LookupCommon 후보) | |
| `Model` | `txtItemId` (+`btnItemId`) | 멀티라인 입력 + 버튼 | 확인 필요 | `btnItemId_Click`에서 `txtItemId.Text = sItemId` | |
| (라벨 없음) | `btnMeasure` | 버튼 | — | Click → `btnMeasure_Click` | 동작 확인 필요 |

- 조회조건 패널은 `HidePanel` 타입(접기 가능)입니다.
- TB_FX_SearchCondition에 이 화면 행이 8건 있습니다(조회조건 저장/복원 기능으로 보이며, 내용은 확인 필요).

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 핸들러 / 경로 | AS-IS 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` > `InitControls` | `biz:CommonData.CommonDataList` [LookupCommon] | 공통코드 조회 API (공용) |
| 화면 진입 / Division 변경 | `Form_Load` > `InitControls` > `SetChangedControl`, `clbDivision_SelectedIndexChanged` > `SetChangedControl` | `biz:CommonData.CommonDataList` [PlanDateShip] | 공통코드 조회 API (PlanDateShip, Division 파라미터) |
| 조회(Find) | `FindButton` > `FindData_Main` | `SSP.SSP0017_GET_INVENTORY_RAW` | 화면 조회 API → Oracle `SSP0017_GET_INVENTORY_RAW` |
| Model 버튼 | `btnItemId_Click` | 추출 없음 | 확인 필요 (결과를 `txtItemId`에 반영) |
| Measure 버튼 | `btnMeasure_Click` | 추출 없음 | 확인 필요 |
| Grid 스크롤 | `SpdMain_TopChange` | 추출 없음 | 확인 필요 (FlexGrid 스크롤 이벤트로 대응할지 판단 필요) |
| (미연결) | `GetDivision` | `SCM.SCM0001_GET_DIVISION` | 사용 여부가 확인된 뒤 결정 |
| (미연결) | `GetDayRange` | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 사용 여부가 확인된 뒤 결정 |
| (미연결) | `<field:dtInventoryStatus>` | `biz:CommonData.CommonDataList` [OWMS_STOCK_STATUS] | 사용 여부가 확인된 뒤 결정 |

- 주석 처리된 호출(`SCP.GET_DATE_RANGE_1MONTH`, `SCP.SCM0001_GET_SCP_PERIOD`)은 TO-BE 범위에서 제외합니다.
- 저장·삭제 액션은 추출되지 않았습니다. 조회 전용 화면으로 판단합니다.

## 3. Division별 Grid 변형 요약

- 현행 시트: `Inventory Raw(Mobility & IT)` (META+코드연결). 메타 31개 컬럼 중 표시 27개, 숨김 4개(`LONG_QTY`, `OPERATION_NAME`, `ROUTE_NAME`, `ROUTE_TYPE`)
- Division 14개 전부 27개로 같아서 **Division별 변형이 없습니다**.
- `Inventory Raw(IT & Mobile)` 시트는 메타에만 있고 코드는 참조하지 않습니다. 폐기 후보입니다.
- 컬럼헤더 1행, 컬럼 푸터(합계) 표시. 합계 컬럼은 확인 필요입니다.
- 메타 기반 Grid이므로 TO-BE에서도 메타(`SCM_MST_SHEET_COLUMNS` 대응) 기반 컬럼 구성이 전제입니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 값 |
|---|---|
| TB_FX_GroupMenuAuth 화면 행 수 | 14 |
| TB_FX_MenuItemInfo 행 수 | 2 |
| TB_FX_ProgramInfo 행 수 | 2 |
| TB_FX_Favorite 행 수 | 9 |
| 코드상 권한 분기 | 추출되지 않음 |
| C/U/D 엔드포인트 | 없음 (조회만 존재) |

- 그룹별 C/R/U/D 플래그 값은 Fact Pack에 없습니다(행 수만 있음). 원문 CSV `dbmeta_dbo_TB_FX_GroupMenuAuth.csv` 확인이 필요합니다.

## 5. 미확정 사항

1. `btnMeasure_Click`, `btnItemId_Click`, `SpdMain_TopChange`의 내부 동작
2. `clbDivision`을 비활성(`Enabled=false`) 상태로 두는 정책, 그리고 `NowGroupID` 기반 기본 Division 설정 방식
3. `clbPlantSite`, `cboInventoryType`의 데이터 출처
4. `FindData_Main`:386~390 파라미터와 SP 인자 매핑
5. `GetDivision`, `GetDayRange`, `dtInventoryStatus`(진입점 미연결)의 실사용 여부
6. Grid 컬럼 표시 순서, 합계 대상 컬럼, 숨김 4개 컬럼의 사유
7. SP 결과셋과 메타 컬럼의 일치 여부 (grid 매칭 미실행)
8. `Inventory Raw(IT & Mobile)` 메타 시트를 폐기할지 여부
9. `usrButton1`(부모 미지정)이 화면에 실제로 배치되는지
10. 라벨 `Valtage` 철자를 유지할지 정정할지
