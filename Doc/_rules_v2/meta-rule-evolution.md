# 메타-룰 진화 (Meta-Rule Evolution)

> ⭐ 룰 v2 의 자가 진화 메커니즘 — 룰셋이 PoC 를 통해 자신의 결함을 발견하고 보강하는 과정.

---

## §0 위치 + 진입점

| 항목 | 값 |
|---|---|
| 파일 | `Doc/_rules_v2/meta-rule-evolution.md` (이 파일) |
| 진입 시점 | (a) Phase 6/7 PoC 진행 (b) "룰이 부족해 보임" 사용자 지적 (c) PR 머지 후 보완사항 ≥ 10 |
| cross-ref | `CLAUDE.md` §룰 v2 구조 + `00_INDEX.md` §메타 + `anti-simplification.md` (보완) |
| 첫 작성 | 2026-06-04 (Phase 7 PoC 보완 5~7 종합) |

---

## §1 PoC 의 진짜 가치 — 메타-룰 발견

### §1.1 PoC 의 표면 가치 (1차)

- 룰 v2 만 사용해서 신규 화면 1건 완성 → success criterion (보완사항 ≤ 10) 충족

### §1.2 PoC 의 진짜 가치 (메타)

- ⭐ **룰 v2 자체의 결함 발견** — 작업 중 누락/모호한 룰이 매번 노출됨
- ⭐ **룰의 변형 절 (§2) 의 중요성** — 표준 (§1) 만으로 모든 사용자 의도 충족 불가
- ⭐ **사용자 작업물 우선** — 잘 동작하는 사용자 코드를 룰 v2 표준으로 강제 변경 금지 (anti-simplification 의 반대편)

---

## §2 Phase 6/7 PoC 의 메타-룰 발견 히스토리

### §2.1 Phase 6 PoC (DMF0015 BOD) — 룰 11 재작성

| 발견 | 영향 |
|---|---|
| BE 의 표준 Spring Boot Controller/Service/ServiceImpl 구조 적용 | ❌ NSCM 은 단일 GeneralController + 동적 SP routing (Java 코드 0줄) |
| → 신규 화면당 Java 파일 5개 작성 = **over-engineering** | 사용자 명시 지적 ("BE 는 추가될 것이 없어 보이는데") |
| → 5 파일 `_archive_be_phase6_wrong/` 이동 | 룰 11 전면 재작성 (NSCM dynamic SP routing 표준) |
| **메타-룰 #1** | **표준 (§1) 작성 전 reference 화면의 BE 구조 cross-check 의무** |
| **메타-룰 #2** | **PoC 의 결함 = 룰의 결함 — PoC 가 작동하면 룰이 작동** |

### §2.2 Phase 7 PoC (DMF0008 ErpEdiMaster) — 룰 04/07 변형 절 (§2) 보강

| 발견 | 영향 |
|---|---|
| DMF0008 이 **이미 존재** (사용자 작성) — PoC 의 의미 변경 | 신규 작성 검증 → 기존 화면 cross-check |
| DataGrid wrapper 의무 (룰 07 §1) 위반 — FlexGrid + FlexGridColumn 직접 사용 | 사용자 의도 (명시적 column / `initialized` callback / `itemDoubleClick`) |
| Store 명명 자유도 — `setSearchCondition` vs 표준 `setSearchParams` | 의미 동등 / 사용자 표현 차이만 |
| fetchStaticColumns 의무성 — read-only + 명시적 column 화면도? | 일부 화면은 BE column 메타 불필요 |
| **메타-룰 #3** | **변형 절 (§2) 신설 의무** — 룰 04/07 모두 §2 의 변형 (variant) 명시 |
| **메타-룰 #4** | **사용자 작업물 우선** — 룰의 §1 표준 강제 X (anti-simplification 의 반대편) |

### §2.3 Write 실패 → 우회경로 룰 (운영 룰)

| 발견 | 영향 |
|---|---|
| 신규 폴더 Write 시 "File has not been read yet" 에러 발생 | 보안 정책상 read-only / 사용자 작업물 보호 |
| 우회: Read 먼저 → Edit / Bash mv / Python 우회 의무 | `hooks/file-write-fallback.md` 신규 작성 |
| **메타-룰 #5** | **운영 룰 (작업 도중 사고 대응) 의 일급 시민화** — 룰 v2 가 코드 룰만 다루지 않음 |

---

## §3 학습된 메타-룰 7 종 종합

