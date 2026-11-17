# 사내 PKG 원문의 빈 문자열 비교 구문 조사 (2026-11-13)

> 범위: 사내 Oracle ZIOUI1 · OWNER=`SCM_MGR` · `PACKAGE BODY` / `PROCEDURE` / `FUNCTION` (TRIGGER 도 함께 받았고 일치 0줄).
> 작업 성격: 조사·보고(§1~§8 은 DB 객체 수정 없이 SELECT 만). **(a) 14줄은 사용자 지시로 2026-11-13 18:39 사내 적용**(§9). `nscm-fe`·`nscm-be` 수정 0건.
> 줄별 결과: [2026-11-13_EMPTY_STRING_COMPARE_조사.csv](2026-11-13_EMPTY_STRING_COMPARE_조사.csv) (939행 = 부등·NOT IN 578행 + 등호 `= ''` 361행). 등호 비교는 §8.
> 수치 출처: 이번 조회 실측. 원문 기준 시각 = `ALL_SOURCE` 전체 조회 2026-11-13 18:06:13(DB SYSDATE) · 1,235개 객체 1,248,849줄.

## 1. 결론

| 항목 | 값 | 출처 |
|---|---:|---|
| 실행되는 자리에 있는 빈 문자열 부등 비교(`<> ''` · `!= ''`) | **34줄 / 14개 객체** | 토큰 분석(주석·문자열 리터럴 구분) 18:06 원문 |
| 그중 결과를 틀리게 하는 줄 — 분류 (a) | **6줄 / 5개 객체** | 문맥 열람 + 실측(§3) |
| 그중 결과에 영향 없는 줄 — 분류 (b) | 28줄 / 11개 객체 | `IS NOT NULL` 과 OR 로 묶임 |
| 실행되는 자리에 있는 `NOT IN (…, '')` | **0줄** | 토큰 분석 + 문자열 연결 복원 재검사 |

- §15-1 의 `NOT IN (…, '')` 8줄 / 8개 객체는 8줄이 블록 주석 안의 AS-IS 메모(`/* AS-IS : CELL_PROD_SITE_ID NOT IN ('-', '')`)다. 실행 코드가 아니다.
- §15-1 의 170줄 / 78개 객체 중 실행 코드는 32줄(a 4 · b 28)이고 138줄은 주석이다(§2-2).
- 줄 단위 정규식이 잡지 못한 결함 2줄이 따로 있다: `PKG_DMF0035` 3226·3229줄(동적 SQL 문자열 안 `''''`).

## 2. 조사 방법

### 2-1 실측 재확인 (사내 DB 2026-11-13 18:05:14 · 18:09:35)

| 조회 | 행 수 |
|---|---:|
| `SELECT COUNT(*) FROM DUAL WHERE 'A' <> ''` | 0 |
| `… WHERE 'A' NOT IN ('ALL','%','')` | 0 |
| `… WHERE 'A' NOT IN ('ALL','%')` | 1 |
| `… WHERE NVL('5','') <> ''` | 0 |
| `… WHERE 'X' IS NOT NULL AND 'X' <> ''` | 0 |
| `… WHERE ('X' IS NOT NULL OR 'X' <> '')` | 1 |
| `… WHERE (NVL('X','') != '' OR 'X' IS NOT NULL)` | 1 |
| `… WHERE NVL('5','''') <> ''''` (작은따옴표 1자와 비교) | 1 |

### 2-2 §15-1 수치 재현

§15-1 에 정규식 원문이 적혀 있지 않아 변형 15종을 18:06 원문에 적용했다. 아래 조합이 §15-1 수치와 같다.

| 구문 | 정규식(줄 단위) · 제외 조건 | 이번 결과 | §15-1 |
|---|---|---:|---:|
| 1 | `(<>\|!=)\s*''(\s\|\)\|$)` · `--` 로 시작하는 줄 제외 | 170줄 / 78객체 | 170줄 / 78객체 |
| 2 | `NOT\s+IN\s*\([^)]*,\s*''\s*[,)]` · `--` 로 시작하는 줄 제외 | 8줄 / 8객체 | 8줄 / 8객체 |

