# E2E 결과 — 2026-11-05 06:24

테스트 58 · PASS 26 · FAIL 32 · FLAKY 0 · SKIP 0

| 화면 | 스모크 | 조회조건 동작 | 공통 기능 | CRUD | 권한(계정×DIV) | 권한별 CRUD(계정) | BE DB 오류(시노님·SQL) | 실패 요약 |
|---|---|---|---|---|---|---|---|---|
| DMF0004 | 1/3 ✗ | 5/8 OK · FAIL 0 · WARN 1 · ERROR 2 | 8/8 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Team' (TeamField) — 후보 [Team]<br>smoke: Error: 조회조건 판정 불가(ERROR) 2: Team, Detail |
| DMF0005 | 0/3 ✗ | 6/12 OK · FAIL 0 · WARN 1 · ERROR 5 | 10/11 OK · FAIL 1 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Project Null' (Checkbox) — 후보 [Project Null]<br>smoke: Error: 조회조건 판정 불가(ERROR) 5: Project Null, Project, End Customer(Report) Null, Detail, Owner<br>smoke: Error: 공통 기능 FAIL 1: Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제) |
| DMF0082 | 0/3 ✗ | 4/12 OK · FAIL 1 · WARN 4 · ERROR 3 | 10/12 OK · FAIL 1 · WARN 0 · ERROR 1 | - | - | - | - | smoke: Error: 조회조건 ' ' (Checkbox) — 후보 []<br>smoke: Error: 조회조건 동작 FAIL 1: Sum<br>smoke: Error: 공통 기능 FAIL 1: Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제) |
| SCP0007 | 2/3 ✗ | 2/10 OK · FAIL 0 · WARN 8 · ERROR 0 | 8/8 OK · FAIL 0 · WARN 0 · ERROR 0 | 0/1 ✗ | 5/5 | 0/1 ✗ | - | smoke: Error: 그리드 컬럼 누락 (메타 기준)<br>crud: Error: 마커 행 저장 성공 <br>authcrud: Test timeout of 540000ms exceeded. |
| SCP0028 | 0/3 ✗ | 7/8 OK · FAIL 0 · WARN 0 · ERROR 1 | 10/11 OK · FAIL 1 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Division*' (DivisionField) — 후보 [Div. | Division]<br>smoke: Error: 조회조건 판정 불가(ERROR) 1: Model<br>smoke: Error: 공통 기능 FAIL 1: Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제) |
| SCP0041 | 0/3 ✗ | 6/9 OK · FAIL 0 · WARN 0 · ERROR 3 | 10/11 OK · FAIL 1 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Inspection' (InputField) — 후보 [Inspection]<br>smoke: Error: 조회조건 판정 불가(ERROR) 3: Inspection, Cutoff Date, Status<br>smoke: Error: 공통 기능 FAIL 1: Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제) |
| SCP0084 | 0/3 ✗ | 2/6 OK · FAIL 1 · WARN 2 · ERROR 1 | 10/12 OK · FAIL 1 · WARN 0 · ERROR 1 | - | - | - | 3건 (시노님·권한 3) | smoke: Error: 그리드 컬럼 누락 (메타 기준)<br>smoke: Test timeout of 1200000ms exceeded.<br>smoke: Error: 공통 기능 FAIL 1: Excel 다운로드 |
| SCP0096 | 0/3 ✗ | 5/7 OK · FAIL 0 · WARN 0 · ERROR 2 | 11/12 OK · FAIL 1 · WARN 0 · ERROR 0 | 1/1 | 2/2 | 2/2 | - | smoke: Error: 조회조건 'Input Value' (CustomDropdown) — 후보 [Input Value | -]<br>smoke: Error: 조회조건 판정 불가(ERROR) 2: Input Value, Day of the week<br>smoke: Error: 공통 기능 FAIL 1: Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제) |
| SCP0100 | 2/3 ✗ | 13/18 OK · FAIL 1 · WARN 3 · ERROR 1 | 10/11 OK · FAIL 0 · WARN 0 · ERROR 1 | 1/1 | 2/2 | 2/2 | - | smoke: Error: 조회조건 동작 FAIL 1: (기준표 순서) |
| SCP0111 | 0/3 ✗ | 6/9 OK · FAIL 1 · WARN 0 · ERROR 2 | 11/13 OK · FAIL 2 · WARN 0 · ERROR 0 | - | - | - | 3건 | smoke: Error: 조회조건 'Qty ＜ 0' (Checkbox) — 후보 [Qty ＜ 0 | Qty ≥ 0]<br>smoke: Error: 조회조건 동작 FAIL 1: (기준표 순서)<br>smoke: Error: 공통 기능 FAIL 2: Condition(F6) Period 비저장(기간 조건 제외), Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제) |
| SCP0122 | 3/3 | 4/5 OK · FAIL 0 · WARN 1 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | 0/1 ✗ | 2/2 | 1/2 ✗ | 3건 | crud: Test timeout of 300000ms exceeded.<br>authcrud: Error: [jaeuk.shin] 재조회 후 신규 행 존재 |
| SCP0125 | 0/3 ✗ | 0/6 OK · FAIL 1 · WARN 0 · ERROR 5 | 0/2 OK · FAIL 1 · WARN 1 · ERROR 0 | - | - | - | 3건 | smoke: Error: 조회조건 'Div' (DivisionField) — 후보 [Div | Div.]<br>smoke: Error: 조회조건 동작 FAIL 1: (기준 조회)<br>smoke: Error: 공통 기능 FAIL 1: Search(조회 버튼) |

상세: `_summary.csv` (어노테이션: cond=조회조건별 동작(값 변경→조회·기준표 순서·Checkbox/Radio 디자인) · common=공통 기능(Search·F5·Sort·Filter·Condition·Reset·Excel·Columns·Search Area·Manual) · columns=컬럼 대사, dynamic=동적 기간 컬럼(정적 메타 밖 binding 수·타이틀 시트 호출), calls=call-proc, buttons=노출 버튼, division=DIV별 행수, crud=CRUD 사이클 결과(mode/saved/cleaned), authcrud=계정 권한 기대(btn_auth) vs 실측) · HTML: `html/index.html` · 실패 trace: `artifacts/`
