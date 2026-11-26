# 사업부별 Shipment Plan 산출 흐름 — 2026-11-23 13:44 생성

> 원천(사용자 제공 2026-11-11 · 사본 `Doc/asisfacts/ref_ssp/src/`): `(20261111) 사업부별 Shipment Plan 산출 흐름도.pptx`(슬라이드 10) · `(20261111) 사업부별 Shipment Plan 산출 로직.xlsx`(요약 · 산출 흐름 · 단계별 상세 · 기준정보 설정). 생성 = `tools/Analysis/ssp_shipplan.py`
> 자료 기준 = SCP FINAL → 출하요청 → 사업부별 일 산출(40 · 81·82 · 전극 · Packer) → 확정 · ERP 송신 — TO-BE(Oracle) 본문에서 정리한 산출 로직이다. 문구는 원문 그대로 옮겼고, AS-IS SP 본문과의 대조는 §7 에 따로 적었다.

## 1. 전체 흐름 : SCP FINAL 에서 확정 · ERP 송신까지

<div class="spf "><div class="spf-row"><div class="spf-card " style="--c:#5B6770"><div class="spf-h">SCP FINAL 확정</div><ul><li>PLAN_TYPE = 'FN'</li><li>PR_SCP_PLN_INTERFACE_PLAN</li><li>SCP I/F Blocking(FP_TARGET_YN = 'N')이면 요청 생성 생략</li></ul></div><div class="spf-ar">▶</div><div class="spf-col" style="--c:#1F7A8C"><div class="spf-h">출하요청 생성</div><div class="spf-sub"><b>SEMI 요청</b><span>DM_PLN_SHIPMENT_REQ (PLANT)</span></div><div class="spf-sub"><b>FG 요청</b><span>DM_PLN_SHIPMENT_REQ (SALES)</span></div><div class="spf-sub"><b>Packer 요청</b><span>SSP_ANL_SHIP_REQ_P</span></div><div class="spf-sub"><b>전극 요청(주 1회)</b><span>SSP_ANL_SHIP_REQ_EE</span></div></div><div class="spf-ar">▶</div><div class="spf-col" style="--c:#3A6EA5"><div class="spf-h">사업부별 일 산출</div><div class="spf-sub" data-k="DIV:DIV_40"><b>40</b><span>SSP_ANL_SHIP_PLAN_40</span></div><div class="spf-sub" data-k="DIV:DIV_8X"><b>81 계열 · 82</b><span>SSP_ANL_SHIP_PLAN_C</span></div><div class="spf-sub" data-k="DIV:DIV_P"><b>Packer</b><span>SSP_ANL_SHIP_PLAN_P</span></div><div class="spf-sub" data-k="DIV:DIV_EE"><b>전극</b><span>SSP_ANL_SHIP_PLAN_EE</span></div></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">확정 · ERP 송신</div><ul><li>SSP_ANL_SHIP_CONFIRM (CHANGE_TYPE 'C')</li><li>XIF_ERP_SHIP_PLAN_CONFIRM_S_SN</li><li>Packer : XIF_ERP_PACK_SHIP_PLAN_S_SN · XIF_SCS_PACK_SHIP_PLAN_S_SN</li><li>확정 행은 다음 날 산출에 다시 읽힘(Rolling)</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#0B3C49"><div class="spf-h">통합</div><ul><li>PR_SSP_ANL_SHIP_PLAN_ALL</li><li>SSP_ANL_SHIP_PLAN_ALL</li><li>화면 SSP0012 · SSP0019 로 건수 확인</li></ul></div></div><div class="spf-roll"><i style="left:calc(((100% - 120px) / 5 + 30px) * 2 + ((100% - 120px) / 5) / 2);width:calc(((100% - 120px) / 5 + 30px) * 1)"></i><span style="left:calc(((100% - 120px) / 5 + 30px) * 2 + ((100% - 120px) / 5) / 2);width:calc(((100% - 120px) / 5 + 30px) * 1)">↺ Rolling — 확정 행은 다음 날 산출에 다시 읽힘</span></div><div class="spf-note" style="--c:#D98E2B"><b class="t">수량 결정 원칙</b><b>출하계획 수량 = 확정구간 안은 출하확정 + 확정구간 이후는 출하요청</b><span>재고(ERP · MES · OWMS) · 생산계획은 WH_STOCK · BALANCE(재고 부족 여부) 계산에만 사용. 예외 : 82 FP 자동생성 대상 Pack 품목은 생산 기반으로 수량 산정</span></div></div>

- 「사업부별 일 산출」의 사업부 상자(40 · 81 계열·82 · Packer · 전극)를 클릭하면 §4 의 해당 사업부 산출 흐름이 열립니다.

## 2. 요약 — 산출 단위 · Operation Group · 수량 결정 · 실적 차감 · Rolling · 재고 · 생산

| 구분 | 내용 |
|---|---|
| 질문 | 통합테스트 문서 기준으로 사업부별 · Operation Group 별 Shipment Plan 산출 상세 로직 (Request 산출 → 실적 차감 → 전주 확정 Rolling → 재고 조달 → 전극 생산 조달 → 사업부별 산출, 단계별 테이블 · 조건) |
| 근거 | ZIOUI1 현재 본문(2026-11-11 재조회) 19개 프로시저 · 함수 2개 · 기준정보 조회값. 상세는 「산출 흐름」 · 「단계별 상세」 · 「기준정보 설정」 시트 |
| 답 1. 산출 단위 | 사업부마다 프로그램 · 결과 테이블 · 주기가 다름<br/>- 40(소형) : 법인별(HQ00 · AZ00 · NJ00) 1일 1회 → SSP_ANL_SHIP_PLAN_40<br/>- 81 계열 · 82 : 법인별 일 마감(10분 주기, 진입 조건 충족 시 1회) → SSP_ANL_SHIP_PLAN_C<br/>- 전극 : 법인별(10분 주기, 시업시간 · 재고 수신 충족 시 1회) → SSP_ANL_SHIP_PLAN_EE<br/>- Packer(40 외주 Pack) : 1일 1회(07:15) → SSP_ANL_SHIP_PLAN_P |
| 답 2. Operation Group | SCM_MST_SITE.OPERATION_GROUP : A = Cell, P = Pack · Module, E = Electrode, W = A/S(Warranty). OSP_YN = 'Y' 는 외주(Packer) 사이트<br/>- Request 산출 대상 : SEMI(반제품) 는 From 사이트 A(외주 제외) · 40 의 P(외주 제외) · 82 의 P 전체, FG(제품) 는 40 = A 만 · 81·82 = 전체, Packer 는 40 의 P 외주 사이트, 전극은 E<br/>- 확정구간 일수 : 사이트 SHIP_FROZEN(일) 또는 ATTRIBUTE6 = 'W n' 이면 (n+1)×7 − 요일차(월 = 0) |
| 답 3. 수량 결정 원칙 | 출하계획 수량 = 확정구간 안은 출하확정(SSP_ANL_SHIP_CONFIRM, CHANGE_TYPE = 'C'), 확정구간 이후는 출하요청<br/>- 재고(ERP · MES · OWMS) · 생산계획은 출하계획 수량을 정하지 않고 WH_STOCK · BALANCE(가용 재고, 부족 여부) 계산에만 사용<br/>- 예외 : 82 의 FP 자동생성 대상(룩업 FP_AUTO_SHIP_FROM_TO 3건, Pack 품목)만 「전일 재고 + 생산 × (100 − RATE)%」 를 Lot 단위로 내림한 값이 출하계획 수량 |
| 답 4. 실적 차감 | 40 · 81·82 · Packer 는 출하 실적으로 출하요청을 차감하는 단계 없음. 출하된 수량은 CUTOFF 재고(BOH)에 이미 빠진 상태로 반영<br/>- 확정구간에 들어온 요청은 하루 한 번 확정으로 바뀌고 확정 표시(81·82 : SSP_ANL_SHIP_PLAN_C.CONFIRM_FLAG = 'Y', 40 : DM_PLN_SHIPMENT_REQ.ATTRIBUTE10 = 확정 ID, 전극 : SSP_ANL_SHIP_REQ_EE.CONFIRM_FLAG = 'Y', Packer : SSP_ANL_SHIP_REQ_P.CONFIRM_ID)가 붙어 다시 확정되지 않음<br/>- 전극만 출하 실적(SSP_DNM_SHIP_RESULT_OWMS_V)을 사용 : 전주 월요일 ~ 전전일 구간의 출고 메저를 실적으로, 그 이후를 확정으로 채워 재고 계산 |
| 답 5. 전주 확정 Rolling | 확정 테이블 SSP_ANL_SHIP_CONFIRM 이 날짜를 넘어 유지되고, 매일 산출 시 확정구간 안의 확정 행을 다시 읽어 출하계획(SHIP_PLAN / SHIP_CONFIRM / P_SHIP_PLAN_SIMU_ETD 메저)에 그대로 넣음. 화면 · 변경요청 승인으로 바뀐 확정 수량도 같은 테이블에서 반영 |
| 답 6. 재고 조달 | - 81·82 : 기초재고 = GMES 가용(Lot − OQC 불량 − QMS · MES Hold) + ESS Packer 재고 + OWMS 가용. ERP 재고(SCM_DNM_STOCK_V)는 진입 조건 확인에만 사용<br/>- 40 : 기초재고 = MES/FCS 가용 + OWMS 가용 + TCO 외주 재고(B100 · R100) − Hold<br/>- 전극 : 기초재고 = 전극 MES + 원자재 창고(IWMS) + 전극 창고(OWMS), 조립 ↔ 전극 플랜트 매핑 적용<br/>- Packer : 기초재고 = SCS 재고(SCM_DNM_SCS_STOCK) |
| 답 7. 전극 생산 조달 | 전극 출하계획 수량(P_SHIP_PLAN_SIMU_ETD)은 확정 + 출하요청(사용자 시뮬레이션 저장값 우선). FP Pancake 시뮬레이션 생산계획(Coater · Notching 소요)은 재고 시뮬레이션 P_INV_SIM · P_INV_CONFIRM 계산에 들어가 재고 부족 여부를 표시<br/>- P_INV_SIM(익일) = P_INV_SIM(전일) + Coater 계획(전일) + 입고 예정(당일) − Notching 소요(당일) − 출하계획(당일) |
| 확인 필요 1 | 81·82 기초재고의 OWMS 는 SSP_ANL_OWMS_STOCK_C2.CUTOFF_DATE = 기준일 − 1 행을 읽음. 같은 실행이 만든 C2 행은 CUTOFF_DATE = 기준일이라 OWMS 만 하루 앞 재고가 들어감(GMES 는 기준일). AS-IS 원문과 같은지 대조 필요<br/>확인 SQL : SELECT CUTOFF_DATE, PLAN_START_YYYYMMDD, COUNT(*) FROM SSP_ANL_OWMS_STOCK_C2 GROUP BY CUTOFF_DATE, PLAN_START_YYYYMMDD ORDER BY CUTOFF_DATE DESC |
| 확인 필요 2 | 82 FP 자동생성 산정의 이동계획(INTN_MOVEMENT) 차감 조인 조건이 PP.MEASURE = 'INTN_MOVEMENT' 로 되어 있어 이동 수량이 항상 0. 변환본 주석에 원문 동작 그대로라고 기록됨 |
| 실행 상태 | TO-BE 잡 JOB_PR_SSP_PLN_SHIP_PLAN_40 · _AZ · _C · _81_82 · _EE · _P 모두 DISABLED. 산출 프로시저는 모두 VALID(ESS 확정 PR_SSP_ANL_ESS_SHIP_CONFIRM · PR_SSP_ANL_ESS_PLAN_CUTOFF 는 INVALID) |

