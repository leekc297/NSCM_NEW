import { CellType, type FlexGrid as FlexGridType, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  DIVISION_40,
  MENU_ID,
  MSG,
  SHEETS,
  VERSION_POPUP_MONTHS_BACK,
  VERSION_POPUP_MONTHS_FWD,
  VERSION_TYPE_DEFAULT,
  VERSION_TYPE_LOOKUP,
} from '../../demand-manager.constants';
import type { VersionPopupRow } from '../../demand-manager.types';
import styles from '../../DemandManager.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  onSelect: (versionNo: string, label: string) => void;
}

// 버전 목록 컬럼 — AS-IS DMF0068_VersionPopup 이 코드로 직접 만든 8개 중 표시 5개
//   (Division / Seq / Date 는 AS-IS 에서도 숨김)
const VERSION_COLUMNS = [
  { key: 'VERSION_NO', header: 'Version', width: 220 },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 300 },
  { key: 'VERSION_TYPE', header: 'Type', width: 110 },
  { key: 'CREATED_BY', header: 'Create By', width: 110 },
  { key: 'CREATION_DATE', header: 'Create Date', width: 140 },
];

// ⭐ Version 팝업 — AS-IS DMF0068_VersionPopup(389행) 1:1.
//   사업부는 40 고정으로 열리고 기간 기본값은 오늘 기준 앞뒤 3개월이다.
//   한 건만 고를 수 있으며 두 건 이상이면 안내 후 막는다. 행 더블클릭은 바로 채택이다.
export const VersionPopupModal = ({ open, modalClose, onSelect }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<VersionPopupRow>>(undefined);

  const [sdt, setSdt] = useState('');
  const [edt, setEdt] = useState('');
  const [versionType, setVersionType] = useState<string>(VERSION_TYPE_DEFAULT);
  const [description, setDescription] = useState('');

  const [typeRows] = useTabComboQueries({ filters: [VERSION_TYPE_LOOKUP] });
  const typeOptions = useMemo(
    () =>
      ((typeRows ?? []) as unknown as Array<Record<string, string>>).map(r => ({
        label: String(r.NAME ?? r.CODE ?? ''),
        value: String(r.CODE ?? ''),
      })),
    [typeRows]
  );

  useEffect(() => {
    if (!open) return;
    setSdt(dayjs().subtract(VERSION_POPUP_MONTHS_BACK, 'month').startOf('month').format('YYYYMMDD'));
    setEdt(dayjs().add(VERSION_POPUP_MONTHS_FWD, 'month').endOf('month').format('YYYYMMDD'));
    setVersionType(VERSION_TYPE_DEFAULT);
    setDescription('');
  }, [open]);

  // ⭐ filters 는 메모이즈한 참조로 넘긴다 (인라인 객체는 매 렌더 새 참조 → 무한 재조회)
  const filters = useMemo(
    () => ({
      startYyyymmdd: sdt,
      endYyyymmdd: edt,
      divisionId: DIVISION_40,
      versionType,
      description,
    }),
    [sdt, edt, versionType, description]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.VERSION_POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION_POPUP,
    tabId: MENU_ID,
    filters,
    enabled: open && sdt !== '' && edt !== '' && versionType !== '',
  });
  const versionRows = useMemo<VersionPopupRow[]>(
    () => (data as { o_rc1?: VersionPopupRow[] } | undefined)?.o_rc1 ?? [],
    [data]
  );

  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      VERSION_COLUMNS.map(
        (c): RawFlexGridColumnConfig => ({
          colNm: c.key,
          colLblNm: c.header,
          colWth: c.width,
          fixed: false,
          visible: true,
          display: true,
          inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        })
      ),
    []
  );

  const adopt = (row: VersionPopupRow | undefined) => {
    if (!row) {
      void setAlert({ type: 'alert', content: t(MSG.VERSION_ONE_ONLY, '_버전은 1개만 선택해 주세요.') });
      return;
    }
    const versionNo = String(row.VERSION_NO ?? '');
    if (!versionNo) return;
    onSelect(versionNo, `${versionNo} ${String(row.VERSION_DESCRIPTION ?? '')}`.trim());
    modalClose();
  };

  /**
   * 선택된 행을 클릭 시점에 그리드에서 직접 읽는다.
   * ⭐ 조회 결과 배열을 인덱스로 뒤지지 않는다 — 그리드 행 순서와 배열 순서가 어긋나거나
   *    행이 많아 가상 스크롤이 동작하면 인덱스가 맞지 않아 "선택 안 됨"으로 잘못 판정된다.
   *    선택 행 객체는 그리드가 이미 들고 있으므로 그것을 그대로 쓴다.
   */
  const adoptCurrentSelection = () => {
    const g = gridRef.current;
    const items = (g?.selectedItems ?? []) as VersionPopupRow[];
    if (items.length > 1) {
      void setAlert({ type: 'alert', content: t(MSG.VERSION_ONE_ONLY, '_버전은 1개만 선택해 주세요.') });
      return;
    }
    const rowIdx = g?.selection?.row ?? -1;
    const fromGrid =
      rowIdx >= 0 ? (g?.rows?.[rowIdx]?.dataItem as VersionPopupRow | undefined) : undefined;
    const picked = items[0] ?? fromGrid;
    if (!picked) {
      // 고른 행이 없을 때는 "1개만 선택" 이 아니라 선택을 요청하는 안내가 맞다
      void setAlert({ type: 'alert', content: t(MSG.VERSION_REQUIRED, '_버전을 선택하세요.') });
      return;
    }
    adopt(picked);
  };

  // 행 선택 추적 + 더블클릭 채택 + No. 코너 (hook #108)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    const dblClickHandler = () => {
      adoptCurrentSelection();
    };
    g.formatItem.addHandler(formatHandler);
    g.hostElement?.addEventListener('dblclick', dblClickHandler);
    return () => {
      try {
        g.formatItem.removeHandler(formatHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [versionRows]);

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
          <h2 className='headerTitle'>Version</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={() => void refetch?.()}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => <InputField value={DIVISION_40} disabled />}
                  />
                </Grid>
                <Grid size={5}>
                  <FormItem
                    label={t('LBL00013', 'Period')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.modalFieldRow}>
                        <InputField
                          value={sdt}
                          onChange={e => setSdt(e.target.value)}
                          placeholder='YYYYMMDD'
                        />
                        <span>~</span>
                        <InputField
                          value={edt}
                          onChange={e => setEdt(e.target.value)}
                          placeholder='YYYYMMDD'
                        />
                      </div>
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00052', 'Type')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        value={versionType}
                        options={typeOptions}
                        onChange={(_, v) => setVersionType(String(v ?? ''))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00608', 'Description')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        value={description}
                        onChange={e => setDescription(e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />

          <div className={styles.modalGridWrapper}>
            <DataGrid<VersionPopupRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
            />
          </div>

          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={adoptCurrentSelection}
            />
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
