# -*- coding: utf-8 -*-
r"""
meta_apply — Vibe_Manager 👀 META 미리보기 / ✅ META 커밋 (사용자 지시 2026-10-22: 사내 META 작업 때 PROCEDURE 도 같이)
  python meta_apply.py <ID> [--commit]
  ① Doc/gen/<ID>/<ID>_PKG.sql — 파일의 PACKAGE / PACKAGE BODY 를 사내 ALL_SOURCE 와 비교(FRESH 비교)
       사내에 없음 → 컴파일 · 같음 → 건너뜀 · 다름 + 사내 = 이 파일로 마지막 적용한 상태(Doc/gen/<ID>/_pkg_applied.json 지문) → 컴파일
       다름 + 지문 없음/불일치(다른 작업자·직접 수정·사내 현행본) → **중단**(사내를 덮지 않음 — 병합 후 다시, 정말 덮으려면 --force-pkg)
       컴파일은 --commit 일 때만(DDL 은 ROLLBACK 불가) · 성공하면 사내 재조회본 지문을 기록 · --check = 비교만
  ② Doc/gen/<ID>/<ID>_registration.sql — run_sql.py 로 실행(--commit 없으면 끝에 ROLLBACK)
  PROC_M 은 PKG 인자(ALL_ARGUMENTS)에서 만들어지므로 ① → ② 순서. 종료코드 0 정상 / 1 실행 오류 / 2 FRESH 중단
"""
import sys as _sys
try: _sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
import os, re, sys, subprocess, datetime, difflib, hashlib, json
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, HERE)
import dbconn

def file_blocks(text):
    """<ID>_PKG.sql 의 CREATE OR REPLACE PACKAGE [BODY] 블록 → [(TYPE, NAME, 본문 줄[])] (ALL_SOURCE 와 같은 형태: 'PACKAGE …' 부터, 종결 '/' 줄 제외)"""
    lines = text.replace('\r\n', '\n').split('\n'); out = []; i = 0
    hdr = re.compile(r'^\s*CREATE\s+OR\s+REPLACE\s+(?:EDITIONABLE\s+|NONEDITIONABLE\s+)?(PACKAGE(?:\s+BODY)?)\s+("?[\w$#]+"?\.)?"?([\w$#]+)"?(.*)$', re.I)
    while i < len(lines):
        m = hdr.match(lines[i])
        if not m: i += 1; continue
        typ = re.sub(r'\s+', ' ', m.group(1).upper()); name = m.group(3).upper()
        body = [f"{typ} {name}{m.group(4)}"]; i += 1
        while i < len(lines) and lines[i].strip() != '/': body.append(lines[i]); i += 1
        out.append((typ, name, body)); i += 1
    return out

def hsh(lines): return hashlib.sha1('\n'.join(lines).encode('utf-8', 'surrogateescape')).hexdigest()

def norm(lines):
    ls = [l.rstrip() for l in lines]
    if ls:  # 첫 줄: 스키마 접두·따옴표·공백 차이 무시
        ls[0] = re.sub(r'\s+', ' ', re.sub(r'"?[\w$#]+"?\.(?="?[\w$#]+)', '', ls[0], count=1).replace('"', '')).strip().upper()
    while ls and not ls[-1].strip(): ls.pop()
    return ls

