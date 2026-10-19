## 1.2.1 (2026-10-19)
- S5: 등록 되돌리기(`<ID>_revert.sql` 미리보기/커밋), 파이프라인 `--regen-pkg`(이식된 PKG 보존이 기본이 됨)
- S7: dev-login 가능 계정 확인(`probe-accounts.js`), 스모크/CRUD/권한 작업에 화면ID 입력
- 러너: npm/npx/브라우저 다운로드 제거(로컬 Chrome 사용) — Local 환경 보호

## 1.2.0 (2026-10-16)
- **완료 정의(DoD) 패널** 신설: 현재 화면의 DOD.md(B01~B21 ✅/❌), FE 게이트 BLOCK/WARN(클릭 → 파일:라인), PKG 게이트, 파이프라인·E2E·골든·신뢰도 한눈에
- **ID 하나로 끝까지**(pipeline.js): FE 골격 → 등록 SQL → PKG 골격 → FE 수선(Claude ×3) → PKG 이식(Claude ×3) → E2E 스펙 → 대사표. 드라이런(--no-claude) 작업 포함
- 2단계: To-Be 프레임워크·공통 카탈로그(framework.js) 생성/열기
- 빠른 실행에 ★ 파이프라인 항목, 화면 선택 시 DoD 패널 자동 갱신

## 1.1.0 (2026-10-16)
- 작업 종류 `python` / `cmd` 추가 (설정 `vibeManager.pythonCommand`)
- 2단계: DB 접속 점검(probe.py) · To-Be Oracle 메타 export(export_tobe_meta.py) · dbconn.json 열기 — 접속정보는 tools/DbConn/dbconn.json + .env.asis 로 일원화(비밀번호 미표시)
- 1단계: 개발대상 대사표(Recon) — xlsx→csv, recon.js, 대시보드
- 4단계: 골든 테스트(As-is SP ↔ To-Be PROC 결과 대조) 케이스 생성/실행/열기
- 5단계: 자동 수선 루프(repair-loop.js: gen→Claude→게이트 ×3) · 컴파일/린트 게이트(check.js --tsc --lint; --final 에 포함)
- 7단계 신설: E2E(Playwright) — 계정/권한매트릭스 추출, 스펙 생성, 스모크/CRUD/권한·Division 실행, 결과/HTML 리포트
- 빠른 실행(화면ID): 자동 수선 · 골든 · E2E 전체 항목 추가

# Changelog
## 1.0.0 — 2026-10-16
- 최초 릴리스: 6단계 트리(30작업)·게이트 판정·대시보드·상태표시줄, 프로그램 ID 빠른 실행, 룰·Hook·하네스 뷰(hook 켜기/끄기), 환경설정 뷰·환경 점검, 실행 이력, 전/후 소스 비교(git), Agent 배치/게이트 집계.
