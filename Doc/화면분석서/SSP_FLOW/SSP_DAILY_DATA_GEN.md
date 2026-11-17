# SSP 일 데이터 생성 방안

- 작성일: 2026-11-16
- 범위: AS-IS 개발 DB(LGCE_SCMDEV)와 TO-BE Oracle에서 SCP 결과 없이 매일 SSP 화면 시험 데이터를 만드는 방법
- 근거: AS-IS SP 원문 `Doc/asisfacts/db/modules/dbo.*.sql`(LGCE_SCMDEV 추출본), 운영 잡 목록 `Doc/asisfacts/ref_ssp/prod_jobs.csv`, 흐름 문서 `SSP_SHIPPLAN_FLOW.md`, `SSP_REF_PROCESS.md`
- 상태: 설계만 작성함. DB 조회·실행 없음. 행 수·소요 시간은 미측정임

## 1. 운영 생성 경로

| 순서 | 주기 | 운영 잡 | SP | 결과 테이블 |
|---|---|---|---|---|
| 1 | 매주 월 00:01 | JOB.SCMPROD_PLAN_ID_WEEKLY_Creation | PR_SCM_MST_PLAN 'WEEKLY' | SCM_MST_PLAN(WEEKLY) |
| 2 | 사업부별 주 1회 | JOB.SCMPROD_PLAN_FINAL_<사업부>_Creation | PR_SCP_ENG_CONTROL → PR_SCP_PLN_INTERFACE_PLAN | SCP 엔진 결과, 출하요청 |
| 3 | 매일 00:10 | JOB.SCMPROD_PLAN_ID_DAILY_Creation | PR_SCM_MST_PLAN 'DAILY', 오늘 | SCM_MST_PLAN(DAILY) |
| 4 | 수시(5~30분) | JOB.PR_SSP_XIF_*_STOCK_*_R | PR_SSP_XIF_OWMS_STOCK_R 등 | 재고 I/F 테이블, IF_STOCK_CHECK 룩업 플래그 |
| 5 | 매일 07:15 | JOB.PR_SSP_PLN_SHIP_PLAN_P | PR_SSP_ANL_SHIP_PLAN_P → PR_SSP_ANL_SHIP_CONFIRM_P | SSP_ANL_SHIP_PLAN_P |
| 6 | 매일 08:00, 10:30, 11:00 | JOB.PR_SSP_PLN_SHIP_PLAN_40, _40_AZ, _40_C | _40_BALANCE → CONFIRM_BATCH_40 → SHIP_PLAN_40 | SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_CONFIRM |
| 7 | 10분마다 | JOB.PR_SSP_PLN_SHIP_PLAN_81_82 | PR_SSP_PLN_SHIP_PLAN_CUTOFF → 하위 SP | SSP_ANL_SHIP_PLAN_C, SSP_ANL_SHIP_CONFIRM |
| 8 | 10분마다 | JOB.PR_SSP_PLN_SHIP_PLAN_EE | PR_SSP_ANL_SHIP_PLAN_EE | SSP_ANL_SHIP_PLAN_EE, SSP_ANL_SHIP_REQ_EE |
| 9 | 30분마다 | JOB.PR_SSP_ANL_SHIP_PLAN_ALL | PR_SSP_ANL_SHIP_PLAN_ALL NULL | SSP_ANL_SHIP_PLAN_ALL |

- 개발 DB SQL Agent 잡은 411개 중 활성 1개이며 SSP 잡은 전부 꺼져 있음(`SSP_BATCH_ANALYSIS.md` L7)
- 개발 DB에는 재고 I/F(순서 4)를 보내는 외부 시스템이 없음. 순서 4는 생성 작업이 대신 채워야 함

## 2. 생성 전에 정해진 제약

### 2-1. 실행일이 곧 데이터 일자임

| SP | 기준 일자 | 원문 |
|---|---|---|
| PR_SSP_ANL_SHIP_PLAN_40 | 오늘(GETDATE) | L187 |
| PR_SSP_ANL_SHIP_PLAN_EE | 오늘(GETDATE) | L193 |
| PR_SSP_ANL_SHIP_PLAN_P | 전일(GETDATE-1) | L43 |
| PR_SSP_ANL_SHIP_PLAN_CUTOFF, CONFIRM_BATCH_N | 파라미터 @cutoff_date(호출 측이 전일 전달) | PR_SSP_PLN_SHIP_PLAN_CUTOFF L83 |
| PR_SSP_ANL_SHIP_PLAN_ALL | 파라미터, NULL이면 전일 | L67~73 |

- 40, EE, Packer는 일자를 파라미터로 받지 않음. 빠진 날을 나중에 SP로 채울 수 없음
- 빠진 날은 결과 테이블 일자 이동 복제(5장)로만 채움

### 2-2. 화면 Plan date 노출 조건

