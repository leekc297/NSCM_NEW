# -*- coding: utf-8 -*-
"""DM 운영자 매뉴얼 내용(TO-BE 기준, 2026-11-24). VMW AI 단계를 세션에서 수행한 결과를 content/chapters.json 으로 씀"""
import csv, json, os, re, shutil

D = r'c:\Projects\NSCM\Doc\OpsManual\DM'
F = lambda n: f'Doc/OpsManual/DM/facts/{n}'
rd = lambda n: list(csv.DictReader(open(os.path.join(D, 'facts', n), encoding='utf-8-sig')))
J = rd('jobs.csv'); S = rd('screens.csv'); T = rd('tables.csv'); B = rd('batch.csv')
jobs = [j['job'] for j in J]

# ───────── 프로세스 묶음(TO-BE 잡 63개)
P_ORDER = ['기준 정보 동기화', '인터페이스 수신', '주간 롤링 시작', 'MKT FCST 컷오프', 'Sales Plan 컷오프', '계획 확정(SCP 연계)', '인터페이스 송신', '분석과 KPI', 'PR 자동 요청', '메일과 SMS 알림']
RULE = [
    ('PR 자동 요청', r'^JOB_DMF0070_'),
    ('주간 롤링 시작', r'MST_CUST_FCST_WEEKLY_ROLLING_MON_TOTAL|PLN_ESS_VMI_REFRESH'),
    ('MKT FCST 컷오프', r'PLN_MKT_FCST_WEEKLY_ROLLING|DNM_EDI_CUTOFF|CUTOFF_DATA_CLEANSING'),
    ('Sales Plan 컷오프', r'PLN_SALES_PLAN_WEEKLY_ROLLING'),
    ('계획 확정(SCP 연계)', r'PLAN_FINAL_\d+_CREATION'),
    ('인터페이스 송신', r'TO_XIF_PLM_PLAN_S|TO_XIF_DM_SSPM_CELL_CAR_S|BPS_INTERFACE'),
    ('분석과 KPI', r'_ANL_|BI_FULFILL|HI_RATIO'),
    ('메일과 SMS 알림', r'SMS_SEND|MAIL_SEND|ESS_MAIL'),
    ('기준 정보 동기화', r'4MCC|CUST_MODEL_MAPPING|HI_STANDARD|FINAL_ITEM_BOM|EDI_CUST_MATERIAL|EDI_UNLOADING'),
    ('인터페이스 수신', r'EDI_CALLOFF|SALES_RESULT|RFC_|SM_JOB|ADJUSTED_MKT_FCST|SSP_SYNC'),
]
processOf = {}
for j in jobs:
    processOf[j] = next(p for p, rx in RULE if re.search(rx, j))
cnt = {p: sum(1 for v in processOf.values() if v == p) for p in P_ORDER}
assert sum(cnt.values()) == 63, cnt

