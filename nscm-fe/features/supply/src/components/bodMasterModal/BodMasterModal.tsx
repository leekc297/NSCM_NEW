import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { isSaveResultFailure, LBL, MSG } from '../newPlanModal/newPlan.constants';

import styles from './BodMasterModal.module.scss';

// AS-IS SCM0002_GetBODPopup(BOD Master) 을 옮긴 공용 모달. SCP0009(FG, type 0) / SCP0010(SEMI, type 1) 이 같이 쓴다.
//   조회 SP: PKG_SCM0002.P_SCM0002_GET_BOD_FG_POPUP / P_SCM0002_GET_BOD_SEMI_POPUP(화면별 bodMaster/SEARCH 버튼매핑이 고른다).
//   메타 등록: .atlas/gscm-design/SCP0009/design/09_register_bod_master_popup.sql
//   AS-IS 는 호출 행들과 KEY_IDX 가 같은 후보를 IS_LOCK='Y' 로 체크+잠금(LockRange) 표시하고 OK 결과에서 뺀다
//   (SCM0002_GetBODPopup.cs:331-337, 373-374). 이 모달도 잠금 행을 체크 고정(해제 불가)으로 보여 주고 OK 에서 제외한다.

export type BodMasterType = 0 | 1; // 0 = FG, 1 = SEMI

export interface BodMasterParams {
  divisionId: string;
  bodId: string;
  fromSite: string;
  toSite: string;
  planStartYyyymmdd: string;
  operGrp: string; // FG = BIZ_TYPE, SEMI = OPERATION_GROUP
  itemId: string;
  originFromDivisionId: string;
}

// 선택된 BOD 1건 — 행 삽입에 필요한 값만 담는다(AS-IS InsertRow 가 읽는 dtBOD 컬럼).
export interface BodMasterPick {
  bodId: string;
  firstSite: string;
  firstSiteName: string;
  secondSite: string;
  secondSiteName: string;
  incoterms: string;
  transportMode: string;
  ltTotal: string;
  shipFrozen: string;
  bodFromYyyymmdd: string;
  bodToYyyymmdd: string;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  type: BodMasterType;
  menuId: string;
  params: BodMasterParams;
  // 호출 행들의 잠금 키(division_id + from_site + to_site + transport_mode + bod_id). 같은 KEY_IDX 후보는 제외된다.
  callerKeys: string[];
  onSelect: (picks: BodMasterPick[]) => void;
}

export const BOD_MASTER_SHEET = 'bodMaster';

interface BodRow {
  KEY_IDX?: string;
  [key: string]: unknown;
}

const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');
const toDateOnly = (v: unknown): string => str(v).slice(0, 10);
const toYyyymmdd = (v: unknown): string => str(v).replace(/-/g, '').slice(0, 8);

