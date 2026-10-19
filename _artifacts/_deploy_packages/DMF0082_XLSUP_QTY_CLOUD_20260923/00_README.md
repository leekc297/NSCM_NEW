# DMF0082 Excel Upload — Invalid QTY 검증 복구 + Error Detail 컬럼 정합 (클라우드 이관)

> 마커: `[E20260923-XLSUPQTY]`(DB) · `[E20260923-XLSUPHDR]`(FE)

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0082_XLSUP_QTY_CLOUD_20260923` |
| 대상 | **DMF0082 — FCST & PRICE MGMT** / Excel Upload |
| 범위 | **DB 1객체 + FE 1파일** (BE 무변경) |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1 / SCM_MGR, 2026-09-23 23:38:52) |
| 클라우드 | **미적용** |

---

## 1. 고치는 증상 2가지 (사용자 신고 2026-09-23)

### ① "M0~M12 에 문자가 들어오면 Oracle 오류 메시지가 뜬다"

`P_DMF0082_EXCEL_UPLOAD` 의 **숫자여부 체크가 Oracle 에서 사문(死文)** 이었습니다.

```sql
-- 구(사문)
(NVL(ATTRIBUTE7,'') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE7,'^[+-]?\d+\.?\d*$'))
```

Oracle 은 `'' = NULL` 이라 **`x <> ''` 가 값과 무관하게 항상 UNKNOWN** 입니다(hook #119 — MSSQL `<> ''` 오역). 그래서 이 `UPDATE` 가 **단 1행도 잡지 못하고**, 비숫자 값이 저장 분기(`p_mode>0`)까지 흘러가 `GT_F020_UPLOAD_MASTER_FINAL` 적재의 `TO_NUMBER(TMP.LOC) > 0` 에서 **ORA-01722 invalid number** 원문이 화면에 노출됐습니다.

**사내 실증 (ZIOUI1, 2026-09-23)**

| 식 | 결과 |
|---|---|
| `NVL('10.5210.52','') <> ''` | **FALSE/UNKNOWN** |
| `'10.5210.52' IS NOT NULL` | TRUE |
| `NOT REGEXP_LIKE('10.5210.52','^[+-]?\d+\.?\d*$')` | TRUE (점 2개 = 숫자 아님) |
| **현행 조건으로 잡히는 건수** | **0** |
| `IS NOT NULL` 정정 조건 | **1** |

**정정**

```sql
-- 신
(TRIM(ATTRIBUTE7) IS NOT NULL AND NOT REGEXP_LIKE(TRIM(ATTRIBUTE7),'^[+-]?\d+\.?\d*$'))
```

- 진짜 빈 셀(NULL)·공백만 든 셀은 **종전대로 검사 제외** (`TRIM('  ')` = `''` = NULL)
- 정규식 대상도 `TRIM(x)` — `' 10.52 '` 같은 전후 공백을 오류로 몰지 않습니다
- 메시지 `'Invalid NUMERIC.'` → **`'Invalid QTY [<헤더라벨>: <입력값>]'`**
  라벨 = `HEADER_CONTENT` 기간 토큰 `M0~M12` (= `ATTRIBUTE7~19`), 첫 위반 칸 1개 표기(CASE 선평가)

### ② "오류 시 나오는 COLUMN 이 Excel Upload 의 COLUMN 과 일치하지 않는다"

FE 상수 `forecast-price.constants.ts` 의 `UPLOAD_HEADERS` 가 **구 10컬럼**으로 남아 있었습니다.

| | 값 |
|---|---|
| 구 `UPLOAD_HEADERS` (10) | `Div, End Customer, Sales Site, Model, Incoterms, FCST Type, Customs Handbook, Cell Prod Site, Currency, Measure` |
| 실제 `HEADER_CONTENT` (19, 사내 실측) | `Div, Team, End Customer, Project Code, Currency, Model, M0 … M12` |

`FcstUploadModal` 은 `ATTRIBUTE{n}` → `UPLOAD_HEADERS[n-1]` 로만 라벨을 붙입니다. 그래서 Error Detail 에 **지금 양식에 없는** `Sales Site`·`Incoterms`·`FCST Type`·`Customs Handbook`·`Cell Prod Site`·`Measure` 가 뜨고, 라벨이 모자란 `ATTRIBUTE11~19`(M4~M12)는 원시 키로 노출됐습니다.

2026-09-21 `[E20260921-XLSFORMASIS]` 로 양식이 AS-IS DMF0020 파리티(19컬럼)로 바뀌었는데 **이 상수만 동기화되지 않은 누락**입니다. 19토큰으로 교체했습니다.

---

## 2. 사내 검증 실측 (모의행, 2026-09-23)

`CREATED_BY='QTYTEST20260923'` 전용 배치로 `@TITLE` 1 + `UPLOAD` 3 을 적재해 `P_DMF0082_EXCEL_UPLOAD(mode=0)` 실행 후 정리(잔여 0).

| 입력 M0 | 결과 | MESSAGE_TEXT |
|---|---|---|
| `10.5210.52` | ERROR | `Invalid QTY [M0: 10.5210.52]` |
| `ABC` | ERROR | `Invalid QTY [M0: ABC]` |
| `  30.5 ` (전후 공백) | **SUCCESS** | — (정상 통과) |

- 결과커서 `('0','SUCCESS',None)` · `@TITLE` 행 무영향
- 컴파일 **VALID · USER_ERRORS 0** · 적용본 == 패치본
- 마커: `XLSUPQTY` 1 / `XLSFORMMEASUREOFF` 2 / `XLSFORMCURRENCY` 2 / `XLSFORMSORT` 1 / `XLSFORMCURCHAIN` 2
- 구 `'Invalid NUMERIC.'` **잔존 0**

---

## 3. 적용 절차

1. **DB** (SCM_MGR 접속) — `@A_DB/05_PKG_DMF0082_BODY.sql`
   - 이 BODY 에는 09-23 Excel Form 조치 4종(`MEASUREOFF`/`CURRENCY`/`SORT`/`CURCHAIN`)도 함께 들어 있습니다.
     클라우드가 그 회차를 아직 안 받았다면 **이 파일 하나로 같이 반영**됩니다.
   - 확인: `STATUS='VALID'` · `USER_ERRORS` 0 · 마커 5종 존재 · `'Invalid NUMERIC.'` 0건
2. **FE** — `B_FE/forecast-price.constants.ts`
   → `nscm-fe/features/demand/src/pages/forecast-price/forecast-price.constants.ts` 덮어쓰기
3. **화면 확인** — DMF0082(81) → Excel Upload
   - M0 에 문자 입력한 행 → `Invalid QTY [M0: <값>]`
   - Error Detail 컬럼이 `Div/Team/End Customer/Project Code/Currency/Model/M0~M12` 와 일치

패키지 상태변수 없음 → BE 재기동 불요.

### ⚠ 선행 확인 — 클라우드 `HEADER_CONTENT`

FE 상수는 `HEADER_CONTENT` 와 **1:1 순서 일치**가 전제입니다. 클라우드가 구 토큰이면 FE 만 고쳐도 어긋납니다.

```sql
SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
 WHERE PROGRAM_ID = 'DMF0082';
