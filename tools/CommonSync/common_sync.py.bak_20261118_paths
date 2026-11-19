#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
공통소스 다운로드 & 병합 (Vibe_Manager ⬇️🔀 Source Download & Merge) — 2026-10-22

원천 = nscm-fe 의 remote `common`(eunjoo-hwang/nscm-fe, 다운로드 전용 · push URL no_push 확인 후에만 진행 · 푸시 없음)
대상 = nscm-fe 의 apps · features · packages · public · configs (공통 트리는 모노레포라 `nscm-fe/` 접두) — 기본(--areas fe)
     BE 는 따로: --areas be → nscm-be 의 src 만 (2026-11-12 · 공통 트리 `nscm-be/` 접두 · 기준선 = state.json baselineBe
     · 환경 파일 항상 로컬 유지 · 로컬 기동용 설정 2개는 누락 키만 보충 · 로컬 ID 로그인 점검 실패 시 무변경 중단)
방식 = git merge/pull 금지(사내 GitLab 이력과 섞임) → 직전 기준선..common/main 에서 바뀐 파일만 **파일 단위**로 판정·적용

판정 규칙 (메모리 reference_repo_upload_download_commands §2 "내 것이 더 최신이면 내걸로" · 회차 README 08-25~10-14 그대로):
  - 내용 대조(개행·BOM 정규화). mtime 판정 금지
  - 로컬 = 공통의 어떤 이력본(같은 경로 전 이력 + 같은 파일명 이력 = rename 추적)과 일치 → 내 편집 아님 → 공통 채택
  - 차이가 포맷(공백·따옴표·세미콜론·끝 콤마)뿐 → 공통 채택
  - 그 외 = 내 편집본 → 공통도 바뀌었으면 3-way(git merge-file). base = "로컬이 실제 출발한 공통 판본"
    (기준선 시점까지의 이력 중 로컬과 변경량 최소 — 기준선보다 새 판본은 base 후보 제외)
    충돌 0 + 선언 중복 증가 0 → 병합본 적용 / 충돌 → 로컬 유지(결정 대기, conflicts/ 에 base·common·merged)
  - configs/types/procedures.d.ts = RawProcedureMap 메뉴 키 블록 단위 구조 병합 (+ declare global 1건 실존 확인)
  - locales *.json = 키 단위 병합
  - 신규(로컬 부재) → 추가 / 삭제 → 로컬이 이력본과 일치할 때만 삭제(내 편집본이면 유지)

사용:
  python common_sync.py --dry-run [--summary out.json]          분류만(파일 변경 없음) → .vibe/common_sync/PLAN_<시각>.md
  python common_sync.py --apply --target <sha> [--summary ...]   dry-run 때 본 커밋이 맞을 때만 적용 → 백업·README·기준선 갱신
  옵션: --fe <nscm-fe 경로>  --be <nscm-be 경로>  --no-be  --base-be <sha>  --be-work <사본>  --remote common  --branch main  --base <기준선 sha(기본 state.json)>  --no-fetch
