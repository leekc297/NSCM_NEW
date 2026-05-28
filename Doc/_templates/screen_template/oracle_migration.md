# [SCREEN_ID] — Oracle 마이그레이션 가이드 (T-SQL → PL/SQL)

> **이 파일의 역할**: 화면이 호출하는 SP/View/Table을 Oracle PL/SQL로 변환할 때의 비호환 패턴과 변환 가이드를 명시. 클로드 코드가 SP를 다시 짤 때 참조.

작성일: YYYY-MM-DD | 매핑된 As-Is: [SCREEN_ID]

---

## 1. 호출 SP 인벤토리

| SP 이름 | 라인 수 | 호출 시점 | Oracle 변환 위험도 |
|---|---|---|---|
| (도메인)0001_GET_DATA | 156 | Search | Low (SELECT only) |
| (도메인)0001_SAVE_DATA | 320 | Save | High (TVP, MERGE, OUTPUT 사용) |
| UP_FX_GetCommonDataList | 45 | Load | Low (TheOne 표준) |

## 2. 비호환 패턴 식별 (이 화면 호출 SP의 본문에서)

| 패턴 | 발견 SP | 라인 수 | Oracle 대체 |
|---|---|---|---|
| `SELECT TOP N ...` | (도메인)0001_GET_DATA | 12 | `WHERE ROWNUM <= N` 또는 `FETCH FIRST N ROWS ONLY` |
| `IDENTITY` 컬럼 | - | 0 | Oracle SEQUENCE + TRIGGER |
| `GETDATE()` | (도메인)0001_GET_DATA, _SAVE_DATA | 5 | `SYSDATE` 또는 `SYSTIMESTAMP` |
| `ISNULL(x, y)` | 다수 | 8 | `NVL(x, y)` 또는 `COALESCE(x, y)` |
| `CONVERT(...)` | (도메인)0001_GET_DATA | 3 | `TO_CHAR()`, `TO_DATE()`, `TO_NUMBER()` |
| `[bracket].[name]` 식별자 | 모든 | 다수 | `"DOUBLE_QUOTE"` 또는 그냥 식별자 |
| `WITH (NOLOCK)` 힌트 | (도메인)0001_GET_DATA | 1 | Oracle은 read consistency 자동 — 제거 |
| CTE (`WITH AS`) | (도메인)0001_SAVE_DATA | 1 | Oracle도 지원 — 그대로 변환 가능 |
| `MERGE INTO ... USING` | (도메인)0001_SAVE_DATA | 1 | Oracle MERGE 지원 — 약간의 syntax 차이 |
| `OUTPUT` 절 | (도메인)0001_SAVE_DATA | 1 | `RETURNING ... INTO` |
| `#temp_table` | (도메인)0001_SAVE_DATA | 2 | Oracle GLOBAL TEMPORARY TABLE 또는 PL/SQL TABLE TYPE |
| TVP (Table-Valued Parameter) | (도메인)0001_SAVE_DATA | input | Oracle은 OBJECT TYPE 또는 PL/SQL ASSOCIATIVE ARRAY |
| `ROWVERSION` / `TIMESTAMP` | - | 0 | Oracle ORA_ROWSCN 또는 별도 version 컬럼 |
| `NEWID()` | - | 0 | `SYS_GUID()` |
| `sp_executesql @sql, @params` | (도메인)0001_GET_DATA | 1 | `EXECUTE IMMEDIATE` |
| `IF @@ROWCOUNT > 0` | 다수 | 다수 | `IF SQL%ROWCOUNT > 0` |
| `RAISERROR(N, ...)` | (도메인)0001_SAVE_DATA | 2 | `RAISE_APPLICATION_ERROR(-2000N, ...)` |
| `TRY...CATCH` | (도메인)0001_SAVE_DATA | 1 | PL/SQL `BEGIN ... EXCEPTION ...` |
| `BEGIN TRAN`/`COMMIT` 명시 | (도메인)0001_SAVE_DATA | 1 | Oracle 자동 트랜잭션 — 명시적 `COMMIT`만 |
| `PRINT '...'` | 일부 | 다수 | `DBMS_OUTPUT.PUT_LINE(...)` |

## 3. 데이터 타입 매핑

