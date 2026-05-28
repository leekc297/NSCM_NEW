# Doc/_dev_rules — NSCM 바이브코딩 룰셋

> **목적**: 한 사람이 개발한 것처럼 일관성 있는 코드 생산 보장.
> **대상**: 인간 개발자 + AI(Claude) 공통.
> **근거**: `C:\Projects\NSCM` (실제 To-Be 코드 패턴 역추적).

## 1. 읽는 순서

### 1.1 처음 작업하는 사람 / AI

```
1. ../../CLAUDE.md (워크스페이스 루트, 자동 로드)
2. 00_INDEX.md
3. 01_CLAUDE.md  ← 핵심 컨텍스트
4. 07_DO_AND_DONT.md ← 빠른 참조
```

### 1.2 작업 영역별

| 작업 | 읽을 순서 |
|---|---|
| FE 기능 추가 | 01 → 03_FE_RULES → 10_API_DYNAMIC_PROC → 12_GRID_COMMON → 05_SCREEN_TEMPLATE → 09_WIJMO_VALIDATION_EXPRESSION |
| BE 기능 추가 | 01 → 04_BE_RULES → 10_API_DYNAMIC_PROC → 05_SCREEN_TEMPLATE → 08_SCREEN_REGISTRATION |
| 신규 화면 (FE+BE+DB) | **17_NEW_SCREEN_QUICKSTART** (5분 요약) → 01 → 10 → 05 → 08 → 09 → 12 |
| ⭐ PR 머지 전 | 18_CODE_REVIEW_CHECKLIST + 07_DO_AND_DONT |
| 에러 처리 | 14_ERROR_HANDLING + 21_TROUBLESHOOTING |
| As-Is 화면 마이그레이션 (Wijmo 적용) | 09_WIJMO_VALIDATION_EXPRESSION → 03_FE_RULES §12 → 05_SCREEN_TEMPLATE §2.8/2.9/2.10 |
| ⭐ 화면 분석서(xlsx 12시트) 작성/보강 | 20_SCREEN_ANALYSIS_PIPELINE → 19_MOCKUP_SVG_RULES → 09 → hooks/screen-analysis-* |
| 브랜치/커밋/PR | 02_DEVELOPMENT_RULES |
| Hook 설정 | 06_HOOKS |
| DB 변환 (MSSQL→Oracle) | `../_analysis/db_migration/01~03` |

## 2. 룰셋 목록

| # | 문서 | 주제 | 분량 |
|---|---|---|---:|
| 00 | [00_INDEX.md](00_INDEX.md) | 진입점 + 기술스택 + 도메인 매핑 | 중 |
| 01 | [01_CLAUDE.md](01_CLAUDE.md) | AI 컨텍스트 + 표준 코드 템플릿 | 대 |
| 02 | [02_DEVELOPMENT_RULES.md](02_DEVELOPMENT_RULES.md) | 브랜치/커밋/PR/리뷰 | 중 |
| 03 | [03_FE_RULES.md](03_FE_RULES.md) | Frontend (React 19) 상세 | 대 |
| 04 | [04_BE_RULES.md](04_BE_RULES.md) | Backend (Spring Boot 3.5) 상세 | 대 |
| 05 | [05_SCREEN_TEMPLATE.md](05_SCREEN_TEMPLATE.md) | 신규 화면 코드 템플릿 | 대 |
| 06 | [06_HOOKS.md](06_HOOKS.md) | Git/Husky/AI/CI Hook | 중 |
| 07 | [07_DO_AND_DONT.md](07_DO_AND_DONT.md) | DO/DON'T 1-pager | 소 |
| 08 | [08_SCREEN_REGISTRATION.md](08_SCREEN_REGISTRATION.md) | ⭐ 신규 화면 7개 영역 메타 등록 (자기완결형 인라인 DML + 4-파일 SQL 세트, 2026-05-19 PKG 폐기) | 대 |
| 09 | [09_WIJMO_VALIDATION_EXPRESSION.md](09_WIJMO_VALIDATION_EXPRESSION.md) | ⭐ As-Is Spread Validation/Expression → Wijmo 매핑 | 대 |
| 10 | [10_API_DYNAMIC_PROC.md](10_API_DYNAMIC_PROC.md) | ⭐ 동적 SP 호출 아키텍처 (NSCM 핵심) | 대 |
| 11 | [11_AUTH_SECURITY.md](11_AUTH_SECURITY.md) | ⭐ 인증·인가·세션 (@LoginUser/@AuthCheck + 권한 2 테이블) | 중 |
| 12 | [12_GRID_COMMON.md](12_GRID_COMMON.md) | ⭐ Wijmo Grid 공통 운영 패턴 | 중 |
| 13 | [13_I18N_MESSAGES.md](13_I18N_MESSAGES.md) | ⭐ i18n MSG/LBL/MNU 코드 + locales JSON | 중 |
| 14 | [14_ERROR_HANDLING.md](14_ERROR_HANDLING.md) | ⭐ 에러 처리 (BaseException + Alert/Toast + RFC 7807) | 중 |
| 15 | [15_ROUTING_MDI.md](15_ROUTING_MDI.md) | ⭐ React Router + MDI 탭 + LazyLoader | 중 |
| 16 | [16_LOGGING_AUDIT.md](16_LOGGING_AUDIT.md) | ⭐ @SystemLog + traceId + Logback MDC + SCM_SYS_LOG | 중 |
| 17 | [17_NEW_SCREEN_QUICKSTART.md](17_NEW_SCREEN_QUICKSTART.md) | ⭐ 신규 화면 5분 Quickstart (9 step 압축) | 소 |
| 18 | [18_CODE_REVIEW_CHECKLIST.md](18_CODE_REVIEW_CHECKLIST.md) | ⭐ PR 머지 게이트 체크리스트 (사람용) | 중 |
| 19 | [19_MOCKUP_SVG_RULES.md](19_MOCKUP_SVG_RULES.md) | ⭐ Mockup SVG/PNG 생성 룰 v2 (정형 GSCM 빌더, 2026-05-19) | 중 |
| 20 | [20_SCREEN_ANALYSIS_PIPELINE.md](20_SCREEN_ANALYSIS_PIPELINE.md) | ⭐ 화면 분석서 12시트 파이프라인 (2026-05-19) | 중 |
| 21 | [21_TROUBLESHOOTING.md](21_TROUBLESHOOTING.md) | ⭐ 트러블슈팅 가이드 (Oracle/DBeaver/Wijmo/PowerShell, 2026-05-19) | 중 |
| 22 | [22_PACKAGE_ARTIFACTS.md](22_PACKAGE_ARTIFACTS.md) | ⭐ 이관 패키지 (`_artifacts`) 표준 — DB/서버 미연결 환경 (2026-05-22) | 중 |

