"""B7 기준 데이터 변경 후 후보 갱신 — (a) 이 화면 저장이 콤보 원천을 바꾸는가 정적 대조 (2026-10-28)

사용자 요청(10-27): 단위테스트 두 시트 오류(DMF0004 저장한 Sales Site 가 조회조건 콤보에 안 보임 · DMF0005 Team 저장 후 재바인딩 ·
  LOOKUP 신규 End Customer 가 셀 콤보에 안 보임 · SSPM DEPT 변경이 재조회에 안 보임)가 다른 화면에 같은 형태로 있으면 찾아야 한다.

두 갈래
  (a) 자기 저장 → 콤보  : 이 화면 저장 SP 가 쓰는 테이블 ∩ 콤보 원천 SQL 이 읽는 테이블. 겹치면 저장 직후 그 콤보가 갱신돼야 한다
                         (AS-IS = 저장 후 재바인딩 호출 여부, TO-BE = 공용 useInvalidateCombos 호출 — packages/shared/src/hooks/useCustomQueryClient.ts)
                         겹치지 않으면 이 화면 저장으로 바뀌는 후보가 없다 → NA(근거 = 두 테이블 목록)
  (b) 외부 변경 → 재진입 : 다른 화면·배치가 마스터를 바꾼 뒤 이 화면을 다시 열면 새 후보가 보여야 한다 — _verify.spec @verify 'B7' 테스트(재진입 시 admin/combo 재조회 실측)
원천
  AS-IS 콤보 원천 = Doc/asisfacts/screens/<ID>/combo_src.csv (sp·code) → AS-IS DB sys.sql_modules 원문(UP_FX_* 는 @Code 분기 본문만 — combo_oracle.branch_sql)
  AS-IS 저장 SP  = Doc/golden/golden_cases.csv kind=SAVE · DML 대상 = save_audit.asis_targets (로그·임시 제외)
  TO-BE 화면 소스 = nscm-fe/features/*/src/pages/** 중 이 화면 MENU_ID 를 쓰는 폴더
  python b7_check.py <MENU_ID> [--asis <AS-IS ID>]   → Doc/verify/<ID>/b7_check.json
"""
import csv, datetime, glob, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
import combo_oracle as co  # noqa: E402
import save_audit as sa  # noqa: E402
from dbconn import connect  # noqa: E402

TBL = re.compile(r'(?i)\b(?:FROM|JOIN)\s+(?:\[?\w+\]?\.)?\[?(?:dbo\]?\.)?\[?([A-Za-z_]\w*)\]?')


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


_SSP_BF = None


def ssp_bigfilter_sets(text=None):
    """2026-11-20 T380(SSP0014 B7 판정필요 6행 '원천 미확인 cboDivision, cboOperationGroup'): SSP/Common/BigFilter.xml list_line_ssp 의
    N번째 결과셋 = N번째 'SELECT * FROM @T…' 직전 블록의 INSERT … EXEC [SP] @Code='X', @Param1='Y' — 결과셋 번호 → (SP, @Code, @Param1).
    결과셋 번호는 facts_combosrc.SSP_INNER(DataService.GetSSPInnerTable 열 → 번호). 순수 함수(text 를 주면 파일을 읽지 않음)"""
    global _SSP_BF
    if text is None and _SSP_BF is not None:
        return _SSP_BF
    import facts_combosrc as fc
    t = text if text is not None else fc.read_text(co.BIGFILTER_SSP)
    b = t[t.find('list_line_ssp'):] if 'list_line_ssp' in t else t
    if '<![CDATA[' in b:
        b = b[b.find('<![CDATA[') + 9:b.find(']]>')]
    pat = re.compile(r"(?is)EXEC\s+\[?(?:dbo\]?\.\[?)?(\w+)\]?\s+@Code\s*=\s*'([^']*)'(?:\s*,\s*@Param1\s*=\s*(?:'([^']*)'|@\w+))?")
    out, prev = [], 0
    for m in re.finditer(r'(?i)\bSELECT\s+\*\s+FROM\s+@\w+', b):
        ms = list(pat.finditer(b[prev:m.start()]))
        prev = m.end()
        out.append((ms[-1].group(1), ms[-1].group(2), ms[-1].group(3) or '') if ms else None)
    if text is None:
        _SSP_BF = out
    return out


