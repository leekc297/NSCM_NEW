# -*- coding: utf-8 -*-
"""메뉴별 실저장 정리 정의 자동 생성(2026-10-31) — 저장 PROC(PROC_M SAVE/INS/UPD/DEL) 본문을 사내오라클 ALL_SOURCE 에서 새로 읽어 하위 호출까지(깊이 3) DML 대상 테이블을 찾는다.

  python tools/Harness/verify/gen_cleanup_spec.py [MENU ...] [--write]
    → Doc/verify/_cleanup_spec_gen.csv(메뉴·저장 PROC·DML 테이블·키·미해석 테이블) · --write 면 cleanup_spec.json 에 없는 메뉴만 추가(수기 정의는 건드리지 않음)

  키 = 대표 테이블(DML 문장이 가장 많은 영구 테이블)의 PK 컬럼 중 대상 테이블 전부에 있는 컬럼(이력·계산 컬럼 제외)
  키를 못 가진 테이블 = unresolved_tables → 그 테이블의 잔존은 save_residue.py 가 실측 보고한다(정리 대상 밖임을 숨기지 않는다)
"""
import argparse, collections, csv, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
from facts_sortrules import strip_comments  # noqa: E402  # SQL 주석(--·/* */) 제거 — facts_combosrc 판은 // 만 지운다(T37)
from sort_check import proc_body  # noqa: E402
from dbconn import connect  # noqa: E402

SPEC = os.path.join(HERE, 'cleanup_spec.json')
RX_CALL = re.compile(r'(?i)\b((?:PKG_[A-Z0-9_]+\.)?(?:P_|PR_)[A-Z0-9_]+)\s*\(')
RX_DML = re.compile(r'(?i)\b(INSERT\s+INTO|MERGE\s+INTO|UPDATE|DELETE\s+FROM|DELETE)\s+(?:SCM_MGR\.)?([A-Z][A-Z0-9_$]+)\b')
NOT_TABLE = re.compile(r'(?i)^(SET|WHERE|FROM|OF|V_|L_|P_|O_)')
INFRA = re.compile(r'(?i)^SCM_SYS_LOG|TITLESET|EXCEL_UP|_UPLOAD|_TMP$|_TEMP$|_WRK$|_LOG$|^SCM_COM_ATCH')
SKIP_KEY = re.compile(r'(?i)^(CREATION_DATE|CREATED_BY|LAST_UPDATE|LAST_UPDATED_BY|SEQ|HIST|H_|YYYYMM)')


