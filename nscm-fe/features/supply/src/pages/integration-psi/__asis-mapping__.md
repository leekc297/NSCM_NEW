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
| EditButton | (제거) | — | AS-IS SwitchLock 편집모드 토글. TO-BE 는 편집모드 없이 권한(auth)으로 셀 입력 여부를 바로 결정 → 버튼 미노출 |
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
| 대상 행 미선택 | (제거 — 편집모드 없음, INSERT 는 SAVE 권한으로 게이트) | MSG00014 | MSG00014 "No row selected." (NO_ROW_SELECTED, 현재 미사용) |
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

## 4-b. iter-2 해소분 (사용자 신고 2026-10-12 — 코드 수정 완료)

- **U-1 Model/NickName 입력칸 통합**: 사용자 지시로 두 검색칸을 `Model/Nickname` 한 칸으로 합치고 팝업을
  `master/materialByDivisionModal/MaterialByDivisionModal` 로 교체. 값은 `itemId` 한 축으로만 전송하고
  `nickName` 은 `''` 고정 — SP 가 nick 과 item 을 **AND** 로 걸기 때문이다(PKG_SCP0111 BODY L317~319 nick /
  L324~326 item). 같은 문자열을 양쪽에 넣으면 0건이 된다. (AS-IS 는 두 칸 분리 — 사용자 결정에 따른 의도적 차이)
- **U-2 `Qty < 0` 배치/정렬**: 검색영역 하단(`extraConditions`)으로 이동 + 표준 마크업(`Grid size={3}` +
  `FormItem label labelAlign='right'` + 단독 `Checkbox`)으로 교정. SSP0021 `Sum` 선례 동일.
- **U-3 Period 미바인딩**: 원인은 콤보 파라미터 **키 이름 불일치**. `SCM_ADM_CMBO_SQL_M` 의 `CalendarMonth`
  등록 SQL 이 `q.basis_yyyymm >= @param1 AND <= @param2` 인데 FE 가 `from`/`to` 로 보내고 있었다. BE
  `makeComboQuery` 는 `@키` 를 **요청 body 의 동명 키로 raw 치환**(bind 아님)하므로 치환이 일어나지 않아
  조회가 실패하고 월 목록이 비었다 → `param1`/`param2` 로 교정. 라벨은 CODE(YYYYMM)에서 `YYYY-MM` 으로
  직접 포맷(AS-IS cs L841~842 `ParseExact(..., "yyyy-MM")`), NAME(타임스탬프)은 쓰지 않는다.
- **U-4 Division 이 40 고정**: store 초기값이 `session.div ?? '40'` 이라 그 값이 옵션에 존재하는 한 교정
  effect(`!hasDivision`)가 걸리지 않아 40 에 고정됐다. AS-IS 는 cs:235 `setListBox` 로 DataSource 만 바인딩하고
  명시 지정(cs:237 `ControlValues = "81"`)은 **주석 처리**돼 있어 UsrCombo 가 첫 행을 자동선택한다 →
  초기값을 `''` 로 비워 첫 옵션이 바인딩되게 교정. 실측 첫 항목 = **81 Automotive Battery**
  (`Division_SCP` `ORDER BY A.ATTRIBUTE1`, EE(ATTRIBUTE3='EE') FE 제외 후). 메타 fetch 영향 없음 —
  `Integration PSI` 컬럼 24행·measure 7행 모두 `DIVISION_ID IS NULL` 이고 SP 필터가
  `P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL OR ...`(PKG_NSCM_UI_COM_MENU BODY L168/218/391) 다.

