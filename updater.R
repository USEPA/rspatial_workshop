while(TRUE){
  Sys.sleep(10)
  if(!dir.exists(here::here(".git"))){
    setwd(here::here())
    prj_name <- stringr::str_extract(here::here(), "[\\w]+$")
    remote_url <- paste0("https://github.com/jhollist/", prj_name)
    system("git init")
    system(paste("git remote add origin", remote_url))
  }
  system("git add scripts/workshop_code.R")
  system("git commit -m 'update'")
  system("git push origin master")
}