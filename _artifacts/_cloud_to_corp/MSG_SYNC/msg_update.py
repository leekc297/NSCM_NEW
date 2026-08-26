#!/usr/bin/env python3
"""
msg_update.py — 클라우드 MSG 추출본 1개를 받아 사내 오라클을 클라우드 기준으로 맞춘다.

  python msg_update.py <클라우드추출본.csv|txt>            # 생성만 (기본 — 아무것도 바꾸지 않음)
  python msg_update.py <파일> --apply-db                   # 사내 DB 실제 적용
  python msg_update.py <파일> --apply-ui                   # FE 소스 코드 치환 실제 적용

처리 규칙 (사용자 확정 2026-08-21)
  A. 코드 동일 · 명칭 상이  -> 사내 명칭을 **클라우드 기준으로 UPDATE**
  B. 사내에 코드 없음       -> **신규 INSERT**
  C. A 중 그 코드를 쓰는 UI 가 있으면, 그 UI 가 쓰던 **옛 명칭**을 잃지 않도록
       C-1) 클라우드에 같은 명칭을 가진 다른 코드가 있으면 -> UI 를 그 코드로 **치환**
       C-2) 없으면 -> 사내에 **신규 코드 채번**(01001+ 대역)해 옛 명칭으로 INSERT,
                     UI 를 그 코드로 치환, 그리고 **클라우드에도 INSERT** 할 SQL 을 낸다
     ※ C 가 A 를 안전하게 만든다. C 없이 A 만 하면 그 코드를 쓰는 다른 화면이 조용히 오표기된다
       (2026-08-14 사용자 확정 규약 — 기존 코드 문구 덮어쓰기 위험).

채번 규약 (feedback_i18n_new_code_three_point_sync)
  - 기존에 같은 명칭이 있으면 그 코드 재사용 (= C-1). 없을 때만 신규 채번 (= C-2).
  - 신규는 **01001 이상 대역**에서 MAX+1. 1000 미만 공번 메우기 금지, 전대역 MAX+1 금지.
  - MAX 는 **사내 + 클라우드 양측**을 함께 본다(클라우드 선점 코드 충돌 방지).
  - 대역 밖 이상치(예: MSG99999 = 테스트 행)는 MAX 계산에서 제외한다.

산출물 (OUTDIR)
  00_REPORT.xlsx          판정표 (요약/명칭상이/신규유입/UI치환/사내단독/입력이상)
  10_CORP_APPLY.sql       사내 적용 — UPDATE 명칭 + INSERT 신규유입 + INSERT 신규채번
  20_CORP_META_REMAP.sql  사내 메타 코드 치환 (MNU_MSG_ID / API_MSG_ID / LOOKUP.SEGMENT2)
  30_CLOUD_PUSH.sql       클라우드 역이관 — 신규 채번 코드 INSERT
  40_UI_REMAP.md          FE 소스 치환 목록 (파일:라인, 옛코드 -> 새코드)
"""
from __future__ import annotations

import argparse
import csv
import importlib.util
import io
import json
import re
import subprocess
import sys
import unicodedata
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
ORA_PY = REPO / "_artifacts" / "_diagnostics" / "ora.py"
LOCALES_DIR = REPO / "nscm-fe" / "public" / "locales"
LANGS = ("KO", "EN", "CN")
AUDIT_BY = "admin"                      # 메타 감사컬럼은 'admin' 만 (claude ID 금지)

SCAN_ROOTS = ["nscm-fe/features", "nscm-fe/apps", "nscm-fe/packages",
              "nscm-be/src/main/java", "nscm-be/src/main/resources"]
SCAN_GLOBS = ["*.ts", "*.tsx", "*.java", "*.xml"]
SCAN_EXCLUDE = ["!node_modules", "!dist", "!build", "!.git"]   # 포함 뒤에 와야 바인딩됨

CODE_TOKEN_RE = re.compile(r"\b(?:LBL|MSG|MNU)[0-9A-Za-z_]{3,}\b")
MENU_ID_RE = re.compile(r"MENU_ID\s*(?::[^=]*)?=\s*['\"]([A-Za-z0-9_]+)['\"]")
NUMBERED_RE = re.compile(r"^(LBL|MSG|MNU)(\d{5})$")
BAND_LO, BAND_HI = 1001, 9999           # 신규 채번 대역

FIELDS = ("MSG_ID", "LANG_CD", "MSG_NM", "MSG_DESC", "MSG_TP_CD", "USE_YN")
# 사용자 추출본의 헤더 변형 흡수
HEADER_ALIAS = {
    "msg_id": "MSG_ID", "msgid": "MSG_ID", "message_id": "MSG_ID", "messageid": "MSG_ID",
    "lang_cd": "LANG_CD", "langcd": "LANG_CD", "lang": "LANG_CD", "language": "LANG_CD",
    "msg_nm": "MSG_NM", "msgnm": "MSG_NM", "message_nm": "MSG_NM", "messagenm": "MSG_NM",
    "msg_name": "MSG_NM", "message_name": "MSG_NM",
    "msg_desc": "MSG_DESC", "msgdesc": "MSG_DESC", "description": "MSG_DESC",
    "msg_tp_cd": "MSG_TP_CD", "msgtpcd": "MSG_TP_CD", "msg_type": "MSG_TP_CD",
    "use_yn": "USE_YN", "useyn": "USE_YN",
}


# ---------------------------------------------------------------------------
# 입력 로더 — 구분자/인코딩/헤더 변형을 사람이 신경 쓰지 않도록 흡수
# ---------------------------------------------------------------------------
def _norm_key(k):
    return re.sub(r"[^0-9a-z_]", "", (k or "").strip().lower())


