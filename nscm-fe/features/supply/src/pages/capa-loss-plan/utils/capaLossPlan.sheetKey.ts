import {
  DIVISION_TYPE_NAME_BY_TYPE,
  MSG,
  PROGRESS_STATUS,
  SHEET_STATUS,
  SHEET_TYPE,
  type DivisionType,
  type GridSheet,
  type SheetStatus,
  type SheetType,
} from '../capa-loss-plan.constants';

/**
 * 시트 결정식과 Edit 게이트 — 이 화면에서 가장 틀리기 쉬운 두 규칙을 한 곳에 모은다.
 *
 * 시트는 `_sheet_name = "{_sheet_status}_{_division_type_name}"`(03 §0) 이고,
 * 시트가 바뀌면 컬럼셋·measure·GET SP·컬럼설정 키가 **전부** 바뀐다. 탭이 아니라 스위치다(R-01).
 */

/**
 * `_sheet_status` 4값 (AS-IS FORM:482~520).
 *
 * 함정: **2차 컷오프 + MODEL 이 1차와 같은 `CUTOFF_MODEL` 로 간다.** 컷오프 차수로 먼저 가르면
 * `2ND_CUTOFF_MODEL` 이라는 존재하지 않는 시트를 만들게 된다 — SheetType 을 **먼저** 본다.
 */
export const toSheetStatus = (progressStatus: string, sheetType: SheetType): SheetStatus => {
  const isCutoff =
    progressStatus === PROGRESS_STATUS.FIRST_CUTOFF ||
    progressStatus === PROGRESS_STATUS.SECOND_CUTOFF;
  if (!isCutoff) return SHEET_STATUS.CURRENT;
  if (sheetType === SHEET_TYPE.MODEL) return SHEET_STATUS.CUTOFF_MODEL;
  return progressStatus === PROGRESS_STATUS.FIRST_CUTOFF
    ? SHEET_STATUS.FIRST_CUTOFF_LINE
    : SHEET_STATUS.SECOND_CUTOFF_LINE;
};

/** `_sheet_name` 8값 — DB `SHEET_NAME` 과 대소문자까지 일치한다(03 V-01). */
export const toSheetName = (
  progressStatus: string,
  sheetType: SheetType,
  divisionType: DivisionType
): GridSheet =>
  `${toSheetStatus(progressStatus, sheetType)}_${DIVISION_TYPE_NAME_BY_TYPE[divisionType]}` as GridSheet;

// "LINE 계열 시트인가" 판별 함수는 두지 않는다 — 편집잠금(C2)·재계산 디스패치·SAVE SP 분기가
//   전부 `_sheet_status` 가 아니라 **(progressStatus, sheetType) 원본 쌍**으로 판정하기 때문이다
//   (03 R-06/R-18/R-30). 파생값으로 한 번 더 감싸면 `2ND_CUTOFF + MODEL` 같은 경계 조합에서
//   원본 쌍과 판정이 갈린다.

/**
 * SAVE SP 변형 선택 (03 R-30/R-31).
 * `CURRENT` 또는 `1ST_CUTOFF + MODEL` 이면 MODEL SP, 그 외는 LINE SP.
 * 주의: 식 그대로면 `2ND_CUTOFF + MODEL` 도 LINE SP 인데, 그 조합은 Edit 게이트(L-13 —
 * `PROG_STAT='2'` 무조건 차단)에 걸려 저장 경로가 도달 불가라 실동작 차이가 없다.
 * AS-IS 식을 "정리" 하지 않고 그대로 옮긴다(오타로 보지 말 것 — 03 R-30).
 */
export const usesModelSaveSp = (progressStatus: string, sheetType: SheetType): boolean => {
  const status = toSheetStatus(progressStatus, sheetType);
  if (status === SHEET_STATUS.CURRENT) return true;
  return progressStatus === PROGRESS_STATUS.FIRST_CUTOFF && sheetType === SHEET_TYPE.MODEL;
};

/**
 * `p_sheet_name` 이 MODEL/LINE 에서 **비대칭**이다(03 R-30/R-31, V-50).
 *   MODEL SAVE -> `_sheet_status`(접미 없음, 예 `CURRENT`)
 *   LINE  SAVE -> `_sheet_name`(접미 포함, 예 `1ST_CUTOFF_LINE_ASSEMBLY`)
 * GET 은 언제나 `_sheet_name` 이다. 셋을 하나로 통일하면 SP 파싱이 깨진다.
 */
export const toSaveSheetNameParam = (
  progressStatus: string,
  sheetType: SheetType,
  divisionType: DivisionType
): string =>
  usesModelSaveSp(progressStatus, sheetType)
    ? toSheetStatus(progressStatus, sheetType)
    : toSheetName(progressStatus, sheetType, divisionType);

/** Edit 게이트 판정 결과 — 차단이면 띄울 메시지 코드를 함께 준다. */
export interface EditGateVerdict {
  blocked: boolean;
  messageId?: string;
}

/**
 * Edit 진입 게이트 3분기 (01 L-12~L-15 / 03 R-20 / V-10~V-14).
 *
 * 판정 기준값은 화면에서 고른 Status(`progressStatus`)가 **아니라** 그 버전의 현재 진행상태
 * (`dtVersionAll.PROG_STAT` = `currVersionProgressStatus`)다. 둘을 혼동하면 편집 조건이 통째로 달라진다.
 * 판정 시점도 Load 가 아니라 **Edit 클릭 시점**이다(Version 콤보가 바뀌면 값이 재계산된다).
 *
 * 함정: `'1'`(1차 컷오프)을 단독 차단으로 구현하면 **1차 컷오프 Line 편집이 통째로 막힌다**.
 * `'1'` 은 화면 Status 도 `'1'` 이고 SheetType 이 `MODEL` 일 때**만** 차단이다.
 * **SCP0105 와 다르다** — SCP0105 는 `-`/`1`/`2` 전부 무조건 차단에 메시지도 1종이다.
 */
export const judgeEditGate = (
  currVersionProgressStatus: string,
  progressStatus: string,
  sheetType: SheetType
): EditGateVerdict => {
  if (currVersionProgressStatus === PROGRESS_STATUS.PRE) {
    return { blocked: true, messageId: MSG.PRE_READ_ONLY };
  }
  if (currVersionProgressStatus === PROGRESS_STATUS.SECOND_CUTOFF) {
    return { blocked: true, messageId: MSG.READ_ONLY };
  }
  if (
    currVersionProgressStatus === PROGRESS_STATUS.FIRST_CUTOFF &&
    progressStatus === PROGRESS_STATUS.FIRST_CUTOFF &&
    sheetType === SHEET_TYPE.MODEL
  ) {
    return { blocked: true, messageId: MSG.READ_ONLY };
  }
  return { blocked: false };
};
