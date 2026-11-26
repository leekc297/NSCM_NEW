# -*- coding: utf-8 -*-
"""SSP 통합테스트 사전점검 단계 SQL 파일 3종 생성 + 검증(2026-11-25 사용자 지시)
  ① 검증쿼리 Oracle(TO-BE) 한 파일 ② 검증쿼리 MSSQL(AS-IS) 한 파일 ③ 단위별 데이터 산출 실행 명령 Oracle 한 파일
  python -u gen_sql_files.py <시험일 YYYYMMDD> <V10 xlsx> <scn JSON> <출력 폴더> [--no-db]
  형태 : DBeaver 에서 그대로 실행(바인드 변수 · DECLARE(MSSQL) · SQL*Plus 명령 · 단독 / 없음). 쿼리마다 위에 주석으로 내용 표기"""
import sys, os, re, io, json, time, datetime, warnings
warnings.simplefilter('ignore')
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import openpyxl
import dbeaver as D

T = sys.argv[1]; XLSX = sys.argv[2]; SCN = json.load(open(sys.argv[3], encoding='utf-8')); OUT = sys.argv[4]; NO_DB = '--no-db' in sys.argv
T, T1 = D.set_test_date(T)   # 시험일 기준값(계획 시작일 · 기본값 · 주석)은 dbeaver.py 한 곳에서 만듦
T3 = (datetime.datetime.strptime(T, '%Y%m%d') - datetime.timedelta(days=3)).strftime('%Y%m%d')
q = openpyxl.load_workbook(XLSX)['검증쿼리']
v9 = [[q.cell(r, c).value for c in range(1, 7)] for r in range(2, 34) if q.cell(r, 1).value in ('VQ-27', 'VQ-31')]
rows = D.build(v9, test_date=T)
# VQ → 쓰는 사전점검 No
use = {}; no = 0
for s in SCN['sections']:
    for r in s['rows']:
        no += 1
        for v in re.findall(r'VQ-\d+', r[5] + ' ' + r[3]): use.setdefault(v, []).append((no, r[3].split('\n')[0]))
BAR = '-- ' + '=' * 110


def cmt(text):
    """주석 줄에 DBeaver 가 변수로 읽을 수 있는 형태(:이름 · ?)가 없게"""
    return re.sub(r':(?=[A-Za-z_가-힣])', ': ', str(text)).replace('?', '')


def query_file(side):
    ora = side == 5; name = 'Oracle(TO-BE)' if ora else 'MSSQL(AS-IS)'
    sel = [r for r in rows if r[side] != '-']
    L = [BAR, f'-- SSP 통합테스트 시나리오(e2e) 사전점검 단계 검증쿼리 · {name} · {len(sel)}개',
         f'-- 시험일(PLAN_DATE) = {T} · 계획 시작일 : 40 · 전극 = {T}, 81·82 · Packer · 통합 스냅샷 = {T1}(시험일 - 1)',
         '-- 실행 : DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). 값을 바꿀 때는 각 쿼리 맨 위 WITH PRM 줄만 고침',
         '-- 조회만 수행(변경 문장 없음). 번호 = 통합테스트 시나리오 「검증쿼리(사전점검)」 시트의 ID',
         ('-- 같은 번호의 MSSQL(AS-IS) 쿼리와 결과 열 이름 · 정렬이 같음' if ora else '-- 같은 번호의 Oracle(TO-BE) 쿼리와 결과 열 이름 · 정렬이 같음. AS-IS 운영 DB 에서 실행. VQ-42 는 뷰 전체를 계산하므로 업무 시간을 피해 실행'),
         f'-- 생성 {datetime.datetime.now():%Y-%m-%d %H:%M} · tools/Analysis/ssp_it_precheck/gen_sql_files.py', BAR, '',
         '-- 목차']
    L += [f'--   {r[0]}  {cmt(r[2])}' for r in sel] + ['']
    for r in sel:
        u = use.get(r[0], [])
        L += [BAR, f'-- [{r[0]}] {cmt(r[2])}', f'-- 분류 : {cmt(r[1])}', f'-- 대상 : {cmt(r[3])}', f'-- 확인 : {cmt(r[4])}',
              '-- 사용 : ' + (' / '.join(f'사전점검 No {n}({cmt(t)})' for n, t in u) if u else '테스트케이스 시트'), BAR, r[side] + ';', '']
    return '\n'.join(L), sel


