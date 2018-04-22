library(RCyjs)
rcy <- RCyjs(title="RTK demo")

nodes <- c("A", "T")
g <- graphNEL(nodes, edgemode="directed")
nodeDataDefaults(g, attr="type") <- "undefined"
nodeDataDefaults(g, attr="flux") <- 0

nodeData(g, nodes, "type") <- c("activator", "target")

g <- graph::addEdge("A", "T", g)

setGraph(rcy, g)
layout(rcy, "grid")
fit(rcy, padding=100)
setDefaultStyle(rcy)

# tune up the position interactively
# save and restore that layout opaquely - don't bother looking at the numbers
# randomize the layout as part of the test, before restoring

saveLayout(rcy, filename="layout.RData")
layout(rcy, "random")
restoreLayout(rcy, filename="layout.RData")
fit(rcy, padding=100)

# alternatively, get and set node positions, modify them programmatically
tbl.pos <- getPosition(rcy)
tbl.pos$y <- tbl.pos$y + 20
setPosition(rcy, tbl.pos)


# set the node shape, the same one for all nodes
setDefaultNodeShape(rcy, "vee")
redraw(rcy)

# give a different node shape to each node
setNodeShape(rcy, nodes, c("diamond", "roundrectangle"))
redraw(rcy)

# as graphs get more complicated it soons becomes worthwhile
# to specify visualization rules.  these map data attributes
# to visual attribuetes.   they are expressed in a style
# inspired by CSS.  here are the rules we will use next

loadStyleFile(rcy, "../extdata/vignetteStyle.js")
redraw(rcy)

tbl.pos <- getPosition(rcy)
for(i in 1:10){
   new.activator.flux <- i * 100
   if(new.activator.flux > 1000)
      new.activator.flux <- 1000
   new.target.flux <- (i-3) * 100
   setNodeAttributes(rcy, "flux", c("A", "T"), c(new.activator.flux, new.target.flux))
   tbl.pos$x[1] <- tbl.pos$x[1] + 5
   tbl.pos$x[2] <- tbl.pos$x[2] - 5
   tbl.pos$y <- jitter(tbl.pos$y, amount=2)
   setPosition(rcy, tbl.pos)
   redraw(rcy)
   Sys.sleep(0.3)
   }


# find shortest paths
set.seed(17)
g <- createTestGraph(nodeCount=40, edgeCount=40)
setGraph(rcy, g)
setDefaultStyle(rcy)
layout(rcy, "cola")


x <- sp.between(g=g, start="n7", finish="n13")
selectNodes(rcy, x[[1]]$path_detail)

