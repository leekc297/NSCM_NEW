import { useEffect, useMemo } from 'react';

import { useTabComboQueryResults } from '@shared/hooks';

import {
  DIVISION_TYPE,
  MENU_ID,
  SEARCH_COMBO,
  SHEET_NAME_BY_DIVISION_TYPE,
  SHOP_GROUP_ID,
} from '../capa-teep-report.constants';
import type { CapaTeepFilters, ComboOption, ComboRow } from '../capa-teep-report.types';
import { useCapaTeepReportStore } from '../useCapaTeepReportStore';
import {
  buildBuildingOptions,
  buildDivisionOptions,
  buildLineOptions,
  buildLineTypeOptions,
  buildOperationOptions,
  buildPlantOptions,
  buildSiteOptions,
  buildVersionOptions,
  buildVersionSeqOptions,
  deriveCurrProgressStatus,
  derivePlanType,
  expandMultiSelect,
  filterMasterByShopGroup,
  toDivisionParam,
} from '../utils/capaTeepReport.combos';

/**
 * 조회조건 콤보 4종 + cascade 파생값의 단일 출처 (design 02 §2 / §3 / §5.3).
 *
 * cascade 형태(02 §3.1): Division / Plan Month / Version / Site~Line Type 은 **전부 클라 필터**이고
 * 서버 재조회는 **`Operation group`(DivisionType) 1건**뿐이다 — 그것도 파라미터로 좁히는 게 아니라
 * **마스터 콤보 자체를 갈아끼운다**(`CapaLineMaster_SCP_ALL` <-> `CapaLineMasterEE_SCP_ALL`, goal S-5).
 * `comboId` 문자열이 바뀌면 react-query 키가 갈라져 자동 재조회되므로 **`refetch()` 를 직접 부르지 않는다**
 * (nscm-patterns §5-1).
 *
 * 호출 수는 **3~4건**이다 — ELTR 경로에서만 Line Type 원천(`OperationElectrodeType_SCP_ALL`)이 추가된다.
 * `useTabComboQueries`/`useTabComboQueryResults` 에 넘기는 배열 길이가 렌더마다 흔들리면 훅 내부 쿼리 수가
 * 요동치므로 **길이를 4로 고정**하고 ELTR 이 아닐 때도 같은 자리를 유지한다(자매 SCP0106 선례).
 *
 * 미사용 콤보 3종(`CapaProgressStatus_SCP_ALL` / `YearFromThisYear_SCP_ALL` / `YesOrNo`)은 호출하지
 * 않는다 — 대응 컨트롤이 Designer 에 아예 없어 dead 로 확정됐다(02 §2.5 D1~D3 / goal S-16).
 * 콤보 결과를 store 에 담지 않는다(서버 데이터 SSOT = React Query).
 */
export interface CapaTeepReportCombos {
  divisionOptions: ComboOption[];
  versionOptions: ComboOption[];
  versionSeqOptions: ComboOption[];
  siteOptions: ComboOption[];
  plantOptions: ComboOption[];
  buildingOptions: ComboOption[];
  lineOptions: ComboOption[];
  operationOptions: ComboOption[];
  lineTypeOptions: ComboOption[];
  /** Division 콤보 **성공** 수신 여부 — 권한 0건 게이트의 판정 시점(01 L-04). 실패는 포함하지 않는다. */
  isDivisionSettled: boolean;
  /** Division 콤보 조회 실패 — 권한 0건과 다른 분기다(실패 안내만, 조회영역 잠금 금지). */
  isDivisionError: boolean;
  /** GET SP payload(IN 13 중 FE 가 싣는 12건, 02 §5.5). */
  buildGetPayload: () => CapaTeepFilters;
}

