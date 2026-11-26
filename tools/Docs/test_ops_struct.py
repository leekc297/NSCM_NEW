# -*- coding: utf-8 -*-
"""ops_struct.py, ops_tobe.py 규칙 시험(2026-11-24 운영자 매뉴얼 확정 구성, 배치 = TO-BE). 실제 DB, PPT 생성 없음. 출력 줄 = PASS/FAIL, 끝 = ALL PASS/SOME FAIL"""
import os, sys, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ops_struct as OS
import ops_tobe as OT

ok = True


def chk(name, cond, extra=''):
    global ok
    print(('PASS' if cond else 'FAIL'), name, extra)
    ok = ok and bool(cond)


# AS-IS 스케줄 해독(TO-BE 잡 없을 때 참고 시각에만 씀)
d = OS.sched_info({'freq_type': '4', 'freq_interval': '1', 'freq_subday_type': '1', 'freq_subday_interval': '0', 'freq_recurrence_factor': '0', 'active_start_time': '60000', 'active_end_time': '235959', 'enabled': '1'})
chk('AS-IS 참고 매일 06:00 = 매일, 시각 1개, 6시 칸', d['days'] == '매일' and d['times'] == ['06:00'] and d['hours'] == [6], str(d))
h = OS.sched_info({'freq_type': '4', 'freq_interval': '1', 'freq_subday_type': '8', 'freq_subday_interval': '1', 'freq_recurrence_factor': '0', 'active_start_time': '0', 'active_end_time': '125959', 'enabled': '1'})
chk('AS-IS 참고 1시간마다 00~12시 = 반복 구간 13칸', h['hours'] == list(range(13)) and '1시간마다' in h['every'] and not h['times'], str(h))

# 프로세스 기본 묶음
chk('CUTOFF = 컷오프', OS.proc_of('JOB_PR_DM_CUTOFF', []) == '컷오프')
chk('MAIL = 메일과 SMS 알림', OS.proc_of('JOB_PR_DM_DNM_ESS_MAIL', ['PR_DM_DNM_ESS_MAIL_SEND']) == '메일과 SMS 알림')
chk('XIF_ERP_..._R = 인터페이스 수신', OS.proc_of('JOB_X', ['PR_DM_XIF_ERP_NSD0001_R']) == '인터페이스 수신')

# TO-BE 잡 달력 해독
c = OT.cal_info('FREQ=WEEKLY;BYDAY=TUE;BYHOUR=6;BYMINUTE=40;BYSECOND=0')
chk('TO-BE 달력 매주 화 06:40', c['days'] == '화' and c['times'] == ['06:40'] and c['hours'] == [6], str(c))
c = OT.cal_info('FREQ=HOURLY;INTERVAL=1')
chk('TO-BE 달력 1시간마다 = 24칸', c['every'] == '1시간마다' and len(c['hours']) == 24 and not c['times'], str(c))
c = OT.cal_info('FREQ=DAILY;BYHOUR=0,12;BYMINUTE=30')
chk('TO-BE 달력 매일 00:30, 12:30', c['days'] == '매일' and c['times'] == ['00:30', '12:30'], str(c))

# TO-BE 본문 읽기/쓰기(주석, 커서 이름, 객체 이름 제외)
db = OT.TobeDB.__new__(OT.TobeDB); db._src = {}; db._pkg = {}; db._io = {}; db.objects = {'PKG_X': 'PACKAGE'}
db.source = lambda n: """PROCEDURE P_T IS
CURSOR CUR_LOOP IS SELECT A FROM DM_SRC_TABLE;
BEGIN
-- INSERT INTO DM_COMMENTED
INSERT INTO SCM_MGR.DM_DST_TABLE (A) SELECT A FROM DM_SRC_TABLE S JOIN SCM_MST_SITE M ON 1 = 1;
UPDATE DM_UPD_TABLE SET A = 1;
MERGE INTO DM_MRG_TABLE T USING DUAL ON (1 = 1) WHEN MATCHED THEN UPDATE SET A = 1;
END;"""
wr, rd = db.io('PKG_X.P_T')
chk('TO-BE 쓰기 = INSERT, UPDATE, MERGE 대상(주석 제외)', {'DM_DST_TABLE', 'DM_UPD_TABLE', 'DM_MRG_TABLE'} <= set(wr) and 'DM_COMMENTED' not in wr, str(wr))
chk('TO-BE 읽기 = FROM, JOIN(커서 이름, DUAL 제외)', 'DM_SRC_TABLE' in rd and 'SCM_MST_SITE' in rd and 'CUR_LOOP' not in rd and 'DUAL' not in rd, str(rd))