SSP 화면 Plan date 목록은 `SSP_PLAN_VERSION_V`(`UP_FX_GetCommonDataList` 'PlanDateShip', 상위 20건)에서 가져옴.

| 대상 | 노출 조건 | 원문 |
|---|---|---|
| 사업부 40 | SCM_MST_PLAN_DETAIL 행: DAILY 모델링, PLAN_TYPE 'SP', PLAN_STATUS '1', UI_DISPLAY_YN 'Y', CONFIRM_FLAG 'Y' | SSP_PLAN_VERSION_V L28~59 |
| 40 외 사업부 | SSP_MST_SHIP_PLAN_SCHEDULE에서 CONFIRM_CREATE_YN 'Y'인 최신 PLAN_START_YYYYMMDD 1일. 법인은 룩업 SSP_PLAN_VERSION_V/ESOC(C100) | L61~86 |
| 공통 하한 | plan_name >= FN_GET_BUCKET_YYYYMMDD(-5). 매주 월요일 이동, 2026-11-16 기준 20261012 | L105 |

- 40은 PR_SSP_ANL_SHIP_PLAN_40이 SP 행을 넣음(L314~368, PLAN_STATUS 0으로 시작). 완료 시 1로 바뀌어야 노출됨
- 40 외 사업부는 C100 법인 일정 행 1건만 보고 날짜를 정함. C100 일정 행이 'Y'가 아니면 81/82/EE 화면 Plan date가 0행임

## 3. 생성 방식 요약

배치 SP는 원본 그대로 실행함. SP가 기다리는 입력과 진행 플래그만 생성 작업이 준비함.

| 단계 | 주기 | 내용 |
|---|---|---|
| L1 SCP 대체 입력 | 주 1회(월), 그 주 FN 버전이 없을 때 | 최근 FN 버전 SCP 결과를 이번 주 일자로 복제, 출하요청 SP 호출 |
| L2 일 전제 준비 | 매일, L3 전 | DAILY 계획 ID, 재고 스냅샷, IF_STOCK_CHECK 플래그, 일정 행, EE 호출 플래그 |
| L3 일 배치 실행 | 매일 | 운영 잡 순서대로 배치 SP 호출. 메일 SP 제외 |
| L4 대체 복제 | L3 실패 사업부만 | 직전 생성일 결과를 오늘 일자로 복제 |

## 4. 단계별 생성 방법

### 4-1. L1 SCP 대체 입력 (주 1회)

| 순서 | 대상 | 방법 | 원문 |
|---|---|---|---|
| 1 | SCM_MST_PLAN(WEEKLY) | PR_SCM_MST_PLAN 'WEEKLY', 이번 주 월요일 실행 | PR_SCM_MST_PLAN L54~156 |
| 2 | SCM_MST_PLAN_DETAIL(FN) | 사업부별 직전 FN 행을 새 PLAN_ID로 복제. PLAN_STATUS '1', UI_DISPLAY_YN 'Y', PLAN_TYPE 'FN' 유지 | PR_SCP_PLN_INTERFACE_PLAN L118~136, SCP_PLAN_VERSION_V |
| 3 | SCP_PLN_SHIPMENT_PLAN | 직전 FN 키(DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ) 행 복제. PLAN_ID 교체, 일자 컬럼 +7×n일 | PR_SSP_ANL_SHIP_REQ_FG L140~160 |
| 4 | SCP_PLN_SHIPMENT_PLAN_PEGGING | 같은 키로 복제. ORDER_ID 조인 유지 | REQ_FG L157~158 |
| 5 | SCP_ANL_SHIPMENT_PLAN_SEMI | MEASURE 'SHIP_PLAN_AMEND' 행 복제 | REQ_SEMI L220~229 |
| 6 | SCP_ANL_PRODUCTION_PLAN | 81/82 CUTOFF가 읽는 최신 WEEKLY 버전 행 복제 | PR_SSP_ANL_SHIP_PLAN_CUTOFF L550~575 |
| 7 | 출하요청 | 사업부별 SP 개별 호출: PR_SSP_ANL_SHIP_REQ_SEMI(div, start, 'FN', seq, user) 40 외, PR_SSP_ANL_SHIP_REQ_P('40', start, 'FN', seq), PR_SSP_ANL_SHIP_REQ_FG(div, plan_id) | PR_SCP_PLN_INTERFACE_PLAN L451~497 |