이 178줄의 분류: (a) 4 · (b) 실행 코드 28 · (b) 주석 120(구문1 118 + 구문2 2) · (d) 주석 26(구문1 20 + 구문2 6). CSV `정리안15_1_일치` 열 = Y.

### 2-3 정규식 1회로 끝내지 않은 것

1. **넓은 정규식** — `(<>|!=|^=|~=)\s*''` · `''\s*(<>|!=|^=|~=)` · `NOT\s+IN\s*\([^)]*''` 를 주석 제외 없이 적용 → 578줄(줄·구문 기준) / 125개 객체. CSV 는 이 578줄을 담는다(§15-1 의 178줄 포함).
2. **토큰 분석** — 객체 원문을 주석(`--` · `/* */`) / 문자열 리터럴(`'…'` · `q'[…]'`) / 코드로 나눠, 코드 자리의 빈 리터럴 `''` 가 부등 연산자 옆이나 `NOT IN` 목록 원소인 곳을 찾음 → 코드 자리 32줄. 일치가 있는 125개 객체 중 미종결 문자열이 생긴 객체 0개(분석기 어긋남 없음).
3. **동적 SQL 한 겹 더** — 문자열 리터럴의 내용(이스케이프 해제 후)에 같은 분석 적용 → 2줄(`PKG_DMF0035` 3226·3229).
4. **문자열 연결 복원** — `'…' || 변수 || '…'` 를 문장 단위로 이어 붙인 뒤 재분석(여러 리터럴에 걸친 `NOT IN` 목록·비교 대비) → 같은 2줄, 추가 일치 0.
5. **대조** — 578줄마다 토큰 상태(코드 / 문자열 / 주석)를 붙여 2~4 결과와 맞춤. 자동 분류 규칙에 걸리지 않은 줄 0.

### 2-4 한계 (미확인으로 남는 것)

- 변수에 담긴 빈 문자열과의 비교(`V := ''; … X <> V`)는 찾지 못한다. 미조사.
- VIEW · MATERIALIZED VIEW 원문(`ALL_VIEWS`)은 범위 밖. 미조사.
- 등호 비교 `= ''` 353줄 / 63개 객체는 2차 조사에서 분류했다(§8).
- (b) 28줄은 AS-IS 원문 대조를 하지 않았다.
- 운영 호출 여부는 `SCM_ADM_PROC_M` 등록 · `ALL_DEPENDENCIES` · `SCM_SYS_LOG_BATCH` 로만 확인했다. BE 가 등록 없이 부르는 경로는 확인하지 못했다.

## 3. 분류별 건수 (CSV 578행)

| 분류 | 뜻 | 실행 코드 | 동적 SQL 문자열 | 주석 | 계 |
|---|---|---:|---:|---:|---:|
| a | 조건이 항상 거짓 → 결과가 틀림 | 4 | 2 | 0 | **6** |
| b | 결과 영향 없음(OR 로 묶임 · 주석) | 28 | 0 | 296 | 324 |
| c | 다른 의미(따옴표 이스케이프 · 변수 연결 · 작은따옴표 1자 리터럴) | 12 | 146 | 0 | 158 |
| d | 백업·임시 객체(`_BAK` · `_1104*` · `PKG_S39V*` · `PKG_ZTMP_*` · `SCM_ADM_PROC_M` 등록 0행) | 0 | 41 | 49 | 90 |
| 미확인 | | 0 | 0 | 0 | 0 |

- (d) 13개 객체: `PKG_DMF0082_BAK1109` 21 · `PKG_DMF0082_1104` 13 · `_1104A` 13 · `_1104B` 13 · `_1104C` 13 · `PKG_ZTMP_S200B` 7 · `PKG_ZTMP_S015J` 4 · `PKG_S39V2`~`V7` 각 1. 13개 모두 `SCM_ADM_PROC_M` 등록 0행(18:09 조회). 이 객체들에 실행되는 빈 문자열 비교는 0줄이다.
- (c) 실행 코드 12줄 = `PR_DM_PLN_CUST_FCST_RECORD` 6줄 · `PR_DM_PLN_CUST_FCST_RECORD_TEMP` 6줄의 `NVL(D.ATTRIBUTE8, '''') <> ''''`. 리터럴이 작은따옴표 1자라 값이 있으면 참이다. AS-IS 같은 자리도 `ISNULL(D.ATTRIBUTE8, '''') <> ''''`.