# 패키지 본문 프로시저 구간 = 'END <이름>;' 까지(안쪽 PROCEDURE 선언에서 자르지 않음)
db2 = OT.TobeDB.__new__(OT.TobeDB); db2._src = {}; db2._pkg = {'PKG_T': """PROCEDURE P_A IS
  PROCEDURE LOCAL_X IS BEGIN NULL; END;
BEGIN
  INSERT INTO DM_A_TABLE VALUES (1);
END P_A;
PROCEDURE P_B IS BEGIN UPDATE DM_B_TABLE SET A = 1; END P_B;"""}
src = db2.source('PKG_T.P_A')
chk('본문 구간 = END P_A; 까지(안쪽 PROCEDURE 지나서)', 'DM_A_TABLE' in src and 'DM_B_TABLE' not in src, repr(src[-40:]))

# TO-BE 잡 단계(job_action '-- step N : 이름')
db.objects = {'PR_DM_A': 'PROCEDURE', 'PKG_DM_B': 'PACKAGE'}
st = db.steps({'action': "BEGIN\n -- step 1 : 수신\n PR_DM_A('X');\n -- step 2 : 계산\n SCM_MGR.PKG_DM_B.P_RUN;\n COMMIT;\nEND;"})
chk('TO-BE 잡 단계 2개, 프로시저 = TO-BE 객체만', st == [[1, '수신', ['PR_DM_A']], [2, '계산', ['PKG_DM_B.P_RUN']]], str(st))

# AS-IS 로직 검사
h = OS.asis_logic_hits({'chapters': [{'id': 'C9', 'slides': [{'kind': 'table', 'title': '점검', 'rows': [['SELECT * FROM msdb.dbo.sysjobs WITH(NOLOCK)']]}]},
                                     {'id': 'C11', 'slides': [{'kind': 'text', 'title': '로그', 'lines': ['USER_SCHEDULER_JOB_RUN_DETAILS 확인', '스케줄 없음. AS-IS 참고 시각: 매일 06:00']}]}]})
chk('AS-IS 로직 검사 = msdb, NOLOCK 잡음. TO-BE 문장, AS-IS 참고 시각은 통과', len(h) == 1 and h[0][0] == 'C9', str(h))

# 구성, 검사
F = {'S': [{'id': 'DMF0004', 'name': 'Sales Site', 'top': 'Demand', 'group': 'Demand Master', 'writes': 'DM_MST_SALES_SITE', 'reads': ''}],
     'J': [{'job': 'JOB_A', 'process': '컷오프', 'desc': '', 'schedule': '매일 06:00', 'steps': '1', 'exec': 'PR_A', 'ext': '', 'enabled': 'N'},
           {'job': 'JOB_B', 'process': '계획 생성', 'desc': '잡 설명', 'schedule': 'TO-BE 스케줄 없음. AS-IS 참고 시각: 매일 07:00', 'steps': '1', 'exec': 'PR_B', 'ext': 'ERP(SAP)', 'enabled': 'N'}],
     'T': [{'job': 'JOB_A', 'jobOn': 'N', 'on': '0', 'days': '매일', 'every': '', 'times': '06:00', 'hours': '6', 'basis': 'TO-BE 잡'},
           {'job': 'JOB_B', 'jobOn': 'N', 'on': '0', 'days': 'AS-IS 참고 매일 07:00', 'every': '', 'times': '', 'hours': '7', 'basis': 'TO-BE 잡(시각 = AS-IS 참고)'}],
     'L': [], 'SPT': [{'sp': 'PR_A', 'found': 'Y', 'writes': 'DM_PLN_X', 'reads': ''}],
     'TB': [{'table': 'DM_PLN_X', 'kind': '계획', 'screenWrites': '', 'screenReads': '', 'batchWrites': 'PR_A', 'batchReads': ''}],
     'B': [{'job': 'JOB_A', 'step': '1', 'stepName': 'S1', 'exec': 'PR_A'}], 'E': []}
