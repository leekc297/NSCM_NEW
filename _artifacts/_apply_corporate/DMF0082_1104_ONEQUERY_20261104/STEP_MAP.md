# STEP_MAP — PKG_DMF0082_1104.P_DMF0082_GET_MAIN_DATA 원 STEP ↔ 새 구조 대조표 (2-A Current 경로 · §4 2-B 버전 경로)

마커 `[E20261104-DMF0082ONEQUERY]` · 줄 번호 = 원문 GET_MAIN_DATA 내부 줄(BODY 8행부터 1로 센 main.sql 기준) · 생성 = `build.py` (`oneq_blocks.py` S0/S1/S2 · `oneq_s3.py` S3)

## 0. 경로 선택
- `V_ONEQ_CURRENT := (버전 LIKE '%Current%' OR '%current%') AND NOT LIKE '%SP%' AND NOT LIKE '%MF%' AND NOT LIKE '%SF%'`
  (원문 L1446·2368·2945·3524 IF 게이트와 같은 판정식). 2-A: TRUE = 새 3문장, 그 외 = 원문 L493~5337 그대로. **2-B: TRUE = S2-CUR(사업부별) / FALSE = S2-ALL(사업부별, §4)** — S0·S1·S3 공용.

## 1. 원 STEP → 새 위치 (Current 경로)

