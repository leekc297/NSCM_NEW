import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import {
  CustomDialog,
  CustomDropdown,
  DataGrid,
  ResultArea,
  SearchArea,
} from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';

import type { DivisionType } from '../../capa-line-assign.constants';
import {
  ADMIN_SHEET_NAME,
  ALL,
  COLUMN,
  DIVISION_TYPE,
  FALLBACK_LABEL,
  LBL,
  MENU_ID,
  SHEETS,
} from '../../capa-line-assign.constants';
import type { ComboOption, GridRow } from '../../capa-line-assign.types';
import {
  useSopModelCascade,
  type SopModelSelection,
} from '../../hooks/useSopModelCascade';
import { useCapaLineAssignStore } from '../../useCapaLineAssignStore';
import { collapseStaticLargeTier } from '../../utils/capaLineAssignColumns';

import styles from './CapaLineAssignModals.module.scss';

interface Props {
  open: boolean;
  sheet: SHEETS.SOP_MODEL_ASSEMBLY | SHEETS.SOP_MODEL_ELTR;
  tabId: string;
  divisionId: string;
  verId: string;
  verSeq: string;
  onClose: () => void;
  onConfirm: (rows: GridRow[]) => void;
}

const isChecked = (row: GridRow): boolean => row[COLUMN.CHK] === true || row[COLUMN.CHK] === 'Y';

/** 부모가 넘기는 초기 시트(= 메인 Division Type)로부터 팝업 자체 Division Type 초기값을 역산. */
const divisionTypeOfSheet = (sheet: Props['sheet']): DivisionType =>
  sheet === SHEETS.SOP_MODEL_ELTR ? DIVISION_TYPE.ELTR : DIVISION_TYPE.CELL;

/** `'ALL'`/빈 선택 → 전 후보 CSV(폴백) 또는 빈 문자열. 메인 store `toCsv` 와 동일 규약(§4.3). */
const toCsv = (selected: string[], candidates: string[], emptyFallback: boolean): string => {
  const picked = selected.filter(code => code && code !== ALL);
  if (selected.includes(ALL)) return candidates.join(',');
  if (picked.length > 0) return picked.join(',');
  return emptyFallback ? candidates.join(',') : '';
};

/**
 * P02 CAPA Line Assign Model 팝업 (AS-IS `SCP0104_CAPA_Line_Assign_Model`,
 * 시트 `SOP_MODEL_ASSEMBLY` | `SOP_MODEL_ELTR` 19컬럼).
 *
 * 선택 다건 → SOP 그리드 행 추가. 중복키는 8키(Division+Site+Company+Plant+Factory+Line+
 * Operation+ElectrodeType)로 부모가 판정한다(§3.5.1).
 *
 * 주의(§6-5, U-9 = AS-IS 원문 유지): SP 가 `@p_version`/`@p_version_seq` 를 **무시**하고 내부
 * `PROG_STAT='0'`(Current) MAX 버전을 쓴다. 조회조건이 Cutoff 버전이면 팝업 목록이 Current 기준이
 * 되는데, 이는 AS-IS 사양이므로 그대로 재현한다(파라미터는 계약대로 실어 보낸다).
 */