- 일자 이동 컬럼: PLAN_START_YYYYMMDD, YYYYMMDD, LPST, EPST, START_TIME, END_TIME
- 복제 행 표시: CREATED_BY = 'SSPGEN_<YYYYMMDD>'. SCM_MST_PLAN·_DETAIL은 기존 예시 `tools/AsisLocal/sql/20261115_SSP0015_PLAN_VERSION_40.sql`처럼 ATTRIBUTE15도 씀
- 7번은 PR_SCP_PLN_INTERFACE_PLAN을 통째로 부르지 않음. 통째로 부르면 PR_SCP_PLN_FP_SHIP_TARGET, PR_SCP_PLN_MRP_PROD_TARGET_NERP_CREATE, PR_SCP_PLN_PEGGING_PLAN, PR_SCP_IF_SCS_SHIP_TARGET(82)이 같이 돌아 FP·ERP 대상 테이블까지 씀
- REQ_FG는 같은 계획 시작일에 1회만 돎. 룩업 DM_ETC_SETTING / SEGMENT1 'PLAN_START_YYYYMMDD_<div>' / SEGMENT2 시작일 행이 있으면 건너뜀(L212~219). 새 주 시작일이면 문제없음
- SCP_PLN_INTERFACE_YN.FP_TARGET_YN = 'N'이면 출하요청을 만들지 않음(REQ_FG L105). L1 전에 값 확인
- 출하요청 기간은 계획일부터 84일(SHIP_PLAN_40 L201). 주 단위 이동이면 매일 실행 기간을 덮음

### 4-2. L2 일 전제 준비 (매일)

| 순서 | 대상 | 방법 | 필요한 SP와 원문 |
|---|---|---|---|
| 1 | SCM_MST_PLAN(DAILY) | PR_SCM_MST_PLAN 'DAILY', 오늘 | SHIP_PLAN_40 L298~303 |
| 2 | 40 재고 | 최근 CUTOFF 스냅샷을 전일 CUTOFF로 복제: SSP_DNM_OWMS_STOCK, SSP_DNM_GMES_STOCK_40, SSP_DNM_STOCK_C, SSP_ANL_FORMATION_C, SSP_ANL_MES_FCS_STOCK_40_C | SHIP_PLAN_40 L203~214 |
| 3 | 81/82 재고 | SCM_DNM_STOCK_V가 CUTOFF_DATE 전일, STOCK_TYPE 'INVENTORY' 행을 내도록 원천 복제. SSP_DNM_OWMS_STOCK 전일 행 | PR_SSP_PLN_SHIP_PLAN_CUTOFF L118~124 |
| 4 | 외부 DB 재고 원천 | 시노님 대상 복제: LGCE_FPDEV_TR.dbo.SCM_STOCK_H(SCM_DNM_STOCK_SN), LGCE_FPDEV_TR.dbo.AGING_STOCK_V 원천(SCM_DNM_STOCK_AGING_V_SN), LGCE_FPDEV_TR.dbo.SCM_MES_WIP_HISTORY_H, LGCE_FPDEV_TR.dbo.IF_SSP_FP_RELEASE_PLAN_V 원천 | `db_synonyms.csv` |
| 5 | IF_STOCK_CHECK 룩업 | 기존 행 UPDATE: SEGMENT5 = 오늘, ATTRIBUTE1 = 'Y'. 대상 SEGMENT1/SEGMENT3 = PLAN_40/40, PLAN_AUTO/81_82, PLAN_EE/EE. SEGMENT4 = 법인 | SHIP_PLAN_40 L222~249, CUTOFF L144~167, EE L257~280 |
| 6 | SSP_MST_SHIP_PLAN_SCHEDULE | 법인 11개 행이 20501231까지 있음(11장 C2). 행 추가 없이 오늘·전일 행 _YN 플래그만 갱신함 | CUTOFF L83~105, L340~398 |
| 7 | SSP_MST_SHIP_PLAN_SCHEDULE_EE | 같은 형태로 20501231까지 있음. 오늘 행 CURRENT_PLAN_DATE_YN = 'N' 확인만 함 | EE L232~235 |
| 8 | EE 호출 플래그 | LGCE_FPDEV_TR.dbo.SCM_SYS_LOOKUP_VALUE / LOOKUP_TYPE_CODE 'AUTO_PLAN_CALL_FLAG' / ATTRIBUTE1 = 오늘, ACTIVE_FLAG 'Y'. 룩업 BASIS_START_TIME_PLANT 시업 시각과 SEGMENT2 일치 | EE L219~240 |
| 9 | Packer 기준일 | 룩업 SSP_ANL_SHIP_PLAN_P / SEGMENT1 '40'의 ATTRIBUTE1이 전일보다 작아야 함. SP가 끝에서 스스로 갱신하므로 정상 매일 실행이면 손대지 않음 | PLAN_P L53~60, L824 |

- 2~4번 재고 복제 키: CUTOFF_DATE(또는 해당 일자 컬럼)만 전일로 바꿈. 수량은 원본 유지
- 4번은 LGCE_SCMDEV 밖 DB에 쓰는 작업임. AS-IS 개발 DB 쓰기 허용 범위에 LGCE_FPDEV_TR이 들어가는지 확인 필요
- 6번 일정 행은 2019-08-21 'ssp_batch'가 20501231까지 미리 만든 행임(11장 C2). 행을 넣는 코드는 미확인이나 생성 작업에는 필요 없음
- AS-IS 개발 DB `PR_SSP_PLN_SHIP_PLAN_CUTOFF` L198 `set @erp_stock_cnt = 1;`(개발 테스트용)로 ERP 재고 확인을 건너뜀. 개발 DB에서 3번은 화면 데이터 내용용이며 진행 조건에는 쓰이지 않음

