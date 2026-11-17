# -*- coding: utf-8 -*-
"""asis_live_proof_answers.py — 런처 몫 미증명 항목(_proof_live_targets.csv)마다 AS-IS 런처 실행 결과(정답)가 있는지 연결한다 (2026-11-15, 27화면 미검증·미판단 0 작업)

입력  Doc/asislive/_proof_live_targets.csv (asis_live_proof_targets.py 출력)
      Doc/asislive/<ID>/run_*_acts_*/acts.json (asis_live_scen_run.py --states · --pick · --insert · --violate · --cells · 버튼 실행)
      Doc/asislive/<ID>/run_*/grids.json (기본 실행 덤프) · overlap.json 있는 폴더는 뺀다(다른 화면 실행과 겹친 기록)
출력  Doc/asislive/_proof_live_answers.csv  (화면 × 사유 종류: 건수 · 정답 상태 · 근거 폴더 · 관찰 요약)
상태  정답 있음        = 그 종류에 맞는 실행을 했고 관찰값이 있음(잠금·색, 팝업 고른 뒤 바뀐 셀, 늘어난 행, 검증 메시지, 호출 SP)
      실행·관찰 없음   = 실행했으나 관찰값이 없음(팝업이 안 열림, 행이 안 늘어남 등). 그 자체가 AS-IS 사실이므로 근거로 남긴다
      미실행          = 맞는 실행 기록 없음
한계  화면 단위로 연결한다. 검사 단위 1건과 셀·열 1개를 짝짓는 일은 검증 엔진 쪽 입력(asis_live_ingest)에서 한다.

  python tools/AsisLive/asis_live_proof_answers.py [ID …]
"""
import csv, glob, json, os, re, sys, time, collections

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
try: sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception: pass
P = lambda *a: os.path.join(ROOT, *a)

# 사유 종류 → 근거가 되는 실행 종류(acts 폴더 이름 끝)
NEED = {
    "편집 불가 셀": ["states", "states_edit", "insert", "violate"],
    "행 조건 계산": ["states", "states_edit"],
    "팝업 값 반영": ["pick", "pick_edit", "pickbtn", "pickbtn_edit"],          # 11-15 pickbtn = 버튼·조회 조건 팝업(M4 BTN·COND)
    "팝업 사용처": ["pick", "pick_edit", "cell", "cell_edit", "pickbtn", "pickbtn_edit"],
    "팝업 내부": ["pick", "pick_edit", "pickbtn", "pickbtn_edit"],
    "팝업·셀 이벤트 호출": ["pick", "pick_edit", "cell", "cell_edit", "pickbtn", "pickbtn_edit"],
    "차등 검증 인자": ["pick", "pick_edit", "cell", "cell_edit", "cond", "acts", "pickbtn", "pickbtn_edit"],
    "신규행 전제": ["insert", "violate"],
    "검증 위반 입력": ["violate"],
    "저장 밖 경로 메시지": ["acts", "edit", "cell", "cell_edit", "pick", "pick_edit", "pickbtn", "pickbtn_edit", "event"],   # 11-15 이벤트 분기 메시지(실제 메시지 관찰분만)
    "동작 재현 시나리오": ["acts", "edit", "cell", "cell_edit", "pick", "pick_edit", "pickbtn", "pickbtn_edit", "event"],
    "분기 해석": ["pick_edit", "states_edit", "acts", "edit"],
    "그리드에 없는 컬럼": ["dump"],
    "조건 데이터 없음": ["cond", "pre"],
}


def kind_of(dirname):
    b = os.path.basename(dirname)
    if "_acts" not in b: return "dump"
    t = b.split("_acts", 1)[1].lstrip("_")
    if t == "": return "acts"
    if t.startswith("pre_") or t.startswith("div"): return "pre"
    return t


