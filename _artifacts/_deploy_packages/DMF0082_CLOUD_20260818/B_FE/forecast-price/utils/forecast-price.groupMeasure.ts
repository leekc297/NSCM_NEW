/**
 * ⭐ DMF0082 — 편집 가능 Measure 후보 원천 = LOOKUP `GET_ADMIN_GROUP_MEASURE`.
 *
 * 요구 원천 (현업 검수 40번 항목):
 *   "Current 버전일 경우 아래 Measure 를 입력 가능해야 한다 —
 *     MKT_FCST[R+P] / SCM_FCST[R+P] = **GET_ADMIN_GROUP_MEASURE 룩업 정보 기준으로 통제** / Unit Price(LOC)"
 *   ⇒ 후보 목록을 CMBO 'FcstPriceEditMeasure'(division|site|bucket) 가 아니라 이 룩업에서 받는다.
 *
 * 룩업 실측 구조 (Admin > Lookup 캡처 2026-08-04 — 헤더 라벨 = SEGMENT 별칭):
 *   SEGMENT1 = Group_id    ADMIN / DM ADMIN / DM Planner / SCP Planner / SCM PI Admin …
 *   SEGMENT2 = Program_Id  'DMF0082'
 *   SEGMENT3 = Division    '40' …
 *   SEGMENT4 = Measure     SCM_FCST / MKT_FCST / LOC / VMI_In_Req
 *   SEGMENT5 = '-'         (미사용)
 *   ATTRIBUTE1~4 = EDIT_Day / FROM_TIME / TO_TIME / LIMIT_MEASURE
 *   Active(VALID_YN) = 'Y'
 *
 * ⚠️ ATTRIBUTE(요일·시간대 제한)는 **여기서 쓰지 않는다** — 요일제한은 BE PKG 가 행별 EDIT_FLAG /
 *   drop3 TODAY_LIMIT_YN 으로 이미 종합 산출한다(forecast-price.types MeasureAuthRow 주석).
 *   이 파일의 책임은 "이 그룹이 이 화면·이 division 에서 다룰 수 있는 Measure 목록" 하나다.
 *
 * ⚠️ 응답 키 표기 방어: 공통 조회 API(`admin/lookup` = PR_GET_LOOKUP_INFO_LIST)가 SEGMENTn 을
 *   그대로 주는지 화면 라벨(GROUP_ID/PROGRAM_ID/DIVISION/MEASURE)로 별칭해 주는지가 배포본마다
 *   갈릴 수 있어 **양쪽 키를 다 읽는다**. 한쪽만 읽었다가 빈 후보가 되면 증상이
 *   "Measure 드롭다운이 비었다" 로만 보여 원인 추적이 어렵다.
 */

/** `admin/lookup` 조회 키 (LookupParam.lookupType). */
export const GROUP_MEASURE_LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE' as const;

type LookupRow = Record<string, unknown>;

/** 룩업 1행 파싱 결과 — 판정에 쓰는 4개 축 + 유효여부. */
export interface GroupMeasureRow {
  groupId: string;
  programId: string;
  divisionId: string;
  measure: string;
  validYn: string;
}

const text = (value: unknown): string => {
  if (typeof value === 'string') return value.trim();
  if (typeof value === 'number') return String(value);
  return '';
};

/** 첫 번째로 값이 있는 키를 고른다 (SEGMENTn ↔ 라벨 별칭 양쪽 대응). */
const field = (row: LookupRow, ...keys: string[]): string => {
  for (const key of keys) {
    const value = text(row[key]);
    if (value !== '') return value;
  }
  return '';
};

export const parseGroupMeasureRow = (row: LookupRow): GroupMeasureRow => ({
  groupId: field(row, 'SEGMENT1', 'GROUP_ID', 'Group_id'),
  programId: field(row, 'SEGMENT2', 'PROGRAM_ID', 'Program_Id'),
  divisionId: field(row, 'SEGMENT3', 'DIVISION', 'DIVISION_ID', 'Division'),
  measure: field(row, 'SEGMENT4', 'MEASURE', 'Measure'),
  // Active 컬럼. 미제공(SP 가 이미 유효행만 내려주는 경우)이면 'Y' 취급.
  validYn: field(row, 'VALID_YN', 'ACTIVE', 'USE_YN') || 'Y',
});

/**
 * 축 1개 일치 판정 — 공란/'-'/'ALL' 은 **제한 없음**으로 본다.
 * (GET_ADMIN_GROUP 의 SEGMENT2='ALL' 운영 선례 — useMktFcstStore L258 실측 주석.)
 */
const axisMatches = (rowValue: string, target: string): boolean => {
  const v = rowValue.toUpperCase();
  if (v === '' || v === '-' || v === 'ALL') return true;
  return v === target.trim().toUpperCase();
};

/**
 * 로그인 사용자 그룹이 이 화면·division 에서 **편집할 수 있는 Measure 코드 목록**.
 *
 * @returns 코드 배열 / 판정 보류 시 `null`.
 *   - `null`  = 룩업 응답 미도착·실패, 또는 authGroup 미해석(CMBO 'FcstPriceUserAuthGroup' 인플라이트).
 *               호출측은 기존 폴백(전체 목록)을 유지해야 한다 — 조회 중에 후보를 0으로 만들면
 *               "잠깐 비었다가 채워지는" 드롭다운이 된다.
 *   - `[]`    = 응답은 왔는데 해당 그룹에 등록된 Measure 가 없음 = **편집 권한 없음**(제한 유지).
 */
export const groupEditMeasures = (
  rows: ReadonlyArray<LookupRow> | undefined | null,
  ctx: { authGroup: string; divisionId: string; programId: string }
): string[] | null => {
  if (!rows) return null;
  const group = ctx.authGroup.trim();
  if (group === '') return null;

  const codes: string[] = [];
  const seen = new Set<string>();
  for (const raw of rows) {
    const row = parseGroupMeasureRow(raw);
    if (row.measure === '') continue;
    if (row.validYn.toUpperCase() !== 'Y') continue;
    // 그룹은 정확 일치만 (+ 전그룹 공통행 'ALL'). 공란 행이 전원 통과하면 통제가 풀린다.
    const rowGroup = row.groupId.toUpperCase();
    if (rowGroup !== group.toUpperCase() && rowGroup !== 'ALL') continue;
    if (!axisMatches(row.programId, ctx.programId)) continue;
    if (!axisMatches(row.divisionId, ctx.divisionId)) continue;
    if (seen.has(row.measure)) continue;
    seen.add(row.measure);
    codes.push(row.measure);
  }
  return codes;
};
