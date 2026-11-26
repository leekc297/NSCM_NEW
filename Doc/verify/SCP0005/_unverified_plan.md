# SCP0005 미검증 조치표 (라운드 7, 2026-11-25 22:4x)

입력: 해소 원장 unverified_worklist.csv(기준 21:07:34, 생성 22:36:28) 24행. 열림 21행(검사기 11, 데이터전제 6, AI후보 4), 집계 3행. 원장 verify_ledger.csv ERROR 20행 + FAIL 1행(V-91dc58e6 AI후보).
원장 미검증 처리 대상 = 조치표 21행(빠진 행 0). 집계 3행(V-ef37f9e9, T-d920ea16, T-e71343b5)은 하위 행을 따라감.
라운드 6 사본 _unverified_plan.md.bak_20261125_r6.

| 묶음 | 행 ID | 규칙 | 대상 | 측정 실패 지점(실측) | 고칠 곳 | 담당 |
|---|---|---|---|---|---|---|
| R7-1 저장 감사 계정 | V-a8518547, V-4bee5c9b, V-91dc58e6, EG-9ec319ae, EG-6c4494f4, EG-d899e761, EG-66bd3635, EG-ded49290, EG-157be290 | F8 | 저장 감사 칸, 이력 행 값 | 정리 기록 cleanup_20261125_191358.sql 머리글에 계정 없음 → 기본 계정 minyonglee1 기대(실제 저장 jooyong026). judge F8 블록이 EG 행 6개(save_trace PASS)를 이 FAIL 로 덮음. eg_ingest 가 같은 행 감사 판정 여러 줄 중 마지막(NA)을 씀 | save_audit.py(키별 계정·시각, 삭제 조건 CREATED_BY, dry-run 제외, 루트 표), judge.py F8 블록(EG 행 제외), eg_ingest.py SAC 묶음, cleanup_marker.py·ledger_guard.py(키별 계정·마커 줄) | 주 세션 |
| R7-2 저장 응답 표본 | V-3134fc3e, T-ece1c98b, T-f048d4a9, V-b6f27092, V-bc631885, V-06e7dec2, V-fa71e89c, V-dc54eed4 | E4, H2 | MSG00043, 저장 오류 칸 색 5묶음 | 'route/SAVE 실제 응답 표본 없음'. 19:41 부분 재측정(E1,H13)이 .prev 를 덮어 표본 0건. 22:36 결과 T-9b93a539 에 표본 있음 | tools/E2E/lib/btnpopup.ts persistRespSamples, Doc/e2e/specs/_trace.spec.ts 표본 원천 2곳 | 주 세션 |
| R7-3 빈값 비교 | V-6e159871 | A7 | SCP0005_GET_DISTRIBUTION_ROUTE | a_port_name 8행, shipping_company 334행, lt_type 1685행 ''↔'/' 를 값 다름으로 셈. 키 셀 비교(T239)에는 빈값 동치가 있고 컬럼 프로파일 계산에는 없음 | tools/DbConn/golden.py 컬럼 프로파일 불일치 계산 | 주 세션 |
| R7-4 신규 행 정리 | ES-88905017 | F1 | E2E crud 저장 왕복(insert) | inserted·saved·found·updated=Y, cleaned=N. 화면 삭제는 신규 행만 지움(AS-IS cs:302~308, TO-BE DistributionRoute.tsx:148). DB 잔존 원래 표 11행·이력 표 24행(22:50 조회) | tools/E2E/lib/crud.ts deferDbCleanup, ledger_guard.py record, cleanup_marker.py 마커 조건 | 주 세션 |
| R7-5 버튼 테두리 클릭 | V-fe802ac0 | H6 | From City 검색 버튼 | 테두리 클릭 실측 없음. 버튼 전 영역 실측이 조회조건 팝업(COND)만 돌고 AS-IS 버튼 팝업(BTN btnFromSrch)은 건너뜀. 같은 규칙 팝업 버튼 순서 FAIL 12행을 'City' 낱말로 물려받음 | Doc/e2e/specs/eg_popup.spec.ts runCorners, tools/Harness/verify/judge.py 결함 상속 | 주 세션 |
| R7-6 팝업 선택 반영 | EG-f36911c9 | M4 | 도시 팝업 TO_CITY 칸 OK | 고른 1행 = ADALV(popup_rowsets.json call 6), 칸 'ADCAN' 유지. 같은 팝업을 TO_COUNTRY 칸에서 열면 TO_CITY 'ADCAN'→'ADALV' 반영(call 7). AI 검토의 '고른 행 값이 같음'은 행 기록과 다름. 대응 컬럼이 부분 일치로 COUNTRY 로 잡힘 | eg_popup.spec.ts PICK_OK 다시 읽기(3초)·완전 일치 대응 컬럼·재현 근거 | 주 세션 |

하위 에이전트: 쓰지 않음. 6묶음 중 4묶음이 같은 스펙·판정 파일(judge.py, eg_popup.spec.ts, _trace.spec.ts)을 고쳐 주 세션이 차례로 처리함.
