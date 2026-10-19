# Hook #150 — DEPT_ID 산출 기준 표준 (SCM_MST_SITE_ITEM 단일화 + DIV+SITE MAX 단일건)

> ⭐ **사용자 지시 (2026-09-05)** — "DEPT_ID 을 가져오는 기준을 변경하고자 합니다."
> ⭐ **사용자 지시 (2026-09-07, §3 정책 전환)** — "SCM_MST_SITE_ITEM 기준으로 중복 DEPT 발생 가능성이 있었으며,
> 이때 **DIVISION_ID + SCM_SITE_ID 를 기준으로 MAX 로 한건만 추출**하는 것으로 RULE 을 변경."
> **적용 범위 (2026-09-07 사용자 확정)**: 룰 개정 + 실측으로 확인된 미적용 지점(`PKG_DMF0020` 2곳) 정정.
> 기존 PKG/SP **일괄 소급 개정은 하지 않는다**(§7).

---

## §1. 규칙 (핵심 2줄)

1. **DEPT_ID 는 `SCM_MST_SITE_ITEM.DEPT_ID` 에서만 가져온다.**
2. **산출 키가 `(DIVISION_ID, SCM_SITE_ID)` 면 `MAX(DEPT_ID)` 로 키당 정확히 1건만 취한다.**

| 구분 | 패턴 | 판정 |
|---|---|---|
| AS-IS ① | `SCM_MST_SITE.DEPT_ID` 직접 추출 | ⛔ 폐기 |
| AS-IS ② | `SCM_MST_SITE.OWNER` → 그 OWNER 의 DEPT_ID 추출 | ⛔ 폐기 (⚠ §2-C — TO-BE 스키마에 원천 부재) |
| AS-IS ③ | `SCM_MST_SITE_ITEM.OWNER` → `SCM_MST_SSO_USER_INFO.USER_ID` → `.DEPT_ID` | ⛔ 폐기 |
| **TO-BE** | **`SCM_MST_SITE_ITEM.DEPT_ID`** — (DIV,SITE) 키면 `MAX` 단일건 (§3) | ✅ 유일 정본 |

---

## §2. 스키마 실측 사실 (2026-09-05 최초 · 2026-09-07 재실측, AJS DB — 추정 금지)

### A. 컬럼 실재 (`USER_TAB_COLUMNS`)
| 테이블 | `DEPT_ID` | `OWNER` | `SALES_SITE_ID` | site 키 |
|---|:--:|:--:|:--:|---|
| `SCM_MST_SITE` | ✅ (col 39) | ❌ **없음** | ❌ 없음 | `SCM_SITE_ID` |
| `SCM_MST_SITE_ITEM` | ✅ (col 15) | ✅ (col 16) | ❌ **없음** | `SCM_SITE_ID` |
| `SCM_MST_SITE_ITEM_PRIORITY` | ❌ | ❌ | ✅ (col 4) | `SALES_SITE_ID` |

### B. ⭐ `SALES_SITE_ID` 용어 매핑 (오적용 1순위)
요구 문구의 "**SALES_SITE_ID**" 는 **컬럼명이 아니라 개념명**이다.
`SCM_MST_SITE_ITEM` 에는 `SALES_SITE_ID` 컬럼이 **없다**. 실제로 써야 할 컬럼은 다음과 같다.

```
DIV + SALES_SITE_ID   ==>   MI.DIVISION_ID + MI.SCM_SITE_ID
                            (판매 site 한정이 필요하면 SCM_MST_SITE.SITE_TYPE = 'SALES' 로 제한)
```

`SALES_SITE_ID` 라는 실컬럼은 `SCM_MST_SITE_ITEM_PRIORITY` / `SCP_PLN_*` / `DM_DNM_SALES_RESULT` 계열(25개 객체)에만 존재하므로,
**DEPT_ID 산출 로직에서 `SALES_SITE_ID` 컬럼을 직접 찾으면 ORA-00904 이다.**

### C. ⚠ AS-IS ② 의 원천 부재
`SCM_MST_SITE` 에는 **`OWNER` 컬럼이 존재하지 않는다** (`SCM_MST_SITE` · `SCM_MST_SITE_H` · 백업본 전부 실측 확인).
따라서 AS-IS ② 는 현행 TO-BE 스키마에서 **구현 불가능한 패턴**이며, 실제 잔존 패턴은 ①·③ 뿐이다.
② 를 AS-IS GSCM(MSSQL) 원천에서 확인해야 할 경우 별도 실측할 것 — **추정으로 코드를 작성하지 말 것.**

