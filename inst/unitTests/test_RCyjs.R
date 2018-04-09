library (RCyjs)
library (RUnit)
#----------------------------------------------------------------------------------------------------
if(!exists("rcy")){
   title <- "rcy test"
   rcy <- RCyjs(title=title)
   checkTrue(ready(rcy))
   checkEquals(getBrowserWindowTitle(rcy), title)
   checkEquals(length(getNodes(rcy)), 0);
   }

colors <- list(green="rgb(0,255,0)",
               white="rgb(255,255,255)",
               red="rgb(255,0,0)",
               blue="rgb(0,0,255)",
               black="rgb(0,0,0)",
               darkGreen="rgb(0,200,0)",
               darkerGreen="rgb(0,120,0)",
               darkRed="rgb(221,0,0)",
               darkerRed="rgb(170,0,0)",
               purple="rgb(221,221,0)",
               darkBlue="rgb(0,0,170)",
               darkerBlue="rgb(0,0,136)",
               lightGray="rgb(230,230,230)")

shapes = c("ellipse", "triangle", "pentagon", "hexagon", "heptagon", "octagon", "star",
           "rectangle", "roundrectangle")


PORTS=9047:9097
#----------------------------------------------------------------------------------------------------
runTests = function()
{
   test.setGraph();
   test.deleteSetAddGraph()
   test.largeGraph()

   test.loadStyleFile();
   test.getJSON()
   test.addGraphFromFile()

   test.constructorWithGraphSupplied()


#   test.constructorWithGraph();
#   test.setBackgroundColor();
#
#   test.setNodeDefaults()
#   test.setEdgeDefaults()
#
#   test.setNodeLabelRule()
#   test.setNodeLabelAlignment()
#   test.setNodeSizeRule()
#   test.setNodeColorRule()
#   test.setNodeShapeRule()
#
#   test.setEdgeColorRule()
#   test.setEdgeWidthRule()
#
#   test.setEdgeArrowLookupRules()  # both color and shape, source and target
#
#   test.nodeSelection()
#
#   test.layoutStrategies()
#   test.layouts()
#
#   test.getSetPosition()
#   test.getNodeSize()
#   test.saveRestoreLayout()
#
#   test.getJSON()
#
#   test.zoom()
#
#   test.setNodeAttributes();
#   test.setEdgeAttributes();
#
#   test.compoundNodes();
#   test.setNodeImage();
#
#   test.httpAddGraphToExistingGraph()
#   test.httpAddGraphToEmptyGraph()
#   test.httpAddCompoundEdgeToExistingGraph()
#   test.httpAddJsonGraphFromFile()
#   test.savePNG()

} # run.tests
#----------------------------------------------------------------------------------------------------
# a utility: create and return simple instance, for further experimentation
rcy.demo <- function(portRange=PORTS)
{
   g <- simpleDemoGraph()

   checkTrue(ready(rcy))
   setGraph(rcy, g)
   setBrowserWindowTitle(rcy, "rcy.demo")
   checkEquals(getBrowserWindowTitle(rcy), "rcy.demo")

   tbl.nodes <- getNodes(rcy)
   checkEquals(nrow(tbl.nodes), 3)
   checkEquals(tbl.nodes$id, c("A", "B", "C"))

   setNodeLabelRule(rcy, "label");
   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy, "count", c(0, 100), c(colors$green, colors$red), mode="interpolate")
   redraw(rcy)
   layout(rcy, "cose")
   fit(rcy, 300)

   rcy

} # rcy.demo
#----------------------------------------------------------------------------------------------------
test.setGraph <- function()
{
   printf("--- test.setGraph")

   checkTrue(ready(rcy))

   title <- "setGraph"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   setNodeLabelRule(rcy, "label");
   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy, "count", c(0, 100), c(colors$green, colors$red), mode="interpolate")
   redraw(rcy)
   layout(rcy, "cola")
   fit(rcy, 100)

   tbl.nodes <- getNodes(rcy)
   checkEquals(nrow(tbl.nodes), 3)
   checkEquals(tbl.nodes$id, c("A", "B", "C"))
   Sys.sleep(1)

} # test.setGraph
#----------------------------------------------------------------------------------------------------
test.setGraphEdgesInitiallyHidden <- function()
{
   printf("--- test.setGraphEdgesInitiallyHidden")

   checkTrue(ready(rcy))

   title <- "setGraphEdgesInitiallyHidden"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   g <- simpleDemoGraph()
   setGraph(rcy, g, hideEdges=TRUE)
   setNodeLabelRule(rcy, "label");
   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy, "count", c(0, 100), c(colors$green, colors$red), mode="interpolate")
   redraw(rcy)
   layout(rcy, "cola")
   fit(rcy, 100)

   tbl.nodes <- getNodes(rcy)
   checkEquals(nrow(tbl.nodes), 3)
   checkEquals(tbl.nodes$id, c("A", "B", "C"))
   Sys.sleep(1)

} # test.setGraphEdgesInitiallyHidden
#----------------------------------------------------------------------------------------------------
test.deleteSetAddGraph <- function()
{
   printf("--- test.deleteSetAddGraph")

   checkTrue(ready(rcy))

   title <- "deleteSedAddGraph"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   deleteGraph(rcy)

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   setNodeLabelRule(rcy, "label");
   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy, "count", c(0, 100), c(colors$green, colors$red), mode="interpolate")
   redraw(rcy)
   layout(rcy, "cola")
   fit(rcy, 200)

   g2 <- createTestGraph(nodeCount=10, edgeCount=4)
   addGraph(rcy, g2)
   layout(rcy, "cola")

   g3 <- createTestGraph(10, 10)
   addGraph(rcy, g3)
   layout(rcy, "cola")

   g4 <- createTestGraph(30, 20)
   addGraph(rcy, g4)
   layout(rcy, "cola")

   tbl.nodes <- getNodes(rcy)
   checkEquals(nrow(tbl.nodes), 33)
   Sys.sleep(1)

} # test.deleteSetAddGraph
#----------------------------------------------------------------------------------------------------
# to keep tests simple, this file creates an rcy object with an empty graph, at global scope, when
# the file is read (sourced, loaded).  this test, unlike all the others, creates its own new RCyjs
# object, to ensure that we can construct one with a graph, without difficulty or error
test.constructorWithGraphSupplied <- function()
{
   printf("--- test.constructorWithGraphSupplied");

   g <- simpleDemoGraph()

   rcy2 <- RCyjs(graph=g, title="constructorWithGraphSupplied");
   checkTrue(ready(rcy2))
   setNodeLabelRule(rcy2, "label");
   setNodeSizeRule(rcy2, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy2, "count", c(0, 100), c(colors$green, colors$red), mode="interpolate")
   redraw(rcy2)
   layout(rcy2, "cola")
   Sys.sleep(1)
   fit(rcy2, 350)

   title <- "graph ctor"
   setBrowserWindowTitle(rcy2, title)
   checkEquals(getBrowserWindowTitle(rcy2), title)

   tbl.nodes <- getNodes(rcy2)
   checkEquals(nrow(tbl.nodes), 3)
   checkEquals(tbl.nodes$id, c("A", "B", "C"))
   Sys.sleep(1)

   closeWebSocket(rcy2)

} #  test.constructorWithGraphSupplied
#----------------------------------------------------------------------------------------------------
test.largeGraph <- function()
{
   printf("--- test.largeGraph")

   setBrowserWindowTitle(rcy, "largeGraph")
   deleteGraph(rcy)
   g <- createTestGraph(nodeCount=1000, edgeCount=1200)
   addGraph(rcy, g)
   layout(rcy, "grid")
   layout(rcy, "cola")
   Sys.sleep(1)

} # test.largeGraph
#----------------------------------------------------------------------------------------------------
test.loadStyleFile <- function(count=3)
{
   printf("--- test.loadStyleFile")

   setBrowserWindowTitle(rcy, "loadStyleFile")

   setGraph(rcy, simpleDemoGraph())
   layout(rcy, "cola")
   selectNodes(rcy, c("A", "B"))
   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   styleFile.2 <- system.file(package="RCyjs", "extdata", "sampleStyle2.js");

   for(i in 1:3){
      loadStyleFile(rcy, styleFile.1)
      Sys.sleep(1)
      loadStyleFile(rcy, styleFile.2)
      Sys.sleep(1)
      } # for i

} # test.loadStyleFile
#----------------------------------------------------------------------------------------------------
test.getJSON <- function()
{
   printf("--- test.getJSON")

   setBrowserWindowTitle(rcy, "getJSON")
   g <- simpleDemoGraph()
   setGraph(rcy, g)
   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   loadStyleFile(rcy, styleFile.1)
   layout(rcy, "cola")

   json <- getJSON(rcy)
   checkTrue(nchar(json) > 2000)
   x <- fromJSON(json)

   checkEquals(sort(names(x)), sort(c("elements", "style", "zoomingEnabled", "userZoomingEnabled",
                                      "zoom", "minZoom", "maxZoom", "panningEnabled", "userPanningEnabled",
                                      "pan", "boxSelectionEnabled", "renderer")))
   tbl.nodes <- x$elements$nodes$data
   checkEquals(nrow(tbl.nodes), 3)
   checkEquals(tbl.nodes$id, c("A", "B", "C"))

   tbl.edges <- x$elements$edges$data
   checkEquals(nrow(tbl.edges), 3)
   checkEquals(tbl.edges$id, c("A->B", "B->C", "C->A"))

} # test.getJSON
#----------------------------------------------------------------------------------------------------
test.addGraphFromFile <- function()
{
   printf("--- test.addGraphFromFile")
   deleteGraph(rcy)
   g <- createTestGraph(nodeCount=10, edgeCount=30)
   addGraph(rcy, g)
   layout(rcy, "cola")
   tbl.nodes.0 <- getNodes(rcy)
   g <- getJSON(rcy)
   temp.filename <- tempfile(fileext=".json")
   write(g, file=temp.filename)
   deleteGraph(rcy)
   addGraphFromFile(rcy, temp.filename)
   layout(rcy, "cola")
   tbl.nodes.1 <- getNodes(rcy)

   checkEquals(sort(tbl.nodes.0$id), sort(tbl.nodes.1$id))

} # test.addGraphFromFile
#----------------------------------------------------------------------------------------------------
#test.biocGraphToCytoscapeJSON <- function()
#{
#   print("--- test.biocGraphToCytoscapeJSON")
#   g <- simpleDemoGraph()
#   g.json <- biocGraphToCytoscapeJSON(g)
#
#      # check this by converting from JSON back to R, and inspecting the fields
#   g2 <- fromJSON(g.json)
#
#      # two standard sections
#   checkEquals(names(g2), c("data", "elements"))
#
#      # data is for overall graph attributes: selection, name, ...
#      # we have none here
#   checkEquals(length(g2$data), 0)
#
#     # elements are nodes and edges
#   checkEquals(names(g2$elements), c("nodes", "edges"))
#
#     # the attributes for each node
#   tbl.nodes <- g2$elements$nodes$data;
#   checkEquals(colnames(tbl.nodes), c("name", "type", "lfc", "label", "count", "id"))
#   checkEquals(tbl.nodes$name,  c("A", "B", "C"))
#   checkEquals(tbl.nodes$type,  c("kinase", "transcription factor", "glycoprotein"))
#   checkEquals(tbl.nodes$count, c(2, 30, 100))
#
#     # now the edges
#   tbl.edges <- g2$elements$edges$data
#   checkEquals(sort(names(tbl.edges)), c("edgeType", "misc", "score", "source", "target"))
#
#     # check the network structure
#   checkEquals(tbl.edges$source, c("A", "B", "C"))
#   checkEquals(tbl.edges$target, c("B", "C", "A"))
#
#   checkEquals(tbl.edges$score,  c(35, -12, 0))
#   checkEquals(tbl.edges$edgeType,  c("phosphorylates", "synthetic lethal", "undefined"))
#
#} # test.biocGraphToCytoscapeJSON
##----------------------------------------------------------------------------------------------------
#test.biocGraphToCytoscapeJSON.RJSONIO.version <- function()
#{
#   print("--- test.biocGraphToCytoscapeJSON.RJSONIO.version")
#   g <- simpleDemoGraph()
#   g.json <- biocGraphToCytoscapeJSON(g)
#
#      # check this by converting from JSON back to R, and inspecting the fields
#   g2 <- fromJSON(g.json)
#
#      # two standard sections
#   checkEquals(names(g2), c("data", "elements"))
#
#      # data is for overall graph attributes: selection, name, ...
#      # we have none here
#   checkEquals(length(g2$data), 0)
#
#     # elements are nodes and edges
#   checkEquals(names(g2$elements), c("nodes", "edges"))
#
#     # the attributes for each node
#   checkEquals(sort(names(g2$elements$nodes[[1]]$data)), c("count", "id", "label", "lfc", "name", "type"))
#
#     # check a few of them
#   checkEquals(unlist(lapply(g2$elements$nodes, function(node) return(node$data$name))),
#               c("A", "B", "C"))
#   checkEquals(unlist(lapply(g2$elements$nodes, function(node) return(node$data$id))),
#               c("A", "B", "C"))
#   checkEquals(unlist(lapply(g2$elements$nodes, function(node) return(node$data$type))),
#               c("kinase", "transcription factor", "glycoprotein"))
#
#     # now the edges
#   checkEquals(sort(names(g2$elements$edges[[1]]$data)), c("edgeType", "misc", "score", "source", "target"))
#
#     # check the network structure
#   checkEquals(unlist(lapply(g2$elements$edges, function(edge) return(edge$data$source))), c("A","B","C"))
#   checkEquals(unlist(lapply(g2$elements$edges, function(edge) return(edge$data$target))), c("B","C","A"))
#   checkEquals(unlist(lapply(g2$elements$edges, function(edge) return(edge$data$edgeType))),
#               c("phosphorylates", "synthetic lethal", "undefined"))
#
#} # test.biocGraphToCytoscapeJSON.RJSONIO.version
#----------------------------------------------------------------------------------------------------
test.setNodeLabelRule <- function()
{
   printf("--- test.setNodeLabelRule")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))

   title <- "setNodeLabelRule"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   all.attributes <- names(nodeData(g)[[1]])
   for(attribute in all.attributes){
     setNodeLabelRule(rcy, attribute);
     redraw(rcy)
     Sys.sleep(0.5)
     }

   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   closeWebSocket(rcy)

} # test.setNodeLabelRule
#----------------------------------------------------------------------------------------------------
test.setNodeLabelAlignment <- function()
{
   printf("--- test.setNodeLabelRule")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");
   title <- "setNodeSizeRule"
   setBrowserWindowTitle(rcy, title)

   setDefaultNodeSize(rcy, 60)
   setDefaultNodeColor(rcy, "white")
   setDefaultNodeBorderColor(rcy, "black")
   setDefaultNodeBorderWidth(rcy, 1)
   redraw(rcy)

   hValues <- c("left", "center", "right")
   vValues <- c("top",  "center", "bottom")

   for(hValue in hValues)
      for(vValue in vValues){
         setNodeLabelAlignment(rcy, hValue, vValue);
         redraw(rcy)
         }

   setNodeLabelAlignment(rcy, "center", "center")
   redraw(rcy)

   sizes <- seq(0, 32, 2)

   for(size in sizes){
      setDefaultNodeFontSize(rcy, size)
      redraw(rcy)
      } # for size

   for(size in rev(sizes)){
      setDefaultNodeFontSize(rcy, size)
      redraw(rcy)
      } # for size

   setDefaultNodeFontSize(rcy, 16)
   redraw(rcy)

   closeWebSocket(rcy)

} # test.setNodeLabelAlignment
#----------------------------------------------------------------------------------------------------
test.setNodeSizeRule <- function()
{
   printf("--- test.setNodeLabelRule")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");

   title <- "setNodeSizeRule"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

     # the count attribute:  A:2, B: 30, C: 100
   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(50, 200, 500));
   redraw(rcy)
   closeWebSocket(rcy)

} # test.setNodeSizeRule
#----------------------------------------------------------------------------------------------------
test.setNodeColorRule <- function()
{
   printf("--- test.setNodeLabelRule")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");

   title <- "setNodeColorRule"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

     # the count attribute:  A:2, B: 30, C: 100
   setNodeColorRule(rcy, "lfc", c(-3, 0, 3), c(colors$green, colors$white, colors$red), mode="interpolate")
   redraw(rcy)

   setNodeColorRule(rcy, "type",
                    c("kinase", "transcription factor", "glycoprotein"),
                    c(colors$blue, colors$red, colors$green), mode="lookup")
   redraw(rcy)
   Sys.sleep(1)

   setNodeColorRule(rcy, "count", c(-10, 100), c(colors$white, colors$green), mode="interpolate")
   redraw(rcy)

   Sys.sleep(1)

   closeWebSocket(rcy)

} # test.setNodeColorRule
#----------------------------------------------------------------------------------------------------
test.setNodeShapeRule <- function()
{
   printf("--- test.setNodeLabelRule")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "type");

   title <- "setNodeShapeRule"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

      # shapes are discrete entities, unlike color or size, which are continuous
      # so no mode parameter (lookup or interpolate) is needed
   setNodeShapeRule(rcy, "type",
                    c("kinase", "transcription factor", "glycoprotein"),
                    c("triangle", "roundrectangle", "star"))

   redraw(rcy)

   closeWebSocket(rcy)

} # test.setNodeShapeRule
#----------------------------------------------------------------------------------------------------
test.nodeSelection <- function()
{
   printf("--- test.nodeSelection")
   rcy <- rcy.demo()

   checkEquals(length(getSelectedNodes(rcy)), 0)

   tbl.nodes <- getNodes(rcy)
   checkEquals(tbl.nodes$name, c("A", "B", "C"))

   selectNodes(rcy, "B")
   checkEquals(nrow(getSelectedNodes(rcy)), 1)
   clearSelection(rcy)
   checkEquals(length(getSelectedNodes(rcy)), 0)

   closeWebSocket(rcy)

} # test.nodeSelection
#----------------------------------------------------------------------------------------------------
test.layoutStrategies <- function()
{
   printf("--- test.layoutStrategies")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   title <- "layoutStrategies"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)
   layout.strategies <- layoutStrategies(rcy)
   builtin.strategies <- c("breadthfirst", "circle", "concentric", "cose", "grid", "random")
   extension.strategies <- c("cola", "dagre", "cose-bilkent")
   checkTrue(all(builtin.strategies %in% layout.strategies))
   checkTrue(all(extension.strategies %in% layout.strategies))

   closeWebSocket(rcy)

} # test.layoutStrategies
#----------------------------------------------------------------------------------------------------
test.layouts <- function()
{
   printf("--- test.layouts")

   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   title <- "layouts"
   setBrowserWindowTitle(rcy, title)
   layout.strategies <- layoutStrategies(rcy)
   for(strategy in layout.strategies){
     layout(rcy, strategy)
     Sys.sleep(0.5)
     } # for strategy

   closeWebSocket(rcy)

} #  test.layouts
#----------------------------------------------------------------------------------------------------
# there is some non-deterministic behavior here, the exploration of which is deferred.
# numbers don't have quite the values arithmetic suggests.  sometimes the final zoom is larger than
# the initial zoom.
# this works predictably & reliably at the R command prompt, but
test.zoom <- function()
{
   printf("--- test.zoom")
   rcy <- rcy.demo()

   initial.zoom = getZoom(rcy);
   loops = 8

   for(i in 1:loops){
      setZoom(rcy, 0.5 * getZoom(rcy))
      #redraw(rcy)
      #printf("new zoom: %f", getZoom(rcy))
      } # for i


    for(i in 1:(loops)){
      setZoom(rcy, 2.0 * getZoom(rcy))
      #redraw(rcy)
      #printf("new zoom: %f", getZoom(rcy))
      #Sys.sleep(0.1)
      } # for i

    closeWebSocket(rcy)

} # test.zoom
#----------------------------------------------------------------------------------------------------
test.bigGraph <- function()
{
   printf("--- test.bigGraph");

    # 1000 nodes, 0 edges:     2 seconds
    # 1000 nodes, 1000 edges: 15 seconds
    # 1000 nodes, 2000 edges: 45 seconds

   nodeCount = 1000
   edgeCount = 1000

   g <- createTestGraph(nodeCount=nodeCount, edgeCount=edgeCount)
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   title <- "bigGraph"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   tbl.nodes <- getNodes(rcy)
   checkEquals(nrow(tbl.nodes), nodeCount)

   #layout(rcy, "grid")
   #layout(rcy, "cose")
   closeWebSocket(rcy)

} #  test.bigGraph
#----------------------------------------------------------------------------------------------------
test.setEdgeColorRule <- function()
{
   printf("--- test.setEdgeColorRule");

   g <- simpleDemoGraph()
   checkEquals(sort(edaNames(g)), c("edgeType", "misc", "score"))
   checkEquals(eda(g, "edgeType"), c("A|B"="phosphorylates",
                                     "B|C"="synthetic lethal",
                                     "C|A"="undefined"))

   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");
   redraw(rcy)
   title <- "setEdgeColorRule"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

     # invoke lookup (direct assignment) rule on edgeType
   setEdgeColorRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c(colors$red, colors$green, colors$blue), mode="lookup")
   redraw(rcy)

   Sys.sleep(1)

    # A|B   35
    # B|C  -12
    # C|A    0

      # now do interpoloate.  there should be one very faint red line, one faint one
      # and one which is quite strong.

   setEdgeColorRule(rcy, "score", c(-15, 50), c(colors$white, colors$red), mode="interpolate")
   redraw(rcy)

   Sys.sleep(1)

   closeWebSocket(rcy)

} # test.setEdgeColorRule
#----------------------------------------------------------------------------------------------------
test.setEdgeWidthRule <- function()
{
   printf("--- test.setEdgeWidthRule")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "setEdgeWidthRule");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

      # first the lookup width rule, based on discrete variable edgeType
   setEdgeWidthRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c(2, 5, 10), mode="lookup")

    redraw(rcy)

      # now the interpolate rule,  based on continuou variable edgeType

   setEdgeWidthRule(rcy, "score", c(-15, 50), c(2, 10), mode="interpolate")
   redraw(rcy)
   closeWebSocket(rcy)

} # test.setEdgeWidthRule
#----------------------------------------------------------------------------------------------------
test.setEdgeArrowLookupRules <- function()
{
   printf("--- test.setEdgeArrowLookupRules")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "setEdgeTargetArrowhRule");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   setEdgeColorRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c(colors$red, colors$green, colors$blue), mode="lookup")
   redraw(rcy)

   setEdgeTargetArrowShapeRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c("tee", "triangle", "none"))
   redraw(rcy)

   setEdgeTargetArrowColorRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c("black", "red", "green"),
                    mode="lookup")

   setEdgeSourceArrowShapeRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c("tee", "triangle", "none"))
   redraw(rcy)

   setEdgeSourceArrowColorRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c("red", "black", "green"),
                    mode="lookup")
   redraw(rcy)
   closeWebSocket(rcy)

} # test.setEdgeArrowLookupRules
#----------------------------------------------------------------------------------------------------
test.setEdgeTargetArrowColorRule <- function()
{
   printf("--- test.setEdgeTargetArrowColorRule")
   g <- simpleDemoGraph()
   checkEquals(sort(edaNames(g)), c("edgeType", "misc", "score"))
   checkEquals(eda(g, "edgeType"), c("A|B"="phosphorylates",
                                     "B|C"="synthetic lethal",
                                     "C|A"="undefined"))

   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");
   redraw(rcy)
   title <- "setEdgeTargetArrowColorRule"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

     # invoke lookup (direct assignment) rule on edgeType
   setEdgeTargetArrowColorRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c(colors$red, colors$green, colors$blue), mode="lookup")
   redraw(rcy)

   Sys.sleep(1)

    # A|B   35
    # B|C  -12
    # C|A    0

      # now do interpoloate.  there should be one very faint red line, one faint one
      # and one which is quite strong.

   setEdgeTargetArrowColorRule(rcy, "score", c(-15, 50), c(colors$white, colors$red), mode="interpolate")
   redraw(rcy)

   Sys.sleep(1)

   closeWebSocket(rcy)

} # test.setEdgeTargetArrowColorRule
#----------------------------------------------------------------------------------------------------
test.setEdgeSourceArrowShapeRule <- function()
{
   printf("--- test.setEdgeSourceArrowShapeRule")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "setEdgeSourceArrowhRule");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   setEdgeSourceArrowShapeRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c("none", "tee", "triangle"))

   closeWebSocket(rcy)

} # test.setEdgeSourceArrowShapeRule
#----------------------------------------------------------------------------------------------------
test.setEdgeSourceArrowColorRule <- function()
{
   printf("--- test.setEdgeSourceArrowColorRule")
   g <- simpleDemoGraph()
   checkEquals(sort(edaNames(g)), c("edgeType", "misc", "score"))
   checkEquals(eda(g, "edgeType"), c("A|B"="phosphorylates",
                                     "B|C"="synthetic lethal",
                                     "C|A"="undefined"))

   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");
   redraw(rcy)
   title <- "setEdgeSourceArrowColorRule"
   setBrowserWindowTitle(rcy, title)

     # invoke lookup (direct assignment) rule on edgeType
   setEdgeSourceArrowColorRule(rcy, "edgeType",
                    c("phosphorylates", "synthetic lethal", "undefined"),
                    c(colors$red, colors$green, colors$blue), mode="lookup")
   redraw(rcy)

   Sys.sleep(1)

    # A|B   35
    # B|C  -12
    # C|A    0

      # now do interpoloate.  there should be one very faint red line, one faint one
      # and one which is quite strong.

   setEdgeSourceArrowColorRule(rcy, "score", c(-15, 50), c(colors$white, colors$red), mode="interpolate")
   redraw(rcy)

   Sys.sleep(1)

   closeWebSocket(rcy)

} # test.setEdgeSourceArrowColorRule
#----------------------------------------------------------------------------------------------------
test.getSetPosition <- function()
{
   printf("--- test.getSetPosition");

   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "getSetPosition");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   tbl <- getPosition(rcy, "A")
   checkEquals(nrow(tbl), 1)
   checkEquals(colnames(tbl), c("id", "x", "y"))
   checkEquals(tbl[1, "id"], "A")

      # now get positions of all
   tbl <- getPosition(rcy)
   checkEquals(nrow(tbl), 3)
   checkEquals(colnames(tbl), c("id", "x", "y"))
   checkEquals(tbl$id, nodes(g))
   checkTrue(all(is.integer(tbl$x)))
   checkTrue(all(is.integer(tbl$y)))

   tbl2 <- tbl
   tbl2[, 2:3] <- tbl2[, 2:3] + 50

   for(i in 1:2){
      setPosition(rcy, tbl2)
      Sys.sleep(0.5)
      setPosition(rcy, tbl)
      Sys.sleep(0.5)
      } # for i

   for(i in 1:2){
      setPosition(rcy, tbl2[1,])
      Sys.sleep(0.5)
      setPosition(rcy, tbl[1,])
      Sys.sleep(0.5)
      } # for i

   closeWebSocket(rcy)

} # test.getSetPosition
#----------------------------------------------------------------------------------------------------
test.getNodeSize <- function()
{
   printf("--- test.getNodeSize");

   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "getNodeSize");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)
   tbl.size <- getNodeSize(rcy)
   checkEquals(dim(tbl.size), c(3, 3))
   checkEquals(colnames(tbl.size), c("id", "width", "height"))
   checkEquals(tbl.size$id, c("A", "B", "C"))
     # all dimeneions are 30px
   checkEquals(unique(as.character(as.matrix(tbl.size[, c("width", "height")]))), "30px")

   tbl.sizeA <- getNodeSize(rcy, "A")
   checkEquals(dim(tbl.sizeA), c(1,3))
   checkEquals(as.list(tbl.sizeA[1,]), list(id="A", width="30px", height="30px"))

} # test.getNodeSize
#----------------------------------------------------------------------------------------------------
test.saveRestoreLayout <- function()
{
   if(!interactive())
       return(TRUE);

   printf("--- test.saveRestoreLayout");

   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "restoreLayout");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   tbl.layout <- getPosition(rcy)

   layoutFilename <- "testLayout.RData";
   if(file.exists(layoutFilename))
      unlink(layoutFilename)

   saveLayout(rcy, layoutFilename)
   checkTrue(file.exists(layoutFilename))

   layout(rcy, "cose")
   Sys.sleep(0.4)
   restoreLayout(rcy, layoutFilename)
   fitContent(rcy)
   setZoom(rcy, 0.9 * getZoom(rcy))

   tbl.layout2 <- getPosition(rcy)
   checkEquals(tbl.layout, tbl.layout2)

   closeWebSocket(rcy)

} # test.saveRestoreLayout
#----------------------------------------------------------------------------------------------------
test.setBackgroundColor <- function()
{
   printf("--- test.setBackgroundColor");
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "setBackgroundColor");
   setNodeLabelRule(rcy, "label");

   redraw(rcy)
   for(color in colors){
     setBackgroundColor(rcy, color)
     redraw(rcy)
     } # for color

   closeWebSocket(rcy)

} # test.setBackgroundColor
#----------------------------------------------------------------------------------------------------
test.setNodeDefaults <- function()
{
   printf("--- test.setNodeDefaults");

   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "getSetPosition");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   setDefaultNodeSize(rcy, 200); redraw(rcy);
   setDefaultNodeWidth(rcy, 40); redraw(rcy);
   setDefaultNodeHeight(rcy, 10); redraw(rcy);
   setDefaultNodeColor(rcy, "rgb(80,120,221)"); redraw(rcy);


   setDefaultNodeSize(rcy, 80); redraw(rcy);
   for(shape in shapes){
      setDefaultNodeShape(rcy, shape);
      redraw(rcy);
      }
   setDefaultNodeFontColor(rcy, "red"); redraw(rcy);
   setDefaultNodeFontSize(rcy, 32); redraw(rcy);
   setDefaultNodeBorderColor(rcy, "red"); redraw(rcy)
   setDefaultNodeBorderColor(rcy, "black"); redraw(rcy)
   setDefaultNodeBorderWidth(rcy, 10); redraw(rcy)
   setDefaultNodeBorderWidth(rcy, 5); redraw(rcy)
   setDefaultNodeBorderWidth(rcy, 3); redraw(rcy)
   setDefaultNodeBorderWidth(rcy, 1); redraw(rcy)
   setDefaultNodeBorderWidth(rcy, 5); redraw(rcy)
   setDefaultNodeBorderWidth(rcy, 10); redraw(rcy)

   closeWebSocket(rcy)

} # test.setNodeDefaults
#----------------------------------------------------------------------------------------------------
test.setEdgeDefaults <- function()
{
   printf("--- test.setEdgeDefaults")
   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   checkTrue(ready(rcy))
   setBrowserWindowTitle(rcy, "setEdgeDefaults");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

   setDefaultEdgeFontSize(rcy, 20); redraw(rcy);
   setDefaultEdgeTargetArrowShape(rcy, "triangle"); redraw(rcy);
   setDefaultEdgeTargetArrowShape(rcy, "none"); redraw(rcy);
   setDefaultEdgeTargetArrowShape(rcy, "tee"); redraw(rcy);
   setDefaultEdgeTargetArrowShape(rcy, "triangle"); redraw(rcy);

   setDefaultEdgeColor(rcy, colors$red); redraw(rcy);
   setDefaultEdgeTargetArrowColor(rcy, colors$blue); redraw(rcy);
   setDefaultEdgeWidth(rcy, 5); redraw(rcy);
   setDefaultEdgeLineColor(rcy, colors$green); redraw(rcy);
   setDefaultEdgeFont(rcy, "SansSerif"); redraw(rcy);
   setDefaultEdgeFontWeight(rcy, 1.0); redraw(rcy);
   setDefaultEdgeTextOpacity(rcy, 1.0); redraw(rcy);

   setDefaultEdgeLineStyle(rcy, "solid"); redraw(rcy);
   setDefaultEdgeLineStyle(rcy, "dotted"); redraw(rcy);
   setDefaultEdgeLineStyle(rcy, "dashed"); redraw(rcy);

   setDefaultEdgeOpacity(rcy, 1.0); redraw(rcy);
   setDefaultEdgeOpacity(rcy, 0.4); redraw(rcy);
   setDefaultEdgeOpacity(rcy, 0.0); redraw(rcy);
   setDefaultEdgeOpacity(rcy, 1.0); redraw(rcy);

   setDefaultEdgeSourceArrowColor(rcy, colors$purple); redraw(rcy);
   setDefaultEdgeSourceArrowShape(rcy, "tee"); redraw(rcy);

   closeWebSocket(rcy)

} # test.setEdgeDefaults
#----------------------------------------------------------------------------------------------------
test.setNodeAttributes <- function()
{
  rcy <- rcy.demo()
     # originally lfc is c(-3, 0, 3)
  setNodeAttributes(rcy, "lfc", c("A", "B", "C"), c(0, 0, 0))

} # test.setNodeAttributes
#----------------------------------------------------------------------------------------------------
test.setEdgeAttributes <- function()
{

} # test.setEdgeAttributes
#----------------------------------------------------------------------------------------------------
test.compoundNodes <- function()
{
   printf("--- test.compoundNodes")

   nodes <- c("parent", "kid.1", "kid.2");

   g = graphNEL(nodes, edgemode="directed");
   nodeDataDefaults(g, attr = "label") <- "default node label"
   nodeDataDefaults(g, attr = "parent") <- "";
   edgeDataDefaults(g, attr = "edgeType") <- "undefined"

   nodeData(g, nodes, "label") = nodes
   nodeData(g, c("kid.1", "kid.2"), "parent") <- rep("parent", 2);
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   setNodeLabelRule(rcy, "label"); redraw(rcy)
   setNodeLabelAlignment(rcy, "center", "center")
   redraw(rcy)

} # test.compoundNodes
#----------------------------------------------------------------------------------------------------
test.setNodeImage <- function()
{
   printf("--- test.setNodeImage")
   rcy <- rcy.demo()
   images <- list(A="http://farm1.staticflickr.com/231/524893064_f49a4d1d10_z.jpg",
                  B="http://farm9.staticflickr.com/8316/8003798443_32d01257c8_b.jpg",
                  C="http://localhost:5000/8003798443_32d01257c8_b.jpg")

   setNodeImage(rcy, images)

   images <- list(A="https://farm1.staticflickr.com/231/524893064_f49a4d1d10_z.jpg",
                  B="http://localhost:5000/HellsCanyonJune2015.jpg",
                  charlie="https://farm9.staticflickr.com/8316/8003798443_32d01257c8_b.jpg")
   setNodeImage(rcy, images)

} # test.setNodeImage
#----------------------------------------------------------------------------------------------------
demo.hypoxia <- function()
{
   require(org.Hs.eg.db)

   if(!exists("refnet")){
     library(RefNet)
     refnet <<- RefNet();
     tbl.hypoxia <<- interactions(refnet,provider="hypoxiaSignaling-2006")
     }

   g.hypoxia <- refnetToGraphNEL(tbl.hypoxia)
   all.nodes <- nodes(g.hypoxia)
   gene.nodes <- intersect(all.nodes, keys(org.Hs.egSYMBOL2EG))
   process.nodes <- setdiff(all.nodes, gene.nodes)
   nodeData(g.hypoxia, gene.nodes, attr="type") <- "gene"
   nodeData(g.hypoxia, process.nodes, attr="type") <- "process"

   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g.hypoxia);
   setBackgroundColor(rcy, colors$lightGray)
   setDefaultNodeSize(rcy, 60)
   setDefaultNodeColor(rcy, "white")
   setDefaultNodeBorderColor(rcy, "black")
   setDefaultNodeBorderWidth(rcy, 3)
   checkTrue(ready(rcy))
   setNodeLabelRule(rcy, "label");
   setNodeShapeRule(rcy, "type", c("gene", "process"), c("ellipse", "roundrectangle"))
   redraw(rcy)
   title <- "Hypoxia Signaling: Pouyssegur 2006"
   setBrowserWindowTitle(rcy, title)
   saved.layout.file <- system.file(package="RCyjs", "extdata", "hypoxiaLayout.RData")
   restoreLayout(rcy, saved.layout.file)
   fitContent(rcy)
   setZoom(rcy, 0.9 * getZoom(rcy))


   edgeColors <- list(activates = colors$darkerGreen,
                      inhibits = colors$darkRed,
                      inactivates = colors$darkRed,
                      hydroxylates = colors$black,
                      "TF cofactor" = colors$darkBlue,
                      "TF binding" = colors$darkBlue,
                      hydroxylated = colors$black,
                      stabilizes.mrna = colors$darkerBlue,
                      preserves = colors$darkGreen,
                      proteolyzes = colors$darkRed)

   setEdgeColorRule(rcy, "edgeType", names(edgeColors), as.character(edgeColors), mode="lookup")
   setEdgeTargetArrowColorRule(rcy, "edgeType", names(edgeColors), as.character(edgeColors),
                               mode="lookup")
   edgeTargetShapes <- list(activates = "triangle",
                            inhibits = "tee",
                            inactivates = "tee",
                            hydroxylates = "triangle",
                            "TF cofactor" = "none",
                            "TF binding" = "triangle",
                            hydroxylated = "none",
                            stabilizes.mrna = "triangle",
                            preserves = "triangle",
                            proteolyzes = "triangle")

   setEdgeTargetArrowShapeRule(rcy, "edgeType", names(edgeTargetShapes), as.character(edgeTargetShapes))

   redraw(rcy)

   # closeWebSocket(rcy)

   rcy

} # demo.hypoxia
#----------------------------------------------------------------------------------------------------
refnetToGraphNEL <- function(tbl)
{
  g = new ("graphNEL", edgemode="directed")

  nodeDataDefaults(g, attr="type") <- "undefined"
  nodeDataDefaults(g, attr="label") <- "default node label"
  nodeDataDefaults(g, attr="expression") <-  1.0
  nodeDataDefaults(g, attr="gistic") <-  0
  nodeDataDefaults(g, attr="mutation") <-  "none"

  edgeDataDefaults(g, attr="edgeType") <- "undefined"
  edgeDataDefaults(g, attr= "pubmedID") <- ""

  all.nodes <- sort(unique(c(tbl$A, tbl$B)))
  g = graph::addNode (all.nodes, g)
  nodeData (g, all.nodes, "label") = all.nodes

  g = graph::addEdge (tbl$A, tbl$B, g)

  edgeData (g, tbl$A, tbl$B, "edgeType") = tbl$type

  g

} # refnetToGraphNEL
#----------------------------------------------------------------------------------------------------
getExpression <- function()
{

  strong.proneural.tumors <- c("TCGA.02.0014","TCGA.02.0069","TCGA.02.0074",
                               "TCGA.02.0339","TCGA.02.0440","TCGA.02.0446",
                               "TCGA.06.0174","TCGA.06.0177","TCGA.06.0241",
                               "TCGA.06.0410","TCGA.08.0347","TCGA.08.0385",
                               "TCGA.08.0524")
  spn <- strong.proneural.tumors
  print(load("~/s/bioc/trunk/RpacksTesting/ProneuralHeterogeneity/data/tbl.mrna.rda"))
  tbl.mrna <- tbl.mrna[spn,]
  name.map <- c("284"="ANGPT1",
                "285"="ANGPT2",
                "846"="CASR",
                "54583"="EGLN1",
                "112399"="EGLN3",
                "2033"="EP300",
                "3091"="HIF1A",
                "3725"="JUN",
                "3791"="KDR",
                "1432"="MAPK14",
                "6667"="SP1",
                "7010"="TEK",
                "7422"="VEGFA",
                "7428"="VHL")
   mtx <- tbl.mrna[, names(name.map)]

} # getExpression
#----------------------------------------------------------------------------------------------------
getExpression <- function()
{
  library(cgdsr)
  source("~/s/data/public/tcga/code/cgdsr.R")
  url.new <- 'http://www.cbioportal.org/public-portal/';   # trailing slash needed!
  cgdsr.server <- CGDS(url.new)
  goi <- as.character(name.map)
  case <- "gbm_tcga_pub2013_all"
  profile <- "gbm_tcga_pub2013_rna_seq_v2_mrna_median_Zscores"
  tbl.m <- cgdsrRequest(cgdsr.server, goi, profile, case, genesPerQuery = 50)   # 574 x 1582


} #  getExpression
#----------------------------------------------------------------------------------------------------
test.httpAddGraphToExistingGraph <- function()
{
   printf("--- test.httpAddGraphToExistingGraph")
   rcy <- rcy.demo()
   setBackgroundColor(rcy, "#FAFAFA")
   setDefaultEdgeColor(rcy, "blue")
   redraw(rcy)
   checkEquals(nrow(getNodes(rcy)), 3)
   g2 <- createTestGraph(100, 100)
   httpAddGraph(rcy, g2)
   layout(rcy, "grid")
   checkEquals(nrow(getNodes(rcy)), 103)

} # test.httpAddGraphToExistingGraph
#----------------------------------------------------------------------------------------------------
test.httpAddGraphToEmptyGraph <- function()
{
   printf("--- test.httpAddGraphToEmptyGraph")
   rcy <- RCyjs(PORTS, graph=graphNEL())
   setBackgroundColor(rcy, "#FAFAFA")
   setDefaultEdgeColor(rcy, "blue")
   redraw(rcy)
   checkEquals(length(getNodes(rcy)), 0)
   g2 <- createTestGraph(100, 100)
   httpAddGraph(rcy, g2)
   layout(rcy, "grid")
   checkEquals(nrow(getNodes(rcy)), 100)

} # test.httpAddGraphToEmptyGraph
#----------------------------------------------------------------------------------------------------
test.httpAddJsonGraphFromFile <- function()
{
   printf("--- test.httpAddJsonGraphFromFile")
   file <- system.file(package="RCyjs", "extdata", "g.json")
   checkTrue(file.exists(file))

   rcy <- RCyjs(PORTS, graph=graphNEL())
   setBackgroundColor(rcy, "#FAFAFA")
   setDefaultEdgeColor(rcy, "blue")
   redraw(rcy)

   httpAddJsonGraphFromFile(rcy, file)
   fit(rcy)
   layout(rcy, "grid")
   dim(getNodes(rcy))
   checkTrue(nrow(getNodes(rcy)) > 300)

} # test.httpAddGraphToEmptyGraph
#----------------------------------------------------------------------------------------------------
test.savePNG <- function()
{
   printf("--- test.savePNG")
   rcy <- rcy.demo()
   filename <- tempfile(fileext=".png")
   savePNG(rcy, filename)
   checkTrue(file.exists(filename))
   #system(sprintf("open %s", filename))

} # test.savePNG
#----------------------------------------------------------------------------------------------------
test.multiGraphSeparatelyVisibleEdges <- function()
{
   if(!interactive())
       return(TRUE);

   printf("--- test.multiGraphSeparatelyVisibleEdges")
   g <- new("graphNEL", edgemode = "directed")
   g <- graph::addNode(c("A", "B"), g)
   g <- graph::addEdge("A", "B", g)
   g <- graph::addEdge("B", "A", g)

   rcy <- RCyjs(PORTS, graph=g)
   fit(rcy, 200)
   loadStyleFile(rcy, "style.js")

} # test.multiGraphSeparatelyVisibleEdges
#----------------------------------------------------------------------------------------------------
test.httpAddCompoundEdgeToExistingGraph <- function()
{
   if(!interactive())
       return(TRUE);

   printf("--- test.httpAddCompoundEdgeToExistingGraph")

   g <- simpleDemoGraph()
   rcy <- RCyjs(portRange=PORTS, quiet=TRUE, graph=g);
   layout(rcy, "cose")

   setBrowserWindowTitle(rcy, "compoundEdge");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

} # test.httpAddCompoundEdgeToExistingGraph
#----------------------------------------------------------------------------------------------------
test.createStaticView <- function()
{
  printf("--- test.createStaticView")
  rcy <- rcy.demo()
  loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "demoStyle.js"))
  fit(rcy, 100)
  json <- getJSON(rcy)
  fullAssignmentString <- sprintf("network = %s", json)
  templateFile <- system.file(package="RCyjs", "extdata", "staticViewTemplate.html")
  s <- paste(readLines(templateFile), collapse="\n")
  s.edited <- sub("STATIC_VIEW_NETWORK_ASSIGNMENT_GOES_HERE", fullAssignmentString, s, fixed=TRUE)
  writeLines(text=s.edited, "test.html")
  browseURL("test.html")

} # test.createStaticView
#----------------------------------------------------------------------------------------------------

if(!interactive())
    runTests()
