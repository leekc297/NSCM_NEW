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
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  DIVISION_40,
  DIVISION_LOOKUP,
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
  onSelect: (versionNo: string) => void;
}

// 버전 목록 컬럼 — AS-IS DMF0068_VersionPopup 이 코드로 직접 만든 8개 중 표시 5개
//   (Division / Seq / Date 는 AS-IS 에서도 숨김)
//   align 생략 = 좌측정렬(columnMapping alignMap 기본값 L)
const VERSION_COLUMNS: Array<{
  key: string;
  header: string;
  width: number;
  align?: 'L' | 'R' | 'C';
}> = [
  { key: 'VERSION_NO', header: 'Version', width: 220 },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 300 },
  { key: 'VERSION_TYPE', header: 'Type', width: 110 },
  { key: 'CREATED_BY', header: 'Create By', width: 110 },
  { key: 'CREATION_DATE', header: 'Create Date', width: 140, align: 'C' },
];

// Version 팝업 — AS-IS DMF0068_VersionPopup(389행) 1:1.
//   사업부는 40 고정으로 열리고 기간 기본값은 오늘 기준 -3개월 ~ +3개월이다
//   (VERSION_POPUP_MONTHS_BACK / _FWD).
//   한 건만 고를 수 있으며 두 건 이상이면 안내 후 막는다. 행 더블클릭은 바로 채택이다.
export const VersionPopupModal = ({ open, modalClose, onSelect }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<VersionPopupRow>>(undefined);

  const [sdt, setSdt] = useState('');
  const [edt, setEdt] = useState('');
  const [versionType, setVersionType] = useState<string>(VERSION_TYPE_DEFAULT);
  const [description, setDescription] = useState('');

  const [typeRows, divisionRows] = useTabComboQueries({
    filters: [VERSION_TYPE_LOOKUP, DIVISION_LOOKUP],
  });
  const typeOptions = useMemo(
    () =>
      ((typeRows ?? []) as unknown as Array<Record<string, string>>).map(r => ({
        label: String(r.NAME ?? r.CODE ?? ''),
        value: String(r.CODE ?? ''),
      })),
    [typeRows]
  );
  // Div 콤보 옵션 — 라벨은 룩업 NAME(AS-IS '40 Mobility & IT Battery').
  //   ⭐ 룩업이 아직 안 왔거나 40 이 없어도 콤보가 빈칸으로 보이면 안 되므로 40 옵션을 보장한다.
  //     (값은 항상 DIVISION_40 고정 — 이 화면은 사업부 선택 조회조건이 없다.)
  const divisionOptions = useMemo(() => {
    const rows = (divisionRows ?? []) as unknown as Array<Record<string, string>>;
    const found = rows.find(r => String(r.CODE ?? '') === DIVISION_40);
    return [{ label: found ? String(found.NAME ?? DIVISION_40) : DIVISION_40, value: DIVISION_40 }];
  }, [divisionRows]);

  useEffect(() => {
    if (!open) return;
    // AS-IS 와 동일하게 오늘 날짜 기준 ±개월. 월초/월말 스냅 없음(demand-manager.constants 주석 참조).
    setSdt(dayjs().subtract(VERSION_POPUP_MONTHS_BACK, 'month').format('YYYYMMDD'));
    setEdt(dayjs().add(VERSION_POPUP_MONTHS_FWD, 'month').format('YYYYMMDD'));
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
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.VERSION_POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION_POPUP,
    tabId: MENU_ID,
    filters,
    enabled: open && sdt !== '' && edt !== '' && versionType !== '',
  });
  const loading = isLoading || isFetching;
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
          horzAlgnCd: c.align,
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
      void setAlert({
        type: 'alert',
        content: t(MSG.VERSION_ONE_ONLY, '_버전은 1개만 선택해 주세요.'),
      });
      return;
    }
    const versionNo = String(row.VERSION_NO ?? '');
    if (!versionNo) return;
    // 조회조건 칸에는 VERSION_NO 만 넣는다. 설명을 붙여 두면 표시문과 조회키가 달라져
    //   편집을 시작하는 순간 코드로 되돌려야 하고, 사용자에게는 값이 바뀌는 것처럼 보인다.
    onSelect(versionNo);
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
      void setAlert({
        type: 'alert',
        content: t(MSG.VERSION_ONE_ONLY, '_버전은 1개만 선택해 주세요.'),
      });
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

  /**
   * 행 더블클릭 = OK 와 같은 채택. 그리드 래퍼의 onDoubleClick 으로 받는다.
   *
   * ⭐ hostElement.addEventListener 로 붙이지 않는 이유 —
   *   gridRef 는 Wijmo 의 initialized 콜백에서 채워지고(DataGrid.handleInitialized),
   *   CustomDialog 는 MuiDialog 에 keepMounted 를 주지 않아 팝업을 열 때마다 그리드가
   *   새로 마운트된다. 그래서 "effect 가 도는 시점에 ref 가 준비돼 있는가"에 등록 성공 여부가
   *   걸리고, 한 번 어긋나면 재시도할 계기가 없어 영구 미등록으로 남는다.
   *   래퍼의 React 이벤트로 받으면 등록은 항상 보장되고, ref 는 마운트 시점이 아니라
   *   **이벤트 발생 시점**에 읽으므로 타이밍 문제가 성립하지 않는다.
   *
   * 헤더/코너 더블클릭은 hitTest 로 걸러 데이터 셀에서만 채택한다.
   */
  const handleGridDoubleClick = (e: React.MouseEvent<HTMLDivElement>) => {
    const g = gridRef.current;
    if (!g) return;
    if (g.hitTest(e.nativeEvent).cellType !== CellType.Cell) return;
    adoptCurrentSelection();
  };

  // No. 코너 라벨 (hook #108)
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    g.formatItem.addHandler(formatHandler);
    return () => {
      try {
        g.formatItem.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
    // open/versionRows — 팝업 재오픈·재조회로 그리드가 새로 마운트되면 다시 붙인다.
  }, [open, versionRows]);

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
                {/* Div — 40 고정. 콤보로 보여주되 선택은 잠근다(화면 자체가 Division 40 전용). */}
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown value={DIVISION_40} options={divisionOptions} disabled />
                    )}
                  />
                </Grid>
                {/* Period — 공용 카탈로그 PeriodField(@master/searchFields), 타 화면과 동일 DateRange.
                    값은 종전과 같은 YYYYMMDD 8자리라 SP filters 는 그대로다. */}
                <PeriodField
                  gridSize={4}
                  label={t('LBL00013', 'Period')}
                  start={sdt}
                  end={edt}
                  onChange={(start, end) => {
                    setSdt(start);
                    setEdt(end);
                  }}
                />
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
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00608', 'Description')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={description}
                        onChange={e => setDescription(e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />

          {/* 더블클릭 채택 — 리스너 등록 타이밍에 의존하지 않도록 래퍼에서 받는다(위 주석 참조) */}
          <div className={styles.modalGridWrapper} onDoubleClick={handleGridDoubleClick}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <DataGrid<VersionPopupRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
              isReadOnly={true}
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
