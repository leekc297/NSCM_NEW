# DMF0035/0022/0051 — 개인화 DIVISION 필터 일괄 적용 (클라우드 이관)

> 원장 `REQ:CHAT-20260916-W69` · 마커 `[E20260916-PERSDIV2]` / `[E20260916-MEASDIV35]`
> 사내(ZIOUI1) 적용 완료 **2026-09-16 15:59:17** · 클라우드 **미적용**

## 1. 신고 증상 (사용자 2026-09-16)

> DMF0035 조회 시, DB 에 저장된 개인화 COLUMN·MEASURE 가 **조회 시점의 DIVISION 과 다른 경우**,
> 개인화를 저장하기 전에 조회하면 다른 DIVISION 으로 개인화된 COLUMN·MEASURE 가 그대로 조회된다.
> 조회 시점에 개인화 등록분이 자신의 DIVISION 에 포함되지 않으면 **전부 제외**되어야 한다.

## 2. 재현 (사내 실측)

`minyonglee1` 의 Mkt Fcst Waterfall 개인화에는 `END_CUSTOMER`(82·81 전용)와 `END_CUSTOMER40`(40 전용),
`ITEM_ID`↔`ITEM_ID40`, `SCM_SITE_ID`↔`SCM_SITE_ID40` 이 **쌍으로 모두** 들어 있다.
정정 전 SP 실행 결과 **div40 과 div81 이 완전히 동일한 정적 컬럼축(19개)** 과 **동일한 메저 23종**을 반환했다.

## 3. 원인 — 세 갈래

| # | 축 | 상태 |
|---|---|---|
| ① | **컬럼** `PKG_DMF0035` · `PKG_DMF0022` | 개인화('C') 컬럼목록에 division 필터 **없음**. 같은 축을 **TITLE SP 와 FE 컬럼메타 SP 는 이미 필터**한다(TITLE: DMF0035 `INSTR(...)>0` / DMF0022 `20180620 division 추가`, FE: `PR_GET_SHEET_COLUMN_LIST`). 메인 데이터 SP 만 안 걸러져 **화면에 없는 컬럼이 SELECT/GROUP BY/PIVOT 축**으로 남았다 (`[E20260910-GRAINFIX]`·`[E20260916-DIVBLANK]` 동일 계보) |
| ② | **메저** `PKG_DMF0035` | 필터가 **있으나 무효**. 토큰 목록을 `ROWNUM = 1` 로 뽑은 **임의의 한 행**의 `DIVISION_ID` 에서 만들고 그 TOKEN 으로 각 메저 자신의 `DIVISION_ID` 를 덮어썼다. 그 한 행의 값이 `40,82,81,81_UC,…`(전 사업부)라 **어떤 division 으로 조회해도 전부 통과** → `[E20250807-001418]` 의 의도가 전혀 작동하지 않았다 |
| ③ | `PKG_DMF0051` | 컬럼(`[C20221107-000343]`)·메저(`[E20260910-MEASDIV]`) **둘 다 이미 보유** → **무변경** |

## 4. 조치

| PKG | 컬럼('C') | 메저('M') |
|---|---|---|
| `PKG_DMF0035` | ✅ 필터 추가 `[E20260916-PERSDIV2]` | ✅ `ROWNUM=1` 결함 정정 `[E20260916-MEASDIV35]` — `PKG_DMF0022` 방식(자기 행 토큰화)과 동일 |
| `PKG_DMF0022` | ✅ 필터 추가 `[E20260916-PERSDIV2]` | 이미 정상(`[E20250520-000574]`) |
| `PKG_DMF0051` | 이미 정상 | 이미 정상 | **파일 없음(무변경)** |

판정식은 **FE 컬럼메타 SP 와 동일**하게 맞췄다 — `C.DIVISION_ID IS NULL OR INSTR(','||C.DIVISION_ID||',', ','||P_DIVISION_ID||',') > 0`
(NULL = 전 division 허용, 공백 `' '` 은 불일치로 제외). 메저는 `DIVISION_ID` 가 NULL 이면 제외되며 3본 공통 동작이다(2026-09-10 사용자 결정).

## 5. ⚠ AS-IS 파리티 이탈 고지

