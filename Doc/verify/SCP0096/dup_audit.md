# SCP0096 중복 실태표 · 2026-11-25 19:17:56

- 시험 기록 구간(UTC): 처음 ~ 9999

## 1층 검사 행

- 원장 1675행 · 출처별 GENERAL 683, TRACE 343, RULE_SCREEN 325, CONFIRMED 107, ASIS_DIFF 84, DEFECT 48, SEARCH 29, COLUMN 28, ASIS 14, SP 8, MSG 6
- 같은 확인 묶음 31개(65행, 대표 외 구성원 34행) · 판정 모두 같음 30 · 판정 다름 1
- 출처 조합: CONFIRMED + DEFECT 24, ASIS + TRACE 7
- 집계 행(GENERAL) 683

## 2층 측정 동작

- 시험 825개 · 시험 시간 합 307.4분 · 로그인 5초 초과분 4.6분 · 시험마다 되풀이한 로그인(5초까지)·열기·조회 130.2분 · 본문 172.6분
- 읽기 시험 0 · 쓰기 시험 0 · 스펙별 _snap.spec.ts 36, _trace.spec.ts 154, _verify.spec.ts 548, eg_auth.spec.ts 87
- 포착 호출 650건 · 서로 다른 호출 21건 · 반복 629건 · 반복분 서버 시간 94.9초
- 많이 반복된 호출: dayRange/SEARCH 229회(시험 63개, 평균 106ms); calendar/SEARCH 188회(시험 52개, 평균 131ms); Shipment Working Day OSP/SEARCH 155회(시험 52개, 평균 207ms); Shipment Working Day OSP/SEARCH 18회(시험 4개, 평균 496ms); dayRange/SEARCH 17회(시험 4개, 평균 98ms); dayRange/SEARCH 14회(시험 6개, 평균 93ms)

- 같은 기능 팝업: 시험 54개 · 5.4분 · _snap.spec.ts:@snap 조회조건 팝업 정적 aria; _trace.spec.ts:G4 조회조건 팝업 버튼(BTN) = AS-IS 버튼 → TO-BE 칸 버튼; _trace.spec.ts:PCOL 팝업 내부 그리드 컬럼 — H5·A5·D5·H2; _trace.spec.ts:W4 M4 팝업 선택값 반영 = AS-IS; _verify.spec.ts:고정 컬럼(H12)·동적 헤더(A9)·로딩 표시(H11)·팝업 Enter(G10)·특수 버튼(M2); _verify.spec.ts:그리드 더블클릭 팝업 인자(G5) — AS-IS 가 팝업에 넘기는 셀 값이 TO-BE 팝업 조회 요청에 들어가는지
- 같은 기능 저장: 시험 65개 · 43.5분 · _trace.spec.ts:W4 E4 업무 검증 메시지 = AS-IS(저장 차단); _verify.spec.ts:CRUD — 필수 공란 실제 저장 시도(E3) → 필수 채워 실제 저장·재조회·값 보존·정리(F1·F2·F4·F6); _verify.spec.ts:입력 검증 저장(E1 음수·소수·E2 날짜·E5 콤보); _verify.spec.ts:저장 경로(F1 실패·H10 취소·H11 로딩·F2 붙여넣기); _verify.spec.ts:저장 세부(F1·F6) — 컬럼별 왕복·0 값 저장; _verify.spec.ts:후보 갱신(B7) — 저장→콤보 원천 대조(a)·재진입/재조회 시 콤보 재조회(b); eg_auth.spec.ts:개인화 저장 후 동작(EG395) — 저장 요청을 서버로 보내지 않고 화면 반응만
