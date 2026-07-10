# DMF0014 Excel Upload 2-Step 분리 (2026-07-10)

> 사용자 요구: DMF0014 Excel Upload 를 DMF0074 처럼 **[Upload]=검증·분류 / [OK]=저장** 2-Step 으로 분리.

## 배경 (실측)

DMF0014 SP `PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD` 는 이전 세션에서 **mode=0(검증) 에서
에러 0건이면 즉시 적재**하도록 수정돼 있었음 (BODY L1733 `IF V_COUNT = 0 THEN` — 주석 "P_MODE>0 제거").
→ 현재 1-Step(업로드=즉시저장). 2-Step 분리를 위해 **P_MODE>0 게이트 복원** 필요.

## 변경 (BE 코드 0 · SP 1줄 · 메타 · FE)

### ① SP — `01_ddl/01_PKG_DMF0014_BODY_2step_FIX.sql`
- **단일 라인** (L1733): `IF V_COUNT = 0 THEN` → `IF P_MODE > 0 AND V_COUNT = 0 THEN`
- 효과: mode=0 = 검증·분류만(적재 skip) / mode>0 = DM_PLN_CUSTOMER_PSI 적재. 블록 후 SUCCESS 커서는 불변.
- 블록(1733~3138)은 **ELSE 없음** → mode=0 은 persist 건너뛰고 정상 SUCCESS 반환 (분류결과는 staging → PR_GET_EXCEL_UPLOAD_RESULT).
- V_CREATION_DATE = MAX (동일 사용자 최신 배치) → mode>0(OK) 이 mode=0(Upload) 배치 자동 타겟.
- 원복: `01_ddl/00_PKG_DMF0014_BODY_ORIG_backup.sql` (CREATE OR REPLACE 재실행).

### ② 메타 — `02_meta/01_dmf0014_upload_save_meta.sql`
- API_M `DMF0014_upload_SAVE` → `PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD`
- PROC_M 5행 (mode NUMBER / createdBy 세션자동 / programId / sheetName / o_result_cursor)
- BTN_MPG `DMF0014 / FCST Upload / UPLOAD_SAVE` (⚠ 'SAVE'=그리드 17키 저장 선점 · 'UPLOAD'=FileController 선점 → 'UPLOAD_SAVE')
- USER_GR ADMIN / DM ADMIN (DM Viewer 제외 — write op)

### ③ FE
- `FcstUploadModal` opt-in `onSave` prop (미지정 = 기존 1-Step 유지 — 타 소비처 무영향). onSave 시 [OK] 저장 버튼 활성(검증완료+Error 0).
- `CustomerFcstUpload.tsx` — onSave = `/DMF0014/FCST Upload/UPLOAD_SAVE/call-proc` (mode=1).
- 파일 선택 시 자동 검증(스피너) · Error>0 면 OK 비활성(전량 게이트).

## 적용

`python apply.py` (멱등 · BODY 재컴파일 VALID 검증 · 메타 MERGE). 적용 결과: BODY VALID / API 1 / PROC 5 / BTN 1 / USER_GR 2.

## 검증 기대치

BODY VALID · 게이트 복원 라인 1 · API_upload_SAVE 1 · PROC 5 · BTN UPLOAD_SAVE 1 · USER_GR 2
