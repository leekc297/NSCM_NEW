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

## 라운드 3 기록 누락(2026-11-25 02:5x~03:1x)

- 조치표(_unverified_plan.md.bak_20261125_r3, 166행)와 백업 *.bak_20261125_scp05u3 만 남고 이 파일과 _ENGINE_MASTER.md 기록은 없음. 다음 CheckList(03:24~05:25) 결과 직전 처리 대상 165행 중 89행 해소(unverified_triage.json resolved_actionable)

## 라운드 4 (2026-11-25 05:27 ~ 06:11 · 일괄 보완)

- 입력: 원장 verify_ledger.csv(05:25), 분류 unverified_triage.csv(05:25:00). 처리 대상 92행(AI 검토 34 포함) + 사람 1행, 집계 21행 제외
- 행별 조치표 _unverified_plan.md(93행, 빠진 행 0). 결정 목록 _unverified_decisions.md(R4-D1~D14)
- 묶음 6개를 하위 에이전트에 나눔(U1 사실 추출, U2 골든·정렬, U3 _trace.spec, U4a 저장 왕복, U4b _verify.spec, U5 팝업·원장·판정). 하위 에이전트 결과는 자체 시험 재실행, 사실 파일 재생성 결과, tsc, engine_selfcheck 로 다시 확인
- 재측정: run_verify, checklist_run, E2E 실행 안 함(사용자 지시 2026-11-18, 11-19)

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| U1 사실 추출 | 6 | cell_rules 키가 컬럼 이름뿐이라 POPUP 시트가 본 시트를 덮음(T540). SetImageCell 칸 MaxLength 없음(cs:222~224, 590~595)에 META 길이 잔존(T541). 색 조건에 cs:1286 continue·cs:1293 break 가드 누락(T542) | facts_cellrules.py:99~306, facts_lockrules.py:36~55, 561~635 | 재생성 cell_rules 39→55행, color_rules 3행 cond 변경, lock_rules·edit_expect 변화 0 |
| U2 골든·정렬 | 10 | _order_check 가 동률 행 순서까지 비교(T545). sort_ci 부분 질의 별칭 미추적(T546). p_route_id 원천 없음(T547). shared 팝업 SP 케이스 제외(T548). 룩업 SP 에 CR-075 ④ 적용(T549) | tools/DbConn/golden.py, gen_golden_cases.py, Doc/golden/golden_cases.csv(SCP0005 5행), sort_ci_check.py | golden selftest 10/10(05:52 재실행 확인), sort_ci 39/39, --case ROUTEID·HISTORY PASS 1행↔1행(05:43), 읽기 전용 재조회 valid_yn ''·'Y' DIFF → PASS |
| U3 _trace.spec | 17 | 자리표시자 지운 문구 비교·경계값 999(T550). 응답 없이 대조표 문장 FAIL·99030/99040 확대(T551). 업로드 창 닫기 경로 없음(T552). RAW 지역 변수·저장 응답 조건 평가 불가(T553). Division 없는 화면 A4 분기 없음·L1 문장 오부착(T554) | Doc/e2e/specs/_trace.spec.ts, 새 tools/E2E/lib/saveerr.ts | saveerr selftest 55/55, btnpopup 30/30, condeval 21/21 |
| U4a 저장 왕복 | 6 | 원값 '/' 가 콤보 후보 밖이라 원복 실패 → 이후 칸 중단(T555, T556). 'S' 메타를 전 시트에서 모아 TRANSPORT_MODE 가 마커 칸이 됨(T557). PRIORITY 를 99+1 로 입력(T558). 저장 0건인데 FAIL(T559) | saveprobe.ts, crud.ts, rowlink.ts, e2e_suite_ingest.py | rowlink.u4 selftest 28/28, rowlink 9/9, crud_verdict 함수 시험 3건. DB 05:45 ROUTE_ID 3764 LT_TYPE '/' 복원 확인 |
| U4b _verify.spec | 24 | Valid → DAYS_MON 대응(T560). 콤보 응답 ID 차이(T561). 후보 밖 값 행 0건(T562). 숫자 원천 입력 없음(T563, T569). C6 대상 0개(T564). 붙여넣기 길이 초과(T565). F5 63초 조회(T566). 업로드 응답 260자 잘림(T567). 잘린 조건 대체(T568). 입력 한글 칸 오판(T580). 소수 미지정 칸 소수 시험(T581). 원복 위임 표시 잘림(T582). 명칭 값 덤프 없음(T583). M1 시나리오 없음(T584) | _verify.spec.ts, condcol.ts, i18n_lang_check.py, 새 m1upload.ts·xlsx_rows.py | condcol 7/7, scenario 33/33, cellfill 9/9, excelcheck 44/44, i18n 14/14, m1upload 13/13 |
| U5 팝업·원장·판정 | 18 | PICK_OK 전후 변화만 비교(T570). 메인 기간 없는 화면 Period 비교(T571). ExcelUploadForm2 원문이 01.Framework(T572). 도달 불가 분기 칸 포함(T573). CELL·버튼 팝업 실측 미연결(T574, T575). 'Pop' 없는 클래스 미해석(T576). LOCAL 생성문(T577). 응답시간 문장 덮어씀(T578). ledger 시트 무시·600자 절단·NUMBER_TEXT 판정필요(T579) | eg_popup.spec.ts, mapping_trace.py, judge.py, ledger.py, facts_popup.py | mapping_trace 108/108, judge_popup 11/11, judge_e4f1 11/11, 임시 폴더 원장 실행. E02 facts ExcelUploadForm2 in_pack false → true |
| 마무리 | 2 | I3 상향이 측정 실패까지 올림(T585). _trace M1 고정 ERROR 가 _verify 결과를 덮음(T586) | judge.py I3 블록, _trace.spec.ts M1 줄 | py_compile, tsc 0 |

