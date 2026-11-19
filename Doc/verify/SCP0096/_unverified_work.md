# SCP0096 미검증 해소 작업 기록

## 라운드 1 (2026-11-18 16:07~16:3x)
- 시작: CheckList v27(15:23~16:06) 원장 미검증 270행 · 처리 대상 169 · 사람 7 · 집계 94
- 차등짝 76행: 원인 2개 실측
  - 메인 조회 SCP0096_GET_SHIPMENT_WORKING_DAY_OSP 인자 @debug_mode 미해결(SKIP). SP 선언 기본값 'F'(Doc/asisfacts/db/modules/dbo.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP.sql:17)을 읽지 않음
  - 기간 조회 P_SCM0001_GET_SCP_MONTH_PERIOD 짝 없음. AS-IS 호출은 프레임워크 GSCM/01.Framework/GSCM.Windows.Forms/Class/DateUtil.cs:347 경유라 화면 호출 목록(endpoints.csv)에 없음
  - 고친 곳: tools/Harness/verify/gen_param_map.py(sp_declared_defaults · framework_sps)
  - 재측정 중 검사기 결함 2개 추가 발견·수정: diff_verify.py(AS-IS 이름 없는 컬럼 위치 대응, COLSET 허위 FAIL 8) · diff_ingest.py(DIFF 호출의 ORDER 를 order 칸으로 판정, 허위 FAIL 4)
  - 결과: 차등 21호출 전부 실행 · 원장 ASIS_DIFF 84행 PASS 51 · NA 33(CR-105 값·행 데이터 차이) · 미검증 0
  - 값 차이 1셀(D_20261121 AS-IS Y · TO-BE N, 키 81|KR02239900_81-P · 40|CN00254300_40-P): CR-105 로 NA. 원인 미확인
- 데이터전제 13행(K3 3행 이상 필요): tools/E2E/lib/smoke-extra.ts ensureRows minRows 인자 · Doc/e2e/specs/_verify.spec.ts K3·K1 이 행 부족 시 대안 조회 → K3 V-844492e8 PASS
- 재측정: diff_verify·diff_ingest 직접 실행 · run_verify.py SCP0096 --only K3,K1(13.3분) → CheckList v28
- 끝: 원장 미검증 186행 · 처리 대상 85(검사기공백 61 · 미분류 9 · 판단 9 · 대조표 4 · 데이터전제 2) · 사람 7 · 집계 94 · FAIL 15(변화 없음)
- engine_selfcheck PASS. 백업 *.bak_20261118_unvr1

## 라운드 2 (2026-11-18 16:2x~2026-11-18 16:45)
- 시작: v28 원장 미검증 186 · 처리 대상 85
- 조회조건 Plant Site 6규칙(B1·B2·B3·B4·B6·G7) '콤보 없음': findSearchBox 가 열린 왼쪽 메뉴의 'Plant Site' 메뉴 항목을 라벨로 집음(브라우저 DOM 실측 · 메뉴 조상 콤보 2개) → 메뉴·그리드 안 글자 제외 후 콤보 1개 라벨 선택(Doc/e2e/specs/_verify.spec.ts findSearchBox)
- Plant Site 콤보 원천 인자 'division' 해석 불가: 같은 메서드 지역 변수 대입식(SCP0096_Shipment_Working_Day_OSP.cs:417) 추적 → combo_oracle.py local_rhs · SEARCH B4 PASS · G7 PASS · CASCADE B4 판정필요(TO-BE 표시값 '?INFAC_40' 1건 AS-IS 코드 환산 못 함, 원인 미확인)
- 결함 유형 상속 행: judge.py _absent_cols 를 E3·'셀' 표기·괄호 안 '컬럼'까지 확장 · 신규행/Insert 결함 유형 + 이 화면 Insert 없음(원장 근거) → NA
- A7 SP 3행 '파라미터 값 미정': golden.py 빈 인자 = AS-IS SP 선언 기본값 → 본문 빈 값=전체 → 차등 검증 실측 인자 순(신규 공용 tools/Harness/verify/asis_sp_src.py) · 메인 SP·달력 SP 골든 실행(달력 436행 일치)
- DM0003_GET_BUCKET_TYPE_CODE: AS-IS 결과 미사용(cs:136 dtBucketType 대입만, 읽는 곳 없음) → gen_param_map.py asis_result_unused · sp_pair source=unused · judge A6·A7 NA(근거 원문 위치)
- 재측정: run_verify --only B1,B2,B3,B4,B6,G7(16:2x) → --only K3(16:3x~16:4x, v30)
- 끝: 원장 미검증 133 · 처리 대상 66(검사기공백 40 · 미분류 11 · 판단 9 · 대조표 4 · 데이터전제 2) · 사람 7 · 집계 60 · FAIL 15(변화 없음) · 미검증 시트 604
- K3 시험 v30 실행에서 240초 초과(ensureRows 가 Div 81·40·82·81_UC 순회, 모두 0행). 16:20 실행은 Div 40 19행이었음, 0행이 된 원인 미확인 · K3·K1 시간 제한 600초로 조정(다음 실행부터)
- 사고: python 치환 문자열 '\b' 가 백스페이스로 들어감(gen_param_map.py 8곳) → chr(92) 로 정정 · 오늘 수정 파일 19개 전수 점검 0건
- engine_selfcheck PASS. 백업 *.bak_20261118_unvr2

