#' @importFrom methods new is as
#' @import BiocGenerics
#' @import httpuv
#' @import BrowserViz
#' @import graph
#' @importFrom utils write.table
#' @importFrom base64enc base64decode
#'
#' @name RCyjs-class
#' @rdname RCyjs-class
#' @exportClass RCyjs

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


setGeneric("setNodeSize",  signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeSize'))
setGeneric("setNodeWidth", signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeWidth'))
setGeneric("setNodeHeight", signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeHeight'))
setGeneric("setNodeColor", signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeColor'))
setGeneric("setNodeShape", signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeShape'))
setGeneric("setNodeFontColor", signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeFontColor'))
setGeneric("setNodeFontSize", signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeFontSize'))
setGeneric("setNodeBorderWidth", signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeBorderWidth'))
setGeneric("setNodeBorderColor", signature='obj', function(obj, nodeIDs, newValues) standardGeneric('setNodeBorderColor'))

setGeneric('setNodeLabelRule',    signature='obj', function(obj, attribute) standardGeneric ('setNodeLabelRule'))
setGeneric('setNodeLabelAlignment',  signature='obj', function(obj, horizontal, vertical) standardGeneric ('setNodeLabelAlignment'))
setGeneric('setNodeSizeRule',     signature='obj', function(obj, attribute, control.points, node.sizes) standardGeneric('setNodeSizeRule'))
setGeneric('setNodeColorRule',    signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setNodeColorRule'))
setGeneric('setEdgeStyle',        signature='obj', function(obj, mode) standardGeneric('setEdgeStyle'))

setGeneric('layout',                 signature='obj', function(obj, strategy="random") standardGeneric('layout'))
setGeneric('getSupportedNodeShapes',  signature='obj', function(obj) standardGeneric('getSupportedNodeShapes'))
setGeneric('getSupportedEdgeDecoratorShapes',  signature='obj', function(obj) standardGeneric('getSupportedEdgeDecoratorShapes'))
setGeneric('getLayoutStrategies',    signature='obj', function(obj) standardGeneric('getLayoutStrategies'))
setGeneric('layoutSelectionInGrid',  signature='obj', function(obj, x, y, w, h) standardGeneric('layoutSelectionInGrid'))
setGeneric('layoutSelectionInGridInferAnchor', signature='obj', function(obj, w, h) standardGeneric('layoutSelectionInGridInferAnchor'))
setGeneric('getPosition',         signature='obj', function(obj, nodeIDs=NA) standardGeneric('getPosition'))
setGeneric('setPosition',         signature='obj', function(obj, tbl.pos) standardGeneric('setPosition'))
setGeneric('getNodeSize',         signature='obj', function(obj, nodeIDs=NA) standardGeneric('getNodeSize'))
setGeneric('saveLayout',          signature='obj', function(obj, filename) standardGeneric('saveLayout'))
setGeneric('getJSON',             signature='obj', function(obj) standardGeneric('getJSON'))
setGeneric('savePNG',             signature='obj', function(obj, filename) standardGeneric('savePNG'))
setGeneric('saveJPG',             signature='obj', function(obj, filename, resolutionFactor=1) standardGeneric('saveJPG'))
#setGeneric('saveAsWebPage',       signature='obj', function(obj, filename) standardGeneric('saveAsWebPage'))
setGeneric('restoreLayout',       signature='obj', function(obj, filename) standardGeneric('restoreLayout'))
setGeneric('setZoom',             signature='obj', function(obj, newValue) standardGeneric('setZoom'))
setGeneric('getZoom',             signature='obj', function(obj) standardGeneric('getZoom'))
setGeneric('setBackgroundColor',  signature='obj', function(obj, newValue) standardGeneric ('setBackgroundColor'))
setGeneric('fit',                 signature='obj', function(obj, padding=30) standardGeneric('fit'))
setGeneric('fitSelection',        signature='obj', function(obj, padding=30) standardGeneric('fitSelection'))
setGeneric('selectNodes',         signature='obj', function(obj, nodeIDs) standardGeneric('selectNodes'))
setGeneric('sfn',                 signature='obj', function(obj) standardGeneric('sfn'))
setGeneric('selectFirstNeighborsOfSelectedNodes',  signature='obj', function(obj) standardGeneric('selectFirstNeighborsOfSelectedNodes'))

setGeneric('hideAllEdges',        signature='obj', function(obj) standardGeneric('hideAllEdges'))
setGeneric('showAll',             signature='obj', function(obj, which="both") standardGeneric('showAll'))
setGeneric('hideEdges',           signature='obj', function(obj, edgeType) standardGeneric('hideEdges'))
setGeneric('showEdges',           signature='obj', function(obj, edgeType) standardGeneric('showEdges'))
setGeneric('vAlign',              signature='obj', function(obj) standardGeneric('vAlign'))
setGeneric('hAlign',              signature='obj', function(obj) standardGeneric('hAlign'))

#setGeneric("setNodeImage", signature='obj', function(obj, imageURLs) standardGeneric('setNodeImage'))

#----------------------------------------------------------------------------------------------------
#' Create an RCyjs object
#'
#' @description
#' The RCyjs class provides an R interface to cytoscape.js, a rich, interactive, full-featured, javascript
#' network (graph) library.  One constructs an RCyjs instance on a specified port (default 9000),
#' the browser code is loaded, and a websocket connection opened.
#'
#' @rdname RCyjs-class
#'
#' @param portRange The constructor looks for a free websocket port in this range.  16000:16100 by default
#' @param title Used for the web browser window, "RCyjs" by default
#' @param graph a Biocondcutor graphNEL object
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
RCyjs = function(portRange=16000:16100, title="RCyjs", graph=graphNEL(), quiet=TRUE)
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
#' @references \url{https://js.cytoscape.org/#style}
#'
#' Though we provide access to individual styling rules (see below) we often find
#' it convenient to express all aspects of a visual style in a single JSON file
#'
#' @rdname loadStyleFile
#' @aliases loadStyleFile
#'
#' @param obj an RCyjs instance
#' @param filename contains json in the proper cytoscape.js format
#'
#' @return nothing
#'
#' @export
#'
#' @examples
#' if(interactive()){
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
#' @return no return value
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
#' deleteSelectedNodes
#'
#' \code{deleteSelectedNodes} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname deleteSelectedNodes
#' @aliases deleteSelectedNodes
#'
#' @param obj  an RCyjs instance
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    target <- nodes(g)[1]
#'    selectNodes(rcy, target)
#'    deleteSelectedNodes(rcy)
#'    }
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
#' setNodeSizeRule
#'
#' \code{setNodeSizeRule} control node size via values of the specified attribute
#'
#' actual node sizes are interpolated via the specified relationship of control.points node.sizes
#'
#' @rdname setNodeSizeRule
#' @aliases setNodeSizeRule
#'
#' @param obj an RCyjs instance
#' @param attribute a character string, the node attribute category whose value controls size
#' @param control.points a list of values of the attribute
#' @param node.sizes the corresponding node size, one specified for each of the control.points
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    setNodeSizeRule(rcy, "count", c(0, 30, 110), c(20, 50, 100));
#'    redraw(rcy)
#'    }
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
#' setNodeColorRule
#'
#' \code{setNodeColorRule} control node color via values of the specified attribute
#'
#' for interpolate mode, in which the node attribute should be a continusously varying numerical quantity
#' in-between colors are calculated for in-between values.
#' for lookup mode, in which the node attribute is a discrete string variable, simple color lookup is performed.
#'
#' @rdname setNodeColorRule
#' @aliases setNodeColorRule
#'
#' @param obj an RCyjs instance
#' @param attribute a character string, the node attribute category whose value controls color
#' @param control.points a list of all possible values of the attribute
#' @param colors the corresponding node color, one specified for each of the control.points
#' @param mode a character string, either "interpolate" or "lookup"
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    setNodeColorRule(rcy, "count", c(0, 100), c("green", "red"), mode="interpolate")
#'    redraw(rcy)
#'    }
#'
setMethod('setNodeColorRule', 'RCyjs',

  function (obj, attribute, control.points, colors, mode=c("interpolate", "lookup")) {

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
#' setEdgeStyle
#'
#' \code{setEdgeStyle} plain & fast (haystack) vs fancy & slower (bezier)
#'
#' cytoscape.js offers two kinds of edge rendering - a tradeoff in richess and speed
#' edge target decorations (arrows, tee, etc) are only rendered with the "bezier" style
#'
#' @rdname setEdgeStyle
#' @aliases setEdgeStyle
#'
#' @param obj an RCyjs instance
#' @param mode  a character string, either "bezier" or "haystack"
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"))
#'    setEdgeStyle(rcy, "bezier")
#'    redraw(rcy)
#'    }
#'
setMethod('setEdgeStyle', 'RCyjs',

  function (obj, mode=c("bezier", "haystack")) {

     payload <- mode
     send(obj, list(cmd="setEdgeStyle", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
#' setNodeAttributes
#'
#' \code{setNodeAttributes} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname setNodeAttributes
#' @aliases setNodeAttributes
#'
#' @param obj  an RCyjs instance
#' @param attribute a character string
#' @param nodes  character strings - node ids
#' @param values scalar values, all of one type (all numeric, or all character, or all integer, ...)
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    setNodeAttributes(rcy, "lfc", c("A", "B", "C"), c(0, 0, 0))
#'    redraw(rcy)
#'    }
#'
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
#' setEdgeAttributes
#'
#' \code{setEdgeAttributes} on the graph in the browse
#'
#' Edges are specified by sourceNode/targetNode/edgeType triples.
#'
#' @rdname setEdgeAttributes
#' @aliases setEdgeAttributes
#'
#' @param obj  an RCyjs instance
#' @param attribute a character string
#' @param sourceNodes vector of character strings
#' @param targetNodes  vector of character strings
#' @param edgeTypes vector of character strings
#' @param values  vector of character strings
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"));
#'    setEdgeAttributes(rcy, attribute="score",
#'                      sourceNodes=c("A", "B", "C"),
#'                      targetNodes=c("B", "C", "A"),
#'                      edgeTypes=c("phosphorylates", "synthetic lethal", "undefined"),
#'                      values=c(0, 0, 0))
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
#' redraw
#'
#' \code{redraw} re-render the graph, using the latest style rules and assignements
#'
#' @rdname redraw
#' @aliases redraw
#'
#' @param obj an RCyjs instance
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    setNodeAttributes(rcy, "lfc", c("A", "B", "C"), c(0, 0, 0))
#'    redraw(rcy)
#'    }
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
#' setDefaultNodeSize
#'
#' \code{setDefaultNodeSize} set all nodes to the same specifed size, in pixels
#'
#' @rdname setDefaultNodeSize
#' @aliases setDefaultNodeSize
#'
#' @param obj an RCyjs instance
#' @param newValue a numeric, in pixels
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodesSize", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeSize(rcy, 80)
#'   }
#'
setMethod("setDefaultNodeSize",  'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setGlobalNodeSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' setDefaultNodeWidth
#'
#' \code{setDefaultNodeWidth} set all nodes to the same specifed width, in pixels
#'
#' @rdname setDefaultNodeWidth
#' @aliases setDefaultNodeWidth
#'
#' @param obj an RCyjs instance
#' @param newValue a numeric, in pixels
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodesWidth", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeWidth(rcy, 80)
#'   }
#'
setMethod("setDefaultNodeWidth",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setGlobalNodeWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })

#----------------------------------------------------------------------------------------------------
#' setNodeWidth
#'
#' \code{setNodeWidth} set the specified nodes to the specifed widths, in pixels
#'
#' @rdname setNodeWidth
#' @aliases setNodeWidth
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues a numeric, in pixels (one, or as many as there are nodeIDs)
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodesWidth", graph=g)
#'   layout(rcy, "cose")
#'   setNodeWidth(rcy, 80)
#'   }
#'
setMethod("setNodeWidth",   'RCyjs',

  function (obj, nodeIDs, newValues) {
       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeWidth", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })

#----------------------------------------------------------------------------------------------------
#' setNodeHeight
#'
#' \code{setNodeHeight} set the specified nodes to the specifed heights, in pixels
#'
#' @rdname setNodeHeight
#' @aliases setNodeHeight
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues a numeric, in pixels (one, or as many as there are nodeIDs)
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodesHeight", graph=g)
#'   layout(rcy, "cose")
#'   setNodeHeight(rcy, 80)
#'   }
#'
setMethod("setNodeHeight",   'RCyjs',

  function (obj, nodeIDs, newValues) {
       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeHeight", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })

#----------------------------------------------------------------------------------------------------
#' setNodeSize
#'
#' \code{setNodeSize} set the specified nodes to the specifed sizes, in pixels
#'
#' @rdname setNodeSize
#' @aliases setNodeSize
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues a numeric, in pixels (one, or as many as there are nodeIDs)
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodesSize", graph=g)
#'   layout(rcy, "cose")
#'   setNodeSize(rcy, 80)
#'   }
#'
setMethod("setNodeSize",   'RCyjs',

  function (obj, nodeIDs, newValues) {
       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeSize", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })

#----------------------------------------------------------------------------------------------------
#' setNodeColor
#'
#' \code{setNodeColor} set the specified nodes to the specifed color
#'
#' @rdname setNodeColor
#' @aliases setNodeColor
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues a character string, legal CSS color names (one or more)
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodeColor", graph=g)
#'   layout(rcy, "cose")
#'   setNodeColor(rcy, 80)
#'   }
#'
setMethod("setNodeColor",   'RCyjs',

  function (obj, nodeIDs, newValues) {
       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeColor", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })

#----------------------------------------------------------------------------------------------------
#' setNodeShape
#'
#' \code{setNodeShape} set the specified nodes to specifed shapes
#'
#' @rdname setNodeShape
#' @aliases setNodeShape
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues a character string, one of the legitimate cytoscape.js node shapes
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodeShape", graph=g)
#'   layout(rcy, "cose")
#'   setNodeShape(rcy, 80)
#'   }
#'
setMethod("setNodeShape", "RCyjs",

  function (obj, nodeIDs, newValues) {

     if(!(all(newValues %in% getSupportedNodeShapes(obj))))
        stop(sprintf("unrecognized shapes: %s",
                     paste(setdiff(newValues, getSupportedNodeShapes(obj)), collapse=",")))

       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeShape", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })

#----------------------------------------------------------------------------------------------------
#' setNodeFontColor
#'
#' \code{setNodeFontColor} set the specified nodes to the same specifed node font color
#'
#' @rdname setNodeFontColor
#' @aliases setNodeFontColor
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues a character string, a legal CSS color name (one or more)
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodeFontColor", graph=g)
#'   layout(rcy, "cose")
#'   setNodeFontColor(rcy, "red")
#'   }
#'
setMethod("setNodeFontColor", "RCyjs",

   function (obj, nodeIDs, newValues) {
       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeFontColor", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })

#----------------------------------------------------------------------------------------------------
#' setNodeFontSize
#'
#' \code{setNodeFontSize} set the specified nodes to the same specifed node font size
#'
#' @rdname setNodeFontSize
#' @aliases setNodeFontSize
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues a numeric, in pixels (one, or as many as there are nodeIDs)
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodeFontSize", graph=g)
#'   layout(rcy, "cose")
#'   setNodeFontSize(rcy, 5)
#'   }
#'
setMethod("setNodeFontSize", "RCyjs",

  function (obj, nodeIDs, newValues) {
       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeFontSize", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })


#----------------------------------------------------------------------------------------------------
#' setNodeBorderWidth
#'
#' \code{setNodeBorderWidth} set the specified nodes to the same specifed node border width, in pixels
#'
#' @rdname setNodeBorderWidth
#' @aliases setNodeBorderWidth
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues numeric, in pixels (one, or as many as there are nodeIDs)
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodeBorderWidth", graph=g)
#'   layout(rcy, "cose")
#'   setNodeBorderWidth(rcy, 3)
#'   }
#'
setMethod("setNodeBorderWidth", "RCyjs",


  function (obj, nodeIDs, newValues) {
       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeBorderWidth", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })


#----------------------------------------------------------------------------------------------------
#' setNodeBorderColor
#'
#' \code{setNodeBorderColor} set the specified nodes to the specifed node border color
#'
#' @rdname setNodeBorderColor
#' @aliases setNodeBorderColor
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a character string (one or more)
#' @param newValues legal CSS color names (one or more)
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setNodeBorderColor", graph=g)
#'   layout(rcy, "cose")
#'   setNodeBorderColor(rcy, "green")
#'   }
#'
setMethod("setNodeBorderColor", "RCyjs",


  function (obj, nodeIDs, newValues) {
       # allow for many nodes, 1 value - in an unnuanced way
     node.count <- length(nodeIDs)
     value.count <- length(newValues)
     if(value.count < node.count)
        newValues <- rep(newValues[1], node.count)

     payload <- list(nodes=nodeIDs, values=newValues)
     send(obj, list(cmd="setNodeBorderColor", callback="handleResponse", status="request",
                    payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })


#----------------------------------------------------------------------------------------------------
#' setDefaultNodeHeight
#'
#' \code{setDefaultNodeHeight} set all nodes to the same specifed width, in pixels
#'
#' @rdname setDefaultNodeHeight
#' @aliases setDefaultNodeHeight
#'
#' @param obj an RCyjs instance
#' @param newValue a numeric, in pixels
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodeHeight", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeHeight(rcy, 80)
#'   }
#'
setMethod("setDefaultNodeHeight",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setGlobalNodeHeight", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' setDefaultNodeColor
#'
#' \code{setDefaultNodeColor} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname setDefaultNodeColor
#' @aliases setDefaultNodeColor
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, any valid CSS color name
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodeColor", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeColor(rcy, "lightblue")
#'   }
#'
setMethod("setDefaultNodeColor",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setGlobalNodeColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' setDefaultNodeShape
#'
#' \code{setDefaultNodeShape} change the shape of all nodes
#'
#' @rdname setDefaultNodeShape
#' @aliases setDefaultNodeShape
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, one of "ellipse", "triangle", "rectangle", "roundrectangle",
#'                             "bottomroundrectangle","cutrectangle", "barrel",
#'                             "rhomboid", "diamond", "pentagon", "hexagon",
#'                             "concavehexagon", "heptagon", "octagon", "star", "tag", "vee"
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodeShape", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeShape(rcy, "barrel")
#'   }
#'

setMethod("setDefaultNodeShape",   'RCyjs',

  function (obj, newValue=c("ellipse", "triangle", "rectangle", "roundrectangle",
               "bottomroundrectangle","cutrectangle", "barrel",
               "rhomboid", "diamond", "pentagon", "hexagon",
               "concavehexagon", "heptagon", "octagon", "star", "tag", "vee")){

     send(obj, list(cmd="setGlobalNodeShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' setDefaultNodeFontColor
#'
#' \code{setDefaultNodeFontColor}
#'
#' @rdname setDefaultNodeFontColor
#' @aliases setDefaultNodeFontColor
#'
#' @param obj an RCyjs instance
#' @param newValue any CSS color
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodeColor", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeFontColor(rcy, "red")
#'   }
#'

setMethod("setDefaultNodeFontColor",   'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setGlobalNodeFontColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' setDefaultNodeFontSize
#'
#' \code{setDefaultNodeFontSize} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname setDefaultNodeFontSize
#' @aliases setDefaultNodeFontSize
#'
#' @param obj an RCyjs instance
#' @param newValue numeric, in points
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodeFontSize", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeFontSize(rcy, 8)
#'   }
#'

setMethod("setDefaultNodeFontSize",  'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setGlobalNodeFontSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' setDefaultNodeBorderWidth
#'
#' \code{setDefaultNodeBorderWidth} in pixels
#'
#' @rdname setDefaultNodeBorderWidth
#' @aliases setDefaultNodeBorderWidth
#'
#' @param obj an RCyjs instance
#' @param newValue numeric, in pixels
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodeBorderWidth", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeBorderWidth(rcy, 2)
#'   }

setMethod("setDefaultNodeBorderWidth",  'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setGlobalNodeBorderWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
#' setDefaultNodeBorderColor
#'
#' \code{setDefaultNodeBorderColor} put somewhat more detailed description here
#'
#' @rdname setDefaultNodeBorderColor
#' @aliases setDefaultNodeBorderColor
#'
#' @param obj an RCyjs instance
#' @param newValue any CSS color
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodeBorderColor", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeBorderColor(rcy, "red")
#'   }
#'

setMethod("setDefaultNodeBorderColor",  'RCyjs',

  function (obj, newValue) {
     send(obj, list(cmd="setGlobalNodeBorderColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
#' setDefaultEdgeTargetArrowShape
#'
#' \code{setDefaultEdgeTargetArrowShape} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname setDefaultEdgeTargetArrowShape
#' @aliases setDefaultEdgeTargetArrowShape
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, one of "triangle", "triangle-tee", "triangle-cross", "triangle-backcurve",
#'                     "vee", "tee", "square", "circle", "diamond", "none"
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultEdgeTargetArrowShape", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultEdgeTargetArrowShape(rcy, "tee")
#'   }
#'

setMethod("setDefaultEdgeTargetArrowShape", "RCyjs",
  function(obj, newValue=c("triangle", "triangle-tee", "triangle-cross", "triangle-backcurve",
                     "vee", "tee", "square", "circle", "diamond", "none")) {
     send(obj, list(cmd="setGlobalEdgeTargetArrowShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
  })

#----------------------------------------------------------------------------------------------------
#' setDefaultEdgeColor
#'
#' \code{setDefaultEdgeColor}
#'
#' @rdname setDefaultEdgeColor
#' @aliases setDefaultEdgeColor
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, any valid CSS color
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultNodeColor", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultNodeFontColor(rcy, "red")
#'   }
#'

setMethod("setDefaultEdgeColor", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setGlobalEdgeColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' setDefaultEdgeTargetArrowColor
#'
#' \code{setDefaultEdgeTargetArrowColor}
#'
#' @rdname setDefaultEdgeTargetArrowColor
#' @aliases setDefaultEdgeTargetArrowColor
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, and valid CSS color
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultEdgeTargetArrowColor", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultEdgeTargetArrowColor(rcy, "red")
#'   }
#'

setMethod("setDefaultEdgeTargetArrowColor", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setGlobalEdgeTargetArrowColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' setDefaultEdgeWidth
#'
#' \code{setDefaultEdgeWidth} in pixels
#'
#' @rdname setDefaultEdgeWidth
#' @aliases setDefaultEdgeWidth
#'
#' @param obj an RCyjs instance
#' @param newValue a numeric
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultEdgeWidth", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultEdgeWidth(rcy, 1)
#'   }
#'

setMethod("setDefaultEdgeWidth", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setGlobalEdgeWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
     })
#----------------------------------------------------------------------------------------------------
#' setDefaultEdgeLineColor
#'
#' \code{setDefaultEdgeLineColor}
#'
#' @rdname setDefaultEdgeLineColor
#' @aliases setDefaultEdgeLineColor
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, and valid CSS color
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultEdgeLineColor", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultEdgeLineColor(rcy, "red")
#'   }
#'

setMethod("setDefaultEdgeLineColor", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setGlobalEdgeLineColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));
  })

#----------------------------------------------------------------------------------------------------
#' setDefaultEdgeLineStyle
#'
#' \code{setDefaultEdgeLineStyle} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname setDefaultEdgeLineStyle
#' @aliases setDefaultEdgeLineStyle
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, one of "solid", "dotted", or "dashed"
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultEdgeLineStyle", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultEdgeLineColor(rcy, "dashed")
#'   }
#'

setMethod("setDefaultEdgeLineStyle", "RCyjs",
  function (obj, newValue=c("solid", "dotted", "dashed")) {
     send(obj, list(cmd="setGlobalEdgeLineStyle", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' setDefaultEdgeSourceArrowColor
#'
#' \code{setDefaultEdgeSourceArrowColor}
#'
#' @rdname setDefaultEdgeSourceArrowColor
#' @aliases setDefaultEdgeSourceArrowColor
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, and valid CSS color
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultEdgeSourceArrowColor", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultEdgeSourceArrowColor(rcy, "red")
#'   }
#'

setMethod("setDefaultEdgeSourceArrowColor", "RCyjs",
  function (obj, newValue) {
     send(obj, list(cmd="setGlobalEdgeSourceArrowColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
#' setDefaultEdgeSourceArrowShape
#'
#' \code{setDefaultEdgeSourceArrowShape} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname setDefaultEdgeSourceArrowShape
#' @aliases setDefaultEdgeSourceArrowShape
#'
#' @param obj an RCyjs instance
#' @param newValue a character string, one of "triangle", "triangle-tee", "triangle-cross", "triangle-backcurve",
#'                     "vee", "tee", "square", "circle", "diamond", "none"
#'
#' @return no value returned
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="setDefaultEdgeSourceArrowShape", graph=g)
#'   layout(rcy, "cose")
#'   setDefaultEdgeSourceArrowShape(rcy, "tee")
#'   }
#'

setMethod("setDefaultEdgeSourceArrowShape", "RCyjs",
  function(obj, newValue=c("triangle", "triangle-tee", "triangle-cross", "triangle-backcurve",
                     "vee", "tee", "square", "circle", "diamond", "none")) {
     send(obj, list(cmd="setGlobalEdgeSourceArrowShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
  })

#----------------------------------------------------------------------------------------------------
#' setNodeLabelRule
#'
#' \code{setNodeLabelRule} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname setNodeLabelRule
#' @aliases setNodeLabelRule
#'
#' @param obj an RCyjs instance
#' @param attribute a character string, the node attribute to display as label
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- createTestGraph(nodeCount=20, edgeCount=20)
#'   rcy <- RCyjs(title="layouts", graph=g)
#'   setNodeLabelRule(rcy, "label");
#'   }
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
#' setNodelLabelAlignment
#'
#' \code{setNodeLabelAlignment} put somewhat more detailed description here
#'
#' multi-line description goes here with
#' continuations on subsequent lines
#' if you like
#'
#' @rdname setNodeLabelAlignment
#' @aliases setNodeLabelAlignment
#'
#' @param obj an RCyjs instance
#' @param horizontal character string
#' @param vertical character string
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"));
#'    setNodeLabelAlignment(rcy, "center", "top")

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
## #' setNodeImage
# #'
# #' \code{setNodeImage} put somewhat more detailed description here
# #'
# #' multi-line description goes here with
# #' continuations on subsequent lines
# #' if you like
# #'
# #' @rdname setNodeImage
# #' @aliases setNodeImage
# #'
# #' @param obj an RCyjs instance
# #' @param imageURLs  a vector of character strings
# #'
# #' @return explain what the method returns
# #'
# #' @export
# #'
# #' @examples
# #'   x <- 3 + 2
# #'
#
# setMethod('setNodeImage', 'RCyjs',
#
#   function (obj, imageURLs) {
#      recognizedNodes <- intersect(names(imageURLs), nodes(obj@graph))
#      send(obj, list(cmd="setNodeImage", callback="handleResponse", status="request",
#                                   payload=imageURLs))
#      while (!browserResponseReady(obj)){
#         Sys.sleep(.1)
#         }
#      invisible(getBrowserResponse(obj));  # the empty string.
#      })
#
#----------------------------------------------------------------------------------------------------
#' getSupportedNodeShapes
#'
#' \code{getSupportedNodeShapes} return a list of those currently offered
#'
#' @rdname getSupportedNodeShapes
#' @aliases getSupportedNodeShapes
#'
#' @param obj  an RCyjs instance
#'
#' @return a list of character strings
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- createTestGraph(nodeCount=20, edgeCount=20)
#'   rcy <- RCyjs(title="shapes", graph=g)
#'   shapes <- getSupportedNodeShapes(rcy)
#'   }
#'
setMethod('getSupportedNodeShapes',  "RCyjs",
          function(obj){
             c("ellipse", "triangle", "rectangle", "roundrectangle",
               "bottomroundrectangle","cutrectangle", "barrel",
               "rhomboid", "diamond", "pentagon", "hexagon",
               "concavehexagon", "heptagon", "octagon", "star", "tag", "vee")
          })

#----------------------------------------------------------------------------------------------------
#' getSupportedEdgeDecoratorShapes
#'
#' \code{getSupportedEdgeDecoratorShapes} return a list of those currently offered
#'
#' @rdname getSupportedEdgeDecoratorShapes
#' @aliases getSupportedEdgeDecoratorShapes
#'
#' @param obj  an RCyjs instance
#'
#' @return a list of character strings
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- createTestGraph(nodeCount=20, edgeCount=20)
#'   rcy <- RCyjs(title="shapes", graph=g)
#'   shapes <- getSupportedEdgeDecoratorShapes(rcy)
#'   }
#'
#'
#'
setMethod('getSupportedEdgeDecoratorShapes',  "RCyjs",
          function(obj){
             c("triangle", "triangle-tee", "triangle-cross", "triangle-backcurve",
               "vee", "tee", "square", "circle", "diamond", "none")
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
#' if(interactive()){
#'   g <- createTestGraph(nodeCount=20, edgeCount=20)
#'   rcy <- RCyjs(title="layouts", graph=g)
#'   strategies <- getLayoutStrategies(rcy)
#'   }
#'

setMethod('getLayoutStrategies', 'RCyjs',

  function (obj) {
     builtinStrategies = c("breadthfirst", "circle", "concentric", "cose", "grid", "random")
     extensionStrategies = c("cola", "dagre", "cose-bilkent")
     return(sort(c(builtinStrategies, extensionStrategies)))
     })

#----------------------------------------------------------------------------------------------------
#' layout
#'
#' \code{layout} apply a layout algorithm to the current grap
#'
#' @rdname layout
#' @aliases layout
#'
#' @param obj  an RCyjs instance
#' @param strategy  a character string, one of the supported algorithms
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- createTestGraph(nodeCount=20, edgeCount=20)
#'   rcy <- RCyjs(title="layouts", graph=g)
#'   strategies <- getLayoutStrategies(rcy)
#'   for(strategy in stategies){
#'      layout(rcy, strategy)
#'      Sys.sleep(1)
#'      }
#'   }
#'
#' @seealso \code{\link{getLayoutStrategies}}

setMethod('layout', 'RCyjs',

  function (obj, strategy="random") {
     if(!strategy %in% getLayoutStrategies(obj))
        stop(sprintf("unrecognized layout strategy: '%s'", strategy))

     send(obj, list(cmd="doLayout", callback="handleResponse", status="request", payload=strategy))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })

#----------------------------------------------------------------------------------------------------
#' layoutSelectionInGrid
#'
#' \code{layoutSelectionInGrid} arrange selected nodes in this region
#'
#' @rdname layoutSelectionInGrid
#' @aliases layoutSelectionInGrid
#'
#' @param obj an RCyjs instance
#' @param x  numeric  this will be the top left x coordinate of the grid
#' @param y  numeric  the top right
#' @param w  numeric  width of the grid
#' @param h  numeric  height of the grid
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"));
#'    selectNodes(rcy, nodes(g))
#'    layoutSelectionInGrid(rcy, -1000, 10, 100, 400)
#'    }
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
#' layoutSelectionInGridInferAnchor
#'
#' \code{layoutSelectionInGridInferAnchor} the top-most, left-most of the selected nodes is the anchor
#'
#' anchor (the top left) of the grid is the location of the topmost/leftmost node, then arrange
#' all the selected nodes in a box anchored here.
#'
#' @rdname layoutSelectionInGridInferAnchorm
#' @aliases layoutSelectionInGridInferAnchor
#'
#' @param obj  an RCyjs instance
#' @param w  numeric, the width of the grid box
#' @param h  numeric, the height of the grid box
#'
#' @return explain what the method returns
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    g <- simpleDemoGraph()
#'    rcy <- RCyjs(title="rcyjs demo", graph=g)
#'    layout(rcy, "cose")
#'    fit(rcy, 100)
#'    loadStyleFile(rcy, system.file(package="RCyjs", "extdata", "sampleStyle2.js"));
#'    selectNodes(rcy, nodes(g))
#'    layoutSelectionInGrid(rcy, -1000, 10, 100, 400)
#'    }
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
#' getPosition
#'
#' \code{getPosition} for all or specified nodes
#'
#' @rdname getPosition
#' @aliases getPosition
#'
#' @param obj an RCyjs instance
#' @param nodeIDs a vector of character strings, default NA
#'
#' @return a data.frame with "id", "x" and "y" columns
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="getPosition", graph=g)
#'   layout(rcy, "cose")
#'   tbl.pos <- getPosition(rcy)
#'   tbl.posA <- getPosition(rcy, "A")
#'   }
#'
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
#' setPosition
#'
#' \code{setPosition} of nodes by their id
#'
#' @rdname setPosition
#' @aliases setPosition
#'
#' @param obj  an RCyjs instance
#' @param tbl.pos a data.frame with three columns: id, x, y
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   rcy <- RCyjs(title="getPosition", graph=g)
#'   layout(rcy, "cose")
#'   tbl.pos <- getPosition(rcy)
#'     # shift all the nodes to the right
#'   tbl.pos$x <- tbl.pos$x + 50
#'   setPosition(rcy, tbl.pos)
#'   }
#'
#' @seealso \code{\link{getPosition}}
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
#' saveLayout
#'
#' \code{saveLayout} to a named file
#'
#' All node positions are saved to a functionally opaque RData object,
#' in a file whose name you supply.  These files are used by
#' restoreLayout.
#'
#' @rdname saveLayout
#' @aliases saveLayout
#'
#' @param obj a RCyjs instance
#' @param filename "layout.RData" by default
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    layout(rcy, "grid")
#'    saveLayout(rcy, filename="gridLayout.RData")
#'    layout(rcy, "circle")
#'    restoreLayout(rcy, "gridLayout.RData")
#'    }
#'
#' @seealso\code{\link{restoreLayout}}
#'

setMethod('saveLayout', 'RCyjs',

  function (obj, filename="layout.RData") {
     tbl.layout <- getPosition(obj)
     save(tbl.layout, file=filename)
     })

#----------------------------------------------------------------------------------------------------
#' restoreLayout
#'
#' \code{restoreLayout} restore a previously-saved layout
#'
#' @rdname restoreLayout
#' @aliases restoreLayout
#'
#' @param obj an RCyjs instance
#' @param filename  a character string, default "layout.RData"
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    layout(rcy, "grid")
#'    saveLayout(rcy, filename="gridLayout.RData")
#'    layout(rcy, "circle")
#'    restoreLayout(rcy, "gridLayout.RData")
#'    }
#'
#' @seealso\code{\link{saveLayout}}


setMethod('restoreLayout', 'RCyjs',

  function (obj, filename="layout.RData") {
     tbl.layout <- NA
     stopifnot(file.exists(filename))
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
#' if(interactive()){
#'    sampleGraph <- simpleDemoGraph()
#'    rcy <- RCyjs(title="getJSON", graph=sampleGraph)
#'    s <- getJSON(rcy)
#'    s.asList <- fromJSON(s)  # easier to inspect if you wish toa
#'    }
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
#' savePNG
#'
#' \code{savePNG} write current cytoscape view, at current resolution, to a PNG file.
#'
#' @rdname savePNG
#' @aliases savePNG
#'
#' @param obj  an RCyjs instance
#' @param filename  a character string
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="layouts", graph=createTestGraph(nodeCount=20, edgeCount=20))
#'    style.filename <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
#'    loadStyleFile(rcy, style.filename)
#'    layout(rcy, "cose")
#'    fit(rcy)
#'    filename <- tempfile(fileext=".png")
#'    savePNG(rcy, filename)
#'    }


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
#' saveJPG
#'
#' \code{saveJPG} write current cytoscape view, at current resolution, to a JPG file.
#'
#' @rdname saveJPG
#' @aliases saveJPG
#'
#' @param obj  an RCyjs instance
#' @param filename  a character string
#' @param resolutionFactor  numeric, default 1, higher values multiply resolution beyond screen dpi
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="layouts", graph=createTestGraph(nodeCount=20, edgeCount=20))
#'    style.filename <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
#'    loadStyleFile(rcy, style.filename)
#'    layout(rcy, "cose")
#'    fit(rcy)
#'    filename <- tempfile(fileext=".jpg")
#'    saveJPG(rcy, filename, resolutionFactor)
#'    }

setMethod('saveJPG', 'RCyjs',

  function (obj, filename, resolutionFactor=1) {
     payload <- list(resolutionFactor=resolutionFactor)
     send(obj, list(cmd="getJPG", callback="handleResponse", status="request",
                                  payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     jpg <- getBrowserResponse(obj)
     jpg.parsed <- fromJSON(jpg)
     substr(jpg.parsed, 1, 30) # [1] "data:image/jpg;base64,iVBORw0K"
     nchar(jpg.parsed)  # [1] 768714
     jpg.parsed.headless <- substr(jpg.parsed, 23, nchar(jpg.parsed))  # chop off the uri header
     jpg.parsed.binary <- base64decode(jpg.parsed.headless)
     conn <- file(filename, "wb")
     writeBin(jpg.parsed.binary, conn)
     close(conn)
     })

#----------------------------------------------------------------------------------------------------
## #' saveAsWebPage
## #'
## #' \code{saveAsWebPage} write current cytoscape graph and style to a standalone webpage
## #'
## #' @rdname saveAsWebPage
## #' @aliases saveAsWebPage
## #'
## #' @param obj  an RCyjs instance
## #' @param filename  a character string
## #'
## #' @return no return value
## #'
## #' @export
## #'
## #' @examples
## #' if(interactive()){
## #'    rcy <- RCyjs(title="layouts", graph=createTestGraph(nodeCount=20, edgeCount=20))
## #'    style.filename <- system.file(package="RCyjs", "extdata", "sampleStyle1.js");
## #'    loadStyleFile(rcy, style.filename)
## #'    layout(rcy, "cose")
## #'    fit(rcy)
## #'    filename <- tempfile(fileext=".html")
## #'    saveAsWebPage(rcy, filename)
## #'    }
##
## setMethod('saveAsWebPage', 'RCyjs',
##
##   function (obj, filename) {
##      payload <- list(resolutionFactor=resolutionFactor)
##      send(obj, list(cmd="getJPG", callback="handleResponse", status="request",
##                                   payload=payload))
##      while (!browserResponseReady(obj)){
##         Sys.sleep(.1)
##         }
##      jpg <- getBrowserResponse(obj)
##      jpg.parsed <- fromJSON(jpg)
##      substr(jpg.parsed, 1, 30) # [1] "data:image/jpg;base64,iVBORw0K"
##      nchar(jpg.parsed)  # [1] 768714
##      jpg.parsed.headless <- substr(jpg.parsed, 23, nchar(jpg.parsed))  # chop off the uri header
##      jpg.parsed.binary <- base64decode(jpg.parsed.headless)
##      conn <- file(filename, "wb")
##      writeBin(jpg.parsed.binary, conn)
##      close(conn)
##      })
##
#----------------------------------------------------------------------------------------------------
#' noaNames
#'
#' \code{noaNames} the names of the unique node attribute categories on the graph (not their values)
#'
#' @rdname noaNames
#' @aliases noaNames
#'
#' @param graph a graphNEL
#'
#' @return character strings, the names of the unique node attribute categories on the graph
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   noaNames(g)
#'   }
#'
noaNames <- function (graph)
{
  return(names(nodeDataDefaults(graph)))
}
#------------------------------------------------------------------------------------------------------------------------
#' edaNames
#'
#' \code{edaNames} the names of the unique edge attribute categories on the graph (not their values)
#'
#' @rdname edaNames
#' @aliases edaNames
#'
#' @param graph a graphNEL
#'
#' @return character strings, the names of the unique edge attribute categories on the graph
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   edaNames(g)
#'   }
#'
edaNames <- function (graph)
{
  return (names(edgeDataDefaults (graph)))
}
#------------------------------------------------------------------------------------------------------------------------
#' noa
#'
#' \code{noa} retrieve the node/attribute-value pairs, for the specified node attribute category
#'
#' @rdname noa
#' @aliases noa
#'
#' @param graph a graphNEL
#' @param node.attribute.name a character string
#'
#' @return character strings, the names of the unique edge attribute categories on the graph
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   noa(g, "lfc")
#'    }
#'
noa <- function (graph, node.attribute.name)
{
  if (!node.attribute.name %in% noaNames(graph))
    return (NA)

  return(unlist(nodeData (graph, attr=node.attribute.name)))

} # noa
#------------------------------------------------------------------------------------------------------------------------
#' eda
#'
#' \code{eda} retrieve the node/attribute-value pairs, for the specified node attribute category
#'
#' @rdname eda
#' @aliases eda
#'
#' @param graph a graphNEL
#' @param edge.attribute.name a character string
#'
#' @return character strings, the names of the unique edge attribute categories on the graph
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'   g <- simpleDemoGraph()
#'   edaNames(g)   # discover the attribute category names
#'   eda(g, "edgeType")
#'   eda(g, "score")
#'   }
#'
eda <- function(graph, edge.attribute.name)
{
  if (!edge.attribute.name %in% edaNames (graph))
    return (NA)

  return(unlist(edgeData(graph, attr=edge.attribute.name)))

} # eda
#------------------------------------------------------------------------------------------------------------------------
#' fit
#'
#' \code{fit} zoom in (or out) to display all nodes in the current graph
#'
#' @rdname fit
#' @aliases fit
#'
#' @param obj  an RCyjs instance
#' @param padding  numeric, in pixels
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    setZoom(rcy, 0.5)   # zoom out
#'    fit(rcy)
#'    }

setMethod('fit', 'RCyjs',

  function (obj, padding=30) {
     send(obj, list(cmd="fit", callback="handleResponse", status="request", payload=padding))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' fitSelection
#'
#' \code{fitSelection} zoom in to include only currently selected nodes
#'
#' @rdname fitSelection
#' @aliases fitSelection
#'
#' @param obj an RCyjs instance
#' @param padding numeric, in pixels
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    selectNodes(rcy, "A")
#'    fitSelection(rcy, padding=100)
#'    }



setMethod('fitSelection', 'RCyjs',

  function (obj, padding=30) {
     send(obj, list(cmd="fitSelected", callback="handleResponse", status="request", payload=padding))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' selectNodes
#'
#' \code{selectNodes} by node id
#'
#' @rdname selectNodes
#' @aliases selectNodes
#'
#' @param obj  an RCyjs instance
#' @param nodeIDs character strings
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    selectNodes(rcy, c("A", "B"))
#'    }
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
#' selectFirstNeighborsOfSelectedNodes
#'
#' \code{selectFirstNeighborsOfSelectedNodes}
#'
#' @rdname selectFirstNeighborsOfSelectedNodes
#' @aliases selectFirstNeighborsOfSelectedNodes
#'
#' @param obj  an RCyjs instance
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    selectNodes(rcy, "A")
#'    getSelectedNodes(rcy)  # just one
#'    selectFirstNeighborsOfSelectedNodes()
#'    getSelectedNodes(rcy)  # now three
#'    }
#'
setMethod('selectFirstNeighborsOfSelectedNodes', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="sfn", callback="handleResponse", status="request", payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' sfn
#'
#' \code{sfn} select first neighbors of the currently selected nodes
#'
#' @rdname sfn
#' @aliases sfn
#'
#' @param obj  an RCyjs instance
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    selectNodes(rcy, "A")
#'    getSelectedNodes(rcy)  # just one
#'    sfn()
#'    getSelectedNodes(rcy)  # now three
#'    }
#'
setMethod('sfn', 'RCyjs',

  function (obj) {
     selectFirstNeighborsOfSelectedNodes(obj)
     })

#----------------------------------------------------------------------------------------------------
#' hideAllEdges
#'
#' \code{hideAllEdges}
#'
#' @rdname hideAllEdges
#' @aliases hideAllEdges
#'
#' @param obj  an RCyjs instance
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
#'   hideAllEdges()
#'   showAll(rcy, "edges")
#'   }


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

  function (obj, which=c("both", "nodes", "edges")) {
     payload <- match.arg(which)
     send(obj, list(cmd="showAll", callback="handleResponse", status="request", payload=payload))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
#' hideEdges
#'
#' \code{hideEdges} hide all edges of the specified type
#'
#' edgeType is a crucial feature for RCyjs.  We assume it is an attribute found
#' on every edge in every graph.
#'
#' @rdname hideEdges
#' @aliases hideEdges
#'
#' @param obj an RCyjs instance
#' @param edgeType  a character string
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    getNodes(rcy)
#'    edaNames(rcy)        # includes "edgeType"
#'    eda(rcy, "edgeType")  # includes "phosphorylates"
#'    hideEdges(rcy, edgeType="phosphorylates")
#'    showEdges(rcy, edgeType="phosphorylates")
#'    }


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
#' showEdges
#'
#' \code{showEdges} if hidden, edges of the specified type will be made visible
#'
#' edgeType is a crucial feature for RCyjs.  We assume it is an attribute found
#' on every edge in every graph.
#'
#' @rdname showEdges
#' @aliases showEdges
#'
#' @param obj an RCyjs instance
#' @param edgeType  a character string
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    getNodes(rcy)
#'    edaNames(rcy)        # includes "edgeType"
#'    eda(rcy, "edgeType")  # includes "phosphorylates"
#'    hideEdges(rcy, edgeType="phosphorylates")
#'    showEdges(rcy, edgeType="phosphorylates")
#'    }
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
#' getZoom
#'
#' \code{getZoom} learn the zoom level of the current display
#'
#' @rdname getZoom
#' @aliases getZoom
#'
#' @param obj  an RCyjs instance
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    getZoom(rcy)
#'    Sys.sleep(1)
#'    setZoom(rcy, 5)
#'    getZoom(rcy)
#'    }
#'

setMethod('getZoom', 'RCyjs',

  function (obj) {
     send(obj, list(cmd="getZoom", callback="handleResponse", status="request",
                    payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })

#----------------------------------------------------------------------------------------------------
#' setZoom
#'
#' \code{setZoom} zoom in or out
#'
#' @rdname setZoom
#' @aliases setZoom
#'
#' @param obj  an RCyjs instance
#' @param newValue  numeric, typically be 0.1 (zoomed way out, nodes are small) and 10 (zoomed way in, nodes are large)
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    setZoom(rcy, 0.2)
#'    Sys.sleep(1)
#'    setZoom(rcy, 5)
#'    }
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
#' setBackgroundColor
#'
#' \code{setBackgroundColor} of the entire cytoscape.js div
#'
#' @rdname setBackgroundColor
#' @aliases setBackgroundColor
#'
#' @param obj  an RCyjs instance
#' @param newValue  a character string, any valid CSS color
#'
#' @return no return value
#'
#' @export
#'
#' @examples
#' if(interactive()){
#'    rcy <- RCyjs(title="rcyjs demo", graph=simpleDemoGraph())
#'    setBackgroundColor(rcy, "lightblue")
#'    }

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
#' vAlign
#'
#' \code{vAlign} vertically align selected nodes
#'
#' The shared x coordinate will be the mean of the x coordinates of selected nodes.
#' The y coordinates are preserved.
#'
#' @rdname vAlign
#' @aliases vAlign
#'
#' @param obj  an RCyjs instance
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
#'   selectNodes(rcy, nodes(g)[1:2])
#'   vAlign(rcy)
#'   }
#'

setMethod("vAlign", "RCyjs",
   function(obj) {
     .alignSelectedNodes(obj, "vertical")
     })
#------------------------------------------------------------------------------------------------------------------------
#' hAlign
#'
#' \code{hAlign} horizontally align selected nodes
#'
#' The shared y coordinate will be the mean of the y coordinates of selected nodes.
#' The x coordinates are preserved.
#'
#' @rdname hAlign
#' @aliases hAlign
#'
#' @param obj  an RCyjs instance
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
#'   selectNodes(rcy, nodes(g)[1:2])
#'   hAlign(rcy)
#'   }
#'
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
