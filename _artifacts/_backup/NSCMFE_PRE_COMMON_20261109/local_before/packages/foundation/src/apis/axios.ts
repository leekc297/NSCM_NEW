import axios, { AxiosHeaders } from 'axios';
import type { AxiosInstance, AxiosRequestConfig, AxiosPromise } from 'axios';
import { monotonicFactory } from 'ulid';

import {
  type ApiResponse,
  type LookupParam,
  type ComboParam,
  type ComboResponse,
  type LookupResponse,
  type ProcStreamHandlers,
  type ProcStreamLine,
  type ProcStreamResult,
  quoteComboParams,
} from '@foundation/models';

import { API_CONFIG } from '../constants/app-config';

import {
  requestErrorInterceptor,
  requestInterceptor,
  responseErrorInterceptor,
  responseInterceptor,
} from './axios-interceptors';

const basicConfig: AxiosRequestConfig = {
  baseURL: API_CONFIG.BASE_URL,
  timeout: API_CONFIG.TIMEOUT,
  withCredentials: API_CONFIG.WITH_CREDENTIALS,
};

const mockConfig: AxiosRequestConfig = {
  baseURL: 'localhost:8080/api',
  timeout: 1000 * 300,
  withCredentials: false,
};

class AxiosConfig {
  service: AxiosInstance;
  headers = new AxiosHeaders();

  public constructor(requestConfig: AxiosRequestConfig) {
    this.service = axios.create(requestConfig);
    this.service.interceptors.request.use(requestInterceptor, requestErrorInterceptor);
    this.service.interceptors.response.use(responseInterceptor, responseErrorInterceptor);
  }

  setHeader<P extends Record<string, string>>(params: P, options: AxiosRequestConfig = {}): this {
    const newHeaders = new AxiosHeaders({
      ...API_CONFIG.DEFAULT_HEADERS,
      ...options.headers,
      ...params,
    });

    this.headers = Object.assign(this.headers, newHeaders);
    return this;
  }
  async request<T, P = object>(config: AxiosRequestConfig<P> = {}): AxiosPromise<ApiResponse<T>> {
    return this.service.request<ApiResponse<T>>({
      headers: this.headers,
      ...config,
    });
  }

  async get<T, P = unknown>(
    url: string,
    params?: P,
    options: AxiosRequestConfig = {}
  ): AxiosPromise<ApiResponse<T>> {
    return this.request<T, P>({
      method: 'GET',
      url,
      params,
      ...options,
    });
  }

  async post<T, P = object>(
    url: string,
    data?: P,
    options: AxiosRequestConfig<P> = {}
  ): AxiosPromise<ApiResponse<T>> {
    // ⭐ FormData(multipart) 업로드 — Content-Type 제거해 브라우저/axios 가 boundary 포함
    //   multipart/form-data 를 자동 설정하게 한다. (DEFAULT_HEADERS 의 application/json 이 강제되면
    //   파일 파트가 파싱되지 않아 업로드가 무반응. 2026-07-07)
    const isFormData = typeof FormData !== 'undefined' && data instanceof FormData;
    if (isFormData) {
      const headers = new AxiosHeaders(this.headers);
      headers.delete('Content-Type');
      return this.request<T, P>({ method: 'POST', url, data, headers, ...options });
    }
    return this.request<T, P>({
      method: 'POST',
      url,
      data,
      ...options,
    });
  }

  async put<T, P = unknown>(
    url: string,
    data?: P,
    options: AxiosRequestConfig<P> = {}
  ): AxiosPromise<ApiResponse<T>> {
    return this.request<T, P>({
      method: 'PUT',
      url,
      data,
      ...options,
    });
  }

  async patch<T, P = unknown>(
    url: string,
    data?: P,
    options: AxiosRequestConfig<P> = {}
  ): AxiosPromise<ApiResponse<T>> {
    return this.request<T, P>({
      method: 'PATCH',
      url,
      data,
      ...options,
    });
  }

