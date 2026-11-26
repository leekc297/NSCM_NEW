# DMF0082 81 Weekly 지난 주차 Unit Price(KRW) = LOC 값, Unit Price(USD) 빈칸 원인 (사내 ZIOUI1, 2026-11-23 조회)

## 화면 값 출처
- 조회 주차 이전 구간(W45, W46)은 단가를 원장에서 읽지 않고 실적으로 계산함. PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DRV1 구간, AS-IS DMF0082_GET_MAIN_DATA L2337 과 같음.
  - Unit Price(LOC) = 실적 MKT_AMT_LOC 합 / RTF_SYS_RP 합
  - Unit Price(KRW) = 실적 MKT_AMT_KRW 합 / RTF_SYS_RP 합
  - Unit Price(USD) 는 지난 구간에서 계산하지 않음. AS-IS 도 LOC, KRW 두 메저만 만듦.
- 실적 원천 DM_PLN_SALES_PLAN_RESULT. 적재 배치 PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING 이 ERP 매출실적 DM_DNM_SALES_RESULT_IF 의 SALES_AMOUNT_FOR → MKT_AMT_LOC, SALES_AMOUNT_SUM → MKT_AMT_KRW 로 옮김.
- 환율 재계산(당월 1일 이후 KRW = LOC × 월 환율)은 Division 40 만 수행함. AS-IS 원문 주석 "40 사업부만 진행함" 과 같음. 81, 82 는 ERP 원화 금액을 그대로 씀.

## 사내 DB 실측
DM_DNM_SALES_RESULT_IF USD 행 중 SALES_AMOUNT_SUM(원화) = SALES_AMOUNT_FOR(외화) 인 건수
| Division | 2026-08 | 2026-09 | 2026-10 |
|---|---|---|---|
| 81 | 0 / 1,040 | 0 / 923 | 39 / 280 |
| 81_HG | 0 / 61 | 0 / 58 | 21 / 21 |
| 81_UC | 0 / 4 | 0 / 8 | 116 / 116 |
| 82 | 0 / 2,541 | 2 / 2,130 | 623 / 667 |

- 같은 행이 DM_PLN_SALES_PLAN_RESULT 에 MKT_AMT_KRW = MKT_AMT_LOC 로 적재됨(81 USD 35키 20261001~20261021, 82 USD 170키 20260911~20261012).
- 월 환율 DM_MST_EXCHANGE_RATE 81·82 USD→KRW 는 202607~202612 있음(202610~202612 1,340). 화면 W48 KRW 1,142,926.200 / LOC 852.930 = 1,340 으로 일치함.

## AS-IS 개발 DB 실측 (LGCE_SCMDEV, 2026-11-23)
- DM_DNM_SALES_RESULT_IF USD 행 원화 = 외화 건수: 81 202610 39 / 280, 82 202609 2 / 2,130, 82 202610 623 / 667. 202606~202608 0건. 사내 DB 와 건수 같음.

## 81 예시 (사내 실적, KRW 금액 = LOC 금액 행)
| 프로젝트 | Site | 품목 | 일자 | MKT_AMT_LOC | MKT_AMT_KRW | RTF | LOC 단가 | KRW 단가(화면) | KRW 단가(환율 1,340 적용 시) |
|---|---|---|---|---|---|---|---|---|---|
| A20TY4001 | TY_US_VDH | AMTYTTNGA-A1-070 | 20261021 | 1,442,390.4 | 1,442,390.4 | 660 | 2,185.440 | 2,185.440 | 2,928,489.600 |
| A15FD5002 | Ford_MX_TPZ | AMFMCC727-F1-021 | 20261012 | 691,944.66 | 691,944.66 | 627 | 1,103.580 | 1,103.580 | 1,478,797.200 |

- AS-IS 개발 DB 실적 테이블(202608 까지 적재)에도 같은 행 있음: 81 213행 중 55행, 82 274행 중 225행이 KRW 금액 = LOC 금액.
- Division 40 은 당월 환율 재계산 단계가 있어 같은 현상 없음(40 MIP474586B11 20261010: KRW 267,574,014 / RTF 52,410 = 5,105.400, AS-IS 캡처와 같음).

## 판정
- 원인: ERP 매출실적 수신분 중 최근 월 USD 행의 원화 금액이 환산되지 않고 외화 금액과 같은 값으로 들어옴. 81·82 는 배치가 환율로 다시 계산하지 않아 KRW 단가 = LOC 단가로 표시됨.
- USD 빈칸은 AS-IS 와 같은 동작임.
- 화면 조회 SP, 적재 배치는 AS-IS 와 같은 로직임. 프로그램 결함 아님.
- 첨부 화면(2026-11 W45, W46)의 서버 데이터는 사내 DB 에 없음(사내 81 실적은 20261021 까지). 같은 현상은 사내 2026-10 실적에서 확인함.

