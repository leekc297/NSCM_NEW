"""BPS 인터페이스 배치(JOB_PR_DM_BPS_INTERFACE) — 메탈링크 I/F 팀(DEPT) = SSPM(SCM_MST_SITE_ITEM.DEPT_ID) (사내 ZIOUI1)

사용자 지시(2026-10-02): "TO-BE 에서는 OWNER 조인이 아닌 SSPM 에서 DEPT 를 추출해서 사용하는 것으로 변경되어야 합니다.
  이부분을 AS-IS 에 맞도록 각 BATCH JOB 에 보완 적용해주세요."
  + "AS-IS 의 OWNER JOIN 해서 DEPT 가져오던 부분을 SSPM 의 DEPT_ID 를 가져오는 것으로 전환하라는 이야기"

AS-IS (LGCE_SCMDEV dbo.PR_DM_BPS_METAL_LINK_S, [PJ2024-50461] 2024.09.12):
  업로드는 DEPT_ID 공백 저장 → I/F 시점에 SCM_MST_SITE_ITEM.OWNER 첫 사용자 → SSO_USER_INFO.DEPT_ID 로 팀 산출 (_C.DEPT_ID 미사용).
TO-BE 현재: PR_DM_BPS_METAL_LINK_S 가 컷오프(_C) 의 A.DEPT_ID 를 그대로 전송 → 원장이 '-' 이면 '-' / 부서명 NULL 전송.

배치 잡 내 SP 4본 점검 결과 (2026-10-02 ALL_SOURCE 실측):
  PR_DM_METAL_LINK_CUTOFF     : 원장 → _C 복사만 (AS-IS 동일) — 변경 없음
  PR_DM_BPS_SALES_PLAN_S      : 이미 D.DEPT_ID (2026.09.03/09.06 AJS) — 변경 없음
  PR_DM_BPS_SALES_ETC_PLAN_S  : 이미 D.DEPT_ID (2026.09.03/09.06 AJS) — 변경 없음
  PR_DM_BPS_METAL_LINK_S      : ★ 본 건 대상

변경 [E20261002-IFDEPTSSPM] — PR_DM_BPS_METAL_LINK_S 한정 (기존 SCM_MST_SITE_ITEM D 외부조인 재사용 — PK 4키 1:1, 행 수 불변)
  1) T1.DEPT_ID      : A.DEPT_ID(_C) → D.DEPT_ID(SSPM)
  2) 부서명 조인      : A.DEPT_ID = DEPT.DEPT_ID(+) → D.DEPT_ID = DEPT.DEPT_ID(+)
  SSPM 미등록·DEPT_ID NULL 모델은 NULL 전송 (AS-IS 의 OWNER 미매칭과 동일 · PR_DM_BPS_SALES_PLAN_S 와 동일).

사용:
  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01 생성 (치환 지점 개수 assert)
  python build_apply.py apply   # FRESH-GATE 통과 시 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OBJ = "PR_DM_BPS_METAL_LINK_S"
TYP = "PROCEDURE"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261002-IFDEPTSSPM]"
F_BACKUP = os.path.join(HERE, "00_BACKUP_PR_DM_BPS_METAL_LINK_S.sql")
F_TOBE = os.path.join(HERE, "01_PR_DM_BPS_METAL_LINK_S.sql")


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=OBJ, t=TYP)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=OBJ, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def rep1(src, old, new, what):
    n = src.count(old)
    if n != 1:
        sys.exit(f"ABORT: {what} 일치 {n}회 (1회여야 함) — 원문이 바뀌었거나 이미 반영됨")
    return src.replace(old, new)


def transform(src):
    if MARK in src:
        sys.exit(f"ABORT: {MARK} 이미 존재 — 재적용 불필요")
    if "\r" in src:
        sys.exit("ABORT: 원문에 CR 포함 — 치환 패턴 재확인 필요")

    # 0) Program History 1줄
    src = rep1(src,
               " * 2026.07.06\tZIONEX\t\t[PJ202650304] NextSCM Migration\n",
               " * 2026.07.06\tZIONEX\t\t[PJ202650304] NextSCM Migration\n"
               f" * 2026.10.02\tZIONEX\t\t{MARK} 팀(DEPT) = SSPM(SCM_MST_SITE_ITEM.DEPT_ID) — AS-IS Owner 팀 산출 자리, 컷오프(_C) DEPT_ID 미사용\n",
               "Program History")

    # 1) T1.DEPT_ID : 컷오프(_C) A.DEPT_ID → SSPM D.DEPT_ID
    src = rep1(src,
               "                     , A.DEPT_ID /* 부서ID */\n",
               f"                     , D.DEPT_ID /* 부서ID */ /*{MARK} A.DEPT_ID(_C) → SSPM(SCM_MST_SITE_ITEM.DEPT_ID). AS-IS = TEAM.DEPT_ID(Owner 팀) 자리*/\n",
               "T1 DEPT_ID")

    # 2) 부서명 조인 키 : A.DEPT_ID → D.DEPT_ID
    src = rep1(src,
               "                   AND A.DEPT_ID = DEPT.DEPT_ID(+)\n",
               f"                   AND D.DEPT_ID = DEPT.DEPT_ID(+) /*{MARK} 부서명도 SSPM DEPT_ID 기준*/\n",
               "DEPT name join")
    return src


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        fetched = cur.fetchone()[0]
    src = s["src"]
    new = transform(src)
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{OBJ} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(F_BACKUP, "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(src) + "/\n")
    open(F_TOBE, "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched}, open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, s["last_ddl"], s["md5"], "lines", src.count("\n"), "->", new.count("\n"),
          "marker", new.count(MARK))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS")
        tobe = strip(open(F_TOBE, encoding="utf-8").read())
        cur.execute(tobe)
        print("APPLIED", os.path.basename(F_TOBE))
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=OBJ)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=OBJ)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)
        after = read_source(cur)
        applied = tobe[len("CREATE OR REPLACE "):]
        print("DB==TOBE", after["src"].rstrip() == applied.rstrip(), "marker", after["src"].count(MARK))
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        print("SCM_MGR INVALID objects", cur.fetchone()[0])
        cur.execute("SELECT job_name, enabled, state FROM user_scheduler_jobs WHERE job_name='JOB_PR_DM_BPS_INTERFACE'")
        for r in cur:
            print("  JOB", r)


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
