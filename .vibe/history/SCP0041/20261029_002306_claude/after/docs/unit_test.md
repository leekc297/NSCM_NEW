# SCP0041 단위테스트 케이스

> 컨트롤명은 화면설계서 §3, 엔드포인트는 업무분석서 §5와 화면설계서 §5와 같은 이름을 씁니다. Fact Pack에 없는 기대값은 "확인 필요"로 적었습니다. 주석 처리된 호출은 0건이라 대상이 없습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0041-001 | 초기화 | 사용자 로그인, 메뉴 권한 있음 | 화면을 연다 | - | `SCM.SCM0001_GET_LOOKUP_VALUES` 1회 호출, 룩업 값 로드(바인딩 컨트롤 확인 필요) | `Form_Load` > GetLookupData:165 / `SCM.SCM0001_GET_LOOKUP_VALUES` / SP `SCM0001_GET_LOOKUP_VALUES` |
| TC-SCP0041-002 | 초기화 | 공통데이터 PERIOD_DEFAULT 존재 | 화면을 열고 `dCalendar`·`dCalendarCutoff` 값을 확인한다 | - | 기간 컨트롤에 PERIOD_DEFAULT 결과 1행의 FROM_VALUE~TO_VALUE가 설정됨(적용 대상 확인 필요) | `Form_Load` > setPeriod:549 / `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] |
| TC-SCP0041-003 | 초기화 | - | 화면을 열고 `spdMain`의 활성 탭을 확인한다 | - | 탭 `Osp Stock`, `Pack Hold Stock` 2개가 보이고 활성 탭은 `Osp Stock` | InitSpread:195~196 / `Form_Load` / 시트 `Osp Stock`, `Pack Hold Stock` |
| TC-SCP0041-004 | 초기화 | - | 조회조건 라벨을 확인한다 | - | `cboDivision`="Division*", `clbPlantSite`="Plant Site", `txtItemId`="Model", `dCalendar`="Period*", `txtInspection`=DefPackLabel.INSEPECTION_ID 문구(확인 필요), `cboStatus`="Status", `dCalendarCutoff`="Cutoff Date", `btnExcelUpload`="Upload", `formDown`="Excel Form" | props.csv / `Form_Load` |
| TC-SCP0041-005 | 그리드 | 활성 탭 `Osp Stock` | `spdMain` 헤더를 확인한다 | - | 14컬럼: Valuation Type, Cell From Site, Box, Comment, Created By, Creation Date, Division*, Model*, Last Update Date, Last Updated By, Nick Name, Qty*, Plant Site*, Date* (순서는 메타 원문 확인 필요) | 시트 `Osp Stock` / SetSheetHeaderColumn@SetSpreadInit:211 |
| TC-SCP0041-006 | 그리드 | 탭 `Pack Hold Stock` 선택 | `spdMain` 헤더를 확인한다 | - | 15컬럼: Create Date, Cutoff Date, 실제 완료일, 예상 완료일, 예상 시작일, Status, 관리번호, 수정자, Change Date, Nick Name, PLANT, Model, 수량, 변경점 신청자, Plant Site | 시트 `Pack Hold Stock` / SetSheetHeaderColumn@SetSpreadInit:211 |
| TC-SCP0041-007 | 조회 | 활성 탭 `Osp Stock`, 데이터 있음 | `cboDivision` 선택, `clbPlantSite` 체크, `dCalendar` 기간 입력 후 툴바 Find | Division=테스트 Division, Plant Site 1건 이상 | `SCP.SCP0041_GET_STOCK_OSP` 호출, Plant Site는 CODE 값으로 전달, `Osp Stock` 시트에 결과 표시 | FindButton > FindData_Main:662 / `SCP.SCP0041_GET_STOCK_OSP` / SP `SCP0041_GET_STOCK_OSP` / 시트 `Osp Stock` |
| TC-SCP0041-008 | 조회 | 탭 `Pack Hold Stock`, 데이터 있음 | `cboDivision`, `clbPlantSite`, `txtInspection`, `cboStatus`, `dCalendarCutoff` 입력 후 툴바 Find | Inspection·Status·Cutoff 값 | `SCP.SCP0041_GET_PACK_HOLD_STOCK` 호출, `Pack Hold Stock` 시트에 결과 표시 | FindButton > FindData_Pack:740 / `SCP.SCP0041_GET_PACK_HOLD_STOCK` / SP `SCP0041_GET_PACK_HOLD_STOCK` / 시트 `Pack Hold Stock` |
| TC-SCP0041-009 | 조회 | 탭별로 각각 실행 | 툴바 Find 한 번 실행 후 호출된 엔드포인트를 기록한다 | - | 활성 시트 엔드포인트만 호출되는지, 두 엔드포인트가 모두 호출되는지 기록(As-is 기대값 확인 필요) | FindButton / `SCP.SCP0041_GET_STOCK_OSP`, `SCP.SCP0041_GET_PACK_HOLD_STOCK` |
| TC-SCP0041-010 | 조회 | 해당 조건 데이터 없음 | `Osp Stock` 탭에서 결과가 없는 조건으로 Find | 데이터 없는 기간 | 그리드 0행, 오류 없음(빈 결과 메시지 확인 필요) | `SCP.SCP0041_GET_STOCK_OSP` / 시트 `Osp Stock` |
| TC-SCP0041-011 | 조회 | 해당 조건 데이터 없음 | `Pack Hold Stock` 탭에서 결과가 없는 조건으로 Find | 존재하지 않는 `txtInspection` 값 | 그리드 0행, 오류 없음(메시지 확인 필요) | `SCP.SCP0041_GET_PACK_HOLD_STOCK` / 시트 `Pack Hold Stock` |
| TC-SCP0041-012 | 조회 | SP 오류 유도(권한 회수 등) | 툴바 Find | - | 오류 메시지 표시, 그리드 기존 상태 유지(메시지 원문 확인 필요) | `SCP.SCP0041_GET_STOCK_OSP` / `SCP.SCP0041_GET_PACK_HOLD_STOCK` (오류 응답) |
| TC-SCP0041-013 | 조회 | 필수 조회조건 비움 | `cboDivision` 또는 `dCalendar`를 비우고 Find | Division 빈값 / Period 빈값 | 필수값 검증 동작(메시지·차단 여부 확인 필요) | 라벨 `Division*`, `Period*` / FindButton |
| TC-SCP0041-014 | 저장 | `Pack Hold Stock` 조회 완료, 편집 모드 | 셀 값 수정 후 툴바 Save | 수정 행 1건 이상 | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` 호출 → SCM_DNM_STOCK_LOT_CONTROL UPDATE, SCM_SYS_LOG_BATCH 로그 1건 이상 → `SCP.SCP0041_GET_PACK_HOLD_STOCK`로 재조회되어 수정값 표시 | SaveButton > SaveDataPacker:469 > FindData_Pack:740 / SP `SCP0041_SAVE_PACKER_HOLD_STOCK` / 시트 `Pack Hold Stock` |
| TC-SCP0041-015 | 저장 | 저장 SP 오류 유도 | Save | 잘못된 값(검증 대상은 SP 원문 확인 필요) | 오류 메시지 표시, 데이터 변경 없음, 재조회 안 함(확인 필요) | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` (오류 응답) |
| TC-SCP0041-016 | 저장 | 수정 없음 | 아무것도 바꾸지 않고 Save | - | 저장 대상 없음 처리(메시지 확인 필요), UPDATE 0건 | SaveButton / `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` |
| TC-SCP0041-017 | 저장 | 화면의 모든 버튼·탭·툴바 조작 | Find/Save/Edit, 탭 전환, 모든 버튼을 실행하며 호출 로그를 확인한다 | - | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA`(`SCP0040_SAVE_CHARACTERISTIC_CAPA`)가 한 번도 호출되지 않음(미도달 확인용 음성 테스트) | SaveData:354 unreached / `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` |
| TC-SCP0041-018 | 이벤트 | 화면 열림 | `spdMain`에서 `Pack Hold Stock` 탭 클릭 → 다시 `Osp Stock` 탭 클릭 | - | 탭을 클릭할 때마다 `biz:CommonData.CommonDataList`(PERIOD_DEFAULT)가 호출되어 기간 기본값이 다시 설정됨. 조회조건 표시 전환 여부 기록(확인 필요) | `SpdMain_SheetTabClick` > SetSelectMenu > setPeriod:549 / `biz:CommonData.CommonDataList` / 시트 `Osp Stock`, `Pack Hold Stock` |
| TC-SCP0041-019 | 이벤트 | 화면 열림 | `btnItemId` 클릭 → 팝업에서 모델 선택 | 모델 1건 이상 | `txtItemId.Text`에 선택 모델(sItemId)이 들어감 | `BtnItemId_Click` :882 |
| TC-SCP0041-020 | 이벤트 | 화면 열림 | `cboDivision` 값을 바꾼다 | Division A → B | 처리 결과 기록(`clbPlantSite` 목록이 바뀌는지 등 확인 필요), 오류 없음 | `CboDivision_SelectedIndexChanged` (InitEvent:220) |
| TC-SCP0041-021 | 이벤트 | 화면 열림 | `btnExcelUpload` 클릭 → 파일 선택 | 엑셀 양식 파일 | 업로드 처리(대상 시트·저장 SP 확인 필요), 오류 없음 | `btnExcelUpload_Click` (InitializeComponent:380) |
| TC-SCP0041-022 | 이벤트 | 화면 열림 | `formDown` 클릭 | - | 엑셀 양식 파일이 내려받아짐(양식 컬럼 확인 필요) | `btnExcelFormDownload_Click` (InitializeComponent:419) |
| TC-SCP0041-023 | 이벤트 | `Pack Hold Stock` 조회·편집 모드 | `spdMain` 셀에 값을 입력한다(편집 중) | 임의 값 | 편집 중 처리 동작 기록(변경 표시 등 확인 필요) | `SpdMain_EditChange` (InitEvent:223) / 시트 `Pack Hold Stock` |
| TC-SCP0041-024 | 이벤트 | `Pack Hold Stock` 조회·편집 모드 | 셀 값을 바꾸고 포커스를 옮긴다 | 임의 값 | 셀 변경 처리 동작 기록(행 상태 표시 등 확인 필요) | `ActiveSheet_CellChanged` (InitEvent:224) |
| TC-SCP0041-025 | 권한 | 탭 `Pack Hold Stock` (iFocusTabIndex == 1) | 툴바 Edit | - | 편집 모드 진입(GetSheetInfo 수행) | EditButton:268 / 시트 `Pack Hold Stock` |
| TC-SCP0041-026 | 권한 | 탭 `Osp Stock` | 툴바 Edit | - | `iFocusTabIndex == 1` 조건이 아니면 GetSheetInfo를 하지 않음(화면상 결과 확인 필요) | EditButton:268 / 시트 `Osp Stock` |
| TC-SCP0041-027 | 권한 | 조회 전용 권한 그룹 사용자 | 화면을 열고 툴바 버튼 노출을 확인한다 | - | TB_FX_GroupMenuAuth 설정에 따름(기대값 확인 필요) | TB_FX_GroupMenuAuth 9행 / SaveButton / `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` |
| TC-SCP0041-028 | division | Division 40, 81, 82, EE 사용자(또는 선택) | 각 Division으로 `Osp Stock` 조회 | Division=40/81/82/EE | 모든 Division에서 14컬럼 구성이 같음 | grid_effective.csv / 시트 `Osp Stock` / `SCP.SCP0041_GET_STOCK_OSP` |
| TC-SCP0041-029 | division | Division 40, 81, 82, EE | 각 Division으로 `Pack Hold Stock` 조회 | Division=40/81/82/EE | 모든 Division에서 15컬럼 구성이 같음 | grid_effective.csv / 시트 `Pack Hold Stock` / `SCP.SCP0041_GET_PACK_HOLD_STOCK` |
| TC-SCP0041-030 | division | 81 하위(81_HD 등)·EE 하위 Division | 하위 Division으로 두 시트를 조회한다 | Division=81_HD, EE_UC 등 | 컬럼 수 `Osp Stock` 14 / `Pack Hold Stock` 15 그대로 | grid_effective.csv (14개 division 공통) |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001~004 |
| | `SpdMain_SheetTabClick` | 018 |
| | `BtnItemId_Click` | 019 |
| | `CboDivision_SelectedIndexChanged` | 020 |
| | `btnExcelUpload_Click` | 021 |
| | `btnExcelFormDownload_Click` | 022 |
| | `SpdMain_EditChange` | 023 |
| | `ActiveSheet_CellChanged` | 024 |
| 엔드포인트 | `SCM.SCM0001_GET_LOOKUP_VALUES` | 001 |
| | `biz:CommonData.CommonDataList` | 002, 018 |
| | `SCP.SCP0041_GET_STOCK_OSP` | 007, 010, 012, 028 |
| | `SCP.SCP0041_GET_PACK_HOLD_STOCK` | 008, 011, 012, 014, 029 |
| | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` | 014, 015, 016 |
| | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | 017 (미도달 음성 테스트) |
| 시트 | `Osp Stock` | 003, 005, 007, 010, 028 |
| | `Pack Hold Stock` | 003, 006, 008, 011, 014, 029 |
| 빈 결과 / 오류 응답 | | 010, 011 / 012, 015 |
