# -*- coding: utf-8 -*-
"""pkg_asis_map.py — TO-BE PKG 원문에 적힌 AS-IS SP 이름으로 짝을 읽는다 (2026-11-11 · EN-02 ② 짝 = 기록된 사실)

배경(실측 2026-11-11): 차등 검증 SKIP 183건 중 141건이 "AS-IS 짝 없음". 짝을 이름 정규화 일치로 찾아서, 이름을 줄여 옮긴 PROC
(SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM → P_SSP0003_GET_CHG_REQ_CONFIRM)과 AS-IS 호출이 정적으로 안 풀린 화면(SCP0108)이 빠졌다.
이식한 사람이 PKG 원문에 남긴 기록을 읽는다 — 이름 유사도로 고르지 않는다.
  A  명세 주석   `<AS-IS SP>  ->  P_<TO-BE PROC>`
  B  명세 주석   `/* AS-IS <SP> */` 바로 다음 줄 `PROCEDURE P_<PROC>`
  C  본문 `PROCEDURE P_<PROC> (…) IS` ~ 첫 BEGIN 사이 `Program ID : <SP>` (2026-11-25 T532)
  (PROCEDURE 앞 머리말 `Program ID : <SP>` 는 쓰지 않는다 — 머리말 위치가 PKG 마다 달라 한 칸 어긋난 짝이 실측됨)
채택 조건: AS-IS SP 본문 파일(Doc/asisfacts/db/modules/dbo.<SP>.sql)이 실재 · 한 PROC 에 서로 다른 SP 가 적혀 있으면 CONFLICT 로 버린다(짝 없음으로 남김).

  python tools/Harness/verify/pkg_asis_map.py <PKG> [<PKG> …]    사내 ALL_SOURCE 를 읽어 출력
  python tools/Harness/verify/pkg_asis_map.py --selftest
"""
import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
MODULES = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules')
RX_ARROW = re.compile(r'\b([A-Za-z][A-Za-z0-9_]{5,})\s*-+>\s*(P_[A-Za-z0-9_]+)')
RX_ASIS = re.compile(r'/\*\s*AS-?IS\s*:?\s*([A-Za-z][A-Za-z0-9_]{5,})\s*\*/', re.I)
RX_PROC = re.compile(r'^\s*PROCEDURE\s+(P_[A-Za-z0-9_]+)', re.I)
RX_PGM = re.compile(r'Program\s*ID\s*:\s*([A-Za-z][A-Za-z0-9_]{5,})', re.I)


def asis_exists(sp):
    return os.path.exists(os.path.join(MODULES, f'dbo.{sp}.sql'))


