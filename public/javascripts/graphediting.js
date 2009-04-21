/**
 * graphediting.js
 */

/**
 * It initializes the svg proof. Removes any 
 * style attribute from svg xml nodes and adds
 * on click events in proof nodes.
 */
function init() {
	
	removeStyleAttribute();
	addOnClickEventToNodes();
	fitToArea();
}

/**
 * Adds on click event to proof nodes.
 */
function addOnClickEventToNodes() {
	
	var graph = document.getElementById("graph0");

	for (var i = 0; i < graph.childNodes.length; i++) {
		thisNode = graph.childNodes[i];
		if (thisNode.nodeName == "g") {
			thisNode.setAttribute("onclick", "nodeClicked(this)");
			thisNode.setAttribute("class", "");
			setContextMenu(thisNode);
		}
	}	
}

/**
 * Action to be executed when a proof node is clicked.
 * @param thisNode
 */
function nodeClicked(thisNode) {

	if (thisNode.getAttribute("class") == "clicked") {
		thisNode.setAttribute("class", "");
	}
	else {
		contents = thisNode.getElementsByTagName("text")[0].firstChild.data;
		thisNode.setAttribute("class", "clicked");
	}
}

/**
 * Removes style attribute from any svg xml node.
 * The style will be managed by css file.
 */
function removeStyleAttribute(){
	var alltags = document.getElementsByTagName("*");
	
	for (var i = 0; i < alltags.length; i++) {
		elem = alltags[i];
		if (elem.hasAttribute) {
			elem.removeAttribute("style");
		}
	}
}

/**
 * Executes zoom in an out of a proof.
 * @param k - number of units to zoom a proof
 */
function zoom(k) {
	
	var graph = document.getElementById("graph0");
	alert(graph);
	transformAttr = graph.getAttribute("transform");
	alert(transformAttr);
	if (transformAttr != null) {
		value1 = transformAttr.substring(transformAttr.indexOf("(") + 1, transformAttr.indexOf(" ") - 1);
		value2 = transformAttr.substring(transformAttr.indexOf(" ") + 1, transformAttr.indexOf(")"));
		others = transformAttr.substring(transformAttr.indexOf(")") + 1), transformAttr.length - 1;
		value1 = value1 * k;
		value2 = value2 * k;
	}
	else {
		value1 = 1.33333;
		value2 = 1.33333;
		others = "rotate(0) translate(4 140)";
		
	}
	graph.setAttribute("transform", "scale(" + value1 + " " + value2 + ") " + others);
}

/**
 * Fits the proof to the svg canvas previously defined.
 */
function fitToArea() {
	
	var svgTag = document.getElementsByTagName("svg")[0];
	svgTag.setAttribute("width", "800px");
	svgTag.setAttribute("height", "400px");
	svgTag.setAttribute("viewBox", "0 0 2400 1200");
	svgTag.setAttribute("preserveAspectRatio", "none");
}
	
/**
 * Enables context menu to a proof node.
 * @param node
 */
function setContextMenu(node) {
	ContextMenu.set("node-menu", node.id);
}

/**
 * Colapses a proof node, that is, hides all 
 * descendants of the proof node in the proof graph.
 * @param node
 */
function colapse(node) {
	for (var i = 0; i < node.childNodes.length; i++) {
		current = node.childNodes[i];
		alert(current.nodeName);		
		current.setAttribute("class", "colapsed");
	}	
}

