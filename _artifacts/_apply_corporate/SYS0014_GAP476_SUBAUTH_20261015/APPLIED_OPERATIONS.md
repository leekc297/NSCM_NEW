# GAP476 SYS0014 사업부 권한 삭제 시 하위 권한 동반 삭제 — 사내 ZIOUI1 적용 기록 (2026-10-15)

- DB: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost) · 계정 SCM_MGR
- AS-IS 대조: LGCE_SCMDEV `UP_FX_DeleteUserGroupAuthExtention` 직접 조회 (`IF @AuthType='D'` → PrntCode=@Code 행 삭제) + `GroupUserInfo.cs` L579~582(AuthType D · PrntCode '')·L658~660(P · PrntCode=division)
- 선행: GAP473(같은 SP, 권한 요청 동반 삭제) 21:18:18 적용본 위에 작업

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 21:26:10 | PKG_SYS0014 BODY 최신 원문 조회·백업 (LAST_DDL 21:18:18) | `apply_gap476.py fetch` → `PKG_SYS0014_BODY.ASIS.sql` / `.TOBE.sql` | +17줄 (삽입만) |
| 2 | 21:26:11 | 적용 전 재현 E2E (시험 키 `ZZ_GAP476_T1`, 끝나고 삭제) | `e2e_BEFORE.out.txt` | FAIL = 하위 권한 P ZZP81 잔존 재현 |
| 3 | 21:26:31 | 적용 (FRESH-GATE 통과) | `apply.out.txt` | VALID · 오류 0 · 의존 INVALID 0 · DB==적용본 |
| 4 | 21:26:32~34 | 적용 후 E2E + GAP473 회귀 | `e2e_AFTER.out.txt` · `e2e_GAP473_regress.out.txt` | PASS · PASS · 대조군 불변 |
| 5 | 21:29:27~30 | 클라우드 패키지 리허설 99→00→10→10→90→99→99→10→90 | `_deploy_packages/SYS0014_GAP476_SUBAUTH_CLOUD_20261015/_rehearsal_out/` | 전부 기대대로 · 최종 DB==적용본 (LAST_DDL 21:29:30) |
| 6 | 21:29:55 | 리허설 후 E2E + GAP473 회귀 | `e2e_AFTER_REHEARSAL.out.txt` | PASS · PASS · 시험 행 0 |

현재 상태 = 적용 (GAP473 + GAP476). 원복 = `python apply_gap476.py rollback` 또는 패키지 `A_DB/99_ROLLBACK_GAP476_PATCH.sql`.