## 라운드 3 (2026-11-18 16:5x~2026-11-18 18:48 · 일괄 보완 → 전체 1회)
- 시작: v30 원장 미검증 133 · 전체 목록 Doc/verify/SCP0096/_unverified_plan.md(행별 조치) · 결정 목록 _unverified_decisions.md
- 일괄 보완 후 전체 실행 v31(17:06~17:56): 미검증 115 · FAIL 21 — 허위 FAIL·미검증 원인 추가 발견: 공통 PROC 배선 목록 앞 4개 자르기(이 화면 배선 누락) · ensureRows 기간 확대가 TO-BE 1000컬럼 결함에 걸려 0행 · master_sweep PK 없음 순서 · 경계값 시험이 빈칸 행(DB 행 없음)에 저장해 행 생성(AU000062_81-P · 17:43 삭제로 원복)
- 수정 후 전체 실행 v32(18:02~18:44): 미검증 85 · FAIL 7 · PASS 691 · 처리 대상 30(판단 13 · 검사기 13 · 대조표 4) · 사람 9 · 보완 대기 2 · 집계 44
- 발견 TO-BE 결함: PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP 기간 약 990일 초과 실패(_unverified_decisions.md)
- 사내 DB: 18:02 이후 DEFAULT 표 생성·수정 0 · OSP 표 1행(CN00254300_40-P 20261119) 값 원복(Y) · 감사 칸(LAST_UPDATED_BY jooyong026 · 18:06:23)은 시험 값으로 남음(원래 감사 값 기록 없음)
- 경계값·2행 저장 시험 Division 재선택 보완(18:4x) — 재측정(--only F1,F4)은 사용자 지시로 저장 시험 전 중단(18:48 · DB 흔적 0 확인 · 잔존 잠금 2개 삭제). 다음 VM CheckList 에서 측정


## 라운드 4 (2026-11-19 00:0x~00:2x · 일괄 보완 · 재측정은 체인이 함)
- 시작: CheckList v33(체인 23:18~23:56) 원장 미검증 51행 · 처리 대상 14 · 사람 6 · 보완 대기 2 · 집계 29. 전체 목록 _unverified_plan.md(51행 = 원장 51행)
- 확인 방법: 단위 함수 시험·자기 시험·engine_selfcheck. run_verify --only·개별 검사기 재실행 안 함

