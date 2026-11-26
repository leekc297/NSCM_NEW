/**
 * ⭐ DMF0082 — DM Planner (W/S) 권한 분기 판정 (순수 함수 모음).
 *
 * 요구 원천 = 현업 요청 캡처 2026-07-31 (`[DM Planner(W/S) + 81]` / `[DM Planner + 81]` 2건):
 *   ① FCST Type 콤보 : **81 계열 + W/S** 만 A/S(Chargeable)·A/S(Free)·WS(Chargeable)·WS(Free)·
 *      Recall·RMA 6종(SALES_TYPE_CODE2 ∪ _ADD). 그 외(40 포함)는 SALES_TYPE_CODE 기준 전체 목록에서
 *      W/S 2종(AS 전용)만 뺀 목록 — 판정은 `isWsFcstTypeEditCombo`, 목록은 CMBO 'FcstType'.
 *   ③ Sales Site 콤보 : W/S 만 조회조건·Grid 양쪽에 **비축(AS)향 사이트** 포함.
 *   ④ Measure        : 비W/S + 81 은 `MKT_FCST`(라벨 'MKT FCST[R+P]') 만 사용 가능.
 *
 * ⚠️ AS-IS 원천에 대한 실측 기록 (2026-07-31, `DMF0082_FcstNPrice_Mgmt.cs` 667KB 전수):
 *   AS-IS **DMF0082 에는 W/S 판정 코드가 없다** (`W/S`·`as_yn`·`비축`·`FcstTypeWs` grep 0건).
 *   AS-IS 는 대신 `NowGroupID` 를 콤보 SP 에 넘겨 **SP 가 목록을 걸러** 같은 효과를 냈다:
 *     - `GetFcstType()` L9175  : UP_FX_GetCommonDataList_DM(CODE='FCST_TYPE', PARAM1=NowGroupID)
 *     - `GetSalesSite/40` L3473/L3502 : PARAM3=groupID, PARAM4=userId
 *   TO-BE 는 그 그룹ID 전달이 유실됐고, BE 는 CMBO SQL 에 `sesUserId`/`sesLangCd` 만 주입하므로
 *   (LookupServiceImpl L78~79) "SP 위임" 복원은 CMBO SQL 신규등록(=BE 작업)을 부른다.
 *   ⇒ 이미 DB 에 등록·가동 중인 DMF0003(MKT FCST) 콤보 3종을 재사용해 **FE 판정**으로 구현한다
 *     (BE 작업 0). 판정 지점을 이 파일 하나로 모아 그리드 컴포넌트 비대화를 막는다.
 *
 * 관련 구현 위치:
 *   - 판정값 주입 : `ForecastPrice.tsx` (CMBO 'MktFcstWsPlannerYn' → store.wsPlannerYn)
 *   - ①③ 콤보    : `ForecastPriceGrid.tsx` beginningEdit dataMap 스왑 / `ForecastPriceForm.tsx`
 *   - ④ measure  : `ForecastPriceGrid.tsx` measureDataMap.getDisplayValues
 */

/**
 * 비W/S 사용자에게 허용되는 유일한 편집 measure (81 계열 한정).
 * 코드 `MKT_FCST` = SCM_MST_SHEET_MEASURE 라벨 'MKT FCST[R+P]' (사내 메타 실측 2026-07-31).
 * ⚠️ 'MKT FCST[P+P]' 는 별도 코드 `MKT_FCST_PP` — 혼동 금지.
 */
export const WS_RESTRICTED_MEASURE = 'MKT_FCST' as const;

/** CMBO 'MktFcstWsPlannerYn' 응답(단일행 CODE='Y'/'N') → boolean. 미응답·0행 = false(권한 없음). */
export const parseWsPlannerYn = (rows: ReadonlyArray<{ CODE?: unknown }> | undefined): boolean => {
  const code = rows?.[0]?.CODE;
  return typeof code === 'string' && code.trim() === 'Y';
};

