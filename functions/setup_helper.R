#' A short helper for setting up the water quality script paths
#'
#' @param Year The yeart of data the user wants to target
#'
#' @returns A list of length 2 with two path strings
#'
#' @export
#' @examples
setup_helper <- function(Year){
    
  result <- try({
    
    #get the file path and name of the active document
    script_path <- rstudioapi::getActiveDocumentContext()$path
    
    #remove the unnecessary components of the file path
    short_path <- stringr::str_remove_all(script_path, "~/GitHub/RcWaterQuality/scripts/|.qmd")

    #do an extra removal for the positron editor
    short_path <- stringr::str_extract(short_path, "(?<=\\\\scripts\\\\).*")
    
  }, silent = TRUE)
  
  #if the script is being rendered we have to access the file path using a different option
  if (inherits(result, "try-error")){
    
    #get the file path and name of the active document
    script_path <- glue::glue(getwd(), "/", knitr::current_input())
    
    #remove unnecessary components of the file path
    short_path <- stringr::str_split(script_path, "/scripts/")[[1]][2]
    
    #remove unnecessary components of the file path (part 2)
    short_path <- stringr::str_remove_all(short_path, ".rmarkdown")
    
  }

  #create the full output path that includes the year of data analysed and the date the analysis occured
  output_path <- here::here(glue::glue('outputs/{short_path}/{Year-1}-{Year}/script_ran_on_{format(Sys.time(), "%Y-%m-%d")}/'))
  
  #strip the script name to the very base (just the environment)
  striped_short_path <- stringr::str_extract(short_path, "estuarine|freshwater|inshore|pesticides")
  
  #join sections that will point to the data folder using the shortened version of the script name
  data_path <- here::here(glue::glue("data/{striped_short_path}/"))

  #if it is the 1st or 4th water quality script that is calling this function 
  if (stringr::str_detect(short_path, "s1|s4")){
    
    #include "raw" to the data path
    data_path <- glue::glue("{data_path}/raw/")

    if (stringr::str_detect(short_path, "s1")){

      #create folders for the plots and spreadsheets to be stored separately (since there are so many)
      dir.create(glue::glue("{output_path}/plots/"), recursive = TRUE, showWarnings = FALSE)
      dir.create(glue::glue("{output_path}/spreadsheets/"), recursive = TRUE, showWarnings = FALSE)
    }
        
  #otherwise if it is the 2nd, 3rd or 5th water quality script
  } else if (stringr::str_detect(short_path, "s2|s3|s5")){

    #figure out which water type it is
    water_type <- stringr::str_extract(striped_short_path, "freshwater|estuarine|inshore")
            
    #direct the path to a specific file in the "processed" folder
    data_path <- glue::glue("{data_path}/processed/{Year-1}-{Year}_{water_type}_wq_all")

    #create folder
    dir.create(output_path, recursive = TRUE)

    #create folders for the plots and maps to be stored separately (since there are so many)
    #dir.create(glue::glue("{output_path}/plots/"), recursive = TRUE)
    #dir.create(glue::glue("{output_path}/maps/"), recursive = TRUE)
      
  }

  return(list(data_path, output_path))

}
