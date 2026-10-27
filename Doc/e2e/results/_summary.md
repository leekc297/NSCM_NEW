# E2E 결과 — 2026-10-26 18:15

테스트 32 · PASS 27 · FAIL 5 · FLAKY 0 · SKIP 0

| 화면 | 스모크 | 조회조건 동작 | 공통 기능 | CRUD | 권한(계정×DIV) | 권한별 CRUD(계정) | BE DB 오류(시노님·SQL) | 실패 요약 |
|---|---|---|---|---|---|---|---|---|
| SCP0007 | 2/3 ✗ | 2/10 OK · FAIL 0 · WARN 8 · ERROR 0 | 8/8 OK · FAIL 0 · WARN 0 · ERROR 0 | 0/1 ✗ | 5/5 | 4/5 ✗ | - | smoke: Error: 그리드 컬럼 누락 (메타 기준)<br>crud: Error: 마커 행 저장 성공 <br>authcrud: Error: [jaeuk.shin] 허용 계정 마커 행 저장  |
| SCP0096 | 1/1 | - | - | 1/1 | 2/2 | 2/2 | - |  |
| SCP0100 | 1/1 | - | - | 1/1 | 2/2 | 2/2 | - |  |
| SCP0122 | 1/1 | - | - | 0/1 ✗ | 2/2 | 1/2 ✗ | - | crud: Test timeout of 300000ms exceeded.<br>authcrud: Error: [jaeuk.shin] 재조회 후 신규 행 존재 |

상세: `_summary.csv` (어노테이션: cond=조회조건별 동작(값 변경→조회·기준표 순서·Checkbox/Radio 디자인) · common=공통 기능(Search·F5·Sort·Filter·Condition·Reset·Excel·Columns·Search Area·Manual) · columns=컬럼 대사, dynamic=동적 기간 컬럼(정적 메타 밖 binding 수·타이틀 시트 호출), calls=call-proc, buttons=노출 버튼, division=DIV별 행수, crud=CRUD 사이클 결과(mode/saved/cleaned), authcrud=계정 권한 기대(btn_auth) vs 실측) · HTML: `html/index.html` · 실패 trace: `artifacts/`