### 4-3. L3 일 배치 실행 (매일)

| 순서 | 호출 | 파라미터 | 비고 |
|---|---|---|---|
| 1 | PR_SSP_ANL_SHIP_PLAN_P | 없음 | 전일 기준 |
| 2 | PR_SSP_ANL_SHIP_CONFIRM_P | 없음 | |
| 3 | PR_SSP_ANL_SHIP_PLAN_40_BALANCE | 없음 | HQ00 잡에서만 |
| 4 | PR_SSP_ANL_SHIP_CONFIRM_BATCH_40 | '40', 'HQ00' | 오늘 계획 있으면 진행 안 함 |
| 5 | PR_SSP_ANL_SHIP_PLAN_40 | '40', 'HQ00' | |
| 6 | 4~5 반복 | '40', 'AZ00' | 운영 10:30 잡 |
| 7 | 4~5 반복, PR_SSP_ANL_INVENTORY_RAW '40' | '40', 'NJ00' | 운영 11:00 잡 |
| 8 | 81/82 법인별: PR_SSP_ANL_SHIP_PLAN_CUTOFF → _CUTOFF_FP_AUTO → PR_SSP_ANL_SHIP_CONFIRM_BATCH_N → _BATCH_N_FP_AUTO | 법인, 전일 | 아래 81/82 설명 |
| 9 | PR_SSP_ANL_SHIP_PLAN_EE | 없음 | 오늘 기준 |
| 10 | PR_SSP_ANL_SHIP_PLAN_ALL | NULL | 전일 기준. 한 번 스냅샷한 사업부·법인은 제외 |

- 호출 제외: PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40, PR_SSP_MAIL_SEND_BATCH_N, PR_SSP_MAIL_SEND_SHIP_REQ_DELETE, PR_SSP_XIF_SCS_PACK_SHIP_PLAN_S_82
- CONFIRM_BATCH 계열은 SP 안에서 XIF_ERP_SHIP_PLAN_CONFIRM_S 등 송신 테이블에 씀. 개발 DB 송신 테이블이 실제 ERP로 나가는지는 미확인임
- 81/82 설명
  - 개발 DB `PR_SSP_PLN_SHIP_PLAN_CUTOFF` L100~102는 PLAN_START_YYYYMMDD '20260920', COMPANY_ID 'MI00'으로 고정되어 있음. 이 SP를 부르면 MI00 1개 법인만 돌고 오늘 데이터가 생기지 않음
  - 방안 A: 이 SP를 부르지 않고 하위 SP를 법인별로 직접 호출함. SP가 하던 일 3가지를 생성 작업이 대신함
    - SSP_ANL_OWMS_STOCK_C2 생성(L201~330 INSERT 원문 그대로 사용)
    - 일정 행 플래그 갱신: ERP_STOCK_CUTOFF_YN, OWMS_STOCK_CUTOFF_YN, PLAN_CUTOFF_CREATE_YN, CONFIRM_CREATE_YN = 'Y'
    - 갱신 대상 PLAN_START_YYYYMMDD는 원문과 같게 둠: CUTOFF 단계는 오늘 행, PLAN_CUTOFF·CONFIRM 단계는 전일 행(L340~398)
  - 방안 B: 개발 DB SP 커서 조건을 운영 원문(주석 처리된 L99, L108)으로 되돌림. DB 객체 변경이라 사용자 승인 필요
  - 권장: 방안 A. AS-IS 개발 DB 객체를 바꾸지 않음
- 실행 중 감시: `db_orphan_sessions.py --watch` 5분 알림, 30분 본인 세션 KILL

## 5. L4 대체 복제 (L3 실패 사업부만)

| 결과 테이블 | 일자 키 | 화면 |
|---|---|---|
| SSP_ANL_SHIP_PLAN_40 | PLAN_START_YYYYMMDD, ATTRIBUTE10(법인) | SSP0015, SSP0026, SSP0029, SSP0045 |
| SSP_ANL_SHIP_PLAN_C | PLAN_START_YYYYMMDD | SSP0021, SSP0060 |
| SSP_ANL_SHIP_PLAN_EE | PLAN_START_YYYYMMDD | SSP0022, SSP0023 |
| SSP_ANL_SHIP_PLAN_P | PLAN_START_YYYYMMDD | SSP0015 |
| SSP_ANL_SHIP_PLAN_ALL | PLAN_START_YYYYMMDD | SSP0015, SSP0021, SSP0023, SSP0029, SSP0060 |
| SSP_ANL_SHIP_CONFIRM | 확정 일자, CONFIRM_ID('C'+일자+시퀀스) | 21개 화면 |
| SCM_MST_PLAN_DETAIL(SP 행), SSP_MST_SHIP_PLAN_SCHEDULE | 2-2 노출 조건 | Plan date 목록 |

