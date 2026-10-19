import { useEffect, useMemo } from 'react';

import { useTabComboQueryResults } from '@shared/hooks';

import {
  COMBO,
  DIVISION_TYPE,
  MENU_ID,
  SHEET_BY_DIVISION_TYPE,
  SHEET_STATUS,
  SHOP_GROUP_ID,
} from '../capa-speed-plan.constants';
import type { ComboOption, ComboRow } from '../capa-speed-plan.types';
import { useCapaSpeedPlanStore } from '../useCapaSpeedPlanStore';
import {
  buildAssemblyLineTypeOptions,
  buildBuildingOptions,
  buildDivisionOptions,
  buildEltrLineTypeOptions,
  buildLineOptions,
  buildOperationOptions,
  buildPlantOptions,
  buildProgressStatusOptions,
  buildSiteOptions,
  buildVersionOptions,
  buildVersionSeqOptions,
  deriveCurrProgressStatus,
  derivePlanType,
  expandMultiSelect,
} from '../utils/capaSpeedPlan.combos';

/**
 * 조회조건 콤보 7종 + cascade 파생값의 단일 출처.
 *
 * cascade 형태(design 02 §3.0): **서버 재조회는 `divisionType` 1건뿐**이고 나머지 10개 이벤트는
 * 전부 클라 필터다(마스터/버전/상태 결과셋을 좁히기만 한다 — 서버 왕복 0회).
 * `divisionType` 은 마스터 comboId 자체(`CapaLineMaster_SCP_ALL` <-> `CapaLineMasterEE_SCP_ALL`)를
 * 바꾸므로 react-query 키가 갈라져 자동 재조회된다. 전부 재조회형으로 만들면 체크리스트 6개가
 * 매번 서버를 때린다.
 *
 * 페이지가 이 훅을 1회 호출해 Form 에 내려준다 — 조회(F5) 시 payload 전개에 후보 목록이 필요해서다
 * (무선택 = 후보 전체 CODE 전개, 02 §3.4). 콤보 결과를 store 에 담지 않는다(서버 데이터 SSOT).
 */
export interface CapaSpeedPlanCombos {
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
  /**
   * `OperationElectrodeType_SCP_ALL` **원본 행**(125건).
   * 그리드 셀 콤보는 조회조건과 좁히는 기준이 달라(행의 DIVISION_ID+OPERATION_ID, 03 §1.3)
   * 이미 걸러진 `lineTypeOptions` 가 아니라 원본이 필요하다.
   */
  electrodeTypeRows: ComboRow[] | undefined;
  /** Division 콤보 응답 수신 여부 — 권한 0건 게이트의 판정 시점(위 주석). */
  isDivisionSettled: boolean;
  /** GET SP payload — 다중선택 6축이 전개된 확정 형태. 값은 전부 문자열이다. */
  buildGetPayload: () => Record<string, string>;
}