def parse(pkg, spec_lines, body_lines, exists=asis_exists):
    """반환 = (map {PKG.P_PROC: (asis_sp, 근거)}, conflicts [(proc, {sp…})], dropped [(proc, sp, 사유)])"""
    cand = {}   # proc → {sp: 근거}
    def put(proc, sp, why):
        cand.setdefault(proc.upper(), {}).setdefault(sp.upper(), (sp, why))
    for i, l in enumerate(spec_lines):
        m = RX_ARROW.search(l)
        if m:
            put(m.group(2), m.group(1), f'명세 {i + 1}행 "{m.group(1)} -> {m.group(2)}"')
        m = RX_ASIS.search(l)
        if m:
            for j in range(i + 1, min(i + 4, len(spec_lines))):
                if not spec_lines[j].strip():
                    continue
                p = RX_PROC.match(spec_lines[j])
                if p:
                    put(p.group(1), m.group(1), f'명세 {i + 1}행 /* AS-IS {m.group(1)} */')
                break
    # 본문 머리말(Program ID)이 PROCEDURE 앞에 있으면 쓰지 않는다 — 2026-11-11 실측: 머리말이 PROCEDURE 앞에 있는 PKG 와 안에 있는 PKG 가 섞여 한 칸 어긋난 짝이 나왔다(PKG_SSP0021·0023·0060)
    # 2026-11-25 T532(SSP0014 차등 112행 '짝 없음'): PKG_SSP0014 가 11-24 13:55 재컴파일되며 명세 화살표 주석이 빠져 짝 7건(SSP0014 3 · SCP0028 4)이 사라졌다.
    #   C = 본문 `PROCEDURE P_X (…) IS` 와 첫 BEGIN 사이(선언부)의 `Program ID : <SP>` — 그 PROCEDURE 안에 있으므로 어긋날 수 없다. 앞쪽 머리말은 여전히 쓰지 않는다.
    cur, state, c_dropped = None, None, []
    for i, l in enumerate(body_lines):
        p = RX_PROC.match(l)
        if p:
            cur, state = p.group(1), 'head'
        if cur and state == 'head' and re.search(r'(?i)(^|\)|\s)(IS|AS)\s*(--.*)?$', l):
            state = 'decl'
            continue
        if state == 'decl':
            if re.match(r'(?i)^\s*BEGIN\b', l):
                cur, state = None, None
                continue
            m = RX_PGM.search(l)
            if m:
                # 전 PKG 144개 대조(11-25 02:5x): 선언부 머리말을 복사해 다른 SP 를 적은 PROC 3개(PKG_DMF0000 1 · PKG_SSP0060 2) —
                #   PROC 이름(P_ 제거)과 같은 AS-IS SP 가 따로 있으면 머리말을 버린다(이름 일치 짝에 맡김)
                same = re.sub(r'(?i)^P_', '', cur)
                if same.upper() != m.group(1).upper() and exists(same):
                    c_dropped.append((cur.upper(), m.group(1), f'본문 {i + 1}행 선언부 머리말이 이름 같은 AS-IS SP {same} 와 다름'))
                else:
                    put(cur, m.group(1), f'본문 {i + 1}행 PROCEDURE {cur} 선언부 Program ID "{m.group(1)}"')
    out, conflicts, dropped = {}, [], list(c_dropped)
    for proc, sps in cand.items():
        live = {k: v for k, v in sps.items() if exists(v[0])}
        for k, v in sps.items():
            if k not in live:
                dropped.append((proc, v[0], 'AS-IS SP 본문 파일 없음'))
        if len(live) > 1:
            conflicts.append((proc, sorted(v[0] for v in live.values())))
        elif len(live) == 1:
            sp, why = list(live.values())[0]
            out[f'{pkg.upper()}.{proc}'] = (sp, why)
    # 한 AS-IS SP 가 여러 PROC 에 적힌 경우는 그대로 둔다(1:N 이식 — 호출 쪽이 PROC 을 고른다)
    return out, conflicts, dropped


def read_live(pkgs):
    """사내 ALL_SOURCE → {pkg: (spec_lines, body_lines)}. 접속 실패는 예외 그대로(호출자가 미측정으로 처리)"""
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
    import dbconn
    cfg = dbconn.load_cfg()
    schema = (dbconn.resolve('tobe', cfg).get('schema') or '').upper()
    cx = dbconn.connect('tobe', cfg)
    cur = cx.cursor()
    res = {}
    for pkg in pkgs:
        cur.execute("SELECT type, text FROM all_source WHERE owner = :o AND name = :n AND type IN ('PACKAGE', 'PACKAGE BODY') ORDER BY type, line", o=schema, n=pkg.upper())
        spec, body = [], []
        for typ, text in cur.fetchall():
            (spec if typ == 'PACKAGE' else body).append((text or '').rstrip('\n'))
        res[pkg.upper()] = (spec, body)
    cx.close()
    return res


def live_map(pkgs):
    """{PKG.P_PROC: (asis_sp, 근거)} + 보고 문자열 목록"""
    out, notes = {}, []
    for pkg, (spec, body) in read_live(sorted(set(p.upper() for p in pkgs))).items():
        if not spec and not body:
            notes.append(f'{pkg}: 사내 ALL_SOURCE 에 없음')
            continue
        m, cf, dr = parse(pkg, spec, body)
        out.update(m)
        for proc, sps in cf:
            notes.append(f'{pkg}.{proc}: CONFLICT — 원문에 서로 다른 AS-IS SP {sps} (짝 미채택)')
        for proc, sp, why in dr:
            notes.append(f'{pkg}.{proc}: {sp} 미채택 — {why}')
    return out, notes


