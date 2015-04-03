library(igraph)
library(graph)
library(RJSONIO)

toCytoscape <- function (igraphobj) {
  
  # Extract graph attributes
  graph_attr = graph.attributes(igraphobj)
  
  # Extract nodes
  node_count = length(V(igraphobj))
  if('name' %in% list.vertex.attributes(igraphobj)) {
    V(igraphobj)$id <- V(igraphobj)$name
  } else {
    V(igraphobj)$id <-as.character(c(1:node_count))
  }
  
  
  nodes <- V(igraphobj)
  nds = list()
  
  v_attr = vertex.attributes(igraphobj)
  v_names = list.vertex.attributes(igraphobj)
  
  for(i in 1:node_count) {
#     node_attr = list()
#     
#     for(j in 1:length(v_attr)) {
#       node_attr[j] = v_attr[[j]][i]  
#     }
#     names(node_attr) = v_names
    nds[[i]] = list(data = mapAttributes(v_names, v_attr, i))
  }
  
  edges <- get.edgelist(igraphobj)
  edge_count = ecount(igraphobj)
  e_attr <- edge.attributes(igraphobj)
  e_names = list.edge.attributes(igraphobj)
  
  attr_exists = FALSE
  e_names_len = 0
  if(identical(e_names, character(0)) == FALSE) {
    attr_exists = TRUE
    e_names_len = length(e_names)
  }
  e_names_len <- length(e_names)
  
  eds = list()
  for(i in 1:edge_count) {
    st = list(source=toString(edges[i,1]), target=toString(edges[i,2]))
    
    # Extract attributes
    if(attr_exists) {
      eds[[i]] = list(data=c(st, mapAttributes(e_names, e_attr, i)))
    } else {
      eds[[i]] = list(data=st)
    }
  }

  el = list(nodes=nds, edges=eds)
  
  x <- list(data = graph_attr, elements = el)
  return (toJSON(x))
}

mapAttributes <- function(attr.names, all.attr, i) {
  attr = list()
  cur.attr.names = attr.names
  attr.names.length = length(attr.names)
  
  for(j in 1:attr.names.length) {
    if(is.na(all.attr[[j]][i]) == FALSE) {
#       attr[j] = all.attr[[j]][i]
      attr <- c(attr, all.attr[[j]][i])
    } else {
      cur.attr.names <- cur.attr.names[cur.attr.names != attr.names[j]]
    }
  }
  names(attr) = cur.attr.names
  return (attr)
}


send2cy <- function(cygraph, style.name, layout.name) {
  network.url = paste(base.url, "networks", sep="/")
  res <- POST(url=network.url, body=cygraph, encode="json")
  network.suid = unname(fromJSON(rawToChar(res$content)))
  print(network.suid)
  
  # Apply Visual Style
  apply.layout.url = paste(base.url, "apply/layouts", layout.name, toString(network.suid), sep="/")
  apply.style.url = paste(base.url, "apply/styles", style.name, toString(network.suid), sep="/")
  
  res <- GET(apply.layout.url)
  res <- GET(apply.style.url)
}

#----------------------------------------------------------------------------------------------------
.makeSimpleGraph = function ()
{
  g = new ('graphNEL', edgemode='directed')

  nodeDataDefaults(g, attr='type') <- 'undefined'
  nodeDataDefaults(g, attr='lfc') <-  1.0
  nodeDataDefaults(g, attr='label') <- 'default node label'
  nodeDataDefaults(g, attr='count') <-  0

  edgeDataDefaults(g, attr='edgeType') <- 'undefined'
  edgeDataDefaults(g, attr='score') <-  0.0
  edgeDataDefaults(g, attr= 'misc') <- "default misc"

  g = graph::addNode ('A', g)
  g = graph::addNode ('B', g)
  g = graph::addNode ('C', g)
  nodeData (g, 'A', 'type') = 'kinase'
  nodeData (g, 'B', 'type') = 'transcription factor'
  nodeData (g, 'C', 'type') = 'glycoprotein'

  nodeData (g, 'A', 'lfc') = -3.0
  nodeData (g, 'B', 'lfc') = 0.0
  nodeData (g, 'C', 'lfc') = 3.0

  nodeData (g, 'A', 'count') = 2
  nodeData (g, 'B', 'count') = 30
  nodeData (g, 'C', 'count') = 100

  nodeData (g, 'A', 'label') = 'Gene A'
  nodeData (g, 'B', 'label') = 'Gene B'
  nodeData (g, 'C', 'label') = 'Gene C'

  g = graph::addEdge ('A', 'B', g)
  g = graph::addEdge ('B', 'C', g)
  g = graph::addEdge ('C', 'A', g)

  edgeData (g, 'A', 'B', 'edgeType') = 'phosphorylates'
  edgeData (g, 'B', 'C', 'edgeType') = 'synthetic lethal'

  edgeData (g, 'A', 'B', 'score') =  35.0
  edgeData (g, 'B', 'C', 'score') =  -12

  g

} # .makeSimpleGraph
#----------------------------------------------------------------------------------------------------
test <- function()
{
   g <- .makeSimpleGraph()
   ig <- igraph.from.graphNEL(g)
   json.g <- toCytoscape(ig)
   f <- file("g.json")
   writeLines(json.g, f); close(f)

} # test
#----------------------------------------------------------------------------------------------------
