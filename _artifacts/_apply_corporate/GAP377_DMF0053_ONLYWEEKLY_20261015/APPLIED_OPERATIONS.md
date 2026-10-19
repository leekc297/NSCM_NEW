# GAP377 DMF0053 Only Weekly 주 합계 — 사내 ZIOUI1 적용 기록 (2026-10-15)

- DB: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost) · 계정 SCM_MGR
- 기준 원문: 착수 시 ALL_SOURCE 재조회 18:57:42 · PKG_DMF0053 BODY LAST_DDL 2026-10-15 15:59:03 VALID (1,176줄) → `PKG_DMF0053_BODY.ASIS_20261015_191127.sql`
- AS-IS 대조: LGCE_SCMDEV(LESDFPSTO1C01) 직접 조회 — `DMF0053_GET_SPREAD_TITLE`(modify 2023-08-23) `_asis_DMF0053_GET_SPREAD_TITLE.sql` · `DMF0053_GET_CUST_FCST_WATERFALL`(modify 2026-03-26) `_asis_DMF0053_GET_CUST_FCST_WATERFALL.sql` L568~586 / L1180~1216
- 재현 파라미터: SCM_COM_SQL_LOG 10-06 13:14 minyonglee1 ONLY_WEEKLY 호출의 FE 실전송값 형식 (ALL / '' 구분 그대로)

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 19:0x | 수정 전 재현 | `repro.py` → `before_81.out.txt` | 머리글 36칸 · Only Weekly W40 3,462 (Weekly 39,426+3,462) |
| 2 | 19:11:27 | PKG_DMF0053 BODY 패치(FRESH-GATE 통과, T1~T3 각 2 · G1~G2 각 1) | `apply_corp.py apply` → `apply.out.txt` / 적용본 `PKG_DMF0053_BODY.TOBE_20261015_191127.sql` | VALID · 오류 0 · 의존 INVALID 0 |
| 3 | 19:12~ | 수정 후 검증 | `after_81.out.txt` · `after_40.out.txt` · `after_81_md.out.txt` | 81 머리글 26칸·W40 42,888·총합 = Weekly 주 칸 합 · Weekly 전후 동일 · 40(2023) W13/26/39 = GAP AS-IS 값 · Monthly/Daily 정상 |
| 4 | 19:16~19:16:45 | 클라우드 패키지 리허설 | `_deploy_packages/DMF0053_GAP377_ONLYWEEKLY_CLOUD_20261015/_rehearsal_out/` | 최종 적용 상태 · md5 적용본 `6e4dda26…` · 원복 시 수정 전 `3d82eb6c…` 일치 |
| 5 | 19:17 | 최종 상태 재확인 | `final_81.out.txt` | 26칸 · W40 42,888 · W44 26,314 · W49 7,256 |

원복: `python apply_corp.py rollback` 또는 패키지 `A_DB/99_ROLLBACK_GAP377_PATCH.sql`.
