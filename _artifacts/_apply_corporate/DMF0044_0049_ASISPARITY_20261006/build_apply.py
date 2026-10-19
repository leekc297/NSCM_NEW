"""[E20261006-ASISPARITY] PKG_DMF0044 / PKG_DMF0049 — AS-IS 운영 실제 동작 일치 (개발본 잔존 제거)

근거: asis_delta_20261002 시트 `14_대상_대상제외_확정` "DMF0044 개발본 잔존"(4블록) · "DMF0049 개발본 잔존"(2블록) = 대상.
  TO-BE 전환 원본이 AS-IS 개발본(2026-02)이라 운영(DMF0044 2025-05-20 · DMF0049 2025-07-23 수정본)에 없는
  개발 SR [E20260107-001542] 로직이 실행 코드로 남아 있다. 운영 원문에는 주석으로도 없다(전문 확인).

  PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE
    #002·#003  DEPT_NAME 검증 문구 2곳  'DEPT_NAME 정보가 …' → 'TEAM정보가 존재하지 않아 저장할 수 없습니다.' (운영 L417·L423)
    #001·#004  DEPARTMENT_NAME IS NULL 검증 + 오류 처리 9줄 비활성 (운영에 없음)
  PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C
    #007·#009  구코드 COMPANY_ID 검증(NERP_CONV_MASTER) + INVALID 반환 11줄 비활성 (운영에 없음)

방식: 지금 DB 원문(ALL_SOURCE) 위의 외과적 변경 — 비활성은 줄 주석(원문 보존), 문구는 2줄 치환. 원복 = 99_ROLLBACK_apply.py.
  python build_apply.py build    # 00_BACKUP / 01_ SQL 생성만 (DB 변경 없음)
  python build_apply.py apply    # FRESH-GATE 후 적용 + 검증
"""
import sys, os, hashlib, json, datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
TYP = "PACKAGE BODY"
PKGS = ("PKG_DMF0044", "PKG_DMF0049")
MARK = "[E20261006-ASISPARITY]"
WHY = "AS-IS 운영 일치 — 운영 미배포 개발 SR [E20260107-001542] 잔존"
OFF = "--" + MARK + " "                      # 비활성 줄 접두 (원복 = 접두 제거)
MSG_OLD = "'DEPT_NAME 정보가 존재하지 않아 저장할 수 없습니다.'"
MSG_NEW = "'TEAM정보가 존재하지 않아 저장할 수 없습니다.'"
NOTE44_MSG = "    -- " + MARK + " 문구 = AS-IS 운영 [E20250401-000548] (TO-BE 전환 원본 개발본 문구 'DEPT_NAME 정보가 …' 교체)"
NOTE44_OFF = "    -- " + MARK + " DEPARTMENT_NAME 검증 비활성 — " + WHY
NOTE49_OFF = "    -- " + MARK + " 구코드 COMPANY_ID 검증 비활성 — " + WHY
ADDED = {"PKG_DMF0044": 2, "PKG_DMF0049": 1}   # 추가 줄 수 (설명 주석)
MARKS = {"PKG_DMF0044": 2 + 9, "PKG_DMF0049": 1 + 11}


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur, pkg):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=pkg, t=TYP)
    ddl, status = cur.fetchone()
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=pkg, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "status": status, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def one(lines, lo, hi, pred, what):
    hit = [i for i in range(lo, hi) if pred(lines[i])]
    assert len(hit) == 1, f"{what}: 매칭 {len(hit)}건 (1건이어야 함) — 원문이 바뀌었거나 이미 반영됨"
    return hit[0]


def member(lines, name):
    lo = one(lines, 0, len(lines), lambda l: l.strip().startswith("PROCEDURE " + name), name + " 시작")
    hi = one(lines, lo, len(lines), lambda l: l.strip() == "END " + name + ";", name + " 끝")
    return lo, hi


def off(lines, a, b):
    for i in range(a, b + 1):
        assert MARK not in lines[i] and lines[i].strip() and not lines[i].lstrip().startswith("--"), lines[i]
        lines[i] = OFF + lines[i]


