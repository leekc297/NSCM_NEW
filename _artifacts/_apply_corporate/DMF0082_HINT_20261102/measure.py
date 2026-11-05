"""[E20261102-DMF0082HINT] P_DMF0082_GET_MAIN_DATA 전후 측정 — python measure.py <label> [runs]
  HTTP = 화면 경로 FcstNPrice call-proc(파라미터 = _diagnostics/_0082_measure.py 근거, 세션 유지) · 결과 지문(행 정렬 md5)
  SP   = 같은 세션 반복 직접 호출(프로시저 실행 / 커서 fetch 분리)
  기간 = 당월 1일 ~ +6개월-1일 (FE 기본 PR_GET_DAY_RANGE month=6 규약)"""
import sys, os, time, json, hashlib, statistics, datetime
import requests
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb
HERE = os.path.dirname(os.path.abspath(__file__))
label = sys.argv[1]; RUNS = int(sys.argv[2]) if len(sys.argv) > 2 else 5
USER = "minyonglee1"; BASE = "http://localhost:8080"; FRM, TO = "20261101", "20270430"; E = ""
out = {'label': label, 'start': datetime.datetime.now().isoformat(timespec='seconds'), 'http': {}, 'sp': {}}
cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()
def active():
    c.execute("SELECT COUNT(*) FROM V$SESSION WHERE STATUS='ACTIVE' AND TYPE='USER'"); return c.fetchone()[0]
c.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'),STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'"); out['body'] = c.fetchone(); print(label, 'BODY', out['body'], flush=True)
s = requests.Session(); r = s.post(f"{BASE}/user/login", json={"userId": USER}, timeout=60); print('login', r.status_code, flush=True)
def digest(rows):
    return hashlib.md5(''.join(sorted(hashlib.md5(json.dumps(x, sort_keys=True, ensure_ascii=False, default=str).encode()).hexdigest() for x in rows)).encode()).hexdigest()
for div in ('40', '81', '82'):
    body = {"divisionId": div, "deptId": E, "endCustomer": E, "bizType": E, "fromYyyymmdd": FRM, "toYyyymmdd": TO, "salesSite": E, "itemId": E, "versionType": "Current", "qtyYn": "N", "userGroup": USER, "plantSiteId": E, "projectCode": E, "owner": E, "senderCode": E}
    res = []
    for i in range(RUNS):
        a0 = active(); t0 = time.time(); rr = s.post(f"{BASE}/DMF0082/FcstNPrice/SEARCH/call-proc", json=body, timeout=1800); el = time.time() - t0
        j = rr.json(); result = j.get('result') or {}
        lists = {k: v for k, v in result.items() if isinstance(v, list)}
        sz = {k: len(v) for k, v in lists.items()}; dg = {k: digest(v) for k, v in lists.items()}
        pr = result.get('PROC_RESULT') or result.get('proc_result')
        if i == 0: json.dump(lists.get('fcstNPrice'), open(os.path.join(HERE, f'_rows_{label}_{div}.json'), 'w', encoding='utf-8'), ensure_ascii=False)
        res.append({'sec': round(el, 2), 'http': rr.status_code, 'code': j.get('code'), 'sizes': sz, 'digest': dg, 'active': a0})
        print(f"HTTP div{div} #{i+1} {el:7.2f}s http={rr.status_code} code={j.get('code')} {sz} active={a0}", flush=True)
    out['http'][div] = res; json.dump(out, open(os.path.join(HERE, f'_measure_{label}.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
# SP 직접 (같은 세션 재사용)
c.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
for div in ('40', '81', '82'):
    res = []
    for i in range(3):
        args = [div, E, E, E, FRM, TO, E, E, "Current", "N", USER, USER, E, E, E, E]
        outs = [c.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
        t0 = time.time(); c.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", args + outs); t1 = time.time()
        k = outs[0].getvalue(); rows = k.fetchall(); t2 = time.time(); cols = [d[0] for d in k.description]
        dg = hashlib.md5(''.join(sorted(hashlib.md5(repr(x).encode()).hexdigest() for x in rows)).encode()).hexdigest()
        res.append({'proc': round(t1 - t0, 2), 'fetch': round(t2 - t1, 2), 'rows': len(rows), 'cols': len(cols), 'digest': dg})
        print(f"SP   div{div} #{i+1} proc {t1-t0:7.2f}s fetch {t2-t1:6.2f}s rows={len(rows)} cols={len(cols)}", flush=True)
        cx.rollback()
    out['sp'][div] = res; json.dump(out, open(os.path.join(HERE, f'_measure_{label}.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
out['end'] = datetime.datetime.now().isoformat(timespec='seconds')
json.dump(out, open(os.path.join(HERE, f'_measure_{label}.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('END', out['end'])
