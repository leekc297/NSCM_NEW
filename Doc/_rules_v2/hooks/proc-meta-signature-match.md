# Hook — PROC_M ↔ 실제 SP signature (ALL_ARGUMENTS) 일치 의무 + FE filter key 매핑

> **트리거**: 신규 SP 작성 또는 SCM_ADM_PROC_M 메타 등록 시
>
> **목적**: PROC_M 의 COL_NM/SORT_ORD/COL_TP_CD 가 SP 실제 IN/OUT 인자와 positional + 갯수 일치 강제 → PLS-00306 (인수 갯수/유형 오류) 차단

작성: 2026-06-09 (SCM0005 DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST 사고: PROC_M 2 row vs SP 7 인자 → PLS-00306)
관련 룰: `_tobe/11_be_controller_service.md`, `_tobe/12_metadata_sql.md`
상위 룰: `anti-simplification.md`

---

## §0. 사고 (2026-06-09)

### §0.1 SCM0005 DynamicQuery PLS-00306

```sql
-- 실제 SP signature (ALL_ARGUMENTS):
P_DQ_ID / P_DQ_NAME / P_ROLE / P_USER_ID / P_MNU_ID + O_RC1 + O_RESULT_CURSOR  (5 IN + 2 OUT)

-- PROC_M 등록 (잘못):
divisionId IN / O_RC1 OUT                                                       (1 IN + 1 OUT)
```

→ MyBatis 가 PROC_M positional 로 binding → 인수 갯수 부족 → **PLS-00306: 인수의 갯수나 유형이 잘못되었습니다**.

### §0.2 SCM0005 FE filter key mismatch

```ts
// FE store
state.filters[SHEETS.COLUMNS] = { queryId: id };  // ← 'queryId'

// PROC_M (COLUMNS SP)
COL_NM = 'dqId'                                   // ← 'dqId'
```

→ MyBatis 가 `#{dqId}` placeholder 에 FE 의 `queryId` 못 찾음 → NULL bind → SP 가 NULL 받고 0 row 반환.

### §0.3 SYS0013 HISTORY cross-sheet 일관성 사고 (2026-06-15) ⭐

같은 store 의 3 시트 (COLUMNS / PARAMETERS / HISTORY) 가 같은 SP IN param (`P_DQ_ID`) 받는데, **HISTORY 만 다른 별칭** 사용:

```ts
state.filters[SHEETS.COLUMNS]    = { dqId: id };      // ✅
state.filters[SHEETS.PARAMETERS] = { dqId: id };      // ✅
state.filters[SHEETS.HISTORY]    = { queryId: id };   // ❌ alias
// 주석: "HISTORY SP 는 'queryId' (P_QUERYID)" ← 추측 기반 — 실제 SP body 는 P_DQ_ID
```

→ HISTORY tab 의 BE 가 `queryId` 무시 → `P_DQ_ID=NULL` → SP WHERE `(P_DQ_ID IS NULL OR DQ_ID=P_DQ_ID)` 항상 true → **선택 query 무관 전체 history 반환** (모든 query 선택 시 같은 항목 표시).

**근본 원인**: SP signature 추측 + 주석에 잘못된 가정 (`P_QUERYID`) 명시. 실제 SP body 확인 누락.

### §0.4 SYS0012 클라우드 "순서 뒤틀림 = silent 0행" 사고 (2026-07-02) ⭐

PROC_M **행수 9 = SP 인자 9 (개수 정합)** 인데 COL_NM **순서만 뒤틀림**:

```
클라우드 PROC_M 2~7: divisionId, userId, department, startDate, endDate, status
사내 정상       2~7: userId, startDate, endDate, status, divisionId, department
```

전부 VARCHAR → **PLS-00306 없이 SP 정상 실행** — `P_STATUS` 에 시작일이 꽂혀 상태 분기 전멸 → **오류 없는 항상 0행**.

