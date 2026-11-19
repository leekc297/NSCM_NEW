# SCP0111 미검증 행별 조치 (2026-11-19 10:41 · 라운드 3)

- 원천: `unverified_triage.csv`(2026-11-19 10:24:07, 분류 라운드 9). 원장 `verify_ledger.csv`(2026-11-18 19:50) 미검증 32행
- 이 표 32행 = 처리 대상 12(판단 8, 엔진 4) + 가이드 1 + 사람 5 + 집계 14. 원장 미검증 32행과 같음
- 라운드 1·2 표는 `_unverified_work.md` 에 남김. 결정 번호는 `_unverified_decisions.md`
- 재측정은 VM 의 CheckList 재수행으로 함. 이번 라운드에서 run_verify·개별 검사기 재실행 안 함

## 처리 대상 12행 + 가이드 1행

| 행 | 규칙 | 유형(담당) | 원인(실측) | 조치 |
|---|---|---|---|---|
| ES-f6cf77b0 | G4 | 판단 | 화면 체크박스 문구 = LBL01150 'Qty < 0'(반각, DB 조회 10:3x). 시험 기대값 = 조회조건 정리 Excel 'Qty ＜ 0'(전각 U+FF1C)과 계획 파일이 잘못 이은 LBL00689 'Qty ≥ 0'. 글자 비교라 못 찾음 | 검사기 결함 T339. `tools/E2E/lib/nscm.ts` fieldExistsAny 에 전각→반각(NFKC) 후보 추가 |
| V-028e36d9 | A2 | 판단 | INCOTERMS 칸 DataMap 은 값=표시값(IntegrationPsiGrid.tsx:94~97 buildCellCombo). 이름이 없는 코드 표시 칸이라 후보 밖 'FCA' 도 후보 안 코드와 같은 모양. 코드 표 SCM_ADM_LOOKUP_MASTER_DETAIL INCOTERMS 16행 중 FCA VALID_YN=Y | 검사기 결함 T338. `tools/E2E/lib/disp2.ts` judgeCodeShown, `Doc/e2e/specs/_verify.spec.ts` A2 수집에 값=표시값 칸 구분. FCA 가 후보에서 빠진 원인은 결정 목록 D4 |
| EG-c892f15f | I1 | 판단 | 화면 사용 MSG 코드 중 묶음 해당 = MSG00002 1개. MSG00606 KO '저장되었습니다.' ≠ MSG00002 KO '성공적으로 저장되었습니다.' | 11-18 20:2x i18n_static.py 제외 규칙에 해당(SCP0111 마지막 실행 19:47 이 그 전). 수정 없음, 다음 CheckList 에서 빠짐 |
| EG-42d53d53 | MS1 | 판단 | PKG_SCP0111 3204줄 C_MSG_DUP := '[99010]동일한 데이터가 존재합니다.', 3337줄 RAISE_APPLICATION_ERROR(-20010, C_MSG_DUP). 사용자 화면에 한글 고정 문구로 나감 | 검사기 보완 T340. `i18n_static.py` 문구의 메시지 출력 경로(use) 기록, `eg_ingest.py` RAISE·MSG 변수 = FAIL(CR-008), 경로 없음 = 판정필요. 이 행은 FAIL 예정. PKG 보완은 보완 단계 대상(D7) |
| V-23d0a714 | F5 | 판단 | AS-IS DeleteButton 본문 없음(SCP0111_IntegrationPSI.cs:536~539). TO-BE 기존 행 Delete 알림 '신규 입력 (Insert) 한 행만 삭제할 수 있습니다.' | 검사기 보완 T341. `tools/E2E/lib/mergecheck.ts` emptyOverrideLine, judgeMergeDelete asisNoDelete, `_verify.spec.ts` asisNoDeleteAt. AS-IS 빈 Delete + 알림 = NA(원문 근거) |
| V-171648d3 | H4 | 판단 | layout2.ts 가 판정필요로 낸 행을 judge.py REVIEW_SWEEP 이 ERROR 로 바꿈. 사용자 선례 T102(SCP0016 V-34521981 '오류 아님, 판정 필요로 이관') | 검사기 보완 T342. `judge.py` 헤더 글자 잘림 행은 판정필요 유지 |
| EG-8451fc67 | G4 | 판단 | 팝업 조회조건 AS-IS [Model, Division, Site, Project] ↔ TO-BE [Div., Operation Group, Material] 양쪽 실측 끝남. CR-096 은 호출 인자만 정함 | 검사기 보완 T342. `judge.py` COND_LIST 구성 차이 = 판정필요(결정 D5) |
| EG-caf2c4d2 | G4 | 판단 | 위와 같음(Nick Name 팝업) | 위와 같음 |
| T-03071eab | F4 | 검사기공백(엔진) | main/SAVE 는 ADMIN 아닌 저장 계정만 호출(integration-psi.constants.ts:233~234). 시험 계정 minyonglee1 = ADMIN | 수정 없음. 결정 D10(다른 계정 실저장 복원 경로 없음) |
| T-ea67ed5b | F4 | 검사기공백(엔진) | 위와 같음 | 위와 같음 |
| T-18374ec4 | B4 | 데이터전제(엔진) | AS-IS 개발 DB Plan date 후보 0건(뷰 기준일 경과, 11-16 기록) ↔ TO-BE 22건 | 수정 없음. 결정 D6 |
| V-530425d0 | B4 | 데이터전제(엔진) | 위와 같음 | 위와 같음 |
| T-b8e710df | X-LOC | 대조표사유(가이드) | 대조표 45줄 SCP0111_DERIV_MISMATCH 가 소스에 없음(지금 소스 MSG01502) | DB MODE. FE_GUIDE_20261118_1816.md G7 그대로 |

## 사람 5행

| 행 | 규칙 | 내용 | 결정 |
|---|---|---|---|
| EG-d39015d9 | A1 | 양쪽 Measure 칸 설정이 있는 같은 사용자 없음 | A3 |
| EG-03a69cb6 | A6 | TITLESET_USER 보유·미보유 계정쌍 없음 | A2 |
| EG-b3b45d64 | J4 | 명부에 GUEST 전용 계정 없음(11-18 23:0x users.json guestAccount 추가, SCP0111 은 그 뒤 미실행) | A1 |
| V-fd3610e5 | J4 | EG-b3b45d64 따름 | A1 |
| ES-cd72403b | F1 | editonly 화면 신규 행 저장 시험 보류(saveCalls=0) | D9 |

## 집계 14행(하위 행 판정을 따라감)

| 행 | 규칙 | 따르는 하위 행 |
|---|---|---|
| V-1cfe031a, V-222881c4, V-31f5eee3, V-aa1e3d20, V-dd4d11b7, V-d11f5638 | F5 | V-23d0a714 |
| V-65b54305, V-8d92277c, V-9ecafdc2, V-b1bc2122 | G4 | EG-8451fc67, EG-caf2c4d2, ES-f6cf77b0 |
| V-cefbaa9f | I1 | EG-c892f15f |
| T-7f7f309f, T-81c9a537 | X-ROW | J2 화면 단위 검사 ERROR. 원천 = `Doc/e2e/results/SCP0111/_summary.csv` authcrud FAIL 'jooyong026 허용 계정 마커 행 저장 · 재조회 후 신규 행 존재'(mapping_trace.py test_status_for 가 조작 실패로 보고 ERROR). ES-cd72403b(D9 저장 보류)와 같은 원인 |
| T-eb4e0e13 | X-ROW | 하위 24검사 중 ERROR 1 = I1 화면 단위 검사(mapping_trace 2056·2125줄 문장). EG-c892f15f 따름 |
