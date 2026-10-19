# DMF0014 Excel Upload 반려 메시지 구체화 (2026-09-11)

| 항목 | 값 |
|---|---|
| 요청 | 사용자 지시 2026-09-11 — "메시지 보완을 통해 사용자가 인지할 수 있도록" |
| 마커 | `E20260911-DMF0014MSG` (15건) |
| 변경 | `PKG_DMF0014` **BODY 만** (SPEC·파라미터·FE 무변경) |
| 검증 | 임시명 `PKG_DMF0014_E0911CHK` 선컴파일 — VALID/VALID · ERRORS 0 · 라이브 무손상 |

## 문제

업로드 검증 실패 15개 지점 중 **14개가 전부 같은 문구**를 반환했다:

```sql
SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG,   -- 14곳 동일
       V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT               -- 실제 사유는 여기에만
  FROM DUAL;
```

FE 는 `MSG` 만 읽는다 (`customer-fcst-upload.api.ts:43` `inner?.RESULT_MSG || inner?.MSG`,
`CustomerFcstUpload.tsx:585` 타입도 `{CODE, MSG}`) → **`EVENT` 의 사유가 화면에 도달하지 않는다.**
사용자는 왜 반려됐는지 알 수 없었다.

## 변경 ① 사유별 메시지 (14곳)

형식: `ERR_RTN: <사유> — <설명>. (N건) <조치 안내>.`

| LINE | 사유 |
|---:|---|
| 817 | Duplication Key — 동일 키 행 중복 |
| 861 | Invalid Division |
| 925 | Invalid Measure Upload Bucket |
| 956 | Invalid Measure Upload UOM |
| 997 | Invalid Sales Site |
| 1039 | Invalid Plant Site |
| 1117 | Invalid Customer Model |
| 1155 | Invalid Incoterms |
| 1198 | Invalid FCST Type |
| 1286 | Invalid Measure Group |
| 1414 · 1532 | Invalid Quantity — 숫자 아닌 값 |
| 1570 | Invalid Upload UOM |
| 1611 | Invalid Upload UOM (Customer FCST) |

건수는 각 블록이 이미 쓰던 `v_err_cnt`(14곳 공통, `SQL%ROWCOUNT`)를 그대로 실었다.

## 변경 ② 발견된 결함 2건 동시 정정

1. **L855 로그 문구 오류** — `MESSAGE_TEXT = 'Invalid Division.'` 인데 로그·EVENT 에는
   `'ERROR Key Duplication'` 이 찍혔다(copy-paste). → `'ERROR Invalid Division'` 으로 정정.
2. **`Costomer` 오타 2곳** → `Customer` (MESSAGE_TEXT + 로그 문구).

## 미변경 (의도적)

