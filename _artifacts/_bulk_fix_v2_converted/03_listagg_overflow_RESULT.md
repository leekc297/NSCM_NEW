# Stage 3c — LISTAGG ON OVERFLOW TRUNCATE WITH COUNT 일괄 결과

작성: 2026-06-01
관련 Plan: `C:\Users\ejene\.claude\plans\hashed-fluttering-seahorse.md`

## 적용 패치

| 파일 | LISTAGG ON OVERFLOW 추가 |
|---|---:|
| `04_Package_PKG_DMF0027.sql` | 2 |
| `04_Package_PKG_DMF0035.sql` | 4 |
| `04_Package_PKG_DMF0048.sql` | 1 |
| `04_Package_PKG_DMF0053.sql` | 5 |
| `04_Package_PKG_DMF0082.sql` | 1 |
| `04_Package_PKG_NSCM_UI_COM_LOOKUP.sql` | 2 |
| **합계** | **15** |

## ⚠️ 중요 발견 — Oracle LISTAGG 문법 정정

`ON OVERFLOW TRUNCATE [WITH COUNT]` 는 **LISTAGG 인자 안** 에 위치 (WITHIN GROUP 뒤가 아님):

```sql
-- ✅ Oracle 정합 syntax
LISTAGG(col, ',' ON OVERFLOW TRUNCATE WITH COUNT) WITHIN GROUP (ORDER BY ...)

-- ❌ ORA-00923 (FROM keyword not found)
LISTAGG(col, ',') WITHIN GROUP (ORDER BY ...) ON OVERFLOW TRUNCATE WITH COUNT
```

1차 시도는 잘못된 위치 (WITHIN GROUP 뒤) 에 삽입 → 6 파일 rollback 후 정정.

## Smoke Test 검증

```sql
SELECT LISTAGG(OBJECT_NAME, ',' ON OVERFLOW TRUNCATE WITH COUNT)
       WITHIN GROUP (ORDER BY OBJECT_NAME) AS R
  FROM USER_OBJECTS WHERE ROWNUM <= 5;
-- 정상 동작: PR_DM_PLN_..., PR_DM_PLN_..., ...
```

## 안전성

- `ON OVERFLOW TRUNCATE` 는 **defensive** — 정상 입력 (4000자 이하) 시 동작 변경 없음
- 4000자 초과 시 ORA-01489 대신 truncate + (옵션 WITH COUNT) 잘림 표시
- 이미 적용된 LISTAGG 는 skip (idempotent)

## 후속 룰 보강

룰 21 §12 또는 룰 10 §SP 패턴 에 추가:
> Oracle LISTAGG 의 ON OVERFLOW 절은 LISTAGG 인자 안 (delimiter 다음) 에 위치. WITHIN GROUP 뒤가 아님. 모든 LISTAGG 에 `ON OVERFLOW TRUNCATE WITH COUNT` 권고 (4000자 초과 시 ORA-01489 회피).
