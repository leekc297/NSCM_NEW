# Hook — Oracle GET SP `o_rc` + `O_RESULT_CURSOR` Dual OUT Cursor 표준

> **트리거**: 신규 GET (조회) SP 작성 또는 PROC_M 등록 시
>
> **목적**: BE 응답 JSON 의 cursor key 가 FE 의 `RESPONSE_SET.OUTPUT = 'o_rc'` 와 일치하도록 dual OUT cursor 표준 강제

작성: 2026-06-06 (SCM0009 P_SYS0012_GET_APPROVAL_LIST 단일 cursor → FE `data.o_rc` undefined → grid 빈 표시 사고)
관련 룰: `_tobe/11_be_controller_service.md`, `_tobe/12_metadata_sql.md`
상위 룰: `anti-simplification.md`

---

## §0. 사고 (2026-06-06)

### §0.1 SCM0009 단일 cursor 사고

```sql
-- ❌ 위반 (단일 OUT cursor)
CREATE OR REPLACE PROCEDURE P_SYS0012_GET_APPROVAL_LIST (
    P_USER_ID       IN  VARCHAR2,
    ...
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
```

```sql
-- ❌ PROC_M 도 단일
INSERT INTO SCM_ADM_PROC_M VALUES ('P_SYS0012_GET_APPROVAL_LIST','O_RESULT_CURSOR','OUT','PROC_RESULT',...);
```

**결과**:
- BE 응답: `{ "O_RESULT_CURSOR": [...] }`
- FE: `data?.o_rc` → **undefined** → grid 빈 표시
- 사용자 보고: "데이터가 조회되지 않습니다"
- BE 로그에서는 5 rows 정상 반환 확인 (FE 가 못 읽음)

### §0.2 SCM0011 표준 (정상 동작)

```sql
-- ✅ 표준 dual cursor
CREATE OR REPLACE PROCEDURE PKG_SYS0011.P_SYS0011_GET_AUTH_DATA (
    O_RC            OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
```

```sql
-- ✅ PROC_M 도 dual
INSERT INTO SCM_ADM_PROC_M VALUES
  ('PKG_SYS0011.P_SYS0011_GET_AUTH_DATA', 'o_rc',           'OUT', 'CURSOR',      1, ...),
  ('PKG_SYS0011.P_SYS0011_GET_AUTH_DATA', 'O_RESULT_CURSOR','OUT', 'PROC_RESULT', 2, ...);
```

→ BE 응답: `{ "o_rc": [...], "O_RESULT_CURSOR": [{"CODE":"0","MSG":"SUCCESS"}] }`
→ FE: `data?.o_rc` ✓

---

## §1. 표준 (의무)

### §1.1 GET SP signature

```sql
CREATE OR REPLACE PROCEDURE SCM_MGR.P_{MENU_ID}_{ACTION} (
    P_SES_USER_ID    IN  VARCHAR2,
    P_{FILTER1}      IN  VARCHAR2,
    P_{FILTER2}      IN  VARCHAR2,
    ...
    O_RC             OUT SYS_REFCURSOR,   -- ⭐ 데이터 cursor (소문자 매핑)
    O_RESULT_CURSOR  OUT SYS_REFCURSOR    -- ⭐ 결과 상태 cursor (CODE/MSG)
)
AS
BEGIN
    OPEN O_RC FOR
        SELECT ... FROM ... ;   -- 메인 데이터

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        DECLARE V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
        BEGIN
            OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;  -- 빈 cursor
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
        END;
END;
/
```

### §1.2 PROC_M 등록 (의무 2 행)

```sql
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, ...) VALUES
  ('P_{MENU_ID}_{ACTION}', 'sesUserId',       'IN',  'VARCHAR',     1, ...),
  ('P_{MENU_ID}_{ACTION}', '{filter1}',       'IN',  'VARCHAR',     2, ...),
  ...
  ('P_{MENU_ID}_{ACTION}', 'o_rc',            'OUT', 'CURSOR',      N,   ...),  -- ⭐ COL_NM 소문자
  ('P_{MENU_ID}_{ACTION}', 'O_RESULT_CURSOR', 'OUT', 'PROC_RESULT', N+1, ...);  -- ⭐ COL_NM 대문자
```

| COL_NM | DATA_TP_CD | 비고 |
|---|---|---|
| `o_rc` (소문자) | `CURSOR` | 메인 데이터 cursor. **FE 가 `data.o_rc` 로 읽음** |
| `O_RESULT_CURSOR` (대문자) | `PROC_RESULT` | 결과 상태 cursor. FE 는 보통 무시 (BE 가 error 처리에 활용) |

