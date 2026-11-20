# SCP0028 미검증 해소 작업 기록

## 라운드 1 (2026-11-19 16:35 ~ 17:1x · 일괄 보완)

- 입력: CheckList 원장 `verify_ledger.csv`(16:34:49), 분류 `unverified_triage.*`(16:35:20). 원장 미검증 278행 = 처리 대상 141(엔진 109, 판단 30, 자동 2), 집계 137
- 행별 조치 표 `_unverified_plan.md`(141행, 처리 대상 141행과 같음). 결정 목록 `_unverified_decisions.md`(D1~D19, 70행). 표 생성 `_unverified_plan_gen.py`
- 재측정: run_verify, 개별 검사기 재실행 안 함(사용자 지시 2026-11-18 일괄 보완 뒤 전체 검증). 확인은 단위 함수 시험, 사실 파일 재생성 diff, engine_selfcheck

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| A BE 정지 | 12 | `e2e/results.json` 문서 시나리오(05:30Z 시작, 3,068초): '[BE 대기] 로그인 … 300초 안에 BE 가 뜨지 않음' 3회, '[openScreen] SCP0028: 주소 진입 뒤 Home 에 남음' 10회. Home 이동을 '화면 권한 없음'으로 기록. `_server_8080.log` 15:26:00 server_guard 기동 | `tools/E2E/lib/nscm.ts` openScreen(BE 포트 확인, waitBeUp, 재로그인, 1회 재시도, beDown), `Doc/e2e/specs/_verify.spec.ts` 시나리오 실패 문구, `tools/Harness/verify/unverified_classes.csv` 20행 (T360) | tsc 0. 실제 BE 정지 재현은 미측정 |
| B 조회 0행 메모 | 7 | 같은 results.json 05:27Z '버튼 경로 메시지·모달 조건' 테스트 출력 '[required] From Site: 후보 없음(목록 0개)'. 증거 '대안 없음 전부 0행 … 재시도 생략' = 대안 시도 0건인 실행이 메모를 남김 | `tools/E2E/lib/smoke-extra.ts` ensureRows 메모 조건 (T361) | tsc 0 |
| C Insert 무동작 | 26 | AS-IS SCP0028_Shipment_Lot_Size.cs:200~203 InsertButton → InsertRow(), 571~573 InsertRow 본문 비어 있음. TO-BE 실측 'Insert 무동작', 'Insert 뒤 신규 행 없음' | `tools/Harness/verify/facts_lockrules.py` insert_noop, `tools/Harness/verify/judge.py` _asis_insert_noop, insert_noop_na (T362) | 원장 단위 시험 26행 해당없음. facts_lockrules SCP0028 재생성 diff = new_row 열 UNKNOWN → NONE 18칸만. 빈 본문 판정 134화면(원문 확인 표본 SCP0096 cs:274, SSP0020 cs:897) |
| D Valid 별칭 | 8 | 원장 V-cd32453c '조회조건 실측 5 … CR-092', T-5fa3ec51 'TO-BE 헤더 Active'. 사내 오라클 LBL00007 KO·EN·CN = Active(16:5x). combo_runtime.json search 키에 Valid 없음 | `Doc/e2e/specs/_verify.spec.ts` findSearchBox, VERIFY_ALIASES (T363) | tsc 0 |
| E 기준표 없음 | 7 | `SCP_DM_화면별 조회조건 정리_260122_v0.4.xlsx` 6시트 SCP0028·Shipment Lot 0건. search_cond.csv SCP0028 0행 | `tools/Harness/verify/judge.py` 기준표 없는 화면 경로 (T364) | py_compile 0 |
| F 다른 화면 결함 유형 | 6 | 대상 칸(End Customer, Sold-to Customer, Sales Company, Sales Plant, Cust Group, Sales Site)이 원장 COLUMN 98행, SEARCH 7종에 없음 | `tools/Harness/verify/judge.py` cascade_entities, _absent_ents (T365) | 원장 모의 시험 6행 해당없음, 4행 유지(D7) |
| G Input 버튼 | 3 | 버튼 목록 '…Search(F5), 입력, Delete, Insert(F8)…'(계정 언어 KO). 사내 오라클 LBL00872 EN Input, KO 입력(16:5x) | 신규 `tools/E2E/lib/labeltrans.ts`, `Doc/e2e/specs/eg_popup.spec.ts` (T366) | labelVariants('Input') = ['입력'] |
| H 언어 전환 | 2 | 다른 화면 동시 실행 전환 생략(T200). 15:4x langacct.ts 로 보완된 상태 | 수정 없음 | 해당 없음 |

