// DMF0045 — 상위 버킷(W_/M_) 입력 → 하위 D_ 전개 (design 03 §2.4 — AS-IS 입력 시 재분배).
//   근거:
//     · design 03 §2.4: Weekly 입력 → D 분배(DefaultBucketDay), Monthly 입력 → D 분배.
//       저장(SAVE SP)은 항상 D_ 단위(§4.3) — 그래서 W_/M_ 입력분은 편집 종료 시점에 D_ 로 전개해
//       둬야 저장 조립(dmf0045.save buildUnfoldRows)이 D_ 만 수집해도 손실이 없다.
//     · 분배 알고리즘은 전사 공통 표준 @shared/lib/bucket-distribution 사용
//       (2026-07-21 확정 룰 — "신규 화면에 배분이 필요하면 본 유틸 사용"). mkt-fcst(DMF0003)/
//       sales-plan(DMF0021) 과 동일 계보이나 cross-feature import 금지라 공용 유틸만 참조한다.
//     · 하위 D_ 귀속 = "컬럼 인접(adjacency)" — dynBindings(좌→우 정렬) 에서 편집 W_/M_ 다음부터
//       다음 동급/상위 경계 전까지의 D_ 묶음 (AS-IS iCol walk 및 mkt-fcst.recalc 경계탐색과 동일).
//   적용요일 마스크(DefaultBucketDay) 소스 확정(2026-09-27 DB 실측): 콤보 SQL_ID='DefaultBucketDay'
//     = SCM_ADM_LOOKUP_MASTER_DETAIL(LOOKUP_TYPE='DEFAULT_BUCKET_DAY', SEGMENT1=divisionId,
//       SEGMENT2=MONTHLY|WEEKLY, SEGMENT3=요일코드 MON..SUN). 실데이터: 40→MON, 81*/82→FRI.
//     이 마스크가 없으면(콤보 미조회·해당 division 미등록) 공용 유틸(룰2)의 fallback(월요일, 없으면
//     첫 일자 전량)을 따른다 — 추측 마스크를 만들지 않는다. mask 는 호출측(Grid)이 콤보에서 조회해
//     dayCodeToMask 로 변환한 7비트(SUN-first)를 넘긴다.
import {
  distributeMonthToWeeks,
  distributeWeekToDays,
  type WeekOfMonth,
} from '@shared/lib/bucket-distribution';

import { dynKindOf } from './dmf0045.editLock';

// 적용요일 마스크 부재 fallback — 공용 유틸의 무마스크 동작(월요일/첫 일자) 로 위임.
const NO_APPLICABLE_MASK = '0000000';

// DefaultBucketDay 요일코드(SEGMENT3) → 공용 유틸 7비트 마스크(SUN-first, index 0=일 … 6=토).
//   공용 유틸 규약(bucket-distribution §요일 비트)과 동일 인덱스. 미인식 코드는 무마스크(fallback).
const DAY_CODE_BIT: Record<string, number> = {
  SUN: 0,
  MON: 1,
  TUE: 2,
  WED: 3,
  THU: 4,
  FRI: 5,
  SAT: 6,
};
export const dayCodeToMask = (dayCode: string | undefined | null): string => {
  const bit = DAY_CODE_BIT[String(dayCode ?? '').trim().toUpperCase()];
  if (bit === undefined) return NO_APPLICABLE_MASK;
  return '0000000'.slice(0, bit) + '1' + '0000000'.slice(bit + 1);
};

// D_yyyymmdd → JS getUTCDay (일=0..토=6). 공용 유틸 요일 규약(SUN-first)과 동일.
const dowOf = (binding: string): number => {
  const d = binding.slice(2);
  return new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8))).getUTCDay();
};

// dynBindings 에서 index 다음부터 "다음 경계(boundaryKinds 중 하나)" 전까지의 D_ binding 묶음.
//   W_ 전개: 다음 W_/M_ 경계 전까지. M_ 전개: 다음 M_ 경계 전까지(중간 W_ 는 통과).
const memberDaysAfter = (
  dynBindings: readonly string[],
  startIdx: number,
  boundaryKinds: ReadonlyArray<'M' | 'W'>
): string[] => {
  const days: string[] = [];
  for (let i = startIdx + 1; i < dynBindings.length; i++) {
    const kind = dynKindOf(dynBindings[i]);
    if (kind && boundaryKinds.includes(kind as 'M' | 'W')) break;
    if (kind === 'D') days.push(dynBindings[i]);
  }
  return days;
};