- **U-5 조회 전 기간 컬럼 미생성**: `buildPivotColumns` 가 **조회결과 행에서만** YYYYMM 을 유도해
  `rows.length === 0` 이면 `[]` 를 돌려줬다 → 화면 최초 진입·Period 지정 직후에는 고정 컬럼만 보였다.
  AS-IS 는 `Form_Load`(cs:174) → `CreateSpread`(cs:297) → `InitSpread`(cs:303) → `SetCalendar`(cs:334)
  순으로 **데이터와 무관하게** `cmbFromMonth`~`cmbToMonth` 구간을 `Data.Type.CalendarMonth` 로 열거해
  `AddNumColumn(..., width 75)`(cs:354)로 월 컬럼을 먼저 만들고, PlanDate 변경(cs:1862)·조회(cs:853) 때마다
  `InitSpread` 로 재생성한다. → `periodMonthRange(from,to)` 추가 + `buildPivotColumns` 를
  **기간 월 ∪ 행 YYYYMM 키** union 으로 변경하고 `IntegrationPsiGrid` 에 `fromYyyymm`/`toYyyymm` 전달.
  - 월 열거를 DB 왕복 없이 FE 산술로 하는 근거: `scm_sys_calendar_m.basis_yyyymm` 은 구간 내 결번이 없다
    (실측 202609~202712 → DISTINCT 16개월 = 달 수 일치) → 연속 월 증가 = DB 열거.
  - 행 키를 union 하는 이유: 조회 후 기간을 좁히면 응답에 있는 월이 컬럼을 잃어 데이터가 은폐된다.
  - 단위테스트 `utils/integrationPsiColumns.test.ts` 9건(연도 경계·역순·형식불량·union·고정컬럼 배제).

- **U-6 Period → SCP 공통 `PeriodRangePicker`**: 사용자 지시로 월 콤보 2개를
  `packages/shared/src/components/molecules/periodRangePicker/PeriodRangePicker.tsx` 로 교체
  (같은 feature 의 capa-mobility-it / production-plan / safety-stock / shipment-plan-fg 등과 동일 사용법).
  - **단위 환산**: 컴포넌트 값은 `YYYYMMDD`(일)인데 조회 param 은 `p_from_yyyymm`/`p_to_yyyymm`(월)이다.
    store 는 SP 계약대로 YYYYMM 을 유지하고 경계에서만 환산한다 — `start`=해당월 1일, `end`=해당월 **말일**
    (`Date.UTC(y, m, 0)`), 되돌려받은 값은 `slice(0,6)`.
  - **표기 = `YYYY-MM`(사용자 지시 2026-10-13)**: 공통 컴포넌트에 opt-in 프롭 `monthOnly` 를 추가했다
    (`packages/shared/.../PeriodRangePicker.tsx`). 기본값 false 라 이 컴포넌트를 쓰는 다른 12개 화면은 영향 없다.
    `monthOnly` 는 (1) 표기를 `YYYY-MM` 로 줄이고 (2) OK 확정값을 **월 경계**(시작월 1일 ~ 종료월 말일)로
    정규화한다. 정규화가 필요한 이유: 표기에 일자가 안 보이는데 값이 09-17~02-03 이면 표기와 값이 어긋난다.
    값 계약(start/end/onChange = YYYYMMDD)은 불변 — 소비자가 앞 6자리만 취한다.
    남은 차이: 달력 패널은 여전히 **일 셀**을 보여준다(클릭한 일자가 속한 달이 선택된다). 월 셀만 보이는
    패널로 바꾸려면 MonthPanel 재설계가 필요해 범위 밖으로 뒀다.
  - **divergence(상한 소실)**: AS-IS 는 월 목록을 HORIZON_END_DATE 까지만 바인딩해 그 이후 월을 **고를 수 없었다**
    (cs:267~278 + cs:287~291). 자유 달력에는 min/max 가 없어 `SCPPlanPeriod_SCP`(HORIZON_END) 조회와
    `CalendarMonth` 월목록 조회를 함께 제거했다(iter-1 **P-MED-1 되돌림**). 상한 밖 월을 골라도 SP 는 빈 컬럼을
    돌려주므로 오류는 아니다. 제약을 되살려야 하면 `onChange` 클램프가 필요하다 — SQL_ID·파라미터 계약은
    `COMBO.CALENDAR_MONTH`/`COMBO.SCP_PLAN_PERIOD`·`PERIOD_LIST_FALLBACK_MONTHS` 에 주석으로 남겼다.
  - **초기 선택 로직 변경**: 종전엔 "월 콤보 옵션에 현재 값이 없으면 기본값"이었는데 옵션 목록이 사라져
    `[fromMonth, periodMonth]` 변화 시 재설정으로 바꿨다. AS-IS 도 PlanDate 변경 시 `SetChangedPeriod` 로
    무조건 재설정한다(cs:1859 → cs:293~294). 사용자가 달력으로 고친 값은 PlanDate 가 바뀔 때까지 유지된다.
  - 삭제: `components/IntegrationPsiForm.module.scss`(Period 전용 `.periodField`/`.periodSeparator` 뿐이라 전부 사용處 소멸).