def load_json_export(text, path, enc):
    """JSON 추출본.
    지원 형태
      1) SQLcl / SQL Developer : {"results":[{"columns":[...],"items":[{...}]}]}
      2) 단순 배열             : [{...}, ...]
      3) {"items":[...]} / {"data":[...]} / {"rows":[...]}
      4) JSON Lines            : 한 줄에 객체 하나

    ⚠ 키는 소문자(msg_id …)로 오고, **NULL 컬럼은 키 자체가 생략**된다
      (SQLcl 실측 — msg_desc 없는 항목 다수). 키 부재 = NULL 로 다룬다.
    """
    shape, items = None, None
    try:
        data = json.loads(text)
    except json.JSONDecodeError:
        items, shape = [], "JSON Lines"
        for ln in text.splitlines():
            ln = ln.strip().rstrip(",")
            if ln.startswith("{"):
                items.append(json.loads(ln))
        data = None

    if data is not None:
        if isinstance(data, list):
            items, shape = data, "배열"
        elif isinstance(data, dict):
            if isinstance(data.get("results"), list):
                items, shape = [], "SQLcl results/items"
                for res in data["results"]:
                    items.extend(res.get("items") or [])
            else:
                for k in ("items", "data", "rows", "records"):
                    if isinstance(data.get(k), list):
                        items, shape = data[k], f"{{{k}}}"
                        break
    if items is None:
        raise SystemExit(f"JSON 구조를 해석하지 못했습니다: {path}")

    recs, bad = {}, []
    for ln, it in enumerate(items, 1):
        if not isinstance(it, dict):
            bad.append({"라인": ln, "사유": "객체가 아님", "원문": str(it)[:200]})
            continue
        m = {}
        for k, v in it.items():
            f = HEADER_ALIAS.get(_norm_key(k))
            if f and f not in m:                      # 값은 원문 그대로 (트림 금지)
                m[f] = None if v is None or v == "" else v
        mid, lang = m.get("MSG_ID"), m.get("LANG_CD")
        mid = mid.strip() if isinstance(mid, str) else mid
        lang = lang.strip() if isinstance(lang, str) else lang
        if not mid or not lang:
            bad.append({"라인": ln, "사유": "msg_id 또는 lang_cd 공란",
                        "원문": json.dumps(it, ensure_ascii=False)[:200]})
            continue
        key = (mid, str(lang).upper())
        if key in recs:
            bad.append({"라인": ln, "사유": f"키 중복 — 뒤 행으로 덮어씀 {key}",
                        "원문": json.dumps(it, ensure_ascii=False)[:200]})
        recs[key] = {
            "MSG_ID": mid, "LANG_CD": str(lang).upper(),
            "MSG_NM": m.get("MSG_NM"), "MSG_DESC": m.get("MSG_DESC"),
            "MSG_TP_CD": (m.get("MSG_TP_CD")
                          or re.match(r"^[A-Za-z]+", mid).group(0)[:3].upper()),
            "USE_YN": str(m.get("USE_YN") or "Y").upper()[:1],
        }
    meta = {"파일": str(path), "인코딩": enc, "형식": f"JSON ({shape})",
            "원본 items": len(items), "적재행": len(recs), "이상행": len(bad),
            "컬럼": ",".join(sorted({f for it in items[:50] if isinstance(it, dict)
                                     for f in [HEADER_ALIAS.get(_norm_key(k)) for k in it]
                                     if f}))}
    return recs, bad, meta


def load_cloud_export(path):
    raw = Path(path).read_bytes()
    text, enc = None, None
    for e in ("utf-8-sig", "utf-8", "cp949", "euc-kr"):
        try:
            text, enc = raw.decode(e), e
            break
        except UnicodeDecodeError:
            continue
    if text is None:
        raise SystemExit(f"인코딩을 판별하지 못했습니다: {path}")

    if text.lstrip()[:1] in ("{", "["):                  # JSON 계열
        return load_json_export(text, path, enc)

    sample = "\n".join(text.splitlines()[:20])
    try:
        dialect = csv.Sniffer().sniff(sample, delimiters=",\t|;")
        delim = dialect.delimiter
    except csv.Error:
        delim = max(",\t|;", key=lambda d: sample.count(d))

    rdr = csv.reader(io.StringIO(text), delimiter=delim)
    rows = list(rdr)
    if not rows:
        raise SystemExit(f"빈 파일입니다: {path}")

    head = [HEADER_ALIAS.get(re.sub(r"[^0-9a-z_]", "", (h or "").strip().lower()), None)
            for h in rows[0]]
    if "MSG_ID" in head and "LANG_CD" in head:
        idx = {f: head.index(f) for f in FIELDS if f in head}
        body, has_header = rows[1:], True
    else:                                        # 헤더 없는 덤프 = 테이블 컬럼 순서로 간주
        idx = {f: i for i, f in enumerate(FIELDS)}
        body, has_header = rows, False

    recs, bad = {}, []
    for ln, r in enumerate(body, start=2 if has_header else 1):
        if not r or all(not (c or "").strip() for c in r):
            continue

        def g(f, default=None, keep_ws=True):
            """값은 **원문 그대로** 둔다.
            .strip() 하면 사내 원장에 실재하는 뒤 공백(예: MNU00185 'Biz Plan Price ')과
            어긋나 '없는 명칭 차이'를 만들어내고, 그 차이가 신규 코드 채번까지 유발한다.
            (2026-08-21 자체검증에서 실제로 MNU01001 이 공백 1개 때문에 채번됨)
            키 컬럼(MSG_ID/LANG_CD)만 예외적으로 트림한다."""
            i = idx.get(f)
            if i is None or i >= len(r):
                return default
            v = r[i]
            if isinstance(v, str) and not keep_ws:
                v = v.strip()
            return None if v in ("", "\\N", "NULL", "(null)") else v

        mid, lang = g("MSG_ID", keep_ws=False), g("LANG_CD", keep_ws=False)
        if not mid or not lang:
            bad.append({"라인": ln, "사유": "MSG_ID 또는 LANG_CD 공란", "원문": delim.join(r)[:200]})
            continue
        recs[(mid, lang.upper())] = {
            "MSG_ID": mid, "LANG_CD": lang.upper(), "MSG_NM": g("MSG_NM"),
            "MSG_DESC": g("MSG_DESC"),
            "MSG_TP_CD": (g("MSG_TP_CD", keep_ws=False)
                          or (re.match(r"^[A-Za-z]+", mid).group(0)[:3].upper())),
            "USE_YN": (g("USE_YN", keep_ws=False) or "Y").upper()[:1],
        }
    meta = {"파일": str(path), "인코딩": enc, "구분자": repr(delim), "헤더": has_header,
            "적재행": len(recs), "이상행": len(bad),
            "컬럼": ",".join(f for f in FIELDS if f in idx)}
    return recs, bad, meta