def transform44(src):
    assert MARK not in src, "이미 반영됨"
    lines = src.split("\n")
    lo, hi = member(lines, "P_DMF0044_MOBILE_REPORT_CREATE")
    # ── DEPT_NAME 검증 문구 2곳 (검증·로그유형은 운영과 같으므로 유지)
    m = [i for i in range(lo, hi) if MSG_OLD in lines[i]]
    assert len(m) == 2 and src.count(MSG_OLD) == 2, (m, src.count(MSG_OLD))
    assert lines[m[0]].strip().startswith("V_LOG_TYPE := 'DEPT_NAME INVALID'; V_LOG_MESSAGE := " + MSG_OLD)
    assert lines[m[1]].strip() == "OPEN O_RESULT_CURSOR FOR SELECT " + MSG_OLD + " AS MSG FROM DUAL;"
    if0 = m[0] - 1
    assert lines[if0].strip() == "IF v_chk > 0 THEN" and lines[if0 - 1].strip().endswith("AND DEPT_NAME IS NULL;")
    # ── DEPARTMENT_NAME 검증 블록 9줄 (SELECT 2 + IF … END IF 7)
    a = one(lines, lo, hi, lambda l: l.strip().endswith("AND DEPARTMENT_NAME IS NULL;"), "DEPARTMENT_NAME 검증") - 1
    assert lines[a].strip() == "SELECT COUNT(1) INTO v_chk FROM DM_PLN_SALES_ETC_REPORT_C"
    b = a + 8
    assert lines[a + 2].strip() == "IF v_chk > 0 THEN" and "'DEPARTMENT_NAME INVALID'" in lines[a + 3]
    assert lines[b - 1].strip() == "RETURN;" and lines[b].strip() == "END IF;" and lines[b + 1].strip() == ""
    assert m[1] < a and lines[b + 2].strip().startswith("-- [E20250418-001567] 중복 검증")
    for i in m:
        lines[i] = lines[i].replace(MSG_OLD, MSG_NEW)
    off(lines, a, b)
    lines.insert(a, NOTE44_OFF)       # 뒤에서부터 삽입 (앞 인덱스 보존)
    lines.insert(if0 - 1, NOTE44_MSG)
    return "\n".join(lines)


def transform49(src):
    assert MARK not in src, "이미 반영됨"
    lines = src.split("\n")
    lo, hi = member(lines, "P_DMF0049_SAVE_SALES_ETC_REPORT_C")
    h = one(lines, lo, hi, lambda l: l.strip() == "-- [E20260107-001542]_DM_COMPANY 룩업코드 검증 (구코드 COMPANY_ID 저장 불가)", "COMPANY_ID 검증 머리 주석")
    a, b = h + 2, h + 12
    assert lines[a].strip() == "SELECT COUNT(*) INTO v_chk FROM SCM_MGR.GT_DMF0049_RESULTS_MST R"
    assert "NERP_CONV_MASTER" in lines[a + 1] and lines[a + 2].strip() == "AND ROWNUM = 1;"
    assert lines[a + 3].strip() == "IF v_chk > 0 THEN" and lines[a + 4].strip() == "ROLLBACK;"
    assert lines[b - 1].strip() == "RETURN;" and lines[b].strip() == "END IF;" and lines[b + 1].strip() == ""
    assert src.count("NERP_CONV_MASTER") == 1 and src.count("구코드 COMPANY_ID는 저장할 수 없습니다.") == 2
    off(lines, a, b)
    lines.insert(a, NOTE49_OFF)
    return "\n".join(lines)


TRANSFORM = {"PKG_DMF0044": transform44, "PKG_DMF0049": transform49}


def check(pkg, src, new):
    assert new.count(MARK) == MARKS[pkg], (pkg, new.count(MARK))
    assert len(new.split("\n")) == len(src.split("\n")) + ADDED[pkg]
    # 변경 외 줄은 한 글자도 다르지 않아야 한다 — 표식 줄 제거·문구 원복 후 원문과 동일
    assert restore(new) == src, pkg + ": 변경분 제거 후 원문 불일치"


