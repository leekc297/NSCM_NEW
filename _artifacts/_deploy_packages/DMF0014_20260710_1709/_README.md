# DMF0014 Customer FCST Upload — 클라우드 이관 (이번 수정 반영분만 · 2026-07-10)

> 범위 = **이번 라운드 수정분만** — ① Excel Upload 2-Step 분리 ② Plant Site 조회조건 교정.

## 변경 내용

### ① Excel Upload 2-Step 분리
- 기존: 파일 업로드(mode=0) 시 에러 0건이면 **즉시 저장** (SP L1733 게이트 제거된 상태).
- 변경: **P_MODE>0 게이트 복원** → 업로드=검증·분류만 / **OK=저장**.

### ② Plant Site 조회조건
- `SalesPlant`(Division only) → **`PlantSitebyEndCustomer`**(Division+EndCustomer 바인드, 81* enable). 카탈로그 `PlantSiteField` 사용.

## 파일

### SQL (클라우드 DB — 순서대로)
| 파일 | 내용 |
|---|---|
| `sql/00_PKG_DMF0014_BODY_ORIG_backup.sql` | ⚠ 원본 백업 (원복용 — `CREATE OR REPLACE` 재실행) |
| `sql/01_PKG_DMF0014_BODY_2step_FIX.sql` | ⭐ BODY 패치 (단일 라인 L1733: `IF V_COUNT=0` → `IF P_MODE>0 AND V_COUNT=0`). 배포 후 `ALTER PACKAGE SCM_MGR.PKG_DMF0014 COMPILE BODY` → VALID 확인 |
| `sql/02_dmf0014_upload_save_meta.sql` | SAVE call-proc 메타 (API `DMF0014_upload_SAVE` / PROC 5 / BTN `UPLOAD_SAVE` / USER_GR 2) — 멱등 MERGE |

### FE
| 파일 | 변경 |
|---|---|
| `fe/.../fcst-upload-modal/FcstUploadModal.tsx` (+`.module.scss`) | ⚠ **공유** — opt-in `onSave` 2-Step(파일선택=자동검증+스피너 / OK=저장, 전량 게이트) + 하단 스크롤바 잘림 수정 |
| `fe/.../customer-fcst-upload/CustomerFcstUpload.tsx` | onSave = `/DMF0014/FCST Upload/UPLOAD_SAVE/call-proc` (mode=1) |
| `fe/.../customer-fcst-upload/components/CustomerFcstUploadForm.tsx` | Plant Site → 카탈로그 `PlantSiteField` |
| `fe/.../searchFields/SearchFields.tsx` | ⚠ **공유** — `PlantSiteField`(PlantSitebyEndCustomer) |

## 적용 순서

1. `sql/01_...BODY_2step_FIX.sql` 실행 → `ALTER PACKAGE SCM_MGR.PKG_DMF0014 COMPILE BODY` → STATUS=VALID 확인
2. `sql/02_...meta.sql` 실행 (멱등)
3. FE 배포
- ⚠ 롤백: `sql/00_...ORIG_backup.sql` 재실행

## 검증

- BODY VALID · 게이트 라인 `[DMF0014 2-Step]` 1건
- API `DMF0014_upload_SAVE`(1)/PROC 5/BTN `UPLOAD_SAVE`(1)/USER_GR(2)
- 화면: 파일 선택→스피너→분류(Success/Error) / Error 0 시 OK 활성→저장→재조회 / Error>0 시 OK 비활성

## ⚠ 클라우드 이슈 (2026-07-10) — Plant Site 가 81 division 기준 조회 안 됨

**원인**: 클라우드 `SCM_ADM_CMBO_SQL_M` 에 `PlantSitebyEndCustomer` 미등록(또는 구버전 잔존).
**해결**: 적용 순서 0단계로 **`sql/00_CMBO_PlantSitebyEndCustomer_cloud.sql`** 실행 (진단→멱등 등록/교정→검증 CNT_DIV81>0).
