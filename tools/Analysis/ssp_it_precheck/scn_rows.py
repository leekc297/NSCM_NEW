# -*- coding: utf-8 -*-
"""SSP 통합테스트 시나리오(e2e) 사전점검 시트 본문 — Cutoff 전 사전 점검 · 기준 정보 확인 · Shipment Plan 데이터 산출
열 = No · 단위 · 단위명 · 단계 · 테스트케이스 · 대상화면 · 수행방식 · 선행조건 · 결과(실제 결과 기록 칸, 비움) · PI 요청 테스트 반영
근거 = TO-BE 프로그램 원문(ZIOUI1 2026-11-23 14:09) · ZIOUI1 실측(14:10 ~ 14:32) · 「SSP 프로세스 확인 내용」 2026-11-20 판"""
import json, sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from vq_new import VQ
from vq_asis import ASIS

# 2026-11-26 R221(개선안 20261125102947_SELF_3): 실행 명령의 시험일 = 사용자 지정값. 사용 : python scn_rows.py <출력 json> <시험일 YYYYMMDD>
#   gen_sql_files.py 첫 인자(시험일)와 같은 값을 넣음. 날짜가 들어가는 실행 명령 문구는 TEST_DATE 를 씀
TEST_DATE = next((a for a in sys.argv[2:] if len(a) == 8 and a.isdigit()), None)
if __name__ == '__main__' and not TEST_DATE:
    print('[FAIL] 시험일(YYYYMMDD) 인자 없음. 사용 : python scn_rows.py <출력 json> <시험일 YYYYMMDD>')
    sys.exit(2)
TEST_DATE = TEST_DATE or '<시험일 YYYYMMDD>'

U = {'공통': '공통', '40': 'Mobility&IT', '81·82': 'Auto&ESS', 'Packer': 'Packer', '전극': 'Electrode'}
SECTIONS = []


def sec(title): SECTIONS.append({'title': title, 'rows': []})


def row(unit, stage, case, screen, how, pre):
    SECTIONS[-1]['rows'].append([unit, U[unit], stage, case, screen, how, pre])


# ─────────────────────────────────────────────────────────────────────────────
sec('■ CutOff 전 사전 점검 사항(진입조건 확인)')
row('공통', '실행 환경',
    'SSP 배치 프로그램 컴파일 상태 · 잡 사용 여부 · ERP 연계 차단 기간 확인\n'
    '[방법]\n1. 산출 · 재고 수신 프로그램 중 INVALID 조회\n2. SSP 잡 사용 여부 조회 후 시험 방식(잡 자동 수행, 수동 실행) 확정\n3. ERP 연계 차단 기간 조회\n'
    '[판정]\n1. INVALID 0건\n2. 잡 사용 여부가 시험 방식과 같음. 수동 실행이면 잡 실행문의 프로그램 순서대로 실행\n3. 시험 일시가 차단 기간 밖',
    'SCM0016(Batch Log)', '화면 및 SQL\n(VQ-33 / VQ-34 / VQ-22)',
    '운영 데이터 이관 완료\n2026-11-23 14:28 ZIOUI1 실측 : INVALID 0건, SSP 잡 46개 모두 사용 안 함(수동 실행 기준)')
row('공통', '실행 환경',
    '시험일 일 계획 ID · 일 마감 진행 행 · 산출 공통 코드 확인\n'
    f"[방법]\n1. 일 계획 ID 생성 프로그램 실행 후 사업부별 시험일 행 조회\n   BEGIN PR_SCM_MST_PLAN(P_PLAN_CYCLE => 'DAILY', P_PLAN_NAME => '{TEST_DATE}'); END;\n   (P_PLAN_NAME = 시험일)\n"
    '2. 81·82(SSP_MST_SHIP_PLAN_SCHEDULE) · 전극(SSP_MST_SHIP_PLAN_SCHEDULE_EE) 시험일 행 조회\n3. 법인 설명 · 시업 시각 · Packer 산출 기준일 · 통합 스냅샷 대상 코드 조회\n'
    '[판정]\n1. 40 시험일 일 계획 ID 1건(40 산출이 이 ID 아래 SP 행을 만듦)\n'
    '2. 법인 11개(GM00 · HD00 · HG00 · HM00 · HQ00 · MI00 · NA00 · NB00 · NJ00 · ST00 · WA00) 시험일 행 존재, CURRENT_PLAN_DATE_YN = N\n3. 산출 대상 법인의 코드 행 존재',
    'PR_SCM_MST_PLAN', '배치 실행 및 SQL\n(VQ-35 / VQ-18 / VQ-19 / VQ-44)',
    '2026-11-23 14:10 ZIOUI1 실측 : 일 계획 ID 최신 20261116(시험일 행 생성 필요). 진행 행은 2050-12-31 까지 등록되어 있고 2026-11-23 행은 11개 법인 모두 N')
