# DMF0008 보완 클라우드 적용 패키지 — 2026-06-11

> 본 패키지는 2026-06-11 작업분. 기존 (`_README_2026-06-10_DEPLOY.md`) 의 추가 보완.

## 사고 + Fix 요약

| # | 사고 | Root cause | Fix |
|---|---|---|---|
| 1 | DMF0008 조회 시 `ORA-06550 PLS-00306 인수 갯수 잘못` | SP signature 변경 (오늘 SP body 업데이트로 sig 변경) ↔ PROC_M 옛 sig 잔존 | PROC_M 3 SP (SUMMARY/REPAIR/GET_SALES_SITE) 재구성 |
| 2 | Summary 조회 SQL 정상 / 데이터 0 rows | BE auto-fill `menuId` 키 = NULL 전달 → SP 의 `PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, NULL)` 권한 조인 실패 | PROC_M.COL_NM `menuId` → `mnuId` (BE 자동 채움 키, 3 SP) |
| 3 | Summary 정상/정비/예외 카운트 모두 0 (실 데이터 있음에도) | inner SELECT 의 `NVL(EXCEPTION_FLAG, NULL) != 'Y'` → NULL!= 'Y' = UNKNOWN → CASE THEN 1 ELSE 0 = 0 | SUMMARY/REPAIR SP body 의 `NVL(.., NULL)` → `NVL(.., 'N')` |
| 4 | Repair 의 정비필요 (flag=4) 더블클릭 시 0 rows | line 153 `SUM(CASE WHEN ... AND EXCEPTION_FLAG != 'Y' THEN 1) STATUS_CODE_` bare 패턴 (NVL 미적용) → NULL flag 모두 0 → SUM=0 → `STATUS_CODE_ > 0` 필터 fail | REPAIR SP body bare `!= 'Y'` → `NVL(.., 'N') != 'Y'` (4곳) |

## 배포 파일

| 파일 | 내용 |
|---|---|
| `01_SP_BODY/070_DMF0008_GET_EDI_MST_SUMMARY_Body.sql` | SUMMARY SP body (NVL fix 적용본) |
| `01_SP_BODY/071_DMF0008_GET_EDI_MST_REPAIR_Body.sql` | REPAIR SP body (NVL fix + bare != 'Y' fix 적용본) |
| `03_META/130_DMF0008_PROC_M_2026-06-11_fix.sql` | PROC_M 3 SP 재구성 + menuId → mnuId 통일 + 검증 SELECT |

## 적용 순서

### Phase 1: PROC_M 메타 갱신
1. `03_META/130_DMF0008_PROC_M_2026-06-11_fix.sql` 실행
2. BLOCK 5 검증 SELECT 2건 모두 `0 row` 확인 의무

### Phase 2: SP body 갱신
1. `01_SP_BODY/070_DMF0008_GET_EDI_MST_SUMMARY_Body.sql` 실행
2. `01_SP_BODY/071_DMF0008_GET_EDI_MST_REPAIR_Body.sql` 실행
3. 두 SP 모두 `STATUS=VALID` 확인 의무

### Phase 3: 실 데이터 검증
1. DMF0008 화면 진입 → div=81 자동 선택
2. 조회 → Summary BMW 의 정상/정비/예외 각 행 > 0 표시 확인
3. BMW SUCCESS 셀 더블클릭 → Repair grid 96 rows
4. BMW GSCM_MASTER_DATA (정비필요) 셀 더블클릭 → Repair grid 54 rows
5. Sales Site / SSPM dblClick 동작 정상 확인

## 합격 기준

| Phase | 기준 |
|---|---|
| 1 | PROC_M 검증 SELECT 2건 모두 0 row |
| 2 | 2 SP 모두 STATUS=VALID |
| 3 | BMW 의 4 단계 (Summary 조회 / 정상 더블클릭 / 정비필요 더블클릭 / SSPM dblClick) 모두 데이터 표시 |

## 룰 보강 (별도 git commit — cloud 무관)

- `Doc/_rules_v2/hooks/sp-no-fake-data-extraction.md` 신규 hook — PKG/SP 가짜 구현 절대 금지 (NVL NULL / bare != 'Y' / DUMMY cursor 등 18 패턴 검출)
- 메모리 `feedback_sp_no_fake_extraction.md` 신규

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-05 | 초기 패키지 (`README.md`) |
| 2026-06-10 오전 | PROC_M O_RESULT_CURSOR boost + FE 4 grid 분리 (`_README_2026-06-10_PATCH.md`) |
| 2026-06-10 오후 | 6 사고 종합 fix + SHEET_COLUMNS NULL flag fix (`_README_2026-06-10_DEPLOY.md`) |
| **2026-06-11** | **PROC_M signature 정합 + menuId→mnuId + NVL EXCEPTION_FLAG fix (본 README)** |
