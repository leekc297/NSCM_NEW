# -*- coding: utf-8 -*-
"""앱 계정(SCMP_APP) 시노님 누락 자동 보완 + 이력 (2026-10-29 사용자 지시: "시노님이 없어서 실행이 안되는 경우에는 시노님 추가하고, 시노님 없어서 오류발생한 이력 남겨주세요")

사용: python tools/Harness/verify/syn_fix.py <MENU_ID> [--dry]   (run_verify 가 syn_check 뒤에 자동 호출)

하는 일
  1 Doc/verify/<ID>/syn_check.csv 의 비OK 행 + BE 로그(nscm-be/logs/nscm.log)의 ORA-00942 "SCMP_APP"."X" 발생 객체를 모은다
  2 SYN_MISSING: SCM_MGR 의 같은 이름 시노님(또는 객체)이 가리키는 <owner>.<obj> 로 CREATE OR REPLACE SYNONYM SCMP_APP.X — 접속 계정 SCM_MGR(CREATE ANY SYNONYM 보유)
     SELECT 권한이 없으면: SCM_MGR 이 GRANT OPTION 을 가진 객체는 GRANT SELECT … TO SCMP_APP, 아니면 PRIV_MISSING 으로 남기고 DBA 용 GRANT 문을 기록
  3 적용 뒤 syn_check 를 다시 돌려 verdict 가 OK 인지 확인(해소 못 하면 차단 유지)
  4 이력: Doc/verify/_synonym_history.csv (전 화면 공용, 추가 기록) · Doc/verify/<ID>/applied/<ts>_synonym.sql (실행 SQL 그대로) · Doc/cloud_sql/synonym_<ts>_<ID>.sql (클라우드 이관용 멱등 SQL)
"""
import argparse, csv, datetime, json, os, re, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
APP = 'SCMP_APP'
OWNER = 'SCM_MGR'
HIST = os.path.join(ROOT, 'Doc', 'verify', '_synonym_history.csv')
HIST_COLS = ['ts', 'menu_id', 'object', 'source', 'verdict_before', 'target', 'action', 'sql', 'result', 'verdict_after', 'error_evidence', 'by']


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig') as f: return list(csv.DictReader(f))


