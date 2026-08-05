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

## Cross-ref
- TO-BE 정밀: `_tobe/10_popup_modal.md` / `_tobe/13_routing_menu.md`
- 라우팅 3-SET: 메모리 `feedback_route_slug_mnu_url_3set`(MENU_ID=폴더명=route-paths=MNU_URL) / `reference_scm_adm_mnu_m_url_slug`
- 공용 모달 인벤토리: 메모리 `reference_public_modals_master_components`(features/master/src/components) / `reference_column_setting_modal_shared`
- 도메인 내 공유 모달 선례: `features/demand/src/components/versionModal/`(DMF0044·0049 공유 — menuId prop 주입식) / `fcst-upload-modal`
- 모달 그리드도 카테고리 01(No.코너)/03(메타 동적 fetch) 적용 — "팝업이라 예외" 없음
