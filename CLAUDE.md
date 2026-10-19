# CLAUDE.md — NSCM (경량 진입점, 2026-10-12 재구성)

> 이 파일은 **매 턴 로드되는 상시 컨텍스트**다. 그래서 짧다. 상세 룰은 아래 라우팅으로 **필요할 때만** 읽는다.
> 구 전문(20KB)은 `Doc/_archive/CLAUDE_md_full_2026-10-12.md` 에 보존. 내용은 삭제되지 않았고 **계층 이동**만 했다 (§6 매핑표).

## 0. 프로젝트
**LG Energy Solution NSCM** — AS-IS GSCM C#.NET WinForms(358 csproj / 4,162 cs / 2,771 SP) → TO-BE **React 19 + Spring Boot 3.5 + Oracle 19c**.
도메인 DM / SCM / FP / SCP / SSP / Common. 코드: `nscm-fe/` · `nscm-be/` · 분석 `Doc/_analysis/`, `_analysis/`.

## 1. 절대 원칙 (항상 적용)
1. ⚠️ **anti-simplification** — 속도·편의를 위한 단순화 절대 금지. "모두/전체/정밀/상세" 요청 = 다중 패턴 + Cross-check. 자동화 1회 통과 채택 금지. 추출 한계는 명시. 전문: `Doc/_rules_v2/anti-simplification.md` (**T01~T21 작업 시 Read**).
2. **디자인 그대로 구현(1순위)** → **한 사람이 개발한 것처럼**(reference 화면 DMF0004~0007 패턴 100% 동일) → **AS-IS 한 줄도 누락 없음** → **공용으로 끌어올리기**(shared default 변경 금지).
3. **Layer 의존 방향**: FE foundation ← shared ← features ← web / BE Controller → Service(interface) → ServiceImpl → BaseService → MyBatis.
4. **Syntax Error 0**: Oracle 19c 컴파일 가능 / FE·BE lint + type-check + build 통과.
5. **정직 보고**: 검증 미실행·미확인·환경 파손은 PASS 가 아니라 **ERROR** 로 보고 (hook #126). 완료는 스스로 선언하지 않는다 — 게이트 통과 증빙 첨부.
6. **DB 작업 = 새로고침한 최신 원문 기준** (hook #152, 실행 hook 으로 강제). 운영/사내 DB 적용은 승인된 절차(T18)만.
7. **파괴적 Git 작업**(force-push / filter-branch / reset --hard) 전 사용자 승인 의무.
8. **보완 = DB 객체 수정 우선** (사용자 상시 지시 2026-10-15). 가능하면 PKG/SP/메타 등 DB 객체로 해결한다. FE(`nscm-fe`)·BE(`nscm-be`) 수정이 필요하면 **직접 수정하지 않고 가이드만 제공**(파일:라인 · 변경 전/후 · 이유 · 검증법).

## 2. 응답 모드 (속도 ↔ 누락 0 양립의 핵심)
| 모드 | 판별 | 행동 |
|---|---|---|
| **질의(LITE)** | 파일을 만들거나 고치지 않는 질문·확인·설명 요청 | 룰 전문 로드 없이 **즉답**. 답의 근거가 룰/메타면 그 hook **1개만** Read. 첫 줄에 `[LITE]` 표기 |
| **작업(FULL)** | 생성·수정·적용·변환·배포·분석서 작성 등 산출물이 생기는 요청 | §3 라우팅 수행. 첫 줄에 `[T# 적용: … / Read: …]` 표기 |
| 강제 | 프롬프트 앞에 `!full` / `!lite` | 판별을 무시하고 해당 모드 |

질의가 작업으로 바뀌는 순간(“그럼 고쳐줘”) FULL 로 전환한다. LITE 에서 답이 불확실하면 추측하지 말고 **확인할 파일 경로를 제시**한다.

## 3. 작업(FULL) 라우팅 — 4단계
```
Step 1  Read: Doc/_rules_v2/anti-simplification.md                (최우선·불변)
Step 2  Read: Doc/_rules_consolidation/TRIGGER_ROUTER.md          (T00~T21 → 필독 룰 + 핵심 Hook)  ← RULESET_MASTER §2/§2.5/§7 추출본
Step 3  해당 T# 행의 핵심 Hook 을 Doc/_rules_v2/hooks/<name>.md 에서 Read (⭐⭐⭐ 생략 불가)
Step 4  T01/T01M 이면 Read: Doc/_rules_consolidation/UI_MANDATORY_CHECKLIST.md 를 PRE-WRITE 통과  ← RULESET_MASTER §3 추출본
```
- 2대 통합 진입 hook: **Oracle SP/DB 전부** → `hooks/oracle-db-workflow.md` / **화면 종료 선언 전** → `hooks/screen-completion-gate.md` (8 게이트).
- 공통 hook: 작성 직전 `hooks/pre-write.md` · 직후 `hooks/post-write.md` · 종료 직전 `hooks/pre-submit.md`.
- 신규/수정 화면 **절대 누락 금지 3종**: `ui-dynamic-property-management`(master) → `menu-button-dynamic-fetch` → `ui-category-setup-column-meta`.
- 전체 카탈로그(hook 한 줄 요약 153종)·카운트 단일 소스 = `RULESET_MASTER.md §4` + `00_INDEX.md §B.3` — **카탈로그가 필요할 때만** 연다. 매 작업 전문 Read 금지(토큰 150K+).
- 경로별 상세 규약은 `.claude/rules/*.md` 가 **해당 경로 파일을 만질 때 자동 로드**된다: FE 화면 / BE / DB·SQL / 분석 산출물.

## 4. 절대 금지 (Top 11 — 요약)
①상대경로 import(alias 사용) ②feature 간 직접 import ③`console.log`/`System.out.println` ④`any` ⑤inline style ⑥Controller 에서 SQL 직접 ⑦`@Autowired` 필드 주입 ⑧하드코딩 SQL ID ⑨`ResponseEntity` 직접(→`successResponseEntity`) ⑩MSSQL 키워드 잔존(DATEADD/CHARINDEX/STRING_SPLIT/GETDATE/ISNULL/IIF/N'/NOLOCK) ⑪As-Is `validation.md`/`expressions.md` 1건이라도 누락(`__asis-mapping__.md` 필수).

## 5. 실행 hook (`.claude/settings.json` — AI 의지와 무관하게 자동 차단)
`block-dev-commands`(Bash) · `check-rules-read`(Write/Edit 전 — 필수 hook 미열람 시 차단, 2026-10-12 신설) · `check-dbeaver-sql` · `check-notnull-insert` · `check-fe-import` · `check-ui-gates` · `check-meta-sql` · `check-db-fresh-source`(Write/Edit 후) · `attach-context`(프롬프트 키워드 → 룰 자동 첨부, LITE 판별 포함). 상세 `.claude/hooks/README.md`.

## 6. 구 CLAUDE.md 섹션 → 이동 위치
| 구 섹션 | 지금 위치 |
|---|---|
| Model Fallback / 도구 빠른 참조(§8) | `Doc/_archive/CLAUDE_md_full_2026-10-12.md` §Model, §8 (단순 질의는 `/model` 로 가벼운 모델 권장) |
| Step 3 기존 코드 참조 / Step 3.5 features 폴더 결정 5단계 / Step 4 화면별 분석자료·카운트 일치·xlsx 1~10시트 불신 | `.claude/rules/00-fe-screen.md` |
| §5 명명 규약 BE / §6 표준 응답·DB 호출 | `.claude/rules/01-be.md` |
| 절대 금지 ⑩ MSSQL / DB 변환 룰 / SP 파이프라인 / DBeaver / 사내 적용 | `.claude/rules/02-db-sql.md` |
| §11 Cowork 산출물 폴더 매핑 / §12 v7.4 화면 분석서 의무 / §13 통계 | `.claude/rules/03-analysis-docs.md` |
| §2 Step 1~2 룰셋 로드 / §9 관련 문서 표 / 유지 룰 v1 8종 | `TRIGGER_ROUTER.md` + `RULESET_MASTER.md §5` |
| §7 자기 점검 | `hooks/post-write.md` + `UI_MANDATORY_CHECKLIST.md §3.3` |
| §15 변경 이력 | `Doc/_archive/CLAUDE_changelog_YYYY-MM.md` 1-line (hook #77 — 본 파일에 직접 추가 금지) |
