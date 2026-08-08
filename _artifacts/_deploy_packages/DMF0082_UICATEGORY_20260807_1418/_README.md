# DMF0082 UICATEGORY 클라우드 이관 패키지 (2026-08-07 14:18 · **재취합 15:30**)

> **목적**: DMF0082(FcstNPrice) 81(편집)/82(조회 전용) 확장 — 필수 키 5컬럼 DIVISION 토큰 + DMF0003 파리티 17컬럼 + 조회조건 3종(Project/Owner/SenderCode) + 82 편집 차단.
> **원천**: 사내 OCGSCMD_P01 적용·검증 완료분(2026-08-07)의 live 덤프. 상세 = `Doc/_archive/work_reports/2026-08-07_DMF0082_uicategory_보완.md` (§8 후속 포함)
> ⚠️ **클라우드 DB 적용물은 QA·DEV 2곳 동시 적용 의무** (feedback_cloud_be_build_out_of_sync_diagnosis)
>
> ⭐ **재취합(15:30) 추가 반영분 — 전 파일 fresh 재덤프**:
> ① **[SENTINEL3]** SAVE 판가 52주 검증 — T_PRICE 적재+검증 조인 양변 센티널 변형(`' '/'-'/'--'`) 정규화(hook #119 §1.5, 변형 분열 "Unit Price Not Found" 실사고 해소 — 02 BODY 마커 2곳)
> ② **CTRL 공백 48행 → NULL 정정**(AS-IS 빈값 실측 — 04 [3] UPDATE)
> ③ **cascade 전수 반영**(FE): Division→bizTypes reset(F-A) + SalesSite=DMF0003 스왑 이식(`ScmSitebyEndCustomer40`↔`UserSiteByEndCustomer` 서버 바인드, F-B) + Insert PLANT_SITE_ID 시드 승계(F-E) + **82 Price Batch Input 버튼 숨김**
> ④ `fe/forecast-price/__asis-mapping__.md`(EID 20행+CRUD·모달 매트릭스 14행) 동봉
> **CRUD 런타임 실증(사내, SAVE 직접)**: 81 M/I/D 왕복 PASS · 40 M/I PASS(D=수요 no-op AS-IS 규약) · 82 V82-00 거부+원장 불변 · 검증 게이트 3종 작동 — `_apply_corporate/CRUD_ROUNDTRIP_DMF0082_20260807.txt`

## 0. 선행(PREREQ) — 미적용 시 본 패키지보다 먼저

| 선행 | 내용 | 확인 방법 |
|---|---|---|
| `DMF0082_20260804_1032` 통합 패키지 | 7/22~8/4 누적 8건(GTT 58종 DDL·메타 451문·W/M 복원·PKG 취합·AUTHUNION·SORTFIX·PlantSite 등) + 선행 `MSG_LBL_MNU_SYNC_20260724`·`DMF0082_EXCHANGE_SAVE_20260724`(PKG_DMF0000) | 90_VERIFY [1] PKG VALID + [3] SPEC 에 p_plant_site_id 존재 |
| (참고) 2026-08-05 ASFROMSITE | 클라우드 별도 패키지 없음 — **본 패키지 01/02(BODY cumulative)+03(SAVE PROC_M 18행)이 커버** | 90_VERIFY [3] P_AS_FROM_SITE / [4] SAVE 18 |

## 1. 적용 순서 (순서 의무 — 메타 = 마지막 DB 스위치)

| # | 파일 | 내용 | 비고 |
|---|---|---|---|
| 1 | `00_GTT_ALTER.sql` | GT_DMF0082_MF_SP +4 / GTT_MF_SP +14 (멱등 ORA-01430 skip) | ⚠️ 최우선. ORA-14450 시 저사용 시간대 재시도 |
| 2 | `01_PKG_DMF0082_SPEC.sql` | 사내 live 덤프 (GET/CURRENT +3 IN, SAVE p_as_from_site 포함) | SPEC → BODY 순서 |
| 3 | `02_PKG_DMF0082_BODY.sql` | 사내 live 덤프 **13,257행** — UICATEGORY 전 수정 + **[SENTINEL3] 판가 검증 변형 정규화** + 8/5 ASFROMSITE + 기왕 누적 포함 | 컴파일 후 VALID 확인 |
| 4 | `03_PROC_M.sql` | GET 22 / CURRENT 22 / SAVE 18 — DELETE→INSERT (사내 실측 literal) | ⚠️ PKG 직후 **즉시**(구 PROC_M = PLS-00306 화면 파손 구간) |
| 5 | `04_META_SHEET_COLUMNS.sql` | 5키 토큰 UPDATE(멱등) + **신규 17컬럼 MERGE INTO**(hook #98 §9 — MATCHED=전속성 동기·NOT MATCHED=INSERT, **DELETE 0건**) + **[3] CTRL 공백 → NULL 정정** | 마지막 DB 스위치 — 1~4 선행 필수. ⛔ 시트 메타 DELETE 절대 금지(2026-08-07 사용자 확정) |
| 6 | `05_TITLESET_RESEED.sql` | FcstNPrice 개인화 전량 DELETE → 자동 재시드 | ⚠️ 개인화 소실 — 파일 헤더의 백업 CTAS 먼저 실행 권장 |
| 7 | `06_CMBO_USER_AUTH_GROUP.sql` | CMBO 'FcstPriceUserAuthGroup' (2026-08-04 사내 등록분 — 클라우드 미적용 F-1) | 멱등(NOT EXISTS) |
| 8 | `07_WS_FCSTTYPE_AUTH.sql` | **DM Planner (W/S) A/S·W/S 등록 지원**(2026-08-07 사용자 지시) — ①CMBO 신규 `FcstTypeByUserGroupDMF0082`(AS-IS `UP_FX_GetCommonDataList_DM:72` 1:1 — W/S 보유 시 WS/WSF/AS/ASF 4종 한정, 그 외 WS·WSF 배제) ②DMF0082 FCST_TYPE 셀 콤보 교체 ③`GET_ADMIN_GROUP_MEASURE` W/S×DMF0082×81계열 6×`MKT_FCST` 등재 | 멱등(NOT EXISTS). ⚠️공유 `FCST_TYPE_NOT_ETC`(4화면) **무변경** |
| 9 | `90_VERIFY.sql` | 통합 검증 — QA·DEV 각각 전 항목 기대값 일치 ([10]·[11] = W/S 지원 검증) | 아래 §3 |
| 9 | `fe/` | FE 스냅샷 | 아래 §4 |

## 2. 변경 요약 (사내 검증 실측 포함)

- **근본원인 해소**: 필수 키 5컬럼(DIVISION_ID/END_CUSTOMER/SCM_SITE_ID/ITEM_ID/CELL_PROD_SITE_ID) '40' 단독 → 81계열+82 확장. SHEET_COLUMNS 44→**61행**(노출 40=49/81=42/82=41).
- **PKG**: 조회조건 3 IN append(project/owner/sender — sender=**실값 보유 행만 매칭·무값 행 통과**) + C_TITLE whitelist 가드 + **82 EDIT_FLAG='N' 일괄 + SAVE V82-00 가드(82 저장 거부)** + Tier3 캐리어 적재(AS_YN/ATTR1/VMI_STD_DIO/NEW_FLAG — 값 정책·한계는 work report §5).
- **동반 해소 잠복결함**: ①CURRENT 전면 파손(C_TITLE `DEFAULT_FLAG IS NULL` 사문 → ORDER BY SORT_KEY 상시 ORA-00904 — SEARCH_CURRENT 실배선) → `= ' '` 교정 ②GTT_MF_SP AS_FROM_SITE/SENDER_NAME 부재 잠복 ③whitelist 부재.
- **사내 실측**: 40=17,343행(EDIT Y)/81=6,518행(EDIT Y)/**82=4,890행 전행 EDIT N**. 필터: project 1건=607행/owner 무존재=0행/sender 무존재=전행 유지. 재시드 자동 생성 실증(C16+M6).

## 3. 검증 (90_VERIFY.sql — QA·DEV 각각)

[1] PKG VALID ×2 / [2] GTT 79·72 / [3] 신규 파라미터 4종 / [4] PROC_M 22·22·18 / [5] 61·49·42·41 / [6] 5키 토큰 / [7] CMBO 1 / [8] TITLESET 0(직후) / [9] (선택) 82 EDIT_FLAG 전행 'N'.
⚠️ SP 직접 검증 시 `p_item_id` 는 **빈 문자열('')=전체** — 'ALL' 전달 시 '%ALL%' LIKE 전멸(사내 실측 함정).

## 4. FE 스냅샷 (`fe/`)

| 경로 | 반영 위치 | 내용 |
|---|---|---|
| `fe/forecast-price/` (26파일 — `__asis-mapping__.md` 포함) | `nscm-fe/features/demand/src/pages/forecast-price/` | ⚠️ **폴더 통째 교체 의무**(파일 단위 덮어쓰기 금지 — 클라우드 셸 세대 혼재 함정). Form=DMF0003 파리티 재배치(Row2 SenderCode·Row3 Project/Model/PlantSite·Row4 Owner/Version/체크박스) + **cascade F-A/F-B**(bizTypes reset·SalesSite 서버바인드 스왑) + store setFilters +4키(plantSiteId 결함 fix) + **82 차단: Insert/Delete/Save hotkey + Price Batch Input 버튼 숨김** + Insert PLANT 시드 승계(F-E) |
| `fe/configs-types/procedures.d.ts` | `nscm-fe/configs/types/procedures.d.ts` | DMF0082.FcstNPrice.request +projectCode/owner/senderCode | 
- 전제: `features/master` searchFields 카탈로그(ProjectField/OwnerField/PlantSiteField)·COM0005/COM0006 공용 모달 = 클라우드 기존재(DMF0003 이관분). 미존재 시 DMF0003 FE 이관분 선행.
- 검증: tsc --noEmit 0 / eslint 0 (features/demand, 2026-08-07 사내).

## 5. MSG / LBL / MNU / BTN 4분류 감사 (동봉 의무 — feedback_deploy_package_msg_lbl_mnu_omission)

| 분류 | 신규/변경 | 판정 근거 |
|---|---|---|
| MSG_M | **0** | V82-00 메시지 = SP 인라인 리터럴(기존 e_validation_error 관례 — V81-00 동형). FE = 기존 MSG 키 재사용 |
| LBL_M / locales | **0** | 신규 라벨 전부 기존 키 재사용(LBL00090 Sender Code·LBL00687/00689 체크박스·카탈로그 필드 내장 라벨 — DMF0003/0020 기등재). locales json = 이관 제외(2026-07-24 사용자 확정) |
| MNU_M | **0** | 메뉴/라우팅 무변경 |
| BTN_MPG / API_M | **0** | SEARCH/SEARCH_CURRENT/SAVE 기존 배선 그대로(파라미터만 PROC_M 확장) |

## 6. 원복

클라우드 적용 전 상태 백업: 05 헤더 CTAS + 적용 전 `USER_SOURCE` PKG 덤프 + `SCM_ADM_PROC_M`/`SCM_MST_SHEET_COLUMNS` 해당 행 CTAS 백업을 QA·DEV 각각 선행 권장. 사내 원복 정본 = `_apply_corporate/ROLLBACK_DMF0082_uicategory_20260807.sql` 패턴 준용(GTT 추가 컬럼 잔존 무해).
