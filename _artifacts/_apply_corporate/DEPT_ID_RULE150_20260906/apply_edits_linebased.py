# -*- coding: utf-8 -*-
"""hook#150 DEPT_ID 원천 단일화 — 라인 기반 편집 (원본 보존: 기존 라인 주석 처리 + 신규 라인 마커)"""
import pathlib, re, sys
S = pathlib.Path(__file__).parent
M = "-- [hook#150 2026-09-06 AJS] AS-IS: "
T = "-- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)"


def apply(name, ops):
    src = (S / f"{name}.sql").read_text(encoding="utf-8")
    lines = src.split("\n")
    pri = {"R": 0, "C": 1, "I": 2}
    for op in sorted(ops, key=lambda o: (-o[1], pri[o[0]])):
        k = op[0]
        if k == "R":
            _, n, old, new = op
            l = lines[n - 1]
            assert old in l, f"{name}:{n} expected [{old}] got [{l.strip()[:100]}]"
            lines[n - 1] = l.replace(old, new, 1)
        elif k == "C":
            _, a, b, tok = op
            assert tok in lines[a - 1], f"{name}:{a} expected token [{tok}] got [{lines[a-1].strip()[:100]}]"
            for i in range(a - 1, b):
                l = lines[i]
                ind = re.match(r"\s*", l).group(0)
                lines[i] = ind + M + l[len(ind):] if l.strip() else l
        elif k == "I":
            _, n, new = op
            lines[n:n] = new
    out = S / f"{name}.new.sql"
    out.write_text("\n".join(lines), encoding="utf-8")
    print(f"{name}: {len(ops)} ops -> {out.name} ({len(lines)} lines)")


# ---------------- DMF0020_GET_SCM_MST_FUTURE_PRICE (standalone) ----------------
apply("DMF0020_GET_SCM_MST_FUTURE_PRICE", [
    ("R", 706, ", SU.DEPT_ID", ", SI.DEPT_ID  " + T + " (AS-IS: SU.DEPT_ID)"),
    ("C", 708, 709, "LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO SU"),
    ("R", 1034, "T1.OWNER, T1.PARTIAL_PLAN_YN", "T1.OWNER, T1.PARTIAL_PLAN_YN, T1.DEPT_ID /* 2026-09-06 hook#150 AJS */"),
    ("C", 1043, 1048, "LEFT JOIN ("),
    ("I", 1048, ["        " + T,
                 "        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM",
                 "            ON TEAM.DEPT_ID = SITE_ITEM.DEPT_ID"]),
])

# ---------------- DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (standalone) ----------------
POP_TEAM_NEW = ["        " + T + " / TEAM,DEPRTMENT 조인을 SITE_ITEM 뒤로 이동",
                "        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM",
                "            ON SITE_ITEM.DEPT_ID = TEAM.DEPT_ID",
                "            AND TEAM.VALID_YN = 'Y'",
                "        LEFT JOIN SCM_MST_SSO_DEPT_INFO DEPRTMENT",
                "            ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID",
                "            AND DEPRTMENT.VALID_YN = 'Y'"]
SP_TEAM_NEW = ["            " + T,
               "            LEFT JOIN       SCM_MST_SSO_DEPT_INFO                            TEAM",
               "            ON              SITE_ITEM.DEPT_ID = TEAM.DEPT_ID"]
apply("DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP", [
    ("R", 297, ",SU.DEPT_ID", ",SI.DEPT_ID  " + T + " (AS-IS: SU.DEPT_ID)"),
    ("R", 309, "ON SU.DEPT_ID = TM.DEPT_ID", "ON SI.DEPT_ID = TM.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: SU.DEPT_ID)"),
    ("C", 369, 375, "LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM"),
    ("R", 390, "AND SITE_ITEM.ITEM_ID = A.ITEM_ID", "AND SITE_ITEM.ITEM_ID = A.ITEM_ID"),
    ("I", 390, POP_TEAM_NEW),
    ("C", 751, 752, "SCM_MST_SSO_DEPT_INFO"),
    ("R", 766, "T1.PARTIAL_PLAN_YN", "T1.PARTIAL_PLAN_YN, T1.DEPT_ID /* 2026-09-06 hook#150 AJS */"),
    ("R", 779, "SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE", "SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE"),
    ("I", 779, SP_TEAM_NEW),
])

# ---------------- PKG_DMF0020 ----------------
ops = []
for a in (2781, 2857):  # SALES_PRICE_TEMPLATE x2
    ops += [("C", a, a + 13, "LEFT JOIN ("),
            ("I", a + 13, ["        " + T,
                           "        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM",
                           "            ON TEAM.DEPT_ID = SI.DEPT_ID"])]
for a in (3803, 3818, 3831):  # OWNER_DATA x3
    ops += [("C", a + 1, a + 1, "SCM_MST_SSO_USER_INFO B"),
            ("R", a + 3, "A.OWNER       = B.USER_ID", "A.DEPT_ID     = C.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: A.OWNER = B.USER_ID AND B.DEPT_ID = C.DEPT_ID)"),
            ("C", a + 4, a + 4, "B.DEPT_ID     = C.DEPT_ID")]