def observe(k, j):
    """실행 1건의 관찰 요약과 관찰값 유무"""
    acts = j.get("acts") or []
    if k in ("states", "states_edit"):
        st = j.get("cellstate") or {}; sm = j.get("summary") or {}
        if not st: return False, j.get("error") or j.get("note") or "셀 상태 없음"
        return True, "%s행×%s열 잠김 %s 열림 %s · 행마다 잠금 다른 열 %d" % (sm.get("rows"), sm.get("cols"), sm.get("locked_cells"), sm.get("open_cells"), len(sm.get("cols_lock_varies_by_row") or []))
    if k in ("pickbtn", "pickbtn_edit"):
        pops = [a for a in acts if a.get("popup") and a["popup"].get("form")]
        if not acts: return False, j.get("error") or j.get("note") or "실행 없음"
        picked = [a for a in pops if (a.get("pick_act") or {}).get("ok") or a.get("pick_button")]
        return bool(picked), "버튼 %d 중 팝업 %d · 고름 %d · 바뀐 조건 %s" % (len(acts), len(pops), len(picked), ", ".join("%s→%s" % (a["control"], ",".join(x["control"] for x in a.get("cond_changes") or [])[:60] or "-") for a in picked)[:200])
    if k in ("pick", "pick_edit"):
        pops = [a for a in acts if a.get("popup")]; chg = [a for a in pops if a.get("grid_changes")]
        if not acts: return False, j.get("error") or j.get("note") or "실행 없음"
        return bool(pops), "열 %d 중 팝업 %d · 고른 뒤 셀 변화 %d (%s)" % (len(acts), len(pops), len(chg), ", ".join("%s→%s" % (a["control"], a["popup"]["form"]) for a in pops)[:200])
    if k in ("insert", "violate"):
        # 11-15: 수정 모드 뒤 행 추가(insert · after_edit) · 상세 시트 행 추가(insert_detail) 우선, 수정 모드 없이 누른 결과(insert_no_edit)는 참고
        isrc = j.get("insert_src") or {}
        if not isrc and j.get("id"):
            try:
                import asis_live_scen_run as _S; isrc = _S.insert_targets(j["id"])   # 11-15 이전 실행: 원문 분석을 지금 수행
            except Exception: isrc = {}
        ins = [a for a in acts if a.get("kind") in ("insert", "insert_detail")] or [a for a in acts if a.get("kind") == "insert_no_edit"]
        sv = [a for a in acts if a.get("kind") in ("save_violate", "save_violate_detail")]
        if isrc and not isrc.get("exists"):
            return True, "AS-IS 행 추가 기능 없음(%s) · 런처 행 추가 결과 %s" % (isrc.get("evidence"), ({x: len(v) for x, v in (ins[0].get("new_rows") or {}).items()} or 0) if ins else "실행 없음")
        if not ins: return False, j.get("error") or j.get("note") or "실행 없음"
        parts = []
        for a in ins:
            nr = a.get("new_rows") or {}; msg = [d.get("text", "")[:50] for d in a.get("dialogs") or []]
            parts.append("%s늘어난 행 %s · 메시지 %s" % (("%s " % a["target"]) if a.get("target") else "", {x: len(v) for x, v in nr.items()} or 0, msg or 0))
        s = " / ".join(parts)
        for x in sv: s += " · 빈 새 행 저장 메시지 %s · 호출 %s" % ([d.get("text", "")[:50] for d in x.get("dialogs") or []] or 0, x.get("calls") or 0)
        # "수정모드가 아니므로" 만 받은 행 추가 = 실행기가 수정 모드를 켜지 않은 결과(11-15 이전 실행) → 정답 아님
        blocked = lambda a: not a.get("new_rows") and all("수정모드" in (d.get("text") or "") for d in a.get("dialogs") or [])
        ok = any((a.get("new_rows") or a.get("dialogs")) and not blocked(a) for a in ins if a.get("kind") != "insert_no_edit")
        return ok, s
    if k == "dump":
        return True, "기본 실행 덤프"
    n_calls = sum(len(a.get("calls") or []) for a in acts); n_dlg = sum(len(a.get("dialogs") or []) for a in acts); n_pop = sum(len(a.get("popups") or []) for a in acts)
    return bool(acts) and (n_calls + n_dlg + n_pop) > 0, "동작 %d · 호출 %d · 메시지 %d · 팝업 %d" % (len(acts), n_calls, n_dlg, n_pop)