### D. PK / 다건 발생 구조
```
PK_SCM_MST_SITE_ITEM = (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID)
```
→ `(DIVISION_ID, SCM_SITE_ID)` 는 **PK 의 부분집합**이다. PROJECT_CODE·ITEM_ID 축이 남으므로 **1:N 이 정상**이고,
그 N 행의 `DEPT_ID` 가 서로 다를 수 있다. ⇒ 이 지점에 §3 의 `MAX` 를 적용한다.

---

## §3. ⭐ 다건 정책 — **(DIV, SITE) 기준 MAX 단일건** (사용자 확정 2026-09-07)

> ⚠️ **2026-09-05 의 "다건 그대로 반환" 정책은 폐기되었다.** 아래가 현행 정책이다.

### 실측 다중성 (2026-09-07 AJS 재실측, 추정 아님)
```
(DIVISION_ID, SCM_SITE_ID) 키 = 2,590    DEPT_ID 2개 이상 = 500
  division 별 다중 키 : 40=100 · 81=209 · 81_HG=1 · 81_HM=7 · 81_UC=8 · 82=175 (81_HD·81_ST=0)
  키당 최대 DEPT_ID   : 30
  키당 최대 SITE_ITEM 행수 : 40=3,506 · 81=2,187 · 82=1,063
      ↳ DEPT 값이 1개여도 (DIV,SITE) 단독 조인은 이 행수만큼 증식한다 — DEPT 다중성보다 훨씬 크다
정본 뷰 술어(SITE_TYPE='SALES' AND DIVISION_ID<>'40') 기준 : 키 1,273 중 다중 400 (31.4%)
```

### 정책
| # | 항목 | 확정 내용 |
|---:|---|---|
| 1 | **(DIV, SITE) grain** | `MAX(DEPT_ID)` 로 **키당 정확히 1건**. 키가 PK 보다 성긴 모든 지점이 대상 |
| 2 | **NULL 제외** | `AND SA.DEPT_ID IS NOT NULL` 명시 (MAX 가 NULL 을 무시하더라도 의도를 코드에 남긴다) |
| 3 | **PK 4키 grain** | `(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID)` 가 확보되면 **이미 1:1** → MAX 불필요, 그 행의 `DEPT_ID` 를 그대로 쓴다. site 대표값으로 **덮어쓰지 않는다** |
| 4 | ⭐ **유효부서 술어는 MAX 안쪽으로** | 소비 측이 `SCM_MST_SSO_DEPT_INFO`(`VALID_YN='Y'`) 를 **INNER 로 요구**하던 지점은 그 술어를 MAX 의 **바깥이 아니라 안쪽**에 둔다. 밖에 두면 대표값이 무효 부서일 때 **행이 통째로 사라진다** — 실측 7 키 소실(2026-09-07) |
| 5 | 검증 | 변경 전후 **결과 행수 대사 의무**. MAX 전환은 키당 1건이므로 **행수가 늘면 잘못 적용된 것**이다 |

### 정본 형태 (둘 다 등가 — 상황에 맞게 선택)

```sql
-- (a) 스칼라 서브쿼리형 : 소비 측이 이미 SITE 를 들고 있고 지점이 1곳일 때
       (SELECT MAX(SA.DEPT_ID)
          FROM SCM_MST_SITE_ITEM SA
         WHERE SA.DIVISION_ID = MS.DIVISION_ID
           AND SA.SCM_SITE_ID = MS.SCM_SITE_ID
           AND SA.DEPT_ID IS NOT NULL) AS DEPT_ID   /* site 대표 부서 */

-- (b) 선계산 인라인 뷰형 : 조인으로 소비할 때 (hook #129 ① — 행별 스칼라 회피)
       INNER JOIN (SELECT SA.DIVISION_ID, SA.SCM_SITE_ID, MAX(SA.DEPT_ID) AS DEPT_ID
                     FROM SCM_MST_SITE_ITEM SA
                    WHERE SA.DEPT_ID IS NOT NULL
                    GROUP BY SA.DIVISION_ID, SA.SCM_SITE_ID) IM
           ON  IM.DIVISION_ID = MS.DIVISION_ID
           AND IM.SCM_SITE_ID = MS.SCM_SITE_ID
```

> §3-4 가 걸리는 지점이면 (b) 의 인라인 뷰 안에
> `INNER JOIN SCM_MST_SSO_DEPT_INFO SD ON SD.DEPT_ID = SA.DEPT_ID AND SD.VALID_YN = 'Y'` 를 함께 넣는다.

---

## §4. 기준 구현체 (정본)

**`SCM_MST_SITE_DEPT_V`** — 본 룰의 레퍼런스 구현. `-- 2026.09.03 AJS` / `-- 2026.09.06 AJS` 마커로 전환 완료.

