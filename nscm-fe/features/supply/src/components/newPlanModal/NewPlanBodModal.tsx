import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { buildNoColumn, GridUtils, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import type { BodPick, NewPlanProgramId } from './newPlan';
import { isSaveResultFailure, LBL, MSG } from './newPlan.constants';
import styles from './NewPlanBodModal.module.scss';

// AS-IS SCM0002_GetBODItemPopup(New Plan 팝업 안에서 BOD 를 고르는 하위 팝업)을 옮긴 모달.
//   설계: .atlas/gscm-design/SCM0002/design/03_grid-columns.md §3. 조회 SP 는 PKG_SCM0002.P_SCM0002_GET_BODITEM_FOR_SUPPLY_POPUP 이고
//   기존 bod-item 화면의 GetBodItemModal 은 SCP0030 래퍼 SP 를 쓰고 LOCK 처리가 없어 재사용하지 않는다.
//   AS-IS 는 LOCK='Y' 행을 체크 상태로 잠그지만, 이 모달은 LOCK 행을 선택 결과에서 제외하는 것으로 같은 결과를 낸다.

interface BodRow {
  LOCK?: string;
  FROM_SITE?: string;
  TO_SITE?: string;
  BOD_ID?: string;
  INCOTERMS?: string;
  TRANSPORT_MODE?: string;
  DAYS_MON?: string;
  DAYS_TUE?: string;
  DAYS_WED?: string;
  DAYS_THU?: string;
  DAYS_FRI?: string;
  DAYS_SAT?: string;
  DAYS_SUN?: string;
  LEAD_TIME?: string | number;
  FROM_YYYYMMDD?: string;
  TO_YYYYMMDD?: string;
  [key: string]: unknown;
}

export interface NewPlanBodParams {
  menuId: string;
  divisionId: string;
  planStartYyyymmdd: string;
  planType: string;
  planSeq: string;
  operationGroupId: string;
  originFromDivisionId: string;
  originToDivisionId: string;
  itemId: string;
  programId: NewPlanProgramId;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  params: NewPlanBodParams;
  // 선택한 BOD 행들(LOCK 제외). 첫 행은 호출 행에, 나머지는 복제 행에 채워진다.
  setSelectedValue: (picks: BodPick[]) => void;
}

// 호출 SP 시트. SCM_ADM_MNU_BTN_MPG_M 의 SCP0009/SCP0010 bodPopup/SEARCH → API SCM0002_BODITEM_GET(12_register_bod_popup.sql).
export const BOD_POPUP_SHEET = 'bodPopup';

const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// 반환 커서 컬럼과 1:1 — 기존 GetBodItemModal 과 같은 구성이다. Voyage 는 sClsLblNm 으로 묶는다.
//   LOCK 은 AS-IS 가 숨기는 컬럼이라 여기에 넣지 않고 행 데이터로만 쓴다(pickSelected 가 row.LOCK 을 읽는다).
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'FROM_SITE_NAME', colLblNm: 'From Site', colWth: 150, horzAlgnCd: 'L' },
  { colNm: 'TO_SITE_NAME', colLblNm: 'To Site', colWth: 150, horzAlgnCd: 'L' },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 130, horzAlgnCd: 'L' },
  { colNm: 'PRIORITY', colLblNm: 'Priority', colWth: 70, horzAlgnCd: 'C' },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 90, horzAlgnCd: 'L' },
  { colNm: 'BOD_ITEM_VALID', colLblNm: 'BOD Item Valid', colWth: 90, horzAlgnCd: 'C' },
  { colNm: 'DAYS_MON', colLblNm: 'Mon', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
  { colNm: 'DAYS_TUE', colLblNm: 'Tue', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
  { colNm: 'DAYS_WED', colLblNm: 'Wed', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
  { colNm: 'DAYS_THU', colLblNm: 'Thu', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
  { colNm: 'DAYS_FRI', colLblNm: 'Fri', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
  { colNm: 'DAYS_SAT', colLblNm: 'Sat', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
  { colNm: 'DAYS_SUN', colLblNm: 'Sun', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
  { colNm: 'LEAD_TIME', colLblNm: 'L/T(Day)', colWth: 80, horzAlgnCd: 'R' },
  { colNm: 'FROM_YYYYMMDD', colLblNm: 'From', colWth: 100, horzAlgnCd: 'C' },
  { colNm: 'TO_YYYYMMDD', colLblNm: 'To', colWth: 100, horzAlgnCd: 'C' },
].map(c => ({ ...c, visible: true, display: true })) as RawFlexGridColumnConfig[];

// 날짜 컬럼이 datetime 문자열로 오면 앞 8자리(yyyymmdd) 또는 yyyy-mm-dd 형태만 남긴다.
const toDateOnly = (v: unknown): string => str(v).slice(0, 10);

const toPick = (row: BodRow): BodPick => ({
  fromSite: str(row.FROM_SITE),
  toSite: str(row.TO_SITE),
  bodId: str(row.BOD_ID),
  incoterms: str(row.INCOTERMS),
  transportMode: str(row.TRANSPORT_MODE),
  voyageMon: str(row.DAYS_MON),
  voyageTue: str(row.DAYS_TUE),
  voyageWed: str(row.DAYS_WED),
  voyageThu: str(row.DAYS_THU),
  voyageFri: str(row.DAYS_FRI),
  voyageSat: str(row.DAYS_SAT),
  voyageSun: str(row.DAYS_SUN),
  ltDay: str(row.LEAD_TIME),
  fromYyyymmdd: toDateOnly(row.FROM_YYYYMMDD),
  toYyyymmdd: toDateOnly(row.TO_YYYYMMDD),
});

export const NewPlanBodModal = ({ open, modalClose, params, setSelectedValue }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const [rawRows, setRawRows] = useState<BodRow[]>([]);
  const [loading, setLoading] = useState(false);

  // 열릴 때마다 조회한다. AS-IS FindData 는 폼 로드 때 1회 조회했다(.cs:240-290).
  useEffect(() => {
    if (!open) return;
    let cancelled = false;
    const load = async () => {
      setLoading(true);
      try {
        const res = await apiClient.post<{ o_rc1?: BodRow[] }>(
          `/${params.menuId}/${BOD_POPUP_SHEET}/SEARCH/call-proc`,
          {
            divisionId: params.divisionId,
            planStartYyyymmdd: params.planStartYyyymmdd.replace(/-/g, '').slice(0, 8),
            planType: params.planType,
            seq: params.planSeq,
            operationGroup: params.operationGroupId,
            originFromDivisionId: params.originFromDivisionId,
            originToDivisionId: params.originToDivisionId,
            itemId: params.itemId,
            prgramId: params.programId,
          }
        );
        if (cancelled) return;
        if (isSaveResultFailure(res)) {
          setRawRows([]);
          void setAlert({ type: 'alert', content: t(MSG.SYSTEM_ERROR, '_System error.') });
          return;
        }
        setRawRows(res.data?.result?.o_rc1 ?? []);
      } catch {
        if (!cancelled) {
          setRawRows([]);
          void setAlert({ type: 'alert', content: t(MSG.SYSTEM_ERROR, '_System error.') });
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void load();
    return () => {
      cancelled = true;
    };
    // 조회 조건은 열릴 때의 값만 쓴다. 객체 참조 변화로 재조회하지 않는다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const rows = useMemo(
    () => withRowNo(rawRows.map(r => ({ ...r, FROM_YYYYMMDD: toDateOnly(r.FROM_YYYYMMDD), TO_YYYYMMDD: toDateOnly(r.TO_YYYYMMDD) }))),
    [rawRows]
  );
  const staticColumns = useMemo(() => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS], [t]);

  // OK — 체크되고 LOCK 이 아닌 행만 반환한다. 0건이면 선택 행 없음 메시지(AS-IS .cs:303-353).
  const pickSelected = (items: BodRow[]) => {
    const picks = items.filter(r => str(r.LOCK) !== 'Y').map(toPick);
    if (picks.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_ROW_SELECTED, '_No rows selected.') });
      return;
    }
    setSelectedValue(picks);
    modalClose();
  };

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    pickSelected((grid.selectedItems ?? []) as unknown as BodRow[]);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as BodRow | undefined;
    if (!dataItem) return;
    pickSelected([dataItem]);
  };

  return (
    <CustomDialog
      size={900}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL_BOD_ITEM_MASTER', { defaultValue: 'BOD Item Master' })}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.gridWrapper}>
            <ProgressIndicator shape='circular' apprearance='infinite' open={loading} placement='parent' />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<WijmoRowItem>
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
