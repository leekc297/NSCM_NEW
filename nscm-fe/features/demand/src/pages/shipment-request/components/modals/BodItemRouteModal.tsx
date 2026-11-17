/**
 * DMF0045 TR_MODE 셀 BOD Item/Project/Route 선택 팝업 (AS-IS DMF0046 GetBODItemPrjRoutePopup, design 03 §3).
 *
 * 트리거 = 신규행(action='I') TR_MODE 셀 더블클릭(전제 ITEM_ID — 없으면 그리드가 선차단). 다건 선택 가능하며
 *   확정 시 부모(applyPopupFill BOD)가 c_* 반환을 현재 행 7칸(FROM_SITE/TO_SITE/INCOTERMS/TR_MODE/
 *   BOD_ID/END_CUSTOMER/TEAM_NAME_KO)에 매핑한다.
 *
 * 주의: 공용 features/master 팝업 카탈로그에 이 SP 의 1:1 대응이 없다 — Hard Boundary(convert-core §2.2)상
 *   타 feature 에 새 컴포넌트를 만들 수 없어 화면 폴더에 로컬 구성한다(shipping SSP0045 BodItemRouteModal 선례).
 * 주의: DMF0046 GetBODItemPrjRoutePopup 미배포 → 조회 런타임 미완. 배선·가드·파라미터는 완비, 실행은 SP 배포 후.
 * 주의: 팝업 컬럼도 admin 메타 단일 원천(memory popup-grid-columns-admin-meta). SCM_MST_SHEET_COLUMNS
 *   PROGRAM_ID='DMF0045' SHEET_NAME='bodPopup' — FE 하드코딩 컬럼 배열 금지(register.sql 등록 대상).
 */
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID} from '../../shipment-request.constants';
import { BOD_POPUP_TITLE_KEY, LBL, MSG_NO_ROWS_SELECTED, SHEETS } from '../../shipment-request.constants';
import type { BodItemReturn, BodPopupRow } from '../../shipment-request.types';

import styles from './BodItemRouteModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행(다건) 전달 — 부모가 c_* 반환을 현재 행 7칸에 매핑한다(applyPopupFill BOD).
  setSelectedValue: (rows: BodItemReturn[]) => void;
  // AS-IS DMF0046 팝업 파라미터 — divisionId + itemId(전제) + fromYyyymmdd.
  preSearchParams: {
    divisionId: string;
    itemId: string;
    fromYyyymmdd: string;
  };
}

// [ROLLBACK:dmf0045-bod-popup-use-scp0030 · 2026-10-29] ──────────────────────────────────────────────
//   사용자 지시(2026-10-29): DMF0045 TR_MODE 팝업을 SCP0030 BOD ID 팝업과 "동일하게 동작"하도록 그 백엔드를
//   그대로 재사용한다(일단 동작 우선, 세부 매핑은 후속). SCP0030 BOD 팝업 = 배포 완료:
//     · 조회 : /SCP0030/bodPopup/SEARCH/call-proc → PKG_SCP0030.P_SCP0030_GET_BOD_POPUP
//              (내부에서 PKG_SCM0002.P_SCM0002_GET_BODITEM_FOR_SUPPLY_POPUP 호출, IN = divisionId/itemId)
//     · 권한 : 호출자(attackgo 등) SCP0030 메뉴·bodPopup/SEARCH 권한 보유(DB 실측 2026-10-29)
//   주의: SCP0030/bodPopup 은 admin 컬럼메타가 DB 에 없다(SCP0030 FE 도 하드코딩) → 아래 POPUP_COLUMNS 를
//     SCP0030 GetBodItemModal 과 동일하게 하드코딩한다(이 팝업 한정 예외). 반환은 FROM_SITE_NAME/TO_SITE_NAME
//     (사이트 '명')·TRANSPORT_MODE·INCOTERMS·BOD_ID 중심이라 END_CUSTOMER/Team 은 안 채워진다(A안 수용).
//   롤백: BOD_SRC_MENU 를 MENU_ID 로 되돌리고, 하드코딩 POPUP_COLUMNS 를 admin 메타 fetch(popupColumns)로
//     원복, filters/toSelection 을 원래 DMF0046 컬럼명으로 되돌린다.
const BOD_SRC_MENU = 'SCP0030';

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

