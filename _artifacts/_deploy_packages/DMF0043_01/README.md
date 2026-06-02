# DMF0043_01 — Contribute View 클라우드 이관 패키지

작성: 2026-06-02

---

## 1. 개요

DMF0043_01 (Contribute View — 기여율 조회 화면) + Version Popup (Division 권한 기반 동적 lookup, 2026-06-02 적용) + Column Title Set Modal + Validators + Expressions.

### 1.1 적용 범위

| 영역 | 변경 |
|---|---|
| FE | 신규 화면 `contribute-view` (16 파일 — Grid/Form/2 Modal/Validators/Expressions/Store/Types) |
| DB 메타 | 초기 메타 + KO Name Update + TitleSet Meta |
| SP / PKG | VersionPopup Diagnose 자료 |

### 1.2 2026-06-02 핵심 변경 (최신)

- **ContributeVersionModal Division** 정적 4개 옵션 (`40/10/20/30`) → `useTabComboQueries({ filters: ['MyDivision'] })` 권한 기반 **동적 lookup** (메모리 `reference_public_modals_master_components` + 룰 23 §12.A 패턴)
- SP 호출 실패 시 `DIVISION_FALLBACK` 4개로 fallback

---

## 2. 폴더 구조

```
DMF0043_01/
├── README.md
├── 01_FE/
│   └── contribute-view/                ← 화면 파일 (16 파일)
│       ├── ContributeView.tsx / .module.scss
│       ├── contribute-view.constants.ts
│       ├── useContributeViewStore.ts / types.ts
│       ├── hooks/useContributeViewExpression.ts / useContributeViewValidation.ts
│       └── components/
│           ├── ContributeViewForm.tsx / .module.scss
│           ├── ContributeViewGrid.tsx / .module.scss
│           └── modals/
│               ├── ContributeVersionModal.tsx / .module.scss   ← 2026-06-02 Division 동적 lookup
│               └── ColumnTitleSetModal.tsx / .module.scss
├── 02_DB_Meta_SQL/
│   ├── 42_DMF0043_01_meta.sql                      ← 초기 메타
│   ├── 46_DMF0043_01_KO_Name_Update.sql            ← i18n KO 라벨 보강
│   ├── 46_DMF0043_01_KO_Name_Update_DBeaver.sql
│   ├── 46_DMF0043_01_KO_Name_Update_Verify.sql
│   ├── 46_DMF0043_01_KO_Name_Update_Diagnose.sql
│   ├── 48_DMF0043_01_TitleSet_Meta.sql             ← Column Title Set Modal 메타
│   ├── 48_DMF0043_01_TitleSet_Meta_DBeaver.sql
│   ├── 48_DMF0043_01_TitleSet_Meta_Verify.sql
│   └── 48_DMF0043_01_TitleSet_Meta_Diagnose.sql
├── 03_SP_PKG/
│   └── 47_DMF0043_01_VersionPopup_Diagnose.sql     ← Version Popup SP 진단 (참고용)
└── 04_Verify/                                       ← 메타 SQL 의 Verify 별도 폴더 (위 02 의 _Verify 와 동일)
```

---

## 3. 적용 순서

### Step 1. DB 메타 (02_DB_Meta_SQL/) — 순서 의무

```
1) @42_DMF0043_01_meta.sql
2) @46_DMF0043_01_KO_Name_Update.sql      → i18n KO 라벨 보강 (DBeaver / Verify / Diagnose 3 파일 동봉)
3) @48_DMF0043_01_TitleSet_Meta.sql       → Column Title Set 메타 (Modal 호출용)
```

각 SQL 의 Verify 파일로 사후 카운트 PASS 확인.

### Step 2. FE 파일 배포
```
contribute-view/ → nscm-fe/features/master/src/pages/contribute-view/  (디렉토리 전체)
```

### Step 3. BE 재시작 + 브라우저 검증

1. 메뉴 DMF0043_01 진입
2. SP Version 선택 popup 클릭
3. **Division 콤보** 에 사용자 권한 있는 모든 division 표시 확인 (2026-06-02 fix — minyonglee1 14 division 중 권한 있는 것)
4. Period / Type / Description 입력 + Version 선택 → 메인 grid 조회
5. Column Title Set Modal 동작 확인

---

## 4. 의존성

| 항목 | 위치 |
|---|---|
| As-Is `.cs` | `Doc/_legacy_source/06_UIL/domain_DM/.../DMF0043_Contribute_View/`, `DMF0043_VersionPopup/` |
| To-Be PKG | `PKG_DMF0043` (BODY VALID) — VersionPopup SP 포함 |
| MyDivision SP | `DMF0008_GET_MY_DIVISION_LIST` (BODY VALID) — useTabComboQueries 가 호출 |

---

## 5. 영향 분석

- 메타: 30+ row (i18n + API + PROC + 권한)
- FE: contribute-view 디렉토리 신규 (또는 기존 폴더 교체)
- 다른 화면 영향: 0 (independent)

---

## 6. 변경 이력

- 2026-06-02: 본 패키지 작성 + Version Popup Division 동적 lookup 적용
