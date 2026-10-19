# 통합테스트 PROCESS FLOW + 테스트 데이터 SET

> **원천: ZIOUI1 실데이터만** (예측·추정 없음)
> host `ol9-db` · user `SCM_MGR` · 조회 **2026-09-18 07:56**
> **배치는 수동 실행 전제** — 관련 JOB 19개가 전부 `ENABLED=FALSE`

## 1. 사용자 확정 사항

| # | 결정 |
|---|---|
| 화면 정정 | **82 = DMF0020(단가) + DMF0003(MKT FCST)** — `DMF0083` 은 오기(저장소 전체 0건 확인) |
| 산출 성격 | 지정서 + 보완 SQL **둘 다** |
| 82 권한메타 | `GET_ADMIN_GROUP_MEASURE` 에 DMF0003/82 미등재 = **의도된 설계** |
| 산출 형식 | Markdown+Mermaid · Excel · HTML |
| 배치 | **수동 실행 전제** (실행 SP·인자 명시) |
| 52주 | **단가 입력 기간** |

## 2. 산출물

| 파일 | 내용 |
|---|---|
| `01_PROCESS_FLOW.md` | Mermaid mindmap + DIVISION 3축 flowchart + 단계표 |
| `02_PROCESS_FLOW.xlsx` | 3시트 — PROCESS_FLOW(30단계 / **14컬럼**) / DMF0035_3TYPE / 배치JOB_원스케줄 |
| `03_PROCESS_FLOW.html` | 단일 HTML (Mermaid CDN 렌더 + 전체 표 내장) |
| **`04_TESTDATA_SET.xlsx`** | ★ 6시트 — TESTDATA_SET(**115행 / 29컬럼**) / 대상ITEM_실측 / 권한매트릭스_실측 / **테스트계정_권한해석** / **CMBO_사전확인** / G1_데이터결손 |
| `05_SEED_SUPPLEMENT.sql` | 보완 SEED (멱등 MERGE · 비파괴 · 원복 포함) |
| `_raw/` | 재실행 스크립트 7본 + 실측 json |

## 2-1. 화면 ID ↔ 화면명 (실측)

권위 원천은 `SCM_ADM_MNU_M.MNU_MSG_ID` → `SCM_ADM_MSG_M.MSG_NM`(KO), MSG 미등록 시 `MNU_DESC`.
임의 명명 없이 `_raw/09_program_names.py` 가 추출한다.

| PROGRAM_ID | 화면명 | 근거 | 비고 |
|---|---|---|---|
| DMF0003 | MKT FCST | MSG `MNU00182` | |
| DMF0014 | Customer FCST Upload | MSG `MNU00036` | |
| DMF0020 | Sales Price | MSG `MNU_DMF0020` | |
| DMF0021 | Sales Plan | MSG `MNU00034` | |
| DMF0022 | Sales Plan Waterfall | MSG `MNU00044` | DMF0035 SALES PLAN TYPE 의 메타 소속 |
| DMF0035 | Demand Plan Waterfall | **`MNU_DESC` 폴백** | MSG `MNU00691` 이 `SCM_ADM_MSG_M` 에 **미등록** |
| DMF0042 | Business Plan | MSG `MNU00014` | |
| DMF0044 | Sales Reports | MSG `MNU00038` | |
| DMF0049 | ETC Sales Reports | MSG `MNU00039` | |
| DMF0051 | Biz Plan Waterfall | MSG `MNU00045` | **`USE_YN='N'`** (비활성 메뉴) — BIZ PLAN TYPE 메타 소속으로만 사용 |
| DMF0082 | **Fcst&Price MGMT** | MSG `MNU00042` | `MNU_DESC` 는 `Fcst MGMT` 로 다름 — **MSG 가 정본** |

도식 라벨은 `DMF0003(MKT FCST)` 형식. 단 마인드맵은 Mermaid 가 괄호를 노드 shape 문법으로
해석하므로 `DMF0003 · MKT FCST` 형식을 쓴다.

## 3. 프로세스 플로우 (30 단계)

**40** — DMF0082 단가/MKT_FCST/SCM_FCST → Cutoff 2회 → DMF0021 → DMF0044/0049 → DMF0042 → DMF0035 3 TYPE
**81** — EDI/DMF0014 CUST_FCST 유입 → DMF0082 3권한 → Cutoff → DMF0021 → DMF0035 2 TYPE
**82** — DMF0020 단가(52주) → **DMF0003** MKT_FCST → Cutoff → DMF0021 → DMF0035 2 TYPE

