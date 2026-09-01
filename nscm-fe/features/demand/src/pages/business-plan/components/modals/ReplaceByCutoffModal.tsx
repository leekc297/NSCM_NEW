import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { CUTOFF_VER_TYPE, MENU_ID, MSG, SHEETS } from '../../business-plan.constants';
import type { MdfVersionRow } from '../../business-plan.types';
import styles from '../../BusinessPlan.module.scss';
import { callReplaceByCutoff } from '../../utils/business-plan.api';

import { useReplaceByCutoffModalStore } from './replaceByCutoffModalStore';

// ⭐ 조회 파라미터는 yyyymm(6) 계약 유지 — 화면 입력만 달력(PeriodField, yyyymmdd 8)으로 통일하고
//   여기서 왕복 변환한다. from=1일 / to=말일로 펼친다.
const toYmd = (yyyymm: string, edge: 'start' | 'end'): string => {
  if (!/^\d{6}$/.test(yyyymm)) return '';
  const d = dayjs(`${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`);
  return (edge === 'start' ? d : d.endOf('month')).format('YYYYMMDD');
};
const toYm = (yyyymmdd: string): string => (/^\d{8}$/.test(yyyymmdd) ? yyyymmdd.slice(0, 6) : '');

interface Props {
  open: boolean;
  // applied=true 시 부모가 메인 재조회 (컷오프본 대체 반영)
  modalClose: (applied: boolean) => void;
  divisionId: string;
  // 부모(BusinessPlan.tsx)가 산출한 선택 M_ 범위 (미선택 = 조회기간 전체 — AS-IS L3422~3450)
  // ⭐ optional — 미전달 시 빈값 fallback. range 를 안 넘기는 구버전 호출부에서의 런타임 크래시 방지
  //   (`range.from` of undefined). VersionCutoffModal 과 동일 조치.
  range?: { from: string; to: string }; // yyyymm
}

// 버전 목록 grid 컬럼 = AS-IS ReplaceByCutOffPopUp InitSpread L173~182 8종 1:1
//   (Division / Version NO / Type / Description / Cutoff Date / Ver Seq / Update By / Update Date).
//   원천은 DMF0042_GET_DM_MDF_VERSION 커서 — Ver. Cutoff · Replace 두 팝업이 같은 커서를 공유한다.
//   금지: Description 을 Type 앞에 두기 / Created By·Creation Date 를 표시 컬럼으로 쓰기
//   (AS-IS 는 SELECT 에만 있고 그리드에는 Update By/Date 를 쓴다 — 2026-08-25 리뷰).
const VERSION_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 90, align: 'L' as const },
  { key: 'VERSION_NO', header: 'Version No', width: 150, align: 'L' as const },
  { key: 'VERSION_TYPE', header: 'Type', width: 70, align: 'C' as const },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 260, align: 'L' as const },
  { key: 'YYYYMMDD', header: 'Cutoff Date', width: 100, align: 'C' as const },
  { key: 'VER_CRE_SEQ', header: 'Ver Seq', width: 70, align: 'R' as const },
  { key: 'LAST_UPDATED_BY', header: 'Update By', width: 120, align: 'L' as const },
  { key: 'LAST_UPDATE_DATE', header: 'Update Date', width: 160, align: 'C' as const },
];

