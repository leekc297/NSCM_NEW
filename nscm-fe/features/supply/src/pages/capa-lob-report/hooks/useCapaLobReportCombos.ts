import { useEffect, useMemo } from 'react';

import { useTabComboQueryResults } from '@shared/hooks';

import {
  BOTTLENECK_ALL,
  MENU_ID,
  SEARCH_COMBO,
  SHOP_GROUP_ID,
  sheetOf,
} from '../capa-lob-report.constants';
import type {
  CapaLobFilters,
  ComboOption,
  ComboRow,
} from '../capa-lob-report.types';
import { useCapaLobReportStore } from '../useCapaLobReportStore';
import {
  buildBottleneckOptions,
  buildBuildingOptions,
  buildDivisionOptions,
  buildLineOptions,
  buildLineTypeOptions,
  buildOperationOptions,
  buildPlantOptions,
  buildProgressStatusOptions,
  buildSiteOptions,
  buildVersionOptions,
  buildVersionSeqOptions,
  derivePlanType,
  deriveCurrProgressStatus,
  isAllSelected,
} from '../utils/capaLobReport.combos';

/**
 * AS-IS `GetCheckedListValueNone(dt, "ALL")` 전개 재현(CString.cs:567~578).
 * 다중선택 콤보에서 "ALL"(무선택)이면 **현재 후보 목록(dt)의 전체 CODE를 콤마 전개**해 SP로 보낸다 —
 * 후보 목록은 Refresh 함수에서 이미 shop_group(=Division Type)·상위축으로 좁혀져 있어, 전개값이 곧
 * "그 조건으로 좁혀진 전체"다. SP(`PKG_SCP0108` BODY:191~198)는 빈값·'ALL'을 무필터로 보므로, ''를
 * 보내면 그 축이 통째로 빠져 Division Type 필터(60/318)·Site cascade가 조용히 사라진다.
 * 선택값이 특정이면 그대로 쓴다(= 기존 `toFilterValue` 의 비-ALL 경로와 동일).
 */
const effectiveCodes = (selected: string, options: readonly ComboOption[]): string =>
  isAllSelected(selected) ? options.map(option => option.value).join(',') : selected;

/**
 * 조회조건 콤보 5종 + cascade 파생값의 단일 출처 (design 02 §2 / §3 / §5.1).
 *
 * **서버 재조회는 0건이 파리티다**(02 §3.0). 콤보 5종을 `useTabComboQueryResults` 1 round-trip 으로
 * 받고 cascade 10 이벤트 전부를 클라 필터로 처리한다. 특히 **DivisionType 변경에도 콤보를 다시
 * 부르지 않는다** — SCP0105/0106 의 `comboId` 스왑(`CapaLineMaster` <-> `CapaLineMasterEE`) 패턴을
 * 복사하면 AS-IS 위반이다(02 §0 #1 — SCP0108 은 `CapaLineMasterEE` 호출 0건).
 *
 * 콤보 결과를 store 에 담지 않는다(서버 데이터 SSOT = React Query). 조회 payload 조립에 후보 목록이
 * 필요하지 않다 — SCP0108 은 무선택을 `''`(무필터)로 보내고 후보 전체를 전개하지 않는다(02 §1.1).
 */
export interface CapaLobReportCombos {
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
  bottleneckOptions: ComboOption[];
  /** Division 콤보 **성공** 수신 여부 — 권한 0건 게이트의 판정 시점(01 L-04). 실패는 포함하지 않는다. */
  isDivisionSettled: boolean;
  /** Division 콤보 조회 실패 — 권한 0건과 다른 분기다(실패 안내만, 조회영역 잠금 금지). */
  isDivisionError: boolean;
  /** GET SP payload(IN 15 중 FE 가 싣는 13건, 02 §1.1 / §5.4). */
  buildGetPayload: () => CapaLobFilters;
}

