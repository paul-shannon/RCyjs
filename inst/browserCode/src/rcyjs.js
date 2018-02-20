"use strict";
var cytoscape = require('cytoscape');
import css from './css/trenaviz.css';
$ = require('jquery');
require('jquery-ui-bundle');
//----------------------------------------------------------------------------------------------------
var RCyjs = (function(hub){

  var cyDiv;
  var vizmaps = [];
  var graph;

  var hub = hub;

//----------------------------------------------------------------------------------------------------
function initializeUI()
{
   cyDiv = $("#cyDiv");
   $(window).resize(handleWindowResize);
   handleWindowResize();

} // initializeUI
//----------------------------------------------------------------------------------------------------
function handleWindowResize ()
{
   cyDiv.width(0.95 * $(window).width());
   cyDiv.height(0.90 * $(window).height());

} // handleWindowResize
//--------------------------------------------------------------------------------
function addMessageHandlers()
{
   hub.addMessageHandler("setGraph",             setGraph);
   hub.addMessageHandler("setNodeAttributes",    setNodeAttributes);
   hub.addMessageHandler("setEdgeAttributes",    setEdgeAttributes);
   hub.addMessageHandler("addGraph",             addGraph);
   hub.addMessageHandler("httpAddGraph",         httpAddGraph);
   hub.addMessageHandler("httpSetStyle",         httpSetStyle);
   hub.addMessageHandler("getNodeCount",         getNodeCount);
   hub.addMessageHandler("getEdgeCount",         getEdgeCount);
   hub.addMessageHandler("getNodes",             getNodes);
   hub.addMessageHandler("getSelectedNodes",     getSelectedNodes);

   hub.addMessageHandler("setNodeLabelRule",      setNodeLabelRule);
   hub.addMessageHandler("setNodeLabelAlignment", setNodeLabelAlignment);

   hub.addMessageHandler("setNodeSizeRule",      setNodeSizeRule);
   hub.addMessageHandler("setNodeColorRule",     setNodeColorRule);
   hub.addMessageHandler("setNodeShapeRule",     setNodeShapeRule);

   hub.addMessageHandler("setEdgeColorRule",             setEdgeColorRule);
   hub.addMessageHandler("setEdgeStyle",                 setEdgeStyle);
   hub.addMessageHandler("setEdgeWidthRule",             setEdgeWidthRule);
   hub.addMessageHandler("setEdgeTargetArrowShapeRule",  setEdgeTargetArrowShapeRule);
   hub.addMessageHandler("setEdgeTargetArrowColorRule",  setEdgeTargetArrowColorRule);
   hub.addMessageHandler("setEdgeSourceArrowShapeRule",  setEdgeSourceArrowShapeRule);
   hub.addMessageHandler("setEdgeSourceArrowColorRule",  setEdgeSourceArrowColorRule);

   hub.addMessageHandler("redraw",                redraw);
   hub.addMessageHandler("fit",                   fit);
   hub.addMessageHandler("fitSelected",           fitSelected);
   hub.addMessageHandler("getZoom",               getZoom);
   hub.addMessageHandler("setZoom",               setZoom);
   hub.addMessageHandler("setBackgroundColor",    setBackgroundColor);
   hub.addMessageHandler("layoutStrategies",      layoutStrategies);
   hub.addMessageHandler("doLayout",              doLayout);
   hub.addMessageHandler("layoutSelectionInGrid", layoutSelectionInGrid);
   hub.addMessageHandler("layoutSelectionInGridInferAnchor", layoutSelectionInGridInferAnchor);

   hub.addMessageHandler("getPosition",          getPosition);
   hub.addMessageHandler("setPosition",          setPosition);
   hub.addMessageHandler("getNodeSize",          getNodeSize);
   hub.addMessageHandler("hideAllEdges",         hideAllEdges);
   hub.addMessageHandler("showAllEdges",         showAllEdges);
   hub.addMessageHandler("hideEdges",            hideEdges);
   hub.addMessageHandler("showEdges",            showEdges);
   hub.addMessageHandler("showAll",              showAll);

   hub.addMessageHandler("getJSON",              getJSON);
   hub.addMessageHandler("getPNG",               getPNG);
   hub.addMessageHandler("selectNodes",          selectNodes);
   hub.addMessageHandler("invertNodeSelection",  invertNodeSelection);
   hub.addMessageHandler("hideSelectedNodes",    hideSelectedNodes);
   hub.addMessageHandler("deleteSelectedNodes",  deleteSelectedNodes);
   hub.addMessageHandler("sfn",                  sfn);
   hub.addMessageHandler("clearSelection",       clearSelection);

   hub.addMessageHandler("setNodeImage",         setNodeImage);

   hub.addMessageHandler("setDefaultNodeColor",  setDefaultNodeColor);
   hub.addMessageHandler("setDefaultNodeShape",  setDefaultNodeShape);

   hub.addMessageHandler("setDefaultNodeSize",   setDefaultNodeSize);
   hub.addMessageHandler("setDefaultNodeWidth",  setDefaultNodeWidth);
   hub.addMessageHandler("setDefaultNodeHeight", setDefaultNodeHeight);
   hub.addMessageHandler("setDefaultNodeColor",  setDefaultNodeColor);
   hub.addMessageHandler("setDefaultNodeShape",  setDefaultNodeShape);
   hub.addMessageHandler("setDefaultNodeFontColor", setDefaultNodeFontColor);
   hub.addMessageHandler("setDefaultNodeFontSize", setDefaultNodeFontSize);
   hub.addMessageHandler("setDefaultNodeBorderWidth", setDefaultNodeBorderWidth);
   hub.addMessageHandler("setDefaultNodeBorderColor", setDefaultNodeBorderColor);

   hub.addMessageHandler("setDefaultEdgeFontSize", setDefaultEdgeFontSize);
   hub.addMessageHandler("setDefaultEdgeTargetArrowShape", setDefaultEdgeTargetArrowShape);
   hub.addMessageHandler("setDefaultEdgeColor", setDefaultEdgeColor);
   hub.addMessageHandler("setDefaultEdgeTargetArrowColor", setDefaultEdgeTargetArrowColor);
   hub.addMessageHandler("setDefaultEdgeFontSize", setDefaultEdgeFontSize);
   hub.addMessageHandler("setDefaultEdgeWidth", setDefaultEdgeWidth);
   hub.addMessageHandler("setDefaultEdgeLineColor", setDefaultEdgeLineColor);
   hub.addMessageHandler("setDefaultEdgeFont", setDefaultEdgeFont);
   hub.addMessageHandler("setDefaultEdgeFontWeight", setDefaultEdgeFontWeight);
   hub.addMessageHandler("setDefaultEdgeTextOpacity", setDefaultEdgeTextOpacity);
   hub.addMessageHandler("setDefaultEdgeLineStyle", setDefaultEdgeLineStyle);
   hub.addMessageHandler("setDefaultEdgeOpacity", setDefaultEdgeOpacity);
   hub.addMessageHandler("setDefaultEdgeSourceArrowColor", setDefaultEdgeSourceArrowColor);
   hub.addMessageHandler("setDefaultEdgeSourceArrowShape", setDefaultEdgeSourceArrowShape);

} // addMessageHandlers
//----------------------------------------------------------------------------------------------------
function redraw(msg)
{
   update();
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // redraw
//----------------------------------------------------------------------------------------------------
function fit(msg)
{
   var padding = msg.payload;
   console.log("fit, with padding " + padding);
   cy.fit(padding)
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // fit
//----------------------------------------------------------------------------------------------------
function fitSelected(msg)
{
   var selectedNodes = cy.filter('node:selected');
   var padding = msg.payload;

   if(selectedNodes.length == 0){
     status = "failure";
     payload = "no nodes currently selected"
     }
  else{
    console.log("fitSelected, with padding " + padding);
    cy.fit(selectedNodes, padding)
    status = "success";
    payload = "";
    }

  hub.send({cmd: msg.callback, status: status, callback: "", payload: payload});


} // fit
//----------------------------------------------------------------------------------------------------
function setZoom(msg)
{
   var newFactor = msg.payload
   var box = cy.extent();
   var center = {x: box.x1 + (box.w/2), y: box.y1 + (box.h/2)};
   cy.zoom({level: newFactor, position: center});
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setZoom
//----------------------------------------------------------------------------------------------------
function getZoom(msg)
{
   result = cy.zoom();
   returnMsg = {cmd: msg.callback, status: "success", callback: "", payload: result};
   console.log(returnMsg);
   hub.send(returnMsg);

} // getZoom
//----------------------------------------------------------------------------------------------------
function setBackgroundColor(msg)
{
   var newValue = msg.payload
   cyDiv.css({"background-color": newValue});
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setZoom
//----------------------------------------------------------------------------------------------------
function update()
{
   cy.style().update()

} // update
//----------------------------------------------------------------------------------------------------
function setNodeLabelRule(msg)
{
   var controllingAttribute = msg.payload;
   var valueString = "data(" + controllingAttribute + ")";
   cy.style().selector('node').css({content: valueString});
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeLabelRule
//----------------------------------------------------------------------------------------------------
function setNodeLabelAlignment(msg)
{
   var horizontalPosition = msg.payload.horizontal;
   var verticalPosition = msg.payload.vertical;
   cy.style().selector('node').css({"text-halign": horizontalPosition});
   cy.style().selector('node').css({"text-valign": verticalPosition});

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeLabelAlignment
//----------------------------------------------------------------------------------------------------
function setNodeSizeRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setNodeSizeRule: " + controllingAttribute);
   var controlPoints = msg.payload.controlPoints;
   var nodeSizes = msg.payload.nodeSizes;
   //console.log(controlPoints);
   //console.log(nodeSizes);

      // the controlPoints describe 1 or more segments, each defined by successive overlapping
      // pairs.  thus, control points of 0,1,2,3 define 3 segments >=0 <1, >= 1 <2, >= 2 <=3
      // since cyjs only allows two control points per css "mapData" call, we issue
      // as many calls as there are segments, conditioning each by first selecting the range
      //
      // example, from hypoxiaVizmap.js
      //
      //    "selector" : "node[score > 0.0][score < 12]",
      //    "css" : {
      // "background-color" : "mapData(score,0.0,12,rgb(255,255,255),rgb(255,0,0))"


      // three forms:
      // cy.style().selector("node[count<=1]").css

   var segmentCount = controlPoints.length - 1;

   for(var seg=0; seg < segmentCount; seg++){
     var minVal = controlPoints[seg];
     var maxVal = controlPoints[seg+1];
     var minSize = nodeSizes[seg];
     var maxSize = nodeSizes[seg+1];

        // on first and last segment, make sure the bounds are inclusive

     var lowerBoundOperator = " > ";
     var upperBoundOperator = " < ";
     if(seg == 0) lowerBoundOperator = " >= ";
     if(seg == (segmentCount - 1)) upperBoundOperator = " <= ";

     var selectorString = "node[" + controllingAttribute + lowerBoundOperator + minVal + "]" +
                              "[" + controllingAttribute + upperBoundOperator  + maxVal + "]";
     var mappingString = "mapData(" + controllingAttribute + "," + minVal + "," + maxVal +
                                                           "," + minSize + "," + maxSize + ")";

     cy.style().selector(selectorString).css({width: mappingString});
     cy.style().selector(selectorString).css({height: mappingString});
     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeSizeRule
//----------------------------------------------------------------------------------------------------
function setNodeColorRule(msg)
{
   var mode = msg.payload.mode;
   if(mode == "interpolate")
      setNodeColorInterpolatingRule(msg)
   else if (mode == "lookup")
      setNodeColorLookupRule(msg)
   else
      hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

} // setNodeColorRule
//----------------------------------------------------------------------------------------------------
function setNodeColorLookupRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setNodeColorRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var nodeColors = msg.payload.nodeColors;

   for(var i=0; i < states.length; i++){
     var color = nodeColors[i];
     var state = states[i];
     var selectorString = "node[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     cy.style().selector(selectorString).css({"background-color": color});
     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeColorLookupRule
//----------------------------------------------------------------------------------------------------
function setNodeColorInterpolatingRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setNodeColorRule: " + controllingAttribute);
   var controlPoints = msg.payload.controlPoints;
   var nodeColors = msg.payload.nodeColors;


      // the controlPoints describe 1 or more segments, each defined by successive overlapping
      // pairs.  thus, control points of 0,1,2,3 define 3 segments >=0 <1, >= 1 <2, >= 2 <=3
      // since cyjs only allows two control points per css "mapData" call, we issue
      // as many calls as there are segments, conditioning each by first selecting the range
      //
      // example, from hypoxiaVizmap.js
      //
      //    "selector" : "node[score > 0.0][score < 12]",
      //    "css" : {
      // "background-color" : "mapData(score,0.0,12,rgb(255,255,255),rgb(255,0,0))"


      // three forms:
      // cy.style().selector("node[count<=1]").css

   var segmentCount = controlPoints.length - 1;

   for(var seg=0; seg < segmentCount; seg++){
     var minVal = controlPoints[seg];
     var maxVal = controlPoints[seg+1];
     var startColor = nodeColors[seg];
     var endColor = nodeColors[seg+1];

        // on first and last segment, make sure the (start, end) bounds (respectively) are inclusive

     var lowerBoundOperator = " > ";
     var upperBoundOperator = " <= ";
     if(seg == 0) lowerBoundOperator = " >= ";

     var selectorString = "node[" + controllingAttribute + lowerBoundOperator + minVal + "]" +
                              "[" + controllingAttribute + upperBoundOperator  + maxVal + "]";
     var mappingString = "mapData(" + controllingAttribute + "," + minVal + "," + maxVal +
                                                           "," + startColor + "," + endColor + ")";
     console.log("selectorString: " + selectorString);
     console.log("mapping string: " + mappingString);

     cy.style().selector(selectorString).css({"background-color": mappingString});
     } // for seg


   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setNodeShapeRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setNodeShapeRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var nodeShapes = msg.payload.nodeShapes;

   for(var i=0; i < states.length; i++){
     var shape = nodeShapes[i];
     var state = states[i];
     var selectorString = "node[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString + "  shape: " + shape);
     cy.style().selector(selectorString).css({"shape": shape});
     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeShapeRule
//----------------------------------------------------------------------------------------------------
// either "haystack" for fast rendering, no arrows, or "bezier" for slow, arrows, better appearance
function setEdgeStyle(msg)
{
   var mode = msg.payload;

   if ($.inArray(mode, ["haystack", "bezier"]) < 0)
     hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

   if(mode === "haystack")
      cy.edges().style({"curve-style": "haystack"});
   else if (mode == "bezier")
      cy.edges().style({"curve-style": "bezier"});

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeStyle
//----------------------------------------------------------------------------------------------------
function setEdgeColorRule(msg)
{
   var mode = msg.payload.mode;
   if(mode === "interpolate")
      setEdgeColorInterpolatingRule(msg)
   else if (mode == "lookup")
      setEdgeColorLookupRule(msg)
   else
      hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

} // setEdgeColorRule
//----------------------------------------------------------------------------------------------------
function setEdgeColorLookupRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeColorRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var colors = msg.payload.edgeColors;

   for(var i=0; i < states.length; i++){
     var color = colors[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     cy.style().selector(selectorString).css({"line-color": color});
     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeColorLookupRule
//----------------------------------------------------------------------------------------------------
function setEdgeColorInterpolatingRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeColorRule, interpolated: " + controllingAttribute);
   var controlPoints = msg.payload.controlPoints;
   var edgeColors = msg.payload.edgeColors;


      // the controlPoints describe 1 or more segments, each defined by successive overlapping
      // pairs.  thus, control points of 0,1,2,3 define 3 segments >=0 <1, >= 1 <2, >= 2 <=3
      // since cyjs only allows two control points per css "mapData" call, we issue
      // as many calls as there are segments, conditioning each by first selecting the range
      //
      // example, from hypoxiaVizmap.js
      //
      //    "selector" : "edge[score > 0.0][score < 12]",
      //    "css" : {
      // "line-color" : "mapData(score,0.0,12,rgb(255,255,255),rgb(255,0,0))"


      // three forms:
      // cy.style().selector("edge[count<=1]").css

   var segmentCount = controlPoints.length - 1;

   for(var seg=0; seg < segmentCount; seg++){
     var minVal = controlPoints[seg];
     var maxVal = controlPoints[seg+1];
     var startColor = edgeColors[seg];
     var endColor = edgeColors[seg+1];

        // on first and last segment, make sure the (start, end) bounds (respectively) are inclusive

     var lowerBoundOperator = " > ";
     var upperBoundOperator = " <= ";
     if(seg == 0) lowerBoundOperator = " >= ";

     var selectorString = "edge[" + controllingAttribute + lowerBoundOperator + minVal + "]" +
                              "[" + controllingAttribute + upperBoundOperator  + maxVal + "]";
     var mappingString = "mapData(" + controllingAttribute + "," + minVal + "," + maxVal +
                                                           "," + startColor + "," + endColor + ")";
     console.log("selectorString: " + selectorString);
     console.log("mapping string: " + mappingString);

     cy.style().selector(selectorString).css({"line-color": mappingString});
     } // for seg


   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setEdgeWidthRule(msg)
{
   var mode = msg.payload.mode;

   if(mode === "interpolate")
      setEdgeWidthInterpolatingRule(msg)
   else if (mode == "lookup")
      setEdgeWidthLookupRule(msg)
   else
      hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

} // setEdgeWidthRule
//----------------------------------------------------------------------------------------------------
function setEdgeWidthInterpolatingRule(msg)
{
   hub.send({cmd: msg.callback, status: "not yet implemented", callback: "", payload: ""});

} // setEdgeWidthInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setEdgeWidthLookupRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeWidthLookupRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var widths = msg.payload.widths;

   for(var i=0; i < states.length; i++){
     var width = widths[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     cy.style().selector(selectorString).css({"width": width});
     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeWidthLookupRule
//----------------------------------------------------------------------------------------------------
function setEdgeTargetArrowShapeRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   var states = msg.payload.controlPoints;
   var shapes = msg.payload.edgeShapes;

   for(var i=0; i < states.length; i++){
     var shape = shapes[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     console.log("  newShape: " + shape);
     cy.style().selector(selectorString).css({"target-arrow-shape": shape});

     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeTargetArrowShapeRule
//----------------------------------------------------------------------------------------------------
function setEdgeTargetArrowColorRule(msg)
{
   var mode = msg.payload.mode;

   if(mode === "interpolate")
      setEdgeTargetArrowColorInterpolatingRule(msg)
   else if (mode == "lookup")
      setEdgeTargetArrowColorLookupRule(msg)
   else
      hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

} // setEdgeTargetArrowColorRule
//----------------------------------------------------------------------------------------------------
function setEdgeTargetArrowColorInterpolatingRule(msg)
{
   hub.send({cmd: msg.callback, status: "not yet implemented", callback: "", payload: ""});

} // setEdgeTargetArrowColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setEdgeTargetArrowColorLookupRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeTargetArrowColorLookupRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var colors = msg.payload.colors;

   for(var i=0; i < states.length; i++){
     var color = colors[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     cy.style().selector(selectorString).css({"target-arrow-color": color});
     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeTargetArrowColorLookupRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowColorInterpolatingRule(msg)
{
   hub.send({cmd: msg.callback, status: "not yet implemented", callback: "", payload: ""});

} // setEdgeSourceArrowColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowShapeRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   var states = msg.payload.controlPoints;
   var shapes = msg.payload.edgeShapes;

   for(var i=0; i < states.length; i++){
     var shape = shapes[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     console.log("  newShape: " + shape);
     cy.style().selector(selectorString).css({"source-arrow-shape": shape});
     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeSourceArrowShapeRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowColorRule(msg)
{
   var mode = msg.payload.mode;

   if(mode === "interpolate")
      setEdgeSourceArrowColorInterpolatingRule(msg)
   else if (mode == "lookup")
      setEdgeSourceArrowColorLookupRule(msg)
   else
      hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeSourceArrowColorRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowColorLookupRule(msg)
{
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeSourceArrowColorLookupRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var colors = msg.payload.colors;

   for(var i=0; i < states.length; i++){
     var color = colors[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     cy.style().selector(selectorString).css({"source-arrow-color": color});
     } // for seg

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeSourceArrowColorLookupRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowColorInterpolatingRule(msg)
{
   hub.send({cmd: msg.callback, status: "error", callback: "", payload: "not implemented yet"});

} // setEdgeSourceArrowColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function getNodeSize(msg)
{
   console.log("=== getNodeSize");
   var nodeID = msg.payload;
   var filterString = "node[id='" + nodeID + "']";
   var width = cy.filter(filterString).css("width");
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: width});

} // getNodeSize
//----------------------------------------------------------------------------------------------------
function layoutStrategies(msg)
{
   console.log("=== layoutStrategies");
   var strategies = ["random", "grid", "circle", "concentric", "breadthfirst", "cose"];
     // not yet working:   "dagre", "cola", "springy";

   console.log("== layoutStrategies hub.sending " + strategies.length + " strategies");
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: strategies});

} // layoutStragegies
//----------------------------------------------------------------------------------------------------
function doLayout(msg)
{
   console.log("=== doLayout");
   var strategy = msg.payload;
   cy.layout({name: strategy}).run()

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // doLayout
//----------------------------------------------------------------------------------------------------
function layoutSelectionInGrid(msg)
{
  var x = msg.payload.x;
  var y = msg.payload.y;
  var w = msg.payload.w
  var h = msg.payload.h

  var box = {x1: x, y1: y, w: w, h: h }

  cy.filter("node:selected").layout({ name: 'grid', boundingBox: box });

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // layoutSelectinInfGrid
//----------------------------------------------------------------------------------------------------
function layoutSelectionInGridInferAnchor(msg)
{
  var currentPan = cy.pan();
  var currentZoom = cy.zoom();

  var w = msg.payload.w
  var h = msg.payload.h

  var yCoordinates = cy.nodes("node:selected").map(function(node) {return node.position().y});
  var xCoordinates = cy.nodes("node:selected").map(function(node) {return node.position().x});

  var y = Math.min.apply(null, yCoordinates)
  var x = Math.min.apply(null, xCoordinates)

  var box = {x1: x, y1: y, w: w, h: h }

  cy.filter("node:selected").layout({ name: 'grid', boundingBox: box });
  cy.viewport({zoom: currentZoom, pan: currentPan});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // layoutSelectionInGridInferAnchor
//----------------------------------------------------------------------------------------------------
function getJSON(msg)
{
   console.log("=== getJSON");
   json = JSON.stringify(cy.json());
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: json});

} // getJSON
//----------------------------------------------------------------------------------------------------
function getPNG(msg)
{
   console.log("=== getPNG");
   var png_json = JSON.stringify(cy.png());
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: png_json});

} // getPNG
//----------------------------------------------------------------------------------------------------
function getPosition(msg)
{
   console.log("=== getPosition");
     // if payload is empty, we interpret that as "get all nodes"
   var nodeNames = msg.payload;
   var allNodes = false;
   var targetIDs = [];

   if(nodeNames.length == 0){ // either an empty string or an empty array
      allNodes = true;
      }
   else if(typeof(nodeNames) == "string")
     targetIDs = [nodeNames];
   else
     targetIDs = nodeNames;

   var filterStrings = [];

   for(var i=0; i < targetIDs.length; i++){
     var s = '[id="' + targetIDs[i] + '"]';
     filterStrings.push(s);
     } // for i

   var nodesToSelect = cy.nodes(filterStrings.join());

   if(allNodes)
      layout = JSON.stringify(cy.nodes().map(function(n){return{id: n.id(),
                                                                x: n.position().x,
                                                                y: n.position().y}}));
   else{
      layout = JSON.stringify(nodesToSelect.map(function(n){return{id: n.id(),
                                                                x: n.position().x,
                                                                y: n.position().y}}));
      } // else: subset of nodes specified

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: layout});

} // getPosition
//----------------------------------------------------------------------------------------------------
function setPosition(msg)
{
   console.log("==== setPosition");
   //console.log(msg.payload);
     // there will be 1 or more position objects, each with id, x, and y values
   var positionObjects = msg.payload;

   console.log("calling setPosition map");
   positionObjects.map(function(e){
       var tag="[id='" + e.id + "']";
       cy.$(tag).position({x: e.x, y:e.y});
       });

   /************
   for(var i=0; i < positionObjects.length; i++){
      var obj = positionObjects[i];
      var id = obj.id;
      var xPos = obj.x;
      var yPos = obj.y;
      var filterString = "[id='" + id + "']";
      //console.log(" setPosition " + id + ": " + xPos + ", " + yPos);
      cy.nodes(filterString).position({x: xPos, y: yPos});
      } // for i
    ********/
   console.log("after setPosition map");

     // create a subset of all nodes, including only those in positionObjects
   //var filterStrings = [];
   //for(var i=0; i < positionObjects.length; i++){
   //  var s = '[id="' + positionObjects[i].id + '"]';
   //  filterStrings.push(s);
   //  } // for i
   //var nodeSubset = cy.nodes(filterStrings.join());
   //console.log("rcyjs.html, setPosition(msg) setting position on nodes, count: " + nodeSubset.length);
   //console.log(JSON.stringify(nodeSubset))

   //--------------------------------------------------------------------------------
   // bug: in some cases the order of nodes in nodeSubset does not match the i indices of the positionObjects
   //--------------------------------------------------------------------------------

      // nodeSubset.positions(function(i, node){return{x: positionObjects[i].x, y: positionObjects[i].y}})
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setPosition
//----------------------------------------------------------------------------------------------------
function getNodeSize(msg)
{
   console.log("=== getNodeSize");
     // if payload is empty, we interpret that as "get all nodes"
   var nodeNames = msg.payload;
   var allNodes = false;
   var targetIDs = [];

   if(nodeNames.length == 0){ // either an empty string or an empty array
      allNodes = true;
      }
   else if(typeof(nodeNames) == "string")
     targetIDs = [nodeNames];
   else
     targetIDs = nodeNames;

   var filterStrings = [];

   for(var i=0; i < targetIDs.length; i++){
     var s = '[id="' + targetIDs[i] + '"]';
     filterStrings.push(s);
     } // for i

   var nodesToSelect = cy.nodes(filterStrings.join());

   if(allNodes)
      layout = JSON.stringify(cy.nodes().map(function(n){return{id: n.id(),
                                                                width: n.style().width,
                                                                height: n.style().height}}));
   else{
      layout = JSON.stringify(nodesToSelect.map(function(n){return{id: n.id(),
                                                                width: n.style().width,
                                                                height: n.style().height}}));
      } // else: subset of nodes specified

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: layout});

} // getNodeSize
//----------------------------------------------------------------------------------------------------
function hideAllEdges(msg)
{
   cy.edges().hide();

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // hideAllEdges
//----------------------------------------------------------------------------------------------------
function showAllEdges(msg)
{
   cy.edges().show();

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // showAllEdges
//----------------------------------------------------------------------------------------------------
function hideEdges(msg)
{
   var edgeType = msg.payload;
      // emulate this, constructed on the fly:  cy.edges('[edgeType="chromosome"]').hide()
   filterString = '[edgeType="' + edgeType + '"]';
   console.log("filterString: " + filterString);
   cy.edges(filterString).hide();

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // hideEdges
//----------------------------------------------------------------------------------------------------
function showEdges(msg)
{
   var edgeType = msg.payload;
      // emulate this, constructed on the fly:  cy.edges('[edgeType="chromosome"]').show()
   filterString = '[edgeType="' + edgeType + '"]';
   console.log("filterString: " + filterString);
   cy.edges(filterString).show();

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // showEdges
//----------------------------------------------------------------------------------------------------
function showAll(msg)
{
   cy.nodes().show();
   cy.edges().show();

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // showAll
//----------------------------------------------------------------------------------------------------
function setNodeImage(msg)
{
  console.log("--- entering setNodeImage");
  var imageList = msg.payload;
  console.log(imageList);

  var nodeIDs = Object.keys(imageList);
  var urls = Object.keys(imageList).map(function(key){return imageList[key]});
  for(var i=0; i < nodeIDs.length; i++){
     var filterString = "node[id='" + nodeIDs[i] + "']";
     cy.nodes(filterString).style({"background-image": urls[i], "background-fit": "cover"});
     } // var i

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeSize
//----------------------------------------------------------------------------------------------------
function setDefaultNodeSize(msg)
{
  var newSize = msg.payload;
  cy.style().selector('node').css({"height": newSize});
  cy.style().selector('node').css({"width": newSize});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeSize
//----------------------------------------------------------------------------------------------------
function setDefaultNodeWidth(msg)
{
  var newSize = msg.payload;
  cy.style().selector('node').css({"width": newSize});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeWidth
//----------------------------------------------------------------------------------------------------
function setDefaultNodeHeight(msg)
{
  var newSize = msg.payload;
  cy.style().selector('node').css({"height": newSize});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeHeight
//----------------------------------------------------------------------------------------------------
function setDefaultNodeColor(msg)
{
  var newColor = msg.payload;
  cy.style().selector("node").css({"background-color": newColor});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeColor
//----------------------------------------------------------------------------------------------------
function setDefaultNodeShape(msg)
{
  var newShape = msg.payload;
  cy.style().selector("node").css({"shape": newShape});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeColor
//----------------------------------------------------------------------------------------------------
function setDefaultNodeFontColor(msg)
{
  var color = msg.payload;
  cy.style().selector("node").css({"color": color});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeFontColor
//----------------------------------------------------------------------------------------------------
function setDefaultNodeFontSize(msg)
{
  var newValue = msg.payload;
  cy.style().selector("node").css({"font-size": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeFontSize
//----------------------------------------------------------------------------------------------------
function setDefaultNodeBorderWidth(msg)
{
  var newValue = msg.payload;
  cy.style().selector("node").css({"border-width": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeBorderWidth
//----------------------------------------------------------------------------------------------------
function setDefaultNodeBorderColor(msg)
{
  var newValue = msg.payload;
  cy.style().selector("node").css({"border-color": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeBorderColor
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeFontSize(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"font-size": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdge
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeTargetArrowShape(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"target-arrow-shape": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeTargetArrowShape
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeColor(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"line-color": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdge
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeTargetArrowColor(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"target-arrow-color": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdge
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeFontSize(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"font-size": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeFontSize
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeWidth(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"width": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeWidth
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeLineColor(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"line-color": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeLineColor
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeFont(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"font-family": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeFont
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeFontWeight(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"font-weight": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeFontWeight
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeTextOpacity(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"text-opacity": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeTextOpacity
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeLineStyle(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"line-style": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeLineStyle
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeOpacity(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"opacity": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeOpacity
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeSourceArrowColor(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"source-arrow-color": newValue});

 hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeSourceArrowColor
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeSourceArrowShape(msg)
{
  var newValue = msg.payload;
  cy.style().selector("edge").css({"source-arrow-shape": newValue});

  hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeSourceArrayShape
//----------------------------------------------------------------------------------------------------
function selectNodes(msg)
{
   console.log("==== selectNodes");
   console.log(msg.payload);
   var nodeIDs = msg.payload;

   if(typeof(nodeIDs) == "string")
      nodeIDs = [nodeIDs];

   var filterStrings = [];

   for(var i=0; i < nodeIDs.length; i++){
     var s = '[id="' + nodeIDs[i] + '"]';
     filterStrings.push(s);
     } // for i


   var nodesToSelect = cy.nodes(filterStrings.join());
   nodesToSelect.select()

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // selectedNodes
//----------------------------------------------------------------------------------------------------
function sfn(msg)
{
   cy.nodes(':selected').neighborhood().nodes().select()
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // sfn
//----------------------------------------------------------------------------------------------------
function clearSelection(msg)
{
   console.log("==== clearSelection");
   cy.filter("node:selected").unselect()

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // clearSelection
//----------------------------------------------------------------------------------------------------
function invertNodeSelection(msg)
{
   console.log("==== invertNodeSelection");
   var currentlySelected = cy.filter("node:selected");
   cy.nodes().select();
   currentlySelected.unselect();
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // invertNodeSelection
//----------------------------------------------------------------------------------------------------
function hideSelectedNodes(msg)
{
   console.log("==== hideSelectedNodes");
   cy.filter("node:selected").hide();
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // hideSelectedNodes
//----------------------------------------------------------------------------------------------------
function deleteSelectedNodes(msg)
{
   console.log("==== deleteSelectedNodes");
   cy.filter("node:selected").remove();
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // deleteSelectedNodes
//----------------------------------------------------------------------------------------------------
function getNodeLabel(msg)
{
   //nodesOfInterest = msg.payload;
   //cy.filter("node:selected")[0].data('label')

} // getNodeLabel
//----------------------------------------------------------------------------------------------------
function setGraph(msg)
{
   console.log("in function setGraph");
   console.log(msg.payload);
   graph = JSON.parse(msg.payload.graph);
   hideEdges = msg.payload.hideEdges;
   console.log("setGraph calling createCytoscapeWindow, assiging cy");
   cy = createCytoscapeWindow(graph, hideEdges)
   console.log("setGraph after createCytoscapeWindow, cy assigned");
   console.log(cy)
   //cy.load(graph.elements)
   //cy.add(graph)

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: "got graph"});

} // setGraph
//----------------------------------------------------------------------------------------------------
function setNodeAttributes(msg)
{
   console.log("=== rcyjs.html: setNodeAttributes")
   console.log(msg.payload);
   var nodeIDs = msg.payload.nodes;

   var attributeName = msg.payload.attribute;

   for(var i=0; i < nodeIDs.length; i++){
      var name = nodeIDs[i];
      var newValue = msg.payload.values[i];
      var filterString = "[name='" + name + "']";
      //console.log("filterString: " + filterString);
      //console.log("nodeID: " + name + "   value: " + newValue);
      var dataObj = cy.nodes().filter(filterString).data();
      Object.defineProperty(dataObj, attributeName, {value: newValue});
      //cy.nodes().filter(filterString).data({attributeName: value});
      //cy.nodes().filter(filterString).data[attributeName] = value;
      } // for i

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeAttributes
//----------------------------------------------------------------------------------------------------
function setEdgeAttributes(msg)
{
   console.log("=== rcyjs.html: setEdgeAttributes")
   var attributeName = msg.payload.attribute;
   var sourceNodes = msg.payload.sourceNodes;
   var targetNodes = msg.payload.targetNodes;
   var edgeTypes = msg.payload.edgeTypes;
   var values = msg.payload.values

   for(var i=0; i < sourceNodes.length; i++){
      selectorString = "edge[source='" + sourceNodes[i] + "'][target='" + targetNodes[i] +
                       "'][edgeType='" + edgeTypes[i] + "']";

      //console.log(selectorString);
      var dataObj = cy.edges().filter(selectorString).data();
      if(dataObj != undefined){
         Object.defineProperty(dataObj, attributeName, {value: values[i]});
         }
      //cy.edges("edge[source='Crem'][target='Hk2'][edgeType='undefined']").data({"score": 3})
      } // for i

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeAttributes
//----------------------------------------------------------------------------------------------------
function getNodeCount(msg)
{
   var status = "success";  // be optimistic

   result = JSON.stringify(cy.nodes().length);
   returnMsg = {cmd: msg.callback, status: "success", callback: "", payload: result};
   console.log("getNodeCount returning payload: " + result);

   console.log(returnMsg);
   hub.send(returnMsg);

} // getNodeCount
//---------------------------------------------------------------------------------------------------
function getEdgeCount(msg)
{
   result = JSON.stringify(cy.edges().length);
   returnMsg = {cmd: msg.callback, status: "success", callback: "", payload: result};
   console.log("getEdgeount returning payload: " + result);

   console.log(returnMsg);
   hub.send(returnMsg);


} // getEdgeCount
//---------------------------------------------------------------------------------------------------
function getNodes(msg)
{
   var status = "success";  // be optimistic

   if (typeof (cy) == "undefined"){
      payload = JSON.stringify([]);
      status = "error";
      }
   else if (cy.nodes().length == 0){
      payload = JSON.stringify([]);
      }
   else {
      payload =  JSON.stringify(cy.nodes().map(function(node) {
                                return {id: node.data().id, name: node.data().name}}));
      }

   hub.send({cmd: msg.callback, status: "success", callback: "", payload: payload});

} // getNodes
//---------------------------------------------------------------------------------------------------
function getSelectedNodes(msg)
{
   var status = "success";  // be optimistic

   if (typeof (cy) == "undefined"){
      payload = JSON.stringify([]);
      status = "error";
      }
   else if (cy.nodes().length == 0){
      payload = JSON.stringify([]);
      }
   else {
      payload =  JSON.stringify(cy.filter("node:selected").map(function(node) {
                                return {id: node.data().id, name: node.data().name}}));
      }

   console.log("getNodes returning payload: " + payload);
   hub.send({cmd: msg.callback, status: "success", callback: "", payload: payload});

} // getNodes
//---------------------------------------------------------------------------------------------------
function layout(strategy)
{
   switch(strategy) {
      case "random":
         var options = {name: 'random',
                        fit: true, // whether to fit to viewport
                        padding: 30, // fit padding
                        boundingBox: undefined, // constrain layout bounds; { x1, y1, x2, y2 } or { x1, y1, w, h }
                        animate: false, // whether to transition the node positions
                        animationDuration: 500, // duration of animation in ms if enabled
                        ready: undefined, // callback on layoutready
                        stop: undefined // callback on layoutstop
                        };
         cy.layout(options);
         break;
      default:
         console.log("unrecognized layout strategy: " + strategy);
      } // switch

} // layout
//----------------------------------------------------------------------------------------------------
function addNode(propsJSON)
{
  props = JSON.parse(propsJSON)
  console.log("--- addNode, these props");
  console.log(props)

  obj = cy.add({group: "nodes", data: props, position: { x: 200, y: 200 }});
  return(obj.id());

} // addNode
//----------------------------------------------------------------------------------------------------
function addEdge(nodeA_id, nodeB_id)
{
  console.log("--- addEdge betwee %s and %s", nodeA_id, nodeB_id);

  obj = cy.add({group: "edges", data: {source: nodeA_id, target: nodeB_id}});

  return(obj.id());

} // addEdge
//----------------------------------------------------------------------------------------------------
function addGraph(msg)
{
  console.log("=== entering addGraph");
  var network = JSON.parse(msg.payload);
  console.log("adding graph of " + network.elements.nodes.length + " nodes and "
                                 + network.elements.edges.length + " edges.");

    // new nodes must have an explicit position
  for(var n=0; n < network.elements.nodes.length; n++){
     network.elements.nodes[n].position = {x: 0, y:0};
     }

  obj = cy.add(network.elements)
  cy.nodes().map(function(node){node.data({degree: node.degree()})});
  console.log("after add")

  return_msg = {cmd: msg.callback, status: "success", callback: "", payload: ""};
  hub.send(return_msg);

} // addGraph
//----------------------------------------------------------------------------------------------------
function httpAddGraph(msg)
{
  console.log("=== entering httpAddGraph");
  var filename = msg.payload;
  console.log("httpAdding graph '" + filename + "'");
  status = addNetwork(filename);
  if (status=="success") {
     return_msg = {cmd: msg.callback, status: "success", callback: "", payload: ""};
     }
  else{
    return_msg = {cmd: msg.callback, status: "failure", callback: "", payload: status};
    }

  hub.send(return_msg);

} // httpAddGraph
//----------------------------------------------------------------------------------------------------
function httpSetStyle(msg)
{
  console.log("=== entering httpSetStyle");
  var filename = msg.payload;
  console.log("httpSetStyle: '" + filename + "'");
  loadStyle(filename);
  return_msg = {cmd: msg.callback, status: "success", callback: "", payload: ""};
  hub.send(return_msg);

} // httpSetStyle
//----------------------------------------------------------------------------------------------------
function getVizmapNames()
{
   var names = [];

   if(typeof(vizmaps) == "object") {
      for(var i=0; i < vizmaps.length; i++){
        names.push(vizmaps[i].title);
        } // for i
      } // if defined

   return (names);

} // getVizmapNames
//----------------------------------------------------------------------------------------------------
function ws_getVizmapNames(msg)
{
   var names = getVizmapNames();
   var statusMessage = "success";

   if(names.length == 0)
      statusMessage = "failure";

   return_msg = {cmd: msg.callback, status: statusMessage, callback: "", payload: names};

   hub.send(return_msg);

} // ws_getVizmapNames
//----------------------------------------------------------------------------------------------------
function setVizmapByName(requestedName)
{
  for(var i=0; i < vizmaps.length; i++){
    if(vizmaps[i].title == requestedName) {
       cy.style(vizmaps[i].style);
       return(true);
       } // if matched
   } // for i

   return(false);

} // setVizmapByName
//----------------------------------------------------------------------------------------------------
function ws_setVizmapByName(msg)
{
  var requestedName = msg.payload;
  var callback = msg.callback;

  var success = setVizmapByName(requestedName);

  if(success)
      statusMessage = "success"
   else
      statusMessage = "error"

   msg = {cmd: callback, status: statusMessage, callback:"", payload:statusMessage};
   // hub.send(msg);


} // ws_setVizmapByName
//----------------------------------------------------------------------------------------------------
// these are likely to become programmable options
function setupDefaultStyles(cy)
{
     // disable gray rectangle indicating active-selection-taking-place
   cy.style().selector('node:active').css({"overlay-opacity": 0});
   cy.style().selector('edge:active').css({"overlay-opacity": 0});

     // make this visual clue more persistent
   cy.style().selector('node:selected').css({'overlay-color': 'grey', 'overlay-opacity': 0.3})
   cy.style().selector('edge:selected').css({'overlay-color': 'grey', 'overlay-opacity': 0.3})

   // cy.style().selector('node:selected').css('background-color', 'red')

}  // setupDefaultStyles
//----------------------------------------------------------------------------------------------------
function createCytoscapeWindow(graph, hideEdges) {

   var localCy;

   console.log("--- createCytoscapeWindow")
   cyElement = $("#cyDiv");
   console.log("--- graph");
   console.log(graph);
   debugger;

   var localCy = cytoscape({
       container: cyElement,
       elements: graph.elements,
       showOverlay: false,
       minZoom: 0.001,
       maxZoom: 100.0,
       boxSelectionEnabled: true,
       layout: {
         name: "preset",
         fit: true
         },
    ready: function() {
        console.log("cy ready");
        localCy = this;
        if(hideEdges)
           localCy.edges().style({"display": "none"});
        console.log("createCytoscapeWindow assigning degree to nodes")
        localCy.nodes().map(function(node){node.data({degree: node.degree()})});
        setupDefaultStyles(localCy);
        localCy.layout({name: "random"});
        localCy.reset();
        console.log("about to call localCy.fit");
        setTimeout(function(){localCy.fit(50); console.log("fit complete?");}, 250)
        localCy.edges().selectify();
        console.log("about to send browserReady message to R");
        setTimeout(function(){hub.send({cmd: "handleResponse", status: "success", callback: "", payload: ""});}, 100);
        } // localCy.ready
       })

    return (localCy);

} // createCytoscapeWindow
//----------------------------------------------------------------------------------------------------
function qtipOptions()
{
  options = {content: function(){
               console.log(" qitp on " + this.id());
               var attrs = Object.keys(this.data());
               if($.inArray("tooltip", attrs) >= 0){
                 console.log("  found tooltip: " + this.data("tooltip"));
                 return(this.data("tooltip"))
                 }
               if($.inArray("label", attrs) >= 0){
                 console.log("  found lable: " + this.data("label"));
                 return(this.data("label"))
                 }
               if($.inArray("id", attrs) >= 0){
                 console.log("  found id: " + this.data("id"));
                 return(this.data("id"))
                 }
               },
           position: {
             my: 'top center',
             //at: 'bottom center'
             at: 'top center'
             },
           show: {
             event: 'mouseover'
             },
           hide: {
             event: 'mouseout'
             },
           style: {
             classes: 'qtip-bootstrap',
             tip: {
                width: 16,
                height: 8
               }
             }
          }; // options

  return(options);

} // qtipOptions
//----------------------------------------------------------------------------------------------------
// requires an http server at localhost:8000, started in the directory where filename is found
// expected file contents:  vizmap = [{selector:"node",css: {...
function loadStyle(filename)
{
   //var s = "http://localhost:8000/" + filename;
   console.log("rcyjs.loadStyle, filename: " + filename);

   var s = window.location.href + "?" + filename;
   console.log("=== about to getScript on " + s);

   $.getScript(s)
     .done(function(script, textStatus) {
        console.log(textStatus);
        //console.log("style elements " + layout.length);
        cy.style(vizmap);
       })
    .fail(function( jqxhr, settings, exception ) {
       console.log("getScript error trying to read " + filename);
       console.log("exception: ");
       console.log(exception);
       });

} // loadStyle
//----------------------------------------------------------------------------------------------------
addNetwork = function (filename)
{
   var s = window.location.href + "?" + filename;
   console.log("=== about to getScript on " + s);
   $.getScript(s)
     .done(function(script, textStatus) {
         //console.log("getScript: " + textStatus);
         //console.log("nodes: " + network.elements.nodes.length);
         //if(typeof(network.elements.edges) != "undefined")
         //  console.log("edges: " + network.elements.edges.length);
         cy.add(network.elements);  // no positions yet
         cy.nodes().map(function(node){node.data({degree: node.degree()})});
         //cy.edges().style({"display": "none"});  // default hide edges for now
         //cy.elements().qtip(qtipOptions());
         return("success");
         }) // .done
    .fail(function(jqxhr, settings, exception) {
       var msg = "addNetwork getscript error trying to read " + filename;
       console.log(msg);
       return(msg);
      });

} // addNetwork
//----------------------------------------------------------------------------------------------------
function setEdgeRenderingMethod(newMethod)
{
  cy.edges().css({"curve-style": newMethod});

} // setEdgeRenderingMethod
//----------------------------------------------------------------------------------------------------
demoSimpleNetwork = function(cy)
{
  node0 = cy.add({group: "nodes", data: { weight: 75, name: "A"}, position: { x: 200, y: 200 }});
  node1 = cy.add({group: "nodes", data: { weight: 75, name: "B"}, position: { x: 300, y: 300 }});
  cy.add({group: "edges", data: { id: "e0", source: node0.data("id"), target: node1.data("id")}});
  setVizmapByName("Nested Network Style");

} // demoSimpleNetwork
//----------------------------------------------------------------------------------------------------
return{
   setHub: setHub,
   addMessageHandlers: addMessageHandlers,
   initUI: initializeUI,
   setEdgeRenderingMethod: setEdgeRenderingMethod,
   loadStyle: loadStyle
   };

//----------------------------------------------------------------------------------------------------
}); // RCyjsModule

console.log("rcyjs.html 1");
hub = BrowserViz();
console.log("rcyjs.html 2");
rcy = RCyjsModule();
console.log("rcyjs.html 3");
rcy.setHub(hub);
console.log("rcyjs.html 4");
rcy.addMessageHandlers();
console.log("rcyjs.html 5");

hub.addOnDocumentReadyFunction(rcy.initUI);
console.log("rcyjs.html 6");
hub.start();
console.log("rcyjs.html 7");
//----------------------------------------------------------------------------------------------------
var hub = require("browservizjs")
var rcy = RCyjs(hub);
hub.init();
rcy.addMessageHandlers()
hub.addOnDocumentReadyFunction(rcy.initializeUI.bind(rcy));
hub.start();
window.rcy = rcy;
