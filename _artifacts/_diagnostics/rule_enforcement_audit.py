# -*- coding: utf-8 -*-
"""rule_enforcement_audit.py — 룰 실행력 감사 (2026-08-31 신설, 사용자 지시
"기존 Rule 들도 전체적으로 제대로 적용이 되도록, 누락되는 부분이 없도록 보완조치")

원칙 (hook #148 §4.8): "hook 본문의 의무는 생성기/게이트 코드에 있을 때만 룰이다."
본 도구는 그 역방향을 기계 감사한다:
  [A] 전 hook 본문이 참조하는 실행 산출물(_artifacts/*.py|sql|ps1|mjs·.claude/hooks/*.ps1) 실존 여부
  [B] 실행력-핵심 hook 의 "의무 마커"가 지목된 코드 파일 안에 실존하는지 (큐레이션 목록 — 신설 hook 마다 여기 등재)
출력: _artifacts/_gate_reports/rule_enforcement_audit_<ts>.md  (GAP = 부재 항목 — 즉시 보완 대상)

사용:  python rule_enforcement_audit.py            # 전체 감사 + 리포트
       python rule_enforcement_audit.py --quiet    # GAP 만 출력 (CI 성)
"""
import io, re, sys, glob, pathlib, datetime

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
ROOT = pathlib.Path(r"C:\Projects\NSCM")
HOOKS = ROOT / "Doc" / "_rules_v2" / "hooks"
REPORTS = ROOT / "_artifacts" / "_gate_reports"

# ── [B] 실행력-핵심 의무 큐레이션 (hook → (코드 파일 glob, 필수 마커[전부 존재해야 PASS])) ──
#    ⭐ 신설 hook 이 "게이트/생성기 의무" 를 선언하면 이 표에 함께 등재한다 (등재 누락 = 본 감사의 GAP 아님 — 리뷰 축).
OBLIGATIONS = [
    ("#133 ui-common-testitem-mapping-axis", "_artifacts/_diagnostics/asis_mapping_gate.py", ["UI_COMMON_ITEMS"]),
    ("#139 request-ledger-and-subclause-mapping", "_artifacts/_diagnostics/asis_mapping_gate.py",
     ["REQUEST_LEDGER", "parse_request_ledger", "보완요청_원장"]),
    ("#149 remediation-closure-symptom-reproduction", "_artifacts/_diagnostics/asis_mapping_gate.py",
     ["G149", "재현", "해소"]),
    ("#148 cloud-deploy-silent-failure-gates (생성기 G1~G5)", "_artifacts/_diagnostics/_ui_cloud_pkg_build_20260831.py",
     ["40_GRANT_SYNONYM", "22A_SHEET_META_DEP_PROGRAMS", "V11", "V12", "V13", "V14"]),
    ("#148+ONKEY 무PK MERGE 논리키 폴백 (2026-08-31)", "_artifacts/_diagnostics/_ui_cloud_pkg_build_20260831.py",
     ["LOGICAL_KEY_FALLBACK"]),
    ("#125 ui-selfcheck-runtime-mandatory (HTTP E2E 러너)", "_artifacts/_diagnostics/ui_http_e2e.py", []),
    ("#145 verification-evidence-and-scale (증거 게이트)", "_artifacts/_diagnostics/asis_mapping_evidence/verify_mapping_evidence.py", []),
    ("#138 comment-live-code-discrimination (전처리기)", "_artifacts/_diagnostics/strip_code_comments.py", []),
    ("#142 ui-meta-dictionary-mandatory (검증기)", "_artifacts/_diagnostics/ui_meta_dictionary_20260821/06_verify.py", []),
    ("screen-completion-gate (러너)", "_artifacts/_diagnostics/ui_gate_runner.py", []),
    ("wiring-chain (배선 체인 실측)", "_artifacts/_diagnostics/wiring_chain_check.py", []),
    ("#98 §6.2-T 실행 hook (메타 SQL 차단)", ".claude/hooks/check-meta-sql.ps1", []),
    ("실행 hook (UI 게이트 G-A~G-E)", ".claude/hooks/check-ui-gates.ps1", []),
    ("Excel Upload 검증 시트 표준 (2026-08-31 — 기대값=실측·일자 동적)", "_artifacts/_diagnostics/gen_excel_upload_testcases.py",
     ["E20260831-REGEN"]),
    ("Excel Upload 케이스 러너", "_artifacts/_diagnostics/excel_upload_case_e2e.py", ["E20260831-REGEN"]),
]

