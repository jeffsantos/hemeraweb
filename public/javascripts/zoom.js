//					ZOOM AND PAN WITH AUTOZOOM AND REAL TIME PAN OPTIONS
//                                v 1.2  
/*
Copyright (C) 2004  Domenico Strazzullo
nst@dotuscomus.com
Modified by Geoff Whale (GRW) G.Whale@unsw.edu.au 2007-09-07
See README.txt for details

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License at http://www.gnu.org/copyleft/gpl.html for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

//-----------------------------------------------------
//DECLARATIONS AREA
//-----------------------------------------------------
var svgNS = "http://www.w3.org/2000/svg";
var url;
var newdocId;
var map;              												// where the new document is loaded
var panload;          												// where the new document is cloned in the map navigator
var rtp;			  												// real time pan
var az;				  												// autozoom
var first;
var loop;    		  												// for autozoom
var nav_x;
var nav_y;
var nav_w;
var nav_h;
var width_vb_ratio;
var height_vb_ratio;
var doc_vb_ratio;	  												// GRW: viewbox to width ratio of original map
var disp_aspect;	  												// GRW: aspect ratio of viewing area (map or pan)
var w_prop;
var area;
var Sides;			  												// the sum of width and height
var wSide;
var hSide;
var Step;			  												// copy of active type of zoom array to work with
var s;				  												// index for above
var rect2sq_ratio;	  												// ratio with square of equivalent perimeter 
var propW;			  												// relating to main viewbox
var propH;			  												// relating to main viewbox
var pan_boxX;
var pan_boxY;
var pan_boxW;
var pan_boxH;
var lens;
var offsetX;
var offsetY;
var z_dir;
var loopX;
var loopY;
var evtX;
var evtY;
var lensX;
var lensY;
var lensW;
var lensH;

// -----------------------------------------------------
// original list of IDs in the SVG document used by this script:
// "main","map","lens","zoom_value","pan","panload","az","rtp"
//
// personal list of IDs in the SVG document used by this script:
// "proof"
// --------------------------------------------------

//-----------------------------------------------------
//GLOBAL AREA
//-----------------------------------------------------
// Create two arrays, one for regular and one for auto zoom.
// Array with regular zoom preset values. Change to any values you wish. These values act as surface area multipliers.
var zmArray = [1,2,3,4,6,10,20,50,100,180];
// This fills autozoom array with finely incremented values.
a_val = 1;															// base value
a_fac = 1.01;														// base value multiplier
var a_zmArray = [1];												// first element set to 1 (no zoom)
// with 67 loops result yelds 180 approx. You can use any figure, just don't lose your magnifying glass by making it too small and unusable!
for(i = 1; i < 68; i ++) {
	a_fac += 0.0021;												// arbitrary
	a_val = a_val * a_fac;
	a_zmArray[i] = Number(a_val.toFixed(2));
}
// We want it to look neat, so we only use the integer portion of the last element (180).
a_zmArray[a_zmArray.length - 1] = parseInt(a_zmArray[a_zmArray.length - 1]);

//-----------------------------------------------------
// FUNCTIONS AREA
//-----------------------------------------------------
//This function was changed from its original version
//to use the custom code added in this script
function init (evt) {
	svgdoc = evt.target.ownerDocument;
	main = svgdoc.getElementById("proofarea");
	map = svgdoc.getElementById("map");
	panload = svgdoc.getElementById("panload");
// read svg viewbox values, used for resize.
	var main_viewbox = svgdoc.getElementById("proofarea").getAttributeNS(null,"viewBox").split(" ");
	propW = Number(main_viewbox[2]);
	propH = Number(main_viewbox[3]);
	pan_boxX = svgdoc.getElementById("pan").getAttributeNS(null,"x");
	pan_boxY = svgdoc.getElementById("pan").getAttributeNS(null,"y");
	pan_boxW = svgdoc.getElementById("pan").getAttributeNS(null,"width");
	pan_boxH = svgdoc.getElementById("pan").getAttributeNS(null,"height");
	lens = svgdoc.getElementById("lens");
	rtp = false;
	az = false;
	first = true;
	Step = zmArray;
	reset();
	fitToArea();
	embedDoc(evt);
}

function load_svg(evt,url) {
	if (window.getURL) {
		getURL(url,getURLCallback);
		function getURLCallback(data) {
			if(data.success) {
			var node = parseXML(data.content, document);
			addDoc(evt,node.firstChild);
			}
		}
	}
	else if (window.XMLHttpRequest) {
		function gemi_XMLHttpRequestCallback() {
			if (xmlRequest.readyState == 4) {
				if (xmlRequest.status == 200 || xmlRequest.status == 0) {
					addDoc(evt,document.importNode(xmlRequest.responseXML.documentElement,true));
				}
			}
		}
		var xmlRequest = null;
		xmlRequest = new XMLHttpRequest();
		xmlRequest.overrideMimeType("text/xml");
		xmlRequest.open("GET",url,true);
		xmlRequest.onreadystatechange = gemi_XMLHttpRequestCallback;
		xmlRequest.send(null);
	}
}

// Replacement of previously loaded document (if any) takes place here
// GRW: allow for preliminary child nodes such as comments or xml-stylesheets
function addDoc(evt,node) {
	var child = map.childNodes;
	if (child.length > 0) map.removeChild(child.item(0));
	child = panload.childNodes;
	if (child.length > 0) panload.removeChild(child.item(0));
  
	var newdoc = node;
	while (newdoc != null && newdoc.nodeName != "svg") {
		newdoc = newdoc.nextSibling;
	}
	if (newdoc == null) {											// no point in proceeding
		alert("Cannot find <svg> element in " + node.parent.nodeName);
		return;
	}
	map.appendChild(newdoc);
	
	newdocId = newdoc.getAttributeNS(null,"id");
	newdocId = (newdocId != "") ? newdocId : "Untitled";
	newdoc.setAttributeNS(null,"id",newdocId);
	var doc_clone = newdoc.cloneNode(true);
	panload.appendChild(doc_clone);
	set_pan_viewbox(evt);
	zoom('org');
}

//-----------------------------------------------------
//BEGIN CUSTOMIZATION
//-----------------------------------------------------
function fitToArea() {
	var proofArea = svgdoc.getElementById("proof");
	
	var docW = Number(map.getAttributeNS(null,"width"));
	var docH = Number(map.getAttributeNS(null,"height"));	
	proofArea.setAttributeNS(null, "width", docW);
	proofArea.setAttributeNS(null, "height", docH);
	
	var ratio = docW/docH;
	var proof_viewbox = proofArea.getAttributeNS(null,"viewBox");
	proof_viewbox = proof_viewbox.split(" ");
	var w = Number(proof_viewbox[2]);
	var h = Number(proof_viewbox[3]);
	
	if(w < docW)
		w = docW;
	var newW = w;
	var newH = w/ratio;
	if(newH < h) {
		newW = h*ratio;
		newH = h;
	}
	
	proof_viewbox = "0 0 " + newW.toString() + " " + newH.toString();
	proofArea.setAttributeNS(null, "viewBox", proof_viewbox);
}

function embedDoc(evt) {
	var newdoc = svgdoc.getElementById("proof");
	newdocId = newdoc.getAttributeNS(null,"id");
	newdocId = (newdocId != "") ? newdocId : "Untitled";
	newdoc.setAttributeNS(null,"id",newdocId);	
	var doc_clone = newdoc.cloneNode(true);
	panload.appendChild(doc_clone);
	set_pan_viewbox(evt);
	zoom('org');
}
//-----------------------------------------------------
//END CUSTOMIZATION
//-----------------------------------------------------

function set_pan_viewbox(evt) {
	var map_doc = svgdoc.getElementById(newdocId);
	var docW = Number(map_doc.getAttributeNS(null,"width"));
	var docH = Number(map_doc.getAttributeNS(null,"height"));
	var map_viewbox = map_doc.getAttributeNS(null,"viewBox");
	if (map_viewbox == "" || map_viewbox == null) {
		map_viewbox = "0 "+"0 "+ docW +" "+ docH;
		map_doc.setAttributeNS(null,"viewBox",map_viewbox);
	}
	svgdoc.getElementById("pan").setAttributeNS(null,"viewBox",map_viewbox);	
	
// we will also need the individual values of the viewbox 
	map_viewbox = map_viewbox.split(" ");
	nav_x = Number(map_viewbox[0]);
	nav_y = Number(map_viewbox[1]);
	nav_w = Number(map_viewbox[2]);
	nav_h = Number(map_viewbox[3]);
// nav_* are the viewport dimensions from the original map,
// adjusted so they're expressed in pixels, but not scaled.

// GRW: can't assume viewbox uses same units as wid/ht
	doc_vb_ratio = nav_w / docW;
	set_scale("panload", doc_vb_ratio);
	set_scale("lensxf", doc_vb_ratio);
	nav_w /= doc_vb_ratio;											// now screen units
	nav_h /= doc_vb_ratio;
	doc_aspect = nav_w / nav_h;
	disp_aspect = (svgdoc.getElementById("map").getAttributeNS(null,"width")) / (svgdoc.getElementById("map").getAttributeNS(null,"height"));

	width_vb_ratio = nav_w / pan_boxW;
	height_vb_ratio = nav_h / pan_boxH;

/*
w_prop establishes the proportion of the lens width in respect to the rectangle's (lens) width+height (Sides[]). 
Since we chose the zoom to take into account surface area for enlargment/reduction rather then width, to simulate 
analog optical appliances, we convert the rectangle into a square of equivalent perimeter, then get the ratio 
between rectangle's and square areas (rect2sq_ratio), and finally convert it back to a rectangle using w_prop.
*/
	w_prop = nav_w / (nav_w + nav_h);
	area = nav_w * nav_h;
	Sides = [nav_w + nav_h];										// initial default value stored in array 
	wSide = [nav_w];												// make arrays for precalculated widths and heights also
	hSide = [nav_h];
	rect2sq_ratio = area / Math.pow((Sides[0]) / 2,2);
	zoom_set(evt);
}

