# REPAIR SCP0122 — 2026-10-22 02:27:05

## 게이트 0회차 — BLOCK 38 / WARN 8
- ✗ M04 미구현: D00-2-002 §2 cboDivision / SelectedIndexChanged — 스텁만 생성 — 로직 이식 후 구현으로 @__asis-mapping__.md
- ✗ M04 미구현: D00-2-003 §2 cboPlanGroup / SelectedIndexChanged — 스텁만 생성 — 로직 이식 후 구현으로 @__asis-mapping__.md
- ✗ M04 미구현: D00-2-004 §2 spdMain / ComboSelChange — 스텁만 생성 — 로직 이식 후 구현으로 @__asis-mapping__.md
- ✗ M04 미구현: D00-2-005 §2 spdMain / CellClick — 스텁만 생성 — 로직 이식 후 구현으로 @__asis-mapping__.md
- ✗ M04 미구현: D00-4-001 §4 biz:CommonData.CommonDataList / — SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 @__asis-mapping__.md
- ✗ M04 미구현: D00-4-003 §4 SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT / SCP0122_GET_PLAN_ACTIVITY_MGMT — SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 @__asis-mapping__.md
- ✗ M04 미구현: D00-4-004 §4 SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT / SCP0122_SAVE_PLAN_ACTIVITY_MGMT — SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 @__asis-mapping__.md
- ✗ M07 커밋본에 있던 파일이 삭제됨: plan-activity-mgmt.types.ts — 골격 재생성으로 기능 유실 의심(git checkout -- 로 복원 후 병합, 저장소 C:\Projects\NSCM) @plan-activity-mgmt.types.ts
- ✗ M07 커밋본에 있던 파일이 삭제됨: utils/plan-activity-mgmt.util.ts — 골격 재생성으로 기능 유실 의심(git checkout -- 로 복원 후 병합, 저장소 C:\Projects\NSCM) @utils/plan-activity-mgmt.util.ts
- ✗ G02 As-is 엔드포인트 SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT 미구현 (SP 등록·배선 필요) 
- ✗ G02 As-is 엔드포인트 SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT 미구현 (SP 등록·배선 필요) 
- ✗ B23 registration.sql API 배선 = 사내 현행(proc_meta.csv) — SCP0122_PLAN_ACTIVITY_MGMT_ACTION → 'PKG_SCP0122.P_'(프로시저명 공란) — 그대로 적용하면 운용 중 배선이 바뀜(적용 금지 · register.json 정리) 
- ✗ T01 TS2322 Type 'string[]' is not assignable to type 'string'. @components\PlanActivityMgmtForm.tsx:46
- ✗ T01 TS2322 Type 'string' is not assignable to type 'string[]'. @components\PlanActivityMgmtForm.tsx:48
- ✗ T01 TS2344 Type 'SHEETS' does not satisfy the constraint '"main"'. @components\PlanActivityMgmtGrid.tsx:16
- ✗ T01 TS2344 Type 'SHEETS' does not satisfy the constraint '"main"'. @components\PlanActivityMgmtGrid.tsx:18
- ✗ T01 TS2344 Type 'unknown' does not satisfy the constraint 'WijmoRowItem'. @components\PlanActivityMgmtGrid.tsx:23
- ✗ T01 TS2344 Type 'SHEETS' does not satisfy the constraint '"main"'. @components\PlanActivityMgmtGrid.tsx:23
- ✗ T01 TS2344 Type 'SHEETS' does not satisfy the constraint '"main"'. @components\PlanActivityMgmtGrid.tsx:43
- ✗ T01 TS2322 Type 'MutableRefObject<FlexGrid<never> | undefined>' is not assignable to type 'MutableRefObject<FlexGrid<any> | undefined>'. @components\PlanActivityMgmtGrid.tsx:44
- ✗ T01 TS2322 Type 'MutableRefObject<EditTracker<unknown> | undefined>' is not assignable to type 'MutableRefObject<EditTracker<never> | undefined>'. @components\PlanActivityMgmtGrid.tsx:46
- ✗ T01 TS2344 Type 'SHEETS' does not satisfy the constraint '"main"'. @PlanActivityMgmt.tsx:19
- ✗ T01 TS2322 Type 'SHEETS' is not assignable to type '"main"'. @PlanActivityMgmt.tsx:34
- ✗ T01 TS2322 Type 'PlanActivityMgmtFilter | undefined' is not assignable to type '{ divisionId: string; planGroupId: string; prsCd: string; } | undefined'. @PlanActivityMgmt.tsx:36
- ✗ T01 TS2322 Type 'SHEETS' is not assignable to type '"main"'. @PlanActivityMgmt.tsx:43
- ✗ T01 TS2339 Property 'o_rc' does not exist on type 'NoInfer<ProcResponse<"SCP0122", Extract<keyof ProcessedProcedures[M], string>>>'. @PlanActivityMgmt.tsx:53
- ✗ T01 TS7006 Parameter 'item' implicitly has an 'any' type. @PlanActivityMgmt.tsx:53
- ✗ T01 TS2345 Argument of type 'FlexGrid<unknown>' is not assignable to parameter of type 'FlexGrid<WijmoRowItem>'. @PlanActivityMgmt.tsx:61
- ✗ T01 TS2345 Argument of type 'FlexGrid<unknown>' is not assignable to parameter of type 'FlexGrid<WijmoRowItem>'. @PlanActivityMgmt.tsx:67
- ✗ T01 TS2339 Property 'o_rc' does not exist on type 'NoInfer<ProcResponse<"SCP0122", Extract<keyof ProcessedProcedures[M], string>>>'. @PlanActivityMgmt.tsx:96

