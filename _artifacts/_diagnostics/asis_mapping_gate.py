#!/usr/bin/env python3
"""
asis_mapping_gate.py — __asis-mapping__.md EID 1:1 대사표 스켈레톤 생성 + 자동 대조 (2026-08-07 신설)

배경: SYS0017 근본원인 감사(2026-08-06) — 분석 md 에 E01~E19 전 조문이 실존했는데도
      "총합 비교" 게이트가 개별 이벤트 누락을 통과시켰다(E01/E07/E08·E09/E13/E14·E15).
      asis-coverage-check.md §0.0(원천 브리지)·§0.1(EID 1:1, 2026-08-07 개정판) 의 실행 도구.

사용:
  # 스켈레톤 생성 (구현 시작 전 의무 — 기존 파일 있으면 신규 ID 만 append, 기입값 보존)
  python asis_mapping_gate.py --init <분석md경로...> <페이지폴더>
      · 분석 md 는 1개 이상. `*_주요이벤트_상세분석.md` 를 주면 동일 prefix 의
        `*_제약매트릭스_상세.md` 가 옆에 있을 때 자동 포함(안내 출력).
      · --out <파일경로> : 대사표를 페이지 폴더 대신 지정 경로에 생성 (검증/드라이런 용)
  # 완료 게이트 (잔여 0 = PASS)
  python asis_mapping_gate.py --check <페이지폴더>
  exit code: 0 = PASS / 1 = FAIL(잔여 존재·사유 누락) / 2 = 실행 오류

추출 규칙 (원천 = hook #105 산출 md — asis-coverage-check §0.0):
  E1) 헤더(`#..# E01. ...` / `E04-2.`) 의 EID — 헤더 제목이 요지.
  E2) 헤더 본문 어디든 나타나는 EID 토큰(예: `## 8. 삭제 (Delete 툴바 — E19, ...)`).
  E3) EID 섹션 내부 최상위 번호 목록(`1.`~`n.`) → 세부 항번 `E{n}-{k}` 행 분리
      (감사 소급표의 E14-4/E16-4/E02-3 인용과 동일 해상도. 헤더가 이미 -항번이면 미분해).
  E4) 표 행(`| E01 | ...`).
  C1) 제약 md 표 행 `| A1 | ...` — ID = [A-K]+숫자. 요지 = 표의 첫 내용 셀.

대사표 양식 (asis-coverage-check §0.1 5열 — 빈 칸 1개 = 게이트 실패):
  | ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외 시 필수) | 상태 |
  상태 허용값: 미구현(초기값) / 구현 / 제외 / 해당없음(조회 전용 화면의 CRUD 행 등 — 사유 필수)
  PASS 조건: 전 행이 [구현 + 구현위치 기입] 또는 [제외·해당없음 + 사유 기입]

⭐ CRUD·모달 매트릭스 축 (2026-08-07 확장 — 사용자 요구 "MAIN UI 와 모달의 CRUD 누락 0"):
  --init 이 대사표에 `## CRUD·모달 매트릭스` 섹션을 추가 생성한다:
  C-1) CRUD 행 `CRUD:{EID}:{액션}` — CRUD 성격 이벤트(키워드 분류: SEARCH/INSERT/DELETE/SAVE/EDIT)를
       액션 축으로 재정렬. 조회 전용 화면이면 SEARCH 행만 생성된다(강제 CRUD 행 없음 — 오탐 방지).
  C-2) 모달 행 `MODAL:{이름}` — 분석 md 팝업 절(Pop*/…팝업/Modal/Dialog 명칭) ∪ FE 실존 파일
       (`<페이지폴더>/**/*{Modal,Dialog}*.tsx`) 합집합. FE 에만 있는 모달 = "분석 근거 확인 필요" 표기.
  빈 셀 = --check FAIL (E/제약 행과 동일 판정). --check --matrix-only = 매트릭스 행만 판정(러너 섹션 5).

⭐ AS-IS 이벤트 핸들러 인벤토리 축 (2026-08-08 신설 — 사용자 요구 "AS-IS 의 모든 것을 놓치지 않도록"):
  대사표의 E번호는 **분석 md** 기준이라 **분석서가 놓친 핸들러는 게이트도 통과**시킨다
  (2026-08-08 실측: DMF0082 AS-IS 핸들러 25개 중 대사표가 이름으로 참조하던 것은 6개뿐).
  → `.cs` 에서 UI 이벤트 핸들러를 **기계 추출**해 각각 구현/제외/해당없음+사유를 강제한다.
    python asis_mapping_gate.py --handlers <MENU_ID> <페이지폴더>   # 섹션 생성/병합(기입값 보존)
    python asis_mapping_gate.py --check <페이지폴더> [--handlers-only]
  H-1) 핸들러 판정 = 메서드명 접미(_Click/_Changed/_SelectedIndexChanged/_ComboSelChange/
       _ClipboardPasted/_KeyUp/_KeyDown/_DoubleClick/_CellClick/_EditChange/_Enter/_Leave/_Load/
       _TextChanged/_ValueChanged/_CheckedChanged/_Closing/_Closed/_Validating)
       + BaseForm 오버라이드 액션(InsertRow/SaveData/FindData/DeleteButton/EditButton/SetEditList/Excel*).
  H-2) 주석 제외 **라이브 코드 라인수**를 함께 기록 — 3행 이하는 `**사문(빈 몸통)**` 표기
       (사문 = 미이관이 파리티 → 상태 '제외'+사유로 통과).
  H-3) 플랫폼 차이(WinForms 배관: Ctrl+V 수동 ClipboardPaste, bPasteContinue 플래그 등)는
       상태 '해당없음'+사유로 통과 — Wijmo 네이티브 처리와 등가임을 근거로 남긴다.

추출 한계 (anti-simplification 명시): 헤더·번호목록·표 3형식 외 서술형 문단 속 동작(예: 항번 없는
  보조 설명)은 행으로 분해되지 않는다 — 원천 md 가 hook #105 양식(E번호 체계)일 때 전수성이 보장된다.
"""
import argparse
import pathlib
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