| # | 메타-룰 | 위치 |
|---:|---|---|
| 1 | **표준 (§1) 작성 전 reference 화면 cross-check 의무** — 추측 금지, 실제 코드 read | 모든 _tobe/*.md 의 §0 |
| 2 | **PoC 가 결함이면 룰이 결함** — PoC report → 룰 보강 사이클 | 본 파일 §1.2 |
| 3 | **변형 절 (§2) 의 의무** — 표준 (§1) 만으로 충족 불가 | 모든 _tobe/*.md |
| 4 | **사용자 작업물 우선** — 잘 동작하는 코드를 표준에 맞춰 변경 X | 본 파일 §4 + `anti-simplification.md` 보완 |
| 5 | **운영 룰의 일급 시민화** — Write 실패 / DB error / 디버깅 등 작업 도중 사고도 룰 v2 가 처리 | `hooks/file-write-fallback.md` + `hooks/menu-not-displayed-debug.md` + `hooks/runtime-error-prevention.md` |
| 6 | **기존 사용자 작성 화면도 PoC 가치** — 신규 작성뿐 아니라 cross-check 도 robust 검증 | 본 파일 §1.2 |
| 7 | **메타-룰 자체의 룰화** — 본 파일 (`meta-rule-evolution.md`) 의 존재 자체가 메타-메타-룰 | 본 파일 |

---

## §4 사용자 작업물 우선 — anti-simplification 의 반대편

### §4.1 anti-simplification.md 의 의미

> 단순화 절대 금지 — 사용자가 "모두/전체/정밀/상세" 요청 시 다중 패턴 + Cross-check 의무

### §4.2 사용자 작업물 우선의 의미

> 사용자가 이미 작성한 코드를 룰의 §1 표준에 맞춰 **강제 변경 금지**.
>
> 변경 의무 vs 변경 금지의 판단 기준:

| 사용자 코드 상태 | 결정 |
|---|---|
| 작동 + 룰 §1 표준 준수 | ✅ 변경 없음 (그대로 유지) |
| 작동 + 룰 §1 위반 + 룰 §2 변형 명시 | ✅ 변경 없음 + 룰 §2 변형 cross-ref (DMF0008 의 FlexGrid 직접 사용 = 룰 07 §2.7 변형) |
| 작동 + 룰 §1 위반 + 룰 §2 변형 미명시 | ⚠️ **사용자 의도 cross-check 후 결정** — (a) 변형 추가하여 룰 §2 보강 (b) 사용자 코드 §1 으로 refactor |
| 미작동 (런타임 오류 / 결과 누락) | ❌ 변경 필요 (룰 §1 적용 + 사고 발견 시 hook 추가) |

### §4.3 변형 절 (§2) 의 의무 — Phase 7 PoC 의 핵심 발견

- 모든 _tobe/*.md 는 **표준 (§1) + 변형 (§2) + 위반 검출 (§3)** 의 3 단계 구조
- 변형 (§2) 는 **사용자 의도의 합법화** — "이 화면은 §1 의 표준 외 어떤 사유로 §2 의 변형을 사용한다" 를 룰이 인정
- §2 의 변형이 늘어날수록 룰의 적용 범위가 확장 — 룰 v2 의 robust 화

---

## §5 PoC → 룰 보강 사이클 (메타 워크플로우)

### §5.1 사이클의 단계

1. **PoC 진행** — 룰 v2 만 사용해 신규 화면 작성 (또는 기존 화면 cross-check)
2. **보완사항 카운트** — 룰 v2 의 누락/모호한 사항을 모두 기록
3. **메타-룰 식별** — 보완사항을 4 분류:
   - (a) 룰 §1 표준 누락 → §1 추가 작성
   - (b) 룰 §2 변형 누락 → §2 변형 추가 (Phase 7 의 룰 04/07)
   - (c) Hook 부재 → `hooks/` 신규 작성 (Phase 7 의 file-write-fallback)
   - (d) 메타-룰 (룰 v2 자체의 정책) → 본 파일 (`meta-rule-evolution.md`) 갱신
4. **보강 작업** — 위 4 분류에 따라 룰 v2 의 해당 파일 수정 + cross-ref 갱신
5. **메모리 등록** — 향후 동일 사고 방지를 위한 트리거 + 룰 cross-ref

### §5.2 메타 워크플로우의 cross-ref

- 메타-룰 발견 시 본 파일 §2 의 히스토리 표에 행 추가
- §3 의 학습된 메타-룰 표에 새 메타-룰 추가
- CLAUDE.md 의 룰 v2 구조 표에 본 파일 cross-ref
- 메모리: `feedback_poc_meta_rule_evolution.md` 의 트리거 list 갱신

---

## §6 Hook 6 — 메타-룰 자기 점검

> PR 머지 직전 + PoC 후 진행. 사람용 (사용자) + AI 용 (Claude) 공통.

```
□ PoC 진행 후 보완사항 ≥ 1 건인가? → §5.1 사이클 시작
□ 보완사항을 4 분류 (§1/§2/Hook/메타) 로 모두 분류했는가?
□ 룰의 §2 변형 절 보강 시 사용자 의도 cross-check 했는가?
□ Hook 신규 작성 시 anti-simplification + cross-ref 갱신 의무
□ 메모리 등록 시 트리거 + 룰 cross-ref 명시
□ CLAUDE.md / 00_INDEX.md 의 카탈로그에 새 룰/Hook 등록
```

---

## §7 변경 이력

| 일자 | 변경 | Phase |
|---|---|---|
| 2026-06-04 | 본 파일 신규 작성 — Phase 6/7 PoC 의 메타-룰 발견 종합 + 사이클 정의 + Hook 신규 | Phase 7 보완 5~7 |