/**
 * measure 제한을 적용할 사업부인가 — 81 계열(81, 81_UC, 8110 …) 한정.
 *
 * ⚠️ 이 게이트는 **④(measure) 전용**이다. 40 사업부는 SCM_FCST·LOC·MKT_AMT_* 등을 정상 사용하므로
 *   division 게이트 없이 제한을 걸면 40 이 통째로 막힌다 (캡처도 `+ 81` 로 한정).
 *   ①(FCST Type)도 81 게이트를 쓰지만 **요건이 다르므로 함수를 합치지 않는다**
 *   (`isWsFcstTypeEditCombo` — 그쪽은 "W/S 전용 등록본을 쓸 자격", 여기는 "measure 를 좁힐 사업부").
 *   ③(Sales Site)만 division 게이트가 없다 — W/S Planner 그룹 자체가 81 조직이고, mkt-fcst 도
 *   그 컬럼은 W/S 여부만으로 판정한다(MktFcstGrid L765~773 wsOnly).
 */
export const isMeasureRestrictedDivision = (divisionId: string): boolean =>
  divisionId.trim().startsWith('81');

/**
 * ① FCST Type 편집 후보를 **W/S 전용 등록본**(CMBO 'FcstTypeEditMode' = SALES_TYPE_CODE2 ∪
 *   SALES_TYPE_CODE2_ADD 6종)으로 스왑할 자격인가 — **81 계열 사업부 + W/S Planner** 일 때만.
 *
 * 근거 = 현업 검수 캡처(FCST&PRICE MGMT / Div 40) + 사용자 확정 2026-08-05:
 *   · "SALES_TYPE_CODE2, SALES_TYPE_CODE2_ADD Lookup Code 는 **81, 81_Div 의 DM Planner(W/S)
 *      권한일 경우에만** 사용"
 *   · "40 Div 의 경우 FCST Type 에서 W/S(Chargable), W/S(Free) 항목은 안 보여야 함"
 *   · DM Planner(W/S) 권한은 애초에 40 을 쓰지 않으므로 40 에서 W/S 목록이 뜰 이유가 없다.
 *
 * ⚠️ 종전에는 division 게이트 없이 `wsPlannerYn` 단독으로 판정했다 — 그 결과 W/S 계정이 40 을
 *   조회하면 6종(W/S 2종 포함)이 그대로 스왑돼 캡처의 금지 항목이 노출됐다. 이 함수가 그 구멍을 막는다.
 *   자격이 없으면 호출측은 SALES_TYPE_CODE 기준 목록(CMBO 'FcstType')에서
 *   `filterFcstTypeCandidates` 로 W/S 2종을 뺀 후보를 쓴다.
 */
export const isWsFcstTypeEditCombo = (ctx: { wsPlannerYn: boolean; divisionId: string }): boolean =>
  ctx.wsPlannerYn && ctx.divisionId.trim().startsWith('81');

/**
 * ① 비W/S 사용자에게 **감춰야 할** FCST Type 인가 — WS(Chargeable) / WS(Free) 계열.
 *
 * 캡처 원문: "[DM Planner + 81] Fcst Type이 WS(Chargeable), WS(Free)가 등록이 불가능 (combo에 조회x)".
 * A/S 2종은 대상이 아니다 — 캡처가 WS 2종만 명시한다.
 *
 * ⚠️ 이 판정이 필요한 이유 (2026-07-31 실측):
 *   당초엔 "비W/S 는 편집 콤보 스왑을 생략하면 기존 표시 콤보에 WS 가 없다"고 봤으나, DMF0082 의
 *   admin 표시 콤보에는 **WS 2종이 포함되어 있어** 비W/S 계정에서 그대로 노출됐다.
 *   ⇒ 생략이 아니라 **명시적 제거**가 필요하다.
 *
 * 코드/라벨 어느 쪽으로 저장되든 걸리도록 둘 다 검사한다. 'A/S(...)' 는 선두가 A 라 매치되지 않고,
 * 'Sample(...)' 등도 무관하다.
 */
//   'WS(Chargeable)' / 'WS(Free)' / 'W/S(...)' / 'WS_C' 를 잡고, 뒤에 영숫자가 이어지는
//   무관한 코드('WSX' 등)는 잡지 않는다. 'A/S(...)'·'Sample(...)' 은 선두 문자가 달라 미매치.
const WS_ONLY_PATTERN = /^w\s*\/?\s*s(?![a-z0-9])/i;

export const isWsOnlyFcstType = (code: string, name: string): boolean =>
  WS_ONLY_PATTERN.test(code.trim()) || WS_ONLY_PATTERN.test(name.trim());

