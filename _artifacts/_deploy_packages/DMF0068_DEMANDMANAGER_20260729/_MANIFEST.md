# DMF0068 이관 패키지 MANIFEST

재취합: **2026-07-30** — 07-29 최초 취합본에는 이후의 런타임 정정(FE 7파일)이 빠져 있었다.

> ⭐ **2026-08-06 보강 — 자급 DDL 2본 신설 (클라우드 PLS-00201 조치)**
> 클라우드에서 `01_PKG_DMF0068_SPEC.sql` 실행 시 `PLS-00201: 'T_DMF0068_TAB' 식별자가 정의되어야 합니다` 발생.
> 원인: SPEC 이 스키마 TYPE 2종(T_DMF0068_ROW/T_DMF0068_TAB)을 파라미터 타입으로 참조하고 BODY 가
> GTT 5종(GT_DM68_ORD_*)을 정적 참조하는데, 00_PRECHECK 는 **존재 점검만** 하고 생성 DDL 이 미동봉이었음
> (이관패키지 GTT/TYPE DDL 자급 의무 위반 계보).
> **실행 순서(수정): `00A_TYPE_DDL.sql` → `00B_GTT_DDL.sql` → 01_SPEC → 02_BODY → 03_GRANT → ...**
> 두 파일 모두 사내 OCGSCMD_P01 실측 원문(ALL_SOURCE / DBMS_METADATA) 1:1 + 멱등(존재 가드 / -955 skip).

| 항목 | 상태 |
|---|---|
| FE 폴더 ↔ 로컬 소스 | **OK (전 파일 일치)** (17 파일) |
| `02_DB_SP` SPEC/BODY ↔ 사내 `ALL_SOURCE` | **IDENTICAL** (정규화 대조 — 차이는 `SCM_MGR.` 접두어뿐) |
| `locales.DMF0068_PATCH.json` ↔ 로컬 locales | **일치** (KO/EN/CN 각 5키, 값 불일치 0) |

## 2026-07-30 재취합에 반영된 FE 정정 7파일

| 파일 | 정정 내용 |
|---|---|
| `DemandManager.tsx` | 커서 키 `o_rc1`(useTabProcQuery 는 result 를 그대로 반환) / 편집권한 = `hasButton('SAVE')` (세션에 그룹 ID 없어 그룹명 비교 불가) / EDIT 버튼 제거 |
| `demand-manager.constants.ts` | 바인딩 대문자화(SP alias 일치) / 버전 팝업 기본창 −12~+3개월 / 월 그룹 헤더 상수 |
| `components/DemandManagerGrid.tsx` | 편집 가능 셀 배경색 / 컬럼 표시 정합 |
| `components/DemandManagerForm.tsx` | 버전 조회 버튼 배치·표준화 |
| `components/modals/VersionPopupModal.tsx` | 선택 행 판정 = `selectedItems[0] ?? rows[rowIdx].dataItem` (인덱스 의존 제거 — 가상화 불일치) |
| `utils/demand-manager.merge.ts` | `headerRange()` 추가 — 커스텀 MergeManager 는 네이티브 columnGroup span 을 무효화하므로 헤더 세로·가로 머지를 수동 구현 |
| `utils/demand-manager.validate.ts` | 검증 메시지 코드 정합 |

## 스테일 판정 명령 (다음 재취합 전 실행)

```bash
# FE — 0건이어야 한다
diff -rq _artifacts/_deploy_packages/DMF0068_DEMANDMANAGER_20260729/04_FE/demand-manager \
         nscm-fe/features/demand/src/pages/demand-manager

# DB — ora.py 표 출력은 show(limit=500) 로 잘리므로 비교에 쓰지 말 것.
#      ALL_SOURCE 를 커서로 전량 fetch 해서 대조한다.
```

## 파일 인벤토리 (SHA-256 앞 16자)

