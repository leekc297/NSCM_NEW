# GAP358 DMF0049 GDW 중복 키 검사 — 사내 ZIOUI1 적용 기록 (2026-10-15)

- DB: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost) · 계정 SCM_MGR
- 기준 원문: 착수 시 ALL_SOURCE 재조회 18:11:19 · PKG_DMF0049 BODY LAST_DDL 2026-10-14 09:22:10 VALID (1,302줄) → `PKG_DMF0049_BODY.ASIS_20261015_183625.sql`
- AS-IS 대조: LGCE_SCMDEV(LESDFPSTO1C01) `DMF0049_SAVE_SALES_ETC_REPORT_C`(modify 2026-02-05) L762~818 직접 조회 → `_asis_DMF0049_SAVE_SALES_ETC_REPORT_C.sql`

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 18:35 | 수정 전 검증 | `test_dupchk.py` → `test_BEFORE.out.txt` | 커버리지 158/13,287 · 빈 키 중복 0(누락) |
| 2 | 18:36:26 | PKG_DMF0049 BODY 패치(FRESH-GATE 통과, 13줄 치환) | `apply_corp.py apply` → `apply.out.txt` / 적용본 `PKG_DMF0049_BODY.TOBE_20261015_183625.sql` | VALID · 오류 0 · 의존 INVALID 0 |
| 3 | 18:36 | 수정 후 검증 | `test_AFTER.out.txt` | 커버리지 13,287/13,287 · 빈 키 중복 1(탐지) · 대조 1 · 비중복 0 |
| 4 | 18:39~18:40:33 | 클라우드 패키지 리허설(99/10 반복) | `_deploy_packages/DMF0049_GAP358_GDWDUPNVL_CLOUD_20261015/_rehearsal_out/` | 최종 적용 상태 · md5 적용본 `e0b6f145…` 일치 · 원복 시 수정 전 `3b7fa217…` 일치 |

원복: `python apply_corp.py rollback` 또는 패키지 `A_DB/99_ROLLBACK_GAP358_PATCH.sql`.