def be_log_evidence(objs):
    """BE 로그에서 객체별 ORA-00942 발생 횟수·첫/마지막 시각 — 이력의 '오류 발생' 증거"""
    out = {o: {'count': 0, 'first': '', 'last': ''} for o in objs}
    p = os.path.join(ROOT, 'nscm-be', 'logs', 'nscm.log')
    if not os.path.exists(p): return out
    rx = re.compile(r'^(\d{2}:\d{2}:\d{2}).*ORA-00942.*"' + APP + r'"\."([A-Z0-9_$#]+)"')
    day = datetime.datetime.fromtimestamp(os.path.getmtime(p)).strftime('%Y-%m-%d')
    with open(p, encoding='utf-8', errors='ignore') as f:
        for line in f:
            m = rx.match(line)
            if not m or m.group(2) not in out: continue
            e = out[m.group(2)]; e['count'] += 1; e['first'] = e['first'] or f'{day} {m.group(1)}'; e['last'] = f'{day} {m.group(1)}'
    return out


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu_id'); ap.add_argument('--dry', action='store_true'); a = ap.parse_args()
    mid = a.menu_id.upper(); ts = datetime.datetime.now(); tsn = ts.strftime('%Y%m%d_%H%M%S')
    syn_p = os.path.join(ROOT, 'Doc', 'verify', mid, 'syn_check.csv')
    rows = [x for x in rd(syn_p) if x.get('kind') != 'NOTE']
    bad = {x['name']: x for x in rows if (x.get('verdict') or 'OK') != 'OK'}
    # BE 로그에서 이 화면 실행 중 난 ORA-00942 객체도 후보(정적 검사가 못 잡은 콤보)
    ev = be_log_evidence(set(bad) | set())
    p = os.path.join(ROOT, 'nscm-be', 'logs', 'nscm.log')
    if os.path.exists(p):
        with open(p, encoding='utf-8', errors='ignore') as f:
            for o in set(re.findall(r'ORA-00942[^\n]{0,200}?"' + APP + r'"\."([A-Z0-9_$#]+)"', f.read())):
                if o not in bad: bad[o] = {'menu_id': mid, 'kind': 'BELOG', 'source': 'nscm.log ORA-00942', 'name': o, 'verdict': 'SYN_MISSING', 'path': ''}
    if not bad:
        print(f'{mid}: 시노님 누락 없음'); return 0
    ev = be_log_evidence(set(bad))
    from dbconn import connect
    hist, applied_sql, cloud_sql = [], [], []
    with connect('tobe', write=True) as cx:
        c = cx.cursor()
        q = lambda sql, **kw: (c.execute(sql, kw), c.fetchall())[1]
        me = q("SELECT USER FROM DUAL")[0][0]
        roles = {r[0] for r in q("SELECT GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTEE=:g", g=APP)} | {APP, 'PUBLIC'}
        for name, x in sorted(bad.items()):
            before = x.get('verdict') or 'SYN_MISSING'
            # 대상: SCMP_APP 시노님이 이미 있나 → 없으면 SCM_MGR 시노님/객체 → PUBLIC
            tgt = None
            for own in (APP, OWNER, 'PUBLIC'):
                r = q("SELECT TABLE_OWNER, TABLE_NAME FROM DBA_SYNONYMS WHERE OWNER=:o AND SYNONYM_NAME=:n", o=own, n=name)
                if r: tgt = (r[0][0], r[0][1]); break
            if not tgt and q("SELECT 1 FROM DBA_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE IN ('TABLE','VIEW','SEQUENCE','PACKAGE','FUNCTION','PROCEDURE')", o=OWNER, n=name):
                tgt = (OWNER, name)
            evid = ev.get(name, {}); evtxt = f"BE 로그 ORA-00942 {evid.get('count', 0)}회({evid.get('first', '')}~{evid.get('last', '')})" if evid.get('count') else '정적 시노님검사(syn_check) 검출'
            h = {'ts': ts.strftime('%Y-%m-%d %H:%M:%S'), 'menu_id': mid, 'object': name, 'source': x.get('source', ''), 'verdict_before': before, 'target': f'{tgt[0]}.{tgt[1]}' if tgt else '', 'action': '', 'sql': '', 'result': '', 'verdict_after': '', 'error_evidence': evtxt, 'by': me}
            if not tgt:
                h.update(action='SKIP', result='대상 객체를 SCM_MGR·PUBLIC 시노님/객체에서 찾지 못함 — 수동 확인'); hist.append(h); print(f"  [SKIP] {name}: 대상 미확인"); continue
            own, obj = tgt
            sqls = []
            has_app_syn = bool(q("SELECT 1 FROM DBA_SYNONYMS WHERE OWNER=:o AND SYNONYM_NAME=:n AND TABLE_OWNER=:t AND TABLE_NAME=:m", o=APP, n=name, t=own, m=obj))
            if not has_app_syn:
                sqls.append(f"CREATE OR REPLACE SYNONYM {APP}.{name} FOR {own}.{obj}")
            # 권한: 객체 소유자가 SCMP_APP 이면 불필요 · 아니면 DBA_TAB_PRIVS 에 SELECT(또는 EXECUTE) 가 SCMP_APP/PUBLIC/롤에 있어야
            otype = (q("SELECT OBJECT_TYPE FROM DBA_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE NOT IN ('PACKAGE BODY','SYNONYM')", o=own, n=obj) or [('TABLE',)])[0][0]
            priv = 'EXECUTE' if otype in ('PACKAGE', 'PROCEDURE', 'FUNCTION', 'TYPE') else 'SELECT'
            privs = q("SELECT GRANTEE, PRIVILEGE, GRANTABLE FROM DBA_TAB_PRIVS WHERE OWNER=:o AND TABLE_NAME=:n", o=own, n=obj)
            has_priv = own == APP or any(g in roles and pv in (priv, 'READ') for g, pv, _ in privs)
            grant_sql = f"GRANT {priv} ON {own}.{obj} TO {APP}"
            can_grant = own == me or any(g == me and pv == priv and gr == 'YES' for g, pv, gr in privs)
            if not can_grant and q("SELECT 1 FROM SESSION_PRIVS WHERE PRIVILEGE='GRANT ANY OBJECT PRIVILEGE'"): can_grant = True  # system 계정(2026-10-29 사용자: 접속 계정을 system 으로) — 어떤 객체든 부여 가능
            if not has_priv:
                if can_grant: sqls.append(grant_sql)
                else: h['result'] = f"권한 없음 — {me} 는 {own}.{obj} 에 GRANT OPTION 이 없어 부여 불가 · DBA 실행 필요: {grant_sql} (또는 TO RL_FP_SEL)"
            h['sql'] = '; '.join(sqls); h['action'] = 'APPLY' if sqls else 'NOOP'
            if a.dry:
                h['result'] = (h['result'] + ' · ' if h['result'] else '') + 'DRY-RUN(미실행)'
            else:
                try:
                    for s in sqls:
                        c.execute(s); applied_sql.append(s + ';')
                    cx.commit()
                    h['result'] = (h['result'] + ' · ' if h['result'] else '') + (f"적용 {len(sqls)}문" if sqls else '변경 없음')
                except Exception as ex:
                    h['result'] = f'실패 {str(ex)[:160]}'
            cloud_sql.append(f"-- {name} ({x.get('source','')}) — {h['error_evidence']}\nBEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM {APP}.{name} FOR {own}.{obj}'; EXCEPTION WHEN OTHERS THEN IF SQLCODE NOT IN (-955) THEN RAISE; END IF; END;\n/\n-- 권한(소유자/DBA 계정에서): {grant_sql};")
            hist.append(h)
    # 재검사
    try:
        subprocess.run([sys.executable, os.path.join(HERE, 'syn_check.py'), mid], check=False, capture_output=True)
        after = {x['name']: (x.get('verdict') or 'OK') for x in rd(syn_p) if x.get('kind') != 'NOTE'}
        for h in hist:
            h['verdict_after'] = after.get(h['object'], '검사 대상 아님(BE 로그 검출)')
            if 'GRANT OPTION 이 없어 부여 불가' in (h.get('result') or '') and h['verdict_after'] in ('OK', '검사 대상 아님(BE 로그 검출)'):
                h['verdict_after'] = 'PRIV_MISSING(DBA GRANT 필요)'  # 시노님은 만들었지만 SELECT 권한이 없어 여전히 ORA-00942/01031
    except Exception as ex:
        for h in hist: h['verdict_after'] = f'재검사 실패 {str(ex)[:80]}'
    # 이력 쓰기
    new = not os.path.exists(HIST)
    with open(HIST, 'a', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=HIST_COLS); (w.writeheader() if new else None); w.writerows(hist)
    ad = os.path.join(ROOT, 'Doc', 'verify', mid, 'applied'); os.makedirs(ad, exist_ok=True)
    if applied_sql or a.dry:
        with open(os.path.join(ad, f'{tsn}_synonym.sql'), 'w', encoding='utf-8') as f:
            f.write(f"-- {mid} 앱 계정 시노님 보완 — 사내오라클(ZIOUI1) {me} 로 {ts:%Y-%m-%d %H:%M:%S} {'DRY-RUN' if a.dry else '실행'}\n-- 근거: Doc/verify/_synonym_history.csv (같은 ts)\n" + '\n'.join(applied_sql if applied_sql else [f'-- {h["sql"]}' for h in hist]) + '\n')
    cd = os.path.join(ROOT, 'Doc', 'cloud_sql'); os.makedirs(cd, exist_ok=True)
    with open(os.path.join(cd, f'synonym_{tsn}_{mid}.sql'), 'w', encoding='utf-8') as f:
        f.write(f"-- 클라우드 이관용: {mid} 앱 계정({APP}) 시노님 — 멱등(이미 있으면 교체) · 사내 적용 {ts:%Y-%m-%d %H:%M} · 전체 F5 실행 가능\n" + '\n'.join(cloud_sql) + '\n')
    for h in hist:
        print(f"  [{h['action']}] {h['object']} → {h['target'] or '-'} | {h['result']} | 재검사 {h['verdict_after']} | {h['error_evidence']}")
    unresolved = [h for h in hist if h['verdict_after'] not in ('OK', '검사 대상 아님(BE 로그 검출)')]
    print(f"{mid}: 시노님 보완 {len(hist)}건 · 해소 {len(hist) - len(unresolved)} · 미해소 {len(unresolved)} → 이력 {HIST}")
    return 2 if unresolved else 0


if __name__ == '__main__':
    sys.exit(main())
