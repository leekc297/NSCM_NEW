import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import { MENU_ID, SHEETS } from '../../mkt-fcst-01.constants';
import styles from '../../MktFcst01.module.scss';
import { useMktFcst01Store } from '../../useMktFcst01Store';
import {
  normalizePrdnCtry,
  PRDN_CTRY_NA,
  PRDN_CTRY_OPT_NA,
  toCellStr,
} from '../../utils/mkt-fcst-01.cell';

// Prod. Country 선택 팝업 (설계서 popup-3, 요건 2).
//   Suffix Gr. 별 Cell · Pack · Link Site(모델 코드 14 · 15 · 16 자리 생산국)를 보여 주고, 체크한 Suffix Gr. 를
//   번호순 · 쉼표로 이어 셀에 넣는다. 머리글 체크 = 99 를 뺀 모두 선택. Skip = 99(N/A) 단독(Option 은 호출부가 N/A 로 맞춘다).
//   조회: prdnCtry / SEARCH → PKG_DMF0003_01.P_DMF0003_01_GET_PRDN_CTRY_POPUP (사업부 · 사용자).
//   99 와 다른 번호를 함께 고르면 저장 프로시저가 막는다(설계서 메시지 · 검증) — 팝업은 그대로 넘긴다.
//   N/A 상수와 값 정리 규칙은 셀 직접 입력과 같이 쓰도록 utils/mkt-fcst-01.cell 에 둔다.
export { PRDN_CTRY_NA, PRDN_CTRY_OPT_NA };

type PrdnCtryRow = ResponseData<MENU_ID, SHEETS.PRDN_CTRY>;

interface PrdnCtryModalProps {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  // 셀에 이미 있는 값(쉼표 구분) — 열 때 그 번호를 체크해 둔다.
  value: string;
  onConfirm: (result: { prdnCtry: string; skip: boolean }) => void;
}

