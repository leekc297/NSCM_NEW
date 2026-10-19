# SCP0111 통합 PSI (Integration PSI) — AS-IS ↔ TO-BE 매핑

AS-IS: `GSCM.SCP.Forms.UIL / SCP0111_IntegrationPSI` (WinForms, spdMain siMain 단일 그리드 + 서버측 동적 PIVOT)
TO-BE: `nscm-fe/features/supply/src/pages/integration-psi/`
설계 근거: `.atlas/gscm-design/SCP0111/design/00_checklist.md ~ 03_grid-columns.md` (DB 실측 PASS)

## 1. SP 매핑

| AS-IS 호출 | TO-BE SP (PKG_SCP0111, VALID) | TO-BE 배선 |
|---|---|---|
| 메인 조회 | `P_SCP0111_GET_INTEGRATION_PSI` (10 IN + O_RC[PIVOT] + O_RESULT_CURSOR) | `useTabProcQuery` SEARCH → API `P_SCP0111_GET` (버튼 SEARCH) |
| 일반 저장 | `P_SCP0111_SAVE_INTEGRATION_PSI` (20 IN, modiQty 가감) | `callSaveIntegrationPsi('GENERAL')` → 버튼 SAVE → API `P_SCP0111_SAVE` |
| ADMIN 저장 | `P_SCP0111_SAVE_PSI_ADMIN` (21 IN, +p_boh_qty) | `callSaveIntegrationPsi('ADMIN')` → 버튼 SAVEDETAIL → API `P_SCP0111_SAVE_ADMIN` |
| ESS Pack Line | `P_SCP0111_GET_ESS_PACK_LINE` (IN 0 + O_RC + O_RESULT_CURSOR) | 미배선 — 아래 §4 #3(configs Hard Boundary) |

## 2. 버튼(toolbarOverride) 매핑

AS-IS toolbarOverride 5종(00_checklist §4-B) + 공용 EXCEL + ADMIN 저장 분기.

| AS-IS 버튼 | TO-BE hotkeyConfig | 등록 MNU_BTN_CD | 비고 |
|---|---|---|---|
| FindButton | search=handleSearch | SEARCH | |
| SaveButton | save=hasButton('SAVE')?handleSave:false | SAVE / SAVEDETAIL | auth.isAdmin 로 SP 분기 |
| InsertButton | insert=hasButton('SAVE')?handleInsert:false | INSERT | V1/V2 신규행 |
| DeleteButton | delete=()=>undefined (NO-OP) | DELETE | AS-IS 본문 공백(cs:536-539) 무동작 재현 |
| EditButton | edit=hasButton('EDIT')?handleEdit:false | EDIT | 편집모드 토글 |
| (공용) Excel | — | EXCEL | 클라 다운로드 |

## 3. validation / expressions 매핑 (design 03 §5 — 15건)

