# SCP0111 미검증 결정 목록 (2026-11-19 10:4x · 라운드 3 갱신)

- 앞 판 `_decisions_20261118.md`(05:46) D1~D8 · A1~A3 를 이어받고 D9~D11 을 더함
- 근거 칸의 룰 번호 = `tools/Harness/rules/tobe_rule_registry.csv`
- 라운드 3: D1·D5 = 판정필요로 추출(미검증 아님), D3 = AS-IS 원문 근거 해당없음, D7 = FAIL, D8 = 기존 제외 규칙 해당, D11 = 검사기 결함 해소. 다음 CheckList 에서 반영. 결정이 남은 번호 = D1, D4, D5, D6, D7, D9, D10, A1~A3

## 판정 기준

| 번호 | 행 | 정할 내용 | 근거 |
|---|---|---|---|
| D1 | V-171648d3 (H4) | 헤더 글자 잘림 5칸을 오류로 볼지(라운드 3: 판정필요로 추출, T102 선례) | OPERATION_GROUP 글자 68 > 칸 64px, CELL_CF 68 > 64, COMPANY_ID 66 > 64, UOM 39 > 37, SEQ_FLAG 71 > 59. CR-003 '기본 폭은 헤더 문구 길이 이상' 이면 FAIL. T102(SCP0037·SCP0016 v5 사용자 판정 '칸 폭은 사람 판정 영역') 이면 판정필요. 두 기준 중 하나를 정해야 기계 판정 가능 |
| D3 | V-23d0a714 (F5) | 라운드 3 처리: AS-IS DeleteButton 본문 없음 + TO-BE 알림 = 해당없음(T341). 결정 불필요 | 알림 '신규 입력 (Insert) 한 행만 삭제할 수 있습니다.'. AS-IS DeleteButton 본문 공백(cs:536~539). TO-BE = 저장 전 신규 행만 지움(사용자 지시 2026-10-13, IntegrationPsi.tsx 주석). CR-057 은 Active 컬럼 관리 화면 조건이라 이 화면에 그대로 맞지 않음 |
| D4 | V-028e36d9 (A2) | INCOTERMS 칸 신규 행 콤보 후보에 FCA 가 없는 것을 결함으로 볼지 | 라운드 3: A2(이름 표시)는 값=표시값 칸이라 해당없음(T338). 코드 표 SCM_ADM_LOOKUP_MASTER_DETAIL INCOTERMS 16행 중 FCA VALID_YN=Y(10:3x 조회). 화면 후보(BE 조회 코드 API 응답)에서 빠진 원인 미확인. 다음 CheckList 근거 칸에 후보 수가 기록됨 |
| D5 | EG-8451fc67, EG-caf2c4d2 (G4) | Model·Nick Name 팝업 조회조건 구성 차이를 TO-BE 룰로 볼지(라운드 3: 판정필요로 추출, 다른 화면 같은 유형 19행 14화면) | AS-IS SCM0002 조건 Model, Division, Site, Project ↔ TO-BE 공용 모달 Div(비활성), Operation Group(비활성), Material. CR-096 은 호출 인자만 TO-BE 룰로 정함. 조회조건 구성까지 넓힐지 결정 필요 |
| D6 | T-18374ec4, V-530425d0 (B4) | Plan Date 후보 AS-IS 0건 ↔ TO-BE 22건 | AS-IS 개발 DB Plan date 뷰 기준일 경과로 0행(11-16 기록). AS-IS 개발 DB 시험 데이터 추가 여부는 사용자 확인 사항 |
| D7 | EG-42d53d53 (MS1) | PROC 한글 문구 다국어 처리(라운드 3: FAIL 로 추출, 3337줄 RAISE_APPLICATION_ERROR) | PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN '[99010]동일한 데이터가 존재합니다.'. CR-008(3개 언어 등록). 고치면 PKG 보완(보완 단계 대상, 정합검증 단계에서는 보완 안 함) |
| D8 | EG-c892f15f (I1) | 라운드 3 처리: 11-18 i18n_static 제외 규칙 해당(화면 사용 MSG00002 1개, MSG00606 KO 문구 다름). 결정 불필요 | MSG00002, MSG00606 둘 다 '[EN] Saved successfully.'. CR-032(같은 문구 코드 1개). 두 코드가 AS-IS 에서 넘어온 코드인지 미확인 |
| D9 | ES-cd72403b (F1, 라운드 1 의 ES-0af2f16b 를 이은 행) | 신규 행 저장 시험 허용 여부 | cleanup_spec SCP0111 mode=editonly. 저장된 신규 행을 지울 키·삭제 경로 없음(저장 SP action I·M 만). restore_touched 는 기록 시각 뒤 minyonglee1 이 만든 행만 지움. jooyong026 등 다른 계정 저장분은 사내 DB 에 남음. 18:0x 실측: Insert 행 추가는 됨(그리드 1259 → 1260). 19:1x authcrud jooyong026 Div 40: 그리드 1898 → 1899 · 저장 시험 보류 |
| D10 | T-03071eab, T-ea67ed5b (F4) | 일반 저장(main/SAVE) 실저장 시험 계정 | ADMIN 아닌 저장 계정(SCP Planner bottle)만 main/SAVE 호출. 일반 저장 SP 는 BOM 하위 전극 행까지 가감(AS-IS SCP0111_SAVE_INTEGRATION_PSI 495·579·661·740줄 UPDATE). 복원기는 minyonglee1 변경 행만 되돌림. 다른 사람 계정 행을 계정 기준으로 되돌리면 그 사람이 직접 고친 값까지 지울 수 있음 |
| D11 | ES-f6cf77b0 (G4) | 라운드 3 처리: 검사기 결함 T339(전각·반각). 화면 문구 LBL01150 'Qty < 0'. 결정 불필요 | smoke: 조회조건 라벨 일치 5, 누락 1('Qty ＜ 0'), TO-BE 후보 [Qty ＜ 0, Qty ≥ 0]. CR-092·CR-077 해당 여부 미확인 |

## 계정

| 번호 | 행 | 필요한 계정 |
|---|---|---|
| A1 | EG-b3b45d64 (J4) · V-fd3610e5 (J4 결함원장 DM-247, 이번 보완으로 EG380 결과를 따름) | 메뉴 권한이 없는 GUEST 전용 계정 1개 |
| A2 | EG-03a69cb6 (A6) | SCP0111 칸 설정(TITLESET_USER)이 있는 계정과 없는 계정 1쌍 |
| A3 | EG-d39015d9 (A1) | AS-IS·TO-BE 양쪽에 Measure 칸 설정이 있는 같은 사용자 |