function zoom_switch(evt,f) {
  var fill;
	if(f == "rtp") {
		rtp ? rtp = false : rtp = true;								// switching real time pan on and off
		var a = rtp;												// for setting real time pan and autozoom selection button fill-opacity
	}
	else if(f == "az") {
		az ? az = false : az = true;								// switching autozoom on and off
		az ? Step = a_zmArray : Step = zmArray;						// point to appropriate array
		s = 0;														// acts as zoom array index pointer. First value in array is zoom default
		var a = az;	
		if(first == false) {
			zoom_set(evt);											// for setting real time pan and autozoom selection button fill-opacity
		}
	}
	a ? fill = "#b8b8b8" : fill = "#ffffff";
	svgdoc.getElementById(f).setAttributeNS(null,"fill",fill);
}

function zoom_set(evt) {
	first = false;
	for(i = 1; i < Step.length; i ++) {
// calculate new lens area according to the value of the next magnitude Step, then convert into a square of eqivalent perimeter using rect2sq_ratio. 
// get the square's two sides sum and store result into Sides[] array. Then store the sides values.
		Sides[i] = Math.sqrt((area * (Step[0] / Step[i])) / rect2sq_ratio) * 2;
		wSide[i] = Sides[i] * w_prop;
		hSide[i] = Sides[i] - wSide[i];

// GRW: adjust zoom to reflect aspect ratio differences
		if (wSide[i] / hSide[i] < disp_aspect) {
			wSide[i] = Math.min(nav_w, hSide[i]*disp_aspect);
		} else if (wSide[i] / hSide[i] > disp_aspect) {
			hSide[i] = Math.min(nav_h, wSide[i]/disp_aspect);
		}
	}
// reset the zoom lens rect attributes on switching from regular to auto and viceversa.
	setCoor(nav_x,nav_y,nav_w,nav_h);
	svgdoc.getElementById("zoom_value").firstChild.data = Step[0];
}

