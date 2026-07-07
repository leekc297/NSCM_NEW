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
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ItemByDivisionModal } from '../itemByDivisionModal/ItemByDivisionModal';
import { OwnerByDivisionModal } from '../ownerByDivisionModal/OwnerByDivisionModal';
import { ProjectByDivisionModal } from '../projectByDivisionModal/ProjectByDivisionModal';

import styles from './SearchFields.module.scss';

// ====================================================================================
// 표준 props
// ====================================================================================
// gridSize: 화면별 4개/행 등 레이아웃 오버라이드용 (미지정 시 각 필드 기존 size 유지 — 회귀 0).
interface SingleFieldProps {
  value: string;
  onChange: (v: string) => void;
  gridSize?: number;
}
interface MultiFieldProps {
  value: string[];
  onChange: (v: string[]) => void;
  division?: string; // 종속 필터용
  gridSize?: number;
}
interface PopupFieldProps {
  value: string[];
  onChange: (v: string[]) => void;
  division: string;
  deptIds?: string[];
  endCustomers?: string[];
  scmSiteIds?: string[];
  projectCodes?: string[];
  gridSize?: number;
}

// i18n helper — LBL+5자리 표준 (KO.json 미등록 시 fallback 영문)
const useL = () => {
  const { t } = useTranslation();
  return (code: string, fallbackEn: string) => t(code, { defaultValue: fallbackEn });
};

// CustomDropdown options helper — NUMBER→String + DIVISION_ID 필터
// row type 을 string-keyed 로 강제 (eslint no-base-to-string / restrict-template-expressions 회피)
const toOptions = (rows: Array<Record<string, unknown>> | undefined, divisionId?: string) => {
  const arr = (rows ?? []) as unknown as Array<Record<string, string>>;
  return [
    ...new Map(
      arr
        .filter(r => !divisionId || !r.DIVISION_ID || r.DIVISION_ID === divisionId)
        .map(r => [`${r.DIVISION_ID ?? ''}|${r.CODE ?? ''}`, r] as const)
    ).values(),
  ].map(r => ({ label: String(r.NAME ?? r.CODE ?? ''), value: String(r.CODE ?? '') }));
};

// 'ALL' 기본값 helper — P_COM0006/P_COM0008 SP WHERE 절 `(P_X='ALL' OR ...)` 패턴 대응
const orAll = (arr?: string[]) => (arr && arr.length > 0 ? arr.join(',') : 'ALL');

// ⭐ 2026-06-12 사용자 요구: 박스 + 우측 별도 조회 버튼 (TextBox 오른쪽 끝 뒤, 높이 정렬)
//   InputField (박스) 와 Button (별도 조회 버튼) 을 flex 컨테이너로 분리 — endAdornment 안 사용
//   기존 popupBtnStyle (전체 박스가 button) 은 deprecated
interface PopupSearchInputProps {
  value: string;
  onValueChange: (v: string) => void;
  onOpenPopup: () => void;
  disabled?: boolean; // ⭐ division 기준 비활성 (AS-IS Enabled=false) — 입력/팝업 버튼 모두 잠금
}
const popupRowStyle: React.CSSProperties = {
  display: 'flex',
  alignItems: 'stretch',
  gap: 4,
  width: '100%',
};
const PopupSearchInput = ({
  value,
  onValueChange,
  onOpenPopup,
  disabled,
}: PopupSearchInputProps) => (
  <div style={popupRowStyle}>
    <InputField
      fullWidth
      disabled={disabled}
      value={value}
      onChange={e => onValueChange((e.target as HTMLInputElement).value)}
    />
    <Button
      appearance='outlined'
      priority='normal'
      disabled={disabled}
      iconComponent={<FunctionSearchIcon appearance='lined' />}
      onClick={() => {
        if (!disabled) onOpenPopup();
      }}
    />
  </div>
);

