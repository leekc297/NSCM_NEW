# -*- coding: utf-8 -*-
"""클라우드 속도 점검 쿼리 생성과 로컬 검증. VMW 업무 'BATCHJOB 속도 점검'(chainId perfbatch) · 'UI 속도 점검'(chainId perfui) 이 부름
  python perf_check.py batch  --module <단위>   배치 프로시저 · JOB 실행 로그, 실행 중 단계, SQL 별 소요, 잠금, ASH 쿼리 파일
  python perf_check.py ui     --module <화면ID>  화면 조회 호출 소요(SCM_COM_SQL_LOG), 버튼 소요(SCM_COM_SYS_LOG), 조회 재실행, 문장별 소요, 실행계획, 통계
  python perf_check.py verify --module <단위> --kind batch|ui   만든 쿼리를 ZIOUI1 에서 실행(조회, 재실행 뒤 ROLLBACK)
  원문 기준 = 실행 때 사내 ZIOUI1 에서 새로 읽은 ALL_SOURCE · ALL_ARGUMENTS · ALL_SCHEDULER_JOBS · SCM_COM_SQL_LOG(파일 머리에 조회 시각과 LAST_DDL_TIME)
  출력 폴더 = quick.json 해당 업무 outputs 의 폴더(경로는 quick.json 1곳)
  배치 쿼리 원형 = Doc/통합테스트_SSP/PR_SSP_ANL_SHIP_PLAN_40_실행로그_점검쿼리_20261125.sql(2026-11-25 nscm-12 세션)
  UI 쿼리 원형 = Doc/verify/DMF0045/cloud_perf/DMF0045_CLOUD_QUERY_CHECK_20261125.sql(2026-11-25 DMF0045 세션)"""
import sys, os, io, re, json, datetime, collections
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
OWNER = 'SCM_MGR'
LINE = '-- ' + '=' * 110
STEP_RE = r"'^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)'"
BATCH_MODS = ['DM', 'SCP', 'SSP', 'SCM']
SLOW_SEC = 5   # R226: verify 에서 이 초를 넘는 블록 = [SLOW] + 실행계획(2026-11-26)
WRITE_NAME = r'SAVE|INSERT|_INS(_|$)|UPDATE|_UPD(_|$)|DELETE|_DEL(_|$)|MERGE|UPLOAD|CREATE|APPLY|CONFIRM|EXEC|BATCH|SEND|COPY|RESET|CALC|CANCEL|APPROV|CLOSE'


class InputError(Exception):
    pass


def item_def(chain):
    q = json.load(io.open(os.path.join(ROOT, 'tools', 'VibeManager', 'quick.json'), encoding='utf-8-sig'))
    for g in q.get('groups', []):
        for it in g.get('items', []):
            if it.get('chainId') == chain:
                return it
    raise InputError('quick.json 에 chainId %s 업무 없음' % chain)


def out_dir(chain, unit):
    it = item_def(chain)
    rel = (it.get('outputs') or [''])[0]
    if '${id}' not in rel:
        raise InputError('quick.json %s outputs 에 ${id} 없음' % chain)
    return os.path.join(ROOT, os.path.dirname(rel.replace('${id}', unit)))


def read_inputs(chain, unit):
    it = item_def(chain)
    f = it.get('inputsFile')
    if not f:
        return {}
    p = os.path.join(ROOT, f.replace('${id}', unit))
    return json.load(io.open(p, encoding='utf-8-sig')) if os.path.exists(p) else {}


def q(s):
    return "'" + str(s).replace("'", "''") + "'"


def inlist(xs):
    return ', '.join(q(x) for x in xs)


def connect():
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
    import dbconn
    t = dbconn.connect('tobe')
    t.autocommit = False
    c = t.cursor()
    try:
        c.callTimeout = 300000
    except Exception:
        pass
    return t, c


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


# 2026-11-25 클라우드 적용 회신 반영(사용자 'BATCH JOB, UI 클라우드 점검 쿼리를 최종 적용된 버전으로'):
#   ① 15:08 DMF0045 회신: 클라우드 접속 창 로그인 SCM_MGR, 현재 스키마 FP_MGR → 이름만 쓴 객체가 FP_MGR 에서 찾아짐(ORA-01031, 다른 객체). 파일 첫 쿼리에서 현재 스키마 고정
#   ② 14:05 DMF0045 회신: 클라우드 PKG 2436줄(11-24), 사내 2399줄(11-17) → 사내 원문 기준 줄 번호, 단계가 클라우드와 다름. 원문 판 대조 쿼리
#   ③ 14:03 DMF0045 회신 '3번이 계속 수행 중'(조회 재실행 972초): 재실행이 끝나지 않을 때 새 창에서 돌리는 실행 중 감시 쿼리
SCHEMA_SQL = 'ALTER SESSION SET CURRENT_SCHEMA = %s' % OWNER
SCHEMA_NOTES = ['클라우드 접속 창의 현재 스키마가 %s 가 아니면(2026-11-25 클라우드 회신 : 로그인 SCM_MGR, 현재 스키마 FP_MGR) 이름만 쓴 테이블, 패키지가 다른 스키마에서 찾아짐' % OWNER,
                '파일의 다른 쿼리보다 먼저 1회 실행. 새 접속 창을 열면 그 창에서도 다시 실행']


def src_versions(c, objs):
    """[(이름, 원문 유형, 줄 수, 원문 해시 합)] — 사내 ZIOUI1 값. 클라우드 같은 식(SUM(ORA_HASH(TEXT)))과 비교"""
    out = []
    for n, t in objs:
        c.execute("SELECT COUNT(*), SUM(ORA_HASH(text)) FROM all_source WHERE owner = :o AND name = :n AND type = :t", o=OWNER, n=n, t=t)
        k, h = c.fetchone()
        out.append((n, t, int(k or 0), int(h or 0)))
    return out


def version_sql(vers):
    """클라우드 원문 판 대조 : 줄 수, 해시 합이 사내 값과 같은지(SAME_AS_CORP)"""
    corp = '\n  UNION ALL '.join("SELECT %s AS NAME, %s AS TYPE, %d AS CORP_LINES, %d AS CORP_HASH FROM DUAL" % (q(n), q(t), k, h) for n, t, k, h in vers)
    return ("WITH CORP AS (\n  %s\n)\n, CLOUD AS (\nSELECT C.NAME\n     , C.TYPE\n     , COUNT(*) AS CLOUD_LINES\n     , SUM(ORA_HASH(C.TEXT)) AS CLOUD_HASH\n  FROM ALL_SOURCE C\n"
            " WHERE C.OWNER = '%s'\n   AND (C.NAME, C.TYPE) IN (SELECT CORP.NAME, CORP.TYPE FROM CORP)\n GROUP BY C.NAME\n        , C.TYPE\n)\n"
            "SELECT CORP.NAME\n     , CORP.TYPE\n     , (SELECT MAX(O.STATUS) FROM ALL_OBJECTS O WHERE O.OWNER = '%s' AND O.OBJECT_NAME = CORP.NAME AND O.OBJECT_TYPE = CORP.TYPE) AS STATUS\n"
            "     , (SELECT TO_CHAR(MAX(O.LAST_DDL_TIME), 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS O WHERE O.OWNER = '%s' AND O.OBJECT_NAME = CORP.NAME AND O.OBJECT_TYPE = CORP.TYPE) AS LAST_DDL_TIME\n"
            "     , CLOUD.CLOUD_LINES\n     , CORP.CORP_LINES\n     , CASE WHEN CLOUD.CLOUD_LINES = CORP.CORP_LINES AND CLOUD.CLOUD_HASH = CORP.CORP_HASH THEN 'Y' ELSE 'N' END AS SAME_AS_CORP\n"
            "  FROM CORP\n  LEFT JOIN CLOUD\n    ON CLOUD.NAME = CORP.NAME\n   AND CLOUD.TYPE = CORP.TYPE\n ORDER BY CORP.NAME\n        , CORP.TYPE") % (corp, OWNER, OWNER, OWNER)


VERSION_NOTES = ['확인 : SAME_AS_CORP = N 이면 클라우드 원문이 사내 원문과 다름. 아래 SRC_LINE(줄 번호), 단계 이름은 클라우드 원문 기준으로 다시 봄(원문 회신 필요)',
                 'CLOUD_LINES 가 비어 있으면 클라우드에 객체 없음']


def block(key, title, notes, sql, plsql=False):
    body = sql.rstrip().rstrip(';')
    end = body + ';\n/' if plsql else body + ';'
    return '\n'.join([LINE, '-- [%s] %s' % (key, title)] + ['-- ' + n for n in notes] + [LINE, end, '']) + '\n'


def write_out(dirp, base, head, parts, stmts, meta):
    os.makedirs(dirp, exist_ok=True)
    f = os.path.join(dirp, base + '.sql')
    io.open(f, 'w', encoding='utf-8', newline='\r\n').write(head + ''.join(parts))
    meta = dict(meta, file=os.path.basename(f), base=base, at=now(), statements=stmts)
    io.open(os.path.join(dirp, '_statements.json'), 'w', encoding='utf-8').write(json.dumps(meta, ensure_ascii=False, indent=1))
    print('[OUT]', os.path.relpath(f, ROOT).replace(os.sep, '/'))
    return f


