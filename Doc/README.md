# Doc/ — LGES GSCM 분석·소스·바이브코딩 작업 폴더

작성: 2026-05-08 (Phase 2-Z)

> 본 폴더는 **As-Is 분석 자료 + Legacy 원본 소스 + 바이브 코딩 가이드 + Figma 링크**를 한 곳에 모아둔 작업 공간입니다.
> 클로드 코드(또는 다른 AI 코딩 에이전트)가 화면 단위로 To-Be를 작성할 때, **한 화면 = 한 폴더**가 self-contained 컨텍스트가 되도록 설계되었습니다.

---

## 디렉토리 구조

```
Doc/
├── _legacy_source/              ← As-Is 원본 (바이브코딩 시 직접 참조)
│   ├── 01_Framework/            ← App.Core / Windows.Forms / UIModel
│   ├── 03_BIZ/                  ← 도메인 BIZ 라이브러리
│   ├── 04_WSL/                  ← Web Service Layer (대부분 빈 껍질)
│   ├── 06_UIL/                  ← UI Layer (1화면=1csproj)
│   │   ├── domain_DM/           ← Demand 도메인 화면
│   │   ├── domain_FP/           ← Forecast Plan
│   │   ├── domain_SCP/          ← Supply Chain Plan
│   │   ├── domain_SSP/          ← Sales/Shipment Sourcing Plan
│   │   ├── domain_SCM/          ← SCM 마스터/팝업
│   │   └── common/              ← SystemMgmt, 공통 컴포넌트
│   ├── DB_DDL/                  ← Tables/Views/SPs/Types DDL 분리 보관
│   └── External_Interfaces/     ← RFC, WebService, Updater 소스
│
├── _analysis/                   ← 분석 자료 (바이브코딩 시 첫 참조)
│   ├── domain_Common/
│   │   ├── 00_domain_overview.md
│   │   ├── screens/
│   │   │   └── <SCREEN_ID>/
│   │   │       ├── analysis.md            ← As-Is 화면 정밀 분석
│   │   │       ├── tobe_design.md         ← To-Be 화면 설계
│   │   │       ├── web_components.md      ← Web 컴포넌트 매핑
│   │   │       ├── oracle_migration.md    ← T-SQL→PL/SQL 변환
│   │   │       ├── source_links.md        ← Legacy 소스 링크
│   │   │       └── figma_link.md          ← Figma 디자인 링크
│   │   ├── sps/                           ← 도메인 SP 본문 분석
│   │   ├── tables/                        ← 도메인 테이블·ERD
│   │   └── api_endpoints/                 ← 도메인 API 명세
│   ├── domain_SCM/  (동일 구조)
│   ├── domain_DM/   (동일 구조)
│   ├── domain_SCP/  (동일 구조)
│   ├── domain_SSP/  (동일 구조)
│   └── domain_FP/   (동일 구조)
│
├── _dev_rules/                  ← ⭐ 정식 바이브코딩 룰셋 (00~21 + hooks)
│   ├── 00_INDEX.md ~ 21_TROUBLESHOOTING.md
│   └── hooks/  (pre-write / post-write / pre-submit + screen-analysis-*)
│
├── _archive/_vibe_coding/       ← 2026-05-21 archive 이관 (구버전 Phase 2-Z)
│   └── _ARCHIVE_NOTICE.md       ← 신버전 매핑표
│
├── _figma/                      ← Figma 디자인 링크 (사용자 작성)
│   └── README.md
│
└── _templates/                  ← 폴더/문서 템플릿 (참조용)
    └── screen_template/         ← 화면 폴더 템플릿 6종
```

---

## 작업 흐름 (도메인별 Phase 3 진입 시)

각 도메인은 6단계로 진행합니다.

| 단계 | 작업 | 결과 위치 |
|---|---|---|
| 1 | 도메인 소스를 `_legacy_source/06_UIL/domain_<X>/`로 복사 | `_legacy_source/` |
| 2 | 도메인 통합 스캔 (화면+endpoint+DB 매핑) | `_analysis/_scan/phase3_<X>.json` (워크스페이스 루트) |
| 3 | 화면별 6개 .md 산출 (template 기반) | `_analysis/domain_<X>/screens/<SCREEN>/` |
| 4 | 도메인 SP 본문 정밀 + Oracle 변환 가이드 | `_analysis/domain_<X>/sps/` |
| 5 | 도메인 ERD + API 엔드포인트 명세 | `_analysis/domain_<X>/tables/`, `api_endpoints/` |
| 6 | 도메인 종합 산출물 (.md + .docx + .xlsx) | 워크스페이스 루트 `0X_<도메인>_Analysis.{md,docx,xlsx}` |

---

## 한 화면 폴더의 6개 .md 역할

