# E2E 결과 — 2026-11-19 17:25

테스트 6 · PASS 2 · FAIL 4 · FLAKY 0 · SKIP 0

| 화면 | 스모크 | 조회조건 동작 | 공통 기능 | CRUD | 권한(계정×DIV) | 권한별 CRUD(계정) | BE DB 오류(시노님·SQL) | 실패 요약 |
|---|---|---|---|---|---|---|---|---|
| SSP0014 | 0/3 ✗ | - | - | 0/1 ✗ | 1/1 | 1/1 | - | smoke: Error: 조회조건 'Div' (DivisionField) — 후보 [Div | Div.]<br>smoke: Error: 권한 안내 없이 열림<br>smoke: Error: 권한 안내 없이 열림<br>crud: Error: expect(received).toBeTruthy() |

상세: `_summary.csv` (어노테이션: cond=조회조건별 동작(값 변경→조회·기준표 순서·Checkbox/Radio 디자인) · common=공통 기능(Search·F5·Sort·Filter·Condition·Reset·Excel·Columns·Search Area·Manual) · columns=컬럼 대사, dynamic=동적 기간 컬럼(정적 메타 밖 binding 수·타이틀 시트 호출), calls=call-proc, buttons=노출 버튼, division=DIV별 행수, crud=CRUD 사이클 결과(mode/saved/cleaned), authcrud=계정 권한 기대(btn_auth) vs 실측) · HTML: `html/index.html` · 실패 trace: `artifacts/`
