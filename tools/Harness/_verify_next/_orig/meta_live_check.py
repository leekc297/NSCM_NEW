# -*- coding: utf-8 -*-
"""메타·배선 실시간 검증(EN-03 · EN-22 의 확인 단계 · 2026-11-11) — 생성·보완 뒤 화면이 실제로 동작할 DB 상태인지를 사내 DB 를 '지금' 조회해 확인한다.

  python tools/Harness/verify/meta_live_check.py <MENU_ID>      → Doc/verify/<ID>/meta_live_check.csv (+ 콘솔 요약)
  python tools/Harness/verify/meta_live_check.py --selftest

왜: 완료 조건 B22/B23/B26 은 내보낸 CSV 스냅샷(Doc/tobefacts/db/*.csv)과 대조한다 — 사내 DB 에 적용한 뒤의 실제 상태가 아니다. 생성 체인에는 DB 반영 확인 단계가 없다(추측 지점 원장 META·FE_GEN).
검사(모두 읽기 전용 · 사내 DB 실시간):
  M1 메뉴        SCM_ADM_MNU_M 에 이 화면 행 · USE_YN
  M2 FE 호출 배선  FE 가 부르는 (시트, 버튼) — TO-BE 사실 Doc/tobefacts/screens/<ID>/endpoints.csv(TS 파서) — 마다 SCM_ADM_MNU_BTN_MPG_M → SCM_ADM_API_M 로 PROC 이 풀리는가
                 (버튼이 빈 조회 훅은 'SEARCH' — E2E 포착 URL 형태 <시트>/SEARCH/call-proc 과 같음)
  M3 PROC 실재    풀린 PKG.PROC 이 ALL_PROCEDURES 에 있고 · PACKAGE/BODY 가 VALID · ALL_ERRORS 0
  M4 인자 메타    SCM_ADM_PROC_M 의 IN/OUT 인자 수·순서 ↔ ALL_ARGUMENTS(실제 PKG 시그니처) — BE 는 PROC_M 순서로 바인딩한다
  M5 컬럼 메타    AS-IS 메타의 시트(Doc/asisfacts/screens/<ID>/dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv)마다 TO-BE SCM_MST_SHEET_COLUMNS 에 행이 있는가 · 빠진 컬럼
  M6 콤보        FE 상수의 콤보 ID(tobefacts constants.csv 의 COMBO.*) 가 SCM_ADM_CMBO_SQL_M 에 있고 USE_YN=Y
판정: PASS / FAIL(반영 안 됨) / ERROR(재료 없음 — 미측정). FAIL 1건이라도 있으면 종료코드 2.
한계: FE 사실 파일이 낡았으면(화면을 고친 뒤 TobeFacts 미갱신) M2·M6 대상이 실제와 다를 수 있다 — 파일 시각을 출력한다. 버튼 권한(그룹별)은 여기서 보지 않는다(J 규칙 소관).
"""
import csv
import os
import re
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
csv.field_size_limit(10 ** 8)
COLS = ['check', 'target', 'result', 'detail']


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def fe_calls(endpoints, mid):
    """FE 호출 지점 → {(시트, 버튼)} — 이 화면 메뉴 · 주석 아님 · 시트가 있는 call-proc 류"""
    out = {}
    for r in endpoints:
        if (r.get('menu') or '').upper() != mid or (r.get('commented') or '0') not in ('0', ''):
            continue
        sh = (r.get('sheet') or '').strip()
        if not sh or not re.search(r'call-proc|useTabProcQuery|useProcMutation|callProc', (r.get('url') or '') + (r.get('callee') or '') + (r.get('kind') or '')):
            continue
        btn = (r.get('action') or '').strip().upper() or 'SEARCH'
        if re.search(r'[${}\s]', sh + btn):  # 식이 풀리지 않은 호출(동적 시트·버튼)은 대상에서 빼고 따로 센다
            out.setdefault(('?', '?'), []).append(f"{os.path.basename(r.get('file') or '')}:{r.get('line')}")
            continue
        out.setdefault((sh, btn), []).append(f"{os.path.basename(r.get('file') or '')}:{r.get('line')}")
    return out


