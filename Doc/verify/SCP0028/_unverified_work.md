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

## 2026-11-20 라운드 4 (16:39 ~ 16:5x · CheckList 16:06 원장 · 일괄 보완)

- 입력: 원장 `verify_ledger.csv`(16:06:41), 분류 `unverified_triage.*`(16:06:50). 원장 미검증 53 = 엔진 12, 판단 2, 집계 39. AI 검토 행 1(EG-ac06e957) 포함 처리 대상 15
- 행별 조치 표 `_unverified_plan.md`(15행, 묶음 6개). 결정 목록 `_unverified_decisions.md`(R4-D1~D3, R3-D7~D13 이월). 지난 라운드 표는 `*.r3_20261120`
- 하위 에이전트 1개(golden.py). 고친 내용은 T514 표식, py_compile, ⑤단계 조건 코드로 다시 확인함
- 재측정: run_verify, Playwright 실행 안 함. 확인은 판정 함수 재현(node), tsc, selftest, engine_selfcheck

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| P1 일괄 입력 팝업 0행 | 5 | 필수 알림 단추 'Confirm' 이 popk3run 닫기 목록에 없음. Escape 는 basic CustomDialog(CustomDialog.tsx:283, onClose 없음)가 무시해 알림이 남고 From Site 콤보가 안 열림. eg_popup runCall 은 0행 필수 알림 뒤 채우기 단계 없음 | tools/E2E/lib/popk3run.ts takePopAlert·fillPopRows export, Doc/e2e/specs/eg_popup.spec.ts:547~550 (T510) | tsc 0, popk3.selftest 40/40 |
| P2 일괄 삭제 메시지 | 4 | run_verify.py:928 이 E2E 시작 때 결과 파일을 .prev 로 옮김. 표본은 e2e_results.json.prev T-0159f9dc. respSample·branchBody 를 그 문자열로 돌려 'S' 응답과 'F' 사본 생성 확인 | Doc/e2e/specs/_trace.spec.ts 표본 원천 .prev (T511) | node 재현, tsc 0, btnpopup.selftest 30/30 |
| P3 일괄 입력 SP 골든 | 1 | BTN 시험 실행 URL 에 main/INSERT 없음. T-6b9a8ce8 은 F4 일반 시험이 단추 이름 INSERT 로 저장 경로 NA 를 써 BTN 시험 결과가 병합 규칙에 가려짐. 골든 인자 원천은 TO-BE 호출 기록뿐 | _trace.spec.ts spPairKind·F4 저장 판단(T511), tools/DbConn/golden.py ⑤단계 팝업 행 표본(T514) | py_compile 0, getter→칸 5종 시험. popup_rowsets.json btnInput 0행이라 지금은 ERROR 유지 |
| P4 From Site 후보 | 1 | FROM_SITE 는 그리드 칸이 아니고 행 데이터에만 있음(calls/_grid_main.json). T499 는 그리드 칸만 훑음 | tools/E2E/lib/probe.ts dataKeys, smoke-extra.ts condColForOpts (T513) | 기록 표본 20행 pickCondCol: 종전 없음 → FROM_SITE 'HQ07-A' |
| P5 수정 행 배경색 | 1 | 편집기 value='' 경로로 LOT_SIZE·INCREMENT '1' 유지(증거 2회) | _trace.spec.ts h2RuntimeEdit 키보드 지움 (T512) | tsc 0 |

### 고치지 않고 결정 목록으로 보낸 행

- R4-D1 3행(EG-ac06e957, T-2c20a3fc, T-fad117f6): Model 팝업 COM0013 교체 룰 등록 범위. 사용자 지시 2026-10-08 기록은 5화면 소스 주석뿐이라 자동 등록 안 함

### 다음 CheckList 에서 바뀔 판정(미측정)

