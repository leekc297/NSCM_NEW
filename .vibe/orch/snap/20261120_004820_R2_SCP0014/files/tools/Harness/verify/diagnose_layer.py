# -*- coding: utf-8 -*-
"""보완 전 원인 계층 확정(EN-24 · 2026-11-11) — 조치 필요 행마다 원인이 메타·DB 객체·FE 중 어디인지를 '재서' 정한다.

  python tools/Harness/verify/diagnose_layer.py <MENU_ID>     → Doc/verify/<ID>/layer_diagnosis.csv (+ 콘솔 요약)
  python tools/Harness/verify/diagnose_layer.py --selftest

왜: fixlist 의 layer 는 규칙별 기본값이다(layer_reason '규칙 A5 기본 계층') — 그 행을 진단한 결과가 아니어서 보완이 엉뚱한 계층을 고칠 수 있다(추측 지점 원장 REPAIR).
측정(모두 읽기 전용):
  P1 컬럼 메타 대조  컬럼 행(A5·H1·H8·H9·H12·D5) — 사내 DB SCM_MST_SHEET_COLUMNS 의 그 (시트,컬럼) 속성 ↔ AS-IS 메타(Doc/asisfacts/screens/<ID>/dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv)
       속성이 다르면 = DB_META(메타 값이 AS-IS 와 다름) · 같으면 = 메타는 AS-IS 와 같음 → 화면(FE)이 메타대로 그리지 않거나 AS-IS 코드가 메타를 덮는 경우(둘 중 무엇인지는 이 측정으로 못 가림)
       · TO-BE 메타에 행이 없으면 = DB_META(행 누락)
  P2 메시지 등록     증거의 MSG/LBL 코드 — 사내 DB SCM_ADM_MSG_M 에 KO/EN 행이 없으면 = DB_META(메시지 미등록) · 있으면 = FE(코드는 등록됨)
  P3 저장 경로 COMMIT  F10 — 판정 자체가 PROC 본문 사실(ALL_SOURCE) → DB_OBJECT
  P4 조회 요청 실림   텍스트 조건(G1·G8) — E2E 가 잰 '요청 본문에 값이 실렸는가': 실렸는데 0행 = DB_OBJECT(PROC 조건 처리) · 안 실림 = FE(요청 조립)
그 밖의 행은 **미확정(측정 경로 없음)** 으로 남긴다 — 규칙 기본 계층으로 채우지 않는다.
열: row_id, rule_id, target, layer_default(fixlist), layer_measured, probe, grade(E2 실측 / E2-문장 = E2E 증거 문장 판독), basis
한계: P4 는 E2E 증거 문장을 읽는다(구조화 증거 전환 전 · EN-11). P1 의 '메타 동일' 은 FE 원인과 AS-IS 코드 덮어쓰기를 구분하지 못한다.
"""
import csv
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
csv.field_size_limit(10 ** 8)
COLS = ['row_id', 'rule_id', 'target', 'layer_default', 'layer_measured', 'probe', 'grade', 'basis']
# 규칙 → 대조할 컬럼 메타 속성
ATTR = {'A5': ['VISIBLE_FLAG', 'DEFAULT_FLAG', 'USER_SELECTABLE_FLAG', 'VALID_YN'], 'H1': ['HORIZONTAL_ALIGN_CODE'], 'H8': ['DATA_SCALE_NUMBER', 'CELL_CONTROL_OBJECT_TYPE_CODE'],
        'H9': ['COLUMN_WIDTH'], 'H12': ['FIXED_FLAG'], 'D5': ['CELL_CONTROL_OBJECT_TYPE_CODE', 'CELL_COMBO_DATA_TYPE']}


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def nz(v):
    s = '' if v is None else str(v).strip()
    return '' if s in ('-', '/') else s  # 빈값 센티널('-'·'/')은 빈값으로 본다