배치는 JOB 정의에서 **실측 인용**한 SP·인자로 수동 실행한다.
```sql
PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('40','MKT FCST Weekly Cutoff','MF_W','Weekly Rolling','system');
PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('40','SCM FCST Weekly Cutoff','SF_W','Weekly Rolling','system');
PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE('81','');
PR_DM_PLN_CUST_FCST_RECORD('81','EDI');          -- EDI CUST_FCST 유입
```

## 4. 테스트 데이터 SET (115행)

| 축 | 구성 |
|---|---|
| DIVISION | 40: 45행 · 81: 45행 · 82: 25행 |
| 구분 | 입력 90 · 검증 15 · 선행/배치 5 · 선행/입력 5 |
| 화면 | DMF0082 35 · DMF0021 25 · DMF0035 15 · DMF0003 10 · DMF0014/0020/0042/0044/0049 각 5 |
| 권한 | DM Planner 65 · SCP Planner 20 · DM Planner (W/S) 10 · 권한무관 20 |

각 행은 **ITEM / SITE / PROJECT / FCST_TYPE / INCOTERMS / DOM_EXP / PLANT_SITE** 7키가
ZIOUI1 에 **실존하는 조합**이며, 해당 measure 의 **보유 여부·기간·현재값(SUM QTY 또는 평균 단가)** 을 함께 싣는다.

### 대상 ITEM (FOCUS 메저 보유 기준 상위 5종)
| DIV | ITEM | FOCUS 보유 |
|---|---|---|
| 40 | `MCCM134010A1` `MCCM131012A1` `MCCM348014A3` `MCCM356015A2` `MCCM350415B1` | MKT/SCM/RTF/RTF_SYS_RP (4/5) |
| 81 | `ACLN1007I-A1` `ACHP2005I-A1` `ACLF1015I-A2` `ACLF1015I-B1` `AMFMCC727-D1-010` | MKT/CUST/RTF/RTF_SYS_RP (4/5) |
| 82 | `ETD1551AFB3A-XBA` `ETD1551AFB3C-XBA` `EH257064P8S1` `EH048189P3S1` `EP096636PFBA-AB0` | MKT/RTF/RTF_SYS_RP (3/5) |

### 테스트 계정 (실측) — ⚠ 2026-09-18 전면 정정

`DM Planner` 7명 · `DM Planner (W/S)` 5명 · `SCP Planner` 5명.

> **초판의 "`minyonglee1` 을 기본 계정으로" 는 무효다.**
> FE 가 권한을 해석하는 CMBO 3종(`FcstPriceUserAuthGroup` / `SalesPlanUserAuthGroup` /
> `BizPlanUserAuthGroup`)은 본문이 모두
> ```sql
> ORDER BY DECODE(M.USER_GR_ID, 'ADMIN', 1, 2), M.USER_GR_ID
> ```
> 이고 **FE 는 1행만 채택**한다. 따라서 ADMIN 을 겸직한 계정은 화면에서 **항상 `ADMIN` 으로
> 해석**되어 `DM Planner` / `SCP Planner` 권한 경계를 검증할 수 없다.

계정별 실측 해석 결과 (`_raw/08_acct_resolve.py`, 시트 `테스트계정_권한해석`):

| USER_ID | W/S 판정 | DMF0082 해석 | DMF0021 해석 | 판정 |
|---|---|---|---|---|
| `bpark416` `cmjin` `eunah.koo` `wcyoon` | N | `DM Planner` | `DM Planner` | ✅ DM Planner 검증용 |
| `ys_cho` | **Y** | `DM Planner` | `DM Planner` | ✅ W/S 겸직(설계상 정상 — W/S 는 별도 CMBO 로 판정) |
| `jaehyeok` `miyeong.lee` | **Y** | `DM Planner (W/S)` | (없음) | ✅ W/S 단독 검증용 |
| `bottle` `coeogus` `dodae` | N | `SCP Planner` | `SCP Planner` | ✅ SCP Planner 검증용 |
| **`minyonglee1` `jaehun_cho`** | Y | **`ADMIN`** | **`ADMIN`** | ❌ **권한경계 검증 불가** — `DM ADMIN/ADMIN` 단계(S40-10) 전용 |

배정 규칙: **순수 단일권한 계정 우선** → 보유그룹 수 적은 순. 지정서에
`해석authGroup(실측)` · `W/S판정(실측)` 두 컬럼을 추가해 행마다 근거를 싣는다.