- 버킷 일자 컬럼(YYYYMMDD 등)도 계획일 이동분만큼 같이 이동함
- CONFIRM_ID는 원본 시퀀스(SEQ1_SSP_ANL_SHIP_CONFIRM_ID)로 새로 받음. 원본 ID 재사용 금지
- SSP_ANL_SHIP_PLAN_40은 추출본 기준 전체 3,596,652행(`db_rowcounts.csv`)임. 하루치 복제 소요 시간은 미측정이며 첫 실행 때 잼
- 실행 기록에 '대체 복제'로 따로 남김. SP 실행 결과와 섞어 보고하지 않음

## 6. 표시와 되돌리기

- 복제 행: CREATED_BY = 'SSPGEN_<YYYYMMDD>'. 11장 C4 대상 21개 테이블에 ATTRIBUTE15가 없고, ATTRIBUTE10은 SSP_ANL_SHIP_PLAN_40이 법인 코드로 씀(SHIP_PLAN_40 L222)
- SP가 만든 행: SP가 CREATED_BY에 'ssp_batch' 또는 넘긴 user를 씀. 실행 시작·종료 시각과 PLAN_START_YYYYMMDD를 실행 기록에 남겨 되돌리기 키로 씀
- UPDATE한 룩업·일정 행: 바꾸기 전 값을 실행 기록에 저장
- 되돌리기 SQL: 실행마다 `undo_<env>_<YYYYMMDD>.sql` 생성. 행 단위 DELETE/UPDATE만 사용. TRUNCATE, WHERE 없는 DELETE, DDL 금지
- 보관: 생성분은 SSP_PLAN_VERSION_V 하한(5주) 안에서 유지. 삭제 주기는 사용자 결정

## 7. TO-BE Oracle 적용

- 같은 SP가 Oracle로 변환되어 있음. 11-16 카탈로그(`Doc/tobefacts/db/procs_catalog.csv`) 기준 VALID임
- DBMS_SCHEDULER 잡 47개는 DISABLED 상태로 기록됨(`it_precheck.csv` P-02, 11-09). `PR_SSP_PLN_SHIP_PLAN_CUTOFF` 머리말은 "Oracle Job 등록 없음"이라 기록이 서로 다름. ALL_SCHEDULER_JOBS 조회로 확인 필요
- 오늘 기준은 SYSDATE임. 2-1 제약 동일
- 외부 DB 시노님(LGCE_FPDEV_TR, LGCE_INFDEV) 대상이 TO-BE에서 어떤 객체인지 미확인. 4-2 4번·8번의 TO-BE 대상은 원문에서 다시 확인
- 저장 PROC는 PROC 안에서 COMMIT함. 실행 전 되돌리기 SQL을 먼저 만듦(2026-11-11 SCP0028 기록)
- AS-IS와 TO-BE 원천 데이터가 달라 결과 차이는 판정필요로 분류함(CR-101)

## 8. 실행 주체

| 항목 | 방안 |
|---|---|
| 실행기 | `tools/SspDaily/ssp_daily_gen.py` 신규. `--env asis|tobe`, `--steps L1,L2,L3,L4`, `--div`, `--dry-run` |
| 생성 원장 | `tools/SspDaily/ssp_gen_matrix.csv` 신규. 테이블별 생성 방법·일자 키·되돌리기 키. `ssp_batch_sp_table.csv`에서 시작 |
| DB 연결 | `tools/DbConn/dbconn.py` connect('asis'), SP 호출은 `tools/DbConn/golden.py` run_asis 재사용 |
| 일정 | Windows 작업 스케줄러 매일 1회. AS-IS → TO-BE 순서. 개발 DB SQL Agent 잡과 TO-BE 잡은 켜지 않음 |
| 기록 | `Doc/verify/SSP_DAILY/<YYYYMMDD>/`: 실행 기록 json, 테이블별 전후 행 수, undo SQL |

## 9. 생성 확인 기준

| 확인 | 기준 |
|---|---|
| Plan date | SSP_PLAN_VERSION_V에 40은 오늘, 40 외는 전일(C100 일정 행) 1건 이상 |
| 결과 행 | 4-3 결과 테이블별 생성 일자 행 수 > 0, 직전 생성일 행 수와 대조표 |
| 배치 로그 | SCM_SYS_LOG_BATCH에 이번 실행 ERROR 0, 'STOCK IS NOT YET INCOMMING' 0 |
| AS-IS 화면 | `tools/AsisLive/asis_live_run.py`로 SSP0015, SSP0021, SSP0023 조회 행 수 > 0 |
| TO-BE 화면 | PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI, PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN 직접 호출 행 수 > 0 |
| 되돌리기 | 첫 실행 후 undo SQL 1회 실행, 생성 전 행 수 복귀 확인 후 재생성 |

