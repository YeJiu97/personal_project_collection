# packages
library(corrplot)
library(readr)
library(ggplot2)
library(dplyr)
library(maps)
library(tidyverse)
library(mapdata)
library(sf)
library(treemapify)
library(reshape2)
library(scales)  # 加载scales包以使用数字格式
library(tidyr)
library(dplyr)
library(ggplot2)
library(gplots)

# 导入country_vaccinations.csv
country_vaccinations <- read_csv("country_vaccinations.csv")

# 导入country_vaccinations_by_manufacturer.csv
country_vaccinations_by_manufacturer <- read_csv("country_vaccinations_by_manufacturer.csv")

# 导入owid-covid-data.csv
owid_covid_data <- read_csv("owid-covid-data.csv")
owid_covid_data <- owid_covid_data[owid_covid_data$continent!="", ]  # remove conient == "" data

# check dataset
str(owid_covid_data)



# ======================================================
# ===   visualization for death and case =========
# ======================================================
# 可视化 2：每年的total case的不同conient的占比和变化
# 选择所需的列
data <- owid_covid_data %>%
  select(continent, location, date, total_cases)

# 转换日期为年份
data <- data %>%
  mutate(year = lubridate::year(date))

data$total_cases <- ifelse(is.na(data$total_cases), 0, data$total_cases)


# 找到每个国家每年的最大总病例数
max_cases <- data %>%
  group_by(continent, location, year) %>%
  summarize(max_total_cases = max(total_cases, na.rm = TRUE))

max_cases <- max_cases %>%
  filter(max_total_cases != -Inf)

# 根据大洲和年份对数据进行分组，并计算每个大洲每年的总病例数
continent_cases <- max_cases %>%
  group_by(continent, year) %>%
  summarize(total_cases = sum(max_total_cases, na.rm = TRUE))

# 绘制堆叠条形图
ggplot(continent_cases, aes(x = year, y = total_cases, fill = continent)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Total Cases", fill = "Continent") +
  theme_minimal() +
  ggtitle("Total COVID-19 Cases by Year and Continent")

# ================================================================
# 可视化 1: total case by time and conient
# 创建包含大陆和新病例的子数据集
continent_new_cases <- subset(owid_covid_data, !is.na(continent) & !is.na(new_cases))

# 使用ggplot2绘制可视化图表
ggplot(continent_new_cases, aes(x = date, y = new_cases, color = continent)) +
  geom_line() +
  labs(x = "Date", y = "New Cases", color = "Continent", title = "New Cases by Continent") +
  scale_x_date(date_breaks = "2 month", date_labels = "%b %Y") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  # 旋转横坐标标签
        plot.title = element_text(hjust = 0.5))  # 设置标题居中


# ================================================================
# 可视化 3：total_death 随着时间的变化，每个continent
# Select necessary columns
death_data <- owid_covid_data %>%
  select(continent, location, date, total_deaths)

# Convert date to year
death_data <- death_data %>%
  mutate(year = lubridate::year(date))

death_data$total_deaths <- ifelse(is.na(death_data$total_deaths), 0, death_data$total_deaths)
death_data <- death_data[death_data$continent != "",]

# Find the maximum total deaths for each country in each year
max_deaths <- death_data %>%
  group_by(continent, location, year) %>%
  summarize(max_total_deaths = max(total_deaths, na.rm = TRUE))

max_deaths <- max_deaths %>%
  filter(max_total_deaths != -Inf)

# Group the data by continent and year, and calculate the total deaths for each continent in each year
continent_deaths <- max_deaths %>%
  group_by(continent, year) %>%
  summarize(total_deaths = sum(max_total_deaths, na.rm = TRUE))

# Plot stacked bar chart
ggplot(continent_deaths, aes(x = year, y = total_deaths, fill = continent)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Total Deaths", fill = "Continent") +
  theme_minimal() +
  ggtitle("Total COVID-19 Deaths by Year and Continent")


# Plot stacked area chart
ggplot(continent_deaths, aes(x = year, y = total_deaths, fill = continent)) +
  geom_area() +
  labs(x = "Year", y = "Total Deaths", fill = "Continent") +
  theme_minimal() +
  ggtitle("Total COVID-19 Deaths by Year and Continent")


# ===========================================================
# 可视化 4：接着使用 per 
continent_new_cases_per_million <- subset(owid_covid_data, !is.na(continent) & !is.na(new_cases_per_million))

# 使用ggplot2绘制可视化图表
ggplot(continent_new_cases_per_million, aes(x = date, y = new_cases_per_million, color = continent)) +
  geom_line() +
  labs(x = "Date", y = "New Cases per Million", color = "Continent", title = "New Cases per Million by Continent") +
  scale_x_date(date_breaks = "2 month", date_labels = "%b %Y") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  # 旋转横坐标标签
        plot.title = element_text(hjust = 0.5))  # 设置标题居中



