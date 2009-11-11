/**
 * graphediting.js
 */

// -----------------------------------------------------
// GENERAL FUNCTIONS
// -----------------------------------------------------
var current_g_element_id = "" 



//-----------------------------------------------------
// FUNCTIONS TO MANIPULATE THE PROOF GRAPH
// -----------------------------------------------------

/**
 * Adds on click event to proof nodes. 
 * Adds context menu to proof nodes. 
 * Sets css class to proof nodes.
 */
function configNodes() {
	var g_graph = document.getElementsByClassName("graph")[0];

	for (var i = 0; i < g_graph.childNodes.length; i++) {
		thisNode = g_graph.childNodes[i];
		if (thisNode.nodeName == "g") {
			config_g_element(thisNode);
		}
	}	
}

function config_g_element(g_element) {
	
	for (var i = 0; i < g_element.childNodes.length; i++) {
		var thisNode = g_element.childNodes[i];
		
		// Closed Goal
		if (thisNode.nodeName == "polygon") {  
			g_element.setAttribute("class", "closedGoal");	
			//g_element.setAttribute("onclick", "nodeClicked(this)");
			//setContextMenuToClosedGoalNode(g_element);
		}

		// Open Goal
		if (thisNode.nodeName == "ellipse") {
			g_element.setAttribute("class", "openGoal");
			//g_element.setAttribute("onclick", "nodeClicked(this)");
			setContextMenuToOpenGoalNode(g_element);
		}		
	}	
}

//-----------------------------------------------------
// EVENTS
// -----------------------------------------------------

function nodeClicked(thisNode) {

	if (thisNode.getAttribute("class") == "closedGoal_clicked") {
		thisNode.setAttribute("class", "closedGoal");
	}
	else if (thisNode.getAttribute("class") == "closedGoal") {
		thisNode.setAttribute("class", "closedGoal_clicked");
	}		
	else if (thisNode.getAttribute("class") == "openGoal_clicked") {
		thisNode.setAttribute("class", "openGoal");
	}
	else if (thisNode.getAttribute("class") == "openGoal") {
		thisNode.setAttribute("class", "openGoal_clicked");
	}	
}

//-----------------------------------------------------
// FUNCTIONS TO CREATE CONTEXT MENUS
// -----------------------------------------------------

function setContextMenuToClosedGoalNode(node) {
	ContextMenu.set("closed-goal-menu", node.id);
}

function setContextMenuToOpenGoalNode(node) {
	ContextMenu.set("open-goal-menu", node.id);
}

//-----------------------------------------------------
// CONTEXT MENU AJAX HANDLERS
// -----------------------------------------------------

function getRulesSuccessHandler(request) {
	changeContextMenu('rules-menu', request.responseText);
}

function applyRuleSuccessHandler(request) {
	var svg = request.responseText;
	changeSVGContent(svg);
}

function generalFailureHandler(request) {
	var notice = $('notice');
	notice.innerHTML = decodeURIComponent(request.responseText);
	notice.show();
}

//-----------------------------------------------------
//CONTEXT MENU HELPERS
//-----------------------------------------------------

function getGoal(node) {
	var goal = node.getElementsByTagName("text")[0].firstChild.data;
	current_g_element_id = node.id; //Global reference.
	return goal;	
}

function changeContextMenu(id, newContent) {
	var menu = $(id);
	var context = $(current_g_element_id);
	
	if (newContent) {
		menu.innerHTML = newContent;
	}
	
	ContextMenu.set(menu.id, context.id);	
	ContextMenu.show(menu.id, ContextMenu.left, ContextMenu.top);		
}

function backToShowRulesMenu() {
	changeContextMenu('open-goal-menu', '');	
}

function changeSVGContent(newContentStr) {
	var map = $('map');
	var proofArea = $('proofarea');
	
	var parser = new DOMParser();	
	var doc = parser.parseFromString(newContentStr, "application/xhtml+xml");	
	var newProofElement = doc.getElementById('proof');
	var oldProofElement = $('proof');	
	map.removeChild(oldProofElement);
	map.appendChild(newProofElement);	
	
	reloadSVG();
}

function reloadSVG() {
	var evt = getLastLoadEvt();
	init(evt);
	configNodes();	
}

//-----------------------------------------------------
// NOT IMPLEMENTED YET
//-----------------------------------------------------
function colapse(node) {
	for (var i = 0; i < node.childNodes.length; i++) {
		current = node.childNodes[i];		
		current.setAttribute("class", "colapsed");
	}	
}

