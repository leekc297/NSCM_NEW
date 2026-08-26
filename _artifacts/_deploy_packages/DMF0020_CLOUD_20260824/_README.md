# DMF0020 Sales Future Price — 클라우드 이관 패키지 (2026-08-24)

> 사내 적용·실측 완료 / **클라우드 미적용**

---

## 0. 먼저 — FE 없이 DB 만 올려도 되나?

**이번 패키지의 정정분은 DB + 메타만으로 동작합니다.** 이번 작업에서 FE 는 한 줄도 고치지 않았고,
배선이 의존하는 FE 파일 3개는 사내 git HEAD 와 동일합니다.

| FE 파일 | 사내 HEAD 대비 | 이 패키지가 요구하는 것 |
|---|---|---|
| `components/modals/PriceBatchInputModal.tsx` | 변경 없음 | `data?.o_rc1` 읽기 · 16키 SAVE 페이로드 · `bucketType='W'` |
| `components/modals/SalesPriceRangeModal.tsx` | 변경 없음 | `/{MENU}/priceBatch/SAVE/call-proc` 호출 |
| `sales-future-price.constants.ts` | 변경 없음 | `SHEETS.PRICE_BATCH = 'priceBatch'` |

### ⚠ 그래도 확인이 필요한 2가지

**① 같은 화면 폴더의 다른 5개 파일이 사내에서 수정된 상태입니다** — 이번 세션 것이 아니라 이전 작업분.
DB 만 올리면 이번 정정은 동작하지만 **화면 자체는 구버전**입니다("전체 적용"은 아님).

```
SalesFuturePrice.tsx                        24줄
components/SalesFuturePriceForm.tsx         46줄
components/SalesFuturePriceGrid.tsx         60줄
modals/SalesPriceRangeModal.module.scss      5줄
modals/SalesPriceVersionModal.module.scss    6줄
```

**② 클라우드 FE 가 사내 HEAD 와 같은지는 확인되지 않았습니다.** 클라우드가 공통소스보다
뒤처져 있던 전력이 있으므로 추정하지 말고 실제 대조할 것 —
`_artifacts/_tools/cloud_gap_check.mjs` 로 위 8개 파일만 SAME/STALE/MISSING 판정하면 됩니다.

**결론**: 이번 정정(조회 배선·저장 결함·성능)만 필요하면 **DB 만으로 충분**.
화면까지 최신으로 맞추려면 위 5개 파일을 함께 올려야 합니다.

---

## 1. 적용 순서

| # | 파일 | 내용 | 비고 |
|---|---|---|---|
| 1 | `A_DB/00_GTT_DDL.sql` | GTT 42종 자급 DDL + 인덱스 + `SCMP_APP` 권한 | 멱등(ORA-955 스킵). **PKG 보다 먼저** |
| 2 | `A_DB/01_PKG_DMF0020_SPEC.sql` | PACKAGE SPEC (293줄) | |
| 3 | `A_DB/02_PKG_DMF0020_BODY.sql` | PACKAGE BODY (8,750줄) | 정정 마커 12종 포함 |
| 4 | `A_DB/00B_GTT_STATS.sql` | 토큰·권한 GTT 대표 통계 고정 | PKG **뒤에**. 되돌리기 블록 파일 안에 있음 |
| 5 | `A_DB/10_SHEET_COLUMNS.sql` | 컬럼 메타 77행 | DELETE 후 재적재 |
| 6 | `A_DB/11_SHEET_MEASURE.sql` | 메저 메타 4행 | |
| 7 | `A_DB/12_EXCEL_COLUMNS.sql` | Excel 컬럼 1행 | |
| 8 | `A_DB/20_WIRING_AUTH.sql` | API_M / PROC_M / BTN_MPG / MNU_M / PROGRAM / 권한 2축 | MERGE(멱등) |
| 9 | `A_DB/21_LOOKUP.sql` | LOOKUP 12행 | MERGE |
| 10 | `A_DB/30_MSG_LBL_MNU.sql` | MSG 20행 | INSERT-only(기존 문구 안 덮음) |
| 11 | `A_DB/90_VERIFY.sql` | 검증 — **V1~V7 전부 PASS 여야 완료** | |

