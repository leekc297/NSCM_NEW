import { BUCKET_TYPE, GUBUN, type Gubun } from '../demand-plan-waterfall-01.constants';

import { bucketKindOf, dynKindOf, rankOf } from './waterfall.periods';

export interface HeaderDrillInput {
  gubun: Gubun;
  /** 현재 조회조건 bucket (AS-IS fBucket — 조회 시점 버킷) */
  bucket: string;
  /** 화면에 등록된 기간 컬럼 binding — TITLE SP SORT_ORDER_NO 순서 그대로 (AS-IS 스프레드 컬럼 순서) */
  dynBindings: string[];
  /** 현재 표시 상태 */
  isVisible: (binding: string) => boolean;
  /** 더블클릭된 헤더의 leaf binding */
  clicked: string;
  /** 조회조건 Sum 체크 — ON 이면 bucket 단계도 접어 합계로 요약할 수 있다 */
  isSumChecked?: boolean;
}

/**
 * BIZ 상위 헤더(1단 연도, 2단 분기) 클릭을 그 묶음의 합계 binding 으로 바꾼다.
 * hitTest 는 머지 원점이 아니라 커서 아래 물리 컬럼(대개 M_)을 주기 때문이다(BusinessPlanGrid 선례).
 * 머지 좌단 대신 binding 에서 직접 산출해, Sum OFF 로 Y_/Q_ 가 숨은 상태에서도 연도/분기로 확정된다.
 *   1단 = Y_{연도} / 2단 = M_ 이면 소속 Q_{연도}_{분기}, Y_·Q_ 는 그대로 / leaf 행 = 물리 컬럼 그대로
 */
export const resolveBizHeaderBinding = (
  physical: string,
  headerRow: number,
  leafRow: number,
  dynBindings: string[]
): string => {
  const kind = dynKindOf(physical);
  if (!kind || headerRow >= leafRow) return physical;
  const year = physical.slice(2, 6);
  const pick = (b: string): string => (dynBindings.includes(b) ? b : physical);
  if (headerRow === 0) return pick(`Y_${year}`);
  if (kind === 'M') return pick(`Q_${year}_${Math.ceil(Number(physical.slice(6, 8)) / 3)}`);
  return physical;
};

/**
 * 헤더 더블클릭 드릴다운 — AS-IS `spdMain_CellDoubleClick(e.ColumnHeader)` 1:1.
 *
 * MKT·SALES (DMF0035 .cs:1632-1680 / DMF0022 .cs:1700-1748)
 *   M_ 클릭 : 클릭 컬럼부터 순회하며 W_ 토글 / D_ 는 보이면 접기만 /
 *             (bucket<>DAILY) M_ 은 숨겨져 있으면 펼침 → 다음 컬럼이 M_ 이면 중단
 *   W_ 클릭 : D_ 토글 → 다음 컬럼이 W_ 이면 중단
 *
 *   [E20261109-ALLBUCKET] AS-IS 는 D_ 처리를 bucket=DAILY 로 제한했으나, PKG_DMF0022 가
 *   WEEKLY/MONTHLY 에서도 기간 컬럼 900개 이하이면 D_ 를 내려준다(F_DAILY_YN, 2026-11-09 DB 반영).
 *   그래서 bucket 조건을 빼고 "D_ 컬럼이 있으면 펼친다"로 바꿨다. D_ 가 없으면(초과 기간, MKT) 순회해도
 *   걸리는 컬럼이 없어 기존 동작과 같다.
 *
 * BIZ — Business Plan(DMF0042, BusinessPlanGrid dblclickHandler) 동작으로 맞춘다 (사용자 지시 2026-11-10).
 *   AS-IS DMF0051 로직(M_ 클릭부터 연말까지 M_ 접기·Q_ 토글)은 TITLE SP 순서(Y_ → Q_ → M_ M_ M_)에서
 *   클릭 월 앞의 Q_/Y_ 를 못 건드려, 연도 전체가 사라지고 다시 펼 헤더가 없어지는 결함이 있었다.
 *   Y_ 클릭 : 그 연도(다음 Y_ 전까지)의 Q_ 토글 + 열린 M_ 접기
 *   Q_ 클릭 : 그 분기(다음 Q_/Y_ 전까지)의 M_ 토글
 *   M_ 클릭 : 동작 없음
 *   Y_/Q_ 합계 컬럼 자체는 드릴로 건드리지 않는다 — 표시 여부는 조회조건 Sum 체크박스가 정한다.
 *
 * 공통 규칙 (사용자 지시 2026-11-10):
 *   Sum ON  : 위 규칙 그대로 — bucket 단계도 접혀 합계(상위 컬럼)로 요약되고, 다시 누르면 펼친다.
 *   Sum OFF : 조회 bucket 보다 **세부 단계만** 펼치고 접는다. 합계가 숨어 있어 bucket 단계를 접으면
 *             묶음이 통째로 사라지기 때문이다 → MKT·SALES Daily, BIZ Monthly 는 더블클릭해도 변화 없음.
 *
 * @returns 바꿀 binding → 새 visible 값 (대상 없으면 빈 Map)
 */
