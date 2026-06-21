# NSCM RULE 체계 진단 보고서 / Rule-System Diagnosis Report

> 작성일 / Date: 2026-06-18
> 범위 / Scope: `C:\Projects\NSCM` 하위 모든 RULE · HOOK (MD + 실행 스크립트) — 전체 룰(DB/SP/BE/UI)
> 목적 / Goal: TO-BE UI 개발·수정 시 RULE 누락 방지 — 중복·충돌·누락 식별 및 보완
> 짝 문서 / Companion: `RULESET_MASTER.md` (통합 마스터 룰 — Claude Code 인식 최적화)

---

## 0. 요약 (Executive Summary)

NSCM 의 룰 체계는 **성숙하고 내용 품질이 높다** (룰 v2 의 13 TO-BE 룰 + 69 hook + 20 트리거 매트릭스 + AS-IS framework 7 정밀 분석). 사고가 발생할 때마다 hook 으로 흡수하는 *meta-rule-evolution* 사이클이 잘 작동하고 있다.

그러나 **빠른 진화의 부작용으로 "메타 정합성(meta-integrity)" 결함**이 누적되었다. 룰 내용 자체보다 **카운트·진입점·v1/v2 경계·실행 강제(enforcement)의 불일치**가 핵심 리스크다. 이 결함들은 *"룰이 있는데도 누락되는"* 상황을 만든다 — 바로 사용자가 우려한 지점이다.

| 심각도 | 항목 | 영향 |
|---|---|---|
| 🔴 High | Hook 카운트 4중 불일치 (41 / 50 / 53 / **실제 69**) | AI·사람이 "전체 hook 로드"를 신뢰 불가 → 누락 |
| 🔴 High | 문서화 hook 69 vs 실행 강제 hook 5 의 괴리 | 64개 룰은 "AI 가 읽기를 기억해야만" 적용 → 자동 차단 불가 |
| 🔴 High | 진입점(CLAUDE.md) 이중화 — 루트 + `_rules_v2/` | 두 파일이 부분 중복·부분 상충 → 단일 진실 부재 |
| 🟡 Med | v1 룰 32 고아 (root CLAUDE 에 있고 v1 README·v2 CLAUDE 에 없음) | 유지 룰 7 vs 8 불일치 |
| 🟡 Med | 카탈로그 번호 무질서 (1~70, 결번·역순·retract) | 신규 hook 등재 시 충돌·누락 위험 |
| 🟡 Med | v1 `_dev_rules/hooks/` DEPRECATED 중복 잔존 | 개발자가 구버전 hook 을 읽을 위험 |
| 🟢 Low | 실행 스크립트 OS 잠금 (Windows ps1 전용, `block-dev-commands.sh` 부재) | 클라우드/Linux 환경 강제 누락 |
| 🟢 Low | `.claude/hooks/README.md` ↔ `settings.json` 불일치 (8 vs 5, 이벤트 오기재) | 문서 신뢰도 저하 |

> **핵심 결론**: 룰의 *내용*은 보완보다 **재정합(re-alignment)** 이 필요하다. 단일 진실 소스(Single Source of Truth) 1개와, 카운트 자동 검증 1개, 그리고 "문서 hook vs 실행 hook" 용어 분리만 확립하면 누락 리스크가 구조적으로 제거된다.

---

## 1. 룰 자산 인벤토리 (Inventory)

분석 대상은 4개 계층으로 나뉜다.

### 1.1 진입점 (Entry points) — 이중화 ⚠️
| 파일 | 라인 | 역할 | 문제 |
|---|---|---|---|
| `/CLAUDE.md` (루트) | 374 | Claude Code 가 **자동 로드**하는 최상위 컨텍스트 | v2 라우터 내용을 상당 부분 복제 + 자체 카운트(50/53) 보유 |
| `Doc/_rules_v2/CLAUDE.md` | 161 | 룰 v2 "분기 라우터" | 진입점 2 라 자칭하나, 루트 CLAUDE 가 실질 진입점 |
| `Doc/_rules_v2/00_INDEX.md` | ~190 | 트리거 매트릭스(20행) + hook 카탈로그(69) | 헤더 "53" 과 실제 69 불일치 |
| `Doc/_rules_v2/anti-simplification.md` | — | 최우선 불변 룰 | (정상 — 단일) |

> Claude Code 는 루트 `CLAUDE.md` 만 자동 인식한다. `_rules_v2/CLAUDE.md` 는 루트가 "읽어라"고 지시해야 로드된다. 즉 **진입점이 2개라는 사실 자체가 라우팅 혼선**의 근원.

