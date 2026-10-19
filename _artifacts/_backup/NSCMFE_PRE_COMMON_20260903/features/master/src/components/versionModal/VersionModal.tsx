import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { Dayjs } from 'dayjs';
import { useEffect, useMemo, useRef, useState } from 'react';

import dayjs from '@foundation/dayjs';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  MODAL_SALES_VERSION,
  MODAL_SALES_VERSION_SHEET,
  MSG,
  REPORT_TYPE,
  VERSION_ACTION,
} from './version-modal.constants';
import { callTransfer, callVersionAction, callVersionActionBp } from './versionModal.api';
import styles from './VersionModal.module.scss';
import { useVersionModalStore } from './versionModalStore';

export interface VersionModalProps {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  projectType: string;
  onSelect: (versionNo: string, label: string) => void;
}

type SalesVersionRow = ResponseData<MODAL_SALES_VERSION, MODAL_SALES_VERSION_SHEET, 'data'>;

interface VersionSearchConditions {
  sdt: string;
  edt: string;
  versionType: string;
  description: string;
}

const isSalesPlanType = (versionType: string) => versionType.includes('SP');
const isReportType = (versionType: string) => versionType.startsWith('REPORT_');
const isValidDate = (value: string) =>
  /^\d{8}$/.test(value) && dayjs(value, 'YYYYMMDD').format('YYYYMMDD') === value;
const isValidPickerDate = (value: Dayjs | null): value is Dayjs =>
  value !== null && value.isValid();
const toCellStr = (value: unknown) => {
  if (value == null) return '';
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean' || typeof value === 'bigint') {
    return String(value);
  }
  return '';
};