# ───────── 잡 설명(설명 없는 TO-BE 잡 전부)
JN = {
    'JOB_DMF0070_AUTO_PR_REQUEST': 'MKT FCST 기준 PR 요청 대상 생성. DM_PLN_PR_DETAIL, DM_PLN_AUTO_PR_CHECK 저장함',
    'JOB_DMF0070_AUTO_PR_REQUEST_MAIL': 'PR 요청 대상 추출 뒤 메일 발송. DM_PLN_AUTO_PR_CHECK 갱신함',
    'JOB_DMF0070_DIFF_QTY_MAIL_SEND_AUTO': 'MKT FCST 수량 차이 발생 건 메일 발송. 저장 테이블 없음',
    'JOB_LGCE_SCMPROD_PR_DM_PLN_ADJUSTED_MKT_FCST_R_TO_MKT_FCST': 'PLM 조정 FCST(XIF_PLM_ADJUSTED_MKT_FCST_R_SN) 수신 뒤 DM_PLN_MKT_FCST 반영. 1시간마다',
    'JOB_LGCE_SCMPROD_PR_DM_PLN_MKT_FCST_TO_XIF_PLM_PLAN_S': 'MKT FCST 를 PLM 송신 테이블 XIF_PLM_DM_PLN_MKT_FCST_PLAN_S 로 보냄. 매일 01:00',
    'JOB_PR_DM_4MCC_SCM_MST': '프로젝트, 사이트, 사이트 품목 기준 정보를 4MCC 송신 테이블 3개로 보냄',
    'JOB_PR_DM_ANL_KPI_RTF_SALES': 'Sales Plan 컷오프 기준 RTF 판매 KPI DM_ANL_KPI_RTF_SALES 생성',
    'JOB_PR_DM_ANL_MKT_PSI_DATA': 'MKT PSI DM_ANL_MKT_PSI 생성 뒤 DW 송신 테이블 2개로 보냄',
    'JOB_PR_DM_BI_FULFILL_CURRENT': 'Sales Plan 실적 기준 Fulfillment 현재분 DM_DNM_FULFILL 생성',
    'JOB_PR_DM_BI_FULFILL_GEN': 'Sales Plan 컷오프 기준 Fulfillment DM_DNM_FULFILL 생성',
    'JOB_PR_DM_BI_FULFILL_VMI': 'MKT FCST 컷오프 기준 VMI Fulfillment DM_DNM_FULFILL 생성',
    'JOB_PR_DM_BPS_INTERFACE': 'Metal Link 판가 컷오프 뒤 Sales Plan, 기타 판매, Metal Link 판가를 BPS 송신 테이블 3개로 보냄',
    'JOB_PR_DM_CHECK_BEFOREHAND_SMS_SEND': 'DM 배치 미실행, 오류 잡 확인 뒤 SMS 발송. 5분마다',
    'JOB_PR_DM_CUST_DEMAND_ANL_SUMMARY': '81 사업부 6개(81, UC, HM, ST, HD, HG) 고객 수요 요약 DM_CUST_DEMAND_ANL_SUMMARY 생성',
    'JOB_PR_DM_CUST_MODEL_MAPPING_IF': 'ERP 고객 모델 매핑 수신 뒤 DM_CUST_MODEL_MAPPING_M 저장',
    'JOB_PR_DM_CUTOFF_DATA_CLEANSING': '주간 컷오프 보관 기간이 지난 컷오프, 버전 데이터 정리',
    'JOB_PR_DM_DNM_EDI_CALLOFF': 'EDI Call-off 수신 뒤 고객 FCST 이력 DM_PLN_CUST_FCST_H 기록. 하루 여러 번',
    'JOB_PR_DM_DNM_EDI_CUTOFF': 'EDI Call-off 일 컷오프 DM_DNM_EDI_CALLOFF_ITEM_C 생성. 매일 06:15',
    'JOB_PR_DM_DNM_ERP_EDI_MST_SUMMARY_MAIL_SEND': 'ERP EDI 기준 정보 누락 요약 메일 발송. 매일 08:00',
    'JOB_PR_DM_DNM_ESS_MAIL': 'ESS 메일 발송 잡. 단계 PR_DM_DNM_ESS_MAIL_SEND 가 TO-BE 객체에 없음(확인 필요)',
    'JOB_PR_DM_DNM_EXCHANGE_RATE_MAIL_SEND': '환율 DM_MST_EXCHANGE_RATE 등록 현황 메일 발송. 수 23:40',
    'JOB_PR_DM_DNM_SALES_RESULT': 'ERP 매출 실적 수신 뒤 DM_DNM_SALES_RESULT_IF 저장. 하루 여러 번',
    'JOB_PR_DM_HI_RATIO_CREATE_BATCH': 'HI 고객 FCST 입력, MKT FCST 변경, 매출 입력 지표 3개 생성',
    'JOB_PR_DM_HI_STANDARD_CREATE_BATCH': 'HI 사이트 품목 매핑 DM_HI_SITE_ITEM_MAPPING 생성. 매일 04:00',
    'JOB_PR_DM_IF_CHECK_SMS_SEND': 'ERP 수신 테이블 3개 수신 여부 확인 뒤 SMS 발송. 1시간마다',
    'JOB_PR_DM_MST_CUST_FCST_WEEKLY_ROLLING_MON_TOTAL': '월요일 주간 롤링 9단계. 고객 FCST 롤링, MKT FCST, Sales Plan 결과 이동, 81, 82 MKT FCST 롤링',
    'JOB_PR_DM_MST_EDI_CUST_MATERIAL_INFO': 'ERP EDI 고객 자재 정보 수신 뒤 DM_MST_EDI_CUST_MATERIAL_INFO 저장. 1시간마다',
    'JOB_PR_DM_MST_EDI_UNLOADING_POINT': 'ERP EDI 하역지 수신 뒤 DM_MST_EDI_UNLOADING_POINT 저장. 1시간마다',
    'JOB_PR_DM_MST_FINAL_ITEM_BOM_UPDATE_BATCH': '최종 품목 BOM 기준으로 SCM_MST_SITE_ITEM 갱신. 1시간마다',
    'JOB_PR_DM_PLN_ESS_VMI_REFRESH': 'ESS VMI MKT FCST 갱신. 월 07:50, 08:50',
    'JOB_PR_DM_SM_JOB': 'NERP RFC 호출 뒤 자재 문서 SCM_DNM_MAT_DOCUMENT 반영. 일요일 4회',
    'JOB_PR_DM_SSP_SYNC': 'SSP 출하 확정, 출고 실적 기준 DM_PLN_MKT_FCST_CONFIRM 동기화',
    'JOB_PR_DM_TO_XIF_DM_SSPM_CELL_CAR_S': '사이트 품목 Cell Car 정보를 XIF_DM_SSPM_CELL_CAR_S_SN 으로 보냄',
    'JOB_PR_DM_UNLOGIN_MAIL_SEND': '3개월 미접속자 권한 회수 메일 발송. 매일 04:00',
    'JOB_RFC_PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT': 'NERP RFC 로 MDF 수신 뒤 DM_PLN_MDF_RESULT 저장. 매일 07:00',
    'JOB_RFC_XIF_ERP_MATERIAL_DOCUMENT_DM_R': 'NERP RFC 로 자재 문서 수신 뒤 SCM_DNM_MAT_DOCUMENT 이동. 매일 07:15',
    'JOB_SCMPROD_PLAN_FINAL_40_CREATION': '40 사업부 SCP 계획 엔진 제어 PR_SCP_ENG_CONTROL 뒤 MKT FCST 수량 균형 생성',
    'JOB_SCMPROD_PLAN_FINAL_81_CREATION': '81 사업부 SCP 계획 엔진 제어 PR_SCP_ENG_CONTROL 뒤 MKT FCST 수량 균형 생성',
}
for j in jobs:
    m = re.match(r'JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_(.+)$', j)
    if m and j not in JN:
        k = m.group(1)
        if k in ('TUE_TOTAL', 'TOTAL_MOBILE'):
            JN[j] = 'MKT FCST 일 컷오프(MF_D) 사업부별 단계 실행. 40 사업부 판가 반영 단계 포함'
        elif 'SCM_FCST' in k:
            JN[j] = f'SCM FCST 주간 컷오프(SF_W). 대상 {("40" if k == "TUE_SCM_FCST" else k.replace("TUE_SCM_FCST_", ""))} 사업부'
        else:
            JN[j] = f'MKT FCST 주간 컷오프(MF_W). 대상 {k.replace("MON_", "").replace("TUE_", "").replace("81_2", "81")} 사업부'
    m = re.match(r'JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_(.+)$', j)
    if m and j not in JN:
        k = m.group(1)
        JN[j] = f'{k} 사업부 Sales Plan 컷오프. RTF 확인, 수량 균형 생성' + ('' if k == '40' else ', 판가 없는 RTF 메일')
miss = [j for j in jobs if j not in JN]
assert not miss, miss