## 10. 실행 전 확인할 항목

| 번호 | 항목 | 확인 방법 |
|---|---|---|
| C1 | 사업부별 최신 FN 버전과 PLAN_START_YYYYMMDD | SCP_PLAN_VERSION_V 조회 |
| C2 | SSP_MST_SHIP_PLAN_SCHEDULE(_EE) 최대 일자, 미래 행 존재 | MAX(PLAN_START_YYYYMMDD) 법인별 |
| C3 | IF_STOCK_CHECK 행 목록(SEGMENT1·3·4) | 룩업 조회 |
| C4 | 재고 테이블별 최신 CUTOFF_DATE와 하루 행 수 | 테이블별 GROUP BY |
| C5 | 표시 컬럼(ATTRIBUTE15) 유무 | `Doc/asisfacts/db/db_columns.csv` |
| C6 | 개발 DB 송신 테이블(XIF_*_S*)이 외부로 나가는지 | 인터페이스 담당 확인 |
| C7 | LGCE_FPDEV_TR 쓰기 허용 여부 | 사용자 확인 |
| C8 | TO-BE 잡 등록 상태 | ALL_SCHEDULER_JOBS |
| C9 | SP 1회 소요 시간 | 첫 실행 실측 |

## 11. C10 조회 결과 (2026-11-16)

- 조회 시각: AS-IS 23:30:44~23:42:49, TO-BE 23:41:02~23:41:33. SELECT만 실행함
- 조회 스크립트와 원본 결과: `Doc/verify/SSP_DAILY/20261116/c10_probe.py`, `c10_asis.json`, `c10_tobe.json`
- 두 DB 공통: 오늘 20261116, SSP_PLAN_VERSION_V 하한 20261012, SSP_PLAN_VERSION_V 0행

### C1 SCP FN 버전

| 항목 | AS-IS | TO-BE |
|---|---|---|
| SCP_PLAN_VERSION_V 최신 FN | 40: 20261019 seq 2(plan_id 1466), 81: 20260817, 그 밖 12개 사업부: 20260824 | EE: 20261005, 그 밖 13개 사업부: 20261026(plan_id 1467) |
| SCP_PLN_SHIPMENT_PLAN, _PEGGING 최신 FN | EE 20261005, 그 밖 13개 20261026 | AS-IS와 같음 |
| SCP_ANL_SHIPMENT_PLAN_SEMI 최신(SHIP_PLAN_AMEND) | EE 20260817, 6개 사업부 20260831 | 12개 사업부 20260824 |
| WEEKLY 계획 최신 | 40 20261019, 그 밖 20260824 | 40·81 20261109, 그 밖 20261102 |
| DM_ETC_SETTING 실행 키 | 6개 사업부 20260831, 81_UC 20250714 | 6개 사업부 20260817, 81_UC 20250714 |
| SCP_PLN_INTERFACE_YN 20261116 FP_TARGET_YN | 14개 사업부 'Y' | 14개 사업부 'Y' |

- AS-IS는 SCP_PLN_SHIPMENT_PLAN에 20261026 FN 행이 있으나 버전 뷰에는 81이 20260817, 나머지가 20260824까지만 있음. L1 복제 원본은 버전 뷰에 있는 주차로 잡음
- DM_PLN_SHIPMENT_REQ에는 PLAN_START_YYYYMMDD 컬럼이 없음(컬럼 YYYYMMDD, ATTRIBUTE1~10). 사업부별 요청 최신 일자는 미조회

### C2 일정 행

| 테이블 | AS-IS | TO-BE |
|---|---|---|
| SSP_MST_SHIP_PLAN_SCHEDULE | 법인 11개, 최대 일자 20501231, 법인별 20261116 이후 행 8,812건 | AS-IS와 같음 |
| CONFIRM_CREATE_YN 'Y' 최신 | 20261008(GM00, HD00, HG00, MI00, ST00, WA00), 20261009(HM00, HQ00, NA00, NB00, NJ00) | AS-IS와 같음 |
| SSP_MST_SHIP_PLAN_SCHEDULE_EE | 법인 11개, 최대 일자 20501231 | AS-IS와 같음 |

- SCM_ADM_LOOKUP_MASTER_DETAIL에 LOOKUP_TYPE 'SSP_PLAN_VERSION_V' 행이 AS-IS 0건, TO-BE 0건임. 뷰가 쓰는 FN_GET_LOOKUP_VALUE('SSP_PLAN_VERSION_V','ESOC')의 원천 테이블은 미확인

### C3 룩업

