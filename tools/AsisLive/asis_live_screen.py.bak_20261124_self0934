# -*- coding: utf-8 -*-
"""화면 1개의 AS-IS 런처 실측 묶음 — CheckList 작업 때 구동 (2026-11-13 · 사용자 지시
   "실제 AS-IS 런처 실행으로 필요한 데이터 취합 및 기준설정 부분은 화면별 CHECKLIST 작업 시 구동되도록")

  python tools/AsisLive/asis_live_screen.py <ID> [--force] [--no-buttons] [--after-basic]
      --after-basic  CheckList 체인용: 바로 앞 asis_live_auto.py 의 기본 실측에 행이 있으면 ③ 을 다시 하지 않는다
      환경변수 VERIFY_ASIS_LIVE(auto|always|off) · VERIFY_ASIS_LIVE_MAX_AGE_H(기본 24) — asis_live_auto.py 와 같은 기준
순서  ① 대상 여부(제외 화면이면 근거를 적고 끝)  ② 로컬 서버(8086) 응답
      ③ 기본 실측: 열기 → 필수 조건 최근 값 → 조회 → 화면·그리드 덤프·캡처·서버 호출   (asis_live_batch.py --fill recent --only <ID>)
      ④ 소스 분기 시나리오 도출·기준 연결                                               (asis_live_scen_src.py <ID>)
      ⑤ 버튼 분기 실행: 조회·팝업 분기의 버튼 누르기 → 팝업·메시지·Excel 기록 후 닫기      (asis_live_scen_run.py <ID>)
      ⑥ 분기 실행 현황                                                                   (asis_live_scen_cov.py <ID>)
      ⑦ TO-BE 조회 조건과 대조(TO-BE 호출 기록이 있을 때만)                              (asis_live_cond.py <ID>)
      ⑧ 분기별 AS-IS 실행 결과 ↔ TO-BE 대조표 판정 대조 · TO-BE 룰로 정의된 차이는 오류 아님   (asis_live_scen_cmp.py <ID>)
산출  Doc/asislive/<ID>/screen_bundle.json  {id, at, status, steps:[{step, rc, sec, note}], reused}
      status: OK(전 단계 실행) | PARTIAL(일부 단계 실패 — 단계별 rc 참조) | ERROR(실측 못 함 = 미검증) | NA(대상 제외 — 근거 기록)
재사용  기준 시간(기본 24시간) 안에 status OK 인 묶음이 있으면 다시 돌리지 않는다(--force 로 강제). 런처 구동은 화면당 수 분이 걸리기 때문.
동시 실행  런처·호출 기록은 PC 에 하나뿐 → 화면 단위 잠금(Doc/asislive/_screen.lock)으로 한 번에 한 화면만. 다른 화면이 돌고 있으면 최대 60분 기다린다.
종료코드  0 OK·NA·재사용 · 2 PARTIAL · 3 ERROR(미측정) · 5 로컬 서버 미기동      (CheckList 체인은 어느 코드든 계속 진행한다 — 미측정은 미검증으로 남는다)
누르지 않는 것  저장 계열·상태 변경 이름·파일/Excel 버튼(asis_live_scen_run.py 규칙). 저장 시나리오는 이 묶음에 없다.
"""
import json, os, re, socket, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
PY = sys.executable
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass

MATERIAL4 = {"FP02510", "FP02800N", "SCP0008", "SCP0038"}


def excluded(mid):
    """대상 제외 근거 — 목록의 단일 소스 = asis_live_batch.EXCLUDED (11-13 SSP0020 은 사용 화면으로 정정됨)"""
    if mid.startswith("FP"): return "FP 화면 전체 제외(사용자 결정 11-13)"
    if mid in MATERIAL4: return "Material 필수 화면 제외(사용자 결정 11-13)"
    try:
        src = open(os.path.join(HERE, "asis_live_batch.py"), encoding="utf-8").read()
        m = re.search(r"^EXCLUDED\s*=\s*\{([^}]*)\}", src, re.M)
        if m and mid in set(re.findall(r'"([A-Z0-9_]+)"', m.group(1))): return "제외 화면(소스 없음·미사용 예정 — asis_live_batch.EXCLUDED)"
    except Exception:
        pass
    return ""


