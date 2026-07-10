# DMF0014 — 클라우드 FE 재취합 (2026-07-08 v2)

> ⭐ **클라우드 파싱 오류 대응 전용 — FE 파일만 취합.**
> 증상: 클라우드에서 `CustomerFcstUpload.tsx 138:18 Parsing error: ',' expected` (vite babel / eslint).
> 원인: **클라우드의 파일이 최신 수정본과 다름**(부분 적용/머지 잔재로 구문 파괴).
> 로컬(=본 취합본) 파일은 정상. 브랜치 차이(`feat/dmf0020-20260629` vs `main`)로 파일이 어긋난 상태였음.

## 0. 조치 = **통째로 덮어쓰기** (머지 금지)
아래 14개 파일을 클라우드 동일 경로에 **파일 단위 전체 교체**하세요. 기존 파일과 라인 병합/부분 반영 금지(그것이 파싱 깨짐의 원인).

```bash
# 워크스페이스 루트(nscm-fe/)에서 — 폴더째 복사(구조 동일)
cp -rf fe/features/demand/src/pages/customer-fcst-upload  nscm-fe/features/demand/src/pages/
cp -f  fe/features/demand/src/components/fcst-upload-modal/*  nscm-fe/features/demand/src/components/fcst-upload-modal/
# ⚠️ 공유 — diff 검토 후 반영
cp -f  fe/features/master/src/components/searchFields/*      nscm-fe/features/master/src/components/searchFields/
cp -f  fe/packages/foundation/src/apis/axios.ts             nscm-fe/packages/foundation/src/apis/
cp -f  fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx  nscm-fe/packages/shared/src/components/organisms/sub-title/
```

교체 후: `pnpm run lint` (클라우드) → `@demand` 파싱 에러 0 확인.

## 1. 파일 목록 (14) — 현재 워킹트리 최신본, 스마트따옴표/충돌마커 0 검증 완료

**화면 전용 (그대로 교체)**
```
features/demand/src/pages/customer-fcst-upload/
  CustomerFcstUpload.tsx              ⭐ EditTracker 저장(2행 이후 저장 fix) + createdByList
  customer-fcst-upload.constant.ts    SAVE_KEYS createdByList
  customer-fcst-upload.types.ts
  useCustomerFcstUploadStore.ts
  __asis-mapping__.md
  components/CustomerFcstUploadForm.tsx + .module.scss   ⭐ Project·Model 박스+돋보기 36px 정합
  components/CustomerFcstUploadGrid.tsx                  ⭐ editTrackerRef 노출
features/demand/src/components/fcst-upload-modal/
  FcstUploadModal.tsx + .module.scss   업로드 이중발사 ref 가드
```

**공유 (⚠️ diff 검토 후 반영)**
```
features/master/src/components/searchFields/SearchFields.tsx + .module.scss
packages/foundation/src/apis/axios.ts
packages/shared/src/components/organisms/sub-title/SubTitle.tsx
```

## 2. 이번 취합에 반영된 수정 (본 파일들이 담고 있는 것)
| 구분 | 내용 | 주 파일 |
|---|---|---|
| 저장 | 2행 이후 셀 수정이 저장 안 되던 문제 → 저장 payload 를 그리드 공용 EditTracker 에서 도출 | `CustomerFcstUpload.tsx`, `CustomerFcstUploadGrid.tsx` |
| 저장 | 다건 저장 ORA-01400 회피(createdByList) | `CustomerFcstUpload.tsx`, `customer-fcst-upload.constant.ts` |
| 조회조건 | Project·Model/Nickname 박스+돋보기 버튼 폭/높이(36px)를 상하 필드와 정합 | `CustomerFcstUploadForm.tsx` + `.module.scss` |
| 업로드 | 이중발사 ref 가드 | `FcstUploadModal.tsx` |

## 3. 주의
- **SQL(PKG_DMF0014 등)은 이 폴더에 없음** — DB 배포분은 `_dmf0014_cloud_full_20260708_artifacts/sql/` 참조(사내 = 클라우드 공용 DB면 이미 반영).
- **FE ↔ SQL 동시성**: `createdByList`(FE)와 PROC_M SORT17(`04`)은 같은 릴리스에 함께 있어야 함(한쪽만 = ORA-01400).
- 본 취합본은 `main` 워킹트리 기준. 클라우드가 다른 브랜치면 **파일 전체 교체**로만 반영(라인 머지 금지).