| 항목 | AS-IS | TO-BE |
|---|---|---|
| IF_STOCK_CHECK 전체 | 123행 | 123행, 구성 같음 |
| PLAN_40 | 법인 3개(G180, HQ00, NJ00). AZ00 행 없음 | 같음 |
| PLAN_AUTO / 81_82 | 법인 18개 | 같음 |
| PLAN_EE / EE | 법인 19개 | 같음 |
| SEGMENT5 최신 | 20260822 | 20260822 |
| SSP_ANL_SHIP_PLAN_P 기준일 | 40 / 20260821 | 40 / 20260821 |
| AUTO_PLAN_CALL_FLAG | LGCE_FPDEV_TR 10행, ATTRIBUTE1 20261009~20261022 | PR_SSP_ANL_SHIP_PLAN_EE L268에서 참조. 원천 테이블 미조회 |

- AZ00은 PLAN_40 행이 없어 SHIP_PLAN_40 재고 확인이 0 대 0으로 통과함(L222~249)
- Packer 기준일 20260821이 전일 20261115보다 작아 PR_SSP_ANL_SHIP_PLAN_P는 진행 조건을 만족함

### C4 재고·결과 테이블 최신 일자

| 테이블 | 일자 컬럼 | AS-IS 최신(건수) | TO-BE 최신(건수) |
|---|---|---|---|
| SSP_DNM_OWMS_STOCK | CUTOFF_DATE | 20261009(44,393) | 20261009(44,393) |
| SSP_DNM_GMES_STOCK_40 | YYYYMMDD | 20260919(2,171) | 20260919(2,171) |
| SSP_DNM_GMES_STOCK_81_82 | YYYYMMDD | 20261010(1,956) | 20261010(1,956) |
| SSP_DNM_STOCK_C | CUTOFF_DATE | 2026-10-25(55,941) | 2026-09-18(1) |
| SSP_ANL_FORMATION_C | PLAN_START_YYYYMMDD | 20261010(4,379) | 20260822(1,164) |
| SSP_ANL_MES_FCS_STOCK_40_C | PLAN_START_YYYYMMDD | 20261010(2,722) | 20260822(999) |
| SSP_ANL_OWMS_STOCK_C | PLAN_START_YYYYMMDD | 20261010(24,716) | 20260822(1,670) |
| SSP_ANL_TCO_STOCK_C | PLAN_START_YYYYMMDD | 20250930(2) | 20250930(2) |
| SSP_ANL_OWMS_STOCK_C2 | CUTOFF_DATE | 20261009(43,128) | 20261009(43,128) |
| SCM_DNM_SCS_STOCK | CUTOFF_DATE | 20260821(22) | 20261009(22) |
| SCM_DNM_MES_STOCK | YYYYMMDD | 0행 | 0행 |
| SCM_DNM_STOCK_SN(LGCE_FPDEV_TR SCM_STOCK_H) | CUTOFF_DATE | 2026-09-29(59,224) | 해당 없음 |
| SSP_ANL_SHIP_PLAN_40 | PLAN_START_YYYYMMDD | 20261010(3,002,714), 12장 참조 | 20261010(3,002,739) |
| SSP_ANL_SHIP_PLAN_C | PLAN_START_YYYYMMDD | 20261009(43,590) | 20260821(46,941) |
| SSP_ANL_SHIP_PLAN_EE | PLAN_START_YYYYMMDD | 20261010(29,224) | 20261010(29,224) |
| SSP_ANL_SHIP_PLAN_P | PLAN_START_YYYYMMDD | 20261009(14,382) | 20261009(14,382) |
| SSP_ANL_SHIP_PLAN_ALL | PLAN_START_YYYYMMDD | 20260821(454) | 20261009(900) |
| SSP_ANL_SHIP_REQ_P | YYYYMMDD | 20261228(3) | 20261228(3) |
| SSP_ANL_HOLD_STOCK | PLAN_START_YYYYMMDD | 20261010(32) | 20261010(32) |
| SSP_ANL_SHIP_CONFIRM | PLAN_START_YYYYMMDD | 20261026(75) | 20261116(6) |
| SCM_MST_PLAN DAILY 최신 | PLAN_NAME | 40 20261009, 그 밖 20260830 | 20261030 |

- SSP_DNM_FP_PLAN_FROZEN, SSP_ANL_SHIP_REQ_EE는 조회 대상 일자 컬럼(CUTOFF_DATE, PLAN_START_YYYYMMDD, BASIS_YYYYMMDD, YYYYMMDD, STOCK_DATE)이 없어 미조회
- AS-IS 응답 시간: SCP_PLN_SHIPMENT_PLAN 97.3초, _PEGGING 99.7초, SSP_ANL_OWMS_STOCK_C2 59.4초. 일자별 집계 기준이며 복제 소요 시간은 미측정

### C5 표시 컬럼

