# SSP0025 Web 컴포넌트 매핑 (As-is → React/Wijmo)

## 1. 메인 화면 컨트롤 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | LayoutItem | 크기 | React/Wijmo 후보 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Div*` | Division | 128x20 | 단일선택 ComboBox (필수 표시) |
| clbFromSite | UsrCheckedList | `Plant Site` | layoutToSite | 140x21 | 다중선택 MultiSelect (체크리스트) |
| txtItemId | UsrMultiLineEditor | `Material` | lblItemId | 151x21 | 멀티라인 입력(여러 값) |
| btnItemId | UsrButton | `layoutControlItem2` (LayoutItem 기본 Text, 화면 표시 여부 **확인 필요**) | layoutControlItem4 | 39x24 | 팝업 호출 버튼 → Item by Division 팝업 |
| txtModelId | UsrMultiLineEditor | `Model` | lblModelId | 162x21 | 멀티라인 입력(여러 값) |
| btnModelId | UsrButton | `layoutControlItem2` (위와 같음) | layoutControlItem1 | 39x24 | 팝업 호출 버튼 → Item by Division 팝업 |
| txtNickName | TextBox | `Nick Name` | layoutNickName | 135x24 | 단일 텍스트 입력 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Shipment Requestor PIC` | - | 1192x608 | Wijmo FlexGrid (편집 가능) |
| usrButton1 | UsrButton | - | 없음(parent 없음) | 75x23 | 사용 여부 **확인 필요** |
| imageList1 | ImageList | - | - | - | 이미지 셀(cellTypeImage)과의 관련 여부 **확인 필요** |
| usrConditionPanel1 | UsrConditionPanel | - | - | 1192x41, HidePanel | 조회조건 패널 |
| emptySpaceItem2 | EmptySpaceItem | - | - | 122x28 | 여백 |
| (프레임워크) | 버튼 | FindButton / SaveButton / EditButton | - | - | 공통 버튼 바(조회/저장/편집). 행 추가는 InsertRow(진입 버튼 **확인 필요**) |

## 2. 팝업(`SSP0025_ItembyDivisionPopup`, 제목 `Item by DivisionPopup`) 컨트롤 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | LayoutItem | 크기 | 초기 상태 | React/Wijmo 후보 |
|---|---|---|---|---|---|---|
| clbDivisionId | UsrCheckedList | `Division` | lblDivision | 141x21 | Enabled=false | 읽기전용 MultiSelect |
| clbFromSiteId | UsrCheckedList | `From Site` | lblFromSite | 147x21 | Enabled=true | MultiSelect |
| txtItemId | UsrMultiLineEditor | `Material` | lbItemId | 150x21 | Text=sItemId | 멀티라인 입력 |
| txtModelId | UsrMultiLineEditor | `Model` | lbModelId | 169x21 | Text=sModelId | 멀티라인 입력 |
| btnButtonList | UsrButtonList | - | layoutControlItem1 | 105x26 | - | 팝업 내 조회 버튼 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Project` | - | 985x524 | - | Wijmo FlexGrid (조회 전용, 더블클릭 동작 **확인 필요**) |
| usrLayoutControl1 / layoutControlGroup1 | UsrLayoutControl | - | - | 657x184, Dock Fill | - | 용도 **확인 필요** |
| emptySpaceItem1 | EmptySpaceItem | - | - | 35x30 | - | 여백 |

## 3. 화면 배치

props.csv에는 SplitContainer(Orientation·SplitterDistance)가 **없습니다**. 따라서 좌/우 분할은 없고 Dock Top + Dock Fill의 상/하 2단 구성입니다.

| 화면 | 상단 (Dock Top) | 하단 (Dock Fill) | 높이 비율(Size 기준) |
|---|---|---|---|
| 메인 | usrConditionPanel1 1192x41 | spdMain 1192x608 | 상 41 : 하 608 (≈ 6.3% : 93.7%) |
| 팝업 | usrConditionPanel1 985x50 | spdMain 985x524 | 상 50 : 하 524 (≈ 8.7% : 91.3%) |

조회조건 배치 순서(LayoutItem 기준): Div* → Plant Site → Material(+버튼) → Model(+버튼) → Nick Name. LayoutControl 안의 실제 좌표 순서는 Fact Pack에 Location이 없어 **확인 필요**입니다.

## 4. 시트별 Grid 컬럼

### 4-1. 시트 `Shipment Requestor PIC` (메인, META+코드연결)

