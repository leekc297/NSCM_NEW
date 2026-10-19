"""STEP 3 — META 전환 SQL 생성 · (사용자 2026-09-15 추가 지시) 사내 ZIOUI1 실행 · 검증

usage: python s3_meta.py build | apply | verify

생성 (03_meta/<PKG>/):
  30_META_SWITCH.sql   PROC_M: 같은 환경의 standalone 행을 새 PROC_NM('PKG.멤버')으로 복제(MERGE ON PK — 멱등)
                       API_M : API_ID 키로 API_URL = 'PKG.멤버' (이전값 WHERE 없음 — 멱등)
  38_META_VERIFY.sql   API_URL · PROC_M 행수/IN-OUT 순서 == 멤버 ALL_ARGUMENTS · PR_GET_PROC_INFO_LIST 해석 결과
  39_META_ROLLBACK.sql API_URL → standalone · 복제 PROC_M 행 삭제
기존 standalone PROC_M 행은 STEP 4(DROP) 까지 유지.
"""
import csv, datetime, json, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
OUT = ROOT / "03_meta"
sys.path.insert(0, str(HERE.parents[2] / "_diagnostics"))
import ora, oracledb  # noqa: E402

LOG = OUT / "APPLY_LOG.md"


def q(s):
    return "'" + str(s).replace("'", "''") + "'"


def plan(L):
    """PKG → [(sp, member, qualified, [api rows], proc_nm_original)]"""
    api_bk = {r["API_ID"]: r for r in csv.DictReader((ROOT / "01_backup" / "meta" / "SCM_ADM_API_M.csv").open(encoding="utf-8-sig"))}
    pm_bk = {}
    for r in csv.DictReader((ROOT / "01_backup" / "meta" / "SCM_ADM_PROC_M.csv").open(encoding="utf-8-sig")):
        pm_bk.setdefault(r["PROC_NM"].upper(), r["PROC_NM"])
    out = {}
    for t in L["targets"]:
        apis = [a["api_id"] for a in t["meta"]["api_m"]]
        if not apis:
            continue
        orig_url = {a: api_bk[a]["API_URL"] for a in apis}
        out.setdefault(t["pkg"], []).append(dict(sp=t["sp"], member=t["member"], qual=f"{t['pkg']}.{t['member']}",
                                                 apis=apis, orig_url=orig_url, proc_nm=pm_bk.get(t["sp"].upper(), t["sp"]),
                                                 procm_rows=len(t["meta"]["proc_m"]), btn=t["meta"]["btn_mpg"]))
    return out


def build(L):
    P = plan(L)
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    for pkg, items in sorted(P.items()):
        d = OUT / pkg; d.mkdir(parents=True, exist_ok=True)
        sw = [f"-- {pkg} — META 전환: 화면 API 가 standalone 대신 PKG 멤버를 호출하도록 (SCM_MGR · 멱등)",
              f"-- 생성 {now} · 선행: STEP 2 PKG SPEC/BODY 적용·VALID (멤버 존재) · 사내 적용 시 BE 재기동 불요(META 매 호출 조회)",
              "SET DEFINE OFF", ""]
        vf = [f"-- {pkg} — META 전환 확인 (조회 전용)", "SET PAGESIZE 200 LINESIZE 300", ""]
        rb = [f"-- {pkg} — META 원복: API_URL → standalone · 복제 PROC_M 삭제 (SCM_MGR)", "SET DEFINE OFF", ""]
        for it in items:
            sw += [f"-- [{it['sp']} → {it['qual']}] API {', '.join(it['apis'])} · PROC_M {it['procm_rows']}행",
                   "MERGE INTO SCM_MGR.SCM_ADM_PROC_M T",
                   f"USING (SELECT {q(it['qual'])} PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M WHERE UPPER(PROC_NM) = {q(it['sp'].upper())}) S",
                   "ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD)",
                   "WHEN MATCHED THEN UPDATE SET T.DATA_TP_CD = S.DATA_TP_CD, T.SORT_ORD = S.SORT_ORD, T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE",
                   "WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)",
                   "     VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);",
                   f"UPDATE SCM_MGR.SCM_ADM_API_M SET API_URL = {q(it['qual'])}, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE",
                   f" WHERE API_ID IN ({', '.join(q(a) for a in it['apis'])});", ""]
            vf += [f"-- {it['sp']} → {it['qual']}",
                   f"SELECT API_ID, API_URL, CASE WHEN API_URL = {q(it['qual'])} THEN 'OK' ELSE 'NG' END CHK FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN ({', '.join(q(a) for a in it['apis'])});",
                   f"SELECT {q(it['qual'])} PROC_NM,",
                   f"       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = {q(it['qual'])}) NEW_ROWS,",
                   f"       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE UPPER(PROC_NM) = {q(it['sp'].upper())}) STANDALONE_ROWS,",
                   f"       (SELECT COUNT(*) FROM USER_ARGUMENTS WHERE PACKAGE_NAME = {q(pkg)} AND OBJECT_NAME = {q(it['member'])} AND DATA_LEVEL = 0) MEMBER_ARGS,",
                   f"       (SELECT LISTAGG(COL_TP_CD, ',') WITHIN GROUP (ORDER BY SORT_ORD) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = {q(it['qual'])}) PROC_M_INOUT,",
                   f"       (SELECT LISTAGG(REPLACE(IN_OUT, 'IN/OUT', 'INOUT'), ',') WITHIN GROUP (ORDER BY POSITION) FROM USER_ARGUMENTS WHERE PACKAGE_NAME = {q(pkg)} AND OBJECT_NAME = {q(it['member'])} AND DATA_LEVEL = 0) MEMBER_INOUT",
                   "  FROM DUAL;", ""]
            rb += [f"UPDATE SCM_MGR.SCM_ADM_API_M SET API_URL = {q(list(it['orig_url'].values())[0])}, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE WHERE API_ID IN ({', '.join(q(a) for a in it['apis'])});",
                   f"DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = {q(it['qual'])};", ""]
            assert len(set(it["orig_url"].values())) == 1, it
        sw.append("COMMIT;"); rb.append("COMMIT;")
        (d / "30_META_SWITCH.sql").write_text("\n".join(sw) + "\n", encoding="utf-8")
        (d / "38_META_VERIFY.sql").write_text("\n".join(vf) + "\n", encoding="utf-8")
        (d / "39_META_ROLLBACK.sql").write_text("\n".join(rb) + "\n", encoding="utf-8")
    (OUT / "PLAN.json").write_text(json.dumps(P, ensure_ascii=False, indent=1), encoding="utf-8")
    print({k: len(v) for k, v in P.items()}, "targets", sum(len(v) for v in P.values()), "apis", sum(len(i["apis"]) for v in P.values() for i in v))


