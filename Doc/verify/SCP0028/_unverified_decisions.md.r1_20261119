# SCP0028 결정 목록 · 2026-11-19 17:05

| 결정 | 행 ID | 정할 내용 | 근거 |
|---|---|---|---|
| D1 | V-4121e73d, V-970e2243, V-899509b0, V-7a589536 | 다음 CheckList(BE 정상) 저장 세부 행으로 원인 확인. 같은 결과면 표본 값 선택 규칙 보완 | 저장 표본 값이 저장 전 검증에 막힘(F1, F2, F4, F6). 같은 실행이 BE 정지 구간과 겹쳐 원인 미확인 |
| D2 | V-d9f71764, V-d7cde174, V-a5e26726, V-fbb3bbaf | AS-IS 한 칸 공란 저장 동작을 AS-IS Live 로 확인할지 결정 | 기존 행 필수 칸 공란 저장. TO-BE 는 공란 뒤 수정 상태 없음 또는 M, 안내 수정한 내용이 없습니다. AS-IS SaveData 는 M 행이 LOT_SIZE, INCREMENT 공란이고 VALID_YN Y, SPLIT_YN N 이면 수정 취소(cs:583~590). 한 칸만 비운 경우 AS-IS 동작 미확인 |
| D3 | V-13254dec, V-02cca4b6, V-e3cbb602, V-fcba9999, V-e7534976, V-8c12aeea, V-4f2b09d7, V-81f7459d, V-3625f78e, V-4625c728 | 권장안 통과(저장이 콤보 원천을 바꾸지 않음, 재진입 재조회 실측). 승인하면 판정 경로에 넣음 | 콤보 재조회(B7). 저장 SP SCP0028_SAVE_SHIPMENT_LOT_SIZE 대상 표 SCP_MST_SHIPMENT_LOT_SIZE 가 콤보 원천 9종과 겹치지 않음. 재진입 때 admin/combo 12건 재조회 실측 통과. 원천 미확인 1종 |
| D4 | V-9e2b9258, V-db17a330, V-99331be4, V-93e5a09c, V-ed2ee896, V-6f2c58ff | 다음 라운드 검사기 보완 대상(팝업 연결 텍스트 칸 입력 경로). 268종은 조회 SP 의 Model 조건 대상 칸 확인 필요 | 조회조건 Model. TO-BE Model 칸은 팝업 연결 텍스트(MaterialByDivisionModal, ShipmentLotSize.tsx:362~371). 검사기 입력값이 조회 요청 본문에 실리지 않음(G8, G9 측정 실패). CEP2065I-B 조회 결과에 ITEM_ID 밖 값 268종(다른 칸 검색 여부 미확인) |
| D5 | V-dd4f9db4, V-ff037ad7 | SSP0014 세션 T355(멀티선택 후보 1개 재시도, 16:4x)와 같은 증상. 다음 CheckList 재측정 결과로 확인 | From Site 후보 0~1개. combo_oracle 실측은 Division 81 에서 30개. 같은 실행의 B 묶음(팝업 필수 알림, 메모)과 시각이 겹침 |
| D6 | V-db0f51c6, T-a239a7e1, T-449b82ac, T-0855373f, T-c7a94f1d, T-247bdc3c, T-57afcab2, T-3dbd9fe5, T-ba663c76, T-c5782dcb, T-8ef356b6, T-2a9cd623, T-5bb8509f, T-84c5ee4c, T-41bb3f1f, EG-ea38ffcb, T-2c20a3fc, T-653f1a5d, T-fad117f6, T-a9985ef6, T-f43dac0f, T-d6ad4a4e | 팝업 시나리오 검사기 확장은 다음 라운드. A6 2행은 대조표 Model 팝업 SP 표기 정정 필요(DB MODE 라 FE 폴더 대조표는 가이드 대상). btnDelete 는 AS-IS 무동작인데 TO-BE 는 삭제 팝업을 띄움, 차이 인정 여부 결정 | 팝업 계열(H6, G5, M4, A6, F4, G4). 화면 진입, 조회 중 팝업 SP 호출 0건. 팝업 선택값 반영 시나리오 실행 경로 없음. TO-BE Model 팝업은 사용자 지시(2026-10-08)로 COM0013 MaterialByDivisionModal 이라 PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 TO-BE 에서 부르지 않음. AS-IS btnDelete_Click(cs:288~300)은 Form_Load("D") 뒤 ShowDialog 가 없어 팝업을 띄우지 않음 |
| D7 | V-f3e94ee4, V-e9891c92, V-2611b990, V-9b370c0f | 권장안: DMF0003, DMF0082 의 AS From Site, DMF0005 Cust Group 관계는 SCP0028 대상 아님(해당없음). 승인하면 판별 규칙에 반영 | 다른 화면 결함 유형 중 칸 이름이 SCP0028 칸과 겹침(AS From Site 와 From Site, Site, Active). 이름만으로 같은 칸인지 판별 불가 |
| D8 | V-480372c9, V-86b2f489 | 권장안: 모드 전달 방식 차이로 통과. 승인 여부 | AS-IS 팝업 호출 고정 플래그 _action_flag D, I 를 TO-BE 팝업에 넘기지 않음. TO-BE 는 setBatchMode(I, D)로 모드 전달(ShipmentLotSize.tsx:338~344) |
| D9 | V-86e7f1e2, V-a89007be, T-0caf6c62, T-4677b9e5 | 팝업 Delete 시나리오 검사기 확장(다음 라운드) | MSG00031, MSG00284 는 FindDelete 경로 메시지. Delete 팝업 조회 시나리오 경로 없음 |
| D10 | V-ee003a13, V-8da88867 | 다음 라운드에 golden_cases.csv 짝, 인자 확인 | golden.py 가 두 조회 SP 를 실행하지 못함. 실행 기록 미확인 |
| D11 | T-6dc0e2d5, T-52d59336 | 공통 SP 라 화면 단위 대상 여부 결정 | PR_GET_MNU_BTN_AUTH 정렬(A6), 시노님(DB-SYN) 검사 경로 없음. 공통 권한 SP |
| D12 | V-b1aa0c11 | 권장안: CR-084, CR-093 적용 통과. 판정 경로 연결 여부 | AS-IS EditButton SwitchLock(cs:229~235) 편집 모드. TO-BE 룰 CR-084, CR-093(편집 버튼 없음, 조회 즉시 편집) |
| D13 | V-b48e5d97 | InsertRow 무동작이라 신규 행이 생기지 않음. 권장안: 해당없음 | AS-IS DeleteButton 은 활성 스프레드가 spdMain 이고 신규(I) 행일 때만 삭제(cs:211~227). 조회 전 프로브 미구현 |
| D14 | V-564a1ac4 | 권장안: 통과(기존 행 삭제 불가가 AS-IS 동작). 승인 여부 | DIVISION_ID 병합 37행 Delete 뒤 D 표시 0, 알림 표시. AS-IS DeleteButton 은 신규 행만 삭제 |
| D15 | V-a99ddb18 | 저장 전 편집으로 조건을 만드는 시험 허용 여부(저장 요청은 차단) | H2 배경색 조건(M 행, LOT_SIZE, INCREMENT 공란, VALID Y, SPLIT N)을 만족하는 행 0. Div 40 조회 265행 |
| D16 | V-d629e9b7 | 검사기 신설 여부 | I3 언어 전환 명칭 비교 검사기 없음 |
| D17 | T-522ba284 | SSP0014 세션 T357(mapping_trace ev_gates 가 check.js --page 실행, 16:4x)로 연결됨. 다음 CheckList 재측정 결과로 확인 | check.js G03 화면 이벤트 배선 검사를 원장 행에 연결하는 경로 없음 |
| D18 | EG-bd80125c | 메시지 코드 등록 뒤 FE 가이드 작성 여부 | 화면 고정 한글 문구 useShipmentLotSizeValidation.ts:52 {0}은 {1} 보다 클 수 없습니다. |
| D19 | EG-f71f5543 | DB 객체 보완 대상 여부(NO_DATA_FOUND 처리) | PKG_SCP0028 264줄 V_TOKEN_TAB 단건 SELECT INTO 빈 결과 처리 없음 |
