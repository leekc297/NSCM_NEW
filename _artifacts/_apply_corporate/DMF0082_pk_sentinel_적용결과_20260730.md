# DMF0082 — PK 센티널 `'-'` 정규화 **적용 완료** (사내 DB, 2026-07-30)

> 요청: "TABLE 에는 필수 항목이지만 해당 DIVISION 에서 사용하지 않는 경우 `NVL(x,'-')` 처리 / 조회 시 SELECT 절 `NVL(x,'-') AS x`"
> 확정 사양: **대상 = PK × VARCHAR2 × NOT NULL** / **적용 division = 전체** / **V81-01 원문 유지**
> 근거 룰: hook #119 `oracle-null-sentinel-and-notnull-default` (센티널 `'-'` 통일)

## 1. 대상 확정 (3단 축소 — 사용자 지시 반영)

| 단계 | 기준 | 결과 |
|---|---|---:|
| ① | 영속 8테이블 NOT NULL 합집합 | 24 |
| ② | + `DATA_TYPE='VARCHAR2'` (NUMBER/DATE 제외) | 18 |
| ③ | + **PK 구성 컬럼만** | 16 |
| ④ | + DMF0082 가 실제 DML 하는 테이블만 (`_C` 3컬럼 제외) | **13** |

**최종 13컬럼**: `DIVISION_ID` `PROJECT_CODE` `SCM_SITE_ID` `ITEM_ID` `DOM_EXP` `FCST_TYPE` `INCOTERMS`
`MEASURE` `PLANT_SITE_ID` `YYYYMMDD` `END_CUSTOMER` `CELL_PROD_SITE_ID` `CURRENCY`

제외: `CREATED_BY`/`LAST_UPDATED_BY`(비PK) · NUMBER 3 · DATE 3 · 이력(_H) 테이블 2본(PK=`HISTORY_SEQ` NUMBER → 대상 0)

## 2. 적용 내역 — 7곳

### 【조회】 리터럴 NULL → `'-'` (5곳)
판정 근거: 영속 테이블 PK 는 NOT NULL → **읽어서 NULL 이 나올 수 없음**. 조회 NULL 원천 = 코드가 써넣는 리터럴 `NULL` 뿐 (실측 5곳).

| # | 위치 | 프로시저 | 변경 |
|---|---|---|---|
| G1 | L770 | `GET_MAIN_DATA` | `, NULL  AS PLANT_SITE_ID` → `, '-'  AS PLANT_SITE_ID` (폭 4자 유지 — 정렬 보존) |
| G2 | L6382 / L6469 / L6718 / L6805 | `GET_MAIN_DATA_CURRENT` | `, NULL AS CURRENCY` → `, '-' AS CURRENCY` |

원문 주석 전부 유지.

### 【저장】 정규화 UPDATE 2블록 삽입 (13컬럼 NVL, `WHERE ... IS NULL` 가드)

| 블록 | 배포 후 위치 | 적용 division | 배치 근거 |
|---|---|---|---|
| **N1** | **L11265~11287** (`IF v_is_81='N' THEN`[L11264] **내부**, Zone1 DELETE[L11288] 앞) | 40 | Zone1(#16 RMA→RTF)이 `GT_PRDM1_T_MAIN` 을 직접 읽어 40계 테이블에 DML. 이 구간은 40 전용 = V81-01 미실행이라 앞 배치 안전 |
| **N2** | **L12168~12190** (`V_GETDATE := SYSDATE;`[L12191] 앞) | **전체** | **V81-01(#19) 이후** → 검증은 raw 값으로 수행되어 원 동작 유지, 이후 Zone2 DML 7문장 전부 보호 |

**커버리지**
- 40: N1(Zone1) + N2(Zone2) ✅
- 81/82: Zone1 게이트 스킵 → V81-01 원본 검증 → N2(Zone2) ✅
- L11919/11933 KRW·USD 파생 INSERT = N2 앞 → 커버 ✅
- L12334 VMI 자동복제 = N2 뒤지만 정규화된 행 `A.*` 복사 + MEASURE 리터럴 → 안전 ✅

> 개별 DML NVL 방식이었다면 **67곳 + MERGE ON 4곳** = 71건. 정규화 2블록으로 동일 효과·최소 diff.

## 3. 배포·검증 이력

| 단계 | 결과 |
|---|---|
| BE(8080) 정지 | PID 16120 종료 확인 |
| 배포 | `DDL_LOCK_TIMEOUT=120` → `CREATE OR REPLACE PACKAGE BODY` |
| 컴파일 | **PACKAGE / PACKAGE BODY 모두 `VALID`, `USER_ERRORS 0`** (LAST_DDL 2026-07-30 21:19:21) |
| 라인수 | 12,841 → **12,887** (+46 = 블록 23행 × 2, 계산값 일치) |
| 삽입 검증 | `[PK-NN]` 블록 **2개** (L11265 / L12168) — 배치 위치 원문 대조 확인 |
| 잔존 검증 | 리터럴 `NULL AS (PLANT_SITE_ID\|CURRENCY)` = **0** |
| V81-01 보존 | `OR NVL(A.PLANT_SITE_ID, '-') = '-';` **L11636 에 원문 유지** (N1 삽입으로 +23 시프트) |
| 조회 회귀 | `GET_MAIN_DATA` 40=**1,324행** / 81=**385행** / 82=**105행** — 배포 전과 **완전 동일**, 3건 모두 `('0','SUCCESS')` |
| 저장 SP | **직접 실행 안 함** (hook #104 — 내부 DML·연쇄 SP 보유). 화면 E2E 위임 |
| BE 재기동 | **사용자 요청 시 진행** (2026-07-30 지시) |

## 4. 원복 절차

```
-- BE 정지 후
@BACKUP_PKG_DMF0082_body_pre_pk_sentinel_20260730.sql
```
> 이 백업은 **82→81 편입 적용 후 / PK 센티널 적용 전** 상태입니다.
> 82 편입까지 되돌리려면 `BACKUP_PKG_DMF0082_body_pre_div82_20260730.sql` 사용.

## 5. 잔여

- **BE 재기동** (요청 시)
- 화면 E2E: 40/81/82 저장 경로 실측 (V81-01 통과 후 정규화 → DML)
- **클라우드 미적용** — 이관 패키지 취합 시 본 BODY 동봉 (룰 22 / hook #14)
- ⚠️ **별건(기존 결함, 미수정)**: `GET_MAIN_DATA_CURRENT` 가 **전 division `ORA-00904 "SORT_KEY"`** 로 실패.
  `V_ORDERBY`(L7150 상당)가 `ORDER BY SORT_KEY` 를 조립하는데 동적 SQL 템플릿 SELECT 가 `SORT_KEY` 를 투영하지 않음.
  정상 동작하는 `GET_MAIN_DATA` 는 `999 AS SORT_KEY` 를 투영(2026-07-22 fix)—CURRENT 에 미반영.
  `SEARCH_CURRENT` 버튼 배선 SP 이므로 "Current" 조회 불가 상태. 본 작업과 무관(백업본에도 동일 존재).
- 📌 **후속 예정(사용자 통지 2026-07-30)**: 타 UI 사용 PKG/SP 에도 동일 PK 센티널 규약 확대 적용.
  재사용 절차 = ①대상 테이블 PK×VARCHAR2×NOT NULL 추출 SQL(§1) ②스테이징 GTT 정규화 지점 특정
  ③검증 로직과의 실행 순서 확인(V81-01 류) ④assert·라인수 대조 후 배포.
