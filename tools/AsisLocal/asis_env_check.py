# -*- coding: utf-8 -*-
"""AS-IS 로컬 실행 환경 점검 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P1)

  사용: python tools/AsisLocal/asis_env_check.py [화면ID]
  점검: ① 로컬 서버(8086) 응답 ② 런처 접속 주소 ③ 사본 DB 대상 = .env.asis 서버뿐인지
        ④(화면ID) 프로그램 등록·화면 DLL ⑤(화면ID) 화면이 부르는 FoxQuery id 정의 여부 ⑥ 제외 화면 여부
  종료코드: 0 정상 · 2 FAIL(이 화면은 실행 불가) · 3 미측정(환경 미비 — 점검 자체를 못 함) · 5 로컬 서버 미기동
  읽기 전용. DB 는 조회만 한다.
"""
import os, re, sys, glob, socket, urllib.request

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
GSCM = os.path.join(ROOT, "GSCM")
LAUNCH_DIR = os.path.join(GSCM, "02.Launcher", "GSCM.Launcher", "bin", "Debug")
WSL_COPY = os.path.join(GSCM, "_asis_local", "04.WSL")
PORT = 8086
# 사용자 결정(2026-11-12): 소스 없는 8개 = 제외 · SCP0034 = 미사용 예정
EXCLUDED = {"SSP0060": "소스 없음(제외)", "SSP0020": "소스 없음(제외)", "SCP0049": "소스 없음(제외 · SCP0049_CAPA_T)", "FP00599": "소스 없음(제외)",
            "FP00608": "소스 없음(제외)", "FP02846": "소스 없음(제외)", "SCM0010": "소스 없음(제외)", "SCP0200": "소스 없음(제외)", "SCP0034": "미사용 예정(제외)"}

for s in (sys.stdout, sys.stderr):
    try: s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass

rows = []
def add(item, status, detail): rows.append((item, status, detail)); print("[%s] %s — %s" % (status, item, detail), flush=True)

def env_asis():
    env = {}
    for line in open(os.path.join(ROOT, ".env.asis"), encoding="utf-8-sig"):
        line = line.strip()
        if "=" in line and not line.startswith("#"):
            k, v = line.split("=", 1); env[k.strip()] = v.strip().strip('"').strip("'")
    return env