# ======================================================================== BATCH
def resolve_batch(c, names):
    """입력 이름(프로시저, 패키지, PKG.PROC, JOB) → 대상 객체 · 로그 PROGRAM_NAME · JOB"""
    objs, jobs, miss = collections.OrderedDict(), [], []
    for raw in names:
        n = raw.strip().upper()
        if not re.match(r'^[A-Z0-9_$#.]+$', n):
            raise InputError('이름에 쓸 수 없는 글자: %s' % raw)
        c.execute("SELECT job_name, job_action FROM all_scheduler_jobs WHERE owner = :o AND job_name = :n", o=OWNER, n=n)
        j = c.fetchone()
        if j:
            jobs.append(j[0])
            act = j[1].read() if hasattr(j[1], 'read') else (j[1] or '')
            act = re.sub(r'/\*.*?\*/', ' ', act, flags=re.S)
            for p in re.findall(r'\b((?:PR|PKG|SP|FN)_[A-Z0-9_$#]+)(?:\.[A-Z0-9_$#]+)?\s*[(;]', act.upper()):
                objs.setdefault(p, None)
            continue
        objs.setdefault(n.split('.')[0], None)
    for o in list(objs):
        c.execute("SELECT object_type, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner = :o AND object_name = :n "
                  "AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY') ORDER BY object_type", o=OWNER, n=o)
        rs = c.fetchall()
        if not rs:
            miss.append(o); del objs[o]; continue
        types = [r[0] for r in rs]
        src = 'PACKAGE BODY' if 'PACKAGE BODY' in types else types[0]
        c.execute("SELECT text FROM all_source WHERE owner = :o AND name = :n AND type = :t ORDER BY line", o=OWNER, n=o, t=src)
        text = ''.join(r[0] for r in c.fetchall())
        progs = sorted(set(re.findall(r"\b\w*PROGRAM_NAME\w*\s+(?:VARCHAR2\s*\([^)]*\)\s*)?(?:CONSTANT\s+)?(?:VARCHAR2\s*\([^)]*\)\s*)?:=\s*'([^']+)'", text, re.I)))
        steps = len(re.findall(r'(?m)^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)', text))
        # 2026-11-25 최종 적용본(PR_SSP_ANL_SHIP_PLAN_40 점검 쿼리 [L3]): 계획 진행 상태 SCM_MST_PLAN_DETAIL 을 쓰는 프로시저면 그 표 조건값을 원문에서 읽음
        plan = None
        if re.search(r'\bSCM_MST_PLAN_DETAIL\b', text, re.I):
            plan = {k: sorted(set(re.findall(r"\b%s\s*=\s*'([A-Z0-9_]+)'" % k, text, re.I)))[:3] for k in ('MODELING_ID', 'PLAN_TYPE')}
        objs[o] = dict(types=types, src=src, status=[r[1] for r in rs], ddl=max(r[2] for r in rs), lines=text.count('\n'), progs=progs or [o], steps=steps, plan=plan)
    if not jobs and objs:
        c.execute("SELECT job_name, job_action FROM all_scheduler_jobs WHERE owner = :o", o=OWNER)
        for jn, act in c.fetchall():
            a = (act.read() if hasattr(act, 'read') else (act or '')).upper()
            a = re.sub(r'/\*.*?\*/', ' ', a, flags=re.S)
            if any(re.search(r'\b%s\b' % re.escape(o), a) for o in objs):
                jobs.append(jn)
    # 2026-11-25 최종 적용본 [L1]: 같은 JOB 에서 앞뒤로 도는 프로그램(JOB_ACTION 의 다른 단계)도 실행 로그에 같이 보여 줌. 법인, 사업부 인자 값도 읽음
    side, divs = [], set()
    for jn in sorted(set(jobs)):
        c.execute("SELECT job_action FROM all_scheduler_jobs WHERE owner = :o AND job_name = :n", o=OWNER, n=jn)
        r = c.fetchone()
        a = re.sub(r'/\*.*?\*/', ' ', ((r[0].read() if r and hasattr(r[0], 'read') else (r[0] if r else '')) or '').upper(), flags=re.S)
        side += [p for p in re.findall(r'\b((?:PR|SP)_[A-Z0-9_$#]+)\s*[(;]', a) if p not in objs and p not in side]
        divs |= set(re.findall(r"P_DIVISION_ID\s*=>\s*'([A-Z0-9]+)'", a))
    return objs, sorted(set(jobs)), miss, side, sorted(divs)


