# PKG_DMF0040 이관 패키지 — `[E20260909-VERLABEL]` + Owner 필터(P53)

## 1. ⚠ 먼저 — 앞서 드린 파일이 실행되지 않은 이유

이전에 드린 `PKG_DMF0040_BODY_AFTER_V2.sql` 은 `USER_SOURCE` **원문 백업**이라 실행용이 아니었습니다.
두 가지가 빠져 있었습니다.

| 결함 | 증상 |
|---|---|
| `CREATE OR REPLACE` 접두어 없음 | 1행 `PACKAGE BODY "PKG_DMF0040" IS` → `SP2-0044 알 수 없는 명령` |
| 종결자 `/` 없음 + **빈 줄 107개** | SQL\*Plus 기본값 `SQLBLANKLINES OFF` 가 빈 줄에서 문장을 끊어, 선언부가 개별 SQL 로 실행됨 → `ORA-00928` / `ORA-00904 "P_BUCKET"` / `ORA-00904 "P_CREATED_BY"` / `PLS-00103 END` |

본 패키지의 `01_`/`02_` 는 접두어·종결자·`SET SQLBLANKLINES ON` 을 갖춘 **실행용 파일**입니다.

## 2. 무엇이 들어 있나

대상 : `SCM_MGR.PKG_DMF0040` (SPEC + BODY) > `P_DMF0040_GET_MKT_FCST_COMPARISON`

### (a) `[E20260909-VERLABEL]` — 메저명을 실제 선택 VERSION_ID 로

`'Version(A)' / 'Version(B)'` 문자열이 **표시 라벨이면서 동시에 판정 키**였다. 표시축과 판정축을 분리한다.

| # | 위치 | 변경 |
|---:|---|---|
| 1 | `ALL_QUERY_DATA` 버전 분기 | `V.VERSION_TYPE AS MEASURE` → `V.VERSION_NO AS MEASURE` + `V.VERSION_TYPE AS VERSION_TYPE` 추가 |
| 2 | `ALL_QUERY_DATA` Difference 분기 | `'Difference' AS VERSION_TYPE` 추가 (UNION ALL 컬럼 정합) |
| 3 | `MKT_FCST` 파생표 `SELECT DISTINCT` | `, F.VERSION_TYPE` 추가 (판정축 통과) |
| 4 | `VERSION_SORT` CASE | `A.MEASURE` → `A.VERSION_TYPE` |

③ 이 필요한 이유 : `MKT_FCST` 가 참조하는 `A` 는 CTE 가 아니라 그 위의 `SELECT DISTINCT` **파생표**다.
CTE 에만 컬럼을 추가하면 `ORA-00904 "A"."VERSION_TYPE"` 이 난다(1차 시도 실패 기록).
`VERSION_TYPE` 은 `MEASURE` 에 함수종속이라 `DISTINCT` 카디널리티는 불변.

**값 변경의 하류 영향 — 전수 확인 결과 깨지는 판정은 위 ④ 하나뿐**

| 소비 지점 | 판정 |
|---|---|
| `VERSION_SORT` CASE | ⚠ 영향 → ④ 로 정정 |
| 출력 컬럼 `A.MEASURE` | 의도한 표시 변경 |
| 편집권한 `A.MEASURE IN ('MKT_FCST_RP','RTF','CUST_FCST','VMI_IN_Req')` 외 3곳 | 무영향 — AS-IS 메저명과 비교라 본 SP 의 MEASURE 값과는 애초에 매칭 0 |
| `A.MEASURE = D.MEASURE` 조인 | 무영향 — 양변이 같은 CTE 라 동시 변경으로 정합 유지 |

### (b) Owner 필터 P53 (사용자 제시 2건)

| # | 변경 |
|---:|---|
| 1 | `IF P_OWNER IS NOT NULL AND P_OWNER <> '' THEN` → `IF P_OWNER IS NOT NULL THEN` |
| 2 | `LEFT OUTER JOIN TARGET_SITE_ITEM B` 조인키에 `AND A.DIVISION_ID = B.DIVISION_ID` 추가 |

## 3. ⚠ 전체본 교체다 — 동반 이관되는 변경