AS-IS 번호를 그대로 두면 TO-BE 에서 다른 문구로 등록돼 오표시된다(hook#114). 아래 TO-BE 코드는
SCM_ADM_MSG_M 실측(2026-09-23, ora.py)으로 의미 일치 확정한 것이다(gap-resolve iter-1 D-DRIFT-2).

| AS-IS 규칙 | TO-BE 위치 | AS-IS MSG | TO-BE MSG (실측 EN) |
|---|---|---|---|
| 조회기간 from>to 금지 | Form 조회 전 | MSG00344(부재) | MSG00219 "Invalid period (start > end)." (PERIOD_RANGE) |
| 필수값 공백(15건) | unfoldSaveCells / 저장 전 | MSG00001 | MSG00013 "Please enter the required fields." (REQUIRED_FIELD) |
| OPERATION_GROUP NAME→CODE lookup 부재 | operationGroupToCode()==null | MSG00001 | MSG00013 (OP_GROUP_LOOKUP_MISSING) |
| 신규행 중복(INSERT_KEY_COLS) | isDuplicateInsertRow | MSG00260 | MSG00260 "Duplicate combination…" (DUPLICATE_ROW) |
| Line 미지정("-") 저장 확인 | handleSave confirm 게이트 | MSG00453(부재) | MSG01434 "Line 항목 미입력, 저장?" (LINE_REQUIRED) |
| 저장 성공 | callSaveIntegrationPsi ok | — | MSG00002 "Saved successfully." (SAVE_SUCCESS) |
| 저장 대상 변경 없음 | cells/payload 0 | — | MSG00004 "No changes to save." (NO_CHANGES) |
| 저장 실패 | callSaveIntegrationPsi !ok | — | MSG00003 "Failed to save." (SAVE_FAIL) |
| 대상 행 미선택 | handleInsert editMode 가드 | MSG00014 | MSG00014 "No row selected." (NO_ROW_SELECTED) |
| ESS 파생검증 D1/D2 불일치 경고 | (경고, 저장 미차단) | 리터럴 | SCP0111_DERIV_MISMATCH (비카탈로그 — 등가 코드 부재, 신규 채번 필요) |

주의: MSG00001("Would you like to save it?")·MSG00004("No changes to save.") 를 각각 필수입력·저장성공에
쓰던 직전 구현의 오지정을 교정한 것이다. MSG00344/MSG00453/DERIV 는 TO-BE 카탈로그 부재라 등가 코드로
대체(00344→00219, 00453→01434)했고, DERIV 는 등가 부재로 비카탈로그 key 유지(메타 소유자 채번 대상).

수정(M): preQty≠qty 셀만 modiQty=qty-preQty(가감). 신규(I): 조회기간 전 월 + BOH 절대값.
(design 03 §4-저장 cs:1233-1626 규칙 재현 — 상수 이식이 아니라 로직 재현.)

## 4. 미해소 gap (R3 — 블로커: 선행 activity / 사용자 결정 / configs Hard Boundary)

gap-resolve iter-1(2026-09-23) 재검증 결과. 각 항목 뒤 분류는 R3 사유다.

1. **UPPR_MNU_ID** — 05_register 는 'Supply_Plan' 추정. DB 실측 ora.py 로 SCM_ADM_MNU_M 부모 확정 필요 → 사용자/메뉴 소유자 결정(R3).
2. **SCM_ADM_PROC_M 파라미터 메타** — GET/SAVE/SAVE_ADMIN 3종 미등록. convert-sp 책임(ALL_ARGUMENTS 실측). FE payload camelCase 키가 COL_NM 과 일치해야 함(R3-선행).
3. **ESS Pack Line 셀콤보 분기 A(U-1)** — `P_SCP0111_GET_ESS_PACK_LINE` 은 IN 0 + O_RC/O_RESULT_CURSOR(ora.py 실측)라
   COMPANY_ID 는 PARAM 이 아니라 화면 클라 필터로 재현한다(그리드 lineDataMap 분기 A 로직은 이미 완성). 단 원천 데이터
   fetch 는 CMBO SQL_ID 부재(SCM_ADM_CMBO_SQL_M 0건 실측)로 `useTabProcQuery` aux 호출뿐이며, 이는
   `configs/types/procedures.d.ts` 등록이 필요하다 = **configs/** Hard Boundary(범위 밖) → R3(§5 스니펫에 등록 항목 추가).
4. **권한 CMBO(P-MED-2)** — AS-IS 는 세션 NowGroupID(ADMIN/SCM PI Admin/SCP Planner) 기준. SCP0111 전용 auth combo 미정의
   + session.groupId 유령 필드 → AuthContext safe default `{isAdmin:false,...}`. 항상 GENERAL 저장. auth 원천 확정은 사용자/convert-sp 결정(R3).
5. **DERIV_MISMATCH MSG 코드** — TO-BE 카탈로그 등가 코드 부재(실측). 비카탈로그 key + defaultValue 경고 유지. 신규 채번(메타 소유자) → R3.
6. **라벨 LBL 채번(D-DRIFT-1)** — Qty/From Month/To Month/CellItem ID 는 정확한 기존 LBL 코드 부재(실측). 현재 LBL00658/00666/00667/00768
   은 각각 "User Info"/"Only new rows can be deleted."/"No data to save."/"Seq" 로 오지정. Item ID(LBL00021="Material")는
   근사 대체 후보 LBL01142="Item" 존재하나 정확치 않음. 라벨 텍스트 신규 채번은 메타 소유자 책임(AI 문구 생성 금지) → R3.

## 4-a. iter-1 해소분 (R1 — 코드 수정 완료)

- **P-LOW-2** L7 모듈 반제품 예외: `useTabLookupQueries(['MULTI_CHILD_ITEM'])` → SEGMENT2 값 Set 배선(실측 2행). multiChildItems 빈 Set 제거.
- **P-MED-1** To월 HORIZON: `SCPPlanPeriod_SCP`(@planName/@divisionId) HORIZON_END_DATE 우선, 부재 시 산술 fallback.
- **D-DRIFT-2** MSG 오지정 교정: §3 표 참조(00001→00013, 00004 분리(성공 00002/변경없음 00004), 00344→00219, 00453→01434).

## 5. procedures.d.ts 배선 스니펫 (직접 수정 불가 — configs/** Hard Boundary)

`nscm-fe/configs/types/procedures.d.ts` 는 공유 레지스트리라 이 작업 범위 밖이다. 아래 항목을
config 소유자가 등록해야 call-proc 타입/파라미터 매핑이 완성된다. IN/OUT 는 PKG_SCP0111 ALL_ARGUMENTS
실측(convert-sp)으로 확정하되, FE payload 키는 다음 camelCase 로 보낸다(COL_NM 과 일치 필수):

- `P_SCP0111_GET_INTEGRATION_PSI` — IN 10 (조회조건) / OUT O_RC(PIVOT, response key `o_rc1`) + O_RESULT_CURSOR
- `P_SCP0111_SAVE_INTEGRATION_PSI` — IN 20: activeFlag, planType, divisionId, companyId, plantId,
  operationGroup, seqFlag, cellitemId, itemId, measure, toSite, lineId, valuationType, toProduct,
  incoterms, yyyymm, modiQty (이상 17 '^'delim 배열) + planStartYyyymmdd, userId (스칼라) [+ SP 내부 파생]
- `P_SCP0111_SAVE_PSI_ADMIN` — 위 20 + bohQty ('^'delim 배열) = 21

주의: 이 키셋은 `utils/integrationPsiSave.ts` buildGeneralPayload/buildAdminPayload 반환 키와 1:1이다.
SCM_ADM_PROC_M.COL_NM 이 확정되면 두 곳(여기 + save 빌더)이 함께 검증돼야 한다.