# ---------------------------------------------------------------------------
# 사내 DB
# ---------------------------------------------------------------------------
def ws_norm(s):
    """앞뒤·연속 공백만 정규화 — 의미 비교용."""
    return " ".join((s or "").split())


def punc_norm(s):
    """공백·구두점·대소문자를 모두 지운 형태 — 표기 차이 판별용."""
    return re.sub(r"[\s\W_]+", "", unicodedata.normalize("NFKC", s or "")).casefold()


HANGUL_RE = re.compile(r"[가-힣]")


def diff_kind(lang, old, new, corp, cloud, code):
    """명칭 차이 1건의 성격을 가른다.

    실측(2026-08-21 클라우드 파일) 결과 27개 차이 코드 중 의미가 실제로 바뀐 것은 일부였고,
    나머지는 구두점·번역채움·언어퇴행이었다. 이것들까지 '의미 변경' 으로 보면
    쓸데없이 코드를 채번하고 UI 를 고치게 된다.
    """
    if ws_norm(old) == ws_norm(new):
        return "공백차이"
    if punc_norm(old) == punc_norm(new):
        return "표기차이"                       # 예: 'Model/Nickname' -> 'Model/ Nickname'
    if lang in ("EN", "CN") and HANGUL_RE.search(new or "") and not HANGUL_RE.search(old or ""):
        return "언어퇴행"                       # 클라우드 EN/CN 칸에 한글 — 사내 번역이 더 낫다
    others = [corp[(code, l)]["MSG_NM"] for l in LANGS if l != lang and (code, l) in corp]
    other_unchanged = all((corp[(code, l)]["MSG_NM"] or "") == (cloud[(code, l)]["MSG_NM"] or "")
                          for l in LANGS if l != lang and (code, l) in corp and (code, l) in cloud)
    if any(punc_norm(old) == punc_norm(x) for x in others) and other_unchanged:
        return "번역채움"                       # 예: KO 칸에 영문이 있었는데 한국어로 채워짐
    return "의미변경"


def _ora():
    spec = importlib.util.spec_from_file_location("ora_helper", ORA_PY)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    import oracledb
    u, p, d = mod.conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def load_corp():
    with _ora() as con, con.cursor() as cur:
        cur.execute("SELECT MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN "
                    "FROM SCM_MGR.SCM_ADM_MSG_M")
        return {(r[0], r[1]): dict(zip(FIELDS, r)) for r in cur.fetchall()}


def load_corp_meta_usage():
    """사내 메타에서 MSG 코드를 쓰는 3축 (컬럼명 실측 확인 완료).

    ⚠ LOOKUP.SEGMENT2 는 MSG 코드 전용 컬럼이 아니라 임의 값이 들어간다.
       거르지 않으면 코드 6,772종으로 부풀어(실제 코드는 917종) '사용중' 판정이 오염된다.
       -> 세 축 모두 SCM_ADM_MSG_M 에 실재하는 코드만 인정한다.
    """
    sql = """
      WITH VALID AS (SELECT DISTINCT MSG_ID FROM SCM_MGR.SCM_ADM_MSG_M)
      SELECT 'MNU_M' AXIS, M.MNU_MSG_ID CODE, M.MNU_ID REF
        FROM SCM_MGR.SCM_ADM_MNU_M M JOIN VALID V ON M.MNU_MSG_ID = V.MSG_ID
      UNION ALL
      SELECT 'API_M', A.API_MSG_ID, A.API_ID
        FROM SCM_MGR.SCM_ADM_API_M A JOIN VALID V ON A.API_MSG_ID = V.MSG_ID
      UNION ALL
      SELECT 'LOOKUP', L.SEGMENT2, L.LOOKUP_TYPE || '|' || L.SEGMENT1
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L JOIN VALID V ON L.SEGMENT2 = V.MSG_ID
    """
    out = defaultdict(list)
    with _ora() as con, con.cursor() as cur:
        cur.execute(sql)
        for axis, code, ref in cur.fetchall():
            out[code].append((axis, ref))
    return out


# ---------------------------------------------------------------------------
# 소스 스캔
# ---------------------------------------------------------------------------
def _rg(pattern_args, only_matching=True):
    cmd = ["rg", "-n", "--no-heading", "-H", "--no-messages"] + (["-o"] if only_matching else [])
    for g in SCAN_GLOBS:
        cmd += ["-g", g]
    for g in SCAN_EXCLUDE:
        cmd += ["-g", g]
    cmd += pattern_args + [r for r in SCAN_ROOTS if (REPO / r).exists()]
    p = subprocess.run(cmd, cwd=REPO, capture_output=True, text=True,
                       encoding="utf-8", errors="replace")
    if p.returncode not in (0, 1):
        print(f"  ! rg 실패(rc={p.returncode}): {p.stderr[:200]}", file=sys.stderr)
    return p.stdout.splitlines()


def build_menu_map():
    m = {}
    for ln in _rg(["-e", r"MENU_ID\s*(:[^=]*)?=\s*['\"][A-Za-z0-9_]+['\"]"]):
        try:
            path, _l, matched = ln.split(":", 2)
        except ValueError:
            continue
        g = MENU_ID_RE.search(matched)
        if g:
            m.setdefault(Path(path).parent.as_posix(), g.group(1))
    return m


def screen_of(path, menu_map):
    p = Path(path).parent
    while len(p.parts) > 1:
        if p.as_posix() in menu_map:
            return menu_map[p.as_posix()]
        p = p.parent
    return ""


