# Hook — CMBO_SQL_M `@varName` 치환 + Oracle VARCHAR2 비교 사고 방지

> `SCM_ADM_CMBO_SQL_M` 의 SQL 안에서 `@divisionId` 등 substitution 시 **BE 가 quote 안 함** → VARCHAR2 컬럼 비교 시 ORA-01722.

작성: 2026-06-03 (DMF0020 BP_CUSTOMS_HANDBOOK / BP_FCST_TYPE 사고 후)

---

## §0. 사용자 사고

```
SQL: SELECT SEGMENT2 AS CODE, SEGMENT2 AS NAME
       FROM SCM_ADM_LOOKUP_MASTER_DETAIL
      WHERE LOOKUP_TYPE = 'BP_CUSTOMS_HANDBOOK'
        AND VALID_YN = 'Y'
        AND SEGMENT1 = @divisionId           ← BE 가 81 raw 치환
      ORDER BY DISPLAY_SEQ

→ ORA-01722: '_'을(를) 포함하는 문자열 값을 숫자로 변환할 수 없음: 81_UC
   ORA-03302: (ORA-01722 세부정보) 부적합한 문자열 값: 81_UC
```

**원인 분석**:
1. BE 가 `@divisionId` 의 값 `'81'` 을 **quote 없이 raw 치환** → `SEGMENT1 = 81`
2. `SEGMENT1` 는 VARCHAR2 컬럼, 다른 row 의 값 `'81_UC'` 가 있음
3. Oracle 이 `SEGMENT1 = 81` 비교 시 string → number 변환 시도 → `'81_UC'` 변환 실패 → ORA-01722

## §1. ✅ 올바른 패턴 — `TO_CHAR(@varName)` wrap

```sql
SELECT SEGMENT2 AS CODE, SEGMENT2 AS NAME
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'BP_CUSTOMS_HANDBOOK'
   AND VALID_YN = 'Y'
   AND SEGMENT1 = TO_CHAR(@divisionId)     -- string compare 강제
 ORDER BY DISPLAY_SEQ
```

또는 left side 도 명시:
```sql
WHERE TO_CHAR(SEGMENT1) = TO_CHAR(@divisionId)
```

## §2. BE 자동 채움 변수 — `@varName` 명시 인벤토리

CMBO_SQL_M SQL 의 substitution 변수 (mybatis `#{}` 아님):

| 변수 | 출처 | Quote? | 타입 |
|---|---|---|---|
| `@sesUserId` | 세션 사용자 ID | ❌ raw | string |
| `@sesLangCd` | 세션 언어 | ❌ raw | string |
| `@mnuId` | 메뉴 ID | ❌ raw | string |
| `@divisionId` | useTabComboQueries filters | ❌ raw | string/number 모두 |
| 그 외 화면별 인자 | useTabComboQueries 의 `{comboId: 'X', divisionId: '40'}` | ❌ raw | mixed |

→ **모든 `@varName` 은 quote 없이 raw 치환**. VARCHAR2 비교 시 항상 `TO_CHAR` wrap 의무.

## §3. 동일 패턴 사고 가능 컬럼 인벤토리

VARCHAR2 컬럼인데 **숫자 값** 도 포함되어 있어 number 변환 위험:

| 테이블.컬럼 | 위험 값 (실제 row) |
|---|---|
| `SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT1` | `'40' / '81' / '81_UC' / '81_HM'` |
| `SCM_MST_PROJECT.DIVISION_ID` | `'40' / '81' / '81_HD'` |
| `SCM_MST_SITE.DIVISION_ID` | `'40' / '81' / '81_UC'` |
| `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M.UNIT_ID` | division 외 다른 UNIT 도 함께 |

→ 위 컬럼들과 `@divisionId` 비교 시 항상 `TO_CHAR` wrap.

## §4. PRE-WRITE SQL grep 자기 점검

```bash
# 1. CMBO_SQL_M SQL 작성 시 @varName + VARCHAR2 column 비교 패턴
grep -nE "SEGMENT1\s*=\s*@|DIVISION_ID\s*=\s*@" _artifacts/local-docker-oracle/**/*.sql

# 2. TO_CHAR wrap 누락 검출
grep -nE "@(divisionId|sesUserId|mnuId)" _artifacts/local-docker-oracle/**/*.sql | grep -vE "TO_CHAR\(@"
```

## §5. Oracle 추가 pitfall — `'' = NULL`

```sql
-- ❌ 항상 0 rows (Oracle 의 empty string == NULL → 조건 NULL → false)
WHERE BIZ_TYPE_NAME <> ''

-- ✅ 정확
WHERE BIZ_TYPE_NAME IS NOT NULL
-- 또는
WHERE LENGTH(TRIM(BIZ_TYPE_NAME)) > 0
```

→ MSSQL 의 `<> ''` 그대로 변환 금지. AS-IS T-SQL 변환 시 cross-check 의무.

## §6. cross-ref

- 룰 21 §11 PowerShell 사고 (Oracle 추가 케이스 보강)
- 룰 24 §6.5 AS-IS DB 직접 cross-check (실제 row 값 인벤토리 확인 의무)
- 메모리 `reference_combo_sql_id_inventory.md` 의 SQL 작성 패턴 cross-ref

## §7. 사용자 사고 사례

| 사례 | 사고 | Fix |
|---|---|---|
| DMF0020 CustomsHandbook v1 | `SEGMENT1 = @divisionId` + `<> ''` | `SEGMENT1 = TO_CHAR(@divisionId)` + `IS NOT NULL` |
| DMF0020 FcstType v1 | 동일 | 동일 |
| DMF0020 BizType v1 | `BIZ_TYPE_NAME <> ''` (Oracle '' = NULL → 0 rows) | `IS NOT NULL` 만 |