**교훈 3가지**:
1. 검증은 행수 카운트(§3.1)만으로 부족 — **위치별 COL_NM 이름까지 기대값과 대조** (아래 §3.4)
2. ⚠ **PK_SCM_ADM_PROC_M = (PROC_NM, COL_NM, COL_TP_CD)** — 순서 교정 시 `COL_NM 을 UPDATE` 하면
   같은 SP 의 다른 행과 충돌 → **ORA-00001**. 교정 표준:
   - ✅ **단일 CASE UPDATE 로 SORT_ORD 스왑** (Oracle 문장 단위 일관성 — swap 안전):
     ```sql
     UPDATE SCM_MGR.SCM_ADM_PROC_M
        SET SORT_ORD = CASE COL_NM WHEN 'userId' THEN 2 WHEN 'startDate' THEN 3 ... END
      WHERE PROC_NM='P_XXX' AND COL_NM IN (...);
     ```
   - ✅ 이관 스크립트는 **SP 단위 DELETE 후 INSERT** (PK 구조 무관·멱등)
   - ❌ `MERGE ON (PROC_NM, SORT_ORD) WHEN MATCHED UPDATE COL_NM` — ORA-00001
3. BE 는 매 요청 PROC_M 재조회(`GeneralServiceImpl.callProc/execBtn` → `makeProcedure`, 캐시 없음)
   → 교정 **COMMIT 즉시 반영, BE 재시작 불필요**

---

## §1. 의무 패턴

### §1.1 PROC_M 등록 = SP signature 1:1 매핑

| PROC_M 컬럼 | SP signature |
|---|---|
| `COL_NM` | SP IN/OUT param 이름 → camelCase 변환 (P_USER_ID → sesUserId, P_DQ_ID → dqId) |
| `COL_TP_CD` | `'IN'` / `'OUT'` (SP IN_OUT) |
| `DATA_TP_CD` | `'VARCHAR'` / `'NUMBER'` / `'CLOB'` / `'CURSOR'` / `'PROC_RESULT'` |
| `SORT_ORD` | **SP POSITION 과 정확 일치** (positional binding) |

### §1.2 BE 자동 채움 키 (FE 미전송 — 표준)

| SP 인자 | PROC_M COL_NM | BE 동작 |
|---|---|---|
| P_USER_ID / P_SES_USER_ID | `sesUserId` | session 의 userId 자동 |
| P_MNU_ID | `mnuId` | 현재 menu id 자동 (FE request body) |
| P_LANG_CD | `sesLangCd` | session lang 자동 |
| P_CREATED_BY | `createdBy` | session userId 자동 (As-Is 변환 SP 대응 — 2026-06-06 추가) |
| P_LAST_UPDATED_BY | `lastUpdatedBy` | session userId 자동 (As-Is 변환 SP 대응 — 2026-06-06 추가) |

> ⚠️ **자동 채움 표준 위치**: `nscm-be/src/main/java/com/lgcns/nscm/framework/dao/NDaoInterface.java:430-441` 의 `_selectList()` 메서드. 신규 키 추가 시 이 한 곳만 수정 (다른 위치 분산 금지).

### §1.3 FE filter key = PROC_M COL_NM 정확 일치

```ts
// ✅ 의무 — PROC_M COL_NM 과 동일 key
state.filters[SHEETS.COLUMNS] = { dqId: id };  // SP P_DQ_ID → COL_NM='dqId'
```

```ts
// ❌ 금지 — 임의 명명 (FE 의도와 SP 시그니처 불일치)
state.filters[SHEETS.COLUMNS] = { queryId: id };
```

### §1.4 ⭐ Cross-sheet 일관성 (2026-06-15 SYS0013 사고 후 신설)

같은 store 의 여러 시트가 **같은 SP IN param** 받을 때 **모든 시트 동일 key 사용 의무**:

```ts
// ✅ 의무
setSelectedQueryId: id => {
  state.filters[SHEETS.COLUMNS]    = { dqId: id };
  state.filters[SHEETS.PARAMETERS] = { dqId: id };
  state.filters[SHEETS.HISTORY]    = { dqId: id };  // 같은 P_DQ_ID 받으면 같은 key
}
```