export const VersionModal = ({
  open,
  modalClose,
  divisionId,
  projectType,
  onSelect,
}: VersionModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const sessionUserId = useSessionStore(state => state.session.userId ?? '');
  const gridRef = useRef<FlexGridType<SalesVersionRow>>(undefined);
  const { hasButton } = useTabBtnPermissions({ menuId: MODAL_SALES_VERSION });
  const staticColumns = useVersionModalStore(state => state.staticColumns);
  const fetchStaticColumns = useVersionModalStore(state => state.fetchStaticColumns);

  const [sdt, setSdt] = useState<Dayjs | null>(null);
  const [edt, setEdt] = useState<Dayjs | null>(null);
  const [description, setDescription] = useState('');
  const [versionType, setVersionType] = useState('');
  const [includeActual, setIncludeActual] = useState(false);
  const [resultDate, setResultDate] = useState<Dayjs | null>(null);
  const [movePlan, setMovePlan] = useState(false);
  const [movePlanMonth, setMovePlanMonth] = useState<Dayjs | null>(null);
  const [updateLatest, setUpdateLatest] = useState(true);
  const [searchConditions, setSearchConditions] = useState<VersionSearchConditions>({
    sdt: '',
    edt: '',
    versionType: '',
    description: '',
  });
  const [selectedIdx, setSelectedIdx] = useState(-1);
  const [running, setRunning] = useState(false);
  // Type 변경 = Grid 초기화. 목록/액션 버튼(Create·Transfer·Copy·Delete)이 전부 versionType 축이라
  //   Type 만 바꾸고 조회하지 않으면 화면 조건과 결과가 어긋난 채 액션이 실행될 수 있다.
  //   조회 결과는 searchConditions 로만 갱신되므로 표시만 비우고 재조회는 사용자가 Search 로 직접 한다.
  const [gridCleared, setGridCleared] = useState(false);

  const versionTypeComboId =
    projectType === REPORT_TYPE.SP_W ? 'MDF_TYPE_SP_POPUP' : 'MDF_TYPE_BP_POPUP';
  const [divisionRows] = useTabComboQueries({
    filters: ['MyDivision'],
    enabled: open,
  });
  const [versionTypeRows] = useTabComboQueries({
    filters: [versionTypeComboId],
    enabled: open,
  });
  const divisionLabel = useMemo(() => {
    const division = (divisionRows ?? []).find(item => item.CODE === divisionId);
    const name = division?.NAME ?? '';
    if (!name || name === divisionId) return divisionId;
    return name.startsWith(`${divisionId} `) ? name : `${divisionId} ${name}`;
  }, [divisionId, divisionRows]);
  const versionTypeOptions = useMemo(
    () =>
      (versionTypeRows ?? []).map(item => ({
        label: item.NAME || item.CODE,
        value: item.CODE,
      })),
    [versionTypeRows]
  );

  useEffect(() => {
    if (!open || versionTypeOptions.length === 0) return;

    const initialSdt = dayjs().subtract(1, 'month');
    const initialEdt = dayjs().add(5, 'month');
    const initialVersionType = versionTypeOptions[0]?.value ?? '';

    setSdt(initialSdt);
    setEdt(initialEdt);
    setDescription('');
    setVersionType(initialVersionType);
    setIncludeActual(false);
    setResultDate(null);
    setMovePlan(false);
    setMovePlanMonth(null);
    setUpdateLatest(true);
    setSearchConditions({
      sdt: initialSdt.format('YYYYMMDD'),
      edt: initialEdt.format('YYYYMMDD'),
      versionType: initialVersionType,
      description: '',
    });
    setSelectedIdx(-1);
    setRunning(false);
    setGridCleared(false);
  }, [open, versionTypeOptions]);

  const filters = useMemo(
    () => ({
      divisionId,
      sdt: searchConditions.sdt,
      edt: searchConditions.edt,
      versionType: searchConditions.versionType,
      description: searchConditions.description,
      userId: sessionUserId,
      mnuId: MODAL_SALES_VERSION,
    }),
    [divisionId, searchConditions, sessionUserId]
  );
  const { data, refetch } = useTabProcQuery<MODAL_SALES_VERSION, MODAL_SALES_VERSION_SHEET>({
    menuId: MODAL_SALES_VERSION,
    sheetName: MODAL_SALES_VERSION_SHEET,
    tabId: 'VersionModal',
    filters,
    enabled:
      open &&
      !!searchConditions.versionType &&
      isValidDate(searchConditions.sdt) &&
      isValidDate(searchConditions.edt),
  });
  const versionRows = useMemo<SalesVersionRow[]>(
    () => (gridCleared ? [] : ((data as { data?: SalesVersionRow[] } | undefined)?.data ?? [])),
    [data, gridCleared]
  );

  const selectedVersionIsReport = isReportType(versionType);
  const selectedVersionIsSalesPlan = isSalesPlanType(versionType);
  const canRunVersionAction = hasButton(selectedVersionIsSalesPlan ? 'ACTION' : 'ACTION_BP');
  const canTransfer = hasButton('TRANSFER');

  const handleVersionTypeChange = (value: string) => {
    setVersionType(value);
    setGridCleared(true);
    gridRef.current?.select(-1, -1);
    setSelectedIdx(-1);
    setDescription('');
    setIncludeActual(false);
    setResultDate(null);
    setMovePlan(false);
    setMovePlanMonth(null);
    setUpdateLatest(true);
  };

  const handleSearch = () => {
    if (!versionType) {
      void setAlert({
        type: 'alert',
        content: t('MSG00429', '_{0} value is required.').replace('{0}', t('LBL00052', 'Type')),
      });
      return;
    }
    if (!isValidPickerDate(sdt) || !isValidPickerDate(edt)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00665', '_Please enter the search period.'),
      });
      return;
    }
    if (sdt.isAfter(edt, 'day')) {
      void setAlert({
        type: 'alert',
        content: t('MSG00108', '_Invalid period (start > end).'),
      });
      return;
    }

    const nextConditions = {
      sdt: sdt.format('YYYYMMDD'),
      edt: edt.format('YYYYMMDD'),
      versionType,
      description,
    };
    const unchanged =
      searchConditions.sdt === nextConditions.sdt &&
      searchConditions.edt === nextConditions.edt &&
      searchConditions.versionType === nextConditions.versionType &&
      searchConditions.description === nextConditions.description;

    setSelectedIdx(-1);
    setGridCleared(false);
    if (unchanged) {
      void refetch?.();
      return;
    }
    setSearchConditions(nextConditions);
  };

  const selectedRow = versionRows[selectedIdx];
  const getGridSelectedRow = () => {
    const grid = gridRef.current;
    const rowIndex = grid?.selection?.row ?? -1;
    return grid?.rows[rowIndex]?.dataItem as SalesVersionRow | undefined;
  };

  const adopt = (row: SalesVersionRow | undefined) => {
    if (!row) return;
    const rowVersionType = toCellStr(row.VERSION_TYPE);
    if (rowVersionType !== REPORT_TYPE.SP_W && rowVersionType !== REPORT_TYPE.BP_M) return;

    const versionNo = toCellStr(row.VERSION_NO);
    onSelect(versionNo, `${versionNo} ${toCellStr(row.VERSION_DESCRIPTION)}`.trim());
    modalClose();
  };

  const handleGridDblClick = (event: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const hitTest = grid.hitTest(event);
    if (hitTest.cellType !== CellType.Cell || hitTest.row < 0) return;

    setSelectedIdx(hitTest.row);
    adopt(grid.rows[hitTest.row]?.dataItem as SalesVersionRow | undefined);
  };

  useEffect(() => {
    if (!open) return;
    void fetchStaticColumns(divisionId);
  }, [open, divisionId, fetchStaticColumns]);

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || !grid.columnHeaders) return;

    const formatHandler = (_sender: unknown, event: FormatItemEventArgs) => {
      if (event.panel.cellType !== CellType.TopLeft) return;
      if (event.panel.getCellData(0, 0, false) !== 'No.') {
        event.panel.setCellData(0, 0, 'No.');
      }
      event.cell.style.textAlign = 'center';
    };
    const selectionHandler = () => setSelectedIdx(grid.selection?.row ?? -1);

    grid.formatItem.addHandler(formatHandler);
    grid.selectionChanged.addHandler(selectionHandler);
    if (open) setSelectedIdx(grid.selection?.row ?? -1);

    return () => {
      grid.formatItem?.removeHandler(formatHandler);
      grid.selectionChanged?.removeHandler(selectionHandler);
    };
  }, [open, versionRows]);

  const runAction = async (action: string) => {
    const actionRow = selectedRow ?? getGridSelectedRow();
    if (running || !actionRow) return;

    const sendYn = toCellStr(actionRow.SEND_YN);
    const versionNo = toCellStr(actionRow.VERSION_NO);
    const rowVersionType = toCellStr(actionRow.VERSION_TYPE);

    if (action === VERSION_ACTION.TRANSFER && sendYn !== 'N') {
      void setAlert({
        type: 'alert',
        content: t(MSG.SEND_ONLY_N, '_Only unsent versions can be transferred.'),
      });
      return;
    }
    if (action === VERSION_ACTION.CANCEL && sendYn !== 'Y') {
      void setAlert({
        type: 'alert',
        content: t(MSG.CANCEL_ONLY_Y, '_Only transferred versions can be canceled.'),
      });
      return;
    }
    if (action === VERSION_ACTION.DELETE && sendYn !== 'N' && sendYn !== 'C') {
      void setAlert({
        type: 'alert',
        content: t(MSG.DELETE_ONLY_NC, '_Only N or C versions can be deleted.'),
      });
      return;
    }
    if (
      isSalesPlanType(rowVersionType) &&
      (action === VERSION_ACTION.CREATE || action === VERSION_ACTION.COPY)
    ) {
      if (includeActual && !isValidPickerDate(resultDate)) {
        void setAlert({
          type: 'alert',
          content: t('MSG00429', '_{0} value is required.').replace(
            '{0}',
            t('LBL00801', 'Result Date')
          ),
        });
        return;
      }
      if (movePlan && !isValidPickerDate(movePlanMonth)) {
        void setAlert({
          type: 'alert',
          content: t('MSG00429', '_{0} value is required.').replace(
            '{0}',
            t('LBL00803', 'Reference Month')
          ),
        });
        return;
      }
    }

    const confirmMessage =
      action === VERSION_ACTION.DELETE
        ? t(MSG.DELETE_CONFIRM, '_Do you want to delete the version?')
        : action === VERSION_ACTION.COPY && !includeActual
          ? t(MSG.COPY_PLAN_ONLY, '_Do you want to copy only the plan without actual data?')
          : action === VERSION_ACTION.CANCEL
            ? t(MSG.CANCEL_CONFIRM, '_Do you want to cancel the transfer?')
            : '';
    if (confirmMessage) {
      const confirmed = await setAlert({ type: 'confirm', content: confirmMessage });
      if (!confirmed) return;
    }

    setRunning(true);
    try {
      const response =
        action === VERSION_ACTION.TRANSFER || action === VERSION_ACTION.CANCEL
          ? await callTransfer({
              divisionId,
              versionNo,
              versionType: rowVersionType,
              actionType: action,
            })
          : isSalesPlanType(rowVersionType)
            ? await callVersionAction({
                divisionId,
                versionNo,
                versionDescription: description,
                resultDate:
                  includeActual && isValidPickerDate(resultDate)
                    ? resultDate.format('YYYYMMDD')
                    : '',
                actionType: action,
                mvPlanYyyymm:
                  movePlan && isValidPickerDate(movePlanMonth)
                    ? movePlanMonth.format('YYYYMM')
                    : '',
                updateYn: updateLatest ? 'Y' : 'N',
              })
            : await callVersionActionBp({
                divisionId,
                versionNo,
                versionDescription: description,
                actionType: action,
              });

      if (!response.ok) {
        void setAlert({
          type: 'alert',
          content: response.message || t(MSG.SAVE_ERROR, '_An error occurred while saving.'),
        });
        return;
      }
      void setAlert({ type: 'alert', content: t(MSG.SAVED, '_Saved successfully.') });
      setSelectedIdx(-1);
      gridRef.current?.select(-1, -1);
      await refetch?.();
      gridRef.current?.select(-1, -1);
      setSelectedIdx(-1);
    } finally {
      setRunning(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={980}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00653', '_Version')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00663', '_Div')}
                    labelAlign='right'
                    required
                    render={() => <InputField value={divisionLabel} disabled />}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00052', '_Type')}
                    labelAlign='right'
                    required
                    render={() => (
                      <CustomDropdown
                        value={versionType}
                        options={versionTypeOptions}
                        onChange={(_, value) => handleVersionTypeChange(String(value ?? ''))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00013', 'Period')}
                    labelAlign='right'
                    required
                    render={() => (
                      <div className={styles.modalFieldRow}>
                        <div className={styles.modalDatePicker}>
                          <DatePickerCalendar
                            usecase='date'
                            elevation
                            size='small'
                            format='YYYY.MM.DD'
                            value={sdt}
                            onChange={((date: Dayjs | null) => setSdt(date)) as never}
                          />
                        </div>
                        <span>~</span>
                        <div className={styles.modalDatePicker}>
                          <DatePickerCalendar
                            usecase='date'
                            elevation
                            size='small'
                            format='YYYY.MM.DD'
                            value={edt}
                            mindate={isValidPickerDate(sdt) ? sdt : undefined}
                            onChange={((date: Dayjs | null) => setEdt(date)) as never}
                          />
                        </div>
                      </div>
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00719', '_Description')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        value={description}
                        onChange={event => setDescription(event.target.value)}
                      />
                    )}
                  />
                </Grid>

                {selectedVersionIsReport && (
                  <Grid size={4}>
                    <div className={styles.modalCheckboxField}>
                      <div className={styles.modalCheckboxLabel}>
                        <Checkbox
                          labelText={t('LBL00417', '_Include Actual')}
                          checked={includeActual}
                          onChange={(checked: boolean) => {
                            setIncludeActual(checked);
                            setResultDate(checked ? dayjs() : null);
                            setUpdateLatest(checked);
                          }}
                        />
                      </div>
                      <div className={styles.modalDatePicker}>
                        <DatePickerCalendar
                          usecase='date'
                          elevation
                          size='small'
                          format='YYYY.MM.DD'
                          value={resultDate}
                          disabled={!includeActual}
                          onChange={((date: Dayjs | null) => setResultDate(date)) as never}
                        />
                      </div>
                    </div>
                  </Grid>
                )}
                {selectedVersionIsSalesPlan && (
                  <Grid size={4}>
                    <div className={styles.modalCheckboxField}>
                      <div className={styles.modalCheckboxLabel}>
                        <Checkbox
                          labelText={t('LBL00416', '_Move Plan')}
                          checked={movePlan}
                          onChange={(checked: boolean) => {
                            setMovePlan(checked);
                            setMovePlanMonth(checked ? dayjs().subtract(1, 'month') : null);
                          }}
                        />
                      </div>
                      <div className={styles.modalReferenceControls}>
                        <div className={styles.modalDatePicker}>
                          <DatePickerCalendar
                            usecase='month'
                            elevation
                            size='small'
                            value={movePlanMonth}
                            disabled={!movePlan}
                            onChange={((date: Dayjs | null) => setMovePlanMonth(date)) as never}
                          />
                        </div>
                        {selectedVersionIsReport && (
                          <div className={styles.modalInlineCheckbox}>
                            <Checkbox
                              labelText={t('LBL00418', '_Update Latest')}
                              checked={updateLatest}
                              disabled={includeActual}
                              onChange={(checked: boolean) => setUpdateLatest(checked)}
                            />
                          </div>
                        )}
                      </div>
                    </div>
                  </Grid>
                )}
              </>
            }
          />

          <div className={styles.modalActionBar}>
            {!selectedVersionIsReport && canRunVersionAction && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel='Version Create'
                disabled={running}
                onClick={() => void runAction(VERSION_ACTION.CREATE)}
              />
            )}
            {selectedVersionIsReport && canTransfer && (
              <>
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
                  buttonLabel='Transfer'
                  disabled={running}
                  onClick={() => void runAction(VERSION_ACTION.TRANSFER)}
                />
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
                  buttonLabel='Transfer Cancel'
                  disabled={running}
                  onClick={() => void runAction(VERSION_ACTION.CANCEL)}
                />
              </>
            )}
            {selectedVersionIsReport && canRunVersionAction && (
              <>
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
                  buttonLabel='Version Copy'
                  disabled={running}
                  onClick={() => void runAction(VERSION_ACTION.COPY)}
                />
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
                  buttonLabel='Version Delete'
                  disabled={running}
                  onClick={() => void runAction(VERSION_ACTION.DELETE)}
                />
              </>
            )}
          </div>

          <div className={styles.modalGridWrapper}>
            <DataGrid<SalesVersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={staticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
              // Division 등 동일값 데이터 셀 세로 병합 — DataGrid 기본값(ColumnHeaders)은 헤더만 병합.
              //   wrapper 가 매 렌더 prop 을 grid 에 재적용하므로 effect 가 아닌 prop 으로 줘야 유지된다.
              allowMerging={AllowMerging.All}
              dblClick={handleGridDblClick}
            />
          </div>

          <div className={styles.modalButtonWrapper}>
            {selectedVersionIsReport && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel='OK'
                onClick={() => adopt(selectedRow ?? getGridSelectedRow())}
              />
            )}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
