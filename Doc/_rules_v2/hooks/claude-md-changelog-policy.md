# Hook — CLAUDE.md 변경 이력 작성 정책 (2026-06-20)

> 사용자 명시 (2026-06-20) — **rule 로 추가**.
> 위반 시: CLAUDE.md 가 작업마다 비대화 → 1차 로드 토큰 낭비 + 핵심 룰 가독성 손상 + cache miss 빈도 증가.

---

## §0. 배경

CLAUDE.md §15 (변경 이력) 이 작업마다 entry 가 누적되며 비대화:
- 2026-05-13 ~ 2026-05-30 : Phase 0-4 archive (1차)
- 2026-06-03 ~ 2026-06-12 : 2026-06 archive (2차)
- 2026-06-15 ~ 2026-06-19 : 29 entry 추가 archive (3차, 59KB → 20KB 회복)
- 2026-06-20 : SYS0011 audit entry 단일 1.6KB → CLAUDE.md 23.5KB 비대 재발

**근본 원인**: §15 가 entry 본문 + 표 형식으로 작업 상세를 직접 담음. 작업당 100~500 char × 누적.

**근본 해법** (본 hook 의 정책):
1. §15 = **인덱스 pointer 만** (entry 본문 0, 표 0)
2. 모든 entry 본문 = **`Doc/_archive/CLAUDE_changelog_{YYYY-MM}.md`** archive 안 1-line 추가
3. 상세 작업 보고 = **`Doc/_archive/work_reports/{YYYY-MM-DD}_{topic}.md`** 신규 파일 작성

---

## §1. CLAUDE.md §15 작성 표준

### §1.1 §15 구조 (불변)

```markdown
## 15. ⭐ 변경 이력

> 모든 변경 이력은 monthly archive 에 직접 추가됩니다. CLAUDE.md 에는 작성하지 마세요.

- 2026-06: `Doc/_archive/CLAUDE_changelog_2026-06.md` (현재 월)
- 2026-05: `Doc/_archive/CLAUDE_changelog_phase0-4.md`
- 작업 상세 보고서: `Doc/_archive/work_reports/{YYYY-MM-DD}_{topic}.md`

작성 정책: `Doc/_rules_v2/hooks/claude-md-changelog-policy.md`
```

§15 의 본문 = **위 5 줄 고정**. entry 표 작성 금지.

### §1.2 §15 작성 시 강제 정책

| # | 강제 정책 | 위반 시 |
|---:|---|---|
| 1 | **§15 안에 변경 entry 직접 추가 금지** | PR 리뷰에서 reject |
| 2 | **§15 본문 ≤ 5 줄 (pointer 만)** | CLAUDE.md 비대화 |
| 3 | 변경 entry = monthly archive 에 1-line 추가 (200 char 이하) | archive 도 비대화 회피 |
| 4 | 상세 (위반 매트릭스 / 변경 파일 / 검증 결과 등) = work_reports/ 별도 md | 그 외 모든 비대 회피 |

---

## §2. Monthly Archive (`Doc/_archive/CLAUDE_changelog_{YYYY-MM}.md`)

### §2.1 구조

```markdown
# CLAUDE.md §15 변경 이력 — {YYYY-MM} archive

## 인덱스 (시간 순)

| 일자 | 키워드 (1-line ≤ 200 char) |
|---|---|
| 2026-06-20 | SYS0011 룰 전면 점검·교정 — 4 위반 + LBL 충돌 신규 ID — 본문 `work_reports/2026-06-20_SYS0011_audit.md` |
...
```

### §2.2 1-line entry 규칙

- **≤ 200 char** (긴 본문 → work_reports/ 분리)
- 키워드 위주 (날짜 + 작업명 + fix 핵심 + work_reports 링크)
- **상세 인용 금지** (V01 / V02 / 매트릭스 / 검증 SQL 등은 work_reports 본문)

### §2.3 월 전환 시점

- 매월 1일 신규 archive 파일 생성 (`CLAUDE_changelog_{YYYY-MM}.md`)
- §15 pointer 의 archive 목록 갱신 (직전 월 + 신규 월 추가)

---

## §3. Work Reports (`Doc/_archive/work_reports/{YYYY-MM-DD}_{topic}.md`)

### §3.1 파일명 표준