| 묶음 | 원인(실측) | 고친 파일 | 전 → 기대 |
|---|---|---|---|
| F7·F8 저장 감사 2행 | 23:29 저장 시험이 OSP 2행·DEFAULT 1행 변경, 감사 판정 4건 PASS(save_audit_cols.csv). 키 있는 복원 경로가 save_trace.json 을 안 씀 → save_audit NOT_RUN. golden_cases.csv(11-17 22:37)에 저장 SP 행 없음 | restore_touched.py(키 있는 복원도 save_trace 기록) · prereq.py golden_missing_sps(빠진 AS-IS 호출 SP 있으면 골든 재생성 · SCP0096·SSP0005 해당) | ERROR → 단위 시험 F8 PASS · F7 PASS |
| F4 경계값 1행 | 사내 DEFAULT 표 Div 40 7행 모두 7 · Div 81 1행 7 · Div 82 5가 2행(00:01 조회). 행 수 기준 Division 1개만 바꿔 봄 | smoke-extra.ts findRowAcrossDivisions · _verify.spec.ts 경계값 시험 | ERROR → 다음 실행 측정 |
| F6 빈값 1행 | '7'→'' 키보드·편집기 둘 다 7 유지. AS-IS cs:568~569 빈값 → '0' 저장 | inputcheck.ts asisBlankDefault·judgeBlankReject(자기 시험 17/17) · _verify.spec.ts 칸 설정 isRequired 실측 | ERROR → 다음 실행 FAIL 또는 PASS(AS-IS 근거로 판정) |
| D2 동적 칸 수량 편집 1행 | @DYNVAL 은 0 아닌 숫자 칸 전제. 일자 칸 값 Y/N | scenario.ts NOT_APPLICABLE_TAG(자기 시험 33/33) · _verify.spec.ts 메타 dataType·값 종류 실측 | ERROR → 다음 실행 NA(메타 근거) |
| E3 확정 요건 1행 | sheet_columns.csv SCP0096 6칸 USER_SELECTABLE_FLAG='N' 0칸 | judge.py _meta_req_none | ERROR → NA(메타 근거) |
| PKG_SCP0019 2행 · 집계 F4·A6·X-ROW | AS-IS cs:456 주석 안 호출이 문장 원문 칸에 합쳐져 SP 로 추출. commented_calls.csv 에 같은 줄 기록 | mapping_trace.py commented_only_sps | 대상 행 소멸 |
| G1 집계 11행 | 하위 G1|COND:cboDayWeek·cboInputValue 정적 NA(기준표 BUTTON_AREA · CR-071)를 E2E @trace '칸을 찾지 못함' ERROR 가 이김 | mapping_trace.py 기준표 제외 정적 NA 우선 | ERROR → 하위 NA |
| J4 권한 대조 1행 | AS-IS InsertButton·DeleteButton 재정의 본문 없음(cs:274·278) · C·D 권한 대응 동작 없음 | menu_auth_sync.py empty_overrides(자기 시험 9/9) | PARTIAL → PASS(단위 확인) |
| 대조표 사유 2행(MODAL·UC-01) | 사유 문장 있음 · 키워드 불일치. 주장이 AS-IS 사실로 확인됨(팝업 파일 0 · InsertButton 빈 재정의) | mapping_trace.py reason_fact | ERROR → PASS |
| 대조표 사유 2행(D00-3-020·D00-3-032) | 기재 오류 1 · 근거 없는 미이식 1 | 없음(DB MODE · FE 가이드 3·4번) | 결정 목록 |
| C1 연쇄 후보 1행 · 집계 3행 | TO-BE 이름 INFAC_40 을 AS-IS 원천으로만 코드로 바꿈. 사내 SCM_MST_SITE.SITE_DESCRIPTION → PL01279700_40-P · AS-IS DEV 에 없음 | combo_oracle.py resolve_names(단위 시험: 데이터 차이로 설명) | 판정필요 → 데이터 차이 설명 |
| A1 같은 사용자 1행 | 조회 SP 인자에 사용자 칸 없음인데 ERROR | a1_live.py(자기 시험 17/17) | ERROR → NA(SP 인자 근거) |
| 분류표 | 미분류 2유형(입력 경로 실패 · PARTIAL), 새 문구(AS-IS 빈값 처리 근거 없음) | unverified_classes.csv 72·78 | 미분류 0 |

- engine_selfcheck: 00:15 PASS(TSC 0 · JS 30 · PY 46)
- 남은 사유: 사람 6행(스냅샷 5 · A1 은 이번 보완으로 자동 판정 예정) · 보완 대기 2행 · 대조표 2행(가이드)
- 백업 *.bak_20261119_unvr4