ops += [("R", 5294, ", SU.DEPT_ID", ", SI.DEPT_ID  " + T + " (AS-IS: SU.DEPT_ID)"),
        ("C", 5296, 5297, "LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO SU"),
        ("R", 5623, "T1.OWNER, T1.PARTIAL_PLAN_YN", "T1.OWNER, T1.PARTIAL_PLAN_YN, T1.DEPT_ID /* 2026-09-06 hook#150 AJS */"),
        ("C", 5632, 5637, "LEFT JOIN ("),
        ("I", 5637, ["        " + T, "        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM", "            ON TEAM.DEPT_ID = SITE_ITEM.DEPT_ID"])]
ops += [("R", 8010, ",SU.DEPT_ID", ",SI.DEPT_ID  " + T + " (AS-IS: SU.DEPT_ID)"),
        ("R", 8022, "ON SU.DEPT_ID = TM.DEPT_ID", "ON SI.DEPT_ID = TM.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: SU.DEPT_ID)"),
        ("C", 8082, 8088, "LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM"),
        ("R", 8103, "AND SITE_ITEM.ITEM_ID = A.ITEM_ID", "AND SITE_ITEM.ITEM_ID = A.ITEM_ID"),
        ("I", 8103, POP_TEAM_NEW),
        ("C", 8472, 8473, "SCM_MST_SSO_DEPT_INFO"),
        ("R", 8487, "T1.PARTIAL_PLAN_YN", "T1.PARTIAL_PLAN_YN, T1.DEPT_ID /* 2026-09-06 hook#150 AJS */"),
        ("R", 8500, "SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE", "SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE"),
        ("I", 8500, SP_TEAM_NEW)]
apply("PKG_DMF0020", ops)

# ---------------- PKG_DMF0022 ----------------
apply("PKG_DMF0022", [("C", 1802, 1803, "SELECT SU.DEPT_ID FROM SCM_MST_SSO_USER_INFO SU"),
                      ("I", 1803, ["           A.DEPT_ID AS DEPT_ID,  " + T])])
# ---------------- PKG_DMF0035 ----------------
apply("PKG_DMF0035", [("C", 2247, 2249, "(SELECT SU.DEPT_ID"),
                      ("I", 2249, ["         , A.DEPT_ID AS DEPT_ID  " + T])])
# ---------------- PKG_DMF0040 (q'[ ]' 동적 SQL 내부) ----------------
apply("PKG_DMF0040", [("R", 1313, ",E.ATTRIBUTE7", ",E.ATTRIBUTE7\n                              ,E.DEPT_ID  -- 2026-09-06 hook#150 AJS"),
                      ("C", 1335, 1341, "LEFT JOIN ("),
                      ("I", 1341, ["            " + T,
                                   "            LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM",
                                   "                   ON  TEAM.DEPT_ID = E.DEPT_ID"]),
                      ("R", 1347, "ON  J.DEPT_ID = K.DEPT_ID", "ON  E.DEPT_ID = K.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: J.DEPT_ID = OWNER 경유)")])


# ---------------- PKG_DMF0044 ----------------
def sc(n):
    su = "SU" + n
    si = "SI" + n
    old = f"(SELECT {su}.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO {su} WHERE A.OWNER = {su}.USER_ID AND ROWNUM = 1)"
    new = (f"(SELECT {si}.DEPT_ID FROM SCM_MGR.SCM_MST_SITE_ITEM {si} WHERE {si}.DIVISION_ID = A.DIVISION_ID AND {si}.PROJECT_CODE = A.PROJECT_CODE "
           f"AND {si}.SCM_SITE_ID = A.SCM_SITE_ID AND {si}.ITEM_ID = A.ITEM_ID AND ROWNUM = 1) /* 2026-09-06 hook#150 AJS: AS-IS {old} */")
    return old, new


apply("PKG_DMF0044", [("R", 3087, *sc("")), ("R", 3095, *sc("2")), ("R", 3098, *sc("3")), ("R", 3102, *sc("4")),
                      ("C", 8588, 8588, "JOIN SCM_MST_SSO_USER_INFO C ON SUBSTR(B.OWNER"),
                      ("R", 8589, "JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID", "JOIN SCM_MST_SSO_DEPT_INFO D ON B.DEPT_ID = D.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: C.DEPT_ID = OWNER 경유 SSO_USER_INFO)"),
                      ("R", 8718, "JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID", "JOIN SCM_MST_SSO_DEPT_INFO D ON B.DEPT_ID = D.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: C.DEPT_ID = SCM_MST_SITE.DEPT_ID)"),
                      ("R", 8825, "JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID", "JOIN SCM_MST_SSO_DEPT_INFO D ON B.DEPT_ID = D.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: C.DEPT_ID = SCM_MST_SITE.DEPT_ID)"),
                      ("R", 8847, "LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID", "LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON B.DEPT_ID = D.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: C.DEPT_ID = SCM_MST_SITE.DEPT_ID)")])