### 고치지 않은 행(결정 목록)

- R4-D1 이력 팝업 선행 결함 5행, R4-D2 진입 시나리오 1행, R4-D3 스냅샷 1행, R4-D4 붙여넣기 AS-IS 기대값 9행(측정 경로는 고침 T562), R4-D5 실저장 1행(분류표 76행 '실저장필요' 사람 등록), R4-D9 1행

### 다음 CheckList 에서 바뀔 판정(판정 경로 기준, 미측정)

- 미검증 → 실측(PASS 또는 FAIL): E4 9행, H2 6행, A4 1행, F1·F6 4행, ES 2행, C1 2행, C3·C6 5행, K3 2행, E1 4행, M1 1행, I3 1행, H6·G5 연결 7행
- FAIL·판정필요 → 재판정: AD 3행(읽기 전용 재조회 PASS), EG 정렬 4행(PASS 3, NA 1), EG 팝업 2행, E3 1행, G1 1행, I2 2행, L1 1행, X-REASON 1행
- 미검증 → 해당없음(원문 근거): *_CITY_NAME 4행(T573), EG-6fba2eee(T571)
- 행 사라짐: FACT 6행(사실 검토 재생성 때)
- 행 ID 바뀜: 원장 30행(T579-a, 결정 R4-D12)
- 미검증 유지: R4-D1 5행, R4-D2 1행, R4-D5 1행, R4-D4 9행(ERROR, AS-IS 기대 미확인)

### 점검

- engine_selfcheck PASS(06:10:19, CTRL_CHARS 0, TSC 0, selftest JS 39·PY 66). 06:09 첫 실행은 _trace.spec.ts:2475 0x08 로 FAIL → `\b` 로 복원. sort_ci_check.py:467, _verify.spec.ts:2805 의 0x08 도 같은 방법으로 복원
- 사고: U3 편집 중 05:5x 에 _trace.spec.ts 가 몇 분 동안 7줄로 덮였다가 직전 사본으로 복원됨. 백업 대비 diff 는 U3 변경 구간만. 그 사이 다른 세션 열람 여부 미확인
- 결함 번호: U4b 가 쓴 T570~T572 를 U5 번호와 겹쳐 T580~T582 로 바꿈. _trace.spec.ts:2880 의 'T540' 주석은 라운드 3 것으로 _checker_defects.md T540 과 다른 내용
- 줄바꿈 유지: _trace.spec.ts CRLF 3373/3373, _verify.spec.ts CRLF 4408/4408, unverified_classes.csv LF, facts_popup.py CRLF 412/412
- 백업 *.bak_20261125_scp05u4. 새 파일 saveerr.ts, saveerr.selftest.js, m1upload.ts, m1upload.selftest.js, condcol.selftest.js, rowlink.u4.selftest.js, xlsx_rows.py. inventory_check --write-registry 06:10(등록부에 xlsx_rows.py 반영, TS lib 파일은 등록 대상 아님 미확인)
- DB: 사내 오라클 읽기 전용 조회와 GET 프로시저 호출(호출 뒤 rollback)만. 쓰기 없음
- pending_recheck --mark 06:10, unverified_resolve --no-rerun 06:10