row('공통', '진입 조건',
    '법인별 재고 수신 확인 표시 확인(사업부 산출 공통 진입 조건)\n'
    '[방법] 재고 수신 확인 표시(IF_STOCK_CHECK) 사용 행을 법인별로 조회. 미충족 법인은 재고 I/F 수신(No 8)을 다시 확인. 재고 수신이 안 되는 시험 환경이면 백업 후 해당 행의 수신일 · 수신 여부를 수동으로 완료 처리\n'
    '[판정] 산출 대상 법인 NOT_READY_CNT = 0\n- PLAN_40(40) · PLAN_AUTO(81·82) : 수신일(SEGMENT5) = 시험일 + 수신 여부(ATTRIBUTE1) = Y\n- PLAN_EE(전극) : 수신일 = 시험일',
    '-', 'SQL\n(VQ-36)',
    'No 8(재고 I/F 수신) 완료\n2026-11-23 14:10 ZIOUI1 실측 : 수신일 최신 20261117(40 MES), 20260822(그 외). 시험일 갱신 필요')
row('40', '진입 조건',
    '40 산출 진입 조건 확인(법인 HQ00 · AZ00 · NJ00)\n'
    '[방법] 법인별 3가지 조회\n1. 시험일 계획 시작일의 SHIP_CONFIRM 행 0건(SSP_ANL_SHIP_PLAN_40)\n2. 재고 수신 확인(PLAN_40) 미충족 0건\n3. 시험일 일 계획 ID 존재\n'
    '[판정] 법인 3개 READY_YN = Y. 1이 1건 이상이거나 2가 미충족이면 출하계획 생성 프로그램이 오류 없이 종료하고 산출하지 않음',
    'PR_SSP_ANL_SHIP_PLAN_40\nPR_SSP_ANL_SHIP_CONFIRM_BATCH_40', 'SQL\n(VQ-37)',
    'No 2 · No 3 충족\nAZ00 은 PLAN_40 행이 없어 재고 수신 확인 없이 진행(2026-11-23 실측)')
row('81·82', '진입 조건',
    '81·82 컷오프 진입 조건 확인(법인 11개)\n'
    '[방법] 법인별 3가지 조회\n1. 시험일 행 CURRENT_PLAN_DATE_YN = N\n2. 전일(시험일 - 1) ERP 재고(SCM_DNM_STOCK_V, INVENTORY) 1건 이상\n3. 재고 수신 확인(PLAN_AUTO) 미충족 0건\n'
    '[판정] 대상 법인 READY_YN = Y. 미충족 법인은 컷오프가 오류 없이 건너뜀',
    'PR_SSP_PLN_SHIP_PLAN_CUTOFF', 'SQL\n(VQ-38)',
    'No 2 · No 3 · No 9 충족\nHG00 은 PLAN_AUTO 행이 없어 1 · 2 만 판정(2026-11-23 실측)')
row('Packer', '진입 조건',
    'Packer 산출 진입 조건 · 기준일 확인\n'
    '[방법] Packer 산출 기준일 코드(SSP_ANL_SHIP_PLAN_P)와 기초재고 자료 조회\n'
    '[판정]\n1. 계획 기준일(시험일 - 1) > 최종 산출 기준일(ATTRIBUTE1) → READY_YN = Y\n2. 기초재고 기준일(시험일 - 3) SCS 재고(SCM_DNM_SCS_STOCK) 1건 이상\n재고 수신 확인 표시 조건은 없음',
    'PR_SSP_ANL_SHIP_PLAN_P', 'SQL\n(VQ-39)',
    'No 8 충족\n2026-11-23 실측 : 최종 산출 기준일 20260821')
row('전극', '진입 조건',
    '전극 산출 진입 조건 확인(법인별)\n'
    '[방법] 법인별 3가지 조회\n1. 시험일 행(SSP_MST_SHIP_PLAN_SCHEDULE_EE) CURRENT_PLAN_DATE_YN = N\n'
    '2. FP 실적 수신 완료 표시(FP 코드 AUTO_PLAN_CALL_FLAG 의 ATTRIBUTE1 = 시험일, 시업 시각 = BASIS_START_TIME_PLANT)\n3. 재고 수신 확인(PLAN_EE : IWMS · MES · OWMS) 행이 모두 수신일 = 시험일\n'
    '[판정] 대상 법인 READY_YN = Y. 조건을 충족한 법인만 산출하고 나머지는 건너뜀',
    'PR_SSP_ANL_SHIP_PLAN_EE', 'SQL\n(VQ-40)',
    'No 2 · No 3 충족, FP 실적 수신 완료(FP 담당 확인)\n2026-11-23 실측 : AUTO_PLAN_CALL_FLAG 최신 20261121')

# ─────────────────────────────────────────────────────────────────────────────
sec('■ 기준 정보 확인(재고등)')
row('공통', '재고',
    '사업부별 재고 I/F 수신 확인\n'
    '[방법] 재고 테이블별 기준일 자료 건수와 수신 시각 조회\n- 81·82 : SSP_DNM_OWMS_STOCK(전일) · SSP_DNM_GMES_STOCK_81_82(당일)\n'
    '- 전극 : SSP_DNM_GMES_STOCK_EE · SSP_DNM_IWMS_STOCK_EE · SSP_DNM_OWMS_STOCK_EE(당일)\n- 40 : SSP_DNM_GMES_STOCK_40(당일) · SSP_DNM_STOCK_C(전일) · SSP_DNM_OWMS_STOCK(전일)\n'
    '- Packer : SCM_DNM_SCS_STOCK(전일 수신분, 산출 기초재고는 시험일 - 3)\n'
    '[판정] 9행 모두 1건 이상, 수신 시각이 시험일(Packer 기초재고 행은 시험일 - 2 이전 수신분)\n[AS-IS 대조] AS-IS(운영) DB 에서 VQ-41 의 AS-IS SQL 을 실행해 테이블별 건수 · 수신 시각 비교. 산출 결과 차이를 입력 차이와 로직 차이로 가르는 근거',
    '-', 'SQL\n(VQ-41)',
    '운영 데이터 이관 또는 재고 수신 프로그램 실행\n기준일 규칙 = 「SSP 프로세스 확인 내용」 2026-11-20 판 8번 슬라이드\n2026-11-23 14:10 ZIOUI1 실측 : 최신 기준일 20260919 ~ 20261117(시험일 수신분 없음)')