def main():
    a = sys.argv[1:]
    if not a or a[0].startswith('--'): sys.exit(__doc__)
    ID = a[0].upper(); commit = '--commit' in a; check = '--check' in a; force = '--force-pkg' in a  # --check: 비교만(읽기 전용)
    gen = os.path.join(ROOT, 'Doc', 'gen', ID); pkg = os.path.join(gen, f'{ID}_PKG.sql'); reg = os.path.join(gen, f'{ID}_registration.sql')
    run_sql = [sys.executable, os.path.join(HERE, 'run_sql.py')]
    print(f"{'✅ META 커밋' if commit else '👀 META 미리보기'} — {ID}")
    rc = 0
    # ① PKG
    if not os.path.exists(pkg):
        print(f"① PKG: {os.path.relpath(pkg, ROOT)} 없음 — 건너뜀")
    else:
        cfg = dbconn.load_cfg(); schema = (dbconn.resolve('tobe', cfg).get('schema') or '').upper()
        apf = os.path.join(gen, '_pkg_applied.json'); applied = json.load(open(apf, encoding='utf-8')) if os.path.exists(apf) else {}
        fmt = datetime.datetime.fromtimestamp(os.path.getmtime(pkg))
        blocks = file_blocks(open(pkg, encoding='utf-8-sig').read())
        if not blocks: print('① PKG: 파일에서 CREATE OR REPLACE PACKAGE 블록을 찾지 못함 — 건너뜀')
        cx = dbconn.connect('tobe', cfg); cur = cx.cursor(); diffs = []; newer = []
        for typ, name, body in blocks:
            cur.execute("SELECT text FROM all_source WHERE owner = :o AND name = :n AND type = :t ORDER BY line", o=schema, n=name, t=typ)
            db = ''.join(r[0] or '' for r in cur.fetchall()).split('\n')
            cur.execute("SELECT last_ddl_time, status FROM all_objects WHERE owner = :o AND object_name = :n AND object_type = :t", o=schema, n=name, t=typ)
            meta = cur.fetchone()
            if not meta: diffs.append((typ, name, '사내에 없음(신규)', None)); continue
            nf, nd = norm(body), norm(db)
            if nf == nd: print(f"① {typ} {name}: 사내와 동일 — 컴파일 생략 (사내 {meta[1]})"); continue
            owned = applied.get(f'{typ} {name}') == hsh(nd)  # 사내 = 이 파일로 마지막 적용한 상태
            n = sum(1 for l in difflib.unified_diff(nd, nf, lineterm='', n=0) if l[:1] in '+-' and l[:3] not in ('+++', '---'))
            ddl = meta[0] if isinstance(meta[0], datetime.datetime) else datetime.datetime.strptime(str(meta[0])[:19], '%Y-%m-%d %H:%M:%S')
            diffs.append((typ, name, f'차이 {n}줄 · 사내 LAST_DDL {ddl:%Y-%m-%d %H:%M} · 파일 {fmt:%Y-%m-%d %H:%M} · {"마지막 적용 상태 그대로" if owned else "이 파일로 적용된 적 없거나 그 뒤 바뀜"}', ddl))
            if not owned: newer.append((typ, name, ddl, n))
        cx.close()
        for typ, name, why, _ in diffs: print(f"① {typ} {name}: {why}")
        if check: print('(--check: 비교만 — 실행 없음)'); sys.exit(2 if newer else 0)
        if newer and not force:
            for typ, name, ddl, n in newer: print(f"⛔ ① {typ} {name}: 사내 현행(LAST_DDL {ddl:%Y-%m-%d %H:%M})과 {n}줄 다르고, 이 파일로 마지막 적용한 상태가 아님")
            print("   → 사내 PKG 를 이 파일로 덮으면 다른 작업자·직접 수정분이 사라질 수 있어 META 작업을 중단합니다.")
            print("     사내 ALL_SOURCE 와 파일을 병합해 파일을 갱신(룰 H14 · 🛠️ 기존 화면 보완)한 뒤 다시 실행하세요. 정말 덮어써야 하면 --force-pkg.")
            sys.exit(2)
        if diffs:
            if commit:
                print(f"① PKG 컴파일: {os.path.relpath(pkg, ROOT)}", flush=True)
                r = subprocess.run(run_sql + [pkg, '--commit']); rc = rc or r.returncode
                if r.returncode != 0: print('✖ ① PKG 컴파일 오류 — META 적용 중단'); sys.exit(1)
                cx = dbconn.connect('tobe', cfg); cur = cx.cursor()  # 적용 지문 기록 = 사내 재조회본
                for typ, name, body in blocks:
                    cur.execute("SELECT text FROM all_source WHERE owner = :o AND name = :n AND type = :t ORDER BY line", o=schema, n=name, t=typ)
                    applied[f'{typ} {name}'] = hsh(norm(''.join(r[0] or '' for r in cur.fetchall()).split('\n')))
                cx.close(); applied['_at'] = datetime.datetime.now().isoformat(timespec='seconds')
                json.dump(applied, open(apf, 'w', encoding='utf-8'), ensure_ascii=False, indent=1); print(f"   적용 지문 기록 → {os.path.relpath(apf, ROOT)}")
            else: print('   (미리보기: PKG 는 DDL 이라 되돌릴 수 없어 실행하지 않음 — ✅ META 커밋 때 컴파일됩니다. 아래 META 결과는 현재 사내 PKG 인자 기준)')
    # ② META
    if not os.path.exists(reg): print(f"② META: {os.path.relpath(reg, ROOT)} 없음 — 건너뜀"); sys.exit(rc)
    print(f"② META {'커밋' if commit else '미리보기(ROLLBACK)'}: {os.path.relpath(reg, ROOT)}", flush=True)
    r = subprocess.run(run_sql + [reg] + (['--commit'] if commit else [])); rc = rc or r.returncode
    sys.exit(rc)

if __name__ == '__main__':
    main()
