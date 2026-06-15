-- DMF0020 사용 combo SQL_ID 인벤토리 (이관 전 사내에 등록 여부 확인용)
-- 사내 등록 combo: ['CurrencyList', 'EndCustomer', 'EndCustomerByDivisionDept', 'Incoterms', 'MyDivision', 'SalesSite', 'SiteByEndCustomer', 'SoldCustomer', 'TeambyDivision', 'YesOrNo']

SELECT SQL_ID FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN (
  'CurrencyList',
  'EndCustomer',
  'EndCustomerByDivisionDept',
  'Incoterms',
  'MyDivision',
  'SalesSite',
  'SiteByEndCustomer',
  'SoldCustomer',
  'TeambyDivision',
  'YesOrNo',
  '_END_'
);