/**
 * ① FCST Type 편집 후보 필터 — WS 2종(= 캡처의 "AS 전용여부 Y 2건")을 뺀다.
 * 반환이 원본과 같은 길이면 뺄 것이 없었다는 뜻(호출측이 스왑을 생략해도 된다).
 *
 * ⚠️ `wsPlannerYn=true` 는 "원본 그대로" 지만, **호출측은 이제 항상 false 로 부른다** —
 *   W/S 자격 판정은 `isWsFcstTypeEditCombo`(81 계열 게이트 포함)가 상위에서 끝내고, 이 함수는
 *   그 자격이 없을 때의 목록(SALES_TYPE_CODE 기준)을 좁히는 데만 쓰이기 때문이다.
 *   인자는 mkt-fcst 계열 호출부와의 호환을 위해 남긴다.
 */
export const filterFcstTypeCandidates = <T extends { CODE?: string; NAME?: string }>(
  candidates: readonly T[],
  wsPlannerYn: boolean
): T[] => {
  const all = [...candidates];
  if (wsPlannerYn) return all;
  return all.filter(row => !isWsOnlyFcstType(row.CODE ?? '', row.NAME ?? ''));
};

/**
 * ② AS FROM SITE 관련 사업부 — 81 계열 + 82 (mkt-fcst MktFcst.tsx L501 동일 규칙).
 * ⚠️ measure 제한(isMeasureRestrictedDivision)은 81 만인 것과 다르다 — 82 는 measure 제한 대상이
 *   아니지만 AS FROM SITE 는 쓴다. 두 게이트를 하나로 합치지 말 것.
 */
export const isAsFromSiteDivision = (divisionId: string): boolean => {
  const div = divisionId.trim();
  return div.startsWith('81') || div === '82';
};

/**
 * ② AS FROM SITE 판정용 FCST Type 집합 — CMBO 'FcstTypeWs'(SALES_TYPE_CODE2) 응답 → Set.
 *
 * ⚠️ CODE 와 NAME 을 **둘 다** 넣는다. FCST_TYPE 셀에 저장되는 값이 콤보마다 갈리기 때문:
 *   이 화면의 표시 dataMap(admin cellCboDataTp)과 편집 스왑 콤보('FcstTypeEditMode')와
 *   판정 콤보('FcstTypeWs')가 서로 다른 등록본이라, 한쪽이 코드('WS_C')를 쓰고 다른 쪽이
 *   라벨('WS(Chargeable)')을 쓰면 CODE 만 비교했을 때 **영원히 매칭되지 않는다**.
 *   양쪽을 다 담으면 어느 표기로 저장돼도 판정이 성립한다 (오탐 위험은 없다 — 두 집합 모두
 *   W/S·A/S 4종에서 온 값이라 그 외 FcstType 과 겹치지 않는다).
 *
 * ⚠️ **셀 개방(ForecastPriceGrid)과 저장 검증(ForecastPrice.handleSave)이 반드시 같은 집합을 써야
 *   한다** — 2026-08-06 사고가 정확히 그거였다: 그리드는 CODE+NAME 을, handleSave 는 CODE 만
 *   담고 있었고 셀에 저장되는 값이 라벨이라 **컬럼은 노랗게 열리는데 MSG00476 은 영원히 안 떴다**.
 *   그래서 생성 로직을 이 함수 하나로 모은다 — 호출측에서 따로 만들지 말 것.
 */
export const buildWsFcstTypeSet = (
  rows: ReadonlyArray<{ CODE?: string; NAME?: string }> | undefined
): Set<string> => {
  const set = new Set<string>();
  for (const row of rows ?? []) {
    const code = (row.CODE ?? '').trim();
    const name = (row.NAME ?? '').trim();
    if (code) set.add(code);
    if (name) set.add(name);
  }
  return set;
};

/**
 * ② AS FROM SITE 셀을 편집 가능하게 열지 — mkt-fcst `isAsFromSiteEditable`(MktFcstGrid L337~341) 1:1.
 *
 * 조건: W/S Planner + 신규행(FCST Type 을 셋팅하는 행) + FCST Type 이 W/S·A/S 4종.
 * wsFcstTypes = CMBO 'FcstTypeWs'(SALES_TYPE_CODE2) 응답 — A/S(Chargeable)·A/S(Free)·
 *   WS(Chargeable)·WS(Free). 목록을 FE 에 하드코딩하지 않는다.
 */