---

## 2. 이번에 정정한 것 (사내 실측 근거 포함)

### 2.1 기능 결함 — 저장이 조용히 안 되던 문제 ⭐ 가장 중요

| 마커 | 증상 | 원인 |
|---|---|---|
| **PROC_M 계약 누락** | Price Batch / Range Rate 저장 시 `PLS-00306` | `SCM_ADM_PROC_M` 에 `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` 계약이 **0건** → generic call-proc 이 `{call PROC}` 로 인자 없이 호출 |
| **`[E20260824-SAVEGTTINIT]`** | **세션당 첫 저장만 반영**, 2번째부터 `code=0` 인데 원장 무변경 | 저장 SP 가 스테이징 GTT(`GT_DMF0020_RESULTS_MST`/`_RESULTS`/`_EXCH`)를 초기화하지 않음. `ON COMMIT PRESERVE ROWS` 라 직전 호출 행이 남아 이후 호출이 건너뜀 |

`SAVEGTTINIT` 는 BE 커넥션 풀(10) 때문에 화면에서 "가끔 저장됨"으로 보여 재현이 어려운 형태였습니다.

**단일 세션 반복 실측**

| | 정정 전 | 정정 후 |
|---|---|---|
| #1 | 0.34s 원장 반영 **OK** | 0.59s OK |
| #2 | 0.01s ⛔ 미반영 | 0.28s OK |
| #3 | 0.01s ⛔ 미반영 | 0.28s OK |
| #4 | 0.01s ⛔ 미반영 | 0.28s OK |

원장(`SCM_MST_FUTURE_PRICE`) 실변경으로 검증했고, 다중 행(2·3행)과 HTTP 경로 5회 연속도 전부 PASS.
검증에 쓴 값은 모두 원상 복구했습니다.

### 2.2 배선

`priceBatch SEARCH` 를 메인 SP → **AS-IS 대응 팝업 SP** 로 전환했습니다.
FE 주석(L172)이 이미 이 SP 를 지목하고 있었고 배선만 빠져 있던 상태입니다.

```
DMF0020_priceBatch_SEARCH
  before : PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE               (메인 SP, 20 인자)
  after  : PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (18 인자)
```

`[E20260824-POPCUR]` — OUT 커서명을 `P_CUR` → `O_RC1` 로 정렬(FE 는 `data?.o_rc1` 을 읽음).

### 2.3 정확성 — 조회조건이 틀리게 걸리던 문제

| 마커 | 증상 | 원인 |
|---|---|---|
| **`[E20260824-POPDELIM]`** | Price Batch Input 에서 **Sales Site 다중선택 시 0행** | 화면은 `salesSite.join('^')` 로 보내는데 팝업 SP 는 `','` 로 split. `'A^B'` 가 1개 토큰으로 뭉쳐 매칭 0 |
| **`[E20260824-TOKENPAREN]`** | Item·Project·Owner 필터에 **엉뚱한 행이 섞여 나옴** | `WHERE PARAM_NM='p_x' AND A OR B` 가 `(PARAM_NM='p_x' AND A) OR B` 로 해석되어 B 가 공유 GTT 의 **다른 파라미터 토큰**까지 매칭 |

**POPDELIM 실측** — `TABLE(FN_String_Split)` 11곳 + 인라인 `REGEXP_SUBSTR` 12곳 = 23곳 정정.
Sales Site 뿐 아니라 Dept·End Customer·Project·Item·Owner·BizType 다중선택이 전부 같은 결함이었다.