def scan_source_usage(menu_map):
    """코드 -> [(파일, 라인, 인용여부)]  — 인용(따옴표 안)만 안전 치환 대상."""
    hits = defaultdict(list)
    for ln in _rg(["-e", CODE_TOKEN_RE.pattern], only_matching=False):
        try:
            path, lno, text = ln.split(":", 2)
        except ValueError:
            continue
        for code in set(CODE_TOKEN_RE.findall(text)):
            quoted = any(q + code + q in text for q in ("'", '"', "`"))
            hits[code].append((path.replace("\\", "/"), int(lno), quoted,
                               screen_of(path, menu_map)))
    return hits


# ---------------------------------------------------------------------------
# 채번
# ---------------------------------------------------------------------------
def band_max(prefix, code_iterables):
    best = BAND_LO - 1
    for codes in code_iterables:
        for c in codes:
            m = NUMBERED_RE.match(c)
            if m and m.group(1) == prefix:
                n = int(m.group(2))
                if BAND_LO <= n <= BAND_HI and n > best:      # 대역 밖 이상치 배제
                    best = n
    return best


class Allocator:
    def __init__(self, corp_codes, cloud_codes):
        self.pools = {}
        self.sources = (corp_codes, cloud_codes)
        self.issued = []

    def next(self, prefix):
        if prefix not in self.pools:
            self.pools[prefix] = band_max(prefix, list(self.sources) + [set(self.issued)])
        self.pools[prefix] += 1
        code = f"{prefix}{self.pools[prefix]:05d}"
        self.issued.append(code)
        return code


# ---------------------------------------------------------------------------
# SQL 생성 헬퍼
# ---------------------------------------------------------------------------
def q(v):
    if v is None:
        return "NULL"
    return "'" + str(v).replace("'", "''").replace("\r", "' || CHR(13) || '") \
                       .replace("\n", "' || CHR(10) || '") + "'"


def _meta_upd(axis, ref, set_val, where_val):
    """메타 3축 공용 UPDATE 생성기 (SET/WHERE 값을 인자로 받아 2단계 치환에도 쓴다)."""
    aud = f"LAST_UPDATED_BY = {q(AUDIT_BY)}, LAST_UPDATE_DATE = SYSDATE"
    if axis == "MNU_M":
        return (f"UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_MSG_ID = {q(set_val)}, {aud} "
                f"WHERE MNU_ID = {q(ref)} AND MNU_MSG_ID = {q(where_val)};")
    if axis == "API_M":
        return (f"UPDATE SCM_MGR.SCM_ADM_API_M SET API_MSG_ID = {q(set_val)}, {aud} "
                f"WHERE API_ID = {q(ref)} AND API_MSG_ID = {q(where_val)};")
    lt, s1 = ref.split("|", 1)
    return (f"UPDATE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL SET SEGMENT2 = {q(set_val)}, {aud} "
            f"WHERE LOOKUP_TYPE = {q(lt)} AND SEGMENT1 = {q(s1)} AND SEGMENT2 = {q(where_val)};")


def insert_stmt(table, rec):
    return (f"INSERT INTO {table} (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, "
            f"CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n"
            f"     VALUES ({q(rec['MSG_ID'])}, {q(rec['LANG_CD'])}, {q(rec['MSG_NM'])}, "
            f"{q(rec['MSG_DESC'])}, {q(rec['MSG_TP_CD'])}, {q(rec['USE_YN'])}, "
            f"{q(AUDIT_BY)}, SYSDATE, {q(AUDIT_BY)}, SYSDATE);")


def insert_if_absent(table, rec):
    """PK(MSG_ID, LANG_CD) 가 없을 때만 넣는 멱등 INSERT.
    클라우드에 이미 있는 코드를 건드리지 않기 위해 NOT EXISTS 로 가드한다
    (기존 코드 문구 덮어쓰기 금지 규약 — 2026-08-19 확정)."""
    return (f"INSERT INTO {table} (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, "
            f"CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n"
            f"SELECT {q(rec['MSG_ID'])}, {q(rec['LANG_CD'])}, {q(rec['MSG_NM'])}, "
            f"{q(rec['MSG_DESC'])}, {q(rec['MSG_TP_CD'])}, {q(rec['USE_YN'])}, "
            f"{q(AUDIT_BY)}, SYSDATE, {q(AUDIT_BY)}, SYSDATE\n"
            f"  FROM DUAL\n"
            f" WHERE NOT EXISTS (SELECT 1 FROM {table} T\n"
            f"                    WHERE T.MSG_ID = {q(rec['MSG_ID'])} "
            f"AND T.LANG_CD = {q(rec['LANG_CD'])});")