- 미검증 → 실측(통과 또는 오류): P1 5행(EG-6cc339e1 은 R4-D3 대로 FAIL 가능), P2 4행, P4 V-dd4f9db4, P5 V-a99ddb18(빈 값이 화면에서 안 들어가면 사유를 붙인 미검증)
- V-8da88867: T510 으로 Input 팝업 행이 popup_rowsets.json 에 남으면 골든 실행, 남지 않으면 미검증 유지
- T-6b9a8ce8: 해당없음 → BTN 팝업 경로 실측(통과·오류·미검증)
- 다른 화면: 'Confirm' 알림이 뜨는 팝업의 K3·H6·M3, 행 데이터에만 있는 코드 칸을 쓰는 다중 선택 조회조건, 단추 이름이 INS 류인 GET·LOG PROC 의 F4 행

### 점검

- engine_selfcheck PASS(16:56:26 · TSC 0 · SELFTEST_JS 34 · PY 65)
- inventory_check --write-registry 실행(등록부 tools/Harness/README.md)
- 줄바꿈: popk3run.ts, eg_popup.spec.ts, _trace.spec.ts, probe.ts, smoke-extra.ts CRLF 유지(LF 단독 0). golden.py LF 유지
- 백업 `*.bak_20261120_scp28u4`(popk3run, probe, smoke-extra, eg_popup.spec, _trace.spec, golden)
- 시험 데이터: TO-BE 저장, 삭제, DB 조회 없음
- FE 가이드: 없음(이번 라운드 화면 결함 확정 0건)

## 2026-11-20 라운드 5 (21:52 ~ 22:15 · CheckList 21:51 원장 · 일괄 보완)