// AS-IS 가시 컬럼(SCM0002_GetBODPopup.cs). FIRST/SECOND 사이트 라벨은 FG/SEMI 에서 서로 반대다.
const buildColumns = (type: BodMasterType): RawFlexGridColumnConfig[] =>
  [
    { colNm: 'FIRST_SITE_NAME', colLblNm: type === 0 ? 'To Site' : 'From Site', colWth: 150, horzAlgnCd: 'L' },
    { colNm: 'SECOND_SITE_NAME', colLblNm: type === 0 ? 'From Site' : 'To Site', colWth: 150, horzAlgnCd: 'L' },
    { colNm: 'PRIORITY', colLblNm: 'Priority', colWth: 70, horzAlgnCd: 'C' },
    { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 80, horzAlgnCd: 'L' },
    { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 90, horzAlgnCd: 'L' },
    { colNm: 'DAYS_MON', colLblNm: 'Mon', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
    { colNm: 'DAYS_TUE', colLblNm: 'Tue', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
    { colNm: 'DAYS_WED', colLblNm: 'Wed', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
    { colNm: 'DAYS_THU', colLblNm: 'Thu', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
    { colNm: 'DAYS_FRI', colLblNm: 'Fri', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
    { colNm: 'DAYS_SAT', colLblNm: 'Sat', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
    { colNm: 'DAYS_SUN', colLblNm: 'Sun', sClsLblNm: 'Voyage', colWth: 45, horzAlgnCd: 'C' },
    { colNm: 'LT_TOTAL', colLblNm: 'L/T(Day)', colWth: 80, horzAlgnCd: 'R' },
    { colNm: 'FROM_YYYYMMDD', colLblNm: 'From', colWth: 100, horzAlgnCd: 'C' },
    { colNm: 'TO_YYYYMMDD', colLblNm: 'To', colWth: 100, horzAlgnCd: 'C' },
  ].map(c => ({ ...c, visible: true, display: true })) as RawFlexGridColumnConfig[];

const toPick = (row: BodRow): BodMasterPick => ({
  bodId: str(row.BOD_ID),
  firstSite: str(row.FIRST_SITE),
  firstSiteName: str(row.FIRST_SITE_NAME),
  secondSite: str(row.SECOND_SITE),
  secondSiteName: str(row.SECOND_SITE_NAME),
  incoterms: str(row.INCOTERMS),
  transportMode: str(row.TRANSPORT_MODE),
  ltTotal: str(row.LT_TOTAL),
  shipFrozen: toYyyymmdd(row.SHIP_FROZEN),
  bodFromYyyymmdd: toYyyymmdd(row.FROM_YYYYMMDD),
  bodToYyyymmdd: toYyyymmdd(row.TO_YYYYMMDD),
});

export const BodMasterModal = ({ open, modalClose, type, menuId, params, callerKeys, onSelect }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const [rawRows, setRawRows] = useState<BodRow[]>([]);
  const [loading, setLoading] = useState(false);

  // 열릴 때마다 조회한다(AS-IS 는 폼 로드 시 1회 조회).
  useEffect(() => {
    if (!open) return;
    let cancelled = false;
    const load = async () => {
      setLoading(true);
      try {
        const res = await apiClient.post<{ o_rc1?: BodRow[] }>(`/${menuId}/${BOD_MASTER_SHEET}/SEARCH/call-proc`, {
          divisionId: params.divisionId,
          bodId: params.bodId,
          fromSite: params.fromSite,
          toSite: params.toSite,
          planStartYyyymmdd: toYyyymmdd(params.planStartYyyymmdd),
          operGrp: params.operGrp,
          itemId: params.itemId,
          origionDivisionId: params.originFromDivisionId,
          debugMode: 'F',
        });
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
    () =>
      withRowNo(
        rawRows.map(r => ({
          ...r,
          FROM_YYYYMMDD: toDateOnly(r.FROM_YYYYMMDD),
          TO_YYYYMMDD: toDateOnly(r.TO_YYYYMMDD),
        }))
      ),
    [rawRows]
  );
  const staticColumns = useMemo(() => [buildNoColumn(t(LBL.NO, '_No')), ...buildColumns(type)], [t, type]);

  // 잠금 행 표시(AS-IS IS_LOCK='Y' → CHK=True + LockRange). initialized 는 1회 closure 라 키는 ref 로 읽는다.
  const lockedKeysRef = useRef(new Set<string>());
  lockedKeysRef.current = new Set(callerKeys);
  const isLockedRow = (grid: FlexGrid, r: number): boolean =>
    lockedKeysRef.current.has(str((grid.rows[r]?.dataItem as BodRow | undefined)?.KEY_IDX));

  const handleInitialized = (grid: FlexGrid) => {
    // 잠금 행은 항상 체크 상태로 되돌린다(행 로드·전체선택 해제 뒤에도). 같은 값 대입은 무시돼 루프가 생기지 않는다.
    const keepLockedChecked = () => {
      grid.rows.forEach((row, r) => {
        if (isLockedRow(grid, r) && !row.isSelected) row.isSelected = true;
      });
    };
    grid.loadedRows.addHandler(keepLockedChecked);
    grid.updatedView.addHandler(keepLockedChecked);
    // 셀 DOM 은 재사용되므로 체크박스 disabled 는 잠금 여부로 매번 다시 정한다.
    grid.formatItem.addHandler((_s, e) => {
      const locked = isLockedRow(grid, e.row);
      if (e.panel.cellType === CellType.RowHeader && e.col === 0) {
        const input = e.cell.querySelector<HTMLInputElement>('input[type=checkbox]');
        if (input) input.disabled = locked;
      } else if (e.panel.cellType === CellType.Cell) {
        // AS-IS 잠금 행은 체크만 되고 배경색이 없다. 체크(isSelected)로 붙는 선택 하이라이트는 wijmo 가
        //   formatItem 없이 클래스를 다시 붙이므로, 표식 클래스를 달고 scss 에서 배경을 덮는다.
        e.cell.classList.toggle(styles.lockedRow, locked);
      }
    });
  };

  // OK — 체크된 행 중 호출 행과 같은 키(잠금)는 제외. 0건이면 메시지 없이 닫는다(AS-IS 동일).
  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const locked = new Set(callerKeys);
    const picks = ((grid.selectedItems ?? []) as unknown as BodRow[])
      .filter(r => !locked.has(str(r.KEY_IDX)))
      .map(toPick);
    if (picks.length > 0) onSelect(picks);
    modalClose();
  };

  return (
    <CustomDialog
      size={1050}
      height='25vh'
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL_BOD_MASTER', { defaultValue: 'BOD Master' })}</h2>
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
                initialized={handleInitialized}
                itemsSource={rows as unknown as WijmoRowItem[]}
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