MAPPING_FILENAME = "__asis-mapping__.md"

RE_HEADER = re.compile(r"^(#{1,6})\s*(.*)$")
RE_HEADER_EID_PREFIX = re.compile(r"^E(\d{1,3})(-\d{1,2})?\s*[.．:]?\s*(.*)$")
RE_EID_TOKEN = re.compile(r"\bE(\d{2,3})(-\d{1,2})?\b")
RE_NUM_ITEM = re.compile(r"^(\d{1,2})\.\s+(.*)$")
RE_TABLE_EID = re.compile(r"^\|\s*(E\d{1,3}(?:-\d{1,2})?)\s*\|(.*)$")
# 제약 ID — 실측 형식은 `A-15`/`P-23`/`DP-13`/`PL-07` 등 **접두 1~3자 + 하이픈 + 숫자** 다.
#   ⚠️ 구 패턴 `[A-K]\d{1,2}` 는 하이픈도 P/S/X 접두도 못 잡아 **DMF0082 제약 200행이 통째로 누락**됐다
#      (2026-08-08 실측 — D8 결함이 적힌 `P-23` 이 그 안에 있었다).
RE_TABLE_CONSTRAINT = re.compile(r"^\|\s*([A-Z]{1,3}-?\d{1,3})\s*\|(.*)$")
# ⭐ 범위 축약 행 — `| PL-05~18 | … ×14 |` 처럼 **1행이 N건**을 대표한다(2026-08-08 실측).
#   그대로 두면 13건이 조용히 사라진다 → 개별 ID 로 전개한다.
RE_TABLE_RANGE = re.compile(r"^\|\s*([A-Z]{1,3})-(\d{1,3})\s*~\s*(\d{1,3})\s*\|(.*)$")
# ID 컬럼이 없는 데이터 표(예: §1.2 파라미터 흐름) — 추출 대상이 아니므로 **건수를 보고**해 은폐를 막는다.
RE_TABLE_DATA_NOID = re.compile(r"^\|\s*[`\"'\w][^|]{0,80}\|.*\|.*\|")
# ⚠️ EID 세부 항번은 **문자 접미**도 쓴다(`E01-A`/`E01-B1`/`E08-C`). 구 패턴은 숫자 접미만 허용해
#   DMF0082 대사표 17 EID 행 중 **11행을 조용히 무시**했다(2026-08-08 실측 — 오늘 정정한 E01-B·E08-C 포함).
RE_MAP_ROW = re.compile(
    r"^\|\s*(E\d{1,3}(?:-[A-Za-z0-9]{1,3})?|[A-Z]{1,3}-?\d{1,3}"
    r"|CRUD:[^|\s]+|MODAL:[^|\s]+|HANDLER:[^|\s]+)\s*\|(.*)$"
)
# 대사표 안에서 **ID 행처럼 보이는데 위 패턴에 안 걸리는** 행 탐지 — 조용한 누락 차단(2026-08-08 신설).
RE_ID_LOOKALIKE = re.compile(r"^\|\s*([A-Za-z][\w]{0,4}[-_]?\d{1,3}[A-Za-z0-9]{0,2})\s*\|")

STATUS_OK_IMPL = "구현"
STATUS_EXCLUDED = "제외"
STATUS_NA = "해당없음"
STATUS_INIT = "미구현"

# CRUD 키워드 분류 (AS-IS 분석 md 한국어/영문 혼용 — 다중 패턴, anti-simplification §1.1)
CRUD_KEYWORDS = [
    ("SAVE", re.compile(r"저장|Save|SAVE_", re.I)),
    ("DELETE", re.compile(r"삭제|Delete|제거\b", re.I)),
    ("INSERT", re.compile(r"Insert|신규\s*행|신규행|추가\s*[—\-(]|수신자\s*추가", re.I)),
    ("EDIT", re.compile(r"편집\s*모드|EditChange|편집\s*이벤트|\bEdit\b", re.I)),
    ("SEARCH", re.compile(r"조회|Find|Search|Show[A-Z]|검색", re.I)),
]
RE_MD_POPUP = re.compile(r"\b([A-Za-z0-9_]*Pop[A-Z][A-Za-z0-9_]*|[A-Za-z0-9_]+(?:Modal|Dialog))\b")


def classify_crud(text):
    """이벤트 요지 → CRUD 액션 다중 분류 (첫 일치 1개가 아닌 전 일치 — 복합 이벤트 대응)."""
    hits = []
    for action, rx in CRUD_KEYWORDS:
        if rx.search(text):
            hits.append(action)
    return hits


def norm_eid(num, sub):
    return f"E{int(num):02d}" + (sub or "")


def gist(text, limit=90):
    t = re.sub(r"\s+", " ", text).strip().strip("|").strip()
    t = t.replace("|", "／")  # 표 셀 보호
    return (t[: limit - 1] + "…") if len(t) > limit else t


