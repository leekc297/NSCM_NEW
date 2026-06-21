import type { CollectionView } from '@mescius/wijmo';
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker} from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  MODAL_SHEET_DATA,
  MODAL_SHEET_YEAR,
  MODAL_VERSION,
} from './contribute-version-modal.constants';
import styles from './ContributeVersionModal.module.scss';
import { useContributeVersionModalStore } from './contributeVersionModalStore';

// AS-IS POPUP/DMF0043_ContributeRatePopup.cs (Designer.cs L326 "기여율 버전관리").
// - FindData L194: DMF0043_GET_CONTRIBUTE_RATE_POPUP(p_yyyy)
// - SaveData L240: DMF0043_SAVE_DM_MST_CONTRIBUTE_VER (^ 구분 bulk string)
// - InsertButton L308: VER_SEQ 자동 채번 + 신규 row top edit
// - DeleteButton L171: 선택 row 즉시 삭제 (신규는 splice, 기존은 CRUD_TYPE=D 마킹)
// 2026-06-19: #67 표준 5 파일 lift + FlexGrid JSX 제거 + DataGrid + GridAction + EditTracker 사용.

interface VersionRow extends WijmoRowItem {
  VER_SEQ: string | number;
  YYYY: string;
  VERSION_NM: string;
  VALID_YN: string;
  DESCRIPTION: string;
}

interface YearOption extends WijmoRowItem {
  CODE: string | number;
  NAME: string;
  NAME2: string;
}

interface ContributeVersionModalProps {
  open: boolean;
  modalClose: () => void;
}

