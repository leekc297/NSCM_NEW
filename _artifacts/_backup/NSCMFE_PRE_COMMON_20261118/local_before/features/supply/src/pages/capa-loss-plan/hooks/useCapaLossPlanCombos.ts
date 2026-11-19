import { useEffect, useMemo } from 'react';

import { useTabComboQueries } from '@shared/hooks';

import {
  COMBO,
  DIVISION_TYPE,
  MENU_ID,
  OPERATION_WHITELIST_LOOKUP_TYPE,
  SHOP_GROUP_ID,
} from '../capa-loss-plan.constants';
import type { ComboOption, ComboRow } from '../capa-loss-plan.types';
import { useCapaLossPlanStore } from '../useCapaLossPlanStore';
import {
  buildDivisionOptions,
  buildBuildingOptions,
  buildLineOptions,
  buildLineTypeOptions,
  buildOperationOptions,
  buildOperationWhitelist,
  buildPlantOptions,
  buildProgressStatusOptions,
  buildSiteOptions,
  buildVersionOptions,
  buildVersionSeqOptions,
  deriveCurrProgressStatus,
  derivePlanType,
  expandMultiSelect,
  needsOperationWhitelist,
} from '../utils/capaLossPlan.combos';

/**
 * 조회조건 콤보 5종 + cascade 파생값의 단일 출처.
 *
 * cascade 형태(design 02 §3): **서버 재조회는 `divisionType` 1건뿐**이고 나머지 11개 이벤트는
 * 전부 클라 필터다(마스터/버전/상태 결과셋을 좁히기만 한다 — 서버 왕복 0회, F-19).
 * `divisionType` 은 마스터 comboId 자체(`CapaLineMaster_SCP_ALL` <-> `CapaLineMasterEE_SCP_ALL`)를
 * 바꾸므로 react-query 키가 갈라져 자동 재조회된다.
 *
 * **SCP0105 와 다른 점**(02 §0 — 복사 사고 방지):
 *   #2 Status 3중 필터식이 다르다        -> `buildProgressStatusOptions`
 *   #3 Status 기본선택이 "마지막 항목"   -> 아래 effect
 *   #4 Operation 에서 `AFFFF` 미제외     -> `buildOperationOptions`
 *   #5 Operation 화이트리스트(고유)      -> `buildOperationWhitelist`
 *   #6 Line Type 원천이 **마스터 1개**   -> `buildLineTypeOptions` (별도 콤보 호출 없음)
 *   #7 Item 파라미터가 `p_nick_name`     -> `buildGetPayload`
 *   #8 `p_sheet_name` 이 8값             -> 호출부가 시트를 넘긴다
 *
 * 페이지가 이 훅을 1회 호출해 Form 에 내려준다 — 조회(F5) 시 payload 전개에 후보 목록이 필요해서다
 * (무선택 = 후보 전체 CODE 전개, 02 §3.4). 콤보 결과를 store 에 담지 않는다(서버 데이터 SSOT).
 */
export interface CapaLossPlanCombos {
  divisionOptions: ComboOption[];
  versionOptions: ComboOption[];
  versionSeqOptions: ComboOption[];
  statusOptions: ComboOption[];
  siteOptions: ComboOption[];
  plantOptions: ComboOption[];
  buildingOptions: ComboOption[];
  lineOptions: ComboOption[];
  operationOptions: ComboOption[];
  lineTypeOptions: ComboOption[];
  /** GET SP payload — 다중선택 6축이 전개된 확정 형태. 값은 전부 문자열이다. */
  buildGetPayload: () => Record<string, string>;
}

