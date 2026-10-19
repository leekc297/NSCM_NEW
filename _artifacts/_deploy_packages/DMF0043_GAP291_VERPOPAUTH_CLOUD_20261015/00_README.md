# DMF0043_GAP291_VERPOPAUTH_CLOUD_20261015 — 기여율 버전관리 팝업 버튼 = ADMIN · DM ADMIN 만 (클라우드 메타 패치 + FE 가이드)

- 마커: `[GAP291 2026-10-15]` · 대상: `SCM_ADM_MNU_BTN_MPG_M` · `SCM_ADM_USER_GR_MNU_BTN_MPG_M` (MNU_ID='DMF0043', SHT_NM='version')
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 완료 — `_artifacts/_apply_corporate/DMF0043_VERPOPAUTH_20261015/APPLIED_OPERATIONS.md`
- 패키지 · BE 무변경, **BE 재기동 불필요**. **FE 수정 필요(아래 가이드)** — DB 만 반영하면 서버가 비관리자 저장을 막지만 버튼은 계속 보인다.

## 무엇이 바뀌나
AS-IS `DMF0043_ContributeRatePopup.cs` DefineProperty L111~123: 로그인 그룹이 ADMIN · DM ADMIN 이 아니면 Edit/Insert/Save/Delete 숨김.
TO-BE 는 팝업 버튼을 무조건 표시하고 `version|SAVE` 권한도 DM Viewer 가 보유 → 전 그룹이 표시·저장 가능했다.

| # | 변경 | 효과 |
|---|---|---|
| [1] | `SCM_ADM_MNU_BTN_MPG_M` DMF0043\|version 에 EDIT · INSERT · DELETE (API 없음) | FE 표시 게이트 코드 |
| [2] | `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 위 3종 = ADMIN · DM ADMIN 만 | 보유 그룹 합집합으로 판정 (`PKG_NSCM_UI_COM_AUTH` 기존 로직) |
| [3] | `version\|SAVE` 의 ADMIN · DM ADMIN 외 그룹 `USE_YN='N'` | 서버 `checkMenuBtnAuth` 가 비관리자 저장 API 차단 |
- 적용 직전 상태를 `SCM_ADM_MNU_BTN_BAK_GAP291` · `SCM_ADM_GR_BTN_BAK_GAP291` 에 최초 1회 백업(재실행 시 보존) → 99 원복 기준.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 에 ADMIN · DM ADMIN 존재 · L2 SAVE·SEARCH · L4 0행 | L1 에 ADMIN · DM ADMIN 이 없으면 **10 실행 금지**, 결과 회신 |
| 2 | `A_DB/10_APPLY_GAP291_META.sql` | `BACKUP — … 생성` + `APPLIED — MNU_BTN 추가 3 · GR_BTN 추가 6 · SAVE 회수 N` (N = 클라우드에서 SAVE 활성인 비관리자 그룹 수) | `중단 — …` / `실패 — …` 는 변경 없음, 회신 |
| 3 | `A_DB/90_VERIFY.sql` | V1 3 PASS · V2 6/0 PASS · V3 0 PASS | 회신 |
| 4 | FE 배포 후 화면 확인 | 비관리자: 팝업 Insert/Delete/Save 미표시·F8/F9 무동작 / 관리자: 표시·저장 정상 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP291_META.sql` | `ROLLED BACK — GR_BTN 삭제 6 · MNU_BTN 삭제 3 · SAVE 복원 N` | 회신 |

## 사내 리허설 (2026-10-15 18:34, `_rehearsal_out/`)
90(FAIL ×3, 적용 전) → 99(중단 — 백업 없음) → 00 → 10(3·6·1) → 10(0·0·0 SKIP) → 90(PASS ×3) → 99(6·3·1) → 99(0·0·0 SKIP) → 10(3·6·1) → 90(PASS ×3).
원복 후 상태 = 수정 전 8행과 동일. 판정 프로시저 실호출: ADMIN/DM ADMIN 단독·복수 보유자 Y, DM Viewer·GUEST 계 N.

## FE 가이드 (직접 수정하지 않음 — 적용 요청 시 반영)
파일: `nscm-fe/features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx`

1. import (L12) — `useTabBtnPermissions` 추가
   - 전: `import { useTabProcQuery } from '@shared/hooks';`
   - 후: `import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';`
2. 컴포넌트 본문 (L104 `const queryClient = useQueryClient();` 다음) — 권한 게이트
   ```tsx
   // AS-IS DefineProperty L111~123 — ADMIN·DM ADMIN 에만 Edit/Insert/Save/Delete.
   //   그룹 판정은 버튼권한 메타(version 시트 EDIT/INSERT/DELETE = ADMIN·DM ADMIN)로 이관 —
   //   PKG_NSCM_UI_COM_AUTH 가 보유 그룹 합집합으로 판정. 그룹명 하드코딩·session.groupId 금지.
   //   SAVE 는 메인 ContributeMain|SAVE 가 전 그룹 보유라 hasButton('SAVE') 로 가를 수 없다 → EDIT 로 게이트.
   const { hasButton } = useTabBtnPermissions({ menuId: MODAL_VERSION, enabled: open });
   const canEdit = hasButton('EDIT');
   ```
3. 단축키 (L365) — 비관리자 F8/F9 차단
   - 전: `<GridHotkeys onInsert={handleInsert} onDelete={handleDelete} />`
   - 후: `{canEdit && <GridHotkeys onInsert={handleInsert} onDelete={handleDelete} />}`
4. 버튼 (L415~437) — Insert / Delete / Save 조건부 렌더 (Close 는 그대로)
   - Insert: `{canEdit && hasButton('INSERT') && (<Button … onClick={handleInsert} />)}`
   - Delete: `{canEdit && hasButton('DELETE') && (<Button … onClick={handleDelete} />)}`
   - Save: `{canEdit && (<Button … onClick={() => void handleSave()} />)}`
5. 그리드 편집 잠금 (L405 `<DataGrid<VersionRow>`) — AS-IS 는 기본 잠금 + Edit 로만 해제
   - 후: `isReadOnly={!canEdit}` 속성 추가 (공용 DataGrid 가 `...gridProps` 로 FlexGrid 에 전달)

- 이유: 팝업은 별도 MENU_ID 가 없어 DMF0043 의 버튼권한을 쓴다(선례: `features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx` L117~123, 864 — DMF0082 같은 AS-IS 패턴을 `hasButton('EDIT')` 로 이관).
- 검증: ① `DM_A_TEST`(DM ADMIN) — 버튼 3종 표시·F8/F9·셀 편집·저장 정상 ② DM Viewer·GUEST 만 보유한 계정 — 버튼 3종 미표시·F8/F9 무동작·셀 편집 불가, 강제 호출 시 `/DMF0043/version/SAVE/call-proc` 서버 권한 거부 ③ 복수 그룹(예 `ahn.hc`) — 표시(합집합).
