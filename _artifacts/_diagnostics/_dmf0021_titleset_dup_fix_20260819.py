#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0021_titleset_dup_fix_20260819.py — DMF0021 'Sales Plan' FROM_SITE_ID 메타 중복 정리

원인(실측): SCM_MST_SHEET_COLUMNS 에 (DMF0021,'Sales Plan',FROM_SITE_ID) 2행 —
①SORT 162/VISIBLE 'N' 구 이관분(kjj0070, 2025-12-12) ②SORT 168/VISIBLE 'Y' 활성분(2026-07-21).
SCM0002_SET_TITLESET_POPUP L157 단일행 서브쿼리가 2행을 만나 ORA-01427.
조치: DIVISION_ID 동일 확인 시 구 숨김행 백업 후 삭제 → 합성 사용자로 SP 재현 검증 → 정리.
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402

BAK = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0021_FROM_SITE_ID_DUP_ROW_BACKUP_20260819.txt"


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute(
        """SELECT DIVISION_ID, SORT_ORDER_NO, VISIBLE_FLAG FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
           WHERE PROGRAM_ID='DMF0021' AND SHEET_NAME='Sales Plan' AND COLUMN_NAME='FROM_SITE_ID'"""
    )
    rows = cur.fetchall()
    print("DIVISION_ID 실측:", rows)
    assert len(rows) == 2, f"행수 {len(rows)}"
    if len({r[0] for r in rows}) != 1:
        print("DIVISION_ID 상이 — 삭제 보류(SP 서브쿼리 DIV축 누락 별도 보고)")
        return
    cur.execute(
        """SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
           WHERE PROGRAM_ID='DMF0021' AND SHEET_NAME='Sales Plan'
             AND COLUMN_NAME='FROM_SITE_ID' AND SORT_ORDER_NO=162 AND VISIBLE_FLAG='N'"""
    )
    cols = [x[0] for x in cur.description]
    bak = dict(zip(cols, [str(v) for v in cur.fetchone()]))
    with open(BAK, "w", encoding="utf-8") as f:
        f.write(repr(bak))
    cur.execute(
        """DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
           WHERE PROGRAM_ID='DMF0021' AND SHEET_NAME='Sales Plan'
             AND COLUMN_NAME='FROM_SITE_ID' AND SORT_ORDER_NO=162 AND VISIBLE_FLAG='N'"""
    )
    print("구 숨김행 삭제:", cur.rowcount, "(백업:", BAK, ")")
    con.commit()
    # 재현 검증 — 사용자 실패 페이로드 그대로, 합성 사용자
    ov1 = cur.var(oracledb.DB_TYPE_CURSOR)
    ov2 = cur.var(oracledb.DB_TYPE_CURSOR)
    stmt = """BEGIN SCM_MGR.SCM0002_SET_TITLESET_POPUP('DMF0021','Sales Plan','C',
        'Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y^Y',
        'DIVISION_ID^DEPT_ID^END_CUSTOMER^SCM_SITE_ID^PROJECT_CODE^ITEM_ID^TEXT^ITEM_NAME^NICK_NAME^INCOTERMS^FCST_TYPE^DOM_EXP^FROM_SITE_ID^CURRENCY^PLANT_SITE_ID^MEASURE',
        '1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16',
        'N^N^N^N^N^N^N^N^N^N^N^N^N^N^N^N',
        'ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC^ASC',
        'E2ETEST_TS',
        '30^80^80^120^80^100^100^80^80^40^80^30^110^40^50^100',
        '^^^^^^^^^^^^^^^','^^^^^^^^^^^^^^^', :o1, :o2); END;"""
    try:
        cur.execute(stmt, {"o1": ov1, "o2": ov2})
        print("재현 검증: 성공 — ORA-01427 해소")
    except Exception as e:  # noqa: BLE001
        print("재현 검증 실패:", str(e)[:250])
    cur.execute("DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE USER_ID='E2ETEST_TS'")
    print("합성 사용자 titleset 정리:", cur.rowcount, "행")
    con.commit()
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