def extract_ids(md_paths):
    """[(id, 요지, 원천파일)] — 문서 등장 순. 중복 ID 는 최초 1회."""
    seen = {}
    order = []

    def add(_id, g, src):
        if _id not in seen:
            seen[_id] = (g, src)
            order.append(_id)

    for path in md_paths:
        text = pathlib.Path(path).read_text(encoding="utf-8", errors="ignore")
        src = pathlib.Path(path).name
        cur_eid = None  # 세부 항번 분해 대상 (suffix 없는 헤더 EID)
        for line in text.splitlines():
            hm = RE_HEADER.match(line)
            if hm:
                title = hm.group(2).strip()
                pm = RE_HEADER_EID_PREFIX.match(title)
                if pm:
                    eid = norm_eid(pm.group(1), pm.group(2))
                    add(eid, gist(pm.group(3) or title), src)
                    cur_eid = eid if not pm.group(2) else None
                else:
                    toks = RE_EID_TOKEN.findall(title)
                    if toks:
                        for num, sub in toks:
                            add(norm_eid(num, sub), gist(title), src)
                        cur_eid = norm_eid(*toks[0]) if not toks[0][1] and len(toks) == 1 else None
                    else:
                        cur_eid = None
                continue
            tm = RE_TABLE_EID.match(line)
            if tm:
                cells = [c.strip() for c in tm.group(2).split("|") if c.strip()]
                add(tm.group(1), gist(" / ".join(cells[:2]) if cells else ""), src)
                continue
            rm = RE_TABLE_RANGE.match(line)
            if rm:
                pre, a, b = rm.group(1), int(rm.group(2)), int(rm.group(3))
                cells = [c.strip() for c in rm.group(4).split("|") if c.strip()]
                base = gist(" / ".join(cells[:2])) if cells else ""
                for k in range(a, b + 1):
                    add(f"{pre}-{k:02d}", f"[범위행 {pre}-{a:02d}~{b:02d} 전개 {k - a + 1}/{b - a + 1}] {base}", src)
                continue
            cm = RE_TABLE_CONSTRAINT.match(line)
            if cm:
                cells = [c.strip() for c in cm.group(2).split("|") if c.strip()]
                if cells and not re.fullmatch(r"[-: ]+", cells[0]):
                    add(cm.group(1), gist(" / ".join(cells[:2])), src)
                continue
            if cur_eid:
                nm = RE_NUM_ITEM.match(line.strip())
                if nm:
                    add(f"{cur_eid}-{nm.group(1)}", gist(nm.group(2)), src)
    return [(i, seen[i][0], seen[i][1]) for i in order]


# ── 번호 체계(numbered) dialect ────────────────────────────────────────────────
# hook #105 는 `## E01. …` 를 쓰지만, 일부 분석서는 **계층 번호**(`## 1.` / `### 2.1` / `#### 1.4-A`)와
# **섹션별 번호 표**(`| 1 | …`)를 쓴다(DMF0042 실측). 원천 md 를 고쳐 쓰는 것은 위험하므로
# **게이트가 이 방언을 읽는다.** 매핑은 결정적이고 역추적 가능해야 한다:
#   `## 1.`      → E01           `### 2.1`  → E02-1        `#### 1.4-A` → E01-4A
#   제약 표 행   → C{섹션문자}-{행번호}  (§1→CA, §2→CB, … 하위섹션은 상위 문자에 누적)
# ⚠️ 어떤 방언을 썼는지 **항상 출력**한다 — 조용한 동작 변경 금지(hook #126 §5).
RE_NUM_SECTION = re.compile(r"^(\d{1,2})(?:\.(\d{1,2}))?(?:\s*-\s*([A-Za-z]\d?))?\s*[.．]?\s+(.*)$")
RE_TABLE_NUMROW = re.compile(r"^\|\s*(\d{1,3})\s*\|(.*)$")


def _sec_letter(n: int) -> str:
    """1→A, 2→B … 26→Z, 27→AA (상위 섹션 번호 → 문자 접두)."""
    s = ""
    while n > 0:
        n, r = divmod(n - 1, 26)
        s = chr(ord("A") + r) + s
    return s


NUMBERED_CONSUMED = set()   # 방언이 흡수한 표 행 원문 — count_noid_rows 중복 계상 방지


def extract_ids_numbered(md_paths):
    """계층 번호 방언 추출. 반환 형식은 `extract_ids` 와 동일."""
    seen, order = {}, []
    NUMBERED_CONSUMED.clear()

    def add(_id, g, src):
        if _id not in seen:
            seen[_id] = (g, src)
            order.append(_id)

    for path in md_paths:
        p = pathlib.Path(path)
        text = p.read_text(encoding="utf-8", errors="ignore")
        src = p.name
        # 역할 판정 — 이벤트 문서면 E 계열, 그 외(제약/매트릭스)는 C 계열 표 행을 뽑는다.
        is_event = any(k in src for k in ("주요이벤트", "상세동작", "이벤트"))
        top, sub, subsub, cur_prefix = 0, 0, "", ""
        noid_seq = {}   # 섹션접두 → 무번호 행 일련번호(100번대)
        for line in text.splitlines():
            hm = RE_HEADER.match(line)
            if hm:
                sm = RE_NUM_SECTION.match(hm.group(2).strip())
                if not sm:
                    continue
                a, b, c, title = sm.group(1), sm.group(2), sm.group(3), sm.group(4)
                top = int(a)
                sub = int(b) if b else 0
                subsub = (c or "").upper()
                cur_prefix = "C" + _sec_letter(top)
                if is_event:
                    eid = "E%02d" % top
                    if sub:
                        eid += "-%d%s" % (sub, subsub)
                    elif subsub:
                        eid += "-%s" % subsub
                    add(eid, gist("§%s %s" % (a + ("." + b if b else "") + ("-" + c if c else ""), title)), src)
                continue
            if is_event:
                continue
            s = line.strip()
            if not cur_prefix or not s.startswith("|") or re.fullmatch(r"[-: |]+", s):
                continue
            sec = "%d%s" % (top, ("." + str(sub)) if sub else "")
            nm = RE_TABLE_NUMROW.match(s)
            if nm:
                cells = [x.strip() for x in nm.group(2).split("|")]
                cells = [x for x in cells if x and not re.fullmatch(r"[-: ]+", x)]
                if not cells:
                    continue
                add("%s-%02d" % (cur_prefix, int(nm.group(1))),
                    gist("§%s %s" % (sec, " / ".join(cells[:2]))), src)
                NUMBERED_CONSUMED.add(s)
                continue
            # ⭐ ID 컬럼이 **없는** 데이터 표도 버리지 않는다(2026-08-09).
            #   DMF0042 실측: §9 메시지 인벤토리 16 · §2.2 권한 파라미터 11 · §4 기간·버킷 6 =
            #   전부 실제 제약인데 첫 셀이 숫자가 아니라 추출에서 빠졌다.
            #   → 같은 섹션 안에서 **100번대 일련번호**를 부여한다(= "원문에 번호가 없던 행" 표식).
            cells = [x.strip() for x in s.strip("|").split("|")]
            if not cells or not cells[0]:
                continue
            head0 = cells[0].lstrip("*` ")
            if head0.startswith(("#", "ID", "구분", "축", "대상", "항목", "파일", "컬럼", "위치", "MSG ID", "파라미터", "검사", "객체")):
                continue                       # 표 헤더 행
            noid_seq[cur_prefix] = noid_seq.get(cur_prefix, 100) + 1
            add("%s-%03d" % (cur_prefix, noid_seq[cur_prefix]),
                gist("§%s [원문 무번호] %s" % (sec, " / ".join(x for x in cells[:2] if x))), src)
            NUMBERED_CONSUMED.add(s)
    return [(i, seen[i][0], seen[i][1]) for i in order]