export const isAsFromSiteEditable = (params: {
  wsPlannerYn: boolean;
  isInsertRow: boolean;
  fcstType: string;
  wsFcstTypes: ReadonlySet<string>;
}): boolean =>
  params.wsPlannerYn &&
  params.isInsertRow &&
  params.wsFcstTypes.has(params.fcstType.trim()) &&
  params.wsFcstTypes.size > 0;

/**
 * ② AS FROM SITE 값이 "없음"인가 — 공란 + 커서 placeholder `'-'`.
 *
 * ⚠️ `'-'` 를 반드시 함께 본다. DMF0082 조회 커서는 AS FROM SITE 빈값을 `'-'` 로 내려주고
 *   (2026-08-06 실측 로그), `ForecastPrice.handleInsert` 가 신규행에 시드 복사하므로 **화면상
 *   비어 보이는 신규행의 실제 값이 `'-'`** 다. `=== ''` 만 보던 검증이 여기서 통째로 빠져나가
 *   MSG00476 이 영원히 안 떴다.
 *   `'-'` 를 빈값 센티널로 보는 것은 이 화면의 기존 규약이다 —
 *   `forecast-price.groupMeasure.ts` 도 `'' | '-' | 'ALL'` 을 "제한 없음"으로 함께 취급한다.
 */
export const isAsFromSiteBlank = (value: string): boolean => {
  const v = value.trim();
  return v === '' || v === '-';
};

/**
 * ② 저장 전 AS FROM SITE 필수 위반인가 — mkt-fcst `MktFcst.tsx` L497~525 규칙 1:1.
 *
 * W/S Planner + 81 계열·82 + **고객향 사이트**(= AS(비축)향 사이트 목록에 없는 사이트) +
 * FCST Type 이 W/S 4종 + AS FROM SITE 공란 → 위반(MSG00476).
 * ⚠️ 비축향 사이트 자신은 대상이 아니다 — "고객향 사이트로 AS/WS 를 등록할 때" 출처 사이트를
 *   받는 것이 이 컬럼의 목적이기 때문.
 */
export const isAsFromSiteMissing = (params: {
  wsPlannerYn: boolean;
  divisionId: string;
  scmSiteId: string;
  fcstType: string;
  asFromSite: string;
  wsFcstTypes: ReadonlySet<string>;
  asSiteNames: ReadonlySet<string>;
}): boolean => {
  if (!params.wsPlannerYn) return false;
  if (!isAsFromSiteDivision(params.divisionId)) return false;
  const site = params.scmSiteId.trim();
  if (!site || params.asSiteNames.has(site)) return false; // 비축향 사이트 = 대상 아님
  if (!params.wsFcstTypes.has(params.fcstType.trim())) return false;
  return isAsFromSiteBlank(params.asFromSite);
};

/**
 * ⑤ 비축(AS) 입고요청 measure — 현업 검수 41번 "AS_In_Req = 81, 81_JV, 82 Div 에서만
 *   DM Planner(W/S) 권한일 경우에만 입력 가능".
 * 코드 표기는 mkt-fcst 와 동일한 `AS_In_Req` (MEASURE_FALLBACK L232 / MktFcstGrid L804 실측).
 */
export const AS_MEASURE = 'AS_In_Req' as const;

/**
 * ⑤ AS_In_Req 를 이 사용자·이 사업부에서 다룰 수 있는가 — **후보 노출과 셀 편집이 공유하는 단일 판정**.
 *
 * 근거: mkt-fcst `MktFcstGrid` L794~808 — "사이트 미정 + 비W/S + 81 계열·82 → AS_In_Req 제거(블랙리스트)".
 *   거기서 AS_In_Req 는 W/S 권한자의 measure 이고, 대상 사업부는 81 계열·82 다(=isAsFromSiteDivision).
 *
 * ⚠️ mkt-fcst 는 여기에 더해 **행의 Sales Site 로 후보를 단일화**한다(비축향 → AS_In_Req 만 /
 *   고객향 → MKT_FCST_RP 만). DMF0082 에는 그 규칙을 옮기지 않는다 — 41번 요건은 AS_In_Req 의
 *   노출 조건만 정하고, 같은 항목이 MKT_FCST[R+P]·SCM_FCST[R+P]·Unit Price(LOC) 를 룩업 기준으로
 *   함께 쓰도록 요구하기 때문이다. 사이트 단일화를 넣으면 비축향 사이트 행에서 그 3종이 사라진다.
 */
