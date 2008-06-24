/**
 * @author Jefferson
 */

function init() {
	
	removeStyleAttribute();
	addOnClickEventToNodes();
	fitToArea();
}

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

function nodeClicked(thisNode) {

	if (thisNode.getAttribute("class") == "clicked") {
		thisNode.setAttribute("class", "");
	}
	else {
		contents = thisNode.getElementsByTagName("text")[0].firstChild.data;
		thisNode.setAttribute("class", "clicked");
	}
}

function removeStyleAttribute(){
	var alltags = document.getElementsByTagName("*");
	
	for (var i = 0; i < alltags.length; i++) {
		elem = alltags[i];
		if (elem.hasAttribute) {
			elem.removeAttribute("style");
		}
	}
}

function zoom(k) {
	
	var graph = document.getElementById("graph0");
	transformAttr = graph.getAttribute("transform");
	value1 = transformAttr.substring(transformAttr.indexOf("(") + 1, transformAttr.indexOf(" ") - 1);
	value2 = transformAttr.substring(transformAttr.indexOf(" ") + 1, transformAttr.indexOf(")"));	
	others = transformAttr.substring(transformAttr.indexOf(")") + 1), transformAttr.length - 1;
	value1 = value1 * k;
	value2 = value2 * k;
	graph.setAttribute("transform", "scale(" + value1 + " " + value2 + ") " + others);
}

function fitToArea() {
	
	var svgTag = document.getElementsByTagName("svg")[0];
	svgTag.setAttribute("width", "800px");
	svgTag.setAttribute("height", "400px");
	svgTag.setAttribute("viewBox", "0 0 2400 1200");
	svgTag.setAttribute("preserveAspectRatio", "none");
}
	
function setContextMenu(node) {
	ContextMenu.set("node-menu", node.id);
}

function colapse(node) {
	for (var i = 0; i < node.childNodes.length; i++) {
		current = node.childNodes[i];
		alert(current.nodeName);		
		current.setAttribute("class", "colapsed");
	}	
}

function expand(node) {
	
}

function pan(k1,k2) {

	root=document.getElementsByTagName("svg")[0];
	var old_value=root.currentScale;
	if (k1!=0) 	{
		old_x=root.currentTranslate.x;
		x=old_x + k1 * 20;
		root.currentTranslate.x=x;
	}
	else {
		old_y=root.currentTranslate.y;
		y=old_y + k2 * 20;
		root.currentTranslate.y=y;
	}
}
	
function reset() {

	root=document.getElementsByTagName("svg")[0];
	root.currentTranslate.x=0;
	root.currentTranslate.y=0;
	root.currentScale=1;
}

