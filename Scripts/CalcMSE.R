

MSE <- function(file1, file2) {
  mat1 = data.matrix(read.csv(file1, header=F))
  mat2 = data.matrix(read.csv(file2, header=F))
  
  mat1 = mat1/max(mat1,1) * 100
  mat2 = mat2/max(mat2,1) * 100
  
  if(nrow(mat1)!=ncol(mat1) || nrow(mat2)!=ncol(mat2) || nrow(mat1)!=ncol(mat2))
    stop("Input matrices are not square or do not have same dimensions")
  
  nt = nrow(mat1)
  
  # clear diagonal just in case
  for (i in 1:nt) {
    mat1[i,nt+1-i] = 0
    mat2[i,nt+1-i] = 0
  }
  
  mse = mean((mat1 - mat2)^2)
  return(mse)
}

table <- data.frame(
  id = integer(),
  application = character(),
  filename = character(),
  mse = double(),
  config = character(),  
  stringsAsFactors = FALSE
)


temp = list.files(pattern="*.csv")
appPrev = "";
id = 0;
for (i in 1:length(temp)) {
  app <-sub("\\_.*", "", temp[i])
  if (appPrev != app) {
     id <- 1
     appPrev <- app
  } else {
     id <- id +1
  }
  file = temp[i]
  mse = 0.0
  config = "orig"
  newRow <- data.frame(id, app, file, mse, config)
  table <- rbind(table, newRow)  
}

appPrev = "";
for (i in 1: nrow(table)) {
  app <-table[i, 2]
  if (appPrev != app) {
    fileBase <- paste(app, "_64.csv", sep = "")
    appPrev <- app
  }
  table[i, 4] <- MSE(fileBase, toString(table[i, 3]))
}

write.csv(table, "mseCalculated.txt", row.names = FALSE)