메타 SCM_MST_SHEET_COLUMNS 19행은 모두 '기본'입니다. 14개 division의 차이는 없습니다. 메타의 순서(COLUMN 순번)와 폭은 grid_effective에 없어 **확인 필요**입니다(아래 표는 grid_effective의 행 순서).

| # | COLUMN_NAME | 라벨(메타) | 출처 | 코드 추가 처리 |
|---:|---|---|---|---|
| 1 | CELL_TYPE | Cell Type | META | - |
| 2 | CREATED_BY | Created By | META | - |
| 3 | CREATION_DATE | Creation Date | META | - |
| 4 | DIVISION_ID | Division | META | InsertRow:318 신규 행 콤보(MyDivision) |
| 5 | ELECTRODE_TYPE | Electrode Type | META | - |
| 6 | ITEM_ID | Material* | META | - |
| 7 | LAST_UPDATE_DATE | Last Update Date | META | - |
| 8 | LAST_UPDATED_BY | Last Updated By | META | - |
| 9 | MODEL_ID | Model | META | - |
| 10 | NICK_NAME | Nick Name | META | - |
| 11 | PART_LEADER | Part Leader | META | - |
| 12 | PART_LEADER_NAME | Part Leader Name | META | - |
| 13 | SITE_DESCRIPTION | Plant Site* | META | InsertRow:320 / SpdMain_CellClick:640 신규 행 콤보(PlantCell) |
| 14 | TEAM_LEADER | Team Leader | META | - |
| 15 | TEAM_LEADER_NAME | Team Leader Name | META | - |
| 16 | TO_SITE | Plant Site Code | META | - |
| 17 | USER_ID | User ID* | META | - |
| 18 | USER_NAME | User Name | META | - |
| 19 | VALID_YN | Valid* | META | 콤보 원천(dtYesOrNo 여부) **확인 필요** |

추가 처리: InitSpread:162~164에서 3개 컬럼에 `cellTypeImage`를 적용합니다. 대상 컬럼은 **확인 필요**입니다. 헤더 스타일은 General 정렬, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`입니다(Designer:499~502).

### 4-2. 시트 `Project` (팝업, 코드 하드코딩 전용)

| # | 필드 | 헤더 | 유형 | 폭 | 표시 | 가로 정렬 |
|---:|---|---|---|---:|---|---|
| 1 | DIVISION_ID | division | Text | 60 | true | Center |
| 2 | DIVISION_NAME | division | Text | 80 | **false (숨김)** | 미지정 |
| 3 | FROM_SITE_CODE | From Site Code | Text | 70 | true | 미지정 |
| 4 | FROM_SITE | From Site | Text | 150 | true | Left |
| 5 | ITEM_ID | Material | Text | 100 | true | Center |
| 6 | MODEL_ID | Model | Text | 100 | true | Center |
| 7 | CELL_TYPE | Cell Type | Text | 80 | true | Center |
| 8 | NICK_NAME | Nick Name | Text | 100 | true | Left |
| 9 | ELECTRODE_TYPE | Electrode Type | Text | 80 | true | Center |
| 10 | ITEM_UOM | UOM | Text | 60 | true | Center |
| 11 | UOM_CONVERT_IN_TACT_TIME | Pancake (m/cell) | Num(FixedPoint, 소수 5자리) | 120 | true | 미지정 |

모든 컬럼은 Merge=None입니다. 세로 정렬은 지정된 컬럼에서 Center입니다. grid_effective는 11컬럼을 '코드추가'로 셉니다. 이 중 DIVISION_NAME은 숨김이므로 실제 표시 컬럼은 10개입니다. division별 차이는 없습니다.

## 5. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| Shipment Requestor PIC | META+코드연결 | 코드가 `AddSheet`(146)로 메타 시트명을 사용합니다. `SetSheetHeaderColumn`(159)이 메타로 컬럼을 만들고, 코드는 셀 유형(이미지·콤보)만 덮어씁니다 |
| Project | 코드 하드코딩 전용(메타 없음) | 팝업 InitSpread에서 Add*Column으로 직접 구성합니다. SCM_MST_SHEET_COLUMNS에는 해당 시트가 없습니다 |

- 메인 시트와 팝업 시트는 그리드끼리 연결되지 않습니다(마스터-디테일 아님). 연결은 팝업에서 고른 ItemId/ModelId를 메인 조회조건 txtItemId/txtModelId에 넣는 방식입니다(btnItemId_Click:718, btnModelId_Click:736).
