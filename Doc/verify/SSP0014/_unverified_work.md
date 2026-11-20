# SSP0014 미검증 해소 작업 기록

## 라운드 1 (2026-11-19 16:18~16:5x · 일괄 보완)

- 입력: CheckList 13:49~16:17 결과 원장 미검증 293행. 분류 16:17:57 라운드 1 = 처리 대상 143(엔진 115, 판단 28), 가이드 4, 사람 1, 집계 145. 이전 라운드 기록 없음
- 행별 조치 `_unverified_plan.md`(148행 + 집계 145행 = 293행). 결정 `_unverified_decisions.md`(D1~D8). FE 가이드 `FE_GUIDE_20261119_1647.md`(4건, doc_style 위반 0)
- 재측정: 이번 라운드에서 run_verify, 개별 검사기 재실행 안 함. 다음 CheckList 재수행에서 측정

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 재측정 |
|---|---|---|---|---|
| R1 BE 중단 | 36 | nscm-be/logs/nscm.log 14:33 뒤 15:07 까지 0줄. Doc/verify/SSP0014/e2e/results.json: K3(14:33:21) ensureRows 사업부 8개 0행, E6(14:38)·B7(14:43)·B1·B2(14:49)·G8·G9(14:55) `ERR_CONNECTION_REFUSED`, K1(15:01) 로그인 시간 초과 | 없음. 15:1x server_guard.py · nscm.ts waitBeUp 반영분이 다음 실행에서 BE 재기동 | CheckList 재수행 |
| P1 저장 경로 | 28 | ShipmentModelPicGrid.tsx handleDblClick: 사용자 칸 8개 더블클릭 = SsoUserModal. crud.ts setCell 더블클릭 → 입력이 팝업으로(13:51 crud spec · 14:06 @verify '편집 가능 셀 7개 시도 — 값이 바뀌는 셀 없음'). 14:07 저장 세부·14:08 저장 경로 시험 `[측정 경로 없음] Save 를 누를 수 없음 — 팝업 'User Popup'`. r0 USER_ID 빈 값(E7 증거 '[User ID] 값은 필수'). 사용자 칸 저장은 USER_CHECK 등록 사용자만 통과 | T350 tools/E2E/lib/nscm.ts dismissDblPopup(더블클릭 전 대화상자 수 비교) · setCell · 편집기 확인 경로, saveprobe.ts typeRaw. T349 probe.ts findRow · firstEditableRow · requiredColumns · popupColumn · otherColumnValue · requiredFilled, crud.ts 후보 행 순서 · 팝업 칸 값, saveprobe.ts nextOf | CheckList 재수행 |
| P4 팝업 인자 G5 | 16 | AS-IS SpdMain_CellDoubleClick(cs:626~831) 팝업에 셀 값 인자 0개(actions.csv) | T352 Doc/e2e/specs/_verify.spec.ts G5 | CheckList 재수행 |
| P2 E7 첫 행 | 15 | r0 USER_ID 빈 값 → Save 가 필수 안내(COLUMN 7행) · 메시지 0(EG 8행) | T349 probe.ts findRow · firstEditableRow | CheckList 재수행 |
| P5 D4 | 9 | AS-IS InsertButton 본문 주석뿐(cs:254~257) · TO-BE Insert 없음 | T354 Doc/e2e/specs/_trace.spec.ts | CheckList 재수행 |
| P6 C3 | 9 | 자기 칸 팝업 선택값 대입(cs:649 등 8칸) · 조회 후 표시 변환(cs:358) | T356 tools/Harness/verify/mapping_trace.py selfAssign · _trace.spec.ts | CheckList 재수행 |
| P3 D5 아이콘 | 8 | 팝업 아이콘 = CSS ::after(_grid.scss:710~730) · 검사기는 자식 요소만 봄 | T351 Doc/e2e/specs/eg_popup.spec.ts | CheckList 재수행 |
| R2 언어 | 4 | lang_texts.json KO·EN·CN '다른 화면 E2E 동시 실행 — 전환 생략(T200)' | 없음. 15:4x langacct.ts 반영분 | CheckList 재수행 |
| P7 SP 짝 | 2 | golden_cases.csv 128행 '미매칭' · sort_check.csv 'PROC_M 배선 없음' · sp_pair.csv 231~233행에는 짝 있음 | T358 tools/DbConn/gen_golden_cases.py · tools/Harness/verify/sort_check.py · golden_cases.csv SSP0014 재생성(짝 3/3, 다른 화면 273건 같음) | CheckList 재수행 |
| P8 G1·G2 멀티선택 | 2 | 검색어 CN003256_40-A 가 후보에 없음(SCM_MST_SITE 0행, 16:46 조회) | T355 _trace.spec.ts | CheckList 재수행 |
| P9 F6 숫자 칸 | 1 | cell_rules.csv 21칸 중 숫자 0 | T353 _verify.spec.ts | CheckList 재수행 |
| P10 G03-WIRE | 1 | Doc/gen/SSP0014/CHECK.md 없음 | T357 mapping_trace.py ev_gates | CheckList 재수행 |
| X1 · X2 | 5 | 대조표 팝업 행 ↔ 트리거 칸, 범위 표기 칸 | 미보완(D7, D8) | 미검증 유지 가능 |
| J · H | 8 | 판단 7 · 스냅샷 1 | 결정 목록 D1~D6 | 결정 대기 |
| G 가이드 | 4 | 대조표 구현 위치 칸 없음 | FE_GUIDE_20261119_1647.md G1~G4 | 가이드 반영 뒤 |

