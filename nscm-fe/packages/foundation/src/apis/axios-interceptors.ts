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
    default:
      return Promise.reject(error);
  }
};
