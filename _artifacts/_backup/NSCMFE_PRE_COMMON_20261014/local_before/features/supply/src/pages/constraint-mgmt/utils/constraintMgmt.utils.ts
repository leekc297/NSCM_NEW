import type { RawFlexGridColumnConfig } from '@foundation/models';

import {
  DISPLAY_SEQ_MAX,
  DISPLAY_SEQ_PATTERN,
  DUPLICATE_KEY_COLUMNS,
  type ActiveGrid,
} from '../constraint-mgmt.constants';
import type {
  DetailRow,
  DynamicSubColumn,
  MasterRow,
  SearchParamProps,
} from '../constraint-mgmt.types';

/**
 * Main 신규행 기본값 — AS-IS 는 VALID_YN='Y' 1건만 세팅한다(cs:811~815, G-22).
 * LOOKUP_TYPE_KEY 는 빈 값으로 보낸다: 저장 커서가 NVL(TRIM(LOOKUP_TYPE_KEY), TRIM(LOOKUP_TYPE))
 * 로 보정하므로 신규행은 키를 만들 필요가 없다(PKG 커서 L8).
 */
export const EMPTY_MASTER_ROW = {
  LOOKUP_TYPE_KEY: '',
  LOOKUP_TYPE: '',
  DESCRIPTION: '',
  LOOKUP_GROUP: '',
  VALID_YN: 'Y',
  SEGMENT1: '',
  SEGMENT2: '',
  SEGMENT3: '',
  SEGMENT4: '',
  SEGMENT5: '',
  SEGMENT6: '',
  SEGMENT7: '',
  SEGMENT8: '',
  SEGMENT9: '',
  SEGMENT10: '',
  ATTRIBUTE1: '',
  ATTRIBUTE2: '',
  ATTRIBUTE3: '',
  ATTRIBUTE4: '',
  ATTRIBUTE5: '',
  ATTRIBUTE6: '',
  ATTRIBUTE7: '',
  ATTRIBUTE8: '',
  ATTRIBUTE9: '',
  ATTRIBUTE10: '',
  ATTRIBUTE11: '',
  ATTRIBUTE12: '',
  ATTRIBUTE13: '',
  ATTRIBUTE14: '',
  ATTRIBUTE15: '',
  CREATED_BY: '',
  CREATION_DATE: '',
  LAST_UPDATED_BY: '',
  LAST_UPDATE_DATE: '',
} as const satisfies MasterRow;

/**
 * Sub 신규행 기본값 — AS-IS 12건(LOOKUP_TYPE=선택 마스터 키 + SEGMENT1~10='-' + VALID_YN='Y',
 * cs:822~836). LOOKUP_TYPE 은 Insert 시점에 mainLookupType 으로 덮어쓴다.
 * DISPLAY_SEQ 는 빈 값으로 둔다 — AS-IS 기본값에도 없고, 저장 시 sanitizeDetailRow 가 빈 값을
 * '0' 으로 보정(cs:674)하고 SP 정수 검사(PKG L813)도 통과하므로 화면에는 공백으로 보인다.
 * SEGMENT*_KEY 는 신규행에서 쓰이지 않고 커서가 '-' 로 보정한다(PKG L92~101).
 */
export const EMPTY_DETAIL_ROW = {
  LOOKUP_TYPE: '',
  DESCRIPTION: '',
  DISPLAY_SEQ: '',
  SEGMENT1: '-',
  SEGMENT2: '-',
  SEGMENT3: '-',
  SEGMENT4: '-',
  SEGMENT5: '-',
  SEGMENT6: '-',
  SEGMENT7: '-',
  SEGMENT8: '-',
  SEGMENT9: '-',
  SEGMENT10: '-',
  SEGMENT1_KEY: '',
  SEGMENT2_KEY: '',
  SEGMENT3_KEY: '',
  SEGMENT4_KEY: '',
  SEGMENT5_KEY: '',
  SEGMENT6_KEY: '',
  SEGMENT7_KEY: '',
  SEGMENT8_KEY: '',
  SEGMENT9_KEY: '',
  SEGMENT10_KEY: '',
  VALID_YN: 'Y',
  ATTRIBUTE1: '',
  ATTRIBUTE2: '',
  ATTRIBUTE3: '',
  ATTRIBUTE4: '',
  ATTRIBUTE5: '',
  ATTRIBUTE6: '',
  ATTRIBUTE7: '',
  ATTRIBUTE8: '',
  ATTRIBUTE9: '',
  ATTRIBUTE10: '',
  ATTRIBUTE11: '',
  ATTRIBUTE12: '',
  ATTRIBUTE13: '',
  ATTRIBUTE14: '',
  ATTRIBUTE15: '',
  CREATED_BY: '',
  CREATION_DATE: '',
  LAST_UPDATED_BY: '',
  LAST_UPDATE_DATE: '',
} as const satisfies DetailRow;