## 4. (a) 목록 — 6줄

| # | 객체 · 서브프로그램 | 줄 | 원문 | 일어나는 일 | AS-IS 같은 자리 | 권장 대체 |
|---:|---|---:|---|---|---|---|
| 1 | `PKG_DMF0035` · `P_DMF0035_GET_MKT_FCST_WATERFALL` | 3226 | `'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' ' \|\|` | 실행 문장이 `NVL(C.ATTRIBUTE8, '') <> ''` → CASE 가 ELSE NULL → `KWH_MODULE` NULL | `DMF0035_GET_MKT_FCST_WATERFALL` 4080줄 `ISNULL(C.ATTRIBUTE8, '''') <> ''''` | `C.ATTRIBUTE8 IS NOT NULL` |
| 2 | 같음 | 3229 | `'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' ' \|\|` | 같음 → `KWH_PACK` NULL | 같은 SP 의 KWH_PACK 줄 | `C.ATTRIBUTE8 IS NOT NULL` |
| 3 | `PKG_DMF0045` · `P_DMF0045_GET_SHIPMENT_REQUEST` | 1295 | `AND A.STORAGE_ID     <> ''` | UNION ALL 첫 가지(SCM_MST_LOCATION 기준 storage 목록) 0행 → 그 목록과 조인하는 기초재고(`GT_DMF0045_BOH`) 집계에서 빠짐 | `DMF0045_GET_SHIPMENT_REQUEST` 1452줄 `AND (storage_id IS NOT NULL AND storage_id <> '')` | 1295줄 삭제(1294줄 `IS NOT NULL` 유지) |
| 4 | `PKG_DMF0003` · `P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` | 15009 | `IF S_FUTURE_VALID IS NOT NULL AND S_FUTURE_VALID <> '' THEN` | 'Sales Price 중복' 검증(`RAISE EX_INVALID`)이 실행되지 않고 15016줄 INSERT 로 진행 | `DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` 1109줄 `if @s_FUTURE_valid <> ''` | `IF S_FUTURE_VALID IS NOT NULL THEN` |
| 5 | `PKG_DMF0003_01` · `P_DMF0003_01_SAVE_MKT_FCST_PK_DATA_UPDATE` | 16525 | 4번과 같은 문장 | 같음 | 같음 | 같음 |
| 6 | `PR_SCM_DNM_DELIVERY_TRACKING` | 54 | `AND (SELECT NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' AND OLD_VALUE1 = XIF_ERP_DELIVERY_TRACKING_R_SN.ATTRIBUTE1) <> ''` | COMPANY_ID 신코드 치환 UPDATE 0행 | `PR_SCM_DNM_DELIVERY_TRACKING` 65줄 같은 문장(`<> ''`) | `… ) IS NOT NULL` |

AS-IS 조회: MSSQL `LGCE_SCMDEV` `sys.sql_modules` 2026-11-13 18:10:32. MSSQL 은 `''` 가 빈 문자열이라 6곳 모두 "값이 있으면 참"으로 동작한다.

### 4-1 데이터 영향 실측 (사내 DB 18:10~18:12)

| # | 조회 | 결과 |
|---:|---|---|
| 1 | `SCM_MST_SITE_ITEM` `DIVISION_ID LIKE '81%' AND CELL_PER_MODULE>0 AND ATTRIBUTE8 IS NOT NULL` | 32,330행(81 31,521 · 81_UC 468 · 81_HD 158 · 81_ST 117 · 81_HM 62 · 81_HG 4) |
| 1 | 같은 조건 + `NVL(ATTRIBUTE8,'') <> ''` | 0행 |
| 2 | 같은 테이블 `CELL_PER_CAR>0 AND ATTRIBUTE8 IS NOT NULL` | 33,943행 |
| 3 | `SCM_MST_LOCATION` `VALID_YN='Y' AND STORAGE_ID IS NOT NULL` | 670행(40 213 · 81 315 · 81_HD 4 · 81_HG 6 · 81_HM 8 · 81_ST 5 · 81_UC 14 · 82 105) |
| 3 | 같은 조건 + `STORAGE_ID <> ''` | 0행 |
| 6 | `XIF_ERP_DELIVERY_TRACKING_R_SN` 전체 · TRANSFER_FLAG 분포 · TRANSFER_DATE 범위 | 12,374행 · 전부 'Y' · 20250406~20250628 |
| 6 | UPDATE 대상 조건(`<> ''` 제외) 행 수 | 0행 |

