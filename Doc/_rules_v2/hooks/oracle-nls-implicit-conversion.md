# Hook #109 — oracle-nls-implicit-conversion (암묵 형변환 = 세션 NLS 의존 폭탄) ⭐ 2026-07-08 신설

> **트리거**: ORA-01861 / ORA-01843 / ORA-01722 / "로컬은 되는데 클라우드만 실패" / -9994 / InvocationTargetException / TO_DATE / DATE 파라미터
> **사고**: DMF0014 저장 — 클라우드 WAS 에서만 -9994 (2026-07-08). 진짜 원인 = `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` L1322
> `FN_NEXT_DAY(N_MIN_YYYYMMDD, 'MON')` — DATE 파라미터에 'YYYYMMDD' 문자열 직접 전달 → **암묵 TO_DATE(마스크 없음) = 세션 NLS_DATE_FORMAT 의존** → 클라우드 WAS(Linux JVM) 세션에서만 ORA-01861.
> 상위: `oracle-db-workflow.md` §0-E / 부록 `01_MSSQL_to_Oracle_Conversion_Rules.md` **C-11**

---

## §1. 왜 "로컬은 되는데 클라우드만" 인가 (판정 시그니처)

암묵 날짜/숫자 변환은 **세션**의 NLS(NLS_DATE_FORMAT / NLS_NUMERIC_CHARACTERS)에 의존한다.
같은 SP 라도 세션마다 결과가 다르다:

| 세션 | NLS | 결과 |
|---|---|---|
| SQL 클라이언트 직접 호출 | 클라이언트 설정 | 통과 (SP 무결처럼 보임) |
| 로컬 BE (한국어 Windows JVM) | 파싱 가능 포맷 | 통과 |
| **클라우드 BE (WAS Linux JVM)** | 상이 | **ORA-01861 폭발** |

→ **"SP 직접호출 OK + 로컬 BE OK + 클라우드 BE 만 실패" = NLS 암묵 변환 1순위 의심.**
권한/BE 빌드로 단정 금지 (2026-07-08 사고에서 GRANT/시노님/PROC_M/BE빌드 전수 배제 후에야 도달 — 이 hook 으로 첫 수에 확인할 것).

## §2. 금지/의무 (SP 작성·변환 시)

1. ❌ **DATE 파라미터 함수/프로시저에 문자열·숫자 직접 전달 금지** — `FN_NEXT_DAY(v_yyyymmdd, ...)` ✗
   ✅ `FN_NEXT_DAY(TO_DATE(v_yyyymmdd, 'YYYYMMDD'), ...)`
2. ❌ **단일 인자 `TO_DATE(x)` / `TO_CHAR(date)`(비교용) 금지** — 항상 명시 마스크.
3. ❌ VARCHAR 컬럼 ↔ DATE 값 암묵 비교 금지.
4. `NEXT_DAY(d,'MON')` 류 **요일명 리터럴 = NLS_DATE_LANGUAGE 의존** — 사내 표준은 `FN_NEXT_DAY`(ISO 주 기반, NLS 비의존) 사용.
5. `TO_NUMBER(x)`(소수점 포함 문자열) = NLS_NUMERIC_CHARACTERS 의존 — 과학표기('2.0260706E7') 처리 시 유의.

## §3. 진단·수정 절차 (사고 재발 시)

1. 실오류 확보: `-9994`/`InvocationTargetException: null` 은 래퍼 —
   **`SCM_COM_SYS_LOG.EXCT_MSG_CTN`** (MNU_ID+시각 조회) 또는 BE 콘솔 `Caused by:` 에 전체 ORA 체인이 있음
   (`SCM_COM_SQL_LOG.EXCEPTION` 은 null 로 잘림 — 판정에 쓰지 말 것). 상세: `sp-exception-handler-debug-friendly.md` §4.5.
2. BACKTRACE 라인의 소스에서 암묵 변환 검출.
3. 수정 = 명시 마스크 1줄 최소 diff (사고 정본: `12_PR_DM_PLN_NLS_FIX.sql`).
4. ⭐ **sweep 의무** (anti-simplification): 같은 객체 전체에서 동종 함정 전수 검색 후 일괄 판정.

```sql
-- DATE 파라미터 함수 호출부 원시값 전달 (예: FN_NEXT_DAY)
SELECT line, text FROM user_source
 WHERE name='{OBJ}' AND UPPER(text) LIKE '%FN_NEXT_DAY%'
   AND UPPER(text) NOT LIKE '%TO_DATE%' AND UPPER(text) NOT LIKE '%SYSDATE%';
-- 단일 인자 TO_DATE
SELECT line, text FROM user_source
 WHERE name='{OBJ}' AND REGEXP_LIKE(text, 'TO_DATE\s*\(\s*[A-Za-z_.]+\s*\)', 'i');
```

5. **사내+클라우드 동시 배포 의무** — 사내는 세션 NLS 가 우연히 맞아 "동작 중"이어도 동일 잠재 결함.

## §4. 자기 점검

```
✅ DATE 파라미터 호출부 전수 grep — 원시값 전달 0건?
✅ 단일 인자 TO_DATE/TO_CHAR 0건?
✅ fix 는 명시 마스크 최소 diff (원본 백업 + 사내·클라우드 동시)?
✅ "클라우드만 실패" 신고 시 이 hook 1순위 적용했나? (권한 단정 금지)
```

> Cross-ref: 부록 C-11 / oracle-db-workflow §3 / sp-exception-handler-debug-friendly §4.5 / 메모리 `feedback_invocationtargetexception_null_hides_real_error`
