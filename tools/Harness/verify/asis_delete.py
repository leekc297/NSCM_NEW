# -*- coding: utf-8 -*-
"""AS-IS Delete 동작 판정 단일 원천(2026-11-09 T173 — SSP0025 2·4번 허위 FAIL)

  DeleteButton 재정의가 화면 메서드로 위임하는 경우(SSP0025: DeleteButton:199 this.Delete() → Delete:343 sv.Rows.Remove,
  guard 'sCellText.Trim() == CAppSetting.StringI')를 종전 판정(DeleteButton 안의 '.Delete' DATA_OP 만)이 놓쳐
  "기존 행 Delete → D" 를 기대값으로 만들었다(gen_expect P06 · _trace.spec.ts F5 asisNewOnly 같은 결함).

  delete_stmts(actions)  = DeleteButton 에서 CALL_LOCAL 로 도달하는 화면 메서드(깊이 6)의 삭제 문장
                           [(action 행, 호출 경로 guard 를 이은 유효 guard)]
                           삭제 문장 = DATA_OP·CALL_EXT 중 target 이 .Delete / .DeleteRow / .Rows.Remove / .RemoveRow(s)
                           (2026-11-09 전 화면 actions.csv 전수: X.Delete 198 · X.DeleteRow 27 · X.Rows.Remove 5)
  new_only(actions)      = 삭제 문장이 1건 이상이고 전부 유효 guard 에 '== CAppSetting.StringI|FlagI' 인 if 조각이 있음
                           ('else of (... == FlagI)' 조각은 반대 조건이라 인정하지 않음) → (True, 근거 'Delete:343') | (False, '')
"""
import re

DEL_RX = re.compile(r'\.(Delete|DeleteRow|Rows\.Remove|RemoveRows?)$')
NEWI_RX = re.compile(r'==\s*CAppSetting\.(StringI|FlagI)\b')


def _callee(a):
    return re.sub(r'^this\.', '', a.get('target') or '').split('.')[-1]


def delete_stmts(actions, entry='DeleteButton', depth=6):
    by = {}
    for a in actions:
        by.setdefault(a.get('method') or '', []).append(a)
    out, seen = [], set()

    def walk(m, chain, d):
        if m in seen or d > depth:
            return
        seen.add(m)
        # 2026-11-10 T180(SCP0033 3번 허위 FAIL): 앞선 return 가드 'if (x != CAppSetting.FlagI) return;'(cs:186) 뒤의 삭제 문장은 신규 행에서만 닿는다 —
        #   종전엔 삭제 문장 자신의 guard 만 보아 '== FlagI' 가 없다고 '기존 행 Delete → D' 를 기대했다. 같은 범위(RETURN guard 의 앞 조각이 뒤 문장 guard 의 앞부분)에서
        #   뒤 줄 문장에 '(앞선 return) == FlagI' 조각을 붙인다. 조건이 '!=' 인 return 만 인정('==' 인 return 은 반대 — 신규 행에서 중단)
        early = []  # (line, 앞 조각, 합성 조각)
        def _ln(a):
            try:
                return int(a.get('line') or 0)
            except ValueError:
                return 0
        for a in by.get(m, []):
            if (a.get('kind') or '') != 'RETURN':
                continue
            segs = [s.strip() for s in (a.get('guard') or '').split('▸') if s.strip()]
            mm = re.match(r'^if \((.+?)\s*!=\s*CAppSetting\.(StringI|FlagI)\s*\)$', segs[-1]) if segs else None
            if mm and '&&' not in mm.group(1):  # '||' 는 중단 조건을 넓힐 뿐(SCP0001 IsNullOrWhiteSpace(action) || action != FlagI) · '&&' 는 신규 행 아닌데도 통과할 수 있어 제외
                early.append((_ln(a), ' ▸ '.join(segs[:-1]), f'(앞선 return {segs[-1]}) {mm.group(1)} == CAppSetting.{mm.group(2)}'))
        for a in by.get(m, []):
            g0 = a.get('guard') or ''
            extra = [syn for ln, pre, syn in early if _ln(a) > ln and g0.startswith(pre)]
            g = ' ▸ '.join(x for x in (chain, *extra, g0) if x)
            k = a.get('kind') or ''
            if k == 'CALL_LOCAL':
                n = _callee(a)
                if n in by:
                    walk(n, g, d + 1)
            elif k in ('DATA_OP', 'CALL_EXT') and DEL_RX.search(a.get('target') or ''):
                out.append((a, g))

    walk(entry, '', 0)
    return out


def _guard_new_only(g):
    for seg in (s.strip() for s in g.split('▸')):
        if seg.startswith('else of'):
            continue
        if NEWI_RX.search(seg):
            return True
    return False


def new_only(actions):
    st = delete_stmts(actions)
    if st and all(_guard_new_only(g) for _, g in st):
        a = st[0][0]
        return True, f"{a.get('method')}:{a.get('line')}"
    return False, ''