def exec_file():
    H = [BAR, '-- SSP 통합테스트 시나리오(e2e) 단위별 데이터 산출 실행 명령 · Oracle(TO-BE)',
         f'-- 시험일(PLAN_DATE) = {T}. 산출 프로그램은 날짜 인자가 없고 실행 시각(SYSDATE) 기준으로 계산함 → {T[:4]}-{T[4:6]}-{T[6:]} 당일에 실행해야 계획 시작일이 맞음',
         f'--   계획 시작일 : 40 · 전극 = {T}, 81·82 · Packer · 통합 스냅샷 = {T1}(시험일 - 1)',
         '-- 실행 : 블록 하나씩 골라 실행(블록과 그 아래 / 줄까지 선택). 파일 전체 실행(F5)은 하지 않음 — 수신 · 산출이 한꺼번에 돌아감',
         '--        SQL Developer · SQLcl · SQL*Plus 는 블록 끝 / 줄이 있어야 블록이 끝남. DBeaver 는 블록 안에 커서를 두고 Ctrl+Enter(/ 줄은 실행하지 않음)',
         '-- 주의 : 변경 문장임. 프로그램 안에서 COMMIT 하므로 되돌릴 수 없음. 실행 전 사전점검 No 1 ~ 14 완료, DB 백업 지점 확보',
         '-- 진입 조건을 충족하지 못한 법인은 오류 없이 건너뜀(로그도 남지 않음). 실행 전 진입 조건 쿼리, 실행 후 결과 쿼리 번호를 블록마다 적어 둠',
         '-- 실행문 출처 : TO-BE 스케줄러 잡(SCM_MGR.JOB_…)의 실행문 그대로(사내 DB ZIOUI1 2026-11-25 10:05 조회)',
         f'-- 생성 {datetime.datetime.now():%Y-%m-%d %H:%M} · tools/Analysis/ssp_it_precheck/gen_sql_files.py', BAR, '',
         '-- 목차',
         '--   [0-1] 공통 : 일 계획 ID 생성(40 산출 선행 · 필수). 먼저 [0-1-확인] 으로 마지막 일자 조회',
         '--   [0-2] 공통 : 재고 · 계획 입력 수신 프로그램(수신 자료가 들어와 있을 때) 11개 블록',
         '--   [1-1] 40 HQ00 · [1-2] 40 AZ00 · [1-3] 40 NJ00',
         '--   [2]   81·82 컷오프',
         '--   [3]   Packer',
         '--   [4]   전극',
         '--   [5-1] 공통 : 통합 스냅샷 · [5-2] 공통 : 일 마감 지연 문자',
         '--   [9]   실행 로그 조회', '']
    B = []

    def blk(tag, title, lines, body):
        B.extend([BAR, f'-- [{tag}] {title}'] + ['-- ' + x for x in lines] + [BAR, body, '', '/', ''])   # 블록 끝 / : 스크립트 실행(SQL Developer · SQLcl · SQL*Plus)에 필요(2026-11-25 PLS-00103 발생)

    # 2026-11-25 원문 확인 : 일 계획 ID 는 전일 행(월요일은 전주 월요일 행)을 복사해 만든다 → 빠진 날이 있으면 시험일만 실행해도 0건.
    #   40 출하계획 생성(PR_SSP_ANL_SHIP_PLAN_40)은 시험일 ID 가 없으면 SCM_MST_PLAN_DETAIL.PLAN_ID(NOT NULL) 에 빈 값을 넣다가 오류로 끝남
    B.extend([BAR, '-- [0-1-확인] 공통 : 일 계획 ID 최신 일자 조회(조회 문장)', '-- 40 의 LAST_PLAN_NAME 이 시험일 전날이면 [0-1] 은 하루치만 만들고, 더 이전이면 빠진 날부터 차례로 만듦', BAR,
              "SELECT DIVISION_ID\n     , MAX(PLAN_NAME) AS LAST_PLAN_NAME\n     , MAX(PLAN_ID) KEEP (DENSE_RANK LAST ORDER BY PLAN_NAME) AS LAST_PLAN_ID\n     , COUNT(*) AS ROW_CNT\n"
              "  FROM SCM_MST_PLAN\n WHERE PLAN_CYCLE = 'DAILY'\n GROUP BY DIVISION_ID\n ORDER BY DIVISION_ID;", ''])
    blk('0-1', '공통 : 일 계획 ID 생성(빠진 날부터 시험일까지 차례로)', ['잡 : JOB_SCMPROD_PLAN_ID_DAILY_CREATION(운영 매일 00:10, 하루에 하루치)',
        '필수 : 40 출하계획 생성(PR_SSP_ANL_SHIP_PLAN_40)은 실행일의 일 계획 ID 가 없으면 오류로 끝남(SCM_MST_PLAN_DETAIL.PLAN_ID 가 NOT NULL)',
        '       확정 반영(PR_SSP_ANL_SHIP_CONFIRM_BATCH_40)은 이 ID 를 보지 않아 먼저 실행되므로, ID 없이 [1-1] 을 실행하면 확정만 반영되고 출하계획은 안 만들어짐',
        '만드는 방식 : 전일 행을 복사(월요일은 전주 월요일 행). 전일 행이 없으면 0건 → 40 의 마지막 일자 다음 날부터 시험일까지 하루씩 차례로 실행',
        '시험일이 실행일보다 뒤면 프로그램이 실행일로 바꿔 처리함. 이미 있는 날은 다시 만들지 않음',
        '확인 : [0-1-확인] 다시 조회(40 LAST_PLAN_NAME = 시험일) · VQ-35(사업부별 시험일 PLAN_NAME 행 1건)'],
        "DECLARE\n  V_LAST VARCHAR2(8);\n  D_DAY  DATE;\nBEGIN\n  SELECT MAX(PLAN_NAME)\n    INTO V_LAST\n    FROM SCM_MST_PLAN\n   WHERE DIVISION_ID = '40'\n     AND PLAN_CYCLE = 'DAILY';\n"
        f"  D_DAY := TO_DATE(V_LAST, 'YYYYMMDD') + 1;\n  WHILE D_DAY <= TO_DATE('{T}', 'YYYYMMDD') LOOP\n    PR_SCM_MST_PLAN('DAILY', TO_CHAR(D_DAY, 'YYYYMMDD'));\n    D_DAY := D_DAY + 1;\n  END LOOP;\nEND;")
    recv = [('전일 ERP 재고 생성', 'JOB_PR_SCM_DNM_STOCK_V', '81·82 컷오프 진입 조건(전일 ERP 재고). 확인 : VQ-42', 'PR_SCM_DNM_STOCK_V;'),
            ('제품 창고(OWMS) 재고 수신', 'JOB_PR_SSP_XIF_OWMS_STOCK_R(운영 5분)', '81·82 · 40. 확인 : VQ-41 · VQ-36', 'PR_SSP_XIF_OWMS_STOCK_R;\n  PR_SSP_XIF_OWMS_STOCK_REST_R;'),
            ('40 MES 재고 수신', 'JOB_PR_SSP_XIF_MES_STOCK_40_R(운영 06:05 ~ 10:55, 10분)', '확인 : VQ-41 · VQ-36(PLAN_40)', 'PR_SSP_XIF_MES_WIP_LOT_40_R;'),
            ('81·82 MES 재고 수신', 'JOB_PR_SSP_XIF_MES_STOCK_81_82_R(운영 10분)', '확인 : VQ-41 · VQ-36(PLAN_AUTO)', 'PR_SSP_XIF_MES_WIP_LOT_8X_R;'),
            ('전극 MES 재고 수신', 'JOB_PR_SSP_XIF_MES_STOCK_EE_R(운영 30분)', '확인 : VQ-41 · VQ-36(PLAN_EE)', 'PR_SSP_XIF_MES_WIP_LOT_EE_R;'),
            ('전극 창고(OWMS) 재고 수신', 'JOB_PR_SSP_XIF_OWMS_STOCK_EE_R(운영 10분)', '확인 : VQ-41 · VQ-36(PLAN_EE)', 'PR_SSP_XIF_OWMS_STOCK_EE_R;'),
            ('전극 원자재 창고(IWMS) 재고 수신', 'JOB_PR_SSP_XIF_IWMS_STOCK_EE_R(운영 10분)', '확인 : VQ-41 · VQ-36(PLAN_EE)', 'PR_SSP_XIF_IWMS_STOCK_EE_R;'),
            ('FP 확정 생산계획 · SSP 재고 스냅샷 · 화성 후 셀 · MES 재공 이력', 'JOB_PR_SSP_DNM_FP_PLAN_FROZEN(운영 1시간)', '40 · 81·82 · 전극 산출이 읽는 입력. 확인 : VQ-43 · VQ-41(SSP_DNM_STOCK_C)',
             'PR_SSP_DNM_FP_PLAN_FROZEN;\n  PR_SSP_DNM_STOCK;\n  PR_SSP_DNM_FORMATION_POST_CELL;\n  PR_SSP_DNM_MES_WIP_HISTORY;'),
            ('FP 출하가능량 변경분 수신', 'JOB_PR_SSP_XIF_FP_AMEND_SHIPAVAL(운영 2분)', '확인 : VQ-43', 'PR_SSP_XIF_FP_AMEND_SHIPAVAL;'),
            ('SCS 생산계획 수신', 'JOB_PR_SCM_DNM_SCS_PROD_PLAN', 'Packer 산출 입력. 확인 : VQ-43', 'PR_SSP_XIF_SCS_PROD_PLAN_R;'),
            ('SCS 재고 수신', 'JOB_PR_SCM_DNM_SCS_STOCK', 'Packer 기초재고. 확인 : VQ-43 · VQ-39', 'PR_SSP_XIF_SCS_STOCK_RSLT_SUM_R;')]
    for k, (title, job, chk, body) in enumerate(recv, 1):
        blk(f'0-2-{k}', '공통 : ' + title, ['잡 : ' + job, chk, '수신 테이블에 시험일 자료가 들어와 있을 때 실행. 수신 자료가 없으면 재고 수신 확인 표시(VQ-36)가 갱신되지 않음'], f'BEGIN\n  {body}\nEND;')
    for tag, co, job, when, extra in (('1-1', 'HQ00', 'JOB_PR_SSP_PLN_SHIP_PLAN_40', '08:00', 'BAL'), ('1-2', 'AZ00', 'JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ', '10:30', ''), ('1-3', 'NJ00', 'JOB_PR_SSP_PLN_SHIP_PLAN_40_C', '11:00', 'INV')):
        steps = (['  PR_SSP_ANL_SHIP_PLAN_40_BALANCE;                                              /* 잔량 정리 */'] if extra == 'BAL' else []) + [
            f"  PR_SSP_ANL_SHIP_CONFIRM_BATCH_40(P_DIVISION_ID => '40', P_COMPANY_ID => '{co}');   /* 확정 반영 */",
            f"  PR_SSP_ANL_SHIP_PLAN_40(P_DIVISION_ID => '40', P_COMPANY_ID => '{co}');            /* 출하계획 생성 */"] + (
            ["  PR_SSP_ANL_INVENTORY_RAW(P_DIVISION_ID => '40');                                  /* 재고 원장 */"] if extra == 'INV' else []) + [
            f"  PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40(P_COMPANY_ID1 => '{co}', P_LOG_MESSGE => V_P_LOG_MESSGE);   /* 선적요청 부족 메일 */"]
        blk(tag, f'40(Mobility&IT) 법인 {co} 산출', [f'잡 : {job}(운영 매일 {when})', '순서 : HQ00 → AZ00 → NJ00. 사전점검 No 16',
            f'실행 전 : VQ-37({co} READY_YN = Y) · 실행 후 : VQ-17(로그) · VQ-35(SP 상태 1) · VQ-45(결과 구성) · VQ-46(BALANCE 산식)',
            f'결과 : SSP_ANL_SHIP_PLAN_40 계획 시작일 {T} · 법인 {co}'],
            'DECLARE\n  V_P_LOG_MESSGE VARCHAR2(4000);\nBEGIN\n' + '\n'.join(steps) + '\nEND;')
    blk('2', '81·82(Auto&ESS) 컷오프', ['잡 : JOB_PR_SSP_PLN_SHIP_PLAN_81_82(운영 05:07 부터 10분)', '진입 조건을 충족한 법인만 진행. 남은 법인은 조건 충족 후 다시 실행. 사전점검 No 22',
        '실행 전 : VQ-38(법인별 READY_YN = Y) · 실행 후 : VQ-17(로그) · VQ-54(진행 표시) · VQ-47(OWMS 재고 마감) · VQ-48(결과 구성) · VQ-49(BALANCE 산식)',
        f'결과 : SSP_ANL_SHIP_PLAN_C 계획 시작일 {T1} · SSP_ANL_OWMS_STOCK_C2 CUTOFF_DATE {T1}'], 'BEGIN\n  PR_SSP_PLN_SHIP_PLAN_CUTOFF;\nEND;')
    blk('3', 'Packer 산출', ['잡 : JOB_PR_SSP_PLN_SHIP_PLAN_P(운영 매일 07:15)', '사전점검 No 28',
        '실행 전 : VQ-39(READY_YN = Y) · 실행 후 : VQ-17(로그) · VQ-39(최종 산출 기준일 갱신) · VQ-50(결과 구성) · VQ-51(BALANCE 산식)',
        f'결과 : SSP_ANL_SHIP_PLAN_P 계획 시작일 {T1} · 기초재고 기준일 {T3}'],
        'BEGIN\n  PR_SSP_ANL_SHIP_PLAN_P;      /* 출하계획 생성 */\n  PR_SSP_ANL_SHIP_CONFIRM_P;   /* 확정 반영 */\nEND;')
    blk('4', '전극(Electrode) 산출', ['잡 : JOB_PR_SSP_PLN_SHIP_PLAN_EE(운영 10분, 법인 시업 시각 이후)', '진입 조건을 충족한 법인만 진행. 사전점검 No 33',
        '실행 전 : VQ-40(법인별 READY_YN = Y) · 실행 후 : VQ-17(로그) · VQ-54(진행 표시) · VQ-52(결과 구성) · VQ-53(기초재고 · 재고 상세 마감)',
        f'결과 : SSP_ANL_SHIP_PLAN_EE 계획 시작일 {T}'], 'BEGIN\n  PR_SSP_ANL_SHIP_PLAN_EE;\nEND;')
    blk('5-1', '공통 : 사업부별 출하계획 · 확정 통합 스냅샷', ['잡 : JOB_PR_SSP_ANL_SHIP_PLAN_ALL(운영 30분)', '사업부별 산출([1] ~ [4])을 마친 뒤 실행. 사전점검 No 37',
        f'실행 후 : VQ-55(계획 시작일 {T1}) · VQ-44(통합 스냅샷 대상 기준일 갱신)'], 'BEGIN\n  PR_SSP_ANL_SHIP_PLAN_ALL(P_PLAN_START_YYYYMMDD => NULL);\nEND;')
    blk('5-2', '공통 : 일 마감 지연 문자', ['잡 : JOB_PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND(운영 10분)', '미완료 법인의 초과 기준 시각 직후 10분 안에 실행해야 적재됨. 사전점검 No 39',
        '실행 후 : VQ-57(문구 CUTOFF)'], 'BEGIN\n  PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND;\nEND;')
    logq = (f"WITH PRM AS (SELECT '{T}' AS P_TEST_DATE FROM DUAL)   /* 시험일. 이 줄의 값만 바꿔 실행 */\n"
            "SELECT L.PROGRAM_NAME\n     , L.LOG_TYPE                      /* START 시작, TXN 처리, END 종료, ERROR 오류 */\n     , L.LOG_COUNT\n     , SUBSTR(L.LOG_MESSAGE, 1, 200) AS LOG_MESSAGE\n"
            "     , SUBSTR(L.DESCRIPTION, 1, 200) AS DESCRIPTION\n     , L.SQL_ERR_CODE\n     , SUBSTR(L.SQL_ERR_MSG, 1, 300) AS SQL_ERR_MSG\n     , L.EVENT_DATE\n  FROM SCM_SYS_LOG_BATCH L\n     , PRM\n"
            " WHERE L.EVENT_DATE >= TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD')\n   AND L.EVENT_DATE < TO_DATE(PRM.P_TEST_DATE, 'YYYYMMDD') + 1\n"
            "   AND (   L.PROGRAM_NAME LIKE 'PR_SSP%'\n        OR L.PROGRAM_NAME IN ('PR_SCM_MST_PLAN', 'PR_SCM_DNM_STOCK_V'))\n ORDER BY L.EVENT_DATE\n        , L.PROGRAM_NAME")
    B.extend([BAR, '-- [9] 실행 로그 조회(조회 문장) : 시험일에 남은 SSP 산출 · 수신 프로그램 로그', '-- 확인 : 프로그램마다 START 와 END 가 짝으로 있고 ERROR 행 · SQL_ERR_CODE 가 없음. 로그가 없으면 진입 조건 미충족으로 건너뛴 것', BAR, logq + ';', ''])
    return '\n'.join(H + B), logq