RE_REF = re.compile(r"(?:`|\b)((?:_artifacts|\.claude/hooks)/[\w\-./가-힣]+?\.(?:py|sql|ps1|sh|mjs))(?:`|\b)")
SKIP_REF_HINTS = ("DEPRECATED", "구 ", "폐기", "예시", "예:")


def newest(globpat):
    hits = sorted(glob.glob(str(ROOT / globpat)))
    return hits[-1] if hits else None


def main():
    quiet = "--quiet" in sys.argv
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M")
    gaps, ok_refs, ref_rows = [], 0, []

    # [A] hook 본문 참조 실행 산출물 실존 스윕
    seen = set()
    for md in sorted(HOOKS.glob("*.md")):
        text = md.read_text(encoding="utf-8", errors="replace")
        for m in RE_REF.finditer(text):
            rel = m.group(1).strip("`")
            key = (md.name, rel)
            if key in seen:
                continue
            seen.add(key)
            line_ctx = text[max(0, m.start() - 60):m.start()]
            if any(h in line_ctx for h in SKIP_REF_HINTS):
                continue
            exists = (ROOT / rel).exists()
            if not exists and "*" in rel:
                exists = bool(glob.glob(str(ROOT / rel)))
            ref_rows.append((md.name, rel, exists))
            if exists:
                ok_refs += 1
            else:
                gaps.append(f"[A] {md.name} → `{rel}` 부재")

    # [B] 의무 마커 검사
    ob_rows = []
    for name, rel, markers in OBLIGATIONS:
        p = ROOT / rel
        if not p.exists():
            cand = newest(rel)
            p = pathlib.Path(cand) if cand else p
        if not p.exists():
            ob_rows.append((name, rel, "파일 부재", "GAP"))
            gaps.append(f"[B] {name}: `{rel}` 부재")
            continue
        body = p.read_text(encoding="utf-8", errors="replace")
        missing = [mk for mk in markers if mk not in body]
        if missing:
            ob_rows.append((name, rel, "마커 부재: " + ", ".join(missing), "GAP"))
            gaps.append(f"[B] {name}: `{rel}` 에 마커 {missing} 부재")
        else:
            ob_rows.append((name, rel, f"마커 {len(markers)}종 실존" if markers else "파일 실존", "PASS"))

    REPORTS.mkdir(parents=True, exist_ok=True)
    rep = REPORTS / f"rule_enforcement_audit_{ts}.md"
    with open(rep, "w", encoding="utf-8") as f:
        f.write(f"# 룰 실행력 감사 — {ts} (`rule_enforcement_audit.py`)\n\n")
        f.write(f"- [A] hook 본문 참조 실행 산출물: {len(ref_rows)}건 중 실존 {ok_refs} / 부재 {len(ref_rows)-ok_refs}\n")
        f.write(f"- [B] 실행력-핵심 의무 마커: {len(ob_rows)}건 중 GAP {sum(1 for r in ob_rows if r[3]=='GAP')}\n")
        f.write(f"- **GAP 총 {len(gaps)}건** — 즉시 보완 대상 (hook #148 §4.8: 코드에 없으면 룰이 아니다)\n\n")
        f.write("## [B] 의무 마커\n\n| 의무 | 코드 | 판정 | 결과 |\n|---|---|---|---|\n")
        for n, r, d, v in ob_rows:
            f.write(f"| {n} | `{r}` | {d} | **{v}** |\n")
        f.write("\n## [A] 참조 부재 (GAP 만)\n\n")
        a_gaps = [g for g in gaps if g.startswith("[A]")]
        f.write("\n".join(f"- {g}" for g in a_gaps) if a_gaps else "- 없음\n")
        f.write("\n\n## GAP 전체\n\n" + ("\n".join(f"- {g}" for g in gaps) if gaps else "- 없음") + "\n")

    if not quiet:
        print(f"[A] 참조 {len(ref_rows)} (실존 {ok_refs}) / [B] 의무 {len(ob_rows)}")
    for g in gaps:
        print("GAP:", g)
    print("report:", rep)
    return 1 if gaps else 0


if __name__ == "__main__":
    sys.exit(main())
