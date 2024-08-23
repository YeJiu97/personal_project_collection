library(ggplot2)
library(GGally)
library(corrplot)
library(vcd)
library(caret)
# library(woeBinning)
library(scorecard)
library(pROC)

# 相关性检测
data_cleaned_with_features_select <- read.csv("cleaned_data_selecte_features.csv")

colnames(data_cleaned_with_features_select)

continuous_variables <- data_cleaned_with_features_select[, c("LIMIT_BAL", "PAY_AMT1", "PAY_AMT2", "PAY_AMT3")]

# 计算相关性矩阵
correlation_matrix <- cor(continuous_variables)

# 打印相关性矩阵
print(correlation_matrix)


# 绘制相关性矩阵的可视化
corrplot(correlation_matrix, method = "color", type = "upper", 
         tl.col = "black", tl.srt = 45, addCoef.col = "black")


# 使用 ggpairs 函数进行可视化
ggpairs(continuous_variables, 
        upper = list(continuous = wrap("cor", size = 4)), 
        lower = list(continuous = "smooth"), 
        diag = list(continuous = "densityDiag"))

# 离散变量数据集
# 选择需要的离散变量列
discrete_variables <- data_cleaned_with_features_select[, c("PAY_0", "PAY_2", "PAY_3", "PAY_4", "PAY_5", "PAY_6")]

# 查看新数据框的前几行，确认结果
head(discrete_variables)



# 初始化一个空的矩阵用于存储Cramer's V 结果
cramers_v_results <- matrix(NA, ncol = ncol(discrete_variables), nrow = ncol(discrete_variables))
rownames(cramers_v_results) <- colnames(discrete_variables)
colnames(cramers_v_results) <- colnames(discrete_variables)

# 计算Cramer's V 结果
for (i in 1:ncol(discrete_variables)) {
  for (j in 1:ncol(discrete_variables)) {
    if (i != j) {
      test <- assocstats(table(discrete_variables[, i], discrete_variables[, j]))
      cramers_v_results[i, j] <- test$cramer
    } else {
      cramers_v_results[i, j] <- NA
    }
  }
}

# 打印Cramer's V 结果
print(cramers_v_results)

# 绘制相关性矩阵的可视化
corrplot(cramers_v_results, method = "color", type = "upper", 
         tl.col = "black", tl.srt = 45, addCoef.col = "black",
         title = "Cramer's V Correlation Matrix",
         mar = c(0, 0, 1, 0))

# 显示 NA 值为白色
corrplot(cramers_v_results, method = "color", type = "upper", 
         tl.col = "black", tl.srt = 45, na.label = "NA", na.label.col = "white",
         title = "Cramer's V Correlation Matrix",
         mar = c(0, 0, 1, 0))


data_cleaned_without_multicollinearity <- data_cleaned_with_features_select[, !colnames(data_cleaned_with_features_select) %in% c("ID, PAY_2", "PAY_4", "PAY_6")]

write.csv(data_cleaned_without_multicollinearity, "data_cleaned_without_multicollinearity.csv")


# 开始进行分箱和逻辑回归
colnames(data_cleaned_without_multicollinearity)

data_logic <- split_df(data_cleaned_without_multicollinearity, y = "default.payment",
                       ratio = c(0.6, 0.4), seed = 1234)

label_list = lapply(data_logic, function(x) x$"default.payment")

bins = scorecard::woebin(data_cleaned_without_multicollinearity, y = "default.payment")

data_woe_list = lapply(data_logic, function(x) woebin_ply(x, bins))

# 训练模型
ml = glm(default.payment ~ ., family = binomial(), data = data_woe_list$train)
m_step = step(ml, direction = 'both', trace = FALSE)
m2 = eval(m_step$call)
summary(m_step)

pred_list = lapply(data_woe_list, function(x) predict(m2, x, type = "response"))

perf = perf_eva(pred = pred_list, label = label_list,show_plot =  c('ks', 'lift', 'gain', 'roc', 'lz', 'pr', 'f1', 'density'))

card = scorecard(bins, m2)

score_list = lapply(data_logic, function(x) scorecard_ply(x, card))
perf_psi(score = score_list, label = label_list)