def batch_statements(objs, jobs, days, side=(), divs=(), vers=()):
    names = list(objs)
    progs = sorted({p for o in objs.values() for p in o['progs']})
    pkgs = sorted(n for n, o in objs.items() if 'PACKAGE' in o['types'])

    def prog_pred(al):
        """로그 PROGRAM_NAME 조건. 패키지는 'PKG.프로시저' 형식으로도 남으므로 LIKE 'PKG.%' 추가"""
        c = ['%s.PROGRAM_NAME IN (%s)' % (al, inlist(progs))] + ["%s.PROGRAM_NAME LIKE '%s.%%' ESCAPE '\\'" % (al, p.replace('_', '\\_')) for p in pkgs]
        return '(' + '\n        OR '.join(c) + ')'
    srcs = sorted({(n, o['src']) for n, o in objs.items()})
    S = collections.OrderedDict()
    S['L0'] = SCHEMA_SQL
    if vers:
        S['L0-1'] = version_sql(vers)
    obj_cte = ("OBJ AS (\nSELECT /*+ MATERIALIZE */ O.OBJECT_ID\n     , O.OBJECT_NAME\n  FROM ALL_OBJECTS O\n WHERE O.OWNER = '%s'\n   AND O.OBJECT_NAME IN (%s)\n"
               "   AND O.OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')\n)" % (OWNER, inlist(names)))
    src_cond = '\n    OR '.join("(C.NAME = %s AND C.TYPE = %s)" % (q(n), q(t)) for n, t in srcs)
    step_cte = ("STEP AS (\nSELECT /*+ MATERIALIZE */ C.NAME\n     , C.LINE AS FROM_LINE\n     , NVL(LEAD(C.LINE) OVER (PARTITION BY C.NAME ORDER BY C.LINE) - 1, 999999) AS TO_LINE\n"
                "     , RTRIM(LTRIM(C.TEXT), ' ' || CHR(9) || CHR(10) || CHR(13)) AS STEP_NAME\n  FROM ALL_SOURCE C\n WHERE C.OWNER = '%s'\n   AND (%s)\n   AND REGEXP_LIKE(C.TEXT, %s)\n)" % (OWNER, src_cond, STEP_RE))
    job_like = ('\n    OR '.join('S.ACTION = %s' % q(j) for j in jobs)) if jobs else "1 = 0"
    S['L1'] = ("WITH PRM AS (SELECT %d AS P_DAYS FROM DUAL)   /* 조회 일수. 이 줄의 값만 바꿔 실행 */\nSELECT L.EVENT_DATE\n     , L.PROGRAM_NAME\n     , L.LOG_TYPE\n     , L.LOG_COUNT\n"
               "     , SUBSTR(L.LOG_MESSAGE, 1, 200) AS LOG_MESSAGE\n     , SUBSTR(L.DESCRIPTION, 1, 300) AS DESCRIPTION\n     , L.SQL_ERR_CODE\n     , SUBSTR(L.IN_PARA_DATA, 1, 200) AS IN_PARA_DATA\n     , L.CREATED_BY\n"
               "  FROM SCM_SYS_LOG_BATCH L\n     , PRM\n WHERE %s\n   AND L.EVENT_DATE >= TRUNC(SYSDATE) - PRM.P_DAYS\n ORDER BY L.EVENT_DATE DESC") % (min(days, 3), prog_pred('L')[:-1] + ('\n        OR L.PROGRAM_NAME IN (%s))' % inlist(side) if side else ')'))
    S['L2'] = ("WITH PRM AS (SELECT %d AS P_DAYS FROM DUAL)   /* 조회 일수. 이 줄의 값만 바꿔 실행 */\n, LG AS (\nSELECT L.PROGRAM_NAME\n     , L.EVENT_DATE\n     , L.LOG_TYPE\n"
               "     , LEAD(L.EVENT_DATE) OVER (PARTITION BY L.PROGRAM_NAME ORDER BY L.EVENT_DATE, DECODE(L.LOG_TYPE, 'START', 1, 'TXN', 2, 'ERROR', 3, 'END', 4)) AS NEXT_DATE\n"
               "     , LEAD(L.LOG_TYPE)   OVER (PARTITION BY L.PROGRAM_NAME ORDER BY L.EVENT_DATE, DECODE(L.LOG_TYPE, 'START', 1, 'TXN', 2, 'ERROR', 3, 'END', 4)) AS NEXT_TYPE\n"
               "  FROM SCM_SYS_LOG_BATCH L\n     , PRM\n WHERE %s\n   AND L.LOG_TYPE IN ('START', 'END', 'ERROR')\n   AND L.EVENT_DATE >= TRUNC(SYSDATE) - PRM.P_DAYS\n)\n"
               "SELECT LG.PROGRAM_NAME\n     , LG.EVENT_DATE AS START_DATE\n     , CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_DATE END AS END_DATE\n"
               "     , CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_TYPE END AS END_TYPE\n"
               "     , ROUND((NVL(CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_DATE END, SYSDATE) - LG.EVENT_DATE) * 1440, 1) AS ELAPSED_MIN\n"
               "     , TO_CHAR(LG.EVENT_DATE, 'HH24:MI') AS START_HHMI\n  FROM LG\n WHERE LG.LOG_TYPE = 'START'\n ORDER BY LG.PROGRAM_NAME, LG.EVENT_DATE DESC") % (days, prog_pred('L'))
    plan = [o['plan'] for o in objs.values() if o.get('plan') is not None]
    if plan:
        mods = sorted({x for p in plan for x in p.get('MODELING_ID', [])}); pts = sorted({x for p in plan for x in p.get('PLAN_TYPE', [])})
        cond = ''.join(['\n   AND D.MODELING_ID IN (%s)' % inlist(mods) if mods else '', '\n   AND D.DIVISION_ID IN (%s)' % inlist(divs) if divs else '', '\n   AND D.PLAN_TYPE IN (%s)' % inlist(pts) if pts else ''])
        S['L2-1'] = ("SELECT D.MODELING_ID\n     , D.DIVISION_ID\n     , D.PLAN_ID\n     , D.PLAN_SEQ\n     , D.PLAN_TYPE\n     , D.PLAN_STATUS\n     , D.PLAN_START_DATE\n     , D.PLAN_END_DATE\n"
                     "     , ROUND((NVL(D.PLAN_END_DATE, SYSDATE) - D.PLAN_START_DATE) * 1440, 1) AS ELAPSED_MIN\n     , D.CREATION_DATE\n     , D.LAST_UPDATE_DATE\n  FROM SCM_MST_PLAN_DETAIL D\n"
                     " WHERE D.CREATION_DATE >= TRUNC(SYSDATE) - %d%s\n ORDER BY D.CREATION_DATE DESC NULLS LAST\n FETCH FIRST 10 ROWS ONLY") % (days, cond)
    jw = ('J.JOB_NAME IN (%s)' % inlist(jobs)) if jobs else '1 = 0'
    S['L3'] = ("SELECT J.JOB_NAME\n     , J.ENABLED\n     , J.STATE\n     , J.LAST_START_DATE\n     , J.LAST_RUN_DURATION\n     , J.NEXT_RUN_DATE\n     , J.REPEAT_INTERVAL\n"
               "     , R.SESSION_ID AS RUNNING_SID\n     , R.ELAPSED_TIME AS RUNNING_ELAPSED\n  FROM ALL_SCHEDULER_JOBS J\n  LEFT JOIN ALL_SCHEDULER_RUNNING_JOBS R\n    ON R.OWNER    = J.OWNER\n   AND R.JOB_NAME = J.JOB_NAME\n"
               " WHERE J.OWNER = '%s'\n   AND %s\n ORDER BY J.JOB_NAME") % (OWNER, jw)
    S['L3-1'] = ("SELECT D.JOB_NAME\n     , D.ACTUAL_START_DATE\n     , D.RUN_DURATION\n     , D.STATUS\n     , D.ERROR#\n     , SUBSTR(D.ADDITIONAL_INFO, 1, 300) AS ADDITIONAL_INFO\n"
                 "  FROM ALL_SCHEDULER_JOB_RUN_DETAILS D\n WHERE D.OWNER = '%s'\n   AND %s\n   AND D.ACTUAL_START_DATE >= SYSTIMESTAMP - INTERVAL '%d' DAY\n ORDER BY D.ACTUAL_START_DATE DESC") % (OWNER, jw.replace('J.', 'D.'), days)
    S['L4'] = ("WITH %s\n, %s\nSELECT S.INST_ID\n     , S.SID\n     , S.SERIAL#\n     , S.USERNAME\n     , S.MODULE\n     , S.ACTION\n     , S.STATUS\n     , S.LOGON_TIME\n     , S.SQL_EXEC_START\n"
               "     , ROUND((SYSDATE - S.SQL_EXEC_START) * 1440, 1) AS SQL_RUN_MIN\n     , S.SQL_ID\n     , (SELECT MAX(OBJ.OBJECT_NAME) FROM OBJ WHERE OBJ.OBJECT_ID = Q.PROGRAM_ID) AS SRC_OBJECT\n     , Q.PROGRAM_LINE# AS SRC_LINE\n"
               "     , (SELECT MAX(ST.STEP_NAME) FROM STEP ST, OBJ WHERE OBJ.OBJECT_ID = Q.PROGRAM_ID AND ST.NAME = OBJ.OBJECT_NAME AND Q.PROGRAM_LINE# BETWEEN ST.FROM_LINE AND ST.TO_LINE) AS STEP_NAME\n"
               "     , S.EVENT\n     , S.WAIT_CLASS\n     , S.SECONDS_IN_WAIT\n     , S.BLOCKING_INSTANCE\n     , S.BLOCKING_SESSION\n     , SUBSTR(Q.SQL_TEXT, 1, 200) AS SQL_TEXT\n"
               "  FROM GV$SESSION S\n  LEFT JOIN GV$SQL Q\n    ON Q.INST_ID      = S.INST_ID\n   AND Q.SQL_ID       = S.SQL_ID\n   AND Q.CHILD_NUMBER = S.SQL_CHILD_NUMBER\n"
               " WHERE S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)\n    OR S.PLSQL_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)\n    OR Q.PROGRAM_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)\n    OR %s") % (obj_cte, step_cte, job_like)
    S['L5'] = ("WITH PRM AS (SELECT %d AS P_DAYS FROM DUAL)   /* 이 일수 안에 실행된 SQL. 이 줄의 값만 바꿔 실행 */\n, %s\n, %s\nSELECT OBJ.OBJECT_NAME AS SRC_OBJECT\n     , Q.PROGRAM_LINE# AS SRC_LINE\n"
               "     , (SELECT MAX(ST.STEP_NAME) FROM STEP ST WHERE ST.NAME = OBJ.OBJECT_NAME AND Q.PROGRAM_LINE# BETWEEN ST.FROM_LINE AND ST.TO_LINE) AS STEP_NAME\n"
               "     , Q.SQL_ID\n     , Q.EXECUTIONS\n     , ROUND(Q.ELAPSED_TIME / 1000000, 1) AS ELAPSED_SEC\n     , ROUND(Q.ELAPSED_TIME / NULLIF(Q.EXECUTIONS, 0) / 1000000, 2) AS SEC_PER_EXEC\n"
               "     , ROUND(Q.CPU_TIME / 1000000, 1) AS CPU_SEC\n     , Q.BUFFER_GETS\n     , Q.DISK_READS\n     , Q.ROWS_PROCESSED\n     , Q.PLAN_HASH_VALUE\n     , Q.LAST_ACTIVE_TIME\n"
               "     , SUBSTR(Q.SQL_TEXT, 1, 150) AS SQL_TEXT\n  FROM GV$SQL Q\n  JOIN OBJ\n    ON OBJ.OBJECT_ID = Q.PROGRAM_ID\n     , PRM\n WHERE Q.LAST_ACTIVE_TIME >= TRUNC(SYSDATE) - PRM.P_DAYS + 1\n"
               " ORDER BY Q.ELAPSED_TIME DESC\n FETCH FIRST 50 ROWS ONLY") % (1, obj_cte, step_cte)
    S['L6'] = ("WITH %s\nSELECT W.INST_ID\n     , W.SID AS WAIT_SID\n     , W.EVENT AS WAIT_EVENT\n     , W.SECONDS_IN_WAIT\n     , B.SID AS BLOCK_SID\n     , B.SERIAL# AS BLOCK_SERIAL\n"
               "     , B.USERNAME AS BLOCK_USER\n     , B.MODULE AS BLOCK_MODULE\n     , B.ACTION AS BLOCK_ACTION\n     , B.STATUS AS BLOCK_STATUS\n     , B.SQL_ID AS BLOCK_SQL_ID\n     , B.PREV_SQL_ID AS BLOCK_PREV_SQL_ID\n"
               "     , (SELECT O.OWNER || '.' || O.OBJECT_NAME FROM ALL_OBJECTS O WHERE O.OBJECT_ID = W.ROW_WAIT_OBJ#) AS LOCK_OBJECT\n  FROM GV$SESSION W\n  JOIN GV$SESSION B\n"
               "    ON B.INST_ID = W.BLOCKING_INSTANCE\n   AND B.SID     = W.BLOCKING_SESSION\n WHERE W.BLOCKING_SESSION IS NOT NULL\n   AND (W.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)\n        OR %s)") % (obj_cte, job_like.replace('S.ACTION', 'W.ACTION').replace('\n    OR', '\n        OR'))
    S['L7'] = "SELECT INST_ID\n     , INSTANCE_NAME\n     , HOST_NAME\n  FROM GV$INSTANCE\n ORDER BY INST_ID"
    # 2026-11-26 R226(개선안 20261125150348_SELF): ASH 는 시작 ~ SYSTIMESTAMP 범위를 WHERE 첫 조건으로 좁히고, 생성 시각 기준 리터럴 하한(LAST_RUN 의 START 검색 범위와 같은 전날 0시)을 같이 둠.
    #   START 로그가 없을 때 기본 조회 범위 180분 → 30분. SQL_LINE 은 ASH 에 나온 SQL_ID 와 시작 뒤 실행된 문장만 읽음
    ash_floor = (datetime.datetime.now() - datetime.timedelta(days=1)).strftime('%Y-%m-%d 00:00:00')
    S['L8'] = ("WITH PRM AS (SELECT 30 AS P_FROM_MIN FROM DUAL)   /* START 로그가 없을 때 조회 시작(분 전). 이 줄의 값만 바꿔 실행 */\n, %s\n, %s\n"
               ", LAST_RUN AS (\nSELECT /*+ MATERIALIZE */ CAST(NVL(MAX(L.EVENT_DATE), MAX(SYSDATE - PRM.P_FROM_MIN / 1440)) AS TIMESTAMP) AS FROM_TS\n  FROM PRM\n  LEFT JOIN SCM_SYS_LOG_BATCH L\n"
               "    ON %s\n   AND L.LOG_TYPE     = 'START'\n   AND L.EVENT_DATE  >= TRUNC(SYSDATE) - 1\n)\n"
               ", ASH AS (\nSELECT /*+ MATERIALIZE */ A.INST_ID\n     , A.SQL_ID\n     , NVL(A.EVENT, 'ON CPU') AS EVENT\n     , COUNT(*) AS SAMPLE_CNT\n     , MIN(A.SAMPLE_TIME) AS FIRST_SAMPLE\n     , MAX(A.SAMPLE_TIME) AS LAST_SAMPLE\n"
               "  FROM GV$ACTIVE_SESSION_HISTORY A\n WHERE A.SAMPLE_TIME BETWEEN (SELECT LAST_RUN.FROM_TS FROM LAST_RUN) AND SYSTIMESTAMP\n"
               "   AND A.SAMPLE_TIME >= TIMESTAMP '" + ash_floor + "'   /* 생성 시각 기준 하한(전날 0시). 다른 날 실행하면 이 값도 바꿈 */\n"
               "   AND A.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)\n"
               " GROUP BY A.INST_ID\n        , A.SQL_ID\n        , NVL(A.EVENT, 'ON CPU')\n)\n"
               ", SQL_LINE AS (\nSELECT /*+ MATERIALIZE */ Q.INST_ID\n     , Q.SQL_ID\n     , MAX(OBJ.OBJECT_NAME) AS SRC_OBJECT\n     , MAX(Q.PROGRAM_LINE#) AS SRC_LINE\n     , MAX(SUBSTR(Q.SQL_TEXT, 1, 150)) AS SQL_TEXT\n"
               "  FROM GV$SQL Q\n  JOIN OBJ\n    ON OBJ.OBJECT_ID = Q.PROGRAM_ID\n WHERE Q.SQL_ID IN (SELECT ASH.SQL_ID FROM ASH)\n   AND Q.LAST_ACTIVE_TIME >= CAST((SELECT LAST_RUN.FROM_TS FROM LAST_RUN) AS DATE)\n"
               " GROUP BY Q.INST_ID\n        , Q.SQL_ID\n)\n"
               "SELECT SL.SRC_OBJECT\n     , ST.STEP_NAME\n     , SL.SRC_LINE\n     , A.SQL_ID\n     , A.EVENT\n     , A.SAMPLE_CNT\n     , A.FIRST_SAMPLE\n     , A.LAST_SAMPLE\n     , SL.SQL_TEXT\n"
               "  FROM ASH A\n  LEFT JOIN SQL_LINE SL\n    ON SL.INST_ID = A.INST_ID\n   AND SL.SQL_ID  = A.SQL_ID\n  LEFT JOIN STEP ST\n    ON ST.NAME = SL.SRC_OBJECT\n   AND SL.SRC_LINE BETWEEN ST.FROM_LINE AND ST.TO_LINE\n"
               " ORDER BY A.SAMPLE_CNT DESC") % (obj_cte, step_cte, prog_pred('L'))
    return S, progs