## 3. 단계 × 사업부 비교

### 3-1. 산출 흐름(엑셀 「산출 흐름」 시트)

| 단계 | 40 (소형 · Cell / Pack) | 81 계열 · 82 (자동차 · ESS) | 전극 (EE) | Packer (40 외주 Pack) |
|---|---|---|---|---|
| 0. 실행 · 진입 조건 | 잡 08:00(HQ00) · 10:30(AZ00) · 11:00(NJ00)<br/>오늘 SSP_ANL_SHIP_PLAN_40 에 SHIP_CONFIRM 행(ATTRIBUTE10 = 법인) 없음 + IF_STOCK_CHECK(PLAN_40, MES_F · MES_W · OWMS) 법인 행 전부 SEGMENT5 = 오늘 · ATTRIBUTE1 = 'Y' | 잡 05:07 ~ 23:57 10분 주기<br/>SSP_MST_SHIP_PLAN_SCHEDULE 오늘 행 CURRENT_PLAN_DATE_YN = 'N' + SCM_DNM_STOCK_V 전일 INVENTORY 1건 이상 + IF_STOCK_CHECK(PLAN_AUTO, MES_W · OWMS) 법인 행 전부 오늘 · 'Y' | 잡 10분 주기<br/>SSP_MST_SHIP_PLAN_SCHEDULE_EE 오늘 행 'N' + FP 룩업 AUTO_PLAN_CALL_FLAG ATTRIBUTE1 = 오늘(FP MES 실적 수신 완료) + 시업시간(BASIS_START_TIME_PLANT) + IF_STOCK_CHECK(PLAN_EE, IWMS · MES · OWMS) 법인 행 전부 SEGMENT5 = 오늘 | 잡 07:15<br/>기준일(오늘 − 1)이 룩업 SSP_ANL_SHIP_PLAN_P.ATTRIBUTE1(현재 20260821) 보다 뒤일 때만 수행 |
| 1. Shipment Request 산출 (SCP FINAL) | SCP FN 확정 연계 시<br/>SEMI : SCP_ANL_SHIPMENT_PLAN_SEMI → DM_PLN_SHIPMENT_REQ(PLANT)<br/>FG : SCP_OPT_SHIPMENT_PLAN(_PEGGING)_V, OPERATION_GROUP = 'A' → DM_PLN_SHIPMENT_REQ(SALES)<br/>+ Pack 요청 SSP_ANL_SHIP_PLAN_PACK_REQ | SCP FN 확정 연계 시<br/>SEMI · FG 모두 DM_PLN_SHIPMENT_REQ (81_UC 는 FG 미생성)<br/>82 는 Pack(P) 사이트 SEMI 도 생성 | 일 산출 1-5 단계에서 주 1회(새 EE FN 계획 버전일 때)<br/>SCP_ANL_SHIPMENT_PLAN_SEMI · SCP_OPT(OPERATION_GROUP = 'E') → SSP_ANL_SHIP_REQ_EE (작성자 'SCP FN Plan', ETA 기준) | SCP FN 확정 연계(40) 시<br/>SCP_OPT, From 사이트 OPERATION_GROUP = 'P' · OSP_YN = 'Y' → SSP_ANL_SHIP_REQ_P |
| 2. 출하 실적 차감 | 차감 단계 없음. 출하분은 OWMS · MES CUTOFF 재고에 반영<br/>확정된 요청은 ATTRIBUTE10 = 확정 ID 로 표시해 재확정 방지 | 차감 단계 없음. 출하분은 CUTOFF 재고에 반영<br/>확정된 요청은 SSP_ANL_SHIP_PLAN_C.CONFIRM_FLAG = 'Y', 확정 못 한 요청은 'D' | 출고 메저 과거 구간(전주 월요일 ~ 전전일) = OWMS 출하 실적(SSP_DNM_SHIP_RESULT_OWMS_V), 이후 = 확정<br/>확정된 요청은 SSP_ANL_SHIP_REQ_EE.CONFIRM_FLAG = 'Y' | 차감 단계 없음<br/>확정된 요청은 SSP_ANL_SHIP_REQ_P.CONFIRM_ID 기록 |
| 3. 전주 확정 Rolling | SHIP_CONFIRM 메저 = 확정(CHANGE_TYPE = 'C', 전일 ~ +84일, Electrode 제외) + 확정구간 이후 미확정 요청<br/>신규 확정 : 출하일 = 오늘 + SHIP_FROZEN − 1 하루분, 전일 BALANCE 음수 일자 제외 | SHIP_PLAN 메저 = 확정구간 : 확정(CHANGE_TYPE = 'C') / 이후 : 출하요청<br/>신규 확정 : 출하일 ≤ 전일 + 확정구간 일수인 미확정 요청 전부(Lot 분할) | P_SHIP_PLAN_SIMU_ETD = 확정(전주 월요일 ~ +56일) + 요청(ETD ≥ 오늘 − 1 + 확정구간 일수, 미확정). 사용자 시뮬레이션 저장값(SSP_ANL_SHIP_PLAN_SIMU_EE) 있으면 그 값<br/>신규 확정 : 미확정 요청 중 ETD 가 확정구간 안인 것 | SHIP_CONFIRM 메저 = 확정 + 확정구간 이후 요청(≥ 기준일 + SHIP_FROZEN, 기본 7)<br/>신규 확정 : 출하일 = 오늘 + SHIP_FROZEN − 1 |
| 4. 재고 조달 (기초재고 · 재고 흐름) | 기초 = MES/FCS 가용(SSP_ANL_MES_FCS_STOCK_40_C) + OWMS 가용(SSP_ANL_OWMS_STOCK_C) + TCO(SSP_ANL_TCO_STOCK_C) − Hold(SSP_ANL_HOLD_STOCK)<br/>익일 WH_STOCK = 전일 WH_STOCK + 전일 WH_IN − 전일 SHIP_CONFIRM − 전일 POSTP_PLAN − 전일 Hold + 전일 Release | 기초 = GMES 가용(SSP_DNM_GMES_STOCK_81_82) + ESS Packer(SSP_DNM_ESS_PACKER_STOCK_V) + OWMS 가용(SSP_ANL_OWMS_STOCK_C2)<br/>WH_STOCK(d) = 기초 + Σ(d 이전 PROD_PLAN − SHIP_PLAN − INTN_MOVEMENT) | 기초 = 전극 MES(SSP_DNM_GMES_STOCK_EE) + IWMS(SSP_DNM_IWMS_STOCK_EE) + OWMS(SSP_DNM_OWMS_STOCK_EE) → SSP_ANL_STOCK_EE_C → SSP_ANL_BOH_CUTOFF_EE | 기초 = SCM_DNM_SCS_STOCK<br/>WH_STOCK = 기초 + Σ(PROD_PLAN − SHIP_CONFIRM) |
| 5. 생산 조달 | PROD_PLAN = 조립 · 모듈 · Pouch 실적 + FP 확정 계획 + 외주 계획, 생산일 + 활성화 L/T, × 수율<br/>WH_IN = PROD_PLAN − 해당 Lot OWMS 재고(사용자 입력 시 유지) | PROD_PLAN = FP 확정 생산계획(SSP_DNM_FP_PLAN_FROZEN) + 82 ESS Packer 계획 + A/S 입고<br/>82 FP 자동생성 대상만 생산 기반 출하계획 산정 | FP Pancake 시뮬레이션 계획(Coater · Coater+Post Yield · Notching 소요) + 입고 예정(SSP_DNM_FP_MRP_INTRANSIT_SN) + SCP 목표<br/>P_INV_SIM · P_INV_CONFIRM · R_INV_* 재고 시뮬레이션에 사용 | PROD_PLAN = SCS 생산계획(SCM_DNM_SCS_PROD_PLAN) |
| 6. 결과 생성 | SSP_ANL_SHIP_PLAN_40 (PLAN_TYPE 'SP', 오늘 ~ +84일) → 확정 SSP_ANL_SHIP_CONFIRM · ERP 송신 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN<br/>화면 SSP0015 | SSP_ANL_SHIP_PLAN_C (기준일 = 전일, +56일) → 확정 SSP_ANL_SHIP_CONFIRM · XIF_ERP_SHIP_PLAN_CONFIRM_S_SN · 경로 SSP_ANL_SHIP_CONFIRM_ROUTE<br/>화면 SSP0021 · SSP0060 | SSP_ANL_SHIP_PLAN_EE (당일분 + CUTOFF분) → 확정 SSP_ANL_SHIP_CONFIRM · XIF_ERP_SHIP_PLAN_CONFIRM_S_SN<br/>화면 SSP0023 | SSP_ANL_SHIP_PLAN_P (기준일 = 오늘 − 1, +56일) → 확정 SSP_ANL_SHIP_CONFIRM · XIF_ERP_PACK_SHIP_PLAN_S_SN · XIF_SCS_PACK_SHIP_PLAN_S_SN<br/>화면 SSP0026 · SSP0015 |

### 3-2. 단계별 사업부 비교(흐름도 9번 슬라이드)

