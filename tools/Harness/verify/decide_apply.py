# -*- coding: utf-8 -*-
"""사용자 판정 대상 행에 AI 권장안을 먼저 적용 (2026-11-20 사용자 지시)
   "사용자판정의 경우에도 우선 권장안으로 해서 진행은 하고 차후 판정필요 항목으로 사용자가 필요시에만 다시 코멘트하도록"

  python tools/Harness/verify/decide_apply.py <MENU_ID>            권장안 적용 + 기록
  python tools/Harness/verify/decide_apply.py <MENU_ID> --dry      원장을 고치지 않고 대상만 출력
  python tools/Harness/verify/decide_apply.py --selftest

  대상 = 미검증 분류(Doc/verify/<ID>/unverified_triage.csv) 담당 '결정' 행: AI 판정 검토(llm_review.csv)가 근거를 읽었지만 인용 확인만으로 결론을 못 낸 행.
  처리
    1) AI 검토 답의 고칠 곳(fix_hint)이 검사기 파일이면 결정 대상이 아님 → 담당 '엔진'으로 되돌림(검사기 보완 뒤 다시 측정). 원장은 그대로
    2) 그 밖의 행: 원장 result ERROR → '판정필요', 근거 칸 앞에 '[권장안 적용] 권장 <판정>(신뢰 <등급>) — <이유> · 근거 <파일:줄> — 실측: <원 근거>', tobe_ref 'AI 권장안'
       PASS·NA·FAIL 로 확정하지 않는다: 인용이 기계 확인된 PASS·NA·FAIL 은 AI 판정 검토(llm_review → judge 반입)가 이미 반영한다. 여기 남은 행은 그 조건을 못 채운 행이다
    3) 사용자판정이 있는 행([사용자판정] · 수동 사용자판정)은 건드리지 않는다. 사용자가 CheckList 사용자의견으로 코멘트하면 그 판정이 우선한다(종전 경로)
  담당 '사람' 행(스냅샷 승인 · 시험 계정 없음 · 삭제 경로 없는 화면의 실저장)은 권장안으로 풀 수 없다. 미검증으로 두고 사유와 필요한 조치를 목록에 적는다
  산출
    Doc/verify/<ID>/ai_recommend.csv        행별 권장 판정 · 이유 · 근거 · 다른 선택지 · 상태(applied | engine | kept | user)
    Doc/verify/<ID>/ai_recommend_base.json  적용 직전 원장 값(다음 실행의 judge 가 되돌릴 때 씀 · tobe_ref 'AI 권장안')
  문서: make_verify_docs.py 가 ai_recommend.csv 로 '판정필요(권장안 적용)' 시트를 만든다
  종료코드 0 = 기록 완료(대상 0 포함) · 3 = 원장 또는 분류 결과 없음
"""
import argparse, csv, datetime, json, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
TAG = '[권장안 적용]'; REF = 'AI 권장안'
ENGINE_FILE = re.compile(r'(Doc[\\/]e2e[\\/]specs|tools[\\/]E2E|tools[\\/]Harness|\.spec\.ts|probe\.ts|saveprobe\.ts|검사기)', re.I)
USER = re.compile(r'^(\[사용자판정\]|\[사용자의견)')
HUMAN_ACTION = {'스냅샷승인': 'snap_validate.py 결과를 보고 snap_approve.py 로 승인', '계정': 'tools/E2E/users.json 에 해당 권한·Division 계정 추가',
                '저장보류': '정리 키·삭제 경로 지정(gen_cleanup_spec) 또는 저장 시험 허용 여부 결정'}
FIELDS = ['row_id', 'rule_id', 'target', 'status', 'recommend', 'confidence', 'reason', 'evidence_ref', 'alternatives', 'action', 'at']


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def read_csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as fh:
            return list(csv.DictReader(fh))
    except OSError:
        return []


def write_retry(path, fn):
    for _ in range(6):
        try:
            return fn()
        except OSError:
            time.sleep(1.0)
    return fn()


def alternatives(rec):
    """권장 판정 말고 사용자가 고를 수 있는 판정"""
    alls = ['PASS(오류 아님)', 'FAIL(보완 대상)', 'NA(대상 아님)', '판정필요 유지']
    return ' / '.join(a for a in alls if not a.startswith(rec)) if rec else ' / '.join(alls)


