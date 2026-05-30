# NSCM 바이브코딩 개발 Rule (진입점)

**작성일**: 2026-05-13
**대상**: AI 바이브코딩 (Claude) + 인간 개발자 공통
**원칙**: ⭐ **한 사람이 개발한 것처럼 일관성 있게**
**근거 소스**: `C:\Projects\NSCM` (실제 개발된 nscm-be / nscm-fe 코드 패턴 분석)

## 룰셋 문서 구성

| # | 문서 | 용도 |
|---|---|---|
| 00 | [00_INDEX.md](00_INDEX.md) | (이 파일) 룰셋 진입점 |
| 01 | [01_CLAUDE.md](01_CLAUDE.md) | **AI 바이브코딩 컨텍스트** — 작업 시작 시 반드시 읽어야 할 핵심 룰 |
| 02 | [02_DEVELOPMENT_RULES.md](02_DEVELOPMENT_RULES.md) | 공통 개발 규약 (브랜치/커밋/PR/리뷰) |
| 03 | [03_FE_RULES.md](03_FE_RULES.md) | Frontend (React 19 + Turborepo) 상세 룰 |
| 04 | [04_BE_RULES.md](04_BE_RULES.md) | Backend (Spring Boot 3.5 + Java 21) 상세 룰 |
| 05 | [05_SCREEN_TEMPLATE.md](05_SCREEN_TEMPLATE.md) | 신규 화면 추가 시 표준 템플릿 (FE + BE + DB 한 세트) |
| 06 | [06_HOOKS.md](06_HOOKS.md) | Git Hook + Husky + AI 검증 Hook 룰 (총괄) |
| **06⚠** | **[hooks/anti-simplification.md](hooks/anti-simplification.md)** | ⚠️ **최우선** — 작업 단순화 절대 금지 Rule (2026-05-22 신규). 모든 작업 시작 전 필독. 위반 = 신뢰성 손상 |
| 06a | [hooks/pre-write.md](hooks/pre-write.md) | ⭐ AI Hook — 파일 작성 직전 자기 점검 체크리스트 |
| 06b | [hooks/post-write.md](hooks/post-write.md) | ⭐ AI Hook — 파일 작성 직후 검증 체크리스트 |
| 06c | [hooks/pre-submit.md](hooks/pre-submit.md) | ⭐ AI Hook — PR 제출 직전 최종 검증 체크리스트 |
| 06d | [hooks/screen-analysis-pre-build.md](hooks/screen-analysis-pre-build.md) | ⭐ AI Hook — 화면 분석서 작성 직전 자기 점검 (2026-05-19) |
| 06e | [hooks/screen-analysis-post-build.md](hooks/screen-analysis-post-build.md) | ⭐ AI Hook — 화면 분석서 작성 직후 자동 검증 (12시트 + PNG + MD5 + 카운트) |
| 06f | [hooks/screen-analysis-pre-submit.md](hooks/screen-analysis-pre-submit.md) | ⭐ AI Hook — 화면 분석서 PR 머지 직전 최종 검증 |
| 07 | [07_DO_AND_DONT.md](07_DO_AND_DONT.md) | DO/DON'T 빠른 참조 카드 |
| 08 | [08_SCREEN_REGISTRATION.md](08_SCREEN_REGISTRATION.md) | ⭐ 신규 화면 7개 영역 메타 등록 — 자기완결형 인라인 DML + DBeaver 4-파일 세트 (2026-05-19 PKG 폐기) |
| 09 | [09_WIJMO_VALIDATION_EXPRESSION.md](09_WIJMO_VALIDATION_EXPRESSION.md) | ⭐ As-Is Spread/Grid Validation(2,683건) + Expression(1,766건) → Wijmo FlexGrid/FlexSheet 매핑 + 100% 적용 의무 |
| 10 | [10_API_DYNAMIC_PROC.md](10_API_DYNAMIC_PROC.md) | ⭐ 동적 SP 호출 아키텍처 (NSCM 핵심) — GeneralController + 메타 7영역 + useTabProcQuery 흐름 |
| 11 | [11_AUTH_SECURITY.md](11_AUTH_SECURITY.md) | ⭐ 인증·인가·세션 (@LoginUser/@AuthCheck/SecurityConfig + 권한 2 테이블 동적 복제) |
| 12 | [12_GRID_COMMON.md](12_GRID_COMMON.md) | ⭐ Wijmo Grid 공통 운영 패턴 (DataGrid/EditTracker/GridAction/CRUD_TYPE + finishEditing 안전 패턴) |
| 13 | [13_I18N_MESSAGES.md](13_I18N_MESSAGES.md) | ⭐ i18n MSG/LBL/MNU 코드 + locales JSON + gen_i18n_msg_json.py + API_MSG_ID 동반 INSERT |
| 14 | [14_ERROR_HANDLING.md](14_ERROR_HANDLING.md) | ⭐ 에러 처리 (BaseException + GlobalExceptionHandler + Alert/Toast/Confirm + RFC 7807) |
| 15 | [15_ROUTING_MDI.md](15_ROUTING_MDI.md) | ⭐ React Router + MDI 탭 + LazyLoader + ROUTE_PATHS 상수 + MNU_URL leaf slug |
| 16 | [16_LOGGING_AUDIT.md](16_LOGGING_AUDIT.md) | ⭐ @SystemLog + traceId(ULID) + Logback MDC + SCM_SYS_LOG + $$PLSQL_UNIT |
| 17 | [17_NEW_SCREEN_QUICKSTART.md](17_NEW_SCREEN_QUICKSTART.md) | ⭐ 신규 화면 추가 5분 Quickstart (9 step 압축, 핵심 명령어) |
| 18 | [18_CODE_REVIEW_CHECKLIST.md](18_CODE_REVIEW_CHECKLIST.md) | ⭐ PR 머지 게이트 체크리스트 (사람용, hooks/pre-submit 의 정식 버전) |
| 19 | [19_MOCKUP_SVG_RULES.md](19_MOCKUP_SVG_RULES.md) | ⭐ As-Is Mockup PNG/SVG 생성 룰 v2 (정형 GSCM 빌더 + 백업 PNG 우선 + 누락 0 검증, 2026-05-19) |
| 20 | [20_SCREEN_ANALYSIS_PIPELINE.md](20_SCREEN_ANALYSIS_PIPELINE.md) | ⭐ 화면 분석서(xlsx 12시트 + SVG + MD 8종) 전체 파이프라인 룰 (2026-05-19) |
| 21 | [21_TROUBLESHOOTING.md](21_TROUBLESHOOTING.md) | ⭐ 트러블슈팅 가이드 — Oracle SP 빈 결과 진단 + ORA-XXXXX 에러 분류 + Wijmo finishEditing + PowerShell 한글 모지바케 (2026-05-19) |
| 22 | [22_PACKAGE_ARTIFACTS.md](22_PACKAGE_ARTIFACTS.md) | ⭐ 이관 패키지 (`_{screen_id}_artifacts`) — DB/서버 미연결 환경에서 압축 패키지 표준 + _README + _COMMON_FILES_GUIDE 양식 (2026-05-22, DMF0020 작업 반영) |
| 23 | [23_FE_IMPORT_INVENTORY.md](23_FE_IMPORT_INVENTORY.md) | ⭐ FE Import 인벤토리 — `@shared/*` / `@foundation/*` / global 정확 매핑 (2026-05-22) |
| 24 | [24_ASIS_CROSSCHECK.md](24_ASIS_CROSSCHECK.md) | ⭐ As-Is Cross-Check — Event/API/Validation/Expression 4축 100% 매핑 (2026-05-22) |
| 25 | [25_NEW_SCREEN_MANDATORY_CHECKLIST.md](25_NEW_SCREEN_MANDATORY_CHECKLIST.md) | ⭐⭐ 신규 화면 생성 강제 체크리스트 — 5종 자료 + POPUP 자동 생성 (2026-05-22) |
| 26 | [26_VITE_DAYJS_LOCALE.md](26_VITE_DAYJS_LOCALE.md) | ⭐ Vite + @lges/design-system dayjs/locale 동적 import 해결 (2026-05-22) |
| **27** | **[27_WIJMO_PIVOT_AND_MODULE.md](27_WIJMO_PIVOT_AND_MODULE.md)** | ⭐ **Wijmo 모듈 중복 (`node_modules/node_modules/` → `mergeManager === null`) + Grid header 머지 발동 조건 (TWO_DEPTH + group.header == leaf.header) + PivotGrid React 패턴 (useMemo + 1회 fields 설정 가드) + 신규 sheet 5종 매핑 (2026-05-28, DMF0007 PSI Tab + PivotGrid 작업 반영)** |
| **28** | **[28_GIT_MULTI_REMOTE.md](28_GIT_MULTI_REMOTE.md)** | ⭐ **Git Multi-Remote — NSCM 모노레포 (`leekc297/NSCM` GitHub 개인 백업) + 사내 GitLab `.git` 외부 백업 (`NSCM_gitlab_backup`) + 민감 파일 `.gitignore` 의무 + "소스 업로드" 트리거 (2026-05-28)** |
| **29** | **[29_LOCAL_DB_CSV_IMPORT.md](29_LOCAL_DB_CSV_IMPORT.md)** | ⭐ **로컬 Docker Oracle CSV 적재 표준 — sqlldr ctl 6대 처리 (CR 제거 / 컬럼 quote / DATE / regex precision / multi-line / NOT NULL relax) + 12GB Free 한도 + 200MB 임계 + DM_* 제외 + DDL `/` terminator 자동 삽입 + §2.5 7GB 안전 임계 자동 감시 (2026-05-30, Docker 재구축 + 113 테이블 적재 + 7GB 임계 관리 작업 반영)** |
| **30** | **[30_LOCAL_BACKUP_RESTORE.md](30_LOCAL_BACKUP_RESTORE.md)** | ⭐ **로컬 환경 통합 백업/원복 — D:\NSCM_backup\ + git bundle + FE node_modules tar + Oracle expdp FULL + Windows Task Scheduler 매일 02:00 + daily 7개 + manual 30일 보존. 키워드 "백업해줘" / "원복해줘" 트리거 (2026-05-30)** |
| **31** | **[31_FIGMA_DESIGN_INTEGRATION.md](31_FIGMA_DESIGN_INTEGRATION.md)** | ⭐ **Figma 디자인 → React 신규 화면 연동 — Personal Access Token + REST API fetch + JSON → React 매핑. URL 자동 감지 trigger. Doc/_figma/screens/{화면ID}.md 진실 source + _api_cache/_images gitignore. 룰 23 import inventory cross-check 의무 (2026-05-30)** |
| 06g | [hooks/fe-import-check.md](hooks/fe-import-check.md) | ⭐ Hook — FE Import 자기 점검 (2026-05-22) |
| 06h | [hooks/asis-coverage-check.md](hooks/asis-coverage-check.md) | ⭐ Hook — As-Is 4축 매핑 검증 (2026-05-22) |
| 06i | [hooks/new-screen-pre-build.md](hooks/new-screen-pre-build.md) | ⭐⭐ Hook — 신규 화면 생성 직전 자기 점검 (2026-05-22) |
| **06j** | **[hooks/module-duplication-check.md](hooks/module-duplication-check.md)** | ⭐ **Hook — `node_modules/node_modules/` 잔존 + Vite deps stale 캐시 검출 (2026-05-28)** |
| **06k** | **[hooks/encoding-check.md](hooks/encoding-check.md)** | ⭐ **Hook — VSCode/.editorconfig/터미널 UTF-8 일관성 보장 (2026-05-28)** |
| **06m** | **[hooks/rule-md-organize.md](hooks/rule-md-organize.md)** | ⭐⭐ **Hook 메타룰 — "MD 파일 정리해줘" 트리거 시 7단계 (회고 → 일반화 → 중복 grep → 작성/보강 결정 → 작성 → cross-ref → 검증) (2026-05-28)** |
| **06n** | **[hooks/runtime-error-prevention.md](hooks/runtime-error-prevention.md)** | ⭐ **Hook — 신규 FE 화면/모달 작성 시 기본 런타임 오류 방지 (Box export 누락 / Edit 후 변수 미정의). PRE-WRITE 룰 23 + 기존 화면 import block Read + POST-WRITE grep 검증 의무 (2026-05-28, DMF0020 사고 후)** |
| **06o** | **[hooks/menu-not-displayed-debug.md](hooks/menu-not-displayed-debug.md)** | ⭐ **Hook — 메뉴 클릭 후 화면 미표시 5단계 디버깅 (1=MNU_URL↔FE slug, 2=라우터 매핑, 3=메뉴 권한, 4=부모 권한, 5=런타임 오류). "권한 누락" 단정 금지 (2026-05-29, DMF0043/0043_01/0072 사고)** |