def gen_batch(unit):
    unit = unit.strip().upper()
    parts_ = [p for p in unit.split('_') if p]
    if not parts_ or any(p not in BATCH_MODS for p in parts_):
        raise InputError('단위 %s: 모듈은 %s 만 씀' % (unit, ', '.join(BATCH_MODS)))
    inp = read_inputs('perfbatch', unit)
    names = [x for x in re.split(r'[\s,]+', str(inp.get('targets') or '')) if x]
    if not names:
        raise InputError('대상 프로시저 또는 JOB 이름이 비어 있음')
    try:
        days = max(1, min(60, int(str(inp.get('days') or '14').strip())))
    except ValueError:
        raise InputError('조회 일수는 숫자: %s' % inp.get('days'))
    t, c = connect()
    c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); at = c.fetchone()[0]
    objs, jobs, miss, side, divs = resolve_batch(c, names)
    vers = src_versions(c, [(n, o['src']) for n, o in objs.items()]) if objs else []
    t.close()
    if not objs:
        raise InputError('ZIOUI1 에 없는 이름: %s' % ', '.join(miss or names))
    S, progs = batch_statements(objs, jobs, days, side, divs, vers)
    tag = re.sub(r'[^A-Z0-9_]', '_', names[0].upper())[:60] + ('_외%d' % (len(names) - 1) if len(names) > 1 else '')
    base = 'BATCH_속도점검_%s_%s' % (tag, datetime.datetime.now().strftime('%Y%m%d_%H%M'))
    head = [LINE, '-- BATCHJOB 속도 점검 쿼리 · Oracle(클라우드) · 조회만 수행',
            '-- 실행 : DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). 결과를 회신',
            '-- 입력 : %s · 조회 일수 %d' % (', '.join(names), days),
            '-- 원문 기준 : 사내 ZIOUI1 %s 조회' % at]
    for n, o in objs.items():
        head.append('--   %s : %s · %s · LAST_DDL_TIME %s · %d줄 · 단계 주석 %d개' % (n, '/'.join(o['types']), '/'.join(o['status']), o['ddl'], o['lines'], o['steps']))
    head += ['-- 로그 PROGRAM_NAME(SCM_SYS_LOG_BATCH) : %s' % ', '.join(progs + ['%s.(프로시저 이름)' % n for n, o in objs.items() if 'PACKAGE' in o['types']]),
             '-- JOB : %s' % (', '.join(jobs) if jobs else '없음(JOB 에서 부르지 않음. [L3] 결과 0행)')]
    if side:
        head.append('-- 같은 JOB 의 다른 단계(실행 로그 [L1] 에 같이 표시) : %s' % ', '.join(side))
    if miss:
        head.append('-- ZIOUI1 에 없는 이름(쿼리에서 뺌) : %s' % ', '.join(miss))
    head += ['-- [L4] ~ [L8] 은 V$ 조회 권한 필요. [L8] 은 Diagnostics Pack(ASH) 사용 조건. ORA-00942 가 나면 DBA 에 실행 요청',
             '-- 단계 이름(STEP_NAME) = 프로시저 안 /* 1-1 … */ 형식 주석. 주석이 없는 프로시저는 빈 값이고 SRC_LINE 으로 봄',
             '-- SCM_SYS_LOG_BATCH 는 인덱스가 없음(ZIOUI1 195,627행 기준). [L1] [L2] 는 전체 읽기', LINE, '', '']
    parts = [block('L0', '현재 스키마 고정(파일 첫 쿼리)', SCHEMA_NOTES, S['L0'])]
    if 'L0-1' in S:
        parts.append(block('L0-1', '클라우드 원문 판 대조(사내 ZIOUI1 원문과 같은지)', VERSION_NOTES, S['L0-1']))
    parts += [block('L1', '최근 실행 로그' + (' · 같은 JOB 에서 앞뒤로 도는 프로그램 포함' if side else ''), ['확인 : 마지막 START 뒤에 END 나 ERROR 가 있는지. ERROR 면 LOG_MESSAGE, DESCRIPTION(오류 줄)'], S['L1']),
             block('L2', '실행 회차별 소요 시간', ['확인 : 회차마다 시작, 종료, 소요 분. END_TYPE 이 비어 있으면 실행 중이거나 세션이 끊긴 회차'], S['L2'])]
    if 'L2-1' in S:
        parts.append(block('L2-1', '계획 진행 상태(SCM_MST_PLAN_DETAIL, 최근 10회)', ['확인 : PLAN_STATUS 0 = 진행 중, 1 = 정상 종료, -1 = 오류. 0 인데 [L4] 에 세션이 없으면 비정상 종료', '조건값(MODELING_ID, DIVISION_ID, PLAN_TYPE) = 사내 원문, JOB 인자에서 읽은 값'], S['L2-1']))
    parts += [
             block('L3', 'JOB 상태, 실행 중 JOB', ['확인 : RUNNING_SID 값이 있으면 실행 중. LAST_RUN_DURATION 으로 이전 회차 소요'], S['L3']),
             block('L3-1', 'JOB 실행 이력', ['확인 : 회차별 RUN_DURATION, STATUS, 오류'], S['L3-1']),
             block('L4', '지금 실행 중인 세션과 현재 단계(V$ 권한 필요)', ['확인 : STEP_NAME, SRC_LINE = 지금 실행 중인 위치. EVENT, BLOCKING_SESSION = 대기 원인. BLOCKING_SESSION 값이 있으면 [L6]'], S['L4']),
             block('L5', 'SQL 별 소요 시간(V$ 권한 필요)', ['확인 : 누적 소요 큰 순서. ELAPSED_SEC 는 공유 풀 누적값이라 앞 회차가 더해져 있음(EXECUTIONS, SEC_PER_EXEC 로 구분)'], S['L5']),
             block('L6', '잠금 대기(V$ 권한 필요)', ['확인 : 대상 세션을 막는 세션의 MODULE, ACTION, SQL'], S['L6']),
             block('L7', '인스턴스 수', ['확인 : 2 이상이면 GV$ 조회가 인스턴스마다 나뉘어 실행됨'], S['L7']),
             block('L8', '이번 회차 단계별 소요와 대기(ASH, V$ 권한 + Diagnostics Pack)', ['확인 : 단계(STEP_NAME)별 표본 수. 1표본 = 약 1초. EVENT 가 ON CPU 외 값이면 그 대기가 원인', '조회 범위 = 마지막 START 부터. START 가 없으면 P_FROM_MIN 분 전부터'], S['L8'])]
    stmts = [dict(key=k, sql=v, plsql=False) for k, v in S.items()]
    write_out(out_dir('perfbatch', unit), base, '\n'.join(head), parts, stmts, dict(kind='batch', unit=unit, targets=names, objects=list(objs), jobs=jobs, programs=progs, missing=miss, side=side, versions=vers))
    print('대상 객체 :', ', '.join(objs), '· JOB :', ', '.join(jobs) or '없음', '· PROGRAM_NAME :', ', '.join(progs))
    return 0


# ======================================================================== UI
def split_args(s):
    """{call P( 'a', 'b''c', NULL, 1)} 의 인자 목록(문자 그대로)"""
    out, cur, inq, i = [], '', False, 0
    while i < len(s):
        ch = s[i]
        if inq:
            cur += ch
            if ch == "'":
                if i + 1 < len(s) and s[i + 1] == "'":
                    cur += "'"; i += 1
                else:
                    inq = False
        elif ch == "'":
            inq = True; cur += ch
        elif ch == ',':
            out.append(cur.strip()); cur = ''
        else:
            cur += ch
        i += 1
    if cur.strip() or out:
        out.append(cur.strip())
    return out


def safe_lit(v):
    """로그 값 → PL/SQL 리터럴. & ? : 는 CHR() 로(DBeaver 변수 입력 창 방지)"""
    if v.upper() == 'NULL' or v == '':
        return 'NULL'
    if v.startswith("'"):
        body = v[1:-1]
        for ch, n in (('&', 38), ('?', 63), (':', 58)):
            body = body.replace(ch, "' || CHR(%d) || '" % n)
        return "'" + body + "'"
    return v if re.match(r'^-?\d+(\.\d+)?$', v) else 'NULL'