def plan(tri, review, ledger):
    """분류 행 + AI 검토 답 + 원장 → 처리 목록. 순수 함수(파일 안 씀)"""
    rv = {x['row_id']: x for x in review}; led = {r['row_id']: r for r in ledger}
    out = []
    for t in tri:
        actor = t.get('actor') or ''; rid = t.get('row_id') or ''
        if actor == '사람':
            out.append({'row_id': rid, 'rule_id': t.get('rule_id', ''), 'target': t.get('target', ''), 'status': 'kept', 'recommend': '', 'confidence': '',
                        'reason': '권장안으로 풀 수 없음(' + (t.get('class') or '') + ')', 'evidence_ref': '', 'alternatives': '',
                        'action': HUMAN_ACTION.get(t.get('class') or '', (t.get('remedy') or '')[:200])})
            continue
        if actor != '결정':
            continue
        r = led.get(rid); x = rv.get(rid) or {}
        base = {'row_id': rid, 'rule_id': t.get('rule_id', ''), 'target': t.get('target', ''), 'confidence': x.get('confidence', ''),
                'reason': (x.get('reason') or '').strip()[:600], 'evidence_ref': (x.get('evidence_ref') or '').strip()[:400], 'action': ''}
        if r is None:
            continue
        if USER.match(r.get('evidence') or '') or (r.get('tobe_ref') or '').startswith('수동'):
            out.append(dict(base, status='user', recommend='', alternatives='', action='사용자판정이 있어 그대로 둠')); continue
        hint = (x.get('fix_hint') or '').strip()
        if hint and ENGINE_FILE.search(hint):
            out.append(dict(base, status='engine', recommend='', alternatives='', action='검사기 보완 대상으로 되돌림: ' + hint[:300])); continue
        rec = (x.get('verdict') or '').strip() or '판정필요'
        out.append(dict(base, status='applied', recommend=rec, alternatives=alternatives(rec),
                        action='사용자 코멘트가 없으면 권장안 유지. 다르게 판정하려면 CheckList 사용자의견 칸에 적음'))
    return out


def apply_ledger(ledger, items):
    """원장 행에 권장안 적용 → (바뀐 행 수, 적용 직전 값 {row_id: {...}})"""
    by = {r['row_id']: r for r in ledger}; base = {}; n = 0
    for it in items:
        if it['status'] != 'applied':
            continue
        r = by.get(it['row_id'])
        if r is None or (r.get('tobe_ref') or '') == REF:
            continue
        base[r['row_id']] = {k: r.get(k, '') for k in ('result', 'evidence', 'tobe_ref', 'note')}
        orig = r.get('evidence') or ''
        r['evidence'] = (f"{TAG} 권장 {it['recommend']}" + (f"(신뢰 {it['confidence']})" if it['confidence'] else '') + f" — {it['reason'] or '이유 기록 없음'}"
                         + (f" · 근거 {it['evidence_ref']}" if it['evidence_ref'] else '') + f" — 실측: {orig}")
        r['note'] = ((r.get('note') or '') + f" | 원판정:{r.get('result', '')}(AI 권장안)").strip(' |')
        r['result'] = '판정필요'; r['tobe_ref'] = REF; n += 1
    return n, base


def reset_rows(rows, base):
    """judge 가 부른다: 지난 실행의 권장안 적용 행을 기계 판정으로 되돌림 → 되돌린 행 수"""
    n = 0
    for r in rows:
        if (r.get('tobe_ref') or '') != REF:
            continue
        b = base.get(r['row_id'])
        if b:
            r.update({k: v for k, v in b.items() if k in r})
        else:
            r['result'] = 'ERROR'; r['tobe_ref'] = ''
            r['evidence'] = re.sub(r'^\[권장안 적용\].*? — 실측: ', '', r.get('evidence') or '', flags=re.S)
        r['note'] = re.sub(r'\s*\|?\s*원판정:[^|]*\(AI 권장안\)', '', r.get('note') or '').strip(' |')
        n += 1
    return n


