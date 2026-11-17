/**
 * SSP0024 전용 Material/Model 선택 팝업 (AS-IS SSP0024_ItembyDivisionPopup, 전극 item 마스터).
 *
 * 주의: 공용 features/master ItemByDivisionModal(COM0008, DM0002_ItembyDivisionPopup)과 겉모습은 같지만
 *   호출 SP·조회조건·반환컬럼이 다르다(design 02 §4.6). 이 팝업은 전용 SP
 *   PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP(원천 SCP_MST_FINAL_ITEM)을 쓰고 10 프로퍼티를 반환한다.
 *   공용 모달을 그대로 재사용하지 말 것(nscm-patterns §2.6 콤보/팝업 의미 패리티).
 *
 * 두 호출 경로:
 *   - 조회조건 버튼(btnMaterialId/btnModelId): 다중 선택 -> 부모가 MaterialId/ModelId 만 추출해 텍스트 채움.
 *   - 그리드 셀(MATERIAL_ID 더블클릭): 단건 선택 -> 부모가 10칸 일괄 채움(design 03 §3.2 cs:570~579).
 *
 * 주의: PKG_SSP0024 미배포(goal.md ②) -> 조회 SP 는 런타임 미완. 배선 완비, 실행은 convert-sp 배포 후.
 */
import { CellType, HeadersVisibility, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LBL, MENU_ID, SHEETS } from '../../shipment-master-electrode.constants';
import type { PopupRow } from '../../shipment-master-electrode.types';

import styles from './ElectrodeItemByDivisionModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행(들) 그대로 전달 — 부모가 용도에 맞게 추출(버튼=id 다건 / 셀=10칸 일괄).
  setSelectedValue: (rows: PopupRow[]) => void;
  // 조회 컨텍스트(design 02 §4.6): divisionId / plantSiteCode / materialId.
  preSearchParams: { divisionId?: string; plantSiteId?: string; materialId?: string };
  // 셀 호출(단건, 10칸 채움) vs 버튼 호출(다건, id 채움).
  callFromCell: boolean;
}

