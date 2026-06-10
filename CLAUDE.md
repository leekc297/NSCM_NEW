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

### Step 1: 룰셋 로드 (룰셋 v2 — 3 진입점만, 모든 작업) ⭐ 2026-06-03 갱신
```
Read: Doc/_rules_v2/anti-simplification.md  ⚠️ ⭐ 최우선 — 단순화 절대 금지 (불변)
Read: Doc/_rules_v2/CLAUDE.md               ← 분기 라우터 (작업 트리거 → 진입 룰)
Read: Doc/_rules_v2/00_INDEX.md §A 트리거 매트릭스 ← 17 트리거 × 룰/Hook 자동 분기
```

> ⭐ **3 진입점 정책 (룰셋 v2, 2026-06-03)**:
> 위 3 파일만 1차 로드. **모든 도메인별 룰/hook 은 `00_INDEX.md` 의 17-트리거 매트릭스가 작업 키워드에 따라 자동 분기.**
> 룰셋 v2 구조: `_asis/00_framework` (7 정밀) + `_asis/01_popups` (인벤토리) + `_tobe/01~13` (13 룰) + `_mapping/asis_to_tobe.md` (10 격차) + `hooks/` (10 hook).

> ⚠️ **anti-simplification.md** 는 다른 모든 룰을 압도하는 최우선 룰입니다.
> 속도/편의를 위한 작업 단순화는 절대 금지. 사용자가 "모두/전체/정밀/상세" 요청하면 다중 패턴 + Cross-check 의무.
> 위반 = 신뢰성 손상 → 도구 사용 중단.

### Step 1.5: 작성 중/직후 Hook (모든 작업 공통) ⭐ 2026-06-03 갱신
```
파일 작성 직전: Read: Doc/_rules_v2/hooks/pre-write.md
파일 작성 직후: Read: Doc/_rules_v2/hooks/post-write.md
작업 종료 직전: Read: Doc/_rules_v2/hooks/pre-submit.md
```

> **트리거별 hook 추가 적용은 `00_INDEX.md §A` 17-트리거 매트릭스 참조** (신규 화면 / Popup / Grid / Button / 메뉴 미표시 / BE / SQL / Figma 등).

> 룰 v1 (`Doc/_dev_rules/`) 24 룰은 `_archive/` 이동 완료. 유지되는 7 룰: 02 (브랜치/커밋) / 21 (트러블슈팅) / 22 (이관패키지) / 28 (Git multi-remote) / 29 (CSV 적재) / 30 (백업/원복) / 31 (Figma) — 룰 v2 와 cross-ref.

### Step 2: 영역별 추가 룰 ⭐ 2026-06-03 룰 v2 갱신

> 룰 v2 의 `00_INDEX.md §A` 17-트리거 매트릭스가 작업 키워드로 자동 분기. 아래는 빠른 참조:

#### TO-BE 룰 (`Doc/_rules_v2/_tobe/`) — 13 정밀
- **FE 폴더/명명**: `_tobe/01_file_structure.md`
- **FE Import alias**: `_tobe/02_imports.md` (정확 export 인벤토리 + 사고 패턴)
- **FE 메인 컴포넌트**: `_tobe/03_main_component.md` (7 단계 구조 + Multi-sheet/Tab/Panel/Dynamic 변형)
- **FE Store (Zustand)**: `_tobe/04_store.md` (createPersistedStoreWithTab + G1 GET 의무)
- **FE Constants**: `_tobe/05_constants.md` (MENU_ID/SHEETS/RESPONSE_SET + LBL 5자리)
- **FE 조회조건 SearchArea**: `_tobe/06_search_area.md` (FormItem + useTabComboQueries + searchFields 카탈로그 + G2 통합)
- **FE Grid DataGrid**: `_tobe/07_datagrid.md` (FlexGrid 직접 사용 금지 + EditTracker + 8 금지 사고 사례)
- **FE Column meta**: `_tobe/08_column_meta.md` (`_inputEditType`/`_ctrlType`/`_modalKey` + dynamic util)
- **FE SubTitle/hotkeyConfig**: `_tobe/09_subtitle_hotkey.md` (10 키 매핑 CRUD 6 + Aux 4)
- **FE Popup/Modal**: `_tobe/10_popup_modal.md` (공용 11종 + CustomDialog + 신규 작성)
- **BE Spring Boot**: `_tobe/11_be_controller_service.md` (Controller/Service/Mapper + 보안 의무 + 5 격차 endpoint)
- **메타 SQL**: `_tobe/12_metadata_sql.md` (7-BLOCK + 멱등 INSERT + MSSQL→Oracle + lookup combo)
- **Routing/Menu**: `_tobe/13_routing_menu.md` (MNU_URL slug + 7단계 디버깅)

#### AS-IS Framework (`Doc/_rules_v2/_asis/00_framework/`) — 7 정밀 분석
- BaseForm (6,329 lines, 157 method) / DataService (5,261 lines, 87 method) / MessageHelper (100% — Type 4 + Button 7 + 23 MSG ID) / Logging / Auth_FormAuth / UsrControls (36 컨트롤) / FoxDataClient (WCF→REST)

#### Hook (`Doc/_rules_v2/hooks/`) — 10
- pre-write / post-write / pre-submit / screen-create-checklist / asis-coverage-check / grid-column-meta / popup-asis-analysis / asis-button-mapping / runtime-error-prevention / menu-not-displayed-debug