function zoom(in_out) {
	if (first) return;												// user clicked zoom before anything is loaded
	z_dir = in_out;
	if(in_out == "org") s = 0;										//back to 1 value
	else {
// increments or decrements array index and prevents overflow
		(in_out == "in") ? s += 1 * (s < Step.length - 1) : s -= 1 * (s > 0);
	}
	getCoor();														// get current coordinates and calculate the new ones
	lensX += ((lensW - wSide[s]) / 2);								// convert back to rectangle
	lensY += ((lensH - hSide[s]) / 2);
	if (s == 0) {
		lensX = nav_x;
		lensY = nav_y;
	}
	setCoor(lensX,lensY,wSide[s],hSide[s]);
	svgdoc.getElementById("zoom_value").firstChild.data = Step[s];
	if(az && in_out != "org") loop = setTimeout('zoom(z_dir)',40);
}

// comments unfinished

function enable_drag(evt,grab) {
	getCoor();
	if(grab) {
		svgdoc.getElementById("dragarea").setAttributeNS(null,"pointer-events","all");
		getEvt(evt);
		offsetX = (evtX * ratio - pan_boxX) * width_vb_ratio - lensX;
		offsetY = (evtY * ratio - pan_boxY) * height_vb_ratio - lensY;
	}
	else {
		svgdoc.getElementById("dragarea").setAttributeNS(null,"pointer-events","none");
		setCoor(lensX,lensY,lensW,lensH);
	}
}
function pan(evt) {
	getEvt(evt);
	lensX = (evtX * ratio - pan_boxX) * width_vb_ratio - offsetX;
	lensY = (evtY * ratio - pan_boxY) * height_vb_ratio - offsetY;
	if (lensX < nav_x) {
		lensX = nav_x;
	}
	else if ((lensX) > (nav_w - lensW)) {
		lensX = nav_w - lensW;
	}
	if (lensY < nav_y) {
		lensY = nav_y;
	}
	else if ((lensY) > (nav_h - lensH)) {
		lensY = nav_h - lensH;
	}
	lens.setAttributeNS(null,"x",lensX);
	lens.setAttributeNS(null,"y",lensY);
	if(rtp) svgdoc.getElementById("map").setAttributeNS(null,"viewBox",lensX + " " + lensY + " " + lensW + " " + lensH);
}
function arrowPan(x,y) {
	getCoor();
	lensX += x;
	lensY += y;
	if (lensX < nav_x) {
		lensX = nav_x;
	}
	else if ((lensX) > (nav_w - lensW)) {
		lensX = nav_w - lensW;
	}
	if (lensY < nav_y) {
		lensY = nav_y;
	}
	else if ((lensY) > (nav_h - lensH)) {
		lensY = nav_h - lensH;
	}
	setCoor(lensX,lensY,lensW,lensH);
	loopX = x;
	loopY = y;
	loop = setTimeout('arrowPan(loopX,loopY)', 40);
}
function reset() {
	var w = window.innerWidth;
	var h = window.innerHeight;
	win_ratio = w / h;
	vBox_ratio = propW / propH;
	if(win_ratio >= vBox_ratio) ratio = propH / h;
	else ratio = propW / w;
}
function getEvt(evt) {
	evtX = parseFloat(evt.clientX);
	evtY = parseFloat(evt.clientY);
}
function getCoor() {
	lensX = parseFloat(lens.getAttributeNS(null,"x"));
	lensY = parseFloat(lens.getAttributeNS(null,"y"));
	lensW = parseFloat(lens.getAttributeNS(null,"width"));
	lensH = parseFloat(lens.getAttributeNS(null,"height"));
}
function setCoor(a,b,c,d) {
	lens.setAttributeNS(null,"x",a);
	lens.setAttributeNS(null,"y",b);
	lens.setAttributeNS(null,"width",c);
	lens.setAttributeNS(null,"height",d);
	svgdoc.getElementById("map").setAttributeNS(null,"viewBox",a + " " + b + " " + c + " " + d);
}
function stopauto() {
	if(loop != null) clearTimeout (loop);
}