## 기술 스택 (확정)

### Frontend (`nscm-fe`)

| 항목 | 값 |
|---|---|
| Runtime | Node.js ≥ 20.14.0 |
| Package Manager | pnpm ≥ 10.0.0 |
| Monorepo | Turborepo 2.1.x |
| Framework | React 19.2.0 |
| Language | TypeScript 5.7.x |
| Build | Vite 6.x |
| Lint | ESLint 9.x (Flat Config) |
| Style | SCSS Modules |
| State | Zustand 5.x |
| HTTP | Axios 1.7.x |
| Grid | @mescius/wijmo (FlexGrid + FlexSheet) |
| UI Lib | MUI (Grid, Modal 등 일부 사용) |
| i18n | @foundation/i18n (자체 래퍼) |
| Test | Vitest |

### Backend (`nscm-be`)

| 항목 | 값 |
|---|---|
| Runtime | Java 21 |
| Framework | Spring Boot 3.5.5 |
| Build | Gradle (Java plugin) |
| DB Access | MyBatis-Spring-Boot 3.0.5 |
| DB | Oracle 19c (운영) + MSSQL 12.4 (전환기) |
| Security | Spring Security |
| Lombok | ✓ |
| API Doc | springdoc-openapi 2.8.0 (Swagger UI) |
| Validation | spring-boot-starter-validation |
| Format | Spotless 6.3.0 |
| ID 생성 | ULID (ulid-creator 5.2.2) |
| Package Base | `com.lgcns.nscm` |
| WAR 이름 | `nscm.war` |

