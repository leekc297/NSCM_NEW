# SCP0028 미검증 행별 조치 표 · 라운드 1 · 2026-11-19 17:05

- 입력: unverified_triage.csv(16:35:20), 원장 verify_ledger.csv(16:34:49). 원장 미검증 278행 = 처리 대상 141, 집계 137
- 표 행 수 141 = 처리 대상 141. 집계 137행은 하위 행을 따라감

## 고친 묶음

| 묶음 | 행 수 | 원인(실측) | 고친 곳 | 다음 CheckList 판정(미측정) |
|---|---|---|---|---|
| A | 12 | BE 정지 중 측정(results.json 05:30Z~06:21Z 문서 시나리오: 로그인 BE 대기 300초 실패 3회, 화면 열기 Home 이동 10회). Home 이동을 화면 권한 없음으로 기록함 | tools/E2E/lib/nscm.ts openScreen(BE 포트 확인, 대기, 재로그인, 1회 재시도, beDown), Doc/e2e/specs/_verify.spec.ts 시나리오 실패 문구, unverified_classes.csv 재실행 유형 | 다음 CheckList 에서 실측(통과 또는 오류). BE 가 다시 멈추면 [BE 응답 없음] 재실행 유형 |
| B | 7 | 앞 테스트(05:27Z 버튼 경로 메시지)가 From Site 후보 0개 상태에서 대안 0건으로 조회 0행 메모를 남김. 뒤 문서 시나리오가 메모 때문에 재시도 생략 | tools/E2E/lib/smoke-extra.ts ensureRows 메모 조건(대안 시도 0건, BE 포트 닫힘, 5xx 있으면 메모 안 함) | 다음 CheckList 에서 Division 순회로 행 확보 뒤 실측. 행을 못 만들면 시도 내역을 붙인 미검증 |
| C | 26 | AS-IS InsertButton → InsertRow() 본문 비어 있음(SCP0028_Shipment_Lot_Size.cs:200~203, 571~573). TO-BE 도 Insert 뒤 신규 행 없음(실측). 검사기가 잠금 해석 실패, 측정 경로 없음으로 기록함 | tools/Harness/verify/facts_lockrules.py insert_noop(신규 행 기대 NONE), tools/Harness/verify/judge.py _asis_insert_noop, insert_noop_na | 해당없음(근거 AS-IS 실행 문장 0, TO-BE 신규 행 없음). D1 컬럼 15행은 원장 재생성 때 신규 행 행이 만들어지지 않음 |
| D | 8 | TO-BE 조회조건 라벨 Active(LBL00007 EN Active, 원장 V-cd32453c 실측). _verify 검사기가 AS-IS 라벨 Valid 로만 찾아 칸을 못 찾음. 명칭 변경 룰 CR-092 는 _trace 에만 연결돼 있었음 | Doc/e2e/specs/_verify.spec.ts findSearchBox(label_alias.csv 별칭 라벨로 다시 찾음) | 다음 CheckList 에서 콤보 덤프, B2, B3, B4, B6, G1, G7 실측. H5 는 기준표 없는 화면 경로에서 CR-092 로 판정 |
| E | 7 | 조회조건 기준표(SCP_DM_화면별 조회조건 정리_260122_v0.4.xlsx 6시트, search_cond.csv)에 SCP0028 행 0. 정적 H5, SC1 판정이 행을 건드리지 않음 | tools/Harness/verify/judge.py 기준표 없는 화면 경로(AS-IS 라벨 대조, SC1 해당없음) | H5 6행: TO-BE 라벨이 있으면 통과, 없으면 사유를 붙인 미검증. SC1: 해당없음(기준표 행 0) |
| F | 6 | 다른 화면(DMF0004, DMF0005) 결함 유형. 대상 칸(End Customer, Sold-to Customer, Sales Company, Sales Plant, Cust Group, Sales Site)이 SCP0028 그리드 98행, 조회조건 7개에 없음. 대상 칸 판별 함수가 컬럼이라는 말이 있는 대상만 읽음 | tools/Harness/verify/judge.py cascade_entities, _absent_ents(C2) | 해당없음(대상 칸 없음) |
| G | 3 | 측정 계정 언어 KO. 버튼 라벨 LBL00872 EN Input, KO 입력(사내 오라클 SCM_ADM_MSG_M 16:5x 조회). 검사기가 영문 Input 만 찾음 | tools/E2E/lib/labeltrans.ts(신규), Doc/e2e/specs/eg_popup.spec.ts 버튼 이름 후보 | 다음 CheckList 에서 Input 팝업 열림 실측. V-180ef854, V-b2d03a00 은 EG-5ca14a48 을 이어받음 |
| H | 2 | 다른 화면 E2E 동시 실행으로 언어 전환 생략(T200). 11-19 15:4x 언어 전환 전용 계정(langacct.ts, adminPool)으로 보완됨 | 이번 라운드 수정 없음(다른 세션 보완분) | 다음 CheckList 에서 전용 계정으로 실측 |