## 5. 권한 매트릭스 (실측 `GET_ADMIN_GROUP_MEASURE`)

| 화면 | DIV | DM Planner | DM Planner (W/S) | SCP Planner |
|---|---|---|---|---|
| DMF0082 | 40 | `LOC` `MKT_FCST` `VMI_In_Req` | — | `SCM_FCST` (**MON**) |
| DMF0082 | 81 계열 | `LOC` `MKT_FCST` | `MKT_FCST` | `SCM_FCST` (**TUE**) |
| DMF0003 | 81 계열 | `MKT_FCST` | `MKT_FCST` | `MKT_FCST` (**TUE**) |
| DMF0021 | 40 / 81 계열 | `SalesAmt_LOC` | — | `RTF_SYS_RP` (81=**WED**) |
| DMF0021 | 82 | `SalesAmt_LOC` | — | — |
| DMF0020 / 0042 / 0044 / 0049 / 0035 | — | **메타 미등재 = 제한 없음 전제** | | |

`ATTRIBUTE1` = 편집 가능 **요일**. 테스트 일정에 직결된다.

## 6. 보완 SEED (`05_SEED_SUPPLEMENT.sql`)

| 대상 | 건수 | 방식 |
|---|---:|---|
| **81 SCM_FCST** | ITEM 5종 / **4,242행** | 같은 키의 **MKT_FCST 실데이터를 복제**해 MEASURE 만 치환 (QTY 값도 실데이터 그대로) |
| 40 BIZPLAN | ITEM 2종 | **자동 생성 안 함** — `DEPT_ID`·`BIZ_TYPE`·`ITEM_USE`·`UNIT_ENERGY` 가 파생 불가(임의값 금지). 화면 직접 입력 또는 ITEM 교체 |

멱등 MERGE · `CREATED_BY='TESTDATA_20260918'` 식별 · §0 사전확인 / §3 검증 / §4 원복 SQL 동봉.
**미실행 상태** — 실행은 별도 승인 후.

## 7. ⚠ 검증 중 발견한 제약 (지정서·플로우에 반영됨)

| # | 내용 |
|---|---|
| 1 | **DMF0082 는 division 82 조회 전용**(`V82-00`). FE `ForecastPrice.tsx:851~900` + 서버 `EDIT_FLAG='N'` 이중 차단 → 82 는 **DMF0003** 사용이 정답 |
| 2 | **DMF0049 G0 게이트**: `DM Planner` 는 **82 만** 편집 허용(`[C20210406-000259]`). 40 은 상위 권한 필요 → S40-10 권한을 `DM ADMIN/ADMIN` 으로 정정 |
| 3 | **DMF0020 편집 가능 division = 82 뿐** (lookup `DM_EDITABLE_DIVISION_ALLOW`). 40/81 단가는 DMF0082 LOC 축 |
| 4 | **CUST_FCST 유입 2경로**: EDI = `MEASURE='CUST_FCST_EDI'` / 수기·DMF0014 = `MEASURE='CUST_FCST'` — 구분 검증 필요 |
| 5 | **단가 원장이 division 별로 다름**: `DM_PLN_CFM_SELLING_PRICE` = **40 계열 전용**(81/82 는 0건) / `SCM_MST_FUTURE_PRICE` = 전 division |
| 6 | **81 SCM_FCST 원장 0건** — 권한메타에는 등재돼 있으나 데이터가 없다 → 신규 입력 시나리오 또는 SEED 보완 |
| 7 | **82 SCM_FCST 0건** — 82 프로세스에 SCM_FCST 단계 없음 |
| 8 | **ADMIN 겸직 계정은 권한경계 검증 불가** (위 §4) — `minyonglee1`/`jaehun_cho` 배정 금지 |
| 9 | **DMF0082 authGroup race**: 콤보 도착 전 조회가 나가면 `userGroup=userId` 로 measureAuth 미표시 응답이 남는다. `ForecastPrice.tsx:287~295` 가 그룹 확정 시 재조회하나, **첫 진입 직후 즉시 조회하면 재현**된다 → 테스트 시 콤보 로딩 완료 후 조회할 것 |

## 7-1. 테스트 전 사전확인 — CMBO 등록 (실측 2026-09-18, 전 10종 `USE_YN='Y'`)