- **U-7 Insert 가 선택행 품목정보를 복사하지 않았다**: AS-IS `InsertRow` 비-ADMIN 분기(cs:986~1058)는
  현재 선택행(`_currRowIdx`, CellClick cs:1722)에서 **식별필드 17건을 복사**하고 고정값 5건을 얹는다
  (합 22건 = `defaultData.Add` 목록 cs:1027~1049). TO-BE 는 고정값 5건만 넘기고 있었다.
  - **원인**: 기존 주석이 "`addRow` 가 앵커행을 복사하므로 고정값만 override 로 넘긴다"고 했는데 **사실이 아니다**.
    `GridAction.addRowSet` 은 `{ ...defaultCopyProps, CRUD_TYPE: 'I' }` 로 **넘긴 값만** 넣고
    앵커는 삽입 *위치* 계산(`resolveInsertAnchor`)에만 쓴다(`packages/foundation/src/utils/gridAction.ts`).
    파라미터 이름이 `defaultCopyProps` 라 복사처럼 읽히는 함정이다.
  - **수정**: `INSERT_COPY_COLS` 17건을 앵커행에서 명시 복사 → 고정값이 덮도록 spread 순서 배치.
    복사: PLAN_TYPE, DIVISION_ID, OPERATION_GROUP, CELL_MODEL_NICK_NAME, CELL_ITEM_ID, NICK_NAME,
    ITEM_ID, CELL_CF, COMPANY_ID, PLANT_ID, VALUE_TYPE, TO_PRODUCT, TO_SITE, INCOTERMS, UOM,
    PLANT_ID_DESCRIPTION, TO_SITE_DESCRIPTION. 고정: MEASURE_LABEL='Prod Plan', MEASURE='PROD_PLAN',
    LINE_ID='-', BOH_QTY=0, SEQ_FLAG=앵커 SEQ_FLAG[0]+'50'(cs:1020~1021).
  - 컬럼명 전건이 `SCM_MST_SHEET_COLUMNS`('Integration PSI') 24행과 1:1 대응함을 실측 확인(2026-10-13 ora.py).
  - ADMIN 분기(V1, cs:967~976)는 AS-IS 도 DIVISION_ID 만 넣으므로 그대로 뒀다. 현재 `auth.isAdmin` 은
    전용 권한 콤보 미확정으로 false 고정이라(§4 R3) 실동작은 V2 다.

- **U-8 Delete = 미저장 신규행만 삭제(사용자 지시 2026-10-13)**: AS-IS `DeleteButton()` 은 **본문이 비어 있다**
  (cs:536~539) → AS-IS 에서 Delete 는 아무 일도 하지 않는다(사용자 관찰과 일치). TO-BE 는 지시에 따라
  `CRUD_TYPE='I'` 행(Insert 후 Save 전)만 제거한다.
  - `GridAction.removeRow(grid, deleteOnlyNew=true)` 사용 — 저장된 행에 'D' 마킹을 남기지 않는다.
  - **저장된 행을 지우지 않는 것은 선택이 아니라 제약**이다: SAVE SP 에 행 삭제 경로가 없다.
    `action` 은 `'I'|'M'` 뿐이고 `activeFlag` 는 'Y' 고정이며, `PKG_SCP0111` BODY 의 `DELETE` 문 16건은
    전부 `GT_*` 전역임시테이블 정리다(2026-10-13 ora.py 실측). 'D' 를 마킹하면 화면에서만 지워진 듯 보이고
    저장되지 않는 상태가 된다.
  - 저장된 행만 선택한 경우 무반응 대신 안내한다 — `MSG00608`(KO "신규 입력 (Insert) 한 행만 삭제할 수 있습니다." /
    EN "Only newly inserted rows can be deleted." / CN 3언어 `USE_YN='Y'` 실측). 신규 채번 없이 기존 코드 재사용.
  - 게이트는 Insert 와 동일한 `hasButton('SAVE')` — 권한이 없으면 Insert 자체가 불가해 지울 신규행도 없다.

