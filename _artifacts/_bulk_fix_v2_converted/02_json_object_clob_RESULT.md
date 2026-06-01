# Stage 3b — V_IN_PARA_DATA CLOB 일괄 변환 결과

작성: 2026-06-01
관련 Plan: `C:\Users\ejene\.claude\plans\hashed-fluttering-seahorse.md`

## 적용 패치 (확정)

| 파일 | VARCHAR2→CLOB |
|---|---:|
| `04_Package_PKG_DM0000.sql` | 1 |
| `04_Package_PKG_DMF0008.sql` | 6 |
| `04_Package_PKG_DMF0014.sql` | 5 |
| `04_Package_PKG_DMF0042.sql` | 10 |
| `04_Package_PKG_DMF0043.sql` | 8 |
| `04_Package_PKG_DMF0048.sql` | 1 |
| `04_Package_PKG_DMF0049.sql` | 2 |
| `04_Package_PKG_DMF0051.sql` | 1 |
| `04_Package_PKG_DMF0073.sql` | 2 |
| `04_Package_PKG_SCM0007.sql` | 3 |
| `04_Package_PKG_SCM0010.sql` | 2 |
| **합계** | **41** |

## ⚠️ 중요 발견 — Plan 의 가정 정정

| Plan 가정 | 실제 (Oracle 23ai) | 조치 |
|---|---|---|
| `JSON_OBJECT(... RETURNING CLOB)` 추가 필요 | **PL/SQL 에서 PLS-00684 에러** (SQL context 만 허용) | **JSON_OBJECT body 패치 ROLLBACK** |
| DMF0043 prior fix 가 RETURNING CLOB 사용 | DMF0043 DB BODY 에 RETURNING CLOB 0건 | 실제 fix 는 V_IN_PARA_DATA CLOB 선언만 |
| 32 파일 / 166 JSON_OBJECT call 변환 필요 | 11 파일 / 41 V_IN_PARA_DATA 선언만 변환 충분 | 작업 scope 축소 |

## Smoke Test 검증

```sql
DECLARE V_IN_PARA_DATA CLOB;
BEGIN
  V_IN_PARA_DATA := JSON_OBJECT('p_yyyy' VALUE '2026', 'p_division_id' VALUE '81');
  DBMS_OUTPUT.PUT_LINE('OK len=' || DBMS_LOB.GETLENGTH(V_IN_PARA_DATA));
END;
-- 결과: OK len=38
```

Oracle 23ai PL/SQL 은 JSON_OBJECT default 반환값을 CLOB 변수에 implicit 변환 — overflow 회피 달성.

## 안전 검증 절차 (재실행 시)

```
1. python _artifacts/_bulk_fix_v2_converted/02_v_in_para_data_clob_only.py
   # 11 파일 / 41 changes (재실행 시 0)

2. grep -nE "V_IN_PARA_DATA\s+VARCHAR2\(\s*\d+\s*\)" To-be_v2_converted/06_Packages/
   # 결과 0 줄 = 모든 선언 CLOB 으로 전환됨

3. (선택) 영향 SP 11개 DB 재컴파일 — 단 변환 잔존 (PATINDEX/`||1` 등) 으로 다른 PLS 오류 가능
   → Stage 3c/3e 의 보강 후 재시도 권고
```

## 백업

```
_artifacts/_bulk_fix_v2_converted/_backup_2026-06-01_stage3b/
└── 04_Package_PKG_*.sql (57 files)
```

## 폐기된 산출물

- `02_json_object_clob.py` — 잘못된 가정 (RETURNING CLOB) 기반. **사용 금지.**
- 32 파일 / 166 JSON_OBJECT 패치 — Oracle 23ai PL/SQL 거부로 rollback 완료.

## 후속 룰 보강 (Stage 5 후보)

룰 21 §10 또는 룰 24 §6.5 에 다음 룰 추가:
> Oracle 23ai PL/SQL 에서 `JSON_OBJECT(... RETURNING CLOB)` 은 PLS-00684. 4000자 초과 우려 시 받는 변수를 CLOB 으로 선언 (PL/SQL implicit conversion 활용). SQL context 의 SELECT 절은 RETURNING CLOB 허용.
