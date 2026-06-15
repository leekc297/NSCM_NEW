"""
PKG_DMF0027 → PKG_SYS0013 rename
- PACKAGE spec + BODY 추출 + 명칭 치환 + CREATE OR REPLACE 생성
"""
import oracledb, re

DSN = "121.162.245.167:2521/ESSCMD"
USR, PWD = "SCM_MGR", "!SCMroqkf2026"

# 명칭 치환 매핑 (긴 명 → 짧은 명, PKG 명도 포함)
NAME_MAP = [
    ("P_DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON", "P_SYS0013_GET_QUERY_LIST_COMMON"),
    ("P_DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS",  "P_SYS0013_GET_PARAMETERS"),
    ("P_DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS",     "P_SYS0013_GET_COLUMNS"),
    ("P_DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2",       "P_SYS0013_EXECUTE_QUERY"),
    ("P_DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST",        "P_SYS0013_GET_QUERY_LIST"),
    ("P_DMF0027_GET_DM_DYNAMIC_QUERYS",                "P_SYS0013_GET_DYNAMIC_QUERYS"),
    ("P_DMF0027_GET_DM_ROLE_DATA",                     "P_SYS0013_GET_ROLE_DATA"),
    # standalone SP names (PKG body 안에서 호출 가능)
    ("DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON",   "SYS0013_GET_QUERY_LIST_COMMON"),
    ("DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS",    "SYS0013_GET_PARAMETERS"),
    ("DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS",       "SYS0013_GET_COLUMNS"),
    ("DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2",         "SYS0013_EXECUTE_QUERY"),
    ("DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST",          "SYS0013_GET_QUERY_LIST"),
    ("DMF0027_GET_DM_DYNAMIC_QUERYS",                  "SYS0013_GET_DYNAMIC_QUERYS"),
    ("DMF0027_GET_DM_ROLE_DATA",                       "SYS0013_GET_ROLE_DATA"),
    # PKG 자체
    ("PKG_DMF0027", "PKG_SYS0013"),
]

conn = oracledb.connect(user=USR, password=PWD, dsn=DSN)
cur = conn.cursor()

out_path = "C:/Projects/NSCM/_artifacts/_apply_corporate/62_sys0013_pkg_rename_create.sql"
with open(out_path, "w", encoding="utf-8") as out:
    out.write("-- 62. PKG_DMF0027 → PKG_SYS0013 rename — PACKAGE spec + BODY\n")
    out.write("-- 작성: 2026-06-15\n\n")

    for type_ in ("PACKAGE", "PACKAGE BODY"):
        cur.execute(
            "SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0027' AND TYPE=:t ORDER BY LINE",
            {"t": type_}
        )
        body_lines = [r[0] for r in cur.fetchall()]
        body = "".join(body_lines)

        # 모든 명칭 치환 (긴 명부터 — substring 매칭 안전)
        new_body = body
        total_subs = 0
        for old, new in NAME_MAP:
            new_body, n = re.subn(rf"\b{re.escape(old)}\b", new, new_body, flags=re.IGNORECASE)
            total_subs += n

        out.write(f"-- ============================================\n")
        out.write(f"-- {type_} : PKG_DMF0027 → PKG_SYS0013 ({total_subs} substitutions)\n")
        out.write(f"-- ============================================\n")
        out.write("CREATE OR REPLACE ")
        out.write(new_body)
        out.write("\n/\n\n")

        print(f"  {type_}: {len(body)} bytes, {total_subs} substitutions")

cur.close()
conn.close()
print(f"\nWritten: {out_path}")