export const BodItemRouteModal = ({ open, modalClose, setSelectedValue, preSearchParams }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.BOD_POPUP> | undefined>(
    undefined
  );

  // [ROLLBACK:dmf0045-bod-popup-use-scp0030] 컬럼 메타 = 하드코딩 POPUP_COLUMNS(SCP0030 동일, admin 메타 없음).
  //   종전엔 /admin/menu/DMF0045/column 에서 fetch 했으나 SCP0030/bodPopup 은 메타가 없어 하드코딩으로 대체.

  useEffect(() => {
    if (!open) return;
    // [ROLLBACK:dmf0045-bod-popup-use-scp0030] SCP0030 SP(P_SCP0030_GET_BOD_POPUP) IN = divisionId/itemId.
    //   planGroup 은 SP 가 안 쓰지만 SCP0030 FE 와 동형으로 함께 보낸다(빈값).
    setFilters({
      divisionId: preSearchParams.divisionId,
      itemId: preSearchParams.itemId,
      planGroup: '',
    } as never);
    // 열릴 때만 초기화 — 열려 있는 동안 상위 값 변화로 입력을 덮지 않는다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.BOD_POPUP>({
    // [ROLLBACK:dmf0045-bod-popup-use-scp0030] 조회를 /SCP0030/bodPopup/SEARCH/call-proc 로 보낸다.
    menuId: BOD_SRC_MENU as never,
    sheetName: SHEETS.BOD_POPUP,
    tabId: `${BOD_SRC_MENU}_DMF0045_BodItemRouteModal`,
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  // [ROLLBACK:dmf0045-bod-popup-use-scp0030] SCP0030 GetBodItemModal 동일 — From/To(YYYYMMDD)는 date-only 정규화.
  const rows = useMemo(
    () =>
      withRowNo(
        (data?.o_rc1 ?? []).map(row => {
          const r = row as unknown as { FROM_YYYYMMDD?: string; TO_YYYYMMDD?: string };
          return {
            ...row,
            FROM_YYYYMMDD: (r.FROM_YYYYMMDD ?? '').slice(0, 10),
            TO_YYYYMMDD: (r.TO_YYYYMMDD ?? '').slice(0, 10),
          };
        }) as unknown as BodPopupRow[]
      ),
    [data]
  );
  // [ROLLBACK:dmf0045-bod-popup-use-scp0030] 하드코딩 POPUP_COLUMNS 사용(admin 메타 fetch 대체).
  const staticColumns = useMemo(() => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS], [t]);

  // [ROLLBACK:dmf0045-bod-popup-use-scp0030] SCP0030 BOD 팝업 반환 컬럼 → c_* 매핑.
  //   SCP0030(supply) 반환 커서는 사이트 **코드**(FROM_SITE/TO_SITE)와 **명**(FROM_SITE_NAME/TO_SITE_NAME)을
  //   둘 다 준다(ora.py 실측 2026-11-10: o_rc1 컬럼에 FROM_SITE·FROM_SITE_NAME·TO_SITE·TO_SITE_NAME 공존).
  //   END_CUSTOMER/DEPT 는 반환하지 않아 그 2칸은 ''(A안 수용). 원복 시 DMF0046 컬럼명으로.
  //   From/To Site 셀은 **코드**(SCM_SITE_ID)로 채운다 — 명(_NAME)을 넣으면 SHIP_FROZEN 조회
  //   (SCM_MST_SITE.SCM_SITE_ID = FROM_SITE, SP line 196)·저장이 매칭 실패해 Frozen 구간이 안 잡힌다
  //   (사용자 신고 2026-11-10, AS-IS 는 c_FROM_SITE=코드를 SetText — DMF0045_ShipmentRequest.cs:1346/1358).
  const toSelection = (row: BodPopupRow): BodItemReturn => {
    const r = row as unknown as Record<string, string | undefined>;
    return {
      c_FROM_SITE: r.FROM_SITE ?? '', // 코드(SCM_SITE_ID) — 명 FROM_SITE_NAME 아님
      c_TO_SITE: r.TO_SITE ?? '', // 코드(SCM_SITE_ID) — 명 TO_SITE_NAME 아님
      c_INCOTERMS: r.INCOTERMS ?? '',
      c_TRANSPORT_MODE: r.TRANSPORT_MODE ?? '',
      c_BOD_ID: r.BOD_ID ?? '',
      c_END_CUSTOMER: '',
      c_DEPT_NAME_KO: '',
    };
  };

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as BodPopupRow[];
    if (selections.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG_NO_ROWS_SELECTED, { defaultValue: 'No rows selected.' }),
      });
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
          <h2 className='headerTitle'>{t(BOD_POPUP_TITLE_KEY, { defaultValue: 'BOD Item Master' })}</h2>
        </div>
      }
      customContentArea={
        // [ROLLBACK:dmf0045-bod-popup-use-scp0030] SCP0030 GetBodItemModal 과 동일 레이아웃 — 검색영역 없이
        //   그리드만(division/item 은 preSearchParams 로 열 때 자동조회). 원복 시 SearchArea(Div/Model/Search) 복원.
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
                // [ROLLBACK:dmf0045-bod-popup-use-scp0030] SCP0030 GetBodItemModal 과 동일 — 체크박스 다건 선택.
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
