# DMF0082 81 저장 후속처리 보완 `[E20260930-DMF0082-81SP]` — 사내 ZIOUI1 실행 작업 대조표

| 시각 (2026-09-30) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 12:07:37 | SCM_MGR | **공용 SP 81 분기 추가** (FRESH-GATE 통과 · VALID · 오류 0) | `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE` | [01_SALES_PLAN_SYNC_SP_81.sql](01_SALES_PLAN_SYNC_SP_81.sql) (`apply_81salesplan.py apply`) |
| 12:07:37 | SCM_MGR | **PKG BODY SAVE ■9 81 ELSE 분기** (VALID · 오류 0 · 참조 객체 INVALID 0) | `PKG_DMF0082` BODY | [02_PKG_DMF0082_BODY_81POST.sql](02_PKG_DMF0082_BODY_81POST.sql) |
| 12:12~12:18 | SCM_MGR | E2E 3회 — 81 SCM_FCST 1셀 저장('M') → 검증 → 'D' 저장 → 테스트 Sales Plan SCM_FCST 1행·`DM_PLN_MKT_FCST_H` 이력 2행 삭제 | 81 / A19VO6001 / Volvo AS_WA_SE_GOT / AMVCC519H-A1R000 / E / AS / FCA / WA00-P | `_diagnostics/DMF0082_CLOUD_PERFCHK_20260930/e02_81_save_e2e.py` (출력 `e02_81_save_e2e_out*.txt`) |

- 적용 전 원문 백업: [00_BACKUP_SALES_PLAN_SYNC_SP.sql](00_BACKUP_SALES_PLAN_SYNC_SP.sql) (LAST_DDL 2026-09-02 17:30:25) · [00_BACKUP_PKG_DMF0082_BODY.sql](00_BACKUP_PKG_DMF0082_BODY.sql) (LAST_DDL 2026-09-30 10:18:48 = CLOUDPERF 적용본)
- 원복: [99_ROLLBACK_SALES_PLAN_SYNC_SP.sql](99_ROLLBACK_SALES_PLAN_SYNC_SP.sql) · [99_ROLLBACK_PKG_DMF0082_BODY.sql](99_ROLLBACK_PKG_DMF0082_BODY.sql)
- ⚠ E2E 1회차에서 테스트 키의 BALANCE·RTF 원장 576값이 `BALANCE_CREATE('81','CALL')` 로 재계산되어 **남아 있다**(정리 대상 아님 — 새로 연결한 정상 동작의 결과, 2회차부터 변화 0).
- 삽입 분기 원문: [_branch_A_81.sql](_branch_A_81.sql) · [_branch_B_81.sql](_branch_B_81.sql) — 빌더가 "기존 줄 1바이트 불변" assert
- 클라우드 패키지: [`_deploy_packages/DMF0082_81SALESPLAN_CLOUD_20260930/`](../../_deploy_packages/DMF0082_81SALESPLAN_CLOUD_20260930/00_README.md)