def rdcsv(p):
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menus', nargs='*'); ap.add_argument('--write', action='store_true'); a = ap.parse_args()
    pm = [r for r in rdcsv(os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'proc_meta.csv')) if r.get('proc') and re.search(r'SAVE|INS|UPD|DEL', r.get('btn') or '', re.I) and (r.get('use_yn') or 'Y') != 'N']
    want = [m.upper() for m in a.menus] or sorted({r['menu_id'].upper() for r in rdcsv(os.path.join(ROOT, 'Doc', 'verify', '_doc_proof_rows.csv')) if r['menu_id']})
    spec = json.load(open(SPEC, encoding='utf-8')); out = []; min_depth = {}
    sheet_cols = rdcsv(os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'sheet_columns.csv'))
    for k in [k for k, v in spec.items() if isinstance(v, dict) and v.get('_generated') and k in want]:  # 다시 생성(수기 정의는 유지)
        spec.pop(k)
    with connect('tobe') as cx:
        cur = cx.cursor(); pkgs = {}; alones = {}

        def pkg_src(pkg):
            if pkg not in pkgs:
                cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=pkg); m = cur.fetchone()
                txt = ''
                if m:
                    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=m[0], n=pkg)
                    txt = strip_comments(''.join(r[0] for r in cur.fetchall()))
                pkgs[pkg] = txt
            return pkgs[pkg]

        def alone(name):
            if name not in alones:
                cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=name); m = cur.fetchone()
                txt = ''
                if m:
                    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", o=m[0], n=name)
                    txt = strip_comments(''.join(r[0] for r in cur.fetchall()))
                alones[name] = txt
            return alones[name]

        def walk(name, cur_pkg, depth, seen, dml, notes):
            key = name.upper()
            if key in seen or depth > 3:
                return
            seen.add(key)
            pkg, proc = key.split('.') if '.' in key else (cur_pkg, key)
            body = ''
            if pkg:
                src = pkg_src(pkg); body = proc_body(src, proc) if src else ''
            if not body:
                body = alone(proc)
            if not body:
                notes.append(f'본문 없음 {key}'); return
            for m in RX_DML.finditer(body):
                t = m.group(2).upper()
                if not NOT_TABLE.match(t):
                    dml[t] += 1; min_depth[t] = min(min_depth.get(t, 9), depth)
            for m in RX_CALL.finditer(body):
                if m.group(1).upper() != key:
                    walk(m.group(1), pkg, depth + 1, seen, dml, notes)
        for mid in want:
            ps = sorted({r['proc'] for r in pm if r['menu_id'].upper() == mid})
            if not ps:
                out.append({'menu': mid, 'status': '저장 PROC 없음', 'procs': '', 'tables': '', 'keys': '', 'unresolved': '', 'notes': ''}); continue
            dml = collections.Counter(); seen = set(); notes = []; min_depth.clear()
            for p in ps:
                walk(p, '', 0, seen, dml, notes)
            perm = {}
            for t, n in dml.items():
                cur.execute("SELECT TEMPORARY FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t); r = cur.fetchone()
                if r and r[0] == 'N':
                    perm[t] = n
            if not perm:
                out.append({'menu': mid, 'status': '영구 테이블 DML 없음', 'procs': ';'.join(ps), 'tables': '', 'keys': '', 'unresolved': '', 'notes': ';'.join(notes)[:300]}); continue
            cols = {}
            for t in perm:
                cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t); cols[t] = {r[0] for r in cur.fetchall()}
            # 대표 테이블 = 업무 테이블 중 저장 PROC 본문(깊이 0)에서 DML 이 가장 많은 것. 기반 테이블(로그·개인화·업로드 임시)은 대표·키 후보에서 뺀다(2026-10-31 DMF0021 키가 TITLESET 으로 잡힌 결함)
            biz = {t: n for t, n in perm.items() if not INFRA.search(t)}
            if not biz:
                out.append({'menu': mid, 'status': '업무 테이블 DML 없음', 'procs': ';'.join(ps), 'tables': '', 'keys': '', 'unresolved': ';'.join(perm), 'notes': ';'.join(notes)[:300]})
                if a.write and mid not in spec:
                    spec[mid] = {'mode': 'editonly', '_generated': '2026-10-31 gen_cleanup_spec.py', '_why': '업무 테이블 DML 없음(개인화·로그만)', 'tables': [], 'unresolved_tables': list(perm)}
                continue
            root = sorted(biz, key=lambda t: (t.endswith('_H'), min_depth.get(t, 9), -biz[t], t))[0]
            cur.execute("SELECT C.COLUMN_NAME FROM ALL_CONSTRAINTS K JOIN ALL_CONS_COLUMNS C ON C.OWNER=K.OWNER AND C.CONSTRAINT_NAME=K.CONSTRAINT_NAME WHERE K.OWNER='SCM_MGR' AND K.TABLE_NAME=:t AND K.CONSTRAINT_TYPE='P' ORDER BY C.POSITION", t=root)
            pk = [r[0] for r in cur.fetchall() if not SKIP_KEY.match(r[0])]
            pk_src = 'PK'
            if not pk:  # PK 없는 표 — 유일 인덱스
                cur.execute("SELECT C.COLUMN_NAME FROM ALL_INDEXES I JOIN ALL_IND_COLUMNS C ON C.INDEX_OWNER=I.OWNER AND C.INDEX_NAME=I.INDEX_NAME WHERE I.TABLE_OWNER='SCM_MGR' AND I.TABLE_NAME=:t AND I.UNIQUENESS='UNIQUE' ORDER BY I.INDEX_NAME, C.COLUMN_POSITION", t=root)
                pk = list(dict.fromkeys(r[0] for r in cur.fetchall() if not SKIP_KEY.match(r[0]))); pk_src = '유일 인덱스'
            screen = {r['column_name'].upper() for r in sheet_cols if r.get('program_id', '').upper() == mid}
            hidden = [k for k in pk if screen and k not in screen]
            keys = [k for k in pk if not screen or k in screen]  # 가드는 화면 행 값으로 키를 읽는다 — 화면에 없는 키는 쓸 수 없다
            tables = [t for t in biz if keys and all(k in cols[t] for k in keys)]; unresolved = [t for t in perm if t not in tables]
            status = 'OK' if keys and tables and not hidden else '키가 화면 컬럼 아님' if hidden else f'{pk_src} 없음'
            notes.append(f'대표 {root}({pk_src})')
            if hidden:
                notes.append('화면에 없는 키 ' + ','.join(hidden))
            out.append({'menu': mid, 'status': status, 'procs': ';'.join(ps), 'tables': ';'.join(tables), 'keys': ';'.join(keys), 'unresolved': ';'.join(unresolved), 'notes': ';'.join(notes)[:300]})
            if a.write and status != 'OK' and mid not in spec:  # 신규행 키를 화면에서 읽을 수 없음 → 기존행 수정·원복 저장만(신규행 경로 금지) · 잔존은 save_residue 실측
                spec[mid] = {'mode': 'editonly', '_generated': '2026-10-31 gen_cleanup_spec.py', '_why': status + ' · ' + ';'.join(notes)[:200], 'tables': [t for t in biz], 'unresolved_tables': [t for t in perm if t not in biz]}
            if a.write and status == 'OK' and mid not in spec:
                vary = [k for k in keys if k != 'DIVISION_ID'][:1]
                spec[mid] = {'mode': 'keyset', '_generated': '2026-10-31 gen_cleanup_spec.py', '_why': f"저장 PROC {';'.join(ps)[:200]} 의 DML 대상(깊이 3). 대표 {root} PK", 'keys': keys, 'vary': vary, 'tables': tables, 'unresolved_tables': unresolved}
    with open(os.path.join(ROOT, 'Doc', 'verify', '_cleanup_spec_gen.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['menu', 'status', 'procs', 'tables', 'keys', 'unresolved', 'notes']); w.writeheader(); w.writerows(out)
    if a.write:
        json.dump(spec, open(SPEC, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    c = collections.Counter(o['status'] for o in out)
    print(f'{len(out)}메뉴 {dict(c)} → Doc/verify/_cleanup_spec_gen.csv' + (' · cleanup_spec.json 갱신' if a.write else ''))
    for o in out:
        print(o['menu'], o['status'], 'keys=' + o['keys'], 'tables=' + str(len([x for x in o['tables'].split(';') if x])), 'unresolved=' + o['unresolved'][:90])


if __name__ == '__main__':
    main()
