# CLAUDE.md — NSCM 룰셋 v2 진입점

> ⭐ **AI 바이브코딩 시 이 파일을 가장 먼저 읽어야 합니다.**

---

## 진입점 정책 (3 파일 1차 로드 — 모든 작업)

```
1. Read: Doc/_rules_v2/anti-simplification.md   ⚠️ ⭐ 최우선 (단순화 절대 금지, 불변)
2. Read: Doc/_rules_v2/CLAUDE.md                ← 분기 라우터 (이 파일)
3. Read: Doc/_rules_v2/00_INDEX.md              ← 트리거 매트릭스 + 룰/Hook 카탈로그
```

→ 위 3 파일만 1차 로드. 도메인별 룰/Hook 은 00_INDEX 의 **트리거 매트릭스** 가 작업 키워드로 자동 분기.

⚠️ **anti-simplification.md** 는 다른 모든 룰을 압도하는 최우선 룰. 속도/편의를 위한 단순화는 절대 금지. 사용자가 "모두/전체/정밀/상세" 요청 시 다중 패턴 + Cross-check 의무.

---

## 핵심 원칙 (3개)

### 원칙 1: "한 사람이 개발한 것처럼"
- 신규 코드는 reference 화면 (DMF0004~7) 패턴과 완전히 동일한 스타일
- 폴더 구조 / import 순서 / 명명 규약 / 주석 헤더 모두 일치
- reference 화면이 표준 baseline

### 원칙 2: "AS-IS 한 줄도 누락 없음"
- AS-IS `.cs / .Designer.cs` 처음 ~ 끝 정밀 read (block 단위 200~500 lines)
- 모든 Event / API / Validation / Expression / Button = TO-BE 에 1:1 매핑
- 누락 1 건 = anti-simplification 위반

### 원칙 3: "공용으로 끌어올리기"
- 화면 작업 중 공용 후보 발견 시 `@master/components/` 또는 `@shared/components/` 로 추가
- 다른 화면에서 재사용 가능 + 중복 작성 방지

---

## 룰 v2 구조

```
Doc/_rules_v2/
├─ anti-simplification.md           ⚠️ 진입점 1
├─ CLAUDE.md                        진입점 2 (이 파일)
├─ 00_INDEX.md                      진입점 3
├─ meta-rule-evolution.md           ⭐ 메타-룰 진화 (PoC → 룰 보강 사이클, 2026-06-04 신규)
├─ _asis/
│  ├─ 00_framework/                 (AS-IS Framework 7 파일 정밀)
│  │  ├─ 01_BaseForm.md             — 6,329 lines / 157 method
│  │  ├─ 02_DataService.md          — 5,261 lines / 87 method
│  │  ├─ 03_MessageHelper.md        — 405 lines (100%) + 23 MSG ID
│  │  ├─ 04_Logging.md              — SCM_SYS_LOG + G3 통합
│  │  ├─ 05_Auth_FormAuth.md        — UserInfoContext + GAppSettings + 보안 의무
│  │  ├─ 06_UsrControls.md          — 36 컨트롤 + ControlValues 표준
│  │  └─ 07_FoxDataClient.md        — WCF→REST 매핑
│  ├─ 01_popups/                    (AS-IS Popup 592 → Top 30 정밀)
│  │  ├─ __POPUP_TEMPLATE__.md
│  │  ├─ 00_inventory.md            — 분류 + SCM0002 38 + DM 30
│  │  └─ {popup-name}.md            (Phase 2 다음 — Top 30 deep-dive)
│  └─ 02_screens/                   (per-screen — Phase 5 lazy)
│     ├─ __TEMPLATE__.md            — 13 category 정밀
│     └─ {MENU_ID}/__analysis__.md
├─ _tobe/                           (TO-BE 13 룰)
│  ├─ __TEMPLATE__.md
│  ├─ 01_file_structure.md
│  ├─ 02_imports.md
│  ├─ 03_main_component.md
│  ├─ 04_store.md
│  ├─ 05_constants.md
│  ├─ 06_search_area.md
│  ├─ 07_datagrid.md
│  ├─ 08_column_meta.md
│  ├─ 09_subtitle_hotkey.md
│  ├─ 10_popup_modal.md
│  ├─ 11_be_controller_service.md
│  ├─ 12_metadata_sql.md
│  └─ 13_routing_menu.md
├─ _mapping/
│  └─ asis_to_tobe.md               (AS-IS↔TO-BE + 10 격차 사양)
└─ hooks/                           (41 hook — 전체 목록은 00_INDEX.md §B.3 카탈로그가 단일 진실 source)
   ├─ pre-write.md / post-write.md / pre-submit.md     (공통 3)
   ├─ oracle-db-workflow.md         ⭐⭐ Oracle SP/DB 작업 단일 진입점 (T08/T10/T18/T19, 2026-06-11)
   ├─ screen-completion-gate.md     ⭐⭐ UI 화면 완성도 8 게이트 (T01/T20, 2026-06-11)
   └─ (나머지 36 — 00_INDEX §A 트리거 매트릭스가 작업 키워드로 자동 분기)
```

---

## 격차 (AS-IS 에 있으나 TO-BE 미구현) 인벤토리