def col_of(row):
    """원장 행 → (시트, 컬럼) — target 'Sheet.COLUMN (Label)' 또는 증거 첫머리 'COLUMN: …'. 못 찾으면 ('','')"""
    tg = row.get('target') or ''
    m = re.match(r'^(.+?)\.([A-Z][A-Z0-9_]+)\b', tg)
    if m:
        return m.group(1).strip(), m.group(2)
    m = re.match(r'^([A-Z][A-Z0-9_]{2,}):', (row.get('evidence') or '').strip())
    return ('', m.group(1)) if m else ('', '')


def judge_meta(attrs, asis_rows, tobe_rows):
    """순수 함수 — 같은 (시트,컬럼)의 AS-IS·TO-BE 메타 행들(Division 별 여러 행) → (계층, 근거)"""
    if not asis_rows and not tobe_rows:
        return '', 'AS-IS·TO-BE 메타 모두 이 컬럼 행 없음 — 메타 대조 불가'
    if not tobe_rows:
        return 'DB_META', f'TO-BE 메타에 이 컬럼 행 없음(AS-IS {len(asis_rows)}행)'
    if not asis_rows:
        return '', f'AS-IS 메타에 이 컬럼 행 없음(TO-BE {len(tobe_rows)}행) — AS-IS 는 코드로 만든 컬럼일 수 있음 · 메타 대조 불가'
    key = lambda r: nz(r.get('DIVISION_ID'))
    A = {key(r): r for r in asis_rows}; T = {key(r): r for r in tobe_rows}
    diffs = []
    for d in sorted(set(A) | set(T)):
        if d not in T:
            diffs.append(f"Div '{d}' TO-BE 행 없음"); continue
        if d not in A:
            diffs.append(f"Div '{d}' AS-IS 행 없음(TO-BE 추가)"); continue
        for a in attrs:
            va, vt = nz(A[d].get(a)), nz(T[d].get(a))
            if va != vt:
                diffs.append(f"Div '{d}' {a} AS-IS '{va}' ↔ TO-BE '{vt}'")
    if diffs:
        return 'DB_META', '메타 값이 AS-IS 와 다름 — ' + ' · '.join(diffs[:6]) + (f' …(+{len(diffs) - 6})' if len(diffs) > 6 else '')
    return 'FE_OR_ASIS_CODE', f"메타 속성({', '.join(attrs)})이 AS-IS 와 같음({len(T)}개 Division 행) — 화면이 메타대로 그리지 않거나 AS-IS 코드가 메타를 덮음"


def judge_request(ev):
    """순수 함수 — 텍스트 조건 증거 문장 → (계층, 근거)"""
    if re.search(r'요청 본문에 실렸는데\s*0행', ev):
        return 'DB_OBJECT', 'E2E 측정: 입력값이 조회 요청 본문에 실렸는데 0행 — PROC 의 조건 처리'
    if re.search(r'요청 본문에 값 없음', ev):
        return 'FE', 'E2E 측정: 입력값이 조회 요청 본문에 없음 — 화면의 요청 조립'
    return '', ''


