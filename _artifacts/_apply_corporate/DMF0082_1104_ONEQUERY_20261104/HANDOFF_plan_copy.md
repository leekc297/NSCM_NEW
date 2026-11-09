# PKG_DMF0082_1104.P_DMF0082_GET_MAIN_DATA — STEP 축소(3문장) 재작성 계획

> (타 세션 ejene PC 계획 파일 `C:\Users\ejene\.claude\plans\pkg-dmf0082-1104-nested-liskov.md` 의 사본 · 2026-11-06 LG PC 수신 저장)

## Context

DMF0082(FCST & PRICE MGMT) 조회 SP `P_DMF0082_GET_MAIN_DATA`(BODY 8~5546행, 5,539줄)는 GTT 20여 개를 거치는 약 50개 STEP(DELETE/INSERT/MERGE/UPDATE)으로 결과를 만든다. 클라우드 QA 체감 10초대 이상(10-12 실측: 9메저 사용자 81 조회 31~35s), 사용자 목표는 3초. 지금까지의 튜닝(인덱스·통계·힌트·LATFIX·ONEREAD·RLXPRE·MFPERF)은 문장 단위 수정이었고, 이번에는 **구조 자체**를 바꾼다.

- 작업 대상: **PKG_DMF0082_1104** (2026-11-04 16:00 원본 복제, 동등 검증 완료). 원본 `PKG_DMF0082`는 건드리지 않는다.
- 2026-11-04 16:00 이후 원본이 바뀌면(타 작업자) 1104에 먼저 반영한 뒤 진행한다 (hook #152 FRESH-GATE).

### 사용자 결정 (2026-11-04)
| 항목 | 결정 |
|---|---|
| 동등성 | **현행과 행 단위 완전 동일** (아래 이상 5건도 그대로 재현, 수정은 별도 결정) |
| 목표 구조 | **3문장**: 준비 1 + 적재 1 + 출력(동적 SQL) 1 |
| 측정 기준 | k0101(메저 9: MKT_FCST,RTF_SYS_RP,CUST_FCST,AS_In_Req,AS_In_Plan,AS_Inv,KRW,USD,LOC) + minyonglee1(메저 7), 40/81/82 × Current, 기간 당월1일~+6개월 |
| 진행 순서 | **Current 경로 먼저 → 버전(MF/SF/SP·복수 버전) 경로** (사용자 변경 2026-11-04) |

### 원문 분석에서 확인된 이상 동작 5건 (재현 대상 · 수정 여부는 별도 결정)
1. MF×40 판가 arm(L2837)만 `END_CUSTOMER := PROJECT_CODE`, SF/SP×40(L3474/3596)은 `A.END_CUSTOMER`
2. MF_SP INSERT L4771 주 달력 비교식 좌우 뒤바뀜 → `GT_DMF0082_CAL_WEEK_END_DATE`·`CAL_MONTH_END_DATE` 결과 무영향(죽은 GTT 2개)
3. `p_item_id` 필터(L842)가 `MST_ITEM_SINGLE_V`를 줄여 T4 CELL_MODEL 닉네임 조회(L981)까지 제한
4. 분석 구간 내 모든 적재문이 `SENDER_CODE=''` → `p_sender_code≠ALL`이면 L4187 DELETE가 전 행 삭제
5. `T_LAST_DATA_SETUP_PRICE_C`(L1391)는 VERSION_NO 없이 8키 집계 → 복수 버전 시 값이 합쳐짐
   (+ `T_LAST_DATA_SETUP_PRICE`(비 _C)는 적재문 주석 처리로 빈 테이블 = 죽은 GTT)

---

## 1. 현행 STEP 인벤토리 → 패밀리 (분석 결과 요약 · 행 번호 = BODY 8행부터 센 main.sql 기준)

| 구간 | STEP 내용 | 축소 후 위치 |
|---|---|---|
| L241·301 | 세션 ALTER 2건 (TEMP_UNDO, dynamic_sampling=2) | **유지** (DML 아님) |
| L257~297 | PARAM_TOKEN 삭제 1 + 분해 INSERT 10 | **S0** 1 INSERT(UNION ALL 10) |
| L322·1229·5507 | PR_SCM_SYS_LOG_BATCH (autonomous 확인됨) | 유지 |
| L351~436 | TITLESET_USER 시드 INSERT 2 (COUNT=0 조건·영구 테이블) | 유지 (행위 보존) |
| L459~480 | C_BUCKET 루프 → V_PV_LIST/V_PV_COL_LIST/V_QTY_SUM CLOB | 유지 (문자열 생성) |
| L493~534 | T_VERSION 적재 + V_CUTOFF_FROM/TO | S2 CTE `ver` + 스칼라 2개 |
| L549~554 | T_WS_FCST (LOOKUP SALES_TYPE_CODE) | S2 CTE `ws` |
| L567~605 | 날짜 스칼라 V_FROM_YYYYMMDD / V_TO_RESULT (SYSDATE·달력) | 유지 (SELECT INTO 3건) |
| L611~838 | ITEM_SINGLE ORI_V→A_V→B_V→_V (4 GTT) | **S1** CTE 체인 |
| L842 | p_item_id 필터 DELETE | S1 `_V` CTE 술어 (T2·T4 **둘 다** 필터본 사용 — 이상③ 재현) |
| L861~998 | TEMP_SITE_ITEM_ALL (44열, 조인 10개, LISTAGG 스칼라) | S1 CTE `all` |
| L1002~1048 | site/customer/biz/item 필터 DELETE 4 | S1 `all` WHERE (item 은 중복 — 생략해도 동일, 단 NOT NULL 가드 동일하게) |
| L1057~1114 | TEMP_SITE_ITEM 6키 GROUP BY MAX | **S1 최종 INSERT** |
| L1126~1151 | project/owner/team 선행 축소 DELETE (NOT IN·NULL 의미) | S1 — 원문과 같은 `NOT IN (SELECT … FROM 자기자신)` 형태로 적재 후 1 DELETE 가 아닌 **INSERT 의 WHERE 로 흡수** (3키 그룹 EXISTS 로 동일 의미 — NULL 키·빈 토큰 케이스 검증 필수) |
| L1168~1246 | TEMP_SELECT_MEASURE 3 INSERT(사용자/CUST_FCST 자식/DM_ADMIN 강제 8) | S2 CTE `mea` (우선순위 UNION + NOT EXISTS 동일) |
| L1254~1432 | LAST_DATA_SETUP FCST(81) / FCST_C / PRICE_C | S2 CTE `ld81`, `ldc`, `lpc` (40 FCST 는 L1559 INSERT ALL 윈도 → CTE `ld40`) |
| L1441~3697 | TEMP_FCST_N_PRICE 기본 적재 28 arm | **S2** UNION ALL — 패밀리 A(수요 12 arm→2 스캔: 81/40 × Current/_C) · B(81 금액 3→1) · C(판가 8→4: 81/40 × Current/_C) · D(실적 4→2) · E(CUST 실적 1) |
| L3707~3829 | CURRENCY MERGE 3 (9키/8키/5키) | S2 CTE `loc9/loc8/loc5` → `COALESCE(own, loc9, loc8(단일), loc5(단일))` |
| L3841~3927 | 파생 LOC/KRW/FCST_GAP INSERT (Current·MF·SF) | S2 CTE `drv1` (base 위 GROUP BY) |
| L3939~4115 | SP 파생 LOC/KRW INSERT + RTF/MKT_AMT 삭제 | S2 CTE `drv2` + 최종 WHERE (버전 문자열에 SP 포함 시 전 버전 행 제외 — 원문과 동일) |
| L4129 | DM_ADMIN 강제 메저 삭제 | S2 최종 WHERE |
| L4149~4204 | 파라미터 필터 DELETE 6 (site NOT EXISTS / plant·project·owner·team NOT IN / sender NOT EXISTS) | S2 최종 WHERE — **MERGE·파생 이후** 단계에 두어야 함 (plant·project 는 M3 5키·qty_yn 9키 합에 영향) |
| L4220~4232 | 중복 제거 (59열 ROW_NUMBER, QTY DESC) | S2 윈도 CTE `dedup` (= 59열 GROUP BY MAX(QTY) 동일) |
| L4246~4281 | qty_yn=Y 삭제 (9키 MKT/SCM 합≠0) | S2 윈도 CTE `qty` (NULL 키 행 보존 의미 동일) |
| L4291~4307 | CUST_FCST 고아 삭제 (10키 NVL NOT EXISTS) | S2 윈도 CTE `orph` |
| L4312~4418 | C_TITLE 루프 → V_COLUMN/GROUPBY/ORDERBY, ADMIN COUNT | 유지 (문자열 생성·스칼라) |
| L4431~4649 | 편집권한 GTT 2개(INSERT 2 + UPDATE 5 + DELETE 3) | **S3** CTE `adm` (순서 CASE: 기본Y/T/N→LOC→AS_In_Req→VMI→LIMIT N→81AUTH N) · O_RC4 도 같은 CTE 로 OPEN |
| L4657~4675 | 달력 GTT 2 | 삭제 (이상② — 결과 무영향 실증 후) |
| L4686~4828 | MF_SP INSERT (11키×일 GROUP BY, 60 MAX) | **S3** CTE `msp` — 표시 열만 집계 |
| L4848~4952 | ATTR1 MERGE (40 MKT_FCST / 82 PR_DETAIL, PIVOT A1..A31) | S3 LEFT JOIN CTE `attr1` (p_division_id 분기) |
| L4972~5036 | 후처리 UPDATE 2 + AS_FROM MERGE + CURRENCY UPDATE | S3 CTE 체인 (순서 고정: CP '-' → AS_FROM 복사 → CURRENCY ' ') |
| L5042~5053 | PV_LIST 빈 경우 조기 반환 | 유지 |
| L5076~5226 | 숨김 열 대표값 MERGE 2 (CP → PLANT, COUNT 조건) | S3 CTE (조건은 SQL 생성 시 V_USER_COL_CNT 로 분기) |
| L5235~5262 | LAST_UPDATED_BY 동적 MERGE | S3 윈도 (PARTITION BY V_LU_KEYS, O_RC1 QTY 필터와 동일 행 집합) |
| L5273~5332 | O_RC1 5 arm UNION ALL + PIVOT | **S3** 그대로, 입력을 `msp` 축소본으로 |
| L5343~5396 | O_RC2/3/5 (달력·DUAL) | 유지 |

---

## 2. 목표 구조

```
S0  PARAM_TOKEN 1 INSERT (10 파라미터 UNION ALL)            ← 토큰 GTT 유지 (S1·S2·S3 공용, 함수 1회 실행 보장)
S1  INSERT INTO GT_DMF0082_TEMP_SITE_ITEM  WITH ori, a, b, v, all … (필터 4 + 선행축소 흡수)
S2  INSERT INTO GT_DMF0082_TEMP_FCST_N_PRICE
      WITH ver, ws, mea, ld81, ld40, ldc, lpc,
           base AS (패밀리 A~E UNION ALL),
           loc9, loc8, loc5, cur AS (COALESCE 통화 채움),
           drv1, drv2, uni AS (cur ∪ drv1 ∪ drv2),
           flt AS (파라미터 6 필터 + SP 삭제 + DM_ADMIN 제외),
           dedup, qty, orph
      SELECT … FROM orph
S3  OPEN O_RC1 FOR  (동적 CLOB)
      WITH adm, cal, pvt, vd, attr1,
           msp AS (TEMP_FCST_N_PRICE → 11키×일 GROUP BY, 표시 열만 MAX),
           fix1(CP '-') → fix2(AS_FROM) → fix3(CURRENCY) → fix4(CP 대표) → fix5(PLANT 대표) → fix6(LAST_UPD),
           disp AS (표시키 × 일 GROUP BY: SUM(QTY), COUNT(*))      ← 사전 그룹핑 핵심
      SELECT [@V_COLUMN], QTY, [@PV] FROM (5 arm over disp) PIVOT …
    OPEN O_RC4 FOR (adm CTE 정적 SQL) · O_RC2/3/5 현행
```

GTT 잔존 3개: PARAM_TOKEN · TEMP_SITE_ITEM · TEMP_FCST_N_PRICE (모두 SYS$SESSION PRESERVE — 커서 fetch 시 ORA-08103 없음, 10-14 확인). 나머지 GTT 는 **DROP 하지 않는다** (SAVE/EXCEL 등 타 프로시저 공용).

### 사전 그룹핑(사용자 요청) 적용 지점과 등가 조건
| 지점 | 내용 | 등가 조건 (착수 전 실측 게이트) |
|---|---|---|
| G1 S3 `msp` | 60개 MAX 속성 → **V_COLUMN 에 있는 열만** 집계 | 동적 SQL 이므로 조건 없음 (선택 안 된 열은 결과에 없음) |
| G2 S3 `disp` | 5 arm 이 각각 MF_SP 전체를 5회 스캔 → 표시키×일로 1회 집계 후 5 arm | ①QTY 필터(`(MEASURE∉{SCM_FCST,FCST_GAP} AND QTY≠0) OR MEASURE∈{…}`)를 **집계 전** 적용 ②AVG arm(KRW/USD/LOC W_/M_)은 `SUM(sum)/SUM(cnt)` ③fix4~6 은 disp **이전**(11키 grain)에 수행 |
| G3 S2 `base` | 열 축소(표시 안 하는 속성 제거) | ⛔ **금지** — dedup 키가 59열 전부라 열을 빼면 행이 줄 수 있음 (10-12 NOGRPBY 교훈: 구조적 유일성 증명 없이는 항등 집계 제거 불가). TEMP_SITE_ITEM 4키 유일성 실측 후 PASS 면 2차 과제 |
| G4 S2 `ld*` | LAST_DATA 집계를 원장 1회 윈도로 | 이미 09-30/10-14 적용된 방식 유지 |

### 보존해야 하는 순서 의존 (분석에서 확인)
- 통화 채움(M1~M3) → 파생 drv1(CURRENCY 로 GROUP BY)·drv2(B.CURRENCY 출력) 순
- 파라미터 필터 → dedup → qty_yn → 고아 삭제 순 (dedup 이 qty_yn 합을 바꿈)
- S3: CP '-' → AS_FROM 복사(키에 CP) → CURRENCY → CP 대표 → PLANT 대표(새 CP 키) → LAST_UPD(V_COLUMN 키)
- 40 Current: L1559 INSERT ALL 이 T_LAST_DATA_SETUP_FCST 를 만들고 #4(PP)·#8(실적)이 읽음 → `ld40` CTE 를 세 arm 이 공유
- SP 버전 포함 시 L4114 DELETE 는 **전 버전** RTF/MKT_AMT 행 삭제 (버전 문자열은 `Current,MF_W_…` 복수 가능 — v02_matrix 실증)

---

## 3. 작업 단계

### 0. 기준선 (hook #129 0-b · 수정 전 필수)
- `python _artifacts/_diagnostics/DMF0082_QRYPERF_20260930/p03_trace_profile.py <div>` 방식으로 **PKG_DMF0082_1104** 현행 문장별 시간 (40/81/82 × k0101/minyonglee1) — 결과 json 저장
- 벽시계: ab.py 방식 3회 중앙값, proc/fetch 분리, 행수·digest 기록
- 게이트 실측: TEMP_SITE_ITEM 4키 유일성(40/81/82), TEMP_SELECT_MEASURE MEASURE/RESULT_MEASURE 중복 여부, PARAM_TOKEN 빈 토큰 발생 여부, L1126 NOT IN 의 NULL 키 행 수
- 측정 중 원장 변경 감시: 측정 전후 DM_PLN_MKT_FCST/CFM/FUTURE_PRICE/SALES_PLAN(_RESULT) MAX(LAST_UPDATE_DATE)·COUNT 기록 (10-14 교훈)

### 1. 동등성 비교 도구 준비 (코드 수정 전)
- `v01_compare.py`/`v02_matrix.py` 를 복제해 `_artifacts/_apply_corporate/DMF0082_1104_ONEQUERY_20261104/compare.py`: 패키지 A=PKG_DMF0082 vs B=PKG_DMF0082_1104, 사용자 {k0101, minyonglee1}, 6커서 **행 순서 포함 SHA + 정렬 SHA + 행수 + 열 목록**
- 시나리오 매트릭스 (0행 = 미실증 표기): 40/81/82 × {Current, MF_W 단일, SF_W 단일, SP_W 단일, MF_D 단일, Current+MF_W 복수, Current+SP_W 복수} × 필터 {없음, site, item(부분 문자열), customer, biz, project, owner, team, plant(81), sender(≠ALL → 0행 재현), qty_yn=Y} 중 데이터 있는 조합 전부
- 1104 재작성 전 A vs B 가 **전 항목 PASS** 인지 먼저 확인 (도구 자체 검증)

### 2. 재작성 (BODY 중 GET_MAIN_DATA 1 프로시저만 교체 · 타 프로시저 무수정) — 2단계로 나눠 진행

**2-A. Current 경로 (1차 납품·검증·측정)**
- S0 → S1 → (compare: TEMP_SITE_ITEM 내용 A vs B 직접 대조) → S2 **Current arm 만** (패밀리 A 81/40 Current, B 81 Current 금액, C Current 판가 81/40, D Current 실적, E CUST 실적, 통화 채움, drv1 Current 분, 필터·dedup·qty_yn·고아) → (compare: TEMP_FCST_N_PRICE 59열 정렬 해시) → S3 → 6커서 compare
- 2-A 동안 버전 경로는 **원문 블록을 그대로 둔다**: `IF p_version_type` 에 Current 가 아닌 토큰이 하나라도 있으면 원문 STEP 경로로 분기(기존 코드 보존). 즉 2-A 완료 시점의 1104 는 "Current = 새 3문장 / 버전 = 원문" 혼합본이며, 복수 버전(`Current,MF_W_…`)도 원문 경로로 보낸다.
- 2-A 검증 매트릭스 = §1 중 Current 행 전부 + 필터 11종 + 사용자 2명 + 40/81/82. 성능 측정도 Current 기준으로 1차 보고.

**2-B. 버전 경로 (2차)**
- S2 UNION ALL 에 MF/SF/SP arm(패밀리 A·B·C·D 의 `_C` 스캔, drv1 MF/SF 분, drv2 SP 분, L4114 SP 삭제, ld `_C` CTE) 추가 → 원문 분기 블록 제거 → 버전 단일·복수 매트릭스 compare → 측정
- 2-A 의 Current 결과가 2-B 로 바뀌지 않았는지 Current 매트릭스 **재실행** (회귀 0)
- 중간 GTT 대조는 1104 에 임시 디버그 프로시저를 두지 말고, 같은 세션에서 두 패키지를 순서대로 호출한 뒤 GTT 를 읽는 compare.py 옵션으로 수행
- 마커 `[E20261104-DMF0082ONEQUERY]` · 원 STEP 행 번호 → 새 CTE 이름 **대조표**를 BODY 주석 상단에 포함 (누락 0 증빙)
- 힌트 추가 금지(#129 순서) · 기존 힌트(L1622·2071·2285·MERGE 3)는 문장이 사라지므로 제거되며, 계획 회귀 시에만 재검토
- `ALTER SESSION SET optimizer_dynamic_sampling=2` 유지, GTT SHARED 통계(10-09) 는 잔존 3 GTT 에 그대로 유효

### 3. 검증 (완료 선언 조건 — 2-A·2-B 각각 적용)
1. `ALL_OBJECTS` PACKAGE/BODY VALID · `ALL_ERRORS` 0
2. §1 매트릭스 전 항목 PASS (FAIL 0 · 미실증 항목 목록 첨부)
3. 원본 PKG_DMF0082 LAST_DDL_TIME 이 작업 시작(2026-11-04 14:48:42) 과 같음 — 다르면 차이분 1104 반영 후 재검증
4. 성능: 0단계와 같은 조건·같은 시간대, A/B 교차(ab.py 방식) 3회 중앙값 — proc·fetch·CPU·TEMP 사용량 · 문장별 p03 프로파일 전후표
5. 측정 전후 원장 변경 없음 확인

### 4. 산출물
`_artifacts/_apply_corporate/DMF0082_1104_ONEQUERY_20261104/`
- `00_baseline_*.json/.log`, `01_PKG_DMF0082_1104_BODY.sql`(SOURCE-FRESH 스탬프), `compare.py`, `measure.py`, `_matrix.txt`, `STEP_MAP.md`(원 STEP ↔ 새 CTE 대조표 + 이상 5건 재현 위치), `APPLIED_OPERATIONS.md`
- 원본 반영(PKG_DMF0082 교체)·클라우드 패키지는 **사용자 결정 후** 별도 단계 — 이 계획 범위 밖

---

## 4. 참조 파일
- 원문: `C:\Users\ejene\AppData\Local\Temp\claude\…\scratchpad\pkg1104\body.sql` (16:00 복제 기준) — 작업 시 DB 에서 재조회
- 기존 도구: `_artifacts/_diagnostics/DMF0082_QRYPERF_20260930/{v01_compare,v02_matrix,p03_trace_profile}.py`, `_artifacts/_apply_corporate/DMF0082_HINT_20261102/{ab,measure,build_apply}.py`, `tools/DbConn/dbconn.py`, `_artifacts/_diagnostics/ora.py`
- 이력 메모: project_dmf0082_{qryperf_20260930, gttstats_20261009, gttdelete_20261014, cloud_perf_recheck_20261012, mfperf_cutoffprune_20261015}

## 5. 리스크
- 한 INSERT 가 수천 줄: 옵티마이저가 CTE 를 인라인/머지하며 계획이 달라질 수 있음 → 0단계 프로파일로 문장별 비교, 필요 시 `MATERIALIZE` 는 힌트이므로 사용자 승인 후
- S2 UNION ALL 에 분기(division·version)가 CASE/OR 로 들어가면 바인드 값과 무관하게 전 arm 을 파싱 — 실행은 술어로 0행 처리되지만 계획 비용 증가 가능 → 동적 SQL 로 arm 자체를 생략하는 방식은 S2 에서 **쓰지 않음**(정적 SQL 유지, 바인드 피킹 없는 클라우드 QA 고려)
- 공유 DB: 측정 사이 원장 변경·타 작업자 인덱스 재생성 노이즈 → CPU·행수 기준 병행 판정
