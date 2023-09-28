  
## Introduction
This project aims to look at time spent on our website on certain weekdays and how that differs across campaigns. 
The main goal of this business is to sell products from our e-commerce site, so we will be looking at time spent in connection with dollars spent, in the conext of comparing campaigns.

Since the attribution model for our campaigns is incomplete, we do not see which campaign generated how much revenue. We can only see data on an aggregate level. 
This way, the context of our analysis becomes `campaign` versus `no campaign`.

In the following sections we will go through: 
1. Data preparation - querying data and checking for any outliers; and performing correlation and regression analysis between the two above mentioned variables.
2. Analysis of 3 hypotheses
3. Conclusion


## Data Preparation


#### SQL code:
``` SQL
WITH
  user_touchpoints AS (
  SELECT
    user_pseudo_id,
    CASE
      WHEN campaign IN ('BlackFriday_V1', 'BlackFriday_V2', '(data deleted)', 'NewYear_V1', 'NewYear_V2', 'Holiday_V1', 'Holiday_V2') THEN 'marketing_campaign'
    ELSE
    'not_marketing_campaign'
  END
    AS campaign_category,
    PARSE_DATE('%Y%m%d', event_date) AS touch_date,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS first_touch_timestamp,
    MAX(TIMESTAMP_MICROS(event_timestamp)) AS last_touch_timestamp,
    AVG(purchase_revenue_in_usd) AS avg_revenue
  FROM
    `turing_data_analytics.raw_events`
  GROUP BY
    user_pseudo_id,
    campaign_category,
    touch_date )
SELECT
  ut.touch_date,
  ut.campaign_category,
  ROUND(AVG(DATETIME_DIFF(ut.last_touch_timestamp, ut.first_touch_timestamp, MINUTE)), 2) AS avg_time_spent_minutes,
  ROUND(AVG(ut.avg_revenue),2) AS avg_revenue
FROM
  user_touchpoints ut
GROUP BY
  ut.touch_date,
  ut.campaign_category
ORDER BY
  ut.touch_date,
  ut.campaign_category;
```
### Outliers 
As part of data preparation, we examined any outliers for `avg_time_spent_minutes`.


| Outliers       |         |
| -------------- | ------  |
| First quartile | 9.025   |
| Third quartile | 30.67   |
| IQR            | 21.645  |
| Lower bound    | -23.4425|
| Upper bound    | 63.1375 |

