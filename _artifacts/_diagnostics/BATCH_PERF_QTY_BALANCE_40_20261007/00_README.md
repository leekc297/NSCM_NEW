# 배치 속도 진단 — PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE('40', NULL) — 전주 월~목 로그

> 대상 호출 (클라우드 스케줄러 잡 `JOB_SCMPROD_PLAN_FINAL_40_CREATION` 의 PL/SQL 블록 — 구 `PR_SCP_ENG_CONTROL('1','FN')` 대체):
> `SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(P_DIVISION_ID => '40', P_PLAN_ID => NULL, O_RESULT_CURSOR => v_cur); COMMIT;`
> 조회 전용 · DB 변경 없음 · 클라우드 SCM_MGR(또는 `SCM_SYS_LOG_BATCH` 조회 권한 계정)에서 실행. Q7 은 AWR/V$ 권한 필요.

| 파일 | 내용 |
|---|---|
| [01_qty_balance_40_log_diag.sql](01_qty_balance_40_log_diag.sql) | 진단 쿼리 Q0~Q7 (전주 월~목 자동 계산) |
| `_run_diag.py` | 사내 ZIOUI1 사전 검증 실행기 (`python _run_diag.py [from] [to] [division] [plan_id]`) |
| [02_compact_output.sql](02_compact_output.sql) | **01 의 핵심(Q1/Q2/Q3/Q5/Q6/Q7-b/Q8)을 행당 한 줄 문자열로 압축** — SQL*Plus 붙여넣기 50,000자 제한 회피용. 내용·필터 동일. C2 는 간격 5초 이상 행만. 2차 추가: **C1W**(이번 주 실행) · **C7-run**(잡 실행 구간 안의 ASH, 잡 세션 ACTION 또는 PL/SQL 귀속) · C7-run-txt · C7-plan(DISPLAY_AWR). 3차 추가: **C3W / C2W**(이번 주 구간 집계·타임라인 — 신판 비교용). 사내 19문장 전부 검증(2026-10-07) |
| `_run_compact.py` | 02 검증 실행기 (인자 동일) |
| [03_sales_plan_weekly_rolling_40_diag.sql](03_sales_plan_weekly_rolling_40_diag.sql) | **잡 `JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40` 이력·소요 진단** (2026-10-08 추가, 사용자 요청). S1 잡 정의 · S2 스케줄러 실행 이력(전체 소요) · S3 step 2 SP(`PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE` 40) 실행 목록 · **S4 세션(하위 SP KRW/VERSION_CREATE/FUTURE_PRICE/EXCHANGE_RATE/MAIL_SEND)별 타임라인** · S5 구간 집계 · S6 잡 세션 ASH(로그 없는 본체 L228~1950 의 문장 특정). 사내 81(09-23) 실행으로 9문장 검증 |
| `_run_sp40.py` | 03 검증 실행기 (`python _run_sp40.py [division]`) |

## 1. 로그 구조 (2026-10-07 사내 SP 원문 L1~L3181 전수 확인)

| 항목 | 값 | 근거 |
|---|---|---|
| 로그 테이블 | `SCM_MGR.SCM_SYS_LOG_BATCH` (인덱스 없음 → 기간 넓히면 풀스캔 느려짐) | ALL_IND_COLUMNS 0건 |
| 루트 SP 적재 | `PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, …, USER, V_PROC_INPUT, …)` — autonomous transaction | SP L1250/L1357/… |
| `PROGRAM_NAME` | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` | `$$PLSQL_UNIT` |
| **`IN_PARA_DATA`** | `{"p_division_id":"40","p_plan_id":"NULL"}` — 한 실행의 START/ING/END/ERROR/INVALID 모든 행에 동일 → **실행 식별 키** | L1216 `JSON_OBJECT(... NVL(P_PLAN_ID,'NULL'))` |
| `DESCRIPTION` | START/END/INVALID `p_division_id : 40 / p_plan_id : NULL` · ING `''` · **ERROR = backtrace(에러 줄 번호)** | L1248 / L1355 / L3174 |
| `LOG_MESSAGE` | ING `step - A0nn ` · START `########## Start of procedure ##########11` · ERROR = SQLERRM | L1354 등 |
| `CREATED_BY` | 루트 = 세션 계정(`USER`) · **하위 SP(`PR_SCM_SYS_LOG_BATCH`) = `'scm_batch'` 고정** → 루트와 계정으로 묶지 못함, 시간 구간 + `@p_division_id : 40` 문구로 묶음 | PR_SCM_SYS_LOG_BATCH L40 |
| 하위 SP 로그 | `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW` (`@p_division_id : 40 / @v_created_by : SYSTEM`) · `PR_DM_DNM_CREATE_WS_RTF` (`@P_DIVISION_ID: 40`) | 각 SP L90 / L104 |

