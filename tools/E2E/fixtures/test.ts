import { test as base } from '@playwright/test';
import { Nscm, CFG } from '../lib/nscm';
export type Opts = { account: string; division: string };
export const test = base.extend<{ nscm: Nscm } & Opts>({
  account: [process.env.E2E_ACCOUNT || CFG.defaultAccount, { option: true }],
  division: [process.env.E2E_DIVISION || CFG.defaultDivision, { option: true }],
  nscm: async ({ page, account }, use) => { const n = new Nscm(page); await n.loginAs(account); await use(n); },
});
export { expect } from '@playwright/test';
