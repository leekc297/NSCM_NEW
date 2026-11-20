# SCP0005 미검증 해소 작업 기록

## 라운드 1 (2026-11-20 08:29 ~ 08:5x · 일괄 보완)

- 입력: CheckList 원장 `verify_ledger.csv`(08:12:16, CheckList 07:35), 분류 `unverified_triage.*`(08:24:15). 처리 대상 257행(엔진 153, 판단 103, 사람 1), 집계 95
- 행별 조치 표 `_unverified_plan.md`(257행, 빠진 행 0, 겹친 행 0). 결정 목록 `_unverified_decisions.md`(D1~D7, 80행). 표 생성 `_unverified_plan_gen.py`
- 재측정: run_verify, 개별 검사기 재실행 안 함(사용자 지시 2026-11-18). 확인은 단위 함수 시험, 사실 파일 재생성 diff, engine_selfcheck

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| A route 시트 중복 행(T451) | 50 | sheet_columns.csv SCP0005 시트 3개(Distribution Route 39, route 33, POPUP 16). 화면 컬럼 메타 조회 키 'Distribution Route'(useDistributionRouteStore.ts:113~117). `_index.csv` dts_sheets 빈 값 | `tools/E2E/lib/nscm.ts` recordMetaSheets, `tools/Harness/verify/ledger.py` T451 | 필터 단위 시험 3건. 겹침 비율 기준 검토 결과 DMF0005 purchase_81·82, DMF0043 versionPopup, SCM0016 batchLogHist 를 잘못 묶어 버림(쓰지 않음) |
| B 셀 규칙 시트(T450) | 5 | cell_rules.csv LT 5칸 sheet POPUP. 원문 cs:243 `if (spreadInfo.SheetName == SpdSheet.shtMain)` · cs:78 shtMain 'Distribution Route' | `tools/Harness/verify/facts_cellrules.py` guard_sheets | 재생성 diff: LT_ARRIVAL_INLAND, LT_DEPARTURE_INLAND, LT_LAY_OFF_CLEARANCE, LT_VOYAGE, LT_WAIT_SHIPPING 시트 POPUP → Distribution Route. 나머지 칸 값 같음(cond_cells 빈 열 추가는 다른 세션 T392 열) |
| C 저장 왕복 행 식별(T452) | 4 | V-4e4af2a4 'FROM_COUNTRY r359 CN→KR · 재조회 행 식별 0건'. probe.ts:251 rowIdentity 가 숫자 칸 제외 | `tools/E2E/lib/saveprobe.ts` uniqueIdKey, rowsById | tsc 0 |
| D 이력 팝업 미열림(T454) | 1 | AS-IS cs:1093~1103 ROUTE_ID 더블클릭 → 이력 팝업. TO-BE DistributionRouteGrid.tsx:188~200 FROM·TO 칸만 처리. judge.py:2805 RX_TOOLFAIL '열림 감지 실패' → ERROR | `Doc/e2e/specs/_trace.spec.ts` M3 | tsc 0 |
| E 조회조건 검색 단추 팝업(T453) | 8 | _trace.spec.ts W4d 분기 끝 else(종전 2195줄)가 txt* 조건 행을 미검증으로 적음. AS-IS btnFromSrch·btnToSrch(cs:358~369), TO-BE 돋보기(DistributionRouteForm.tsx:82~87, 123~127) | `Doc/e2e/specs/_trace.spec.ts` condPopup | tsc 0 |
| F Division 없는 화면(T455) | 2 | 'Division 40 선택 못 함 · set=false rows=8036'. SCP0005 controls.csv 이름에 Div 0건 | `tools/Harness/verify/e2e_suite_ingest.py` no_div | py_compile 0. Div 컨트롤 없는 AS-IS 화면 87/417 |
| G FPTextBox 팝업 칸(T456) | 4 | ledger.py T114 분기 CELL=- 만 일반 텍스트. SpreadInfo.cs:1387~1389 CELL 빈 값 → FPTextBox. InsertRow 잠금 칸(cs:950~954)에 FROM_COUNTRY·FROM_CITY 없음 | `tools/Harness/verify/ledger.py` _plain | 정규식 단위 시험 5건 |
| H 미분류 등록 | 15 | 증거 문구가 분류표에 없음 | `tools/Harness/verify/unverified_classes.csv` 71·73·52 행 | 정규식 컴파일 19행, 문구 8종 분류 시험 |

