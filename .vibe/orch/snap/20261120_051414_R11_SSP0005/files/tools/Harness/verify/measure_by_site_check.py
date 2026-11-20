# -*- coding: utf-8 -*-
"""Sales Site 유형별 입력 Measure 허용 목록(B5 · EG068 · DM-37/DM-135/DM-139/DM-153) — Doc/verify/<ID>/measure_by_site.csv (2026-11-03)

  python -I tools/Harness/verify/measure_by_site_check.py <ID>

  대상 : 화면의 신규 행 Measure 편집 콤보(AS-IS facts combo_src.csv GRID 행의 TO-BE 콤보 ID: MktFcstEditMeasure · FcstPriceEditMeasure 등 'EditMeasure' 를 포함하는 코드)
  표본 : 버킷 파라미터(@bucketType)가 있는 콤보는 주간 'W' 로 고정 · DB 에서 사업부별 Sales Site 3유형 — VMI(SCM_MST_SITE.VMI_YN='Y') · 비축(AS_SITE_PLANT LOOKUP SEGMENT1) · 고객향(둘 다 아님) 각 1곳(VALID_YN='Y')
  방법 : SCM_ADM_CMBO_SQL_M 최신 SQL 을 BE 와 같은 치환(combo_live_check.subst)으로 실행 → CODE 집합
  기대 : 문서 규칙(DM-37 · DM-135 · DM-139 · TO-BE SQL 주석 동일) — VMI 사이트 → VMI_In_Req 포함(DM-139: 40·82 사업부만 · 그 외 사업부는 VMI 사이트도 제외) · 비축 → AS_In_Req 포함·VMI_In_Req 제외 · 고객향 → 둘 다 제외 (MKT_FCST 계열 포함 여부는 화면·관리자 Measure 설정(DM-139 GET_ADMIN_GROUP_MEASURE)에 따르므로 단언하지 않는다)
         AS_In_Req 는 DM Planner(W/S) 권한 계정 기준(기본 계정 가정 — DM-139 81/81_JV/82 W/S 권한만)
         (측정은 코드 접두 비교: ^VMI_In_Req · ^AS_In_Req · ^MKT_FCST — 화면별 코드 변형(MKT_FCST_RP/MKT_FCST) 허용)
  판정 : 기대 충족 PASS · 어긋남 FAIL(코드 목록 증거) · 표본 없음/SQL 없음/실행 오류 ERROR
  변이 : CL_MUTATE=1 → 고객향 표본을 VMI 표본으로 바꿔 넣어 FAIL 경로 확인(자기검증용)
"""
import csv, os, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
COLS = ['combo_id', 'division', 'site_type', 'site', 'codes', 'result', 'why']
EXPECT = {'VMI': ({'VMI_In_Req'}, set()), 'AS': ({'AS_In_Req'}, {'VMI_In_Req'}), 'CUST': (set(), {'VMI_In_Req', 'AS_In_Req'})}


def judge(site_type, codes, division='82'):
    """순수 판정 — codes: 콤보 CODE 집합. division 이 40/82 가 아니면 VMI 사이트도 VMI_In_Req 제외(DM-139). (result, why)"""
    if not codes:
        return 'ERROR', f"[확인 대상] {site_type} 사이트 후보 0건 — 사업부 {division} 의 편집 Measure 설정(DM_UI_EDITABLE_MEASURE 등) 자체가 없는지 확인 필요(규칙 판정 불가)"
    must, mustnot = EXPECT[site_type]
    if site_type == 'VMI' and division not in ('40', '82'):
        must, mustnot = set(), {'VMI_In_Req'}
    has = lambda pre: any(c.startswith(pre) for c in codes)
    bad = []
    for m in must:
        if not has(m): bad.append(f'{m} 없음')
    for m in mustnot:
        if has(m): bad.append(f'{m} 있음')
    why = f"{site_type} 사이트 후보 {len(codes)}건: {', '.join(sorted(codes))[:160]}"
    return ('FAIL', why + ' · ' + ' / '.join(bad)) if bad else ('PASS', why)


def selftest():
    assert judge('VMI', {'MKT_FCST_RP', 'VMI_In_Req'})[0] == 'PASS'
    assert judge('VMI', {'MKT_FCST_RP'})[0] == 'FAIL' and judge('CUST', {'LOC'})[0] == 'PASS'
    assert judge('AS', {'MKT_FCST_RP', 'AS_In_Req'})[0] == 'PASS'
    assert judge('AS', {'MKT_FCST_RP', 'AS_In_Req', 'VMI_In_Req'})[0] == 'FAIL'
    assert judge('CUST', {'MKT_FCST'})[0] == 'PASS' and judge('CUST', set())[0] == 'ERROR'
    assert judge('CUST', {'MKT_FCST', 'AS_In_Req'})[0] == 'FAIL'
    assert judge('VMI', {'MKT_FCST_RP'}, '81')[0] == 'PASS' and judge('VMI', {'MKT_FCST_RP', 'VMI_In_Req'}, '81')[0] == 'FAIL'
    print('selftest ok')


def combo_ids(mid):
    p = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid, 'combo_src.csv')
    if not os.path.exists(p): return []
    out = []
    for r in csv.DictReader(open(p, encoding='utf-8-sig', newline='')):
        c = (r.get('code') or '').strip()
        if r.get('target_kind') == 'GRID' and 'editmeasure' in c.replace('_', '').lower() and c not in out:
            out.append(c)
    return out