### 1.2 룰 v2 (정본 / canonical)
- TO-BE 정밀 룰 13: `_tobe/01_file_structure ~ 13_routing_menu.md`
- AS-IS Framework 7: `_asis/00_framework/01~07.md`
- Hook 69: `_rules_v2/hooks/*.md` (실측)
- 매핑 1: `_mapping/asis_to_tobe.md` (10 격차 G1~G10)
- 메타: `meta-rule-evolution.md`

### 1.3 룰 v1 (`Doc/_dev_rules/`) — 일부 유지, 대부분 archive
- 유지 7 (또는 8): 02 / 21 / 22 / 28 / 29 / 30 / 31 (+ **32 고아**)
- archive 24: `_archive/00~27` (정상 흡수 — 검증됨)
- v1 `hooks/` 폴더: 26 .md — 6 이관 / 10 DEPRECATED 중복 / 8 미흡수

### 1.4 실행 강제 hook (`.claude/`) — 실제 동작하는 유일한 자동화
| 파일 | 이벤트 | 강제 내용 | Exit |
|---|---|---|---|
| `attach-context.ps1` | UserPromptSubmit | 키워드 매칭 → 관련 룰 자동 첨부 (비차단) | 0 |
| `block-dev-commands.ps1` | PreToolUse(Bash) | 로컬 pnpm/turbo/eslint 차단 | deny |
| `check-dbeaver-sql.ps1` | PostToolUse(Write/Edit) | `*_DBeaver*.sql` 의 SQL*Plus 토큰 차단 | 2 |
| `check-notnull-insert.ps1` | PostToolUse(Write/Edit) | 6개 테이블 NOT NULL 컬럼 누락 차단 | 2 |
| `check-fe-import.ps1` | PostToolUse(Write/Edit) | `@shared/*` 금지 import 차단 + `as unknown as` 경고 | 2/1 |

> `settings.json` 에 wiring 된 것은 **5개 ps1 뿐**. `.sh` 버전은 존재하나 미연결. `block-dev-commands.sh` 는 아예 부재.

---

## 2. 중복 (Duplication)

### D-1. 진입점 CLAUDE.md 이중화 🔴
루트 `/CLAUDE.md` 와 `Doc/_rules_v2/CLAUDE.md` 가 **3 진입점 정책·핵심 원칙·유지 룰 표·hook 안내**를 각각 보유. 두 곳을 모두 갱신해야 정합이 유지되나, 실제로는 갱신이 한쪽에만 적용되어 카운트가 어긋남(50/53 vs 41).

> **권고**: 루트 `CLAUDE.md` 를 **유일한 진입점**으로 확정하고, `_rules_v2/CLAUDE.md` 는 *얇은 포인터*(“상세는 00_INDEX 참조”)로 축소하거나 통합. 카운트·인벤토리는 **00_INDEX 1곳에서만** 보유.

### D-2. anti-simplification.md 이중 사본 🟡
`Doc/_dev_rules/hooks/anti-simplification.md` 와 `Doc/_rules_v2/anti-simplification.md` 가 동일 내용 2벌. 의도된 복제라고 문서화돼 있으나, 최우선 불변 룰이 2곳에 있으면 향후 한쪽만 수정될 위험.

> **권고**: v2 를 정본으로 두고 v1 사본은 **포인터 스텁**(1줄 "→ `_rules_v2/anti-simplification.md`")으로 대체.

### D-3. v1 `hooks/` DEPRECATED 중복 10종 🟡
`pre-write / post-write / pre-submit / asis-coverage-check / asis-button-mapping / runtime-error-prevention / popup-asis-analysis / menu-not-displayed-debug / grid-column-meta(-mandatory) / screen-entry-asis-baseline` 등이 v1·v2 양쪽에 존재. v1 README 가 "v2 우선"이라 명시하나 파일이 물리적으로 남아 grep·탐색 시 노이즈.

> **권고**: v1 `hooks/` 의 DEPRECATED 10종을 `_archive/` 로 이동하거나 포인터 스텁화.

### D-4. 실행 스크립트 ps1/sh 병존 🟢
5종 중 4종이 ps1+sh 2벌. 로직은 동일하나 **양쪽을 수동 동기화**해야 함 (예: `check-notnull-insert` 의 6 테이블 목록이 두 파일에 하드코딩).

---

## 3. 충돌 / 불일치 (Conflicts & Inconsistencies)

### C-1. Hook 카운트 4중 불일치 🔴 (최우선)
| 출처 | 주장 카운트 |
|---|---|
| `Doc/_rules_v2/CLAUDE.md` (구조 블록) | **41** ("나머지 36") |
| `00_INDEX.md §B.3` 헤더 | **53** |
| `/CLAUDE.md` (루트) | **50** 및 **53** 혼용 |
| **실제 디스크 (`hooks/*.md`)** | **69** |

