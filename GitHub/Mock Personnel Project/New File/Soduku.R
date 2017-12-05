solver <- function(puzzle){
      puzzle <- as.vector(t(as.matrix(puzzle))) #expands puzzle into a vector by row
      
      I <- c(rep(0,9^3),0)
      
      for(j in 1:9){
            for(i in 1:81){
                  I[i+(j-1)*81] <- ifelse(puzzle[i]==j,1,0) #expands puzzle into a length 729 indicator vector
            }#for
      }#for
      I_0 <- sum(I) #normalization constant needed later
      y <- c(rep(1,27*9+81),I_0)
      L1 <- c(rep(1,9^3),0)
      A <- matrix(0,27*9,9^3+1) #to become the matrix of constraints
      block_id <- matrix(0,9,81)
      
      ##Row constraints
      for(i in 1:9){
            block_id[i,(9*(i-1)+1):(9*(i-1)+9)] <- rep(1,9)
      }#for
      
      ##column constraints
      block_dot <- matrix(0,9,81)
      
      for(i in 0:8){ #must dot at 1,10,11,etc for column 1
            indices <- c(1+i,10+i,19+i,28+i,37+i,46+i,55+i,64+i,73+i) #indices for column i
            block_dot[i+1,indices] <- rep(1,9)
      }#for
      ##end column constraints
      
      ##BOX constraints
      box_dot <- matrix(0,9,81)
      
      for(i in 0:2){
            box_dot[i+1,(3*i+1):(3*i+3)] <- rep(1,3)
            box_dot[i+1,(9+3*i+1):(9+3*i+3)] <- rep(1,3)
            box_dot[i+1,(18+3*i+1):(18+3*i+3)] <- rep(1,3)
      }#for
      
      for(i in 0:2){
            box_dot[i+4,(27+3*i+1):(27+3*i+3)] <- rep(1,3)
            box_dot[i+4,(36+3*i+1):(36+3*i+3)] <- rep(1,3)
            box_dot[i+4,(45+3*i+1):(45+3*i+3)] <- rep(1,3)
      }#for
      
      for(i in 0:2){
            box_dot[i+7,(54+3*i+1):(54+3*i+3)] <- rep(1,3)
            box_dot[i+7,(63+3*i+1):(63+3*i+3)] <- rep(1,3)
            box_dot[i+7,(72+3*i+1):(72+3*i+3)] <- rep(1,3)
      }#for
      
      ##require that every cell be filled
      cell_dot <- rep(0,81*9+1)
      for(j in 0:8){
            cell_dot[1+81*j] <- 1
      }#for
      cell_mat <- cell_dot
      for(i in 2:81){
            cell_mat <- rbind(cell_mat,(c(rep(0,i-1),cell_dot[1:(81*9+1-i)],0)))
      }#for
      bigblock<-rbind(block_id,block_dot,box_dot)
      for(i in 0:8){
            A[(27*i+1):(27+27*i),(81*i+1):(81*i+81)] <- bigblock
      }#for
      
      A <- rbind(A,cell_mat,I)
      
      ##add constraint that the solution must agree with the initial puzzle
      sim_sud <- lp(direction="min",objective.in=L1,const.mat=A,const.dir="==",const.rhs=y,all.int=TRUE)
      ##lp_solve package uses revised simplex method for standard linear programs, and branch and bound for integrality requirements
      z<-sim_sud$solution #the solution as an indicator vector
      ##reconstruction of the solution as a standard puzzle
      solved <- matrix(0,9,9)
      
      for(i in 0:8){ #reconstruction of each number's indicator matrix
            indic <- z[(81*i+1):(81*i+81)]
            for(j in 1:81){
                  indic[j] <- ifelse(indic[j]!=0,(i+1),0)
            }#for
            indic <- matrix(indic,nrow=9,ncol=9,byrow=TRUE)
            solved <- solved+indic
      }#for
      
      return(solved)
}#Function Puzzle

plotSudoku <- function(sol, set, sud) {  
      plot(0:10, 0:10, type="n", axes=F, xlab="Column", ylab="Row")
      
      for (row in 1:9) for (col in 1:9) {
            backcol = grey(.95)
            number = sol[row, col]
            if (sud[row, col] != 0) {
                  backcol = grey(.85) # given
                  number = sud[row, col]
            } else if (set[row, col] != 0) { # a guess
                  if (sol[row, col] == 0) {
                        grey(.65) # no solution yet
                        number = set[row, col]
                  } else if (sol[row, col] == set[row, col]) {
                        backcol = rgb(0, 1, 0) # correct guess - green
                  } else {
                        backcol = rgb(1, 0, 0) # wrong guess - red
                  }
            } else if (sol[row, col] != 0) {
                  backcol = rgb(1, 1, 0) # not guessed - yellow
            }
            polygon(c(col-.5, col-.5, col+.5, col+.5), 
                    c((10-row)-.5, (10-row)+.5, (10-row)+.5, (10-row)-.5), col=backcol)
            if (number > 0) text(col, 10-row, number, offset=0)
      }#for
      
      # Add row and column numbers
      for (i in 1:9) {
            text(.25, 10-i, i, offset=0)    
            text(9.75, 10-i, i, offset=0)
            text(i, .1, i, offset=0)        
            text(i, 9.9, i, offset=0)
      }#for
      
      # Plot thick lines
      for (i in seq(.5,9.5,3)) {
            lines(c(.5, 9.5), c(i, i), lwd=3)
            lines(c(i, i), c(.5, 9.5), lwd=3)
      }  #for
}#Function PlotSudoku

# Use shared variables and side-effects, because the dependency graph is messy
setMatrix <- matrix(0, nrow=9, ncol=9)
solutionMatrix <- matrix(0, nrow=9, ncol=9)
sudokuMatrix <- matrix(0, nrow=9, ncol=9)

set <- reactive({
      input$setButton
      isolate({
            setMatrix[as.integer(input$row), as.integer(input$col)] <<- as.integer(input$value)
      })#isolate
})#reactive

restart <- reactive({
      input$newButton
      isolate({
            sudokuMatrix <<- generateSudoku(input$blanks)
      })#isolate
      solutionMatrix <<- matrix(0, nrow=9, ncol=9) 
      setMatrix <<- matrix(0, nrow=9, ncol=9) 
})#reactive

solve <- reactive({
      input$solveButton
      if (input$solveButton != 0) {
            solutionMatrix <<- solver(sudokuMatrix) 
      }#if
})#reactive
output$sudoku <- renderPlot({
      # Replot after each action
      set()
      restart()
      solve()
      plotSudoku(solutionMatrix, setMatrix, sudokuMatrix)     
})#renderPlot 