#### AS-IS↔TO-BE 격차 매핑 + 사양
- `Doc/_rules_v2/_mapping/asis_to_tobe.md` (10 격차 = 신규 구현 8 + 격차 유지 2)

#### 유지되는 룰 v1 (`Doc/_dev_rules/`)
- **트러블슈팅 (Oracle/DBeaver/Wijmo/PowerShell)**: `Doc/_dev_rules/21_TROUBLESHOOTING.md`
- **이관 패키지 (`_artifacts`)**: `Doc/_dev_rules/22_PACKAGE_ARTIFACTS.md`
- **Git Multi-Remote (NSCM 모노레포 + GitHub + GitLab)**: `Doc/_dev_rules/28_GIT_MULTI_REMOTE.md`
- **로컬 Docker Oracle CSV 적재**: `Doc/_dev_rules/29_LOCAL_DB_CSV_IMPORT.md`
- **로컬 환경 백업/원복**: `Doc/_dev_rules/30_LOCAL_BACKUP_RESTORE.md`
- **Figma → React**: `Doc/_dev_rules/31_FIGMA_DESIGN_INTEGRATION.md`
- **브랜치/커밋/PR/리뷰**: `Doc/_dev_rules/02_DEVELOPMENT_RULES.md`
- **DB MSSQL→Oracle 변환 룰**: `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md`

> ⚠️ 룰 v1 의 나머지 24 룰 (00 / 01 / 03~20 / 23~27) 은 `Doc/_dev_rules/_archive/` 로 이동 완료 (룰 v2 안에 흡수). 직접 참조 금지.

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
| `Doc/_rules_v2/hooks/` | 20 Hook (pre/post-write + screen-create + asis-coverage + components-folder-pattern + ...) |
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

> archive 된 룰 v1 (00/01/03~20/23~27) 은 `Doc/_dev_rules/_archive/` 이동 완료 — 직접 참조 금지. 룰 v2 안에 흡수.

### 분석 자료

| 경로 | 내용 |
|---|---|
| `Doc/_analysis/INDEX.md` | 도메인 분석 자료 진입점 |
| `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` | DB 변환 규칙 |
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

**상세**: `Doc/_dev_rules/hooks/anti-simplification.md`

핵심: (1) "모두/전체/정밀/상세" 요청 시 다중 패턴 + Cross-check 의무 (2) 자동화 1회 통과 채택 금지 (3) 기존 분석 자료 활용 (4) 추출 한계 명시 (5) 시간/토큰 절약 단독 결정 금지.

## 15. ⭐ 변경 이력

> 2026-06-01 이전 항목은 `Doc/_archive/CLAUDE_changelog_phase0-4.md` 로 이동 (2026-06-09 슬림화).