| MS SQL 타입 | Oracle 타입 | 변환 주의 |
|---|---|---|
| `INT` / `BIGINT` | `NUMBER(10)` / `NUMBER(19)` | 기본 |
| `BIT` (0/1) | `NUMBER(1)` 또는 `CHAR(1) Y/N` | 변환 정책 결정 필요 |
| `DECIMAL(p,s)` / `NUMERIC` | `NUMBER(p,s)` | 동일 |
| `VARCHAR(N)` | `VARCHAR2(N)` | Oracle 32767 한계 (PL/SQL), 4000 (SQL) |
| `NVARCHAR(N)` | `NVARCHAR2(N)` | 한글은 NVARCHAR2 필수 |
| `DATETIME` / `DATETIME2` | `DATE` 또는 `TIMESTAMP` | DATE는 초 단위, TIMESTAMP는 ms 가능 |
| `MONEY` / `SMALLMONEY` | `NUMBER(19,4)` | |
| `TEXT` / `NTEXT` (deprecated) | `CLOB` / `NCLOB` | |
| `IMAGE` (deprecated) | `BLOB` | |
| `UNIQUEIDENTIFIER` | `RAW(16)` 또는 `VARCHAR2(36)` | |

## 4. 트랜잭션 / 에러 처리 변환 예시

### As-Is (T-SQL)
```sql
CREATE PROCEDURE [dbo].[(도메인)0001_SAVE_DATA]
    @items dbo.tvp_Items READONLY,
    @userId VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN
        MERGE dbo.target_table AS T
        USING @items AS S ON T.id = S.id
        WHEN MATCHED THEN UPDATE SET T.qty = S.qty
        WHEN NOT MATCHED THEN INSERT (id, qty) VALUES (S.id, S.qty)
        OUTPUT $action, INSERTED.id;
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        RAISERROR ('Save failed', 16, 1)
    END CATCH
END
```

### To-Be (PL/SQL)
```sql
CREATE OR REPLACE PROCEDURE pkg_(도메인)0001.save_data (
    p_items   IN  t_items_table,    -- OBJECT TYPE collection
    p_user_id IN  VARCHAR2,
    p_result  OUT SYS_REFCURSOR
) AS
BEGIN
    FORALL i IN INDICES OF p_items
        MERGE INTO target_table T
        USING (SELECT p_items(i).id AS id, p_items(i).qty AS qty FROM dual) S
        ON (T.id = S.id)
        WHEN MATCHED THEN UPDATE SET T.qty = S.qty
        WHEN NOT MATCHED THEN INSERT (id, qty) VALUES (S.id, S.qty);
    
    OPEN p_result FOR
        SELECT id, qty FROM target_table WHERE id IN (SELECT id FROM TABLE(p_items));
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Save failed: ' || SQLERRM);
END save_data;
```

## 5. 호출 View 인벤토리

| View 이름 | 라인 수 | 변환 위험도 |
|---|---|---|
| (도메인)_xxx_V | 156 | Low |
| SCM_DNM_yyy_V | 42 | Low |

## 6. 인덱스·제약 변환

| As-Is | Oracle 변환 | 비고 |
|---|---|---|
| Clustered Index | Oracle Index-Organized Table (IOT) 또는 일반 인덱스 | 성능 검토 필요 |
| Non-clustered Index | 일반 인덱스 | 동일 |
| Filtered Index | Function-based Index | `CREATE INDEX ... ON ... (CASE WHEN ...)` |
| INCLUDE columns | Oracle은 미지원 | Composite index로 |
| Unique constraint | Unique constraint | 동일 |

## 7. 변환 자동화 가능성

| 변환 종류 | 자동 가능 비율 | 도구 |
|---|---|---|
| 데이터 타입 매핑 | 95% | Oracle SQL Developer Migration Workbench |
| 단순 SP (SELECT/INSERT only) | 70~80% | 위 도구 또는 ora2pg |
| 복잡 SP (CTE + 동적 SQL + TRY/CATCH) | 30~50% | 수작업 검토 필수 |
| Identity → Sequence+Trigger | 80% | 도구 |
| 트리거 | 50% | 도구 + 수정 |

## 8. 이 화면의 변환 작업 우선순위

(이 화면이 호출하는 SP·View·Table 수에 따라 결정)

- [ ] 1순위: (도메인)0001_GET_DATA 변환 + 단위 테스트 (입력/출력 동일성 검증)
- [ ] 2순위: (도메인)0001_SAVE_DATA 변환 (TVP → OBJECT TYPE)
- [ ] 3순위: View (도메인)_xxx_V 변환

## 9. 참고

- 변환 패턴 모음: [`/Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md`](../../../_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md) (구 `_vibe_coding/oracle_pl_sql_patterns.md` → `_archive/_vibe_coding/` 로 이관)
- As-Is 분석: [`analysis.md`](./analysis.md)
- 호출 SP 본문: 도메인 sps 폴더 참조 [`/Doc/_analysis/domain_<X>/sps/`](../../sps/)