| 원문 줄 | 원 STEP (문장 수) | 새 위치 | 비고 |
|---|---|---|---|
| L1~233 | 선언부 | 그대로 + `V_ONEQ_CURRENT` 1개 추가 | |
| L241 | `ALTER SESSION TEMP_UNDO` | 그대로 | |
| L257~297 | PARAM_TOKEN DELETE 1 + INSERT 10 | **S0** DELETE 1 + INSERT 1 (UNION ALL 10) | 토큰 값·함수 호출 횟수 동일 |
| L301~436 | dynamic_sampling · 시작 로그 · 날짜 검증 · TITLESET 시드 INSERT 2 | 그대로 | 영구 테이블 DML 보존 |
| L459~480 | V_EXP · C_BUCKET 루프(PV CLOB 3) | 그대로 | |
| L493~534 | T_VERSION DELETE/INSERT · V_CUTOFF | Current 경로 = 적재 없음 → `V_CUTOFF := '00000000'/'99999999'` (원문 L530 NVL 과 동일값) | T_VERSION 소비처는 버전 arm 뿐 |
| L549~554 | T_WS_FCST DELETE/INSERT | **S2** CTE `WS` | |
| L562~605 | 날짜 스칼라 3 + IF | 그대로(복사) | |
| L611~659 | ORI_V DELETE/INSERT | **S1** CTE `ORI` | |
| L668~703 | A_V | S1 CTE `AV` | |
| L712~732 | B_V | S1 CTE `BV` | |
| L741~838 | MST_ITEM_SINGLE_V | S1 CTE `V0` (ENERGE `CAST(… AS NUMBER(20,4))` = GTT 열 타입 재현) | |
| L842~850 | p_item_id 필터 DELETE | S1 CTE `V` = `p_item_id IS NULL OR EXISTS(토큰 LIKE)` | **이상③ 재현**: T2·T4 둘 다 `V`(필터본) 사용 |
| L861~998 | SITE_ITEM_ALL | S1 CTE `ALLX` (MIN_CAPACITY·CELL_QUANTITY·MODULE_PER_CAR `CAST NUMBER(20,10)` · SORT_ORDER_NO/PROJECT_S_OP_REPORT NULL 타입 명시) | 조인 K(미사용) 포함 원문 그대로 |
| L1002~1048 | site/customer/biz/item 필터 DELETE 4 | S1 CTE `ALLF` WHERE (NOT 게이트 OR EXISTS) | NOT EXISTS 삭제 → 생존 EXISTS, 의미 동일 |
| L1057~1114 | TEMP_SITE_ITEM 6키 GROUP BY | **S1 INSERT** 본문 | |
| L1126~1151 | project/owner/team 선행축소 DELETE(NOT IN) | **원문 그대로 1 DELETE 유지** | NOT IN 의 NULL 튜플·빈 집합 의미를 WHERE 로 옮기면 비등가 위험 → 보존 (조건 미지정 시 미실행) |
| L1168~1246 | TEMP_SELECT_MEASURE INSERT 3 | S2 CTE `MEA1`→`MEA2`(NOT EXISTS MEA1)→`MEA3`(NOT EXISTS MEA1∪MEA2)→`MEA` | SORT_ORDER_NO `CAST NUMBER(10,2)` = GTT 열 타입 |
| L1254~1273 | T_LAST_DATA_SETUP_FCST (81/82) | S2 CTE `LD` 81 분기 | 8키 1행 — 소비처 KEEP 래퍼는 항등 |
| L1559 INSERT ALL 의 LD 분기 (40) | X_LD_EMIT 행 | S2 CTE `LD` 40 분기 (A⋈C 전체 · p_from~p_to · GROUP BY 8키 MAX/MAX) | 윈도 MAX 와 동일값 |
| L1294~1335 | T_LAST_DATA_SETUP_PRICE | 없음 | 원문도 적재 없음(죽은 GTT) |
| L1344~1432 | FCST_C / PRICE_C | 없음 | Current 경로 = T_VERSION 0행 → 원문도 0행 |
| L1441 | TEMP_FCST_N_PRICE DELETE | S2 앞 DELETE 그대로 | |
| L1449 IF 분기 | 사업부별 arm 선택(81% / 82 / 40) | **apply #5**: S2 INSERT 를 `S2-81`(A1·A3·A5·A6·A8·A9) / `S2-82`(A1·A3·A6·A8·A9) / `S2-40`(A2·A4·A7·A8·A9) (apply #12 부터 A3·A4 는 A1·A2 에 병합) 정적 3본으로 두고 PL/SQL `IF p_division_id LIKE '81%' / ELSIF = '82' / ELSE` 로 1개만 실행 | 바인드 술어 arm 은 FILTER 로 실행되지 않는 게 아니라 원장 스캔이 일어났다(82 호출에서 40 arm 의 PK_DM_PLN_CFM_MKT_DEMAND_PLAN ASH 172 샘플) |
| L1450~1551 | A1 수요 81/82 | S2 `BASE` arm A1 | |
| L1559~1687 | A2 수요 40 INSERT ALL 출력 분기 | S2 `BASE` arm A2 (LD = CTE `LD`) | B/D LEFT JOIN + HIT 조건 = INNER JOIN |
| L1693~1748 / L1750~1805 | A3/A4 MKT_FCST_PP | **apply #12 (23:29)**: A1/A2 에 병합 — 같은 원장·같은 WHERE 를 1회 읽고 측정값 매핑 `M(AM→BM, PP)`(= MEA DISTINCT MEASURE 자기매핑 ∪ 'MKT_FCST'→'MKT_FCST_PP' 1행) 등가조인 · MEASURE 출력 `CASE WHEN M.PP='Y' THEN 'MKT_FCST_PP' ELSE (A1/A2 식) END` | 구 형태 `A.MEASURE='MKT_FCST' AND B.MEASURE='MKT_FCST_PP'`(키 없는 교차조인)는 옵티마이저가 MEA 1행 추정 → GTT 카티션 → 원장 PK 행별 NL(원본 L1750 `1kr5k368wpvrj` 109회 1,709s · 1104 minyonglee1/40 59.5s, 23:11 실측) — 행 다중도 등가: #1 = A×B(B.MEASURE=A.MEASURE) = A×M(N,DISTINCT)×B(M.BM) · #3 = A(MKT_FCST)×B(PP) = A×M(Y,1)×B(PP) · LU/LD/NOTATION 은 두 arm 동일 |
| L1816~1866 | A5 81 금액 | S2 arm A5 (`p_division_id LIKE '81%'`) | |
| L1871~2052 / L2054~2156 | A6/A7 판가 1회 읽기 | S2 arm A6/A7 (윈도 형태 그대로 · 힌트 L2071 제거) | D: 81 JOIN / 40 EXISTS 원문 유지 |
| L2160~2264 | A8 실적 | S2 arm A8 | |
| L2273~2361 | A9 CUST 종속 실적 | S2 arm A9 (힌트 L2285 제거) | |
| L3707~3730 | CURRENCY MERGE 1차(9키 MAX) | S2 CTE `LOC9` + `CUR` COALESCE 1순위 | |
| L3747~3786 | 2차(8키 NVL · 단일) | CTE `LOC8` + COALESCE 2순위 | 1차 채움이 2·3차 원천을 바꾸지 않음(채운 값 = 상위 그룹에 이미 존재) |
| L3801~3829 | 3차(5키 NVL · 단일) | CTE `LOC5` + COALESCE 3순위 | |
| L3841~3927 | 파생 LOC/KRW · FCST_GAP | S2 CTE `DRV1` (입력 = `CUR`) | Current 게이트 항상 참 |
| L3939~4115 | SP 파생·삭제 | 없음 | Current 경로 비실행 (2-B) |
| L4129~4134 | DM_ADMIN 메저 삭제 | S2 CTE `FLT` NOT EXISTS | |
| L4149~4204 | 조회조건 필터 DELETE 6 | CTE `FLT` (삭제조건 ≠ TRUE 를 생존 조건으로 전개 — NOT IN 빈 집합·NULL 토큰·NULL 열 의미 포함) | **이상④ 재현**: SENDER_CODE 전 arm NULL → 지정 시 0행 |
| L4220~4232 | 중복 제거(59열 ROW_NUMBER QTY DESC) | **apply #5**: 원문 COUNT 검사 + DELETE 그대로(INSERT 뒤) | CTE `DEDUP` 윈도판은 넓은 행 전량 TEMP 재기록(82 실측 46s)이라 환원 |
| L4246~4282 | p_qty_yn 9키 합 필터 | **apply #5**: 원문 DELETE 그대로 | |
| L4291~4307 | CUST 종속 고아 삭제 | **apply #5**: 원문 DELETE 그대로 | |
| L4312~4418 | C_TITLE 루프 · 키/필수 열 추가 · V_ORDERBY · V_GROUP_ID | 그대로 | |
| L4431~4462 | GTT_TEMP_INTO_GROUP_MEASURE INSERT | **S3** CTE `INTOG` | |
| L4468~4500 | TEMP_ADMIN_GROUP_MEASURE INSERT | S3 CTE `ADM0` | |
| L4521~4548 | UPDATE LOC → 'Y' | S3 `ADM` 내부 `E1` | 순서 보존 E1→E2→E3→E4→E5 |
| L4550~4556 | UPDATE AS_In_Req | `E2` | |
| L4558~4572 | UPDATE VMI_In_Req | `E3` | |
| L4590~4616 | UPDATE LIMIT_MEASURE → 'N' | `E4` | |
| L4626~4647 | UPDATE 81AUTH → 'N' | `ADM.EDIT_AUTH_YN` (E5) | |
| L4649 | INTO GTT DELETE | 없음(CTE) | |
| L4657~4675 | CAL_MONTH_END_DATE / CAL_WEEK_END_DATE INSERT | **제거** | **이상②**: L4771 비교식 좌우 역순 → 항상 불일치, 월 달력은 읽는 곳 없음 → 결과 무영향 (매트릭스 PASS 로 실증) |
| L4686~4828 | MF_SP INSERT (11키×일 · 60 MAX) | S3 CTE `MSP` — **G1: V_COLUMN/V_GROUPBY/V_ORDERBY 에 참조된 속성 열만 MAX** (k0101 40 실측: 60→3) · **항등 판정(apply #6)**: 실행 시 `TEMP_FCST_N_PRICE` 11키×YYYYMMDD 중복 0 AND 달력 일자당 1행 → GROUP BY/MAX/SUM 생략(그룹=행) · 아니면 집계 | GROUP BY 축 동일(11키+버킷+MEASURE_GROUP+SORT_ORDER_NO+SUN~SAT+달력4) · WE 조인 제거 · 수치 6열 CAST NUMBER(20,10) 양쪽 경로 동일 |
| L4760~4764 | AS_YN | PL/SQL 1회 판정 → 리터럴 | 비상관 |
| L4848~4952 | ATTR1 MERGE (40/82) | S3 CTE `ATTR1S` + `M2` LEFT JOIN — ATTR1 참조 시에만 | |
| L4972~4974 | AS_FROM_SITE NULL→' ' | MSP `NVL(MAX,' ')` (원문도 INSERT 시 NVL) | no-op |
| L4981~4983 | CELL_PROD '/'·공백 → '-' | `M1` | |
| L4992~5017 | AS_FROM_SITE 복사 MERGE | `M3R`(10키 NVL '/' GROUP BY · MKT_FCST 비공백만 · HAVING COUNT(DISTINCT)=1) + `M3`(LEFT JOIN) — AS_FROM_SITE 표시 시에만 · **apply #7** 윈도 → 집계+조인 | 원문 USING/ON 동형 |
| L5025~5036 | CURRENCY ' ' | `M4` | |
| L5076~5146 | 숨김 CELL_PROD 대표값 | `M5R`(10키 NVL '~' GROUP BY · WHERE CP IS NOT NULL · HAVING COUNT(DISTINCT)>1 · KEEP LAST) + `M5`(LEFT JOIN 적용) — 원문 MERGE USING/ON 동형 · 숨김 판정 PL/SQL 그대로 | apply #6 에서 WINDOW SORT 판 → 집계+조인 판 |
| L5161~5226 | 숨김 PLANT 대표값 | `M6R`/`M6` (M5 와 같은 형태 · HAVING COUNT(DISTINCT NVL)>=1) | 키에 M5 이후 CELL_PROD |
| L5235~5262 | LAST_UPD 동적 MERGE | `LUW`(피벗 대상 행만 · `RID_`+행 키+2열 좁은 투영 위 원문 윈도 MAX(CREATE_DATE) · MAX(LAST_UPDATED_BY) KEEP LAST) + `SRC0`(`RID_` 단일 키 LEFT JOIN · QF 행만 치환) — 두 열 표시 시에만 · **apply #8** (원문 MERGE ON ROWID 동형) | `RID_` = MSP 의 F.ROWID(집계 경로 MIN(F.ROWID)) · PARTITION BY = V_LU_KEYS 원시 열(원문 산출식 그대로) · apply #7 의 2식 조인은 450s 로 폐기 |
| L5273~5332 | O_RC1 5 arm PIVOT | **G2** `DISP`(표시키×일 SUM, COUNT · QTY 필터 집계 전) → 5 arm (AVG = SUM/COUNT) → PIVOT → ORDER BY | 식·열 목록 원문과 동일 |
| L5343~5366 | O_RC2·O_RC3 | 그대로 | |
| L5372~5375 | O_RC4 (GTT 읽기) | S3 `WITH INTOG/ADM0/ADM SELECT … ORDER BY MEASURE` 동적 SELECT | |
| L5382~5396 | O_RC5 | 그대로 | |
| L5503~5535 | 결과·로그·예외 | 그대로 | |

## 2. 이상 동작 5건 — 재현 위치
| # | 내용 | 새 코드 위치 |
|---|---|---|
| ① | MF×40 판가 EC=PROJECT_CODE | 2-B 대상 (Current 경로 무관) |
| ② | 주 달력 비교식 역순 | 달력 GTT 제거 = 원문과 같은 결과(실증: 매트릭스) |
| ③ | Item 검색어가 CELL_MODEL 닉네임 조회 제한 | S1 `V` 를 T2·T4 공용 |
| ④ | Sender 지정 시 전 행 삭제 | S2 arm 전부 SENDER_CODE NULL + `FLT` EXISTS 조건 → 0행 |
| ⑤ | PRICE_C 버전 미구분 | 2-B 대상 |

## 3. 문장 수 (Current 경로 · DML/커서 OPEN 기준)
S0 DELETE+INSERT 2 · S1 INSERT 1 (+조건부 선행축소 DELETE 1) · **S2-L 룩업 GTT 적재 3 (WS · SELECT_MEASURE · LAST_DATA_SETUP_FCST, 각 DELETE+INSERT)** · S2 DELETE+INSERT 2 · S3 OPEN 1 (+O_RC4 OPEN 1) — 데이터 적재 핵심 3문장(S1·S2·S3) + 소형 룩업 3.
잔존 GTT: PARAM_TOKEN · TEMP_SITE_ITEM · T_WS_FCST · TEMP_SELECT_MEASURE · T_LAST_DATA_SETUP_FCST · TEMP_FCST_N_PRICE (2-B 에서 T_VERSION · FCST_C · PRICE_C 추가).

### 3-1. 룩업을 CTE 로 두지 않는 이유 (17:3x 실측)
WS/MEA/LD 를 CTE 로 두면 Oracle 이 SYS_TEMP 로 물질화하고 통계가 없어 MEA 를 3,118행(TITLESET_USER NUM_ROWS 19,112 기준 추정)으로 보았다. 그 결과 PP arm 의 상수 조인(`A.MEASURE='MKT_FCST' AND B.MEASURE='MKT_FCST_PP'`)이 MERGE JOIN CARTESIAN(추정 4,800만행) → 원장 PK 인덱스 행별 NESTED LOOPS 로 풀려 S2 가 32분+ (SQL_ID 38w5z8smdhxva, 계획 1173473358, ASH 핫 라인 174/93). 원문은 같은 룩업을 10-09 에 SHARED 고정 통계를 심은 GTT 로 읽어 HASH 로 고정됐다. 룩업 GTT 적재로 환원한 뒤 같은 케이스 0.94s.

## 4. 진단 훅
S3 는 세션 `CLIENT_INFO='ONEQ_DEBUG'` 일 때만 생성 SQL 을 DBMS_OUTPUT 으로 내보낸다 (`_dumpsql.py`). 운영 경로 무영향.

## 4. 2-B 버전(MF/SF/SP·복수) 경로 — 원 STEP → 새 위치 (`oneq_2b.py` · `ONEQ_STAGE=2B build.py`)

| 원문 줄 | 원 STEP | 새 위치 | 비고 |
|---|---|---|---|
| L493~541 | T_VERSION DELETE/INSERT(IF SP/MF/SF) · V_CUTOFF SELECT INTO | **원문 그대로**(룩업 GTT 적재 — S1 앞) | VER 는 CTE 로 두지 않음(무통계 룩업 CTE 사고 재발 방지) · 순수 Current 는 적재 0행·V_CUTOFF 기본값 = 2-A 와 동일 |
| L1344~1388 | T_LAST_DATA_SETUP_FCST_C 적재(81/40 · CUT 프루닝) | S2-L 룩업 GTT 적재 `LDC`(UNION ALL 81/40 arm) — **11-05 VERLOOP**: VER GTT INNER JOIN 대신 `FOR VL IN (SELECT DISTINCT VERSION_NO FROM T_VERSION …) LOOP … AND A.VERSION_NO = VL.VERSION_NO` | 원문 T_VERSION 조인 = 카티션 1행 추정→NL 457s(원본 L1355/L1376 동일 계획) · 버전별 적재 합집합 = 원문(GROUP BY 에 VERSION_NO) · T_VERSION 비면 0회 |
| L2448 등 소비처 | FCST_C 8키 재집계(버전 간 합침 · KEEP LAST) | CTE `LDC8`(GTT LDC 위 GROUP BY) | 소형 |
| L1392~1431 | T_LAST_DATA_SETUP_PRICE_C 적재(8키 · 버전 미구분) | S2-L 룩업 GTT 적재 `LPC` — **11-05 VERLOOP** 동일 적용 + 버전 2개 이상(`V_VERLOOP_CNT > 1`)이면 8키 재집계(MERGE ON ROWID: MIN(ROWID) 행 ← MAX(CREATE_DATE)·MAX(LAST_UPDATED_BY) → 나머지 DELETE) | **이상⑤ 재현** 유지: 원문 = 버전 간 MAX 1행 · 루프본 = 버전별 MAX 후 재집계(MAX 결합법칙) = 동일 |
| L1453~2361 | Current arm(IF Current) | S2-ALL 의 Current arm — 각 arm WHERE 에 `G_CUR`(`NVL(p_version_type,'~') LIKE '%Current%' OR '%current%'`) | 순수 Current 요청은 S2-CUR(게이트 없음) 실행 |
| L2375~2940 | MF arm(IF MF) — 수요 81/82·40 · PP 81/82·40 · 금액 81 · 판가 81/82·40 · 실적 | S2-ALL arm `MF1·MF2·MF3·MF4·MF5·MFP1·MFP2·MFR` 중 사업부 해당분(81: 1·3·5·P1·R / 82: 1·3·P1·R / 40: 2·4·P2·R · **apply #12 부터 3/4 는 1/2 에 병합** — WHERE 차이(1/2 의 `A.YYYYMMDD >= F.NOW_YYYYMMDD` 는 수요 분만)는 `(M.PP='Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)` 로 보존) · `INNER JOIN T_VERSION F ON F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'` | **이상① 재현**: MFP2 EC=A.PROJECT_CODE |
| L2952~3518 | SF arm(IF SF) | `SF1..SF5·SFP1·SFP2·SFR` 동일 구조 · `LIKE 'SF%'` | SFP2 EC=A.END_CUSTOMER |
| L3531~3697 | SP arm(IF SP) — 판가 81/82·40 · 실적 | `SPP1·SPP2·SPR` · `LIKE 'SP%'` (실적·금액은 `F.SP_VERSION_NO` 매칭) | |
| L3846~3927 | DRV1 게이트(Current/MF/SF) | CTE `DRV1` WHERE 에 게이트 식 추가 | |
| L3939~4111 | SP 전용 LOC/KRW 파생(RTF ⟕ MKT_AMT_LOC(버전 포함) ⟕ MKT_AMT_KRW(버전 미포함)) | CTE `DRV2`(입력 `CUR`) → `UNI` 에 UNION ALL | 원문 조인 키·버전 유무 그대로 |
| L4114 | SP 포함 시 RTF_SYS_RP·MKT_AMT_* **전 버전** 행 삭제 | CTE `FLT` 생존 조건 `(버전 NOT LIKE '%SP%' OR MEASURE IS NULL OR MEASURE NOT IN (...))` | 3값 논리 보존 |
| L4210~4307 | 중복제거 · qty_yn · 고아 DELETE | 원문 그대로(S2 뒤) | 2-A 와 동일 |

적용 조건: Current 회귀 매트릭스 FAIL 0 확인 후 `ONEQ_STAGE=2B python build.py apply` → compare `--scen ver,multi`(MF_W/SF_W/SP_W/MF_D 단일 · Current,MF_W · Current,SP_W) × 2 사용자 × 40/81/82 → Current 회귀 재실행.