def main(mid):
    from dbconn import connect
    from combo_live_check import subst, default_user
    ids = combo_ids(mid)
    vd = os.path.join(ROOT, 'Doc', 'verify', mid); os.makedirs(vd, exist_ok=True)
    out = os.path.join(vd, 'measure_by_site.csv')
    res = []
    if not ids:
        print(f'[measure_by_site] {mid}: Measure 편집 콤보(EditMeasure) 없음 — 대상 아님');
        with open(out, 'w', encoding='utf-8-sig', newline='') as f: csv.DictWriter(f, COLS).writeheader()
        return 0
    user = default_user(); mutate = os.environ.get('CL_MUTATE') == '1'
    with connect('tobe') as cx:
        cur = cx.cursor()
        cur.execute("SELECT DISTINCT DIVISION_ID FROM SCM_MGR.SCM_MST_SITE WHERE VALID_YN = 'Y' AND DIVISION_ID IN ('40','81','82') ORDER BY 1")
        divs = [r[0] for r in cur.fetchall()]
        cur.execute("SELECT SQL_ID FROM SCM_MGR.SCM_ADM_CMBO_SQL_M"); all_ids = {str(r[0]).replace('_', '').lower(): str(r[0]) for r in cur.fetchall()}
        for cid0 in ids:
            cid = all_ids.get(cid0.replace('_', '').lower(), cid0)
            cur.execute("SELECT DBMS_LOB.SUBSTR(SQL_DTL_CTN, 4000, 1) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :1", [cid]); row = cur.fetchone()
            if not row:
                res.append({'combo_id': cid, 'division': '', 'site_type': '', 'site': '', 'codes': '', 'result': 'ERROR', 'why': '[확인 대상] SCM_ADM_CMBO_SQL_M 에 SQL 없음'}); continue
            sql = str(row[0])
            for div in divs:
                samples = {}
                cur.execute("SELECT SCM_SITE_ID FROM SCM_MGR.SCM_MST_SITE WHERE VALID_YN='Y' AND DIVISION_ID=:1 AND VMI_YN='Y' AND ROWNUM=1", [div]); r1 = cur.fetchone(); samples['VMI'] = r1[0] if r1 else ''
                cur.execute("SELECT S.SCM_SITE_ID FROM SCM_MGR.SCM_MST_SITE S WHERE S.VALID_YN='Y' AND S.DIVISION_ID=:1 AND NVL(S.VMI_YN,'N')<>'Y' AND S.SCM_SITE_ID IN (SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='AS_SITE_PLANT' AND VALID_YN='Y' AND (SEGMENT3 IS NULL OR SEGMENT3=:2)) AND ROWNUM=1", [div, div]); r2 = cur.fetchone(); samples['AS'] = r2[0] if r2 else ''
                cur.execute("SELECT S.SCM_SITE_ID FROM SCM_MGR.SCM_MST_SITE S WHERE S.VALID_YN='Y' AND S.DIVISION_ID=:1 AND NVL(S.VMI_YN,'N')<>'Y' AND S.SCM_SITE_ID NOT IN (SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='AS_SITE_PLANT' AND VALID_YN='Y') AND ROWNUM=1", [div]); r3 = cur.fetchone(); samples['CUST'] = r3[0] if r3 else ''
                if mutate and samples['VMI']: samples['CUST'] = samples['VMI']
                for st_, site in samples.items():
                    if not site:
                        res.append({'combo_id': cid, 'division': div, 'site_type': st_, 'site': '', 'codes': '', 'result': 'ERROR', 'why': f'[측정 경로 없음] {div} 사업부에 {st_} 유형 유효 사이트 표본 없음'}); continue
                    s2, miss = subst(sql, {'divisionId': f"'{div}'", 'scmSiteId': f"'{site}'", 'projectCode': "''", 'measure': "''", 'bucketType': "'W'", 'mnuId': mid}, user)
                    try:
                        cur.execute(s2); rows = cur.fetchall()
                    except Exception as e:
                        res.append({'combo_id': cid, 'division': div, 'site_type': st_, 'site': site, 'codes': '', 'result': 'ERROR', 'why': f'[확인 대상] 콤보 SQL 실행 오류 {str(e)[:120]}'}); continue
                    codes = {str(r[0]) for r in rows if r[0] is not None}
                    r_, why = judge(st_, codes, div)
                    if miss and (not codes or r_ == 'FAIL'):
                        r_, why = 'ERROR', f"[확인 대상] 콤보 SQL 파라미터 {miss} 를 화면 입력 없이 채울 수 없어(''로 치환) 후보 {len(codes)}건 — {why}"
                    res.append({'combo_id': cid, 'division': div, 'site_type': st_, 'site': site, 'codes': ';'.join(sorted(codes)), 'result': r_, 'why': f"{why} · 표본 {site}" + (' · [변이 CL_MUTATE]' if mutate else '')})
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, COLS); w.writeheader(); w.writerows(res)
    for x in res:
        print(f"[measure_by_site] {mid} {x['combo_id']} {x['division']} {x['site_type']}: {x['result']} {x['why'][:160]}")
    return 0


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest': selftest(); sys.exit(0)
    if len(sys.argv) < 2: sys.exit(__doc__)
    sys.exit(main(sys.argv[1]))
