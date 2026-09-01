# 룰 실행력 감사 — 20260831_1539 (`rule_enforcement_audit.py`)

- [A] hook 본문 참조 실행 산출물: 45건 중 실존 45 / 부재 0
- [B] 실행력-핵심 의무 마커: 15건 중 GAP 0
- **GAP 총 0건** — 즉시 보완 대상 (hook #148 §4.8: 코드에 없으면 룰이 아니다)

## [B] 의무 마커

| 의무 | 코드 | 판정 | 결과 |
|---|---|---|---|
| #133 ui-common-testitem-mapping-axis | `_artifacts/_diagnostics/asis_mapping_gate.py` | 마커 1종 실존 | **PASS** |
| #139 request-ledger-and-subclause-mapping | `_artifacts/_diagnostics/asis_mapping_gate.py` | 마커 3종 실존 | **PASS** |
| #149 remediation-closure-symptom-reproduction | `_artifacts/_diagnostics/asis_mapping_gate.py` | 마커 3종 실존 | **PASS** |
| #148 cloud-deploy-silent-failure-gates (생성기 G1~G5) | `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260831.py` | 마커 6종 실존 | **PASS** |
| #148+ONKEY 무PK MERGE 논리키 폴백 (2026-08-31) | `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260831.py` | 마커 1종 실존 | **PASS** |
| #125 ui-selfcheck-runtime-mandatory (HTTP E2E 러너) | `_artifacts/_diagnostics/ui_http_e2e.py` | 파일 실존 | **PASS** |
| #145 verification-evidence-and-scale (증거 게이트) | `_artifacts/_diagnostics/asis_mapping_evidence/verify_mapping_evidence.py` | 파일 실존 | **PASS** |
| #138 comment-live-code-discrimination (전처리기) | `_artifacts/_diagnostics/strip_code_comments.py` | 파일 실존 | **PASS** |
| #142 ui-meta-dictionary-mandatory (검증기) | `_artifacts/_diagnostics/ui_meta_dictionary_20260821/06_verify.py` | 파일 실존 | **PASS** |
| screen-completion-gate (러너) | `_artifacts/_diagnostics/ui_gate_runner.py` | 파일 실존 | **PASS** |
| wiring-chain (배선 체인 실측) | `_artifacts/_diagnostics/wiring_chain_check.py` | 파일 실존 | **PASS** |
| #98 §6.2-T 실행 hook (메타 SQL 차단) | `.claude/hooks/check-meta-sql.ps1` | 파일 실존 | **PASS** |
| 실행 hook (UI 게이트 G-A~G-E) | `.claude/hooks/check-ui-gates.ps1` | 파일 실존 | **PASS** |
| Excel Upload 검증 시트 표준 (2026-08-31 — 기대값=실측·일자 동적) | `_artifacts/_diagnostics/gen_excel_upload_testcases.py` | 마커 1종 실존 | **PASS** |
| Excel Upload 케이스 러너 | `_artifacts/_diagnostics/excel_upload_case_e2e.py` | 마커 1종 실존 | **PASS** |

## [A] 참조 부재 (GAP 만)

- 없음


## GAP 전체

- 없음
