// ====================================================================================
// SearchFields Catalog — 조회조건 표준 카탈로그 (2026-06-03 사용자 요구)
//
// "조회조건의 경우에는 항목별로 rule 로 관리해주세요. 사이즈, 데이터 추출경로를 등록해서
//  등록된 조회항목은 그대로 사용하고, 신규인 경우에는 생성 후 관리항목으로 추가해주세요."
//
// 사용 예 (신규 화면):
//   import {
//     DivisionField, TeamField, EndCustomerField, SalesSiteField, BizTypeField,
//     PlantSiteField, ProjectField, ItemField, OwnerField,
//     PeriodField, BucketField, VersionField, SearchOverRangeField,
//   } from '@master/searchFields';
//
//   <SearchArea conditions={<>
//     <DivisionField value={sc.divisionId} onChange={v => set({ divisionId: v })} />
//     <TeamField value={sc.deptIds} onChange={v => set({ deptIds: v })} division={sc.divisionId} />
//     ...
//   </>} />
//
// 각 컴포넌트는 자동 적용:
//   - Grid size (표준 너비)
//   - FormItem (label + labelAlign + required + render)
//   - i18n key (LBL00501~514 — DMF0020 영역 100-block)
//   - lookup combo (SCM_ADM_CMBO_SQL_M 등록 SQL_ID)
//   - popup modal + preSearchParams 6필드 'ALL' 자동 default
//   - DivisionField 변경 시 종속 필드 reset 처리는 호출 측에서 useEffect 로
// ====================================================================================

import dayjs, { type Dayjs } from 'dayjs';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';

import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { ItemByDivisionModal } from '../itemByDivisionModal/ItemByDivisionModal';
import { OwnerByDivisionModal } from '../ownerByDivisionModal/OwnerByDivisionModal';
import { ProjectByDivisionModal } from '../projectByDivisionModal/ProjectByDivisionModal';

// ====================================================================================
// 표준 props
// ====================================================================================
interface SingleFieldProps {
  value: string;
  onChange: (v: string) => void;
}
interface MultiFieldProps {
  value: string[];
  onChange: (v: string[]) => void;
  division?: string;       // 종속 필터용
}
interface DependentMultiFieldProps extends MultiFieldProps {
  deptIds?: string[];
  endCustomers?: string[];
}
interface PopupFieldProps {
  value: string[];
  onChange: (v: string[]) => void;
  division: string;
  deptIds?: string[];
  endCustomers?: string[];
  scmSiteIds?: string[];
  projectCodes?: string[];
}

// i18n helper — LBL+5자리 표준 (KO.json 미등록 시 fallback 영문)
const useL = () => {
  const { t } = useTranslation();
  return (code: string, fallbackEn: string) => t(code, { defaultValue: fallbackEn });
};

// CustomDropdown options helper — NUMBER→String + DIVISION_ID 필터
const toOptions = (rows: Array<Record<string, unknown>> | undefined, divisionId?: string) => {
  const arr = rows ?? [];
  return [...new Map(
    arr.filter(r => !divisionId || !r.DIVISION_ID || r.DIVISION_ID === divisionId)
       .map(r => [`${r.DIVISION_ID ?? ''}|${r.CODE ?? ''}`, r]),
  ).values()].map(r => ({ label: String(r.NAME ?? r.CODE ?? ''), value: String(r.CODE ?? '') }));
};

// 'ALL' 기본값 helper — P_COM0006/P_COM0008 SP WHERE 절 `(P_X='ALL' OR ...)` 패턴 대응
const orAll = (arr?: string[]) => (arr && arr.length > 0 ? arr.join(',') : 'ALL');

