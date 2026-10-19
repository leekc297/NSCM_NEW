// ====================================================================================
// SearchFields Catalog — 조회조건 표준 카탈로그 (2026-06-03 사용자 요구)
//
// "조회조건의 경우에는 항목별로 rule 로 관리해주세요. 사이즈, 데이터 추출경로를 등록해서
//  등록된 조회항목은 그대로 사용하고, 신규인 경우에는 생성 후 관리항목으로 추가해주세요."
//
// 사용 예 (신규 화면):
//   import {
//     DivisionField, TeamField, EndCustomerField, SalesSiteField, SoldToCustomerField,
//     BizTypeField, PlantSiteField, ProjectField, ItemField, OwnerField,
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
import { useEffect, useMemo, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, type DropdownSortKey } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ItemByDivisionModal } from '../itemByDivisionModal/ItemByDivisionModal';
import { OwnerByDivisionModal } from '../ownerByDivisionModal/OwnerByDivisionModal';
import { ProjectByDivisionModal } from '../projectByDivisionModal/ProjectByDivisionModal';

import { logCascade } from './SearchFields.debug';
import styles from './SearchFields.module.scss';
import { yearBoundsOf, yearToDayjs, yearValueOf } from './yearField.util';

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

// ====================================================================================
// 임시 일괄 정렬 (2026-08-25 사용자 요구) — End Customer / Sales Site / Plant Site 세 칸.
//
// 세 칸은 코드 목록이라 콤보가 준 순서(DISPLAY_SEQ)에 업무 의미가 없어 표시명 순으로 세운다.
// 화면마다 sortBy 를 달지 않고 카탈로그 기본값으로 둔 것은 "일괄 적용 + 한 번에 해제" 요구
// 때문이다. 해제할 때는 아래 값을 undefined 로 바꾸면 세 칸이 동시에 콤보 순서로 돌아간다
// (호출부는 손댈 것이 없다).
//
// 임시: 정식 결정이 나면 이 상수를 지우고 화면별 sortBy prop 으로 되돌린다.
// 주의: 나머지 칸(Team / Biz Type / Sold-To Customer / Bucket ...)에는 걸지 않는다. 업무 순서를
//   담은 콤보가 섞여 있어 일괄 정렬은 그쪽을 망가뜨린다 (CustomDropdown sortOptionsBy 주석 참조).
// 호출부가 sortBy 를 명시하면 그 값이 이긴다.
// ====================================================================================
const TEMP_LIST_SORT_BY: DropdownSortKey | undefined = 'label';

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

type Row = Record<string, string>;

// cascade 클라이언트 필터 helper (2026-08-22)
// CustomDropdown 은 전체선택/전체해제를 ['ALL'] / [''] 로 내려보내므로 실제 코드만 남긴다.
// 남는 값이 없으면 null = 필터 미적용 (MktFcstForm.normalizeIds 와 동일 규칙).
const toFilterSet = (values?: string[]): Set<string> | null => {
  const cleaned = (values ?? [])
    .map(v => String(v).trim())
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');
  return cleaned.length > 0 ? new Set(cleaned) : null;
};

// 콤보 행 값 읽기 — 콤보 응답은 컬럼에 따라 NUMBER 로 내려오기도 한다 (toOptions 의 NUMBER->String
// 주석과 같은 사정). 문자열로 맞춰야 Set 비교가 성립한다.
const cellValue = (row: Row, column: string): string => {
  const raw = row[column] as string | number | null | undefined;
  return raw === null || raw === undefined ? '' : String(raw).trim();
};

/**
 * 콤보 행 1건이 한 단계를 통과하는가.
 *
 * strict=false (기본, 관대) — 그 컬럼이 공란인 행은 통과시킨다. 콤보 SQL 이 상위 단계를 안 채운 행
 *   ('SalesSite' 의 PROJECT_CODE NULL 행)까지 자르면 목록이 비어버리는 컬럼에 쓴다.
 *   SalesMonitoringForm L212 cascade 규칙과 동일.
 * strict=true (엄격) — 공란 행도 자른다.
 *   필수: End Customer 의 DEPT_ID 는 반드시 엄격이다. 이 콤보는 공란 DEPT_ID 행이 대다수라
 *   관대로 두면 필터가 통째로 무력화돼 Team 을 골라도 목록이 그대로 보인다.
 *   같은 사고가 두 번 있었다 — MktFcstForm L67 (2026-08-18 원복), BusinessPlanForm L89 (2026-08-21 실측).
 */
