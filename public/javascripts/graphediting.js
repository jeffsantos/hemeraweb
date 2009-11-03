/**
 * graphediting.js
 */

// -----------------------------------------------------
// GENERAL FUNCTIONS
// -----------------------------------------------------

function initialize() {
	configNodes();
}


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
			config_G_Element(thisNode);
		}
	}	
}

function config_G_Element(g_element) {

	for (var i = 0; i < g_element.childNodes.length; i++) {
		thisNode = g_element.childNodes[i];
		
		// Closed Goal
		if (thisNode.nodeName == "polygon") {  
			g_element.setAttribute("class", "closedGoal");	
			g_element.setAttribute("onclick", "nodeClicked(this)");
			setContextMenuToClosedGoalNode(g_element);
		}

		// Open Goal
		if (thisNode.nodeName == "ellipse") {
			g_element.setAttribute("class", "openGoal");			
			g_element.setAttribute("onclick", "nodeClicked(this)");
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
// CONTEXT MENU ACTIONS
// -----------------------------------------------------

function colapse(node) {
	alert(node);
	for (var i = 0; i < node.childNodes.length; i++) {
		current = node.childNodes[i];
		alert(current.nodeName);		
		current.setAttribute("class", "colapsed");
	}	
}

