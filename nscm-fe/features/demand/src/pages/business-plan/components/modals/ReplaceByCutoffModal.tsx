import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { CUTOFF_VER_TYPE, MENU_ID, MSG, SHEETS } from '../../business-plan.constants';
import type { CutoffVersionRow } from '../../business-plan.types';
import styles from '../../BusinessPlan.module.scss';
import { callReplaceByCutoff } from '../../utils/business-plan.api';

interface Props {
  open: boolean;
  // applied=true 시 부모가 메인 재조회 (컷오프본 대체 반영)
  modalClose: (applied: boolean) => void;
  divisionId: string;
  // 부모(BusinessPlan.tsx)가 산출한 선택 M_ 범위 (미선택 = 조회기간 전체 — AS-IS L3487~3539)
  range: { from: string; to: string }; // yyyymm
}

// 버전 목록 grid 8컬럼 — AS-IS ReplaceByCutOffPopUp.InitSpread L173~182 1:1
const VERSION_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 80 },
  { key: 'VERSION_NO', header: 'Version NO', width: 150 },
  { key: 'VERSION_TYPE', header: 'Type', width: 70 },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 260 },
  { key: 'YYYYMMDD', header: 'Cutoff Date', width: 100 },
  { key: 'VER_CRE_SEQ', header: 'Ver Seq', width: 70 },
  { key: 'LAST_UPDATED_BY', header: 'Update By', width: 110 },
  { key: 'LAST_UPDATE_DATE', header: 'Update Date', width: 150 },
];

