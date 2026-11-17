# -*- coding: utf-8 -*-
"""AS-IS 실측 2차 — 필수 조회조건을 "가장 최근 값"으로 채운다 (2026-11-12 · 사용자 결정 "최근 값으로 진행")

화면을 연 직후(조회 전)에 불린다. 화면 소스·화면 ID 를 고정해 두지 않고, 그 화면의 컨트롤 덤프(라벨·형식·항목 수)만 보고 규칙을 적용한다.
  규칙 1 (FP 계획): "Plan ID" 콤보가 비어 있으면 → 선택된 Plan Group 의 가장 최근 계획 날짜(AS-IS DB SCM_FP_PLAN_H 조회·읽기 전용)를
                   Plan Date 달력에 넣는다 → 화면이 Plan ID 목록을 다시 불러온다.
  규칙 2 (Division 연동): 필수 콤보·체크 목록이 비어 있고 Division 콤보가 있으면 → Division 을 다른 값으로 바꿨다가 원래 값으로 되돌린다
                   (화면의 변경 이벤트가 목록을 채운다). 그래도 비면 Division 을 차례로 바꿔 목록이 채워지는 첫 Division 을 쓴다.
  규칙 3 (콤보): 항목은 있는데 선택이 없으면 첫 항목(화면이 최근 순으로 정렬해 준 목록의 맨 위)을 고른다.
  규칙 4 (체크 목록): Version 체크 목록에 항목이 있는데 체크가 없으면 첫 항목을 체크한다.
  규칙 5 (Version 입력칸): Version 입력칸(팝업에서 고르는 형식)이 비어 있으면 → 화면의 Version 팝업을 실제로 열어(팝업 기본 조건 그대로)
                   팝업이 보여 주는 목록의 맨 위 행을 선택한다. 고른 값과 위 5행을 기록한다.
채운 내용은 전부 fills 목록으로 돌려준다(run.json·summary.md·_summary.csv 에 기록). 채우지 못한 필수 항목은 left 로 돌려준다(추측해서 넣지 않는다).
"""
import os, re, sys
import asis_live_run as R

KEY = re.compile(r"plan\s*id|plan\s*date|plant\s*date|instance\s*date|version|\bseq\b|plan\s*type|\byear\b|plan\s*group", re.I)
DIV = re.compile(r"^div", re.I)
_FP_DATE = {}
_SKIP = set()                                       # Rel. 체크로 대신한 Plan ID 콤보(더 채우려 하지 않는다)


def state(host):
    d = host.send("dump", timeout=120, rows=-1).get("data") or {}
    lab = {}
    for li in d.get("layout_items") or []:
        if li.get("control"): lab[li["control"]] = (li.get("label") or "").strip()
    out = []
    for c in d.get("controls") or []:
        t = (c.get("type") or "").split(".")[-1]
        if not t.startswith("Usr") or not c.get("visible"): continue
        c = dict(c); c["t"] = t; c["label"] = lab.get(c.get("name"), "")
        out.append(c)
    return out


def raw(host):
    """보이는 컨트롤 전부(Usr 가 아닌 화면 고유 컨트롤 포함)"""
    d = host.send("dump", timeout=120, rows=-1).get("data") or {}
    out = []
    for c in d.get("controls") or []:
        if not c.get("visible"): continue
        c = dict(c); c["t"] = (c.get("type") or "").split(".")[-1]; out.append(c)
    return out


def fp_dates(instance, n=12):
    """그 Plan Group 에 계획이 있는 날짜 — 최근 순 n개 (AS-IS DB 읽기 전용)"""
    k = ("dates", instance)
    if k in _FP_DATE: return _FP_DATE[k]
    sys.path.insert(0, os.path.join(R.ROOT, "tools", "DbConn"))
    from dbconn import connect
    with connect("asis") as cx:
        cur = cx.cursor()
        cur.execute("select distinct top %d convert(varchar(8), PLAN_START_TIME, 112) d from LGCE_FPDEV_TR.dbo.SCM_FP_PLAN_H with(nolock) where INSTANCE_ID = ? order by d desc" % int(n), instance)
        _FP_DATE[k] = [r[0] for r in cur.fetchall() if r[0]]
    return _FP_DATE[k]


def inner_items(ctrls_all, c):
    return c.get("items") or []


def checked_list_items(host, name):
    """UsrCheckedList 안쪽 CheckedListBox 의 항목 수·체크 수"""
    d = host.send("dump", timeout=120, rows=-1).get("data") or {}
    for c in d.get("controls") or []:
        if "/" + name + "/" in (c.get("path") or "") and (c.get("type") or "").endswith("CheckedListBox"):
            it = c.get("items") or []
            return len(it), sum(1 for x in it if x.get("checked")), [x.get("text") for x in it[:5]]
    return 0, 0, []


def is_required(c):
    return c["label"].rstrip().endswith("*") or bool(KEY.search(c["label"]))


