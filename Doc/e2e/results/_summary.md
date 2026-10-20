# E2E 결과 — 2026-10-20 16:42

테스트 12 · PASS 10 · FAIL 2 · FLAKY 0 · SKIP 0

| 화면 | 스모크 | CRUD | 권한(계정×DIV) | 권한별 CRUD(계정) | 실패 요약 |
|---|---|---|---|---|---|
| SCP0096 | 1/1 | 1/1 | 2/2 | 2/2 |  |
| SCP0100 | 0/1 ✗ | 1/1 | 1/2 ✗ | 2/2 | smoke: Error: 조회조건 'Search Level' (RadioGroup)<br>auth: Error: [jaeuk.shin ADMIN/DM ADMIN/FP Planner/FP Viewer/GUEST/JV Planner/SCM PI Admin/SCM Viewer/SCP Planner/SCP Tester/S |

상세: `_summary.csv` (어노테이션: columns=컬럼 대사, dynamic=동적 기간 컬럼(정적 메타 밖 binding 수·타이틀 시트 호출), calls=call-proc, buttons=노출 버튼, division=DIV별 행수, crud=CRUD 사이클 결과(mode/saved/cleaned), authcrud=계정 권한 기대(btn_auth) vs 실측) · HTML: `html/index.html` · 실패 trace: `artifacts/`