> 상세는 `_mapping/asis_to_tobe.md` 참조.

| # | 격차 | 결정 | Phase |
|---|---|---|---|
| G1 | 검색조건 저장/복원 (F6/F10) | ✅ 신규 구현 (POST/DELETE only — GET 이미 구현) | Phase 5 ⭐ |
| G2 | BigFilter 캐싱 (DM 1 round-trip) | ✅ 신규 구현 | Phase 5 ⭐ |
| G3 | PerfLog (성능 + 메뉴 open/close + 화면 실행) | ✅ 신규 구현 | Phase 5 |
| G4 | Batch 처리 (대량 row) | ✅ 신규 구현 | Phase 5 |
| G5 | File transfer (FP_DataPull/Push) | ✅ 신규 구현 | Phase 5+ |
| G6 | YesNoCancel confirm 3옵션 | ✅ 신규 구현 | Phase 5 |
| G7 | Impersonation (admin 대리) | ❌ 격차 유지 (사용 빈도 0) | (없음) |
| G8 | UsrColumnCombo (multi-column) | ❌ 격차 유지 | (없음) |
| G9 | DateRangePicker | ✅ 신규 구현 | Phase 5 |
| G10 | MonthPicker / MonthRangePicker | ✅ 신규 구현 | Phase 5 |

> **신규 구현 8 격차 (G1~G6 + G9 + G10)**: Phase 5 진행. PoC (Phase 6, DMF0015) 의 success criterion.

---

## 보안 의무 (TO-BE 이관 시 절대 금지)

> Phase 1 발견 — `_asis/00_framework/05_Auth_FormAuth.md` §3.2

⛔ **AS-IS `GSCM/01.Framework/GSCM.App.Core/GAppSettings.cs` 의 hardcoded 값 절대 TO-BE 이관 금지**:
- AES 키 (`AESKey` / `AESVector`)
- DB connection string (`saveSCPPath_dev` / `_prd` — uid + pwd 포함)

**TO-BE 의무**:
- Jasypt + Vault / AWS Secrets Manager / 환경변수
- `config-local.yml` (gitignore) + Spring profile
- `.gitignore` 강화 (`*.key` / `*.pem` / `_artifacts/grant_*.sql` / `.figma_token`)

---

## 진행 상태 (2026-06-03)

| Phase | 상태 | 산출물 |
|---|---|---|
| Phase 0 | ✅ 완료 | 폴더 골격 + 3 템플릿 + INDEX/CLAUDE skeleton |
| Phase 1 | ✅ 완료 | AS-IS Framework 7 정밀 분석 + 10 격차 식별 |
| Phase 2 | ✅ 완료 | AS-IS Popup 592 분류 + 핵심 매핑 + Top 10 식별 |
| Phase 3 | ✅ 완료 | TO-BE 13 룰 정밀 추출 (~4,200 lines) |
| Phase 4 | 🔵 진행 중 | 룰셋 v2 마무리 + hooks + 기존 31 룰 archive |
| Phase 5 | ✅ 완료 (1차) | 8 격차 신규 구현 (G1/G2/G3/G4/G6/G9/G10) — G5 pending / G3 BE AOP pending |
| Phase 6 | ✅ PASS | PoC DMF0015 — 보완사항 10 (PASS) |
| Phase 7 | ✅ 완료 | 2 차 PoC (DMF0008) + 4 reference 화면 cascade cross-check + 룰 07 §2.10 7 sub-pattern 정형화 + meta-rule-evolution.md |

---

## 참고: 룰 v1 (`Doc/_dev_rules/`)

> Phase 4 종료 후 일부 archive. 유지되는 룰 (Phase 4 결정):

| 유지 | 사유 |
|---|---|
| `02_DEVELOPMENT_RULES.md` | 브랜치/커밋/PR/리뷰 표준 |
| `21_TROUBLESHOOTING.md` | Oracle/DBeaver/Wijmo/PowerShell 종합 |
| `28_GIT_MULTI_REMOTE.md` | NSCM 모노레포 + GitHub + GitLab |
| `29_LOCAL_DB_CSV_IMPORT.md` | Docker Oracle CSV 적재 |
| `30_LOCAL_BACKUP_RESTORE.md` | 백업/원복 표준 |
| `31_FIGMA_DESIGN_INTEGRATION.md` | Figma → React 매핑 |
| `hooks/anti-simplification.md` | (`_rules_v2/anti-simplification.md` 로 복사 완료) |

→ 나머지 25 룰은 `Doc/_dev_rules/_archive/` 이동 예정.

> ⭐ **2026-06-11 `Doc/_dev_rules/hooks/` 정리**: 유니크 6종 (oracle-cmbo-varname-quote / db-error-asis-cross-check / deploy-package-completeness / screen-entry-asis-baseline / wijmo-merge-sticky-content / popup-dialog-layout) → `_rules_v2/hooks/` 이관 (원본은 포인터 스텁). 중복 10종 DEPRECATED. 상세: `Doc/_dev_rules/hooks/README.md`.

---

> Plan 파일: `C:\Users\ejene\.claude\plans\effervescent-beaming-donut.md`