def statements(sql):
    body = "\n".join(l for l in sql.splitlines() if not l.strip().startswith(("--", "SET ")))
    return [s.strip() for s in re.split(r";\s*\n", body) if s.strip() and s.strip().upper() != "COMMIT"]


def log(line):
    print(line)
    with LOG.open("a", encoding="utf-8") as f:
        f.write(line + "\n")


def verify(cur, L, write=True):
    P = plan(L)
    rows = ["| PKG | 원 SP | API | API_URL | PROC_M(new/standalone) | 멤버 인자 | IN/OUT 일치 | PR_GET_PROC_INFO_LIST 해석 |", "|---|---|---|---|---|---|---|---|"]
    bad = 0
    for pkg, items in sorted(P.items()):
        for it in items:
            cur.execute("SELECT API_ID, API_URL FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN (" + ",".join(q(a) for a in it["apis"]) + ")")
            urls = dict(cur.fetchall())
            cur.execute("SELECT COL_TP_CD FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", p=it["qual"]); new = [r[0] for r in cur.fetchall()]
            cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE UPPER(PROC_NM)=:p", p=it["sp"].upper()); old = cur.fetchone()[0]
            cur.execute("SELECT IN_OUT FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME=:k AND OBJECT_NAME=:m AND DATA_LEVEL=0 ORDER BY POSITION", k=pkg, m=it["member"])
            args = [r[0].replace("IN/OUT", "INOUT") for r in cur.fetchall()]
            inout_ok = new == args
            # BE 경로 모사 — 메뉴 버튼별 PR_GET_PROC_INFO_LIST
            res = []
            for b in it["btn"]:
                rc = cur.var(oracledb.DB_TYPE_CURSOR)
                cur.callproc("SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST", [b["mnu"], b["sht"], b["btn"], rc])
                got = rc.getvalue().fetchall()
                res.append(f"{b['mnu']}/{b['sht']}/{b['btn']}→{got[0][0] if got else '-'}({len(got)})")
            ok = all(u == it["qual"] for u in urls.values()) and len(urls) == len(it["apis"]) and len(new) == old and inout_ok and all(it["qual"] in r for r in res)
            bad += not ok
            rows.append(f"| {pkg} | {it['sp']} | {', '.join(it['apis'])} | {'OK' if all(u == it['qual'] for u in urls.values()) else urls} | {len(new)}/{old} | {len(args)} | {inout_ok} | {'; '.join(res)} |")
    if write:
        (OUT / "VERIFY.md").write_text(f"# STEP 3 META VERIFY ({datetime.datetime.now():%Y-%m-%d %H:%M:%S})\n\n" + "\n".join(rows) + f"\n\n불일치 {bad}건\n", encoding="utf-8")
    return bad, rows


def main():
    mode = sys.argv[1]
    L = json.loads((ROOT / "LEDGER.json").read_text(encoding="utf-8"))
    OUT.mkdir(exist_ok=True)
    if mode == "build":
        build(L); return
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    if mode == "apply":
        log(f"\n## {datetime.datetime.now():%Y-%m-%d %H:%M:%S} META 전환 사내 적용")
        # 선행 게이트: 전 멤버 존재·PKG VALID
        for pkg, items in sorted(plan(L).items()):
            cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:p AND OBJECT_TYPE='PACKAGE BODY'", p=pkg)
            assert (cur.fetchone() or ["-"])[0] == "VALID", pkg
            for it in items:
                cur.execute("SELECT COUNT(*) FROM ALL_PROCEDURES WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:p AND PROCEDURE_NAME=:m", p=pkg, m=it["member"])
                assert cur.fetchone()[0] == 1, it["qual"]
        try:
            for f in sorted(OUT.glob("PKG_*/30_META_SWITCH.sql")):
                n = 0
                for s in statements(f.read_text(encoding="utf-8")):
                    cur.execute(s); n += cur.rowcount
                log(f"- {f.parent.name}: 문장 실행 · 영향 {n}행")
            bad, _ = verify(cur, L, write=False)
            if bad:
                con.rollback(); log(f"- ❌ 검증 불일치 {bad} → ROLLBACK"); sys.exit(2)
            con.commit(); log("- COMMIT")
        except Exception as ex:
            con.rollback(); log(f"- ❌ {ex} → ROLLBACK"); raise
    if mode in ("apply", "verify"):
        bad, rows = verify(cur, L)
        print("\n".join(rows[:3])); print("불일치", bad)


if __name__ == "__main__":
    main()