클라우드 접속 수단이 없어 **클라우드 현재 본문과 diff 를 뜰 수 없다**(hook #151).
본 패키지는 사내 현재 BODY **전체본**이므로, 클라우드가 아래 마커를 아직 갖고 있지 않다면 함께 넘어간다.

| 마커 | 건수 | 내용 |
|---|---:|---|
| `[E20260909-VERLABEL]` | 5 | 본 건 (메저명 = VERSION_ID) |
| `[E20260827-SHEETNAME]` | 1 | `V_SHEET_NAME` = `'Mkt Fcst Waterfall'` — 불일치 시 titleset 0행 → `ORA-00936` |
| `[E20260827-SORTCODE]` | 6 | 정렬코드 `'-'` → `ASC` / `VERSION_NO`·`MEASURE` ORDER BY 제외 / 고아 콤마 방어 |
| `[E20260827-DATEINS]` | 13 | DATE 컬럼 문자열 INSERT (NLS 의존 `ORA-01861`) 정정 |
| `[E20260827-NLSDATE]` | 7 | `TO_DATE(..., 'YYYYMMDD')` 명시 마스크 |
| `[hook#150 2026-09-06 AJS]` | 7 | DEPT_ID 원천 = `SCM_MST_SITE_ITEM.DEPT_ID` (SITE.DEPT_ID / OWNER 경유 폐기) |

⇒ 클라우드에 이 중 일부만 이미 있다면 **그 상태와 무관하게 사내 현재본으로 통일**된다.
특정 건만 넘기려면 알려 주시면 외과적 패치로 다시 만들겠습니다.

## 4. 적용 절차

```sql
-- SCM_MGR 로 접속 (SQL*Plus / SQLcl / SQL Developer 스크립트 실행 F5)
@01_PKG_DMF0040_SPEC.sql
@02_PKG_DMF0040_BODY.sql
@90_VERIFY.sql
```

SPEC 은 내용 변경이 없다(참조·재컴파일용). BODY 만 적용해도 되지만, SPEC 먼저 실행하면
클라우드 SPEC 이 구판이어서 생기는 시그니처 불일치를 사전에 제거한다.
파라미터는 `... P_BUCKET, P_USER_ID, P_MENU_ID, O_RC1, O_RESULT_CURSOR` 20개.

패키지는 상태 변수를 갖지 않아 재배포로 인한 `ORA-04068` 이 없다 → **BE 재기동 불요**.

## 5. 검증 게이트 (`90_VERIFY.sql`)

| 게이트 | 기대 |
|---|---|
| G1 | `PACKAGE` / `PACKAGE BODY` 둘 다 `VALID` (2행) |
| G2 | `USER_ERRORS` **0행** |
| G3 | `[E20260909-VERLABEL]` 마커 **5행** |
| G4 | LIVE `A.MEASURE = 'Version(` **0행** (주석으로만 존재해야 함) |
| G5 | `DIVISION_ID 조인키` 1 · `P_OWNER IS NOT NULL` 1 |
| G6 | 의존 객체 `INVALID` **0행** |
| G7 | `SCMP_APP` 시노님 1행 + `EXECUTE` 권한 1행 (없으면 화면에서 `PLS-00201`) |

### 화면 확인

MKT FCST Comparison 에서 버전 2개 선택 후 조회 →
메저 컬럼이 `Version(A)/(B)` 가 아니라 **선택한 VERSION_ID 그대로**(예 `MF_W_20260824_V001`) 표시되고,
행 순서는 최신버전 → 이전버전 → `Difference` 를 유지해야 한다.
Owner 는 콤마 다중 선택 시 각 Owner 행수의 **합**이 나와야 한다.

## 6. 사내 검증 실측 (2026-09-09)

배포 15:42:06 · BODY `VALID` · `USER_ERRORS` 0 · 의존 INVALID 0

`P_DMF0040_GET_MKT_FCST_COMPARISON` 직접 호출 (div40 / 20260801~20260930 / `MF_W_20260824_V001,MF_W_20260817_V001`)

| 축 | 결과 |
|---|---|
| MEASURE 분포 | `MF_W_20260824_V001` 258 / `MF_W_20260817_V001` 257 / `Difference` 271 |
| 정렬 | 단일 키 반환 순서 = 최신버전 → 이전버전 → Difference (유지) |
| OWNER 단일 | `SUNGWOOK SONG` → 3행 |
| OWNER 멀티 | `SUNGWOOK SONG,HYEONIL PARK` → **23행 = 3 + 20** (누락·교차오염 0) |

### FE 전달 규약 (중요)

생성 SQL 이 `REGEXP_SUBSTR('<P_OWNER>', '[^,]+', 1, LEVEL)` 형태로 **홑따옴표를 이미 감싼다.**
FE 는 `dodae,kim` 처럼 **따옴표 없는 raw 콤마 문자열**을 보내야 한다.
따옴표를 동봉하면 생성 SQL 이 파손된다. `P_VERSION_NO` 도 동일 구조.

## 7. ⚠ 동시배포 경합 (반드시 읽을 것)

오늘 사내 `PKG_DMF0040` BODY 는 다른 작업자와 번갈아 재배포되고 있다.

```
14:22 · 14:47 · 15:00 · 15:04 · [본 작업 15:30] · 15:35:42 · 15:36:44 · [본 작업 15:42] · [본 작업 15:56] · 15:59:11
```

- **15:35:42** 배포가 본 패치를 덮어 지웠다(→ 15:36:44 판 위에 재이식).
- **15:59:11** 배포가 다시 덮었다. 해당 배포본은 줄바꿈이 `CRLF` 로, 본 작업(`LF`)과 다른 출처다.
- ⇒ **2026-09-09 16:00 기준 사내 DB 에는 본 패치가 없다.** 본 패키지 파일에는 있다.

사내에 다시 넣으려면 `02_` 를 실행하면 된다. 다만 다른 작업자와 시점을 맞추지 않으면 또 덮인다.
재배포 전에는 항상 라이브 본문을 먼저 읽어 대조할 것(백업 후 sha 비교).

## 8. 범위 밖 (미포함)

- FE / BE / MSG·LBL·MNU 메타 / GTT·TYPE DDL : 변경 없음 — 동봉분 없음
- `SCMP_APP` 시노님 누락 17객체 : 별건 (G7 은 `PKG_DMF0040` 만 확인)
