# -*- coding: utf-8 -*-
"""Excel 업로드 시험이 남긴 스테이징 행 정리(2026-11-02)

  python tools/Harness/verify/excel_stage_clean.py <MENU_ID> "<YYYY-MM-DD HH24:MI:SS>"   시험 시작 시각 이후 이 계정의 표식 행 삭제
  python tools/Harness/verify/excel_stage_clean.py --selftest                            판정 변이 입증

  대상 = SCM_ADM_EXCEL_UPLOAD 중 PROGRAM_ID·CREATED_BY(시험 계정)·시작 시각 이후 행으로
    ① 값 칸에 시험 표식(E2E · E2E_WRONG_*)이 있는 행 ② 그 표식 행과 같은 초에 만들어진 @TITLE 행.
  표식이 없는 행은 지우지 않는다(사용자 업로드 보호). 삭제 전후 건수를 출력한다.
"""
import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
RX_MARK = re.compile(r'^E2E(_WRONG_[A-Z])?$')
ACCOUNT = 'minyonglee1'


def pick_rows(rows):
    """rows = [{id, status, at, vals}] — 지울 UPLOAD_ID 목록"""
    marked = [r for r in rows if any(RX_MARK.match(str(v or '').strip()) for v in r['vals'])]
    secs = {r['at'] for r in marked}
    ids = {r['id'] for r in marked}
    ids |= {r['id'] for r in rows if r['status'] == '@TITLE' and r['at'] in secs}
    return sorted(ids)


def selftest():
    R = [{'id': 1, 'status': 'UPLOAD', 'at': 's1', 'vals': ['E2E', '']}, {'id': 2, 'status': '@TITLE', 'at': 's1', 'vals': ['Division*']}, {'id': 3, 'status': '@TITLE', 'at': 's2', 'vals': ['Division*']}, {'id': 4, 'status': 'UPLOAD', 'at': 's2', 'vals': ['REAL', 'E2EX']}, {'id': 5, 'status': 'UPLOAD', 'at': 's3', 'vals': ['E2E_WRONG_A']}]
    got = pick_rows(R)
    cases = [('표식 행·같은 초 제목 삭제', got == [1, 2, 5], True), ('다른 초 제목 보호', 3 not in got, True), ('표식 없는 행 보호', 4 not in got, True), ('행 없음', pick_rows([]) == [], True)]
    bad = 0
    for n, ok, want in cases:
        k = ok == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n}")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main(mid, since):
    from dbconn import connect
    with connect('tobe', write=True) as cx:
        cur = cx.cursor()
        cur.execute("SELECT * FROM SCM_ADM_EXCEL_UPLOAD WHERE (PROGRAM_ID=:p OR PROGRAM_ID LIKE :q ESCAPE '\\') AND LOWER(CREATED_BY)=:u AND CREATION_DATE>=TO_DATE(:s,'YYYY-MM-DD HH24:MI:SS')", p=mid, q=mid + '\\_%', u=ACCOUNT, s=since)  # DMF0074_40 처럼 Division 접미가 붙는 화면(2026-11-03)
        names = [d[0] for d in cur.description]
        rows = []
        for x in cur.fetchall():
            d = dict(zip(names, x))
            rows.append({'id': d['UPLOAD_ID'], 'status': d.get('UPLOAD_STATUS_CODE'), 'at': str(d['CREATION_DATE']), 'vals': [v for k, v in d.items() if k.startswith('ATTRIBUTE') and not hasattr(v, 'read')]})
        ids = pick_rows(rows)
        n = 0
        for i in range(0, len(ids), 500):
            ch = ids[i:i + 500]
            cur.execute('DELETE FROM SCM_ADM_EXCEL_UPLOAD WHERE (PROGRAM_ID=:p OR PROGRAM_ID LIKE :q ESCAPE \'\\\') AND LOWER(CREATED_BY)=:u AND UPLOAD_ID IN (' + ','.join(f':i{j}' for j in range(len(ch))) + ')', {'p': mid, 'q': mid + '\\_%', 'u': ACCOUNT, **{f'i{j}': v for j, v in enumerate(ch)}})
            n += cur.rowcount
        cx.commit()
    print(f'[excel_stage_clean] {mid}: {since} 이후 {len(rows)}행 중 표식 {len(ids)}건 → 삭제 {n}건 · IDs {ids[:8]}')
    return 0


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        sys.exit(selftest())
    if len(sys.argv) < 3:
        print(__doc__); sys.exit(2)
    sys.exit(main(sys.argv[1].upper(), sys.argv[2]))