- **U-9 모든 셀이 편집 불가였다(사용자 신고 2026-10-13 "값이 수정이 안 된다")**
  - **원인(공용 그리드 컬럼레벨 게이트)**: 공용 DataGrid 는 `setEditableColumns`
    (`packages/shared/.../data-grid/dataGridUtils.ts:371~393`)에서 `beginningEdit` 에 핸들러를 먼저 걸고
    `cancel = !GridUtils.isEditableCell(...)` 을 세운다. `isEditableCell`(`gridUtils.ts:80~106`)은
    `INPUT_TP_CD='S'`(SEARCH_ONLY)를 **무조건 false** 로 돌린다. wijmo Event 는 등록 순서대로 호출하고
    (DataGrid.tsx:1527 주석) 화면 핸들러는 `cancel` 을 true 로만 세우므로 한번 취소된 편집은 되살아나지 않는다.
    - 기간(YYYYMM) pivot 컬럼: 코드가 `_inputEditType: SEARCH_ONLY` 로 만들고 "편집가능 셀은 beginningEdit 가
      명시 해제"라고 주석했는데 **구조적으로 불가능한 설명**이었다.
    - 고정 24컬럼: `SCM_MST_SHEET_COLUMNS`('Integration PSI') **전건 `INPUT_TP_CD='S'`**(2026-10-13 ora.py 실측)
      → `BOH_QTY`·`LINE_ID` 도 함께 막혀 있었다.
  - **FE 수정**: `buildPivotColumns` 의 `_inputEditType` → `OPTIONAL`. 실제 잠금은 그리드 `beginningEdit` 의
    L2~L23 규칙(`isPivotCellLocked`)이 행단위로 판정한다. `OPTIONAL` 이 통과하는 근거는 `isEditableCell` 의
    OPTIONAL 분기가 `EDIT_FLAG <> 'N'` 인데 GET SP 가 EDIT_FLAG 를 반환하지 않기 때문이다
    (PKG_SCP0111 전문 EDIT_FLAG 0건 실측 → `undefined !== 'N'` → true).
  - **붙여넣기 비대칭 차단**: 공용 DataGrid 는 `pastingCell` 에도 컬럼레벨만 보는 같은 핸들러를 건다
    (`dataGridUtils.ts:391`). 기간 컬럼을 OPTIONAL 로 열면 `beginningEdit` 로 막은 잠금셀이 Ctrl+V 로는
    열리는 구멍이 생긴다 → 판정을 `isCellEditable` 로 추출해 `beginningEdit` · `pastingCell` 양쪽에 동일 적용.
  - **DB 메타(사용자 실행 대기)**: `BOH_QTY`·`LINE_ID` 는 메타 주도라 SQL 이 필요하다. 기존 운영 행 UPDATE 라
    **CORE-08 / META-13 / decisions R15** 에 따라 Claude 는 작성만 하고 사용자가 실행한다 →
    `.atlas/gscm-design/SCP0111/design/08_fix_editable_input_tp_cd.sql`(+`_rollback.sql`).
    `BOH_QTY`→`'O'`, `LINE_ID`→`'IO'`(= `EDIT_FLAG<>'N' AND CRUD_TYPE='I'`, 화면의 신규행 전용 규칙과 일치).
    영향범위는 PROGRAM_ID='SCP0111' / SHEET_NAME='Integration PSI' 2행뿐(동명 시트 0건 실측).
  - **남는 순서 의존**: 위 SQL 적용 후에도 `BOH_QTY` 는 계속 잠긴다 — 행단위 판정
    `isBohCellEditable` 이 `isBohEditableAuth(auth)` 를 요구하고 `auth` 는 전용 권한 콤보 미확정으로
    `{isAdmin:false,isPiAdmin:false,isPlanner:false}` 고정이다(§4 R3). auth 확정이 선행 조건이다.
    `LINE_ID` 는 SQL 적용만으로 신규행에서 열린다 — **U-7 Insert 복사와 짝**이다(Insert 가 `LINE_ID='-'` 를
    넣는데 편집이 막혀 있으면 Line 을 영원히 못 고르고 저장 시 MSG01434 를 벗어날 수 없다).