| CMBO SQL_ID | USE_YN | 미등록/미사용 시 영향 |
|---|---|---|
| `MktFcstWsPlannerYn` | Y | ⚠ **0행이면 `wsPlannerYn=false` 로 조용히 degrade** — AS_In_Req·W/S FCST Type·AS FROM SITE 검증이 **오류 없이 전부 꺼진다** |
| `FcstTypeWs` | Y | 컬럼은 열리는데 MSG00476 미발화 (2026-08-06 사고) |
| `FcstTypeEditMode` | Y | W/S FCST Type 스왑 불가 |
| `FcstPriceUserAuthGroup` / `SalesPlanUserAuthGroup` / `BizPlanUserAuthGroup` | Y | 권한별 편집 measure 판정 불가 |
| `SalesFuturePriceEditableDivision` | Y | 82 단가 입력 불가 (DMF0020) |
| `MyDivision` | Y | DMF0035 조회 불가 (MSG00097) |
| `DMF0042_BP_Measure` | Y | DMF0042 삽입 차단 MSG00113 |
| `Dmf0003ScpPlannerEditFlag` | Y | 0행 = DMF0003 편집 차단 MSG00477 |

`MktFcstWsPlannerYn` 본문 (실측):
```sql
SELECT CASE WHEN EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M
        WHERE USER_ID = @sesUserId AND USER_GR_ID = 'DM Planner (W/S)')
       THEN 'Y' ELSE 'N' END AS CODE, 'WS_PLANNER' AS NAME FROM DUAL
```
→ W/S 5개 계정 전부 `CODE='Y'` 반환 확인.

## 8. 미해소 공백

1. **81 EDI CUST_FCST 유입 절차는 신규 정의** — 기존 문서에 없었다
2. **DMF0042 는 보완요청 원장 0건** — 통합테스트 축 자체가 공백
3. **DMF0035 TestCases 없음** — waterfall 데이터 정합 검증은 이번에 신규 정의
4. **기존 "통합테스트 시나리오"는 없었다** — 1st/2nd xlsx 는 **화면별 결함 92건 목록**이다. 본 산출물의 `대응결함No` 컬럼으로 역매핑해 커버리지를 확보했다
5. `DMF0049`·`DMF0044` 는 FE 가 `userGroup` 에 **userId 를 전달** → FE 권한 게이트가 사실상 발화하지 않는다(서버 `EDIT_AUTH_V` 의존)

## 9. 재실행

```
_raw/01_collect.py        권한·계정·배치JOB·배선·버전 수집
_raw/02_pick_targets.py   (v1 이력)
_raw/03_pick_v2.py        FOCUS 메저 기준 대상 ITEM 선별
_raw/04_flow_def.py       PROCESS FLOW 정의 (단일 원천)
_raw/05_build_flow.py     01/02/03 생성
_raw/06_build_testdata.py 04 생성
_raw/07_build_seed.py     05 생성
_raw/08_acct_resolve.py   계정별 권한해석 실측 (06 의 입력)
_raw/09_program_names.py  화면 ID -> 화면명 실측 (04/05/06 의 입력)
```

---

## 10. ⭐ v3 — `08_SAMPLEDATA_STEPNO_v3.xlsx` (2026-09-20)

### 10-1. 배경

`07_SAMPLEDATA_STEPNO_v2.xlsx` 가 신규 기준(G열 요구 · IF/UPLOAD/N:N LAYOUT · VMI ·
INCOTERMS EDIT_FLAG · Cell Prod Site)으로 TestData 3시트를 **새로 만들면서**
v1(`06`) 양식의 36컬럼 중 **13컬럼이 사라졌다**.

| 사라진 컬럼 (v1 → v2) |
|---|
| `Step` `엑셀항목` `실제화면` `화면명` `해석authGroup(실측)` `W/S판정(실측)` `편집요일` `권한메타근거` `등록값명세` `기간(실측)` `현재값(실측)` `검증화면` `대응결함No` |

또한 v2 는 `샘플지정='N'` STEP(40 12-1/12-2/13-1/14-1 · 81 14-1 · 82 12-1)을 통째로
떨어뜨렸고, `항목` 컬럼에 **ITEM_ID 가 들어가는 결함**이 있었다.

> **결함 원인** — `_raw/32_build.py` 의 `item` 변수가 정규화 루프의
> `item = rec.get("ITEM_ID") or ""` 에 덮여 STEP 의 항목명이 사라진다.
> 40TestData 1-1 의 `항목` 이 `385665`(ITEM_ID) 로 찍힌 것이 그 흔적.

