# `.claude/hooks/` — Claude Code 강제 실행 Hook (2026-10-12 동기화 — 실측 9 스크립트 / 10 wiring)

## 목적

룰 문서(`Doc/_rules_v2/hooks/*.md`)는 **AI 가 읽고 지키는 가이드("문서 hook")**.
이 폴더의 스크립트는 **harness 가 자동 실행하는 차단/주입("실행 hook")** — AI 의지와 무관, `exit 2` 시 도구 호출 차단.

> ⚠️ **용어(R-8)**: 문서 hook **153종**(`Doc/_rules_v2/hooks/*.md` 2026-10-12 실측) vs 실행 hook **9 스크립트**는 **별개**. 단일 진입·전체 카탈로그 = `Doc/_rules_consolidation/RULESET_MASTER.md`.

## 파일 구성 (실제 wiring = `../settings.json` 기준, 9 스크립트 / 10 wiring)

| 파일 | 이벤트 | 차단/동작 | 위반 exit |
|---|---|---|:---:|
| `attach-context.{ps1,sh}` | **UserPromptSubmit** | (차단 없음) **v3 2026-10-12**: `!lite`/`!full` 또는 질의 판별 → **LITE** 는 1줄 안내만 / **FULL** 은 anti-simplification + `TRIGGER_ROUTER.md`(MASTER §2 추출본) + 키워드별 진입 hook 첨부, T01/T01M 은 `UI_MANDATORY_CHECKLIST.md`(§3 추출본) 추가, 합계 120KB 상한(초과분은 경로 안내). RULESET_MASTER 전문(159KB) 첨부 **중단**. ⚠ `.sh` 는 구 v2 로직(미동기) | 0 |
| `block-dev-commands.{ps1,sh}` | **PreToolUse (Bash)** | local `pnpm/turbo/eslint` 차단 (`ALLOW_PNPM=1` 우회) | deny |
| `check-rules-read.ps1` | **PreToolUse (Write/Edit/MultiEdit)** | **2026-10-12 신설** — 대상 경로별 필수 룰 hook 을 이 세션에서 읽었는지(Read 호출 또는 attach 첨부) transcript 로 검사, 미열람 시 차단 + Read 경로 안내. FE pages / FE packages / BE / `_artifacts` SQL·PY 4분류. 우회 `NSCM_SKIP_RULE_READ=1`(보고 의무) | 2 |
| `check-dbeaver-sql.{ps1,sh}` | **PostToolUse (Write/Edit/MultiEdit)** | `*_DBeaver*.sql` SQL*Plus 토큰 | 2 |
| `check-notnull-insert.{ps1,sh}` | **PostToolUse** | `**/sql/*.sql` INSERT NOT NULL 누락 (하드코딩 6 테이블) | 2 |
| `check-fe-import.{ps1,sh}` | **PostToolUse** | `.tsx` 금지 import + `as unknown as` 경고 | 2 / 1 |
| `check-ui-gates.ps1` | **PostToolUse** | 페이지 ts/tsx G-A~G-G (자체 행상태 / call-proc 무판정 / 감사키 빈값 / util 미배선 / 모달 확정버튼 / 콤보 빈 catch / 콤보 quoting) | 2 / 1 |
| `check-meta-sql.ps1` | **PostToolUse** | `SHEET_COLUMNS` INSERT/UPDATE 값 단언 (CTRL 화이트리스트 / INPUT_TP_CD / 전면 IM) | 2 / 1 |
| `check-db-fresh-source.ps1` | **PostToolUse** | `_artifacts/**/*.sql` DDL `SOURCE-FRESH` 24h / `*.py` DB 재조회+`FRESH-GATE` (hook #152) | 2 |

> 정정 (구 README 오류): "5 스크립트" → **9 스크립트** (check-ui-gates / check-meta-sql / check-db-fresh-source / check-rules-read 누락 표기). `.sh` parity 는 attach-context·block-dev-commands·check-dbeaver-sql·check-notnull-insert·check-fe-import 5종만 존재 — 나머지 4종 Linux 미지원.
> 검증 일괄 실행: `powershell -File scripts\rules\verify_hooks.ps1` (구문·LITE/FULL 판별·rules-read 차단·추출본 drift·상시 컨텍스트 크기).

## OS 환경 (R-7)

- **Windows (현재 wiring)**: `settings.json` 이 `powershell ... -File ....ps1` 호출. 5종 ps1 모두 존재.
- **Linux/Mac/클라우드**: `.sh` 5종 완비 (2026-06-18 `block-dev-commands.sh` 신설로 parity 완성). 전환 시 `settings.json` 의 각 `command` 를 교체:
  ```diff
  - "command": "powershell -NoProfile -ExecutionPolicy Bypass -File C:/Projects/NSCM/.claude/hooks/check-dbeaver-sql.ps1"
  + "command": "bash /your/path/NSCM/.claude/hooks/check-dbeaver-sql.sh"
  ```
  bash 스크립트는 Python 3 가 PATH 에 있어야 함 (JSON 파싱 + 정규식).
  > ⚠️ ps1 과 sh 를 **동시에 wiring 하지 말 것** (반대 OS 에서 실패/중복 실행). OS 당 한쪽만.

## 유지보수 주의 (진단 G-1)

- `check-notnull-insert` 의 대상 테이블 6종은 **ps1+sh 양쪽에 하드코딩**. 새 NOT NULL 테이블 추가 시 두 파일 모두 수정.
- `attach-context` 의 키워드 그룹·첨부 경로는 2026-06-18 갱신 (RULESET_MASTER 단일 진입 + UI mandatory/T01M 추가).

## 비활성화 (롤백)

`.claude/settings.json` 에서 `hooks` 키 제거 → 즉시 비활성화. 스크립트 삭제 불필요.

## 룰 추가 시

1. `check-<name>.{ps1,sh}` 작성 (양 OS) 2. `settings.json` 의 해당 이벤트 배열에 추가 3. 차단 테스트.

## 참조

- 단일 진입/전체 카탈로그: `Doc/_rules_consolidation/RULESET_MASTER.md`
- 진단/권고: `Doc/_rules_consolidation/00_DIAGNOSIS_진단보고서.md`
- 문서 hook 본문: `Doc/_rules_v2/hooks/` (69)
