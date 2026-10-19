import {
  DAY_BINDING_RE,
  SAVE_ACTIVE_FLAG,
  SAVE_ARRAY_KEYS,
  SAVE_DELIMITER,
} from '../shipment-working-day.constants';
import type { SaveEntry, ShipmentWorkingDayRow } from '../shipment-working-day.types';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export interface BuiltSavePayload {
  entries: SaveEntry[];
  // 값이 비어 전송에서 제외한 변경 셀 수. 화면이 사용자에게 알리는 데 쓴다.
  skippedBlank: number;
}

// EditTracker 변경맵 -> SAVE 대상. 저장 단위는 행이 아니라 셀 1개다(03 §3-c).
//   같은 행에서 3일치를 바꾸면 3건이 나간다 — AS-IS 이중 루프(for 행 { for 열 })와 같은 결과.
//
//   필수 제외 규칙: 값이 빈 D_ 셀은 payload 에서 뺀다. TO-BE SAVE SP 는 빈 값을 '-' 로 치환하지
//   않고 그대로 NULL 로 UPDATE 하는데 SSP_MST_SHIP_CALENDAR.WORKDAY_YN 은 NOT NULL 이라
//   ORA-01400 -> ROLLBACK TO SAVEPOINT -> 전건 미저장이 된다(03 §4-e #5).
export const buildSaveEntries = (
  changed: Map<ShipmentWorkingDayRow, Record<string, WijmoPrimitive>> | undefined
): BuiltSavePayload => {
  const entries: SaveEntry[] = [];
  let skippedBlank = 0;
  if (!changed) return { entries, skippedBlank };

  for (const [item, fields] of changed) {
    const record = item as unknown as Record<string, unknown>;
    for (const binding of Object.keys(fields)) {
      // 편집 가능 셀은 동적 D_ 일자 셀뿐이다. 정적 2열은 INPUT_TP_CD='S' 로 이미 잠겨 있다.
      if (!DAY_BINDING_RE.test(binding)) continue;
      const workdayYn = str(record[binding]).trim().toUpperCase();
      if (!workdayYn) {
        skippedBlank += 1;
        continue;
      }
      entries.push({
        // SP 가 F_SPL_CNT(P_ACTIVE_FLAG) 로 루프 길이를 뽑으므로 건수만큼 채워야 한다.
        activeFlag: SAVE_ACTIVE_FLAG,
        divisionId: str(item.DIVISION_ID),
        companyId: str(item.COMPANY_ID),
        yyyymmdd: binding.slice(2),
        workdayYn,
      });
    }
  }
  return { entries, skippedBlank };
};

// '^' 평면 CLOB payload. useProcMutation 은 배열을 결합하지 않아 전 파라미터가 NULL 바인딩되므로
//   apiClient.post 직접 경로를 쓴다(03 §4-e #1).
//   lastUpdatedBy/timeZone/debugMode 는 스칼라라 배열 결합 대상이 아니다. 특히 lastUpdatedBy 는
//   /call-proc 이 세션을 주입하지 않으므로 FE 가 직접 싣는다 — 원장 LAST_UPDATED_BY 가 NOT NULL
//   이라 빠지면 저장이 전건 실패한다(03 §4-e #4).
export const toCaretPayload = (
  entries: SaveEntry[],
  scalars: { lastUpdatedBy: string; timeZone: string; debugMode: string }
): Record<string, string> => ({
  ...Object.fromEntries(
    SAVE_ARRAY_KEYS.map(key => [key, entries.map(e => e[key]).join(SAVE_DELIMITER)])
  ),
  ...scalars,
});