// ====================================================================================
// 1. DivisionField (필수, size=4, combo=MyDivision)
//    AS-IS clbDivisions / DataService SetChangeControl("MyDivision")
// ====================================================================================
export const DivisionField = ({ value, onChange, gridSize }: SingleFieldProps) => {
  const L = useL();
  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00501', 'Div')}
        labelAlign='right'
        required
        render={() => (
          <CustomDropdown
            value={value}
            options={(divisions ?? []).map(item => ({
              label: String(item.NAME),
              value: String(item.CODE),
            }))}
            onChange={(_, option) => onChange(String(option))}
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 2. TeamField (size=4, combo=TeambyDivision)
// ====================================================================================
export const TeamField = ({ value, onChange, division, gridSize }: MultiFieldProps) => {
  const L = useL();
  const [teams] = useTabComboQueries({ filters: ['TeambyDivision'] });
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00502', 'Team')}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value.join(',')}
            options={toOptions(teams as never, division)}
            onChange={(_, options) =>
              onChange(
                String(options ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 3. EndCustomerField (size=4, combo=EndCustomer)
// ====================================================================================
export const EndCustomerField = ({ value, onChange, division, gridSize }: MultiFieldProps) => {
  const L = useL();
  const [endCustomers] = useTabComboQueries({ filters: ['EndCustomer'] });
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00503', 'End Customer')}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value.join(',')}
            options={toOptions(endCustomers as never, division)}
            onChange={(_, options) =>
              onChange(
                String(options ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 4. SalesSiteField (size=4, combo=SalesSite)
// ====================================================================================
export const SalesSiteField = ({ value, onChange, division, gridSize }: MultiFieldProps) => {
  const L = useL();
  const [salesSites] = useTabComboQueries({ filters: ['SalesSite'] });
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00506', 'Sales Site')}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value.join(',')}
            options={toOptions(salesSites as never, division)}
            onChange={(_, options) =>
              onChange(
                String(options ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 5. PlantSiteField (size=4, combo=SalesSite 재사용 — Plant Site combo BE 미등록)
// ====================================================================================
export const PlantSiteField = ({ value, onChange, division, gridSize }: MultiFieldProps) => {
  const L = useL();
  const [salesSites] = useTabComboQueries({ filters: ['SalesSite'] });
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00509', 'Plant Site')}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value.join(',')}
            options={toOptions(salesSites as never, division)}
            onChange={(_, options) =>
              onChange(
                String(options ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 6. BizTypeField (size=4, combo=BizType — SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='BIZ_TYPE')
// ====================================================================================
export const BizTypeField = ({ value, onChange, gridSize }: Omit<MultiFieldProps, 'division'>) => {
  const L = useL();
  const [bizTypes] = useTabComboQueries({ filters: ['BizType'] });
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00504', 'Biz.Type')}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value.join(',')}
            options={toOptions(bizTypes as never)}
            onChange={(_, options) =>
              onChange(
                String(options ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 7. ProjectField (size=4, popup=ProjectByDivisionModal, 6필드 'ALL' 자동)
// ====================================================================================
interface ProjectFieldProps extends PopupFieldProps {
  // 체크박스 선택 모드(재기동 시 선택값 carry 없음).
  multiCheckbox?: boolean;
  disabled?: boolean; // ⭐ division 기준 비활성 (예: DMF0048 Division='40' → Project 비활성)
}
export const ProjectField = (props: ProjectFieldProps) => {
  const L = useL();
  const [open, setOpen] = useState(false);
  const {
    value,
    onChange,
    division,
    deptIds,
    endCustomers,
    scmSiteIds,
    projectCodes,
    gridSize,
    multiCheckbox,
    disabled,
  } = props;
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00507', 'Project')}
        labelAlign='right'
        render={() => (
          <PopupSearchInput
            disabled={disabled}
            value={value.join(',')}
            onValueChange={v =>
              onChange(
                v
                  .split(',')
                  .map(s => s.trim())
                  .filter(Boolean)
              )
            }
            onOpenPopup={() => setOpen(true)}
          />
        )}
      />
      <ProjectByDivisionModal
        open={open}
        modalClose={() => setOpen(false)}
        setSelectedValue={(projects: string) => {
          onChange(
            projects
              .split(',')
              .map(s => s.trim())
              .filter(Boolean)
          );
          setOpen(false);
        }}
        preSearchParams={
          {
            divisionId: division,
            deptId: orAll(deptIds),
            endCustomer: orAll(endCustomers),
            salesSite: orAll(scmSiteIds),
            // multiCheckbox: 재기동 시 선택값 미전달(carry 없음) → 'ALL'(=전체 목록, 필터 없음).
            projectCode: multiCheckbox ? 'ALL' : orAll(projectCodes),
            etc: 'N',
          } as never
        }
        callFromCell={false}
        multiCheckbox={multiCheckbox}
      />
    </Grid>
  );
};

// ====================================================================================
// 8. ItemField — Model / Nickname (size=4, popup=ItemByDivisionModal, headerTitle='Model / Nickname')
// ====================================================================================
interface ItemFieldProps extends PopupFieldProps {
  itemIds?: string[];
  // 재기동 시 기선택 모델을 전체목록에서 체크 표시(멀티 picker). 미지정 시 기존 동작.
  multiCheckbox?: boolean;
}
export const ItemField = (props: ItemFieldProps) => {
  const L = useL();
  const [open, setOpen] = useState(false);
  const {
    value,
    onChange,
    division,
    deptIds,
    endCustomers,
    scmSiteIds,
    projectCodes,
    itemIds,
    gridSize,
    multiCheckbox,
  } = props;
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00508', 'Model / Nickname')}
        labelAlign='right'
        render={() => (
          <PopupSearchInput
            value={value.join(',')}
            onValueChange={v =>
              onChange(
                v
                  .split(',')
                  .map(s => s.trim())
                  .filter(Boolean)
              )
            }
            onOpenPopup={() => setOpen(true)}
          />
        )}
      />
      <ItemByDivisionModal
        open={open}
        modalClose={() => setOpen(false)}
        setSelectedValue={(items: string) => {
          onChange(
            items
              .split(',')
              .map(s => s.trim())
              .filter(Boolean)
          );
          setOpen(false);
        }}
        preSearchParams={
          {
            divisionId: division,
            deptId: orAll(deptIds),
            endCustomer: orAll(endCustomers),
            salesSite: orAll(scmSiteIds),
            projectCode: orAll(projectCodes),
            // multiCheckbox(체크박스 선택) 모드: 재기동 시 선택값 미전달(carry 없음) → 전체 목록.
            itemId: multiCheckbox ? '' : itemIds && itemIds.length > 0 ? itemIds.join(',') : '',
          } as never
        }
        headerTitle='Model / Nickname'
        multiCheckbox={multiCheckbox}
        callFromCell={false}
      />
    </Grid>
  );
};

// ====================================================================================
// 9. OwnerField (size=4, popup=OwnerByDivisionModal, 6필드 'ALL' 자동)
// ====================================================================================
interface OwnerFieldProps extends PopupFieldProps {
  owners?: string[];
  // 체크박스 선택 모드(재기동 시 선택값 carry 없음).
  multiCheckbox?: boolean;
}
export const OwnerField = (props: OwnerFieldProps) => {
  const L = useL();
  const [open, setOpen] = useState(false);
  const {
    value,
    onChange,
    division,
    deptIds,
    endCustomers,
    scmSiteIds,
    projectCodes,
    owners,
    gridSize,
    multiCheckbox,
  } = props;
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00510', 'Owner')}
        labelAlign='right'
        render={() => (
          <PopupSearchInput
            value={value.join(',')}
            onValueChange={v =>
              onChange(
                v
                  .split(',')
                  .map(s => s.trim())
                  .filter(Boolean)
              )
            }
            onOpenPopup={() => setOpen(true)}
          />
        )}
      />
      <OwnerByDivisionModal
        open={open}
        modalClose={() => setOpen(false)}
        setSelectedValue={(o: string) => {
          onChange(
            o
              .split(',')
              .map(s => s.trim())
              .filter(Boolean)
          );
          setOpen(false);
        }}
        preSearchParams={
          {
            divisionId: division,
            deptId: orAll(deptIds),
            endCustomer: orAll(endCustomers),
            salesSite: orAll(scmSiteIds),
            projectCode: orAll(projectCodes),
            owner: owners && owners.length > 0 ? owners.join(',') : '',
          } as never
        }
        ownerId=''
        multiCheckbox={multiCheckbox}
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
  gridSize?: number;
}
export const PeriodField = ({ start, end, onChange, gridSize }: PeriodFieldProps) => {
  const L = useL();
  const value: [Dayjs, Dayjs] = [toDayjs(start), end ? toDayjs(end) : dayjs().add(90, 'day')];
  return (
    <Grid size={gridSize ?? 8}>
      <FormItem
        label={L('LBL00505', 'Period')}
        labelAlign='right'
        required
        render={() => (
          // ⭐ 디자인 기준 높이 36px 정합 (표준 CustomDropdown/InputField 동일).
          //   design-system 내부 클래스 비의존 — wrapper CSS 로 input/inputbase 높이 강제.
          <div className={styles.datePickerFix}>
            <DatePickerCalendar
              usecase='date-range-multi'
              elevation
              size='small'
              value={value}
              onChange={
                ((date: [Dayjs, Dayjs]) => {
                  onChange(date[0]?.format('YYYYMMDD') ?? '', date[1]?.format('YYYYMMDD') ?? '');
                }) as never
              }
            />
          </div>
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 11. BucketField (size=2, combo=BucketType — W/M filter)
// ====================================================================================
interface BucketFieldProps {
  value: 'W' | 'M';
  onChange: (v: 'W' | 'M') => void;
  gridSize?: number;
}
export const BucketField = ({ value, onChange, gridSize }: BucketFieldProps) => {
  const L = useL();
  const [buckets] = useTabComboQueries({ filters: ['BucketType'] });
  const options = (buckets ?? [])
    .map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) }))
    .filter(o => o.value === 'W' || o.value === 'M');
  const effective =
    options.length > 0
      ? options
      : [
          { label: 'Weekly', value: 'W' },
          { label: 'Monthly', value: 'M' },
        ];
  return (
    <Grid size={gridSize ?? 2}>
      <FormItem
        label={L('LBL00511', 'Bucket')}
        labelAlign='right'
        required
        render={() => (
          <CustomDropdown
            value={value || 'W'}
            options={effective}
            onChange={(_, option) => onChange(String(option) === 'M' ? 'M' : 'W')}
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 12. VersionField (size=6, popup, 우측 🔍)
// ====================================================================================
interface VersionFieldProps {
  value: string;
  onOpenPopup: () => void;
  gridSize?: number;
}
export const VersionField = ({ value, onOpenPopup, gridSize }: VersionFieldProps) => {
  const L = useL();
  return (
    <Grid size={gridSize ?? 6}>
      <FormItem
        label={L('LBL00513', 'Version')}
        labelAlign='right'
        required
        render={() => (
          <PopupSearchInput
            value={value || 'Current'}
            onValueChange={() => {
              /* Version 은 popup 선택만, 직접 입력 안 함 */
            }}
            onOpenPopup={onOpenPopup}
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 13. SearchOverRangeField (size=4, checkbox)
// ====================================================================================
interface CheckFieldProps {
  value: boolean;
  onChange: (v: boolean) => void;
  gridSize?: number;
}
export const SearchOverRangeField = ({ value, onChange, gridSize }: CheckFieldProps) => {
  const L = useL();
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00512', 'Search over range')}
        labelAlign='right'
        render={() => (
          <input
            type='checkbox'
            checked={value}
            onChange={e => onChange(e.target.checked)}
            style={{ marginLeft: 8, transform: 'scale(1.2)' }}
          />
        )}
      />
    </Grid>
  );
};
