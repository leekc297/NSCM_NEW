# DM 프로세스 정리 (rev1.0) — 분석 참고

> **출처**: `Doc/ui_analysis_meet/DM 프로세스 정리_rev1.0 1.pptx` (35 슬라이드) — 전수 추출 (누락 0, run 카운트 대사)
> **한계**: 도식(그림) 9개는 텍스트만 추출 — 해당 슬라이드에 `[도식 포함]` 표기. 도식 구조는 원본 PPT 참조.
> **활용**: DM 화면/SP 분석(hook #105) 시 배치 프로시저·메저·Cut off·인터페이스 규칙의 원천 참고.

## 배치/프로시저 인벤토리 (본문 실측 전수)

- `PR_DM_ANL_KPI_SALES_ACCURACY`
- `PR_DM_ANL_KPI_SUMMARY`
- `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW`
- `PR_DM_CUTOFF_DATA_CLEANSING`
- `PR_DM_DNM_EXCHANGE_RATE_MAIL_SEND`
- `PR_DM_DNM_SALES_RESULT`
- `PR_DM_DNM_SALES_RESULT_IF`
- `PR_DM_MST_EXCHANGE_RATE_CUTOFF`
- `PR_DM_PLN_CFM_TO_MKT_FCST_ALL`
- `PR_DM_PLN_DEMANDID_PEGGING`
- `PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM`
- `PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE`
- `PR_DM_PLN_MKT_FCST_LASTEST_MEASURE`
- `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE`
- `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_BATCH`
- `PR_DM_PLN_MKT_FCST_RESULT_MOVE`
- `PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING`
- `PR_DM_PLN_MKT_FCST_TO_NET_DEMAND`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_MON_40`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_MON_82`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TOTAL_MOBILE`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_2`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_HG`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_UC`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_SCM_FCST`
- `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_TOTAL`
- `PR_DM_PLN_SALES_PLAN_CUTOFF`
- `PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE`
- `PR_DM_PLN_SALES_PLAN_RESULT_MOVE`
- `PR_DM_PLN_VERSION_CREATE`
- `PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND`
- `PR_SCM_`
- `PR_SCM_DNM_MAT_DOCUMENT`
- `PR_SCM_DNM_STOCK_SALE`
- `PR_SCM_DNM_STOCK_SALES`
- `PR_SCM_MST_CUSTOMER`
- `PR_SCM_MST_EXCHANGE_RATE`
- `PR_SCM_MST_FUTURE_PRICE_CUTOFF`
- `PR_SCM_MST_PROJECT`
- `PR_SCM_MST_PROJECTBOM`
- `PR_SCM_MST_PROJECT_DV_MASTER`
- `PR_SCM_MST_PROJECT_ITEM`
- `PR_SCM_MST_PROJECT_SCHEDULE`
- `PR_SCM_SYS_DATA_PURGE_WEEKLY`
- `PR_SCP_PLN_INTERFACE_PLAN`

## 목차

- S01. DM 프로세스 정리
- S02. 조직, 관련 시스템
- S03. 개요
- S04. DM 전체 데이터 흐름
- S05. 테이블 구조
- S06. 메져설명
- S07. 메져설명
- S08. Cut off 일정 `[도식]`
- S09. Batch – weekly rolling 정리
- S10. PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING
- S11. 배치 - Weekly Rolling
- S12. PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE
- S13. PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 실행시 패턴 `[도식]`
- S14. 배치 프로시저 - PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE
- S15. 배치 프로시저 - PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE
- S16. PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE
- S17. PR_DM_PLN_MKT_FCST_RESULT_MOVE
- S18. PR_DM_PLN_SALES_PLAN_RESULT_MOVE
- S19. ERP 매출 실적 JOB_RFC.매출 실적 정보
- S20. ERP 매출 실적 – ERP I/F 스케쥴 `[도식]`
- S21. ERP 매출 실적
- S22. 판매법인 재고 JOB_RFC.판매법인(G260) 재고
- S23. 판매법인 재고
- S24. Customer Master (Soldto, Shipto) JOB_RFC.Customer Master(Soldto, Shipto)
- S25. Customer Master (Soldto, Shipto)
- S26. 자재 입/출고 정보 JOB_RFC.DM_VMI_재고 입출고 실적
- S27. 자재 입/출고 정보
- S28. PROJECT
- S29. PR_SCM_MST_PROJECT
- S30. BPS 환율
- S31. 배치 프로시저 - PR_SCM_MST_EXCHANGE_RATE, PR_DM_DNM_EXCHANGE_RATE_MAIL_SEND
- S32. PR_DM_CUTOFF_DATA_CLEANSING
- S33. PR_DM_CUTOFF_DATA_CLEANSING
- S34. GSCM Data Purge `[도식]`
- S35. GSCM Data Purge `[도식]`

---

## S01. DM 프로세스 정리

_(텍스트 없음 — 도식/제목 전용 슬라이드)_

## S02. 조직, 관련 시스템

- DM
- 수요관리

- SCP
- 공급계획

- SSP
- 출하계획

- MKT FCST(Marketing Forecast) : 수요계획

- RTF(Return To Forecast) : 공급가능수량

- DM Sales Plan화면에서 RTF 수정값

## S03. 개요

- Sales Site
- 등록

- SSPM
- 등록

- Sales Price
- 등록

- Mkt Fcst등록

- Sales Plan
- 생성

- MF Cutoff
- 생성

- SP Cutoff
- 생성

- Sales Report
- 작성

- Biz Plan
- 등록

- BP Cutoff
- 생성

- 고객 등록

- 모델 등록

- 판가 등록

- 판매계획 등록

- 매출계획(금액) 생성

- 사업계획 등록

- BPS I/F

- NET DEMAND 생성
- (SCP 계획데이터)

- RTF 수정

- GDW I/F

- 사용자가 직접 CUTOFF 버튼 클릭

- 배치 실행

- 배치 실행

## S04. DM 전체 데이터 흐름

- DM_PLN_SALES_PLAN_REPORT_C

- DM_PLN_MKT_FCST

- DM_PLN_SALES_PLAN

- DM_PLN_MKT_FCST_C

- DM_PLN_SALES_PLAN_C

- DM_PLN_MKT_FCST_RESULT

- DM_PLN_SALES_PLAN_RESULT

- DM_PLN_MKT_FCST_RESULT_C

- DM_PLN_SALES_PLAN_RESULT_C

- ERP

- DM_PLN_BP_FCST_C

- DM_PLN_BP_FCST

- DM_PLN_SALES_ETC_REPORT_C

- GDW

- 해외법인기여매출

- DM_PLN_SALES_ETC_PLAN

- DM_PLN_SALES_ETC_PLAN_C

- DM_PLN_CFM_MKT_DEMAND_PLAN

- DM_PLN_CFM_MKT_DEMAND_PLAN_C

- XIF_BPS_SALES_PLAN_S_SN

- DM_PLN_CFM_SELLING_PRICE_C

- DM_PLN_CFM_SELLING_PRICE

- SCM_MST_FUTURE_PRICE_C

- SCM_MST_FUTURE_PRICE

- 40 사업부만 해당 FLOW 사용

- XIF_BPS_SALES_ETC_PLAN_S_SN

- XIF_BPS_METAL_LINK_PRICE_S_SN

- DM_BPS_METAL_LINK_PRICE

- DM_BPS_METAL_LINK_PRICE_C

- BPS I/F 전사업부 해당

## S05. 테이블 구조

- DM_PLN_MKT_FCST

- DM_PLN_SALES_PLAN

- DM_PLN_MKT_FCST_RESULT

- DM_PLN_SALES_PLAN_RESULT

- DM_PLN_MKT_FCST_C

- DM_PLN_SALES_PLAN_C

- DM_PLN_MKT_FCST_RESULT_C

- DM_PLN_SALES_PLAN_RESULT_C

- Current 버전 Data

- Cutoff Data

- 계획

- 실적

- 수량

- 금액

- 수량

- 금액

- DM_PLN_CFM_MKT_DEMAND_PLAN

- DM_PLN_CFM_MKT_DEMAND_PLAN_C

- 단가

- SCM_MST_FUTURE_PRICE

- SCM_MST_FUTURE_PRICE_C

- DM_PLN_CFM_SELLING_PRICE

- DM_PLN_CFM_SELLING_PRICE_C

- 40
- 사업부용

- 40
- 사업부용

## S06. 메져설명

| DB데이터 메저 | 화면표기 메져 | 설명 |
|---|---|---|
| MKT_FCST | MKT FCST[P+P] | 81, 81_JV, 82 사업부: Demnad > Demand Plan > MKT FCST 화면에서 입력<br>40 사업부: Demnad > Demand Plan > FcstPrice MGMT 화면에서 입력 |
| MKT_FCST_RP | MKT FCST[R+P] | 화면에서 만들어주는 데이터<br>계획구간: MKT FCST와 동일하게 생성함<br>실적구간: RTF와 동일하게 생성함 |
| MKT_FCST_RP_CAR | MKT FCST[R+P] CAR | MKT FCST값과 SCM_MST_SITE_ITEM 테이블의 CELL_PER_CAR 또는 CELL_PER_MODULE로 나눈값 ITEM_CLASS_NAME에 따라 어떤 값으로 나눌지 달라짐 (81, 81_JV만 사용) |
| MKT_FCST_RP_CELL | MKT FCST[R+P] CELL | MKT FCST값과 SCM_MST_SITE_ITEM 테이블의 CELL_PER_CAR 또는 CELL_PER_MODULE로 곱한값 ITEM_CLASS_NAME에 따라 어떤 값으로 곱할지 달라짐 (81, 81_JV만 사용) |
| MKT_FCST_ENERGY | MKT FCST[R+P] Energy(MWH) | MKT FCST값과 SCM_MST_ITEM_SN의 ENERGE값을 곱한 데이터 (82만 사용) |
| CUST_FCST | Cust. FCST[P+P] | EDI 통신을 통해서 들어오는 데이터로 자동 생성하는 데이터 (81, 81_JV만 사용) |
| RTF_SYS_RP | RTF[R+P] | 실적 구간의 경우 ERP에서 전송하는 데이터<br>계획 구간의 경우 SCP에서 전송받은 데이터 |
| RTF_SCP | RTF[P+P] | SCP에서 전송받은 데이터 |
| RTF |  | 화면에서는 보이지 않지만, 존재하는 RTF<br>해당 데이터는 SCP에서 사용하고 있음. |
| RTF_SYS_RP_CAR | RTF[R+P] CAR | RTF값과 SCM_MST_SITE_ITEM 테이블의 CELL_PER_CAR 로 나눈값 ITEM_CLASS_NAME에 따라 어떤식으로 표기할지 달라짐(81, 81_JV만 사용) |
| RTF_SYS_RP_CELL | RTF[R+P] CELL | RTF값과 SCM_MST_SITE_ITEM 테이블의 CELL_PER_CAR 또는 CELL_PER_MODULE로 곱한값 ITEM_CLASS_NAME에 따라 어떤 값으로 곱할지 달라짐 (81, 81_JV만 사용) |
| RTF_ENERGY | RTF[R+P] Energy(MWH) | RTF_SYS_RP값과 SCM_MST_ITEM_SN의 ENERGE값을 곱한 데이터 (82만 사용) |

## S07. 메져설명

| DB데이터 메저 | 화면표기 메져 | 설명 |
|---|---|---|
| BALANCE | Balance | MKT FCST와 RTF_SYS_RP간의 DIFF |
| VMI_In_Req | VMI-In Request[R+P] | SCP 에 만들어달라고 요청하는 수량. (82, 40 사업부만 사용)<br>81, 81_JV, 82 사업부: Demnad > Demand Plan > MKT FCST 화면에서 입력<br>40 사업부: Demnad > Demand Plan > FcstPrice MGMT 화면에서 입력 |
| VMI_In_Plan | VMI-In Plan[R+P] | SCP 에서 만들겠다고 회신한 수량. (82, 40 사업부만 사용)<br>일반 SITE 의 RTF_SCP 와 동일한 개념. |
| VMI_Inv | VMI Inv. | 해당 SITE 의 VMI 재고 (82, 40 사업부만 사용) |
| VMI_DIO | DIO | 의미는 모름. 실제 사용도 거의 안함.<br>DIO 는 보통 재고일수 또는 출발해서 목적지까지 도착하는 기간 정도로 해석함. |
| AS_In_Req | AS In Request[R+P] | SCP 에 만들어달라고 요청하는 수량. (81, 81_JV, 82사업부만 사용)<br>81, 81_JV, 82 사업부: Demnad > Demand Plan > MKT FCST 화면에서 입력 |
| AS_In_Plan | AS In Plan[R+P] | SCP 에서 만들겠다고 회신한 수량. (81, 81_JV, 82사업부만 사용)<br>일반 SITE 의 RTF_SCP 와 동일한 개념. |
| AS_Inv | AS Inv. | 해당 SITE 의 AS 재고 (81, 81_JV, 82사업부만 사용) |
| KRW | Unit Price(KRW) | 단가 * 원화 계산 |
| USD | Unit Price(USD) | 단가 * 달러 계산 |
| LOC | Unit Price(LOC) | 입력한 단가 |
| SalesAmt_KRW | Sales Amt.(KRW) | 계획구간: RTF_SCP * Unit Price(KRW)<br>실적구간: ERP에서 전송해준 금액 ( 40사업부만 예외적으로 환율로 계산 ) |
| SalesAmt_USD | Sales Amt.(USD) | 계획구간: RTF_SCP * Unit Price(USD)<br>실적구간: ERP에서 전송해준 금액 ( 40사업부만 예외적으로 환율로 계산 ) |
| SalesAmt_LOC | Sales Amt.(LOC) | 계획구간: RTF_SCP * Unit Price(LOC)<br>실적구간: ERP에서 전송해준 금액 ( 40사업부만 예외적으로 환율로 계산 ) |

## S08. Cut off 일정  `[도식 포함 — 텍스트만 추출]`

_(텍스트 없음 — 도식/제목 전용 슬라이드)_

## S09. Batch – weekly rolling 정리

- 운영 배치에 Weekly rolling 가 여러 개 걸려있는데, 하단 LIST가 MKT FCST CUTOFF / SCM FCST CUTOFF 목록

| JOB NAME | 사용 | 일정 | 단계 | 프로시저 | 파라미터 |  | 비고 |
|---|---|---|---|---|---|---|---|
| JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_MON_40 | O | 월요일 15시 | 1 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 40 | MF_W | Weekly |
| JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_MON_82 | O | 월요일 16시 | 1 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 82 | MF_W | Weekly |
| JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TOTAL_MOBILE | O | 수, 목<br>, 금, 토, 일<br>오전 12시 | 1 | PR_DM_PLN_CFM_TO_MKT_FCST_ALL | 40 |  | CFM테이블과 MKT FCST 테이블 동기화 |
|  |  |  | 2 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 40 | MF_D | Daily |
|  |  |  | 2 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81 | MF_D | Daily |
|  |  |  | 3 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_UC | MF_D | Daily |
|  |  |  | 4 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HM | MF_D | Daily |
|  |  |  | 5 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_ST | MF_D | Daily |
|  |  |  | 6 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HD | MF_D | Daily |
|  |  |  | 7 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HG | MF_D | Daily |
|  |  |  | 8 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 82 | MF_D | Daily |
| JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_2 | O | 화요일<br>오전 04시 | 1 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81 | MF_W | WEEKLY |
|  |  |  | 2 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HM | MF_W | WEEKLY |
|  |  |  | 3 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_ST | MF_W | WEEKLY |
| JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_HG | O | 화요일<br>오전 09시 | 1 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HG | MF_W | WEEKLY |
| JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_UC | O | 화요일<br>오전 10시 | 1 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_UC | MF_W | WEEKLY |
|  |  |  | 2 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HD | MF_W | WEEKLY |
| JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_SCM_FCST | O | 월요일<br>17시30분 | 1 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 40 | SF_W | WEEKLY |
| JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_TOTAL | O | 화요일<br>오전<br>12시 15분 | 1 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 82 | MF_D | Daily |
|  |  |  | 2 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 82 | MF_W | WEEKLY |
|  |  |  | 3 | PR_DM_PLN_CFM_TO_MKT_FCST_ALL | 40 |  | CFM테이블과 MKT FCST 테이블 동기화 |
|  |  |  | 4 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 40 | MF_D | Daily |
|  |  |  | 5 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81 | MF_D | Daily |
|  |  |  | 6 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_UC | MF_D | Daily |
|  |  |  | 7 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HM | MF_D | Daily |
|  |  |  | 8 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_ST | MF_D | Daily |
|  |  |  | 9 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HD | MF_D | Daily |
|  |  |  | 10 | PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING | 81_HG | MF_D | Daily |

## S10. PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING

- 배치 - Weekly Rolling

- DM_PLN_MKT_FCST

- DM_PLN_MKT_FCST_C

- YYYYMMDD >= 당주 월요일

- DM_PLN_MKT_FCST_RESULT

- DM_PLN_MKT_FCST_RESULT_C

- 당주 월요일 기준 54주 전 데이터 ~ 당주월요일 -1

- 컷오프 종류: MF_W (MKT FCST WEEKLY CUTOFF)
- SF_W (SCM FCST WEEKLY CUTOFF [40사업부만 존재])
- MF_D (MKT FCST DAILY CUT0FF)

- DM_PLN_CFM_MKT_DEMAND_PLAN

- DM_PLN_CFM_MKT_DEMAND_PLAN_C

- 40 사업부전용 테이블이지만,
- 모든 사업부가 다 사용함
- Sales Plan Cutoff 시

- PR_DM_PLN_VERSION_CREATE

- DM_MST_VERSION

- IF @p_ver_type =  ‘MF_W’ AND @v_division_id = ‘40’

- DM_PLN_MKT_FCST

- Measure: SCM FCST 당주 월요일 이후 데이터 삭제 후 MKT FCST 메져로 재생성

- DM_PLN_CFM_MKT_DEMAND_PLAN

- Measure: SCM FCST 당주 월요일 이후 데이터 삭제 후 MKT FCST 메져로 재생성

- PR_SCM_MST_FUTURE_PRICE_CUTOFF

- 프로시져 실행시 전달받은 Type으로 버전을 생성하며, 타입명+날짜+SEQ 형태로 버전이 생성된다.

- IF @v_division_id = ‘40’

- SCM_MST_FUTURE_PRICE

- SCM_MST_FUTURE_PRICE_C

- YYYYMMDD >= 당주 월요일

- DM_PLN_CFM_SELLING_PRICE

- DM_PLN_CFM_SELLING_PRICE_C

- MKT FCST  CUTOFF 된 데이터에 대해서만 생성한다.

- 40 사업부전용 테이블

- 해당 작업을 40 사업부만 하는 이유는, 40 사업부는 타 사업부와 다르게
- MKT FCST 데이터 생성 시 MKT FCST AMT를 생성한다.
- 하여, 해당 시점의 단가와 환율값을 보관한다.

## S11. 배치 - Weekly Rolling

- 프로시저

- 테이블

- PR_DM_PLN_MKT_FCST_LASTEST_MEASURE

- PR_DM_PLN_MKT_FCST_TO_NET_DEMAND

- PR_DM_PLN_DEMANDID_PEGGING

- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE

- PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW

- 전주의 MKT FCST 데이터를 MKT_FCST_LATEST로 생성

- Net Demand 생성 SCP에서 사용하는 계획데이터

- Current 버전에 Sales Plan 생성

- VMI 메저 정리 및 SCP 리턴값을 CURRENT 버전에 적용

- PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM

- ELSE

- PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING

- IF @p_ver_type <> ‘MF_M’

- IF @p_ver_type = ‘MF_W’ OR @p_ver_type = ‘SF_W’

- 사용하는 곳은 모르겠으나, 생성은 계속함 우선 SCP는 사용하지 않는다고함

- IF @p_ver_type = ‘MF_W’

- PR_DM_PLN_SALES_PLAN_CUTOFF (‘SP_D’)

- MKT FCST CUTOFF 실적과 SALES PLAN CUTOFF 실적의 DIFF를 없애기 위해 SP_D로 CUTOFF

- PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND

- MKT FCST CUTOFF 완료 내역 메일링

## S12. PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE

- 배치 - Weekly Rolling

- 프로시저

- 테이블

- PR_DM_PLN_VERSION_CREATE

- Sales Plan Weekly Cutoff 전용

- PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW

- Sales Plan Weekly 버전번호 생성

- Current 버전에 Sales Plan 생성

- PR_SCM_MST_FUTURE_PRICE_CUTOFF

- PR_DM_MST_EXCHANGE_RATE_CUTOFF

- 판가 Cut off

- 환율 Cut off

- DM_PLN_CFM_MKT_DEMAND_PLAN_C

- DM_PLN_SALES_PLAN_C

- MKT FCST CUTOFF의 가장 마지막 버전의 데이터를 가지고와
- 금액 메저 다시 계산함 ( SALES PLAN 을 그대로 CUTOFF 하지 않음 )

- DM_PLN_SALES_PLAN_RESULT_C

- DM_PLN_SALES_PLAN_RESULT_C

- 월요일밤 12시 ( MF CUTOFF 시점 ) 의 실적을 SALES PLAN CUTOFF에
- 담아야 하므로, 월요일 버전의 SP_D 버전의 데이터를 복사함

- DM_PLN_MKT_FCST_C

- 40 사업부

- 40 사업부 외 타사업부
- DM_PLN_MKT_FCST_C : RTF 메져, AMT 메져 외 데이터
- DM_PLN_CFM_MKT_DEMAND_PLAN_C : RTF 메져, AMT 메져 데이터

- DM_PLN_SALES_ETC_PLAN_C

- DM_PLN_SALES_ETC_PLAN_C

## S13. PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 실행시 패턴  `[도식 포함 — 텍스트만 추출]`

- 패턴이 4개가 있음.
- Description 이 Call 로 끝나면서 정각에 돌아가는 경우
- Description 이 Call 로 끝나지만 아무때나 돌아가는 경우
- Description 이  숫자로 끝나는데, start 와 end 에 모두 값이 들어가는 경우
- Description 이  숫자로 끝나는데, end 에만 값이 들어가는 경우

- 1번 : 배치가 호출함- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_BATCH

- 2번 : mkt fcst save 프로시저가 호출함 - DMF0003_SAVE_MKT_FCST
- 3번 : scp 에서 plan 끝난 후에 호출함 - PR_SCP_PLN_INTERFACE_PLAN
- 4번 : Daily Cutoff 하면서 호출함 - PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING ( @plan_id = null )

## S14. 배치 프로시저 - PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE

- 역할 : SCP 리턴값을 CURRENT 버전에 적용
- Call 인 경우: Balance 메저를 만들어서 MKT_FCST 에 넣어준다.
- Call 이 아닌 경우 : 1) SCP_ALLOC 을 읽어서 MKT_FCST에 INSERT2) Balance 메저 생성3) Current 버전에 대해 Sales Amt 만드는 프로시저 호출 (PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW )4) PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 호출 ( CUTOFF 등등 ) – CUTOFF 버전에 대해서 거의 동일한 역할 수행함.
- 1. plan_id 값이 있는경우는 SCP에서 호출받은 경우임
- 2.  NULL  : 주1회 WEEKLY ROLLING 작업시 호출받은 경우임 (SP: PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING)
- 3. 'CALL' : MKT_FCST값 저장시 특정대상만 전달받으며 호출된 경우임 (SP: DMF0003_SAVE_MKT_FCST)

## S15. 배치 프로시저 - PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE

- Call 이 아닌 경우
- #T_results 에 SCP_Alloc 값과 MKT_FCST 의 MKT_FCST, RTF, Balance 메저를 넣는다 ( RMA 제외 )
- Dm_pln_mkt_fcst 에서 RTF_SYS_RP, RTF_SCP, VMI_IN_Plan 메저 삭제 ( RMA 제외 )
- Dm_pln_mkt_fcst 에서 RTF_SYS_RP, RTF_SCP메저 삭제 ( 소형 RMA 만)
- #T_MKT_FCST_INSERT 에 다음 내용을 넣는다.1) SCP_Alloc 의 값 (  Vmi 이면 VMI_In_Plan 메저로, 아니면 RTF_SCP 메저로 )2) DM_PLN_MKT_FCST 의 VMI_In_Req 또는 MKT_FCST 메저
- DM_PLN_MKT_FCST 에 #T_MKT_FCST_INSERT 값을 넣는다. ( RTF_SCP 는 RTF_SYS_RP 로 한 번 더 넣는다. )
- 소형 RMA 에 대해서 DM_PLN_MKT_FCST 의 MKT_FCST 값을 RTF_SYS_RP 로 넣는다.
- VMI 처리
- Balance 메저 생성
- PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 호출

## S16. PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE

- DM_MST_VERSION 에서 SCP PLAN DATE 이후의 MF_W 버전들을 모두 커서로 돌려서각 버전들에 대해 아래 처리 수행
- DM_PLN_MKT_FCST_C 에서 'RTF_SYS_RP','RTF_SCP','VMI_In_Plan‘ 메저 삭제
- #T2_MKT_FCST_INSERT 에 1) VMI_IN_PLAN , RTF_SCP 메저 삽입 ( FROM SCP_ALLOC)2) VMI_IN_REQ  VMI_IN_PLAN, MKT_FCST  RTF_SCP 로 바꿔서 삽입(FROM MKT_FCST_C)3) 소형 RMA 의 경우 MKT_FCST 메저 삽입 ( FROM MKT_FCST_C )
- #T2_MKT_FCST_INSERT 의 모든 값을 MKT_FCST_C 에 인서트 ( RTF_SCP 는 RTF_SYS_RP 로 한 번 더 )
- VMI 처리
- BALANCE 처리

## S17. PR_DM_PLN_MKT_FCST_RESULT_MOVE

- 배치 - Weekly Rolling – MKT FCST Result Move

- DM_PLN_MKT_FCST

- DM_PLN_MKT_FCST_RESULT

- 지지난 월요일 <= YYYYMMDD < 지난(금주) 월요일

- DM_PLN_MKT_FCST_RESULT

- DM_PLN_MKT_FCST_RESULT

- RTF, VMI 관련 메저 생성 및 이동

- RTF  RTF_Sytem[R+P]

- 지지난 월요일 <= YYYYMMDD < 지난(금주) 월요일

- _Result 테이블에는 P+P 메저는 생성되지 않는데, 조회화면에서 P+P 메저와 R+P 메저를 같이 조회할 때
- 같은 기간이라도 메저에 따라 실적테이블과 계획테이블을 나눠서 조회해야 하는 문제를 해결하기 위해서
- P+P 성격의 메저를 실적테이블에 생성해주는 역할 수행

## S18. PR_DM_PLN_SALES_PLAN_RESULT_MOVE

- 배치 - Weekly Rolling

- DM_PLN_SALES_PLAN

- DM_PLN_SALES_PLAN_RESULT

- YYYYMMDD Beween  1년전 부터 지난(금주) 월요일

- Mkt FCST, Cust Fcst, RTF System[R+P], TMM Fcst 메저를 Plan 테이블에서 Result 테이블로 복사

- RTF  RTF_Sytem[R+P]

## S19. ERP 매출 실적 JOB_RFC.매출 실적 정보

| 인터페이스 명 |  | 매출 정보 |
|---|---|---|
| 인터페이스 아이디 |  | ZSDOM_GSCM_SALES_RESULT |
| 송신 | 시스템 | ERP ( SD ) |
|  | PGM-ID | ZSDOM_GSCM_SALES_RESULT |
|  | 방식 | RFC |
| 수신 | I/F TABLE | XIF_ERP_SALES_RESULT_R |
|  | PGM-ID | PR_DM_DNM_SALES_RESULT_IF<br>PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING |
|  | 본테이블 | DM_DNM_SALES_RESULT_IF |
| 담당 |  | DM 전용 |
|  |  |  |

## S20. ERP 매출 실적 – ERP I/F 스케쥴  `[도식 포함 — 텍스트만 추출]`

_(텍스트 없음 — 도식/제목 전용 슬라이드)_

## S21. ERP 매출 실적

- XIF_ERP_SALES_RESULT_R_SN

- PR_DM_DNM_SALES_RESULT_IF

- 실제 DM 실적테이블에 데이터 적재하는 프로시져
- 적재 진행여부는 룩업: RESULT_MAPPING_SCHEDULE로 확인한다.

- DM_DNM_SALES_RESULT_IF

- 현재 일자가 1일인 경우 전전월 1일부터 삭제 후 생성
- 나머지의 경우 전월 1일부터 삭제 후 재생성

- PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING

- DM_PLN_MKT_FCST_RESULT

- DM_PLN_SALES_PLAN_RESULT

- PR_DM_ANL_KPI_SALES_ACCURACY

- PR_DM_ANL_KPI_SUMMARY

- JOB_RFC.매출 실적 정보

- JOB.PR_DM_DNM_SALES_RESULT

- ※ 40 사업부의 경우에는 실적데이터로 받은 AMT를 사용하지 않고,
- ERP 데이터 보관 후 환율 정보로 재계산 진행 ※

- ※ERP에서 데이터를 준대로 그대로 받는다 ※

## S22. 판매법인 재고 JOB_RFC.판매법인(G260) 재고

| 인터페이스 명 |  | 판매법인(G260) 재고 |
|---|---|---|
| 인터페이스 아이디 |  | ZSDMD_RFC_SCM_SALESCORP_STOCK |
| 송신 | 시스템 | ERP(SD) |
|  | PGM-ID | ZSDMD_RFC_SCM_SALESCORP_STOCK |
|  | 방식 | RFC |
| 수신 | I/F TABLE | XIF_ERP_SALES_STOCK_R |
|  | PGM-ID | PR_SCM_DNM_STOCK_SALES |
|  | 본테이블 | SCM_DNM_STOCK_SALES |
| 담당 |  | DM 전용 |

## S23. 판매법인 재고

- JOB_RFC.판매법인(G260) 재고

- XIF_ERP_SALES_STOCK_R_SN

- JOB.PR_SCM_DNM_STOCK_SALES

- PR_SCM_DNM_STOCK_SALE

- SCM_DNM_STOCK_SALES

- 82 사업부의 경우 AS INV / VMI INV 생성시 재고 데이터 체크하는 재고 테이블
- 실적 데이터 생성 시 사용

## S24. Customer Master (Soldto, Shipto) JOB_RFC.Customer Master(Soldto, Shipto)

| 인터페이스 명 |  | Customer Master (Soldto, Shipto) |
|---|---|---|
| 인터페이스 아이디 |  | ZSDMD_RFC_SCM_CUSTOMER |
| 송신 | 시스템 | ERP(SD) |
|  | PGM-ID | ZSDMD_RFC_SCM_CUSTOMER |
|  | 방식 | RFC |
| 수신 | I/F TABLE | XIF_ERP_CUSTOMER_R |
|  | PGM-ID | PR_SCM_MST_CUSTOMER |
|  | 본테이블 | SCM_MST_CUSTOMER |
| 담당 |  | DM 전용은 아님. ( 다른 모듈들도 사용함 )<br>SALES SITE 와의 연관성때문인지 DM 에서 관리함. |

## S25. Customer Master (Soldto, Shipto)

- Sales Site 등록시 사용 ( Shipto / Soldto )

- JOB_RFC.Customer Master(Soldto, Shipto)

- XIF_ERP_CUSTOMER_R_SN

- JOB.PR_SCM_MST_CUSTOMER

- PR_SCM_MST_CUSTOMER

- SCM_MST_CUSTOMER

## S26. 자재 입/출고 정보 JOB_RFC.DM_VMI_재고 입출고 실적

| 인터페이스 명 |  | DM MAT DOCUMENT (자재 입/출고 정보) |
|---|---|---|
| 인터페이스 아이디 |  | ZMMIF_GSCM_MAT_DOCUMENT |
| 송신 | 시스템 | ERP(MM) |
|  | PGM-ID | ZMMIF_GSCM_MAT_DOCUMENT |
|  | 방식 | RFC |
| 수신 | I/F TABLE | XIF_ERP_MATERIAL_DOCUMENT_DM_R |
|  | PGM-ID | PR_SCM_DNM_MAT_DOCUMENT |
|  | 본테이블 | SCM_DNM_MAT_DOCUMENT |
| 담당 |  | DM 전용 |

## S27. 자재 입/출고 정보

- 실적 데이터 생성 시
- 40사업부 재고 VMI 생성 데이터

- JOB_RFC.DM_VMI_재고 입출고 실적

- XIF_ERP_MATERIAL_DOCUMENT_DM_R

- PR_SCM_DNM_MAT_DOCUMENT

- SCM_DNM_MAT_DOCUMENT

- SCM_DNM_MAT_DOCUMENT_H

- PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING

- 테이블 활용

## S28. PROJECT

| 인터페이스 명 |  | PROJECT |
|---|---|---|
| 인터페이스 아이디 |  | OPLM_OFP0_PLM_PJT_BPMS, OPLM_OFP0_PLM_DV_MASTER, OPLM_OFP0_PLM_MODEL, OPLM_OFP0_PLM_SCH |
| 송신 | 시스템 | PLM, BPMS |
|  | PGM-ID | OPLM_OFP0_PLM_PJT_BPMS, OPLM_OFP0_PLM_DV_MASTER, OPLM_OFP0_PLM_MODEL, OPLM_OFP0_PLM_SCH |
|  | 방식 | SAP PI |
| 수신 | I/F TABLE | XIF_PLM_PJT_BPMS_R, XIF_PLM_PJT_DV_MASTER_R, XIF_PLM_PJT_MODEL_MASTER_R, XIF_PLM_PJT_MODEL_QUANTITY_R, XIF_PLM_PJT_SCHEDULE_R |
|  | PGM-ID | PR_SCM_MST_PROJECT |
|  | 본테이블 | SCM_MST_PROJECT<br>SCM_MST_PROJECT_MAPPING<br>SCM_MST_PROJECT_ITEM<br>SCM_MST_PROJECT_SCHEDULE |
| 담당 |  | 공통이지만 DM 이 관리함 |
| 비고 |  | 인터페이스목록에 있는 System Project 모델 소요량 (OPLM_OFP0_PLM_SYSPJT_MODEL_QUANTITY) 은 2020년 2월까지 실행 후 실행이력이 없음. |

- 4개의 I/F 가 하나의 수신 프로시저에 묶여있음.

## S29. PR_SCM_MST_PROJECT

- (JOB. PR_SCM_MST_PROJECT)

- 배치 프로시저 - PR_SCM_MST_PROJECT – 개발/운영이 달라서 운영기준으로 동기화(2020/7/22)

- SCM_MST_PROJECT

- PR_SCM_MST_PROJECT_DV_MASTER

- SCM_MST_PROJECT_MAPPING

- SCM_MST_PROJECT_MODEL_DEMAND_QTY

- SCM_MST_PROJECT_ITEM

- PR_SCM_MST_PROJECT_SCHEDULE

- PR_SCM_MST_PROJECTBOM

- SCM_MST_PROJECT_SCHEDULE

- PR_SCM_MST_PROJECT_ITEM

- xif_plm_pjt_bpms_r_sn

- xif_plm_pjt_dv_master_r_sn

- gplm_mapping_yn = ‘Y’

- attr_15 = ‘Y’

- xif_plm_pjt_model_master_r_sn

- attr_10 = ‘Y’

- xif_plm_pjt_schedule_r_sn

- XIF_BPMS_PROJECTBOM_ESS_R_SN
- XIF_BPMS_PROJECTBOM_AUTO_R_SN

- SCM_MST_SITE_ITEM

- BPMS_EXIST = ‘Y’

- OPLM_OFP0_PLM_PJT_BPMS

- OPLM_OFP0_PLM_DV_MASTER

- OPLM_OFP0_PLM_MODEL

- 자동차 : BPS0111
- ESS : BPS0114
- 매시 정각 및 30분에 데이터 생성하고
- XIF 테이블에는 약 20분 정도 후에 수신됨
- 모델정보는 bpms 에서 바로 받음.

- Gplm 에서 개발프로젝트가 만들어져야
- IF 됨 ( 샘플코드 등록 등..)

## S30. BPS 환율

| 인터페이스 명 |  | EnSemble 환율 |
|---|---|---|
| 인터페이스 아이디 |  |  |
| 송신 | 시스템 | BPS ( 구 EnSemble ) |
|  | PGM-ID |  |
|  | 방식 | ETL |
| 수신 | I/F TABLE | XIF_GSC_MOVE_EXCHANGE_RATE_SN |
|  | PGM-ID | PR_SCM_MST_EXCHANGE_RATE |
|  | 본테이블 | DM_MST_EXCHANGE_RATE |
| 담당 |  | 백계성 책임 |
| 비고 |  | 화학 경영관리팀 – 엔솔 경영관리팀에서 환율 공지<br>EnSemble 에 등록, EnSemble 에서 GSCM 으로 송신 ( 경영관리팀 )<br>GSCM 에서 수신<br>GSCM I/F 테이블에서 본테이블로 복사<br>매일 2회 12시 23시 |

## S31. 배치 프로시저 - PR_SCM_MST_EXCHANGE_RATE, PR_DM_DNM_EXCHANGE_RATE_MAIL_SEND

- XIF_GSC_MOVE_EXCHANGE_RATE_SN
- ( I/F 수신테이블 )

- 매일 12:00, 23:00
- 신규 데이터 수신여부 확인해서 있을 경우 DM 환율테이블로 전송

- DM 환율테이블로 전송
- Price 업데이트

- 수요일 23:40
- 현재 환율정보의 수신 시점을 알려주는 메일 발송

- BPS에서 알아서 넣어줌 ETL 방식

- JOB. PR_SCM_MST_EXCHANGE_RATE

- PR_SCM_MST_EXCHANGE_RATE

- DM_MST_EXCHANGE_RATE

- PR_DM_DNM_EXCHANGE_RATE_MAIL_SEND

- JOB.PR_DM_DNM_EXCHANGE_RATE_MAIL_SEND

## S32. PR_DM_CUTOFF_DATA_CLEANSING

- PR_DM_CUTOFF_DATA_CLEANSING DM 컷오프 데이터 삭제 및 보관테이블 이동처리
- ( 컷오프 데이터들이 대상임 )
- Daily Cutoff Data 는 2주 보관 후 삭제함
- Weekly Cutoff Data 는 1년(54주) 보관 후 _KEEP 테이블로 이동하고 원본테이블에서는 삭제함
- Version Table 의 Attr 필드에 표시를 하는 이유는 DM 관리목적도 있지만 GSCM 의 데이터를 읽어가는 시스템( Data Lake )에 가져갈 대상을 알려주려는 목적도 있어서 임의로 변경하면 안됨

- _C
- 테이블

- PR_DM_CUTOFF_DATA_CLEANSING

- _C_KEEP
- 테이블

- Version
- 테이블

## S33. PR_DM_CUTOFF_DATA_CLEANSING

- PR_DM_CUTOFF_DATA_CLEANSING DM 컷오프 데이터 삭제 및 보관테이블 이동처리
- ( 컷오프 데이터들이 대상임 )
- Daily Cutoff Data 는 2주 보관 후 삭제함
- Weekly Cutoff Data 는 1년(54주) 보관 후 _KEEP 테이블로 이동하고 원본테이블에서는 삭제함
- Version Table 의 Attr 필드에 표시를 하는 이유는 DM 관리목적도 있지만 GSCM 의 데이터를 읽어가는 시스템( Data Lake )에 가져갈 대상을 알려주려는 목적도 있어서 임의로 변경하면 안됨

| 테이블 | 버전유형 | 처리방법 | 보관기간 | Version Table 표시 |
|---|---|---|---|---|
| DM_PLN_MKT_FCST_C | Daily | 삭제 | 2주 |  |
| DM_PLN_SALES_PLAN_C | Daily | 삭제 | 2주 |  |
| DM_PLN_MKT_FCST_RESULT_C | Daily | 삭제 | 2주 |  |
| DM_PLN_SALES_PLAN_RESULT_C | Daily | 삭제 | 2주 |  |
| SCM_MST_FUTURE_PRICE_C | Daily | 삭제 | 2주 |  |
| DM_MST_EXCHANGE_RATE_C | Daily | 삭제 | 2주 |  |
| DM_PLN_MKT_FCST_C | Weekly | 이동 | 54주 | ATTRIBUTE1 |
| DM_PLN_MKT_FCST_RESULT_C | Weekly | 이동 | 54주 | ATTRIBUTE2 |
| DM_PLN_SALES_PLAN_C | Weekly | 이동 | 54주 | ATTRIBUTE1 |
| DM_PLN_SALES_PLAN_RESULT_C | Weekly | 이동 | 54주 | ATTRIBUTE2 |
| DM_PLN_BP_FCST_C | Manual | 이동 | 54주 | ATTRIBUTE1 |
| SCM_MST_FUTURE_PRICE_C | Weekly | 이동 | 54주 | ATTRIBUTE3 |
| DM_ANL_KPI_SUMMARY |  | 삭제 | 27주 |  |
| DM_ANL_KPI_SALES_ACCURACY |  | 삭제 | 27주 |  |
| DM_PLN_DEMANDID_PEGGING |  | 삭제 | 14주 |  |
| DM_PLN_NET_DEMAND |  | 삭제 | 14주 |  |
| DM_PLN_SALES_PLAN_REPORT_C | Manual | 이동 | 18개월 | ATTRIBUTE3 |

## S34. GSCM Data Purge  `[도식 포함 — 텍스트만 추출]`

- GSCM 전체적으로 적용되는 데이터 삭제 프로시저 ( 프로시저 : PR_SCM_SYS_DATA_PURGE_WEEKLY)
- 주로 인터페이스 테이블과 같이 별도 보관정책이 없고, 삭제는 필요한 테이블들이 대상임

- Batch Job 에 아래와 같이 걸려있음

## S35. GSCM Data Purge  `[도식 포함 — 텍스트만 추출]`

- 해당 프로시저가 아래 룩업을 읽어서 매주 삭제작업 진행
