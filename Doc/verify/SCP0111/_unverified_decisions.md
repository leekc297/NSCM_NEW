# SCP0111 미검증 결정 목록 (2026-11-19 12:4x · 라운드 4 갱신)

- 앞 판 `_decisions_20261118.md`(05:46) D1~D8 · A1~A3 를 이어받고 D9~D11 을 더함
- 근거 칸의 룰 번호 = `tools/Harness/rules/tobe_rule_registry.csv`
- 라운드 4(12:4x): D6 = 검사기 결함 T343 으로 확인, 결정 불필요. D10 = 검사기 보완 T344(같은 계정 세션 그룹 재현)로 대체, D12 에 측정 방식 확인만 남김. 결정이 남은 번호 = D1, D4, D5, D7, D9, D12, A1~A3
- 라운드 3: D1·D5 = 판정필요로 추출(미검증 아님), D3 = AS-IS 원문 근거 해당없음, D7 = FAIL, D8 = 기존 제외 규칙 해당, D11 = 검사기 결함 해소. 다음 CheckList 에서 반영. 결정이 남은 번호 = D1, D4, D5, D6, D7, D9, D10, A1~A3

## 판정 기준

| 번호 | 행 | 정할 내용 | 근거 |
|---|---|---|---|
| D1 | V-171648d3 (H4) | 헤더 글자 잘림 5칸을 오류로 볼지(라운드 3: 판정필요로 추출, T102 선례) | OPERATION_GROUP 글자 68 > 칸 64px, CELL_CF 68 > 64, COMPANY_ID 66 > 64, UOM 39 > 37, SEQ_FLAG 71 > 59. CR-003 '기본 폭은 헤더 문구 길이 이상' 이면 FAIL. T102(SCP0037·SCP0016 v5 사용자 판정 '칸 폭은 사람 판정 영역') 이면 판정필요. 두 기준 중 하나를 정해야 기계 판정 가능 |
| D3 | V-23d0a714 (F5) | 라운드 3 처리: AS-IS DeleteButton 본문 없음 + TO-BE 알림 = 해당없음(T341). 결정 불필요 | 알림 '신규 입력 (Insert) 한 행만 삭제할 수 있습니다.'. AS-IS DeleteButton 본문 공백(cs:536~539). TO-BE = 저장 전 신규 행만 지움(사용자 지시 2026-10-13, IntegrationPsi.tsx 주석). CR-057 은 Active 컬럼 관리 화면 조건이라 이 화면에 그대로 맞지 않음 |
| D4 | V-028e36d9 (A2) | INCOTERMS 칸 신규 행 콤보 후보에 FCA 가 없는 것을 결함으로 볼지 | 라운드 3: A2(이름 표시)는 값=표시값 칸이라 해당없음(T338). 코드 표 SCM_ADM_LOOKUP_MASTER_DETAIL INCOTERMS 16행 중 FCA VALID_YN=Y(10:3x 조회). 화면 후보(BE 조회 코드 API 응답)에서 빠진 원인 미확인. 다음 CheckList 근거 칸에 후보 수가 기록됨 |
| D5 | EG-8451fc67, EG-caf2c4d2 (G4) | Model·Nick Name 팝업 조회조건 구성 차이를 TO-BE 룰로 볼지(라운드 3: 판정필요로 추출, 다른 화면 같은 유형 19행 14화면) | AS-IS SCM0002 조건 Model, Division, Site, Project ↔ TO-BE 공용 모달 Div(비활성), Operation Group(비활성), Material. CR-096 은 호출 인자만 TO-BE 룰로 정함. 조회조건 구성까지 넓힐지 결정 필요 |
| D6 | T-18374ec4, V-530425d0 (B4) | 라운드 4 처리: 결정 불필요. 검사기 결함 T343 | 지난 라운드 원인(AS-IS 뷰 기준일 경과)은 틀렸음. 12:3x AS-IS 개발 DB 직접 실행: DATE_WEEKLY1 사업부 81 13건(20260601~20260824), SCP_PLAN_VERSION_V 사업부 81 FN 12건. combo_oracle 이 필터식 이어 붙이기('" + division + "')를 글자 그대로 비교해 0건으로 기록함. 다음 CheckList 에서 AS-IS 12건 또는 13건과 TO-BE 22건을 비교함 |
| D7 | EG-42d53d53 (MS1) | PROC 한글 문구 다국어 처리(라운드 3: FAIL 로 추출, 3337줄 RAISE_APPLICATION_ERROR) | PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN '[99010]동일한 데이터가 존재합니다.'. CR-008(3개 언어 등록). 고치면 PKG 보완(보완 단계 대상, 정합검증 단계에서는 보완 안 함) |
| D8 | EG-c892f15f (I1) | 라운드 3 처리: 11-18 i18n_static 제외 규칙 해당(화면 사용 MSG00002 1개, MSG00606 KO 문구 다름). 결정 불필요 | MSG00002, MSG00606 둘 다 '[EN] Saved successfully.'. CR-032(같은 문구 코드 1개). 두 코드가 AS-IS 에서 넘어온 코드인지 미확인 |
| D9 | ES-cd72403b (F1, 라운드 1 의 ES-0af2f16b 를 이은 행) | 신규 행 저장 시험 허용 여부 | cleanup_spec SCP0111 mode=editonly. 저장된 신규 행을 지울 키·삭제 경로 없음(저장 SP action I·M 만). restore_touched 는 기록 시각 뒤 minyonglee1 이 만든 행만 지움. jooyong026 등 다른 계정 저장분은 사내 DB 에 남음. 18:0x 실측: Insert 행 추가는 됨(그리드 1259 → 1260). 19:1x authcrud jooyong026 Div 40: 그리드 1898 → 1899 · 저장 시험 보류 |
| D10 | T-03071eab, T-ea67ed5b (F4) | 라운드 4 처리: 검사기 보완 T344 로 대체. 측정 방식 확인은 D12 | 다른 계정 실저장 대신 같은 시험 계정(minyonglee1)으로 세션 그룹에서 'System Administrator' 를 빼고 수정 저장. 일반 저장 SP 가 쓰는 표 = SCP_ANL_PSI_INTEGRATION 1개, 전 행 LAST_UPDATED_BY = 저장 계정이라 restore_touched 가 되돌림 |
| D12 | T-03071eab, T-ea67ed5b (F4) | 세션 그룹 재현(T344)으로 잰 main/SAVE 판정을 일반 저장 계정의 판정으로 인정할지 | 화면 분기만 바꿈(서버 권한·DB 그대로). 요청 본문은 일반 저장 계정과 같은 함수(buildGeneralPayload)가 만듦. 저장 사용자 칸 = minyonglee1. 증거 머리말 '[세션 그룹 재현 T344 …]' 로 구분됨. 인정하지 않으면 실제 SCP Planner 계정 시험이 필요함(D10 원래 문제) |
| D11 | ES-f6cf77b0 (G4) | 라운드 3 처리: 검사기 결함 T339(전각·반각). 화면 문구 LBL01150 'Qty < 0'. 결정 불필요 | smoke: 조회조건 라벨 일치 5, 누락 1('Qty ＜ 0'), TO-BE 후보 [Qty ＜ 0, Qty ≥ 0]. CR-092·CR-077 해당 여부 미확인 |

