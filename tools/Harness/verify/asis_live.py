"""AS-IS 실행되지 않는 코드(진입점 미연결 메서드) 판정 — 검사기 공통 (2026-10-30 SCP0041 조치 필요 3번 계기 · 검사기 결함 T4)

  python tools/Harness/verify/asis_live.py <AS-IS ID> [<AS-IS ID> ...]     # 판정 결과·근거 출력(파일 쓰기 없음)

사례: SCP0041 SaveButton 이 '// SaveData();' 를 주석 처리하고 SaveDataPacker() 만 부르는데, SaveData 본문의
SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA 를 F4 검사 대상으로 잡아 'PROC_M 배선 없음' FAIL → FE 대조표 행 집계 3건까지 증폭.
KEEP 9(주석은 근거가 아니다)·E16(주석 코드는 사실이 아님) — 실행되지 않는 메서드의 문장은 AS-IS 사실이 아니다.

죽은 메서드 = 아래 3중 교차를 모두 통과한 것만(하나라도 확인 못 하면 살아있는 코드로 본다 — 결함을 NA 로 묻는 오판 방지):
  ① AsisFacts actions_entries.csv 에서 entry_kind=unreached 이고, 살아있는 진입점(이벤트 += · override · 생성자) 경로에 한 번도 없음
  ② 화면 폴더 .cs 원문(// · /* */ 주석 제거, 줄 번호 유지)에서 선언 외 이름 참조가 없음 — 단 다른 죽은 메서드 본문 안 참조는
     참조로 치지 않는다(죽은 코드끼리의 호출, 고정점 반복). 대리자·이벤트 연결(+= Foo · new EventHandler(Foo))도 참조로 센다
  ③ override 아님(프레임워크가 부름) · private(접근 한정자 없음 포함)만 — public/protected/internal 은 다른 클래스·하위 클래스가
     부를 수 있어 살아있음으로 본다(GSCM 전체 rg 1회 2분+ 실측 → 실행마다 불가, 2026-10-30)
한계: #if 비활성 블록 안 참조는 참조로 센다(보수 — 살아있음 쪽). 리플렉션(문자열 이름 호출)은 private 메서드에선 쓰지 않는 것으로 본다.
"""
import collections
import csv
import functools
import glob
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from facts_combosrc import strip_comments  # noqa: E402

MODS = r'(?:public|private|protected|internal|static|async|override|virtual|new|sealed|partial|extern|unsafe|abstract)'
NOT_TYPE = {'return', 'await', 'new', 'else', 'throw', 'yield', 'case', 'goto', 'in', 'is', 'as', 'out', 'ref', 'using', 'lock', 'if', 'while', 'foreach', 'for', 'switch'}  # 'return Foo(' 같은 호출을 선언으로 오인 금지


def _rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as fp: return list(csv.DictReader(fp))


def _src_path(rel):
    rel = rel.replace('\\', '/')
    return next((q for q in (os.path.join(ROOT, 'GSCM', rel), os.path.join(ROOT, 'GSCM_20260512', rel)) if os.path.exists(q)), '')