### §1.3 SAVE / MUTATION SP 는 단일 cursor 도 허용

SAVE/INSERT/UPDATE/DELETE 같은 mutation SP 는 데이터 반환이 없으므로:

```sql
CREATE OR REPLACE PROCEDURE P_{MENU_ID}_SAVE_{ACTION} (
    P_SES_USER_ID    IN  VARCHAR2,
    P_DATA           IN  CLOB,
    O_RESULT_CURSOR  OUT SYS_REFCURSOR   -- 단일 cursor OK (mutation 응답)
)
```

PROC_M:
```sql
('P_{MENU_ID}_SAVE_{ACTION}', 'O_RESULT_CURSOR', 'OUT', 'PROC_RESULT', N, ...)
```

→ FE 는 mutation 의 onSuccess 만 사용 (data 응답 안 봄). 단일 cursor 충분.

---

## §2. PRE-WRITE 자기 점검

```
☐ GET SP 인가? (조회 결과 cursor 반환 필요?)
  → YES: O_RC + O_RESULT_CURSOR 2 OUT 의무
  → NO (mutation): O_RESULT_CURSOR 1 OUT 만

☐ PROC_M COL_NM 'o_rc' (소문자) 사용?
  → 'O_RC' 대문자 또는 'o_result_cursor' 소문자 = 위반

☐ FE 의 RESPONSE_SET.OUTPUT 값 확인?
  → 'o_rc' 인 경우 SP/PROC_M 도 'o_rc' 일치 필수
```

---

## §3. POST-WRITE 자동 검증 SQL

```sql
-- GET SP 중 dual cursor 누락 검출
SELECT PROC_NM,
       SUM(CASE WHEN COL_NM='o_rc'            THEN 1 ELSE 0 END) AS HAS_O_RC,
       SUM(CASE WHEN COL_NM='O_RESULT_CURSOR' THEN 1 ELSE 0 END) AS HAS_RESULT,
       SUM(CASE WHEN COL_TP_CD='OUT'          THEN 1 ELSE 0 END) AS OUT_COUNT
  FROM SCM_ADM_PROC_M
 WHERE PROC_NM LIKE 'P_%_GET_%'
    OR PROC_NM LIKE 'PKG_%_GET_%'
 GROUP BY PROC_NM
HAVING SUM(CASE WHEN COL_NM='o_rc' THEN 1 ELSE 0 END) = 0;  -- 위반 SP 목록
-- 기대: 0 rows
```

### §3.1 FE 응답 검증 (브라우저 콘솔)

```javascript
// SCM 화면에서 F12 → Console
// useTabProcQuery 결과 확인
// data 객체에 o_rc 키가 있는지 확인
```

---

## §4. PR 머지 게이트

- [ ] 모든 GET SP 는 O_RC + O_RESULT_CURSOR 2 OUT 의무
- [ ] PROC_M COL_NM 정확히 `o_rc` (소문자) + `O_RESULT_CURSOR` (대문자)
- [ ] `__asis-mapping__.md ## SP 변환` 표에 cursor 패턴 명시

---

## §5. anti-pattern 인벤토리

| 잘못된 패턴 | 결과 |
|---|---|
| 단일 `O_RESULT_CURSOR` 만 | FE `data.o_rc` undefined → grid 빈 표시 |
| `O_RC` (대문자) COL_NM | BE 응답 key 가 `O_RC` 됨 → FE `data.o_rc` 못 읽음 (case-sensitive JSON key) |
| `o_result_cursor` (소문자) | BE 응답 key 가 `o_result_cursor` → 표준 위반 |
| SP OUT 2 개인데 PROC_M 1 개만 등록 | MyBatis 바인딩 오류 → SP 호출 실패 |

---

## §6. cross-ref

| 항목 | 룰 |
|---|---|
| GET SP 표준 구조 | `_tobe/11_be_controller_service.md` §dual-cursor (신규) |
| PROC_M 의 COL_NM 매핑 표 | `_tobe/12_metadata_sql.md` §PROC_M 표준 |
| FE RESPONSE_SET 정의 | `_tobe/05_constants.md` |
| 메모리 | `feedback_sp_dual_out_cursor_pattern` |

---

## §7. 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-06 | 초안 작성 | SCM0009 P_SYS0012_GET_APPROVAL_LIST 사고 |
