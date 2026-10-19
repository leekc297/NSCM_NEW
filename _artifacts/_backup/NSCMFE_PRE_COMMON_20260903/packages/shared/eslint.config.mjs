import baseConfig from '../../configs/eslint.config.mjs';

export default [
  ...baseConfig,
  {
    rules: {
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: ['@tanstack/react-query', '@tanstack/react-query/**/*'],
              message: '@foundation에서 re-export된 것을 쓰세요.',
            },
          ],
        },
      ],
    },
  },
];
