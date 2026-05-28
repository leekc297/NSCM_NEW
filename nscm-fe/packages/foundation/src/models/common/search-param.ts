export interface DivisionId {
  CODE: string;
  NAME: string;
}

export interface Team {
  CODE: string;
  NAME: string;
  DIVISION_ID: string;
}

export interface EndCustomer {
  CODE: string;
  NAME: string;
  DIVISION_ID: string;
  DEPT_ID: string;
}

export interface SalesSite {
  CODE: string;
  NAME: string;
  DIVISION_ID: string;
  END_CUSTOMER?: string;
  DEPT_ID?: string;
}

export interface BizType {
  CODE: string;
  NAME: string;
  DIVISION_ID: string;
}

export interface Bucket {
  CODE: string;
  NAME: string;
}