def restore(new):
    """삽입·비활성·문구 변경을 걷어낸 원문 (원복 스크립트와 build 자체 검증이 같이 쓴다)"""
    out = []
    for l in new.split("\n"):
        if l.startswith("    -- " + MARK):
            continue
        out.append(l[len(OFF):] if l.startswith(OFF) else l)
    return "\n".join(out).replace(MSG_NEW, MSG_OLD)


def stamp(pkg, base):
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    return f"-- SOURCE-FRESH: SCM_MGR.{pkg} {TYP} LAST_DDL={base['last_ddl']} FETCHED={now} DB=ZIOUI1\n"


def build(cur, write_backup=False):
    res = {}
    for pkg in PKGS:
        base = read_source(cur, pkg)
        new = TRANSFORM[pkg](base["src"])
        check(pkg, base["src"], new)
        if write_backup:
            with open(os.path.join(HERE, f"00_BACKUP_{pkg}_BODY.sql"), "w", encoding="utf-8", newline="\n") as f:
                f.write(stamp(pkg, base) + "-- 적용 전 원문 (조회 전용 백업)\n" + ddl_text(base["src"]) + "/\n")
            with open(os.path.join(HERE, f"_base_{pkg}.txt"), "w", encoding="utf-8", newline="\n") as f:
                f.write(base["src"])
        with open(os.path.join(HERE, f"01_{pkg}_BODY.sql"), "w", encoding="utf-8", newline="\n") as f:
            f.write(stamp(pkg, base) + "-- " + MARK + " " + WHY + "\n" + ddl_text(new) + "/\n")
        print("BUILD", pkg, "base", base["last_ddl"], base["md5"], f"→ +{ADDED[pkg]} lines")
        res[pkg] = (base, new)
    if write_backup:
        json.dump({p: {k: res[p][0][k] for k in ("last_ddl", "status", "md5")} for p in PKGS},
                  open(os.path.join(HERE, "_fresh_state.json"), "w"), indent=1)
    return res


def apply():
    with connect() as con:
        cur = con.cursor()
        res = build(cur)
        saved = json.load(open(os.path.join(HERE, "_fresh_state.json")))
        out = {}
        for pkg in PKGS:
            base, new = res[pkg]
            if saved[pkg]["md5"] != base["md5"]:
                sys.exit(f"ABORT {pkg}: 착수 시 백업본과 현재 DB 원문이 다름 — 재조회·재검토 필요")
        for pkg in PKGS:
            base, new = res[pkg]
            # FRESH-GATE: 적용 직전 DB 원문 재조회 == 방금 읽은 기준본
            now = read_source(cur, pkg)
            if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
                sys.exit(f"FRESH-GATE FAIL {pkg}: 착수 후 DB 원문 변경 — 중단")
            print("FRESH-GATE PASS", pkg, now["last_ddl"], now["md5"])
            cur.execute(ddl_text(new).rstrip())
            after = read_source(cur, pkg)
            cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=pkg)
            errs = cur.fetchone()[0]
            same = after["src"].rstrip() == new.rstrip()
            print("AFTER", pkg, after["last_ddl"], after["status"], "errors", errs, "same_as_built", same)
            out[pkg] = {"before": {k: base[k] for k in ("last_ddl", "md5")},
                        "after": {k: after[k] for k in ("last_ddl", "status", "md5")}, "errors": errs, "same_as_built": same}
        cur.execute("SELECT object_name, object_type FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID' "
                    "AND object_name IN ('PKG_DMF0044','PKG_DMF0049') "
                    "UNION SELECT name, type FROM all_dependencies d WHERE referenced_owner='SCM_MGR' AND referenced_name IN ('PKG_DMF0044','PKG_DMF0049') "
                    "AND EXISTS (SELECT 1 FROM all_objects o WHERE o.owner=d.owner AND o.object_name=d.name AND o.object_type=d.type AND o.status='INVALID')")
        out["invalid"] = cur.fetchall()
        print("INVALID (본체·의존)", out["invalid"])
        json.dump(out, open(os.path.join(HERE, "_apply_result.json"), "w"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    if sys.argv[1:] == ["apply"]:
        apply()
    else:
        with connect() as con:
            build(con.cursor(), write_backup=(sys.argv[1:] == ["build", "--backup"]))