## 라운드 5 (2026-11-25 07:45 ~ 08:1x · 체인 회차 3 · 일괄 보완)

- 입력: 원장 verify_ledger.csv(07:45:31), 분류 unverified_triage.csv(07:45:31). 해소 확인 재측정 run 20261125061230(06:12:30 시작, run_mode only, 규칙 24개, 단계 diff·eg·suite)
- 처리 대상 20행 + 결정 1행(V-a6bb7234). 조치표 _unverified_plan.md(21행, 빠진 행 0). 라운드 4 조치표 사본 _unverified_plan.md.bak_20261125_r4
- 라운드 4 에서 고쳤는데 남은 14행은 재측정 증거(e2e_results.json run 20261125061230)로 다른 원인을 찾음. 같은 고침 되풀이 없음
- 묶음 4개 하위 에이전트(W1 _trace.spec, W2 저장 세부, W3 업로드·붙여넣기·F5, W4 정렬 상속·콤보 사실). 결과는 자체 시험 재실행과 engine_selfcheck 로 다시 확인

| 묶음 | 행 | 원인(재측정 실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| W1 | 6 | MSG00209: 입력 계획은 정상(T-dba493fd PASS, 999 → 1 입력 합계 1000 알림). 뒤 3행이 앞 시험의 닫힌 토스트 글자(DOM 잔존, 화면 밖)를 새 알림으로 읽음(T590). H2 2행: 부정 숫자 원자·빈 칸 원자 전제 없음, 조회 행 CRUD_TYPE 키 없음(T591). A4: 본 조회 시트 키 'route' 미인식, U+200B, 응답 대기 없음(T592, T593) | _trace.spec.ts:59, 281~296, 554, 1407~1426, 2548, 2916~ · saveerr.ts:243~261 | tsc 0, 새 시험 40/40, saveerr 55/55, condeval 21/21 |
| W2 | 6 | 빈값이 TO-BE 에서 '0' 으로 바뀌어 [입력 경로 실패](T595). CheckValid cs:1293 지역 변수 경유라 AS-IS 검증 못 찾음(T596). 앞 단계가 r360 '0' 을 남겨 경계값 99 저장이 막힘(T597). 숫자 칸 뺀 식별 값이 같음(T598). 요일 묶음 1개 이상 필수 미충족(T599) | saveprobe.ts, crud.ts, rowlink.ts, _verify.spec.ts 저장 세부 | rowlink.u5 26/26, u4 28/28 외 7종 |
| W3 | 4 | 업로드 상태 문구가 O_CUR_LIST.MESSAGE_TEXT 이고 빈 양식이 Error-Number 로 덮임(T601). M1 결과가 flush 규칙으로 버려짐(T602). F5 확인창 미처리(T603). E6 시험이 06:12 회차에 미실행, 병합 호출이 팝업 파일(T604). 단추 이름 완전 일치만(T600, 직접 고침) | _verify.spec.ts, m1upload.ts, excelcheck.ts, popk3run.ts:56~66 | m1upload 22/22, excelcheck 50/50, T600 함수 시험 7건 |
| W4 | 4 | judge 가 팝업·셀 이벤트 SP 의 A6 TRACE 행에 정렬 재료를 붙이지 않음(T605, T606, T608). setListBox ALL 행 미해석(T607) | judge.py:383, 1496 · mapping_trace.py:1245 · facts_combosrc.py:349~616 | judge_popup 22/22, mapping_trace 108/108, 사본 원장 ERROR 3 → PASS 2·NA 1, SCP0005 combo_src 1행 |

### 다음 CheckList 에서 바뀔 판정(판정 경로 기준, 미측정)

- 미검증 → 실측: H2 2행, A4 1행, F6 빈값 1행, F4 경계값 1행, F1 2행 저장 1행, 신규 행 저장 왕복 2행, M1 1행
- FAIL·미검증 → 재판정: MSG00209 3행, E3 1행, K3 2행(K3 붙여넣기는 E6 시험이 돌아야 바뀜), F6 0 값 1행
- 미검증 → PASS 2행·NA 1행: A6 팝업·셀 이벤트 조회 3행(사본 원장 실행 결과)
- 행 사라짐: FACT-708ae4ce(사실 검토 재생성 때)

### 점검

- engine_selfcheck PASS(08:12, 60.6초, CTRL_CHARS 0, TSC 0, selftest JS 40·PY 66)
- 사고: T600 첫 패치가 셸 경유로 역슬래시가 반으로 줄어 정규식이 `^\s*` 대신 `^s*` 가 됨 → Edit 로 바로잡고 파일 문자열 대조 시험 통과. 이후 패치는 Edit 또는 파일 쓰기로만
- 백업 *.bak_20261125_scp05u5. 새 파일 rowlink.u5.selftest.js
- DB 쓰기 없음

## 라운드 6 (2026-11-25 18:19 ~ 19:2x · 행 단위 해소)

- 입력: 해소 원장 unverified_worklist.csv(기준 17:00:47, 갱신 18:19:15) 열림 10행(검사기 9, 데이터전제 1), 집계 6행. 직전 측정 row_run RR20261125170349(17:03~17:28)
- 조치표 _unverified_plan.md(10행, 빠진 행 0). 콤보 Valid, 업로드 팝업 인자 2묶음은 하위 에이전트 2개(다른 파일). 하위 에이전트 변경은 diff 와 자체 시험(combo_oracle 19/19, popup_args_check 16/16)으로 다시 확인
- 판정은 row_run 출력과 해소 원장으로만 봄. 원장, e2e_results.json 손으로 고치지 않음

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 재측정(row_run) | 결과 |
|---|---|---|---|---|---|
| K1 그리드 조작 | V-27f100cb, V-f426f87d, V-7ccb8dd4, V-612b1d63 | 17:03 증거 '셀 좌표 확인 실패(2행 · LT_TYPE): wj-listbox-item'. copy 단계가 0행 LT_TYPE 을 선택한 뒤 ctrl 단계가 같은 칸을 다시 눌러 콤보 목록이 열리고 2행 자리를 덮음(T630) | Doc/e2e/specs/_verify.spec.ts cellPt | 18:35~18:38 | 4행 오류 → 통과 |
| K2 2행 동시 저장 | V-26d2974c | row_run 17:03 '저장 세부' 534ms 종료(T631, 첫 줄 조건). 08:16 측정 '저장에 실패'는 ROUTE_ID 7303 AVERAGE, 7305 MAX(같은 경로 MIN 1행) 형제 행 짝이라 유일 키 UK_SCP_MST_DISTRIBUTION_ROUTE(LT_TYPE 포함) 충돌(사내 오라클 18:2x 조회)(T635) | _verify.spec.ts 저장 세부 첫 줄·pickPair, tools/E2E/lib/saveprobe.ts soloIdentity | 18:38~18:48 | 오류 → 통과(FROM_COUNTRY 2행 CN → KR 저장·원복 OK, 형제 행 제외 20행) |
| K4 Excel Form | V-a32c8abf | _trace.spec M1 고정 '[측정 코드 없음]' 문구(T632). row_run 이 기록된 시험에만 붙여 옮긴 측정을 못 돌림(T634). 첫 재측정은 판정필요인데 judge 판정필요 정리가 증거 첫머리 문구로 오류로 바꿈 | _verify.spec.ts 'Excel 양식·업로드', _trace.spec.ts M1, tools/Harness/verify/row_run.py pick_tests | 18:48(오류 유지), 18:56 | 오류 → 판정필요(팝업 없이 양식 다운로드 6,968바이트, CR-095 사용자 판정) |
| K4 Excel 업로드 행 상태 | V-219edc76 | row_run 17:03 489ms 종료(T631). 업로드 창 단추가 OK·Cancel 뿐인데 'Upload' 단추만 찾음(m1_result_SCP0005.png)(T633). 18:48 대조군 'Error-Duplicate' = 시험 파일 안 중복(T637). 18:56 대조군 'Error-Unique Duplicate' = 응답 오류 행 짝짓기 동점(건수 성공 1·오류 9 는 기대와 같음)(T638) | _verify.spec.ts M1, tools/E2E/lib/m1upload.ts | 18:48, 18:56 | 시도 2회 뒤 미검증 → 결정 R6-D2. T638 은 재측정 안 함 |
| K5 조회조건 Valid | V-052d2add | combo_oracle 이 TO-BE 후보의 ALL 은 빼고 AS-IS 정적 목록 ALL 은 남김(T612, 하위 에이전트). row_run 정적 묶음에 combo_oracle 없음(T639) | tools/Harness/verify/combo_oracle.py, row_run.py | 19:00(그대로), 19:04 | 오류 → 통과 |
| K6 업로드 팝업 인자 | V-a6bb7234 | 인자 #2 this.spdMain.ActiveSheet.SheetName = 'Distribution Route'(cs:78, 233) ↔ TO-BE 업로드 주소 ADMIN_SHEET_NAME[SHEETS.ROUTE](ExcelUploadModal.tsx:133)(T620, 하위 에이전트). judge 대체 호출 행이 이전 판정 행을 다시 판정 안 함, row_run 정적 묶음에 popup_args_check 없음(T639). 19:04 재측정 뒤 같은 행 두 호출 묶음 중 뒤 묶음(SaveExceptError 해당없음)이 앞 판정을 덮음 | popup_args_check.py, judge.py G5 _put·T577, row_run.py | 19:00(그대로), 19:04 | 오류 → 해당없음(덮어쓰기 결함). 합치기 고침 뒤 재측정 안 함, 결정 R6-D3 |
| K3 신규 행 저장(계정) | ES-836708a8 | 저장 차단 문구 '[Working Days]' 는 TO-BE 코드 고정 글자(useDistributionRouteValidation.ts:41)라 머리글 묶음을 못 찾고 기록 없이 넘어감(T636). 19:08 실측 묶음 머리글 = 'Departure Days' | tools/E2E/lib/rowlink.ts groupCandidates, crud.ts | 19:07~19:13 | 오류 → 통과(DAYS_MON=Y 채운 뒤 저장 2회 성공). 마커 행 정리 실패(locator.click 20초) → 결정 R6-D4 |

- 남은 시험 행: ROUTE_ID 11172, 11173(jooyong026, 19:08·19:10) 원래 표 2행, 이력 표 2행. cleanup_marker 는 저장 키 기록(crud_keys.json)이 없어 지우지 않음. 19:13 백업(Doc/verify/SCP0005/cleanup/*_SCP_MST_DISTRIBUTION_ROUTE*.csv) 뒤 삭제, 건수 단언 2 = 2, 확인 조회 0건
- K2 2행 저장은 기존 행(FROM_COUNTRY CN → KR → CN) 실저장·원복 OK. 이력 표 기록은 체인 끝 restore_touched 몫
- engine_selfcheck PASS 5회(18:34, 18:55, 19:00, 19:04, 19:07 · 마지막 TSC 0, selftest JS 40·PY 67)
- 백업 *.bak_20261125_scp05u6(_verify.spec.ts, _trace.spec.ts, saveprobe.ts, rowlink.ts, crud.ts, m1upload.ts, row_run.py, judge.py, combo_oracle.py, popup_args_check.py, _checker_defects.md)
- 새 도구 파일 없음(함수 추가만) → inventory_check 등록부 갱신 안 함
- 마무리: pending_recheck --mark 19:14, unverified_resolve --no-rerun 19:14
- 추가 확인 후보: 신규 행 정리 클릭 시간 초과 원인(crud.ts 정리 단계), judge '[Errno 22] llm_review_base.json' 반영 실패(18:38 row_run 로그), row_run '장시간 세션 조회 실패 DPY-6005'(18:48)

## 라운드 7 (2026-11-25 22:42 ~ 23:37 · 행 단위 해소)

- 입력: 해소 원장 unverified_worklist.csv(기준 21:07:34, 생성 22:36:28) 열림 21행(검사기 11, 데이터전제 6, AI후보 4), 집계 3행. 조치표 _unverified_plan.md(21행, 빠진 행 0)
- 하위 에이전트 안 씀(4묶음이 judge.py, eg_popup.spec.ts, _trace.spec.ts 를 같이 고침)
- 판정은 row_run 출력과 해소 원장으로만 봄. 원장, e2e_results.json 손으로 고치지 않음

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 재측정(row_run) | 결과 |
|---|---|---|---|---|---|
| R7-1 저장 감사 계정 | V-a8518547, V-4bee5c9b, V-91dc58e6, EG 6행 | cleanup_20261125_191358.sql 머리글에 계정 없음 → 기본 계정 minyonglee1 기대(저장 jooyong026). judge F8 블록이 EG 행(save_trace PASS)을 덮음. eg_ingest 마지막 줄(NA) 사용(T640, T641) | save_audit.py, judge.py, eg_ingest.py, cleanup_marker.py, ledger_guard.py | 22:57~23:10 | 9행 오류·FAIL → 통과 |
| R7-2 저장 응답 표본 | H2 5행 | 19:41 부분 재측정이 .prev 를 덮어 route/SAVE 표본 0건(T642) | btnpopup.ts persistRespSamples, _trace.spec.ts | 23:10~23:16 | 5행 오류 → 통과 |
| R7-2 저장 응답 표본 | V-3134fc3e, T-ece1c98b, T-f048d4a9 | 23:16 표본 해소 뒤 '[서버 문구 표시] 실제 서버 문구 잴 수 없음'. 화면이 응답 MSG 열을 그대로 띄움(가짜 응답 표지 실측). 원문 문구 원천 없음(T646) | 새 proc_errmsg.py, _trace.spec.ts | 23:16(그대로), 23:21~23:23 | 3행 오류 → FAIL('DUP DATA.' ≠ MSG00043) · 결정 R7-D1 |
| R7-3 빈값 비교 | V-6e159871 | golden 컬럼 프로파일이 ''↔'/' 를 값 다름으로 셈(T643). row_run 정적 묶음에 golden.py 없음(T648) | golden.py, row_run.py | 23:23(그대로), 23:30~23:32 | 오류 → 통과(확인 필요 0) |
| R7-4 신규 행 정리 | ES-88905017 | 화면 삭제는 신규 행만(AS-IS cs:302~308, TO-BE DistributionRoute.tsx:148)(T640). 23:23 재측정에서 행 클릭 20초 예외가 정리 위임을 건너뜀, 시험 행 2건 잔존(T647) | crud.ts deferDbCleanup·삭제 예외 분리 | 23:23(FAIL 그대로), 23:30~23:32 | FAIL → 통과(cleaned=Y, DB 정리 위임) |
| R7-5 버튼 테두리 | V-fe802ac0 | 버튼 전 영역 실측이 BTN 팝업 건너뜀, 결함 상속이 팝업 버튼 순서 FAIL 을 'City' 낱말로 물려받음(T644). 업로드 버튼 대응 누락(T646) | eg_popup.spec.ts runCorners·btnLocator, judge.py | 23:33~23:35 | 오류 → 통과(EG-a6f0d10d 네 모서리·중앙 열림) |
| R7-6 팝업 선택 반영 | EG-f36911c9 | 22:36 고른 1행 ADALV 인데 칸 ADCAN 유지(popup_rowsets call 6). AI 검토 '같은 값' 은 행 기록과 다름. 1회 읽기·부분 일치 대응 컬럼(T645) | eg_popup.spec.ts PICK_OK | 23:33~23:35 | 오류 → 통과('CAWND'→'ADALV') |

- DB 쓰기(시험 행 정리만, 백업·건수 단언): 22:52 원래 표 11행·이력 표 24행(cleanup_20261125_225211.sql), 23:30 원래 표 2행·이력 표 4행(cleanup_20261125_233003.sql), 23:32 row_run 정리(cleanup_20261125_233224.sql). 23:33 조회 E2E 마커 0건. 22:52 dry-run 기록 파일은 지움(백업 CSV 중복)
- 새로 보인 측정 실패 1행: EG-6e3313da(To City 칸 팝업 2행 Ctrl 선택 뒤 칸 CAWND 유지, 23:35) → 결정 R7-D2
- row_run 반입은 AI 권장안 적용을 다시 하지 않아 결정 행 21행(R4-D1~D5 등)이 원장에서 오류로 보임. 다음 CheckList 1단계가 다시 적용함
- 점검: engine_selfcheck PASS 5회(22:56, 23:12, 23:20, 23:29 · 마지막 TSC 0, selftest JS 40·PY 68). 줄바꿈 CRLF 유지(eg_popup.spec.ts 1123/1123, _trace.spec.ts 3523/3523, crud.ts)
- 새 도구 proc_errmsg.py → inventory_check --write-registry 23:20
- 마무리: pending_recheck --mark 23:36, unverified_resolve --no-rerun 23:36
- 추가 확인 후보: crud.ts 화면 삭제 단계 행 첫 칸 클릭 시간 초과(매회), TO-BE 이력 표 신규 저장 행 ROUTE_ID 0 기록(AS-IS 이력 SP 비교 미확인), tools/Harness/_verify_next/eg_ingest.py 사본은 고치지 않음