- 입력: 원장 `verify_ledger.csv`(21:51), 분류 `unverified_triage.*`(21:52:13). 원장 미검증 30 = 엔진 4, 자동 4, 집계 22. AI 검토 행 5 포함 처리 대상 13
- 행별 조치 표 `_unverified_plan.md`(13행, 묶음 8개). 결정 목록 `_unverified_decisions.md`(R4-D1, R5-D2, R5-D3, R3-D1, R4-D3, 기준 원장 판단 대기 18·58). 지난 라운드 표는 `*.r4_20261120`
- 하위 에이전트 안 씀(묶음 8개 중 7개가 _trace.spec.ts 또는 그 lib 를 같이 고침)
- 재측정: run_verify, Playwright 실행 안 함. 확인은 selftest, 원장 사본 to_ledger 드라이런, py_compile, engine_selfcheck

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| Q1 표시 컬럼 | 1 | mapping_trace.py 조건 줄이기 ('asisVisible', 4) 가 숨김 정보 앞 4컬럼만 남김. TO_SITE, TRANS_MODE_CODE 메타 VISIBLE_FLAG N(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv) | mapping_trace.py 줄이기 전 압축·asisVisCut, _trace.spec.ts visOf·A5 2곳 (T520) | 원장 사본 to_ledger: T-fc9d26c9 asisVisible 18/18, condition 854자. 실제 원장 md5 그대로 |
| Q2 To Site | 1 | condColForOpts 가 FROM_SITE 를 고름(증거 'FROM_SITE 값 조건 밖 HQ07-A') | condcol.ts, smoke-extra.ts, _trace.spec.ts (T521) | popk3.selftest 43/43 |
| Q3 팝업 정렬 | 1 | orderCheck 기호 제거 비교. 'Renault AS HQ_FR_RHE' → 'Renault AS_FR_FNS' 위반 판정 | popupprobe.ts (T522) | popk3.selftest 48/48(종전 코드면 첫 사례 violAt 1) |
| Q4 단추 순서 증거 | 1 | 판정은 OK·Close 위치만 씀. 증거에 Open, Search 같이 적음. CR-005·CR-100 대로 FAIL 맞음 | eg_popup.spec.ts (T523) | tsc 0 |
| Q5 일괄 입력 팝업 | 1 | 필수 칸 첫 후보 AU000062_81-P 만 넣고 0행이면 멈춤. HQ05-W 966행(diff #24) | _trace.spec.ts drivePopupPath·pickComboNth (T525) | tsc 0 |
| Q6 수정 행 배경색 | 1 | 편집기·키보드 지움 뒤 '1' 유지(21:51 증거). numberInputRule.ts:34~36 빈 값 허용이라 원인 미확인 | _trace.spec.ts h2RuntimeEdit 경로 2개 추가·입력 불가 표시, unverified_classes.csv 16행 (T526) | tsc 0, unverified_resolve selftest OK |
| Q7 AS-IS 시간 초과 | 4 | #47 'I' From Site 30개 AS-IS 300초 초과. 21:59 실측 HQ07-A 1개 150초 초과, MI00-P 14.6초 2145행. HQ07-A 품목 1175 × To Site 129, 스칼라 함수 3개 | diff_verify.py 시간 초과 표시 (T524), unverified_classes.csv 15행 | unverified_resolve selftest OK, py_compile 0 |
| Q8 Model 팝업 교체 | 3 | 라운드 4 와 같음 | 없음 | 결정 R4-D1 |

### 다음 CheckList 에서 바뀔 판정(미측정)

- T-fc9d26c9: AI 검토 PASS → 검사기 PASS(AS-IS 표시 15 ⊆ TO-BE 15)
- V-8e065123: AI 검토 PASS → 검사기 실측(TO_SITE 로 대조, 통과 또는 오류)
- EG-017a5164: 판정필요 → PASS(다른 위반 행이 있으면 판정필요 유지)
- EG-2644dff3: FAIL 유지(증거 문구만 바뀜)
- T-6b9a8ce8: 미검증 → 실측(INPUT SP 호출 통과 또는 오류)
- V-a99ddb18: 미검증 → 실측, 또는 '[전제 상태 TO-BE 입력 불가]' 미검증(담당 사람 · 결정 R5-D3)
- AD 4행: 미검증 유지, 담당 자동 → 사람(결정 R5-D2)
- 집계 22행: 하위 행을 따라감
- 다른 화면: ENTRY 행 숨김 정보가 잘렸던 화면의 A5(종전 PASS·FAIL 이 바뀔 수 있음), 같은 코드 집합 칸이 둘인 다중 선택 조건(From/To), 기호가 섞인 팝업 정렬 키, AS-IS 시간 초과 차등 행 분류

### 점검

- engine_selfcheck PASS(22:12:53 · TSC 0 · SELFTEST_JS 34 · PY 65 · RULE_REGISTRY 0)
- 새 도구 파일 없음(inventory_check 실행 안 함)
- 줄바꿈: mapping_trace.py, _trace.spec.ts, condcol.ts, smoke-extra.ts, popupprobe.ts, eg_popup.spec.ts, popk3.selftest.js CRLF 유지. diff_verify.py LF 유지
- 백업 `*.bak_20261120_scp28u5`(mapping_trace, _trace.spec, condcol, smoke-extra, popupprobe, eg_popup.spec, diff_verify, unverified_classes.csv, unverified_resolve, popk3run, popk3.selftest)
- 시험 데이터: TO-BE 저장·삭제 없음. AS-IS DEV MSSQL 읽기만(팝업 SP 2회 실행 21:57~21:59, sys.indexes·건수 조회). mapping_trace SCP0028 재실행으로 mapping_trace*.csv·md 다시 만듦
- FE 가이드: 없음(이번 라운드 화면 결함 확정 0건)

## 2026-11-20 라운드 6 (23:38 ~ 23:47 · CheckList 23:38 원장 · 일괄 보완)

- 입력: 원장 `verify_ledger.csv`(23:38:10), 분류 `unverified_triage.*`(23:38:21). 원장 미검증 12 = 엔진 2, 사람 4, 집계 6. AI 검토 행 2 포함 표 8행
- 라운드 5 결과(23:38 원장, 실행 20261120221708): T-6b9a8ce8 PASS(main/INSERT 200 · 6행), T-fc9d26c9 PASS(표시 15 ⊆ 15), EG-017a5164 PASS(위반 없음 966행), V-a99ddb18 FAIL(빈 값 입력됨 · Save 뒤 'M' 유지), AD 4행 담당 사람(T524 표시 적용)
- 하위 에이전트 안 씀(고칠 묶음 1개)
- 재측정: run_verify, Playwright 실행 안 함. 확인은 popk3.selftest, engine_selfcheck

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| S1 To Site | 1 | T521 뒤 22:17 실행에서도 FROM_SITE 대조. 라벨 칸 TO_SITE_DESCRIPTION(sheet_columns.csv 'To Site')과 라벨 갈래 칸 TO_SITE 모두 읽은 후보와 겹침 0 이라 pickCondCol 이 전 칸 최다 겹침 FROM_SITE 를 고름. 겹침 0 이유는 칸별 값 기록이 없어 미확인 | condcol.ts chooseCondCol, smoke-extra.ts condColForOpts, _trace.spec.ts 증거 '대조 칸 근거' (T527) | popk3.selftest 52/52, engine_selfcheck PASS(23:46:26) |
| S2 Model 팝업 | 3 + 집계 6 | 라운드 4 와 같음 | 없음 | 결정 R4-D1 |
| S3 AS-IS 시간 초과 | 4 | 호출 #48 AS-IS 300초 초과 | 없음 | 결정 R5-D2 |

### 다음 CheckList 에서 바뀔 판정(미측정)

- V-8e065123: AI 검토 PASS → 검사기 실측(TO_SITE 로 대조, 통과 또는 오류). 증거에 대조 칸 근거가 남음
- 나머지 7행과 집계 6행: 결정 전까지 미검증 유지
- 다른 화면: 라벨 칸(설명)과 코드 칸이 따로 있고 다른 조건 칸이 같은 코드 집합을 갖는 다중 선택 조건

### 점검

- engine_selfcheck PASS(23:46:26 · TSC 0 · SELFTEST_JS 34 · PY 65)
- 새 도구 파일 없음
- 줄바꿈: condcol.ts, smoke-extra.ts, _trace.spec.ts, popk3.selftest.js CRLF 유지
- 백업 `*.bak_20261120_scp28u6`(_trace.spec, smoke-extra, condcol, popk3.selftest)
- 시험 데이터: TO-BE·AS-IS DB 쓰기·조회 없음
- FE 가이드: 없음. V-a99ddb18 FAIL 은 보완 단계 대상(fixlist.csv 13:10 판에는 없음)

## 2026-11-21 라운드 7 (00:52 ~ 01:00 · CheckList 00:52 원장 · 일괄 보완)

- 입력: 원장 `verify_ledger.csv`(00:52:26), 분류 `unverified_triage.*`(00:52:26). 원장 미검증 0. AI 검토 행 2(V-4633ca25 엔진, EG-ac06e957 결정)
- 라운드 6 결과: V-8e065123 PASS(TO_SITE 대조 5행 일치). 증거 '읽은 후보 14개와 겹침 0' 으로 T527 원인 확인(콤보 후보를 앞 14개만 읽음)
- 직전 결정 12행은 decide_apply 가 권장안 적용(recommended 12)

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| U1 저장 중 로딩 | 1 | AI 검토가 AS-IS cs:661 new FoxAsyncProxy(this) 를 인용하며 'AS-IS 진행 표시 없음' 으로 PASS 반영. powershell.exe 로 TheOne.Windows.Forms.4.5.dll 의 FoxAsyncProxy 를 만들어 ShowProgress 읽음 = True(00:5x). AS-IS 소스 06.UIL 'ShowProgress = false' 765곳, 'true' 1곳 | llm_review.py asis_progress_on·decide H11 막음 (T528) | llm_review selftest OK(2건 추가), 실제 인용으로 막음 확인, engine_selfcheck PASS(00:59:51) |
| U2 Model 팝업 | 1 | R4-D1 권장안 적용(판정필요) | 없음 | 결정 R4-D1 |

### 다음 CheckList 에서 바뀔 판정(미측정)

- V-4633ca25: AI 검토 PASS → 판정필요(시험 검사 CM-003). 결정 R7-D1
- EG-ac06e957: 판정필요 유지
- 다른 화면: H11 저장 중 로딩 행에서 AI 검토가 'AS-IS 진행 표시 없음' 으로 낮춘 행(AS-IS 가 FoxAsyncProxy 기본값·ProgressForm 을 쓰는 화면)

### 점검

- engine_selfcheck PASS(00:59:51)
- 새 도구 파일 없음. 백업 llm_review.py.bak_20261121_scp28u7. 줄바꿈 LF 유지
- 시험 데이터: DB 접근 없음. AS-IS DLL 은 읽기만(리플렉션 객체 생성 1회, 파일 변경 없음)
- FE 가이드: 없음

## 2026-11-25 라운드 1 (02:15 ~ 02:3x · CheckList 02:10:34 원장 · 일괄 보완)

- 입력: unverified_triage.*(02:10:34, 원장과 같은 시각이라 재생성 안 함). 원장 ERROR 71 = 처리 대상 65 + 집계 6. AI 검토 2행 추가해 표 73행(_unverified_plan.md)
- 11-21 라운드 7 뒤 새로 생긴 행 64건(차등 60, E4·I1·K2 검사기공백 3, A6 판단 1)

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일:줄 (결함 유형) | 확인 |
|---|---|---|---|---|
| B1 팝업 조회 SP 짝 | 60 | diff/P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP__3.md 'SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음'. sp_pair.csv SCP0028 3행에 팝업 SP 없음. endpoints.csv SP 4행이 화면 cs 만. 화면 cs:270 new SCM0002_ShipmentLotSizePopup() → 팝업 cs:284 FoxDataRequest("SCM.SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP"). 인자 6개 이름 대응 1:1(db_params.csv ↔ proc_params.csv) | tools/Harness/verify/gen_param_map.py _uil_class_files, popup_class_sps 신설, framework_sps 끝에서 호출, 짝 note '팝업 경유 호출' (T529) | popup_class_sps('SCP0028', TO-BE 호출 이름) → 1건 근거 'SCP0028_Shipment_Lot_Size.cs:270 new SCM0002_ShipmentLotSizePopup() → GSCM\06.UIL\GSCM.SCM.Popup.UIL\SCM0002_ShipmentLotSizePopup.cs:284', 없는 이름 0건 |
| B2 팝업 SP 정렬 | 1(T-c6aefa56) | sort_rules.csv SP 3행(팝업 SP 없음). facts_sortrules.run 이 endpoints.csv·actions.csv 만 읽음. sort_check 는 체인 1단계(run_verify.py:1030)라 diff 단계 gen_param_map(:1364)보다 먼저 돎 | tools/Harness/verify/facts_sortrules.py popup_sps 신설(이 화면 proc_meta PROC 이름의 AS-IS SP 중 팝업 원문 호출 확인분), run 에서 SP 목록에 더함 (T529) | popup_sps → 1건, sp_rules 팝업 SP ORDER BY 2분기(dbo.SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP.sql:61, :97 키 DIVISION_ID, OPERATION_GROUP_ID, FROM_SITE, TO_SITE, ITEM_ID), facts_sortrules --selftest 3/3 |
| B3 계정 지정 시나리오 언어 단계 | 2(V-1f64fec6, V-ca2072cf) | 증거 '다른 화면 E2E 동시 실행(SCP0005,SSP0005,SSP0014) — 계정 언어 전환 생략(T200) · 계정 dana.robot'. _verify.spec.ts 시나리오는 e.user 가 있으면 언어 시험 계정(SLA)을 안 잡고, lang 단계가 acquireLangExclusive(다른 화면 E2E 0개 조건)를 기다리다 실패. 실행별 로그인 계정 기록이 없어 같은 계정 충돌인지 가릴 수 없었음 | tools/E2E/lib/langacct.ts noteLogin, accountBusy, takeLangAccountFor, waitLangHolder 신설. tools/E2E/lib/nscm.ts loginAs 앞 waitLangHolder, 성공 뒤 noteLogin. Doc/e2e/specs/_verify.spec.ts 시나리오 지정 계정 로그인 뒤 takeLangAccountFor 로 SLA 설정(끝의 기존 원복·releaseLangAccount 경로 사용) (T530) | engine_selfcheck TSC 0 |
| B4 K2 무판정 | 1(V-b685dddf) | 원장 applicable=N, applicable_why 'COLUMN_SETTING: actions.csv TitleSet|btnColumn 0건'. judge.py:906~916 무판정 단계가 applicable 을 안 보고 ERROR 로 바꿈. judge.py:3308 적용성 단계는 NOT_RUN 행만 NA 처리 | tools/Harness/verify/judge.py 무판정 단계에 applicable=N 제외 (T531) | py_compile, engine_selfcheck |

### 고치지 않고 결정 목록으로 보낸 행

- T-fad117f6(F4): TO-BE SCP0028 이 PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 부르지 않음(callProc SCM0002, SCP0033, SSP0019). 대상 SP 는 R4-D1 결정에 따름. F4 행 집계 4행은 mapping_trace_instances.csv 의 F4 요소 ERROR 1개(이 행)를 따라감
- V-4633ca25(H11 AI검토:검사기오판): 원문 다시 확인. cs:661 new FoxAsyncProxy(this), ShowProgress=false 없음. 조회 cs:344, 411 은 false 로 끔. AI 검토 근거가 원문과 다르고 T528 막음으로 판정필요 유지. 검사기 수정 없음, R7-D1
- EG-ac06e957(G4 AI검토:룰등록): R4-D1
- T-4cec401b(X-ROW checkValidSize 진입점 6검사 중 ERROR 1): 하위 검사 이름 미확인. 집계 행이라 따로 고치지 않음

### 다음 CheckList 에서 바뀔 판정(미측정)

| 행 | 지금 | 다음 CheckList 예상 경로 |
|---|---|---|
| AD-* 60행(A1, A5, A6, A7) | ERROR(짝 없음 SKIP) | diff_verify 가 AS-IS SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP 을 실행해 KEYSET, COLSET, ORDER, VALUES 판정. AS-IS DEV DB 300초 초과 호출은 R5-D2 |
| T-c6aefa56(A6) | ERROR | sort_check 가 팝업 SP 정렬 2분기를 TO-BE ORDER BY 와 대조 |
| V-1f64fec6(E4), V-ca2072cf(I1) | ERROR | dana.robot 을 다른 실행이 안 쓰면 언어 전환 뒤 측정. 쓰면 종전처럼 다른 화면 대기 |
| V-b685dddf(K2) | ERROR | NA '대상 없음 — COLUMN_SETTING: actions.csv TitleSet|btnColumn 0건' |
| 집계 V-86208af2, T-4cec401b, F4 4행 | ERROR | 하위 행을 따라감 |

### 점검

- python tools/Harness/verify/engine_selfcheck.py: PASS 44.5초(PY_COMPILE 0, TSC 0, SELFTEST_JS 34, SELFTEST_PY 66, DB 필요 2개 미실행)
- 새 도구 파일 없음(기존 파일에 함수 추가)이라 inventory_check --write-registry 실행 안 함
- 줄바꿈: nscm.ts, _verify.spec.ts CRLF 유지. langacct.ts, gen_param_map.py, facts_sortrules.py, judge.py LF 유지
- 백업 `*.bak_20261125_scp28u8`(gen_param_map, facts_sortrules, judge, langacct, nscm, _verify.spec)
- CheckList, 개별 검사기 재실행 안 함(지시 [4]). DB 쓰기 없음
