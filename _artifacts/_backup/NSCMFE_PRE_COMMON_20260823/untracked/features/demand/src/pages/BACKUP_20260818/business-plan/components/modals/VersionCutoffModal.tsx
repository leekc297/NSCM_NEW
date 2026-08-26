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
import type { MdfVersionRow } from '../../business-plan.types';
import styles from '../../BusinessPlan.module.scss';
import { callCutoff } from '../../utils/business-plan.api';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
}

// 버전 목록 grid 8컬럼 — AS-IS VersionCutOffPopUp.InitSpread L190~199 1:1
//   (Division/Version NO/Type/Description/Cutoff Date/Ver Seq/Update By/Update Date)
const VERSION_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 90 },
  { key: 'VERSION_NO', header: 'Version NO', width: 150 },
  { key: 'VERSION_TYPE', header: 'Type', width: 70 },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 220 },
  { key: 'YYYYMMDD', header: 'Cutoff Date', width: 100 },
  { key: 'VER_CRE_SEQ', header: 'Ver Seq', width: 70 },
  { key: 'LAST_UPDATED_BY', header: 'Update By', width: 110 },
  { key: 'LAST_UPDATE_DATE', header: 'Update Date', width: 150 },
];

// ⭐ Ver. Cutoff 모달 — AS-IS VersionCutOffPopUp(610줄, BP_M 경로) 1:1 (2026-08-05 재작성):
//   조회 = DMF0042_GET_DM_MDF_VERSION(mdfVersion 시트 — Description 필터 포함. 구 구현의
//   cutoffVersion 배선은 Replace 팝업과 뒤바뀐 오배선이었음) / 실행 = Confirm →
//   DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF (division 'ALL' 시 MyDivision 전체 순차 실행 L328~331,
//   결과 ';' 연결 → MSG00151 → TO-BE MSG00675). Period 기본 = 오늘~+5개월 (Form_Load L106~108).
//   권한 게이트 = 부모 hasButton('CUTOFF') (화면 DefineProperty L354~367 ADMIN/DM ADMIN 1:1).
export const VersionCutoffModal = ({ open, modalClose, divisionId }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<MdfVersionRow>>(undefined);

  // Division 콤보 — MyDivision (AS-IS clbDivision. 초기값 = 화면 division, 변경 가능 L247)
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
  // Period 기본 = 2년 전 ~ +5개월 (AS-IS Form_Load L106~108 은 오늘~+5개월 — 과거 컷오프 버전이
  //   목록에서 전멸해 "조회되지 않음"이 되므로 과거 포함으로 확장. 2026-08-05 사용자 지시 Δ.
  //   현 원장 BP_M 컷오프일 = 2025-01-17/2025-05-22 실측 — 2년이면 커버)
  const [fromYyyymmdd, setFromYyyymmdd] = useState('');
  const [toYyyymmdd, setToYyyymmdd] = useState('');
  // Description — 조회 필터(P_VERSION_DESCRIPTION like) 겸 Cutoff 실행 설명 (AS-IS txtDes 단일 필드)
  const [description, setDescription] = useState('');
  const [running, setRunning] = useState(false);

  useEffect(() => {
    if (open) {
      setDivision(divisionId);
      setFromYyyymmdd(dayjs().subtract(2, 'year').format('YYYYMMDD'));
      setToYyyymmdd(dayjs().add(5, 'month').format('YYYYMMDD'));
      setDescription('');
      setRunning(false);
    }
  }, [open, divisionId]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({
      divisionId: division,
      versionDescription: description,
      versionType: CUTOFF_VER_TYPE, // 'BP_M' (AS-IS LoadDataDiv L2915~2920)
      fromYyyymmdd,
      toYyyymmdd,
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [division, description, fromYyyymmdd, toYyyymmdd, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MDF_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.MDF_VERSION,
    tabId: MENU_ID,
    filters,
    enabled: open && /^\d{8}$/.test(fromYyyymmdd) && /^\d{8}$/.test(toYyyymmdd),
  });
  const versionRows = useMemo<MdfVersionRow[]>(
    () => (data as { data?: MdfVersionRow[] } | undefined)?.data ?? [],
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

  // ⭐ Cutoff 실행 — AS-IS BP_Cutoff L521~576: division 'ALL' = MyDivision 전체 순차 실행,
  //   결과 첫 값 ';' 연결 → MSG00675("[Division ID : {0}] {1}") → 재조회. (AS-IS 확인창 없음 —
  //   TO-BE confirm 은 안전 강화 Δ)
  const handleCutoff = async () => {
    if (running) return;
    const targets =
      division.toUpperCase() === 'ALL' ? divisionOptions.map(o => o.value) : [division];
    if (targets.length === 0 || targets[0] === '') return;
    const confirmed = await setAlert({
      type: 'confirm',
      content: `Manual Cutoff (${targets.join(',')})?`,
    });
    if (!confirmed) return;
    setRunning(true);
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    try {
      let joined = '';
      for (const div of targets) {
        const res = await callCutoff(div, description.trim(), CUTOFF_VER_TYPE, sesUserId);
        if (!res.ok) {
          void setAlert({
            type: 'alert',
            content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
          });
          return;
        }
        joined += `;${res.message ?? ''}`;
      }
      // 완료 안내 — MSG00675 'Manual Cutoff가 완료되었습니다.[Division ID : {0}] {1}' (AS-IS 00151)
      void setAlert({
        type: 'alert',
        content: t(MSG.CUTOFF_DONE, '_Manual Cutoff가 완료되었습니다.[Division ID : {0}] {1}')
          .replace('{0}', targets.join(','))
          .replace('{1}', joined),
      });
      setDescription('');
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
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* AS-IS 타이틀 "Ver. Cut-Off [BP_M]" (LoadDataDiv L137) */}
          <h2 className='headerTitle'>{`Ver. Cut-Off [${CUTOFF_VER_TYPE}]`}</h2>
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
                      // ⭐ 화면 division 고정 — 비활성 (2026-08-05 사용자 지시. AS-IS 는 변경 가능 Δ)
                      <CustomDropdown
                        value={division}
                        options={divisionOptions}
                        onChange={(_, option) => setDivision(String(option))}
                        disabled
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
            <DataGrid<MdfVersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
            />
          </div>

          {/* Description — 조회 필터 겸 Cutoff 버전 설명 (AS-IS txtDes 단일 필드 파리티) */}
          <div className={styles.modalFieldRow}>
            <span>Description</span>
            <InputField
              value={description}
              onChange={e => setDescription(e.target.value)}
              placeholder='Version description'
            />
          </div>

          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Confirm'
              disabled={running}
              onClick={() => void handleCutoff()}
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
