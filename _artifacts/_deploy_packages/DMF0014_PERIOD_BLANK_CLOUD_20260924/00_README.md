# DMF0014 Excel Upload — 동적(기간) 구간 검증 정책 개정 (클라우드 이관)

> 마커 `[E20260923-DMF0014BLANK]` · 대상 `PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD`

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0014_PERIOD_BLANK_CLOUD_20260924` |
| 대상 | **DMF0014 — Customer FCST Upload** / Excel Upload 검증 |
| 범위 | **DB 1객체** (`PKG_DMF0014` BODY). FE/BE 무변경 |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1 / SCM_MGR, 2026-09-24 00:02:04) |
| 클라우드 | **미적용** |

---

## 1. 확정 정책 (사용자 지시 2026-09-23, 3회에 걸쳐 확정)

> 1. "동적 COLUMN 구간에 숫자가 아니면 숫자 오류, 그리고 전체 동적 COLUMN 영역에 값이 없으면 숫자 오류가 아닙니다."
> 2. "동적 구간에 값이 없는것은 오류가 아닙니다."
> 3. "값이 없을 때는 Please Input QTY 대상이 아닙니다. 숫자가 아닌 문자인 경우에 이 메세지가 나오면 됩니다."

| 동적 구간 셀 | 개정 후 | 개정 전 |
|---|---|---|
| **빈칸(값 없음)** | **오류 아님 — 메시지 없음** | `Please Input QTY [YYYYMMDD]` |
| **숫자가 아닌 문자** | **`Please Input QTY [YYYYMMDD: 값]`** | `Invalid Numeric [YYYYMMDD: 값]` |
| 소수점 (정수만 허용) | `Invalid Decimal [YYYYMMDD: 값]` (유지) | 동일 |

⚠ **같은 날 오전 회차(`[E20260923-DMF0014VALMSG]`)의 정책을 사용자가 뒤집은 것**입니다.
그때는 "빈값 → `Please Insert QYT`" 였습니다. **이번 지시가 최신**이며, 문구 `Please Input QTY` 는
**빈값용 → 비숫자용으로 이동**했습니다(3번 문장). 그에 따라 `Invalid Numeric` 문구는 폐기됩니다.

식별 컬럼 18종 검증 메시지(`Invalid Division [..]` 등, `VALMSG` 31곳)는 **그대로 유지**됩니다.

---

## 2. 변경 4곳 (전부 `P_DMF0014_CUST_FCST_EXCEL_UPLOAD` 내부)

### ① 빈값 분기 제거

```sql
-- 구
CASE WHEN TRIM(V.VALUE) IS NULL
     THEN CASE WHEN EXISTS (SELECT 1 FROM DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD
                            WHERE M.VALID_YN='Y' AND … M.SUMMARY_BUCKET_VALUE = …)
               THEN 'Please Input QTY [' || TRIM(H.HDR) || ']' END
