library(RUnit)

mapper <- function(list1, list2)
{
   stopifnot(length(list1) == length(list2))
   mapply(function(e1, e2){sprintf("%s: %d", e2, e1)}, list1, list2)

}


test.mapper <- function()
{
  list1 <- 1:3
  list2 <- LETTERS[1:3]
      # should.be.good
  x <-  mapper(list1, list2)
  checkEquals(length(x), 3)
  checkEquals(x, c("A: 1", "B: 2", "C: 3"))
      # should.fail
  checkException(mapper(list1, list2[1:5]))

}
