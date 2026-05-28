# `.claude/hooks/` — Claude Code 강제 실행 Hook

## 목적

`Doc/_dev_rules/hooks/*.md` 의 선언적 룰을 보강하는 **자동 차단 시스템**.
AI 의 의지와 무관하게 harness 가 실행 → 위반 시 `exit 2` → 도구 호출 차단 + stderr 가 AI 컨텍스트로 전달됨.

## 파일 구성 (8개 스크립트 + 1 설정)

| 파일 | 이벤트 | 차단 대상 | 위반 시 exit |
|---|---|---|:---:|
| `check-dbeaver-sql.{ps1,sh}` | PostToolUse Write/Edit | `*_DBeaver*.sql` 에 SQL\*Plus 토큰 (`SET`/`PROMPT`/`DEFINE`/`&var`/`/`) | 2 |
| `check-notnull-insert.{ps1,sh}` | PostToolUse Write/Edit | `**/sql/*.sql` INSERT 에서 NOT NULL 컬럼 누락 | 2 |
| `check-fe-import.{ps1,sh}` | PostToolUse Write/Edit | `**/features/**/*.tsx` 의 금지 import + `as unknown as` cast | 2 / 1 |
| `attach-context.{ps1,sh}` | UserPromptSubmit | (차단 없음) — 키워드 매칭 시 룰 문서 stdout 으로 첨부 | 0 |
| `../settings.json` | (메타) | 위 hook 들을 등록 | — |

## Windows 환경 (현재 기본)

`settings.json` 이 PowerShell hook 을 사용합니다 (`powershell -NoProfile -ExecutionPolicy Bypass -File ...`).
Claude Code 재시작 시 자동 활성화.

## 클라우드 환경 (Linux/Mac) 전환

bash hook 으로 전환하려면 `settings.json` 의 각 `command` 를 다음으로 교체:

```diff
- "command": "powershell -NoProfile -ExecutionPolicy Bypass -File C:/Projects/NSCM/.claude/hooks/check-dbeaver-sql.ps1"
+ "command": "bash /your/path/NSCM/.claude/hooks/check-dbeaver-sql.sh"
```

bash 스크립트는 Python 3 가 PATH 에 있어야 합니다 (JSON 파싱 + 정규식).

## 차단 동작 예시

### 예 1) `*_DBeaver.sql` 에 `SET SERVEROUTPUT` 추가 시
```
BLOCK [check-dbeaver-sql]: C:/Projects/NSCM/_dmf0020_artifacts/sql/test_DBeaver.sql
  -> Forbidden SQL*Plus token detected: 'SET' (line 5)
  -> DBeaver files MUST NOT contain SQL*Plus commands (causes ORA-00922).
  -> Remove this line. DBMS_OUTPUT uses DBeaver's Output panel (no SET SERVEROUTPUT needed).
  -> Reference: memory/feedback_dbeaver_sql_mandatory_grep.md
```
→ Write 도구 호출 차단 + AI 가 stderr 받아 정정

### 예 2) `SCM_ADM_USER_GR_MNU_BTN_MPG_M` INSERT 에서 SHT_NM 누락
```
BLOCK [check-notnull-insert]: .../20_DMF0020_Registration_DBeaver.sql
  -> Table SCM_ADM_USER_GR_MNU_BTN_MPG_M (line 251): missing NOT NULL columns: SHT_NM
  -> NOT NULL columns without DEFAULT must be explicitly listed (avoids ORA-01400).
```

### 예 3) `import { Dialog } from '@shared/components'`
```
BLOCK [check-fe-import]: .../SomeComponent.tsx
  -> line 12 : invalid import 'Dialog' from '@shared/components'. Use 'CustomDialog' from '@shared/components'
  -> Reference: Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md
```

### 예 4) UserPromptSubmit (차단 없음, 컨텍스트 첨부만)
사용자 프롬프트에 "DBeaver INSERT" 포함 시:
```
===== AUTO-ATTACHED RULE CONTEXT (attach-context hook) =====
The following rules are MANDATORY for this task. Do not skip verification steps.

----- BEGIN: anti-simplification.md -----
... (291줄 본문 첨부)
----- END: anti-simplification.md -----

----- BEGIN: feedback_dbeaver_sql_mandatory_grep.md -----
... (본문)
----- END: feedback_dbeaver_sql_mandatory_grep.md -----

===== END AUTO-ATTACHED RULE CONTEXT =====
```
→ AI 가 작업 시작 전 룰을 강제로 컨텍스트에 받음

## MD 룰과의 관계

| 계층 | 위치 | 역할 | 강제력 |
|---|---|---|---|
| 참고 문서 | `Doc/_dev_rules/hooks/*.md` (9개) | 인간 가독 + AI 참고 + 상세 사유 | 의식적 |
| 강제 hook | `.claude/hooks/*.{ps1,sh}` (4×2) | harness 차단 + 자동 컨텍스트 주입 | **절대적** |

→ 양립. MD 9개는 그대로 유지하고 hooks 가 final guard.

## 비활성화 (롤백)

`.claude/settings.json` 에서 `hooks` 키만 제거하면 즉시 비활성화.
스크립트 파일은 삭제 불필요 — 호출되지 않을 뿐.

## 룰 추가 시

1. 새 검증 스크립트 `.claude/hooks/check-<name>.{ps1,sh}` 작성
2. `settings.json` 의 `PostToolUse.hooks` 배열에 추가
3. 차단 테스트로 동작 확인

## 참조 룰 문서

- `Doc/_dev_rules/hooks/anti-simplification.md` — 단순화 절대 금지 (5層 cross-check)
- `Doc/_dev_rules/hooks/post-write.md` — Write 직후 검증 명령
- `Doc/_dev_rules/hooks/fe-import-check.md` — FE import 패턴
- `Doc/_dev_rules/hooks/asis-coverage-check.md` — As-Is 4축 매핑
- `Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md` — `@shared/*` 정확 매핑표
- `Doc/_dev_rules/24_ASIS_CROSSCHECK.md` — As-Is cross-check 룰
- 메모리 `feedback_dbeaver_sql_mandatory_grep.md` — DBeaver SQL 금지 패턴
- 메모리 `reference_scm_adm_user_gr_btn_mpg_m.md` — `SHT_NM` PK 정의