```
정정 전  단일 A 1,062 / 단일 B 981 / A^B     0 ⛔
정정 후  단일 A 1,062 / 단일 B 981 / A^B 2,043 = |A∪B|  ✅
```

**TOKENPAREN 실측** — 술어 수준 직접 대조(토큰 GTT 에 `p_item_id` + `p_dept_id` 동시 적재):

```
종전(괄호 없음)   97 행   ← 부서 토큰이 Item 매칭에 새어 들어감
정정(괄호 있음)    1 행
정답(item 토큰만)  1 행   일치
```

⚠ **`ALL` 조회에서는 두 결함 모두 증상이 안 보인다**(OR 단락). 그래서 오래 안 잡혔다.
정정 후 `ALL` 조회 sha 는 불변(`4a0acd0634808c30` / 10,524행)임을 PRE·POST 대조로 확인했다.

`[E20260824-DIVYN]` — `GET_SPREAD_TITLE` / `GET_SPREAD_TITLE_SAVE_PRICE` 의 SELECT 컬럼절
`FN_GET_DIVISION_YN` 행별 호출을 토큰 완전일치 `INSTR` 로 대체(2곳).

### 2.4 성능

| 마커 | 내용 | 실측 |
|---|---|---|
| `[E20260824-OWNERSPLIT]` | `SI.OWNER` 를 행마다 `FN_String_Split` → 파이프라인 함수가 `VW_LAT_` LATERAL 로 변환되어 `MERGE JOIN OUTER + BUFFER SORT`, cost 5.6e10. 문자열 연산(`INSTR`/`SUBSTR`)으로 대체 | **div40 814초 → 2.5초** |
| `[E20260824-POPDEPT]` | `FN_GET_DEPT_LIST` 를 최종 SELECT 에서 행마다 호출(1회 조회에 38,652회 / 579,546 LIO) → `GT_DMF0020_DEPT_AUTH` 1회 적재 후 대조 | 최종 SELECT 2.87s → 0.72s |
| `[E20260824-LOCONLY]` | `SCM_MST_SHEET_MEASURE` 4건과 CROSS JOIN 으로 부풀렸으나 최종 SELECT 는 `MEASURE='LOC'` 만 소비 | `GT_DMF0020_OUTPUT` 419,037 → 139,679 (−67%)<br>`GT_DMF0020_SALES_SITE_MODEL` 154,284 → 38,571 (−75%) |

**최종 성능 (세션 재사용 = BE 커넥션풀 조건)**

```
div82  7.51s / 7.30s / 8.79s   sha 66acfa93fde6066d  (38,646행)
div40  2.50s / 2.59s           sha 44381123624bbc8b  (2,152행)
```

sha 가 반복·division 별로 고정 — **결과 불변**입니다. `LOCONLY` 는 PRE/POST sha 동일로 동등성을 확인했고,
피벗 컬럼 원천 `DISTINCT YYYYMMDD` 가 전체 57 = LOC 57 로 같아 컬럼 목록도 안 바뀝니다.

---

## 3. ⚠ 이번 범위 **밖** — 클라우드에서도 그대로 남는 결함

### 3.1 PROC_M 계약 누락 5건 (`90_VERIFY` V5 에서 FAIL 로 나옵니다 — 정상)

| 시트/버튼 | SP |
|---|---|
| exchange SAVE | `P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL` |
| main SPREAD_TITLE_DATE | `P_DMF0020_GET_SPREAD_TITLE_DATE` |
| salesPriceRange SAVE | `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` |
| salesPriceRange SEARCH | `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP` |
| salesPriceTemplate SEARCH | `P_DMF0020_GET_SALES_PRICE_TEMPLATE` |

배선(`API_M`)은 있는데 계약(`PROC_M`)만 없습니다. **사내에도 동일하게 남아 있으며** PKG 통합과 무관한
기존 누락입니다. 해당 버튼을 누르면 `PLS-00306` 이 납니다. 별도 정정 예정.