- **2026-06-01 (Plan — 룰 진입점 정비 + To-Be SP 결함 fix + As-Is DB cross-check 자동화)**: DMF0043 (마스터 화면 1개) 작업이 며칠 소요된 3축 진짜 원인 (To-Be SP 결함 / 마이그레이션 데이터 결함 / 룰셋 구조 결함) 해소. **Stage 1**: CLAUDE.md Step 1 진입점 8 → 3 (anti-simplification + 01_CLAUDE.md + 00_INDEX §B). **00_INDEX §B 트리거 매트릭스 15행** 신설 + 01_CLAUDE.md 분기 라우터화. **Stage 2**: 5 주제 진실 source 헤더 표시 (POPUP 룰 25 §3.3.1 / DB 오류 룰 21 §12 / PIVOT 룰 27 §B / Figma 룰 31) + 메모리 archive 10건 (`memory/_archive/`). **Stage 3a**: DMF0005 SUBSTR offset 3건 fix (DMF0042/0043 은 이미 fix됨 또는 주석). **Stage 3b**: V_IN_PARA_DATA VARCHAR2(4000) → CLOB 41 건 (11 파일). ⚠️ Oracle 23ai PL/SQL 은 `JSON_OBJECT(... RETURNING CLOB)` 거부 (PLS-00684) — RETURNING CLOB 166건 patch 시도는 rollback. **Stage 3c**: LISTAGG `ON OVERFLOW TRUNCATE WITH COUNT` 15건 (6 파일). ⚠️ ON OVERFLOW 는 LISTAGG 인자 안 위치 (WITHIN GROUP 뒤가 아님). **Stage 3d/3e**: GTT DELETE 누락 38 proc / 203 GT_* INSERT audit + Cursor OUT vs OPEN mismatch 66 proc / 107 cases audit — bulk fix 위험으로 audit only. **Stage 4**: `_artifacts/_diagnostics/` 신설 (sp_body_diff / row_count_diff / column_inventory 3 sh + 매핑 표 + README). DMF0043 row_count_diff 실행 결과: As-Is 1.5M / To-Be 27K (98% 누락). **Stage 5**: `screen-entry-asis-baseline.md` hook 신규 (4단계 baseline 자동 점검) + 룰 25 §0.5 추가 (신규 화면 진입 의무) + 00_INDEX hook 카탈로그 보강 (06q/06r/06s/06t 4건). **산출물**: `_artifacts/_bulk_fix_v2_converted/` (백업 + 5 스크립트 + 5 RESULT.md) + `_artifacts/_diagnostics/`.
- **2026-06-02 (DMF0072 NN Master Mapping 풀스택 + 4축 룰 보강)**: DMF0072 신규 화면 (격차 A=multi-select / B-1=layout / B-2=Project+Item Popup / C=Team SP body 모두 적용) + DMF0043_01 Version Popup Division 권한 기반 동적 lookup + DMF0072 grid 계층적 cell merge + COM0008 sheet columns duplicate cleanup. **SP/메타 5세트 4-파일**: `_artifacts/52_DMF0072_lookup_sp_fix` (WRAPPER ALL 변환 제거 + sesUserId/mnuId 추가 + END_CUSTOMER/SALES_SITE multi-value split), `53_DMF0072_TEAM_LIST_sp_body` (As-Is SCM0001_GET_TEAM_BY_DIVISION 1:1 변환 stub→27 lines), `54_DMF0072_popup_sp_create` (Project POPUP As-Is SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX 1:1 + Item POPUP As-Is DMF0002_GET_ITEM_BY_DIVISION_POPUPEx 3-UNION 분기 1:1), `55_DMF0072_popup_meta` (메타 5블록 PASS), `56_COM0008_sheet_columns_dedupe` (34→17 row). **사고 → 룰화**: (1) `() => undefined` 빈 버튼 → hook `asis-button-mapping.md` 신규 + 룰 25 §1.5.1 + 메모리 `feedback_asis_button_mapping_mandatory` (2) wrapper SP 'ALL → ''' 변환 anti-pattern → 룰 21 §14 + 메모리 `feedback_wrapper_sp_no_all_transform` (3) Wijmo 기본 column-independent merge → 룰 12 §11.6 HierarchicalMergeManager 패턴 + 메모리 `feedback_wijmo_hierarchical_merge` (4) 공용 modal 재사용 누락 시 신규 작성 충동 → 룰 23 §12.A 인벤토리 + 메모리 `reference_public_modals_master_components` (5) SHEET_COLUMNS duplicate INSERT 2회 → 룰 21 §13 POPUP 데이터 미조회 5단계 진단 + 메모리 `feedback_sql_idempotent_insert_all` 보강. **00_INDEX**: hook 카탈로그 06u 추가 + 트리거 매트릭스 T1 신규화면 hook 보강.
- **2026-06-02 (Grid Column 메타 표준화 + 4 화면 풀스택 적용 — 사용자 명시 요구)**: DMF0004 의 표준 패턴 (편집 가능 cell coloring + 신규 입력 SOLDTO popup) 을 4 신규 화면 (DMF0072/0008/0043/0043_01) 에 적용 + 룰 보강. **룰 12 §11.7 신설** — Grid Column 메타 표준 (14 `CELL_CONTROL_TYPE` enum + 5 `CELL_INPUT_EDIT_TYPE` enum + Column 이름 패턴 → Control Type 매핑 + Coloring 자동 처리 + Popup cell 동작). **룰 25 §1.5.2 신설** — As-Is `.cs` 의 `LockColumn`/`SetCellTypeCombo`/`cellTypeImage` 패턴 → To-Be `_inputEditType`/`_ctrlType`/`_modalKey` 매핑 의무. **hook `grid-column-meta-mandatory.md` 신규** (7절 — asis-button-mapping 패턴 차용 — PRE/POST WRITE grep 검증). **메모리 2건**: `feedback_grid_editable_coloring_mandatory.md` (DataGrid 래퍼 + `_inputEditType` 의무, FlexGrid 직접 사용 금지), `feedback_grid_popup_cell_mandatory.md` (popup cell 표준 — `_ctrlType:'FPModal'` + dblClick + CRUD_TYPE='I' 가드). **00_INDEX**: 06v hook + T1 매트릭스 보강. **4 화면 적용**: DMF0072 (popup 4개 + DataGrid 래퍼) → DMF0043 (EDIT_FLAG → CRUD_TYPE) → DMF0043_01 (조회 전용 DataGrid) → DMF0008 (4 grids + Repair popup 3개).
- **2026-06-02 (공통 버튼 10대 룰 정비 — 사용자 명시 요구)**: As-Is 분석으로 CRUD 3대 (Insert/Delete/Save) 구현 여부 판정 + Sort/Filter/Condition/ResetCondition 4대 구현 후 신규 4 화면 (DMF0072/0008/0043/0043_01) 적용. As-Is `BaseForm.cs:5054~5268` 의 4 default 메서드 (`OnClickSortButton/FilterButton/ConditionButton/ResetConditionButton`) = 모든 화면 공통 → To-Be `SubTitle.DefaultButtonActions` 자동 제공 → `hotkeyConfig` 명시 생략 = 자동 활성 정책. **룰 12 §11.8 신설** — Sort/Filter 자동 활성 3 요소 (`DataGrid allowSorting={true}` + `useRef<FlexGridFilter>` + `<SubTitle gridFilter={ref}>`). **룰 25 §1.5.3 신설** — Search Aux 4대 매핑 의무 (UsrConditionPanel grep 0건 → condition/resetCondition false 의무). **hook `asis-button-mapping.md` 보강** — 제목 + §0 (5+1대 → 10대) + §1.1 CRUD 6대 + §1.2 Search Aux 4대 + §3.5 PRE-WRITE Search Aux 자기 점검 6 row + §4 POST-WRITE grep 3~5 + §6 cross-ref. **메모리 신규** `feedback_search_aux_default_activation.md` (기본 활성 정책 + UsrConditionPanel cross-check + anti-simplification 4 키 일괄 처리 금지). **00_INDEX**: §B T1 보조 룰 컬럼에 `12 §11.8` 추가.
- **2026-06-02 (Deploy Package 완전성 룰 정비 — 사용자 명시 요구)**: DMF0072/0008/0043/0043_01 deploy zip 검수 시 lookup combo / POPUP modal / standalone SP body 누락 4건 발견. **사후 보강**: DMF0072 (lookup 5종 메타 9 row + SP body 4건), DMF0008 (updateHistory 메타 3 row + wrapper SP body 2건 = DMF0008_*+DMF0000_*), DMF0043 (standalone SP body 9건), DMF0043_01 (공용 DMF0002_GET_TITLESET_POPUP body 1건). **룰 22 §9 신설** — SP/메타 완전성 (§9.1 사고 사례 / §9.2 5-종 인벤토리 / §9.3 메타 보강 SQL 4-파일 세트 표준 / §9.4 SP body 추출 절차 (DBMS_METADATA.GET_DDL) / §9.5 wrapper/공용 SP 별도 표시 / §9.6 자기 점검). **hook `deploy-package-completeness.md` 신설** — PRE-DEPLOY 5 인벤토리 + POST-DEPLOY 4 grep + 사후 보강 6 단계. **메모리 신규** `feedback_deploy_package_completeness.md`. **00_INDEX T16 신설** — deploy zip 트리거. 모든 NOT EXISTS 멱등 패턴으로 재실행 안전.
- **2026-06-03 (DMF0020 완전 신규 풀스택 + UPPR_MNU_ID/SHT_NM/Form 표준화)**: DMF0020 (Sales Future Price / 환율·판매단가 관리) 완전 신규 풀스택 작성 (FE 22 파일 + PKG_DMF0020 18 SP DB 적재 + 메타 SQL 7-BLOCK + __asis-mapping__.md 153/153 4축 매핑 + Deploy package). **사고 #1 메뉴 미표시** — `UPPR_MNU_ID='DEMAND_MASTER'` 대문자 vs 실제 부모 `Demand_Master` (자매 화면 7개 표준) 불일치 + `MNU_TP_CD='FN'` vs 표준 `'SCREEN'`. fix SQL `11_DMF0020_fix_uppr_menu_case.sql` 적용. **사고 #2 ORA-01403** — FE `shtNm='main'` vs DB `SHT_NM='futurePrice'` 불일치. fix SQL `12_DMF0020_fix_sheet_name_main.sql` 적용. **사고 #3 조회조건 임의 작성** — 14 input 을 `<label>`+`<input>` 임의 작성 + 직접 useTabProcQuery 호출 → 자매 화면 (DMF0007) 표준 패턴 (SearchArea + FormItem + Grid + useTabComboQueries + CustomDropdown) 위반 + AS-IS 캡쳐 `Doc/ui_cap/DMF0020_init.png` 1:1 재현 X. Form 전면 재작성 (3-row layout: Div/Team/EC/BizType/Period | SalesSite/Project/Model+Nickname | PlantSite/Owner/Bucket/SearchRange/Version). **룰 보강**: hook `menu-not-displayed-debug.md` 5→7단계 (Step 1.5 UPPR_MNU_ID 대소문자 정합 + Step 1.6 SHT_NM 자매 화면 cross-check 신규) + 표준 부모 메뉴 ID 인벤토리 표 / 룰 08 §4.2/4.3 인벤토리 + 표준 + cross-check / 룰 25 §1.5.4 신규 (조회조건 Form 표준 5종 import + useTabComboQueries filter 키 인벤토리 + Grid size + FormItem + DatePickerCalendar 의무) / 메모리 신규 3건 (`feedback_mnu_uppr_case_standard.md` + `feedback_sheet_name_main_standard.md` + `feedback_form_search_area_standard.md`) / `feedback_be_restart_login.md` 보강 (BE 재기동 불필요 조건 4건).
- **2026-06-10 (사내 Oracle 직결 전환 + 11 화면 일괄 적용 + 룰셋 자가 진화 #4)**: BE `config-local.yml` 을 로컬 Docker 에서 사내 Oracle (10.20.100.153:2521:ESSCMD) 로 전환. **Phase A**: Docker 단계 제거 — `start-all.ps1` 의 PRE-CHECK Docker Desktop 감지 + Step 1 DOCKER 50 lines + `-SkipDocker` param + 포트 1521 점검 제거 / 0.3 사내 Oracle TCP 도달 PRE-CHECK 추가 / 단계 재번호 DOCKER/BE/FE → BE/FE. **Phase B**: 11 화면 (DMF0008/0072/0043/0043_01/0020 + SYS0011/0012/0013/0014/0015 + SYS0001) 의 Docker DB 산출물 (82 SQL 파일) 을 사내에 적용. 도구 = `docker exec nscm-oracle sqlplus` (Windows Oracle Instant Client 미설치 우회) + `tr -d '\r'` CRLF stdin pipe + `apply.sh` wrapper (`_artifacts/_apply_corporate/`). 사내 DB 변경량: MNU +2 / API +30 / PROC +107 / SHEET +62 / BTN +27 / 권한 +47. **8가지 사내 schema 차이 검출**: (1~4) SCM_ADM_MSG_M NOT NULL 4컬럼 (MSG_TP_CD/USE_YN/CREATED_BY/LAST_UPDATED_BY) (5) SCM_COM_MSG_M 양쪽 미존재 (6) SCM_ADM_MNU_M.BMK_YN 사내 미존재 (7) USERS tablespace quota 부족 ORA-01653 (8) DBMS_METADATA `bad stylesheet: kuaudobj` 버그. **Phase C**: i18n MSG 보강 SQL — DMF0008 i18n 15 row 4-파일 세트 + AS-IS MSG[숫자] 인벤토리 (33 ID → To-Be 미등록 29) 등록 SQL 4-파일 세트 (`_artifacts/_apply_corporate/_msg_inventory/`). Docker DB 검증 ✅ 87 rows created / 사내 ORA-01653 잔존 (DBA 확장 필요). **Phase D**: lint 사고 → 룰 변환 2건 — (1) `@tanstack/react-query` 직접 import → `@foundation/query-client` re-export 사용 의무 (2) relative imports 알파벳/계층 정렬 (`./{name}.constants/types` → `./components/*`). **신규 hook 5종**: `db-corporate-apply.md` / `db-schema-divergence-check.md` / `asis-msg-inventory.md` / `react-query-foundation-reexport.md` / `relative-import-order.md`. **신규 메모리 5종**: `reference_corporate_oracle_connection.md` + `feedback_corporate_db_apply_pattern.md` + `feedback_corporate_schema_8_diffs.md` + `feedback_react_query_import_foundation.md` + `feedback_relative_import_order.md` + MEMORY.md 인덱스 갱신. **start-all.ps1**: Docker 단계 제거 commit `04dda18` push (개인 백업 leekc297/NSCM). **메모리 `feedback_start_server.md`** 갱신 — 서버 기동 = BE + FE 2종 (Docker 미포함).
- **2026-06-09 (4 신규 admin 화면 풀스택 — MESSAGE/CODE/Group User/Program + 룰셋 자가 진화 #3)**: 사용자 명시 요구 — 4 admin 화면 신규/보강. MENU_ID 충돌 (SYS0011/0012 = AuthRequest/AuthApproval 기존) → SYS0014/0015 신규. **Phase A** (MESSAGE SYS0001 + CODE SYS0010 audit): SYS0010 lookupDetail AFTER_SAVE 권한 누락 fix. **Phase B SYS0015 PROGRAM**: 풀스택 (DDL `SCM_ADM_PROGRAM` + 7-BLOCK 메타 + 2 SP dual cursor + AS-IS TB_FX_ProgramInfo 406 → 397 row import + FE 6 파일 + Router + i18n). **Phase C SYS0014 Group User**: 4 SP (GET_GROUP/USER/AUTH + SAVE 4-sheet 통합) + 5 sheet SHEET_COLUMNS + FE 8 파일 (Main/UserInfo/3×UnitGrid cascade). **추가 보강**: SAVE SP 4 sheet 확장 + handleInsert/handleDelete per-grid + TitleArea rightButtons (룰 09 §12) + SsoUserModal popup (USER_ID dblClick + setUser callback + editTracker) + Recently-Added loadedRows 패턴 (Main grid CRUD_TYPE='I' 자동 isSelected) + SHEET_COLUMNS INPUT_TP_CD + ATTRIBUTE1(modalKey). **사고 → 룰 변환 1 건**: SCM_ADM_MNU_M.MNU_DESC NULL → FE sidebar 메뉴 미표시 (SYS0015 진단 사고). **hook 보강**: `menu-not-displayed-debug.md §1.3.5 Step 1.7` (MNU_DESC NULL 검증 + 자매 cross-check + fix UPDATE). **룰 13 §10 신설**: MNU_DESC 필수 의무 (anti-pattern + 자매 cross-check + 자동 검증 SQL). **메모리 신규**: `feedback_mnu_desc_required.md` + MEMORY.md 인덱스. **메뉴 위치 정정**: SYS0014/SYS0015 UPPR_MNU_ID Admin_Menu → System 이동 (사용자 요구) — SCM_ADM_MNU_M UPDATE + Router children 위치 변경. SYS0010 Admin_Menu 유지. **DB artifacts**: 72/73/74/75/76/77/78/79 (8 SQL) + `_artifacts/_asis_program_dump/` (AS-IS import + Python NOT NULL default 처리).
- **2026-06-07 (DMF0003 MKT FCST Insert dropdown 사고 5건 → 룰셋 자가 진화)**: DMF0003 신규 화면 풀스택 + Insert cell dropdown 정밀 적용 작업 중 12 단계 보완사항 누적. **사고 → 룰 변환 5 건**: (1) `selectionMode='Row'` 명시 시 single click → row 선택만 → cell editor 진입 차단 → dropdown 미표시 근본 원인. 자매 DMF0020 미명시 default `'MultiRange'` 사용 (2) imperative `g.columnLayout=JSON.stringify(...)` 재set 시 column 객체 재생성 → `col.dataMap` reset → 모든 timing fix 후에도 fail. JSX `<FlexGridColumn dataMap={dataMaps[c.key]}>` 평면 + 3-row header `g.columnHeaders.rows.push(new Row())` + formatItem textContent 패턴 의무 (3) useEffect 안 매번 `new DataMap(...)` 시 wijmo column stale state. DataMap 객체 자체 `useMemo` memoize 의무 (4) CMBO_SQL_M `@varName` BE 자동 채움 = `@sesUserId/@sesLangCd/@langCd/@mnuId` 시스템 키만. `@divisionId/@endCustomer` 등 사용자 정의 변수는 객체 filter `{ comboId, divisionId }` 명시 의무. BizType 같은 단순 distinct 는 SQL `@divisionId` 제거 + `DIVISION_ID` 결과 컬럼 + FE filter 패턴 (5) localStorage persist `useEffect(() => setItem, [state])` 패턴은 mount 시 closure 의 default 가 saved 덮어쓰기 사고. mount 1회 복원 useEffect + handleApply callback 안 직접 setItem 의무. **신규 hook 2 종**: `Doc/_rules_v2/hooks/wijmo-insert-cell-dropdown.md` (12 단계 보완사항 1-pass 의무 + 자매 검증 SQL_ID 인벤토리) / `localstorage-persist-pattern.md`. **TO-BE 룰 3 종 보강**: 07_datagrid §12 (Insert cell ComboBox 표준 — 5 anti-pattern + 정확 패턴 코드 + handleInsert 표준 + Sort/Filter hotkeyConfig + 자동 검증 grep) / 12_metadata_sql §15 (CMBO `@varName` BE 자동 채움 표 + 자매 검증 SQL_ID 13건 인벤토리 + SQL 작성 권장) / 04_store §11 (sessionStorage vs localStorage 결정 표 + anti-pattern + 정확 패턴). **메모리 신규 4 건**: feedback_wijmo_jsx_over_columnlayout / feedback_wijmo_selection_mode_default / feedback_cmbo_sql_at_division_param / feedback_localstorage_persist_callback_pattern + MEMORY.md 인덱스 보강. **부수 fix**: PlantSite / Measure CMBO_SQL_M 등록 (`_artifacts/_deploy_packages/DMF0003/03_META/040_DMF0003_PlantSite_Measure_combo_register.sql` MERGE 멱등) / BizType SQL `@divisionId` 제거 (`030_DMF0003_BizType_combo_fix.sql`) / Sort+Filter button hotkeyConfig 명시 (`sort: handleSort, filter: handleFilter` + GridAction toggleColumnSort/Filter) / handleInsert startEditing → 첫 editable col (`_inputEditType: 'IM'|'IO'`) 자동 찾기 (DIVISION_ID 등 read-only col 회피). 자매 검증 reference: `features/master/src/pages/sales-future-price/components/SalesFuturePriceFlexGrid.tsx:65-432`.
- **2026-06-09 (SCM0005 DynamicQuery 풀스택 + SHEET_COLUMNS 전역 dedupe + 룰셋 자가 진화 #2)**: SCM0003/SCM0005 audit + SYS0013 BE/PROC_M/SP rewrite + AS-IS DQ 데이터 import (107/1886/272/157 row) + SHEET_COLUMNS binding fix + DynamicQueryResultGrid 동적 column 작업 중 사고 6 건 도출. **사고 → 룰 변환 6 건**: (1) `createPersistedStoreWithTab` 시그니처 (1 제네릭 + 2 인자) — SCM0009/SCM0005 재발 (2) `SCM_MST_SHEET_COLUMNS.COLUMN_NAME` = SP 반환 alias case-sensitive 일치 의무 — mismatch 시 row 추가되지만 cell 빈 칸 (3) `SCM_ADM_PROC_M` 행 수 + SORT_ORD = SP ALL_ARGUMENTS positional 정확 일치 의무 — PLS-00306 방지 (4) `MNU_BTN_CD` 표준 SEARCH 의무 (RETRIEVE 금지) + MNU_BTN_MPG_M ↔ USER_GR_MNU_BTN_MPG_M 일관성 — "권한없음" 방지 (5) `fetchStaticColumns` 는 `if (!initialized)` guard 밖 의무 — persist 시 영구 미호출 방지 (6) DataGrid `staticColumns` 하드코딩 `[{binding, header, width}]` 금지 — `mapRawColumnsToWijmoColumns` 의 `.filter(c => c.display)` 통과 못 함. **신규 hook 2 종**: `Doc/_rules_v2/hooks/sheet-columns-binding-match.md` / `proc-meta-signature-match.md`. **TO-BE 룰 3 종 보강**: 04_store §9/§10 (createPersistedStoreWithTab 시그니처 + fetchStaticColumns guard) / 07_datagrid §11 (staticColumns 출처 표준 — store/dynamic/하드코딩 금지) / 12_metadata_sql §13/§14 (MNU_BTN_CD 표준 + 전역 SHEET_COLUMNS dedupe). **메모리 신규 6 건**: feedback_createpersistedstorewithtab_signature / feedback_sheet_columns_binding_must_match_sp / feedback_proc_meta_must_match_sp_signature / feedback_button_code_consistency_search_vs_retrieve / feedback_fetchstaticcolumns_no_initialized_guard / feedback_grid_no_hardcoded_static_columns. **DB artifacts**: `_artifacts/57_SYS0011_dedupe / 65_GLOBAL_SHEET_COLUMNS_dedupe_all (15,166 row 삭제) / 66_SYS0013_permission_fix / 67_SYS0013_DMF0027_PROC_M_resync / 68_SYS0013_remaining_PROC_M / 69_SYS0013_SHEET_COLUMNS_register / 70_DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_rewrite / 71_SYS0013_SHEET_COLUMNS_resync_actual_sp_cols`. **FE 변경**: useDynamicQueryStore.ts (시그니처 fix + staticColumns state + fetchStaticColumns + setSelectedQueryId filter key 정정) / DynamicQuery.tsx (fetchStaticColumns guard 밖) / 5 sub-grid (Main/Columns/Parameters/History store-fetched + Result 동적 column) / SCM0009 AuthApprovalGrid 동일 패턴. **AS-IS data import**: `_artifacts/_asis_dq_dump/` (5 dump txt + convert_to_oracle.py NOT NULL default 처리 + insert_dq_*.sql 4 파일). 00_INDEX hook 카탈로그 14→16 항목 추가 + T08/T04 트리거 매트릭스 보강.
- **2026-06-09 (SCM0008/0009 풀스택 fix + 룰셋 자가 진화)**: 사용자 명시 요구 다회 → SCM0008 Auth Request 4 사고 묶음 + SCM0009 Auth Approval 풀스택 (form 표준 컴포넌트 / Grid 메타 / SP dual cursor / i18n) 작업 후 룰셋 v2 패키지화. **사고 → 룰 변환 6 건**: (1) `useProcMutation onSuccess` override 시 default (invalidate + toast) 완전 대체 — 4 요소 명시 의무 (2) Oracle GET SP dual OUT cursor (`O_RC` + `O_RESULT_CURSOR`) — 단일 cursor 사용 시 FE `data.o_rc` undefined → grid 빈 표시 (3) DataGrid `selectionMode={SelectionMode.Row}` — 단일 row 선택 grid 의무 명시 (4) 그리드 특화 액션 버튼 (Add/Delete) 은 SubTitle 이 아닌 TitleArea.rightButtons 배치 (5) 서버 데이터 (APPROVAL_RESULT 등) 기반 row.isSelected 자동 setting 금지 (6) Recently-Added row 표시 = Wijmo `loadedRows` event handler + ref 3 요소 패턴 의무 (useEffect 단독 X) + (7) SearchArea Grid size 균등 표준 (3 field = 3/3/3). **신규 hook 3 종**: `Doc/_rules_v2/hooks/mutation-onsuccess-defaults.md` / `sp-dual-cursor-pattern.md` / `grid-interaction-patterns.md`. **TO-BE 룰 5 종 보강**: 07_datagrid §8/§9/§10 (selectionMode + 자동체크 금지 + recently-added) / 09_subtitle_hotkey §12 (그리드 특화 액션 배치) / 11_be_controller_service §3.1 (dual cursor 강화) / 12_metadata_sql §2.4.1 (PROC_M cursor 표준) / 06_search_area §10 (Grid size 균등). **메모리 신규 7 건**: feedback_useprocmutation_onsuccess_override / feedback_sp_dual_out_cursor_pattern / feedback_grid_selectionmode_row / feedback_grid_action_button_placement / feedback_no_auto_check_on_server_state / feedback_recently_added_loadedrows_pattern / feedback_form_grid_equal_sizing. **DB artifacts**: `_artifacts/57~63_SYS0011/SYS0012*.sql` (8 file — dedupe / SHEET_COLUMNS / API_M / MNU_BTN_MPG_M / PROC_M / USER_GR_MNU_BTN_MPG_M / SP 3 종 + dual cursor fix). **FE 변경**: SubTitle.tsx `searchAction` prop 신설 / AuthRequest.tsx + AuthApproval.tsx + AuthApprovalForm.tsx + useAuthApprovalStore.ts + AuthApprovalGrid.tsx + AuthorityGrid.tsx + MyAuthorityListGrid.tsx + DivisionGrid.tsx + UserInfoDetail.tsx 모두 표준 컴포넌트 + 룰 적용. **i18n**: KO/EN/CN.json 에 LBL00601~LBL00617 (17 키) 추가 + AuthRequest/UserInfoDetail 의 t() key 정리. 00_INDEX hook 카탈로그 11→14 항목 추가 + T05/T07 트리거 매트릭스 보강. 신규 화면 작성 시 룰 v2 트리거 매트릭스에서 자동 분기.
- **2026-06-06 (SCM0008 fix + 공통 버튼 기본 표시 정책 + SearchArea 부재 Search 버튼 룰화)**: 사용자 명시 요구 3건 → 룰 자가 진화. **SCM0008 (Auth Request) 사고**: (1) hotkeyConfig 9 키 (insert/delete/save/search/condition/resetCondition/excel/upload/manual) 전부 false → Sort/Filter/Excel 까지 숨김 + SearchArea 부재 + search false → 사용자가 조회 트리거 + 정렬/필터/엑셀 다운로드 수단 없음 (2) SCM_MST_SHEET_COLUMNS PROGRAM_ID='SYS0011' 의 4 sheet 모두 정확히 2배 중복 (authority 6=3×2 / division 4=2×2 / myAuthorityList 18=9×2 / userInfo 14=7×2 = TOT 42 / DISTINCT 21). **fix**: (1) `_artifacts/57_SYS0011_SCM0008_sheet_columns_dedupe.sql` 4-파일 세트 적용 (21 row 삭제, 잔존 0건 검증 PASS) (2) `nscm-fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx` 에 **`searchAction?: () => void` prop 신설** — rightButtons 의 맨 앞 (customButtons 보다 좌측) 에 "Search(F5)" 자동 렌더 + F5 hotkey 자동 연동 (3) `AuthRequest.tsx` 의 hotkeyConfig 일괄 false 제거 → Hidden allowlist (insert/delete/save) + UsrConditionPanel 부재 (condition/resetCondition false) + manual/upload false + sort/filter/excel 생략 (자동 활성) + `searchAction={handleSearch}` (useQueryClient invalidate `[tabId]`). **룰 보강**: 룰 09 §2.2.1 (공통 버튼 기본 표시 정책 — Hidden allowlist + Always-visible 매트릭스 + SCM0008 위반 사례) + §2.5 (SearchArea 부재 searchAction 의무) + §7.4/§7.5 anti-pattern + §8 grep #6 (일괄 false 검출) + #7 (disableSearchArea + searchAction 누락 검출) / hook `asis-button-mapping.md` §5 (공통 버튼 정책 + 의무 매트릭스 + SCM0008 사례) / **hook 신규 `search-button-when-no-searcharea.md`** (SubTitle searchAction prop 구현 사양 + 화면 적용 패턴 + 자동 검증 grep). **메모리 신규 2건**: `feedback_common_button_visibility_default.md` (Hidden allowlist 정책 + 자동 검증 grep + 사고 사례) + `feedback_search_button_when_no_searcharea.md` (SubTitle prop 사양 + 적용 조건 2축 + 기존 위반 화면 인벤토리 4건 — admin 3 화면 향후 처리 TODO). MEMORY.md 인덱스 보강.
- **2026-06-03 (DMF0020 메인 SP 1:1 변환 + popup 3종 AS-IS 매핑 + Wijmo 머지 sticky + 공용 ColumnSettingModal)**: 사용자 요구 다회 보완 → 룰 정리. **메인 SP B 옵션 변환**: AS-IS `DMF0020_GET_SCM_MST_FUTURE_PRICE` 1,898 lines → Oracle `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M` (Dynamic PIVOT + 28 fixed cols + 4 measure cartesian) + SAVE SP `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL_M` (17 IN ^-delim CLOB DELETE-INSERT). **CSV 적재**: SCM_MST_FUTURE_PRICE div=40/81 105만 rows + SCM_SYS_CALENDAR_M 15K + SCM_MST_SHEET_MEASURE. **CMBO 등록**: FcstType / CustomsHandbook / BizType (BP_FCST_TYPE / BP_CUSTOMS_HANDBOOK / SCM_MST_PROJECT). **3 popup AS-IS 1:1 매핑**: ExchangeRate (long→wide pivot + 2-row YYYY/MM header + Division/Currency Restricted merge), PriceBatch (2-row 검색조건 + 12 cols grid + Project/Item popup), ColumnSetting (dual grid Base/User + Sort combo). **공용 컴포넌트화 (Option C)**: `features/master/src/components/columnSettingModal/` 신설 → DMF0020/DMF0043_01 둘 다 호출 (Hybrid — BE SP 결과 + fallbackColumns FE meta fallback). **사고 → 룰화 8건**: (1) Wijmo `g.mergedRanges` 잘못된 API → 룰 12 §11.6.3.1 + hook `wijmo-merge-sticky-content.md` 신규 + 메모리 `feedback_wijmo_merge_sticky_content.md` (2) merge cell scroll 시 빈 영역 → §11.6.3.2 viewport sticky content 패턴 (translateY 보정) (3) Wijmo `DataMap` import 위치 (`@mescius/wijmo.grid`) → 룰 23 §8.1 신설 (Wijmo class export 위치 정확 표) (4) CustomDialog `DEFAULT_HEIGHT='50vh'` 미고려 SCSS `min-height: 70vh` 잘림 + position='overflow' 중앙 미표시 → hook `popup-dialog-layout.md` 신규 + 메모리 `feedback_popup_dialog_layout.md` (5) React Query refetch loop (filters 매 render 신규 객체) → useMemo 의무 (각 popup 적용) (6) CMBO_SQL_M `@varName` quote 없이 raw 치환 → VARCHAR2 비교 시 ORA-01722 (SEGMENT1='81_UC' 등) → hook `oracle-cmbo-varname-quote.md` 신규 + 메모리 `feedback_oracle_cmbo_quote_pitfall.md` (TO_CHAR wrap 의무 + Oracle '' = NULL 룰) (7) SCM_ADM_API_M `API_TP_CD` NOT NULL 누락 → 기존 메모리 `reference_scm_adm_api_m_ddl` cross-check 안 함 (anti-simplification 위반 자체 분석) (8) priceBatch sheet 가 환율 SP `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP` (6 IN) 잘못 routing → 메인 SP `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M` (17 IN) 으로 변경. **00_INDEX hook 카탈로그**: 06w (wijmo-merge-sticky) + 06x (popup-dialog-layout) + 06y (oracle-cmbo-varname) 3건. **룰 23 §12.A 공용 modal 인벤토리**: `ColumnSettingModal` 추가 / `ProjectByDivisionModal` setSelectedValue 확장 (optional `projectStatus`/`bizTypeName` 자동 채움 — DMF0020). **메모리 신규 4건** + MEMORY.md 인덱스 보강.
