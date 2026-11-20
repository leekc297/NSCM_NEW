# E2E 결과 — 2026-11-20 15:03

테스트 145 · PASS 90 · FAIL 55 · FLAKY 0 · SKIP 0

| 화면 | 스모크 | 조회조건 동작 | 공통 기능 | CRUD | 권한(계정×DIV) | 권한별 CRUD(계정) | BE DB 오류(시노님·SQL) | 실패 요약 |
|---|---|---|---|---|---|---|---|---|
| DMF0004 | 1/3 ✗ | 5/8 OK · FAIL 0 · WARN 1 · ERROR 2 | 8/8 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Team' (TeamField) — 후보 [Team]<br>smoke: Error: 조회조건 판정 불가(ERROR) 2: Team, Detail |
| DMF0005 | 1/3 ✗ | 7/12 OK · FAIL 0 · WARN 1 · ERROR 4 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Project' (ProjectField) — 후보 [PJT | Project]<br>smoke: Error: 조회조건 판정 불가(ERROR) 4: Project Null, Project, End Customer(Report) Null, Detail |
| DMF0082 | 0/3 ✗ | 4/12 OK · FAIL 1 · WARN 4 · ERROR 3 | 10/12 OK · FAIL 1 · WARN 0 · ERROR 1 | - | - | - | - | smoke: Error: 조회조건 ' ' (Checkbox) — 후보 []<br>smoke: Error: 조회조건 동작 FAIL 1: Sum<br>smoke: Error: 공통 기능 FAIL 1: Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제) |
| SCP0005 | 3/3 | 5/7 OK · FAIL 0 · WARN 2 · ERROR 0 | 12/12 OK · FAIL 0 · WARN 0 · ERROR 0 | 0/1 ✗ | 2/2 | 1/2 ✗ | - | crud: Error: 마커 행 저장 성공 <br>authcrud: Error: [jooyong026] 허용 계정 마커 행 저장  |
| SCP0007 | 2/3 ✗ | 8/9 OK · FAIL 0 · WARN 1 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | 0/1 ✗ | 5/5 | 0/1 ✗ | - | smoke: Error: 헤더 시각적 단 수 ≥ 2 (As-is SetSheetHeaderColumn 2행 · 월간은 Qty 2행 병합 = 2단) — 1단이면 columnGroups leaf 라벨 점검<br>crud: Error: 마커 행 저장 성공 <br>authcrud: Test timeout of 540000ms exceeded. |
| SCP0016 | 2/3 ✗ | 6/10 OK · FAIL 0 · WARN 4 · ERROR 0 | 12/13 OK · FAIL 0 · WARN 1 · ERROR 0 | - | - | - | - | smoke: Error: As-is 병합 헤더 리터럴 노출 [SUM] |
| SCP0020 | 3/3 | 5/6 OK · FAIL 0 · WARN 1 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - |  |
| SCP0028 | 3/3 | 7/8 OK · FAIL 0 · WARN 1 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | 1/1 | 1/2 ✗ | 2/2 | - | auth: Error: [zhangjiali GUEST/SCM Viewer] btn_auth DELETE=N → 버튼 비노출 |
| SCP0033 | 3/3 | 3/4 OK · FAIL 0 · WARN 1 · ERROR 0 | 10/11 OK · FAIL 0 · WARN 0 · ERROR 1 | - | - | - | - |  |
| SCP0037 | 3/3 | 6/6 OK · FAIL 0 · WARN 0 · ERROR 0 | 10/11 OK · FAIL 0 · WARN 0 · ERROR 1 | - | - | - | - |  |
| SCP0041 | 1/3 ✗ | 5/8 OK · FAIL 0 · WARN 0 · ERROR 3 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Inspection' (InputField) — 후보 [Inspection]<br>smoke: Error: 조회조건 판정 불가(ERROR) 3: Inspection, Cutoff Date, Status |
| SCP0084 | 2/3 ✗ | 4/5 OK · FAIL 0 · WARN 1 · ERROR 0 | 11/12 OK · FAIL 1 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 공통 기능 FAIL 1: Excel 다운로드 |
| SCP0096 | 1/3 ✗ | 4/6 OK · FAIL 0 · WARN 0 · ERROR 2 | 12/12 OK · FAIL 0 · WARN 0 · ERROR 0 | 1/1 | 2/2 | 2/2 | - | smoke: Error: 조회조건 'Input Value' (CustomDropdown) — 후보 [Input Value | -]<br>smoke: Error: 조회조건 판정 불가(ERROR) 2: Input Value, Day of the week |
| SCP0100 | 2/3 ✗ | 13/18 OK · FAIL 1 · WARN 3 · ERROR 1 | 10/11 OK · FAIL 0 · WARN 0 · ERROR 1 | 1/1 | 2/2 | 2/2 | - | smoke: Error: 조회조건 동작 FAIL 1: (기준표 순서) |
| SCP0104 | 3/3 | 7/7 OK · FAIL 0 · WARN 0 · ERROR 0 | 12/12 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - |  |
| SCP0108 | 0/3 ✗ | 0/15 OK · FAIL 1 · WARN 0 · ERROR 14 | 0/2 OK · FAIL 1 · WARN 1 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Div' (DivisionField) — 후보 [Div | Div.]<br>smoke: Error: 조회조건 동작 FAIL 1: (기준 조회)<br>smoke: Error: 공통 기능 FAIL 1: Search(조회 버튼) |
| SCP0111 | 3/3 | 7/7 OK · FAIL 0 · WARN 0 · ERROR 0 | 12/12 OK · FAIL 0 · WARN 0 · ERROR 0 | 0/1 ✗ | 2/2 | 1/2 ✗ | - | crud: Error: 마커 행 저장 성공 <br>authcrud: Error: [jooyong026] 허용 계정 마커 행 저장  |
| SCP0122 | 3/3 | 3/4 OK · FAIL 0 · WARN 1 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | 0/1 ✗ | 2/2 | 2/2 | 2건 | crud: Test timeout of 300000ms exceeded. |
| SCP0125 | 0/3 ✗ | 0/6 OK · FAIL 1 · WARN 0 · ERROR 5 | 0/2 OK · FAIL 1 · WARN 1 · ERROR 0 | - | - | - | 3건 | smoke: Error: 조회조건 'Div' (DivisionField) — 후보 [Div | Div.]<br>smoke: Error: 조회조건 동작 FAIL 1: (기준 조회)<br>smoke: Error: 공통 기능 FAIL 1: Search(조회 버튼) |
| SCP0127 | 3/3 | 9/9 OK · FAIL 0 · WARN 0 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - |  |
| SCP0131 | 3/3 | 6/7 OK · FAIL 0 · WARN 1 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - |  |
| SSP0003 | 0/3 ✗ | 7/15 OK · FAIL 0 · WARN 0 · ERROR 8 | 11/12 OK · FAIL 1 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'sItemId' (InputField) — 후보 [sItemId]<br>smoke: Error: 조회조건 판정 불가(ERROR) 8: Approval, sItemId, Request No, Dept Name, Title, Change Reason, Reason Detail, Reject Reason<br>smoke: Error: 공통 기능 FAIL 1: Search Area 조회영역 토글 |
| SSP0005 | 2/3 ✗ | 3/4 OK · FAIL 0 · WARN 1 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | 0/1 ✗ | 1/1 | 1/1 | - | smoke: Error: As-is 병합 헤더 리터럴 노출 [Company, Division, SUM]<br>crud: Error: As-is 에 저장 SP 없음 → Save(F7) 비노출 |
| SSP0014 | 3/3 | 7/7 OK · FAIL 0 · WARN 0 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | 1/1 | 1/1 | 1/1 | - |  |
| SSP0015 | 0/3 ✗ | - | - | - | 0/1 ✗ | 0/1 ✗ | 2건 | smoke: Error: 조회조건 'Result Type' (CustomDropdown) — 후보 [Result Type]<br>smoke: TimeoutError: locator.click: Timeout 20000ms exceeded.<br>smoke: TimeoutError: locator.click: Timeout 20000ms exceeded.<br>auth: TimeoutError: locator.click: Timeout 20000ms exceeded. |
| SSP0020 | 1/3 ✗ | 1/5 OK · FAIL 1 · WARN 2 · ERROR 1 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'All' (Checkbox) — 후보 [All | ALL]<br>smoke: Error: 조회조건 동작 FAIL 1: Period |
| SSP0021 | 0/3 ✗ | 8/16 OK · FAIL 0 · WARN 4 · ERROR 4 | 11/13 OK · FAIL 1 · WARN 1 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Show SQL' (Checkbox) — 후보 [Show SQL]<br>smoke: Error: 조회조건 판정 불가(ERROR) 4: Show SQL, item.UserName, Box ID, Result Type<br>smoke: Error: 공통 기능 FAIL 1: Search Area 조회영역 토글 |
| SSP0023 | 0/3 ✗ | 8/15 OK · FAIL 0 · WARN 6 · ERROR 1 | 11/12 OK · FAIL 1 · WARN 0 · ERROR 0 | - | 1/1 | 0/1 ✗ | 2건 | smoke: Error: 조회조건 'Result Type' (CustomDropdown) — 후보 [Result Type]<br>smoke: Error: 조회조건 판정 불가(ERROR) 1: Result Type<br>smoke: Error: 공통 기능 FAIL 1: Search Area 조회영역 토글<br>authcrud: Error: [jinhuannj] 허용 계정 마커 행 저장  |
| SSP0024 | 3/3 | 3/5 OK · FAIL 0 · WARN 2 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - |  |
| SSP0025 | 3/3 | 3/5 OK · FAIL 0 · WARN 2 · ERROR 0 | 11/11 OK · FAIL 0 · WARN 0 · ERROR 0 | - | - | - | - |  |
| SSP0060 | 0/3 ✗ | 9/18 OK · FAIL 0 · WARN 5 · ERROR 4 | 11/13 OK · FAIL 1 · WARN 1 · ERROR 0 | - | 1/1 | 0/1 ✗ | 2건 | smoke: Error: 조회조건 'Sum(Week)' (Checkbox) — 후보 [Sum(Week)]<br>smoke: Error: 조회조건 판정 불가(ERROR) 4: Sum(Week), Total PSI, Box ID, Result Type<br>smoke: Error: 공통 기능 FAIL 1: Search Area 조회영역 토글<br>authcrud: Error: [jinhuannj] 대표 Division 40 가 Division 후보에 있음 |
| SSP0200 | 0/3 ✗ | 9/18 OK · FAIL 0 · WARN 2 · ERROR 7 | 10/11 OK · FAIL 1 · WARN 0 · ERROR 0 | - | - | - | - | smoke: Error: 조회조건 'Request No' (InputField) — 후보 [Request No]<br>smoke: Error: 조회조건 판정 불가(ERROR) 7: Single Process, Request No, Requestor, Dept Name, Approval, Item Id, Requestor<br>smoke: Error: 공통 기능 FAIL 1: Search Area 조회영역 토글 |

상세: `_summary.csv` (어노테이션: cond=조회조건별 동작(값 변경→조회·기준표 순서·Checkbox/Radio 디자인) · common=공통 기능(Search·F5·Sort·Filter·Condition·Reset·Excel·Columns·Search Area·Manual) · columns=컬럼 대사, dynamic=동적 기간 컬럼(정적 메타 밖 binding 수·타이틀 시트 호출), calls=call-proc, buttons=노출 버튼, division=DIV별 행수, crud=CRUD 사이클 결과(mode/saved/cleaned), authcrud=계정 권한 기대(btn_auth) vs 실측) · HTML: `html/index.html` · 실패 trace: `artifacts/`
