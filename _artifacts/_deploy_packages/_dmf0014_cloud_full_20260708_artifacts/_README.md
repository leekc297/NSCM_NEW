# DMF0014 (CustomerFcstUpload) — 클라우드 이관 전체 취합 (2026-07-08, 오후 갱신)

> ⭐ **로컬 DB ≠ 클라우드 DB** (오늘 확인):
> - 로컬 BE = `121.162.245.167/OCGSCMD_P01` (SCM_MGR) — 오늘 모든 fix 배포 완료
> - 클라우드/dev BE = `10.34.220.81/ESSCMD` (**SCMD_APP**) — **별도 DB, 오늘 fix 미적용** → 동일 SQL error
>
> 이 폴더 = 클라우드에 적용해야 할 **FE + SQL 전체** (2026-07-08 **오후 세션까지 최신 취합**).
> FE 14파일 = 현재 워킹트리와 1:1 동기화. SQL `02` body = 사내에 실제 배포된 최신본(오후 dedup/normalize 포함).

> ⭐⭐ **오후 세션 추가분** (오전 취합본 대비 신규 — 반드시 함께 반영):
> | 추가 | 증상 | 파일 |
> |---|---|---|
> | A | Excel Upload OK 시 `ORA-01841`(년 범위) + 재시도 "10행→20행 Duplication Key" | `sql/02` PKG_DMF0014 (일자행 숫자표기 정규화 + 같은 초 트윈 dedup + 잔존 배치 정리) |
> | B | 2행 이후 셀 수정이 저장 안 됨("저장할 데이터 없음") | FE `CustomerFcstUpload.tsx` + `CustomerFcstUploadGrid.tsx` (저장 payload 를 그리드 공용 EditTracker 에서 도출) |
> | C | 조회조건 Project·Model/Nickname 박스+돋보기 버튼 폭/높이가 상하 필드와 불일치 | FE `CustomerFcstUploadForm.tsx` + `.module.scss` (endAdornment 절대배치 폐기 → flex 나란히, 36px) |
>
> ⚠️ B 는 BE 프레임워크 결함(`SystemLogAspect` 예외 시 요청 2회 실행)이 A 의 근접 원인이기도 함 — BE 불변 결정에 따라 SP(`02`) dedup 으로 방어. 상세 = `_dmf0014_hotfix_20260708_artifacts/_README.md §6`.

## 0. ⚠️ 핵심 — FE 와 SQL 은 반드시 함께 배포
`PROC_M` SORT17 을 `createdByList` 로 바꾸는 순간, **구버전 FE(createdBy)** 는 즉시 저장 실패(ORA-01400)합니다.
→ **FE 재빌드/배포 + SQL 04 를 같은 릴리스에** 반영하세요. (한쪽만 적용 금지)

## 1. 오늘 고친 DMF0014 결함 (클라우드에도 동일 존재 → 본 이관으로 해소)
| # | 증상 | 파일 |
|---|---|---|
| 1 | 저장 다건 ORA-01400 (CREATED_BY NULL) | FE `createdByList` + `sql/04` PROC_M |
| 2 | 저장 1건에 **테이블 전체 삭제**(무오류) | `sql/02` PKG_DMF0014 (GT_SCFU 무prefix 상관 → `V_*` 정정) |
| 3 | 저장 후 ORA-01403 / 01422 / 무한루프 / TRUNCATE mutex | `sql/03` PR_DM_PLN (5세대 누적본) |
| 4 | 업로드 "Invalid Measure Upload Bucket" | `sql/02` PKG_DMF0014 (bucket 검증=V_TITLE 주차라벨 → **날짜행(2Row)** + 과학표기 정규화) |
| 5 | 업로드 이중발사(dev) | FE `FcstUploadModal` ref 가드 |

