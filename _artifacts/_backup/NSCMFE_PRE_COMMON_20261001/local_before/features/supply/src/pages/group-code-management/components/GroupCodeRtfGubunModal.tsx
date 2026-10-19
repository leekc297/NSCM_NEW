/**
 * SCP0080 전용 RTFGubun(GROUP_CODE5, 82 사업부) 선택 팝업.
 *
 * AS-IS: GSCM.SystemMgmt.UIL.CommonDataSCPPopup(DataType=RTFGubun, DivisionID='82') —
 *   Code/Name 2컬럼 단건선택 그리드. OK 시 편집셀 GROUP_CODE5 에 item.Name 을 넣는다
 *   (SCP0080_GroupCodeManagement.cs:1657~1679, 03_grid-columns.md §3-3 R-POPUP-RTFGUBUN).
 *
 * 데이터 원천: 등록 콤보 RTFGubun_SCP(SCM_ADM_CMBO_SQL_M) — DIVISION_ID/CODE/NAME 반환,
 *   @divisionId 파라미터로 사업부 필터(INSTR 다중매칭). AS-IS CommonDataList_SCP 비즈서비스 등가
 *   (convert-core §2.6 의미 패리티 — 값 재사용 아님). 별도 SP 배선 불필요(콤보 기존 배포).
 *
 * Hard Boundary: 이 팝업은 group-code-management 폴더 소유. 공용 CommonData 모달이 없어
 *   자매(shipping/ItemByDivisionModal + supply/ElecMaterialPopup) 패턴으로 화면 로컬 구현한다.
 */
import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabComboQueryResults } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import { MENU_ID, RTF_GUBUN_COMBO_ID } from '../group-code-management.constants';

import styles from './GroupCodeRtfGubunModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 편집중인 82 division 값. RTFGubun_SCP @divisionId 필터로 넘어간다(항상 '82' 이지만 명시 전달).
  divisionId: string;
  // 선택 확정 -> 부모가 GROUP_CODE5 <- NAME 을 쓴다(AS-IS item.Name).
  setSelectedValue: (name: string) => void;
}

// AS-IS CommonDataSCPPopup 그리드 = Code(70) / Name(300) 2 텍스트 컬럼(cs:131~132). 그대로 재현.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'CODE', colLblNm: 'Code', colWth: 90, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'NAME', colLblNm: 'Name', colWth: 300, horzAlgnCd: 'L', visible: true, display: true },
];

export const GroupCodeRtfGubunModal = ({
  open,
  modalClose,
  divisionId,
  setSelectedValue,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  // RTFGubun_SCP 콤보 조회. divisionId 는 raw 로 넘긴다 — apiClient.getCombo funnel(quoteComboParams)이
  //   홑따옴표를 붙여 @divisionId SQL 리터럴로 치환한다(이중 인용 방지, 인용 주체=funnel).
  //   data 뿐 아니라 isPending 도 필요해 useTabComboQueryResults(전체 쿼리 객체) 를 쓴다.
  const [rtfQuery] = useTabComboQueryResults({
    filters: [{ comboId: RTF_GUBUN_COMBO_ID, mnuId: MENU_ID, divisionId }],
    enabled: open,
  });
  const loading = open && (rtfQuery?.isPending ?? false);

  const rows = useMemo(
    () => withRowNo((rtfQuery?.data ?? [])),
    [rtfQuery?.data]
  );
  const staticColumns = useMemo(
    () => [buildNoColumn(t('LBL00674', { defaultValue: 'No' })), ...POPUP_COLUMNS],
    [t]
  );

  const confirm = (row: ComboResponse | undefined) => {
    if (!row) return;
    // AS-IS: defaultData.Add(GROUP_CODE5, item.Name) — Name 을 셀에 넣는다(Code 아님).
    setSelectedValue(String(row.NAME ?? ''));
    modalClose();
  };

  const handleSubmit = () => {
    const selected = gridRef.current?.selectedItems?.[0] as ComboResponse | undefined;
    confirm(selected);
  };

  // 더블클릭 = 그 행으로 즉시 확정(단건 빠른 경로, AllowMultiRange=false).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row) as ComboResponse | undefined;
    confirm(row);
  };

  return (
    <CustomDialog
      size={520}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00669', { defaultValue: 'Common Data' })}</h2>
        </div>
      }
      customContentArea={
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
                headersVisibility={HeadersVisibility.Column}
                staticColumns={staticColumns}
                itemsSource={rows as unknown as WijmoRowItem[]}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel='OK'
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
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