row('81·82', '재고',
    '법인별 전일 ERP 재고 생성 확인\n'
    '[방법] SCM_DNM_STOCK_V(STOCK_TYPE = INVENTORY)의 시험일 - 1 자료를 법인별로 조회\n'
    '[판정] 81·82 컷오프 대상 11개 법인 모두 1건 이상. 조회되지 않는 법인은 컷오프가 진행되지 않음\n[AS-IS 대조] AS-IS(운영) DB 에서 VQ-42 의 AS-IS SQL 을 실행해 법인별 건수 · 수량 비교. 산출 결과 차이를 입력 차이와 로직 차이로 가르는 근거',
    'PR_SCM_DNM_STOCK_V', 'SQL\n(VQ-42)',
    'ERP 기말 재고 수신 후 PR_SCM_DNM_STOCK_V 실행\n2026-11-23 14:10 ZIOUI1 실측 : 법인별 최신 20261119 ~ 20261120')
row('공통', '계획 입력',
    '산출 입력 자료 갱신 확인\n'
    '[방법] FP 확정 생산계획 · FP 출하가능량 · SCS 생산계획 · SCS 재고의 최종 생성 일시 조회\n'
    '[판정] 4개 자료 최종 생성 일시가 시험일\n[AS-IS 대조] AS-IS(운영) DB 에서 VQ-43 의 AS-IS SQL 을 실행해 자료별 건수 · 기간 비교. 산출 결과 차이를 입력 차이와 로직 차이로 가르는 근거',
    'JOB_PR_SSP_DNM_FP_PLAN_FROZEN\nJOB_PR_SSP_XIF_FP_AMEND_SHIPAVAL\nJOB_PR_SCM_DNM_SCS_PROD_PLAN\nJOB_PR_SCM_DNM_SCS_STOCK', 'SQL\n(VQ-43)',
    'FP · SCS 수신 프로그램 실행(왼쪽 잡의 실행문)\n2026-11-23 14:28 ZIOUI1 실측 : 최종 생성 2026-10-10(FP 출하가능량 2026-08-11)')
row('공통', '계획 입력',
    '사업부별 선적요청(Shipment Request) 존재 확인\n'
    '[방법] 테스트품목 시트 품목의 시험일 이후 선적요청 조회\n- 40 · 81 · 82 : DM_PLN_SHIPMENT_REQ\n- Packer : SSP_ANL_SHIP_REQ_P\n- 전극 : SSP_ANL_SHIP_REQ_EE\n'
    '[판정] 사업부마다 시험일 이후 선적요청 1건 이상, 화면 수량 = 쿼리 수량\n[AS-IS 대조] AS-IS(운영) DB 에서 VQ-27 의 AS-IS SQL 을 실행해 테스트품목의 일자별 선적요청 수량 비교. 산출 결과 차이를 입력 차이와 로직 차이로 가르는 근거',
    'SSP0026(Shipment Request(Mobility & IT))\nDMF0045(Shipment Request(Auto & ESS))\nSSP0045(Shipment Request SEMI)\nSSP0022(Shipment Request(Electrode))', '화면 및 SQL\n(VQ-27)',
    'SCP FINAL 확정 연계 · 운영 데이터 이관 완료')
row('공통', '기준정보',
    '경로 · 물류 기준정보 확인\n'
    '[방법] 테스트품목 시트 품목의 From Site → To Site 로 화면 조회\n'
    '[판정]\n1. BOD 행 존재 · 유효\n2. Distribution Route 운송 방법 · 리드타임 등록\n3. Shipment Lot Size 등록(81·82 CONTAINER 계산에 사용)\n없으면 등록 후 시작',
    'SCP0007(BOD)\nSCP0005(Distribution Route)\nSCP0028(Shipment Lot Size)', '화면', '-')
row('공통', '기준정보',
    '담당 · 달력 기준정보 확인\n'
    '[방법] 테스트품목 · 테스트계정 시트 기준으로 화면 조회\n'
    '[판정]\n1. Shipment Model PIC : 시험 품목 담당자 지정\n2. Delegate : 승인자 · 위임자 지정\n3. Shipment Working Day : 시험일이 출하 가능일\n4. 전극 : Shipment Master Electrode 품목 행 존재, Shipment Requestor PIC 지정',
    'SSP0014(Shipment Model PIC)\nSSP0020(Delegate)\nSSP0005(Shipment Working Day)\nSSP0024(Shipment Master Electrode)\nSSP0025(Shipment Requestor PIC)', '화면', '-')