```sql
-- branch 1 : DIVISION_ID != '40' (SITE_TYPE='SALES')  ← (DIV,SITE) grain → MAX 적용
  FROM (SELECT  MS.DIVISION_ID
              , MS.SCM_SITE_ID
              , (SELECT  MAX(SA.DEPT_ID)                       -- ⭐ §3-1 정본
                   FROM  SCM_MST_SITE_ITEM SA
                  WHERE  SA.DIVISION_ID = MS.DIVISION_ID
                    AND  SA.SCM_SITE_ID = MS.SCM_SITE_ID
                    AND  SA.DEPT_ID IS NOT NULL) AS DEPT_ID    /* 사이트 대표 부서 */
          FROM  SCM_MST_SITE MS
         WHERE  MS.SITE_TYPE = 'SALES' AND MS.DIVISION_ID != '40') IA
     , SCM_MST_SSO_DEPT_INFO DI
 WHERE IA.DEPT_ID = DI.DEPT_ID(+)  AND IA.DEPT_ID IS NOT NULL

-- branch 2 : DIVISION_ID = '40'  ← ITEM/PROJECT 까지 내려간 PK grain → §3-3 (MAX 불필요)
 WHERE SI.DEPT_ID = DI.DEPT_ID(+) AND SI.DEPT_ID IS NOT NULL
   AND SI.DIVISION_ID = '40' AND RTRIM(SI.ITEM_ID) IS NOT NULL AND RTRIM(SI.PROJECT_CODE) IS NOT NULL
```

실측(2026-09-07): 뷰 총 16,838행 = div40 15,565 + 비40 **1,273** — 비40 은 `(DIV,SITE)` 중복 **0건**(MAX 로 1:1 확정),
`UPPER_DEPT_ID` NULL **0건**(이 술어 범위에서는 대표값이 항상 유효 부서).

파생 뷰 **`IF_SCM_MST_SITE_DEPT_V`** (DW 용) 는 위 뷰를 그대로 `FROM` 하므로 **자동 반영**된다 — 별도 수정 대상 아님.