| 단계 | 40 | 81 계열 · 82 | 전극 | Packer |
|---|---|---|---|---|
| 출하 실적 차감 | 없음(재고에 반영) | 없음(재고에 반영) | 전주 월 ~ 전전일 OWMS 실적 | 없음 |
| Rolling | 확정 + 확정구간 이후 요청 | 확정구간 = 확정 / 이후 = 요청 | 확정 + 요청(시뮬레이션 우선) | 확정 + 요청 |
| 신규 확정 대상 | 오늘 + 확정구간 − 1 하루분 | 확정구간 안 미확정 전부 | ETD 확정구간 안 미확정 | 오늘 + 확정구간 − 1 |
| 기초재고 | MES/FCS + OWMS + TCO − Hold | GMES + ESS Packer + OWMS | MES + IWMS + OWMS | SCS 재고 |
| 생산 반영 | WH_IN(재고 흐름) | PROD_PLAN(재고 흐름) · 82 FP 자동생성은 수량 | 재고 시뮬레이션 | PROD_PLAN(재고 흐름) |
| 결과 테이블 | SSP_ANL_SHIP_PLAN_40 | SSP_ANL_SHIP_PLAN_C | SSP_ANL_SHIP_PLAN_EE | SSP_ANL_SHIP_PLAN_P |

## 4. 사업부별 산출 흐름

- 카드 = 흐름도 슬라이드의 단계(번호 순서대로 진행) · 표 = 엑셀 「단계별 상세」의 같은 사업부 행(프로그램 · 원천 · 대상 · 조건 · 산식)

### SCP FINAL 확정 연계 → 출하요청 산출(공통)

- Operation Group 별 출하요청 대상 · 확정구간 — SCM_MST_SITE.OPERATION_GROUP(From 사이트 기준) · OSP_YN = 'Y' 는 외주 사이트

| Operation Group | SEMI 요청 | FG 요청 | Packer 요청 | 전극 요청 |
|---|---|---|---|---|
| A · Cell | 40 · 81 · 82 (외주 제외) | 40 = A 만 · 81 · 82 전체 | - | - |
| P · Pack · Module | 40 (외주 제외) · 82 전체 | 81 · 82 | - | - |
| P · Pack 외주(OSP) | 82 | - | 40 | - |
| E · Electrode | - | - | - | SCP 반제품 계획 중 E |
| W · A/S | To 사이트 제외 | A/S 판매처는 PLANT 요청으로 전환 | - | - |

<div class="spf "><div class="spf-grid" style="--n:2"><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">확정구간 일수</div><ul><li>사이트 SHIP_FROZEN (일 단위)</li><li>ATTRIBUTE6 = 'W n' 이면 (n + 1) × 7 − 요일차(월 = 0)</li><li>40 : 0 ~ 21일 · 81 : 11 ~ 14일(W1 포함) · 82 : W1(14일) · 외주 Pack 40 = 3일</li></ul></div><div class="spf-card " style="--c:#1F7A8C"><div class="spf-h">요청 보존 기간(사용자 수정 유지)</div><ul><li>확정구간 ~ + 보존일수 : 사용자 수정분 유지, 시스템 생성분만 다시 생성</li><li>보존 기간 이후 : 전부 삭제 후 다시 생성</li><li>40 = 7 · 81 계열 = 10 · 82 = 0 · 전극 = 7일</li></ul></div></div></div>

- SEMI : SCP_ANL_SHIPMENT_PLAN_SEMI(SHIP_PLAN_AMEND) · FG · Packer : SCP_OPT_SHIPMENT_PLAN_V + PEGGING_V(SHIP_PLAN, SEMI_YN 'N') · 81_UC 는 FG 미생성

**단계별 상세 — [공통] SCP FINAL 확정 연계 → Shipment Request 산출**

| 사업부 | 단계 | 처리 | 프로그램 | 원천 테이블 | 대상 테이블 · 메저 | 조건 | 산식 · 비고 |
|---|---|---|---|---|---|---|---|
| 40 · 81 계열 · 82 | 1 | 확정 연계 호출 | PR_SCP_PLN_INTERFACE_PLAN | SCM_MST_PLAN · SCM_MST_PLAN_DETAIL · SCP_PLN_INTERFACE_YN | 하위 호출 : SEMI · Packer · FG 선적요청 | PLAN_TYPE = 'FN'. SEMI 는 사업부 ATTRIBUTE3 <> 'EE', Packer 는 40, FG 는 전 사업부(내부에서 81_UC · 비대상 제외) | SCP_PLN_INTERFACE_YN.FP_TARGET_YN = 'N'(SCP I/F Blocking) 이면 SEMI · FG · Packer 생성 생략 |
| 40 · 81 계열 · 82 | 1 | 반제품(SEMI) 선적요청 삭제 | PR_SSP_ANL_SHIP_REQ_SEMI | DM_PLN_SHIPMENT_REQ · SCM_MST_SITE · SCM_ADM_LOOKUP_MASTER_DETAIL(DM_SHIP_OW_FROZEN) | DM_PLN_SHIPMENT_REQ (MEASURE = 'SHIP_REQ') 삭제 | 출하일 ≥ 계획시작일 + SHIP_FROZEN(기본 10) 중<br/>① ~ + 보존일수(DM_SHIP_OW_FROZEN) 구간 : LAST_UPDATED_BY 가 SCM_BATCH · SCP_BATCH · SYSTEM 인 행<br/>② 보존 구간 이후 전부 ③ QTY = 0 | 보존일수 : 40 = 7, 81 계열 = 10, 82 = 0 |
| 40 · 81 계열 · 82 | 1 | 반제품(SEMI) 선적요청 생성 | PR_SSP_ANL_SHIP_REQ_SEMI | SCP_ANL_SHIPMENT_PLAN_SEMI · SCP_MST_BOD_N_V · SCM_MST_SITE | DM_PLN_SHIPMENT_REQ (SITE_TYPE = 'PLANT', 작성자 scm_batch) + DM_PLN_SHIPMENT_REQ_H | MEASURE = 'SHIP_PLAN_AMEND', 해당 FN 버전(계획시작일 · SEQ), QTY > 0<br/>From 사이트 : (OPERATION_GROUP = 'A' AND OSP_YN = 'N') OR (= 'P' AND 사업부 40 AND OSP_YN = 'N') OR (= 'P' AND 사업부 82)<br/>To 사이트 : OPERATION_GROUP <> 'W', From · To PLANT_ID 다름<br/>출하일 ≥ 계획시작일 + SHIP_FROZEN, ≤ 오늘 + 70일, 같은 키 기존 요청 없음, 룩업 제외 경로(G382-A:G388-P · G184-A:CN003035-P) 제외 | 출하일 = BOD.SEGMENT3 = 'A' 이면 계획일, 아니면 계획일 + BEFORE_LT |
| 40 · 81 · 82 (81_UC 제외) | 1 | 제품(FG) 선적요청 삭제 · 생성 | PR_SSP_ANL_SHIP_REQ_FG | SCP_OPT_SHIPMENT_PLAN_V · SCP_OPT_SHIPMENT_PLAN_PEGGING_V · SCP_MST_BOD_N_V · SCM_SYS_CALENDAR_M | DM_PLN_SHIPMENT_REQ (SITE_TYPE = 'SALES', ATTRIBUTE1 = 'N', 작성자 System) | MEASURE = 'SHIP_PLAN', SEMI_YN = 'N', 40 은 OPERATION_GROUP = 'A' 만, 수량 = Pegging ALLOCATION_QTY(FCST_TYPE · PROJECT_CODE 단위)<br/>같은 계획시작일 1회(룩업 DM_ETC_SETTING · PLAN_START_YYYYMMDD_<사업부>), To 사이트 ATTRIBUTE2 = 'Y'(자동생성), To 가 A/S(W) SALES 면 제외<br/>출하일 ≥ 81·82 : 전일 + 확정구간 일수 / 40 : 오늘 + SHIP_FROZEN, < 오늘 + 63일, 같은 키(QTY <> 0) 기존 요청 없음 | 삭제 : 확정구간 이후 ~ + 보존일수는 ATTRIBUTE1 = 'N' 만, 이후 전부, QTY = 0. 81·82 주 단위(ATTRIBUTE6 'W') 사이트는 미수정분 추가 삭제 |
| 40 · 81 · 82 | 1 | A/S(Warranty) 선적요청 | PR_SSP_ANL_SHIP_REQ_FG | 룩업 AS_SITE_PLANT · DM_PLN_MKT_FCST | DM_PLN_SHIPMENT_REQ (PLANT / SALES) | ① FG 의 To 가 A/S SALES(W) 이면 AS_SITE_PLANT 로 A/S PLANT 로 바꿔 SITE_TYPE = 'PLANT' 생성(확정구간 이후, 10주 이내)<br/>② From 이 A/S PLANT(W) 인 MKT_FCST 를 ETD(FN_GET_SSP_ETD_DATE) 로 바꿔 SALES 요청 생성(확정구간 이후, 8주 + 7일) |  |
| Packer (40) | 1 | Packer 선적요청 삭제 · 생성 | PR_SSP_ANL_SHIP_REQ_P | SCP_OPT_SHIPMENT_PLAN_V · _PEGGING_V · SCM_MST_SITE · SCP_MST_BOD_N_V | SSP_ANL_SHIP_REQ_P (REQUEST_ID = 'R' + 일자 + 6자리) | MEASURE = 'SHIP_PLAN', SEMI_YN = 'N', OPERATION_GROUP = 'P', From 사이트 OSP_YN = 'Y' · OPERATION_GROUP = 'P', To SITE_TYPE = 'SALES'<br/>출하일 ≥ 오늘 + SHIP_FROZEN, < 오늘 + 63일, To ATTRIBUTE2 = 'Y', QTY > 0, 같은 키 없음 | 품번 12번째 자리를 From 사이트 PACKER_ITEM_ID_SUFFIX 로 치환. 삭제 규칙은 FG 와 같음(미수정 = System · SSP_BATCH) |

### 40 소형 : 법인별 1일 1회

- 잡 HQ00 08:00 · AZ00 10:30 · NJ00 11:00 → 결과 SSP_ANL_SHIP_PLAN_40 (화면 SSP0015)

