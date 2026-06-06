# Global Fix — NextSCM Pilot 변환기 사고 패턴 일괄 처치

## 배경

DMF0008_GET_SALES_SITE 진단 (2026-06-05) 중 NextSCM Pilot 변환기의 광범위 사고 패턴 발견. 210 audit SQL 실행 결과:

| 사고 패턴 | 규모 | 위험도 |
|---|---|---|
| TRUNCATE GTT (DDL 권한 부족) | **49 SP** | 🔴 HIGH |
| DROP TABLE (DDL 권한 + 객체 삭제) | 4 SP | 🔴 HIGH |
| generic '오류가 발생했습니다' EXCEPTION | **50+ SP** | 🟡 MEDIUM (디버깅 불가) |
| GTT INSERT/UPDATE/DELETE grant 누락 | **1,114 GTT** | 🔴 HIGH |
| DUMMY OPEN 메인 cursor 덮어쓰기 | 3 SP (SUMMARY 외 SUS) | 🟡 MEDIUM |

## 단계적 처치

### Stage 1 — 즉시 적용 (안전)

```sql
@_artifacts/_deploy_packages/_global_fix/010_All_GTT_DML_Grant_To_SCMD_APP.sql
```

모든 SCM_MGR GTT (1,114) 에 SCMD_APP 의 INSERT/UPDATE/DELETE 일괄 GRANT.
GTT 는 session 격리 → 다른 user 영향 0. DDL TRUNCATE/DROP 권한은 별도.

### Stage 2 — SP 별 발견 시 fix (점진적)

화면 작업 중 SP body 에 `EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_*'` 발견 시:
1. SP body recompile — TRUNCATE → DELETE 변환
2. EXCEPTION handler 의 `'오류가 발생했습니다.'` → SQLCODE/SQLERRM 포함

예시: `_artifacts/_deploy_packages/DMF0008/01_SP_BODY/030_DMF0008_GET_SALES_SITE_FIX_Truncate.sql`

### Stage 3 — 일괄 fix (사용자 결정 후, 위험 분석 필수)

49 SP TRUNCATE → DELETE 일괄 변환은 광범위 변경. 단계:
1. SP body 백업 (`DBMS_METADATA.GET_DDL`)
2. As-Is .cs / .sql 와 cross-check
3. 안전한 SP 부터 단계적 적용
4. 각 SP recompile 후 caller test
5. 사용자 사전 승인 필수

## 우선순위 — 화면별

| 화면 | 작업 우선순위 | SP body fix |
|---|---|---|
| DMF0008 (진행 중) | 1 | SUMMARY (020) + SALES_SITE (030) |
| DMF0082 | 후속 | 다수 TRUNCATE (29 lines × 7 SP) |
| DMF0035 / 0022 / 0074 / 0048 / 0042 / 0020 | 후속 | PKG 안 TRUNCATE 다수 |
| DMF0003 / 0008 | 후속 | PKG 안 7 lines |
| PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE | 후속 | 19 lines |
| PR_SCM_SIM_OPT_EE_PSI | 후속 | 81 lines (최대) |

## 메모리 cross-ref

- `feedback_sp_truncate_gtt_grant.md` — 사고 패턴 일반화
- `feedback_sp_cursor_reassignment_overwrite.md` — DUMMY OPEN 덮어쓰기 사고

## audit SQL

`_artifacts/_deploy_packages/DMF0008/05_VERIFY/210_Audit_Truncate_All_SPs.sql` — 새 화면 작업 시 재실행 가능
