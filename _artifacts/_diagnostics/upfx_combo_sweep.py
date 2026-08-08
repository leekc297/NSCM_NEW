#!/usr/bin/env python3
"""upfx_combo_sweep.py — 전 화면 UP_FX 콤보 파라미터 정합 진단 스윕 (2026-08-08 신설)

배경: AS-IS 는 콤보 데이터를 3계통(BigFilter / UP_FX_GetCommonDataList_DM / 기본판 은닉 호출)으로
      얻는데, TO-BE 는 UP_FX 계통의 **파라미터·분기** 축이 광범위하게 누락됐을 가능성이 있다.
      DMF0082 실측에서 9건이 나왔으므로 전 화면 규모를 먼저 **읽기 전용**으로 파악한다.

동작: ①FE `MENU_ID = 'XXX'` 상수로 화면↔페이지 폴더 매핑을 실측 수집
      ②각 화면의 셀 콤보(SHEET_COLUMNS, FPComboBox)를 DB 에서 수집
      ③ui_gate_runner 섹션 7 로직(토큰 대사·quoting·빈 catch)을 그대로 재사용해 판정
      ④화면 × SQL_ID × 토큰 × 판정 매트릭스를 md 로 산출

⚠️ 코드 수정 0 — 진단만. 실제 수정은 각 화면 작업 시점(T01M)에 적용 (hook #91 방식).

사용: python upfx_combo_sweep.py [--out <경로>]
"""
import argparse
import datetime
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import ui_gate_runner as G  # noqa: E402
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
FEATURES = ROOT / "nscm-fe" / "features"
MENU_ID_RE = re.compile(r"export\s+const\s+MENU_ID\s*=\s*'([^']+)'")


