# SCP0111 Integration PSI 결정 필요 목록 (2026-11-18)

## 판정 기준

| 번호 | 검증ID | 규칙 | 내용 | 실측 | 권장 |
|---|---|---|---|---|---|
| D1 | V-171648d3 | H4 | 헤더 글자 잘림 5칸 | OPERATION_GROUP 글자 68 > 칸 64px, CELL_CF 68 > 64, COMPANY_ID 66 > 64, UOM 39 > 37, SEQ_FLAG 71 > 59 | SCP0016 선례대로 오류 아님 |
| D2 | T-7e4b2b41 | K4 | Delete 버튼 노출 | AS-IS 버튼 Search, Insert, Save. AS-IS DeleteButton 본문 공백(cs:536). TO-BE Delete = 저장 전 신규 행만 지움(사용자 지시 2026-10-13, IntegrationPsi.tsx 주석) | 사용자 지시 기능이라 오류 아님 |
| D3 | V-23d0a714 | F5 | 병합 셀 Delete | PLAN_TYPE 병합 37행 선택 Delete → D 표시 0, 알림 '신규 입력 (Insert) 한 행만 삭제할 수 있습니다.' | D2 와 같은 근거로 오류 아님 |
| D4 | V-028e36d9 | A2 | INCOTERMS 'FCA' 코드 그대로 표시 | 콤보 칸 3개 중 1칸, INCOTERMS 26행이 후보에 없는 'FCA' | 기준 코드 FCA 비활성 여부 확인 필요 |
| D5 | EG-8451fc67, EG-caf2c4d2 | G4 | Model/Nickname 팝업 조회조건 구성 | AS-IS SCM0002 조건 Model, Division, Site, Project ↔ TO-BE 공용 모달 Div(비활성), Operation Group(비활성), Material | CR-096(공용 모달 인자)을 조회조건 구성까지 넓혀 오류 아님 |
| D6 | V-530425d0 | B4 | Plan Date 후보 | AS-IS 0건 ↔ TO-BE 22건. AS-IS 개발 DB Plan date 뷰 기준일 경과(11-16 기록) | 데이터 차이(CR-101) 판정필요 유지 |
| D7 | EG-42d53d53 | MS1 | PROC 한글 문구 | PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN '[99010]동일한 데이터가 존재합니다.' | 다국어 등록 확인 필요 |
| D8 | EG-c892f15f | I1 | 같은 문구 다른 코드 | MSG00002, MSG00606 '[EN] Saved successfully.' | 다국어 등록 확인 필요 |

## 계정

| 번호 | 검증ID | 규칙 | 필요한 계정 |
|---|---|---|---|
| A1 | EG-b3b45d64 | J4 | 메뉴 권한이 없는 GUEST 전용 계정 1개(첫 화면 Auth Request 확인) |
| A2 | EG-03a69cb6 | A6 | SCP0111 칸 설정(TITLESET_USER)이 있는 계정과 없는 계정 1쌍 |
| A3 | EG-d39015d9 | A1 | AS-IS·TO-BE 양쪽에 Measure 칸 설정이 있는 같은 사용자 |