<div class="spf "><div class="spf-row"><div class="spf-card " style="--c:#5B6770"><div class="spf-h">1. 진입 조건</div><ul><li>오늘 SSP_ANL_SHIP_PLAN_40 SHIP_CONFIRM 행(법인) 없음</li><li>IF_STOCK_CHECK PLAN_40 (MES_F · MES_W · OWMS) 전부 오늘 · 'Y'</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">2. 전일 확정 변경 반영</div><ul><li>PR_SSP_ANL_SHIP_PLAN_40_BALANCE (HQ00 잡만)</li><li>확정 수량이 바뀐 날짜부터 BOH · BALANCE 재계산</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">3. 신규 확정</div><ul><li>원천 DM_PLN_SHIPMENT_REQ (ATTRIBUTE10 NULL · QTY ≥ 1)</li><li>출하일 = 오늘 + SHIP_FROZEN − 1 하루분</li><li>전일 BALANCE 음수 일자 제외</li><li>→ SSP_ANL_SHIP_CONFIRM · XIF_ERP_SHIP_PLAN_CONFIRM_S_SN</li></ul></div></div><div class="spf-snake" style="--n:3"><i></i><u></u></div><div class="spf-row"><div class="spf-card " style="--c:#3A6EA5"><div class="spf-h">4. 재고 CUTOFF</div><ul><li>OWMS → SSP_ANL_OWMS_STOCK_C</li><li>TCO(B100 · R100) → SSP_ANL_TCO_STOCK_C</li><li>MES/FCS → SSP_ANL_MES_FCS_STOCK_40_C</li><li>Hold 이월 SSP_ANL_HOLD_STOCK</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#4E8F4A"><div class="spf-h">5. 메저 생성</div><ul><li>SHIP_REQ : 요청(전일 ~ +84일)</li><li>SHIP_CONFIRM : 확정 + 확정구간 이후 미확정 요청</li><li>PROD_PLAN : 실적 + FP 계획, + 활성화 L/T, × 수율</li><li>WH_IN = 생산 − Lot OWMS 재고</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#0B3C49"><div class="spf-h">6. 재고 계산 · 적재</div><ul><li>당일 WH_STOCK = MES/FCS + OWMS + TCO − Hold</li><li>익일 = 전일 + WH_IN − SHIP_CONFIRM − POSTP − Hold + Release</li><li>BALANCE = WH − SHIP_CONFIRM − POSTP</li><li>→ SSP_ANL_SHIP_PLAN_40</li></ul></div></div><div class="spf-leg"><span style="--c:#5B6770"><i></i>진입 조건</span><span style="--c:#1F7A8C"><i></i>출하요청</span><span style="--c:#D98E2B"><i></i>확정 · Rolling</span><span style="--c:#3A6EA5"><i></i>재고</span><span style="--c:#4E8F4A"><i></i>생산</span><span style="--c:#0B3C49"><i></i>결과 · 송신</span></div></div>

**단계별 상세 — [40] 소형 — PR_SSP_ANL_SHIP_PLAN_40_BALANCE → PR_SSP_ANL_SHIP_CONFIRM_BATCH_40 → PR_SSP_ANL_SHIP_PLAN_40 (법인별)**

| 사업부 | 단계 | 처리 | 프로그램 | 원천 테이블 | 대상 테이블 · 메저 | 조건 | 산식 · 비고 |
|---|---|---|---|---|---|---|---|
| 40 | 0 | 진입 조건 | PR_SSP_ANL_SHIP_PLAN_40 | SSP_ANL_SHIP_PLAN_40 · 룩업 IF_STOCK_CHECK | - | 오늘(PLAN_START_YYYYMMDD) SHIP_CONFIRM 행(ATTRIBUTE10 = 법인) 없음 AND IF_STOCK_CHECK SEGMENT1 = 'PLAN_40' · 법인 행 전부 SEGMENT5 = 오늘 · ATTRIBUTE1 = 'Y' | 확정 배치(CONFIRM_BATCH_40)도 같은 SHIP_CONFIRM 행이 있으면 생략 |
| 40 | 0 | 전일 확정 변경 반영 | PR_SSP_ANL_SHIP_PLAN_40_BALANCE | SSP_ANL_SHIP_PLAN_40 · SSP_ANL_SHIP_CONFIRM | SSP_ANL_SHIP_PLAN_40 (전일분 BOH · BALANCE 갱신) | 전일 CUTOFF 이후 확정 수량이 바뀐 날짜부터 BOH · BALANCE 재계산 | HQ00 잡에서만 선행 호출 |
| 40 | 3 | 신규 확정 | PR_SSP_ANL_SHIP_CONFIRM_BATCH_40 | DM_PLN_SHIPMENT_REQ · SCP_MST_BOD_N_V · SCM_MST_SITE(_CUSTOMER) · SCP_MST_SHIPMENT_LOT_SIZE · SSP_MST_PARTIAL_SEQ · SSP_ANL_SHIP_PLAN_40(전일 BALANCE) | SSP_ANL_SHIP_CONFIRM · _H · XIF_ERP_SHIP_PLAN_CONFIRM_S_SN · SSP_ANL_SHIP_CONFIRM_ROUTE, 요청 ATTRIBUTE10 = 확정 ID | MEASURE = 'SHIP_REQ', QTY ≥ 1, ATTRIBUTE10 IS NULL, From 사이트 법인 = 실행 법인<br/>출하일 = 오늘 + SHIP_FROZEN − 1 (SHIP_FROZEN = 0 이면 오늘) — 하루분만<br/>전일 SP 계획 BALANCE 가 음수인 사이트 · 품목 · 일자 제외(룩업 Specific_Site 사이트는 예외) | Lot Size(SPLIT_YN = 'Y') 단위로 행 분할. 확정 ID = 'C' + 일자 + 6자리 |
| 40 | 4 | 재고 CUTOFF | PR_SSP_ANL_SHIP_PLAN_40 (1-1 ~ 1-6) | SSP_DNM_OWMS_STOCK · SSP_DNM_STOCK_C · SSP_ANL_HOLD_STOCK · SCP_MST_FORMATION · SCM_DNM_STOCK_AGING_V | SSP_ANL_OWMS_STOCK_C · SSP_ANL_TCO_STOCK_C · SSP_ANL_HOLD_STOCK · SSP_ANL_FORMATION_C · SSP_ANL_MES_FCS_STOCK_40_C | TCO = STORAGE B100 · R100. Hold 는 직전 SP 버전 기준 이월. MES/FCS 는 활성화 L/T · 수율 적용 |  |
| 40 | 1 | SHIP_REQ 메저 | PR_SSP_ANL_SHIP_PLAN_40 (2-1) | DM_PLN_SHIPMENT_REQ · SSP_ANL_SHIP_PLAN_PACK_REQ · SCP_MST_BOD_N_V | GT → SSP_ANL_SHIP_PLAN_40 MEASURE = 'SHIP_REQ' | MEASURE = 'SHIP_REQ', QTY > 0, 출하일 전일 ~ +84일, From 사이트 OPERATION_GROUP <> 'E', From 사이트 법인 = 실행 법인 | BIZ_TYPE = From 사이트 코드 '-' 뒤 1자리(A · P) |
| 40 | 3 | SHIP_CONFIRM 메저(Rolling) | PR_SSP_ANL_SHIP_PLAN_40 (2-2) | SSP_ANL_SHIP_CONFIRM · DM_PLN_SHIPMENT_REQ | MEASURE = 'SHIP_CONFIRM' | ① 확정 : CHANGE_TYPE = 'C', BIZ_TYPE <> 'E', QTY > 0, 전일 ~ +84일<br/>② 요청 : 출하일 > 오늘 + SHIP_FROZEN − 1, ATTRIBUTE10 IS NULL(미확정) | 확정구간 안은 확정, 이후는 요청 |
| 40 | 5 | 생산 메저 | PR_SSP_ANL_SHIP_PLAN_40 (2-3 ~ 2-12) | SCM_MES_WIP_HISTORY_H_SN · SCM_DNM_PRODUCT_RESULT_V · SSP_DNM_PLAN_FROZEN_V · SSP_ANL_PROD_PLAN_OSP · SSP_ANL_FORMATION_C · SSP_FORMATION_POST_CELL_V | POSTP_PLAN · PROD_PLAN · INCO_WIP · MES_FCS_HOLD · MES_FCS_RELEASE · PROD_DATE · LOT · WH_IN · INSP_WIP | PROD_PLAN : 실적 A3000(MES Lot) · A9000 · F6200 · F7000 ~ F7300 · P5000 · Pouch F5400 ~ F5600 + 계획 조립 · 모듈(P5500) · Pouch 특성 · 외주(SSP0018 입력) + 계획 없는 담당 모델(SSP_MST_MODEL_USER)<br/>일자 = 생산일 + LT_FORMATION + ATTRIBUTE1, 수량 × SSP_MODIFY_YIELD | WH_IN = PROD_PLAN − 해당 Lot · 생산일 OWMS 재고(사용자 입력값 SSP_ANL_SHIP_PLAN_40_WH_IN_H 유지) |
| 40 | 4 | WH_STOCK · BALANCE | PR_SSP_ANL_SHIP_PLAN_40 (2-14 · 2-15) | SSP_ANL_MES_FCS_STOCK_40_C · SSP_ANL_OWMS_STOCK_C · SSP_ANL_TCO_STOCK_C · SSP_ANL_HOLD_STOCK | WH_STOCK · BALANCE | 당일 WH_STOCK = MES/FCS(AVAILABLE_YN <> 'N') + OWMS AVAILABLE_QTY + TCO − Hold<br/>익일 WH_STOCK = 전일 WH_STOCK + 전일 WH_IN − 전일 SHIP_CONFIRM − 전일 POSTP_PLAN − 전일 MES_FCS_HOLD + 전일 MES_FCS_RELEASE<br/>BALANCE = 당일 WH_STOCK − 당일 SHIP_CONFIRM − 당일 POSTP_PLAN |  |
| 40 | 6 | 결과 적재 | PR_SSP_ANL_SHIP_PLAN_40 (3) | GT_SSP_ANL_SHIP_PLAN_40 | SSP_ANL_SHIP_PLAN_40 (PLAN_TYPE 'SP', SEQ 1, ATTRIBUTE10 = 법인) | 실행 법인 사이트 · 오늘 기준 삭제 후 적재. 일 계획 상태 SCM_MST_PLAN_DETAIL(MODELING 101, DAILY) 기록 | NJ00 잡은 이어서 PR_SSP_ANL_INVENTORY_RAW 호출. 음수 잔량 메일 PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40 |

### 81 계열 · 82 : 법인별 일 마감

- 잡 05 ~ 23시 10분 주기 · 법인 루프 한 트랜잭션 · 기준일 = 오늘 − 1 → 결과 SSP_ANL_SHIP_PLAN_C (화면 SSP0021 · SSP0060)