// GRW: rescale reference thumbnail to match original image
function set_scale(id,scale) {
	var elm = svgdoc.getElementById(id);
	elm.setAttributeNS(null, "transform", "scale(" + scale + ")");
}

function rectangle(id,x,y,rx,ry,w,h,f,s,sw,op,sr) {
	var e = svgdoc.createElementNS(svgNS,"rect");
	e.setAttributeNS(null,"id",id);
	e.setAttributeNS(null,"x",x);
	e.setAttributeNS(null,"y",y);
	e.setAttributeNS(null,"rx",rx);
	e.setAttributeNS(null,"ry",ry);
	e.setAttributeNS(null,"width",w);
	e.setAttributeNS(null,"height",h);
	e.setAttributeNS(null,"fill",f);
	e.setAttributeNS(null,"stroke",s);
	e.setAttributeNS(null,"stroke-width",sw);
	e.setAttributeNS(null,"opacity",op);
	e.setAttributeNS(null,"shape-rendering",sr);
	return e;
}
function text(id,x,y,ff,fs,fw,fst,ta,pe,tn,tr,fl) {
	var e = svgdoc.createElementNS(svgNS,"text");
	e.setAttributeNS(null,"id",id);
	e.setAttributeNS(null,"x",x);
	e.setAttributeNS(null,"y",y);
	e.setAttributeNS(null,"fill",fl);
	e.setAttributeNS(null,"font-family",ff);
	e.setAttributeNS(null,"font-size",fs);
	e.setAttributeNS(null,"font-weight",fw);
	e.setAttributeNS(null,"font-style",fst);
	e.setAttributeNS(null,"text-anchor",ta);
	e.setAttributeNS(null,"text-rendering",tr);
	e.setAttributeNS(null,"pointer-events",pe);
	var tNode = svgdoc.createTextNode(tn);
	e.appendChild(tNode);
	return e;
}