# ---------------------------------------------------------------------------
# 본체
# ---------------------------------------------------------------------------
def build_plan(cloud, corp, src_usage, meta_usage, args):
    allow_lang_reg = bool(getattr(args, 'allow_lang_regression', False))
    corp_codes = {k[0] for k in corp}
    cloud_codes = {k[0] for k in cloud}
    alloc = Allocator(corp_codes, cloud_codes)

    # 클라우드 명칭 -> 코드 역인덱스 (C-1 탐색용)
    cloud_by_name = defaultdict(set)
    for (mid, lg), r in cloud.items():
        if r["MSG_NM"]:
            cloud_by_name[(lg, " ".join(r["MSG_NM"].split()))].add(mid)

    name_diff, cloud_only, corp_only, remaps, new_codes = [], [], [], [], []

    # --- A/C : 코드 단위로 본다 (명칭 상이가 한 언어라도 있으면 그 코드는 검토 대상)
    for code in sorted(corp_codes & cloud_codes):
        # 차이를 성격별로 가른다. **의미변경만** UI 치환·신규 채번의 대상이다.
        buckets = defaultdict(list)
        for lg in LANGS:
            c, p = cloud.get((code, lg)), corp.get((code, lg))
            if not (c and p):
                continue
            cn, pn = c["MSG_NM"] or "", p["MSG_NM"] or ""
            if cn == pn:
                continue
            buckets[diff_kind(lg, p["MSG_NM"], c["MSG_NM"], corp, cloud, code)].append(
                (lg, p["MSG_NM"], c["MSG_NM"]))
        if not buckets:
            continue
        diffs = buckets["의미변경"]

        src = [h for h in src_usage.get(code, [])]
        mta = meta_usage.get(code, [])
        used = bool(diffs) and (bool(src) or bool(mta))

        # C-1 : 옛 사내 명칭을 그대로 가진 클라우드 코드 탐색
        target, quality = None, ""
        if used:
            cand = None
            for lg, old_nm, _new in diffs:
                if not old_nm:
                    continue
                hits = cloud_by_name.get((lg, " ".join(old_nm.split())), set()) - {code}
                cand = hits if cand is None else (cand & hits)
            if cand:
                target = sorted(cand)[0]
                quality = f"전언어 일치(후보 {len(cand)}개)"
            else:                                   # 언어별 부분 일치 재시도 (KO 우선)
                for lg in ("KO", "EN", "CN"):
                    old = next((o for g_, o, _n in diffs if g_ == lg), None)
                    if not old:
                        continue
                    hits = cloud_by_name.get((lg, " ".join(old.split())), set()) - {code}
                    if hits:
                        target, quality = sorted(hits)[0], f"{lg} 부분 일치"
                        break

        # C-2 : 없으면 신규 채번 + 사내 INSERT + 클라우드 PUSH
        if used and not target:
            pfx = (NUMBERED_RE.match(code).group(1) if NUMBERED_RE.match(code)
                   else re.match(r"^[A-Za-z]+", code).group(0)[:3].upper())
            target, quality = alloc.next(pfx), "신규 채번"
            for lg in LANGS:
                p = corp.get((code, lg))
                if not p:
                    continue
                new_codes.append({"MSG_ID": target, "LANG_CD": lg, "MSG_NM": p["MSG_NM"],
                                  "MSG_DESC": p["MSG_DESC"], "MSG_TP_CD": p["MSG_TP_CD"],
                                  "USE_YN": p["USE_YN"], "유래": f"{code} 의 사내 옛 명칭 보존"})

        ACT_BY_KIND = {
            "공백차이": "명칭 UPDATE 만 (앞뒤 공백 — 의미 동일)",
            "표기차이": "명칭 UPDATE 만 (구두점·간격 — 의미 동일)",
            "번역채움": "명칭 UPDATE 만 (해당 언어 번역이 채워짐 — 의미 동일)",
            "언어퇴행": ("클라우드 기준 UPDATE (EN/CN 에 한글 유입 — 사용자 승인)" if allow_lang_reg
                     else "⛔ UPDATE 제외 (클라우드 EN/CN 에 한글 — 사내 값이 더 정확)"),
        }
        for kind, bucket in buckets.items():
            for lg, old_nm, new_nm in bucket:
                if kind != "의미변경":
                    act = ACT_BY_KIND[kind]
                elif not used:
                    act = "명칭 UPDATE 만 (사내 사용처 없음)"
                else:
                    act = f"명칭 UPDATE + UI 를 {target} 로 치환"
                name_diff.append({
                    "구분": kind, "MSG_ID": code, "LANG_CD": lg,
                    "사내_명칭(옛)": old_nm, "클라우드_명칭(새)": new_nm,
                    "UPDATE": ("적용" if (kind != "언어퇴행" or allow_lang_reg) else "제외"),
                    "사내사용": "사용중" if (bool(src) or bool(mta)) else "미사용",
                    "소스사용처": len(src), "메타사용처": len(mta),
                    "화면ID": ",".join(sorted({s[3] for s in src if s[3]})) or "",
                    "치환대상코드": (target or "") if kind == "의미변경" else "",
                    "치환근거": quality if kind == "의미변경" else "",
                    "조치": act,
                })

        if used and target:
            remaps.append({"옛코드": code, "새코드": target, "근거": quality,
                           "소스": src, "메타": mta})

    # --- B : 사내에 없는 코드 = 신규 INSERT
    for k in sorted(set(cloud) - set(corp)):
        cloud_only.append(cloud[k])
    for k in sorted(set(corp) - set(cloud)):
        r = dict(corp[k])
        r["비고"] = "사내 단독 — 이번 동기화 대상 아님(삭제하지 않음)"
        corp_only.append(r)

    return {"name_diff": name_diff, "cloud_only": cloud_only, "corp_only": corp_only,
            "remaps": remaps, "new_codes": new_codes}