def rename_pairs(miss, extra, a_info, t_info):
    """AS-IS 에만 있는 컬럼 ↔ TO-BE 에만 있는 컬럼 중 (라벨, 순번)이 같은 1:1 쌍 — [(asis, tobe)]. 라벨이 비었거나 후보가 여럿이면 잇지 않는다"""
    out = []
    for a in miss:
        ia = a_info(a)
        if not ia or not ia[0]:
            continue
        cand = [b for b in extra if t_info(b) == ia]
        if len(cand) == 1 and sum(1 for x in miss if a_info(x) == ia) == 1:
            out.append((a, cand[0]))
    return out


def cmp_args(meta_rows, db_args):
    """순수 함수 — PROC_M 행[(col_tp, sort)] ↔ ALL_ARGUMENTS[(in_out, position)] → (ok, 설명)"""
    m = [(str(t).upper(), int(s or 0)) for t, s in meta_rows]; d = [(str(io).upper().replace('IN/OUT', 'INOUT'), int(p or 0)) for io, p in db_args if p]
    mi, mo = sum(1 for t, _ in m if t == 'IN'), sum(1 for t, _ in m if t != 'IN'); di, do = sum(1 for t, _ in d if t == 'IN'), sum(1 for t, _ in d if t != 'IN')
    if not d:
        return False, 'PKG 에 이 PROC 인자 정보 없음'
    if not m:
        return False, f'PROC_M 행 없음(PKG 인자 IN {di} · OUT {do})'
    if (mi, mo) != (di, do):
        return False, f'인자 수 다름 — PROC_M IN {mi}·OUT {mo} ↔ PKG IN {di}·OUT {do}'
    seq_m = [t for t, _ in sorted(m, key=lambda x: x[1])]; seq_d = [t for t, _ in sorted(d, key=lambda x: x[1])]
    if [x == 'IN' for x in seq_m] != [x == 'IN' for x in seq_d]:
        return False, 'IN/OUT 순서 다름'
    return True, f'IN {mi} · OUT {mo} 일치'