export const isAsMeasureAllowed = (ctx: { wsPlannerYn: boolean; divisionId: string }): boolean =>
  ctx.wsPlannerYn && isAsFromSiteDivision(ctx.divisionId);

/**
 * ⑥ VMI 입고요청 measure — 현업 검수 41번 "VMI_In_Req = 40, 82 Div 에서만 **권한과 무관하게**
 *   Sales Site 가 VMI = 'Y' 인 경우에만 입력 가능".
 */
export const VMI_MEASURE = 'VMI_In_Req' as const;

/** ⑥ VMI_In_Req 대상 사업부 — 40 계열 + 82. (81 계열은 대상 아님 = 항상 read-only.) */
export const isVmiMeasureDivision = (divisionId: string): boolean => {
  const div = divisionId.trim();
  return div.startsWith('40') || div === '82';
};

/**
 * ⑥ VMI_In_Req 셀을 열지 — **그룹 권한(drop3 measureAuth)과 무관하게** 이 함수가 단독 결정한다
 *   (41번 "권한과 무관하게"). 호출측은 이 measure 에 한해 measureAuth 검사를 건너뛴다.
 *
 * @param vmiYn 판정할 VMI 플래그. 조회행은 자기 행의 `VMI_YN`, **신규행은 같은 Sales Site 를 쓰는
 *   조회행에서 끌어온 값**을 호출측이 넘긴다 (신규행 자체에는 사이트 마스터 조인 결과가 없다).
 * @param vmiProvided 이번 조회 결과에 `VMI_YN` 컬럼이 실제로 존재했는가.
 *
 * ⚠️ `vmiProvided` 가 따로 필요한 이유 — 이 화면의 조회 커서 컬럼은 **컬럼 메타(UI Category Setup >
 *   Column)를 따라간다**(2026-08-05 실측: Div 40 정적 20컬럼 → 81 17컬럼, 화면에서 뺀 3개가 그대로
 *   응답에서도 사라짐). 즉 관리자가 VMI_YN 컬럼을 내리면 값이 통째로 안 온다.
 *   그때 'Y' 를 강제하면 40·82 의 VMI 행이 전부 잠겨 **기존 동작이 퇴행**하므로, 컬럼이 없는
 *   환경에서는 판정을 보류하고 사업부 게이트만 적용한다. 컬럼이 등록되는 순간 규칙이 자동으로 켜진다.
 */
export const isVmiMeasureAllowed = (params: {
  divisionId: string;
  vmiYn: WijmoPrimitive | undefined;
  isInsertRow: boolean;
  vmiProvided: boolean;
}): boolean => {
  if (!isVmiMeasureDivision(params.divisionId)) return false;
  // ① 컬럼 자체가 안 내려오는 환경 = 판정 불가 → 사업부 게이트만 (기존 동작 보존).
  if (!params.vmiProvided) return true;
  const raw = params.vmiYn;
  const text = raw === undefined || raw === null ? '' : typeof raw === 'string' ? raw : String(raw);
  // ② 컬럼은 오는데 이 행/사이트 값을 못 구한 경우 = 신규행에서 조회 결과에 없는 사이트를 고른 상황.
  //   조회행이면 데이터가 그렇다는 뜻이므로 차단, 신규행이면 판정 근거가 없으므로 통과시킨다
  //   (막으면 새 사이트로는 VMI 행을 아예 등록할 수 없는 막다른 길이 된다).
  if (text.trim() === '') return params.isInsertRow;
  // ③ 값이 있으면 신규행·조회행 구분 없이 'Y' 만 개방.
  return text.trim().toUpperCase() === 'Y';
};

/**
 * 그룹 룩업(GET_ADMIN_GROUP_MEASURE)으로 통제되는 measure — 현업 검수 41번의 앞 3종.
 * AS_In_Req / VMI_In_Req 는 룩업이 아니라 별도 규칙(⑤⑥)이 결정하므로 이 목록에 넣지 않는다.
 */
export const GROUP_AUTH_MEASURES = ['MKT_FCST', 'SCM_FCST', 'LOC'] as const;