### 고치지 않고 결정 목록으로 보낸 행

- D1~D19 70행. D5(2행)는 SSP0014 세션 T355, D17(1행)은 T357 과 같은 증상이라 다음 CheckList 에서 다시 잼

### 다음 CheckList 에서 바뀔 판정(검사기 판정 경로 기준, 미측정)

- 미검증 → 해당없음: C 묶음 26행(D1 컬럼 15행은 원장 재생성 때 행이 만들어지지 않음), F 묶음 6행, SC1 V-119cf5cb
- 미검증 → 실측(통과 또는 오류): A 12행, B 7행, D 8행, G 3행, H 2행, H5 6행(라벨을 못 찾으면 사유를 붙인 미검증)
- 미검증 유지: 결정 목록 70행(D5, D17 은 다른 세션 보완분으로 바뀔 수 있음)
- 다른 화면: Insert 빈 본문 화면 134개의 신규 행 전제 행, 기준표 행 0 화면의 H5·SC1, 'Valid'·'Input' 처럼 별칭·다른 언어 라벨을 쓰는 화면

### 점검

- engine_selfcheck PASS(17:0x, PY_COMPILE 0, TSC 0, selftest JS 31, PY 53)
- inventory_check --write-registry: 도구 242, 등록부에 없는 도구 0. GATE_SCOPE·STAGE_WARN 실패는 다른 세션 run_verify.py 16:53 수정분(이번 수정 아님)
- 줄바꿈: judge.py LF, nscm.ts CRLF 를 수정 전 형식으로 되돌림. 추가 줄의 줄표를 쉼표로 바꿈
- 백업 `*.bak_20261119_scp28u`(_verify.spec, eg_popup.spec, nscm, smoke-extra, facts_lockrules, judge, unverified_classes)
- 시험 데이터: TO-BE 저장 없음. 사내 오라클 조회 1회(SCM_ADM_MSG_M LBL00872, LBL00007). Doc/asisfacts/screens/SCP0028 edit_expect.csv, lock_rules.csv, color_rules.csv 재생성(facts_lockrules)
- FE 가이드: 없음(이번 라운드 화면 결함 확정 0건)

## 2026-11-20 라운드 (07:5x ~ 08:3x · CheckList 07:38 원장 · 일괄 보완)

