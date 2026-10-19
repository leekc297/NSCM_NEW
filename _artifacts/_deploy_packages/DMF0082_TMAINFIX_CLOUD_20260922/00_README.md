# DMF0082 — P_PR_DM_PLN_CFM_TO_MKT_FCST 값 미전달 정정 + standalone 삭제 (클라우드 이관)

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0082_TMAINFIX_CLOUD_20260922` |
| 대상 화면 | **DMF0082 — FCST & PRICE MGMT** (저장 → 40 사업부 MKT FCST / Sales Price 동기화) |
| 범위 | **DB 전용** (FE / BE 변경 없음) |
| 사내 적용 | **완료 · 검증 PASS** (222.110.191.243:2521/ZIOUI1 / SCM_MGR, 2026-09-22) |
| 클라우드 | **미적용** |
| 사내 원본 스탬프 | `PKG_DMF0082` BODY USER_SOURCE 재추출 — LAST_DDL 2026-09-22 10:52:58 (SOURCE-FRESH, 적용본과 EQUAL) |
| 선행 패키지 | `DMF0082_XLSFORM_ASIS_CLOUD_20260921` (클라우드 09-21 18:56 적용분) — **이 패키지는 그 위에 올린다** |

---

## 1. 결함

1. `P_DMF0082_SAVE_MAIN_DATA` 는 저장 행을 **`GT_PRDM1_T_MAIN`** 에 적재하는데, 호출되는 `P_PR_DM_PLN_CFM_TO_MKT_FCST` 는
   **`GT_PRDM_T_MAIN`**(무 '1') 을 읽었다. DB 전체에서 `GT_PRDM_T_MAIN` 에 적재하는 객체는 **0건** →
   40 사업부 CFM → `DM_PLN_MKT_FCST` / `SCM_MST_FUTURE_PRICE` 전파, BALANCE 재생성, Sales Plan 금액 재계산이 **항상 no-op**.
2. PR 의 VMI 메저 리터럴이 `'VMI_IN_REQ'` 인데 저장값은 **`'VMI_In_Req'`** (사내 DM_PLN_MKT_FCST 40 = 18,619건, 대문자 0건).
   AS-IS MSSQL 은 대소문자 무시 collation 이라 매칭됐으나 Oracle 은 구분 → GTT 만 고치면 VMI 행은 계속 누락.

## 2. standalone 삭제 근거 — 호출처 전수 조사

> 기준(사용자 확정 2026-09-22): **다른 곳에서 호출하면 standalone 유지, 호출처가 없으면 삭제하고 PKG_DMF0082 로 합친다.**
> 단독 배치 JOB 으로 실행되는 `PR_` SP 는 standalone 으로 둔다.

| 조사 축 | 결과 |
|---|---|
| AS-IS DB `sys.sql_modules` (LGCE_SCMDEV) | 실제 `EXEC` = **`DMF0082_SAVE_MAIN_DATA` 1곳뿐**. `PR_DM_PLN_CFM_TO_MKT_FCST_ALL` 은 이름 일부 일치일 뿐 호출 없음, `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE`(+`_20250730`/`_20260508`) 는 주석 1줄 |
| AS-IS SQL Agent JOB (msdb) | 3개 JOB 모두 **`PR_DM_PLN_CFM_TO_MKT_FCST_ALL`** 을 호출 (별개 배치 SP — **standalone 유지 대상, 이번 변경 무관**) |
| AS-IS C# 소스 (`GSCM`) | `DMF0082_FcstNPrice_Mgmt.cs:715` 주석 1줄 ("저장할 때 실행되는 EXEC PR_DM_PLN_CFM_TO_MKT_FCST") — 직접 호출 없음 |
| TO-BE 사내 DB | ALL_DEPENDENCIES 0 / ALL_SOURCE = BALANCE_CREATE 주석 1건 / SCHEDULER JOB 0 (JOB 3종은 `_ALL`) / `SCM_ADM_PROC_M`·`SCM_ADM_API_M` 0 |
| TO-BE 소스 (nscm-be / nscm-fe) | 0 |

⇒ 이 PR 은 **단독 배치가 아니라 DMF0082 저장의 하위 루틴**이다. 2026-09-15 UIPKG 로 `PKG_DMF0082.P_PR_DM_PLN_CFM_TO_MKT_FCST` 에
이미 취합됐고, 저장 SP 도 PKG 내부판을 호출한다 → standalone 은 **삭제 대상**.

---

## 3. 작업 ↔ 파일 대조표 (적용 순서)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — 클라우드 선판정 (READ-ONLY)
2. [A_DB/01_PKG_DMF0082_BODY.sql](A_DB/01_PKG_DMF0082_BODY.sql) — `PKG_DMF0082` BODY 교체 (CREATE OR REPLACE) · 약 895KB
   - 복사 범위: 15번째 줄 `CREATE OR REPLACE PACKAGE BODY         "PKG_DMF0082" IS` ~ 마지막 `END PKG_DMF0082;` + `/` (1~14줄은 헤더 주석)
3. [A_DB/02_DROP_STANDALONE_PR.sql](A_DB/02_DROP_STANDALONE_PR.sql) — standalone PR + 가리키는 시노님 DROP (멱등)
4. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — 적용 후 검증 (값 단언 + 세션 GTT dry-run, ROLLBACK)

롤백 전용 (평소 실행 안 함):
- [A_DB/99_ROLLBACK_PKG_DMF0082_BODY.sql](A_DB/99_ROLLBACK_PKG_DMF0082_BODY.sql) — BODY 를 이번 변경 직전으로
- [A_DB/99_ROLLBACK_STANDALONE_PR.sql](A_DB/99_ROLLBACK_STANDALONE_PR.sql) — standalone 본문 + GRANT + SYNONYM 복원

### 01 에 포함된 변경 (마커 `[E20260922-TMAINFIX]` 10줄)

| SP | 변경 |
|---|---|
| `P_PR_DM_PLN_CFM_TO_MKT_FCST` | `GT_PRDM_T_MAIN` → `GT_PRDM1_T_MAIN` **5곳** (SELECT 4 + TRUNCATE 1) |
| 同 | `'VMI_IN_REQ'` → `'VMI_In_Req'` **4곳** (TEMP 적재 / DM_PLN_MKT_FCST DELETE / SEND_TARGET / RESULTS) |
| `P_DMF0082_SAVE_MAIN_DATA` | PR 호출부 주석 2줄 ("잠재 이슈 미수정" → 해소) — 로직 무변경 |

- 그 외 SP 는 **클라우드 09-21 적용본과 동일** — `DMF0082_XLSFORM_ASIS_CLOUD_20260921/A_DB/05` 와 사내 적용 직전 원문을 대조해
  **헤더 주석 외 차이 0** 확인.
- SPEC / PROC_M / API_M / BTN_MPG **무변경**.
- GTT 신설 없음 (`GT_PRDM1_T_MAIN` 은 기존 SAVE 가 이미 사용 중 — PRECHECK [B] 로 존재·컬럼 동일성 확인).

---

## 4. 멱등성 / 비파괴

| 스크립트 | 재실행 | 방식 |
|---|---|---|
| 01 | O | `CREATE OR REPLACE` |
| 02 | O | 시노님·프로시저가 없으면 `SKIP` 출력 (ORA-01434/-04043 흡수). 사내에서 재실행 → SKIP 2건 실측 |
| 90 | O | 조회 + 세션 GTT 삽입 후 `ROLLBACK` (원장 무변경) |

- 데이터 DML **0건** (메타·원장 변경 없음). 사내 전값 WHERE 없음.
- 02 순서 = **시노님 먼저, 프로시저 나중** — 프로시저를 먼저 지우면 `ALL_SYNONYMS` 에서 대상 시노님이 보이지 않게 된다(사내 실측).

---

## 5. 적용 중단 조건 (PRECHECK 판정)

| PRECHECK | 정상 | 불일치 시 |
|---|---|---|
| **[A]** 세대 | XLSFORMASIS ≥ 4, TMAINFIX = 0, OLD_GTT_REF = 5 | XLSFORMASIS = 0 → **중단** (선행 09-21 패키지 미적용 — 그것부터). TMAINFIX = 10 → 이미 적용됨 |
| **[B]** GTT | 6개 GTT 존재, 28 컬럼 전부 SAME | `GT_PRDM1_T_MAIN` 없음 또는 DIFF 행 → **중단** |
| **[C]** 하위 호출 객체 | 3개 VALID | MISSING/INVALID → **중단** (이제 실제로 실행됨) |
| **[D]** VMI 표기 | `VMI_In_Req` 만 존재 | 대문자 `VMI_IN_REQ` 행 존재 → **중단**, 사용자 확인 |
| **[E]** standalone | E1 ≤ 1행, E2 0, E3 = BALANCE_CREATE 주석 1건, E4 0, E5 0 | E2/E4/E5 ≠ 0 또는 E3 에 실제 호출 → **02 만 보류** (01 은 진행 가능) |
| **[E6]** 시노님/권한 | (캡처) | 99 롤백의 GRANT/SYNONYM 과 다르면 99 를 클라우드 값으로 수정해 보관 |
| **[F]** 채번 | 신규 0 | — |

---

## 6. MSG / LBL / MNU / BTN 4분류

| 분류 | 신규 | 비고 |
|---|---|---|
| MSG | 0 | — |
| LBL | 0 | — |
| MNU | 0 | — |
| BTN | 0 | 배선 무변경 |

---

## 7. 롤백

1. `99_ROLLBACK_PKG_DMF0082_BODY.sql` 실행 (BODY = 클라우드 09-21 적용본과 동일 로직).
2. standalone 이 필요하면 `99_ROLLBACK_STANDALONE_PR.sql` 실행 (PRECHECK [E6] 값과 GRANT/SYNONYM 대조 후).
   - 1 과 2 는 독립이다 (PKG 는 standalone 을 참조하지 않음).

---

## 8. 사내 실측 검증 결과 (이 패키지가 재현해야 할 값)

| 게이트 | 사내 실측 |
|---|---|
| V1 PKG 상태 | PACKAGE / PACKAGE BODY **VALID / PASS** |
| V2 컴파일 에러 | **0** |
| V3 마커·잔존 | TMAINFIX=10 / OLD_GTT=0 / OLD_VMI=0 / NEW_GTT_IN_PR=5 / NEW_VMI_IN_PR=4 → **PASS** |
| V4 standalone | **0행** (재DROP 시 ORA-01434 — 시노님 부재 확인) |
| V5 INVALID | **0행** |
| V6 dry-run | GT1_LOADED=45 / PR_PICK=45 / VMI_MOCK=5 / VMI_NEW=5 / VMI_OLD=0 → **PASS** |
| 수정 전 대비 | PR 추출 건수 **0 → 40**, SEND_TARGET **0 → 20**, VMI 모의 **0 → 5** |

---

## 9. ⚠️ 운영 영향 / 후속

- 이제 40 사업부 **저장 시 PR 이 실제로 동작**한다: `DM_PLN_MKT_FCST` DELETE/INSERT → `SCM_MST_FUTURE_PRICE` DELETE/INSERT
  → `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE('40')` → `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE`.
  저장 소요시간 증가 가능 — **사내 화면 E2E 저장 테스트는 아직 미실행.**
- 이슈 후보 (미수정·범위 밖): `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` L2079 에도 `'VMI_IN_REQ'`,`'AS_IN_REQ'` 대문자 리터럴 존재.
- `PR_DM_PLN_CFM_TO_MKT_FCST_ALL` (배치 JOB 3종이 호출) 은 **standalone 유지** — 이번 변경 무관.
