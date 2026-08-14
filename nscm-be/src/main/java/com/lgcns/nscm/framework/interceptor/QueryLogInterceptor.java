package com.lgcns.nscm.framework.interceptor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

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
import com.lgcns.nscm.framework.property.CommonProperties;
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
    private static final ThreadLocal<Boolean> logging = ThreadLocal.withInitial(() -> false);

    private final DataSource dataSource;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final CommonProperties commonProperties;

    private int thresholdMs = 0;

    public QueryLogInterceptor(DataSource dataSource, CommonProperties commonProperties) {
        this.dataSource = dataSource;
        this.commonProperties = commonProperties;
    }

    @Override
    public Object intercept(Invocation invocation) throws Throwable {

        if (Boolean.TRUE.equals(logging.get())) {
            return invocation.proceed();
        }

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

            if (thresholdMs > 0 && elapsed < thresholdMs) {
                return null;
            }

            String paramsJson = toJsonSafe(parameter);
            UserSession userSession = SecurityUtil.getUserSession();
            String userId =  (userSession != null && userSession.getUserId() != null) ? userSession.getUserId() : "GUEST";
            LocalDateTime now = LocalDateTime.now();

            // logging.set(true);
            if(commonProperties.getMybatis().isLoggingOnlyError()) {
            	if(!NullUtils.isNone(exceptionMsg)) insertSqlLog(sqlId, sqlType, sqlText, elapsed, now, userId, paramsJson, resultCount, exceptionMsg);
            } else insertSqlLog(sqlId, sqlType, sqlText, elapsed, now, userId, paramsJson, resultCount, exceptionMsg);
        }
    }

    private void insertSqlLog(String sqlId,
                              String sqlType,
                              String sqlText,
                              int elapsedMs,
                              LocalDateTime executeTime,
                              String userId,
                              String paramsJson,
                              int resultCount,
                              String exceptionMsg) {

        String insertSql =
            "INSERT INTO SCM_COM_SQL_LOG " +
            " (SQL_ID, SQL_TYPE, SQL_TEXT, ELAPSED_MS, EXECUTE_TIME, CREATED_BY, PARAMS, RESULT_COUNT, EXCEPTION) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {

            ps.setString(1, sqlId);
            ps.setString(2, sqlType);
            ps.setString(3, sqlText);
            ps.setInt(4, elapsedMs);
            ps.setTimestamp(5, Timestamp.valueOf(executeTime));
            ps.setString(6, userId);
            ps.setString(7, paramsJson);

            if (resultCount < 0) {
                ps.setNull(8, java.sql.Types.INTEGER);
            } else {
                ps.setInt(8, resultCount);
            }

            ps.setString(9, exceptionMsg);

            ps.executeUpdate();
        } catch (Exception e) {
            log.warn("Failed to insert SCM_COM_SQL_LOG. sqlId={}, elapsedMs={}, error={}",
                    sqlId, elapsedMs, e.getMessage());
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
