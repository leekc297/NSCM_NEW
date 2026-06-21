# Hook — BE API 계약 (UI 호출 관점, javadoc 기준)

> **Trigger**: T07 (데이터 조회/SAVE) + T08 (BE/Controller/Service) + T01 (신규 화면의 BE 연동)
> **출처(공식)**: `Doc/03.Framework/BackEnd API List 및 사용가이드(javadoc)/` (NSCM BE javadoc, com.lgcns.nscm.framework + admin)
> **PR 차단 강도**: ⭐⭐ (계약 불일치 = 호출 실패/런타임 사고)
> **신설일**: 2026-06-19 (03.Framework 룰화 — FE+BE API 포함 결정)
> **상위 hook**: `framework-foundation-entry.md`
> **짝 hook**: `messaging-api-and-search-fields-mandatory.md` (#26, FE apiClient 측)

## 0. 원칙 — "FE apiClient 호출은 BE javadoc 계약과 정확히 매핑된다"

FE 의 `@foundation/apis` apiClient 메서드는 BE 의 Controller endpoint 와 1:1 대응한다. 신규 화면/기능에서 BE 호출 시, 본 hook 의 계약표로 **endpoint·파라미터·응답 형태**를 확인하고 표준 호출 경로(useTabProcQuery 등)를 사용한다. 화면에서 `fetch`/`axios` 직접 호출 금지 (#framework-foundation §1).

---

## 1. 표준 응답 포맷 (`BaseResponse<T>` / `BaseController`)

모든 BE 응답은 `@ControllerAdvice BaseController` 하위에서 `BaseResponse<T>` 로 정형화:

```json
{ "code": "0", "message": "success", "result": { ... } }
```

- BE: `successResponseEntity(data)` 사용 — `ResponseEntity` 직접 작성 금지 (CLAUDE.md §6).
- 에러: `ErrorResponse extends BaseResponse` + `GlobalExceptionHandler` (BusinessException/SystemException/SqlException/ConnectorException).
- `CustomMap` = 공통 Data DTO (Clob, Date/Timestamp 자동 변환 HashMap) — SP 결과 매핑 시 사용.

## 2. ⭐ 핵심 — 동적 프로시저 호출 (`GeneralController.callProc`)

대부분의 화면 조회/저장은 이 endpoint 하나로 수렴:

| BE (javadoc) | 시그니처 | FE 호출 |
|---|---|---|
| `GeneralController.callProc` | `(UserSession, params, mnuId, shtNm, mnuBtnCd)` | `apiClient.callProc<M,S>` / `callMutationProc<M,S,RS>` |
| URL 패턴 | `${menuId}/${sheetName}/${action}/call-proc` | — |
| `GeneralController.retrieveGeneral` / `excuteGeneral` | `(params, business, subBusiness)` | 일반 조회/실행 |

- FE 우선순위: **`useTabProcQuery` > `apiClient.callProc` 직접** / **`useProcMutation` > `callMutationProc` 직접**.
- BE 내부: `BaseService.makeProcedure(params, procParam)` (동적 프로시저 생성) → `selectList(dbId, sqlId, param)`.
- `mnuBtnCd` = 버튼 코드(SEARCH/SAVE/INSERT/DELETE/EXECUTE) → 권한·로그 분기.

## 3. Combo / Lookup (`LookupController`)

| BE | FE | body / response |
|---|---|---|
| `retrieveCombo` | `apiClient.getCombo` (legacy) | 단건 combo |
| `retrieveComboMuti` | `apiClient.getCombosMulti` | `admin/combo-muti` body `{comboList:[{comboId}]}` → `{ComboId:[]}` (1 round-trip) |
| `retrieveLookkup` | `apiClient.getLookup` (legacy) | 단건 lookup |
| `retrieveLookkupMuti` | `apiClient.getLookupsMulti` | `admin/lookup-muti` body `{lookupType:'A,B'}` csv |

- FE 우선순위: **`useTabComboQueries` > `getCombosMulti` 직접**. (#messaging-api §apiClient)
- BE 내부: `BaseService.makeComboQuery(query, params)` (콤보 동적 쿼리).

## 4. 메뉴 / 권한 / 동적 메타 (`MenuController`)

| BE | FE 용도 |
|---|---|
| `retrieveMenus(userSession)` | 메뉴 트리 (useSessionStore 메뉴목록) |
| `retrieveMenuAuth(userSession, mnuId)` | 화면 권한 (`MenuAuthDto`) |
| `checkMenuAuth(userSession, mnuId)` | 권한 체크 |
| `retrieveGridColumns(userSession, mnuId, dto)` | **동적 컬럼 메타** (`GridColumn`) → #ui-category-setup-column-meta |
| `retrieveGridMeasures(userSession, mnuId, dto)` | **동적 measure 메타** (`GridMeasure`) → #ui-dynamic-property-management |

- 버튼 권한은 FE `useTabBtnPermissions({ menuId })` → `mnuBtnAuth: string[]` (#screen-meta-and-permissions #50).
- 동적 컬럼/measure 는 admin UI 결정이 단일 진실 → 하드코딩 금지.

## 5. 세션 / 사용자 (`UserController`)

| BE | FE |
|---|---|
| `getUserSession(userSession)` → `UserSession` | useSessionStore 초기화 |
| `login(LoginRequest)` / `logout()` | SSO 미연동 — 직접 login/logout (인수인계서 §2-1) |
| `setLangCd(userSession, LangCdRequest)` | 언어코드 변경 (i18n) |

## 6. 보안 / 로그 어노테이션 (BE 작업 시)

- `@AuthCheck(type=...)` — 권한 검증 (`AuthCheck.Type`)
- `@LoginUser` — `UserSession` 주입 (`LoginUserArgumentResolver`)
- `@SystemLog(LogType)` — 시스템 로그 (`SystemLogAspect`)
- `@RequiredArgsConstructor` + final 주입 (CLAUDE.md §4 — `@Autowired` 필드 주입 금지)

## 7. PRE-WRITE 체크리스트

- [ ] 화면 조회/저장이 `useTabProcQuery`/`useProcMutation` (→ callProc) 경유인가? (fetch/axios 직접 0)
- [ ] combo/lookup 이 `useTabComboQueries`/getCombosMulti 경유인가?
- [ ] 동적 컬럼/measure 를 `retrieveGridColumns`/`retrieveGridMeasures` 로 fetch 하는가? (하드코딩 0)
- [ ] BE 신규 시 응답이 `successResponseEntity(data)` (표준 `{code,message,result}`)인가?
- [ ] BE 신규 시 `@RequiredArgsConstructor` + `@AuthCheck`/`@SystemLog` 적용했는가?
- [ ] SP 호출 시 `mnuBtnCd` 가 버튼 코드와 일치하는가?

## 8. POST-WRITE grep (0 hit 의무)

```bash
grep -rEn "\b(fetch|axios)\(" features/                         # 0 (apiClient 경유)
grep -rEn "ResponseEntity\.(ok|status)\(" nscm-be/              # 0 (successResponseEntity 사용)
grep -rEn "@Autowired" nscm-be/src/main/java/.../service        # 0 (생성자 주입)
# 동적 컬럼 하드코딩 흔적
grep -rEn "staticColumns\s*=\s*\[" features/                    # 검토 (retrieveGridColumns 여야)
```

## 9. 안티패턴

| ❌ | ✅ |
|---|---|
| 화면에서 `axios.post('/...')` | `useTabProcQuery`/`useProcMutation` |
| combo 개별 N회 호출 | `useTabComboQueries` (1 round-trip) |
| 컬럼 메타 하드코딩 | `retrieveGridColumns` 동적 fetch |
| BE `return ResponseEntity.ok(...)` | `successResponseEntity(data)` |
| BE `@Autowired` 필드 주입 | `@RequiredArgsConstructor` + final |
| 권한/로그 어노테이션 누락 | `@AuthCheck` + `@SystemLog` |

## 10. Cross-ref

- `framework-foundation-entry.md` (상위) / `messaging-api-and-search-fields-mandatory.md` (#26, FE apiClient 10 메서드) / `screen-meta-and-permissions-mandatory.md` (#50, 권한) / `ui-dynamic-property-management.md` (#66) / `ui-category-setup-column-meta.md` (#65) / `_tobe/11_be_controller_service.md` / `mutation-onsuccess-defaults.md` (#28)
