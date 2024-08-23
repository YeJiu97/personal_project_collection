# ==============================================
library(dplyr)
library(tidyverse)
library(lubridate)
library(janitor)
library(skimr)
library(lubridate)
library(here)
library(maps)
library(rnaturalearth)
library(ggplot2)
library(sf)





# ==============================================
# load dataset
country_vaccinations <- read.csv("country_vaccinations.csv")
country_vaccinations_by_manufacturer <- read.csv("country_vaccinations_by_manufacturer.csv")
owid_covid_data <- read.csv("owid-covid-data.csv")






# ==================================================
# 对疫苗的使用进行分析
str(country_vaccinations_by_manufacturer)

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




vaccine_data <- vaccine_data %>%
  mutate(date = as.Date(date)) %>%
  arrange(date)











# Calculate total usage for each vaccine and month
vaccine_usage <- vaccinations_manufacturer %>%
  group_by(vaccine, month = lubridate::floor_date(date, "month")) %>%
  summarise(total = sum(total_vaccinations))

# Sort vaccines by total usage
vaccine_usage <- vaccine_usage %>%
  arrange(desc(total))

# 获得area plot
ggplot(vaccine_usage, aes(x = month, y = total, fill = vaccine)) +
  geom_area() +
  labs(title = "Vaccine Usage Over Time", x = "Month", y = "Total Usage") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal() +
  theme(legend.position = "centre")

str(country_vaccinations)

# 使用地图
# 提取包含疫苗接种数据的国家数据
country_vaccinations_total <- country_vaccinations %>% 
  group_by(country) %>%
  filter(!is.na(total_vaccinations)) %>%
  summarise(
    total_vaccinations = max(total_vaccinations),
    total_vaccinations_per_hundred = max(total_vaccinations_per_hundred),
    vaccines = first(vaccines),
  ) %>%
  filter(total_vaccinations_per_hundred >= 0.5)

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

# 将绘图保存到本地文件
ggsave("map_plot.png", plot = map_plot, width = 30, height = 15, dpi = 500)


# top 20 for total_vaccinations
top_20_countries <- covid_data_total %>%
  arrange(total_vaccinations) %>%
  tail(20) %>%
  select(country)

covid_data_top_20 <- covid_data_total %>%
  filter(country %in% top_20_countries$country)

covid_data_top_20 <- covid_data_top_20 %>%
  arrange(total_vaccinations)

ggplot(covid_data_top_20, aes(x = total_vaccinations, y = country)) +
  geom_bar(aes(fill = country), position = "identity", stat = "identity", show.legend = FALSE) +
  labs(title = "Number of people vaccinated in each country",
       x = "Total Vaccination", y = "Country", caption = "Data: Covid19") +
  theme(panel.grid = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  coord_flip()


str(country_vaccinations_total)




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

# 将绘图保存到本地文件
ggsave("map_plot.png", plot = map_plot, width = 30, height = 15, dpi = 500)










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

# 将绘图保存到本地文件
ggsave("map_plot_fully.png", plot = map_plot, width = 30, height = 15, dpi = 500)







# 按people_fully_vaccinated_per_hundred降序排列，并选择前20个国家
top_20_countries <- country_vaccinations_total %>%
  arrange(desc(people_fully_vaccinated_per_hundred)) %>%
  head(20) %>%
  select(country)

# 筛选出TOP 20国家的数据
top_20_data <- country_vaccinations_total %>%
  filter(country %in% top_20_countries$country)

# 创建Bar chart可视化
ggplot(top_20_data, aes(x = people_fully_vaccinated_per_hundred, y = country)) +
  geom_bar(aes(fill = country), position = "identity", stat = "identity", show.legend = FALSE) +
  labs(title = "People Fully Vaccinated per Hundred People (Top 20 Countries)",
       x = "People Fully Vaccinated per Hundred", y = "Country", caption = "Data: Covid19") +
  theme(panel.grid = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  coord_flip()




















# ==============================================
str(owid_covid_data)
# 对owid_covid_data数据进行提取
# 将每个地方的每个月的最新的数据提取出来
owid_covid_data$date <- as.Date(owid_covid_data$date)
newest_data <- owid_covid_data %>%
  group_by(continent, format(date, "%Y-%m")) %>%
  filter(date == max(date)) %>%
  ungroup()

# 去除""值
newest_data <- newest_data[newest_data$continent != "", ]
str(newest_data)

# 接着计算每个月的全球的tocal_cases，new_cases，total_deaths，new_deaths，total_cases_per_million
# new_cases_per_million，total_deaths_per_million，new_deaths_per_million的总和
monthly_data <- newest_data %>%
  mutate(month = format(date, "%Y-%m")) %>%
  group_by(month) %>%
  summarize(total_cases = sum(total_cases, na.rm = TRUE),
            new_cases = sum(new_cases, na.rm = TRUE),
            total_deaths = sum(total_deaths, na.rm = TRUE),
            new_deaths = sum(new_deaths, na.rm = TRUE),
            total_cases_per_million = sum(total_cases_per_million, na.rm = TRUE),
            new_cases_per_million = sum(new_cases_per_million, na.rm = TRUE),
            total_deaths_per_million = sum(total_deaths_per_million, na.rm = TRUE),
            new_deaths_per_million = sum(new_deaths_per_million, na.rm = TRUE))