// ====================================================================================
// 1. DivisionField (필수, size=4, combo=MyDivision)
//    AS-IS clbDivisions / DataService SetChangeControl("MyDivision")
// ====================================================================================
export const DivisionField = ({ value, onChange }: SingleFieldProps) => {
  const L = useL();
  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00501', 'Div')} labelAlign='right' required render={() => (
        <CustomDropdown
          value={value}
          options={(divisions ?? []).map(item => ({ label: String(item.NAME), value: String(item.CODE) }))}
          onChange={(_, option) => onChange(String(option))}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 2. TeamField (size=4, combo=TeambyDivision)
// ====================================================================================
export const TeamField = ({ value, onChange, division }: MultiFieldProps) => {
  const L = useL();
  const [teams] = useTabComboQueries({ filters: ['TeambyDivision'] });
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00502', 'Team')} labelAlign='right' render={() => (
        <CustomDropdown
          multiple allOption useClearIcon limitTags={1}
          value={value.join(',')}
          options={toOptions(teams as never, division)}
          onChange={(_, options) => onChange(String(options ?? '').split(',').filter(Boolean))}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 3. EndCustomerField (size=4, combo=EndCustomer)
// ====================================================================================
export const EndCustomerField = ({ value, onChange, division }: MultiFieldProps) => {
  const L = useL();
  const [endCustomers] = useTabComboQueries({ filters: ['EndCustomer'] });
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00503', 'End Customer')} labelAlign='right' render={() => (
        <CustomDropdown
          multiple allOption useClearIcon limitTags={1}
          value={value.join(',')}
          options={toOptions(endCustomers as never, division)}
          onChange={(_, options) => onChange(String(options ?? '').split(',').filter(Boolean))}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 4. SalesSiteField (size=4, combo=SalesSite)
// ====================================================================================
export const SalesSiteField = ({ value, onChange, division }: MultiFieldProps) => {
  const L = useL();
  const [salesSites] = useTabComboQueries({ filters: ['SalesSite'] });
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00506', 'Sales Site')} labelAlign='right' render={() => (
        <CustomDropdown
          multiple allOption useClearIcon limitTags={1}
          value={value.join(',')}
          options={toOptions(salesSites as never, division)}
          onChange={(_, options) => onChange(String(options ?? '').split(',').filter(Boolean))}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 5. PlantSiteField (size=4, combo=SalesSite 재사용 — Plant Site combo BE 미등록)
// ====================================================================================
export const PlantSiteField = ({ value, onChange, division }: MultiFieldProps) => {
  const L = useL();
  const [salesSites] = useTabComboQueries({ filters: ['SalesSite'] });
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00509', 'Plant Site')} labelAlign='right' render={() => (
        <CustomDropdown
          multiple allOption useClearIcon limitTags={1}
          value={value.join(',')}
          options={toOptions(salesSites as never, division)}
          onChange={(_, options) => onChange(String(options ?? '').split(',').filter(Boolean))}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 6. BizTypeField (size=4, combo=BizType — SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='BIZ_TYPE')
// ====================================================================================
export const BizTypeField = ({ value, onChange }: Omit<MultiFieldProps, 'division'>) => {
  const L = useL();
  const [bizTypes] = useTabComboQueries({ filters: ['BizType'] });
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00504', 'Biz.Type')} labelAlign='right' render={() => (
        <CustomDropdown
          multiple allOption useClearIcon limitTags={1}
          value={value.join(',')}
          options={toOptions(bizTypes as never)}
          onChange={(_, options) => onChange(String(options ?? '').split(',').filter(Boolean))}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 7. ProjectField (size=4, popup=ProjectByDivisionModal, 6필드 'ALL' 자동)
// ====================================================================================
export const ProjectField = (props: PopupFieldProps) => {
  const L = useL();
  const [open, setOpen] = useState(false);
  const { value, onChange, division, deptIds, endCustomers, scmSiteIds, projectCodes } = props;
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00507', 'Project')} labelAlign='right' render={() => (
        <button type='button' onClick={() => setOpen(true)} style={popupBtnStyle}>
          <span>{value.length > 0 ? value.join(',') : <span style={{ color: '#9ca3af' }}>&nbsp;</span>}</span>
          <span style={{ color: '#1976d2' }}>🔍</span>
        </button>
      )} />
      <ProjectByDivisionModal
        open={open}
        modalClose={() => setOpen(false)}
        setSelectedValue={(projects: string) => {
          onChange(projects.split(',').map(s => s.trim()).filter(Boolean));
          setOpen(false);
        }}
        preSearchParams={{
          divisionId: division,
          deptId: orAll(deptIds),
          endCustomer: orAll(endCustomers),
          salesSite: orAll(scmSiteIds),
          projectCode: orAll(projectCodes),
          etc: 'N',
        } as never}
      />
    </Grid>
  );
};

// ====================================================================================
// 8. ItemField — Model / Nickname (size=4, popup=ItemByDivisionModal, headerTitle='Model / Nickname')
// ====================================================================================
interface ItemFieldProps extends PopupFieldProps {
  itemIds?: string[];
}
export const ItemField = (props: ItemFieldProps) => {
  const L = useL();
  const [open, setOpen] = useState(false);
  const { value, onChange, division, deptIds, endCustomers, scmSiteIds, projectCodes, itemIds } = props;
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00508', 'Model / Nickname')} labelAlign='right' render={() => (
        <button type='button' onClick={() => setOpen(true)} style={popupBtnStyle}>
          <span>{value.length > 0 ? value.join(',') : <span style={{ color: '#9ca3af' }}>&nbsp;</span>}</span>
          <span style={{ color: '#1976d2' }}>🔍</span>
        </button>
      )} />
      <ItemByDivisionModal
        open={open}
        modalClose={() => setOpen(false)}
        setSelectedValue={(items: string) => {
          onChange(items.split(',').map(s => s.trim()).filter(Boolean));
          setOpen(false);
        }}
        preSearchParams={{
          divisionId: division,
          deptId: orAll(deptIds),
          endCustomer: orAll(endCustomers),
          salesSite: orAll(scmSiteIds),
          projectCode: orAll(projectCodes),
          itemId: itemIds && itemIds.length > 0 ? itemIds.join(',') : '',
        } as never}
        headerTitle='Model / Nickname'
      />
    </Grid>
  );
};