def file_lint(text, mssql=False, allow_slash=False):
    bad = []
    for i, ln in enumerate(text.split('\n'), 1):
        if re.match(r'^(SET|PROMPT|DEFINE|UNDEFINE)\s|^&\w', ln): bad.append((i, 'SQL*Plus 명령', ln[:40]))
        if re.match(r'^/\s*$', ln) and not mssql and not allow_slash: bad.append((i, '단독 /', ln[:40]))
        if '?' in ln: bad.append((i, '? 문자', ln[:40]))
        if re.search(r':[A-Za-z_가-힣]', ln): bad.append((i, ':이름 형태', ln[:60]))
        if '\t' in ln: bad.append((i, '탭', ln[:40]))
    return bad


os.makedirs(OUT, exist_ok=True)
ora_txt, ora_rows = query_file(5); ms_txt, ms_rows = query_file(6); ex_txt, logq = exec_file()
names = {'ora': f'SSP_사전점검_검증쿼리_ORACLE_{T}.sql', 'ms': f'SSP_사전점검_검증쿼리_MSSQL_{T}.sql', 'ex': f'SSP_단위별_데이터산출_실행명령_ORACLE_{T}.sql'}
for k, txt in (('ora', ora_txt), ('ms', ms_txt), ('ex', ex_txt)):
    io.open(os.path.join(OUT, names[k]), 'w', encoding='utf-8', newline='\r\n').write(txt)
    stm = [s for s in re.split(r';\n\n', txt) if s.strip()]
    print(f'{names[k]} : {txt.count(chr(10)) + 1}줄 · 금지 형태 {file_lint(txt, allow_slash=(k == "ex"))[:3] or 0}')
