# 화면 폴더 템플릿

> 한 화면 = 한 폴더 = 6개 .md 의 셀프-컨테인 단위.

## 사용법

Phase 3 도메인별 분석 시, 자동 스캐너가 본 템플릿을 복사해 각 화면 폴더에 깔고, 부분적으로 채워둡니다 (다음을 자동 채움):

| 자동 채움 | 사용자 보강 |
|---|---|
| `analysis.md` 1·3·4·6·7 (화면 메타·컨트롤·이벤트·SP·테이블) | 5 (비즈니스 룰 인터뷰), 9 (알려진 이슈) |
| `tobe_design.md` 라이브러리 미정 항목 | 라이브러리 결정 후 일괄 채움 |
| `web_components.md` 컨트롤 매핑 | 디자인 결정 후 |
| `oracle_migration.md` SP 변환 패턴 자동 식별 | 검증 |
| `source_links.md` 자동 (경로 매칭) | - |
| `figma_link.md` 빈 칸 | 사용자가 채움 |

## 6개 .md 역할 (요약)

| 파일 | 한 줄 요약 |
|---|---|
| `analysis.md` | As-Is 동작·룰·DB 의존을 클로드 코드가 To-Be 작성에 쓸 수 있을 만큼 정밀하게 |
| `tobe_design.md` | Web 화면 설계 의도 (라이브러리 무관) |
| `web_components.md` | WinForms→Web 컴포넌트 매핑 (라이브러리 미정 → 결정 후 채움) |
| `oracle_migration.md` | T-SQL→PL/SQL 변환 가이드 |
| `source_links.md` | Legacy 소스 직접 참조 인덱스 |
| `figma_link.md` | Figma 디자인 링크 (사용자 작성) |