def apply_in_triage(mid, tri, say=print):
    """unverified_resolve.py 가 분류 직후 부른다: 메모리의 분류 목록(tri)에 권장안을 적용하고 원장·기록 파일을 쓴다.
       적용한 행은 tri 에서 빼고(더는 미검증 아님), 검사기 보완으로 되돌릴 행은 담당을 '엔진'으로 바꾼다. 반환 = {'applied', 'engine', 'kept', 'user'}"""
    vd = os.path.join(ROOT, 'Doc', 'verify', mid); lp = os.path.join(vd, 'verify_ledger.csv')
    with open(lp, encoding='utf-8-sig', newline='') as fh:
        rd = csv.DictReader(fh); fields = rd.fieldnames; ledger = list(rd)
    items = plan(tri, read_csv(os.path.join(vd, 'llm_review.csv')), ledger)
    c = {k: sum(1 for i in items if i['status'] == k) for k in ('applied', 'engine', 'kept', 'user')}
    if not items:
        return c
    at = now()
    for i in items:
        i['at'] = at
    n, base = apply_ledger(ledger, items)
    if n:
        bp = os.path.join(vd, 'ai_recommend_base.json')
        try:
            old = json.load(open(bp, encoding='utf-8'))
        except (OSError, ValueError):
            old = {}
        old.update(base)

        def _w():
            with open(lp, 'w', encoding='utf-8-sig', newline='') as fh:
                w = csv.DictWriter(fh, fieldnames=fields, extrasaction='ignore'); w.writeheader(); w.writerows(ledger)
        write_retry(lp, _w)
        json.dump(old, open(bp, 'w', encoding='utf-8'), ensure_ascii=False)
    st = {i['row_id']: i for i in items}
    for t in list(tri):
        i = st.get(t.get('row_id'))
        if not i:
            continue
        if i['status'] == 'applied':
            tri.remove(t)
        elif i['status'] == 'engine':
            t['actor'] = '엔진'; t['remedy'] = ('AI 판정 검토가 검사기 측정 방법을 원인으로 봄 → ' + i['action'])[:900]
    with open(os.path.join(vd, 'ai_recommend.csv'), 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=FIELDS, extrasaction='ignore'); w.writeheader(); w.writerows(items)
    say(f"[권장안] 사용자 판정 대상: 권장안 적용 {c['applied']}행('판정필요'로 표시) · 검사기 보완으로 되돌림 {c['engine']} · 사용자판정 유지 {c['user']} · 권장안으로 풀 수 없음 {c['kept']} · Doc/verify/{mid}/ai_recommend.csv", flush=True)
    return c


def run(mid, dry=False):
    vd = os.path.join(ROOT, 'Doc', 'verify', mid); lp = os.path.join(vd, 'verify_ledger.csv')
    tri = read_csv(os.path.join(vd, 'unverified_triage.csv'))
    if not os.path.exists(lp) or not os.path.exists(os.path.join(vd, 'unverified_triage.csv')):
        print(f'[FAIL] 원장 또는 미검증 분류 결과 없음 — Doc/verify/{mid}'); return 3
    with open(lp, encoding='utf-8-sig', newline='') as fh:
        rd = csv.DictReader(fh); fields = rd.fieldnames; ledger = list(rd)
    items = plan(tri, read_csv(os.path.join(vd, 'llm_review.csv')), ledger)
    c = {k: sum(1 for i in items if i['status'] == k) for k in ('applied', 'engine', 'kept', 'user')}
    print(f"[권장안] 결정 대상 {c['applied'] + c['engine'] + c['user']}행: 권장안 적용 {c['applied']} · 검사기 보완으로 되돌림 {c['engine']} · 사용자판정 유지 {c['user']} · 권장안으로 풀 수 없음(사람) {c['kept']}", flush=True)
    if dry:
        for i in items:
            print(f"  {i['status']:8s} {i['row_id']} {i['rule_id']} {i['recommend']} | {(i['reason'] or i['action'])[:100]}")
        return 0
    at = now()
    for i in items:
        i['at'] = at
    n, base = apply_ledger(ledger, items)
    if n:
        bp = os.path.join(vd, 'ai_recommend_base.json')
        try:
            old = json.load(open(bp, encoding='utf-8'))
        except (OSError, ValueError):
            old = {}
        old.update(base)

        def _w():
            with open(lp, 'w', encoding='utf-8-sig', newline='') as fh:
                w = csv.DictWriter(fh, fieldnames=fields, extrasaction='ignore'); w.writeheader(); w.writerows(ledger)
        write_retry(lp, _w)
        json.dump(old, open(bp, 'w', encoding='utf-8'), ensure_ascii=False)
    # 분류 결과에서 검사기 보완으로 되돌릴 행은 담당을 '엔진'으로(다음 반복의 보완 대상)
    eng = {i['row_id']: i for i in items if i['status'] == 'engine'}
    if eng:
        tp = os.path.join(vd, 'unverified_triage.csv')
        with open(tp, encoding='utf-8-sig', newline='') as fh:
            rd = csv.DictReader(fh); tf = rd.fieldnames; trows = list(rd)
        for t in trows:
            if t['row_id'] in eng:
                t['actor'] = '엔진'; t['remedy'] = ('AI 판정 검토가 검사기 측정 방법을 원인으로 봄 → ' + eng[t['row_id']]['action'])[:900]
        with open(tp, 'w', encoding='utf-8-sig', newline='') as fh:
            w = csv.DictWriter(fh, fieldnames=tf, extrasaction='ignore'); w.writeheader(); w.writerows(trows)
    with open(os.path.join(vd, 'ai_recommend.csv'), 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=FIELDS, extrasaction='ignore'); w.writeheader(); w.writerows(items)
    print(f"[OK] 원장 {n}행을 '판정필요(권장안 적용)'로 바꿈 · Doc/verify/{mid}/ai_recommend.csv", flush=True)
    return 0


