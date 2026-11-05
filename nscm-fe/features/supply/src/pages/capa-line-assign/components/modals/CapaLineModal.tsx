import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import type { DivisionType, SHEETS } from '../../capa-line-assign.constants';
import {
  ADMIN_SHEET_NAME,
  ALL,
  COLUMN,
  DIVISION_TYPE,
  FALLBACK_LABEL,
  LBL,
  MENU_ID,
} from '../../capa-line-assign.constants';
import type { ComboOption, ComboRow, GridRow } from '../../capa-line-assign.types';
import { useCapaLineAssignStore } from '../../useCapaLineAssignStore';
import {
  distinctByCode,
  inSet,
  pickedSet,
  sortLineCodes,
  sortMasterCodes,
} from '../../utils/capaLineAssign.cascade';
import { collapseStaticLargeTier } from '../../utils/capaLineAssignColumns';

import styles from './CapaLineAssignModals.module.scss';

interface Props {
  open: boolean;
  /** `divisionType` 파생 — SP 가 갈린다(`..._GET_CAPA_LINE_{ASSEMBLY|ELTR}`). */
  sheet: SHEETS.LINE_ASSEMBLY | SHEETS.LINE_ELTR;
  /**
   * 조회조건 Division Type 표시용(Electrode/Cell/Module-Pack) — AS-IS `rgrpDivisionType` 은
   * 보이되 `Enabled=false`(선택 불가)다. `sheet` 2분류로는 Cell·Module-Pack 을 못 가르므로 부모가
   * 원값(0/1/2)을 그대로 넘긴다.
   */
  divisionType: DivisionType;
  tabId: string;
  /** 팝업 Division 초기값 — 부모 조회 Division. AS-IS `cboDivision` 은 이 값으로 세팅 후 편집 가능. */
  divisionId: string;
  /** Division 콤보 후보 — 부모가 넘기는 Division 목록(사용자가 팝업 안에서 바꿀 수 있다). */
  divisionOptions: ComboOption[];
  /** 마스터 4축 cascade 원천 — AS-IS 가 부모에서 넘기던 DataTable 과 동일(메인 화면과 같은 출처). */
  masterRows: ComboRow[];
  onClose: () => void;
  onConfirm: (rows: GridRow[]) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const isChecked = (row: GridRow): boolean => row[COLUMN.CHK] === true || row[COLUMN.CHK] === 'Y';

/**
 * `CString.GetCheckedListValue` 등가 — `'ALL'`/선택 0건이면 현재 후보 전체 CODE CSV(미선택=전체).
 * AS-IS P03 getPlant/getFactory/getLine 의 `if(res=="") res = 전체 CODE` 분기와 같다(cs:441-531).
 */
const toCsv = (selected: string[], candidates: ComboOption[]): string => {
  const picked = selected.filter(code => code && code !== ALL);
  if (picked.length > 0 && !selected.includes(ALL)) return picked.join(',');
  return candidates.map(option => option.value).join(',');
};

/**
 * P03 CAPA Line 팝업 (AS-IS `SCP0104_CAPA_Line`, 시트 `LINE`).
 *
 * 부모 화면이 DataTable 8개를 주입하던 AS-IS 와 달리 팝업이 자체 조회한다(design 03 §5.7).
 * 선택 다건 → 부모 Assign 그리드에 행 추가. **중복키(Division+Site+Company+Plant+Factory+Line
 * 6키) 행은 부모가 건너뛴다**(§3.5.1) — 이 컴포넌트는 선택 행을 그대로 돌려준다.
 *
 * 다중선택은 AS-IS 를 따라 데이터 `CHK` 컬럼(헤더 캡션 "V")으로 한다 — AS-IS `AddCheckColumn("V",CHK)`
 * + `LockRange2`(CHK 만 편집)와 등가다. `CHK` 외 전 셀은 읽기전용(`ReadOnlySheetList`, E-8) —
 * `isReadOnly` 로 그리드 전체를 잠그면 CHK 체크까지 막히므로, `CHK` 만 편집 가능하게 둔다(`CHK` 의
 * 편집 허용은 컬럼 메타 `INPUT_TP_CD` 가 담당). 선택 행은 `CHK === true|'Y'` 로 수집한다(`isChecked`).
 * 수정상태 rowHeader 컬럼은 저장이 없어 무의미하므로 `hideStatusColumn` 으로 숨긴다.
 *
 * 조회조건(AS-IS `SCP0104_CAPA_Line` 폼) — Division(부모값 초기화·편집 가능) + Site·Plant·Building·Line
 * 4축 다중선택 cascade 콤보다. 상위 축을 바꾸면 하위 축 후보가 재계산되고(팝업 로컬 cascade) 선택은
 * `ALL` 로 리셋된다. 미선택(ALL) = 현재 후보 전체 CODE(AS-IS getPlant/getFactory/getLine 폴백).
 * Building(Factory) 은 Site 가 아니라 **Plant** 에 종속된다(`GetFilterFactory`, V-10).
 *
 * 오픈 시 자동조회한다(AS-IS Form_Load → SetDefConditions → `_FindData`, cs:437) — 부모 조건을
 * 물려받아 즉시 질의. 재오픈 시 직전 검색조건·결과가 그대로 복원된다.
 */
export const CapaLineModal = ({
  open,
  sheet,
  divisionType,
  tabId,
  divisionId,
  divisionOptions,
  masterRows,
  onClose,
  onConfirm,
}: Props) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const staticColumns = useCapaLineAssignStore(s => s.staticColumns);
  // 정적 컬럼 1단은 AS-IS 가 숨겨 2단이다(collapseStaticLargeTier) — Assign/SOP 그리드와 동일.
  //   `LINE` 시트도 Site/Plant/Building/Line 메타가 LARGE<>SMALL 이라(DB 실측) 축소 없으면 상위
  //   그룹 헤더가 뜬다. 팝업은 개인화·편집모드가 없어 축소만 적용한다.
  const columns = useMemo(
    () => collapseStaticLargeTier(staticColumns[sheet]),
    [staticColumns, sheet]
  );

