# -*- coding: utf-8 -*-
"""asis_live_cell_facts.py — AS-IS 런처 셀 실행 결과를 열 단위 사실표로 모은다 (2026-11-15, 27화면 미검증·미판단 0 작업)

입력  Doc/asislive/<ID>/run_*_acts_states · _states_edit   (asis_live_scen_run.py --states : 조회 직후·수정 모드의 행별 셀 잠금·배경색·글자색)
      Doc/asislive/<ID>/run_*_acts_pick · _pick_edit       (--pick : 셀 더블클릭 → 팝업 → 첫 행 고름 → 바뀐 셀)
      Doc/asislive/<ID>/run_*_acts_insert · _violate       (--insert · --violate : 행 추가 뒤 새 행 셀 잠금, 빈 새 행 저장 메시지)
      종류마다 가장 최근 실행 1개만 쓴다. overlap.json 있는 폴더(다른 화면 실행과 겹친 기록)는 뺀다.
출력  Doc/asislive/<ID>/cell_facts.csv   열 1개 = 1행
        grid · sheet · col_index · tag · label · visible
        lock_read  · lock_edit  : 잠김 n/전체 n (행마다 다르면 '행마다 다름')     ← 편집 불가 셀 · 행 조건 계산 대조용
        back_read  · back_edit  : 배경색 목록(행 수)                               ← 행 조건 계산(색) 대조용
        dbl_popup  · dbl_popup_edit : 더블클릭 때 뜬 팝업 폼(없으면 '없음', 누르지 않았으면 빈칸)
        pick_changed : 팝업에서 고른 뒤 값이 바뀐 열(이 열을 눌렀을 때)
        new_row_lock : 행 추가 뒤 새 행에서 이 열 잠김(1)/열림(0)
        evidence : 근거 폴더(종류=폴더)
      Doc/asislive/_cell_facts_summary.csv 화면별 요약(실행 종류별 근거 유무 · 열 수)
한계  열 이름(tag)으로 묶는다. 같은 tag 가 여러 그리드에 있으면 그리드·시트별로 따로 적는다.
      값이 아닌 상태(잠금·색·팝업)만 모은다. TO-BE 와의 대조와 판정은 검증 엔진 쪽 입력에서 한다.

  python tools/AsisLive/asis_live_cell_facts.py [ID …]
"""
import csv, glob, json, os, sys, time, collections

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
try: sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception: pass
KINDS = ["states", "states_edit", "pick", "pick_edit", "insert", "violate"]


def latest(mid):
    out = {}
    for d in sorted(glob.glob(P("Doc", "asislive", mid, "run_*_acts_*"))):
        if not os.path.isdir(d) or os.path.exists(os.path.join(d, "overlap.json")): continue
        k = os.path.basename(d).split("_acts_", 1)[1]
        if k not in KINDS or not os.path.exists(os.path.join(d, "acts.json")): continue
        try: out[k] = (d, json.load(open(os.path.join(d, "acts.json"), encoding="utf-8")))
        except Exception: pass
    return out


def lock_txt(st, ci):
    lk = [r[ci] for r in (st.get("locked") or []) if ci < len(r)]
    if not lk: return ""
    n1 = lk.count("1")
    if 0 < n1 < len(lk): return "행마다 다름(잠김 %d/%d)" % (n1, len(lk))
    return "잠김 %d/%d" % (n1, len(lk))


def back_txt(st, ci, key="back"):
    c = collections.Counter(r[ci] for r in (st.get(key) or []) if ci < len(r))
    return ", ".join("%s(%d)" % kv for kv in c.most_common(4))


