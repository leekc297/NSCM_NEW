# DMF0082 — 월(M0~M12) 전환 + 단가 소수 정밀도 + End Customer 필터 정정 (클라우드 이관, 2026-09-08)

마커 **`[E20260908-XLSMONTH]`**(11) + **`[E20260908-LOCPRECISION]`** + **`[E20260908-ENDCUST]`**(1)
· 사내 적용 완료 · 업로드 왕복 E2E 통과 · **UI 조회 확인 완료(사용자, 2026-09-08)**

> ⚠ `02_PKG_DMF0082_BODY.sql` 은 **사내 배포본과 바이트 일치 검증 완료**. 앞서 받아가신 판본이 있으면 **이 파일로 다시 적용**하십시오(End Customer 정정이 추가됨).

## 이관 대상 — **DB 3건 (순서대로)**. FE 변경 없음

| # | 파일 | 대상 객체 | 유형 |
|---|---|---|---|
| 1 | `A_DB/01_ALTER_GTT_PRECISION.sql` | `GT_DMF0082_FCST_PRICE_DAILY` 3컬럼 | ALTER (23,2 → **30,10**) |
| 2 | `A_DB/02_PKG_DMF0082_BODY.sql` | `SCM_MGR.PKG_DMF0082` PACKAGE BODY | CREATE OR REPLACE (전체본) |
| 3 | `A_DB/03_META_EXCEL_COLUMNS.sql` | `SCM_ADM_EXCEL_COLUMNS` HEADER_CONTENT | UPDATE (10 → **23 토큰**) |

- **PACKAGE SPEC 이관 불필요** — 시그니처 무변경
- **FE 이관 대상 없음** — FE 는 이미 `[E20260907-XLSMONTH]` 로 M0~M12 양식을 생성 중(사용자 지시: 현재 FE 유지)
- 순서 의존: **1 → 2** 필수(GTT 폭이 좁은 상태로 BODY 만 올리면 단가가 계속 반올림된다). 3은 순서 무관하나 미적용 시 업로드 전건 탈락.

## 변경 요약

### 1) 기간축 = 월 M0~M12 (13칸 고정)
- **Form SP** `P_DMF0082_GET_EXCEL_FORM_DATA`: 주차 W01~W26(조회구간 종속) → 월 13칸 고정(BUCKET·조회구간 무관) / `WEEK_LIST` → `MONTH_LIST`
- **업로드 SP** `P_DMF0082_EXCEL_UPLOAD`: 기간 헤더 인식 `^[0-9]{8}$` → `^M[0-9]{1,2}$`(3곳), 월→일자 전개(2곳)
- 월→일자 규칙 = **AS-IS `DMF0020_EXCEL_UPLOAD` 산식 1:1**
  `M{n}` = `ADD_MONTHS(SYSDATE,n)` / 대상 = 그 달의 **주 시작일**(매일 아님) / 창 = **오늘 ~ 오늘+52주**
  (과거 주 자동 제외, 오늘이 속한 당주는 포함)
- 메타 `HEADER_CONTENT` = 식별 10(ATTRIBUTE1~10) + `M0`~`M12`(ATTRIBUTE11~23)

### 2) 단가 소수 정밀도 정정 `[E20260908-LOCPRECISION]`
- 증상(사용자 신고): 업로드 `523.621` → 원장 `523.62` 로 반올림, 월별 값이 뭉개짐
- 원인: 중간 GTT `GT_DMF0082_FCST_PRICE_DAILY` 가 **NUMBER(23,2)** — 원장 PRICE·`GT_PRDM1_T_MAIN.QTY_PRICE` 는 (30,10)
- 조치: GTT 3컬럼 + PKG 실코드 CAST **8곳** → `NUMBER(30,10)` (주석 1건은 원문 보존)
- 요구: 단가는 **소수점 이하 3자리까지 입력 가능**(사용자 명시 2026-09-08) — (30,10)이 충족
- ⚠ **월 전환 이전부터 있던 결함**(주차 양식에서도 동일하게 잘렸음)

### 3) End Customer 필터 축 정정 `[E20260908-ENDCUST]`
- 증상(사용자 신고): **division 81 에서 End Customer = `BMW` 선택 시 0행**
- 원인: EC 콤보 `FilterEndCustomerByDivision` 는 division 별로 다른 축을 CODE 로 준다
  (40 = `SCM_MST_SITE_ITEM.PROJECT_CODE` / **81 계열 = `SCM_MST_SITE.END_CUSTOMER`**)
  그런데 `P_DMF0082_GET_MAIN_DATA` 는 division 무관하게 `PROJECT_CODE` 하고만 대조 → 스테이징 전건 삭제