const collectDrillPatch = ({
  gubun,
  bucket,
  dynBindings,
  isVisible,
  clicked,
}: HeaderDrillInput): Map<string, boolean> => {
  const patch = new Map<string, boolean>();
  const start = dynBindings.indexOf(clicked);
  if (start < 0) return patch;

  const clickedKind = dynKindOf(clicked);
  const nextKind = (i: number): string | null =>
    i + 1 < dynBindings.length ? dynKindOf(dynBindings[i + 1]) : null;
  const flip = (b: string): void => {
    patch.set(b, !isVisible(b));
  };

  if (gubun === GUBUN.BIZ_PLAN) {
    if (clickedKind !== 'Y' && clickedKind !== 'Q') return patch;
    for (let i = start + 1; i < dynBindings.length; i += 1) {
      const b = dynBindings[i];
      const k = dynKindOf(b);
      if (clickedKind === 'Y') {
        if (k === 'Y') break;
        if (k === 'Q') flip(b);
        else if (k === 'M' && isVisible(b)) patch.set(b, false);
      } else {
        if (k === 'Q' || k === 'Y') break;
        if (k === 'M') flip(b);
      }
    }
    return patch;
  }

  const isDaily = bucket === BUCKET_TYPE.DAILY;
  if (clickedKind === 'M') {
    for (let i = start; i < dynBindings.length; i += 1) {
      const b = dynBindings[i];
      const k = dynKindOf(b);
      if (k === 'W') flip(b);
      else if (k === 'D') {
        if (isVisible(b)) patch.set(b, false);
      } else if (k === 'M' && !isDaily) {
        if (!isVisible(b)) patch.set(b, true);
      }
      if (nextKind(i) === 'M') break;
    }
  } else if (clickedKind === 'W') {
    for (let i = start; i < dynBindings.length; i += 1) {
      const b = dynBindings[i];
      if (dynKindOf(b) === 'D') flip(b);
      if (nextKind(i) === 'W') break;
    }
  }
  return patch;
};

/** 위 규칙 진입점 — Sum OFF 면 collectDrillPatch 결과에서 조회 bucket 보다 세부 단계만 남긴다. */
export const walkHeaderDrill = (input: HeaderDrillInput): Map<string, boolean> => {
  if (input.isSumChecked) return collectDrillPatch(input);
  const activeRank = rankOf(input.gubun, bucketKindOf(input.gubun, input.bucket));
  const patch = new Map<string, boolean>();
  if (activeRank === null) return patch;
  collectDrillPatch(input).forEach((visible, binding) => {
    const rank = rankOf(input.gubun, dynKindOf(binding));
    if (rank !== null && rank > activeRank) patch.set(binding, visible);
  });
  return patch;
};