def src_tables(cx, sp, code):
    """콤보 원천이 읽는 테이블 — UP_FX_* 는 @Code 분기 본문, 전용 SP 는 원문 전체"""
    if sp.startswith('SSP_BIGFILTER') and code:
        import facts_combosrc as fc
        spec = fc.SSP_INNER.get(code)
        sets = ssp_bigfilter_sets()
        if spec and spec[0] < len(sets) and sets[spec[0]]:
            isp, icode, p1 = sets[spec[0]]
            ts, where = src_tables(cx, isp, icode)
            return ts, f"SSP_BIGFILTER {code} = BigFilter.xml list_line_ssp 결과셋 {spec[0]} → {where}{f' (@Param1={p1})' if p1 else ''}"
        return None, f'원천 SP 없음/BigFilter(SSP_BIGFILTER {code} 결과셋 번호 미등록)'
    if sp in ('STATIC', '') or sp.startswith(('DM_BIGFILTER', 'SSP_BIGFILTER')):
        return None, ('고정 목록' if sp == 'STATIC' else '원천 SP 없음/BigFilter')
    if code and sp.upper().startswith('UP_FX_'):
        sql = co.branch_sql(type('A', (), {'cx': cx})(), sp, code)
        where = f'{sp} @Code={code} 분기'
    else:
        c = cx.cursor()
        c.execute("SELECT m.definition FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id WHERE o.name=?", sp)
        r = c.fetchone()
        sql = r[0] if r else ''
        where = f'{sp} 원문'
    if not sql:
        return None, f'{where} 원문 없음'
    ts = {t.upper() for t in TBL.findall(sql) if not t.startswith(('#', '@')) and t.upper() not in ('DUAL', 'SELECT', 'STRING_SPLIT', 'OPENJSON')}
    # 원천이 사용자 함수(FN_*)를 FROM 으로 읽으면 함수 원문의 테이블까지 한 단계 전개(FN_GET_DIVISION 등)
    c = cx.cursor()
    for fn in sorted(t for t in ts if t.startswith('FN_')):
        c.execute("SELECT m.definition FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id WHERE o.name=?", fn)
        r = c.fetchone()
        if r:
            ts |= {f"{t.upper()}" for t in TBL.findall(r[0]) if not t.startswith(('#', '@')) and t.upper() not in ('DUAL', 'SELECT', 'STRING_SPLIT', 'OPENJSON')}
            where += f' + {fn} 원문'
    return sorted(ts), where