def runs(mid):
    out = collections.defaultdict(list)
    for d in sorted(glob.glob(P("Doc", "asislive", mid, "run_*"))):
        if not os.path.isdir(d) or os.path.exists(os.path.join(d, "overlap.json")): continue
        k = kind_of(d)
        if k == "dump":
            if os.path.exists(os.path.join(d, "grids.json")): out["dump"].append((d, True, "기본 실행 덤프", 0))
            continue
        f = os.path.join(d, "acts.json")
        if not os.path.exists(f): continue
        try: j = json.load(open(f, encoding="utf-8"))
        except Exception: continue
        ok, s = observe(k, j)
        nmsg = sum(len(a.get("dialogs") or []) + sum(len((r or {}).get("dialogs") or []) for r in (a.get("retries") or [])) for a in j.get("acts") or [])
        out[k].append((d, ok, s, nmsg))
    return out


SP_KINDS = {   # 11-16: SP 가 대상인 사유 — 원장 행의 대상 SP 가 런처 실행(기본 실행 포함) 호출 기록에 있으면 그 호출(인자·행 수)이 정답
    "팝업·셀 이벤트 호출": r"진입·조회 중 호출 없음|결과를 반환하지 않음\(팝업·셀 이벤트|팝업 조회 호출 없음",
    "차등 검증 인자": r"파라미터 미정|골든 비교 케이스 없음|SKIP AS-IS",
}


