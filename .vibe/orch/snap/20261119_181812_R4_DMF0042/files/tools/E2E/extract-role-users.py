#!/usr/bin/env python3
"""extract-role-users — SCP·SSP 권한 × Division 대표 사용자 추출 (사내오라클 실조회, 2026-10-27 사용자 지시)

  python tools/E2E/extract-role-users.py            # 조회·선정만 → Doc/e2e/role_users/role_users_<날짜>.csv / .md
  python tools/E2E/extract-role-users.py --apply    # + tools/E2E/users.json areas.SCP / areas.SSP 갱신(백업 후)

권한 (사용자 지정)  SCP = SCP Planner · SCP Tester · SCM Viewer · ADMIN · SCM PI Admin
                   SSP = SSP ADMIN · SSP Planner · SSP Viewer
Division 계열      40 · 81 · 82 (SCM_MST_DIVISION.ATTRIBUTE3 기준. EE 제외 — AS-IS SCP/SSP Division 콤보 원천
                   UP_FX_GetCommonDataList 'MyDivision' / _SCP 'Division' 이 ATTRIBUTE3 <> 'EE')
원천 (읽기 전용)   SCM_ADM_USER_M · SCM_ADM_USER_GR_M · SCM_ADM_USER_GR_MPG_M · SCM_ADM_USER_GR_UNIT_AUTH_MPG_M · SCM_ADM_USER_GR_MNU_MPG_M

선정 규칙 (권한 R × 계열 F 마다 1명)
  필수  사용자 USE_YN=Y · ACNT_LOK_YN=N / (R, 사용자) 그룹 매핑 USE_YN=Y / R 의 Division 권한(UNIT_TP_CD='D', USE_YN='Y') 에 계열 F 포함
  순위  ① 같은 영역(SCP·SSP) 메뉴를 가진 '다른' 활성 권한 그룹 수 적은 순 — 버튼 권한은 그룹 합집합이라 권한 경계가 흐려지지 않게
        ② R 의 Division 권한 계열 수 적은 순(F 하나뿐이 최선)
        ③ F 편집권한(EDIT_YN=Y) 보유 우선
        ④ 최근 로그인(LOGN_DTM) 순 → USER_ID
  사용  명부는 계정 풀이다 — 기본 테스트는 화면당 ADMIN/PLANNER 1계정, 권한×Division 전수는 사용자가 화면을 지정할 때만(users.json screens[ID].mode=division)
"""
import sys, os, csv, json, datetime, shutil, importlib.util, collections
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
ROLES = {'SCP': ['SCP Planner', 'SCP Tester', 'SCM Viewer', 'ADMIN', 'SCM PI Admin'], 'SSP': ['SSP ADMIN', 'SSP Planner', 'SSP Viewer']}
FAMILIES = ['40', '81', '82']
TODAY = datetime.date.today().strftime('%Y%m%d')

spec = importlib.util.spec_from_file_location('ora', os.path.join(ROOT, '_artifacts', '_diagnostics', 'ora.py'))
ora = importlib.util.module_from_spec(spec); spec.loader.exec_module(ora)
import oracledb


def q(cur, sql, **b):
    cur.execute(sql, b); cols = [c[0] for c in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]