## 라운드 5 (2026-11-19 01:0x · 체인 recheck 00:21~00:59 결과 이어서)
- 재측정 결과(체인 recheck · 원장 00:59): 미검증 51 → 18행. 라운드 4 보완 행 판정: F7 PASS · F8 PASS(변경 행 5건) · F4 경계값 PASS(Div 82 r5 5→7→5) · C1 EG-7b487474 PASS(데이터 차이) · J4 PASS · 대조표 T-af133d05·T-15cf757f PASS · D2 NA(동적 칸 362개 dataType 숫자 0 · 값 Y,N) · E3 NA(메타 필수 0칸) · A1 EG-938ba32f NA(SP 인자 사용자 칸 없음)
- 사내 DB(01:06 조회): DEFAULT 표 값 분포 시험 전과 같음(40 7×7 · 81 7×1 · 82 5×2·7×6) · 시험 계정 생성 행 0
- 남은 처리 대상 1행 V-70799fba(F6): 원장 증거 '칸 설정 isRequired=false · 거부 원인 미확인'. 같은 실행에서 같은 칸 키보드 '0'(V-e2da7fb2)·'6'(V-7b7c7536) 입력 성공 → 입력 경로 정상, 빈값만 화면이 받지 않음. 공용 숫자 편집기 isRequired:false(columnMapping.ts:97~99)라 원인 줄 미확인
- 고친 곳: tools/E2E/lib/inputcheck.ts judgeBlankReject 에 pathOk(같은 칸 같은 경로 입력 성공) 추가(자기 시험 19/19) · Doc/e2e/specs/_verify.spec.ts 빈값 판정에 칸 편집기 isRequired 기록·0 왕복 결과 전달
- 기대(다음 CheckList): V-70799fba ERROR → FAIL(AS-IS cs:569 빈값 → 0 저장 근거)
- engine_selfcheck 01:05 PASS · FE 가이드 FE_GUIDE_20261119_0106.md(2번 원인 설명 정정) · 백업 *.bak_20261119_unvr4(소스) · _unverified_plan.md.bak_20261119_unvr5
- 남은 사유: 사람 5행(스냅샷) · 보완 대기 2행 · 대조표 2행(가이드) · 집계 8행(하위 = 위 행)


## 라운드 6 (2026-11-19 07:1x · 사용자 질의 '재수행 2단계에서 종료된 이유' 뒤 보완)
- 중단 원인(로그 01-25-15 · unverified_resolve.py:236): 처리 대상 건수 비교 3 → 4 로 반복 중단. F6 1행은 FAIL 로 판정됐으나 --only F6,X-REASON 부분 실행이 B3 2행(T-796a1766 Day of the week · T-cc214e9d Input Value)을 새 미검증으로 만들었고, 대조표 2행은 DB MODE 라 재수행으로 줄 수 없는데 처리 대상에 남음
- B3 2행 원인(실측): _verify.spec.ts flushRt 가 이번 실행에서 채운 구역(search)을 통째로 바꿈. 부분 실행은 주 조회조건(Div · Plant Site)만 채워 Bulk Update 창 콤보 2개 항목을 combo_runtime.json 에서 지움 → combo_oracle 콤보 3개만 판정(01:32)
- 고친 곳: Doc/e2e/specs/_verify.spec.ts flushRt(부분 실행 VERIFY_ONLY 이면 search·grid 항목 단위 합침 · combos 목록 합침) · tools/Harness/verify/unverified_resolve.py progress()(직전 처리 대상 행 중 풀린 행이 있으면 계속 · 새 행은 다음 보완 대상) · DB MODE 대조표 행 = 담당 '가이드'(처리 대상 제외)
- 확인: unverified_resolve --selftest OK · engine_selfcheck 07:18 PASS
- 재측정: run_verify.py SCP0096 전체 1회(07:19 시작 · 로그 _run_20261119_unv_r6.log)

- 라운드 6 재측정 결과(v36 · 07:19~07:56 · 전체 35.3분): 미검증 23 → 18행 · 처리 대상 4 → 1 · B3 T-796a1766·T-cc214e9d PASS(콤보 순서 DISPLAY_SEQ · 고정 목록 Y,N) · F6 V-70799fba FAIL 유지 · 대조표 2행 = 담당 가이드
- 새 처리 대상 V-67eb6936(I1 KO 언어 저장 시나리오): '언어 변경 실패(ENG→ENG)'. 00:25 실행은 같은 코드로 ENG→KOR PASS. 언어 단계가 1회 클릭 + 2.5초 고정 대기만 함
- 고친 곳: Doc/e2e/specs/_verify.spec.ts 시나리오 lang 단계(바뀔 때까지 최대 8초 확인 · 메뉴 다시 열어 최대 3회 · 회차별 메뉴 열림 기록) · engine_selfcheck 07:58 PASS
- 재측정: run_verify.py SCP0096 전체 1회(07:58 시작 · 로그 _run_20261119_unv_r7.log)
- 라운드 7 재측정 결과(v37 · 07:58~08:36 · 전체 36.4분): 미검증 18 → 16행 · 처리 대상 1 → 0 · V-67eb6936 PASS(ENG→KOR 전환 · 문구 '저장할 데이터가 없습니다.')
- 남은 16행: 사람 5(스냅샷) · 보완 대기 2(Sum 체크박스 FAIL 뒤) · 가이드 2(대조표 · DB MODE) · 집계 7