export const useCapaLobReportCombos = (): CapaLobReportCombos => {
  const sp = useCapaLobReportStore(state => state.searchParams);
  const lineTypeOperationId = useCapaLobReportStore(state => state.lineTypeOperationId);
  const setSearchParams = useCapaLobReportStore(state => state.setSearchParams);
  const setDerivedVersionInfo = useCapaLobReportStore(state => state.setDerivedVersionInfo);

  const shopGroupId = SHOP_GROUP_ID[sp.divisionType];

  /**
   * mount 시 5건 1 round-trip.
   * AS-IS 는 필드 초기화만으로 서버 왕복 6회 + `RefreshBottleneck` 1회 = 7회다(02 §4.1) — 그 중
   * 2건(`YearFromThisYear_SCP_ALL` / 중복 `YesOrNo`)은 참조 0건 데드라 이식하지 않는다(02 §2.7).
   * `mnuId` 는 `Division_SCP` 의 `@mnuId` 해소용이며 **raw** 로 나간다(`quoteComboParams` 특례).
   * 미전달 시 `NVL(TRIM(''),'ALL')='ALL'` 로 메뉴 권한 필터가 빠져 AS-IS 보다 넓어진다(02 §2.1).
   */
  const [divisionResult, versionResult, statusResult, masterResult, yesOrNoResult] =
    useTabComboQueryResults({
      filters: [
        { comboId: SEARCH_COMBO.DIVISION, mnuId: MENU_ID },
        { comboId: SEARCH_COMBO.CAPA_VERSION, mnuId: MENU_ID },
        { comboId: SEARCH_COMBO.PROGRESS_STATUS, mnuId: MENU_ID },
        { comboId: SEARCH_COMBO.LINE_MASTER, mnuId: MENU_ID },
        { comboId: SEARCH_COMBO.BOTTLENECK, mnuId: MENU_ID },
      ],
    });

  const divisionRows = divisionResult.data as ComboRow[] | undefined;
  const versionRows = versionResult.data as ComboRow[] | undefined;
  const statusRows = statusResult.data as ComboRow[] | undefined;
  const master = masterResult.data as ComboRow[] | undefined;
  const yesOrNoRows = yesOrNoResult.data as ComboRow[] | undefined;

  /**
   * "권한이 없다" / "아직 안 왔다" / "조회가 실패했다" **3상태**를 구분한다 — AS-IS 는 동기 로드 직후
   * `dtDivision.Rows.Count == 0` 을 한 시점에 판정한다(cs:1133~1134). 로딩 중 0건으로 판정하면 정상
   * 권한 사용자에게도 `MSG00667` 이 뜨고 조회영역이 잠긴다(자매 SCP0105 실사고).
   * 판정은 `isSuccess` 기준이다 — `!isPending` 으로 잡으면 **실패(isError)까지 "권한 없음"** 이 되어
   * 네트워크 오류에 조회영역이 통째로 잠긴다(iter-1 G-03 / 02 V-30). `useTabComboQueryResults` 는
   * 바로 이 구분을 위해 존재하는 훅이다(`useCustomQueryClient.ts` 주석).
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

  // 3중 필터 결과 — 항목이 **항상 1건**이다(02 §2.3). 그래서 Status 가 disabled 인 것이 자연스럽다.
  const statusOptions = useMemo(
    () => buildProgressStatusOptions(statusRows, currProgressStatus),
    [statusRows, currProgressStatus]
  );

  /**
   * 6축 마스터 슬라이스 — `GetFilterXxx` 술어를 축마다 재현하되, **상위축이 ALL이면 그 축의 후보
   * 전개값(effective)으로 하위를 좁힌다**(AS-IS Refresh 연쇄: `RefreshFactory` 는 `_plant`=`getPlant()`
   * =dtPlant 전개를 쓰고, dtPlant 는 `_site` 로 좁혀져 있다 → Site만 체크해도 Building/Line이 그 Site의
   * Plant로 좁혀진다, cs:1064~1096). raw 선택값(ALL)만으로 좁히면 상위 cascade가 끊겨 Building/Line이
   * 전건으로 뜬다(Site 선택 시 Building 12개 버그).
   * 축별로 걸리는 조건이 다르다(통일하면 후보 집합이 달라진다):
   *  - Site: DIVISION 만(shop group·상위 축 없음) -> DivisionType 을 바꿔도 목록이 안 변한다
   *  - Plant: + effSite + SHOP_GROUP / Building: + SHOP_GROUP + effPlant
   *  - Line: + SHOP_GROUP + effPlant + effFactory / Operation: + effLine 까지
   *  - Line Type: DIVISION + OPERATION 스냅샷만(shop group 없음, G-16 유지)
   */
  const siteOptions = useMemo(
    () => buildSiteOptions({ rows: master, divisionId: sp.divisionId, shopGroupId }),
    [master, sp.divisionId, shopGroupId]
  );
  const effSite = useMemo(() => effectiveCodes(sp.siteId, siteOptions), [sp.siteId, siteOptions]);

  const plantOptions = useMemo(
    () =>
      buildPlantOptions({
        rows: master,
        divisionId: sp.divisionId,
        shopGroupId,
        siteId: effSite,
      }),
    [master, sp.divisionId, shopGroupId, effSite]
  );
  const effPlant = useMemo(
    () => effectiveCodes(sp.plantId, plantOptions),
    [sp.plantId, plantOptions]
  );

  const buildingOptions = useMemo(
    () =>
      buildBuildingOptions({
        rows: master,
        divisionId: sp.divisionId,
        shopGroupId,
        plantId: effPlant,
      }),
    [master, sp.divisionId, shopGroupId, effPlant]
  );
  const effFactory = useMemo(
    () => effectiveCodes(sp.factoryId, buildingOptions),
    [sp.factoryId, buildingOptions]
  );

  const lineOptions = useMemo(
    () =>
      buildLineOptions({
        rows: master,
        divisionId: sp.divisionId,
        shopGroupId,
        plantId: effPlant,
        factoryId: effFactory,
      }),
    [master, sp.divisionId, shopGroupId, effPlant, effFactory]
  );
  const effLine = useMemo(() => effectiveCodes(sp.lineId, lineOptions), [sp.lineId, lineOptions]);

  const operationOptions = useMemo(
    () =>
      buildOperationOptions(
        {
          rows: master,
          divisionId: sp.divisionId,
          shopGroupId,
          plantId: effPlant,
          factoryId: effFactory,
          lineId: effLine,
        },
        sp.divisionType
      ),
    [master, sp.divisionId, shopGroupId, effPlant, effFactory, effLine, sp.divisionType]
  );
  const effOperation = useMemo(
    () => effectiveCodes(sp.operationId, operationOptions),
    [sp.operationId, operationOptions]
  );
  /**
   * Line Type 만 `searchParams.operationId` 가 아니라 **스냅샷**(`lineTypeOperationId`)으로 만든다.
   * AS-IS 는 `RefreshElectrodeType`(Division / DivisionType / Operation 변경)에서만 목록을 다시
   * 만들고, Site~Line 핸들러는 Operation **선택값**만 비운다(cs:1533~1557) — 선택값을 그대로 쓰면
   * AS-IS 가 갱신하지 않는 목록이 같이 바뀐다(02 V-15 / iter-2 G-16).
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
        sp.divisionType
      ),
    [master, sp.divisionId, lineTypeOperationId, sp.divisionType]
  );

  /**
   * 'ALL' 선두 옵션 — AS-IS `AddALL(dt, true)` 이 `{Code='ALL', Name='ALL'}` 행을 index 0 에 삽입한다
   * (BLL/CommonData.cs:108~120). 표시문구가 **데이터값 'ALL' 그대로**이므로 LBL 로 번역하지 않는다
   * (없는 LBL 번호를 추측해 붙이는 것이 hook #114 위반이다). 나머지 2건은 `YesOrNo` CMBO 의 'Y'/'N'.
   */
  const bottleneckOptions = useMemo(
    () => buildBottleneckOptions(yesOrNoRows, BOTTLENECK_ALL),
    [yesOrNoRows]
  );

  /**
   * 단일 콤보 3축 기본선택 — AS-IS 는 `InitEvent` 가 `InitControls` **뒤**라 최초 바인딩 중에는
   * cascade 핸들러가 돌지 않는다(02 §4.1 배선 순서 함정). useEffect 연쇄로 짜면 초기 마운트에 N번
   * 도는 차이가 생기므로 세 축의 기본선택을 한 effect 에서 함께 결정한다.
   * 선택값이 후보에 없으면(상위 변경으로 무효화) 첫 행으로 되돌린다 — `cbo.DataSource` 바인딩 재현.
   */
  useEffect(() => {
    const patch: Partial<typeof sp> = {};
    if (divisionOptions.length > 0 && !divisionOptions.some(o => o.value === sp.divisionId)) {
      patch.divisionId = divisionOptions[0].value;
    }
    if (versionOptions.length > 0 && !versionOptions.some(o => o.value === sp.verId)) {
      patch.verId = versionOptions[0].value;
    }
    if (versionSeqOptions.length > 0 && !versionSeqOptions.some(o => o.value === sp.verSeq)) {
      patch.verSeq = versionSeqOptions[0].value;
    }
    if (Object.keys(patch).length > 0) setSearchParams(patch);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions, versionOptions, versionSeqOptions]);

  /**
   * Status 기본선택 — AS-IS `cboProgressStatus.SelectedIndex = Items.Count - 1`(cs:1048~1051).
   * 목록이 항상 1건이므로 결과적으로 **그 버전의 현재 진행상태**가 그대로 선택된다.
   * 이 값이 `sheetName`(CURRENT/CUTOFF)·GET SP 분기를 결정하므로 후보와 같은 effect 에서 확정한다.
   *
   * `sp.progressStatus` 를 dep 에 반드시 포함한다 — `setDivision` 은 Division 변경 시 progressStatus 를
   * `''` 로 리셋하는데, **새 Division 의 현재버전 진행상태가 이전과 같으면**(예: 둘 다 Current '0')
   * `currProgressStatus` 값이 불변이라 `statusOptions` memo 참조도 그대로여서 이 effect 가 깨어나지
   * 않는다 -> progressStatus 가 `''` 에 갇히고 `sheetOf('')`=CUTOFF 로 Current 데이터가 0건 조회된다
   * (Division 변경 후 Status 빈 칸 버그). 리셋된 빈 값을 dep 로 감지해 재도출한다.
   */
  useEffect(() => {
    setDerivedVersionInfo(planType, currProgressStatus);
    if (statusOptions.length === 0) return;
    if (statusOptions.some(option => option.value === sp.progressStatus)) return;
    const preferred = statusOptions.find(option => option.value === currProgressStatus);
    setSearchParams({ progressStatus: (preferred ?? statusOptions[0]).value });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planType, currProgressStatus, statusOptions, sp.progressStatus]);

  /**
   * GET SP payload — IN 15개 중 FE 가 싣는 13건(02 §1.1 / §5.4).
   * `p_user_id` 는 BE `@LoginUser` 자동 주입이라 FE 가 싣지 않는다(03 R-20). `debug_mode` 는 SP 본문
   * 미참조 리터럴이라 제외한다(03 §4.2 #15 / C-11). `planType` 은 파라미터가 아니다(02 §1.1).
   * 무선택 6축(Site~Operation·Line Type)은 `''`(무필터)가 아니라 **shop_group·상위축으로 좁혀진 후보
   * 전개값**을 보낸다(AS-IS `GetCheckedListValueNone` 전개 — `effectiveCodes`). ''를 보내면 SP가 축을
   * 통째로 건너뛰어 Division Type(60/318)·Site cascade 필터가 사라진다(바로 위 cascade와 같은 값).
   */
  const buildGetPayload = (): CapaLobFilters => ({
    // 1  p_version      — Plan Month(VER_ID)
    version: String(sp.verId ?? ''),
    // 2  p_version_seq  — VER_SEQ. AS-IS 는 byte 캐스팅(실패 시 0) -> number 로 전달
    versionSeq: Number(sp.verSeq) || 0,
    // 3  p_division_id
    divisionId: String(sp.divisionId ?? ''),
    // 4  p_site_id      — 이하 6축은 무선택('ALL') 이면 후보 전개값(effective)
    siteId: effSite,
    // 5  p_plant_id
    plantId: effPlant,
    // 6  p_factory_id   — 라벨은 Building, 파라미터는 factory (hook #112 rename)
    factoryId: effFactory,
    // 7  p_line_id
    lineId: effLine,
    // 8  p_operation_id — 전개값이 shop_group('A'Cell/'P'Module·Pack)으로 좁혀져 Division Type 필터가 된다
    operationId: effOperation,
    // 9  p_nick_name    — 팝업 다중선택 결과 `,` join. UPPER() 임의 추가 금지(공통 QA)
    nickName: String(sp.nickName ?? ''),
    // 10 p_electrode_type — Line Type 후보 스냅샷(G-16) 전개
    electrodeType: effectiveCodes(sp.electrodeType, lineTypeOptions),
    // 11 p_bottleneck_flag — 'ALL' -> '' 치환(cs:586~601)
    bottleneckFlag: sp.bottleneckFlag === BOTTLENECK_ALL ? '' : String(sp.bottleneckFlag ?? ''),
    // 12 p_program_id
    programId: MENU_ID,
    // 13 p_sheet_name   — Status 파생(CURRENT/CUTOFF)
    sheetName: sheetOf(sp.progressStatus),
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
    bottleneckOptions,
    isDivisionSettled,
    isDivisionError,
    buildGetPayload,
  };
};