```

기대값(사내 실측 19토큰):
`Div|Team|End Customer|Project Code|Currency|Model|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12`

---

## 4. 이번 조치 범위 **밖** — 함께 발견했으나 미조치

### (a) 같은 SP 의 `Negative Number` / `Zero Number` 도 동일 사문

`NVL(x,'') <> ''` 구조가 그대로라 두 검증 역시 발동하지 않습니다. **지금 되살리면 종전까지 통과하던 0·음수 입력이 갑자기 차단**되고, SP 머리말 정책("LOC 값이 없을 경우 0으로 간주")과 충돌할 수 있어 **원문 유지**했습니다. 되살릴지는 별도 판단이 필요합니다.

### (b) 스테이징 2벌 적재 — "1행 올렸는데 Error 행번호가 2, 4"

사용자 제공 파일(`DMF0082_Template_20260923_101948.xlsx`)을 열어보면 **데이터가 1행뿐**입니다.
`EXCEL_ROW` 는 설계상 `@TITLE`(= 엑셀 1행 헤더)을 1번으로 세므로 **데이터 첫 행 = 2 가 정상**입니다.
따라서 **4 가 나왔다 = 스테이징에 `@TITLE`+데이터가 2벌** 들어갔다는 뜻입니다(1=@TITLE, 2=데이터, 3=@TITLE, 4=데이터).

BE 경로는 이번에 배제됐습니다 — `SCM_ADM_EXCEL_COLUMNS` 는 DMF0082 **1행**(루프 1회), 새 `FileServiceImpl` 로 이 파일을 추적하면 `@TITLE` 1 + `UPLOAD` 1 = **2행만** 생성됩니다.
→ 남은 후보는 **FE 이중발사**(업로드 요청 2회) 입니다. 확인 SQL:

```sql
SELECT UPLOAD_ID, UPLOAD_STATUS_CODE,
       TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3') CD, CREATED_BY
  FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
 WHERE PROGRAM_ID = 'DMF0082'
   AND CREATION_DATE >= SYSDATE - 1
 ORDER BY UPLOAD_ID;
```

두 `@TITLE` 의 `CD` 가 **완전히 같으면** 한 배치 안에 2벌(BE/SP 경로), **다르면** 업로드 요청이 2회입니다.

### (c) `10.5210.52` — 값이 두 번 이어붙은 원인

업로드 파일 **자체**에 문자열로 들어 있습니다(`sharedStrings si[24]='10.5210.52'`, 셀 `G2 t="s"`).
데이터 셀이 전부 공유문자열이라 **엑셀에서 손으로 편집·저장한 파일이 아니라 JS 라이브러리가 생성한 다운로드본**입니다.
즉 업로드가 아니라 **Excel Form 생성/입력 단계**에서 이미 값이 이어붙었습니다. 이번 조치는 그 값을 `Invalid QTY` 로 **막아주지만**, 이어붙는 원인 자체는 별건입니다.

---

## 5. 원복

사내 `_apply_corporate/DMF0082_XLSUP_QTY_20260923/` 에서 실행합니다.

| 대상 | 명령 |
|---|---|
| Invalid QTY 조치 해제 (2026-09-23 23:38 직전 원문) | `python apply_qty.py restore` |

FE 는 `_artifacts/_backup/COMMON_20260923C_PRE/` 가 아니라 **git** 으로 되돌립니다
(`git checkout -- features/demand/src/pages/forecast-price/forecast-price.constants.ts`).