def facts(mid):
    L = latest(mid); rows = {}; ev = {k: os.path.relpath(v[0], ROOT).replace("\\", "/") for k, v in L.items()}

    def row(grid, sheet, ci, col):
        # 열 이름 + 그리드로 묶는다. 시트는 실행 종류마다 이름·번호로 달리 적혀 있어 묶는 열쇠에서 뺀다(첫 값 기록)
        k = (grid or "", col.get("tag") or col.get("label") or str(ci))
        if k not in rows:
            rows[k] = {"menu_id": mid, "grid": k[0], "sheet": sheet if sheet not in (None, "") else "", "col_index": ci, "tag": k[1], "label": col.get("label") or "", "visible": col.get("visible") or ""}
        r = rows[k]
        if not r.get("sheet") and sheet not in (None, ""): r["sheet"] = sheet
        if col.get("label") and not r.get("label"): r["label"] = col["label"]
        if col.get("visible") and not r.get("visible"): r["visible"] = col["visible"]
        if r.get("col_index") in ("", None) and ci not in ("", None): r["col_index"] = ci
        return r

    for k, key in (("states", "read"), ("states_edit", "edit")):
        if k not in L: continue
        st = L[k][1].get("cellstate") or {}
        for i, col in enumerate(st.get("cols") or []):
            r = row(st.get("grid"), st.get("sheet_name") or st.get("sheet"), col.get("index", i), col)
            r["lock_" + key] = lock_txt(st, i); r["back_" + key] = back_txt(st, i)
    for k, key in (("pick", "dbl_popup"), ("pick_edit", "dbl_popup_edit")):
        if k not in L: continue
        for a in L[k][1].get("acts") or []:
            r = row(a.get("grid"), a.get("sheet"), a.get("index", ""), {"tag": a.get("control")})
            pf = (a.get("popup") or {}).get("form") or ""
            if not pf and a.get("late_popups"): pf = ",".join(sorted({p.get("form") for p in a["late_popups"] if p.get("form") and p.get("form") != "ProgressForm"}))
            r[key] = pf or "없음"
            ch = sorted({c.get("col") for g in a.get("grid_changes") or [] for c in g.get("cells") or [] if c.get("col") not in ("(행)",)})
            if ch: r["pick_changed"] = ", ".join(ch)
            if a.get("rule"): r[key + "_rule"] = a["rule"]
    for k in ("violate", "insert"):
        if k not in L: continue
        ins = [a for a in L[k][1].get("acts") or [] if a.get("kind") == "insert"]
        if not ins: continue
        ns = ins[0].get("new_row_state") or {}
        for i, col in enumerate(ns.get("cols") or []):
            r = row(ns.get("grid"), ns.get("sheet_name") or ns.get("sheet"), col.get("index", i), col)
            lk = (ns.get("locked") or [""])[0]
            r["new_row_lock"] = lk[i] if i < len(lk) else ""
        break
    # 그리드 이름이 없는 기록(11-15 이전 실행)은 같은 열 이름의 행이 하나뿐이면 그 행에 합친다
    for k in [k for k in list(rows) if k[0] == ""]:
        same = [k2 for k2 in rows if k2[0] != "" and k2[1] == k[1]]
        if len(same) != 1: continue
        dst = rows[same[0]]
        for kk, vv in rows.pop(k).items():
            if vv not in ("", None) and dst.get(kk) in ("", None): dst[kk] = vv
    for r in rows.values(): r["evidence"] = " ".join("%s=%s" % kv for kv in sorted(ev.items()))
    return sorted(rows.values(), key=lambda r: (r["grid"], int(r["col_index"]) if str(r.get("col_index")).isdigit() else 9999)), ev


COLS = ["menu_id", "grid", "sheet", "col_index", "tag", "label", "visible", "lock_read", "lock_edit", "back_read", "back_edit", "dbl_popup", "dbl_popup_rule", "dbl_popup_edit", "dbl_popup_edit_rule", "pick_changed", "new_row_lock", "evidence"]


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]
    if not ids: ids = sorted({os.path.basename(os.path.dirname(d)) for d in glob.glob(P("Doc", "asislive", "*", "run_*_acts_states"))})
    summ = []
    for mid in ids:
        rows, ev = facts(mid)
        if not rows: summ.append({"menu_id": mid, "cols": 0, **{k: ("" if k not in ev else "있음") for k in KINDS}}); continue
        f = P("Doc", "asislive", mid, "cell_facts.csv")
        with open(f + ".tmp", "w", encoding="utf-8-sig", newline="") as fo:
            w = csv.DictWriter(fo, fieldnames=COLS, extrasaction="ignore"); w.writeheader(); w.writerows(rows)
        os.replace(f + ".tmp", f)
        summ.append({"menu_id": mid, "cols": len(rows), **{k: ("있음" if k in ev else "") for k in KINDS}})
        print("%s 열 %d · 근거 %s" % (mid, len(rows), ", ".join(sorted(ev))), flush=True)
    sf = P("Doc", "asislive", "_cell_facts_summary.csv")
    with open(sf, "w", encoding="utf-8-sig", newline="") as fo:
        w = csv.DictWriter(fo, fieldnames=["menu_id", "cols"] + KINDS); w.writeheader(); w.writerows(summ)
    print("[실측 %s] 화면 %d · 열 사실 %d행" % (time.strftime("%Y-%m-%d %H:%M"), len(summ), sum(s["cols"] for s in summ)))
    print("@@LINK 📂 열 단위 AS-IS 사실 요약|%s" % sf)
    return 0


if __name__ == "__main__":
    sys.exit(main())