## 결정 목록으로 보낸 묶음

| 결정 | 행 수 | 원인 |
|---|---|---|
| D1 | 4 | 저장 표본 값이 저장 전 검증에 막힘(F1, F2, F4, F6). 같은 실행이 BE 정지 구간과 겹쳐 원인 미확인 |
| D2 | 4 | 기존 행 필수 칸 공란 저장. TO-BE 는 공란 뒤 수정 상태 없음 또는 M, 안내 수정한 내용이 없습니다. AS-IS SaveData 는 M 행이 LOT_SIZE, INCREMENT 공란이고 VALID_YN Y, SPLIT_YN N 이면 수정 취소(cs:583~590). 한 칸만 비운 경우 AS-IS 동작 미확인 |
| D3 | 10 | 콤보 재조회(B7). 저장 SP SCP0028_SAVE_SHIPMENT_LOT_SIZE 대상 표 SCP_MST_SHIPMENT_LOT_SIZE 가 콤보 원천 9종과 겹치지 않음. 재진입 때 admin/combo 12건 재조회 실측 통과. 원천 미확인 1종 |
| D4 | 6 | 조회조건 Model. TO-BE Model 칸은 팝업 연결 텍스트(MaterialByDivisionModal, ShipmentLotSize.tsx:362~371). 검사기 입력값이 조회 요청 본문에 실리지 않음(G8, G9 측정 실패). CEP2065I-B 조회 결과에 ITEM_ID 밖 값 268종(다른 칸 검색 여부 미확인) |
| D5 | 2 | From Site 후보 0~1개. combo_oracle 실측은 Division 81 에서 30개. 같은 실행의 B 묶음(팝업 필수 알림, 메모)과 시각이 겹침 |
| D6 | 22 | 팝업 계열(H6, G5, M4, A6, F4, G4). 화면 진입, 조회 중 팝업 SP 호출 0건. 팝업 선택값 반영 시나리오 실행 경로 없음. TO-BE Model 팝업은 사용자 지시(2026-10-08)로 COM0013 MaterialByDivisionModal 이라 PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 TO-BE 에서 부르지 않음. AS-IS btnDelete_Click(cs:288~300)은 Form_Load("D") 뒤 ShowDialog 가 없어 팝업을 띄우지 않음 |
| D7 | 4 | 다른 화면 결함 유형 중 칸 이름이 SCP0028 칸과 겹침(AS From Site 와 From Site, Site, Active). 이름만으로 같은 칸인지 판별 불가 |
| D8 | 2 | AS-IS 팝업 호출 고정 플래그 _action_flag D, I 를 TO-BE 팝업에 넘기지 않음. TO-BE 는 setBatchMode(I, D)로 모드 전달(ShipmentLotSize.tsx:338~344) |
| D9 | 4 | MSG00031, MSG00284 는 FindDelete 경로 메시지. Delete 팝업 조회 시나리오 경로 없음 |
| D10 | 2 | golden.py 가 두 조회 SP 를 실행하지 못함. 실행 기록 미확인 |
| D11 | 2 | PR_GET_MNU_BTN_AUTH 정렬(A6), 시노님(DB-SYN) 검사 경로 없음. 공통 권한 SP |
| D12 | 1 | AS-IS EditButton SwitchLock(cs:229~235) 편집 모드. TO-BE 룰 CR-084, CR-093(편집 버튼 없음, 조회 즉시 편집) |
| D13 | 1 | AS-IS DeleteButton 은 활성 스프레드가 spdMain 이고 신규(I) 행일 때만 삭제(cs:211~227). 조회 전 프로브 미구현 |
| D14 | 1 | DIVISION_ID 병합 37행 Delete 뒤 D 표시 0, 알림 표시. AS-IS DeleteButton 은 신규 행만 삭제 |
| D15 | 1 | H2 배경색 조건(M 행, LOT_SIZE, INCREMENT 공란, VALID Y, SPLIT N)을 만족하는 행 0. Div 40 조회 265행 |
| D16 | 1 | I3 언어 전환 명칭 비교 검사기 없음 |
| D17 | 1 | check.js G03 화면 이벤트 배선 검사를 원장 행에 연결하는 경로 없음 |
| D18 | 1 | 화면 고정 한글 문구 useShipmentLotSizeValidation.ts:52 {0}은 {1} 보다 클 수 없습니다. |
| D19 | 1 | PKG_SCP0028 264줄 V_TOKEN_TAB 단건 SELECT INTO 빈 결과 처리 없음 |

