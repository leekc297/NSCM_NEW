# -*- coding: utf-8 -*-
"""
dbconn — NSCM DB 접속정보 레지스트리 (비밀번호는 절대 출력/저장하지 않는다)

  설정  : dbconn.json  (접속 '이름' → .env 키 접두어).  실제 값은 envFile(.env.asis) 의 <PREFIX>_<KEY>
  사용  : from dbconn import connect, describe
          with connect('tobe') as cx: ...
  드라이버: oracle → python-oracledb(thin, Oracle Client 불필요)   mssql → pyodbc(ODBC Driver 17) 또는 pymssql
  설치  : pip install oracledb pyodbc      (pymssql 은 pyodbc 가 없을 때만)
"""
import sys as _sys
try: _sys.stdout.reconfigure(encoding='utf-8', errors='replace'); _sys.stderr.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
CFG_PATH = os.environ.get('DBCONN_JSON', os.path.join(HERE, 'dbconn.json'))


def load_cfg(path=CFG_PATH):
    with open(path, encoding='utf-8-sig') as f:
        return json.load(f)


def load_env(env_file):
    """KEY=VALUE 파일 파싱. 주석(#)·빈 줄 무시. 따옴표 제거. 이미 설정된 OS 환경변수가 우선."""
    env = {}
    if not os.path.exists(env_file):
        return env
    with open(env_file, encoding='utf-8-sig') as f:
        for line in f:
            s = line.strip()
            if not s or s.startswith('#') or '=' not in s:
                continue
            k, v = s.split('=', 1)
            k, v = k.strip(), v.strip()
            if len(v) >= 2 and v[0] == v[-1] and v[0] in '"\'':
                v = v[1:-1]
            env[k] = os.environ.get(k, v)
    return env


def resolve(name, cfg=None):
    """접속 이름 → dict(type, host, port, database/service, user, password, driver, schema). 누락 키는 KeyError."""
    cfg = cfg or load_cfg()
    c = cfg['connections'][name]
    env = load_env(cfg['envFile'])
    p = c['envPrefix']
    out = {'name': name, 'type': c['type'], 'title': c.get('title', name), 'schema': c.get('schema'), 'readOnly': c.get('readOnly', False)}
    missing = []
    for field, key in c['keys'].items():
        k = f'{p}_{key}'
        if k in env:
            out[field] = env[k]
        elif field in ('driver',):
            out[field] = None
        else:
            missing.append(k)
    if missing:
        raise KeyError(f"{cfg['envFile']} 에 {', '.join(missing)} 가 없습니다")
    return out


def describe(name, cfg=None):
    """로그/리포트용 — 비밀번호 제외."""
    r = resolve(name, cfg)
    target = r.get('service') or r.get('database')
    return f"{r['title']} [{r['type']}] {r['user']}@{r['host']}:{r['port']}/{target}"


def connect(name, cfg=None, write=False):
    r = resolve(name, cfg)
    if r['readOnly'] and write:
        raise PermissionError(f"'{name}' 은 readOnly 접속입니다")
    if r['type'] == 'oracle':
        import oracledb
        dsn = f"{r['host']}:{r['port']}/{r['service']}"
        cx = oracledb.connect(user=r['user'], password=r['password'], dsn=dsn)
        try:
            with cx.cursor() as cur:
                cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'")
                if r.get('schema'):
                    cur.execute(f"ALTER SESSION SET CURRENT_SCHEMA={r['schema']}")
        except Exception:
            pass
        return cx
    if r['type'] == 'mssql':
        try:
            import pyodbc
            drv = r.get('driver') or 'ODBC Driver 17 for SQL Server'
            cs = (f"DRIVER={{{drv}}};SERVER={r['host']},{r['port']};DATABASE={r['database']};"
                  f"UID={r['user']};PWD={r['password']};TrustServerCertificate=yes;Encrypt=no")
            return pyodbc.connect(cs, timeout=15)
        except ImportError:
            import pymssql
            return pymssql.connect(server=r['host'], port=int(r['port']), database=r['database'],
                                   user=r['user'], password=r['password'], login_timeout=15)
    raise ValueError(f"unknown type {r['type']}")


def mask(text, cfg=None):
    """문자열 안에 비밀번호가 섞여 들어갔을 때 치환(예외 메시지 출력용)."""
    cfg = cfg or load_cfg()
    env = load_env(cfg['envFile'])
    for k, v in env.items():
        if re.search(r'(PASS|PWD|PASSWORD)', k, re.I) and v and v in text:
            text = text.replace(v, '***')
    return text


def write_csv(path, cursor, header=None, lower_header=True):
    """커서 결과 → CSV(UTF-8 BOM, Excel 호환). 반환: 행 수"""
    import csv
    cols = header or [d[0] for d in cursor.description]
    if lower_header and not header:
        cols = [c.lower() for c in cols]
    os.makedirs(os.path.dirname(path), exist_ok=True)
    n = 0
    with open(path, 'w', newline='', encoding='utf-8-sig') as f:
        w = csv.writer(f)
        w.writerow(cols)
        for row in cursor:
            w.writerow(['' if v is None else (v.read() if hasattr(v, 'read') else v) for v in row])
            n += 1
    return n


if __name__ == '__main__':
    cfg = load_cfg()
    for n in cfg['connections']:
        try:
            print(describe(n, cfg))
        except Exception as e:
            print(f"{n}: 설정 오류 — {mask(str(e), cfg)}")