- **U-10 Insert 행의 Line 셀콤보가 안 뜬다(사용자 신고 2026-10-13)**
  - **AS-IS 동작**: `spdMain_CellClick`(cs:1720~1794)에서 `action=='I'`(신규행)이고 클릭 컬럼이 `LINE_ID` 일 때만
    후보를 만들어 `SheetUtils.SetComboDataRow(siMain, e.Row, LINE_ID, dtLine, true)`(cs:1790)로 **행단위 셀콤보**를 붙인다.
    분기 A(div 82 & opGroup 'P') = `dtEssPackLineAll` COMPANY_ID 필터(cs:1758~1765) /
    분기 B(그 외) = `dtLineAll` PLANT_ID + SHOP_GROUP_ID 필터(cs:1769~1775).
    이어서 **NAME 을 CODE 로 덮고**(cs:1779~1782) `"-"` 행을 맨 앞에 **DataTable 에 삽입**한다(cs:1784~1788).
  - **1차 원인(미해소 — 사용자 실행 대기)**: `LINE_ID` 의 `INPUT_TP_CD='S'` 라 공용 DataGrid 가 셀 편집 자체를
    취소한다(U-9 와 같은 경로). 셀이 편집모드로 들어가지 못하면 드롭다운도 뜨지 않는다.
    → `08_fix_editable_input_tp_cd.sql` 이 `LINE_ID`→`'IO'` 로 바꾼다. **이 SQL 실행이 선행조건이다.**
  - **2차 원인(FE 결함 3건 — 수정 완료)**: SQL 만 적용해도 아래 때문에 정상 동작하지 않았다.
    1. **sentinel `"-"` 가 DataMap 컬렉션에 없었다.** 라벨 목록에만 `LINE_ID_EMPTY` 를 끼워 넣어
       `DataMap.getKeyValue('-')` 가 컬렉션에서 못 찾는다 → `"-"` 를 골라도 값이 되돌아오지 않는다.
       신규행 기본값이 `"-"` 이고 저장검증이 `LINE_ID==='-'` 로 MSG01434 를 띄우므로 반드시 왕복해야 한다.
       → AS-IS cs:1784 처럼 **실제 행으로** 컬렉션에 넣고 라벨에서는 한 번 걸러 중복을 막았다.
    2. **표시문자열이 AS-IS 와 달랐다.** 콤보 SQL 은 `NAME = LINE_ID || ' ' || LINE_NAME`
       (`SCM_ADM_CMBO_SQL_M` 'LineByOperationPlantId_SCP_ALL' 실측)인데 AS-IS 는 NAME 을 CODE 로 덮는다
       → `toCodeLabeled` 로 NAME:=CODE 적용(코드만 표시).
    3. **라인 원천이 비면 `null` 을 반환해 dataMap 자체를 안 붙였다**(`if (all.length === 0) return null`).
       AS-IS 는 후보 0건이어도 `"-"` 한 건으로 콤보를 만든다 → sentinel 상주로 항상 dataMap 을 돌려준다.
  - **DB 실측(2026-10-13)**: 분기 B 원천은 정상 — `SCM_LINE_HIERARCHY_CPS_V_SN` 기준 1358 라인 / 28 plant /
    opGroup 5종(A 372·B 213·E 313·F 330·P 130). 즉 후보 데이터 부족이 원인은 아니다.
  - **분기 A 는 여전히 R3(불가)**: ESS Pack 외주라인 원천이 **DB 에 아예 없다** —
    `ALL_OBJECTS` 에 `%ESS_PACK_LINE%` 0건, `SCM_ADM_CMBO_SQL_M` 에 ESS/외주 계열 SQL_ID 0건.
    따라서 `essPackLineRows={[]}` 유지가 맞다. division 82 + Pack 신규행은 `"-"` 만 뜬다(메타 등록 선행).
  - `LINE_ID` 를 `CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'` 로 등록하지 **않는다** — 공용 DataGrid 의
    메타 콤보 경로는 `cellCtrlObjTpCd===COMBO && cellCboDataTp` 를 둘 다 요구하고(DataGrid.tsx:1156~1160),
    등록하면 화면이 붙인 행단위 dataMap 을 메타 dataMap 이 덮는다. insert-only-combo-hardcode 규약 유지.

