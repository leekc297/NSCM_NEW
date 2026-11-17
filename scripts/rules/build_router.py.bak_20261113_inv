# -*- coding: utf-8 -*-
r"""
build_router.py — RULESET_MASTER.md 에서 '경량 진입 문서' 2종을 추출 생성한다.
  · Doc/_rules_consolidation/TRIGGER_ROUTER.md        ← §2 트리거 매트릭스 + §2.5 카테고리 축 + §7 PR 게이트
  · Doc/_rules_consolidation/UI_MANDATORY_CHECKLIST.md ← §3 UI-MANDATORY 체크리스트 (3.1~3.4)
정본은 여전히 RULESET_MASTER.md 1곳. 이 스크립트는 '복제'가 아니라 '추출'이며,
MASTER 를 고친 뒤 본 스크립트를 재실행하면 추출본이 따라간다 (drift 방지).
추가로 hook 카운트 drift(디스크 실측 vs MASTER 표기)를 보고한다.

사용:  python scripts/rules/build_router.py            (C:\Projects\NSCM 에서)
       python scripts/rules/build_router.py --check    (생성 없이 drift 만 점검, 불일치 시 exit 1)
"""
import io, os, re, sys, glob, datetime

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
MASTER = os.path.join(ROOT, 'Doc', '_rules_consolidation', 'RULESET_MASTER.md')
OUT_DIR = os.path.join(ROOT, 'Doc', '_rules_consolidation')
HOOK_DIR = os.path.join(ROOT, 'Doc', '_rules_v2', 'hooks')
CHECK_ONLY = '--check' in sys.argv

def read(p):
    with io.open(p, 'r', encoding='utf-8-sig') as f:
        return f.read()

def section(text, start_pat, end_pat):
    """## 헤더 start_pat 부터 다음 ## 헤더 end_pat 직전까지 (헤더 포함)"""
    s = re.search(r'(?m)^' + start_pat, text)
    if not s:
        raise SystemExit('section start not found: ' + start_pat)
    e = re.search(r'(?m)^' + end_pat, text[s.start():])
    body = text[s.start():] if not e else text[s.start(): s.start() + e.start()]
    return body.rstrip() + '\n'

def write(p, content):
    if CHECK_ONLY:
        return
    with io.open(p, 'w', encoding='utf-8', newline='\n') as f:
        f.write(content)
    print('wrote', os.path.relpath(p, ROOT), len(content.encode('utf-8')), 'bytes')

master = read(MASTER)
today = datetime.date.today().isoformat()
hdr = ('> ⚙️ **자동 추출본** — 정본 = `Doc/_rules_consolidation/RULESET_MASTER.md`. '
       '직접 편집 금지. MASTER 수정 후 `python scripts/rules/build_router.py` 재실행. '
       '(추출일 %s)\n\n' % today)

# ── 1) TRIGGER_ROUTER.md ───────────────────────────────────────────────
s2  = section(master, r'## §2\. ', r'## §2\.5')
s25 = section(master, r'## §2\.5', r'## §3\. ')
s7  = section(master, r'## §7\. ', r'## §8\. ')
router = (
    '# NSCM TRIGGER ROUTER — 작업 → 룰/Hook 분기표 (경량 진입)\n\n' + hdr +
    '## 사용법\n'
    '1. 요청문에서 **T# 를 1개 이상 고른다** (복수 가능. 판단 불가 시 T00 + 가장 가까운 T#).\n'
    '2. 해당 행의 **핵심 Hook 을 `Doc/_rules_v2/hooks/<name>.md` 에서 Read** 한다 — ⭐⭐⭐ 표기는 생략 불가.\n'
    '3. T01/T01M 이면 `UI_MANDATORY_CHECKLIST.md` 를 PRE-WRITE 로 통과한다.\n'
    '4. 첫 응답 머리에 `[T# 적용: T01, T04 / Read: hook-a, hook-b]` 1줄을 남긴다 (누락 추적용).\n'
    '5. 카탈로그 전체(142+ hook 한 줄 요약)가 필요할 때만 `RULESET_MASTER.md §4` 를 연다.\n\n'
    + s2 + '\n' + s25 + '\n' + s7
)
write(os.path.join(OUT_DIR, 'TRIGGER_ROUTER.md'), router)

# ── 2) UI_MANDATORY_CHECKLIST.md ───────────────────────────────────────
s3 = section(master, r'## §3\. ', r'## §4\. ')
write(os.path.join(OUT_DIR, 'UI_MANDATORY_CHECKLIST.md'),
      '# NSCM UI-MANDATORY CHECKLIST (T01 신규 / T01M 수정 — PRE-WRITE 통과 의무)\n\n' + hdr + s3)

# ── 3) hook 카운트 drift ───────────────────────────────────────────────
disk = len(glob.glob(os.path.join(HOOK_DIR, '*.md')))
m = re.search(r'hook 총수 = \*\*(\d+)\*\*', master)
stated = int(m.group(1)) if m else -1
h4 = re.search(r'## §4\. Hook 카탈로그 \(전체 (\d+)', master)
h4n = int(h4.group(1)) if h4 else -1
print('hook count: disk=%d  MASTER상단=%d  MASTER§4헤더=%d' % (disk, stated, h4n))
if disk != stated or disk != h4n:
    print('⚠ hook count drift — RULESET_MASTER 상단 문단/§4 헤더/00_INDEX §B.3 를 디스크 실측(%d)으로 정정하세요.' % disk)
    if CHECK_ONLY:
        sys.exit(1)
