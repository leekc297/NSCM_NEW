#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0082_pjtname_fix_20260819.py — DMF0082 GRID Project 명 표시 정정 (사용자 신고 2026-08-19)

원인(실측): TEMP_SITE_ITEM_ALL 스테이징 L839 `F.PROJECT_CODE AS PROJECT_NAME` — 마스터 조인
부재로 명 자리에 코드가 들어감. 정정: SCM_MST_PROJECT LEFT JOIN + NVL(명, 코드) 폴백
(마스터 미등재 코드는 코드 표시 유지 — div82 미등재 계보). 마커 [E20260819-PJTNAME].
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402

OLD_SEL = "         , F.PROJECT_CODE                                   AS PROJECT_NAME"
NEW_SEL = ("         , NVL(MP.PROJECT_NAME, F.PROJECT_CODE)            AS PROJECT_NAME"
           "  --[E20260819-PJTNAME] 명 표시(마스터 미등재=코드 폴백)")

OLD_JOIN = """    INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
        ON  S.COUNTRY     = I.COUNTRY"""
NEW_JOIN = """    INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
        ON  S.COUNTRY     = I.COUNTRY
    --[E20260819-PJTNAME] Project 명 원천 — SCM_MST_PROJECT (미등재 코드 대비 LEFT)
    LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
        ON  F.DIVISION_ID  = MP.DIVISION_ID
        AND F.PROJECT_CODE = MP.PROJECT_CODE"""


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute(
        """SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
           AND TYPE='PACKAGE BODY' ORDER BY LINE"""
    )
    body = "CREATE OR REPLACE " + "".join(r[0] for r in cur.fetchall()).rstrip() + "\n/\n"
    with open(r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_BODY_PRE_PJTNAME_20260819.sql",
              "w", encoding="utf-8", newline="") as f:
        f.write(body)
    c1, c2 = body.count(OLD_SEL), body.count(OLD_JOIN)
    print(f"앵커: SELECT {c1} / JOIN {c2}")
    assert c1 == 1 and c2 >= 1, "앵커 불일치 — 중단"
    body = body.replace(OLD_SEL, NEW_SEL)
    # JOIN 앵커가 복수면 첫 번째(TEMP_SITE_ITEM_ALL 블록)만 — L839 인접 블록인지 위치로 확인
    if c2 == 1:
        body = body.replace(OLD_JOIN, NEW_JOIN)
    else:
        idx = body.find(NEW_SEL)
        jidx = body.find(OLD_JOIN, idx)
        assert jidx > 0, "SELECT 이후 JOIN 앵커 없음"
        body = body[:jidx] + NEW_JOIN + body[jidx + len(OLD_JOIN):]
    out = r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_BODY_PJTNAME_20260819.sql"
    with open(out, "w", encoding="utf-8", newline="") as f:
        f.write(body)
    cur.execute(body.rstrip().rstrip("/").rstrip())
    cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082'")
    print("적용:", cur.fetchall())
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'")
    print("ALL_ERRORS:", cur.fetchone()[0])
    cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
                   AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260819-PJTNAME%'""")
    print("마커:", cur.fetchone()[0], "(기대 2)")
    cur.close()
    con.close()
    print("클라우드 파일:", out)


if __name__ == "__main__":
    main()