def selftest():
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)
    ex = lambda sp: sp.upper() in ('SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM', 'SCP0108_GET_CAPA_LOB', 'SSP0014_GET_SHIPMENT_MODEL_PIC', 'OTHER_SP_NAME')
    spec = [' *   SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM     -> P_SSP0003_GET_CHG_REQ_CONFIRM',
            '/* AS-IS SCP0108_GET_CAPA_LOB */', 'PROCEDURE P_SCP0108_GET_CAPA_LOB', '(', ');',
            '/* AS-IS NOT_EXISTING_SP_NAME */', 'PROCEDURE P_GHOST']
    body = ['/*', ' * Program ID   : SSP0014_GET_SHIPMENT_MODEL_PIC', ' */', 'PROCEDURE P_SSP0014_GET_MODEL_PIC', 'IS', 'BEGIN', 'END;']
    m, cf, dr = parse('PKG_X', spec, body, ex)
    t('A 화살표 기록 → 짝', m.get('PKG_X.P_SSP0003_GET_CHG_REQ_CONFIRM', ('',))[0] == 'SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM')
    t('B /* AS-IS */ 다음 PROCEDURE → 짝', m.get('PKG_X.P_SCP0108_GET_CAPA_LOB', ('',))[0] == 'SCP0108_GET_CAPA_LOB')
    t('본문 Program ID 머리말만으로는 짝을 만들지 않는다(어긋남 방지)', 'PKG_X.P_SSP0014_GET_MODEL_PIC' not in m)
    t('AS-IS 본문 파일 없는 이름은 미채택(변이)', 'PKG_X.P_GHOST' not in m and any(d[0] == 'P_GHOST' for d in dr))
    m2, cf2, _ = parse('PKG_X', spec + [' * OTHER_SP_NAME -> P_SCP0108_GET_CAPA_LOB'], body, ex)
    t('한 PROC 에 서로 다른 SP 기록 = CONFLICT · 미채택(변이)', 'PKG_X.P_SCP0108_GET_CAPA_LOB' not in m2 and len(cf2) == 1)
    m3, _, _ = parse('PKG_X', ['PROCEDURE P_NO_RECORD'], ['PROCEDURE P_NO_RECORD', 'IS'], ex)
    t('기록 없는 PROC 은 짝을 만들지 않는다', m3 == {})
    m4, _, _ = parse('PKG_X', ['/* AS-IS SCP0108_GET_CAPA_LOB */', '', 'FUNCTION F_X RETURN NUMBER;', 'PROCEDURE P_LATER'], [], ex)
    t('/* AS-IS */ 바로 다음이 PROCEDURE 가 아니면 잇지 않는다', m4 == {})
    # T532: 선언부(IS ~ 첫 BEGIN) 안 Program ID = 짝 · 앞 PROCEDURE 의 BEGIN 뒤·다음 PROCEDURE 앞 머리말은 짝 아님
    b5 = ['PROCEDURE P_SSP0014_GET_MODEL_PIC', '(', '    P_A IN VARCHAR2', ')', 'IS', '/*', ' * Program ID   : SSP0014_GET_SHIPMENT_MODEL_PIC', ' */',
          '  V_X NUMBER;', 'BEGIN', '  NULL;', 'END P_SSP0014_GET_MODEL_PIC;',
          '/*', ' * Program ID   : SCP0108_GET_CAPA_LOB', ' */', 'PROCEDURE P_NEXT', 'IS', 'BEGIN', 'NULL;', 'END;']
    m5, _, _ = parse('PKG_X', [], b5, ex)
    t('C 본문 선언부 Program ID → 짝', m5.get('PKG_X.P_SSP0014_GET_MODEL_PIC', ('',))[0] == 'SSP0014_GET_SHIPMENT_MODEL_PIC')
    t('C PROCEDURE 앞 머리말은 다음 PROC 짝이 아님(변이)', 'PKG_X.P_NEXT' not in m5)
    m6, _, _ = parse('PKG_X', [], ['PROCEDURE P_GHOST (P_A IN VARCHAR2) IS', ' * Program ID : NOT_EXISTING_SP_NAME', 'BEGIN', 'END;'], ex)
    t('C AS-IS 파일 없는 Program ID 는 미채택(변이)', m6 == {})
    m7, cf7, _ = parse('PKG_X', [' * OTHER_SP_NAME -> P_SSP0014_GET_MODEL_PIC'], b5, ex)
    t('C 명세 기록과 본문 기록이 다르면 CONFLICT(변이)', 'PKG_X.P_SSP0014_GET_MODEL_PIC' not in m7 and len(cf7) == 1)
    m8, _, d8 = parse('PKG_X', [], ['PROCEDURE P_SCP0108_GET_CAPA_LOB IS', ' * Program ID : OTHER_SP_NAME', 'BEGIN', 'END;'], ex)
    t('C PROC 이름과 같은 AS-IS SP 가 있고 머리말이 다르면 미채택(변이 · 복사 머리말)', m8 == {} and any(d[0] == 'P_SCP0108_GET_CAPA_LOB' for d in d8))
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a:
        print(__doc__)
        return 3
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass
    m, notes = live_map(a)
    for k in sorted(m):
        print(f'{k:<60} ← {m[k][0]:<52} {m[k][1]}')
    for n in notes:
        print('  ! ' + n)
    print(f'[pkg_asis_map] 짝 {len(m)} · 참고 {len(notes)}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
