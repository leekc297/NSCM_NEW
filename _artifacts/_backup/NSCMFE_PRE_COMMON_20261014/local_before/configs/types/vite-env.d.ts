/// <reference types="vite/client" />
/// <reference types="node" />

interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string;
  readonly VITE_PROXY_BASE_URL: string;
  readonly VITE_API_TIMEOUT: string;
  readonly VITE_ENV: string;
  
  readonly VITE_APP_NAME: string;
  readonly VITE_KO_NAME: string;
  readonly VITE_EN_NAME: string;
  readonly VITE_TITLE_NAME: string;
  readonly [key: string]: string;
  readonly MODE: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
