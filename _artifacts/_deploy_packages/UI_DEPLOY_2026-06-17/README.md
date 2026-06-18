# UI_DEPLOY_2026-06-17 — 4 화면 클라우드 이관 패키지

> 작성: 2026-06-17 — DMF0008 / DMF0072 / DMF0043 / DMF0043_01 4 화면 UI 동적 속성관리 + UI 보완 + SP body patch 통합.

---

## 폴더 구조

```
UI_DEPLOY_2026-06-17/
├── README.md  (이 파일)
├── DMF0008/         (ERP EDI Master)
├── DMF0072/         (NN Master Mapping)
├── DMF0043/         (Contribute Main)
└── DMF0043_01/      (Contribute View)
```

각 화면 폴더 표준 sub-folder:

```
{MENU_ID}/
├── README.md                (적용 순서 + 검증 절차)
├── 01_FE/                   변경된 FE 파일 (TypeScript/SCSS)
│   └── {feature-folder}/
├── 01_SP_BODY/              SP body 재컴파일 SQL (DMF0008 만)
├── 03_META/                 메타 등록 SQL (BTN_MPG / API_M / PROC_M / SHEET_COLUMNS)
├── 04_GRANT_SYNONYM/        SCMD_APP 권한 + SYNONYM (DMF0008 만)
└── 05_VERIFY/               진단/검증 SQL
```

## 화면별 핵심 변경

| 화면 | 핵심 변경 |
|---|---|
| **DMF0008** | Menu Button 동적화 + Status Update URL fix + UpdateHistory silent fail + 3:3:4 비율 + Division 기본 81 + Repair tooltip + SP body END 로그 patch + 메타 chain 전체 재 sync |
| **DMF0072** | Menu Button 동적화 + monolithic 분리 (Grid/Modals sub-component) + staticColumns + cell merge + scroll bar 정상 |
| **DMF0043** | Menu Button 동적화 + customButtons 항상 노출 + staticColumns + viewport sticky cell merge + PIVOT NVL 회귀 |
| **DMF0043_01** | Menu Button 동적화 + ColumnSettingModal fallbackColumns visible flag (popup 재진입 복원) + 동적 컬럼 제외 + 돋보기 popup 버튼 + 공용 ColumnSettingModal 의 visible 필드 |

## 적용 순서 (화면 간 독립 — 어느 화면부터 시작해도 무방)

각 화면 폴더의 README.md 의 적용 순서 그대로 수행.

## PRE-DEPLOY 5 인벤토리 (메모리 `feedback_deploy_package_completeness.md`)

- ✅ FE 변경 파일 (변경된 것 만)
- ✅ 메타 SQL (BTN_MPG / API_M / PROC_M / SHEET_COLUMNS / USER_GR)
- ✅ SP body patch (DMF0008 의 END 로그 fix)
- ✅ GRANT/SYNONYM (SCMD_APP — DMF0008)
- ✅ 검증 SQL + diagnose

## 사용자 사내 적용 시 참고

- **BE 재기동 의무** — 메타 변경 후 BE 캐시 무효화 (Spring boot 메모리 caching)
- 적용 후 브라우저 강력 새로고침 (Ctrl+Shift+R) — FE/BE 캐시 무효화
- 시크릿 창 안내 금지 (메모리 `feedback_no_incognito_window_guide.md`) — DevTools `localStorage.clear(); sessionStorage.clear(); location.reload(true)`

## 관련 룰

- `Doc/_dev_rules/22_PACKAGE_ARTIFACTS.md` — 이관 패키지 표준
- `Doc/_rules_v2/hooks/oracle-db-workflow.md` — Oracle SP/DB 작업 진입점
- `Doc/_rules_v2/hooks/ui-dynamic-property-management.md` — UI 동적 속성관리 (Menu Button + Column + Measure)
- `Doc/_rules_v2/hooks/grid-column-setting-popup-pattern.md` — DMF0043_01 master 패턴
- 메모리 `feedback_scmd_app_grant_mandatory.md` — SCMD_APP GRANT/SYNONYM 의무
- 메모리 `feedback_barrel_export_no_full_replace.md` — barrel re-export 통째 교체 금지
