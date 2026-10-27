/**
 * SSP0025 전용 Material/Model 선택 팝업 (AS-IS SSP0025_ItembyDivisionPopup, 전극 item 마스터).
 *
 * 주의: 공용 features/master ItemByDivisionModal(COM0008, DM0002_ItembyDivisionPopup)과 겉모습은 같지만
 *   호출 SP·조회조건·반환컬럼이 다르다(design 02 §4.6). 이 팝업은 전용 SP
 *   PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP 을 쓰고 ItemId/DivisionId/ElectrodeType/ModelId/
 *   NickName/CellType 6 프로퍼티를 반환한다. 공용 모달을 그대로 재사용하지 말 것(convert-core §2.6 의미 패리티).
 *   POP-01 판정: 공용 ItemByDivisionModal 의 대응 AS-IS 는 DM0002_ItembyDivisionPopup(Ex)이고, 이 팝업의
 *   AS-IS 클래스 SSP0025_ItembyDivisionPopup 은 GSCM 전체에서 SSP0025 만 호출한다 — 대응 공용 modal 이 없어
 *   로컬 신규가 허용 경로다. 상세 근거는 __asis-mapping__.md "POP-01 판정 근거".
 *
 * 조회조건(AS-IS Popup/SSP0025_ItembyDivisionPopup.cs InitControls cs:196~222 그대로):
 *   - Division  : 컨텍스트 고정(AS-IS clbDivisionId.Enabled=false, cs:204) — 부모 division 표시만.
 *   - From Site : 다중선택(AS-IS clbFromSiteId.Enabled=true, cs:205). CMBO FromSiteByAssembly
 *                 (@segment5=division / @attribute1=to-site). p_from_site_id 로 전달(ALL/빈값=무필터).
 *   - Material / Model : BtnType 으로 한쪽만 노출(AS-IS cs:214~221) — mode(ITEM/MODEL/CELL)로 재현.
 *   - To Site  : 컨텍스트(부모 plantSite)로 p_to_site_id 전달(비표시, AS-IS sPlantSiteCode cs:301).
 *
 * 두 호출 경로:
 *   - 조회조건 버튼(btnItemId/btnModelId): 다중 선택 -> 부모가 ItemId/ModelId 만 추출해 텍스트 채움.
 *   - 그리드 셀(ITEM_ID 더블클릭): 단건 선택 -> 부모가 6칸 일괄 채움(design 03 §3 R12 cs:642~666).
 *
 * 조회 발사: AS-IS Form_Load 가 FindData() 를 즉시 호출(cs:182)하므로 오픈 시 자동조회하고, 결과가
 *   정확히 1건이면 클릭 없이 확정·닫기(AS-IS cs:315~332). 자매 SSP0024 ElectrodeItemByDivisionModal 동형.
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

import { COMBO, LBL, MENU_ID, SHEETS } from '../../shipment-requestor-pic.constants';
import type { PopupRow } from '../../shipment-requestor-pic.types';

import styles from './RequestorPicItemByDivisionModal.module.scss';

// 팝업 조회 모드(design 02 §4.6): ITEM(btnItemId)/MODEL(btnModelId)/CELL(그리드 셀 R12).
export type ItemPopupMode = 'ITEM' | 'MODEL' | 'CELL';

interface Props {
  open: boolean;
  modalClose: () => void;
  // 선택 행(들) 그대로 전달 — 부모가 용도에 맞게 추출(버튼=id 다건 / 셀=6칸 일괄).
  setSelectedValue: (rows: PopupRow[]) => void;
  // 조회 컨텍스트(design 02 §4.6): divisionId / plantSite(=to-site) / item(model).
  preSearchParams: { divisionId?: string; plantSite?: string; itemId?: string; modelId?: string };
  // 셀 호출(단건, 6칸 채움) vs 버튼 호출(다건, id 채움).
  callFromCell: boolean;
  // AS-IS BtnType 등가 — 검색칸을 Material/Model 중 무엇으로 쓸지 결정한다(Popup cs:214~221).
  //   값으로 추론하면 Model 이 빈 채로 팝업을 열었을 때 Material 모드로 오판하므로 명시 전달한다.
  mode: ItemPopupMode;
}

// AS-IS 팝업 그리드 컬럼 (Popup/SSP0025_ItembyDivisionPopup.cs:243~253 — 폭/정렬 그대로).
//   gap-resolve iter-1 A04: 종전 5컬럼은 Division_code·From Site Code·From Site·UOM·Pancake 5건이 누락돼 있었다.
//   From Site 는 이 팝업의 행 식별축이다(같은 ITEM_ID 가 from-site 별로 중복) — 없으면 어느 행인지 구분 불가.
//   DIVISION_NAME 은 AS-IS 도 hidden 이라 제외.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Division_code', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'FROM_SITE_CODE', colLblNm: 'From Site Code', colWth: 70, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'FROM_SITE', colLblNm: 'From Site', colWth: 150, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'ITEM_ID', colLblNm: 'Material', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'MODEL_ID', colLblNm: 'Model', colWth: 100, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'CELL_TYPE', colLblNm: 'Cell Type', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 100, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'ELECTRODE_TYPE', colLblNm: 'Electrode Type', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'ITEM_UOM', colLblNm: 'UOM', colWth: 60, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'UOM_CONVERT_IN_TACT_TIME', colLblNm: 'Pancake (m/cell)', colWth: 120, horzAlgnCd: 'R', scale: 5, visible: true, display: true },
];

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 콤보 행 -> 드롭다운 옵션(코드->명칭). 부모 Form(ShipmentRequestorPicForm toOptions)과 동일.
const toOptions = (rows: ComboResponse[] | undefined): { label: string; value: string }[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

export const RequestorPicItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell,
  mode,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const isModelMode = mode === 'MODEL';
  const divisionId = preSearchParams.divisionId ?? '';
  const toSite = preSearchParams.plantSite ?? ''; // AS-IS sPlantSiteCode (= p_to_site_id)

  // 검색 키워드 1칸 — 모드에 따라 Material(ITEM) 또는 Model(MODEL) 필터로 나간다(AS-IS BtnType).
  const [keyword, setKeyword] = useState('');
  // From Site 다중 체크값 (AS-IS clbFromSiteId, p_from_site_id). 빈 배열 = 무필터(전 from-site).
  const [fromSiteIds, setFromSiteIds] = useState<string[]>([]);
  const [filters, setFilters] = useState<ProcRequest<MENU_ID, SHEETS.POPUP> | undefined>(undefined);

  // Division(컨텍스트, 비활성 표시) + From Site(다중, cascade) 콤보.
  //   Division = MyDivision(부모 Form 과 동일 CMBO)로 코드->명칭 표시만(AS-IS clbDivisionId.Enabled=false).
  //   From Site = FromSiteByAssembly. AS-IS 는 (division, to-site)로 좁힌다(cs:206) —
  //     @segment5=division / @attribute1=to-site. to-site 가 다중(콤마)이면 등호가 전건 탈락시키므로
  //     단일값일 때만 전달하고 다중이면 division 기준 전체를 보인다(사용 가능한 후보 보존).
  const [divisions, fromSites] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      {
        comboId: COMBO.FROM_SITE,
        mnuId: MENU_ID,
        segment5: divisionId,
        attribute1: toSite.includes(',') ? '' : toSite,
      },
    ],
  });
  const divisionOptions = useMemo(() => toOptions(divisions), [divisions]);
  const fromSiteOptions = useMemo(() => toOptions(fromSites), [fromSites]);

  // 오픈 시 자동조회(AS-IS Form_Load → FindData cs:182). 검색 키워드·From Site 선택을 컨텍스트로 초기화하고
  //   filters 를 즉시 세팅해 useTabProcQuery 를 enable 한다. 닫히면 filters·선택을 비워 재오픈 시 스테일
  //   결과를 막는다(세 모드 모달이 상시 마운트라 내부 state 가 오픈 간 유지됨).
  useEffect(() => {
    if (!open) {
      setFilters(undefined);
      setFromSiteIds([]);
      return;
    }
    const kw = preSearchParams.itemId ?? preSearchParams.modelId ?? '';
    setKeyword(kw);
    setFromSiteIds([]);
    setFilters({
      divisionId,
      fromSiteId: '',
      toSiteId: toSite,
      itemId: isModelMode ? '' : kw,
      modelId: isModelMode ? kw : '',
    } as ProcRequest<MENU_ID, SHEETS.POPUP>);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.POPUP>({
    menuId: MENU_ID,
    sheetName: SHEETS.POPUP,
    tabId: 'SSP0025_ItemByDivisionModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as PopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t(LBL.NO, '_No')), ...POPUP_COLUMNS],
    [t]
  );

  const handleSearch = () => {
    // Search(FindButton 등가, AS-IS cs:260) — 컨텍스트(division/to-site) + From Site 체크값 + 키워드로
    //   filters 교체. 모드에 맞는 키에만 키워드를 실어 반대쪽이 AND 로 0건을 만들지 않게 한다.
    setFilters({
      divisionId,
      fromSiteId: fromSiteIds.join(','),
      toSiteId: toSite,
      itemId: isModelMode ? '' : keyword,
      modelId: isModelMode ? keyword : '',
    } as ProcRequest<MENU_ID, SHEETS.POPUP>);
  };

  // AS-IS FindData 는 조회 결과가 **정확히 1건**이면 클릭 없이 확정·닫는다(Popup cs:315~332).
  //   조회 1회당 한 번만 발동하도록 filters 참조로 잠근다(같은 결과 재렌더 시 반복 닫힘 방지).
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
            searchButtonLabel={t(LBL.SEARCH_MODAL, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                {/* Division — 컨텍스트 고정(AS-IS clbDivisionId.Enabled=false). 코드->명칭 표시만. */}
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.DIVISION, '_Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown disabled value={divisionId} options={divisionOptions} />
                    )}
                  />
                </Grid>
                {/* From Site — 다중선택(AS-IS clbFromSiteId, ALL 포함). p_from_site_id 로 전달. */}
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.FROM_SITE, '_From Site')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        allOption
                        useClearIcon
                        limitTags={1}
                        sortBy='label'
                        value={fromSiteIds.join(',')}
                        options={fromSiteOptions}
                        onChange={(_, picked) =>
                          setFromSiteIds(
                            String(picked ?? '')
                              .split(',')
                              .filter(v => v && v !== 'ALL')
                          )
                        }
                      />
                    )}
                  />
                </Grid>
                {/* 모드별 단일 검색칸 — AS-IS 는 BtnType 으로 반대쪽 칸을 숨긴다(Popup cs:214~221). */}
                <Grid size={4}>
                  <FormItem
                    label={isModelMode ? t(LBL.MODEL, '_Model') : t(LBL.MATERIAL, '_Material')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={keyword}
                        onChange={e => setKeyword(e.target.value)}
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
