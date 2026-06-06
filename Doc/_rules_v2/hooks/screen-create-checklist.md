# Hook — screen-create-checklist (신규 화면 생성 강제 체크리스트)

> **트리거**: 키워드 "신규 화면 / 화면 추가 / DMFXXXX 만들어 / 화면 생성" 감지 시
>
> **목적**: 6종 자료 + 13 룰 적용 + 격차 신규 구현 사양 모두 확인

---

## §0 6 종 자료 (Phase 4 — 기존 5 종 + AS-IS Framework 인덱스 추가)

| # | 자료 | 위치 | 의무 |
|---|---|---|---|
| 1 | AS-IS `.cs` + `.Designer.cs` | `GSCM/06.UIL/...` | 처음~끝 전체 read (block 단위) |
| 2 | xlsx 12 시트 | `_analysis/_screens/{27|28|29|30|31|32}_*/{prefix}{MENU_ID}.xlsx` | 모든 시트 30+ filled cells |
| 3 | 8 MD 폴더 | `_analysis/domain_{X}/screens/{MENU_ID}/` | analysis / events / api / validation / expressions / dropdowns / popups / mapping 8 MD |
| 4 | 룰셋 v2 진입점 3 파일 | `Doc/_rules_v2/{anti-simplification, CLAUDE.md, 00_INDEX.md}` | 모두 read |
| 5 | Figma 디자인본 (있으면) | `Doc/_figma/screens/{MENU_ID}.md` | 룰 31 §6.1 매핑 cross-check |
| 6 | **🆕 AS-IS Framework 인덱스** | `_rules_v2/_asis/00_framework/01_BaseForm.md` 외 6 | BaseForm override 가능 메서드 / DataService 호출 패턴 / MessageHelper MSG ID / UsrControls / Logging / Auth / FoxDataClient — 모두 cross-ref |

---

## §1 강제 체크리스트 (작성 전)

### §1.1 13 룰 적용 확인

- [ ] **01 file_structure**: 폴더명 = kebab-case, `index.ts` 한 줄 export, `components/` (typo 오타 금지)
- [ ] **02 imports**: alias 사용 + 정확 export 인벤토리 cross-check (`@shared/lges` 의 없는 것 확인)
- [ ] **03 main_component**: 7 단계 구조 + hotkeyConfig manual/upload 명시
- [ ] **04 store**: `createPersistedStoreWithTab` + G1 GET 의무 (fetchStaticColumns 안의 search-conditions GET)
- [ ] **05 constants**: MENU_ID/SHEETS/RESPONSE_SET + LBL 자유 형식 금지
- [ ] **06 search_area**: SearchArea + FormItem + CustomDropdown + 카탈로그 13 종 + lookup SQL_ID 등록 확인
- [ ] **07 datagrid**: DataGrid wrapper + EditTracker + dblClick handler + CRUD_TYPE 가드
- [ ] **08 column_meta**: `_inputEditType` / `_ctrlType` / `_modalKey` 모든 column 명시
- [ ] **09 subtitle_hotkey**: 10 키 매핑 (CRUD 6 + Aux 4) + AS-IS .cs 의 button override cross-check
- [ ] **10 popup_modal**: 공용 11 종 인벤토리 cross-check + 신규 modal 신중 결정
- [ ] **11 be_controller_service**: Spring Boot 표준 + 보안 의무 (secret hardcoding 금지)
- [ ] **12 metadata_sql**: 7-BLOCK 메타 + 멱등 INSERT + MSSQL→Oracle 변환 + 4 파일 세트
- [ ] **13 routing_menu**: MNU_URL slug + ROUTE_PATHS 일치 + UPPR_MNU_ID PascalCase + SHT_NM 'main'

### §1.2 AS-IS Framework cross-ref (6 인덱스 의무 read)

- [ ] `_asis/00_framework/01_BaseForm.md` — BaseForm CRUD 6대 + Aux 4대 + 권한 + 검색조건 + spread 초기 설정
- [ ] `_asis/00_framework/02_DataService.md` — SP 호출 4 시스템 + BigFilter + Dynamic column
- [ ] `_asis/00_framework/03_MessageHelper.md` — Type 4종 / Button 7종 + MSG ID 사용 패턴
- [ ] `_asis/00_framework/04_Logging.md` — SCM_SYS_LOG + G3 통합 사양
- [ ] `_asis/00_framework/05_Auth_FormAuth.md` — UserInfoContext + GAppSettings 보안 의무
- [ ] `_asis/00_framework/06_UsrControls.md` — UsrCombo/UsrCheckedList ControlValues 표준
- [ ] `_asis/00_framework/07_FoxDataClient.md` — WCF→REST 매핑

---

## §2 강제 자동 생성 자료 (신규 화면 작성 직후)

- [ ] **AS-IS 분석 MD**: `_rules_v2/_asis/02_screens/{MENU_ID}/__analysis__.md` (13 category 100% — 템플릿 `__TEMPLATE__.md`)
- [ ] **__asis-mapping__.md**: 4축 매핑 (Event / API / Validation / Expression / Button)
- [ ] **POPUP 자동 생성 5종** (메모리 룰): 호출 모든 popup 의 신규 modal 작성 (공용 11 외 신규 필요 시)
- [ ] **메타 SQL 4 파일 세트**: `_artifacts/{N}_{MENU_ID}_metadata*.sql`
- [ ] **Deploy 패키지**: `_artifacts/{N}_{MENU_ID}_deploy/` (SP body + 메타 SQL + FE 파일 인벤토리 + BE 파일 인벤토리)

---

## §3 진입 트리거 (사용자 키워드)

| 키워드 | 동작 |
|---|---|
| "신규 화면 / 화면 추가 / 화면 만들어 / 화면 생성" | 이 hook 즉시 적용 |
| "DMF00xx 만들어 / 작업해" | 동일 |
| "POPUP / 모달 추가" | 룰 10 §3 (신규 modal 작성) 추가 적용 |
| "BE / Controller / Service 추가" | 룰 11 추가 적용 |

→ 메모리 `feedback_new_screen_mandatory.md` 와 동기.

---

## §4 위반 처리

- 6 종 자료 1 건이라도 누락 → **anti-simplification 위반** → 작업 중단 + 사용자 보고
- 13 룰 1 건이라도 위반 → 즉시 fix
- 격차 사양 (G1~G10) 적용 안 함 → Phase 5 작업 우선 권장

---

## §5 적용 룰 cross-ref

| 항목 | 룰 |
|---|---|
| 13 _tobe 룰 | `_tobe/01~13.md` |
| 7 AS-IS framework | `_asis/00_framework/01~07.md` |
| 격차 신규 구현 | `_mapping/asis_to_tobe.md` §2~§6 (G1~G6/G9/G10) |
| 메모리 트리거 | `feedback_new_screen_mandatory.md` |