def count_noid_rows(md_paths, numbered=False):
    """ID 컬럼이 없는 데이터 표 행 수 — 추출 대상이 아니므로 **건수를 보고**해 조용한 누락을 막는다.

    (예: DMF0082 §1.2 'division 파라미터 흐름' 10행 — 대상／파라미터／라인 3열, ID 없음)
    ⚠ `numbered=True` = 계층 번호 방언이 `| 1 | …` 행을 **이미 흡수**했으므로 중복 계상하지 않는다
      (2026-08-09: 미보정 시 DMF0042 에서 215건으로 과대보고 → 경고가 늑대소년이 된다).
    """
    n, srcs = 0, {}
    for path in md_paths:
        for line in pathlib.Path(path).read_text(encoding="utf-8", errors="ignore").splitlines():
            s = line.strip()
            if not s.startswith("|") or re.fullmatch(r"[-: |]+", s):
                continue
            if RE_MAP_ROW.match(s) or RE_TABLE_RANGE.match(s):
                continue
            if numbered and (RE_TABLE_NUMROW.match(s) or s in NUMBERED_CONSUMED):
                continue
            cells = [c for c in s.strip("|").split("|")]
            if len(cells) >= 3 and cells[0].strip() and not cells[0].strip().startswith(("#", "ID", "구분", "축", "대상", "항목")):
                n += 1
                srcs[pathlib.Path(path).name] = srcs.get(pathlib.Path(path).name, 0) + 1
    return n, srcs


def id_sort_key(_id):
    m = re.match(r"E(\d+)(?:-(\d+))?$", _id)
    if m:
        return (1, int(m.group(1)), int(m.group(2) or 0), "")
    m = re.match(r"([A-K])(\d+)$", _id)
    if m:
        return (0, ord(m.group(1)), int(m.group(2)), "")
    if _id.startswith("CRUD:"):
        return (3, 0, 0, _id)
    if _id.startswith("MODAL:"):
        return (4, 0, 0, _id)
    return (2, 0, 0, _id)


def build_matrix_rows(ids, page_dir, md_texts=None):
    """CRUD·모달 매트릭스 행 [(id, 요지)] — C-1 CRUD 분류 + C-2 모달 합집합."""
    rows = []
    # C-1: 최상위 EID (sub 항번 제외) 의 요지를 CRUD 분류
    for _id, g, src in ids:
        if not re.fullmatch(r"E\d+", _id):
            continue
        for action in classify_crud(g):
            rows.append((f"CRUD:{_id}:{action}", f"[{action}] {g}"))
    # C-2: 모달 — 분석 md 전문 팝업 명칭 ∪ FE 실존 파일
    md_names = {}
    for src, text in (md_texts or {}).items():
        for name in RE_MD_POPUP.findall(text):
            norm = re.sub(r"^[A-Z0-9]+_(?=Pop)", "", name)  # SCM0006_PopSQL → PopSQL
            norm = re.sub(r"\d+$", "", norm)  # 라인 인용(PopSQL173) → PopSQL (한계: 숫자 접미 모달명 병합)
            if norm:
                md_names.setdefault(norm, set()).add(src)
    fe_names = {}
    if page_dir and pathlib.Path(page_dir).is_dir():
        for pat in ("*Modal*.tsx", "*Dialog*.tsx"):
            for f in pathlib.Path(page_dir).rglob(pat):
                fe_names.setdefault(f.stem, set()).add(str(f.relative_to(page_dir)).replace("\\", "/"))
    for name in sorted(md_names):
        rows.append((f"MODAL:{name}", f"AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무"))
    for name in sorted(fe_names):
        origin = "; ".join(sorted(fe_names[name]))
        rows.append((f"MODAL:{name}", f"FE 실존 모달 ({origin}) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입)"))
    # 중복 ID 제거 (md/FE 동명 시 md 요지 우선)
    seen, out = set(), []
    for _id, g in rows:
        if _id in seen:
            continue
        seen.add(_id)
        out.append((_id, g))
    return out


def parse_existing(path):
    """기존 대사표 → {id: 원본행문자열} (기입값 보존)."""
    rows = {}
    if not path.exists():
        return rows
    for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        m = RE_MAP_ROW.match(line.strip())
        if m and not re.fullmatch(r"[-: |]+", line.strip()):
            rows[m.group(1)] = line.rstrip()
    return rows