plan = {'mods': ['DM'], 'key': 'DM'}
chs = OS.compose(plan, F, {'chapters': [{'id': 'C14', 'slides': [{'kind': 'text', 'title': 'x', 'lines': ['홍길동 010'], 'src': ['Doc']}]}]}, 'DM')
c14 = [c for c in chs if c['id'] == 'C14'][0]['slides']
chk('C14 연락처 = 모양만(빈 표 10행, content 의 C14 는 무시)', len(c14) == 1 and c14[0]['kind'] == 'table' and all(all(x == '' for x in r) for r in c14[0]['rows']) and len(c14[0]['rows']) == 10 and c14[0]['columns'] == OS.CONTACT_COLS)
c6 = [c for c in chs if c['id'] == 'C6'][0]['slides']
chk('C6 실행표 = 사용 여부와 상관없이 스케줄 표시', any(s['kind'] == 'timeline' and s['rows'][0]['on'] for s in c6))
chk('C6 시간대 요약 = TO-BE 스케줄, AS-IS 참고 시각 따로', c6[0]['rows'][0][:3] == ['TO-BE 스케줄', '0', '1'] and c6[0]['rows'][1][:3] == ['AS-IS 참고 시각', '0', '1'], str(c6[0]['rows']))
c5 = [c for c in chs if c['id'] == 'C5'][0]['slides'][0]
chk('C5 잡 목록 = 사용 여부 칸 없음, 잡 전부, 실행 프로시저', '사용 여부' not in c5['columns'] and '실행 프로시저' in c5['columns'] and len(c5['rows']) == 2)
ids = [c['id'] for c in chs]
chk('장 순서 = OPS(본문, 부록)', ids == [x[0] for x in OS.OPS], str(ids))

fails, sm = OS.check(plan, F, {'chapters': [{'id': 'C14', 'slides': [{'kind': 'text'}]}]}, lambda *a: None, lambda t, f: None)
chk('검사: AI 장 빠짐', sum(1 for f in fails if f.startswith('장 빠짐')) == len(OS.AI_REQ), str(len(fails)))
chk('검사: 프로세스 간지 빠짐(컷오프, 계획 생성)', any('간지 빠짐: 컷오프' in f for f in fails) and any('간지 빠짐: 계획 생성' in f for f in fails))
chk('검사: screenNotes, jobNotes(설명 없는 잡), tableNotes 빠짐', any(f.startswith('screenNotes 빠짐 1개') for f in fails) and any('jobNotes 빠짐 1개' in f and 'JOB_A' in f for f in fails) and any(f.startswith('tableNotes 빠짐 1개') for f in fails), str(fails))
chk('검사: C14 에 내용을 쓰면 실패', any(f.startswith('C14') for f in fails))
good = {'screenNotes': {'DMF0004': '판매 사이트 기준 정보 등록'}, 'jobNotes': {'JOB_A': '컷오프 실행'}, 'tableNotes': {'DM_PLN_X': '계획 결과'},
        'chapters': [{'id': c, 'slides': ([{'kind': 'divider', 'title': '컷오프'}, {'kind': 'flow', 'title': 'f', 'nodes': [{'id': 'a'}], 'edges': [], 'src': ['Doc']},
                                            {'kind': 'divider', 'title': '계획 생성'}, {'kind': 'flow', 'title': 'g', 'nodes': [{'id': 'b'}], 'edges': [], 'src': ['Doc']}] if c == 'C3'
                                           else [{'kind': 'text', 'title': 't', 'lines': ['확인함'], 'src': ['Doc']}])} for c in OS.AI_REQ]}
fails2, _ = OS.check(plan, F, good, lambda *a: None, lambda t, f: None)
chk('검사: 다 채우면 실패 0', not fails2, str(fails2))
bad = dict(good, jobNotes={'JOB_A': '컷오프 실행', 'JOB.OLD_ASIS': 'x'}, chapters=good['chapters'] + [{'id': 'C9', 'slides': [{'kind': 'table', 'title': '점검', 'columns': ['쿼리'], 'rows': [['SELECT TOP 10 * FROM msdb.dbo.sysjobhistory']], 'src': ['Doc']}]}])
fails3, _ = OS.check(plan, F, bad, lambda *a: None, lambda t, f: None)
chk('검사: AS-IS 로직, TO-BE 에 없는 잡 이름 = 실패', any(f.startswith('AS-IS 로직 들어감') for f in fails3) and any(f.startswith('TO-BE 잡에 없는 잡 이름 1개') for f in fails3), str(fails3))
print('ALL PASS' if ok else 'SOME FAIL')
sys.exit(0 if ok else 1)
