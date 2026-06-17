# CLAUDE.md — NSCM 작업 시 필수 컨텍스트

> ⭐ **AI 바이브코딩 시 이 파일을 가장 먼저 읽어야 합니다.**
> 작업 영역에 따라 추가로 읽어야 할 파일이 있습니다.

## Model Fallback Policy
- Primary: Opus 4.7 (아키텍처 설계, 다중 모듈 리팩토링)
- Fallback (529/overload 시): Sonnet 4.6
- 단순 작업 (CRUD, 단일 파일 수정): Sonnet 4.6 기본 사용

## 1. 프로젝트

**LG Energy Solution NSCM (Next SCM)**
- AS-IS: GSCM C#.NET WinForms (358 csproj, 4,162 cs, 2,771 SPs)
- TO-BE: React 19 + Spring Boot 3.5 + Oracle 19c
- 도메인: DM(Demand) / SCM(Master) / FP(Factory) / SCP(Supply) / SSP(Shipping) / Common(Admin)

## 2. 작업 시작 시 필수 행동 (반드시 순서대로)

### Step 1: 룰셋 로드 (룰셋 v2 — 3 진입점만, 모든 작업) ⭐ 2026-06-11 갱신
```
Read: Doc/_rules_v2/anti-simplification.md  ⚠️ ⭐ 최우선 — 단순화 절대 금지 (불변)
Read: Doc/_rules_v2/CLAUDE.md               ← 분기 라우터 (작업 트리거 → 진입 룰)
Read: Doc/_rules_v2/00_INDEX.md §A 트리거 매트릭스 ← 20 트리거 × 룰/Hook 자동 분기
```

> ⭐ **3 진입점 정책 (룰셋 v2, 2026-06-03 / 2026-06-11 갱신)**:
> 위 3 파일만 1차 로드. **모든 도메인별 룰/hook 은 `00_INDEX.md` 의 20-트리거 매트릭스가 작업 키워드에 따라 자동 분기.**
> 룰셋 v2 구조: `_asis/00_framework` (7 정밀) + `_asis/01_popups` (인벤토리) + `_tobe/01~13` (13 룰) + `_mapping/asis_to_tobe.md` (10 격차) + `hooks/` (50 hook — 00_INDEX §B.3 카탈로그가 단일 진실 source).
>
> ⭐ **2대 통합 진입 hook (2026-06-11 신설)** — 해당 작업 시 개별 hook 보다 먼저 읽기:
> - **Oracle SP/DB 작업 전부** → `Doc/_rules_v2/hooks/oracle-db-workflow.md` (작업 타입 8종 분기 + 증상→원인 매핑)
> - **화면 작업 종료 선언 전** → `Doc/_rules_v2/hooks/screen-completion-gate.md` (8 게이트 의무 + 보고 양식)

> ⚠️ **anti-simplification.md** 는 다른 모든 룰을 압도하는 최우선 룰입니다.
> 속도/편의를 위한 작업 단순화는 절대 금지. 사용자가 "모두/전체/정밀/상세" 요청하면 다중 패턴 + Cross-check 의무.
> 위반 = 신뢰성 손상 → 도구 사용 중단.

### Step 1.5: 작성 중/직후 Hook (모든 작업 공통) ⭐ 2026-06-15 갱신
```
파일 작성 직전        : Read: Doc/_rules_v2/hooks/pre-write.md
파일 작성 직후        : Read: Doc/_rules_v2/hooks/post-write.md
작업 종료 직전        : Read: Doc/_rules_v2/hooks/pre-submit.md
화면 작업 종료 직전(+) : Read: Doc/_rules_v2/hooks/screen-completion-gate.md ⭐ 8 게이트
```

⭐ **신규 화면 / 화면 수정 (T01/T04/T07) 시 절대 누락 금지 hook 3종** — 사용자 명시 요구 (2026-06-12 / 2026-06-15 재강조):

```
1순위 master : Read: Doc/_rules_v2/hooks/ui-dynamic-property-management.md
               ↳ 3 구성요소 (Menu Button / Column / Measure) admin UI 기반 동적 fetch + 즉시 반영
2순위 Button : Read: Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md            (child)
3순위 Col+Msr: Read: Doc/_rules_v2/hooks/ui-category-setup-column-meta.md         (child)
```