### 10-2. v3 = 이전 양식 유지 + 신규 데이터 합류

| 구분 | 내용 |
|---|---|
| 컬럼 | **1~36 = 06 양식 그대로(순서 포함)**, 37~45 = v2 신규 9컬럼 뒤에 추가 |
| 추가 9컬럼 | `END_CUSTOMER` `INCOTERMS_EDIT_FLAG` `CELL_PROD_SITE_ID` `CURRENCY` `화면LAYOUT원천` `LAYOUT컬럼수` `G열요구사항` `STEP시트` `행출처` |
| 행 | v1 299행 + v2 300행 − 동일키 병합 50행 = **549행** |
| 병합 규칙 | 같은 키의 v1·v2 행은 **v1 행을 남기고** v2 의 신규 컬럼만 채움 (v1 의 `기간/현재값` 실측 보존). 같은 회차 안에서는 병합하지 않음 — IF LAYOUT 행은 7키 투영이 전부 `-` 라 서로 달라도 키가 같아지기 때문 |
| STEP 시트 | 30개 (`40_1-1` ~ `82_10-1`). 메타 17컬럼(TestData 와 동일 프레임) + LAYOUT 전 컬럼, 2행 = 컬럼 라벨 |

| 시트 | 행수 | 데이터출처 |
|---|---:|---|
| `40TestData` | 160 | 기존 80 · 기존IF 5 · 신규SSPM 60 · 신규기준정보 10 · 신규VMI 5 |
| `81TestData` | 230 | 기존 105 · 기존IF 25 · 신규SSPM 70 · 신규기준정보 30 |
| `82TestData` | 159 | 기존 60 · 기존IF 10 · 신규SSPM 75 · 신규기준정보 14 |

`행출처` 컬럼으로 v1(06) / v2(07) / v1+v2 병합을 행마다 식별할 수 있다.

### 10-3. 검증 게이트 (`_raw/43_verify_v3.py` — 2026-09-21 **G1~G13 전체 PASS**)

| 게이트 | 내용 | 결과 |
|---|---|---|
| G1 | DIVISION 3시트 = 07 원본과 셀 단위 동일 (무변경) | PASS |
| G2 | TestData 앞 36컬럼 = 06 헤더와 순서까지 동일 | PASS (확장 9컬럼은 뒤) |
| G3 | 06 의 299행 전수 승계 — 비교 20컬럼 완전일치 | PASS · 미승계 0 |
| G4 | `항목` 컬럼 오염 0건 (07 결함 정정 확인) | PASS |
| G5 | DIVISION `샘플 Link`='샘플' 인 30 STEP 전수가 TestData 행 + STEP 시트 보유 | PASS |
| G6 | STEP 시트 30개 행수 = 07 대응 시트와 일치 | PASS |
| G7 | v2 유래 행 INCOTERMS 에 EDIT_FLAG='N' 0건 | PASS |
| G8 | 필수 11컬럼 공백 0건 | PASS |
| G9 | '기존' 분류 행 전수가 선별근거(`분류기준`) 보유 | PASS |
| G10 | `미측정(재조회 필요)` 잔존 0행 | PASS |
| G11 | **'기존' 260행 전수가 원장에 실존** | PASS · 위반 0 |
| G12 | STEP 시트 LAYOUT 중복 컬럼명 0 | PASS |
| G13 | 공백 LAYOUT 컬럼 438건 전수가 `_LAYOUT_GAP` 에 사유 등재 | PASS |

G3 의 **보강 셀 340개** = v1 에서 `-`/공백이던 `편집요일`·`권한메타근거`·`등록값명세`·
`데이터보유/기간/현재값(실측)` 을 2026-09-21 실측으로 채운 것. 값 손실 아님.

### 10-4. 2026-09-21 DB 복구 후 실측 반영

09-20 시점의 ZIOUI1 다운이 해소돼(`2026-09-21 04:52` 접속 확인) 미측정분을 전부 닫았다.