/**
 * 행 모양은 느슨하게 둔다 — 비교 모집단은 그리드 sourceCollection(WijmoRowItem, 인덱스 시그니처)
 * 에서 오고 검사 대상은 saveWithValidation 콜백의 payload 라 둘 다 받아야 한다.
 * 주의: 11키만 뽑은 Pick/mandatory-optional 매핑 타입으로 좁히면 "모든 속성이 optional" 인
 * weak type 이 되어 인덱스 시그니처 소스가 '공통 속성 없음'(TS2345)으로 거부된다.
 * 실제 키 목록은 DUPLICATE_KEY_COLUMNS 가, 정규화는 buildDuplicateKey 의 String() 이 담당한다.
 */
type DuplicateCheckRow = Record<string, WijmoPrimitive | undefined>;

const buildDuplicateKey = (row: DuplicateCheckRow): string =>
  DUPLICATE_KEY_COLUMNS.map(col => String(row[col] ?? '').toUpperCase()).join('||');

/**
 * 중복검증 — AS-IS CheckValidation(cs:938~1009) 과 같은 11키(LOOKUP_TYPE + SEGMENT1~10)를
 * 대소문자 무시로 비교한다. Main·Sub 가 같은 키를 쓴다(AS-IS 가 같은 CheckValidation(spd) 공유).
 *
 * 필수: 검사 대상(targets)과 비교 모집단(population)은 다른 집합이다. AS-IS 는 바깥 루프만
 * I/M/D 로 좁히고 안쪽 루프(cs:966)에는 action 필터가 없다 — 변경행을 시트에 실린 전 행과
 * 대조한다. 변경행끼리만 비교하면 기존 행과 같은 키의 신규행이 SP 까지 흘러가 ORA-00001 이
 * 뜨고, 저장 SP 의 SAVEPOINT 롤백으로 같은 배치의 정상 편집분까지 함께 실패한다(MSG00060 대신
 * DB 원문이 노출된다).
 *
 * 자기 자신 제외(cs:968 `if (i == j) continue;`)는 모집단 키 카운트 2건 이상으로 대신한다 —
 * targets 는 population 의 부분집합이다(둘 다 그리드 소스에서 읽고, sanitizeDetailRow 가 만드는
 * 복사본도 11키는 원본과 같다). 같은 키가 2건 이상이면 자기 말고 같은 키의 행이 더 있다는 뜻이다.
 */
export const findDuplicateRow = <T extends DuplicateCheckRow>(
  targets: T[],
  population: readonly DuplicateCheckRow[]
): T | null => {
  const counts = new Map<string, number>();
  for (const row of population) {
    const key = buildDuplicateKey(row);
    counts.set(key, (counts.get(key) ?? 0) + 1);
  }
  for (const row of targets) {
    if ((counts.get(buildDuplicateKey(row)) ?? 0) >= 2) return row;
  }
  return null;
};

/**
 * DISPLAY_SEQ 사전 가드 — SP 가 REGEXP_LIKE 불통과·범위밖에 ORA-20002 를 던지므로 FE 가 먼저 막는다.
 * 선언 타입은 string 이지만 Oracle NUMBER 가 런타임에 number 로 내려오므로 String() 으로 감싼다
 * (문자열 메서드를 직접 부르면 TypeError 가 저장 핸들러 밖으로 던져져 무반응이 된다).
 * 빈 값은 저장 커서가 '0' 으로 보정하므로 통과시킨다.
 */