### 고치지 않은 행

- 결정 목록 D1~D7 80행. D1(44행)은 화면 기능 누락(이력 팝업)이 먼저 고쳐져야 측정됨. FE 가이드 `FE_GUIDE_20261120_0854.md` 1건
- 이번 라운드 미보완 88행(U 묶음): H2 배경색 조건 행 11, E4 메시지 경로 8, 조회조건·셀 팝업 표준 H6·G5 14, DAYS·PRIORITY 연쇄 7, M1 Excel 업로드 메시지 4, E1 숫자 칸 4, AI 검토 검사기오판 중 미수정 23, FACT SetImageCell·색 규칙 7, 그 밖 10. 원인은 행 증거와 AI 검토 처리 방법 칸 기준이고 원문 재확인은 못 함(미확인)
- 재실행 2행(ES-836708a8, ES-88905017): 증거 'locator.click Timeout 5000ms · saveCalls=0'. 어느 단추 클릭인지 기록을 찾지 못함(results.json, e2e_suite.json 검색) → 원인 미확인

### 다음 CheckList 에서 바뀔 판정(검사기 판정 경로 기준, 미측정)

- 미검증 → 실측(통과 또는 오류): C 4행, E 8행, D 1행(화면에 팝업이 없으므로 FAIL 예상 근거 = TO-BE 소스 더블클릭 처리에 ROUTE_ID 분기 없음)
- 미검증 → 해당없음: F 2행
- FAIL → 실측 재판정: G 4행(기대 '팝업 보조 입력')
- 행 사라짐: A 50행(meta_sheets.json 이 생긴 다음 CheckList 원장부터. 첫 CheckList 는 기록만 함), B 5행(사실 검토 재생성 때)
- 미검증 유지: H 15행(분류만 바뀜), 결정 목록 80행, U 88행

### 점검

- engine_selfcheck PASS(08:56:04, PY_COMPILE 0, CTRL_CHARS 0, TSC 0, selftest JS 32, PY 59)
- 줄바꿈: nscm.ts, saveprobe.ts, _trace.spec.ts CRLF 유지(수정 뒤 CRLF 1017/1017, 207/207, 2630/2630). ledger.py, facts_cellrules.py, e2e_suite_ingest.py LF 유지
- 백업 `*.bak_20261120_scp05u`(nscm.ts, saveprobe.ts, _trace.spec.ts, ledger.py, facts_cellrules.py, e2e_suite_ingest.py, unverified_classes.csv)
- DB: 사내 오라클 조회만(08:41 SCP_MST_DISTRIBUTION_ROUTE 2행, 08:51 PKG_SCP0005 프로시저·버튼 연결·API 연결). 쓰기 없음
- 사실 파일 재생성: Doc/asisfacts/screens/SCP0005/cell_rules.csv(facts_cellrules.py)
- 새 도구 파일 없음(inventory_check 등록부 갱신 안 함)

## 라운드 2 (2026-11-20 09:57 ~ 10:0x)

- 입력: 원장 09:06:10(재검 08:59 시작, 09:56:56 시나리오 실행 중 멈춤, NOT_RUN 1,758/1,996행). 분류 10:00:50 재생성. 측정 근거는 재검 E2E 결과 e2e_results.json(09:43, 813행)
- 라운드 1 보완 실측 확인(재검 E2E): T454 T-6d14c72c FAIL '10초 동안 대화상자 0 · 서버 호출 0 · 편집기 없음 — 팝업 열리지 않음'. T453 From/To City 4행 PASS(대화상자 9·28행, 조건 값 ''→'AATES'), From/To Country 4행 FAIL '검색 단추 없음'. T452 FROM_COUNTRY r6996 'PL'→'CN' 재조회 OK · 원복 OK · 행 식별 = ROUTE_ID '5942'. 사실 검토 09:05 에 LT 숫자 칸 FACT 5행 없음(T450)

