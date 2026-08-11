#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""authunion_coverage_scan.py — 권한그룹 판정 '합집합(AUTHUNION)' 적용 현황 전수 스캔 (2026-08-09, 읽기 전용)

⚠️ 왜 마커 검색이면 안 되는가 (2026-08-09 실측):
    `INSTR(TEXT,'AUTHUNION')` 로 세면 **PKG_DMF0003 이 미적용으로 잡힌다**. 실제로는 L5911~5912 에
    동일한 합집합 조건이 들어가 있고 주석 문구만 다르다(v2 별형). 마커는 '표식'이지 '구현'이 아니다.
    → 본 스캐너는 **조건식 형태**로 판정한다.

판정 (GET_ADMIN_GROUP 참조 지점마다, 앞뒤 창 안에서):
  UNION  : 보유그룹 서브쿼리(SCM_ADM_USER_GR_MPG_M + USER_GR_ID)가 같이 있다 → 합집합 판정
  SINGLE : `SEGMENT1 = <단일값>` 만 있다 → 단일그룹 판정 (미적용)
  OTHER  : 위 어느 쪽도 아님 (단순 참조·주석 등) — 판정 대상 아님, 건수만 보고

FE 축 (발현 여부):
  화면 store 가 P_USER_GROUP 자리에 무엇을 넘기는지 분류한다.
    USERID   : `userGroup: sesUserId` 류 — **단일그룹이면 항상 탈락** (최우선 발현 지점)
    AUTHCMBO : `authGroup || sesUserId` — CMBO 해석값 우선(폴백만 USER_ID)
    EMPTY/기타
"""
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
FE_PAGES = ROOT / "nscm-fe" / "features"

WINDOW = 25  # GET_ADMIN_GROUP 라인 기준 앞뒤 탐색 창(라인)

RE_HELD_GROUP = re.compile(r"SCM_ADM_USER_GR_MPG_M", re.I)
RE_SEGMENT1_EQ = re.compile(r"SEGMENT1\s*=", re.I)


def strip_sql_comment(line: str) -> str:
    """줄 끝 `--` 주석 제거.

    ⚠️ 2026-08-09 실측 — 줄 **시작** 주석만 걸렀더니 PKG_DMF0082 L7691 이
      `... -- 필요시 GET_ADMIN_GROUP_MEASURE 에도 넣어야 한다` 라는 **꼬리 주석** 때문에
      판정 지점으로 잡혀 '단일그룹 잔여'로 오탐났다. 주석은 코드가 아니다.
    """
    q = None
    for i, c in enumerate(line):
        if q:
            if c == q:
                q = None
            continue
        if c == "'":
            q = c
            continue
        if c == "-" and i + 1 < len(line) and line[i + 1] == "-":
            return line[:i]
    return line


def classify_object(raw_lines):
    """[(line_no, verdict)] — GET_ADMIN_GROUP 참조 지점별 판정 (주석 제거 후)."""
    lines = [strip_sql_comment(x) for x in raw_lines]
    out = []
    n = len(lines)
    for i, txt in enumerate(lines):
        if "GET_ADMIN_GROUP" not in txt.upper():
            continue
        lo, hi = max(0, i - WINDOW), min(n, i + WINDOW + 1)
        win = "\n".join(lines[lo:hi])
        if RE_HELD_GROUP.search(win):
            out.append((i + 1, "UNION"))
        elif RE_SEGMENT1_EQ.search(win):
            out.append((i + 1, "SINGLE"))
        else:
            out.append((i + 1, "OTHER"))
    return out


def scan_db():
    import oracledb

    u, p, d = conn_info()
    res = {}
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT DISTINCT NAME, TYPE FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND UPPER(TEXT) LIKE '%GET_ADMIN_GROUP%'
                ORDER BY 1"""
        )
        objs = cur.fetchall()
        for name, typ in objs:
            cur.execute(
                """SELECT TEXT FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE""",
                {"n": name, "t": typ},
            )
            lines = [r[0].rstrip("\n") for r in cur.fetchall()]
            res[name] = classify_object(lines)
    return res


RE_MENU_ID = re.compile(r"export\s+const\s+MENU_ID\s*=\s*'([A-Z]{2,4}\d{4})'")
# ⚠️ 2026-08-09 — `userGroup: sesUserId`(객체 프로퍼티) 만 보면 **`const userGroup = sesUserId`(변수 대입)를 놓친다**.
#   실측: DMF0049(etc-sales-reports:127)가 이 형태라 1차 스캔에서 '기타'로 빠졌다. 둘 다 잡는다.
# ⚠️ 2026-08-09 (2차 정정) — 키 이름을 `userGroup` 으로 고정하면 **`userinfo` 를 쓰는 화면을 놓친다**.
#   실측: DMF0048(sales-monitoring)이 `const userinfo = session.groupId || sesUserId` 형태였다.
#   권한그룹 파라미터의 실제 이름은 PROC_M COL_NM 기준 5형이다:
#     userGroup / userinfo / userInfo / P_USERINFO / groupId
#   (`groupId` 키를 쓰는 PKG_DMF0022/0035/SYS0008/SYS0013 은 GET_ADMIN_GROUP 자체를 참조하지 않아 대상 밖)
_UG = r"(?:userGroup|userinfo|userInfo|authGroup|P_USERINFO)"
RE_UG_USERID = re.compile(r"\b%s\b\s*[:=]\s*sesUserId\b" % _UG)
# `session.groupId || sesUserId` = groupId 가 유령 필드라 **사실상 USER_ID 직전달**과 동일하다.
RE_UG_GHOST = re.compile(r"\b%s\b\s*=\s*[^;\n]*session\.groupId\s*\|\|" % _UG)
RE_UG_AUTHCMBO = re.compile(r"\b%s\b\s*=\s*get\(\)\.authGroup\s*\|\|" % _UG)
RE_UG_ANY = re.compile(r"\b%s\b\s*[:=]" % _UG)


