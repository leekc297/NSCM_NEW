# DMF0044 (Sales Reports) 저장 개선 — 대량저장 / 속도 / 자릿수 / 저장반영

- **마커**: `E20260903-DMF0044*`
- **원장**: `REQ:CHAT-20260903-W53` (VERIFIED — 사용자 실측 확인 2026-09-03)
- **대상 SP**: `PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C` / `_C_CF`
- **BE/FE 코드 변경**: **없음** (§5 참조)

---

## 1. 적용 순서

| # | 파일 | 대상 | 비고 |
|---|---|---|---|
| 0 | — | — | `04_` 는 CLOB 없이 수치 오류만 막는 **대안본**. 전체 적용 시 사용하지 않음 |
| 1 | `05A_PKG_DMF0044_SPEC_CLOB.sql` | `PKG_DMF0044` (SPEC) | IN 파라미터 44개 → CLOB |
| 2 | `05B_PKG_DMF0044_BODY_CLOB_BULK.sql` | `PKG_DMF0044` (BODY) | 개선 7종 누적 |
| 3 | `06_SCM_ADM_PROC_M_CLOB.sql` | `SCM_ADM_PROC_M` | API 등록 메타 44행 → CLOB |

⚠ **②와 ③ 사이에 저장이 실행되면 깨집니다.** SP 는 CLOB 을 기대하는데 메타가 VARCHAR 로 남으면 BE 가 `jdbcType=VARCHAR` 로 바인딩합니다. **연속 적용**하십시오.

⚠ 라이브 PKG 교체이므로 BE 기동 중이면 DDL 락이 걸립니다.

### 배포 후 확인

```sql
-- 마커 (기대: NUM 14 / BULK 8 / TOP1 3 / BRANCH 1 / 메시지 1)
SELECT COUNT(*) FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TEXT LIKE '%E20260903-DMF0044%';

-- 메타↔SP 타입 정합 (기대: 0행)
SELECT M.PROC_NM, M.SORT_ORD, M.COL_NM, M.DATA_TP_CD, A.DATA_TYPE
  FROM SCM_MGR.SCM_ADM_PROC_M M
  JOIN ALL_ARGUMENTS A ON A.OWNER='SCM_MGR'
   AND A.PACKAGE_NAME = SUBSTR(M.PROC_NM,1,INSTR(M.PROC_NM,'.')-1)
   AND A.OBJECT_NAME  = SUBSTR(M.PROC_NM,INSTR(M.PROC_NM,'.')+1)
   AND A.POSITION = M.SORT_ORD AND A.IN_OUT='IN'
 WHERE M.PROC_NM LIKE 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT%'
   AND M.COL_TP_CD='IN' AND M.DATA_TP_CD <> A.DATA_TYPE;
```

---

## 2. 개선 7종

### ① 수치 오버플로 — `ORA-01438`

`QTY` 는 `NUMBER(30,10)`(정수부 20자리)로 정상이었다. 문제는 **배분식의 연산 순서**였다.

```sql
-- 변경 전 : 곱셈이 먼저라 중간값이 폭주
ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0)
-- 변경 후 (L5129·5240·5345·5449)
ROUND(V_ADJQTY * (A.QTY / V_ORIQTY), 0)
```

중간변수 6개(`V_ADJQTY`/`V_REST`/`V_ORIQTY`/`V_LOC_SALESAMT_LOC`/`V_LOC_RTF`/`V_LOC_PRICE`)도 `NUMBER(30,10)` → `NUMBER` 로 상한 해제.

> 격리 실측: `777777777777777 × 1410` OK / `× 1410 × 1410` → `ORA-01438`

### ② 대량 저장 — CLOB 전환

두 SAVE SP 는 **파라미터 하나가 전 행의 해당 컬럼을 `^` 로 이은 벌크 캐리어**다. IN 인자 21/23개가 전부 `VARCHAR2`(32,767 상한)라 행이 늘면 끊겼다(약 800행 근처).

SPEC·BODY 헤더 44개 + `SCM_ADM_PROC_M` 44행을 `CLOB` 으로 전환.

### ③ 속도 — 파싱 `O(N²)` 제거

종전은 컬럼마다 `REGEXP_SUBSTR(p,'[^^]+',1,LEVEL)` 을 행 수만큼 호출했고 매 호출이 문자열을 처음부터 재스캔했다 — **O(행수² × 컬럼수)**. 1,000행이면 정규식 23,000회.

`SP_SPLIT_CARET`(단일 패스 `DBMS_LOB.INSTR`) + `SP_PAD_TOK` + `FORALL` 일괄 INSERT 로 교체.