# ───────── 화면 역할(TO-BE 저장 테이블 기준, 사용 메뉴 29개)
SN = {
    'DMF0004': 'Sales Site, 고객, 위치, 버킷 변환 기준 정보 등록. SCM_MST_SITE, SCM_MST_SITE_CUSTOMER, DM_MST_BUCKET_CONVERSION 저장',
    'DMF0005': 'Sales Site 프로젝트 모델 등록. SCM_MST_SITE_ITEM 저장, 변경 이력 SCM_MST_SITE_ITEM_H',
    'DMF0005_01': 'ESS 사업부 Sales Site 프로젝트 모델 등록. DMF0005 와 같은 테이블 저장',
    'DMF0006': '고객 모델 매핑 DM_MST_CUSTOMER_MODEL 등록',
    'DMF0007': '고객 FCST 기준 DM_MST_CUSTOMER_FCST 등록. 저장 때 DM_PLN_MKT_FCST 함께 저장',
    'DMF0020': '판가 SCM_MST_FUTURE_PRICE, 환율 DM_MST_EXCHANGE_RATE, 확정 판가 DM_PLN_CFM_SELLING_PRICE 등록',
    'DMF0020_01': 'ESS 사업부 판가, 환율 등록. DMF0020 과 같은 테이블 저장',
    'DMF0083': '모델 그룹 판가 SCM_MST_FUTURE_PRICE_MDL_GR, 환율 DM_MST_EXCHANGE_RATE 등록',
    'DMF0043': '기여율 버전과 비율 DM_MST_CONTRIBUTE_VER, DM_MST_CONTRIBUTE_RATIO_MST, DM_MST_CONTRIBUTE_RATIO_DTL 등록',
    'DMF0043_01': '기여율 기준 판매 조회. 저장 테이블 없음(개인화 컬럼만)',
    'DMF0008': 'ERP EDI 기준 정보 검증, 보정. SCM_MST_SITE, SCM_MST_SITE_ITEM 과 이력 저장',
    'DMF0072': 'N:N 고객 모델 매핑 DM_CUST_MODEL_MAPPING_M 등록',
    'DMF0003': 'MKT FCST 입력. DM_PLN_MKT_FCST, PR 상세 DM_PLN_PR_DETAIL, MKT PSI 저장',
    'DMF0003_01': 'ESS 사업부 MKT FCST 입력. DMF0003 과 같은 테이블 저장',
    'DMF0048': 'Sales Plan 과 출하 실적 비교 조회. 저장 테이블 없음(개인화 컬럼만)',
    'DMF0014': '고객 FCST 엑셀 업로드. DM_PLN_CUSTOMER_PSI 와 이력 저장',
    'DMF0042': '사업 계획 DM_PLN_BP_FCST 입력, 사업 계획 컷오프 DM_PLN_BP_FCST_C 생성',
    'DMF0044': 'Sales Report 버전 생성, 조회. DM_MDF_VERSION, DM_PLN_SALES_PLAN_REPORT_C 저장',
    'DMF0049': '기타 매출 Report DM_PLN_SALES_ETC_REPORT_C 저장, 조회',
    'DMF0074': 'Metal Link 판가 엑셀 업로드. DM_BPS_METAL_LINK_PRICE 와 이력 저장',
    'DMF0082': 'MKT FCST 와 판가 통합 관리. DM_PLN_MKT_FCST, DM_PLN_CFM_SELLING_PRICE, SCM_MST_FUTURE_PRICE 저장',
    'DMF0021': 'Sales Plan 입력. DM_PLN_SALES_PLAN, DM_PLN_SALES_ETC_PLAN, DM_PLN_CFM_MKT_DEMAND_PLAN 저장',
    'DMF0021_01': 'ESS 사업부 Sales Plan 입력. DMF0021 과 같은 테이블 저장',
    'DMF0035': 'MKT FCST, Sales Plan 버전별 변동 조회. 버전 DM_MST_VERSION 저장',
    'DMF0040': 'MKT FCST 버전 비교 조회. 저장 테이블 없음(개인화 컬럼만)',
    'DMF0068': '수주 관리 목록 저장, 삭제(JSON 저장 프로시저)',
    'DMF0053': '고객 FCST 버전별 변동 조회. 저장 테이블 없음(개인화 컬럼만)',
    'DMF0035_01': 'ESS 사업부 Waterfall 조회. DMF0035 와 같은 테이블 저장',
    'DMD0001': 'Report Dashboard 조회. 저장 버튼 없음',
}
assert set(SN) == {s['id'] for s in S}, set(s['id'] for s in S) ^ set(SN)

# ───────── 테이블 역할(이전 판 역할 문장 재사용 + 새 테이블)
old = json.load(open(os.path.join(D, 'content', 'chapters_bak_20261124_asis.json'), encoding='utf-8'))
TN = {}
NEW_T = {
    'DM_PLN_BP_FCST_C': '사업 계획 컷오프본', 'DM_MST_EXCHANGE_RATE_H': '환율 변경 이력', 'SCM_MST_FUTURE_PRICE_MDL_GR': '모델 그룹별 판가',
    'DM_BP_EXCHANGE_RATE_C': '사업 계획 환율 컷오프본', 'SCP_OPMZ_PLAN_CTRL_ACTV_M': 'SCP 계획 엔진 제어 활동', 'SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M': 'SCP 계획 엔진 제어 실행 이력',
    'SCP_OPMZ_PLAN_M': 'SCP 계획 엔진 계획 마스터', 'DM_BPS_METAL_LINK_PRICE': 'Metal Link 판가', 'DM_BPS_METAL_LINK_PRICE_H': 'Metal Link 판가 변경 이력',
    'XIF_PLM_ADJUSTED_MKT_FCST_R_SN': 'PLM 조정 FCST 수신 I/F', 'XIF_SCM_MST_PROJECT_4MCC_S_SN': '4MCC 프로젝트 송신 I/F', 'XIF_SCM_MST_SITE_4MCC_S_SN': '4MCC 사이트 송신 I/F',
    'XIF_SCM_MST_SITE_ITEM_4MCC_S_SN': '4MCC 사이트 품목 송신 I/F',
}
for t in T:
    if t['screenWrites'] or t['batchWrites']:
        TN[t['table']] = NEW_T.get(t['table']) or old['tableNotes'].get(t['table']) or ''
missing = [k for k, v in TN.items() if not v]
for k in missing:  # 이름으로 역할 적음(분류 + 접미사)
    suf = '컷오프본' if k.endswith('_C') else '이력' if k.endswith('_H') else '송신 I/F' if k.endswith('_S_SN') else '수신 I/F' if k.endswith('_R_SN') else ''
    TN[k] = (next((x['kind'] for x in T if x['table'] == k), '') + ' ' + suf).strip() or '확인 필요'
print('tableNotes', len(TN), 'by name', len(missing), missing)

src_j = [F('jobs.csv'), F('timeline.csv')]
src_b = [F('batch.csv'), F('sp_tables.csv')]

# ───────── C1 업무 개요
C1 = {'id': 'C1', 'title': '1. 업무 개요', 'slides': [
    {'kind': 'text', 'title': '1. 업무 개요', 'src': [F('screens.csv'), F('jobs.csv'), F('sp_tables.csv')], 'lines': [
        '맡는 업무: 고객 수요(MKT FCST)와 판매 계획(Sales Plan) 입력, 주간 컷오프, 판가와 환율 관리',
        '화면: 사용 메뉴 29개. Demand Master 12개, Demand Plan 11개, Waterfall 5개, Report 1개',
        '배치: TO-BE 잡 63개(SCM_MGR DBMS_SCHEDULER), 단계 113개, 실행 프로시저 54개',
        '받는 데이터: ERP EDI Call-off, 매출 실적, 자재 문서, MDF, PLM 조정 FCST, SSP 출하 확정',
        '보내는 데이터: PLM 계획, BPS 판매 계획과 Metal Link 판가, 4MCC 기준 정보, SSPM Cell Car, DW MKT PSI',
        'SCP 연계: PLAN_FINAL 잡이 PR_SCP_ENG_CONTROL 로 SCP_OPMZ_PLAN_M 저장 뒤 MKT FCST 수량 균형 생성',
        '사용 여부: 사내 TO-BE 잡 ENABLED 값은 운영 반영 전 값임. 운영 사용 여부 미확인',
    ]},
    {'kind': 'flow', 'title': '1. 업무 개요 - 주간 계획 주기', 'src': src_j, 'nodes': [
        {'id': 'w1', 'label': '주간 롤링', 'sub': '월 00:00 MON_TOTAL 9단계. 고객 FCST, 결과 이동'},
        {'id': 'w2', 'label': 'MKT FCST 컷오프', 'sub': '월 15:00~화 11:50 MF_W, SF_W 사업부별'},
        {'id': 'w3', 'label': '계획 확정', 'sub': '화 15:30, 목 01:30 40 사업부, 수 06:20 81 사업부'},
        {'id': 'w4', 'label': 'Sales Plan 컷오프', 'sub': '화 18:00 40, 수, 금 81 사업부, 목, 금 03:00 82'},
        {'id': 'w5', 'label': 'BPS 송신', 'sub': '금 22:00 BPS_INTERFACE'},
        {'id': 'w6', 'label': '컷오프 정리', 'sub': '토 00:45 CUTOFF_DATA_CLEANSING'},
    ], 'edges': [{'from': f'w{i}', 'to': f'w{i + 1}', 'label': ''} for i in range(1, 6)],
        'notes': ['MKT FCST 일 컷오프(MF_D) = 화 00:15 TUE_TOTAL, 일, 수, 목, 금, 토 00:00 TOTAL_MOBILE', '시각 = TO-BE 잡 스케줄(ALL_SCHEDULER_JOBS, ALL_SCHEDULER_SCHEDULES)']},
]}