const matchesCascade = (
  row: Row,
  column: string,
  filter: Set<string> | null,
  strict = false
): boolean => {
  if (!filter) return true;
  const cell = cellValue(row, column);
  if (cell === '') return !strict;
  return filter.has(cell);
};

/**
 * cascade 한 단계 선언. 문자열 배열이면 관대 매칭, 객체면 strict 를 직접 고른다.
 * 관대/엄격 판정 근거는 matchesCascade 주석 참조.
 */
export type CascadeStepFilter = string[] | { values?: string[]; strict?: boolean };

/**
 * 콤보 행의 컬럼명 -> 그 컬럼에 매칭할 값 목록.
 *
 * 컬럼명을 컴포넌트에 박지 않는 이유: 같은 필드라도 comboId 를 갈아끼우면 콤보 SQL 이
 * 내려주는 cascade 컬럼이 달라진다 (예: 'SalesSite' 는 DEPT_ID/PROJECT_CODE,
 * 'UserSiteByEndCustomer' 는 서버에서 걸러 컬럼 자체가 없다).
 * 어느 조회조건이 어느 컬럼에 대응하는지는 화면이 아는 정보라 호출 측이 통째로 넘긴다.
 *
 * 값이 비었거나 'ALL' 뿐이면 그 단계는 미적용 — multi-select 전체선택('ALL')과 전체해제('')가
 * 필터상 같다는 CustomDropdown 계약을 그대로 따른다. 선언한 순서대로 적용된다.
 * DIVISION_ID 는 여기 적지 않아도 항상 맨 앞에서 먼저 걸린다 (runCascade 참조).
 */
export type CascadeFilter = Record<string, CascadeStepFilter | undefined>;

/** cascade 한 단계의 스냅샷 — 디버그 출력(logCascade)이 구조적으로 그대로 받는다. */
interface CascadeStep {
  column: string;
  filter: Set<string> | null;
  /** 공란 행을 잘랐는지 — 목록이 안 좁혀질 때 제일 먼저 볼 값이다. */
  strict: boolean;
  rows: Row[];
}

/** 배열 단축표기와 객체표기를 한 모양으로 편다. */
const normalizeStep = (spec?: CascadeStepFilter): { values?: string[]; strict: boolean } =>
  Array.isArray(spec) || spec === undefined
    ? { values: spec, strict: false }
    : { values: spec.values, strict: spec.strict ?? false };

/**
 * division 최우선 -> 호출 측이 선언한 순서대로 cascade 적용.
 *
 * division 을 맨 앞에 고정하는 이유: 같은 DEPT_ID / PROJECT_CODE 값이 여러 division 에
 * 존재하므로, division 을 나중에 걸면 타 division 행이 하위 필터를 통과해 중간 단계에 섞인다.
 *
 * @returns 단계별 스냅샷. 마지막 원소의 rows 가 최종 결과이며 항상 1개 이상이다.
 */
