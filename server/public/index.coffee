selectFunc = ->
deselectFunc = ->
sys = {}
selected = []
getAndAddChildren = ->
addChild = ->
removeNodeTree = ->
removeParent = ->
nodes = {}

window.dump = ->
	console.log("selected: ")
	console.log(selected)
	console.log("nodes: ")
	console.log(nodes)

removeFrom = (item,arr) ->
	newArr = []
	for elem in arr
		if elem != item
			newArr.push(elem)
	newArr

class Graph
	constructor: (@id) ->
		sys = @sys = arbor.ParticleSystem(800,2000,0.5)
		@sys.parameters = {gravity:true}
		selected = @selected = []
		r = new Renderer(@id)
		r.initMouseHandling()
		@sys.renderer = r
	addRandNodes: (parent = undefined) ->
		addChild('a',[],true)
		addChild('b',['a'])
	addNode: (name) ->
		addChild(name,[])
	addChild: (name,parentNames,root=false) ->
		if !(name of nodes)
			data = {selected:root,parents:parentNames,children:[]}
			if root then selected.push(name)
			node = sys.addNode(name,data)
			if parentNames.length > 0
				for parentName in parentNames
					sys.addEdge(parentName,name)
					parent = nodes[parentName]
					parent.data.children.push(name)
			nodes[name] = node
		if name of nodes and root then nodes[name].data.selected = true
	getAndAddChildren: (parents) ->
		getIngredients(parents,(nC) -> 
			console.log(nC)
			addChild(child,parents) for child in nC
			)
	selectNode: (name) ->
		nodes[name].data.selected = true
		selected.push(name)
		getAndAddChildren(selected)
		getAndAddChildren([name])
	deselectNode: (name) ->
		selected = removeFrom(name,selected)
		for childName in nodes[name].data.children
			child = nodes[childName]
			if !child.data.selected
				if child.data.parents.length == 1
					removeNodeTree(childName)
				else
					removeParent(child,name)
		nodes[name].data.children = []
	removeParent: (child,parentName) ->
		child.data.parents = removeFrom(parentName,child.data.parents)
	removeNodeTree: (name) ->
		children = nodes[name].data.children
		sys.pruneNode(name)
		delete nodes[name]
		for child in children
			removeNodeTree(child)

pS = {}
class Renderer
	constructor: (@id) ->
		@canvas = $('#'+@id).get(0)
	init: (system) ->
		pS = @pS = system
		@pS.screenSize(@canvas.width,@canvas.height)
		@pS.screenPadding(80)
	# does the actual graph drawing
	redraw: () ->
		ctx = @canvas.getContext('2d')
		ctx.fillStyle = 'white'
		ctx.fillRect(0,0,@canvas.width,@canvas.height)
		# draw edges
		@pS.eachEdge((edge,p1,p2) ->
			ctx.strokeStyle = "rgba(0,0,0,0.333)"
			ctx.lineWidth = 1
			ctx.beginPath()
			ctx.moveTo(p1.x,p1.y)
			ctx.lineTo(p2.x,p2.y)
			ctx.stroke()
			)

		# draw nodes
		@pS.eachNode((node,p) ->
			ctx.fillStyle = if node.data.selected then "orange" else "white"
			ctx.beginPath()
			ctx.arc(p.x,p.y,30,0,360)
			ctx.closePath()
			ctx.fill()
			ctx.stroke()
			ctx.fillStyle = "black"
			ctx.textAlign = "center"
			ctx.textBaseline = "middle"
			ctx.fillText(node.name,p.x,p.y)
			)
	# sets up click events on nodes
	initMouseHandling: () ->
		mousedown = (e) -> 
			pos = $('canvas').offset()
			_mouseP = arbor.Point(e.pageX-pos.left,e.pageY-pos.top)
			@target = pS.nearest(_mouseP)
			if @target and @target.node
				node = @target.node
				node.fixed = true
				if node.data.selected and selected.length >= 2
					node.data.selected = false
					deselectFunc(node.name)
				else if !node.data.selected
					node.data.selected = true
					selectFunc(node.name)
			$(window).bind('mouseup',mouseup)
			return false

		mouseup = (e) ->
			@dragged?.node.fixed = false
			@dragged = undefined
			$(window).unbind('mouseup')
			return false
	
		$(@canvas).mousedown(mousedown)

$(document).ready(() ->
	$('canvas').attr('width',$(window).width()-300)
	$('canvas').attr('height',$(window).height())
	g = new Graph("viewport")
	selectFunc = g.selectNode
	deselectFunc = g.deselectNode
	getAndAddChildren = g.getAndAddChildren
	addChild = g.addChild
	removeNodeTree = g.removeNodeTree
	removeParent = g.removeParent

	$('#button').click( ->
		val = $('#field').val()
		$('#field').val('')
		addChild(val,[],true)
		getAndAddChildren([val])
		if selected.length > 1 then getAndAddChildren(selected)
		$('ul').prepend('<li><span>'+val+'</span> <a href="#">x</a></li>')
		return false
		)
	$('ul li a').live('click', ->
		val = $(this).parent().children('span').html()
		console.log('deleting: ')
		console.log(val)
		deselectFunc(val)
		removeNodeTree(val)
		$(this).parent().remove()
		return false
		)
	)
