#' @importFrom methods new is
#' @import BiocGenerics
#' @import httpuv
#' @import BrowserViz
#' @importFrom utils write.table
#'
#' @name RCyjs-class
#' @rdname RCyjs-class
#' @exportClass RCyjs

DEFAULT_PORT_RANGE <- 16000:16100

.RCyjs <- setClass ("RCyjs",
                    representation = representation(graph="graph"),
                    contains = "BrowserVizClass"
                    )

#----------------------------------------------------------------------------------------------------
# built (cd inst/browserCode; make) with npm and webpack, this html+javascript file has all of the
# browser-side code
cyjsBrowserFile <- system.file(package="RCyjs", "browserCode", "dist", "rcyjs.html")
#----------------------------------------------------------------------------------------------------
printf <- function(...) print(noquote(sprintf(...)))
#----------------------------------------------------------------------------------------------------
setGeneric('setGraph',            signature='obj', function(obj, graph) standardGeneric ('setGraph'))
setGeneric('addGraph',            signature='obj', function(obj, graph) standardGeneric ('addGraph'))
setGeneric('deleteGraph',         signature='obj', function(obj) standardGeneric ('deleteGraph'))
setGeneric('loadStyleFile',       signature='obj', function(obj, filename) standardGeneric ('loadStyleFile'))
setGeneric('getJSON',             signature='obj', function(obj) standardGeneric('getJSON'))
setGeneric('addGraphFromFile',    signature='obj', function(obj, jsonFileName) standardGeneric ('addGraphFromFile'))

setGeneric('getNodeCount',        signature='obj', function(obj) standardGeneric ('getNodeCount'))
setGeneric('getEdgeCount',        signature='obj', function(obj) standardGeneric ('getEdgeCount'))
setGeneric('getNodes',            signature='obj', function(obj, which="all") standardGeneric ('getNodes'))

setGeneric('getSelectedNodes',    signature='obj', function(obj) standardGeneric ('getSelectedNodes'))
setGeneric('clearSelection',      signature='obj', function(obj, which="both") standardGeneric ('clearSelection'))
setGeneric('invertNodeSelection', signature='obj', function(obj) standardGeneric ('invertNodeSelection'))
setGeneric('hideSelectedNodes',   signature='obj', function(obj) standardGeneric ('hideSelectedNodes'))
setGeneric('deleteSelectedNodes', signature='obj', function(obj) standardGeneric ('deleteSelectedNodes'))
setGeneric('redraw',              signature='obj', function(obj) standardGeneric ('redraw'))


setGeneric('setNodeAttributes',   signature='obj', function(obj, attribute, nodes, values) standardGeneric('setNodeAttributes'))
setGeneric('setEdgeAttributes',   signature='obj', function(obj, attribute, sourceNodes, targetNodes, edgeTypes, values) standardGeneric('setEdgeAttributes'))