const runCascade = (rows: Row[], division?: string, cascade?: CascadeFilter): CascadeStep[] => {
  const specs: [string, CascadeStepFilter | undefined][] = [
    ['DIVISION_ID', division ? [division] : []],
    ...Object.entries(cascade ?? {}),
  ];
  let current = rows;
  return specs.map(([column, spec]) => {
    const { values, strict } = normalizeStep(spec);
    const filter = toFilterSet(values);
    current = current.filter(r => matchesCascade(r, column, filter, strict));
    return { column, filter, strict, rows: current };
  });
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
  // 편집 시작 시점 훅 — 표시문(라벨)과 조회키가 다른 필드가 라벨을 풀 때 쓴다.
  onFocus?: () => void;
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
  onFocus,
}: PopupSearchInputProps) => {
  // 콤마 입력 즉시 소실 버그 수정 (2026-09-16): 부모는 값을 string[]로 들고 있다가
  // `value.join(',')`로 내려주는데, 콤마 뒤에 아직 토큰이 없는 편집 중간 상태
  // (예: "ABC,")는 split+filter(Boolean)에서 빈 문자열이 걸러져 즉시 "ABC"로 되돌아온다.
  // 그 결과 방금 입력한 콤마가 렌더 직후 사라지는 것처럼 보인다. 포커스 중에는 로컬
  // 텍스트를 그대로 보여주고, blur/외부 값 변경 시에만 부모가 정리한 값으로 동기화한다.
  const [text, setText] = useState(value);
  const focusedRef = useRef(false);
  useEffect(() => {
    if (!focusedRef.current) setText(value);
  }, [value]);
  return (
    <div style={popupRowStyle}>
      <InputField
        fullWidth
        disabled={disabled}
        value={text}
        onFocus={() => {
          focusedRef.current = true;
          onFocus?.();
        }}
        onBlur={() => {
          focusedRef.current = false;
          setText(value);
        }}
        onChange={e => {
          const v = (e.target as HTMLInputElement).value;
          setText(v);
          onValueChange(v);
        }}
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
};

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
  // 자동 보정 없음 (2026-08-23 사용자 요청) — 스토어 값이 옵션에 없어도 첫 옵션으로
  //   덮어쓰지 않는다. 옵션이 1건이어도 사용자가 직접 고르기 전에는 선택되지 않는다.
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        className={commonStyles.formItem}
        label={L('LBL00001', 'Div')}
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
        className={commonStyles.formItem}
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
  cascade,
  disabled,
  sortBy,
  debugLabel,
}: MultiFieldProps & {
  /**
   * ⭐ 2026-07-23 (DMF0003 조회조건 AS-IS 정합) — opt-in 콤보 대체.
   * 기본 'EndCustomer'(기존 화면 무영향). DMF0003 은 AS-IS BigFilter 1:1 등록본
   * 'EndCustomerByDivision'(40=SITE_ITEM owner-dept PROJECT_CODE + lookup-only UNION) 사용.
   * ⭐ 2026-08-04 — Team(DEPT_ID) 클라 필터 재현 (BigFilter EndCustomerByDivision —
   *   GetDMInnerTable DEPT_ID 필터). 2026-08-22 부터 전용 deptIds prop 대신 공용 cascade 로 받는다.
   */
  comboId?: string;
  /** 클라이언트 cascade 필터. CascadeFilter 주석 참조. 예: { DEPT_ID: sc.deptIds } */
  cascade?: CascadeFilter;
  /**
   * 2026-08-22 opt-in — division 기준 잠금 (AS-IS DMF0043 Enabled=false 계열).
   * 미지정 = 기존 동작(무영향). 판정은 호출 측 책임 (예: divisionId === '40').
   */
  disabled?: boolean;
  /**
   * 목록 정렬. 미지정 = 위 TEMP_LIST_SORT_BY(임시 일괄 'label'). 화면이 명시하면 그 값이 이긴다.
   * 'label' 은 표시명 기준 숫자-영어-한글 순 (CustomDropdown sortOptionsBy 참조).
   * 표시 계층 전용이라 cascade 가 좁히는 원본 행 순서는 건드리지 않는다.
   */
  sortBy?: DropdownSortKey;
  /** 임시 로컬 디버그 — 넘기면 cascade 단계별 결과가 콘솔에 찍힌다. SearchFields.debug 참조. */
  debugLabel?: string;
}) => {
  const L = useL();
  const [endCustomers] = useTabComboQueries({ filters: [comboId ?? 'EndCustomer'] });
  const rawRows = (endCustomers ?? []) as Row[];
  const steps = runCascade(rawRows, division, cascade);
  const cascadeRows = steps[steps.length - 1].rows;
  const options = toOptions(cascadeRows as never, division);
  // 임시 로컬 디버그 — 렌더마다 찍히지 않게 입력이 실제로 바뀐 시점에만 찍는다.
  const debugSignature = `${rawRows.length}|${division ?? ''}|${JSON.stringify(cascade ?? {})}`;
  useEffect(() => {
    if (!debugLabel) return;
    logCascade({
      label: debugLabel,
      comboId: comboId ?? 'EndCustomer',
      division,
      rawRows,
      steps,
      options,
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debugLabel, debugSignature]);
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        className={commonStyles.formItem}
        label={L('LBL00080', 'End Customer')}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            disabled={disabled}
            sortBy={sortBy ?? TEMP_LIST_SORT_BY}
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
  cascade,
  sortBy,
  debugLabel,
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
  /**
   * 2026-08-22 opt-in — 클라이언트 cascade 필터. 컬럼명 -> 값 매핑 (CascadeFilter 주석 참조).
   * 기본 'SalesSite' 콤보는 DIVISION_ID / DEPT_ID / PROJECT_CODE 를 함께 반환하므로
   * division-team-project-salesSite 4단 cascade 를 옵션 단계에서 좁힐 수 있다.
   * 예: { DEPT_ID: sc.deptIds, PROJECT_CODE: sc.endCustomers }
   * 미전달 = 기존 동작(division 필터 단독) — 기존 사용처 무영향.
   * 서버 바인드(comboId) 경로에도 같이 적용되지만, 그 콤보가 해당 컬럼을 안 내려주면
   * 관대 매칭에 의해 no-op 이다.
   */
  cascade?: CascadeFilter;
  /**
   * 목록 정렬. 미지정 = 위 TEMP_LIST_SORT_BY(임시 일괄 'label'). 화면이 명시하면 그 값이 이긴다.
   * 'label' 은 표시명 기준 숫자-영어-한글 순 (CustomDropdown sortOptionsBy 참조).
   * 표시 계층 전용이라 cascade 가 좁히는 원본 행 순서는 건드리지 않는다.
   */
  sortBy?: DropdownSortKey;
  /** 임시 로컬 디버그 — 넘기면 cascade 단계별 결과가 콘솔에 찍힌다. SearchFields.debug 참조. */
  debugLabel?: string;
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
  const rawRows = (salesSites ?? []) as Row[];
  // division 최우선 — 나머지 cascade 는 전부 이 결과 위에서만 돈다.
  const steps = runCascade(rawRows, division, cascade);
  const cascadeRows = steps[steps.length - 1].rows;
  const options = comboId
    ? cascadeRows.map(r => ({
        label: String(r.NAME ?? r.CODE ?? ''),
        value: String(r.CODE ?? ''),
      }))
    : toOptions(cascadeRows as never, division);
  // 임시 로컬 디버그 — 렌더마다 찍히지 않게 입력이 실제로 바뀐 시점에만 찍는다.
  const debugSignature = `${rawRows.length}|${division ?? ''}|${JSON.stringify(cascade ?? {})}`;
  useEffect(() => {
    if (!debugLabel) return;
    logCascade({
      label: debugLabel,
      comboId: comboId ?? 'SalesSite',
      param: comboId
        ? `divisionId=${q(division)}, endCustomer=${q(endCustomer)}, deptId=${q(deptId)}, asYn=${q(asYn ? 'Y' : 'N')}`
        : undefined,
      division,
      rawRows,
      steps,
      options,
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debugLabel, debugSignature]);
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        className={commonStyles.formItem}
        label={L('LBL00506', 'Sales Site')}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy={sortBy ?? TEMP_LIST_SORT_BY}
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
// 5. SoldToCustomerField (size=4, combo=SoldCustomer)
// ====================================================================================
export const SoldToCustomerField = ({
  value,
  onChange,
  division,
  gridSize,
  comboId,
  endCustomer,
  deptId,
  cascade,
  debugLabel,
}: MultiFieldProps & {
  /**
   * opt-in 서버 바인드 콤보 대체 — SalesSiteField 와 같은 모양이다.
   * 미지정이면 기본 'SoldCustomer' 를 전량 받아 클라에서 좁힌다(종전 동작).
   * 지정하면 @divisionId / @endCustomer / @deptId 를 실어 서버에서 좁힌 결과를 받는다.
   * 파라미터가 react-query 키에 들어가므로 상위 조회조건이 바뀌면 새 키가 되어 자동으로
   * 재조회된다 — refetch 를 직접 부르지 않는다.
   *
   * 주의: 파라미터 값은 홑따옴표로 감싼다. BE makeComboQuery 가 등록 SQL 의 @키 를 bind 가
   * 아니라 raw 문자열로 치환하기 때문이다. 다중 선택은 'A,B' 한 덩어리, 미선택은 'ALL' 이며
   * SQL 이 'ALL' 분기를 갖는다. SQL 에 없는 @키 는 치환되지 않고 그냥 남는다(no-op).
   */
  comboId?: string;
  endCustomer?: string;
  deptId?: string;
  /** 클라이언트 cascade 필터. CascadeFilter 주석 참조. 예: { TEAM_CODE: sc.deptIds } */
  cascade?: CascadeFilter;
  /** 임시 로컬 디버그 — 넘기면 cascade 단계별 결과가 콘솔에 찍힌다. SearchFields.debug 참조. */
  debugLabel?: string;
}) => {
  const L = useL();
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const [soldCustomers] = useTabComboQueries(
    comboId
      ? {
          filters: [
            {
              comboId,
              divisionId: q(division),
              endCustomer: q(endCustomer),
              deptId: q(deptId),
            },
          ],
        }
      : { filters: ['SoldCustomer'] }
  );
  const rawRows = (soldCustomers ?? []) as Row[];
  // division 최우선 — 나머지 cascade 는 전부 이 결과 위에서만 돈다.
  const steps = runCascade(rawRows, division, cascade);
  const cascadeRows = steps[steps.length - 1].rows;
  // 컬럼명은 두 벌을 다 견딘다 — 조인 콤보는 SOLD_CUSTOMER_CODE / _NAME(카탈로그 풀네임)로,
  // 서버 바인드 콤보는 CODE / NAME 으로 내려온다. toOptions 는 CODE / NAME 만 보므로 쓰지 않는다.
  const options = cascadeRows
    .map(r => ({
      label: String(r.SOLD_CUSTOMER_NAME ?? r.NAME ?? r.SOLD_CUSTOMER_CODE ?? r.CODE ?? ''),
      value: String(r.SOLD_CUSTOMER_CODE ?? r.CODE ?? ''),
    }))
    .filter(o => o.value !== '');
  // 임시 로컬 디버그 — 렌더마다 찍히지 않게 입력이 실제로 바뀐 시점에만 찍는다.
  const debugSignature = `${rawRows.length}|${division ?? ''}|${JSON.stringify(cascade ?? {})}`;
  useEffect(() => {
    if (!debugLabel) return;
    logCascade({
      label: debugLabel,
      comboId: comboId ?? 'SoldCustomer',
      param: comboId
        ? `divisionId=${q(division)}, endCustomer=${q(endCustomer)}, deptId=${q(deptId)}`
        : undefined,
      division,
      rawRows,
      steps,
      options,
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debugLabel, debugSignature]);
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        className={commonStyles.formItem}
        label={L('LBL00081', 'Sold-To Customer')}
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
// 6. PlantSiteField (size=4, combo=PlantSitebyEndCustomer)
// ====================================================================================
// Plant Site — combo `PlantSitebyEndCustomer`.
//   2026-08-22 콤보 SQL 개정: 파라미터를 받지 않고 전량(DIVISION_ID / END_CUSTOMER / CODE / NAME)
//   을 내려준다. cascade 는 전부 클라이언트에서 건다 — 종전 @divisionId/@endCustomer 서버 바인드는
//   제거했다 (SQL 에 토큰이 없어 그대로 두면 raw 치환이 실패한다).
//   Enable = 81 계열만 (40/82 disabled).
//   룰: hooks/messaging-api-and-search-fields-mandatory 3.1 + memory feedback_search_fields_catalog.
export const PlantSiteField = ({
  value,
  onChange,
  division,
  endCustomer,
  gridSize,
  comboId,
  cascade,
  disabled: disabledOverride,
  sortBy,
  debugLabel,
}: MultiFieldProps & {
  /** End Customer 조회조건 (콤마 조인). 콤보의 END_CUSTOMER 컬럼과 엄격 매칭한다. */
  endCustomer?: string;
  /**
   * 2026-08-20 (DMF0048 조회조건 AS-IS 정합) — opt-in.
   * comboId 기본 'PlantSitebyEndCustomer'(파라미터 없음). DMF0048 은 AS-IS
   * UP_FX_GetCommonDataList 기준 'FromSiteByDivision' 사용 — 이 콤보만 @divisionId 를 받는다.
   */
  comboId?: string;
  /** 추가 클라이언트 cascade 단계. CascadeFilter 주석 참조. END_CUSTOMER 단계 뒤에 붙는다. */
  cascade?: CascadeFilter;
  /**
   * 활성 기준 오버라이드 — 기본은 81 계열 전용 게이트.
   * DMF0048 처럼 AS-IS 가 40 만 비활성인 화면은 호출 측이 직접 지정한다.
   */
  disabled?: boolean;
  /**
   * 목록 정렬. 미지정 = 위 TEMP_LIST_SORT_BY(임시 일괄 'label'). 화면이 명시하면 그 값이 이긴다.
   * 'label' 은 표시명 기준 숫자-영어-한글 순 (CustomDropdown sortOptionsBy 참조).
   * 표시 계층 전용이라 cascade 가 좁히는 원본 행 순서는 건드리지 않는다.
   */
  sortBy?: DropdownSortKey;
  /** 임시 로컬 디버그 — 넘기면 cascade 단계별 결과가 콘솔에 찍힌다. SearchFields.debug 참조. */
  debugLabel?: string;
}) => {
  const L = useL();
  // 기본 Enable = 81 계열만 (81/81_UC/81_HM/81_ST/81_HD/81_HG). 40·82 = 비활성.
  //   호출 측 disabled 가 오면 그 값이 우선한다 (AS-IS 기준이 화면마다 다름).
  const disabled = disabledOverride ?? !division?.startsWith('81');
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  // 기본 콤보는 파라미터 없는 전역 lookup — 화면·division 무관하게 react-query 캐시를 공유한다.
  //   comboId 를 갈아끼운 화면만 종전 서버 바인드 경로를 그대로 탄다 ('FromSiteByDivision' 등).
  //   그 콤보들은 이번 SQL 개정 대상이 아니라 @divisionId/@endCustomer 토큰이 살아 있다 —
  //   파라미터를 빼면 raw 치환이 안 돼 SQL 이 깨진다.
  const [plantSites] = useTabComboQueries({
    filters: [
      comboId
        ? { comboId, divisionId: q(division), endCustomer: q(endCustomer) }
        : 'PlantSitebyEndCustomer',
    ],
    enabled: !disabled,
  });
  const rawRows = (plantSites ?? []) as Row[];
  // END_CUSTOMER 단계는 콤보가 그 컬럼을 실제로 내려줄 때만 건다.
  //   'FromSiteByDivision' 등 END_CUSTOMER 가 없는 콤보에 엄격 매칭을 걸면 전 행이 잘려 목록이 빈다.
  const hasEndCustomerColumn = rawRows.some(r => 'END_CUSTOMER' in r);
  // 필수: strict. 개정 전 SQL 의 `INSTR(',' || @endCustomer || ',', ',' || A.END_CUSTOMER || ',')`
  //   는 END_CUSTOMER 가 공란인 행을 통과시키지 않았다 — 관대 매칭으로 두면 서버 필터 때보다
  //   목록이 늘어난다.
  const steps = runCascade(rawRows, division, {
    ...(hasEndCustomerColumn
      ? { END_CUSTOMER: { values: endCustomer?.split(',') ?? [], strict: true } }
      : {}),
    ...cascade,
  });
  const cascadeRows = steps[steps.length - 1].rows;
  // 같은 Plant Site 가 End Customer 별로 여러 행 내려오므로 CODE 중복제거는 toOptions 가 맡는다.
  const options = toOptions(cascadeRows as never, division);
  // 임시 로컬 디버그 — 렌더마다 찍히지 않게 입력이 실제로 바뀐 시점에만 찍는다.
  const debugSignature = `${rawRows.length}|${division ?? ''}|${endCustomer ?? ''}|${JSON.stringify(cascade ?? {})}`;
  useEffect(() => {
    if (!debugLabel) return;
    logCascade({
      label: debugLabel,
      comboId: comboId ?? 'PlantSitebyEndCustomer',
      param: comboId ? `divisionId=${q(division)}, endCustomer=${q(endCustomer)}` : undefined,
      division,
      rawRows,
      steps,
      options,
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debugLabel, debugSignature]);
  return (
    <Grid size={gridSize ?? 4}>
      <FormItem
        className={commonStyles.formItem}
        label={L('LBL00005', 'Plant Site')}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            disabled={disabled}
            sortBy={sortBy ?? TEMP_LIST_SORT_BY}
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
// 7. BizTypeField (size=4, combo=BizType — SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='BIZ_TYPE')
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
        className={commonStyles.formItem}
        label={L('LBL00085', 'Biz.Type')}
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
// 8. ProjectField (size=4, popup=ProjectByDivisionModal, 6필드 'ALL' 자동)
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
        className={commonStyles.formItem}
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
            // 그리드 형태(체크박스 다중선택 여부)와 무관하게 입력값을 그대로 넘긴다 - 모달이 그
            //   값으로 조회한 결과를 처음부터 보여줘야 한다 (사용자 지정 2026-09-07).
            //   종전에는 multiCheckbox 일 때 'ALL'(전체 목록)로 버렸다. 이미 고른 값이 많으면
            //   목록이 그만큼 좁아지는데, 그건 감수하기로 한 트레이드오프다.
            projectCode: orAll(projectCodes),
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
// 9. ItemField — Model / Nickname (size=4, popup=ItemByDivisionModal, headerTitle='Model / Nickname')
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
        className={commonStyles.formItem}
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
            // 그리드 형태와 무관하게 입력값을 그대로 넘긴다 (위 ProjectField 와 같은 규약).
            itemId: itemIds && itemIds.length > 0 ? itemIds.join(',') : '',
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
// 10. OwnerField (size=4, popup=OwnerByDivisionModal, 6필드 'ALL' 자동)
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
        className={commonStyles.formItem}
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
        // ownerId 는 넘기지 않는다. 모달이 `ownerId ?? preSearchParams.owner` 로 fallback 하는데
        //   `??` 는 nullish 만 통과시키므로 빈 문자열을 넘기면 그 fallback 이 막혀 위 owner 값이
        //   영원히 안 읽힌다 (2026-09-07 실측: SP 6번째 인자 P_OWNER_ID 가 항상 '').
        multiCheckbox={multiCheckbox}
      />
    </Grid>
  );
};

// ====================================================================================
// 11. PeriodField (size=8, DatePickerCalendar date-range-multi)
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
  /**
   * 시작(From) 피커를 비활성화한다 — AS-IS 일부 화면(SCP0006 등)이 `MonthMin1=MonthMax1`로
   * From 월 자체를 고정하는 동작 재현용(design/02_search-combo.md §2 #6). 기본 false —
   * 미지정 시 기존 사용처와 동일하게 동작(회귀 0).
   */
  disabledStart?: boolean;
  /** From/To 두 피커 모두 비활성화 (예: SSP0015 Packer 시트 — Period 편집 불가). 기본 false(회귀 0). */
  disabled?: boolean;
}
export const PeriodField = ({
  start,
  end,
  onChange,
  gridSize,
  label,
  mode,
  disabledStart,
  disabled,
}: PeriodFieldProps) => {
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
        className={commonStyles.formItem}
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
                disabled={disabled || disabledStart}
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
                disabled={disabled}
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
// 11-1. YearField (size=3, DatePickerCalendar usecase='year')
//     연도만 다루는 조회조건. 직접 입력(YYYY 4자리)과 연도 그리드 팝오버를 둘 다 지원한다.
//     값 형식은 'YYYY' 4자리 문자열 — 스토어의 yyyy 규약을 그대로 쓴다.
//
//     선택 범위는 달력 마스터(CALENDAR_YYYY 콤보)에서 뽑은 최소/최대 연도로 막는다.
//     콤보를 목록으로 그리지 않고 경계 계산에만 쓰는 이유: 목록이 2009 부터 수십 건이라
//     드롭다운으로는 원하는 연도를 찾기 어려운데, 그렇다고 범위를 풀면 데이터가 없는 연도를
//     입력할 수 있고 그때는 조회 0건으로만 드러난다(SP 판정 — FE 사전 검증 없음).
//     minYear/maxYear 를 직접 주면 그 값이 이긴다.
// ====================================================================================
interface YearFieldProps {
  value: string; // 'YYYY'
  onChange: (v: string) => void;
  gridSize?: number;
  label?: string;
  required?: boolean;
  // 달력 마스터 범위를 쓰지 않고 직접 막을 때만 준다.
  minYear?: number;
  maxYear?: number;
}
export const YearField = ({
  value,
  onChange,
  gridSize,
  label,
  required = true,
  minYear,
  maxYear,
}: YearFieldProps) => {
  const L = useL();
  // 경계 계산 전용 조회. 쿼리 키가 콤보 ID 단위라 같은 콤보를 쓰는 다른 호출과 캐시를 공유한다.
  const [calendarYyyy] = useTabComboQueries({ filters: ['CALENDAR_YYYY'] });
  const bounds = useMemo(() => yearBoundsOf(calendarYyyy), [calendarYyyy]);

  return (
    <Grid size={gridSize ?? 3}>
      <FormItem
        className={commonStyles.formItem}
        label={label ?? L('LBL00086', 'Year')}
        labelAlign='right'
        required={required}
        render={() => (
          // 디자인 기준 높이 36px 정합 — PeriodField 와 같은 wrapper 를 쓴다.
          <div className={styles.datePickerFix}>
            <DatePickerCalendar
              usecase='year'
              elevation
              size='small'
              value={yearToDayjs(value)}
              minYear={minYear ?? bounds.minYear}
              maxYear={maxYear ?? bounds.maxYear}
              // 피커 자체 폭이 96px 고정이라 조회조건 칸을 채우려면 풀어 준다.
              sx={{ width: '100%', justifyContent: 'flex-start' }}
              onChange={
                ((date: Dayjs | null) => {
                  // 비우거나 덜 친 상태에서도 onChange 가 온다. 쓸 수 없는 값이면 직전 연도를
                  //   그대로 둔다 - yearValueOf 주석 참조(조회키·편집잠금이 4자리를 전제한다).
                  const year = yearValueOf(date);
                  if (year !== null) onChange(year);
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
// 12. BucketField (size=2, combo=BucketType — W/M filter)
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
        className={commonStyles.formItem}
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
// 13. VersionField (size=6, popup, 우측 🔍)
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
  /**
   * 조회에 실제로 나가는 VERSION_NO. 팝업이 채운 표시문(`value`)은 'VERSION_NO + 설명' 이라
   * 그 상태에서 편집을 시작하면 설명까지 조회키로 올라가 0건이 된다.
   * 이 값을 주면 포커스 순간 표시문을 코드만 남긴 상태로 되돌린다 (정본 DemandManagerForm 동일 규약).
   * 미전달 = 기존 동작(표시문 그대로 편집).
   */
  versionNo?: string;
}
export const VersionField = ({
  value,
  onOpenPopup,
  gridSize,
  label,
  emptyText,
  onValueChange,
  versionNo,
}: VersionFieldProps) => {
  const L = useL();
  // 주의: 직접 입력 가능한 경우 emptyText 를 value 로 넣지 않는다 — placeholder 성격의 문자열이
  //   실제 입력값이 되어 타이핑하면 앞에 그대로 붙는다. 편집형은 빈 값을 빈 값으로 둔다.
  const shownValue = value || (onValueChange ? '' : (emptyText ?? 'Current'));
  // 표시문이 조회키와 다를 때만(= 팝업이 설명을 붙여 둔 상태) 라벨을 푼다. 이미 코드만 있으면 무동작.
  const unlabelOnFocus =
    onValueChange && versionNo !== undefined && versionNo !== '' && shownValue !== versionNo
      ? () => onValueChange(versionNo)
      : undefined;
  return (
    <Grid size={gridSize ?? 6}>
      <FormItem
        className={commonStyles.formItem}
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
            onFocus={unlabelOnFocus}
            onOpenPopup={onOpenPopup}
          />
        )}
      />
    </Grid>
  );
};

// ====================================================================================
// 14. SearchOverRangeField (size=4, checkbox)
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
        className={commonStyles.formItem}
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
