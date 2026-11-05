# SCP0020 TO-BE 설계 입력 (사실 기반)

## 1. 조회조건 (컨트롤 기준)

| 순번(추정) | 조건 라벨(원문) | AS-IS 컨트롤 | 유형 | 필수 | 연동 |
|---:|---|---|---|---|---|
| - | `Division*` | cboDivision | 단일 콤보 | Y(라벨 *) | `ClbDivision_SelectedIndexChanged` → Plant Site 갱신 가능성(RefreshPlantSiteByDivision:292). 연결은 **확인 필요** |
| - | `Plant Site` | clbPlantSite | 멀티 체크리스트 | - | `ClbPlantSite_SelectedIndexChanged` → Line 갱신 가능성(RefreshLineByPlantPacker:327). 연결은 **확인 필요** |
| - | `Operation Group*` | cboOperationGroup | 단일 콤보 | Y(라벨 *) | Line 갱신 가능성(RefreshLineByOperation:301). **확인 필요** |
| - | `Line` | clbLine | 멀티 체크리스트 | - | LineByOperation 공통코드 관련 가능성. **확인 필요** |
| - | `Model` | txtItemId (+btnItemId) | 멀티라인 입력 + 버튼 | - | `btnItemId_Click` → txtItemId 값 설정 |
| - | `Valid` | cboValid | 단일 콤보 | - | `biz:CommonData.YesOrNo` |

- 조건의 표시 순서는 Location이 추출되지 않아 **확인 필요**입니다.
- SCP 화면은 TO-BE 기준표(search_cond.csv) 정의를 따라야 합니다. 그 기준표와 대조하는 작업은 이 문서 범위 밖입니다(**확인 필요**).
- TB_FX_SearchCondition에 255행이 있습니다(저장된 조회조건). 내용은 **확인 필요**입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | 조건(사실) | 호출 API 후보(TO-BE) |
|---|---|---|---|
| 화면 진입 | `Form_Load` | - | 공통코드: YesOrNo(Valid 콤보), CommonDataList LookupCommon, CommonDataList LineByOperation |
| 조회 | FindButton → Find_Data | Packer 시트 | `SCP0020_GET_TACT_TIME_OSP` |
| 조회 | FindButton → Find_Data | Plant 시트 | `SCP0020_GET_TACT_TIME` (+ LineByOperation 재조회 1041) |
| 상단 행 더블클릭 | `SpdMain_CellDoubleClick` | Packer 계열 | `SCP0020_GET_TACT_TIME_EXCEPT_OSP` → 하단 Except 그리드 |
| 상단 행 더블클릭 | `SpdMain_CellDoubleClick` | Plant 계열 | `SCP0020_GET_TACT_TIME_EXCEPT` → 하단 Except 그리드 |
| 저장 | SaveButton → SaveData_Packer | Packer | `SCP0020_SAVE_TACT_TIME_OSP` → 재조회 `SCP0020_GET_TACT_TIME_OSP` |
| 저장 | SaveButton → SaveData_Main | Plant | `SCP0020_SAVE_TACT_TIME` → 재조회 `SCP0020_GET_TACT_TIME` |
| 저장 | SaveButton → SaveData_Except_Packer | Except(Packer) | `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` → 재조회 `SCP0020_GET_TACT_TIME_EXCEPT_OSP` |
| 저장 | SaveButton → SaveData_Except | Except(Plant) | `SCP0020_SAVE_TACT_TIME_EXCEPT` → 재조회 `SCP0020_GET_TACT_TIME_EXCEPT` |
| 행 추가 | InsertButton | Packer 시트일 때 LINE_ID 셀 콤보(864) | 클라이언트 처리 + 콤보 데이터 |
| 편집 | EditButton | INPUT_STATUS == "I" 행의 LINE_ID 셀 콤보(641) | 클라이언트 처리 |
| 셀 클릭 | `SpdMain_CellClick` | Plant 시트 LINE_ID, 잠금 아님 | LineByOperation 데이터(division·FACTORY_ID·OP 필터) |
| 붙여넣기 | `SpdMain_ClipboardPasted` | LINE_ID 범위 | LINE 콤보 데이터 재적용 |
| 시트 전환 | `SpdMain_ActiveSheetChanged` | Plant ↔ Packer | 시트 정보 전환. 하단 Except 컬럼 표시 규칙(DAILY_CAPACITY/OPERATION_NAME) 재적용 |

