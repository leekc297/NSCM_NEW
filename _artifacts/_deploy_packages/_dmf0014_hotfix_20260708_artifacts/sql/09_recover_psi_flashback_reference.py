import pathlib, oracledb
root = pathlib.Path(r"C:\Projects\NSCM")
kv={}
for line in (root/".env.asis").read_text(encoding="utf-8",errors="ignore").splitlines():
    if "=" in line and not line.strip().startswith("#"):
        k,v=line.split("=",1); kv[k.strip()]=v.strip()
dsn=f"{kv['TOBE_DB_HOST']}:{kv['TOBE_DB_PORT']}/{kv['TOBE_DB_PDB']}"
TS = "TO_TIMESTAMP(TO_CHAR(SYSDATE,'YYYY-MM-DD')||' 10:57:00','YYYY-MM-DD HH24:MI:SS')"
KEYS = ["DIVISION_ID","SCM_SITE_ID","CUSTOMER_PROJECT_CODE","CUSTOMER_MODEL","DOM_EXP",
        "FCST_TYPE","MEASURE_GROUP","MEASURE","YYYYMMDD","INCOTERMS","PLANT_SITE_ID"]
keyeq = " AND ".join(f"C.{k} = F.{k}" for k in KEYS)
with oracledb.connect(user=kv["TOBE_DB_USER"],password=kv["TOBE_DB_PASS"],dsn=dsn) as con:
    cur=con.cursor()
    # 사전 확인
    cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.DM_PLN_CUSTOMER_PSI AS OF TIMESTAMP {TS} WHERE DIVISION_ID='81' AND SCM_SITE_ID='HLGP_KR_CHU'")
    before = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_PLN_CUSTOMER_PSI WHERE DIVISION_ID='81' AND SCM_SITE_ID='HLGP_KR_CHU'")
    now = cur.fetchone()[0]
    print(f"10:57 시점 {before}행 / 현재 {now}행")
    # 복구 INSERT — 현재 없는 키만
    cur.execute(f"""
        INSERT INTO SCM_MGR.DM_PLN_CUSTOMER_PSI
        SELECT F.* FROM SCM_MGR.DM_PLN_CUSTOMER_PSI AS OF TIMESTAMP {TS} F
         WHERE F.DIVISION_ID='81' AND F.SCM_SITE_ID='HLGP_KR_CHU'
           AND NOT EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_CUSTOMER_PSI C WHERE {keyeq})
    """)
    print("복구 INSERT:", cur.rowcount, "행")
    con.commit()
    cur.execute("SELECT COUNT(*) CNT, COUNT(DISTINCT CUSTOMER_MODEL) MODELS FROM SCM_MGR.DM_PLN_CUSTOMER_PSI WHERE DIVISION_ID='81' AND SCM_SITE_ID='HLGP_KR_CHU'")
    r = cur.fetchone()
    print(f"복구 후: {r[0]}행 / {r[1]}모델")
