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
import { useEffect, useMemo, useState } from 'react';
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
import { resolveDivisionAutoSelect } from './SearchFields.utils';

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
// disabled: 부모에서 division 이 확정돼 내려오는 모달용 (AS-IS DMF0044_United_VersionPopup L119~120
//   `clbDivision.SelectedValue = _sDiv; clbDivision.Enabled = false` 1:1). 미지정 시 기존 동작 그대로.
interface DivisionFieldProps extends SingleFieldProps {
  disabled?: boolean;
}
export const DivisionField = ({ value, onChange, gridSize, disabled }: DivisionFieldProps) => {
  const L = useL();
  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const options = useMemo(
    () =>
      (divisions ?? []).map(item => ({
        label: String(item.NAME),
        value: String(item.CODE),
      })),
    [divisions]
  );
  // ⭐ 미보유 division 자동 보정 (SearchFields.utils 주석 참조) — 보유 Div 가 하나뿐인 계정에서
  //   스토어 기본값('40' 등)이 옵션에 없어 콤보가 빈칸으로 보이던 문제. 유효값은 덮어쓰지 않는다.
  //   ⚠ disabled(부모 확정값)일 때는 보정하지 않는다 — 부모 화면 값을 모달이 뒤집으면 안 된다.
  useEffect(() => {
    if (disabled) return;
    const next = resolveDivisionAutoSelect(options, value);
    if (next !== null) onChange(next);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [options, value, disabled]);
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        label={L('LBL00501', 'Div')}
        labelAlign='right'
        required
        render={() => (
          <CustomDropdown
            value={value}
            options={options}
            disabled={disabled}
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
export const TeamField = ({
  value,
  onChange,
  division,
  gridSize,
  comboId,
}: MultiFieldProps & {
  /**
   * ⭐ 2026-07-23 (DMF0003 조회조건 AS-IS 정합) — opt-in 콤보 대체.
   * 기본 'TeambyDivision'(기존 화면 무영향). DMF0003 은 AS-IS BigFilter 1:1 등록본
   * 'UserTeamByDivision'(SITE_ITEM.OWNER 1번 토큰 사용자의 부서 기준) 사용.
   */
  comboId?: string;
}) => {
  const L = useL();
  // ⭐ 2026-08-12 — divisionId 를 콤보 파라미터로 전달 (AS-IS 콜사이트 계약 = @Param1=division 재조회 1:1).
  //   TeambyDivision 은 40 이 owner 경로 전용 분기(원문 ELSE)라, 미전달('ALL' 분기)로는 40 팀이
  //   영원히 반환되지 않는다(40 SALES 사이트는 DEPT 미배정 설계). division 변경 = 쿼리키 변경 = 자동 재조회.
  //   ⚠ BE makeComboQuery 는 raw 문자열 치환 — 작은따옴표 포함 전달 계약. 빈 division = '' = 'ALL' 분기(종전 동일).
  //   @divisionId 토큰이 없는 콤보(UserTeamByDivision 등)는 전달해도 무해(치환 대상 없음 — 클라 필터가 동작).
  const [teams] = useTabComboQueries({
    filters: [{ comboId: comboId ?? 'TeambyDivision', divisionId: `'${division ?? ''}'` }],
  });
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
export const EndCustomerField = ({
  value,
  onChange,
  division,
  gridSize,
  comboId,
  deptIds,
}: MultiFieldProps & {
  /**
   * ⭐ 2026-07-23 (DMF0003 조회조건 AS-IS 정합) — opt-in 콤보 대체.
   * 기본 'EndCustomer'(기존 화면 무영향). DMF0003 은 AS-IS BigFilter 1:1 등록본
   * 'EndCustomerByDivision'(40=SITE_ITEM owner-dept PROJECT_CODE + lookup-only UNION) 사용.
   * ⭐ 2026-08-04 — deptIds opt-in: AS-IS 검색 Customer 콤보의 Team(DEPT_ID) 클라 필터 재현
   *   (BigFilter EndCustomerByDivision — GetDMInnerTable DEPT_ID 필터). 콤보의 DEPT_ID 컬럼과
   *   관대 매칭(콤보 행 DEPT_ID 공란=통과). 미전달 = 기존 동작(무영향).
   */
  comboId?: string;
  deptIds?: string[];
}) => {
  const L = useL();
  const [endCustomers] = useTabComboQueries({ filters: [comboId ?? 'EndCustomer'] });
  const deptSet = deptIds && deptIds.length > 0 ? new Set(deptIds) : null;
  const deptFiltered = deptSet
    ? ((endCustomers ?? []) as Array<Record<string, string>>).filter(
        r => !r.DEPT_ID || deptSet.has(r.DEPT_ID)
      )
    : endCustomers;
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
            options={toOptions(deptFiltered as never, division)}
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
export const SalesSiteField = ({
  value,
  onChange,
  division,
  gridSize,
  comboId,
  endCustomer,
  deptId,
  asYn,
}: MultiFieldProps & {
  /**
   * ⭐ 2026-07-23 (조회조건 AS-IS 정합, hook #117) — opt-in 서버 바인드 콤보 대체.
   * comboId 지정 시 'UserSiteByEndCustomer'(AS-IS UP_FX SiteByEndCustomer/40 1:1) 형태의
   * @divisionId/@endCustomer/@deptId 바인드 콤보로 전환 — EndCustomer/Team cascade +
   * 40 owner-team 필터 + OPERATION_GROUP 'W' 제외 (서버 필터 완료 → CODE/NAME 직결).
   * 미지정 = 기존 'SalesSite' + division 클라 필터 (기존 사용처 무영향).
   * ⭐ 2026-08-04 — CMBO 의 @asYn 게이트 제거(AS-IS E20260211-001189 정합): AS 사이트는
   *   전 사용자 무조건 포함. asYn prop/바인드는 SQL 에 토큰이 없어 no-op (호환 유지용 존치).
   */
  comboId?: string;
  endCustomer?: string;
  deptId?: string;
  asYn?: boolean;
}) => {
  const L = useL();
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const [salesSites] = useTabComboQueries(
    comboId
      ? {
          filters: [
            {
              comboId,
              divisionId: q(division),
              endCustomer: q(endCustomer),
              deptId: q(deptId),
              asYn: q(asYn ? 'Y' : 'N'),
            },
          ],
        }
      : { filters: ['SalesSite'] }
  );
  const options = comboId
    ? ((salesSites ?? []) as Array<Record<string, string>>).map(r => ({
        label: String(r.NAME ?? r.CODE ?? ''),
        value: String(r.CODE ?? ''),
      }))
    : toOptions(salesSites as never, division);
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
            options={options}
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
// ⭐ Plant Site — combo `PlantSitebyEndCustomer` (Division + EndCustomer 서버측 @바인드).
//   Enable = 81 계열만 (40/82 disabled). 값 quoting 의무 (BE makeComboQuery raw 치환).
//   룰: hooks/messaging-api-and-search-fields-mandatory §3.1 + memory feedback_search_fields_catalog.
export const PlantSiteField = ({
  value,
  onChange,
  division,
  endCustomer,
  gridSize,
}: MultiFieldProps & { endCustomer?: string }) => {
  const L = useL();
  // Enable = 81 계열만 (81/81_UC/81_HM/81_ST/81_HD/81_HG). 40·82 = 비활성.
  const disabled = !division?.startsWith('81');
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  // 서버측 바인드 cascade — division/endCustomer 변경 시 queryKey 갱신 → 재조회 (81* 만 조회)
  const [plantSites] = useTabComboQueries({
    filters: [
      { comboId: 'PlantSitebyEndCustomer', divisionId: q(division), endCustomer: q(endCustomer) },
    ],
    enabled: !disabled,
  });
  // PlantSitebyEndCustomer 반환열 = CODE/NAME 만 (서버 필터 완료) → division 재필터 불요
  const options = ((plantSites ?? []) as Array<Record<string, string>>).map(r => ({
    label: String(r.NAME ?? r.CODE ?? ''),
    value: String(r.CODE ?? ''),
  }));
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
            disabled={disabled}
            value={value.join(',')}
            options={options}
            onChange={(_, opts) =>
              onChange(
                String(opts ?? '')
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
export const BizTypeField = ({
  value,
  onChange,
  gridSize,
  comboId,
  division,
}: Omit<MultiFieldProps, 'division'> & {
  /**
   * ⭐ 2026-07-23 (DMF0003 조회조건 AS-IS 정합) — opt-in.
   * comboId 기본 'BizType'(전역 lookup — 기존 화면 무영향). DMF0003 은 AS-IS BigFilter 1:1
   * 'BizTypebyDivision'(DM_BIZ_TYPE(40) UNION SCM_MST_PROJECT BIZ_TYPE(비40), DIVISION_ID 반환) 사용.
   * division 지정 시 DIVISION_ID 클라 필터 (미지정 = 무필터, 기존 동작 보존).
   */
  comboId?: string;
  division?: string;
}) => {
  const L = useL();
  const [bizTypes] = useTabComboQueries({ filters: [comboId ?? 'BizType'] });
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
            options={toOptions(bizTypes as never, division)}
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
// mode='month' 용 — YYYYMM ↔ dayjs (정본 DemandManagerForm ymToDayjs 동일 규약: 1일로 고정)
const ymToDayjs = (s: string) => {
  if (!s || s.length !== 6) return dayjs();
  return dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-01`);
};
interface PeriodFieldProps {
  start: string;
  end: string;
  onChange: (start: string, end: string) => void;
  gridSize?: number;
  // 라벨 커스터마이즈 (미지정 시 표준 'Period'). 예: 승인관리 'Request Date'.
  label?: string;
  /**
   * 'month' = 년월(YYYYMM) 구간 — AS-IS drpPeriodMonth 계열 화면(DMF0074 등,
   * usecase='month' 정본 = DemandManagerForm). 기본 'date'(YYYYMMDD) — 기존 사용처 회귀 0.
   * ⚠ 값 형식이 모드에 따라 다르다(YYYYMM vs YYYYMMDD) — 스토어 초기값·SP 계약과 맞출 것.
   */
  mode?: 'date' | 'month';
}
export const PeriodField = ({ start, end, onChange, gridSize, label, mode }: PeriodFieldProps) => {
  const L = useL();
  // 시작일/종료일을 각각 독립 달력 2개로 분리 (mode='month' 는 월 달력).
  //   필드별로 자기 팝업이 뜨며, 종료일은 시작일 이후만 선택 가능(mindate).
  const isMonth = mode === 'month';
  const parse = isMonth ? ymToDayjs : toDayjs;
  const outFormat = isMonth ? 'YYYYMM' : 'YYYYMMDD';
  const startValue = start ? parse(start) : null;
  const endValue = end ? parse(end) : null;
  return (
    <Grid size={gridSize ?? 8}>
      <FormItem
        label={label ?? L('LBL00505', 'Period')}
        labelAlign='right'
        required
        render={() => (
          // ⭐ 디자인 기준 높이 36px 정합 (표준 CustomDropdown/InputField 동일).
          //   design-system 내부 클래스 비의존 — wrapper CSS 로 input/inputbase 높이 강제.
          <div className={styles.periodSplit}>
            <div className={styles.datePickerFix}>
              <DatePickerCalendar
                usecase={isMonth ? 'month' : 'date'}
                elevation
                size='small'
                format={isMonth ? 'YYYY.MM' : 'YYYY.MM.DD'}
                value={startValue}
                onChange={
                  ((date: Dayjs | null) => {
                    onChange(date?.format(outFormat) ?? '', end);
                  }) as never
                }
              />
            </div>
            <span className={styles.periodSep}>~</span>
            <div className={styles.datePickerFix}>
              <DatePickerCalendar
                usecase={isMonth ? 'month' : 'date'}
                elevation
                size='small'
                format={isMonth ? 'YYYY.MM' : 'YYYY.MM.DD'}
                value={endValue}
                mindate={startValue ?? undefined}
                onChange={
                  ((date: Dayjs | null) => {
                    onChange(start, date?.format(outFormat) ?? '');
                  }) as never
                }
              />
            </div>
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
  /** 라벨 override — 화면별 Version 명칭이 다른 경우(DMF0044/0049 BP/SP Version). 미전달 = LBL00513 'Version' */
  label?: string;
  /** value 가 빈 값일 때 표시할 문자열. 미전달 = 'Current' (DMF0020 기존 동작 보존) */
  emptyText?: string;
  /**
   * 직접 입력(key-in) 허용. 미전달 = 팝업 선택 전용 (기존 동작 그대로 — 회귀 0).
   * 사용자가 친 문자열이 가공 없이 그대로 올라오므로, 조회키/표시문 매핑은 호출 측이 정한다.
   */
  onValueChange?: (v: string) => void;
}
export const VersionField = ({
  value,
  onOpenPopup,
  gridSize,
  label,
  emptyText,
  onValueChange,
}: VersionFieldProps) => {
  const L = useL();
  // 주의: 직접 입력 가능한 경우 emptyText 를 value 로 넣지 않는다 — placeholder 성격의 문자열이
  //   실제 입력값이 되어 타이핑하면 앞에 그대로 붙는다. 편집형은 빈 값을 빈 값으로 둔다.
  const shownValue = value || (onValueChange ? '' : (emptyText ?? 'Current'));
  return (
    <Grid size={gridSize ?? 6}>
      <FormItem
        label={label ?? L('LBL00513', 'Version')}
        labelAlign='right'
        required
        render={() => (
          <PopupSearchInput
            value={shownValue}
            onValueChange={
              onValueChange ??
              (() => {
                /* 미전달 = popup 선택 전용, 직접 입력 안 함 */
              })
            }
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