/**
 * ⭐ measure 단위 셀 편집 가부 — 그리드 `canEditCell` 의 단일 원천 (현업 검수 41번 매트릭스 1:1).
 *
 *   MKT_FCST / SCM_FCST / LOC : GET_ADMIN_GROUP_MEASURE 룩업(drop3 measureAuth) 기준.
 *   AS_In_Req                 : 81 계열·82 + DM Planner(W/S). **룩업과 무관** — 권한 그룹이
 *                               AS_In_Req 를 안 내려줘도 W/S 면 열어야 한다(41번 원문).
 *   VMI_In_Req                : 40 계열·82 + Sales Site VMI='Y'. **"권한과 무관하게"**(41번 원문)
 *                               라 measureAuth 를 아예 보지 않는다.
 *   그 외 measure             : 항상 read-only (MKT_FCST_PP·BALANCE·FCST_GAP 등 계산/참조 컬럼).
 *
 * ⚠️ 시간축(bucket·기준주차·M+4) 잠금은 여기서 보지 않는다 — `isNonEditableCell` 의 책임이다.
 *   이 함수는 "이 measure 를 이 사용자가 다룰 수 있는가"만 답한다.
 */
export const isMeasureEditableByAuth = (params: {
  measure: string;
  divisionId: string;
  wsPlannerYn: boolean;
  /** GET drop3 GET_ADMIN_GROUP_MEASURE 결과 (key=MEASURE, value=EDIT_FLAG==='Y'). */
  measureAuth: Readonly<Record<string, boolean>>;
  /** 행 Sales Site 의 VMI 플래그. 신규행은 같은 사이트 조회행에서 승계한 값을 넘긴다. */
  vmiYn?: WijmoPrimitive;
  /** 이번 조회 결과에 VMI_YN 컬럼이 실제로 존재했는가 (컬럼 메타에서 내리면 값이 통째로 안 온다). */
  vmiProvided: boolean;
  isInsertRow: boolean;
}): boolean => {
  const measure = params.measure.trim();

  if (measure === AS_MEASURE) {
    return isAsMeasureAllowed({ wsPlannerYn: params.wsPlannerYn, divisionId: params.divisionId });
  }
  if (measure === VMI_MEASURE) {
    return isVmiMeasureAllowed({
      divisionId: params.divisionId,
      vmiYn: params.vmiYn,
      isInsertRow: params.isInsertRow,
      vmiProvided: params.vmiProvided,
    });
  }
  if (!(GROUP_AUTH_MEASURES as readonly string[]).includes(measure)) return false;
  return params.measureAuth[measure] !== false;
};

/**
 * ④⑤ 신규행 Measure 편집 후보 필터.
 *
 * 입력 candidates = 그룹 룩업(GET_ADMIN_GROUP_MEASURE)이 허용한 measure 쌍 목록.
 *   ⑤ AS_In_Req  : 81 계열·82 + W/S 가 아니면 **후보에서 제거**(41번).
 *   ⑥ VMI_In_Req : 40 계열·82 가 아니면 **후보에서 제거**(41번). 사이트 VMI='Y' 판정은 행 단위라
 *                  여기서는 못 한다 — 셀 개방 시 `isVmiMeasureAllowed` 가 마저 본다.
 *   ④ 비W/S + 81 계열이면 `MKT_FCST` 만 남긴다. 그 외(W/S 사용자, 또는 40 등)는 원본 유지.
 *
 * ⚠️ 필터 결과가 0건이면 **직전 목록을 그대로 돌려준다** — 드롭다운이 비어 아무것도 못 고르는 상태를
 *   만들지 않기 위함이며, mkt-fcst 의 `candidates.length > 0` 가드와 동일 규약이다
 *   (MktFcstGrid L809). 단 ⑤ 블랙리스트는 이 폴백에서 제외한다 — 권한 밖 measure 를 "후보가 비었다"는
 *   이유로 되살리면 통제가 풀린다.
 */
export const filterEditMeasures = <T extends { CODE?: string }>(
  candidates: readonly T[],
  ctx: { wsPlannerYn: boolean; divisionId: string }
): T[] => {
  const blocked = new Set<string>();
  if (!isAsMeasureAllowed(ctx)) blocked.add(AS_MEASURE);
  if (!isVmiMeasureDivision(ctx.divisionId)) blocked.add(VMI_MEASURE);
  const all = [...candidates].filter(row => !blocked.has((row.CODE ?? '').trim()));
  if (ctx.wsPlannerYn) return all;
  if (!isMeasureRestrictedDivision(ctx.divisionId)) return all;
  const restricted = all.filter(row => (row.CODE ?? '').trim() === WS_RESTRICTED_MEASURE);
  return restricted.length > 0 ? restricted : all;
};
