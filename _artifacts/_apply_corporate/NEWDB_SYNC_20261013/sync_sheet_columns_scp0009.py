"""신규 사내오라클(59.19.252.148) ← 구 사내오라클(222.110.191.243) 누락분 반영 : SCM_MST_SHEET_COLUMNS (SCP0009 / Shipment Request)

구 DB 에서 2026-10-13 10:07~10:10 (minyonglee1) 에 바뀐 COLUMN_WIDTH 12행이 신규 DB 에 없다.
신규 DB 쪽 해당 행의 최종 수정은 전부 그보다 이전(2026-10-06 ~ 10-12 16:35) → 구 DB 값이 최신.

  python sync_sheet_columns_scp0009.py check   # 신·구 재조회 대조만 (변경 없음)
  python sync_sheet_columns_scp0009.py apply   # 재조회 게이트 통과 행만 UPDATE (COLUMN_WIDTH + 수정자·수정일을 구 DB 값으로)
"""
import sys, json, os, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
NEW_HOST, OLD_HOST = "59.19.252.148", "222.110.191.243"
PGM, SHEET = "SCP0009", "Shipment Request"
CUT = datetime.datetime(2026, 10, 12, 20, 0, 0)
SQL = ("SELECT COLUMN_NAME, COLUMN_WIDTH, LAST_UPDATED_BY, LAST_UPDATE_DATE FROM SCM_MST_SHEET_COLUMNS "
       "WHERE PROGRAM_ID=:p AND SHEET_NAME=:s")
ALLCOLS = ("SELECT * FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:p AND SHEET_NAME=:s ORDER BY COLUMN_NAME")


def connect(host):
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=f"{host}:{d.split(':', 1)[1]}")


def snapshot(con):
    cur = con.cursor(); cur.execute(SQL, p=PGM, s=SHEET)
    rows = cur.fetchall()
    assert len({r[0] for r in rows}) == len(rows), "COLUMN_NAME 중복 — 키 판정 불가"
    return {r[0]: r[1:] for r in rows}


def plan(o, n):
    assert set(o) == set(n), f"컬럼 집합 불일치 only-old {set(o)-set(n)} only-new {set(n)-set(o)}"
    todo, skip = [], []
    for c in sorted(o):
        if o[c][0] == n[c][0]:
            continue
        # 구 DB 가 컷오프 이후 수정됐고, 신규 DB 행이 그보다 이전 수정일 때만 대상
        if o[c][2] >= CUT and n[c][2] < o[c][2]:
            todo.append((c, n[c][0], o[c][0], o[c][1], o[c][2], n[c][1], n[c][2]))
        else:
            skip.append((c, o[c], n[c]))
    return todo, skip


def other_cols_equal(co, cn):
    """COLUMN_WIDTH·감사 컬럼 외 나머지 컬럼은 신·구가 같은지 (다르면 폭만 옮기는 게 맞는지 재검토 대상)"""
    a = co.cursor(); a.execute(ALLCOLS, p=PGM, s=SHEET); ra = a.fetchall(); names = [d[0] for d in a.description]
    b = cn.cursor(); b.execute(ALLCOLS, p=PGM, s=SHEET); rb = b.fetchall()
    ex = {"COLUMN_WIDTH", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"}
    idx = [i for i, c in enumerate(names) if c not in ex]
    return [tuple(r[i] for i in idx) for r in ra] == [tuple(r[i] for i in idx) for r in rb]


def main(mode):
    with connect(OLD_HOST) as co, connect(NEW_HOST) as cn:
        c = cn.cursor(); c.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), (SELECT DBID FROM V$DATABASE), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
        host, dbid, now = c.fetchone()
        assert host != "ol9-db", f"대상이 신규 DB 가 아님: {host}"
        o, n = snapshot(co), snapshot(cn)
        todo, skip = plan(o, n)
        print("NEW DB", host, dbid, now, "| rows old", len(o), "new", len(n), "| 대상", len(todo), "| 보류", len(skip),
              "| 폭·감사 외 컬럼 동일:", other_cols_equal(co, cn))
        for t in todo:
            print("   ", t[0], "width", t[1], "->", t[2], "| old upd", t[3], t[4], "| new upd", t[5], t[6])
        for s in skip:
            print("    SKIP", s)
        if mode != "apply":
            return
        cur = cn.cursor(); n_upd = 0; before = []
        for col, w_new, w_old, by, dt, nby, ndt in todo:
            # 재조회 게이트: 신규 DB 행이 방금 본 값 그대로일 때만 갱신 (그 사이 바뀌었으면 0행)
            cur.execute("UPDATE SCM_MST_SHEET_COLUMNS SET COLUMN_WIDTH=:w, LAST_UPDATED_BY=:b, LAST_UPDATE_DATE=:d "
                        "WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c AND COLUMN_WIDTH=:w0 AND LAST_UPDATE_DATE=:d0",
                        w=w_old, b=by, d=dt, p=PGM, s=SHEET, c=col, w0=w_new, d0=ndt)
            if cur.rowcount != 1:
                cn.rollback(); sys.exit(f"GATE FAIL: {col} rowcount {cur.rowcount} — 전체 ROLLBACK")
            n_upd += 1; before.append({"COLUMN_NAME": col, "COLUMN_WIDTH": w_new, "LAST_UPDATED_BY": nby, "LAST_UPDATE_DATE": str(ndt)})
        json.dump({"applied_at": now, "db": [host, dbid], "before": before}, open(os.path.join(HERE, "_before_sheet_columns_scp0009.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
        cn.commit()
        o2, n2 = snapshot(co), snapshot(cn)
        print("UPDATED", n_upd, "| COMMIT | 적용 후 신·구 (폭·수정자·수정일) 동일:", o2 == n2)


if __name__ == "__main__":
    main(sys.argv[1])