def emit_sql(plan, outdir, cloud, corp):
    T = "SCM_MGR.SCM_ADM_MSG_M"
    # ---- 10_CORP_APPLY.sql
    L = ["-- 10_CORP_APPLY.sql : 사내 오라클을 클라우드 기준으로 맞춘다 (자동생성)",
         "--   1) 명칭 상이 -> UPDATE   2) 사내 미보유 -> INSERT   3) 옛 명칭 보존용 신규 채번 -> INSERT",
         "--   ※ 사내 단독 보유 행은 삭제하지 않는다.", "SET DEFINE OFF", ""]
    upd = 0
    L.append("-- [1] 명칭 상이 -> 클라우드 기준으로 UPDATE ------------------------------")
    for r in plan["name_diff"]:
        if r.get("UPDATE") == "제외":            # 언어퇴행 — 사내 값을 지킨다
            continue
        c = cloud.get((r["MSG_ID"], r["LANG_CD"]))
        if not c:
            continue
        L.append(f"UPDATE {T} SET MSG_NM = {q(c['MSG_NM'])}, LAST_UPDATED_BY = {q(AUDIT_BY)}, "
                 f"LAST_UPDATE_DATE = SYSDATE\n WHERE MSG_ID = {q(r['MSG_ID'])} "
                 f"AND LANG_CD = {q(r['LANG_CD'])};")
        upd += 1
    L += ["", "-- [2] 사내 미보유 코드 -> INSERT ----------------------------------------"]
    for r in plan["cloud_only"]:
        L.append(insert_stmt(T, r))
    L += ["", "-- [3] 옛 사내 명칭 보존용 신규 채번 -> INSERT ---------------------------"]
    for r in plan["new_codes"]:
        L.append(f"-- {r['유래']}")
        L.append(insert_stmt(T, r))
    n10 = upd + len(plan["cloud_only"]) + len(plan["new_codes"])
    L += ["", "COMMIT;",
          f"-- 요약 : UPDATE {upd} / INSERT(신규유입) {len(plan['cloud_only'])} "
          f"/ INSERT(신규채번) {len(plan['new_codes'])}",
          f"-- STMT_COUNT: {n10}"]
    (outdir / "10_CORP_APPLY.sql").write_text("\n".join(L) + "\n", encoding="utf-8")

    # ---- 09_ROLLBACK_CORP.sql (적용 전 상태로 되돌리는 스크립트)
    R = ["-- 09_ROLLBACK_CORP.sql : 10/20 적용분을 되돌린다 (자동생성)",
         "--   실행 순서 = 메타 되돌리기 -> 신규행 삭제 -> 명칭 원복",
         "--   ⚠ 적용 후 사람이 추가로 손댄 변경까지 되돌리지는 않는다.",
         "SET DEFINE OFF", ""]
    rn = 0
    if plan["remaps"]:
        R.append("-- [1] 메타 코드 되돌리기 (2단계)")
        jobs_r = [(axis, ref, rm["옛코드"], rm["새코드"])
                  for rm in plan["remaps"] for axis, ref in rm["메타"]]
        for i, (axis, ref, old, _new) in enumerate(jobs_r, 1):
            R.append(_meta_upd(axis, ref, f"#R{i:04d}", _new))
            rn += 1
        for i, (axis, ref, old, _new) in enumerate(jobs_r, 1):
            R.append(_meta_upd(axis, ref, old, f"#R{i:04d}"))
            rn += 1
    R.append("")
    R.append("-- [2] 이번에 들어간 신규 행 삭제 (신규유입 + 신규채번)")
    for r in plan["cloud_only"] + plan["new_codes"]:
        R.append(f"DELETE FROM {T} WHERE MSG_ID = {q(r['MSG_ID'])} AND LANG_CD = {q(r['LANG_CD'])};")
        rn += 1
    R.append("")
    R.append("-- [3] 명칭 원복 (적용 직전 사내 값)")
    for r in plan["name_diff"]:
        if r.get("UPDATE") == "제외":
            continue
        p = corp.get((r["MSG_ID"], r["LANG_CD"]))
        if not p:
            continue
        R.append(f"UPDATE {T} SET MSG_NM = {q(p['MSG_NM'])}, LAST_UPDATED_BY = {q(AUDIT_BY)}, "
                 f"LAST_UPDATE_DATE = SYSDATE\n WHERE MSG_ID = {q(r['MSG_ID'])} "
                 f"AND LANG_CD = {q(r['LANG_CD'])};")
        rn += 1
    R += ["", "COMMIT;", f"-- STMT_COUNT: {rn}"]
    (outdir / "09_ROLLBACK_CORP.sql").write_text("\n".join(R) + "\n", encoding="utf-8")

    # ---- 20_CORP_META_REMAP.sql
    M = ["-- 20_CORP_META_REMAP.sql : 사내 메타의 코드 참조를 새 코드로 치환 (자동생성)",
         "--",
         "-- ⚠ 2단계(임시 센티널 경유)로 쓴다. 치환에 연쇄·순환이 있기 때문이다.",
         "--    (실측: MSG00711 <-> MSG00712 상호 교환 등 5건)",
         "--    1단계로 바로 최종값을 쓰면, 뒤 UPDATE 의 WHERE 가 앞서 바뀐 행을 다시 잡아 되돌린다.",
         "--    SCM_ADM_MSG_M 을 참조하는 FK 는 없음(실측) -> 임시값 사용 안전.",
         "SET DEFINE OFF", ""]
    jobs = [(axis, ref, rm["옛코드"], rm["새코드"])
            for rm in plan["remaps"] for axis, ref in rm["메타"]]
    n = 0
    if jobs:
        M.append("-- [1단계] 옛 코드 -> 임시 센티널")
        for i, (axis, ref, old, _new) in enumerate(jobs, 1):
            M.append(_meta_upd(axis, ref, f"#T{i:04d}", old))
            n += 1
        M += ["", "-- [2단계] 임시 센티널 -> 새 코드"]
        for i, (axis, ref, _old, new) in enumerate(jobs, 1):
            M.append(_meta_upd(axis, ref, new, f"#T{i:04d}"))
            n += 1
    M += ["", "COMMIT;",
          f"-- 요약 : 메타 치환 {len(jobs)}건 (2단계 = 문장 {n})", f"-- STMT_COUNT: {n}"]
    (outdir / "20_CORP_META_REMAP.sql").write_text("\n".join(M) + "\n", encoding="utf-8")

    # ---- 30_CLOUD_PUSH.sql
    # 클라우드에 없는 사내 행 전량 = 신규 채번분 + 사내 단독 보유분
    push, seen_push = [], set()
    for r in plan["new_codes"] + plan["corp_only"]:
        k = (r["MSG_ID"], r["LANG_CD"])
        if k not in seen_push:
            seen_push.add(k)
            push.append(r)
    C = ["-- 30_CLOUD_PUSH.sql : 클라우드에 없는 사내 행을 **클라우드에** 생성 (자동생성)",
         "--   실행 위치 = 클라우드 DB",
         "--   대상 = ① 사내에서 신규 채번한 코드  ② 사내 단독 보유 코드",
         "--   ⚠ 전부 NOT EXISTS(PK = MSG_ID + LANG_CD) 가드 -> 이미 있는 행은 건너뛴다.",
         "--      기존 코드의 문구를 덮어쓰지 않으므로 재실행해도 안전(멱등).",
         f"--   구성 = 신규채번 {len(plan['new_codes'])}행 + 사내단독 "
         f"{len([r for r in push if r not in plan['new_codes']])}행 = 총 {len(push)}행",
         "--   ※ 이미 사내 적용을 마친 뒤 재생성하면 신규채번분은 '사내단독' 에 흡수되어 [1] 이 0 이 된다.",
         "--     그래도 [2] 에 전량 포함되므로 이 파일 하나면 충분하다.",
         "SET DEFINE OFF", "",
         f"-- [1] 신규 채번 {len(plan['new_codes'])}행 -------------------------------------"]
    for r in plan["new_codes"]:
        C.append(insert_if_absent(T, r))
    only = [r for r in push if r not in plan["new_codes"]]
    C += ["", f"-- [2] 사내 단독 보유 {len(only)}행 --------------------------------------"]
    for r in only:
        C.append(insert_if_absent(T, r))
    C += ["", "COMMIT;",
          f"-- 요약 : 클라우드 INSERT 후보 {len(push)}건 "
          f"(신규채번 {len(plan['new_codes'])} + 사내단독 {len(only)})",
          f"-- STMT_COUNT: {len(push)}"]
    (outdir / "30_CLOUD_PUSH.sql").write_text("\n".join(C) + "\n", encoding="utf-8")
    return upd


