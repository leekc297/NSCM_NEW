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

## §5. ⭐ 2026-08-25 증보 — DATE 파라미터 함수 호출 = 명시 TO_DATE 선행 의무 (사용자 확정)

> 사용자 지시 (2026-08-25): "DATE 의 경우 로컬에서 사용하는 오라클과 클라우드에서 사용하는 오라클의
> DATE 선언이 달라 **정확한 형변환을 먼저 진행한 후에 사용**하도록 해야 합니다."

### 실사고 (DMF0074 Excel Form, 2026-08-25 — 본 hook 판정 시그니처 그대로 재발)

- 증상: 클라우드 DMF0074 Excel Form 조회 시 "다운로드할 템플릿 대상 데이터가 없습니다" —
  실제로는 0건이 아니라 **SP 가 ORA-01861 로 죽고 FE 가 에러 커서를 0건으로 오표시**.
- 원인: `PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE` L601·605·606 이
  `FN_NEXT_DAY(A.YYYYMMDD, 'MON')` 로 **VARCHAR2 를 DATE 파라미터에 직접 전달** (함수 시그니처 `P_DATEVAL IN DATE`).
- NLS 실증 (사내 재현): 세션 `NLS_DATE_FORMAT` 별 `FN_NEXT_DAY('20260821','MON')` 결과 —
  `RR/MM/DD`(사내 세션)=우연히 통과 / `YYYY-MM-DD`=통과 / **`DD-MON-RR`(클라우드 BE JVM)=ORA-01861**.
  → "사내 정상 = 안전" 이 아니다. 세션 포맷 복불복일 뿐.
- 같은 PKG 의 L1022~1026(EXCEL_UPLOAD proc)은 이미 `FN_NEXT_DAY(TO_DATE(A.YYYYMMDD,'YYYYMMDD'),...)`
  올바른 패턴 — **한 패키지 안에 두 패턴이 공존**했고 템플릿 쪽만 누락. 부분 정정의 전형.

### 의무 (기존 §2 강화)

1. **DATE 파라미터를 받는 함수/프로시저 호출부의 인자가 VARCHAR2/NUMBER 면 무조건
   `TO_DATE(x, '명시마스크')` 를 먼저 감싼다** — `FN_NEXT_DAY`·`NEXT_DAY`·`ADD_MONTHS`·
   `MONTHS_BETWEEN`·자체 FN_* 전부. 컴파일은 VALID 로 통과하므로 컴파일 검증으로는 못 잡는다.
2. **전수 스캔 게이트** (신규 SP 작성·기존 SP 수정 시):
   ```sql
   SELECT NAME, TYPE, LINE, TEXT FROM ALL_SOURCE
   WHERE  OWNER='SCM_MGR'
     AND  REGEXP_LIKE(TEXT, 'FN_NEXT_DAY\s*\(\s*[A-Za-z_.]*YYYYMMDD')  -- TO_DATE 미선행 호출
     AND  NOT REGEXP_LIKE(TEXT, 'FN_NEXT_DAY\s*\(\s*TO_DATE');
   ```
3. **검증은 클라우드 조건 세션으로**: `ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR'` +
   `NLS_LANGUAGE='AMERICAN'` 후 SP 실호출 — 이 세션에서 통과해야 완료 (사내 기본 세션 통과는 무의미).
4. FE 오표시 짝: SP 예외 시 FE 가 "데이터 없음" 류 메시지로 가리는 화면은 **예외 원문 확인이 0순위**
   (`SCM_SYS_LOG_BATCH.SQL_ERR_CODE/SQL_ERR_MSG/SQL_BACKTRACE` — DESCRIPTION 아님).

### 잔여 동일 패턴 인벤토리 (2026-08-25 전수 스캔 — 정정 대기, 소급은 화면 작업 시점)

| 객체 | 건수 | 비고 |
|---|---:|---|
| PKG_DMF0022 | 7 | Waterfall 계열 |
| PKG_DMF0048 | 6 | Sales Monitoring |
| PKG_DMF0020 | 3 | Sales Price (DMF0074 형제 — 동일 CTE 계보) |
| PKG_DMF0044 | 1 | Sales Reports |
| PKG_DMF0074 | ~~3~~ **0** | ✅ 2026-08-25 정정 (E20260825-DATECONV) |
| 기타 standalone (DMF0022/0035/0074 구본·PR_SCP_OPT 등) | 다수 | 미배선 레거시 여부 확인 후 판단 |

## §6. ⭐⭐ 2026-08-27 증보 — 동적 SQL 안의 `CAST(문자 AS DATE)` = 클라우드 BE 세션만 ORA-01861 (사용자 명시)

> 사용자 원문: "동적 SQL 내에서 일자변환에 대해서 정확한 형변환 문장이 있어야 합니다."

### 실사고 (DMF0040 클라우드, 2026-08-27)
- `PKG_DMF0040` 동적 SQL 7곳 `TO_CHAR(FN_NEXT_DAY(CAST(F.CUTOFF_YYYYMMDD AS DATE),'MON')-7,'YYYYMMDD')` — `CUTOFF_YYYYMMDD` 는 VARCHAR2 'YYYYMMDD'.
- SCM_MGR DBeaver 재현·사내 BE 는 통과, **클라우드 BE JDBC 세션(`NLS_DATE_FORMAT='DD-MON-RR'`) 만** `ORA-01861 @ DBMS_SQL` → 화면 "SQL ERROR".
- 정정 `[E20260827-NLSDATE]`: `TO_DATE(F.CUTOFF_YYYYMMDD,'YYYYMMDD')`. 같은 스윕에서 DMF0014 `PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40` 의 `CAST(A.SUMMARY_BUCKET_VALUE AS DATE)` 1곳 선제 정정.

### 의무
1. 동적 SQL(문자열로 조립되는 SQL) 안의 문자→DATE 는 **예외 없이 `TO_DATE(x,'마스크')`**. `CAST(x AS DATE)` 는 문자 인자에 대해 ⛔ (SYSTIMESTAMP/NULL 인자만 허용).
2. 검증은 **클라우드 NLS 모사 세션**으로: `ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR'` 후 (a) ASIS 식 재현 실패 (b) 정정 식·정정 SP 통과. `RR/MM/DD`·`YYYY-MM-DD` 는 4자리 연도를 관용 허용해 **재현되지 않으므로 검증 근거로 쓰지 않는다** (정본 `_artifacts/_diagnostics/dmf0040_nlsdate_verify.py`).
3. 이관 패키지 생성 시 동봉 SP 원문 NLS 스캔 0건 게이트 ([[cloud-deploy-silent-failure-gates]] §3 G5).

### 잔여 동일 패턴 인벤토리 (2026-08-27 SCM_MGR 전수 — 정정 대기, 소급은 화면 작업 시점)
`SCP0039_GET_VALIDATION_INTRANSIT_INVENTORY`(2) · `SSP0046_GET_SHIPMENT_REQUEST`(1) · `SSP0060_GET_SHIPMENT_PLAN`(3) · 구 standalone `DMF0040_GET_MKT_FCST_COMPARISON`(7, PKG 이전 유물·미배선).