export const useCapaTeepReportCombos = (): CapaTeepReportCombos => {
  const sp = useCapaTeepReportStore(state => state.searchParams);
  const lineTypeOperationId = useCapaTeepReportStore(state => state.lineTypeOperationId);
  const setSearchParams = useCapaTeepReportStore(state => state.setSearchParams);
  const setDerivedVersionInfo = useCapaTeepReportStore(state => state.setDerivedVersionInfo);

  const isEltr = sp.divisionType === DIVISION_TYPE.ELTR;
  const shopGroupId = SHOP_GROUP_ID[sp.divisionType];

  /**
   * mount 시 1 round-trip(hook #5 §4) — `useTabComboQuery` 단일 N회 호출 금지(02 §5.3 주의2).
   * `mnuId` 는 `Division_SCP` 의 `@mnuId` 해소용이며 **raw** 로 나간다(`quoteComboParams` 특례).
   *
   * **`@mnuId`(goal D-7) — 기본안 "미전달" 은 FE 계층에서 달성 불가다**: 공용 훅이 `mnuId` 미지정
   * 파라미터에 화면 `menuId` 를 **자동 주입**한다(`useCustomQueryClient.ts` `withMenuId` — 캐시 분리
   * 목적). 빈 문자열을 넣어도 falsy 라 다시 주입되므로 "안 보내기" 는 공용 훅 수정(Hard Boundary 밖)이
   * 아니면 불가능하다. TO-BE SQL 은 `NVL(TRIM(@mnuId),'ALL')='ALL'` 관대형이고 이 회차에
   * `SCM_ADM_USER_GR_MNU_MPG_M` 메뉴 권한을 등록하므로 후보가 좁아지지 않는다(02 §2.1 ④ / §7 A-3).
   * 자매 SCP0106/0108 과 동일하게 명시 전달하고, 정책 결론은 04 리포트에 관측차로 올린다.
   */
  const [divisionResult, versionResult, masterResult, electrodeTypeResult] =
    useTabComboQueryResults({
      filters: [
        { comboId: SEARCH_COMBO.DIVISION, mnuId: MENU_ID },
        { comboId: SEARCH_COMBO.CAPA_VERSION, mnuId: MENU_ID },
        {
          comboId: isEltr
            ? SEARCH_COMBO.LINE_MASTER_ELTR
            : SEARCH_COMBO.LINE_MASTER_ASSEMBLY,
          mnuId: MENU_ID,
        },
        { comboId: SEARCH_COMBO.OPERATION_ELECTRODE_TYPE, mnuId: MENU_ID },
      ],
    });

  const divisionRows = divisionResult.data as ComboRow[] | undefined;
  const versionRows = versionResult.data as ComboRow[] | undefined;
  const masterRows = masterResult.data as ComboRow[] | undefined;
  const electrodeLookupRows = electrodeTypeResult.data as ComboRow[] | undefined;

  /**
   * "권한이 없다" / "아직 안 왔다" / "조회가 실패했다" **3상태**를 구분한다 — AS-IS 는 동기 로드 직후
   * `dtDivision.Rows.Count == 0` 을 한 시점에 판정한다(cs:1131~1132). 로딩 중 0건으로 판정하면 정상
   * 권한 사용자에게도 `MSG00667` 이 뜨고 조회영역이 잠긴다. 판정은 `isSuccess` 기준이다 —
   * `!isPending` 으로 잡으면 실패까지 "권한 없음" 이 되어 네트워크 오류에 조회영역이 통째로 잠긴다
   * (자매 SCP0108 iter-1 G-03).
   */
  const isDivisionSettled = divisionResult.isSuccess;
  const isDivisionError = divisionResult.isError;

  const divisionOptions = useMemo(() => buildDivisionOptions(divisionRows), [divisionRows]);

  // Version 계열 4파생 — 결과셋 1건에서 전부 나온다(02 §2.2). 서버 정렬 유지(FE 재정렬 금지).
  const versionOptions = useMemo(
    () => buildVersionOptions(versionRows, sp.divisionId),
    [versionRows, sp.divisionId]
  );
  const versionSeqOptions = useMemo(
    () => buildVersionSeqOptions(versionRows, sp.divisionId, sp.verId),
    [versionRows, sp.divisionId, sp.verId]
  );
  const planType = useMemo(
    () => derivePlanType(versionRows, sp.divisionId, sp.verId, sp.verSeq),
    [versionRows, sp.divisionId, sp.verId, sp.verSeq]
  );
  const currProgressStatus = useMemo(
    () => deriveCurrProgressStatus(versionRows, sp.divisionId, sp.verId, sp.verSeq),
    [versionRows, sp.divisionId, sp.verId, sp.verSeq]
  );

  /**
   * 마스터 원천 — ASSEMBLY 경로는 `SHOP_GROUP_ID = 'A'|'P'` 로 **선필터**한다(02 §2.3 BL:35~42).
   * 축별 `GetFilterXxx` 의 shop group 절은 Division 이 비면 생성되지 않지만 이 선필터는 그 이전 단계라
   * 항상 걸린다 — 두 단계를 혼동해 여기서 빼면 Cell/Module·Pack 에 전극 라인이 섞인다(goal S-7).
   */
  const master = useMemo(
    () => filterMasterByShopGroup(masterRows, sp.divisionType),
    [masterRows, sp.divisionType]
  );

  /**
   * 6축 마스터 슬라이스 — `GetFilterXxx` 술어를 축마다 그대로 재현한다(02 §2.6).
   * 축별로 걸리는 조건이 다르다(통일하면 후보 집합이 달라진다):
   *  - Site: DIVISION 만(shop group 없음) / Plant: + SITE + SHOP_GROUP
   *  - Building: + SHOP_GROUP + PLANT (**SITE 축 없음**) / Line: + FACTORY 까지
   *  - Operation: + LINE 까지(`CODE<>'-'` 없음) / Line Type: DIVISION + OPERATION 만
   */
  const siteOptions = useMemo(
    () => buildSiteOptions({ rows: master, divisionId: sp.divisionId, shopGroupId }),
    [master, sp.divisionId, shopGroupId]
  );
  const plantOptions = useMemo(
    () =>
      buildPlantOptions({
        rows: master,
        divisionId: sp.divisionId,
        shopGroupId,
        siteId: sp.siteId,
      }),
    [master, sp.divisionId, shopGroupId, sp.siteId]
  );
  const buildingOptions = useMemo(
    () =>
      buildBuildingOptions({
        rows: master,
        divisionId: sp.divisionId,
        shopGroupId,
        plantId: sp.plantId,
      }),
    [master, sp.divisionId, shopGroupId, sp.plantId]
  );
  const lineOptions = useMemo(
    () =>
      buildLineOptions({
        rows: master,
        divisionId: sp.divisionId,
        shopGroupId,
        plantId: sp.plantId,
        factoryId: sp.factoryId,
      }),
    [master, sp.divisionId, shopGroupId, sp.plantId, sp.factoryId]
  );
  const operationOptions = useMemo(
    () =>
      buildOperationOptions(
        {
          rows: master,
          divisionId: sp.divisionId,
          shopGroupId,
          plantId: sp.plantId,
          factoryId: sp.factoryId,
          lineId: sp.lineId,
        },
        sp.divisionType
      ),
    [master, sp.divisionId, shopGroupId, sp.plantId, sp.factoryId, sp.lineId, sp.divisionType]
  );
  /**
   * Line Type 만 `searchParams.operationId` 가 아니라 **스냅샷**(`lineTypeOperationId`)으로 만든다.
   * AS-IS 는 `RefreshElectrodeType`(Division / Plan Month / Version / Operation group / Operation 변경)
   * 에서만 목록을 다시 만들고 Site~Line 핸들러는 그 함수를 부르지 않는다(02 §3.2 비대칭 1) —
   * 선택값을 그대로 쓰면 AS-IS 가 갱신하지 않는 목록이 같이 바뀐다.
   * 원천도 DivisionType 별로 2개다(ASSEMBLY = 마스터 / ELTR = lookup 콤보, 02 §2.4).
   */
  const lineTypeOptions = useMemo(
    () =>
      buildLineTypeOptions(
        {
          rows: master,
          divisionId: sp.divisionId,
          shopGroupId: '',
          operationId: lineTypeOperationId,
        },
        sp.divisionType,
        electrodeLookupRows
      ),
    [master, sp.divisionId, lineTypeOperationId, sp.divisionType, electrodeLookupRows]
  );

  /**
   * 단일 콤보 2축 기본선택 — AS-IS 는 `InitEvent()` 가 `InitControls()` **뒤**라 최초 바인딩 중에는
   * cascade 핸들러가 한 번도 돌지 않는다(02 §4.1 배선 순서 함정). useEffect 연쇄로 짜면 초기 마운트에
   * N번 도는 차이가 생기므로 두 축의 기본선택을 한 effect 에서 함께 결정한다.
   * 선택값이 후보에 없으면(상위 변경으로 무효화) 첫 행으로 되돌린다 — `cbo.DataSource` 바인딩 재현.
   * Division 은 다중선택이고 기본이 `ALL` 이라 여기서 첫 행을 강제하지 않는다(02 §4.2 C1).
   */
  useEffect(() => {
    const patch: Partial<typeof sp> = {};
    if (versionOptions.length > 0 && !versionOptions.some(option => option.value === sp.verId)) {
      patch.verId = versionOptions[0].value;
    }
    if (
      versionSeqOptions.length > 0 &&
      !versionSeqOptions.some(option => option.value === sp.verSeq)
    ) {
      patch.verSeq = versionSeqOptions[0].value;
    }
    if (Object.keys(patch).length > 0) setSearchParams(patch);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [versionOptions, versionSeqOptions]);

  // Plan Type 표시값 + 조회 게이트 판정값은 같은 필터에서 나오므로 한 번에 커밋한다(02 §2.2).
  useEffect(() => {
    setDerivedVersionInfo(planType, currProgressStatus);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planType, currProgressStatus]);

  /**
   * GET SP payload — IN 13개 중 FE 가 싣는 12건(02 §5.5 / 03 §4.2).
   *
   * 직렬화 규약이 **축마다 다르다**(02 §3.4 / goal S-6):
   *   Division      -> ALL 이면 **`''`**(SP 가 전체로 해석)
   *   Site~LineType -> ALL 이면 **후보 전건 CSV**, 후보 0건이면 **`'NONE'`**(결과 0건 강제)
   * `String(value ?? '')` 가드 필수 — `'undefined'` 문자열이 SP 까지 전파되면 ORA-01722 다.
   *
   * 주의 1: **`p_prog_stat`·`p_nick_name` 이 없다** — 자매 SCP0106 파라미터를 복사하지 말 것(03 §4.2).
   * 주의 2: **`p_from_yyyymm` 은 GET 파라미터가 아니다** — SP 가 `p_version` 에서 재계산한다(03 §2.1).
   * 주의 3: Electrode 에서 Operation/Line Type 필드는 숨지만 **값은 그대로 나간다**(goal D-6 기본안,
   *   01 L-01/L-02 · V-05). 빈값으로 바꾸면 조회 건수가 달라진다.
   */
  const buildGetPayload = (): CapaTeepFilters => ({
    // 1 p_version       — Plan Month(VER_ID)
    version: String(sp.verId ?? ''),
    // 2 p_version_seq   — VER_SEQ. AS-IS 는 byte 캐스팅(실패 시 0)
    versionSeq: Number(sp.verSeq) || 0,
    // 3 p_division_id   — `GetCheckedListValue` 축: ALL -> ''
    divisionId: toDivisionParam(sp.divisionId),
    // 4~9 `GetCheckedListValueNone` 축: ALL -> 후보 전건 CSV / 후보 0건 -> 'NONE'
    siteId: expandMultiSelect(sp.siteId, siteOptions),
    plantId: expandMultiSelect(sp.plantId, plantOptions),
    factoryId: expandMultiSelect(sp.factoryId, buildingOptions),
    lineId: expandMultiSelect(sp.lineId, lineOptions),
    operationId: expandMultiSelect(sp.operationId, operationOptions),
    electrodeType: expandMultiSelect(sp.electrodeType, lineTypeOptions),
    // 10 p_program_id
    programId: MENU_ID,
    // 11 p_sheet_name    — `divisionType` 파생 단일 출처(03 §4.1)
    sheetName: SHEET_NAME_BY_DIVISION_TYPE[sp.divisionType],
    // 12 p_user_id       = BE @LoginUser 자동 주입(convert-core §3.5)
    // 13 debug_mode      = AS-IS 리터럴 'F' 고정(03 §4.2 #13)
    debugMode: 'F',
  });

  return {
    divisionOptions,
    versionOptions,
    versionSeqOptions,
    siteOptions,
    plantOptions,
    buildingOptions,
    lineOptions,
    operationOptions,
    lineTypeOptions,
    isDivisionSettled,
    isDivisionError,
    buildGetPayload,
  };
};
