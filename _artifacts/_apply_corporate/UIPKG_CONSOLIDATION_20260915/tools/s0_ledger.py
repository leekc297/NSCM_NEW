"""STEP 0 — 대상 34건(12 PKG) 원장 LEDGER.json 생성 (사내 ZIOUI1 조회 전용)

범위: 00_refresh/TOBE_UI별_PKG전환대상_20260915.md §2 에서 PKG_DMF0008·PKG_DMF0048 제외 (사용자 2026-09-15 — AJS 선작업)
항목(대상 SP 별): 상태·LAST_DDL / META 실사용(BTN_MPG→API_M.API_URL·PROC_M·EXCEL·CMBO) / 동일명 기존 멤버 정규화 대조 /
      호출자 전수(ALL_DEPENDENCIES + ALL_SOURCE 단어경계 텍스트) / 스케줄러 JOB 텍스트 / ALL_ARGUMENTS / AUTHID·PRAGMA /
      SCMP_APP 시노님·EXECUTE / 대상 PKG 의 LAST_DDL·비표준 마커(AJS 등)
"""
import collections, datetime, difflib, json, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE.parents[2] / "_diagnostics"))
import ora, oracledb  # noqa: E402

EXCLUDE_PKG = set()   # 2026-09-15 사용자: PKG_DMF0008·PKG_DMF0048 도 진행 (AJS 멤버 본문 = standalone 으로 교체)
# SP → 대상 PKG 재지정 (사용자 확정)
PKG_OVERRIDE = {"DMF0000_GET_UPDATE_HISTORY": "PKG_DMF0000"}
MD = ROOT / "00_refresh" / "TOBE_UI별_PKG전환대상_20260915.md"
DMF0000_TARGET = "PKG_DMF0000"   # 사용자 확정 — DMF0000_GET_UPDATE_HISTORY 는 기존 PKG_DMF0000 멤버로 재배선 (단 DMF0008 제외로 이번 범위 밖)


def parse_targets():
    sec = MD.read_text(encoding="utf-8").split("## 2.")[1].split("## 3.")[0]
    out, pkg, new = [], None, False
    for l in sec.splitlines():
        m = re.match(r"### (PKG_\w+) \((기존|신규 생성)\)", l)
        if m:
            pkg, new = m.group(1), m.group(2) == "신규 생성"; continue
        if l.startswith("| ") and not l.startswith("| standalone"):
            c = [x.strip() for x in l.strip("|").split("|")]
            if pkg in EXCLUDE_PKG:
                continue
            tpkg = PKG_OVERRIDE.get(c[0], pkg)
            out.append(dict(sp=c[0], pkg=tpkg, pkg_new=new and tpkg == pkg, pkg_in_list=pkg, status_0915=c[1], call_kind=c[2], work_type=c[3], member_plan=c[4], rewire=c[5], pre=c[6]))
    return out


def strip_comments_strings(s):
    s = re.sub(r"/\*.*?\*/", lambda m: " " * len(m.group(0)), s, flags=re.S)
    s = re.sub(r"--[^\n]*", lambda m: " " * len(m.group(0)), s)
    return s