![viz](https://github.com/TuringCollegeSubmissions/akilin-ABP.2/blob/main/M4S2%20-%20Scatterplot.png) 

Since **none of the values** are outside of the bounds, we continue including all values in our correlation and regression analysis.


**Next up**: Correlation analysis and a simple linear regression analysis between two variables: `avg_time_spent_minutes` and `revenue`. 

### Correlation Analysis

1. **Correlation Coefficient**: The correlation coefficient between `avg_time_spent_minutes` and `revenue` is approximately 0.625. This value indicates a moderate to strong positive linear relationship between the two variables. In other words, as the average time spent by users increases, the revenue tends to increase as well, and vice versa.

2. **Significance**: The correlation coefficient is statistically significant _(p < 0.05)_, which suggests that the observed correlation is unlikely to be due to random chance. In other words, there is a significant association between these two variables.

![viz](https://github.com/TuringCollegeSubmissions/akilin-ABP.2/blob/main/M4S2%20scatterplot%20correlation.png) 

## Linear Regression Analysis

1. **Multiple R**: The multiple correlation coefficient (R) is approximately 0.625, which is the same as the correlation coefficient obtained earlier. This value indicates the strength of the linear relationship between the independent variable (`avg_time_spent_minutes`) and the dependent variable (`revenue`) when performing a linear regression analysis.

2. **R-Square**: The R-square (R²) value is approximately 0.391. This represents the proportion of the variance in the dependent variable (`revenue`) that can be explained by the independent variable (`avg_time_spent_minutes`). In this case, about 39.1% of the variation in revenue can be explained by variations in average time spent.

3. **Adjusted R-Square**: The adjusted R-squared value accounts for the number of predictors in the model. It is approximately 0.388, which is similar to the R-squared value.

4. **Standard Error**: The standard error is a measure of the variability of the residuals (the differences between the observed and predicted values of the dependent variable). In this case, it is approximately 9.31.

5. **Observations**: There are 184 data points in your dataset.

#### ANOVA (Analysis of Variance)

1. **Regression Sum of Squares (SS)**: The regression sum of squares is approximately 10,123.1033. This represents the variation in the dependent variable (`revenue`) that is explained by the independent variable (`avg_time_spent_minutes`).

2. **Residual Sum of Squares (SS)**: The residual sum of squares is approximately 15,773.71408. This represents the unexplained variation in `revenue` that is not accounted for by the linear relationship with `avg_time_spent_minutes`.

3. **Total Sum of Squares (SS)**: The total sum of squares is approximately 25,896.81738. It represents the total variation in `revenue` before and after considering the independent variable.

4. **F-Statistic**: The F-statistic is 116.8022, and its associated p-value is 0. This indicates that the linear regression model is statistically significant. In other words, there is strong evidence that the independent variable (`avg_time_spent_minutes`) is associated with changes in the dependent variable (`revenue`).

#### Coefficients

1. **Intercept**: The intercept is approximately 15.49. This is the predicted value of `revenue` when `avg_time_spent_minutes` is zero. However, since it doesn't make sense for `avg_time_spent_minutes` to be zero in this context, this intercept may not have a practical interpretation.

2. **X Variable 1 (Slope)**: The coefficient for `avg_time_spent_minutes` is approximately 0.0026. This represents the change in `revenue` for a one-unit change in `avg_time_spent_minutes`. In other words, for each additional minute spent on average, revenue is expected to increase by approximately 0.0026 units.

###  Data prep summary 
In summary, the analysis indicates a statistically significant positive linear relationship between `avg_time_spent_minutes` and `revenue`. Approximately 39.1% of the variation in revenue can be explained by variations in average time spent. The coefficient for `avg_time_spent_minutes` suggests that, on average, each additional minute spent is associated with an increase in revenue of approximately 0.0026 units.

What this means for us is that it is statistically relevant to continue analysing website visitor and customer behavior in the context of how much time they spend on our e-commerce site.

**Next up**:  finding out if users tend to spend more time on your website on certain weekdays and how that behavior differs across campaigns
## Analysis

In this next section, we continue by finding insights about users coming from campaigns and thos who do not come from campaigns.

OBS: for hypotheses A and B, interactive dashboard can be found on [Tableau here](https://public.tableau.com/views/M4S2-CampaignsvsnotcampaignTimespentversusamountspent/Dashboard1?:language=en-GB&publish=yes&:display_count=n&:origin=viz_share_link).

#### Hypothesis A 
*Users spend more time on our e-commerce site on certain weekdays.*

![viz](https://github.com/TuringCollegeSubmissions/akilin-ABP.2/blob/main/M4S2%20DOW%20avg%20time%20spent.png)

This hypothesis is **accepted** based on the results and seen on the above visualization.

Why does this matter? Well, according to our linear regression, we know that time spent on our website has a positive impact on amount spent.

After a quick look into average amount spent on certain weekdays, we notice that there is possibly better correlation between the two variables in the case of `not campaign`than `campaign`:

![viz](https://github.com/TuringCollegeSubmissions/akilin-ABP.2/blob/main/M4S2%20DOW%20avg%20amount%20spent.png)

we continue into the next hypothesis:

#### Hypothesis B
*In the context of spending time on our e-commerce site, users have different purchasing behavior when they come from a `campaign` versus `not_campaign`.*

![viz](https://github.com/TuringCollegeSubmissions/akilin-ABP.2/blob/main/M4S2%20Daily%20dynamic.png)

What we observe here is that the hypothesis is **accepted** because users behaved differently when they originated from a campaign versus not a campaign: 
- When users do not come from a campaign, their purchasing behavior is shown as more predictable, the peaks and lows are less erratic. 

Normally, a new regression analysis would be our next step, to see if there is any difference between the two variables in `campaign` versus `not campaign`, but after a quick data pull, we notice that the number of events in `campaign` is very low. Therefore we advise generating more data before running such analysis. 

|              | Visitors | Customers |
| ------------ | -------- | --------- |
| not_campaign | 1947     | 1645      |
| campaign     | 81       | 71        |


#### Hypothesis C 
*Running campaigns will perform better than not running campaigns.*

The above results about visitors and customer were extracted from data we pulled for an A/B test. In this test we are comparing `campaign` and `not_campaign`. This helps us find out whether there running campaign perform better than not running campaigns.

```SQL
WITH visitors_cte AS(
    SELECT
    campaign, 
    COUNT (DISTINCT user_pseudo_id) AS all_visitors
    FROM `turing_data_analytics.raw_events`
    group by campaign
  )
  SELECT
  CASE
      WHEN re.campaign IN ('BlackFriday_V1', 'BlackFriday_V2', '(data deleted)', 'NewYear_V1', 'NewYear_V2', 'Holiday_V1', 'Holiday_V2') THEN 'marketing_campaign'
    ELSE
    'not_marketing_campaign'
  END
    AS campaign_category,
    COUNT(all_visitors) AS visitors,
    COUNT (DISTINCT user_pseudo_id) customers,
    SUM(purchase_revenue_in_usd) total_revenue
FROM
  `turing_data_analytics.raw_events` re
  JOIN visitors_cte vcte
  ON re.campaign = vcte.campaign
  WHERE purchase_revenue_in_usd > 0
  group by campaign_category
```
In our A/B test `A` stands for `non-campaign` while `B` for `campaign`
![A/B Test](https://github.com/TuringCollegeSubmissions/akilin-ABP.2/blob/main/AB%20Test%20-%20M4S2.png)

Result shows that, although the conversion rate is considerably higher where visitors come from being exposed to a campaign, versus visitors who do not - statistically it is not more significant. 

Thus, the hypothesis is **rejected**. Why did this happen? As mentioned above, the number of events in `campaign` is very low and we advise collecting more data and repeating the test later.


## Conclusion

There is compelling evidence that the user behavior is different when they originate from a `campaign` versus when they do not. 

We must consider three things: 

- the limited amount of data from `campaigns` which hinder apples to apples comparison
- the context of seasonality: holidays are known to generate more purchases than days outside of holidays, in general
- users go through a purchasing funnel and as long as they do not know about a brand or the breadth of their offering, they will never consider buying; awareness campaigns are needed to fill the top of the funnel.

In conclusion, we advise:
- testing `campaign` vs. `not_campaign` comparisons during low season to see the power of campaigning. 
- having an "always-on" campaign to raise awareness and fill the top of the funnel

  
**Presentation can be found**: [here](https://github.com/TuringCollegeSubmissions/akilin-ABP.2/blob/main/Presentation%20-%20M4S2%20-%20Graded%20-%20Website%20Visitor%20Analysis%20and%20Campaign%20Impact.pdf)