export const useCapaLossPlanCombos = (): CapaLossPlanCombos => {
  const sc = useCapaLossPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaLossPlanStore(state => state.setSearchCondition);
  const setDerivedVersionInfo = useCapaLossPlanStore(state => state.setDerivedVersionInfo);

  const isEltr = sc.divisionType === DIVISION_TYPE.ELTR;
  const shopGroupId = SHOP_GROUP_ID[sc.divisionType];

  // mount 시 4건 병렬 로드. 데드 콤보 2건(`YearFromThisYear_SCP_ALL`/`YesOrNo`)은 이식하지 않는다
  //   (02 §2.7 — 선언 외 참조 0건, F-32). 마스터만 divisionType 에 따라 comboId 가 갈린다.
  //
  //   `LookupCommon` 은 AS-IS 가 **조건부로만** 호출하지만(CELL && 컷오프 && LINE) 여기서는 항상
  //   건다 — `useTabComboQueries` 에 넘기는 배열 길이가 렌더마다 바뀌면 훅 내부 쿼리 수가 흔들린다.
  //   4행짜리 lookup 이고 **적용은 조건부**(`needsOperationWhitelist`)라 후보 집합은 AS-IS 와 같다.
  const [divisionRows, versionRows, statusRows, masterRows, whitelistRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO.CAPA_VERSION, mnuId: MENU_ID },
      { comboId: COMBO.PROGRESS_STATUS, mnuId: MENU_ID },
      {
        comboId: isEltr ? COMBO.LINE_MASTER_ELTR : COMBO.LINE_MASTER_ASSEMBLY,
        mnuId: MENU_ID,
      },
      {
        comboId: COMBO.LOOKUP_COMMON,
        mnuId: MENU_ID,
        lookupType: OPERATION_WHITELIST_LOOKUP_TYPE,
      },
    ],
  });

  const master = masterRows as ComboRow[] | undefined;

  const divisionOptions = useMemo(
    () => buildDivisionOptions(divisionRows as ComboRow[] | undefined),
    [divisionRows]
  );

  // Version 계열 4파생 — 결과셋 1건에서 전부 나온다(02 §2.2). 서버 정렬 유지(FE 재정렬 금지).
  const versionOptions = useMemo(
    () => buildVersionOptions(versionRows as ComboRow[] | undefined, sc.divisionId),
    [versionRows, sc.divisionId]
  );
  const versionSeqOptions = useMemo(
    () =>
      buildVersionSeqOptions(versionRows as ComboRow[] | undefined, sc.divisionId, sc.version),
    [versionRows, sc.divisionId, sc.version]
  );
  const planType = useMemo(
    () =>
      derivePlanType(
        versionRows as ComboRow[] | undefined,
        sc.divisionId,
        sc.version,
        sc.versionSeq
      ),
    [versionRows, sc.divisionId, sc.version, sc.versionSeq]
  );
  const currProgressStatus = useMemo(
    () =>
      deriveCurrProgressStatus(
        versionRows as ComboRow[] | undefined,
        sc.divisionId,
        sc.version,
        sc.versionSeq
      ),
    [versionRows, sc.divisionId, sc.version, sc.versionSeq]
  );

  const statusOptions = useMemo(
    () => buildProgressStatusOptions(statusRows as ComboRow[] | undefined, currProgressStatus),
    [statusRows, currProgressStatus]
  );

  // 마스터 1건의 6축 슬라이스 — 상위 선택이 "전체"면 좁히지 않는다(AS-IS 도 후보 전체를 IN 으로 넣어 등가).
  const siteOptions = useMemo(
    () => buildSiteOptions(master, sc.divisionId),
    [master, sc.divisionId]
  );
  const plantOptions = useMemo(
    () =>
      buildPlantOptions({
        rows: master,
        divisionId: sc.divisionId,
        shopGroupId,
        siteId: sc.siteId,
      }),
    [master, sc.divisionId, shopGroupId, sc.siteId]
  );
  const buildingOptions = useMemo(
    () =>
      buildBuildingOptions({
        rows: master,
        divisionId: sc.divisionId,
        shopGroupId,
        plantId: sc.plantId,
      }),
    [master, sc.divisionId, shopGroupId, sc.plantId]
  );
  const lineOptions = useMemo(
    () =>
      buildLineOptions({
        rows: master,
        divisionId: sc.divisionId,
        shopGroupId,
        plantId: sc.plantId,
        factoryId: sc.factoryId,
      }),
    [master, sc.divisionId, shopGroupId, sc.plantId, sc.factoryId]
  );

  /**
   * Operation 화이트리스트 — `CELL && (1st|2nd 컷오프) && LINE` 일 때만 적용한다(02 §2.6, F-15).
   * `division === '40'`(소형) -> `A3000/A8210/A9000`, 그 외 -> `A9000`.
   * 미적용 시 1차 컷오프 후 Line별 비조업 조회에서 `A3000` 공정이 소실된다.
   */
  const operationWhitelist = useMemo(() => {
    if (!needsOperationWhitelist(sc.divisionType, sc.progressStatus, sc.sheetType)) {
      return undefined;
    }
    return buildOperationWhitelist(whitelistRows as ComboRow[] | undefined, sc.divisionId);
  }, [whitelistRows, sc.divisionType, sc.progressStatus, sc.sheetType, sc.divisionId]);

  const operationOptions = useMemo(
    () =>
      buildOperationOptions({
        rows: master,
        divisionId: sc.divisionId,
        shopGroupId,
        plantId: sc.plantId,
        factoryId: sc.factoryId,
        lineId: sc.lineId,
        divisionType: sc.divisionType,
        whitelist: operationWhitelist,
      }),
    [
      master,
      sc.divisionId,
      shopGroupId,
      sc.plantId,
      sc.factoryId,
      sc.lineId,
      sc.divisionType,
      operationWhitelist,
    ]
  );

  // Line Type — **전 축 마스터 슬라이스**다. SCP0105 처럼 ELTR 에서 별도 콤보를 부르지 않는다(02 §0 #6).
  const lineTypeOptions = useMemo(
    () =>
      buildLineTypeOptions({
        rows: master,
        divisionId: sc.divisionId,
        shopGroupId,
        operationId: sc.operationId,
        divisionType: sc.divisionType,
      }),
    [master, sc.divisionId, shopGroupId, sc.operationId, sc.divisionType]
  );

  /**
   * 초기 1회 "일괄 계산" — AS-IS 는 `InitEvent()` 가 `InitControls()` **뒤**라 최초 바인딩 중에는
   * cascade 핸들러가 돌지 않는다(02 §4.1 배선 순서 함정). TO-BE 에서 useEffect 연쇄로 짜면 초기
   * 마운트에 N번 도는 차이가 생기므로, 단일 콤보 3축의 기본선택을 한 effect 에서 함께 결정한다.
   * 선택값이 후보에 없으면(상위 변경으로 무효화) 첫 행으로 되돌린다 — AS-IS `cbo.DataSource` 재현.
   */
  useEffect(() => {
    const patch: Partial<typeof sc> = {};
    if (divisionOptions.length > 0 && !divisionOptions.some(o => o.value === sc.divisionId)) {
      patch.divisionId = divisionOptions[0].value;
    }
    if (versionOptions.length > 0 && !versionOptions.some(o => o.value === sc.version)) {
      patch.version = versionOptions[0].value;
    }
    if (versionSeqOptions.length > 0 && !versionSeqOptions.some(o => o.value === sc.versionSeq)) {
      patch.versionSeq = versionSeqOptions[0].value;
    }
    if (Object.keys(patch).length > 0) setSearchCondition(patch);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions, versionOptions, versionSeqOptions]);

  /**
   * Status 기본선택 = **목록의 마지막 항목**(`SelectedIndex = Items.Count - 1`, 02 §2.3·F-08).
   * **SCP0105 와 다르다** — SCP0105 는 `GetIndexByCode(curr)` 로 현재 진행상태를 고른다.
   * `GetIndexByCode` 류로 바꾸면 3중 필터로 후보가 바뀔 때 선택이 어긋난다.
   */
  useEffect(() => {
    setDerivedVersionInfo(planType, currProgressStatus);
    if (statusOptions.length === 0) return;
    if (statusOptions.some(option => option.value === sc.progressStatus)) return;
    setSearchCondition({ progressStatus: statusOptions[statusOptions.length - 1].value });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planType, currProgressStatus, statusOptions]);

  /**
   * GET SP payload (15 파라미터, AS-IS `SetQueryInfoGet` cs:3031~3063).
   * 다중선택 6축은 여기서 전개한다 — 무선택이면 후보 전체 CODE 를 `,` join, 후보 0건이면 `NONE`
   * (서버에 `'ALL'` 문자열을 보내지 않는다, 02 §3.4).
   * `String(value ?? '')` 가드 필수 — `'undefined'` 문자열이 SP 까지 전파되면 ORA-01722 다.
   *
   * 주의 1: Item 파라미터는 **`p_nick_name`** 이다(SCP0105 의 `p_item_id` 아님 — F-24).
   *   서버는 `A.MDL_NM IN(...)` **단일 컬럼**으로 매칭한다.
   * 주의 2: `p_nick_name`/`p_electrode_type` 의 **SP IN 순번이 시트 계열마다 10/11 <-> 11/10 으로
   *   뒤바뀐다**(03 R-29). 여기서는 명명 인자로만 보내므로 안전하지만, BE/SP 쪽에서 위치 인자
   *   바인딩을 쓰면 값이 뒤바뀐다 — `convert-sp` 인계 사항.
   * 주의 3: `p_sheet_name` 은 호출부가 확정한 **`_sheet_name` 8값**이다(F-25).
   */
  const buildGetPayload = (): Record<string, string> => ({
    // 1 p_version        — Plan Month(VER_ID)
    p_version: String(sc.version ?? ''),
    // 2 p_version_seq    — VER_SEQ
    p_version_seq: String(sc.versionSeq ?? ''),
    // 3 p_prog_stat      — Status 콤보 선택값(버전의 현재 진행상태가 아니다)
    p_prog_stat: String(sc.progressStatus ?? ''),
    // 4 p_division_id
    p_division_id: String(sc.divisionId ?? ''),
    // 5~9 다중선택 5축
    p_site_id: expandMultiSelect(sc.siteId, siteOptions),
    p_plant_id: expandMultiSelect(sc.plantId, plantOptions),
    p_factory_id: expandMultiSelect(sc.factoryId, buildingOptions),
    p_line_id: expandMultiSelect(sc.lineId, lineOptions),
    // 주의: ELTR 에서 Operation 필드는 숨지만 값은 나간다 — 빈값으로 바꾸면 건수가 달라진다(F-23)
    p_operation_id: expandMultiSelect(sc.operationId, operationOptions),
    // 10 p_nick_name     — 팝업 선택 결과. 서버는 `MDL_NM` 단일 컬럼 매칭
    p_nick_name: String(sc.nickName ?? ''),
    // 11 p_electrode_type — 다중선택 6번째 축
    p_electrode_type: expandMultiSelect(sc.electrodeType, lineTypeOptions),
    // 12 p_program_id
    p_program_id: MENU_ID,
    // 13 p_sheet_name    — 호출부가 `toSheetName()` 결과를 덮어쓴다(8값)
    // 14 p_user_id       — BE @LoginUser 주입(세션). 15 debug_mode
    debug_mode: 'F',
  });

  return {
    divisionOptions,
    versionOptions,
    versionSeqOptions,
    statusOptions,
    siteOptions,
    plantOptions,
    buildingOptions,
    lineOptions,
    operationOptions,
    lineTypeOptions,
    buildGetPayload,
  };
};
