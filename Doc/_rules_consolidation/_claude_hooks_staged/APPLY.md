# 실행 hook 적용 안내 (R-3 / R-7)

> `.claude/` 폴더는 이 세션에서 **쓰기 보호**되어 직접 수정할 수 없어, 갱신본을 여기에 staged 했습니다.
> 아래 파일을 `C:\Projects\NSCM\.claude\hooks\` 로 복사하면 반영됩니다. (Claude Code 재시작 시 활성화)

## 1. 복사 대상 (4개 — 기존 덮어쓰기 3 + 신규 1)

| staged 파일 | → 복사 위치 | 변경 |
|---|---|---|
| `attach-context.ps1` | `.claude\hooks\attach-context.ps1` | R-3: RULESET_MASTER 단일 진입 + 아카이브된 v1 경로 → v2 경로 교체 + UI/수정(T01M) 키워드 그룹 추가 |
| `attach-context.sh` | `.claude\hooks\attach-context.sh` | 동일 (bash mirror) |
| `block-dev-commands.sh` | `.claude\hooks\block-dev-commands.sh` | **신규** — 기존엔 .sh 부재 (R-7 parity) |
| `README.md` | `.claude\hooks\README.md` | settings.json 실제와 동기화 (5 스크립트 / 이벤트 정정 / OS 안내) |

## 2. 복사 명령 (PowerShell)

```powershell
$src = "C:\Projects\NSCM\Doc\_rules_consolidation\_claude_hooks_staged"
$dst = "C:\Projects\NSCM\.claude\hooks"
Copy-Item "$src\attach-context.ps1"    "$dst\attach-context.ps1"    -Force
Copy-Item "$src\attach-context.sh"     "$dst\attach-context.sh"     -Force
Copy-Item "$src\block-dev-commands.sh" "$dst\block-dev-commands.sh" -Force
Copy-Item "$src\README.md"             "$dst\README.md"             -Force
```

## 3. 왜 R-3 가 중요한가 (적용 전 위험)

기존 `attach-context.ps1/.sh` 는 다음 **아카이브/이동된 파일**을 첨부 대상으로 가리킵니다 (Test-Path 가드로 조용히 skip → **자동 첨부 실패**):
- `Doc/_dev_rules/hooks/anti-simplification.md` (→ 2026-06-18 `_archive/hooks/` 이동)
- `Doc/_dev_rules/hooks/asis-coverage-check.md` · `new-screen-pre-build.md` 등
- `Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md` · `24_ASIS_CROSSCHECK.md` · `25_*` · `17_*` (→ 모두 `_dev_rules/_archive/`)

→ 즉 **현재 신규 화면 프롬프트에서 룰 자동 첨부가 사실상 비어 있음.** staged 본은 이를 v2/RULESET_MASTER 경로로 교체하고 UI-MANDATORY 체크리스트를 첨부합니다.

## 4. settings.json (변경 불필요)

`attach-context` / `block-dev-commands` 의 **wiring 자체는 그대로** (파일 내용만 교체). 단, Linux/클라우드 전환 시에만 `command` 를 `bash ....sh` 로 교체 (README §OS 환경 참조). ps1·sh 동시 wiring 금지.