export const isValidDisplaySeq = (value: WijmoPrimitive | undefined): boolean => {
  const text = String(value ?? '').trim();
  if (text === '') return true;
  if (!DISPLAY_SEQ_PATTERN.test(text)) return false;
  return Math.abs(Number(text)) <= DISPLAY_SEQ_MAX;
};

/** DISPLAY_SEQ 빈 값을 '0' 으로 채운다(AS-IS cs:674~675 와 동형). 값 타입은 원본 그대로 둔다. */
export const sanitizeDetailRow = (row: DetailRow): DetailRow => {
  const displaySeq = String(row.DISPLAY_SEQ ?? '').trim();
  return displaySeq === '' ? { ...row, DISPLAY_SEQ: '0' } : row;
};

interface PlanGroupFilterArgs {
  isAdmin: boolean;
  /** 동적 라벨이 'PLAN_GROUP' 인 컬럼. 없으면 필터 미적용(AS-IS cs:476~479 exact match). */
  planGroupColumn: DynamicSubColumn | '';
  /** 조회조건에서 체크한 Plan Group NAME 들. */
  picked: string[];
  /** 콤보 응답 전건의 NAME = 내가 Owner 인 Plan Group 전체. */
  owned: string[];
}

/**
 * Sub 결과셋 Plan Group 권한 필터 (AS-IS F-01, cs:483~529).
 *
 * TO-BE SP 에 파라미터가 없어(P_SCP0120_GET_LOOKUP_DETAIL IN = lookupType 1개) FE 재현이
 * 유일한 등가 경로다. 빠지면 비관리자에게 남의 Plan Group 행이 보인다 = 권한 결함.
 *
 * 비교 축은 CODE 가 아니라 NAME 이다 — 원장 컬럼에 들어 있는 값이 OPMZ_PLAN_GR_NAME 이라
 * CODE(PG0024 등)로 비교하면 매칭 0건이 되어 비관리자 그리드가 통째로 빈다.
 *
 * 미선택(picked 0건)은 "필터 없음"이 아니라 "내 Owner 전체"다. 0건 매칭이면 빈 그리드가
 * 정상 동작이며 전건 폴백을 하지 않는다.
 *
 * 비교는 대소문자 무시다 — AS-IS 는 DBUtils.Filter(=DataTable.Select, CaseSensitive 기본 false)
 * 로 걸러 CI 다. JS 엄격비교로 두면 원장 NAME 과 콤보 NAME 의 표기 차이(예 Micro_cyl vs
 * Micro_Cyl)로 소유자에게 자기 데이터가 사라진다. 같은 파일 buildDuplicateKey 와 동형으로 접는다.
 */
export const filterDetailRowsByPlanGroup = (
  rows: DetailRow[],
  { isAdmin, planGroupColumn, picked, owned }: PlanGroupFilterArgs
): DetailRow[] => {
  if (isAdmin) return rows;
  if (!planGroupColumn) return rows;
  const normalize = (value: WijmoPrimitive | undefined): string =>
    String(value ?? '').trim().toUpperCase();
  const allow = new Set((picked.length > 0 ? picked : owned).map(normalize));
  return rows.filter(row => allow.has(normalize(row[planGroupColumn])));
};

/**
 * Sub 컬럼 메타에 동적 3축(숨김/라벨/필수 `*`)을 얹은 파생 컬럼셋.
 *
 * 필수: 이 함수의 결과는 DataGrid 렌더와 `saveWithValidation` 이 **같은 것을 써야 한다**.
 * 파생을 그리드 컴포넌트 안에만 두면 저장 검증에는 `*` 없는 원본 메타가 넘어가
 * `isMandatoryColumn`(inputTpCd='O' + 라벨 `*` 없음)이 전건 false 가 되고, 헤더에 빨간 점은
 * 찍히는데 빈 값이 그대로 저장되는 상태가 된다(AS-IS DataUtil.checkRequiredOfSpread 무력화).
 *
 * visible 은 `hidden ? false : (col.visible ?? true)` 로 계산한다 — 동적 라벨이 붙었다고
 * 메타의 숨김을 깨면 안 된다. Sub SEGMENT10 은 마스터 Admin 플래그(Y/N)라 '-' 가 아니어서
 * 라벨이 'Y*'/'N*' 로 바뀌지만, VISIBLE_FLAG='N' 이라 이 식이 계속 숨김으로 유지한다.
 * (숨긴 컬럼은 `useSaveWithValidation` 이 필수검증 대상에서 빼므로 저장이 막히지도 않는다.)
 */