def empty_targets(host, st):
    """비어 있는 필수 선택 항목 — (컨트롤, 종류)"""
    out = []
    for c in st:
        if not is_required(c) or not c.get("enabled", True) or c.get("name") in _SKIP: continue
        if c["t"] == "UsrCombo":
            if (c.get("item_count") or 0) == 0 or (c.get("selected_index") is not None and c.get("selected_index") < 0): out.append((c, "combo"))
        elif c["t"].startswith("UsrCheckedList") and re.search(r"version", c["label"], re.I) and not (c.get("control_values") or "").strip():
            out.append((c, "checklist"))
    return out


def fp_latest_date(instance):
    if instance in _FP_DATE: return _FP_DATE[instance]
    sys.path.insert(0, os.path.join(R.ROOT, "tools", "DbConn"))
    from dbconn import connect
    with connect("asis") as cx:
        cur = cx.cursor()
        cur.execute("select max(convert(varchar(8), PLAN_START_TIME, 112)) from LGCE_FPDEV_TR.dbo.SCM_FP_PLAN_H with(nolock) where INSTANCE_ID = ?", instance)
        r = cur.fetchone()
    _FP_DATE[instance] = (r[0] if r else None)
    return _FP_DATE[instance]


LOCK = set()                                        # 조건 시나리오가 값을 넣은 컨트롤 — 채움 규칙이 건드리지 않는다(11-13 · SSP0015 Division 40→81 덮어씀)


def do_set(host, fills, why, **kw):
    if kw.get("name") in LOCK:
        fills.append({"rule": why, "set": None, "ok": False, "applied": None, "error": "시나리오가 넣은 값이라 바꾸지 않음(%s)" % kw.get("name")}); return False
    t = R.now(); r = host.send("set", timeout=120, **kw); R.wait_quiet(t, 2, 40)
    fills.append({"rule": why, "set": kw, "ok": bool(r.get("ok")), "applied": r.get("applied"), "error": r.get("error")})
    return bool(r.get("ok"))