def fe_invalidates(mid):
    """TO-BE 화면 폴더에서 useInvalidateCombos 호출과 넘기는 comboId 목록.
    화면 폴더 = 메뉴 ID 리터럴을 가진 파일(대개 *.constants.ts 의 MENU_ID)이 있는 pages/<폴더> — 본문은 MENU_ID 상수만 쓰므로 파일 단위로 찾으면 놓친다"""
    pages = os.path.join(ROOT, 'nscm-fe', 'features', '*', 'src', 'pages')
    files = glob.glob(os.path.join(pages, '**', '*.ts*'), recursive=True)
    lit = re.compile(rf"['\"]{re.escape(mid)}['\"]")
    dirs = set()
    for f in files:
        try:
            if lit.search(open(f, encoding='utf-8', errors='ignore').read()):
                rel = os.path.relpath(f, ROOT).split(os.sep)
                dirs.add(os.sep.join(rel[:rel.index('pages') + 2]))
        except (OSError, ValueError):
            continue
    hits = []
    for f in files:
        rel = os.path.relpath(f, ROOT)
        if not any(rel.startswith(d + os.sep) for d in dirs):
            continue
        t = open(f, encoding='utf-8', errors='ignore').read()
        if 'invalidateCombos(' in t:
            ids = re.findall(r"invalidateCombos\(\s*\[([^\]]*)\]", t)
            hits.append({'file': rel, 'combo_ids': [x.strip().strip("'\"") for g in ids for x in g.split(',') if x.strip()]})
    return hits


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    mid = args[0].upper()
    asis_id = sys.argv[sys.argv.index('--asis') + 1].upper() if '--asis' in sys.argv else mid
    out = os.path.join(ROOT, 'Doc', 'verify', mid, 'b7_check.json')
    res = {'menu_id': mid, 'asis_id': asis_id, 'generated': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
    from asis_live import live_golden
    save_sp = next((g['asis_sp'] for g in live_golden(mid, asis_id, 'SAVE')), '')  # 실행되지 않는 AS-IS 메서드의 저장 SP 제외(2026-10-30 SCP0041 SCP0040_SAVE_CHARACTERISTIC_CAPA)
    tg = sa.asis_targets(save_sp) if save_sp else None
    if not save_sp:
        res['a'] = {'verdict': 'NA', 'note': '저장 SP 없음(조회 전용 화면) — 이 화면 저장으로 바뀌는 콤보 후보 없음', 'targets': []}
    elif not tg:
        res['a'] = {'verdict': '판정필요', 'note': f'AS-IS 저장 SP 원문 없음({save_sp}) — 저장 대상 테이블 미확인', 'targets': []}
    else:
        saved = sorted(tg[0] | tg[1] | set(filter(None, os.environ.get('B7_MUTATE_SAVE_TABLE', '').upper().split(','))))  # 변이 시험용(평소 비어 있음)
        targets = []
        with connect('asis') as cx:
            seen = set()
            for r in read_csv(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis_id, 'combo_src.csv')):
                k = (r['target_kind'], r['target'], r['sp'], r['code'])
                if k in seen:
                    continue
                seen.add(k)
                ts, where = src_tables(cx, r['sp'], r['code'])
                ov = sorted(set(ts or []) & set(saved))
                targets.append({'kind': r['target_kind'], 'target': r['target'], 'label': r['label'], 'src': where, 'tables': ts, 'overlap': ov})
        hit = [t for t in targets if t['overlap']]
        unk = [t for t in targets if t['tables'] is None and not re.match(r'고정 목록', t['src'])]
        inv = fe_invalidates(mid) if hit else []
        if not hit:
            res['a'] = {'verdict': '판정필요' if unk else 'NA',
                        'note': (f"저장 SP {save_sp} 대상 {', '.join(saved)} 와 콤보 원천 {len(targets)}종이 읽는 테이블이 겹치지 않음 — 이 화면 저장으로 바뀌는 후보 없음"
                                 + (f" · 원천 미확인 {len(unk)}종: {', '.join(t['target'] for t in unk)}" if unk else '')),
                        'save_tables': saved, 'targets': targets}
        else:
            names = ', '.join(f"{t['target']}({'/'.join(t['overlap'])})" for t in hit)
            res['a'] = {'verdict': 'PASS' if inv else 'FAIL', 'save_tables': saved, 'targets': targets, 'fe_invalidate': inv,
                        'note': (f"저장이 콤보 원천을 바꿈: {names} — TO-BE useInvalidateCombos 호출 {', '.join(i['file'] for i in inv)} (comboId {sorted({c for i in inv for c in i['combo_ids']})} — 대상 콤보 포함 여부는 사람 확인)"
                                 if inv else f"저장이 콤보 원천을 바꿈: {names} — TO-BE 화면에 저장 후 콤보 무효화(useInvalidateCombos) 없음 → 저장 직후 후보 미갱신")}
    json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"{mid}: B7(a) {res['a']['verdict']} — {res['a']['note'][:220]} → {out}")


def selftest():
    """T380 결과셋 번호 → (SP, @Code, @Param1) 해석 시험"""
    t = ("<q id='list_line_ssp'><![CDATA[ BEGIN INSERT @T EXEC [UP_FX_GetCommonDataList_SCP] @Code = 'A1' , @Param1 = @GROUP_ID SELECT * FROM @T END "
         "BEGIN DELETE @T INSERT @T EXEC [UP_FX_GetCommonDataList] @Code = 'LookupCommon' , @Param1 = 'OPG' , @Param2 = '' SELECT	* FROM @T END "
         "BEGIN SELECT * FROM @T END ]]></q>")
    got = ssp_bigfilter_sets(t)
    cases = [(got[0], ('UP_FX_GetCommonDataList_SCP', 'A1', '')), (got[1], ('UP_FX_GetCommonDataList', 'LookupCommon', 'OPG')), (got[2], None), (len(got), 3)]
    bad = [(g, e) for g, e in cases if g != e]
    print(f'b7_check selftest {len(cases) - len(bad)}/{len(cases)}' + (f' FAIL {bad}' if bad else ''))
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    selftest() if '--selftest' in sys.argv else main()