export const useCapaSpeedPlanCombos = (): CapaSpeedPlanCombos => {
  const sc = useCapaSpeedPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaSpeedPlanStore(state => state.setSearchCondition);
  const setDerivedVersionInfo = useCapaSpeedPlanStore(state => state.setDerivedVersionInfo);

  const isEltr = sc.divisionType === DIVISION_TYPE.ELTR;
  const shopGroupId = SHOP_GROUP_ID[sc.divisionType];

  // mount 시 4건 병렬 로드(AS-IS 는 필드 초기화 시점에 3건 + 마스터 1건을 부른다, 02 §4.1).
  //   데드 콤보 2건(`YearFromThisYear_SCP_ALL`/`YesOrNo`)은 이식하지 않는다(02 §2.6 — 참조 0건).
  //   마스터만 divisionType 에 따라 comboId 가 갈린다 = 유일한 재조회형.
  // `useTabComboQueryResults` 는 `data` 외에 `isPending` 도 준다 — Division 권한 0건 게이트가
  //   "아직 안 왔다" 와 "왔는데 0건" 을 구분해야 해서 필요하다(아래 `isDivisionSettled`).
  const [divisionResult, versionResult, statusResult, masterResult, electrodeResult] =
    useTabComboQueryResults({
      filters: [
        { comboId: COMBO.DIVISION, mnuId: MENU_ID },
        { comboId: COMBO.CAPA_VERSION, mnuId: MENU_ID },
        { comboId: COMBO.PROGRESS_STATUS, mnuId: MENU_ID },
        {
          comboId: isEltr ? COMBO.LINE_MASTER_ELTR : COMBO.LINE_MASTER_ASSEMBLY,
          mnuId: MENU_ID,
        },
        { comboId: COMBO.OPERATION_ELECTRODE_TYPE, mnuId: MENU_ID },
      ],
    });

  const divisionRows = divisionResult.data;
  const versionRows = versionResult.data;
  const statusRows = statusResult.data;
  const electrodeRows = electrodeResult.data;
  const master = masterResult.data as ComboRow[] | undefined;

  /**
   * Division 콤보가 **응답을 받았는지**. Division 권한 0건 게이트(01 L-04 / V-05)는 "권한이 없다"와
   * "아직 안 왔다"를 구분해야 한다 — AS-IS 는 동기 로드 직후 `dtDivision.Rows.Count == 0` 을 한 시점에
   * 판정한다(cs:1241~1242). 로딩 중 후보가 0건인 상태로 판정하면 정상 권한 사용자에게 `MSG00667` 이
   * 뜨고 조회영역이 잠긴다(알림은 `notifiedAuthRef` 로 1회 래치돼 되돌지 않는다).
   */
  const isDivisionSettled = !divisionResult.isPending;

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
  // Site 도 shop group 스코프다 — AS-IS 는 마스터 자체를 `GetFilteredPackCell` 로 먼저 좁힌다
  //   (`utils/capaSpeedPlan.combos.ts` buildSiteOptions 주석 / 설계 F-10).
  const siteOptions = useMemo(
    () => buildSiteOptions({ rows: master, divisionId: sc.divisionId, shopGroupId }),
    [master, sc.divisionId, shopGroupId]
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
  const operationOptions = useMemo(
    () =>
      buildOperationOptions({
        rows: master,
        divisionId: sc.divisionId,
        shopGroupId,
        plantId: sc.plantId,
        factoryId: sc.factoryId,
        lineId: sc.lineId,
      }),
    [master, sc.divisionId, shopGroupId, sc.plantId, sc.factoryId, sc.lineId]
  );

  // Line Type 만 원천이 갈린다: ASSEMBLY 는 마스터 슬라이스, ELTR 은 별도 lookup 콤보(02 §2.4/§2.5).
  const lineTypeOptions = useMemo(
    () =>
      isEltr
        ? buildEltrLineTypeOptions(
            electrodeRows as ComboRow[] | undefined,
            sc.divisionId,
            sc.divisionType
          )
        : buildAssemblyLineTypeOptions({
            rows: master,
            divisionId: sc.divisionId,
            shopGroupId,
            operationId: sc.operationId,
          }),
    [isEltr, electrodeRows, master, sc.divisionId, sc.divisionType, shopGroupId, sc.operationId]
  );

  /**
   * 초기 1회 "일괄 계산" — AS-IS 는 `InitEvent()` 가 `InitControls()` **뒤**라 최초 바인딩 중에는
   * cascade 핸들러가 돌지 않는다(02 §4.1 배선 순서 함정). TO-BE 에서 useEffect 연쇄로 짜면 초기
   * 마운트에 N번 도는 차이가 생기므로, 단일 콤보 3축의 기본선택을 한 effect 에서 함께 결정한다.
   * 선택값이 후보에 없으면(상위 변경으로 무효화) 첫 행으로 되돌린다 — AS-IS `cbo.DataSource` 바인딩 재현.
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
   * Status 기본선택 = 그 버전의 현재 진행상태(`GetIndexByCode`, 없으면 첫 행 — cs:1097~1106).
   * Status 후보는 `currProgressStatus` 로 좁혀지므로 두 값이 같은 effect 에서 결정돼야 흔들리지 않는다.
   */
  useEffect(() => {
    setDerivedVersionInfo(planType, currProgressStatus);
    if (statusOptions.length === 0) return;
    if (statusOptions.some(option => option.value === sc.progressStatus)) return;
    const preferred = statusOptions.find(option => option.value === currProgressStatus);
    setSearchCondition({ progressStatus: (preferred ?? statusOptions[0]).value });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planType, currProgressStatus, statusOptions]);

  /**
   * GET SP payload (15 파라미터, AS-IS `SetQueryInfoGet` cs:2233~2257).
   * 다중선택 6축은 여기서 전개한다 — 무선택이면 후보 전체 CODE 를 `,` join, 후보 0건이면 `NONE`
   * (서버에 `'ALL'` 문자열을 보내지 않는다, 02 §3.4).
   * `String(value ?? '')` 가드 필수 — `'undefined'` 문자열이 SP 까지 전파되면 ORA-01722 다.
   */
  const buildGetPayload = (): Record<string, string> => ({
    // 1 p_version        — Plan Month(VER_ID). AS-IS 기본 "-"
    p_version: String(sc.version ?? ''),
    // 2 p_version_seq    — VER_SEQ. AS-IS 는 (byte) 캐스팅, 기본 0
    p_version_seq: String(sc.versionSeq ?? ''),
    // 3 p_prog_stat      — Status 콤보 선택값(현재 진행상태가 아니다)
    p_prog_stat: String(sc.progressStatus ?? ''),
    // 4 p_division_id
    p_division_id: String(sc.divisionId ?? ''),
    // 5~10 다중선택 6축 — SP 가 STRING_SPLIT(',') 로 푼다
    p_site_id: expandMultiSelect(sc.siteId, siteOptions),
    p_plant_id: expandMultiSelect(sc.plantId, plantOptions),
    p_factory_id: expandMultiSelect(sc.factoryId, buildingOptions),
    p_line_id: expandMultiSelect(sc.lineId, lineOptions),
    // 주의: ELTR 에서 Operation 필드는 숨지만 값은 나간다 — 빈값으로 바꾸면 조회 건수가 달라진다(F-18)
    p_operation_id: expandMultiSelect(sc.operationId, operationOptions),
    p_electrode_type: expandMultiSelect(sc.electrodeType, lineTypeOptions),
    // 11 p_item_id       — 팝업 선택 결과. ITEM_ID 또는 NICK_NAME 둘 다에 매칭된다
    p_item_id: String(sc.itemId ?? ''),
    // 12 p_program_id
    p_program_id: MENU_ID,
    // 13 p_sheet_name    — ASSEMBLY / ELTR
    p_sheet_name: SHEET_BY_DIVISION_TYPE[sc.divisionType],
    // 14 p_user_id       — BE @LoginUser 주입(세션). 15 debug_mode
    debug_mode: 'F',
    // AS-IS QueryId 접미(`_sheet_status`)에 대응 — SP 변형 선택자. convert-sp 가 PKG 분기를 받는다
    p_sheet_status: SHEET_STATUS[sc.progressStatus] ?? '',
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
    electrodeTypeRows: electrodeRows as ComboRow[] | undefined,
    isDivisionSettled,
    buildGetPayload,
  };
};
