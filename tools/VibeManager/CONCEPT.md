# Vibe_Manager v1.0 — 개념 메모 (구현은 단계별 기능 완성 뒤)

VS Code 확장. NSCM 전환 6단계의 작업을 사이드바에서 고르고, **프로그램(화면) ID 만 입력**하면 단계별 작업이 돌아가게 하는 관리 패널.

## 기능 묶음
1. 단계·작업 실행 — steps.json 으로 정의된 작업(PowerShell 스크립트 / Claude Code 지시 / 파일 열기) 을 트리에서 실행. 산출물 건수·0건 게이트를 자동 판정해 단계 상태 표시.
2. 프로그램 ID 중심 반복 작업 — ID 입력 → As-is Pack 확인 → Agent 문서 → To-Be Fact → GAP → 개발 → GAP 확정까지 한 줄로.
3. 소스 작업 보조 — 작업 전/후 소스 비교(diff), 작업 history(실행 기록·프롬프트·게이트 결과) 열람. Claude Code 로 코딩하듯 쓰되 기록이 남게.
4. **환경설정** — DB 접속(As-is MSSQL `.env.asis`, To-Be Oracle), 소스 루트(GSCM, nscm-fe, nscm-be), 산출물 폴더, Claude CLI 경로/모델, Agent 드라이버. 비밀번호는 저장하지 않고 .env 파일 참조만.
5. **룰·Hook·하네스 관리** — 개발 룰(MD), 허용 GAP 목록(allowed_gaps.csv), DB 변경 룰, PR/커밋 Hook(husky), Claude Code 설정(CLAUDE.md, hooks, skills) 을 한 화면에서 보고 켜고 끄고 버전 관리. 룰 보완(6단계) 결과가 여기로 들어와 원천 차단이 되는지 점검.

## 구현 메모
- 순수 JS(의존성 0) + `.vsix` 직접 패키징(네트워크 불필요). 작업 정의는 데이터(steps.json) 로 두어 단계 기능이 추가될 때 코드 수정 없이 확장.
- 작업 실행은 VS Code Tasks API(종료 코드 수집) / Claude Code 는 터미널에 `claude` 띄우고 프롬프트 파일 경로를 첫 지시로 전달.
