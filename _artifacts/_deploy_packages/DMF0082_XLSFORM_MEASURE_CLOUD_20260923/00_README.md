# DMF0082 Excel Form — measure 합집합 + CURRENCY 보정 + 정렬 (클라우드 이관)

> 마커 4종: `[E20260923-XLSFORMMEASURE]` · `[E20260923-XLSFORMCURRENCY]` · `[E20260923-XLSFORMSORT]` · `[E20260923-XLSFORMCURCHAIN]`

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0082_XLSFORM_MEASURE_CLOUD_20260923` |
| 대상 | **DMF0082 — FCST & PRICE MGMT** / Excel Form 팝업 (`PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA`) |
| 범위 | **DB 전용 1객체** (`PKG_DMF0082` BODY). FE/BE 무변경 |
| 사내 적용 | **완료 · VALID · 오류 0** (222.110.191.243:2521/ZIOUI1 / SCM_MGR, 최종 2026-09-23 22:20:50) |
| 클라우드 | **미적용** |

---

## ⚠ 먼저 읽어 주세요 — 건수는 **컷오프 스냅샷**에 달려 있습니다

Excel Form 건수 부족의 근본 원인은 SP 가 아니라 **SP_W 컷오프 스냅샷 결함**으로 확정됐습니다(원장은 정상인데 컷오프에 RTF·금액 계열이 누락). measure 합집합은 그 상황에서도 양식이 채워지도록 하는 **완화 조치**입니다.

| 축 | 클라우드 (09-23) | 사내 (09-23) |
|---|---:|---:|
| 원장 `DM_PLN_SALES_PLAN` RTF_SYS_RP | **6,152 (정상)** | **5,618 (정상)** |
| 최신 컷오프 RTF_SYS_RP | 8 | **0** |
| 최신 컷오프 **MKT_FCST** | **10,472** | **0** |
| 최신 컷오프 RTF_PR / SalesAmt_* | 0 / 0 | 0 / 0 |
| 최신 컷오프 TOTAL | 42,321 | **0** |

**적용 후 예상**: 클라우드는 컷오프에 `MKT_FCST` 10,472행이 있어 **합집합이 실제로 효과를 냅니다**(RTF 8행 단독이면 1행 수준). 사내는 09-23 14:59 컷오프가 전량 0 이라 measure 와 무관하게 0행입니다.

근본 해소는 **컷오프 재수행**이며 §4 참조.

---

## 1. 변경 내용 4종

### ① `[E20260923-XLSFORMMEASURE]` measure 합집합 (사용자 확정 2026-09-23)

```sql
AND SP.MEASURE = 'RTF_SYS_RP'                    -- AS-IS 파리티
→ AND SP.MEASURE IN ('RTF_SYS_RP','MKT_FCST')     -- 합집합
```

사내 실측(컷오프 정상 시점): `RTF_SYS_RP` 단독 **116행** / `MKT_FCST` 단독 144행 / **합집합 145행**. 적용 전 키 집합 ⊆ 적용 후 → **손실 0**(증가 28건, Currency NULL 0 · Team NULL 1).

- ⛔ `MKT_FCST` **단독 교체 금지** — `RTF ⊆ MKT` 가 아니라 RTF 전용 키 1건이 소실됩니다
- `RTF_SCP`·`RTF_PR` 추가는 116 그대로(키 포함관계) → 대안 아님
- 업로드 계약 무영향 — `P_DMF0082_EXCEL_UPLOAD` 는 6키(Div/Team/End Customer/Project/Currency/Model)로 저장하며 measure 를 키로 쓰지 않습니다
- ⚠ **AS-IS 파리티 이탈**(AS-IS `DMF0020_GET_SALES_PRICE_TEMPLATE` L105/L150 은 단일). 2026-09-23 일시 해제했다가 **사용자 판단으로 재적용** — 컷오프 정상화 후 원복 여부는 재검토 대상

### ② `[E20260923-XLSFORMCURRENCY]` CURRENCY 폴백 센티널 정정

```sql
CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END   -- Oracle 에서 사문
→ CASE WHEN NVL(SP.CURRENCY, '-') = '-' THEN ...                            -- AS-IS 2단 폴백 복원
```

MSSQL `ISNULL(x,'')=''` 오역(hook #119). Oracle 은 빈문자=NULL 이라 **항상 ELSE** 로 빠져 SSPM 폴백이 한 번도 동작하지 않았습니다. 사내 실측 590행 폴백 실패 → 양식 Currency 빈칸 **21행 → 0행**.

### ③ `[E20260923-XLSFORMSORT]` 조회 정렬 신설

```sql
ORDER BY DIVISION_ID, DEPT_NAME NULLS LAST, END_CUSTOMER, PROJECT_CODE, ITEM_ID
```

AS-IS 에는 `ORDER BY` 가 **아예 없어**(실측) 순서가 비결정적이었습니다. 양식 표시 컬럼 순서로 신설했습니다. `Currency` 는 `MAX()` 집계값이라 정렬 키 제외, `Team` 미지정 행은 뒤로.

### ④ `[E20260923-XLSFORMCURCHAIN]` CURRENCY 폴백 체인 — 빈칸 0 보증

| 단계 | 원천 | 사내 커버 |
|---|---|---|
| L1 | `SP.CURRENCY` 판매계획 실적 통화 | 14,021 / 14,611 |
| L2 | `SI.CURRENCY` SSPM SITE_ITEM 4키 — **AS-IS 동일** | 나머지 590 전부 |
| L3 | `SCM_MST_FUTURE_PRICE` 같은 키의 기존 단가 통화 | 키 187 / 194 |
| L4 | `SCM_MST_SITE_ITEM` 3키(프로젝트 무시) | 191 / 194 |
| L5 | `MP.CURRENCY` 프로젝트 기본통화 (이미 조인됨) | **194 / 194** |

`COALESCE` 좌→우 단락평가라 앞 단계가 채우면 뒤 서브쿼리는 실행되지 않습니다. **보증 검증**: L1·L2 가 전부 결측이라 가정해도 L3~L5 가 키 194/194 커버.

---

## 2. 사내 검증 실측

| 시점 | 상태 |
|---|---|
| 14:36 (컷오프 정상, 합집합) | **145행** · Currency 빈칸 **0**(USD 71/KRW 52/EUR 22) · 정렬 PASS · 6.0초 |
| 22:10 (합집합 해제 시험) | 0행 — 사내 컷오프 전량 0 이라 measure 무관 |
| **22:20 (합집합 재적용, 현재)** | 0행 · `CODE=0 SUCCESS` · 정렬·M0~M12 유지 — 동일 사유 |

- 컴파일 VALID · USER_ERRORS 0 · 적용본 == DB
- 마커 상태: 합집합 2 / 해제마커 잔존 **0** / CURRENCY 2 / SORT 1 / CHAIN 2
- 비81 가드 회귀 PASS: div 40 → 0행 / `CODE=1` / `MSG01014`
- **손실 0 검증**(14:36 시점): 적용 전 키 집합 ⊆ 적용 후 (subset PASS)
- **빈칸 0 보증 검증**: L1·L2 결측 가정 시에도 L3~L5 가 키 194/194 커버

> 현재 사내 0행은 **컷오프가 전량 0** 이기 때문이며(원장 5,618 정상), SP 변경과 무관합니다.

## 3. 적용 절차 (SCM_MGR 접속)

1. `@A_DB/00_PRECHECK_CLOUD.sql` — 조회 전용
   - `EXPECTED_MISSING` 에 이번 마커가 있으면 미적용 상태
   - `CLOUD_ONLY_MARKERS` 가 비어 있지 않으면 **전체교체 전 결과 공유**
   - `③` 최신 컷오프의 `RTF_SYS_RP` + `MKT_FCST` 건수 — 둘의 합이 양식 행수를 좌우
   - `④` 원장 대비 컷오프 누락 measure — `RTF_PR`/`SalesAmt_*` 가 0 이면 **컷오프 재수행 대상**
2. `@A_DB/05_PKG_DMF0082_BODY.sql`
3. `@A_DB/90_VERIFY.sql` — VALID · USER_ERRORS 0 · INVALID 0 · **마커 4종 > 0** · **합집합 적용 2곳** · **구 CURRENCY 사문식 잔존 0** · SCMP_APP 시노님/EXECUTE
4. 화면 DMF0082(81) → Excel Form 팝업 → **건수 · Currency 빈칸 0 · 정렬** 확인

패키지 상태변수 없음 → BE 재기동 불요.

---

## 4. 건수 정상화 — 별도 조치 (미실행)

원장이 정상이므로 **컷오프 재수행**으로 해소됩니다.

```sql
PR_DM_PLN_SALES_PLAN_CUTOFF( P_DIVISION_ID => '81'
                           , P_VERSION_DESCRIPTION => <설명>
                           , P_VER_TYPE => 'SP_W'
                           , P_CREATED_BY => <계정> );
```

`SP_W_20260923_V002` 가 생성되고 Excel Form 은 `MAX(VERSION_NO)` 로 V002 를 잡습니다(같은 날 V001/V002 공존 선례 있음). **다른 화면·리포트도 함께 바라보는 축**이라 운영 승인 후 실행해야 합니다. 진단 SQL = `_artifacts/_diagnostics/DMF0082_XLSFORM_VERSION_DIAG.sql`.

---

## 5. 원복 단위

사내 `_apply_corporate/DMF0082_XLSFORM_MEASURE_20260923/` 에서 실행합니다. 각 백업본은 **직전 변경까지 누적된 상태**입니다.

| 대상 | 명령 |
|---|---|
| 합집합 **해제**(AS-IS 파리티 복귀) | `python revert_measure.py apply` |
| CURRENCY 체인만 해제 | `python apply_currency_chain.py restore` |
| 정렬까지 해제 | `python apply_sort.py restore` |
| CURRENCY 정정까지 해제 | `python apply_currency.py restore` |
| 전부 원복 (2026-09-22 13:18 원문) | `python apply_measure.py restore` |