### 분류표

- tools/Harness/verify/unverified_classes.csv order 55 추가: '원인은 F\d+ 행|후보가 1개 이하라' = 데이터전제(엔진). 이번 미분류 8행(E4 6, G1·G2 2)

### 확인

- tsc(tools/E2E tsconfig · lib·specs 전체) 오류 0
- mapping_trace.py --selftest 81/81 · sort_check.py --selftest 5/5
- 단위 함수 시험: probe.ts 필수 칸·팝업 칸 판정 8/8(필수 빈 r0 건너뜀, 채워진 행 없으면 첫 기존행, 필수 설정 없으면 종전, 신규행 제외, 2단 묶음 칸, FPTextModal·일반·설정 없음) · C3 selfAssign 분류 5/5(팝업 · 표시 변환 · 다른 칸 원천 2 · ShowDialog 없음)
- engine_selfcheck PASS(16:44)
- 실제 E2E 동작(팝업 닫기 뒤 F2 입력, 필수 칸 채워진 행 저장)은 미측정. 다음 CheckList 에서 확인

### 다른 화면 영향(원장 ERROR·판정필요 증거 문구 기준 같은 증상 행 · 16:4x 집계)

- C3 '연쇄 원천 컬럼 해석 불가' 119행 15화면 · D5 팝업 아이콘 false 27행 11화면 · 멀티선택 후보 1 67행 10화면 · A6 PROC_M 배선 없음 97행 13화면 · G5 원천 셀() 비어 22행 2화면 · F6 숫자 칸 없음 12행 12화면 · D4 Insert 비노출 14행 3화면. 자기 칸 대입·AS-IS 근거 조건에 맞는 행만 바뀌므로 바뀌는 행 수는 미측정
- 골든 kind: 276건 중 13건(9화면)이 sp_pair.csv kind 로 바뀜(DMF0005 2, SSP0015 3, SSP0003 3, SSP0014 1, SSP0020 1, SSP0021 1, SSP0200 1, SCP0104 1). 파일 재생성은 SSP0014 만 함
- 더블클릭 팝업 닫기(T350)·필수 칸 채워진 행 우선(T349)은 E2E 를 쓰는 전 화면에 다음 실행부터 적용
- 백업 *.bak_20261119_ssp14u

## 라운드 2 (2026-11-19 16:57~17:1x · 남은 미보완 묶음)

- 입력: 원장 16:17:30 그대로(CheckList 재수행 없음). 분류 라운드 3(16:54:48) 행 목록이 라운드 1 과 같아 라운드 1 보완은 되풀이하지 않음. 라운드 1 에서 미보완으로 남긴 X1·X2 만 처리

| 묶음 | 행 | 원인(실측 근거) | 고친 곳 | 재측정 |
|---|---|---|---|---|
| X2 칸 상수 이름 | 2(T-0bba9c32 A5, T-86e85805 H5) | AS-IS `public const string DIVISION = "DIVISION_ID";`(SSP0014_ShipmentModelPIC.cs:77). facts_cellclear.const_map 결과 {DIVISION: DIVISION_ID}. 검사기가 상수 이름을 칸 이름으로 씀 | T359 tools/Harness/verify/mapping_trace.py Elements(상수 이름 → 원문 값 칸, 원장 COLUMN 칸으로 가는 것만) · of()(대조표 글의 상수 이름 → 실제 칸) | CheckList 재수행 |
| X1 팝업 대조표 오기 | 4 | 화면 팝업 = MaterialByDivisionModal(COM0013, ShipmentModelPic.tsx:545~558, 2026-10-12 사용자 지시 교체). 대조표 28·36·72·98·131·154줄은 SCM0002(PKG_SCM0002) 그대로. sqllog_calls.json PKG_SCM0002 0건 | 검사기 수정 없음. FE_GUIDE_20261119_1647.md G5(doc_style 위반 0). 출발 사이트 인자 차이 = D7 | 가이드 반영 뒤 |

