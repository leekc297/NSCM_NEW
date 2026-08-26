# Hook #147 — Excel Upload 값 파싱 = NLS·셀서식 **무관**이어야 한다

> 신설 2026-08-23 (사용자 명시). 계기 = DMF0014 Excel Upload 가 **사내는 정상, 클라우드만 전건**
> `Invalid Measure Upload Bucket.` 로 반려된 실사고.
>
> 사용자 원문:
> > "NLS·서식 의존을 제거 의 경우에는 Excel Upload 시 항상 문제가 되므로 문제가 되지 않도록
> >  보완하는 Rule 을 MD, HOOK 에 기재해서 앞으로는 발생하지 않도록 rule 적용 해주세요."
>
> 적용 범위: **엑셀 업로드 계열 SP 전부**(`%_EXCEL_UPLOAD%`, 스테이징 `SCM_ADM_EXCEL_UPLOAD` 소비 코드).
> 카테고리 = `12_process_ops`(주) · `09_oracle_sp`. 짝 룰: [[oracle-nls-implicit-conversion]](#109 — 암묵 형변환) ·
> [[excel-form-upload-standard]](#135 — 2단 업로드 표준) · [[deploy-package-completeness]].

---

## §0. 무엇이 터졌나 (2026-08-23 실측)

`P_DMF0014_CUST_FCST_EXCEL_UPLOAD` 는 버킷 주기(DAILY/WEEKLY/MONTHLY)를 **헤더행 일자 4칸의 간격**으로 정한다.

```sql
-- 종전 (취약)
AND D.UPLOAD_BUCKET_TYPE IN (
    SELECT CASE (NVL(NVL(TO_DATE(TO_CHAR(TO_NUMBER(Z.ATTRIBUTE16)),'YYYYMMDD')
                       - TO_DATE(TO_CHAR(TO_NUMBER(Z.ATTRIBUTE15)),'YYYYMMDD'), …)))
             WHEN 1 THEN 'DAILY' WHEN 7 THEN 'WEEKLY' ELSE 'MONTHLY' END
    FROM SCM_ADM_EXCEL_UPLOAD Z
    WHERE … AND REGEXP_LIKE(Z.ATTRIBUTE15, '^[0-9.eE+-]+$'))   -- ← 행 채택 조건
```

깨지는 경로 두 갈래 — **둘 다 "그 DB 에서만" 터진다**:

| # | 지점 | 무엇에 의존하나 | 결과 |
|---|---|---|---|
| A | `REGEXP_LIKE(x,'^[0-9.eE+-]+$')` | 엑셀/POI 가 그 환경에서 셀을 **어떤 문자열로** 넘겼는지 | `'2026-08-10'` 같은 날짜서식이면 **채택 0건** → `IN (빈 집합)` → `NOT EXISTS` 성립 → **전건 ERROR** |
| B | `TO_NUMBER(x)` | 세션 **`NLS_NUMERIC_CHARACTERS`** | `'20260803.0'` 을 소수점 문자가 `','` 인 DB 에서 변환 → **ORA-01722** |

사내가 멀쩡했던 이유 = 사내 실측 `NLS_NUMERIC_CHARACTERS='.,'` + 헤더 셀이 순수 8자리 `'20260803'`.
**"로컬에서 되니 코드는 맞다" 가 성립하지 않는 유형이다.**

---

## §1. 규칙 (엑셀 업로드 SP 작성·수정 시 절대준수)

### R1. 스테이징 셀 → 일자: **숫자만 뽑아 앞 8자리**
```sql
TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(x),'[^0-9]','')) >= 8
             THEN SUBSTR(REGEXP_REPLACE(TRIM(x),'[^0-9]',''),1,8) END, 'YYYYMMDD')
```
- 8자리 미만이면 **NULL** 로 떨어뜨린다(예외 대신). 폴백 사슬(`NVL`)이 다음 후보를 쓰게 둔다.
- 실측 내성 (2026-08-23, 같은 식에 5형 투입 → 전부 `2026-08-03`):
  `20260803` · `20260803.0` · `2026-08-03` · `' 2026/08/03 00:00:00'` · `2.0260803E7`

### R2. 셀 값에 `TO_NUMBER` 를 **직접** 쓰지 않는다
숫자 판정이 필요하면 먼저 정규화한다: `TO_NUMBER(REGEXP_REPLACE(x,'[^0-9-]',''))` 또는
`TO_NUMBER(x DEFAULT NULL ON CONVERSION ERROR)`(19c+). 소수 포함 값이면 마스크와
`NLS_NUMERIC_CHARACTERS` 를 **명시**한다: `TO_NUMBER(x,'99999999D9','NLS_NUMERIC_CHARACTERS=''.,''')`.

### R3. 행 채택 조건도 같은 기준으로
`REGEXP_LIKE(x,'^[0-9…]+$')` 같은 **표기 기반 필터 금지**. 의미 기반으로 쓴다:
`LENGTH(REGEXP_REPLACE(TRIM(x),'[^0-9]','')) >= 8`.
표기 필터는 "한 DB 에서만 0건" 을 만들고, 0건은 대개 **전건 반려**로 증폭된다.

### R4. `TO_DATE` / `TO_CHAR` 는 **항상 마스크 명시**
마스크 없는 단일 인자 `TO_DATE(x)` 는 `NLS_DATE_FORMAT` 의존이다(#109). 공용 헬퍼
`FN_CHAR_TO_DATE`(내부 `TO_DATE(x,'YYYYMMDD')`) 사용은 무방하나 **8자리 보장은 호출 측 책임**이다.

### R5. "빈 집합 → 전건 반려" 를 만들지 않는다
`IN (서브쿼리)` 로 분류·검증할 때, 서브쿼리가 0건이면 **왜 0건인지 로그로 남기고** 별도 메시지로 끊는다.
`Invalid …` 한 줄로 뭉치면 원인이 데이터인지 파싱인지 구분되지 않아 이번처럼 DB 간 차이를 못 찾는다.

---

## §2. PRE-WRITE 체크 (엑셀 업로드 SP 를 건드리면 무조건)

```
☐ 셀 → 일자 변환이 R1 형태인가 (TO_DATE(TO_CHAR(TO_NUMBER(…))) 0건)
☐ 셀 값에 직접 TO_NUMBER 를 쓰지 않았는가 (R2)
☐ 행 채택이 표기 정규식이 아닌 의미 기준인가 (R3)
☐ TO_DATE/TO_CHAR 마스크 100% 명시인가 (R4)
☐ 분류 서브쿼리 0건 시 별도 메시지·로그가 있는가 (R5)
```

## §3. POST-WRITE 스윕 (전 DB 대상 — 회귀 감시)

```sql
-- ① 취약 변환 (기대 0행)
SELECT NAME, TYPE, LINE FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND UPPER(TEXT) LIKE '%TO_DATE(TO_CHAR(TO_NUMBER(%';

-- ② 표기 기반 행 채택 (기대 0행)
SELECT NAME, LINE FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND TEXT LIKE '%^[0-9.eE+-]+$%';

-- ③ 스테이징 셀에 직접 TO_NUMBER — 업로드 SP 우선 점검 대상 (2026-08-23 실측 상위)
SELECT NAME, COUNT(*) HITS FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND UPPER(TEXT) LIKE '%TO_NUMBER(%ATTRIBUTE1%'
 GROUP BY NAME ORDER BY 2 DESC;
```

2026-08-23 사내 실측: ①은 `PKG_DMF0014` 1건뿐이었고 **정정 완료**(`[E20260823-BUCKETNLS]`).
③은 `PKG_DMF0014` 58 · `PKG_DMF0082` 22 · `DMF0020_EXCEL_UPLOAD` 20 · `PKG_DMF0081` 20 · `PKG_DMF0020` 20 …
= **잠재 노출 목록**(값 칸이 정수 문자열이면 무해, 소수·서식 유입 시 동일 사고). 화면 작업 착수 시 그 SP 부터 R2 로 정리한다.

---

## §4. 사고 계보 — "로컬 정상 / 클라우드 실패" 3형

| 유형 | 관측 | 진짜 원인 |
|---|---|---|
| **배선 메타** | `PLS-00201: identifier 'DMF0014_CUST_FCST_EXCEL_UPLOAD' must be declared` | BE 가 `SCM_ADM_EXCEL_COLUMNS.STORAGE_SQL_ID` 값을 그대로 `CALL` — 그 DB 메타가 구 단독 SP 이름 |
| **NLS·서식** (본 hook) | 전건 `Invalid Measure Upload Bucket.` | 헤더 셀 표기/`NLS_NUMERIC_CHARACTERS` 차이로 파싱 실패 → 분류 서브쿼리 0건 |
| **통계·옵티마이저** | 클라우드만 10배 느림 | `optimizer_dynamic_sampling=0` + GTT 무통계 (별도 계보) |

⇒ **DB 간 차이 진단 0순위 = "그 DB 의 값·설정을 실측" 이다.** 코드만 보면 셋 다 안 보인다.
진단 SQL 정본 = `_artifacts/_deploy_packages/DMF0014_GRAYZERO_CLOUD_20260823/A_DB/00B_DIAG_BUCKET.sql`.
