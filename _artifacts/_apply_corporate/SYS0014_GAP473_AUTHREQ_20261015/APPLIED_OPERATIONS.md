# GAP473 SYS0014 권한 요청 기록 동반 삭제 — 사내 ZIOUI1 적용 기록 (2026-10-15)

- DB: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost) · 계정 SCM_MGR
- AS-IS 대조: LGCE_SCMDEV `UP_FX_DeleteUserGroupInfo` / `UP_FX_DeleteUserGroupAuthExtention` / `UP_FX_DeleteGroupInfo` 직접 조회 + `GSCM/06.UIL/GSCM.SystemMgmt.UIL/GroupUserInfo.cs` L536·L579~582·L605
- 참고: 같은 날 14:36 `*_BAK20261015_SYS0014_1` 백업 4개 · GAP467(그룹 원장 데이터) 작업 존재 — PKG_SYS0014 는 그 작업이 건드리지 않음(LAST_DDL 10-09) · 무변경

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 21:11:43 | PKG_SYS0014 BODY 최신 원문 조회·백업 (LAST_DDL 2026-10-09 13:38:47) | `apply_gap473.py fetch` → `PKG_SYS0014_BODY.ASIS.sql` / `.TOBE.sql` | +29줄 (삽입만) |
| 2 | 21:13:05 | 적용 전 재현 E2E (시험 키 `ZZ_GAP473_T1`, 끝나고 삭제) | `e2e_gap473.py BEFORE` → `e2e_BEFORE.out.txt` | FAIL = 요청 기록 잔존 재현 |
| 3 | 21:13:24 | 적용 (FRESH-GATE 통과) | `apply_gap473.py apply` → `apply.out.txt` | VALID · 오류 0 · 의존 INVALID 0 · DB==적용본 |
| 4 | 21:13:25 | 적용 후 E2E | `e2e_AFTER.out.txt` | PASS · 대조군 행수 불변 |
| 5 | 21:18:15~18 | 클라우드 패키지 리허설 99→00→10→10→90→99→99→10→90 | `_deploy_packages/SYS0014_GAP473_AUTHREQ_CLOUD_20261015/_rehearsal_out/` | 전부 기대대로 · 최종 DB==적용본 (LAST_DDL 21:18:18) |
| 6 | 21:18:30 | 리허설 후 E2E | `e2e_AFTER_REHEARSAL.out.txt` | PASS · 대조군 불변 · 시험 행 0 |

현재 상태 = 적용. 원복 = `python apply_gap473.py rollback` 또는 패키지 `A_DB/99_ROLLBACK_GAP473_PATCH.sql`.