row('공통', '기준선',
    '시험 전 집계 저장\n'
    '[방법] 산출 실행 전에 확정(R · C · P) · 출하요청 · 출하계획 테이블별 집계를 실행하고 결과를 파일로 저장\n'
    '[판정] 집계 3종 저장 완료. 사업부별 시나리오 종료 후 회귀 비교 기준으로 사용',
    '-', 'SQL\n(VQ-29 / VQ-30 / VQ-31)', 'No 1 ~ No 13 완료, 산출 실행 전')

# ─────────────────────────────────────────────────────────────────────────────
sec('■ Shipment Plan 데이터 산출(사업부별 일 산출)')
# 40
row('40', '진입 조건 미충족',
    '재고 수신 확인 미충족 상태에서 40 출하계획 생성 실행 → 건너뜀 확인\n'
    "[방법] 법인 NJ00 의 PLAN_40 재고 수신 확인이 미충족인 상태에서 출하계획 생성 프로그램만 실행\n   BEGIN PR_SSP_ANL_SHIP_PLAN_40(P_DIVISION_ID => '40', P_COMPANY_ID => 'NJ00'); END;\n"
    '[판정] 오류 없이 종료, 실행 로그에 새 START 없음, 시험일 계획 시작일 NJ00 행 미생성',
    'PR_SSP_ANL_SHIP_PLAN_40', '배치 실행 및 SQL\n(VQ-37 / VQ-17 / VQ-45)',
    'No 3 조치 전(NJ00 미충족) 상태\n확정 반영 프로그램(PR_SSP_ANL_SHIP_CONFIRM_BATCH_40)은 재고 수신 확인을 보지 않으므로 이 케이스에서는 실행하지 않음')
row('40', '산출 실행',
    '40 산출 배치 법인 순서 실행(HQ00 → AZ00 → NJ00)\n'
    '[방법] 잡 실행문 순서대로 실행\n'
    '- HQ00 : 잔량 정리(PR_SSP_ANL_SHIP_PLAN_40_BALANCE) → 확정 반영(PR_SSP_ANL_SHIP_CONFIRM_BATCH_40) → 출하계획 생성(PR_SSP_ANL_SHIP_PLAN_40) → 선적요청 부족 메일(PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40)\n'
    '- AZ00 : 확정 반영 → 출하계획 생성 → 선적요청 부족 메일\n'
    '- NJ00 : 확정 반영 → 출하계획 생성 → 재고 원장(PR_SSP_ANL_INVENTORY_RAW) → 선적요청 부족 메일\n'
    '[판정] 법인마다 START · END 로그, 오류 코드 없음. 일 계획 SP 행 PLAN_STATUS 0(수행 중) → 1(완료)',
    'JOB_PR_SSP_PLN_SHIP_PLAN_40\nJOB_PR_SSP_PLN_SHIP_PLAN_40_AZ\nJOB_PR_SSP_PLN_SHIP_PLAN_40_C', '배치 실행\n(VQ-17 / VQ-35)',
    'No 4 법인 3개 READY_YN = Y\n테스트케이스 시트 「40 출하계획 컷오프」와 같은 실행\n운영 시각 08:00 · 10:30 · 11:00')
row('40', '산출 결과',
    '40 출하계획 생성 결과 구성 확인\n'
    '[방법] 시험일 계획 시작일 행을 법인 · Measure 별로 조회, SSP0015 에서 테스트품목 수량 대조\n'
    '[판정]\n1. 계획 시작일 = 시험일, 법인 3개 모두 행 생성\n2. 기간 = 계획 시작일 - 1 ~ + 83일\n'
    '3. Measure = SHIP_REQ · SHIP_CONFIRM · POSTP_PLAN · WH_IN · PROD_PLAN · PROD_DATE · LOT · INCO_WIP · INSP_WIP · MES_FCS_HOLD · MES_FCS_RELEASE · WH_STOCK · BALANCE(자료가 있는 Measure 만 생성)\n'
    '4. 화면 품목 · 일자 수량 = 쿼리 수량',
    'SSP0015(Shipment Plan(Mobility & IT))', '화면 및 SQL\n(VQ-45 / VQ-23)',
    '40 산출 실행 완료\n기간 · Measure 는 2026-10-09 산출분 실측 기준')
row('40', '산출값 검증',
    '40 당일 BALANCE 산식 확인\n'
    '[방법] 시험일 일자의 BALANCE 와 WH_STOCK - SHIP_CONFIRM - POSTP_PLAN 을 법인 · From Site · 품목 단위로 비교\n'
    '[판정] 불일치 0건',
    '-', 'SQL\n(VQ-46)',
    '40 산출 실행 완료\n2026-10-09 산출분 대입 결과 당일 71건 중 불일치 0건')