def cmd_init(md_paths, page_dir, out_override=None, allow_legacy=False):
    md_paths = [pathlib.Path(p) for p in md_paths]
    for p in md_paths:
        if not p.is_file():
            sys.exit(f"[error] 분석 md 없음: {p}")
    # 자동 짝 발견: 주요이벤트 md → 동일 prefix 제약매트릭스 md
    extra = []
    for p in list(md_paths):
        name = p.name
        if "주요이벤트" in name:
            cand = p.parent / name.replace("주요이벤트_상세분석", "제약매트릭스_상세")
            if cand.is_file() and cand not in md_paths:
                extra.append(cand)
    if extra:
        print(f"[auto] 제약매트릭스 md 자동 포함: {', '.join(e.name for e in extra)}")
        md_paths.extend(extra)

    # ⭐ 방언 판정은 **md 파일 단위**로 한다 (2026-08-09 2차 정정).
    #   ⛔ 구 로직은 md 전체 합집합이 0건일 때만 계층번호 방언으로 넘어갔다. 그래서
    #     "제약 md 는 `A-1` 형식이라 87건이 잡히고, 주요이벤트 md 는 E번호 0건" 인 조합에서
    #     **이벤트 축이 통째로 누락된 채 통과**했다(DMF0044 실측 — 이벤트 E 0 / 제약 87).
    #     파일마다 양식이 다를 수 있으므로 파일별로 판정하고, 어떤 파일이 어느 방언인지 **항상 출력**한다.
    ids, seen_ids, dialect_notes, used_numbered = [], set(), [], False
    for p in md_paths:
        part = extract_ids([p])
        dname = "hook#105 E번호"
        if not part:
            part = extract_ids_numbered([p])
            if part:
                dname = "계층번호(numbered)"
                used_numbered = True
            else:
                dname = "추출 0 (양식 미상)"
        dialect_notes.append("%s=%s(%d건)" % (p.name, dname, len(part)))
        for t in part:
            if t[0] not in seen_ids:
                seen_ids.add(t[0])
                ids.append(t)
    dialect = " / ".join(dialect_notes)
    print("[dialect] %s · 합계 %d건" % (dialect, len(ids)))
    for note in dialect_notes:
        if "추출 0" in note:
            print("  ⚠ %s — 이 파일의 축이 대사표에 **하나도 들어가지 않았다**. 양식 확인 필요" % note)
    md_texts = {p.name: p.read_text(encoding="utf-8", errors="ignore") for p in md_paths}
    matrix = build_matrix_rows(ids, page_dir, md_texts)
    if not ids and not matrix:
        sys.exit("[error] EID/제약/CRUD·모달 추출 0건 — 원천 md 가 hook #105 양식(E번호)인지 확인")
    if not ids:
        # [hook #125 §5 / 2026-08-07] 구양식 md = EID 추출 0 → 대사표가 실질 공백인데 게이트 통과하는 사고
        #   (DMF0082 실측). 신규 화면은 #105 양식 md 가 전제이므로 FAIL 로 승격하고,
        #   기존 화면 보완 등 불가피한 경우만 --allow-legacy-md 로 명시 우회(리포트에 사유 남김).
        msg = ("[error] EID/제약 ID 추출 0건 — 원천 md 가 hook #105 양식(E번호)이 아님. "
               "#105 양식으로 md 재작성 후 재실행하거나, 불가피하면 --allow-legacy-md 로 명시 우회(사유 기록 의무)")
        if not allow_legacy:
            sys.exit(msg)
        print("[warn] EID/제약 ID 추출 0건 — --allow-legacy-md 우회(구양식 md). CRUD·모달 매트릭스만 생성 — 사유 기록 의무")

    page = pathlib.Path(page_dir)
    target = pathlib.Path(out_override) if out_override else page / MAPPING_FILENAME
    existing = parse_existing(target)

    header_cols = "| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |"
    lines = []
    lines.append(f"# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)")
    lines.append("")
    lines.append(f"> 원천: {', '.join('`' + p.name + '`' for p in md_paths)} · 생성: asis_mapping_gate.py --init")
    lines.append("> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.")
    lines.append("")
    lines.append("## 이벤트·제약 (EID 1:1)")
    lines.append("")
    lines.append(header_cols)
    lines.append("|---|---|---|---|---|")
    n_new, n_kept = 0, 0

    def emit(_id, g):
        nonlocal n_new, n_kept
        if _id in existing:
            lines.append(existing.pop(_id))
            n_kept += 1
        else:
            lines.append(f"| {_id} | {g} |  |  | {STATUS_INIT} |")
            n_new += 1

    for _id, g, src in sorted(ids, key=lambda x: id_sort_key(x[0])):
        emit(_id, g)
    lines.append("")
    lines.append("## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)")
    lines.append("")
    lines.append(header_cols)
    lines.append("|---|---|---|---|---|")
    for _id, g in sorted(matrix, key=lambda x: id_sort_key(x[0])):
        emit(_id, g)
    # ⭐ 2026-08-08 — 보존 섹션(핸들러 인벤토리 등)에 이미 있는 ID 는 여기서 재출력하지 않는다(중복 방지).
    preserved_ids = set()
    MANAGED = ("## 이벤트·제약 (EID 1:1)", "## CRUD·모달 매트릭스")
    preserved = []
    if target.is_file():
        keep, cur = True, None
        for ln in target.read_text(encoding="utf-8", errors="ignore").splitlines():
            if ln.startswith("## "):
                cur = ln
                keep = not any(ln.startswith(m) for m in MANAGED)
            if keep and cur is not None:
                preserved.append(ln)
                pm = RE_MAP_ROW.match(ln.strip())
                if pm:
                    preserved_ids.add(pm.group(1))
    # 원천에 없지만 기존 표에 있던 행도 보존 (수기 추가분)
    for _id, row in existing.items():
        if _id in preserved_ids:
            continue
        lines.append(row)
        n_kept += 1

    if preserved:
        lines.append("")
        lines.extend(preserved)

    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text("\n".join(lines) + "\n", encoding="utf-8")
    n_noid, noid_srcs = count_noid_rows(md_paths, numbered=used_numbered)
    if n_noid:
        print(f"[warn] ID 컬럼 없는 데이터 표 행 {n_noid}건 — **추출 대상 아님**. "
              f"제약으로 세야 하면 수기 ID 부여 후 추가할 것 (조용한 누락 방지): "
              f"{', '.join(f'{k} {v}건' for k, v in noid_srcs.items())}")
    e_cnt = sum(1 for i, _, _ in ids if i.startswith("E"))
    c_cnt = len(ids) - e_cnt
    crud_cnt = sum(1 for i, _ in matrix if i.startswith("CRUD:"))
    modal_cnt = len(matrix) - crud_cnt
    print(f"[init] {target}")
    print(f"       추출 {len(ids) + len(matrix)}행 (이벤트 E {e_cnt} / 제약 {c_cnt} / CRUD {crud_cnt} / 모달 {modal_cnt}) — 신규 {n_new} / 기존 보존 {n_kept}")
    for _id, g, src in sorted(ids, key=lambda x: id_sort_key(x[0])):
        print(f"       {_id:8} | {src} | {g}")
    for _id, g in sorted(matrix, key=lambda x: id_sort_key(x[0])):
        print(f"       {_id} | {g}")
    return 0