def main():
    apply = '--apply' in sys.argv
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    ctx = q(cur, "SELECT SYS_CONTEXT('USERENV','SERVICE_NAME') SVC, SYS_CONTEXT('USERENV','SERVER_HOST') HOST, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL")[0]
    if (ctx['SVC'] or '').lower() != 'zioui1': sys.exit(f"사내오라클(zioui1) 아님: {ctx}")
    all_roles = sorted({r for rs in ROLES.values() for r in rs})
    binds = {f'r{i}': r for i, r in enumerate(all_roles)}; inl = ','.join(f':r{i}' for i in range(len(all_roles)))
    grp_use = {r['USER_GR_ID']: r['USE_YN'] for r in q(cur, f"SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_M WHERE USER_GR_ID IN ({inl})", **binds)}
    div_fam = {r['DIVISION_ID']: r['ATTRIBUTE3'] or r['DIVISION_ID'].split('_')[0] for r in q(cur, "SELECT DIVISION_ID, ATTRIBUTE3 FROM SCM_MST_DIVISION WHERE VALID_YN='Y'")}
    cand = q(cur, f"""
        SELECT G.USER_GR_ID, G.USER_ID, U.USER_NM, U.DEPT_ID, TO_CHAR(U.LOGN_DTM,'YYYY-MM-DD HH24:MI') LOGN_DTM, A.UNIT_ID, A.EDIT_YN
          FROM SCM_ADM_USER_GR_MPG_M G
          JOIN SCM_ADM_USER_M U ON U.USER_ID = G.USER_ID AND U.USE_YN = 'Y' AND U.ACNT_LOK_YN = 'N'
          JOIN SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A ON A.USER_GR_ID = G.USER_GR_ID AND A.USER_ID = G.USER_ID AND A.UNIT_TP_CD = 'D' AND A.USE_YN = 'Y'
         WHERE G.USE_YN = 'Y' AND G.USER_GR_ID IN ({inl})""", **binds)
    memb = collections.defaultdict(set)
    for r in q(cur, "SELECT USER_ID, USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USE_YN = 'Y'"): memb[r['USER_ID']].add(r['USER_GR_ID'])
    area_grp = collections.defaultdict(set)   # 영역 → 그 영역 메뉴를 가진 그룹
    for r in q(cur, "SELECT DISTINCT USER_GR_ID, SUBSTR(MNU_ID,1,3) AREA FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USE_YN = 'Y' AND (MNU_ID LIKE 'SCP%' OR MNU_ID LIKE 'SSP%')"): area_grp[r['AREA']].add(r['USER_GR_ID'])
    con.close()

    # (권한, 사용자) → 계열별 편집권한
    info = {}
    for r in cand:
        k = (r['USER_GR_ID'], r['USER_ID'])
        e = info.setdefault(k, {'name': r['USER_NM'], 'dept': r['DEPT_ID'], 'login': r['LOGN_DTM'] or '', 'fam': collections.defaultdict(lambda: 'N')})
        f = div_fam.get(r['UNIT_ID'], r['UNIT_ID'].split('_')[0])
        if r['EDIT_YN'] == 'Y' or e['fam'][f] != 'Y': e['fam'][f] = 'Y' if r['EDIT_YN'] == 'Y' else e['fam'][f]
    picks, rows = {}, []
    for area, roles in ROLES.items():
        for role in roles:
            for f in FAMILIES:
                cs = []
                for (rg, uid), e in info.items():
                    if rg != role or f not in e['fam']: continue
                    others = sorted(g for g in memb[uid] if g != role and g in area_grp[area])
                    cs.append({'uid': uid, 'name': e['name'], 'dept': e['dept'], 'login': e['login'], 'others': others,
                               'nfam': len(e['fam']), 'edit': e['fam'][f], 'fams': ','.join(sorted(e['fam']))})
                cs.sort(key=lambda c: (len(c['others']), c['nfam'], 0 if c['edit'] == 'Y' else 1, '' if c['login'] else 'z', [-ord(ch) for ch in c['login']], c['uid']))
                picks[(area, role, f)] = cs[0] if cs else None
                for rank, c in enumerate(cs[:3], 1):
                    rows.append([area, role, f, rank, c['uid'], c['name'], c['dept'] or '', c['login'], c['fams'], c['edit'], len(c['others']), ' / '.join(c['others']), len(cs), grp_use.get(role, '?')])
                if not cs: rows.append([area, role, f, 0, '', '', '', '', '', '', '', '', 0, grp_use.get(role, '?')])

    out = os.path.join(ROOT, 'Doc', 'e2e', 'role_users'); os.makedirs(out, exist_ok=True)
    hdr = ['영역', '권한', 'Division 계열', '순위', 'USER_ID', '이름', 'DEPT_ID', '최근 로그인', '보유 계열(해당 권한)', '해당 계열 편집권한', '같은 영역 다른 그룹 수', '같은 영역 다른 그룹', '후보 수', '권한 그룹 USE_YN']
    with open(os.path.join(out, f'role_users_{TODAY}.csv'), 'w', encoding='utf-8-sig', newline='') as fh: w = csv.writer(fh); w.writerow(hdr); w.writerows(rows)
    md = [f'# SCP·SSP 권한 × Division 대표 사용자 ({TODAY})', '',
          f"- 원천: 사내오라클 {ctx['SVC']} (SERVER_HOST={ctx['HOST']}, 조회 {ctx['NOW']}) — 읽기 전용", '- 선정 규칙: tools/E2E/extract-role-users.py 머리말 (필수 조건 + 순위 ①~④)',
          '- 사용 원칙: 명부는 계정 풀. 기본 테스트 = 화면당 ADMIN/PLANNER 1계정, 권한×Division 전수는 사용자가 화면을 지정할 때만', '',
          '| 영역 | 권한 | 40 | 81 | 82 | 비고 |', '|---|---|---|---|---|---|']
    for area, roles in ROLES.items():
        for role in roles:
            cells = []; notes = set()
            for f in FAMILIES:
                c = picks[(area, role, f)]
                if not c: cells.append('**없음**'); notes.add(f'{f} 후보 0'); continue
                cells.append(f"{c['uid']} ({c['name']})" + (f" ⚠다른 그룹 {len(c['others'])}" if c['others'] else ''))
                if c['others']: notes.add('다른 그룹: ' + ', '.join(c['others']))
            if grp_use.get(role) == 'N': notes.add('⚠ 권한 그룹 USE_YN=N(TO-BE 사용 안 함)')
            md.append(f"| {area} | {role} | " + ' | '.join(cells) + f" | {'; '.join(sorted(notes))} |")
    open(os.path.join(out, f'role_users_{TODAY}.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
    print('\n'.join(md))

    if apply:
        uf = os.path.join(HERE, 'users.json')
        shutil.copy2(uf, uf + f'.bak_{TODAY}_pre_role_users')
        U = json.load(open(uf, encoding='utf-8-sig'))
        areas = U.setdefault('areas', {})
        for area, roles in ROLES.items():
            A = areas.setdefault(area, {})
            A['_doc'] = f'{area} UI 권한 × Division 대표 사용자 — 사내오라클 추출({TODAY}, tools/E2E/extract-role-users.py · 근거 Doc/e2e/role_users/role_users_{TODAY}.md). 기본 테스트 1계정, 전수는 화면 지정 시만'
            A['appliesTo'] = f'{area}*'; A['roles'] = roles; A['extracted'] = f"{ctx['NOW']} {ctx['SVC']}"
            A['divisions'] = {f: {role: (picks[(area, role, f)] or {}).get('uid', '') for role in roles} for f in FAMILIES}
            A['groupDisabled'] = [r for r in roles if grp_use.get(r) == 'N']
            for f in FAMILIES:
                for role in roles:
                    c = picks[(area, role, f)]
                    if c: U.setdefault('names', {}).setdefault(c['uid'], c['name'])
        json.dump(U, open(uf, 'w', encoding='utf-8'), ensure_ascii=False, indent=2); open(uf, 'a', encoding='utf-8').write('\n')
        print(f'\nusers.json 갱신 — areas.SCP / areas.SSP (백업 users.json.bak_{TODAY}_pre_role_users)')


if __name__ == '__main__':
    main()