export const PrdnCtryModal = ({ open, modalClose, divisionId, value, onConfirm }: PrdnCtryModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<PrdnCtryRow>>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const staticColumns = useMktFcst01Store(state => state.staticColumns[SHEETS.PRDN_CTRY]);
  const fetchPopupColumns = useMktFcst01Store(state => state.fetchPopupColumns);

  useEffect(() => {
    if (open) void fetchPopupColumns(SHEETS.PRDN_CTRY, divisionId);
  }, [open, divisionId, fetchPopupColumns]);

  const filters = useMemo(() => ({ divisionId }), [divisionId]);
  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.PRDN_CTRY>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRDN_CTRY,
    tabId: 'PrdnCtryModal',
    filters: filters as never,
    enabled: open && !!divisionId,
  });
  const itemsSource = useMemo(() => data?.o_rc1 ?? [], [data]);

  // 열 때 셀 값의 번호를 체크해 둔다. 같은 Suffix Gr. 가 두 행이면 둘 다 체크된다.
  useEffect(() => {
    const g = gridRef.current;
    if (!open || !g) return;
    const current = new Set(value.split(',').map(v => v.trim()).filter(Boolean));
    for (const row of g.rows) {
      const item = row.dataItem as PrdnCtryRow | undefined;
      row.isSelected = !!item && current.has(toCellStr(item.SUFFIX_GR).trim());
    }
    g.invalidate();
  }, [open, value, itemsSource]);

  // 마지막 칸(Link Site)이 남는 폭을 채워 오른쪽 빈 영역을 없앤다(사용자 요청 2026-11-12).
  //   칸 폭은 메타(COLUMN_WIDTH) 그대로 두고 마지막 칸만 Wijmo star('*')로 바꾼다 — 팝업 크기를 바꾸거나
  //   세로 스크롤바가 생겨도 따라간다. 공용 DataGrid 는 건드리지 않는다(GroupUserMainGrid 와 같은 방식).
  //   updatedLayout 마다 다시 건다(컬럼 재구성 때 메타 폭으로 돌아간다). 이미 '*' 면 건너뛴다(재설정 루프 방지).
  //   itemsSource 를 deps 에 둔 이유: 팝업을 처음 열 때는 그리드가 아직 없어 조회가 끝난 뒤 다시 걸어야 한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!open || !g) return;
    const fillLast = (grid: FlexGrid) => {
      const cols = grid.columns;
      const last = cols.length > 0 ? cols[cols.length - 1] : undefined;
      if (last && last.width !== '*') last.width = '*';
    };
    g.updatedLayout.addHandler(fillLast);
    fillLast(g);
    return () => g.updatedLayout.removeHandler(fillLast);
  }, [open, staticColumns, itemsSource]);

  // 머리글 체크 = 99(N/A)를 뺀 나머지 모두 선택(사용자 요청 2026-11-12). 99 는 다른 번호와 함께 고를 수 없는 값이다.
  //   체크박스를 그리는 wijmo Selector 는 공용 DataGrid 안에서 만들어져 화면이 손댈 수 없으므로, 클릭을 따로 듣는다.
  //   - Selector 는 그리드 host 의 캡처 단계에서 전 행을 체크/해제한다. 그보다 먼저 도는 document 캡처에서
  //     머리글 체크박스 클릭인지와 "99 밖의 행이 이미 모두 체크였는가"를 잡아 두고, document 버블 단계에서 결과를 다시 맞춘다.
  //   - 이미 모두 체크였으면 전체 해제, 아니면 99 밖의 행만 체크하고 99 는 푼다. 99 행은 직접 눌러서만 체크된다.
  //   99 행은 위치가 아니라 Suffix Gr. 값으로 찾는다.
  //   필수: 그리드는 클릭 시점에 gridRef 에서 꺼낸다. 팝업이 열리는 순간에는 그리드가 아직 없어, effect 안에서
  //     미리 잡으면 리스너가 아예 걸리지 않는다(2026-11-12 실제로 그렇게 동작하지 않았다).
  useEffect(() => {
    if (!open) return;

    const isNaRow = (item: PrdnCtryRow | undefined) => toCellStr(item?.SUFFIX_GR).trim() === PRDN_CTRY_NA;
    // 머리글 체크박스 = 그리드 안 체크박스 중 데이터 행(행 머리글 · 셀)에 속하지 않는 것.
    const isHeaderCheckbox = (g: FlexGrid<PrdnCtryRow>, target: EventTarget | null): boolean => {
      if (!(target instanceof HTMLInputElement) || target.type !== 'checkbox') return false;
      if (!g.hostElement?.contains(target)) return false;
      const cellType = g.hitTest(target).cellType;
      return cellType === CellType.TopLeft || cellType === CellType.ColumnHeader;
    };

    // null = 이번 클릭은 머리글 체크박스가 아니다.
    let allPickedBefore: boolean | null = null;
    const capture = (e: MouseEvent) => {
      allPickedBefore = null;
      const g = gridRef.current;
      if (!g || !isHeaderCheckbox(g, e.target)) return;
      const others = g.rows.filter(row => !isNaRow(row.dataItem as PrdnCtryRow | undefined));
      allPickedBefore = others.length > 0 && others.every(row => row.isSelected);
    };
    const adjust = () => {
      const g = gridRef.current;
      if (!g || allPickedBefore === null) return;
      const clearAll = allPickedBefore;
      allPickedBefore = null;
      for (const row of g.rows) {
        row.isSelected = !clearAll && !isNaRow(row.dataItem as PrdnCtryRow | undefined);
      }
      g.invalidate();
    };
    document.addEventListener('click', capture, true);
    document.addEventListener('click', adjust);
    return () => {
      document.removeEventListener('click', capture, true);
      document.removeEventListener('click', adjust);
    };
  }, [open]);

  const handleOk = () => {
    const g = gridRef.current;
    if (!g) return;
    const picked: string[] = [];
    for (const row of g.rows) {
      const item = row.dataItem as PrdnCtryRow | undefined;
      if (row.isSelected && item) picked.push(toCellStr(item.SUFFIX_GR));
    }
    // 하나도 고르지 않으면 셀을 비운다(설계서 popup-3 확인 버튼).
    onConfirm({ prdnCtry: normalizePrdnCtry(picked.join(',')), skip: false });
    modalClose();
  };

  const handleSkip = () => {
    onConfirm({ prdnCtry: PRDN_CTRY_NA, skip: true });
    modalClose();
  };

  return (
    <CustomDialog
      // 프리셋 밖 폭 360(화면 540px) — 체크 칸 50 + 메타 칸 폭 합 410 + 좌우 여백 + 세로 스크롤바 자리에 맞춘 값이다
      //   (사용자 요청 2026-11-12: Link Site 오른쪽 남는 폭 없애기). 몇 px 남는 폭은 마지막 칸이 채운다.
      //   minWidth 를 같은 값으로 둬 첫 드래그 때 기본 최소 폭(800)으로 튀지 않게 한다.
      size={360}
      minWidth={360}
      // 높이 350(화면 525px) — 15줄 정도 보이고 그 이상은 그리드 안에서 스크롤한다(사용자 요청 2026-11-12).
      //   제목 · 건수 줄 약 96 + 머리글 48 + 15줄 × 20 + 버튼 줄 · 여백 약 71 을 더한 값(캡처 비율 추정)이다.
      height={350}
      type='modal'
      position='basic'
      open={open}
      handleClose={modalClose}
      // 컬럼 필터 팝업이 MuiDialog-container 밖에 붙어 FocusTrap 과 충돌한다(SspSyncCompareModal 과 같은 이유).
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL01278', 'Prod. Country')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.prdnCtryGridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={isLoading || isFetching}
              placement='parent'
            />
            <ResultArea title='' count={itemsSource.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<PrdnCtryRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                useCheckbox
                // 체크박스(머리글 = 99 를 뺀 모두 선택)는 rowHeader 의 Selector 가 그린다 — rowHeader 를 남긴다.
                headersVisibility={HeadersVisibility.All}
                staticColumns={staticColumns}
                itemsSource={itemsSource}
              />
            </ResultArea>
          </div>
          <div className={styles.modalButtonWrapper}>
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Close' onClick={modalClose} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Skip' onClick={handleSkip} />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
          </div>
        </div>
      }
    />
  );
};