def ui_info(c, sid, log_rows):
    c.execute("SELECT object_name, object_type, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner = :o AND object_type IN ('PACKAGE', 'PACKAGE BODY') "
              "AND (object_name = :p OR object_name LIKE :l) ORDER BY object_name, object_type", o=OWNER, p='PKG_' + sid, l='PKG_' + sid + '\\_%')
    pk = collections.OrderedDict()
    for n, ty, st, ddl in c.fetchall():
        pk.setdefault(n, []).append((ty, st, ddl))
    if not pk:
        raise InputError('ZIOUI1 에 PKG_%s 패키지 없음' % sid)
    # 최근 화면 호출 표본(ZIOUI1 SCM_COM_SQL_LOG 마지막 log_rows 행)
    c.execute("SELECT MAX(LOG_SEQ) FROM SCM_COM_SQL_LOG"); mx = c.fetchone()[0] or 0
    c.execute("SELECT L.LOG_SEQ, DBMS_LOB.SUBSTR(L.SQL_TEXT, 4000, 1), L.ELAPSED_MS FROM SCM_COM_SQL_LOG L WHERE L.LOG_SEQ > :f AND L.SQL_ID = 'com.lgcns.nscm.callProc' "
              "AND DBMS_LOB.SUBSTR(L.SQL_TEXT, 200, 1) LIKE :k ORDER BY L.LOG_SEQ DESC", f=mx - log_rows, k='%PKG_' + sid + '%')
    sample = {}
    for seq, txt, ms in c.fetchall():
        m = re.search(r'call\s+((PKG_\w+)\.(\w+))\s*\((.*)\)\s*\}?\s*$', txt or '', re.S | re.I)
        if m and m.group(2).upper() in pk and m.group(1).upper() not in sample:
            sample[m.group(1).upper()] = dict(seq=seq, ms=ms, args=split_args(m.group(4)), text=txt)
    # 조회 프로시저 = 표본에 있는 것 + OUT REF CURSOR 가 있고 이름에 GET, SEARCH, SELECT 가 든 것
    c.execute("SELECT package_name, object_name, NVL(overload, '0'), position, argument_name, in_out, data_type FROM all_arguments WHERE owner = :o AND package_name IN (%s) "
              "AND data_level = 0 ORDER BY package_name, object_name, overload, position" % inlist(pk), o=OWNER)
    args = collections.OrderedDict()
    for pn, on, ov, pos, an, io_, dt in c.fetchall():
        args.setdefault((pn + '.' + on, ov), []).append(dict(pos=pos, name=an, io=io_, type=dt))
    # 2026-11-25 14:08 사고 : 로그 표본에 있던 저장 프로시저(P_DMF0045_SAVE_SHIPMENT_REQUEST, P_SCP0007_SAVE_BOD)를 재실행 대상에 넣음
    #   → 재실행 대상 = 이름에 GET, SEARCH, SELECT 가 있고 저장 낱말이 없으며, 본문에 COMMIT 과 GT_ 외 테이블 쓰기가 없는 프로시저만
    body = {}
    for pn in pk:
        c.execute("SELECT text FROM all_source WHERE owner = :o AND name = :n AND type = 'PACKAGE BODY' ORDER BY line", o=OWNER, n=pn)
        body[pn] = ''.join(r[0] for r in c.fetchall())
    def proc_body(full):
        pn, nm = full.split('.')
        s = body.get(pn, '')
        m = re.search(r'(?im)^\s*PROCEDURE\s+%s\b' % re.escape(nm), s)
        if not m:
            return ''
        n = re.search(r'(?im)^\s*(PROCEDURE|FUNCTION)\s+\w+', s[m.end():])
        return s[m.start():m.end() + (n.start() if n else len(s))]
    procs, skipped = [], []
    for (full, ov), al in args.items():
        al = [a for a in al if a['pos'] and a['pos'] > 0]
        has_cur = any(a['type'] == 'REF CURSOR' and 'OUT' in a['io'] for a in al)
        nm = full.split('.')[1]
        if not has_cur or not re.search(r'GET|SEARCH|SELECT|_SEL', nm):
            continue
        if re.search(WRITE_NAME, nm):
            skipped.append((full, '이름에 저장 낱말')); continue
        b = re.sub(r'--[^\n]*|/\*.*?\*/', ' ', proc_body(full), flags=re.S)
        if re.search(r'\bCOMMIT\b', b, re.I):
            skipped.append((full, '본문에 COMMIT')); continue
        w = [x for x in re.findall(r'\b(?:INSERT\s+INTO|UPDATE|DELETE\s+FROM|MERGE\s+INTO)\s+(?:SCM_MGR\.)?(\w+)', b, re.I) if not x.upper().startswith('GT_')]
        procs.append(dict(full=full, ov=ov, args=al, sample=sample.get(full), writes=sorted({x.upper() for x in w})))
    procs.sort(key=lambda p: (p['sample'] is None, -(p['sample'] or {}).get('ms', 0) if p['sample'] else 0, p['full']))
    # 참조 테이블(패키지 본문 의존 관계)
    c.execute("SELECT DISTINCT d.referenced_name, NVL(t.temporary, 'N') FROM all_dependencies d JOIN all_tables t ON t.owner = d.referenced_owner AND t.table_name = d.referenced_name "
              "WHERE d.owner = :o AND d.name IN (%s) AND d.type = 'PACKAGE BODY' AND d.referenced_type = 'TABLE' ORDER BY 1" % inlist(pk), o=OWNER)
    tabs = c.fetchall()
    c.execute("SELECT DISTINCT d.referenced_name FROM all_dependencies d WHERE d.owner = :o AND d.name IN (%s) AND d.type = 'PACKAGE BODY' AND d.referenced_type = 'SYNONYM' ORDER BY 1" % inlist(pk), o=OWNER)
    syns = [r[0] for r in c.fetchall()]
    if syns:
        c.execute("SELECT DISTINCT s.table_name, NVL(t.temporary, 'N') FROM all_synonyms s JOIN all_tables t ON t.owner = s.table_owner AND t.table_name = s.table_name WHERE s.synonym_name IN (%s) AND s.owner IN (:o, 'PUBLIC')" % inlist(syns[:900]), o=OWNER)
        tabs = sorted(set(tabs) | set(c.fetchall()))
    return pk, procs[:10], tabs, skipped, mx


def call_block(p):
    """조회 1회 실행 블록 : 소요(프로시저, FETCH), 커서별 행 수"""
    decl, call, after = [], [], []
    vals = (p['sample'] or {}).get('args') or []
    for i, a in enumerate(p['args']):
        nm = a['name'] or 'P%d' % a['pos']
        if 'OUT' in a['io']:
            v = 'V_%d' % a['pos']
            if a['type'] == 'REF CURSOR':
                decl.append('    %-12s SYS_REFCURSOR;' % v)
                after.append(v)
            elif a['type'] in ('NUMBER', 'INTEGER', 'BINARY_INTEGER', 'PLS_INTEGER', 'FLOAT'):
                decl.append('    %-12s NUMBER;' % v)
            elif a['type'] == 'DATE':
                decl.append('    %-12s DATE;' % v)
            else:
                decl.append('    %-12s VARCHAR2(32767);' % v)
            call.append('%s => %s' % (nm, v))
        else:
            raw = vals[i] if i < len(vals) else None
            if raw is None:
                lit = "'ALL'" if a['type'] in ('VARCHAR2', 'CHAR', 'NVARCHAR2') else 'NULL'
                call.append('%s => %s   /* 로그 표본 없음. 조건값 확인 필요 */' % (nm, lit))
            elif a['type'] == 'DATE':
                call.append('%s => NULL   /* DATE 인자. 로그 값 %s */' % (nm, raw.replace('*/', '')))
            else:
                call.append('%s => %s' % (nm, safe_lit(raw)))
    lines = ['DECLARE'] + decl + ['    V_CUR        INTEGER;', '    V_COLS       INTEGER;', '    V_DESC       DBMS_SQL.DESC_TAB2;', '    V_ROWS       NUMBER;',
             '    V_T0         NUMBER;', '    V_T1         NUMBER;', '    V_T2         NUMBER;', 'BEGIN', '    V_T0 := DBMS_UTILITY.GET_TIME;',
             '    %s(' % p['full'], '        ' + '\n      , '.join(call), '    );', '    V_T1 := DBMS_UTILITY.GET_TIME;']
    for v in after:
        lines += ['    BEGIN', '        V_ROWS := 0;', '        V_CUR := DBMS_SQL.TO_CURSOR_NUMBER(%s);' % v, '        DBMS_SQL.DESCRIBE_COLUMNS2(V_CUR, V_COLS, V_DESC);',
                  '        WHILE DBMS_SQL.FETCH_ROWS(V_CUR) > 0 LOOP', '            V_ROWS := V_ROWS + 1;', '        END LOOP;', '        DBMS_SQL.CLOSE_CURSOR(V_CUR);',
                  "        DBMS_OUTPUT.PUT_LINE('%s ROWS = ' || V_ROWS || ' , COLS = ' || V_COLS);" % v,
                  '    EXCEPTION', "        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('%s 열리지 않음 : ' || SQLERRM);" % v, '    END;']
    lines += ['    V_T2 := DBMS_UTILITY.GET_TIME;', "    DBMS_OUTPUT.PUT_LINE('PROC_SEC  = ' || TO_CHAR((V_T1 - V_T0) / 100, 'FM9999990.00'));",
              "    DBMS_OUTPUT.PUT_LINE('FETCH_SEC = ' || TO_CHAR((V_T2 - V_T1) / 100, 'FM9999990.00'));",
              "    DBMS_OUTPUT.PUT_LINE('TOTAL_SEC = ' || TO_CHAR((V_T2 - V_T0) / 100, 'FM9999990.00'));", 'END;']
    return '\n'.join(lines)


