# Vibe_Manager v1.0 — NSCM 전환 작업 관리 (VS Code 확장)

As-is C#.NET → To-Be React/Oracle 전환의 6단계 작업을 사이드바에서 실행하고, 산출물로 완료를 기계 판정한다. 의존성 없음(순수 JS), 네트워크 불필요.

## 설치 (노트북, 오프라인)
1. VS Code → 확장 뷰 `…` 메뉴 → **VSIX 에서 설치** → `C:\Projects\NSCM\tools\VibeManager\dist\vibe-manager-1.0.0.vsix`
2. `C:\Projects\NSCM` 을 워크스페이스로 연다(루트에 `tools\AsisFacts` 가 있으면 자동 인식, 아니면 설정 `vibeManager.projectRoot`).
3. 왼쪽 활동 바의 Vibe_Manager 아이콘.

## 뷰 3개
- **NSCM 전환 단계** — 6단계 × 30작업. 클릭 = 실행. 작업 종류: PowerShell(파서·Agent), Node(gap/check/suggest), Claude Code 지시(터미널에 `claude` 띄우고 프롬프트 전달), 파일/폴더 열기, 브라우저(GAP 대시보드), Agent 배치, 게이트 집계, 전/후 소스 비교(git HEAD ↔ 작업본). 각 작업의 **게이트**(교차검증 0건, `_gate.csv` PASS, GEN_NOTES 존재…)를 자동 판정해 아이콘으로 표시.
- **룰 · Hook · 하네스** — `tools/Harness/rules/*.csv`(행 수 표시, 클릭 편집), `.claude/settings.json` 의 Claude Code hook 목록(켜기/끄기 — 끄면 명령을 `cmd /c exit 0` 으로 바꾸고 원본을 `_origCommand` 에 보관, 백업 `settings.json.bak_vibe`), `nscm-fe/.husky` Git hook, 룰 문서 색인.
- **환경설정** — `.env.asis`, `asisfacts.json`, `tobefacts.json`, `harness.json`, `.claude/settings.json` 의 키/값을 트리로(비밀번호·토큰 값은 `••••••`). `환경 점검` 버튼 → node/dotnet/python/git/claude 버전과 산출물 유무 리포트.

## 프로그램 ID 하나로 (⚡ 버튼 / 명령 `Vibe_Manager: 프로그램 ID 로 단계 작업 실행`)
ID 를 넣으면 그 화면의 현재 상태(Fact Pack·Agent 문서·GAP·골격)를 보고 다음 할 일을 고른다: Fact Pack 열기 → Agent 문서 생성 → GAP → 신규 화면 골격 생성(`new-screen.ps1`) → Claude Code TODO 이식 → 게이트/최종 게이트 → 전/후 비교 → 문서 3종 확정.

## 상태 표시줄 · 대시보드 · 이력
- 상태 표시줄 `🚀 Vibe_Manager n/6` 클릭 → 6단계 대시보드(각 작업 ▶ 실행).
- 실행 이력 `.vibe/runs.log`, 게이트 리포트 `.vibe/reports/`, 단계 정의 커스터마이즈 `.vibe/steps.json`(내장본 복사 후 편집).

## 설정(vibeManager.*)
projectRoot · toolsDir · harnessDir · outDir · tobeDir · tobeOutDir · rulesDir · gapDir · genDir · powershell · nodeCommand · claudeCommand · claudeModel · claudeStartupDelayMs · agentDriver · agentModel · excludeScreenPatterns · envFiles

## 패키징(개발자)
`python3 build_vsix.py` → `dist/vibe-manager-1.0.0.vsix` (vsce 불필요).
