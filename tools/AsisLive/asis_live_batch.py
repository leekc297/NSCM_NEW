# -*- coding: utf-8 -*-
"""AS-IS 실측 일괄 실행 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P5)

런처를 한 번 띄워 로그인한 뒤, 이 계정 메뉴에 있는 화면을 차례로 "열기 + 조회(기본 조건)" 한다.
  사용: python tools/AsisLive/asis_live_batch.py [--only ID,ID] [--prefix SSP,SCP] [--limit N] [--skip-done] [--find-timeout 120]
  산출: 화면마다 Doc/asislive/<ID>/run_<시각>/ (단건 실행과 같은 형식) · 전체 표 Doc/asislive/_summary.csv · 실행 기록 Doc/asislive/_batch_<시각>.log
  종료코드: 0 전부 정상 · 2 일부 FAIL/ERROR(표에 사유) · 3 환경 미비 · 5 로컬 서버 미기동
주기 방식: 오류가 나도 멈추지 않고 표에 올린 뒤 다음 화면으로 간다. 호스트가 죽으면 다시 띄워 이어서 한다.
앱 동작(조회 SP 안의 쓰기 포함)은 제한하지 않는다. 화면의 저장·삭제 버튼은 누르지 않는다(열기·조회만).
"""
import argparse, csv, json, os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import asis_live_run as R

EXCLUDED = {"SSP0060", "SCP0049", "FP00599", "FP00608", "FP02846", "SCM0010", "SCP0200", "SCP0034"}  # 사용자 결정 11-12: 소스 없음 8 + 미사용 예정 1 · 11-13 사용자 정정: SSP0020 은 사용 화면(미사용 메뉴에도 등록돼 있어 제외로 잡혔던 것) → 목록에서 뺌
SUMMARY = os.path.join(R.ROOT, "Doc", "asislive", "_summary.csv")
COLS = ["id", "title", "menu_path", "status", "exit", "why", "opened", "find_how", "total", "time_status", "grids", "sheets", "grid_rows", "header_cols",
        "calls_load", "calls_find", "own_sp_find", "dialogs", "dialog_text", "sec", "run_dir", "measured_at", "cond", "fills", "fill_left"]


def load_summary():
    if not os.path.isfile(SUMMARY): return {}
    with open(SUMMARY, encoding="utf-8-sig", newline="") as f:
        return {r["id"]: r for r in csv.DictReader(f)}


