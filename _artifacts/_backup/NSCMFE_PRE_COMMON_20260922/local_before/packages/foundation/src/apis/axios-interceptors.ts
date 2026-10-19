import type { InternalAxiosRequestConfig, AxiosError, AxiosResponse } from 'axios';
import { monotonicFactory } from 'ulid';

import type { ApiResponse } from '@foundation/models';

interface DefaultResponse {
  DATARESULT: unknown[];
  O_RESULT_CURSOR?: { CODE: string; EVENT: string; MSG: string }[];
}

export const requestInterceptor = (
  config: InternalAxiosRequestConfig
): InternalAxiosRequestConfig => {
  const strictUlid = monotonicFactory();
  config.headers['X-Request-ID'] = strictUlid();
  return config;
};

export const requestErrorInterceptor = (error: AxiosError): Promise<never> => {
  // TODO 이동주: 요청 에러 처리
  console.error(error);
  return Promise.reject(error);
};

export const responseInterceptor = (
  response: AxiosResponse<ApiResponse<DefaultResponse>>
): AxiosResponse => {
  // DB status
  if (Number(response.data.result?.O_RESULT_CURSOR?.[0]?.CODE))
    throw new Error(response.data.result.O_RESULT_CURSOR?.[0].MSG);

  // BE status
  if (Number(response.data.code)) throw new Error(response.data.message);

  return response;
};

// 응답 자체가 없는 오류(타임아웃/네트워크 단절)는 axios 기본 메시지가 영문이라
// 사용자 친화적 메시지로 변환해 reject 한다. (ERR_CANCELED 는 화면 전환 등에 의한
// 정상 취소이므로 변환하지 않음)
const CONNECTION_ERROR_MESSAGES: Record<string, string> = {
  ECONNABORTED: '_서버 응답이 지연되어 요청이 취소되었습니다. (타임아웃)',
  ETIMEDOUT: '_서버 응답이 지연되어 요청이 취소되었습니다. (타임아웃)',
  ERR_NETWORK: '_서버에 연결할 수 없습니다. 네트워크 상태 또는 서버 기동 여부를 확인하세요.',
};

export const responseErrorInterceptor = (
  error: AxiosError<ApiResponse<DefaultResponse>>
): Promise<never> | AxiosResponse => {
  switch (error.response?.status) {
    // case 400: // Bad Request
    // case 401: // Unauthorized
    case 403: // No Permission
    case 500: // Internal server error
      return error.response;
    // case 404: // Not Found
    // case 502: // Bad Gateway
    // case 503: // Service Unavailable
    default: {
      const friendlyMessage = error.code && CONNECTION_ERROR_MESSAGES[error.code];
      if (friendlyMessage) return Promise.reject(new Error(friendlyMessage, { cause: error }));
      return Promise.reject(error);
    }
  }
};
