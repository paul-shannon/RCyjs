## ----setup, include = FALSE-------------------------------------------------------------------------------------------
options(width=120)
knitr::opts_chunk$set(
   collapse = TRUE,
   eval=interactive(),
   echo=TRUE,
   comment = "#>"
)

## ----loadLibrary, results='hide', echo=FALSE--------------------------------------------------------------------------
#  library(RCyjs)

## ----createGraph, results='hide'--------------------------------------------------------------------------------------
#  nodes <- c("A", "T")
#  g <- graphNEL(nodes, edgemode="directed")
#  g <- graph::addEdge("A", "T", g)

## ----defaultAttributes, results='hide'--------------------------------------------------------------------------------
#  nodeDataDefaults(g, attr="label") <- "undefined"
#  nodeDataDefaults(g, attr="type") <- "undefined"
#  nodeDataDefaults(g, attr="flux") <- 0
#  edgeDataDefaults(g, attr="edgeType") <- "undefined"

## ----assignAttributes, results='hide'---------------------------------------------------------------------------------
#  nodeData(g, nodes, attr="label") <- c("Activator", "Target")
#  nodeData(g, nodes, attr="type") <- c("ligand", "receptor")
#  edgeData(g, "A", "T", attr="edgeType") <- "binds"

## ----displayGraph, results='hide'-------------------------------------------------------------------------------------
#  rcy <- RCyjs(title="RCyjs vignette")
#  setGraph(rcy, g)
#  layout(rcy, "grid")
#  fit(rcy, padding=200)
#  setDefaultStyle(rcy)

## ----builtinShapes----------------------------------------------------------------------------------------------------
#  getSupportedNodeShapes(rcy)
#  getSupportedEdgeDecoratorShapes(rcy)

## ----changeSomeDefaults, results='hide'-------------------------------------------------------------------------------
#  setDefaultNodeShape(rcy, "roundrectangle")
#  setDefaultNodeSize(rcy, 50)
#  setDefaultNodeColor(rcy, "lightgreen")
#  setDefaultNodeFontSize(rcy, 8)
#  setDefaultNodeFontColor(rcy, "darkgreen")
#  setDefaultEdgeLineStyle(rcy, "dotted")
#  setDefaultEdgeWidth(rcy, 1)
#  setDefaultEdgeLineColor(rcy, "black")
#  setDefaultNodeBorderWidth(rcy, 2)
#  setDefaultNodeBorderColor(rcy, "white")
#  setBackgroundColor(rcy, "#F0F0F0")
#  setDefaultEdgeTargetArrowShape(rcy, "arrow")
#  redraw(rcy)

## ----specificNodeVisualAssignements, results='hide'-------------------------------------------------------------------
#  setNodeColor(rcy, "A", "lightblue")
#  setNodeSize(rcy, "T", 80)
#  setNodeShape(rcy, "A", "hexagon")
#  setNodeBorderWidth(rcy, "A", 3)
#  redraw(rcy)

## ----resetStyle, results='hide'---------------------------------------------------------------------------------------
#  setDefaultStyle(rcy)

## ----layouts, results='hide'------------------------------------------------------------------------------------------
#  for(layout.name in getLayoutStrategies(rcy)){
#    layout(rcy, layout.name)
#    Sys.sleep(1)
#  }
#  layout(rcy, "grid")
#  fit(rcy, padding=150)

## ----simpleExample, results='hide'------------------------------------------------------------------------------------
#  library(RCyjs)
#  gDemo <- simpleDemoGraph()
#  noaNames(gDemo)
#  edaNames(gDemo)
#  noa(gDemo, "type")
#  noa(gDemo, "lfc")
#  eda(gDemo, "edgeType")
#  eda(gDemo, "score")

## ----twoNodeExample, results="hide", echo=FALSE-----------------------------------------------------------------------
#  loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "vignetteStyle.js"))
#  redraw(rcy)
#  layout(rcy, "grid")
#  tbl.pos <- getPosition(rcy)
#  for(i in 1:10){
#     new.activator.flux <- i * 100
#     if(new.activator.flux > 1000)
#        new.activator.flux <- 1000
#     new.target.flux <- (i-3) * 100
#     setNodeAttributes(rcy, "flux", c("A", "T"), c(new.activator.flux, new.target.flux))
#     tbl.pos$x[1] <- tbl.pos$x[1] + 5
#     tbl.pos$x[2] <- tbl.pos$x[2] - 5
#     tbl.pos$y <- jitter(tbl.pos$y, amount=2)
#     setPosition(rcy, tbl.pos)
#     redraw(rcy)
#     Sys.sleep(0.3)
#     }
#  
#  

## ----sessionInfo------------------------------------------------------------------------------------------------------
#  sessionInfo()

