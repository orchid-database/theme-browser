##  Theme browser data generation script
##  Author: Harshana Liyanage
##  Date  : 30 March 2021
##

# Library imports ---------------------------------------------------------
library(tidyverse)

# Icon html look up function
  get_icon_html <- function(iname){
    htmltext <- resources %>% filter(icon_name==iname) %>% select(icon_path) 
    return(toString(htmltext))  
  }


# Load resource file-------------------------------------------------------
resources = read.csv(file ='resources.csv', header = TRUE)

# Load SQL export ---------------------------------------------------------
filename ='Theme-variable-export-20210709.csv'
dfThemeVariables = read.csv(file =filename, header = TRUE)

# Manipulating columns to get the required output format 
dfThemeVariables$Theme <- paste("Theme", dfThemeVariables$ThemeID,sep="")
  
dfThemeVariables$themeFlag <- 1
dfThemeVariables<- dfThemeVariables %>% 
  pivot_wider(names_from='Theme', values_from = 'themeFlag') %>% 
  mutate(
    across(everything(), ~replace_na(.x, 0))
  )

dfThemeVariables$iconstring =""

# dfThemeVarsNested <- dfThemeVariables %>% 
#     group_by(ConditionID) %>% 
#     nest()


##%>% 
  ##group_by(ConditionID) %>% 
  #tally()

#dfMultiTheme <- dfThemeVariables %>% 
#    group_by(ConditionID) %>% 
#    tally()

##Find distinct ConditionIDs

dfThemeVariables[dfThemeVariables$Theme1 == 1, "iconstring-Theme1"] <-   get_icon_html('Theme1')
dfThemeVariables[dfThemeVariables$Theme2 == 1, "iconstring-Theme2"] <-   get_icon_html('Theme2')
dfThemeVariables[dfThemeVariables$Theme3 == 1, "iconstring-Theme3"] <-   get_icon_html('Theme3')
dfThemeVariables[dfThemeVariables$Theme4 == 1, "iconstring-Theme4"] <-   get_icon_html('Theme4')
dfThemeVariables[dfThemeVariables$Theme7 == 1, "iconstring-Theme7"] <-   get_icon_html('Theme7')
dfThemeVariables[dfThemeVariables$Theme10 == 1, "iconstring-Theme10"] <-   get_icon_html('Theme10')
dfThemeVariables[dfThemeVariables$Available != "", "Available"] <-   get_icon_html('check-icon')

dfThemeVariables[is.na(dfThemeVariables)] <- ""   


dfThemeVariables$iconstring = paste0(dfThemeVariables$`iconstring-Theme1`,
                                     dfThemeVariables$`iconstring-Theme2`,
                                     dfThemeVariables$`iconstring-Theme3`,
                                     dfThemeVariables$`iconstring-Theme4`,
                                     dfThemeVariables$`iconstring-Theme7`,
                                     dfThemeVariables$`iconstring-Theme10`)

dfThemeVariables$VariableID = dfThemeVariables$ConditionID
dfThemeVariables$VariableName = paste0(dfThemeVariables$ConditionName," ",dfThemeVariables$iconstring)
# dfThemeVariables <- dfThemeVariables %>% 
#   unite(VariableName, Theme1, Theme2,Theme3, Theme4, Theme7, Theme10, sep = '',na.rm =TRUE)

output <- dfThemeVariables %>% 
              select(VariableID, Category, VariableName, VariableType, OutputType, Comment, Available)

write.csv(output, file=paste("formatted_",filename,sep=""),row.names=FALSE)
