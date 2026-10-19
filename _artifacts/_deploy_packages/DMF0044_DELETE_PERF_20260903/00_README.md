# DMF0044 — DELETE 후 SAVE 지연 정정 (사내 2초 / 클라우드 1분)

- 마커 : `E20260903-DELCOUNTDEAD`
- 대상 : `SCM_MGR.PKG_DMF0044` PACKAGE BODY
- 신고 : 1건 DELETE 후 저장에 클라우드 기준 약 1분 소요 (사내는 2초)

## 1. 원인 (실측)

`P_DMF0044_SAVE_SALES_PLAN_REPORT_C` (ETC 저장) 의 DELETE 구간 선두에 **사전 COUNT** 가 있었다.

```sql
-- DELETE COUNT 확인            <- 제거 대상 (구 BODY L4013~4021)
SELECT COUNT(DIVISION_ID)
INTO   n_delete_count
FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
WHERE  EXISTS ( SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST M
                 WHERE M.ACTIVE_FLAG = 'D' );      -- ⛔ 상관조건 0개
```

`EXISTS` 서브쿼리에 바깥(A) 과의 상관조건이 **하나도 없다**. 따라서 술어는 행 단위 판정이 아니라
"GTT 에 'D' 행이 있는가" 라는 **전역 참/거짓**이고, 참이면 원장 전체를 센다.

| 실측 (사내) | 값 |
|---|---|
| 실행계획 | `INDEX FAST FULL SCAN IDX_DM_PLN_SALES_PLAN_REPORT_C_VMD` card **4,634,152** cost **10,965** |
| V$SQL 실제 실행 (SQL_ID `3mqcuttpqc610`) | 1.18초 / buffer gets **39,470** — 1건 삭제인데 |
| 재현 계량 (GTT 에 'D' 1행 적재 후) | 0.13~0.24초, 결과 **4,634,152** = 원장 전건 |
| 실제 DELETE 술어(상관 정상) | **0.02초** |

**증상이 "DELETE 후 SAVE 만 느림"인 이유** — 이 스캔은 GTT 에 `ACTIVE_FLAG='D'` 행이 있을 때만
발생한다. 삭제 없는 일반 저장에서는 EXISTS 가 거짓이라 원장을 건드리지 않는다. 신고 증상과 정확히 일치.

**클라우드가 더 느린 이유** — 동일 문장이 원장 전건을 훑으므로 원장 크기·I/O 에 그대로 비례한다.
(2026-08-28 `E20260828-SARGSWEEP` 로 **아래 DELETE 문만** SARGable 정정했고, 그 위의 이 COUNT 는 남아 있었다.)

## 2. 정정 — 문장 제거 (동작 변화 0)

산출값 `n_delete_count` 는 **바로 아래 DELETE 직후 `n_delete_count := SQL%ROWCOUNT;` 로 즉시 덮어써진다.**
즉 이 COUNT 결과는 **어디에도 쓰이지 않는 죽은 계산**이었다. 같은 패키지의 다른 8개 프로시저는
처음부터 `SQL%ROWCOUNT` 만 쓴다(패턴 정합).

- 제거 : 구 BODY **L4013~4021 (9줄)** → 사유 주석 3줄로 대체
- BODY 라인수 : 10,250 → **10,244**
- 로그 문구(`delete_count: N`)는 `SQL%ROWCOUNT` 기준으로 **오히려 정확해진다**
  (기존 사전 COUNT 는 원장 전건수라 애초에 의미 없는 값이었다)

## 3. 적용 파일 — ⚠ 환경별 기준본이 다르다

사내와 클라우드의 `PKG_DMF0044` 는 **서로 다른 판**이다. 반드시 해당 환경 파일을 써야 한다.

| 환경 | 현재 판 (실측) | 적용 파일 |
|---|---|---|
| 사내 (OCGSCMD_P01) | 구판 — SAVE 인자 `VARCHAR2` 21/23, `SP_SPLIT_CARET`/`FN_CHK_QTY_DIGITS` 없음 | `01_PKG_DMF0044_BODY_DELCOUNT_FIX.sql` |
| 클라우드 | **CLOB 판** — W53 `DMF0044_SAVE_FIX_20260903` 의 05A/05B/06 배포됨 | **`02_PKG_DMF0044_BODY_DELCOUNT_FIX_CLOUD.sql`** |

- `01` = 사내 라이브 BODY(10,250줄) 기준 → 9줄 제거 → 10,244줄
- `02` = **클라우드 배포본 05B(10,481줄) 기준** → 같은 9줄(05B L4168~4176) 제거 → 10,475줄

⚠ **01 을 클라우드에 올리면 실패한다.** 클라우드 SPEC(05A)은 인자가 CLOB 인데 01 의 BODY 는
VARCHAR2 시그니처라 대응 구현이 없다고 판정된다 — 실제 발생:

```
45/15  PLS-00323: 부프로그램 또는 'P_DMF0044_SAVE_SALES_PLAN_REPORT_C' 커서는
       패키지 지정에 정의되고 패키지 본체에 나타나야합니다
48/15  PLS-00323: ... 'P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF' ...
```

SPEC 변경 없음. 인자·계약 변경 없음 → BE / FE / `SCM_ADM_PROC_M` 무변경(양쪽 공통).

## 4. 검증

**01 (사내용)** — 임시명 `PKG_DMF0044_E0903CHK` 선컴파일 오류 0건 → DROP → 사내 적용 후
BODY **VALID** / `ALL_ERRORS` 0 / 잔존 `COUNT(DIVISION_ID)` 0 / 마커 L4013 / 10,250→10,244줄.

**02 (클라우드용)** — 사내 라이브를 건드리지 않고 검증:
05A SPEC + 02 BODY 를 임시명 `PKG_DMF0044_E0903CLD` 로 함께 컴파일 →
**SPEC 오류 0 / BODY 오류 0 (PLS-00323 0건) / PACKAGE·PACKAGE BODY 모두 VALID** → DROP(잔여 0).
계보 지문 확인: `SP_SPLIT_CARET` O / `FN_CHK_QTY_DIGITS` O = 05B 후손임을 확인.

클라우드 적용 후 확인 : 1건 DELETE → SAVE 소요시간 재측정 (기대 = 일반 저장과 동등).

## 5. 상태

- 사내 : **적용 완료** (2026-09-03, `01` 로 적용)
- 클라우드 : 미적용 — **`02` 배포 필요** (`01` 로 시도 시 PLS-00323)

## 6. 별건 — 환경 간 판 분기

사내는 CLOB 판(W53 05A/05B/06)이 **미적용**이다. 실측: SAVE 인자 `VARCHAR2` 21/23,
`SCM_ADM_PROC_M` DATA_TP_CD 도 `VARCHAR`. 이 상태가 유지되면 앞으로도 전체본 생성 시마다
기준 혼동이 재발한다. 사내에도 05A/05B/06 을 적용해 판을 일치시킬지는 별도 결정 필요.