> **빈 토큰은 종전 정규식 `[^^]+` 와 동일하게 건너뛴다**(방안 1 — 동작 변화 0).
> 빈 값이 섞이면 그 컬럼만 한 칸 당겨지는 **정렬 결함은 종전과 동일하며 별건**이다.

### ④ 자릿수 검증 — SQL ERROR → VALIDATION

정수부 20자리 이상이면 예외 대신 사내 관례 커서로 반환한다.

```sql
OPEN O_RESULT_CURSOR FOR
SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
RETURN;
```

⭐ **`MSG` 컬럼에 실어야 화면에 보인다.** FE 는 `EVENT` 를 읽지 않는다 — 근거: `foundation/src/apis/axios-interceptors.ts` L29~30
```ts
if (Number(...O_RESULT_CURSOR[0].CODE)) throw new Error(...[0].MSG);
```
사내 관례(`MSG='ERR_RTN: - Validation Check'` / `EVENT=상세`)를 그대로 쓰면 관례 문자열만 뜨고 사유가 안 보인다.

메시지: `허용 가능한 자릿수를 초과하였습니다.` + 위반 행·값 상세(최대 10건).

⭐ 판정은 **숫자 비교**(`ABS(값) >= 10^20`). 문자열 자릿수 세기는 지수표기(`1.2345678901234568E+22`)를 정수부 `1` 로 읽어 통과시킨다 — 실측으로 23자리 값이 새어 `ORA-01438` 발생.

### ⑤ ⭐ 저장 반영 — 분기 조건 교정 (핵심)

```sql
-- L5113 : SUM 과 COUNT 를 함께 구한다
SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE ...

-- L5127 변경 전 : 합계로 분기  ⛔
IF NVL(V_ORIQTY,0) <> 0 THEN
-- L5127 변경 후 : 건수로 분기
IF NVL(V_QTYCNT,0) > 0 THEN

-- L5129 : 합계 0 을 균등배분으로 처리하도록 이미 작성돼 있었으나 도달 불가(죽은 코드)였다
SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * (A.QTY/V_ORIQTY), 0)
               ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END
```

**행은 있는데 합계가 0** 인 키가 "원래 없었다"로 오판되어 INSERT 분기로 빠졌다(클라우드 실측 **926건**). 이것이 `ORA-00001` 의 근본 원인이며, 가드만 넣었을 때는 **조용한 무저장**으로 바뀌었다.

### ⑥ `ORA-00001` 중복 가드 (안전망)

"RTF 가 원래 없었을 경우" INSERT 에 `NOT EXISTS` 추가. ⑤로 해당 경로를 타지 않게 됐으나 다른 경로 대비 안전망으로 유지.

- `CELL_PROD_SITE` : **NOT NULL / DEFAULT `'-'`** → `NVL` 미사용
- `COMPO_40` : NOT NULL / DEFAULT 가 생성식 → 같은 식으로 비교
- TO-BE PK 는 **16컬럼** (AS-IS 15 + `CELL_PROD_SITE`)

### ⑦ AS-IS `TOP 1` 누락분

AS-IS `DMF0044_SAVE_SALES_PLAN_REPORT_C_CF` L1499 는 **`GROUP BY` 를 가진 유일한 INSERT** 로 `SELECT TOP 1` 을 쓴다. TO-BE 변환에서 누락됐다.

Oracle 은 `ROWNUM` 을 `GROUP BY` **이전**에 매기므로 `WHERE` 에 넣으면 원본 1행만 집계되어 값이 달라진다. **인라인 뷰로 감싸고 바깥에서 `ROWNUM = 1`** 이라야 등가다.

감사 4컬럼(`V_CREATED_BY`×2 / `SYSDATE`×2)은 뷰 컬럼명이 겹쳐 `ORA-00918` 이 나므로 별칭 부여(값·순서 불변).

---

## 3. 검증

| 축 | 결과 |
|---|---|
| 문법 | 임시명 `PKG_DMF0044_E0903CHK` 컴파일 **VALID** / `ALL_ERRORS` **0건** (라이브 무변경, 검증 후 DROP) |
| `ORA-01438` | 배포 후 로그 **0건** (이전 22건) |
| 저장 반영 | **사용자 확인** 2026-09-03 |
| 대량 저장 | **사용자 확인** 2026-09-03 |
| 속도 | **사용자 확인** 2026-09-03 |
| 20자리 VALIDATION | **사용자 확인** 2026-09-03 |