## 행별

| 행 | 규칙 | 유형 | 묶음 |
|---|---|---|---|
| V-5a8ff1e6 | B1 | 검사기공백 | A |
| V-c428fc08 | C1 | 검사기공백 | A |
| V-ed697b1a | E3 | 검사기공백 | A |
| V-1f64fec6 | E4 | 재실행 | A |
| V-904e7990 | E4 | 검사기공백 | A |
| V-1f325f76 | F3 | 검사기공백 | A |
| V-1f9a60bb | F3 | 검사기공백 | A |
| V-477a4f36 | F3 | 검사기공백 | A |
| V-cbc2cee2 | F3 | 검사기공백 | A |
| V-eeb010ff | F3 | 검사기공백 | A |
| V-a1923fff | H10 | 검사기공백 | A |
| V-ca2072cf | I1 | 재실행 | A |
| V-394a3941 | C1 | 데이터전제 | B |
| V-0c97a0f1 | D6 | 데이터전제 | B |
| V-93d3cad9 | F3 | 검사기공백 | B |
| V-c0ff12d4 | F3 | 데이터전제 | B |
| V-de7a1fc2 | F3 | 검사기공백 | B |
| V-eac62d82 | F3 | 데이터전제 | B |
| V-eb42dcc1 | F3 | 데이터전제 | B |
| V-19c73c57 | D1 | 검사기공백 | C |
| V-19dbf57f | D1 | 검사기공백 | C |
| V-1b10da7b | D1 | 검사기공백 | C |
| V-49b74e1a | D1 | 검사기공백 | C |
| V-59056cd1 | D1 | 검사기공백 | C |
| V-5ee103c5 | D1 | 검사기공백 | C |
| V-807ce196 | D1 | 검사기공백 | C |
| V-954df2e5 | D1 | 검사기공백 | C |
| V-9b9267ff | D1 | 검사기공백 | C |
| V-9fb9cc94 | D1 | 검사기공백 | C |
| V-a75b28d5 | D1 | 검사기공백 | C |
| V-c06b9a84 | D1 | 검사기공백 | C |
| V-c70d377f | D1 | 검사기공백 | C |
| V-eba2b607 | D1 | 검사기공백 | C |
| V-fc3bd077 | D1 | 검사기공백 | C |
| V-fd77aa3c | D1 | 검사기공백 | C |
| EG-2ae4d809 | D4 | 미분류 | C |
| EG-ab8129bb | D4 | 미분류 | C |
| EG-cfe1f9a1 | D4 | 미분류 | C |
| V-a005cb70 | D4 | 검사기공백 | C |
| V-2a373e9a | E4 | 검사기공백 | C |
| V-16d1b2ea | E6 | 판단 | C |
| V-5349b028 | E6 | 판단 | C |
| V-e9ab7986 | E6 | 판단 | C |
| ES-e9b7d3ac | F1 | 데이터전제 | C |
| V-4edb4ebc | H3 | 검사기공백 | C |
| V-b9707c91 | B1 | 판단 | D |
| V-af96562f | B2 | 검사기공백 | D |
| V-d081074c | B3 | 검사기공백 | D |
| V-2c13dbe7 | B4 | 검사기공백 | D |
| V-5d06fca9 | B6 | 검사기공백 | D |
| V-602d9026 | G1 | 검사기공백 | D |
| V-00ec53f0 | G7 | 검사기공백 | D |
| V-e91ea18c | H5 | 검사기공백 | D |
| V-4121e73d | F1 | 검사기공백 | D1 |
| V-970e2243 | F2 | 검사기공백 | D1 |
| V-899509b0 | F4 | 검사기공백 | D1 |
| V-7a589536 | F6 | 검사기공백 | D1 |
| V-8da88867 | A7 | 검사기공백 | D10 |
| V-ee003a13 | A7 | 검사기공백 | D10 |
| T-6dc0e2d5 | A6 | 판단 | D11 |
| T-52d59336 | DB-SYN | 검사기공백 | D11 |
| V-b1aa0c11 | D1 | 검사기공백 | D12 |
| V-b48e5d97 | D4 | 판단 | D13 |
| V-564a1ac4 | F5 | 판단 | D14 |
| V-a99ddb18 | H2 | 데이터전제 | D15 |
| V-d629e9b7 | I3 | 검사기공백 | D16 |
| T-522ba284 | G03-WIRE | 검사기공백 | D17 |
| EG-bd80125c | MS1 | 판단 | D18 |
| EG-f71f5543 | F4 | 판단 | D19 |
| V-a5e26726 | E3 | 검사기공백 | D2 |
| V-d7cde174 | E3 | 검사기공백 | D2 |
| V-d9f71764 | E3 | 검사기공백 | D2 |
| V-fbb3bbaf | E3 | 검사기공백 | D2 |
| V-02cca4b6 | B7 | 판단 | D3 |
| V-13254dec | B7 | 판단 | D3 |
| V-3625f78e | B7 | 판단 | D3 |
| V-4625c728 | B7 | 판단 | D3 |
| V-4f2b09d7 | B7 | 판단 | D3 |
| V-81f7459d | B7 | 판단 | D3 |
| V-8c12aeea | B7 | 판단 | D3 |
| V-e3cbb602 | B7 | 판단 | D3 |
| V-e7534976 | B7 | 판단 | D3 |
| V-fcba9999 | B7 | 판단 | D3 |
| V-6f2c58ff | G1 | 판단 | D4 |
| V-9e2b9258 | G1 | 검사기공백 | D4 |
| V-db17a330 | G2 | 검사기공백 | D4 |
| V-99331be4 | G5 | 검사기공백 | D4 |
| V-93e5a09c | G8 | 미분류 | D4 |
| V-ed2ee896 | G9 | 미분류 | D4 |
| V-dd4f9db4 | G1 | 미분류 | D5 |
| V-ff037ad7 | G2 | 미분류 | D5 |
| T-2c20a3fc | A6 | 검사기공백 | D6 |
| T-653f1a5d | A6 | 검사기공백 | D6 |
| T-a9985ef6 | F4 | 검사기공백 | D6 |
| T-f43dac0f | F4 | 검사기공백 | D6 |
| T-fad117f6 | F4 | 검사기공백 | D6 |
| T-d6ad4a4e | G4 | 검사기공백 | D6 |
| T-247bdc3c | G5 | 검사기공백 | D6 |
| T-3dbd9fe5 | G5 | 검사기공백 | D6 |
| T-57afcab2 | G5 | 검사기공백 | D6 |
| T-0855373f | H6 | 검사기공백 | D6 |
| T-449b82ac | H6 | 검사기공백 | D6 |
| T-a239a7e1 | H6 | 검사기공백 | D6 |
| T-c7a94f1d | H6 | 검사기공백 | D6 |
| V-db0f51c6 | H6 | 검사기공백 | D6 |
| EG-ea38ffcb | M4 | 판단 | D6 |
| T-2a9cd623 | M4 | 판단 | D6 |
| T-41bb3f1f | M4 | 판단 | D6 |
| T-5bb8509f | M4 | 판단 | D6 |
| T-84c5ee4c | M4 | 판단 | D6 |
| T-8ef356b6 | M4 | 판단 | D6 |
| T-ba663c76 | M4 | 판단 | D6 |
| T-c5782dcb | M4 | 판단 | D6 |
| V-2611b990 | C2 | 검사기공백 | D7 |
| V-9b370c0f | C2 | 검사기공백 | D7 |
| V-e9891c92 | C2 | 검사기공백 | D7 |
| V-f3e94ee4 | C2 | 검사기공백 | D7 |
| V-480372c9 | G5 | 판단 | D8 |
| V-86b2f489 | G5 | 판단 | D8 |
| T-0caf6c62 | E4 | 검사기공백 | D9 |
| T-4677b9e5 | E4 | 검사기공백 | D9 |
| V-86e7f1e2 | G1 | 검사기공백 | D9 |
| V-a89007be | G1 | 검사기공백 | D9 |
| V-617fdf8b | H5 | 검사기공백 | E |
| V-73f41143 | H5 | 검사기공백 | E |
| V-9058bd2c | H5 | 검사기공백 | E |
| V-98ff27f3 | H5 | 검사기공백 | E |
| V-d4c01cb9 | H5 | 검사기공백 | E |
| V-e7e611bb | H5 | 검사기공백 | E |
| V-119cf5cb | SC1 | 검사기공백 | E |
| V-0b63cd50 | C2 | 검사기공백 | F |
| V-61dc6e5f | C2 | 검사기공백 | F |
| V-66cb7b8f | C2 | 검사기공백 | F |
| V-becafb26 | C2 | 검사기공백 | F |
| V-c0e2f43c | C2 | 검사기공백 | F |
| V-e50e09ac | C2 | 검사기공백 | F |
| EG-5ca14a48 | M3 | 미분류 | G |
| V-180ef854 | M3 | 미분류 | G |
| V-b2d03a00 | M3 | 미분류 | G |
| EG-393dff7e | I2 | 검사기공백 | H |
| EG-874e9a91 | I2 | 검사기공백 | H |
