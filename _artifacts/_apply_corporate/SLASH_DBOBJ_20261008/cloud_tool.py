# -*- coding: utf-8 -*-
"""[E20261008-SLASHOBJ] 클라우드(DEV/QA) 일괄 적용 도구 — 사내 동일여부 사전점검 없이:
   1) backup  : 대상 97객체(manifest_objects.json)의 '현재 클라우드 원문'을 JSON 1파일에 일괄 백업
   2) apply   : (적용 직전 backup 자동 수행 = FRESH-GATE) → 사내 적용본(01_NEW_corp/*.sql)을 CREATE OR REPLACE 일괄 적용
                → 객체별 ALL_ERRORS=0·VALID 확인, 실패 객체는 그 자리에서 백업 원문으로 즉시 원복 → 새로 INVALID 된 의존 객체 재컴파일 → 로그 JSON
   3) verify  : 현재 원문이 사내 적용본과 줄 단위로 같은지(SAME_AS_CORP/DIFF) + 상태·에러
   4) rollback: backup JSON(또는 JSONL spool)에서 원문 복원 (--only 로 일부만)

   사용 (사용자 PC, python-oracledb 설치):
     python cloud_tool.py backup   --env DEV --dsn host:port/service --user SCM_MGR --password '...'
     python cloud_tool.py apply    --env DEV --dsn ... --user ... --password ...            [--dry-run] [--create-missing] [--only A,B]
     python cloud_tool.py verify   --env DEV --dsn ... --user ... --password ...
     python cloud_tool.py rollback --env DEV --dsn ... --user ... --password ... --from 00_CLOUD_BACKUP_DEV_YYYYMMDD_HHMMSS.json [--only A,B]
   산출물: 00_CLOUD_BACKUP_<env>_<ts>.json · 02_CLOUD_APPLY_LOG_<env>_<ts>.json · 04_CLOUD_VERIFY_<env>_<ts>.json · 99_CLOUD_ROLLBACK_LOG_<env>_<ts>.json
"""
import argparse, collections, datetime, hashlib, json, pathlib, re, sys
import oracledb

HERE = pathlib.Path(__file__).resolve().parent
OWNER = "SCM_MGR"
MARK = "[E20261008-SLASHOBJ]"
# 페이로드(클라우드에 넣을 원문) 기본 = 05_CLOUD_PAYLOAD_corp (build_payload.py 가 만든 '지금 사내에 적용된 원문' 스냅샷, payload_manifest.json).
# --payload 01_NEW_corp 로 바꾸면 10-08 16:5x 적용 직후 원문(우리 '/' 변경만 반영된 판) 사용(manifest_objects.json).
NEW_DIR = HERE / "05_CLOUD_PAYLOAD_corp"
MANIFEST = HERE / "payload_manifest.json"
def set_payload(a):
    global NEW_DIR, MANIFEST
    if getattr(a, "payload", None):
        NEW_DIR = HERE / a.payload
        MANIFEST = HERE / ("manifest_objects.json" if a.payload == "01_NEW_corp" else "payload_manifest.json")

# ---------- 공통 ----------
def ts(): return datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
def sha(lines): return hashlib.sha1("\n".join(lines).encode("utf-8")).hexdigest()
def connect(a):
    if not a.dsn: sys.exit("--dsn host:port/service 필수 (클라우드 DEV/QA)")
    return oracledb.connect(user=a.user or OWNER, password=a.password, dsn=a.dsn)

def manifest(a):
    set_payload(a)
    doc = json.loads(MANIFEST.read_text(encoding="utf-8")); rows = doc["objects"] if isinstance(doc, dict) else doc
    only = set(x.strip() for x in a.only.split(",")) if getattr(a, "only", None) else None
    return [r for r in rows if not only or r["name"] in only]

def fetch_source(cur, otype, name):
    """VIEW: DBMS_METADATA DDL(줄 리스트, kind='ddl') / 그 외: ALL_SOURCE 줄 리스트(kind='source'). 없으면 (None, None)."""
    cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=name, t=otype)
    st = cur.fetchone()
    if not st: return None, None, (None, None)
    if otype == "VIEW":
        cur.execute("SELECT DBMS_METADATA.GET_DDL('VIEW', :n, :o) FROM dual", n=name, o=OWNER)
        d = cur.fetchone()[0]; d = d.read() if hasattr(d, "read") else str(d)
        return [l.rstrip("\r") for l in d.split("\n")], "ddl", st
    cur.execute("SELECT text FROM all_source WHERE owner=:o AND name=:n AND type=:t ORDER BY line", o=OWNER, n=name, t=otype)
    return [(r[0] or "").rstrip("\r\n") for r in cur.fetchall()], "source", st

