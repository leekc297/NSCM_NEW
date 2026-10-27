"""[E20261021-DMF0020SAVECLOB] 사내 ZIOUI1 리허설 실행기 — A_DB/*.sql 을 SQL Developer 대신 그대로 실행(SET 줄 제거 · 블록은 '/' 단위 · SELECT 는 ';' 단위)
순서(기본): 00 → 10 → [DB == 시뮬레이터 적용본] → 90 → 99 → [DB == 수정 전] → 00 → 10 → [DB == 적용본] → 90   (최종 상태 = 적용)
사용: python run_rehearsal.py            전 과정
      python run_rehearsal.py 10 90      지정 스크립트만
FRESH-GATE: 각 단계 뒤 ALL_SOURCE 를 새로 읽어 md5 를 _build_meta.json 과 대조한다.
"""
import sys, os, re, json, hashlib, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
A_DB = os.path.join(HERE, "A_DB")
OUTD = os.path.join(HERE, "_rehearsal_out")
META = json.load(open(os.path.join(HERE, "_build_meta.json"), encoding="utf-8"))
FILES = {"00": "00_PRECHECK_CLOUD.sql", "10": "10_APPLY_SAVECLOB_PATCH.sql", "90": "90_VERIFY.sql", "99": "99_ROLLBACK_SAVECLOB_PATCH.sql"}
seq = 0


def md5_src(cur, typ):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0020' AND TYPE=:t ORDER BY LINE", t=typ)
    return hashlib.md5("".join(r[0] for r in cur.fetchall()).replace("\r\n", "\n").encode()).hexdigest()


def run_script(con, key):
    global seq
    seq += 1
    cur = con.cursor(); cur.callproc("DBMS_OUTPUT.ENABLE", [None])
    text = open(os.path.join(A_DB, FILES[key]), encoding="utf-8").read().replace("\r", "")
    lines = text.split("\n"); i = 0; log = [f"=== {FILES[key]} {datetime.datetime.now():%Y-%m-%d %H:%M:%S} ==="]
    while i < len(lines):
        ln = lines[i]
        if not ln.strip() or re.match(r"^(SET|COLUMN|PROMPT)\b", ln, re.I) or (ln.lstrip().startswith("--")):
            i += 1; continue
        if re.match(r"^(DECLARE|BEGIN)\b", ln):
            j = i
            while lines[j].strip() != "/": j += 1
            block = "\n".join(lines[i:j]); i = j + 1
            try:
                cur.execute(block); log.append("BLOCK OK")
            except Exception as e:
                log.append("BLOCK ERROR: " + str(e).splitlines()[0])
            o = cur.var(str); st = cur.var(int)
            while True:
                cur.callproc("DBMS_OUTPUT.GET_LINE", (o, st))
                if st.getvalue() != 0: break
                log.append("  " + (o.getvalue() or ""))
            continue
        j = i
        while not lines[j].rstrip().endswith(";"): j += 1
        stmt = "\n".join(lines[i:j + 1]).rstrip().rstrip(";"); i = j + 1
        try:
            cur.execute(stmt); cols = [c[0] for c in cur.description]; rows = cur.fetchall()
            log.append("  " + " | ".join(cols))
            for r in rows: log.append("  " + " | ".join("" if v is None else str(v) for v in r))
            log.append(f"  ({len(rows)} rows)")
        except Exception as e:
            log.append("STMT ERROR: " + str(e).splitlines()[0] + " :: " + stmt[:120].replace("\n", " "))
    con.commit()
    body = "\n".join(log) + "\n"; print(body)
    open(os.path.join(OUTD, f"{seq:02d}_{FILES[key].replace('.sql', '')}.out.txt"), "w", encoding="utf-8").write(body)


def gate(cur, which):
    got = {"spec": md5_src(cur, "PACKAGE"), "body": md5_src(cur, "PACKAGE BODY")}
    exp = META["md5_tobe" if which == "tobe" else "md5_pre"]
    ok = got == exp
    print(f"[GATE] DB == {which}: {'PASS' if ok else 'FAIL'} got={got} exp={exp}")
    assert ok, f"GATE FAIL ({which})"


def main():
    os.makedirs(OUTD, exist_ok=True)
    u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME'), USER FROM DUAL"); assert cur.fetchone() == ("ZIOUI1", "SCM_MGR")
    steps = sys.argv[1:] or ["00", "10", "=tobe", "90", "99", "=pre", "00", "10", "=tobe", "90"]
    for s in steps:
        if s.startswith("="): gate(cur, s[1:])
        else: run_script(con, s)


if __name__ == "__main__":
    main()
