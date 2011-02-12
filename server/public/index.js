(function() {
  var Graph, Renderer, addChild, deselectFunc, getAndAddChildren, nodes, pS, removeFrom, removeNodeTree, removeParent, selectFunc, selected, sys;
  selectFunc = function() {};
  deselectFunc = function() {};
  sys = {};
  selected = [];
  getAndAddChildren = function() {};
  addChild = function() {};
  removeNodeTree = function() {};
  removeParent = function() {};
  nodes = {};
  window.dump = function() {
    console.log("selected: ");
    console.log(selected);
    console.log("nodes: ");
    return console.log(nodes);
  };
  removeFrom = function(item, arr) {
    var elem, newArr, _i, _len;
    newArr = [];
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      elem = arr[_i];
      if (elem !== item) {
        newArr.push(elem);
      }
    }
    return newArr;
  };
  Graph = (function() {
    function Graph(id) {
      var r;
      this.id = id;
      sys = this.sys = arbor.ParticleSystem(500, 2000, 0.5);
      this.sys.parameters = {
        gravity: true
      };
      selected = this.selected = [];
      r = new Renderer(this.id);
      r.initMouseHandling();
      this.sys.renderer = r;
    }
    Graph.prototype.addRandNodes = function(parent) {
      if (parent == null) {
        parent = void 0;
      }
      addChild('a', [], true);
      return addChild('b', ['a']);
    };
    Graph.prototype.addNode = function(name) {
      return addChild(name, []);
    };
    Graph.prototype.addChild = function(name, parentNames, root) {
      var data, node, parent, parentName, _i, _len;
      if (root == null) {
        root = false;
      }
      if (!(name in nodes)) {
        data = {
          selected: root,
          parents: parentNames,
          children: []
        };
        if (root) {
          selected.push(name);
        }
        node = sys.addNode(name, data);
        if (parentNames.length > 0) {
          for (_i = 0, _len = parentNames.length; _i < _len; _i++) {
            parentName = parentNames[_i];
            sys.addEdge(parentName, name);
            parent = nodes[parentName];
            parent.data.children.push(name);
          }
        }
        return nodes[name] = node;
      }
    };
    Graph.prototype.getAndAddChildren = function(parents) {
      return getIngredients(parents, function(nC) {
        var child, _i, _len, _results;
        console.log(nC);
        _results = [];
        for (_i = 0, _len = nC.length; _i < _len; _i++) {
          child = nC[_i];
          _results.push(addChild(child, parents));
        }
        return _results;
      });
    };
    Graph.prototype.selectNode = function(name) {
      nodes[name].data.selected = true;
      selected.push(name);
      getAndAddChildren(selected);
      return getAndAddChildren([name]);
    };
    Graph.prototype.deselectNode = function(name) {
      var child, childName, _i, _len, _ref;
      selected = removeFrom(name, selected);
      _ref = nodes[name].data.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        childName = _ref[_i];
        child = nodes[childName];
        if (!child.data.selected) {
          if (child.data.parents.length === 1) {
            removeNodeTree(childName);
          } else {
            removeParent(child, name);
          }
        }
      }
      return nodes[name].data.children = [];
    };
    Graph.prototype.removeParent = function(child, parentName) {
      return child.data.parents = removeFrom(parentName, child.data.parents);
    };
    Graph.prototype.removeNodeTree = function(name) {
      var child, children, _i, _len, _results;
      children = nodes[name].data.children;
      sys.pruneNode(name);
      nodes[name] = void 0;
      _results = [];
      for (_i = 0, _len = children.length; _i < _len; _i++) {
        child = children[_i];
        _results.push(removeNodeTree(child));
      }
      return _results;
    };
    return Graph;
  })();
  pS = {};
  Renderer = (function() {
    function Renderer(id) {
      this.id = id;
      this.canvas = $('#' + this.id).get(0);
    }
    Renderer.prototype.init = function(system) {
      pS = this.pS = system;
      this.pS.screenSize(this.canvas.width, this.canvas.height);
      return this.pS.screenPadding(80);
    };
    Renderer.prototype.redraw = function() {
      var ctx;
      ctx = this.canvas.getContext('2d');
      ctx.fillStyle = 'white';
      ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
      this.pS.eachEdge(function(edge, p1, p2) {
        ctx.strokeStyle = "rgba(0,0,0,0.333)";
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(p1.x, p1.y);
        ctx.lineTo(p2.x, p2.y);
        return ctx.stroke();
      });
      return this.pS.eachNode(function(node, p) {
        ctx.fillStyle = node.data.selected ? "orange" : "white";
        ctx.beginPath();
        ctx.arc(p.x, p.y, 30, 0, 360);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
        ctx.fillStyle = "black";
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        return ctx.fillText(node.name, p.x, p.y);
      });
    };
    Renderer.prototype.initMouseHandling = function() {
      var mousedown, mouseup;
      mousedown = function(e) {
        var node, pos, _mouseP;
        pos = $('canvas').offset();
        _mouseP = arbor.Point(e.pageX - pos.left, e.pageY - pos.top);
        this.target = pS.nearest(_mouseP);
        if (this.target && this.target.node) {
          node = this.target.node;
          node.fixed = true;
          if (node.data.selected && selected.length >= 2) {
            node.data.selected = false;
            deselectFunc(node.name);
          } else if (!node.data.selected) {
            node.data.selected = true;
            selectFunc(node.name);
          }
        }
        $(window).bind('mouseup', mouseup);
        return false;
      };
      mouseup = function(e) {
        var _ref;
        if ((_ref = this.dragged) != null) {
          _ref.node.fixed = false;
        }
        this.dragged = void 0;
        $(window).unbind('mouseup');
        return false;
      };
      return $(this.canvas).mousedown(mousedown);
    };
    return Renderer;
  })();
  $(document).ready(function() {
    var g;
    $('canvas').attr('width', $(window).width() - 300);
    $('canvas').attr('height', $(window).height());
    g = new Graph("viewport");
    selectFunc = g.selectNode;
    deselectFunc = g.deselectNode;
    getAndAddChildren = g.getAndAddChildren;
    addChild = g.addChild;
    removeNodeTree = g.removeNodeTree;
    removeParent = g.removeParent;
    $('#button').click(function() {
      var val;
      val = $('#field').val();
      $('#field').val('');
      addChild(val, [], true);
      getAndAddChildren([val]);
      if (selected.length > 1) {
        getAndAddChildren(selected);
      }
      $('ul').prepend('<li><span>' + val + '</span> <a href="#">x</a></li>');
      return false;
    });
    return $('ul li a').live('click', function() {
      var val;
      val = $(this).parent().children('span').html();
      console.log('deleting: ');
      console.log(val);
      deselectFunc(val);
      $(this).parent().remove();
      return false;
    });
  });
}).call(this);