---

## 4. 진단 자산

| 파일 | 용도 |
|---|---|
| `_artifacts/_diagnostics/DMF0044_SAVE_ERROR_VERIFY.sql` | 패치 적용 여부 5축 + 오류 로그 + 정밀도 |
| `_artifacts/_diagnostics/DMF0044_AFTER_REDEPLOY_VERIFY.sql` | 재배포 시각 이후 오류만 필터 + BACKTRACE 소스 자동 출력 |
| `_artifacts/_diagnostics/DMF0044_ORA00001_ROOTCAUSE_VERIFY.sql` | 중복키 3가설(합계0 / 센티널 / 형제행) 판별 |

---

## 5. BE 코드 변경이 불필요한 이유

`framework/base/BaseService.java` `makeProcedure()` L367~382 가 `SCM_ADM_PROC_M` 을 **파라미터 행 단위로 순회**하며 `DATA_TP_CD` 별 바인딩을 조립한다.

```java
if (DATA_TP_CD.equals("VARCHAR")) → #{col, mode=IN, jdbcType=VARCHAR}
else if (DATA_TP_CD.equals("CLOB")) → #{col, mode=IN, jdbcType=CLOB}   // L377 이미 존재
```

분기가 행마다 독립 적용되므로 파라미터 개수·위치 제약이 없다. 기존 CLOB 등록 36건이 모두 `data` 단일 파라미터인 것은 그 화면들이 JSON 단일 페이로드 방식이기 때문이지 코드 제약이 아니다.

> L414~ 에 값을 SQL 에 문자열로 직접 박는 구(舊) `makeProcedure` 가 하나 더 있으나 **통째로 주석 처리된 죽은 코드**다.

---

## 6. 조사 중 확인된 별건 (미조치)

**① 편집 규칙은 FE 에 이미 구현되어 있다** — SP 변경 불필요

`features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts` 가 AS-IS `.cs` L318~370 의 4변수 매트릭스(`EDIT_FLAG` × Measure × Division × 시점)를 그대로 이식했고, `beginningEdit`(편집 차단)과 `formatItem`(색)이 같은 `evalDyn` 하나를 공유한다.

> `SalesReportsGrid.tsx` L434 경위 주석 — 2026-08-10 에 `EDIT_FLAG` 표준 패턴으로 위임했다가, `EDIT_FLAG` 가 구조적으로 대부분 `'N'`(`(V_GROUP_ID='ADMIN') AND (DATA_TYPE='2')`)이라 편집이 전부 막혀 되돌린 이력이 있다. **SP 로 다시 옮기지 말 것.**

**② 파싱 정렬 결함 (종전부터 존재)** — 빈 값이 섞이면 그 컬럼만 한 칸 당겨져 다른 행의 값이 저장된다. `[^^]+` 가 빈 토큰을 건너뛰기 때문. 본 패키지는 **동작 변화 0** 원칙으로 그대로 두었다.

**③ `FORECAST_INFO_CELL_PACK_COUNT` 가 `NUMBER(20,10)`** — 3개 테이블 공통. *"수량/금액 `NUMBER(30,10)` 표준, `(20,10)` 금지"* 규약 위반이나 이번 증상과 무관.

---

## 7. 작업 중 판단 착오 (재발 방지 기록)

**① 증상 소멸을 해결로 판단** — `NOT EXISTS` 가드로 `ORA-00001` 이 사라진 것만 보고 종결로 봤다. 실제로는 **조용한 무저장**으로 바뀌어 "저장 완료인데 값 없음"을 유발했다. 근본은 L5127 분기 조건이었다.

**② 화면 오인 3회** — `sales-monitoring` 폴더를 이름만 보고 DMF0044 로 단정했다. 실제로는 **DMF0048**이고 DMF0044 는 `sales-reports` 다. `menuId` 를 확인하지 않아 "TO-BE 는 read-only", "편집 규칙이 없다", "SP 로 이식해야 한다"를 연달아 잘못 답했다.

**③ 순번 짝짓기** — AS-IS↔TO-BE INSERT 를 **순번**으로 맞춰 누락 지점을 오지목했다. 주석 제거로 라인이 밀려 대응이 어긋났다. **내용 지문**(MEASURE 리터럴 + GROUP BY + 집계 유무)으로 다시 맞춰 확정했다.

**④ 스캔 오탐** — "행수 제한 유무"를 블록 안 `ROWNUM` 문자열 존재로 판정해, **스칼라 서브쿼리 안의 `ROWNUM=1`** 까지 세었다.