// ====================================================================================
// 9. OwnerField (size=4, popup=OwnerByDivisionModal, 6필드 'ALL' 자동)
// ====================================================================================
interface OwnerFieldProps extends PopupFieldProps {
  owners?: string[];
}
export const OwnerField = (props: OwnerFieldProps) => {
  const L = useL();
  const [open, setOpen] = useState(false);
  const { value, onChange, division, deptIds, endCustomers, scmSiteIds, projectCodes, owners } = props;
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00510', 'Owner')} labelAlign='right' render={() => (
        <button type='button' onClick={() => setOpen(true)} style={popupBtnStyle}>
          <span>{value.length > 0 ? value.join(',') : <span style={{ color: '#9ca3af' }}>&nbsp;</span>}</span>
          <span style={{ color: '#1976d2' }}>🔍</span>
        </button>
      )} />
      <OwnerByDivisionModal
        open={open}
        modalClose={() => setOpen(false)}
        setSelectedValue={(o: string) => {
          onChange(o.split(',').map(s => s.trim()).filter(Boolean));
          setOpen(false);
        }}
        preSearchParams={{
          divisionId: division,
          deptId: orAll(deptIds),
          endCustomer: orAll(endCustomers),
          salesSite: orAll(scmSiteIds),
          projectCode: orAll(projectCodes),
          owner: owners && owners.length > 0 ? owners.join(',') : '',
        } as never}
        ownerId=''
      />
    </Grid>
  );
};

// ====================================================================================
// 10. PeriodField (size=8, DatePickerCalendar date-range-multi)
//     dayjs customParseFormat plugin 미등록 환경 → YYYY-MM-DD 변환
// ====================================================================================
const toDayjs = (s: string) => {
  if (!s || s.length !== 8) return dayjs();
  return dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`);
};
interface PeriodFieldProps {
  start: string;
  end: string;
  onChange: (start: string, end: string) => void;
}
export const PeriodField = ({ start, end, onChange }: PeriodFieldProps) => {
  const L = useL();
  const value: [Dayjs, Dayjs] = [toDayjs(start), end ? toDayjs(end) : dayjs().add(90, 'day')];
  return (
    <Grid size={8}>
      <FormItem label={L('LBL00505', 'Period')} labelAlign='right' required render={() => (
        <DatePickerCalendar
          usecase='date-range-multi'
          elevation
          size='small'
          value={value}
          onChange={((date: [Dayjs, Dayjs]) => {
            onChange(date[0]?.format('YYYYMMDD') ?? '', date[1]?.format('YYYYMMDD') ?? '');
          }) as never}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 11. BucketField (size=2, combo=BucketType — W/M filter)
// ====================================================================================
interface BucketFieldProps {
  value: 'W' | 'M';
  onChange: (v: 'W' | 'M') => void;
}
export const BucketField = ({ value, onChange }: BucketFieldProps) => {
  const L = useL();
  const [buckets] = useTabComboQueries({ filters: ['BucketType'] });
  const options = (buckets ?? [])
    .map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) }))
    .filter(o => o.value === 'W' || o.value === 'M');
  const effective = options.length > 0 ? options : [
    { label: 'Weekly', value: 'W' },
    { label: 'Monthly', value: 'M' },
  ];
  return (
    <Grid size={2}>
      <FormItem label={L('LBL00511', 'Bucket')} labelAlign='right' required render={() => (
        <CustomDropdown
          value={value || 'W'}
          options={effective}
          onChange={(_, option) => onChange((String(option) === 'M' ? 'M' : 'W'))}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 12. VersionField (size=6, popup, 우측 🔍)
// ====================================================================================
interface VersionFieldProps {
  value: string;
  onOpenPopup: () => void;
}
export const VersionField = ({ value, onOpenPopup }: VersionFieldProps) => {
  const L = useL();
  return (
    <Grid size={6}>
      <FormItem label={L('LBL00513', 'Version')} labelAlign='right' required render={() => (
        <button type='button' onClick={onOpenPopup} style={popupBtnStyle}>
          <span>{value || 'Current'}</span>
          <span style={{ color: '#1976d2' }}>🔍</span>
        </button>
      )} />
    </Grid>
  );
};

// ====================================================================================
// 13. SearchOverRangeField (size=4, checkbox)
// ====================================================================================
interface CheckFieldProps {
  value: boolean;
  onChange: (v: boolean) => void;
}
export const SearchOverRangeField = ({ value, onChange }: CheckFieldProps) => {
  const L = useL();
  return (
    <Grid size={4}>
      <FormItem label={L('LBL00512', 'Search over range')} labelAlign='right' render={() => (
        <input
          type='checkbox'
          checked={value}
          onChange={e => onChange(e.target.checked)}
          style={{ marginLeft: 8, transform: 'scale(1.2)' }}
        />
      )} />
    </Grid>
  );
};

// ====================================================================================
// 공통 style (popup button)
// ====================================================================================
const popupBtnStyle: React.CSSProperties = {
  width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'space-between',
  padding: '6px 8px', border: '1px solid #b8bfc9', borderRadius: 3,
  background: 'white', cursor: 'pointer', textAlign: 'left',
};