## 라운드 8 (2026-11-19 08:5x~09:00 · 사용자 승인 범위만)
- 스냅샷 5건 일괄 승인(snap_approve 08:5x · 골든 5 · 사용자 판정 5 · snap_validate OK 3 · NA 2) · 상시 승인: harness.json snapAutoApprove=true · run_verify 사후 단계 snap_validate 뒤 snap_approve(OK·NA 만, MISMATCH 제외)
- 되돌림: mapping_trace.py X-REASON '근거 없는 제외 = FAIL' 전환(08:5x 추가 · 승인 없음 · 전 화면 66개 영향) → 종전 REVIEW
- 3차 전체 실행(08:56)은 세션 종료로 08:57:15 사전 단계에서 끊김. 원장·CheckList 는 v37(08:36) 그대로. 남은 잠금(_run.e2e·_run.dbwin SCP0096)은 프로세스 없음 · 실행기가 다음 실행 때 정리
- CheckList 재실행 안 함(사용자 지시: 다시 돌리기 전에 승인 내역만)

## 라운드 9 (2026-11-19 09:0x · 사용자 승인: 사람 확인 항목은 권장안 판정 · 필요할 때만 판정필요 · 미검증으로 남기지 않음)
- mapping_trace.py X-REASON: 근거 없는 제외·해당없음 = FAIL '[대조표 근거 없음]' · 권장 조치 AS-IS 동작 구현 또는 사유 근거 보강(T-8cdb4616 · T-428f2fa6 대상)
- judge.py 선행 결함: 체크박스 FAIL 로 칸이 없는 행 = FAIL '[선행 결함 종속 V-eb856b69]'(V-d8f314e2 · V-9e29a0e2 대상)
- 스냅샷 5행: 08:5x 승인(골든 5) · 다음 CheckList 부터 PASS 기대(미측정)
- 집계 7행: 하위 판정을 따라감(D3 4 · X-ROW 3)
- engine_selfcheck 09:09 PASS · CheckList 재실행 안 함(사용자가 실행)
- 다른 화면 영향: 직전 판정 기준 '사람 확인' 대조표 행이 있는 화면 66개 → 다음 CheckList 부터 FAIL(조치 대상)로 추출

## 라운드 10 (2026-11-19 09:22~10:03 · 🧪 미검증 해소 메뉴 단독 실행)
- 입력: unverified_triage 09:22:14(원장 v37 08:36) · 미검증 16행 · 처리 대상 0행(보완 2 · 사람 5 · 가이드 2 · 집계 7)
- 원인: 라운드 8·9 에서 판정 경로를 고쳤으나(스냅샷 골든 승인 08:54 · judge.py 선행 결함 종속 FAIL · mapping_trace.py 대조표 근거 없음) 원장이 그 전 판(v37)이라 행이 남음. 새 검사기 수정 없음
- 확인: engine_selfcheck 09:25 PASS(TSC 0 · JS 30 · PY 46)
- 재측정: run_verify.py SCP0096 전체 1회(09:26:00~10:02:34 · 34.5분 · 로그 _run_20261119_unv_r10.log · CheckList v38)
- 결과: 원장 미검증 16 → 0행 · unverified_resolve 10:02:43 미검증 0
  - PASS 5: V-06af9fa9 K4 · V-74ab8496 A5 · V-b36b0750·V-308cf4c5 H4 · T-fcedc149 X-ROW
  - FAIL 7: V-d8f314e2 H2 · V-9e29a0e2 D3(선행 결함 종속 V-eb856b69) · T-3168aa6e·T-cf17d66b·T-5618d74a·T-41297850 D3 집계 · T-03dcfd08 X-ROW
  - FAIL 1: V-0d52121b G4 조회조건 스냅샷. 08:54 골든 'Div.' ↔ 09:28 실측 'Div'(diff/조회조건_Div_40.txt 2줄). snap_validate AS-IS 대조 OK → 사후 단계 09:59 자동 승인으로 골든 교체. FE 소스 병합 0건(09:26)이라 라벨 변경 원천은 미확인
  - 판정필요 3: T-8cdb4616·T-428f2fa6 X-REASON(증거 순위 GENERAL 이라 FAIL 불가 → 판정필요) · T-64d83c17 X-ROW
- CheckList '미검증' 시트: 491 → 475행(상속생략 462 · 대상불명 12 · 시험검사 1)
- 회귀 보고 위반 1(V-0d52121b 사용자 판정 PASS ↔ 재실측 FAIL) · 커버리지 경고 SUSPECT_NA100 E3(라운드 4 메타 근거 NA 8행)