## Claude 1회차 (exit 0)
```
뜨리는 내용이었습니다: 시트명 오용, 프로시저명이 빈 ACTION 행, SHEET_COLUMNS 전량 삭제(편집 컬럼 `'M'` 소실), 상위 메뉴 `OPT`, 그룹 권한 2개만 재등록.
  - 사내 현행값 그대로의 미러로 바꿨습니다(DELETE·UPDATE 없음, 없는 행만 INSERT). register.json 도 같은 기준으로 정리했습니다.

### 남은 항목
| 항목 | 상태 | 사유 |
|---|---|---|
| `check.js --final` 직접 실행 | **ERROR(미실행)** | 명령이 권한 승인 대기로 막혔고, 이 세션은 승인할 수 없습니다. tsc/eslint(T01/L01)와 final 단계 M04·M06·M07 판정은 확인되지 않았습니다. 직접 실행해 주세요. |
| 미러 SQL DB 실행 검증 | **ERROR(미실행)** | `run_sql.py` 도 같은 이유로 막혔습니다. 사내에서는 모든 BLOCK 이 0행 변경이어야 정상입니다. |
| 골격 재생성본 디스크 백업 | 안 함 | 폴더 복사가 막혔습니다. 대조표에 쓸 내용만 병합했습니다. |
| 단위테스트 it.todo 28건 | 미전환 | 이번 범위(TODO 이식) 밖입니다. B20 은 통과했습니다. |
| e2e_plan.json 시트명 | 미확인 | register.json 처럼 `Plan Activity Mgmt` 로 추정돼 있을 수 있습니다. |
| 런타임(조회·저장 왕복) | 미검증 | 서버를 기동하지 않았습니다. |

FE 수정은 이 화면 폴더 안에서만 했고, 공용(shared/foundation)과 BE 는 바꾸지 않았습니다.

변경 파일:
- [PlanActivityMgmt.tsx](nscm-fe/features/supply/src/pages/plan-activity-mgmt/PlanActivityMgmt.tsx)
- [__asis-mapping__.md](nscm-fe/features/supply/src/pages/plan-activity-mgmt/__asis-mapping__.md)
- [SCP0122_registration.sql](Doc/gen/SCP0122/SCP0122_registration.sql)
- [register.json](Doc/gen/SCP0122/register.json)
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
```

## 게이트 1회차 — BLOCK 0 / WARN 0

**PASS** (WARN 0) — 1회 수선