# ───────── CT TO-BE 변경 사항과 개선점
CT = {'id': 'CT', 'title': 'TO-BE 변경 사항과 개선점', 'slides': [
    {'kind': 'text', 'title': 'TO-BE 변경 사항과 개선점', 'src': [F('tobe_rules.csv')], 'lines': [
        '조회 즉시 편집: 편집 버튼 없이 조회 직후 편집 가능 칸 노랑 표시(CR-084, CR-093, CR-103)',
        '개인화 컬럼: 사용자별 컬럼, Measure 구성과 순서 저장. 없으면 사업부 기본 구성(CR-001, CR-058)',
        '조회 조건 저장: Condition(F6) 저장, Reset Condition 은 서버 저장본만 삭제(CR-029, CR-094)',
        '저장 검증: 필수 칸 빈 행 저장 차단, 어떤 칸이 필수인지 안내(CR-090, CR-091)',
        '엑셀 업로드: 파일 1개, 양식 머리글 대조 뒤 불일치면 차단, 행별 원인 메시지(CR-017, CR-035, CR-036)',
        '공통 버튼: 권한 있는 버튼만 노출, 권한 = 사용자 보유 그룹 합집합(CR-070, CR-102)',
        '배치: Oracle DBMS_SCHEDULER 잡 63개로 바꿈. 이력 = USER_SCHEDULER_JOB_RUN_DETAILS',
    ]},
    {'kind': 'table', 'title': 'TO-BE 변경 사항과 개선점 - 운영 영향', 'src': [F('tobe_rules.csv'), F('jobs.csv')],
     'columns': ['구분', 'AS-IS', 'TO-BE', '운영 영향'], 'rows': [
        ['화면 편집', 'Edit(F2) 버튼으로 편집 모드', '조회 직후 편집(CR-084)', '편집 모드 문의 없어짐'],
        ['컬럼 구성', '화면 고정 컬럼', '사용자별 개인화, 사업부 기본(CR-001)', '컬럼 안 보임 문의 = 컬럼 설정 먼저 확인'],
        ['조회 조건', '화면 닫으면 초기화', '조회 조건 저장(CR-029)', '조건 이상 문의 = Reset Condition 안내'],
        ['메뉴 노출', '권한 그룹 1개 기준', '보유 그룹 합집합(CR-102), 연결 메뉴만(CR-026)', '권한 = SYS0008 Group Menu 확인'],
        ['배치 실행', 'AS-IS 배치 스케줄러', 'DBMS_SCHEDULER 잡 63개', '재실행 = DBMS_SCHEDULER.RUN_JOB'],
        ['배치 로그', 'AS-IS 잡 이력', 'SCM_SYS_LOG_BATCH, JOB_RUN_DETAILS', '로그 위치 2곳 확인'],
     ]},
]}

# ───────── C2 전체 업무 흐름
C2 = {'id': 'C2', 'title': '2. 전체 업무 흐름', 'slides': [
    {'kind': 'flow', 'title': '2. 전체 업무 흐름', 'src': [F('flow_edges.csv'), F('tables.csv'), F('sp_tables.csv'), F('jobs.csv')], 'nodes': [
        {'id': 'n1', 'label': '기준 정보 등록', 'sub': 'DMF0004, DMF0005, DMF0006, DMF0007 / JOB_PR_DM_4MCC_SCM_MST'},
        {'id': 'n2', 'label': '판가, 환율', 'sub': 'DMF0020, DMF0082, DMF0083'},
        {'id': 'n3', 'label': 'MKT FCST 입력', 'sub': 'DMF0003, DMF0014 / JOB_PR_DM_DNM_EDI_CALLOFF'},
        {'id': 'n4', 'label': 'MKT FCST 컷오프', 'sub': 'JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_TOTAL'},
        {'id': 'n5', 'label': 'Sales Plan', 'sub': 'DMF0021 / JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81'},
        {'id': 'n6', 'label': '결과 전달', 'sub': 'JOB_PR_DM_BPS_INTERFACE, PLM, SCP PLAN_FINAL'},
        {'id': 'n7', 'label': '분석', 'sub': 'DMF0035, DMF0044, DMF0048 / JOB_PR_DM_ANL_MKT_PSI_DATA'},
    ], 'edges': [
        {'from': 'n1', 'to': 'n3', 'label': 'DM_MST_CUSTOMER_FCST'},
        {'from': 'n2', 'to': 'n5', 'label': 'DM_PLN_CFM_SELLING_PRICE'},
        {'from': 'n3', 'to': 'n4', 'label': 'DM_PLN_MKT_FCST'},
        {'from': 'n4', 'to': 'n5', 'label': 'DM_PLN_MKT_FCST_C'},
        {'from': 'n5', 'to': 'n6', 'label': 'DM_PLN_SALES_PLAN_C'},
        {'from': 'n4', 'to': 'n7', 'label': 'DM_PLN_MKT_FCST_RESULT_C'},
        {'from': 'n5', 'to': 'n7', 'label': 'DM_PLN_SALES_PLAN_RESULT_C'},
    ], 'notes': ['PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING 이 DM_PLN_MKT_FCST 를 읽어 DM_PLN_MKT_FCST_C 저장함',
                 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE 가 DM_PLN_MKT_FCST_C 를 읽어 DM_PLN_SALES_PLAN_C 저장함',
                 'PR_DM_BPS_SALES_PLAN_S 가 DM_PLN_SALES_PLAN_C 를 읽어 XIF_BPS_SALES_PLAN_S_SN 저장함']},
]}

# ───────── C3 업무 프로세스별 운영(프로세스마다 간지 + 흐름 1장 + 운영 포인트 1장)
def flow(p, nodes, edges, notes, title_sfx=''):
    return {'kind': 'flow', 'title': f'3. 프로세스 구조 - {p}{title_sfx}', 'src': src_j + src_b, 'nodes': nodes, 'edges': edges, 'notes': notes}