<div class="spf "><div class="spf-row"><div class="spf-card " style="--c:#5B6770"><div class="spf-h">1. 진입 조건</div><ul><li>SSP_MST_SHIP_PLAN_SCHEDULE 오늘 행 'N'</li><li>SCM_DNM_STOCK_V 전일 INVENTORY 있음</li><li>IF_STOCK_CHECK PLAN_AUTO (MES_W · OWMS) 전부 오늘 · 'Y'</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#3A6EA5"><div class="spf-h">2. OWMS 재고 CUTOFF</div><ul><li>SSP_DNM_OWMS_STOCK → SSP_ANL_OWMS_STOCK_C2</li><li>CUTOFF_DATE = 기준일, 없을 때만 생성</li><li>AS 창고는 A/S(W) 사이트로</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#1F7A8C"><div class="spf-h">3. 요청 · 계획 메저</div><ul><li>SHIP_REQ : DM_PLN_SHIPMENT_REQ</li><li>SHIP_PLAN : 확정구간 = 확정 / 이후 = 요청</li><li>PROD_PLAN : SSP_DNM_FP_PLAN_FROZEN + 82 Packer + A/S 입고</li><li>INTN_MOVEMENT : 법인 간 이동</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#3A6EA5"><div class="spf-h">4. 재고 계산 · 적재</div><ul><li>BOH = GMES 가용 + ESS Packer + OWMS 가용</li><li>WH(d) = BOH + Σ(PROD − SHIP_PLAN − MOVE)</li><li>BALANCE = WH − SHIP_PLAN · CONTAINER</li><li>→ SSP_ANL_SHIP_PLAN_C</li></ul></div></div><div class="spf-snake" style="--n:4"><i></i><u></u></div><div class="spf-row"><div class="spf-card " style="--c:#4E8F4A"><div class="spf-h">5. FP 자동생성 (82 Pack)</div><ul><li>FP_AUTO_SHIP_FROM_TO 3건</li><li>생산 기반 SHIP_PLAN 추가 적재</li><li>다음 장 참조</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">6. 신규 확정 · 송신</div><ul><li>SHIP_REQ · CONFIRM_FLAG 'N' · 출하일 ≤ 기준일 + 확정구간</li><li>→ SSP_ANL_SHIP_CONFIRM · XIF_ERP_SHIP_PLAN_CONFIRM_S_SN · ROUTE</li><li>PLAN_C 'Y'(확정) / 'D'(미확정)</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#0B3C49"><div class="spf-h">7. 후속 · 종료</div><ul><li>음수 재고 · 요청 삭제 메일</li><li>82 Pack SCS 송신</li><li>CURRENT_PLAN_DATE_YN = 'Y'</li><li>오류 시 전체 ROLLBACK · 문자 57</li></ul></div><div class="spf-ar"></div><div class="spf-card spf-empty"></div></div><div class="spf-leg"><span style="--c:#5B6770"><i></i>진입 조건</span><span style="--c:#1F7A8C"><i></i>출하요청</span><span style="--c:#D98E2B"><i></i>확정 · Rolling</span><span style="--c:#3A6EA5"><i></i>재고</span><span style="--c:#4E8F4A"><i></i>생산</span><span style="--c:#0B3C49"><i></i>결과 · 송신</span></div></div>

#### 82 FP 자동생성 : 생산 기반 출하계획

- PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO → PR_SSP_ANL_SHIP_CONFIRM_BATCH_N_FP_AUTO · 대상 : 등록 경로의 Pack 품목

<div class="spf spf-op"><div class="spf-row"><div class="spf-card" style="--c:#3A6EA5"><b>전일 WH_STOCK</b><span>당일이 기준일이면 BOH</span></div><div class="spf-ar">+</div><div class="spf-card" style="--c:#4E8F4A"><b>당일 생산 × (100 − RATE)%</b><span>SSP_DNM_FP_PLAN_FROZEN · RATE = 룩업 ATTRIBUTE1</span></div><div class="spf-ar">→</div><div class="spf-card" style="--c:#D98E2B"><b>Lot 단위 내림</b><span>TRUNC(합 ÷ Lot) × Lot</span></div><div class="spf-ar">=</div><div class="spf-card fill" style="--c:#0B3C49"><b>SHIP_PLAN</b><span>출하계획 수량</span></div></div></div>

<div class="spf "><div class="spf-grid" style="--n:2"><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">산정 규칙</div><ul><li>확정구간 안 : 확정 수량만</li><li>합계가 Lot 보다 작으면 0, Lot 이 없으면 전량</li><li>WH_STOCK = 전일 + 생산 − (확정 있으면 확정, 없으면 SHIP_PLAN)</li><li>확정 : SHIP_PLAN 메저 · CONFIRM_FLAG 'N' · 확정구간 안</li><li>이동계획 차감 조인 조건 오기로 이동 수량 항상 0 (확인 필요)</li></ul></div></div></div>

- 등록 경로 (2026-11-11)
- 일반 요청 기반 CUTOFF · 확정 배치는 이 대상을 제외

| 사업부 | From | To |
|---|---|---|
| 82 | MI01-P | MI04-P |
| 82 | VP_ST00-P | MI04-P |
| 82 | VP_ST00-P | US02182600_82-P |

**단계별 상세 — [81 계열 · 82] 자동차 · ESS — PR_SSP_PLN_SHIP_PLAN_CUTOFF (법인 루프, 한 트랜잭션)**

| 사업부 | 단계 | 처리 | 프로그램 | 원천 테이블 | 대상 테이블 · 메저 | 조건 | 산식 · 비고 |
|---|---|---|---|---|---|---|---|
| 81 계열 · 82 | 0 | 진입 조건 | PR_SSP_PLN_SHIP_PLAN_CUTOFF | SSP_MST_SHIP_PLAN_SCHEDULE · SCM_DNM_STOCK_V · 룩업 IF_STOCK_CHECK | SSP_MST_SHIP_PLAN_SCHEDULE 진행 플래그 | ① PLAN_START_YYYYMMDD = 오늘 AND CURRENT_PLAN_DATE_YN = 'N'<br/>② SCM_DNM_STOCK_V : CUTOFF_DATE = 오늘 − 1, STOCK_TYPE = 'INVENTORY', 법인 1건 이상<br/>③ IF_STOCK_CHECK SEGMENT1 = 'PLAN_AUTO' · SEGMENT3 = '81_82' · 법인 행 전부 SEGMENT5 = 오늘 · ATTRIBUTE1 = 'Y' | 기준일(CUTOFF_DATE) = 오늘 − 1. 하위 단계 오류 시 전체 ROLLBACK · 문자 57 |
| 81 계열 · 82 | 4 | OWMS 재고 CUTOFF | PR_SSP_PLN_SHIP_PLAN_CUTOFF | SSP_DNM_OWMS_STOCK · SCM_MST_SITE · 룩업 AS_STORAGE | SSP_ANL_OWMS_STOCK_C2 (CUTOFF_DATE = 기준일), 플래그 ERP_STOCK_CUTOFF_YN · OWMS_STOCK_CUTOFF_YN | SSP_DNM_OWMS_STOCK.CUTOFF_DATE = 기준일, 같은 법인 · 기준일 C2 가 없을 때만 생성 | 사이트 = AS 창고면 OPERATION_GROUP 'W' 사이트, 아니면 품목 OPERATION_GROUP 의 플랜트 사이트 |
| 81 계열 · 82 | 1 | SHIP_REQ 메저 | PR_SSP_ANL_SHIP_PLAN_CUTOFF (2-1) | DM_PLN_SHIPMENT_REQ · SCP_MST_BOD_N_V | SSP_ANL_SHIP_PLAN_C MEASURE = 'SHIP_REQ' | 사업부 ATTRIBUTE3 IN ('81','82'), MEASURE = 'SHIP_REQ', 출하일 기준일 ~ +56일 미만, From 사이트 법인 = 실행 법인, FP_AUTO_SHIP_FROM_TO 대상 제외 | ETA = FN_GET_SSP_ETA_DATE(BOD, 출하일), INCOTERMS = BOD SSP_INCOTERMS 우선 |
| 81 계열 · 82 | 3 | SHIP_PLAN 메저(Rolling) | PR_SSP_ANL_SHIP_PLAN_CUTOFF (2-2) | SSP_ANL_SHIP_CONFIRM · 위 SHIP_REQ | MEASURE = 'SHIP_PLAN' | ① 확정 : CHANGE_TYPE = 'C', 출하일 기준일 ~ +56일, From 사이트 법인 = 실행 법인 (CONFIRM_FLAG 'Y')<br/>② 요청 : 출하일 ≥ 기준일 + 확정구간 일수(0 이하면 기준일) (CONFIRM_FLAG 'N') | 확정구간 일수 = FN_GET_ANL_SHIP_FROZEN_DAY_CNT('SSP', 사업부, From 사이트, 기준일) |
| 81 계열 · 82 | 5 | INTN_MOVEMENT · PROD_PLAN | PR_SSP_ANL_SHIP_PLAN_CUTOFF (2-3 · 2-4) | SCM_DNM_CELL_INHOUSE_PLAN_SN · SSP_DNM_FP_PLAN_FROZEN · SCP_ANL_PRODUCTION_PLAN · SCP_PLAN_VERSION_V · SSP_ANL_SHIP_CONFIRM | INTN_MOVEMENT · PROD_PLAN | 이동 : CATEGORY = 'MOVING', 외주 아닌 플랜트<br/>생산 : OPERATION_ID IN (P5500 · P9500 · F5300 · F5500 · F5600 · F6000 · PL500), PLAN_QTY > 0 + 82 외주 사이트 PROD_PLAN_AMEND(최신 주간 버전, TE · TM 제외) + A/S 입고(To 사이트 OPERATION_GROUP 'W', ETA 기준) | FP_AUTO_SHIP_FROM_TO 대상 제외 |
| 81 계열 · 82 | 4 | WH_STOCK · BALANCE · CONTAINER | PR_SSP_ANL_SHIP_PLAN_CUTOFF (2-7 · 2-8) | SSP_DNM_GMES_STOCK_81_82 · SSP_DNM_ESS_PACKER_STOCK_V · SSP_ANL_OWMS_STOCK_C2 · 룩업 OWMS_STOCK_STATUS · SCP_MST_SHIPMENT_LOT_SIZE | WH_STOCK · BALANCE · CONTAINER | 기초 : GMES(YYYYMMDD = 기준일) LOT_QTY − (AVAILABLE_YN 'N' AND OQC 'N') − (AVAILABLE_YN 'N' AND QMS/MES Hold 'Y')<br/>+ ESS Packer SSP_QTY(CUTOFF_DATE = 기준일 − 1) + OWMS AVAILABLE_QTY(CUTOFF_DATE = 기준일 − 1, OWMS_STOCK_STATUS ATTRIBUTE1 = 'Y')<br/>WH_STOCK(d) = 기초 + Σ(기준일 ~ d−1 의 PROD_PLAN − SHIP_PLAN − INTN_MOVEMENT)<br/>BALANCE = WH_STOCK − SHIP_PLAN, CONTAINER = CEIL(SHIP_PLAN / Lot Size) | Lot Size 운송 = SEA(룩업 G382_Transport 사이트는 TRK). ERP 재고는 진입 조건에만 사용 |
| 81 계열 · 82 | 6 | 결과 적재 · Hold 이월 | PR_SSP_ANL_SHIP_PLAN_CUTOFF (3 · 4) | GT_SSP_ANL_SHIP_PLAN_C · SCP_MST_FINAL_ITEM · SSP_ANL_HOLD_STOCK | SSP_ANL_SHIP_PLAN_C (법인 · 기준일 삭제 후 적재, BIZ_TYPE = 최종 품목 OPERATION_GROUP) · SSP_ANL_HOLD_STOCK(기준일 + 1) | SCP_MST_FINAL_ITEM 에 있는 품목만 적재. Hold 이월은 40 제외 | 플래그 PLAN_CUTOFF_CREATE_YN = 'Y' |
| 82 (FP 자동생성 대상) | 5 | 생산 기반 출하계획 | PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO | 룩업 FP_AUTO_SHIP_FROM_TO(SEGMENT1 사업부 · 2 From · 3 To · 4 품목 · 5 BOD · ATTRIBUTE1 RATE) · SCM_MST_ITEM_SN · SSP_DNM_FP_PLAN_FROZEN · SSP_ANL_SHIP_CONFIRM · SCP_MST_SHIPMENT_LOT_SIZE | SSP_ANL_SHIP_PLAN_C 추가 적재 (MEASURE = 'SHIP_PLAN' 등) | 대상 : 룩업 등록 경로 · 품목 AND SCM_MST_ITEM_SN.SCP_OPERATION_GROUP = 'P'(Pack)<br/>확정구간 안 : 확정 수량만. 이후 : SHIP_PLAN = TRUNC((전일 WH_STOCK + 당일 생산 × (100 − RATE)/100) / Lot) × Lot (Lot 보다 작으면 0, Lot 없으면 전량)<br/>WH_STOCK = 전일 WH_STOCK + 생산 − (확정 있으면 확정, 없으면 SHIP_PLAN) | 현재 등록 3건(82 : MI01-P → MI04-P, VP_ST00-P → MI04-P, VP_ST00-P → US02182600_82-P). 이동계획 차감 조인 조건 오기로 이동 수량 0 |
| 81 계열 · 82 | 3 | 신규 확정 · ERP 송신 | PR_SSP_ANL_SHIP_CONFIRM_BATCH_N | SSP_ANL_SHIP_PLAN_C · SCP_MST_BOD_N_V · SCP_MST_SHIPMENT_LOT_SIZE · SSP_MST_PARTIAL_SEQ · SSP_MST_SITE_ITEM_EE_V · NERP_CONV_MASTER · 룩업 CELL_SHIP_FROM_TO · ELECTRODE_SHIP_FROM_TO | SSP_ANL_SHIP_CONFIRM · _H · XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(SHIPMENT_STATUS 'A', TRANSFER_FLAG 'N') · SSP_ANL_SHIP_CONFIRM_ROUTE, PLAN_C CONFIRM_FLAG Y / D | PLAN_C : 법인 · 기준일, MEASURE = 'SHIP_REQ', QTY > 0, 확정구간 일수 > 0, CONFIRM_FLAG 'N', 출하일 ≤ 기준일 + 확정구간 일수(익일 기준)<br/>같은 키가 이미 확정(CONFIRM_FLAG 'Y')된 행은 제외 후 'Y' 만 표시, FP_AUTO 대상 제외, 남은 대상은 'D' | Lot Size(SPLIT_YN = 'Y') 분할. 90일 지난 송신 자료 삭제. 룩업 SSP_PLN_FP_SHIP_TARGET_WA 법인이면 WA 출하목표 호출. BALANCE 음수 제외 로직은 2020-05-06 제거 |
| 82 (FP 자동생성 대상) | 3 | 생산 기반 확정 | PR_SSP_ANL_SHIP_CONFIRM_BATCH_N_FP_AUTO | SSP_ANL_SHIP_PLAN_C · 룩업 FP_AUTO_SHIP_FROM_TO · SCM_MST_ITEM_SN | BATCH_N 과 같음 | MEASURE = 'SHIP_PLAN', 룩업 등록 품목 AND SCP_OPERATION_GROUP = 'P' |  |
| 81 계열 · 82 | 6 | 후속 | PR_SSP_PLN_SHIP_PLAN_CUTOFF | - | 메일 PR_SSP_MAIL_SEND_BATCH_N(음수 재고) · PR_SSP_MAIL_SEND_SHIP_REQ_DELETE · 82 Pack SCS 송신 PR_SSP_XIF_SCS_PACK_SHIP_PLAN_S_82 | 완료 시 CONFIRM_CREATE_YN · FP_TARGET_SEND_YN · CURRENT_PLAN_DATE_YN = 'Y' |  |