def sp_observed(mid, kind):
    """(관찰 여부, 요약, 근거 폴더) — 원장에서 그 사유인 행의 대상 SP 를 모아 runs 의 calls.json 에서 찾는다. 대상 SP 가 없으면 None"""
    import re, io as _io
    rx = re.compile(SP_KINDS[kind]); f = P("Doc", "verify", mid, "verify_ledger.csv")
    if not os.path.exists(f): return None
    csv.field_size_limit(10 ** 8)
    want = {}
    for r in csv.DictReader(_io.open(f, encoding="utf-8-sig")):
        if (r.get("result") or "") in ("PASS", "FAIL", "NA") or not rx.search(r.get("evidence") or ""): continue
        # 11-16: SP 이름 = 화면ID 꼴 접두(SCP0084_ · SCM0001_ · DM0003_ · UP_) — 대상 열 우선, 없으면 근거 첫 구절. TO-BE 대상(PKG_X.P_NAME)은 P_ 를 떼어 AS-IS 이름으로
        RXSP = re.compile(r"(?<![A-Z0-9_])(?:P_)?((?:[A-Z]{2,4}\d{3,5}[A-Z]?|UP)_[A-Z0-9_]+)(?![a-z])")   # 소문자가 이어지면 클래스 이름(SCM0002_TitleSetForm_Popup)
        sps = set(RXSP.findall(r.get("target") or "")) or set(RXSP.findall((r.get("evidence") or "").split(":")[0]))
        if sps: want[r["row_id"]] = sps
    if not want: return None
    seen = {}
    for d in sorted(glob.glob(P("Doc", "asislive", mid, "run_*"))):
        if not os.path.isdir(d) or os.path.exists(os.path.join(d, "overlap.json")): continue
        cl = []
        for fn in ("calls.json", "acts.json"):                   # acts.json find_calls = 11-16 조회 단계 기록
            fc = os.path.join(d, fn)
            if not os.path.exists(fc): continue
            try: j = json.load(open(fc, encoding="utf-8"))
            except Exception: continue
            cl += (j if isinstance(j, list) else (j.get("calls") or []) if fn == "calls.json" else ((j.get("find_calls") or []) + (j.get("edit_calls") or [])))
        for c in cl:
            sp = str(c.get("sp") or "").split(".")[-1].upper()
            if sp and sp not in seen and (c.get("rows") is not None): seen[sp] = (d, c)
    # 11-16: 원장 근거가 잘린 SP 이름(P_SSP0005_GET …)은 그 화면 SP 이름(골든 파일·golden_cases·호출 기록)에서 앞부분이 같은 이름으로 펼친다.
    #        후보가 여럿이면 후보 전부를 관찰해야 관찰로 본다
    names = set(seen) | {os.path.splitext(os.path.basename(x))[0].upper() for x in glob.glob(P("Doc", "golden", mid, "*.md")) if not os.path.basename(x).startswith("_")}
    fgc = P("Doc", "golden", "golden_cases.csv")
    if os.path.exists(fgc):
        for r in csv.reader(_io.open(fgc, encoding="utf-8-sig")):
            if r and r[0] == mid and len(r) > 3: names.add(r[3].upper())
    try:                                                         # 화면 폴더 원문(주석 제외)의 FoxDataRequest SP 이름 — 잘린 이름 펼침 후보
        import asis_live_scen_run as _S
        fs = _S.screen_src_file(mid)
        if fs:
            for g in glob.glob(os.path.join(os.path.dirname(fs), "**", "*.cs"), recursive=True):
                for q in re.findall(r'FoxDataRequest\(\s*"(?:[A-Za-z]+\.)?([A-Z0-9_]+)"', _S._code_only(_io.open(g, encoding="utf-8-sig", errors="replace").read())): names.add(q.upper())
    except Exception: pass
    def expand(s):
        s = s.upper()
        if s in names: return [s]
        c = sorted(n for n in names if n.startswith(s))
        return c or [s]
    want = {rid: {e for s in sps for e in expand(s)} for rid, sps in want.items()}
    hit = {rid: [s for s in sps if s.upper() in seen] for rid, sps in want.items()}
    hit = {rid: (h if len(h) == len(want[rid]) else []) for rid, h in hit.items()}
    ok = [rid for rid, h in hit.items() if h]
    sps = sorted({s for h in hit.values() for s in h})
    desc = "대상 SP 관찰 행 %d/%d · %s" % (len(ok), len(want), ", ".join("%s(%s · %s행 · %s %s)" % (s, json.dumps(seen[s.upper()][1].get("params") or {}, ensure_ascii=False)[:80], seen[s.upper()][1].get("rows"), os.path.basename(seen[s.upper()][0]), seen[s.upper()][1].get("phase") or "") for s in sps)[:300])
    if len(ok) < len(want): desc += " · 못 본 SP %s" % ",".join(sorted({s for rid, s0 in want.items() if rid not in ok for s in s0 if s.upper() not in seen}))[:600]
    return len(ok) == len(want), desc, (seen[sps[0].upper()][0] if sps else None)


def msg_cover(mid):
    """경로 메시지 실측 대조(_msg_cover.csv, asis_live_msg_cover.py 출력)의 화면별 상태 분포 — 없으면 None"""
    f = P("Doc", "asislive", "_msg_cover.csv")
    if not os.path.exists(f): return None
    c = collections.Counter(r["state"] for r in csv.DictReader(open(f, encoding="utf-8-sig")) if r["menu_id"] == mid)
    return c or None


_MA = {}
def manual_answers():
    if not _MA:
        f = P("Doc", "asislive", "_launcher_manual_answers.csv"); _MA["_"] = {}
        if os.path.exists(f):
            for r in csv.DictReader(open(f, encoding="utf-8-sig")): _MA[(r["menu_id"], r["kind"])] = r
    return _MA


_NT = {}
def not_target():
    if not _NT:
        f = P("Doc", "asislive", "_launcher_not_target.csv"); _NT["_"] = {}
        if os.path.exists(f):
            for r in csv.DictReader(open(f, encoding="utf-8-sig")): _NT[(r["menu_id"], r["kind"])] = r
    return _NT