| 파일 | 역할 | 작성 시점 | 분량 |
|---|---|---|---|
| `analysis.md` | **As-Is 정밀 분석** — 화면 입력/출력/이벤트/SP/테이블/검증 룰 | Phase 3 화면별 분석 시 | 200~600 lines |
| `tobe_design.md` | **To-Be 화면 설계** — 레이아웃, 인터랙션, 데이터 흐름 (Web 기준, 라이브러리 unbound) | Phase 3 또는 Figma 후 | 100~300 lines |
| `web_components.md` | **Web 컴포넌트 매핑** — WinForms 컨트롤 → Web 컴포넌트 (확정: MUI 7.3 + Wijmo 5) | Phase 3 | 50~200 lines |
| `oracle_migration.md` | **T-SQL→PL/SQL 변환** — 화면이 호출하는 SP/View의 비호환 패턴 + 변환 가이드 | Phase 3 | 100~300 lines |
| `source_links.md` | **Legacy 소스 링크 인덱스** — `_legacy_source/`의 .cs/.sql 파일 직접 참조 (바이브코딩 시 깊이 파고들 때) | Phase 3 | 30~80 lines |
| `figma_link.md` | **Figma 디자인 링크** — 사용자(이규철님)가 Figma 작성 후 링크 기입 | 사용자 작성 | 10~30 lines |

---

## 바이브 코딩 시 참조 우선순위

클로드 코드가 한 화면을 To-Be로 작성할 때 다음 순서로 참조합니다:

1. **`figma_link.md`** — UI 디자인 명세
2. **`tobe_design.md`** — 화면 설계 의도
3. **`web_components.md`** — 컴포넌트 매핑
4. **`analysis.md`** — As-Is 비즈니스 룰 (필요할 때만)
5. **`oracle_migration.md`** — DB 호출 시
6. **`source_links.md` → `_legacy_source/`** — 위 5개로 부족할 때 원본 직접 참조
7. **`_dev_rules/*.md`** — 정식 바이브코딩 룰셋 (구 `_vibe_coding` 은 `_archive/_vibe_coding/` 으로 이관)

---

## 명명 규칙

- **화면 폴더 ID**: 원본 csproj 이름 사용 (예: `SCP0049_CAPA`, `DMF0042_BizPlan`, `GSCM.SSP.Plan.UIL`)
- **도메인 폴더**: `domain_<도메인코드>` (소문자: `domain_dm`이 아니라 `domain_DM`)
- **MD 파일명**: 위 6종은 정확히 그대로 (analysis.md / tobe_design.md / web_components.md / oracle_migration.md / source_links.md / figma_link.md)
- 추가 파일은 자유 (예: `screenshots/`, `notes_<author>.md`)

---

## 본 표준의 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-08 | 초기 표준 (Phase 2-Z) — 6개 .md 화면 템플릿, _vibe_coding 가이드 5종 |

---

## 🎯 To-Be 기술스택 확정 (2026-05-11)

본 문서의 "To-Be 미확정" 표현은 **NSCM 프로젝트 기술스택 확정**으로 모두 갱신되었습니다.
상세: `28_ToBe_NSCM_Analysis.xlsx`/.md

| 영역 | 확정 기술스택 |
|---|---|
| **Backend** | Java 21 + Spring Boot 3.5.5 + Gradle 8.8 + MyBatis 3.0.5 |
| **Frontend** | React 18 + TypeScript 5.7 + Vite 6 + **Turborepo Monorepo** |
| **UI Library** | **MUI 7.3.7** + **Wijmo 5.20252 (FlexGrid + FlexSheet)** + Emotion |
| **State** | **TanStack Query 5** (server) + **Zustand 5** (UI) + Immer 11 |
| **Form** | React Hook Form + Zod schema |
| **DB** | **Oracle 19c** (SCM_MGR, AL32UTF8, RBAC: RL_SCM_DML/SEL/SCMD_APP) |
| **Dual DB (마이그 기간)** | Oracle 19c + MS-SQL (병행 운영, ojdbc11 + mssql-jdbc 12.4) |
| **Auth** | Spring Security + LG SSO (개발 진행, QA 환경 시 재개) |
| **API 문서** | SpringDoc OpenAPI 2.8 (Swagger UI) |
| **외부 연동** | SAP JCo (sapjco3.jar) + Spring WS (WSDL/SOAP) + Apache POI 5.4 |
| **로깅** | log4jdbc-log4j2 + Logback |
| **암호화** | Jasypt 3.0.5 (설정 파일 암호화) |
| **모노레포 구조** | apps/web (진입점) + features/{admin,demand,factory,master,shipping,supply} + packages/{foundation, shared} |
| **As-Is 도메인 → To-Be features** | DM→demand / FP→factory / SCP→supply / SSP→shipping / SCM→master / Common→admin |
