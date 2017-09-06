while(TRUE){
  Sys.sleep(10)
  system("git add workshop_code.R")
  system("git commit -m 'update'")
  system("git push origin master")
}