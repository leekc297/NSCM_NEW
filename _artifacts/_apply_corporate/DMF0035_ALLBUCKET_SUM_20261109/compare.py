# [E20261109-ALLBUCKET] BEFORE ↔ AFTER 판정
#   1) 같은 조건: 일자 외 컬럼(h_non_d) · 행 수 · W/M 컬럼 수 동일 (= 기존 값 불변)
#   2) WEEKLY/MONTHLY(기간 컬럼 ≤ 900): AFTER 일자 값(h_d) == BEFORE DAILY 같은 기간 일자 값 (= 새로 붙은 D_ 가 DAILY 조회와 동일)
#   3) DAILY/ONLY_WEEKLY: h_d 까지 완전 동일
#   4) 기간 컬럼 > 900 (가드): AFTER D=0 · 나머지 동일
import json, pathlib, sys
W = pathlib.Path(__file__).resolve().parent
after_label = sys.argv[1] if len(sys.argv) > 1 else "AFTER"
load = lambda l: [json.loads(x) for x in (W / f"results_{l}.jsonl").read_text(encoding="utf-8").splitlines() if x.strip()]
B = {(r['kind'], r['div'], r['frm'], r['to'], r['bucket']): r for r in load("BEFORE")}
A = {(r['kind'], r['div'], r['frm'], r['to'], r['bucket']): r for r in load(after_label)}
fail = 0
print(f"{'kind':8}{'div':4}{'period':19}{'bucket':12}{'B sec':>7}{'A sec':>7}  {'B D/W/M':>12} {'A D/W/M':>12}  판정")
for k, a in A.items():
    b = B.get(k)
    if not b: print("BEFORE 없음", k); continue
    t = a['kind'].endswith('_T')
    dk = ('tD', 'tW', 'tM') if t else ('D', 'W', 'M')
    bd, ad = tuple(b.get(x) for x in dk), tuple(a.get(x) for x in dk)
    notes = []
    if 'err' in a or 'err' in b:
        ok = ('err' in b) and ('err' not in a)   # BEFORE 오류 → AFTER 해소 는 개선
        notes.append(f"B_err={b.get('err','-')[:60]} / A_err={a.get('err','-')[:60]}")
    elif t:
        # TITLE: 일자 행이 추가되면 행 수는 늘어나는 게 정상. SALES TITLE 은 SORT_ORDER_NO = ROW_NUMBER() 라
        #   일자 행이 끼면 W/M 순번이 재번호된다(기존 DAILY 와 동일 동작) → 같은 기간 BEFORE DAILY 와 완전 일치로 판정
        ok = bd[1:] == ad[1:]
        ref = B.get((k[0], k[1], k[2], k[3], 'DAILY'))
        if ad[0] and k[4] not in ('DAILY',) and ref:
            same = a['h_non_d'] == ref['h_non_d'] and a['h_d'] == ref['h_d']
            ok &= same; notes.append(f"TITLE == BEFORE DAILY {'일치' if same else '불일치'}")
        elif ad[0] and k[4] != 'DAILY':
            ref2 = A.get((k[0], k[1], k[2], k[3], 'DAILY'))
            same = bool(ref2) and a['h_non_d'] == ref2['h_non_d'] and a['h_d'] == ref2['h_d']
            ok &= same; notes.append(f"TITLE == AFTER DAILY(경로 불변 확인됨) {'일치' if same else '불일치/없음'}")
        else:
            ok &= a['h_non_d'] == b['h_non_d'] and a['h_d'] == b['h_d']
            if k[0] != 'BIZ_T' and bd[0] == 0 and ad[0] == 0 and k[4] != 'ONLY_WEEKLY': notes.append("D 미포함(가드 900 초과)")
    else:
        ok = a['h_non_d'] == b['h_non_d'] and a['rows'] == b['rows'] and bd[1:] == ad[1:]
        if not ok: notes.append(f"non_d {b['h_non_d']}→{a['h_non_d']} rows {b['rows']}→{a['rows']}")
        if k[4] in ('DAILY', 'ONLY_WEEKLY'):
            ok &= a['h_d'] == b['h_d'] and bd == ad
        elif ad[0]:
            ref = B.get((k[0], k[1], k[2], k[3], 'DAILY'))
            if ref and 'err' not in ref:
                same = a['h_d'] == ref['h_d'] and ad[0] == ref.get(dk[0])
                ok &= same
                notes.append(f"D==BEFORE DAILY {'일치' if same else '불일치'}")
            else:
                notes.append("D 대조 기준(BEFORE DAILY) 없음/오류 — D 개수만")
        else:
            ok &= bd[0] == 0 or k[4] == 'DAILY'
            notes.append("D 미포함(가드 900 초과)" if bd[0] == 0 else "D 사라짐?")
    fail += not ok
    print(f"{k[0]:8}{k[1]:4}{k[2]+'~'+k[3]:19}{k[4]:12}{b.get('total_sec',0):>7}{a.get('total_sec',0):>7}  {str(bd):>12} {str(ad):>12}  {'PASS' if ok else 'FAIL'} {'; '.join(notes)}")
print(f"FAIL {fail} / {len(A)}")