row('40', '산출값 검증',
    '40 산출 결과 AS-IS 같은 기준일 대조\n'
    '[방법]\n1. AS-IS(운영) DB 에서 VQ-45 의 AS-IS SQL 실행(계획 시작일 = 시험일)\n2. TO-BE 에서 VQ-45 실행(같은 계획 시작일)\n3. 두 결과를 법인 · Measure 별 건수 · 수량 합계로 비교. 차이 Measure 는 품목 · 일자 단위로 추적\n'
    '[판정] 법인 · Measure 별 건수 · 수량 일치. 차이는 입력 차이(재고 · 선적요청 · FP 계획 시점)와 로직 차이로 구분해 기록',
    'SSP0015(Shipment Plan(Mobility & IT))', 'SQL\n(VQ-45 / VQ-31)',
    '같은 날 AS-IS 운영 산출 완료, 입력 자료가 같은 시점으로 이관됨')
row('40', '재실행',
    '같은 날 40 산출 재실행 시 중복 생성 없음 확인\n'
    '[방법] 40 산출 실행 완료 후 HQ00 확정 반영 · 출하계획 생성을 다시 실행\n'
    '[판정] 두 프로그램 모두 바로 종료(새 START 로그 없음), 법인 · Measure 별 건수와 최종 변경 일시 변화 없음',
    'PR_SSP_ANL_SHIP_CONFIRM_BATCH_40\nPR_SSP_ANL_SHIP_PLAN_40', '배치 실행 및 SQL\n(VQ-17 / VQ-45)', '40 산출 실행 완료')
# 81·82
row('81·82', '진입 조건 미충족',
    '진입 조건 미충족 법인 건너뜀 확인\n'
    '[방법] 법인 1개(예 : ST00)의 PLAN_AUTO 재고 수신 확인을 미충족으로 둔 상태에서 컷오프 실행\n'
    '[판정]\n1. 해당 법인 시험일 행 진행 표시 변화 없음(N), 출하계획 미생성\n2. 충족 법인은 정상 진행, 프로그램 오류 없음\n3. 해당 법인 조건 충족 후 다시 실행하면 그 법인만 진행',
    'PR_SSP_PLN_SHIP_PLAN_CUTOFF', '배치 실행 및 SQL\n(VQ-38 / VQ-54 / VQ-48)', 'No 5 에서 1개 법인만 미충족')
row('81·82', '산출 실행',
    '81·82 컷오프 실행 · 법인별 단계 순서 확인\n'
    '[방법] PR_SSP_PLN_SHIP_PLAN_CUTOFF 실행. 조건 충족 법인마다 아래 순서로 진행\n'
    'ERP 재고 확인 → OWMS 재고 마감 → 출하계획 마감(PR_SSP_ANL_SHIP_PLAN_CUTOFF · _FP_AUTO) → 확정 반영(PR_SSP_ANL_SHIP_CONFIRM_BATCH_N · _FP_AUTO) → 음수재고 · 삭제 대상 메일 → 완료 표시 → 82 SCS 팩 출하계획 송신 자료\n'
    '[판정]\n1. 실행 로그 START · TXN · END, 오류 없음\n2. 시험일 행 : ERP_STOCK_CUTOFF_YN · OWMS_STOCK_CUTOFF_YN · CURRENT_PLAN_DATE_YN = Y\n'
    '3. 전일 행(시험일 - 1) : PLAN_CUTOFF_CREATE_YN · CONFIRM_CREATE_YN · FP_TARGET_SEND_YN = Y',
    'PR_SSP_PLN_SHIP_PLAN_CUTOFF', '배치 실행 및 SQL\n(VQ-17 / VQ-54)',
    'No 5 READY_YN = Y\n테스트케이스 시트 「81·82 출하계획 컷오프」와 같은 실행\n운영 주기 05:07 부터 10분\n계획 · 확정 · FP 목표 표시는 프로그램이 전일 행에 기록함(AS-IS 와 같음)')
row('81·82', '산출 결과',
    'OWMS 재고 마감 자료 생성 확인\n'
    '[방법] SSP_ANL_OWMS_STOCK_C2 를 법인 · 사업부 별로 조회\n'
    '[판정] 컷오프 완료 법인마다 행 존재, CUTOFF_DATE = 시험일 - 1, PLAN_START_YYYYMMDD = 시험일. 이미 있는 법인은 다시 만들지 않음\n[AS-IS 대조] AS-IS(운영) DB 에서 VQ-47 의 AS-IS SQL 을 같은 기준일로 실행해 법인 · 사업부 별 건수 · 재고 수량 비교',
    '-', 'SQL\n(VQ-47)', '81·82 컷오프 실행 완료, SSP_DNM_OWMS_STOCK 전일 자료 존재(No 8)')
row('81·82', '산출 결과',
    '81·82 출하계획 마감 결과 구성 확인\n'
    '[방법] SSP_ANL_SHIP_PLAN_C 를 법인 · 사업부 · Measure 별로 조회, SSP0021 · SSP0060 에서 테스트품목 수량 대조\n'
    '[판정]\n1. 계획 시작일 = 시험일 - 1, 컷오프 완료 법인 · 사업부(81 · 81_HD · 81_HG · 81_HM · 81_ST · 81_UC · 82) 행 생성\n2. 기간 = 계획 시작일 ~ + 55일(56일)\n'
    '3. Measure 7종 = SHIP_REQ · SHIP_PLAN · INTN_MOVEMENT · PROD_PLAN · WH_STOCK · BALANCE · CONTAINER\n4. 화면 품목 · 일자 수량 = 쿼리 수량',
    'SSP0021(Shipment Plan(Auto & ESS))\nSSP0060(Shipment Plan(Auto & ESS)-WA_UC)', '화면 및 SQL\n(VQ-48 / VQ-24)',
    '81·82 컷오프 실행 완료\n기간 · Measure 는 2026-08-20 산출분 실측 기준')