# ============================================================
# ========== 可视化第二部分：关于疫苗 ========================
# ============================================================
# bar chart
# the result is not used
# 先提取每个月的每个地方的最新数据
country_vaccinations_by_manufacturer$date <- as.Date(country_vaccinations_by_manufacturer$date)
country_vaccinations_by_manufacturer_monthly <- country_vaccinations_by_manufacturer %>%
  group_by(location, format(date, "%Y-%m")) %>%
  filter(date == max(date)) %>%
  ungroup()

# 在提取每个地方的最新的月份的最新数据
latest_month_data <- country_vaccinations_by_manufacturer_monthly %>%
  group_by(location) %>%
  filter(date == max(date)) %>%
  ungroup()
latest_month_data <- latest_month_data %>%
  arrange(location)

# 开始进行可视化
vaccine_totals <- latest_month_data %>%
  group_by(vaccine) %>%
  summarise(total = sum(total_vaccinations)) %>%
  ungroup()

vaccine_totals <- vaccine_totals %>%
  mutate(percentage = total / sum(total) * 100)

# 获得饼图信息
bar_chart <- ggplot(vaccine_totals, aes(x = vaccine, y = percentage, fill = vaccine)) +
  geom_bar(stat = "identity") +
  labs(title = "Vaccine Usage Percentage", x = "Vaccine", y = "Percentage") +
  scale_fill_discrete(name = "Vaccine") +
  theme_minimal() +
  coord_flip()

print(bar_chart)


# ================================
# treemap
# 获得每个疫苗的总接种数量和百分比
vaccine_totals <- latest_month_data %>%
  group_by(vaccine) %>%
  summarise(total = sum(total_vaccinations)) %>%
  ungroup()

vaccine_totals <- vaccine_totals %>%
  mutate(percentage = total / sum(total) * 100,
         total_label = comma(total))  # 使用逗号格式化数字

# 根据百分比创建树状图
treemap <- ggplot(vaccine_totals, aes(area = percentage, fill = vaccine, label = total_label)) +
  geom_treemap() +
  geom_treemap_text(fontface = "bold", place = "centre", grow = TRUE, colour = "white") +  # 在矩形中央显示标签
  labs(title = "Vaccine Usage Count", fill = "Vaccine", size = "Total Vaccinations") +
  scale_fill_brewer(palette = "Set3") +  # 使用更好的配色方案，例如Set3调色板
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(nrow = 1))

print(treemap)



# =========================================
# usage over time
# Calculate total usage for each vaccine and month
vaccine_usage <- country_vaccinations_by_manufacturer %>%
  group_by(vaccine, month = lubridate::floor_date(date, "month")) %>%
  summarise(total = sum(total_vaccinations))

# Sort vaccines by total usage
vaccine_usage <- vaccine_usage %>%
  arrange(desc(total))

# Create an area plot
ggplot(vaccine_usage, aes(x = month, y = total, fill = vaccine)) +
  geom_area() +
  labs(title = "Vaccine Usage Over Time", x = "Month", y = "Total Usage") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(title = "Vaccine Category"))




# ==================================================
# proportion
# Calculate total usage for each vaccine and month
vaccine_usage <- country_vaccinations_by_manufacturer %>%
  group_by(vaccine, month = lubridate::floor_date(date, "month")) %>%
  summarise(total = sum(total_vaccinations))

# Calculate the proportion of each vaccine's usage
vaccine_usage <- vaccine_usage %>%
  group_by(month) %>%
  mutate(proportion = total / sum(total))

# Sort vaccines by total usage
vaccine_usage <- vaccine_usage %>%
  arrange(desc(total))

# Create a stacked area plot
ggplot(vaccine_usage, aes(x = month, y = proportion, fill = vaccine)) +
  geom_area() +
  labs(title = "Vaccine Usage Proportion Over Time", x = "Month", y = "Proportion") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(title = "Vaccine Category"))



# =================================
# map 
# 绘制不同国家的疫苗接种人数的map
country_vaccinations_total <- country_vaccinations %>% 
  group_by(country) %>%
  filter(!is.na(people_fully_vaccinated_per_hundred)) %>%
  summarise(
    people_fully_vaccinated_per_hundred = max(people_fully_vaccinated_per_hundred),
    vaccines = first(vaccines)
  ) %>%
  filter(people_fully_vaccinated_per_hundred >= 0.5)

# 设置绘图的宽度和高度
options(repr.plot.width = 20, repr.plot.height = 10)

# 获取地图数据
world_map <- ne_countries(scale = "medium", returnclass = "sf")

# 根据国家名称合并数据
merged_data <- world_map %>%
  select(name, formal_en) %>%
  right_join(country_vaccinations_total, by = c("name" = "country"))

# 绘制地图
map_plot <- merged_data %>%
  ggplot() +
  geom_sf(aes(fill = vaccines, color = vaccines)) +
  theme(legend.position = "bottom", panel.background = element_blank())

# 打印
print(map_plot)

# 将绘图保存到本地文件
ggsave("map_plot.png", plot = map_plot, width = 30, height = 15, dpi = 500)



