# Hook #127 — oracle-nvl-null-antipattern (`NVL(x, NULL)` 금지 — 표현식은 `NVL(x,'-')`, 술어는 NVL 제거)

> **Trigger**: T06 (SP 변환) / T07 (사내 DB 적용) / SP 본문을 읽거나 고치는 모든 작업
> **PR 차단 강도**: ⭐⭐⭐ (런타임 차단 결함 — ORA-00979 실사고)
> **신설일**: 2026-08-10 (사용자 명시 — "NVL(x, NULL) 은 동작불가로 NVL(x, '-') 로 일괄적으로 적용되도록 RULE 로 지정해주세요")
> **정본**: `_artifacts/_diagnostics/dmf0044_nvl_null_apply.py`

---

## §1. 결론 (2줄)

- ⛔ **`NVL(x, NULL)` 은 금지**한다. MSSQL `ISNULL(x, '')` 오변환 계보이며 Oracle 에서 **동작 불가**다.
- ✅ **표현식(SELECT·GROUP BY·INSERT 값)은 `NVL(x, '-')`** / ⚠ **술어(`IS [NOT] NULL`)는 NVL 자체를 제거**한다.

### §1.1 적용 시점 (사용자 지시 2026-08-10 — **둘 다 의무**)

| 시점 | 의무 |
|---|---|
| **신규 변환** (MSSQL → Oracle SP/PKG 작성) | `ISNULL(x, …)` 변환 시 §3 표를 적용. `NVL(x, NULL)` 을 **산출물에 넣지 않는다** |
| **기 변환분 보완** (이미 이관된 PKG/SP 를 고칠 때) | 그 **PKG/SP 단위 전량**을 §5 grep 으로 훑어 **함께 정리**한다. "내가 만진 줄만" 고치는 부분 정정 금지 |

> 왜 "PKG 단위 전량"인가 — §2 사고는 **한 줄**(L7360/7387)이 원인이었지만, 같은 패키지에 동일 패턴이
> **104곳**(표현식 90 + 술어 14) 있었다. 하나만 고치면 다음 operation 에서 같은 오류가 다시 난다
> (실제로 PRODUCT_DETAIL 건도 ①→②→③ 양파로 3번 드러났다).
> ⚠ 단, **무관한 다른 화면의 PKG 는 건드리지 않는다**(회귀 관리 단위 = 화면/패키지). 목록만 §6 에 남긴다.

---

## §2. 왜 (2026-08-10 실사고)

사용자 신고: *"TYPE SP-W 선택 후 VERSION CREATE 시 SQL ERROR 발생합니다."*

```
ORA-20001: [PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY]
  SQLERRM=ORA-00979: "A"."CURRENCY" 은(는) GROUP BY 절에 나타나거나 집계 함수에서 사용되어야 합니다.
  BACKTRACE=ORA-06512: "SCM_MGR.PKG_DMF0044", 7354행
```

- SELECT(L7360) `NVL(A.CURRENCY, NULL) AS CURRENCY` ↔ GROUP BY(L7387) `NVL(A.CURRENCY, NULL)`
- **텍스트는 같은데** Oracle 이 `NVL(expr, NULL)`(= 아무것도 대체하지 않는 퇴화 형태)을 폴딩하면서
  두 자리의 표현식 동일성 판정이 깨져 **ORA-00979**.
- 전사 실측: `NVL(x, NULL)` **100건**(PKG_DMF0044 만 **104건**: 표현식 90 + 술어 14).

관련 계보: [[feedback_isnull_to_nvl_null_handling]] (`ISNULL(x,'')` → 잘못된 Oracle = `NVL(x, NULL)`) ·
`oracle-empty-string-notnull-insert` (`''` = NULL → NOT NULL 위반).

---

## §3. 치환 규칙 (⚠ 위치에 따라 다르다 — 일괄 치환 금지)

| 위치 | 정정 | 이유 |
|---|---|---|
| **표현식** — SELECT 목록 / GROUP BY / INSERT VALUES / `\|\|` 연결 / CASE 결과 | `NVL(x, **'-'**)` | 빈값 센티널 표준(hook #119 §1.5)과 동일. SELECT·GROUP BY 는 **반드시 쌍으로** 같은 문자열 |
| **술어** — `NVL(x, NULL) IS [NOT] NULL` | **`x IS [NOT] NULL`** (NVL 제거) | `NVL(x,'-') IS NOT NULL` 은 **항상 참** → 조건이 사라진다. DATE/NUMBER 변수면 타입 오류(ORA-00932/01858)까지 난다 |
| **숫자 리터럴형** — `NVL(1, NULL)` 등 (동적 SQL 조립) | **손대지 않는다** | 컬럼 참조가 아니라 조립 토큰 — 의미가 다르다 |

> ⚠ 술어형을 `'-'` 로 바꾸면 **결함을 다른 결함으로 바꾸는 것**이다.
> 실측(PKG_DMF0044): `AND NVL(d_Result_Date, NULL) IS NOT NULL` 7곳 —
> `d_Result_Date` 는 **DATE 변수**라 `'-'` 대입 시 타입 오류, 통과하더라도 조건이 상시 참이 된다.

---

## §4. 적용 절차

1. **탐지** — 주석 줄 제외 후 컬럼/변수 참조형만:
   ```
   NVL\s*\(\s*([A-Za-z_][\w$#]*(?:\s*\.\s*[A-Za-z_][\w$#]*)?)\s*,\s*NULL\s*\)
   ```
2. **분류** — 매치 직후 텍스트가 `IS [NOT] NULL` 이면 **술어**, 아니면 **표현식**.
3. **치환** — 표현식 `NVL(x,'-')` / 술어 `x`. 주석 줄은 **원문 보존**(이력).
4. **검증** — ①잔존 `NVL(x, NULL)` **0건** ②행 수 불변 ③선행 마커 전량 유지
   ④컴파일 VALID ⑤**해당 기능을 실제로 실행**(정적 통과로 끝내지 말 것 — §2 사고가 그렇게 통과했다).

## §5. POST-WRITE grep

```sql
-- 주석 밖 NVL(x, NULL) 잔존 = 0 이어야 한다
SELECT NAME, LINE, TEXT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND TYPE='PACKAGE BODY'
   AND REGEXP_LIKE(TEXT, 'NVL\s*\(\s*[A-Za-z_][A-Za-z0-9_$#]*(\s*\.\s*[A-Za-z_][A-Za-z0-9_$#]*)?\s*,\s*NULL\s*\)', 'i')
   AND LTRIM(TEXT) NOT LIKE '--%'
 ORDER BY NAME, LINE;
```

## §6. 잔여 (2026-08-10 실측 — PKG_DMF0044 외)

`PKG_DMF0002`(2) · `PKG_DMF0003`(4) · `PKG_DMF0042`(1) · `PKG_DMF0043`(1) ·
`PKG_DMF0048`(3) · `PKG_DMF0073`(2) · `PKG_DMF0082`(12) · `PKG_SYS0017`(1) = **26건**.
해당 화면 작업 시 본 룰로 정리한다(무관한 화면을 임의로 건드리지 않는다 — 회귀 관리 단위 유지).
그중 `PKG_DMF0082` L8832~8837 / `PKG_DMF0048` L1996 은 **숫자 리터럴형이라 대상 아님**(§3).