- 정본 = **AS-IS `DMF0003_GET_MKT_FCST_DATA`** (사용자 지시): `division <> '40'` → `S.END_CUSTOMER`(L1681) / `division = '40'` → `f.project_code`(L1838)
- 조치: `T.TOKEN = CASE WHEN p_division_id = '40' THEN F.PROJECT_CODE ELSE F.END_CUSTOMER END`
  (GTT 의 END_CUSTOMER 컬럼은 이미 `SCM_MST_SITE.END_CUSTOMER` 로 적재 — 컬럼 추가 없음)
- **Project + End Customer 동시 입력** = 별도 파라미터(`p_project_code`)가 독립 AND 적용이라 그대로 동작
- 실측: div81 EC=ALL 7,477행 / **EC=BMW 2,708행**(기존 0) / EC=BMW,Volvo 2,894행 /
  **EC=BMW + PROJECT=A15BW7001 195행** / div40 EC=ALL 7,370행(회귀 없음)
- ⚠ `P_DMF0082_GET_MAIN_DATA_CURRENT` 의 동일 필터는 `WHERE F.DIVISION_ID='40'` 하드코딩(AS-IS 원문 보존) 블록이라 **미변경** — 81 Current 경로의 EC 필터 필요 여부는 별도 확인 대상.

## 사내 실측 (2026-09-08)

**Form SP** — division 81 / 2398행 / `MONTH_LIST = 202609,…,202709`(13개월) / 월 슬롯 M0~M12
**월→주시작일 전개** 13개월 전수 정상 (M0 = 20260907~20260928 — 당주부터 / M12 는 창 절단으로 2주)
**업로드 왕복 E2E** (실제 BE `/DMF0082/FcstNPrice/UPLOAD/excel-upload`)
- 헤더 인식: 스테이징 `V_TITLE` ATTRIBUTE11~23 = `M0…M12`
- 검증(P_MODE=0): SUCCESS / ERROR 0
- 적재(P_MODE=1): `RESULT_CODE=0`, `SAVED=63`
- **정밀도 검증**: M0~M12 = `777.001`~`777.013` 업로드 → 원장에 **13개 값 전부 구분 보존** ✅

## 적용 절차
1. `01_ALTER_GTT_PRECISION.sql` (GTT 사용 중 세션 있으면 ORA-14450 — 잠잠할 때 실행)
2. `02_PKG_DMF0082_BODY.sql` → STATUS=VALID · ALL_ERRORS 0행 확인
3. `03_META_EXCEL_COLUMNS.sql` → 아래로 23토큰 확인
```sql
SELECT HEADER_CONTENT, REGEXP_COUNT(HEADER_CONTENT,'\|')+1 TOKENS
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice';
```
⚠ 3번 UPDATE 는 해당 행이 **이미 존재한다는 전제** — 없으면 0행 갱신으로 조용히 지나가고 업로드가 전건 탈락한다.

## ⚠️ 알려진 특성 (AS-IS 파리티 — 결함 아님)
- **M12 는 그 달의 앞부분만** 적재(오늘+52주 창 절단 — 실측 2주)
- 값 `> 0` 인 칸만 적재 — 빈칸·0 은 무시(삭제 아님)
- 단가라 월→일 **분배 없이 동일 값 복사**

## ⚠️ 전체본 교체 주의
`02_PKG_DMF0082_BODY.sql` 은 사내 BODY **전체본**이다. 클라우드가 뒤처져 있으면 그 사이 사내 선행 변경
(2026-08 이후 마커 28종 + 오늘자 `E20260908-GETRANGE` 2곳)이 함께 적용된다. 이관 전 아래로 대조할 것.
```sql
SELECT MARKER, COUNT(*) FROM (
  SELECT REGEXP_SUBSTR(TEXT,'E20[0-9]{6}-[A-Z0-9-]+') MARKER FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY')
WHERE MARKER IS NOT NULL GROUP BY MARKER ORDER BY MARKER;
```

## 원복
- BODY: `_artifacts/_apply_corporate/DMF0082_XLSMONTH_20260908/BACKUP_PKG_DMF0082_BODY_20260908_140618.sql`
- 메타: 같은 폴더 `BACKUP_EXCEL_COLUMNS_20260908_140618.sql`
- GTT: `ALTER TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY MODIFY (컬럼 NUMBER(23,2));` — 단 축소이므로 값이 있으면 실패