def latest_run(mid):
    """가장 최근 기본 실측 (run.json, 경과 시간) — 없으면 (None, None)"""
    try:
        lt = json.load(open(P("Doc", "asislive", mid, "latest.json"), encoding="utf-8")); rd = lt.get("run_dir") or ""
        rd = rd if os.path.isabs(rd) else P(*re.split(r"[\/]", rd))
        run = json.load(open(os.path.join(rd, "run.json"), encoding="utf-8"))
        age = (time.time() - time.mktime(time.strptime(str(run.get("started"))[:19], "%Y-%m-%d %H:%M:%S"))) / 3600
        return run, age
    except Exception:
        return None, None


LOCK = P("Doc", "asislive", "_screen.lock")


def now(): return time.strftime("%Y-%m-%d %H:%M:%S")


def alive(pid):
    try:
        o = subprocess.run(["tasklist", "/FI", "PID eq %d" % pid, "/FO", "CSV", "/NH"], capture_output=True, text=True, errors="replace").stdout
        return ('"%d"' % pid) in o
    except Exception:
        return True


def lock(mid, wait_sec=3600):
    """화면 잠금. 11-15: 부모(asis_live_screen 묶음)가 같은 화면 잠금을 쥐고 부른 자식 단계는 기다리지 않는다(환경변수 ASIS_LIVE_LOCK_HOLDER = 부모 pid·화면).
    자식은 잠금 파일을 지우지 않는다(unlock 은 pid 가 같을 때만 지움)"""
    os.makedirs(os.path.dirname(LOCK), exist_ok=True); t0 = time.time(); told = 0
    hold = os.environ.get("ASIS_LIVE_LOCK_HOLDER", "").split()
    if len(hold) == 2:
        try:
            txt = open(LOCK, encoding="utf-8", errors="replace").read().split()
            if txt[:2] == hold and hold[1] == mid: return True
        except (OSError, IndexError):
            pass
    while True:
        try:
            fd = os.open(LOCK, os.O_CREAT | os.O_EXCL | os.O_WRONLY); os.write(fd, ("%d %s %s" % (os.getpid(), mid, now())).encode()); os.close(fd)
            os.environ["ASIS_LIVE_LOCK_HOLDER"] = "%d %s" % (os.getpid(), mid)   # 이 프로세스가 부르는 자식 단계에 전달
            return True
        except FileExistsError:
            try:
                txt = open(LOCK, encoding="utf-8", errors="replace").read().split()
                if not txt or not txt[0].isdigit() or not alive(int(txt[0])): os.remove(LOCK); continue
            except OSError:
                pass
            if time.time() - t0 > wait_sec: return False
            if time.time() - told > 60: print("[대기] 다른 화면의 AS-IS 실측이 도는 중(%s) — 끝나면 시작" % " ".join(txt[1:2]), flush=True); told = time.time()
            time.sleep(3)


def unlock():
    try:
        if os.path.exists(LOCK) and open(LOCK, encoding="utf-8", errors="replace").read().split()[:1] == [str(os.getpid())]: os.remove(LOCK)
    except OSError:
        pass


def port_ok(port=8086):
    s = socket.socket(); s.settimeout(3)
    try: s.connect(("127.0.0.1", port)); return True
    except OSError: return False
    finally: s.close()


def step(steps, name, args, timeout=2400):
    t0 = time.time(); print("\n[실측 %d] %s" % (len(steps) + 1, name), flush=True); note = ""
    try:
        p = subprocess.run([PY] + args, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=timeout); rc = p.returncode
        lines = [l for l in (p.stdout or "").splitlines() if l.strip()]
        for l in lines[-12:]: print("   " + l[:240], flush=True)
        if rc and (p.stderr or "").strip(): note = (p.stderr or "").strip().splitlines()[-1][:200]; print("   [stderr] " + note, flush=True)
    except subprocess.TimeoutExpired:
        rc = 124; note = "시간 초과 %ds — 자동화 런처 종료" % timeout
        subprocess.run(["taskkill", "/F", "/IM", "AsisLive.Host.exe"], capture_output=True)       # 자동화용 런처만(사용자 런처 GSCM.Launcher.exe 는 건드리지 않는다)
        print("   [ERROR] " + note, flush=True)
    steps.append({"step": name, "rc": rc, "sec": round(time.time() - t0, 1), "note": note})
    return rc


