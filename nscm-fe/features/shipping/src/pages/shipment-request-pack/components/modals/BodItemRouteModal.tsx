/**
 * SSP0026 Cell Biz TR_MODE 셀 BOD Item 선택 팝업 — DMF0045 BodItemRouteModal 패턴 이식.
 *   사용자 결정(2026-11-04): SSP0026 Cell Biz 를 DMF0045 와 동일하게 TR_MODE 팝업으로 전환한다.
 *   AS-IS SSP0026 은 TR_MODE 콤보 + FindData_BOD_Main(콤보 변경 시 BOD_ID 자동세팅)였으나, 두 화면
 *   Cell Biz UX 통일을 위해 팝업 방식을 채택했다(AS-IS 콤보 방식에서 의도적 전환).
 *
 * 백엔드 = SCP0030 BOD 팝업(배포됨) — DMF0045 BodItemRouteModal 과 동일 선택. /SCP0030/bodPopup/SEARCH
 *   /call-proc → P_SCP0030_GET_BOD_POPUP(IN = divisionId/itemId). SSP0026 자체 BOD 라우트목록 SP 가
 *   없어(GET_BOD_ITEM 은 From/To/Item 로 BOD_ID 를 역조회하는 단건용) 배포된 SCP0030 백엔드를 재사용한다.
 * 트리거 = 신규행(CRUD_TYPE='I') TR_MODE 셀 더블클릭(전제 MODEL_ID — 없으면 페이지가 선차단).
 * 선택 → From/To/Incoterms/TrMode/BOD_ID 5칸 세팅(END_CUSTOMER/Team 은 SCP0030 미반환이라 공란).
 *
 * 주의: 공용 features/master 팝업 카탈로그에 이 SP 의 1:1 대응이 없고, Hard Boundary(convert-core §2.2)상
 *   타 feature 컴포넌트를 쓸 수 없어 화면 폴더에 로컬 구성한다(자매 shipment-request-semi 선례).
 * 주의: SCP0030/bodPopup 은 admin 컬럼메타가 DB 에 없어(SCP0030 FE 도 하드코딩) POPUP_COLUMNS 를
 *   SCP0030 GetBodItemModal 과 동일하게 하드코딩한다(이 팝업 한정 예외 — DMF0045 동일).
 */
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { buildNoColumn, GridUtils, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { BOD_POPUP_TITLE_KEY, LBL, MSG_NO_ROWS_SELECTED } from '../../shipment-request-pack.constants';

import styles from './BodItemRouteModal.module.scss';

// SCP0030 BOD 팝업 백엔드 재사용(DMF0045 동일) — SSP0026 자체 라우트목록 SP 부재.
const BOD_SRC_MENU = 'SCP0030';
const BOD_SHEET = 'bodPopup';

// 팝업 확정 반환 DTO — 호출 화면은 이 c_* 계약만 알면 되고 SCP0030 SP 컬럼 변화에 끌려가지 않는다.
export interface BodItemReturn {
  c_FROM_SITE: string;
  c_TO_SITE: string;
  c_INCOTERMS: string;
  c_TRANSPORT_MODE: string;
  c_BOD_ID: string;
}
type BodPopupRow = Record<string, string | number | undefined>;

// SCP0030 GetBodItemModal 과 동일 컬럼셋(SCM0002_GetBODItemPopup / supply BOD) — 반환 커서(o_rc1)와 1:1.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'FROM_SITE_NAME', colLblNm: 'From Site', colWth: 150, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'TO_SITE_NAME', colLblNm: 'To Site', colWth: 150, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 130, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'PRIORITY', colLblNm: 'Priority', colWth: 70, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 90, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'BOD_ITEM_VALID', colLblNm: 'BOD Item Valid', colWth: 90, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_MON', colLblNm: 'Mon', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_TUE', colLblNm: 'Tue', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_WED', colLblNm: 'Wed', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_THU', colLblNm: 'Thu', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_FRI', colLblNm: 'Fri', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_SAT', colLblNm: 'Sat', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'DAYS_SUN', colLblNm: 'Sun', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'LEAD_TIME', colLblNm: 'L/T(Day)', colWth: 80, horzAlgnCd: 'R', visible: true, display: true },
  { colNm: 'FROM_YYYYMMDD', colLblNm: 'From', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'TO_YYYYMMDD', colLblNm: 'To', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
];

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행(다건) 전달 — 부모가 c_* 반환을 현재 행 5칸에 매핑한다.
  setSelectedValue: (rows: BodItemReturn[]) => void;
  // SCP0030 BOD 팝업 파라미터 — divisionId + itemId(전제 MODEL_ID).
  preSearchParams: {
    divisionId: string;
    itemId: string;
  };
}

