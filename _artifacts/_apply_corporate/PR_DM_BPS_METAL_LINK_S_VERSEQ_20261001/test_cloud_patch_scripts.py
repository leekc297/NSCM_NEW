"""클라우드 패키지 01_PATCH / 99_ROLLBACK 자가치환 스크립트를 사내 실제 프로시저로 검증 (최종 상태 = 패치 적용)
순서: 00_BACKUP(원래 식) 복원 → 01 패치 → 01 재실행(ALREADY) → 99 원복 → 99 재실행(NOTHING) → 01 패치 → 상태·줄·md5 확인
"""
import sys, os, re, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = r"C:\Projects\NSCM\_artifacts\_deploy_packages\PR_DM_BPS_METAL_LINK_S_VERSEQ_CLOUD_20261001\A_DB"
NAME = "PR_DM_BPS_METAL_LINK_S"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 600000
cur = con.cursor()
cur.callproc("DBMS_OUTPUT.ENABLE", [None])


def src():
    cur.execute("SELECT text FROM user_source WHERE name=:n AND type='PROCEDURE' ORDER BY line", n=NAME)
    return "".join(r[0] for r in cur)


def state(tag):
    s = src()
    cur.execute("SELECT status FROM user_objects WHERE object_name=:n", n=NAME)
    st = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM user_errors WHERE name=:n", n=NAME)
    er = cur.fetchone()[0]
    line = [l.strip() for l in s.splitlines() if "VERSION_NO_T ||" in l]
    print(f"[{tag}] {st} errors={er} md5={hashlib.md5(s.encode()).hexdigest()[:10]} :: {line}", flush=True)
    return s, st, er


def out():
    lines = []
    v, st = cur.var(str), cur.var(int)
    while True:
        cur.callproc("DBMS_OUTPUT.GET_LINE", (v, st))
        if st.getvalue() != 0:
            break
        lines.append(v.getvalue())
    return lines


def run_block(fname):
    txt = open(os.path.join(PKG, fname), encoding="utf-8").read()
    m = re.search(r"^DECLARE.*?^END;\s*$", txt, re.S | re.M)
    cur.execute(m.group(0))
    print(f"  {fname}: {out()}", flush=True)


orig_text = open(os.path.join(HERE, f"00_BACKUP_{NAME}.sql"), encoding="utf-8").read()
orig = "\n".join(l for l in orig_text.split("\n") if not l.startswith("-- SOURCE-FRESH:")).rstrip()
orig = orig[:-1].rstrip() if orig.endswith("/") else orig
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
cur.execute(orig)
s0, _, _ = state("restored-original")
backup_md5 = hashlib.md5(s0.encode()).hexdigest()

run_block("01_PATCH_PR_DM_BPS_METAL_LINK_S.sql"); s1, st1, e1 = state("patched")
run_block("01_PATCH_PR_DM_BPS_METAL_LINK_S.sql"); state("patch-again")
run_block("99_ROLLBACK_PR_DM_BPS_METAL_LINK_S.sql"); s2, _, _ = state("rolled-back")
run_block("99_ROLLBACK_PR_DM_BPS_METAL_LINK_S.sql"); state("rollback-again")
run_block("01_PATCH_PR_DM_BPS_METAL_LINK_S.sql"); s3, st3, e3 = state("final-patched")

ok = (hashlib.md5(s2.encode()).hexdigest() == backup_md5 and s1 == s3 and st3 == "VALID" and e3 == 0
      and "TO_CHAR(Y.VERSION_SEQ, 'FM00')" in s3 and s3.count("[E20261001-VERSEQ2D]") == 1)
print("RESULT", "PASS" if ok else "FAIL", "| rollback==original:", hashlib.md5(s2.encode()).hexdigest() == backup_md5)