def save(mid, out):
    d = P("Doc", "asislive", mid); os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, "screen_bundle.json"), "w", encoding="utf-8") as f: json.dump(out, f, ensure_ascii=False, indent=1)


def main():
    av = sys.argv[1:]; ids = [a.upper() for a in av if not a.startswith("-")]
    if len(ids) != 1: print(__doc__); return 3
    mid = ids[0]; force = "--force" in av; buttons = "--no-buttons" not in av
    out = {"id": mid, "at": now(), "status": "", "steps": [], "reused": False}
    mode = os.environ.get("VERIFY_ASIS_LIVE", "auto"); max_age = float(os.environ.get("VERIFY_ASIS_LIVE_MAX_AGE_H", "24")); after = "--after-basic" in av
    if mode == "off": print("[건너뜀] %s VERIFY_ASIS_LIVE=off" % mid); return 3
    if mode == "always": force = True
    why = excluded(mid)
    if why:
        out.update(status="NA", note=why); save(mid, out); print("[NA] %s AS-IS 런처 실측 대상 아님 — %s" % (mid, why)); return 0
    bp = P("Doc", "asislive", mid, "screen_bundle.json")
    if not force and os.path.exists(bp):
        try: old = json.load(open(bp, encoding="utf-8"))
        except Exception: old = {}
        try: b_age = (time.time() - time.mktime(time.strptime(str(old.get("at"))[:19], "%Y-%m-%d %H:%M:%S"))) / 3600
        except Exception: b_age = 1e9
        # 2026-11-20 사용자 지시: 나이(24시간) 대신 원장 지문(tools/Harness/verify/asis_fp.py) — 원장이 같으면 오래돼도 재사용. VERIFY_ASIS_LIVE_MAX_AGE_H 를 지정했을 때만 나이도 본다
        sys.path.insert(0, P("tools", "Harness", "verify")); import asis_fp
        fp_ok, fp_why = asis_fp.same(mid, "bundle")
        age_ok = (b_age <= max_age) if os.environ.get("VERIFY_ASIS_LIVE_MAX_AGE_H") else True
        if not (old.get("status") == "OK" and fp_ok and age_ok) and old.get("status") == "OK": print("[새로 실측] %s 직전 묶음(%s)을 쓰지 않음 — %s" % (mid, old.get("at"), fp_why if not fp_ok else "지정한 나이 기준 %s시간 초과" % max_age))
        if old.get("status") == "OK" and fp_ok and age_ok:
            print("[재사용] %s 직전 묶음(%s · %.1f시간 전 · %s) — 런처는 다시 띄우지 않음 · 강제는 --force 또는 VERIFY_ASIS_LIVE=always" % (mid, old.get("at"), b_age, fp_why))
            # 런처를 쓰지 않는 단계는 매번 다시 한다 — CheckList 가 방금 새로 만든 대조표 추적·차등 검증 결과와 맞대야 하기 때문(11-13 SCP0028 전체 실행에서 재사용 시 대조가 빠진 것 보정)
            T = lambda n: os.path.join("tools", "AsisLive", n); st2 = []
            step(st2, "소스 분기 시나리오·대조표 연결 갱신", [T("asis_live_scen_src.py"), mid], 600)
            step(st2, "분기 실행 현황", [T("asis_live_scen_cov.py"), mid], 600)
            if os.path.isdir(P("Doc", "verify", mid, "calls")): step(st2, "TO-BE 조회 조건 대조", [T("asis_live_cond.py"), mid], 600)
            step(st2, "분기별 AS-IS↔TO-BE 대조(TO-BE 룰 조회 포함)", [T("asis_live_scen_cmp.py"), mid], 600)
            step(st2, "그룹·Division 별 비교표", [T("asis_live_scen_matrix.py"), mid], 600)
            step(st2, "진입 경로 없는 분기 분류(현행 소스 원문 재검색)", [T("asis_live_scen_unreached.py"), mid], 600)
            step(st2, "분기 시나리오 명세(전 분기)", [T("asis_live_scen_spec.py"), mid], 600)
            if os.path.exists(P("Doc", "asislive", mid, "save_scenario.json")): step(st2, "AS-IS↔TO-BE 저장 인자 대조", [T("asis_live_save_cmp.py"), mid], 600)
            old["refreshed"] = {"at": now(), "steps": st2}; save(mid, old)
            return 0 if all(x["rc"] == 0 for x in st2) else 2
    if not port_ok():
        out.update(status="ERROR", note="로컬 서버(8086) 미응답 — VM 🖥 AS-IS IIS Start 후 다시 실행"); save(mid, out); print("[ERROR] " + out["note"]); return 5
    if not lock(mid):
        out.update(status="ERROR", note="다른 화면의 AS-IS 실측이 60분 넘게 끝나지 않음"); save(mid, out); print("[ERROR] " + out["note"]); return 3
    try:
        T = lambda n: os.path.join("tools", "AsisLive", n); st = out["steps"]
        run0, age0 = latest_run(mid); rows0 = ((run0 or {}).get("counts") or {}).get("data_rows") or ((run0 or {}).get("counts") or {}).get("grid_rows") or 0
        if after and run0 and str(run0.get("status")) == "OK" and age0 is not None and age0 <= max_age and rows0:
            # CheckList 체인: 바로 앞 asis_live_auto.py 가 만든(또는 재사용한) 기본 실측에 행이 있으면 그대로 쓴다 — 런처를 한 번 덜 띄운다
            st.append({"step": "기본 실측(열기·조회·덤프·호출)", "rc": None, "sec": 0, "note": "앞 단계 실측 사용(%s · 행 %s)" % (str(run0.get("started"))[:16], rows0)})
            print("\n[실측 1] 기본 실측 — 앞 단계 실측 사용(%s · 행 %s)" % (str(run0.get("started"))[:16], rows0), flush=True)
            out["basic"] = {"reused": True, "started": run0.get("started"), "rows": rows0}; rc_b = 0; reuse_basic = True
        else:
            # 실측이 없거나 조회 결과가 0행(필수 조건이 비어 조회가 안 된 경우 포함) → 필수 조건을 최근 값으로 채워 다시 측정
            reuse_basic = False
            rc_b = step(st, "기본 실측(열기·필수 조건 최근 값·조회·덤프·호출)", [T("asis_live_batch.py"), "--fill", "recent", "--find-timeout", "900", "--only", mid])
        opened = False                                           # 이번 실행에서 실제로 열렸는지 = 일괄 표의 이 화면 행(예전 실측 파일로 판단하지 않는다)
        try:
            if reuse_basic: raise StopIteration
            import csv
            with open(P("Doc", "asislive", "_summary.csv"), encoding="utf-8-sig", newline="") as f:
                row = next((r for r in csv.DictReader(f) if r.get("id") == mid), {})
            opened = str(row.get("opened", "")).strip().upper() in ("Y", "TRUE", "1") and str(row.get("measured_at", "")) >= out["at"][:16]
            out["basic"] = {k: row.get(k) for k in ("status", "why", "opened", "find_how", "total", "grid_rows", "calls_find", "dialogs", "measured_at")}
        except StopIteration:
            opened = True
        except Exception as ex:
            out["basic"] = {"error": str(ex)[:150]}
        if rc_b in (3, 5) or not opened:
            out.update(status="ERROR", note="기본 실측 실패(rc %s) — 화면을 열지 못했거나 환경 미비" % rc_b); save(mid, out); print("[ERROR] " + out["note"]); return 3
        step(st, "소스 분기 시나리오 도출", [T("asis_live_scen_src.py"), mid], 600)
        step(st, "분기 실행 현황(실행 전)", [T("asis_live_scen_cov.py"), mid], 600)
        if buttons:
            step(st, "버튼 분기 실행(팝업·메시지·Excel 기록 후 닫기)", [T("asis_live_scen_run.py"), mid])
            # "수정모드가 아니므로 …" 메시지를 낸 버튼은 수정 모드에서 다시 눌러야 그 분기가 실행된다(없으면 런처를 띄우지 않고 끝난다 · 닫을 때 저장하지 않음)
            step(st, "버튼 분기 실행 — 수정 모드 재실행", [T("asis_live_scen_run.py"), mid, "--edit"])
            step(st, "조건 값 변경 분기 실행(콤보·체크 상자·체크 목록)", [T("asis_live_scen_run.py"), mid, "--conds"])
            step(st, "셀 클릭·더블클릭 분기 실행(조건식이 요구하면 수정 모드에서 한 번 더)", [T("asis_live_scen_run.py"), mid, "--cells"])
            step(st, "셀 값 입력·시트 전환 분기 실행(수정 모드 첫 행 입력, 저장 없이 닫음)", [T("asis_live_scen_input.py"), mid])
            step(st, "스크롤·키 입력·붙여넣기 분기 실행(처리기 직접 호출, 저장 없이 닫음)", [T("asis_live_scen_event.py"), mid])
            step(st, "조건식에서 도출한 Division·그룹·조회 조건 값으로 실행", [T("asis_live_scen_values.py"), mid, "--run"], 3600)
            step(st, "저장 정의 초안 생성(SP 원문·DB 키·그리드 열)", [T("asis_live_save_draft.py"), mid], 600)
            if not os.path.exists(P("Doc", "asislive", mid, "save_scenario.json")):
                step(st, "저장 정의 초안 연습 실행(셀 입력·변경 표시 확인, 저장 안 함)", [T("asis_live_save.py"), mid, "--draft", "--dry"])
        step(st, "분기 실행 현황", [T("asis_live_scen_cov.py"), mid], 600)
        if os.path.isdir(P("Doc", "verify", mid, "calls")): step(st, "TO-BE 조회 조건 대조", [T("asis_live_cond.py"), mid], 600)
        else: st.append({"step": "TO-BE 조회 조건 대조", "rc": None, "sec": 0, "note": "TO-BE 호출 기록(Doc/verify/%s/calls) 없음 — 건너뜀" % mid})
        step(st, "분기별 AS-IS↔TO-BE 대조(TO-BE 룰 조회 포함)", [T("asis_live_scen_cmp.py"), mid], 600)
        step(st, "그룹·Division 별 비교표", [T("asis_live_scen_matrix.py"), mid], 600)
        step(st, "진입 경로 없는 분기 분류(현행 소스 원문 재검색)", [T("asis_live_scen_unreached.py"), mid], 600)
        step(st, "분기 시나리오 명세(전 분기)", [T("asis_live_scen_spec.py"), mid], 600)
        if os.path.exists(P("Doc", "asislive", mid, "save_scenario.json")): step(st, "AS-IS↔TO-BE 저장 인자 대조", [T("asis_live_save_cmp.py"), mid], 600)   # 저장 실행 자체는 묶음에 넣지 않는다(DB 에 쓰는 작업 — 메뉴로 따로)
        bad = [s for s in st if s["rc"] not in (0, None)]
        out["status"] = "OK" if not bad else "PARTIAL"; out["end"] = now()
        if out["status"] == "OK":  # 2026-11-20 이 묶음이 어느 원장 기준인지 남김(다음 실행 재사용 판단 · asis_fp.py)
            try:
                sys.path.insert(0, P("tools", "Harness", "verify")); import asis_fp; asis_fp.record(mid, "bundle", "screen_bundle")
            except Exception as _e: print("[원장 지문 기록 실패] %s" % _e)
        save(mid, out)
        print("\n[%s] %s AS-IS 런처 실측 묶음 · 단계 %d · 실패 %d%s · %ds" % (out["status"], mid, len(st), len(bad), (" (" + ", ".join("%s rc=%s" % (s["step"][:14], s["rc"]) for s in bad) + ")") if bad else "", sum(s["sec"] for s in st)))
        print("@@LINK 📂 AS-IS 실측|Doc/asislive/%s" % mid)
        return 0 if not bad else 2
    finally:
        unlock()


if __name__ == "__main__":
    sys.exit(main())
