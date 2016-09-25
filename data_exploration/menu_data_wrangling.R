##### What's on the menu - Data exploration
# Create dashboards for data exploration


#### Libraries

    library(tidyverse)
    library(stringr)
    library(curl)

    
#### Get data - uncomment if need to get data from source
# https://www.r-bloggers.com/a-fun-gastronomical-dataset-whats-on-the-menu/?utm_source=feedburner&utm_medium=email&utm_campaign=Feed%3A+RBloggers+%28R+bloggers%29
    
    # # This url changes every month, check what's the latest at http://menus.nypl.org/data
    # menu_data_url <- "https://s3.amazonaws.com/menusdata.nypl.org/gzips/2016_09_16_07_00_30_data.tgz"
    # temp_dir <- "C:/Users/Muhsin Karim/Documents/GitHub/whats_on_the_menu/tutorial"
    # curl_download(menu_data_url, file.path(temp_dir, "menu_data.tgz"))
    # untar(file.path(temp_dir, "menu_data.tgz"), exdir = temp_dir)
    # dish <- read_csv(file.path(temp_dir, "Dish.csv"))
    # menu <- read_csv(file.path(temp_dir, "Menu.csv"))
    # menu_item <- read_csv(file.path(temp_dir, "MenuItem.csv"))
    # menu_page <- read_csv(file.path(temp_dir, "MenuPage.csv"))
    # 
    # d <- menu_item %>% select( id, menu_page_id, dish_id, price) %>%
    #     left_join(dish %>% select(id, name) %>% rename(dish_name = name),
    #               by = c("dish_id" = "id")) %>%
    #     left_join(menu_page %>% select(id, menu_id),
    #               by = c("menu_page_id" = "id")) %>%
    #     left_join(menu %>% select(id, date, place, location),
    #               by = c("menu_id" = "id")) %>%
    #     mutate(year = lubridate::year(date)) %>%
    #     filter(!is.na(year)) %>%
    #     filter(year > 1800 & year <= 2016) %>%
    #     select(year, location, menu_id, dish_name, price, place)
    # 
    # 
    # ### Save as .Rdata     
    # setwd("C:/Users/Muhsin Karim/Documents/GitHub/whats_on_the_menu/data_exploration")
    # save(d, file = "whats_on_the_menu.Rdata")
        
    
#### Load saved data

    setwd("C:/Users/Muhsin Karim/Documents/GitHub/whats_on_the_menu/data_exploration")    
    load("whats_on_the_menu.Rdata")
    
    
    
    
    