```ts
// ❌ 금지 — 시트별 별칭 (BE 가 무시 → SP param=NULL → 전체 반환)
state.filters[SHEETS.HISTORY] = { queryId: id };
```

**PRE-WRITE 의무**:
1. store 의 `setSelectedXxx` 작성 전 분배 대상 시트별 SP signature cross-check
2. 각 SP 의 `P_*` IN param 추측 금지 — `USER_ARGUMENTS` 또는 SP body 직접 확인
3. 주석에 "SP 의 P_XXX" 추측 작성 금지 — fact 만 작성

**POST-WRITE 검증 grep**:
```bash
# store 의 filter 분배 key 인벤토리
grep -E 'state\.filters\[SHEETS\.\w+\]\s*=\s*\{\s*\w+:' useXxxStore.ts | sort -u
# 같은 의미인데 key 다른 line 발견 시 의도 vs 사고 판단
```

**관련 메모리**:
- `feedback_fe_filter_key_cross_sheet_consistency.md` (2026-06-15 SYS0013)

### §1.4 Dual cursor (GET SP)

```sql
-- SP body
OPEN O_RC FOR  SELECT ...  ;            -- 메인 데이터
OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;

-- PROC_M (마지막 2 행 의무)
('P_...', 'o_rc',           'OUT', 'CURSOR',      N,   ...)  -- ⭐ 소문자
('P_...', 'O_RESULT_CURSOR','OUT', 'PROC_RESULT', N+1, ...)  -- ⭐ 대문자
```

---

## §2. PRE-WRITE 자기 점검

```
☐ SP 실제 인자 수 확인 (ALL_ARGUMENTS POSITION DESC)?
  SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION
    FROM ALL_ARGUMENTS
   WHERE OWNER='SCM_MGR' AND OBJECT_NAME='P_XXX'
   ORDER BY POSITION;

☐ PROC_M INSERT 행 수 = SP IN/OUT 인자 합계 + 1 (O_RESULT_CURSOR 추가) 일치?
☐ SORT_ORD 가 SP POSITION 과 정확 일치 (positional binding)?
☐ FE store 의 filter key = PROC_M COL_NM 매칭?
☐ BE 자동 채움 키 (sesUserId/sesLangCd/mnuId/createdBy/lastUpdatedBy) 정확 사용?
```

---

## §3. POST-WRITE 자동 검증 SQL

### §3.1 PROC_M ↔ SP 인자 갯수 diff 검출

```sql
SELECT p.PROC_NM,
       (SELECT COUNT(*) FROM ALL_ARGUMENTS a
         WHERE a.OWNER='SCM_MGR' AND a.OBJECT_NAME=p.PROC_NM) AS SP_ARGS,
       COUNT(*) AS PROC_M_ROWS
  FROM SCM_MGR.SCM_ADM_PROC_M p
 WHERE p.PROC_NM LIKE 'P_SYS%' OR p.PROC_NM LIKE 'DMF%' OR p.PROC_NM LIKE 'PKG_%'
 GROUP BY p.PROC_NM
HAVING COUNT(*) <> (SELECT COUNT(*) FROM ALL_ARGUMENTS a
                     WHERE a.OWNER='SCM_MGR' AND a.OBJECT_NAME=p.PROC_NM);
-- 결과 = 0 의무 (모든 PROC_M ↔ SP 인자 갯수 일치)
```

### §3.2 FE filter key ↔ PROC_M COL_NM 매핑 검증

```bash
# FE 의 store filter 객체에서 key 추출
grep -nE "state\.filters\[.*\]\s*=\s*\{[^}]+\}" "useXxxStore.ts"
# → 각 key 가 PROC_M COL_NM 에 존재하는지 수동 cross-check
```

### §3.3 PLS-00306 발생 시 (BE log)

```
ORA-06550 PLS-00306: '{SP_NAME}' 호출 시 인수의 갯수나 유형이 잘못되었습니다
```

