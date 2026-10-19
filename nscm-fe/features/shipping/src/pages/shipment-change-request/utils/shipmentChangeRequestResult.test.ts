import { describe, expect, it } from 'vitest';

import {
  judgeSaveError,
  judgeSaveResponse,
  readResultCode,
  type JudgeableResponse,
} from './shipmentChangeRequestResult';

// SSP0201 저장 결과 판정 계약 테스트.
//
// 이 파일이 지키는 것은 **false-success 차단**이다. `responseErrorInterceptor` 는 403·500 을
//   reject 하지 않고 `error.response` 로 **resolve** 한다(axios-interceptors §54~59). 그래서
//   status 분기가 없으면 권한 없음·서버 오류가 성공 경로로 그대로 흘러 "저장되었습니다" 토스트가 뜬다.
//   반대 방향도 막는다 — 판정 근거가 없는 응답(RESULT_CODE 부재·공백, code 가 숫자 아님)을 ok 로
//   올리지 않는다. 그 경우는 `unknown` 이고, 호출부는 unknown 에서 성공 토스트를 띄우지 않는다.
//
// 저장 SP 자체는 테스트에서 호출하지 않는다 — PKG_SSP0201 의 SAVE 경로는 공유 DB 에 ERP 전송행을
//   적재하고 정리 경로가 없다(자매 SSP0200 테스트 헤더와 같은 제약).

/** 성공 응답 틀. 테스트마다 필요한 부분만 덮어쓴다. */
const res = (over: Partial<JudgeableResponse> = {}): JudgeableResponse => ({
  status: 200,
  data: { result: { o_rc1: [{ RESULT_CODE: 'S' }] } },
  ...over,
});

/** o_rc1 행 배열만 바꿔 끼운다(봉투 code 는 두지 않는다 = 신호 없음). */
const withRows = (rows: unknown[], status = 200): JudgeableResponse => ({
  status,
  data: { result: { o_rc1: rows } },
});

describe('judgeSaveResponse — HTTP 축(인터셉터가 resolve 하는 오류)', () => {
  it('403(권한 없음)은 fail 이다 — 인터셉터가 resolve 하므로 여기서 걸러야 한다', () => {
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: 'S' }], 403))).toBe('fail');
  });

  it('500(서버 오류)은 fail 이다', () => {
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: 'S' }], 500))).toBe('fail');
  });

  it('HTTP 오류는 본문의 성공 커서보다 우선한다 — 바깥이 깨졌으면 안쪽을 믿지 않는다', () => {
    // 500 응답 본문에 RESULT_CODE='S' 가 남아 있어도 ok 로 올리지 않는다.
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: 'S' }], 500))).not.toBe('ok');
  });

  it('400 경계값도 fail 이다(399 는 통과)', () => {
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: 'S' }], 400))).toBe('fail');
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: 'S' }], 399))).toBe('ok');
  });
});

describe('judgeSaveResponse — BE 봉투 code 축', () => {
  it('code 가 abc(숫자 아님)면 unknown 이다 — 봉투를 해석할 수 없으면 단정하지 않는다', () => {
    expect(
      judgeSaveResponse({
        status: 200,
        data: { code: 'abc', result: { o_rc1: [{ RESULT_CODE: 'S' }] } },
      })
    ).toBe('unknown');
  });

  it('code 비0 숫자는 fail 이다(문자열 숫자 포함 — ApiResponse.code 는 string 이다)', () => {
    expect(judgeSaveResponse({ status: 200, data: { code: '-1' } })).toBe('fail');
    expect(judgeSaveResponse({ status: 200, data: { code: 1 } })).toBe('fail');
  });

  it('code 가 0 이면 정상 봉투라 SP RESULT_CODE 로 넘어간다', () => {
    expect(
      judgeSaveResponse({
        status: 200,
        data: { code: '0', result: { o_rc1: [{ RESULT_CODE: 'S' }] } },
      })
    ).toBe('ok');
  });

  it('code 부재·null·공백은 "신호 없음" 이라 SP RESULT_CODE 로 넘어간다(종전 거동 유지)', () => {
    // 종전 `!!Number(res.data?.code)` 도 부재를 통과시켰다 — 그 거동을 지킨다.
    expect(judgeSaveResponse(res())).toBe('ok');
    expect(
      judgeSaveResponse({ status: 200, data: { code: null, result: { o_rc1: [{ RESULT_CODE: 'S' }] } } })
    ).toBe('ok');
    expect(
      judgeSaveResponse({ status: 200, data: { code: '  ', result: { o_rc1: [{ RESULT_CODE: 'S' }] } } })
    ).toBe('ok');
  });
});

