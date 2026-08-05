# 카테고리 02 — 권한·Edit 제어 / Auth & Edit Control

> **연다: 언제?** 버튼 권한(hasButton)/편집 가능 범위(EDIT_YN·EDIT_FLAG·editLock)/그룹별 차단을 다룰 때.
> **핵심 지식**: AS-IS 권한 게이트는 3형(버튼 미표시 / 메시지 후 return / 컨트롤 잠금) — 메시지 grep 만으로 "권한 없음" 단정 금지 (asis-coverage-check §0.5).

| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 50 | [screen-meta-and-permissions-mandatory](../hooks/screen-meta-and-permissions-mandatory.md) | ⭐⭐⭐ | `useTabBtnPermissions`+`hasButton(BTN_CD)` 각 액션 + `__asis-mapping__` 권한 매핑 절 의무 |
| 66 | [ui-dynamic-property-management](../hooks/ui-dynamic-property-management.md) | ⭐⭐ | **master** — Menu Button/Column/Measure 3요소 admin 기반 동적 fetch + 즉시 반영 (누락=admin 결정 무효화) |
| 24 | [menu-button-dynamic-fetch](../hooks/menu-button-dynamic-fetch.md) | ⭐⭐ | 버튼 Visible/Enable = SYS0009 매핑 동적 fetch (child) |
| 2 | [asis-coverage-check](../hooks/asis-coverage-check.md) §0.5 | ⭐⭐ | 권한 게이트 3형 전수 탐지: `NowGroupID` switch 전수 grep + 호출 팝업 별도 파일 확인. "범위 밖"≠"부재" |
| 89 | [screen-grid-edit-merge-and-meta-mandatory](../hooks/screen-grid-edit-merge-and-meta-mandatory.md) §E | ⭐⭐⭐ | 컬럼 편집범위=`INPUT_TP_CD`('IM'/'M') 메타 + 조건부 행잠금=`beginningEdit` |
| 70 | [screen-runtime-pitfalls-mandatory](../hooks/screen-runtime-pitfalls-mandatory.md) | ⭐⭐⭐ | 동적 컬럼 EDIT_FLAG='N' 환경 편집 의도 = `beginningEdit` 마지막 override(`e.cancel=false`) |
| 97 | [common-button-grid-routing](../hooks/common-button-grid-routing.md) | ⭐⭐ | 공통버튼 표시=hotkeyConfig 만(SubTitle 권한 비gating) + INSERT/DELETE 활성그리드 라우팅 |
| 63 | [subtitle-button-actions-mandatory](../hooks/subtitle-button-actions-mandatory.md) | ⭐⭐⭐ | SubTitle 11버튼 = hotkeyConfig 1객체 자동 매핑 (hasButton 게이트 포함) |
| 82 | [feature-button-meta-completeness](../hooks/feature-button-meta-completeness.md) | ⭐ | FE handler 있는데 버튼 미표시 = 버튼 메타(BTN_MPG) 등록 누락 점검 |

## Cross-ref
- 권한 2 테이블: `SCM_ADM_USER_GR_MNU_BTN_MPG_M`(시트 단위) + `SCM_ADM_USER_GR_BTN_MPG_M` — 메모리 `reference_scm_adm_user_gr_btn_mpg_m`
- ⚠️ `useTabBtnPermissions` 는 **메뉴 단위 평면화** — 같은 BTN_CD 가 메인/팝업 시트에 공존 시 시트별 대조 (asis-coverage-check §0.5)
- 편집 권한 EDIT_YN 원천: `SCM_ADM_USER_MNU_EDIT_AUTH_V` (GET SP JOIN — P_USER_ID/P_MNU_ID 전달)
- 메모리: `feedback_asis_button_mapping_mandatory` / `feedback_sht_nm_incomplete_migration_auth`(SHT_NM 불완전 이관→권한없음)
