import dayjs from 'dayjs';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LABEL } from '../shipment-allo-report.constants';
import { useShipmentAlloReportStore } from '../useShipmentAlloReportStore';

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
// dayjs customParseFormat 플러그인 미등록 환경 — 하이픈 형태로 변환 후 파싱(VersionModal 선례 동일 규약).
const ymToDayjs = (v: string) => (/^\d{6}$/.test(v) ? dayjs(`${v.slice(0, 4)}-${v.slice(4, 6)}-01`) : null);
const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str((r as Record<string, unknown>).NAME) || str(r.CODE), value: str(r.CODE) }));

type PopupField = 'itemId' | 'nickName' | null;

// AS-IS SCP0055_Shipment_Allo_Report — design 02 §5.1 SearchArea 매핑.
// Division/OperationGroup/BucketType/CellTypeGr = OnShown 강제 고정 + disabled(design 01 §2 #1-4) —
// 사용자가 바꿀 수 없다(표시만). 실질 조작 가능: Team/FromSite/FCST/PlanDate/GapDate/Period/Model/NickName.
export const ShipmentAlloReportForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const sc = useShipmentAlloReportStore(s => s.searchCondition);
  const set = useShipmentAlloReportStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentAlloReportStore(s => s.openSearchArea);

  const [popupField, setPopupField] = useState<PopupField>(null);

  // 콤보 6종 — 화면 고정값(disabled)이라도 데이터소스는 실제로 배선한다(design 02 §5 TO-BE 매핑).
  const [cellTypeGrRows, fromSiteRows, dateRows, bucketTypeRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.CELL_TYPE_GR },
      { comboId: COMBO.FROM_SITE },
      { comboId: COMBO.DATE_WEEKLY, divisionId: sc.divisionId },
      { comboId: COMBO.BUCKET_TYPE },
    ],
  });
  // Team(clbTeam) — `Data.UserTeamByDivision` 대응 TO-BE SQL_ID 미확정(design 02 §7 #2, 백로그 #4).
  // 등록 전까지 빈 옵션(확인 필요로 04_react-gap.md 에 기록).
  const teamOptions: Option[] = [];

  const cellTypeGrOptions = toOptions(cellTypeGrRows);
  const dateOptions = useMemo(() => toOptions(dateRows), [dateRows]);
  const bucketTypeOptions = toOptions(bucketTypeRows);

  // FromSite 클라 후처리 필터(design 02 §2.3/§4c 필수) — OperationGroup(고정 'A') + Division(고정 '40') 일치만.
  const fromSiteOptions = useMemo(() => {
    const rows = (fromSiteRows ?? []) as Record<string, unknown>[];
    return toOptions(
      rows.filter(r => str(r.OPERATION_GROUP) === sc.operationGroup && str(r.DIVISION_ID) === sc.divisionId) as ComboResponse[]
    );
  }, [fromSiteRows, sc.operationGroup, sc.divisionId]);

  // PlanDate 기본값 — 목록 첫 항목.
  const firstDate = dateOptions[0]?.value ?? '';
  useEffect(() => {
    if (firstDate && !sc.planDate) set({ planDate: firstDate });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstDate]);

  // PlanDate 변경 시 GapDate = 옵션 배열 index+1 항목으로 자동 동기화(값 매칭 아님, design 02 §3 §5).
  const handlePlanDateChange = (v: string) => {
    const idx = dateOptions.findIndex(o => o.value === v);
    const next = idx >= 0 ? dateOptions[idx + 1]?.value : undefined;
    set({ planDate: v, gapDate: next ?? sc.gapDate });
  };

  const single = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required?: boolean,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            value={value}
            options={options}
            disabled={disabled}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  const multi = (labelText: string, value: string, options: Option[], onPick: (codes: string) => void) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value}
            options={options}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  const popupField_ = (labelText: string, value: string, onPopup: () => void) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            className={commonStyles.popupSearchField}
            value={value}
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  iconComponent={<FunctionSearchIcon appearance='lined' onClick={onPopup} />}
                />
              ),
            }}
            onChange={() => undefined}
            onKeyDown={e => e.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00664', '_조회')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {single(t(LABEL.DIVISION, { defaultValue: 'Division' }), sc.divisionId, [
              { label: sc.divisionId, value: sc.divisionId },
            ], () => undefined, true, true)}
            {single(
              t(LABEL.OPERATION_GROUP, { defaultValue: 'Operation Group' }),
              sc.operationGroup,
              [{ label: sc.operationGroup, value: sc.operationGroup }],
              () => undefined,
              true,
              true
            )}
            {multi(t(LABEL.FROM_SITE, { defaultValue: 'From Site' }), sc.fromSite, fromSiteOptions, v => set({ fromSite: v }))}
            {multi(t(LABEL.TEAM, { defaultValue: 'Team' }), sc.team, teamOptions, v => set({ team: v }))}
            {single(t(LABEL.CELL_TYPE_GR, { defaultValue: 'Cell Type Gr' }), sc.cellTypeGr, cellTypeGrOptions, () => undefined, false, true)}
            {single(t(LABEL.BUCKET, { defaultValue: 'Bucket' }), sc.bucketType, bucketTypeOptions, () => undefined, false, true)}

            {single(t(LABEL.PLAN_DATE, { defaultValue: 'Plan Date' }), sc.planDate, dateOptions, handlePlanDateChange, true)}
            {single(t(LABEL.GAP_DATE, { defaultValue: 'Gap Date' }), sc.gapDate, dateOptions, v => set({ gapDate: v }), true)}

            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.PERIOD, { defaultValue: 'Period' })}
                labelAlign='right'
                render={() => (
                  <DatePickerCalendar
                    usecase='month'
                    size='small'
                    value={ymToDayjs(sc.fromYyyymm)}
                    onChange={d => set({ fromYyyymm: d ? d.format('YYYYMM') : '' })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label='~'
                labelAlign='right'
                render={() => (
                  <DatePickerCalendar
                    usecase='month'
                    size='small'
                    value={ymToDayjs(sc.toYyyymm)}
                    onChange={d => set({ toYyyymm: d ? d.format('YYYYMM') : '' })}
                  />
                )}
              />
            </Grid>

            {popupField_(t(LABEL.MODEL, { defaultValue: 'Model' }), sc.itemId, () => setPopupField('itemId'))}
            {popupField_(t(LABEL.NICK_NAME, { defaultValue: 'Nick Name' }), sc.nickName, () => setPopupField('nickName'))}

            <Grid size={3} className={commonStyles.customGrid}>
              <div className={commonStyles.customCheckbox}>
                <Checkbox
                  labelText={t(LABEL.FCST_PEGGING, { defaultValue: 'FCST Pegging' })}
                  checked={sc.fcstYn}
                  onChange={checked => set({ fcstYn: checked })}
                />
              </div>
            </Grid>
          </>
        }
      />

      {/* Model ID/Nick Name 팝업 — 동일 ItemByDivisionModal, 반환 필드 소비처만 다름(design 02 §4.6) */}
      <ItemByDivisionModal
        open={popupField === 'itemId'}
        modalClose={() => setPopupField(null)}
        setSelectedValue={items => set({ itemId: items })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={popupField === 'nickName'}
        modalClose={() => setPopupField(null)}
        setSelectedValue={(_items, _itemName, _itemClassName, _itemType, nickName) =>
          set({ nickName: nickName ?? '' })
        }
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
    </>
  );
};