setGeneric('setNodeLabelRule',    signature='obj', function(obj, attribute) standardGeneric ('setNodeLabelRule'))
setGeneric('setNodeLabelAlignment',  signature='obj', function(obj, horizontal, vertical) standardGeneric ('setNodeLabelAlignment'))
setGeneric('setNodeSizeRule',     signature='obj', function(obj, attribute, control.points, node.sizes) standardGeneric('setNodeSizeRule'))
setGeneric('setNodeColorRule',    signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setNodeColorRule'))
setGeneric('setNodeShapeRule',    signature='obj', function(obj, attribute, control.points, node.shapes) standardGeneric('setNodeShapeRule'))

setGeneric('setEdgeStyle',        signature='obj', function(obj, mode) standardGeneric('setEdgeStyle'))
setGeneric('setEdgeColorRule',    signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setEdgeColorRule'))
setGeneric('setEdgeWidthRule',    signature='obj', function(obj, attribute, control.points, widths, mode) standardGeneric('setEdgeWidthRule'))

setGeneric('setEdgeTargetArrowShapeRule',   signature='obj', function(obj, attribute, control.points, shapes) standardGeneric('setEdgeTargetArrowShapeRule'))
setGeneric('setEdgeTargetArrowColorRule',   signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setEdgeTargetArrowColorRule'))

setGeneric('setEdgeSourceArrowShapeRule',   signature='obj', function(obj, attribute, control.points, shapes) standardGeneric('setEdgeSourceArrowShapeRule'))
setGeneric('setEdgeSourceArrowColorRule',   signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setEdgeSourceArrowColorRule'))

setGeneric('layout',                 signature='obj', function(obj, strategy="random") standardGeneric('layout'))
setGeneric('getLayoutStrategies',    signature='obj', function(obj) standardGeneric('getLayoutStrategies'))
setGeneric('layoutSelectionInGrid', signature='obj', function(obj, x, y, w, h) standardGeneric('layoutSelectionInGrid'))
setGeneric('layoutSelectionInGridInferAnchor', signature='obj', function(obj, w, h) standardGeneric('layoutSelectionInGridInferAnchor'))
setGeneric('getPosition',         signature='obj', function(obj, nodeIDs=NA) standardGeneric('getPosition'))
setGeneric('setPosition',         signature='obj', function(obj, tbl.pos) standardGeneric('setPosition'))
setGeneric('getNodeSize',         signature='obj', function(obj, nodeIDs=NA) standardGeneric('getNodeSize'))
setGeneric('getLayout',           signature='obj', function(obj) standardGeneric('getLayout'))
setGeneric('saveLayout',          signature='obj', function(obj, filename) standardGeneric('saveLayout'))
setGeneric('getJSON',             signature='obj', function(obj) standardGeneric('getJSON'))
setGeneric('savePNG',             signature='obj', function(obj, filename) standardGeneric('savePNG'))
setGeneric('restoreLayout',       signature='obj', function(obj, filename) standardGeneric('restoreLayout'))
setGeneric('setZoom',             signature='obj', function(obj, newValue) standardGeneric('setZoom'))
setGeneric('getZoom',             signature='obj', function(obj) standardGeneric('getZoom'))
setGeneric('setBackgroundColor',  signature='obj', function(obj, newValue) standardGeneric ('setBackgroundColor'))
setGeneric('fit',                 signature='obj', function(obj, padding=30) standardGeneric('fit'))
setGeneric('fitContent',          signature='obj', function(obj, padding=30) standardGeneric('fitContent'))
setGeneric('fitSelectedContent',  signature='obj', function(obj, padding=30) standardGeneric('fitSelectedContent'))
setGeneric('selectNodes',         signature='obj', function(obj, nodeIDs) standardGeneric('selectNodes'))
setGeneric('sfn',                 signature='obj', function(obj) standardGeneric('sfn'))

setGeneric('hideAllEdges',        signature='obj', function(obj) standardGeneric('hideAllEdges'))
setGeneric('showAll',             signature='obj', function(obj, which="both") standardGeneric('showAll'))
setGeneric('hideEdges',           signature='obj', function(obj, edgeType) standardGeneric('hideEdges'))
setGeneric('showEdges',           signature='obj', function(obj, edgeType) standardGeneric('showEdges'))
setGeneric('vAlign',              signature='obj', function(obj) standardGeneric('vAlign'))
setGeneric('hAlign',              signature='obj', function(obj) standardGeneric('hAlign'))

setGeneric("setNodeImage", signature='obj', function(obj, imageURLs) standardGeneric('setNodeImage'))

setGeneric("setDefaultNodeSize",  signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeSize'))
setGeneric("setDefaultNodeWidth", signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeWidth'))
setGeneric("setDefaultNodeHeight", signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeHeight'))
setGeneric("setDefaultNodeColor", signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeColor'))
setGeneric("setDefaultNodeShape", signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeShape'))
setGeneric("setDefaultNodeFontColor", signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeFontColor'))
setGeneric("setDefaultNodeFontSize", signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeFontSize'))
setGeneric("setDefaultNodeBorderWidth", signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeBorderWidth'))
setGeneric("setDefaultNodeBorderColor", signature='obj', function(obj, newValue) standardGeneric('setDefaultNodeBorderColor'))


setGeneric("setDefaultEdgeFontSize", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeFontSize"))
setGeneric("setDefaultEdgeTargetArrowShape", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeTargetArrowShape"))
setGeneric("setDefaultEdgeColor", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeColor"))
setGeneric("setDefaultEdgeTargetArrowColor", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeTargetArrowColor"))
setGeneric("setDefaultEdgeFontSize", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeFontSize"))
setGeneric("setDefaultEdgeWidth", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeWidth"))
setGeneric("setDefaultEdgeLineColor", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeLineColor"))
setGeneric("setDefaultEdgeFont", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeFont"))
setGeneric("setDefaultEdgeFontWeight", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeFontWeight"))
setGeneric("setDefaultEdgeTextOpacity", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeTextOpacity"))
setGeneric("setDefaultEdgeLineStyle", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeLineStyle"))
setGeneric("setDefaultEdgeOpacity", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeOpacity"))
setGeneric("setDefaultEdgeSourceArrowColor", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeSourceArrowColor"))
setGeneric("setDefaultEdgeSourceArrowShape", signature="obj", function(obj, newValue) standardGeneric("setDefaultEdgeSourceArrowShape"))

#----------------------------------------------------------------------------------------------------
#' Create an RCyjs object
#'
#' @description
#' The RCyjs class provides an R interface to cy.js, a rich, interactive, full-featured, javascript
#' network (graph) library.  One constructs an RCyjs instance on a specified port (default 9000),
#' the browser code is loaded, and a websocket connection opened.
#'
#' @rdname RCyjs-class
#'
#' @param portRange The constructor looks for a free websocket port in this range.  15000:15100 by default
#' @param title Used for the web browser window, "RCyjs" by default
#' @param quiet A logical variable controlling verbosity during execution
#'
#' @return An object of the RCyjs class
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="rcyjs demo", graph=g)
#'   setNodeLabelRule(rcy, "label");
#'   setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
#'   setNodeColorRule(rcy, "count", c(0, 100), c(colors$green, colors$red), mode="interpolate")
#'   redraw(rcy)
#'   layout(rcy, "cose")
#'   }
#'
#----------------------------------------------------------------------------------------------------
# constructor
RCyjs = function(portRange=DEFAULT_PORT_RANGE, title="RCyjs", graph=graphNEL(), quiet=TRUE)
{
   obj <- .RCyjs(BrowserViz(portRange, title, quiet, browserFile=cyjsBrowserFile,
                            httpQueryProcessingFunction=myQP),
                 graph=graph)

   if(length(nodes(graph)) > 0){
      setGraph(obj, graph)
      if(!quiet)
         printf("loading graph with %d nodes", length(nodes(graph)))
      layout(obj, "random")
      } # if graph

   if(!quiet)
     message(sprintf("RCyjs ctor about to retrun RCyjs object"))

   setBrowserWindowTitle(obj, title)

   obj

} # RCyjs: constructor
#----------------------------------------------------------------------------------------------------
#' setGraph
#'
#' \code{setGraph} Establish a new graph in RCyjs, removing any previous graph
#'
#' This method will remove any previous graph in the browser, adding
#' a new one.  Setting visual properties and performing layout must follow.
#'
#' @rdname setGraph
#' @aliases setGraph
#'
#' @param obj  RCyjs instance
#' @param graph  a graphNEL
#'
#' @return nothing
#'
#' @seealso\code{\link{addGraph}}
#' @export
#'
#' @examples
#' if(interactive()){
#'   sampleGraph <- simpleDemoGraph()
#'   rcy <- RCyjs(title="rcyjs demo")
#'   setGraph(rcy, sampleGraph)
#'   }
#'
setMethod('setGraph', 'RCyjs',

  function (obj, graph) {
     x <- deleteGraph(obj)
     x <- addGraph(obj, graph)
     #g.json <- .graphToJSON(graph)
     #g.json <- as.character(biocGraphToCytoscapeJSON(graph))

     #send(obj, list(cmd="setGraph", callback="handleResponse", status="request",
     #               payload=list(graph=g.json, hideEdges=hideEdges)))
     #while (!browserResponseReady(obj)){
     #   Sys.sleep(.1)
     #   }
     invisible(getBrowserResponse(obj))
     })

#----------------------------------------------------------------------------------------------------
#' deleteGraph
#'
#' \code{deleteGraph} Remove all nodes and edges, the elements of the current graph.
#'
#' This method will remove any previous graph in the browser
#'
#' @rdname deleteGraph
#' @aliases deleteGraph
#'
#' @param obj  RCyjs instance
#'
#' @return nothing
#'
#' @seealso \code{\link{addGraph}} \code{\link{setGraph}}
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   sampleGraph <- simpleDemoGraph()
#'   rcy <- RCyjs(title="rcyjs demo", graph=sampleGraph)
#'   deletetGraph(rcy)
#'   }
#'
setMethod('deleteGraph', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="deleteGraph", callback="handleResponse", status="request", payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj))
     })

#----------------------------------------------------------------------------------------------------
#' addGraph
#'
#' \code{addGraph} send these nodes and edges (with attributes) to RCyjs for display
#'
#' This version transmits a graph (nodes, edges and attributes) to the browser
#' by writing the data to a file, and sending that filename to be read in the
#' browser by javascript.
#'
#' @rdname addGraph
#' @aliases addGraph
#'
#' @param obj  an RCyjs instance
#' @param graph a graphNEL
#'
#' @return nothing
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   rcy <- RCyjs(title="rcyjs demo", graph=g)
#'   g <- simpleDemoGraph()
#'   setGraph(rcy, g)
#'   }
#'

setMethod('addGraph', 'RCyjs',

  function (obj, graph) {
     g.json <- paste("network = ", .graphToJSON(graph))
     temp.filename <- tempfile(fileext=".json")
     write(g.json, file=temp.filename)
     payload <- list(filename=temp.filename)
     send(obj, list(cmd="addGraph", callback="handleResponse", status="request", payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })

#----------------------------------------------------------------------------------------------------
#' addGraphFromFile
#'
#' \code{addGraphFromFile} add graph from specified file, which contains a cytoscape.js JSON graph
#'
#' More description
#'
#' @rdname addGraphFromFile
#' @aliases addGraphFromFile
#'
#' @param obj an RCyjs instance
#' @param jsonFileName path to the file
#'
#' @return nothin
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   filename <- system.file(package="RCyjs", "extdata", "sampleGraph.json")
#'   addGraphFromFile(rcy, filename)
#'   layout(rcy, "cose")
#'   fit(rcy, 200)
#'   }
#'

setMethod('addGraphFromFile', 'RCyjs',

  function (obj, jsonFileName) {
     payload <- list(filename=jsonFileName)
     send(obj, list(cmd="addGraph", callback="handleResponse", status="request", payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     #printf("browserResponseReady")
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
#' loadStyleFile
#'
#' \code{loadStyleFile} load a named JSON cytoscape.js style file into the browser
#'
#' Though we provide access to individual styling rules (see below) we often find
#' it convenient to express all aspects of a visual style in a single JSON file
#' See \link{http://js.cytoscape.org/#style}.
#'
#' @rdname loadStyleFile
#' @aliases loadStyleFile
#'
#' @param filename contains json in the proper cytoscape.js format
#'
#' @return nothing
#'
#' @export
#'
#' @examples
#'   if(interactive()){
#'   rcy <- demo()
#'   filename <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
#'   loadStyleFile(rcy, filename)
#'   }
#'

setMethod('loadStyleFile', 'RCyjs',

  function (obj, filename) {
     send(obj, list(cmd="loadStyleFile", callback="handleResponse", status="request",
                    payload=filename))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     #printf("browserResponseReady")
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
#' getNodes
#'
#' \code{getNodes} returns a data.frame, one row per node, providing id and (if present) name and
#' label columns
#'
#' Every node is guaranteed to have an "id" attribute.  Becuase "name" and "label" are commonly
#' used as well, they are returned as columns in the data.frame if present
#'
#' @rdname getNodes
#' @aliases getNodes
#'
#' @param obj an RCyjs instance
#' @param which a character string, either "all", "visible" or "hidden"
#'
#' @return a data.frame with at least and "id" column
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    getNodes(rcy)
#'    }
#'

setMethod('getNodes', 'RCyjs',

  function (obj, which) {
     stopifnot(which %in% c("all", "visible", "hidden"))
     payload <- list(which=which)
     send(obj, list(cmd="getNodes", callback="handleResponse", status="request", payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0)
       return(fromJSON(getBrowserResponse(obj)))
     else
       return("")
     })

#----------------------------------------------------------------------------------------------------
#' getNodeCount
#'
#' \code{getNodeCount} the number of nodes in the current cytoscape.js graph
#'
#' @rdname getNodeCount
#' @aliases getNodeCount
#'
#' @param obj RCyjs instance
#'
#' @return numeric count
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    getNodeCount(rcy)
#'    }
#'

setMethod('getNodeCount', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="getNodeCount", callback="handleResponse", status="request", payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0)
       return(fromJSON(getBrowserResponse(obj)))
     else
       return("")
     })

#----------------------------------------------------------------------------------------------------
#' getEdgeCount
#'
#' \code{getEdgeCount} the number of edges in the current cytoscape.js graph
#'
#' @rdname getEdgeCount
#' @aliases getEdgeCount
#'
#' @param obj RCyjs instance
#'
#' @return numeric count
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    getEdgeCount(rcy)
#'    }
#'

setMethod('getEdgeCount', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="getEdgeCount", callback="handleResponse", status="request", payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0)
       return(fromJSON(getBrowserResponse(obj)))
     else
       return("")
     })

#----------------------------------------------------------------------------------------------------
#' clearSelection
#'
#' \code{clearSelection} deselect all selected nodes, all selected edges, or both
#'
#' @rdname clearSelection
#' @aliases clearSelection
#'
#' @param obj an RCyjs object
#' @param which a character string:  "both" (the default), "nodes" or "edges"
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    selectNodes(rcy, c("A", "B"))
#'    clearSelection(rcy)
#'    }
#'

setMethod('clearSelection', 'RCyjs',

  function (obj, which="both") {
     stopifnot(which %in% c("both", "nodes", "edges"))
     payload <- list(which=which)
     send(obj, list(cmd="clearSelection", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     return("")
     })

#----------------------------------------------------------------------------------------------------
#' getSelectedNodes
#'
#' \code{getSelectedNodes} get the selected nodes
#'
#' @rdname getSelectedNodes
#' @aliases getSelectedNodes
#'
#' @param obj an RCyjs instance
#'
#' @return a data.frame with (at least) an id column
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    nodes.to.select <- getNodes(rcy)$id
#'    selectNodes(rcy, nodes.to.select)
#'    }
#'

setMethod('getSelectedNodes', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="getSelectedNodes", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0){
        result <- fromJSON(getBrowserResponse(obj))
        if(!is.data.frame(result))  # always empty, indicates no selected nodes
          result <- data.frame()
        return(result)
        }
     else
       return("")
     })

#----------------------------------------------------------------------------------------------------
#' invertNodeSelection
#'
#' \code{invertNodeSelection} deselect all selected nodes, select all previously unselected nodes
#'
#' @rdname invertNodeSelection
#' @aliases invertNodeSelection
#'
#' @param obj an RCyjs instance
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    target <- nodes(g)[1]
#'    selectNodes(rcy, target)
#'    invertNodeSelection(rcy)
#'    }
#'

setMethod('invertNodeSelection', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="invertNodeSelection", callback="handleResponse", status="request",
                    payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0)
       return(fromJSON(getBrowserResponse(obj)))
     else
       return("")
     })

#----------------------------------------------------------------------------------------------------
#' hideSelectedNodes
#'
#' \code{hideSelectedNodes} hide selected nodes from view
#'
#' The hidden nodes are not deleted from the graph
#'
#' @rdname hideSelectedNodes
#' @aliases hideSelectedNodes
#'
#' @param obj  an RCyjs instance
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    target <- nodes(g)[1]
#'    selectNodes(rcy, target)
#'    hideSelectedNodes(rcy)
#'    getNodes(rcy, "hidden")
#'    getNodes(rcy, "visible")
#'    showAll(rcy, which="nodes")
#'    }
#'
#' @seealso \code{\link{showAll}}

setMethod('hideSelectedNodes', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="hideSelectedNodes", callback="handleResponse", status="request",
                    payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0)
       return(fromJSON(getBrowserResponse(obj)))
     else
       return("")
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('deleteSelectedNodes', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="deleteSelectedNodes", callback="handleResponse", status="request",
                    payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0)
       return(fromJSON(getBrowserResponse(obj)))
     else
       return("")
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setNodeAttributes', 'RCyjs',

   function(obj, attribute, nodes, values){

     if (length (nodes) == 0)
       return ()

     if(length(values) == 1)
        values <- rep(values, length(nodes))

     payload <- list(attribute=attribute, nodes=nodes, values=values)
     send(obj, list(cmd="setNodeAttributes", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0)
       return(fromJSON(getBrowserResponse(obj)))
     else
       invisible("")
     }) # setNodeAttributes

#------------------------------------------------------------------------------------------------------------------------
# when implemented, this will probably resolved to this javascript, for instance
#cy.edges("edge[source='Crem'][target='Hk2'][edgeType='undefined']").data({"score": 3})

#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setEdgeAttributes', 'RCyjs',

   function(obj, attribute, sourceNodes, targetNodes, edgeTypes, values){
     if (length (sourceNodes) == 0)
       return ()

     if(length(sourceNodes) == 1)
        values <- rep(values, length(sourceNodes))

     payload <- list(attribute=attribute, sourceNodes=sourceNodes, targetNodes=targetNodes,
                     edgeTypes=edgeTypes, values=values)
     send(obj, list(cmd="setEdgeAttributes", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     result <- getBrowserResponse(obj)
     if(nchar(result) > 0)
       return(fromJSON(getBrowserResponse(obj)))
     else
       invisible("")

     }) # setEdgeAttributes

#------------------------------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('redraw', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="redraw", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setNodeLabelRule', 'RCyjs',

  function (obj, attribute) {
     send(obj, list(cmd="setNodeLabelRule", callback="handleResponse", status="request",
                                  payload=attribute))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setNodeLabelAlignment', 'RCyjs',

  function (obj, horizontal, vertical) {
     stopifnot(vertical %in% c("top", "center", "bottom"))
     stopifnot(horizontal %in% c("left", "center", "right"))
     payload = list(vertical=vertical, horizontal=horizontal)
     send(obj, list(cmd="setNodeLabelAlignment", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setNodeImage', 'RCyjs',

  function (obj, imageURLs) {
     recognizedNodes <- intersect(names(imageURLs), nodes(obj@graph))
     send(obj, list(cmd="setNodeImage", callback="handleResponse", status="request",
                                  payload=imageURLs))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setNodeSizeRule', 'RCyjs',

  function (obj, attribute, control.points, node.sizes) {
     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     nodeSizes=node.sizes)
     send(obj, list(cmd="setNodeSizeRule", callback="handleResponse", status="request",
                                  payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setNodeColorRule', 'RCyjs',

  function (obj, attribute, control.points, colors, mode="interpolate") {

     if (!mode %in% c ('interpolate', 'lookup')) {
       write("Error! RCyjs:setNodeColorRule.  mode must be 'interpolate' (the default) or 'lookup'.", stderr ())
       return ()
       }

     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     nodeColors=colors,
                     mode=mode)
     send(obj, list(cmd="setNodeColorRule", callback="handleResponse", status="request",
                                  payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setNodeShapeRule', 'RCyjs',

  function (obj, attribute, control.points, node.shapes) {

     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     nodeShapes=node.shapes,
                     mode=mode)
     send(obj, list(cmd="setNodeShapeRule", callback="handleResponse", status="request",
                                  payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setEdgeStyle', 'RCyjs',

  function (obj, mode) {

     payload <- mode
     send(obj, list(cmd="setEdgeStyle", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setEdgeColorRule', 'RCyjs',

  function (obj, attribute, control.points, colors, mode="interpolate") {

     if (!mode %in% c ('interpolate', 'lookup')) {
       write("Error! RCyjs:setEdgeColorRule.  mode must be 'interpolate' (the default) or 'lookup'.", stderr ())
       return ()
       }

     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     edgeColors=colors,
                     mode=mode)
     send(obj, list(cmd="setEdgeColorRule", callback="handleResponse", status="request",
                     payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setEdgeWidthRule', 'RCyjs',

  function (obj, attribute, control.points, widths, mode="interpolate") {

     if (!mode %in% c ('interpolate', 'lookup')) {
       write("Error! RCyjs:setEdgeWidthRule.  mode must be 'interpolate' (the default) or 'lookup'.", stderr ())
       return ()
       }

     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     widths=widths,
                     mode=mode)
     send(obj, list(cmd="setEdgeWidthRule", callback="handleResponse", status="request",
                     payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setEdgeTargetArrowShapeRule', 'RCyjs',

  function (obj, attribute, control.points, shapes) {

     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     edgeShapes=shapes)
     send(obj, list(cmd="setEdgeTargetArrowShapeRule", callback="handleResponse", status="request",
                     payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setEdgeSourceArrowShapeRule', 'RCyjs',

  function (obj, attribute, control.points, shapes) {

     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     edgeShapes=shapes,
                     mode=mode)
     send(obj, list(cmd="setEdgeSourceArrowShapeRule", callback="handleResponse", status="request",
                     payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setEdgeTargetArrowColorRule', 'RCyjs',

  function (obj, attribute, control.points, colors, mode="interpolate") {

     if (!mode %in% c ('interpolate', 'lookup')) {
       write("Error! RCyjs:setEdgeTargetArrowColorRule.  mode must be 'interpolate' (the default) or 'lookup'.", stderr ())
       return ()
       }

     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     colors=colors,
                     mode=mode)
     send(obj, list(cmd="setEdgeTargetArrowColorRule", callback="handleResponse", status="request",
                     payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setEdgeSourceArrowColorRule', 'RCyjs',

  function (obj, attribute, control.points, colors, mode="interpolate") {

     if (!mode %in% c ('interpolate', 'lookup')) {
       write("Error! RCyjs:setEdgeSourceArrowColorRule.  mode must be 'interpolate' (the default) or 'lookup'.", stderr ())
       return ()
       }

     payload <- list(attribute=attribute,
                     controlPoints=control.points,
                     colors=colors,
                     mode=mode)
     send(obj, list(cmd="setEdgeSourceArrowColorRule", callback="handleResponse", status="request",
                     payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' getLayoutStrategies
#'
#' \code{getLayoutStrategies} return a list of those currently offered
#'
#' @rdname getLayoutStrategies
#' @aliases getLayoutStrategies
#'
#' @param obj  an RCyjs instance
#'
#' @return a list of character strings
#'
#' @export
#'
#' @examples
#'
#'

setMethod('getLayoutStrategies', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="getLayoutStrategies", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('layout', 'RCyjs',

  function (obj, strategy="random") {
     send(obj, list(cmd="doLayout", callback="handleResponse", status="request",
                                  payload=strategy))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('layoutSelectionInGrid', 'RCyjs',

   function(obj, x, y, w, h){
     payload <- list(x=x, y=y, w=w, h=h)
     send(obj, list(cmd="layoutSelectionInGrid", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)

     })

#----------------------------------------------------------------------------------------------------
# anchor (the top left) of the grid is the location of the topmost/leftmost node
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('layoutSelectionInGridInferAnchor', 'RCyjs',

   function(obj, w, h){
     payload <- list(w=w, h=h)
     send(obj, list(cmd="layoutSelectionInGridInferAnchor", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)

     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('getPosition', 'RCyjs',

  function (obj, nodeIDs=NA) {
     if(all(is.na(nodeIDs)))
        nodeIDs <- ""
     send(obj, list(cmd="getPosition", callback="handleResponse", status="request",
                                  payload=nodeIDs))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     fromJSON(getBrowserResponse(obj))
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setPosition', 'RCyjs',

  function (obj, tbl.pos) {
     send(obj, list(cmd="setPosition", callback="handleResponse", status="request", payload=tbl.pos))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('getNodeSize', 'RCyjs',

  function (obj, nodeIDs=NA) {
     if(all(is.na(nodeIDs)))
        nodeIDs <- ""
     send(obj, list(cmd="getNodeSize", callback="handleResponse", status="request", payload=nodeIDs))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     fromJSON(getBrowserResponse(obj))
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('getLayout', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="getLayout", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     fromJSON(getBrowserResponse(obj))
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('saveLayout', 'RCyjs',

  function (obj, filename="layout.RData") {
     tbl.layout <- getPosition(obj)
     save(tbl.layout, file=filename)
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('restoreLayout', 'RCyjs',

  function (obj, filename="layout.RData") {
     tbl.layout <- NA
     load(filename)
     if(!all(is.na(tbl.layout)))
        x <- setPosition(obj, tbl.layout)
     })

#----------------------------------------------------------------------------------------------------
#' getJSON
#'
#' \code{getJSON} a JSON string from the browser, describing the graph in cytoscape.js terms
#'
#' @rdname getJSON
#' @aliases getJSON
#'
#' @param obj an RCyjs instance
#'
#' @return a JSON string
#'
#' @export
#'
#' @examples
#'   sampleGraph <- simpleDemoGraph()
#'   rcy <- RCyjs(title="getJSON example", graph=sampleGraph)
#'   s <- getJSON(rcy)
#'

setMethod('getJSON', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="getJSON", callback="handleResponse", status="request", payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('savePNG', 'RCyjs',

  function (obj, filename) {
     send(obj, list(cmd="getPNG", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     png <- getBrowserResponse(obj)
     png.parsed <- fromJSON(png)
     substr(png.parsed, 1, 30) # [1] "data:image/png;base64,iVBORw0K"
     nchar(png.parsed)  # [1] 768714
     png.parsed.headless <- substr(png.parsed, 23, nchar(png.parsed))  # chop off the uri header
     png.parsed.binary <- base64decode(png.parsed.headless)
     conn <- file(filename, "wb")
     writeBin(png.parsed.binary, conn)
     close(conn)
     })

#----------------------------------------------------------------------------------------------------
noaNames = function (graph)
{
  return (names (nodeDataDefaults (graph)))
}
#------------------------------------------------------------------------------------------------------------------------
edaNames = function (graph)
{
  return (names (edgeDataDefaults (graph)))
}
#------------------------------------------------------------------------------------------------------------------------
noa = function (graph, node.attribute.name)
{
  if (!node.attribute.name %in% noaNames (graph))
    return (NA)

  return (unlist (nodeData (graph, attr=node.attribute.name)))

} # noa
#------------------------------------------------------------------------------------------------------------------------
eda = function (graph, edge.attribute.name)
{
  if (!edge.attribute.name %in% edaNames (graph))
    return (NA)

  return (unlist (edgeData (graph, attr=edge.attribute.name)))

} # eda
#------------------------------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('fit', 'RCyjs',

  function (obj, padding=30) {
     fitContent(obj, padding);
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('fitContent', 'RCyjs',

  function (obj, padding=30) {
     send(obj, list(cmd="fit", callback="handleResponse", status="request", payload=padding))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('fitSelectedContent', 'RCyjs',

  function (obj, padding=30) {
     send(obj, list(cmd="fitSelected", callback="handleResponse", status="request", payload=padding))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('selectNodes', 'RCyjs',

  function (obj, nodeIDs) {
     send(obj, list(cmd="selectNodes", callback="handleResponse", status="request",
                    payload=nodeIDs))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('sfn', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="sfn", callback="handleResponse", status="request", payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('hideAllEdges', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="hideAllEdges", callback="handleResponse", status="request",
                    payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' showAll
#'
#' \code{showAll} show any hidden objects: nodes, edges, or both
#'
#' @rdname showAll
#' @aliases showAll
#'
#' @param obj an RCyjs instance
#' @param which a character string, either "nodes", "edges" or "both"
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="rcyjs demo", graph=g)
#'   layout(rcy, "cose")
#'   selectNodes(rcy, getNodes(rcy)$id)
#'   hideSelectedNodes(rcy)
#'   showAll(rcy, "nodes")
#'   }
#'

setMethod('showAll', 'RCyjs',

  function (obj, which="both") {
     stopifnot(which %in% c("both", "nodes", "edges"))
     payload <- list(which=which)
     send(obj, list(cmd="showAll", callback="handleResponse", status="request", payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('hideEdges', 'RCyjs',

  function (obj, edgeType) {
     send(obj, list(cmd="hideEdges", callback="handleResponse", status="request",
                    payload=edgeType))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('showEdges', 'RCyjs',

  function (obj, edgeType) {
     send(obj, list(cmd="showEdges", callback="handleResponse", status="request",
                    payload=edgeType))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('getZoom', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="getZoom", callback="handleResponse", status="request",
                    payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setZoom', 'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setZoom", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod('setBackgroundColor', 'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setBackgroundColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeSize",  'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeWidth",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeHeight",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeHeight", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeColor",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeShape",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeFontColor",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeFontColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeFontSize",  'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeFontSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeBorderWidth",  'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeBorderWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultNodeBorderColor",  'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeBorderColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeFontSize", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeFontSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeTargetArrowShape", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeTargetArrowShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeColor", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeTargetArrowColor", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeTargetArrowColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeFontSize", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeFontSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeWidth", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeLineColor", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeLineColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeFont", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeFont", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeFontWeight", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeFontWeight", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeTextOpacity", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeTextOpacity", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeLineStyle", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeLineStyle", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeOpacity", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeOpacity", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeSourceArrowColor", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeSourceArrowColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("setDefaultEdgeSourceArrowShape", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeSourceArrowShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("vAlign", "RCyjs",
   function(obj) {
     .alignSelectedNodes(obj, "vertical")
     })
#------------------------------------------------------------------------------------------------------------------------
#' title
#'
#' \code{methodName} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname methodName
#' @aliases methodname
#'
#' @param p1  some text
#' @param p2  some text
#' @param p3  some text
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#'   x <- 3 + 2
#'

setMethod("hAlign", "RCyjs",
   function(obj) {
     .alignSelectedNodes(obj, "horizontal")
     })
#------------------------------------------------------------------------------------------------------------------------
.alignSelectedNodes <- function(rcy, axis) {

   selectedNodes <- getSelectedNodes(rcy)$id
   if(length(selectedNodes) < 2){
      printf("select 2 or more nodes");
      return;
      }
    tbl.pos <- getPosition(rcy, selectedNodes)
   if(axis == "vertical"){
      x.mean <- sum(tbl.pos$x)/nrow(tbl.pos)
      tbl.pos$x <- x.mean
      }
   else{
     y.mean <- sum(tbl.pos$y)/nrow(tbl.pos)
     tbl.pos$y <- y.mean
     }
    setPosition(rcy, tbl.pos)

} # .alignSelectedNodes
#------------------------------------------------------------------------------------------------------------------------
myQP <- function(queryString)
{
   #printf("=== RCYjs-class::myQP");
   #print(queryString)
     # for reasons not quite clear, the query string comes in with extra characters
     # following the expected filename:
     #
     #  "?sampleStyle.js&_=1443650062946"
     #
     # check for that, cleanup the string, then see if the file can be found

   ampersand.loc <- as.integer(regexpr("&", queryString, fixed=TRUE))
   #printf("ampersand.loc: %d", ampersand.loc)

   if(ampersand.loc > 0){
      queryString <- substring(queryString, 1, ampersand.loc - 1);
      }

   questionMark.loc <- as.integer(regexpr("?", queryString, fixed=TRUE));
   #printf("questionMark.loc: %d", questionMark.loc)

   if(questionMark.loc == 1)
      queryString <- substring(queryString, 2, nchar(queryString))

   filename <- queryString;
   #printf("myQP filename: '%s'", filename)
   #printf("       exists?  %s", file.exists(filename));

   stopifnot(file.exists(filename))

   #printf("--- about to scan %s", filename);
      # reconstitute linefeeds though collapsing file into one string, so json
      # structure is intact, and any "//" comment tokens only affect one line
   text <- paste(scan(filename, what=character(0), sep="\n", quiet=TRUE), collapse="\n")
   #printf("%d chars read from %s", nchar(text), filename);

   return(text);

} # myQP
#----------------------------------------------------------------------------------------------------