// AS-IS InitSpread(Popup/SSP0024_ItembyDivisionPopup.cs:214~224) 의 노출 컬럼 10종을 순서·라벨·폭 그대로.
//   AS-IS 는 DIVISION_NAME 1컬럼만 visible=false 로 숨긴다(11 중 10 노출).
//   admin 메타(`SCM_MST_SHEET_COLUMNS`)에 이 팝업 시트 행이 없어(실측: SSP0024 는 'Ship Master Elec' 25행
//   단일 시트) 화면 정의를 쓴다 — 메타가 등록되면 그쪽이 authoritative 다(임의 등록 금지, convert-core §2.3).
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Division', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'PLANT_SITE_CODE', colLblNm: 'Plant Site Code', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'PLANT_SITE_ID', colLblNm: 'Plant Site', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'MATERIAL_ID', colLblNm: 'Material', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'MODEL_ID', colLblNm: 'Model', colWth: 150, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'CELL_TYPE', colLblNm: 'Cell Type', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 150, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'ELECTRODE_TYPE', colLblNm: 'Electrode Type', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'ITEM_UOM', colLblNm: 'UOM', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'UOM_CONVERT_IN_TACT_TIME', colLblNm: 'Pancake (m/cell)', colWth: 120, horzAlgnCd: 'R', scale: 4, visible: true, display: true },
];

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 콤보 행 -> 드롭다운 옵션(코드->명칭). 부모 Form 과 동일(ShipmentMasterElectrodeForm toOptions).
const toOptions = (rows: ComboResponse[] | undefined): { label: string; value: string }[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

export const ElectrodeItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [materialId, setMaterialId] = useState('');
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.POPUP> | undefined>(undefined);

  // 조회조건 Div/Plant Site 는 AS-IS clbDivisionId/clbPlantSiteId(UsrCheckedList)처럼 select 로 보이되
  //   AS-IS 와 동일하게 비활성(읽기전용)이다 — AS-IS SetConditionPanel 이 두 리스트를 채운 뒤
  //   Enabled=false 로 둔다(Popup/SSP0024_ItembyDivisionPopup.cs:190~191). 값은 preSearchParams 컨텍스트
  //   고정. 부모 Form 과 같은 콤보(MyDivision·PlantSiteByFactoryEEOperation)를 받아 코드->명칭으로 표시한다.
  const [divisions, plantSites] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO.PLANT_SITE, mnuId: MENU_ID, divisionId: preSearchParams.divisionId ?? '' },
    ],
  });
  const divisionOptions = useMemo(() => toOptions(divisions), [divisions]);
  const plantSiteOptions = useMemo(() => toOptions(plantSites), [plantSites]);

  // 팝업 오픈 시 자동조회 — AS-IS SSP0024_ItembyDivisionPopup 은 열리면 바로 조회된다(사용자 확인
  //   2026-10-16). TO-BE 표준(공용 ItemByDivisionModal POP-09 "열자마자 preSearchParams 로 조회")과도
  //   일치한다. 오픈 컨텍스트(division/plantSite/material)로 filters 를 즉시 세팅해 useTabProcQuery 를
  //   enable 한다. 닫히면 filters 를 초기화해 재오픈 시 스테일 결과를 막는다(이 모달 3개가 상시 마운트라
  //   내부 state 가 오픈 간 유지됨). 이후 Material 재입력 + Search 는 handleSearch 로 재조회한다.
  useEffect(() => {
    if (!open) {
      setFilters(undefined);
      return;
    }
    // 셀 재오픈(callFromCell): 기존 Material 로 선필터하면 결과가 1건이라 아래 auto-pick 이 즉시
    //   선택+닫아 "다시 안 열린다"(사용자 신고 2026-11-06). 항상 div+plant 전체 목록으로 열어 다른
    //   Material 로 교체할 수 있게 한다(materialId 선필터 제거). 버튼 경로(callFromCell=false)는 종전대로.
    const mat = callFromCell ? '' : (preSearchParams.materialId ?? '');
    setMaterialId(mat);
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      plantSiteId: preSearchParams.plantSiteId ?? '',
      materialId: mat,
    } as ProcRequest<MENU_ID, SHEETS.POPUP>);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP,
    tabId: 'SSP0024_ItemByDivisionModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as PopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS],
    [t]
  );

  // Search(FindButton 등가)에서만 조회 발사 — 오픈 컨텍스트(division/plantSite) + 현재 Material 입력으로
  //   filters 를 세팅해 useTabProcQuery 를 enable 시킨다(AS-IS FindData 진입 경로 파리티).
  const handleSearch = () => {
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      plantSiteId: preSearchParams.plantSiteId ?? '',
      materialId,
    } as ProcRequest<MENU_ID, SHEETS.POPUP>);
  };

  // AS-IS FindData 는 조회 결과가 **정확히 1건**이면 클릭 없이 그 행을 확정하고 팝업을 닫는다
  //   (Popup/SSP0024_ItembyDivisionPopup.cs:284~298). 조회 1회당 한 번만 발동하도록 filters 참조로 잠근다
  //   (같은 결과로 재렌더될 때 반복 닫힘 방지). gap-resolve iter-1 A06.
  const autoPickedRef = useRef<unknown>(undefined);
  useEffect(() => {
    if (!open || loading || !filters) return;
    if (autoPickedRef.current === filters) return;
    if (rows.length !== 1) return;
    autoPickedRef.current = filters;
    setSelectedValue([rows[0] as PopupRow]);
    modalClose();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, loading, filters, rows]);

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    // 체크박스 다중선택(useCheckbox)에서 체크 상태는 row.isSelected 에 있다(GRID-05) — grid.selectedItems
    //   (셀 범위 선택)가 아니다. 공용 ItemByDivisionModal·ShipmentLotSizeBatchModal 동일 패턴으로 수집한다.
    const selections: PopupRow[] = [];
    for (const row of grid.rows) {
      if (row?.isSelected && row.dataItem) selections.push(row.dataItem as PopupRow);
    }
    if (selections.length === 0) return;
    setSelectedValue(selections);
    modalClose();
  };

  // 더블클릭 = 그 행 하나로 확정 후 닫기 (셀 호출 단건 빠른 경로).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as PopupRow | undefined;
    if (!dataItem) return;
    setSelectedValue([dataItem]);
    modalClose();
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
          <h2 className='headerTitle'>{t(LBL.ITEM_BY_DIVISION, '_Item by Division')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_SUB, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.DIVISION, '_Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled
                        value={preSearchParams.divisionId ?? ''}
                        options={divisionOptions}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.PLANT_SITE, '_Plant Site')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        limitTags={1}
                        disabled
                        value={preSearchParams.plantSiteId ?? ''}
                        options={plantSiteOptions}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.MATERIAL, '_Material')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={materialId}
                        onChange={e => setMaterialId(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
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
                useCheckbox={!callFromCell}
                headersVisibility={callFromCell ? HeadersVisibility.Column : HeadersVisibility.All}
                staticColumns={staticColumns}
                itemsSource={rows as unknown as WijmoRowItem[]}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              buttonLabel={t(LBL.OK, '_OK')}
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
