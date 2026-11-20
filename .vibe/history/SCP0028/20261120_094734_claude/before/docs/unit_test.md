# SCP0028 Shipment Lot Size — 단위테스트

> 근거 열에는 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 메시지 문구와 SP 분기 조건은 Fact Pack에 없으므로, 해당 기대결과는 "AS-IS 실행 결과와 대조"로 적었습니다(**확인 필요**).
> 주석 처리된 호출은 0건이며 테스트 대상에 넣지 않았습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0028-001 | 초기화 | 로그인 상태, 화면 권한 있음 | 메뉴에서 SCP0028 열기 | – | `Form_Load` 실행. `cboValid`에 YesOrNo 목록 바인딩 | `Form_Load` · `biz:CommonData.YesOrNo` (InitControls:135) |
| TC-SCP0028-002 | 초기화 | TC-001과 같음 | 화면 열린 직후 LookupCommon 목록 확인 | – | LookupCommon 목록이 조회됨(바인딩 컨트롤 **확인 필요**, `clbTransMode` 후보) | `Form_Load` · `biz:CommonData.CommonDataList` [code=LookupCommon] (InitControls:137) |
| TC-SCP0028-003 | 초기화 | TC-001과 같음 | 화면 열린 직후 `clbFromSite`, `clbToSite` 목록 확인 | 기본 Division | FromSite와 ToSite 목록이 사용자 그룹(NowGroupID) 기준으로 조회됨 | `Form_Load` · `biz:CommonData.CommonDataList` [code=FromSiteByDivision]·[code=ToSiteByDivision] (SetChangedControl:166/169) |
| TC-SCP0028-004 | 초기화 | TC-001과 같음 | 레이아웃 확인: `usrConditionPanel1` 상단, `usrLayoutControl2` 안의 조회조건, `spdMain` 하단 | – | 상단 조회조건(72)과 하단 그리드(502)가 12.5%:87.5%로 배치됨. 라벨은 `Division*`, `Operation Group`, `From Site`, `Trans Mode`, `To Site`, `Model`, `Valid`. 버튼은 `Input`, `Delete` | `Form_Load` · 시트 `Shipment Lot Size` |
| TC-SCP0028-005 | division | 화면 열림 | `cboDivision`을 다른 Division으로 변경 | Division A → B | `ClbDivision_SelectedIndexChanged` 실행. FromSite와 ToSite 목록이 Division B 기준으로 다시 구성됨 | `ClbDivision_SelectedIndexChanged` · `biz:CommonData.CommonDataList` [code=FromSiteByDivision]·[code=ToSiteByDivision] |
| TC-SCP0028-006 | 권한 | 사용자 그룹이 다른 계정 2개 | 각 계정으로 같은 Division을 선택하고 `clbFromSite`, `clbToSite` 목록 비교 | 그룹 G1, G2 | 목록이 `TB_FX_USERGROUPAUTHEXTENTION`과 NowGroupID 기준으로 그룹별 제한됨 (AS-IS 결과와 대조) | `ClbDivision_SelectedIndexChanged` · `biz:CommonData.CommonDataList` [code=FromSiteByDivision]·[code=ToSiteByDivision] |
| TC-SCP0028-007 | 이벤트 | 화면 열림 | `btnItemId` 클릭 후 Model 선택 | Model 값 | `btnItemId_Click` 실행. `txtItemId.Text`에 선택값(sItemId) 설정 | `btnItemId_Click` (:256) |
| TC-SCP0028-008 | 조회 | 데이터가 있는 조건 | `cboDivision`, `cboOperationGroup`, `clbFromSite`, `clbTransMode`, `clbToSite`, `txtItemId`, `cboValid` 설정 후 툴바 조회 | 유효 조건 | 시트 `Shipment Lot Size`에 결과 행이 표시됨. 행 값이 AS-IS와 일치 | FindButton > FindData · `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` · `SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-009 | 조회 | 데이터가 없는 조건 | 결과가 없는 조건으로 툴바 조회 | 존재하지 않는 Model | 시트 `Shipment Lot Size`가 0행. 오류 없음(빈 결과 안내 문구는 **확인 필요**) | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` · `SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-010 | 조회 | – | 필수 표시가 있는 `cboDivision`을 비우고 조회 | Division 미선택 | AS-IS 동작(검증 메시지 또는 조회)과 같음 (검증 로직 **확인 필요**) | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-011 | 그리드 | TC-008 조회 완료 | 시트 컬럼 헤더 확인 | – | 표시 15개: Created By, Creation Date, Division, From Site, Increment*, Model, Last Update Date, Last Updated By, Lot Size*, Nick Name, Operation Group, Container Split*, To Site, Trans Mode, Valid*. 숨김 3개: FROM_SITE, TO_SITE, TRANS_MODE_CODE | 시트 `Shipment Lot Size` · SetSheetHeaderColumn (InitSpread:186) |
| TC-SCP0028-012 | division | 14개 division 시험 계정 | 각 division으로 조회한 뒤 표시 컬럼 수 확인 | 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC | 모든 division에서 표시 15개, 숨김 3개로 같음 | 시트 `Shipment Lot Size` · grid_effective.csv |
| TC-SCP0028-013 | 이벤트 | 조회 결과 행이 화면보다 많음 | `spdMain` 세로 스크롤 | – | `SpdMain_TopChange` 실행. 동작 결과가 AS-IS와 같음 (본문 **확인 필요**) | `SpdMain_TopChange` · 시트 `Shipment Lot Size` |
| TC-SCP0028-014 | 이벤트 | 조회 완료 | 그리드에서 `Lot Size*` 셀 값 변경 | Lot Size 변경값 | `spdMain_Change`(dsdm.Changed) 실행. 행 상태와 표시가 AS-IS와 같음 (본문 **확인 필요**) | `spdMain_Change` · 시트 `Shipment Lot Size` |
| TC-SCP0028-015 | 조회 | 입력 후보가 있는 조건 | 조회조건 설정 후 `btnInput` 클릭 | 유효 조건 | `btnInput_Click` 실행. 입력 후보 데이터가 조회되어 그리드에 반영됨(반영 방식은 AS-IS와 대조) | `btnInput_Click` · `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` · `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` |
| TC-SCP0028-016 | 조회 | 입력 후보가 없는 조건 | `btnInput` 클릭 | 결과 없는 조건 | 0건 처리. 오류 없음 (안내 문구 **확인 필요**) | `btnInput_Click` · `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` |
| TC-SCP0028-017 | 저장 | TC-014에서 셀 편집 | 툴바 저장 | 변경 행 1건 | `SCP_MST_SHIPMENT_LOT_SIZE` MERGE 반영. `SCP_MST_SHIPMENT_LOT_SIZE_H` 이력과 `SCM_SYS_LOG_BATCH` 로그 INSERT. 이후 재조회 결과에 변경값 표시 | SaveButton > SaveData · `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` → `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-018 | 저장 | TC-015 Input 결과 반영 | 신규 행의 `Lot Size*`, `Increment*`, `Container Split*`, `Valid*` 입력 후 저장 | 신규 행 | 신규 행이 MERGE로 등록되고 재조회 시 표시됨 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` · 시트 `Shipment Lot Size` |
| TC-SCP0028-019 | 저장 | 조회 완료 | 필수 표시 컬럼(`Lot Size*`)을 비우고 저장 | 빈값 | AS-IS 동작(검증 메시지 또는 SP 오류 응답)과 같음. 오류이면 데이터가 변경되지 않음 (검증·메시지 **확인 필요**) | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-020 | 저장 | 변경 행 없음 | 툴바 저장 | – | AS-IS 동작과 같음 (메시지 **확인 필요**) | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-021 | 저장 | 조회 완료 | 행을 선택하고 `btnDelete` 클릭 | 대상 행 1건 | `btnDelete_Click` 실행. `SCP_MST_SHIPMENT_LOT_SIZE`에서 DELETE되고 이력·로그 기록. 재조회 결과에서 해당 행이 없음 (삭제 구분값 **확인 필요**) | `btnDelete_Click` · `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` → `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-022 | 저장 | 조회 결과 0행 또는 선택 없음 | `btnDelete` 클릭 | – | AS-IS 동작과 같음. 데이터 변경 없음 (메시지 **확인 필요**) | `btnDelete_Click` · `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-023 | 저장 | DB 오류를 유발하는 조건(예: SP 실행 실패) | 툴바 저장 | 오류 유발 데이터 | 오류 응답이 표시되고 `SCP_MST_SHIPMENT_LOT_SIZE` 변경 없음 (오류 문구 **확인 필요**) | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `SCP0028_SAVE_SHIPMENT_LOT_SIZE` |
| TC-SCP0028-024 | 권한 | 그룹별 `TB_FX_GroupMenuAuth` 권한이 다른 계정 | 조회, 저장, `btnInput`, `btnDelete` 사용 가능 여부 확인 | 권한 계정별 | AS-IS 권한 플래그와 같음 (C/R/U/D 값 **확인 필요**) | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` · `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` · `btnInput_Click` · `btnDelete_Click` |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001~004 |
| | `btnInput_Click` | 015, 016 |
| | `btnDelete_Click` | 021, 022 |
| | `SpdMain_TopChange` | 013 |
| | `spdMain_Change` | 014 |
| | `ClbDivision_SelectedIndexChanged` | 005, 006 |
| | `btnItemId_Click` | 007 |
| 엔드포인트 | `biz:CommonData.YesOrNo` | 001 |
| | `biz:CommonData.CommonDataList` | 002, 003, 005, 006 |
| | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | 008~010, 017, 021 |
| | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | 015, 016 |
| | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | 017~023 |
| 시트 | `Shipment Lot Size` | 004, 011~014, 018 |
| 빈 결과 / 오류 | – | 009, 016, 019, 020, 022, 023 |
