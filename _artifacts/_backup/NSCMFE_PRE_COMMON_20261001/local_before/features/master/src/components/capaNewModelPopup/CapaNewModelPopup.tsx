// CAPA New Model 팝업(AS-IS SCP0049_CAPANewModelPopup) — Division~Operation 6단 계층 조건으로
//   Model/Item × Line × 월(Lane Qty/Priority) 후보를 조회해 일괄 등록·담당자 메일요청한다.
//   SCP0049_CAPA(본가 화면)·SCP0201_CAPA·SCP0006_ProjectRoute(Plant Assign 더블클릭) 3개 AS-IS
//   화면이 공유하는 팝업이라 공용 컴포넌트로 둔다(capa-new-model-popup.constants.ts 헤더 참고).
//
// 진행 상태(2026-09-22): PKG_SCP0049 Oracle 배포 확인(ora.py, VALID) + admin 등록 확인 후 SP 3종
//   전부 연결 완료. 저장(SaveData, cs L997-1230)은 AS-IS 가 **체크된 행 × 색상마킹된(변경) 셀**
//   단위로 payload 를 조립한다(행 전체가 아니라 dirty 셀마다 한 엔트리) — EditTracker.getOriginalValues()
//   가 셀 단위 변경 기록을 그대로 들고 있어 동일하게 재현한다.
//
// 권한별 행/셀 잠금(EditButton, cs L565-837, 2026-09-22 사용자 결정 A안 — 서버판정 아닌 AS-IS 그대로
//   클라 복제): SP #5/#6(LoadAuthority 원본 데이터, capa-new-model-popup.constants.ts 헤더 참고)은
//   아직 미이관이라 이 화면의 잠금 판정은 플레이스홀더 조회 위에서 동작한다 — 실제 SP 연결 전까지는
//   myAuthList/fpInstanceRows 가 항상 빈 배열이라 SCM PI Admin·행 책임자(USER_ID_1~10)가 아닌 이상
//   전 행이 잠긴 상태로 보인다(AS-IS bPartAuthority=false 와 동일한 안전한 기본값).
import { toggleClass } from '@mescius/wijmo';
import type { CellRangeEventArgs, FlexGrid, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, safeString } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  buildCapaNewModelColumns,
  COMBO,
  DefColumns,
  DYN_MONTH_PREFIX,
  excludeEeDivision,
  MNU_ID,
  MSG,
  SHEET_FP_INSTANCE,
  SHEET_MAIL_SEND,
  SHEET_MY_AUTH_LIST,
  SHEET_NEW_MODEL,
} from './capa-new-model-popup.constants';
import { buildCapaMonthColumns } from './capaNewModelPopup.calendar';
import {
  buildCapaAuthContext,
  type CapaAuthListRow,
  type CapaFpInstanceRow,
  hasLaneQtyCandidate,
  isAlwaysEditableBinding,
  isLockedIdentityBinding,
  resolveCapaRowEditability,
} from './capaNewModelPopup.editLock';
import styles from './CapaNewModelPopup.module.scss';

export type CapaNewModelRow = WijmoRowItem;

export interface CapaNewModelPopupParams {
  divisionId?: string;
  plantId?: string;
  groupId?: string;
  factoryId?: string;
  lineId?: string;
  operationId?: string;
  modelId?: string;
  itemId?: string;
  nickName?: string;
}

interface Props {
  open: boolean;
  onClose: () => void;
  params?: CapaNewModelPopupParams;
}

const todayYyyymmdd = (): string => {
  const now = new Date();
  return `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(
    now.getDate()
  ).padStart(2, '0')}`;
};

