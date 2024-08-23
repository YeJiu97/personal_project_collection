import matplotlib.pyplot as plt
import pandas as pd

# 原始数据集的features的IV值
iv_original = {
    'Feature': ['PAY_0', 'PAY_2', 'PAY_3', 'PAY_4', 'PAY_5', 'PAY_6', 'LIMIT_BAL', 'PAY_AMT1', 'PAY_AMT2', 'PAY_AMT3', 'PAY_AMT4', 'PAY_AMT6', 'PAY_AMT5', 'EDUCATION', 'AGE_BINNED', 'SEX', 'AGE', 'MARRIAGE', 'BILL_AMT3', 'BILL_AMT1', 'BILL_AMT2', 'BILL_AMT6', 'BILL_AMT5', 'BILL_AMT4'],
    'IV': [0.866, 0.56, 0.408, 0.358, 0.325, 0.278, 0.174, 0.168, 0.158, 0.125, 0.085, 0.078, 0.07, 0.016, 0.015, 0.01, 0.008, 0.007, 0.005, 0.005, 0.005, 0.004, 0.004, 0.003]
}

# 随机欠采样之后的数据集的features的IV值
iv_resampled = {
    'Feature': ['PAY_0', 'PAY_2', 'PAY_3', 'PAY_4', 'PAY_5', 'PAY_6', 'PAY_AMT1', 'LIMIT_BAL', 'PAY_AMT2', 'PAY_AMT3', 'PAY_AMT4', 'PAY_AMT6', 'PAY_AMT5', 'SEX', 'EDUCATION', 'AGE', 'BILL_AMT1', 'BILL_AMT2', 'BILL_AMT3', 'BILL_AMT4', 'MARRIAGE', 'BILL_AMT5', 'BILL_AMT6'],
    'IV': [0.851, 0.529, 0.404, 0.359, 0.347, 0.304, 0.174, 0.158, 0.154, 0.11, 0.096, 0.082, 0.072, 0.017, 0.013, 0.011, 0.008, 0.008, 0.006, 0.005, 0.005, 0.005, 0.003]
}

# 转换为DataFrame
df_original = pd.DataFrame(iv_original)
df_resampled = pd.DataFrame(iv_resampled)

# 按Feature排序
df_original.sort_values(by='Feature', inplace=True)
df_resampled.sort_values(by='Feature', inplace=True)

# 绘图
plt.figure(figsize=(14, 10))
plt.plot(df_original['Feature'], df_original['IV'], marker)
