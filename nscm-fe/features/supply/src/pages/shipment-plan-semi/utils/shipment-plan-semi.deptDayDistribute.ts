// Weekly 셀(W_) 입력 시 Dept Day 요일 자동분배 — 이 화면 고유 로직(SCP0009 에 없음).
//   근거: .atlas/gscm-design/SCP0010/design/03_grid-columns.md §3.3 R-DeptDist (cs:4495-4575 전문).
//
// 동작: 변경된 W_ 셀 뒤(오른쪽)로 이어지는 그 주의 7개 D_ 컬럼을 순회하며, 각 D_ 컬럼의 요일이
//   그 행의 Dept_Day 값과 일치하는 1개에만 입력한 W_ 값을 그대로 세팅하고, 나머지 6일은 0으로
//   세팅한다(W_ 셀 표시값은 그대로 두고 D_ 값만 분배 — 저장은 결국 D_ 단위로만 나간다, design §4.4).
//
// 요일 코드는 AS-IS Dept_Day 컬럼값(design 03 §1 #27)과 동일한 규약(3자 영문 약어, MON/TUE/...).
//   iter-2 에서 SCP_MST_SHIPMENT_SEMI_DEPT_DAY.DEPARTURE_DAY 실측(ora.py) — MON/TUE/THU/SAT 확인,
//   아래 DAY_CODE_MAP 과 일치(SUN/WED/FRI 는 샘플 데이터에 없었을 뿐 동일 규약으로 판단).
export const DAY_CODE_MAP: Record<number, string> = {
  0: 'SUN',
  1: 'MON',
  2: 'TUE',
  3: 'WED',
  4: 'THU',
  5: 'FRI',
  6: 'SAT',
};

const yyyymmddToDate = (yyyymmdd: string): Date | null => {
  if (!/^\d{8}$/.test(yyyymmdd)) return null;
  const y = Number(yyyymmdd.slice(0, 4));
  const m = Number(yyyymmdd.slice(4, 6)) - 1;
  const d = Number(yyyymmdd.slice(6, 8));
  return new Date(y, m, d);
};

export const dayCodeOf = (yyyymmdd: string): string | null => {
  const date = yyyymmddToDate(yyyymmdd);
  if (!date) return null;
  return DAY_CODE_MAP[date.getDay()] ?? null;
};

// 그 주(week)에 속한 D_ 컬럼 binding 7개 중, deptDay 요일과 일치하는 1개만 값(qty)을, 나머지
//   6개는 0을 반환한다. weekDayBindings 는 호출측(그리드)이 W_ 컬럼과 연결된 7개 D_ binding을
//   BASIS_START_DATE 기준으로 미리 구성해 넘긴다(그리드가 dynColMetas 를 이미 갖고 있으므로).
export const distributeWeeklyToDailyBindings = (
  weekDayBindings: string[], // 7개 'D_yyyymmdd' binding, 요일 순서 무관
  deptDay: string, // row.Dept_Day 값('X'=미등록, 그 외=요일 코드)
  qty: number
): Record<string, number> => {
  const result: Record<string, number> = {};
  if (!deptDay || deptDay === 'X') {
    // Dept Day 미등록이면 이 함수 호출 전에 이미 편집불가(editLock)로 걸러지나, 방어적으로
    //   전부 0 처리(입력값을 어느 요일에도 반영하지 않음 — 데이터 결함 방지).
    weekDayBindings.forEach(b => {
      result[b] = 0;
    });
    return result;
  }
  weekDayBindings.forEach(b => {
    const yyyymmdd = b.slice(2);
    const code = dayCodeOf(yyyymmdd);
    result[b] = code === deptDay ? qty : 0;
  });
  return result;
};
