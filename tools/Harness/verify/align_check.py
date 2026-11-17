"""H1 가로 정렬 정적 검사 — AS-IS 그리드 컬럼 정렬 ↔ TO-BE 컬럼 메타(HORIZONTAL_ALIGN_CODE) + 화면 FE 정렬 덮어쓰기 (2026-10-27)

사용자 요청(10-27): 단위테스트 두 시트의 오류(예: DM-1 'Contribution Version Valid_YN 컬럼' 정렬)가 다른 화면에 같은 형태로 있으면 찾아야 한다.
  H1 은 검사기가 없어 모든 화면에서 '검사기 없음'으로 지나갔다.

원천
  AS-IS : Doc/asisfacts/screens/<ID>/grid_columns_asis.csv (sheet · column · halign · ref) — 메타(L/C/R) · 코드 FPHAlign(Left/Center/Right)
  TO-BE : SCM_MST_SHEET_COLUMNS.HORIZONTAL_ALIGN_CODE (사내 ZIOUI1 새로 조회) → BE GridColumn.horzAlgnCd → FE columnMapping.alignMap(L/R/C)
          시트 대응 = 같은 PROGRAM_ID 시트명 일치 우선, 없으면 컬럼 집합이 가장 많이 겹치는 메타 시트(공용 팝업은 다른 화면 PROGRAM_ID — 예: SCP0007 Route 팝업 = SCP0005/route)
          화면 FE 가 컬럼 정렬을 직접 지정(`align:`)하면 그 값을 우선(같은 줄에 binding 이름이 있는 경우)
판정  PASS = 같은 정렬 · FAIL = 다름 · NA = TO-BE 에 그 컬럼이 없거나 숨김(표시 구성 A5 가 판정) · AS-IS 정렬 근거 없음

  python align_check.py <MENU_ID>   → Doc/verify/<ID>/align_check.csv
"""
import csv, os, re, sys, glob
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..', '_artifacts', '_diagnostics'))
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CR099_TAG = '[CR-099]'  # H1 AS-IS Center → TO-BE Left = TO-BE 룰 정렬 방식 변경(2026-11-09)
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
NORM = {'L': 'L', 'LEFT': 'L', 'C': 'C', 'CENTER': 'C', 'R': 'R', 'RIGHT': 'R', 'GENERAL': 'L'}
WORD = {'L': 'left', 'C': 'center', 'R': 'right'}


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


def fe_overrides(mid):
    """화면 FE 폴더에서 `binding … align: 'x'` 가 같은 줄에 있는 컬럼 정렬 지정 (공용 메타 매핑을 덮는 경우)"""
    out = {}
    for m in glob.glob(os.path.join(ROOT, 'nscm-fe', 'features', '*', 'src', 'pages', '*', '__asis-mapping__.md')):
        try:
            if mid not in open(m, encoding='utf-8', errors='ignore').read(3000):
                continue
        except OSError:
            continue
        for f in glob.glob(os.path.join(os.path.dirname(m), '**', '*.ts*'), recursive=True):
            if f.endswith(('.test.ts', '.test.tsx')):
                continue
            for i, line in enumerate(open(f, encoding='utf-8', errors='ignore'), 1):
                a = re.search(r"align\s*:\s*'(left|right|center)'", line)
                b = re.search(r"binding\s*:\s*(?:[A-Z_]+\.)?['\"]?([A-Z][A-Z0-9_]+)", line)
                if a and b:
                    out[b.group(1)] = ({'left': 'L', 'right': 'R', 'center': 'C'}[a.group(1)], f"{os.path.relpath(f, ROOT)}:{i}")
    return out