## 추가 확인 (2026-11-23)
### AS-IS 81·82 원화 환율 처리
- 실적 적재 PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING, Sales Price 배치 PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 의 환율 재계산은 Division 40 만 수행함. 81·82 는 ERP 가 보낸 원화 금액을 그대로 씀.
- 수신 PR_DM_DNM_SALES_RESULT_IF 원화 금액 선택: COMPANY_ID 가 룩업 COMPANY_ID(AU00, G540) 이고 SHIPTO 가 SHIPTO_CODE_01 이 아니면 DOC_AMT_KRW, COMPANY_ID 가 COMPANY_ID_HQ(HQ00, C100) 가 아니면 SALES_AMOUNT_SUM, 그 외 DOC_AMT_KRW. 룩업 SCM_CODE_LOOKUP_VALUE LOOKUP_TYPE_CODE='PR_DM_DNM_SALES_RESULT_IF'.

### ERP 원본 XIF_ERP_SALES_RESULT_R_SN (AS-IS 개발 DB) USD 행 SALES_AMOUNT_SUM = SALES_AMOUNT_FOR 건수
| COMPANY_ID | 2026-08 | 2026-09 | 2026-10 |
|---|---|---|---|
| MI00 | 0 / 1,710 | 1,160 / 5,045 | 1,328 / 1,328 |
| GM00 | 0 / 486 | 438 / 1,763 | 1,028 / 1,028 |
| HD00 | 0 / 380 | 340 / 1,260 | 429 / 429 |
| ST00 | 0 / 696 | 592 / 2,262 | 572 / 572 |
| VT00 | 0 / 1,594 | 786 / 3,611 | 676 / 676 |
| HQ00 | 0 / 1,656 | 0 / 3,453 | 0 / 663 |

### 배치 Job
| 순서 | AS-IS SQL Agent | TO-BE DBMS_SCHEDULER | 실행 |
|---|---|---|---|
| 1 | JOB_RFC.매출 실적 정보 (04:40, 07:00, 19:00, 23:00, 월 13:00) | JOB_RFC_XIF_ERP_SALES_RESULT_R | PR_SCM_SYS_RFC_CALL_NERP('XIF_ERP_SALES_RESULT_R') |
| 2 | JOB.PR_DM_DNM_SALES_RESULT (05:00, 07:20, 19:10, 23:10, 월 13:10) | JOB_PR_DM_DNM_SALES_RESULT | PR_DM_DNM_SALES_RESULT_IF → 끝에서 PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING 호출 |
- AS-IS 개발 DB, 사내 TO-BE 의 두 Job 은 사용 안 함(enabled 0 / DISABLED) 상태임.

## MI00 원화 금액 선택 단계 (2026-11-23)
- 원화 금액을 고르는 곳은 ERP 수신 프로시저 PR_DM_DNM_SALES_RESULT_IF 한 곳임. AS-IS 원문 L1647~1659, L1756~1768(두 INSERT 블록, 같은 식), TO-BE L618~625.
- MI00 은 룩업 COMPANY_ID(AU00, G540) 에도, COMPANY_ID_HQ(HQ00, C100) 에도 없어 SALES_AMOUNT_SUM 을 씀. 기간(실적구간, 당월) 조건은 없음. 실적구간만 DOC_AMT_KRW 를 쓰는 규칙은 AS-IS, TO-BE 어디에도 없음.
- 이후 단계(PR_DM_DNM_SALES_RESULT 집계, PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING 적재)는 SALES_AMOUNT_SUM 을 합산만 하고 바꾸지 않음.

### XIF_ERP_SALES_RESULT_R_SN MI00 USD 행 (AS-IS 개발 DB)
| 매출월 | 행수 | SALES_AMOUNT_SUM ÷ SALES_AMOUNT_FOR | DOC_AMT_KRW ÷ DOC_AMT_FOR | TRANSFER_DATE |
|---|---|---|---|---|
| 2026-08 | 1,710 | 1,406.3 (단일값) | 1,370.3 ~ 1,433.6 | 20260929 |
| 2026-09 | 5,045 | 1.0 (1,160행), 1,359.0 (나머지) | 1,337.9 ~ 1,384.3 | 20260929 ~ 20261027 |
| 2026-10 | 1,328 | 1.0 (1,328행) | 1,338.0 ~ 1,359.6 | 20261013 ~ 20261027 |

- 같은 전표가 10-13, 10-14, 10-27 수신분에 반복해서 들어왔고 세 번 다 SALES_AMOUNT_SUM = SALES_AMOUNT_FOR 임. 예: 20261021 수량 408, FOR 891,659.52, SUM 891,659.52, DOC_AMT_KRW 1,193,040,438.
- 판정: 수신 이후 단계에는 환율 로직이 없음. 10월분 원화 미환산은 XIF 테이블 SALES_AMOUNT_SUM 값 문제임. 같은 행의 DOC_AMT_KRW 는 환산되어 있음.
- 미확인: ERP 가 월 마감 뒤 SALES_AMOUNT_SUM 을 환산값으로 다시 보내는지(8월분은 환산, 9월분은 일부, 10월분은 미환산).
