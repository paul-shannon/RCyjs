"use strict";

var cytoscape = require('cytoscape');
//----------------------------------------------------------------------------------------------------
// add layout extensions
var cola = require('cytoscape-cola');
cytoscape.use(cola);

let dagre = require('cytoscape-dagre');
cytoscape.use(dagre);

let coseBilkent = require('cytoscape-cose-bilkent');
cytoscape.use(coseBilkent);

import css from './css/trenaviz.css';
$ = require('jquery');
require('jquery-ui-bundle');
var hub = require("browservizjs")  // see https://github.com/paul-shannon/browservizjs
//----------------------------------------------------------------------------------------------------
var RCyjs = (function(hub){

  var cyDiv;
  var vizmaps = [];
  var graph;

  var hub = hub;

//----------------------------------------------------------------------------------------------------
function initializeUI()
{
   var self = this;
   initializeMenuButtons(self);

   $(window).resize(handleWindowResize);
   handleWindowResize();

} // initializeUI
//----------------------------------------------------------------------------------------------------
function initializeMenuButtons(self)
{
   console.log("--- initializeMenuButtons");

   $("#cyFitButton").click(function(){self.cy.fit(50)});
   $("#cyFitSelectedButton").click(function(){self.cy.fit(self.cy.nodes(":selected"), 50)});

   $("#cySFNButton").click(function(){self.cy.nodes(':selected').neighborhood().nodes().select()});

   $("#cyHideUnselectedButton").click(function(){self.cy.nodes(":unselected").hide()});
   $("#cyShowAllButton").click(function(){self.cy.nodes().show(); self.cy.edges().show()});

} // initializeMenuButtons
//----------------------------------------------------------------------------------------------------
function handleWindowResize ()
{
   var cyDiv = $("#cyDiv");

   var menubarHeight = $("#cyMenubarDiv").height();
   var windowHeight = window.innerHeight;
   var cyDivHeight = windowHeight - (menubarHeight + 30);

     //console.log("menubar: " + menubarHeight);
     //console.log("window: " + windowHeight);
     //console.log("   div: " + cyDivHeight);

   cyDiv.height(cyDivHeight);

   var cyDivWidth = $(window).width() * 0.98;
   cyDiv.width(cyDivWidth)

} // handleWindowResize
//--------------------------------------------------------------------------------
function addMessageHandlers()
{
   var self = this;

   self.hub.addMessageHandler("addGraph",             addGraph.bind(self));
   self.hub.addMessageHandler("deleteGraph",          deleteGraph.bind(self));

   self.hub.addMessageHandler("setNodeAttributes",    setNodeAttributes.bind(self));
   self.hub.addMessageHandler("setEdgeAttributes",    setEdgeAttributes.bind(self));
   self.hub.addMessageHandler("loadStyleFile",        loadStyleFile.bind(self));
   self.hub.addMessageHandler("getNodeCount",         getNodeCount.bind(self));
   self.hub.addMessageHandler("getEdgeCount",         getEdgeCount.bind(self));
   self.hub.addMessageHandler("getNodes",             getNodes.bind(self));
   self.hub.addMessageHandler("getSelectedNodes",     getSelectedNodes.bind(self));

   self.hub.addMessageHandler("setNodeLabelRule",      setNodeLabelRule.bind(self));
   self.hub.addMessageHandler("setNodeLabelAlignment", setNodeLabelAlignment.bind(self));

   self.hub.addMessageHandler("setNodeSizeRule",      setNodeSizeRule.bind(self));
   self.hub.addMessageHandler("setNodeColorRule",     setNodeColorRule.bind(self));
   self.hub.addMessageHandler("setNodeShapeRule",     setNodeShapeRule.bind(self));

   self.hub.addMessageHandler("setEdgeColorRule",             setEdgeColorRule.bind(self));
   self.hub.addMessageHandler("setEdgeStyle",                 setEdgeStyle.bind(self));
   self.hub.addMessageHandler("setEdgeWidthRule",             setEdgeWidthRule.bind(self));
   self.hub.addMessageHandler("setEdgeTargetArrowShapeRule",  setEdgeTargetArrowShapeRule.bind(self));
   self.hub.addMessageHandler("setEdgeTargetArrowColorRule",  setEdgeTargetArrowColorRule.bind(self));
   self.hub.addMessageHandler("setEdgeSourceArrowShapeRule",  setEdgeSourceArrowShapeRule.bind(self));
   self.hub.addMessageHandler("setEdgeSourceArrowColorRule",  setEdgeSourceArrowColorRule.bind(self));

   self.hub.addMessageHandler("redraw",                redraw.bind(self));
   self.hub.addMessageHandler("fit",                   fit.bind(self));
   self.hub.addMessageHandler("fitSelected",           fitSelected.bind(self));
   self.hub.addMessageHandler("getZoom",               getZoom.bind(self));
   self.hub.addMessageHandler("setZoom",               setZoom.bind(self));
   self.hub.addMessageHandler("setBackgroundColor",    setBackgroundColor.bind(self));
   self.hub.addMessageHandler("getLayoutStrategies",   getLayoutStrategies.bind(self));
   self.hub.addMessageHandler("doLayout",              doLayout.bind(self));
   self.hub.addMessageHandler("layoutSelectionInGrid", layoutSelectionInGrid.bind(self));
   self.hub.addMessageHandler("layoutSelectionInGridInferAnchor", layoutSelectionInGridInferAnchor.bind(self));

   self.hub.addMessageHandler("getPosition",          getPosition.bind(self));
   self.hub.addMessageHandler("setPosition",          setPosition.bind(self));
   self.hub.addMessageHandler("getNodeSize",          getNodeSize.bind(self));
   self.hub.addMessageHandler("hideAllEdges",         hideAllEdges.bind(self));
   self.hub.addMessageHandler("showAllEdges",         showAllEdges.bind(self));
   self.hub.addMessageHandler("hideEdges",            hideEdges.bind(self));
   self.hub.addMessageHandler("showEdges",            showEdges.bind(self));
   self.hub.addMessageHandler("showAll",              showAll.bind(self));

   self.hub.addMessageHandler("getJSON",              getJSON.bind(self));
   self.hub.addMessageHandler("getPNG",               getPNG.bind(self));
   self.hub.addMessageHandler("getJPG",               getJPG.bind(self));
   self.hub.addMessageHandler("selectNodes",          selectNodes.bind(self));
   self.hub.addMessageHandler("invertNodeSelection",  invertNodeSelection.bind(self));
   self.hub.addMessageHandler("hideSelectedNodes",    hideSelectedNodes.bind(self));
   self.hub.addMessageHandler("deleteSelectedNodes",  deleteSelectedNodes.bind(self));
   self.hub.addMessageHandler("sfn",                  sfn.bind(self));
   self.hub.addMessageHandler("clearSelection",       clearSelection.bind(self));

   self.hub.addMessageHandler("setNodeImage",         setNodeImage.bind(self));

   self.hub.addMessageHandler("setDefaultNodeColor",  setDefaultNodeColor.bind(self));
   self.hub.addMessageHandler("setDefaultNodeShape",  setDefaultNodeShape.bind(self));

   self.hub.addMessageHandler("setDefaultNodeSize",   setDefaultNodeSize.bind(self));
   self.hub.addMessageHandler("setDefaultNodeWidth",  setDefaultNodeWidth.bind(self));
   self.hub.addMessageHandler("setDefaultNodeHeight", setDefaultNodeHeight.bind(self));
   self.hub.addMessageHandler("setDefaultNodeColor",  setDefaultNodeColor.bind(self));
   self.hub.addMessageHandler("setDefaultNodeShape",  setDefaultNodeShape.bind(self));
   self.hub.addMessageHandler("setDefaultNodeFontColor", setDefaultNodeFontColor.bind(self));
   self.hub.addMessageHandler("setDefaultNodeFontSize", setDefaultNodeFontSize.bind(self));
   self.hub.addMessageHandler("setDefaultNodeBorderWidth", setDefaultNodeBorderWidth.bind(self));
   self.hub.addMessageHandler("setDefaultNodeBorderColor", setDefaultNodeBorderColor.bind(self));

   self.hub.addMessageHandler("setDefaultEdgeFontSize", setDefaultEdgeFontSize.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeTargetArrowShape", setDefaultEdgeTargetArrowShape.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeColor", setDefaultEdgeColor.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeTargetArrowColor", setDefaultEdgeTargetArrowColor.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeFontSize", setDefaultEdgeFontSize.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeWidth", setDefaultEdgeWidth.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeLineColor", setDefaultEdgeLineColor.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeFont", setDefaultEdgeFont.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeFontWeight", setDefaultEdgeFontWeight.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeTextOpacity", setDefaultEdgeTextOpacity.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeLineStyle", setDefaultEdgeLineStyle.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeOpacity", setDefaultEdgeOpacity.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeSourceArrowColor", setDefaultEdgeSourceArrowColor.bind(self));
   self.hub.addMessageHandler("setDefaultEdgeSourceArrowShape", setDefaultEdgeSourceArrowShape.bind(self));

} // addMessageHandlers
//----------------------------------------------------------------------------------------------------
function redraw(msg)
{
   var self = this;

   self.cy.style().update();
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // redraw
//----------------------------------------------------------------------------------------------------
function fit(msg)
{
   var self = this;
   var padding = msg.payload;
   console.log("fit, with padding " + padding);
   self.cy.fit(padding)
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // fit
//----------------------------------------------------------------------------------------------------
function fitSelected(msg)
{
   var self = this;
   var selectedNodes = self.cy.filter('node:selected');
   var padding = msg.payload;

   if(selectedNodes.length == 0){
     status = "failure";
     payload = "no nodes currently selected"
     }
  else{
    console.log("fitSelected, with padding " + padding);
    self.cy.fit(selectedNodes, padding)
    status = "success";
    payload = "";
    }

  self.hub.send({cmd: msg.callback, status: status, callback: "", payload: payload});

} // fit
//----------------------------------------------------------------------------------------------------
function setZoom(msg)
{
   var self = this;
   var newFactor = msg.payload
   var box = self.cy.extent();
   var center = {x: box.x1 + (box.w/2), y: box.y1 + (box.h/2)};
   self.cy.zoom({level: newFactor, position: center});
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setZoom
//----------------------------------------------------------------------------------------------------
function getZoom(msg)
{
   var self = this;
   result = self.cy.zoom();
   var returnMsg = {cmd: msg.callback, status: "success", callback: "", payload: result};
   console.log(returnMsg);
   self.hub.send(returnMsg);

} // getZoom
//----------------------------------------------------------------------------------------------------
function setBackgroundColor(msg)
{
   var self = this;
   var newValue = msg.payload
   cyDiv.css({"background-color": newValue});
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setZoom
//----------------------------------------------------------------------------------------------------
function update()
{
   var self = this;
   self.cy.style().update()

} // update
//----------------------------------------------------------------------------------------------------
function setNodeLabelRule(msg)
{
   var self = this;
   var controllingAttribute = msg.payload;
   var valueString = "data(" + controllingAttribute + ")";
   self.cy.style().selector('node').css({content: valueString});
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeLabelRule
//----------------------------------------------------------------------------------------------------
function setNodeLabelAlignment(msg)
{
   var self = this;
   var horizontalPosition = msg.payload.horizontal;
   var verticalPosition = msg.payload.vertical;
   self.cy.style().selector('node').css({"text-halign": horizontalPosition});
   self.cy.style().selector('node').css({"text-valign": verticalPosition});

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeLabelAlignment
//----------------------------------------------------------------------------------------------------
function setNodeSizeRule(msg)
{
   var self = this;
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
      // self.cy.style().selector("node[count<=1]").css

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

     self.cy.style().selector(selectorString).css({width: mappingString});
     self.cy.style().selector(selectorString).css({height: mappingString});
     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeSizeRule
//----------------------------------------------------------------------------------------------------
function setNodeColorRule(msg)
{
   var self = this;
   var mode = msg.payload.mode;
   if(mode == "interpolate")
      setNodeColorInterpolatingRule(self, msg)
   else if (mode == "lookup")
      setNodeColorLookupRule(self, msg)
   else
      self.hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

} // setNodeColorRule
//----------------------------------------------------------------------------------------------------
function setNodeColorLookupRule(self, msg)
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
     self.cy.style().selector(selectorString).css({"background-color": color});
     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeColorLookupRule
//----------------------------------------------------------------------------------------------------
function setNodeColorInterpolatingRule(self, msg)
{
   console.log(this)

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
      // self.cy.style().selector("node[count<=1]").css

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

     self.cy.style().selector(selectorString).css({"background-color": mappingString});
     } // for seg


   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setNodeShapeRule(msg)
{
   var self = this;
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setNodeShapeRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var nodeShapes = msg.payload.nodeShapes;

   for(var i=0; i < states.length; i++){
     var shape = nodeShapes[i];
     var state = states[i];
     var selectorString = "node[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString + "  shape: " + shape);
     self.cy.style().selector(selectorString).css({"shape": shape});
     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeShapeRule
//----------------------------------------------------------------------------------------------------
// either "haystack" for fast rendering, no arrows, or "bezier" for slow, arrows, better appearance
function setEdgeStyle(msg)
{
   var self = this;
   var mode = msg.payload;

   if ($.inArray(mode, ["haystack", "bezier"]) < 0)
     self.hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

   if(mode === "haystack")
      self.cy.edges().style({"curve-style": "haystack"});
   else if (mode == "bezier")
      self.cy.edges().style({"curve-style": "bezier"});

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeStyle
//----------------------------------------------------------------------------------------------------
function setEdgeColorRule(msg)
{
   var self = this;
   var mode = msg.payload.mode;
   if(mode === "interpolate")
      setEdgeColorInterpolatingRule(msg)
   else if (mode == "lookup")
      setEdgeColorLookupRule(msg)
   else
      self.hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

} // setEdgeColorRule
//----------------------------------------------------------------------------------------------------
function setEdgeColorLookupRule(msg)
{
   var self = this;
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeColorRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var colors = msg.payload.edgeColors;

   for(var i=0; i < states.length; i++){
     var color = colors[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     self.cy.style().selector(selectorString).css({"line-color": color});
     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeColorLookupRule
//----------------------------------------------------------------------------------------------------
function setEdgeColorInterpolatingRule(msg)
{
   var self = this;
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
      // self.cy.style().selector("edge[count<=1]").css

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

     self.cy.style().selector(selectorString).css({"line-color": mappingString});
     } // for seg


   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setEdgeWidthRule(msg)
{
   var self = this;
   var mode = msg.payload.mode;

   if(mode === "interpolate")
      setEdgeWidthInterpolatingRule(msg)
   else if (mode == "lookup")
      setEdgeWidthLookupRule(msg)
   else
      self.hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

} // setEdgeWidthRule
//----------------------------------------------------------------------------------------------------
function setEdgeWidthInterpolatingRule(msg)
{
   var self = this;
   self.hub.send({cmd: msg.callback, status: "not yet implemented", callback: "", payload: ""});

} // setEdgeWidthInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setEdgeWidthLookupRule(msg)
{
   var self = this;
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeWidthLookupRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var widths = msg.payload.widths;

   for(var i=0; i < states.length; i++){
     var width = widths[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     self.cy.style().selector(selectorString).css({"width": width});
     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeWidthLookupRule
//----------------------------------------------------------------------------------------------------
function setEdgeTargetArrowShapeRule(msg)
{
   var self = this;
   var controllingAttribute = msg.payload.attribute;
   var states = msg.payload.controlPoints;
   var shapes = msg.payload.edgeShapes;

   for(var i=0; i < states.length; i++){
     var shape = shapes[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     console.log("  newShape: " + shape);
     self.cy.style().selector(selectorString).css({"target-arrow-shape": shape});

     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeTargetArrowShapeRule
//----------------------------------------------------------------------------------------------------
function setEdgeTargetArrowColorRule(msg)
{
   var self = this;
   var mode = msg.payload.mode;

   if(mode === "interpolate")
      setEdgeTargetArrowColorInterpolatingRule(msg)
   else if (mode == "lookup")
      setEdgeTargetArrowColorLookupRule(msg)
   else
      self.hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

} // setEdgeTargetArrowColorRule
//----------------------------------------------------------------------------------------------------
function setEdgeTargetArrowColorInterpolatingRule(msg)
{
   var self = this;
   self.hub.send({cmd: msg.callback, status: "not yet implemented", callback: "", payload: ""});

} // setEdgeTargetArrowColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setEdgeTargetArrowColorLookupRule(msg)
{
   var self = this;
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeTargetArrowColorLookupRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var colors = msg.payload.colors;

   for(var i=0; i < states.length; i++){
     var color = colors[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     self.cy.style().selector(selectorString).css({"target-arrow-color": color});
     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeTargetArrowColorLookupRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowColorInterpolatingRule(msg)
{
   var self = this;
   self.hub.send({cmd: msg.callback, status: "not yet implemented", callback: "", payload: ""});

} // setEdgeSourceArrowColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowShapeRule(msg)
{
   var self = this;
   var controllingAttribute = msg.payload.attribute;
   var states = msg.payload.controlPoints;
   var shapes = msg.payload.edgeShapes;

   for(var i=0; i < states.length; i++){
     var shape = shapes[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     console.log("  newShape: " + shape);
     self.cy.style().selector(selectorString).css({"source-arrow-shape": shape});
     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeSourceArrowShapeRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowColorRule(msg)
{
   var self = this;
   var mode = msg.payload.mode;

   if(mode === "interpolate")
      setEdgeSourceArrowColorInterpolatingRule(msg)
   else if (mode == "lookup")
      setEdgeSourceArrowColorLookupRule(msg)
   else
      self.hub.send({cmd: msg.callback, status: "error", callback: "", payload: "unknown mode: " + mode});

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeSourceArrowColorRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowColorLookupRule(msg)
{
   var self = this;
   var controllingAttribute = msg.payload.attribute;
   console.log("--- setEdgeSourceArrowColorLookupRule: " + controllingAttribute);
   var states = msg.payload.controlPoints;
   var colors = msg.payload.colors;

   for(var i=0; i < states.length; i++){
     var color = colors[i];
     var state = states[i];
     var selectorString = "edge[" + controllingAttribute + "='"  + state + "']";
     console.log("selectorString: " + selectorString);
     self.cy.style().selector(selectorString).css({"source-arrow-color": color});
     } // for seg

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeSourceArrowColorLookupRule
//----------------------------------------------------------------------------------------------------
function setEdgeSourceArrowColorInterpolatingRule(msg)
{
   var self = this;
   self.hub.send({cmd: msg.callback, status: "error", callback: "", payload: "not implemented yet"});

} // setEdgeSourceArrowColorInterpolatingRule
//----------------------------------------------------------------------------------------------------
function getNodeSize(msg)
{
   var self = this;
   console.log("=== getNodeSize");
   var nodeID = msg.payload;
   var filterString = "node[id='" + nodeID + "']";
   var width = self.cy.filter(filterString).css("width");
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: width});

} // getNodeSize
//----------------------------------------------------------------------------------------------------
function getLayoutStrategies(msg)
{
   var self = this;
   console.log("=== layoutStrategies");
   var builtinStrategies = ["breadthfirst", "circle", "concentric", "cose", "grid", "random"]
   var extensionStrategies = ["cola", "dagre", "cose-bilkent"]
   var strategies = builtinStrategies.concat(extensionStrategies)

   console.log("== layoutStrategies hub.sending " + strategies.length + " strategies");
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: strategies});

} // getLayoutStragegies
//----------------------------------------------------------------------------------------------------
function doLayout(msg)
{
   var self = this;
   console.log("=== doLayout");
   var strategy = msg.payload;
   self.cy.layout({name: strategy}).run()

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // doLayout
//----------------------------------------------------------------------------------------------------
function layoutSelectionInGrid(msg)
{
  var self = this;
  var x = msg.payload.x;
  var y = msg.payload.y;
  var w = msg.payload.w
  var h = msg.payload.h

  var box = {x1: x, y1: y, w: w, h: h }

  self.cy.filter("node:selected").layout({ name: 'grid', boundingBox: box });

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // layoutSelectinInfGrid
//----------------------------------------------------------------------------------------------------
function layoutSelectionInGridInferAnchor(msg)
{
  var self = this;
  var currentPan = self.cy.pan();
  var currentZoom = self.cy.zoom();

  var w = msg.payload.w
  var h = msg.payload.h

  var yCoordinates = self.cy.nodes("node:selected").map(function(node) {return node.position().y});
  var xCoordinates = self.cy.nodes("node:selected").map(function(node) {return node.position().x});

  var y = Math.min.apply(null, yCoordinates)
  var x = Math.min.apply(null, xCoordinates)

  var box = {x1: x, y1: y, w: w, h: h }

  self.cy.filter("node:selected").layout({ name: 'grid', boundingBox: box });
  self.cy.viewport({zoom: currentZoom, pan: currentPan});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // layoutSelectionInGridInferAnchor
//----------------------------------------------------------------------------------------------------
function getJSON(msg)
{
   var self = this;
   console.log("=== getJSON");
   var json = JSON.stringify(self.cy.json());
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: json});

} // getJSON
//----------------------------------------------------------------------------------------------------
function getPNG(msg)
{
   var self = this;
   console.log("=== getPNG");
   var png_json = JSON.stringify(self.cy.png());
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: png_json});

} // getPNG
//----------------------------------------------------------------------------------------------------
function getJPG(msg)
{
   var self = this;
   var quality = msg.payload.quality;
   var width = msg.payload.width;
   var height = msg.payload.height;
   console.log("=== getJPG");
   var options = {full: false,
                  quality: quality,
                  maxWidth: width,
                  maxHeight: height};
     // options ignored for now
   var jpg_json = JSON.stringify(self.cy.jpg(options));
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: jpg_json});

} // getJPG
//----------------------------------------------------------------------------------------------------
function getPosition(msg)
{
   var self = this;
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

   var nodesToSelect = self.cy.nodes(filterStrings.join());

   if(allNodes)
      layout = JSON.stringify(self.cy.nodes().map(function(n){return{id: n.id(),
                                                                x: n.position().x,
                                                                y: n.position().y}}));
   else{
      layout = JSON.stringify(nodesToSelect.map(function(n){return{id: n.id(),
                                                                x: n.position().x,
                                                                y: n.position().y}}));
      } // else: subset of nodes specified

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: layout});

} // getPosition
//----------------------------------------------------------------------------------------------------
function setPosition(msg)
{
   var self = this;
   console.log("==== setPosition");
   //console.log(msg.payload);
     // there will be 1 or more position objects, each with id, x, and y values
   var positionObjects = msg.payload;

   console.log("calling setPosition map");
   positionObjects.map(function(e){
       var tag="[id='" + e.id + "']";
       self.cy.$(tag).position({x: e.x, y:e.y});
       });

   /************
   for(var i=0; i < positionObjects.length; i++){
      var obj = positionObjects[i];
      var id = obj.id;
      var xPos = obj.x;
      var yPos = obj.y;
      var filterString = "[id='" + id + "']";
      //console.log(" setPosition " + id + ": " + xPos + ", " + yPos);
      self.cy.nodes(filterString).position({x: xPos, y: yPos});
      } // for i
    ********/
   console.log("after setPosition map");

     // create a subset of all nodes, including only those in positionObjects
   //var filterStrings = [];
   //for(var i=0; i < positionObjects.length; i++){
   //  var s = '[id="' + positionObjects[i].id + '"]';
   //  filterStrings.push(s);
   //  } // for i
   //var nodeSubset = self.cy.nodes(filterStrings.join());
   //console.log("rcyjs.html, setPosition(msg) setting position on nodes, count: " + nodeSubset.length);
   //console.log(JSON.stringify(nodeSubset))

   //--------------------------------------------------------------------------------
   // bug: in some cases the order of nodes in nodeSubset does not match the i indices of the positionObjects
   //--------------------------------------------------------------------------------

      // nodeSubset.positions(function(i, node){return{x: positionObjects[i].x, y: positionObjects[i].y}})
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setPosition
//----------------------------------------------------------------------------------------------------
function getNodeSize(msg)
{
   var self = this;
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

   var nodesToSelect = self.cy.nodes(filterStrings.join());

   if(allNodes)
      layout = JSON.stringify(cy.nodes().map(function(n){return{id: n.id(),
                                                                width: n.style().width,
                                                                height: n.style().height}}));
   else{
      layout = JSON.stringify(nodesToSelect.map(function(n){return{id: n.id(),
                                                                width: n.style().width,
                                                                height: n.style().height}}));
      } // else: subset of nodes specified

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: layout});

} // getNodeSize
//----------------------------------------------------------------------------------------------------
function hideAllEdges(msg)
{
   var self = this;
   self.cy.edges().hide();

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // hideAllEdges
//----------------------------------------------------------------------------------------------------
function showAllEdges(msg)
{
   var self = this;
   self.cy.edges().show();

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // showAllEdges
//----------------------------------------------------------------------------------------------------
function hideEdges(msg)
{
   var self = this;
   var edgeType = msg.payload;
      // emulate this, constructed on the fly:  self.cy.edges('[edgeType="chromosome"]').hide()
   filterString = '[edgeType="' + edgeType + '"]';
   console.log("filterString: " + filterString);
   self.cy.edges(filterString).hide();

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // hideEdges
//----------------------------------------------------------------------------------------------------
function showEdges(msg)
{
   var self = this;
   var edgeType = msg.payload;
      // emulate this, constructed on the fly:  self.cy.edges('[edgeType="chromosome"]').show()
   filterString = '[edgeType="' + edgeType + '"]';
   console.log("filterString: " + filterString);
   self.cy.edges(filterString).show();

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // showEdges
//----------------------------------------------------------------------------------------------------
function showAll(msg)
{
   var self = this;
   var which = msg.payload.which

   if(which == "both" | which == "edges"){
       self.cy.edges().show()
      }

   if(which == "both" | which == "nodes"){
     self.cy.nodes().show()
     }

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // showAll
//----------------------------------------------------------------------------------------------------
function setNodeImage(msg)
{
   var self = this;
  console.log("--- entering setNodeImage");
  var imageList = msg.payload;
  console.log(imageList);

  var nodeIDs = Object.keys(imageList);
  var urls = Object.keys(imageList).map(function(key){return imageList[key]});
  for(var i=0; i < nodeIDs.length; i++){
     var filterString = "node[id='" + nodeIDs[i] + "']";
     self.cy.nodes(filterString).style({"background-image": urls[i], "background-fit": "cover"});
     } // var i

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeSize
//----------------------------------------------------------------------------------------------------
function setDefaultNodeSize(msg)
{
   var self = this;
  var newSize = msg.payload;
  self.cy.style().selector('node').css({"height": newSize});
  self.cy.style().selector('node').css({"width": newSize});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeSize
//----------------------------------------------------------------------------------------------------
function setDefaultNodeWidth(msg)
{
   var self = this;
  var newSize = msg.payload;
  self.cy.style().selector('node').css({"width": newSize});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeWidth
//----------------------------------------------------------------------------------------------------
function setDefaultNodeHeight(msg)
{
   var self = this;
  var newSize = msg.payload;
  self.cy.style().selector('node').css({"height": newSize});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeHeight
//----------------------------------------------------------------------------------------------------
function setDefaultNodeColor(msg)
{
   var self = this;
  var newColor = msg.payload;
  self.cy.style().selector("node").css({"background-color": newColor});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeColor
//----------------------------------------------------------------------------------------------------
function setDefaultNodeShape(msg)
{
   var self = this;
  var newShape = msg.payload;
  self.cy.style().selector("node").css({"shape": newShape});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeColor
//----------------------------------------------------------------------------------------------------
function setDefaultNodeFontColor(msg)
{
   var self = this;
  var color = msg.payload;
  self.cy.style().selector("node").css({"color": color});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeFontColor
//----------------------------------------------------------------------------------------------------
function setDefaultNodeFontSize(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("node").css({"font-size": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeFontSize
//----------------------------------------------------------------------------------------------------
function setDefaultNodeBorderWidth(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("node").css({"border-width": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeBorderWidth
//----------------------------------------------------------------------------------------------------
function setDefaultNodeBorderColor(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("node").css({"border-color": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultNodeBorderColor
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeFontSize(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"font-size": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdge
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeTargetArrowShape(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"target-arrow-shape": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeTargetArrowShape
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeColor(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"line-color": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdge
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeTargetArrowColor(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"target-arrow-color": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdge
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeFontSize(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"font-size": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeFontSize
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeWidth(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"width": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeWidth
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeLineColor(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"line-color": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeLineColor
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeFont(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"font-family": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeFont
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeFontWeight(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"font-weight": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeFontWeight
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeTextOpacity(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"text-opacity": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeTextOpacity
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeLineStyle(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"line-style": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeLineStyle
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeOpacity(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"opacity": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeOpacity
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeSourceArrowColor(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"source-arrow-color": newValue});

 hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeSourceArrowColor
//----------------------------------------------------------------------------------------------------
function setDefaultEdgeSourceArrowShape(msg)
{
   var self = this;
  var newValue = msg.payload;
  self.cy.style().selector("edge").css({"source-arrow-shape": newValue});

  self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setDefaultEdgeSourceArrayShape
//----------------------------------------------------------------------------------------------------
function selectNodes(msg)
{
   var self = this;
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


   var nodesToSelect = self.cy.nodes(filterStrings.join());
   nodesToSelect.select()

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // selectedNodes
//----------------------------------------------------------------------------------------------------
function sfn(msg)
{
   var self = this;
   self.cy.nodes(':selected').neighborhood().nodes().select()
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // sfn
//----------------------------------------------------------------------------------------------------
function clearSelection(msg)
{
   var self = this;
   var which = msg.payload.which;

   if(which == "both" | which == "edges"){
     self.cy.filter("edge:selected").unselect()
     }

   if(which == "both" | which == "nodes"){
     self.cy.filter("node:selected").unselect()
     }

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // clearSelection
//----------------------------------------------------------------------------------------------------
function invertNodeSelection(msg)
{
   var self = this;
   console.log("==== invertNodeSelection");
   var currentlySelected = self.cy.filter("node:selected");
   self.cy.nodes().select();
   currentlySelected.unselect();
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // invertNodeSelection
//----------------------------------------------------------------------------------------------------
function hideSelectedNodes(msg)
{
   var self = this;
   console.log("==== hideSelectedNodes");
   self.cy.filter("node:selected").hide();
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // hideSelectedNodes
//----------------------------------------------------------------------------------------------------
function deleteSelectedNodes(msg)
{
   var self = this;
   console.log("==== deleteSelectedNodes");
   self.cy.filter("node:selected").remove();
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // deleteSelectedNodes
//----------------------------------------------------------------------------------------------------
function getNodeLabel(msg)
{
   var self = this;
   //nodesOfInterest = msg.payload;
   //cy.filter("node:selected")[0].data('label')

} // getNodeLabel
//----------------------------------------------------------------------------------------------------
// function addGraph(msg)
// {
//    var self = this;
//    console.log("in function addGraph");
//    console.log(msg.payload);
//    graph = JSON.parse(msg.payload.graph);
//    hideEdges = msg.payload.hideEdges;
//    console.log("addGraph calling createCytoscapeWindow, assiging cy");
//    self.cy = self.createCytoscapeWindow(graph, hideEdges)
//    console.log("setGraph after createCytoscapeWindow, cy assigned");
//    console.log(self.cy)
//    //cy.load(graph.elements)
//    //cy.add(graph)
//
//    self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: "got graph"});
//
// } // addGraph
//----------------------------------------------------------------------------------------------------
function deleteGraph(msg)
{
   var self = this;
   if(typeof(self.cy) != "undefined"){
      self.cy.remove(self.cy.elements())
      }
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // deleteGraph
//----------------------------------------------------------------------------------------------------
function setNodeAttributes(msg)
{
   var self = this;
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
      var dataObj = self.cy.nodes().filter(filterString).data();
      Object.defineProperty(dataObj, attributeName, {value: newValue});
      //cy.nodes().filter(filterString).data({attributeName: value});
      //cy.nodes().filter(filterString).data[attributeName] = value;
      } // for i

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setNodeAttributes
//----------------------------------------------------------------------------------------------------
function setEdgeAttributes(msg)
{
   var self = this;
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
      var dataObj = self.cy.edges().filter(selectorString).data();
      if(dataObj != undefined){
         Object.defineProperty(dataObj, attributeName, {value: values[i]});
         }
      //cy.edges("edge[source='Crem'][target='Hk2'][edgeType='undefined']").data({"score": 3})
      } // for i

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: ""});

} // setEdgeAttributes
//----------------------------------------------------------------------------------------------------
function getNodeCount(msg)
{
   var self = this;
   var status = "success";  // be optimistic

   var result = JSON.stringify(self.cy.nodes().length);
   var returnMsg = {cmd: msg.callback, status: "success", callback: "", payload: result};
   console.log("getNodeCount returning payload: " + result);

   console.log(returnMsg);
   self.hub.send(returnMsg);

} // getNodeCount
//---------------------------------------------------------------------------------------------------
function getEdgeCount(msg)
{
   var self = this;

   var result = JSON.stringify(self.cy.edges().length);
   var returnMsg = {cmd: msg.callback, status: "success", callback: "", payload: result};

   self.hub.send(returnMsg);

} // getEdgeCount
//---------------------------------------------------------------------------------------------------
function getNodes(msg)
{
   var self = this;
   var status = "success";  // be optimistic
   var filter = msg.payload.which;  // "all", "visible", "hidden"
   var payload;

   if (typeof (self.cy) == "undefined"){
      payload = JSON.stringify([]);
      status = "error";
      }
   else if (self.cy.nodes().length == 0){
      payload = JSON.stringify([]);
      }
   else {
      var nodes = self.cy.nodes();  // all nodes is the default
      if(filter != "all"){  // "hidden" or "visible"
         nodes = self.cy.nodes(":" + filter);
         }
      //payload =  JSON.stringify(self.cy.nodes(filterString).map(function(node) {
      payload =  JSON.stringify(nodes.map(function(node){
           return {id: node.data().id, name: node.data().name, label: node.data().label}}));
      } // else

   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: payload});

} // getNodes
//---------------------------------------------------------------------------------------------------
function getSelectedNodes(msg)
{
   var self = this;
   var status = "success";  // be optimistic
   var payload = ""

   if (typeof(self.cy) == "undefined"){
      payload = JSON.stringify([]);
      status = "error";
      }
   else if (self.cy.nodes().length == 0){
      payload = JSON.stringify([]);
      }
   else {
      payload =  JSON.stringify(self.cy.filter("node:selected").map(function(node) {
                                return {id: node.data().id, name: node.data().name}}));
      }

   console.log("getNodes returning payload: " + payload);
   self.hub.send({cmd: msg.callback, status: "success", callback: "", payload: payload});

} // getSelectedNodes
//---------------------------------------------------------------------------------------------------
function layout(strategy)
{
   var self = this;
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
         self.cy.layout(options);
         break;
      default:
         console.log("unrecognized layout strategy: " + strategy);
      } // switch

} // layout
//----------------------------------------------------------------------------------------------------
function addNode(propsJSON)
{
   var self = this;
  props = JSON.parse(propsJSON)
  console.log("--- addNode, these props");
  console.log(props)

  var obj = self.cy.add({group: "nodes", data: props, position: { x: 200, y: 200 }});
  return(obj.id());

} // addNode
//----------------------------------------------------------------------------------------------------
function addEdge(nodeA_id, nodeB_id)
{
   var self = this;
  console.log("--- addEdge betwee %s and %s", nodeA_id, nodeB_id);

  var obj = self.cy.add({group: "edges", data: {source: nodeA_id, target: nodeB_id}});

  return(obj.id());

} // addEdge
//----------------------------------------------------------------------------------------------------
function addGraph(msg)
{
  var self = this;

  console.log("=== entering newAddGraph, msg:");
  console.log(msg);

  var filename = msg.payload.filename;
  var status = "success"

  console.log("addGraph calling createCytoscapeWindow, assiging cy");
  if(typeof(self.cy) == "undefined"){
     self.cy = self.createCytoscapeWindow(graph)
     }

  console.log("addGraph '" + filename + "'");

  status = self.addNetwork(filename);

  var return_msg;

  if (status=="success") {
     return_msg = {cmd: msg.callback, status: "success", callback: "", payload: ""};
     }
  else{
    return_msg = {cmd: msg.callback, status: "failure", callback: "", payload: status};
    }

  self.hub.send(return_msg);

} // addGraph
//----------------------------------------------------------------------------------------------------
function loadStyleFile(msg)
{
   var self = this;
   console.log("=== entering loadStyleFile");
   var filename = msg.payload;
   console.log("loadStyleFile: '" + filename + "'");
   self.loadStyle(filename);
   var return_msg = {cmd: msg.callback, status: "success", callback: "", payload: ""};
   self.hub.send(return_msg);

} // loadStyleFile
//----------------------------------------------------------------------------------------------------
function getVizmapNames()
{
   var self = this;
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
   var self = this;
   var names = getVizmapNames();
   var statusMessage = "success";

   if(names.length == 0)
      statusMessage = "failure";

   var return_msg = {cmd: msg.callback, status: statusMessage, callback: "", payload: names};

   self.hub.send(return_msg);

} // ws_getVizmapNames
//----------------------------------------------------------------------------------------------------
function setVizmapByName(requestedName)
{
   var self = this;
  for(var i=0; i < vizmaps.length; i++){
    if(vizmaps[i].title == requestedName) {
       self.cy.style(vizmaps[i].style);
       return(true);
       } // if matched
   } // for i

   return(false);

} // setVizmapByName
//----------------------------------------------------------------------------------------------------
function ws_setVizmapByName(msg)
{
   var self = this;
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
   var self = this;
     // disable gray rectangle indicating active-selection-taking-place
   cy.style().selector('node:active').css({"overlay-opacity": 0});
   cy.style().selector('edge:active').css({"overlay-opacity": 0});

     // make this visual clue more persistent
   cy.style().selector('node:selected').css({'overlay-color': 'grey', 'overlay-opacity': 0.3})
   cy.style().selector('edge:selected').css({'overlay-color': 'grey', 'overlay-opacity': 0.3})

   // self.cy.style().selector('node:selected').css('background-color', 'red')

}  // setupDefaultStyles
//----------------------------------------------------------------------------------------------------
function createCytoscapeWindow()
{
   var self = this;
   var localCy;

   console.log("--- createCytoscapeWindow")
   var cyElement = $("#cyDiv");
   //console.log("--- graph");
   console.log(graph);
   var localCy = cytoscape({
       container: cyElement,
       //elements: graph.elements,
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
   var self = this;
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
// requires an http server at localhost, started in the directory where filename is found
// expected file contents:  vizmap = [{selector:"node",css: {...
function loadStyle(filename)
{
   var self = this;
   console.log("rcyjs.loadStyle, filename: " + filename);

   var s = window.location.href + "?" + filename;
   console.log("=== about to getScript on " + s);

   $.getScript(s)
     .done(function(script, textStatus) {
        console.log(textStatus);
        //console.log("style elements " + layout.length);
        self.cy.style(vizmap);
       })
    .fail(function( jqxhr, settings, exception ) {
       console.log("getScript error trying to read " + filename);
       console.log("exception: ");
       console.log(exception);
       });

} // loadStyle
//----------------------------------------------------------------------------------------------------
function addNetwork (filename)
{
   var self = this;
   var s = window.location.href + "?" + filename;
   console.log("=== about to getScript on " + s);

   $.getScript(s)
     .done(function(script, textStatus) {
         //console.log("getScript: " + textStatus);
         //console.log("nodes: " + network.elements.nodes.length);
         //if(typeof(network.elements.edges) != "undefined")
         //  console.log("edges: " + network.elements.edges.length);
         //if(hideEdges){
         //    console.log(" ---- hiding edges in getScript");
         //   self.cy.edges().style({"display": "none"});
         //   }
         self.cy.add(network.elements);  // no positions yet
         self.cy.nodes().map(function(node){node.data({degree: node.degree()})});
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
   var self = this;
   self.cy.edges().css({"curve-style": newMethod});

} // setEdgeRenderingMethod
//----------------------------------------------------------------------------------------------------
function bindFunctionsToSelf(rcy)
{
  setNodeColorRule.bind(rcy)
  setNodeColorLookupRule.bind(rcy)
  setNodeColorInterpolatingRule.bind(rcy)

  setNodeSizeRule.bind(rcy)
  redraw.bind(rcy)
  layout.bind(rcy)


} // bindFunctionsToSelf
//----------------------------------------------------------------------------------------------------
function demoSimpleNetwork(cy)
{
  node0 = self.cy.add({group: "nodes", data: { weight: 75, name: "A"}, position: { x: 200, y: 200 }});
  node1 = self.cy.add({group: "nodes", data: { weight: 75, name: "B"}, position: { x: 300, y: 300 }});
  self.cy.add({group: "edges", data: { id: "e0", source: node0.data("id"), target: node1.data("id")}});
  setVizmapByName("Nested Network Style");

} // demoSimpleNetwork
//----------------------------------------------------------------------------------------------------
return{
   addMessageHandlers: addMessageHandlers,
   initializeUI: initializeUI,
   setEdgeRenderingMethod: setEdgeRenderingMethod,
   bindFunctionsToSelf: bindFunctionsToSelf,
   loadStyle: loadStyle,
   hub: hub,
   addNetwork: addNetwork,
   loadStyle: loadStyle,
   getJSON: getJSON,
   getNodeCount: getNodeCount,
   getEdgeCount: getEdgeCount,
   createCytoscapeWindow: createCytoscapeWindow
   };

}); // RCyjsModule
//----------------------------------------------------------------------------------------------------
var rcy = RCyjs(hub);
hub.init();
rcy.addMessageHandlers()
hub.addOnDocumentReadyFunction(rcy.initializeUI.bind(rcy));
rcy.bindFunctionsToSelf(rcy)
hub.start();
window.rcy = rcy;
window.hub = hub;