def collect_pages():
    """FE 페이지 폴더 ↔ MENU_ID 매핑 실측 (하드코딩 금지)."""
    out = {}
    for f in FEATURES.rglob("*.constants.ts"):
        m = MENU_ID_RE.search(f.read_text(encoding="utf-8", errors="ignore"))
        if m:
            out.setdefault(m.group(1), f.parent)
    return dict(sorted(out.items()))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out")
    args = ap.parse_args()

    import oracledb

    pages = collect_pages()
    u, p, d = conn_info()
    rows, totals = [], {"FAIL": 0, "WARN": 0, "PASS": 0}
    quote_all, catch_all, no_param_pages = [], [], []

    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        sql_cache = {}
        for menu, page_dir in pages.items():
            cur.execute(
                """SELECT DISTINCT C.CELL_COMBO_DATA_TYPE
                     FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                    WHERE C.PROGRAM_ID = :m
                      AND TRIM(C.CELL_COMBO_DATA_TYPE) IS NOT NULL
                      AND C.CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox'
                      AND NVL(C.VALID_YN,'Y') = 'Y'
                    ORDER BY 1""",
                {"m": menu},
            )
            cids = [r[0] for r in cur.fetchall()]
            if not cids:
                continue
            gp, bc, qv, cv, dyn = G._scan_combo_calls(page_dir)
            quote_all += [(menu,) + v for v in qv]
            catch_all += [(menu,) + v for v in cv]
            for cid in cids:
                if cid not in sql_cache:
                    cur.execute(
                        "SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s",
                        {"s": cid},
                    )
                    r = cur.fetchone()
                    sql_cache[cid] = (
                        (r[0].read() if hasattr(r[0], "read") else str(r[0])) if r else None
                    )
                sql = sql_cache[cid]
                if sql is None:
                    rows.append((menu, cid, "(미등록)", "-", "⛔ FAIL", "CMBO 미등록"))
                    totals["FAIL"] += 1
                    continue
                toks = set(re.findall(r"@(\w+)", sql))
                need = sorted(toks - G.COMBO_SERVER_TOKENS)
                if not need:
                    continue  # 파라미터 없는 콤보 = 검사 대상 아님
                prov = gp | bc.get(cid, set()) | dyn
                miss = [t for t in need if t not in prov]
                strict = [t for t in miss if not G._token_is_lenient(sql, t)]
                if strict:
                    v, note = "⛔ FAIL", "비관대형 미전달 → 0행(코드 raw 표시)"
                    totals["FAIL"] += 1
                elif miss:
                    v, note = "⚠ WARN", "관대형 미전달 → 무필터(전체 목록)"
                    totals["WARN"] += 1
                else:
                    v, note = "✅ PASS", ""
                    totals["PASS"] += 1
                rows.append((menu, cid, ", ".join(need), ", ".join(miss) or "-", v, note))
            if not gp and not bc:
                no_param_pages.append(menu)

    ts = datetime.datetime.now()
    out = pathlib.Path(args.out) if args.out else (
        ROOT / "_artifacts" / "_gate_reports" / f"UPFX_COMBO_PARITY_SWEEP_{ts:%Y%m%d_%H%M}.md"
    )
    L = [
        "# 전 화면 UP_FX 콤보 파라미터 정합 — 진단 매트릭스",
        "",
        f"> 실행 {ts:%Y-%m-%d %H:%M} · `_artifacts/_diagnostics/upfx_combo_sweep.py` · **읽기 전용(코드 수정 0)**",
        "> 룰 = hook #117 §5.5~§5.10 · 판정 로직 = `ui_gate_runner.py` 섹션 7 재사용",
        "> 수정은 각 화면 작업 시점(T01M)에 적용한다 — 일괄 소급 작업 아님(#124 §3 방식).",
        "",
        "## 판정 기준",
        "",
        "BE `BaseService.makeComboQuery` 는 `@토큰` 을 **raw 치환**하고 미전달 토큰을 `''` 로 채운다.",
        "Oracle 에서 `''` = NULL 이므로:",
        "",
        "- **FAIL** — 비관대형(`COL = @t`) + 미전달 → **0행**. 콤보가 비고 그리드는 CODE 를 raw 로 표시한다.",
        "- **WARN** — 관대형(`@t IS NULL OR …` / `NVL(TRIM(@t),'ALL')='ALL' OR …` / `CASE @t …`) + 미전달 → 무필터(전체 목록).",
        "  AS-IS 가 실제로 필터했는지 대조 필요(과다 노출은 저장값 오염으로 이어질 수 있음).",
        "- **PASS** — 필요 토큰 전부 전달.",
        "",
        f"## 요약 — FAIL **{totals['FAIL']}** / WARN **{totals['WARN']}** / PASS **{totals['PASS']}** "
        f"(화면 {len({r[0] for r in rows})}개 · 파라미터 보유 콤보 {len(rows)}건)",
        "",
    ]
    fails = [r for r in rows if "FAIL" in r[4]]
    if fails:
        L += ["### ⛔ FAIL (0행 = 조용한 빈 콤보)", "",
              "| 화면 | SQL_ID | 필요 토큰 | 미전달 | 사유 |", "|---|---|---|---|---|"]
        L += [f"| {m} | {c} | {n} | {ms} | {no} |" for m, c, n, ms, _, no in fails]
        L.append("")
    warns = [r for r in rows if "WARN" in r[4]]
    if warns:
        L += ["### ⚠ WARN (관대형 무전달 = 무필터)", "",
              "| 화면 | SQL_ID | 필요 토큰 | 미전달 |", "|---|---|---|---|"]
        L += [f"| {m} | {c} | {n} | {ms} |" for m, c, n, ms, _, _ in warns]
        L.append("")
    if quote_all:
        L += ["### ⛔ quoting 누락 (hook #117 §5.7 — ORA-00904/01722)", "",
              "| 화면 | 파일 | SQL_ID | 키 | 값 |", "|---|---|---|---|---|"]
        L += [f"| {m} | `{f}` | {c} | `{k}` | `{v}` |" for m, f, c, k, v in quote_all]
        L.append("")
    if catch_all:
        L += ["### ⛔ 조용한 실패 (빈 .catch — hook #117 §5.8)", "",
              "| 화면 | 파일 | SQL_ID |", "|---|---|---|"]
        L += [f"| {m} | `{f}` | {c} |" for m, f, c in catch_all]
        L.append("")
    L += ["### 전체 매트릭스", "",
          "| 화면 | SQL_ID | 필요 토큰 | 미전달 | 판정 |", "|---|---|---|---|---|"]
    L += [f"| {m} | {c} | {n} | {ms} | {v} |" for m, c, n, ms, v, _ in rows]
    L += ["", "### 한계",
          "- FE 정적 파싱 기준: `comboId` 가 변수인 호출(설정 맵 경유)은 페이지 단위로만 귀속되어 판정이 완화된다.",
          "- `SHEET_COLUMNS` 에 `FPComboBox` 로 등록된 셀 콤보만 대상. 조회조건 콤보(SearchFields 카탈로그)와",
          "  `FPModal` 키(모달 검색 API)는 제외 — 각각 hook #112 / 모달 배선 축에서 다룬다.",
          f"- FE 페이지를 찾지 못한 PROGRAM_ID 는 매트릭스에서 빠진다(MENU_ID 상수 미보유 화면).",
          ""]
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(L) + "\n", encoding="utf-8")
    print(f"FAIL {totals['FAIL']} / WARN {totals['WARN']} / PASS {totals['PASS']}")
    print(f"quoting 누락 {len(quote_all)} / 빈 catch {len(catch_all)}")
    print(f"리포트: {out}")


if __name__ == "__main__":
    main()
