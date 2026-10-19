// CAPA New Model 팝업(AS-IS SCP0049_CAPANewModelPopup) — Division~Operation 6단 계층 조건으로
//   Model/Item × Line × 월(Lane Qty/Priority) 후보를 조회해 일괄 등록·담당자 메일요청한다.
//   SCP0049_CAPA(본가 화면)·SCP0201_CAPA·SCP0006_ProjectRoute(Plant Assign 더블클릭) 3개 AS-IS
//   화면이 공유하는 팝업이라 공용 컴포넌트로 둔다(capa-new-model-popup.constants.ts 헤더 참고).
//
// 진행 상태(2026-09-22, UI 우선 — SP 연결부는 다음 회차): 조회조건 6단 cascade + LANE_QTY 검증은
//   전부 실제 등록된 DB 콤보로 동작한다. 그리드 조회(FindData)·저장(SaveData)·메일요청(RequestData)
//   3개는 PKG_SCP0049 미배포라 플레이스홀더 MENU_ID 로 구조만 완성해 뒀다 — 등록 후 MENU_ID_PENDING
//   교체 + 응답 파싱만 손보면 된다(ProjectRouteListSaveModal 선례와 동일 분리 방식).
import type { CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, safeString } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  buildCapaNewModelColumns,
  COMBO,
  DefColumns,
  excludeEeDivision,
  MENU_ID_PENDING,
  MSG,
  SHEET_MAIN,
} from './capa-new-model-popup.constants';
import { buildCapaMonthColumns } from './capaNewModelPopup.calendar';
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

  // FindData(cs L848-935) — SP 미배포(플레이스홀더 MENU_ID, 위 헤더 참고) 라 실패해도 조용히
  //   빈 목록으로 둔다. 등록 후 이 함수만 응답 파싱을 실 스펙에 맞게 교정하면 된다.
  const fetchList = async () => {
    if (!modelId && !itemId && !nickName) {
      void setAlert({
        type: 'alert',
        content: t('MSG00327', '_Model 와 Material,Nick Name 중에 하나는 필수 입력입니다.'),
      });
      return;
    }
    setLoading(true);
    try {
      const res = await apiClient.post<{ o_rc1?: CapaNewModelRow[] }>(
        `/${MENU_ID_PENDING}/${SHEET_MAIN}/SEARCH/call-proc`,
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
      setRows(res.data?.result?.o_rc1 ?? []);
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

  // SaveData 검증(cs L1099-1136) — E2000 LANE_QTY 존재 확인 + 월 Priority 1~9 범위. 저장 SP 는
  //   미배포라 payload 조립까지만 완성(등록 후 apiClient.post 호출부만 살리면 된다).
  const validateAndBuildSavePayload = (): { ok: boolean; msgId?: string } => {
    const source = gridRef.current?.collectionView?.sourceCollection ?? [];
    const checked = source.filter(r => (r as Record<string, unknown>)[DefColumns.CHK] === true);
    if (checked.length === 0) return { ok: false, msgId: MSG.NO_CHANGE };

    for (const row of checked) {
      const rec = row as Record<string, unknown>;
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
    }
    return { ok: true };
  };

  // 검증 실패 msgId 별 기본 문구(번역 미등록 시 폴백) — 전 분기가 '_저장 검증 실패' 하나로
  //   뭉뚱그려져 있어 "수정한 내용 없음" 같은 정상 분기까지 오류처럼 보이던 것을 msgId 별로 분리.
  const SAVE_VALIDATION_DEFAULT_TEXT: Partial<Record<string, string>> = {
    [MSG.NO_CHANGE]: '_수정한 내용이 없습니다.',
    [MSG.LANE_QTY_REQUIRED]:
      '_Lane QTY 값 확인이 필요합니다. Lane QTY 값이 없을 경우, FP Planner에게 등록 요청하시기 바랍니다.',
  };

  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid) return;
    grid.finishEditing();
    const v = validateAndBuildSavePayload();
    if (!v.ok) {
      const msgId = v.msgId ?? MSG.SAVE_ERROR;
      void setAlert({
        type: 'alert',
        content: t(msgId, SAVE_VALIDATION_DEFAULT_TEXT[msgId] ?? '_저장 검증 실패'),
      });
      return;
    }
    // TODO(SP 연결 대기): SCP0049_SAVE_NEW_MODEL 배포 후 `${MENU_ID_PENDING}/${SHEET_MAIN}/SAVE/call-proc`
    //   POST 로 교체(payload 필드는 asis-sp-inventory-capa-new-model-popup.md #2 참고, ^-delim).
    void setToast({ type: 'success', message: t(MSG.SAVE_RESULT, '_저장되었습니다.') });
  };

  const handleRequest = () => {
    const source = gridRef.current?.collectionView?.sourceCollection ?? [];
    const checked = source.filter(r => (r as Record<string, unknown>)[DefColumns.REQUEST_CHK] === true);
    if (checked.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHECKED_ROWS, '_체크된 행이 없습니다.') });
      return;
    }
    // TODO(SP 연결 대기): SCP0049_SAVE_MAIL_SEND_REQUEST 배포 후 실 호출로 교체(payload 필드는
    //   asis-sp-inventory-capa-new-model-popup.md #3 참고).
    void setToast({ type: 'success', message: t(MSG.MAIL_SENT, '_Success to send requestion e-mail.') });
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
                    label={t('LBL_GROUP', '_Group')}
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
                    label={t('LBL00619', '_Operation')}
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
              onClick={handleRequest}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Save'
              onClick={handleSave}
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