def scan_fe():
    """{MENU_ID: (분류, 근거파일:라인)}"""
    out = {}
    for const in FE_PAGES.rglob("*.constants.ts"):
        m = RE_MENU_ID.search(const.read_text(encoding="utf-8", errors="ignore"))
        if not m:
            continue
        menu, folder = m.group(1), const.parent
        kind, ev = None, ""
        for f in list(folder.rglob("*.ts")) + list(folder.rglob("*.tsx")):
            text = f.read_text(encoding="utf-8", errors="ignore")
            rel = f.relative_to(FE_PAGES).as_posix()
            # 위험도 순 — USERID(항상 탈락) > GHOST(유령필드라 사실상 USER_ID) > AUTHCMBO(CMBO 우선)
            for rx, k in ((RE_UG_USERID, "USERID"), (RE_UG_GHOST, "GHOST"), (RE_UG_AUTHCMBO, "AUTHCMBO")):
                mm = rx.search(text)
                if mm and (kind is None or k in ("USERID", "GHOST")):
                    kind = k
                    ev = "%s:%d" % (rel, text.count("\n", 0, mm.start()) + 1)
            if kind is None and RE_UG_ANY.search(text):
                mm = RE_UG_ANY.search(text)
                kind, ev = "기타", "%s:%d" % (rel, text.count("\n", 0, mm.start()) + 1)
        if kind:
            out[menu] = (kind, ev)
    return out


def menu_of(objname):
    m = re.search(r"(DMF\d{4}|SCM\d{4}|COM\d{4}|SYS\d{4})", objname)
    return m.group(1) if m else None


def main():
    db = scan_db()
    fe = scan_fe()

    rows = []
    for name, hits in db.items():
        verdicts = [v for _, v in hits]
        n_single = verdicts.count("SINGLE")
        n_union = verdicts.count("UNION")
        n_other = verdicts.count("OTHER")
        if n_single == 0 and n_union == 0:
            state = "판정없음"
        elif n_single == 0:
            state = "적용"
        elif n_union == 0:
            state = "미적용"
        else:
            state = "혼재"
        mid = menu_of(name)
        fk, fev = fe.get(mid, ("-", ""))
        rows.append((state, name, n_union, n_single, n_other, mid or "-", fk, fev,
                     [ln for ln, v in hits if v == "SINGLE"][:4]))

    order = {"미적용": 0, "혼재": 1, "적용": 2, "판정없음": 3}
    risky = ("USERID", "GHOST")
    rows.sort(key=lambda r: (order[r[0]], 0 if r[6] in risky else 1, r[1]))

    print("# 권한그룹 판정 합집합(AUTHUNION) 적용 현황 — **조건식 형태 기준** (마커 아님)\n")
    print("> UNION=보유그룹 서브쿼리 동반 / SINGLE=`SEGMENT1 = 단일값` 만 / FE=P_USER_GROUP 자리 전달값\n")
    print("| 상태 | 객체 | UNION | SINGLE | 기타 | 화면 | FE 전달 | 근거 | SINGLE 라인 |")
    print("|---|---|---:|---:|---:|---|---|---|---|")
    for st, name, nu, ns, no, mid, fk, fev, slines in rows:
        mark = {"미적용": "⛔", "혼재": "⚠", "적용": "✅", "판정없음": "·"}[st]
        prio = " **최우선**" if st in ("미적용", "혼재") and fk in ("USERID", "GHOST") else ""
        print("| %s %s%s | %s | %d | %d | %d | %s | %s | %s | %s |"
              % (mark, st, prio, name, nu, ns, no, mid, fk, fev,
                 ", ".join("L%d" % x for x in slines) or "-"))

    tot = {}
    for st, *_ in rows:
        tot[st] = tot.get(st, 0) + 1
    print("\n## 종합: " + " / ".join("%s %d" % (k, v) for k, v in sorted(tot.items())))
    urgent = [r for r in rows if r[0] in ("미적용", "혼재") and r[6] in risky]
    print("\n## ⛔ 최우선 (단일그룹 × FE가 USER_ID 직전달 = **지금 발현**)")
    if urgent:
        for st, name, nu, ns, no, mid, fk, fev, slines in urgent:
            print("- **%s** (%s) — SINGLE %d곳 %s · FE `%s`"
                  % (name, mid, ns, ", ".join("L%d" % x for x in slines), fev))
    else:
        print("- 없음")


if __name__ == "__main__":
    main()