### 전극 : 법인별 10분 주기

- PR_SSP_ANL_SHIP_PLAN_EE · 계획 구간 오늘 ~ +56일 · 결과 SSP_ANL_SHIP_PLAN_EE (화면 SSP0023)

<div class="spf "><div class="spf-row"><div class="spf-card " style="--c:#5B6770"><div class="spf-h">1. 진입 조건</div><ul><li>SCHEDULE_EE 오늘 행 'N'</li><li>FP AUTO_PLAN_CALL_FLAG = 오늘</li><li>시업시간 일치</li><li>IF_STOCK_CHECK PLAN_EE 전부 오늘</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#3A6EA5"><div class="spf-h">2. 재고 CUTOFF</div><ul><li>MES + IWMS + OWMS (전극)</li><li>조립 ↔ 전극 플랜트 매핑</li><li>→ SSP_ANL_STOCK_EE_C</li><li>→ SSP_ANL_BOH_CUTOFF_EE</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#4E8F4A"><div class="spf-h">3. 생산계획 추출</div><ul><li>FP Pancake 시뮬레이션 계획</li><li>Coater · Post Yield · Notching 소요</li><li>SCP 목표 · 입고 예정</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#1F7A8C"><div class="spf-h">4. 출하요청(주 1회)</div><ul><li>SCP 반제품 계획 · OG 'E'</li><li>→ SSP_ANL_SHIP_REQ_EE</li><li>작성자 'SCP FN Plan', ETA 기준</li><li>보존 7일</li></ul></div></div><div class="spf-snake" style="--n:4"><i></i><u></u></div><div class="spf-row"><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">5. 출하계획</div><ul><li>P_SHIP_PLAN_SIMU_ETD</li><li>= 확정 + 미확정 요청</li><li>사용자 시뮬레이션 저장값 우선</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">6. 출하 실적 반영</div><ul><li>전주 월 ~ 전전일 = OWMS 출하 실적</li><li>SSP_DNM_SHIP_RESULT_OWMS_V</li><li>이후 = 확정</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#4E8F4A"><div class="spf-h">7. 재고 시뮬레이션</div><ul><li>P_INV_SIM(익일) = 전일 + Coater(전일) + 입고 − Notching − 출하계획</li><li>→ SSP_ANL_SHIP_PLAN_EE</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#0B3C49"><div class="spf-h">8. 신규 확정 · 송신</div><ul><li>미확정 요청 · ETD 확정구간 안</li><li>→ SSP_ANL_SHIP_CONFIRM · XIF_ERP</li><li>요청 CONFIRM_FLAG 'Y'</li></ul></div></div><div class="spf-leg"><span style="--c:#5B6770"><i></i>진입 조건</span><span style="--c:#1F7A8C"><i></i>출하요청</span><span style="--c:#D98E2B"><i></i>확정 · Rolling</span><span style="--c:#3A6EA5"><i></i>재고</span><span style="--c:#4E8F4A"><i></i>생산</span><span style="--c:#0B3C49"><i></i>결과 · 송신</span></div></div>

**단계별 상세 — [전극] PR_SSP_ANL_SHIP_PLAN_EE (법인 루프)**