export const CapaNewModelPopup = ({ open, onClose, params }: Props) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore.getState();
  const sessionUserId = useSessionStore(s => s.session.userId);

  const gridRef = useRef<FlexGrid<CapaNewModelRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<CapaNewModelRow>>();

  // 조회조건 6단 cascade(AS-IS SetChangedControl/ClbXxx_SelectedIndexChanged, cs L1364-1438) —
  //   각 단계 선택 즉시 하위 단계를 재조회한다(react-query 가 파라미터 변경으로 자동 처리).
  const [divisionId, setDivisionId] = useState('');
  const [groupId, setGroupId] = useState('');
  const [plantId, setPlantId] = useState('');
  const [factoryId, setFactoryId] = useState('');
  const [lineId, setLineId] = useState('');
  const [operationId, setOperationId] = useState('');
  const [modelId, setModelId] = useState('');
  const [itemId, setItemId] = useState('');
  const [nickName, setNickName] = useState('');

  const [rows, setRows] = useState<CapaNewModelRow[]>([]);
  const [loading, setLoading] = useState(false);

  const [divisionsRaw] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const divisions = useMemo(() => divisionsRaw?.filter(excludeEeDivision), [divisionsRaw]);
  const [groups] = useTabComboQueries({
    filters: [{ comboId: COMBO.SHOP_GROUP, divisionId }],
    enabled: !!divisionId,
  });
  const [plants] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_BY_GROUP, divisionId, shopGroupId: groupId }],
    enabled: !!divisionId,
  });
  const [buildings] = useTabComboQueries({
    filters: [{ comboId: COMBO.BUILDING_BY_SHOP_GROUP, divisionId, plantId, param3: groupId }],
    enabled: !!divisionId,
  });
  const [lines] = useTabComboQueries({
    filters: [
      { comboId: COMBO.LINE_BY_OPERATION_PLANT, divisionId, plantId, factoryId, operationGroupId: groupId },
    ],
    enabled: !!divisionId,
  });
  const [operations] = useTabComboQueries({
    filters: [
      {
        comboId: COMBO.OPERATION_BY_LINE,
        divisionId,
        plantId,
        factoryId,
        lineId,
        operationGroupId: groupId,
      },
    ],
    enabled: !!divisionId,
  });
  // SaveData E2000(Dam Mixing) LANE_QTY 존재 검증용(cs L1100-1121) — 파라미터 없이 전체 1회 로드.
  const [laneQtyRows] = useTabComboQueries({ filters: [COMBO.LANE_QTY_OF_LINE_ASSIGN] });
  // EditButton 권한판정용(cs L333-338, LoadAuthority) — 둘 다 화면 전용 아닌 공용/등록 콤보.
  const [myGroupsRaw] = useTabComboQueries({ filters: [COMBO.MY_GROUPS] });
  const [operGroupRows] = useTabComboQueries({ filters: [COMBO.OPER_GROUP_BY_CAPA] });

  // LoadAuthority(cs L309-403) 원본 데이터 2종 — SP #5/#6 미이관이라 플레이스홀더 SHT_NM 으로 조회
  //   시도만 해 두고(응답 없으면 빈 배열, 전 행 잠금이라는 안전한 기본값), 배포 후 이 useEffect 만
  //   손보면 된다(다른 로직은 이미 실 데이터 스키마 그대로 짜여 있다).
  const [myAuthList, setMyAuthList] = useState<CapaAuthListRow[]>([]);
  const [fpInstanceRows, setFpInstanceRows] = useState<CapaFpInstanceRow[]>([]);
  const [searchedDivisionId, setSearchedDivisionId] = useState('');

  useEffect(() => {
    if (!open) return;
    void (async () => {
      try {
        const res = await apiClient.post<{ o_rc?: CapaAuthListRow[] }>(
          `/${MNU_ID}/${SHEET_MY_AUTH_LIST}/SEARCH/call-proc`,
          {}
        );
        setMyAuthList(res.data?.result?.o_rc ?? []);
      } catch {
        setMyAuthList([]);
      }
    })();
    void (async () => {
      try {
        const res = await apiClient.post<{ o_rc?: CapaFpInstanceRow[] }>(
          `/${MNU_ID}/${SHEET_FP_INSTANCE}/SEARCH/call-proc`,
          {}
        );
        setFpInstanceRows(res.data?.result?.o_rc ?? []);
      } catch {
        setFpInstanceRows([]);
      }
    })();
  }, [open]);

  // PlannerTypeLogic(cs L936-995) — 조회에 실제 사용된 division 기준(폼의 현재값이 아니다).
  const authCtx = useMemo(
    () =>
      buildCapaAuthContext(
        myAuthList,
        fpInstanceRows,
        (myGroupsRaw ?? []).map(g => safeString(g.CODE)),
        (operGroupRows ?? []).map(r => safeString(r.CODE)),
        searchedDivisionId
      ),
    [myAuthList, fpInstanceRows, myGroupsRaw, operGroupRows, searchedDivisionId]
  );

  // 팝업이 열릴 때마다 호출 화면 파라미터로 초기화(AS-IS LoadData, cs L235-248).
  useEffect(() => {
    if (!open) return;
    setDivisionId(params?.divisionId ?? '');
    setGroupId(params?.groupId && params.groupId !== 'ALL' ? params.groupId : '');
    setPlantId(params?.plantId && params.plantId !== 'ALL' ? params.plantId : '');
    setFactoryId(params?.factoryId && params.factoryId !== 'ALL' ? params.factoryId : '');
    setLineId(params?.lineId && params.lineId !== 'ALL' ? params.lineId : '');
    setOperationId(params?.operationId && params.operationId !== 'ALL' ? params.operationId : '');
    setModelId(params?.modelId ?? '');
    setItemId(params?.itemId ?? '');
    setNickName(params?.nickName ?? '');
    setRows([]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // LANE_QTY 컬럼은 Group='E'(Electrode) 일 때만 노출(SetColumnVisible, cs L1519-1526).
  const isGroupElectrode = groupId
    .split(',')
    .map(v => v.trim())
    .includes('E');
  const staticColumns = useMemo(
    () => buildCapaNewModelColumns(isGroupElectrode),
    [isGroupElectrode]
  );
  const monthColumns = useMemo(() => buildCapaMonthColumns(todayYyyymmdd().slice(0, 6)), []);

  // FindData(cs L848-935) — P_GET_NEW_MODEL(SCP0049/newModel/SEARCH). 데이터 행은 O_RC 커서
  //   (result.o_rc), O_RESULT_CURSOR 는 상태코드 전용(RESULT_CODE/RESULT_MSG)이라 검색 실패는
  //   AS-IS FindData 와 동일하게 빈 목록으로만 처리한다(SP 자체가 예외 시에도 빈 O_RC 를 연다).
  const fetchList = async () => {
    if (!modelId && !itemId && !nickName) {
      void setAlert({
        type: 'alert',
        content: t('MSG00327', 'Model, Material, Nick Name 중 하나는 필수 입력입니다.'),
      });
      return;
    }
    // PlannerTypeLogic(cs L925)이 조회 시점 division 으로 재판정하는 것과 동일 — 폼 값이 그 뒤에
    // 바뀌어도(재검색 전까지) 권한판정은 이 검색에 쓰인 division 을 기준으로 고정한다.
    setSearchedDivisionId(divisionId);
    setLoading(true);
    try {
      const res = await apiClient.post<{ o_rc?: CapaNewModelRow[] }>(
        `/${MNU_ID}/${SHEET_NEW_MODEL}/SEARCH/call-proc`,
        {
          todayYyyymmdd: todayYyyymmdd(),
          divisionId,
          plantId,
          groupId,
          factoryId,
          lineId,
          operationId,
          modelId,
          itemId,
          nickName,
        }
      );
      setRows(res.data?.result?.o_rc ?? []);
    } catch {
      setRows([]);
    } finally {
      setLoading(false);
    }
  };

  // shtMain_Changed(cs L1440-1467) — CHK/REQUEST_CHK 아닌 셀이 바뀌면 그 행 CHK 를 자동 체크.
  const handleCellEdit = (grid: FlexGrid<CapaNewModelRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;
    if (binding === DefColumns.CHK || binding === DefColumns.REQUEST_CHK) return;

    const record = dataItem as Record<string, unknown>;
    if (record.CRUD_TYPE === 'M' && record[DefColumns.CHK] !== true) {
      editTrackerRef.current?.storeChange(dataItem, DefColumns.CHK, record[DefColumns.CHK] as string, true);
      record[DefColumns.CHK] = true;
      GridUtils.refreshRow(grid, e.row);
    }
  };

  // EditButton(cs L565-837) — AS-IS 의 Edit 토글 버튼 개념은 쓰지 않는다(SCP0006 과 같은 "상시편집"
  //   구조 — 검색 직후 이미 권한별로 언락된 상태를 그대로 재현, cs FindData 의 finally 가 매 검색마다
  //   bEdit_Mode=false→OnClickEditButton() 으로 자동 재계산하던 것과 동일 타이밍). rows/authCtx 가
  //   바뀔 때마다 핸들러를 다시 걸고(이전 핸들러는 정리), 이 시점엔 gridRef.current 가 이미 초기화돼
  //   있다(그리드는 팝업이 열리자마자 마운트되고, 이 effect 는 최초 검색으로 rows 가 채워진 뒤에야
  //   실행되므로 mount 순서 걱정이 없다).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const rowEditability = (row: CapaNewModelRow) =>
      resolveCapaRowEditability(
        row as Record<string, unknown>,
        sessionUserId ?? '',
        isGroupElectrode,
        authCtx,
        hasLaneQtyCandidate(row as Record<string, unknown>, laneQtyRows ?? [])
      );

    const beginningEditHandler = (
      g: FlexGrid<CapaNewModelRow>,
      e: CellRangeEventArgs & { cancel: boolean }
    ) => {
      const binding = g.columns[e.col]?.binding ?? '';
      if (isAlwaysEditableBinding(binding)) return;
      if (isLockedIdentityBinding(binding)) {
        e.cancel = true;
        return;
      }
      const row = GridUtils.getRow(g, e.row);
      if (!row) {
        e.cancel = true;
        return;
      }
      const editability = rowEditability(row);
      e.cancel = binding === DefColumns.LANE_QTY ? !editability.laneQtyEditable : !editability.rowEditable;
    };
    grid.beginningEdit.addHandler(beginningEditHandler);
    grid.pastingCell.addHandler(beginningEditHandler as never);

    const formatHandler = (g: FlexGrid<CapaNewModelRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.getColumn().binding ?? '';
      if (isLockedIdentityBinding(binding)) return;
      const row = e.getRow().dataItem as CapaNewModelRow | undefined;
      if (!row) return;
      const editable = isAlwaysEditableBinding(binding)
        ? true
        : binding === DefColumns.LANE_QTY
          ? rowEditability(row).laneQtyEditable
          : rowEditability(row).rowEditable;
      toggleClass(e.cell, 'wj-cell-editable', editable);
    };
    grid.formatItem.addHandler(formatHandler);
    grid.invalidate();

    return () => {
      grid.beginningEdit.removeHandler(beginningEditHandler);
      grid.pastingCell.removeHandler(beginningEditHandler as never);
      grid.formatItem.removeHandler(formatHandler);
    };
  }, [rows, authCtx, isGroupElectrode, laneQtyRows, sessionUserId]);

  // 검증 실패 msgId 별 기본 문구(번역 미등록 시 폴백).
  const SAVE_VALIDATION_DEFAULT_TEXT: Partial<Record<string, string>> = {
    [MSG.NO_CHANGE]: '_수정한 내용이 없습니다.',
    [MSG.LANE_QTY_REQUIRED]:
      '_Lane QTY 값 확인이 필요합니다. Lane QTY 값이 없을 경우, FP Planner에게 등록 요청하시기 바랍니다.',
    [MSG.PRIORITY_RANGE]: '_{0}~{1} 사이의 수를 입력하세요.',
  };

  interface SaveEntry {
    activeFlag: string;
    divisionId: string;
    companyId: string;
    siteId: string;
    plantId: string;
    factoryId: string;
    operationId: string;
    itemId: string;
    lineId: string;
    electrodeType: string;
    dayName: string;
    dayQty: string;
    laneQty: string;
    dataType: 'LANE_QTY_DATA' | 'PRIORITY_DATA';
  }

  // SaveData(cs L997-1230) — 체크된 행 × 색상마킹(변경)된 셀 단위로 엔트리를 만든다(행 전체가
  //   아니다). EditTracker.getOriginalValues() 가 셀 단위 변경 기록(원본값이 남은 binding)을
  //   그대로 갖고 있어 AS-IS 의 colorName=="Red" 판정과 동등하다. LANE_QTY 셀은
  //   dataType=LANE_QTY_DATA, 월(M_YYYYMM) 셀은 dataType=PRIORITY_DATA(1~9 범위 검증).
  //   E2000 라인은 그 행에 변경 셀이 하나라도 있으면 현재 LANE_QTY 가 후보 목록에 있어야 한다
  //   (cs L1100-1121, 매 dirty 셀마다 재검증하지만 결과는 행 1회 판정과 동일해 1회만 수행).
  const buildSaveEntries = (): { ok: true; entries: SaveEntry[] } | { ok: false; msgId: string; msgArgs?: string[] } => {
    const originals = editTrackerRef.current?.getOriginalValues();
    if (!originals || originals.size === 0) return { ok: false, msgId: MSG.NO_CHANGE };

    const entries: SaveEntry[] = [];

    for (const [row, editItem] of originals) {
      const rec = row as Record<string, unknown>;
      if (rec[DefColumns.CHK] !== true) continue;

      const dirtyBindings = Object.keys(editItem).filter(
        b => b === DefColumns.LANE_QTY || /^M_\d{6}$/.test(b)
      );
      if (dirtyBindings.length === 0) continue;

      const opId = safeString(rec[DefColumns.OPERATION_ID]);
      const laneQty = safeString(rec[DefColumns.LANE_QTY]);
      if (opId === 'E2000') {
        const matched = (laneQtyRows ?? []).some(
          l =>
            safeString(l.DIVISION_ID) === safeString(rec[DefColumns.DIVISION_ID]) &&
            safeString(l.ITEM_ID) === safeString(rec[DefColumns.ITEM_ID]) &&
            safeString(l.LINE_ID) === safeString(rec[DefColumns.LINE_ID]) &&
            safeString(l.ELECTRODE_TYPE) === safeString(rec[DefColumns.ELECTRODE_TYPE]) &&
            safeString(l.CODE) === laneQty
        );
        if (!matched) return { ok: false, msgId: MSG.LANE_QTY_REQUIRED };
      }

      for (const binding of dirtyBindings) {
        const dayQty = safeString(rec[binding]);
        const isLaneQty = binding === DefColumns.LANE_QTY;
        if (!isLaneQty && (Number(dayQty) < 1 || Number(dayQty) > 9)) {
          return { ok: false, msgId: MSG.PRIORITY_RANGE, msgArgs: ['1', '9'] };
        }
        entries.push({
          activeFlag: safeString(rec.CRUD_TYPE) || 'M',
          divisionId: safeString(rec[DefColumns.DIVISION_ID]),
          companyId: safeString(rec[DefColumns.COMPANY_ID]),
          siteId: safeString(rec[DefColumns.SITE_ID]),
          plantId: safeString(rec[DefColumns.PLANT_ID]),
          factoryId: safeString(rec[DefColumns.FACTORY_ID]),
          operationId: opId,
          itemId: safeString(rec[DefColumns.ITEM_ID]),
          lineId: safeString(rec[DefColumns.LINE_ID]),
          electrodeType: safeString(rec[DefColumns.ELECTRODE_TYPE]),
          dayName: isLaneQty ? 'LANE_QTY' : binding.replace(DYN_MONTH_PREFIX, ''),
          dayQty,
          laneQty,
          dataType: isLaneQty ? 'LANE_QTY_DATA' : 'PRIORITY_DATA',
        });
      }
    }

    if (entries.length === 0) return { ok: false, msgId: MSG.NO_CHANGE };
    return { ok: true, entries };
  };

  const handleSave = async () => {
    const grid = gridRef.current;
    if (!grid) return;
    grid.finishEditing();

    const v = buildSaveEntries();
    if (!v.ok) {
      let content = t(v.msgId, SAVE_VALIDATION_DEFAULT_TEXT[v.msgId] ?? '_저장 검증 실패');
      v.msgArgs?.forEach((arg, i) => {
        content = content.replace(`{${i}}`, arg);
      });
      void setAlert({ type: 'alert', content });
      return;
    }

    const acc: Record<keyof SaveEntry, string[]> = {
      activeFlag: [],
      divisionId: [],
      companyId: [],
      siteId: [],
      plantId: [],
      factoryId: [],
      operationId: [],
      itemId: [],
      lineId: [],
      electrodeType: [],
      dayName: [],
      dayQty: [],
      laneQty: [],
      dataType: [],
    };
    for (const e of v.entries) (Object.keys(acc) as (keyof SaveEntry)[]).forEach(k => acc[k].push(e[k]));

    const payload: Record<string, string> = { todayYyyymmdd: todayYyyymmdd(), updateId: sessionUserId ?? '' };
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

    try {
      const res = await apiClient.post<{ o_rc?: Array<{ RESULT_CODE?: string; RESULT_CNT?: number }> }>(
        `/${MNU_ID}/${SHEET_NEW_MODEL}/SAVE/call-proc`,
        payload
      );
      const result = res.data?.result?.o_rc?.[0];
      if (result?.RESULT_CODE === 'S') {
        editTrackerRef.current?.clearChanges();
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_RESULT, '_{0}개의 데이터가 저장되었습니다.').replace(
            '{0}',
            safeString(result.RESULT_CNT)
          ),
        });
      } else {
        void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_실행중 에러가 발생했습니다.') });
      }
    } catch {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_실행중 에러가 발생했습니다.') });
    }
  };

  // RequestData(cs L1236-1334) — REQUEST_CHK 체크된 행 단위(셀 단위 아님)로 담당자 등록 요청
  //   메일을 보낸다. loss_code 는 AS-IS 하드코딩 "LA001" 그대로.
  const handleRequest = async () => {
    const source = gridRef.current?.collectionView?.sourceCollection ?? [];
    const checked = source.filter(r => (r as Record<string, unknown>)[DefColumns.REQUEST_CHK] === true);
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHECKED_ROWS, '_체크된 행이 없습니다.') });
      return;
    }

    const acc: Record<string, string[]> = {
      divisionId: [],
      companyId: [],
      siteId: [],
      plantId: [],
      factoryId: [],
      operationId: [],
      lineId: [],
      electrodeType: [],
      itemId: [],
      laneQty: [],
      lossCode: [],
    };
    for (const row of checked) {
      const rec = row as Record<string, unknown>;
      acc.divisionId.push(safeString(rec[DefColumns.DIVISION_ID]));
      acc.companyId.push(safeString(rec[DefColumns.COMPANY_ID]));
      acc.siteId.push(safeString(rec[DefColumns.SITE_ID]));
      acc.plantId.push(safeString(rec[DefColumns.PLANT_ID]));
      acc.factoryId.push(safeString(rec[DefColumns.FACTORY_ID]));
      acc.operationId.push(safeString(rec[DefColumns.OPERATION_ID]));
      acc.lineId.push(safeString(rec[DefColumns.LINE_ID]));
      acc.electrodeType.push(safeString(rec[DefColumns.ELECTRODE_TYPE]));
      acc.itemId.push(safeString(rec[DefColumns.ITEM_ID]));
      acc.laneQty.push(safeString(rec[DefColumns.LANE_QTY]));
      acc.lossCode.push('LA001');
    }
    const payload: Record<string, string> = { updateId: sessionUserId ?? '' };
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

    try {
      const res = await apiClient.post<{ O_RESULT_CURSOR?: Array<{ RESULT_CODE?: string }> }>(
        `/${MNU_ID}/${SHEET_MAIL_SEND}/SAVE/call-proc`,
        payload
      );
      if (res.data?.result?.O_RESULT_CURSOR?.[0]?.RESULT_CODE === 'S') {
        void setToast({ type: 'success', message: t(MSG.MAIL_SENT, '_Success to send requestion e-mail.') });
      } else {
        void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_실행중 에러가 발생했습니다.') });
      }
    } catch {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_실행중 에러가 발생했습니다.') });
    }
  };

  return (
    <CustomDialog
      size={1400}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>CAPA New Model</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00112', '_Search')}
            onSearch={() => void fetchList()}
            conditions={
              <>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00001', '_Division')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        value={divisionId}
                        options={divisions?.map(d => ({ label: d.NAME, value: d.CODE })) ?? []}
                        onChange={(_, option) => {
                          setDivisionId(String(option ?? ''));
                          setGroupId('');
                          setPlantId('');
                          setFactoryId('');
                          setLineId('');
                          setOperationId('');
                        }}
                      />
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00313', 'Group')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        limitTags={1}
                        value={groupId}
                        options={groups?.map(g => ({ label: g.NAME, value: g.CODE })) ?? []}
                        onChange={(_, value) => setGroupId(value)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00013', '_Plant')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        limitTags={1}
                        value={plantId}
                        options={plants?.map(p => ({ label: p.NAME, value: p.CODE })) ?? []}
                        onChange={(_, value) => setPlantId(value)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00341', '_Building')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        limitTags={1}
                        value={factoryId}
                        options={buildings?.map(b => ({ label: b.NAME, value: b.CODE })) ?? []}
                        onChange={(_, value) => setFactoryId(value)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00618', '_Line')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        limitTags={1}
                        value={lineId}
                        options={lines?.map(l => ({ label: l.NAME, value: l.CODE })) ?? []}
                        onChange={(_, value) => setLineId(value)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00009', 'Operation')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        limitTags={1}
                        value={operationId}
                        options={operations?.map(o => ({ label: o.NAME, value: o.CODE })) ?? []}
                        onChange={(_, value) => setOperationId(value)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00669', '_Model')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={modelId}
                        onChange={e => setModelId(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && void fetchList()}
                      />
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label='Material'
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={itemId}
                        onChange={e => setItemId(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && void fetchList()}
                      />
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label='Nick Name'
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={nickName}
                        onChange={e => setNickName(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && void fetchList()}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator shape='circular' apprearance='infinite' open={loading} placement='parent' />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<CapaNewModelRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                editTrackerRef={editTrackerRef}
                itemsSource={rows}
                staticColumns={staticColumns}
                dynamicColumns={monthColumns}
                cellEditEnded={handleCellEdit}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Mail Request'
              onClick={() => void handleRequest()}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Save'
              onClick={() => void handleSave()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
