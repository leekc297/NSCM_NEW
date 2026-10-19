# DMF0035 MKT FCST — 그리드 VERSION 빈값 정정 (클라우드 이관)

> 원장: `REQ:CHAT-20260916-W67` (`Doc/단위테스트_보완대상/보완요청_원장.md`)
> 마커: `[E20260916-VERCOL]` · 사내(ZIOUI1) 적용 완료 **2026-09-16 14:02:43** · 클라우드 **미적용**

## 1. 증상

DMF0035 `TYPE = MKT FCST` 조회 시 **그리드 VERSION 컬럼 값이 비어 있음**.

## 2. 원인 — 메타 이관 오류가 드러낸 SP 경로 단절

`SCM_MST_SHEET_COLUMNS` (`PROGRAM_ID='DMF0035'`, `SHEET_NAME='Mkt Fcst Waterfall'`)

| 컬럼 | AS-IS (MSSQL 직접 조회) | TO-BE | 판정 |
|---|---|---|---|
| VERSION_NO | SORT 220 · VISIBLE_FLAG=`N` · DEFAULT_FLAG=`''` · VALID=`Y` | SORT 220 · `Y` · `Y` · `Y` | **불일치** |
| MEASURE | SORT 500 · `N` · `''` · `Y` | SORT 999 · `Y` · `Y` · `Y` | **불일치** |

`P_DMF0035_GET_MKT_FCST_WATERFALL` 의 컬럼목록(`V_COL_LIST`) 생성부는 개인화(titleset `USER_INQUIRY_COLUMN_TYPE_CODE='C'`) 보유 시
`AND U.COLUMN_NAME NOT IN ('MEASURE','VERSION_NO')` 로 두 컬럼을 빼고, 바로 아래 UNION ALL **'숨은컬럼 arm'**
(`VISIBLE_FLAG='N' AND DEFAULT_FLAG 공백 AND VALID_YN='Y'`)으로 **무조건 재주입**한다. 즉 `NOT IN` 은 **중복 방지용 의도된 코드**다.
AS-IS 에서 이 arm 의 대상은 정확히 VERSION_NO·MEASURE **2개뿐**(실측).

TO-BE 는 두 컬럼이 `VISIBLE_FLAG='Y'/DEFAULT_FLAG='Y'` 로 이관돼 **arm 조건을 벗어났고 재주입 경로가 끊겼다.**
게다가 `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` 가 `DEFAULT_FLAG='Y'` 기준으로 개인화를 자동 시드하므로
TO-BE 는 사실상 **모든 사용자가 'C' 개인화를 갖고** ELSE 분기가 항상 도달한다 → 증상 100% 재현.

> 2026-09-09 `[E20260909-MEASURECOL]`(MEASURE 보장 삽입, 원장 W61)도 **같은 뿌리의 증상 패치**였다. VERSION_NO 만 가드를 못 받았다.

## 3. 조치 — SP 만 수정 (메타 무변경, 사용자 선택)

| # | 변경 | 위치 |
|---|---|---|
| ① | `NOT IN ('MEASURE','VERSION_NO')` → `NOT IN ('MEASURE')` | 컬럼목록 ELSE 분기 |
| ② | VERSION_NO 보장 가드 (`INSTR`=0 일 때만 `V_COL_LIST` + `V_ORDER_LIST` 보강) | MEASURE 가드 직후, REPLACE 규약 직전 |

①은 TO-BE 개인화에 VERSION_NO 가 제 자리로 시드돼 있으므로(사내 `minyonglee1` USER_SORT=10, DSMC=`ASC`)
제외만 풀면 `V_COL_LIST`·`V_ORDER_LIST` **양쪽**에 복귀하고, 기존 REPLACE 규약이
`VERSION_SORT,VERSION_NO` / `VERSION_SORT DESC,VERSION_NO` 로 확장해 **AS-IS 정렬 규약까지 복원**된다.
②는 사용자가 Column Setting 에서 VERSION 을 꺼도 축을 유지한다 — FE 가 VERSION_NO 를 `FORCED_AXIS`
(`waterfall.columns.ts` — "컬럼 설정으로도 끌 수 없다")로 선언한 계약과 일치. **MEASURE 축은 무변경.**