row('81·82', '산출값 검증',
    '81·82 BALANCE 산식 확인\n'
    '[방법] 일자별 BALANCE 와 WH_STOCK - SHIP_PLAN 을 법인 · 사업부 · From Site · 품목 단위로 비교\n'
    '[판정] 불일치 0건',
    '-', 'SQL\n(VQ-49)', '81·82 컷오프 실행 완료\n2026-08-20 산출분 대입 결과 15,120건 중 불일치 0건')
row('81·82', '산출값 검증',
    '81·82 산출 결과 AS-IS 같은 기준일 대조\n'
    '[방법]\n1. AS-IS(운영) DB 에서 VQ-48 의 AS-IS SQL 실행(계획 시작일 = 시험일 - 1)\n2. TO-BE 에서 VQ-48 실행(같은 계획 시작일)\n3. 두 결과를 법인 · 사업부 · Measure 별 건수 · 수량 합계로 비교. FP 생산기반 대상 경로(FP_AUTO_SHIP_FROM_TO)는 따로 구분해 비교\n'
    '[판정] 건수 · 수량 일치. 차이는 입력 차이와 로직 차이로 구분해 기록',
    'SSP0021(Shipment Plan(Auto & ESS))', 'SQL\n(VQ-48 / VQ-31)', '같은 날 AS-IS 운영 산출 완료, 입력 자료가 같은 시점으로 이관됨')
row('81·82', '재실행',
    '같은 날 81·82 컷오프 재실행 시 중복 생성 없음 확인\n'
    '[방법] 모든 법인 완료 후 컷오프를 다시 실행\n'
    '[판정] 대상 법인 0개(시험일 행이 모두 Y), 출하계획 · OWMS 재고 마감 건수와 최종 변경 일시 변화 없음',
    'PR_SSP_PLN_SHIP_PLAN_CUTOFF', '배치 실행 및 SQL\n(VQ-54 / VQ-47 / VQ-48)', '81·82 컷오프 실행 완료')
# Packer
row('Packer', '산출 실행',
    'Packer 산출 실행\n'
    '[방법] 출하계획 생성(PR_SSP_ANL_SHIP_PLAN_P) → 확정 반영(PR_SSP_ANL_SHIP_CONFIRM_P) 순서로 실행\n'
    '[판정]\n1. 실행 로그 START · TXN · END, 오류 없음\n2. Packer 산출 기준일 코드(SSP_ANL_SHIP_PLAN_P)의 ATTRIBUTE1 이 시험일 - 1 로 갱신',
    'JOB_PR_SSP_PLN_SHIP_PLAN_P', '배치 실행 및 SQL\n(VQ-17 / VQ-39)',
    'No 6 READY_YN = Y\n테스트케이스 시트 「Packer 출하계획 컷오프」와 같은 실행\n운영 시각 07:15')
row('Packer', '산출 결과',
    'Packer 출하계획 생성 결과 구성 확인\n'
    '[방법] SSP_ANL_SHIP_PLAN_P 를 Measure 별로 조회\n'
    '[판정]\n1. 계획 시작일 = 시험일 - 1\n2. 기간 = 계획 시작일 - 1 ~ + 55일(57일)\n3. Measure 6종 = SHIP_REQ · SHIP_CONFIRM · SHIP_RTF · PROD_PLAN · WH_STOCK · BALANCE',
    '-', 'SQL\n(VQ-50 / VQ-25)', 'Packer 산출 실행 완료\n기간 · Measure 는 2026-10-09 산출분 실측 기준')
row('Packer', '산출값 검증',
    'Packer BALANCE 산식 확인 · AS-IS 같은 기준일 대조\n'
    '[방법]\n1. 일자별 BALANCE 와 WH_STOCK - SHIP_CONFIRM 을 From Site · 품목 단위로 비교\n2. AS-IS(운영) DB 에서 VQ-50 의 AS-IS SQL, TO-BE 에서 VQ-50 을 같은 계획 시작일(시험일 - 1)로 실행해 Measure 별 건수 · 수량 합계 비교\n'
    '[판정]\n1. 불일치 0건\n2. 건수 · 수량 일치. 차이는 입력 차이와 로직 차이로 구분해 기록',
    '-', 'SQL\n(VQ-51 / VQ-50 / VQ-31)', 'Packer 산출 실행 완료\n2026-10-09 산출분 대입 결과 2,394건 중 불일치 0건')
row('Packer', '재실행',
    '같은 날 Packer 산출 재실행 시 건너뜀 확인\n'
    '[방법] Packer 산출 실행 완료 후 출하계획 생성을 다시 실행\n'
    '[판정] 바로 종료(계획 기준일 ≤ 최종 산출 기준일), 건수와 최종 변경 일시 변화 없음',
    'PR_SSP_ANL_SHIP_PLAN_P', '배치 실행 및 SQL\n(VQ-39 / VQ-50)', 'Packer 산출 실행 완료')