  async delete<T, P = unknown>(
    url: string,
    params?: P,
    options: AxiosRequestConfig = {}
  ): AxiosPromise<ApiResponse<T>> {
    return this.request<T, P>({
      method: 'DELETE',
      url,
      params,
      ...options,
    });
  }

  async callProc<M extends MenuId, S extends SheetName<M>>(
    menuId: M,
    sheetName: S,
    procedureAction: string,
    params?: ProcRequest<M, S>
  ): Promise<ApiResponse<ProcResponse<M, S>>> {
    const response = await this.post<ProcResponse<M, S>, ProcRequest<M, S>>(
      `${menuId}/${sheetName}/${procedureAction}/call-proc`,
      params
    );
    return response.data;
  }

  async callMutationProc<M extends MenuId, S extends SheetName<M>, RS extends ResponseKeys<M, S>>(
    menuId: M,
    sheetName: S,
    procedureAction: string,
    data: ResponseData<M, S, RS>[]
  ): Promise<ApiResponse<MutateResponse>> {
    const response = await this.post<MutateResponse, MutateRequest<M, S, RS>>(
      `${menuId}/${sheetName}/${procedureAction}/call-proc`,
      { data: data }
    );
    return response.data;
  }

  // TODO: 임시 lookup 조회 func - 강민재
  /**
   * @param src 호출 출처 표식 (예: 'grid'). URL 쿼리로만 붙는다 — Network 탭 목록에서
   *   `admin/combo?src=grid` 로 그리드 셀 콤보를 검색조건 콤보와 바로 구분하기 위한 것이다.
   *   본문에는 넣지 않는다: 본문 키는 BE makeComboQuery 가 등록 SQL 의 @키 로 치환하는 대상이라
   *   진단용 값이 SQL 경로에 섞이면 안 된다.
   */
  async getCombo(params: ComboParam, src?: string): Promise<ComboResponse[]> {
    // 그리드 셀 콤보(admin/combo?src=grid)는 유효 코드만 채우도록 validYn='Y' 를 공통 주입한다.
    //   호출부가 명시로 넘긴 값은 존중한다(이미 있으면 유지). raw 로 넣으면 아래 quoteComboParams 가
    //   'Y' 로 감싸 @validYn 치환에 맞춘다. src='grid' 아닌 검색조건 콤보에는 실지 않는다.
    const body = src === 'grid' && params.validYn == null ? { ...params, validYn: 'Y' } : params;
    // 모든 콤보 요청이 반드시 지나는 단일 funnel — 여기서 파라미터 값을 일괄 인용한다.
    //   BE makeComboQuery 가 @키 를 raw 치환하므로 문자열 값엔 홑따옴표가 필수다. 이미 감싼 값은
    //   quoteComboParams 가 그대로 두므로(idempotent) 기존 q()/quote() 화면은 영향 없다.
    const response = await this.post<ComboResponse[], ComboParam>(
      src ? `admin/combo?src=${encodeURIComponent(src)}` : 'admin/combo',
      quoteComboParams(body)
    );
    return response.data.result;
  }

