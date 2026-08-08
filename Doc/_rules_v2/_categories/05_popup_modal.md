# 카테고리 05 — 팝업·모달·라우팅 / Popup, Modal & Routing

> **연다: 언제?** 공용/화면 전용 모달 작성, 모달→부모 값 전달, Router·메뉴 등록을 다룰 때.

| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 35 | [popup-modal-and-routing-mandatory](../hooks/popup-modal-and-routing-mandatory.md) | ⭐⭐⭐ | 공용 popup 표준: **camelCase 폴더 + 5파일 + MODAL_XXX(실제 MENU_ID)** + Router 4 cross-check(DB/route-paths/Router.tsx/폴더) |
| 33 | [popup-asis-analysis](../hooks/popup-asis-analysis.md) | ⭐ | Popup 9 카테고리 .cs deep read (AS-IS 정밀 분석) |
| 34 | [popup-dialog-layout](../hooks/popup-dialog-layout.md) | ⭐ | CustomDialog 잘림·중앙 미표시 방지 |
| 27 | [modal-callback-cascade-check](../hooks/modal-callback-cascade-check.md) | ⭐ | modal callback → 부모 cascade 전파 점검 |
| 20 | [grid-column-setting-popup-pattern](../hooks/grid-column-setting-popup-pattern.md) | ⭐⭐ | Column 표시설정 popup 5단계 + 재진입 복원 |
| 26 | [messaging-api-and-search-fields-mandatory](../hooks/messaging-api-and-search-fields-mandatory.md) | ⭐⭐⭐ | CustomDialog 7 size 표준 (+ useMessageStore — alert/confirm 직접 window.* 금지) |
| 123 | [screen-modal-cascade-filter-analysis](../hooks/screen-modal-cascade-filter-analysis.md) §1 | ⭐⭐⭐ | 신규 화면 내 Modal = **AS-IS 팝업 .cs 기능분석 선행 후 구현** (게이트/SP 바인딩/저장 후처리/MSG — Cutoff·Replace SP 오배선 사고 계보) |
| 70 | [screen-runtime-pitfalls-mandatory](../hooks/screen-runtime-pitfalls-mandatory.md) §8-C | ⭐⭐⭐ | **P9 상호배타 prop 함정** — `CustomDialog customContentArea` 지정 = 공통 OK/Cancel footer **미렌더** → 자체 footer 구현 의무(정본 forecast-price ExchangeRateModal) + §8C.4 함정 확장 표 + G6-1 모달 전수 런타임 확인 (2026-08-06 SYS0017 감사) |
| 124 | [screen-asis-pre-analysis-mandatory](../hooks/screen-asis-pre-analysis-mandatory.md) §2 | ⭐⭐⭐ | ⭐ **각 모달 = MAIN UI 와 동일한 4영역(디자인·VALIDATION·EVENT·CRUD) 분석·점검 단위** — CRUD 매트릭스 행 체크만으로 완료 금지, `MODAL:` 행에 모달별 근거 링크 + G6-6 CRUD 왕복 (주 소속 11 — 01·05 공유, 2026-08-07) |
| 125 | [ui-selfcheck-runtime-mandatory](../hooks/ui-selfcheck-runtime-mandatory.md) §4 | ⭐⭐⭐ | **모달 = MAIN UI 동등 실행 검증** — MODAL 행마다 [AS-IS 기능 대사·디자인·R·CUD 왕복·권한] 5칸 실증(빈 칸=미완료) + 모달 시트 API 전수 호출 — '형태만 모달' 차단 (주 소속 12, 2026-08-07) |

## Cross-ref
- TO-BE 정밀: `_tobe/10_popup_modal.md` / `_tobe/13_routing_menu.md`
- 라우팅 3-SET: 메모리 `feedback_route_slug_mnu_url_3set`(MENU_ID=폴더명=route-paths=MNU_URL) / `reference_scm_adm_mnu_m_url_slug`
- 공용 모달 인벤토리: 메모리 `reference_public_modals_master_components`(features/master/src/components) / `reference_column_setting_modal_shared`
- 도메인 내 공유 모달 선례: `features/demand/src/components/versionModal/`(DMF0044·0049 공유 — menuId prop 주입식) / `fcst-upload-modal`
- 모달 그리드도 카테고리 01(No.코너)/03(메타 동적 fetch) 적용 — "팝업이라 예외" 없음
