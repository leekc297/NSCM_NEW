import { LEVEL_ID_COLUMN, LEVEL_NAME_COLUMN, type LevelNo } from '../capa-line-master.constants';

// AS-IS SCP0114 저장 전 공백 검사 `CheckDummyDuplication()` (cs:1298~1470, validations #1 cs:771).
//   "중복은 DB에서 체크하고 공백만 UI 에서 체크함"(cs:768) — 즉 이 훅은 공백(필수) 검사 전용이고,
//   중복은 SAVE SP 의 THROW 99020 응답을 화면이 표면화한다(07 §3 S3, 페이지 doSave).
//
//   - 신규행('I') : 활성 레벨의 자기 ID + 자기 NAME 둘 다 필수
//   - 수정행('M') : 활성 레벨의 자기 NAME 필수
//   - 그 외 행    : 검사 대상 아님(cs:1314 `if (_action == "") continue;`)
//
// 공용 useSaveWithValidation(메타 INPUT_TP_CD=IM/M 기반)과 **병행** 배선한다 — 커스텀만 두면
//   메타가 바뀌었을 때 필수검증이 통째로 새는 사고가 난다(SCP0020 2026-09-14 실사고, convert-core §2.4).
//   반대로 공용만 두면 admin 이 INPUT_TP_CD 를 전건 'S' 로 등록했을 때 판정이 사문화된다
//   (memory input-tp-cd-search-only-kills-save-validation). 두 경로를 모두 건다.

// 공백만 있는 문자열도 미입력으로 본다(공용 useSaveWithValidation.isBlank 동일 규칙).
const isBlank = (value: unknown): boolean =>
  value === null || value === undefined || (typeof value === 'string' && value.trim() === '');

export const useCapaLineMasterValidation = () => {
  /** 저장대상행에서 공백인 첫 필수 컬럼 key 를 돌려준다(없으면 null). */
  const findMissingIdOrName = (
    level: LevelNo,
    saveTargets: readonly Record<string, unknown>[]
  ): string | null => {
    const idColumn = LEVEL_ID_COLUMN[level];
    const nameColumn = LEVEL_NAME_COLUMN[level];
    for (const row of saveTargets) {
      const action = row.CRUD_TYPE;
      if (action === 'I') {
        if (isBlank(row[idColumn])) return idColumn;
        if (isBlank(row[nameColumn])) return nameColumn;
      } else if (action === 'M') {
        if (isBlank(row[nameColumn])) return nameColumn;
      }
    }
    return null;
  };

  return { findMissingIdOrName };
};
