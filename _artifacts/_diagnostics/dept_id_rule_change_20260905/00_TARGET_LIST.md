# DEPT_ID 추출 기준 변경 (hook #150) — 변경 대상 추출 원장

- 실측 일자: 2026-09-05 / DB: 175.211.29.206:2521/AJS (SCM_MGR)
- 판정 기준: **주석 제거본(LIVE)** 만 (hook #138). 동적 SQL 문자열 안의 `--` 는 실행 시 주석이므로 동일 취급.
- 범례: ① `SCM_MST_SITE.DEPT_ID` 직접 / ③ `SCM_MST_SITE_ITEM.OWNER`→`SCM_MST_SSO_USER_INFO.USER_ID`→`DEPT_ID` / ② (`SCM_MST_SITE.OWNER`) 는 컬럼 부재로 **0건**
- 상태: `대상` = 보완 필요 / `검토` = 룰 §3 다건 정책·증식 관점 판단 필요 / `✅` = 이미 TO-BE / `—` = 룰 범위 밖

## A. 변경 대상 — 10 객체 / 34 지점

| # | 객체 | 라인 | 패턴 | 내용 (DEPT_ID 가 흘러가는 곳) |
|--:|---|---|:--:|---|
| 1 | DMF0020_GET_SCM_MST_FUTURE_PRICE | 697-709 | ③ | `PJT` 서브쿼리 `SU.DEPT_ID` (SI.OWNER 첫 토큰) → 660 출력 DEPT_ID · 679 AUTHORITY_YN · 736 P_DEPT_ID 필터 |
| 2 | 〃 | 1044-1048 | ③ | `TEAM` (SITE_ITEM.OWNER 첫 토큰) → 1018 SELECT · 1076 P_DEPT_ID 필터 |
| 3 | 〃 | 649-655 | 검토 | `NEW_DEPT_ID_TBL` = SITE⋈SITE_ITEM(DIV+SITE) `MAX(T2.DEPT_ID)` → UPPER_DEPT_ID 산출. 원천은 TO-BE 이나 **MAX 대표축약**(§3) |
| 4 | DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | 292-309 | ③ | `GT_DMF0020_PJT` div40 분기 `SU.DEPT_ID` (FN_String_Split 첫 토큰) → 322/347/440/447 |
| 5 | 〃 | 370 | ① | `C.DEPT_ID = TEAM.DEPT_ID` (C=SCM_MST_SITE SALES) → 322/347 DEPT_ID(비40)·UPPER_DEPT_ID |
| 6 | 〃 | 752 | ① | `SITE.DEPT_ID = TEAM.DEPT_ID` → 718 · 838 |
| 7 | PKG_DMF0020 | 2729 + 2782-2792 | ③ | `TEAM.DEPT_ID` 출력 (SI.OWNER 첫 토큰). ⚠ 같은 블록 2765 `DI ON IM.DEPT_ID`(TO-BE) 가 **DIV+SITE 만으로 INNER JOIN** → 증식 검토 |
| 8 | 〃 | 2805 + 2858-2868 | ③ | #7 미러 블록 (2841 IM 증식 동일) |
| 9 | 〃 | 3800-3836 | ③ | `V_TMPDEPT` 부서 후보 3 쿼리(40/82 · 81 · 81 PM_TEAM_MAPPING) `A.OWNER = B.USER_ID` |
| 10 | 〃 | 5285-5297 | ③ | #1 미러 (PJT SU via SI.OWNER) → 5248 · 5330 |
| 11 | 〃 | 5237-5243 | 검토 | #3 미러 (NEW_DEPT_ID_TBL MAX) |
| 12 | 〃 | 5633-5637 | ③ | #2 미러 (TEAM via SITE_ITEM.OWNER) → 5607 · 5664 필터 |
| 13 | 〃 | 8005-8022 | ③ | #4 미러 (GT_DMF0020_PJT div40) → 8035/8060/8153/8160 |
| 14 | 〃 | 8083 | ① | #5 미러 `C.DEPT_ID = TEAM.DEPT_ID` → 8035/8060/8153/8160/8191 |
| 15 | 〃 | 8473 | ① | #6 미러 `SITE.DEPT_ID = TEAM.DEPT_ID` → 8433 · 8559 |
| 16 | PKG_DMF0022 | 1802-1803 | ③ | `GT_DM22_SCM_MST_SITE_ITEM.DEPT_ID` 스칼라 (UF_FX_STRING_SPLIT 첫 토큰) |
| 17 | PKG_DMF0035 | 2247-2249 | ③ | `GT_DM35_TEMP_SCM_MST_SITE_ITEM.DEPT_ID` 스칼라 (#16 동형) |
| 18 | PKG_DMF0040 | 1307 + 1336-1347 | ③ | 동적 SQL `q'[…]'`: `E.USER_ID`(OWNER 첫 토큰) → `TEAM`(1194/1196 출력 · 1256 EDIT_FLAG · 1370 P_TEAM_ID 필터) + `J/K` (E.OWNER → K.DEPT_ID/K.NAME) |
| 19 | PKG_DMF0044 | 3054 + 3084-3102 | ③ | `GT_0044_BP_FCST_02` DEPARTMENT_ID/NAME · DEPT_ID/NAME 스칼라 4개 (A.OWNER=SITE_ITEM.OWNER 첫 토큰 → SSO_USER_INFO) |
| 20 | 〃 | 8588-8589 | ③ | `GT_DMF0_REPORT` `C`(SSO_USER_INFO ON B.OWNER 첫 토큰) → `D` |
| 21 | 〃 | 8718 | ① | `D ON C.DEPT_ID` (C=SCM_MST_SITE) — MDF_DEPARTMENT‖div |
| 22 | 〃 | 8825 | ① | 동일 (MDF_DEPARTMENT_82 분기 1) |
| 23 | 〃 | 8847 | ① | 동일 (MDF_DEPARTMENT_82 분기 2, LEFT OUTER) |
| 24 | PKG_DMF0051 | 1177-1185 | ③ | `GT_DM51_SCM_MST_SITE_ITEM.DEPT_ID` = `OW.DEPT_ID` (DISTINCT OWNER → SU 스칼라) |
| 25 | 〃 | 1205 + 1215 | ① | `GT_DM51_SCM_CITY.DEPT_ID` = `X.DEPT_ID` (X=SCM_MST_SITE) |
| 26 | PKG_DMF0074 | 96 + 132-138 | ③ | CURRENT 분기 `TEAM.DEPT_ID` (SITE_ITEM.OWNER) → GT_DM74 DEPT_ID · 165 P_DEPT_ID 필터 |
| 27 | 〃 | 201 + 236-242 | ③ | 비-CURRENT 분기 (#26 동형) · 268 필터 |
| 28 | 〃 | 632 + 671-677 | ③ | `BASE_DATA` (SI.OWNER) |
| 29 | 〃 | 711 + 750-756 | ③ | #28 미러 |
| 30 | PKG_DMF0082 | 844 + 904-920 | ③ | `TEAM.DEPT_ID` (F.OWNER) + `K ON CASE div40 THEN J.DEPT_ID ELSE F.DEPT_ID` (**40 만 OWNER 경유, 그 외 SITE_ITEM 직접** 혼합) → 1015 MAX(DEPT_ID) |
| 31 | 〃 | 5066-5083 | ③(판정) | ATTRIBUTE302 END_CUSTOMER 후보: `SI.OWNER→UI→DI` **INNER JOIN 필터** (DEPT 값 출력 아님 — 유효 부서 OWNER 행만 통과). TO-BE = `SI.DEPT_ID = DI.DEPT_ID` 로 치환 여부 판정 |
| 32 | 〃 | 7407 + 7431-7444 | ③ | #30 미러 (+ J/K 혼합) → 7527 MAX |
| 33 | 〃 | 10395-10399 | ③ | `GT_DMF0082_PJT` div40 `SU.DEPT_ID` (OUTER APPLY 첫 토큰) → 10436 · 10461 |
| 34 | 〃 | 10488 | ① | `C.DEPT_ID = TEAM.DEPT_ID` → 10436/10461/10570/10579/10605 |
| 35 | 〃 | 11045 | ① | `SITE.DEPT_ID = TEAM.DEPT_ID` → 11013 |

(#3·#11 = 검토 2 / #31 = 판정 1 → 확정 대상 32 + 검토·판정 3)

## B. 대상 아님 — 8 객체 (근거)

| 객체 | 근거 |
|---|---|
| PKG_DMF0014 | 6442/6499/6524 `ITM.DEPT_ID` (2026-04-01 전환 완료) ✅ — AS-IS ①·③ 은 주석 |
| PKG_DMF0049 | DEPT_ID 는 `DM_PLN_SALES_ETC_REPORT_C.DEPT_ID` 저장값 소비 + 365 `TB_FX_USER` 본인 부서(권한) — 산출 없음 |
| PR_DM_BPS_SALES_PLAN_S | 367/441/513 `D.DEPT_ID` (D=SCM_MST_SITE_ITEM) ✅. `SU` 조인(400/474/546)은 `SU.USER_ID` 조인식뿐, DEPT 미사용 → **잔존 조인 정리(선택)** |
| PR_DM_BPS_SALES_ETC_PLAN_S | 251 `D.DEPT_ID` ✅ (FCST_TYPE='ETC' & div40 은 `A.ATTRIBUTE1`). `SU` 282 잔존(선택) |
| PR_DM_BPS_METAL_LINK_S | 229 `A.DEPT_ID` = `DM_BPS_METAL_LINK_PRICE_C` 저장값 — 상류 = PKG_DMF0074(#26~#29) |
| PR_DM_METAL_LINK_CUTOFF | 85/154 `LP/TMP.DEPT_ID` 저장값 이관 — 상류 동일 |
| IF_DM_HI_CUST_FCST_INPUT_V | `DM_HI_CUST_FCST_INPUT.DEPT_ID` passthrough — 적재 SP 는 목록 외 |
| IF_DM_HI_SALES_INPUT_V | `DM_HI_SALES_INPUT.DEPT_ID` passthrough — 동일 |

## C. 룰 범위 밖 (사용자 본인 부서 = 권한 판정, site DEPT 아님)
- PKG_DMF0020 3843 `FxU`(SCM_ADM_USER_M) · 4719/7769 `GT_DMF0020_DEPT_AUTH` (SCM_ADM_USER_M+PM_TEAM_MAPPING)
- PKG_DMF0044 1202 `SCM_ADM_USER_M` · PKG_DMF0082 9019-9025 `TB_FX_USER` · PKG_DMF0049 365 `TB_FX_USER`

## D. 이미 TO-BE 인 지점 (참고)
- PKG_DMF0022 2691-2708 `GT_DM22_SCM_MST_SITE.DEPT_ID` = `B.DEPT_ID`(SITE_ITEM, GROUP BY PROJECT/ITEM 포함) ✅
- PKG_DMF0035 2872-2885 `GT_DM35_TEMP_SCM_SITE` 동형 ✅
- PKG_DMF0020 2765 / 2841 `DI ON IM.DEPT_ID` ✅ (단 IM 조인키 DIV+SITE 만 — #7/#8 증식 검토)

---
## E. 적용 이력 (2026-09-06)
- 사용자 확정: ① NEW_DEPT_ID_TBL MAX 유지 ② DMF0082 5066 적용 ③ PR_DM_BPS_* 잔존 SU 조인 = 대상 아님 / `SCM_MST_SITE.DEPT_ID` 삭제 예정 → ① 패턴 전량 대상
- 배포: `_artifacts/_apply_corporate/DEPT_ID_RULE150_20260906/01_APPLY/01~10` → AJS 적용 08:33~08:35, 10 객체 VALID · USER_ERRORS 0 · 신규 INVALID 0 (기존 INVALID 62 는 2026-09-04 18:17 이전 상태, 의존 없음)
- 원복본: `00_BACKUP_ASIS/` 10본 (적용 직전 USER_SOURCE 원문)
- 건수 대사: `90_VERIFY/` (BEFORE 2026-09-06 01:34 실측 → AFTER 재실행 → compare) — 결과는 `01_ROWCOUNT_PARITY.md`
- 기존 결함 발견(변경 무관): PKG_DMF0082 GET_MAIN_DATA(_CURRENT) `ORA-00904 SORT_KEY` (적용 전부터) / PKG_DMF0044 8718 분기 `'MDF_DEPARTMENT'||div` 룩업 타입 부재(실존 `MDF_DEPARTMENT_81`) → 0행 사각 / DMF0040|40 300s 초과 / standalone POPUP|40 GT_DMF0020_PJT 적재 >10분
