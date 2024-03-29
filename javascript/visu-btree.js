// ************** Generate the tree diagram	 *****************
function update(source) {
    var i = 0;
    d3.select("svg").remove();
    var margin = { top: 100, right: 120, bottom: 20, left: 400 },
        width = 960 - margin.right - margin.left,
        height = 500 - margin.top - margin.bottom;

    var tree = d3.layout.tree()
        .size([height, width]);

    var diagonal = d3.svg.diagonal()
        .projection(function (d) { return [d.x, d.y]; });

    var svg = d3.select(".svg").append("svg")
        .attr("width", width + margin.right + margin.left)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
        
    // Compute the new tree layout.
    var nodes = tree.nodes(root).reverse(),
        links = tree.links(nodes);

    // Normalize for fixed-depth.
    nodes.forEach(function (d) { d.y = d.depth * 100; });

    // Declare the nodes…
    var node = svg.selectAll("g.node")
        .data(nodes, function (d) { return d.id || (d.id = ++i); });

    // Enter the nodes.
    var nodeEnter = node.enter().append("g")
        .attr("class", "node")
        .attr("transform", function (d) {
            return "translate(" + d.x + "," + d.y + ")";
        });

    nodeEnter.append("circle")
        .attr("r", 10)
        .style("fill", "#fff")
        .style("stroke",function (d) {            
            if(d.draw){
                return "red";
            } 
            return "steelblue";
        });

    nodeEnter.append("text")
        .attr("y", function (d) {
            return d.children || d._children ? -18 : 18;
        })
        .attr("dy", ".35em")
        .attr("text-anchor", "middle")
        .text(function (d) { return d.name; })
        .style("fill-opacity", 1);

    // Declare the links…
    var link = svg.selectAll("path.link")
        .data(links, function (d) { return d.target.id; });

    // Enter the links.
    link.enter().insert("path", "g")
        .attr("class", "link")
        .attr("d", diagonal);

}