# 블록 안 빈 줄 검사(실행 명령 파일)
blocks = re.findall(r'(?ms)^(?:DECLARE|BEGIN)\n.*?^END;', ex_txt)
print('실행 블록', len(blocks), '· 블록 안 빈 줄', sum(1 for b in blocks if '\n\n' in b), '· 쿼리 안 빈 줄', sum(1 for r in ora_rows if '\n\n' in r[5]) + sum(1 for r in ms_rows if '\n\n' in r[6]))
if NO_DB: sys.exit(0)
import dbconn
# ── 검증 1 : Oracle 파일에서 문장을 다시 잘라 ZIOUI1 에서 실행 ──
t = dbconn.connect('tobe'); tc = t.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE 시작', tc.fetchone()[0])
stmts = re.findall(r'(?ms)^(WITH PRM .*?|SELECT .*?);\n', ora_txt)
ok = ng = 0; tcols = {}
for s, r in zip(stmts, ora_rows):
    t0 = time.time()
    try: tc.execute(s); tcols[r[0]] = [d[0].upper() for d in tc.description]; n = len(tc.fetchmany(3000)); ok += 1; print(f'  {r[0]} OK {time.time() - t0:5.1f}s rows={n}')
    except Exception as e: ng += 1; print(f'  {r[0]} ERR {str(e)[:200]}')