export const CapaLineAssignModelModal = ({
  open,
  sheet,
  tabId,
  divisionId,
  verId,
  verSeq,
  onClose,
  onConfirm,
}: Props) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const staticColumns = useCapaLineAssignStore(s => s.staticColumns);

  // ── 팝업 로컬 조회조건 상태 (AS-IS 1:1 복원) ──────────────────────────────────────────
  //   AS-IS `SCP0104_CAPA_Line_Assign_Model` 은 Division·Site·Plant·Building·Line·Operation·
  //   Line Type 7축을 편집 가능한 조회조건으로 두고(..._Model.cs:548-637), **Division Type
  //   (`rgrpDivisionType`)만 `Enabled=false` 로 readonly** 다(..._Model.Designer.cs:787 —
  //   런타임 재활성 코드 없음). Division Type 은 부모(메인 화면)가 생성자로 고정 전달하는 값이라
  //   팝업에서 모드(시트)를 바꿀 수 없다. 따라서 `divisionType`/`effectiveSheet` 는 prop `sheet`
  //   에서 파생한 **고정값**이고, 팝업은 Division + 6축만 로컬 state 로 cascade 한다.
  //
  //   메인 store(`useCapaLineAssignStore.searchParams`)를 공유하면 팝업 선택이 메인 그리드 조회에
  //   새므로(강결합), 팝업은 자기 로컬 state 로만 cascade 를 돌린다. SP 가 version 을 무시하므로
  //   (§6-5, U-9) Version 계열 조건은 두지 않고 파라미터만 계약대로 싣는다.
  const divisionType = divisionTypeOfSheet(sheet);
  const effectiveSheet = sheet;
  const isEltr = divisionType === DIVISION_TYPE.ELTR;

  type SopModelFilters = ProcRequest<MENU_ID, SHEETS.SOP_MODEL_ASSEMBLY>;
  const [applied, setApplied] = useState<SopModelFilters | null>(null);

  const [sel, setSel] = useState<SopModelSelection>(() => ({
    divisionId,
    siteIds: [ALL],
    plantIds: [ALL],
    factoryIds: [ALL],
    lineIds: [ALL],
    operationIds: isEltr ? [] : [ALL],
    electrodeTypes: isEltr ? [] : [ALL],
  }));

  // 재오픈 시 부모 값으로 재시드 — 메인에서 Division/모드를 바꾼 뒤 다시 열면 그 값에서 시작한다.
  useEffect(() => {
    if (!open) return;
    const hiddenAxis = divisionTypeOfSheet(sheet) === DIVISION_TYPE.ELTR ? [] : [ALL];
    setSel({
      divisionId,
      siteIds: [ALL],
      plantIds: [ALL],
      factoryIds: [ALL],
      lineIds: [ALL],
      operationIds: hiddenAxis,
      electrodeTypes: hiddenAxis,
    });
    setApplied(null);
  }, [open, sheet, divisionId]);

  const cascade = useSopModelCascade(sel, divisionType);

  // 정적 컬럼 1단은 AS-IS 가 숨겨 2단이다(collapseStaticLargeTier) — Assign/SOP 그리드와 동일.
  //   Site/Plant/Building/Line/Operation 메타가 LARGE<>SMALL 이라(DB 실측) 축소 없으면 상위 그룹
  //   헤더가 뜬다. 팝업은 개인화·편집모드가 없어 축소만 적용한다.
  const columns = useMemo(
    () => collapseStaticLargeTier(staticColumns[effectiveSheet]),
    [staticColumns, effectiveSheet]
  );

  const buildFilters = (): SopModelFilters => ({
    p_version: verId,
    p_version_seq: verSeq,
    p_division_id: sel.divisionId,
    // AS-IS getter 폴백(§4.3): 빈 선택 시 Plant/Building/Line/Operation 은 전 후보 CSV, Site/
    //   Line Type 은 빈 문자열(..._Model.cs:198-399, `GetCheckedListValue`). 메인 store 와 동일.
    p_site_id: toCsv(sel.siteIds, cascade.candidates.siteIds, false),
    p_plant_id: toCsv(sel.plantIds, cascade.candidates.plantIds, true),
    p_factory_id: toCsv(sel.factoryIds, cascade.candidates.factoryIds, true),
    p_line_id: toCsv(sel.lineIds, cascade.candidates.lineIds, true),
    p_operation_id: toCsv(sel.operationIds, cascade.candidates.operationIds, true),
    p_electrode_type: toCsv(sel.electrodeTypes, cascade.candidates.electrodeTypes, false),
    p_valid_flag: '',
    p_program_id: MENU_ID,
    p_sheet_name: ADMIN_SHEET_NAME[effectiveSheet],
    debug_mode: 'F',
  });

  const filters = useMemo(() => {
    if (!open) return undefined;
    // AS-IS 파리티(#7): 오픈만으로는 조회하지 않는다 — Search(FindButton) 를 눌러 `applied` 가
    // 세팅될 때만 조회한다. AS-IS `SCP0104_CAPA_Line_Assign_Model` 은 Form Load 자동조회가 없고
    // 툴바 Search 로만 질의한다.
    return applied ?? undefined;
  }, [open, applied]);

  const { data, isLoading, isFetching } = useTabProcQuery<
    MENU_ID,
    SHEETS.SOP_MODEL_ASSEMBLY | SHEETS.SOP_MODEL_ELTR
  >({
    menuId: MENU_ID,
    sheetName: effectiveSheet,
    tabId: `${tabId}-capa-sop-model`,
    filters,
    enabled: open && !!filters,
  });

  // 조회 SP 는 선택용 `CHK` 컬럼을 반환하지 않는다(업무 컬럼만). 메타에 `CHK`(FPCheckBox)가
  //   선언돼 있어 값이 undefined 면 Wijmo 가 인디터미네이트("-")로 렌더하므로, 각 행에 `CHK:false`
  //   를 주입해 미체크로 띄운다(P03 CapaLineModal 과 동일 — AS-IS `AddCheckColumn` 기본 false).
  const rows = useMemo<GridRow[]>(
    () =>
      ((data?.o_rc1 ?? []) as unknown as GridRow[]).map(row => ({ [COLUMN.CHK]: false, ...row })),
    [data]
  );

  const handleSearch = () => setApplied(buildFilters());

  const handleSubmit = () => {
    const checked = rows.filter(isChecked);
    if (checked.length === 0) return;
    onConfirm(checked);
    onClose();
  };

  // S05 Division Type(Operation group) — **readonly 표시 전용**. AS-IS `rgrpDivisionType.Enabled=
  //   false`(..._Model.Designer.cs:787) 라 사용자가 못 바꾼다. 메인이 고정 전달한 모드를 보여주기만
  //   한다. AS-IS RadioGroup 3택을 드롭다운으로 매핑(메인 Form 과 동일).
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t(LBL.ELECTRODE, '_Electrode'), value: String(DIVISION_TYPE.ELTR) },
      { label: t(LBL.CELL, '_Cell'), value: String(DIVISION_TYPE.CELL) },
      { label: FALLBACK_LABEL.MODULE_PACK, value: String(DIVISION_TYPE.MODULE_PACK) },
    ],
    [t]
  );

  // D01 Division 변경 = AS-IS `cboDivision_SelectedIndexChanged`→`RefreshAll`(6축 재생성). 하위 초기화.
  const changeDivision = (code: string) =>
    setSel(prev => ({
      ...prev,
      divisionId: code,
      siteIds: [ALL],
      plantIds: [ALL],
      factoryIds: [ALL],
      lineIds: [ALL],
      operationIds: isEltr ? [] : [ALL],
      electrodeTypes: isEltr ? [] : [ALL],
    }));

  const singleField = (
    labelCode: string,
    labelEn: string,
    value: string,
    options: ComboOption[],
    onPick?: (code: string) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            // onPick 없으면 readonly(AS-IS Enabled=false) — Division Type 전용.
            disabled={!onPick}
            value={value}
            options={options}
            onChange={(_, picked) => onPick?.(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  // 다중선택 — 기본 `ALL`. `'ALL'` sentinel 은 서버로 나가지 않는다(buildFilters `toCsv` 가 펼친다).
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
          <h2 className='headerTitle'>CAPA Line Assign Search</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                {/* AS-IS 1:1 — Division 은 단일선택(편집 가능), Division Type(Operation group) 은
                    readonly 표시(Enabled=false), Site/Plant/Building/Line/Operation/Line Type 은
                    다중선택 체크리스트. Operation·Line Type 은 ELTR 모드에서 숨는다(..._Model.cs:2044
                    `_sheet_idx` 분기와 동일 노출 규칙 — Electrode 는 Operation/Line Type 비노출). */}
                {/* S01 Division — 편집 가능(`cboDivision` Enabled 미설정 = true). */}
                {singleField(
                  LBL.DIVISION,
                  'Division',
                  sel.divisionId,
                  cascade.divisionOptions,
                  changeDivision
                )}
                {/* S05 Division Type — readonly(`rgrpDivisionType.Enabled=false`). 메인 고정 모드
                    표시. onPick 생략 = disabled. */}
                {singleField(
                  LBL.OPERATION_GROUP,
                  'Operation group',
                  String(divisionType),
                  divisionTypeOptions
                )}
                {/* S06 Site */}
                {multiField(LBL.SITE, 'Site', sel.siteIds, cascade.siteOptions, codes =>
                  setSel(prev => ({
                    ...prev,
                    siteIds: codes,
                    plantIds: [ALL],
                    factoryIds: [ALL],
                    lineIds: [ALL],
                  }))
                )}
                {/* S07 Plant */}
                {multiField(LBL.PLANT, 'Plant', sel.plantIds, cascade.plantOptions, codes =>
                  setSel(prev => ({ ...prev, plantIds: codes, factoryIds: [ALL], lineIds: [ALL] }))
                )}
                {/* S08 Building(컨트롤명 Factory) — Plant 에 종속(V-10). */}
                {multiField(LBL.BUILDING, 'Building', sel.factoryIds, cascade.factoryOptions, codes =>
                  setSel(prev => ({ ...prev, factoryIds: codes, lineIds: [ALL] }))
                )}
                {/* S09 Line */}
                {multiField(LBL.LINE, 'Line', sel.lineIds, cascade.lineOptions, codes =>
                  setSel(prev => ({ ...prev, lineIds: codes }))
                )}
                {/* S10 Operation — Cell/Module-Pack 에서만 노출. Line 과 무관(함정 1). */}
                {!isEltr &&
                  multiField(
                    LBL.OPERATION,
                    'Operation',
                    sel.operationIds,
                    cascade.operationOptions,
                    codes =>
                      setSel(prev => ({ ...prev, operationIds: codes, electrodeTypes: [ALL] }))
                  )}
                {/* S11 Line Type — Cell/Module-Pack 에서만 노출. Operation 에 종속(E08). */}
                {!isEltr &&
                  multiField(
                    LBL.LINE_TYPE,
                    'Line Type',
                    sel.electrodeTypes,
                    cascade.electrodeTypeOptions,
                    codes => setSel(prev => ({ ...prev, electrodeTypes: codes }))
                  )}
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
                sheetName={ADMIN_SHEET_NAME[effectiveSheet]}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
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
