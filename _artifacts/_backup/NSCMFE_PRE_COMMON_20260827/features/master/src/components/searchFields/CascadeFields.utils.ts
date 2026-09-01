// ====================================================================================
// CascadeFields 공용 정의 — 단계 카탈로그 / 타입 / helper
//
// 컴포넌트 파일과 분리해 둔다: 컴포넌트를 export 하는 파일이 상수나 함수까지 같이 export 하면
// react-refresh/only-export-components 가 걸린다 (SearchFields.utils.ts 와 같은 이유).
// ====================================================================================

// ====================================================================================
// 단계 카탈로그
// ====================================================================================
/**
 * 등록된 cascade 단계. code/name 은 그 단계가 콤보에서 읽는 컬럼이며, 몇 번째 단계로 쓰이든
 * 항상 이 이름 그대로다. 마지막 단계만 CODE / NAME 으로 읽던 규약은 없앴다 - 콤보 SQL 은
 * 전 단계를 풀네임 컬럼으로 내려준다.
 *
 * 신규 단계는 여기 한 줄 추가하면 된다. 콤보 SQL 이 같은 이름으로 컬럼을 내려주면 그대로 붙고,
 * 다르면 호출부가 levels 항목에 columns 를 직접 넘겨 덮는다.
 *
 * multiple 과 allOption 은 따로 둔다 - 다중선택은 아니지만 전체(ALL) 선택은 허용하는 단계가
 * 있기 때문이다 (senderCode). allOption 은 clear 아이콘 노출 여부도 겸하며, 필수 단일선택인
 * division 만 false 다.
 */
export const CASCADE_LEVELS = {
  division: {
    code: 'DIVISION_CODE',
    name: 'DIVISION_NAME',
    labelCode: 'LBL00001',
    labelEn: 'Div',
    multiple: false,
    allOption: false,
    required: true,
  },
  team: {
    code: 'TEAM_CODE',
    name: 'TEAM_NAME',
    labelCode: 'LBL00502',
    labelEn: 'Team',
    multiple: true,
    allOption: true,
    required: false,
  },
  endCustomer: {
    code: 'END_CUSTOMER_CODE',
    name: 'END_CUSTOMER_NAME',
    labelCode: 'LBL00503',
    labelEn: 'End Customer',
    multiple: true,
    allOption: true,
    required: false,
  },
  salesSite: {
    code: 'SALES_SITE_CODE',
    name: 'SALES_SITE_NAME',
    labelCode: 'LBL00506',
    labelEn: 'Sales Site',
    multiple: true,
    allOption: true,
    required: false,
  },
  // Div - Team - Sold-To Customer 로 이어지는 가지. Sales Site 와는 다른 콤보('SoldCustomer')에서
  // 뽑으므로 상위 단계(division / team)를 같은 field 로 맞춰 한 화면에서 두 벌을 같이 쓴다.
  // 컬럼은 그 콤보 SQL 에 맞춰 SOLD_CUSTOMER_CODE / SOLD_CUSTOMER_NAME 이다.
  soldToCustomer: {
    code: 'SOLD_CUSTOMER_CODE',
    name: 'SOLD_CUSTOMER_NAME',
    labelCode: 'LBL00081',
    labelEn: 'Sold-To Customer',
    multiple: true,
    allOption: true,
    required: false,
  },
  plantSite: {
    code: 'PLANT_SITE_CODE',
    name: 'PLANT_SITE_NAME',
    labelCode: 'LBL00509',
    labelEn: 'Plant Site',
    multiple: true,
    allOption: true,
    required: false,
  },
  bizType: {
    code: 'BIZ_TYPE_CODE',
    name: 'BIZ_TYPE_NAME',
    labelCode: 'LBL00504',
    labelEn: 'Biz.Type',
    multiple: true,
    allOption: true,
    required: false,
  },
  // 단일선택이지만 전체(ALL)는 허용한다 - 종전 MktFcstForm 인라인 Sender Code 콤보와 같은 모양.
  senderCode: {
    code: 'SENDER_CODE',
    name: 'SENDER_NAME',
    labelCode: 'LBL00090',
    labelEn: 'Sender Code',
    multiple: false,
    allOption: true,
    required: false,
  },
} as const;

export type CascadeLevelKey = keyof typeof CASCADE_LEVELS;

/**
 * value 로 넘긴 스토어 객체의 문자열 키. field 를 이 union 으로 좁혀 두면
 * 오타난 필드명이 컴파일 단계에서 잡힌다.
 *
 * 스토어 조회조건 타입은 대개 interface 라 Record<string, string> 에 대입되지 않는다
 * (implicit index signature 가 없다). 그래서 value 를 Record 로 받지 않고 제네릭으로 둔다.
 */
export type FieldOf<V> = Extract<keyof V, string>;

/** levels 항목. 키만 주면 기본값을 쓰고, 객체로 주면 화면별로 덮는다. */
export interface CascadeLevelSpec<F extends string = string> {
  key: CascadeLevelKey;
  /**
   * 이 단계 값이 담기는 스토어 필드명. 미지정 시 key 를 그대로 쓴다.
   * value 를 읽고 onChange 로 되돌려줄 때의 키가 되므로, 지정해두면 호출부가
   * setSearchParams(next) 한 줄로 끝난다.
   */
  field?: F;
  /** 라벨 직접 지정 (i18n 기본 라벨과 다른 문구를 쓰는 화면 전용). */
  label?: string;
  /** 콤보 컬럼명 직접 지정. 콤보 SQL 이 표준 규약과 다른 이름을 쓸 때만. */
  columns?: { code: string; name: string };
  disabled?: boolean;
  gridSize?: number;
}

