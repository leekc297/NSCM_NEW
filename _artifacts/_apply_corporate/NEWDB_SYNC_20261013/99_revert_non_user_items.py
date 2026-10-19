"""신규 사내오라클(59.19.252.148) — 이 폴더에서 넣은 것 중 사용자 본인 작업이 아닌 2건 원복

사용자 지시(2026-10-13): "다른 작업은 그냥 놔두고, 제가 어제 저녁 10시부터 지금까지 작업한 내역 중 누락된 항목만 적용" /
"다른 분들이 작업한 내용을 제가 적용할 수는 없습니다."
  1) SCM_MST_SHEET_COLUMNS SCP0009 / Shipment Request COLUMN_WIDTH 12행 → 적용 직전 값(_before_sheet_columns_scp0009.json)으로 복원
  2) SCMP_APP 시노님 15건(GT_0080_* 13 · PKG_SCP0002 · PKG_SCP0080) → DROP
PKG_DMF0082 BODY(SSPMNEW · ADJYNALL)는 사용자 작업이므로 유지.
"""
import sys, os, json, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
NEW_HOST = "59.19.252.148"
SYN = ['GT_0080_ALL', 'GT_0080_BOM_CELL', 'GT_0080_BOM_PACK', 'GT_0080_CELL_CF_KD', 'GT_0080_ENERGE', 'GT_0080_GROUP_CODE', 'GT_0080_ITEM_ACTIVE',
       'GT_0080_ITEM_ALL', 'GT_0080_PLANT', 'GT_0080_PRE', 'GT_0080_SAVE_MAIN', 'GT_0080_SAVE_MAIN_CA', 'GT_0080_TEMP', 'PKG_SCP0002', 'PKG_SCP0080']
# 이 폴더 sync_sheet_columns_scp0009.py 가 넣은 값 (COLUMN_NAME: 넣은 폭)
PUT = {'APPLICATION': 50, 'CELL_MODEL': 50, 'CELL_PACK_COUNT': 55, 'FROM_SITE_NAME': 65, 'INCOTERMS': 60, 'MODEL_SPEC': 55, 'MODEL_VERSION': 55,
       'PROJECT_CODE': 60, 'PROJECT_NAME': 60, 'PROJECT_OWNER': 60, 'SOLDTO_CUSTOMER': 55, 'SPEC_VERSION': 55}

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=f"{NEW_HOST}:{d.split(':', 1)[1]}") as cn:
    c = cn.cursor()
    c.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), (SELECT DBID FROM V$DATABASE), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    host, dbid, now = c.fetchone()
    assert host != "ol9-db" and dbid == 71207375, f"대상이 신규 DB 가 아님: {host} {dbid}"
    print("NEW DB", host, dbid, now)
    before = json.load(open(os.path.join(HERE, "_before_sheet_columns_scp0009.json"), encoding="utf-8"))["before"]
    assert {b["COLUMN_NAME"] for b in before} == set(PUT)
    n = 0
    for b in before:
        dt = datetime.datetime.strptime(b["LAST_UPDATE_DATE"], "%Y-%m-%d %H:%M:%S")
        # 내가 넣은 폭 그대로일 때만 복원 (그 사이 다른 변경이 있으면 0행 → 전체 ROLLBACK)
        c.execute("UPDATE SCM_MST_SHEET_COLUMNS SET COLUMN_WIDTH=:w, LAST_UPDATED_BY=:b, LAST_UPDATE_DATE=:d "
                  "WHERE PROGRAM_ID='SCP0009' AND SHEET_NAME='Shipment Request' AND COLUMN_NAME=:c AND COLUMN_WIDTH=:w0",
                  w=b["COLUMN_WIDTH"], b=b["LAST_UPDATED_BY"], d=dt, c=b["COLUMN_NAME"], w0=PUT[b["COLUMN_NAME"]])
        if c.rowcount != 1:
            cn.rollback(); sys.exit(f"GATE FAIL: {b['COLUMN_NAME']} rowcount {c.rowcount} — 전체 ROLLBACK")
        n += 1
    cn.commit()
    c.execute("SELECT COLUMN_NAME, COLUMN_WIDTH, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM SCM_MST_SHEET_COLUMNS "
              "WHERE PROGRAM_ID='SCP0009' AND SHEET_NAME='Shipment Request'")
    cur = {r[0]: r[1:] for r in c}
    ok = all(cur[b["COLUMN_NAME"]] == (b["COLUMN_WIDTH"], b["LAST_UPDATED_BY"], b["LAST_UPDATE_DATE"]) for b in before)
    print("SHEET_COLUMNS 복원", n, "행 | 적용 직전 값과 동일:", ok)
with oracledb.connect(user="SCMP_APP", password=p, dsn=f"{NEW_HOST}:{d.split(':', 1)[1]}") as ca:
    a = ca.cursor(); inl = ",".join("'" + s + "'" for s in SYN)
    a.execute(f"SELECT SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM USER_SYNONYMS WHERE SYNONYM_NAME IN ({inl})")
    have = a.fetchall()
    assert all(r[1] == "SCM_MGR" and r[0] == r[2] for r in have)
with oracledb.connect(user=u, password=p, dsn=f"{NEW_HOST}:{d.split(':', 1)[1]}") as cn:
    c = cn.cursor()
    for r in have:
        c.execute(f'DROP SYNONYM SCMP_APP."{r[0]}"')
    print("시노님 DROP", len(have))
with oracledb.connect(user="SCMP_APP", password=p, dsn=f"{NEW_HOST}:{d.split(':', 1)[1]}") as ca:
    a = ca.cursor(); a.execute(f"SELECT COUNT(*) FROM USER_SYNONYMS WHERE SYNONYM_NAME IN ({inl})"); left = a.fetchone()[0]
    a.execute("SELECT COUNT(*) FROM USER_SYNONYMS"); print("남은 대상 시노님", left, "| SCMP_APP 시노님 총", a.fetchone()[0], "(적용 전 2301)")
