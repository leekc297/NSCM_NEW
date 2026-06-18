import { VALIDATION_MSG } from '../contribute-main.constants';
import type { MainRow } from '../types';

// AS-IS .cs ValidChk() L722~ 1:1 매핑 — 각 row 의 동적 컬럼 합 = 100% 검증
//   - chkYear=true : 같은 row 의 Y# 셀들 (RBU_0999 제외) sum == 100 또는 0
//   - chkYear=false: 같은 row × 같은 YYYYMM 의 M# 셀들 (RBU_0999 제외) sum == 100 또는 0,
//                    그리고 12개 월 모두 검증 통과 필요
export const validChk = (rows: MainRow[], chkYear: boolean): { ok: boolean; msgCode: string } => {
  const tag = chkYear ? 'Y' : 'M';
  for (const row of rows) {
    // period 별 합계 누적
    const sumByPeriod = new Map<string, number>();
    Object.entries(row).forEach(([k, v]) => {
      if (!k.startsWith(`${tag}#`)) return;
      const parts = k.split('#');
      if (parts.length !== 3) return;
      const [, period, osCorpCd] = parts;
      if (osCorpCd.indexOf('999') >= 0) return; // RBU_0999 (구분) 제외
      const n = Number(v);
      if (v == null || v === '' || Number.isNaN(n)) return; // 빈값/NaN 제외
      sumByPeriod.set(period, (sumByPeriod.get(period) ?? 0) + n);
    });

    // 각 period 합계 검사
    for (const [, sum] of sumByPeriod) {
      if (Math.abs(sum - 100) > 0.001 && Math.abs(sum) > 0.001) {
        return { ok: false, msgCode: VALIDATION_MSG.RATIO_OUT_OF_RANGE };
      }
    }

    // M# 모드: 12개월 모두 검증 통과 필요 (As-Is L805 ValidChkCol.Count != 12)
    if (!chkYear && sumByPeriod.size > 0 && sumByPeriod.size !== 12) {
      return { ok: false, msgCode: VALIDATION_MSG.RATIO_OUT_OF_RANGE };
    }
  }
  return { ok: true, msgCode: '' };
};

// AS-IS .cs ValidChk2() L816~ 1:1 매핑 — 셀에 값이 있는데 같은 period 의 RBU_0999 가 비어 있으면 false
//   (구분값 미입력 차단)
export const validChk2 = (rows: MainRow[], chkYear: boolean): { ok: boolean; msgCode: string } => {
  const tag = chkYear ? 'Y' : 'M';
  for (const row of rows) {
    for (const [k, v] of Object.entries(row)) {
      if (!k.startsWith(`${tag}#`)) continue;
      const parts = k.split('#');
      if (parts.length !== 3) continue;
      const [, period, osCorpCd] = parts;
      if (osCorpCd.indexOf('999') >= 0) continue; // RBU_0999 자체는 검사 대상 X (다른 셀의 동반)
      if (v == null || v === '') continue;
      // 같은 period 의 RBU_0999 셀 값 확인
      const conTypeKey = `${tag}#${period}#RBU_0999`;
      const conType = (row as Record<string, unknown>)[conTypeKey];
      if (conType == null || conType === '') {
        return { ok: false, msgCode: VALIDATION_MSG.REQUIRED_DIVISION };
      }
    }
  }
  return { ok: true, msgCode: '' };
};

// AS-IS .cs FindData — 버전 필수 선택
export const findDataGuard = (verSeq: string): { ok: boolean; msgCode: string } => {
  if (!verSeq) return { ok: false, msgCode: VALIDATION_MSG.VERSION_REQUIRED };
  return { ok: true, msgCode: '' };
};