  /**
   * [E20261015-STREAMPROC] 대량 조회 스트리밍 — `${menuId}/${sheetName}/${procedureAction}/call-proc-stream`.
   * call-proc 과 같은 메타·권한으로 같은 프로시저를 실행하고, 결과를 묶음 단위로 받는 즉시 handlers.onRows 로 넘긴다.
   * 화면은 첫 묶음부터 그릴 수 있다(전량 수신을 기다리지 않음).
   *
   * - axios 는 응답 본문을 다 받아야 넘겨주므로 fetch + ReadableStream 으로 읽는다(쿠키 인증·X-Request-ID 는 동일하게).
   * - 상태 커서(O_RESULT_CURSOR) CODE 가 0 이 아니면 responseInterceptor 와 같은 규칙으로 Error(MSG, {cause: 행}) 를 던진다.
   * - signal 로 취소(조건 변경·탭 닫힘)하면 AbortError 로 끝난다.
   */
  async callProcStream<TRow = Record<string, unknown>>(
    menuId: string,
    sheetName: string,
    procedureAction: string,
    params: object | undefined,
    handlers: ProcStreamHandlers<TRow>,
    signal?: AbortSignal
  ): Promise<ProcStreamResult> {
    const base = String(this.service.defaults.baseURL ?? '').replace(/\/+$/, '');
    const url = `${base}/${menuId}/${sheetName}/${procedureAction}/call-proc-stream`;
    const response = await fetch(url, {
      method: 'POST',
      credentials: API_CONFIG.WITH_CREDENTIALS ? 'include' : 'same-origin',
      headers: {
        ...API_CONFIG.DEFAULT_HEADERS,
        Accept: 'application/x-ndjson',
        'X-Request-ID': monotonicFactory()(),
      },
      body: JSON.stringify(params ?? {}),
      signal,
    });

    const contentType = response.headers.get('Content-Type') ?? '';
    if (!response.ok || !response.body || !contentType.includes('ndjson')) {
      // 메타 해석 오류·권한 거부는 일반 JSON(BaseResponse/ErrorResponse) 로 돌아온다.
      let message = `HTTP ${response.status}`;
      try {
        const data = (await response.json()) as ApiResponse<unknown>;
        if (data.message) message = data.message;
      } catch {
        // 본문이 JSON 이 아니면 상태코드 메시지 유지
      }
      throw new Error(message);
    }

    const reader = response.body.getReader();
    const decoder = new TextDecoder('utf-8');
    let buffer = '';
    let result: ProcStreamResult = { rows: 0, ms: 0 };

    const handleLine = (text: string) => {
      if (!text.trim()) return;
      const line: ProcStreamLine<TRow> = JSON.parse(text);
      switch (line.t) {
        case 'cursor':
          handlers.onCursor?.(line.c, line.cols);
          break;
        case 'rows': {
          if (line.c === 'O_RESULT_CURSOR') {
            // responseInterceptor 와 같은 규칙 — 상태 커서 CODE 가 0 이 아니면 오류 (상태 행 1개라 재파싱 비용 무시)
            const statusLine: { rows: { CODE?: string; MSG?: string }[] } = JSON.parse(text);
            const status = statusLine.rows[0];
            if (Number(status?.CODE)) throw new Error(status?.MSG ?? '', { cause: status });
          }
          handlers.onRows(line.c, line.rows);
          break;
        }
        case 'error':
          throw new Error(line.message);
        case 'end':
          result = { rows: line.rows, ms: line.ms };
          break;
        default:
          break;
      }
    };

    try {
      for (;;) {
        const { done, value } = await reader.read();
        if (done) break;
        buffer += decoder.decode(value, { stream: true });
        let newline = buffer.indexOf('\n');
        while (newline >= 0) {
          handleLine(buffer.slice(0, newline));
          buffer = buffer.slice(newline + 1);
          newline = buffer.indexOf('\n');
        }
      }
      buffer += decoder.decode();
      handleLine(buffer);
    } catch (error) {
      void reader.cancel().catch(() => undefined);
      throw error;
    }
    return result;
  }

  async getLookup(params: LookupParam): Promise<LookupResponse[]> {
    const response = await this.post<LookupResponse[], LookupParam>('admin/lookup', params);
    return response.data.result;
  }

  async executeDynamicQuery<T = Record<string, unknown>>(sqlText: string): Promise<ApiResponse<T>> {
    const response = await this.post<T, { sqlText: string }>('admin/dynamic-query/execute', {
      sqlText,
    });
    return response.data;
  }

  async validateDynamicQuery<T = Record<string, unknown>>(
    sqlText: string
  ): Promise<ApiResponse<T>> {
    const response = await this.post<T, { sqlText: string }>('admin/dynamic-query/validate', {
      sqlText,
    });
    return response.data;
  }
}

export const apiClient = new AxiosConfig(basicConfig);
export const mockApiClient = new AxiosConfig(mockConfig);