| 사업부 | 단계 | 처리 | 프로그램 | 원천 테이블 | 대상 테이블 · 메저 | 조건 | 산식 · 비고 |
|---|---|---|---|---|---|---|---|
| 전극 | 0 | 진입 조건 | PR_SSP_ANL_SHIP_PLAN_EE | SSP_MST_SHIP_PLAN_SCHEDULE_EE · FP 룩업 SCM_SYS_LOOKUP_VALUE(AUTO_PLAN_CALL_FLAG) · 룩업 BASIS_START_TIME_PLANT · IF_STOCK_CHECK | - | PLAN_START_YYYYMMDD = 오늘 AND CURRENT_PLAN_DATE_YN = 'N' AND AUTO_PLAN_CALL_FLAG ACTIVE · ATTRIBUTE1 = 오늘 AND 시업시간 일치<br/>AND IF_STOCK_CHECK SEGMENT1 = 'PLAN_EE' · SEGMENT3 = 'EE' · 법인 행 전부 SEGMENT5 = 오늘 | 계획 구간 = 오늘 ~ +56일. 실적 구간 = 전주 월요일 ~ 전일 |
| 전극 | 4 | 재고 CUTOFF · 기초재고 | PR_SSP_ANL_SHIP_PLAN_EE (1-7 · 1-1) | SSP_DNM_GMES_STOCK_EE · SSP_DNM_IWMS_STOCK_EE · SSP_DNM_OWMS_STOCK_EE · 룩업 ELECTRODE_ASSY_PLANT_MAPPING · SSP_MST_SITE_ITEM_EE_V | SSP_ANL_STOCK_EE_C → SSP_ANL_BOH_CUTOFF_EE (MEASURE_TYPE R = 조립 기준, P = 전극 기준) | MES · IWMS · OWMS 를 조립 ↔ 전극 플랜트 매핑으로 양쪽 기준 재고로 전개, 이전 정보와 비교 후 적재, 0 · 삭제 상태 제거 | PCM · Cell 환산(CONVERT_TO_PCM · CONVERT_TO_CELL) |
| 전극 | 5 | 생산계획 추출 | PR_SSP_ANL_SHIP_PLAN_EE (1-2 · 1-3) | SSP_DNM_FP_PANCAKE_SIMUL_PLAN_V_SN · SCP_ANL_PRODUCTION_PLAN · SCP_PLAN_VERSION_V | GT (FP 계획 · SCP 목표) | FP : PLAN_QTY = Coater 계획, POST_PLAN_QTY = Coater + Post Yield, ASSY_PC_REQ_QTY = Notching 소요 (조립 · 전극 사이트 기준 R / P)<br/>SCP : 최신 EE FN 버전 |  |
| 전극 | 1 | 출하요청 생성(주 1회) | PR_SSP_ANL_SHIP_PLAN_EE (1-4 · 1-5) | SCP_ANL_SHIPMENT_PLAN_SEMI(SHIP_PLAN_AMEND) · SCP_OPT_SHIPMENT_PLAN(_PEGGING)_V(OPERATION_GROUP 'E') · 룩업 ELECTRODE_SHIP_REQ_OW_PERIOD · SCP_PLN_INTERFACE_YN | SSP_ANL_SHIP_REQ_EE (CREATED_BY 'SCP FN Plan', CONFIRM_FLAG 'N') · _H | 최신 EE FN 버전이 SSP_ANL_SHIP_REQ_EE 에 없고 FP_TARGET_YN <> 'N' 일 때만<br/>확정구간 + 보존 7일 이후 : 미확정 전부 삭제 후 생성 / 확정구간 ~ +7일 : 사용자 미수정 · 미확정만 삭제, 사용자 수정분과 같은 키는 생성 제외 | ETA 기준. 출하대상 룩업 ELECTRODE_SHIP_FROM_TO 자동 등록(1-4-1) |
| 전극 | 3 | 출하계획(P_SHIP_PLAN_SIMU_ETD) | PR_SSP_ANL_SHIP_PLAN_EE (2-2-8) | SSP_ANL_SHIP_CONFIRM · SSP_ANL_SHIP_REQ_EE · SSP_ANL_SHIP_PLAN_SIMU_EE | MEASURE = 'P_SHIP_PLAN_SIMU_ETD' | 확정 : CHANGE_TYPE = 'C', 전주 월요일 ~ +56일 + 요청 : ETD ≥ 오늘 − 1 + 확정구간 일수, < +56일, CONFIRM_FLAG <> 'Y'<br/>사용자 시뮬레이션 저장값(최신 SEQ)이 0 아니면 그 값 사용 |  |
| 전극 | 2 | 출하 실적 반영(CUTOFF용) | PR_SSP_ANL_SHIP_PLAN_EE (3-2 · 3-3) | SSP_DNM_SHIP_RESULT_OWMS_V · SSP_ANL_SHIP_CONFIRM | R_SHIP_PLAN_ETD 등 CUTOFF용 출고 메저 | 실적 구간(어제의 전주 월요일 ~ 전전일) = OWMS 출하 실적, 어제 이후 = 확정(CHANGE_TYPE 'C') | 조립 기준(R)은 ELECTRODE_ASSY_PLANT_MAPPING 으로 전극 사이트 실적을 읽음 |
| 전극 | 5 | 재고 시뮬레이션 | PR_SSP_ANL_SHIP_PLAN_EE (2 · 3) | 위 GT · SSP_DNM_FP_MRP_INTRANSIT_SN | P_INV_SIM · P_INV_CONFIRM · R_INV_SHIP_REQ · R_INV_SHIP_PLAN | P_INV_SIM(익일) = P_INV_SIM(전일) + P_FP_COATER_PLAN(전일) + P_INTRANSIT_ETA(당일) − P_FP_NPC_ASSY_PLAN(당일) − P_SHIP_PLAN_SIMU_ETD(당일)<br/>P_INV_CONFIRM : 위 식의 출하를 P_SHIP_CONFIRM_ETD 로<br/>R_INV_SHIP_PLAN(익일) = 전일 + C_FP_COATER_PLAN(전일) + C_INTRANSIT_ETA(당일) − C_FP_NPC_ASSY_PLAN(당일) − R_SHIP_PLAN_ETD(당일) | 기초 = SSP_ANL_BOH_CUTOFF_EE |
| 전극 | 3 | 신규 확정 · ERP 송신 | PR_SSP_ANL_SHIP_PLAN_EE (4-1 ~ 4-3) | SSP_ANL_SHIP_REQ_EE · SCP_MST_BOD_N_V · SCM_MST_SITE · 룩업 ELECTRODE_SHIP_FROM_TO | SSP_ANL_SHIP_CONFIRM · _H · XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, 요청 CONFIRM_ID · CONFIRM_FLAG 'Y' | From 사이트 법인 = 실행 법인, 확정구간 일수 > 0, CONFIRM_FLAG 'N', QTY > 0, ETD 가 확정구간 안 | 이어서 FP 출하목표 PR_SSP_PLN_FP_SHIP_TARGET_EE |
| 전극 | 6 | 결과 적재 | PR_SSP_ANL_SHIP_PLAN_EE (2-3 · 3) | GT | SSP_ANL_SHIP_PLAN_EE (당일분 + CUTOFF분) |  | 화면 SSP0023 |

### Packer (40 외주 Pack) : 1일 1회 07:15

- PR_SSP_ANL_SHIP_PLAN_P → PR_SSP_ANL_SHIP_CONFIRM_P · 기준일 = 오늘 − 1 · 결과 SSP_ANL_SHIP_PLAN_P (화면 SSP0026)

<div class="spf "><div class="spf-row"><div class="spf-card " style="--c:#5B6770"><div class="spf-h">1. 진입 조건</div><ul><li>기준일 &gt; 룩업 SSP_ANL_SHIP_PLAN_P ATTRIBUTE1</li><li>현재 값 20260821</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#1F7A8C"><div class="spf-h">2. 요청 · 확정 메저</div><ul><li>SHIP_REQ · SHIP_RTF : SSP_ANL_SHIP_REQ_P</li><li>SHIP_CONFIRM = 확정 + 요청(≥ 기준일 + SHIP_FROZEN, 기본 7)</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#4E8F4A"><div class="spf-h">3. 생산 · 기초재고</div><ul><li>PROD_PLAN = SCM_DNM_SCS_PROD_PLAN</li><li>BOH = SCM_DNM_SCS_STOCK (기준일 − 2)</li><li>갱신 시각 ≤ 07:15 (월 15:30)</li></ul></div></div><div class="spf-snake" style="--n:3"><i></i><u></u></div><div class="spf-row"><div class="spf-card " style="--c:#3A6EA5"><div class="spf-h">4. 재고 계산 · 적재</div><ul><li>WH = BOH + Σ(PROD − SHIP_CONFIRM)</li><li>BALANCE = WH − SHIP_CONFIRM</li><li>→ SSP_ANL_SHIP_PLAN_P</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#0B3C49"><div class="spf-h">5. 신규 확정 · 송신</div><ul><li>출하일 = 오늘 + SHIP_FROZEN − 1</li><li>→ SSP_ANL_SHIP_CONFIRM</li><li>XIF_ERP_PACK_SHIP_PLAN_S_SN · XIF_SCS_PACK_SHIP_PLAN_S_SN</li></ul></div><div class="spf-ar"></div><div class="spf-card spf-empty"></div></div><div class="spf-leg"><span style="--c:#5B6770"><i></i>진입 조건</span><span style="--c:#1F7A8C"><i></i>출하요청</span><span style="--c:#D98E2B"><i></i>확정 · Rolling</span><span style="--c:#3A6EA5"><i></i>재고</span><span style="--c:#4E8F4A"><i></i>생산</span><span style="--c:#0B3C49"><i></i>결과 · 송신</span></div></div>

**단계별 상세 — [Packer] PR_SSP_ANL_SHIP_PLAN_P → PR_SSP_ANL_SHIP_CONFIRM_P (07:15)**

| 사업부 | 단계 | 처리 | 프로그램 | 원천 테이블 | 대상 테이블 · 메저 | 조건 | 산식 · 비고 |
|---|---|---|---|---|---|---|---|
| Packer | 1 · 3 | SHIP_REQ · SHIP_RTF · SHIP_CONFIRM 메저 | PR_SSP_ANL_SHIP_PLAN_P (2-1 ~ 2-3) | SSP_ANL_SHIP_REQ_P · SSP_ANL_SHIP_CONFIRM | SSP_ANL_SHIP_PLAN_P | 기준일 = 오늘 − 1, 구간 기준일 − 1 ~ +56일<br/>SHIP_CONFIRM = 확정(CONFIRM_FLAG 'Y') + 요청(출하일 ≥ 기준일 + SHIP_FROZEN(기본 7)) |  |
| Packer | 4 · 5 | PROD_PLAN · WH_STOCK · BALANCE | PR_SSP_ANL_SHIP_PLAN_P (2-4 · 2-6 · 2-7) | SCM_DNM_SCS_PROD_PLAN · SCM_DNM_SCS_STOCK | PROD_PLAN · WH_STOCK · BALANCE | 생산 = 최신 CUTOFF SCS 생산계획. 기초 = SCS 재고 CUTOFF_DATE = 기준일 − 2, LAST_UPDATE_DATE ≤ 기준일 07:15(월요일 15:30)<br/>WH_STOCK = 기초 + Σ(PROD_PLAN − SHIP_CONFIRM), BALANCE = WH_STOCK − SHIP_CONFIRM |  |
| Packer | 3 | 신규 확정 · 송신 | PR_SSP_ANL_SHIP_CONFIRM_P | SSP_ANL_SHIP_REQ_P · SCM_MST_SITE_CUSTOMER | SSP_ANL_SHIP_CONFIRM · _H · XIF_ERP_PACK_SHIP_PLAN_S_SN · XIF_SCS_PACK_SHIP_PLAN_S_SN, 요청 CONFIRM_ID | 출하일 = 오늘 + SHIP_FROZEN − 1 (SHIP_FROZEN 0 이면 오늘) |  |

### 통합 — 사업부 결과 통합

**단계별 상세 — [통합] 사업부 결과 통합**

| 사업부 | 단계 | 처리 | 프로그램 | 원천 테이블 | 대상 테이블 · 메저 | 조건 | 산식 · 비고 |
|---|---|---|---|---|---|---|---|
| 전 사업부 | 6 | 출하계획 · 확정 통합본 | PR_SSP_ANL_SHIP_PLAN_ALL | SSP_ANL_SHIP_PLAN_40 · SSP_ANL_SHIP_PLAN_C · SSP_ANL_SHIP_REQ_EE · SSP_ANL_SHIP_CONFIRM · SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE · SSP_MST_SHIP_PLAN_SCHEDULE(_EE) | SSP_ANL_SHIP_PLAN_ALL | 사업부별 결과를 한 테이블로 모음 | 통합테스트 시나리오 C-23 |