def selftest():
    a = [{'DIVISION_ID': '40', 'VISIBLE_FLAG': 'N'}, {'DIVISION_ID': '82', 'VISIBLE_FLAG': 'N'}]
    cases = [('메타 값 다름 → DB_META', judge_meta(['VISIBLE_FLAG'], a, [{'DIVISION_ID': '40', 'VISIBLE_FLAG': 'Y'}, {'DIVISION_ID': '82', 'VISIBLE_FLAG': 'N'}])[0] == 'DB_META'),
             ('메타 같음 → FE 또는 AS-IS 코드', judge_meta(['VISIBLE_FLAG'], a, [dict(x) for x in a])[0] == 'FE_OR_ASIS_CODE'),
             ('TO-BE 행 없음 → DB_META', judge_meta(['VISIBLE_FLAG'], a, [])[0] == 'DB_META'),
             ('AS-IS 행 없음 → 미확정', judge_meta(['VISIBLE_FLAG'], [], a)[0] == ''),
             ("센티널 '-' = 빈값", judge_meta(['FIXED_FLAG'], [{'DIVISION_ID': '', 'FIXED_FLAG': ''}], [{'DIVISION_ID': '-', 'FIXED_FLAG': '-'}])[0] == 'FE_OR_ASIS_CODE'),
             ('요청에 실렸는데 0행 → DB_OBJECT', judge_request("Material · 'PCAN'(값 일부) 이 조회 요청 본문에 실렸는데 0행 — Like 안 됨")[0] == 'DB_OBJECT'),
             ('요청에 값 없음 → FE', judge_request("조회 → MODEL_ID 0행 · 요청 본문에 값 없음")[0] == 'FE'),
             ('컬럼 추출(target)', col_of({'target': 'Shipment Plan Detail.CHANGE_REQ_NO (Request No)'}) == ('Shipment Plan Detail', 'CHANGE_REQ_NO')),
             ('컬럼 추출(증거)', col_of({'target': '', 'evidence': "REMARKS: AS-IS(Div 40) '기본' ↔ TO-BE 표시=N"}) == ('', 'REMARKS'))]
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
    mid = a[0].upper(); vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    fx = [r for r in rd(os.path.join(vd, 'fixlist.csv')) if (r.get('action_needed') or '').upper() == 'Y']
    led = {r['row_id']: r for r in rd(os.path.join(vd, 'verify_ledger.csv'))}
    if not fx:
        print(f'[diagnose_layer] {mid}: 조치 필요 행 없음'); return 0
    asis_meta = rd(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv'))
    from dbconn import connect
    out = []
    with connect('tobe') as cx:
        c = cx.cursor()
        c.execute("SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = :1", [mid])
        names = [d[0] for d in c.description]
        tobe_meta = [dict(zip(names, r)) for r in c.fetchall()]
        for f in fx:
            r = led.get(f['row_id'], {}); rule = (f.get('rule_id') or '').upper(); ev = r.get('evidence') or ''
            layer, probe, grade, basis = '', '', '', ''
            if rule in ATTR:
                sh, col = col_of(r)
                if col:
                    A = [x for x in asis_meta if x.get('COLUMN_NAME') == col and (not sh or x.get('SHEET_NAME') == sh)]
                    T = [x for x in tobe_meta if x.get('COLUMN_NAME') == col and (not sh or x.get('SHEET_NAME') == sh)]
                    layer, basis = judge_meta(ATTR[rule], A, T); probe, grade = 'P1 컬럼 메타 대조', 'E2 실측'
                    basis = f"{(sh + '.') if sh else ''}{col}: {basis}"
            if not layer and rule == 'A5':
                # 화면 단위 A5 행 — target 'Division 컬럼 <Div>/<시트>' · 증거에 컬럼 목록('없어야 하는데 있음 N개 X' · '있어야 하는데 없음 N개 A,B' · '누락… = A, B' · '추가… = X')
                m = re.search(r'Division 컬럼 [^/]+/(.+)$', r.get('target') or '')
                sh2 = m.group(1).strip() if m else ''
                cols2 = []
                for mm in re.finditer(r'(?:있음|없음|=)\s*(?:\d+개\s*)?((?:[A-Z][A-Z0-9_]{2,})(?:\s*,\s*[A-Z][A-Z0-9_]{2,})*)', ev):
                    cols2 += [x.strip() for x in mm.group(1).split(',')]
                cols2 = list(dict.fromkeys(cols2))[:12]
                if cols2:
                    parts = []
                    for col in cols2:
                        A = [x for x in asis_meta if x.get('COLUMN_NAME') == col and (not sh2 or x.get('SHEET_NAME') == sh2)]
                        T = [x for x in tobe_meta if x.get('COLUMN_NAME') == col and (not sh2 or x.get('SHEET_NAME') == sh2)]
                        parts.append((col,) + judge_meta(ATTR['A5'], A, T))
                    kinds = {p[1] for p in parts}
                    layer = 'DB_META' if kinds == {'DB_META'} else ('FE_OR_ASIS_CODE' if kinds == {'FE_OR_ASIS_CODE'} else ('' if kinds == {''} else '혼합'))
                    probe, grade = 'P1 컬럼 메타 대조', 'E2 실측'
                    basis = f"{sh2 or '(시트 미상)'}: " + ' / '.join(f'{c2} → {l or "미확정"}({b[:90]})' for c2, l, b in parts[:4]) + (f' …(+{len(parts) - 4})' if len(parts) > 4 else '')
            if not layer and rule == 'M3' and re.search(r'팝업 목록 0건', ev) and re.search(r'TO-BE 메타 조회가[^·]*0건', ev):
                layer, probe, grade = 'DB_META', 'P5 팝업 메타 실행', 'E2-문장'
                basis = '검사기가 TO-BE 메타 PROC 을 실행한 결과 0건(AS-IS 메타에는 행 있음) — 메타 등록 누락'
            if not layer and rule == 'F10':
                layer, probe, grade, basis = 'DB_OBJECT', 'P3 저장 경로 COMMIT', 'E2 실측', '판정 근거가 PROC 본문(ALL_SOURCE)의 COMMIT 문장'
            if not layer and re.search(r'\b(MSG|LBL)\d{5}\b', ev) and rule in ('I1', 'I2', 'E4', 'MS1'):
                codes = sorted(set(re.findall(r'\b((?:MSG|LBL)\d{5})\b', ev)))[:10]
                miss = []
                for code in codes:
                    c.execute("SELECT LANG_CD FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = :1 AND NVL(USE_YN,'Y') = 'Y'", [code])
                    langs = {x[0] for x in c.fetchall()}
                    if not {'KO', 'EN'} <= langs:
                        miss.append(f"{code}(등록 언어 {sorted(langs) or '없음'})")
                probe, grade = 'P2 메시지 등록', 'E2 실측'
                layer, basis = ('DB_META', '사내 DB SCM_ADM_MSG_M 미등록: ' + ', '.join(miss)) if miss else ('FE', f"코드 {', '.join(codes)} 는 KO·EN 등록됨 — 화면이 그 코드를 쓰지 않거나 다른 문구 사용")
            if not layer and rule in ('G1', 'G8', 'G9'):
                layer, basis = judge_request(ev)
                if layer:
                    probe, grade = 'P4 조회 요청 실림', 'E2-문장'
            out.append({'row_id': f['row_id'], 'rule_id': rule, 'target': (f.get('target') or '')[:70], 'layer_default': f.get('layer', ''), 'layer_measured': layer or '미확정',
                        'probe': probe or '(측정 경로 없음)', 'grade': grade, 'basis': basis or '이 규칙·행 유형에 맞는 계층 측정이 아직 없다 — 규칙 기본 계층으로 채우지 않음'})
    with open(os.path.join(vd, 'layer_diagnosis.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(out)
    done = [x for x in out if x['layer_measured'] != '미확정']
    differ = [x for x in done if x['layer_measured'] != x['layer_default'] and not (x['layer_measured'] == 'FE_OR_ASIS_CODE' and x['layer_default'] == 'FE')]
    print(f"[diagnose_layer] {mid}: 조치 필요 {len(out)}행 · 계층 측정 확정 {len(done)} · 미확정 {len(out) - len(done)} · 규칙 기본 계층과 다른 것 {len(differ)}")
    for x in out:
        print(f"  {x['row_id']} [{x['rule_id']}] 기본 {x['layer_default'] or '-'} → 측정 {x['layer_measured']} · {x['basis'][:150]}")
    print(f"[diagnose_layer] → Doc/verify/{mid}/layer_diagnosis.csv")
    return 0


if __name__ == '__main__':
    sys.exit(main())
