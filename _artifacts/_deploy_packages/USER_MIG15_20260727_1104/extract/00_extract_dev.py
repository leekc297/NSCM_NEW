# -*- coding: utf-8 -*-
"""
USER_MIG15 — DEV MSSQL(LGCE_SCMDEV) 15계정 추출
- 프로필 정본: TB_FX_User_20260715_PROD (운영 스냅샷) + 부재자(miyeong.lee)는 TB_FX_User(DEV) 폴백
- AS-IS 근거 덤프: UserGroupInfo / UserGroupAuthExtention / GroupInfo / GroupMenuAuth(+Extension)
- 출력: extract/asis_*.txt (UTF-8, pipe-delim, 헤더 1행)
- 접속: _artifacts/_diagnostics/asis.py 와 동일 (.env.asis 자동 로드, 읽기 전용)
실행: python 00_extract_dev.py  (이 폴더에서)
"""
import os, sys, io

sys.stdout.reconfigure(encoding="utf-8")
DIAG = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "_diagnostics"))
sys.path.insert(0, DIAG)
import asis  # noqa: E402  (재사용: .env.asis 로드 + pyodbc 접속)

USERS = ['hongjae.kim', 'eunah.koo', 'yooah.chung', 'dodae',
         'jiwon.park', 'bpark416', 'jaehyeok', 'park6151', 'bottle',
         'wonqthanq', 'ys_cho', 'miyeong.lee', 'yeonjusung', 'coeogus']
GROUPS = ['DM ADMIN', 'DM Planner', 'DM Planner (W/S)', 'DM Viewer', 'SCP Planner']

IN_USERS = ",".join(f"N'{u}'" for u in USERS)
IN_GROUPS = ",".join(f"N'{g}'" for g in GROUPS)

USER_COLS = ("UserID, UserName, UserName_E, Email, Dept_ID, OfficePhoneNum, CellPhoneNum, "
             "Language, DefaultGroupID, TimeZone, LastLoginDateTime, UseYN, "
             "Attribute1, Attribute2, Attribute3, Attribute4, Attribute5, "
             "Attribute6, Attribute7, Attribute8, Attribute9, Attribute10")

QUERIES = {
    # 프로필: PROD 스냅샷 우선 + 스냅샷 부재자만 DEV 폴백 (SRC 컬럼으로 출처 표기)
    "asis_user.txt": f"""
        SELECT 'PROD0715' AS SRC, {USER_COLS}
          FROM dbo.TB_FX_User_20260715_PROD WHERE UserID IN ({IN_USERS})
        UNION ALL
        SELECT 'DEV' AS SRC, {USER_COLS}
          FROM dbo.TB_FX_User D WHERE D.UserID IN ({IN_USERS})
           AND NOT EXISTS (SELECT 1 FROM dbo.TB_FX_User_20260715_PROD P WHERE P.UserID = D.UserID)
        ORDER BY 2""",
    # AS-IS 근거 (참고용 — 그룹매핑/권한 생성 정본은 지정 역할 목록)
    "asis_user_group.txt": f"""
        SELECT UserID, GroupID, UseYN FROM dbo.TB_FX_UserGroupInfo
         WHERE UserID IN ({IN_USERS}) ORDER BY UserID, GroupID""",
    "asis_unit_auth.txt": f"""
        SELECT UserID, GroupID, AuthType, Code, PrntCode, JV_PLANT_ID
          FROM dbo.TB_FX_UserGroupAuthExtention
         WHERE UserID IN ({IN_USERS}) ORDER BY UserID, GroupID, AuthType, Code""",
    "asis_group.txt": """
        SELECT GroupID, GrpName, UseYN FROM dbo.TB_FX_GroupInfo ORDER BY GroupID""",
    # 5개 대상 그룹의 AS-IS 메뉴 권한 (gap 진단 근거) — MenuID→ProgramID 해석 포함
    "asis_group_menu_auth.txt": f"""
        SELECT A.GroupID, A.MenuID, M.ProgramID, A.BasicACLC, A.BasicACLR, A.BasicACLU, A.BasicACLD, A.UseYN
          FROM dbo.TB_FX_GroupMenuAuth A
          LEFT JOIN dbo.TB_FX_MenuItemInfo M ON M.MenuID = A.MenuID
         WHERE A.GroupID IN ({IN_GROUPS}) ORDER BY A.GroupID, A.MenuID""",
}

def dump(fname: str, sql: str) -> int:
    cn = asis._conn()
    cur = cn.cursor()
    cur.execute(sql)
    cols = [d[0] for d in cur.description]
    rows = cur.fetchall()
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), fname)
    with io.open(out, "w", encoding="utf-8", newline="\n") as f:
        f.write("|".join(cols) + "\n")
        for r in rows:
            f.write("|".join("" if v is None else str(v).replace("|", "¦").replace("\r", " ").replace("\n", " ") for v in r) + "\n")
    cn.close()
    print(f"[OK] {fname}: {len(rows)} rows")
    return len(rows)

if __name__ == "__main__":
    counts = {f: dump(f, q) for f, q in QUERIES.items()}
    n_users = counts["asis_user.txt"]
    if n_users != len(USERS):
        print(f"[WARN] asis_user.txt {n_users} rows != 기대 {len(USERS)} — 부재자 확인 필요")
    print("[DONE]")