export const BodItemRouteModal = ({ open, modalClose, setSelectedValue, preSearchParams }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [filters, setFilters] = useState<Record<string, string> | undefined>(undefined);

  useEffect(() => {
    if (!open) return;
    // SCP0030 SP(P_SCP0030_GET_BOD_POPUP) IN = divisionId/itemId. planGroup 은 SP 미사용이나 SCP0030 FE
    //   와 동형으로 함께 보낸다(빈값).
    setFilters({
      divisionId: preSearchParams.divisionId,
      itemId: preSearchParams.itemId,
      planGroup: '',
    });
    // 열릴 때만 초기화 — 열려 있는 동안 상위 값 변화로 입력을 덮지 않는다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const { data, isLoading, isFetching } = useTabProcQuery({
    // 조회를 /SCP0030/bodPopup/SEARCH/call-proc 로 보낸다(배포된 SCP0030 BOD 팝업 재사용).
    menuId: BOD_SRC_MENU as never,
    sheetName: BOD_SHEET as never,
    tabId: `${BOD_SRC_MENU}_SSP0026_BodItemRouteModal`,
    filters: filters as never,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  // SCP0030 GetBodItemModal 동일 — From/To(YYYYMMDD)는 date-only 정규화.
  const rows = useMemo(
    () =>
      withRowNo(
        ((data as { o_rc1?: BodPopupRow[] })?.o_rc1 ?? []).map(row => {
          const r = row as { FROM_YYYYMMDD?: string; TO_YYYYMMDD?: string };
          return {
            ...row,
            FROM_YYYYMMDD: String(r.FROM_YYYYMMDD ?? '').slice(0, 10),
            TO_YYYYMMDD: String(r.TO_YYYYMMDD ?? '').slice(0, 10),
          };
        })
      ),
    [data]
  );
  const staticColumns = useMemo(() => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS], [t]);

  // SCP0030 BOD 팝업 반환 컬럼 → c_* 매핑. SCP0030(supply)은 사이트 '명'(FROM_SITE_NAME/TO_SITE_NAME)을
  //   주고 END_CUSTOMER/Team 은 반환하지 않는다(DMF0045 와 동일 — 그 2칸은 호출부가 보존).
  const toSelection = (row: BodPopupRow): BodItemReturn => {
    const r = row as Record<string, string | undefined>;
    return {
      c_FROM_SITE: r.FROM_SITE_NAME ?? '',
      c_TO_SITE: r.TO_SITE_NAME ?? '',
      c_INCOTERMS: r.INCOTERMS ?? '',
      c_TRANSPORT_MODE: r.TRANSPORT_MODE ?? '',
      c_BOD_ID: r.BOD_ID ?? '',
    };
  };

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as BodPopupRow[];
    if (selections.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG_NO_ROWS_SELECTED, '_No rows selected.') });
      return;
    }
    setSelectedValue(selections.map(toSelection));
    modalClose();
  };

  // 더블클릭 = 그 행 하나로 확정(단건 빠른 경로).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as BodPopupRow | undefined;
    if (!dataItem) return;
    setSelectedValue([toSelection(dataItem)]);
    modalClose();
  };

  return (
    <CustomDialog
      size={750}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(BOD_POPUP_TITLE_KEY, '_BOD Item Master')}</h2>
        </div>
      }
      customContentArea={
        // SCP0030 GetBodItemModal 과 동일 레이아웃 — 검색영역 없이 그리드만(division/item 은 열 때 자동조회).
        <div className={styles.dialogContentWrapper}>
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                useCheckbox
                staticColumns={staticColumns}
                itemsSource={rows as unknown as WijmoRowItem[]}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t(LBL.OK, '_OK')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