## 2. 패키지 구성
```
_dmf0014_cloud_full_20260708_artifacts/
├── fe/                                     ← 클라우드 FE 빌드에 반영 (화면 전용 + 공유)
│   ├── features/demand/src/pages/customer-fcst-upload/   (7 + components 3)
│   ├── features/demand/src/components/fcst-upload-modal/ (2)
│   ├── features/master/src/components/searchFields/       (2, ⚠️ 공유)
│   ├── packages/foundation/src/apis/axios.ts             (⚠️ 공유 — FormData 멀티파트)
│   └── packages/shared/.../sub-title/SubTitle.tsx        (⚠️ 공유 — 업로드 버튼 라벨)
└── sql/                                    ← 클라우드 DB(SCMD_APP→SCM_MGR) 실행
    ├── 01_PKG_DMF0014_SPEC.sql             (패키지 스펙 — 없으면/변경 시)
    ├── 02_PKG_DMF0014_BODY.sql             ⭐ 전체삭제 정정 + bucket 검증 (최신 전체 body)
    ├── 03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql  ⭐ 공유 SP 누적 최신본(5세대 fix)
    ├── 04_PROC_M_createdByList.sql         ⭐ 메타 정렬 (FE 와 동시)
    └── 05_GRANT_SCMD_APP.sql               실행권한/시노님
```
> `sql/03` 은 DMF0014 업로드 + **DMF0048 / MKT FCST 공용** SP — 클라우드에 함께 반영되어야 함.

## 3. 적용 순서 (클라우드)
```sql
-- DB (SCM_MGR 로 접속 또는 DBA)
@01_PKG_DMF0014_SPEC.sql          -- (기존 동일이면 생략 가능)
@02_PKG_DMF0014_BODY.sql          -- STATUS VALID 확인
@03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql
@04_PROC_M_createdByList.sql
@05_GRANT_SCMD_APP.sql
```
```bash
# FE (클라우드 빌드) — 화면 전용 + 공유 diff 검토 후 반영
cp -r fe/features/demand/src/pages/customer-fcst-upload  nscm-fe/features/demand/src/pages/
cp    fe/features/demand/src/components/fcst-upload-modal/*  nscm-fe/features/demand/src/components/fcst-upload-modal/
# ⚠️ 공유 — diff 후
cp fe/features/master/src/components/searchFields/*  nscm-fe/features/master/src/components/searchFields/
cp fe/packages/foundation/src/apis/axios.ts          nscm-fe/packages/foundation/src/apis/
cp fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx  nscm-fe/packages/shared/src/components/organisms/sub-title/
```

## 4. 전제 (클라우드 DB 가 신규가 아닐 것)
2026-07-04 배포분(API_M / BTN_MPG / SHEET_COLUMNS / i18n / PR_GET_DAY_RANGE 등 DMF0014 기본 메타)이 클라우드에 이미 있다고 가정. 없다면 그 base 부터 선행 필요(별도).

## 5. 검증 (클라우드)
1. 조회 → 일자별 **다건 수정 저장**(특히 **2행 이후 셀**) → 오류 없이 완료 + 재조회 반영 **+ 기존 행 전부 유지**. (오후 추가 B)
2. 다운로드 → 재업로드 → **성공 N / 실패 0**: `ORA-01841` 0건(과학표기 일자행 정규화), 재시도해도 **10행 그대로**(20행 dup 오탐 0건). (오후 추가 A)
3. 조회조건 **Project · Model/Nickname** 박스 + 돋보기 버튼이 상하 드롭다운·DatePicker와 **우측 끝선·높이(36px)** 정합. (오후 추가 C)
4. VALID 확인: `SELECT STATUS FROM ALL_OBJECTS WHERE OBJECT_NAME IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST');`
5. PROC_M: `04` 검증쿼리로 17=createdByList.

## 6. FE 이관 파일 전체 (14) — 현재 워킹트리 1:1 동기화 완료
```
화면 전용 (customer-fcst-upload/)
  CustomerFcstUpload.tsx              ⭐ EditTracker 저장(오후 B) + createdByList(오전)
  customer-fcst-upload.constant.ts    createdByList(오전)
  customer-fcst-upload.types.ts / useCustomerFcstUploadStore.ts / __asis-mapping__.md
  components/CustomerFcstUploadGrid.tsx   ⭐ editTrackerRef(오후 B)
  components/CustomerFcstUploadForm.tsx + .module.scss  ⭐ 박스 사이징(오후 C)
화면 전용 (components/fcst-upload-modal/)
  FcstUploadModal.tsx + .module.scss   업로드 이중발사 ref 가드(오전)
⚠️ 공유 (diff 검토 후 반영)
  features/master/src/components/searchFields/SearchFields.tsx + .module.scss
  packages/foundation/src/apis/axios.ts
  packages/shared/src/components/organisms/sub-title/SubTitle.tsx
```