_UNI = {}
_CLS = {}
RX_SPLIT = re.compile(r'"(?:[A-Za-z]+\.)?((?:[A-Z]{2,4}\d{3,5}[A-Z]?|UP|PR|SCM|PKG)_[A-Z0-9_]*)"')   # 따옴표 안 SP 이름 전부(FoxDataRequest·QueryId·변수 대입·이어 붙이기 앞부분)


def _class_index():
    """GSCM/06.UIL 의 class 선언 → 파일 목록. Doc/asislive/_cache_class_index.json 에 저장(파일 수·최종 수정 시각이 같으면 다시 씀)"""
    if _CLS: return _CLS
    import io as _io
    fs = glob.glob(P("GSCM", "06.UIL", "**", "*.cs"), recursive=True)
    key = "%d:%d" % (len(fs), int(max((os.path.getmtime(x) for x in fs), default=0)))
    fc = P("Doc", "asislive", "_cache_class_index.json")
    try:
        j = json.load(open(fc, encoding="utf-8"))
        if j.get("key") == key: _CLS.update(j["idx"]); return _CLS
    except Exception: pass
    idx = collections.defaultdict(list)
    for g in fs:
        try: c = _io.open(g, encoding="utf-8-sig", errors="replace").read()
        except Exception: continue
        for cl in set(re.findall(r"\bclass\s+(\w+)", c)): idx[cl].append(g)
    _CLS.update(idx)
    try: json.dump({"key": key, "idx": idx}, open(fc, "w", encoding="utf-8"))
    except Exception: pass
    return _CLS


def screen_sp_universe(mid):
    """11-16 AS-IS 화면 경로의 SP 이름 집합 = 화면 폴더 원문 + 그 원문이 new 로 여는 클래스(팝업·폼, class 선언 기준) 원문 · 주석 제외 · 1단계
    이름 끝이 '_' 인 값(이어 붙이기 앞부분)은 접두로 따로 돌려준다 → (이름 집합, 접두 집합) · 원문 없으면 None"""
    import io as _io
    if mid in _UNI: return _UNI[mid]
    try:
        import asis_live_scen_run as _S
    except Exception: return None
    fs = _S.screen_src_file(mid)
    if not fs: _UNI[mid] = None; return None
    names, classes, seen = set(), set(), set()
    def take(g):
        if g in seen: return
        seen.add(g)
        c = _S._code_only(_io.open(g, encoding="utf-8-sig", errors="replace").read())
        names.update(x.upper() for x in RX_SPLIT.findall(c))
        classes.update(re.findall(r"new\s+(?:[\w]+\.)*(\w+)\s*\(", c))
    folder = glob.glob(os.path.join(os.path.dirname(fs), "**", "*.cs"), recursive=True)
    others = {re.match(r"([A-Z]{2,4}\d{4,5}[A-Z]?)_", os.path.basename(x)).group(1) for x in folder if re.match(r"[A-Z]{2,4}\d{4,5}[A-Z]?_", os.path.basename(x))}
    if len(others - {mid}) > 0:                                   # 여러 화면이 같이 있는 공용 프로젝트 폴더(GSCM.SSP.Plan.UIL) → 이 화면 파일만, 팝업은 클래스로 따라감
        folder = [x for x in folder if os.path.basename(x).upper().startswith(mid.upper() + "_")]
    for g in folder: take(g)
    ci = _class_index()
    for cl in list(classes):
        for g in ci.get(cl, []):
            if re.search(r"Popup|PopUp|Form", cl): take(g)
    full = {x for x in names if not x.endswith("_")}; pre = {x for x in names if x.endswith("_")}
    _UNI[mid] = (full, pre)
    return _UNI[mid]


_SU = {}
def sp_unreachable():
    if not _SU:
        f = P("Doc", "asislive", "_sp_unreachable.csv"); _SU["_"] = {}
        if os.path.exists(f):
            for r in csv.DictReader(open(f, encoding="utf-8-sig")): _SU[(r["menu_id"], r["sp"])] = r
    return _SU