- 패턴: `{YYYY-MM-DD}_{TOPIC}.md`
- 예: `2026-06-20_SYS0011_audit.md` / `2026-06-19_hook70_evolution.md`
- topic = snake_case 또는 MNU_ID prefix (의미 명확화)

### §3.2 본문 구조 (표준)

```markdown
# Work Report — {YYYY-MM-DD} {topic 한국어 설명}

> 출처: 사용자 요청 / Plan 위치

## 1. 위반 매트릭스 (N건)
| # | 룰/Hook | 위치 | 위반 | Fix |

## 2. AS-IS feature parity (해당 시)

## 3. 변경 파일 목록

## 4. 검증 결과 (POST-WRITE grep / Hard Boundary / 8 게이트)

## 5. Phase D 인계 (해당 시 — 사용자 직접 실행)

## 6. 학습 (hook 진화 / 룰 보강)
```

### §3.3 작성 의무

- 화면 audit / 풀스택 작업 / 룰 개정 등 **상세 보고가 필요한 작업** 은 work_report 작성
- 단순 fix (단일 파일 1 line 변경 등) 은 monthly archive 1-line entry 만으로 충분 (work_report 생략)

---

## §4. PRE-WRITE 점검 (CLAUDE.md 직접 편집 시)

| # | 점검 | 확인 방법 |
|---:|---|---|
| 1 | §15 에 entry 추가하려는가? | **금지** — monthly archive 로 이동 |
| 2 | §15 본문 ≤ 5 줄 유지? | `wc -l` 또는 §15~§16 간 줄 수 |
| 3 | 신규 hook / 룰 신설인가? | RULESET_MASTER §4 + 00_INDEX §B.3 카탈로그 갱신 |
| 4 | 작업 본문이 200 char 초과인가? | work_report 작성 후 monthly archive 에 링크 |

---

## §5. POST-WRITE 검증

### §5.1 사이즈 확인
```bash
wc -c CLAUDE.md
# 기대: ≤ 25KB (신규 hook / 룰 추가 외에는 사이즈 증가 0)
```

### §5.2 §15 줄 수
```bash
sed -n '/## 15\./,/## 16\.\|^## [^0-9]/p' CLAUDE.md | wc -l
# 기대: ≤ 15 줄 (header + pointer 5 줄 + 여백)
```

### §5.3 작업 보고 파일 존재
```bash
ls Doc/_archive/work_reports/{YYYY-MM-DD}_*.md
# 기대: 상세 보고가 필요한 작업의 보고서 존재
```

---

## §6. 적용 표

| 작업 | §15 entry | monthly archive | work_report |
|---|:---:|:---:|:---:|
| SYS0011 audit (2026-06-20) | ❌ (이전 비대 entry → 삭제) | ✓ 1-line | ✓ `2026-06-20_SYS0011_audit.md` |
| hook #70 진화 (회차별) | ❌ | ✓ 1-line | (단순 — 생략) |
| DMF0072 풀스택 (2026-06-02) | ❌ | ✓ 1-line | (이미 archive 안 원문 — 그대로 유지) |
| 신규 hook 신설 | ❌ | ✓ 1-line (hook 이름 + 핵심) | hook 본문 자체가 보고 — work_report 생략 |

---

## §7. RULESET_MASTER §3 UI-MANDATORY 통합

POST-WRITE (CLAUDE.md 갱신 시):
- ✅ §15 entry 직접 추가 0건 — monthly archive 사용
- ✅ §15 본문 ≤ 5 줄 (pointer 만)
- ✅ 상세 보고 → `Doc/_archive/work_reports/{YYYY-MM-DD}_*.md`

---

## §8. 짝 hook / 참조

- `Doc/_rules_v2/anti-simplification.md` (최우선 — 단순화 금지 + 작업 본문 임의 누락 금지)
- `Doc/_rules_consolidation/RULESET_MASTER.md` §4 hook 카탈로그 (본 hook 등재 의무)
- `Doc/_rules_v2/00_INDEX.md` §B.3 카탈로그 (본 hook 등재 의무)

---

## §9. 이력

- 2026-06-20 신설 — 사용자 명시 ("CLAUDE.md 직접 추가 금지 + 다른 파일 분리"). SYS0011 audit entry 단일 1.6KB → CLAUDE.md 23.5KB 비대 재발 사고 후 정책 제도화.