| # | 처리 | 결과 |
|---:|---|---|
| 1 | **재선별** — `40 13-1`(DMF0042/BIZPLAN) 4행의 키가 `DM_PLN_BIZPLAN` 에 **실존하지 않음**(각 값 단독으로는 존재, 조합이 없음) | 같은 division 실존 조합(각 60행)으로 교체 · `분류기준` 에 사유·일자 기록 · `행출처`=`v1(06)+재선별` |
| 2 | **재측정** — '기존' 245행의 `데이터보유/기간/현재값(실측)` | 키 미존재 0 · 조회오류 0 |
| 3 | **LAYOUT 채움** — STEP 시트 공백 재조회 | 206셀 채움 |
| 4 | **중복 컬럼 제거** — 30_layouts 가 division 토큰 중복분을 그대로 실어 같은 COLUMN_NAME 이 반복 | 109개 제거 |
| 5 | **`_LAYOUT_GAP` 시트 신설** — 잔여 공백 438건 전수 사유 등재 | A 148 / B 225 / C 47 / D 18 |

`_LAYOUT_GAP` 사유 4분류:

| 코드 | 사유 | 건수 |
|---|---|---:|
| A | 저장 원장에 **컬럼 자체가 없음** — 화면 표시/파생 컬럼 (`VMI_STD_DIO` `VERSION_NO` `END_CUSTOMER40` `PRICE_EXIST` 등) | 148 |
| B | 컬럼은 있고 매칭 레코드도 있으나 **값이 NULL** | 225 |
| C | **'신규' 분류 행** — 원장에 아직 없음 = 테스터 입력 대상 | 47 |
| D | **UPLOAD LAYOUT(`81_4-3`)** — 엑셀 헤더 라벨 ↔ 원장 컬럼 매핑 미확보 | 18 |

> A/B/C 는 공백이 **정상**이다. 임의값으로 메우지 않는다.
> **잔여 조치 대상은 D 18건뿐** — `SCM_ADM_EXCEL_COLUMNS` ↔ `DM_PLN_CUSTOMER_PSI` 매핑 확보 시 해소.

#### 측정 중 발견·정정한 스크립트 결함 6건

| # | 결함 | 증상 | 정정 |
|---:|---|---|---|
| 1 | 센티널(`미측정(재조회 필요)`)을 WHERE 값으로 사용 | 허위 '키 미존재' 10건 | `SENTINEL` 필터 (42/44) |
| 2 | 신규 행에도 `미측정` 표기 | 신규는 실측 대상이 아님 | 신규 → `-` (41) |
| 3 | 조회 전용 화면(DMF0044/0049/0035)의 v1 실측치를 `⚠ 표 없음` 으로 덮어씀 | v1 측정치 소실 | 저장원장 `-` 이면 미갱신 (42) |
| 4 | IF 행을 **하류 원장**으로 측정 | `82 3-1` 허위 미존재 5건 (실제 출처 `SCM_DNM_STOCK` 3,746행) | `IF_SRC` 단일 원천 + `STEP시트` 로 조회 (42/44) |
| 5 | 7키 축이 아닌 LAYOUT(EDI HEAD/PARTNER) | `조회키 없음` → 미측정 10행 | 표 단위 측정 폴백 + 표기 명시 (42) |
| 6 | 쓰기 스크립트 출력을 `head` 로 파이프 | BrokenPipe 가 `wb.save()` 전에 중단 → 저장 유실 | 파이프 없이 로그 파일로 실행 |

> 성능 참고 — `SCM_MGR.SCM_DNM_STOCK`(200만행)에 `ITEM_ID` 인덱스가 없다
> (`IDX01`=DIVISION_ID+CUTOFF_DATE+SCM_SITE_ID / `IDX02`=CUTOFF_DATE+DIVISION_ID+STOCK_TYPE).
> `82 3-1` 5행 측정에 풀스캔이 걸린다.

### 10-5. 재실행 (순서 고정)

```
_raw/40_stepdef_v3.py      v3 STEP 정의 (단일 원천 — v1 30 STEP + v2 신설 합집합)
_raw/41_build_v3.py        08_SAMPLEDATA_STEPNO_v3.xlsx 생성
_raw/45_reselect_missing.py --write   원장 미존재 키 재선별
_raw/42_refill_measure.py   --write   데이터보유/기간/현재값 실측 + 키 실존 재검증
_raw/44_refill_layout.py    --write   STEP 시트 LAYOUT 공백 채움
_raw/46_layout_gap.py                 `_LAYOUT_GAP` 사유 시트 생성
_raw/43_verify_v3.py                  검증 게이트 G1~G13
```

⚠ **출력을 `head`/`tail` 로 파이프하지 말 것** — BrokenPipe 가 저장을 끊는다.
⚠ **엑셀에서 08 파일을 닫고 실행할 것** — 열려 있으면 `PermissionError` 로 저장 거부된다.