- 결정 목록: D8 처리(검사기 결함), D7 근거 갱신. 결정 7건(D1~D7)
- 확인: mapping_trace.py --selftest 81/81 · py_compile 통과 · engine_selfcheck PASS(17:07:12 · TSC 0)
- 다른 화면 영향(원장 COLUMN 칸 기준 대응 생기는 화면 6): DMF0005·DMF0006 TEAM_ID → DEPT_ID, DMF0021 CELL_PACK_COUNT → FORECAST_INFO_CELL_PACK_COUNT, SSP0005 COMPANY → COMPANY_ID·DIVISION → DIVISION_ID, SSP0014 DIVISION → DIVISION_ID, SSP0020 LAST_UPDATE_BY → LAST_UPDATED_BY. 다음 CheckList 부터
- 백업: 라운드 1 백업 mapping_trace.py.bak_20261119_ssp14u(라운드 1·2 변경 전 원본)

## 라운드 3 (2026-11-20 07:43~08:3x · 일괄 보완)

- 입력: CheckList 2026-11-20 06:08~07:43 결과. 원장 07:33:06 ERROR 127행(집계 77) + AI 판정 검토 24행. 분류 07:43:36 라운드 1 = 처리 대상 68(AI 검토 24 포함), 가이드 4, 사람 2, 집계 77
- 행별 조치 `_unverified_plan.md`(집계 아닌 74행 + 집계 77행 = 151행). 결정 `_unverified_decisions.md`(8건 9행). FE 가이드 `FE_GUIDE_20261120_0800.md`(G6 1건, doc_style 위반 0)
- 라운드 1 의 저장 경로 보완(T349·T350)은 반영됐으나 시험 값 'njlilian' 이 USER_CHECK 에 막혀 저장 묶음이 다시 미검증이 됨. 같은 시도를 되풀이하지 않고 검증 차단을 알아보고 통과 값으로 다시 고르게 바꿈
- 재측정: run_verify, 개별 검사기 재실행 안 함. 다음 CheckList 재수행에서 측정

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 재측정 |
|---|---|---|---|---|
| S 저장 경로 | 27 | e2e_results.json V-9526999b·ES-de56f621: 'USER_ID → njlilian · [60s] 저장 응답 USER_CHECK:200 · SAVE call-proc 없음'. probe.otherColumnValue 가 다른 행 최빈값 'njlilian' 을 고름. useShipmentModelPicValidation.ts:47~58 = USER_CHECK 통과 목록에 없으면 MSG01261 알림 후 저장 중단. nscm.alertText 가 숨은 대화상자 포함 마지막 요소를 읽어 알림 '' · closeAlert 는 :visible 로 그 알림을 닫음. saveprobe.saveReload 가 USER_CHECK 호출을 저장 요청으로 세어 'r20 재조회 NG'(V-9bcbf1f5)·DB 무변화(V-6ea977f3) 기록. 저장 경로 시험은 USER_CHECK 에 가짜 실패를 넣음(V-5473aa5a). eg_popup CELL_BADKEY 는 확인 버튼을 먼저 눌러 알림을 닫음(8행). E3 는 숨은 요소 .first() 를 읽고 blockWrites 가 USER_CHECK 를 막음. save_audit.json 07:09 F7·F8 'NOT_RUN 저장 미실행' | T370 nscm.ts alertText · T371 nscm.ts save(검증 알림 선읽기, 검증 호출 뒤 알림이면 대기 끝, preCheckOnly) · T372 nscm.ts pre 기록, saveprobe.ts precheckValues·notePrecheck·saveReload·cellRoundTrip 재시도, probe.ts otherColumnValue exclude·prefer, crud.ts 재시도·'[업무 검증 차단]', _verify.spec.ts F 판정 · T373 _verify.spec.ts 저장 경로 검증 호출 통과·재시도 · T374 _verify.spec.ts E3, probe.ts blockWrites, rowstate.ts · T375 eg_popup.spec.ts CELL_BADKEY | 미측정 |
| C AS-IS 사실 추출 | 17 | cs:77 `const string DIVISION = "DIVISION_ID"` 를 안 풀어 cs:274 LockColumn 범위가 양 끝만 적힘(SpreadInfo.cs:6921 범위 전체 잠금). cs:183~187 NewRow 'W/Warrnaty' 누락. cs:355~360 조건부 셀 형식 누락. dbo.SSP0014_GET_SHIPMENT_MODEL_PIC.sql:89~93 ORDER BY 5키 중 1키만 | T390 facts_lockrules.py · T391 facts_combosrc.py, combo_oracle.py, facts_combovalues.py · T392 facts_cellrules.py · T393 facts_sortrules.py. SSP0014 사실 5종 재생성(lock_rules, edit_expect, combo_src, cell_rules, sort_rules) | 미측정 |
| D 대조표 추적 | 13 | 대조표 부록 표 번호 겹침(97·106·117·118줄), 서술본·이력 표(91·170줄), 구현 위치 칸 미독(ShipmentModelPicGrid.tsx:228), 미배치 usrButton1(Designer.cs:33), 팝업 인자 전용 clbFromSite(actions.csv 841줄), calls/*.json USER_CHECK 15건 미합침, CR-096(confirmed_requirements.csv:97) 미적용 | T400~T404 mapping_trace.py · T405 judge.py f4_calllog · T406 popup_args_check.py, mapping_trace.py. T-d1bd8978·T-bab6f023 은 결정 D7 | 미측정 |
| B 콤보 원천·조회 | 11 | b7_check.json 06:14 '원천 미확인 cboDivision, cboOperationGroup'(SSP_BIGFILTER 미해석). G9 plan key 'user' ↔ @p_user_id 미대응(AS-IS sql:86~88 LIKE). K3 팝업 그리드 행 혼입. sort_check.csv 300자 잘림. G1 결과 코드 ↔ 후보 이름 미환산 | T380 b7_check.py · T381~T383 judge.py · T384 sort_check.py, sort_ci_check.py · T385 _trace.spec.ts | 미측정 |
| J 결정 | 6(+D 2, B 1) | 행별 근거는 결정 목록 | T376 eg_auth.spec.ts + 신규 combo_branch_filter.py(EG-a6f6bebc, 종전 D5) | 미측정 |

### 확인

- tsc(tools/E2E · lib·specs) 오류 0(07:5x 두 번, 다른 세션 T430~T432 변경 포함)
- 단위 시험: 저장 묶음 10/10(통과 목록 추출, 막힌 값 기록, MSG01261 업무 검증 분류, E3 필수 안내·실패 알림·저장 요청, 실패 주입 차단·실패 문구) · combo_branch_filter --selftest 4/4 · b7_check 4/4 · sort_ci_check 14/14 · mapping_trace 84/84 · popup_args_check 6/6 · combo_oracle 8/8
- engine_selfcheck PASS(08:32:54 · TSC 0 · selftest JS 32·PY 59)
- inventory_check --write-registry: tools/Harness/README.md 에 combo_branch_filter.py 등록
- 실제 E2E 동작(검증 차단 뒤 통과 값 재시도, 알림 읽기)은 미측정

### 다른 화면 영향과 정리

- 공용 저장 시험 변경(T370~T375)은 E2E 를 쓰는 전 화면에 다음 실행부터 적용. 검증 호출 통과 규칙은 이름에 CHECK·VALID·VERIFY·CHK 가 있고 쓰기 이름이 없는 call-proc 만
- B 묶음: B7 '원천 미확인' 123행 15화면(SSP_BIGFILTER 46건 7화면만 풀림), A6 정렬 130행 24화면, K3 35행 19화면. 바뀌는 행 수 미측정
- D 묶음: 행 ID 겹치는 대조표 47화면은 대조표 추적 행 ID 가 새로 생기고 옛 행 ID 사용자판정은 이어지지 않음. F4 진입·조회 밖 SP 19화면 103행
- C 묶음 정리: 영향 측정 때 다른 화면 157개 sort_rules.csv 가 새 추출기 결과로 바뀐 채 남음(08:01:09~08:08:01). 08:3x 실행 전 원본으로 되돌림(156개, 불일치 0). 바뀐 내용은 Doc/verify/SSP0014/_dedup/sort_rules_new_20261120 에 보관. lock_rules·edit_expect·cell_rules 33화면은 git 기준과 같음. SCP0028 combo_src.csv(08:08:41)에 added_rows 열이 붙어 있음(다른 세션 실행분인지 미확인, 그대로 둠)
- popup_args_check.py SSP0014 실행으로 Doc/verify/SSP0014/popup_args.csv 가 새 내용으로 바뀜(원본 백업 없음, 다음 CheckList 재생성)

### 남은 사유

- M4|BTN:btnItemId PASS 근거가 Model 팝업이 아닌 UserInfoPopup(TEAM_LEADER 더블클릭) 실측임(D 묶음 확인). 검사기 근거 연결 결함 의심, 이번 라운드 범위 밖이라 고치지 않음
- 백업: 각 파일 옆 *.bak_20261120_ssp14u. eg_auth.spec.ts 백업은 수정 뒤 git HEAD 본으로 만듦(다른 세션 T430 변경 미포함)
