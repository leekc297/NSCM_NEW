# Hook — Rule MD Organize (메타룰)

> ⭐ **트리거 명령**: "MD 파일 정리해줘" / "룰 정리해줘" / "rule 정리해줘"
> **목적**: 최근 세션의 새로운 인사이트·사고·반복 패턴을 룰셋(`Doc/_dev_rules/*.md` + `hooks/*.md`)에 누적 반영. 룰셋을 살아있는 자산으로 유지.

작성: 2026-05-28
관련 메모리: `feedback_md_organize_trigger.md`
관련 룰: `06_HOOKS.md`, `14_ANTI_SIMPLIFICATION` (anti-simplification.md)

---

## §1. 트리거 패턴

다음 명령 감지 시 본 hook 의 단계 수행:

| 트리거 | 의도 |
|---|---|
| "MD 파일 정리해줘" | 룰셋 전반 점검·보완 |
| "룰 정리해줘" / "rule 정리해줘" | 동일 |
| "룰셋 업데이트" | 동일 |
| "이번 작업 룰에 반영해줘" | 최근 1세션 작업만 반영 |

## §2. 수행 단계 (필수 순서)

### Step 1. 회고 (Retrospective)

이번 세션 (또는 최근 N개 메시지) 의 작업을 회상하여 다음 분류:

| 분류 | 예시 |
|---|---|
| **새 인사이트** | 처음 발견된 동작 / 라이브러리 패턴 / DB 메타 동작 |
| **사고** (incident) | 실제 발생한 오류 + 원인 + 보완 |
| **반복 패턴** | 같은 종류 작업의 표준화 가능 절차 |
| **시행착오** | 중간에 잘못된 접근 + 교정 (다음에 반복 안 하도록) |
| **트리거 약속** | 사용자가 "X 라고 하면 Y 해줘" 명시 |

### Step 2. 인사이트 일반화

각 항목을 **다음 작업 / 다른 화면 / 다른 모듈에서 재사용 가능한 형태**로 일반화:

- ❌ "DMF0007 의 customerPSI sheet 가 그랬다" (단발성 사실)
- ✅ "신규 sheet 등록 시 SCM_MST_SHEET_COLUMNS 의 sCls 와 colLbl 이 동일해야 머지 동작" (일반화)

### Step 3. 기존 룰 중복 검사 (필수)

```bash
# 신규 작성 직전 — 키워드로 기존 룰 grep
grep -rln "<핵심 키워드>" C:/Projects/NSCM/Doc/_dev_rules/
```

중복 발견 시 → **신규 작성 금지, 기존 룰 보강** 으로 전환.
중복 없음 → 새 룰 작성 결정.

### Step 4. 작성/보강 결정 매트릭스

| 인사이트 규모 | 결정 |
|---|---|
| 단일 작은 사실 (1-2 줄) | 기존 룰 파일 §끝에 추가 |
| 한 영역의 새 sub-topic | 기존 룰 파일에 새 §섹션 추가 + cross-ref |
| 새 큰 주제 (3+ sub-topics) | **신규 룰** `{번호}_{TITLE}.md` 작성 |
| 자동 검증 가능 + 매 작업 적용 | **신규 hook** `hooks/{name}-check.md` 작성 |
| 사용자 명시 트리거 패턴 | **메모리** `feedback_*.md` + 신규 hook (적절 시) |
| 실제 발생한 사고 | `21_TROUBLESHOOTING.md` 의 새 §N |

### Step 5. 작성 (표준 양식)

#### 5.1 신규 룰 파일 — `Doc/_dev_rules/{번호}_{TITLE}.md`

```markdown
# {번호}. {제목}

> ⭐ **한 줄 요약**: ...
> 작성: YYYY-MM-DD
> 관련 룰: [...]
> 관련 hook: [...]

## §1. 배경 / 근본 원인
## §2. 핵심 규칙
## §3. 코드/SQL 예시
## §4. 검증 방법
## §5. 변경 이력
```

#### 5.2 신규 Hook — `hooks/{name}-check.md`

