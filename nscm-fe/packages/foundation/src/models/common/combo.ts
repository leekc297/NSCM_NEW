export interface ComboParam {
  comboId: string;
  [key: string]: string;
}

export interface ComboResponse {
  CODE: string;
  NAME: string;
  [key: string]: string;
}

// 공통 콤보 파라미터 값 자동 인용 (single source).
//
// 배경: BE BaseService.makeComboQuery 는 등록 SQL(SCM_ADM_CMBO_SQL_M)의 @키 를 bind 가 아니라
//   raw 문자열로 치환한다. 그래서 문자열 값은 홑따옴표로 감싸야 SQL 리터럴이 된다. 안 감싸면
//   division='81' 같은 숫자 코드만 우연히 통과하고 '81_UC'/'ALL'/코드값 같은 문자열은
//   식별자로 해석돼 ORA-00904 로 실패한다(2026-08-08 사내 Oracle 재현). 규약: 인용은 호출자 책임.
//
// 이 함수는 그 인용을 콤보 요청 funnel(apiClient.getCombo) 한 곳에서 일괄 처리하기 위한 것이다.
//   - comboId 는 SQL 선택 키라 치환 대상이 아니므로 인용하지 않는다.
//   - 이미 홑따옴표로 감싼 값(기존 q()/quote() 헬퍼가 붙여 보낸 값)은 그대로 둔다(idempotent)
//     — 이중 인용('' 81_UC '') 방지. 덕분에 기존 정상 화면은 무손상, raw 로 넘기던 화면만 교정된다.
//   - 빈 값의 'ALL' 치환 여부는 SQL(관대형 게이트 vs 'ALL' 센티널)마다 달라 호출자 몫으로 남긴다.
//     여기서는 인용만 한다 — 빈 값은 '' 로(= BE 미전달 기본값과 동일) 감싼다.
//   - 값 안의 홑따옴표는 '' 로 이스케이프한다.
export const quoteComboValue = (value: string | undefined): string => {
  const trimmed = (value ?? '').trim();
  if (trimmed.length >= 2 && trimmed.startsWith('\'') && trimmed.endsWith('\'')) return trimmed;
  return `'${trimmed.replace(/'/g, '\'\'')}'`;
};

export const quoteComboParams = (params: ComboParam): ComboParam => {
  const quoted: ComboParam = { comboId: params.comboId };
  for (const [key, value] of Object.entries(params)) {
    if (key === 'comboId') continue;
    // mnuId 는 raw 로 보낸다 — @sesUserId 처럼 BE LookupServiceImpl 가 홑따옴표를 붙인다(인용 주체 = BE).
    //   화면이 quoteParam 으로 미리 감싸 넣었어도 여기서 겉 홑따옴표 한 겹을 벗겨 raw 로 통일한다
    //   (mnuId 는 단순 화면코드라 내부 따옴표가 없다). 안 벗기면 BE 가 멱등이라 결과는 같지만
    //   네트워크 payload 에 인용값이 그대로 남아 화면마다 표기가 갈린다.
    if (key === 'mnuId') {
      const trimmed = (value ?? '').trim();
      quoted[key] =
        trimmed.length >= 2 && trimmed.startsWith('\'') && trimmed.endsWith('\'')
          ? trimmed.slice(1, -1)
          : trimmed;
      continue;
    }
    quoted[key] = quoteComboValue(value);
  }
  return quoted;
};