def selftest():
    E = [{'menu': 'X', 'sheet': 'main', 'action': '', 'url': 'X/main//call-proc', 'callee': 'useTabProcQuery', 'kind': 'hook', 'commented': '0', 'file': 'a.tsx', 'line': '1'},
         {'menu': 'X', 'sheet': 'main', 'action': 'SAVE', 'url': '/X/main/SAVE/call-proc', 'callee': 'apiClient.post', 'kind': 'http', 'commented': '0', 'file': 'a.tsx', 'line': '2'},
         {'menu': 'X', 'sheet': 'old', 'action': 'SAVE', 'url': '/X/old/SAVE/call-proc', 'callee': 'apiClient.post', 'kind': 'commented', 'commented': '1', 'file': 'a.tsx', 'line': '3'},
         {'menu': 'Y', 'sheet': 'main', 'action': '', 'url': 'Y/main//call-proc', 'callee': 'useTabProcQuery', 'kind': 'hook', 'commented': '0', 'file': 'b.tsx', 'line': '4'},
         {'menu': 'X', 'sheet': '', 'action': '', 'url': '(useTabComboQueries)', 'callee': 'useTabComboQueries', 'kind': 'hook', 'commented': '0', 'file': 'a.tsx', 'line': '5'},
         {'menu': 'X', 'sheet': '${SHEETS.A}', 'action': 'SEARCH', 'url': 'X/${SHEETS.A}/SEARCH/call-proc', 'callee': 'apiClient.post', 'kind': 'http', 'commented': '0', 'file': 'a.tsx', 'line': '6'}]
    fc = fe_calls(E, 'X')
    cases = [('조회 훅 빈 버튼 = SEARCH', ('main', 'SEARCH') in fc), ('저장 호출', ('main', 'SAVE') in fc), ('주석 호출 제외', ('old', 'SAVE') not in fc), ('다른 메뉴 제외', len([k for k in fc if k != ('?', '?')]) == 2),
             ('풀리지 않은 식은 따로', ('?', '?') in fc),
             ('인자 일치', cmp_args([('IN', 1), ('IN', 2), ('OUT', 3)], [('IN', 1), ('IN', 2), ('OUT', 3)])[0]),
             ('인자 수 다름', not cmp_args([('IN', 1), ('OUT', 2)], [('IN', 1), ('IN', 2), ('OUT', 3)])[0]),
             ('IN/OUT 순서 다름', not cmp_args([('IN', 1), ('OUT', 2), ('IN', 3)], [('IN', 1), ('IN', 2), ('OUT', 3)])[0]),
             ('PROC_M 없음', not cmp_args([], [('IN', 1)])[0]),
             ('ID 만 다르고 라벨·순번 같은 쌍 = 이름 바뀐 같은 자리', rename_pairs(['MKT_OWNER'], ['MTK_OWNER'], lambda x: ('MKT Owner', '23'), lambda x: ('MKT Owner', '23')) == [('MKT_OWNER', 'MTK_OWNER')]),
             ('라벨이 다르면 잇지 않는다(변이)', rename_pairs(['A'], ['B'], lambda x: ('L1', '1'), lambda x: ('L2', '1')) == []),
             ('순번이 다르면 잇지 않는다(변이)', rename_pairs(['A'], ['B'], lambda x: ('L1', '1'), lambda x: ('L1', '2')) == []),
             ('후보가 둘이면 잇지 않는다', rename_pairs(['A'], ['B', 'C'], lambda x: ('L1', '1'), lambda x: ('L1', '1')) == [])]
    bad = 0
    for n, ok in cases:
        bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n}")
    print(f"{len(cases) - bad}/{len(cases)}")
    return 1 if bad else 0


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a:
        print(__doc__); return 3
    mid = a[0].upper(); vd = os.path.join(ROOT, 'Doc', 'verify', mid); os.makedirs(vd, exist_ok=True)
    tf = os.path.join(ROOT, 'Doc', 'tobefacts', 'screens', mid)
    ep_path = os.path.join(tf, 'endpoints.csv'); endpoints = rd(ep_path)
    consts = rd(os.path.join(tf, 'constants.csv'))
    asis_meta = rd(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv'))
    from dbconn import connect
    out = []
    add = lambda c, t, r, d: out.append({'check': c, 'target': t, 'result': r, 'detail': d})
    with connect('tobe') as cx:
        c = cx.cursor()
        # M1
        c.execute("SELECT USE_YN FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID = :1", [mid]); row = c.fetchone()
        add('M1 메뉴', mid, 'PASS' if row and (row[0] or 'Y') == 'Y' else 'FAIL', f"SCM_ADM_MNU_M {'USE_YN=' + str(row[0]) if row else '행 없음'}")
        # 실시간 배선
        c.execute("""SELECT NVL(B.SHT_NM,'_DEFAULT_'), NVL(B.MNU_BTN_CD,'SEARCH'), B.API_ID, A.API_URL, A.USE_YN
                       FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B LEFT JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = B.API_ID WHERE B.MNU_ID = :1""", [mid])
        wire = {(s, b.upper()): (api, url, use) for s, b, api, url, use in c.fetchall()}
        # M2
        if not endpoints:
            add('M2 FE 호출 배선', mid, 'ERROR', f'[측정 경로 없음] TO-BE FE 사실 없음({os.path.relpath(ep_path, ROOT)}) — TobeFacts 추출 먼저')
        else:
            fc = fe_calls(endpoints, mid)
            age = time.strftime('%Y-%m-%d %H:%M', time.localtime(os.path.getmtime(ep_path)))
            if ('?', '?') in fc:
                add('M2 FE 호출 배선', '(식이 풀리지 않은 호출)', 'ERROR', f"[측정 경로 없음] 시트·버튼이 식이라 대조 불가 {len(fc[('?', '?')])}곳: {', '.join(fc[('?', '?')][:5])}")
            for (sh, btn), where in sorted(k for k in fc.items() if k[0] != ('?', '?')):
                w = wire.get((sh, btn))
                if not w:
                    add('M2 FE 호출 배선', f'{sh}/{btn}', 'FAIL', f"사내 DB 버튼 배선(SCM_ADM_MNU_BTN_MPG_M)에 없음 · FE {', '.join(where[:3])} · FE 사실 {age}")
                elif not w[1]:
                    add('M2 FE 호출 배선', f'{sh}/{btn}', 'FAIL', f'API_ID {w[0]} 가 SCM_ADM_API_M 에 없음(PROC 미연결) · FE {where[0]}')
                else:
                    add('M2 FE 호출 배선', f'{sh}/{btn}', 'PASS', f'→ {w[1]} · FE {where[0]}')
        # M3·M4 — 배선된 PROC 전부(FE 가 안 부르는 것도 등록돼 있으면 확인)
        procs = sorted({url for _, url, _ in wire.values() if url and '.' in url})
        pkgs = sorted({p.split('.')[0].upper() for p in procs})
        st = {}
        for i in range(0, len(pkgs), 200):
            part = pkgs[i:i + 200]
            c.execute(f"SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY') AND OBJECT_NAME IN ({','.join(':' + str(k + 1) for k in range(len(part)))})", part)
            for n, t, s in c.fetchall():
                st.setdefault(n, {})[t] = s
        for pk in pkgs:
            s = st.get(pk, {})
            c.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME = :1", [pk]); ne = c.fetchone()[0]
            ok = s.get('PACKAGE') == 'VALID' and s.get('PACKAGE BODY') == 'VALID' and not ne
            add('M3 PROC 실재', pk, 'PASS' if ok else 'FAIL', f"PACKAGE {s.get('PACKAGE', '없음')} · BODY {s.get('PACKAGE BODY', '없음')} · 컴파일 오류 {ne}")
        for p in procs:
            pk, pr = p.split('.', 1)
            c.execute("SELECT IN_OUT, POSITION FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME = :1 AND OBJECT_NAME = :2 AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION", [pk.upper(), pr.upper()])
            dba = c.fetchall()
            if not dba:
                c.execute("SELECT COUNT(*) FROM ALL_PROCEDURES WHERE OWNER='SCM_MGR' AND OBJECT_NAME = :1 AND PROCEDURE_NAME = :2", [pk.upper(), pr.upper()])
                if not c.fetchone()[0]:
                    add('M3 PROC 실재', p, 'FAIL', 'ALL_PROCEDURES 에 없음(PKG 에 이 PROC 없음)'); continue
            c.execute("SELECT COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M WHERE UPPER(PROC_NM) = :1 ORDER BY SORT_ORD", [p.upper()])
            ok, why = cmp_args(c.fetchall(), dba)
            add('M4 인자 메타', p, 'PASS' if ok else 'FAIL', why)
        # M5
        if not asis_meta:
            add('M5 컬럼 메타', mid, 'ERROR', '[측정 경로 없음] AS-IS 메타 사실 없음(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv)')
        else:
            c.execute("SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = :1", [mid])
            T, TL = {}, {}
            for s, col, lab, so in c.fetchall():
                T.setdefault(s, set()).add(col)
                TL[(s, col)] = ((lab or '').strip(), str(so if so is not None else '').split('.')[0])
            A, AL = {}, {}
            for r in asis_meta:
                if (r.get('VALID_YN') or 'Y') != 'N':
                    A.setdefault(r.get('SHEET_NAME', ''), set()).add(r.get('COLUMN_NAME', ''))
                    AL[(r.get('SHEET_NAME', ''), r.get('COLUMN_NAME', ''))] = ((r.get('COLUMN_LABEL_NAME') or '').strip(), str(r.get('SORT_ORDER_NO') or '').split('.')[0])
            for s in sorted(A):
                if s not in T:
                    add('M5 컬럼 메타', s, 'FAIL', f'TO-BE SCM_MST_SHEET_COLUMNS 에 이 시트 없음(AS-IS {len(A[s])}컬럼)')
                else:
                    # 대소문자만 다른 이름은 같은 컬럼으로 본다(2026-11-11 SSP0060 실측: AS-IS 'Expected_Shipping_Date' ↔ TO-BE 'EXPECTED_SHIPPING_DATE') — 근거에 표기
                    tu = {x.upper(): x for x in T[s]}; au = {x.upper(): x for x in A[s]}
                    case_only = sorted(x for x in A[s] if x not in T[s] and x.upper() in tu)
                    miss = sorted(x for x in A[s] if x.upper() not in tu); extra = sorted(x for x in T[s] if x.upper() not in au)
                    # 2026-11-11 T240(사용자 지적 · SSP0060 MKT_OWNER↔MTK_OWNER): 컬럼 ID 만 다르고 라벨·순번이 같은 쌍은 같은 자리의 컬럼이다.
                    #   AS-IS 는 메타 ID 와 SP 결과 컬럼이 어긋나 있을 수 있고 TO-BE 는 조회 결과 컬럼에 맞춰 둔다 → 누락과 구분해 표기(판정은 사용자 결정으로 FAIL 유지)
                    renamed = rename_pairs(miss, extra, lambda x: AL.get((s, x)), lambda x: TL.get((s, x)))
                    miss = [x for x in miss if x not in {a for a, _ in renamed}]
                    extra = [x for x in extra if x not in {b for _, b in renamed}]
                    # 2026-11-11 16:5x 사용자 결정: ID 만 다른 쌍도 계속 조치 필요(FAIL)로 남긴다 — 단 '누락'이 아니라 'ID 만 다름'임을 근거에 구분해 적는다
                    add('M5 컬럼 메타', s, 'FAIL' if (miss or renamed) else 'PASS', f"AS-IS {len(A[s])} · TO-BE {len(T[s])}컬럼"
                        + (f" · 컬럼 ID 만 다름(라벨·순번 같음 · 조치 필요 — TO-BE 는 메타·PKG·FE 가 같은 ID 를 쓰는지 함께 확인) {len(renamed)}: " + ', '.join(f'{a}↔{b}' for a, b in renamed[:6]) if renamed else '')
                        + (f" · TO-BE 에 없는 컬럼 {len(miss)}: {', '.join(miss[:8])}" if miss else '')
                        + (f" · TO-BE 에만 있는 컬럼 {len(extra)}: {', '.join(extra[:8])}" if extra else '') + (f" · 대소문자만 다름 {len(case_only)}: {', '.join(case_only[:4])}" if case_only else ''))
        # M6
        combos = sorted({(r.get('value') or '').strip() for r in consts if re.match(r'^COMBO\.', r.get('name') or '') and re.match(r'^[A-Za-z][\w]*$', (r.get('value') or '').strip())})
        if not combos:
            add('M6 콤보', mid, 'ERROR' if not consts else 'PASS', '[측정 경로 없음] FE 상수 사실 없음' if not consts else 'FE 상수에 COMBO.* 없음')
        for i in range(0, len(combos), 200):
            part = combos[i:i + 200]
            c.execute(f"SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ({','.join(':' + str(k + 1) for k in range(len(part)))})", part)
            got = {s: u for s, u in c.fetchall()}
            for s in part:
                add('M6 콤보', s, 'PASS' if got.get(s, '') == 'Y' else 'FAIL', f"SCM_ADM_CMBO_SQL_M {'USE_YN=' + str(got[s]) if s in got else '행 없음'}")
    with open(os.path.join(vd, 'meta_live_check.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(out)
    cnt = {}
    for r in out:
        cnt[(r['check'], r['result'])] = cnt.get((r['check'], r['result']), 0) + 1
    checks = sorted({r['check'] for r in out})
    print(f"[meta_live_check] {mid} {time.strftime('%Y-%m-%d %H:%M:%S')} (사내 DB 실시간)")
    for ck in checks:
        print(f"  {ck}: " + ' · '.join(f"{res} {cnt[(ck, res)]}" for res in ('PASS', 'FAIL', 'ERROR') if (ck, res) in cnt))
    for r in out:
        if r['result'] != 'PASS':
            print(f"  [{r['result']}] {r['check']} · {r['target']} — {r['detail'][:170]}")
    nf = sum(1 for r in out if r['result'] == 'FAIL')
    print(f"[meta_live_check] FAIL {nf} · ERROR {sum(1 for r in out if r['result'] == 'ERROR')} → Doc/verify/{mid}/meta_live_check.csv")
    return 2 if nf else 0


if __name__ == '__main__':
    sys.exit(main())