describe('judgeSaveResponse — SP RESULT_CODE 축', () => {
  it('정상 S 는 ok 다', () => {
    expect(judgeSaveResponse(res())).toBe('ok');
  });

  it('RESULT_CODE X(확인필요)는 fail 이다 — S 가 아닌 값은 전부 실패다', () => {
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: 'X' }]))).toBe('fail');
  });

  it('업무 실패코드 N(Model 미조회)·F(판가 미입력)도 fail 이다', () => {
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: 'N' }]))).toBe('fail');
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: 'F' }]))).toBe('fail');
  });

  it('o_rc1 빈 배열은 unknown 이다 — 저장됐다고도 실패했다고도 말할 근거가 없다', () => {
    expect(judgeSaveResponse(withRows([]))).toBe('unknown');
  });

  it('o_rc1 [{}](행은 있고 코드열이 없음)은 unknown 이다', () => {
    expect(judgeSaveResponse(withRows([{}]))).toBe('unknown');
  });

  it('RESULT_CODE null 은 unknown 이다 — 빈 값을 실패코드로 읽지 않는다', () => {
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: null }]))).toBe('unknown');
  });

  it('RESULT_CODE 공백문자열은 unknown 이다', () => {
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: '' }]))).toBe('unknown');
    expect(judgeSaveResponse(withRows([{ RESULT_CODE: '   ' }]))).toBe('unknown');
  });

  it('result·o_rc1 자체가 없는 응답은 unknown 이다', () => {
    expect(judgeSaveResponse({ status: 200, data: {} })).toBe('unknown');
    expect(judgeSaveResponse({ status: 200, data: { result: {} } })).toBe('unknown');
    expect(judgeSaveResponse({ status: 200 })).toBe('unknown');
  });
});

describe('readResultCode — 이름으로 읽는다(위치 폴백 금지)', () => {
  it('부가열이 함께 와도 RESULT_CODE 를 이름으로 집는다', () => {
    // 자매 SSP0200 사고 재현 방지: 위치([0])로 읽으면 CHANGE_REQ_NO 'R…' 를 실패코드로 오판한다.
    const data = {
      result: { o_rc1: [{ CHANGE_REQ_NO: 'R20261012000001', RESULT_CODE: 'S' }] },
    };
    expect(readResultCode(data)).toBe('S');
    expect(judgeSaveResponse({ status: 200, data })).toBe('ok');
  });

  it('RESULT_CODE 가 없으면 다른 열을 코드로 쓰지 않는다 — 위치 폴백이 없다', () => {
    expect(readResultCode({ result: { o_rc1: [{ CHANGE_REQ_NO: 'R20261012000001' }] } })).toBe('');
  });

  it('소문자 result_code 변형도 읽는다', () => {
    expect(readResultCode({ result: { o_rc1: [{ result_code: 'S' }] } })).toBe('S');
  });

  it('앞뒤 공백은 제거한다', () => {
    expect(readResultCode({ result: { o_rc1: [{ RESULT_CODE: ' S ' }] } })).toBe('S');
  });

  it('첫 행만 본다(SP 는 1행 커서를 돌려준다)', () => {
    const data = { result: { o_rc1: [{ RESULT_CODE: 'S' }, { RESULT_CODE: 'X' }] } };
    expect(readResultCode(data)).toBe('S');
  });
});

describe('judgeSaveError — reject 된 요청', () => {
  it('cause 가 실린 예외는 fail 이다 — 서버가 오류를 판정해 돌려준 것이다', () => {
    // 인터셉터가 DB 오류행을 `new Error(MSG, { cause: resultRow })` 로 던진다(axios-interceptors §33).
    const error = new Error('ORA-01400', { cause: { CODE: '-1', MSG: 'ORA-01400' } });
    expect(judgeSaveError(error)).toBe('fail');
  });

  it('cause 없는 예외(통신 오류·BE code 예외)는 unknown 이다 — 서버에 닿았는지조차 모른다', () => {
    expect(judgeSaveError(new Error('Network Error'))).toBe('unknown');
  });

  it('cause 가 undefined·null 이면 unknown 이다', () => {
    expect(judgeSaveError(new Error('x', { cause: undefined }))).toBe('unknown');
    expect(judgeSaveError(new Error('x', { cause: null }))).toBe('unknown');
  });

  it('Error 가 아닌 값이 throw 돼도 터지지 않고 unknown 이다', () => {
    expect(judgeSaveError(undefined)).toBe('unknown');
    expect(judgeSaveError(null)).toBe('unknown');
    expect(judgeSaveError('boom')).toBe('unknown');
  });
});

describe('성공 토스트 게이트 — ok 가 아닌 것은 하나도 ok 로 새지 않는다', () => {
  it.each<[string, JudgeableResponse]>([
    ['403', withRows([{ RESULT_CODE: 'S' }], 403)],
    ['500', withRows([{ RESULT_CODE: 'S' }], 500)],
    ['code 가 abc', { status: 200, data: { code: 'abc', result: { o_rc1: [{ RESULT_CODE: 'S' }] } } }],
    ['RESULT_CODE X', withRows([{ RESULT_CODE: 'X' }])],
    ['o_rc1 []', withRows([])],
    ['o_rc1 [{}]', withRows([{}])],
    ['RESULT_CODE null', withRows([{ RESULT_CODE: null }])],
  ])('%s 는 ok 가 아니다', (_label, input) => {
    expect(judgeSaveResponse(input)).not.toBe('ok');
  });
});