- **U-11 저장이 아무 행도 넣지 않았다 — `P_ACTIVE_FLAG` 가 action 판별자였다(사용자 신고 2026-10-13)**
  - **원인**: SP 는 별도 action 파라미터가 없다(`P_SCP0111_SAVE_INTEGRATION_PSI` IN 19개 — ALL_ARGUMENTS 실측).
    셀별 I/M 은 **`P_ACTIVE_FLAG` 토큰**으로 전달된다:
    `L725 V_ACTIVE_FLAG := F_TOKEN(T_ACTIVE_FLAG, V_MST_LOOP_CNT)` →
    `L751 IF V_ACTIVE_FLAG = 'I' THEN ... INSERT(L755) ... L810 END IF`(일반) /
    `L3325 = 'I'` · `L3359 = 'M'` · `L3384 ELSIF = 'I'`(ADMIN).
    FE 는 `baseCell` 에서 `activeFlag: 'Y'` 를 **고정 전송**했고 `SaveCell.action` 은 계산만 하고
    `buildGeneralPayload` 가 payload 에 넣지 않았다 → 'Y' 는 'I' 도 'M' 도 아니라 **INSERT 분기 미통과**.
  - **수정**: `activeFlag: join(c => c.action)`. 중복 필드 `SaveCell.activeFlag` 는 재발 방지로 **제거**하고
    `action` 을 단일 원천으로 삼았다. 회귀테스트 `utils/integrationPsiSave.test.ts` 7건
    (특히 "activeFlag 는 셀별 action 을 ^ 로 이어 보낸다 — Y 고정 금지", 토큰 수 일치 검증).
  - **부작용 — 재고만 어긋났다**: 재고 재계산 UPDATE 는 ACTIVE_FLAG 와 무관하게 무조건 돈다
    (`L899 ELSIF V_MEASURE='PROD_PLAN'` → `L921 UPDATE ... SET QTY = ROUND(QTY + V_MODI_QTY,0)`
    `L929 AND MEASURE='INV' AND YYYYMM >= V_YYYYMM`). 이 WHERE 는 계획행 UPDATE(L906)보다 느슨해
    LINE_ID·SEQ_FLAG 를 보지 않는다 → **계획행 0건 갱신인데 INV 는 움직였다.**
    실측: 12:20:28 에 `MEASURE='INV'` 26행/2아이템만 갱신, 다른 measure 0건.
    두 아이템은 PLAN_START='20260810' 버전에 INV 13행만 있고 유입·유출 measure 가 없어
    정상값은 `QTY = BOH_QTY` 인데, BOH 와의 차이가 `1배/2배`로 정확히 누적돼 있었다
    (AAEF −103/−206, ACEF +100/+200 = `QTY+delta` 를 `>=202608`·`>=202609` 로 두 번 적용한 지문).
    → 데이터 교정 SQL **사용자 실행 대기**: `.atlas/gscm-design/SCP0111/design/09_fix_inv_qty_after_failed_save.sql`
    (+rollback, 대상 24행, `QTY := BOH_QTY`).
    **순서 주의**: 재고를 먼저 되돌리지 않고 같은 편집을 재저장하면 INV 가 한 번 더 가감된다.

- **U-12 신규행에서 기간(월) 수량이 입력돼선 안 된다(사용자 확인 2026-10-13)**
  - **AS-IS**: `InsertRow` 가 삽입한 그 행에 곧바로 두 범위를 잠근다 —
    `cs:1054 LockRange(insCell, PLAN_TYPE .. VALUE_TYPE, true)` +
    `cs:1057 LockRange(insCell, TO_SITE_DESCRIPTION .. GetMaxColumnIndex(), true)`.
    마지막 컬럼은 `SetCalendar`(cs:354 `AddNumColumn`)가 뒤에 붙인 **YYYYMM 월 컬럼**이라 두 번째 범위가
    수량칸을 전부 삼킨다(BOH_QTY·UOM·SEQ_FLAG·MEASURE·PLANT_ID·TO_SITE 포함).
    메타 SORT_ORDER 실측(PLAN_TYPE 10 … VALUE_TYPE 120 / **LINE_ID 130** / TO_SITE_DESCRIPTION 140 …)상
    **두 범위 사이에 남는 칸은 `LINE_ID` 하나뿐**이다. ADMIN(cs:976)은 `DIVISION_ID` 만 잠근다.
    AS-IS 워크플로: Insert → Line 선택 → Save → 재조회 → **그때 수량 입력**(저장행은 L2~L23 규칙 적용).
  - **TO-BE 결함**: `isPivotCellLocked`(저장행 규칙 L2~L23)만 돌려 신규행 월 셀이 열려 있었다 — AS-IS 보다 느슨.
  - **수정**: `isInsertRowCellEditable(binding, auth)` 추가(`integrationPsiEditLock.ts`) +
    `isCellEditable` 에서 `CRUD_TYPE==='I'` 를 **가장 먼저** 분기. 저장행 LINE_ID 는 `false`
    (AS-IS 도 cs:550 `LockColumn(PLAN_TYPE..INCOTERMS)` 범위에 들어 잠긴다).
    테스트 `utils/integrationPsiEditLock.test.ts` 5건(월 셀·식별열 잠금 / Planner 는 일반 규칙 / ADMIN 예외).
  - **U-11 사고의 구조적 예방**: 월 셀이 잠기면 `unfoldSaveCells` 의 신규 `modiQty` 가 전부 0 이 되어
    SP 의 무조건 INV 재계산(`L921`)이 재고를 흔들 수 없다. 즉 이 수정은 파리티 교정이면서 재발 방지다.