def selftest():
    ok = True

    def chk(name, cond, extra=''):
        nonlocal ok
        print(('PASS ' if cond else 'FAIL ') + name + (' ' + str(extra) if extra and not cond else '')); ok = ok and bool(cond)
    led = [{'row_id': f'R{i}', 'result': 'ERROR', 'evidence': f'실측 {i}', 'tobe_ref': '', 'note': ''} for i in range(1, 7)]
    led[4]['evidence'] = '[사용자판정] PASS — x'
    tri = [{'row_id': 'R1', 'actor': '결정', 'rule_id': 'H6', 'target': 't1', 'class': '판단'}, {'row_id': 'R2', 'actor': '결정', 'rule_id': 'M3', 'target': 't2', 'class': '판단'},
           {'row_id': 'R3', 'actor': '사람', 'rule_id': 'W8', 'target': 't3', 'class': '계정', 'remedy': 'x'}, {'row_id': 'R4', 'actor': '엔진', 'rule_id': 'F1', 'target': 't4', 'class': '검사기공백'},
           {'row_id': 'R5', 'actor': '결정', 'rule_id': 'E3', 'target': 't5', 'class': '판단'}, {'row_id': 'R6', 'actor': '결정', 'rule_id': 'K4', 'target': 't6', 'class': '판단'}]
    rv = [{'row_id': 'R1', 'verdict': 'PASS', 'confidence': '보통', 'reason': 'AS-IS 도 같은 동작', 'evidence_ref': 'a.cs:10', 'fix_hint': ''},
          {'row_id': 'R2', 'verdict': '판정필요', 'confidence': '보통', 'reason': '검사기가 0행에서 잼', 'evidence_ref': 'b.cs:2', 'fix_hint': 'Doc/e2e/specs/_verify.spec.ts: From Site 를 고른 뒤 측정'},
          {'row_id': 'R5', 'verdict': 'NA', 'confidence': '높음', 'reason': 'x', 'evidence_ref': '', 'fix_hint': ''}]
    items = plan(tri, rv, led); st = {i['row_id']: i for i in items}
    chk('결정 행 = 권장안 적용 대상', st['R1']['status'] == 'applied' and st['R1']['recommend'] == 'PASS')
    chk('고칠 곳이 검사기 파일 = 엔진으로 되돌림', st['R2']['status'] == 'engine')
    chk('사람 행 = 권장안으로 풀 수 없음 + 필요한 조치', st['R3']['status'] == 'kept' and 'users.json' in st['R3']['action'])
    chk('엔진 행은 대상 아님', 'R4' not in st)
    chk('사용자판정 있는 행 = 그대로', st['R5']['status'] == 'user')
    chk('AI 검토 답이 없는 결정 행 = 권장 판정필요', st['R6']['status'] == 'applied' and st['R6']['recommend'] == '판정필요')
    chk('다른 선택지에 권장 판정 제외', 'PASS' not in st['R1']['alternatives'] and 'FAIL' in st['R1']['alternatives'])
    n, base = apply_ledger(led, items); r1 = led[0]
    chk('원장: 결과 판정필요 · 표식 · 원 근거 유지', n == 2 and r1['result'] == '판정필요' and r1['evidence'].startswith(TAG + ' 권장 PASS(신뢰 보통)') and r1['evidence'].endswith('— 실측: 실측 1') and r1['tobe_ref'] == REF)
    chk('PASS 로 확정하지 않음', all(r['result'] != 'PASS' for r in led))
    chk('엔진·사용자판정·사람 행 원장 불변', led[1]['result'] == 'ERROR' and led[4]['evidence'].startswith('[사용자판정]') and led[2]['result'] == 'ERROR')
    n2, _ = apply_ledger(led, items); chk('두 번 적용해도 겹쳐 쓰지 않음', n2 == 0)
    k = reset_rows(led, base)
    chk('되돌리기: 기계 판정 복원', k == 2 and r1['result'] == 'ERROR' and r1['evidence'] == '실측 1' and r1['tobe_ref'] == '' and '원판정' not in r1['note'])
    led[5].update({'result': '판정필요', 'tobe_ref': REF, 'evidence': TAG + ' 권장 판정필요 — x — 실측: 실측 6', 'note': '원판정:ERROR(AI 권장안)'})
    reset_rows(led, {}); chk('기준 파일이 없어도 되돌림', led[5]['result'] == 'ERROR' and led[5]['evidence'] == '실측 6')
    print('SELFTEST ' + ('OK' if ok else 'FAIL')); return 0 if ok else 1


def main():
    if '--selftest' in sys.argv:
        return selftest()
    ap = argparse.ArgumentParser(); ap.add_argument('menu_id'); ap.add_argument('--dry', action='store_true')
    a = ap.parse_args()
    return run(a.menu_id.upper(), a.dry)


if __name__ == '__main__':
    sys.exit(main())