# ---------------- PKG_DMF0051 ----------------
apply("PKG_DMF0051", [("R", 1177, ", OW.DEPT_ID                                                             AS DEPT_ID", ", SMSI.DEPT_ID                                                           AS DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: OW.DEPT_ID = OWNER 경유)"),
                      ("C", 1182, 1185, "( SELECT SU.DEPT_ID"),
                      ("R", 1205, ", S.DEPT_ID", ", SI.DEPT_ID  " + T + " (AS-IS: S.DEPT_ID = SCM_MST_SITE.DEPT_ID)"),
                      ("C", 1215, 1215, ", X.DEPT_ID"),
                      ("R", 1227, "AND A.SCM_SITE_ID = S.SCM_SITE_ID", "AND A.SCM_SITE_ID = S.SCM_SITE_ID"),
                      ("I", 1227, ["          LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM SI  -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 (A 의 PK 4키 1:1 -> 건수 불변)",
                                   "                 ON SI.DIVISION_ID  = A.DIVISION_ID",
                                   "                AND SI.PROJECT_CODE = A.PROJECT_CODE",
                                   "                AND SI.SCM_SITE_ID  = A.SCM_SITE_ID",
                                   "                AND SI.ITEM_ID      = A.ITEM_ID"])])
# ---------------- PKG_DMF0074 ----------------
ops = []
for a, al in ((131, "SITE_ITEM"), (235, "SITE_ITEM"), (670, "SI"), (749, "SI")):
    ops += [("C", a, a + 7, "LEFT JOIN ("),
            ("I", a + 7, ["        " + T,
                          "        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM",
                          f"               ON TEAM.DEPT_ID = {al}.DEPT_ID"])]
apply("PKG_DMF0074", ops)
# ---------------- PKG_DMF0082 ----------------
apply("PKG_DMF0082", [
    ("C", 903, 912, "LEFT JOIN ("),
    ("I", 912, ["    " + T, "    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM", "        ON TEAM.DEPT_ID = F.DEPT_ID"]),
    ("C", 919, 921, "ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID"),
    ("I", 921, ["        ON K.DEPT_ID = F.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: div40 은 J.DEPT_ID = OWNER 경유)"]),
    ("C", 5071, 5072, "INNER JOIN SCM_MGR.SCM_MST_SSO_USER_INFO UI"),
    ("R", 5074, "ON UI.DEPT_ID = DI.DEPT_ID", "ON SI.DEPT_ID = DI.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: UI.DEPT_ID = OWNER 경유)"),
    ("C", 5081, 5083, "WHERE  UI.USER_ID = CASE WHEN INSTR(SI.OWNER"),
    ("I", 5083, ["                                        WHERE  1 = 1  -- 2026-09-06 hook#150 AJS"]),
    ("C", 7431, 7437, "LEFT JOIN (SELECT B2.USER_ID"),
    ("I", 7437, ["    " + T, "    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM", "        ON TEAM.DEPT_ID = F.DEPT_ID"]),
    ("R", 7444, "ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID ELSE F.DEPT_ID END", "ON K.DEPT_ID = F.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID ELSE F.DEPT_ID END)"),
    ("R", 10395, "SU.DEPT_ID, TM.DEPT_NAME_KO", "SI.DEPT_ID /* 2026-09-06 hook#150 AJS AS-IS SU.DEPT_ID */, TM.DEPT_NAME_KO"),
    ("R", 10399, "TM ON SU.DEPT_ID = TM.DEPT_ID", "TM ON SI.DEPT_ID = TM.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: SU.DEPT_ID)"),
    ("C", 10484, 10492, "LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM"),
    ("R", 10508, "AND SITE_ITEM.ITEM_ID = A.ITEM_ID", "AND SITE_ITEM.ITEM_ID = A.ITEM_ID"),
    ("I", 10508, ["\t" + T + " / TEAM,DEPRTMENT 조인을 SITE_ITEM 뒤로 이동",
                  "\tLEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM",
                  "\t\tON SITE_ITEM.DEPT_ID = TEAM.DEPT_ID AND TEAM.VALID_YN = 'Y'",
                  "\tLEFT JOIN SCM_MST_SSO_DEPT_INFO DEPRTMENT",
                  "\t\tON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID",
                  "\t\tAND DEPRTMENT.VALID_YN = 'Y'"]),
    ("C", 11044, 11045, "LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM"),
    ("R", 11060, "T1.PARTIAL_PLAN_YN", "T1.PARTIAL_PLAN_YN, T1.DEPT_ID /* 2026-09-06 hook#150 AJS */"),
    ("R", 11071, "SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE", "SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE"),
    ("I", 11071, ["\t\t" + T, "\t\tLEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM", "\t\t\tON SITE_ITEM.DEPT_ID = TEAM.DEPT_ID"]),
])
