import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import { MENU_ID, SHEETS } from '../../shipment-lot-size.constants';
import type { BatchMode, LotSizePopupRow } from '../../shipment-lot-size.types';

import styles from './ShipmentLotSizeBatchModal.module.scss';

// AS-IS SCM0002_ShipmentLotSizePopup (btnInput "I" 일괄입력 / btnDelete "D" 일괄삭제, design 01 R5/R6).
//   후보 조회 SP = PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP (SHT_NM='popup', IN divisionId/
//   operationGroup/fromSite/toSite/itemId/actionFlag — PROC_M 실측). 선택 후보를 onConfirm 으로 반환하면
//   부모가 I=GET_INPUT 재조회+편집모드, D=SAVE(active_flag='D') 로 처리한다(design 01 R5/R6, 03 §4.4).
//   주의(정직 보고): 팝업 후보 컬럼셋·검색 UX 는 AS-IS 팝업 본문 미덤프(asis.py 비대화형 차단)로 GET/POPUP
//   SP 계약 + 메인 표시 컬럼에서 추론했다 — 브라우저 육안/컬럼 라벨은 사용자 확인 축(04 리포트 명시).

interface Props {
  open: boolean;
  mode: BatchMode; // 'I' 일괄입력 / 'D' 일괄삭제
  divisionId: string; // 부모 확정 division (AS-IS 팝업 입력 파라미터)
  onClose: () => void;
  onConfirm: (rows: LotSizePopupRow[]) => void;
}

export const ShipmentLotSizeBatchModal = ({ open, mode, divisionId, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<LotSizePopupRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.POPUP> | undefined>();

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP,
    tabId: MENU_ID,
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  // useMemo — 매 렌더 새 배열이면 그리드 re-bind 로 체크박스 선택(row.isSelected)이 풀린다(DivisionModal 규약).
  const columns = useMemo(
    () =>
      [
        buildNoColumn(t('LBL00674', 'No')),
        { colNm: 'DIVISION_ID', colLblNm: t('LBL00641', 'Division'), display: true, visible: true, colWth: 90, horzAlgnCd: 'C' },
        { colNm: 'OPERATION_GROUP_ID', colLblNm: t('LBL00027', 'Operation Group'), display: true, visible: true, colWth: 120 },
        { colNm: 'FROM_SITE_DESCRIPTION', colLblNm: t('LBL00022', 'From Site'), display: true, visible: true, colWth: 140 },
        { colNm: 'TO_SITE_DESCRIPTION', colLblNm: t('LBL00023', 'To Site'), display: true, visible: true, colWth: 140 },
        { colNm: 'ITEM_ID', colLblNm: t('LBL00669', 'Model'), display: true, visible: true, colWth: 120 },
        { colNm: 'NICK_NAME', colLblNm: t('LBL00767', 'Nick Name'), display: true, visible: true, colWth: 120 },
        { colNm: 'TRANS_MODE_NAME', colLblNm: t('LBL00025', 'Trans Mode'), display: true, visible: true, colWth: 100, horzAlgnCd: 'C' },
      ] as RawFlexGridColumnConfig[],
    [t]
  );

  const rows = useMemo(() => withRowNo(data?.o_rc1 ?? []), [data]);

  // 팝업 open 시 후보 조회 필터 세팅(division + actionFlag). close 시 초기화.
  useEffect(() => {
    if (open && divisionId) {
      setFilters({
        divisionId,
        operationGroup: '',
        fromSite: '',
        toSite: '',
        itemId: '',
        actionFlag: mode,
      });
    } else {
      setFilters(undefined);
    }
  }, [open, divisionId, mode]);

  const collectCheckedRows = (grid: FlexGrid<LotSizePopupRow> | null | undefined): LotSizePopupRow[] => {
    if (!grid) return [];
    const picked: LotSizePopupRow[] = [];
    for (const row of grid.rows) {
      if (row?.isSelected) picked.push(row.dataItem as LotSizePopupRow);
    }
    return picked;
  };

  const handleConfirm = () => {
    onConfirm(collectCheckedRows(gridRef.current));
  };

  const title =
    mode === 'I'
      ? t('LBL00872', { defaultValue: 'Input' })
      : t('LBL00108', { defaultValue: 'Delete' });

  const headerTitle = (
    <div className={styles.headerContainer}>
      <div className={styles.headerDot} />
      <h2 className={styles.headerTitle}>{`${t('MNU00091', '_Shipment Lot Size')} - ${title}`}</h2>
    </div>
  );

  return (
    <CustomDialog
      open={open}
      size={860}
      type='modal'
      position='basic'
      handleClose={onClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.gridWrapper}>
            <ProgressIndicator shape='circular' apprearance='infinite' open={loading} placement='parent' />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<LotSizePopupRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows}
                staticColumns={columns}
                useCheckbox
                isReadOnly
              />
            </ResultArea>
          </div>

          {/* 우하단 버튼 정렬 — 액션(OK) 먼저, Close 마지막(CommonCheckList §팝업, nscm-patterns §3.7) */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t('LBL00716', '_OK')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleConfirm}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', '_Close')}
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