## 3-Layer Architecture (Frontend)

```
┌────────────────────────────────────────────────────────┐
│  Layer 3: Application — apps/web + features/*         │
│           페이지, 비즈니스 로직, MDI 탭 관리          │
└────────────────────┬───────────────────────────────────┘
                     │ 사용 (단방향)
                     ▼
┌────────────────────────────────────────────────────────┐
│  Layer 2: Shared (@shared) — packages/shared          │
│           재사용 컴포넌트, 훅, 전역 스토어             │
└────────────────────┬───────────────────────────────────┘
                     │ 사용 (단방향)
                     ▼
┌────────────────────────────────────────────────────────┐
│  Layer 1: Foundation (@foundation) — packages/foundation
│           순수 함수, 타입, HTTP, 디자인 시스템         │
└────────────────────────────────────────────────────────┘
```

**규칙**:
- ✅ 하위 Layer는 상위 Layer 호출 가능
- ❌ 상위 Layer가 하위 Layer 호출 금지
- ❌ Feature 간 직접 호출 금지 (apps/web에서 조합)

## Backend Layered Architecture

```
Controller    ─→ Service (interface) ─→ ServiceImpl ─→ BaseService ─→ MyBatis
   ↓
BaseController                                                            ↓
   ↓                                                                      ↓
BaseResponse<T>                                                       Oracle/MSSQL
   ↓                                                                  PKG.Procedure
ResponseEntity                                                        (DATARESULT cursor)
```

