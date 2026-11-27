# SCP0005 중복 실태표 · 2026-11-25 19:17:56

- 시험 기록 구간(UTC): 2026-11-24T16:24:33.070Z ~ 2026-11-24T17:06:44.600ZZ

## 1층 검사 행

- 원장 2276행 · 출처별 RULE_SCREEN 622, GENERAL 551, TRACE 448, COLUMN 284, CONFIRMED 110, ASIS 98, ASIS_DIFF 72, DEFECT 50, SEARCH 20, MSG 11, SP 10
- 같은 확인 묶음 44개(95행, 대표 외 구성원 51행) · 판정 모두 같음 31 · 판정 다름 13
- 출처 조합: CONFIRMED + DEFECT 24, ASIS + TRACE 20
- 집계 행(GENERAL) 551

## 2층 측정 동작

- 시험 82개 · 시험 시간 합 84.1분 · 로그인 5초 초과분 0.8분 · 시험마다 되풀이한 로그인(5초까지)·열기·조회 31.5분 · 본문 51.7분
- 읽기 시험 112 · 쓰기 시험 6 · 스펙별 _verify.spec.ts 60, _trace.spec.ts 18, _snap.spec.ts 4
- 포착 호출 585건 · 서로 다른 호출 24건 · 반복 561건 · 반복분 서버 시간 548.6초
- 많이 반복된 호출: route/SEARCH 266회(시험 69개, 평균 646ms); region/SEARCH 219회(시험 88개, 평균 1626ms); route/SEARCH_CITY 32회(시험 14개, 평균 104ms); region/SEARCH 6회(시험 6개, 평균 144ms); region/SEARCH 6회(시험 6개, 평균 148ms); region/SEARCH 6회(시험 6개, 평균 154ms)

- 같은 기능 팝업: 시험 7개 · 2.0분 · _snap.spec.ts:@snap 조회조건 팝업 정적 aria; _trace.spec.ts:BTN 팝업 경로(F4·E4·G1) = AS-IS 버튼 → 팝업 → OK → 후속 메서드; _trace.spec.ts:G4 조회조건 팝업 버튼(BTN) = AS-IS 버튼 → TO-BE 칸 버튼; _trace.spec.ts:PCOL 팝업 내부 그리드 컬럼 — H5·A5·D5·H2; _trace.spec.ts:W4 M4 팝업 선택값 반영 = AS-IS; _verify.spec.ts:고정 컬럼(H12)·동적 헤더(A9)·로딩 표시(H11)·팝업 Enter(G10)·특수 버튼(M2); _verify.spec.ts:그리드 더블클릭 팝업 인자(G5) — AS-IS 가 팝업에 넘기는 셀 값이 TO-BE 팝업 조회 요청에 들어가는지
- 같은 기능 저장: 시험 6개 · 9.3분 · _trace.spec.ts:W4 E4 업무 검증 메시지 = AS-IS(저장 차단); _verify.spec.ts:CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6); _verify.spec.ts:입력 검증 저장(E1 음수·소수·E2 날짜·E5 콤보); _verify.spec.ts:저장 경로(F1 실패·H10 취소·H11 로딩·F2 붙여넣기); _verify.spec.ts:저장 세부(F1·F6) — 컬럼별 왕복·0 값 저장; _verify.spec.ts:후보 갱신(B7) — 저장→콤보 원천 대조(a)·재진입/재조회 시 콤보 재조회(b)