- C4 대상 21개 테이블에 ATTRIBUTE15 없음. 두 DB 같음
- ATTRIBUTE10은 21개 테이블에 있음. SCM_DNM_STOCK_SN에는 없음
- 6장 표시 방법을 CREATED_BY 기준으로 고침

### C8 TO-BE 잡·객체

- ALL_SCHEDULER_JOBS에서 이름에 SSP, SCMPROD, PLAN_ID가 들어간 잡 92개가 전부 ENABLED FALSE, DISABLED임. JOB_PR_SSP_PLN_SHIP_PLAN_40·_40_AZ·_40_C·_81_82·_EE·_P, JOB_PR_SSP_ANL_SHIP_PLAN_ALL, JOB_SCMPROD_PLAN_ID_DAILY_CREATION·_WEEKLY_CREATION 포함
- 4-3 호출 대상 SP 18개 중 17개 VALID, PR_SSP_PLN_SHIP_PLAN_CUTOFF 1개 INVALID(LAST_DDL 2026-11-13 21:22)
- TO-BE PR_SSP_PLN_SHIP_PLAN_CUTOFF는 운영 조건 그대로임: L116 PLAN_START_YYYYMMDD = TO_CHAR(SYSDATE,'YYYYMMDD'), L121 CURRENT_PLAN_DATE_YN = 'N'. AS-IS 개발 DB의 고정값은 없음

### 남은 항목

| 번호 | 상태 |
|---|---|
| C6 | 개발 DB 송신 테이블 외부 전송 여부. 인터페이스 담당 확인 필요 |
| C7 | LGCE_FPDEV_TR 쓰기 허용 여부. 사용자 결정 필요 |
| C9 | SP 1회 소요 시간. 첫 실행 때 측정 |
| 추가 | TO-BE PR_SSP_PLN_SHIP_PLAN_CUTOFF INVALID 원인. 12장에서 확인함 |
| 추가 | AS-IS SSP_ANL_SHIP_PLAN_40 일자별 건수. 12장에서 확인함 |

## 12. 추가 조회 결과 (2026-11-16 23:59 ~ 2026-11-17 00:00)

### AS-IS SSP_ANL_SHIP_PLAN_40 일자별 건수

- 조회 방법: DIVISION_ID '40', PLAN_START_YYYYMMDD 일자별 COUNT. IDX02(DIVISION_ID, PLAN_START_YYYYMMDD) 사용, 일자당 0.2~2.9초
- 최신 계획일: 20261010. 20261011~20261116 행 0건

| 계획일 | 건수 |
|---|---|
| 20260925 | 25,612 |
| 20260926 | 10,983 |
| 20260927~20261008 | 25,190~27,566 |
| 20261009 | 28,148 |
| 20261010 | 3,002,714 |

- 20261009 법인별: AZ00 928, HQ00 12,276, NJ00 14,869, 법인 없음(ATTRIBUTE10 NULL) SHIP_CONFIRM 75
- 20261010 MEASURE 13종 행 수: AZ00 13종 680. HQ00 10종 105,400, SHIP_CONFIRM 109,738, SHIP_REQ 107,355, WH_IN 105,399. NJ00 11종 123,420, SHIP_CONFIRM 130,817, SHIP_REQ 128,945
- 20260925~20261009 하루 행 수의 106배임. 20261010 데이터를 만든 실행 경로는 미확인
- 40 SP 계획 상세 행(SCM_MST_PLAN_DETAIL MODELING_ID '101', PLAN_TYPE 'SP') 최신 2건:
  - 20261009: CREATED_BY 'asislive', 2026-11-15 20:08:27. 11-15 시험 행
  - 20260822: CREATED_BY 'ssp_batch', 2026-08-22 08:01:53
- 20261010 SP 계획 상세 행이 없어 20261010 데이터는 Plan date 목록에 나오지 않음
- L4 대체 복제 원본: 20261009(28,148행). 20261010은 쓰지 않음

### TO-BE PR_SSP_PLN_SHIP_PLAN_CUTOFF INVALID 원인

- ALL_ERRORS 0건. 컴파일 오류가 기록되어 있지 않음
- 참조 객체 22개 중 SCM_MGR 객체 전부 VALID
- 이 SP LAST_DDL_TIME 2026-11-13 21:22:13 이후 참조 객체 PR_SSP_ANL_SHIP_CONFIRM_BATCH_N이 2026-11-16 20:14:45에 다시 컴파일됨
- 원인: 참조 객체 재컴파일에 따른 의존 무효화. 다음 호출 때 Oracle이 자동 재컴파일하거나 ALTER PROCEDURE PR_SSP_PLN_SHIP_PLAN_CUTOFF COMPILE로 VALID가 됨. 재컴파일은 실행하지 않음
- 4-3 설계는 81/82에서 이 SP를 거치지 않고 하위 SP를 직접 호출하므로 생성 작업에는 영향 없음