// ⭐ Replace by Cutoff 모달 — AS-IS ReplaceByCutOffPopUp(562줄) 1:1 (2026-08-05 재작성):
//   조회 = DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION(cutoffVersion 시트 — BP_FCST_C 에 실적재된
//   컷오프 버전만. 구 구현의 mdfVersion 배선은 Cutoff 팝업과 뒤바뀐 오배선이었음) →
//   버전 선택 → MSG00400 confirm(기간·버전 바인딩 L474) → DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF
//   (yyyyMM 6자리 from/to = 팝업 Period 현재값 L469~470) → MSG00401({0}건 L511) → 재조회.
//   권한 게이트 = 부모 hasButton('REPLACE') (화면 btnReplace L3478~3484 ADMIN/DM ADMIN 1:1).
export const ReplaceByCutoffModal = ({ open, modalClose, divisionId, range }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<CutoffVersionRow>>(undefined);

  // Division 콤보 — MyDivision (AS-IS clbDivision. 초기값 = 화면 division L214)
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      return { value: code, label: code === name || name === '' ? code : `${code} (${name})` };
    });
  }, [myDivisions]);

  const [division, setDivision] = useState(divisionId);
  // Period = 부모 선택 M_ 범위 → from01 ~ to말일 (AS-IS LoadDataDiv L115~134 — 2월 28 단순화 대신 실말일)
  const [fromYyyymmdd, setFromYyyymmdd] = useState('');
  const [toYyyymmdd, setToYyyymmdd] = useState('');
  const [running, setRunning] = useState(false);
  const [appliedAny, setAppliedAny] = useState(false);

  useEffect(() => {
    if (open) {
      setDivision(divisionId);
      setFromYyyymmdd(`${range.from}01`);
      setToYyyymmdd(dayjs(`${range.to}01`).endOf('month').format('YYYYMMDD'));
      setRunning(false);
      setAppliedAny(false);
    }
  }, [open, divisionId, range]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({
      divisionId: division,
      // AS-IS FindData L239~240 — P_YYYYMM_FROM/TO 에 yyyymmdd 8자리 전달 (SP 내부 YYYYMM 문자비교 관용)
      yyyymmFrom: fromYyyymmdd,
      yyyymmTo: toYyyymmdd,
      versionType: CUTOFF_VER_TYPE, // 'BP_M' 고정 (L241)
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [division, fromYyyymmdd, toYyyymmdd, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.CUTOFF_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUTOFF_VERSION,
    tabId: MENU_ID,
    filters,
    enabled: open && /^\d{8}$/.test(fromYyyymmdd) && /^\d{8}$/.test(toYyyymmdd),
  });
  const versionRows = useMemo<CutoffVersionRow[]>(
    () => (data as { data?: CutoffVersionRow[] } | undefined)?.data ?? [],
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

  // No. 코너 헤더 (hook #108)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    g.formatItem.addHandler(formatHandler);
    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, versionRows]);

  // ⭐ Replace 실행 — AS-IS Replace_Cutoff L453~516. 선택 버전 필수(AS-IS 는 미클릭 시 첫 행 —
  //   TO-BE 선택 필수 = 안전 강화 Δ) → MSG00400 confirm → SP(yyyyMM 6자리) → MSG00401({0}건).
  const handleReplace = async () => {
    if (running) return;
    const sel = gridRef.current?.selectedItems[0] as CutoffVersionRow | undefined;
    const versionNo = sel ? String(sel.VERSION_NO ?? '') : '';
    if (!versionNo) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_COLUMN, '_필수 입력 컬럼이 없습니다.'),
      });
      return;
    }
    const from6 = fromYyyymmdd.slice(0, 6);
    const to6 = toYyyymmdd.slice(0, 6);
    // MSG00400 — {0}년{1}월 ~ {2}년{3}월 + {4}=버전 (AS-IS L474 바인딩 순서 1:1)
    const confirmed = await setAlert({
      type: 'confirm',
      content: t(
        MSG.REPLACE_CONFIRM,
        '_\'{0}년 {1}월 ~ {2}년 {3}월\' 기간의 Current 데이터를 Cutoff 버전 [{4}] 데이터로 대체하시겠습니까?'
      )
        .replace('{0}', from6.slice(0, 4))
        .replace('{1}', from6.slice(4, 6))
        .replace('{2}', to6.slice(0, 4))
        .replace('{3}', to6.slice(4, 6))
        .replace('{4}', versionNo),
    });
    if (!confirmed) return;
    setRunning(true);
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    try {
      const res = await callReplaceByCutoff({
        divisionId: division,
        versionType: CUTOFF_VER_TYPE,
        yyyymmFrom: from6,
        yyyymmTo: to6,
        versionNo,
        createdBy: sesUserId,
      });
      if (!res.ok) {
        void setAlert({
          type: 'alert',
          content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      // MSG00401 — {0}건 대체 완료 (AS-IS L511. SP 첫 값 = 건수)
      const count = Number(res.message ?? '');
      void setAlert({
        type: 'alert',
        content: t(MSG.REPLACE_DONE, '_{0}건의 데이터가 대체되었습니다.').replace(
          '{0}',
          Number.isFinite(count) ? count.toLocaleString() : (res.message ?? '')
        ),
      });
      setAppliedAny(true);
      void refetch?.();
    } finally {
      setRunning(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1000}
      handleClose={() => modalClose(appliedAny)}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* AS-IS 타이틀 "Ver. Cut-Off for Replacement [BP_M]" (LoadDataDiv L108) */}
          <h2 className='headerTitle'>{`Ver. Cut-Off for Replacement [${CUTOFF_VER_TYPE}]`}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={() => void refetch?.()}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        value={division}
                        options={divisionOptions}
                        onChange={(_, option) => setDivision(String(option))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={5}>
                  <FormItem
                    label={t('LBL00013', 'Period')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.modalFieldRow}>
                        <InputField
                          value={fromYyyymmdd}
                          onChange={e => setFromYyyymmdd(e.target.value)}
                          placeholder='YYYYMMDD'
                        />
                        <span>~</span>
                        <InputField
                          value={toYyyymmdd}
                          onChange={e => setToYyyymmdd(e.target.value)}
                          placeholder='YYYYMMDD'
                        />
                      </div>
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label='Type'
                    labelAlign='right'
                    render={() => <InputField value={CUTOFF_VER_TYPE} disabled />}
                  />
                </Grid>
              </>
            }
          />

          <div className={styles.modalGridWrapper}>
            <DataGrid<CutoffVersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
              selectionMode='Row'
            />
          </div>

          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Confirm'
              disabled={running}
              onClick={() => void handleReplace()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={() => modalClose(appliedAny)}
            />
          </div>
        </div>
      }
    />
  );
};