print(f'  파일에서 자른 문장 {len(stmts)} · 정상 {ok} · 오류 {ng}')
try: tc.execute(logq); print('  [9] 로그 조회 OK rows=', len(tc.fetchmany(1000)))
except Exception as e: print('  [9] 로그 조회 ERR', str(e)[:200])
# 실행 명령 : 블록 문법 확인(구문 분석만 · 실행하지 않음) + 조회 문장 실행
pok = png = 0
for b in blocks:
    try: tc.parse(b); pok += 1
    except Exception as e: png += 1; print('  블록 문법 ERR', b.split('\n')[4][:60] if len(b.split('\n')) > 4 else b[:60], '|', str(e)[:160])
print(f'  실행 블록 문법 확인 {pok} · 오류 {png}(구문 분석만, 실행 안 함)')
for s in re.findall(r'(?ms)^(SELECT DIVISION_ID\n.*?);\n', ex_txt):
    try: tc.execute(s); print('  [0-1-확인] 조회 OK', [tuple(r) for r in tc.fetchall() if r[0] in ('40', '81', '82', 'EE')])
    except Exception as e: print('  [0-1-확인] 조회 ERR', str(e)[:200])
# 실행 명령 : 블록 안 프로그램 존재 · 상태 · 인자 이름(실행하지 않음)
ng2 = 0
for p in sorted(set(re.findall(r'\b(PR_[A-Z0-9_]+)\b', '\n'.join(blocks)))):
    tc.execute("SELECT status FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = :p AND object_type = 'PROCEDURE'", p=p); s = tc.fetchone()
    tc.execute("SELECT argument_name FROM all_arguments WHERE owner = 'SCM_MGR' AND object_name = :p AND argument_name IS NOT NULL", p=p); args = {a[0] for a in tc.fetchall()}
    used = set(re.findall(p + r'\((.*?)\);', '\n'.join(blocks), re.S) and re.findall(r'(P_[A-Z0-9_]+)\s*=>', ' '.join(re.findall(p + r'\((.*?)\);', '\n'.join(blocks), re.S))))
    bad = sorted(used - args)
    if not s or bad: ng2 += 1
    print(f'  프로그램 {p} : {s[0] if s else "없음"}' + (f' · 없는 인자 {bad}' if bad else ''))
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE 종료', tc.fetchone()[0], '· 없는 프로그램 · 인자', ng2)
# ── 검증 2 : MSSQL 파일 문장 문법 · 결과 열(실행 안 함) ──
a = dbconn.connect('asis'); ac = a.cursor(); ac.execute("SELECT DB_NAME(), CONVERT(VARCHAR(19), GETDATE(), 120)"); print('AS-IS', tuple(ac.fetchone()))
ms_stmts = re.findall(r'(?ms)^(WITH PRM.*?);\n', ms_txt); aok = ang = adif = 0
for s, r in zip(ms_stmts, ms_rows):
    try:
        ac.execute("EXEC sp_describe_first_result_set ?", s); cols = [x[2].upper() for x in ac.fetchall()]; aok += 1
        same = cols == tcols.get(r[0]); adif += 0 if same else 1; print(f'  {r[0]} 문법 OK · 열 {len(cols)}개 ' + ('TO-BE 와 같음' if same else '다름'))
    except Exception as e: ang += 1; print(f'  {r[0]} 문법 ERR {str(e)[:200]}')
ac.execute("SELECT CONVERT(VARCHAR(19), GETDATE(), 120)"); print('AS-IS 종료', ac.fetchone()[0], f'· 문장 {len(ms_stmts)} · 문법 정상 {aok} · 오류 {ang} · 열 이름 다름 {adif}')
