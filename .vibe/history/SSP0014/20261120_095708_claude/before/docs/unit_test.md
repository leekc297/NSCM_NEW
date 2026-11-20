# SSP0014 Shipment Model PIC — 단위테스트

> 근거 열은 업무분석서 §5와 화면설계서 §5의 이름을 그대로 씁니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 핸들러 본문이 확인되지 않은 케이스는 기대결과를 'AS-IS 실행 결과와 동일'로 적고, 판정 기준은 확인 필요로 남깁니다.
> 주석 처리된 호출(0건)은 테스트 케이스로 만들지 않았습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0014-001 | 초기화 | 로그인. SSP0014 메뉴 권한 보유 | 1) 화면을 연다 | – | `Form_Load` 실행. 조회조건(cboDivision, cboOperationGroup, clbFromSite, cboValidYN, txtUser, txtItemId)이 표시되고 spdMain에 시트 `Shipment Model PIC`가 생성됨. 콤보 초기값은 AS-IS와 동일(값은 확인 필요) | `Form_Load`, `Shipment Model PIC` |
| TC-SSP0014-002 | 초기화 | TC-001 | 1) usrConditionPanel1 영역 확인 2) usrLayoutControl2 안의 컨트롤 라벨 확인 | – | 라벨 원문 `Division*`, `Operation Group`, `From Site`, `Valid`, `User ID(Name)`, `Model`이 표시되고 btnItemId가 txtItemId 옆에 있음 | `Form_Load` |
| TC-SSP0014-003 | 그리드 | TC-001 | 1) spdMain / spdMain_Sheet1의 컬럼 헤더를 확인 | – | 21컬럼 헤더(Created By, Creation Date, Division, From Site, Model, Last Update Date, Last Updated By, Mail User1~5, Nick Name, Operation Group, Part Leader, Part Leader Name, Team Leader, Team Leader Name, User ID*, User Name, Valid*)가 모두 표시됨. 순서와 폭은 메타 원문과 일치 | `Shipment Model PIC` (SetSheetHeaderColumn) |
| TC-SSP0014-004 | 그리드 | TC-001 | 1) spdMain에서 이미지 셀이 적용된 컬럼 확인 | – | InitSpread 225~233의 이미지 CellType 8건이 AS-IS와 같은 컬럼에 적용됨(대상 컬럼은 확인 필요) | `Shipment Model PIC` |
| TC-SSP0014-005 | 조회 | 해당 조건의 데이터가 SSP_MST_MODEL_USER에 있음 | 1) cboDivision 선택 2) clbFromSite 체크 3) 조회 클릭 | Division=시험 계정 Division, From Site=1건 이상 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` 1회 호출, spdMain에 결과 행 표시, 행 수가 SP 직접 실행 결과와 같음 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC`, `SSP0014_GET_SHIPMENT_MODEL_PIC`, `Shipment Model PIC` |
| TC-SSP0014-006 | 조회 | TC-001 | 1) cboDivision 선택 2) clbFromSite 다건 체크 3) cboValidYN, txtUser, txtItemId 입력 4) 조회 | 다건 From Site, txtItemId 다중행 | 다건 값이 구분자 문자열로 전달되어(GetCheckedListValue, STRING_SPLIT) 조건에 맞는 행만 조회됨 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-007 | 조회 | 해당 조건 데이터 없음 | 1) txtItemId에 없는 Model 입력 2) 조회 | Model=존재하지 않는 값 | 오류 없이 0행 표시(빈 결과 메시지는 AS-IS와 동일, 확인 필요) | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-008 | 조회 | cboDivision 미선택 상태를 만들 수 있음 | 1) cboDivision을 비움 2) 조회 | Division=빈값 | 필수(`Division*`) 처리가 AS-IS와 동일(검증 메시지 또는 동작은 확인 필요) | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-009 | 저장 | TC-005 조회 완료 | 1) spdMain 행의 USER_ID를 유효한 사용자로 수정 2) 저장 | USER_ID=TB_FX_USER에 있는 ID | `SSP.SSP0014_GET_USER_ID_CHECK` 통과 → `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`가 SSP_MST_MODEL_USER에 MERGE, SCM_SYS_LOG_BATCH에 INSERT → `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` 재조회로 수정값 표시. 시험 후 원래 행으로 복원 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `SSP.SSP0014_GET_USER_ID_CHECK`, `SSP0014_GET_USER_ID_CHECK`, `Shipment Model PIC` |
| TC-SSP0014-010 | 저장 | TC-005 조회 완료 | 1) spdMain 행의 USER_ID를 존재하지 않는 ID로 수정 2) 저장 | USER_ID=TB_FX_USER에 없는 ID | `SSP.SSP0014_GET_USER_ID_CHECK` 검사 결과에 따라 저장이 차단되거나 AS-IS와 같은 오류 메시지 표시. SSP_MST_MODEL_USER 변경 없음(검사 기준과 메시지는 확인 필요) | `SSP.SSP0014_GET_USER_ID_CHECK`, `SSP0014_GET_USER_ID_CHECK` |
| TC-SSP0014-011 | 저장 | TC-005 조회 완료 | 1) 필수 컬럼 VALID_YN 또는 USER_ID를 비움 2) 저장 | Valid*=빈값 | AS-IS와 같은 필수값 처리(오류 응답 또는 메시지). 데이터 변경 없음 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `Shipment Model PIC` |
| TC-SSP0014-012 | 저장 | 해당 키의 행이 SSP_MST_MODEL_USER에 없음 | 1) 신규 키로 저장할 수 있는 상태 만들기(방법은 확인 필요) 2) 저장 | 신규 Model/Site | MERGE로 INSERT 반영, 재조회에 표시. 시험 후 삭제 복원 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-013 | 저장 | SAVE SP 오류를 유발할 수 있는 시험 환경 | 1) SP 오류가 나는 값으로 저장 | 오류 유발 값(확인 필요) | 오류 메시지 표시, 부분 저장 없음(롤백), 그리드 유지 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-014 | 이벤트 | TC-001 | 1) cboDivision 값을 다른 Division으로 변경 | Division=다른 값 | `CboDivision_SelectedIndexChanged` 실행. 종속 조회조건(cboOperationGroup, clbFromSite 등) 갱신 여부가 AS-IS와 동일(본문 확인 필요) | `CboDivision_SelectedIndexChanged` |
| TC-SSP0014-015 | 이벤트 | TC-001 | 1) btnItemId 클릭 2) 값 선택(팝업 여부 확인 필요) | Model 1건 이상 | `btnItemId_Click` 실행, txtItemId.Text에 sItemId 값이 설정됨 | `btnItemId_Click` |
| TC-SSP0014-016 | 이벤트 | TC-005 조회 완료(여러 행) | 1) spdMain 셀 더블클릭 | 임의 행/컬럼(이미지 셀 포함) | `SpdMain_CellDoubleClick` 실행 결과가 AS-IS와 동일(본문 확인 필요) | `SpdMain_CellDoubleClick`, `Shipment Model PIC` |
| TC-SSP0014-017 | 이벤트 | TC-005 조회 완료(화면을 넘는 행 수) | 1) spdMain 세로 스크롤 | – | `SpdMain_TopChange` 실행 결과가 AS-IS와 동일(본문 확인 필요). 오류 없음 | `SpdMain_TopChange` |
| TC-SSP0014-018 | 초기화 | `biz:CommonData.YesOrNo`를 쓰는 컨트롤 확인(진입점 미연결) | 1) 해당 컨트롤(cboValidYN 후보, 확인 필요)의 항목 확인 | – | YesOrNo 공통 코드 목록이 AS-IS와 같은 항목으로 표시됨 | `biz:CommonData.YesOrNo` |
| TC-SSP0014-019 | division | Division 40 계정과 81 계정 각각 | 1) 각 계정으로 화면을 연다 2) spdMain 컬럼 수 확인 | Division=40, 81 | 두 Division 모두 `Shipment Model PIC` 21컬럼이 동일하게 표시됨(division별 변형 없음 확인) | `Shipment Model PIC`, `Form_Load` |
| TC-SSP0014-020 | division | Division 82 / EE 계정 각각 | TC-019와 같은 절차 | Division=82, EE | 21컬럼 동일 표시 | `Shipment Model PIC` |
| TC-SSP0014-021 | 권한 | 조회 권한만 있는 그룹 계정(TB_FX_GroupMenuAuth 기준, 확인 필요) | 1) 화면 열기 2) 조회 3) 저장 시도 | – | 조회는 되고, 저장 버튼 동작은 권한 메타에 따름(AS-IS와 동일) | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC`, `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-022 | 권한 | 그룹이 다른 두 계정 | 1) 각 계정으로 화면 열기 2) 조회조건 기본값 비교 | – | SetChangeControl(GROUP_ID/USER_ID, NowGroupID)에 따른 조회조건 차이가 AS-IS와 동일 | `Form_Load` |
| TC-SSP0014-023 | 조회 | 조회 SP 오류(예: 연결 단절)를 재현할 수 있는 시험 환경 | 1) 조회 | – | 오류 메시지 표시, 화면 비정상 종료 없음, 이전 그리드 상태 유지 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |

**커버리지 확인**
| 대상 | 케이스 |
|---|---|
| `Form_Load` | 001, 002, 019, 022 |
| `SpdMain_TopChange` | 017 |
| `SpdMain_CellDoubleClick` | 016 |
| `CboDivision_SelectedIndexChanged` | 014 |
| `btnItemId_Click` | 015 |
| `biz:CommonData.YesOrNo` | 018 |
| `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | 005, 006, 007, 008, 009, 021, 023 |
| `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | 009, 011, 012, 013, 021 |
| `SSP.SSP0014_GET_USER_ID_CHECK` | 009, 010 |
| 시트 `Shipment Model PIC` | 001, 003, 004, 005, 009, 011, 016, 019, 020 |
| 빈 결과 / 오류 응답 | 007 / 010, 011, 013, 023 |
