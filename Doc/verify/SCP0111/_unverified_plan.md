# SCP0111 미검증 행별 조치 (2026-11-19 12:4x · 라운드 4)

- 원천: `unverified_triage.csv`(2026-11-19 12:24:00, 분류 라운드 1). 원장 `verify_ledger.csv`(2026-11-19 12:23) 미검증 10행
- 이 표 10행 = 처리 대상 4(엔진 4) + 가이드 1 + 사람 2 + 집계 3. 원장 미검증 10행과 같음
- 라운드 1~3 표는 `_unverified_work.md` 에 남김. 결정 번호는 `_unverified_decisions.md`
- 재측정은 VM 의 CheckList 재수행으로 함. 이번 라운드에서 run_verify, 개별 검사기 재실행 안 함

## 처리 대상 4행 + 가이드 1행

| 행 | 규칙 | 유형(담당) | 원인(실측) | 조치 |
|---|---|---|---|---|
| T-18374ec4 | B4 | 데이터전제(엔진) → 검사기공백 | combo_src 필터식 `"DIVISION_ID = '" + division + "' AND CODE IN (" + sPlanDateFN + ")"` 를 combo_oracle eval_filter 가 이어 붙이기를 풀지 않고 `" + division + "` 글자 그대로 비교함. 두 분기 모두 0행. AS-IS 개발 DB 직접 실행(12:3x): DATE_WEEKLY1 사업부 81 13건, SCP_PLAN_VERSION_V 사업부 81 FN 12건. 지난 라운드 원인(뷰 기준일 경과)은 틀렸음 | 검사기 결함 T343. `tools/Harness/verify/combo_oracle.py` expand_concat, accum_source, eval_filter expand, main raw_rows, concat_expander. 결정 D6 취소 |
| V-530425d0 | B4 | 데이터전제(엔진) → 검사기공백 | 위와 같음 | 위와 같음 |
| T-03071eab | F4 | 검사기공백(엔진) | main/SAVE 는 세션 그룹에 'System Administrator' 가 없을 때만 호출(IntegrationPsi.tsx:207, 342). 시험 계정 minyonglee1 = ADMIN 이라 Save 가 main/SAVEDETAIL 로 나감. 일반 저장 SP P_SCP0111_SAVE_INTEGRATION_PSI 가 쓰는 표 = SCP_ANL_PSI_INTEGRATION(UPDATE 69곳, INSERT 2곳, 전부 LAST_UPDATED_BY = P_USER_ID) 와 임시 표뿐(사내 DB 원문 12:3x 조회) | 검사기 보완 T344. `Doc/e2e/specs/_verify.spec.ts` CRUD 시험 끝에 세션 그룹 재현(같은 계정, 그룹 1개씩 제외, 같은 수정 저장). 저장 계정이 같아 restore_touched 감사 칸 복원 대상에 들어감. 결정 D10 대체 |
| T-ea67ed5b | F4 | 검사기공백(엔진) | 위와 같음 | 위와 같음 |
| T-b8e710df | X-LOC | 대조표사유(가이드) | 대조표 45줄 SCP0111_DERIV_MISMATCH 가 소스에 없음(지금 소스 MSG01502) | DB MODE. `FE_GUIDE_20261118_1816.md` G7 그대로 |

## 사람 2행

| 행 | 규칙 | 내용 | 결정 |
|---|---|---|---|
| ES-9b3831e2 | F1 | editonly 화면 신규 행 저장 시험 보류(saveCalls=0, 그리드 1898 → 1899 행 추가는 확인) | D9 |
| ES-cd72403b | F1 | 위와 같음(authcrud jooyong026) | D9 |

## 집계 3행

| 행 | 규칙 | 따르는 하위 행 |
|---|---|---|
| V-7b04b710 | F1 | ES-9b3831e2, ES-cd72403b |
| T-7f7f309f | X-ROW | J2 화면 단위 검사 ERROR. 원천 `Doc/e2e/results/SCP0111/_summary.csv` authcrud. ES-cd72403b(D9)와 같은 원인 |
| T-81c9a537 | X-ROW | 위와 같음 |
