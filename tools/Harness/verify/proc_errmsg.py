"""저장 오류코드 → TO-BE 서버 문구(프로시저 원문) 조회 (2026-11-25 T646 · SCP0005 MSG00043 3행)

  python tools/Harness/verify/proc_errmsg.py <MENU_ID> <오류코드>[,<오류코드>...]   → JSON {코드: {"msg", "where"}} 출력
  python tools/Harness/verify/proc_errmsg.py --selftest

화면이 저장 오류 응답의 MSG 열을 그대로 알림으로 띄우는 경우(_trace.spec 가짜 응답 표지로 실측), 실제 문구는 서버 프로시저가 정한다.
사내 DB ALL_SOURCE 에서 PKG_<MENU_ID> 본문의 오류코드 대입 줄('<코드>')을 찾고, 그 뒤 3줄 안의 문자열 대입(…MSG… := '문구')을 문구로 본다.
찾지 못한 코드는 결과에 넣지 않는다(추정 금지). 읽기 전용 조회만 한다.
"""
import json, os, re, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
MSG_RX = re.compile(r"(?i)\b\w*(?:MSG|MESSAGE)\w*\s*:=\s*'((?:[^']|'')*)'")


def find_msgs(lines, codes):
    """lines = [(이름, 줄 번호, 글자)] · 코드 대입 줄 뒤 3줄 안 첫 문구 대입"""
    out = {}
    for i, (nm, ln, tx) in enumerate(lines):
        for c in codes:
            if c in out or not re.search(r":=\s*'" + re.escape(c) + r"'", tx):
                continue
            for nm2, ln2, tx2 in lines[i + 1:i + 4]:
                m = MSG_RX.search(tx2)
                if m and nm2 == nm and ln2 - ln <= 3:
                    out[c] = {'msg': m.group(1).replace("''", "'"), 'where': f'{nm} 줄 {ln}~{ln2}'}
                    break
    return out


def selftest():
    ls = [('P', 1, "V_ERR_CODE := '99020';"), ('P', 2, "V_ERR_MESSAGE := 'DUP PRIORITY.';"), ('P', 5, "V_ERR_CODE := '99010';"), ('P', 6, "x := 1;"), ('P', 7, "V_ERR_MESSAGE := 'DUP DATA.';"),
          ('P', 20, "V_ERR_CODE := '99030';"), ('P', 30, "V_ERR_MESSAGE := 'FAR';")]
    got = find_msgs(ls, ['99010', '99020', '99030'])
    cases = [('코드 바로 뒤 문구', got.get('99020', {}).get('msg'), 'DUP PRIORITY.'), ('3줄 안 문구', got.get('99010', {}).get('msg'), 'DUP DATA.'),
             ('3줄 밖 = 못 찾음', '99030' in got, False)]
    bad = 0
    for n, g, w in cases:
        ok = g == w; bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n} → {g}(기대 {w})")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main():
    if '--selftest' in sys.argv:
        return selftest()
    if len(sys.argv) < 3:
        print(__doc__)
        return 2
    mid, codes = sys.argv[1].upper(), [c for c in sys.argv[2].split(',') if c]
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
    from dbconn import connect  # noqa: E402
    with connect('tobe') as cx:
        cur = cx.cursor()
        cur.execute("SELECT NAME, LINE, TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND TYPE = 'PACKAGE BODY' AND NAME = :n ORDER BY LINE", n=f'PKG_{mid}')
        lines = [(r[0], r[1], r[2] or '') for r in cur.fetchall()]
    print(json.dumps(find_msgs(lines, codes), ensure_ascii=False))
    return 0


if __name__ == '__main__':
    sys.exit(main())