## 계정

| 번호 | 행 | 필요한 계정 |
|---|---|---|
| A1 | EG-b3b45d64 (J4) · V-fd3610e5 (J4 결함원장 DM-247, 이번 보완으로 EG380 결과를 따름) | 메뉴 권한이 없는 GUEST 전용 계정 1개 |
| A2 | EG-03a69cb6 (A6) | SCP0111 칸 설정(TITLESET_USER)이 있는 계정과 없는 계정 1쌍 |
| A3 | EG-d39015d9 (A1) | AS-IS·TO-BE 양쪽에 Measure 칸 설정이 있는 같은 사용자 |

## CheckList v64 사용자의견 반영 뒤 결정 (2026-11-19 13:4x)

| 번호 | 행 | 정할 내용 | 근거 |
|---|---|---|---|
| D13 | V-fd3610e5, EG-45ade04a (J4) | 앱 공통 결함(DM-247 Home 권한 신청 화면 미표시)을 어디서 관리할지 | 화면 CheckList 에서는 해당없음으로 빼고 측정 결과는 `Doc/verify/_app_level_results.csv` 에 남김. 11-19 측정: 권한 없는 계정 로그인 뒤 URL /view/home, Auth Request 화면 미표시(FAIL). 공통 결함 목록이나 Home 화면 CheckList 중 관리 위치 미정 |
| D14 | V-daa3f0ba (D6) | TO-BE Insert 위치(고른 칸 병합 묶음 아래)를 TO-BE 룰로 둘지 | 원장 룰 CR-015 '선택 행 위'와 다름. 사용자의견 '확인 필요'. 지금은 FAIL 유지, 가이드 G9 로 'above' 변경 제안. TO-BE 룰로 정하면 CR-015 예외 등록 필요 |