# ==================================================
# ========== 可视化3：变量之间的关系  ==============
# ==================================================
# ==================================================
# 人口密度和每百万人口的总病例数之间的关系的可视化
# 过滤数据：选择最新日期的数据，并筛选出人口密度和每百万人口总病例数都不为NA的数据
# 筛选出日期为最新且人口密度和每百万人口总病例数都不为NA的数据
filtered_data <- subset(owid_covid_data, !is.na(population_density) & !is.na(total_cases_per_million))

# 获取最新日期
latest_date <- max(filtered_data$date)

# 根据最新日期筛选数据
filtered_data <- subset(filtered_data, date == latest_date)

# 绘制散点图，添加抖动效果
ggplot(filtered_data, aes(x = population_density, y = total_cases_per_million, color = continent)) +
  geom_point(size = 3, position = position_jitter(width = 0.1, height = 0.1)) +
  labs(x = "Population Density", y = "Total Cases per Million", title = "Total Case per Million v.s Population Density") +
  theme_minimal()


# total case per Million 
filtered_vac_data <- subset(owid_covid_data, !is.na(total_vaccinations_per_hundred) & !is.na(total_cases_per_million))

# 获取最新日期
latest_vac_date <- max(filtered_vac_data$date)

# 根据最新日期筛选数据
filtered_vac_data <- subset(filtered_vac_data, date == latest_date)

# 绘制散点图，添加抖动效果
ggplot(filtered_vac_data, aes(x = total_cases_per_million , y = total_vaccinations_per_hundred, color = continent)) +
  geom_point(size = 3, position = position_jitter(width = 0.1, height = 0.1)) +
  labs(x = "Total Cases per Million", y = "Total Vaccinations per Hundred", title = "Total Case per Million v.s Total Vaccinations per Hundred") +
  theme_minimal()

# ============================================================
owid_covid_data$icu_patients_per_million

# 筛选出不缺失的GDP人均和每百万人口死亡数数据
filtered_gdp_data <- subset(owid_covid_data, !is.na(gdp_per_capita) & !is.na(total_deaths))

# 获取最新日期
latest_gdp_date <- max(filtered_gdp_data$date)

# 根据最新日期筛选数据
latest_gdp_data <- subset(filtered_gdp_data, date == latest_gdp_date)


# 绘制气泡图
ggplot(latest_gdp_data, aes(x = gdp_per_capita, y = total_deaths_per_million, size = total_cases_per_million, color = continent)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(1, 10), name = "Total Cases") +
  labs(x = "GDP per Capita", y = "total deaths per million", title = paste("The relationship between GDP per capita and total deaths per million", latest_gdp_date)) +
  theme_minimal()



# 绘制气泡图
ggplot(latest_gdp_data, aes(x = gdp_per_capita, y = total_deaths_per_million)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(1, 10), name = "Total Cases") +
  labs(x = "GDP per Capita", y = "total deaths per million", title = paste("The relationship between GDP per capita and total deaths per million", latest_gdp_date)) +
  theme_minimal()

# ==============================================================
# 选择与人口相关的指标和total_deaths
population_vars <- c("population", "population_density", "median_age", "aged_65_older", "aged_70_older", 
                     "gdp_per_capita", "extreme_poverty", "cardiovasc_death_rate", "diabetes_prevalence", "total_deaths")

# 提取所选指标的数据
population_data <- select(owid_covid_data, location, date, all_of(population_vars))

# 处理缺失值：删除包含缺失值的行
population_data <- na.omit(population_data)

# 计算相关系数矩阵
cor_matrix <- cor(population_data[, population_vars])

# 将相关系数矩阵转换为长格式数据框
cor_data <- melt(cor_matrix)

# 绘制热力图
ggplot(data = cor_data, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = round(value, 2)), color = "black", size = 3) +  # 显示相关系数的数字
  scale_fill_gradient(low = "yellow", high = "red") +
  labs(title = "Correlation Heatmap: Population Indicators vs. Total Deaths",
       x = "Variables",
       y = "Variables",
       fill = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# ================================================================
# 选择与医疗资源相关的指标和total_deaths
healthcare_vars <- c("icu_patients", "icu_patients_per_million", "hosp_patients", "hosp_patients_per_million",
                     "weekly_icu_admissions", "weekly_icu_admissions_per_million", "weekly_hosp_admissions",
                     "weekly_hosp_admissions_per_million", "hospital_beds_per_thousand", "total_deaths")

# 提取所选指标的数据
healthcare_data <- select(owid_covid_data, location, date, all_of(healthcare_vars))

# 处理缺失值：删除包含缺失值的行
healthcare_data <- na.omit(healthcare_data)

# 计算相关系数矩阵
cor_matrix <- cor(healthcare_data[, healthcare_vars])

# 将相关系数矩阵转换为长格式数据框
cor_data <- melt(cor_matrix)

# 绘制热力图
ggplot(data = cor_data, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = round(value, 2)), color = "black", size = 3) +  # 显示相关系数的数字
  scale_fill_gradient(low = "yellow", high = "red") +
  labs(title = "Correlation Heatmap: Healthcare Indicators vs. Total Deaths",
       x = "Variables",
       y = "Variables",
       fill = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

cor_data