def prefill(host, sid):
    """반환 (fills, left) — fills: 적용한 설정 목록 · left: 끝내 비어 있는 필수 항목 설명 목록"""
    fills = []; _SKIP.clear()
    st = state(host); tg = empty_targets(host, st)
    vtxt = [c for c in st if c["t"] in ("UsrMultiLineEditor", "UsrTextBox") and re.search(r"version", c["label"], re.I) and c.get("enabled", True) and not (c.get("text") or "").strip()]
    if not tg and not vtxt: return fills, []

    # 규칙 1 — FP 계획: Plan ID 콤보가 비어 있음
    #   (11-13 보완) 날짜 컨트롤은 Usr 달력뿐 아니라 화면 고유 달력(DateEdit · 이름 planday 등)도 찾는다.
    #   최근 계획 날짜에 그 화면의 Plan ID 목록이 비면 계획이 있는 날짜를 최근 순으로 차례로 넣어 본다(화면이 목록을 채우는 첫 날짜).
    #   그래도 비면 화면의 "Rel."(확정 계획) 체크를 켠다(Plan ID 없이 조회하는 화면 고유 경로).
    def planid_empty(st_):
        return [c for c in st_ if c["t"] == "UsrCombo" and re.search(r"plan\s*id", c["label"], re.I) and c.get("enabled", True) and (c.get("item_count") or 0) == 0]
    if planid_empty(st):
        grp = next((c for c in st if c["t"] == "UsrCombo" and re.search(r"plan\s*group", c["label"], re.I)), None)
        if grp and (grp.get("selected_index") is None or grp.get("selected_index") < 0) and (grp.get("item_count") or 0) > 0:
            do_set(host, fills, "FP Plan Group 미선택 → 첫 항목", name=grp["name"], index="0"); st = state(host)
            grp = next((c for c in st if c["name"] == grp["name"]), grp)
        inst = (grp or {}).get("control_values") or (grp or {}).get("selected_value")
        rw = raw(host)
        date_c = next((c for c in st if "DatePicker" in c["t"] and "Range" not in c["t"] and re.search(r"plan\s*date|instance\s*date", c["label"], re.I)), None)
        if date_c is None:
            date_c = next((c for c in rw if c["t"] == "DateEdit" and re.search(r"plan.?day|plan.?date|instance", c.get("name") or "", re.I)), None)
        if inst and date_c:
            ds = fp_dates(inst)
            if not ds: fills.append({"rule": "FP 최근 계획 날짜", "ok": False, "error": "Plan Group %s 의 계획이 DB 에 없음" % inst})
            for n, d in enumerate(ds):
                do_set(host, fills, "FP 계획 날짜 %s번째 최근(SCM_FP_PLAN_H · Plan Group %s)" % (n + 1, inst), name=date_c["name"], prop="DateTime", value=d)
                st = state(host)
                if not planid_empty(st): break
        else:
            fills.append({"rule": "FP 최근 계획 날짜", "ok": False, "error": "Plan Group(%s)·Plan Date 달력(%s) 을 찾지 못함" % (inst, date_c and date_c["name"])})
        st = state(host)
        left_ids = planid_empty(st)
        if left_ids:
            rels = [c for c in raw(host) if c["t"].endswith("CheckBox") and c.get("enabled", True) and (re.match(r"rel\.?$", (c.get("text") or "").strip(), re.I) or re.search(r"chk_?rel", c.get("name") or "", re.I))]
            for pc in left_ids:
                tok = next((k for k in ("form", "cell", "pack", "elec", "assy") if k in (pc.get("name") or "").lower()), None)
                cand = [r for r in rels if tok and tok in (r.get("name") or "").lower()] or (rels if len(rels) == 1 else [])
                for r in cand[:1]:
                    do_set(host, fills, "Plan ID 목록 없음 → Rel.(확정 계획) 체크(%s)" % pc["label"], name=r["name"], prop="Checked", value="true")
                    _SKIP.add(pc["name"])
        st = state(host); tg = empty_targets(host, st)

    # 규칙 2 — Division 연동
    def unfilled(tg_):
        n = 0
        for c, k in tg_:
            if k == "combo" and (c.get("item_count") or 0) == 0: n += 1
            if k == "checklist" and checked_list_items(host, c["name"])[0] == 0: n += 1
        return n
    if unfilled(tg):
        dv = next((c for c in st if c["t"] == "UsrCombo" and (DIV.search(c["label"]) or re.search(r"division", c.get("name") or "", re.I)) and (c.get("item_count") or 0) > 1), None)
        if dv:
            org = dv.get("selected_index") or 0; other = 1 if org == 0 else 0
            do_set(host, fills, "Division 변경 이벤트 발생(다른 값)", name=dv["name"], index=str(other))
            do_set(host, fills, "Division 원래 값으로 복귀", name=dv["name"], index=str(org))
            st = state(host); tg = empty_targets(host, st)
            if unfilled(tg):
                for i in range(dv.get("item_count") or 0):
                    if i == org: continue
                    do_set(host, fills, "Division 을 바꿔 목록이 채워지는지 확인", name=dv["name"], index=str(i))
                    st = state(host); tg = empty_targets(host, st)
                    if not unfilled(tg): break

    # 규칙 2b (11-13) — Division 이 체크 목록인 화면: 필수 콤보가 비어 있으면 Division 을 하나씩만 체크해 목록이 채워지는 첫 Division 을 쓴다
    if unfilled(tg):
        dl = next((c for c in st if c["t"].startswith("UsrCheckedList") and (DIV.search(c["label"]) or re.search(r"division", c.get("name") or "", re.I))), None)
        if dl:
            n_items, _chk, _t = checked_list_items(host, dl["name"])
            for i in range(n_items):
                do_set(host, fills, "Division 체크 목록에서 %s번째만 체크(목록이 채워지는지 확인)" % (i + 1), name=dl["name"], check=str(i), only="1")
                st = state(host); tg = empty_targets(host, st)
                if not unfilled(tg): break

    # 규칙 3·4 — 항목은 있는데 선택이 없는 것 (탭 순서대로: 앞 선택이 뒤 목록을 바꾼다)
    for _ in range(6):
        st = state(host); tg = empty_targets(host, st); did = False
        for c, k in sorted(tg, key=lambda x: (x[0].get("y") or 0, x[0].get("x") or 0)):
            if k == "combo" and (c.get("item_count") or 0) > 0:
                did = do_set(host, fills, "콤보 첫 항목(%s)" % c["label"], name=c["name"], index="0"); break
            if k == "checklist":
                n, chk, _txt = checked_list_items(host, c["name"])
                if n > 0 and chk == 0: did = do_set(host, fills, "체크 목록 첫 항목(%s)" % c["label"], name=c["name"], check="0"); break
        if not did: break

    # 규칙 5 — Version 입력칸: 팝업을 열어 맨 위 행 선택
    for c in vtxt:
        t0 = R.now(); r = host.send("popup_pick", timeout=150, wait=60); R.wait_quiet(t0, 2, 40)
        pk = r.get("picked") or {}
        fills.append({"rule": "Version 팝업 맨 위 행(%s)" % c["label"], "set": {"name": c["name"], "popup": r.get("popup"), "opener": r.get("opener")}, "ok": bool(r.get("ok")),
                      "applied": ("popup:%s rows=%s value=%s" % (r.get("popup"), r.get("rows"), pk.get("value"))) if r.get("ok") else None, "top": pk.get("top"), "error": r.get("error")})
        break                                              # 화면당 Version 입력칸 1개(여는 메서드가 화면 단위)

    st = state(host); tg = empty_targets(host, st); left = []
    for c in vtxt:
        cur = next((x for x in st if x["name"] == c["name"]), None)
        if cur is not None and not (cur.get("text") or "").strip(): left.append("%s[%s·%s] 비어 있음(팝업 선택 실패)" % (c["name"], c["label"], c["t"]))
    for c, k in tg:
        if k == "checklist" and checked_list_items(host, c["name"])[1] > 0: continue
        left.append("%s[%s·%s] 비어 있음(항목 %s개)" % (c["name"], c["label"], c["t"], c.get("item_count") if k == "combo" else checked_list_items(host, c["name"])[0]))
    return fills, left
