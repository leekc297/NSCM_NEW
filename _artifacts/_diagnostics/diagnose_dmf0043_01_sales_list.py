#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST + DMF0043_GET_SALES_LIST_SPREAD_TITLE 직접 호출
- O_RC1/O_RC2/O_RC3 cursor 응답 행 수 확인
- titleData (BASE 9 + dynamic) 행 수 확인
"""
import oracledb

CONN = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn="121.162.245.167:2521/OCGSCMD_P01",
)

def main():
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()

    # title SP — BASE 9 + dynamic
    print("=== DMF0043_GET_SALES_LIST_SPREAD_TITLE (divisionId='40') ===")
    rc1 = cur.var(oracledb.CURSOR)
    cur.callproc("DMF0043_GET_SALES_LIST_SPREAD_TITLE", ["40", rc1])
    title_rows = rc1.getvalue().fetchall()
    cols = [d[0] for d in rc1.getvalue().description]
    print(f"  rows: {len(title_rows)}")
    print(f"  columns: {cols}")
    base_cnt = 0
    dyn_cnt = 0
    for i, r in enumerate(title_rows[:20]):
        d = dict(zip(cols, r))
        is_base = i < 9
        if is_base:
            base_cnt += 1
        else:
            dyn_cnt += 1
        print(f"    [{i:3}] BASE={is_base}  COLUMN_NAME={d.get('COLUMN_NAME')}  LARGE={d.get('LARGE_CLASS_LABEL_NAME')}  LEAF={d.get('COLUMN_LABEL_NAME')}")
    if len(title_rows) > 20:
        print(f"    ... ({len(title_rows) - 20} more)")
    print(f"  TOTAL: BASE_first_9={min(9, len(title_rows))}  DYN_rest={max(0, len(title_rows) - 9)}")

    # main SP — 데이터 조회 (Year 콤보의 첫 verSeq + 일반적 인자)
    print()
    print("=== DMF0043_GET_MAIN_VARSION_DATA (Year 콤보 인자 확인) ===")
    rc_year = cur.var(oracledb.CURSOR)
    try:
        cur.callproc("DMF0043_GET_MAIN_VARSION_DATA", [rc_year])
        year_rows = rc_year.getvalue().fetchall()
        ycols = [d[0] for d in rc_year.getvalue().description]
        print(f"  rows: {len(year_rows)}")
        print(f"  columns: {ycols}")
        for r in year_rows[:5]:
            d = dict(zip(ycols, r))
            print(f"    CODE={d.get('CODE')}  NAME={d.get('NAME')}  NAME2={d.get('NAME2')}")
    except oracledb.DatabaseError as e:
        print(f"  ERR: {e}")
        # 인자가 다를 수 있음 — ALL_ARGUMENTS 확인
        cur.execute("""
            SELECT ARGUMENT_NAME, DATA_TYPE, IN_OUT, POSITION
              FROM USER_ARGUMENTS
             WHERE OBJECT_NAME='DMF0043_GET_MAIN_VARSION_DATA'
             ORDER BY POSITION
        """)
        for row in cur.fetchall():
            print(f"    arg: {row}")

    # main 데이터 SP — verSeq=80 정도로 시도 (실 값은 사용자 화면에서)
    print()
    print("=== DMF0043_GET_CONTRIBUTION_SALES_LIST sanity (verSeq 미지정 — 인자만 확인) ===")
    cur.execute("""
        SELECT ARGUMENT_NAME, DATA_TYPE, IN_OUT, POSITION
          FROM USER_ARGUMENTS
         WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST'
         ORDER BY POSITION
    """)
    for row in cur.fetchall():
        print(f"  arg: {row}")

    # 실제 호출 시도 — 사용자 보고: 데이터 조회 안 됨
    print()
    print("=== DMF0043_GET_CONTRIBUTION_SALES_LIST 실 호출 (divisionId='40', 첫 verSeq) ===")
    if 'year_rows' in dir() and year_rows:
        first_ver = year_rows[0][0]  # CODE
        print(f"  first verSeq: {first_ver}")
        rc_main = cur.var(oracledb.CURSOR)
        rc_sort = cur.var(oracledb.CURSOR)
        rc_cnt = cur.var(oracledb.CURSOR)
        try:
            cur.callproc("DMF0043_GET_CONTRIBUTION_SALES_LIST", [
                '40',         # divisionId
                str(first_ver),  # verSeq
                '',           # versionNo (선택 — 빈 값 시 SP 가 어떻게 처리?)
                '',           # endCustReport
                'ALL',        # productGroup
                'ALL',        # bizType
                'N',          # millionYn
                'N',          # compatibilityYn
                'minyonglee1',  # sesUserId
                rc_main,
                rc_sort,
                rc_cnt,
            ])
            main_rows = rc_main.getvalue().fetchall()
            mcols = [d[0] for d in rc_main.getvalue().description]
            print(f"  main rows: {len(main_rows)}")
            print(f"  main columns: {mcols[:10]} ... (total {len(mcols)})")
            if main_rows:
                d = dict(zip(mcols, main_rows[0]))
                print(f"  first row sample: {dict(list(d.items())[:5])}")
            else:
                print("  WARN — main rows 0건")

            cnt_rows = rc_cnt.getvalue().fetchall()
            print(f"  cnt rows: {len(cnt_rows)}  data: {cnt_rows[:3]}")
        except oracledb.DatabaseError as e:
            print(f"  ERR: {e}")

    conn.close()

if __name__ == "__main__":
    main()