def norm_body(s, names):
    s = re.sub(r"/\*.*?\*/", " ", s, flags=re.S)
    s = re.sub(r"--[^\n]*", " ", s)
    for n in names:
        s = re.sub(r'(?i)"?\b' + re.escape(n) + r'\b"?', "X", s)
    s = re.sub(r"(?i)^\s*PROCEDURE\s+", "", s.strip())
    s = re.sub(r"(?i)END\s+X\s*;\s*(END\s+\w+\s*;)?\s*$", "END;", s.strip())
    return re.sub(r"\s+", " ", s).upper().strip()


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    q = lambda s, **k: (cur.execute(s, k), cur.fetchall())[1]
    targets = parse_targets()
    names = {t["sp"] for t in targets}
    pkgs = sorted({t["pkg"] for t in targets})

    src_cache = {}
    def src(name, typ):
        if (name, typ) not in src_cache:
            src_cache[(name, typ)] = "".join(r[0] for r in q("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ))
        return src_cache[(name, typ)]

    objs = {(r[0], r[1]): (r[2], r[3]) for r in q("SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_TYPE IN ('PROCEDURE','PACKAGE','PACKAGE BODY','FUNCTION','TRIGGER','VIEW','TYPE BODY')")}
    members = collections.defaultdict(set)
    for pk, pr in q("SELECT OBJECT_NAME, PROCEDURE_NAME FROM ALL_PROCEDURES WHERE OWNER='SCM_MGR' AND OBJECT_TYPE='PACKAGE' AND PROCEDURE_NAME IS NOT NULL"):
        members[pk].add(pr)
    syn = {r[0] for r in q("SELECT SYNONYM_NAME FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND TABLE_OWNER='SCM_MGR'")}
    grant = {r[0] for r in q("SELECT TABLE_NAME FROM ALL_TAB_PRIVS WHERE GRANTEE='SCMP_APP' AND TABLE_SCHEMA='SCM_MGR' AND PRIVILEGE='EXECUTE'")}
    api = q("SELECT API_ID, API_TP_CD, API_URL, USE_YN FROM SCM_MGR.SCM_ADM_API_M")
    btn = q("SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M")
    procm = collections.defaultdict(list)
    for r in q("SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M ORDER BY PROC_NM, SORT_ORD"):
        procm[r[0].upper()].append(r[1:])
    excel = q("SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS")
    cmbo = [(r[0], r[1].read() if hasattr(r[1], "read") else (r[1] or "")) for r in q("SELECT SQL_ID, SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M")]
    jobs = q("SELECT JOB_NAME, JOB_ACTION, ENABLED FROM ALL_SCHEDULER_JOBS WHERE OWNER='SCM_MGR'")
    deps = collections.defaultdict(set)
    for n, t, rn in q("SELECT NAME, TYPE, REFERENCED_NAME FROM ALL_DEPENDENCIES WHERE OWNER='SCM_MGR' AND REFERENCED_OWNER='SCM_MGR' AND NAME <> REFERENCED_NAME"):
        deps[rn].add((n, t))
    # 전 소스 (텍스트 참조 — 주석 제거)
    all_src = collections.defaultdict(str)
    for n, t, txt in q("SELECT NAME, TYPE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','TRIGGER','TYPE BODY') ORDER BY NAME, TYPE, LINE"):
        all_src[(n, t)] += txt
    clean = {k: strip_comments_strings(v).upper() for k, v in all_src.items()}

    ledger = dict(fetched=fetched, db=q("SELECT SYS_CONTEXT('USERENV','CON_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL")[0],
                  scope=dict(pkgs=pkgs, excluded=sorted(EXCLUDE_PKG), count=len(targets)), pkgs={}, targets=[])
    for pk in pkgs:
        spec, body = src(pk, "PACKAGE"), src(pk, "PACKAGE BODY")
        marks = sorted(set(re.findall(r"E20\d{6}-[A-Z0-9_]+|hook#\d+|20\d\d\.\d\d\.\d\d\s+[A-Z]{2,5}\b", spec + body)))
        ledger["pkgs"][pk] = dict(exists=bool(spec), spec=objs.get((pk, "PACKAGE")), body=objs.get((pk, "PACKAGE BODY")),
                                  members=len(members.get(pk, ())), scmp_app_synonym=pk in syn, scmp_app_execute=pk in grant,
                                  recent_markers=[m for m in marks if not m.startswith("E20") or m >= "E20260901"])

    for t in targets:
        sp = t["sp"]; up = sp.upper()
        member = sp if sp.upper().startswith("P_") else "P_" + sp
        st = objs.get((sp, "PROCEDURE"))
        s = src(sp, "PROCEDURE")
        head = strip_comments_strings(s)[: s.upper().find(" IS") + 400 if " IS" in s.upper() else 600].upper()
        rec = dict(t, member=member, status=st, lines=s.count("\n"),
                   authid=bool(re.search(r"\bAUTHID\b", head)), pragma=sorted(set(re.findall(r"PRAGMA\s+(\w+)", strip_comments_strings(s).upper()))),
                   scmp_app_synonym=sp in syn, scmp_app_execute=sp in grant)
        # META 실사용
        api_rows = [dict(api_id=a, tp=tp, url=url, use=use) for a, tp, url, use in api if (url or "").upper() in (up, "SCM_MGR." + up)]
        api_ids = {a["api_id"] for a in api_rows}
        rec["meta"] = dict(api_m=api_rows,
                           btn_mpg=[dict(mnu=m, sht=sh, btn=b, api=a, use=us) for m, sh, b, a, us in btn if a in api_ids],
                           proc_m=[list(x) for x in procm.get(up, [])],
                           excel=[list(x) for x in excel if (x[2] or "").upper() == up],
                           cmbo=[sid for sid, txt in cmbo if re.search(r"(?<![A-Z0-9_$#.])" + re.escape(up) + r"(?![A-Z0-9_$#])", txt.upper())])
        # 동일명 기존 멤버
        pk = t["pkg"]
        if member.upper() in members.get(pk, set()):
            body = src(pk, "PACKAGE BODY")
            i = re.search(r"(?im)^\s*PROCEDURE\s+" + re.escape(member) + r"\b", body)
            mb = ""
            if i:
                nxt = re.search(r"(?im)^\s*(PROCEDURE|FUNCTION)\s+\w+", body[i.end():])
                mb = body[i.start(): i.end() + (nxt.start() if nxt else len(body) - i.end())]
            a, b = norm_body(s, [sp, member, pk]), norm_body(mb, [sp, member, pk])
            diff = [x for x in difflib.ndiff(a.split(" "), b.split(" ")) if x[:1] in "+-"]
            rec["same_name_member"] = dict(exists=True, found_in_body=bool(i), identical=a == b, token_diff=len(diff), diff_sample=diff[:40],
                                           member_markers=sorted(set(re.findall(r"20\d\d\.\d\d\.\d\d\s+[A-Z]{2,5}\b|E20\d{6}-[A-Z0-9_]+", mb))))
        else:
            rec["same_name_member"] = dict(exists=False)
        # 호출자
        callers_dep = sorted(f"{n}|{ty}" for n, ty in deps.get(up, ()))
        pat = re.compile(r"(?<![A-Z0-9_$#])" + re.escape(up) + r"(?![A-Z0-9_$#])")
        callers_txt = sorted(f"{n}|{ty}|{len(pat.findall(txt))}" for (n, ty), txt in clean.items() if n != up and pat.search(txt))
        rec["callers"] = dict(dependencies=callers_dep, source_text=callers_txt)
        rec["sched_jobs"] = sorted(j for j, act, en in jobs if act and pat.search(strip_comments_strings(act).upper()))
        rec["arguments"] = [list(r) for r in q("SELECT POSITION, ARGUMENT_NAME, IN_OUT, DATA_TYPE, DEFAULTED FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND PACKAGE_NAME IS NULL AND DATA_LEVEL=0 ORDER BY POSITION", n=up)]
        ledger["targets"].append(rec)

    out = ROOT / "LEDGER.json"
    out.write_text(json.dumps(ledger, ensure_ascii=False, indent=1, default=str), encoding="utf-8")
    print("written", out, "targets", len(ledger["targets"]))
    print("\n[PKG]")
    for pk, v in ledger["pkgs"].items():
        print(f"  {pk:13} exists={v['exists']} body={v['body']} members={v['members']} syn={v['scmp_app_synonym']} exec={v['scmp_app_execute']} recent={v['recent_markers'][-6:]}")
    print("\n[TARGET]")
    for r in ledger["targets"]:
        sm = r["same_name_member"]
        print(f"  {r['pkg']:12} {r['sp']:48} {r['status']} api={len(r['meta']['api_m'])} btn={len(r['meta']['btn_mpg'])} procm={len(r['meta']['proc_m'])} excel={len(r['meta']['excel'])} cmbo={len(r['meta']['cmbo'])}"
              f" | same={('Y ident' if sm.get('identical') else 'Y diff' + str(sm.get('token_diff'))) if sm['exists'] else 'N'}"
              f" | callers={[c.split('|')[0] for c in r['callers']['source_text']]} jobs={r['sched_jobs']} authid={r['authid']} pragma={r['pragma']} args={len(r['arguments'])}")


if __name__ == "__main__":
    main()