/** useCascadeFields / CascadeFields 공통 입력. */
export interface UseCascadeFieldsOptions<V extends object> {
  /** 조인된 평면 콤보 1건의 등록 ID (SCM_ADM_CMBO_SQL_M). */
  comboId: string;
  /** 화면에 렌더할 단계와 순서. 배열 순서가 곧 cascade 순서다. */
  levels: (CascadeLevelKey | CascadeLevelSpec<FieldOf<V>>)[];
  /** 조회조건 스토어 객체. 단계 field(미지정 시 key)로 선택값을 읽는다. */
  value: V;
  /**
   * 바뀐 단계 + 그 아래 전 단계(초기화)를 담은 부분 객체.
   * 스토어가 partial merge 라 그대로 setSearchParams(next) 하면 된다.
   *
   * 값 모양은 스토어 필드 타입을 따라간다 — 문자열 필드면 문자열('ALL'),
   * 배열 필드면 배열([])이다. writeValue / blankValue 참조.
   */
  onChange: (next: Partial<V>, changed: CascadeLevelKey) => void;
  /** 전 단계 공통 Grid size. 단계별로 다르게 주려면 levels 항목의 gridSize 로 덮는다. */
  gridSize?: number;
  /** 콤보 조회 자체를 막을 때. */
  enabled?: boolean;
  /**
   * 임시 로컬 디버그 — 넘기면 콤보 원본 컬럼 목록과 단계별 잔여 행 수가 콘솔에 찍힌다.
   * 목록이 비는 사고의 대부분은 콤보 SQL 컬럼명이 규약과 달라 첫 단계에서 전 행이 잘리는 경우다.
   * SearchFields.debug 참조. 확인이 끝나면 호출부에서 지운다.
   */
  debugLabel?: string;
}

export type CascadeFieldsProps<V extends object> = UseCascadeFieldsOptions<V>;

// ====================================================================================
// helpers
// ====================================================================================
export type Row = Record<string, unknown>;

/** 조회조건 스토어 한 필드가 담을 수 있는 값. 배열은 다중선택 조회조건(MktFcst 계열)이다. */
export type FieldValue = string | number | boolean | string[] | null | undefined;

/**
 * 콤보 셀 값 읽기. 콤보 응답은 컬럼에 따라 NUMBER 로 내려오기도 해서 문자열로 맞춰야
 * Set 비교가 성립한다 (SearchFields.cellValue 와 같은 사정).
 */
export const cell = (row: Row, column: string): string => {
  const raw = row[column] as string | number | null | undefined;
  return raw === null || raw === undefined ? '' : String(raw).trim();
};

/**
 * 선택값 문자열 -> 실제 코드 Set. 남는 값이 없으면 null = 필터 미적용.
 * CustomDropdown 은 전체선택을 'ALL', 전체해제를 '' 로 내보내고 둘은 필터상 같다.
 */
export const toCodeSet = (v?: string): Set<string> | null => {
  const cleaned = (v ?? '')
    .split(',')
    .map(s => s.trim())
    .filter(s => s !== '' && s.toUpperCase() !== 'ALL');
  return cleaned.length > 0 ? new Set(cleaned) : null;
};

export const normalizeLevel = (input: CascadeLevelKey | CascadeLevelSpec): CascadeLevelSpec =>
  typeof input === 'string' ? { key: input } : input;

/**
 * 스토어 객체에서 한 단계 선택값 읽기.
 * 제네릭 V 를 문자열 키로 인덱싱해야 해서 여기서만 캐스팅한다 — 밖으로는 FieldOf<V> 로 좁혀 둬서
 * 호출부가 넘기는 field 이름 자체는 컴파일 단계에서 검증된다.
 * 조회조건 값은 문자열이지만 스토어 타입이 제네릭이라 원시 타입으로 좁혀 캐스팅한다 —
 * unknown 인 채로 String() 을 태우면 객체가 섞였을 때 '[object Object]' 가 나와 린트가 막는다.
 */
export const readValue = (source: object, field: string): string => {
  const raw = (source as Record<string, FieldValue>)[field];
  if (raw === null || raw === undefined) return '';
  return Array.isArray(raw) ? raw.join(',') : String(raw);
};

/** 이 필드가 배열로 담기는가. 스토어 필드 타입은 런타임에 바뀌지 않으므로 값으로 판정해도 안전하다. */
const isArrayField = (source: object, field: string): boolean =>
  Array.isArray((source as Record<string, FieldValue>)[field]);

/**
 * 스토어 필드 타입에 맞춘 쓰기 값.
 *
 * 화면마다 조회조건을 문자열로 들기도 하고(SalesSiteProjectModel: deptId: string)
 * 배열로 들기도 한다(MktFcst: deptIds: string[]). 읽을 때 join 으로 폈으니 쓸 때도 원래 모양으로
 * 되돌려야 스토어 타입이 안 깨진다.
 *
 * 주의: 'ALL' 을 빈 값으로 바꾸지 않는다. CustomDropdown 은 전체선택을 'ALL' sentinel 로
 * 내보내고 그 값이 그대로 돌아와야 전체 체크 표시가 유지된다. 배열이면 ['ALL'] 로 담긴다.
 */
export const writeValue = (source: object, field: string, raw: string): FieldValue =>
  isArrayField(source, field) ? raw.split(',').filter(Boolean) : raw;

/** 하위 단계 초기화 값 — 배열 필드면 빈 배열, 문자열 필드면 'ALL'. 둘 다 필터 미적용이다. */
export const blankValue = (source: object, field: string): FieldValue =>
  isArrayField(source, field) ? [] : 'ALL';