→ "전체 hook 을 로드한다"는 정책이 어느 숫자도 신뢰할 수 없음. AI 가 53개로 인식하면 **16개(#54~69 상당)가 사각지대**.

> **권고**: 카운트는 **00_INDEX 1곳에서만** 관리 + CI/사전 스크립트로 `ls hooks/*.md | wc -l == 헤더 숫자` 자동 검증(아래 R-2).

### C-2. 카탈로그 번호 무질서 🟡
§B.3 의 번호가 `1~50` 순차 후 `53, 52, 54, 55, 57, 56, 51, 58, 59, 60, ~~70(retract)~~, 69, 68, 67, 66, 65, 64, 63, 62, 61` 로 역순·결번·삽입 혼재. 헤더 "53" 과 최대 번호 "70" 도 불일치.

> **권고**: 번호를 **파일명 알파벳 순 or 트리거(T번호) 순으로 재배열** + 재번호. retract 항목은 별도 "Retracted" 섹션으로 분리.

### C-3. 유지 룰 7 vs 8 (룰 32 고아) 🟡
- `Doc/_dev_rules/README.md` §1: "7 룰 유지" (02/21/22/28/29/30/31)
- `Doc/_rules_v2/CLAUDE.md` §C: 7 룰 (32 없음)
- `/CLAUDE.md` (루트): 32_CLAUDE_ORACLE_DIRECT.md 를 유지 룰로 참조 → 사실상 8

→ `32_CLAUDE_ORACLE_DIRECT.md` 파일은 실재(2026-06-11)하나 두 인덱스에 미등재.

> **권고**: 룰 32 를 유지 목록에 정식 등재(또는 v2 hook `oracle-db-workflow` 와 통합 후 archive). 세 진입 문서의 유지 룰 표를 **동일 출처 참조**로 통일.

### C-4. "자동 분기" 주장 vs 실제 강제의 격차 🔴
00_INDEX 는 "20 트리거가 작업 키워드로 **자동 분기**"한다고 기술. 그러나 실제 자동화는 `attach-context.ps1` 의 **4개 키워드 그룹**(SQL / FE / as-is / 신규화면)뿐이며, 이는 T01~T20 의 일부만 커버. 즉 대부분의 분기는 **AI 가 00_INDEX 를 읽고 수동으로 따라야** 성립.

→ 신규 화면 mandatory hook(#60~69, PR 차단 등급)이 키워드 매칭에서 빠지면 **자동 첨부되지 않음**.

> **권고**: (a) "자동 분기"라는 표현을 "AI 가 매트릭스를 읽고 분기"로 정확화, 또는 (b) `attach-context.ps1` 의 키워드 그룹을 T01/T04/T05/T06/T07 mandatory hook 까지 확장(아래 R-3).

### C-5. `.claude/hooks/README.md` ↔ `settings.json` 불일치 🟢
- README: "8 스크립트" 주장 → 실제 wiring 5 (ps1)
- README: `attach-context` 를 PostToolUse 로 오기재 → 실제 UserPromptSubmit
- README: "bash hook 전환" 안내 → `block-dev-commands.sh` 부재로 전환 불가

> **권고**: README 를 settings.json 실제와 동기화.

---

## 4. 누락 (Gaps) — TO-BE UI 관점

사용자 핵심 우려("UI 개발·수정 시 룰 누락")에 직결되는 구조적 누락:

### G-1. 문서 hook 64종은 "강제"가 아니라 "기억 의존" 🔴
69 hook 중 실행 강제(차단)되는 것은 FE import / DBeaver SQL / NOT NULL 3종뿐. **#60~69 같은 "PR 차단 강제" 등급 UI hook 도 실제로는 프로그램이 차단하지 않음** — AI 가 읽고 지킬 때만 적용. 사람이 수동 작업하면 전혀 강제되지 않음.

> **권고**: UI mandatory hook 의 POST-WRITE grep 체크를 **실제 PostToolUse 스크립트로 승격** 가능한 것부터 단계 이관(예: FlexGrid 직접 JSX 금지 → `check-fe-import.ps1` 패턴 확장).

### G-2. 신규 화면 mandatory 3종의 단일 체크리스트 부재 🟡
`ui-dynamic-property-management` + `menu-button-dynamic-fetch` + `ui-category-setup-column-meta` 가 "절대 누락 금지"로 루트 CLAUDE 에 강조되나, 이를 **단일 PRE-WRITE 체크리스트**로 묶은 곳이 없음 → 각 hook 을 개별로 기억해야 함.

> **권고**: `RULESET_MASTER.md` §UI-MANDATORY 의 통합 체크리스트로 단일화(본 산출물에 포함).

### G-3. "화면 수정(기존 화면 변경)" 트리거의 모호성 🟡
트리거 매트릭스는 "신규 화면"(T01) 중심. **기존 UI 수정** 시에는 regression-zero(#62) + column-meta-rework(#55) + Hard Boundary 가 핵심이나, "수정" 키워드 전용 트리거가 분리돼 있지 않음.

> **권고**: T01 을 "신규/수정" 2 분기로 세분하고, 수정 분기에 #62/#55/#60 을 명시(본 산출물 §매트릭스 반영).

### G-4. 실행 hook 의 OS 커버리지 누락 🟢
클라우드/Linux 빌드에서는 ps1 hook 이 동작 안 함. `block-dev-commands.sh` 부재로 로컬 명령 차단이 Linux 에서 무력.

> **권고**: 5종 모두 `.sh` 완비 + settings.json 에 OS 분기(또는 cross-platform node 스크립트) 도입.

---

## 5. 권고 요약 (Recommendations roadmap)

| ID | 권고 | 효과 | 난이도 |
|---|---|---|---|
| R-1 | 진입점 단일화 — 루트 `CLAUDE.md` = 유일 진입, `_rules_v2/CLAUDE.md` 는 포인터 | 라우팅 혼선 제거 | 소 |
| R-2 | 카운트 SSoT = 00_INDEX 1곳 + 자동 검증 스크립트 | 카운트 드리프트 영구 차단 | 소 |
| R-3 | `attach-context.ps1` 키워드 → mandatory UI hook 까지 확장 | 자동 첨부 사각지대 해소 | 중 |
| R-4 | 카탈로그 재번호(파일명/트리거 순) + Retracted 분리 | 신규 등재 충돌 방지 | 소 |
| R-5 | 룰 32 등재 통일 + v1 DEPRECATED 10종 archive | v1/v2 경계 정리 | 소 |
| R-6 | UI mandatory 통합 PRE/POST 체크리스트 단일화 | UI 누락 구조적 제거 | 소 (본 산출물) |
| R-7 | 실행 hook `.sh` 완비 + OS 분기 | 클라우드 강제 복원 | 중 |
| R-8 | "문서 hook(가이드)" vs "실행 hook(강제)" 용어 분리 | 강제 착시 제거 | 소 |

> R-1·R-2·R-4·R-5·R-6·R-8 은 **저난이도·고효과**. 우선 적용 권장.

---

## 6. 영문 요약 (English Summary)

The NSCM rule system is **mature and high-quality in content**, but rapid evolution has produced **meta-integrity defects** — not in what the rules say, but in *counts, entry points, v1/v2 boundaries, and enforcement*. These defects are what cause *"a rule exists but still gets missed."*

Top findings:
1. **Hook count drift (High):** four different counts (41 / 50 / 53) against an **actual 69** files on disk. No source is trustworthy → up to 16 hooks are blind spots.
2. **Documented vs enforced gap (High):** 69 documented "hooks" but only **5 are actually wired** in `settings.json` (FE-import, DBeaver-SQL, NOT-NULL blocks + context-attach + dev-command block). The other 64 — including "PR-blocking" UI rules #60–69 — apply only if the AI remembers to read them; manual edits are not enforced.
3. **Dual entry point (High):** root `/CLAUDE.md` and `Doc/_rules_v2/CLAUDE.md` both carry overlapping, partially-conflicting routing/counts. No single source of truth.
4. **Rule 32 orphan (Med):** retained in root CLAUDE but absent from both index files → 7-vs-8 inconsistency.
5. **Catalog numbering chaos (Med):** numbers run 1→70 out of order with gaps and a retracted entry, mismatching the "53" header.
6. **OS-locked enforcement (Low):** only PowerShell `.ps1` hooks are wired; `block-dev-commands.sh` is missing, so Linux/cloud builds enforce nothing.

Recommendation: establish **one Single Source of Truth** (root CLAUDE.md as the only entry; 00_INDEX as the only count/catalog), add a **count self-check**, separate the terms **"guide hook" (documentation) vs "enforced hook" (script)**, and consolidate the **UI-mandatory checklist** into one place (provided in the companion `RULESET_MASTER.md`). These structurally eliminate the "rule-exists-but-missed" risk the user is concerned about.

---

*본 보고서는 기존 룰 파일을 변경하지 않았습니다. 보완 적용은 짝 문서 `RULESET_MASTER.md` 와 위 R-1~R-8 권고를 참조하십시오.*
*This report did not modify any existing rule files. For remediation, see the companion `RULESET_MASTER.md` and recommendations R-1–R-8.*