export const buildDynamicDetailColumns = (
  baseColumns: RawFlexGridColumnConfig[],
  dynamicColumnLabels: Record<string, string>,
  hiddenSubColumns: Record<string, true>
): RawFlexGridColumnConfig[] =>
  baseColumns.map(col => {
    const field = col.colNm;
    if (!field) return col;
    const overriddenLabel = dynamicColumnLabels[field];
    const hidden = !!hiddenSubColumns[field];
    const visible = hidden ? false : (col.visible ?? true);
    if (overriddenLabel === undefined && visible === (col.visible ?? true)) return col;
    return {
      ...col,
      ...(overriddenLabel !== undefined ? { colLblNm: overriddenLabel } : {}),
      visible,
    };
  });

/**
 * F6 로 서버에 저장한 조회조건(paramNm/paramCtn)을 searchParams 로 되돌린다.
 *
 * 스토어(createPersistedStoreWithTab)는 새로고침 시 영속화하지 않으므로, F6 저장분을 다시
 * 띄우는 유일한 경로는 진입 시 GET /admin/menu/SCP0120/search-conditions 복원이다(다른 화면과
 * 동형). 종전엔 이 복원이 없어 저장은 성공해도 새로고침하면 init 기본값으로 돌아갔다.
 *
 * personalizeCondition 이 배열을 콤마로 접어 저장하고 저장 SP 가 빈 값을 skip 하므로,
 * planGroupNames 는 콤마로 분해하고 저장되지 않은 키는 init 기본값을 그대로 유지한다.
 */
export const buildSearchParamsFromSaved = (
  saved: readonly { paramNm: string; paramCtn: string }[],
  init: SearchParamProps
): SearchParamProps => {
  const map = new Map(saved.map(row => [row.paramNm, row.paramCtn]));
  const next: SearchParamProps = { ...init };
  const lookupType = map.get('lookupType');
  if (lookupType !== undefined) next.lookupType = lookupType;
  const validYn = map.get('validYn');
  if (validYn !== undefined) next.validYn = validYn;
  const planGroupNames = map.get('planGroupNames');
  if (planGroupNames !== undefined)
    next.planGroupNames = planGroupNames.split(',').filter(value => value !== '');
  return next;
};

export interface SaveTarget {
  target: ActiveGrid;
  /** 저장 대상이 아닌 영역에도 변경분이 남는가 (사용자에게 알려야 한다). */
  otherHasChanges: boolean;
}

/**
 * 저장 대상은 포커스가 아니라 변경분이 있는 영역으로 정한다.
 *
 * AS-IS 는 fps.Name(마지막 클릭 그리드)만 봤다(cs:543·651). 그래서 하단에 행을 넣고 상단을
 * 한 번 클릭한 뒤 저장하면 상단이 대상이 되어, 상단에 변경이 없으면 "No changes to save."가
 * 뜨고 하단 신규행은 조용히 남는다. 판정 기준인 CRUD_TYPE 은 행 앞 상태표시(I/M/D)와 같은
 * 값이라, 표시가 보이는 영역이 곧 저장 대상이 된다.
 *
 * 양쪽 다 변경분이 있으면 한 번에 한 영역만 저장되므로(저장 SP 가 시트별로 갈린다) 포커스를
 * 쓰되 otherHasChanges 로 남는 쪽이 있음을 알린다. Insert/Delete 는 선택 행에 작용하므로
 * 종전대로 activeGrid 를 따른다 — 저장만 다르다.
 */
export const pickSaveTarget = (
  masterDirtyCount: number,
  detailDirtyCount: number,
  activeGrid: ActiveGrid
): SaveTarget => {
  if (masterDirtyCount > 0 && detailDirtyCount > 0) {
    return { target: activeGrid, otherHasChanges: true };
  }
  if (detailDirtyCount > 0) return { target: 'sub', otherHasChanges: false };
  return { target: 'main', otherHasChanges: false };
};
