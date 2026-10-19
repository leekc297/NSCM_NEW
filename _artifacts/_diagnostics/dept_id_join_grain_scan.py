# -*- coding: utf-8 -*-
"""hook #150 §5-5 / G150-3 판정기 — SCM_MST_SITE_ITEM 참조의 조인 grain 을 실측한다.

무엇을 보는가
  DEPT_ID 산출에서 `SCM_MST_SITE_ITEM` 을 (DIVISION_ID, SCM_SITE_ID) 단독으로 조인하면
  PK(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID) 의 나머지 축만큼 행이 증식한다
  (실측 2026-09-07: 키당 최대 3,506행 / 최대 30 DEPT_ID).
  hook #150 §3 은 이런 지점에 MAX(DEPT_ID) 로 키당 1건을 요구한다.

판정 방법
  - USER_SOURCE 를 읽고 **LIVE 라인만** 본다 (주석 라인 제외 — hook #138).
  - `SCM_MST_SITE_ITEM` 이 나온 라인부터 이후 LIVE 12 라인을 창(window)으로 잡아
    `.DIVISION_ID =` / `.SCM_SITE_ID =` / `.PROJECT_CODE =` / `.ITEM_ID =` 조인키를 수집한다.
  - 창 안에 MAX( 또는 GROUP BY 가 있으면 1건 보장 장치가 있는 것으로 보고 OK 로 분류한다.

출력 판정
  VIOLATION : JOINKEYS = DIVISION_ID+SCM_SITE_ID 인데 MAX/GROUP BY 없음  -> §5-5 위반 (G150-3 FAIL)
  PK        : PK 4키 확보 -> §3-3 (MAX 불필요, 그 행의 DEPT_ID 유지)
  OK(MAX)   : (DIV,SITE) grain 이지만 MAX/GROUP BY 로 1건 보장
  PARTIAL   : 그 외 부분 grain -> 육안 판정 필요

한계 (명시)
  창 기반 휴리스틱이라 조인키가 12 LIVE 라인 밖에 흩어져 있으면 놓칠 수 있다.
  VIOLATION / PARTIAL 로 나온 지점은 반드시 원문을 읽고 확정할 것 — 이 도구는 후보 축소용이다.

사용
  python _artifacts/_diagnostics/dept_id_join_grain_scan.py PKG_DMF0020 PKG_DMF0082
  python _artifacts/_diagnostics/dept_id_join_grain_scan.py --all          # DEPT_ID 참조 객체 전수
  python _artifacts/_diagnostics/dept_id_join_grain_scan.py --all --violation-only
  python _artifacts/_diagnostics/dept_id_join_grain_scan.py --file path/to/PKG.sql   # 배포 전 파일 검사(DB 접속 불요)
"""
import os
import re
import sys
import pathlib

import oracledb

PK = ("DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID")
WINDOW = 12


def _connect():
    """접속 정보 = 환경변수 NSCM_ORA_* 우선, 없으면 프로젝트 루트 .env.asis (ora.py 와 동일 규약)."""
    user = os.environ.get("NSCM_ORA_USER")
    pw = os.environ.get("NSCM_ORA_PASS")
    dsn = os.environ.get("NSCM_ORA_DSN")
    if not (user and pw and dsn):
        root = pathlib.Path(__file__).resolve().parents[2]
        env = {}
        for ln in open(root / ".env.asis", encoding="utf-8"):
            ln = ln.strip()
            if "=" in ln and not ln.startswith("#"):
                k, v = ln.split("=", 1)
                env[k] = v
        user = env["TOBE_DB_USER"]
        pw = env["TOBE_DB_PASS"]
        dsn = f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}"
    return oracledb.connect(user=user, password=pw, dsn=dsn)


def _is_live(text):
    """주석 라인 제외 (hook #138 — 주석은 근거도 적용 대상도 아니다)."""
    s = text.strip()
    return bool(s) and not s.startswith("--")


def scan_object(cur, name):
    cur.execute(
        "SELECT TYPE, LINE, TEXT FROM USER_SOURCE WHERE NAME=:1 ORDER BY TYPE, LINE", [name]
    )
    rows = [(t, ln, (tx or "").rstrip("\n")) for t, ln, tx in cur]
    if not rows:
        return []
    out = []
    for i, (typ, line, text) in enumerate(rows):
        if not _is_live(text):
            continue
        # 단어 경계 필수 — `GT_DM22_SCM_MST_SITE_ITEM` 같은 **GTT 사본**이 이름 포함으로 걸리던 오탐 차단
        #   (2026-09-07 실측: PKG_DMF0022 L1796 INSERT INTO GTT 가 VIOLATION 오판정 → 실제 원천은 PK 4키 조인)
        if not re.search(r"(?<![A-Za-z0-9_])SCM_MST_SITE_ITEM", text, re.I):
            continue
        win, j, taken = [], i + 1, 0
        while j < len(rows) and taken < WINDOW:
            if rows[j][0] == typ and _is_live(rows[j][2]):
                win.append(rows[j][2])
                taken += 1
            j += 1
        blob = (text + " " + " ".join(win)).upper()
        keys = {k for k in PK if re.search(r"\." + k + r"\s*=", blob)}
        guarded = bool(re.search(r"\bMAX\s*\(", blob) or re.search(r"\bGROUP\s+BY\b", blob))
        if keys == set(PK):
            verdict = "PK"
        elif keys == {"DIVISION_ID", "SCM_SITE_ID"}:
            verdict = "OK(MAX)" if guarded else "VIOLATION"
        else:
            verdict = "PARTIAL"
        out.append(
            {
                "object": name,
                "type": typ,
                "line": line,
                "keys": "+".join(sorted(keys)) or "-",
                "guarded": guarded,
                "verdict": verdict,
                "src": text.strip()[:88],
            }
        )
    return out