def chain(ids_labels):
    nodes = [{'id': f's{i}', 'label': l, 'sub': s} for i, (l, s) in enumerate(ids_labels)]
    return nodes, [{'from': f's{i}', 'to': f's{i + 1}', 'label': ''} for i in range(len(nodes) - 1)]


def ops(p, rows):
    return {'kind': 'table', 'title': f'3. 프로세스 구조 - {p} 운영 포인트', 'src': src_j + [F('columns.csv')], 'columns': ['확인', '정상', '이상일 때 조치'], 'rows': rows}


C3 = []
p = '기준 정보 동기화'
n, e = chain([('ERP 매핑 수신', '매일 11:10 PR_DM_CUST_MODEL_MAPPING_IF → DM_CUST_MODEL_MAPPING_M'),
              ('EDI 기준 수신', '1시간마다 EDI 고객 자재, 하역지 2개 잡'),
              ('BOM 반영', '1시간마다 SCM_MST_SITE_ITEM 갱신'),
              ('HI 매핑', '매일 04:00 DM_HI_SITE_ITEM_MAPPING'),
              ('4MCC 송신', '매일 00:30 XIF_SCM_MST_*_4MCC_S_SN 3개')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['관련 화면 = DMF0004, DMF0005, DMF0006, DMF0008, DMF0072']),
       ops(p, [['SCM_SYS_LOG_BATCH PROGRAM_NAME 별 ERROR', '0건', '수신 I/F 테이블 건수 확인 뒤 잡 RUN_JOB'],
               ['DMF0008 EDI 기준 정보 검증 화면', '누락 0건', 'DMF0008 에서 사이트 품목 보정'],
               ['XIF_SCM_MST_*_4MCC_S_SN 송신 건수', '매일 00:30 이후 증가', 'JOB_PR_DM_4MCC_SCM_MST 재실행']])]
p = '인터페이스 수신'
n, e = chain([('NERP RFC 호출', 'PR_SCM_SYS_RFC_CALL_NERP. 07:00 MDF, 07:15 자재 문서'),
              ('XIF 수신 테이블', 'XIF_ERP_FI_MDF_R_SN, XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN'),
              ('DM 테이블 이동', 'DM_PLN_MDF_RESULT, SCM_DNM_MAT_DOCUMENT'),
              ('EDI Call-off', '매일 03:20 외 여러 번 DM_PLN_CUST_FCST_H 기록'),
              ('수신 확인 SMS', '1시간마다 PR_DM_IF_CHECK_SMS_SEND')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['매출 실적 = JOB_PR_DM_DNM_SALES_RESULT 하루 여러 번', 'PLM 조정 FCST = 1시간마다, SSP 동기화 = 월 07:50']),
       ops(p, [['XIF_ERP_SALES_RESULT_R_SN 등 수신 3개 테이블', 'SMS 미발송', 'NERP RFC 로그 SCM_SYS_LOG_BATCH 확인'],
               ['DM_PLN_MDF_RESULT CREATE_DATE', '매일 07:00 이후 당일분', 'JOB_RFC_PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT RUN_JOB'],
               ['SCM_DNM_MAT_DOCUMENT 건수', '매일 07:15 이후 증가', 'JOB_RFC_XIF_ERP_MATERIAL_DOCUMENT_DM_R 2단계 순서로 재실행']])]
p = '주간 롤링 시작'
n, e = chain([('고객 FCST 롤링', '월 00:00 1단계 DM_MST_CUSTOMER_FCST_C'),
              ('결과 이동', '2~5단계 81, 82 MKT FCST, Sales Plan 결과 이동'),
              ('MKT FCST 롤링', '6~7단계 81, 82 사업부'),
              ('40 판가 반영', '8단계 PR_DM_PLN_CFM_TO_MKT_FCST_ALL'),
              ('ESS VMI 갱신', '월 07:50, 08:50 PR_DM_PLN_ESS_VMI_REFRESH')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['잡 = JOB_PR_DM_MST_CUST_FCST_WEEKLY_ROLLING_MON_TOTAL 9단계, 단계마다 PR_SCM_SYS_LOG_BATCH 기록']),
       ops(p, [['DM_MST_CUSTOMER_FCST_C 최신 CUTOFF_DATE', '이번 주 월요일', 'MON_TOTAL 1단계부터 다시 실행'],
               ['JOB_RUN_DETAILS STATUS', 'SUCCEEDED', '실패 단계 확인 뒤 그 단계 프로시저 직접 실행']])]
p = 'MKT FCST 컷오프'
n, e = chain([('월 MF_W 40, 82', '월 15:00, 16:00 사업부 주간 컷오프'),
              ('화 MF_D', '화 00:15 TUE_TOTAL 10단계. 전 사업부'),
              ('화 MF_W 81', '04:00~04:10, 10:00~10:10 81 사업부 6개'),
              ('SF_W SCM FCST', '월 17:30 40, 화 11:00~11:50 81 사업부 6개'),
              ('EDI 일 컷오프', '매일 06:15 DM_DNM_EDI_CALLOFF_ITEM_C'),
              ('정리', '토 00:45 CUTOFF_DATA_CLEANSING')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['프로시저 = PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING. 결과 = DM_PLN_MKT_FCST_C, DM_PLN_MKT_FCST_RESULT_C', '일 컷오프(MF_D) = 일, 수, 목, 금, 토 00:00 TOTAL_MOBILE 9단계']),
       ops(p, [['DM_PLN_MKT_FCST_C 사업부별 CUTOFF_TYPE MF_W 최신 CUTOFF_YYYYMMDD', '이번 주 일자', '그 사업부 잡 RUN_JOB'],
               ['DM_MST_VERSION VERSION_TYPE MF_W, SF_W', '이번 주 버전 1건', 'DMF0035 버전 조회로 확인'],
               ['DM_DNM_EDI_CALLOFF_ITEM_C CUTOFF_YYYYMMDD', '당일', 'JOB_PR_DM_DNM_EDI_CUTOFF RUN_JOB']])]
p = 'Sales Plan 컷오프'
n, e = chain([('RTF 확인', '1단계 RTF Check, PR_SCM_SYS_LOG_BATCH'),
              ('수량 균형 생성', '2단계 PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'),
              ('판가 없는 RTF 메일', '3단계 PR_DM_DNM_SALES_PRICE_EXIST_MAIL_SEND(40 제외)')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['사업부 잡 8개: 40 화 18:00, 81 6개 수, 금, 82 목, 금 03:00', '결과 = DM_PLN_SALES_PLAN_C, DM_PLN_SALES_PLAN_RESULT_C, DM_PLN_SALES_ETC_PLAN_C']),
       ops(p, [['DM_PLN_SALES_PLAN_C 사업부별 CUTOFF_TYPE SP_W 최신 CUTOFF_YYYYMMDD', '이번 주 일자', '그 사업부 잡 RUN_JOB'],
               ['판가 없는 RTF 메일 수신 건수', '0건', 'DMF0020, DMF0082 판가 등록 뒤 3단계 다시 실행']])]