def gen_ui(sid):
    sid = sid.strip().upper()
    if not re.match(r'^[A-Z]{2,4}\d{4}[A-Z]?$', sid):
        raise InputError('화면 ID 형식 아님: %s' % sid)
    log_rows = 500000
    t, c = connect()
    c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); at = c.fetchone()[0]
    pk, procs, tabs, skipped, mx = ui_info(c, sid, log_rows)
    vers = src_versions(c, [(n, ty) for n, v in pk.items() for ty, _st, _d in v])
    t.close()
    pkl = inlist(pk)
    like = "DBMS_LOB.SUBSTR(L.SQL_TEXT, 200, 1) LIKE '%%PKG\\_%s%%' ESCAPE '\\'" % sid
    rng = ("PRM AS (SELECT 7 AS P_DAYS, 500000 AS P_LOG_ROWS FROM DUAL)   /* 조회 일수, 최근 로그 행 수 범위. 이 줄의 값만 바꿔 실행 */\n"
           ", RNG AS (SELECT MAX(X.LOG_SEQ) - MAX(PRM.P_LOG_ROWS) AS FROM_SEQ FROM SCM_COM_SQL_LOG X, PRM)")
    S = collections.OrderedDict()
    S['U0-0'] = SCHEMA_SQL
    S['U0-1'] = version_sql(vers)
    S['U0'] = ("WITH %s\nSELECT MIN(L.LOG_SEQ) AS FROM_SEQ\n     , MAX(L.LOG_SEQ) AS TO_SEQ\n     , MIN(L.EXECUTE_TIME) AS FROM_TIME\n     , MAX(L.EXECUTE_TIME) AS TO_TIME\n"
               "  FROM SCM_COM_SQL_LOG L\n     , RNG\n WHERE L.LOG_SEQ > RNG.FROM_SEQ") % rng
    S['U1'] = ("WITH %s\nSELECT REGEXP_SUBSTR(DBMS_LOB.SUBSTR(L.SQL_TEXT, 200, 1), 'PKG_[A-Z0-9_]+\\.[A-Z0-9_]+', 1, 1, 'i') AS PROC_NAME\n     , COUNT(*) AS CALL_CNT\n"
               "     , ROUND(AVG(L.ELAPSED_MS)) AS AVG_MS\n     , ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY L.ELAPSED_MS)) AS P90_MS\n     , MAX(L.ELAPSED_MS) AS MAX_MS\n"
               "     , SUM(CASE WHEN L.EXCEPTION IS NOT NULL THEN 1 ELSE 0 END) AS ERR_CNT\n     , MAX(L.EXECUTE_TIME) AS LAST_TIME\n"
               "  FROM SCM_COM_SQL_LOG L\n     , RNG\n     , PRM\n WHERE L.LOG_SEQ > RNG.FROM_SEQ\n   AND L.SQL_ID = 'com.lgcns.nscm.callProc'\n   AND L.EXECUTE_TIME >= SYSTIMESTAMP - NUMTODSINTERVAL(PRM.P_DAYS, 'DAY')\n"
               "   AND %s\n GROUP BY REGEXP_SUBSTR(DBMS_LOB.SUBSTR(L.SQL_TEXT, 200, 1), 'PKG_[A-Z0-9_]+\\.[A-Z0-9_]+', 1, 1, 'i')\n ORDER BY MAX_MS DESC") % (rng, like)
    S['U2'] = ("WITH %s\nSELECT L.LOG_SEQ\n     , L.EXECUTE_TIME\n     , L.ELAPSED_MS\n     , L.RESULT_COUNT\n     , L.CREATED_BY\n     , DBMS_LOB.SUBSTR(L.SQL_TEXT, 2000, 1) AS SQL_TEXT\n"
               "     , DBMS_LOB.SUBSTR(L.EXCEPTION, 300, 1) AS EXCEPTION\n  FROM SCM_COM_SQL_LOG L\n     , RNG\n     , PRM\n WHERE L.LOG_SEQ > RNG.FROM_SEQ\n   AND L.SQL_ID = 'com.lgcns.nscm.callProc'\n"
               "   AND L.EXECUTE_TIME >= SYSTIMESTAMP - NUMTODSINTERVAL(PRM.P_DAYS, 'DAY')\n   AND %s\n ORDER BY L.ELAPSED_MS DESC\n FETCH FIRST 30 ROWS ONLY") % (rng, like)
    S['U3'] = ("WITH PRM AS (SELECT 7 AS P_DAYS FROM DUAL)   /* 조회 일수. 이 줄의 값만 바꿔 실행 */\nSELECT L.MNU_BTN_CD\n     , L.SHT_NM\n     , COUNT(*) AS CNT\n"
               "     , ROUND(AVG((CAST(L.TRNM_END_DTM AS DATE) - CAST(L.TRNM_ST_DTM AS DATE)) * 86400), 1) AS AVG_TOTAL_SEC\n"
               "     , ROUND(MAX((CAST(L.TRNM_END_DTM AS DATE) - CAST(L.TRNM_ST_DTM AS DATE)) * 86400), 1) AS MAX_TOTAL_SEC\n"
               "     , ROUND(AVG((CAST(L.DB_TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_ST_DTM AS DATE)) * 86400), 1) AS AVG_DB_SEC\n"
               "     , ROUND(MAX((CAST(L.DB_TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_ST_DTM AS DATE)) * 86400), 1) AS MAX_DB_SEC\n"
               "     , SUM(CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 1 ELSE 0 END) AS ERR_CNT\n     , MAX(L.CREATION_DATE) AS LAST_DATE\n"
               "  FROM SCM_COM_SYS_LOG L\n     , PRM\n WHERE L.MNU_ID = '%s'\n   AND L.CREATION_DATE >= SYSDATE - PRM.P_DAYS\n   AND L.LOG_TP_CD IN ('BUTTON', 'EXCELUPLOAD')\n"
               " GROUP BY L.MNU_BTN_CD\n        , L.SHT_NM\n ORDER BY MAX_TOTAL_SEC DESC NULLS LAST") % sid
    runs = []
    if procs:
        S['U4-0'] = 'ALTER SESSION DISABLE COMMIT IN PROCEDURE'
    for i, p in enumerate(procs, 1):
        k = 'U4-%d' % i
        S[k] = call_block(p); runs.append((k, p))
    if procs:
        # 2026-11-25 14:03 DMF0045 회신 '3번이 계속 수행 중'(재실행 972초) → 재실행이 끝나지 않을 때 새 창에서 돌리는 실행 중 감시(DMF0045_CLOUD_RUNNING_CHECK 최종본)
        own = "SELECT O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = '%s' AND O.OBJECT_NAME IN (%s)" % (OWNER, pkl)
        act = ("SELECT S.SQL_ID, S.SQL_CHILD_NUMBER FROM V$SESSION S, V$SQL Q WHERE S.SQL_ID = Q.SQL_ID AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER AND S.STATUS = 'ACTIVE' AND Q.PROGRAM_ID IN (%s)" % own)
        # 2026-11-25 R226: V$SESSION 전체와 V$SQL 을 OR 조건으로 맞붙이면 사내 18.0초 → 실행 중 사용자 세션을 먼저 좁힌 뒤 V$SQL 을 SQL_ID, CHILD_NUMBER 로 붙임(사내 0.1초)
        S['U4-M1'] = ("WITH OBJ AS (SELECT /*+ MATERIALIZE */ O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = '%s' AND O.OBJECT_NAME IN (%s))\n"
                      ", SES AS (SELECT /*+ MATERIALIZE */ S.SID, S.SERIAL#, S.USERNAME, S.MACHINE, S.STATUS, S.SQL_ID, S.SQL_CHILD_NUMBER, S.SQL_EXEC_START, S.LAST_CALL_ET\n"
                      "                 , S.EVENT, S.WAIT_CLASS, S.BLOCKING_SESSION, S.PLSQL_ENTRY_OBJECT_ID\n"
                      "              FROM V$SESSION S WHERE S.STATUS = 'ACTIVE' AND S.TYPE = 'USER' AND S.SQL_ID IS NOT NULL)\n"
                      "SELECT S.SID\n     , S.SERIAL#\n     , S.USERNAME\n     , S.MACHINE\n     , S.SQL_ID\n     , (SELECT MAX(O.OBJECT_NAME) FROM ALL_OBJECTS O WHERE O.OBJECT_ID = Q.PROGRAM_ID) AS SRC_OBJECT\n"
                      "     , Q.PROGRAM_LINE# AS SRC_LINE\n     , ROUND((SYSDATE - S.SQL_EXEC_START) * 86400) AS STMT_SEC\n     , S.LAST_CALL_ET AS CALL_SEC\n     , S.EVENT\n     , S.WAIT_CLASS\n     , S.BLOCKING_SESSION\n"
                      "     , SUBSTR(Q.SQL_TEXT, 1, 80) AS SQL_TEXT\n  FROM SES S\n  JOIN V$SQL Q\n    ON Q.SQL_ID       = S.SQL_ID\n   AND Q.CHILD_NUMBER = S.SQL_CHILD_NUMBER\n"
                      " WHERE Q.PROGRAM_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)\n    OR S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)\n ORDER BY S.LAST_CALL_ET DESC") % (OWNER, pkl)
        S['U4-M2'] = ("SELECT (SELECT MAX(O.OBJECT_NAME) FROM ALL_OBJECTS O WHERE O.OBJECT_ID = Q.PROGRAM_ID) AS SRC_OBJECT\n     , Q.PROGRAM_LINE# AS SRC_LINE\n     , Q.SQL_ID\n     , Q.EXECUTIONS\n     , Q.USERS_EXECUTING\n"
                      "     , ROUND(Q.ELAPSED_TIME / 1000000, 2) AS ELAPSED_SEC\n     , Q.BUFFER_GETS\n     , Q.ROWS_PROCESSED\n     , TO_CHAR(Q.LAST_ACTIVE_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_ACTIVE\n"
                      "     , SUBSTR(Q.SQL_TEXT, 1, 60) AS SQL_TEXT\n  FROM V$SQL Q\n WHERE Q.PROGRAM_ID IN (%s)\n   AND Q.LAST_ACTIVE_TIME >= SYSDATE - 1 / 24\n ORDER BY Q.LAST_ACTIVE_TIME") % own
        S['U4-M3'] = ("SELECT T.PLAN_TABLE_OUTPUT\n  FROM (SELECT DISTINCT A.SQL_ID, A.SQL_CHILD_NUMBER FROM (%s) A) X\n     , TABLE(DBMS_XPLAN.DISPLAY_CURSOR(X.SQL_ID, X.SQL_CHILD_NUMBER, 'TYPICAL')) T") % act
        S['U4-M4'] = ("SELECT L.SID\n     , L.SQL_ID\n     , L.OPNAME\n     , L.TARGET\n     , L.SOFAR\n     , L.TOTALWORK\n     , ROUND(L.SOFAR / NULLIF(L.TOTALWORK, 0) * 100, 1) AS PCT\n"
                      "     , L.ELAPSED_SECONDS\n     , L.TIME_REMAINING\n  FROM V$SESSION_LONGOPS L\n WHERE L.SOFAR < L.TOTALWORK\n   AND L.SID IN (SELECT S.SID FROM V$SESSION S, V$SQL Q WHERE S.SQL_ID = Q.SQL_ID\n"
                      "                    AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER AND S.STATUS = 'ACTIVE' AND Q.PROGRAM_ID IN (%s))\n ORDER BY L.ELAPSED_SECONDS DESC") % own
    gts = [n for n, tmp in tabs if tmp == 'Y']
    if gts:
        S['U5'] = '\nUNION ALL\n'.join("SELECT '%s' AS GT_NAME, COUNT(*) AS CNT FROM %s" % (n, n) for n in gts)
    obj_pb = ("SELECT O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = '%s' AND O.OBJECT_NAME IN (%s) AND O.OBJECT_TYPE = 'PACKAGE BODY'" % (OWNER, pkl))
    # 2026-11-26 R226(개선안 20261125150348_SELF): U6, U7 은 V$SQL 을 최근 P_DAYS 일 안에 실행된 문장으로 좁혀 읽음
    S['U6'] = ("WITH PRM AS (SELECT 1 AS P_DAYS FROM DUAL)   /* 이 일수 안에 실행된 문장. 이 줄의 값만 바꿔 실행 */\nSELECT (SELECT O.OBJECT_NAME FROM ALL_OBJECTS O WHERE O.OBJECT_ID = S.PROGRAM_ID) AS SRC_OBJECT\n     , S.PROGRAM_LINE# AS SRC_LINE\n     , S.SQL_ID\n     , S.CHILD_NUMBER\n     , S.EXECUTIONS\n"
               "     , ROUND(S.ELAPSED_TIME / 1000000, 2) AS ELAPSED_SEC\n     , ROUND(S.ELAPSED_TIME / NULLIF(S.EXECUTIONS, 0) / 1000000, 2) AS SEC_PER_EXEC\n     , ROUND(S.CPU_TIME / 1000000, 2) AS CPU_SEC\n"
               "     , S.BUFFER_GETS\n     , S.DISK_READS\n     , S.ROWS_PROCESSED\n     , S.PLAN_HASH_VALUE\n     , S.LAST_ACTIVE_TIME\n     , SUBSTR(S.SQL_TEXT, 1, 100) AS SQL_TEXT\n"
               "  FROM V$SQL S\n     , PRM\n WHERE S.LAST_ACTIVE_TIME >= SYSDATE - PRM.P_DAYS\n   AND S.PROGRAM_ID IN (%s)\n ORDER BY S.ELAPSED_TIME DESC\n FETCH FIRST 20 ROWS ONLY") % obj_pb
    S['U7'] = ("WITH PRM AS (SELECT 1 AS P_DAYS FROM DUAL)   /* 이 일수 안에 실행된 문장. 이 줄의 값만 바꿔 실행 */\nSELECT T.PLAN_TABLE_OUTPUT\n  FROM (SELECT S.SQL_ID\n             , S.CHILD_NUMBER\n          FROM V$SQL S\n             , PRM\n         WHERE S.LAST_ACTIVE_TIME >= SYSDATE - PRM.P_DAYS\n           AND S.PROGRAM_ID IN (%s)\n         ORDER BY S.ELAPSED_TIME DESC\n"
               "         FETCH FIRST 5 ROWS ONLY) X\n     , TABLE(DBMS_XPLAN.DISPLAY_CURSOR(X.SQL_ID, X.CHILD_NUMBER, 'TYPICAL')) T") % obj_pb
    perm = [n for n, tmp in tabs if tmp != 'Y']
    if perm:
        S['U8'] = ("SELECT T.TABLE_NAME\n     , T.NUM_ROWS\n     , T.BLOCKS\n     , T.LAST_ANALYZED\n     , T.STALE_STATS\n  FROM ALL_TAB_STATISTICS T\n WHERE T.OWNER = '%s'\n"
                   "   AND T.OBJECT_TYPE = 'TABLE'\n   AND T.TABLE_NAME IN (%s)\n ORDER BY T.NUM_ROWS DESC NULLS LAST") % (OWNER, inlist(perm))
        S['U8-1'] = ("SELECT C.TABLE_NAME\n     , C.INDEX_NAME\n     , LISTAGG(C.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) AS COLUMNS\n     , MAX(I.STATUS) AS STATUS\n"
                     "  FROM ALL_IND_COLUMNS C\n  JOIN ALL_INDEXES I\n    ON I.OWNER      = C.INDEX_OWNER\n   AND I.INDEX_NAME = C.INDEX_NAME\n WHERE C.TABLE_OWNER = '%s'\n   AND C.TABLE_NAME IN (%s)\n"
                     "   AND C.TABLE_NAME IN (SELECT S.TABLE_NAME FROM ALL_TAB_STATISTICS S WHERE S.OWNER = '%s' AND S.NUM_ROWS >= 100000)\n GROUP BY C.TABLE_NAME\n        , C.INDEX_NAME\n ORDER BY C.TABLE_NAME\n        , C.INDEX_NAME") % (OWNER, inlist(perm), OWNER)
    S['U9'] = 'ROLLBACK'
    if procs:
        S['U9-1'] = 'ALTER SESSION ENABLE COMMIT IN PROCEDURE'
    base = 'UI_속도점검_%s_%s' % (sid, datetime.datetime.now().strftime('%Y%m%d_%H%M'))
    head = [LINE, '-- %s UI 속도 점검 쿼리 · Oracle(클라우드)' % sid,
            '-- 실행 : DBeaver 에서 쿼리 하나씩(Ctrl+Enter). [U4-*] 블록은 출력 창(DBMS_OUTPUT)을 켜고 실행. 마지막 [U9] ROLLBACK',
            '-- 원문 기준 : 사내 ZIOUI1 %s 조회' % at,
            '-- 순서 : [U0-0] 현재 스키마 고정 → [U0-1] 원문 판 대조(SAME_AS_CORP = N 이면 줄 번호는 클라우드 원문 기준으로 다시 봄) → [U0] ~ [U9-1]']
    for n, v in pk.items():
        head.append('--   %s : %s' % (n, ' · '.join('%s %s %s' % x for x in v)))
    head += ['-- 화면 호출 로그 = SCM_COM_SQL_LOG(SQL_ID = com.lgcns.nscm.callProc, SQL_TEXT = 호출 원문, ELAPSED_MS). 인덱스가 LOG_SEQ 뿐이라 최근 P_LOG_ROWS 행으로 범위를 먼저 좁힘',
             '--   [U0] FROM_TIME 이 조회 일수보다 늦으면 P_LOG_ROWS 를 늘림',
             '-- 버튼 로그 = SCM_COM_SYS_LOG(MNU_ID = 화면 ID). TOTAL = 서버 요청 처리 전체, DB = DB 호출 구간. 차이가 크면 DB 밖(서버, 전송) 시간',
             '-- [U4-*] 조회 1회 재실행 = ZIOUI1 최근 호출 로그 값(LOG_SEQ 범위 %d ~ %d). 느린 조건으로 바꾸려면 [U2] SQL_TEXT 값을 같은 순서로 넣음' % (mx - log_rows, mx),
             '-- [U5] 는 [U4-*] 직후 같은 세션에서 실행(임시 테이블 건수). [U6] [U7] 은 V$ 조회 권한 필요(ORA-00942 = DBA 에 SELECT_CATALOG_ROLE 요청)']
    head.append('-- [U4-0] 은 저장 프로시저 안 COMMIT 을 막는 세션 설정(COMMIT 을 만나면 ORA-00034). [U9-1] 에서 되돌림')
    head.append('-- [U4-*] 는 DBeaver 수동 커밋 모드(Manual Commit)에서 실행. 자동 커밋이면 블록이 끝날 때 DBeaver 가 COMMIT 함')
    if procs:
        head.append('-- [U4-*] 가 1분 넘게 끝나지 않으면 그 창은 두고 새 접속 창에서 [U0-0] 실행 뒤 [U4-M1] ~ [U4-M4] 를 1~2분 간격으로 2~3회 실행해 회신(2026-11-25 클라우드 재실행 972초 사례)')
    for full, why in skipped:
        head.append('-- 재실행 제외 : %s (%s)' % (full, why))
    if not procs:
        head.append('-- 조회 프로시저 없음(OUT REF CURSOR 가 있는 GET, SEARCH, SELECT 프로시저를 찾지 못함). [U4] 생략')
    head += [LINE, '', '']
    parts = [block('U0-0', '현재 스키마 고정(파일 첫 쿼리)', SCHEMA_NOTES, S['U0-0']),
             block('U0-1', '클라우드 원문 판 대조(사내 ZIOUI1 원문과 같은지)', VERSION_NOTES, S['U0-1']),
             block('U0', '로그 범위 확인', ['확인 : FROM_TIME ~ TO_TIME 이 점검할 기간을 덮는지'], S['U0']),
             block('U1', '조회 프로시저별 소요(최근 조회 일수)', ['확인 : MAX_MS, P90_MS 가 큰 프로시저'], S['U1']),
             block('U2', '느린 호출 30건', ['확인 : 느린 호출의 조건값(SQL_TEXT), 사용자, 결과 행 수'], S['U2']),
             block('U3', '버튼별 처리 시간(SCM_COM_SYS_LOG)', ['확인 : TOTAL 과 DB 차이'], S['U3'])]
    if 'U4-0' in S:
        parts.append(block('U4-0', '저장 프로시저 COMMIT 막기(재실행 전 필수)', ['확인 : 오류 없이 끝남. 같은 탭에서 [U4-*] 실행'], S['U4-0']))
    for k, p in runs:
        smp = p['sample']
        note = ['ZIOUI1 로그 LOG_SEQ %s, %s ms 호출 값' % (smp['seq'], smp['ms']) if smp else 'ZIOUI1 로그 표본 없음. 조건값 확인 필요']
        if p['writes']:
            note.append('테이블 쓰기 있음(%s, COMMIT 없음). DBeaver 수동 커밋 모드에서 실행하고 [U9] ROLLBACK' % ', '.join(p['writes'][:4]))
        parts.append(block(k, '조회 1회 재실행 %s' % p['full'], ['확인 : PROC_SEC = 프로시저 시간, FETCH_SEC = 결과 읽기 시간, 커서별 행 수'] + note, S[k], plsql=True))
    if 'U4-M1' in S:
        mn = ['[U4-*] 가 끝나지 않을 때만. 재실행 창은 두고 새 접속 창에서 [U0-0] 실행 뒤 실행. 조회만 함']
        parts += [block('U4-M1', '실행 중 감시 : 지금 도는 세션, 문장 줄 번호(V$ 권한 필요)', mn + ['확인 : SRC_LINE 이 회차마다 바뀌는지, STMT_SEC, EVENT, BLOCKING_SESSION',
                                                                                     '멈추기 : ALTER SYSTEM CANCEL SQL \'<SID>, <SERIAL#>\'; (DBA 권한, 문장만 취소. 취소된 창에서 [U9] ROLLBACK)'], S['U4-M1']),
                  block('U4-M2', '실행 중 감시 : 최근 60분 문장 진행 이력', mn + ['확인 : LAST_ACTIVE 순. 마지막 줄이 지금 단계'], S['U4-M2']),
                  block('U4-M3', '실행 중 감시 : 지금 도는 문장 실행계획', mn, S['U4-M3']),
                  block('U4-M4', '실행 중 감시 : 오래 걸리는 읽기 진행률', mn + ['확인 : PCT, TIME_REMAINING'], S['U4-M4'])]
    if 'U5' in S:
        parts.append(block('U5', '임시 테이블 건수([U4-*] 직후 같은 세션)', ['확인 : 단계별 중간 결과 건수. 큰 단계가 느린 단계 후보'], S['U5']))
    parts += [block('U6', '패키지 안 문장별 누적 소요(V$ 권한 필요)', ['확인 : SRC_LINE = 패키지 본문 줄 번호. SEC_PER_EXEC 가 큰 문장'], S['U6']),
              block('U7', '소요 상위 5문장 실행계획(V$ 권한 필요)', ['확인 : FULL 읽기, 예상 행 수와 실제 차이'], S['U7'])]
    if 'U8' in S:
        parts += [block('U8', '참조 테이블 통계', ['확인 : STALE_STATS = YES, LAST_ANALYZED 오래된 테이블'], S['U8']),
                  block('U8-1', '10만 행 이상 참조 테이블 인덱스', [], S['U8-1'])]
    parts.append(block('U9', '되돌림', ['[U4-*] 에서 사용자 설정 기본행, 임시 테이블 행이 들어갔을 때 되돌림'], S['U9']))
    if 'U9-1' in S:
        parts.append(block('U9-1', 'COMMIT 막기 해제', [], S['U9-1']))
    stmts = [dict(key=k, sql=v, plsql=k.startswith('U4-') and not k.startswith('U4-M') and k != 'U4-0') for k, v in S.items()]
    write_out(out_dir('perfui', sid), base, '\n'.join(head), parts, stmts, dict(kind='ui', unit=sid, packages=list(pk), procs=[p['full'] for p in procs], skipped=skipped, gts=gts, tables=perm, versions=vers))
    print('패키지 :', ', '.join(pk), '· 재실행 프로시저 :', ', '.join(p['full'] for p in procs) or '없음', '· 참조 테이블', len(perm), '· 임시 테이블', len(gts))
    return 0