# ── ⭐ AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 신설) ────────────────────────────────
# 배경: 대사표는 **분석 md 의 E번호**에 묶여 있고 **AS-IS 소스의 실제 핸들러 목록**에는 안 묶여 있다.
#   → 분석서가 놓친 핸들러는 게이트도 통과시킨다(2026-08-08 실측: DMF0082 AS-IS 핸들러 24개 중
#      대사표가 이름으로 참조하는 것은 6개뿐이었다).
#   본 축은 `.cs` 에서 핸들러를 **기계로 뽑아** 각각 구현/제외/해당없음+사유를 강제한다.
# ⚠️ 2026-08-09 정정 — 구 정규식은 **닫힌 화이트리스트**였고, 열거에 없는 핸들러를 **조용히 버렸다.**
#   DMF0042 정본 실측 누락 6종: spdMain_CellDoubleClick / spdMain_TopChange / OnShown /
#   FindButton / InsertButton / SaveButton (전부 `.cs` 에 실재. hook #126 §5.1 '정규식 미매칭 무시').
#   → ① 이벤트 접미는 **접두어 허용**(`_CellDoubleClick` = `Cell`+`DoubleClick`) ② BaseForm override 보강
#      ③ 그래도 안 걸린 것은 버리지 말고 `residual_handlers()` 로 **미분류 후보 보고**(§3 잔여 노출).
HANDLER_RE = re.compile(
    r"_\w*?(Click|DoubleClick|Change|Changed|SelectedIndexChanged|ComboSelChange"
    r"|ClipboardPasted|Pasted|Paste|KeyUp|KeyDown|EditChange|Enter|Leave|Load"
    r"|TextChanged|ValueChanged|CheckedChanged|Closing|Closed|Validating|Scroll|LeaveCell|EnterCell|CellClick)$"
    r"|^(InsertRow|SaveData|FindData|DeleteButton|EditButton|FindButton|InsertButton|SaveButton"
    r"|NewButton|PrintButton|CopyButton|ExcelButton|SetEditList|ExcelUpload|ExcelDownload|OnShown|OnLoad)$"
)

# 핸들러 '후보' — 이벤트 시그니처(sender, EventArgs) 또는 BaseForm override 형태.
#   HANDLER_RE 에 안 걸린 후보는 **삭제하지 않고 미분류로 보고**한다.
HANDLER_CANDIDATE_RE = re.compile(r"^(?:On[A-Z]\w+|[a-z]\w*_[A-Z]\w+|\w+Button|\w+Data|\w+Row)$")
# 사문(빈 몸통) 판정 — 라이브 코드가 이보다 적으면 "사문/스텁" 으로 표기(미이관이 파리티)
HANDLER_DEAD_LINES = 3


def extract_handlers(menu):
    """AS-IS `{MENU}_*.cs` 에서 UI 이벤트 핸들러를 전수 추출.

    반환: [(핸들러명, 시작라인, 라이브 코드 라인수)] — 주석은 제외하고 센다.
    """
    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
    import combo_callsite_parity as CC

    # ⚠ resolve_cs 는 2026-08-09 부터 (path, 사유, 후보수, 후보목록) 4-튜플을 반환한다
    #   (정본 레지스트리 + 다중후보 FAIL). 모호하면 path=None → 조용히 진행하지 않는다.
    cs, canon_why, _ncand, _cands = CC.resolve_cs(menu)
    if not cs:
        return None, canon_why
    live = CC.strip_comments(cs.read_text(encoding="utf-8", errors="ignore"))
    out, residual = [], []
    for name, s, e in CC.parse_methods(live):
        body = live[s:e]
        n_live = sum(1 for l in body.splitlines() if l.strip())
        rec = (name, live.count("\n", 0, s) + 1, n_live)
        if HANDLER_RE.search(name):
            out.append(rec)
        elif HANDLER_CANDIDATE_RE.match(name):
            residual.append(rec)          # ⚠ 버리지 않는다 — 미분류로 보고
    if residual:
        print("  ⚠ 미분류 핸들러 후보 %d개 — HANDLER_RE 보강 또는 제외 사유 필요:" % len(residual))
        for n, ln, nl in sorted(set(residual)):
            print("      · %s (%s:%d, 라이브 %d행)" % (n, cs.name, ln, nl))
    return sorted(set(out)), cs


def cmd_handlers(menu, page_dir, out_override=None):
    """대사표에 `## AS-IS 이벤트 핸들러 인벤토리` 섹션을 생성/병합 (기입값 보존)."""
    page = pathlib.Path(page_dir)
    target = pathlib.Path(out_override) if out_override else (page / MAPPING_FILENAME)
    handlers, cs = extract_handlers(menu)
    if handlers is None:
        print(f"[error] AS-IS .cs 미발견 ({menu}_*.cs)")
        return 2
    existing = parse_existing(target)
    text = target.read_text(encoding="utf-8", errors="ignore") if target.is_file() else ""

    rows = []
    for name, line, n_live in handlers:
        _id = f"HANDLER:{name}"
        if _id in existing:
            rows.append(existing[_id])
            continue
        dead = " · **사문(빈 몸통)**" if n_live <= HANDLER_DEAD_LINES else ""
        rows.append(f"| {_id} | AS-IS `{cs.name}:{line}` (라이브 {n_live}행){dead} |  |  | {STATUS_INIT} |")

    sec = [
        "",
        "## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)",
        "",
        f"> 원천: `{cs.relative_to(pathlib.Path(__file__).resolve().parents[2])}` — `.cs` 에서 **기계 추출**한 "
        f"UI 이벤트 핸들러 {len(handlers)}개.",
        "> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.",
        "> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.",
        "",
        "| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |",
        "|---|---|---|---|---|",
    ] + rows
    if "## AS-IS 이벤트 핸들러 인벤토리" in text:
        text = re.sub(r"\n## AS-IS 이벤트 핸들러 인벤토리[\s\S]*?(?=\n## |$)", "", text)
    target.write_text(text.rstrip() + chr(10) + chr(10).join(sec) + chr(10), encoding="utf-8")
    n_new = sum(1 for r in rows if r.endswith(f"| {STATUS_INIT} |"))
    print(f"[init] 핸들러 {len(handlers)}개 — 신규 {n_new} / 기존 보존 {len(handlers)-n_new} → {target}")
    return 0