| 묶음 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|
| T457 저장 왕복 행 식별 순서·파생 칸 | e2e_results V-4e4af2a4: FROM_CITY r359 'CNNKG'→'KRCOJ' 재조회 'CNNKG' NG · '다른 칸 변경 LT_TYPE MAX→AVERAGE' · TRANSPORT_MODE 왕복 OK 뒤 'TRANSPORT_MODE_NAME AIR→FERRY' 를 다른 칸 변경으로 보고 중단. touched_rows.json: FROM_CITY 시험 행 7305(LT_TYPE MAX), 다음 시험 행 7303(LT_TYPE AVERAGE) = 비슷한 행 찾기가 다른 행을 집음. DB 10:04: 7305 FROM_COUNTRY 'KR'·FROM_CITY 'KRCOJ' 잔존 | `tools/E2E/lib/saveprobe.ts` ID 칸 먼저(h1·h2), sideDiff(편집 전 값 직접 비교 · 시험 칸 파생 칸 제외), 비슷한 행 찾기 차이에서 파생 칸 제외 | tsc 0 |
| T458 조회조건 같은 묶음 단추 | e2e_results T-9b463365 외 3행 '검색 단추 없음'. TO-BE Country 칸 단추 없음(DistributionRouteForm.tsx:60~70, 98~110), AS-IS btnFromSrch·btnToSrch 가 Country·City 두 칸을 채움(cs:340~371) | `Doc/e2e/specs/_trace.spec.ts` condPopup 라벨 첫 단어가 같은 칸의 단추 · 같이 채워진 칸 원복 | tsc 0 |
| T459 G4 버튼 라벨 | e2e_results T-85f3a8bb·T-7e1a41bb '클릭 메서드가 popup_args.csv 에 없음'. popup_args.csv 에 btnFromSrch_Click 행 3개 있음, host_label 빈 값 | `Doc/e2e/specs/_trace.spec.ts` G4 BTN 인자 원천 컨트롤 이름(txtFromCity → From City)으로 칸 찾기 | tsc 0 |
| T460 색 규칙 조건 | FACT-a3f92559·FACT-3d955bfe: color_rules cond FALSE. facts_lockrules.py 가 `string.IsNullOrEmpty(변수)` 를 세션 값으로 보고 FALSE. 원문 cs:1301~1305 변수 = siMain.GetValue(i, nFromCityName) | `tools/Harness/verify/facts_lockrules.py` atom·lhs(칸 번호 변수) | SCP0005 color_rules 재생성 2행 cond 'COL(FROM_CITY_NAME)==""'·'COL(TO_CITY_NAME)==""' · edit_expect·lock_rules 변화 없음 |

- 데이터 복원: 재검이 체인 끝 전에 멈춰 restore_touched 가 안 돌았음. 10:04 `restore_touched.py SCP0005 --keep-trace` 실행 → 9917, 5942, 7305, 7303 RESTORE · 이력 표 7행 삭제. 10:04:50 DB 확인: 7305 CN·CNNKG·yangwon_kim 2021-02-24, 7303·5942 원래 감사 칸. 9917 은 11-19 21:26 상태(결정 목록 D4)
- 고치지 않은 행: 라운드 1 U 묶음 50행, FACT 5행(SetImageCell 셀 형식 4, ROUTE_ID 노랑 색 1), 결정 목록 D1~D8
- 다음 CheckList 판정(미측정): Country 조건 4행 = 같은 묶음 단추로 실측(통과 또는 오류) · G4 btnFromSrch·btnToSrch 2행 = 실측 · 저장 왕복 4행 = 실측 · FACT 2행 사라짐(사실 검토 재생성 때) · 그 밖 라운드 1 판정 경로 그대로
- 점검: engine_selfcheck PASS(10:06:51, TSC 0, CTRL_CHARS 0). 백업 *.bak_20261120_scp05u2(saveprobe.ts, _trace.spec.ts, facts_lockrules.py). 줄바꿈 saveprobe.ts CRLF 218/218, _trace.spec.ts CRLF 2643/2643
- 다른 화면 영향(미측정): IsNullOrEmpty(그리드 칸 값 변수) 조건이 FALSE 에서 칸 조건으로 바뀌는 화면, 단추 없는 조회조건 칸
