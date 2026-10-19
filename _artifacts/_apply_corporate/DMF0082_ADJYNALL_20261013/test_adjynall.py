"""[E20261013-DMF0082ADJYNALL] 검증 — 저장 SP 실호출 (차단 케이스만 · 영구 테이블 무변경이 기대값)

 대상 = 마스터에 SALES_PLAN_ADJUST_YN='N' 으로 등록된 40 품목. 종전에는 단가 검증에서 빠져 판가 없이 저장됐다.
 호출 = 신규 행 MKT_FCST 1건, 그 주에 LOC 판가가 없는 (키, 주). 기대 = 'Unit Price Not Found' 로 차단, 원장 0 → 0.
 안전장치: ① 적용 마커가 있을 때만 호출 ② 호출 직전 그 키의 수요·판가 원장 0건 확인(아니면 다른 키) ③ 호출 후 건수 재확인.
   막히지 않고 저장되면 FAIL 로 보고하고 넣어진 키·일자를 출력한다(자동 삭제하지 않음).

  python test_adjynall.py
"""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

MARK = "[E20261013-DMF0082ADJYNALL]"
CNT = ("SELECT (SELECT COUNT(*) FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE division_id=:d AND project_code=:p AND scm_site_id=:s AND item_id=:i) + "
       "(SELECT COUNT(*) FROM DM_PLN_CFM_SELLING_PRICE WHERE division_id=:d AND project_code=:p AND scm_site_id=:s AND item_id=:i) FROM dual")


def main():
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d)
    cn.call_timeout = 600000
    cur = cn.cursor()
    cur.execute("SELECT COUNT(*) FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE :m", m="%" + MARK + "%")
    if cur.fetchone()[0] == 0:
        sys.exit("ERROR: 적용 마커 없음 — 호출하지 않음 (미적용 상태에서 호출하면 시험 행이 저장된다)")
    cur.execute("""SELECT S.division_id, S.project_code, S.scm_site_id, S.item_id
                     FROM SCM_MST_SITE_ITEM S
                    WHERE S.division_id='40' AND S.valid_yn='Y' AND S.sales_plan_adjust_yn='N'
                      AND EXISTS (SELECT 1 FROM SCM_MST_ITEM_SN N WHERE N.division_id=S.division_id AND N.item_id=S.item_id AND N.active_flag='Y')
                    ORDER BY S.project_code, S.scm_site_id, S.item_id""")
    keys = cur.fetchall()
    print("조정 제외(N) 유효 품목", len(keys), "건")
    cur.execute("SELECT TO_CHAR(TRUNC(SYSDATE,'IW')+7*8,'YYYYMMDD') FROM dual")   # 8주 뒤 월요일
    ymd = cur.fetchone()[0]
    ok = True
    tried = 0
    for div, prj, site, item in keys:
        key = dict(d=div, p=prj, s=site, i=item)
        cur.execute(CNT, key)
        before = cur.fetchone()[0]
        if before != 0:
            print(f"  건너뜀 — 원장에 이미 {before}건: {div}/{prj}/{site}/{item}")
            continue
        for cell in ("-", "HQ06-A"):
            rc = cn.cursor()
            cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA",
                         ["I", div, prj, prj, site, item, "E", "MPS", "CPT", "MKT_FCST", "-", cell, ymd, "", "1", "minyonglee1", "", rc])
            cols = [c[0] for c in rc.description]
            row = rc.fetchone()
            res = dict(zip(cols, row)) if row else {}
            msg = str(res.get("RESULT_MSG", "")).replace("\n", " / ")
            cn.rollback()
            cur.execute(CNT, key)
            after = cur.fetchone()[0]
            hit = "Unit Price Not Found" in msg
            print(f"  {div}/{prj}/{site}/{item} · Cell Prod [{cell}] · {ymd} → {res.get('RESULT_CODE')} | {msg[:170]}")
            print(f"     원장 {before} → {after} · {'단가 검증 차단 PASS' if hit and after == 0 else ('FAIL — 저장됨' if after else '다른 검증에서 차단(단가 검증 미도달)')}")
            if after != 0:
                print("     !!! 넣어진 행 정리 필요:", key, ymd)
                ok = False
                break
            if hit:
                tried += 1
                break
        if tried >= 2 or not ok:
            break
    print("RESULT", "PASS" if ok and tried >= 1 else ("FAIL" if not ok else "ERROR — 단가 검증까지 도달한 케이스 없음(판정 불가)"))


if __name__ == "__main__":
    main()