- 1·2번: 화면 결과 행 수 차이는 재지 않았다(프로시저 미실행). 위 수는 원본 테이블 기준이다. `PKG_DMF0035` 의 `C` 는 `GT_DM35_SITE_ITEM`(2294줄 INSERT · 2336줄 `FROM SCM_MST_SITE_ITEM`)이다.
- 3번: 해당 SELECT 는 `V_DIVISION_ID = '81'` 조건(1324·1328줄)이 있어 Division 81 조회에만 해당한다. 화면 결과 차이는 재지 않았다.
- 4·5번: 중복 검증에 걸릴 데이터가 있는지는 재지 않았다(저장 프로시저 입력에 따라 달라짐).

## 5. 우선순위 — 운영 호출 객체 기준

| 순위 | 대상 | `SCM_ADM_PROC_M` 등록(18:09) | 실행 기록 `SCM_SYS_LOG_BATCH`(18:10~18:12) | LAST_DDL | 판단 근거 |
|---:|---|---|---|---|---|
| 1 | `PKG_DMF0035` 3226·3229 | 서브프로그램 등록 Y | 14,246행 · 최근 2026-11-13 15:43 | 2026-11-09 18:34 | 등록 + 당일 실행 기록 + 원본 32,330행이 조건에 해당 |
| 2 | `PKG_DMF0045` 1295 | 서브프로그램 등록 Y | GET 기록 0행(SAVE 44행 · 최근 2026-11-10 10:02) | 2026-10-30 17:32 | 등록 + 같은 PKG 저장 기록 + Division 81 원본 315행 |
| 3 | `PKG_DMF0003` 15009 · `PKG_DMF0003_01` 16525 | 서브프로그램 등록 N(PKG 는 18 · 20개 등록) | 해당 서브프로그램 기록 0행 | 2026-11-10 13:10 · 2026-11-12 10:36 | PKG 본문 안 호출 0곳 · `nscm-fe`/`nscm-be` 소스 검색 0건 → 호출 경로 미확인 |
| 4 | `PR_SCM_DNM_DELIVERY_TRACKING` 54 | 등록 N(배치) | 0행(호출자 `PR_SCM_DNM_INTRANSIT` 도 0행) | 2026-11-03 16:12 | `PR_SCM_DNM_INTRANSIT` 2071줄이 호출 · 현재 대상 데이터 0행 · 관련 스케줄러 잡 `JOB_RFC_XIF_ERP_DELIVERY_TRACKING_R` DISABLED |

- 1번 참고: 같은 취지의 `PKG_DMF0022` 3040줄은 `NVL(C.ATTRIBUTE8,''@#@#@#'') <> ''@#@#@#''` 로 되어 있어 대상이 아니다. `PKG_DMF0035` 3221줄 주석은 "기존 가드는 NULL 여부만 본다(AS-IS ISNULL(ATTRIBUTE8,'')<>'' 동형)" 이라고 적고 있으나 실측은 0행이다.
- 4번은 구조상 결함이지만 사내 DB 에 대상 데이터와 실행 기록이 없다. 운영(클라우드) 데이터는 조회하지 않았다.

## 6. (b) 실행 코드 28줄 — 영향 없음

