#!/usr/bin/env python3
"""
DMF0043_01 데이터 조회 가능한 (verSeq, versionNo) 조합 찾기.

흐름:
  1) Year combo SP (DMF0043_GET_MAIN_VARSION_DATA) → verSeq 인벤토리
  2) 각 verSeq 별 Version popup SP (DMF0043_GET_CONT_VIEW_VERSIONPOPUP) → versionNo 후보
     - period: 최근 12 개월 ~ +6 개월 default
     - versionType: REPORT_SP_W / REPORT_BP_M / REPORT_MF_D 모두 시도
  3) 각 (verSeq, versionNo) 조합으로 main SP 호출 → main rows > 0 확인
"""
import oracledb
import datetime

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")

def main():
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()

    # 1) Year combo
    print("=== Year combo (DMF0043_GET_MAIN_VARSION_DATA) ===")
    rc = cur.var(oracledb.CURSOR)
    cur.callproc('DMF0043_GET_MAIN_VARSION_DATA', ['minyonglee1', 'DMF0043_01', rc])
    year_rows = rc.getvalue().fetchall()
    ycols = [d[0] for d in rc.getvalue().description]
    print(f"  rows: {len(year_rows)}")
    for r in year_rows[:10]:
        d = dict(zip(ycols, r))
        print(f"    CODE={d.get('CODE')} NAME={d.get('NAME')} NAME2={d.get('NAME2')}")

    # 2) Version popup — verSeq 별로 versionNo 후보
    print()
    print("=== Version popup 후보 (verSeq 별) ===")
    # AS-IS default period: 최근 -6 ~ +6 month (popup 의 default), 그러나 더 넓게 시도
    today = datetime.date.today()
    start_yyyymmdd = (today - datetime.timedelta(days=365 * 3)).strftime("%Y%m%d")  # 3년 전
    end_yyyymmdd = (today + datetime.timedelta(days=180)).strftime("%Y%m%d")  # +6개월

    found = []  # (verSeq, yyyy, versionNo, versionType, description)
    for y in year_rows:
        d = dict(zip(ycols, y))
        ver_seq = str(d.get('CODE') or '')
        yyyy = str(d.get('NAME2') or d.get('NAME') or '')[:4]
        if not ver_seq:
            continue
        for vtype in ['REPORT_BP_M', 'REPORT_SP_W', 'REPORT_MF_D']:
            rc2 = cur.var(oracledb.CURSOR)
            try:
                cur.callproc('DMF0043_GET_CONT_VIEW_VERSIONPOPUP', [
                    start_yyyymmdd, end_yyyymmdd, '40', vtype, '', rc2
                ])
                vrows = rc2.getvalue().fetchall()
                vcols = [d[0] for d in rc2.getvalue().description]
                if vrows:
                    print(f"  verSeq={ver_seq} yyyy={yyyy} type={vtype}: {len(vrows)} version 후보")
                    for vr in vrows[:5]:
                        vd = dict(zip(vcols, vr))
                        version_no = str(vd.get('VERSION_NO') or '')
                        desc = str(vd.get('VERSION_DESCRIPTION') or '')[:30]
                        if version_no:
                            found.append((ver_seq, yyyy, version_no, vtype, desc))
                            print(f"    VERSION_NO={version_no:<30} TYPE={vtype:<15} DESC={desc}")
            except Exception as e:
                pass

    # 3) main SP 호출 — rows > 0 확인
    print()
    print("=== main SP 호출 (DMF0043_GET_CONTRIBUTION_SALES_LIST) ===")
    print("  data 조회 가능한 (verSeq, versionNo) 조합:")
    success = []
    for ver_seq, yyyy, version_no, vtype, desc in found:
        rc_main = cur.var(oracledb.CURSOR)
        rc_sort = cur.var(oracledb.CURSOR)
        rc_cnt = cur.var(oracledb.CURSOR)
        try:
            cur.callproc('DMF0043_GET_CONTRIBUTION_SALES_LIST', [
                '40',           # divisionId
                ver_seq,        # verSeq
                version_no,     # versionNo
                '',             # endCustReport
                'ALL',          # productGroup
                'ALL',          # bizType
                'N',            # millionYn
                'N',            # compatibilityYn
                'minyonglee1',  # sesUserId
                rc_main, rc_sort, rc_cnt,
            ])
            mrows = rc_main.getvalue().fetchall()
            cnt_rows = rc_cnt.getvalue().fetchall()
            cnt = cnt_rows[0][0] if cnt_rows else 0
            if mrows:
                success.append((ver_seq, yyyy, version_no, vtype, len(mrows), cnt, desc))
                print(f"  ✓ verSeq={ver_seq} yyyy={yyyy} VERSION={version_no} TYPE={vtype} → main_rows={len(mrows)} cnt={cnt}")
        except Exception as e:
            print(f"  ✗ verSeq={ver_seq} VERSION={version_no}: {str(e)[:80]}")

    print()
    print(f"=== 결과: {len(success)} 조합 데이터 조회 가능 ===")
    if success:
        print()
        print("화면 입력값 (FE 매핑):")
        first = success[0]
        print(f"  - Year 선택: yyyy={first[1]} (verSeq={first[0]})")
        print(f"  - Version 선택: {first[2]} (type={first[3]})")
        print(f"  - Division: 40 / 제품군: ALL / Biz: ALL / Million: N / Consistency: N")
        print(f"  → 예상 main rows: {first[4]}")

    conn.close()

if __name__ == "__main__":
    main()
