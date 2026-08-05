package com.lgcns.nscm.framework.interceptor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.utils.NullUtils;
import com.lgcns.nscm.framework.utils.SecurityUtil;

@Intercepts({
    @Signature(
        type = Executor.class,
        method = "update",
        args = {MappedStatement.class, Object.class}
    ),
    @Signature(
        type = Executor.class,
        method = "query",
        args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}
    ),
    @Signature(
        type = Executor.class,
        method = "queryCursor",
        args = {MappedStatement.class, Object.class, RowBounds.class}
    )
})
public class QueryLogInterceptor implements Interceptor {

    private static final Logger log = LoggerFactory.getLogger(QueryLogInterceptor.class);

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final SqlLogWriter sqlLogWriter;
    private final boolean loggingOnlyError;

    private int thresholdMs = 0;

    public QueryLogInterceptor(SqlLogWriter sqlLogWriter, boolean loggingOnlyError) {
        this.sqlLogWriter = sqlLogWriter;
        this.loggingOnlyError = loggingOnlyError;
    }

    @Override
    public Object intercept(Invocation invocation) throws Throwable {

        long start = System.currentTimeMillis();

        MappedStatement ms = (MappedStatement) invocation.getArgs()[0];
        Object parameter = invocation.getArgs().length > 1 ? invocation.getArgs()[1] : null;

        String sqlId = ms.getId();
        SqlCommandType commandType = ms.getSqlCommandType();
        String sqlType = commandType.name(); // SELECT / INSERT / ...

        BoundSql boundSql = ms.getBoundSql(parameter);
        String sqlText = buildFullSql(boundSql, parameter);

        int resultCount = -1;
        String exceptionMsg = null;

        try {
            Object result = invocation.proceed();

            if (result instanceof List<?> list) {
                resultCount = list.size();
            } else if (result != null) {
                resultCount = 1;
            } else {
                resultCount = 0;
            }

            return result;
        } catch (Exception e) {
            exceptionMsg = e.getClass().getSimpleName() + ": " + e.getMessage();
            throw e;
        } finally {
            long end = System.currentTimeMillis();
            int elapsed = (int) (end - start);

            // 주의: finally 안에서 절대 return 하지 않는다. finally 의 return 은 try 의 실제 쿼리 결과를 덮어쓴다.
            boolean belowThreshold = thresholdMs > 0 && elapsed < thresholdMs;
            boolean hasError = !NullUtils.isNone(exceptionMsg);
            boolean skip = belowThreshold || (loggingOnlyError && !hasError);

            if (!skip) {
                String paramsJson = toJsonSafe(parameter);
                UserSession userSession = SecurityUtil.getUserSession();
                String userId = (userSession != null && userSession.getUserId() != null) ? userSession.getUserId() : "GUEST";
                LocalDateTime now = LocalDateTime.now();

                sqlLogWriter.offer(new SqlLogRecord(
                        sqlId, sqlType, sqlText, elapsed, now, userId, paramsJson, resultCount, exceptionMsg));
            }
        }
    }

    private String toJsonSafe(Object parameter) {
        try {
            return parameter == null ? null : objectMapper.writeValueAsString(parameter);
        } catch (Exception e) {
            return "param to json error: " + e.getMessage();
        }
    }

    // ? 를 실제 값으로 치환한 SQL 문자열 생성 (로그용)
    private String buildFullSql(BoundSql boundSql, Object parameterObject) {
        String sql = boundSql.getSql();
        List<ParameterMapping> paramMappings = boundSql.getParameterMappings();

        if (paramMappings == null || paramMappings.isEmpty()) {
            return sql;
        }

        Object paramObj = (parameterObject != null) ? parameterObject : boundSql.getParameterObject();

        StringBuilder sb = new StringBuilder();
        int paramIndex = 0;
        int qIndex;
        int prev = 0;

        while ((qIndex = sql.indexOf('?', prev)) != -1 && paramIndex < paramMappings.size()) {
            sb.append(sql, prev, qIndex);
            Object value = getParameterValue(paramObj, boundSql, paramMappings.get(paramIndex));
            sb.append(formatValueForSql(value));
            prev = qIndex + 1;
            paramIndex++;
        }
        sb.append(sql.substring(prev));

        return sb.toString();
    }

    private Object getParameterValue(Object parameterObject,
                                    BoundSql boundSql,
                                    ParameterMapping parameterMapping) {
        String propertyName = parameterMapping.getProperty();

        if (boundSql.hasAdditionalParameter(propertyName)) {
            return boundSql.getAdditionalParameter(propertyName);
        }
        if (parameterObject == null) {
            return null;
        }
        if (parameterObject instanceof Map<?, ?> map) {
            return map.get(propertyName);
        }
        try {
            var field = parameterObject.getClass().getDeclaredField(propertyName);
            field.setAccessible(true);
            return field.get(parameterObject);
        } catch (Exception e) {
            return null;
        }
    }

    private String formatValueForSql(Object value) {
        if (value == null) return "NULL";
        if (value instanceof Number) return value.toString();
        if (value instanceof java.util.Date date) {
            return "'" + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date) + "'";
        }
        return "'" + value.toString().replace("'", "''") + "'";
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {
        String thresholdProp = properties.getProperty("thresholdMs");
        if (thresholdProp != null) {
            try {
                this.thresholdMs = Integer.parseInt(thresholdProp);
            } catch (NumberFormatException ignore) {
            }
        }
    }
}