- 입력: 원장 `verify_ledger.csv`(07:38), 분류 `unverified_triage.*`(07:48:27). 처리 대상 111행(엔진 81, 판단 30), 집계 113행
- 행별 조치 표 `_unverified_plan.md`(111행, 처리 대상과 같음, 23묶음). 결정 목록 `_unverified_decisions.md`(D1~D11, 22행). 생성 `_unverified_plan_gen.py`. 지난 라운드 표는 `*.r1_20261119` 로 남김
- 재측정: run_verify, 개별 검사기 재실행 안 함. 확인은 단위 함수 시험, 시험 스크립트, 사실 파일 재생성 diff, engine_selfcheck
- 지난 라운드와 같은 시도 없음. 지난 라운드 결정 D1(저장 표본)은 이번 원장 실행 기록으로 원인(숫자 칸 글자 누락)을 확인해 C 묶음으로 고침

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| A Delete 단추 | 7 | SubTitle.tsx:397~468 화면 단추 'Delete'(일괄삭제 팝업)가 툴바 'Delete(F9)' 앞. eg_auth.spec.ts `/^Delete/`, subButton('Delete').first() 가 화면 단추를 잡음 | tools/E2E/lib/nscm.ts:724~733, authprobe.ts:67~78, Doc/e2e/specs/eg_auth.spec.ts:167·317·332~336, crud.ts:307 (T430) | tsc 0 |
| B crud insert | 1 | AS-IS Insert 빈 본문(asisInsertNoop 실행 문장 0). crud.ts 가 Insert 단추만 보고 마커 행 경로 | tools/E2E/lib/crud.ts:41~53·70 (T431) | asisInsertNoop SCP0028 사실 noop=true(node 08:1x) |
| C 숫자 칸 글자 누락 | 1 | e2e/results.json crud 기록 '12801' → 요청 lotSize '1'·'12'·'1280' | tools/E2E/lib/crud.ts:139~150 (T432) | tsc 0 |
| D 정렬 NULL | 1 | sort_ci_check nullable 이 같은 이름 칸 전체를 봄. PKG_SCP0028 본문 키 5개 원본 SCP_MST_SHIPMENT_LOT_SIZE NOT NULL(사내 오라클 08:0x) | tools/Harness/verify/sort_ci_check.py stmt_before·key_source·nullable (T433) | --selftest 21/21 · 본 조회 SP 키 5개 원본 표 추적 읽기 전용 확인 |
| E Model 라벨·입력 | 6 | 기준표 'Model' → 'Model/Nickname' 75/78행. G8·G9 가 그리드 머리글 'Model' 을 라벨로 잡음(조회 1940행, 본문에 입력값 없음) | judge.py H5(T434), labelalias.ts stdAlias, smoke-extra.ts:117, _verify.spec.ts findSearchBox·G8/G9 (T434, T442) | 판정 논리 재현 75/78 PASS · Material 3행 미적용 |
| F 탭 이름 | 1 | MNU00091 KO·EN·CN 'SSP Lot Size'(msg_master.csv) | labeltrans.ts msgTexts, _verify.spec.ts 탭 이름 (T435) | tsc 0 |
| G 권한 동기화 | 1 | menu_auth_sync FAIL 2건 · SCP0104 V-24ff60ab 사용자판정 | confirmed_requirements.csv CR-116, judge.py J4 (T436) | tobe_rule_registry --build, --check rc 0 |
| H G6 팝업 알림 | 1 | 일괄입력 팝업 Find 필수 알림이 화면 기록에 섞임 | nscm.ts:503~504·555~562 (T437) | tsc 0 |
| I 콤보 원천 추출 | 14 | DataBind(Data.Type.YesOrNo, true)(cs:135) 미추출 · ClearUsrCheckedList(cs:149, 호출 0) 오추출 → b7 '원천 미확인 control' | facts_combosrc.py DataBind·dead_private (T438) | combo_src.csv 재생성 diff: control 행 삭제 1, cboValid 행 추가 1 |
| J 신규 행 결함 유형 | 3 | _no_insert 가 Insert 빈 본문 화면을 보지 않음 | judge.py _no_insert (T439) | py_compile 0 |
| K 병합 셀 Delete | 1 | 화면 단추 'Delete' 를 누름(알림 = 팝업 제목) · AS-IS Delete 신규 행만(DeleteButton:223) | _verify.spec.ts 병합 셀 Delete, mergecheck.ts asisNewOnly (T440) | mergecheck.selftest 35/35 · asisDeleteNewOnly SCP0028 newOnly=true |
| L 조회 전 Delete | 1 | 조회 전 프로브 Insert 만 | _verify.spec.ts D4 (T441) | tsc 0 |
| M 팝업 호출 기록 | 3 | eg_chain(CL_SELFTEST_BASE) 실행이 calls/*.json 미기록(calls 폴더 eg_* 0) | fixtures/test.ts:90, eg_chain.py:56 (T443) | tsc 0 · py_compile 0 |
| N 시나리오 라벨 | 2 | btn 'Input'(KO '입력'), iscombo 'Division'(TO-BE 'Div.') | _verify.spec.ts 시나리오 btn·iscombo (T444) | tsc 0 |
| O 신규 행 시나리오 | 3 | 시나리오 문구가 insert_noop_na 문구표에 없음 | judge.py NEWROW_MISS_RE·NEWROW_STEP_RE (T445) | 단위 시험: 대상 2행 NA, 편집 중 Input 행 미검증 유지 |
| P 원값 복원 | 1 | 편집기 주입만 써서 LOT_SIZE 안 바뀜 | _verify.spec.ts 원값 복원 (T446) | tsc 0 |
| Q 골든 인자 | 1 | @p_to_site 선언 기본값 '' 을 빈 값으로 셈(SKIP) | tools/DbConn/golden.py (T447) | py_compile 0 |
| R SwitchLock | 1 | EditButton SwitchLock 문장 판정 경로 없음 | judge.py CR-093 블록 (T448) | py_compile 0 |
| S 이어받기 집계 | 8 | 팝업 EG 행 이어받기 문구가 미분류 | unverified_classes.csv 11행 | classify 시험 2건 집계 |
| T 공용 권한 SP | 1 | PR_GET_MNU_BTN_AUTH 를 PROC_M 배선으로만 찾음 | judge.py F4 (T449) | py_compile 0 |

### 고치지 않은 행

- U 이번 라운드 미보완 35행: K3 팝업 그리드 6, 팝업 실행 경로(H6·G5·M4) 18, 팝업 Delete 5, 입력용 SP 2(F4, A7), C2 연쇄 결함 유형 5(결정 D9 겹침). 엔진 확장이 필요해 다음 라운드 대상
- V 동시 실행 2행(V-ca2072cf, V-1f64fec6): 시나리오 지정 계정 dana.robot, 같은 시각 다른 화면 E2E 3개로 언어 전환 생략(T200 보호). 다른 화면 E2E 가 없을 때 실측
- W 1행(V-dd4f9db4): SSP0014 세션 T385(_trace.spec.ts:1491, 07:54)와 같은 증상
- 결정 목록 D1~D11 22행

### 다음 CheckList 에서 바뀔 판정(검사기 판정 경로 기준, 미측정)

- 미검증 → 해당없음: J 3행, K 1행(서버 요청·일부 D 면 FAIL), O 3행, R 1행
- 미검증 → 통과 경로: D 1행, E 의 H5 1행, F 1행, G 1행, T 1행(EG374·EG411 실측 따라 FAIL 가능)
- 미검증 → 실측(통과 또는 오류): A 7행, B 1행(행 이름이 edit-save 로 바뀜), C 1행, E 5행, H 1행, I 14행, L 1행, M 3행, N 2행, P 1행, Q 1행
- 집계로 분류: S 8행(하위 행 따라감)
- 다른 화면: Delete·Save·Insert 화면 단추가 있는 SubTitle 화면의 EG369·EG374·EG411·authcrud, DataBind(Data.Type.X) 콤보를 쓰는 AS-IS 화면(GSCM 약 80건), 기준표 행 0 화면의 'Model' 류 조회조건, 선언 기본값 '' 인자를 가진 골든 대상 SP, 공용 권한 SP F4 행

### 점검

- engine_selfcheck PASS(08:23:18, PY_COMPILE 0, TSC 0, CTRL_CHARS 0, selftest JS 32, PY 59). T449 뒤 judge.py py_compile 0
- tsc(tools/E2E · 스펙 포함) 오류 0
- 백업 `*.bak_20261120_scp28u2*`(nscm.ts, authprobe.ts, crud.ts, eg_auth.spec.ts, _verify.spec.ts, sort_ci_check.py, judge.py, confirmed_requirements.csv, facts_combosrc.py, labeltrans.ts, labelalias.ts, smoke-extra.ts, mergecheck.ts·selftest, unverified_classes.csv, fixtures/test.ts, eg_chain.py, golden.py)
- 줄바꿈: 셸 편집이 nscm.ts·crud.ts·authprobe.ts·eg_auth.spec.ts 를 LF 로 바꿔 백업 기준 CRLF 로 되돌림(08:0x). 제어 문자 0
- 다른 세션 겹침: judge.py 를 SSP0014 세션이 같은 시각에 고침(T405·T38x). 수정 직전 다시 읽고 필요한 부분만 고침. 내 표식 T430~T449 21종 남아 있음 확인
- 시험 데이터: TO-BE 저장 없음. 사내 오라클 조회(ALL_SOURCE PKG_SCP0028, ALL_TAB_COLUMNS 2표). Doc/asisfacts/screens/SCP0028/combo_src.csv 재생성(facts_combosrc)
- FE 가이드: FE_GUIDE_20261120_0817.md 1건(대조표 17행 Model 팝업). doc_style 위반 0

## 2026-11-20 라운드 3 (13:10 ~ 13:44 · CheckList 13:07 원장 · 일괄 보완)

- 입력: 원장 `verify_ledger.csv`(13:07:33), 분류 `unverified_triage.*`(13:10:16). 원장 미검증 87 = 엔진 19, 결정 2, 집계 66. AI 검토 행 20 포함 처리 대상 39
- 행별 조치 표 `_unverified_plan.md`(41행 = 처리 대상 39 + 결정 2, 끝에 처리 결과 표). 결정 목록 `_unverified_decisions.md`(R3-D1~D13). 지난 라운드 표는 `*.r2_20261120`
- 하위 에이전트 4개로 나눔(P1 mapping_trace, P2 파이썬 검사기 8종, T1 _verify.spec.ts, T2 _trace.spec.ts). 고친 곳은 T 표식과 llm_review 반영 조건 코드로 다시 확인함
- 재측정: run_verify, Playwright 실행 안 함. 확인은 selftest, 사본 원장 드라이런, 산출물 재생성 diff, tsc, engine_selfcheck

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| P1 팝업 규칙 대상 | 11 | mapping_checks.csv EVT_POPUP 이 FE 대조표 행 글의 '팝업' 낱말로 G5, H6, M4 를 붙이고 행에 적힌 이름 전부를 대상으로 잡음. AS-IS clbFromSite(Designer.cs:42), clbToSite(:63) 체크 목록, TRANS_MODE_CODE(cs:75, 646, 499) 셀 이벤트 0건, btnInput(cs:270~284)·btnDelete(cs:298~312) 팝업 뒤 재조회만 | tools/Harness/verify/mapping_trace.py:593~608, 649~652, 1228~1235, 1528~1712, 2333 (T480) | selftest 108/108, 드라이런 11/11 해당없음, 93화면 1,522건 중 해당없음 240 |
| P2a DM-52 | 1 | gen_expect.py P15 가 AS-IS 차단 없는 버튼에도 행 생성. CR-022 는 차단 메시지 코드 규칙. btnInput_Click cs:260~274 차단 없음 | gen_expect.py (T485) | DM-52 행 58화면 36 → 8 |
| P2a 기본 문구 | 1 | remember(MSG.INC_GT_LOT, '…')(useShipmentLotSizeValidation.ts:52) 기본 문구 미인식. MSG01127 KO, EN, CN 등록(msg_master.csv:3675~3677) | i18n_static.py (T486) | selftest 12/12, i18n_static.csv 1행 빠짐 |
| P2a AI 반영 | 1 | 실측 [Open, Search, Close, OK](popup_results.json 12:49) FAIL 을 AI 가 같은 룰 CR-005 와 무관한 인용(cs:246)으로 PASS 처리. SCP0007 사용자 정정은 OK 먼저인 팝업 건 | llm_review.py same_rule_block (T487) | selftest 5건 추가, tobe_rule_registry --check 위반 0 |
| P2b 정렬·시노님 | 3 | sort_check 가 AS-IS sort_rules 에 있는 SP 만 행 생성. MATERIAL SP, PR_GET_MNU_BTN_AUTH 는 AS-IS 경로 SP 8종에 없음. PR_GET_MNU_BTN_AUTH = Auth.xml:26 BE 매퍼 전용 | sort_check.py, syn_check.py (T488) | sort_check selftest 10/10, sort_check.csv 2행(PASS, NA), syn_check.csv 3행 OK |
| P2b B6·G5·A7 | 4 | B6 기준표 0행 화면 기대 없음(cboValid.DataBind(YesOrNo, true) cs:135). G5 setBatchMode → mode prop → actionFlag(ShipmentLotSize.tsx:338·343, BatchModal:142·173) 미추적. A7 INPUT SP 인자 = 팝업 선택 결과(cs:278~280, 417~423), 실행 기록 0건 | judge.py B6·A7, popup_args_check.py, golden.py (T489) | popup_args selftest 10/10, popup_args.csv 2행 PASS, golden md 사유 기록 |
| T1 K3 팝업 그리드 | 5 | _verify.spec.ts 가 행 문구에 '팝업'이 있으면 재지 않고 '미포함: 팝업 그리드' 를 붙임 | _verify.spec.ts:3592, 3663~3700, 173, 3710, 3795~3848, tools/E2E/lib/popk3.ts, popk3run.ts (T496, T500) | tsc 0, popk3.selftest 40/40 |
| T1 Model 조건 | 2 | G8/G9 시험이 G2 행을 고르지 않음. SEARCH G5 는 G10 행이 있을 때만 잼 | _verify.spec.ts:4055~4076, 3229, 3318~3335 (T497, T498) | tsc 0 |
| T1·T2 From Site 후보 | 1 | 후보는 코드(AU000062_81-P), 라벨 칸 FROM_SITE_DESCRIPTION 은 설명. 코드는 숨은 칸 FROM_SITE(constants.ts:183) | tools/E2E/lib/condcol.ts, smoke-extra.ts:890, _trace.spec.ts:1636 (T499) | selftest 6건, tsc 0 |
| T2 기능 단추 팝업 | 1 | popup_args btnDelete_Click 2행 인자 원천이 "D", sDivision_id 라 칸 라벨 0개를 '없음'으로 기록 | _trace.spec.ts G4 (T501) | tsc 0, btnpopup selftest 30/30 |
| T2 일괄 입력 경로 | 1 | INPUT SP 는 Input 팝업 OK 뒤 조회(cs:260~284, FindInput cs:417). 시나리오 없음. _verify CRUD 가 btn INSERT 로 저장 SP 로 보고 T210 으로 덮음(_verify.spec.ts:1022) | _trace.spec.ts 'BTN 팝업 경로'(T502), _verify.spec.ts 저장 SP 대상에서 _GET_ SP 제외(T506) | tsc 0, 정규식 시험 2건 |
| T2 일괄 삭제 메시지 | 4 | FindDelete 결과 S → MSG00031(cs:544), 그 밖 MSG00284(cs:553). 삭제 행 복원 경로 없음(restore_touched 키 없는 복원은 지운 행 제외) | _trace.spec.ts 'BTN 팝업 경로' 가짜 응답, W4 E4 넘김, tools/E2E/lib/btnpopup.ts (T503, T504) | tsc 0. 실삭제 안 함 |
| T2 H2 배경색 | 1 | 조건 action==FlagM 을 조회 결과 265행에서 찾음 | _trace.spec.ts H2, h2RuntimeEdit (T505) | tsc 0 |

### 고치지 않고 결정 목록으로 보낸 행

- R3-D2 3행(Model 팝업 교체), R3-D3, R3-D4 각 1행. R3-D1(EG-2644dff3)은 검사기를 고쳤고 화면 결함 확정 여부를 결정 목록에 올림

### 다음 CheckList 에서 바뀔 판정(미측정)

- 미검증 → 해당없음: P1 11행, T-6dc0e2d5
- 미검증·판정필요 → 통과 경로: T-653f1a5d, T-52d59336, V-5d06fca9, V-480372c9, V-86b2f489
- 행 생성 안 됨: V-c346a4a2, EG-bd80125c
- PASS(AI 반영) → FAIL: EG-2644dff3
- 미검증 → 실측(통과 또는 오류): K3 5행, V-db17a330, V-99331be4, V-dd4f9db4, T-d6ad4a4e, T-6b9a8ce8, 삭제 메시지 4행, V-a99ddb18
- 미검증 유지(사유 명시): V-8da88867
- 다른 화면: T480 해당없음 240건(종전 PASS 9건은 R3-D7), T485 DM-52 행 28건 빠짐, T487 SCP0005 AI 반영 3행 빠짐(R3-D8), 팝업이 있는 화면의 K3 팝업 측정, 숨은 코드 칸이 있는 다중 선택 조회조건

### 점검

- engine_selfcheck PASS(13:44:10 · TSC 0 · SELFTEST_JS 34 · PY 65 · RULE_REGISTRY 0). 13:38 FAIL(llm_review selftest 가짜 룰 번호, golden.py 작업 중 미정의 이름)은 13:41 해소
- inventory_check --write-registry 13:4x 실행. 새 파일 tools/E2E/lib/popk3.ts, popk3run.ts, condcol.ts, btnpopup.ts 는 등록부 tools/Harness/README.md 에 0건(등록 범위 밖 여부 미확인)
- 줄바꿈: _verify.spec.ts CRLF 4247/4247, _trace.spec.ts CRLF, mapping_trace.py CRLF 유지. 새 lib 파일 LF
- 백업 `*.bak_20261120_scp28u3`(gen_expect, i18n_static, llm_review, sort_check, syn_check, judge, popup_args_check, golden, _verify.spec, smoke-extra, _trace.spec), mapping_trace.py.bak_20261120_scp28u3b
- 다른 세션 겹침: judge.py 에 다른 세션의 미커밋 'AI 권장안 되돌리기' 블록 있음(건드리지 않음). T490~T495 는 다른 세션 사용
- 시험 데이터: TO-BE 저장, 삭제 없음. 사내 오라클 읽기만(PKG_SCP0028 예외 분기, MATERIAL SP ORDER BY, 시노님). 재생성 산출물: i18n_static.csv, sort_check.csv, syn_check.csv, popup_args.csv, Doc/golden INPUT md
- FE 가이드: FE_GUIDE_20261120_1320.md 1건(Model 팝업 단추 순서). doc_style 위반 0. fixlist.csv 에 EG-2644dff3 행 없음(지금 원장 PASS)이라 고치지 않음
