// CAPA New Model 팝업(AS-IS SCP0049_CAPANewModelPopup) — Division~Operation 6단 계층 조건으로
//   Model/Item × Line × 월(Lane Qty/Priority) 후보를 조회해 담당자에게 등록 요청 메일을 보낸다.
//   SCP0049_CAPA(본가 화면)·SCP0201_CAPA·SCP0006_ProjectRoute(Plant Assign 더블클릭) 3개 AS-IS
//   화면이 공유하는 팝업이라 공용 컴포넌트로 둔다(capa-new-model-popup.constants.ts 헤더 참고).
//
// 2026-11-02 사용자 결정 — 이 팝업을 조회 전용으로 전환했다. AS-IS 의 저장(SaveData)·CHK('Save')
//   선택 체크박스·권한별 행/셀 편집잠금(EditButton/LoadAuthority)은 전부 제거하고, 그리드는 Mail Req
//   체크박스를 제외한 모든 셀을 읽기전용으로 둔다. 남는 쓰기 동작은 Mail Request(담당자 등록요청
//   메일) 하나뿐이다. 편집/저장/권한판정이 사라져 capaNewModelPopup.editLock.ts 는 더 이상 쓰이지
//   않는다(향후 SCP0049/SCP0201 편집 화면을 구축하면 그 로직을 되살린다).
import type { CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MaterialByDivisionModal } from '../materialByDivisionModal/MaterialByDivisionModal';

import {
  buildCapaNewModelColumns,
  COMBO,
  DefColumns,
  excludeEeDivision,
  MNU_ID,
  MSG,
  REQUEST_CHK_COLUMN,
  SHEET_MAIL_SEND,
  SHEET_NEW_MODEL,
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
  const sessionUserId = useSessionStore(s => s.session.userId);

  const gridRef = useRef<FlexGrid<CapaNewModelRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

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
  const [modelPopupOpen, setModelPopupOpen] = useState(false);

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
  // AS-IS 컬럼 순서 재현: 동적 월 컬럼 뒤에 Mail Req(REQUEST_CHK)를 마지막으로 붙인다(constants 헤더 참고).
  const dynamicColumns = useMemo(() => [...monthColumns, REQUEST_CHK_COLUMN], [monthColumns]);

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

  // 조회 전용(2026-11-02) — Mail Req(REQUEST_CHK) 체크박스만 편집 가능하고 나머지 셀은 전부 잠근다.
  //   grid.isReadOnly 는 전 셀을 잠가 Mail Req 까지 막으므로, 셀 단위로 beginningEdit/pastingCell 을
  //   취소하는 방식을 쓴다. rows 가 채워진 뒤 핸들러를 다시 건다(이전 핸들러는 정리).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const lockHandler = (
      g: FlexGrid<CapaNewModelRow>,
      e: CellRangeEventArgs & { cancel: boolean }
    ) => {
      const binding = g.columns[e.col]?.binding ?? '';
      if (binding !== DefColumns.REQUEST_CHK) e.cancel = true;
    };
    grid.beginningEdit.addHandler(lockHandler);
    grid.pastingCell.addHandler(lockHandler as never);

    return () => {
      grid.beginningEdit.removeHandler(lockHandler);
      grid.pastingCell.removeHandler(lockHandler as never);
    };
  }, [rows]);

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
                    label={t('LBL00313', '_Group')}
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
                    label={t('LBL00030', '_Plant')}
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
                    label={t('LBL00008', '_Building')}
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
                    label={t('LBL00010', '_Line')}
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
                    label={t('LBL00009', '_Operation')}
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
                {/* Model/Nickname 한 칸으로 통합, 값은 modelId 로 전송 */}
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00618', '_Model/Nickname')}
                    labelAlign='right'
                    render={() => (
                      // 입력칸 옆에 돋보기 버튼(SearchFields PopupSearchInput 과 같은 배치)
                      <div className={styles.popupSearchRow}>
                        <InputField
                          fullWidth
                          value={modelId}
                          onChange={e => setModelId(e.target.value)}
                          onKeyDown={e => e.key === 'Enter' && void fetchList()}
                        />
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={<FunctionSearchIcon appearance='lined' />}
                          onClick={() => setModelPopupOpen(true)}
                        />
                      </div>
                    )}
                  />
                </Grid>
                <Grid size={2}>
                  <FormItem
                    label={t('LBL00021', '_Material')}
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
                {/* <Grid size={2}>
                  <FormItem
                    label={t('LBL00767', '_Nick Name')}
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
                </Grid> */}
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator shape='circular' apprearance='infinite' open={loading} placement='parent' />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<CapaNewModelRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows}
                staticColumns={staticColumns}
                dynamicColumns={dynamicColumns}
                // 조회 전용 — SAVE 자동 잠금 opt-out(Mail Req 체크박스는 열어둬야 함), 수정상태 컬럼
                //   숨김, Mail Req 선택은 저장 대상이 아니므로 이탈 가드에서 제외. 셀 잠금은 위
                //   useEffect 의 beginningEdit 핸들러가 Mail Req 외 전 셀에서 처리한다.
                saveAuth={false}
                hideStatusColumn
                excludeFromDirtyCheck
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
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={onClose}
            />
          </div>
          {/* CAPA 메인 Model/Nickname 과 같은 팝업 */}
          <MaterialByDivisionModal
            open={modelPopupOpen}
            modalClose={() => setModelPopupOpen(false)}
            multiCheckbox
            setSelectedValue={items => setModelId(items)}
            preSearchParams={{
              divisionId,
              operationGroup: '',
              scpModuleType: MNU_ID,
              itemId: modelId,
            }}
          />
        </div>
      }
    />
  );
};