> 위 3종 누락 = admin 운영 결정이 화면에 무효화 → **신뢰성 손상**. PRE-WRITE 체크리스트 (master §6) + POST-WRITE grep (master §7) + Screen Completion Gate G2/G3 의 의무 점검 대상.

> **그 외 트리거별 hook 분기는 `00_INDEX.md §A` 20-트리거 매트릭스 참조** (Popup / SQL / SP 변환 / 사내 DB 적용 / Figma / 메뉴 미표시 등).

> 룰 v1 (`Doc/_dev_rules/`) 24 룰은 `_archive/` 이동 완료. 유지되는 7 룰: 02 (브랜치/커밋) / 21 (트러블슈팅) / 22 (이관패키지) / 28 (Git multi-remote) / 29 (CSV 적재) / 30 (백업/원복) / 31 (Figma) — 룰 v2 와 cross-ref.

### Step 2: 영역별 추가 룰 — 카탈로그는 00_INDEX 가 단일 진실 source

> 작업 키워드 → 자동 분기는 `Doc/_rules_v2/00_INDEX.md §A 트리거 매트릭스 (20행)` 가 담당.
> 카탈로그 (TO-BE 13 룰 / AS-IS Framework 7 / Hook 50종) 인벤토리는 `00_INDEX.md §B.3` 가 단일 진실 source.
> 따라서 본 §2 에서는 위치/카운트를 중복 유지하지 않음 (카운트 불일치 사고 방지).

**룰 v2 빠른 위치 (디렉터리만)**:
- TO-BE 13 정밀 룰: `Doc/_rules_v2/_tobe/01_file_structure ~ 13_routing_menu.md`
- AS-IS Framework 7 분석: `Doc/_rules_v2/_asis/00_framework/01~07_*.md`
- 50 Hook: `Doc/_rules_v2/hooks/` (통합 진입 3 = oracle-db-workflow / screen-completion-gate / ui-dynamic-property-management + 공통 3 = pre-write / post-write / pre-submit + 트리거 매트릭스 분기 44)
- AS-IS↔TO-BE 격차: `Doc/_rules_v2/_mapping/asis_to_tobe.md` (10 격차)

**유지되는 룰 v1 (`Doc/_dev_rules/`)** — 룰 v2 와 cross-ref:

| 룰 | 내용 |
|---|---|
| 02 | 브랜치/커밋/PR/리뷰 |
| 21 | 트러블슈팅 (Oracle/DBeaver/Wijmo/PowerShell) |
| 22 | 이관 패키지 (`_artifacts`) |
| 28 | Git Multi-Remote (NSCM 모노레포 + GitHub + GitLab) |
| 29 | 로컬 Docker Oracle CSV 적재 |
| 30 | 로컬 환경 백업/원복 |
| 31 | Figma → React |
| 32 | Claude(Code) Oracle 직결 (SQLcl MCP / python-oracledb / docker sqlplus) |
| `Doc/_analysis/db_migration/01` | DB MSSQL→Oracle 변환 룰 (부록 C 실전 함정 9종) |
| `Doc/_analysis/db_migration/02` | SP 변환·검증 6-Stage 파이프라인 |

> 룰 v1 나머지 24 룰 (00 / 01 / 03~20 / 23~27) 은 `Doc/_dev_rules/_archive/` 이동 완료. 직접 참조 금지.
> 구 `Doc/_dev_rules/hooks/` 도 레거시 (유니크 6종 v2 이관 완료, 상세: 해당 폴더 README.md).

