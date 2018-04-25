library (RCyjs)
library (RUnit)
#----------------------------------------------------------------------------------------------------
if(interactive()){
  if(!exists("rcy")){
     title <- "rcy test"
     rcy <- RCyjs(title=title)
     #checkTrue(ready(rcy))
     #checkEquals(getBrowserWindowTitle(rcy), title)
     #checkEquals(length(getNodes(rcy)), 0);
     } # exists
  } # interactive

#----------------------------------------------------------------------------------------------------
waitForDisplay <- function(msecs)
{
    wait(rcy, msecs)
}
#----------------------------------------------------------------------------------------------------
runTests <- function()
{
   test_setGraph();
   test_deleteSetAddGraph()
   test_largeGraph()

   test_setDefaultStyle()
   test_setDefaultStyleElements()
   test_nodeSpecificStyling()

   test_loadStyleFile();
   test_getJSON()
   test_addGraphFromFile()
   #test_multiGraph()

   test_getCounts()
   test_nodeSelection()

   test_getLayoutStrategies()
   test_layouts()
   test_fit()
   test_specialLayouts()

   test_getSetPosition()
   test_saveRestoreLayout()
   test_savePNG()
   test_saveJPG()

   test_zoom()

   test_queryAttributes()
   test_setNodeAttributes();
   test_setEdgeAttributes();

   test_setNodeLabelRule()
   test_setNodeLabelAlignment()


   test_hideShowEdges()
   test_compoundNodes()

   #--------------------------------------------------------------------------------
   # re-enable this at end.  it writes to a new browser tab/window, hiding the above.
   #--------------------------------------------------------------------------------
    test_constructorWithGraphSupplied()

} # run.tests
#----------------------------------------------------------------------------------------------------
# a utility: create and return simple instance, for further experimentation
rcy.demo <- function()
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
   setNodeColorRule(rcy, "count", c(0, 100), c("green", "red"), mode="interpolate")
   redraw(rcy)
   layout(rcy, "cose")
   fit(rcy, 300)

   rcy

} # rcy.demo
#----------------------------------------------------------------------------------------------------
test_setGraph <- function()
{
   printf("--- test_setGraph")

   if(!interactive())
       return(TRUE);

   checkTrue(ready(rcy))

   title <- "setGraph"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   setNodeLabelRule(rcy, "label");
   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy, "count", c(0, 100), c("green", "red"), mode="interpolate")
   redraw(rcy)
   layout(rcy, "cola")
   fit(rcy, 100)

   tbl.nodes <- getNodes(rcy)
   checkEquals(nrow(tbl.nodes), 3)
   checkEquals(tbl.nodes$id, c("A", "B", "C"))
   waitForDisplay(500)

} # test_setGraph
#----------------------------------------------------------------------------------------------------
test_setGraphEdgesInitiallyHidden <- function()
{
   printf("--- test_setGraphEdgesInitiallyHidden")

   if(!interactive())
       return(TRUE);

   checkTrue(ready(rcy))

   title <- "setGraphEdgesInitiallyHidden"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   g <- simpleDemoGraph()
   setGraph(rcy, g, hideEdges=TRUE)
   setNodeLabelRule(rcy, "label");
   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy, "count", c(0, 100), c("green", "red"), mode="interpolate")
   redraw(rcy)
   layout(rcy, "cola")
   fit(rcy, 100)

   tbl.nodes <- getNodes(rcy)
   checkEquals(nrow(tbl.nodes), 3)
   checkEquals(tbl.nodes$id, c("A", "B", "C"))
   waitForDisplay(500)

} # test_setGraphEdgesInitiallyHidden
#----------------------------------------------------------------------------------------------------
test_deleteSetAddGraph <- function()
{
   printf("--- test_deleteSetAddGraph")

   if(!interactive())
       return(TRUE);

   checkTrue(ready(rcy))

   title <- "deleteSedAddGraph"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   deleteGraph(rcy)

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   setNodeLabelRule(rcy, "label");
   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy, "count", c(0, 100), c("green", "red"), mode="interpolate")
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
   waitForDisplay(500)

} # test_deleteSetAddGraph
#----------------------------------------------------------------------------------------------------
# TODO: multiple edges between two edges, in the same direction, do not work (21 apr 2018)
doNotRun_test_multiGraph <- function()
{
   printf("--- test_multiGraph")

   g1 <- graphNEL(c("n1", "n2"), edgemode="directed")
   edgeDataDefaults(g1, "edgeType") <- "g1.edge"
   g1 <- addEdge("n1", "n2", g1)
   setGraph(rcy, g1)
   setDefaultStyle(rcy)
   layout(rcy, "cose")

   g2 <- graphNEL(c("n1", "n2"), edgemode="directed")
   edgeDataDefaults(g2, "edgeType") <- "g2.edge"
   g2 <- addEdge("n1", "n2", g2)
   addGraph(rcy, g2)

} # test_multiGraph
#----------------------------------------------------------------------------------------------------
# to keep tests simple, this file creates an rcy object with an empty graph, at global scope, when
# the file is read (sourced, loaded).  this test, unlike all the others, creates its own new RCyjs
# object, to ensure that we can construct one with a graph, without difficulty or error
test_constructorWithGraphSupplied <- function()
{
   printf("--- test_constructorWithGraphSupplied");

   if(!interactive())
       return(TRUE);

   g <- simpleDemoGraph()

   rcy2 <- RCyjs(graph=g, title="constructorWithGraphSupplied");
   checkTrue(ready(rcy2))
   setNodeLabelRule(rcy2, "label");
   setNodeSizeRule(rcy2, "count", c(0, 30, 110), c(20, 50, 100));
   setNodeColorRule(rcy2, "count", c(0, 100), c("green", "red"), mode="interpolate")
   redraw(rcy2)
   layout(rcy2, "cola")
   waitForDisplay(500)
   fit(rcy2, 350)

   title <- "graph ctor"
   setBrowserWindowTitle(rcy2, title)
   checkEquals(getBrowserWindowTitle(rcy2), title)

   tbl.nodes <- getNodes(rcy2)
   checkEquals(nrow(tbl.nodes), 3)
   checkEquals(tbl.nodes$id, c("A", "B", "C"))
   waitForDisplay(500)

   closeWebSocket(rcy2)

} #  test_constructorWithGraphSupplied
#----------------------------------------------------------------------------------------------------
test_largeGraph <- function()
{
   printf("--- test_largeGraph")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "largeGraph")
   deleteGraph(rcy)
   g <- createTestGraph(nodeCount=1000, edgeCount=1200)
   addGraph(rcy, g)
   #layout(rcy, "grid")
   later(function(){layout(rcy, "grid"); printf("all done waiting in later")}, 4)
   return(TRUE)

   #Sys.sleep(3)
   #waitForDisplay(2000)
   #fit(rcy)
   #layout(rcy, "cola")
   #waitForDisplay(10000)


} # test_largeGraph
#----------------------------------------------------------------------------------------------------
test_setDefaultStyle <- function()
{
   printf("--- test_setDefaultStyle")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "setDefaultStyle")

   g <- createTestGraph(nodeCount=10, edgeCount=30)
   setGraph(rcy, g)
   later(function() layout(rcy, "cose"), 1)
   later(function() setDefaultStyle(rcy), 2)
   later(function() layout(rcy, "grid"), 3)
   later(function()
            loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js")), 4)
   later(function() {printf("--- layout random"); layout(rcy, "random")}, 6)
   later(function() {printf("--- dfs 1 at 10"); setDefaultStyle(rcy)}, 10)
   later(function() {printf("--- dfs 1 at 12"); setDefaultStyle(rcy)}, 12)
   later(function() {printf("--- layout random at 11"); layout(rcy, "random")}, 11);
   later(function() {printf("--- style at 13");
                    loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"))
                    }, 13)
   later(function() {printf("--- dfs 1 at 14"); setDefaultStyle(rcy)}, 16)
   waitForDisplay(5000)

} # test_setDefaultStyle
#----------------------------------------------------------------------------------------------------
test_setDefaultStyleElements <- function()
{
   printf("--- test_setDefaultStyleElements")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "setDefaultStyleElements")

   g <- createTestGraph(nodeCount=10, edgeCount=30)
   setGraph(rcy, g)
   layout(rcy, "cola")
   loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"))

   sizes <- c(0, 10, 20, 30, 40, 50, 30)
   colors <- c("pink", "yellow", "lightblue", "lightgreen", "cyan", "gray", "lemonchiffon")

   for(size in sizes){
      setDefaultNodeWidth(rcy, size); redraw(rcy);waitForDisplay(500)
      } # for size

   for(size in sizes){
      setDefaultNodeHeight(rcy, size); redraw(rcy); waitForDisplay(500)
      } # for size

   for(size in sizes){
      setDefaultNodeSize(rcy, size); redraw(rcy); waitForDisplay(500)
      } # for size

   for(color in colors){
      setDefaultNodeColor(rcy, color); redraw(rcy);waitForDisplay(500)
      } # for size

   shapes <- c("ellipse", "triangle", "rectangle", "roundrectangle",
               "bottomroundrectangle","cutrectangle", "barrel",
               "rhomboid", "diamond", "pentagon", "hexagon",
               "concavehexagon", "heptagon", "octagon", "star", "tag", "vee",
               "ellipse")

   for(shape in shapes){
      setDefaultNodeShape(rcy, shape); redraw(rcy);waitForDisplay(500)
      } # for size

   setDefaultNodeShape(rcy, "roundrectangle");
   setDefaultNodeColor(rcy, "#F0F0F0")
   redraw(rcy)

   for(color in colors){
      setDefaultNodeFontColor(rcy, color); redraw(rcy);waitForDisplay(500)
      } # for size

   setDefaultNodeColor(rcy, "lightblue")
   setDefaultNodeFontColor(rcy, "darkblue")
   redraw(rcy);

   for(fontSize in seq(1, 20, by=2)){
      setDefaultNodeFontSize(rcy, fontSize); redraw(rcy); waitForDisplay(500)
      }

   for(width in c(0:5, 1)){
      setDefaultNodeBorderWidth(rcy, width); redraw(rcy);waitForDisplay(500)
      }

   for(color in c(colors, "black")){
      setDefaultNodeBorderColor(rcy, color); redraw(rcy);waitForDisplay(500)
      }

   arrow.shapes <- c("triangle", "triangle-tee", "triangle-cross", "triangle-backcurve",
                     "vee", "tee", "square", "circle", "diamond", "none")

   for(shape in c(arrow.shapes, "triangle")){
      setDefaultEdgeTargetArrowShape(rcy, shape); redraw(rcy);waitForDisplay(500)
      }

   for(color in c(colors, "black")){
      setDefaultEdgeTargetArrowColor(rcy, color); redraw(rcy);waitForDisplay(500)
      }

   for(shape in c(arrow.shapes, "triangle")){
      setDefaultEdgeSourceArrowShape(rcy, shape); redraw(rcy);waitForDisplay(500)
      }

   for(color in c(colors, "black")){
      setDefaultEdgeSourceArrowColor(rcy, color); redraw(rcy);waitForDisplay(500)
      }

   for(color in c(colors, "black")){
      setDefaultEdgeColor(rcy, color); redraw(rcy);waitForDisplay(500)
      }

   for(width in c(0:5, 1)){
      setDefaultEdgeWidth(rcy, width); redraw(rcy);waitForDisplay(500)
      }

   for(color in c(colors, "black")){
      setDefaultEdgeLineColor(rcy, color); redraw(rcy);waitForDisplay(500)
      }

   line.styles <- c("solid", "dotted", "dashed", "solid")
   for(style in line.styles){
      setDefaultEdgeLineStyle(rcy, style); redraw(rcy);waitForDisplay(500)
      }

} # test_setDefaultStyleElements
#----------------------------------------------------------------------------------------------------
test_nodeSpecificStyling <- function()
{
   printf("--- test_nodeSpecificStyling")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "specificNodeStyling")
   g <- createTestGraph(nodeCount=10, edgeCount=30)
   setGraph(rcy, g)
   layout(rcy, "cola")
   loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle1.js"))
   setDefaultNodeBorderWidth(rcy, 1); redraw(rcy)
   setBackgroundColor(rcy, "lemonchiffon")

   sizes <- c(2, 10, 20, 30, 40, 50, 30)
   colors <- c("pink", "yellow", "lightblue", "lightgreen", "cyan", "gray", "lemonchiffon", "lightgray")

   for(size in sizes){
      setNodeWidth(rcy, "n1", size); redraw(rcy);waitForDisplay(500)
      } # for size

   for(size in sizes){
      setNodeHeight(rcy, c("n4", "n6"), size); redraw(rcy);waitForDisplay(500)
      } # for size

   for(size in sizes){
      setNodeSize(rcy, "n1", size); redraw(rcy);waitForDisplay(500)
      } # for size

   for(color in colors){
      setNodeColor(rcy, "n1", color); redraw(rcy); waitForDisplay(250)
      setNodeColor(rcy, c("n10", "n8"), color); redraw(rcy);waitForDisplay(500)
      } # for size

   for(shape in c(getSupportedNodeShapes(rcy), "ellipse")){
      setNodeShape(rcy, c("n3", "n4"), shape); redraw(rcy); waitForDisplay(500);
      }

   for(color in colors){
      setNodeFontColor(rcy, "n1", color); redraw(rcy); waitForDisplay(250)
      setNodeBorderColor(rcy, c("n10", "n8"), color); redraw(rcy);waitForDisplay(500)
      } # for size

   for(size in c(0:5, 1)){
      setNodeBorderWidth(rcy, c("n1", "n2", "n3"), size); redraw(rcy);waitForDisplay(500)
      } # for size

   for(size in c(0, 1, 5, 10, 15, 20, 30, 10)){
      setNodeFontSize(rcy, c("n1", "n2", "n3"), size); redraw(rcy);waitForDisplay(500)
      } # for size

} # test_nodeSpecificStyling
#----------------------------------------------------------------------------------------------------
test_loadStyleFile <- function(count=3)
{
   printf("--- test_loadStyleFile")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "loadStyleFile")

   setGraph(rcy, simpleDemoGraph())
   layout(rcy, "cola")
   selectNodes(rcy, c("A", "B"))
   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   styleFile.2 <- system.file(package="RCyjs", "extdata", "sampleStyle2.js");

   for(i in 1:3){
      loadStyleFile(rcy, styleFile.1)
      waitForDisplay(500)
      loadStyleFile(rcy, styleFile.2)
      waitForDisplay(500)
      } # for i

} # test_loadStyleFile
#----------------------------------------------------------------------------------------------------
test_getJSON <- function()
{
   printf("--- test_getJSON")

   if(!interactive())
       return(TRUE);

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

} # test_getJSON
#----------------------------------------------------------------------------------------------------
test_addGraphFromFile <- function()
{
   printf("--- test_addGraphFromFile")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "addGraphFromFile");

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

} # test_addGraphFromFile
#----------------------------------------------------------------------------------------------------
test_getCounts <- function()
{
   printf("--- test_getCounts")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "getCounts");

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   layout(rcy, "cola")
   checkEquals(getNodeCount(rcy), length(nodes(g)))
   checkEquals(getEdgeCount(rcy), length(edgeNames(g)))

   nodesRequested <- 10
   edgesRequested <- 15
   g2 <- createTestGraph(nodeCount=nodesRequested, edgeCount=edgesRequested)
   setGraph(rcy, g2)
   layout(rcy, "cola")
      # createTestGraph cannot always return as many edges as requested
      # the edge possiblities may be used up before the full complement
      # is achieved.   so only expect as many edges in rcy as there are in R
   checkEquals(getEdgeCount(rcy), length(edgeNames(g2)))

   addGraph(rcy, g)
   layout(rcy, "cola")
   checkEquals(getNodeCount(rcy), 13)
   checkEquals(getEdgeCount(rcy), length(edgeNames(g2)) + length(edgeNames(g)))

} # test_getCounts
#----------------------------------------------------------------------------------------------------
test_nodeSelection <- function()
{
   printf("--- test_nodeSelection")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "nodeSelection")

   count <- 20
   set.seed(31)
   g <- createTestGraph(nodeCount=count, edgeCount=10)
   setGraph(rcy, g)

   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   loadStyleFile(rcy, styleFile.1)

   layout(rcy, "cola")
   waitForDisplay(500)
   rcy.nodes <- getNodes(rcy)$id
   checkEquals(rcy.nodes, nodes(g))
   target.nodes <- paste("n", sample(1:count, 3), sep="")
     #--------------------------------------------
     # select a few, get them, clear, get none
     #-------------------------------------------
   selectNodes(rcy, target.nodes)
   waitForDisplay(500)
   checkEquals(target.nodes, getSelectedNodes(rcy)$id)
   clearSelection(rcy)
   waitForDisplay(500)
   checkEquals(nrow(getSelectedNodes(rcy)), 0)
     #------------------------------------------
     # select the same few, hide them, get them,
     # check count of remaining visible nodes
     # conclude with showing all
     #------------------------------------------
   selectNodes(rcy, target.nodes)
   waitForDisplay(500)
   hideSelectedNodes(rcy)
   checkEquals(length(getNodes(rcy, "hidden")$id), length(target.nodes))
   checkEquals(length(getNodes(rcy, "visible")$id), count - length(target.nodes))
   checkEquals(length(getNodes(rcy, "all")$id), count)
   checkEquals(length(getNodes(rcy)$id), count)
   waitForDisplay(500)
   checkEquals(sort(getNodes(rcy, "hidden")$id), sort(target.nodes))
   checkEquals(length(getNodes(rcy, "visible")$id), count - 3)
     #-----------------------------------------------------
     # now invert selection twice, getting count each time
     #-----------------------------------------------------
   showAll(rcy) # , which="nodes")
   invertNodeSelection(rcy)
   waitForDisplay(500)
   checkEquals(length(getSelectedNodes(rcy)$id), 17)
   invertNodeSelection(rcy)
   waitForDisplay(500)
   checkEquals(length(getSelectedNodes(rcy)$id), 3)
     #-----------------------------------------------------
     # now delete those three selected nodes.  make sure
     # they are not simply hidden, but truly gone
     #-----------------------------------------------------
   deleteSelectedNodes(rcy)
   waitForDisplay(500)
   checkEquals(length(getNodes(rcy)$id), 17)
   showAll(rcy)
   waitForDisplay(500)
   checkEquals(length(getNodes(rcy)$id), 17)
   showAll(rcy)

   clearSelection(rcy)
   checkEquals(nrow(getSelectedNodes(rcy)), 0)
   selectNodes(rcy, "n8")
   checkEquals(nrow(getSelectedNodes(rcy)), 1)
   sfn(rcy)
   checkEquals(nrow(getSelectedNodes(rcy)), 2)
   selectFirstNeighborsOfSelectedNodes(rcy)
   checkEquals(nrow(getSelectedNodes(rcy)), 3)

} # test_nodeSelection
#----------------------------------------------------------------------------------------------------
test_getLayoutStrategies <- function()
{
   printf("--- test_getLayoutStrategies")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "getLayoutStrategies")

   actual <- getLayoutStrategies(rcy)

   expected.builtin.strategies <- c("breadthfirst", "circle", "concentric", "cose", "grid", "random")
   expected.extension.strategies <- c("cola", "dagre", "cose-bilkent")

   checkTrue(all(expected.builtin.strategies %in% actual))
   checkTrue(all(expected.extension.strategies %in% actual))

} # test_getLayoutStrategies
#----------------------------------------------------------------------------------------------------
test_layouts <- function()
{
   printf("--- test_layouts")

   if(!interactive())
       return(TRUE);

   g <- createTestGraph(nodeCount=20, edgeCount=20)
   setGraph(rcy, g)

   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   loadStyleFile(rcy, styleFile.1)

   fit(rcy)
   redraw(rcy)
   layout.strategies <- getLayoutStrategies(rcy)
   for(strategy in layout.strategies){
     setBrowserWindowTitle(rcy, strategy)
     layout(rcy, strategy)
     waitForDisplay(2000)
     } # for strategy

} #  test_layouts
#----------------------------------------------------------------------------------------------------
test_specialLayouts <- function()
{
   printf("--- test_specialLayouts")

   if(!interactive())
      return(TRUE)

   set.seed(17)
   g <- createTestGraph(nodeCount=100, edgeCount=100)
   setGraph(rcy, g)
   loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle1.js"))
   layout(rcy, "cose")

   noi <- c("n1", "n7", "n21", "n22", "n31", "n42", "n44", "n48", "n51", "n52", "n74",
            "n78", "n79", "n82", "n86", "n98", "n99")
   selectNodes(rcy, noi)
   layoutSelectionInGrid(rcy, -1000, 10, 100, 400)
   fit(rcy)
   waitForDisplay(1000)

   layoutSelectionInGridInferAnchor(rcy, 400, 100)
   waitForDisplay(1000)

   noi <- c("n54", "n57", "n83")
   clearSelection(rcy)
   selectNodes(rcy, noi)
   vAlign(rcy)
   waitForDisplay(1000)

   noi <- c("n3", "n8", "n13", "n34", "n61", "n91")
   selectNodes(rcy, noi)
   waitForDisplay(1000)
   hAlign(rcy)
   waitForDisplay(1000)

} # test_specialLayouts
#----------------------------------------------------------------------------------------------------
# a test whose success is judge by visual inspection
# node positions are unchanged by zoom - presumably rendered position would change
test_fit <- function()
{
   printf("--- test_fit");

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "fit")
   g <- createTestGraph(nodeCount=20, edgeCount=20)
   setGraph(rcy, g)
   layout(rcy, "cola")

   for(padding in c(0, 50, 100, 150, 200, 250, 0)){
      fit(rcy, padding)
      waitForDisplay(500)
      }

   clearSelection(rcy)
   selectNodes(rcy, "n17")
   for(padding in c(0, 50, 100, 150, 200, 250, 300, 400)){
      fitSelection(rcy, padding)
      waitForDisplay(500)
      }


} # test_fit
#----------------------------------------------------------------------------------------------------
test_getSetPosition <- function()
{
   printf("--- test_getSetPosition");

   if(!interactive())
       return(TRUE);

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   setBrowserWindowTitle(rcy, "getSetPosition");
   setNodeLabelRule(rcy, "label");
   layout(rcy, "cola")
   fit(rcy, padding=150)
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
   checkTrue(all(is.numeric(tbl$x)))
   checkTrue(all(is.numeric(tbl$y)))

   tbl2 <- tbl
   tbl2[, 2:3] <- tbl2[, 2:3] + 50

     # move all 3 nodes
   for(i in 1:2){
      setPosition(rcy, tbl2)
      waitForDisplay(500)
      setPosition(rcy, tbl)
      waitForDisplay(500)
      } # for i

     # move jut Gene A
   for(i in 1:2){
      setPosition(rcy, tbl2[1,])
      waitForDisplay(500)
      setPosition(rcy, tbl[1,])
      waitForDisplay(500)
      } # for i

} # test_getSetPosition
#----------------------------------------------------------------------------------------------------
test_setNodeLabelRule <- function()
{
   printf("--- test_setNodeLabelRule")

   if(!interactive())
       return(TRUE);

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   checkTrue(ready(rcy))

   title <- "setNodeLabelRule"
   setBrowserWindowTitle(rcy, title)
   checkEquals(getBrowserWindowTitle(rcy), title)

   all.attributes <- names(nodeData(g)[[1]])
   for(attribute in all.attributes){
     setNodeLabelRule(rcy, attribute);
     redraw(rcy)
     waitForDisplay(500)
     }

   setNodeLabelRule(rcy, "label");
   redraw(rcy)

} # test_setNodeLabelRule
#----------------------------------------------------------------------------------------------------
test_setNodeLabelAlignment <- function()
{
   printf("--- test_setNodeLabelRule")

   if(!interactive())
       return(TRUE);

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   layout(rcy, "cola")
   title <- "setNodeLabelAlignment"
   setBrowserWindowTitle(rcy, title)

   setDefaultNodeSize(rcy, 60)
   setDefaultNodeColor(rcy, "white")
   setDefaultNodeBorderColor(rcy, "black")
   setDefaultNodeBorderWidth(rcy, 1)
   redraw(rcy)

   hValues <- c("left", "center", "right")
   vValues <- c("top",  "center", "bottom")

   fit(rcy, 200)

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

} # test_setNodeLabelAlignment
#----------------------------------------------------------------------------------------------------
# there is some non-deterministic behavior here, the exploration of which is deferred.
# numbers don't have quite the values arithmetic suggests.  sometimes the final zoom is larger than
# the initial zoom.
# this works predictably & reliably at the R command prompt, but
test_zoom <- function()
{
   printf("--- test_zoom")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "zoom")

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   loadStyleFile(rcy, styleFile.1)
   layout(rcy, "cola")
   fit(rcy)

   initial.zoom = getZoom(rcy);
   loops = 8

   for(i in 1:loops){
      setZoom(rcy, 0.5 * getZoom(rcy))
      } # for i

    for(i in 1:(loops)){
      setZoom(rcy, 2.0 * getZoom(rcy))
      } # for i

} # test_zoom
#----------------------------------------------------------------------------------------------------
test_saveRestoreLayout <- function()
{
   printf("--- test_saveRestoreLayout");

   if(!interactive())
       return(TRUE);


   setBrowserWindowTitle(rcy, "restoreLayout");
   g <- simpleDemoGraph()
   setGraph(rcy, g)
   layout(rcy, "cola")
   fit(rcy, 200)
   tbl.pos.1 <- getPosition(rcy)
   f <- tempfile(fileext=".RData")
   saveLayout(rcy, f)
   layout(rcy, "random")
   restoreLayout(rcy, f)
   fit(rcy, 200)
   tbl.pos.2 <- getPosition(rcy)
   checkEqualsNumeric(tbl.pos.1$x, tbl.pos.2$x, tol=1e-2)
   checkEqualsNumeric(tbl.pos.1$y, tbl.pos.2$y, tol=1e-2)

} # test_saveRestoreLayout
#----------------------------------------------------------------------------------------------------
test_savePNG <- function()
{
   printf("--- test_savePNG")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "savePNG")
   g <- createTestGraph(100, 100)
   setGraph(rcy, g)
   layout(rcy, "cose")

   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   loadStyleFile(rcy, styleFile.1)

   filename <- tempfile(fileext=".png")
   savePNG(rcy, filename)
   checkTrue(file.exists(filename))
   checkTrue(file.size(filename) > 100000)

} # test_savePNG
#----------------------------------------------------------------------------------------------------
test_saveJPG <- function()
{
   printf("--- test_saveJPG")

   if(!interactive())
       return(TRUE);

   setBrowserWindowTitle(rcy, "saveJPG")
   g <- createTestGraph(100, 100)
   setGraph(rcy, g)
   layout(rcy, "cose")
   loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"))

   selectNodes(rcy, paste("n", sample(1:100, size=10), sep=""))

   filename.1 <- tempfile(fileext=".jpg")
   filename.4 <- tempfile(fileext=".jpg")

   saveJPG(rcy, filename.1, resolutionFactor=1)
   checkTrue(file.exists(filename.1))
   fs.1 <- file.size(filename.1)

   saveJPG(rcy, filename.4, resolutionFactor=4)
   checkTrue(file.exists(filename.4))
   fs.2 <- file.size(filename.4)

     # found ratio of fs2.4/fs.1 to be ~9.18.  aspect ratio preserved, file is
     # larger therefore in x and y.

   checkTrue(fs.2/fs.1 > 4)

} # test_saveJPG
#----------------------------------------------------------------------------------------------------
test_setNodeAttributes <- function()
{
   printf("--- test_setNodeAttributes")

   if(!interactive())
      return(TRUE)

   setBrowserWindowTitle(rcy, "setNodeAttributes")
   g <- simpleDemoGraph()
   setGraph(rcy, g)
   layout(rcy, "cose")
   fit(rcy, 100)
   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   styleFile.2 <- system.file(package="RCyjs", "extdata", "sampleStyle2.js");
   loadStyleFile(rcy, styleFile.2)

     # originally lfc is c(-3, 0, 3)
   setNodeAttributes(rcy, "lfc", c("A", "B", "C"), c(0, 0, 0))
   redraw(rcy)
   waitForDisplay(500)

   setNodeAttributes(rcy, "lfc", c("A", "B", "C"), c(1, 2, 3))
   redraw(rcy)
   waitForDisplay(500)

   setNodeAttributes(rcy, "lfc", c("A", "B", "C"), c(-3, -2, -1))
   redraw(rcy)
   waitForDisplay(500)

} # test_setNodeAttributes
#----------------------------------------------------------------------------------------------------
test_setEdgeAttributes <- function()
{
   printf("--- test_setEdgeAttributes")

   if(!interactive())
      return(TRUE)

   setBrowserWindowTitle(rcy, "setEdgeAttributes")
   g <- simpleDemoGraph()
   setGraph(rcy, g)
   layout(rcy, "cose")
   fit(rcy, 100)
   styleFile.1 <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
   styleFile.2 <- system.file(package="RCyjs", "extdata", "sampleStyle2.js");
   loadStyleFile(rcy, styleFile.2)

   setEdgeAttributes(rcy, attribute="score",
                     sourceNodes=c("A", "B", "C"),
                     targetNodes=c("B", "C", "A"),
                     edgeTypes=c("phosphorylates", "synthetic lethal", "undefined"),
                     values=c(0, 0, 0))

   redraw(rcy)  # all edges should be lightgray
   waitForDisplay(500)

   setEdgeAttributes(rcy, attribute="score",
                     sourceNodes=c("A", "B", "C"),
                     targetNodes=c("B", "C", "A"),
                     edgeTypes=c("phosphorylates", "synthetic lethal", "undefined"),
                     values=c(30, 30, 30))

   redraw(rcy)  # all edges should be green
   waitForDisplay(500)

   setEdgeAttributes(rcy, attribute="score",
                     sourceNodes=c("A", "B", "C"),
                     targetNodes=c("B", "C", "A"),
                     edgeTypes=c("phosphorylates", "synthetic lethal", "undefined"),
                     values=c(-30, 0, 30))

   redraw(rcy)  # edges should be AB: red, BC: lightgray, CA: green
   waitForDisplay(500)

   setEdgeAttributes(rcy, attribute="score",
                     sourceNodes=c("A", "B", "C"),
                     targetNodes=c("B", "C", "A"),
                     edgeTypes=c("phosphorylates", "synthetic lethal", "undefined"),
                     values=c(30, -30, 0))

   redraw(rcy)  # edges should be AB: red, BC: lightgray, CA: green
   waitForDisplay(500)

   setEdgeAttributes(rcy, attribute="score",
                     sourceNodes=c("A", "B", "C"),
                     targetNodes=c("B", "C", "A"),
                     edgeTypes=c("phosphorylates", "synthetic lethal", "undefined"),
                     values=c(0, 30, -30))

   redraw(rcy)  # edges should be AB: red, BC: lightgray, CA: green
   waitForDisplay(500)

} # test_setEdgeAttributes
#----------------------------------------------------------------------------------------------------
test_hideShowEdges <- function()
{
   printf("--- test_hideShowEdges")

   if(!interactive())
      return(TRUE)

   g <- simpleDemoGraph()
   setGraph(rcy, g)
   layout(rcy, "cola")
   loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"))
   target.edge.type <- "phosphorylates"
   checkTrue(target.edge.type %in% eda(g, "edgeType"))
   hideEdges(rcy, target.edge.type)
   waitForDisplay(1000)
   showEdges(rcy, target.edge.type)
   waitForDisplay(1000)
   hideEdges(rcy, target.edge.type)
   waitForDisplay(1000)
   showAll(rcy, which="edges")

   hideAllEdges(rcy)
   waitForDisplay(1000)
   showAll(rcy, which="edges")

} # test_hideShowEdges
#----------------------------------------------------------------------------------------------------
test_compoundNodes <- function()
{
   printf("--- test_compoundNodes")

   if(!interactive())
      return(TRUE)

   setBrowserWindowTitle(rcy, "compoundNodes")
   set.seed(17)
   g <- createTestGraph(nodeCount=10, edgeCount=10)
   nodeDataDefaults(g, attr="parent") <- ""
   nodeData(g, c("n3", "n10"), attr="parent") <- "n8"
   nodeData(g, c("n7"), attr="parent") <- "n3"
   setGraph(rcy, g)
   layout(rcy, "cola")
   loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"))

   setNodeLabelAlignment(rcy, "center", "top")

   redraw(rcy)
   fit(rcy)
   layout(rcy, "cola")

} # test_compoundNodes
#----------------------------------------------------------------------------------------------------
test_queryAttributes <- function()
{
   printf("--- test_queryAttributes")

   if(!interactive())
      return(TRUE);

   g <- simpleDemoGraph()
   checkEquals(sort(noaNames(g)), c("count", "label", "lfc", "type"))
   checkEquals(noa(g, "lfc"), c(A=-3, B=0, C=3))

   checkEquals(sort(edaNames(g)), c("edgeType", "misc", "score"))
   checkEquals(eda(g, "edgeType"), c("A|B"="phosphorylates", "B|C"="synthetic lethal", "C|A"="undefined"))

} # test_queryAttributes
#----------------------------------------------------------------------------------------------------
deferred_test_multiGraphSeparatelyVisibleEdges <- function()
{
   if(!interactive())
       return(TRUE);

   printf("--- test_multiGraphSeparatelyVisibleEdges")
   g <- new("graphNEL", edgemode = "directed")
   g <- graph::addNode(c("A", "B"), g)
   g <- graph::addEdge("A", "B", g)
   g <- graph::addEdge("B", "A", g)

   setGraph(rcy, g)
   fit(rcy, 200)
   loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"))

} # deferred_test_multiGraphSeparatelyVisibleEdges
#----------------------------------------------------------------------------------------------------
deferred_test_httpAddCompoundEdgeToExistingGraph <- function()
{
   if(!interactive())
       return(TRUE);

   printf("--- test_httpAddCompoundEdgeToExistingGraph")

   g <- simpleDemoGraph()
   setGraphr(rcy, g)
   layout(rcy, "cose")

   setBrowserWindowTitle(rcy, "compoundEdge");
   setNodeLabelRule(rcy, "label");
   redraw(rcy)

} # deferred_test_httpAddCompoundEdgeToExistingGraph
#----------------------------------------------------------------------------------------------------
skiptest_createStaticView <- function()
{
  printf("--- test_createStaticView")

   if(!interactive())
      return(TRUE)

  rcy <- rcy.demo()
  loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "demoStyle.js"))
  fit(rcy, 100)
  json <- getJSON(rcy)
  fullAssignmentString <- sprintf("network = %s", json)
  templateFile <- system.file(package="RCyjs", "extdata", "staticViewTemplate.html")
  s <- paste(readLines(templateFile), collapse="\n")
  s.edited <- sub("STATIC_VIEW_NETWORK_ASSIGNMENT_GOES_HERE", fullAssignmentString, s, fixed=TRUE)
  writeLines(text=s.edited, "test_html")
  browseURL("test_html")

} # skiptest_createStaticView
#----------------------------------------------------------------------------------------------------
if(!interactive())
    runTests()