- **U-13 신규 등록이 불완전했다 — 삽입 월 범위 + 'BOH' 쓰레기 행(사용자 신고 2026-10-13)**
  - U-11 수정으로 `PROD_PLAN` 행이 **들어가기는 했다**(실측 13:18~13:25 4세트 × 7행). 그런데 둘이 틀렸다.
  - **(1) 삽입 월 범위**: AS-IS 는 `dtToMonth = Data.Common(CalendarMonth, plan_start월, this._toDate월)`
    (cs:1510~1511)로 **Plan 전체 개월수**를 만들고 그 월을 전부 루프한다(cs:1514~1537).
    `_toDate` 는 `SCPPlanPeriod` **HORIZON_END_DATE**, 부재 시 `plan_start+11월`(cs:267~278).
    TO-BE 는 `gridPeriodMonths()`(화면 조회기간의 렌더 컬럼)를 썼다 → **행이 모자라게 생성**.
    실측: 세트마다 6개월(202608~202701)만 생성. 정상은 PLAN_START=20260810 → 13개월(202608~202708),
    20260817 → 20개월(202608~202803).
    → `insertTargetMonths(planStartYyyymmdd, horizonEndYyyymmdd)` 추가(`integrationPsiSave.ts`),
    `IntegrationPsi.tsx` 에 `SCPPlanPeriod_SCP`(`@planName`/`@divisionId`) 조회를 **저장 경로 전용**으로 배선.
    (화면 기간 입력은 공통 PeriodRangePicker 라 상한을 쓰지 않는다 — U-6 에서 제거한 그 쿼리를 용도만 바꿔 되살린 셈이다.)
  - **(2) `YYYYMM='BOH'` 쓰레기 행**: FE 가 신규행에 BOH 전용 셀(`yyyymm:'BOH'`)을 끼워 보내 SP INSERT(L755)가
    그 리터럴을 YYYYMM 컬럼에 넣었다. AS-IS 신규 경로에는 BOH 토큰이 **없다**(일반 저장 payload 에 `p_boh_qty`
    자체가 없고 ADMIN 저장만 보낸다). 조회는 YYYYMM 범위로 걸러 안 보여주므로 **보이지 않는 쓰레기**가 된다
    (실측 전역 4행 = 이 4세트가 전부). → 신규행 BOH 셀 push 제거.
  - **(3) 함께 고친 잠재 결함**: BOH **수정**셀의 yyyymm 도 리터럴 'BOH' 였다. AS-IS 는
    `AppendString(ref p_yyyymm, p_plan_start_yyyymmdd.Substring(0,6), iCount)`(cs:1577) 즉 **plan start 월**이다.
    BOH 편집이 auth 로 막혀 있어 드러나지 않았을 뿐 같은 쓰레기 행을 만들 경로였다.
  - **재고는 안전했다**: 같은 시각대 `MEASURE='INV'` 갱신 0건 — U-12(신규행 월 셀 잠금)로 `modiQty` 가 전부 0 이라
    SP 의 무조건 INV 재계산이 돌 여지가 없었다. U-12 가 U-11 재발을 실제로 막았음이 확인됐다.
  - **데이터 정리(사용자 실행 대기)**: `.atlas/gscm-design/SCP0111/design/10_cleanup_incomplete_insert_rows.sql`
    (+rollback) — 28행 삭제. 전건 QTY=0 이라 수량 손실 없음. 백업 테이블 생성 단계 포함.
  - 회귀테스트 `utils/integrationPsiSave.test.ts` 12건(HORIZON 20개월 / BOH 셀 미포함 / BOH 수정셀 = plan start 월 /
    HORIZON 부재 시 +11월 fallback).

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
