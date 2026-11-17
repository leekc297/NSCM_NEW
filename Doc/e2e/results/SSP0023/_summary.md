# E2E 결과 — 2026-11-14 23:50

테스트 5 · PASS 1 · FAIL 4 · FLAKY 0 · SKIP 0

| 화면 | 스모크 | 조회조건 동작 | 공통 기능 | CRUD | 권한(계정×DIV) | 권한별 CRUD(계정) | BE DB 오류(시노님·SQL) | 실패 요약 |
|---|---|---|---|---|---|---|---|---|
| SSP0023 | 0/3 ✗ | 8/15 OK · FAIL 0 · WARN 6 · ERROR 1 | 11/12 OK · FAIL 1 · WARN 0 · ERROR 0 | - | 1/1 | 0/1 ✗ | 2건 | smoke: Error: 조회조건 'Result Type' (CustomDropdown) — 후보 [Result Type]<br>smoke: Error: 조회조건 판정 불가(ERROR) 1: Result Type<br>smoke: Error: 공통 기능 FAIL 1: Search Area 조회영역 토글<br>authcrud: Error: [jinhuannj] 허용 계정 마커 행 저장  |

상세: `_summary.csv` (어노테이션: cond=조회조건별 동작(값 변경→조회·기준표 순서·Checkbox/Radio 디자인) · common=공통 기능(Search·F5·Sort·Filter·Condition·Reset·Excel·Columns·Search Area·Manual) · columns=컬럼 대사, dynamic=동적 기간 컬럼(정적 메타 밖 binding 수·타이틀 시트 호출), calls=call-proc, buttons=노출 버튼, division=DIV별 행수, crud=CRUD 사이클 결과(mode/saved/cleaned), authcrud=계정 권한 기대(btn_auth) vs 실측) · HTML: `html/index.html` · 실패 trace: `artifacts/`
