# `.claude/hooks/` — Claude Code 강제 실행 Hook (2026-06-18 동기화, R-7/R-8)

## 목적

룰 문서(`Doc/_rules_v2/hooks/*.md`)는 **AI 가 읽고 지키는 가이드("문서 hook")**.
이 폴더의 스크립트는 **harness 가 자동 실행하는 차단/주입("실행 hook")** — AI 의지와 무관, `exit 2` 시 도구 호출 차단.

> ⚠️ **용어(R-8)**: 문서 hook(대다수) vs 실행 hook 5종은 **별개**. 단일 진입·전체 카탈로그·카운트 = `Doc/_rules_consolidation/RULESET_MASTER.md` §4.

## 파일 구성 (실제 wiring = `../settings.json` 기준, 5 스크립트)

| 파일 | 이벤트 | 차단/동작 | 위반 exit |
|---|---|---|:---:|
| `block-dev-commands.{ps1,sh}` | **PreToolUse (Bash)** | local `pnpm/turbo/eslint` 차단 (`ALLOW_PNPM=1` 우회) | deny |
| `check-dbeaver-sql.{ps1,sh}` | **PostToolUse (Write/Edit/MultiEdit)** | `*_DBeaver*.sql` SQL*Plus 토큰 | 2 |
| `check-notnull-insert.{ps1,sh}` | **PostToolUse (Write/Edit/MultiEdit)** | `**/sql/*.sql` INSERT NOT NULL 누락 (하드코딩 6 테이블) | 2 |
| `check-fe-import.{ps1,sh}` | **PostToolUse (Write/Edit/MultiEdit)** | `.tsx` 금지 import + `as unknown as` 경고 | 2 / 1 |
| `attach-context.{ps1,sh}` | **UserPromptSubmit** | (차단 없음) 키워드 매칭 → 룰 문서 stdout 첨부 | 0 |

> 정정 (구 README 오류): ① "8 스크립트"가 아니라 **5종**(각 ps1+sh) ② `attach-context` 는 PostToolUse 가 아니라 **UserPromptSubmit**.

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
