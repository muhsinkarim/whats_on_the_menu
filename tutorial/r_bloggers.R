# A Fun Gastronomical Dataset: What's on the Menu?
# https://www.r-bloggers.com/a-fun-gastronomical-dataset-whats-on-the-menu/?utm_source=feedburner&utm_medium=email&utm_campaign=Feed%3A+RBloggers+%28R+bloggers%29

library(tidyverse)
library(stringr)
library(curl)

# This url changes every month, check what's the latest at http://menus.nypl.org/data
menu_data_url <- "https://s3.amazonaws.com/menusdata.nypl.org/gzips/2016_09_16_07_00_30_data.tgz"
temp_dir <- "C:/Users/Muhsin Karim/Documents/GitHub/whats_on_the_menu/tutorial"
curl_download(menu_data_url, file.path(temp_dir, "menu_data.tgz"))
untar(file.path(temp_dir, "menu_data.tgz"), exdir = temp_dir)
dish <- read_csv(file.path(temp_dir, "Dish.csv"))
menu <- read_csv(file.path(temp_dir, "Menu.csv"))
menu_item <- read_csv(file.path(temp_dir, "MenuItem.csv"))
menu_page <- read_csv(file.path(temp_dir, "MenuPage.csv"))

d <- menu_item %>% select( id, menu_page_id, dish_id, price) %>%
    left_join(dish %>% select(id, name) %>% rename(dish_name = name),
              by = c("dish_id" = "id")) %>%
    left_join(menu_page %>% select(id, menu_id),
              by = c("menu_page_id" = "id")) %>%
    left_join(menu %>% select(id, date, place, location),
              by = c("menu_id" = "id")) %>%
    mutate(year = lubridate::year(date)) %>%
    filter(!is.na(year)) %>%
    filter(year > 1800 & year <= 2016) %>%
    select(year, location, menu_id, dish_name, price, place)

d[sample(1:nrow(d), 10), ]

d %>% count(tolower(dish_name)) %>% arrange(desc(n)) %>% head(10)

ggplot(d, aes(year)) +
    geom_histogram(binwidth = 5, center = 1902.5, color = "black", fill = "lightblue") +
    scale_y_continuous("N.o. menu items")

d$decennium = floor(d$year / 10) * 10
foods <- c("coffee", "tea", "pancake", "ice cream", "french frie",
           "french peas", "apple", "banana", "strawberry")
# Above I dropped the "d" in French fries in order 
# to also match "French fried potatoes."
food_over_time <- map_df(foods, function(food) {
    d %>%
        filter(year >= 1900 & year <= 1980) %>%
        group_by(decennium, menu_id) %>%
        summarise(contains_food =
                      any(str_detect(dish_name, regex(food, ignore_case = TRUE)),
                          na.rm = TRUE)) %>%
        summarise(prop_food = mean(contains_food, na.rm = TRUE)) %>%
        mutate(food = food)
})

# A reusable list of ggplot2 directives to produce a lineplot
food_time_plot <- list(
    geom_line(),
    geom_point(),
    scale_y_continuous("% of menus include",labels = scales::percent,
                       limits = c(0, NA)),
    scale_x_continuous(""),
    facet_wrap(~ food),
    theme_minimal(),
    theme(legend.position = "none"))

food_over_time %>% filter(food %in% c("coffee", "tea")) %>%
    ggplot(aes(decennium, prop_food, color = food)) + food_time_plot

food_over_time %>% filter(food %in% c("pancake", "ice cream")) %>%
    ggplot(aes(decennium, prop_food, color = food)) + food_time_plot

food_over_time %>% filter(food %in% c("french frie", "french peas")) %>%
    ggplot(aes(decennium, prop_food, color = food)) + food_time_plot

food_over_time %>% filter(food %in% c("apple", "banana", "strawberry")) %>%
    ggplot(aes(decennium, prop_food, color = food)) + food_time_plot


### Save as .Rdata

    setwd("C:/Users/Muhsin Karim/Documents/GitHub/whats_on_the_menu/tutorial")
    save(d, food_over_time, file = "whats_on_the_menu.Rdata")