# ======================================================================== 검증
def verify(unit, kind):
    chain = 'perfbatch' if kind == 'batch' else 'perfui'
    unit = unit.strip().upper()
    d = out_dir(chain, unit)
    meta = json.load(io.open(os.path.join(d, '_statements.json'), encoding='utf-8'))
    t, c = connect()
    log, fail, slow, plans = [], [], [], []
    def P(*a):
        s = ' '.join(str(x) for x in a); print(s, flush=True); log.append(s)
    c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM DUAL"); P('ZIOUI1', c.fetchone())
    c.callproc('DBMS_OUTPUT.ENABLE', [None])
    try:
        for st in meta['statements']:
            t0 = datetime.datetime.now()
            try:
                if st['plsql']:
                    c.execute(st['sql'])
                    out = []; lv = c.var(str); sv = c.var(int)
                    while True:
                        c.callproc('DBMS_OUTPUT.GET_LINE', (lv, sv))
                        if sv.getvalue() != 0: break
                        out.append(lv.getvalue())
                    P('[%s] %.1f초 · %s' % (st['key'], (datetime.datetime.now() - t0).total_seconds(), ' | '.join(out)[:300]))
                    if any('열리지 않음' in o for o in out): fail.append('[%s] 커서 열리지 않음 %s' % (st['key'], ' | '.join(out)[:200]))
                elif st['sql'].strip().upper().startswith('ALTER SESSION'):
                    c.execute(st['sql']); P('[%s] %s' % (st['key'], st['sql']))
                elif st['sql'].strip().upper() == 'ROLLBACK':
                    t.rollback(); P('[%s] ROLLBACK' % st['key'])
                else:
                    c.execute(st['sql']); rows = c.fetchall()
                    P('[%s] %.1f초 · %d행%s' % (st['key'], (datetime.datetime.now() - t0).total_seconds(), len(rows), (' · 첫 행 ' + str(rows[0])[:200]) if rows else ''))
                sec = (datetime.datetime.now() - t0).total_seconds()
                if sec > SLOW_SEC and not st['sql'].strip().upper().startswith(('ALTER SESSION', 'ROLLBACK')):
                    slow.append('[%s] %.1f초 > %d초' % (st['key'], sec, SLOW_SEC))
                    P('[SLOW] [%s] %.1f초 > %d초. 범위를 줄인 뒤 제공' % (st['key'], sec, SLOW_SEC))
                    if not st['plsql']:
                        plans.append('===== [%s] %.1f초 실행계획(EXPLAIN PLAN FOR + DBMS_XPLAN.DISPLAY)' % (st['key'], sec))
                        try:
                            sid_ = ('PERF_' + re.sub(r'[^A-Z0-9_]', '_', st['key'].upper()))[:30]
                            c.execute("EXPLAIN PLAN SET STATEMENT_ID = '%s' FOR %s" % (sid_, st['sql']))
                            c.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY(NULL, :stid, 'TYPICAL'))", stid=sid_)
                            plans += [r[0] for r in c.fetchall()]
                        except Exception as e2:
                            plans.append('실행계획 조회 오류 · ' + str(e2).split('\n')[0][:200])
                    else:
                        plans.append('===== [%s] %.1f초 PL/SQL 블록. 실행계획은 [U4-M3] 또는 [U7] 로 확인' % (st['key'], sec))
            except Exception as e:
                msg = str(e).split('\n')[0][:200]
                P('[%s] 오류 %.1f초 · %s' % (st['key'], (datetime.datetime.now() - t0).total_seconds(), msg))
                fail.append('[%s] %s' % (st['key'], msg))
    finally:
        t.rollback(); t.close()
    # 2026-11-26 R226(개선안 20261125150348_SELF_2): 5초 넘는 블록은 PASS 로 두지 않음. 결과 = SLOW, 느린 블록 건수와 실행계획을 _검증.txt 에 남김
    res = 'FAIL' if fail else ('SLOW' if slow else 'PASS')
    f = os.path.join(d, meta['base'] + '_검증.txt')
    io.open(f, 'w', encoding='utf-8').write('\n'.join(['속도 점검 쿼리 로컬 검증 ' + now(), '방식 : 파일의 쿼리를 사내 ZIOUI1 에서 차례로 실행(조회. 재실행 블록 뒤 ROLLBACK). %d초 넘는 블록 = [SLOW] + 실행계획' % SLOW_SEC] + log
                                                       + ['[FAIL] ' + x for x in fail] + ['[SLOW] ' + x for x in slow] + plans
                                                       + ['결과 : %s · 실패 %d건 · 느린 블록(%d초 초과) %d건' % (res, len(fail), SLOW_SEC, len(slow))]) + '\n')
    print('[OUT]', os.path.relpath(f, ROOT).replace(os.sep, '/'))
    print('결과 :', res, '· 느린 블록 %d건' % len(slow))
    return 0 if not fail else 1


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    a = sys.argv[1:]
    try:
        if len(a) >= 3 and a[0] == 'batch' and a[1] == '--module':
            sys.exit(gen_batch(a[2]))
        if len(a) >= 3 and a[0] == 'ui' and a[1] == '--module':
            sys.exit(gen_ui(a[2]))
        if len(a) >= 5 and a[0] == 'verify' and a[1] == '--module' and a[3] == '--kind' and a[4] in ('batch', 'ui'):
            sys.exit(verify(a[2], a[4]))
        print(__doc__); sys.exit(2)
    except InputError as e:
        print('[FAIL] 입력 오류 :', e); sys.exit(3)
