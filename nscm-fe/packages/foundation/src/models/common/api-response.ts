export interface ApiResponse<T = unknown> {
  result: T;
  code?: string;
  message?: string;
}

export interface I18nResponse {
  messageId: string;
  message: string;
  langCd: string;
}