def errors(cur, otype, name):
    cur.execute("SELECT line, position, text FROM all_errors WHERE owner=:o AND name=:n AND type=:t AND attribute='ERROR' ORDER BY sequence", o=OWNER, n=name, t=otype)
    return [f"L{l}:{p} {t.strip()[:160]}" for l, p, t in cur.fetchall()]

def status(cur, otype, name):
    cur.execute("SELECT status FROM all_objects WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=name, t=otype)
    r = cur.fetchone(); return r[0] if r else None

def invalid_set(cur):
    cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner=:o AND status='INVALID'", o=OWNER)
    return {f"{t}|{n}" for t, n in cur.fetchall()}

def build_ddl(otype, kind, lines):
    text = "\n".join(lines)
    if kind == "ddl": return text.rstrip().rstrip(";")
    return "CREATE OR REPLACE " + text.lstrip()

def new_lines(r):
    f = NEW_DIR / r["file"]
    return f.read_text(encoding="utf-8").split("\n"), ("ddl" if r["otype"] == "VIEW" else "source")

def compile_stmt(key):
    t, n = key.split("|", 1)
    if t == "PACKAGE BODY": return f'ALTER PACKAGE {OWNER}.{n} COMPILE BODY'
    if t == "PACKAGE": return f'ALTER PACKAGE {OWNER}.{n} COMPILE SPECIFICATION'
    if t in ("PROCEDURE", "FUNCTION", "VIEW", "TRIGGER", "TYPE", "SYNONYM"): return f'ALTER {t} {OWNER}.{n} COMPILE'
    if t == "TYPE BODY": return f'ALTER TYPE {OWNER}.{n} COMPILE BODY'
    return None

# ---------- backup ----------
def take_backup(cur, a, rows, tag):
    objs = []; miss = 0
    for r in rows:
        lines, kind, (st, ddl_t) = fetch_source(cur, r["otype"], r["name"])
        if lines is None:
            objs.append(dict(type=r["otype"], name=r["name"], exists=False)); miss += 1; continue
        objs.append(dict(type=r["otype"], name=r["name"], exists=True, status=st, last_ddl=ddl_t, kind=kind, line_count=len(lines),
                         dash_lines=sum(1 for l in lines if "'-'" in l), sha1=sha(lines), lines=lines))
    doc = dict(mark=MARK, env=a.env, dsn=a.dsn, at=datetime.datetime.now().isoformat(timespec="seconds"), owner=OWNER,
               invalid_baseline=sorted(invalid_set(cur)), objects=objs)
    out = HERE / f"00_CLOUD_BACKUP_{a.env}_{tag}.json"
    out.write_text(json.dumps(doc, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"BACKUP {out.name}: objects {len(objs)} (missing {miss}) · bytes {out.stat().st_size:,} · baseline INVALID {len(doc['invalid_baseline'])}")
    return doc, out

def backup(a):
    con = connect(a); cur = con.cursor(); take_backup(cur, a, manifest(a), ts())

# ---------- apply ----------
def apply(a):
    rows = manifest(a); con = connect(a); cur = con.cursor(); tag = ts()
    # FRESH-GATE: 적용 직전 현재 원문을 그대로 백업(= 원복 기준). 백업과 적용 사이에 다른 변경이 끼어들 틈이 없도록 같은 세션에서 연속 수행.
    bk, bk_path = take_backup(cur, a, rows, tag); bmap = {f"{o['type']}|{o['name']}": o for o in bk["objects"]}
    log = []; stat = collections.Counter()
    for r in rows:
        key = f"{r['otype']}|{r['name']}"; b = bmap[key]
        nl, kind = new_lines(r)
        if not b["exists"]:
            if not a.create_missing:
                log.append(dict(object=key, result="SKIP(missing in cloud)")); stat["skip_missing"] += 1; print("SKIP missing", key); continue
        elif (b["kind"] == "source" and [l.rstrip() for l in b["lines"]] == [l.rstrip() for l in nl]) or \
             (b["kind"] == "ddl" and "\n".join(l.strip() for l in b["lines"]).strip() == "\n".join(l.strip() for l in nl).strip()):
            log.append(dict(object=key, result="ALREADY(same as corp applied)")); stat["already"] += 1; continue
        if a.dry_run:
            log.append(dict(object=key, result="DRY-RUN", cloud_lines=b.get("line_count"), corp_lines=len(nl), cloud_dash=b.get("dash_lines"), corp_dash=sum(1 for l in nl if "'-'" in l))); stat["dry"] += 1; continue
        ddl = build_ddl(r["otype"], kind, nl)
        try:
            cur.execute(ddl)
        except Exception as ex:
            res = dict(object=key, result="FAIL", error=str(ex)[:300])
            if b["exists"]:
                try: cur.execute(build_ddl(r["otype"], b["kind"], b["lines"])); res["restored"] = status(cur, r["otype"], r["name"])
                except Exception as ex2: res["restore_error"] = str(ex2)[:200]
            log.append(res); stat["fail"] += 1; print("FAIL", key, str(ex)[:150]); continue
        errs = errors(cur, r["otype"], r["name"]); st = status(cur, r["otype"], r["name"])
        if errs or st != "VALID":
            res = dict(object=key, result="INVALID", errors=errs[:5], status=st)
            if b["exists"]:
                cur.execute(build_ddl(r["otype"], b["kind"], b["lines"])); res["restored"] = status(cur, r["otype"], r["name"]); res["result"] = "INVALID(restored)"
            log.append(res); stat["fail"] += 1; print("INVALID", key, errs[:1]); continue
        after, _, (st2, ddl2) = fetch_source(cur, r["otype"], r["name"])
        log.append(dict(object=key, result="OK", status=st2, last_ddl=ddl2, lines_before=b.get("line_count"), lines_after=len(after),
                        dash_before=b.get("dash_lines"), dash_after=sum(1 for l in after if "'-'" in l), same_as_corp=([l.rstrip() for l in after] == [l.rstrip() for l in nl]) if kind == "source" else None))
        stat["ok"] += 1
    # 새로 INVALID 된 의존 객체 재컴파일(기준선 밖만, 2회)
    recompiled = []
    if not a.dry_run:
        base = set(bk["invalid_baseline"])
        for _ in range(2):
            new_inv = sorted(invalid_set(cur) - base)
            if not new_inv: break
            for key in new_inv:
                s = compile_stmt(key)
                if not s: continue
                kt, kn = key.split("|", 1)
                try: cur.execute(s); recompiled.append(dict(object=key, result=status(cur, kt, kn)))
                except Exception as ex: recompiled.append(dict(object=key, result="ERR", error=str(ex)[:160]))
        still = sorted(invalid_set(cur) - base)
    else: still = []
    out = HERE / f"02_CLOUD_APPLY_LOG_{a.env}_{tag}.json"
    out.write_text(json.dumps(dict(mark=MARK, env=a.env, dsn=a.dsn, at=datetime.datetime.now().isoformat(timespec="seconds"), backup=bk_path.name, dry_run=a.dry_run,
                                   stat=dict(stat), recompiled=recompiled, still_invalid_beyond_baseline=still, log=log), ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"APPLY {a.env}: {dict(stat)} · recompiled {len(recompiled)} · new INVALID remaining {len(still)} · log {out.name}")
    for s in still: print("   still INVALID:", s)

# ---------- verify ----------
def verify(a):
    rows = manifest(a); con = connect(a); cur = con.cursor(); out = []; stat = collections.Counter()
    for r in rows:
        cur_lines, kind, (st, ddl_t) = fetch_source(cur, r["otype"], r["name"]); nl, _ = new_lines(r)
        if cur_lines is None: res = "MISSING"
        elif kind == "ddl": res = "VIEW(" + st + ")"
        else: res = "SAME_AS_CORP" if [l.rstrip() for l in cur_lines] == [l.rstrip() for l in nl] else "DIFF"
        errs = errors(cur, r["otype"], r["name"]) if cur_lines is not None else []
        stat[res if res.startswith(("SAME", "DIFF", "MISSING")) else "VIEW"] += 1
        out.append(dict(object=f"{r['otype']}|{r['name']}", result=res, status=st, last_ddl=ddl_t, errors=len(errs),
                        lines=len(cur_lines) if cur_lines else None, corp_lines=len(nl), dash_lines=sum(1 for l in cur_lines if "'-'" in l) if cur_lines else None, corp_dash=sum(1 for l in nl if "'-'" in l)))
    inv = sorted(invalid_set(cur))
    p = HERE / f"04_CLOUD_VERIFY_{a.env}_{ts()}.json"
    p.write_text(json.dumps(dict(mark=MARK, env=a.env, dsn=a.dsn, at=datetime.datetime.now().isoformat(timespec="seconds"), stat=dict(stat), invalid_all=inv, objects=out), ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"VERIFY {a.env}: {dict(stat)} · schema INVALID {len(inv)} · {p.name}")
    for o in out:
        if o["result"] not in ("SAME_AS_CORP",) and not o["result"].startswith("VIEW(VALID"): print("  ", o["object"], o["result"], o["status"], "lines", o["lines"], "/", o["corp_lines"], "dash", o["dash_lines"], "/", o["corp_dash"])

# ---------- rollback ----------
def load_backup(path):
    p = pathlib.Path(path); txt = p.read_text(encoding="utf-8")
    if p.suffix.lower() == ".jsonl":   # SQL spool(JSON Lines: {"t","n","l","p","s"} 한 행 = 원문 한 줄의 조각 p) → 객체별 lines 로 조립(조각은 이어 붙임)
        objs = collections.OrderedDict()
        for ln in txt.splitlines():
            ln = ln.strip()
            if not ln.startswith("{"): continue
            d = json.loads(ln); objs.setdefault((d["t"], d["n"]), {}).setdefault(int(d["l"]), {})[int(d.get("p", 1))] = d.get("s") or ""
        out = []
        for (t, n), v in objs.items():
            lines = ["".join(pc[k] for k in sorted(pc)) for _, pc in sorted(v.items())]
            kind = "ddl" if t == "VIEW" else "source"
            if kind == "source": lines = [l + "\n" for l in lines]   # ALL_SOURCE 원문은 줄 끝 개행 포함(spool 에서 RTRIM 됨) → 복원
            out.append(dict(type=t, name=n, exists=True, kind=kind, lines=lines))
        return out
    return json.loads(txt)["objects"]

def rollback(a):
    if not a.from_file: sys.exit("--from <00_CLOUD_BACKUP_*.json | *.jsonl> 필수")
    objs = load_backup(a.from_file); only = set(x.strip() for x in a.only.split(",")) if a.only else None
    con = connect(a); cur = con.cursor(); log = []; stat = collections.Counter()
    for o in objs:
        if only and o["name"] not in only: continue
        key = f"{o['type']}|{o['name']}"
        if not o.get("exists", True):
            log.append(dict(object=key, result="SKIP(not in backup: did not exist)")); stat["skip"] += 1; continue
        try:
            cur.execute(build_ddl(o["type"], o.get("kind", "source"), o["lines"]))
            errs = errors(cur, o["type"], o["name"]); st = status(cur, o["type"], o["name"])
            log.append(dict(object=key, result="OK" if (st == "VALID" and not errs) else "RESTORED_BUT_INVALID", status=st, errors=errs[:3])); stat["ok" if st == "VALID" else "invalid"] += 1
        except Exception as ex:
            log.append(dict(object=key, result="FAIL", error=str(ex)[:300])); stat["fail"] += 1; print("FAIL", key, str(ex)[:150])
    p = HERE / f"99_CLOUD_ROLLBACK_LOG_{a.env}_{ts()}.json"
    p.write_text(json.dumps(dict(mark=MARK, env=a.env, dsn=a.dsn, at=datetime.datetime.now().isoformat(timespec="seconds"), source=str(a.from_file), stat=dict(stat), log=log), ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"ROLLBACK {a.env}: {dict(stat)} · {p.name}")

if __name__ == "__main__":
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["backup", "apply", "verify", "rollback"])
    ap.add_argument("--env", default="CLOUD"); ap.add_argument("--dsn"); ap.add_argument("--user"); ap.add_argument("--password")
    ap.add_argument("--only"); ap.add_argument("--dry-run", action="store_true"); ap.add_argument("--create-missing", action="store_true"); ap.add_argument("--from", dest="from_file")
    ap.add_argument("--payload", help="05_CLOUD_PAYLOAD_corp(기본, 사내 현재 원문 스냅샷) | 01_NEW_corp(적용 직후 원문)")
    a = ap.parse_args(); {"backup": backup, "apply": apply, "verify": verify, "rollback": rollback}[a.cmd](a)
