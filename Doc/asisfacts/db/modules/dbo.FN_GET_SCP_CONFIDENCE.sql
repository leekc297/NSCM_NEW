CREATE FUNCTION [dbo].[FN_GET_SCP_CONFIDENCE]
(
    @alpha FLOAT,            -- Confidence level (e.g., 0.2 for 20% confidence)
    @standard_dev FLOAT,     -- Standard deviation of your data
    @size INT                -- Sample size
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @z FLOAT;
    DECLARE @result FLOAT;

    -- Calculate the Z-score for the given alpha and a two-tailed test using your NORMSINV function
    SET @z = ABS(dbo.FN_GET_SCP_NORMSINV(1 - @alpha / 2));

    -- Calculate the confidence interval
    SET @result = @z * (@standard_dev / SQRT(@size));

    RETURN @result;
END;