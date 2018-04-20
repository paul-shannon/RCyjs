#----------------------------------------------------------------------------------------------------
#' simpleDemoGraph
#'
#' @rdname simpleDemoGraph
#'
#' @return a graphNEL with 3 nodes and 3 edges
#'
#' @export
#'
#' @examples
#'   g <- simpleDemoGraph()
#'
simpleDemoGraph <- function ()
{
  g <- new ('graphNEL', edgemode='directed')

  nodeDataDefaults(g, attr='type') <- 'undefined'
  nodeDataDefaults(g, attr='lfc') <-  1.0
  nodeDataDefaults(g, attr='label') <- 'default node label'
  nodeDataDefaults(g, attr='count') <-  0

  edgeDataDefaults(g, attr='edgeType') <- 'undefined'
  edgeDataDefaults(g, attr='score') <-  0.0
  edgeDataDefaults(g, attr= 'misc') <- "default misc"

  g <- graph::addNode ('A', g)
  g <- graph::addNode ('B', g)
  g <- graph::addNode ('C', g)
  nodeData (g, 'A', 'type') <- 'kinase'
  nodeData (g, 'B', 'type') <- 'transcription factor'
  nodeData (g, 'C', 'type') <- 'glycoprotein'

  nodeData (g, 'A', 'lfc') <- -3.0
  nodeData (g, 'B', 'lfc') <- 0.0
  nodeData (g, 'C', 'lfc') <- 3.0

  nodeData (g, 'A', 'count') <- 2
  nodeData (g, 'B', 'count') <- 30
  nodeData (g, 'C', 'count') <- 100

  nodeData (g, 'A', 'label') <- 'Gene A'
  nodeData (g, 'B', 'label') <- 'Gene B'
  nodeData (g, 'C', 'label') <- 'Gene C'

  g <- graph::addEdge ('A', 'B', g)
  g <- graph::addEdge ('B', 'C', g)
  g <- graph::addEdge ('C', 'A', g)

  edgeData (g, 'A', 'B', 'edgeType') <- 'phosphorylates'
  edgeData (g, 'B', 'C', 'edgeType') <- 'synthetic lethal'

  edgeData (g, 'A', 'B', 'score') <-  35.0
  edgeData (g, 'B', 'C', 'score') <-  -12

  g

} # simpleDemoGraph
#----------------------------------------------------------------------------------------------------
#' createTestGraph
#'
#' \code{createTestGraph} With as many nodes and edges as you wish, but neither edge nor node attributes.
#'
#' @rdname createTestGaph
#'
#' @param nodeCount 1 or more
#' @param edgeCount 0 or more
#'
#' @return a graphNEL with \code{nodeCount} nodes and \code{edgeCount} edges
#'
#' @export
#'
#' @examples
#'   g <- createTestGraph(5, 3)
#'
createTestGraph <- function(nodeCount, edgeCount)
{
   elementCount <- nodeCount^2;
   vec <- rep(0, elementCount)

   set.seed(13);
   vec[sample(1:elementCount, edgeCount)] <- 1
   mtx <- matrix(vec, nrow=nodeCount)

   gam <- graphAM(adjMat=mtx, edgemode="directed")

   g <- as(gam, "graphNEL")
   edgeDataDefaults(g, attr="edgeType") <- "testEdges"
   nodeDataDefaults(g, attr="nodeType") <- "testNodes"

   g

} # createTestGraph
#----------------------------------------------------------------------------------------------------
# biocGraphToCytoscapeJSON <- function (graph) {
#
#   igraphobj <- igraph::igraph.from.graphNEL(graph)
#
#
#   # Extract graph attributes
#   graph_attr <- graph.attributes(igraphobj)
#
#   # Extract nodes
#   node_count <- length(V(igraphobj))
#   if('name' %in% list.vertex.attributes(igraphobj)) {
#     V(igraphobj)$id <- V(igraphobj)$name
#   } else {
#     V(igraphobj)$id <-as.character(c(1:node_count))
#   }
#
#
#   nodes <- V(igraphobj)
#   nds <- list()
#
#   v_attr <- vertex.attributes(igraphobj)
#   v_names <- list.vertex.attributes(igraphobj)
#
#
#   for(i in seq_len(node_count)){   #   1:node_count) {
#     nds[[i]] <- list(data = mapAttributes(v_names, v_attr, i))
#     }
#
#   edges <- get.edgelist(igraphobj)
#   edge_count <- ecount(igraphobj)
#   e_attr <- edge.attributes(igraphobj)
#   e_names <- list.edge.attributes(igraphobj)
#
#   attr_exists <- FALSE
#   e_names_len <- 0
#   if(identical(e_names, character(0)) == FALSE) {
#     attr_exists <- TRUE
#     e_names_len <- length(e_names)
#     }
#   e_names_len <- length(e_names)
#
#   eds <- list()
#   if(edge_count > 0){
#     for(i in 1:edge_count) {
#        st <- list(source=toString(edges[i,1]), target=toString(edges[i,2]))
#
#     # Extract attributes
#      if(attr_exists) {
#        eds[[i]] <- list(data=c(st, mapAttributes(e_names, e_attr, i)))
#       } else {
#       eds[[i]] <- list(data=st)
#       }
#     }
#    } # if edge_count > 0
#
#   el <- list(nodes=nds, edges=eds)
#
#   x <- list(data = graph_attr, elements = el)
#   return (toJSON(x))
#
# } # biocGraphToCytoscapeJSON
# #----------------------------------------------------------------------------------------------------
# mapAttributes <- function(attr.names, all.attr, i)
# {
#   attr <- list()
#   cur.attr.names <- attr.names
#   attr.names.length <- length(attr.names)
#
#   for(j in 1:attr.names.length) {
#     if(is.na(all.attr[[j]][i]) == FALSE) {
#       attr <- c(attr, all.attr[[j]][i])
#       }
#     else {
#       cur.attr.names <- cur.attr.names[cur.attr.names != attr.names[j]]
#       }
#     } # for j
#
#   names(attr) <- cur.attr.names
#   return (attr)
#
# } # mapAttributes
#----------------------------------------------------------------------------------------------------
# the basic form
#
#   network =  {"nodes":[{"data":{"id":"o"},"position":{"x":779.5, "y":500 }}],
#               "edges":[{"data":{"source":"o","target":"o","id":"e1"}}]};
#
.graphToJSON <- function(g)
{
   if(length(nodes(g)) == 0)
      return ("{}")

       # allocate more character vectors that we could ever need; unused are deleted at conclusion

    vector.count <- 10 * (length(edgeNames(g)) + length (nodes(g)))
    vec <- vector(mode="character", length=vector.count)
    i <- 1;

    vec[i] <- '{"elements": {"nodes": ['; i <- i + 1;
    nodes <- nodes(g)
    edgeNames <- edgeNames(g)
    edges <- strsplit(edgeNames, "~")  # a list of pairs
    edgeNames <- sub("~", "->", edgeNames)
    names(edges) <- edgeNames

    noa.names <- names(graph::nodeDataDefaults(g))
    eda.names <- names(graph::edgeDataDefaults(g))
    nodeCount <- length(nodes)
    edgeCount <- length(edgeNames)

    for(n in 1:nodeCount){
       node <- nodes[n]
       vec[i] <- '{"data": '; i <- i + 1
       nodeList <- list(id = node)
       this.nodes.data <- graph::nodeData(g, node)[[1]]
       if(length(this.nodes.data) > 0)
          nodeList <- c(nodeList, this.nodes.data)
       nodeList.json <- toJSON(nodeList, auto_unbox=TRUE)
       vec[i] <- nodeList.json; i <- i + 1
       if(all(c("xPos", "yPos") %in% names(graph::nodeDataDefaults(g)))){
          position.markup <- sprintf(', "position": {"x": %f, "y": %f}',
                                     graph::nodeData(g, node, "xPos")[[1]],
                                     graph::nodeData(g, node, "yPos")[[1]])
          vec[i] <- position.markup
          i <- i + 1
          }
        if(n != nodeCount){
           vec [i] <- "},"; i <- i + 1 # sprintf("%s},", x)  # another node coming, add a comma
           }
       } # for n

    vec [i] <- "}]"; i <- i + 1  # close off the last node, the node array ], the nodes element }

    if(edgeCount > 0){
       vec[i] <- ', "edges": [' ; i <- i + 1
       for(e in seq_len(edgeCount)) {
          vec[i] <- '{"data": '; i <- i + 1
          edgeName <- edgeNames[e]
          edge <- edges[[e]]
          sourceNode <- edge[[1]]
          targetNode <- edge[[2]]
          edgeList <- list(id=edgeName, source=sourceNode, target=targetNode)
          this.edges.data <- edgeData(g, sourceNode, targetNode)[[1]]
          if(length(this.edges.data) > 0)
             edgeList <- c(edgeList, this.edges.data)
          edgeList.json <- toJSON(edgeList, auto_unbox=TRUE)
          vec[i] <- edgeList.json; i <- i + 1
          if(e != edgeCount){          # add a comma, ready for the next edge element
             vec [i] <- '},'; i <- i + 1
             }
          } # for e
      vec [i] <- "}]"; i <- i + 1
      } # if edgeCount > 0

   vec [i] <- "}"  # close the edges object
   i <- i + 1;
   vec [i] <- "}"  # close the elements object
   vec.trimmed <- vec [which(vec != "")]
   #printf("%d strings used in constructing json", length(vec.trimmed))
   paste0(vec.trimmed, collapse=" ")

} # .graphToJSON
#------------------------------------------------------------------------------------------------------------------------