p = '계획 확정(SCP 연계)'
n, e = chain([('SCP 엔진 제어', 'PR_SCP_ENG_CONTROL → SCP_OPMZ_PLAN_M, SCM_MST_PLAN_DETAIL'),
              ('MKT FCST 수량 균형', 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE → DM_PLN_MKT_FCST')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['40 사업부 = 화 15:30, 목 01:30 JOB_SCMPROD_PLAN_FINAL_40_CREATION', '81 사업부 = 수 06:20 JOB_SCMPROD_PLAN_FINAL_81_CREATION']),
       ops(p, [['SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M 실행 이력', '잡 시각 이후 1건', 'SCP 담당과 엔진 상태 확인 뒤 RUN_JOB'],
               ['DM_PLN_CFM_MKT_DEMAND_PLAN 갱신 일자', '잡 시각 이후', 'Sales Plan 컷오프 완료 여부 먼저 확인']])]
p = '인터페이스 송신'
n, e = chain([('Metal Link 컷오프', '금 22:00 PR_DM_METAL_LINK_CUTOFF'),
              ('BPS 송신', 'XIF_BPS_SALES_PLAN_S_SN, XIF_BPS_SALES_ETC_PLAN_S_SN'),
              ('Metal Link 송신', 'XIF_BPS_METAL_LINK_PRICE_S_SN')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['PLM = 매일 01:00 XIF_PLM_DM_PLN_MKT_FCST_PLAN_S_SN', 'SSPM Cell Car = 매일 06:40 XIF_DM_SSPM_CELL_CAR_S_SN']),
       ops(p, [['BPS 송신 3개 테이블 건수', '금 22:00 이후 증가', 'Sales Plan 컷오프 결과 확인 뒤 JOB_PR_DM_BPS_INTERFACE RUN_JOB'],
               ['SCM_SYS_LOG_BATCH PR_DM_METAL_LINK_CUTOFF', 'ERROR 0건', 'DMF0074 Metal Link 판가 업로드 확인']])]
p = '분석과 KPI'
n, e = chain([('MKT PSI', '매일 06:00 DM_ANL_MKT_PSI, DW 송신'),
              ('RTF 판매 KPI', '화 06:00 DM_ANL_KPI_RTF_SALES'),
              ('HI 지표', '화 04:00 DM_HI_* 3개'),
              ('고객 수요 요약', '수 08:00 81 사업부 6단계'),
              ('Fulfillment', '매일 06:30, 07:00, 07:30, 23:30 DM_DNM_FULFILL')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['분석 결과 조회 화면 = DMF0035, DMF0040, DMF0044, DMF0048, DMF0053']),
       ops(p, [['DM_ANL_MKT_PSI LAST_UPDATE_DATE', '당일 06:00 이후', 'JOB_PR_DM_ANL_MKT_PSI_DATA RUN_JOB'],
               ['DM_DNM_FULFILL DATA_TYPE 별 건수', '잡 3개 모두 당일분 있음', 'Sales Plan, MKT FCST 컷오프 결과 확인']])]
p = 'PR 자동 요청'
n, e = chain([('PR 요청 생성', '월 01:00 DMF0070_AUTO_PR_REQUEST → DM_PLN_PR_DETAIL'),
              ('PR 요청 메일', '화 01:00 DM_PLN_AUTO_PR_CHECK 대상 메일'),
              ('수량 차이 메일', '12시간마다 DMF0070_DIFF_QTY_MAIL_SEND_AUTO')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['PR 상세는 DMF0003, DMF0082 에서 조회함']),
       ops(p, [['DM_PLN_AUTO_PR_CHECK 대상 건수', '월 01:00 이후 생성', 'DMF0070_AUTO_PR_REQUEST 직접 실행'],
               ['SCM_ADM_SMS_MAIL_SEND_LOG SEND_MAIL_ERROR_LOG_DESC', '빈 값', 'SYS0017 Mail Setup 수신자 확인']])]
p = '메일과 SMS 알림'
n, e = chain([('배치 미실행 확인', '5분마다 PR_DM_CHECK_BEFOREHAND_SMS_SEND'),
              ('오류 잡 확인', 'PR_DM_CHECK_JOB_ERROR_SMS_SEND'),
              ('I/F 수신 확인', '1시간마다 PR_DM_IF_CHECK_SMS_SEND'),
              ('기준 정보 메일', '매일 08:00 EDI 요약, 수 23:40 환율'),
              ('미접속자 메일', '매일 04:00 PR_DM_UNLOGIN_MAIL_SEND')])
C3 += [{'kind': 'divider', 'title': p}, flow(p, n, e, ['수신자 = SYS0017 Mail Setup, SCM0007 SMS Setup(SCM_ADM_RECIPIENT_* 테이블)', 'JOB_PR_DM_DNM_ESS_MAIL 단계 프로시저 TO-BE 객체 없음(확인 필요)']),
       ops(p, [['SCM_ADM_SMS_MAIL_SEND_LOG SEND_DATE 최신', '5분 안', 'JOB_PR_DM_CHECK_BEFOREHAND_SMS_SEND STATE 확인'],
               ['SEND_MAIL_ERROR_LOG_DESC', '빈 값', '수신자, 메일 서버 설정 확인']])]
C3c = {'id': 'C3', 'title': '3. 프로세스 구조', 'slides': C3}

# ───────── C9 일상 운영 점검표
Q_JOB = "SELECT JOB_NAME, ENABLED, STATE, NEXT_RUN_DATE, FAILURE_COUNT FROM USER_SCHEDULER_JOBS WHERE JOB_NAME LIKE 'JOB%DM%' OR JOB_NAME LIKE 'JOB_DMF%'"
Q_RUN = "SELECT JOB_NAME, STATUS, ERROR#, ACTUAL_START_DATE, ADDITIONAL_INFO FROM USER_SCHEDULER_JOB_RUN_DETAILS WHERE ACTUAL_START_DATE >= TRUNC(SYSDATE) AND STATUS <> 'SUCCEEDED'"
Q_LOG = "SELECT PROGRAM_NAME, LOG_TYPE, SQL_ERR_CODE, SQL_ERR_MSG, EVENT_DATE FROM SCM_SYS_LOG_BATCH WHERE EVENT_DATE >= TRUNC(SYSDATE) AND LOG_TYPE = 'ERROR' ORDER BY EVENT_DATE DESC FETCH FIRST 50 ROWS ONLY"
Q_MF = "SELECT DIVISION_ID, CUTOFF_TYPE, MAX(CUTOFF_YYYYMMDD) FROM DM_PLN_MKT_FCST_C WHERE CUTOFF_TYPE IN ('MF_W','MF_D','SF_W') GROUP BY DIVISION_ID, CUTOFF_TYPE"
Q_SP = "SELECT DIVISION_ID, CUTOFF_TYPE, MAX(CUTOFF_YYYYMMDD) FROM DM_PLN_SALES_PLAN_C WHERE CUTOFF_TYPE IN ('SP_W','SP_D') GROUP BY DIVISION_ID, CUTOFF_TYPE"
Q_EDI = "SELECT MAX(CUTOFF_YYYYMMDD), COUNT(*) FROM DM_DNM_EDI_CALLOFF_ITEM_C WHERE CUTOFF_YYYYMMDD = TO_CHAR(SYSDATE,'YYYYMMDD')"
Q_MAIL = "SELECT USE_TYPE_CODE, SEND_DATE, SEND_MAIL_ERROR_LOG_DESC FROM SCM_ADM_SMS_MAIL_SEND_LOG WHERE SEND_DATE >= TRUNC(SYSDATE) AND SEND_MAIL_ERROR_LOG_DESC IS NOT NULL"
C9 = {'id': 'C9', 'title': '9. 일상 운영 점검표', 'slides': [
    {'kind': 'table', 'title': '9. 일상 운영 점검표 - 매일', 'src': src_j + [F('columns.csv')], 'columns': ['주기', '확인 시각', '점검 항목', '확인 쿼리', '정상 기준', '이상할 때 볼 곳'], 'rows': [
        ['일', '08:30', '잡 상태', Q_JOB, 'STATE SCHEDULED, FAILURE_COUNT 0', '로그와 모니터링 장 보는 순서'],
        ['일', '08:30', '당일 실패 실행', Q_RUN, '0행', 'ADDITIONAL_INFO, SCM_SYS_LOG_BATCH'],
        ['일', '08:30', '배치 오류 로그', Q_LOG, '0행', 'PROGRAM_NAME 의 잡 단계'],
        ['일', '06:30', 'EDI 일 컷오프', Q_EDI, '당일 1건 이상', 'JOB_PR_DM_DNM_EDI_CUTOFF'],
        ['일', '09:00', '메일, SMS 발송 오류', Q_MAIL, '0행', 'SYS0017, SCM0007 수신자'],
    ]},
    {'kind': 'table', 'title': '9. 일상 운영 점검표 - 주간', 'src': src_j + [F('columns.csv')], 'columns': ['주기', '확인 시각', '점검 항목', '확인 쿼리', '정상 기준', '이상할 때 볼 곳'], 'rows': [
        ['주', '화 12:00', 'MKT FCST 주간 컷오프', Q_MF, '사업부별 MF_W, SF_W 이번 주 일자', 'MKT FCST 컷오프 프로세스'],
        ['주', '금 16:00', 'Sales Plan 컷오프', Q_SP, '사업부별 SP_W 이번 주 일자', 'Sales Plan 컷오프 프로세스'],
        ['주', '토 09:00', 'BPS 송신', "SELECT COUNT(*) FROM XIF_BPS_SALES_PLAN_S_SN", '금 22:00 이후 증가', 'JOB_PR_DM_BPS_INTERFACE'],
    ]},
]}

# ───────── C10 장애 대응
C10 = {'id': 'C10', 'title': '10. 장애 대응', 'slides': [
    {'kind': 'table', 'title': '10. 장애 대응', 'src': src_j + src_b, 'columns': ['증상', '확인', '조치', '재실행'], 'rows': [
        ['배치 실패', 'USER_SCHEDULER_JOB_RUN_DETAILS ERROR#, ADDITIONAL_INFO', '원인 데이터 보정', "DBMS_SCHEDULER.RUN_JOB('<TO-BE 잡>')"],
        ['컷오프 누락', 'DM_PLN_MKT_FCST_C, DM_PLN_SALES_PLAN_C 최신 CUTOFF_YYYYMMDD', '사업부 잡 STATE, ENABLED 확인', '사업부 잡 단독 RUN_JOB'],
        ['I/F 미수신', 'PR_DM_IF_CHECK_SMS_SEND SMS, XIF 수신 테이블 건수', 'NERP RFC 로그 SCM_SYS_LOG_BATCH 확인', 'RFC 잡 1단계부터 RUN_JOB'],
        ['화면 저장 오류', 'SCM_COM_SQL_LOG EXCEPTION(LOG_SEQ 범위)', '저장 프로시저 오류 메시지 확인', '해당 없음'],
        ['장시간 쿼리', 'SCM_COM_SQL_LOG ELAPSED_MS', '5분 이상 알림, 30분 이상 사용자 세션만 KILL', '해당 없음'],
    ]},
    {'kind': 'flow', 'title': '10. 장애 대응 - 다단계 잡 재실행 순서', 'src': src_b, 'nodes': [
        {'id': 'r1', 'label': '실패 단계 확인', 'sub': 'SCM_SYS_LOG_BATCH PROGRAM_NAME, EVENT_DATE'},
        {'id': 'r2', 'label': '원인 보정', 'sub': '입력 데이터, 기준 정보 보정'},
        {'id': 'r3', 'label': '실패 단계 실행', 'sub': 'batch.csv 단계 순서 그 단계 프로시저 직접 실행'},
        {'id': 'r4', 'label': '다음 단계 실행', 'sub': '남은 단계 순서대로. 전 단계 재실행 = RUN_JOB'},
        {'id': 'r5', 'label': '결과 확인', 'sub': '컷오프 테이블 CUTOFF_YYYYMMDD, 송신 테이블 건수'},
    ], 'edges': [{'from': f'r{i}', 'to': f'r{i + 1}', 'label': ''} for i in range(1, 5)],
        'notes': ['다단계 잡 = MON_TOTAL 9단계, TUE_TOTAL 10단계, TOTAL_MOBILE 9단계, CUST_DEMAND_ANL_SUMMARY 6단계']},
]}

# ───────── C11 로그와 모니터링
C11 = {'id': 'C11', 'title': '11. 로그와 모니터링', 'slides': [
    {'kind': 'text', 'title': '11. 로그와 모니터링 - 보는 순서', 'src': src_j + [F('columns.csv'), 'tools/VibeManager/rules/10_RULES_KEEP.md'], 'lines': [
        '1. 잡 상태: USER_SCHEDULER_JOBS STATE, ENABLED, NEXT_RUN_DATE, FAILURE_COUNT',
        '2. 실행 결과: USER_SCHEDULER_JOB_RUN_DETAILS STATUS, ERROR#, ADDITIONAL_INFO',
        '3. 잡 로그: USER_SCHEDULER_JOB_LOG OPERATION, STATUS',
        '4. 배치 단계 로그: SCM_SYS_LOG_BATCH PROGRAM_NAME, LOG_TYPE(START, END, ERROR), SQL_ERR_MSG, SQL_BACKTRACE',
        '5. 화면 SQL 로그: SCM_COM_SQL_LOG 는 LOG_SEQ 범위로 먼저 좁힌 뒤 SQL_ID, ELAPSED_MS, EXCEPTION 조회',
        '6. 메일, SMS: SCM_ADM_SMS_MAIL_SEND_LOG SEND_DATE, SEND_MAIL_ERROR_LOG_DESC',
    ]},
    {'kind': 'table', 'title': '11. 로그와 모니터링 - 조회 예시', 'src': [F('columns.csv')], 'columns': ['대상', '쿼리'], 'rows': [
        ['잡 실행 이력', "SELECT JOB_NAME, STATUS, ERROR#, ACTUAL_START_DATE, RUN_DURATION FROM USER_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME = 'JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_TOTAL' ORDER BY ACTUAL_START_DATE DESC FETCH FIRST 10 ROWS ONLY"],
        ['배치 단계 로그', "SELECT PROGRAM_NAME, LOG_TYPE, LOG_MESSAGE, SQL_ERR_MSG, EVENT_DATE FROM SCM_SYS_LOG_BATCH WHERE EVENT_DATE >= SYSDATE - 1 AND PROGRAM_NAME LIKE 'PR_DM_PLN%' ORDER BY EVENT_DATE DESC"],
        ['화면 SQL 로그', "SELECT LOG_SEQ, SQL_ID, ELAPSED_MS, EXCEPTION FROM SCM_COM_SQL_LOG WHERE LOG_SEQ > (SELECT MAX(LOG_SEQ) - 5000 FROM SCM_COM_SQL_LOG) AND EXCEPTION IS NOT NULL"],
        ['장시간 화면 SQL', "SELECT LOG_SEQ, SQL_ID, ELAPSED_MS, CREATED_BY FROM SCM_COM_SQL_LOG WHERE LOG_SEQ > (SELECT MAX(LOG_SEQ) - 5000 FROM SCM_COM_SQL_LOG) AND ELAPSED_MS > 300000"],
    ]},
]}

# ───────── C12 기준 정보 관리
C12 = {'id': 'C12', 'title': '12. 기준 정보 관리', 'slides': [
    {'kind': 'table', 'title': '12. 기준 정보 관리 - 등록 순서', 'src': [F('screens.csv'), F('flow_edges.csv'), F('tables.csv')], 'columns': ['순서', '화면', '등록 테이블', '빠지면 생기는 증상'], 'rows': [
        ['1', 'DMF0004 Sales Site', 'SCM_MST_SITE, SCM_MST_SITE_CUSTOMER, DM_MST_BUCKET_CONVERSION', 'DMF0003, DMF0082 조회 버킷 변환 누락'],
        ['2', 'DMF0006 Customer Model Mapping', 'DM_MST_CUSTOMER_MODEL', 'DMF0005, DMF0014 고객 모델 후보 없음'],
        ['3', 'DMF0072 N:N Master Mapping', 'DM_CUST_MODEL_MAPPING_M', 'EDI 고객 FCST 기록 누락'],
        ['4', 'DMF0005 Sales Site Project Model', 'SCM_MST_SITE_ITEM', 'MKT FCST 행 생성 안 됨'],
        ['5', 'DMF0007 Customer FCST Master', 'DM_MST_CUSTOMER_FCST', '주간 롤링 1단계 대상 없음'],
        ['6', 'DMF0020, DMF0083 판가, 환율', 'SCM_MST_FUTURE_PRICE, DM_MST_EXCHANGE_RATE', '판가 없는 RTF 메일 발생'],
        ['7', 'DMF0043 Contribution Rate', 'DM_MST_CONTRIBUTE_RATIO_MST, DTL', '기여율 판매 조회 빈 값'],
        ['8', 'DMF0008 ERP EDI Master Validation', 'SCM_MST_SITE_ITEM 보정', 'ERP EDI 요약 메일 누락 건 남음'],
    ]},
]}

# ───────── C13 권한과 메뉴 관리(SYSTEM 사용 메뉴, TO-BE 저장 테이블)
C13 = {'id': 'C13', 'title': '13. 권한과 메뉴 관리', 'slides': [
    {'kind': 'table', 'title': '13. 권한과 메뉴 관리 - 등록 순서', 'src': [F('admin_screens.csv')], 'columns': ['순서', '작업', '화면', '저장 테이블'], 'rows': [
        ['1', '메뉴 추가', 'SYS0003 Menu', 'SCM_ADM_MNU_M'],
        ['2', '메뉴 버튼 등록', 'SYS0009 Menu Button', 'SCM_ADM_MNU_BTN_MPG_M'],
        ['3', '권한 그룹 등록', 'SYS0007 Group', 'SCM_ADM_USER_GR_M'],
        ['4', '그룹 메뉴, 버튼 권한', 'SYS0008 Group Menu', 'SCM_ADM_USER_GR_MNU_MPG_M, SCM_ADM_USER_GR_MNU_BTN_MPG_M'],
        ['5', '그룹 사용자, 단위 권한', 'SYS0014 Group User', 'SCM_ADM_USER_GR_MPG_M, SCM_ADM_USER_GR_UNIT_AUTH_MPG_M'],
        ['6', '사용자 등록', 'SYS0002 User', 'SCM_ADM_USER_M'],
        ['7', '권한 요청, 승인', 'SYS0011, SYS0012', 'SCM_ADM_USER_GR_MPG_M'],
    ]},
    {'kind': 'text', 'title': '13. 권한과 메뉴 관리 - 확인 사항', 'src': [F('admin_screens.csv'), F('tobe_rules.csv')], 'lines': [
        '메뉴 노출: 상위 메뉴까지 USE_YN Y, 사용 중 그룹 1개 이상 연결된 메뉴만 보임(CR-026). DMF0022 는 상위 Waterfall USE_YN N 이라 안 보임',
        '권한 판정: 사용자가 가진 그룹 권한 합집합(CR-102)',
        '버튼 노출: SCM_ADM_USER_GR_MNU_BTN_MPG_M 버튼 권한이 있을 때만(CR-070)',
        '메일, SMS 수신자: SYS0017 Mail Setup, SCM0007 SMS Setup',
        '미접속자: JOB_PR_DM_UNLOGIN_MAIL_SEND 가 3개월 미접속자 권한 회수 메일 발송',
    ]},
]}

content = {'key': 'DM', 'screenNotes': SN, 'jobNotes': JN, 'tableNotes': TN, 'processOf': processOf, 'processOrder': P_ORDER,
           'chapters': [C1, CT, C2, C3c, C9, C10, C11, C12, C13]}
out = os.path.join(D, 'content', 'chapters.json')
json.dump(content, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('written', out, {p: cnt[p] for p in P_ORDER})