-- 신
CASE WHEN TRIM(V.VALUE) IS NULL THEN NULL      -- 빈칸은 검사 대상 아님
```

부수효과: 행 × 기간칸 수만큼 돌던 `DM_MST_CUSTOMER_FCST`/`SCM_MST_DIVISION` 상관 `EXISTS` 가 사라져 **검증 비용이 줄어듭니다**(결과 불변 — 이 분기는 이제 메시지를 만들지 않음).

### ② 비숫자 분기 문구
`'Invalid Numeric ['` → `'Please Input QTY ['`

### ③ 로그 문구
`'… Invalid Numeric / Invalid Decimal / Please Input QTY …'` → `'… Please Input QTY / Invalid Decimal …'`

### ④ 정책 주석 동기화
실코드와 어긋나면 다음 작업자가 옛 정책을 따르므로 ①②③ 서술을 함께 개정했습니다.

---

## 3. 왜 빈칸이 더 이상 ERROR 로 마킹되지 않는가 (구조 근거)

MERGE 의 `USING` 이 **`WHERE P.MSG IS NOT NULL`** 로 메시지 없는 셀을 걸러낸 뒤 `UPLOAD_ID` 로 `GROUP BY` 합니다(실측).
따라서 **빈칸만 있는 행은 `X` 집합에 아예 나타나지 않아 `ON (A.UPLOAD_ID = X.UPLOAD_ID)` 이 매칭되지 않고**, `WHEN MATCHED` 의 `UPLOAD_STATUS_CODE='ERROR'` 가 실행되지 않습니다.

---

## 4. 사내 검증 실측 (모의행, 2026-09-24)

`CREATED_BY='BLKTEST20260924'` 전용 배치로 `V_TITLE` 1행(기간 헤더 `20260928/20261005/20261012`) + `UPLOAD` 3행을 적재한 뒤, 개정된 MERGE `USING` 서브쿼리를 그대로 떼어 실행했습니다. 실행 후 정리(잔여 0).

| 케이스 | 결과 |
|---|---|
| 전 구간 빈칸 | **(대상 아님 = 오류 없음)** |
| 비숫자 `ABC` | **`Please Input QTY [20260928: ABC]`** |
| 소수점 `10.5` | `Invalid Decimal [20260928: 10.5]` |

- 컴파일 **VALID · USER_ERRORS 0** · 적용본 == 패치본
- 마커 `DMF0014BLANK` 2곳 / `DMF0014VALMSG` 31곳 유지
- `'Invalid Numeric ['` **잔존 0** · `'Please Input QTY ['` **1곳(비숫자 분기)** · `'Invalid Decimal ['` 1곳

### ⚠ 1차 시도 실패 기록 (원복 후 재적용)

첫 적용에서 **PLS-00103 (`소수점` 심볼)** 로 `INVALID` 가 났습니다. 정책 주석이 이미 `/* … */` 블록 **안**인데 그 안에 또 `/*[TAG] … */` 를 넣어 **중첩 주석**이 됐고, **Oracle 은 블록 주석 중첩을 지원하지 않아** 안쪽 `*/` 가 바깥 주석을 조기 종료시켜 뒤 문장이 코드로 해석된 것입니다.
즉시 `restore` 로 `VALID` 복구 → 주석을 `[TAG]` 대괄호 표기로 바꾸고 **중첩 `/*` 정적 가드**(깊이 카운터)를 통과시킨 뒤 재적용했습니다. 현재 상태는 정상입니다.

---

## 5. 적용 절차

1. SCM_MGR 접속 → `@A_DB/05_PKG_DMF0014_BODY.sql`
2. 확인
   ```sql
   SELECT STATUS FROM ALL_OBJECTS
    WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' AND OBJECT_TYPE='PACKAGE BODY';  -- VALID
   SELECT COUNT(*) FROM USER_ERRORS WHERE NAME='PKG_DMF0014';                            -- 0
   ```
   BODY 원문에서 `'Invalid Numeric ['` **0건**, `'Please Input QTY ['` **1건** 확인
3. 화면 확인 — DMF0014 → Excel Upload
   - 동적 구간 **전부 빈칸**인 행 → 기간 관련 오류 **없음**
   - 동적 구간에 **문자** 입력 → `Please Input QTY [<기간>: <값>]`

패키지 상태변수 없음 → BE 재기동 불요.

> 이 BODY 에는 같은 날 오전 회차 `[E20260923-DMF0014VALMSG]`(식별 컬럼 18종 메시지 시인성)도 함께 들어 있습니다.
> 클라우드가 그 회차를 아직 안 받았다면 **이 파일 하나로 같이 반영**됩니다.

---

## 6. 원복

```
cd _artifacts/_apply_corporate/DMF0014_PERIOD_BLANK_20260923
python apply_blank.py restore     # 2026-09-24 00:02 직전 원문(= VALMSG 회차 상태)
```
