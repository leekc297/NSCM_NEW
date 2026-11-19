# SCP0111 미검증 행별 조치 (2026-11-18 18:17 · 라운드 1)

- 원천: `unverified_triage.csv`(2026-11-18 17:44:39) 47행. 이 표 47행(집계 18 포함), 원장 미검증 47행과 같음
- 조치 칸: 고친 검사기 파일, 원인 실측 근거, 결정 목록 번호(`_unverified_decisions.md`)
- 재측정은 VM 체인의 CheckList 전체 1회로 함(사용자 지시 2026-11-18 '일괄 보완 뒤 전체 검증')

## 처리 대상 26행 + 사람 3행

| 행 | 규칙 | 유형(담당) | 원인(실측) | 조치 |
|---|---|---|---|---|
| V-daf17c68 | F7 | 검사기공백(엔진) | save_audit.py 가 신규 행 정리 백업(cleanup_*.sql)만 근거로 씀. SCP0111 은 cleanup_spec mode=editonly(기존 행 수정 저장)라 백업이 없어 NOT_RUN. 같은 실행의 restore_touched 로그에 '시험 계정 변경 행 12 → 되돌림 12' 있음 | restore_touched.py 키 없는 복원이 되돌리기 전 변경 행 표·감사 판정을 save_trace.json 에 남김. save_audit.py 가 정리 백업이 없으면 save_trace.json 으로 F7·F8 판정. AS-IS 저장 SP 대상 표 추출에 T-SQL 별칭(UPDATE X … FROM 표 X)·주석 처리 보완 |
| V-e14dd788 | F8 | 검사기공백(엔진) | 위와 같음 | 위와 같음 |
| EG-7a7637ba | I2 | 검사기공백(엔진) | lang_texts.json KO·EN·CN 3개 언어 'SCP0096 E2E 동시 실행 — 전환 생략(T200)'. 16:34 실행 로그 '[langlock] SCP0111 I2: 다른 화면 E2E 실행 중(SCP0096)' 뒤 6.1분 대기 후 생략 | run_verify.py lang_retry: 본 E2E 뒤 다른 화면 E2E 종료를 최대 45분 기다려 I2 시험만 다시 실행(대기 표식으로 교착 방지) |
| EG-ee2bb45d | I2 | 검사기공백(엔진) | 위와 같음 | 위와 같음 |
| V-6b31428f | I3 | 검사기공백(엔진) | judge.py I3 판정은 i18n_lang.csv '<언어> 데이터' 행을 씀. I2 전환 생략으로 그 행이 없음 | I2 재실행으로 같이 풀림(검사기 추가 수정 없음) |
| V-d9598564 | J4 | 검사기공백(엔진) | _trace.spec.ts:1897 이 결함원장 J4 행을 '측정 코드 없음' 으로 고정 기록. 그룹×메뉴 대조 도구(facts_auth_db groups · EG372)는 체인 밖(10-31 실행본) | menu_auth_sync.py 신설(AS-IS TB_FX_GroupMenuAuth ↔ TO-BE 그룹×메뉴·버튼, 버튼 짝 BaseForm.cs). 18:05 SCP0111 실측 PASS(그룹 5↔5, R·C·U·D·SAVE 일치). run_verify 사후 단계 연결, judge.py J4 결함원장 행 판정 연결 |
| V-fd3610e5 | J4 | 검사기공백(엔진) | 같은 결함 DM-247 을 재는 EG-b3b45d64(EG380) 가 있는데 연결 없음 | judge.py: 같은 결함 번호를 근거로 든 같은 규칙 EG 행 결과를 따름. EG380 은 GUEST 계정 없음이라 결정 목록 A1 로 감 |
| V-ce8459b6 | E2 | 검사기공백(엔진) | _verify.spec.ts E2 가 To 칸에 키보드로 '2024.10' 입력. 분리형 월 칸(MUI)이라 역전·대조군 둘 다 안 들어감(실측 18:0x 디버그: 달력으로 고르면 202505 들어감) | _verify.spec.ts E2: 키보드 실패 시 smoke-extra.ts pickSplitMonth 로 달력 선택(대조군 = 다음 해 같은 달) |
| V-a30ef64b | G1 | 미분류(엔진) | _trace.spec.ts G1 기간 칸이 periodShiftEnd 사용. 범위 달력(_popup_ · monthPanel)만 다뤄 분리형 월 칸(_periodSplit_ · 달력 버튼 2개 · MUI 월 팝오버)에서 '달력이 열리지 않음' | smoke-extra.ts isSplitPeriod, pickSplitMonth 신설. periodShiftEnd, periodReverseTry 에 분리형 경로 추가. 디버그 실측: 끝 202703 → 202702, 역전 시작 202704 > 끝 202703 |
| V-c73d3323 | G1 | 검사기공백(엔진) | AS-IS MSG00344(기간 역전 차단) 행은 위 G1 기간 측정이 성공한 뒤에만 잼(periodReverseTry). 앞 단계 실패로 측정 안 됨 | 위 수정으로 같이 측정됨 |
| V-81d39949 | M2 | 판단(판단) | _verify.spec.ts M2 가 조회조건 Period 칸 안 달력 아이콘 버튼(aria-label calendar)을 화면 전용 버튼으로 골라 클릭. 디버그 실측: 조회조건 칸 안 버튼 2개 | _verify.spec.ts M2: 조회조건 칸 안 글자 없는 아이콘 버튼 제외 |
| T-7e4b2b41 | K4 | 판단(판단) | AS-IS 버튼 Search·Insert·Save 에 없는 Delete 노출. TO-BE 룰 CR-070(공통 버튼 = 화면 기능 + 버튼 코드 권한일 때 노출). IntegrationPsi.tsx:465 `delete: … handleDelete`, ADMIN 그룹 DELETE 권한 Y(menu_auth_sync 실측) | judge.py K4: 화면 소스 버튼 핸들러 + 시험 계정 그룹 버튼 권한 확인되면 CR-070 근거로 PASS |
| ES-0af2f16b | F1 | 데이터전제(엔진) | crud.ts 가 화면에 그려진 행(.wj-row) 수로 Insert 성공 판단. 디버그 실측: DOM 37 → 37, 그리드 1259 → 1260(신규 행 1259번 CRUD_TYPE I). 빈 행을 못 찾으면 0번(기존 행)에 마커를 넣는 경로도 있었음 | crud.ts: 그리드 행 수로도 판단, 신규 행 위치는 그리드 CRUD_TYPE=I 행으로 찾고 못 찾으면 중단. editonly 화면은 저장 시험 보류(정리 경로 없음) → 결정 목록 D9 |
| T-03071eab | F4 | 검사기공백(엔진) | main/SAVE(일반 저장)는 ADMIN 아닌 저장 계정만 호출(integration-psi.constants.ts:233~234). 시험 계정 minyonglee1 은 ADMIN 이라 SAVEDETAIL 만 나감 | 결정 목록 D10(다른 사람 계정 실저장 복원 경로 없음) |
| T-ea67ed5b | F4 | 검사기공백(엔진) | 위와 같음 | 위와 같음 |
| T-18374ec4 | B4 | 데이터전제(엔진) | AS-IS 개발 DB Plan date 후보 0건(뷰 기준일 경과, 11-16 기록) ↔ TO-BE 22건 | 결정 목록 D6(AS-IS 개발 DB 데이터 추가는 사용자 확인 사항) |
| V-530425d0 | B4 | 데이터전제(엔진) | 위와 같음 | 위와 같음 |
| T-b8e710df | X-LOC | 대조표사유(대조표) | 대조표 45줄 식별자 SCP0111_DERIV_MISMATCH 가 소스에 없음. 지금 소스 = MSG01502(integration-psi.constants.ts:169), 판정 IntegrationPsiGrid.tsx:423~447 | DB MODE: FE_GUIDE_20261118_1816.md G7 |
| V-171648d3 | H4 | 미분류(엔진) | 헤더 5칸 글자 > 칸 폭. CR-003(폭 ≥ 헤더 문구)과 T102(칸 폭 = 사람 판정) 충돌 | 분류표 '판단' 추가 · 결정 목록 D1 |
| EG-8451fc67 | G4 | 미분류(엔진) | AS-IS SCM0002 조회조건 Model·Division·Site·Project ↔ TO-BE 공용 모달 Div·Operation Group·Material. CR-096 은 호출 인자만 다룸 | 분류표 '판단' 추가 · 결정 목록 D5 |
| EG-caf2c4d2 | G4 | 미분류(엔진) | 위와 같음 | 위와 같음 |
| V-028e36d9 | A2 | 판단(판단) | INCOTERMS 26행 'FCA' 가 콤보 후보에 없어 코드 그대로 보임. 콤보 원천 비활성 여부 미확인 | 결정 목록 D4 |
| V-23d0a714 | F5 | 판단(판단) | 병합 37행 Delete → D 표시 0, 알림 '신규 입력 (Insert) 한 행만 삭제할 수 있습니다.'. CR-057 은 Active 관리 화면 조건이라 그대로 적용 안 됨 | 결정 목록 D3 |
| ES-f6cf77b0 | G4 | 판단(판단) | smoke 조회조건 라벨 'Qty ＜ 0' 누락(후보 [Qty ＜ 0, Qty ≥ 0]) | 결정 목록 D11 |
| EG-c892f15f | I1 | 판단(판단) | MSG00002 · MSG00606 같은 문구 '[EN] Saved successfully.'. CR-032(같은 문구 코드 1개) | 결정 목록 D8 |
| EG-42d53d53 | MS1 | 판단(판단) | PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN 안 한글 문구 '[99010]동일한 데이터가 존재합니다.'. CR-008(3개 언어 등록) | 결정 목록 D7(보완 단계 대상 · 정합검증 단계 보완 금지) |
| EG-d39015d9 | A1 | 계정(사람) | 양쪽 Measure 칸 설정이 있는 같은 사용자 없음 | 결정 목록 A3 |
| EG-03a69cb6 | A6 | 계정(사람) | TITLESET_USER 보유·미보유 계정쌍 없음 | 결정 목록 A2 |
| EG-b3b45d64 | J4 | 계정(사람) | GUEST 전용 계정 없음 | 결정 목록 A1 |

## 집계 18행(하위 행 판정을 따라감)

| 행 | 규칙 | 따르는 하위 행 |
|---|---|---|
| V-1cfe031a, V-222881c4, V-31f5eee3, V-aa1e3d20, V-dd4d11b7, V-d11f5638 | F5 | V-23d0a714 |
| V-65b54305, V-8d92277c, V-9ecafdc2, V-b1bc2122 | G4 | EG-8451fc67, EG-caf2c4d2 |
| V-cefbaa9f | I1 | EG-c892f15f |
| T-99a0a856, T-d89f244f, T-7ceed643 | G1 | 기간 G1 행(V-a30ef64b, V-c73d3323) |
| T-7f7f309f, T-81c9a537, T-caf721fa, T-eb4e0e13 | X-ROW | 진입점 하위 검사(팝업 G4 · 기간 G1 등) |