→ 즉시 §3.1 SQL 실행 + PROC_M 재등록 (`DELETE + INSERT positional 정확`).

### §3.4 ⭐ 위치+이름 대조 (순서 뒤틀림 검출 — §0.4 사고 후 신설, 이관/진단 의무)

```sql
WITH EXPECT (POS, COL_NM) AS ( /* 정상(사내) 순서를 기대값으로 나열 */
    SELECT 1,'sesUserId' FROM DUAL UNION ALL SELECT 2,'userId' FROM DUAL /* ... */ )
SELECT E.POS, A.ARGUMENT_NAME SP_ARG, P.COL_NM PROC_M_COL, E.COL_NM EXPECTED_COL,
       CASE WHEN A.POSITION IS NULL THEN '*** SP 인자 없음'
            WHEN P.SORT_ORD IS NULL THEN '*** PROC_M 행 없음'
            WHEN P.COL_NM <> E.COL_NM THEN '*** 순서/이름 뒤틀림'
            ELSE 'OK' END CHK
FROM EXPECT E
LEFT JOIN (SELECT POSITION, ARGUMENT_NAME FROM ALL_ARGUMENTS
            WHERE OWNER='SCM_MGR' AND OBJECT_NAME='{SP}' AND PACKAGE_NAME IS NULL) A ON A.POSITION=E.POS
LEFT JOIN (SELECT SORT_ORD, COL_NM FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='{SP}') P ON P.SORT_ORD=E.POS
ORDER BY E.POS;
-- 9행 전부 CHK='OK' 의무 (실전본: SYS0012_APPROVAL_20260702/90_DIAGNOSE/900_cloud_diagnose_search.sql)
```

---

## §4. PR 머지 게이트

- [ ] 모든 SP 의 PROC_M 행 수 = ALL_ARGUMENTS 인자 수 일치
- [ ] PROC_M SORT_ORD = SP POSITION 정확 일치
- [ ] FE store filter key = PROC_M COL_NM 정확 일치 (`__asis-mapping__.md ## PROC_M 매핑` 표 의무)
- [ ] BE 자동 채움 키 (sesUserId/sesLangCd/mnuId/createdBy/lastUpdatedBy) 정확 사용 (custom naming 금지)

---

## §5. anti-pattern 인벤토리

| 잘못된 패턴 | 결과 |
|---|---|
| PROC_M 행 수 < SP 인자 수 | PLS-00306 (인수 갯수 부족) |
| PROC_M SORT_ORD 가 SP POSITION 과 불일치 | type mismatch (예: VARCHAR 자리에 CURSOR) |
| FE filter `{queryId: id}` ↔ PROC_M COL_NM `dqId` | BE binds NULL → SP 0 row 반환 |
| SP P_USER_ID 자리에 임의 COL_NM (예: `userId`) | BE 자동 채움 안 됨 → NULL → 권한 체크 fail |
| 행수 동일 + COL_NM **순서만 뒤틀림** (전부 VARCHAR) | **에러 없는 silent 0행** (값이 엉뚱한 인자에 bind — SYS0012 §0.4) |
| 순서 교정을 `COL_NM UPDATE` 로 시도 | ORA-00001 (PK=(PROC_NM,COL_NM,COL_TP_CD)) → SORT_ORD CASE 스왑/DELETE+INSERT |

---

## §6. cross-ref

| 항목 | 룰 |
|---|---|
| PROC_M COL_NM 매핑 표 | `_tobe/12_metadata_sql.md` §2.4 |
| dual cursor | hook `sp-dual-cursor-pattern.md` |
| 메모리 | `feedback_proc_meta_must_match_sp_signature`, `feedback_fe_filter_key_match_proc_meta` |

---

## §7. 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-09 | 초안 작성 | SCM0005 DMF0027 PLS-00306 + filter key mismatch 사고 |
| 2026-07-02 | §0.4/§3.4 신설 + anti-pattern 2건 | SYS0012 클라우드 "순서 뒤틀림 silent 0행" + ORA-00001 교정 사고 |