@functools.lru_cache(maxsize=None)
def dead_methods(asis):
    """{(class, method): 근거 문자열} — 실행되지 않는 AS-IS 메서드"""
    sd = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis)
    ents, acts = _rd(os.path.join(sd, 'actions_entries.csv')), _rd(os.path.join(sd, 'actions.csv'))
    if not ents or not acts: return {}
    live = {(r['class'], r['method']) for r in ents if r['entry_kind'] != 'unreached'}
    cand = {(r['class'], r['method']) for r in ents if r['entry_kind'] == 'unreached'} - live
    cand = {k for k in cand if k[1] != '.ctor'}
    if not cand: return {}
    cur = {f['file'] for f in _rd(os.path.join(sd, 'files.csv')) if f.get('variant') in ('current', 'shared')}
    # 메서드 본문 범위(파일별 문장 줄 최소~최대) — 참조가 어느 메서드 안에 있는지 판정
    rng = collections.defaultdict(list)  # basename → [(lo, hi, (cls, meth))]
    files = {}
    by = collections.defaultdict(list)
    for a in acts:
        if cur and a['file'] not in cur: continue
        by[(a['file'], a['class'], a['method'])].append(int(a['line'] or 0))
    for (f, cls, m), ls in by.items():
        rng[os.path.basename(f.replace('\\', '/'))].append((min(ls), max(ls), (cls, m)))
        files.setdefault(f, None)
    folders = {os.path.dirname(p) for p in (_src_path(f) for f in files) if p}
    if not folders: return {}  # 원문 없음 → 확인 불가 = 살아있음
    texts = {}
    for d in folders:
        for g in glob.glob(os.path.join(d, '*.cs')):
            try:
                with open(g, encoding='utf-8-sig', errors='replace') as fp: texts[g] = strip_comments(fp.read()).split('\n')
            except Exception:
                return {}
    meths_in = lambda base, ln: [k for lo, hi, k in rng.get(base, []) if lo <= ln <= hi]
    refs, decl = {}, {}
    for cls, m in cand:
        rx = re.compile(r'(?<!\w)' + re.escape(m) + r'(?!\w)')  # 'this.Foo'·'x.Foo' 도 참조로 센다(이벤트 연결 += this.Foo · 다른 객체 같은 이름 = 보수적으로 살아있음)
        rxd = re.compile(r'^\s*(?:\[[^\]]*\]\s*)*((?:' + MODS + r'\s+)*)([\w<>\[\],.?]+)\s+' + re.escape(m) + r'\s*(?:<[^>()]*>)?\s*\(')
        rs, ds = [], []
        for g, lines in texts.items():
            for i, ln in enumerate(lines, 1):
                if not rx.search(ln): continue
                md = rxd.match(ln)
                if md and md.group(2) not in NOT_TYPE: ds.append((g, i, md.group(1) or ''))
                else: rs.append((os.path.basename(g), i))
        refs[(cls, m)], decl[(cls, m)] = rs, ds
    dead = set(cand)
    why = {}
    for k in list(dead):
        ds = decl[k]
        if not ds: dead.discard(k); continue  # 선언을 원문에서 못 찾음 → 확인 불가
        if any('override' in mods for _, _, mods in ds): dead.discard(k); continue
        if any(re.search(r'\b(public|protected|internal)\b', mods) for _, _, mods in ds): dead.discard(k); continue  # 다른 클래스·하위 클래스가 부를 수 있음 → 살아있음(GSCM 전체 검색은 1회 2분+ 라 실행마다 불가, 2026-10-30 실측)
    changed = True
    while changed:
        changed = False
        for k in list(dead):
            outside = [(b, i) for b, i in refs[k] if not any(o in dead for o in meths_in(b, i))]
            if outside:
                dead.discard(k); changed = True
    for k in dead:
        d0 = decl[k][0]
        inner = [f'{b}:{i}' for b, i in refs[k]]
        why[k] = (f"AS-IS 진입점 미연결 — {os.path.basename(d0[0])}:{d0[1]} {k[0]}.{k[1]} 를 부르는 살아있는 코드 없음"
                  + (f"(참조 {', '.join(inner[:3])} 는 실행되지 않는 메서드 안)" if inner else '(주석 밖 호출 0)')
                  + ' · KEEP 9/E16 주석·미호출 코드는 AS-IS 사실 아님')
    return why


def is_dead_row(asis, cls, meth):
    return (cls, meth) in dead_methods(asis)


@functools.lru_cache(maxsize=None)
def dead_sps(asis):
    """{SP 이름(접두 모듈 제외, 대문자): 근거} — AS-IS 호출이 전부 죽은 메서드 안에만 있는 SP(저장·조회 SP 선택에서 제외)"""
    dm = dead_methods(asis)
    if not dm: return {}
    occ = collections.defaultdict(set)
    for a in _rd(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis, 'actions.csv')):
        for t in re.findall(r'[A-Za-z0-9_]+\.([A-Za-z][A-Za-z0-9_]{5,})|^([A-Za-z][A-Za-z0-9_]{5,})$', a.get('endpoint') or ''):
            sp = (t[0] or t[1]).upper()
            occ[sp].add((a['class'], a['method']))
    return {sp: '; '.join(dm[k] for k in sorted(ks))[:300] for sp, ks in occ.items() if ks and all(k in dm for k in ks)}


def sp_base(name):
    return (name or '').split('.')[-1].upper()


def asis_of(mid, asis=''):
    """AS-IS ID — 인자 우선, 없으면 tools/Harness/rules/map_screen.csv(TO-BE→AS-IS), 없으면 같은 ID"""
    if asis: return asis.upper()
    for r in _rd(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv')):
        if (r.get('tobe_id') or '').upper() == mid.upper(): return r['asis_id'].upper()
    return mid.upper()


def live_golden(mid, asis, kind):
    """Doc/golden/golden_cases.csv 의 화면 케이스 중 실행되는 AS-IS SP 만(kind=SAVE|GET) — 죽은 메서드의 SP 를 '이 화면 저장 SP' 로 고르지 않는다
    (2026-10-30 SCP0041: 첫 SAVE 케이스 = 죽은 SaveData 의 SCP0040_SAVE_CHARACTERISTIC_CAPA → B7·F7 이 엉뚱한 저장 대상 테이블로 판정)"""
    dsp = dead_sps(asis)
    return [g for g in _rd(os.path.join(ROOT, 'Doc', 'golden', 'golden_cases.csv'))
            if g.get('screen') == mid and g.get('kind') == kind and sp_base(g.get('asis_sp')) not in dsp]


if __name__ == '__main__':
    for a in sys.argv[1:]:
        dm = dead_methods(a)
        print(f'[{a}] 실행되지 않는 메서드 {len(dm)}')
        for (c, m), w in sorted(dm.items()): print(f'  {c}.{m}: {w}')
        for sp, w in sorted(dead_sps(a).items()): print(f'  SP {sp} (호출이 전부 죽은 메서드 안)')
