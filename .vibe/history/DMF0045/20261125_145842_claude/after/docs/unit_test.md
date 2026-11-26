# DMF0045 ShipmentRequest — 단위테스트

> 근거: Fact Pack(DMF0045)과 업무분석서·화면설계서입니다. 기대결과가 Fact Pack에 없으면 **확인 필요**로 적었습니다. 이런 케이스는 AS-IS를 실행해 실측값을 확정한 뒤 판정합니다.
> 절차 열의 컨트롤명은 화면설계서 §3 컨트롤명입니다. 근거 열의 엔드포인트·SP·핸들러·시트 이름은 원문입니다.
> 주석 처리된 호출(commented_calls)은 0건이어서 테스트 대상에서 제외할 것이 없습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-DMF0045-001 | 초기화 | Division 81 권한 계정으로 로그인 | DMF0045 화면을 연다 | — | `cboDivision`에 사용자 그룹 권한(TB_FX_USERGROUPAUTHEXTENTION) Division 목록이 표시됩니다 | `Form_Load`, `biz:CommonData.CommonDataList` [code=MyDivision] (InitControls:200) |
| TC-DMF0045-002 | 초기화 | 001과 같음 | 화면을 연 뒤 `cboBucketType` 목록을 확인한다 | — | SCM_ADM_LOOKUP_MASTER_DETAIL 기반 Bucket 코드(DAILY/WEEKLY/MONTHLY 포함 여부 확인)가 표시됩니다. 초기 선택값은 **확인 필요** | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, SP `DM0003_GET_BUCKET_TYPE_CODE` (GetBucketType:2266) |
| TC-DMF0045-003 | 초기화 | 001과 같음 | 화면을 연 뒤 `spdMain` 시트 탭을 확인한다 | — | 시트 `Pack Biz`, `Cell Biz` 2개가 생성되고 `Pack Biz`가 활성화됩니다. 헤더는 3행입니다 | `Form_Load`, CreateSpread:255/260/265, `DM.DMF0045_GET_SPREAD_TITLE`, SP `DMF0045_GET_SPREAD_TITLE`, 시트 `Pack Biz`, `Cell Biz` |
| TC-DMF0045-004 | 초기화 | 001과 같음 | 화면을 열 때 호출 로그를 확인한다 | — | Measure 공통 코드 조회가 1회 호출됩니다 | `Form_Load`, `biz:CommonData.CommonDataList` [code=Measure] (InitControls:231) |
| TC-DMF0045-005 | 초기화 | 001과 같음 | `drpPeriod`, `btnColumn`의 상태를 확인한다 | — | `drpPeriod`는 비활성(Enabled=false), `btnColumn`은 비표시(Visible=false)입니다 | props.csv 515/356, `btnColumn_Click` |
| TC-DMF0045-006 | 그리드 | Division 81, 조회 완료 | `spdMain`에서 `Cell Biz` 탭을 선택해 컬럼을 확인한다 | `cboDivision`=81 | 표시 13개: Division*, Team, End Customer, Requestor, FCST Type*, Frorm ( Plant )*, To ( Sales-Site )*, Incoterms*, Trans Mode*, Model*, Nick Name, Project Code*, Measure*. 숨김: BOD_ID, MEASURE_COLOR, SHIP_FROZEN. 순서는 SORT_ORDER_NO 확인 후 판정 | 시트 `Cell Biz`, grid_effective.csv, `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-007 | 그리드 | Division 81, 조회 완료 | `Pack Biz` 탭의 컬럼을 확인한다 | `cboDivision`=81 | 006과 같은 13개 컬럼이 표시되고 3개가 숨겨집니다 | 시트 `Pack Biz`, grid_effective.csv |
| TC-DMF0045-008 | 그리드 | 조회 결과 1행 이상 | 헤더를 확인한다 | — | 0행 대분류 Span + SUM, 1행 소분류 Span, 2행 SUM입니다. `B_` 포함 컬럼은 숨김입니다. 토요일 헤더는 Blue, 일요일 헤더는 Red입니다 | SetSpreadHeaderSpan:327~381/335/346, `DM.DMF0045_GET_SPREAD_TITLE`, 시트 `Pack Biz` |
| TC-DMF0045-009 | 그리드 | 조회 결과 1행 이상 | 그리드 하단 Footer를 확인한다 | — | ColumnFooter가 표시되고 MEASURE 기준 합계가 나옵니다. 합계 방식은 **확인 필요** | InitSpreadFooterSum:285, Set_SumValues:734, 시트 `Cell Biz` |
| TC-DMF0045-010 | division | Division 81_UC 권한 계정 | `cboDivision`=81_UC로 조회한 뒤 두 시트의 컬럼·Measure를 확인한다 | 81_UC | 두 시트 모두 표시 컬럼 13개입니다. Measure 메타 행 수: `Cell Biz` 11, `Pack Biz` 9. 실제 표시 Measure 종류 수와 일치하는지 확인합니다 | `cboDivision_SelectedIndexChanged`, `DM.DMF0045_GET_SHIPMENT_REQUEST`, 시트 `Cell Biz`, `Pack Biz` |
| TC-DMF0045-011 | division | Division 82 권한 계정 | `cboDivision`=82로 조회한 뒤 두 시트의 Measure를 확인한다 | 82 | 표시 컬럼 13개입니다. Measure 메타 행 수: `Cell Biz` 10, `Pack Biz` 8(81보다 1개 적음). 빠지는 Measure는 **확인 필요** | `DM.DMF0045_GET_SHIPMENT_REQUEST`, SP `DMF0045_GET_SHIPMENT_REQUEST`(SCM_MST_SHEET_MEASURE), 시트 `Cell Biz`, `Pack Biz` |
| TC-DMF0045-012 | division | Division 81 권한 계정 | `cboDivision`=81로 조회한 뒤 Measure 수를 확인한다 | 81 | Measure 메타 행 수: `Cell Biz` 11, `Pack Biz` 9 | `DM.DMF0045_GET_SHIPMENT_REQUEST`, 시트 `Cell Biz`, `Pack Biz` |
| TC-DMF0045-013 | division | Division 40 또는 EE 계열 계정 | 해당 Division으로 화면을 열고 조회한다 | 40 / EE | 메타(SCM_MST_SHEET_COLUMNS) 정의가 없습니다. 화면 동작(컬럼 미생성 또는 사용 불가)은 **확인 필요** | `DM.DMF0045_GET_SPREAD_TITLE`, grid_rule, 시트 `Cell Biz`, `Pack Biz` |
| TC-DMF0045-014 | 조회 | Division 81, 데이터 있음 | 조건을 입력하고 조회(FindButton)를 누른다 | `cboDivision`=81, `cboBucketType`=WEEKLY | Measure 조회 → 데이터 조회 → 타이틀 조회 순서로 호출되고 결과가 바인딩됩니다. SetSpreadColumn이 적용됩니다(652) | FindData, `biz:CommonData.CommonDataList` [code=Measure](579), `DM.DMF0045_GET_SHIPMENT_REQUEST`, SP `DMF0045_GET_SHIPMENT_REQUEST`(609), `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-015 | 조회 | 조회 전후 SCM_MST_TITLESET_USER 행 수 기록 | 조회를 누른다 | 014와 같음 | 조회 SP가 SCM_MST_TITLESET_USER에 INSERT하는지(행 수 변화) 확인합니다. 조건은 **확인 필요** | SP `DMF0045_GET_SHIPMENT_REQUEST` (INSERT:SCM_MST_TITLESET_USER) |
| TC-DMF0045-016 | 조회 | 결과가 없는 조건 | 결과가 없는 조건으로 조회를 누른다 | `txtItemId`=존재하지 않는 모델 | 그리드가 0행입니다. `GetMaxRowIndex() < 0`이므로 SetSpreadColumn이 호출되지 않습니다. 메시지는 **확인 필요** | FindData:652, `DM.DMF0045_GET_SHIPMENT_REQUEST` |
| TC-DMF0045-017 | 조회 | 조회 SP 오류를 유발할 수 있는 환경(예: 시험 DB에서 SP 권한 회수) | 조회를 누른다 | 014와 같음 | 오류 응답 시 화면 처리(메시지·그리드 유지)는 **확인 필요**입니다. 그리드가 깨지지 않아야 합니다 | `DM.DMF0045_GET_SHIPMENT_REQUEST` 오류 응답 |
| TC-DMF0045-018 | 저장 | 조회 완료, 편집 가능 행 존재 | 행을 수정하고 저장(SaveButton)을 누른다 | Measure 값 변경 | 저장 SP가 호출되고 DM_PLN_SHIPMENT_REQ, DM_PLN_SHIPMENT_REQ_H, SCM_SYS_LOG_BATCH에 INSERT됩니다. 이후 재조회됩니다. 시험 후 원복합니다 | SaveData:896, `DM.DMF0045_SAVE_SHIPMENT_REQUEST`, SP `DMF0045_SAVE_SHIPMENT_REQUEST`, SaveData > FindData > `DM.DMF0045_GET_SHIPMENT_REQUEST` |
| TC-DMF0045-019 | 저장 | `Cell Biz` 활성 | `Cell Biz` 탭에서 수정 후 저장한다 | — | 활성 시트(GetSheetInfo:807) 데이터만 저장되는지 확인합니다 | SaveData:807, `DM.DMF0045_SAVE_SHIPMENT_REQUEST`, 시트 `Cell Biz` |
| TC-DMF0045-020 | 저장 | 필수값(`*` 컬럼) 비움 | Model* 셀을 비우고 저장한다 | ITEM_ID 공란 | 검증·오류 메시지는 **확인 필요**입니다(SP는 SCP_MST_BOD / SCP_MST_DISTRIBUTION_ROUTE 참조) | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` 오류 응답, SP `DMF0045_SAVE_SHIPMENT_REQUEST` |
| TC-DMF0045-021 | 저장 | 변경 없음 | 수정 없이 저장을 누른다 | — | 처리(호출 여부·메시지)는 **확인 필요** | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` |
| TC-DMF0045-022 | 그리드 | `Pack Biz` 활성, 잠금 아님 | 행추가(InsertButton)를 누른다 | — | 새 행의 FCST_TYPE 셀은 FCST_TYPE 콤보, MEASURE 셀은 Measure 콤보입니다 | InsertRow:1001/1003/1004/1005, `biz:CommonData.CommonDataList` [code=FCST_TYPE], [code=Measure], 시트 `Pack Biz` |
| TC-DMF0045-023 | 권한 | 시트 잠금 상태(IsLock=true) | 행추가를 누른다 | — | 행이 추가되지 않습니다. 메시지는 **확인 필요** | InsertRow 조건 `IsLock(...) == false` (1003) |
| TC-DMF0045-024 | 이벤트 | 화면 로드 완료 | `cboDivision`을 다른 Division으로 바꾼다 | 81 → 82 | 타이틀 SP가 다시 호출되고 헤더가 재구성됩니다. 다른 조건의 연쇄 갱신은 **확인 필요** | `cboDivision_SelectedIndexChanged`, `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-025 | 이벤트 | 조회 결과 있음 | `cboBucketType`을 WEEKLY로 바꾼다 | WEEKLY, `chkSum` 해제 | D_ 숨김, W_ 표시, M_ 숨김 | `cboBucketType_SelectedIndexChanged`(1136), SetSpreadColumn 2164/2168/2173 |
| TC-DMF0045-026 | 이벤트 | 조회 결과 있음 | `cboBucketType`을 MONTHLY로 바꾼다 | MONTHLY | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn 2180/2184 |
| TC-DMF0045-027 | 이벤트 | `cboBucketType`=DAILY, 조회 결과 있음 | `chkSum`을 체크했다가 해제한다 | `chkSum` on/off | D_는 항상 표시, M_은 `chkSum` 상태를 따릅니다. W_ 최종 표시는 **확인 필요**(2152/2157 중복) | `chkSum_CheckedChanged`(2136), SetSpreadColumn 2152/2157 |
| TC-DMF0045-028 | 이벤트 | `cboBucketType`=WEEKLY | `chkSum`을 체크한다 | `chkSum` on | M_ 컬럼이 표시됩니다 | `chkSum_CheckedChanged`, SetSpreadColumn 2173 |
| TC-DMF0045-029 | 이벤트 | 화면 로드 완료 | `btnMeasure`를 누른다 | — | 타이틀 SP가 다시 호출되고 헤더가 재구성됩니다 | `btnMeasure_Click`, `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-030 | 이벤트 | 화면 로드 완료 | `btnColumn`이 화면에 없는지 확인한다(Visible=false) | — | 버튼이 표시되지 않습니다. 핸들러가 실행되면 타이틀 SP를 다시 호출합니다(코드 경로) | `btnColumn_Click`, `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-031 | 이벤트 | 화면 로드 완료 | `btnProject`를 누르고 Project를 선택한다 | Project 1건 선택 | `txtProject`에 선택한 Project 코드가 들어갑니다. 팝업 화면은 **확인 필요** | `btnProject_Click`(2093) |
| TC-DMF0045-032 | 이벤트 | 화면 로드 완료 | `btnItemId`를 누르고 Model을 선택한다 | Model 1건 선택 | `txtItemId`에 선택한 Model이 들어갑니다 | `btnItemId_Click`(2116) |
| TC-DMF0045-033 | 이벤트 | 화면 로드 완료 | `clbCustomer`의 선택을 바꾼다 | 1건 체크 | 연쇄 갱신 대상은 **확인 필요**(NowGroupID 읽기만 확인). AS-IS 실측 후 판정 | `clbCustomer_SelectedIndexChanged`(1128) |
| TC-DMF0045-034 | 이벤트 | 화면 로드 완료 | `clbTeam`의 선택을 바꾼다 | 1건 체크 | 연쇄 갱신 대상은 **확인 필요**. AS-IS 실측 후 판정 | `clbTeam_SelectedIndexChanged`(1116/1120) |
| TC-DMF0045-035 | 그리드 | `cboBucketType`=MONTHLY, 조회 결과 있음 | `spdMain`의 M_ 컬럼 헤더를 더블클릭한다(2회) | — | 1회차에 W_/D_ 컬럼 표시가 토글되고, 2회차에 원래대로 돌아옵니다 | `spdMain_CellDoubleClick` 1211/1217 |
| TC-DMF0045-036 | 그리드 | W_ 컬럼 표시 상태 | W_ 컬럼 헤더를 더블클릭한다 | — | D_ 컬럼 표시가 토글됩니다 | `spdMain_CellDoubleClick` 1233 |
| TC-DMF0045-037 | 그리드 | 편집 가능 행 | END_CUSTOMER 콤보 값을 바꾼다 | 다른 End Customer | 같은 행 FROM_SITE 콤보 목록이 다시 설정됩니다(UserSiteByEndCustomer[Auth]). 목록 기준은 **확인 필요** | `spdMain_ComboSelChange`(1158) |
| TC-DMF0045-038 | 그리드 | 편집 가능 행, Division·FROM_SITE 컬럼 존재 | FROM_SITE 콤보 값을 바꾼다 | 다른 Plant | MEASURE 콤보 목록이 다시 설정됩니다 | `spdMain_ComboSelChange`(1194/1195), `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] |
| TC-DMF0045-039 | 이벤트 | 조회 결과가 화면보다 많음 | `spdMain`을 세로 스크롤한다 | — | 동작은 **확인 필요**(배선만 확인). AS-IS 실측 후 판정 | `spdMain_TopChange` (Designer:982) |
| TC-DMF0045-040 | 이벤트 | 조회 결과 있음 | `spdMain` 셀에서 키를 입력한다 | 임의 키 | 동작은 **확인 필요**(배선만 확인). AS-IS 실측 후 판정 | `spdMain_KeyUp` (Designer:983) |
| TC-DMF0045-041 | 이벤트 | `Pack Biz` 활성, 조회 결과 있음 | 셀 값을 바꾼다 | 수량 변경 | DefaultBucketDay 조회가 호출됩니다. 반영 결과는 **확인 필요** | `spdMain_Changed` (dsdmPack.Changed), `biz:CommonData.CommonDataList` [code=DefaultBucketDay](1749/1811), 시트 `Pack Biz` |
| TC-DMF0045-042 | 이벤트 | `Cell Biz` 활성, 조회 결과 있음 | 셀 값을 바꾼다 | 수량 변경 | 041과 같은 처리가 dsdmCell 기준으로 일어납니다 | `spdMain_Changed` (dsdmCell.Changed), `biz:CommonData.CommonDataList` [code=DefaultBucketDay], 시트 `Cell Biz` |
| TC-DMF0045-043 | 권한 | 그룹 권한이 다른 두 계정 | 각 계정으로 화면을 열어 `cboDivision` 목록을 비교한다 | 계정 A / B | 그룹 권한(NowGroupID, TB_FX_USERGROUPAUTHEXTENTION)에 따라 목록이 달라집니다. 메뉴 C/R/U/D 권한(TB_FX_GroupMenuAuth 13행)은 **확인 필요** | `Form_Load`, `biz:CommonData.CommonDataList` [code=MyDivision] |
| TC-DMF0045-044 | 이벤트 | 조회 결과 있음 | 편집(EditButton)을 누른다 | — | 활성 시트 정보(GetSheetInfo)를 가져옵니다. 결과는 **확인 필요** | EditButton:443 |
| TC-DMF0045-045 | 조회 | 화면 전 기능 수행(로드·조회·행추가·저장·이벤트) | 호출 로그에서 SCM0001 호출 여부를 확인한다 | — | 진입점 미연결이므로 호출되지 않습니다. 호출되면 미연결 판정을 재검토합니다 | GetBizTypebyDivision:2278, `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`, SP `SCM0001_GET_BIZ_TYPE_BY_DIVISION` |
| TC-DMF0045-046 | 초기화 | 공통코드 조회 오류를 유발할 수 있는 환경 | 화면을 연다 | — | 오류 응답 시 화면 처리는 **확인 필요**. 화면이 비정상 종료되지 않아야 합니다 | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE` / `DM.DMF0045_GET_SPREAD_TITLE` 오류 응답 |

## 커버리지 대조

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 15 | `btnMeasure_Click` 029 · `cboDivision_SelectedIndexChanged` 010, 024 · `chkSum_CheckedChanged` 027, 028 · `btnColumn_Click` 005, 030 · `btnProject_Click` 031 · `btnItemId_Click` 032 · `cboBucketType_SelectedIndexChanged` 025, 026 · `clbCustomer_SelectedIndexChanged` 033 · `clbTeam_SelectedIndexChanged` 034 · `spdMain_CellDoubleClick` 035, 036 · `spdMain_ComboSelChange` 037, 038 · `spdMain_TopChange` 039 · `spdMain_KeyUp` 040 · `Form_Load` 001~004, 043, 046 · `spdMain_Changed` 041, 042 | 15/15 |
| 엔드포인트 6 | `biz:CommonData.CommonDataList` 001, 004, 014, 022, 038, 041 · `DM.DMF0045_GET_SHIPMENT_REQUEST` 014~017 · `DM.DMF0045_SAVE_SHIPMENT_REQUEST` 018~021 · `DM.DMF0045_GET_SPREAD_TITLE` 003, 024, 029 · `DM.DM0003_GET_BUCKET_TYPE_CODE` 002 · `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` 045 | 6/6 |
| 시트 2 | `Cell Biz` 006, 019, 042 · `Pack Biz` 007, 022, 041 | 2/2 |
| division 변형 | 81 012 · 81_UC 010 · 82 011 · 40/EE 013 | 4/4 |
| 빈 결과·오류 | 016(빈 결과) · 017, 020, 046(오류 응답) | 포함 |