def save_summary(rows):
    tmp = SUMMARY + ".tmp"
    with open(tmp, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=COLS, extrasaction="ignore"); w.writeheader()
        for k in sorted(rows): w.writerow(rows[k])
    os.replace(tmp, SUMMARY)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", default=""); ap.add_argument("--prefix", default=""); ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--skip-done", action="store_true", help="_summary.csv 에 status=OK 인 화면은 건너뜀")
    ap.add_argument("--find-timeout", type=int, default=120); ap.add_argument("--rows", type=int, default=50); ap.add_argument("--no-find", action="store_true")
    ap.add_argument("--scenario-tobe", action="store_true", help="화면별 Doc/asislive/<ID>/scenario_tobe.json (TO-BE 검증 조건)을 조회 전에 넣는다")
    ap.add_argument("--fill", default="", help="recent = 필수 조회조건을 가장 최근 값으로 채운 뒤 조회(2차)")
    ap.add_argument("--only-file", default="", help="대상 화면 ID 목록 파일(csv 의 id 열 또는 한 줄에 하나)")
    a = ap.parse_args()
    prefill = None
    import asis_live_fill
    if a.fill == "recent": prefill = asis_live_fill.prefill
    c0, w0, base = R.env_ready()
    if c0: print("[ERROR] " + w0); return c0
    if not R.acquire_lock("batch"): print("[ERROR] 다른 AS-IS 실측이 끝나지 않음"); return 3
    others = R.other_launchers()
    if others: print("[WARN] 다른 AS-IS 런처가 실행 중(%s) — 그 런처를 조작하면 호출 기록에 섞입니다" % ", ".join(others), flush=True)
    batch_dir = os.path.join(R.ROOT, "Doc", "asislive", "_batch_cmd_" + R.now().strftime("%Y%m%d_%H%M%S"))

    def session(n):
        for attempt in range(3):      # 메뉴가 비어 있는 세션은 쓸 수 없다 → 최대 3번 다시 띄운다
            host, info, why = R.start_session(batch_dir + "_%d_%d" % (n, attempt))
            if host: return host, info
            print("[WARN] 런처 세션 시작 실패(%d/3): %s" % (attempt + 1, why), flush=True); time.sleep(5)
        print("[ERROR] 런처 세션 시작 실패: " + why, flush=True)
        return None, {}

    sess = 1; host, info = session(sess)
    if not host: return 3
    menu = host.send("menu", timeout=60).get("items") or []
    seen, targets = set(), []
    for m in menu:
        pid = (m.get("program_id") or "").strip().upper(); url = (m.get("url") or "").strip()
        if not pid or not url.lower().endswith(".dll") or pid in seen: continue
        seen.add(pid); targets.append((pid, m.get("title") or "", m.get("path") or "", url))
    only = {x.strip().upper() for x in a.only.split(",") if x.strip()}
    if a.only_file:
        with open(a.only_file, encoding="utf-8-sig", newline="") as f:
            head = f.readline(); f.seek(0)
            only |= ({r["id"].strip().upper() for r in csv.DictReader(f)} if "id" in [h.strip().lstrip("\ufeff") for h in head.split(",")] else {x.strip().upper() for x in f if x.strip()})
    if 1: pref = tuple(x.strip().upper() for x in a.prefix.split(",") if x.strip())
    rows = load_summary(); plan = []
    for pid, title, path, url in targets:
        if only and pid not in only: continue
        if pref and not pid.startswith(pref): continue
        if a.skip_done and rows.get(pid, {}).get("status") == "OK": continue
        plan.append((pid, title, path, url))
    if a.limit: plan = plan[: a.limit]
    print("메뉴 화면 %d개(프로그램 경로 있음) · 이번 대상 %d개 · 계정 %s" % (len(targets), len(plan), info.get("user_id")), flush=True)

    n_ok = n_bad = 0; t_all = time.time()
    for i, (pid, title, path, url) in enumerate(plan, 1):
        t0 = time.time(); started = R.now(); R.touch_lock()
        row = {"id": pid, "title": title, "menu_path": path, "measured_at": R.ts(started)[:19]}
        if pid in EXCLUDED:
            row.update(status="NA", exit=2, why="제외 화면(소스 없음·미사용 예정 — 사용자 결정 11-12)"); rows[pid] = row; save_summary(rows)
            print("[%d/%d] %s NA 제외" % (i, len(plan), pid), flush=True); continue
        if not os.path.isfile(os.path.join(R.LAUNCH_DIR, url)):
            row.update(status="FAIL", exit=2, why="화면 DLL 없음: " + url); rows[pid] = row; save_summary(rows); n_bad += 1
            print("[%d/%d] %s FAIL DLL 없음" % (i, len(plan), pid), flush=True); continue
        run_dir, run = R.new_run(pid, started); run.update(info); run["client_base_url"] = base; run["other_launchers"] = others; run["batch"] = True
        try:
            w_sec, w_left = R.wait_db_clear(1900)             # 앞 화면이 남긴 실행 중 조회가 끝난 뒤에 다음 화면을 연다
            if w_sec >= 10: print("  (앞 조회 종료 대기 %ss · 남은 요청 %s)" % (w_sec, w_left), flush=True)
            run["db_wait_before"] = {"sec": w_sec, "left": w_left}
            scen = None; asis_live_fill.LOCK.clear()
            if a.scenario_tobe:
                try: scen = json.load(open(os.path.join(R.ROOT, "Doc", "asislive", pid, "scenario_tobe.json"), encoding="utf-8")); run["scenario"] = {"rule": "tobe", "set": scen.get("set")}; asis_live_fill.LOCK.clear(); asis_live_fill.LOCK.update(s.get("name") for s in scen.get("set") or [])
                except Exception: scen = None
            code, status, why = R.measure(host, pid, run_dir, a, run, scen, close_after=True, prefill=prefill)
            if code == 2 and "not in this user's menu" in why and host.proc.poll() is None:
                # 메뉴에는 있던 화면(대상 목록 = 메뉴)인데 이 세션에서 못 찾음 = 세션 메뉴가 비었다 → 세션을 새로 띄워 한 번 더
                try: host.stop()
                except Exception: pass
                sess += 1; host, info2 = session(sess)
                if not host: print("[ERROR] 런처를 다시 띄우지 못해 중단 — 나머지는 미측정", flush=True); break
                run_dir, run = R.new_run(pid, R.now()); run.update(info2); run["client_base_url"] = base; run["other_launchers"] = others; run["batch"] = True; run["retry"] = "menu_empty"
                started = R.now()
                code, status, why = R.measure(host, pid, run_dir, a, run, None, close_after=True, prefill=prefill)
        except Exception as ex:
            code, status, why = 3, "ERROR", "실측 중 예외: %s" % str(ex)[:200]
        alive = host.proc.poll() is None
        try:
            code, status, why = R.collect(pid, run_dir, run, started, R.now(), a, code, status, why)
        except Exception as ex:
            code, status, why = 3, "ERROR", "산출물 정리 중 예외: %s" % str(ex)[:200]
        if not alive: code, status, why = 2, "FAIL", "런처가 종료됨(화면 실행 중 프로세스 종료) · " + why
        R.save_run(pid, run_dir, run, code, status, why, links=False)
        c, f = run.get("counts") or {}, run.get("find") or {}
        own_find = 0
        try:
            cj = json.load(open(os.path.join(run_dir, "calls.json"), encoding="utf-8"))["calls"]
            own_find = len({x["sp"] for x in cj if x.get("phase") == "find" and not x["sp"].upper().startswith(("UP_FX_", "SCM_SYS_GET_SPREAD_TITLE", "SCP0009_GET_SHEET_CALENDAR"))})
            calls_load = sum(1 for x in cj if x.get("phase") == "load")
        except (OSError, ValueError, KeyError):
            calls_load = ""
        dl = run.get("dialogs") or []
        row.update(status=status, exit=code, why=why, opened=run.get("gate", {}).get("opened"), find_how=f.get("how"), total=f.get("total"), time_status=f.get("time_status"),
                   grids=c.get("grids"), sheets=c.get("sheets"), grid_rows=c.get("grid_rows"), header_cols=c.get("header_cols"), calls_load=calls_load, calls_find=c.get("calls_find"),
                   own_sp_find=own_find, dialogs=len(dl), dialog_text=" || ".join(" / ".join((d.get("text") or "").splitlines())[:120] for d in dl)[:400],
                   sec=round(time.time() - t0, 1), run_dir=R.rel(run_dir),
                   cond=("최근 값 채움" if run.get("fills") else ("기본값(채울 항목 없음)" if prefill else "기본값")),
                   fills=" ; ".join("%s=%s" % ((x.get("set") or {}).get("name"), x.get("applied") or x.get("error")) for x in (run.get("fills") or []))[:600],
                   fill_left=" ; ".join(run.get("fill_left") or [])[:300])
        rows[pid] = row; save_summary(rows)
        if status == "OK": n_ok += 1
        else: n_bad += 1
        print("[%d/%d] %s %s · %s · %s · 그리드 행 %s · 조회 호출 %s · 대화상자 %d · %.0fs%s" % (
            i, len(plan), pid, status, f.get("how"), f.get("total"), c.get("grid_rows"), c.get("calls_find"), len(dl), time.time() - t0, (" — " + why[:100]) if why else ""), flush=True)
        if not alive or run.get("close_left"):       # 호스트가 죽었거나 화면이 안 닫힘 → 세션을 새로
            try: host.stop()
            except Exception: pass
            sess += 1; host, info2 = session(sess)
            if not host: print("[ERROR] 런처를 다시 띄우지 못해 중단 — 나머지는 미측정", flush=True); break
    try: host and host.stop()
    except Exception: pass
    print("일괄 종료: 대상 %d · OK %d · 그 외 %d · %.0f분 · 세션 %d회" % (len(plan), n_ok, n_bad, (time.time() - t_all) / 60, sess), flush=True)
    print("@@LINK 📄 AS-IS 실측 전체 표|" + R.rel(SUMMARY))
    return 0 if n_bad == 0 else 2


if __name__ == "__main__":
    sys.exit(main())