```markdown
# Hook — {이름}

> ⭐ 트리거: ...
> 목적: ...

## §1. 발동 조건
## §2. 검증 명령
## §3. 보완 절차
## §4. 자동 통합 (TODO)
## §5. 알려진 위반 사례
```

#### 5.3 메모리 — `feedback_*.md` / `reference_*.md` / `project_*.md`

```markdown
---
name: {이름}
description: {1줄 요약}
type: feedback | reference | project | user
---

{본문 - Why, How to apply 포함}
```

### Step 6. Cross-reference 업데이트 (필수)

신규 작성 후 다음 모두 업데이트:

| 파일 | 추가 항목 |
|---|---|
| `CLAUDE.md` §9 (관련 문서 표) | 새 룰/hook 추가 |
| `CLAUDE.md` §15 (변경 이력) | 한 줄 요약 |
| `Doc/_dev_rules/00_INDEX.md` | 룰셋 목록에 추가 |
| 관련 기존 룰의 `> ⭐ 연관:` 라인 | cross-ref 추가 |
| `MEMORY.md` (트리거인 경우) | 색인 추가 |

### Step 7. 검증 grep

```bash
# 새 룰 번호가 다른 파일에 cross-ref 되었는지 확인
grep -rln "{새번호}_{TITLE}\|룰 {새번호}" C:/Projects/NSCM/Doc/_dev_rules/ \
  C:/Projects/NSCM/CLAUDE.md \
  C:/Users/ejene/.claude/projects/C--Projects-NSCM/memory/MEMORY.md
# 기대: 본인 + CLAUDE.md + 00_INDEX + 1개 이상 관련 룰
```

## §3. 절대 금지 (Anti-Pattern)

> Anti-simplification.md 원칙 준수 — MD 정리 작업 자체에도 적용.

| # | 금지 |
|---:|---|
| 1 | ❌ 회고 없이 무작정 새 파일 작성 — 중복 가능성 |
| 2 | ❌ 기존 룰 grep 생략 — 중복 작성 위험 |
| 3 | ❌ 단발성 사실만 기록 (일반화 안 함) — 재활용 불가 |
| 4 | ❌ Cross-reference 생략 — 새 룰이 룰셋에서 발견 안 됨 |
| 5 | ❌ MEMORY.md 색인 누락 — 트리거 약속이 망각됨 |
| 6 | ❌ 변경 이력 누락 — 작성 시점 불명 |
| 7 | ❌ 사용자 의도 미확인 후 임의 일반화 — 룰셋 오염 |

## §4. 자가 점검 체크리스트

`/MD 파일 정리해줘` 트리거 직후 다음 모두 확인:

```
☐ 1. 최근 세션 작업을 분류별로 회고했나
☐ 2. 각 인사이트를 일반화 (다른 화면에서도 적용 가능) 했나
☐ 3. 기존 룰 grep 으로 중복 검사했나
☐ 4. 적절한 작성/보강 결정을 했나 (신규 룰/hook/기존 보강)
☐ 5. 표준 양식 (§5) 따라 작성했나
☐ 6. CLAUDE.md / 00_INDEX / 관련 룰 cross-ref 업데이트했나
☐ 7. MEMORY.md (트리거인 경우) 색인 추가했나
☐ 8. 변경 이력 (YYYY-MM-DD) 작성했나
☐ 9. 사용자에게 추가/보완된 파일 목록 보고했나
```

## §5. 알려진 적용 사례

| 일자 | 트리거 | 산출물 |
|---|---|---|
| 2026-05-28 | "rule 적용 부분을 md, hook 파일에 추가/보완해주세요" | 룰 27 (Wijmo 모듈 중복 + 머지 + PivotGrid + 5종 매핑) + hooks 2종 (module-duplication-check, encoding-check) + 21 §9 보강 + 08/10/12 cross-ref |
| 2026-05-28 | "MD 파일 정리해줘" | 룰 28 (Git Multi-Remote) + hook rule-md-organize (메타룰) + 메모리 트리거 약속 |