## 도메인 매핑 (As-Is → To-Be)

| As-Is (GSCM) | To-Be FE (features) | To-Be BE (package) | DB Schema |
|---|---|---|---|
| DM (Demand) | `features/demand` | `com.lgcns.nscm.demand` | `SCM_MGR` (PKG_DMF*) |
| SCM (Master) | `features/master` | `com.lgcns.nscm.master` | `SCM_MGR` (PKG_SCM*) |
| Common | `features/admin` | `com.lgcns.nscm.admin` | `SCM_MGR` (PKG_NSCM_UI_*, PKG_SYS*) |
| FP | `features/factory` (검토) | `com.lgcns.nscm.factory` | `FP_MGR` |
| SCP | `features/supply` | `com.lgcns.nscm.supply` | `SCM_MGR` |
| SSP | `features/shipping` | `com.lgcns.nscm.shipping` | `SCM_MGR` |

## 절대 규칙 (위반 시 즉시 PR Reject)

1. **Layer 의존 방향**: Foundation ← Shared ← Application (역방향 금지)
2. **Feature 간 직접 import 금지**: `features/demand`가 `features/master`를 import하지 않는다
3. **MenuId/SheetName/ResponseSet은 enum + as const**: `user-management.constants.ts` 패턴
4. **API 호출은 반드시 useTabProcQuery / useProcMutation**: 직접 fetch 금지
5. **Backend SQL ID는 nameSpace + 메서드명**: hardcoded 문자열 금지
6. **모든 API 응답은 BaseResponse<T>**: ResponseEntity 직접 작성 금지
7. **DTO는 `*.dto.*` 패키지 + Builder 패턴 + `of()` 정적 팩토리**
8. **Service Interface + ServiceImpl 분리**: 단일 클래스 금지
9. **클래스/메서드 주석은 표준 Javadoc 헤더**: `@Project @Package @FileName @author @date @description`
10. ⭐ **As-Is Validation/Expression 100% 매핑**: 신규 화면 FE 작업 시 `validation.md`/`expressions.md` 행 수 == 적용 건수, `__asis-mapping__.md` 매트릭스 작성 의무

## 룰 검증 흐름

```
1. 코드 작성 (Claude 또는 사람)
   ↓
2. 로컬 검증
   - FE: pnpm lint + type-check + test
   - BE: ./gradlew spotlessApply build
   ↓
3. Husky pre-commit Hook
   - FE: lint-staged (eslint --fix + prettier --write)
   - BE: spotless apply + 단위 테스트
   ↓
4. Husky pre-push Hook
   - 브랜치명 검증 (feat/fix/docs/style/refactor/test/chore)
   - type-check
   ↓
5. CI (GitLab)
   - 빌드 + 테스트 + Sonar
```

> 본 룰은 실제 개발된 `C:\Projects\NSCM` 코드를 역추적하여 도출되었으며, "한 사람이 일관성 있게 개발한 것처럼" 보이도록 모든 신규 코드는 본 룰을 따라야 합니다.