## 5. 기준정보 설정(엑셀 「기준정보 설정」 시트)

| 구분 | 사업부 | 사이트 구분 | Operation Group | 외주(OSP_YN) | 사이트 수 | SHIP_FROZEN(일) | 확정구간 설정(ATTRIBUTE6) |
|---|---|---|---|---|---|---|---|
| Operation Group | 40 | PLANT | A (Cell) | N | 6 | 0 ~ 21 | D0, D21 |
| Operation Group | 40 | PLANT | A (Cell) | Y | 1 | 0 | D0 |
| Operation Group | 40 | PLANT | E (Electrode) | N | 4 | 7 | D7 |
| Operation Group | 40 | PLANT | E (Electrode) | Y | 1 | 0 | D0 |
| Operation Group | 40 | PLANT | P (Pack) | N | 2 | 21 | D21 |
| Operation Group | 40 | PLANT | P (Pack · Packer) | Y | 17 | 3 | D3 |
| Operation Group | 40 | PLANT | W (A/S) | N | 1 | 0 | D0 |
| Operation Group | 81 | PLANT | A | N | 9 | 11 ~ 14 | D11, W1 |
| Operation Group | 81 | PLANT | E | N | 7 | 7 ~ 56 | D7, D56 |
| Operation Group | 81 | PLANT | P | N | 7 | 11 ~ 14 | D11, W1 |
| Operation Group | 81 | PLANT | P | Y | 2 | 1 ~ 11 | D1, D11 |
| Operation Group | 81 | PLANT | W | N | 5 | 0 ~ 14 | D0, D11, W1 |
| Operation Group | 81_HD | PLANT | A · E · P | N | 3 | 0 | D0 |
| Operation Group | 81_HG · 81_HM | PLANT | A / E | N | 각 1 / 1 | 11 / 7 | D11 / D7 |
| Operation Group | 81_ST | PLANT | A / E / P | N | 1 / 1 / 1 | 11 / 7 / 11 | D11 / D7 / D11 |
| Operation Group | 81_UC | PLANT | A / E | N | 4 / 2 | 14 / 7 | W1 / D7 |
| Operation Group | 82 | PLANT | A · E · P · W | N | 11 · 2 · 3 · 3 | 14 | W1 |
| Operation Group | 82 | PLANT | P (외주) | Y | 10 | 1 ~ 28 | D1, W1, W2, W3 |
| Operation Group | 82 | SALES | W (A/S) | - | 3 | 0 | - |
| 확정구간 일수 계산 | FN_GET_ANL_SHIP_FROZEN_DAY_CNT('SSP', 사업부, 사이트, 기준일) = ATTRIBUTE6 이 'W n' 이면 (n + 1) × 7 − (기준일 − 그 주 월요일), 아니면 SHIP_FROZEN. 40 · Packer 는 FN_GET_SSP_ANL_SHIP_FROZEN(= SHIP_FROZEN) |  |  |  |  |  |  |
| 요청 보존일수 DM_SHIP_OW_FROZEN | 40 = 7, 81 · 81_HD · 81_HG · 81_HM · 81_ST · 81_UC = 10, 82 = 0 |  |  |  |  |  |  |
| 전극 보존일수 ELECTRODE_SHIP_REQ_OW_PERIOD | 등록 17건 모두 7일 |  |  |  |  |  |  |
| 재고 수신 확인 IF_STOCK_CHECK | PLAN_40(40) 5건 : MES_F · MES_W · OWMS / PLAN_AUTO(81_82) 24건 : MES_W · OWMS / PLAN_EE(EE) 39건 : IWMS · MES · OWMS |  |  |  |  |  |  |
| FP 자동생성 FP_AUTO_SHIP_FROM_TO | 3건, 모두 82 : MI01-P → MI04-P, VP_ST00-P → MI04-P, VP_ST00-P → US02182600_82-P |  |  |  |  |  |  |
| Packer 차단일 SSP_ANL_SHIP_PLAN_P | 40 : ATTRIBUTE1 = 20260821 (기준일이 이 날짜 이하이면 미수행) |  |  |  |  |  |  |
| BIZ_TYPE · OPERATION_GROUP 룩업 | A = Cell, E = Electrode, P = Pack · Module (40 · 81 · 82 공통) |  |  |  |  |  |  |
| TO-BE 잡(모두 DISABLED) | JOB_PR_SSP_PLN_SHIP_PLAN_40 08:00 · _AZ 10:30 · _C 11:00 / _81_82 05 ~ 23시 7 · 17 · 27 · 37 · 47 · 57분 / _EE 10분 / _P 07:15 |  |  |  |  |  |  |

## 6. 확인 필요 · 실행 상태(흐름도 10번 슬라이드)

<div class="spf "><div class="spf-grid" style="--n:2"><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">1. 81·82 OWMS 재고 기준일</div><ul><li>기초재고의 OWMS 는 SSP_ANL_OWMS_STOCK_C2.CUTOFF_DATE = 기준일 − 1 행을 읽음</li><li>같은 실행이 만든 행은 CUTOFF_DATE = 기준일 → OWMS 만 하루 차이(GMES 는 기준일)</li><li>AS-IS 원문 대조 필요</li></ul></div><div class="spf-card " style="--c:#D98E2B"><div class="spf-h">2. 82 FP 자동생성 이동계획</div><ul><li>이동계획 차감 조인 조건이 PP.MEASURE = 'INTN_MOVEMENT' 로 기재</li><li>이동 수량 항상 0</li><li>변환본 주석 : 원문 동작 그대로 유지</li></ul></div></div></div>

<div class="spf "><div class="spf-grid" style="--n:1"><div class="spf-card " style="--c:#5B6770"><div class="spf-h">실행 상태</div><ul><li>산출 잡 6개(40 · 40_AZ · 40_C · 81_82 · EE · P) 모두 DISABLED · 산출 프로시저 모두 VALID</li><li>ESS 확정 PR_SSP_ANL_ESS_SHIP_CONFIRM · PR_SSP_ANL_ESS_PLAN_CUTOFF 는 INVALID</li></ul></div></div></div>


## 7. 교차검증 — 자료(TO-BE 본문 기준) ↔ AS-IS SP 본문

- 엑셀 「단계별 상세」 각 행의 프로그램에 대해, 「원천 테이블」이 AS-IS 본문의 읽기·쓰기 대상에, 「대상 테이블 · 메저」의 테이블이 쓰기 대상에 있는지 대조(중첩 호출 깊이 3 · 이름 끝 `_SN` 은 떼고 비교). 테이블 이름은 AS-IS 객체 카탈로그에 있는 것만 대조하고, 카탈로그에 없는 이름은 따로 적는다(임시 테이블 · 메저 이름 · TO-BE 에만 있는 객체)

| 구간 | 단계 | 처리 | 프로그램(AS-IS 본문 있는 것) | 원천 — 본문에 없음 | 대상 — 본문 쓰기에 없음 | AS-IS 카탈로그에 없는 테이블 이름 |
|---|---|---|---|---|---|---|
| [공통] | 1 | 반제품(SEMI) 선적요청 삭제 | PR_SSP_ANL_SHIP_REQ_SEMI | - | - | DM_SHIP_OW_FROZEN |
| [공통] | 1 | 제품(FG) 선적요청 삭제 · 생성 | PR_SSP_ANL_SHIP_REQ_FG | - | - | SCP_OPT_SHIPMENT_PLAN_V, SCP_OPT_SHIPMENT_PLAN_PEGGING_V |
| [공통] | 1 | Packer 선적요청 삭제 · 생성 | PR_SSP_ANL_SHIP_REQ_P | - | - | SCP_OPT_SHIPMENT_PLAN_V |
| [40] | 0 | 전일 확정 변경 반영 | PR_SSP_ANL_SHIP_PLAN_40_BALANCE | SSP_ANL_SHIP_CONFIRM | - | - |
| [40] | 6 | 결과 적재 | PR_SSP_ANL_SHIP_PLAN_40 | - | - | GT_SSP_ANL_SHIP_PLAN_40 |
| [81 계열 · 82] | 6 | 결과 적재 · Hold 이월 | PR_SSP_ANL_SHIP_PLAN_CUTOFF | - | - | GT_SSP_ANL_SHIP_PLAN_C |
| [81 계열 · 82] | 5 | 생산 기반 출하계획 | PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO | - | - | FP_AUTO_SHIP_FROM_TO |
| [81 계열 · 82] | 3 | 생산 기반 확정 | PR_SSP_ANL_SHIP_CONFIRM_BATCH_N_FP_AUTO | - | - | FP_AUTO_SHIP_FROM_TO |
| [전극] | 1 | 출하요청 생성(주 1회) | PR_SSP_ANL_SHIP_PLAN_EE | - | - | SCP_OPT_SHIPMENT_PLAN |

- 대조한 행 39 · 원천·대상이 모두 AS-IS 본문과 맞는 행 38 · 차이 있는 행 1 · 근거 `ssp_shipplan_crosscheck.csv`
- AS-IS 객체 카탈로그에 없는 테이블 이름 7종: DM_SHIP_OW_FROZEN(PR_SSP_ANL_SHIP_REQ_SEMI); FP_AUTO_SHIP_FROM_TO(PR_SSP_ANL_SHIP_CONFIRM_BATCH_N_FP_AUTO, PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO); GT_SSP_ANL_SHIP_PLAN_40(PR_SSP_ANL_SHIP_PLAN_40); GT_SSP_ANL_SHIP_PLAN_C(PR_SSP_ANL_SHIP_PLAN_CUTOFF); SCP_OPT_SHIPMENT_PLAN(PR_SSP_ANL_SHIP_PLAN_EE); SCP_OPT_SHIPMENT_PLAN_PEGGING_V(PR_SSP_ANL_SHIP_REQ_FG); SCP_OPT_SHIPMENT_PLAN_V(PR_SSP_ANL_SHIP_REQ_FG, PR_SSP_ANL_SHIP_REQ_P) — `GT_` 는 TO-BE 전역 임시 테이블. 나머지는 TO-BE 에서 이름이 다르거나 새로 생긴 객체일 수 있어 AS-IS 대응 객체 확인 대상
- 자료 칸에 함께 적힌 메저 · 컬럼 · 룩업 코드 이름 62건은 테이블이 아니라 대조에서 제외(CSV 에는 남김)
- 「본문에 없음」의 가능한 원인: 동적 SQL · 깊이 4 이상 호출 · TO-BE 변환에서 바뀐 이름 · 자료가 요약하며 넣은 관련 테이블. 건별 원인은 확인하지 않았다(미확인).

