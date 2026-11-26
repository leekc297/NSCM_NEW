# DMF0082 BIZ-03-2 단가 0.000 확인 결과 (사내 ZIOUI1, 2026-11-22 13:37 조회)

## 확인 방법
- Division 40 조회 원천: 수량 DM_PLN_CFM_MKT_DEMAND_PLAN, 단가 DM_PLN_CFM_SELLING_PRICE (PKG_DMF0082 P_DMF0082_GET_MAIN_DATA A2·A7 구간)
- 수량 키(PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, DOM_EXP, INCOTERMS)와 같은 키의 LOC 단가 유무 대조: `b2_202704_key_check.sql`

## 2027년 4월 NT·Greenway 계획 수량 19키 중 단가 없는 키 4건
| 프로젝트 | Site | 품목 | INCOTERMS | MKT_FCST | 단가 원장 상태 |
|---|---|---|---|---|---|
| NT | NT_CN_HUI | MIF519664A11 | DDP | 10,000 | SCM_MST_FUTURE_PRICE 단가가 20270329 까지만 있음. 4월 단가 미등록 |
| GREENWAY LEV | Greenway_CN_DGG | MCCM348014A3 | CIF | 120,000 | 단가는 DAP 로만 등록(CNY 10) |
| Greenway | Greenway Dongguan_CN_DGG | MCCH350040A1-000 | DAP | 150,000 | 단가는 CIF 로만 등록(USD 2.52) |
| Greenway | Greenway_CN_DGG | MCCM356015A2 | DAP | 140,000 | 단가는 프로젝트 GREENWAY LEV 로만 등록(CNY 11.062, USD 1.58) |

## 판정
- 단가 0.000 현상은 사실임. 원인은 단가 원장에 계획 수량과 같은 키의 단가 행이 없음.
- 통화 센티널 원인(BIZ-03-1 종속) 아님. Division 40 2026-11 이후 단가 행 통화값: CFM_SELLING_PRICE, FUTURE_PRICE 모두 CNY·EUR·INR·JPY·KRW·USD 만 있음. '/'·공백 0건.
- AS-IS DMF0082_GET_MAIN_DATA L2060 도 DM_PLN_CFM_SELLING_PRICE 를 같은 키로 읽고 대체 단가가 없음. TO-BE 동작이 AS-IS 와 같음.
- 프로그램 결함 아님. 패키지 수정 없음. 단가 값은 영업 담당이 정할 값이라 DB 에 임의 입력하지 않음.
- 보고서의 GREENWAY LEV 22,500 은 사내 DB 에서 같은 값 미확인. 사내 GREENWAY LEV 4월 수량은 320,000, 120,000, 640,000 임.

## 조치 안내
- 위 4키는 Batch Price Input 또는 LOC 셀 수정으로 단가를 등록하면 다음 확정 배치 뒤 조회에 반영됨.
- 월별 단가 없는 키 건수: `b1_unpriced_keys_by_month.sql` (2027-04 날짜 기준 190키 중 21키, 수량 4,093,271 / 289,732,949)
