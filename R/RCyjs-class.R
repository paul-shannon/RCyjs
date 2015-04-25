#----------------------------------------------------------------------------------------------------
cyjsBrowserFile <- system.file(package="RCyjs", "scripts", "rcyjs.html")
#----------------------------------------------------------------------------------------------------
.RCyjs <- setClass ("RCyjsClass", 
                    representation = representation(graph="graph"),
                    contains = "BrowserVizClass",
                    prototype = prototype (uri="http://localhost", 9000)
                    )

#----------------------------------------------------------------------------------------------------
setGeneric('setGraph',            signature='obj', function(obj, graph) standardGeneric ('setGraph'))
setGeneric('addGraph',            signature='obj', function(obj, graph) standardGeneric ('addGraph'))

setGeneric('getNodes',            signature='obj', function(obj) standardGeneric ('getNodes'))
setGeneric('getSelectedNodes',    signature='obj', function(obj) standardGeneric ('getSelectedNodes'))
setGeneric('clearSelection',      signature='obj', function(obj) standardGeneric ('clearSelection'))
setGeneric('redraw',              signature='obj', function(obj) standardGeneric ('redraw'))
setGeneric('setNodeLabelRule',    signature='obj', function(obj, attribute) standardGeneric ('setNodeLabelRule'))
setGeneric('setNodeLabelAlignment',  signature='obj', function(obj, horizontal, vertical) standardGeneric ('setNodeLabelAlignment'))
setGeneric('setNodeSizeRule',     signature='obj', function(obj, attribute, control.points, node.sizes) standardGeneric('setNodeSizeRule'))
setGeneric('setNodeColorRule',    signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setNodeColorRule'))
setGeneric('setNodeShapeRule',    signature='obj', function(obj, attribute, control.points, node.shapes) standardGeneric('setNodeShapeRule'))

setGeneric('setEdgeColorRule',    signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setEdgeColorRule'))
setGeneric('setEdgeWidthRule',    signature='obj', function(obj, attribute, control.points, widths, mode) standardGeneric('setEdgeWidthRule'))

setGeneric('setEdgeTargetArrowShapeRule',   signature='obj', function(obj, attribute, control.points, shapes) standardGeneric('setEdgeTargetArrowShapeRule'))
setGeneric('setEdgeTargetArrowColorRule',   signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setEdgeTargetArrowColorRule'))

setGeneric('setEdgeSourceArrowShapeRule',   signature='obj', function(obj, attribute, control.points, shapes) standardGeneric('setEdgeSourceArrowShapeRule'))
setGeneric('setEdgeSourceArrowColorRule',   signature='obj', function(obj, attribute, control.points, colors, mode) standardGeneric('setEdgeSourceArrowColorRule'))

setGeneric('layout',              signature='obj', function(obj, strategy) standardGeneric('layout'))
setGeneric('layoutStrategies',    signature='obj', function(obj) standardGeneric('layoutStrategies'))
setGeneric('getPosition',         signature='obj', function(obj, nodeIDs=NA) standardGeneric('getPosition'))
setGeneric('setPosition',         signature='obj', function(obj, tbl.pos) standardGeneric('setPosition'))
setGeneric('getLayout',           signature='obj', function(obj) standardGeneric('getLayout'))
setGeneric('saveLayout',          signature='obj', function(obj, filename) standardGeneric('saveLayout'))
setGeneric('restoreLayout',       signature='obj', function(obj, filename) standardGeneric('restoreLayout'))
setGeneric('setZoom',             signature='obj', function(obj, newValue) standardGeneric('setZoom'))
setGeneric('getZoom',             signature='obj', function(obj) standardGeneric('getZoom'))
setGeneric('setBackgroundColor',  signature='obj', function(obj, newValue) standardGeneric ('setBackgroundColor'))
setGeneric('fitContent',          signature='obj', function(obj) standardGeneric('fitContent'))
setGeneric('fitSelectedContent',  signature='obj', function(obj) standardGeneric('fitSelectedContent'))
setGeneric('selectNodes',         signature='obj', function(obj, nodeIDs) standardGeneric('selectNodes'))
setGeneric('hideAllEdges',        signature='obj', function(obj) standardGeneric('hideAllEdges'))

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
# constructor
RCyjs = function(portRange, host="localhost", title="RCyjs", graph=graphNEL(), quiet=TRUE)
{
  
  obj <- .RCyjs(BrowserViz(portRange, host, title, quiet, browserFile=cyjsBrowserFile), graph=graph)

  while (!browserResponseReady(obj)){
      Sys.sleep(.1)
      }
   if(!quiet) {
      message(sprintf("setGraph got browser response"))
      print(getBrowserResponse(obj))
      }

   if(length(nodes(graph)) > 0)
       setGraph(obj, graph)
      
   obj

} # RCyjs: constructor
#----------------------------------------------------------------------------------------------------
setMethod('setGraph', 'RCyjsClass',

  function (obj, graph) {
     g.json <- as.character(biocGraphToCytoscapeJSON(graph))
     #printf("RCyjs.setGraph sending g.json with %d chars", nchar(g.json))
     
     send(obj, list(cmd="setGraph", callback="handleResponse", status="request",
                                  payload=g.json))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
setMethod('addGraph', 'RCyjsClass',

  function (obj, graph) {
     printf("RCyjs::addGraph");
     print(graph)
     g.json <- as.character(biocGraphToCytoscapeJSON(graph))
     printf("about to send g.json");
     send(obj, list(cmd="addGraph", callback="handleResponse", status="request",
                    payload=g.json))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     printf("browserResponseReady")
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
setMethod('getNodes', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="getNodes", callback="handleResponse", status="request",
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
setMethod('clearSelection', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="clearSelection", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     return("")
     })

#----------------------------------------------------------------------------------------------------
setMethod('getSelectedNodes', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="getSelectedNodes", callback="handleResponse", status="request",
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
setMethod('redraw', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="redraw", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
setMethod('setNodeLabelRule', 'RCyjsClass',

  function (obj, attribute) {
     send(obj, list(cmd="setNodeLabelRule", callback="handleResponse", status="request",
                                  payload=attribute))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));  # the empty string.
     })

#----------------------------------------------------------------------------------------------------
setMethod('setNodeLabelAlignment', 'RCyjsClass',

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
setMethod('setNodeSizeRule', 'RCyjsClass',

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
setMethod('setNodeColorRule', 'RCyjsClass',

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
setMethod('setNodeShapeRule', 'RCyjsClass',

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
setMethod('setEdgeColorRule', 'RCyjsClass',

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
setMethod('setEdgeWidthRule', 'RCyjsClass',

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
setMethod('setEdgeTargetArrowShapeRule', 'RCyjsClass',

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
setMethod('setEdgeSourceArrowShapeRule', 'RCyjsClass',

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
setMethod('setEdgeTargetArrowColorRule', 'RCyjsClass',

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
setMethod('setEdgeSourceArrowColorRule', 'RCyjsClass',

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
setMethod('layoutStrategies', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="layoutStrategies", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)     
     })
          
#----------------------------------------------------------------------------------------------------
setMethod('layout', 'RCyjsClass',

  function (obj, strategy="random") {
     send(obj, list(cmd="doLayout", callback="handleResponse", status="request",
                                  payload=strategy))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)     
     })
          
#----------------------------------------------------------------------------------------------------
setMethod('getPosition', 'RCyjsClass',

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
setMethod('setPosition', 'RCyjsClass',

  function (obj, tbl.pos) {
     send(obj, list(cmd="setPosition", callback="handleResponse", status="request", payload=tbl.pos))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })
          
#----------------------------------------------------------------------------------------------------
setMethod('getLayout', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="getLayout", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     fromJSON(getBrowserResponse(obj))
     })
          
#----------------------------------------------------------------------------------------------------
setMethod('saveLayout', 'RCyjsClass',

  function (obj, filename="layout.RData") {
     tbl.layout <- getPosition(obj)
     save(tbl.layout, file=filename)
     })
          
#----------------------------------------------------------------------------------------------------
setMethod('restoreLayout', 'RCyjsClass',

  function (obj, filename="layout.RData") {
     tbl.layout <- NA
     load(filename)
     if(!all(is.na(tbl.layout)))
        x <- setPosition(obj, tbl.layout)
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
setMethod('fitContent', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="fit", callback="handleResponse", status="request",
                                  payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
setMethod('selectNodes', 'RCyjsClass',

  function (obj, nodeIDs) {
     send(obj, list(cmd="selectNodes", callback="handleResponse", status="request",
                    payload=nodeIDs))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
setMethod('hideAllEdges', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="hideAllEdges", callback="handleResponse", status="request",
                    payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
setMethod('getZoom', 'RCyjsClass',

  function (obj) {
     send(obj, list(cmd="getZoom", callback="handleResponse", status="request",
                    payload=""))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
setMethod('setZoom', 'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setZoom", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
setMethod('setBackgroundColor', 'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setBackgroundColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })

#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeSize",  'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeWidth",   'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeHeight",   'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeHeight", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeColor",   'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeShape",   'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeFontColor",   'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeFontColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeFontSize",  'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeFontSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeBorderWidth",  'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeBorderWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
setMethod("setDefaultNodeBorderColor",  'RCyjsClass',

  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeBorderColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     getBrowserResponse(obj);
     })

#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeFontSize", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultNodeFontSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeTargetArrowShape", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeTargetArrowShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeColor", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeTargetArrowColor", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeTargetArrowColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeFontSize", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeFontSize", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeWidth", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeWidth", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeLineColor", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeLineColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeFont", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeFont", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeFontWeight", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeFontWeight", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeTextOpacity", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeTextOpacity", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeLineStyle", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeLineStyle", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeOpacity", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeOpacity", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeSourceArrowColor", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeSourceArrowColor", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
setMethod("setDefaultEdgeSourceArrowShape", "RCyjsClass",
  function (obj, newValue) {
     send(obj, list(cmd="setDefaultEdgeSourceArrowShape", callback="handleResponse", status="request",
                    payload=newValue))
     while (!browserResponseReady(obj)){
        Sys.sleep(.1)
        }
     invisible(getBrowserResponse(obj));    # the empty string
     })
#----------------------------------------------------------------------------------------------------