## 3. AI 검증 Hook (`hooks/`)

| Hook | 시점 | 용도 |
|---|---|---|
| [pre-write.md](hooks/pre-write.md) | 코드 작성 전 | 영역/명명/Layer/기존 패턴 점검 |
| [post-write.md](hooks/post-write.md) | 작성 직후 | TS/Java/XML/SQL 위반 + 메타 Table + procedures.d.ts |
| [pre-submit.md](hooks/pre-submit.md) | PR 제출 직전 | 빌드/통합/일관성/문서/메타/타입 최종 검증 |

## 4. 변경 정책

룰 변경 시:
1. PR 작성 (`chore(dev-rules): ...`)
2. 영향 받는 모든 룰셋 cross-reference 확인 (검색 + 갱신)
3. `CLAUDE.md` (워크스페이스 루트) 동기화
4. 메모리 `project_nscm_dev_rules.md` 갱신
5. 팀 공유 (Slack/Wiki)

## 5. 룰셋 자체 검증 (매월 1회)

```
[ ] 실제 코드(`C:\Projects\NSCM`)와 룰셋 패턴 일치 확인
[ ] DO/DON'T 항목이 최신 코드 베이스와 일치
[ ] 추가된 라이브러리/패턴 반영
[ ] 빌드 명령 (pnpm/gradlew) 최신
[ ] Cross-reference (00↔01↔05↔08) 일치
```

## 6. 룰 위반 적발 시

```
1. 위반 코드 PR 단계에서 reject
2. 코드 작성자에게 해당 룰 문서 링크 공유
3. 룰이 명확하지 않다면 → 룰셋 보강 PR
4. 반복 위반 시 → 팀 회의에서 hook 강화
```

## 7. 관련 외부 산출물

| 산출물 | 위치 | 용도 |
|---|---|---|
| DB 변환 룰셋 | `../_analysis/db_migration/` | MSSQL → Oracle |
| To-Be v2 산출물 | `../../To-be_v2_converted/` | Oracle 변환 결과 |
| 화면 등록 PKG | `../../To-be_v2_converted/08_Screen_Registration/` | 메타 Table 자동 등록 |
| As-Is 분석 자료 | `../_analysis/domain_*/` | 화면별 validation/analysis MD |
| Workspace CLAUDE | `../../CLAUDE.md` | 작업 시작 시 자동 로드 |

## 8. FAQ

**Q. 룰이 두 문서에 다르게 쓰여 있다면?**
A. `01_CLAUDE.md`가 우선. 실제 코드(`C:\Projects\NSCM`)와도 차이 있으면 코드 기준.

**Q. 새 라이브러리를 도입하고 싶다면?**
A. 03_FE_RULES 또는 04_BE_RULES에 추가 후 팀 합의. 단일 PR로 진행.

**Q. 화면 등록 자동화 PKG가 실패하면?**
A. `08_SCREEN_REGISTRATION.md` §7 롤백 절차 참조. 또는 개별 DELETE 후 재등록.

**Q. AI(Claude)가 룰을 어겼다면?**
A. pre-write/post-write/pre-submit hook이 한 번이라도 작동했는지 확인. 작동 안 했으면 hook 강화.

---

> 룰셋 전체는 살아있는 문서입니다. 코드 베이스 변경 시 적시에 갱신하세요.