def sp_save_only(mid, sp):
    """11-16 실저장 경로 SP 판별: SP 이름이 쓰기 계열이거나, 그 SP 를 요청하는 메서드를 (깊이 3까지 거슬러) 부르는 쪽이 모두 Save 이름 메서드면 근거 문자열, 아니면 None"""
    import re
    if re.search(r"SAVE|DELETE|_DEL_|INSERT|UPDATE|_SET_", sp, re.I) and (mid, sp) in _ROOTS: return "쓰기 SP 이름"
    try:
        import asis_live_scen_run as _S
    except Exception: return None
    fs = _S.screen_src_file(mid)
    if not fs: return None
    t = _S._code_only(open(fs, encoding="utf-8-sig", errors="replace").read())
    fdz = fs[:-3] + ".Designer.cs"                              # 이벤트 연결은 디자이너 파일에도 있다 → 연결 판정용 본문
    tw = t + (chr(10) + _S._code_only(open(fdz, encoding="utf-8-sig", errors="replace").read()) if os.path.exists(fdz) else "")
    names = re.findall(r"(?:override|private|protected|public)[^\n;{]*\b(\w+)\s*\([^)]*\)\s*\{", t)
    bodies = {}
    for n in names:
        b, _l = _S._method_body(t, n)
        if b is not None: bodies[n] = b
    holders = [n for n, b in bodies.items() if sp in b]
    if not holders: return None
    def roots(n, dp, seen):
        if n in seen: return set()
        seen.add(n)
        # 호출 = '이름(' 형태만. 이벤트 연결(+= 이름)은 호출이 아님 → 연결된 처리기는 시작 메서드로 멈춘다
        if re.search(r"(?:\+=\s*(?:new\s+[\w.]+\(\s*)?|new\s+\w*EventHandler\w*\(\s*)(?:this\.)?%s\b" % re.escape(n), tw): return {n}   # += 연결 · new EventHandler(처리기) 전달(SSP0015 TsmNotepad_Click 628행)
        cs = [m for m, b in bodies.items() if m != n and re.search(r"\b%s\s*\(" % re.escape(n), b)]
        if not cs and dp > 0 and not re.search(r"override[^\n;{]*\b%s\s*\(" % re.escape(n), t):
            return set()                                       # 11-16 호출부·이벤트 연결 없고 override 도 아님 = 죽은 코드(GetNewERPInterface 호출 주석) → 시작점 아님
        if not cs or dp >= 3: return {n}
        r = set()
        for c in cs: r |= roots(c, dp + 1, seen)
        return r
    rs = set()
    for h in holders: rs |= roots(h, 0, set())
    _ROOTS[(mid, sp)] = rs
    if re.search(r"SAVE|DELETE|_DEL_|INSERT|UPDATE|_SET_", sp, re.I): return "쓰기 SP 이름"
    if rs and all(re.search(r"save", x, re.I) for x in rs): return "부르는 메서드 %s" % ",".join(sorted(rs))[:120]
    return None


_ROOTS = {}
def sp_decided(mid, sp):
    """11-16 못 본 SP 를 부르는 시작 메서드가 모두 사용자 결정 '실행 안 함' 처리기(Doc/asislive/_user_decisions.csv)면 근거 문자열"""
    if (mid, sp) not in _ROOTS: sp_save_only(mid, sp)
    rs = _ROOTS.get((mid, sp)) or set()
    f = P("Doc", "asislive", "_user_decisions.csv")
    if not rs or not os.path.exists(f): return None
    dec = {r["handler"] for r in csv.DictReader(open(f, encoding="utf-8-sig")) if r["menu_id"] == mid}
    if rs <= dec: return "부르는 처리기 %s = 사용자 결정 실행 안 함" % ",".join(sorted(rs))
    return None


