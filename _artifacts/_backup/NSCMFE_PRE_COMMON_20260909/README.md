# NSCMFE_PRE_COMMON_20260909 — 공통소스 bb9c5113 반영 전 백업 + 분류표

- 공통 HEAD: **bb9c5113** (2026-09-09 "fix : 엑셀 다운로드 후 헤더 높이 수정")
- 직전 기준선: **5e1a83b9** (2026-09-08 적용) — `git merge-base --is-ancestor` 로 조상 확인(force-push 재작성 없음)
- 변경 범위: 4폴더(apps·features·packages·public) **38파일** (공통 전체 변경은 .atlas·nscm-be·Doc 포함이나 다운로드 대상 아님)
- 사용자 지시: **"내가 가지고 있는 소스가 더 최신이면 내 걸로 유지"**
- 판정: mtime ⛔ — 3자 내용 대조(기준선·공통·로컬) + 개행 정규화(LF) + 공통 이력 전수 대조 + Python 바이너리 I/O

## 분류 (38)
| 구분 | 건수 | 처리 |
|---|---:|---|
| 공통채택 (로컬=기준선, 내가 안 건드림) | 31 | 공통본 적용 |
| 신규 추가 | 3 | 공통본 추가 |
| 3-way 병합 성공 | 1 | 양쪽 변경 병합 |
| 충돌 → 수동 병합 | 1 | 로컬 기능 보존 + 공통 신규 로직만 이식 |
| 충돌 → 무처리(로컬이 이미 동일 내용) | 1 | KO.json |
| 공통 삭제 반영 | 1 | 로컬=기준선이라 삭제 |

### 신규 추가 (3) — 사용자 화면 "Assign Group" 모달
- features/admin/src/pages/user-management/components/AssignGroupModal.tsx · AssignGroupModal.module.scss
- features/admin/src/pages/user-management/components/UserManagementGrid.module.scss

### 3-way 병합 성공 (1)
- features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx
  → 공통: Excel Form 팝업 제거 + `handleExcelFormDownload` 직다운로드(내 `utils/customer-fcst-upload.excelForm.ts` 재사용).
    로컬 편집분 유지. `components/CustomerFcstTemplateModal.tsx` 는 미참조로 남음(삭제 안 함).

### 충돌 → 수동 병합 (1)
- packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx
  - 로컬 보존: `toZeroWidthColumnSet` 기반 `hiddenFromList`(관리자 폭 0 컬럼 목록 은닉, 2026-08-22 지시) + 하드코딩 문구
  - 공통 이식: `serializeSavePayload` 무변경 스킵(변경 없으면 저장/재조회 없이 닫기) — `HIDDEN_FROM_LIST` → `hiddenFromList` 로 치환 적용
  - 짝 파일 `columnLayoutModal.utils.ts` 는 공통채택(= `serializeSavePayload` 신규 export 포함, `toZeroWidthColumnSet` 유지 확인)

### 충돌 → 무처리 (1)
- public/locales/KO.json — 공통 변경은 `LBL00635: Rejected → 반려` 단 1건인데 로컬에 **이미 반영돼 있음**. 로컬 자체 추가분 보존.

### 공통 삭제 반영 (1)
- features/demand/src/pages/sales-plan/utils/sales-plan.comboContext.ts
  → 공통이 삭제(SalesPlanGrid 에서 `buildSalesPlanTeamSourceFilter` 참조 제거)했고 로컬본=기준선이라 그대로 삭제.
    참조하던 `SalesPlanGrid.tsx` 도 같은 회차 공통채택본으로 교체되어 잔여 참조 0 (주석 1건만 남음).

## ⚠ 4폴더 밖 미수행 — BE 동반 변경 (사용자 결정 필요)
공통 `fdf5a748 fix: 사용자 화면에 권한 그룹 모달 조회 추가` 는 FE(AssignGroupModal) + **BE 5파일**이 한 쌍이다.
- nscm-be/.../admin/user/UserController.java · UserService.java · UserServiceImpl.java · resources/sql/admin/User.xml
- nscm-be/.../admin/lookup/LookupServiceImpl.java

`AssignGroupModal` 은 `GET /user/{userId}/groups` 를 호출하는데 **로컬 BE 에 이 엔드포인트가 없다**(grep 실측 0건).
⇒ 화면은 뜨지만 모달 조회는 404. 다운로드 표준 범위(4폴더)를 넘어서므로 적용하지 않았다. 필요 시 별도 지시 요망.

## 미수행 — 검증
type-check / lint 미실행 (사용자 지시 2026-09-02 "별도 요청 전까지 자동 수행 금지"). 요청 시 `_artifacts/_tools/fe-check.ps1`.

## 원복
본 폴더 `nscm-fe/` 이하를 `C:\Projects\NSCM\nscm-fe\` 에 실경로 복사(삭제된 comboContext 포함).
