# SCP0020 Tact Time — 단위테스트

> **근거**: Fact Pack 사실만 썼습니다. 내부 동작이 미추출된 핸들러는 기대결과를 "AS-IS와 동일(**확인 필요**)"로 적었습니다.
> 주석 처리된 호출(commented_calls)은 0건이며, 테스트 케이스로 만들지 않았습니다.
> '절차' 열의 컨트롤명은 화면설계서 §3과 같습니다. '근거' 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5와 화면설계서 §5·§4 원문입니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0020-001 | 초기화 | 메뉴 권한 보유 | 화면 SCP0020 열기 | - | cboValid에 YesOrNo 목록(CODE/NAME)이 바인딩된다 | `Form_Load` > InitControls:218 / `biz:CommonData.YesOrNo` |
| TC-SCP0020-002 | 초기화 | 동일 | 화면 열기 | - | LookupCommon 공통코드 호출이 성공한다(바인딩 대상 컨트롤은 **확인 필요**) | `Form_Load` > InitControls:220 / `biz:CommonData.CommonDataList` [code=LookupCommon] |
| TC-SCP0020-003 | 초기화 | 동일 | 화면 열기 | - | LineByOperation 공통코드 호출이 성공한다(용도 **확인 필요**) | `Form_Load` > DefineProperty:199 / `biz:CommonData.CommonDataList` [code=LineByOperation] |
| TC-SCP0020-004 | 초기화 | 동일 | 화면 열기 후 spdMain 탭과 spdExcept 시트 확인 | - | spdMain에 `Plant`·`Packer` 탭, spdExcept에 `Tact Time Except` 시트가 있다. `Tact Time` 시트는 생성되지 않는다 | CreateSpread:374·377·384 / 시트 `Plant`, `Packer`, `Tact Time Except`, `Tact Time` |
| TC-SCP0020-005 | 초기화 | 동일 | 화면 열기 | - | 필드 초기화(dtValidYN/dtYesOrNo)가 오류 없이 수행된다(실행 시점 **확인 필요**) | `<field:dtValidYN>`:57, `<field:dtYesOrNo>`:58 / `biz:CommonData.YesOrNo` |
| TC-SCP0020-006 | 조회 | 데이터가 있는 조건 | cboDivision, cboOperationGroup 선택 → (Plant 경로) 조회 | Division, Operation Group 유효값 | LineByOperation 재조회 후 `Plant` 시트에 결과가 표시된다 | FindButton > Find_Data > FindData_Main:1041·1067 / `biz:CommonData.CommonDataList` [code=LineByOperation], `SCP.SCP0020_GET_TACT_TIME`, SP `SCP0020_GET_TACT_TIME` / 시트 `Plant` |
| TC-SCP0020-007 | 조회 | 데이터가 있는 조건 | (Packer 경로) 조회 | 동일 | `Packer` 시트에 결과가 표시된다 | FindButton > Find_Data > Find_Packer:980 / `SCP.SCP0020_GET_TACT_TIME_OSP`, SP `SCP0020_GET_TACT_TIME_OSP` / 시트 `Packer` |
| TC-SCP0020-008 | 조회 | 결과가 없는 조건 | Plant 경로로 조회 | 존재하지 않는 Model을 txtItemId에 입력 | `Plant` 시트가 0건으로 표시되고 오류가 없다 | `SCP.SCP0020_GET_TACT_TIME` / 시트 `Plant` |
| TC-SCP0020-009 | 조회 | 결과가 없는 조건 | Packer 경로로 조회 | 동일 | `Packer` 시트가 0건으로 표시되고 오류가 없다 | `SCP.SCP0020_GET_TACT_TIME_OSP` / 시트 `Packer` |
| TC-SCP0020-010 | 조회 | SP 오류를 유도하는 환경 | 조회 실행 | - | 오류 메시지가 표시되고 그리드가 깨지지 않는다(메시지 형식 **확인 필요**) | `SCP.SCP0020_GET_TACT_TIME`, `SCP.SCP0020_GET_TACT_TIME_OSP` |
| TC-SCP0020-011 | 조회 | - | cboDivision을 선택하지 않고 조회 | Division 빈값 | 필수 입력 안내가 나오거나 조회되지 않는다(검증 로직 **확인 필요**, 라벨 `Division*`) | layoutControlItem1 Text `Division*` / `SCP.SCP0020_GET_TACT_TIME` |
| TC-SCP0020-012 | 조회 | - | cboOperationGroup을 선택하지 않고 조회 | Operation Group 빈값 | 필수 입력 안내가 나오거나 조회되지 않는다(**확인 필요**, 라벨 `Operation Group*`) | layoutControlItem5 Text `Operation Group*` / `SCP.SCP0020_GET_TACT_TIME` |
| TC-SCP0020-013 | 조회 | 데이터가 있음 | txtItemId에 여러 줄 Model 입력 → 조회 | Model 2건(줄바꿈) | 입력한 Model만 조회된다(파라미터 형식 **확인 필요**) | txtItemId(UsrMultiLineEditor) / `SCP.SCP0020_GET_TACT_TIME` / SP `SCP0020_GET_TACT_TIME` |
| TC-SCP0020-014 | 조회 | 데이터가 있음 | cboValid 선택 → 조회 | Valid = Y / N | 선택값에 맞는 결과가 나온다(**확인 필요**) | cboValid / `biz:CommonData.YesOrNo`, `SCP.SCP0020_GET_TACT_TIME` |
| TC-SCP0020-015 | 조회 | 데이터가 있음 | clbPlantSite·clbLine 다중 선택 → 조회 | Plant Site 2건, Line 2건 | 선택한 사이트·라인만 조회된다(**확인 필요**) | clbPlantSite, clbLine / `SCP.SCP0020_GET_TACT_TIME_OSP` |
| TC-SCP0020-016 | 이벤트 | 화면 열림 | btnItemId 클릭 | - | txtItemId.Text에 sItemId 값이 설정된다(팝업 여부 **확인 필요**) | `btnItemId_Click`:2560 |
| TC-SCP0020-017 | 이벤트 | 화면 열림 | cboDivision 값 변경 | Division A → B | AS-IS와 같이 동작한다(Plant Site 갱신 가능성 있음, 내부 동작 **확인 필요**) | `ClbDivision_SelectedIndexChanged` (InitEvent:460) |
| TC-SCP0020-018 | 이벤트 | Division 선택됨 | clbPlantSite 선택 변경 | Plant Site 체크 변경 | AS-IS와 같이 동작한다(Line 갱신 가능성 있음, 내부 동작 **확인 필요**) | `ClbPlantSite_SelectedIndexChanged` (InitEvent:461) |
| TC-SCP0020-019 | 이벤트 | `Packer` 조회 결과 있음 | spdMain `Packer` 행 더블클릭 | 대상 행 1건 | spdExcept `Tact Time Except`에 OSP 예외 데이터가 표시된다(분기 조건 **확인 필요**) | `SpdMain_CellDoubleClick` > FindData_Except_Packer:1321 / `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP`, SP `SCP0020_GET_TACT_TIME_EXCEPT_OSP` / 시트 `Tact Time Except` |
| TC-SCP0020-020 | 이벤트 | `Plant` 조회 결과 있음 | spdMain `Plant` 행 더블클릭 | 대상 행 1건 | spdExcept `Tact Time Except`에 예외 데이터가 표시된다 | `SpdMain_CellDoubleClick` > FindData_Except:1397 / `SCP.SCP0020_GET_TACT_TIME_EXCEPT`, SP `SCP0020_GET_TACT_TIME_EXCEPT` / 시트 `Tact Time Except` |
| TC-SCP0020-021 | 이벤트 | 예외 데이터가 없는 행 | spdMain 행 더블클릭 | 예외 없는 모델 행 | spdExcept가 0건으로 표시되고 오류가 없다 | `SpdMain_CellDoubleClick` / `SCP.SCP0020_GET_TACT_TIME_EXCEPT`, `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` |
| TC-SCP0020-022 | 이벤트 | `Plant` 활성, 잠금 아님 | spdMain LINE_ID 셀 클릭 | - | LINE_ID 셀이 Line 콤보로 바뀐다(division·FACTORY_ID 필터 데이터) | `SpdMain_CellClick`:2583 / 시트 `Plant` |
| TC-SCP0020-023 | 이벤트 | `Plant` 활성 | spdMain의 LINE_ID 외 셀 클릭, 또는 잠금 셀의 LINE_ID 클릭 | - | 콤보가 구성되지 않는다 | `SpdMain_CellClick`:2583 조건(IsLock("Plant")=false, IsLockCell=false, e.Column==LINE_ID) / 시트 `Plant` |
| TC-SCP0020-024 | 이벤트 | `Plant` 또는 `Packer` 활성, 잠금 아님, 행 1건 이상 | spdMain LINE_ID 열에 값 붙여넣기 | 유효한 Line 코드 2건 | 붙여넣은 LINE_ID 셀에 Line 콤보(dtLine)가 적용된다 | `SpdMain_ClipboardPasted`:2769~2773 / 시트 `Plant`, `Packer` |
| TC-SCP0020-025 | 이벤트 | 화면 열림 | spdMain 탭을 `Plant`로 전환 | - | shtMain으로 ChangeSheet/ChangeActiveSheet가 적용되고, spdExcept에서 OPERATION_NAME 표시·DAILY_CAPACITY 숨김(초기화 시점 **확인 필요**) | `SpdMain_ActiveSheetChanged`:2792~2793 / 시트 `Plant`, `Tact Time Except` |
| TC-SCP0020-026 | 이벤트 | 화면 열림 | spdMain 탭을 `Packer`로 전환 | - | shtPacker로 ChangeSheet/ChangeActiveSheet가 적용된다 | `SpdMain_ActiveSheetChanged`:2799~2800 / 시트 `Packer` |
| TC-SCP0020-027 | 이벤트 | spdMain 다건 조회 | spdMain 세로 스크롤 | - | AS-IS와 같이 동작한다(내부 동작 **확인 필요**) | `SpdMain_TopChange` (InitEvent:464) |
| TC-SCP0020-028 | 이벤트 | spdExcept 다건 조회 | spdExcept 세로 스크롤 | - | AS-IS와 같이 동작한다(**확인 필요**) | `SpdExcept_TopChange` (InitEvent:467) |
| TC-SCP0020-029 | 이벤트 | spdMain 편집 중 | spdMain 셀 편집 후 편집 모드 종료 | 임의 값 | AS-IS와 같이 동작한다(**확인 필요**) | `SpdMain_EditModeOff` (Designer:505) |
| TC-SCP0020-030 | 이벤트 | spdMain 편집 중 | spdMain 셀 값 입력 | 임의 값 | AS-IS와 같이 동작한다(**확인 필요**) | `SpdMain_EditChange` (Designer:506) |
| TC-SCP0020-031 | 이벤트 | spdExcept 편집 중 | spdExcept 셀 편집 후 종료 | 임의 값 | AS-IS와 같이 동작한다(**확인 필요**) | `spdExcept_EditModeOff` (Designer:558) |
| TC-SCP0020-032 | 이벤트 | spdExcept 편집 중 | spdExcept 셀 값 입력 | 임의 값 | AS-IS와 같이 동작한다(**확인 필요**) | `spdExcept_EditChange` (Designer:559) |
| TC-SCP0020-033 | 이벤트 | `Plant` 조회됨 | spdMain `Plant` 셀 값 변경 | 임의 값 | 변경 행 상태가 반영된다(내부 동작 **확인 필요**) | `SpdMain_Changed` (dsdmMain, InitEvent:471) / 시트 `Plant` |
| TC-SCP0020-034 | 이벤트 | `Packer` 조회됨 | spdMain `Packer` 셀 값 변경 | 임의 값 | 변경 행 상태가 반영된다(**확인 필요**) | `SpdMain_Changed_Packer` (dsdmMainPacker, InitEvent:474) / 시트 `Packer` |
| TC-SCP0020-035 | 이벤트 | `Tact Time Except` 조회됨 | spdExcept 셀 값 변경 | 임의 값 | 변경 행 상태가 반영된다(**확인 필요**) | `SpdExcept_Changed` (dsdmExcept, InitEvent:482) / 시트 `Tact Time Except` |
| TC-SCP0020-036 | 그리드 | `Plant` 조회됨 | spdMain `Plant` 헤더 확인 | - | 표시 23개(Actual Capacity … Yield(%)*), 숨김 10개(ACTUAL_OUTPUT, EFFECTIVE_DATA_COUNT, EXCEPT_YN, FROM_ACTUAL_CAPACITY, INPUT_STATUS, OPERATION_GROUP_ID, OPERATION_ID, PLANT_SITE_ID, TO_ACTUAL_CAPACITY, VALID_YN) | SetSpreadInit:438 / 시트 `Plant` / `SCP.SCP0020_GET_TACT_TIME` |
| TC-SCP0020-037 | 그리드 | `Packer` 조회됨 | spdMain `Packer` 헤더 확인 | - | 표시 14개(Created By, Creation Date, Daily Capacity*, Division*, Model*, Last Update Date, Last Updated By, Line*, Nick Name, OSP_YN, Priority*, Plant Site*, Tact Time*, Yield(%)*), 숨김 4개(EXCEPT_YN, INPUT_STATUS, OPERATION_ID, PLANT_SITE_ID) | SetSpreadInit:449 / 시트 `Packer` / `SCP.SCP0020_GET_TACT_TIME_OSP` |
| TC-SCP0020-038 | 그리드 | spdMain `Plant` 활성 | spdExcept `Tact Time Except` 헤더 확인 | - | 표시 16개. OPERATION_NAME(Operation) 표시, DAILY_CAPACITY 숨김 | InitSpread:410·411 / 시트 `Tact Time Except`, `Plant` / `SCP.SCP0020_GET_TACT_TIME_EXCEPT` |
| TC-SCP0020-039 | 그리드 | spdMain `Packer` 활성 | spdExcept `Tact Time Except` 헤더 확인 | - | 표시 16개. DAILY_CAPACITY(Daily Capacity) 표시, OPERATION_NAME 숨김 | InitSpread:415·416 / 시트 `Tact Time Except`, `Packer` / `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` |
| TC-SCP0020-040 | 그리드 | 화면 열림 | 메타 시트 `Tact Time` 노출 여부 확인 | - | `Tact Time` 탭과 그리드가 표시되지 않는다(메타 33행은 코드 미참조, 폐기 여부 **확인 필요**) | 시트 `Tact Time` (Fact Pack §12 "메타 정의만, 코드 미참조") |
| TC-SCP0020-041 | 그리드 | `Packer` 활성, 잠금 아님 | InsertButton 클릭 | - | 새 행이 추가되고 LINE_ID 셀이 콤보(dtComboIns)가 된다 | InsertButton:859~864 / 시트 `Packer` |
| TC-SCP0020-042 | 그리드 | `Packer`(인덱스 1) 조회됨 | EditButton 클릭 | INPUT_STATUS="I" 행 | 조건에 맞는 행의 LINE_ID에 콤보가 적용된다(`GetText("0", …)` 행 지정 원문의 의도 **확인 필요**) | EditButton:607·636~641 / 시트 `Packer` |
| TC-SCP0020-043 | 저장 | `Plant` 행 수정 | spdMain `Plant` 값 수정 → 저장 | TACT_TIME, YIELD, PRIORITY 변경 | 저장에 성공하고 `Plant`가 다시 조회된다. SCP_MST_TACT_TIME·_H에 반영된다 | SaveButton > SaveData_Main:1797·1874 / `SCP.SCP0020_SAVE_TACT_TIME`, SP `SCP0020_SAVE_TACT_TIME` → `SCP.SCP0020_GET_TACT_TIME` / 시트 `Plant` |
| TC-SCP0020-044 | 저장 | `Packer` 행 추가 | InsertButton → 값 입력 → 저장 | 필수(* 컬럼) 입력 | 저장에 성공하고 `Packer`가 다시 조회된다. SCP_MST_TACT_TIME_OSP·_H에 반영된다 | SaveButton > SaveData_Packer:1560·1622 / `SCP.SCP0020_SAVE_TACT_TIME_OSP`, SP `SCP0020_SAVE_TACT_TIME_OSP` → `SCP.SCP0020_GET_TACT_TIME_OSP` / 시트 `Packer` |
| TC-SCP0020-045 | 저장 | Packer 행 더블클릭으로 하단 조회됨 | spdExcept 행 추가·수정 → 저장 | Start Date*, End Date*, Tact Time*, Yield(%)* | 저장에 성공하고 하단이 다시 조회된다. SCP_MST_TACT_TIME_EXCEPT_OSP·_H에 반영된다 | SaveButton > SaveData_Except_Packer:2023·2094 / `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP`, SP `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` → `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` / 시트 `Tact Time Except` |
| TC-SCP0020-046 | 저장 | Plant 행 더블클릭으로 하단 조회됨 | spdExcept 행 추가·수정 → 저장 | 동일 | 저장에 성공하고 하단이 다시 조회된다. SCP_MST_TACT_TIME_EXCEPT·_H에 반영된다 | SaveButton > SaveData_Except:2227·2297 / `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT`, SP `SCP0020_SAVE_TACT_TIME_EXCEPT` → `SCP.SCP0020_GET_TACT_TIME_EXCEPT` / 시트 `Tact Time Except` |
| TC-SCP0020-047 | 저장 | 저장 SP가 ERR_MESSAGE를 돌려주는 데이터 | 저장 실행 | 필수값 누락 또는 중복 키 | ERR_MESSAGE 내용이 표시되고 재조회로 덮어쓰지 않는다(판정 조건·메시지 ID **확인 필요**) | SaveData_Packer:1622, SaveData_Main:1874, SaveData_Except_Packer:2094, SaveData_Except:2297 / `SCP.SCP0020_SAVE_TACT_TIME`, `SCP.SCP0020_SAVE_TACT_TIME_OSP`, `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT`, `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` |
| TC-SCP0020-048 | 저장 | `Plant` 행 삭제 상태(삭제 방식 **확인 필요**) | 저장 | 예외 데이터가 있는 모델 행 | SCP_MST_TACT_TIME과 SCP_MST_TACT_TIME_EXCEPT의 DELETE·_H 이력이 AS-IS와 같다(**확인 필요**) | `SCP.SCP0020_SAVE_TACT_TIME`, SP `SCP0020_SAVE_TACT_TIME`(DELETE:SCP_MST_TACT_TIME, DELETE:SCP_MST_TACT_TIME_EXCEPT) / 시트 `Plant` |
| TC-SCP0020-049 | 권한 | 조회 전용 그룹 사용자(TB_FX_GroupMenuAuth) | 화면 열기 | - | 권한에 맞게 Save/Insert/Edit 버튼이 노출·제한된다(C/R/U/D 값 **확인 필요**) | TB_FX_GroupMenuAuth 13행 / `SCP.SCP0020_SAVE_TACT_TIME` |
| TC-SCP0020-050 | 권한 | spdMain 시트 잠금 상태(IsLock=true) | LINE_ID 셀 클릭, 붙여넣기, InsertButton 실행 | - | LINE_ID 콤보가 적용되지 않는다 | `SpdMain_CellClick`:2583, `SpdMain_ClipboardPasted`:2773, InsertButton:864 / 시트 `Plant`, `Packer` |
| TC-SCP0020-051 | division | division 14종 각각 로그인(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) | 각 division에서 조회 후 헤더 수 확인 | - | 모든 division에서 `Packer` 14, `Plant` 23, `Tact Time Except` 16으로 같다(division 변형 없음) | Fact Pack §12 / 시트 `Packer`, `Plant`, `Tact Time Except` / `SCP.SCP0020_GET_TACT_TIME`, `SCP.SCP0020_GET_TACT_TIME_OSP` |
| TC-SCP0020-052 | division | `Plant` 활성, 서로 다른 division 데이터 | 각 division 행의 LINE_ID 셀 클릭 | Division A 행 / Division B 행 | 콤보 목록이 해당 행의 DIVISION_ID·FACTORY_ID로 필터된 Line만 보여 준다 | `SpdMain_CellClick`:2583(DBUtils.Filter DIVISION_ID/FACTORY_ID) / `biz:CommonData.CommonDataList` [code=LineByOperation] / 시트 `Plant` |