> ⚠️ **주석은 근거도 적용 대상도 아니다 (hook #138).** AS-IS 3형은 주석으로 남아 있을 뿐이며,
> **주석 해제로 되살리는 행위 금지**. 판정은 항상 주석 제거본(`_artifacts/_diagnostics/strip_code_comments.py`)으로 한다.

---

## §5. 금지 패턴 + 검출

| # | 금지 | 대체 |
|---:|---|---|
| 1 | `SCM_MST_SITE`(별칭).`DEPT_ID` 를 DEPT 산출에 사용 | `SCM_MST_SITE_ITEM.DEPT_ID` |
| 2 | `SITE_ITEM.OWNER` → `SSO_USER_INFO.USER_ID` → `DEPT_ID` 경유 | `SITE_ITEM.DEPT_ID` 직접 |
| 3 | `OWNER` 의 콤마 분리 첫번째 값 사용(`INSTR(OWNER,',')` / `SUBSTR`) | 폐기 — OWNER 는 DEPT 산출에 쓰지 않는다 |
| 4 | `SALES_SITE_ID` 컬럼을 `SCM_MST_SITE_ITEM` 에서 참조 | `SCM_SITE_ID` |
| 5 | ⭐ **`(DIVISION_ID, SCM_SITE_ID)` 단독으로 `SCM_MST_SITE_ITEM` 을 직접 조인** (MAX/GROUP BY 없음) | §3 정본 (a) 또는 (b) — **키당 1건**으로 만든 뒤 조인 |
| 6 | ⭐ MAX 를 취해 놓고 **유효부서 INNER 술어를 MAX 바깥**에 둠 | 술어를 MAX 안쪽으로 (§3-4) |
| 7 | PK 4키가 있는 지점을 site 대표값(MAX)으로 **덮어쓰기** | 그 행의 `DEPT_ID` 유지 (§3-3) |

검출 스윕 (주석 제거본 기준):
```bash
# ① SITE.DEPT_ID 직접 사용 잔존
python _artifacts/_diagnostics/ora.py query "
  SELECT DISTINCT NAME, TYPE FROM USER_SOURCE
   WHERE REGEXP_LIKE(UPPER(TEXT), '(^|[^_A-Z])[A-Z]{1,4}\.DEPT_ID')
     AND NAME IN (SELECT NAME FROM USER_SOURCE WHERE UPPER(TEXT) LIKE '%SCM_MST_SITE%')"

# ② OWNER 경유 DEPT 산출 잔존
python _artifacts/_diagnostics/ora.py query "
  SELECT DISTINCT NAME, TYPE FROM USER_SOURCE
   WHERE UPPER(TEXT) LIKE '%OWNER%' AND UPPER(TEXT) LIKE '%USER_ID%'
     AND NAME IN (SELECT NAME FROM USER_SOURCE WHERE UPPER(TEXT) LIKE '%DEPT_ID%')"
```

```bash
# ③ ⭐ (DIV,SITE) 단독 조인 grain 판정 — LIVE 라인만, 조인키 집합을 실제로 읽는다
#    정본 스캐너 = _artifacts/_diagnostics/dept_id_join_grain_scan.py
python _artifacts/_diagnostics/dept_id_join_grain_scan.py PKG_DMF0020 PKG_DMF0082 ...
#    JOINKEYS 가 DIVISION_ID+SCM_SITE_ID 인데 MAX/GROUP BY 가 없으면 §5-5 위반
```

---

## §6. 게이트

| ID | 게이트 | FAIL 조건 |
|---|---|---|
| G150-1 | 원천 단일성 | DEPT 산출 SQL 이 `SCM_MST_SITE_ITEM.DEPT_ID` 외 원천을 사용 |
| G150-2 | 컬럼 실재 | `SALES_SITE_ID` 를 `SCM_MST_SITE_ITEM` 에서 참조(ORA-00904) |
| G150-3 | ⭐ **MAX 단일건** | 산출 키가 `(DIVISION_ID, SCM_SITE_ID)` 인데 `MAX`(또는 등가 1건 보장)가 없음 |
| G150-4 | ⭐ **grain 보존** | PK 4키가 확보된 지점을 site 대표값으로 덮어씀 (§3-3 위반) |
| G150-5 | 행수 대사 | 변경 전후 결과 행수 실측 미제출. **MAX 전환인데 행수가 늘었으면 FAIL** |
| G150-6 | 주석 부활 금지 | 주석 처리된 AS-IS ①·③ 블록을 해제해 되살림 |
| G150-7 | ⭐ **유효부서 술어 위치** | 유효부서 INNER 술어가 MAX 바깥에 있어 통과 키 집합이 줄어듦 (§3-4 위반) |

---

## §7. ⭐ 적용 범위 (소급 일괄 개정 금지 — 사용자 명시)

> "일단 RULE 만 변경하고 전체 PKG, SP 을 변경하지는 않습니다" (2026-09-05)
> 2026-09-07 추가 확정: **룰 개정 + 실측으로 확인된 미적용 지점만 정정** (전수 재적용 아님)

| 대상 | 조치 |
|---|---|
| 기존 PKG / SP (DEPT_ID 참조 **109 객체 / 2,151 라인** 실측) | **일괄 개정 안 함.** 현 상태 유지 |
| 신규 작성 SQL/SP/뷰 | **본 룰 의무 적용** |
| 기존 객체를 **다른 사유로 수정할 때** | 그 객체의 DEPT 산출부는 본 룰로 정정 (touch 시 적용) |
| `SCM_MST_SITE_DEPT_V` / `IF_SCM_MST_SITE_DEPT_V` | **적용 완료** (2026.09.03 · 09.06 AJS) |
| `NEW_DEPT_ID_TBL` (`DMF0020_GET_SCM_MST_FUTURE_PRICE` · `PKG_DMF0020` 미러) | **적용 완료** — 이미 `MAX(T2.DEPT_ID)` |
| ⭐ `PKG_DMF0020` `P_DMF0020_GET_SALES_PRICE_TEMPLATE` (2블록, UNION ALL 미러) | **2026-09-07 정정 대상** — `IM` 이 (DIV,SITE) 단독 INNER JOIN 이라 §5-5 위반. 패키지 = `_artifacts/_apply_corporate/DEPT_ID_RULE150_MAX_20260907/` |

> 2026-09-06 적용 10 객체 35 지점 중 **위 1건(2블록)을 제외한 나머지는 PK 4키 또는 등가 grain** 이라
> 본 정책 전환으로 값·건수가 바뀌지 않는다(2026-09-07 조인 grain 전수 스캔 실측 — LIVE 166 참조).
> 소급 전수 전환이 필요해지면 그때 별도 지시로 착수한다. 본 hook 이 소급 착수 근거가 되지 않는다.

---

## §8. Cross-ref
- hook #138 `comment-live-code-discrimination` — 주석 ≠ 근거 / 주석 부활 금지
- hook #129 `oracle-perf-fix-priority-order` — 행별 스칼라 회피(선계산+JOIN) / 조인 카디널리티 변화 검증
- hook #30 `oracle-db-workflow` — SP/DB 작업 진입점
- 메모리 `feedback_dictionary_first_for_meta_work.md` — division 기준은 언제나 AS-IS
- 메모리 `feedback_literal_occurrence_is_not_structure_evidence.md` — 출현 카운트 ≠ 구조 근거
- 메모리 `feedback_asis_dev_volatile_snapshot_gate.md` — 원천 DB 재적재 → 고정 건수 ASSERT 금지