AS-IS `DMF0022` 는 이 조건을 **2019-01-25 에 의도적으로 주석처리(KHSONG)** 했고, TO-BE 도 2026-09-10 `[E20260910-PERSDIV]` 로
넣었다가 **원복**한 이력이 있다(사유: 컬럼목록이 GROUP BY 에도 쓰여 grain 이 바뀜 — div81 에서 -29행).
본 적용은 **사용자 지시에 따른 의도적 AS-IS 이탈**이다. 원복 코멘트는 삭제하지 않고 그대로 보존했다.

**다만 그 회귀는 이번 실측에서 재현되지 않았다.** 원인 매핑을 다시 뜯어보니:

| PKG | `END_CUSTOMER40` 매핑 | 제외 시 grain |
|---|---|---|
| DMF0035 | `CASE WHEN A.DIVISION_ID='40' THEN A.PROJECT_CODE ELSE ' ' END` | div≠40 에선 **상수** → 영향 없음 |
| DMF0022 | `A.PROJECT_CODE AS END_CUSTOMER40` (무조건) | PROJECT_CODE 운반체 — **위험 실재** |
| DMF0051 | 동일(무조건) | AS-IS 부터 필터 보유 |

⇒ 위험은 **DMF0022 에 한정**되며, 그 사용자 개인화에 `PROJECT_CODE` 가 따로 있으면 운반체가 유지된다
(`minyonglee1` 은 보유 — div81/82 에서 유지됨).

## 6. 검증 (사내 2026-09-16)

| 축 | 결과 |
|---|---|
| 배포 | 15:59:17 · `PKG_DMF0035`/`PKG_DMF0022` BODY **VALID** · `USER_ERRORS` 0 · `PKG_DMF0051` VALID(무변경) |
| **컬럼 A/B — DMF0035 div40** | 정적축 19 → 16 (`END_CUSTOMER`·`SCM_SITE_ID`·`ITEM_ID` 제외) · **행수 1,106 → 1,106 (변화 0)** ⇒ PERSDIV 회귀 미재현 |
| 컬럼 A/B — DMF0035 div81 | 정적축 19 → 16 (`END_CUSTOMER40`·`SCM_SITE_ID40`·`ITEM_ID40` 제외 — div40 과 **반대쪽**이 빠짐) |
| 컬럼 A/B — DMF0022 div81 / div40 | 22 / 19 축으로 축소 (`END_CUSTOMER40`,`CUST_GROUP` / `END_CUSTOMER`,`PROJECT_CODE`,`TEXT`,`PLANT_SITE_ID`,`FROM_SITE_ID`) |
| **메저 통제 검증** | 시험 계정에 5종(MKT_FCST/SCM_FCST/LOC/MKT_FCST_ENERGY/SFA) 개인화 후 division 별 실행 →<br>div40 = MKT_FCST·SCM_FCST / div82 = MKT_FCST·MKT_FCST_ENERGY·SFA / div81 = MKT_FCST·SCM_FCST·LOC·SFA<br>**각 메저 자신의 DIVISION_ID 기준으로 정확히 일치.** 시험 행 5건 삭제 완료 |

⚠ DMF0022/DMF0035 div81 는 해당 파라미터에서 데이터가 0행이라 **행수 A/B 는 div40(1,106행)에서만** 성립한다.

## 7. 파일 ↔ 작업 대조표

| 파일 | 내용 |
|---|---|
| `01_PKG_DMF0035_BODY.sql` | 컬럼 필터 + 메저 정정 (빌드 시점 DB 추출 · SOURCE-FRESH) |
| `02_PKG_DMF0022_BODY.sql` | 컬럼 필터 (동일) |
| `03_VERIFY.sql` | V1~V7 |
| — | `PKG_DMF0051` 은 **무변경**이라 파일을 넣지 않는다(V5 로 보유 상태만 확인) |

## 8. 원복

`_artifacts/_backup/PKG_PERSDIV2_20260916/PKG_DMF00{35,22}_body_v3.sql` (적용 직전 원문) 앞에
`CREATE OR REPLACE ` 를 붙여 실행. A/B 측정치 = 같은 폴더 `ab_before.json` / `ab_after.json`.

## 9. 잔여 (범위 밖 — 사용자 판단 필요)

개인화가 **하나도 없는** 사용자용 분기(IF branch, `SHEET_COLUMNS.DEFAULT_FLAG='Y'` 기준)에는
여전히 division 필터가 없다. TO-BE 는 `PR_GET_SHEET_COLUMN_LIST` 가 진입 시 개인화를 자동 시드하므로
이 분기는 거의 도달하지 않지만, 도달하면 같은 증상이 난다. 확장 여부는 지시 필요.