def main():
    mid = sys.argv[1].upper()
    # facts_gridcols 산출 = AS-IS ID 폴더(2026-10-28: TO-BE≠AS-IS ID 화면은 mid 로 읽으면 빈 입력) — --asis 또는 map_screen.csv
    aid = sys.argv[sys.argv.index('--asis') + 1].upper() if '--asis' in sys.argv else next(
        (m['asis_id'].upper() for m in read_csv(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv')) if (m.get('tobe_id') or '').upper() == mid), mid)
    asis = read_csv(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', aid, 'grid_columns_asis.csv'))
    if not asis:
        print(f"{mid}: AS-IS grid_columns_asis.csv 없음 — H1 대상 없음")
        return
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("""SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, HORIZONTAL_ALIGN_CODE, VISIBLE_FLAG
                     FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE VALID_YN = 'Y'""")
    meta = {}
    for pg, sh, col, al, vis in cur:
        meta.setdefault((pg, sh), {})[col] = (al, vis)
    over = fe_overrides(mid)
    sheets = {}
    for r in asis:
        sheets.setdefault(r['sheet'], []).append(r)
    rows = []
    for sh, cols in sheets.items():
        names = {c['column'] for c in cols}
        # 2026-11-07 T160(SCP0016 H1 29행 NA '대응 메타 시트 없음'): 한쪽만 공백을 지워 비교해 'Waterfall Shipment Plan' ↔ 'WATERFALLSHIPMENTPLAN' 이 영영 안 맞았다 — 양쪽 다 정규화
        _nz = lambda s: re.sub(r'[\s_\-]', '', str(s or '')).upper()
        same = [k for k in meta if k[0] == mid and _nz(k[1]) == _nz(sh)]
        ratio = 1.0
        if same:
            key = same[0]
        else:
            cand = sorted(((len(names & set(v)) / max(len(names), 1), k) for k, v in meta.items()), reverse=True)
            key = cand[0][1] if cand and cand[0][0] >= 0.6 else None
            ratio = cand[0][0] if key else 0.0
        # 2026-11-09 T173(SSP0025 10번 · 사용자 지시 '팝업 MODEL_ID·NICK_NAME 정렬 Center/Left 는 조치필요 아님 → 판정필요'):
        #   같은 PROGRAM_ID 시트가 없어 컬럼 겹침으로 '다른 화면' 메타를 추정한 경우(SSP0025_ItembyDivisionPopup → SSP0024/Ship Master Elec 메인 그리드)
        #   TO-BE 팝업이 실제로 그 메타를 쓰는지 확인되지 않았다 → 그 원천으로 낸 FAIL 은 결함 증거가 아니라 판정필요 · PASS 는 근거에 '원천 추정' 표시
        borrowed = bool(key) and not same and key[0] != mid
        for c in cols:
            a = NORM.get((c.get('halign') or '').strip().upper())
            t = meta.get(key, {}).get(c['column']) if key else None
            ov = over.get(c['column'])
            t_al = ov[0] if ov else (NORM.get((t[0] or 'L').strip().upper()) if t else None)
            src = (f"FE {ov[1]}" if ov else f"메타 {key[0]}/{key[1]}" if key else '대응 메타 시트 없음')
            if not a:
                v, note = 'NA', 'AS-IS 정렬 근거 없음'
            elif key is None:
                v, note = 'NA', f"TO-BE 대응 메타 시트 없음(AS-IS 시트 {sh})"
            elif t is None and not ov:
                v, note = 'NA', f"TO-BE {key[0]}/{key[1]} 에 컬럼 없음 — 표시 구성(A5)에서 판정"
            elif t and (t[1] or 'Y') == 'N' and not ov:
                v, note = 'NA', '숨김 컬럼(VISIBLE_FLAG=N) — 표시 정렬 대상 아님'
            else:
                v = 'PASS' if a == t_al else 'FAIL'
                note = f"AS-IS {WORD[a]} ↔ TO-BE {WORD.get(t_al, t_al)}" + ('' if v == 'PASS' else ' — 정렬 다름')
                # 2026-11-09 CR-099(사용자 판정 SSP0024 CheckList 2·3번 · SSP0025 10번): AS-IS Center → TO-BE Left 는 TO-BE 룰로 바뀐 정렬 방식 — 결함 아님(PASS · 근거 표시)
                #   다른 방향(Right↔Left 등 숫자 칸 정렬 깨짐)은 그대로 FAIL
                if v == 'FAIL' and a == 'C' and t_al == 'L':
                    v, note = 'PASS', f"{CR099_TAG} {note.replace(' — 정렬 다름', '')} — TO-BE 룰 정렬 방식 변경(Center→Left · 사용자 판정 2026-11-09)"
                if borrowed and not ov:
                    tag = f"TO-BE 원천 추정(같은 화면 시트 없음 · 컬럼 겹침 {ratio:.0%} 로 다른 화면 메타 {key[0]}/{key[1]} 사용 — TO-BE 팝업 실제 메타 미확인)"
                    if v == 'FAIL':
                        v, note = '판정필요', f"[정렬 원천 추정 → 판정필요] {note} · {tag}"
                    else:
                        note = f"{note} · {tag}"
            rows.append({'menu_id': mid, 'sheet': sh, 'column': c['column'], 'label': c.get('label', ''), 'asis_halign': a or '',
                         'asis_ref': c.get('ref', ''), 'tobe_program': key[0] if key else '', 'tobe_sheet': key[1] if key else '',
                         'tobe_halign': t_al or '', 'tobe_source': src, 'verdict': v, 'note': note})
    out = os.path.join(ROOT, 'Doc', 'verify', mid, 'align_check.csv')
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    from collections import Counter
    print(f"{mid}: H1 정렬 {len(rows)}컬럼 — {dict(Counter(r['verdict'] for r in rows))} · 시트 대응 "
          + ', '.join(f"{s}→{next((r['tobe_program'] + '/' + r['tobe_sheet'] for r in rows if r['sheet'] == s), '')}" for s in sheets) + f" → {out}")


if __name__ == '__main__':
    main()