  // Division — AS-IS `cboDivision` 은 부모값으로 세팅하되 **편집 가능**하다(cs:409 세팅만, 비활성 아님).
  //   변경 시 `cboDivision_SelectedIndexChanged`(cs:856)가 `RefreshAll` 로 하위 4축을 다시 채운다.
  //   팝업 로컬 state 로 두고 부모값은 오픈 시 초기값으로만 쓴다.
  const [localDivisionId, setLocalDivisionId] = useState(divisionId);

  // 팝업 로컬 조회조건 — 다중선택 4축. 기본 `ALL`(AS-IS UsrCheckedList 기본 전체).
  const [siteIds, setSiteIds] = useState<string[]>([ALL]);
  const [plantIds, setPlantIds] = useState<string[]>([ALL]);
  const [factoryIds, setFactoryIds] = useState<string[]>([ALL]);
  const [lineIds, setLineIds] = useState<string[]>([ALL]);
  type LineFilters = ProcRequest<MENU_ID, SHEETS.LINE_ASSEMBLY>;
  const [applied, setApplied] = useState<LineFilters | null>(null);

  // ── 4축 cascade 후보 — 메인 화면 useCapaLineCascade 와 동일 로직(같은 순수 함수 재사용) ──────
  //   Division 은 팝업 로컬 선택값(`localDivisionId`)으로 거른다(AS-IS 는 편집 가능).
  const inDivision = (row: ComboRow): boolean =>
    !localDivisionId || str(row.DIVISION_ID) === localDivisionId;

  const siteSet = useMemo(() => pickedSet(siteIds), [siteIds]);
  const plantSet = useMemo(() => pickedSet(plantIds), [plantIds]);
  const factorySet = useMemo(() => pickedSet(factoryIds), [factoryIds]);