### Step 3: 기존 유사 코드 참조
신규 파일 작성 전 기존 패턴을 반드시 확인:
- **FE 화면**: `C:\Projects\NSCM\nscm-fe\features\admin\src\pages\user-management\` (표준 패턴)
- **BE 도메인**: `C:\Projects\NSCM\nscm-be\src\main\java\com\lgcns\nscm\admin\menu\` (표준 패턴)

### Step 3.5: ⭐ 신규 화면 features 폴더 결정 의무 (2026-06-04 추가 — SCM0008 사고 후)

> 메모리 `feedback_new_screen_features_location.md` + 룰 v2 `_tobe/01_file_structure.md` §1.3/§1.4 적용 의무.

신규 화면 작성 시 다음 5 단계 의무 수행:

1. **SCM_ADM_MNU_M 트리 walk-up** — UPPR_MNU_ID 의 최상위 부모 (Lv 0) 식별
2. **최상위 → features 매핑** — Master/Demand/Report → 동명 폴더 / Admin → features/admin / **Authority → features/authority** (UPPR_MNU_ID=Auth_Mgmt 도 features/authority)
3. **Router.tsx import 검색** — `@authority/auth-request` 같은 import 있으면 **기존 작성 = cross-check 만**
4. **features/{layer}/src/pages/ 인벤토리** grep — 자매 화면 표준 패턴 학습
5. **결과 보고** — 신규 작성 / cross-check 결정 명시

⚠️ 누락 시 SCM0008 사고처럼 admin 으로 잘못 매핑 → 9 파일 중복 작성 위험.

### Step 4: 화면별 분석 자료 참조 (해당 화면 작업 시) — ⭐ FE 신규 화면은 필수
- DM: `Doc/_analysis/domain_DM/screens/{화면ID}/` 모든 8개 MD (특히 **validation.md** + **expressions.md** 필독)
- 공통: `Doc/_analysis/domain_Common/screens/{화면ID}/` 동일
- SCM: `Doc/_analysis/domain_SCM/screens/{화면ID}/` 동일
- Excel: `_analysis/_screens/{27|28|29}_*_Screens/*_{화면ID}.xlsx` 의 `11_Validation` + `12_Expression` 시트 *(2026-05-20 폴더 이동)*
- ⭐ **카운트 일치 의무**: 위 두 자료의 행 수가 To-Be 코드 적용 건수와 정확히 일치해야 함 (누락 0건). PR 머지 조건.
- ⭐ **xlsx 1~10 시트 신뢰 금지** (2026-05-18 추가): 27_DM_Screens 중 14개 파일에서 1~10 시트(`1_화면개요`~`10_ToBe권장`)가 다른 화면 데이터로 잘못 채워진 사고가 있었음. `00_정정안내_READ_ME` 시트가 있거나 `1_화면개요`의 화면 ID가 파일명과 다르면 **MD 폴더를 1차 신뢰**할 것. 상세: `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md §1 원칙 4`.

## 3. 핵심 원칙 (3개)

### 원칙 1: "한 사람이 개발한 것처럼"
- 신규 코드는 기존 패턴과 완전히 동일한 스타일이어야 함
- 폴더 구조, import 순서, 명명 규약, 주석 헤더 모두 일치
- 기존 화면(user-management, menu)이 표준

### 원칙 2: Layer 의존 방향 절대 준수
- FE: Foundation ← Shared ← Application (역방향 금지)
- BE: Controller → Service(interface) → ServiceImpl → BaseService → MyBatis

### 원칙 3: Syntax Error 0
- DB 변환물은 Oracle 19c에서 컴파일 가능해야 함
- 자동변환 위험 시 보존 + 가이드 추가 (`Doc/_analysis/db_migration/`)
- FE/BE는 lint + type-check + build 통과 필수

## 4. 절대 금지 (Top 11)

1. ❌ 상대 경로 import (`../../../`) — alias (`@shared`, `@foundation`) 사용
2. ❌ Feature 간 직접 import (admin → demand 등) — apps/web에서 조합
3. ❌ `console.log` / `System.out.println` — Logger 사용
4. ❌ `any` 타입 — 정확한 타입
5. ❌ inline style — SCSS Module
6. ❌ Controller에서 SQL 직접 호출 — Service 경유
7. ❌ `@Autowired` 필드 주입 — `@RequiredArgsConstructor` + final
8. ❌ Hardcoded SQL ID — `nameSpace + "method"`
9. ❌ ResponseEntity 직접 — `successResponseEntity(data)`
10. ❌ MSSQL 키워드 (DATEADD/CHARINDEX/STRING_SPLIT/GETDATE/ISNULL/IIF/N'/WITH (NOLOCK))
11. ❌ ⭐ As-Is `validation.md` / `expressions.md` 누락 (1건이라도) — 100% 매핑 필수, `__asis-mapping__.md` 미작성

## 5. 명명 규약 (요약)

### Frontend
- 컴포넌트 파일: `PascalCase.tsx`
- 폴더: `kebab-case/`
- 훅/스토어/유틸: `camelCase.ts`
- 타입/상수: `kebab-case.{types,constants}.ts`
- Workspace alias: `@foundation`, `@shared`, `@admin`, `@demand`, ...

### Backend
- 패키지: `com.lgcns.nscm.{domain}.{feature}`
- 클래스: `{Feature}Controller`, `{Feature}Service`, `{Feature}ServiceImpl`
- DTO: `{Feature}Request/Response.java` (in `dto/`)
- MyBatis: `sql/{domain}/{Feature}.xml`, namespace `com.lgcns.nscm.{domain}.{feature}`
- DB SP: `PKG_{UI_ID}.P_{기능명}`

## 6. 표준 응답 / 표준 호출

### Backend → Frontend 응답
```
{ "code": "0", "message": "success", "result": {...} }
```
→ Controller는 `successResponseEntity(data)` 사용. 직접 ResponseEntity 작성 금지.

### Frontend API 호출
```ts
const { data } = useTabProcQuery<MENU_ID>({ menuId, sheetName, tabId, filters, enabled });
const { mutate } = useProcMutation<MENU_ID>({ menuId, sheetName, tabId });
```
→ 직접 `fetch`/`axios` 호출 금지.

### Backend DB 호출
```java
private final String nameSpace = "demand.dmf0099.";
Map<String, Object> result = selectList(nameSpace + "retrieveMain", params);
List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);
return Dmf0099Response.listOf(data);
```

## 7. 자기 점검 (코드 작성 직후)

```
✅ 명명 규약 OK?
✅ Layer 위반 없음?
✅ 기존 패턴 참조했나?
✅ 표준 응답/호출 방식 사용?
✅ Slf4j / SCSS Module 사용?
✅ 주석 헤더 포함? (BE 클래스)
✅ MSSQL 잔존 키워드 0건?
✅ ⭐ As-Is validation.md + expressions.md 누락 0건? __asis-mapping__.md 작성?
```

## 8. 도구 빠른 참조

| 작업 | FE | BE |
|---|---|---|
| 로컬 실행 | `pnpm local` | `./gradlew bootRun` |
| 빌드 | `pnpm build` | `./gradlew build` |
| Lint | `pnpm lint:fix` | `./gradlew spotlessApply` |
| Type | `pnpm type-check` | (컴파일 시) |
| Test | `pnpm test` | `./gradlew test` |

## 9. 관련 문서

> 2026-06-09 정리: archive 된 룰 v1 (00/01/03~20/23~27) + `_dev_rules/hooks/` 의 룰 v2 흡수분 표에서 제거. 룰 v2 카탈로그 + 7 유지 룰 + 분석 자료 + archive 만 유지.

### 룰 v2 (진입점 + 카탈로그)

| 경로 | 내용 |
|---|---|
| `Doc/_rules_v2/anti-simplification.md` | ⚠️ ⭐ 최우선 — 단순화 절대 금지 (불변) |
| `Doc/_rules_v2/CLAUDE.md` | 분기 라우터 |
| `Doc/_rules_v2/00_INDEX.md` | 트리거 매트릭스 17행 + 룰/Hook 카탈로그 |
| `Doc/_rules_v2/_tobe/` | TO-BE 13 정밀 룰 (01~13) |
| `Doc/_rules_v2/_asis/00_framework/` | AS-IS Framework 7 정밀 분석 |
| `Doc/_rules_v2/hooks/` | 48 Hook (통합 진입 3: oracle-db-workflow / screen-completion-gate / ⭐ ui-dynamic-property-management + pre/post-write + ... — §B.3 카탈로그 참조) |
| `Doc/_rules_v2/_mapping/asis_to_tobe.md` | AS-IS↔TO-BE + 10 격차 사양 |
| `Doc/_rules_v2/meta-rule-evolution.md` | PoC → 룰 보강 사이클 (4 분류) |

### 유지되는 룰 v1 (`Doc/_dev_rules/`)

| 경로 | 내용 |
|---|---|
| `Doc/_dev_rules/02_DEVELOPMENT_RULES.md` | 브랜치/커밋/PR/리뷰 |
| `Doc/_dev_rules/21_TROUBLESHOOTING.md` | ⭐ 트러블슈팅 (Oracle/DBeaver/Wijmo/PowerShell) |
| `Doc/_dev_rules/22_PACKAGE_ARTIFACTS.md` | ⭐ 이관 패키지 (`_artifacts`) |
| `Doc/_dev_rules/28_GIT_MULTI_REMOTE.md` | ⭐ Git Multi-Remote (NSCM + GitHub + GitLab) |
| `Doc/_dev_rules/29_LOCAL_DB_CSV_IMPORT.md` | ⭐ Docker Oracle CSV 적재 |
| `Doc/_dev_rules/30_LOCAL_BACKUP_RESTORE.md` | ⭐ 로컬 환경 통합 백업/원복 |
| `Doc/_dev_rules/31_FIGMA_DESIGN_INTEGRATION.md` | ⭐ Figma → React 매핑 |
| `Doc/_dev_rules/32_CLAUDE_ORACLE_DIRECT.md` | ⭐ Claude(Code) Oracle 직결 (SQLcl MCP / ora.py / docker sqlplus) — 2026-06-11 신설 |

> archive 된 룰 v1 (00/01/03~20/23~27) 은 `Doc/_dev_rules/_archive/` 이동 완료 — 직접 참조 금지. 룰 v2 안에 흡수.

### 분석 자료

| 경로 | 내용 |
|---|---|
| `Doc/_analysis/INDEX.md` | 도메인 분석 자료 진입점 |
| `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` | DB 변환 규칙 (⭐ 부록 C 실전 함정 9종) |
| `Doc/_analysis/db_migration/02_SP_CONVERSION_PIPELINE.md` | ⭐ SP 변환·검증 6-Stage 파이프라인 (2026-06-11) |
| `_analysis/_FOLDER_MAP.md` | ⭐ Cowork 분석 산출물 폴더 매핑표 |
| `_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx` | ⭐ 통합 매트릭스 (3,318행 / 395 화면 / 710 SP / 355 Tables) |

### Archive

| 경로 | 내용 |
|---|---|
| `Doc/_archive/CLAUDE_changelog_phase0-4.md` | ⭐ CLAUDE.md §15 변경 이력 archive (2026-05-13 ~ 2026-05-30) |
| `Doc/_dev_rules/_archive/` | 룰 v1 25개 archive (00/01/03~20/23~27) |

## 10. 참고 — 실제 코드 위치

- FE: `C:\Projects\NSCM\nscm-fe\`
- BE: `C:\Projects\NSCM\nscm-be\`
- 분석 산출물: `C:\Projects\NSCM\_phase{1~4}\`, `C:\Projects\NSCM\_analysis/_screens\` *(2026-05-20 root 정리)*

## 11. ⭐ Cowork 분석 산출물 폴더 매핑 (2026-05-20 정리)

Root 폴더에 흩어져 있던 Cowork 분석 산출물(00_~29_)을 Phase별 폴더로 분류했습니다.
**상세 매핑표는 [`_analysis/_FOLDER_MAP.md`](./_FOLDER_MAP.md) 를 참조하세요.**

| 폴더 | 내용 | 파일 수 |
|---|---|---:|
| `_analysis/_phase1/` | Phase 1 개요·인벤토리·아키텍처 (00_INDEX 포함) | 6 |
| `_analysis/_phase2/` | Phase 2 DB/화면/Endpoint 정밀 인벤토리 + 게이트 보고서 | 17 |
| `_analysis/_phase3/` | Phase 3 도메인별 상세 분석 (Common/SCM/DM/SCP/SSP/FP) + Master | 21 |
| `_analysis/_phase4/` | Phase 4 To-Be 상세 스펙 (Screen/Field/Event/IA/BPF/Arch) | 40 |
| `_analysis/_screens/` | 화면 단위 분석서 (27_DM/28_Common/29_SCM/**30_SCP/31_SSP/32_FP** Screens) | **6 도메인** |
| **`_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx`** | **⭐ 통합 매트릭스 (2026-05-21 v7.4) — 화면×POPUP×SP×Tables (JSON) 1,577행 / 395 화면 / 710 SP / 355 Tables** | 1 |

**AI 작업 시 빠른 참조:**
- As-Is 시스템 전체 개요 → `_analysis/_phase1/00_INDEX.md` + `_analysis/_phase1/01_Overview.md`
- DB 정밀/Oracle 호환성 → `_analysis/_phase2/02_DB_Inventory.xlsx` + `_analysis/_phase2/02_Oracle_Compat.xlsx`
- 도메인별 분석 → `_analysis/_phase3/{04~09}_*_Analysis.{md|docx|xlsx}`
- 신규 화면 메타·필드·이벤트 → `_analysis/_phase4/{11~13}_*.xlsx`
- 화면 13시트 분석서 → `_analysis/_screens/{27_DM|28_Common|29_SCM|30_SCP|31_SSP|32_FP}_Screens/{prefix}{화면ID}.xlsx` ⭐ **2026-05-21 v7.4 — 302 화면 정밀**
- **⭐ 화면×SP×Tables 통합 매트릭스** → `_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx` (3 시트: 매트릭스 3,318행 / 인벤토리 395 / 통계 (Anti-Simplification 11개 원천))

## 12. ⭐ v7.4 룰 (2026-05-21) — 화면 분석서 정밀 작업 의무

**"메타 자동 생성도 일괄 자동화" 명문화** (룰 19 §16):

| # | 의무 | 위반 시 |
|---:|---|---|
| 1 | 화면별 `.cs` 전체 Read (처음~끝, 수백~수천 라인) | xlsx 빈칸 다수 = 즉시 재작업 |
| 2 | 화면별 `.Designer.cs` 전체 Read | 동일 |
| 3 | xlsx 13시트 모두 filled cells 30+ | 즉시 재작업 |
| 4 | Validation: 모든 `MessageHelper.GMessageBox` 추출 (Msg ID + 카테고리) | 누락 위반 |
| 5 | Expression: 모든 `LockColumn/LockRange` + `SetValue` Auto-Sync 추출 | 누락 위반 |
| 6 | 호출 POPUP: 모든 `new XxxPopup()` 추출 + 공통 영역 Link 또는 신규 분석서 | 누락 위반 |
| 7 | SP
## 13. ⭐ 화면 분석서 통합 통계 (2026-05-22 기준)

| 도메인 | xlsx (13시트) | analysis.md | 8 MD 완비 |
|---|---:|---:|---:|
| DM | 84 | 83 | 49 (34 화면 보강 필요) |
| SCP | 66 | 70 | 66 |
| SSP | 56 | 58 | 56 |
| FP | 95 | 112 | 95 |
| Common | 32 | 57 | (별도) |
| SCM | 16 | 16 | (별도) |
| **합계** | **349** | **396** | |

**통합 산출물**: `_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx` (3,318행 / 395 화면 / 710 SP / 355 Tables, Anti-Simplification 11개 원천)

## 14. ⭐ Anti-Simplification 룰 — 최우선

> 사용자 요구 (2026-05-22): "단순화 해서 잘못된 결과나 산출물을 도출하면 그건 신뢰성만 손상시키고, 클로드를 사용하지 않게 되는 결과를 이어질거에요."

**상세**: `Doc/_rules_v2/anti-simplification.md` *(2026-06-11 경로 정정 — 구 `_dev_rules/hooks/` 버전은 DEPRECATED)*

핵심: (1) "모두/전체/정밀/상세" 요청 시 다중 패턴 + Cross-check 의무 (2) 자동화 1회 통과 채택 금지 (3) 기존 분석 자료 활용 (4) 추출 한계 명시 (5) 시간/토큰 절약 단독 결정 금지.

## 15. ⭐ 변경 이력 (요약 — 풀 원문은 archive 참조)

> **archive**:
> - 2026-05-13 ~ 2026-05-30: `Doc/_archive/CLAUDE_changelog_phase0-4.md`
> - 2026-06-03 ~ 2026-06-12: `Doc/_archive/CLAUDE_changelog_2026-06.md` ⭐ 2026-06-15 이동
>
> 신규 항목은 본 §15 에 1-line entry 로 추가하고, 12개를 초과하면 다음 archive (`CLAUDE_changelog_2026-07.md` 등) 로 이동.

| 일자 | 키워드 (archive 참조 = 풀 원문) |
|---|---|
| 2026-06-17 (저녁) | ⭐ Wijmo FlexGrid 가이드 2 파일 룰셋 통합 (자가 진화 #15, hook 56→57): 사용자 작성 `Doc/wijmo-flexgrid-guide.md` (17.7KB, 정신 모델 + 안티패턴 10 row + §11 CLAUDE.md 규칙 블록) + `Doc/wijmo-flexgrid-api-reference.md` (22.8KB, FlexGrid/Column/CollectionView 속성/메서드/이벤트 정확 시그니처 grep용) 두 파일을 NSCM 룰셋 자동 참조 시스템 통합. 신규 진입 hook `wijmo-flexgrid-entry.md` 작성 (T04 트리거 + 사전 의무 Read + 자기 점검 5 항목 + 기존 wijmo hooks 5 종 cross-ref). 00_INDEX.md T04 row + B.3 카탈로그 #57 등록. 메모리 entry 추가 |
| 2026-06-17 | ⭐ DMF0043 dynamic 컬럼 클라우드 사고 → 3 hook 신설 (자가 진화 #14, hook 53→56): (1) **`pivot-dynamic-column-nvl.md`** — PIVOT 결과 NULL → MyBatis `callSettersOnNulls=false` 환경에서 setter skip → JSON 키 누락. DMF0020 (NVL 적용) 클라우드 정상 ↔ DMF0043 (NVL 누락) 사고 비교로 root cause 확정. 동적 SELECT `NVL(CAST(...AS NUMBER), 0)` + PIVOT 입력 `MAX(NVL(value, 0))` 의무. 2 줄 fix 로 첫 row NULL 0 검증 완료 (2) **`column-meta-rework-checklist.md`** — DMF0008/0020/0043/0043_01 4 화면 column 재작업 진입 룰 (인벤토리 4 + 점검 8). 사용자 명시 다음 작업 진입 의무 (3) **`sp-patch-file-deploy.md`** — `END;/` 한 줄 사고 + 객체 의존 순서 PLS-00905 사고 fallback `ALTER PROCEDURE COMPILE`. SQL client 별 적용 가이드. 메모리 3 신규 (BE 변경 절대 금지 / shared/* 전역 prop 변경 금지 / META cross-check DDL 의무). DataGrid.tsx 의 `autoGenerateColumns={false}` 전역 영향 사고 fix (모든 화면 grid 컬럼 0 → 복구) |
| 2026-06-16 (밤) | ⭐ SearchArea 2단 초과 시 extraConditions 분리 룰 신설 (자가 진화 #13, hook 52→53): `Doc/_rules_v2/hooks/search-area-extra-conditions.md` 신설 — 12 col Grid 기준 6 필드 초과 시 SearchArea `extraConditions` prop 으로 3단 이후 분리 + 자동 ▼ 확장 토글. DMF0003 (5단 → 2단+3단 분리) + DMF0020 (5단 → 2단+3단 분리) 적용. Sample DMF0006. 2026-06-16 사용자 명시 |
| 2026-06-16 (저녁) | ⭐ DMF0003 admin column/measure 3-filter + 사용자 measure 권한 UPSERT 풀스택 (자가 진화 #12, hook 51→52): (1) **BE 인프라 재사용 의무 룰 신설** (`Doc/_rules_v2/hooks/be-infrastructure-reuse.md`) — 사용자 명시 "BE 는 틀 제공 + 신규 생성 회피". 신규 Controller/Service 작성 전 §2 인벤토리 검색 의무 + 표준 path (SP + 메타 INSERT 만으로 완성) (2) MenuServiceImpl `retrieveGridColumns/Measures` 3-filter 추가 (mnuId≠SYS0004 시 `visible=Y + ATTRIBUTE1 ⊃ divisionId` 강제 — admin 단일 진실 source) (3) DMF0003 measure 권한 SAVE — 기존 SP `PKG_SCM0002.P_SCM0002_SET_TITLESET_POPUP` 재사용 + 신규 메타 INSERT (`031_dmf0003_titleset_save_meta.sql`) + FE `apiClient.callMutationProc` 표준 path (4) MktForecastMasterGrid `mergedColumns` division 분기 추가 (`*40` vs base 5쌍 중복 fix) |
| 2026-06-16 | ⭐ DMF0003 메인 grid 22,095초 사고 → MSSQL→Oracle 변환 6 성능 룰 신설 (자가 진화 #11, hook 50→51): (1) column 안 REGEXP_SUBSTR/CONNECT BY → FROM 분리 (2) 분리자 split → GT 적재 (3) MASTER lookup → LEFT JOIN (4) GT MAIN KEY INDEX 의무 (5) WHERE 함수 → SARGable (6) 'ALL'/''/NULL 시 GT INSERT skip + SELECT OR short-circuit. `Doc/_rules_v2/hooks/oracle-sp-perf-anti-patterns.md` 신설 + `Doc/_analysis/db_migration/01_*` §7 추가 + 00_INDEX T19 등록 |
| 2026-06-15 오후 | SYS0013 클라우드 적용 5건 사고 → 룰 보강 (자가 진화 #10, hook 2 보강 + 메모리 4 신규 + 1 보강): UNIT_TP_CD='D' INSERT+UPDATE 동반 / DIVISION_ID DUMP byte 검증 / barrel export PATCH 안내문 / SP 참조 테이블 USER_OBJECTS grep / FE filter key cross-sheet 일관성 |
| 2026-06-15 | DMF0007 Customer PSI 시트 제거 (FE + i18n + DB 메타 SQL 4세트) + 사내 Oracle IP 변경 10.20.100.153 → 121.162.245.167 (5 파일 + 메모리 갱신) + CLAUDE.md 비대화 정리 (§15 archive 분리 + §2 압축, 62KB → ~20KB) |
| 2026-06-12 오후 | SYS0012/0014/0010 풀스택 + 컬럼 lookup 누락 방지 강조 (자가 진화 #9, hook 48→50) |
| 2026-06-12 | UI 동적 속성관리 master + 다국어 영문화 + 클라우드 정합 5건 룰화 (자가 진화 #8, hook 41→48) |
| 2026-06-11 | 룰셋 정합성 대정비 + Oracle 파이프라인 + UI 완성도 게이트 (hook 41 + 트리거 20행, T19/T20 신설) |
| 2026-06-11 오후 | UI Category Setup column 메타 동적 fetch hook + DMF0043_01 SP fix + 성능 튜닝 v1/v2 (자가 진화 #7) |
| 2026-06-11 오후 | DMF0043 GET SP PRODUCT_GROUP '' → 'N' fix (자가 진화 #6) |
| 2026-06-11 | DMF0043 silent SAVE fail 3축 fix (자가 진화 #5, SUBSTR-0 / mutate array / TRUNCATE GT) |
| 2026-06-10 | 사내 Oracle 직결 전환 + 11 화면 일괄 적용 + lint 사고 2건 룰 변환 (자가 진화 #4, hook 5종 + 메모리 5종) |
| 2026-06-09 | 4 신규 admin 화면 풀스택 (MESSAGE/CODE/Group User/Program) + MNU_DESC 룰 (자가 진화 #3) |
| 2026-06-09 | SCM0005 DynamicQuery 풀스택 + SHEET_COLUMNS 전역 dedupe (자가 진화 #2, 사고 6 건 룰 변환) |
| 2026-06-09 | SCM0008/0009 풀스택 fix (사고 6 건 룰 변환, hook 11→14 + 메모리 7건) |
| 2026-06-07 | DMF0003 MKT FCST Insert dropdown 사고 5건 → 룰셋 자가 진화 (12단계 wijmo dropdown + CMBO @divisionId 등) |
| 2026-06-06 | SCM0008 fix + 공통 버튼 기본 표시 정책 + SearchArea 부재 Search 버튼 룰화 |
| 2026-06-03 | DMF0020 메인 SP 1:1 변환 + popup 3종 AS-IS 매핑 + Wijmo 머지 sticky + 공용 ColumnSettingModal (사고 8건 룰화) |
| 2026-06-02 | Deploy Package 완전성 룰 정비 (DMF0072/0008/0043/0043_01 lookup/POPUP/SP 누락 4건 + hook 신설) |
| 2026-06-02 | 공통 버튼 10대 룰 정비 (CRUD 6 + Search Aux 4 매핑 + Sort/Filter 자동 활성) |
| 2026-06-02 | Grid Column 메타 표준화 + 4 화면 풀스택 적용 (CELL_CONTROL_TYPE 14 + CELL_INPUT_EDIT_TYPE 5) |
| 2026-06-02 | DMF0072 NN Master Mapping 풀스택 + 4축 룰 보강 (사고 5건 룰화) |
| 2026-06-01 | Plan — 룰 진입점 정비 + To-Be SP 결함 fix + As-Is DB cross-check 자동화 (DMF0043 3축 해소) |