# 전극
row('전극', '진입 조건 미충족',
    'FP 실적 수신 완료 표시가 없는 법인 건너뜀 확인\n'
    '[방법] 일부 법인만 진입 조건(No 7)을 충족한 상태에서 전극 산출 실행\n'
    '[판정] 충족 법인만 진행 표시 P → Y. 미충족 법인은 시험일 행 N 유지, 출하계획 미생성. 충족 법인이 없으면 로그 없이 종료',
    'PR_SSP_ANL_SHIP_PLAN_EE', '배치 실행 및 SQL\n(VQ-40 / VQ-54)', 'No 7 에서 일부 법인만 충족')
row('전극', '산출 실행',
    '전극 산출 실행 · 법인별 진행 확인\n'
    '[방법] PR_SSP_ANL_SHIP_PLAN_EE 실행. 법인마다 아래 순서로 진행\n'
    '기준 자료 생성(기초재고 마감 · FP 계획 · SCP 목표 · 출하요청 · 재고 상세 마감) → Measure 생성(요청용 R · 계획용 P) → 전일 마감분 생성 → 확정 반영 · ERP 송신 자료\n'
    '[판정]\n1. 실행 로그 START · END, 오류 없음\n2. 시험일 행 CURRENT_PLAN_DATE_YN = P(진행 중) → Y\n3. 전일 행(시험일 - 1) PLAN_CUTOFF_CREATE_YN · CONFIRM_CREATE_YN = Y',
    'PR_SSP_ANL_SHIP_PLAN_EE', '배치 실행 및 SQL\n(VQ-17 / VQ-54)',
    'No 7 READY_YN = Y\n테스트케이스 시트 「전극 출하계획 컷오프」와 같은 실행\n운영 주기 10분, 법인 시업 시각 이후')
row('전극', '산출 결과',
    '전극 출하계획 생성 결과 구성 확인\n'
    '[방법] SSP_ANL_SHIP_PLAN_EE 와 기초재고 마감 · 재고 상세 마감을 법인 별로 조회, SSP0023 · SSP0022 에서 테스트품목 수량 대조\n'
    '[판정]\n1. 계획 시작일 = 시험일, 산출 법인마다 행 생성\n2. 요청용(R) Measure 10종 · 계획용(P) Measure 11종\n'
    '3. 기초재고 마감(SSP_ANL_BOH_CUTOFF_EE) · 재고 상세 마감(SSP_ANL_STOCK_EE_C) 시험일 행 생성\n4. 화면 품목 · 일자 수량 = 쿼리 수량\n[AS-IS 대조] AS-IS(운영) DB 에서 VQ-53 의 AS-IS SQL 을 같은 기준일로 실행해 기초재고 마감 · 재고 상세 마감의 법인 별 건수 · 수량 비교',
    'SSP0023(Shipment Plan(Electrode))\nSSP0022(Shipment Request(Electrode))', '화면 및 SQL\n(VQ-52 / VQ-53 / VQ-26)',
    '전극 산출 실행 완료\nMeasure 종류는 2026-10-09 산출분 실측 기준')
row('전극', '산출값 검증',
    '전극 산출 결과 AS-IS 같은 기준일 대조\n'
    '[방법]\n1. AS-IS(운영) DB 에서 VQ-52 의 AS-IS SQL 실행(계획 시작일 = 시험일)\n2. TO-BE 에서 VQ-52 실행(같은 계획 시작일)\n3. 두 결과를 법인 · 사업부 · Measure 별 건수 · 수량 합계로 비교\n'
    '[판정] 건수 · 수량 일치. 차이는 입력 차이와 로직 차이로 구분해 기록',
    'SSP0023(Shipment Plan(Electrode))', 'SQL\n(VQ-52 / VQ-31)', '같은 날 AS-IS 운영 산출 완료, 입력 자료가 같은 시점으로 이관됨')
row('전극', '재실행',
    '같은 날 전극 산출 재실행 시 중복 생성 없음 확인\n'
    '[방법] 완료 법인이 있는 상태에서 전극 산출을 다시 실행\n'
    '[판정] 완료 법인(시험일 행 Y)은 대상에서 빠지고 건수와 최종 변경 일시 변화 없음',
    'PR_SSP_ANL_SHIP_PLAN_EE', '배치 실행 및 SQL\n(VQ-54 / VQ-52)', '전극 산출 실행 완료')
# 공통
row('공통', '통합',
    '사업부별 출하계획 · 확정 통합 스냅샷 생성 확인\n'
    '[방법] 아래 문장 실행\n   BEGIN PR_SSP_ANL_SHIP_PLAN_ALL(P_PLAN_START_YYYYMMDD => NULL); END;\n'
    '[판정]\n1. SSP_ANL_SHIP_PLAN_ALL 에 계획 시작일 = 시험일 - 1 행이 산출을 마친 사업부 · 법인마다 생성\n'
    '2. 통합 스냅샷 대상 코드(SSP_ANL_SHIP_PLAN_ALL)의 ATTRIBUTE1 이 시험일 - 1 로 갱신\n3. 다시 실행하면 이미 만든 대상은 제외\n[AS-IS 대조] AS-IS(운영) DB 에서 VQ-55 의 AS-IS SQL 을 같은 기준일로 실행해 사업부 · 법인 별 건수 · 확정 수량 비교',
    'PR_SSP_ANL_SHIP_PLAN_ALL', '배치 실행 및 SQL\n(VQ-55 / VQ-44)', '사업부별 산출 실행 완료\n운영 주기 30분')
