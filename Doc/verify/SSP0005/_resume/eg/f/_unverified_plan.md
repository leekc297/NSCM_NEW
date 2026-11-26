# SSP0005 미검증 처리 목록, 라운드 1

- 기준 원장 Doc/verify/SSP0005/verify_ledger.csv(2026-11-20 09:29), 분류 unverified_triage.csv(2026-11-20 09:36:54) 313행(원장 미검증 278행 + AI 검토 대상 35행)
- 조치 구분 행 수: 보완 142, 집계 111, 결정 36, 미처리 23, 자동 1
- 처리 순서: 행 수가 많은 묶음부터(0행 데이터전제 → X-REASON → 차등짝 → 재실행 → 정렬 → 실전송 건수)

| 행 ID | 출처 | 규칙 | 유형 | 담당 | 대상 | 조치 | 원인 | 고칠 곳 |
|---|---|---|---|---|---|---|---|---|
| AD-7fa173fd | ASIS_DIFF | A1 | 차등짝 | 엔진 | SSP0005 SSP0005_GET_SHIPMENT_WORKING_DAY 결과 행·키 집합(공통 , AS- | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| AD-ba7411e8 | ASIS_DIFF | A1 | 차등짝 | 엔진 | SSP0005 SSP0005_GET_SHIPMENT_WORKING_DAY 결과 행·키 집합(공통 , AS- | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| AD-eea2b59a | ASIS_DIFF | A1 | 차등짝 | 엔진 | SSP0005 SCP0009_GET_SHEET_CALENDAR_3SPAN 결과 행·키 집합(공통 , AS- | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| EG-57ab9048 | RULE_SCREEN | A1 | AI검토:검사기오판 | 엔진 | SSP0005 실전송 건수 calendar | 보완 | 실전송 건수 시험이 그리드 행 수와 응답 행 수가 같은 호출을 기록 | _verify.spec.ts 실전송 건수(A1) T473 |
| V-494abd53 | RULE_SCREEN | A10 | 데이터전제 | 엔진 | SSP0005 조회 전 합계 행 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-7d9d415a | RULE_SCREEN | A2 | 검사기공백 | 엔진 | SSP0005 편집기 표시값 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-8a24338f | COLUMN | A2 | 데이터전제 | 엔진 | Shipment Working Day.COMPANY_ID (Company) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| AD-193ba11d | ASIS_DIFF | A5 | 차등짝 | 엔진 | SSP0005 SCP0009_GET_SHEET_CALENDAR_3SPAN 결과 컬럼 집합(AS-IS 전용   | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| AD-3cb5dabc | ASIS_DIFF | A5 | 차등짝 | 엔진 | SSP0005 SSP0005_GET_SHIPMENT_WORKING_DAY 결과 컬럼 집합(AS-IS 전용   | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| AD-9dd5b272 | ASIS_DIFF | A5 | 차등짝 | 엔진 | SSP0005 SSP0005_GET_SHIPMENT_WORKING_DAY 결과 컬럼 집합(AS-IS 전용   | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| EG-2e54c4fd | RULE_SCREEN | A5 | 재실행 | 자동 | SSP0005 EG022 Div 선택 81 | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| EG-37030106 | RULE_SCREEN | A5 | 재실행 | 자동 | SSP0005 EG022 Div 선택 81_HG | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| EG-60b14ede | RULE_SCREEN | A5 | 재실행 | 자동 | SSP0005 EG022 Div 선택 81_HD | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| EG-84d3e691 | RULE_SCREEN | A5 | 재실행 | 자동 | SSP0005 EG022 Div 선택 81_ST | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| EG-b8bfb785 | RULE_SCREEN | A5 | 재실행 | 자동 | SSP0005 EG022 Div 선택 81_UC | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| EG-bce7e7d8 | RULE_SCREEN | A5 | 재실행 | 자동 | SSP0005 EG022 Div 선택 81_HM | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| EG-ebf04f16 | RULE_SCREEN | A5 | 재실행 | 자동 | SSP0005 EG022 Div 선택 82 | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| EG-f3ea711c | RULE_SCREEN | A5 | 재실행 | 자동 | SSP0005 EG022 Div 선택 40 | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| V-4245df49 | RULE_SCREEN | A5 | 데이터전제 | 엔진 | SSP0005 Division 컬럼 81/Shipment Working Day | 보완 | Div 선택 뒤 0행이면 Division 외 단일 선택 조건 후보 순회 | _verify.spec.ts Division 컬럼 + sweepCondCombos T475 |
| V-6524b70e | RULE_SCREEN | A5 | 데이터전제 | 엔진 | SSP0005 Division 컬럼 82/Shipment Working Day | 보완 | Div 선택 뒤 0행이면 Division 외 단일 선택 조건 후보 순회 | _verify.spec.ts Division 컬럼 + sweepCondCombos T475 |
| V-a66d06d4 | RULE_SCREEN | A5 | 데이터전제 | 엔진 | SSP0005 Division 컬럼 40/Shipment Working Day | 보완 | Div 선택 뒤 0행이면 Division 외 단일 선택 조건 후보 순회 | _verify.spec.ts Division 컬럼 + sweepCondCombos T475 |
| AD-911abf41 | ASIS_DIFF | A6 | 차등짝 | 엔진 | SSP0005 SSP0005_GET_SHIPMENT_WORKING_DAY 공통·유일 행 상대 순서 | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| AD-c5e377e2 | ASIS_DIFF | A6 | 차등짝 | 엔진 | SSP0005 SCP0009_GET_SHEET_CALENDAR_3SPAN 공통·유일 행 상대 순서 | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| AD-f7788149 | ASIS_DIFF | A6 | 차등짝 | 엔진 | SSP0005 SSP0005_GET_SHIPMENT_WORKING_DAY 공통·유일 행 상대 순서 | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| T-09965270 | TRACE | A6 | 검사기공백 | 엔진 | P_SSP0005_GET | 보완 | 0행 해소 뒤 조회 경로 결과 실측 | smoke-extra.ts ensureRows T475 |
| T-267333fd | TRACE | A6 | 검사기공백 | 엔진 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY | 보완 | 0행 해소 뒤 조회 경로 결과 실측 | smoke-extra.ts ensureRows T475 |
| T-36da53a5 | TRACE | A6 | AI검토:검사기오판 | 엔진 | U01, `ProgressForm`(FindData_Main) cs:372 | 보완 | 변수 대입 SELECT 의 ORDER BY 를 결과 정렬 규칙에서 제외 | facts_sortrules.py assign_select T472 |
| T-3b42e295 | TRACE | A6 | AI검토:검사기오판 | 엔진 | B03, `Data.Common(Data.Type.LookupCommon, false, "WEEK_WORK | 보완 | 변수 대입 SELECT 의 ORDER BY 를 결과 정렬 규칙에서 제외 | facts_sortrules.py assign_select T472 |
| V-1b666fe8 | SP | A6 | AI검토:검사기오판 | 엔진 | SSP0005_GET_SHIPMENT_WORKING_DAY | 보완 | 변수 대입 SELECT 의 ORDER BY 를 결과 정렬 규칙에서 제외 | facts_sortrules.py assign_select T472 |
| V-4089d95c | SP | A6 | AI검토:검사기오판 | 엔진 | SSP0005_GET_SHIPMENT_WORKING_DAY | 보완 | 변수 대입 SELECT 의 ORDER BY 를 결과 정렬 규칙에서 제외 | facts_sortrules.py assign_select T472 |
| AD-4bd484b6 | ASIS_DIFF | A7 | 차등짝 | 엔진 | SSP0005 SSP0005_GET_SHIPMENT_WORKING_DAY 공통행 컬럼 값(공통 행, 불일치 | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| AD-6559b063 | ASIS_DIFF | A7 | 차등짝 | 엔진 | SSP0005 SCP0009_GET_SHEET_CALENDAR_3SPAN 공통행 컬럼 값(공통 행, 불일치 | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| AD-b4b0e70e | ASIS_DIFF | A7 | 차등짝 | 엔진 | SSP0005 SSP0005_GET_SHIPMENT_WORKING_DAY 공통행 컬럼 값(공통 행, 불일치 | 보완 | E2E 입력 시험 호출(Invalid Date)은 같은 프로시저 정상 인자 판정 호출이 있으면 원장 행 생성 안 함 | diff_ingest.py is_input_test_dup T471 |
| T-37d62dbc | TRACE | C3 | 데이터전제 | 엔진 | SUN | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-3912ade6 | TRACE | C3 | 데이터전제 | 엔진 | SAT | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-3e579fb8 | TRACE | C3 | 데이터전제 | 엔진 | DAY_CODE | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-542b856c | TRACE | C3 | 데이터전제 | 엔진 | P_LAST_ROW | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-94eb5239 | TRACE | C3 | 데이터전제 | 엔진 | P_FIRST_ROW | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-35395986 | TRACE | D1 | 데이터전제 | 엔진 | DIVISION_ID / Divison | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-4aa8e925 | TRACE | D1 | 데이터전제 | 엔진 | COMPANY_ID / Company | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-4c0fb1d3 | COLUMN | D1 | 데이터전제 | 엔진 | Shipment Working Day.<DYNAMIC:LOOP> (동적 LOOP 컬럼) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-689c2134 | RULE_SCREEN | D1 | 데이터전제 | 엔진 | SSP0005 편집 모드 구분 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-a7ff1087 | COLUMN | D1 | 데이터전제 | 엔진 | Shipment Working Day.COMPANY_ID (Company) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-e60b34c2 | COLUMN | D1 | 데이터전제 | 엔진 | Shipment Working Day.DIVISION_ID (Divison) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-664e9248 | RULE_SCREEN | D2 | 데이터전제 | 엔진 | SSP0005 시나리오 [자동] 값 있는 편집 구간 수량 셀 편집 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-1f2690f4 | ASIS | D3 | 데이터전제 | 엔진 | COMPANY,DIVISION | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-4a7ffdbe | ASIS | D3 | 데이터전제 | 엔진 | siMain.SwitchLock | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-3a321dcf | RULE_SCREEN | D6 | 데이터전제 | 엔진 | SSP0005 시나리오 [자동] 선택 행 위로 Insert | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-59de933f | TRACE | E4 | 데이터전제 | 엔진 | MSG00134 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-bc60d5c7 | TRACE | E4 | 데이터전제 | 엔진 | cboInputValue / Input Value | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-c61b1188 | TRACE | E4 | 데이터전제 | 엔진 | MSG00093 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-cd6386c9 | TRACE | E4 | 데이터전제 | 엔진 | MSG00004 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-d9af9685 | TRACE | E4 | 데이터전제 | 엔진 | MSG00004 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-f5e2b116 | TRACE | E4 | 데이터전제 | 엔진 | MSG00093 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-f6d2008f | TRACE | E4 | 데이터전제 | 엔진 | MSG00134 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-8bcce9c3 | RULE_SCREEN | E4 | 데이터전제 | 엔진 | SSP0005 시나리오 [자동] 기존 행 동적 기간 칸 수정 저장 → 입력된 필수 칸 오탐 없음 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-1598bbba | COLUMN | E5 | 데이터전제 | 엔진 | Shipment Working Day.COMPANY_ID (Company) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-23be0292 | RULE_SCREEN | E5 | 데이터전제 | 엔진 | SSP0005 입력검증 콤보붙여넣기 COMPANY_ID | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-3f39ad5f | RULE_SCREEN | E5 | 데이터전제 | 엔진 | SSP0005 입력검증 콤보키인 COMPANY_ID | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-dc2837b7 | RULE_SCREEN | E6 | 데이터전제 | 엔진 | SSP0005 화면 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-45ceb78a | RULE_SCREEN | F1 | 검사기공백 | 엔진 | SSP0005 화면 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-657eef0e | RULE_SCREEN | F1 | 데이터전제 | 엔진 | SSP0005 컬럼별 저장 왕복 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-e4f681b2 | RULE_SCREEN | F1 | 데이터전제 | 엔진 | SSP0005 2행 동시 저장 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-f8bcc179 | RULE_SCREEN | F1 | 데이터전제 | 엔진 | SSP0005 저장 실패 처리 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-5c9fabe3 | RULE_SCREEN | F2 | 검사기공백 | 엔진 | SSP0005 화면 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-75c9d6f8 | RULE_SCREEN | F2 | 데이터전제 | 엔진 | SSP0005 붙여넣기 저장 인식 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-f1230888 | TRACE | F3 | 데이터전제 | 엔진 | SSP0005 화면 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-6ac126ba | RULE_SCREEN | F3 | 검사기공백 | 엔진 | SSP0005 붙여넣기 후보 외 값 | 보완 | 0행 해소 뒤 편집 가능한 콤보 칸(D_ 일자) 측정 | smoke-extra.ts ensureRows T475 |
| V-5f3d1aad | RULE_SCREEN | F4 | 검사기공백 | 엔진 | SSP0005 경계값 저장 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-860976f4 | RULE_SCREEN | F4 | 검사기공백 | 엔진 | SSP0005 화면 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-2bc6b855 | RULE_SCREEN | F6 | 검사기공백 | 엔진 | SSP0005 화면 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-2c074ac3 | RULE_SCREEN | F6 | 데이터전제 | 엔진 | SSP0005 빈값 저장 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-400f4037 | RULE_SCREEN | F6 | 검사기공백 | 엔진 | SSP0005 다른 셀 편집 값 유지 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-81b4003b | RULE_SCREEN | F6 | 검사기공백 | 엔진 | SSP0005 저장 행 수 불변 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-a14b0257 | RULE_SCREEN | F6 | 데이터전제 | 엔진 | SSP0005 0 값 저장 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-812d4edc | RULE_SCREEN | F7 | 검사기공백 | 엔진 | SSP0005 저장 연계·이력 표 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-a24a4e33 | RULE_SCREEN | F7 | 검사기공백 | 엔진 | SSP0005 저장 연계 테이블 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-b4363ff6 | RULE_SCREEN | F7 | 검사기공백 | 엔진 | SSP0005 2회 저장 행 수 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-49200bb3 | RULE_SCREEN | F8 | 검사기공백 | 엔진 | SSP0005 수정 감사 컬럼 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-5be74c34 | RULE_SCREEN | F8 | 검사기공백 | 엔진 | SSP0005 이력 행 값 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-99b4da5e | RULE_SCREEN | F8 | 검사기공백 | 엔진 | SSP0005 저장 감사 필드 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-9bf88d42 | SEARCH | G1 | 데이터전제 | 엔진 | 조회조건 Div | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| EG-c88c7559 | RULE_SCREEN | G4 | 재실행 | 자동 | SSP0005 EG271 Div 선택 81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG | 보완 | 다중 선택 Division 선택(비우고 고름, 칩으로 확인) | authprobe.ts selectDiv T474 |
| V-8051ecab | SEARCH | G8 | 데이터전제 | 엔진 | 조회조건 Period | 보완 | 0행 해소(ensureRows). 기간 조건 대상 선정 문제는 D-09 | smoke-extra.ts ensureRows T475 |
| V-a6d90c80 | RULE_SCREEN | H10 | 데이터전제 | 엔진 | SSP0005 저장 취소 요청 없음 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-d9d4b814 | RULE_SCREEN | H10 | 데이터전제 | 엔진 | SSP0005 시나리오 [자동] 편집 중 Input 실행 → MSG00680(DM-52 일반 규칙) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-66b6fe9a | RULE_SCREEN | H11 | 데이터전제 | 엔진 | SSP0005 저장 중 로딩 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-ce9bc8df | RULE_SCREEN | H2 | 데이터전제 | 엔진 | SSP0005 시나리오 [자동] 당주 구분선(rail) = 이번 주(Weekly) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-edb955cc | RULE_SCREEN | H4 | 데이터전제 | 엔진 | SSP0005 불필요 스크롤 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-d75aa24b | RULE_SCREEN | I1 | 데이터전제 | 엔진 | SSP0005 시나리오 [자동] KO 언어, 변경 없이 저장 → KO 수정사항 없음 알림 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| EG-2c4e83cb | RULE_SCREEN | I2 | 데이터전제 | 엔진 | SSP0005 언어 전환 EN 데이터 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| EG-fd4f5b54 | RULE_SCREEN | I2 | 데이터전제 | 엔진 | SSP0005 언어 전환 CN 데이터 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| ES-b745a06c | RULE_SCREEN | J1 | 데이터전제 | 엔진 | SSP0005 E2E auth Division 40 조회, 계정 40:SSP Viewer | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-005bcedc | GENERAL | K1 | 데이터전제 | 엔진 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-1503b652 | GENERAL | K1 | 데이터전제 | 엔진 | [DMF0020 결함 일반화] 그리드 Sort 토글(동적 영역 포함) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-19a015ce | CONFIRMED | K1 | 데이터전제 | 엔진 | 그리드 필터(F4) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-1a01a3a5 | DEFECT | K1 | 데이터전제 | 엔진 | 그리드 필터(F4) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-63c6cabf | RULE_SCREEN | K1 | 데이터전제 | 엔진 | SSP0005 필터 편집기 항목 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-679f5030 | RULE_SCREEN | K1 | 검사기공백 | 엔진 | SSP0005 동적 칸 정렬·필터 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-6adc17b7 | DEFECT | K1 | 데이터전제 | 엔진 | 전체 팝업 No. 컬럼·건수, Contribution Sales Version 팝업 그리드 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-6bee414b | RULE_SCREEN | K1 | 검사기공백 | 엔진 | SSP0005 정렬 상태 Copy·Hide | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-8cf4cffe | RULE_SCREEN | K1 | 데이터전제 | 엔진 | SSP0005 화면 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-a3ff3769 | CONFIRMED | K1 | 데이터전제 | 엔진 | 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-a90f96f3 | GENERAL | K1 | 데이터전제 | 엔진 | [DMF0020 결함 일반화] 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-ab7531bf | GENERAL | K1 | 데이터전제 | 엔진 | [DMF0053 결함 유형] 팝업 Filter 텍스트 입력창 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-bd8c9a68 | GENERAL | K1 | 데이터전제 | 엔진 | [DMF0068 결함 일반화] Insert 시 Project 컬럼, Sort | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-c97c566d | GENERAL | K1 | 데이터전제 | 엔진 | [DMF0004 결함 일반화] Company 컬럼 공란 데이터 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-d0bc918a | CONFIRMED | K1 | 데이터전제 | 엔진 | 그리드 필터 유지 재조회 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-df027667 | GENERAL | K1 | 데이터전제 | 엔진 | [COM0007 결함 일반화] Message ID 컬럼 필터 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-e67fd879 | CONFIRMED | K1 | 데이터전제 | 엔진 | 그리드 Sort 토글(동적 영역 포함) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-f331200e | GENERAL | K1 | 데이터전제 | 엔진 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-fdf43251 | CONFIRMED | K1 | 데이터전제 | 엔진 | Message ID 컬럼 필터 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| EG-0e3461e7 | RULE_SCREEN | K2 | 데이터전제 | 엔진 | SSP0005 EG395 SSP0005 저장 후 비움 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-64d012df | CONFIRMED | K3 | 데이터전제 | 엔진 | 그리드 헤더 클릭 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-947aac49 | GENERAL | K3 | 데이터전제 | 엔진 | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-a8f53080 | RULE_SCREEN | K3 | 데이터전제 | 엔진 | SSP0005 화면 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-aad488f0 | GENERAL | K3 | 데이터전제 | 엔진 | [결함 유형 묶음 K3-G02, 2건] 조회 단축키(F5) 실행 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-ded146fb | DEFECT | K3 | 데이터전제 | 엔진 | 그리드 헤더 클릭 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-e248d2d6 | GENERAL | K3 | 데이터전제 | 엔진 | [결함 유형 묶음 K3-G01, 1건] 그리드 Ctrl+클릭 다중 선택(팝업 그리드 포함) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-ea863b45 | DEFECT | K3 | 데이터전제 | 엔진 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-f1eec983 | DEFECT | K3 | 데이터전제 | 엔진 | 전체 팝업 No. 컬럼·건수, Contribution Sales Version 팝업 그리드 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-f4089525 | CONFIRMED | K3 | 데이터전제 | 엔진 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-11d06153 | RULE_SCREEN | L1 | 검사기공백 | 엔진 | SSP0005 저장 응답 시간 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-5564070a | RULE_SCREEN | L1 | 검사기공백 | 엔진 | SSP0005 방향키 누적 지연 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| V-b2cf061d | RULE_SCREEN | N1 | 검사기공백 | 엔진 | SSP0005 센티널 표시 | 보완 | Company 기본값 AA00 0행. Division 순회 콤보 선택 결함 수정 + Division 외 단일 선택 조건 후보 순회 | smoke-extra.ts ensureRows·sweepCondCombos T475 |
| T-1ea37b47 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | G15, `GetModelColumnFromViewColumn`(cRow) | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-28ecf992 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | P08, `SpdMain_CellDoubleClick` cs:834 | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-3cba11de | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | C20, `components`(Container) | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-3e1a8559 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | G24, `Visible=`(`W_` → `D_` 토글) | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-3f48cc71 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | D10, `ds == null`(Changed) | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-42a775ce | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | D08, `ds == null` | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-5517ef41 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | A06, 저장 대상 = action AND 글자색 Red cs:491-492 | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-6fdb34a4 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | G16, `GetModelColumnFromViewColumn`(cCol) | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-916fbc3b | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | E04, `SpdMain_Changed` | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-a0874f0d | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | V07, `MSG00050` 숫자 형식 | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-af31c210 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | G22, `Visible=`(`M_` → `W_` 토글) | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-ba42a5a9 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | C11, `emptySpaceItem2` | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-bce780ad | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | P09, `SpdMain_Changed` cs:872 | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-bf54ef48 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | C10, `emptySpaceItem1` | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-c4b14de7 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | A09, `DefineProperty()` 빈 본문 cs:142-144 | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-d232213e | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | D09, `!CanModelChange`(Changed) | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| T-fb78b761 | TRACE | X-REASON | AI검토:검사기오판 | 엔진 | G23, `Visible=`(`M_` → `D_` 숨김) | 보완 | 대조표 TO-BE 칸 사유 판독(AS-IS 줄 인용 + 미이식 근거, 행 참조 상속) | mapping_trace.py reason_claim T470 |
| V-b263da2c | RULE_SCREEN | B1 | 검사기공백 | 엔진 | SSP0005 시나리오 [자동] 조회조건 콤보 2종 = 콤보 | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| V-fe598693 | SEARCH | B1 | 판단 | 판단 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| V-704a25d6 | SEARCH | B2 | 검사기공백 | 엔진 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| V-3eb21b5c | SEARCH | B3 | 검사기공백 | 엔진 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| EG-8fa997a6 | RULE_SCREEN | B4 | 판단 | 판단 | SSP0005 콤보 후보 활성 FP_MGR.SCM_COMPANY_M.COMPANY_ID/Company_SSP | 결정 | Company 후보 25건 비활성 판정. AS-IS 콤보 SQL Active 조건 미확인 | 결정 목록 D-05 |
| V-c851f50b | SEARCH | B4 | 검사기공백 | 엔진 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| V-ebc184b9 | SEARCH | B6 | 검사기공백 | 엔진 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| V-ec9e8596 | SEARCH | B7 | 판단 | 판단 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| EG-434d8ee2 | RULE_SCREEN | D4 | 미분류 | 엔진 | SSP0005 EG140 Insert Div 81 | 결정 | Insert 권한 있으나 버튼 비노출(D-04 와 같은 원인) | 결정 목록 D-04 |
| EG-49decbad | RULE_SCREEN | D4 | 미분류 | 엔진 | SSP0005 EG319 Insert Div 81 | 결정 | Insert 권한 있으나 버튼 비노출(D-04 와 같은 원인) | 결정 목록 D-04 |
| EG-be85b4af | RULE_SCREEN | D4 | 미분류 | 엔진 | SSP0005 EG126 Insert Div 81 | 결정 | Insert 권한 있으나 버튼 비노출(D-04 와 같은 원인) | 결정 목록 D-04 |
| V-6f1aea63 | ASIS | E4 | AI검토:검사기오판 | 엔진 | MSG00135 | 결정 | MSG00135 막기가 Bulk Update 모달 OK 단계(MSG00719)로 이동 | 결정 목록 D-07 |
| V-c9bd2b82 | SEARCH | G1 | 검사기공백 | 엔진 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| V-4ee21f62 | SEARCH | G2 | 검사기공백 | 엔진 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| V-dd7c2ad9 | RULE_SCREEN | G4 | 스냅샷승인 | 사람 | SSP0005 스냅샷 조회조건 Div 40 | 결정 | 스냅샷 승인 보류. snap_validate MISMATCH | 결정 목록 D-01 |
| V-9c955342 | RULE_SCREEN | G6 | 판단 | 판단 | SSP0005 조회조건 초기값 | 결정 | Division 초기값 ALL(placeholder) 판독 | 결정 목록 D-06 |
| V-f6f2c4b9 | SEARCH | G7 | 검사기공백 | 엔진 | 조회조건 Plant Site | 결정 | 조회조건 기준표 968행 Plant Site(다중, ALL버튼)와 AS-IS, TO-BE Company(단일) 차이 | 결정 목록 D-03 |
| EG-36e64c07 | RULE_SCREEN | J1 | 판단 | 판단 | SSP0005 EG366 Division 후보 SSP/81/SSP Viewer | 결정 | Division 후보 EE 누락(Division 원장 유효값 밖) | 결정 목록 D-06 |
| EG-158532ce | RULE_SCREEN | J2 | 판단 | 판단 | SSP0005 EG374 DELETE 버튼 조회 전 SSP/81/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-15a9733a | RULE_SCREEN | J2 | 판단 | 판단 | SSP0005 EG374 INSERT 버튼 조회 전 SSP/82/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-397e1a0f | RULE_SCREEN | J2 | 판단 | 판단 | SSP0005 EG374 INSERT 버튼 조회 전 SSP/40/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-42515862 | RULE_SCREEN | J2 | 판단 | 판단 | SSP0005 EG374 INSERT 버튼 조회 전 SSP/81/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-c6148723 | RULE_SCREEN | J2 | 판단 | 판단 | SSP0005 EG374 DELETE 버튼 조회 전 SSP/82/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-d2fe62f7 | RULE_SCREEN | J2 | 판단 | 판단 | SSP0005 EG374 DELETE 버튼 조회 전 SSP/40/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-035d24e0 | RULE_SCREEN | K4 | 판단 | 판단 | SSP0005 EG411 DELETE 버튼 조회 전 SSP/81/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-1ca102cc | RULE_SCREEN | K4 | 판단 | 판단 | SSP0005 EG411 DELETE 버튼 조회 전 SSP/82/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-4093ed61 | RULE_SCREEN | K4 | 판단 | 판단 | SSP0005 EG411 INSERT 버튼 조회 전 SSP/82/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-5f851100 | RULE_SCREEN | K4 | 판단 | 판단 | SSP0005 EG411 INSERT 버튼 조회 전 SSP/81/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-6586111e | RULE_SCREEN | K4 | 판단 | 판단 | SSP0005 EG411 DELETE 버튼 조회 전 SSP/40/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| EG-ffe74885 | RULE_SCREEN | K4 | 판단 | 판단 | SSP0005 EG411 INSERT 버튼 조회 전 SSP/40/SSP Planner | 결정 | Insert, Delete 툴바 버튼 비노출. AS-IS InsertButton 본문 주석 1줄 | 결정 목록 D-04 |
| V-d9d87624 | RULE_SCREEN | K4 | 스냅샷승인 | 사람 | SSP0005 스냅샷 버튼 Div 40 | 결정 | 스냅샷 승인 보류. snap_validate MISMATCH | 결정 목록 D-01 |
| EG-2d8daf5d | RULE_SCREEN | N1 | 판단 | 판단 | SSP0005 기준정보 키 존재 SCM_MST_SITE_ITEM | 결정 | 기준정보 키 대조가 화면 SP 미참조 표까지 포함 | 결정 목록 D-05 |
| EG-7cce21d1 | RULE_SCREEN | N1 | 판단 | 판단 | SSP0005 기준정보 키 존재 SCM_MST_PLAN_DETAIL | 결정 | 기준정보 키 대조가 화면 SP 미참조 표까지 포함 | 결정 목록 D-05 |
| EG-de6ec4d2 | RULE_SCREEN | N1 | 판단 | 판단 | SSP0005 기준정보 키 존재 SCM_MST_PROJECT | 결정 | 기준정보 키 대조가 화면 SP 미참조 표까지 포함 | 결정 목록 D-05 |
| T-9c47fb04 | TRACE | X-LOC | 대조표사유 | 가이드 | —, `filterCalls` | 결정 | DB MODE. 대조표 구현 위치 보강은 가이드 대상 | 결정 목록 D-02 |
| T-c02b5322 | TRACE | X-LOC | 대조표사유 | 가이드 | Δ2, 편집 기본 ON(모드 토글 미이식) | 결정 | DB MODE. 대조표 구현 위치 보강은 가이드 대상 | 결정 목록 D-02 |
| FACT-1b8d4243 | FACT |  | AI검토:추출오류 | 엔진 | combo_src.csv D_ | 미처리 | AS-IS 사실 추출기 보완 미착수(D_ 동적 컬럼, cboInputValue, DefColumns 상수) | 결정 목록 D-08 |
| FACT-22d28d04 | FACT |  | AI검토:추출오류 | 엔진 | combo_src.csv control | 미처리 | AS-IS 사실 추출기 보완 미착수(D_ 동적 컬럼, cboInputValue, DefColumns 상수) | 결정 목록 D-08 |
| FACT-305e97da | FACT |  | AI검토:추출오류 | 엔진 | edit_expect.csv COMPANY_ID | 미처리 | AS-IS 사실 추출기 보완 미착수(D_ 동적 컬럼, cboInputValue, DefColumns 상수) | 결정 목록 D-08 |
| FACT-3ddf08b1 | FACT |  | AI검토:추출오류 | 엔진 | grid_effective.csv D_ | 미처리 | AS-IS 사실 추출기 보완 미착수(D_ 동적 컬럼, cboInputValue, DefColumns 상수) | 결정 목록 D-08 |
| FACT-46f9e6c0 | FACT |  | AI검토:추출오류 | 엔진 | cell_rules.csv D_ | 미처리 | AS-IS 사실 추출기 보완 미착수(D_ 동적 컬럼, cboInputValue, DefColumns 상수) | 결정 목록 D-08 |
| FACT-84c8a011 | FACT |  | AI검토:추출오류 | 엔진 | lock_rules.csv COMPANY_ID | 미처리 | AS-IS 사실 추출기 보완 미착수(D_ 동적 컬럼, cboInputValue, DefColumns 상수) | 결정 목록 D-08 |
| FACT-998312f7 | FACT |  | AI검토:추출오류 | 엔진 | edit_expect.csv D_ | 미처리 | AS-IS 사실 추출기 보완 미착수(D_ 동적 컬럼, cboInputValue, DefColumns 상수) | 결정 목록 D-08 |
| FACT-c1215450 | FACT |  | AI검토:추출오류 | 엔진 | combo_src.csv cboInputValue | 미처리 | AS-IS 사실 추출기 보완 미착수(D_ 동적 컬럼, cboInputValue, DefColumns 상수) | 결정 목록 D-08 |
| T-7407a2ae | TRACE | A1 | AI검토:검사기오판 | 엔진 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY | 미처리 | 골든 요약 CSV 가 최신 비교(6행 일치)로 갱신되지 않음. 0행 해소 뒤 재측정 | 결정 목록 D-09 |
| T-85585e48 | TRACE | A1 | AI검토:검사기오판 | 엔진 | P_SSP0005_GET | 미처리 | 골든 요약 CSV 가 최신 비교(6행 일치)로 갱신되지 않음. 0행 해소 뒤 재측정 | 결정 목록 D-09 |
| T-c7d508e6 | TRACE | A6 | AI검토:검사기오판 | 엔진 | PKG_COM0000.P_SCM0001_GET_SCP_PERIOD | 미처리 | GET_SCP_PERIOD 버튼코드와 프로시저 연결 누락(1행 결과 SP) | 결정 목록 D-09 |
| V-d8993ea0 | SP | A7 | 검사기공백 | 엔진 | SCM0001_GET_SCP_PERIOD | 미처리 | golden cols.csv 없음. 차등 검증 PASS(호출 #1) 미반영 | 결정 목록 D-09 |
| T-ff291a6c | TRACE | B3 | 검사기공백 | 엔진 | cboDayWeek / Day of the week / Day Week | 미처리 | combo_oracle 순서 검사의 COND 실행 경로 없음 | 결정 목록 D-09 |
| V-803fc0b5 | SEARCH | B7 | 판단 | 판단 | 조회조건 Div | 미처리 | combo_src 추출기가 호출되지 않는 메서드 매개변수 control 을 콤보로 기록 | 결정 목록 D-08 |
| V-8bccac42 | GENERAL | B7 | 판단 | 판단 | [DMF0005 결함 유형] Team 조회조건 후보 | 미처리 | combo_src 추출기가 호출되지 않는 메서드 매개변수 control 을 콤보로 기록 | 결정 목록 D-08 |
| V-b4c1b701 | GENERAL | B7 | 판단 | 판단 | [결함 유형 묶음 B7-G01, 3건] 저장 후 마스터 조회조건 콤보 후보 | 미처리 | combo_src 추출기가 호출되지 않는 메서드 매개변수 control 을 콤보로 기록 | 결정 목록 D-08 |
| V-ce2c787d | RULE_SCREEN | E2 | 검사기공백 | 엔진 | SSP0005 기간 역전 조회 | 미처리 | 기간 역전 입력 실패(From=To 2026.11.20) | 결정 목록 D-09 |
| V-21c0cf89 | ASIS | E4 | 검사기공백 | 엔진 | MSG00134 | 미처리 | 가드 조건 유형 미분류(MSG00093 SelectedValue null, MSG00134 모달 후보) | 결정 목록 D-09 |
| V-23e055de | ASIS | E4 | 검사기공백 | 엔진 | MSG00093 | 미처리 | 가드 조건 유형 미분류(MSG00093 SelectedValue null, MSG00134 모달 후보) | 결정 목록 D-09 |
| V-8c0b1fa7 | ASIS | E4 | 검사기공백 | 엔진 | MSG00004 | 미처리 | 가드 조건 유형 미분류(MSG00093 SelectedValue null, MSG00134 모달 후보) | 결정 목록 D-09 |
| V-0ac85697 | SEARCH | G1 | 미분류 | 엔진 | 조회조건 Period | 미처리 | 기간 끝 값 달력 열림 실패 | 결정 목록 D-09 |
| V-fbce9494 | RULE_SCREEN | G1 | 검사기공백 | 엔진 | SSP0005 텍스트 부분일치 Period | 미처리 | 기간(달력) 조건에 텍스트 부분일치 검사 생성 | 결정 목록 D-09 |
| EG-a594e950 | RULE_SCREEN | J2 | 미분류 | 엔진 | SSP0005 EG369 CR-070 공통버튼 Div | 미처리 | EG369 perDiv 빈 키 | 결정 목록 D-09 |
| V-5be4f9ae | RULE_SCREEN | J4 | AI검토:검사기오판 | 엔진 | SSP0005 탭 이름 | 자동 | T435 수정 이전 판정. 다음 CheckList 재측정 | - |
| V-41d1438e | GENERAL | B2 | 집계 | 집계 | [DMF0006 결함 유형] 조회조건 Team, 그리드 Team/End Customer/Sales Site | 집계 | 하위 행 판정을 따름 | - |
| V-84608722 | GENERAL | B2 | 집계 | 집계 | [DMF0005 결함 유형] 그리드 Cust Group→End Customer→Sales Site | 집계 | 하위 행 판정을 따름 | - |
| V-9147d6a6 | DEFECT | B2 | 집계 | 집계 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | 집계 | 하위 행 판정을 따름 | - |
| V-a8dab5b5 | CONFIRMED | B2 | 집계 | 집계 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | 집계 | 하위 행 판정을 따름 | - |
| T-295cccf2 | TRACE | B3 | 집계 | 집계 | SSP0005_ShipmentWorkingDay.GetDayRange | 집계 | 하위 행 판정을 따름 | - |
| T-60360d2c | TRACE | B3 | 집계 | 집계 | B04, `Data.Common(YesOrNo)` cs:48 | 집계 | 하위 행 판정을 따름 | - |
| T-a65ef304 | TRACE | B3 | 집계 | 집계 | B03, `Data.Common(Data.Type.LookupCommon, false, "WEEK_WORK | 집계 | 하위 행 판정을 따름 | - |
| V-39e58029 | DEFECT | B3 | 집계 | 집계 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | 집계 | 하위 행 판정을 따름 | - |
| V-a2a1285f | GENERAL | B3 | 집계 | 집계 | [DMF0048 결함 일반화] 조회조건 Team(DEPT_ID)·End Customer(END_CUSTOME | 집계 | 하위 행 판정을 따름 | - |
| V-0579297f | GENERAL | B4 | 집계 | 집계 | [DMF0005 결함 유형] 하단 그리드 Sales Company/Sales Plant 콤보 | 집계 | 하위 행 판정을 따름 | - |
| V-09ca250a | GENERAL | B4 | 집계 | 집계 | [SCP0007 결함 유형] To Site 조회조건 콤보 | 집계 | 하위 행 판정을 따름 | - |
| V-1973f0f7 | GENERAL | B4 | 집계 | 집계 | [DMF0006 결함 유형] Team·End Customer·Sales Site 후보 | 집계 | 하위 행 판정을 따름 | - |
| V-1ab6f833 | CONFIRMED | B4 | 집계 | 집계 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | 집계 | 하위 행 판정을 따름 | - |
| V-2ca77a75 | DEFECT | B4 | 집계 | 집계 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | 집계 | 하위 행 판정을 따름 | - |
| V-3ebae6c3 | GENERAL | B4 | 집계 | 집계 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | 집계 | 하위 행 판정을 따름 | - |
| V-425fec93 | GENERAL | B4 | 집계 | 집계 | [DMF0005 결함 유형] Sales Plant 셀 콤보(3050 Plant) | 집계 | 하위 행 판정을 따름 | - |
| V-496652ff | GENERAL | B4 | 집계 | 집계 | [결함 유형 묶음 B4-G01, 3건] 저장, Sales Site 조회조건 콤보 | 집계 | 하위 행 판정을 따름 | - |
| V-4a6860ab | CONFIRMED | B4 | 집계 | 집계 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | 집계 | 하위 행 판정을 따름 | - |
| V-6c5354ee | GENERAL | B4 | 집계 | 집계 | [DMF0004 결함 유형] Sales Site 그리드 End Customer·Sold to Customer | 집계 | 하위 행 판정을 따름 | - |
| V-7956b2f9 | GENERAL | B4 | 집계 | 집계 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | 집계 | 하위 행 판정을 따름 | - |
| V-c5a5057d | DEFECT | B4 | 집계 | 집계 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | 집계 | 하위 행 판정을 따름 | - |
| V-c826a8ad | GENERAL | B4 | 집계 | 집계 | [DMF0006 결함 유형] 조회조건 Team, 그리드 Team/End Customer/Sales Site | 집계 | 하위 행 판정을 따름 | - |
| V-d8827278 | GENERAL | B4 | 집계 | 집계 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | 집계 | 하위 행 판정을 따름 | - |
| V-e62ad7de | DEFECT | B4 | 집계 | 집계 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | 집계 | 하위 행 판정을 따름 | - |
| V-e708b813 | GENERAL | B4 | 집계 | 집계 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | 집계 | 하위 행 판정을 따름 | - |
| V-e76b5e89 | GENERAL | B4 | 집계 | 집계 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | 집계 | 하위 행 판정을 따름 | - |
| V-fb5bed5d | GENERAL | B4 | 집계 | 집계 | [DMF0007 결함 유형] 저장(성공 메시지), Sales Site 셀 콤보 | 집계 | 하위 행 판정을 따름 | - |
| V-1310bb37 | GENERAL | B5 | 집계 | 집계 | [DMF0082 결함 유형] AS From Site 활성·콤보, Measure 후보 | 집계 | 하위 행 판정을 따름 | - |
| V-1cacf2b9 | GENERAL | B5 | 집계 | 집계 | [DMF0003 결함 유형] FCST Type 콤보, Measure 입력 가능 | 집계 | 하위 행 판정을 따름 | - |
| V-7054e971 | GENERAL | B5 | 집계 | 집계 | [DMF0082 결함 유형] Current 버전 입력 Measure(MKT_FCST·SCM_FCST·Unit | 집계 | 하위 행 판정을 따름 | - |
| V-b126e27d | GENERAL | B5 | 집계 | 집계 | [DMF0021 결함 유형] 신규 행 Sales Site·Project 팝업·Model 후보·Team 컬럼 | 집계 | 하위 행 판정을 따름 | - |
| V-c4caff15 | GENERAL | B5 | 집계 | 집계 | [결함 유형 묶음 B5-G01, 2건] 신규 행 Measure 콤보 후보(입력 가능 Measure) | 집계 | 하위 행 판정을 따름 | - |
| T-1ffdf93b | TRACE | C3 | 집계 | 집계 | SSP0005_ShipmentWorkingDay.CboDayWeek_SelectedIndexChanged | 집계 | 하위 행 판정을 따름 | - |
| T-a76983da | TRACE | C3 | 집계 | 집계 | Δ11, 붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설) | 집계 | 하위 행 판정을 따름 | - |
| T-dff0a06b | TRACE | C3 | 집계 | 집계 | SSP0005_ShipmentWorkingDay.SpdMain_Changed | 집계 | 하위 행 판정을 따름 | - |
| T-17118e14 | TRACE | D1 | 집계 | 집계 | P04, `EditButton` cs:346 | 집계 | 하위 행 판정을 따름 | - |
| T-663ca880 | TRACE | D1 | 집계 | 집계 | D01, `Columns.Get(0).Visible == false` | 집계 | 하위 행 판정을 따름 | - |
| T-8ae004d7 | TRACE | D1 | 집계 | 집계 | SSP0005_ShipmentWorkingDay.EditButton | 집계 | 하위 행 판정을 따름 | - |
| T-d45ddbb8 | TRACE | D1 | 집계 | 집계 | P05, `SaveButton` cs:360 | 집계 | 하위 행 판정을 따름 | - |
| T-e08fb747 | TRACE | D1 | 집계 | 집계 | Δ11, 붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설) | 집계 | 하위 행 판정을 따름 | - |
| T-fd593e58 | TRACE | D1 | 집계 | 집계 | Δ2, 편집 기본 ON(모드 토글 미이식) | 집계 | 하위 행 판정을 따름 | - |
| T-fd719f66 | TRACE | D1 | 집계 | 집계 | V04, `MSG00135` 편집모드 아님 | 집계 | 하위 행 판정을 따름 | - |
| T-119be376 | TRACE | D3 | 집계 | 집계 | Δ10, 툴바 `Insert`/`Delete` NO-OP 노출을 **버튼 권한 축으로 게이트**(gap-r | 집계 | 하위 행 판정을 따름 | - |
| T-2e6c3e63 | TRACE | D3 | 집계 | 집계 | D01, `Columns.Get(0).Visible == false` | 집계 | 하위 행 판정을 따름 | - |
| T-39793869 | TRACE | D3 | 집계 | 집계 | Δ2, 편집 기본 ON(모드 토글 미이식) | 집계 | 하위 행 판정을 따름 | - |
| T-4def2d25 | TRACE | D3 | 집계 | 집계 | Δ11, 붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설) | 집계 | 하위 행 판정을 따름 | - |
| T-5a056b57 | TRACE | D3 | 집계 | 집계 | P05, `SaveButton` cs:360 | 집계 | 하위 행 판정을 따름 | - |
| T-8af7f375 | TRACE | D3 | 집계 | 집계 | V04, `MSG00135` 편집모드 아님 | 집계 | 하위 행 판정을 따름 | - |
| T-90f0831a | TRACE | D3 | 집계 | 집계 | P04, `EditButton` cs:346 | 집계 | 하위 행 판정을 따름 | - |
| V-27bf5b6f | CONFIRMED | D4 | 집계 | 집계 | Insert 시 Project 컬럼, Sort | 집계 | 하위 행 판정을 따름 | - |
| V-33be7f8c | GENERAL | D4 | 집계 | 집계 | [DMF0004 결함 일반화] Insert 행 Div, Div 변경 시 그리드 | 집계 | 하위 행 판정을 따름 | - |
| V-50aa82a9 | GENERAL | D4 | 집계 | 집계 | [결함 유형 묶음 D4-G01, 2건] 하단 메시지설정 탭의 Insert(행추가) | 집계 | 하위 행 판정을 따름 | - |
| V-692ec7df | GENERAL | D4 | 집계 | 집계 | [SYS0016 결함 유형] Module 조회조건·Insert Module 콤보 / Sub Module 조회 | 집계 | 하위 행 판정을 따름 | - |
| V-7645bedd | GENERAL | D4 | 집계 | 집계 | [SCP0007 결함 유형] Insert 행 To Site 콤보·City | 집계 | 하위 행 판정을 따름 | - |
| V-a64f146f | CONFIRMED | D4 | 집계 | 집계 | Insert 행 Div, Div 변경 시 그리드 | 집계 | 하위 행 판정을 따름 | - |
| V-c3ecf2ff | GENERAL | D4 | 집계 | 집계 | [DMF0068 결함 일반화] Insert 시 Project 컬럼, Sort | 집계 | 하위 행 판정을 따름 | - |
| V-4361f363 | CONFIRMED | D6 | 집계 | 집계 | 그리드 Insert 신규행 위치 | 집계 | 하위 행 판정을 따름 | - |
| V-6630b28e | GENERAL | D6 | 집계 | 집계 | [DMF0042 결함 유형] Exchange Rate Currency, 중복 Keyset 메시지, Ins | 집계 | 하위 행 판정을 따름 | - |
| V-7f4b0615 | GENERAL | D6 | 집계 | 집계 | [DMF0068 결함 일반화] Insert 시 Project 컬럼, Sort | 집계 | 하위 행 판정을 따름 | - |
| V-97ac36ec | GENERAL | D6 | 집계 | 집계 | [DMF0005 결함 일반화] Insert 행 위치, 셀 병합(FPMerge) 그룹 | 집계 | 하위 행 판정을 따름 | - |
| V-f251a3d7 | GENERAL | E5 | 집계 | 집계 | [DMF0005 결함 일반화] Sales Company·Sales Plant 셀 | 집계 | 하위 행 판정을 따름 | - |
| T-091637e9 | TRACE | G1 | 집계 | 집계 | C12, `btnInput` | 집계 | 하위 행 판정을 따름 | - |
| T-0dd5c195 | TRACE | G1 | 집계 | 집계 | V04, `MSG00135` 편집모드 아님 | 집계 | 하위 행 판정을 따름 | - |
| T-0ed1bf5b | TRACE | G1 | 집계 | 집계 | Δ1, `Period*` 빈값 조회 **차단** | 집계 | 하위 행 판정을 따름 | - |
| T-127c883d | TRACE | G1 | 집계 | 집계 | D01, `Columns.Get(0).Visible == false` | 집계 | 하위 행 판정을 따름 | - |
| T-13baf5a1 | TRACE | G1 | 집계 | 집계 | C09, `layoutControlItem10`(TextVisible=false) | 집계 | 하위 행 판정을 따름 | - |
| T-59a7f9dd | TRACE | G1 | 집계 | 집계 | Δ6, 빈 `D_` 셀 변경건 전송 제외 | 집계 | 하위 행 판정을 따름 | - |
| T-5a5739c8 | TRACE | G1 | 집계 | 집계 | B04, `Data.Common(YesOrNo)` cs:48 | 집계 | 하위 행 판정을 따름 | - |
| T-6ca621f1 | TRACE | G1 | 집계 | 집계 | A04, Division 권한 게이트 cs:161-162 | 집계 | 하위 행 판정을 따름 | - |
| T-88160cf1 | TRACE | G1 | 집계 | 집계 | Δ11, 붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설) | 집계 | 하위 행 판정을 따름 | - |
| T-a2fe0c60 | TRACE | G1 | 집계 | 집계 | A02, 필수값 검증 2건 cs:377·456 | 집계 | 하위 행 판정을 따름 | - |
| T-cb76e19d | TRACE | G1 | 집계 | 집계 | A15, `GetDayOfWeek` = dsSpdTitle 역조회 cs:824-830 | 집계 | 하위 행 판정을 따름 | - |
| T-d194141f | TRACE | G1 | 집계 | 집계 | P01, `FindButton` cs:330 | 집계 | 하위 행 판정을 따름 | - |
| T-ddb765d3 | TRACE | G1 | 집계 | 집계 | G13, `SmartColMerge`(조회 후) | 집계 | 하위 행 판정을 따름 | - |
| V-8cb39c0d | GENERAL | G1 | 집계 | 집계 | [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | 집계 | 하위 행 판정을 따름 | - |
| V-c10a2744 | GENERAL | G1 | 집계 | 집계 | [DMF0040 결함 유형] Plant Site 조회조건 | 집계 | 하위 행 판정을 따름 | - |
| V-ef1b1289 | GENERAL | G1 | 집계 | 집계 | [SCP0028 결함 유형] From Site 조회조건 | 집계 | 하위 행 판정을 따름 | - |
| V-4b73fcf6 | GENERAL | G2 | 집계 | 집계 | [SCP0028 결함 유형] From Site 조회조건 | 집계 | 하위 행 판정을 따름 | - |
| V-60cc2127 | GENERAL | G2 | 집계 | 집계 | [결함 유형 묶음 G2-G01, 2건] 단일/콤보 조회조건의 ALL 재선택 재조회 | 집계 | 하위 행 판정을 따름 | - |
| V-d57a3b5a | GENERAL | H10 | 집계 | 집계 | [DMF0082 결함 일반화] Price Batch Input 팝업 Save 결과 판정(o_rc1 첫 행 R | 집계 | 하위 행 판정을 따름 | - |
| V-1b0b54e1 | DEFECT | J1 | 집계 | 집계 | 사용자 Division 권한 콤보 쿼리(DIVISION_ID, 권한 USE_YN) 필터 | 집계 | 하위 행 판정을 따름 | - |
| V-4b1963c6 | CONFIRMED | J1 | 집계 | 집계 | Division 조회조건 후보 | 집계 | 하위 행 판정을 따름 | - |
| V-54a57e6e | CONFIRMED | J1 | 집계 | 집계 | Division 기본값, 메뉴 트리(Admin-System) | 집계 | 하위 행 판정을 따름 | - |
| V-6ddbfcdb | GENERAL | J1 | 집계 | 집계 | [DMF0074 결함 일반화] 조회조건 Division 콤보(DIVISION_ID) 권한 자동 선택, Pe | 집계 | 하위 행 판정을 따름 | - |
| V-bc2567bd | GENERAL | J1 | 집계 | 집계 | [DMF0082 결함 일반화] Division 기본값, 메뉴 트리(Admin-System) | 집계 | 하위 행 판정을 따름 | - |
| V-cc542802 | GENERAL | J1 | 집계 | 집계 | [DMF0003 결함 일반화] Division 조회조건 후보 | 집계 | 하위 행 판정을 따름 | - |
| V-dfd93f3b | GENERAL | J1 | 집계 | 집계 | [DMF0004 결함 일반화] 조회조건 Division 콤보(DIVISION_ID) 초기 선택값, 사용자  | 집계 | 하위 행 판정을 따름 | - |
| V-30e45b47 | GENERAL | J2 | 집계 | 집계 | [결함 유형 묶음 J2-G01, 4건] 공통 버튼(Insert·Save·Delete 등) 노출의 권한 판정 | 집계 | 하위 행 판정을 따름 | - |
| V-3c04771c | CONFIRMED | J2 | 집계 | 집계 | 공통버튼 Insert(F8)/Delete(F9)/Save(F7)/Upload 노출 | 집계 | 하위 행 판정을 따름 | - |
| V-5d5f56c6 | GENERAL | J2 | 집계 | 집계 | [DMF0082 결함 유형] Insert·Save 버튼 | 집계 | 하위 행 판정을 따름 | - |
| V-77658cc1 | GENERAL | J2 | 집계 | 집계 | [DMF0082 결함 일반화] 공통 버튼(Insert/Save/Delete 등 SubTitle 버튼) 노출  | 집계 | 하위 행 판정을 따름 | - |
| V-83fd2b9b | GENERAL | J2 | 집계 | 집계 | [DMF0044 결함 유형] Delete 버튼 | 집계 | 하위 행 판정을 따름 | - |
| V-6df5c22d | GENERAL | K4 | 집계 | 집계 | [DMF0042 결함 유형] Exchange Rate Currency, 중복 Keyset 메시지, Ins | 집계 | 하위 행 판정을 따름 | - |
| V-ceca4b3b | GENERAL | K4 | 집계 | 집계 | [DMF0082 결함 일반화] 공통 버튼(Insert/Save/Delete 등 SubTitle 버튼) 노출  | 집계 | 하위 행 판정을 따름 | - |
| V-d8d564f4 | GENERAL | K4 | 집계 | 집계 | [DMF0020 결함 일반화] Condition(F6) 저장, Sales Report ETC Insert  | 집계 | 하위 행 판정을 따름 | - |
| V-e8f6c900 | GENERAL | K4 | 집계 | 집계 | [DMF0044 결함 유형] Delete 버튼 | 집계 | 하위 행 판정을 따름 | - |
| V-0417fab6 | GENERAL | N1 | 집계 | 집계 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | 집계 | 하위 행 판정을 따름 | - |
| V-32fdf034 | GENERAL | N1 | 집계 | 집계 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure, VMI 메저, MKT FCST A | 집계 | 하위 행 판정을 따름 | - |
| V-57a379d1 | GENERAL | N1 | 집계 | 집계 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼, AS FROM SITE 컬럼 | 집계 | 하위 행 판정을 따름 | - |
| V-75e8993b | GENERAL | N1 | 집계 | 집계 | [결함 유형 묶음 N1-G02, 2건] Div별 컬럼·Measure 구성의 AS-IS 일치 | 집계 | 하위 행 판정을 따름 | - |
| V-7e5f8bf4 | GENERAL | N1 | 집계 | 집계 | [결함 유형 묶음 N1-G01, 2건] 공란 데이터 표기(단일 센티널) | 집계 | 하위 행 판정을 따름 | - |
| V-967b2fef | GENERAL | N1 | 집계 | 집계 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site I | 집계 | 하위 행 판정을 따름 | - |
| T-3535dd59 | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.InitControls | 집계 | 하위 행 판정을 따름 | - |
| T-8ce79c17 | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.SpdMain_Changed | 집계 | 하위 행 판정을 따름 | - |
| T-8e5e0b55 | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.Form_Load | 집계 | 하위 행 판정을 따름 | - |
| T-8e7c6673 | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.GetDayRange | 집계 | 하위 행 판정을 따름 | - |
| T-962cff00 | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.InitSpreadDateColumn | 집계 | 하위 행 판정을 따름 | - |
| T-a9ea136e | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.CboDayWeek_SelectedIndexChanged | 집계 | 하위 행 판정을 따름 | - |
| T-ce645cc0 | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.SaveData_Main | 집계 | 하위 행 판정을 따름 | - |
| T-ddd4e063 | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.InitSpread | 집계 | 하위 행 판정을 따름 | - |
| T-f727c20b | TRACE | X-ROW | 집계 | 집계 | SSP0005_ShipmentWorkingDay.SpdMain_TopChange | 집계 | 하위 행 판정을 따름 | - |

## 원장 판정필요 17행(분류 대상 밖)
- T-a5619ed7 외 15행(A1 행 집계): FAIL 요소 P_SSP0005_GET 골든 비교 케이스 없음. T-85585e48(API 별칭 골든 매칭)을 따름. 결정 목록 D-09
- V-f2bd7c17(H4 헤더 글자 잘림 DIVISION_ID 50 > 47px): 사람 판정 행. 결정 목록 D-10