def emit_ui_remap(plan, outdir):
    lines = ["# FE 소스 코드 치환 목록 (자동생성)", "",
             "옛 코드는 클라우드 기준으로 **다른 명칭**이 된다. 그 코드를 쓰던 화면이 옛 의미를",
             "유지하도록 아래대로 코드를 바꾼다. `인용`=따옴표 리터럴(안전 치환 대상),",
             "`비인용`=주석·식별자 등(자동 치환 제외 — 사람이 판단)", ""]
    total_q = total_u = 0
    for rm in plan["remaps"]:
        qs = [s for s in rm["소스"] if s[2]]
        us = [s for s in rm["소스"] if not s[2]]
        total_q += len(qs)
        total_u += len(us)
        lines += [f"## `{rm['옛코드']}` → `{rm['새코드']}`  ({rm['근거']})", ""]
        if rm["메타"]:
            lines.append("- 사내 메타: " + ", ".join(f"{a}:{r}" for a, r in rm["메타"]))
        for f, l, _qd, scr in qs:
            lines.append(f"- [인용] {f}:{l}" + (f"  (화면 {scr})" if scr else ""))
        for f, l, _qd, scr in us:
            lines.append(f"- [비인용] {f}:{l}" + (f"  (화면 {scr})" if scr else ""))
        lines.append("")
    lines += [f"---", f"합계: 인용 {total_q}곳(자동 치환 가능) / 비인용 {total_u}곳(수동 확인)", ""]

    # ⭐ 문서·주석 스윕 대상 (hook #140 §A-4)
    #   자동 치환은 따옴표 리터럴만 한다. 옛 코드가 룰 문서에 '정본' 으로 박혀 있으면
    #   코드 참조가 0건이어도 다음 작업이 틀린 문구를 띄운다(2026-08-21 MSG00718 실사고).
    olds = sorted({rm["옛코드"] for rm in plan["remaps"]})
    lines += [
        "## ⭐ 문서·주석 스윕 대상 (hook #140 §A-4 — 적용 후 필수)", "",
        "아래 옛 코드가 **룰 문서·소스 주석**에 남아 있는지 확인한다.",
        "룰이 그 코드를 '정본' 으로 지시하고 있으면 **반드시 정정**(기능 영향).",
        "`public/locales/*.json` · `configs/types/generated-keys.d.ts` 히트는 사전 항목이므로 정상.", "",
        "```bash",
        f"rg -n \"{'|'.join(olds)}\" Doc nscm-fe nscm-be" if olds else "rg -n \"<옛코드>\" Doc nscm-fe nscm-be",
        "```", "",
        f"대상 코드 {len(olds)}종: " + (", ".join(f"`{c}`" for c in olds) if olds else "(없음)"),
    ]
    (outdir / "40_UI_REMAP.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    return total_q, total_u


def apply_ui(plan):
    """따옴표 리터럴로 감싸인 코드만, **한 번의 스캔으로 동시에** 치환한다.

    ⚠ 순차 replace 금지. 이번 클라우드 파일에는 MSG00711 <-> MSG00712 처럼 서로 맞바뀐
      치환이 실재한다(연쇄/순환 5건). 순차로 돌리면 두 번째 치환이 첫 번째를 되돌려
      두 코드가 한 값으로 뭉개진다. 그래서 정규식 1패스 동시 치환으로 처리한다.
    """
    per_file = defaultdict(dict)
    for rm in plan["remaps"]:
        for f, _l, quoted, _s in rm["소스"]:
            if quoted:
                per_file[f][rm["옛코드"]] = rm["새코드"]
    changed = 0
    for f, mapping in per_file.items():
        p = REPO / f
        txt = p.read_text(encoding="utf-8")
        pat = re.compile("(['\"`])(" +
                         "|".join(re.escape(k) for k in sorted(mapping, key=len, reverse=True)) +
                         r")\1")
        new_txt = pat.sub(lambda m: f"{m.group(1)}{mapping[m.group(2)]}{m.group(1)}", txt)
        if new_txt != txt:
            p.write_text(new_txt, encoding="utf-8")
            changed += 1
    return changed


STMT_COUNT_RE = re.compile(r"^--\s*STMT_COUNT:\s*(\d+)\s*$", re.M)


def split_sql(text):
    """실행 가능한 문장만 순서대로 돌려준다.

    ⚠ 예전 구현은 `text.split(';\\n')` 로 먼저 쪼갠 뒤 '--' 줄을 지웠다. 그러면
       [헤더주석 + SET DEFINE OFF + 첫 INSERT] 가 한 덩어리가 되고, 그 덩어리가
       'SET DEFINE' 으로 시작한다는 이유로 통째로 스킵돼 **첫 문장이 조용히 누락**됐다
       (2026-08-21 자체검증에서 3건 중 1건 실종). 그래서 주석·지시어를 **먼저** 걷어낸 뒤 쪼갠다.
    """
    lines = []
    for ln in text.splitlines():
        s = ln.strip()
        if not s or s.startswith("--") or s.upper().startswith("SET DEFINE"):
            continue
        lines.append(ln)
    out = []
    for chunk in "\n".join(lines).split(";"):
        body = chunk.strip()
        if body:
            out.append(body)
    return out


def apply_db(outdir, files):
    done = []
    with _ora() as con, con.cursor() as cur:
        for fn in files:
            text = (outdir / fn).read_text(encoding="utf-8")
            stmts = split_sql(text)
            expect = STMT_COUNT_RE.search(text)
            runnable = [s for s in stmts if s.upper() != "COMMIT"]
            if expect and int(expect.group(1)) != len(runnable):
                raise SystemExit(
                    f"[중단] {fn}: 생성 시 기록한 문장 수 {expect.group(1)} != 분해 결과 "
                    f"{len(runnable)}. 조용한 누락 방지를 위해 실행하지 않습니다.")
            affected = 0
            for s in stmts:
                if s.upper() == "COMMIT":
                    con.commit()
                    continue
                cur.execute(s)
                affected += cur.rowcount or 0
            con.commit()
            done.append((fn, len(runnable), affected))
    return done


def emit_report(outdir, plan, meta, bad_rows, counts):
    import openpyxl
    from openpyxl.styles import Font, PatternFill

    wb = openpyxl.Workbook()
    fill, bold = PatternFill("solid", fgColor="DDEBF7"), Font(bold=True)

    def sh(title, cols, rows):
        ws = wb.create_sheet(title)
        ws.append(cols)
        for c in ws[1]:
            c.fill, c.font = fill, bold
        for r in rows:
            ws.append([r.get(c, "") for c in cols])
        ws.freeze_panes = "A2"
        for i, c in enumerate(cols, 1):
            w = max([len(str(c))] + [len(str(r.get(c, ""))[:60]) for r in rows]) if rows else len(str(c))
            ws.column_dimensions[openpyxl.utils.get_column_letter(i)].width = min(max(w + 2, 10), 60)

    ws = wb.active
    ws.title = "0_요약"
    ws.append(["항목", "값"])
    for c in ws[1]:
        c.fill, c.font = fill, bold
    for k, v in meta.items():
        ws.append([f"입력·{k}", v])
    for k, v in counts.items():
        ws.append([k, v])
    ws.column_dimensions["A"].width, ws.column_dimensions["B"].width = 34, 70

    sh("1_명칭상이", ["구분", "MSG_ID", "LANG_CD", "사내_명칭(옛)", "클라우드_명칭(새)", "UPDATE", "사내사용",
                  "소스사용처", "메타사용처", "화면ID", "치환대상코드", "치환근거", "조치"],
       plan["name_diff"])
    sh("2_신규유입", list(FIELDS), plan["cloud_only"])
    sh("3_신규채번", ["MSG_ID", "LANG_CD", "MSG_NM", "MSG_TP_CD", "USE_YN", "유래"], plan["new_codes"])
    sh("4_UI치환", ["옛코드", "새코드", "근거", "소스건수", "메타건수"],
       [{"옛코드": r["옛코드"], "새코드": r["새코드"], "근거": r["근거"],
         "소스건수": len(r["소스"]), "메타건수": len(r["메타"])} for r in plan["remaps"]])
    sh("5_사내단독", list(FIELDS) + ["비고"], plan["corp_only"])
    sh("6_입력이상행", ["라인", "사유", "원문"], bad_rows)
    wb.save(outdir / "00_REPORT.xlsx")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cloud_file", help="클라우드 MSG 추출본 (CSV/TSV/파이프, 헤더 유무 무관)")
    ap.add_argument("-o", "--out", default=None, help="산출 폴더 (기본: ./out_<입력파일명>)")
    ap.add_argument("--apply-db", action="store_true", help="사내 DB 에 10/20 SQL 실제 실행")
    ap.add_argument("--apply-ui", action="store_true", help="FE 소스 코드 치환 실제 적용")
    ap.add_argument("--allow-lang-regression", action="store_true",
                    help="클라우드 EN/CN 에 한글이 들어온 행(언어퇴행)도 그대로 UPDATE 한다 "
                         "(기본은 사내 번역 보존을 위해 제외)")
    a = ap.parse_args()

    outdir = Path(a.out) if a.out else HERE / ("out_" + Path(a.cloud_file).stem)
    outdir.mkdir(parents=True, exist_ok=True)

    cloud, bad, meta = load_cloud_export(a.cloud_file)
    detail = " · ".join(f"{k} {v}" for k, v in meta.items()
                        if k not in ("파일", "적재행", "이상행"))
    print(f"[입력] {meta['적재행']}행 적재 / 이상 {meta['이상행']}행  ({detail})")
    corp = load_corp()
    print(f"[사내] {len(corp)}행")

    menu_map = build_menu_map()
    src_usage = scan_source_usage(menu_map)
    meta_usage = load_corp_meta_usage()
    print(f"[스캔] 소스 코드 {len(src_usage)}종 / 메타 코드 {len(meta_usage)}종 / 화면매핑 {len(menu_map)}폴더")

    plan = build_plan(cloud, corp, src_usage, meta_usage, a)
    upd = emit_sql(plan, outdir, cloud, corp)
    tq, tu = emit_ui_remap(plan, outdir)

    counts = {
        "A. 명칭 상이 (UPDATE 대상)": len(plan["name_diff"]),
        "B. 사내 미보유 (INSERT 대상)": len(plan["cloud_only"]),
        "C. UI 치환 필요 코드": len(plan["remaps"]),
        "C-2. 신규 채번 행": len(plan["new_codes"]),
        "  └ 신규 채번 코드": ",".join(sorted({r["MSG_ID"] for r in plan["new_codes"]})) or "(없음)",
        "FE 치환 — 인용(자동 가능)": tq,
        "FE 치환 — 비인용(수동)": tu,
        "사내 단독 (미대상)": len(plan["corp_only"]),
    }
    emit_report(outdir, plan, meta, bad, counts)
    for k, v in counts.items():
        print(f"  {k}: {v}")

    if a.apply_ui:
        n = apply_ui(plan)
        print(f"[적용] FE 소스 {n}파일 치환 완료")
    if a.apply_db:
        for fn, cnt, aff in apply_db(outdir, ["10_CORP_APPLY.sql", "20_CORP_META_REMAP.sql"]):
            print(f"[적용] {fn} 실행 완료 (문장 {cnt} / 영향 행 {aff})")

    print(f"\n산출: {outdir}")
    if not (a.apply_db or a.apply_ui):
        print("  (생성만 함 — 실제 적용은 --apply-db / --apply-ui)")


if __name__ == "__main__":
    main()
