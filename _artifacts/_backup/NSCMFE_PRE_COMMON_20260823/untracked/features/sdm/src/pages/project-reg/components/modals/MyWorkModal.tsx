import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';

import { MENU_ID, SHEETS } from '../../project-reg.constants';
import type { MyWorkRow, MyWorkTarget } from '../../project-reg.types';
import styles from '../../ProjectReg.module.scss';
import { useProjectRegStore } from '../../useProjectRegStore';
import { toDisplayDate } from '../../utils/project-reg.validate';

// ⭐ SDM1010 MY_WORK 모달 (TAB2 MY_WORK 셀 — 메타 FPModal/ATTRIBUTE1='MyWorkModal', 조회 전용).
//   신본 §14 GET_POP_MY_WORK — POP2_GRID5 SEARCH {divisionId(미적용 — 시그니처 충족 ''), dpjtKey}
//   17컬럼 그리드 (SHEET_COLUMNS 'POP2_GRID5' 메타 소비) + Close.
//   ⚠ SAMPLE_A~D_DATE = SP 하드코딩 placeholder (§14 — 정오표 기록). 서버 값 그대로 표시
//     (계약 결정 10 — 날짜 표시 규약 'YYYY.MM.DD' 만 적용).

interface Props {
  open: boolean;
  target: MyWorkTarget | null;
  modalClose: () => void;
}

export const MyWorkModal = ({ open, target, modalClose }: Props) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<MyWorkRow>>(undefined);
  const staticColumns = useProjectRegStore(s => s.staticColumns);
  const fetchStaticColumns = useProjectRegStore(s => s.fetchStaticColumns);

  const dpjtKey = target?.dpjtKey ?? '';

  useEffect(() => {
    if (!open) return;
    void fetchStaticColumns([SHEETS.POP2_GRID5]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // filters — useMemo 참조 안정화 (인라인 객체 금지). divisionId = §14 필터 주석 처리 — '' 전달
  const filters = useMemo(() => ({ divisionId: '', dpjtKey }), [dpjtKey]);
  const { data } = useTabProcQuery<MENU_ID, SHEETS.POP2_GRID5>({
    menuId: MENU_ID,
    sheetName: SHEETS.POP2_GRID5,
    tabId: `${MENU_ID}_POP2`,
    filters,
    enabled: open && dpjtKey !== '',
    queryOptions: { staleTime: 0 },
  });
  const rows = useMemo<MyWorkRow[]>(() => data?.data ?? [], [data]);

  // ⭐ DATE 원형(ISO 직렬화) 커서 컬럼(SOP_DATE/SAMPLE_*) — 'YYYY.MM.DD' 표시 (계약 결정 8.
  //   메타 FPDate* 판정 — 하드코딩 컬럼 목록 금지)
  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(
    (staticColumns[SHEETS.POP2_GRID5] ?? []).map(c => [c.colNm, c])
  );
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !open) return;
    const formatHandler = (_s: FlexGridType<MyWorkRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      const rowItem = g.rows[e.row]?.dataItem as MyWorkRow | undefined;
      if (!rowItem || !meta) return;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      if (ctrlType.startsWith('FPDate')) {
        const text = toDisplayDate(rowItem[binding]);
        if (e.cell.textContent !== text) e.cell.textContent = text;
      }
    };
    g.formatItem.addHandler(formatHandler);
    g.invalidate(true);
    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, rows, staticColumns[SHEETS.POP2_GRID5]]);

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      height='60vh'
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          {/* 모달 타이틀 LBL 미등재 — 영문 리터럴 (신규 채번 금지 관행) */}
          <h2 className='headerTitle'>My Work</h2>
        </div>
      }
      customContentArea={
        <div className={styles.myWorkWrapper}>
          <div className={styles.modalGridWrapper}>
            <DataGrid<MyWorkRow>
              gridRef={gridRef}
              itemsSource={rows}
              staticColumns={staticColumns[SHEETS.POP2_GRID5] ?? []}
              autoGenerateColumns={false}
              allowSorting={false}
              isReadOnly={true}
            />
          </div>
          {/* 자체 footer (P9) — Close = LBL00627 */}
          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