// ⭐ Replace by Cutoff 모달 — AS-IS ReplaceByCutOffPopUp(562줄) 1:1: 버전 목록 조회
//   (DMF0042_GET_DM_MDF_VERSION, versionType='BP_M') → 버전 선택 → 기간(from/to) 확인 → Replace 실행
//   (DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF — createdBy BE주입). 권한 게이트 = 부모 hasButton('REPLACE').
export const ReplaceByCutoffModal = ({ open, modalClose, divisionId, range }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<MdfVersionRow>>(undefined);

  // ⭐ range 미전달 방어 + dep 를 문자열로 (매 렌더 새 객체 → 재설정 루프 차단)
  const rangeFrom = range?.from ?? '';
  const rangeTo = range?.to ?? '';

  const { yyyymmFrom, yyyymmTo } = useReplaceByCutoffModalStore(state => state.range);
  const setRange = useReplaceByCutoffModalStore(state => state.setRange);
  const [running, setRunning] = useState(false);
  const [appliedAny, setAppliedAny] = useState(false);

  useEffect(() => {
    if (open) {
      setRange({ yyyymmFrom: rangeFrom, yyyymmTo: rangeTo });
      setRunning(false);
      setAppliedAny(false);
    }
  }, [open, rangeFrom, rangeTo, setRange]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({
      divisionId,
      versionDescription: '',
      versionType: CUTOFF_VER_TYPE, // 'BP_M' 고정 (AS-IS LoadDataDiv L3465)
      fromYyyymmdd: `${yyyymmFrom}01`,
      toYyyymmdd: `${yyyymmTo}31`,
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, yyyymmFrom, yyyymmTo, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MDF_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.MDF_VERSION,
    tabId: MENU_ID,
    filters,
    enabled: open,
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
          horzAlgnCd: c.align,
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

  // ⭐ Replace 실행 — 선택 버전 필수 + confirm → SP 호출 (결과 passthrough)
  const handleReplace = async () => {
    if (running) return;
    const sel = gridRef.current?.selectedItems[0] as MdfVersionRow | undefined;
    const versionNo = sel ? String(sel.VERSION_NO ?? '') : '';
    if (!versionNo) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_COLUMN, '_필수 입력 컬럼이 없습니다.'),
      });
      return;
    }
    const confirmed = await setAlert({
      type: 'confirm',
      content: `Replace by Cutoff (${divisionId} / ${versionNo} / ${yyyymmFrom}~${yyyymmTo})?`,
    });
    if (!confirmed) return;
    setRunning(true);
    // Loading 토스트는 제거 — duration 3초 고정이라 실제 소요시간과 어긋난다. 진행 표시는 스피너가 맡는다
    //   (VersionCutoffModal 과 동일 조치).
    try {
      const res = await callReplaceByCutoff({
        divisionId,
        versionType: CUTOFF_VER_TYPE,
        yyyymmFrom,
        yyyymmTo,
        versionNo,
        auditUserId: sesUserId,
      });
      if (!res.ok) {
        void setAlert({
          type: 'alert',
          content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      setAppliedAny(true);
      // 처리 건수가 오면 함께 알린다 (AS-IS L511 "{0}건" 계보 — 실측 커서 data:[{CNT:79030}]).
      const done = t(MSG.SAVED, '_성공적으로 저장되었습니다.');
      await setAlert({
        type: 'alert',
        content:
          res.message ||
          (res.count !== undefined ? `${done} (${res.count.toLocaleString()}건)` : done),
      });
      modalClose(true);
    } finally {
      setRunning(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={() => modalClose(appliedAny)}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Replace by Cutoff</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          {/* ⭐ 실행 스피너 — Replace SP 는 대량건(실측 79,030건) 처리라 수 초~수십 초 걸린다.
              모달 전체를 덮는 스피너로 진행 중임을 알린다 (VersionCutoffModal 과 동일 패턴). */}
          <ProgressIndicator
            shape='circular'
            apprearance='infinite'
            open={running}
            placement='parent'
          />
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={() => void refetch?.()}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => <InputField value={divisionId} disabled />}
                  />
                </Grid>
                <PeriodField
                  gridSize={8}
                  start={toYmd(yyyymmFrom, 'start')}
                  end={toYmd(yyyymmTo, 'end')}
                  onChange={(start, end) =>
                    setRange({ yyyymmFrom: toYm(start), yyyymmTo: toYm(end) })
                  }
                />
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
              selectionMode='Row'
            />
          </div>

          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Replace'
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
