{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red44\green55\blue61;\red255\green255\blue255;\red204\green0\blue78;
\red39\green78\blue204;\red0\green0\blue0;\red42\green55\blue62;\red21\green129\blue62;\red238\green57\blue24;
\red107\green0\blue1;}
{\*\expandedcolortbl;;\cssrgb\c22745\c27843\c30588;\cssrgb\c100000\c100000\c100000;\cssrgb\c84706\c10588\c37647;
\cssrgb\c20000\c40392\c83922;\cssrgb\c0\c0\c0;\cssrgb\c21569\c27843\c30980;\cssrgb\c5098\c56471\c30980;\cssrgb\c95686\c31765\c11765;
\cssrgb\c50196\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2   \cf4 \strokec4 ---calculating time spent on the web and revenue generated per day, separating campaign and non-campaign events into 2 categories to be able to compare the effectiveness.\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 WITH\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 user_touchpoints\strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \cf7 \strokec7 (\cf2 \cb1 \strokec2 \
\cb3   \cf5 \strokec5 SELECT\cf2 \cb1 \strokec2 \
\cb3     \strokec6 user_pseudo_id\strokec2 ,\cb1 \
\cb3     \cf5 \strokec5 CASE\cf2 \cb1 \strokec2 \
\cb3       \cf5 \strokec5 WHEN\cf2 \strokec2  \strokec6 campaign\strokec2  \cf5 \strokec5 IN\cf2 \strokec2  \cf7 \strokec7 (\cf8 \strokec8 'BlackFriday_V1'\cf2 \strokec2 , \cf8 \strokec8 'BlackFriday_V2'\cf2 \strokec2 , \cf8 \strokec8 '(data deleted)'\cf2 \strokec2 , \cf8 \strokec8 'NewYear_V1'\cf2 \strokec2 , \cf8 \strokec8 'NewYear_V2'\cf2 \strokec2 , \cf8 \strokec8 'Holiday_V1'\cf2 \strokec2 , \cf8 \strokec8 'Holiday_V2'\cf7 \strokec7 )\cf2 \strokec2  \cf5 \strokec5 THEN\cf2 \strokec2  \cf8 \strokec8 'marketing_campaign'\cf2 \cb1 \strokec2 \
\cb3     \cf5 \strokec5 ELSE\cf2 \cb1 \strokec2 \
\cb3     \cf8 \strokec8 'not_marketing_campaign'\cf2 \cb1 \strokec2 \
\cb3   \cf5 \strokec5 END\cf2 \cb1 \strokec2 \
\cb3     \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 campaign_category\strokec2 ,\cb1 \
\cb3     \cf5 \strokec5 PARSE_DATE\cf7 \strokec7 (\cf8 \strokec8 '%Y%m%d'\cf2 \strokec2 , \strokec6 event_date\cf7 \strokec7 )\cf2 \strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 touch_date\strokec2 ,\cb1 \
\cb3     \cf5 \strokec5 MIN\cf7 \strokec7 (\cf5 \strokec5 TIMESTAMP_MICROS\cf7 \strokec7 (\cf2 \strokec6 event_timestamp\cf7 \strokec7 ))\cf2 \strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 first_touch_timestamp\strokec2 ,\cb1 \
\cb3     \cf5 \strokec5 MAX\cf7 \strokec7 (\cf5 \strokec5 TIMESTAMP_MICROS\cf7 \strokec7 (\cf2 \strokec6 event_timestamp\cf7 \strokec7 ))\cf2 \strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 last_touch_timestamp\strokec2 ,\cb1 \
\cb3     \cf5 \strokec5 AVG\cf7 \strokec7 (\cf2 \strokec6 purchase_revenue_in_usd\cf7 \strokec7 )\cf2 \strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 avg_revenue\cb1 \strokec2 \
\cb3   \cf5 \strokec5 FROM\cf2 \cb1 \strokec2 \
\cb3     \cf8 \strokec8 `turing_data_analytics.raw_events`\cf2 \cb1 \strokec2 \
\cb3   \cf5 \strokec5 GROUP\cf2 \strokec2  \cf5 \strokec5 BY\cf2 \cb1 \strokec2 \
\cb3     \strokec6 user_pseudo_id\strokec2 ,\cb1 \
\cb3     \strokec6 campaign_category\strokec2 ,\cb1 \
\cb3     \strokec6 touch_date\strokec2  \cf7 \strokec7 )\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 SELECT\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 ut\strokec2 .\strokec6 touch_date\strokec2 ,\cb1 \
\cb3   \strokec6 ut\strokec2 .\strokec6 campaign_category\strokec2 ,\cb1 \
\cb3   \cf5 \strokec5 ROUND\cf7 \strokec7 (\cf5 \strokec5 AVG\cf7 \strokec7 (\cf5 \strokec5 DATETIME_DIFF\cf7 \strokec7 (\cf2 \strokec6 ut\strokec2 .\strokec6 last_touch_timestamp\strokec2 , \strokec6 ut\strokec2 .\strokec6 first_touch_timestamp\strokec2 , \strokec6 MINUTE\cf7 \strokec7 ))\cf2 \strokec2 , \cf9 \strokec9 2\cf7 \strokec7 )\cf2 \strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 avg_time_spent_minutes\strokec2 ,\cb1 \
\cb3   \cf5 \strokec5 ROUND\cf7 \strokec7 (\cf5 \strokec5 AVG\cf7 \strokec7 (\cf2 \strokec6 ut\strokec2 .\strokec6 avg_revenue\cf7 \strokec7 )\cf2 \strokec2 ,\cf9 \strokec9 2\cf7 \strokec7 )\cf2 \strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 avg_revenue\cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 FROM\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 user_touchpoints\strokec2  \strokec6 ut\cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 GROUP\cf2 \strokec2  \cf5 \strokec5 BY\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 ut\strokec2 .\strokec6 touch_date\strokec2 ,\cb1 \
\cb3   \strokec6 ut\strokec2 .\strokec6 campaign_category\cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 ORDER\cf2 \strokec2  \cf5 \strokec5 BY\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 ut\strokec2 .\strokec6 touch_date\strokec2 ,\cb1 \
\cb3   \strokec6 ut\strokec2 .\strokec6 campaign_category\strokec2 ;\cb1 \
\cb3   \cf4 \strokec4 --- Calc visitors, customers and revenue\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 WITH\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 visitors_cte\strokec2  \cf5 \strokec5 AS\cf7 \strokec7 (\cf2 \cb1 \strokec2 \
\cb3   \cf5 \strokec5 SELECT\cf2 \cb1 \strokec2 \
\cb3     \strokec6 campaign\strokec2 ,\cb1 \
\cb3     \cf5 \strokec5 COUNT\cf2 \strokec2  \cf7 \strokec7 (\cf5 \strokec5 DISTINCT\cf2 \strokec2  \strokec6 user_pseudo_id\cf7 \strokec7 )\cf2 \strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 all_visitors\cb1 \strokec2 \
\cb3   \cf5 \strokec5 FROM\cf2 \cb1 \strokec2 \
\cb3     \cf8 \strokec8 `turing_data_analytics.raw_events`\cf2 \cb1 \strokec2 \
\cb3   \cf5 \strokec5 GROUP\cf2 \strokec2  \cf5 \strokec5 BY\cf2 \cb1 \strokec2 \
\cb3     \strokec6 campaign\strokec2  \cf7 \strokec7 )\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 SELECT\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \cf5 \strokec5 CASE\cf2 \cb1 \strokec2 \
\cb3     \cf5 \strokec5 WHEN\cf2 \strokec2  \strokec6 re\strokec2 .\strokec6 campaign\strokec2  \cf5 \strokec5 IN\cf2 \strokec2  \cf7 \strokec7 (\cf8 \strokec8 'BlackFriday_V1'\cf2 \strokec2 , \cf8 \strokec8 'BlackFriday_V2'\cf2 \strokec2 , \cf8 \strokec8 '(data deleted)'\cf2 \strokec2 , \cf8 \strokec8 'NewYear_V1'\cf2 \strokec2 , \cf8 \strokec8 'NewYear_V2'\cf2 \strokec2 , \cf8 \strokec8 'Holiday_V1'\cf2 \strokec2 , \cf8 \strokec8 'Holiday_V2'\cf7 \strokec7 )\cf2 \strokec2  \cf5 \strokec5 THEN\cf2 \strokec2  \cf8 \strokec8 'marketing_campaign'\cf2 \cb1 \strokec2 \
\cb3   \cf5 \strokec5 ELSE\cf2 \cb1 \strokec2 \
\cb3   \cf8 \strokec8 'not_marketing_campaign'\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 END\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 campaign_category\strokec2 ,\cb1 \
\cb3   \cf5 \strokec5 COUNT\cf7 \strokec7 (\cf2 \strokec6 all_visitors\cf7 \strokec7 )\cf2 \strokec2  \cf5 \strokec5 AS\cf2 \strokec2  \strokec6 visitors\strokec2 ,\cb1 \
\cb3   \cf5 \strokec5 COUNT\cf2 \strokec2  \cf7 \strokec7 (\cf5 \strokec5 DISTINCT\cf2 \strokec2  \strokec6 user_pseudo_id\cf7 \strokec7 )\cf2 \strokec2  \strokec6 customers\strokec2 ,\cb1 \
\cb3   \cf5 \strokec5 SUM\cf7 \strokec7 (\cf2 \strokec6 purchase_revenue_in_usd\cf7 \strokec7 )\cf2 \strokec2  \strokec6 total_revenue\cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 FROM\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \cf8 \strokec8 `turing_data_analytics.raw_events`\cf2 \strokec2  \strokec6 re\cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 JOIN\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 visitors_cte\strokec2  \strokec6 vcte\cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 ON\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 re\strokec2 .\cf10 \strokec10 campaign\cf2 \strokec2  = \strokec6 vcte\strokec2 .\strokec6 campaign\cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 WHERE\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 purchase_revenue_in_usd\strokec2  \cf7 \strokec7 >\cf2 \strokec2  \cf9 \strokec9 0\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 \strokec5 GROUP\cf2 \strokec2  \cf5 \strokec5 BY\cf2 \cb1 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3   \strokec6 campaign_category\cb1 \strokec2 \
}