### 이 호출이 남기는 step 과 SP 구간 (배치 경로: `P_PLAN_ID NULL` → `V_BATCH_CALL_YN='Y'`)

| 순서 | marker | 이 marker 까지 수행된 구간 (사내 원문 줄) | 주요 작업 |
|---|---|---|---|
| 1 | START | L1223~1250 | GTT 19종 DELETE 후 START 로그 |
| 2 | A001 | L1253~1348 | 변수 셋팅 · `DM_LONG_PLAN_WEEK_CNT` LOOKUP · `V_MEASURE`(40=`SCM_FCST`) ※ L1269 블록 미수행(§4 발견 1) |
| 3 | A007 | L1387~1649 | `SCP_PLN_RTF_ALLOCATION_V` MAX PLAN_ID → `V_P_PLAN_ID` · 없으면 INVALID→END 조기 종료(L1409) · `SCP_PLN_INTERFACE_YN` RTF flag · GT_PRDM2_MF_BALANCE_MKT_FCST / RESULTS / MF_RTF_ALLOCATION 적재 + 통계 |
| 4 | A010 | L1674~2137 | **`DBMS_STATS.GATHER_TABLE_STATS('DM_PLN_MKT_FCST', NO_INVALIDATE=>FALSE)` (L1857)** → GT_PRDM2_MKT_FCST_INSERT (L1859) · GT_PRDM2_CFM_DEMAND_INSERT (L1938) · CELL_PROD_SITE_ID 보정 (L2023) |
| 5 | A011 | L2147~2300 | `INSERT INTO DM_PLN_MKT_FCST` (L2150) · RMA 처리 MKT_FCST / CFM_MKT_DEMAND_PLAN |
| 6 | WS_RTF:START | L2311~2683 | VMI 재고 추출(GT_PRDM2_FP_STOCK_QTY / VMI_MST / VMI_TEMP1·2·ALL + 통계 6회) · VMI RTF DELETE/INSERT MKT_FCST + CFM |
| 7 | WS_RTF:END | L2689 | `PR_DM_DNM_CREATE_WS_RTF('40')` 본체 (AS 재고 → RTF) |
| 8 | A018 | L2694~2903 | VMI DIO 40 분기 (DELETE/INSERT CFM_MKT_DEMAND_PLAN·MKT_FCST, L2694~2826) · GT_PRDM2_MF_BALANCE_MKT_FCST 40 (L2842) · GT_PRDM2_MST (L2871) |
| 9 | A019 | L2913~2950 | GT_PRDM2_MST_ACCUM · GT_PRDM2_TEMPX · DELETE BALANCE from DM_PLN_MKT_FCST |
| 10 | KRW:START | L2957~3000 | INSERT BALANCE into DM_PLN_MKT_FCST · 40: DM_PLN_CFM_MKT_DEMAND_PLAN BALANCE |
| 11 | KRW:END | L3010 | `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW('40','SYSTEM')` 본체 |
| 12 | A020 | L3010~3017 | 호출 복귀 |
| 13 | END | L3024~3162 | `V_BATCH_CALL_YN='Y'` → CUTOFF 블록(A021 / `PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE` / `PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE` / A024) **미수행** |

- A002 는 화면 CALL 전용(L1365). 정상 배치 1회 = step 7개(`A001,A007,A010,A011,A018,A019,A020`).
- 같은 초에 찍힌 START 와 step 행은 `EVENT_DATE` 만으로 순서가 뒤집히므로(사내 실측) 모든 쿼리가 `ORD`(START<ING<INVALID<END/ERROR) + step 번호로 2차 정렬한다.