def scan_file(path):
    """배포 전 .sql 파일 검사 — DB 접속 없이 같은 판정을 적용한다."""
    name = pathlib.Path(path).name
    raw = pathlib.Path(path).read_text(encoding="utf-8", errors="replace").split("\n")
    rows = [("FILE", i + 1, ln.rstrip()) for i, ln in enumerate(raw)]
    out = []
    for i, (typ, line, text) in enumerate(rows):
        if not _is_live(text):
            continue
        # 단어 경계 필수 — `GT_DM22_SCM_MST_SITE_ITEM` 같은 **GTT 사본**이 이름 포함으로 걸리던 오탐 차단
        #   (2026-09-07 실측: PKG_DMF0022 L1796 INSERT INTO GTT 가 VIOLATION 오판정 → 실제 원천은 PK 4키 조인)
        if not re.search(r"(?<![A-Za-z0-9_])SCM_MST_SITE_ITEM", text, re.I):
            continue
        win, j, taken = [], i + 1, 0
        while j < len(rows) and taken < WINDOW:
            if _is_live(rows[j][2]):
                win.append(rows[j][2])
                taken += 1
            j += 1
        blob = (text + " " + " ".join(win)).upper()
        keys = {k for k in PK if re.search(r"\." + k + r"\s*=", blob)}
        guarded = bool(re.search(r"\bMAX\s*\(", blob) or re.search(r"\bGROUP\s+BY\b", blob))
        if keys == set(PK):
            verdict = "PK"
        elif keys == {"DIVISION_ID", "SCM_SITE_ID"}:
            verdict = "OK(MAX)" if guarded else "VIOLATION"
        else:
            verdict = "PARTIAL"
        out.append({"object": name, "type": typ, "line": line, "keys": "+".join(sorted(keys)) or "-",
                    "guarded": guarded, "verdict": verdict, "src": text.strip()[:88]})
    return out


def main(argv):
    args = [a for a in argv if not a.startswith("--")]
    all_mode = "--all" in argv
    vio_only = "--violation-only" in argv

    if "--file" in argv:
        paths = argv[argv.index("--file") + 1:]
        paths = [p for p in paths if not p.startswith("--")]
        if not paths:
            print("--file 뒤에 .sql 경로가 필요합니다")
            return 2
        findings = []
        for p in paths:
            findings.extend(scan_file(p))
        return _report(findings, len(paths), vio_only)

    cn = _connect()
    cur = cn.cursor()
    if all_mode:
        cur.execute(
            "SELECT DISTINCT NAME FROM USER_SOURCE "
            " WHERE UPPER(TEXT) LIKE '%SCM_MST_SITE_ITEM%' "
            "   AND NAME IN (SELECT NAME FROM USER_SOURCE WHERE UPPER(TEXT) LIKE '%DEPT_ID%') "
            " ORDER BY NAME"
        )
        names = [r[0] for r in cur]
    else:
        names = args
    if not names:
        print(__doc__)
        return 2
    findings = []
    for n in names:
        findings.extend(scan_object(cur, n))
    cn.close()
    return _report(findings, len(names), vio_only)


def _report(findings, n_targets, vio_only):
    shown = [f for f in findings if not vio_only or f["verdict"] == "VIOLATION"]
    print(f"{'VERDICT':10} {'OBJECT':46} {'LINE':>6} {'JOINKEYS':44} SRC")
    for f in shown:
        print(f"{f['verdict']:10} {f['object']:46} {f['line']:6} {f['keys']:44} {f['src']}")

    tally = {}
    for f in findings:
        tally[f["verdict"]] = tally.get(f["verdict"], 0) + 1
    print(
        f"\n대상 {n_targets} · LIVE 참조 {len(findings)} — "
        + " / ".join(f"{k}={v}" for k, v in sorted(tally.items()))
    )
    nv = tally.get("VIOLATION", 0)
    print(
        f"G150-3 : {'FAIL' if nv else 'PASS'} (VIOLATION {nv})"
        + ("  ※ PARTIAL 은 육안 확정 필요" if tally.get("PARTIAL") else "")
    )
    return 1 if nv else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