export const ContributeVersionModal = ({ open, modalClose }: ContributeVersionModalProps) => {
  const { t } = useTranslation();

  const initialized = useContributeVersionModalStore(s => s.initialized);
  const staticColumns = useContributeVersionModalStore(s => s.staticColumns);
  const fetchStaticColumns = useContributeVersionModalStore(s => s.fetchStaticColumns);
  const selectedYear = useContributeVersionModalStore(s => s.selectedYear);
  const setSelectedYear = useContributeVersionModalStore(s => s.setSelectedYear);

  const setAlert = useMessageStore(s => s.setAlert);
  const sessionUserId = useSessionStore(s => s.session.userId ?? '');
  const queryClient = useQueryClient();

  const gridRef = useRef<FlexGrid<VersionRow> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  const editTrackerRef = useRef<EditTracker<VersionRow> | undefined>();
  const savingRef = useRef(false);

  const { data: yearData } = useTabProcQuery<MODAL_VERSION>({
    menuId: MODAL_VERSION,
    sheetName: MODAL_SHEET_YEAR,
    tabId: MODAL_VERSION,
    filters: {},
    enabled: open,
  });

  const yearOptions = useMemo<YearOption[]>(
    () => (yearData?.o_rc1 ?? []) as YearOption[],
    [yearData]
  );

  const { data: rateData, refetch } = useTabProcQuery<MODAL_VERSION>({
    menuId: MODAL_VERSION,
    sheetName: MODAL_SHEET_DATA,
    tabId: MODAL_VERSION,
    filters: { yyyy: selectedYear },
    enabled: open && !!selectedYear,
  });

  const itemsSource = useMemo<VersionRow[]>(
    () =>
      ((rateData?.o_rc1 ?? []) as VersionRow[]).map(r => ({
        ...r,
        VER_SEQ: r.VER_SEQ != null ? String(r.VER_SEQ) : '',
        YYYY: r.YYYY != null ? String(r.YYYY) : selectedYear,
        // CRUD_TYPE 강제 set 금지 — EditTracker 가 storeChange 시 'M' / undefined 자체 마킹.
        // 'N' 등 임의 값 set 시 EditTracker._originalValues Map key 불일치 → dirty=0 사고.
      })),
    [rateData, selectedYear]
  );

  // popup open 시 staticColumns + Year combo default 첫 항목 자동 선택 (AS-IS 동일).
  useEffect(() => {
    if (!open) return;
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  useEffect(() => {
    if (!open) return;
    if (yearOptions.length === 0) return;
    if (selectedYear) return;
    const first = yearOptions[0];
    const code = String(first.CODE ?? first.NAME ?? '').trim();
    if (code) setSelectedYear(code);
  }, [open, yearOptions, selectedYear]);

  // sort indicator 사고 fix — wijmo column.allowSorting 기본 true → 모든 column 에
  // indicator 표시. F3(toggleColumnSort) 누르기 전엔 false 로 강제.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || !open) return;
    grid.columns.forEach(col => {
      col.allowSorting = false;
    });
    grid.invalidate();
  }, [open, staticColumns, itemsSource]);

  const handleFind = () => {
    if (!selectedYear) {
      void setAlert({ type: 'alert', content: t('MSG00019', 'Year 를 선택해주세요.') });
      return;
    }
    void refetch?.();
  };

  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const defaultYYYY = /^\d{4}$/.test(selectedYear) ? selectedYear : '';
    GridAction.addRow(grid, {
      VER_SEQ: '',
      YYYY: defaultYYYY,
      VERSION_NM: '',
      VALID_YN: 'Y',
      DESCRIPTION: '',
    } satisfies Partial<VersionRow>);
  };

  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid);
  };

  const handleSave = async () => {
    if (savingRef.current) return;
    savingRef.current = true;

    const grid = gridRef.current;
    if (!grid) {
      savingRef.current = false;
      return;
    }

    // dirty 검출 — itemsAdded/Edited/Removed + EditTracker 추적 row 의 합집합.
    grid.finishEditing();
    const items = grid.collectionView?.sourceCollection ?? [];
    const cv = grid.collectionView as CollectionView<VersionRow> | undefined;
    const trackedRows = Array.from(editTrackerRef.current?.getOriginalValues()?.keys() ?? []);
    const editedSet = new Set<VersionRow>([
      ...(cv?.itemsAdded?.slice() ?? []),
      ...(cv?.itemsEdited?.slice() ?? []),
      ...(cv?.itemsRemoved?.slice() ?? []),
      ...trackedRows,
    ] as VersionRow[]);
    editedSet.forEach(r => {
      if (!r.CRUD_TYPE || (r.CRUD_TYPE !== CRUD_TYPE.INSERT && r.CRUD_TYPE !== CRUD_TYPE.DELETE)) {
        r.CRUD_TYPE = CRUD_TYPE.MODIFY;
      }
    });
    const dirty = items.filter(r => r.CRUD_TYPE || editedSet.has(r));

    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG_NO_CHANGE', '수정한 내용이 없습니다.') });
      savingRef.current = false;
      return;
    }

    for (const r of dirty) {
      if (r.CRUD_TYPE === CRUD_TYPE.DELETE) continue;
      if (!r.YYYY || String(r.YYYY).length !== 4) {
        void setAlert({ type: 'alert', content: t('MSG_YEAR_4DIGIT', 'Year(YYYY) 는 4자리 숫자여야 합니다.') });
        savingRef.current = false;
        return;
      }
      if (!r.VERSION_NM || String(r.VERSION_NM).trim() === '') {
        void setAlert({ type: 'alert', content: t('MSG_VERSION_NM_REQUIRED', '버전명을 입력해주세요.') });
        savingRef.current = false;
        return;
      }
      if (r.VALID_YN !== 'Y' && r.VALID_YN !== 'N') {
        void setAlert({ type: 'alert', content: t('MSG_VALID_YN_INVALID', '유효여부는 Y 또는 N 이어야 합니다.') });
        savingRef.current = false;
        return;
      }
    }

    const ok = await setAlert({ type: 'confirm', content: t('MSG00004', '수정한 내용을 저장하시겠습니까?') });
    if (!ok) {
      savingRef.current = false;
      return;
    }

    const buf = {
      activeFlag: '',
      verSeq: '',
      yyyy: '',
      versionNm: '',
      description: '',
      validYn: '',
      createdBy: '',
    };
    dirty.forEach(r => {
      const flag = r.CRUD_TYPE === CRUD_TYPE.INSERT ? 'I' : r.CRUD_TYPE === CRUD_TYPE.MODIFY ? 'U' : 'D';
      buf.activeFlag += '^' + flag;
      buf.verSeq += '^' + String(r.VER_SEQ ?? '');
      buf.yyyy += '^' + String(r.YYYY ?? '');
      buf.versionNm += '^' + String(r.VERSION_NM ?? '');
      buf.description += '^' + String(r.DESCRIPTION ?? '');
      buf.validYn += '^' + String(r.VALID_YN ?? 'Y');
      buf.createdBy += '^' + sessionUserId;
    });

    const trim = (s: string) => (s.startsWith('^') ? s.substring(1) : s);

    try {
      await apiClient.post(`/${MODAL_VERSION}/version/SAVE/call-proc`, {
        activeFlag: trim(buf.activeFlag),
        verSeq: trim(buf.verSeq),
        yyyy: trim(buf.yyyy),
        versionNm: trim(buf.versionNm),
        description: trim(buf.description),
        validYn: trim(buf.validYn),
        createdBy: trim(buf.createdBy),
      });
      void setAlert({ type: 'alert', content: t('MSG_SAVE_DONE', '저장이 완료되었습니다.') });
      void queryClient.invalidateQueries({ queryKey: [MODAL_VERSION] });
      void refetch?.();
    } catch {
      void setAlert({ type: 'alert', content: t('MSG_SAVE_FAIL', '저장 중 오류가 발생했습니다.') });
    } finally {
      savingRef.current = false;
    }
  };

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00604', 'Contribution Version')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('BTN00001', '_Search')}
            onSearch={handleFind}
            conditions={
              <Grid size={4}>
                <FormItem
                  label={t('LBL00002', '_Year')}
                  labelAlign='right'
                  required
                  render={() => (
                    <select
                      value={selectedYear}
                      onChange={e => setSelectedYear(e.target.value)}
                      aria-label='year'
                    >
                      <option value=''>{t('LBL_SELECT', '_Select')}</option>
                      {yearOptions.map(o => {
                        const v = String(o.NAME2 ?? o.NAME ?? o.CODE ?? '').substring(0, 4);
                        return v ? (
                          <option key={String(o.CODE ?? v)} value={v}>
                            {v}
                          </option>
                        ) : null;
                      })}
                    </select>
                  )}
                />
              </Grid>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<VersionRow>
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              editTrackerRef={editTrackerRef}
              staticColumns={staticColumns}
              itemsSource={itemsSource}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('BTN00003', '_Insert')}
              onClick={handleInsert}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('BTN00004', '_Delete')}
              onClick={handleDelete}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('BTN00005', '_Close')}
              onClick={() => modalClose()}
            />
            <Button
              appearance='contained'
              buttonLabel={t('BTN00006', '_Save')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={() => void handleSave()}
            />
          </div>
        </div>
      }
    />
  );
};