| 객체 · 서브프로그램 | 줄 | 꼴 |
|---|---|---|
| `PKG_SDM1010` · `P_SDM1010_SAVE_TAB1_PJT_REG` | 552 · 553 · 607 · 608 | `( NVL(V, '') != '' OR V IS NOT NULL )` |
| `PKG_SDM2010` · `P_SDM2010_SAVE_PJT_SAMPLE_DEMAND` | 1226~1229 · 1280 · 1365 | 같음 |
| `PKG_SDM2020` · `P_SDM2020_SAVE_PJT_SAMPLE_DEMAND` | 1190~1193 · 1244 · 1329 | 같음 |
| `PKG_SDM5010` · `P_SDM5010_BTN_TAB1_CANCEL` / `_CONFIRM` | 386 · 584 · 632 · 652 | `( P IS NOT NULL OR P != '' )` |
| `PKG_SCM0002` · `P_SCM0002_SET_TITLESET_POPUP` | 4375 · 4462 | `ELSIF V IS NOT NULL OR V != '' THEN` |
| `PKG_DMF0003` · `P_DMF0003_GET_MKT_FCST_DATA` | 6168 | `( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL OR NVL(A.ATTRIBUTE4,'') <> '' OR NVL(A.ATTRIBUTE5,'') <> '')` |
| `PKG_DMF0003_01` · `P_DMF0003_01_GET_MKT_FCST_DATA` | 6693 | 같음 |
| `PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK` · `_ESS_` · `_GM_` · `PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK_BATCH` | 938 · 1352 · 1427 · 1018 | `(T.ETA_DATE IS NOT NULL OR T.ETA_DATE <> '')` |

빈 문자열 비교 항은 항상 UNKNOWN 이고 같은 괄호의 `IS NOT NULL` 이 결과를 정한다(§2-1 실측 2건 1행). 정리할 때 그 항만 지우면 된다.

## 7. 후속으로 남는 것

