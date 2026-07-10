import axios, { AxiosHeaders } from 'axios';
import type { AxiosInstance, AxiosRequestConfig, AxiosPromise } from 'axios';

import type {
  ApiResponse,
  LookupParam,
  ComboParam,
  ComboResponse,
  LookupResponse,
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
  async getCombo(params: ComboParam): Promise<ComboResponse[]> {
    const response = await this.post<ComboResponse[], ComboParam>('admin/combo', params);
    return response.data.result;
  }

  async getLookup(params: LookupParam): Promise<LookupResponse[]> {
    const response = await this.post<LookupResponse[], LookupParam>('admin/lookup', params);
    return response.data.result;
  }
}

export const apiClient = new AxiosConfig(basicConfig);
export const mockApiClient = new AxiosConfig(mockConfig);