row('공통', '산출 결과',
    '산출 배치가 만든 확정 원장 확인(테스트케이스 시트 연결 지점)\n'
    '[방법] 시험일에 배치(ssp_batch)가 만든 확정 행을 사업부 · 상태 별로 조회\n'
    '[판정] 확정구간에 들어온 선적요청이 있는 사업부에 확정 행 생성. 이후 화면 조회 · 수정 · ERP 송신 검증은 테스트케이스 시트에서 수행\n[AS-IS 대조] AS-IS(운영) DB 에서 VQ-56 의 AS-IS SQL 을 같은 기준일로 실행해 사업부 · 상태 별 확정 건수 · 수량 비교',
    '-', 'SQL\n(VQ-56 / VQ-01)', '사업부별 산출 실행 완료')
row('공통', '감시',
    '일 마감 지연 문자 적재 확인\n'
    '[방법] 1개 법인을 미완료로 둔 상태에서 그 법인의 초과 기준 시각 직후 10분 안에 PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND 실행\n'
    '초과 기준 시각 예 : 81·82 HQ00 07:30 · NJ00 10:40, 전극 HQ00 07:50, 40 HQ00 08:10 · AZ00 10:40 · NJ00 11:10\n'
    '[판정] 미완료 법인 문구 「[사업부 구분 CUTOFF DELAY - 법인]」 적재, 완료 법인은 적재 없음',
    'PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND', '배치 실행 및 SQL\n(VQ-57)', '문자 수신자 등록\n운영 주기 10분')
row('공통', '오류 처리',
    '산출 중 오류 발생 시 처리 확인(오류가 발생한 경우에 수행)\n'
    '[방법] 실행 로그 ERROR 행과 진행 표시 · 문자 적재 조회\n'
    '[판정]\n- 40 : 일 계획 SP 행 PLAN_STATUS = -1, 오류 문자 적재\n- 81·82 : 그 회차 전체 ROLLBACK(진행 표시 · 출하계획 변화 없음), ERROR 로그, 오류 문자 적재\n'
    '- 전극 : 해당 법인 시험일 행 CURRENT_PLAN_DATE_YN = E, 오류 문자 적재\n원인 조치 후 재실행 방법은 DB 담당과 확정',
    '-', 'SQL\n(VQ-17 / VQ-35 / VQ-54 / VQ-57)', '산출 실행 중 ERROR 로그 발생')
row('공통', '재시험 준비',
    '재시험 준비(재시험 때만 수행)\n'
    '[방법] 산출 실행 전 DB 백업 지점으로 되돌린 뒤 No 1 부터 다시 수행\n'
    '[판정] No 14 시험 전 집계가 처음 저장한 값과 같음\n진행 표시 · 기준일 코드만 되돌리는 방식은 확정 원장 · ERP 송신 자료 중복 여부가 미확인이라 사용하지 않음',
    '-', 'SQL\n(VQ-29 / VQ-30 / VQ-31)', '산출 실행 전 백업(DB 담당)')

if __name__ == '__main__':
    out = {'sections': SECTIONS,
           'vq': [{'id': v[0], 'cat': v[1], 'what': v[2], 'tabs': v[3], 'point': v[4], 'sql': v[5]} for v in VQ],
           'asis': {k: v[0] for k, v in ASIS.items()},
           'asis_note': '※ AS-IS SQL(MSSQL) 열 : TO-BE 와 대조할 쿼리 13개(VQ-27 · 31 · 41 · 42 · 43 · 45 · 47 · 48 · 50 · 52 · 53 · 55 · 56). 같은 번호의 TO-BE SQL 과 결과 열 이름 · 정렬이 같음. 맨 위 DECLARE 값만 바꿔 AS-IS 운영 DB 에서 실행. __ASIS_TEST__',
           'vq_note': '※ VQ-33 ~ VQ-57(사전점검 시트용)은 2026-11-23 14:28 ~ 14:37 ZIOUI1 에서 25개 모두 오류 없이 실행 확인. :TEST_DATE = 시험일(YYYYMMDD), :PLAN_START = 계획 시작일(40 · 전극 = 시험일, 81·82 · Packer = 시험일 - 1).'}
    json.dump(out, open(sys.argv[1], 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    n = sum(len(s['rows']) for s in SECTIONS)
    print('sections', [(s['title'], len(s['rows'])) for s in SECTIONS], 'rows', n, 'vq', len(VQ))
    # 참조 검사 : 본문이 쓰는 VQ 가 모두 있는지(기존 VQ-01 ~ 32 + 추가분)
    import re
    have = {f'VQ-{i:02d}' for i in range(1, 33)} | {v[0] for v in VQ}
    used = set(re.findall(r'VQ-\d+', json.dumps(SECTIONS, ensure_ascii=False)))
    print('없는 VQ 참조', sorted(used - have), '· 본문에서 안 쓰는 추가 VQ', sorted({v[0] for v in VQ} - used))
    print('SQL 최대 줄 수', max((v[5].count('\n') + 1, v[0]) for v in VQ))