### 3.2 성능 정정 `OWNERNAME` 미적용 (의도적 보류)

`FN_GET_MULTI_OWNER_NAME` 을 `GT_DMF0020_OWNER_NAME` GTT 로 대체하는 정정은 **일부러 넣지 않았습니다.**
조인 술어에 GTT 를 투입하는 형태인데, 같은 패턴이 이번 세션에 계획 붕괴(1,044초)를 일으켰습니다.
Owner 필터를 쓸 때만 발동하는 성능 사안이라 정확성보다 우선순위가 낮습니다 — 별도 실측 후 적용 예정.
(GTT `GT_DMF0020_OWNER_NAME` 은 사내에 생성돼 있으나 참조 0 이라 `00_GTT_DDL.sql` 에서 자동 제외됨)

### 3.3 다른 화면의 동일 유형 결함 (DMF0020 범위 밖 — 참고용)

전 패키지 67개를 스캔해 GTT 초기화 누락을 찾은 결과(오탐 4건 제외):

| 패키지 | 프로시저 | GTT |
|---|---|---|
| `PKG_DMF0003` | `P_DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL` | `GT_DMF0_DM_MST_ITEM_SINGLE_V` |
| `PKG_DMF0042` | `P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV` | `GT_SDPBP_FUTURE_PRICE_TEMP1_2` |
| `PKG_DMF0043` | `P_DMF0043_GET_SALES_LIST_SPREAD_TITLE` | `GT_GSLS1_TEMP` |

DMF0020 과 같은 "세션당 첫 호출만 동작" 증상이 날 수 있습니다. 스캔 도구는 재사용 가능합니다.

---

## 4. 이관 제외 축 (의도적)

| 테이블 | 사유 |
|---|---|
| `SCM_MST_TITLESET_USER` (216행) | 사용자 개인화 데이터 |
| `SCM_ADM_USER_MNU_SRCH_COND_M` (7행) | 사용자별 조회조건 개인화(USER_ID 보유) |
| `SCM_ADM_LOOKUP_MASTER_DETAIL_H` (2행) | 이력 테이블 |
| `SCM_MST_SHEET_COLUMNS_0408` / `_260408` (각 77행) | 백업 테이블 — 서베이에만 표시, SQL 미포함 |
| `GT_DMF0020_OWNER_NAME` | 이번에 만들었으나 **참조 0** (해당 정정을 원복함) — DDL 에서 자동 제외 |

---

## 5. 적용 후 수기 확인 (`90_VERIFY` V8)

1. DMF0020 조회 (div 82 / CURRENT / WEEKLY / 20260701–20270630) → 7~9초
2. Price Batch Input Modal 조회 → 38,646행, 주차 컬럼 `W_yyyymmdd` 표시
3. **Price Batch / Range Rate 저장을 연속 2회 이상** → 매번 값이 반영되는지 확인
   (`SAVEGTTINIT` 정정 전에는 첫 저장만 반영되고 이후 조용히 무시됐습니다)
4. div 40 조회 → 2.5초 (정정 전 814초)

---

## 6. 알려진 운영 주의

- **`CREATE OR REPLACE PACKAGE BODY` 는 `library cache pin` 으로 무한 대기할 수 있습니다.**
  `DDL_LOCK_TIMEOUT` 은 TM 락 전용이라 걸리지 않습니다. 해당 PKG 를 실행 중인 세션이 있으면
  끝날 때까지 기다리거나 DBA 가 KILL 해야 합니다. 조회 세션 판별·KILL 문 생성 도구:
  `_artifacts/_tools/kill_blocking_session.sql`
  ⚠ `SCMP_APP` 은 **공용 계정**이라 전체 KILL 금지 — `SQL_ID`/`PLSQL_ENTRY_OBJECT_ID` 로 대상만 고를 것.
- 적용은 **사용자 조회가 없는 시간대**에 하는 것이 안전합니다.