def main():
    sid = sys.argv[1].strip().upper() if len(sys.argv) > 1 else ""
    worst = 0
    # ① 로컬 서버
    with socket.socket() as s:
        s.settimeout(2); up = s.connect_ex(("127.0.0.1", PORT)) == 0
    if not up:
        add("로컬 서버 %d" % PORT, "ERROR", "미기동 — VM '🖥 AS-IS IIS Start' 또는 tools/AsisLocal/asis_iis.cmd"); return 5
    try:
        code = urllib.request.urlopen("http://localhost:%d/GSCM.SystemMgmt.WSL/FoxDataService.svc" % PORT, timeout=90).status
        add("로컬 서버 %d" % PORT, "OK" if code == 200 else "ERROR", "GSCM.SystemMgmt.WSL HTTP %s" % code)
        if code != 200: worst = max(worst, 3)
    except Exception as e:
        add("로컬 서버 %d" % PORT, "ERROR", "서비스 응답 없음: %s" % str(e)[:120]); worst = max(worst, 3)
    # ② 런처 접속 주소
    try:
        t = re.sub(r"<!--.*?-->", "", open(os.path.join(LAUNCH_DIR, "ClientConfig.xml"), encoding="utf-8-sig", errors="ignore").read(), flags=re.S)
        m = re.search(r'<address\s+name="GSCM"\s+baseUrl="([^"]+)"', t); url = m.group(1) if m else ""
        ok = ("localhost:%d" % PORT) in url or ("127.0.0.1:%d" % PORT) in url
        add("런처 접속 주소", "OK" if ok else "ERROR", url or "읽지 못함"); worst = max(worst, 0 if ok else 3)
    except OSError as e:
        add("런처 접속 주소", "ERROR", str(e)); worst = max(worst, 3)
    # ③ 사본 DB 대상
    try:
        env = env_asis(); want = "%s,%s" % (env["ASIS_DB_HOST"], env["ASIS_DB_PORT"]); targets = {}
        for f in glob.glob(os.path.join(WSL_COPY, "**", "*.config"), recursive=True):
            t = re.sub(r"<!--.*?-->", "", open(f, encoding="utf-8-sig", errors="ignore").read(), flags=re.S)
            for m in re.finditer(r"(?:Data Source|server)\s*=\s*([^;\"'<]+)", t, re.I): targets[m.group(1).strip()] = targets.get(m.group(1).strip(), 0) + 1
        other = {k: v for k, v in targets.items() if k != want}
        add("사본 DB 대상", "OK" if targets and not other else "ERROR", "AS-IS MSSQL %s %d곳%s" % (want, targets.get(want, 0), (" · 그 외 %s" % other) if other else ""))
        if other or not targets: worst = max(worst, 3)
    except Exception as e:
        add("사본 DB 대상", "ERROR", str(e)[:160]); worst = max(worst, 3); env = None
    if not sid:
        return worst
    # ⑥ 제외 화면
    if sid in EXCLUDED:
        add("대상 화면", "NA", "%s = %s" % (sid, EXCLUDED[sid])); return max(worst, 2)
    # ④ 프로그램 등록·DLL
    dll_name = ""
    try:
        import pyodbc
        pw = env[next(k for k in env if k.startswith("ASIS_DB_") and re.search(r"PASS|PWD", k))]
        cn = pyodbc.connect("DRIVER={%s};SERVER=%s,%s;DATABASE=%s;UID=%s;PWD=%s;TrustServerCertificate=yes" % (
            env["ASIS_DB_DRIVER"], env["ASIS_DB_HOST"], env["ASIS_DB_PORT"], env["ASIS_DB_NAME"], env["ASIS_DB_USER"], pw), timeout=15)
        cur = cn.cursor(); cur.execute("SELECT ProgramID, ProgramPath FROM dbo.TB_FX_ProgramInfo WHERE ProgramID = ?", sid); prs = cur.fetchall(); cn.close()
        if not prs:
            add("프로그램 등록", "FAIL", "TB_FX_ProgramInfo 에 ProgramID=%s 없음" % sid); worst = max(worst, 2)
        for pid, path in prs:
            p = (path or "").strip(); ex = os.path.isfile(os.path.join(LAUNCH_DIR, p)); dll_name = os.path.basename(p.replace("\\", "/"))
            add("화면 DLL", "OK" if ex else "FAIL", "%s %s" % (p, "있음" if ex else "없음 — 빌드·배치 필요")); worst = max(worst, 0 if ex else 2)
    except Exception as e:
        add("프로그램 등록", "ERROR", "DB 조회 실패(미측정): %s" % str(e)[:160]); worst = max(worst, 3)
    # ⑤ FoxQuery id 정의
    try:
        defined = {}
        for f in glob.glob(os.path.join(WSL_COPY, "FoxQuery", "**", "*.foxml"), recursive=True):
            t = open(f, encoding="utf-8-sig", errors="ignore").read()
            defined[os.path.basename(f)[:-6].lower()] = {m.group(1).lower() for m in re.finditer(r'<\w+\s+id="([^"]+)"', t)}
        srcs = []
        stem = dll_name[:-4] if dll_name.lower().endswith(".dll") else sid
        for dp, dn, fn in os.walk(os.path.join(GSCM, "06.UIL")):
            dn[:] = [d for d in dn if d not in ("obj", "bin")]
            if any(f.lower() == stem.lower() + ".csproj" for f in fn):
                for dp2, dn2, fn2 in os.walk(dp):
                    dn2[:] = [d for d in dn2 if d not in ("obj", "bin")]
                    srcs += [os.path.join(dp2, f) for f in fn2 if f.endswith(".cs")]
        if not srcs:
            add("FoxQuery 정의", "ERROR", "화면 소스 폴더를 찾지 못함(미측정) — %s.csproj" % stem); worst = max(worst, 3)
        else:
            used = set()
            for f in srcs:
                t = open(f, encoding="utf-8-sig", errors="ignore").read()
                t = re.sub(r"/\*.*?\*/", "", t, flags=re.S); t = re.sub(r"//[^\n]*", "", t)
                used |= set(re.findall(r'FoxDataRequest\(\s*"([^"]+)"', t))
            miss = sorted(u for u in used if "." in u and u.split(".", 1)[1].lower() not in defined.get(u.split(".", 1)[0].lower(), set()))
            add("FoxQuery 정의", "OK" if not miss else "FAIL", "호출 %d종 중 미정의 %d%s" % (len(used), len(miss), (" — " + ", ".join(miss[:6])) if miss else ""))
            if miss: worst = max(worst, 2)
    except Exception as e:
        add("FoxQuery 정의", "ERROR", str(e)[:160]); worst = max(worst, 3)
    return worst

if __name__ == "__main__":
    rc = main()
    print("[%s] AS-IS 환경 점검 종료 (exit %d)" % ("OK" if rc == 0 else ("FAIL" if rc == 2 else "ERROR"), rc), flush=True)
    sys.exit(rc)