종료코드: 0 정상 / 2 사전조건 실패(no_push 아님·기준선 없음 등) / 3 target 불일치 / 4 적용 후 검증 실패
"""
import argparse, datetime, difflib, fnmatch, hashlib, json, os, re, shutil, subprocess, sys, tempfile
from collections import OrderedDict, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
STATE = os.path.join(HERE, 'state.json')
SCOPE = ['apps', 'features', 'packages', 'public', 'configs']
# BE(nscm-be · 2026-11-12) — 공통 트리 `nscm-be/` 의 소스(src)를 같은 규칙으로 받는다. 빌드 설정(build.gradle·settings.gradle·gradle/)·lib·바이너리는 대상 밖
BE_SCOPE = ['src']
# ── BE 로컬 작업환경 보호(사용자 지시 2026-11-12 "BE 다운로드 시 로컬 작업환경을 해치는 것은 차단") ──
# ① 환경 파일 — 작업 모드와 무관하게 항상 로컬 유지(접속 정보·프로필·로그·MyBatis 설정·CORS 는 PC 마다 다르다). 로컬에 없을 때만 공통 원문을 새로 받는다
BE_KEEP = ('src/main/resources/application*.yml', 'src/main/resources/application*.yaml', 'src/main/resources/application*.properties',
           'src/main/resources/config/*', 'src/main/resources/mybatis/mybatis-config.xml',
           'src/main/resources/logback*.xml', 'src/main/resources/log4j*', 'src/main/java/*/framework/config/CorsConfig.java')
# ② 쓰기·삭제 허용 경로 = nscm-be/src 아래뿐. 아래 폴더 조각이 경로에 있으면 차단(저장소·빌드 산출물·IDE·로그)
BE_DENY_PARTS = {'.git', '.gradle', '.idea', '.vscode', '.settings', 'build', 'bin', 'out', 'logs', 'node_modules'}
# ③ BE 저장소(nscm-be/.git)에는 읽기 명령만 — 체크아웃·리셋·클린·스태시·커밋·머지 등 상태를 바꾸는 git 명령은 실행 자체를 막는다
BE_GIT_READONLY = {'status', 'diff', 'config', 'rev-parse'}
def be_local_keep():
    """be_local_keep.txt — 환경 파일과 한 쌍으로 동작해 로컬에 그대로 둬야 하는 BE 소스(작업 모드 무관)"""
    p = os.path.join(HERE, 'be_local_keep.txt')
    if not os.path.exists(p): return ()
    return tuple(l.strip() for l in open(p, encoding='utf-8-sig') if l.strip() and not l.strip().startswith('#'))
def keep_match(rel, pats):
    return any(fnmatch.fnmatchcase(rel, p) for p in pats)
# ④ 환경 파일 중 로컬 기동에 쓰는 2개는 '공통에만 있는 설정 키'만 보충한다(사용자 지시 2026-11-12 — 환경설정이라 DB MODE 에서도 적용).
#    기존 로컬 값·주석·순서는 그대로 두고, 부모 블록이 로컬에 이미 있는 단일 값 키만 공통 기본값으로 끼워 넣는다.
#    접속·SSO·비밀 값 계열 키와 블록째 없는 설정은 넣지 않고 보고서에만 적는다(로컬은 SSO 에 접속하지 않고 ID 로그인을 유지한다).
CFG_SUPPLEMENT = ('src/main/resources/application.yml', 'src/main/resources/config/config-local.yml')
CFG_SKIP = re.compile(r'sso|datasource|password|passwd|username|secret|token|url|host|jdbc|id-login-disabled|domain|endpoint', re.I)
SUPP_CLS = 'BE 환경 파일 — 누락 설정 키 보충(기존 값 유지)'
BE_LOGIN_FILES = ('src/main/java/com/lgcns/nscm/framework/security/filter/JsonLoginFilter.java', 'src/main/java/com/lgcns/nscm/framework/config/SecurityConfig.java')
YML_KEY = re.compile(r'^( *)([A-Za-z0-9_.\-\[\]"\']+)\s*:(?:\s+(.*))?$')
def yml_index(t):
    """들여쓰기 기반 YAML 색인 → (줄[], {경로: (줄 번호, 들여쓰기, 단일 값 여부)}). 목록(- ) 안쪽은 색인하지 않는다"""
    lines = t.split('\n'); stack = []; ent = OrderedDict(); list_ind = None; doc = 0
    for i, raw in enumerate(lines):
        st = raw.strip()
        if raw.startswith('---'): doc += 1; stack = []; list_ind = None; continue  # 문서 구분 — 경로 맨 앞에 문서 번호를 둔다
        if not st or st.startswith('#'): continue
        ind = len(raw) - len(raw.lstrip(' '))
        if st.startswith('- ') or st == '-': list_ind = ind; continue
        if list_ind is not None:
            if ind > list_ind: continue
            list_ind = None
        m = YML_KEY.match(raw)
        if not m: continue
        key = m.group(2).strip('"\''); val = (m.group(3) or '').strip()
        if val.startswith('#'): val = ''
        while stack and stack[-1][0] >= ind: stack.pop()
        path = (f'#{doc}',) + tuple(k for _, k in stack) + (key,)
        ent.setdefault(path, (i, ind, bool(val) and val not in ('|', '>', '|-', '>-')))
        stack.append((ind, key))
    return lines, ent
def yml_flat(obj, pre=()):
    out = {}
    if isinstance(obj, dict):
        for k, v in obj.items(): out.update(yml_flat(v, pre + (str(k),)))
    else: out[pre] = obj
    return out
def cfg_supplement(local_b, common_b, today):
    """→ (보충본 LF bytes 또는 None, 보충한 키[], 블록째 없는 설정[], 일부러 넣지 않은 키[], 오류 문자열)"""
    lt, ct = text(eoln(local_b)), text(eoln(common_b))
    L, Le = yml_index(lt); C, Ce = yml_index(ct)
    adds = defaultdict(list); blocks = []; skipped = []
    for path, (i, ind, scalar) in Ce.items():
        if path in Le: continue
        miss = next((path[:k] for k in range(2, len(path)) if path[:k] not in Le), None)
        if miss is not None:
            if miss not in blocks: blocks.append(miss)
            continue
        if not scalar or len(path) <= 2:
            if path not in blocks: blocks.append(path)
            continue
        if CFG_SKIP.search('.'.join(path[1:])): skipped.append(path); continue
        adds[path[:-1]].append((path, C[i].strip()))
    if not adds: return None, [], [b[1:] for b in blocks], [b[1:] for b in skipped], ''
    ins = []  # (끼워 넣을 줄 번호, [줄…])
    for parent, items in adds.items():
        pi, pind, _ = Le[parent]
        kids = [v[1] for k, v in Le.items() if len(k) == len(parent) + 1 and k[:len(parent)] == parent]
        cind = min(kids) if kids else pind + 2
        end = pi
        for j in range(pi + 1, len(L)):
            st = L[j].strip()
            if not st: continue
            if len(L[j]) - len(L[j].lstrip(' ')) <= pind and not st.startswith('#'): break
            if len(L[j]) - len(L[j].lstrip(' ')) > pind: end = j
        ins.append((end + 1, [' ' * cind + f'# [공통소스 BE 다운로드 {today}] 로컬에 없던 설정 키 보충 — 값은 공통 기본값'] + [' ' * cind + ln for _, ln in items]))
    out = list(L)
    for at, new in sorted(ins, key=lambda x: -x[0]): out[at:at] = new
    merged = '\n'.join(out)
    full = [p for items in adds.values() for p, _ in items]; added = ['.'.join(p[1:]) for p in full]
    blocks = [b[1:] for b in blocks]; skipped = [b[1:] for b in skipped]
    try:  # 보충본이 올바른 YAML 인지, 기존 로컬 값이 하나도 안 바뀌었는지, 보충 키가 실제로 읽히는지
        import yaml
        def flat_all(t):
            o = {}
            for n, d in enumerate(yaml.safe_load_all(t)): o.update(yml_flat(d, (f'#{n}',)))
            return o
        a0, a1 = flat_all(lt), flat_all(merged)
        changed = [k for k, v in a0.items() if a1.get(k, object()) != v]
        if changed: return None, [], blocks, skipped, f'보충 취소 — 기존 값이 달라짐: {".".join(changed[0])}'
        lost = ['.'.join(p[1:]) for p in full if p not in a1]
        if lost: return None, [], blocks, skipped, f'보충 취소 — 보충 키가 읽히지 않음: {lost[0]}'
    except ImportError:
        return None, [], blocks, skipped, '보충 취소 — PyYAML 없음(검증 불가)'
    except Exception as e:
        return None, [], blocks, skipped, f'보충 취소 — YAML 검증 실패: {str(e)[:120]}'
    return merged.encode('utf-8', 'surrogateescape'), added, blocks, skipped, ''
DTS = 'configs/types/procedures.d.ts'
CODE_EXT = {'.ts', '.tsx', '.js', '.jsx', '.mjs', '.cjs', '.scss', '.css', '.json', '.d.ts'}

# ───────────────────────── git ─────────────────────────
class Git:
    def __init__(self, cwd):
        self.cwd = cwd; self._cat = None; self._cache = {}
    def run(self, *args, check=True, inp=None):
        r = subprocess.run(['git', '-c', 'core.quotepath=false', *args], cwd=self.cwd, input=inp, capture_output=True,
                           env=dict(os.environ, GIT_TERMINAL_PROMPT='0'))
        if check and r.returncode != 0:
            raise RuntimeError(f"git {' '.join(args)} 실패({r.returncode}): {r.stderr.decode('utf-8', 'replace').strip()[:400]}")
        return r
    def out(self, *args, check=True):
        return self.run(*args, check=check).stdout.decode('utf-8', 'surrogateescape')
    def blob(self, sha):
        """blob bytes — cat-file --batch 1개 프로세스 재사용"""
        if sha in self._cache: return self._cache[sha]
        if self._cat is None:
            self._cat = subprocess.Popen(['git', 'cat-file', '--batch'], cwd=self.cwd, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        self._cat.stdin.write((sha + '\n').encode()); self._cat.stdin.flush()
        head = self._cat.stdout.readline().decode().split()
        if len(head) < 3 or head[1] == 'missing': self._cache[sha] = None; return None
        n = int(head[2]); data = self._cat.stdout.read(n); self._cat.stdout.read(1)
        if len(self._cache) < 4000: self._cache[sha] = data
        return data
    def blob_at(self, commit, path):
        r = self.run('rev-parse', '--verify', '-q', f'{commit}:{path}', check=False)
        return self.blob(r.stdout.decode().strip()) if r.returncode == 0 else None
    def close(self):
        if self._cat: self._cat.stdin.close(); self._cat.wait()
class ReadOnlyGit(Git):
    """BE 저장소용 — 읽기 명령만 통과(BE_GIT_READONLY). 그 밖의 명령은 실행하지 않고 오류"""
    def run(self, *args, check=True, inp=None):
        if not args or args[0] not in BE_GIT_READONLY or (args[0] == 'config' and '--get' not in args):
            raise RuntimeError(f"⛔ BE 저장소에 허용되지 않은 git 명령 차단: git {' '.join(args)}")
        return super().run(*args, check=check, inp=inp)
    def blob(self, sha): raise RuntimeError('⛔ BE 저장소 객체 접근 차단')

# ───────────────────────── 정규화·판정 보조 ─────────────────────────
def lpath(p):
    """Windows 260자 경로 한도 회피 — \\\\?\\ 접두(절대경로·역슬래시 필수)"""
    p = os.path.abspath(p.replace('/', os.sep))
    return '\\\\?\\' + p if os.name == 'nt' and not p.startswith('\\\\?\\') else p
def wfile(p, b):
    lp = lpath(p); os.makedirs(os.path.dirname(lp), exist_ok=True)
    with open(lp, 'wb') as f: f.write(b)
def rfile(p):
    lp = lpath(p)
    if not os.path.isfile(lp): return None
    with open(lp, 'rb') as f: return f.read()
def is_binary(b): return b is not None and b'\x00' in b[:8000]
def text(b): return b.decode('utf-8', 'surrogateescape')
def norm(b):
    """개행·BOM 정규화(내용 대조용)"""
    if b is None: return None
    if is_binary(b): return b
    t = text(b)
    if t.startswith('﻿'): t = t[1:]
    t = t.replace('\r\n', '\n').replace('\r', '\n')
    return '\n'.join(l.rstrip() for l in t.split('\n')).rstrip('\n').encode('utf-8', 'surrogateescape')
def eoln(b):
    """쓰기·병합 입력용 — BOM 제거 + CRLF→LF 만(줄 끝 공백 등 내용은 그대로). norm 은 비교 전용"""
    if b is None or is_binary(b): return b
    t = text(b)
    if t.startswith('﻿'): t = t[1:]
    return t.replace('\r\n', '\n').encode('utf-8', 'surrogateescape')
def conv(lf_bytes, eol, bom=False):
    """LF 본문 → 대상 개행·BOM"""
    t = text(lf_bytes)
    if eol == '\r\n': t = t.replace('\n', '\r\n')
    return (b'\xef\xbb\xbf' if bom else b'') + t.encode('utf-8', 'surrogateescape')
def h(b): return None if b is None else hashlib.sha1(b).hexdigest()
def fmt_norm(b):
    """포맷 차이 무시 비교용(공백·따옴표·세미콜론·닫힘 앞 콤마)"""
    t = text(norm(b))
    t = re.sub(r'\s+', '', t); t = re.sub(r'[\'"`]', '"', t); t = t.replace(';', ''); t = re.sub(r',([)\]}])', r'\1', t)
    return t
def code_file(p): return os.path.splitext(p)[1].lower() in CODE_EXT
def eol_of(b):
    return '\r\n' if b is not None and not is_binary(b) and b'\r\n' in b else '\n'
def has_bom(b): return b is not None and b.startswith(b'\xef\xbb\xbf')
DECL = re.compile(r'^\s*(?:export\s+)?(?:default\s+)?(?:declare\s+)?(?:async\s+)?(?:const|let|var|function|class|interface|type|enum)\s+([A-Za-z_$][\w$]*)', re.M)
# BE: Java 메서드(이름+인자) · MyBatis XML 의 id — 양쪽이 같은 것을 각자 더한 병합은 충돌 0 이어도 컴파일/기동이 깨진다
JAVA_DECL = re.compile(r'^[ \t]*(?:(?:public|private|protected|static|final|abstract|synchronized|default)\s+)+(?:<[^>]+>\s+)?[\w.<>\[\], ?]+?\s+([A-Za-z_$][\w$]*)\s*\(([^)]*)\)\s*(?:throws\s+[\w., ]+)?\s*[{;]', re.M)
XML_ID = re.compile(r'<(?:select|insert|update|delete|sql|resultMap)\b[^>]*?\bid\s*=\s*"([^"]+)"')
def decl_counts(b, rel=''):
    c = defaultdict(int); t = text(norm(b)); ext = os.path.splitext(rel or '')[1].lower()
    if ext == '.java':
        for m in JAVA_DECL.finditer(t): c[m.group(1) + '(' + re.sub(r'\s+', ' ', m.group(2)).strip() + ')'] += 1
        for m in re.finditer(r'^\s*(?:public\s+|abstract\s+|final\s+)*(?:class|interface|enum|record)\s+([A-Za-z_$][\w$]*)', t, re.M): c[m.group(1)] += 1
        return c
    if ext == '.xml':
        for m in XML_ID.finditer(t): c['id=' + m.group(1)] += 1
        return c
    for m in DECL.finditer(t): c[m.group(1)] += 1
    return c
def dup_increase(merged, local, common, rel=''):
    """병합본에서 같은 이름 선언이 양쪽 원본보다 늘어난 것(양쪽이 같은 일을 각자 한 병합 = 선언 중복)"""
    m, l, c = decl_counts(merged, rel), decl_counts(local, rel), decl_counts(common, rel)
    return sorted(k for k, v in m.items() if v > max(l.get(k, 0), c.get(k, 0)))
def diff_size(a, b):
    sm = difflib.SequenceMatcher(None, text(a).split('\n'), text(b).split('\n'), autojunk=False)
    return sum(max(i2 - i1, j2 - j1) for tag, i1, i2, j1, j2 in sm.get_opcodes() if tag != 'equal')
def origin_score(local_n, cand_n):
    """base 후보 점수 = (후보에 있고 로컬에 없는 줄 수, 전체 변경 줄 수) — 작을수록 '로컬이 실제 출발한 판본'.
    후보에만 있는 줄 = 내가 지운 것 또는 공통이 나중에 더한 것 → 이게 많은 후보를 base 로 쓰면 공통 추가분이 '내 삭제'로 오판돼 사라진다
    (10-14 재현 실측: forecast-price.constants 기준선 base → 공통 주석 블록 18줄 유실 / 936315877 base → 보존, README 와 일치)"""
    sm = difflib.SequenceMatcher(None, text(cand_n).split('\n'), text(local_n).split('\n'), autojunk=False)
    rem = add = 0
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag != 'equal': rem += i2 - i1; add += j2 - j1
    # 가중합 — 후보에만 있는 줄(rem)을 3배로 벌점. rem 만 우선하면 아주 이른 작은 판본(rem≈0·add 수백)이 뽑힌다(재현 실측 2bed0e106)
    return (3 * rem + add, rem)
def merge3(git, local_b, base_b, common_b):
    """git merge-file -p — 입력은 eoln(LF) 으로 맞춰 개행 차이가 충돌로 잡히지 않게 → (병합 LF bytes, 충돌 수)"""
    with tempfile.TemporaryDirectory() as d:
        fs = []
        for nm, b in (('mine', local_b), ('base', base_b), ('common', common_b)):
            p = os.path.join(d, nm); open(p, 'wb').write(eoln(b)); fs.append(p)
        r = subprocess.run(['git', 'merge-file', '-p', '-L', 'mine(local)', '-L', 'base', '-L', 'common', *fs], capture_output=True)
        if r.returncode < 0 or r.returncode > 127: raise RuntimeError('merge-file 오류: ' + r.stderr.decode('utf-8', 'replace'))
        return r.stdout, r.returncode

# ───────────────────────── 공통 이력 색인 ─────────────────────────
class History:
    """common 이력의 경로별 blob 판본. path_all: 전 이력(common/main), path_upto: 기준선까지(base 후보), name_all: 파일명별(rename 추적)"""
    def __init__(self, git, prefix, base, tip, scope=None):
        self.git = git; self.path_all = defaultdict(list); self.path_upto = defaultdict(list); self.name_all = defaultdict(set)
        upto = set(git.out('rev-list', base).split()) if base else set()
        log = git.out('log', '--format=@%H', '--raw', '--no-abbrev', '--no-renames', '-m', tip, '--', *[prefix + s for s in (scope or SCOPE)])
        cur = None
        for line in log.split('\n'):
            if line.startswith('@'): cur = line[1:].strip(); continue
            if not line.startswith(':'): continue
            meta, _, path = line.partition('\t')
            parts = meta.split()
            if len(parts) < 5 or not path.startswith(prefix): continue
            # 그 커밋이 만든 판본(new)만 기록 — 이전 판본(old)을 같은 커밋으로 묶으면 base 선택·라벨이 틀어진다(10-14 재현 실측)
            rel = path[len(prefix):]; sha = parts[3]
            if set(sha) == {'0'}: continue
            self.path_all[rel].append((cur, sha)); self.name_all[os.path.basename(rel)].add(sha)
            if cur in upto: self.path_upto[rel].append((cur, sha))
        self._nh = {}
    def nhash(self, sha):
        if sha not in self._nh: b = self.git.blob(sha); self._nh[sha] = h(norm(b)) if b is not None else None
        return self._nh[sha]
    def matches_history(self, rel, local_n):
        """로컬(정규화)이 공통 이력본 중 하나와 일치? → (근거, sha)"""
        lh = h(local_n)
        for c, sha in self.path_all.get(rel, []):
            if self.nhash(sha) == lh: return ('같은 경로 이력', c[:9])
        for sha in self.name_all.get(os.path.basename(rel), ()):
            if self.nhash(sha) == lh: return ('같은 파일명 이력(rename)', sha[:9])
        return None
    def matches_history_fmt(self, rel, local_n):
        if not code_file(rel): return None
        lf = fmt_norm(local_n)
        for c, sha in self.path_all.get(rel, []):
            b = self.git.blob(sha)
            if b is not None and not is_binary(b) and fmt_norm(b) == lf: return ('포맷 차이만(이력본)', c[:9])
        return None
    def pick_base(self, rel, local_n, base_commit_blob):
        """3-way base = 기준선 시점까지 이력 중 로컬과 변경량 최소(기준선보다 새 판본 제외)"""
        cands = OrderedDict()  # 키 → 원본 bytes (비교는 norm, 병합 입력은 원본)
        if base_commit_blob is not None: cands['기준선'] = base_commit_blob
        for c, sha in self.path_upto.get(rel, []):
            if c[:9] in cands: continue
            b = self.git.blob(sha)
            if b is not None and not is_binary(b): cands[c[:9]] = b
        if not cands: return None, None
        return min(cands.items(), key=lambda kv: origin_score(local_n, norm(kv[1])))

# ───────────────────────── procedures.d.ts 블록 병합 ─────────────────────────
KEY_RE = re.compile(r'^\s{2}([A-Za-z0-9_\'"]+)\s*:\s*\{\s*(?://.*)?$')  # `  SYS0005: { // 설명` 형태 포함
def dts_split(b):
    """→ (머리, OrderedDict{키: 블록}, 꼬리). RawProcedureMap 의 2칸 들여쓰기 최상위 키 단위"""
    lines = text(eoln(b)).split('\n')
    try: s = next(i for i, l in enumerate(lines) if re.match(r'^\s*(export\s+)?interface\s+RawProcedureMap\b', l))
    except StopIteration: return None
    head = lines[:s + 1]; blocks = OrderedDict(); i = s + 1; pre = []
    while i < len(lines):
        l = lines[i]
        if re.match(r'^\}', l): break
        m = KEY_RE.match(l)
        if m:
            key = m.group(1).strip('\'"'); depth = 0; blk = pre + []; pre = []
            while i < len(lines):
                blk.append(lines[i]); depth += lines[i].count('{') - lines[i].count('}'); i += 1
                if depth <= 0: break
            if key in blocks: key = key + '#dup'
            blocks[key] = '\n'.join(blk); continue
        pre.append(l); i += 1
    tail = pre + lines[i:]
    return '\n'.join(head), blocks, '\n'.join(tail)
def dts_merge(git, local_b, base_b, common_b, upload=False, keys=None):
    """upload=True: L=공통 tip · N=로컬 — 로컬에 없는 블록을 '삭제'로 반영하지 않고(과거 유실 블록이 공통에서 지워지는 사고 방지),
    공통이 지운 블록을 되살리지 않는다. 꼬리(declare global) 복구 규칙도 다운로드 전용"""
    L, B, N = dts_split(local_b), dts_split(base_b) if base_b else None, dts_split(common_b)
    if not L or not N: return None, ['RawProcedureMap 파싱 실패']
    B = B or ('', OrderedDict(), '')
    rows = defaultdict(list); pend = []
    def bn(s):  # 블록 비교용 — 앞뒤 빈 줄·줄 끝 공백 무시(블록 앞 빈 줄 차이로 '내 편집' 오판 방지)
        return None if s is None else '\n'.join(x.rstrip() for x in s.split('\n')).strip('\n')
    def piece(name, l0, b0, n0):
        l, b, n = bn(l0), bn(b0), bn(n0)
        r = _piece(name, l, b, n)
        return {b: b0, n: n0, l: l0}.get(r, r) if r is not None else None  # 같은 내용이면 원문(공백 포함) 반환 — 겹치면 로컬 원문 우선
    def _piece(name, l, b, n):
        if l == n: rows['동일'].append(name); return l
        if keys is not None and name not in keys:  # 화면 단위 업로드 — 그 화면 메뉴 키 블록만 올리고 나머지(머리·꼬리 포함)는 공통 그대로
            rows['공통 유지 — 이 화면 키 아님(업로드 제외)'].append(name); return l
        if upload and n is None: rows['공통 유지 — 로컬에 없는 블록(업로드는 삭제 안 함)'].append(name); return l
        if upload and l is None and b is not None: rows['제외 — 공통이 삭제한 블록(되살리지 않음)'].append(name); return None
        if l is None and n is not None:
            if b is None: rows['공통 신규 추가'].append(name)
            else: rows['로컬 부재 → 공통 원문 복구(과거 유실 의심)'].append(name)
            return n
        if n is None:
            if l == b: rows['공통 삭제 반영'].append(name); return None
            rows['로컬 유지 — 공통 삭제·내 편집'].append(name) if b is not None else rows['로컬 전용 유지'].append(name); return l
        if l == b: rows['공통 채택 — 로컬 = 기준선'].append(name); return n
        if n == b: rows['로컬 유지 — 공통 무변경·내 편집'].append(name); return l
        if b is None: rows['로컬 유지 — 기준선 부재·양쪽 상이(결정 대기)'].append(name); pend.append(name); return l
        m, c = merge3(git, l.encode(), b.encode(), n.encode())
        if c == 0: rows['블록 내부 3-way — 충돌 0'].append(name); return text(m)
        rows['로컬 유지 — 블록 3-way 충돌(결정 대기)'].append(f'{name}({c})'); pend.append(name); return l
    head = piece('(머리)', L[0], B[0], N[0])
    if not upload and 'declare global' not in L[2] and 'declare global' in N[2]:  # 전역 타입 선언부 유실(09-22~10-14 실사고) → 공통 원문 복구
        rows['로컬 부재 → 공통 원문 복구(과거 유실 의심)'].append('(꼬리: declare global)'); tail = N[2]
    else: tail = piece('(꼬리: ProcessedProcedures·declare global)', L[2], B[2], N[2])
    out = []
    for k in list(N[1].keys()) + [k for k in L[1] if k not in N[1]]:
        v = piece(k, L[1].get(k), B[1].get(k), N[1].get(k))
        if v is not None: out.append(v)
    merged = '\n'.join([head or '', *out, tail or ''])
    # 블록 앞에 주석 줄이 붙어 있을 수 있어 블록 안의 첫 키 줄로 이름을 얻는다
    names = [next((m.group(1).strip('\'"') for m in map(KEY_RE.match, x.split('\n')) if m), '?') for x in out]
    dup = sorted({k for k in names if names.count(k) > 1})
    checks = {'멤버 수(로컬→병합)': f'{len(L[1])} → {len(out)}', '중복 키': len(dup), 'declare global': merged.count('declare global'),
              '로컬 키 유실': sorted(set(L[1]) - set(names) - {k for k in L[1] if k not in N[1] and B[1].get(k) == L[1].get(k)}),
              '공통 키 유실': sorted(set(N[1]) - set(names))}
    return merged.encode('utf-8', 'surrogateescape'), (rows, checks, pend, dup)

# ───────────────────────── locales JSON 키 병합 ─────────────────────────
def json_merge(local_b, base_b, common_b, upload=False):
    """upload=True: L=공통 tip · N=로컬 — 로컬에 없는 키를 삭제로 반영하지 않는다(공통 키 유지)"""
    L = json.loads(text(norm(local_b)), object_pairs_hook=OrderedDict)
    N = json.loads(text(norm(common_b)), object_pairs_hook=OrderedDict)
    B = json.loads(text(norm(base_b)), object_pairs_hook=OrderedDict) if base_b else OrderedDict()
    st = defaultdict(int); conflicts = []
    def m(l, b, n, path):
        if isinstance(l, dict) and isinstance(n, dict):
            out = OrderedDict(); bb = b if isinstance(b, dict) else {}
            for k in list(l.keys()) + [k for k in n if k not in l]:
                miss = object()
                lv, bv, nv = l.get(k, miss), bb.get(k, miss), n.get(k, miss)
                r = m(None if lv is miss else lv, None if bv is miss else bv, None if nv is miss else nv, path + [k]) if not (lv is miss or nv is miss) else None
                if lv is miss: st['공통 신규 키'] += 1; out[k] = nv; continue
                if nv is miss:
                    if bv is not miss and bv == lv and not upload: st['공통 삭제 키'] += 1; continue
                    st['로컬 전용 키 유지'] += 1; out[k] = lv; continue
                out[k] = r
            return out
        if l == n: return l
        if l == b: st['공통 값 채택'] += 1; return n
        if n == b: st['로컬 값 유지'] += 1; return l
        st['충돌 → 로컬 유지'] += 1; conflicts.append('.'.join(map(str, path))); return l
    res = m(L, B, N, [])
    return json.dumps(res, indent=2, ensure_ascii=False).encode('utf-8'), dict(st), conflicts

# ───────────────────────── 본체 ─────────────────────────
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--fe', default=os.path.join(ROOT, 'nscm-fe')); ap.add_argument('--remote', default='common'); ap.add_argument('--branch', default='main')
    ap.add_argument('--be', default=os.path.join(ROOT, 'nscm-be'), help='BE 로컬 폴더(기본 nscm-be) — 공통 트리의 nscm-be/src 를 같은 규칙으로 받는다')
    ap.add_argument('--be-work', help='BE 를 읽고 쓰는 사본 폴더(시험용). --work 시험에서는 이것을 줄 때만 BE 를 다룬다'); ap.add_argument('--no-be', action='store_true', help='BE 를 다루지 않는다(FE 만)')
    ap.add_argument('--restore-be-from', help='되돌리기: 이 백업 폴더(…_PRE_COMMON_…)의 local_before/nscm-be 에서 BE 파일을 복원한다(--restore-be-paths 필수)')
    ap.add_argument('--restore-be-paths', help='되돌릴 BE 파일(nscm-be 기준 경로, 쉼표 구분) — src 아래만')
    ap.add_argument('--areas', choices=('fe', 'be', 'all'), default='fe', help='받을 영역 — fe(기본: nscm-fe 만) / be(nscm-be/src 만 — Source Download & Merge(BE)) / all')
    ap.add_argument('--no-cfg-supplement', action='store_true', help='BE 환경 파일의 누락 설정 키 보충을 하지 않는다')
    ap.add_argument('--base-be', help='BE 기준선 sha(기본 state.json baselineBe · 없으면 공통 최신 트리와 직접 대조)')
    ap.add_argument('--base'); ap.add_argument('--target'); ap.add_argument('--tip', help='비교 대상 커밋(기본 <remote>/<branch>) — 회차 재현 시험용'); ap.add_argument('--work', help='로컬 파일을 읽고 쓰는 폴더(기본 = --fe). 사본 시험용'); ap.add_argument('--summary'); ap.add_argument('--no-fetch', action='store_true')
    g = ap.add_mutually_exclusive_group(required='--restore-be-from' not in sys.argv); g.add_argument('--dry-run', action='store_true'); g.add_argument('--apply', action='store_true')
    g.add_argument('--upload-prepare', action='store_true', help='Source Upload(UI) 준비 — 선택 파일별로 올릴 내용(전체/내 작업분만)을 --out 에 만든다')
    ap.add_argument('--overwrite-local', action='store_true', help='DB MODE — 로컬 소스를 보호하지 않는다: 공통에 있는 파일은 내 편집본도 공통 원문으로 덮어쓰고, 공통이 지운 파일은 내 편집본도 삭제한다. 공통에 없는 로컬 전용 파일은 유지')
    ap.add_argument('--keys', help='--upload-prepare: procedures.d.ts 에서 올릴 메뉴 키(쉼표) — 보통 화면 ID. 없으면 내 블록 전부')
    ap.add_argument('--files-from', help='--upload-prepare: 올릴 파일 목록(nscm-fe 기준 상대경로, 줄 단위)'); ap.add_argument('--out', help='--upload-prepare: 결과 폴더')
    a = ap.parse_args()
    if a.upload_prepare: return upload_prepare(a)
    if a.restore_be_from: return restore_be(a)
    work = a.work or a.fe
    git = Git(a.fe); now = datetime.datetime.now(); stamp = now.strftime('%Y%m%d_%H%M%S')
    summary = {'ok': False, 'mode': 'apply' if a.apply else 'dry-run', 'stamp': stamp}
    def finish(code, **kw):
        summary.update(kw); git.close()
        if a.summary: open(a.summary, 'w', encoding='utf-8').write(json.dumps(summary, ensure_ascii=False, indent=1))
        sys.exit(code)
    # 사전조건: 다운로드 전용 원격(push URL no_push) — 아니면 진행 금지
    push = git.out('config', '--get', f'remote.{a.remote}.pushurl', check=False).strip()
    if push != 'no_push': print(f'⛔ remote {a.remote} 의 push URL 이 no_push 가 아님({push or "미설정"}) — 다운로드 전용 보호 설정 후 실행'); finish(2, error='pushurl')
    state = json.load(open(STATE, encoding='utf-8')) if os.path.exists(STATE) else {}
    base = a.base or state.get('baseline')
    if not base: print('⛔ 기준선 없음 — --base 지정 또는 state.json'); finish(2, error='no-baseline')
    if not a.no_fetch:
        print(f'⬇️ git fetch {a.remote} …', flush=True)
        r = git.run('fetch', a.remote, check=False); print(text(r.stdout + r.stderr).strip())
        if r.returncode != 0: print('⛔ fetch 실패'); finish(2, error='fetch')
    tip_ref = a.tip or f'{a.remote}/{a.branch}'; tip = git.out('rev-parse', tip_ref).strip()
    if git.run('cat-file', '-e', base + '^{commit}', check=False).returncode != 0: print(f'⛔ 기준선 커밋 {base} 이 로컬에 없음'); finish(2, error='baseline-missing')
    base = git.out('rev-parse', base).strip()
    if a.apply and a.target and not tip.startswith(a.target): print(f'⛔ 미리보기 때 커밋({a.target[:9]})과 지금 {tip_ref}({tip[:9]}) 가 다름 — 다시 미리보기'); finish(3, error='target-mismatch', tip=tip)
    anc = git.run('merge-base', '--is-ancestor', base, tip, check=False).returncode == 0
    prefix = 'nscm-fe/' if git.out('ls-tree', '--name-only', tip, 'nscm-fe/').strip() else ''
    tip_info = git.out('log', '-1', '--format=%h %cd %an %s', '--date=format:%Y-%m-%d %H:%M', tip).strip()
    ncommits = int(git.out('rev-list', '--count', f'{base}..{tip}').strip() or 0)
    print(f'기준선 {base[:9]} → 최신 {tip_info} · 신규 커밋 {ncommits}{"" if anc else " · ⚠ 기준선이 조상 아님(force-push 재작성)"}')
    # 영역 — FE(nscm-fe) + BE(nscm-be · 2026-11-12 추가). BE 는 공통 트리에 `nscm-be/` 가 있고 로컬 폴더가 있을 때만.
    #   사본 시험(--work)에서는 --be-work 를 줄 때만 BE 를 다룬다(실제 nscm-be 를 건드리지 않게)
    want_fe, want_be = a.areas in ('fe', 'all'), a.areas in ('be', 'all')
    areas = [{'key': 'fe', 'label': 'FE', 'prefix': prefix, 'work': work, 'scope': SCOPE, 'base': base, 'keep': (), 'show': ''}] if want_fe else []
    be_work = a.be_work or (None if a.work else a.be); be_skip = ''
    if a.no_be or not want_be: be_skip = '이번 실행 대상 아님(BE 는 --areas be 로 따로 받는다)'
    elif not prefix or not git.out('ls-tree', '--name-only', tip, 'nscm-be/').strip(): be_skip = '공통 트리에 nscm-be/ 없음'
    elif not be_work: be_skip = '사본 시험(--work) — --be-work 미지정'
    elif not os.path.isdir(be_work): be_skip = f'로컬 폴더 없음({be_work})'
    if be_skip:
        if want_be: print(f'⛔ [BE] 받을 수 없음 — {be_skip}'); finish(2, error='be-unavailable', detail=be_skip)
    else:
        be_base = a.base_be or state.get('baselineBe')
        if be_base and git.run('cat-file', '-e', be_base + '^{commit}', check=False).returncode != 0:
            print(f'⚠ [BE] 기준선 커밋 {be_base} 이 로컬에 없음 — 기준선 없이 공통 최신 트리와 직접 대조'); be_base = None
        if be_base: be_base = git.out('rev-parse', be_base).strip()
        print(f'[BE] 기준선 {be_base[:9] if be_base else "없음(첫 회차)"} · 대상 nscm-be/{"·".join(BE_SCOPE)} · 환경 파일 항상 로컬 유지 {len(BE_KEEP)}종(설정·접속·로그·CORS) + 로컬 필수 유지 소스 {len(be_local_keep())}개')
        areas.append({'key': 'be', 'label': 'BE', 'prefix': 'nscm-be/', 'work': be_work, 'scope': BE_SCOPE, 'base': be_base, 'keep': BE_KEEP + be_local_keep(), 'show': 'nscm-be/'})
    # DB MODE(--overwrite-local) 는 공통 새 커밋이 없어도 내 편집본을 공통 원문으로 되돌려야 하므로 여기서 끝내지 않는다
    today = f'{now:%Y-%m-%d}'
    if not want_fe: base_show = areas[0]['base'] or ''  # BE 전용 실행 — 요약의 기준선은 BE 기준선
    else: base_show = base
    if all(ar['base'] == tip for ar in areas) and not a.overwrite_local: print('✅ 새 변경 없음'); finish(0, ok=True, tip=tip, base=base_show, counts={}, changed=0, areas_sel=a.areas)
    plan = []  # dict(rel, work, show, area, st, cls, action, note, data)
    KEEP_CLS = '로컬 환경 파일·필수 유지 소스 — 항상 로컬 유지'
    def classify(ar):
        """한 영역(FE=nscm-fe / BE=nscm-be)의 파일을 판정해 plan 에 더한다 → 그 영역의 공통 변경 건수"""
        aprefix, awork, ascope, abase, akeep, fe_area = ar['prefix'], ar['work'], ar['scope'], ar['base'], ar['keep'], ar['key'] == 'fe'
        def tag(rel): return {'rel': rel, 'work': awork, 'show': ar['show'] + rel, 'area': ar['key']}
        def keep_item(rel, lb, nb):
            """환경 파일 → (구분, 처리, 비고, 자료). 기본 = 로컬 유지. 로컬 기동용 설정 2개는 누락 키만 보충"""
            note = '' if norm(lb) == norm(nb) else ('공통이 삭제' if nb is None else '공통과 다름 — 필요하면 직접 반영')
            if nb is not None and rel in CFG_SUPPLEMENT and not a.no_cfg_supplement and norm(lb) != norm(nb):
                merged, added, blocks, skipped, err = cfg_supplement(lb, nb, today)
                extra = (f' · 공통에만 있는 설정 블록(넣지 않음 — 직접 확인): {", ".join(".".join(b) for b in blocks[:8])}' if blocks else '') + \
                        (f' · 접속·SSO 계열이라 넣지 않은 키: {", ".join(".".join(b) for b in skipped[:8])}' if skipped else '') + (f' · {err}' if err else '')
                if added: return SUPP_CLS, 'merge', f'보충 {len(added)}개: {", ".join(added)}' + extra, {'merged': merged, 'added': added}
                note += extra
            return KEEP_CLS, 'keep', note, None
        paths = [aprefix + s for s in ascope]
        changes = []
        if abase:
            for line in git.out('diff', '--name-status', '--no-renames', abase, tip, '--', *paths).split('\n'):
                if not line.strip(): continue
                st, _, p = line.partition('\t'); changes.append((st[0], p[len(aprefix):]))
        elif not a.overwrite_local:
            # 기준선 없는 첫 회차(BE 2026-11-12) — 공통 최신 트리와 로컬을 직접 대조해 다른 파일만 대상으로 삼는다(삭제는 판정하지 않는다)
            for rec in git.run('ls-tree', '-r', '-z', tip, '--', *paths).stdout.split(b'\0'):
                if not rec: continue
                meta, _, pth = rec.partition(b'\t'); kind, sha = meta.decode().split()[1:3]
                if kind != 'blob': continue
                rel = pth.decode('utf-8')[len(aprefix):]; lb = rfile(os.path.join(awork, rel))
                if lb is None: changes.append(('A', rel))
                elif norm(lb) != norm(git.blob(sha)): changes.append(('M', rel))
        print(f'[{ar["label"]}] 대상 {len(changes)}건 분류 중 …' + ('' if abase else ' (기준선 없음 — 공통 최신 트리와 직접 대조)'), flush=True)
        hist = None if a.overwrite_local else History(git, aprefix, abase or tip, tip, ascope)
        if a.overwrite_local:
            # DB MODE: 판정 없이 공통 최신 트리 기준으로 맞춘다 — 로컬 보호 안 함. ls-tree 로 blob id 를 한 번에 받아 파일별 프로세스 호출을 피한다
            print('⚠ DB MODE — 로컬 소스 보호 안 함: 내 편집본도 공통 원문으로 덮어씁니다', flush=True)
            status_of = dict((rel, st) for st, rel in changes)
            tree = {}
            for rec in git.run('ls-tree', '-r', '-z', tip, '--', *[aprefix + s for s in ascope]).stdout.split(b'\0'):
                if not rec: continue
                meta, _, pth = rec.partition(b'\t')
                kind, sha = meta.decode().split()[1:3]
                if kind == 'blob': tree[pth.decode('utf-8')[len(aprefix):]] = sha
            for rel, sha in tree.items():
                lb = rfile(os.path.join(awork, rel)); nb = git.blob(sha); st = status_of.get(rel, '-')
                it = {**tag(rel), 'st': st, 'local': lb, 'common': nb, 'note': '', 'data': None}
                if lb is not None and keep_match(rel, akeep): kc, ka, kn, kd = keep_item(rel, lb, nb); it.update(cls=kc, action=ka, note=kn, data=kd)
                elif lb is None: it.update(cls='공통 파일 — 로컬 부재', action='write')
                elif norm(lb) == norm(nb): it.update(cls='동일', action='none')
                elif st != '-': it.update(cls='공통 변경분 — 공통 원문 적용(로컬 보호 안 함)', action='write')
                else: it.update(cls='로컬만 다름 — 공통 원문으로 복원(로컬 보호 안 함)', action='write')
                plan.append(it)
            for st, rel in changes:
                if st == 'D' and rel not in tree:
                    lb = rfile(os.path.join(awork, rel))
                    if lb is not None and not fe_area and (keep_match(rel, akeep) or norm(lb) != norm(git.blob_at(abase, aprefix + rel) if abase else None)):
                        plan.append({**tag(rel), 'st': st, 'local': lb, 'common': None, 'note': '', 'data': None, 'cls': 'BE 삭제 차단 — 내 편집본·환경 파일(로컬 유지)', 'action': 'keep'}); continue
                    plan.append({**tag(rel), 'st': st, 'local': lb, 'common': None, 'note': '', 'data': None, 'cls': '공통 삭제 — 로컬 삭제(로컬 보호 안 함)' if lb is not None else '삭제 — 이미 없음', 'action': 'delete' if lb is not None else 'none'})
            known = set(tree) | {r for s, r in changes if s == 'D'}
            for sc in ascope:
                for dp, dns, fns in os.walk(os.path.join(awork, sc)):
                    dns[:] = [d for d in dns if d not in ('node_modules', '.turbo', 'dist', '.next', '_sync_test')]
                    for fn in fns:
                        rel = os.path.relpath(os.path.join(dp, fn), awork).replace(os.sep, '/')
                        if rel not in known: plan.append({**tag(rel), 'st': '-', 'local': None, 'common': None, 'note': '', 'data': None, 'cls': '로컬 전용(공통에 없음) — 유지', 'action': 'keep'})
        for st, rel in ([] if a.overwrite_local else changes):
            lb = rfile(os.path.join(awork, rel))
            bb = git.blob_at(abase, aprefix + rel) if abase else None; nb = git.blob_at(tip, aprefix + rel)
            ln, bn, nn = norm(lb), norm(bb), norm(nb)
            it = {**tag(rel), 'st': st, 'local': lb, 'common': nb}
            def put(cls, action, note='', data=None): it.update(cls=cls, action=action, note=note, data=data); plan.append(it)
            if lb is not None and keep_match(rel, akeep): put(*keep_item(rel, lb, nb)); continue
            if st == 'D':
                if lb is None: put('삭제 — 이미 없음', 'none'); continue
                mh = hist.matches_history(rel, ln) or (('포맷 차이만', '') if bb is not None and code_file(rel) and fmt_norm(lb) == fmt_norm(bb) else None)
                if ln == bn or mh: put('삭제(D) — 로컬 = 공통 이력본', 'delete', mh[0] if mh else '기준선'); continue
                put('로컬 유지 — 공통 삭제·내 편집(결정 대기)', 'keep', 'pending'); continue
            if lb is None:
                if st == 'A': put('신규(A) — 로컬 부재', 'write'); continue
                put('로컬 부재 — 공통 수정 파일(결정 대기)', 'keep', 'pending'); continue
            if ln == nn: put('동일', 'none'); continue
            if is_binary(lb) or is_binary(nb):
                if ln == bn or hist.matches_history(rel, ln): put('바이너리 — 공통 채택', 'write')
                else: put('바이너리 — 로컬 유지(결정 대기)', 'keep', 'pending')
                continue
            if fe_area and rel == DTS:
                merged, info = dts_merge(git, lb, bb, nb)
                if merged is None: put('d.ts — 파싱 실패 → 로컬 유지(결정 대기)', 'keep', 'pending'); continue
                rows, checks, pend, dup = info
                bad = checks['declare global'] != 1 or dup or checks['로컬 키 유실'] or checks['공통 키 유실']
                put('d.ts 구조 병합' + (' — ⚠ 검사 실패 → 로컬 유지(결정 대기)' if bad else ''), 'keep' if bad else 'merge', 'pending' if (bad or pend) else '', {'merged': merged, 'rows': rows, 'checks': checks, 'pend': pend}); continue
            if fe_area and rel.lower().endswith('.json') and '/locales/' in '/' + rel.lower():
                try:
                    pb = bb
                    if st == 'A' or bb is None: pb = None
                    merged, stt, conf = json_merge(lb, pb, nb)
                    if norm(merged) == ln: put('locales 키 병합 — 변경 없음(로컬 유지)', 'none', json.dumps(stt, ensure_ascii=False)); continue
                    put('locales 키 병합', 'merge', ('pending ' if conf else '') + json.dumps(stt, ensure_ascii=False), {'merged': merged, 'conflicts': conf}); continue
                except Exception as e:
                    put(f'locales — JSON 파싱 실패({e}) → 로컬 유지(결정 대기)', 'keep', 'pending'); continue
            mh = hist.matches_history(rel, ln) or (('기준선', '') if ln == bn else None)
            if mh: put('수정(M) — 로컬 = 공통 이력본(무편집)' if st == 'M' else '신규(A) — 로컬 = 공통 이력본', 'write', f'{mh[0]} {mh[1]}'.strip()); continue
            if code_file(rel) and fmt_norm(lb) == fmt_norm(nb): put('포맷 차이만 — 공통 채택', 'write', '공백·따옴표·세미콜론'); continue
            mf = hist.matches_history_fmt(rel, ln)
            if mf: put('포맷 차이만(이력본) — 공통 채택', 'write', f'{mf[0]} {mf[1]}'); continue
            # 내 편집본
            if st == 'A': put('로컬 유지 — 공통 신규·로컬 기존 파일 상이(결정 대기)', 'keep', 'pending'); continue
            bkey, bsel = hist.pick_base(rel, ln, bb)
            if bsel is None: put('로컬 유지 — base 후보 없음(결정 대기)', 'keep', 'pending'); continue
            if norm(bsel) == nn: put('로컬 유지 — 공통 무변경·내 편집', 'keep', f'base {bkey}'); continue
            merged, nconf = merge3(git, lb, bsel, nb)
            if nconf:
                put(f'3-way 충돌 {nconf} → 로컬 유지(결정 대기)', 'keep', f'pending base {bkey}', {'merged': merged, 'base': eoln(bsel)}); continue
            dups = dup_increase(merged, lb, nb, rel)
            if dups: put('3-way 충돌 0 이나 선언 중복 → 로컬 유지(결정 대기)', 'keep', f'pending base {bkey} 중복 {",".join(dups[:5])}', {'merged': merged, 'base': eoln(bsel)}); continue
            if norm(merged) == ln: put('로컬 유지 — 3-way 결과 = 로컬(공통 변경분 이미 포함)', 'none', f'base {bkey}'); continue
            put('3-way 병합 — 충돌 0', 'merge', f'base {bkey}', {'merged': merged})
        return len(changes)
    for ar in areas: ar["changed"] = classify(ar)
    def be_login_check(ar):
        """로컬 ID 로그인 유지 점검 — '적용한 뒤' 내용 기준(미리보기에서는 적용될 내용). 로컬은 SSO 에 접속하지 않고 /user/login(ID) 으로 쓴다"""
        def after(rel):
            it = next((x for x in plan if x['area'] == 'be' and x['rel'] == rel), None)
            if it is None or it['action'] in ('keep', 'none'): return rfile(os.path.join(ar['work'], rel))
            if it['action'] == 'delete': return None
            return it['data']['merged'] if it['action'] == 'merge' else it['common']
        jf, sc = (after(p) for p in BE_LOGIN_FILES)
        res = [(jf is not None and sc is not None and b'/user/login' in sc and b'JsonLoginFilter' in sc, 'ID 로그인 경로(/user/login · JsonLoginFilter) 유지')]
        dis = [p for p in CFG_SUPPLEMENT if re.search(rb'^[ \t]*id-login-disabled[ \t]*:[ \t]*["\']?true', after(p) or b'', re.M | re.I)]
        res.append((not dis, '로컬 설정에 ID 로그인 차단(id-login-disabled: true) 없음' + (f' — 발견: {", ".join(dis)}' if dis else '')))
        return res
    be_login = {ar['key']: be_login_check(ar) for ar in areas if ar['key'] == 'be'}
    for ok_, msg in be_login.get('be', []): print(f'  [BE 로컬 로그인 점검] {"OK" if ok_ else "⛔ 실패"} — {msg}')
    # 집계
    counts = defaultdict(int)
    for it in plan: counts[it['cls']] += 1
    act = defaultdict(int)
    for it in plan: act[it['action']] += 1
    pend = [it for it in plan if 'pending' in (it.get('note') or '')]
    print('\n분류 결과')
    for k, v in sorted(counts.items(), key=lambda kv: -kv[1]): print(f'  {v:5d}  {k}')
    print(f'  → 적용: 공통 채택/신규 {act["write"]} · 병합 {act["merge"]} · 삭제 {act["delete"]} · 로컬 유지 {act["keep"]} · 변경 없음 {act["none"]} · 결정 대기 {len(pend)}')
    nchanged = sum(ar['changed'] for ar in areas)
    # 영역별 집계(FE/BE) — 메뉴 확인창·보고서가 FE 와 BE 를 나눠 보여 준다
    area_sum = {}
    for ar in areas:
        its = [it for it in plan if it['area'] == ar['key']]; ac = defaultdict(int)
        for it in its: ac[it['action']] += 1
        area_sum[ar['key']] = {'base': ar['base'], 'changed': ar['changed'], 'actions': dict(ac), 'pending': sum(1 for it in its if 'pending' in (it.get('note') or '')),
                               'local_only': sum(1 for it in its if it['cls'] == '로컬 전용(공통에 없음) — 유지'), 'env_keep': sum(1 for it in its if it['cls'] == KEEP_CLS)}
        if a.overwrite_local: area_sum[ar['key']]['changed'] = ac['write'] + ac['delete']
        print(f'  [{ar["label"]}] 공통 채택/신규 {ac["write"]} · 병합 {ac["merge"]} · 삭제 {ac["delete"]} · 로컬 유지 {ac["keep"]} · 결정 대기 {area_sum[ar["key"]]["pending"]}')
    summary.update(areas_sel=a.areas, be_login=[{'ok': ok_, 'msg': msg} for ok_, msg in be_login.get('be', [])])
    summary.update(tip=tip, tip_info=tip_info, base=base_show, ancestor=anc, commits=ncommits, changed=nchanged, counts=dict(counts), actions=dict(act), pending=len(pend), areas=area_sum)
    if a.overwrite_local:  # 메뉴가 '새 변경 없음' 을 판단하는 값 = 실제로 바뀌는 파일 수
        summary.update(changed=act['write'] + act['delete'], overwrite_local=True, local_only=counts.get('로컬 전용(공통에 없음) — 유지', 0))

    def report(path, applied, backup_dir=None, verify=None):
        L = [f'# 공통소스 다운로드 & 병합 {"회차 보고" if applied else "미리보기(dry-run)"} — {now:%Y-%m-%d %H:%M}', '',
             f'- 원천: remote `{a.remote}` ({git.out("config", "--get", f"remote.{a.remote}.url", check=False).strip()}) · push URL `no_push` 확인 — 푸시 없음',
             f'- 기준선 `{base[:9]}` → **{"신규 기준선" if applied else "최신"} `{tip[:9]}`** ({tip_info})' + ('' if anc else ' · ⚠ 기준선이 조상 아님(force-push 재작성)'),
             *([f'- 공통 신규 커밋 {ncommits}건 · FE 대상(nscm-fe: apps·features·packages·public·configs) 변경 {areas[0]["changed"]}건 (이름변경은 삭제+신규로 풀어 집계)'] if want_fe else ['- **BE 전용 실행(Source Download & Merge(BE))** — FE(nscm-fe)는 다루지 않는다']),
             *([f'- BE 대상(nscm-be: {"·".join(BE_SCOPE)}) — 기준선 `{ar["base"][:9] if ar["base"] else "없음(첫 회차 — 공통 최신 트리와 직접 대조)"}` · 변경 {ar["changed"]}건 · 환경 파일 항상 로컬 유지 = {", ".join(f"`{k}`" for k in BE_KEEP)} · 빌드 설정(build.gradle 등)·lib·저장소·빌드 산출물은 대상 밖(쓰기 차단)'
                for ar in areas if ar['key'] == 'be'] or [f'- BE(nscm-be) 미포함 — {be_skip}']),
             *[f'- BE 로컬 ID 로그인 점검: {"OK" if ok_ else "⛔ 실패"} — {msg}' for ok_, msg in be_login.get('be', [])],
             ('- ⚠ **DB MODE — 로컬 소스 보호 안 함**: 공통 최신 트리 기준으로 다른 파일은 내 편집본도 공통 원문으로 덮어쓴다 · 공통이 지운 파일은 삭제 · 공통에 없는 로컬 전용 파일은 유지' if a.overwrite_local else
              '- 판정 = 내용 대조(개행·BOM 정규화) · 로컬이 공통 이력본과 일치하면 공통 채택, 내 편집본이면 유지/3-way(base = 로컬이 실제 출발한 공통 판본)'), '',
             '## 분류·처리 결과', '', '| 구분 | 건수 | 처리 |', '|---|---:|---|']
        name = {'write': '공통 원문 적용', 'merge': '병합본 적용', 'delete': '삭제', 'keep': '로컬 유지', 'none': '변경 없음'}
        groups = OrderedDict()
        for it in plan: groups.setdefault(it['cls'], []).append(it)
        for k, its in sorted(groups.items(), key=lambda kv: -len(kv[1])): L.append(f'| {k} | {len(its)} | {name[its[0]["action"]]} |')
        fold = defaultdict(int)
        for it in plan:
            if it['action'] in ('write', 'merge'):
                ps = it['rel'].split('/'); fold['nscm-be' if it['area'] == 'be' else ps[1] if ps[0] in ('features', 'packages') and len(ps) > 2 else ps[0]] += 1
        if fold: L += ['', '적용 폴더별: ' + ' / '.join(f'{k} {v}' for k, v in sorted(fold.items(), key=lambda kv: -kv[1]))]
        pend_its = [it for it in plan if 'pending' in (it.get('note') or '')]
        L += ['', f'## ⚠️ 결정 대기 {len(pend_its)}건 (로컬 유지 상태 — 자동 적용 안 함)', '']
        if pend_its:
            L += ['| 파일 | 사유 | 비고 | 자료 |', '|---|---|---|---|']
            for it in pend_its:
                ref = f'`conflicts/{it["show"]}.*`' if backup_dir and it.get('data') and it['data'].get('merged') is not None and it['action'] == 'keep' else ''
                L.append(f'| `{it["show"]}` | {it["cls"]} | {(it.get("note") or "").replace("pending", "").strip()} | {ref} |')
        else: L.append('- 없음')
        for it in plan:
            if it['area'] == 'fe' and it['rel'] == DTS and it.get('data'):
                d = it['data']; L += ['', '## `procedures.d.ts` 병합 (RawProcedureMap 메뉴 키 블록 단위)', '', '| 처리 | 메뉴 키 |', '|---|---|']
                for k, v in d['rows'].items(): L.append(f'| {k} ({len(v)}) | {"—" if k == "동일" else " · ".join(f"`{x}`" for x in v)} |')
                L += ['', '검사: ' + ' / '.join(f'{k} {v}' for k, v in d['checks'].items())]
        merges = [it for it in plan if it['action'] == 'merge' and not (it['area'] == 'fe' and it['rel'] == DTS)]
        if merges:
            L += ['', '## 병합 적용', '', '| 파일 | 구분 | 비고 |', '|---|---|---|']
            for it in merges: L.append(f'| `{it["show"]}` | {it["cls"]} | {(it.get("note") or "").replace("pending", "").strip()} |')
        dels = [it for it in plan if it['action'] == 'delete']
        if dels:
            L += ['', f'## 삭제 {len(dels)}건', ''] + [f'- `{it["show"]}`' for it in dels]
            refs = import_refs(work, [it['rel'] for it in dels if it['area'] == 'fe']) if applied else {}
            if applied: L += ['', '삭제 파일을 가리키는 import 후보: ' + ('0건' if not refs else ''), *[f'- `{k}` ← {", ".join(v[:5])}' for k, v in refs.items()]]
        be_its = [it for it in plan if it['area'] == 'be' and (it['action'] != 'none' or it.get('note')) and it['cls'] != '로컬 전용(공통에 없음) — 유지']
        if be_its:
            L += ['', f'## BE(nscm-be) 파일별 처리 {len(be_its)}건', '', '| 파일 | 구분 | 처리 | 비고 |', '|---|---|---|---|']
            for it in be_its: L.append(f'| `{it["show"]}` | {it["cls"]} | {name[it["action"]]} | {(it.get("note") or "").replace("pending", "").strip()} |')
        if applied:
            L += ['', '## 원복 자료', f'- `local_before/` — 덮어쓰거나 삭제한 로컬 원본', '- `worktree_tracked.patch` — 적용 직전 nscm-fe 추적파일 전체 diff',
                  '- `git_status_before.txt` — 적용 직전 워킹트리 상태',
                  '- `local_before/nscm-be/` · `be_worktree_tracked.patch` · `be_git_status_before.txt` — BE(nscm-be) 분', '- `conflicts/` — 결정 대기 파일의 base · common · merged(충돌 마커 포함) 사본',
                  '', '## 검증', *[f'- {v}' for v in (verify or [])],
                  '- 정적검증(type-check/lint) **미수행** — 사용자 지시(요청 시만). 공통 신규 소스 ↔ 내 화면 소스 타입 불일치는 type-check 로 확인 필요',
                  *(['- BE 컴파일(gradlew build) **미수행** — BE 소스가 바뀌었으면 BE 재기동 전 빌드 확인 필요. 실행 중인 BE 는 재기동해야 반영된다'] if any(it['area'] == 'be' for it in plan if it['action'] in ('write', 'merge', 'delete')) else [])]
        os.makedirs(os.path.dirname(path), exist_ok=True); open(path, 'w', encoding='utf-8').write('\n'.join(L) + '\n')
        return path

    if a.dry_run:
        p = report(os.path.join(ROOT, '.vibe', 'common_sync', f'PLAN_{stamp}.md'), False)
        print(f'\n미리보기 → {p}'); finish(0, ok=True, report=p)

    # ── 적용 ──
    test = bool(a.work)  # 사본 시험 — 백업은 사본 안, 기준선(state.json) 미갱신
    bdir = os.path.join(work, '_sync_test', f'NSCMFE_PRE_COMMON_{now:%Y%m%d}') if test else os.path.join(ROOT, '_artifacts', '_backup', f'{"NSCMFE" if want_fe else "NSCMBE"}_PRE_COMMON_{now:%Y%m%d}')
    if os.path.exists(bdir): bdir += f'_{now:%H%M%S}'
    os.makedirs(bdir, exist_ok=False)
    open(os.path.join(bdir, 'git_status_before.txt'), 'wb').write(git.run('status', '--porcelain').stdout)
    open(os.path.join(bdir, 'worktree_tracked.patch'), 'wb').write(git.run('diff').stdout)
    autocrlf = git.out('config', '--get', 'core.autocrlf', check=False).strip().lower() == 'true'
    acrlf = {'fe': autocrlf}
    def be_outside(root):
        """BE 루트의 대상 밖 파일(1단계 + gradle/ · lib/) → {경로: (크기, 수정시각)}"""
        o = {}
        for top in os.listdir(root):
            p = os.path.join(root, top)
            if os.path.isfile(p): st_ = os.stat(p); o[top] = (st_.st_size, st_.st_mtime_ns)
            elif top in ('gradle', 'lib', 'scripts', 'db'):
                for dp, dn, fn in os.walk(p):
                    for f in fn:
                        fp = os.path.join(dp, f); st_ = os.stat(fp); o[os.path.relpath(fp, root).replace(os.sep, '/')] = (st_.st_size, st_.st_mtime_ns)
        return o
    for ar in areas:
        if ar['key'] == 'be': ar['outside'] = be_outside(ar['work'])
    for ar in areas:
        if ar['key'] != 'be': continue
        # BE 는 별도 저장소(nscm-be/.git) — 적용 직전 상태·diff 를 따로 남긴다. 사본(저장소 아님)이면 건너뛴다
        acrlf['be'] = False
        if os.path.isdir(os.path.join(ar['work'], '.git')):
            bg = ReadOnlyGit(ar['work'])
            open(os.path.join(bdir, 'be_git_status_before.txt'), 'wb').write(bg.run('status', '--porcelain', check=False).stdout)
            open(os.path.join(bdir, 'be_worktree_tracked.patch'), 'wb').write(bg.run('diff', check=False).stdout)
            acrlf['be'] = bg.out('config', '--get', 'core.autocrlf', check=False).strip().lower() == 'true'
    # ⓪ BE 작업환경 가드 — 하나라도 걸리면 아무 파일도 바꾸지 않고 중단
    guard = []
    for ar in areas:
        if ar['key'] != 'be': continue
        root = os.path.realpath(ar['work']); allow = [os.path.realpath(os.path.join(root, sc)) + os.sep for sc in ar['scope']]
        for it in plan:
            if it['area'] != 'be' or it['action'] not in ('write', 'merge', 'delete'): continue
            rp_ = os.path.realpath(os.path.join(root, it['rel'].replace('/', os.sep))); parts = set(it['rel'].split('/'))
            if not any(rp_.startswith(al) for al in allow): guard.append(f'{it["show"]} — 대상 경로(src) 밖')
            elif parts & BE_DENY_PARTS: guard.append(f'{it["show"]} — 보호 폴더({", ".join(sorted(parts & BE_DENY_PARTS))})')
            elif it['local'] is not None and keep_match(it['rel'], ar['keep']) and it['cls'] != SUPP_CLS: guard.append(f'{it["show"]} — 환경 파일 변경 시도')
        guard += [f'로컬 ID 로그인 점검 실패 — {msg}' for ok_, msg in be_login_check(ar) if not ok_]
    if guard:
        print(f'⛔ BE 작업환경 가드 {len(guard)}건 — 로컬 파일 변경 없음:'); [print('   ' + g) for g in guard[:20]]; finish(4, error='be-guard', guard=guard[:50], backup=bdir)
    # ① 백업 전부 먼저 — 하나라도 실패하면 로컬 파일은 하나도 바꾸지 않고 중단(10-22 시험: 260자 초과 경로에서 중간 실패 → 일부만 적용될 뻔)
    try:
        for it in plan:
            rel = it['show']; lb = it['local']
            if it['action'] in ('write', 'merge', 'delete') and lb is not None: wfile(os.path.join(bdir, 'local_before', rel), lb)
            if it['action'] == 'keep' and it.get('data') and it['data'].get('merged') is not None:
                cb = os.path.join(bdir, 'conflicts', rel)
                wfile(cb + '.merged', it['data']['merged'])
                if it['data'].get('base') is not None: wfile(cb + '.base', it['data']['base'])
                if it['common'] is not None: wfile(cb + '.common', it['common'])
    except OSError as e:
        print(f'⛔ 백업 실패 — 로컬 파일 변경 없음: {e}'); finish(4, error='backup', backup=bdir)
    # ② 적용 — 실패하면 어디까지 했는지와 원복 자료를 알리고 기준선은 갱신하지 않는다
    written = []; done = 0
    try:
        for it in plan:
            rel = it['rel']; lp = os.path.join(it['work'], rel); lb = it['local']
            if it['action'] == 'write':
                # 공통 원문 — 내용은 그대로, 개행만 로컬 파일 방식(신규는 autocrlf=true 면 CRLF = 체크아웃과 같은 결과)
                nb = it['common']
                if not is_binary(nb):
                    eol = eol_of(lb) if lb is not None else ('\r\n' if acrlf.get(it['area']) else eol_of(nb))
                    nb = conv(eoln(nb), eol, has_bom(nb))
                wfile(lp, nb); written.append(it)
            elif it['action'] == 'merge':
                mb = it['data']['merged']
                if lb is not None and lb.endswith(b'\n') and not mb.endswith(b'\n'): mb += b'\n'  # json.dumps 등 끝 개행 보존
                wfile(lp, conv(mb, eol_of(lb), has_bom(lb))); written.append(it)
            elif it['action'] == 'delete':
                os.remove(lpath(lp))
            else: continue
            done += 1
    except OSError as e:
        print(f'✖ 적용 중 실패({done}건 적용 후): {e}\n   원복 자료: {bdir}\\local_before (적용 전 원본) — 기준선 미갱신'); finish(4, error='apply', done=done, backup=bdir)
    # 적용 후 검증
    verify = []; bad = 0
    mism = [it['show'] for it in written if it['action'] == 'write' and norm(rfile(os.path.join(it['work'], it['rel']))) != norm(it['common'])]
    verify.append(f'공통 원문 적용 {sum(1 for i in written if i["action"] == "write")}건 — 개행 정규화 후 공통 원문과 불일치 {len(mism)}건' + (f': {mism[:5]}' if mism else '')); bad += len(mism)
    marks = [it['show'] for it in written if not is_binary(it['common']) and re.search(rb'^(<{7}|>{7}) ', rfile(os.path.join(it['work'], it['rel'])), re.M)]
    verify.append(f'적용 파일 충돌 마커 잔존 {len(marks)}건' + (f': {marks[:5]}' if marks else '')); bad += len(marks)
    left = [it['show'] for it in plan if it['action'] == 'delete' and os.path.exists(lpath(os.path.join(it['work'], it['rel'])))]
    verify.append(f'삭제 {sum(1 for i in plan if i["action"] == "delete")}건 — 잔존 {len(left)}'); bad += len(left)
    dts = os.path.join(work, DTS)
    if want_fe and os.path.exists(dts):
        dg = rfile(dts).count(b'declare global'); verify.append(f'procedures.d.ts `declare global` {dg}건(기대 1)'); bad += dg != 1
    for it in [x for x in plan if x['cls'] == SUPP_CLS]:  # 설정 키 보충 — 기존 줄이 하나도 빠지지 않았는지
        b0 = text(eoln(it['local'])).split('\n'); b1 = text(eoln(rfile(os.path.join(it['work'], it['rel'])))).split('\n')
        gone = sum(1 for d in difflib.ndiff(b0, b1) if d.startswith('- ')); plus = sum(1 for d in difflib.ndiff(b0, b1) if d.startswith('+ '))
        verify.append(f'설정 키 보충 `{it["show"]}` — 추가 {plus}줄(키 {len(it["data"]["added"])}개 + 안내 주석) · 기존 줄 삭제·변경 {gone}건'); bad += gone
    for ok_, msg in be_login.get('be', []):
        verify.append(f'BE 로컬 ID 로그인 점검 — {"OK" if ok_ else "실패"}: {msg}'); bad += not ok_
    kept = [it for it in plan if it['cls'] == KEEP_CLS]  # 환경 파일이 적용 전과 바이트까지 같은지
    if kept:
        diffk = [it['show'] for it in kept if rfile(os.path.join(it['work'], it['rel'])) != it['local']]
        verify.append(f'BE 환경 파일 항상 로컬 유지 {len(kept)}건 — 적용 전과 다른 파일 {len(diffk)}건' + (f': {diffk[:5]}' if diffk else '')); bad += len(diffk)
    for ar in areas:  # BE 대상 밖(빌드 설정 등)은 손대지 않았는지 — 적용 전후 수정 시각 대조
        if ar['key'] == 'be' and ar.get('outside') is not None:
            now_o = be_outside(ar['work']); ch = sorted(k for k in set(now_o) | set(ar['outside']) if now_o.get(k) != ar['outside'].get(k))
            verify.append(f'BE 대상 밖(build.gradle·settings.gradle·gradle/·lib/ 등) 변경 {len(ch)}건' + (f': {ch[:5]}' if ch else '')); bad += len(ch)
    rp = report(os.path.join(bdir, 'README.md'), True, bdir, verify)
    if bad:
        print(f'\n✖ 적용 후 검증 실패 {bad}건 — 기준선 갱신 안 함 · 보고 {rp} · 원복 자료 {bdir}'); finish(4, report=rp, backup=bdir, verify=verify)
    if test: print(f'\n✅ 시험 적용 완료(기준선 미갱신) — 보고 {rp}'); finish(0, ok=True, report=rp, backup=bdir, verify=verify)
    hist_list = state.get('history', [])
    be_ar = next((ar for ar in areas if ar['key'] == 'be'), None)
    ent = {'baseline': tip, 'from': base, 'applied': now.isoformat(timespec='seconds'), 'report': os.path.relpath(rp, ROOT)}
    if not want_fe: ent = {'beOnly': True, 'applied': now.isoformat(timespec='seconds'), 'report': os.path.relpath(rp, ROOT)}
    if be_ar: ent['be'] = {'from': be_ar['base'], 'baseline': tip}
    hist_list.append(ent)
    new_state = {'baseline': tip, 'baselineInfo': tip_info, 'applied': now.isoformat(timespec='seconds'), 'report': os.path.relpath(rp, ROOT)}
    if not want_fe:  # BE 전용 실행 — FE 기준선·보고는 그대로 둔다
        new_state = {k: state[k] for k in ('baseline', 'baselineInfo', 'applied', 'report') if k in state}
        new_state.update(baselineBeApplied=now.isoformat(timespec='seconds'), reportBe=os.path.relpath(rp, ROOT))
    else:
        for k in ('baselineBeApplied', 'reportBe'):
            if k in state: new_state[k] = state[k]
    # BE 기준선 — BE 를 다룬 회차에만 갱신(건너뛴 회차는 이전 값 유지)
    if be_ar: new_state['baselineBe'] = tip
    elif state.get('baselineBe'): new_state['baselineBe'] = state['baselineBe']
    new_state['history'] = hist_list
    json.dump(new_state, open(STATE, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('\n✅ 적용 완료' + (f' — 기준선 {base[:9]} → {tip[:9]}' if want_fe else ' — BE 전용') + (f' · BE 기준선 {be_ar["base"][:9] if be_ar["base"] else "없음"} → {tip[:9]}' if be_ar else '') + f' · 보고 {rp}')
    finish(0, ok=True, report=rp, backup=bdir, verify=verify)

def restore_be(a):
    """도구가 덮어쓴 BE 파일을 그 회차 백업(local_before/nscm-be)에서 되돌린다 — src 아래만 · 현재 파일은 먼저 백업 · 복원 후 바이트 대조"""
    root = os.path.realpath(a.be_work or a.be); src = os.path.join(a.restore_be_from, 'local_before', 'nscm-be')
    rels = [r.strip().replace('\\', '/') for r in (a.restore_be_paths or '').split(',') if r.strip()]
    if not rels or not os.path.isdir(src): print(f'⛔ 되돌릴 경로(--restore-be-paths) 또는 백업 폴더({src}) 없음'); return 2
    allow = [os.path.realpath(os.path.join(root, sc)) + os.sep for sc in BE_SCOPE]; bad = []
    for rel in rels:
        rp_ = os.path.realpath(os.path.join(root, rel.replace('/', os.sep)))
        if not any(rp_.startswith(al) for al in allow) or set(rel.split('/')) & BE_DENY_PARTS: bad.append(f'{rel} — 대상 경로(src) 밖·보호 폴더')
        elif rfile(os.path.join(src, rel)) is None: bad.append(f'{rel} — 백업에 없음')
    if bad: print('⛔ 되돌리기 중단 — 파일 변경 없음:'); [print('   ' + b) for b in bad]; return 4
    now = datetime.datetime.now(); bdir = os.path.join(ROOT, '_artifacts', '_backup', f'NSCMBE_RESTORE_{now:%Y%m%d_%H%M%S}')
    for rel in rels:
        cur = rfile(os.path.join(root, rel))
        if cur is not None: wfile(os.path.join(bdir, 'current_before', 'nscm-be', rel), cur)
    ng = 0
    for rel in rels:
        b = rfile(os.path.join(src, rel)); wfile(os.path.join(root, rel), b)
        same = rfile(os.path.join(root, rel)) == b; ng += not same
        print(f'{"복원" if same else "✖ 불일치"} nscm-be/{rel}')
    open(os.path.join(bdir, 'README.md'), 'w', encoding='utf-8').write(f'# BE 되돌리기 — {now:%Y-%m-%d %H:%M}\n\n- 원본: `{a.restore_be_from}` local_before/nscm-be\n- 되돌린 파일 {len(rels)}건 (되돌리기 직전 내용 = `current_before/`)\n' + ''.join(f'  - `nscm-be/{r}`\n' for r in rels))
    print(f'되돌린 파일 {len(rels) - ng}/{len(rels)} · 직전 내용 백업 {bdir}')
    return 4 if ng else 0

# 업로드 내용의 도구 흔적 — 공통 저장소에는 이 도구들의 소스는 물론 언급(경로·이름)도 남기지 않는다(사용자 지시 2026-10-22)
TRACE = re.compile(r'Vibe_?Manager|VibeManager|tools[/\\](?:Harness|VibeManager|CommonSync|E2E|AsisFacts|TobeFacts|Recon|DbConn|Docs)\b|\.vibe[/\\]|\bHarness\b'
                   r'|TobeGen|Fact ?Pack|Doc[/\\](?:asisfacts|tobefacts|gen|gap|e2e|recon|golden)\b', re.I)  # 생성기·산출물 경로도 도구 흔적
TRACE_FRAG = re.compile(r'\s*[·,;|]?\s*[^\s·,;|:`]*\s*:\s*`?tools[/\\][^\s`·,;|]*`?')
COMMENT_LINE = re.compile(r'^\s*(?://|/\*|\*|#|>|<!--|\{/\*)')
# Markdown(대조표 등)은 줄을 지우면 기록이 사라지므로 흔적 표현만 중립어로 바꾼다
MD_NEUTRAL = [(re.compile(r'`?tools[/\\][^\s`|)·,]*`?'), ''), (re.compile(r'`?Doc[/\\]gen[/\\]?[^\s`|)·,]*`?', re.I), '등록 SQL'),
              (re.compile(r'`?Doc[/\\](?:asisfacts|tobefacts|gap|e2e|recon|golden)[/\\]?[^\s`|)·,]*`?', re.I), 'AS-IS 분석자료'),
              (re.compile(r'Fact ?Pack', re.I), 'AS-IS 분석'), (re.compile(r'TobeGen\s*', re.I), ''),
              (re.compile(r'Vibe_?Manager|VibeManager|\bHarness\b', re.I), ''), (re.compile(r'\.vibe[/\\][^\s`|)·,]*'), '')]
def scrub(b, md=False):
    """→ (정리된 bytes, 정리 줄 수, 남은 코드 흔적 줄[]) — 주석 속 '생성기: tools/…' 조각 제거, 그래도 흔적이 있는 주석 줄은 삭제, 코드 줄의 흔적은 차단.
    md=True: 흔적 표현만 중립어로 바꾸고 줄은 유지"""
    if b is None or is_binary(b) or not TRACE.search(text(b)): return b, 0, []
    out, n, bad = [], 0, []
    for line in text(b).split('\n'):
        if not TRACE.search(line): out.append(line); continue
        if md:
            n += 1; t = TRACE_FRAG.sub('', line)
            for rx, rep in MD_NEUTRAL: t = rx.sub(rep, t)
            t = re.sub(r'\(\s*\)|\s+[·—-]\s*(?=[)|]|$)', '', t).rstrip()
            if TRACE.search(t): bad.append(line.strip()[:120]); out.append(line)
            elif t.strip(' >·—-'): out.append(t)
            continue
        n += 1; t = TRACE_FRAG.sub('', line)
        t = re.sub(r'^(\s*(?://|\*|>|#)\s*)[·,;|]\s*', r'\1', t)
        if not TRACE.search(t):
            if re.sub(r'^\s*(?://|/\*|\*/?|#|>|<!--|-->)\s*', '', t).strip(' ·—-'): out.append(t)  # 남은 설명이 있으면 유지
            continue
        if COMMENT_LINE.match(line): continue
        bad.append(line.strip()[:120]); out.append(line)
    return '\n'.join(out).encode('utf-8', 'surrogateescape'), n, bad

def upload_prepare(a):
    """Source Upload(UI) — 파일마다 '내 작업분'만 올리도록 올릴 내용을 만든다(사용자 지시 2026-10-22).
    공통 최신(tip) 위에 얹을 내용 = 다운로드와 같은 판정의 역방향:
      whole-new    공통에 없는 파일 → 전체(내 신규)
      whole-mine   공통이 내 출발 판본 이후 안 바뀜 → 로컬 전체(= 공통 + 내 수정)
      merged-mine  공통도 바뀜 → 3-way(공통 tip 기준 + 내 수정분만) · d.ts = 메뉴 키 블록 단위 · locales = 키 단위
      skip-same    공통 tip 과 동일 → 올릴 것 없음
      skip-notmine 로컬 = 공통 이력본(내 편집 없음) → 제외(올리면 공통을 옛 판본으로 되돌림)
      skip-missing 로컬에 파일 없음 → 제외(업로드는 삭제를 반영하지 않음)
      conflict     내 수정과 공통 수정이 같은 곳 / 선언 중복 / 바이너리 상이 → 제외(사람 확인 — out/conflicts/)"""
    git = Git(a.fe); res = []
    tip_ref = a.tip or f'{a.remote}/{a.branch}'; tip = git.out('rev-parse', tip_ref).strip()
    prefix = 'nscm-fe/' if git.out('ls-tree', '--name-only', tip, 'nscm-fe/').strip() else ''
    rels = [l.strip().replace('\\', '/') for l in open(a.files_from, encoding='utf-8-sig') if l.strip()]
    keys = {k.strip().upper() for k in (a.keys or '').split(',') if k.strip()} or None
    hist = History(git, prefix, tip, tip)  # 출발 판본 후보 = tip 까지 전 이력
    os.makedirs(a.out, exist_ok=True)
    def save(rel, b, sub='files'):
        p = os.path.join(a.out, sub, rel.replace('/', os.sep)); wfile(p, b); return lpath(p)
    for rel in rels:
        lb = rfile(os.path.join(a.work or a.fe, rel))
        tb = git.blob_at(tip, prefix + rel); ln, tn = norm(lb), norm(tb)
        r = {'rel': rel, 'path': prefix + rel}
        def put(mode, note='', b=None, sub='files'):
            if b is not None and mode in ('whole-new', 'whole-mine', 'merged-mine'):
                b, n, bad = scrub(b, md=rel.lower().endswith('.md'))
                if bad: mode, note, sub = 'conflict', f'코드에 도구 흔적 — 올리지 않음(직접 정리 필요): {bad[0]}', 'conflicts'
                elif n:
                    note += f' · 도구 흔적 {n}줄 정리'
                    if norm(b) == tn: mode, note, b = 'skip-same', '도구 흔적 정리 후 공통 최신과 동일', None
            r.update(mode=mode, note=note)
            if b is not None: r['out'] = save(rel, b, sub)
            res.append(r)
        if lb is None: put('skip-missing', '로컬에 파일 없음'); continue
        if tb is None: put('whole-new', '공통에 없는 파일', lb); continue
        if ln == tn: put('skip-same', '공통 최신과 동일'); continue
        mh = hist.matches_history(rel, ln) or hist.matches_history_fmt(rel, ln)
        if mh: put('skip-notmine', f'내 편집 없음 — {mh[0]} {mh[1]} (올리면 공통을 옛 판본으로 되돌림)'); continue
        if is_binary(lb) or is_binary(tb): put('conflict', '바이너리 — 공통도 바뀜'); continue
        okey, origin = hist.pick_base(rel, ln, None)
        if origin is None: put('conflict', '출발 판본 없음'); continue
        if norm(origin) == tn and rel != DTS: put('whole-mine', f'공통이 내 출발 판본({okey}) 이후 그대로 → 로컬 전체', lb); continue
        if rel == DTS:  # 공통이 그대로여도 블록 단위 — 다른 화면의 내 블록이 같이 올라가지 않게(--keys)
            merged, info = dts_merge(git, tb, origin, lb, upload=True, keys=keys)  # L=공통 tip(충돌 시 유지) · N=로컬 → 공통 + 내 블록
            if merged is None: put('conflict', 'd.ts 파싱 실패'); continue
            rows, checks, pend, dup = info
            if dup or checks['declare global'] != 1 or checks['로컬 키 유실']:  # 역할상 '로컬 키 유실' = 공통 tip 키 유실
                put('conflict', f'd.ts 검사 실패 {checks}', merged, 'conflicts'); continue
            # 역방향 라벨 → 사람이 읽는 말: 공통 신규 추가 = 내 신규 블록 / 공통 채택 = 내 수정 블록(공통 무변경) / 블록 3-way = 양쪽 수정 병합
            say = {'공통 신규 추가': '내 신규 블록', '공통 채택 — 로컬 = 기준선': '내 수정 블록', '블록 내부 3-way — 충돌 0': '양쪽 수정 병합 블록'}
            mine = [f'{v}: {", ".join(rows[k][:8])}' for k, v in say.items() if rows.get(k)]
            if not mine: put('skip-same', 'd.ts — 올릴 내 블록 없음'); continue
            put('merged-mine', '메뉴 키 블록 단위 — ' + ' · '.join(mine) + (f' · 충돌 블록 제외(공통 유지): {", ".join(pend)}' if pend else ''), conv(merged, eol_of(tb)))
            continue
        if rel.lower().endswith('.json') and '/locales/' in '/' + rel.lower():
            try:
                merged, stt, conf = json_merge(tb, origin, lb, upload=True)  # L=공통 tip · N=로컬 → 공통 + 내 키
                if norm(merged) == tn: put('skip-same', '키 단위 — 올릴 내 키 없음'); continue
                if tb.endswith(b'\n') and not merged.endswith(b'\n'): merged += b'\n'
                put('merged-mine', f'키 단위 — {json.dumps(stt, ensure_ascii=False)}' + (f' · 충돌 키(공통 값 유지): {", ".join(conf[:10])}' if conf else ''), conv(merged, eol_of(tb)))
            except Exception as e: put('conflict', f'JSON 파싱 실패 {e}')
            continue
        merged, nconf = merge3(git, tb, origin, lb)  # mine=공통 tip · other=로컬 → 공통 + 내 수정분
        if nconf: put('conflict', f'3-way 충돌 {nconf} (출발 판본 {okey})', merged, 'conflicts'); continue
        dups = dup_increase(merged, tb, lb)
        if dups: put('conflict', f'선언 중복 {", ".join(dups[:5])}', merged, 'conflicts'); continue
        put('merged-mine', f'공통 최신 + 내 수정분(출발 판본 {okey})', conv(merged, eol_of(tb), has_bom(tb)))
    git.close()
    up = [r for r in res if r['mode'] in ('whole-new', 'whole-mine', 'merged-mine')]
    summ = {'ok': True, 'tip': tip, 'prefix': prefix, 'files': res, 'upload': len(up), 'counts': {m: sum(1 for r in res if r['mode'] == m) for m in sorted({r['mode'] for r in res})}}
    L = [f'# Source Upload(UI) 준비 — {datetime.datetime.now():%Y-%m-%d %H:%M}', '', f'- 공통 최신 `{tip[:9]}` 위에 얹을 내용 · 경로 접두 `{prefix}`', '',
         '| 파일 | 구분 | 내용 |', '|---|---|---|'] + [f'| `{r["rel"]}` | {r["mode"]} | {r["note"]} |' for r in res]
    open(os.path.join(a.out, 'UPLOAD_PREP.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    if a.summary: open(a.summary, 'w', encoding='utf-8').write(json.dumps(summ, ensure_ascii=False, indent=1))
    for r in res: print(f'{r["mode"]:13s} {r["rel"]} — {r["note"]}')
    print(f'\n올릴 파일 {len(up)} / 선택 {len(res)} → {os.path.join(a.out, "UPLOAD_PREP.md")}')
    return 0

def import_refs(fe, rels):
    """삭제 파일을 가리키는 import 후보(같은 파일명 stem 을 경로 끝으로 import) — node_modules 제외"""
    stems = {}
    for r in rels:
        b = os.path.basename(r); s = re.sub(r'\.(d\.ts|tsx?|jsx?|scss|css)$', '', b)
        if s in ('index',): s = os.path.basename(os.path.dirname(r))
        stems[r] = s
    hits = defaultdict(list); pats = {r: re.compile(r'''(?:from|import\()\s*['"][^'"]*/''' + re.escape(s) + r'''(?:\.\w+)?['"]''') for r, s in stems.items()}
    for top in SCOPE:
        for dp, dn, fn in os.walk(os.path.join(fe, top)):
            dn[:] = [d for d in dn if d not in ('node_modules', 'dist', '.turbo')]
            for f in fn:
                if not f.endswith(('.ts', '.tsx', '.js', '.jsx', '.scss')): continue
                fp = os.path.join(dp, f)
                try: t = open(fp, encoding='utf-8', errors='replace').read()
                except OSError: continue
                for r, pat in pats.items():
                    if pat.search(t): hits[r].append(os.path.relpath(fp, fe).replace(os.sep, '/'))
    return dict(hits)  # 후보 — 이름만 같은 타 화면 자체 파일일 수 있어 사람이 확인(10-14 README 와 동일)

if __name__ == '__main__':
    main()
