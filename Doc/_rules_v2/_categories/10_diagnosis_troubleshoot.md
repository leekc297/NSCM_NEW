# 카테고리 10 — 진단·트러블슈팅 / Diagnosis & Troubleshooting

> **연다: 언제?** "오류 난다/0행이다/안 보인다/멈춘다/클라우드만 실패한다" — 증상에서 출발할 때.
> **진단 대원칙**: 추측 금지 — BE 로그 실오류(`Caused by:`)/SYS_LOG/USER_SOURCE/AS-IS DB 실측으로 확정.

## 증상 → 룰 역인덱스
| 증상 | 먼저 볼 룰 |
|---|---|
| 오류 없는 **0행** / 동일 2행 중복 / 저장됐는데 미표시 | #100 get-zero-dup-invisible-diagnosis (PROC_M 순서/NVL 잔재/PIVOT 행분열/EXISTS) |
| **PLS-00103 "심볼 )"** 전 SP 공통 | PROC_M `COL_TP_CD='PROC_RESULT'` 비표준 (카테고리 08 필수 지식) |
| 업로드·저장 **무반응(hang)** | #107 sp-hang-runaway-loop-diagnosis (mutex/무한루프/pin) |
| **클라우드만 실패** (로컬 OK) | **#148 cloud-deploy-silent-failure-gates §2 진단 순서**(오류코드→단계 LOG_COUNT→BE `o_rc1`→FE) + #109 oracle-nls-implicit-conversion + 메모리 `feedback_cloud_be_build_out_of_sync_diagnosis` |
| 클라우드 **SP 는 정상인데 화면만 SQL ERROR / 0행** | #148 §1 5계보: 앱계정 GRANT·시노님 / 동적 SQL NLS / MNU_M 행 부재(권한 뷰 INNER JOIN) / 종속 PROGRAM_ID 메타 / FE 세대 |
| `-9994` / `InvocationTargetException:null` | #109 (래퍼 — SYS_LOG·BE 콘솔 실오류 확보) + #44 GRANT 누락 |
| **메뉴 안 보임** | #25 menu-not-displayed-debug (7단계) |
| 성공 토스트인데 **무동작** | 메모리 `feedback_success_toast_but_noop_api_wiring` (API_M 오배선 1순위) |
| 대량 조회/저장 ORA-06502/40478 | #106 oracle-bulk-clob-buffer |
| 조회 무한 재조회/스피너 안 멈춤 | #70 §filters 참조비교 (인라인 객체 금지) |
| 권한 없음 오류 | #91 SHT_NM 정합 + 메모리 `feedback_sht_nm_incomplete_migration_auth` |

## Hook 목록
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 148 | [cloud-deploy-silent-failure-gates](../hooks/cloud-deploy-silent-failure-gates.md) | ⭐⭐⭐ | 클라우드 이관 조용한-실패 5계보 + 6단 진단 순서 (추측 적용 ⛔) |
| 100 | [get-zero-dup-invisible-diagnosis](../hooks/get-zero-dup-invisible-diagnosis.md) | ⭐⭐⭐ | 조회 이상 4증상 진단 플레이북 + 오진 안티패턴 3 |
| 25 | [menu-not-displayed-debug](../hooks/menu-not-displayed-debug.md) | ⭐ | 메뉴 미표시 7단계 디버깅 |
| 107 | [sp-hang-runaway-loop-diagnosis](../hooks/sp-hang-runaway-loop-diagnosis.md) | ⭐⭐ | V$SESSION event 3분류 → mutex/폭주/락 |
| 109 | [oracle-nls-implicit-conversion](../hooks/oracle-nls-implicit-conversion.md) | ⭐⭐ | 세션 NLS 의존 암묵변환 — 명시 마스크 + 동시 배포 |
| 12 | [db-error-asis-cross-check](../hooks/db-error-asis-cross-check.md) | ⭐ | DB 오류/행수 불일치 = AS-IS MSSQL 직접 cross-check (.env.asis) |
| 30 | [oracle-db-workflow](../hooks/oracle-db-workflow.md) §3 | ⭐⭐ | 증상→원인 매핑표 (DB 계열 공통 진입) |
| 43 | [runtime-error-prevention](../hooks/runtime-error-prevention.md) | ⭐ | FE 기본 오류 사전 차단 |

## Cross-ref
- 룰 v1: `_dev_rules/21_TROUBLESHOOTING.md`(Oracle/DBeaver/Wijmo/PowerShell) · Oracle 직결 도구: 룰 32(ora.py/SQLcl)
- 메모리 진단 계보: `feedback_invocationtargetexception_null_hides_real_error` / `feedback_be_systemlog_aspect_double_execution` / `feedback_session_groupid_ghost_field` / `feedback_asis_db_direct_check`
