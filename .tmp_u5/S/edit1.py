import sys
p = r'C:\Projects\NSCM\tools\Harness\verify\gen_param_map.py'
b = open(p, 'rb').read().decode('utf-8')
crlf = '\r\n' in b
s = b.replace('\r\n', '\n')
anchor = "def build(mids):\n"
assert s.count(anchor) == 1
func = '''# T560(2026-11-25 SCP0005 A6·A7·A1·DB-SYN 7행): PKG_SCP0005 짝 3건(GET_DISTRIBUTION_ROUTEID → P_SCP0005_GET_ROUTEID 등)이 'TO-BE proc 미매칭'.
#   PKG 원문 기록이 PROCEDURE 바로 앞 머리말 'Program ID : [SP]'(괄호 포함, 본문 575·734·944행)뿐이라 pkg_asis_map(선언부·명세 주석만)이 못 읽었다.
#   머리말 짝은 한 칸 어긋남(11-11 실측)이 있어 조건 3개를 다 만족할 때만 쓴다: ① 주석 끝 '*/' 바로 다음 줄이 PROCEDURE ② PROC 이름(P_ 제거)이 다른 AS-IS SP 로 따로 있지 않음
#   ③ AS-IS 입력 인자 집합(debug_mode 제외) = TO-BE IN 인자 집합(exact_key). 셋 중 하나라도 어긋나면 짝을 만들지 않는다(종전 '미매칭' 유지)
RX_HDR_PGM = re.compile(r'Program\s*ID\s*:\s*\[?\s*([A-Za-z][A-Za-z0-9_]{5,})\s*\]?', re.I)
RX_HDR_PROC = re.compile(r'^\s*PROCEDURE\s+(P_[A-Za-z0-9_]+)', re.I)


def header_pairs(pkg, body_lines, asis_in, tobe_in, exists=lambda sp: os.path.exists(os.path.join(MODULES, f'dbo.{sp}.sql'))):
    """PROCEDURE 바로 앞 머리말 주석의 Program ID → {PKG.P_PROC: (asis_sp, 근거)} · asis_in {SP: [인자]} · tobe_in {PKG.PROC: [인자]}"""
    out = {}
    dbg = lambda n: re.match(r'(?i)^@?(p_)?debug', n or '')
    for i, l in enumerate(body_lines):
        m = RX_HDR_PROC.match(l)
        if not m:
            continue
        j = i - 1
        while j >= 0 and not body_lines[j].strip():
            j -= 1
        if j < 0 or not body_lines[j].rstrip().endswith('*/'):
            continue
        k = j
        while k >= 0 and '/*' not in body_lines[k] and j - k < 60:
            k -= 1
        if k < 0 or '/*' not in body_lines[k]:
            continue
        sps = {x.group(1).upper(): x.group(1) for ln in body_lines[k:j + 1] for x in [RX_HDR_PGM.search(ln)] if x}
        if len(sps) != 1:
            continue
        sp = list(sps.values())[0]; proc = m.group(1); full = f'{pkg.upper()}.{proc.upper()}'
        same = re.sub(r'(?i)^P_', '', proc)
        if not exists(sp) or (same.upper() != sp.upper() and exists(same)):
            continue
        a = {exact_key(n) for n in asis_in.get(sp.upper(), []) if not dbg(n)}
        t = {exact_key(n) for n in tobe_in.get(full, []) if not dbg(n)}
        if not a or a != t:
            continue
        out[full] = (sp, f'본문 {k + 1}~{j + 1}행 PROCEDURE {proc} 바로 앞 머리말 Program ID "{sp}" · 입력 인자 {len(a)}개 이름 일치(T560)')
    return out


def _selftest_header_pairs():
    body = ['    /*====', '     * Program ID   : [SCP_X_GET_ROUTEID]', '     *====*/', '    PROCEDURE P_X_GET_RID', '    (',
            '    /*====', '     * Program ID   : [SCP_Y_GET_CITY]', '     *====*/', '', '    PROCEDURE P_X_GET_CITY',
            '    /*====', '     * Program ID   : SCP_X_SAVE', '     */', '    PROCEDURE P_X_SAVE', '    -- gap', '    /* Program ID : SCP_X_GAP */', '    V := 1;', '    PROCEDURE P_X_GAP']
    ex = {'SCP_X_GET_ROUTEID', 'SCP_Y_GET_CITY', 'X_GET_CITY', 'SCP_X_SAVE', 'SCP_X_GAP'}
    ai = {'SCP_X_GET_ROUTEID': ['@p_route_id'], 'SCP_Y_GET_CITY': ['@p_country'], 'SCP_X_SAVE': ['@p_route_id', '@p_user_id', '@debug_mode'], 'SCP_X_GAP': ['@p_a']}
    ti = {'PKG.P_X_GET_RID': ['routeId'], 'PKG.P_X_GET_CITY': ['country'], 'PKG.P_X_SAVE': ['routeId', 'userId'], 'PKG.P_X_GAP': ['a']}
    r = header_pairs('PKG', body, ai, ti, exists=lambda s: s.upper() in ex)
    cases = [('T560 괄호 머리말 + 인자 일치 = 짝', r.get('PKG.P_X_GET_RID', ('',))[0] == 'SCP_X_GET_ROUTEID'),
             ('T560 PROC 이름의 AS-IS SP 가 따로 있으면 버림(변이)', 'PKG.P_X_GET_CITY' not in r),
             ('T560 debug_mode 는 인자 비교에서 뺌', r.get('PKG.P_X_SAVE', ('',))[0] == 'SCP_X_SAVE'),
             ('T560 주석과 PROCEDURE 사이에 문장이 있으면 버림(변이)', 'PKG.P_X_GAP' not in r)]
    ti2 = dict(ti); ti2['PKG.P_X_GET_RID'] = ['routeId', 'langCd']
    cases.append(('T560 인자 집합이 다르면 버림(변이)', 'PKG.P_X_GET_RID' not in header_pairs('PKG', body, ai, ti2, exists=lambda s: s.upper() in ex)))
    bad = [n for n, ok in cases if not ok]
    for n, ok in cases:
        print(('PASS ' if ok else 'FAIL ') + n)
    return 1 if bad else 0


'''
s = s.replace(anchor, func + anchor)
# integration after rec_note print loop
anchor2 = "    for n in rec_note:\n        print('   ~ ' + n)\n"
assert s.count(anchor2) == 1
add = anchor2 + '''    # T560: 명세·선언부 기록이 없는 PROC 은 PROCEDURE 바로 앞 머리말(조건 3개)로 짝을 읽는다
    try:
        _have = {p_.upper() for lst in rec_by_sp.values() for p_, _, _ in lst}
        _ain = {k: [n for _, n, _ in v] for k, v in asis_params.items()}
        _tin = {k: [n for _, n, _ in v] for k, v in tobe_in.items()}
        for _pkg, (_spec, _body) in (pkg_asis_map.read_live(want).items() if want else []):
            for _proc, (_sp, _why) in header_pairs(_pkg, _body, _ain, _tin).items():
                if _proc not in _have:
                    rec_by_sp.setdefault(_sp.upper(), []).append((_proc, _sp, _why)); print(f'   ~ {_proc}: 머리말 짝 {_sp} (T560)')
    except Exception as e:  # 접속 실패 = 머리말 짝 미측정(종전 동작) — 숨기지 않고 출력
        print(f'   ~ [미측정] 머리말 짝을 읽지 못함({type(e).__name__}: {str(e)[:120]})')
'''
s = s.replace(anchor2, add)
anchor3 = "def main():\n    mids = "
assert s.count(anchor3) == 1
s = s.replace(anchor3, "def main():\n    if '--selftest' in sys.argv[1:]:\n        return _selftest_header_pairs()\n    mids = ")
open(p, 'wb').write((s.replace('\n', '\r\n') if crlf else s).encode('utf-8'))
print('ok')