export interface RecalcResult {
  // 갱신된 D_ 셀 (binding → 정수 수량). 호출측이 row 에 set + EditTracker 재추적한다.
  updates: Array<{ binding: string; qty: number }>;
}

/**
 * 편집된 W_/M_ 셀 → 하위 D_ 전개 (총합 보존 정수 분배).
 *   @param editedBinding  편집 종료된 동적 셀 binding (W_ 또는 M_ 만 처리 — 그 외 빈 결과).
 *   @param qty            편집 후 상위 버킷 수량(정수).
 *   @param dynBindings    그리드 동적 컬럼 좌→우 정렬 목록(경계 탐색 기준).
 *   @param applicableMask DefaultBucketDay 적용요일 7비트(SUN-first). 미지정 시 월요일/첫 일자 fallback.
 *   반환 updates 는 편집 셀 하위 D_ 전량(총합 = qty).
 */
export const expandBucketToDays = (params: {
  editedBinding: string;
  qty: number;
  dynBindings: readonly string[];
  applicableMask?: string;
}): RecalcResult => {
  const { editedBinding, qty, dynBindings, applicableMask = NO_APPLICABLE_MASK } = params;
  const kind = dynKindOf(editedBinding);
  const idx = dynBindings.indexOf(editedBinding);
  if (idx < 0 || (kind !== 'W' && kind !== 'M')) return { updates: [] };

  const toDayCells = (days: string[]) => days.map(b => ({ key: b, dow: dowOf(b) }));

  if (kind === 'W') {
    // 주 → 주내 D_ (다음 W_/M_ 경계 전까지). DefaultBucketDay 마스크의 적용요일에 배분.
    const days = memberDaysAfter(dynBindings, idx, ['M', 'W']);
    if (days.length === 0) return { updates: [] };
    const dist = distributeWeekToDays(qty, toDayCells(days), applicableMask);
    return { updates: dist.map(d => ({ binding: d.key, qty: d.qty })) };
  }

  // 월 → 주별 배분(공용 유틸 룰1) → 각 주 → 주내 D_(룰2).
  //   주 귀속은 유틸 재계산 태그(W_yyyymmww ISO)가 아니라 그리드 실제 W_ 컬럼(인접)으로 잡는다 —
  //   GET_SPREAD_TITLE 의 W_ 태그 포맷(W_\d{7,10})이 유틸 ISO 포맷과 다를 수 있어(design 03 §2
  //   확인필요), 태그 문자열 매칭에 의존하면 미스매치 시 월 전량이 유실된다(anti-simplification).
  //   대신 각 W_ 의 하위 D_ 개수를 그 주의 "월내 기여 일수"로 삼아 WeekOfMonth 를 구성한다.
  const segments: Array<{ wBinding: string; days: string[] }> = [];
  for (let i = idx + 1; i < dynBindings.length; i++) {
    const k = dynKindOf(dynBindings[i]);
    if (k === 'M') break; // 다음 월 경계
    if (k === 'W') segments.push({ wBinding: dynBindings[i], days: [] });
    else if (k === 'D') {
      // W_ 하위 D_ (직전 W_ 세그먼트에 귀속). W_ 없이 D_ 가 먼저 나오면(순수 Daily) 무시.
      const seg = segments[segments.length - 1];
      if (seg) seg.days.push(dynBindings[i]);
    }
  }
  // 하위 D_ 가 있는 주만 배분 대상 — 없는 주에 qty 가 실리면 아래 전개 루프에서 유실(총합 미보존)된다.
  //   그래서 D_ 보유 세그먼트만 WeekOfMonth 로 넘겨 distributeMonthToWeeks 가 잔여까지 이 안에 담게 한다.
  const daySegments = segments.filter(s => s.days.length > 0);
  if (daySegments.length === 0) return { updates: [] };

  const weeks: WeekOfMonth[] = daySegments.map(s => ({
    key: s.wBinding,
    isoWeek: 0, // 배분에 미사용 (daysInMonth 만 사용) — 실제 W_ binding 을 key 로 둔다.
    daysInMonth: s.days.length, // 그 주가 월에 기여하는 일수 = 하위 D_ 개수(룰1 Rate 기준).
  }));
  const weekDist = distributeMonthToWeeks(qty, weeks);
  const byKey = new Map(weekDist.map(w => [w.key, w.qty]));

  const updates: Array<{ binding: string; qty: number }> = [];
  for (const seg of daySegments) {
    const dist = distributeWeekToDays(
      byKey.get(seg.wBinding) ?? 0,
      toDayCells(seg.days),
      applicableMask
    );
    dist.forEach(d => updates.push({ binding: d.key, qty: d.qty }));
  }
  return { updates };
};