def _excluded():
    try:
        import asis_live_batch as _B; return set(_B.EXCLUDED)
    except Exception: return set()


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]
    src = P("Doc", "asislive", "_proof_live_targets.csv")
    if not os.path.exists(src): print("[ERROR] %s 없음. asis_live_proof_targets.py 먼저" % src); return 3
    agg = collections.Counter()
    for r in csv.DictReader(open(src, encoding="utf-8-sig")):
        if r["owner"] != "런처" or (ids and r["menu_id"] not in ids): continue
        agg[(r["menu_id"], r["kind"])] += int(r["count"] or 0)
    cache = {}; rows = []; tot = collections.Counter()
    for (mid, k), n in sorted(agg.items()):
        if mid not in cache: cache[mid] = runs(mid)
        rr = []; dec_state = None
        for need in NEED.get(k, []): rr += cache[mid].get(need, [])
        good = [x for x in rr if x[1] and (k != "저장 밖 경로 메시지" or (len(x) > 3 and x[3] > 0))]
        if k == "저장 밖 경로 메시지":                        # 11-16: 원장 행 단위 대조(_msg_cover.csv)로 판정 — 미관찰·다른 경로 문구가 0 이어야 끝
            mc = msg_cover(mid)
            if mc:
                left = sum(v for s, v in mc.items() if s in ("미관찰",) or s.startswith("문구 관찰"))
                desc = "경로 메시지 원장 행 %d: %s" % (sum(mc.values()), ", ".join("%s %d" % kv for kv in mc.most_common()))
                fc = P("Doc", "asislive", "_msg_cover.csv")
                # 정답 있음 = 미관찰·다른 경로 0 이고 실측 관찰 1건 이상. 메시지 코드 아님(대상이 MSG 코드가 아닌 원장 행)은 런처로 맞출 문구가 없어 검사기 쪽으로 남긴다
                if left == 0 and mc.get("미실행(실저장 경로)"): good = []; rr = [(fc, False, desc, 0)]; dec_state = "미실행(실저장 경로)"   # 11-16 저장·삭제 SP 뒤 메시지가 남음 → 저장 시험 결정 전
                elif left == 0 and mc.get("실측 관찰") and mc.get("미실행(사용자 결정)"): good = []; rr = [(fc, False, desc, 0)]; dec_state = "미실행(사용자 결정)"
                elif left == 0 and mc.get("실측 관찰"): good = [(fc, True, desc, 1)]
                elif left == 0 and mc.get("미실행(사용자 결정)"): good = []; rr = [(fc, False, desc, 0)]; dec_state = "미실행(사용자 결정)"
                elif left == 0 and mc.get("런처 제외"): good = []; rr = [(fc, False, desc, 0)]
                elif left == 0: good = []; rr = [(fc, False, desc, 0)]; dec_state = "관찰 대상 없음(도달 불가·메시지 코드 아님)"
                else: good = []; rr = rr + [(fc, False, desc, 0)]
        if k in SP_KINDS:                                    # 11-16: 화면 단위 실행 유무 대신 대상 SP 호출 관찰로 판정
            so = sp_observed(mid, k)
            if so is not None:
                ok_, desc, dd = so
                if not ok_ and "못 본 SP" in desc:                # 못 본 SP 가 전부 실저장 경로면 저장 시험 결정 전 미실행
                    miss = [x for x in desc.split("못 본 SP")[-1].strip().split(",") if x]
                    unr = sp_unreachable()                            # 11-16 도달 불가 SP(Doc/asislive/_sp_unreachable.csv) 는 근거와 함께 빼고 판단
                    gone = [x for x in miss if (mid, x) in unr]
                    if gone:
                        desc += " · 도달 불가 SP " + "; ".join("%s(%s)" % (x, unr[(mid, x)]["basis"]) for x in gone)
                        miss = [x for x in miss if x not in gone]
                        if not miss: dec_state = ("미실행(실저장 경로)" if all(unr[(mid, x)]["basis"].startswith("실저장") for x in gone) else "도달 불가(%s)" % unr[(mid, gone[0])]["basis"])
                    uni = screen_sp_universe(mid)                     # 11-16 AS-IS 화면·팝업 원문에 없는 SP(TO-BE 전용 프로시저) → 런처 정답 없음, 검사기 결함 후보
                    inuni = lambda x: uni is None or x.upper() in uni[0] or any(x.upper().startswith(p) for p in uni[1])
                    nouse = [x for x in miss if not inuni(x)]
                    if nouse:
                        desc += " · AS-IS 화면·팝업 원문에 없는 SP " + ",".join(nouse)
                        miss = [x for x in miss if x not in nouse]
                        if not miss: dec_state = "검사기 결함 후보(AS-IS 경로에 없는 SP)"
                    dc = {x: sp_decided(mid, x) for x in miss}         # 사용자 결정 처리기에서만 부르는 SP(SSP0003 승인 경로)는 먼저 뺀다
                    dgone = [x for x in miss if dc[x]]
                    if dgone:
                        desc += " · 사용자 결정 경로 SP " + "; ".join("%s(%s)" % (x, dc[x]) for x in dgone)[:300]
                        miss = [x for x in miss if x not in dgone]
                        if not miss: dec_state = "미실행(사용자 결정)"
                    sv = {x: sp_save_only(mid, x) for x in miss}
                    if miss and gone and all(sv.values()): dec_state = "미실행(실저장 경로)"
                    if miss and all(sv.values()): dec_state = "미실행(실저장 경로)"; desc += " · 실저장 경로 " + "; ".join("%s(%s)" % kv for kv in sv.items())[:300]
                good = [(dd, True, desc, 0)] if ok_ else []
                if not ok_: rr = rr + [(dd or P("Doc", "asislive", mid), False, desc, 0)]
        st = "정답 있음" if good else ("실행·관찰 없음" if rr else "미실행")
        if not good and dec_state: st = dec_state
        ma = manual_answers().get((mid, k))                   # 11-16 메시지·호출이 아닌 관찰(셀 상태 등)로 준 정답 — Doc/asislive/_launcher_manual_answers.csv
        if ma and not good: good = [(P(*ma["run"].split("/")), True, "%s · %s" % (ma["at"], ma["evidence"][:220]), 1)]; st = "정답 있음"
        nt = not_target().get((mid, k))                       # 11-16 런처 대상 아님(검사기 결함 후보 등) — Doc/asislive/_launcher_not_target.csv
        if not good and nt: st = nt["state"]; rr = [(P("Doc", "asislive", "_launcher_not_target.csv"), False, "%s · %s" % (nt["row_ids"], nt["evidence"][:220]), 0)]
        if not good and mid in _excluded():
            st = "런처 제외"; rr = [(P("Doc", "asislive"), False, "런처 대상 아님: asis_live_batch.EXCLUDED(소스 없음·미사용 예정, 사용자 결정 2026-11-12) · 다른 증명 경로 필요", 0)]
        pick = (good or rr)[-1] if rr else None
        rows.append([mid, k, n, st, os.path.relpath(pick[0], ROOT).replace("\\", "/") if pick else "", pick[2] if pick else "", len(rr)])
        tot[st] += n
    out = P("Doc", "asislive", "_proof_live_answers.csv")
    with open(out, "w", encoding="utf-8-sig", newline="") as fo:
        w = csv.writer(fo); w.writerow(["menu_id", "kind", "count", "state", "evidence", "observed", "runs"]); w.writerows(rows)
    print("[실측 %s] 화면 %d · 런처 몫 %d건: %s" % (time.strftime("%Y-%m-%d %H:%M"), len(cache), sum(agg.values()), ", ".join("%s %d" % kv for kv in tot.most_common())))
    bk = collections.defaultdict(collections.Counter)
    for mid, k, n, st, *_ in rows: bk[k][st] += n
    for k in sorted(bk, key=lambda x: -sum(bk[x].values())): print("  %s: %s" % (k, ", ".join("%s %d" % kv for kv in bk[k].most_common())))
    print("@@LINK 📂 런처 정답 연결|%s" % out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
