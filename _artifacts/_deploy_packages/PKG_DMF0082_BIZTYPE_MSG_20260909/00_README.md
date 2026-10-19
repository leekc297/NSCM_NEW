# PKG_DMF0082_BIZTYPE_MSG_20260909 — `[E20260608-000294]` Biz Type 오류 메시지 문구 변경

## 1. 무엇을 바꾸나

DMF0082(FCST&Price Mgmt) 저장 시 40 사업부 모델에 **Biz Type 이 없어 저장이 차단될 때** 뜨는 안내 문구를
AS-IS 와 동일하게 맞춘다. **문자열 1건 교체 — 로직·조인·대상표 변경 없음.**

| | 문구 |
|---|---|
| 변경 전 | `Model*: {ITEM_ID}는 BIZ_TYPE 이 없어서 저장을 할 수 없습니다.` |
| 변경 후 | `1. MDM에서 Biz Type을 입력하시기 바랍니다.`<br>`2. MDM에 Biz Type이 입력된 상태면 SCM_FP에 CSR 요청하시기 바랍니다.` (2줄, `CHR(10)` 연결) |

- 대상 : `SCM_MGR.PKG_DMF0082` (PACKAGE BODY) > `P_DMF0082_SAVE_MAIN_DATA`
- AS-IS 근거 : `dbo.DMF0082_SAVE_MAIN_DATA` **L1016** (LIVE) — DB 직접 조회
  (`165.244.95.223:1433/LGCE_SCMDEV`, `sys.sql_modules`, `modify_date` 2026-06-12 17:31:52)
- 요청 원문 : `[E20260608-000294]_FCST&PRICE MGMT UI Biz Type 오류 메시지 수정 요청` (2026.06.12, JSSBAE)

> AS-IS 와 동일하게 새 문구에는 **모델코드가 들어가지 않는다.** 어떤 모델인지 화면에 표시되지 않으므로
> 모델코드 병기가 필요하면 그건 AS-IS 와 다른 사양이며 별도 지시가 필요하다.

## 2. ⚠ 왜 전체본 덮어쓰기가 아닌가 (반드시 읽을 것)

사내 `PKG_DMF0082` BODY 는 전달받은 클라우드 본(`PKG_DMF0082_BODY_20260907.sql`, 15,107줄) 대비
**49 블록 / 약 337 라인 앞서 있다** (실측 diff). 예:

`[E20260907-DEFFLAG]` · `[E20260907-PERF1]` · `[E20260907-PERF2]` · `[E20260907-LIMITMEAS-DIV]` ·
`[hook#150 2026-09-06 AJS]` DEPT_ID 재설계 · `[E20260908-GETRANGE]` 52주 개방 ·
`[E20260908-ENDCUST]` · `[E20260908-XLSMONTH]` 월 토큰 전환 · `NUMBER(23,2) → NUMBER(30,10)` 등

⇒ **사내 전체본을 클라우드에 배포하면 이번 1건 외에 48 블록이 함께 넘어간다.**
이번 지시는 "**2번은 보류, 1번만 적용**" 이므로, 본 패키지는 전체본이 아니라
**현재 클라우드 본문을 읽어 해당 1줄만 치환하는 외과적 패치**로 구성했다.
클라우드 baseline 이 무엇이든 **이 변경만** 적용된다.

## 3. 구성

| 파일 | 용도 |
|---|---|
| `00_PRECHECK.sql` | (읽기 전용) 클라우드 현재 상태 확인 → `GO` / `SKIP` / `STOP` 판정 |
| `10_PATCH_BIZTYPE_MSG.sql` | **적용** — 본문 재조립 후 `CREATE OR REPLACE`. 가드 2종 내장 |
| `90_VERIFY.sql` | (읽기 전용) 적용 후 게이트 G1~G4 + 의존 객체 INVALID 연쇄 확인 |
| `99_ROLLBACK.sql` | 원복 — 신 문구 블록 제거 + 주석화된 원소스 복원 |
| `_ref/PKG_DMF0082_BODY_CLOUD20260907_BASELINE.sql` | 참고 — 전달받은 클라우드 본(무수정) |
| `_ref/PKG_DMF0082_BODY_CLOUD20260907_PATCHED.sql` | 참고 — 위 baseline 에 본 건만 반영한 전체본 (**diff 검토용, 배포용 아님**) |

`_ref` 전체본은 **리뷰/디프 확인용**이다. 클라우드가 2026-09-07 이후 변경됐다면 이 파일로 덮으면 그 변경이 사라진다.
배포는 `10_PATCH` 로만 한다.

## 4. 적용 절차

