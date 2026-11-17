# -*- coding: utf-8 -*-
"""
Requestor 팝업 콤보 SQL(SCM_ADM_CMBO_SQL_M) — 대소문자 무시 (2026-11-13)
  python cmbo_apply.py --dry | --apply
수정 전 현재 값을 새로 조회해 backup\\CMBO_<SQL_ID>.ASIS.txt 로 저장하고, LIKE 3줄의 컬럼·입력에 UPPER 를 씌운다.
적용 직전 다시 조회해 착수 조회본과 같을 때만 UPDATE (FRESH-GATE). 원복 = 백업 파일 내용으로 UPDATE.
"""
import sys, os, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn

IDS = ['SSP0021_UserInfoList', 'SSP0060_UserInfoList']
PAIRS = [("USER_ID LIKE '%' || @userName || '%'", "UPPER(USER_ID) LIKE '%' || UPPER(@userName) || '%'"),
         ("USER_NM LIKE '%' || @userName || '%'", "UPPER(USER_NM) LIKE '%' || UPPER(@userName) || '%'"),
         ("USER_ENG_NM LIKE '%' || @userName || '%'", "UPPER(USER_ENG_NM) LIKE '%' || UPPER(@userName) || '%'")]


def get(cur, i):
    cur.execute("SELECT SQL_DTL_CTN, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:i", i=i)
    r = cur.fetchone()
    v = r[0].read() if hasattr(r[0], 'read') else r[0]
    return v, r[1]


def run(cur, sql, kw):
    q = sql.replace('@userName', "'" + kw + "'" if kw else "''")
    cur.execute(q)
    return sorted(r[0] for r in cur.fetchall())


def main():
    mode = sys.argv[1]
    con = dbconn.connect('tobe', write=(mode == '--apply'))
    cur = con.cursor()
    os.makedirs(os.path.join(HERE, 'backup'), exist_ok=True)
    for i in IDS:
        old, upd = get(cur, i)
        new = old
        for a, b in PAIRS:
            assert new.count(a) == 1, '%s: 기준 문구 %d건 — %s' % (i, new.count(a), a)
            new = new.replace(a, b)
        open(os.path.join(HERE, 'backup', 'CMBO_%s.ASIS.txt' % i), 'w', encoding='utf-8', newline='').write(old)
        print('[%s] %s 수정 전 LAST_UPDATE_DATE=%s 길이 %d → %d' % (datetime.datetime.now().strftime('%H:%M:%S'), i, upd, len(old), len(new)))
        res = {}
        for kw in (None, 'KIM', 'kim', 'Kim'):
            b, a = run(cur, old, kw), run(cur, new, kw)
            res[kw] = a
            print('   입력 %-5s : 전 %d명 → 후 %d명 | 전에만 %d' % (kw, len(b), len(a), len(set(b) - set(a))))
            assert not (set(b) - set(a)), '수정 전 결과가 수정 후에 없음'
        assert res['KIM'] == res['kim'] == res['Kim'], '대소문자 입력별 결과가 다름'
        assert res[None] == run(cur, old, None)
        if mode == '--apply':
            now, _ = get(cur, i)   # FRESH-GATE
            assert now == old, 'FRESH-GATE 실패: 착수 후 값 변경'
            cur.execute("UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M SET SQL_DTL_CTN=:v, LAST_UPDATE_DATE=SYSDATE WHERE SQL_ID=:i", v=new, i=i)
            assert cur.rowcount == 1
            con.commit()
            chk, upd2 = get(cur, i)
            print('   적용 완료: 저장값==적용본 %s LAST_UPDATE_DATE=%s' % (chk == new, upd2))
    con.close()


if __name__ == '__main__':
    main()