## 2. 쿼리 읽는 법

| 쿼리 | 보는 것 | 판단 |
|---|---|---|
| Q0 | 전주 월 00:00 ~ 목 24:00 | 다른 기간은 각 쿼리 `w` 의 두 날짜를 바꾼다. 윈도 시작 전에 START 한 실행은 빠진다 |
| Q1 | 실행별 시작·종료·소요(분)·상태·step 궤적 | `ERROR` → ERR_AT 의 `line NNNN` 이 실패 줄 · `INVALID→END` = 최신 PLAN_ID 없음(L1409) 조기 종료 · `미종료` = 세션 kill/타임아웃 의심 · STEP_LIST 가 7개 미만이면 중간 중단 |
| **Q2** | 실행 1건의 타임라인, `GAP_SEC` = 직전 로그와 간격, `SECTION` = 그 간격 동안 수행된 SP 구간 | **GAP 큰 행의 SECTION 이 병목 구간**. 하위 SP 행(WS_RTF / KRW)이 구간을 더 잘게 나눈다 |
| **Q3** | 구간(직전 marker → marker)별 합계·평균·최대, 비율 | `TOTAL_SEC` 상위 = 튜닝 1순위 구간. 그 구간 안의 SQL 1문장은 Q7 로 특정 |
| Q4 | 기간 안 ERROR/INVALID 전부(타 SP 포함) | 하위 SP 예외는 하위 ERROR + 루트 ERROR(L3176) 2건으로 남음 |
| Q5 | 최근 8주 주차별 소요 추이 | 개선 전후 비교 기준선 |
| Q6 | 스케줄러 잡 실행 이력(`RUN_DURATION`·CPU·에러·`SESSION_ID`) + 잡 정의/스케줄 + 잡 로그 | 수동 실행이면 0행. `SESSION_ID`(sid,serial#)는 Q7-b 의 `SESSIONS` 와 대조 |
| Q7-a | (V$ 권한) 공유풀에 남은 이 SP 발 SQL — `PROGRAM_LINE#` = SP 줄 | 실행 직후만 유효 |
| **Q7-b** | (AWR) 기간 안 이 SP 세션의 SQL × 플랜 라인 × 대기이벤트 샘플(10초=1) | **hook #129 0-b 실측** — 상위 sql_id 를 `DBMS_XPLAN.DISPLAY_AWR` 로 풀어 1~4순위 판단. 보존 8일이라 월요일분은 비어 있을 수 있음 |
| Q7-c | (AWR) 잡 세션(`ACTION=잡 이름`)이 돌린 SQL 소요 상위 | ASH 가 비었을 때 대안. 수동 실행이면 0행 |

## 3. 사내 사전 검증 (2026-10-07, ZIOUI1 SCM_MGR)

- 사내에는 이 호출(40 / NULL)의 로그가 2026-09-03 이후 **0건**(사내 잡은 DISABLED). 같은 SP 의 **82 / CALL 실행 5건**(2026-09-28~10-01)으로 치환해 Q0~Q7 전부 실행 → 문법·구조 정상. 40 / NULL 원문도 전부 실행(0행 또는 정의 행).
- 치환 검증에서 읽힌 것(해석 예시, 사내 데이터):
  - Q1: 09-28 16:58 실행 8.9분 → `ERROR ORA-03135 connection lost contact` at **line 2825**(VMI DIO INSERT DM_PLN_MKT_FCST, 82 분기 L2786~2825) · 10-01 16:11 실행 **39분**(END) · 나머지 3건 0.5분.
  - Q7-b: 그 09-28 세션(597,64501)은 `dnfs2wbc1anhw` 플랜 라인 1 `LOAD TABLE CONVENTIONAL` + `free buffer waits` 가 460초(PDB 1벌 기준, 전체의 86.8%) — 로그가 가리킨 구간(A007 이후, 에러 줄 2825 = VMI_DIO INSERT)과 ASH 가 같은 지점을 가리킴. MODULE 은 node.exe(앱 세션)라 Q7-c(ACTION=잡 이름)에는 안 잡힘.
  - Q7-c: ACTION 필터 없이는 자동 튜닝 태스크(`/* SQL Analyze */`, ACTION=`ORA$AT_SQ_SQL_SW_nnn`)가 상위를 전부 차지 → ACTION=잡 이름으로 고정.
  - AWR 은 CDB 루트/PDB 2벌(dbid≠con_dbid / dbid=con_dbid) → `dbid = con_dbid` 로 1벌만 집계. 사내 보존 8일 · 스냅샷 1시간.
- 사내 SCM_MGR 은 DBA_HIST_* 조회 가능(V$SQLAREA 는 0행). 클라우드 계정 권한은 실행 시 확인.

## 4. 원문 확인 중 발견 (이 호출에 직접 영향 — 보고만, 수정 미실시)

1. **배치 경로에서 L1269 블록 미수행 (AS-IS 와 다름)** — Oracle 원문 L1263 `V_P_PLAN_ID := ''`(=NULL) 뒤 L1269 `IF V_P_PLAN_ID <> 'CALL'` 는 NULL 비교로 FALSE. AS-IS MSSQL(`ASIS_LATEST__PROD`, L158 `SET @p_plan_id=''` → L164 `IF (@p_plan_id <> 'CALL')`)은 `''<>'CALL'` TRUE 로 수행. 영향: 40 사업부 `V_SP_CUTOFF_FLAG`(L1302, SP_W 버전 존재 여부)가 NULL 로 남아 **L1470 "사용자 수정 RTF 보존"(E20260331-000648) 블록이 배치에서 항상 건너뜀** (CALL 경로는 영향 없음). 속도와 무관한 정합성 건 — 반영 여부는 사용자 결정 대기.
2. 매 실행 `DBMS_STATS.GATHER_TABLE_STATS('DM_PLN_MKT_FCST', NO_INVALIDATE=>FALSE)`(L1857, 2026-06-23 튜닝 이력)가 A007→A010 구간에 포함 — 해당 구간이 크게 나오면 통계 수집 자체 시간을 Q7 로 분리 확인 (가설, 실측 전 결론 금지).
3. 사내 09-28 82/CALL 실행의 ORA-03135 는 클라이언트(node.exe 세션) 연결 끊김으로 SP 가 중단된 것 — 클라우드 40 배치와는 별건.

## 5. 클라우드 1차 결과 (2026-10-07 사용자 실행, 전주 09-28~10-01 · 수신분 = Q1 전체 + Q2 실행 1 의 A019 까지, 이후 잘림)

| # | 시작 | 소요 | 상태 | step | 비고 |
|---|---|---|---|---|---|
| 1 | 09-28(월) 00:09:20 | 5.7분 | END | 7 | 정상 배치 경로 |
| 2 | 09-29(화) 00:24:54 | 6.5분 | END | 7 | 정상 |
| 3 | 09-29(화) 18:02:48 | 1.3분 | **ERROR** | 4 (A011 까지) | `ORA-01400 cannot insert NULL into GT_PRDM2_FP_STOCK_QTY.SCM_SITE_ID` line 2312 (= 사내 L2316 INSERT, SCM_DNM_STOCK_SN×SCM_MST_LOCATION) — 수동 실행 추정(비정규 시각) |
| 4 | 10-01(목) 00:04:08 | 4.5분 | **ERROR** | 5 (A011 + 'SCP 미수립 주차→마지막 계획 RTF' ING) | `ORA-00001 PK_DM_PLN_CFM_MKT_DEMAND_PLAN` line 2703 (= 사내 L2713 VMI_DIO INSERT). 사내 원문엔 2026.10.01 AJS "ATTRIBUTE1~10 복사" 보정이 바로 이 중복 적재 원인을 고친 것으로 주석됨 → 클라우드 판본 포함 여부 Q8-a 로 확인 |

- 클라우드 잡은 **매일 00:0x 에 실행**(사내 정의 화·목 과 다름). 4건 중 2건 실패.
- 실행 1 타임라인(343초): START→A007 **58초** · A007→A010 13초 · A010→A011 1초 · **A011→WS_RTF:START 229초(67%)** · WS_RTF 2초 · →A018 3초 · →A019 13초 · 이후 잘림.
  → 병목 구간 = 사내 L2314~2683 "VMI 재고 추출 → VMI RTF DELETE/INSERT" (40 분기). 구간 안 SQL(사내 줄): GT_PRDM2_FP_STOCK_QTY INSERT(2316, `TO_CHAR(S.CUTOFF_DATE)` 비교) · GT_PRDM2_VMI_MST_MAIN INSERT(2336, **SELECT 절 스칼라 서브쿼리 `(SELECT SUM(S.QTY) FROM GT_PRDM2_FP_STOCK_QTY …)` 2곳 + `ITEM_ID LIKE … || '%'`**) · VMI_MST_MAIN 2차(2450) · VMI_MST(2472) · VMI_TEMP1/2/ALL(2492~2540) · EXCEPTION 삭제(2565) · DM_PLN_MKT_FCST DELETE 2문(2578/2593) · CFM DELETE(2608) · MKT_FCST INSERT(2625) · CFM INSERT(2654). 어느 문장인지는 **Q7-b(ASH) 결과가 와야 특정** — 1순위 후보(스칼라 서브쿼리)는 보이지만 실측 전 확정 금지(hook #129 0-b).
- **클라우드 SP 는 사내와 다른 판본**: 에러 줄 2312/2703 ↔ 사내 2316/2713, GTT `GT_PRDM2_FP_STOCK_QTY.SCM_SITE_ID` 사내 NULL 허용 ↔ 클라우드 NOT NULL. Q2 SECTION 줄 번호는 클라우드에서 몇 줄 어긋남 → **Q8 로 판본·줄 번호 재정렬 후 해석**.
- 사내 SCM_MST_LOCATION(40) 에 SCM_SITE_ID NULL 행 0건, 재고 조인 NULL 0건 → ORA-01400 은 클라우드 데이터(해당 시점 LOCATION 마스터) 문제 가능성. Q8-e 로 확인.

## 5-2. 클라우드 2차 결과 (2026-10-07, 02_compact_output.sql 전체 수신)

**구간 집계 C3 (정상 완주 2건 + 오류 2건 합산)**

| 구간 | 실행별 초 | 비율 | 사내 원문 구간 |
|---|---|---|---|
| **A011 → WS_RTF:START** | 229 / 254 / 229 | **65.7%** | L2314~2683 VMI 재고 추출 → VMI RTF DELETE/INSERT (40 분기) |
| **A001 → A007** | 58 / 61 / 59 | 16.4% | L1387~1649 SCP_PLN_RTF_ALLOCATION_V(뷰) MAX PLAN_ID 2회(L1391, L1423) · GT_PRDM2_MF_BALANCE_MKT_FCST / RESULTS / MF_RTF_ALLOCATION(뷰 원천, L1632) 적재 |
| A007 → A010 | 13 / 20 / 18 / 20 | 6.5% | DM_PLN_MKT_FCST 통계수집 + MKT_FCST_INSERT/CFM_DEMAND_INSERT |
| A019 → KRW:START | 14 / 17 | 2.9% | BALANCE INSERT |
| A018 → A019 | 13 / 14 | 2.5% | MST_ACCUM / TEMPX |
| KRW:START → A020 | 10 / 14 | 2.2% | PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 본체 |
| WS_RTF 본체 | 2 / 8 / 7 | 1.6% | PR_DM_DNM_CREATE_WS_RTF |
| 나머지 | ≤1 | | |

- 세 번 측정이 229·254·229 로 일정 → 데이터량 의존 고정 비용. hook #129 §0.4 기준(≥2초) 대상 구간 = 위 6개, 1·2순위 구간이 82%.
- 실행 4 는 `SCP_PLN_INTERFACE_YN.DM_RTF_YN='N'` 이라 "마지막 계획수립 주차(PLAN_ID 1462) RTF 적용" 분기(L1442~1462)로 들어갔고 그 경로에서도 A011→WS_RTF 229초로 동일.

**C7(ASH 전주 전체)** 은 09-30 15:39~20:19 DBeaver 수동 실행 세션(같은 SP, PLAN_ID 지정 → CUTOFF 블록 → `GT_DPMFCQB_*` = C_QTY_BALANCE 경로)이 상위를 독식해 잡 실행과 분리가 안 됨. 다만 그 세션들에서 **`3g9x8t27cmu5k` INSERT INTO GT_PRDM2_VMI_MST_MAIN 이 플랜 라인 18 INDEX RANGE SCAN · ON CPU 로 1,050초**(4 세션 합) — 병목 구간 안의 L2336/L2397/L2450 과 같은 문장 가족. **잡 실행 구간만 보는 C7-run 을 추가**(02 파일), 실행 후 확정.

**판본**: C8-ver 클라우드 `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` = 3181줄 · AJS 10-01 보정 4곳 · ASISDELTA 5곳 · step 11곳, DDL 2026-10-06 16:16:08 → **사내(10-06 16:03)와 동일 판본**. step 줄 번호 동일(1354/1367/1665/2141/2304/2907/2951/3014). 1차에서 "다른 판본" 이라 본 것은 **에러가 난 09-29·10-01 시점의 구판 줄 번호** 때문. GTT `GT_PRDM2_FP_STOCK_QTY` 도 지금은 4칸 NULL 허용(ORA-01400 당시는 NOT NULL 판본).

**오류 추이 C5 (이 호출만)**: 09-21 주 7회 전부 END(5.7~6.8분) → 09-28 주 7회 중 **4회 ERROR** → 10-05 주 4회 중 **3회 ERROR**(월 00:08 0.4분·화 00:22 0.4분·화 14:00 0.5분·수 00:03 2.3분). 10-06 16:16 신판 배포 뒤 첫 정기 실행(10-07 수 00:03)의 상태는 C1W 로 확인 필요. 속도 이전에 **매일 실패하는 상태**가 먼저다.

**ASH 귀속 한계(사내 실측)**: 화면 CALL 경로(PKG_DMF0003 → 본 SP)는 ASH 의 `PLSQL_ENTRY_OBJECT_ID` 가 PKG_DMF0003 이고 `PLSQL_OBJECT_ID` 는 NULL 로 남아 본 SP 로 귀속되지 않음. 잡 경로(익명 블록 → 본 SP)는 entry = 본 SP 라 C7/C7-run 필터가 유효(클라우드 1차 C7 에서 확인). 필터는 entry 또는 current 어느 쪽이든 본 SP 이면 포함하도록 확장.

**C6**: 클라우드 잡 정의도 DISABLED(runs=0, next=09-22 15:30) → 매일 00:0x 실행은 이 DBMS_SCHEDULER 잡이 아니라 **다른 스케줄러(외부 잡/다른 잡 이름)** 가 호출. Q7-c(ACTION=잡 이름) 는 무효. 실행 주체 확인 필요 — C7-run 의 module/action 열이 단서.

## 5-3. 클라우드 3차 결과 (2026-10-07, C1W · C7-run · C7-plan 수신)

**실행 주체 확정**: C7-run 의 세션 MODULE/ACTION = `DBMS_SCHEDULER / JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TO…`. 사내 정의로 보면 `JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TOTAL_MOBILE`(일·수·목·금·토 00:00, step 2 = `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('40','MKT FCST Daily Cutoff','MF_D','Daily Rolling','system')`) + 월(`…_MON_TOTAL`)·화(`…_TUE_TOTAL`) 00시 잡. 즉 **매일 00시 로그는 Daily Rolling(MF_D) 안에서 본 SP 가 ('40', NULL) 로 호출된 것**이고, 사용자가 지정한 `JOB_SCMPROD_PLAN_FINAL_40_CREATION`(화 15:30·목 01:30) 은 클라우드에서도 DISABLED(runs=0)로 **한 번도 돌지 않았다**. 호출 인자·경로(배치 경로)는 동일하므로 측정치는 그대로 유효. ASH 의 entry 객체는 WEEKLY_ROLLING 이라 1차 C7-run 이 1행만 잡힘 → 필터를 잡 세션(ACTION) 기준으로 확장.

**이번 주 C1W**

| 실행 | 소요 | 상태 | 내용 |
|---|---|---|---|
| 10-05(월) 00:08 | 0.4분 | ERROR | `ORA-00979 "A"."PLANT_SITE_ID" must appear in GROUP BY` line 1858 (구판 줄: GT_PRDM2_MKT_FCST_INSERT 적재) |
| 10-06(화) 00:22 | 0.4분 | ERROR | 동일, line 1858 |
| 10-06(화) 14:00 | 0.5분 | ERROR | 동일, line 1939 (GT_PRDM2_CFM_DEMAND_INSERT) |
| **10-07(수) 00:03** | **2.3분** | **END** | step 7개 완주 — 10-06 16:16 신판 첫 정기 실행 |

→ 10-02~10-06 사이 클라우드에 올라간 판본이 GROUP BY 오류로 매일 실패했고, 10-06 16:16 판본(= 사내)에서 해소. 같은 판본에서 **5.7~6.5분 → 2.3분**. 구간 분해는 C3W/C2W(02 파일에 추가) 결과로 확인.

**C7-plan (`3g9x8t27cmu5k`, 구판 L2336 GT_PRDM2_VMI_MST_MAIN INSERT, 09-30 수동 세션 기준)**: GT_PRDM2_RESULTS(세션 통계 1행 추정) → PK 인덱스 NL → 달력 MERGE JOIN CARTESIAN(38일) → CFM C 를 PK INDEX RANGE SCAN(라인 18)으로 행마다 재탐색. CPU 1,050초가 라인 18 에 몰린 이유 = 조인 조건에 END_CUSTOMER 가 없어 PK 인덱스가 3번째 칸에서 끊김 — **AJS 2026.10.01 보정(L2393 `A.END_CUSTOMER = C.END_CUSTOMER` 추가)이 정확히 이 지점을 고친 것**이고 10-06 16:16 클라우드 반영됨. SELECT 절 스칼라 서브쿼리 2곳(플랜 라인 2~5, GT_PRDM2_FP_STOCK_QTY FULL ×행수)은 그대로 남아 있음 — 신판 C3W 에서 A011→WS_RTF 구간이 여전히 크면 1순위 대상.

## 5-4. 클라우드 4차 결과 (2026-10-07, C7-run 잡 세션 기준 · C3W/C2W) — hook #129 0-a/0-b 완료

**0-b 확정 (구판, 10-01 00:04 실행)**: 잡 세션(9707,29704) ASH 230초의 전부가 `3g9x8t27cmu5k` GT_PRDM2_VMI_MST_MAIN INSERT 플랜 라인 18(PK_DM_PLN_CFM_MKT_DEMAND_PLAN INDEX RANGE SCAN, ON CPU) — 로그 구간 A011→WS_RTF 229초와 1:1 일치. 원인 = END_CUSTOMER 조인 누락으로 PK 인덱스 3번째 칸까지만 사용, AJS 2026.10.01 보정(L2393)이 해당 → 10-06 16:16 반영.

**신판 10-07 00:03 실행 (138초) 구간 분해 C3W/C2W**

| 구간 | 초 | ASH(10초 샘플) 로 보인 문장 | 사내 원문 |
|---|---|---|---|
| A018 → A019 | 37 | `242jv1rzat1x7` DELETE DM_PLN_MKT_FCST BALANCE (EXISTS GT_PRDM2_TEMPX) 30+10 | L2914 MST_ACCUM(윈도 SUM) · L2924 TEMPX(GROUP BY) · **L2936 DELETE** |
| A019 → KRW:START | 29 | `630stwpcj5tr1` INSERT BALANCE DM_PLN_MKT_FCST 20 · `bv4t2rqbavhqt` DELETE CFM BALANCE 10~20 | L2958 INSERT · **L2972 DELETE (EXISTS 안 `CASE WHEN DIVISION_ID='40' THEN END_CUSTOMER ELSE PROJECT_CODE END = …`)** · L2988 INSERT |
| KRW:START → A020 | 19 | (별도 SP) | PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW |
| A007 → A010 | 18 | (샘플 없음) | DM_PLN_MKT_FCST 통계수집(L1857) + MKT_FCST_INSERT/CFM_DEMAND_INSERT |
| A001 → A007 | 14 | `4rb7702gb1zjm` MAX(PLAN_ID) FROM SCP_PLN_RTF_ALLOCATION_V 10~30 | L1391 / L1423 뷰 2회 + L1632 뷰 원천 적재 |
| WS_RTF:END → A018 | 9 | | VMI DIO 40 분기 · MF_BALANCE · GT_PRDM2_MST |
| WS_RTF 본체 | 7 | | |
| A011 → WS_RTF:START | **2** (구판 229) | | VMI_MST_MAIN INSERT — 해소 |
| 나머지 | ≤3 | | |

- 신판에서 2초 이상 구간은 7개이나 어느 하나도 40초를 넘지 않음. 남은 후보(실측 근거 순):
  1. **3순위(SARGable)** L2972 CFM BALANCE DELETE — EXISTS 상관조건의 `CASE … END = TEMPX.PROJECT_CODE` 는 CFM PK 2번째 칸(PROJECT_CODE)을 못 쓰게 함. 40 분기 전용이므로 `END_CUSTOMER = TEMPX.PROJECT_CODE` 로 풀 수 있음(AS-IS 의미 동일 여부 확인 필요).
  2. **1-b(소비집합 선행축소)** L2936/L2958 DM_PLN_MKT_FCST BALANCE DELETE/INSERT — DIVISION_ID 조건이 없고(TEMPX 상관) MEASURE='BALANCE' 로 전 사업부 BALANCE 행을 대상으로 EXISTS 판정. `DIVISION_ID = C_DIVISION_ID` 추가로 범위 축소 가능(결과 불변, TEMPX 가 단일 사업부).
  3. **1-b** L1391/L1423 `SCP_PLN_RTF_ALLOCATION_V` MAX 2회 → 뷰 원천 테이블 직접 MAX 또는 1회로 통합.
  4. 1순위(스칼라 서브쿼리 L2341/2347)는 신판에서 구간 2초라 **대상 제외**.
  5. 4·5순위(인덱스 추가·힌트) 미검토 — 1~3 적용 후 재측정 전엔 착수 안 함.
- ASH 는 10초 샘플이라 138초 실행의 문장 단위 수치는 ±10초 오차. 정밀값이 필요하면 다음 00시 실행 직후 `V$ACTIVE_SESSION_HISTORY`(1초 샘플)로 같은 쿼리를 돌린다(02 의 C7-run 에서 `dba_hist_active_sess_history` → `v$active_session_history`, `dbid=con_dbid` 조건 삭제).
- 10-07 실행은 ING(SCP 미수립 주차 분기) 없이 당주 PLAN 으로 돈 실행이라 10-01~10-06(c_plan_id 1462 분기)과 데이터 조건이 다름. 신판 효과 확정은 다음 2~3회 실행 C3W 로.

## 5-5. 보완 적용 (2026-10-07 사내 · 클라우드 패키지)

사내 실측(40 데이터, ROLLBACK 보호) 후 **결과 동치가 증명되고 효과가 구조적으로 확실한 1건만 적용**: 배치 경로 `SCP_PLN_RTF_ALLOCATION_V` 평가 4회→2회 (MAX 2질의 → KEEP 1질의 · RESULTS UNION 분기가 GTT 재사용). 사내 적용 23:26 VALID · 스모크 통과 · 전체 실행은 클라우드 다음 00시 실행으로 측정. 삭제문 재작성·DIVISION 조건 추가는 실측상 효과 없음(DML 본체 비용)으로 미적용, 통계수집·BALANCE MERGE·KRW 는 승인 필요 옵션. 상세·절차: `_artifacts/_apply_corporate/QTY_BALANCE_40_VIEWONCE_20261007/APPLIED_OPERATIONS.md`.

## 6. 한계

- 로그는 step 단위라 "구간" 까지만 특정. SQL 1문장 특정은 Q7(AWR/V$) 또는 실행 중 `V$SESSION`/`V$ACTIVE_SESSION_HISTORY` 실측 필요 (hook #129 0-b).
- 속도 개선 착수는 `Doc/_rules_v2/hooks/oracle-perf-fix-priority-order.md` 순서(0-a 전수 측정 → 0-b 대상 환경 실측 → 1 함수/스칼라 → … → 5 힌트는 승인 후) 로 진행. 본 폴더는 0-a/0-b 입력 자료.
