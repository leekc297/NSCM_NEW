import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef } from 'react';
import { useTranslation } from 'react-i18next';

import dayjs from '@foundation/dayjs';
import { GridUtils } from '@foundation/utils';
import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { useTabid } from '@shared/stores';

import { DataGrid } from '../../../../lib/grid';
import { MENU_ID, SHEETS } from '../../project-registration.constants';
import type { MyWorkScheduleRow } from '../../project-registration.types';

import styles from './MyWorkPopup.module.scss';
import { useMyWorkPopupStore } from './useMyWorkPopupStore';

interface MyWorkPopupProps {
  open: boolean;
  pjtKey: string;
  pjtCode: string;
  divisionId: string;
  sesUserId: string;
  onClose: () => void;
}

const DATE_BINDINGS = new Set([
  'SAMPLE_A_DATE',
  'SAMPLE_B_DATE',
  'SAMPLE_C_DATE',
  'SAMPLE_D_DATE',
  'SOP_DATE',
]);

// 컴포넌트 밖 순수 핸들러 — 참조 고정 (매 렌더 새 함수면 그리드 element memo 가 무력화된다)
const formatScheduleDates = (grid: FlexGrid<MyWorkScheduleRow>, event: FormatItemEventArgs) => {
  if (event.panel.cellType !== CellType.Cell) return;

  const binding = grid.columns[event.col]?.binding;
  if (!binding || !DATE_BINDINGS.has(binding)) return;

  const value = GridUtils.getRow(grid, event.row)?.[binding];
  if (value == null || value === '' || typeof value === 'boolean') {
    event.cell.textContent = value == null ? '' : String(value);
    return;
  }

  const parsed = dayjs(value);
  event.cell.textContent = parsed.isValid() ? parsed.format('YYYY-MM-DD') : String(value);
};

// My Work 팝업 — 화면설계서 "My Work 팝업" 시트. 조회 전용(저장/삭제 <해당없음>).
// ⚠ 설계서 §확인사항 "2.1. 상세 내역은 추가 예정" — 샘플 일정 그리드(My Work_GRID 시트에 실제
// 명시된 유일한 표)만 구현한다. 그 아래 있던 상태/요청 리스트는 권한관리 팝업 요청 리스트와
// 컬럼이 완전히 동일해 설계서 복사 잔재로 보이며, 별도 정의가 나오기 전까지는 만들지 않는다.
export const MyWorkPopup = ({
  open,
  pjtKey,
  pjtCode,
  divisionId,
  sesUserId,
  onClose,
}: MyWorkPopupProps) => {
  const { t } = useTranslation();
  const tabId = useTabid();

  const initialized = useMyWorkPopupStore(state => state.initialized);
  const staticColumns = useMyWorkPopupStore(state => state.staticColumns);
  const fetchStaticColumns = useMyWorkPopupStore(state => state.fetchStaticColumns);

  const gridRef = useRef<FlexGrid<MyWorkScheduleRow>>();

  // 매 렌더 새 리터럴을 넘기면 useTabProcQuery 의 참조비교가 매번 "필터 변경"으로 오판해
  // 무한 재검증된다 — pjtCode 가 실제로 바뀔 때만 새 객체를 만든다.
  // 요청 4: P_SES_USER_ID는 세션값임을 필터 키에서도 sesUserId로 구분한다.
  const pjtFilters = useMemo(
    () => ({ divisionId, pjtKey, sesUserId }),
    [divisionId, pjtKey, sesUserId]
  );
  const { data } = useTabProcQuery<MENU_ID, SHEETS.POPUP_MY_WORK>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP_MY_WORK,
    tabId,
    filters: pjtFilters,
    enabled: open && !!pjtKey,
  });

  useEffect(() => {
    if (!open) return;
    if (!initialized) void fetchStaticColumns();
  }, [open, initialized, fetchStaticColumns]);

  // 참조 고정 — 매 렌더 새 배열이면 DataGrid 가 컬렉션을 리로드해 깜빡인다 (datagrid-rerender-flicker)
  const rows = useMemo<MyWorkScheduleRow[]>(
    () => (data?.scheduleList as unknown as MyWorkScheduleRow[] | undefined) ?? [],
    [data]
  );

  return (
    <CustomDialog
      open={open}
      size={1000}
      type='modaless'
      position='basic'
      handleClose={onClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00862', '_My Work')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.projectInfo}>
            <span>{t('LBL00873', '_D-PJT Code')}</span>
            <strong>{pjtCode}</strong>
          </div>
          <div className={styles.gridWrapper}>
            {/* DataGrid(memo) — rows useMemo + formatItem 모듈 함수로 참조 고정 전제 */}
            <DataGrid<MyWorkScheduleRow>
              gridRef={gridRef}
              itemsSource={rows}
              staticColumns={staticColumns}
              isReadOnly
              formatItem={formatScheduleDates}
            />
          </div>
          {/* 조회 전용 팝업 — OK 는 닫기만 한다 (닫기는 우측 상단 X 로도 가능). */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