1. (a) 6줄 + §8 의 (a) 8줄 보완 — 이번 작업 범위 밖(DB 객체 미수정). 보완 시 착수 직전 원문 재조회 필요(hook #152).
2. VIEW 원문 · 변수 경유 빈 문자열 비교 — 미조사.
3. (a) 3~5번 · §8 `DMF0072_GET_ITEM_POPUP_LIST` 호출 경로(BE 직접 호출 여부) 확인 — 미확인.

## 8. 등호 비교 `= ''` — 353줄 / 63개 객체 (2차 조사 2026-11-13 18:20~18:30)

> 원문을 다시 내려받았다: `ALL_SOURCE` 2026-11-13 18:20:16 · 1,235개 객체 1,249,084줄. 18:06 원문과 달라진 객체 = `PKG_DMF0014` · `PKG_DMF0040` 2개(§4 의 (a) 5개 객체는 변동 없음).

### 8-1 결론

| 항목 | 값 |
|---|---:|
| 코드·동적 SQL 자리의 `= ''` | 361건 / 353줄 / 63개 객체 (코드 354건 · 동적 SQL 7건) |
| (a) 결과를 틀리게 함 | **8줄 / 1개 객체** (`DMF0072_GET_ITEM_POPUP_LIST`) |
| (b) 영향 없음 | 311건 / 304줄 |
| (c) 다른 의미 | 2건 / 1줄 |
| (d) 백업·임시 객체 | 40건 / 40줄 |
| 미확인 | 0 |

실측(18:25:01): `'A' = ''` 0행 · `NVL('','') = ''` 0행 · `('' IS NULL OR '' = '')` 1행 · `CASE WHEN NVL('','') = '' THEN 'THEN' ELSE 'ELSE' END` = ELSE.

### 8-2 분류 방법

1. 토큰 분석으로 `=` 옆 빈 리터럴 `''` 추출(`:=` 대입 · `=>` 이름 표기 제외). 주석 안과 `= ''X''` 꼴(따옴표 이스케이프)은 대상이 아니다.
2. 조건 묶음(가장 안쪽 괄호 또는 IF/WHEN/WHERE~THEN 구간)을 OR · AND 로 나눠, 같은 식의 `IS NULL` 이 OR 로 붙어 있으면 (b) 로 자동 분류 → 291건(백업 객체 40건 포함).
3. 나머지 70건(단독 비교 32 · UPDATE SET 대입 38)은 앞뒤 원문을 읽어 분류.
4. **TO-BE 룰 반영**(사용자 지시 2026-11-13): NOT NULL 컬럼에 빈 값을 넣지 못해 `NVL(x, '/')` 로 처리하거나 컬럼에 `DEFAULT '/'` 를 둔 것은 오류가 아니다. 컬럼이 비교·대입 대상인 줄은 `ALL_TAB_COLUMNS`(시노님은 원 테이블)에서 NULLABLE · DATA_DEFAULT 를 조회해 근거에 적었다(18:22~18:25).

### 8-3 (b) 311건 내역

| 꼴 | 건수 | 근거 |
|---|---:|---|
| `X IS NULL OR X = ''` (순서 무관 · `NVL(X,'')` · `TRIM(X)` 포함) | 251 | `= ''` 항은 항상 UNKNOWN, 결과 = `IS NULL` 판정 |
| `UPDATE … SET 컬럼 = ''` | 38 | 비교가 아니라 대입. NULL 저장. 대상 컬럼 6개 테이블 모두 NULLABLE=Y · DEFAULT 없음 → ORA-01407 없음 |
| 앞 분기가 NULL 을 같은 결과로 먼저 받는 죽은 분기 | 22 | 아래 표 |

SET 대상: `INF_MGR.XIF_OWMS_STOCK_R`(LOT_ID · GRADE · SOC · CAPACITY_GRADE) · `SCM_MGR.DM_PLN_MKT_FCST`(ATTRIBUTE2~5) · `GT_XGLB_PSI_GLOBAL_AUTO` · `GT_XPGT_PSI_GLOBAL_AUTO`(ATTRIBUTE1 · 9) · `INF_MGR.XIF_ERP_SALES_RESULT_R`(PROJECT_CODE) · `OPT_MGR.SCP_OPT_ENG_INCOMING_STOCK`(ATTRIBUTE5).

| 객체 | 줄 | 영향 없는 이유 |
|---|---|---|
| `PKG_SCM0002` · `PKG_SCP0031` · `PR_SCP_XLS_PSI_GLOBAL_ESS_S` | 569 · 582 / 1542 / 302 · 2291 | 앞 WHEN `NICK_NAME IS NULL THEN '-'` 가 같은 결과 |
| `PR_SSP_ANL_SHIP_CONFIRM_BATCH_40` | 1066 | 앞 WHEN `B.ATTRIBUTE2 IS NULL THEN NULL` 이 같은 결과 |
| `FN_SCM_GET_WHERE_SQL` · `FN_SCM_GET_WHERE_SQL2` | 109 · 125 · 180 / 87 · 95 · 141 | 앞 분기 `NVL(…, 'ALL') = 'ALL'` 이 NULL 을 먼저 받음 |
| `PKG_DMF0003` · `PKG_DMF0003_01` | 6174 / 6699 | 앞줄 `P_PROJECT_CODE IS NULL OR` |
| `PKG_DMF0074` | 149 · 158 · 257 · 266 | ELSE 쪽 `A.PROJECT_CODE / A.ITEM_ID LIKE '%%'` 가 전 행 참. `DM_BPS_METAL_LINK_PRICE` 의 두 컬럼은 **NOT NULL DEFAULT '/'**(TO-BE 룰) · NULL 0행(36,855행) |
| `DMF0043_GET_CONTRIBUTION_SALES_LIST` · `PKG_DMF0043` | 549 / 3250 | 합계 식 첫 항 앞에 ` +` 가 붙지만 단항 + (실측 값 같음) |
| `FN_GET_SCP_CELL_TYPE_SORT` | 25 | 호출처 `PKG_SCP0031` 1536줄이 NULL 을 먼저 400000 으로 처리 |
| `FN_GET_VOC_SOON_YN` | 35 | NULL 이어도 44줄 `!= 'RN'` 이 UNKNOWN 이라 'RN' 과 같은 경로 |

- '/' 센티널 컬럼이 `= ''` 비교 대상인 곳: `PKG_DMF0006` 94줄 `TEAM.DEPT_ID`(`SCM_MST_SSO_DEPT_INFO.DEPT_ID` NOT NULL DEFAULT '/') 1곳. `IS NULL` 과 OR 로 묶여 있고 '/' 값은 0행(21,470행)이라 (b).
- 1차 (a) 의 대상 컬럼도 확인했다: `SCM_MST_LOCATION.STORAGE_ID` · `SCM_MST_SITE_ITEM.ATTRIBUTE8` 은 NULLABLE=Y · DEFAULT 없음 · '/' 값 0행 → 권장 대체 `IS NOT NULL` 유지.

### 8-4 (a) — `DMF0072_GET_ITEM_POPUP_LIST` 8줄 (102 · 103 · 104 · 151 · 152 · 198 · 199 · 200)

```sql
AND CASE WHEN P_DIVISION_ID = '81_UC'
         THEN CASE WHEN NVL(P_MDM_ACTIVE_SW, '') = '' THEN '' ELSE NVL(T.ACTIVE_FLAG, EX.ACTIVE_FLAG) END
         ELSE CASE WHEN NVL(P_MDM_ACTIVE_SW, '') = '' THEN '' ELSE T.ACTIVE_FLAG END
    END = CASE WHEN NVL(P_MDM_ACTIVE_SW, '') = '' THEN '' ELSE 'Y' END
```

- 일어나는 일: WHEN 이 항상 UNKNOWN → 양쪽이 ELSE → `P_MDM_ACTIVE_SW` 를 비워도 `ACTIVE_FLAG = 'Y'` 조건이 걸린다(UNION 3개 가지 모두).
- AS-IS: 같은 이름의 SP 는 `LGCE_SCMDEV` 에 없다. 같은 구문은 `DMF0002_GET_ITEM_BY_DIVISION_POPUPEx` 162~165 · 248줄 `ISNULL(@p_mdmActive_Sw, '') = ''` 에 있고, MSSQL 은 빈 값이면 양쪽이 `''` 가 되어 조건이 없어진다.
- 권장 대체: `PKG_DMF0002` 218~220줄 방식 — `CASE WHEN P_MDM_ACTIVE_SW IS NULL THEN '@#@#@#' ELSE … END = CASE WHEN P_MDM_ACTIVE_SW IS NULL THEN '@#@#@#' ELSE 'Y' END`.
- 운영 호출: `SCM_ADM_PROC_M` 등록 0행 · `ALL_DEPENDENCIES` 참조 0 · `SCM_SYS_LOG_BATCH` 0행 · 원문 안 호출 0곳 · `nscm-be`(java·xml) / `nscm-fe/features`(ts·tsx) 검색 0건 → **호출 경로 미확인**. LAST_DDL 2026-11-02 19:12. 데이터 영향은 재지 않았다.

### 8-5 (c) · (d)

- (c) `PR_SSP_ANL_SHIP_PLAN_ALL` 872줄 2건: `'' || V_P_LANGUAGE || '' = 'KO'` — 비교 대상은 'KO'.
- (d) 40건: `PKG_ZTMP_S015J` 35 · `PKG_DMF0082_1104` · `_1104A` · `_1104B` · `_1104C` · `_BAK1109` 각 1. `SCM_ADM_PROC_M` 등록 0행(18:30). 40건 모두 자동 판정은 `IS NULL` 과 OR 꼴이다.

## 9. (a) 14줄 보완 — 사내 적용 (2026-11-13 18:39~18:43 · 사용자 지시)

| 객체 | 줄 | 수정 후 | 최종 LAST_DDL | 상태 |
|---|---|---|---|---|
| `PKG_DMF0035` | 3226 · 3229 | `AND C.ATTRIBUTE8 IS NOT NULL` | 2026-11-13 18:41:53 | VALID |
| `PKG_DMF0045` | 1295 | 줄 주석 처리 | 2026-11-13 18:42:28 | VALID |
| `PKG_DMF0003` | 15009 | `IF S_FUTURE_VALID IS NOT NULL THEN` | 2026-11-13 18:41:54 | VALID |
| `PKG_DMF0003_01` | 16525 | 같음 | 2026-11-13 18:41:56 | VALID |
| `PR_SCM_DNM_DELIVERY_TRACKING` | 54 | `… ) IS NOT NULL` | 2026-11-13 18:41:57 | VALID |
| `DMF0072_GET_ITEM_POPUP_LIST` | 102 · 103 · 104 · 151 · 152 · 198 · 199 · 200 | `CASE WHEN P_MDM_ACTIVE_SW IS NULL THEN '@#@#@#'` | 2026-11-13 18:41:57 | VALID |

- 확인(18:42:29): 6개 객체 VALID · `ALL_ERRORS` 0 · 적용본 == DB 원문 · 의존 INVALID 0 · 표시 주석(`E20261113-EMPTYCMP`) 14줄.
- 동작 확인된 것: `DMF0072_GET_ITEM_POPUP_LIST` — `P_MDM_ACTIVE_SW` 를 비우면 행 수가 늘어남(81: 41,423 → 49,518 · 81_UC: 363 → 845 · 82: 44,223 → 44,572 · 40: 15,375 → 15,417), 'Y' 는 전후 같음.
- 회귀 없음만 확인된 것: `PKG_DMF0035`(655행 전 컬럼 같음 · KWH 컬럼이 결과 커서에 없어 화면 값 변화는 미확인 · 식 단위로는 0 → 32,330 / 33,943) · `PKG_DMF0045`(10 / 81행 전 컬럼 같음 · 사내 재고 최근 CUTOFF 2026-09-18 이라 효과 미확인).
- 실행하지 않은 것(동작 미검증): `PKG_DMF0003` · `PKG_DMF0003_01` 저장 프로시저, `PR_SCM_DNM_DELIVERY_TRACKING` 배치.
- 기록: `_artifacts/_apply_corporate/EMPTYCMP_20261113/APPLIED_OPERATIONS.md` · 수정 전 원문 `backup/` · 적용본 `tobe/` · 로그 `logs/`.
- 클라우드 이관 패키지: `_artifacts/_deploy_packages/EMPTYCMP_CLOUD_20261113/`(10_APPLY_PATCH → 90_VERIFY · 되돌리기 99_ROLLBACK_PATCH). 사내 리허설(되돌리기 → 원문 대조 6개 일치 → 재적용 → 재실행 SKIP) 통과.

## 10. (b) 실행 코드 28줄 정리 — 사내 적용 (2026-11-13 19:08~19:10, 사용자 지시)

§6 의 28줄에서 `<> ''`, `!= ''` 항만 지웠다. 11개 객체, 줄 수 변화 없음.

| 객체 | 줄 수 | 수정 후 상태 | 최종 LAST_DDL |
|---|---:|---|---|
| `PKG_SDM1010` | 4 | VALID | 2026-11-13 19:08:50 |
| `PKG_SDM2010` | 6 | INVALID(수정 전부터, 오류 4건 같음) | 2026-11-13 19:08:51 |
| `PKG_SDM2020` | 6 | INVALID(수정 전부터, 오류 4건 같음) | 2026-11-13 19:08:52 |
| `PKG_SDM5010` | 4 | VALID | 2026-11-13 19:08:52 |
| `PKG_SCM0002` | 2 | VALID | 2026-11-13 19:08:53 |
| `PKG_DMF0003` | 1 | VALID | 2026-11-13 19:08:56 |
| `PKG_DMF0003_01` | 1 | VALID | 2026-11-13 19:09:01 |
| `PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK` | 1 | VALID(수정 전 INVALID, 오류 0건) | 2026-11-13 19:09:05 |
| `PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK` | 1 | VALID | 2026-11-13 19:09:05 |
| `PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK` | 1 | VALID | 2026-11-13 19:09:06 |
| `PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK_BATCH` | 1 | VALID(수정 전 INVALID, 오류 0건) | 2026-11-13 19:09:07 |

- 전후 시험: `PKG_DMF0003`, `PKG_DMF0003_01` 조회 6건(Division 81, 82, 40)의 결과 커서 3개가 전후 같음. `DM_PLN_MKT_FCST` 에 수정 전 술어와 수정 후 술어를 적용한 행 수 12,850 으로 같음.
- 실행하지 않은 것: 저장 프로시저(`PKG_SDM1010`, `PKG_SDM5010`, `PKG_SCM0002`)와 배치 4개. 술어 등가와 컴파일로만 확인.
- `PKG_SDM2010`, `PKG_SDM2020` 은 `ORA-00904 "BIZ_TYPE"` 로 수정 전부터 컴파일되지 않는다. 이번 변경과 무관하고 조치하지 않았다.
- 기록: `_artifacts/_apply_corporate/EMPTYCMP_B_20261113/APPLIED_OPERATIONS.md`. 클라우드 이관 패키지: `_artifacts/_deploy_packages/EMPTYCMP_B_CLOUD_20261113/`.