def check_citations(page_dir, db_ids=None):
    """⭐ 인용 실재성 검사 (2026-08-08 신설) — 상태='구현' 행의 **구현 위치 인용이 진짜인지** 확인.

    대사표는 "빈 칸 없음"만 강제할 뿐 **기입 내용이 참인지는 보지 않는다.** 오래된/잘못된 인용이
    "구현"으로 남아 있으면 대사표 자체가 거짓 안심을 준다(2026-08-08 실측: `editLock.ts` 오인용 1건).
    ⚠️ 한계 — 파일·심볼이 **존재한다**는 것만 증명한다. 그 코드가 AS-IS 와 **동일하게 동작**하는지는
       증명하지 못한다(그 축은 단위테스트·런타임 E2E 담당).
    """
    page = pathlib.Path(page_dir)
    src = {f.name: f.read_text(encoding="utf-8", errors="ignore")
           for f in list(page.rglob("*.ts")) + list(page.rglob("*.tsx"))}

    # ⭐ 2026-08-11 — 오탐 계보 "폴더밖 배선" 제거.
    #   구현이 페이지 폴더 밖(공용 모달·shared 훅 등)에 있으면 인용도 워크스페이스 상대경로로 적는다
    #   (예 `features/demand/src/components/versionModal/VersionModal.tsx`).
    #   기존 구현은 페이지 폴더만 색인해 이런 정당한 인용을 전부 '미존재'로 찍었다
    #   (실측: DMF0044 12건 / DMF0049 1건 — 파일은 모두 실재).
    #   ⇒ **경로가 포함된 인용**은 FE 루트(nscm-fe) 기준으로 실재 확인하고, 그 파일 본문도 blob 에 넣는다.
    #   ⚠ 경로 없는 맨 파일명(`save.ts` 같은 축약)은 **계속 엄격 판정** — 실제 축약 오인용을 잡아야 한다.
    #   해석 기준(base)은 **모호하지 않은 절대 해석 2종만** 허용한다:
    #     ① FE 루트           — `features/demand/src/components/versionModal/VersionModal.tsx` (DMF0049 표기)
    #     ② 해당 feature 의 src — `components/versionModal/VersionModal.tsx`                   (DMF0044 표기)
    #   두 표기 모두 실제 산출물에서 쓰이며 파일은 실재한다. 탐색(glob)이 아니라 고정 base 결합이라
    #   동명이파일을 잘못 집는 일이 없다.
    _rp = page.resolve()
    fe_root = next((p for p in _rp.parents if p.name == "nscm-fe"), None)
    feat_src = next((p for p in _rp.parents
                     if p.name == "src" and p.parent.parent.name == "features"), None)
    #     ③ 리포지토리 루트    — `nscm-fe/features/.../VersionModal.tsx` (DMF0044 E05 표기)
    repo_root = fe_root.parent if fe_root is not None else None
    bases = [b for b in (fe_root, feat_src, repo_root) if b is not None]
    ext_src = {}

    def _resolve_ext(tok):
        """상대경로 인용 → 실재 파일 반환(없으면 None). 경로 없는 맨 파일명은 대상 아님."""
        if "/" not in tok:
            return None
        for b in bases:
            cand = b / tok
            if cand.is_file():
                return cand
        return None

    blob = "\n".join(src.values())
    db_ids = db_ids or set()
    bad = []
    total = 0
    for line in (page / MAPPING_FILENAME).read_text(encoding="utf-8", errors="ignore").splitlines():
        m = RE_MAP_ROW.match(line.strip())
        if not m or re.fullmatch(r"[-: |]+", line.strip()):
            continue
        cells = [c.strip() for c in m.group(2).strip().strip("|").split("|")]
        while len(cells) < 4:
            cells.append("")
        if cells[3] != STATUS_OK_IMPL:
            continue
        total += 1
        loc = cells[1]
        # 경로 포함 인용(폴더밖 배선)을 먼저 해소 — 실재하면 본문을 심볼 대조용 blob 에 합류시킨다
        row_blob = blob
        for tok in set(re.findall(r"([A-Za-z][\w./\-]*\.tsx?)", loc)):
            f = _resolve_ext(tok)
            if f is not None:
                if f.name not in ext_src:
                    ext_src[f.name] = f.read_text(encoding="utf-8", errors="ignore")
                row_blob += "\n" + ext_src[f.name]
        miss = [f for f in set(re.findall(r"([A-Za-z][\w.\-]*\.tsx?)", loc))
                if f not in src and f not in ext_src]
        # 백틱 심볼 — FE 소스에 없고 DB 식별자(CMBO SQL_ID 등)도 아니면 오인용
        miss += [s for s in set(re.findall(r"`([A-Za-z_$][\w$]*)`", loc))
                 if s not in row_blob and s not in db_ids]
        if miss:
            bad.append((m.group(1), miss))
    return total, bad


