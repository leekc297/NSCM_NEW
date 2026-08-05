# DBWORK_DMF0082_TUNING_20260731_1350 — DMF0082 조회 튜닝 클라우드 이관

> 목적: ① **division 81 hang 근본 조치**(파티션 프루닝) ② 기초 추출 −79~95%(항목1 접두필터) ③ MERGE TEMP spill 159MB 제거(LEADING 힌트)
> 원본: 사내 검증 완료 (2026-07-31, 결과 불변 div40=1,974 / div81=422 게이트 통과)
> 계정: **SCM_MGR** / 실행 도구: SQL*Plus 또는 SQL Developer

---

## 실행 순서

| 순서 | 파일 | 내용 | 중단 조건 |
|---|---|---|---|
| 0-1 | `00_PRECHECK/00A_BACKUP_CURRENT_BODY.sql` | 현행 BODY spool 백업 (원복용) | 백업 파일 미생성 시 진행 금지 |
| 0-2 | `00_PRECHECK/00B_GATE_ITEM1_AGGREGATE.sql` | ⭐⭐ **게이트** — 접두필터 집계보존 (40/81/82 **한 문장 동시** — 구버전처럼 3회 실행 불필요) | **불일치 > 0 이면 ⛔ 적용 중단, 회신** |
| 0-3 | `00_PRECHECK/00C_CLOUD_PROFILE.sql` | ⭐ **클라우드 문장별 프로파일 baseline** — div **40 → 82** 실행 (⛔ 81 은 적용 전 실행 금지: hang) | — |
| 1 | `01_DB_SP/PKG_DMF0082_BODY.sql` | BODY 전체 교체 (12,920라인 단일본) | — |
| 2 | `02_VERIFY/02_VERIFY_AFTER_APPLY.sql` | VALID/라인수 + UI 조회 + 계획 2종 확인 | INVALID 시 즉시 원복 |
| 2-b | `00_PRECHECK/00C_CLOUD_PROFILE.sql` (재실행) | 적용 후 동일 프로파일 — div **40 → 82 → 81** | — |
| 3 | `03_BE_CHANGE/README_BE_TEMP_UNDO.md` | (선택·BE 배포 시) TEMP_UNDO init | — |

> ⭐ **0-3/2-b 가 클라우드 튜닝의 본선입니다** — 사내 실측으로 만든 이번 패치가 클라우드에서 어떤 순위 변화를 만드는지, 그리고 **클라우드 고유의 잔여 병목**(데이터 6~22배·파티션 구조가 사내와 다름)이 어느 문장인지 이 전/후 프로파일 5회분(전 40·82 + 후 40·81·82)으로 확정합니다. 회신 주시면 다음 튜닝 표적을 클라우드 기준으로 잡습니다.

### 1 적용 시 주의
```sql
-- BE 사용 중이면 라이브러리 락 대비:
ALTER SESSION SET DDL_LOCK_TIMEOUT = 120;
@01_DB_SP/PKG_DMF0082_BODY.sql
```
가능하면 클라우드 BE 정지 후 적용 → 재기동.

## 포함된 변경 4건 (사내 라이브 그대로 — 라인 12,926)

| 변경 | 위치 | 사내 검증 |
|---|---|---|
| ⭐ **동적샘플링 세션 강제** `EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2'` | 조회 진입점 2곳(MAIN_DATA / MAIN_DATA_CURRENT) BEGIN 직후 (+6라인) | **클라우드 실증 2026-07-31**: 세션 =2 로 실행한 00E 가 div81 15초 내 완료 — 클라우드 세션 기본값 0(GTT 무통계 파국계획)이 UI 경로 hang 의 주범. Oracle 기본값 2 복원, 멱등(사내=이미 2), 트랜잭션 무관 |
| 파티션 프루닝 `CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM/TO` | 선언+설정+WHERE 4곳 (+22라인) | 결과 불변·계획 술어 3건 확인. **효과는 파티션 있는 클라우드에서만** |
| 항목1 접두필터 `SUBSTR(ITEM_ID,1,12) IN (site-item 접두)` | L517 (+10라인) | 적재 −79~94%·집계보존 MINUS 0건·결과 불변 |
| MERGE `LEADING(B) USE_HASH(A)` | L2710 (+1라인) | TEMP spill 159MB→0·결과 불변 |

> ⚠ 동적샘플링 설정은 **세션 파라미터라 그 커넥션(BE 풀)에 잔류**합니다 — 이후 그 커넥션을 쓰는 다른 화면에도 =2 가 적용되는데, 이는 Oracle 기본값 복원이라 **의도된 개선**입니다. 근본 조치로는 클라우드에 `ALTER SYSTEM SET optimizer_dynamic_sampling=2 SCOPE=BOTH;` (DBA) 를 권장 — 시스템 반영 시 SP 내 설정은 무해한 중복이 됩니다.

## 기대 효과 (클라우드)

- **division 81: 16분+ 미완료 → 15초급** (동적샘플링 + 프루닝 `PARTITION RANGE ALL` → `ITERATOR` — 00E 실측으로 선검증됨)
- 기초 적재 40=117,953→20,874 / 81=65,964→13,610 / 82=73,563→3,602 (00B 로 사전 확인된 축소율)
- MERGE TEMP spill 제거 (데이터 22배인 클라우드에서 spill 이 더 컸을 것)

## 원복

00A 로 백업한 `BACKUP_PKG_DMF0082_BODY_CLOUD_20260731.sql` 실행 → 라인수가 백업 시점 값으로 복귀 확인.

## 이 패키지에 없는 것 (해당 없음 확인)

- 인덱스 DDL 없음 — UNUSABLE 7본 복구는 **사내 전용**(클라우드는 원래 VALID), GTT 인덱스는 전수 계획 조사로 미생성 확정
- MSG/LBL/MNU/메타 없음 — SP 본문만 변경 (신규 채번 0)
- `optimizer_dynamic_sampling=2` 는 기적용분(2026-07-31 이전) 유지 전제
