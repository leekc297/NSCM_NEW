#!/usr/bin/env python3
"""
apply_sheet_columns_merge.py — Phase 1 MERGE 일괄 적용 + 검증

사내 Oracle (SCM_MGR @ 121.162.245.167:2521/OCGSCMD_P01) 에 대해
SHEET_COLUMNS_ASIS_SYNC/03_META/ 의 010/020/030/040/050/090 SQL 일괄 적용.

자격 정보는 nscm-be/src/main/resources/config/config-local.yml 에서 자동 추출 (인라인 노출 없음).
"""
import os
import re
import sys
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
DEPLOY_DIR = ROOT / '_artifacts' / '_deploy_packages' / 'SHEET_COLUMNS_ASIS_SYNC' / '03_META'
BE_CONFIG = ROOT / 'nscm-be' / 'src' / 'main' / 'resources' / 'config' / 'config-local.yml'


def load_creds_from_be_config():
    """BE config-local.yml 에서 jdbc-url / username / password 추출."""
    text = BE_CONFIG.read_text(encoding='utf-8', errors='ignore')
    # 활성 (주석 아님) jdbc-url / username / password
    url = None
    user = None
    pwd = None
    for line in text.splitlines():
        s = line.strip()
        if s.startswith('#'):
            continue
        m = re.match(r'jdbc-url:\s*(\S+)', s)
        if m and url is None:
            url = m.group(1)
        m = re.match(r"username:\s*\"?([^\"]+)\"?", s)
        if m and user is None:
            user = m.group(1).strip()
        m = re.match(r"password:\s*\"([^\"]+)\"", s)
        if m and pwd is None:
            pwd = m.group(1)
    # jdbc:log4jdbc:oracle:thin:@host:port/service → host:port/service
    m = re.search(r'@([^/]+)/(\S+)', url or '')
    if not m:
        m = re.search(r'@([^:]+):(\d+):(\S+)', url or '')  # @host:port:SID
        if m:
            dsn = f"{m.group(1)}:{m.group(2)}/{m.group(3)}"
        else:
            sys.exit(f'JDBC URL 파싱 실패: {url}')
    else:
        dsn = f"{m.group(1)}/{m.group(2)}"
    return user, pwd, dsn


def split_statements(sql_text: str):
    """SQL*Plus 지시문 제거 + ; 기준 단순 분할 + COMMIT 처리."""
    out = []
    buf = []
    for raw in sql_text.splitlines():
        line = raw.rstrip()
        s = line.strip()
        # SQL*Plus directives — 무시
        if not s:
            continue
        up = s.upper()
        if up.startswith(('PROMPT', 'SET ', 'SET\t', '--', '@@', 'WHENEVER ', 'SPOOL ', 'COL ', 'COLUMN ')):
            continue
        if up == 'SET DEFINE OFF':
            continue
        # ; 종결문
        if s.endswith(';'):
            buf.append(line.rstrip(';'))
            stmt = '\n'.join(buf).strip()
            if stmt:
                out.append(stmt)
            buf = []
            continue
        buf.append(line)
    if buf and any(l.strip() for l in buf):
        out.append('\n'.join(buf).strip())
    return out


def run_file(con, file_path: pathlib.Path):
    print(f'\n══════ {file_path.name} ══════')
    text = file_path.read_text(encoding='utf-8', errors='ignore').replace('\r', '')
    stmts = split_statements(text)
    cur = con.cursor()
    for i, s in enumerate(stmts, 1):
        head = s.split('\n')[0][:80]
        try:
            cur.execute(s)
            rc = cur.rowcount
            if cur.description:
                rows = cur.fetchall()
                cols = [c[0] for c in cur.description]
                print(f'[{i}/{len(stmts)}] {head[:60]}...')
                for r in rows[:50]:
                    print('     ', ' | '.join(str('' if v is None else v) for v in r))
                if len(rows) > 50:
                    print(f'     ... ({len(rows)} total)')
            else:
                print(f'[{i}/{len(stmts)}] OK ({rc} row affected) — {head[:60]}')
        except Exception as e:
            print(f'[{i}/{len(stmts)}] FAIL — {head[:60]}')
            print(f'     ERROR: {e}')
            raise
    con.commit()
    cur.close()


def main():
    try:
        import oracledb
    except ImportError:
        sys.exit('ERROR: pip install oracledb 필요')

    user, pwd, dsn = load_creds_from_be_config()
    print(f'접속: {user} @ {dsn}')

    con = oracledb.connect(user=user, password=pwd, dsn=dsn)
    try:
        files = [
            '010_AUDIT_PRE.sql',
            '020_MERGE_DMF0008.sql',
            '030_MERGE_DMF0020.sql',
            '040_MERGE_DMF0043.sql',
            '050_MERGE_DMF0072.sql',
            '090_AUDIT_POST.sql',
        ]
        for f in files:
            run_file(con, DEPLOY_DIR / f)
        print('\n✅ Phase 1 모든 파일 적용 완료')
    finally:
        con.close()


if __name__ == '__main__':
    main()