### 커버리지 점검

| 대상 | 항목 | 커버 TC |
|---|---|---|
| 엔드포인트 | `biz:CommonData.YesOrNo` | 001, 005, 014 |
| | `biz:CommonData.CommonDataList` | 002(LookupCommon), 003·006·052(LineByOperation) |
| | `SCP.SCP0020_GET_TACT_TIME_OSP` | 007, 009, 010, 015, 037, 044, 051 |
| | `SCP.SCP0020_GET_TACT_TIME` | 006, 008, 010~014, 036, 043, 051 |
| | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` | 019, 021, 039, 045 |
| | `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | 020, 021, 038, 046 |
| | `SCP.SCP0020_SAVE_TACT_TIME_OSP` | 044, 047 |
| | `SCP.SCP0020_SAVE_TACT_TIME` | 043, 047, 048, 049 |
| | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` | 045, 047 |
| | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` | 046, 047 |
| 이벤트 핸들러(17) | `btnItemId_Click` 016 · `SpdMain_EditModeOff` 029 · `SpdMain_EditChange` 030 · `spdExcept_EditModeOff` 031 · `spdExcept_EditChange` 032 · `Form_Load` 001~003 · `ClbDivision_SelectedIndexChanged` 017 · `ClbPlantSite_SelectedIndexChanged` 018 · `SpdMain_CellDoubleClick` 019~021 · `SpdMain_TopChange` 027 · `SpdMain_CellClick` 022·023·050·052 · `SpdExcept_TopChange` 028 · `SpdMain_Changed` 033 · `SpdMain_Changed_Packer` 034 · `SpdMain_ClipboardPasted` 024·050 · `SpdMain_ActiveSheetChanged` 025·026 · `SpdExcept_Changed` 035 | 전부 커버 |
| 시트(4) | `Packer` 037 · `Plant` 036 · `Tact Time` 040 · `Tact Time Except` 038·039 | 전부 커버 |
| 빈 결과 / 오류 | 008, 009, 021 / 010, 047 | 포함 |
