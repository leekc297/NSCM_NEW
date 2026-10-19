# hook #150 DEPT_ID 원천 변경 — 건수 대사 결과 (AJS, 2026-09-06)

- BEFORE: 2026-09-06 01:34 실측 (적용 전) / AFTER: 09:34 실측 (적용 후) — 동일 하네스·동일 파라미터 (`90_VERIFY/`)
- 배포: 10 객체 08:33~08:35, 전부 VALID · USER_ERRORS 0 · 신규 INVALID 0

## 1. SP 호출 대사 — 77 커서 중 **75 동일 / 2 상이**
| SP | 40 | 81 | 82 |
|---|---|---|---|
| DMF0020_GET_SCM_MST_FUTURE_PRICE (standalone) | 8,652 = | 9,956 = | 10,520 = |
| DMF0020_…_SAVE_PRICE_POPUP (standalone) | (제외: GT_PJT 적재 >10분) | 2,454 = | **38,659 → 38,672 (+13)** |
| PKG_DMF0020.GET_SALES_PRICE_TEMPLATE | 0 = | 121 = | 107 = |
| PKG_DMF0020.GET_OWNER_DATA | 0 = (블록 대조: V_TMPDEPT 13=13) | 0 = (108→109 상위집합) | 0 = (62=62) |
| PKG_DMF0020.GET_SCM_MST_FUTURE_PRICE | 8,652 = | 9,956 = | 10,520 = |
| PKG_DMF0020.…_SAVE_PRICE_POPUP | 2,152 = | 2,454 = | **38,659 → 38,672 (+13)** |
| PKG_DMF0022.GET_DM_PLN_SALES_PLAN_WATERFALL | 1,679 = | 1,156 = | 736 = |
| PKG_DMF0035.GET_MKT_FCST_WATERFALL | 370 = | 517 = | 199 = |
| PKG_DMF0040.GET_MKT_FCST_COMPARISON | (300s 초과, 전/후 동일 증상) | 394 = | 476 = |
| PKG_DMF0051.GET_DM_PLN_BIZ_PLAN_WATERFALL | 13,076 = | 0 = | 0 = |
| PKG_DMF0074.GET_METAL_LINK_PRICE | 0 = | 4,390 = | 480 = |
| PKG_DMF0074.GET_METAL_LINK_TEMPLATE | 342 = | 145 = | 74 = |
| PKG_DMF0082.GET_MAIN_DATA / _CURRENT | 전/후 모두 `ORA-00904 SORT_KEY` (기존 결함) | 〃 | 〃 |
| PKG_DMF0082.POPUP_…_SAVE_PRICE_POPUP | 2,220 = | 2,454 = | (전 0 / 후 300s 초과) |

(=) 행수 동일. 결과 해시 `=` 인 커서는 값까지 동일, `≠` 는 DEPT_ID 값만 변한 커서(행수 동일).

### +13 (division 82 POPUP) 원인
최종 동적 SQL 이 `GT_DMF0020_SALES_SITE_MODEL A LEFT JOIN GT_DMF0020_OUTPUT B ON … AND a.dept_id = b.dept_id` + `UNION` 구조.
변경 전 A 측 DEPT = `SCM_MST_SITE.DEPT_ID`(site), B 측 DEPT = site → 한 site 의 모든 행이 같은 DEPT 로 묶임.
변경 후 양측 모두 SITE_ITEM 의 **아이템별 DEPT** → 같은 SITE/PROJECT 안에서 부서가 갈리는 아이템(82: SITE_PROJECT 키 101개가 2개 이상 부서)이 부서별로 분리되어 UNION 결과 13행 증가. 사용자 확정 정책 "다건 그대로 반환" 의 직접 결과.

### DEPT_ID 값 변화 (행수 동일 커서)
| 커서 | before (distinct/null) | after | 설명 |
|---|---|---|---|
| POPUP 81 (3본) | 13 / **122 NULL** | 29 / 2 NULL | site 부서가 유효 DEPT_INFO 에 없던 122행이 아이템 부서로 복원 |
| POPUP 82 (2본) | 25 / 0 NULL | 63 / **3,063 NULL** | `SCM_MST_SITE_ITEM.DEPT_ID` 가 NULL 인 아이템(82 division 4,015건 — OWNER 첫 토큰이 SSO_USER_INFO 에 없음)은 이제 NULL. 종전엔 (대부분 무효인) site 부서가 채워져 있었음 |
| POPUP 40 | 12 / 0 | 12 / 0 | 행수·분포 동일, 해시만 상이(정렬/부수 컬럼) |

## 2. SAVE / UPLOAD — 블록 SQL 대조 (실행 불가 SP)
| 지점 | old | new | 판정 |
|---|---|---|---|
| PKG_DMF0044 8588 (SALES_PLAN_VERSION_COPY, OWNER 체인 INNER) | div별 15,565 / 45,459 / 35,557 | 동일 | = |
| PKG_DMF0044 3084 (BIZ_PLAN_VERSION_COPY div40 스칼라 4) | 23,199 | 23,199 동일값 | = |
| PKG_DMF0044 8718 (81분기 `'MDF_DEPARTMENT'‖div` INNER) | 0 | 0 | = (룩업 타입 부재 — 기존 사각) |
| PKG_DMF0044 8825 (82분기 site부서∈DEPT_INFO INNER) | 38,621 | **35,557** | 변화 — item DEPT NULL 3,064행 분기1 이탈 |
| PKG_DMF0082 5066 (EXCEL_UPLOAD END_CUSTOMER 후보) | 40 875 / 81 333 / 82 1,297 | 875 / **340** / **1,375** | 상위집합 — 단일 OWNER 행만 통과하던 결함 해소 |
| PKG_DMF0020 3800 (OWNER_DATA V_TMPDEPT) | 13 / 108 / 62 | 13 / **109** / 62 | 상위집합 — `A.OWNER = B.USER_ID` 전문자열 비교 결함 해소 |
| PKG_DMF0082 844·7407 / PKG_DMF0040 (TEAM OWNER 체인) | — | — | 데이터 증명: OWNER 첫 토큰 DEPT == SITE_ITEM.DEPT_ID 117,948 전행 일치 → 무손실 |

## 3. 적용 중 확인된 기존 결함 (변경과 무관 — 별도 조치 필요)
1. `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA` / `_CURRENT`: `ORA-00904 "SORT_KEY"` (적용 전부터 실패)
2. `PKG_DMF0044` 8718 분기: `'MDF_DEPARTMENT' || p_division_id` → `MDF_DEPARTMENT81` 룩업 타입 없음(실존 `MDF_DEPARTMENT_81`) → 항상 0행
3. `PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON|40`: 300초 초과
4. standalone `DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP|40`: `GT_DMF0020_PJT` 적재 >10분 (PKG 버전 6초 — standalone 은 구버전 잔재)

## 4. 잔여 (컬럼 삭제 전 필수)
목록 밖 `SCM_MST_SITE.DEPT_ID` 사용 의심 19 객체 — `00_TARGET_LIST.md` §E / 메모리 `project_dept_id_rule150_applied_ajs` 참조. 특히 `PKG_DMF0004`(INSERT/UPDATE SCM_MST_SITE) · `DMF0008_SAVE_SALES_SITE_EDI_REPAIR`(MERGE) 는 컬럼 삭제 시 컴파일 INVALID.
