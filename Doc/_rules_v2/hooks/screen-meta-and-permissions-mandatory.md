# Hook — Screen Meta & Permissions (`useTabBtnPermissions` + `__asis-mapping__.md` + i18n 3 언어 + Modal mount)

> **Trigger**: T01 (신규 화면 / 수정) + T20 (화면 완성도 게이트)
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등)
> **신설일**: 2026-06-18 (자가 진화 #29, 사용자 명시 — "누락 없을 때까지" cross-check 3 회차)
> **세트 hook**: #60+#61+#62+#63+#64+#65+#66+#67 + **#68 (본 hook)**

## 0. 원칙 — 4 영역

1. **메뉴 버튼 권한 동적 fetch** — `useTabBtnPermissions` 의무 + `hotkeyConfig` `: false` 동적 분기 (admin USE_YN='N' 자동 반영)
2. **`__asis-mapping__.md` 화면별 작성 의무** — AS-IS↔TO-BE 4축 매핑 + 카운트 100% ✅
3. **i18n 3 언어 동시 등록** — `KO.json` + `EN.json` + `CN.json` 신규 LBL 모두 추가
4. **Modal mount 결정** — 조건부 (`{open && <Modal>}`) vs 항상 (`<Modal open={open}>`) 시나리오별 선택

---

## 1. `useTabBtnPermissions` 권한 동적 hook (`@shared/hooks`)

### 1.1 표준 시그니처
```tsx
import { useTabBtnPermissions } from '@shared/hooks';
import type { HotkeyConfig } from '@foundation/models';

const { hasButton, isLoading } = useTabBtnPermissions({ menuId: MENU_ID });

const hotkeyConfig: HotkeyConfig = {
  search: hasButton('SEARCH') ? handleSearch : false,
  save:   hasButton('SAVE')   ? handleSave   : false,
  insert: hasButton('INSERT') ? handleInsert : false,
  delete: hasButton('DELETE') ? handleDelete : false,
  manual: false,
  upload: false,
};

const customButtons = hasButton('EXECUTE')
  ? [{ label: t('LBL00xxx', '_Execute'), action: handleExecute }]
  : [];
```

### 1.2 동작
- BE: `GET /admin/menu/{mnuId}/auth` → `MenuAuthDto.mnuBtnAuth: string[]`
  - `SCM_ADM_USER_GR_MNU_BTN_MPG_M` JOIN → 사용자 그룹 권한 있는 BTN_CD list 반환
- admin `SYS0009 (Menu Button)` 에서 BTN 의 `USE_YN='N'` 설정 시 → mnuBtnAuth 에서 제외
- 사용자 그룹이 BTN 권한 없으면 → mnuBtnAuth 에서 제외
- 화면 mount 시 자동 fetch + react-query cache (60s staleTime)

### 1.3 의무 사항
- 신규 화면 작성 시 `useTabBtnPermissions` 호출 의무
- `hotkeyConfig` 의 각 핵심 액션 (search/save/insert/delete) 에 `hasButton('XXX') ? ... : false` 분기 의무
- `customButtons` 도 권한 분기 — `hasButton('EXECUTE') ? [...] : []`
- 권한 누락 시 hotkeyConfig 정적 정의 = admin 운영 결정 무력화 → PR 차단

### 1.4 BTN_CD 표준 키 (SCM_MST_BTN_M)
| BTN_CD | 매핑 hotkeyConfig | 비고 |
|---|---|---|
| `SEARCH` | `search` (F5) | 조회 |
| `SAVE` | `save` (F7) | 저장 |
| `INSERT` | `insert` (F8) | 추가 |
| `DELETE` | `delete` (F9) | 삭제 |
| `EXECUTE` | customButtons | 화면 전용 |
| `UPLOAD` | `upload` | 엑셀 업로드 |
| `EXPORT` | (Excel 자동) | 보통 권한 미분기 |

---

## 2. `__asis-mapping__.md` 표준 양식 (권장 — 사용자 작성 시 참조)

> ⚠️ **2026-06-18 사용자 정책 정정**: DMF0004/0005/0006 3 master 화면에 `__asis-mapping__.md` 가 **존재하지 않음**. 따라서 본 영역은 **3 master 에서 추출된 패턴 아님** — 신규 화면 작성 시 마이그레이션 / 분석 자료가 필요하면 본 양식 참조 (필수 아님).

### 2.1 파일 위치
```
features/{domain}/src/pages/{screen}/__asis-mapping__.md   ⭐ 화면 폴더 안 (`pages/`)
```

### 2.2 표준 헤더
```markdown
# DMF0099 (Screen Name) AS-IS ↔ TO-BE 4축 매핑

> **작성**: 2026-MM-DD
> **AS-IS Source**: `Doc/_legacy_source/06_UIL/domain_XX/.../DMF0099_XxxYyy.cs` (라인 수, 메인 우선순위)
> **참조 매핑**: `Doc/_analysis/_asis_mappings/XX/DMF0099_XxxYyy/__asis-mapping__.md`
```

### 2.3 표준 카운트 요약 (8 행 × Phase 진행)
```markdown
## 카운트 요약

| 구분 | AS-IS | Phase 1 | ... | 상태 |
|---|---:|---:|---|
| Event handler | N | ... | **전 phase 완료** |
| API (SP 호출) | N | ... | **전 phase 완료** |
| Validation | N | ... | **전 phase 완료** |
| Expression | N | ... | **전 phase 완료** |
| Button | N | ... | **전 phase 완료** |
| Grid 컬럼 | N | ... | **전 phase 완료** |
| POPUP | N | ... | **전 phase 완료** |
| 격차 | N | ... | **전 phase 완료** |

> ⚠ **모든 행의 상태가 ✅ 가 되어야 PR 머지 가능** (anti-simplification 의무).
```

### 2.4 §A~§D 4축 매핑 표준 섹션

| 섹션 | 내용 | 행 컬럼 |
|---|---|---|
| **§A. Event 매핑** | `Form_Load` / `Button_Click` / `Cell_DoubleClick` 등 | # / AS-IS Handler / Control / Event / AS-IS Line / TO-BE Handler / TO-BE Location / Phase / 상태 |
| **§B. API 매핑** | SP 호출 (`PKG_DMF0099.P_GET_MAIN` 등) | # / AS-IS SP / TO-BE PROC_M ID / API_ID / React Query Key / Phase / 상태 |
| **§C. Validation 매핑** | `MessageHelper.GMessageBox` 호출 | # / AS-IS Validation / MSG ID / Trigger / TO-BE Location / Phase / 상태 |
| **§D. Expression 매핑** | `LockColumn` / `SetValue` Auto-Sync | # / AS-IS Expression / Cells / Logic / TO-BE Location / Phase / 상태 |

### 2.5 Protected override 5+1 표 (CRUD 6대)
```markdown
### Protected override (5 — CRUD 6대 중 5)
| # | Method | AS-IS Line | TO-BE | Location | Phase | 상태 |
|---:|---|---:|---|---|:-:|:-:|
| O1 | `FindButton()` override | 957 | `handleSearch` (F5) | ... | P1 | ✅ |
| O2 | `InsertButton()` override | ... | `handleInsert` (F8) | ... | P2 | ✅ |
| O3 | `DeleteButton()` override | ... | `handleDelete` (F9) | ... | P2 | ✅ |
| O4 | `EditButton()` override | ... | (cell 편집) | Grid level | P2 | ✅ |
| O5 | `SaveButton()` override | ... | `handleSave` (F7) | ... | P2 | ✅ |
| O6 | `OnShown` | ... | (useEffect) | ... | P1 | ✅ |
```

### 2.6 의무 사항
- 신규 화면 / 마이그레이션 화면 작성 시 **반드시 동반 작성** (Screen Completion Gate G1 = 메모리 `screen-completion-gate.md`)
- **모든 행 상태 ✅** — PR 머지 게이트
- AS-IS Source 라인 번호 정확 명시
- 카운트 = AS-IS `.cs` grep 결과 (자동 추출 의무, 메모리 `feedback_new_screen_mandatory.md`)
- Phase 진행 시 columns 추가 + 누적 ✅

---

## 3. i18n 3 언어 동시 등록 (`public/locales/{KO,EN,CN}.json`)

### 3.1 파일 위치
- `nscm-fe/public/locales/KO.json` (한국어 — 기본)
- `nscm-fe/public/locales/EN.json` (영어)
- `nscm-fe/public/locales/CN.json` (중국어)

### 3.2 표준 형식 (메모리 `feedback_i18n_lbl_code_pattern.md` cross-ref)
```json
// KO.json
{
  "LBL00001": "Div.",
  "LBL00002": "Plan Group",
  ...
  "LBL00501": "Future Price",            // ⭐ 신규 100-block 단위
  "LBL00502": "Project Status"
}

// EN.json — KO 와 정확 동일 키 + 동일 값 (메모리 `feedback_i18n_ko_en_alignment.md`)
{
  "LBL00001": "Div.",
  ...
  "LBL00501": "Future Price",
  "LBL00502": "Project Status"
}

// CN.json — 미적용 단계 (자동 EN 값 fallback)
{
  "LBL00001": "Div.",
  ...
}
```

### 3.3 의무 사항
- 신규 LBL 추가 시 **KO + EN 둘 다 동시 등록** (메모리 `feedback_i18n_ko_en_alignment.md`)
  - KO = EN 정확 동일 값 (메모리 명시)
  - KO 전용 키 (예: `MNU_*` 메뉴 트리) 는 EN 미존재 허용
- **CN 미적용** — fallback 영문 (현 phase 정책)
- 코드 = `LBL` + 5자리 숫자 (메모리 `feedback_i18n_lbl_code_pattern.md`)
- 자유 형식 (`LBL_DMF0020_DIV`) 절대 금지
- 신규 영역 = KO.json 최대값 + 100-block 단위 (DMF0020 = LBL00501~514)
- 기존 코드 재사용 시 KO.json 의 의미 cross-check 의무 — 충돌 사고 회피

### 3.4 자동 생성 / sync 스크립트
- `pnpm gen:i18n` — locales 변경 시 i18n type 재생성 (메모리 `reference_pnpm_scripts.md`)
- 신규 LBL 추가 후 type-check 전 의무 실행

---

## 4. Modal mount 결정 — 조건부 vs 항상

### 4.1 패턴 2 비교

| 패턴 | 시그니처 | 동작 |
|---|---|---|
| **A. 항상 mount** | `<RegionModal open={openModal} modalClose={...} ...>` | open=false 일 때 mount 유지 + `display:none` 또는 CSS hide. Modal 내부 useTabProcQuery / store state 보존 |
| **B. 조건부 mount** | `{openModal && <OwnerModal open={openModal} modalClose={...} ...>}` | open=false 일 때 unmount. 재오픈 시 reset + 재fetch |

### 4.2 시나리오별 결정

| 시나리오 | 추천 | 이유 |
|---|---|---|
| 자주 열림 + 데이터 보존 유리 (RegionModal 등 마스터) | **A 항상 mount** | 재오픈 시 즉시 표시, 검색 state 보존 |
| 가끔 열림 + reset 필요 (Owner / Item / Project popup) | **B 조건부 mount** | 메모리 절약, 재오픈 시 깨끗한 상태 |
| 데이터 fetch 비용 큼 + 캐싱 가치 있음 | A 항상 mount | useTabProcQuery 캐시 활용 |
| 컴포넌트 자체 무거움 | B 조건부 mount | 초기 화면 load 시 mount 비용 회피 |
| 항상 동일 데이터 표시 | A 항상 mount | fetch 1 회 충분 |

### 4.3 DMF0004/0005/0006 적용 사례
| 화면 | Modal | 패턴 |
|---|---|---|
| DMF0004 SalesSiteGrid | RegionModal | A 항상 mount (자주 열림 + 마스터 데이터 보존) |
| DMF0004 SalesSiteCustomerGrid | CustomerModal | A 항상 mount |
| DMF0005 SalesSiteProjectModelGrid | TeamModal / OwnerModal / ItemModal / ProjectModal | A 항상 mount (다중 popup 동시 보존) |
| DMF0005 SalesSiteProjectModelPurchaseGrid | OwnerModal | **B 조건부 mount** (`{openOwnerModal && <OwnerModal ...>}`) — 가끔 열림 + reset |
| DMF0006 CustomerModelMappingGrid | ProjectByDivisionModal / ItemByDivisionModal | A 항상 mount |

### 4.4 의무 사항
- 선택 시 시나리오 명시 의무 (주석 또는 PR description)
- 임의 변경 금지 — 한 화면 안 동일 패턴 유지

---

## 5. PRE-WRITE 체크리스트 (4 영역 — 10 항목)

```
[useTabBtnPermissions 권한]
[ ] 1.  useTabBtnPermissions({ menuId: MENU_ID }) 호출?
[ ] 2.  hotkeyConfig 각 액션 `hasButton('SEARCH'/'SAVE'/'INSERT'/'DELETE') ? handler : false` 분기?
[ ] 3.  customButtons 권한 분기 (`hasButton('EXECUTE')` 등)?

[__asis-mapping__.md]
[ ] 4.  화면 폴더 안 __asis-mapping__.md 작성?
[ ] 5.  카운트 요약 8 행 + Phase 진행 표?
[ ] 6.  §A Event / §B API / §C Validation / §D Expression 4 섹션?
[ ] 7.  Protected override 5+1 표?
[ ] 8.  모든 행 상태 ✅ (PR 머지 게이트)?

[i18n 3 언어]
[ ] 9.  신규 LBL 추가 시 KO.json + EN.json 동시 등록 (동일 값)?
[ ] 10. LBL + 5자리 / 자유 형식 0?
[ ] 11. `pnpm gen:i18n` 실행 후 type-check?

[Modal mount]
[ ] 12. 각 popup 시나리오별 mount 패턴 (A 항상 vs B 조건부) 결정 + 주석?
```

---

## 6. POST-WRITE grep (작성 직후 의무)

```bash
SCREEN="nscm-fe/features/{domain}/src/pages/{my-screen}"

# 1. useTabBtnPermissions 호출 확인
grep -nE "useTabBtnPermissions" "$SCREEN/${PascalCase}.tsx"
# 결과 ≥ 1

# 2. hotkeyConfig 정적 정의 (권한 분기 누락) 검출
grep -nE "search:\\s*\\(\\)\\s*=>" "$SCREEN" | head
# 결과 — `hasButton` 동반 확인

# 3. __asis-mapping__.md 존재 + 모든 행 ✅
test -f "$SCREEN/__asis-mapping__.md" && echo "OK"
grep -c "✅" "$SCREEN/__asis-mapping__.md"
# 결과 > 0

# 4. i18n 자유 형식 키 검출
grep -nE "t\\('LBL_[A-Z]" "$SCREEN"
# 결과 = 0

# 5. KO/EN i18n 키 mismatch 검출
KO_KEYS=$(grep -oE "LBL[0-9]{5}" nscm-fe/public/locales/KO.json | sort -u)
EN_KEYS=$(grep -oE "LBL[0-9]{5}" nscm-fe/public/locales/EN.json | sort -u)
diff <(echo "$KO_KEYS") <(echo "$EN_KEYS")
# 결과 — EN 만 존재 키 0 (KO 전용 MNU_* 는 허용)
```

---

## 7. 안티 패턴 (PR 차단)

| # | 안티 패턴 | 사고 / 대체 |
|---:|---|---|
| 1 | `useTabBtnPermissions` 누락 + `hotkeyConfig.search: () => ...` 정적 정의 | admin USE_YN='N' 무력화 / 사용자 그룹 권한 무시. `hasButton('SEARCH') ? handler : false` |
| 2 | `customButtons` 권한 분기 없이 표시 | 권한 없는 사용자도 버튼 보임 + 누르면 BE 403. `hasButton('EXECUTE') ? [...] : []` |
| 3 | `__asis-mapping__.md` 미작성 + PR 제출 | 화면 완성도 게이트 G1 fail. anti-simplification 위반 |
| 4 | `__asis-mapping__.md` 작성했으나 카운트 100% 미달 + ⏳ 잔존 | PR 머지 차단 (anti-simplification) |
| 5 | AS-IS Source 라인 번호 누락 또는 부정확 | 향후 fix 시 의도 손실 |
| 6 | i18n LBL KO 만 등록 + EN 누락 | 다국어 EN 사용자 fallback 깨짐 (메모리 `feedback_i18n_ko_en_alignment.md`) |
| 7 | KO ≠ EN 값 (KO "조회" vs EN "Save" 같은 의미 어긋남) | 일관성 깨짐 — KO=EN 정확 동일 의무 |
| 8 | LBL 자유 형식 (`LBL_DMF0020_DIV`) | 메모리 `feedback_i18n_lbl_code_pattern.md` 위반 |
| 9 | 기존 LBL 재사용 시 의미 cross-check 누락 (LBL00026 충돌 사고 DMF0020) | KO.json 의미 grep 후 적용 |
| 10 | 신규 LBL 추가 후 `pnpm gen:i18n` 미실행 | type-check fail (key 미인식) |
| 11 | Modal mount 패턴 임의 변경 (한 화면 안 A/B 혼용) | 사용자 UX 일관성 깨짐 — 화면 단위 동일 패턴 |
| 12 | Modal mount 패턴 결정 사유 미명시 (주석 0) | PR review 시 의도 불명 |
| **13** | ⭐⭐ **BTN_MPG 를 FE `SHEETS` enum 일부 시트만 등록** | **"화면 오픈 즉시 권한없음"** — FE 가 오픈 시 조회하는 보조 시트(dayRange/spreadTitle/titleSet/sqlText 등)가 BTN_MPG 에 없으면 `checkMenuBtnAuth` 가 `HAS_AUTH_YN='N'` 반환. **FE SHEETS enum 의 모든 시트 × 사용 버튼(SEARCH/SAVE…)을 BTN_MPG + USER_GR_MNU_BTN_MPG_M 양쪽에 등록** (2026-07-29 DMF0003 dayRange 사고 — 조회는 되는데 오픈 시 권한없음) |
| **14** | ⭐ **권한 미러링 원본 메뉴를 실측 없이 지정** | 형제 화면이 **권한 0건**이면 미러링 결과도 0행 → 등록은 성공했는데 권한없음. 원본 메뉴의 `USER_GR_MNU_MPG_M` 보유 그룹 수를 **먼저 조회**하고 0 이면 실제 그룹을 가진 동급 메뉴로 교체 (2026-07-29 SYS0017 — SYS0016 원본이 0건이라 SYS0014 로 교체) |
| **15** | ⭐ **재사용 LBL/MSG 의 실제 문구 미확인** | fallback 문구(`'_Add'`)만 보고 기존 키를 재사용하면 엉뚱한 라벨 노출. locales·MSG_M 에서 **실제 값 조회 후 의미 대조 의무** (2026-07-29 SYS0017 — LBL00073='Exfactory Date' 를 'Add' 로 오용) |

---

## 8. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| Screen Completion Gate G1 (`__asis-mapping__.md`) | hook `screen-completion-gate.md` (#46) |
| UI 동적 속성관리 (3 구성: Button/Column/Measure) | hook `ui-dynamic-property-management.md` |
| Button 동적 fetch hook (`useTabBtnPermissions`) | 메모리 `feedback_ui_dynamic_property_management.md` |
| i18n LBL 5자리 표준 | 메모리 `feedback_i18n_lbl_code_pattern.md` |
| KO=EN 동일 값 의무 | 메모리 `feedback_i18n_ko_en_alignment.md` |
| i18n / procedures.d.ts 자동 gen | 메모리 `reference_pnpm_scripts.md` |
| AS-IS .cs 정밀 read 의무 | 메모리 `feedback_new_screen_mandatory.md` + anti-simplification |
| SubTitle 11 공통 버튼 | hook `subtitle-button-actions-mandatory.md` (#64) |
| BTN_CD 표준 키 매핑 | 메모리 `reference_perm_seed_tables.md` |
| `__asis-mapping__.md` 양식 참조 (사용자 정책 — 3 master 에 부재) | (마이그레이션 화면 작성 시 양식 참조용 — DMF0004/0005/0006 master 외 화면들에 분산) |

---

## 9. 검증 — PR 차단 강도

§5 PRE-WRITE 12 + §6 POST-WRITE grep 5 + §7 안티패턴 12 모두 PR 차단.
사용자 cross-check 3 회차 (2026-06-18 "누락 없을 때까지").

---

## 변경 이력

- 2026-07-29: **안티패턴 13~15 추가** — BTN_MPG 전 시트 등록 의무(DMF0003 dayRange 사고) / 권한 미러링 원본 실측(SYS0017) / 재사용 LBL·MSG 실제 문구 확인(SYS0017).