def cmd_check(page_dir, matrix_only=False, handlers_only=False, citations=False):
    page = pathlib.Path(page_dir)
    target = page / MAPPING_FILENAME
    scope = ("AS-IS 핸들러 인벤토리" if handlers_only else
             "CRUD·모달 매트릭스" if matrix_only else "EID 1:1(+매트릭스+핸들러)")
    if not target.is_file():
        print(f"[FAIL] 대사표 부재: {target} — --init 으로 선생성 의무 (asis-coverage-check §0.1)")
        return 1
    residual = []
    total = 0
    unparsed = []
    for line in target.read_text(encoding="utf-8", errors="ignore").splitlines():
        m = RE_MAP_ROW.match(line.strip())
        if not m or re.fullmatch(r"[-: |]+", line.strip()):
            # ⭐ 조용한 누락 차단 (2026-08-08 신설) — ID 행 꼴인데 파싱이 안 되면 **묵과하지 않는다**.
            #   구 패턴이 `P-23`/`E01-A` 를 못 잡아 제약 200행·EID 11행을 통째로 무시하고도
            #   "PASS" 를 냈던 실사고 계보. 패턴 확장 시 재발 방지용 안전망.
            lk = RE_ID_LOOKALIKE.match(line.strip())
            if lk and not re.fullmatch(r"[-: |]+", line.strip()):
                if re.match(r"^(E\d|[A-Z]{1,3}-\d)", lk.group(1)):
                    unparsed.append(lk.group(1))
            continue
        _id = m.group(1)
        is_matrix = _id.startswith("CRUD:") or _id.startswith("MODAL:")
        is_handler = _id.startswith("HANDLER:")
        if matrix_only and not is_matrix:
            continue
        if handlers_only and not is_handler:
            continue
        total += 1
        cells = [c.strip() for c in m.group(2).strip().strip("|").split("|")]
        while len(cells) < 4:
            cells.append("")
        _gist, impl, reason, status = cells[0], cells[1], cells[2], cells[3]
        impl_filled = impl not in ("", "—", "-")
        reason_filled = reason not in ("", "—", "-")
        if status == STATUS_OK_IMPL and impl_filled:
            continue
        if status in (STATUS_EXCLUDED, STATUS_NA):
            if reason_filled:
                continue
            residual.append((_id, f"상태={status} 인데 사유 공란 (빈 사유 = FAIL)"))
            continue
        if status == STATUS_OK_IMPL:
            residual.append((_id, "상태=구현 인데 구현 위치 공란"))
        else:
            residual.append((_id, f"상태='{status or STATUS_INIT}' — 미구현 잔여"))
    if citations:
        import oracledb
        from ora import conn_info as _ci
        u, pw, d = _ci()
        with oracledb.connect(user=u, password=pw, dsn=d) as con:
            cur = con.cursor()
            cur.execute("SELECT SQL_ID FROM SCM_MGR.SCM_ADM_CMBO_SQL_M")
            db_ids = {r[0] for r in cur.fetchall()}
        n_tot, bad = check_citations(page_dir, db_ids)
        if bad:
            print(f"[FAIL] 인용 실재성 — 상태='구현' {n_tot}행 중 {len(bad)}행이 **존재하지 않는 파일/심볼**을 인용")
            for _id, miss in bad:
                print(f"  ⛔ {_id:12} | {', '.join(miss)}")
            return 1
        print(f"[PASS] 인용 실재성 — 상태='구현' {n_tot}행 전부 파일·심볼 실재 확인")
    if unparsed:
        print(f"[FAIL] ID 행 꼴인데 파싱 불가 {len(unparsed)}건 — 대사표 ID 형식 또는 RE_MAP_ROW 확장 필요 "
              f"(조용한 누락 차단): {', '.join(sorted(set(unparsed)))}")
        return 1
    if total == 0:
        if matrix_only:
            print(f"[FAIL] {target} 에 CRUD·모달 매트릭스 행 0건 — 2026-08-07 축 미생성 (--init 재실행 필요)")
        else:
            print(f"[FAIL] {target} 에 대사 행 0건")
        return 1
    if residual:
        print(f"[FAIL] 잔여 {len(residual)}/{total} 행 — {scope} 게이트 실패 ({target})")
        for _id, why in residual:
            print(f"  ⛔ {_id:8} | {why}")
        return 1
    print(f"[PASS] {total}/{total} 행 전수 [구현+위치] 또는 [제외·해당없음+사유] — {scope} 게이트 통과 ({target})")
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--init", nargs="+", metavar="PATH", help="<분석md...> <페이지폴더> (마지막 인자 = 폴더)")
    ap.add_argument("--check", metavar="페이지폴더")
    ap.add_argument("--out", help="--init 대사표 출력 경로 override (드라이런/검증)")
    ap.add_argument("--matrix-only", action="store_true", help="--check 시 CRUD·모달 매트릭스 행만 판정 (러너 섹션 5)")
    ap.add_argument("--handlers", nargs=2, metavar=("MENU_ID", "페이지폴더"),
                    help="AS-IS .cs 이벤트 핸들러 인벤토리 섹션 생성/병합 (2026-08-08 축)")
    ap.add_argument("--handlers-only", action="store_true", help="--check 시 HANDLER 행만 판정")
    ap.add_argument("--citations", action="store_true",
                    help="--check 시 상태='구현' 행의 구현 위치 인용(파일·심볼) 실재성까지 검증")
    ap.add_argument("--allow-legacy-md", action="store_true",
                    help="--init 시 EID 추출 0건(구양식 md) 허용 — 기본은 FAIL (hook #125 §5). 사유 기록 의무")
    args = ap.parse_args()
    if args.init:
        if len(args.init) < 2:
            ap.error("--init 은 <분석md 1개 이상> + <페이지폴더> 필요")
        sys.exit(cmd_init(args.init[:-1], args.init[-1], args.out, args.allow_legacy_md))
    if args.handlers:
        sys.exit(cmd_handlers(args.handlers[0], args.handlers[1], args.out))
    if args.check:
        sys.exit(cmd_check(args.check, matrix_only=args.matrix_only,
                           handlers_only=args.handlers_only, citations=args.citations))
    ap.error("--init 또는 --check 필요")


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception as e:
        print(f"[error] {e}", file=sys.stderr)
        sys.exit(2)
