library(ggplot2)

# load dataset as dataframe
vaccination_df <- read.csv("country_vaccinations.csv")
vaccinations_manufacturer <- read.csv("country_vaccinations_by_manufacturer.csv")
owid_df <- read.csv("owid-covid-data.csv")

# information for the dataframe
str(owid_df)



# 按照continent是否为空拆分数据集
owid_country_df <- owid_df[owid_df$continent != "", ]
owid_df_continent_null <- owid_df[owid_df$continent == "" & owid_df$location != "World", ]



#  折线图
library(ggplot2)
library(dplyr)

# 提取所需数据
new_cases_data <- owid_country_df %>%
  filter(!is.na(new_cases)) %>%
  mutate(date = as.Date(date),
         month = format(date, "%Y-%m")) %>%
  group_by(continent, month) %>%
  summarise(total_new_cases = sum(new_cases))

# 绘制折线图
ggplot(new_cases_data, aes(x = month, y = total_new_cases, color = continent)) # +
  # geom_line(aes(group = 1)) +
  # labs(x = "月份", y = "每月总新病例数", color = "洲") +
  # scale_x_discrete(labels = new_cases_data$month, breaks = new_cases_data$month) +
  # theme_minimal()


library(ggplot2)
library(dplyr)

# 将日期转换为日期格式
owid_country_df$date <- as.Date(owid_country_df$date)

# 提取所需数据
new_cases_data <- owid_country_df %>%
  filter(!is.na(new_cases)) %>%
  group_by(continent, month = lubridate::floor_date(date, "month")) %>%
  summarise(total_new_cases = sum(new_cases))

# 绘制折线图
ggplot(new_cases_data, aes(x = month, y = total_new_cases, color = continent)) +
  geom_line() +
  labs(x = "月份", y = "每月总新病例数", color = "洲") +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 month") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))




library(ggplot2)
library(dplyr)

# 将日期转换为日期格式
owid_country_df$date <- as.Date(owid_country_df$date)

# 提取所需数据
new_cases_data <- owid_country_df %>%
  filter(!is.na(new_cases)) %>%
  group_by(continent, month = lubridate::floor_date(date, "month")) %>%
  summarise(total_new_cases = sum(new_cases))

# 绘制折线图
ggplot(new_cases_data, aes(x = month, y = total_new_cases, color = continent)) +
  geom_line() +
  labs(x = "Month", y = "Total New Case Per Month", color = "Contient") +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 month") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    legend.position = "bottom",  # 将图例放置在底部
    legend.title = element_text(face = "bold"),  # 设置图例标题为粗体
    legend.text = element_text(size = 10)  # 调整图例文本的大小
  )



# 
str(vaccinations_manufacturer)


# 疫苗的饼图
library(ggplot2)
library(dplyr)

# 计算每种疫苗的使用总量
vaccine_totals <- vaccinations_manufacturer %>%
  group_by(vaccine) %>%
  summarise(total = sum(total_vaccinations))

# 根据使用总量排序疫苗
vaccine_totals <- vaccine_totals %>%
  arrange(desc(total))

# 计算百分比
vaccine_totals <- vaccine_totals %>%
  mutate(percentage = total / sum(total) * 100)

# 绘制饼图
ggplot(vaccine_totals, aes(x = "", y = percentage, fill = vaccine)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  coord_polar("y", start = 0) +
  labs(title = "不同类型的疫苗的总体使用情况", fill = "疫苗") +
  theme_minimal() +
  theme(legend.position = "right") +
  scale_fill_brewer(palette = "Set3")  # 使用颜色调色板进行填充，选择适合饼图的颜色



# 

library(ggplot2)
library(dplyr)

# Convert date column to date format
vaccinations_manufacturer$date <- as.Date(vaccinations_manufacturer$date)

# Calculate total usage for each vaccine and month
vaccine_usage <- vaccinations_manufacturer %>%
  group_by(vaccine, month = lubridate::floor_date(date, "month")) %>%
  summarise(total = sum(total_vaccinations))

# Sort vaccines by total usage
vaccine_usage <- vaccine_usage %>%
  arrange(desc(total))

# Create the area plot
ggplot(vaccine_usage, aes(x = month, y = total, fill = vaccine)) +
  geom_area() +
  labs(title = "Vaccine Usage Over Time", x = "Month", y = "Total Usage") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal() +
  theme(legend.position = "right")




library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)
library(here)

# Load world map shapefile
world_map <- ne_countries(scale = "medium", returnclass = "sf") %>%
  select(name, formal_en)

# Join vaccination data with world map data
vaccine_countries <- world_map %>%
  right_join(vaccinations_manufacturer, by = c("name" = "location"))

# Create the plot
ggplot() +
  geom_sf(data = vaccine_countries, aes(fill = vaccine, color = vaccine)) +
  theme(legend.position = "bottom", panel.background = element_blank())



library(ggplot2)
library(dplyr)
library(sf)
library(rnaturalearth)


new_cases_data <- vaccinations_manufacturer %>%
  group_by(location) %>%
  summarise(total_vaccinations_sum = sum(total_vaccinations))



world_map <- ne_countries(scale = "medium", returnclass = "sf")
vaccine_map_data <- world_map %>%
  inner_join(new_cases_data, by = c("name" = "location"))
ggplot() +
  geom_sf(data = vaccine_map_data, aes(fill = vaccine)) +
  labs(title = "Vaccines Used in Each Country") +
  theme_minimal()


str(vaccinations_manufacturer)




library(dplyr)

# 计算每个国家使用最多的疫苗
most_used_vaccine <- vaccinations_manufacturer %>%
  group_by(location) %>%
  summarise(max_total_vaccinations = max(total_vaccinations)) %>%
  inner_join(vaccinations_manufacturer, by = c("location", "max_total_vaccinations")) %>%
  distinct(location, vaccine)

# 输出每个国家使用最多的疫苗
most_used_vaccine