- 액션별로 어떤 SP를 고르는지(Packer/Plant, Except Packer/Except)의 분기 조건 원문은 **확인 필요**입니다. 위 "조건"은 메서드명과 시트명으로 대응시킨 것입니다.
- 저장 SP 4종은 `ERR_MESSAGE`를 돌려줍니다. 이 값을 성공·실패 판정과 메시지 표시에 써야 합니다.

## 3. Division별 Grid 변형 요약

| 시트 | 표시 컬럼 수 | division 차이 | 코드 변형 |
|---|---:|---|---|
| Plant (상단 탭 1) | 23 | 없음(14종 동일) | LINE_ID 셀 콤보 |
| Packer (상단 탭 2) | 14 | 없음 | LINE_ID 셀 콤보(Insert) |
| Tact Time Except (하단) | 16 | 없음 | 상단 Plant 활성 시 OPERATION_NAME 표시·DAILY_CAPACITY 숨김, Packer 활성 시 반대 |
| Tact Time | 23 | 없음 | 코드 미참조. 구현 제외 후보(**확인 필요**) |

- division에 따른 Grid 분기는 메타와 코드 어디에도 없습니다.

## 4. 권한(C/R/U/D) 관련 사실
- `TB_FX_GroupMenuAuth`에 SCP0020 관련 행이 13개 있습니다. 그룹별 C/R/U/D 값은 Fact Pack에 없어 **확인 필요**입니다.
- 코드에서 확인된 공통 버튼은 FindButton(조회), SaveButton(저장), InsertButton(추가), EditButton(편집)입니다. Delete 계열 버튼은 Fact Pack에 없습니다(**확인 필요**).
- 저장 SP 중 `SCP0020_SAVE_TACT_TIME`에는 DELETE:SCP_MST_TACT_TIME이, EXCEPT 계열 저장 SP에는 DELETE:A가 있습니다. 즉 저장 SP 안에서 삭제가 일어납니다. 이것이 행 삭제 상태(INPUT_STATUS 등)로 일어나는지는 **확인 필요**입니다.
- 그리드 편집 잠금 판정에 `siMain.IsLock("Plant")`, `siMain.IsLockCell(...)`, `siMain.IsLock(siMain.SheetName)`이 쓰입니다(2583·864·2773줄). 잠금 기준이 권한인지 상태인지는 **확인 필요**입니다.

## 5. 미확정 사항

| # | 항목 |
|---:|---|
| 1 | 조회·저장·더블클릭의 Packer/Plant 분기 조건 원문 |
| 2 | 조회조건 컨트롤의 배치 순서와 각 콤보의 데이터 원천(cboDivision, cboOperationGroup, clbLine, clbPlantSite) |
| 3 | `btnItemId_Click`의 Model 선택 방식(팝업 여부) |
| 4 | 내부 동작이 미추출된 이벤트 핸들러 11개: `SpdMain_EditModeOff`, `SpdMain_EditChange`, `spdExcept_EditModeOff`, `spdExcept_EditChange`, `ClbDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged`, `SpdMain_TopChange`, `SpdExcept_TopChange`, `SpdMain_Changed`, `SpdMain_Changed_Packer`, `SpdExcept_Changed` |
| 5 | `Tact Time` 메타 시트 폐기 여부 |
| 6 | grid_effective의 Packer OPERATION_NAME(CODE_ONLY_CHANGE) 귀속 오류 여부 |
| 7 | 권한 13행의 C/R/U/D 값과 Delete 버튼 유무 |
| 8 | 그리드 컬럼 표시 순서(메타 정렬 컬럼 원문) |
| 9 | 실제 SP 실행 결과와 시트 매칭(grid 단계 미실행) |
| 10 | 저장 SP 내부 PR(`PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `PR_SCP_MST_TACT_TIME_HIST`)이 Oracle에 있는지 |