| 파일 | bytes | sha256 | 원본(source of truth) |
|---|---:|---|---|
| `00_PRECHECK_CLOUD.sql` | 2903 | `834f9c68b9429ebd` | — |
| `02_DB_SP/01_PKG_DMF0068_SPEC.sql` | 4104 | `08604c6a347dde28` | SCM_MGR ALL_SOURCE (사내 반영본과 대조 완료 2026-07-30) |
| `02_DB_SP/02_PKG_DMF0068_BODY.sql` | 73225 | `6b99d821de6a5446` | SCM_MGR ALL_SOURCE (사내 반영본과 대조 완료 2026-07-30) |
| `02_DB_SP/03_GRANT.sql` | 1431 | `8eb82bb01ed93aee` | SCM_MGR ALL_SOURCE (사내 반영본과 대조 완료 2026-07-30) |
| `02_DB_SP/04_APP_SYNONYM_ONLY.sql` | 3179 | `0c97c91178c199c0` | SCM_MGR ALL_SOURCE (사내 반영본과 대조 완료 2026-07-30) |
| `02_DB_SP/05_DIAG_9994.sql` | 2630 | `49eac404334e2771` | SCM_MGR ALL_SOURCE (사내 반영본과 대조 완료 2026-07-30) |
| `03_META/01_MSG.sql` | 3298 | `d2d3a3a9ab8e2ff2` | — |
| `03_META/02_API_M.sql` | 3717 | `d89ddc2d574b0ac8` | — |
| `03_META/03_BTN_MPG.sql` | 2126 | `b3a5fa7d0c035197` | — |
| `03_META/04_PROC_M.sql` | 5829 | `deb1df1287892d08` | — |
| `03_META/05_BTN_AUTH.sql` | 1591 | `8696d8893acc5c9e` | — |
| `03_META/06_SHEET_COLUMNS_FIX.sql` | 1245 | `2ceadbeeadbd5666` | — |
| `03_META/07_SHEET_COLUMNS_DIVISION.sql` | 1722 | `b30c4d40e3ad0b59` | — |
| `03_META/08_SHEET_COLUMNS_BINDING_TIER.sql` | 3620 | `3f872c4985383f3f` | — |
| `03_META/97_LBL00783_TYPE_FIX.sql` | 1676 | `5d6931dbc019ef7f` | — |
| `03_META/98_MNU_URL_ALIGN.sql` | 3030 | `b70da36f44291986` | — |
| `03_META/99_ROUTE_PATH.sql` | 1038 | `8d227a41351ae099` | — |
| `04_FE/_configs/locales.DMF0068_PATCH.json` | 1153 | `09544a5b1155d2f4` | nscm-fe/public/locales/{KO,EN,CN}.json (5키) |
| `04_FE/_configs/procedures.d.ts.DMF0068_BLOCK.ts` | 2376 | `d440e71598cc1484` | nscm-fe/configs/types/procedures.d.ts (DMF0068 블록) |
| `04_FE/demand-manager/__asis-mapping__.md` | 6394 | `e55ad90adeab00be` | nscm-fe/features/demand/src/pages/demand-manager/__asis-mapping__.md |
| `04_FE/demand-manager/components/DemandManagerForm.module.scss` | 1399 | `bd757103360e1039` | nscm-fe/features/demand/src/pages/demand-manager/components/DemandManagerForm.module.scss |
| `04_FE/demand-manager/components/DemandManagerForm.tsx` | 3324 | `1d4e60e396f88637` | nscm-fe/features/demand/src/pages/demand-manager/components/DemandManagerForm.tsx |
| `04_FE/demand-manager/components/DemandManagerGrid.tsx` | 12068 | `88482080614b0891` | nscm-fe/features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx |
| `04_FE/demand-manager/components/modals/index.ts` | 57 | `43e553de6ad350e4` | nscm-fe/features/demand/src/pages/demand-manager/components/modals/index.ts |
| `04_FE/demand-manager/components/modals/VersionPopupModal.tsx` | 10334 | `feb34670b69c6c8f` | nscm-fe/features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx |
| `04_FE/demand-manager/demand-manager.constants.ts` | 5770 | `a4019a307210884b` | nscm-fe/features/demand/src/pages/demand-manager/demand-manager.constants.ts |
| `04_FE/demand-manager/demand-manager.types.ts` | 2002 | `b2d6f4b661b871e2` | nscm-fe/features/demand/src/pages/demand-manager/demand-manager.types.ts |
| `04_FE/demand-manager/DemandManager.module.scss` | 1364 | `7aadd280bca67e92` | nscm-fe/features/demand/src/pages/demand-manager/DemandManager.module.scss |
| `04_FE/demand-manager/DemandManager.tsx` | 12410 | `15fbac11ce61d8a4` | nscm-fe/features/demand/src/pages/demand-manager/DemandManager.tsx |
| `04_FE/demand-manager/index.ts` | 49 | `27140cf62b138fc8` | nscm-fe/features/demand/src/pages/demand-manager/index.ts |
| `04_FE/demand-manager/useDemandManagerStore.ts` | 4254 | `4fc786bb6b2e1a9a` | nscm-fe/features/demand/src/pages/demand-manager/useDemandManagerStore.ts |
| `04_FE/demand-manager/utils/demand-manager.api.ts` | 2741 | `ebb985548a4ecd74` | nscm-fe/features/demand/src/pages/demand-manager/utils/demand-manager.api.ts |
| `04_FE/demand-manager/utils/demand-manager.merge.ts` | 4623 | `4e9aac25ca68efa5` | nscm-fe/features/demand/src/pages/demand-manager/utils/demand-manager.merge.ts |
| `04_FE/demand-manager/utils/demand-manager.months.ts` | 2349 | `490c548e4126a583` | nscm-fe/features/demand/src/pages/demand-manager/utils/demand-manager.months.ts |
| `04_FE/demand-manager/utils/demand-manager.save.ts` | 3743 | `4750155b2e484b50` | nscm-fe/features/demand/src/pages/demand-manager/utils/demand-manager.save.ts |
| `04_FE/demand-manager/utils/demand-manager.validate.ts` | 3606 | `3f00ec37d63776f3` | nscm-fe/features/demand/src/pages/demand-manager/utils/demand-manager.validate.ts |
| `_README.md` | 8307 | `8a86287f434ee600` | — |
