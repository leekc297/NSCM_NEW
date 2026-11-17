// SCP0025 pivot 파생 순수 함수 — read-only 화면이라 편집 롤업(SUM 재집계)은 없다.
//   isoWeek: 3단 헤더 주 span 라벨/그룹핑용. mergeFixReason: O_RC2(Fix Reason 상세)를 Fix Reason 행 D_ 셀에 매핑.

import { MEASURE_FIX_REASON } from '../shipment-plan-fix.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// ISO 8601 주차 (월요일 기준) — 3단 헤더 주 span 라벨/그룹핑용 (자매 SCP0024 isoWeek 동일).
export const isoWeek = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

// 행 키 컬럼 — AS-IS Set_FixReason(cs:664 FG / cs:688 SEMI) 정확 정합. O_RC1(Fix Reason 행)과 O_RC2(상세)를
//   아래 키로 매칭한다(대소문자 무시 getCI). INCOTERMS 가 '-' 면 SEMI(incoterms/project_code 제외), 아니면 FG.
//   ⚠️ AS-IS 는 ORIGIN_FROM/TO_DIVISION_ID·ELECTRODE_TYPE 를 매칭 키에 쓰지 않는다 — 과거 이를 키에 추가해
//     O_RC1/O_RC2 간 이 값 차이(실측: div 81 lane ORIGIN_TO='81' vs O_RC1 측 값 상이)로 매칭이 깨져 사유가
//     전혀 안 떴다(2026-10-01). AS-IS 처럼 TRANSPORT_MODE·LT_TOTAL(BOD 종속, BOD_ID 와 동일값)만 포함한다.
const FG_KEYS = [
  'DIVISION_ID', 'BIZ_TYPE', 'ITEM_ID', 'TO_SITE', 'FROM_SITE',
  'INCOTERMS', 'PROJECT_CODE', 'TRANSPORT_MODE', 'LT_TOTAL', 'BOD_ID',
];
const SEMI_KEYS = [
  'DIVISION_ID', 'BIZ_TYPE', 'ITEM_ID', 'TO_SITE', 'FROM_SITE',
  'TRANSPORT_MODE', 'LT_TOTAL', 'BOD_ID',
];

// 케이스 무시 컬럼 읽기 — O_RC1(소문자 alias)·O_RC2(문서상 대문자)의 케이스 차이를 흡수한다.
export const getCI = (row: Row, name: string): unknown => {
  if (name in row) return row[name];
  const lower = name.toLowerCase();
  const upper = name.toUpperCase();
  if (lower in row) return row[lower];
  if (upper in row) return row[upper];
  const hit = Object.keys(row).find(k => k.toLowerCase() === lower);
  return hit ? row[hit] : undefined;
};

// AS-IS 와 동일하게 FG/SEMI 로 키 컬럼을 가른다(INCOTERMS '-' = SEMI). 구분자 '|' 로 조인(값 이어붙음 충돌 방지).
//   reasonByKey 구성(O_RC2)·조회(O_RC1 Fix Reason 행) 양쪽이 같은 함수를 쓰므로 같은 lane 은 같은 키가 된다.
//   export: Unfix 수집(shipmentPlanFixSave)이 Fix Reason 행 선택을 같은 lane 의 Ship Plan 행으로 되찾을 때도 이 키를 쓴다
//   (Ship Plan·Fix Reason 두 measure 행은 같은 lane → 같은 rowKey).
export const rowKey = (row: Row): string =>
  (s(getCI(row, 'INCOTERMS')) === '-' ? SEMI_KEYS : FG_KEYS).map(c => s(getCI(row, c))).join('|');

// Fix Reason 행에 다는 사유 맵 필드명(YYYYMMDD→사유). pivot 숫자 컬럼이 아니라 이 별도 필드에 담아야
//   Wijmo dataType=Number coercion(텍스트→NaN→공란)을 피한다. 그리드 formatItem 이 이 필드를 읽어 D_ 셀에 렌더.
export const FIX_REASON_FIELD = '__fixReason';

// O_RC2(Fix Reason 상세: 키 + YYYYMMDD + FIX_REASON, pivot 아닌 원시 행)을 O_RC1 의 Fix Reason 행에 매핑한다.
//   design 03 §2.3 R-H / AS-IS Set_FixReason(cs:592~700). 원본 행 얕은 복사 후 FIX_REASON_FIELD 에 사유 맵을 단다.
export const mergeFixReason = (rc1: Row[], rc2: Row[]): Row[] => {
  if (rc1.length === 0) return rc1;
  // 키 → (YYYYMMDD → FIX_REASON) 인덱스 구성.
  const reasonByKey = new Map<string, Map<string, string>>();
  for (const r of rc2) {
    const ymd = s(getCI(r, 'YYYYMMDD')).replace(/[^0-9]/g, '').slice(0, 8);
    const reason = s(getCI(r, 'FIX_REASON'));
    if (!ymd) continue;
    const k = rowKey(r);
    let m = reasonByKey.get(k);
    if (!m) {
      m = new Map();
      reasonByKey.set(k, m);
    }
    m.set(ymd, reason);
  }
  if (reasonByKey.size === 0) return rc1;

  return rc1.map(row => {
    if (s(getCI(row, 'MEASURE')) !== MEASURE_FIX_REASON) return row;
    const m = reasonByKey.get(rowKey(row));
    if (!m || m.size === 0) return row;
    // (1) 그리드 렌더용 — 사유를 별도 필드(FIX_REASON_FIELD)에 YYYYMMDD→사유 맵으로 단다.
    //   그리드 formatItem 이 D_ 셀 렌더 시 이 맵을 읽어 텍스트로 그린다(AS-IS SetCellTypeText+SetValue 등가).
    // (2) 엑셀 내려받기용 — 사유를 Fix Reason 행의 일자(D_<YYYYMMDD>) pivot 바인딩에도 직접 심는다.
    //   엑셀 변환기(FlexGridXlsxConverter.save)는 그리드 formatItem(DOM textContent 주입)을 타지 않고
    //   dataItem[binding] 원시값만 읽으므로, 맵에만 담으면 화면엔 보여도 엑셀 Fix Reason 셀이 공란이 된다
    //   (사용자 신고 2026-10-13). pivot D_ 컬럼은 format(n0)을 빼 dataType=Number 강제가 없어(shipmentPlanFixColumns
    //   §leaf 주석) 텍스트를 심어도 숫자 coercion→공란이 되지 않는다. Ship Plan 행 숫자셀·Unfix payload(언제나 같은
    //   lane 의 Ship Plan 행 D_ 를 읽음, shipmentPlanFixSave)와는 별개 행이라 영향 없다. W_/M_(주·월 SUM) 롤업 셀은
    //   AS-IS·화면과 동일하게 비워 둔다(맵에 일자 키만 있어 그 버킷에선 사유 미표시).
    const dailyCells: Record<string, string> = {};
    for (const [ymd, reason] of m) dailyCells[`D_${ymd}`] = reason;
    return { ...row, ...dailyCells, [FIX_REASON_FIELD]: Object.fromEntries(m) };
  });
};