- `L3242` (Save verify failed) — 이미 건수까지 담은 구체 문구라 그대로 둔다.
- `L6884·L6894` 의 `-- goto err_rtn` — **주석**이라 대상 아님 (hook #138).
- 행 단위 사유는 종전처럼 `SCM_ADM_EXCEL_UPLOAD.MESSAGE_TEXT` 에 그대로 기록된다(무변경).

## 실행

| # | 파일 |
|---:|---|
| 1 | `01_PKG_DMF0014_BODY.sql` — BODY 전체 교체 |

검증:
```sql
SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0014';   -- VALID/VALID
SELECT COUNT(*) FROM USER_ERRORS WHERE NAME='PKG_DMF0014';                       -- 0
SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0014'
   AND TEXT LIKE '%E20260911-DMF0014MSG%';                                       -- 15
```

원복 = `99_ROLLBACK_BODY.sql`

## ⚠ 한계

SP 가 메시지를 **문자열로 직접 반환**하는 구조라 i18n(MSG_ID) 체계를 태우지 못했다.
문구는 「영문 사유 + 한글 설명」 하드코딩이다. 다국어가 필요하면 FE 가 `EVENT` 사유 토큰으로
메시지를 조립하는 별도 설계가 필요하다(범위 밖).

---

## 증보 (2026-09-11 2차) — 양식(헤더) 불일치 전용 가드

| 항목 | 값 |
|---|---|
| 요청 | 사용자 지시 — "EXCEL FORM 의 HEADER 가 변경되는 경우 사용불가 메시지" (B안: 신규 문구) |
| 마커 | `E20260911-DMF0014FORM` (2건) |
| 사내 | ✅ 적용 완료 (VALID/VALID · ERRORS 0) |

> ⚠ 사전 조사 결과 **DMF0082 에도 「양식 변경」 전용 문구는 없었다.** 헤더 행을 `@TITLE` 로 마킹하고
> (`PKG_DMF0082` L4958~4964), 헤더가 다르면 그 행이 데이터로 흘러 `NULL Div` / `Invalid …` 로 반려된다.
> 원장 `REQ:CHAT-20260825-12` 의 "신양식 재다운로드 안내"는 **정책 서술**이지 메시지 문구가 아니다.
> 그래서 DMF0014 에 **신규로** 만들었다(사용자 B안 확정).

### 동작

검증 단계(`P_MODE=0`) 첫 검증 직전에서:

1. `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` 의 **앞 13토큰**(식별 컬럼)을 기대 헤더로 조립 — **메타 단일 원천**이라 양식이 바뀌면 가드가 자동 추종
2. 업로드 파일의 헤더 행(`UPPER(TRIM(ATTRIBUTE1))='DIVISION*'`)의 `ATTRIBUTE1~13` 을 같은 방식으로 조립
3. **헤더 행이 없거나 / 13토큰이 하나라도 다르면** 전 행 `ERROR` + 즉시 반환

비교는 `UPPER(TRIM)` — 대소문자·앞뒤 공백만 관용한다.

### 반환 메시지

```
ERR_RTN: Invalid Excel Form — 업로드 양식이 현재 양식과 다릅니다.
[Excel Form] 버튼으로 최신 양식을 다시 받아 작성해주세요.
```

- `SCM_ADM_EXCEL_UPLOAD.MESSAGE_TEXT` = `'Invalid Excel Form.'`
- 로그(`PR_SCM_SYS_LOG_BATCH`) `V_DESCRIPTION` 에 **기대 헤더 vs 파일 헤더 원문**을 함께 남겨 원인 추적이 가능하다:
  `expect=[DIVISION*|SALES SITE*|…] file=[DIVISION*|SALES SITE*|…]` (헤더 행 자체가 없으면 `(header row not found)`)

### 효과

종전에는 양식이 달라도 헤더 행이 데이터로 흘러 **`Invalid Division` 같은 엉뚱한 사유**로 반려됐다.
이제 첫 관문에서 「양식이 다르다」로 정확히 반려된다.

---

## 증보 (2026-09-11 3차) — 복수 오류 일괄 표시

| 항목 | 값 |
|---|---|
| 요청 | 사용자 지시 — "여러 항목 오류 발생 시 전체를 확인할 수 있도록" (FE 무수정, SP 에서 메시지로) |
| 마커 | `E20260911-DMF0014MULTI` (16건) |
| 사내 | ✅ 적용 완료 (VALID/VALID · ERRORS 0) · 라이브와 본 파일 **본문 전 라인 동일** 검증 |

### 종전 문제

14개 검증이 순차로 돌면서 **한 건이라도 걸리면 `RETURN` 으로 즉시 종료**했다.
→ 뒤 검증은 실행조차 되지 않아, 그리드에 그 검증에 걸린 행만 ERROR 로 뜨고
   다른 유형 오류 행은 `UPLOAD` 상태로 남았다 → 고쳐서 다시 올리는 **왕복** 발생.

### 변경

1. **14개 검증의 즉시반환(`OPEN`/`SELECT`/`RETURN` 3줄) 제거** — 끝까지 전부 수행
   (행별 `UPLOAD_STATUS_CODE='ERROR'` + `MESSAGE_TEXT` 마킹은 종전 그대로 유지)
2. **집계 반환 신설** — `V_COUNT`(ERROR 행수) 산출 직후, 적재 게이트 앞:

```
ERR_RTN: Validation Failed — N개 항목 / 총 M건이 반려되었습니다.
[Duplication Key: 2건] [Invalid Sales Site: 1건] [Invalid Plant Site: 1건] …
```

   `MESSAGE_TEXT` 로 GROUP BY 해 건수 내림차순 나열. 문자열 3,200자 초과분은 절단(항목 수는 전량 집계).

3. **허위성공 차단** — 종전에는 `mode>0`(적재)에서 오류가 남아 있어도 적재만 건너뛰고 `SUCCESS` 가 나갔다.
   이제 `V_COUNT > 0` 이면 mode 무관하게 오류로 반환한다 → 적재 게이트(`V_COUNT=0`)와 판정이 일치.

### 안전성

- 적재 게이트 `IF P_MODE > 0 AND V_COUNT = 0` 은 **무변경** — 오류가 하나라도 있으면 저장은 계속 차단된다.
- 각 검증이 `AND UPLOAD_STATUS_CODE='UPLOAD'` 를 쓰므로 **이미 ERROR 인 행은 뒤 검증에서 자동 제외** →
  한 행에 사유가 겹쳐 찍히거나 중복 집계되지 않는다.
- 양식 가드(2차)는 **즉시 반환 유지** — 양식이 다르면 나머지 검증이 무의미하다.

### ⚠ 부작용 (인지·기록)

1차(`E20260911-DMF0014MSG`)에서 만든 사유별 상세 문구는 각 검증의 **즉시반환 `SELECT` 줄**에 있었기 때문에,
그 3줄을 제거하면서 **14개가 함께 사라졌다**(마커 15 → 1).
현재 사유는 `MESSAGE_TEXT` 집계로 전달되므로 동작에는 문제가 없으나, 문구가 원문(`Invalid Sales Site.`)으로
짧아졌다. **후속 개선안**: 1차 문구를 `MSG` 가 아니라 `MESSAGE_TEXT` 자체에 넣으면 집계 메시지와
(향후) FE 행별 사유 컬럼에 동시에 반영된다.

---

## 증보 (2026-09-11 4차) — Error Detail(`MESSAGE_TEXT`) 오류 **누적** · RETURN 문구 원복

| 항목 | 값 |
|---|---|
| 요청 | 사용자 정정 — "Return 메시지가 아니라 **Message_text 에 오류 항목을 취합**" + "상세한 설명" + "return message 수정분 원복" |
| 사내 | ✅ 적용 완료 (VALID/VALID · ERRORS 0) · 라이브와 본 파일 **본문 전 라인 동일** |

### 변경

1. **`MESSAGE_TEXT` 누적 (14곳)** — 덮어쓰기 → 이어붙이기
   ```sql
   MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN '<상세문구>'
                       ELSE MESSAGE_TEXT || ' / ' || '<상세문구>' END
   ```
2. **검증 대상에 기존 ERROR 행 포함 (18곳)** — `UPLOAD_STATUS_CODE = 'UPLOAD'` → `IN ('UPLOAD','ERROR')`
   (이게 없으면 첫 사유가 붙은 행이 뒤 검증에서 빠져 **누적이 안 된다**)
3. **문구를 상세 설명으로** — 3차에서 사라졌던 1차 안내를 `MESSAGE_TEXT` 로 이관
   예: `Invalid Sales Site - 등록되지 않은 Sales Site 입니다. [Sales Site*] 확인`
4. **RETURN 문구 원복** — 3차의 집계 메시지 제거, 원래 `'ERR_RTN: - Validation Check'` 1회 반환

### 유지 (누적의 전제)

- 각 검증의 **즉시 `RETURN` 제거**(3차) — 전 검증이 돌아야 누적된다
- **양식 가드**(2차) — 즉시 반환 유지 (양식이 다르면 나머지 검증이 무의미)
- 적재 게이트 `IF P_MODE > 0 AND V_COUNT = 0` — **무변경**

### ⚠ 작업 중 적출한 함정 (기록)

`MESSAGE_TEXT` 리터럴 대입이 **19곳**으로 보였으나, 그중 **4곳은 `/* … */` 주석 블록 안의 죽은 코드**였다.
주석 인식 없이 치환하면 그 안에 마커가 들어가 **중첩 주석**이 되어 주석이 조기 종료되고 죽은 코드가
살아나 컴파일이 깨진다(실제 발생 → 임시명 선컴파일에서 적출). 블록주석 상태를 추적하는 코드-라인 맵을
만들어 **코드 줄만** 대상으로 재작업했고, 최종 대상은 **14곳**이다.