  const siteOptions = useMemo<ComboOption[]>(
    () => sortMasterCodes(distinctByCode(masterRows, 'SITE_ID', 'SITE_NAME', inDivision)),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, localDivisionId]
  );

  const plantOptions = useMemo<ComboOption[]>(
    () =>
      sortMasterCodes(
        distinctByCode(
          masterRows,
          'PLANT_ID',
          'PLANT_NAME',
          row => inDivision(row) && inSet(siteSet, str(row.SITE_ID))
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, localDivisionId, siteSet]
  );

  // 주의: Building 은 Site 가 아니라 Plant 에 종속된다(`GetFilterFactory`, V-10).
  const factoryOptions = useMemo<ComboOption[]>(
    () =>
      sortMasterCodes(
        distinctByCode(
          masterRows,
          'FACTORY_ID',
          'FACTORY_NAME',
          row => inDivision(row) && inSet(plantSet, str(row.PLANT_ID))
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, localDivisionId, plantSet]
  );

  const lineOptions = useMemo<ComboOption[]>(
    () =>
      sortLineCodes(
        sortMasterCodes(
          distinctByCode(
            masterRows,
            'LINE_ID',
            'LINE_NAME',
            row =>
              inDivision(row) &&
              inSet(plantSet, str(row.PLANT_ID)) &&
              inSet(factorySet, str(row.FACTORY_ID))
          )
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, localDivisionId, plantSet, factorySet]
  );

  const buildFilters = (): LineFilters => ({
    p_division_id: localDivisionId,
    // 미선택(ALL) = 현재 후보 전체 CODE CSV(AS-IS getPlant/getFactory/getLine 폴백, cs:441-531).
    p_site_id: toCsv(siteIds, siteOptions),
    p_plant_id: toCsv(plantIds, plantOptions),
    p_factory_id: toCsv(factoryIds, factoryOptions),
    p_line_id: toCsv(lineIds, lineOptions),
    p_program_id: MENU_ID,
    p_sheet_name: ADMIN_SHEET_NAME[sheet],
    debug_mode: 'F',
  });

  const filters = useMemo(() => {
    if (!open) return undefined;
    return applied ?? undefined;
  }, [open, applied]);

  const { data, isLoading, isFetching } = useTabProcQuery<
    MENU_ID,
    SHEETS.LINE_ASSEMBLY | SHEETS.LINE_ELTR
  >({
    menuId: MENU_ID,
    sheetName: sheet,
    tabId: `${tabId}-capa-line`,
    filters,
    enabled: open && !!filters,
  });

  // 조회 SP(`..._GET_CAPA_LINE_*`)는 선택용 `CHK` 컬럼을 반환하지 않는다(업무 컬럼만). 메타에
  //   `CHK`(FPCheckBox)가 선언돼 있어 그리드는 체크박스 컬럼을 그리는데, 값이 undefined 면 Wijmo
  //   가 인디터미네이트("-"=반쯤 체크된 파란 표시)로 렌더한다 — AS-IS `AddCheckColumn` 이 기본
  //   false 로 초기화하듯 각 행에 `CHK:false` 를 주입해 명확히 미체크 상태로 띄운다.
  const rows = useMemo<GridRow[]>(
    () =>
      ((data?.o_rc1 ?? []) as unknown as GridRow[]).map(row => ({ [COLUMN.CHK]: false, ...row })),
    [data]
  );

  const handleSearch = () => setApplied(buildFilters());

  // 부모 Division 이 바뀌면 팝업 기본 Division 과 하위 선택을 그 값으로 되맞춘다(AS-IS 는 매 오픈
  //   `SetDefConditions` 로 부모값 상속 — 팝업 로컬 편집분은 부모 변경 시 무효화하는 것이 안전하다).
  useEffect(() => {
    setLocalDivisionId(divisionId);
    setSiteIds([ALL]);
    setPlantIds([ALL]);
    setFactoryIds([ALL]);
    setLineIds([ALL]);
  }, [divisionId]);

  // 오픈 시 자동조회 — AS-IS Form_Load → `_FindData`(cs:437). 아직 조회한 적 없을 때만 한 번.
  //   재오픈 시 `applied` 가 남아 있으면 직전 조건·결과를 그대로 복원한다.
  useEffect(() => {
    if (!open || applied) return;
    setApplied(buildFilters());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const handleSubmit = () => {
    const checked = rows.filter(isChecked);
    if (checked.length === 0) return;
    onConfirm(checked);
    onClose();
  };

  // Division — AS-IS `cboDivision` 은 부모값으로 세팅하되 편집 가능(SetDefConditions cs:409, 비활성 아님).
  //   변경 시 AS-IS `cboDivision_SelectedIndexChanged`→`RefreshAll` 처럼 하위 4축을 `[ALL]` 로 리셋한다.
  const divisionField = (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(LBL.DIVISION, { defaultValue: 'Division' })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            value={localDivisionId}
            options={divisionOptions}
            onChange={(_, picked) => {
              setLocalDivisionId(String(picked ?? ''));
              setSiteIds([ALL]);
              setPlantIds([ALL]);
              setFactoryIds([ALL]);
              setLineIds([ALL]);
            }}
          />
        )}
      />
    </Grid>
  );

  // Division Type(Operation group) — AS-IS `rgrpDivisionType`(Electrode/Cell/Module-Pack)은 보이되
  //   선택 불가(Enabled=false). 라벨은 메인 화면과 동일하게 LBL00027 'Operation group'(DB 실측).
  //   옵션 매핑도 메인 divisionTypeOptions 와 동일 — `Module/Pack` 은 등가 LBL 미등록 → 영문 defaultValue.
  const divisionTypeOptions: ComboOption[] = [
    { label: t(LBL.ELECTRODE, { defaultValue: 'Electrode' }), value: String(DIVISION_TYPE.ELTR) },
    { label: t(LBL.CELL, { defaultValue: 'Cell' }), value: String(DIVISION_TYPE.CELL) },
    { label: FALLBACK_LABEL.MODULE_PACK, value: String(DIVISION_TYPE.MODULE_PACK) },
  ];
  const divisionTypeField = (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(LBL.OPERATION_GROUP, { defaultValue: 'Operation group' })}
        labelAlign='right'
        render={() => (
          <CustomDropdown disabled value={String(divisionType)} options={divisionTypeOptions} />
        )}
      />
    </Grid>
  );

  // 다중선택 cascade 축 — 상위 변경 시 하위를 `[ALL]` 로 리셋(팝업 로컬 cascade, AS-IS Refresh* 등가).
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: ComboOption[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <CustomDialog
      size={1000}
      // 창 높이: 기본 50vh(×scale 1.5=75vh≈808px)는 그리드 행수 대비 과도하게 높다. 고정값으로
      //   낮춘다(사용자 지시 2026-10-21).
      height={500}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>CAPA Line Search</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                {divisionField}
                {divisionTypeField}
                {multiField(LBL.SITE, 'Site', siteIds, siteOptions, next => {
                  // Site 변경 → Plant/Building/Line 후보 재계산 → 선택 ALL 리셋(AS-IS RefreshPlant/Factory/Line).
                  setSiteIds(next);
                  setPlantIds([ALL]);
                  setFactoryIds([ALL]);
                  setLineIds([ALL]);
                })}
                {multiField(LBL.PLANT, 'Plant', plantIds, plantOptions, next => {
                  // Plant 변경 → Building/Line 리셋(AS-IS RefreshFactory/Line).
                  setPlantIds(next);
                  setFactoryIds([ALL]);
                  setLineIds([ALL]);
                })}
                {multiField(LBL.BUILDING, 'Building', factoryIds, factoryOptions, next => {
                  // Building 변경 → Line 리셋(AS-IS RefreshLine).
                  setFactoryIds(next);
                  setLineIds([ALL]);
                })}
                {multiField(LBL.LINE, 'Line', lineIds, lineOptions, setLineIds)}
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={isLoading || isFetching}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                hideStatusColumn
                itemsSource={rows as unknown as WijmoRowItem[]}
                staticColumns={columns}
                sheetName={ADMIN_SHEET_NAME[sheet]}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
