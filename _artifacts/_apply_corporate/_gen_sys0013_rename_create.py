"""
SYS0013 SP rename — USER_SOURCE 에서 7 DMF0027 SP body 추출 → 새 명칭으로 CREATE 문 생성
"""
import os, oracledb, re

DSN = "121.162.245.167:2521/ESSCMD"
USR, PWD = "SCM_MGR", "!SCMroqkf2026"

NAME_MAP = {
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST":        "SYS0013_GET_QUERY_LIST",
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS":     "SYS0013_GET_COLUMNS",
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS":  "SYS0013_GET_PARAMETERS",
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2":       "SYS0013_EXECUTE_QUERY",
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON": "SYS0013_GET_QUERY_LIST_COMMON",
    "DMF0027_GET_DM_DYNAMIC_QUERYS":                "SYS0013_GET_DYNAMIC_QUERYS",
    "DMF0027_GET_DM_ROLE_DATA":                     "SYS0013_GET_ROLE_DATA",
}

conn = oracledb.connect(user=USR, password=PWD, dsn=DSN)
cur = conn.cursor()

out_path = "C:/Projects/NSCM/_artifacts/_apply_corporate/59_sys0013_sp_rename_create.sql"
with open(out_path, "w", encoding="utf-8") as out:
    out.write("-- 59. SYS0013 SP rename — DMF0027_* → SYS0013_* (옛 명칭과 공존, DROP 은 별도 step)\n")
    out.write("-- 작성: 2026-06-15 (옵션 A — 짧은 명)\n\n")

    for old_name, new_name in NAME_MAP.items():
        cur.execute(
            "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
            {"n": old_name}
        )
        body_lines = [r[0] for r in cur.fetchall()]
        if not body_lines:
            out.write(f"-- ⚠ {old_name} body 없음 — skip\n\n")
            continue
        body = "".join(body_lines)

        # 1) PROCEDURE 머리 명칭 치환 — 첫 라인의 PROCEDURE <name> 패턴
        new_body = re.sub(
            rf"\b{re.escape(old_name)}\b",
            new_name,
            body,
            count=0,  # 모든 매치 (recursive 자기 호출 포함)
            flags=re.IGNORECASE
        )

        out.write(f"-- ============================================\n")
        out.write(f"-- {old_name} → {new_name}\n")
        out.write(f"-- ============================================\n")
        # USER_SOURCE 의 첫 라인은 이미 'PROCEDURE "<name>"' 형태 — CREATE OR REPLACE 만 prepend
        out.write("CREATE OR REPLACE ")
        out.write(new_body)
        out.write("\n/\n\n")

        # 자기 호출 치환 카운트
        self_ref = len(re.findall(rf"\b{re.escape(old_name)}\b", body, flags=re.IGNORECASE))
        print(f"  {old_name} → {new_name} : body {len(body)} bytes, self-ref {self_ref}")

cur.close()
conn.close()
print(f"\nWritten: {out_path}")