```sql
-- SCM_MGR 로 접속 (SQL*Plus 또는 SQLcl)
@00_PRECHECK.sql        -- 판정이 'GO — 10_PATCH 실행 가능' 인지 확인
@10_PATCH_BIZTYPE_MSG.sql
@90_VERIFY.sql          -- G1~G4 전부 PASS 확인
```

`00_PRECHECK` 판정별 행동:

| 판정 | 의미 | 행동 |
|---|---|---|
| `GO` | 구 문구 LIVE 1건 · 신 문구 0건 | `10_PATCH` 실행 |
| `SKIP` | 신 문구가 이미 존재 | 적용 불필요 — 종료 |
| `STOP` | 대상 라인 수가 1이 아님 | **실행 금지**, 담당자 확인 |

### 내장 가드 (10_PATCH)

| 가드 | 조건 | 실패 시 |
|---|---|---|
| G1 | 신 문구가 이미 있으면 중복 적용 차단 | `ORA-20002 ALREADY APPLIED` |
| G2 | 구 문구 LIVE 라인이 정확히 1건이 아니면 차단 | `ORA-20001 PRECHECK FAIL` |
| G3 | 재조립 중 실제 치환이 1건이 아니면 차단 | `ORA-20003 BUILD FAIL` |

`DDL_LOCK_TIMEOUT = 60` 을 세션에 설정한다. 패키지는 무상태(`[E20260901-STATELESS]`)라
재배포로 인한 `ORA-04068` 이 발생하지 않으므로 **BE 재기동 불요**.
DRY RUN 이 필요하면 스크립트 상단 `C_DRYRUN` 을 `TRUE` 로 바꿔 실행한다(생성만 하고 미적용).

## 5. 검증 게이트 (90_VERIFY)

| 게이트 | 기대 |
|---|---|
| G1 | `PKG_DMF0082` PACKAGE + BODY 둘 다 `VALID` (2건) |
| G2 | 신 문구 LIVE 라인 **1건** |
| G3 | 구 문구 LIVE 라인 **0건** (주석으로만 존재) |
| G4 | `USER_ERRORS` **0건** |
| 추가 | `PKG_DMF0082` 의존 객체 중 `INVALID` **0건** |

### 화면 확인 (권장)

40 사업부에서 `SCM_ITEM_M_SN.FORECAST_INFO_BIZ_TYPE` 이 없는 모델로 **신규행**을 추가해 저장 →
새 2줄 문구가 뜨는지 확인. (검증 실패 경로는 SP 내부에서 `ROLLBACK` 후 반환하므로 데이터 변경 없음 — 실측 확인)

## 6. 사내 적용 이력 (선행 완료)

| 항목 | 내용 |
|---|---|
| 적용 일시 | 2026-09-09 11:10:06 (`ZIOUI1`, `SCM_MGR`) |
| 결과 | PACKAGE BODY `VALID` · 컴파일 오류 0 · 의존 객체 INVALID 연쇄 0 |
| 백업 | `_artifacts/_backup/PKG_DMF0082_BODY_PRE_E20260608_20260909/PKG_DMF0082_BODY_BEFORE.sql` (15,262줄) |
| 런타임 검증 | `PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA` 직접 호출 → `('F', '1. MDM에서 Biz Type을 입력하시기 바랍니다.\n2. MDM에 Biz Type이 입력된 상태면 SCM_FP에 CSR 요청하시기 바랍니다.', 'Validation Check')` 반환 확인 후 `ROLLBACK` |

## 7. 스크립트 자체 검증 (배포 전 수행 완료)

임시 패키지(`PKG_ZZTEST_E20260608`)에 동일 패턴 라인을 만들어 **실제 실행**으로 확인했다(테스트 후 DROP, `PKG_DMF0082` 무영향).

| 검사 | 결과 |
|---|---|
| PATCH 적용 → 컴파일 | `VALID` · 치환 1건 |
| PATCH 후 실행값 | 새 2줄 문구 + `CHR(10)` 개행 정상 |
| G1 중복 적용 차단 | `ORA-20002` 차단 확인 |
| G2 대상 2건일 때 차단 | `ORA-20001` 차단 확인 |
| ROLLBACK 후 원문 | **바이트 단위 원본 복원 일치** · 실행값도 구 문구로 복귀 |

## 8. 범위 밖 (미포함)

- **`[E20260422-001123]` (Sales Price `ISNULL(QTY_PRICE,0)`) — 사용자 지시로 보류.**
  상세 = `Doc/_analysis/asis_delta_20260907/04_E20260422_DETAIL.md`
- MSG/LBL/MNU 메타 : 본 문구는 SP 내 하드코딩(AS-IS 동일)이라 `SCM_ADM_MSG_M` 등재 대상 아님 — 동봉분 없음
- FE / BE / GRANT / 시노님 / GTT·TYPE DDL : 변경 없음 — 동봉분 없음