## 4. 파일 ↔ 작업 대조표

| 파일 | 내용 | 실행 |
|---|---|---|
| `01_PKG_DMF0035_BODY.sql` | `CREATE OR REPLACE PACKAGE BODY PKG_DMF0035` 전문 (**빌드 시점 사내 DB 추출** · SOURCE-FRESH 스탬프) | 1회 실행 |
| `02_VERIFY.sql` | V1~V5 검증 (객체 VALID / 오류 0 / 코드행 판정 / 컬럼목록 재현 / 런타임) | 01 직후 |

⚠ **DDL 은 이 SQL 1본뿐**이다. 메타(`SCM_MST_SHEET_COLUMNS`) · 콤보 · FE 변경 **없음**.

⚠ **코드행 판정 주의**: `[E20260909-MEASURECOL]` 주석문이 구 `NOT IN ('MEASURE','VERSION_NO')` 문구를 인용한다.
주석을 포함해 grep 하면 **오탐 FAIL** 이 난다 — `02_VERIFY.sql` V3 처럼 `LTRIM(TEXT) NOT LIKE '--%'` 로 거를 것.

## 5. 사내 검증 실측 (2026-09-16)

| 축 | 결과 |
|---|---|
| 배포 | 14:02:43 · PACKAGE BODY `VALID` · `USER_ERRORS` **0** |
| 컬럼목록 재현 | VERSION_NO **1건 복귀**, 중복 0 (정정 전 0건) |
| SP 실호출 (단일 버전) | div40 / `MF_D_20260825_V001` / MONTHLY / 2026-09~10, 24.3초 — O_RC1 정적축에 `VERSION_SORT`·`VERSION_NO` 포함, 샘플 5행 전부 값 채워짐 |
| SP 실호출 (다중 버전) | `MF_D_20260825_V001,MF_D_20260824_V001` 14.2초 — **1,808행 / 903+905 버전 분리**, NULL·빈값 **0행**, 정렬 선두 최신(25)→이전(24), `O_RESULT_CURSOR=('0','SUCCESS')` |

## 6. 영향 고지

- VERSION_NO 가 GROUP BY 축으로 복귀하므로 **버전이 합쳐져 보이던 행이 버전별로 분리**된다(행 수 증가). 워터폴 본래 동작이자 AS-IS 파리티.
- 자매 시트 **무영향** — `PKG_DMF0022`(Sales Plan) · `PKG_DMF0051`(Biz Plan) 은 `NOT IN … VERSION_NO` 자체가 **0건**이고,
  메타도 VERSION_NO `VISIBLE_FLAG='N'` + `DEFAULT_FLAG='-'/' '` 라 숨은컬럼 arm 이 정상 작동한다. **DMF0035 단독 결함.**

## 7. 원복

`_artifacts/_backup/PKG_DMF0035_VERCOL_20260916/PKG_DMF0035_body_BEFORE_20260916.sql`
(적용 직전 사내 DB 원문 — LAST_DDL 2026-09-11 15:48:28) 앞에 `CREATE OR REPLACE ` 를 붙여 실행.

## 8. 잔여 (본 패키지 범위 밖)

| # | 항목 | 비고 |
|---|---|---|
| ⓐ | DMF0035 `SHEET_COLUMNS` 의 VERSION_NO·MEASURE 플래그가 AS-IS(`N`/``) 및 자매 시트와 다른 `Y`/`Y` 로 잔존 | 증상은 해소됐으나 **메타 정합 미복원**. 정정 시 개인화 시드·표시 회귀 점검 필요 |
| ⓑ | `PKG_DMF0051` PACKAGE BODY **INVALID** (LAST_DDL 2026-09-10 18:08) | BIZ PLAN TYPE 조회 영향 가능 · 본 건과 무관한 선재 상태 |
